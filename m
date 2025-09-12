Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7C1CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 20:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F388E0006; Fri, 12 Sep 2025 16:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0DDB8E0002; Fri, 12 Sep 2025 16:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFCED8E0006; Fri, 12 Sep 2025 16:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B21A58E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:40:40 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3428F11B08B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:40:40 +0000 (UTC)
X-FDA: 83881766640.15.F73F9BE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70694100017
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 20:40:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SKBA1QL6;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757709638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=GkQyydKle2Ur2rRQ+ZFRyFgS6ECCnnchdf69h3nuARI=;
	b=5i3RnhFPgfPC7fwEQcVxz+LD4KdNry4gkpLrdAkvO/hvI88xYINdFnCHalxXmLwhgUl/c3
	DnfptS2JNg+H0gtEPMoipCPM3LGZ+i7gLaA202fFwNCzARorHJaq+bfuSAgiBY5MWjtIJb
	8ZTRCnWpCix2MAzvG+s2IHMHB84yekc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SKBA1QL6;
	spf=pass (imf05.hostedemail.com: domain of lkp@intel.com designates 198.175.65.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757709638; a=rsa-sha256;
	cv=none;
	b=ycZKW9wi9l75C52Ahz34oLI6axyXl0mNmeu2mLYICVCfxLXJhGlxrv0JO4ZSW7Yt2HoU8Y
	A3fMkk/nNaYFr81hMWmlKk0HcQDoo97uYpWRaRnrjGRnZDx32nzMQ0cGvwceCKuHhrMA/2
	FsGEqpalMkzyASICOSl6QQy5HJuQ08I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757709638; x=1789245638;
  h=date:from:to:cc:subject:message-id;
  bh=QPd8bLe3/lbqxpRBttBhBB11z+gpK6GTHhs/MLT6RZY=;
  b=SKBA1QL6r3VSV2b4N0W9qgujdM3lKwhf7VeaBB2bKYP+3/3ctT4fUPuM
   FydSCr2E2PLcjO2H/7S3E0wxGI9qmXCRcOY4wa3FDTCqf9Aq7CkhYOidz
   Ai7+fihBWemWBWjDMs2fFDh1FXEaO2qiKQouYBljjLu+FPLZVIy+WJNrJ
   RH32oSYmFvF+cIA9FtWbmHZOiIHrVPqpKy09+E6+c+CGuDalliu+zgOQB
   uQAy16a5peoXRvWdSpPmEsKLssMZhAmo4JaGdZXDF3ngaN5FBqNiv6EfD
   rtB3JsgiOrhHNJkNh9etUF59G3mv7gKPdvNLgaefuH4N5b7+jc69qhiY+
   g==;
X-CSE-ConnectionGUID: 7n2y5iKPRye6dZAIhKNKRg==
X-CSE-MsgGUID: dFOQj5nWT2ehArdEtmdfpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="82648237"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="82648237"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 13:40:36 -0700
X-CSE-ConnectionGUID: eWBgVwySSw6L1dvF8wMOEw==
X-CSE-MsgGUID: eicCNeYSQlmyQs4KATF89A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,260,1751266800"; 
   d="scan'208";a="178447284"
Received: from lkp-server02.sh.intel.com (HELO eb5fdfb2a9b7) ([10.239.97.151])
  by fmviesa005.fm.intel.com with ESMTP; 12 Sep 2025 13:40:33 -0700
Received: from kbuild by eb5fdfb2a9b7 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uxAZL-0001Ct-24;
	Fri, 12 Sep 2025 20:40:31 +0000
Date: Sat, 13 Sep 2025 04:40:09 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>
Subject: [linux-next:master] BUILD REGRESSION
 590b221ed4256fd6c34d3dea77aa5bd6e741bbc1
Message-ID: <202509130410.vJTHL1fx-lkp@intel.com>
User-Agent: s-nail v14.9.24
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 70694100017
X-Stat-Signature: x9f7momre7f87g8zpm7bii3ww69jjowa
X-HE-Tag: 1757709637-497006
X-HE-Meta: U2FsdGVkX18Z73tanWaealGyRFDi58zbNn9ahqCuYFpscAPaq7tWGV6Ebx79BBv05f9GrPLBOzvFdjBkM3+9srjz0b21z1w/wPT2F5eSqPyh/t7D2ltE2H7QoAZx1CtUVwt6h31uIXBjE4aIkvq2cN6t53T4l+ZOm0HCEQC0s7/5zdOaDbeaOeaQM0FVYyBuQqynZpbvf4DifkO4A7LH74FDfecdxNOQVcGIsj9vYXqYOKis4vFpguGrYas37YxLdSH5kLc+OgHvHsFWAWPeuQx99OhClmXHJrXOYfbVdKZE7k5NjCuHSrJWSdAopiy/1p5KfcsvBQwkDhEUSkW3q6d/GlBztQ0uI9T8J90WNe87YIIGz0JFHE7LHw8V0mcLHBo3Ug73sVgaZM2ky9AvrbWeKqAoSv5HJ21aZk7fd6YJBHhOKxwQwJ+1Tcw2FBYRJmc3p4Lx4MCLF7rTl3rAB02PQljuOp44xqCdSN2FJ4D9M3F/cdTQ8mx1NLkIbZTbLUGharplbGIRz5S0K+hEXZUb9xtIg13W6+ONJGZFNwHtqa0GS8zxgrcGS3GV0tGkdigcwXAyiWraKI9uS7KRyA0x8/Y/Kh6KE3Szwuk1xuaT9yk9hFLWGFQfOSSxJKI55QovbLC92GGJXhqEXwwb7NQ9k/xKUpnOK0Ge1NRB8qwzQisrX4JCuR7Aq7Kc8wxxEOxsgojrOPWLxM9omeRAIaUUAbqom1nqqpEss36PLePb255cY65twcI1fdssRARxxnw2apWPMfs5/NT0vgiABCyxyz1Q8VIOX10QPUzqUsUao6yrQulKzcE65rjKBujp+M7Hrx7OC35/nJMHYWiLsxojHuZWcqT1FuQN8SgDj5dkTNDpr4vKmt0DfgWMVlwXGWNn9m704BjDPsvHHUQqy99RhypxPzQ+3ZK2wNNUIkyb6+HXZnXSbRWuFWOg+zDJ72+2t4HOKJyjYSgYDBm
 8NsW2IAv
 bjBZ51OWlTyw/Jp+KTkvOOybOIandcexUNRZxE/FcQBgi0E3JH5P69wEknULEWXINTBM0MCWnNLso162d37MNi7qBqNSUEL6IKRKfsTnlPcG4PtZ5W3Fpdrk+hrspn3cFmGC5dpBLx41KEmzSCyEtCwp5xpRjxiXCtUKTTTbI1zPS2nEeP/2K8CAsDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
branch HEAD: 590b221ed4256fd6c34d3dea77aa5bd6e741bbc1  Add linux-next specific files for 20250912

Error/Warning (recently discovered and may have been fixed):

    https://lore.kernel.org/oe-kbuild-all/202508142038.M8MuVqEP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202508211859.UoYsJbLN-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509052225.NIyWDaaP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509061641.M9r43HWa-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509101930.OsSQJxIP-lkp@intel.com
    https://lore.kernel.org/oe-kbuild-all/202509112310.qXbyQPpQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509112313.0XfkfKPl-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509120229.YpG1CcD3-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509121747.MZEQ1fF2-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509121952.ChfqonoQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509122123.Tv76XiqQ-lkp@intel.com
    https://lore.kernel.org/oe-kbuild/202509122328.JDGUFyAN-lkp@intel.com

    Documentation/.renames.txt: warning: ignored by one of the .gitignore files
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): clocks: [[225, 1], [225, 11], [225, 15], [225, 18], [225, 19]] is too short
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): clocks: [[225, 1], [225, 28], [225, 32], [225, 35], [225, 36]] is too short
    arch/arm64/boot/dts/qcom/lemans-evk.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcm6490-fairphone-fp5.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcm6490-idp.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcm6490-shift-otter.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-vision-mezzanine.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride-r3.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride-r3.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/qcs9100-ride.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride-r3.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride-r3.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride.dtb: displayport-controller@af54000 (qcom,sa8775p-dp): reg: [[0, 183844864, 0, 260], [0, 183845376, 0, 192], [0, 183848960, 0, 1904], [0, 183853056, 0, 156], [0, 183857152, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sa8775p-ride.dtb: displayport-controller@af5c000 (qcom,sa8775p-dp): reg: [[0, 183877632, 0, 260], [0, 183878144, 0, 192], [0, 183881728, 0, 1904], [0, 183885824, 0, 156], [0, 183889920, 0, 156]] is too short
    arch/arm64/boot/dts/qcom/sc7280-crd-r3.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-crd-pro.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-crd.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-evoker-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-evoker.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-herobrine-r1.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-villager-r0.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-villager-r1-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-villager-r1.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie-nvme-lte.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie-nvme.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-herobrine-zombie.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-idp.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc7280-idp2.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc8180x-lenovo-flex-5g.dtb: displayport-controller@ae9a000 (qcom,sc8180x-edp): reg: [[0, 183083008, 0, 512], [0, 183083520, 0, 512], [0, 183084032, 0, 1536], [0, 183085568, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sc8180x-primus.dtb: displayport-controller@ae9a000 (qcom,sc8180x-edp): reg: [[0, 183083008, 0, 512], [0, 183083520, 0, 512], [0, 183084032, 0, 1536], [0, 183085568, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sm6350-sony-xperia-lena-pdx213.dtb: displayport-controller@ae90000 (qcom,sm6350-dp): clocks: [[127, 1], [127, 7], [127, 11], [127, 14], [127, 15]] is too short
    arch/arm64/boot/dts/qcom/sm7225-fairphone-fp4.dtb: displayport-controller@ae90000 (qcom,sm6350-dp): clocks: [[141, 1], [141, 7], [141, 11], [141, 14], [141, 15]] is too short
    arch/arm64/boot/dts/qcom/sm7325-nothing-spacewar.dtb: edp@aea0000 (qcom,sc7280-edp): reg: [[0, 183107584, 0, 512], [0, 183108096, 0, 512], [0, 183108608, 0, 3072], [0, 183111680, 0, 1024]] is too short
    arch/arm64/boot/dts/qcom/sm8250-samsung-r8q.dtb: displayport-controller@ae90000 (qcom,sm8250-dp): clocks: [[193, 0], [193, 12], [193, 18], [193, 21], [193, 26]] is too short
    arch/arm64/boot/dts/qcom/sm8250-samsung-x1q.dtb: displayport-controller@ae90000 (qcom,sm8250-dp): clocks: [[193, 0], [193, 12], [193, 18], [193, 21], [193, 26]] is too short
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev1.0.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revA.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu102-revB.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu106-revA.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dtb: clock-generator@36 (silabs,si5341): 'clock-output-names' does not match any of the regexes: '^out@[0-9]$', '^pinctrl-[0-9]+$', '^vddo[0-9]-supply$'
    arch/arm64/boot/dts/xilinx/zynqmp-zcu111-revA.dtb: clock-generator@36 (silabs,si5341): out@0: 'always-on' does not match any of the regexes: '^pinctrl-[0-9]+$'
    drivers/hid/hid-steelseries.c:599:1: warning: label 'srws1_remove' defined but not used [-Wunused-label]
    drivers/infiniband/hw/mlx5/mr.c:840:31: warning: 'sprintf' may write a terminating nul past the end of the destination [-Wformat-overflow=]
    drivers/mfd/tps6594-core.c:767:21: error: implicit declaration of function 'FIELD_GET' [-Werror=implicit-function-declaration]
    drivers/mfd/tps6594-core.c:767:21: error: implicit declaration of function 'FIELD_GET' [-Wimplicit-function-declaration]
    drivers/mfd/tps6594-core.c:767:7: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    drivers/mfd/tps6594-core.c:767:7: error: implicit declaration of function 'FIELD_GET' [-Werror=implicit-function-declaration]

Unverified Error/Warning (likely false positive, kindly check if interested):

    drivers/char/tpm/tpm_ppi.c:349 tpm_show_ppi_tcg_operations() warn: inconsistent returns 'global &tpm_ppi_lock'.
    drivers/char/tpm/tpm_ppi.c:378 tpm_show_ppi_vs_operations() warn: inconsistent returns 'global &tpm_ppi_lock'.
    drivers/gpu/drm/xe/xe_bo.c:2446 xe_bo_create_pin_range_novm() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_bo.c:2513 xe_bo_create_pin_map_at_novm() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_dma_buf.c:253 xe_dma_buf_init_obj() error: uninitialized symbol 'bo'.
    drivers/gpu/drm/xe/xe_pxp_submit.c:133 allocate_gsc_client_resources() error: uninitialized symbol 'bo'.
    kernel/power/energy_model.c:649 em_dev_register_pd_no_update() error: we previously assumed 'dev->em_pd' could be null (see line 594)

Error/Warning ids grouped by kconfigs:

recent_errors
|-- alpha-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- alpha-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- alpha-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arc-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arc-randconfig-r123-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- arm-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-jornada720_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-003-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-004-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm-randconfig-r131-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-003-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-004-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- arm64-randconfig-051-20250912
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-x1q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|-- arm64-randconfig-052-20250912
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-x1q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|-- arm64-randconfig-053-20250912
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-x1q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|-- arm64-randconfig-054-20250912
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-x1q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|-- arm64-randconfig-055-20250912
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-lemans-evk.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-fairphone-fp5.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcm6490-shift-otter.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-industrial-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2-vision-mezzanine.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs6490-rb3gen2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-qcs9100-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride-r3.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af54000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sa8775p-ride.dtb:displayport-controller-af5c000-(qcom-sa8775p-dp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-crd-r3.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd-pro.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-crd.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-evoker.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-herobrine-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r0.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-villager-r1.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme-lte.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie-nvme.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-herobrine-zombie.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc7280-idp2.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-lenovo-flex-5g.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sc818-primus.dtb:displayport-controller-ae9a000-(qcom-sc818-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm6350-sony-xperia-lena-pdx213.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7225-fairphone-fp4.dtb:displayport-controller-ae90000-(qcom-sm6350-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm7325-nothing-spacewar.dtb:edp-aea0000-(qcom-sc7280-edp):reg:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-r8q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-qcom-sm8250-samsung-x1q.dtb:displayport-controller-ae90000-(qcom-sm8250-dp):clocks:is-too-short
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-rev1..dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu102-revB.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu106-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|   |-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):clock-output-names-does-not-match-any-of-the-regexes:out-pinctrl-vddo-supply
|   `-- arch-arm64-boot-dts-xilinx-zynqmp-zcu111-revA.dtb:clock-generator-(silabs-si5341):out:always-on-does-not-match-any-of-the-regexes:pinctrl
|-- arm64-randconfig-r133-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- csky-allnoconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-defconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|   |-- drivers-hid-hid-steelseries.c:warning:label-srws1_remove-defined-but-not-used
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- csky-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- csky-randconfig-r132-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- arch-csky-abiv2-cacheflush.c:error:passing-argument-of-test_and_set_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-clear_bit-from-incompatible-pointer-type
|   |-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-const_test_bit-from-incompatible-pointer-type
|   `-- arch-csky-abiv2-inc-abi-cacheflush.h:error:passing-argument-of-generic_test_bit-from-incompatible-pointer-type
|-- hexagon-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- hexagon-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- hexagon-randconfig-r111-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- i386-buildonly-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-003-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-004-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-buildonly-randconfig-005-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- i386-buildonly-randconfig-006-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- i386-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-061-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-062-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-063-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- i386-randconfig-141-20250911
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_bo_create_pin_map_at_novm()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_bo.c-xe_bo_create_pin_range_novm()-error:uninitialized-symbol-bo-.
|   |-- drivers-gpu-drm-xe-xe_dma_buf.c-xe_dma_buf_init_obj()-error:uninitialized-symbol-bo-.
|   `-- drivers-gpu-drm-xe-xe_pxp_submit.c-allocate_gsc_client_resources()-error:uninitialized-symbol-bo-.
|-- i386-randconfig-141-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- kernel-power-energy_model.c-em_dev_register_pd_no_update()-error:we-previously-assumed-dev-em_pd-could-be-null-(see-line-)
|-- loongarch-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- loongarch-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- loongarch-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- m68k-amiga_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- m68k-m5208evb_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- microblaze-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- microblaze-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-allyesconfig
|   |-- (.head.text):relocation-truncated-to-fit:R_MIPS_26-against-kernel_entry
|   |-- (.ref.text):relocation-truncated-to-fit:R_MIPS_26-against-start_secondary
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-randconfig-r113-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- mips-randconfig-r121-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- clang:error:clang-frontend-command-failed-with-exit-code-(use-v-to-see-invocation)
|-- nios2-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- nios2-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- nios2-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- openrisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- openrisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- openrisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- parisc-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- parisc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-lite5200b_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-mvme5100_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- powerpc-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc-randconfig-003-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- powerpc64-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- powerpc64-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- powerpc64-randconfig-003-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- riscv-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- s390-alldefconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-infiniband-hw-mlx5-mr.c:warning:sprintf-may-write-a-terminating-nul-past-the-end-of-the-destination
|-- s390-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- s390-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sh-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sh-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-allmodconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- sparc-randconfig-r122-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- sparc64-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- um-allmodconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-i386_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- um-x86_64_defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-allyesconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-001-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-002-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-003-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-buildonly-randconfig-004-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-buildonly-randconfig-005-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:call-to-undeclared-function-FIELD_GET-ISO-C99-and-later-do-not-support-implicit-function-declarations
|-- x86_64-buildonly-randconfig-006-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-defconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-121-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-gpu-drm-amd-amdgpu-amdgpu_userq_fence.c:sparse:sparse:incompatible-types-in-comparison-expression-(different-address-spaces):
|-- x86_64-randconfig-122-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-123-20250912
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- x86_64-randconfig-161-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   |-- drivers-char-tpm-tpm_ppi.c-tpm_show_ppi_tcg_operations()-warn:inconsistent-returns-global-tpm_ppi_lock-.
|   `-- drivers-char-tpm-tpm_ppi.c-tpm_show_ppi_vs_operations()-warn:inconsistent-returns-global-tpm_ppi_lock-.
|-- x86_64-rhel-9.4-rust
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allnoconfig
|   `-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|-- xtensa-allyesconfig
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- xtensa-randconfig-001-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
|-- xtensa-randconfig-002-20250912
|   |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
|   `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET
`-- xtensa-randconfig-r112-20250912
    |-- Documentation-.renames.txt:warning:ignored-by-one-of-the-.gitignore-files
    `-- drivers-mfd-tps6594-core.c:error:implicit-declaration-of-function-FIELD_GET

elapsed time: 847m

configs tested: 133
configs skipped: 5

tested configs:
alpha                             allnoconfig    gcc-15.1.0
alpha                            allyesconfig    gcc-15.1.0
alpha                               defconfig    gcc-15.1.0
arc                              allmodconfig    gcc-15.1.0
arc                               allnoconfig    gcc-15.1.0
arc                              allyesconfig    gcc-15.1.0
arc                                 defconfig    gcc-15.1.0
arc                   randconfig-001-20250912    gcc-10.5.0
arc                   randconfig-002-20250912    gcc-12.5.0
arm                              allmodconfig    gcc-15.1.0
arm                               allnoconfig    clang-22
arm                              allyesconfig    gcc-15.1.0
arm                                 defconfig    clang-22
arm                      jornada720_defconfig    clang-22
arm                   randconfig-001-20250912    clang-22
arm                   randconfig-002-20250912    gcc-14.3.0
arm                   randconfig-003-20250912    clang-22
arm                   randconfig-004-20250912    gcc-10.5.0
arm64                            allmodconfig    clang-19
arm64                             allnoconfig    gcc-15.1.0
arm64                               defconfig    gcc-15.1.0
arm64                 randconfig-001-20250912    clang-20
arm64                 randconfig-002-20250912    clang-16
arm64                 randconfig-003-20250912    clang-22
arm64                 randconfig-004-20250912    clang-19
csky                              allnoconfig    gcc-15.1.0
csky                                defconfig    gcc-15.1.0
csky                  randconfig-001-20250912    gcc-15.1.0
csky                  randconfig-002-20250912    gcc-11.5.0
hexagon                          allmodconfig    clang-17
hexagon                           allnoconfig    clang-22
hexagon                          allyesconfig    clang-22
hexagon                             defconfig    clang-22
hexagon               randconfig-001-20250912    clang-22
hexagon               randconfig-002-20250912    clang-22
i386                             allmodconfig    gcc-14
i386                              allnoconfig    gcc-14
i386                             allyesconfig    gcc-14
i386        buildonly-randconfig-001-20250912    gcc-14
i386        buildonly-randconfig-002-20250912    clang-20
i386        buildonly-randconfig-003-20250912    gcc-13
i386        buildonly-randconfig-004-20250912    clang-20
i386        buildonly-randconfig-005-20250912    gcc-14
i386        buildonly-randconfig-006-20250912    clang-20
i386                                defconfig    clang-20
loongarch                        allmodconfig    clang-19
loongarch                         allnoconfig    clang-22
loongarch                           defconfig    clang-19
loongarch             randconfig-001-20250912    gcc-15.1.0
loongarch             randconfig-002-20250912    clang-22
m68k                             allmodconfig    gcc-15.1.0
m68k                              allnoconfig    gcc-15.1.0
m68k                             allyesconfig    gcc-15.1.0
m68k                          amiga_defconfig    gcc-15.1.0
m68k                                defconfig    gcc-15.1.0
m68k                       m5208evb_defconfig    gcc-15.1.0
microblaze                       allmodconfig    gcc-15.1.0
microblaze                        allnoconfig    gcc-15.1.0
microblaze                       allyesconfig    gcc-15.1.0
microblaze                          defconfig    gcc-15.1.0
mips                              allnoconfig    gcc-15.1.0
nios2                             allnoconfig    gcc-11.5.0
nios2                               defconfig    gcc-11.5.0
nios2                 randconfig-001-20250912    gcc-11.5.0
nios2                 randconfig-002-20250912    gcc-11.5.0
openrisc                          allnoconfig    gcc-15.1.0
openrisc                         allyesconfig    gcc-15.1.0
openrisc                            defconfig    gcc-15.1.0
parisc                           allmodconfig    gcc-15.1.0
parisc                            allnoconfig    gcc-15.1.0
parisc                           allyesconfig    gcc-15.1.0
parisc                              defconfig    gcc-15.1.0
parisc                randconfig-001-20250912    gcc-14.3.0
parisc                randconfig-002-20250912    gcc-8.5.0
parisc64                            defconfig    gcc-15.1.0
powerpc                           allnoconfig    gcc-15.1.0
powerpc                          allyesconfig    clang-22
powerpc                   lite5200b_defconfig    clang-22
powerpc                    mvme5100_defconfig    gcc-15.1.0
powerpc               randconfig-001-20250912    gcc-8.5.0
powerpc               randconfig-002-20250912    clang-22
powerpc               randconfig-003-20250912    clang-17
powerpc64             randconfig-001-20250912    gcc-12.5.0
powerpc64             randconfig-002-20250912    clang-22
powerpc64             randconfig-003-20250912    clang-19
riscv                            allmodconfig    clang-22
riscv                             allnoconfig    gcc-15.1.0
riscv                            allyesconfig    clang-16
riscv                               defconfig    clang-22
riscv                 randconfig-001-20250912    clang-16
riscv                 randconfig-002-20250912    gcc-9.5.0
s390                             alldefconfig    gcc-15.1.0
s390                             allmodconfig    clang-18
s390                              allnoconfig    clang-22
s390                             allyesconfig    gcc-15.1.0
s390                                defconfig    clang-22
s390                  randconfig-001-20250912    gcc-10.5.0
s390                  randconfig-002-20250912    gcc-10.5.0
sh                               allmodconfig    gcc-15.1.0
sh                                allnoconfig    gcc-15.1.0
sh                               allyesconfig    gcc-15.1.0
sh                                  defconfig    gcc-15.1.0
sh                    randconfig-001-20250912    gcc-15.1.0
sh                    randconfig-002-20250912    gcc-15.1.0
sparc                            allmodconfig    gcc-15.1.0
sparc                             allnoconfig    gcc-15.1.0
sparc                               defconfig    gcc-15.1.0
sparc                 randconfig-001-20250912    gcc-8.5.0
sparc                 randconfig-002-20250912    gcc-13.4.0
sparc64                             defconfig    clang-20
sparc64               randconfig-001-20250912    gcc-8.5.0
sparc64               randconfig-002-20250912    clang-20
um                               allmodconfig    clang-19
um                                allnoconfig    clang-22
um                               allyesconfig    gcc-14
um                                  defconfig    clang-22
um                             i386_defconfig    gcc-14
um                    randconfig-001-20250912    clang-22
um                    randconfig-002-20250912    gcc-14
um                           x86_64_defconfig    clang-22
x86_64                            allnoconfig    clang-20
x86_64                           allyesconfig    clang-20
x86_64      buildonly-randconfig-001-20250912    gcc-14
x86_64      buildonly-randconfig-002-20250912    gcc-14
x86_64      buildonly-randconfig-003-20250912    clang-20
x86_64      buildonly-randconfig-004-20250912    clang-20
x86_64      buildonly-randconfig-005-20250912    clang-20
x86_64      buildonly-randconfig-006-20250912    gcc-14
x86_64                              defconfig    gcc-14
x86_64                          rhel-9.4-rust    clang-20
xtensa                            allnoconfig    gcc-15.1.0
xtensa                randconfig-001-20250912    gcc-9.5.0
xtensa                randconfig-002-20250912    gcc-12.5.0

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

