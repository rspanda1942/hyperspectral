function patches = normalize(patches)

abc=sum(patches.*patches).^0.5;
patches = bsxfun(@rdivide, patches, abc);