Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B31D4CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B688E0017; Tue, 19 Aug 2025 21:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363488E0011; Tue, 19 Aug 2025 21:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0568E0017; Tue, 19 Aug 2025 21:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD8E8E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:31:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B151982C3C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:31:46 +0000 (UTC)
X-FDA: 83795409012.06.EA0E273
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf03.hostedemail.com (Postfix) with ESMTP id E744220005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:31:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FwSsAWz8;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653504; a=rsa-sha256;
	cv=none;
	b=6uOEPv2bKiLPqQjxaHfnPeEK7gcFBITNyXiuJWJaLcwRjzxD+mlAfsvtvbXFTrHmRLkhFo
	et5Fe3iZXFAPuZrDCwLqdI9B/dPVlJMw1jXB5C2OEaCYNS++4jppa/dwVE847ieWri6hsN
	pe9Q3Sl+F/yf3zaGmQpphEwk6v//i1c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=FwSsAWz8;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ET7U36Bc/vJtjM2aHXKzynfonxv2vKxDCOKJFp/unjY=;
	b=AQ7/TtP48JT+96qRNNQSKzfh4x0SRCp/DJo8PWb2AkSoxLb+eCp8Xd7n+C79R1xHNw8fjH
	lO79mVK36+MmmsPajFBxNSumE1ptr2EqOA+R+TgG41HfBsn/4H/JIwPmUHFO2G4WJZJugJ
	KYTnYy/uTvTzulNMDsjuKv83QXD2AIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755653504; x=1787189504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bDraBxH4NicgEf6kVukT6KH9Et8ZUGYmcruJwbCxmCU=;
  b=FwSsAWz8X4rqZrKsjjRgZk4stTDQ9xkblRy97qW9IN2Ft+6DBVigaxLG
   gUNaTSAqwv1pRR4a8dtS18OOkG1MHOp1qmoEfMd2veTycxrbyvfNCJsy5
   pI1bG0/lHRzsR+d97V6dCAPkG2Vu70jOsqRIKyBUEdxbyNzx5ZjnE+1o0
   SvFpJvZ5HrSA7kanyQOJF/OCc/VTbIcQZXtTnPLJqAQWfuc3juv0f004S
   V/69Q0wUpr+qXQBRggI20x/XoG+rO24PLT9IbmWqU2o3UT4pjGEsL91os
   g088XpilL3yNeb15tCf3JTlhBMKoB3ZqdB7So0j5/SNTo5UT5GnI/6oTG
   g==;
X-CSE-ConnectionGUID: rgZMMapiQIC66cGyKprulg==
X-CSE-MsgGUID: apr38vR7R466CAK2ZDIiKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="56939099"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="56939099"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 18:31:42 -0700
X-CSE-ConnectionGUID: xSEaJLclRUqA9AJspn/PjA==
X-CSE-MsgGUID: LZytxw7tSqeSLdstNlMJ8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="168338351"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa008.fm.intel.com with ESMTP; 19 Aug 2025 18:31:39 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uoXft-000Hvn-1G;
	Wed, 20 Aug 2025 01:31:37 +0000
Date: Wed, 20 Aug 2025 09:31:05 +0800
From: kernel test robot <lkp@intel.com>
To: Petr Mladek <pmladek@suse.com>, Feng Tang <feng.tang@linux.alibaba.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>,
	linux-kernel@vger.kernel.org, paulmck@kernel.org,
	john.ogness@linutronix.de
Subject: Re: [PATCH] panic: Clean up message about deprecated 'panic_print'
 parameter
Message-ID: <202508200907.PsZ3geub-lkp@intel.com>
References: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aKRJKZHgcxyNF3y7@pathway.suse.cz>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E744220005
X-Stat-Signature: b4qfrqxdi4yubnesukwsbrijqos9wc9r
X-Rspam-User: 
X-HE-Tag: 1755653503-896736
X-HE-Meta: U2FsdGVkX19k/tupvuxZHPOTeYbLSQRZuEMBYSA3pV47tH+vva7LqD38UPkPoqONE9q2Cw4HUVWy4zk+bl0y8Zd3XF1FQEY9NWrZrYzgsm6Cg+jX9spBKRwNVwspsixDZ3IU103MAKFw00y/RoN7FHhAi8ZiLmGIxh8jUfJrdQMnVaxLTGAjVi/4dp3JKtcuAjnXC1487IUKOD26vv1bL5waX8pKb67KSCTKi5yShP4e2I2rw+XtMqGBWx9oIH0qW5lOc8sghNwNGdW3TGO79ACe6tOOsYYPlm1zm2dY42wNx2t2DghqxtM1nXOS3tNS6WIzeKwK3hYRHc+CBNNb1aufOT3LW30bX6zdx2ufphfs99nQqXsbFuyF4kuXOAAivcnb8x0Jv14vgP62uo6vho1+6n9t1HxHdSEBAqn0jKT/9PDnl+YPIXiW87/C3prIKxDuT8u6GJaKbw4s8XS+hF/M1FluZyS4xMrPxHNJsSo0pAZeQzBI1UiuuJPkXqrRexWWsHugX7TIPeTWp4fRbDEeyFXuhsKi6tJ4XICJuRqo/aCn/h8lR5kvkky7QjJquJdfkH0HgYO9MKVDSKbbgwKl45VY/Tsi/D9N/XYYATK51etnSScCefOeRewupGeS6NV3LCYFF4bLtgvCP7RVNxYy3/2rws3GN+XuyN6UXjoJIX1lGLOPh+yhxntrA1rq1knrO8h5H9DHxMAg7ZCcihPmFEJHyzxJfDfvH6yPYq0YvCpv4gG5HwgASs86bY5DlSz1cc6g4jaa4pX3vHiqo/nu1wMHIZwX0cOGW4ureXyIE07DPi8K0CCE39FF9u7HSP0enej+jsspXJlu1xGrqoESGOZEl7xXtCXFK5xErjmpByZ+02c5OScvzWR6sCnRluftI4dNj9T3+Ll4ORXBFXCgMx/mHIGl1k3XSyEd45ntFFTThxD0/EqaZRxC2TorDWYOWBAja0r56xQoECA
 27b6Xpmg
 GBlSduBk0cMZSEwHWgHlrajXHz3UH2jyxjXb7Bmt/KnzTayCdTbhy3qBDY61t9Xo/rDof1A6xRQRcR+1ACOJ57/zBrvWvs7M45hlLbjIP8SlV5F4i0VhFC4ZWt68wrbTIej4lJlmxFXwunHuLJSH+g5ItMgfDnr2xFC8xi8Ro5XvKe7FlN3oicQlQ6Irz7l8M2qCLklrZfLTC67/EedVpfDdRtFzaT346qBsHBFu1Ky+EWfpZA69+fYpRUqtiEI7Y0eu8Zdtt6/iScDvCForP2tWjx60eey/Z0oYJP5ZFxvar6tNzzRL84wpRKkhcLJugKi34d4N46cAA/eBcb8WOAPYK7hI3hpIGWm44AGY/2+CJTBcTg4y9f3OPsRz4ozE43S4vI3KBjDEx3WElhdMt/j//+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Petr,

kernel test robot noticed the following build errors:



url:    https://github.com/intel-lab-lkp/linux/commits/UPDATE-20250819-180717/Feng-Tang/lib-sys_info-handle-sys_info_mask-0-case/20250815-152131
base:   the 3th patch of https://lore.kernel.org/r/20250815071428.98041-4-feng.tang%40linux.alibaba.com
patch link:    https://lore.kernel.org/r/aKRJKZHgcxyNF3y7%40pathway.suse.cz
patch subject: [PATCH] panic: Clean up message about deprecated 'panic_print' parameter
config: i386-buildonly-randconfig-004-20250820 (https://download.01.org/0day-ci/archive/20250820/202508200907.PsZ3geub-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250820/202508200907.PsZ3geub-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508200907.PsZ3geub-lkp@intel.com/

All errors (new ones prefixed by >>):

>> kernel/panic.c:952:2: error: call to undeclared function 'panic_print_deprecated'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     952 |         panic_print_deprecated();
         |         ^
   kernel/panic.c:958:2: error: call to undeclared function 'panic_print_deprecated'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     958 |         panic_print_deprecated();
         |         ^
   2 errors generated.


vim +/panic_print_deprecated +952 kernel/panic.c

   949	
   950	static int panic_print_set(const char *val, const struct kernel_param *kp)
   951	{
 > 952		panic_print_deprecated();
   953		return  param_set_ulong(val, kp);
   954	}
   955	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

