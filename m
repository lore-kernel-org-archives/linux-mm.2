Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7818CA6009
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 22:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 822006B008A; Wed,  7 Oct 2026 18:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2A16B008C; Wed,  7 Oct 2026 18:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EAAA6B0092; Wed,  7 Oct 2026 18:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41C0C6B008A
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 18:59:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4C47403C0
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:59:47 +0000 (UTC)
X-FDA: 85297349214.04.794C4EB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80315C0003
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:59:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PpxkU0vE;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791413986;
	b=PloJJ/NUbB74mhoyn7J25FjHPRPt2xlSKshagH/3v6DGXNgfZhwASHTOt3tYzlkysD61Zw
	ttcXjInXlGK76rFqGGIFMUGkpnIq7Fz2w3qJVvIqExVxb6Pi/lpNW8gzhRGbYkKXeU35S3
	l6o7D6fbzLg92E+zkXUTa+YARk18y+Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PpxkU0vE;
	spf=pass (imf22.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791413986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=D1Ti37r3WJ8/qxZbkqTqQ3PPdd2GRoAw7AQ+w9AcAhc=;
	b=spmBSNKP7kJinPXk2+72eD0aEtugROA7fuPiitQNYRlnHO9t5OupGPTveId5FHv579HN5l
	jAQWSVPinwsuDZzaz4NZVtNgN4QP/7fHc3OQDysTvD7USxq5vdVt14PIs24FKz+pU8MwFx
	T7vb4/c2KEORsjBZqqhbp6pxzcz48JE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791413985; x=1822949985;
  h=date:from:to:cc:subject:message-id;
  bh=KcgdW8Ymou+cnYDJZ8kTaOBfDPR7jywHPu5lecoNAiI=;
  b=PpxkU0vECvQlEcXook+1cCRjdyIoZZsapyd91LStvquj3yfj9+nwMHw0
   xYO3UO28Jt1VrTSviJNaNRJ+2/6xI/gifmZtd/1l8Idak2LZK4WyDwM7p
   kfCT0smv/1EeocUjJMPd8KMRD+u2ycyRZE7c4uY2Wlc3r6HO6OmfSjH+w
   QKiNTU6oxW2T2T5h9G9XVMpUXOoxLQbD190eaSPabSamWwdE2/2qgn/Al
   /iaf05cr7LYcdYfvArBPD5uSbNewCz0+DWyxtWALrvjJDyAyc8FvnLpgc
   HhzEzIZML0QBxUDYjmWG+I3VDRWDeQVKn7pQo9bwACOppeq8tbiQzopKQ
   w==;
X-CSE-ConnectionGUID: x0JS5B6kQUS4OA4c2T48YQ==
X-CSE-MsgGUID: gpZ1WQFNR4WCLyGAVxig7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="297499"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="297499"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2026 15:59:43 -0700
X-CSE-ConnectionGUID: i7TyAtWVTS6k8jdjKm/p4Q==
X-CSE-MsgGUID: M13/o/euQh+TK6/UrC6d0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="1667944"
Received: from igk-lkp-server01.igk.intel.com (HELO d0de6c2a75a7) ([10.211.93.152])
  by fmviesa012.fm.intel.com with ESMTP; 07 Oct 2026 15:59:41 -0700
Received: from kbuild by d0de6c2a75a7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xEabr-000000004Eb-2U7o;
	Wed, 07 Oct 2026 22:59:39 +0000
Date: Thu, 08 Oct 2026 00:59:25 +0200
From: kernel test robot <lkp@intel.com>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: include/linux/compiler_types.h:572:45: error: call to
 '__compiletime_assert_431' declared with attribute error: BUILD_BUG_ON
 failed: IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT)
Message-ID: <202610080034.W7eXW61r-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80315C0003
X-Rspam-User: 
X-Stat-Signature: f5qo4dwxu7zah5ehjg9qk6e4oyrcigkf
X-HE-Tag: 1791413984-858085
X-HE-Meta: U2FsdGVkX1/IuLKRlo/wiN2oP7s81+NqBo2kcfDNqnngnHDtpYA/WTXrkVkSlvojC0r24hpZkUT6n9vJE0dRted6WCc2n1Pp+MXYwFUMdiqJ1t3nnYUplQcxsvg0oSlbhdlCKkzOgW/JSuWwHblW2QyRj3o0KAjGAI8UKJomaAs14EoOUpJZDjgJs68nQzYPAwxYXfn7BN4PZ1tANktI4mPCG8dEcsom+RD61xIhc4zdm3oOpCvE1V2U0iGj45F4UY0vW0cUQm/3+6rjVhOS58xGnHtsEkQXfvgkRzXQvIlSbq61eSi1yZRJs413U//cZHP6hZ4/PpxSHkP0ssuI7qCahyHe90pshq/3BKvva/d9g0pXt34yQyL5K+BYc0kEXpiEuuV672W4vR+ez3uR9k+LeofkoWlL9a07GZ2o7SQJ+a5B2liuv30zXBIqPgokTTpY0j4+7v19f0n2OtMrj94PDIf0sagEeAB6iATVBf1Fcyl2O+Q1Kiylt0rnreXBTbtxSGG7icT4w00yGB2cMAvL1gmu2NvMU+KvS+OdE0Sop7CA2O/EoVBGoSDCJcYMcJLUWZqrfYThoBVJUfv0RmDD/VuJDM39to5P2hA8/bT9OazvhubZU3/d7sAWL4S5VjUakAc/PXBXgvSnr9+3n4aG37YYV3wqGSjqoGHcFt/CB5Ks5RtLSlH9eqVsOnj5wX52iYg4O+HLxidMgnAg+zQiSga0wmuw9I6LslqcA7F8efYdKRq7xnaa76nSWAUYQuGAPmQa5RRK0H6uvxsNIQ8AFT8h38E+5A9PS5oj6CwbzT0JDOyKXB7Z0dV+mCAAebsQ01fhUJdhwYen/eRYzTidGq/OuHs2CafJNj5W8U6T/tQ6PEF1pUq3N/fim/jnL04/Jv8Mx3k3ALe6vTT4ZwuQyYgVv+Fy1krc6/gg2FD6GL7eoJ5I1n7cOBTXRl6/VGFlD9AvbzbCO/eknhU
 uXVe1cZL
 Yf5XoI6xfpLUVbWi7I1MLc4oHgijUPFsUpXNi7ucrxzFxXGixD6YJLv0rQpkvYrdo1cdAY1PiILsCSJ5eqP4bWXEEj7xs7BC+2cAuJxTfkUutZuSewSDWPoYQ81+z4rolKCskuLuU5PJtvza8hIlKRcc4foDToX7FD7Mr1vEJ63xap7nyu0nf2zzy+49IDQGlbQC2Axz6MWRY+xFgWiiIbpmQfr12+4u20C4TN9jN61/ZENZdRiDEWjD4phoxRuhgSRu/stFYW4B2UnjXMUV7cBkBKxCsNr0tLWGgDF5UKvJvHs3A6Tvph376Kh2SmEc55zYCBIDOsrPwxMWOCwdLGQWJKUXlyZ0Ggw5W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Miaohe,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   7b63ef2d55f24519e7e9e5f4d15dbea03f126e40
commit: c090868f59ce888db838cf543d18f731d13ed498 Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"
date:   1 year, 1 month ago
config: mips-randconfig-r2301-20261007 (https://download.01.org/0day-ci/archive/20261008/202610080034.W7eXW61r-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 13.4.0
sparse: v0.6.5-rc1
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261008/202610080034.W7eXW61r-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: c090868f59ce ("Revert "hugetlb: make hugetlb depends on SYSFS or SYSCTL"")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610080034.W7eXW61r-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   arch/mips/mm/init.c: In function 'arch_mm_preinit':
>> include/linux/compiler_types.h:572:45: error: call to '__compiletime_assert_431' declared with attribute error: BUILD_BUG_ON failed: IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT)
     572 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:553:25: note: in definition of macro '__compiletime_assert'
     553 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:572:9: note: in expansion of macro '_compiletime_assert'
     572 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   arch/mips/mm/init.c:434:9: note: in expansion of macro 'BUILD_BUG_ON'
     434 |         BUILD_BUG_ON(IS_ENABLED(CONFIG_32BIT) && (PFN_PTE_SHIFT > PAGE_SHIFT));
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_431 +572 include/linux/compiler_types.h

eb5c2d4b45e3d2d Will Deacon 2020-07-21  558  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  559  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21  560  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  561  
eb5c2d4b45e3d2d Will Deacon 2020-07-21  562  /**
eb5c2d4b45e3d2d Will Deacon 2020-07-21  563   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  564   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2d Will Deacon 2020-07-21  565   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2d Will Deacon 2020-07-21  566   *
eb5c2d4b45e3d2d Will Deacon 2020-07-21  567   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  568   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2d Will Deacon 2020-07-21  569   * compiler has support to do so.
eb5c2d4b45e3d2d Will Deacon 2020-07-21  570   */
eb5c2d4b45e3d2d Will Deacon 2020-07-21  571  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2d Will Deacon 2020-07-21 @572  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2d Will Deacon 2020-07-21  573  

:::::: The code at line 572 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

