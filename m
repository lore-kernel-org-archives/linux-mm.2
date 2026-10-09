Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA523CA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 04:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BC96B008C; Fri,  9 Oct 2026 00:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73DE6B0092; Fri,  9 Oct 2026 00:07:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB0E36B0093; Fri,  9 Oct 2026 00:07:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A29D46B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 00:07:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A704E8025A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:07:28 +0000 (UTC)
X-FDA: 85301753376.14.BE3245F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0A8F3180003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:07:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cj2zbom3;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791518846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iwcGqGdTDHIjytocN87mMF3yjoMswGkvQbgJfFrcMXk=;
	b=n+DVtn0USeht2vzrERPFh2znR8aP723KX9R9IJC16CuvIQf8pDFmjdpHp1RV3yUrOnIo1V
	vr86HHzHblYbPi0Dw2k32X046JBns5d1Vrr8AVyfLaaBo1qQcHdEwe7/9xZPBnVV8z4jTL
	MZmZ6/RQoqFyboPyWXBrlKOagQr/wcQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=cj2zbom3;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791518846;
	b=u+EtoS7O88cBeVtbP5aMh8GonDohtDrprdshZQ550qrLQIwUBK1whyI0da21KRTUkBYWz4
	pgE38F7CTOAkLeIkTTaxtzdDxuZqsOvcM30cVgIaQvGyBSjr0Aprkg90+RbhVHh9Fg1dcD
	WrYKU8kBtWgHHh7kIXwAAwDq744NV08=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791518846; x=1823054846;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KNNMfOfVsnDaclgG5s2TFg+2tuPZm5iOCzucHJxLHbM=;
  b=cj2zbom3utWNakaMXZJQQKDFg0nwnVyB7fTU7pdsZgxNnRoZAxTJkIh9
   gwz89rJj/cKcpWoBxd+7DZthga/OVMaXGuNrKasDMGGCeUerV9MNzwEiy
   s4LFtlJ94J1cpqABe1VcLPuPkntYxD6KHgEly8qoYMEUfmFcplP4btJ5Z
   rO2eZn3uYFLODMa0rh3rPA+EqMLkWr3t3yqEMIHG/rkbJioF57hZQvdtX
   XGSsoBMSb0YYiKqJGFWrrVrsG3NM1LnLH3doGtOg9UBwIFyHHxjOoDaqi
   qJrmwtztzy70SRGAGlJLqNJ0GRmIXUb4X64ABvRLYMbrIH3jWhh28N6yu
   Q==;
X-CSE-ConnectionGUID: j0siIelbRDiHeEI/GAqerw==
X-CSE-MsgGUID: 5zrRVqLPRJuaK0m5gtIdkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="200669"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="200669"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 21:07:24 -0700
X-CSE-ConnectionGUID: cxo1EygpTRm9NADGPwp6FA==
X-CSE-MsgGUID: 2tTWJiAjRY+qp0jFQq+hTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="538169"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 08 Oct 2026 21:07:21 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xF1t8-000000005He-3wPS;
	Fri, 09 Oct 2026 04:07:18 +0000
Date: Fri, 9 Oct 2026 12:06:23 +0800
From: kernel test robot <lkp@intel.com>
To: Suhaas Joshi <suhaas@s-joshi.in>, sj@kernel.org,
	akpm@linux-foundation.org, aethernet65535@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/core: Copy only installed probe in
 damon_split_region_at()
Message-ID: <202610091227.PIPVB0PW-lkp@intel.com>
References: <20261008151944.113714-3-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008151944.113714-3-suhaas@s-joshi.in>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0A8F3180003
X-Rspam-User: 
X-Stat-Signature: rma5xeuea43xec61mkwfuadqt734dybh
X-HE-Tag: 1791518845-750881
X-HE-Meta: U2FsdGVkX1/ADx0s9Ev1U/oYV0bGco8j7aoquG7s6mFAqapJdWqqXkxSd2XPgOBgmAK3iN8qdZV6jl1+K9zdzwfTy6P6c1cSblNO5P2AwVuBfpdPD4kCq8Drr0ChrtGpLKPDOt96/knqiGwsuMebq0Pf7fjBjdzBcLN3jus4+W4aosL4fs4AiTh55Z9Lzhwp+5E9SHJVy3oOFCGt8bZA5HCVXKdfMVtx6qXjlLpBn8PbyBmiP/ZkYNUi5YoSV8Jvfv6/slXNonw841Bk925z2VIZLdGaG1JQL/xvHPY8WVeGqK6s17y2WKhx42OqXP/PM0STww0Vf5yu3kHfzOm4/TgDVD0NQZVUKPj2LpL+scwCewQJbT4NFVFeWyEnQPoSniEkx/sIULVcNPx4vJ3HD1lP98k+bKj9dSWbmGrKPxRo+ICMimqjDz3mbWTWhb8xZ1vXSLpbe5kuUTx+7gCPvYB72MUkiBMlHVA0Oot9j0orHhdedDcDDyKutfcqpa3BSosz7LKrvJgYSlyeQYZvAwmmVTE4awDhtvMTi/23GIleo7JIRoRMo5OVkt+DtFYYENEeb2MpOilbdxBtEyndeyX2CORaUUX1kupbuS2lGsnZrzJjF4AeLbS/nPBfL/6PZPu2iqSN76SOKQSD2JawjWDueGk514+pwoomXmfB3kq5s2On0BY2226HQq4JuZi+NGPe2035vAIe1xW+ex2i1jXYA88DhrLhL0+F/SFjxNphzV4YXBGRWi9gP3t5PMyWKR0lkqksm8/rbGejdUaSPM4Q5YNNAx9MZmwTjS4GuXcdCAsFsItziMhpIal5D4cLctP+XVnU8uT5FgZLivYx1drc9HRfJZNARp+4dfgPlyqVDdvxD4dxVTR7aVslTiYArprti1gX2qnKSw4LQzvZsiD/WJVhnSw2QjMy1cw2YZIbhQ7tZa9pSvTZd2W+2euD5/B3FCw9Z4b9t4rngQ8
 MG78XdRf
 rSgQH8gmdxl+gubx8bY1Thi3a8ydBimsXhTc2Y/99MwPT7eEV5/TzOUbdh0hvf35VYGSRUzkzBLjyakeguWx/gnwbUKV/clqdfeA9Ap/qCevgb+E+i8TQ+idJurM2TXxZf+H3fXnaWNeGnHPJLCxumiLeDmV4zv2LYynqrbhZcA6KonI/9lgfeWc+of/e2IyMhsl1RsMFnwdbaJoMbyDLgpnNlHazGcgGcsCNhfbbBOUAvmjxlMndhJP7lCW/AXa40+ellVI9aEOurW0wd5XbJigIJhwP3LifGlkqb8Kw3gnK2dzmrBUaTovKP15BBaJ2Gi7RHyvmeMalLARf6ob5peuPi+8INnuacj49iJQjC2xPxJa/9S3wXySWDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suhaas,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Suhaas-Joshi/mm-damon-core-Copy-only-installed-probe-in-damon_split_region_at/20261008-204926
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20261008151944.113714-3-suhaas%40s-joshi.in
patch subject: [PATCH v2 2/2] mm/damon/core: Copy only installed probe in damon_split_region_at()
config: x86_64-randconfig-1000-20261009 (https://download.01.org/0day-ci/archive/20261009/202610091227.PIPVB0PW-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261009/202610091227.PIPVB0PW-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610091227.PIPVB0PW-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/damon/core.c:4295:
   mm/damon/tests/core-kunit.h: In function 'damon_test_last_region_quota_reset':
   mm/damon/tests/core-kunit.h:2519:45: error: passing argument 1 of 'damos_skip_charged_region' from incompatible pointer type [-Wincompatible-pointer-types]
    2519 |         skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                             ^
         |                                             |
         |                                             struct damon_target *
   mm/damon/core.c:2500:57: note: expected 'struct damon_ctx *' but argument is of type 'struct damon_target *'
    2500 | static bool damos_skip_charged_region(struct damon_ctx *ctx,
         |                                       ~~~~~~~~~~~~~~~~~~^~~
   mm/damon/tests/core-kunit.h:2519:48: error: passing argument 2 of 'damos_skip_charged_region' from incompatible pointer type [-Wincompatible-pointer-types]
    2519 |         skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                                ^~
         |                                                |
         |                                                struct damon_region *
   mm/damon/core.c:2501:60: note: expected 'struct damon_target *' but argument is of type 'struct damon_region *'
    2501 |                                       struct damon_target *t,
         |                                       ~~~~~~~~~~~~~~~~~~~~~^
   mm/damon/tests/core-kunit.h:2519:52: error: passing argument 3 of 'damos_skip_charged_region' from incompatible pointer type [-Wincompatible-pointer-types]
    2519 |         skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                                    ^~
         |                                                    |
         |                                                    struct damos *
   mm/damon/core.c:2502:60: note: expected 'struct damon_region *' but argument is of type 'struct damos *'
    2502 |                                       struct damon_region *r, struct damos *s,
         |                                       ~~~~~~~~~~~~~~~~~~~~~^
>> mm/damon/tests/core-kunit.h:2519:56: error: passing argument 4 of 'damos_skip_charged_region' makes pointer from integer without a cast [-Wint-conversion]
    2519 |         skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                                        ^~~~~~~~~~~~~
         |                                                        |
         |                                                        long unsigned int
   mm/damon/core.c:2502:77: note: expected 'struct damos *' but argument is of type 'long unsigned int'
    2502 |                                       struct damon_region *r, struct damos *s,
         |                                                               ~~~~~~~~~~~~~~^
   mm/damon/tests/core-kunit.h:2519:19: error: too few arguments to function 'damos_skip_charged_region'
    2519 |         skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                   ^~~~~~~~~~~~~~~~~~~~~~~~~
   mm/damon/core.c:2500:13: note: declared here
    2500 | static bool damos_skip_charged_region(struct damon_ctx *ctx,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/damos_skip_charged_region +2519 mm/damon/tests/core-kunit.h

79500f5843f453 Donggeun Yoo 2026-09-28  2489  
18793c04abe665 Liew Rui Yan 2026-10-05  2490  static void damon_test_last_region_quota_reset(struct kunit *test)
18793c04abe665 Liew Rui Yan 2026-10-05  2491  {
18793c04abe665 Liew Rui Yan 2026-10-05  2492  	struct damos s = {0};
18793c04abe665 Liew Rui Yan 2026-10-05  2493  	struct damon_target *t;
18793c04abe665 Liew Rui Yan 2026-10-05  2494  	struct damon_region *r1, *r2;
18793c04abe665 Liew Rui Yan 2026-10-05  2495  	unsigned long min_region_sz = 1;
18793c04abe665 Liew Rui Yan 2026-10-05  2496  	bool skipped;
18793c04abe665 Liew Rui Yan 2026-10-05  2497  
18793c04abe665 Liew Rui Yan 2026-10-05  2498  	t = damon_new_target();
18793c04abe665 Liew Rui Yan 2026-10-05  2499  	if (!t)
18793c04abe665 Liew Rui Yan 2026-10-05  2500  		kunit_skip(test, "target alloc fail");
18793c04abe665 Liew Rui Yan 2026-10-05  2501  
18793c04abe665 Liew Rui Yan 2026-10-05  2502  	r1 = damon_new_region(0, 100);
18793c04abe665 Liew Rui Yan 2026-10-05  2503  	if (!r1) {
18793c04abe665 Liew Rui Yan 2026-10-05  2504  		damon_free_target(t);
18793c04abe665 Liew Rui Yan 2026-10-05  2505  		kunit_skip(test, "region 1 alloc fail");
18793c04abe665 Liew Rui Yan 2026-10-05  2506  	}
18793c04abe665 Liew Rui Yan 2026-10-05  2507  	damon_add_region(r1, t);
18793c04abe665 Liew Rui Yan 2026-10-05  2508  
18793c04abe665 Liew Rui Yan 2026-10-05  2509  	r2 = damon_new_region(100, 200);
18793c04abe665 Liew Rui Yan 2026-10-05  2510  	if (!r2) {
18793c04abe665 Liew Rui Yan 2026-10-05  2511  		damon_free_target(t);
18793c04abe665 Liew Rui Yan 2026-10-05  2512  		kunit_skip(test, "region 2 alloc fail");
18793c04abe665 Liew Rui Yan 2026-10-05  2513  	}
18793c04abe665 Liew Rui Yan 2026-10-05  2514  	damon_add_region(r2, t);
18793c04abe665 Liew Rui Yan 2026-10-05  2515  
18793c04abe665 Liew Rui Yan 2026-10-05  2516  	s.quota.charge_target_from = t;
18793c04abe665 Liew Rui Yan 2026-10-05  2517  	s.quota.charge_addr_from = r1->ar.end;
18793c04abe665 Liew Rui Yan 2026-10-05  2518  
18793c04abe665 Liew Rui Yan 2026-10-05 @2519  	skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
18793c04abe665 Liew Rui Yan 2026-10-05  2520  
18793c04abe665 Liew Rui Yan 2026-10-05  2521  	/* 'r2' is not processed, it should not skip */
18793c04abe665 Liew Rui Yan 2026-10-05  2522  	KUNIT_EXPECT_EQ(test, skipped, false);
18793c04abe665 Liew Rui Yan 2026-10-05  2523  
18793c04abe665 Liew Rui Yan 2026-10-05  2524  	/* 'r2' is last region, it should reset charge_{target,addr}_from */
18793c04abe665 Liew Rui Yan 2026-10-05  2525  	KUNIT_EXPECT_PTR_EQ(test, s.quota.charge_target_from, NULL);
18793c04abe665 Liew Rui Yan 2026-10-05  2526  	KUNIT_EXPECT_EQ(test, s.quota.charge_addr_from, 0);
18793c04abe665 Liew Rui Yan 2026-10-05  2527  
18793c04abe665 Liew Rui Yan 2026-10-05  2528  	damon_free_target(t);
18793c04abe665 Liew Rui Yan 2026-10-05  2529  }
18793c04abe665 Liew Rui Yan 2026-10-05  2530  

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

