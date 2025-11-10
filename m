Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 479D1CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 12:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1BB8E000C; Mon, 10 Nov 2025 07:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879648E0002; Mon, 10 Nov 2025 07:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B61A8E000C; Mon, 10 Nov 2025 07:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6909C8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 07:12:48 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 28527C0D11
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:12:48 +0000 (UTC)
X-FDA: 84094586016.07.925EFEA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 584B4180004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 12:12:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HG2Ibi4C;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762776766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCt+fyO76BswnXeAXk3DxJteEg2N3PZAd/D6BcbPzjU=;
	b=eOc1qX7tZ6TR80rAILqVxpgGcaNk0yY+UzkH0U4+dIBXvnr0REqcflJBk/1MU/RMMvbRKL
	U5nGpDqq8t5wMJ+sA6lup9g6ddaZ22O5RDJX77T4fpZvzFA6LGNdeySRsevFBIOaly5xF0
	fyy67yfrl8cvr2DMLX9pb0sYR3/71fw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762776766; a=rsa-sha256;
	cv=none;
	b=lxHUPbdyNJBUIbRD4SUF36Hq7PijNd+/0s3jc4qNXZKCxUrJv11QgO30k8sVhe/wZYahQX
	rH5Dgb5ZE1a5qqqDxoGx9TtNh1KChsbYelCevTAxVtjZ/R6Q8R3QEw6gd0rjkiSC05GpF5
	1s8Sh5drtu5mrl91+5diXCjClIiNmyA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HG2Ibi4C;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762776765; x=1794312765;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7baM59UhgLs3PzSYxMxfS0Nqh+LcBS+GPLi8CsvzC/w=;
  b=HG2Ibi4COs4D7P1WTdUMD9YrjdXD2K9g0b2xTlDiuKQZrGxoybfQdjig
   0Ti2/3R3QispJslYIzbsgR+HLiM9uJ3ebFGjotRbjXgH7q0g5k5Tlf0M+
   aYMV5pTQcO803+7YLHG60MOswIJljoEM3zZP4kL1u2+O+oDy9Xrwn3wzB
   0jq01fo7TqL1wvrEX0s/wmTJeyw8ww6oVyWojd8emCe9eJb4t4Tp2ED4l
   Yf9neuQImK67ipyYisA2vV0LoQt1yBaahS1Bv6b3gzbo3XLUJfBwEpmA9
   3E13grRdxOCVU+enyftIWj8a94Ariz/yNB/ajrIl718GipjIY0PIGW8If
   w==;
X-CSE-ConnectionGUID: 11FBDvwoTgyIhMDUG1DyIg==
X-CSE-MsgGUID: Pf8aLsy7TKaHS0nBqZEy2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11608"; a="63830714"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="63830714"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 04:12:43 -0800
X-CSE-ConnectionGUID: FSWuZslwQh+TRlCS3ZmSZA==
X-CSE-MsgGUID: WnKB7LmvS+yM8IUXxmgQBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="187966765"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 10 Nov 2025 04:12:39 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIQlA-0000Or-2S;
	Mon, 10 Nov 2025 12:12:36 +0000
Date: Mon, 10 Nov 2025 20:12:34 +0800
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
Message-ID: <202511102053.StJy9JAB-lkp@intel.com>
References: <20251109124947.1101520-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109124947.1101520-4-youngjun.park@lge.com>
X-Stat-Signature: iafmskazwuonp4bjsgqfy8u7hmrcqnc5
X-Rspam-User: 
X-Rspamd-Queue-Id: 584B4180004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762776765-72933
X-HE-Meta: U2FsdGVkX1+T9sU5w/CMuaqoi0FCaLgAnI3EuJ9aF+nmboK3Q9SkDYCnaOXnaxjR4E7GEzAfHe4AkOZwKKovLIYe/znLT9uLlrrCi+hxFCroSRbfiYqpOsJJdpA3ZWDm9P07SeWhRNbsSUQfAhjRq1klxgUc1LvjJmYcJ3YMY1HsI8EkXHbW7A49Ma3uR0CGeHVrixGswCzJ8pAofB+yupxciIJH1ylNTFgCFK8dxe6bV/BvIRmLc7Z/c4wSn2xXl6SYX7ypoxLW8t70+PAhD9rCiOGdpDrJQvftYplDWCuVBMfmAmMH3tJmgPl1J96BWXuXPBdvKJrN3xiIeiTYSM1zbLqSMdbabwBtwan8yYPYy0bI2Onu+AO0f5XOvG9xH2k0Wr7YCL31EQvReKZRGSfxz1BWHTK9PNavZWy7zooh9pLWnd/9o8Tu9CeGT7CUAGGKgmDo1+0C21ya3c+FaRJ6GV2A9ZogyXuf2d+YlayD0sYX4QlSfM6z3yIpQP1JItilL8yi2+AJ9XHI0m/NKjkRGEdl8j8IfKKKf9pla1PPDCxOvryQW1PgwGbbecPBLOP/SUgwOjl6cNYjbkA9RR1vbVuXR/M6uFWiD+JpIwRaCDladeEJiTpMT6cjKZ2K/cmlb3seIVQYXi6nfhICEM7h6TjsNyVthnau8haAo4XHtFbHKz/1XtpvSRC9SEl1UCfRbmIUkJuH7k0ZIQggSVfFzCrpqdnp0/dKuFiH20BqHVAD11pOcEz6ccFnihCxly+1/q//mcBHXzMr7iFsJ9AYVN/fYoO7wwTjZJ6kkA6GTf03PqMfpOL4FgJ/pyIl9XVmv/a489jKkePthndv9dZEfY6x04omC07gRS6MmE3MprhzHbYZ1CE22P9fhg7b9R5aOtzsWbzXnlIJvtwP94uWIEDuwim0UCQXBYGP1zosfHcjyfCTdMNw7X8jkAvXSjrStgDanJwRolxX1y9
 /hWf04ty
 FpnipaJ3uxicM6oSD8fpdCfsWmNygruDdTl3ZUUl925jTHY9QUacsxXVMNKrX1bJ3jqUVfwMa87KiEr+I7bpyGZhb8F6KVGXE24DZHEQvF1IbJ8E7ejIW4O3XUP/d2fdY/d/sjFUlKVdN0H26jCTab2soFJmYid1YftdICyUhTSc4vwAtNC/ggL1NLEcdaFmWc8g+KjDMCjGawLAF1dKKj6laDL0jJOU2NYW5hIj9xX+ss9+XUd6PyQW3ABPLJSWNpyFgRU+zTfrX2T+iUrE1of3F3LcvDweb7bKyc8tG9FkZ8Eo7tz2kOUj0EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-introduce-swap-tier-infrastructure/20251109-215033
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251109124947.1101520-4-youngjun.park%40lge.com
patch subject: [PATCH 3/3] mm/swap: integrate swap tier infrastructure into swap subsystem
config: s390-randconfig-001-20251110 (https://download.01.org/0day-ci/archive/20251110/202511102053.StJy9JAB-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511102053.StJy9JAB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511102053.StJy9JAB-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/page_io.c:29:
>> mm/swap_tier.h:71:1: error: expected identifier or '(' before '{' token
    {
    ^
   mm/swap_tier.h:70:19: warning: 'swap_tiers_collect_compare_mask' declared 'static' but never defined [-Wunused-function]
    static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from mm/swapfile.c:52:
>> mm/swap_tier.h:71:1: error: expected identifier or '(' before '{' token
    {
    ^
   mm/swapfile.c: In function 'swap_alloc_entry':
>> mm/swapfile.c:1309:29: error: 'struct swap_info_struct' has no member named 'tier_idx'
      if (swap_tiers_test_off(si->tier_idx, mask))
                                ^~
   In file included from mm/swapfile.c:52:
   mm/swapfile.c: At top level:
   mm/swap_tier.h:70:19: warning: 'swap_tiers_collect_compare_mask' used but never defined
    static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--
   In file included from mm/memcontrol.c:71:
>> mm/swap_tier.h:71:1: error: expected identifier or '(' before '{' token
    {
    ^
   mm/memcontrol.c: In function 'mem_cgroup_free':
>> mm/memcontrol.c:3734:2: error: implicit declaration of function 'swap_tiers_put_mask'; did you mean 'swap_tiers_release'? [-Werror=implicit-function-declaration]
     swap_tiers_put_mask(memcg);
     ^~~~~~~~~~~~~~~~~~~
     swap_tiers_release
   In file included from mm/memcontrol.c:71:
   mm/memcontrol.c: At top level:
   mm/swap_tier.h:70:19: warning: 'swap_tiers_collect_compare_mask' declared 'static' but never defined [-Wunused-function]
    static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for OF_GPIO
   Depends on [n]: GPIOLIB [=y] && OF [=y] && HAS_IOMEM [=n]
   Selected by [y]:
   - REGULATOR_RT5133 [=y] && REGULATOR [=y] && I2C [=y] && GPIOLIB [=y] && OF [=y]


vim +71 mm/swap_tier.h

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
c17fe68325c921 Youngjun Park 2025-11-09  70  static inline int swap_tiers_collect_compare_mask(struct mem_cgroup *memcg);
c17fe68325c921 Youngjun Park 2025-11-09 @71  {

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

