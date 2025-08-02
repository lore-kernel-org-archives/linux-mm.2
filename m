Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D3B2C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 00:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3410C6B007B; Fri,  1 Aug 2025 20:21:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0496B0089; Fri,  1 Aug 2025 20:21:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205D36B008A; Fri,  1 Aug 2025 20:21:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 102DA6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 20:21:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F96058A59
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 00:21:41 +0000 (UTC)
X-FDA: 83729914002.03.7B59580
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf12.hostedemail.com (Postfix) with ESMTP id 80BB440005
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 00:21:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="eyyEC/Tt";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754094099; a=rsa-sha256;
	cv=none;
	b=DdKU1LCVqZ0ndy4Zqiqi/l6UNoQ8ZUw3VC/XwF3iXMyEPFXtB+/GaWTp9PbXhi3hVo+ZMy
	OVA0MwvROIboQlYttxNckTqDKfduGrKYv6eTsedT2vPUGw8xTTpMBo5d1xlOjJVYDBkcFM
	5jBACUAd5g6C1cUXygtPnWv02lx2ddQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="eyyEC/Tt";
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754094099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MpYOGh4qgwo1vvX6B7G/NV6bFJg00FDsqoBgvnrRBHE=;
	b=DwGYR/8qWD9wbMAcRqCXhmxxON/N2IqdpZJiKuDik5a0vjI5JfGUU/D7t4I6zhdeh7/GRS
	sxMIl+Tc2scRLGVq4R+iKeOcUuqi2copH2VT3wSGO2rssnMeSwxNo8f9qDsW6WTE7s+RA+
	bOr3StMgsC3VPX6HObijSWDH8XiA5PM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754094099; x=1785630099;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=L5P8ubLtAZiGZ0+X+Jg9rPnQ5eZQ0Ngv0hj7RsufwaA=;
  b=eyyEC/TtnNBWWoF+YMKaqYfxJl9ckmZV1EVfIH/pya3kfDDmli9gGkIU
   QwY6CvFsptM6dssu1BhwHtvTAftgmw1Pe1fNzkkZZiCKM77f2gYLRrCHy
   qBR9rRO2gyXuy1u0DjzAxMMZnZpcfhrDcY3GzOQCzztcAy0OxeD1WBZsD
   85tsYBierT1LdwGnPvtX25xdqIS+VlRfWeTSMhik2HqHH5ZKE3py3k0YX
   HqwQRkIndAJfFsjUKEKREo10zW1QYE1RyuAgE8qjs/Hx/64BSXi//rF01
   ACYBwuPf44ScpYKdAM+YZ6Bscm9Lu8QefHSFBpqbtWObBl9U728AInjk9
   g==;
X-CSE-ConnectionGUID: m2dTultZR0eDQ9FBbXVXbQ==
X-CSE-MsgGUID: IVhGki+2QsqYtJ7ywb33Ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="60085599"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="60085599"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 17:21:37 -0700
X-CSE-ConnectionGUID: 67ysIogySE6ggPfWoMVKKg==
X-CSE-MsgGUID: Z7i7rOD8SHiLVCc4B6oC1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="168160504"
Received: from igk-lkp-server01.igk.intel.com (HELO b3b7d4258b7c) ([10.91.175.65])
  by orviesa004.jf.intel.com with ESMTP; 01 Aug 2025 17:21:35 -0700
Received: from kbuild by b3b7d4258b7c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ui00C-0001KJ-33;
	Sat, 02 Aug 2025 00:21:32 +0000
Date: Sat, 2 Aug 2025 02:20:35 +0200
From: kernel test robot <lkp@intel.com>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Igor Belousov <igor.b@beldev.am>
Subject: [akpm-mm:mm-new 98/98] include/linux/compiler_types.h:568:38: error:
 call to '__compiletime_assert_279' declared with attribute error:
 BUILD_BUG_ON failed: ARRAY_SIZE(block_desc) > MAX_TABLE_SIZE
Message-ID: <202508020214.8pUMOfI1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80BB440005
X-Stat-Signature: gagtoshjme69dhz75zfmr7p46r4pf9g6
X-HE-Tag: 1754094098-725862
X-HE-Meta: U2FsdGVkX1//sxP19uxG4wRONvwSnOLegP5Jff9Fx1bMGRdFL4emZ8ea49P6wyLCmfEwsojH9Fm6LHEiL/VlwsV+yH5PX6MVRSYJubwKuVnQ5PVKwP4GuNNYrYCQZhbKHbGJq6n9Yk6N1kMko4Brbk1SteftPGiCm6jjW98aeOnwiOh8/zqmjejh2oIknP/rMt+13TdBIhKj9aEcdj2QO7QZMNOqeo3QtGdQal0t87OlaJEQatgIxiS+EqbIygQyGRczJIO5SGiMGyt0kwzGl7gO/lvc0XFdp41ewQK44p2XILyQQa3iPBgMO3x25Rc42ewOkoltd3cJ281J3wt2YCQaAqFujruj7LZOHkHa1CUt/p6WnBBgBhhKP+wutjfxqp+OGsPTM/EAKOOVLaKJBTnrJQY74OilFLZ/bkWsAWOxEOMvJrzoMAwaSqKkvHOXyfOtBQiI0e0DdHgbz2iQkV50FHWIuLpXMpwmi7afwK0GcPc3IHA856A4qWayom8Xb6F2BdmvuwWRMSE0FBKgxPE5jhyK5BMeMltlOiKQ8IY/cgVtgkadP1C803D02yqqYJVfOFVD41gXyPRg3jbBBT2iK2HLaJX0xaNiZgPdolhlchWm5MrTtnaaBgbh1Iu98i/Q1b9viC4KwX3scY66+bijHkQpCWfGs4uJF/HxR0X94Yh/TWcgQUFoduoc98eR6bIM1Rmbk1OkFD2n/k1YFyfs23yvgOurCbFmpPsvS0y7Q9bsNflBbUm+S3AoFOYq6bVMGX91fhEmTlsOvvxTaijEKqNhlg28uGvDKuGvsiwtAtgOcn+gbBRNzrHrdCR+OR4wMNRYrDoASjFH2stJX5lna5Vol+PM+Lt6ii6x2J2vjMLcAt5xhUQl+zDSLX2sGw22wgjUCt2VaqvWXfvzsEqz7MYTyyUfE4pbBS87cB14xUq+xRmMZuwj2Y9hGSddFQc2AB1tXLmoHO3Rrup
 fzbEalwA
 1OZOjz4mc2Ri23HJhoUP9Ebtq5pwOgvNiQ+SQcg+oE9sOXzykKN51dF1VBlUkUZEJ+DpN7rpVFG0g6DriRcd0c1Itt+c/DClZLKKF9vfOpYfwtqBl48ovc4Ab/37YNpa3rsubANETw1EQz9u8sY3P+XsBB65Wgq4wA4qGbZaaUZdr0l4n9NWcuFGBByBM9DlFUHbGFqltosH9tCfyMyZU0Fkz6QphOvBLnOWJnbl1DolZMqBBYE7zVVCMdFIXyxpIQFN9aEu5loERf8VWFFglw/4qkwW63cETlrJ2CucveGYxCWy36prbf/cLXyamVjw+iJbqmvRd2lpAcwwmLPyCBL6PZRDUcckv8PpnUWLHdC8rbFfvNALQ1gkeRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   4e5e9d156393a3e06172b0c5962644c96c6f7f7c
commit: 4e5e9d156393a3e06172b0c5962644c96c6f7f7c [98/98] mm: add zblock allocator
config: sparc64-randconfig-2001-20250802 (https://download.01.org/0day-ci/archive/20250802/202508020214.8pUMOfI1-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250802/202508020214.8pUMOfI1-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508020214.8pUMOfI1-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from mm/zblock.c:29:
>> mm/zblock.h:21:2: warning: #warning This PAGE_SIZE is not quite supported yet [-Wcpp]
      21 | #warning This PAGE_SIZE is not quite supported yet
         |  ^~~~~~~
   In file included from <command-line>:
   In function 'create_rbtree',
       inlined from 'init_zblock' at mm/zblock.c:450:12:
>> include/linux/compiler_types.h:568:38: error: call to '__compiletime_assert_279' declared with attribute error: BUILD_BUG_ON failed: ARRAY_SIZE(block_desc) > MAX_TABLE_SIZE
     568 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                      ^
   include/linux/compiler_types.h:549:4: note: in definition of macro '__compiletime_assert'
     549 |    prefix ## suffix();    \
         |    ^~~~~~
   include/linux/compiler_types.h:568:2: note: in expansion of macro '_compiletime_assert'
     568 |  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |  ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:2: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |  BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |  ^~~~~~~~~~~~~~~~
   mm/zblock.c:415:2: note: in expansion of macro 'BUILD_BUG_ON'
     415 |  BUILD_BUG_ON(ARRAY_SIZE(block_desc) > MAX_TABLE_SIZE);
         |  ^~~~~~~~~~~~


vim +/__compiletime_assert_279 +568 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  554  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  555  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  556  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  557  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  559   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  560   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  561   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  562   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  563   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  564   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  565   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  566   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  567  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @568  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  569  

:::::: The code at line 568 was first introduced by commit
:::::: eb5c2d4b45e3d2d5d052ea6b8f1463976b1020d5 compiler.h: Move compiletime_assert() macros into compiler_types.h

:::::: TO: Will Deacon <will@kernel.org>
:::::: CC: Will Deacon <will@kernel.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

