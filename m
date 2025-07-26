Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D607C87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 11:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43866B0088; Sat, 26 Jul 2025 07:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F4296B0089; Sat, 26 Jul 2025 07:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 909BC6B008A; Sat, 26 Jul 2025 07:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8626B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 07:31:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB5845C432
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 11:31:45 +0000 (UTC)
X-FDA: 83706200970.20.3344ACA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf30.hostedemail.com (Postfix) with ESMTP id C104780012
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 11:31:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b5RIxQQK;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753529503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SlefamRAyhb5Hj2lsOIYr/7l5YHjqEhOEgoTla48dqQ=;
	b=TUBJIsKP375w0w5m/o5YRk2R+h72ubZyUEmiOkGYUiEp86hVUVdagtJLuqIfe5jQ9fdihq
	VJoMd01AlX73n0yJeC1irlDNidIZ01N4zB7AvXWuX02MKlaOX3v8tW7JQG18sHEAryF7n+
	JU+qzcqCaeu6XJvYU3u84esp754G87c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753529503; a=rsa-sha256;
	cv=none;
	b=2VHAL7Dlp4NuRfNlHz/6LeZYp6ICOZWbj+zwNH28zAZ14TugXTqp6q94NwHCGpgIkRibCK
	te6CziVsrpOy2xY5Oh7pjpt1U47AZp9nWkrE9XkN72Q07SwT93GGOJ0032ZlKnaO4BTBum
	/qxEFphOedt5KO3TQT15yPgbk5k+mzU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=b5RIxQQK;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753529503; x=1785065503;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x5ftixc4aZ/+5TD+y+Aes85jYKYNSbOyuX7QDNVsBd8=;
  b=b5RIxQQKtzsnYdlnFx8W/A0MJpXAZrH23WAIVvafNCigq60Wluc7CYUL
   JC9iNbt0bJul2t0rn1vgfNalaJmohEncAmjLN6gQL9hEqLOTq9uoW8cET
   NLXw/HEiLBfAi7DrLdYpNilENTVhpPxjxaVugbzI/SOXSe+0stQBXP8JQ
   BjSSft2OpfshQKFaQw0mjmbWMkpqxM+qhknaZj8v1710ZB1dEbz0PAsRw
   hUrTNWhTF9kEfCSqKVXY2n33gRm4fTWL6bl0zjBes45+CF0aK+6OL6ZFu
   057QH7XB4ivCb2JcpDtFR1MflrF49sFy/oxxUiyPByiugKAaGJW2dVM0b
   Q==;
X-CSE-ConnectionGUID: Zhh4ViyxSHWIncTN7jJ37A==
X-CSE-MsgGUID: h+lgLYfQScGGhSDBiGoeMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55705697"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55705697"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2025 04:31:41 -0700
X-CSE-ConnectionGUID: pR4kffSwRjy1c2IEc26nyw==
X-CSE-MsgGUID: cFu3aEPNSiGqjJr475Nxqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="160800593"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 26 Jul 2025 04:31:34 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ufd7j-000Lvz-1t;
	Sat, 26 Jul 2025 11:31:31 +0000
Date: Sat, 26 Jul 2025 19:30:54 +0800
From: kernel test robot <lkp@intel.com>
To: Bartosz Golaszewski <brgl@bgdev.pl>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Sean Wang <sean.wang@kernel.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Paul Cercueil <paul@crapouillou.net>, Kees Cook <kees@kernel.org>,
	Andy Shevchenko <andy@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Dong Aisheng <aisheng.dong@nxp.com>,
	Fabio Estevam <festevam@gmail.com>, Shawn Guo <shawnguo@kernel.org>,
	Jacky Bai <ping.bai@nxp.com>,
	Pengutronix Kernel Team <kernel@pengutronix.de>,
	NXP S32 Linux Team <s32@nxp.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Tony Lindgren <tony@atomide.com>,
	Haojian Zhuang <haojian.zhuang@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v3 10/15] pinctrl: make struct pinfunction a pointer in
 struct function_desc
Message-ID: <202507261937.Txq9shpv-lkp@intel.com>
References: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4@linaro.org>
X-Rspamd-Queue-Id: C104780012
X-Stat-Signature: 77jn7aopias84yxxwuo4fr11hc5mbi9j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753529502-347478
X-HE-Meta: U2FsdGVkX1+dnyeTBnOfUQ/jhAMtYc0Uri54oRNPwaIRY4cFWQXDb4IXq8wxjBa3SdjZfzN2UYaUa8QShoLprXujH6I4QWXT7Hh89r6l9CJidLCvSYXTvufZ+YQHjSR91gSAcXjiCSt2IBOYJxle4lv49wyRyYqXIMoUP5VnRGiG5cUwYlrm3SAJPjPc1Rw7pJlX3qfJyvaQtKcv20XuzQU2W17cB6a9uTXd5+83tvl1JYKqsulNNZyLlUq3QEPqAOUwrfUgCyZnS1tlLR9pEXrVqdkl51qaENBVjK9BRzEbLVzh+52RRAmKWkhAjdgw7H9JzFQp32nv8+xEFzf0Mp/j5S4ilBXB4flziMbR0tLE+QA5MELTrAlu3t4LciNewWxdLyu0xiWCr3Sh70F4vkk3vSIrMnRFgvpv80t9+MhMtXjcDIz+HRJF33RD40cD2NOLulrF5CDVBv+p8cM3tM3Dgc25k+0M1L8+kyq5qZ/71sv8J7H8sAFWY2woSUTO7hiJ0n3oO/SZttCqCKtu35TMENSu4WPDi5K4F6v5dAdaEU4QT+OBCaSxO70YwQriFA61yjqKIwt9oObwSP1JcS+Xn34/1ree8foNZqOGtZC5PDBHEdEWVfwhXeSYhefLcd2i50Dnf/J3iaApdAAuLLCbYHS5JviJJNJj9RzURWa0UL3OAVhkB0My7Wh5/1lAE0AWMKosn4Cr6q9fG+xaJ9N2Ci4FBes75pSBIgTb6bsIisIENXR5IWniXTo5gq1T3Lbn9pJLz3OGfdltNv77s9fkm7vUCXTia8Ve5Apl+IdRkQ/1XA7dckfhQaAQCz9tIRBoGqqYqN4XcEknwcyyBuLuOSyYhXGRxKfTw7dXlpX2SsuwMb2LOaqthmJR96NVHoSrNrCAHRYxHhZZScJ/ghUaAfXpeDUoAIbeD/emIKe/uQqXEkujKPg8QSE3idqcId+Ng6ayveoh+XiKtB5
 bPCrLFUR
 ZiZao1WPcvN/rqOyvC5hDyij4F9AHxtxpJ+dD144d+WKVgorJLWJcbczLH10+2p+gV47h8N7IkSqmvifIO5XcKhfzQyyMBfl4w9nl9uTh4EayDNsoP4rmKiBcGUZbbqBbgrjInV/bJ4mygHOjClxNd7QqWOHja2cDDM0uaNiGVmo1hLMpWvy8OqGDh0ikVtZITx13FuUKen+LkqF5S9115RvVEcmY7xR3udk8Kg9mtTwueZfWZXyLHnCUwj6ViU8Hx1IJp+fvdCoAKQzB3UWsN/654Zfr5HUWVf88a8ncOv+SvAXV1ikfC4JjOoHD0G6mjwfDonKbKuorCZlYw+Vnnc20EaosTyc7MqLZDzltOT0dVqwKPEBQID6u5xjeSm1HMrMlYK/r3xR5XJ7Sn5+t+m/J5GlRvsV/7VV15xnlf4yAW+yrxQMnNff7PmJiLTaZneP7yjQ2wtqlMmyQd1FClRBQMw/Zq2oUUZgmcCqhU2lucSu6YG/SnppNl8BMxIM3FmlpQWTvOsIa6Qc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bartosz,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 05adbee3ad528100ab0285c15c91100e19e10138]

url:    https://github.com/intel-lab-lkp/linux/commits/Bartosz-Golaszewski/lib-provide-kmemdup_const/20250724-172620
base:   05adbee3ad528100ab0285c15c91100e19e10138
patch link:    https://lore.kernel.org/r/20250724-pinctrl-gpio-pinfuncs-v3-10-af4db9302de4%40linaro.org
patch subject: [PATCH v3 10/15] pinctrl: make struct pinfunction a pointer in struct function_desc
config: x86_64-buildonly-randconfig-002-20250725 (https://download.01.org/0day-ci/archive/20250726/202507261937.Txq9shpv-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250726/202507261937.Txq9shpv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507261937.Txq9shpv-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/pinctrl/pinmux.c:917:7: warning: cast from 'void (*)(const void *)' to 'void (*)(void *)' converts to incompatible function type [-Wcast-function-type-strict]
     917 |                                          (void (*)(void *))kfree_const,
         |                                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/device/devres.h:166:34: note: expanded from macro 'devm_add_action_or_reset'
     166 |         __devm_add_action_or_reset(dev, action, data, #action)
         |                                         ^~~~~~
   1 warning generated.


vim +917 drivers/pinctrl/pinmux.c

   883	
   884	/**
   885	 * pinmux_generic_add_pinfunction() - adds a function group
   886	 * @pctldev: pin controller device
   887	 * @func: pinfunction structure describing the function group
   888	 * @data: pin controller driver specific data
   889	 */
   890	int pinmux_generic_add_pinfunction(struct pinctrl_dev *pctldev,
   891					   const struct pinfunction *func, void *data)
   892	{
   893		struct function_desc *function;
   894		int selector, error;
   895	
   896		selector = pinmux_func_name_to_selector(pctldev, func->name);
   897		if (selector >= 0)
   898			return selector;
   899	
   900		selector = pctldev->num_functions;
   901	
   902		function = devm_kzalloc(pctldev->dev, sizeof(*function), GFP_KERNEL);
   903		if (!function)
   904			return -ENOMEM;
   905	
   906		function->func = kmemdup_const(func, sizeof(*func), GFP_KERNEL);
   907		if (!function->func)
   908			return -ENOMEM;
   909	
   910		/*
   911		 * FIXME: It's generally a bad idea to use devres in subsystem core
   912		 * code - managed interfaces are aimed at drivers - but pinctrl already
   913		 * uses it all over the place so it's a larger piece of technical debt
   914		 * to fix.
   915		 */
   916		error = devm_add_action_or_reset(pctldev->dev,
 > 917						 (void (*)(void *))kfree_const,
   918						 (void *)function->func);
   919		if (error)
   920			return error;
   921	
   922		function->data = data;
   923	
   924		error = radix_tree_insert(&pctldev->pin_function_tree, selector, function);
   925		if (error)
   926			return error;
   927	
   928		pctldev->num_functions++;
   929	
   930		return selector;
   931	}
   932	EXPORT_SYMBOL_GPL(pinmux_generic_add_pinfunction);
   933	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

