Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11BBCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 11:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23A198E001A; Mon, 10 Nov 2025 06:41:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9F48E0002; Mon, 10 Nov 2025 06:41:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D9AA8E001A; Mon, 10 Nov 2025 06:41:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAAD28E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:41:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9811212D09E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:41:43 +0000 (UTC)
X-FDA: 84094507686.14.E4F1CAC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf21.hostedemail.com (Postfix) with ESMTP id D17381C000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:41:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IniNfwEt;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762774901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnjEPV9BddclIRNMsg8a5Gco1BXy5RV6vToCAvDZEjk=;
	b=YDIiZP3OUM9ObKskNUZrw6AAnpYyZhfY4TkQF+WjTDVJrjbdvMnJAYGVHbEA2/EKcfYrUd
	mKCo4//2nHC4IGnSwW16qhBqs1sidrfAJ1hGqeSIpoKxPjGD4HKOiVTv4d/ZjFdxT1nos2
	Qycn2xZETJaKaAhKIHM08F6Rc5KFPmU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IniNfwEt;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762774901; a=rsa-sha256;
	cv=none;
	b=fPpS5JirZ9kvK0shVPm+AyF3tFi2KQrZy3LnMfFB0bLZ9syAHb5Z1TQLa8YkPf7Rz+sWHy
	eEGWX9IMlmV1ENTKc8KqvGCem/fCbRwju/dX6h0PII60iBvsNmS3TzqBWaonUg8bmBjcpr
	DJIq1e0BI8WJrGx8gyEqSVGmuRnfxdc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762774901; x=1794310901;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=omp3BC0nl5OC+y/Q6uZxJQjCYFP23DTOfobjBhZKdmU=;
  b=IniNfwEt/UM+/IAon84aA+hRkpt7UklrmASV3GLyi31Svqzfr71KHq7a
   nyrKepKHFgD5BrnjC2Geu/Zlm87NsvnCQ3v7IoWqHXcUHCAuZJEQlnj9p
   LHcCCnzEKC/3jsWtyy1G136iA0lPYu37uNfbbFOyMxPhSZflc48PL3JLF
   c0X3hZ3kca+QlAS2JzkaT8D8evFUOn4+mCPLqxqqlJMHTmPYmnHlm0kg0
   VdgJxw6/qtfbkxJEXa6FSspCUG/NERiBp20IOCSEspZ+S3vG7N4WcOx97
   xUt5fEGnU4umk/38OzOrcma1Qx6HYFIqvlmsX6p/7B7M7aCeoyRAOlK10
   w==;
X-CSE-ConnectionGUID: DIdc2jNVRf6wPmLdTRdWrQ==
X-CSE-MsgGUID: ngO5nyb0TOChMtj7vuyIHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="64978222"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="64978222"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 03:41:39 -0800
X-CSE-ConnectionGUID: 10suJJPjRL2utc/Raav2wQ==
X-CSE-MsgGUID: CvnKniDvTh+fgkSSdOvjpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="193663550"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 10 Nov 2025 03:41:35 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIQH7-0000MF-1C;
	Mon, 10 Nov 2025 11:41:33 +0000
Date: Mon, 10 Nov 2025 19:40:40 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, chrisl@kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, youngjun.park@lge.com, gunho.lee@lge.com,
	taejoon.song@lge.com
Subject: Re: [PATCH 3/3] mm/swap: integrate swap tier infrastructure into
 swap subsystem
Message-ID: <202511101938.muW3KLKk-lkp@intel.com>
References: <20251109124947.1101520-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109124947.1101520-4-youngjun.park@lge.com>
X-Rspamd-Queue-Id: D17381C000D
X-Stat-Signature: qdc6hwop6uw6jobb8p3nhpoty6pyc1n3
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762774900-713789
X-HE-Meta: U2FsdGVkX1+g90fhGyJJcbmNj4OrrNYpN7XghPFb0zZfDVvCTiAxY/vfeWNpovXl/XuHYIfSwS5V6DxZGWsJGDFyp0kS0KtgzZyzXXkWEbas9X740Cjybf8cpP6iY/4IX1AEYqX47LW3MDOShCWKqtR7zaRASkdMyW7jsQ/kK1DZR1nkg9aYE3jnsaHz3mR6HdO6iFfupxxuDBQQapqB/e0tjKfyd6bgAyvx82DwFa3/JNE18fjo1HWKjAfY5r6ONlrL0lBKvGLip9LREcN61oOlgS3xD7nufOO4tYlMWmVoVBD73k4NhE8vSg/4papU7YYJ5eBuFTQxj20hTNNQGqTDkBfs9AbYMZT+XI6G6DoOkMHXGOjGOGlxEm/5lKEPVreibrPkxDOZCtQLXST3iUD3M/bmn2PphK3YSYw45Q8wo5W3M9G45dEu1HkELBPVveuXlAaANUvUpDotEW0PtlweSUcAosU2aBik6XvccSQTANzGv1MtUfZjzBcqUAAD3gTXqAUWbp6766f34y81+36nNtW+LhddyXj0O5aywDxMw3q1sH8Laff/LU/DbfD9GR++2T2NUW+UGzTD8/hVJNIOlPDZ8P+1HbSL41rKD4vJrwI/+JIuVikaKYtP+PvmlC+95JxwAOLQXMHIykmyOnfWrDvVPZJLNiQ3Riaw7M8hJ9lv9v8FcXQREaA9LulWPsNz9sXRveJUBupvO0w92Fv0AaMBM8WDx1BE6gtKDZmI6ncMTmK6tZkPaIB0i5iQzz8CCrh3KpP6ZbXMFjAzTjxmC8XjC31Vrb3AB4+oJTYTxdOOw0pb0bbIzuvGphKqHrHXzTy17okiBEmhcKfCereIXEq7sXezolk7Ot5CZ9muFw2xfKTllNPFh3MTZhEpduZ+b7y0GaiVbKGJ8K6kVyO/CS5mQebor+SDhHaRi18C2ogKyxczl039CsOmoTbKvfzQJcmI4MyOAgR6+4z
 6eWiSrWl
 t3FLEaLg7+hysI1IT+2orEr/QpTwGNa8/F/J1yl00RfeZ0DALP+Z7C5RW3l586ThG57sIJ9vjbwzGb3QhTW2RYEQXYjEz46nGCraQ/nCtGAdA+S61OnJ3egmG3rmIXVmeEOyZU68cnDly0a9TFYn8i1dWjECuDohGDbMTMx6e3SzjTwDWcqmkmVLZcgoC/8mW3YROSOTRY4t5w/tfXr1YgzXRkFA0kdKtLgAFq9jyVqI4PbWBnpVfE1QHmyoZLGPdMStqWXmmtPNboe/9T7Pa8idyP6fX9D1V3xaYLvWX74QhSViZK7VUE0zWlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-introduce-swap-tier-infrastructure/20251109-215033
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251109124947.1101520-4-youngjun.park%40lge.com
patch subject: [PATCH 3/3] mm/swap: integrate swap tier infrastructure into swap subsystem
config: s390-randconfig-001-20251110 (https://download.01.org/0day-ci/archive/20251110/202511101938.muW3KLKk-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511101938.muW3KLKk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511101938.muW3KLKk-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from mm/page_io.c:29:
   mm/swap_tier.h:71:1: error: expected identifier or '(' before '{' token
    {
    ^
>> mm/swap_tier.h:70:19: warning: 'swap_tiers_collect_compare_mask' declared 'static' but never defined [-Wunused-function]
    static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from mm/swapfile.c:52:
   mm/swap_tier.h:71:1: error: expected identifier or '(' before '{' token
    {
    ^
   mm/swapfile.c: In function 'swap_alloc_entry':
   mm/swapfile.c:1309:29: error: 'struct swap_info_struct' has no member named 'tier_idx'
      if (swap_tiers_test_off(si->tier_idx, mask))
                                ^~
   In file included from mm/swapfile.c:52:
   mm/swapfile.c: At top level:
>> mm/swap_tier.h:70:19: warning: 'swap_tiers_collect_compare_mask' used but never defined
    static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from mm/memcontrol.c:71:
   mm/swap_tier.h:71:1: error: expected identifier or '(' before '{' token
    {
    ^
   mm/memcontrol.c: In function 'mem_cgroup_free':
   mm/memcontrol.c:3734:2: error: implicit declaration of function 'swap_tiers_put_mask'; did you mean 'swap_tiers_release'? [-Werror=implicit-function-declaration]
     swap_tiers_put_mask(memcg);
     ^~~~~~~~~~~~~~~~~~~
     swap_tiers_release
   In file included from mm/memcontrol.c:71:
   mm/memcontrol.c: At top level:
>> mm/swap_tier.h:70:19: warning: 'swap_tiers_collect_compare_mask' declared 'static' but never defined [-Wunused-function]
    static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OF_GPIO
   Depends on [n]: GPIOLIB [=y] && OF [=y] && HAS_IOMEM [=n]
   Selected by [y]:
   - REGULATOR_RT5133 [=y] && REGULATOR [=y] && I2C [=y] && GPIOLIB [=y] && OF [=y]


vim +70 mm/swap_tier.h

c17fe68325c921 Youngjun Park 2025-11-09  41  
c17fe68325c921 Youngjun Park 2025-11-09  42  void swap_tiers_init(void);
c17fe68325c921 Youngjun Park 2025-11-09  43  int swap_tiers_add(struct tiers_desc desc[], int nr);
c17fe68325c921 Youngjun Park 2025-11-09  44  int swap_tiers_remove(struct tiers_desc desc[], int nr);
c17fe68325c921 Youngjun Park 2025-11-09  45  ssize_t swap_tiers_show_sysfs(char *buf);
c17fe68325c921 Youngjun Park 2025-11-09  46  void swap_tiers_show_memcg(struct seq_file *m, struct mem_cgroup *memcg);
c17fe68325c921 Youngjun Park 2025-11-09  47  void swap_tiers_assign(struct swap_info_struct *swp);
c17fe68325c921 Youngjun Park 2025-11-09  48  void swap_tiers_release(struct swap_info_struct *swp);
c17fe68325c921 Youngjun Park 2025-11-09  49  int swap_tiers_get_mask(struct tiers_desc *desc, int nr, struct mem_cgroup *memcg);
c17fe68325c921 Youngjun Park 2025-11-09  50  void swap_tiers_put_mask(struct mem_cgroup *memcg);
c17fe68325c921 Youngjun Park 2025-11-09  51  static inline bool swap_tiers_test_off(int tier_idx, int mask)
c17fe68325c921 Youngjun Park 2025-11-09  52  {
c17fe68325c921 Youngjun Park 2025-11-09  53  	return TIER_MASK(tier_idx, TIER_OFF_MASK) & mask;
c17fe68325c921 Youngjun Park 2025-11-09  54  }
c17fe68325c921 Youngjun Park 2025-11-09  55  int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
c17fe68325c921 Youngjun Park 2025-11-09  56  #else
c17fe68325c921 Youngjun Park 2025-11-09  57  static inline void swap_tiers_init(void)
c17fe68325c921 Youngjun Park 2025-11-09  58  {
c17fe68325c921 Youngjun Park 2025-11-09  59  }
c17fe68325c921 Youngjun Park 2025-11-09  60  static inline void swap_tiers_assign(struct swap_info_struct *swp)
c17fe68325c921 Youngjun Park 2025-11-09  61  {
c17fe68325c921 Youngjun Park 2025-11-09  62  }
c17fe68325c921 Youngjun Park 2025-11-09  63  static inline void swap_tiers_release(struct swap_info_struct *swp)
c17fe68325c921 Youngjun Park 2025-11-09  64  {
c17fe68325c921 Youngjun Park 2025-11-09  65  }
c17fe68325c921 Youngjun Park 2025-11-09  66  static inline bool swap_tiers_test_off(int tier_off_mask, int mask)
c17fe68325c921 Youngjun Park 2025-11-09  67  {
c17fe68325c921 Youngjun Park 2025-11-09  68  	return false;
c17fe68325c921 Youngjun Park 2025-11-09  69  }
c17fe68325c921 Youngjun Park 2025-11-09 @70  static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

