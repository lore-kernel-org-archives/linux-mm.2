Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 121E860A3810
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 02:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=VQ76/E5b
Received: by kanga.kvack.org (Postfix)
	id 05F216B00EF; Fri, 20 Nov 2026 21:50:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F486B05B0; Fri, 20 Nov 2026 21:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68646B05B1; Fri, 20 Nov 2026 21:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0C156B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 21:50:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 359511202C9
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:50:41 +0000 (UTC)
X-FDA: 85457598282.30.F229487
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id DEE34160002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 02:50:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="VQ76/E5b";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795229439;
	b=xEqWPMxCe5vygEqbP86FnUKiI0apP5Iyw5qFNcUjQeNZl1JVGsAxlFn1P2AP38V+jCJun3
	bTm4gnOocpsRjN9AMKQnoiuXew50gfXXltXwqvwjIxvobz7zZOGvYdABTmYcvBiqj8Xklf
	quesjjejYxCH20YfJ1W97vBTRaa0JZk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795229439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=yCBx/Es5J3SUpzkPHLi96/E6VeKicpxhtWzFsN0S05s=;
	b=mOvCB9wKnCqF3mll2tRUd3EqgMdxAOmhPMTpxsdDbpOeOcRBWeQfYxKlim0el0jI17s27c
	RaEXla46702rfCXMYL9Iq5A3ZdrgYxvlhUv+50ogW/8TyYaN9L2ID7lbnf2yKJPIMhUikZ
	+dZzDROTuhtJwH7UUhkQXork3eAYgFM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="VQ76/E5b";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795229438; x=1826765438;
  h=date:from:to:cc:subject:message-id;
  bh=TDLJr6QVq3+vLPLHDt6l6qsY3dWRPIJ0JtuQidSGitY=;
  b=VQ76/E5b+/1bxYo9Jl3NmAKnDvcKh9u+o8q2sw71jOXeNABbU4EXRnZa
   KqUuecCIrN0WO4+bs5HZdin0XMkwDWLK7okWW1SHL/B4WUB7wPBLy1RHI
   VRTtu9Bhkl09K9Z2V1KO/SR18cZDN7qabgis8Y2ZzyLdaqeCranNEg1V6
   kfEHkqcS94+BMh296INIz31ca9MqJweZwNsNsV/ogRWYPGYLEWvBYN+PE
   +ergRlZfeAXkgeKxzOrgQWA+xf9hs55dS0B5nAghcmnb7YDTy4tYavBob
   edhWyKin0ZF1sBN8IMunZQouJsG6UW0/oqfnHfHKa4Yq2lJWZFB5x9l2N
   g==;
X-CSE-ConnectionGUID: HVM2jRjIQXqb5HZUy3gAtA==
X-CSE-MsgGUID: BIQWaG1pSumFW/AAFb2qnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11972"; a="4123672"
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="4123672"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 18:50:37 -0800
X-CSE-ConnectionGUID: 5I0xCVAlQV+bbAFU7HqWoA==
X-CSE-MsgGUID: YYarhr3WRNuvt5SpkxVh1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,224,1787036400"; 
   d="scan'208";a="11166986"
Received: from igk-lkp-server01.igk.intel.com (HELO 1073a420ae3a) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 20 Nov 2026 18:50:34 -0800
Received: from kbuild by 1073a420ae3a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xUbBO-000000004Dd-3vC1;
	Sat, 21 Nov 2026 02:50:30 +0000
Date: Sat, 21 Nov 2026 03:49:59 +0100
From: kernel test robot <lkp@intel.com>
To: Finn Thain <fthain@linux-m68k.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Arnd Bergmann <arnd@arndb.de>
Subject: include/linux/compiler_types.h:631:45: error: call to
 '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Message-ID: <20261121034304.2dPxVKzk-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DEE34160002
X-Stat-Signature: nw8xbg7pxkn3r8ot8s4zog4wt18f9r9u
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795229437-136906
X-HE-Meta: U2FsdGVkX196bYmyneHPekYP0LkCjRRzl6+EUz5Kcy8Ktqd+QBvDtzY3Ssx3buHQ9p5DHRHtXePy697qNbcrafObjTxuKiNhQgs+OD+3sWBxRqKiwUFtrOQcq4KEoE0U5xthcUeNDmDj0vpzsnqG8FbGv8r5DBXEMOr4zyaMhuX87dLf1ZbkmsY/kE8N3HwWAvgDajAqZHjlawtpPnIRT9ti2dKDE/dwpLIVWELdhyQ1mmtOH0UGKoXxQ/hOtW6HuWVB7CfrbUYWhom2VkQ3c/nOkICz0I9P5pT/cIR8B2I8DIHI07IqIhNXj6tdso8e/ydSaqYoesoH7tNvVlwndVydKqhv/UZBNM8MmuyRFex4zKXhL16ejUdLEj8EEJes+2qT+ZUEDXHEwBSnN8kiYGTylS7B1VxFGCyawA1bVxMS2eVwoiwOkPVqK9brd5C+UC49kqT4xhj16hJcqt8vW2uObRTNf0OzQVO9Yu+Qd8Iiea0j/vmWuKOcP4GhdXdWoXlTBhw2XydLsIdctvlhTJoIqzUlgF/aiTvcYj16fygb1Col03RUESVkt3SQ4dsMpLSFyabBQpQlUOWdolW1bTetn1eFzoK7yCx7SQIHaJUfca2K+s7juiyL8F2bY0gMzXQzdiHZuoQR5XPOoy77Tj6+P377cQIZc7AUIMrSmKixjZJbDAtbWFclq4t5iVr44e8TCINhKX/3fQukWUpxUKLlgE44PjDHJ1nQYTowPyukKmrcZfwGRKrrIzz2VpFLDUHOCQGOLHVOM5ABNO/rbQNo+17u9jibGQYaO+uUHQ+xQcCHW45Mk70HgqN7h3RF2u/PDKmft47+AumFYrtPg7t/erCe9C+MFZODX2eTRaLVxYl5ECaaHjPOr9ljxfILcDrj3AZKSfWzVQf4ykbRhPA1KRyUx8IRdBiYyu7YzY/S3V3Oh11Rqvf4NLMAueRlOx4MeBZFWoaFUH0KJbU
 O42ibBnr
 0QhILD4xRTX+nEJW565Oact/d6oGy1dRTsaz2r4EcayfSMkJFkA5QvhFgCboSpHAmMJYjOgNtRKznGeBMn/YmyW7JQu1KDfx539WIhTDc2UyAs9Y7J6j+4VddUfox1NTK6hsWkVARqAkTudiZJxNOmChG3G7jdUgisCUtB+TIGO7+OKYGnB9skX6JKEJyoL+jd29Ev1Xam2dMOsb0xjdzUIiJ1OwNFJG2cclYL+w3gE+iWkhjI+KS3P43rGv9IGbiL1xgTTbx1Z7kmxpYgjHRsMkk6ERCYkOK6lwmQS6f1rTDL44oOeBj/WDUGANFNUWb3aL7GtjNrhp691zC0fvimaiov9pffPPDZgAL3HKTi/S8aEK5uFJP26ms4rQza/mTw9X9mbdkkPSsHOOwCRYWhOui/s/EM++Yi8gF+LQqATAw6xDY0n9TxZpE4UFnyy8GLVtpVdx4w+2cpe+TfyDgEqRNjfTsVb0as5Vd82MOYXYnKoKtZCyXP8/IsTqZu7DtXX6/8XFYvRMZk29fzrswckYT0i8nJlIDDH2ap1c7NIYPw9/Wr251N2lCHZduMpbnyl4keSCsuMLZSnchs97QGkwruqvKl8UEdRNt53XlmBCEW8UAC+zILlvk3Dcd4RMX48cxVX83vLu2Msw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hi Finn,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   5f22fb20497f4983094131f00a734362300d22d2
commit: e428b013d9dff30f7a65509e33047ba975cce8ba atomic: specify alignment for atomic_t and atomic64_t
date:   10 months ago
config: m68k-randconfig-2000-20261121 (https://download.01.org/0day-ci/archive/20261121/20261121034304.2dPxVKzk-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 13.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121034304.2dPxVKzk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: e428b013d9df ("atomic: specify alignment for atomic_t and atomic64_t")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/20261121034304.2dPxVKzk-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'qlt_queue_unknown_atio',
       inlined from 'qlt_24xx_atio_pkt_all_vps.isra' at drivers/scsi/qla2xxx/qla_target.c:331:4:
>> include/linux/compiler_types.h:631:45: error: call to '__compiletime_assert_433' declared with attribute error: BUILD_BUG_ON failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u)
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:612:25: note: in definition of macro '__compiletime_assert'
     612 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_target.c:216:9: note: in expansion of macro 'BUILD_BUG_ON'
     216 |         BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_433 +631 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  617  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  618  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  619  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  620  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  621  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  622   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  623   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  624   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  625   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  626   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  627   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  628   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  629   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  630  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @631  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  632  

:::::: The code at line 631 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

