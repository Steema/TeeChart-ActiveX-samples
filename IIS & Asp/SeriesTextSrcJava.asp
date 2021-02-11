<!--METADATA NAME="TeeChart Pro v2021 ActiveX Control" TYPE="TypeLib" UUID="{DE7847A7-A266-4AA9-AA68-16676652C9DB}"-->
<%@ LANGUAGE="JavaScript" %>

<%
  //***************************************************************
  // Script starting point. Run script with no parameters to create
  // The page that recalls the script to obtain the Chart.
  //***************************************************************

  if (Request.QueryString('CreateChart')==1){
    RunChart();
  }
  else{
    CreatePage();
  }

  function RunChart(){
    var TChart1;
    var SeriesTextSource1;
    var FolderStr;
    var AppPath;

    TChart1=Server.CreateObject('TeeChart.TChart');
    SeriesTextSource1 = Server.CreateObject('TeeChart.SeriesTextSource');

    // Set some Chart display characteristics
    TChart1.Aspect.Orthogonal=false;
    TChart1.Aspect.Rotation=345;
    TChart1.Aspect.Elevation=345;
    TChart1.Aspect.Perspective=37;
    TChart1.Aspect.Zoom=80;
    TChart1.Aspect.Chart3DPercent=60;
    TChart1.Legend.Visible=false;
    TChart1.Width=500;
    TChart1.Height=350;
    TChart1.Panel.Gradient.Visible=true;
    TChart1.Axis.Depth.Visible=true;
    TChart1.Axis.Left.Increment = 0.4;

    TChart1.AddSeries(scSurface);
    TChart1.Series(0).asSurface.IrregularGrid=true;

    //***************************************************************
    // AddField first param refers to the Series ValueList name
    // The AIndex refers to the Column index of the text file
    // beginning with Column 1
    //***************************************************************
    SeriesTextSource1.AddField('X', 1);
    SeriesTextSource1.AddField('Y', 2);
    SeriesTextSource1.AddField('Z', 3);

    //***************************************************************
    // We found that APPL_PHYSICAL_PATH returned different paths on
    // different operating platforms! So, just in case, check the path
    // to import the Series text data file .....
    //***************************************************************
    // +'**' used to convert FolderStr to string type (there must be
    // a better way!).
    // In case you use physical path from wwwroot then
    // FolderStr=Request.Servervariables('APPL_PHYSICAL_PATH')+'**';

     FolderStr = Server.MapPath("/TeeChartAX/") + '\**';

    if (FolderStr.indexOf('TeeChartAX')>0) {
      FolderStr=PreparePath(FolderStr);
    }
    else {
      FolderStr=PreparePath(FolderStr) + '\\\\';
    }

    // This just checks to see how the decimal separator is setup on your
    // server then selects the appropriate format file.
    if (TChart1.Environment.DecimalSeparator==',') {
      SeriesTextSource1.FileName = FolderStr + 'SampleData.txt'
    }
    else {
      SeriesTextSource1.FileName = FolderStr + 'SampleDataPoint.txt'
    }

    //***************************************************************
    // Activate data source for the Series
    //***************************************************************
    SeriesTextSource1.FieldSeparator=';';
    SeriesTextSource1.Series = TChart1.Series(0);
    SeriesTextSource1.Active = true;

    //***************************************************************
    // Export Chart
    //***************************************************************
    Response.BinaryWrite(TChart1.Export.asPNG.SaveToStream());
  }

  function PreparePath(Instr){
      Instr = Instr.replace('**','');
      while (Instr.indexOf('\\')>0){
          Instr = Instr.replace('\\','**');
      }
      while (Instr.indexOf('**')>0){
        Instr = Instr.replace('**','\\\\');
      }
     return(Instr);
  }

  function CreatePage(){
    Response.Expires = 0;
    Response.Write('<html>');
    Response.Write('<HEAD><title>TeeChart Pro AX Control- importing serverside text files with JScript</title>');
    Response.Write('<LINK REL=STYLESHEET TYPE=\'text/css\' HREF=\'Style.css\'></HEAD><BODY>');
    Response.Write('<img src=\'TeeChartAX300x66.jpg\'>');
    Response.Write('<br><br>');
    Response.Write('<a href=\'ASPHome.htm\'>Back to Contents page</a>');
    Response.Write('<hr>');
    Response.Write('<img id=Img1 src=\'SeriesTextSrcJava.asp?CreateChart=1\'>');
    Response.Write('<HR>Copyright (c) 2021 Steema Software SL</BODY></HTML>');
    Response.Write('</body>');
    Response.Write('</html>');
  }
%>

