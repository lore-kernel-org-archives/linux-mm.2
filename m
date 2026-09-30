Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03164CA5FBA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F019E6B008A; Wed, 30 Sep 2026 07:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2966B008C; Wed, 30 Sep 2026 07:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7F06B0092; Wed, 30 Sep 2026 07:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A92096B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:05:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33CCC14064D
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:05:49 +0000 (UTC)
X-FDA: 85270148418.14.F106EEC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf23.hostedemail.com (Postfix) with ESMTP id B2278140006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:05:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mPlYje33;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790766347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=S40y1xWu0xX3iT4AGczGo5PSJOGNJLHzIE7u9otIvXQ=;
	b=pVzCecY6+PTxYzsix7lPSYdRkuvDIAdnVNPeMoMtE9nZeXEFKcEnTjk1ClHkkqqAuHwjYu
	IPHixCSOXHAiyMbykdgJR1BOdq0RMFTc17HSM+PWytqHPxYFwERZ7IF+b/fEUVDEwrACwS
	RoKiiv5ff2+rjfAQVPQ9u6mXkftCfYI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790766347;
	b=ZSNVTP7AcIvYuVJL3pQThqaGgdaQWPjf2ZJVY5L6jqu1u219Hzz+pXHi6uXOCoyQL5wWAl
	tQAauQBbUHOYc65FaCzp7dQTzxiekH7FhZIFQa+3dCt4usoFo7oLOR4cvHzHM8WoOHSWGp
	eub/7oDPX279luHOSCpshbSQr8EXXYI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mPlYje33;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790766347; x=1822302347;
  h=date:from:to:cc:subject:message-id;
  bh=xb2F7yY761Px570aTEq8Hu9qlrKvIEJumXMxe/XEzVU=;
  b=mPlYje33B+vRcaCPFZ1lfnv9LhHrNwWe19iRaQ6ojPwcnJEdbFnAUMtn
   kjrgvnM1OrOmB85m5nZ7+Qyxy8iofbyEAuUztRzO4Ld9U44hhpV7TckwW
   y7ubjKHURBc1K4aNhaGGWz6NvDC4sApnIKj/zF23GBj1dqA7F4I19/ziw
   iNJOZNqR/LzDnwkt5BDD0xmmIj9mPj6LQp5cArfeUKJUYJftu4YWRPK5d
   2tbme6GtbGhV5VawguuahRcdZxIOeUokMXexZxP1qx+OdwaPrwVR3HRcV
   0jpq0vH1ifOrLfrkoaIj1u5sHIqOm6uaeRQJy9iHbsNXIXldgA5UYgYVH
   g==;
X-CSE-ConnectionGUID: orV3JnWrQJ2EOLI2syzrCw==
X-CSE-MsgGUID: rSA3bVXQTRGNGrHz2eb+Jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11920"; a="90542145"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90542145"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 04:05:45 -0700
X-CSE-ConnectionGUID: pN/9bqPISt2dNIqNy9TQtA==
X-CSE-MsgGUID: Y/l/7UGaTP258CGwh9vqxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="274271720"
Received: from igk-lkp-server01.igk.intel.com (HELO 04362d00df5a) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 30 Sep 2026 04:05:43 -0700
Received: from kbuild by 04362d00df5a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xBs85-000000001q3-0Qlh;
	Wed, 30 Sep 2026 11:05:41 +0000
Date: Wed, 30 Sep 2026 13:05:34 +0200
From: kernel test robot <lkp@intel.com>
To: Finn Thain <fthain@linux-m68k.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 Arnd Bergmann <arnd@arndb.de>
Subject: include/linux/compiler_types.h:631:38: error: call to
 '__compiletime_assert_424' declared with attribute error: BUILD_BUG_ON
 failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) !=
 sizeof(*u)
Message-ID: <202609301230.CauIUXCF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2278140006
X-Stat-Signature: 9j16u13qxy8s93nqmfteyj3jstjwdyyj
X-HE-Tag: 1790766346-847776
X-HE-Meta: U2FsdGVkX1/0OOLuiRzX+npwavD62lfiACEKRmokCEX7Q0DOmI0+uqYXPuP1YJjgpiv/+JVUHLlAi9Ax+dH4vd+36vI0L1XywqX0Yi/H3sw9TlD0igxy9Qw60ZKwLxUXChmyyDo9RMXSd3ZXXSBKL6f521QdbS0ZCiHrmLR/p9KEXA7FZnu+jX4giG61M677bN+PCv1XcRejzkuptbRnSJJjDtfizTtOTDsF9UY9afvrR+ux5UX4nLjOdNtF9HqjRmAr2U8s/jvO87Qb4YSE81eEnaeLn038btlOaPX0cIsZbA+jYO2Zwa9p4KDJDN59HV/3giNjwIJ671cCain8paR/17tB2uhlgng2wL4Uz5nEPiCtlkuPLueIN/kFc1r2KSrUHDCfTekZ6ZhECMBmLJzILlE3NaZ8Wz/OfEfI08HRGoEC/+eN3D8aqAbpoZHp02cwl+lyQKcdp6aIfk8igpTrc97pVysAGeGfweL4+k3NNqEK8dHlXEGtgOzPSxJXMwZIAAknvz+MrQSH83vsCt2nNSMq6Ec7Fs374X9SClqvsn2MS2zw/DuSHxQqV2U04PoaHzQYTdPCAHwpYBy/cpjK5OAMrTo3CrLiI4QSzaGKs9rNcw09tS6Av1DLKGBmnEby/m6bMY9Uo7Lo1NYuKRS5PXLgkv+Z3OeVlRfDTZzvDLEJxwla8SjwniobPNcrQmMX71/0e/YEjs4RRd/rfOZSSCHwlWxBEdRh8IW5usc3ORIjOP3XferkBcPw67oM+zdx2CvrvfMjWAt1BbwWhiZDcEGDfp6Fot5XIcnpWJc7NKS9wb0ZVaUtcJmZO5GHK1BAth9lxK4s5BSmsvEDSJcJqi15/aT+/yfYYWwfbBsA9XGm5cNvneT41b/gEAD0rcdTCMp6Qy4aeA2SBc1+eue5bTIUuy6KdmYxtcJRw6yHKBVHx2wv0zuxdBrPNFWdlL8grA2THBTwD+vxC0p
 BGwujhiI
 Xmw45WQnFsKm0VcjwzG/uDhkyELf7aNbzGMtLNUuNUTC46bFelKGRHtAoT8rAG/QnjcU5ocfpKZcNWhGOEyTqlJXFB+SMFD9MvDG+z7DjCkXE7qBZ6j0j6Pwxqd/KFTRFhpHSXoOorNaqRM4mIukEZlKy5inO9wURdFRBFOyJSyaVTzimg3J0xrnruMB/8NLblT8UA4a7MHst2cJzIFI1nxeZ/AFj3IGkWtB7r6IpWOna2KFjnhw+tV3nfU0w/Jdfv2t8h+IbPb177pN6rY2apToA0RGp39gebQ15hyT49u9Qgk5qrj+VOYdWVLcDI90l7LMvzsxj359WZMcvW4t+t/IEOZAQRI/Vu+U/sK7hjSU0Lr2ZHd4jaEToPACWaRz2ZEQ9bcTIjDEpz9Si+6RPxUAMpr+oxGtbGDFM515cXik01DY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Finn,

FYI, the error/warning still remains.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   551c722f40809618230001baccf219193e22fc5a
commit: e428b013d9dff30f7a65509e33047ba975cce8ba atomic: specify alignment for atomic_t and atomic64_t
date:   8 months ago
config: m68k-randconfig-r2102-20260930 (https://download.01.org/0day-ci/archive/20260930/202609301230.CauIUXCF-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260930/202609301230.CauIUXCF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Fixes: e428b013d9df ("atomic: specify alignment for atomic_t and atomic64_t")
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609301230.CauIUXCF-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   In function 'qlt_queue_unknown_atio',
       inlined from 'qlt_24xx_atio_pkt_all_vps' at drivers/scsi/qla2xxx/qla_target.c:331:4,
       inlined from 'qlt_24xx_process_atio_queue' at drivers/scsi/qla2xxx/qla_target.c:7903:4:
>> include/linux/compiler_types.h:631:38: error: call to '__compiletime_assert_424' declared with attribute error: BUILD_BUG_ON failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:612:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:631:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
   drivers/scsi/qla2xxx/qla_target.c:216:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
     ^~~~~~~~~~~~
--
   In file included from <command-line>:
   In function 'qlt_queue_unknown_atio',
       inlined from 'qlt_24xx_atio_pkt_all_vps' at qla_target.c:331:4,
       inlined from 'qlt_24xx_process_atio_queue' at qla_target.c:7903:4:
>> include/linux/compiler_types.h:631:38: error: call to '__compiletime_assert_424' declared with attribute error: BUILD_BUG_ON failed: offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u)
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                         ^
   include/linux/compiler_types.h:612:4: note: in definition of macro '__compiletime_assert'
       prefix ## suffix();    \
       ^~~~~~
   include/linux/compiler_types.h:631:2: note: in expansion of macro '_compiletime_assert'
     _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
     ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
    #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                        ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
     BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
     ^~~~~~~~~~~~~~~~
   qla_target.c:216:2: note: in expansion of macro 'BUILD_BUG_ON'
     BUILD_BUG_ON(offsetof(struct qla_tgt_sess_op, atio) + sizeof(u->atio) != sizeof(*u));
     ^~~~~~~~~~~~


vim +/__compiletime_assert_424 +631 include/linux/compiler_types.h

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

