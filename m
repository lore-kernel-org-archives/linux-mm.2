Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F013CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 08:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320876B0010; Mon, 24 Nov 2025 03:39:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1846B0011; Mon, 24 Nov 2025 03:39:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7206B0023; Mon, 24 Nov 2025 03:39:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7A96B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:39:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF1001602AC
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:39:00 +0000 (UTC)
X-FDA: 84144850440.10.F9D4F82
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf09.hostedemail.com (Postfix) with ESMTP id D5314140005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 08:38:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HWpQ5BFN;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763973538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OPfCmvzgTU+aPxqkSD4RFKKGWwazVYBT6hCsnbEQ8Eo=;
	b=JwTF61s+nAThFxpJdye+8D5+FpTiucehQutYDytwCfClX8O0yHxFk+3o3HRzLzU0AJon4H
	/vJhIkkujcAlLvtixM9mkgC05Y3/wXsHH7fiiEPqZIOpy7i8mSLPOIn6Mv3CDPqURMOLiD
	LGZBqTu4UHMbPTjJaWiw5Rb/W26k8TA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HWpQ5BFN;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763973538; a=rsa-sha256;
	cv=none;
	b=h41s5hlyTOnYqjCABzu7YjiaqrmPRse6Crp6Xq2z8Fjl9mdBXyKOLAIxvTuUviWcQHKYda
	NTAhDZZYuxHIuepsu7FUkqjuDEfHrd8q+N+8O4XgAuaeCSYZ6TXQwRMHueRReSo04d/ruu
	g7xEWC8pwnwXih0T1MtMoEKWn+fUGQA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763973538; x=1795509538;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=2C5rVuGkFTaSM2Oen8imI1+CyKeXfsB65iGjm6mbxHc=;
  b=HWpQ5BFNJi8g5C9k8rkWUkmoAVgCVvlVWrIAZCuhMd5WRqO+sWX0OXBH
   17kgh86u6vOtKYKGbV/wFgg/le4wWmlRejYTco8T+G8kQTpLhYIySSBEJ
   9UndV2jbTqn2yNtw9u0dHBV8xIWTMYAU4KZQYubmzrDymRKcKbcYFeSGd
   XFVP/Ir2SzBZaigwc+uFVczzrPFhZqZpmmDaD6/k/0o1yEz+ttOxzzzX1
   /SGwS6nuiApOL7eMVsFzdSqMgPEVSqLZvMtvzQxepiLGysRyDmIDziC0u
   DCnA/VXohN4q4aU6awcR8AxnMvp9pihKqZmMpmlLVOLFtoxvHcSI3c8/+
   g==;
X-CSE-ConnectionGUID: uZELm+dAR2+MwdnzUZ/OHQ==
X-CSE-MsgGUID: KDSGbQw6RPOSDB2iyciS4A==
X-IronPort-AV: E=McAfee;i="6800,10657,11622"; a="77329070"
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="77329070"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 00:38:56 -0800
X-CSE-ConnectionGUID: iQyDMvd9T0Kh8ams8KetZw==
X-CSE-MsgGUID: dCQFDI1aTq+/epFKcHcLTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,222,1758610800"; 
   d="scan'208";a="197391053"
Received: from lkp-server01.sh.intel.com (HELO 4664bbef4914) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 24 Nov 2025 00:38:55 -0800
Received: from kbuild by 4664bbef4914 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vNS60-000000000Wt-1wH5;
	Mon, 24 Nov 2025 08:38:52 +0000
Date: Mon, 24 Nov 2025 16:38:13 +0800
From: kernel test robot <lkp@intel.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: include/linux/compiler_types.h:572:38: error: call to
 '__compiletime_assert_596' declared with attribute error: BUILD_BUG_ON
 failed: IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT)
Message-ID: <202511241637.BoBE5PKN-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D5314140005
X-Stat-Signature: 7dggenadte4pr6y1gzkbmpmzsdfenada
X-Rspam-User: 
X-HE-Tag: 1763973537-344496
X-HE-Meta: U2FsdGVkX1/uw+7P/MaggKoeUsdOuackH9RRX55WBHVYx0vP4nhKNAwSDKWCiX8nNtRmFccaB4W4z1GPTz3aujLMeO8IsqkHJUyjqdSrXGk0XVKx9O4EQpQEmwL4uKPj7F06oTp+iCID4Z5JK2rOnoMzeHtmCkKvCWxD/hcLiKQ9W4XQp2o8EUSyremzRVFNLyPcBR/e8nFSc5xfwycQG6gAt6IOPIQoUHXgymvghRuvjdtLy5CpYe8GuiYho9RhSjHTRmRvxLJqhbEQ8RWtCXTDZREWDPdB1zHlSl6dEeLZGb0v8UodXhQZGy2HavVPNABvsb6fTOqQJtsjOMf/4MovJ69AJYYhy7/tyIaleFIy9i9/gZmLZ3n60MtojHsMZKNhNhX0er8l3SJHWfsDOTSZEt6552l0U/F1R3Kp8PnB+XJDzm/WPHE+0wP3Vof/2o8ZpbfhSWEoisL88HS5U4gQMEqTIij8rSN1QWsiI4tWavDf30g7vIFYISap2Oer58n7SQpDx8A2FLf/yv1i60/AQf3YUhsYj1Tpagtjypzd28xfbzB2gdz6aG+0TtAUhY03XlHJ4URsP3n6YmDJmrzVrmbfHyl3wKadplVosHhfl0zwmggeJGMGKtrLEPVOaGVfLaO3KkzSJvC4n2ZFrMz+L8QCXAddUObo3QMit90tD6t8oTxP2b1G0yaDdH2r7NQzS/QGWksmgwGxmzouTFXi8VHEQBLW2xLmQvwdp3d3gen+2qx7dkE9MxoTeO5kOStdkksDHkdgtYbWqmssNKUfwcWGqCXPX2kqVM8JeiJVz2VJXXNU3nWXqBf2lJumAGMAHgUGvZ6VkaJ6Nlm5vIkb6i0SPL2hwwR+JW007Sf95e7D4dnf3+2E3iUNSsj3HY1H4XAO4SrPi2hfHrqpSiGSab5jmqxIt8SeKDDxLaW8OZHD9EfFI13naELcn+oa4rghn+MjwlD7uZA6+lL
 plQmrk0S
 9VCLgCiTHEWHroFoqbh2qFYxqoOWwXj7PqngixDtsrLtBKhYQaV9hHOm/T88hkjluEFbujgUYGU5lPG70NbcAGKaS8jHFN8LR6dRvDA7ohQrJmc/dTPdmVbKVweaqMmqZM8cQxzG+iR0P4SGN7axzugLoRXDpFpfrb33gxalJpYn6HCG/D//QY+p0OWCf+ZmXcmUzVUcW/bAzprJJnwFgIshKBY0BD4Y3vunVgu8sqJAVAK8G6eR4f7UZA4aiMYinn1E81KU9yTG+bmNraH+6NEoB0yzML5wxY3ATODb5F4hno6N62KwMviGpWD+J0T0tZqD2x2vZbd8FPNdcwp1tzMEld0U8zcFXymeamf5Wf2DNk3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
commit: c090868f59ce888db838cf543d18f731d13ed498 Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
date:   2 months ago
config: mips-randconfig-r054-20251124 (https://download.01.org/0day-ci/archive/20251124/202511241637.BoBE5PKN-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251124/202511241637.BoBE5PKN-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511241637.BoBE5PKN-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   arch/mips/mm/init.c: In function 'arch_mm_preinit':
>> include/linux/compiler_types.h:572:38: error: call to '__compiletime_assert_596' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT)
     572 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:553:4: note: in definition of macro '__compiletime_assert'
     553 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:572:2: note: in expansion of macro '_compiletime_assert'
     572 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |  ^~~~~~~~~~~~~~~~
   arch/mips/mm/init.c:434:2: note: in expansion of macro 'BUILD_BUG_ON'
     434 |  BUILD_BUG_ON(IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT));
         |  ^~~~~~~~~~~~


vim +/__compiletime_assert_596 +572 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  559  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  560  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  561  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  562  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  563   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  564   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  565   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  566   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  567   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  568   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  569   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  570   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  571  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @572  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  573  

:::::: The code at line 572 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

