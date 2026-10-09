Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F8ECA6017
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 02:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BABC6B0092; Thu,  8 Oct 2026 22:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BA06B0093; Thu,  8 Oct 2026 22:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182726B0095; Thu,  8 Oct 2026 22:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E08C16B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 22:40:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A0951A0212
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:40:20 +0000 (UTC)
X-FDA: 85301533800.15.485CF38
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf20.hostedemail.com (Postfix) with ESMTP id A0D651C0003
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 02:40:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W1jzMriC;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791513618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FM/gQ3lHafZluFzBZFmiy96F0l9UxhH5WF75v5oTdZM=;
	b=aZIeRs4UYIdlcnkmvHXlN377aKjaSx3QLj9Le/LR3DsQyk745LOQp0SLH4Kosio90ZCsAy
	SdnWUnbmjvDPQ7xXZosd8L4q48M6X+bLqXEqknCBrvY1Z4PzALRB0JhPOFHWTmm8hiqBIy
	ISzCoHyw9KEZFU016J9cCzeHFQFGots=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791513618;
	b=iBclJY64YGRQ+1NvcQztQksdruMRh1sET9HXy/j5LhcYvDdgLajAKHLENhzLRI2pqwh+Or
	TK1Dj0+YYnKhv3FSToGlDuzAfeUKF+H3IeJ//peLQX/pjiaVA/kPEiOZRtEm3pTVECTHVU
	VNEFOHbXnciaFVhzalRBoe30fp3Sv/k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=W1jzMriC;
	spf=pass (imf20.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791513618; x=1823049618;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=U1npSJzejD5mBi1v3j4ledYzhzb7UttD01lckDzSJgM=;
  b=W1jzMriCJMj2NbA9YA+mIJr8pPXWS3SkBpTZqwscRdEAwzXQlynI4cAe
   W82V1aZVYOX4n/S+tpiBgAEQeCv5+ZydloyGBof4Ixrf6sMlGXWUVIGSu
   rFV4MBbbr9Ozk4k6ey1Ih54XxboShJiXF8qGzVNB0q+w6hOMChe8uGhsc
   +ZKHlRUYHDtAoTjU0dRCY2dOCmwaiZwdfad1SSiI5x6CEVzeFosdUtneg
   SCSsDd0AmTkDpSevSghJZbvvWYXUdY9yYpYqBcd/rWysg6YFluRAI2cKK
   EkYpBPETtpZlB/XkJgpOE3nSU6RuuhU8khMvNCQYmbv0A0ouQUnSZks2W
   A==;
X-CSE-ConnectionGUID: IZ/ADWIVRWWZj6XSATxPqg==
X-CSE-MsgGUID: ankkR5eEQ+6bTcCSqVnKNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="312478"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="312478"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 19:40:16 -0700
X-CSE-ConnectionGUID: NKB6IehzQ2+GXVXta22VSw==
X-CSE-MsgGUID: gByQKVSEQGSzQsBZiCzfjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="280369"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 08 Oct 2026 19:40:13 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xF0Wn-000000005Ce-2mWk;
	Fri, 09 Oct 2026 02:40:09 +0000
Date: Fri, 9 Oct 2026 10:40:07 +0800
From: kernel test robot <lkp@intel.com>
To: Suhaas Joshi <suhaas@s-joshi.in>, sj@kernel.org,
	akpm@linux-foundation.org, aethernet65535@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, damon@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/core: Copy only installed probe in
 damon_split_region_at()
Message-ID: <202610091039.fhMXCn7d-lkp@intel.com>
References: <20261008151944.113714-3-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008151944.113714-3-suhaas@s-joshi.in>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0D651C0003
X-Stat-Signature: sm7etzx1fwtojznaxh64fci3iktex3oy
X-HE-Tag: 1791513617-303836
X-HE-Meta: U2FsdGVkX1+EPIPY94HwF/uNCSge5jIleZMdiwTwfrFLNL7jii7ZVnETm9K//XNhrKTaH9WZ11v2ufRbl13f1R3FOHLo0FIYyqtuK7yCgp9KHWj+jn5qitQl8r6xUA3EW/7JDuQpdJDklWYCIXDqRT2mYBey6W5c7CnBVig9VBb75qTZQ0CjyXzyzR2PYsTC1l52Nkkv6YCdKfY6/HuHSBRZmtBtw3+c4o3TsuMXwXj/0gssTFpLgHVLbM7qXQYnjCZC/3tz6H4PnTVJCUKeSNkUvxZj5VQfdOBeXrbO0SinhxXu+MhYw2y21Nr+xThnj8wpwc5pV2TnpEuri6Y8swaj9ty6wGBx1FL2IHEfRIrJ6bd+otCXAb3Vvt2lz4Qg9U8zbB2tdBfRehESNABsC+qFSVVEzHKWA3iWcULaAmnKdjRSIJ7d50METoLTvciuIthot6wYu7yzG3a90WTRQmUFJ7TeEzqTSMbh5k20QcXD3YF/ccvDbLphdORQJQ2TfdBYW3SyhJCeay3VT2q8XJHsek8TQzVuDlTKySjysZs1ntyP2t9ITSXP7eoMnSlTdIoUywzxvcQdqrkkdRZZmnMRDulkbDJn9Kj/kSvXX9e3i7hd4QxnNwo0n2NK2r5isHWBJjsY8s1q3VKt9vapYXgCcGdvmaSW6GexltozKbzqI6cR7uV7YVExIhbPKLtLjuQOZM89vuCCF2/UcthZhLtbdw3V8niKBCR9eAwEPdDKfUcECA+MHBLjgvfmkFtKZ+1sLNlv1qJE7iMyDhgqC2Qv9M2pd2M0ERN81tQd6srart0S9rAtSKWvBIiQ/daScFP2mUvltHMKMLF1CtwEw/AGSwkV4s2Sy9S1LLymiMEljSRWqOaOUz8im26Gg9oY20jCGY6Z+AhFr3YQ3VxRauGiGZsQ4D6AIA2Utw8Fd5vTszSwdgtHaa7g4XvTzVdfDz6woO2vb00i1xxL4DU
 Mw7ft+0A
 jxG/MPJ1unAnMNHq/SkJkDbrls3+dhBYqlONQZZv1GmT7i5cNA/XjrxNpd5Sbn3rFwx3uotkb97lfEUrRiy1JgjKsc0n5VYgS7QNvm/F68ysyngbhS0fBaGRpdILrMZKkNaV98yj0qfCeRBj5glzF1ztwYVsaquuksOkHzpSRtilcVSIKVQr8ECopLFeFzIlJOKFGpN/DMMd8J29ufD3cQhVKQ3nZ0Uhg9rYFhp+riiCNOSJFJJ8YpZYfgXuwlwMRYItGO/mph/5KraVYeO+Q7PZpJJxSEl5RyKl8TXaTxz+R5NvhQUbZaWN03OdcSk2gNOuJtVyCR8asHBQ6pM7Oz2azunreFYXBRA1/Og0ogAHNn/vjYg+hFvfAMw==
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
config: csky-randconfig-1001-20261009 (https://download.01.org/0day-ci/archive/20261009/202610091039.fhMXCn7d-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 9.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261009/202610091039.fhMXCn7d-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610091039.fhMXCn7d-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from mm/damon/core.c:4295:
   mm/damon/tests/core-kunit.h: In function 'damon_test_last_region_quota_reset':
>> mm/damon/tests/core-kunit.h:2519:38: error: passing argument 1 of 'damos_skip_charged_region' from incompatible pointer type [-Werror=incompatible-pointer-types]
    2519 |  skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                      ^
         |                                      |
         |                                      struct damon_target *
   mm/damon/core.c:2500:57: note: expected 'struct damon_ctx *' but argument is of type 'struct damon_target *'
    2500 | static bool damos_skip_charged_region(struct damon_ctx *ctx,
         |                                       ~~~~~~~~~~~~~~~~~~^~~
   In file included from mm/damon/core.c:4295:
   mm/damon/tests/core-kunit.h:2519:41: error: passing argument 2 of 'damos_skip_charged_region' from incompatible pointer type [-Werror=incompatible-pointer-types]
    2519 |  skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                         ^~
         |                                         |
         |                                         struct damon_region *
   mm/damon/core.c:2501:32: note: expected 'struct damon_target *' but argument is of type 'struct damon_region *'
    2501 |           struct damon_target *t,
         |           ~~~~~~~~~~~~~~~~~~~~~^
   In file included from mm/damon/core.c:4295:
   mm/damon/tests/core-kunit.h:2519:45: error: passing argument 3 of 'damos_skip_charged_region' from incompatible pointer type [-Werror=incompatible-pointer-types]
    2519 |  skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                             ^~
         |                                             |
         |                                             struct damos *
   mm/damon/core.c:2502:32: note: expected 'struct damon_region *' but argument is of type 'struct damos *'
    2502 |           struct damon_region *r, struct damos *s,
         |           ~~~~~~~~~~~~~~~~~~~~~^
   In file included from mm/damon/core.c:4295:
>> mm/damon/tests/core-kunit.h:2519:49: warning: passing argument 4 of 'damos_skip_charged_region' makes pointer from integer without a cast [-Wint-conversion]
    2519 |  skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |                                                 ^~~~~~~~~~~~~
         |                                                 |
         |                                                 long unsigned int
   mm/damon/core.c:2502:49: note: expected 'struct damos *' but argument is of type 'long unsigned int'
    2502 |           struct damon_region *r, struct damos *s,
         |                                   ~~~~~~~~~~~~~~^
   In file included from mm/damon/core.c:4295:
>> mm/damon/tests/core-kunit.h:2519:12: error: too few arguments to function 'damos_skip_charged_region'
    2519 |  skipped = damos_skip_charged_region(t, r2, &s, min_region_sz);
         |            ^~~~~~~~~~~~~~~~~~~~~~~~~
   mm/damon/core.c:2500:13: note: declared here
    2500 | static bool damos_skip_charged_region(struct damon_ctx *ctx,
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


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

