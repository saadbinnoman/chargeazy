class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel(
      {required this.imageAssetPath, required this.title, required this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];
  SliderModel sliderModel =
       SliderModel(imageAssetPath: "", title: '', desc: '');

  //1
  sliderModel.setDesc(
      "Charging stations are also called electric vehicle supply equipment (EVSE) and are provided in municipal parking locations by electric utility companies or at retail shopping centers by private companies. These stations provide special connectors that conform to the variety of electric charging connector standards");

  sliderModel.setTitle("EV Charging Station");
  sliderModel.setImageAssetPath("assets/images/img_3.png");

  slides.add(sliderModel);

  sliderModel =  SliderModel(imageAssetPath: "", title: '', desc: '');

  //2
  sliderModel.setDesc(
      "Electrical energy is the energy derived from electric potential energy or kinetic energy of the charged particles. In general, it is referred to as the energy that has been converted from electric potential energy.");
  sliderModel.setTitle("Electric Energy");
  sliderModel.setImageAssetPath("assets/images/img_4.png");
  slides.add(sliderModel);

  sliderModel =  SliderModel(imageAssetPath: "", title: '', desc: '');

  //3
  // sliderModel.setDesc(
  //     "You can create group or community of your farmers or community in your city.And you can also trade, lend, buy, or share any goods with other people");
  // sliderModel.setTitle("Bid system");
  // sliderModel.setImageAssetPath("assets/images/splash3.png");
  // slides.add(sliderModel);
  //
  // sliderModel = new SliderModel(imageAssetPath: "", title: '', desc: '');

  return slides;
}
