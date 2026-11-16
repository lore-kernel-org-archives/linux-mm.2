Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2EFE606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 00:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=DT+6K6Qm
Received: by kanga.kvack.org (Postfix)
	id CFFFE6B00EF; Sun, 15 Nov 2026 19:27:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0926B05B0; Sun, 15 Nov 2026 19:27:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9FC6B05B1; Sun, 15 Nov 2026 19:27:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A8306B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 19:27:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 251F61C4249
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:27:53 +0000 (UTC)
X-FDA: 85439094426.16.685EA94
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8554F1C0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 00:27:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DT+6K6Qm;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794788871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=TtiiaCFeqtLXGnA0GpTTu12dC+fDzVvWIjzSRct5aYc=;
	b=xLs6Ryakz6z1dLgU5SDpGSLJPu9x+F7qzxyfU3/XCpS1d8MjcL0tcMvxKejTSOwOF1IcXY
	ZtdB1thGX/v3cXce+WHW1/mlgInRdbVuQXhgEBoL6PnI/14ofEudso8f6aGcOsi/n7W89a
	kbu9oOQHD64U9xsHC7BlPcMtiof68bg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794788871;
	b=AUwMFtexSj28dDSvLJbfbOZkB3clNaitXmeMCbJ5xQ4+po7HXZzwxXa7WD3SC3yqpy8nkA
	+y3QBmAs0f4LqvCSTPN+XBQwp21yHqouAEfEqOxZUEVKdiWz18YN/3Y3UTiS31tPKYmX5t
	SsuS28XfMA/ANS3G9+VdvtsqnefAF0k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DT+6K6Qm;
	spf=pass (imf18.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794788871; x=1826324871;
  h=date:from:to:cc:subject:message-id;
  bh=Ls/0rd3AhZY4FetIF9ozeDQ7xvACYQetDnnTkuy0/yY=;
  b=DT+6K6Qm3/izUT+2SVkXMolurbglALVUpL/jwZ5gEQ57bIPvLknKSzEJ
   mQe0zV/ub93tfmRxjaOGDh9O1D5VTjuMOK+05ITsptwpgzlJ2SBhCdmlC
   cutQFBI3L6l7NZJZcY30G6WgUYrhkWs1065ZmITgieWSQMVnDiVKixqzL
   P1exTQlYkBNmQ12LC3I7dGrULalgrmq47k6BriPYR2hixXegRFxM/nr8z
   FMXVhC1VTNDTkr/uXXGDxNhq8tdtNA0lFl51us0GNX2qnplkaQlnDhDIV
   Z6JpHt/wXuTZiKAgZyNFSwhpsgy9HVpsycXsT/H+H5FHcVIg2mVJSLPFp
   w==;
X-CSE-ConnectionGUID: CJdkcd4VRJ6CczaSlfpB3A==
X-CSE-MsgGUID: dn6FKAdTSJi9IDv1Pc3HdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11967"; a="3507238"
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="3507238"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2026 16:27:49 -0800
X-CSE-ConnectionGUID: TtsVxioKSniRqVN26etQQg==
X-CSE-MsgGUID: 6Et6NeMgRSeAf7aim/SxBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,215,1787036400"; 
   d="scan'208";a="9742699"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 15 Nov 2026 16:27:47 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xSkZU-000000017UO-0S06;
	Mon, 16 Nov 2026 00:27:44 +0000
Date: Mon, 16 Nov 2026 08:27:39 +0800
From: kernel test robot <lkp@intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Nathan Chancellor <nathan@kernel.org>
Subject: sh4-linux-ld: drivers/media/i2c/tc358746.c:1607:undefined
 reference to `devm_of_clk_add_hw_provider'
Message-ID: <202611160836.dBWEJOjI-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam06
X-Stat-Signature: 8eq65kqspszerd59qr3abywssr1hs7nb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8554F1C0005
X-Rspam-User: 
X-HE-Tag: 1794788870-203185
X-HE-Meta: U2FsdGVkX19DUELoPOfHoHVJLfe+HIlX2YdW5UzpCjMMMRND1OAea+QYDUwAE5YgnzoezxpGFqeXMlzFxpbenDAmI3WXEgcgtZgaIKSnyEjQVT0x079MzbHeMr1am5kb9uUcbqJFBsQBjGNW4Hd0RxHfwW9JNtE13aG5mM1Oinfd1l9FjK8igfsJYHIWiWn8+WlH1a5Ny97okhM21xo8/tBRnUo13qSyj0edvU1X4ryY26bItDsQGqZmkSfcMOhyqYoQnOeRqZItAHz5JRjWq/O93EAAWp5rsph9V50K8IEctvewH0i4C5yyFrD5gy/wHOgFiEKTH9RVMy9zRibBKiOXoEVvQr483D7mgusGx08Rc+dBvyTR4trmYQ23S+yeZqgLe67SVbdFgVgPTMo1Fj1F7/Qx+SuwDs3L1h5DuqOj/1+pFD4RKBqQyLep0HAUBDkrHzjDKn8S9tWZBssH5UwI8ifAtcz7NFETjjB+HTpmtmgfaYke8lN/bYFkNUAwuRJAcNdxSF7hwPOeAB71TCmuti2J7VD2PVSbw4FMOUH/ZnrI8dlL3YbsB2IZeFE22NgFQ87aviDYS9NhuGK0x0FwWWcWC1kxYnOMPz0BQZfJ9lnnevymWZnGYuuvJTQqKhc6w9wfJ7lPuYeTCkFgdS1SBm0rYvIy6CJxWNSuJKHkqg6ZFX3Y8c3QgMB8zQKBDRgZaDvfKJ0azlCPDM/JBvm9QQ8HW69y1W/HVucC/2IoVuYBdVeVKMqJi1JgCfSiWAh++ubY+NhQMqmzJDCyM9B85+aF06rU81UtBc9GFLqXuIpD11oMW1IAVOCo1skLkdB2gFW3Y5kNZQRoqA//aoOSy+KxZcjSHQjHIc/8CBiHeZvMAvg9oodS+8IUtOex5BU2dVqlhpCtQjazgOfvi+eTaU5JKD2gQf/z6Grej1KR5wy6QB6M6HF/orRt/9PEF0HMILHMhK67Nr/1J+h
 FfN8rHMC
 Q/604kCghS3rCBnOGJ6RgW2QcpamkO//YFQezP/J6I8AvRv9ZBlcSJJ+l8pUXY0v3IW85Wu67Mjtx2JEymIGR+mKS+9tLurKY5uNQUCcT9wzRjcFHY1PTmlT8YySBpq44cXzFJbp4zfiH9bSCjXqtfx9msdxuap40u1XMBIG2FzyTJcNhvpy6E7vEQ/YhxNqMan677JOAnIZS7BOzruSFcz1waSnu3a4rZZCws7pMw+fZqFUH6agxC4nqaEz3Gzh1H6X11JeUw1X9KyxdjqaPgU2IL3CelNMyU8gsOmuEjH0OESBKtZg+dkXGX1yInuYc+STJcKfxJRiWw8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hi Arnd,

FYI, the error/warning was bisected to this commit, please ignore it if it's irrelevant.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   fa2933aac170dd19c6a7f0d7b81a8f537e40915c
commit: 94bfc7f3b0c7c33331ba4ff6cc64ff309dfcbce8 err.h: use __always_inline on all error pointer helpers
date:   5 months ago
config: sh-randconfig-1001-20261115 (https://download.01.org/0day-ci/archive/20261116/202611160836.dBWEJOjI-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261116/202611160836.dBWEJOjI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: 94bfc7f3b0c7 ("err.h: use __always_inline on all error pointer helpers")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611160836.dBWEJOjI-lkp@intel.com/

All errors (new ones prefixed by >>):

   sh4-linux-ld: drivers/media/i2c/tc358746.o: in function `tc358746_probe':
   drivers/media/i2c/tc358746.c:1607:(.text+0x1f98): undefined reference to `devm_clk_hw_register'
>> sh4-linux-ld: drivers/media/i2c/tc358746.c:1607:(.text+0x1fa0): undefined reference to `devm_of_clk_add_hw_provider'
   sh4-linux-ld: drivers/media/i2c/tc358746.c:1607:(.text+0x1fa4): undefined reference to `of_clk_hw_simple_get'

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

