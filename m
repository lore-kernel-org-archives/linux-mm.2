Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0F65CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39F978E001C; Mon, 10 Nov 2025 08:26:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 376F28E0002; Mon, 10 Nov 2025 08:26:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D1A8E001C; Mon, 10 Nov 2025 08:26:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 124AF8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:26:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A804E160D2F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:26:55 +0000 (UTC)
X-FDA: 84094772790.14.4559EA5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5473040009
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:26:52 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j0nkU5Dw;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762781213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lprtFd/NlVRB7w+YKB2xp8fLIpz9NqIGACKh1twoei8=;
	b=DG9sUw4SxJAakcbiU8E7Q0vFeWItdr+3Mtx/iDrFpEtAiWKCxq38Glkh2TZgcWqCM4V5/+
	m95TC73a0WV8iyp88tNidvcS52R2LN2VYkm8fAOLxgmzVjsWn3WNKmkIw9KkoWGdH94DRO
	UT1UYVlz92qiC6DlnrnjH0IvGlgkcKc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=j0nkU5Dw;
	spf=pass (imf01.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762781213; a=rsa-sha256;
	cv=none;
	b=P8s37W4ulBstmZLOK9n31rov1cpTC9of16J3LaSGiR6V75GUkoTcKmA3rqigCe02KT+AzE
	y9ekNS+VOnwclOoTWql/5VgoMRyKdAbIn3WIKP1OEHKL3LtaXpNRsOAexJWgPfsOt7+hJw
	cIR1EwvldPOd3EaFa+thMSvgGGMA/dg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762781213; x=1794317213;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gqluEsxLQlbV3vngbeO8V//CEUVe0NkM4sEqKyJqBVc=;
  b=j0nkU5DwL3RLIMNhE7L2kPehx1MyJ4ECoEJs6TtzuwgoCXnqvCrcymOG
   ZlGegpT6fHMg9VdIkD26UWWEKXpEECupAH7YsPuMqixQ+6q6K5nHwApvx
   c+5RcWgJjpCEnVo43LZqYotoXtc/4BasoFcjVNebr8/2vyUcR8uExFJt1
   x+qocAy8K6Uu5fgtAswLyGU4roV83oiMX2m/buiA9ikrQ9A2TKGmbsfYP
   KIG6Hx32+uYbFmStoiQiDfRWn2l7kas3LDReiDro/vPqOjm1/KGF+3fVM
   g4UQVMNna4A2t4a/CJwG6BwwwlFJ1ImgeiE3qfEH7HRS5vQPkv+mqm45l
   w==;
X-CSE-ConnectionGUID: FEOZEAD8QM6E8eFEti7L7w==
X-CSE-MsgGUID: GjHTOaLGQl69Lb6Uv1A0gA==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="64711584"
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="64711584"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 05:26:52 -0800
X-CSE-ConnectionGUID: t+LJONLVQHSZACIPcylDHg==
X-CSE-MsgGUID: TMq45V+1QXibCa/0AnAzug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,293,1754982000"; 
   d="scan'208";a="192932412"
Received: from lkp-server01.sh.intel.com (HELO 7b01c990427b) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 10 Nov 2025 05:26:45 -0800
Received: from kbuild by 7b01c990427b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vIRuu-0000Sp-2q;
	Mon, 10 Nov 2025 13:26:44 +0000
Date: Mon, 10 Nov 2025 21:26:01 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, youngjun.park@lge.com,
	gunho.lee@lge.com, taejoon.song@lge.com
Subject: Re: [PATCH 3/3] mm/swap: integrate swap tier infrastructure into
 swap subsystem
Message-ID: <202511102100.y6n1mtle-lkp@intel.com>
References: <20251109124947.1101520-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251109124947.1101520-4-youngjun.park@lge.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5473040009
X-Stat-Signature: q9dzpt4rcsi3d99a1puf91c3gcb1odfr
X-Rspam-User: 
X-HE-Tag: 1762781212-781365
X-HE-Meta: U2FsdGVkX1/j3QBqWxKiwl7BPmSArEsykb50IzwuNUvTY9r19NSSLKRUtfSd5lpBZlPnUuMVGYcDAtFRB5HCwLoRD+t+YtWYHFZy/phqXsKuqmHLWPItdGhVNVdNah/RPIMKf3jK/tkaZ/hXcdchne0IOmfkNz72psWb5qZdbljiyexMjZHcsfOlc33V33YMWJzgge0hWScvx8D1Mb2VMNIrLlyRikrVYEo8DByzTYAfBZFpudGCBTMPmFF3Uet1Zpvgx+jtIbKzh4qDgUyISoPRwH9Vbi4nYydgNeGfOLYS2dNndEFUvmxCAeLA55e9jdNqOTwVDYn0j4Wb/X2jjdyI1kguSyMK2LKef9mR84WBhde6pu60B8n0viS0PoR8cMN33RfsZJM2BkA50GyNkX4Y6UgZlsPwWuwRKOJ7MtEgceGBt0cSNMVfSL46CZpz32Ky6QzEt44IKm9gn9oxGIIAYsnegYyWss/D2ALqlnWlfRw0PDGK/4R1Z1RBPKvPSZO6Nko1m7mBuNSUS90WWByP9dCozKvSFSMESoyeTb/Z6B8bxrzjDisqJRNX+BFxfLmBF6QSeROKf/Y4o8CI5uXDchJFYQovwb++9Be+XJ7dQLx5wGKw3wDbggMM61eRUpaJxhiesA5JXtjuT9WmcrMqOb4WoiTFt0sGRjmKbw2RnEuJ4h6rakN0OX3CBldDUh1h63eUalUnLyUV47X1wMdcqdYDYCF1p85YBaJBKderRREenbZ+EHSxjsB2yjwQXjJEKs3OKhmhqhlNSbUCLEWKxySV47wiUCXJh7oyBRqmoCgTo1yVgrtcS4jmy42ZnJqTQPRQHhcAFXM+qE8OUscZSldj/twOTUu4Kv4F2/lqYnUqW7n5lKkOVl77lC3q+M1hAJeU5a+jS35Gh2xOSGvhZaZj9YsagE70UHGimvTRhFTOI1ackFcqTbD973oGLmLXV3Aw3AW3bL+BIkU
 5GjnyCMc
 nXUyY5EPg/0bkbFZvQ60Ggelh2cumhVSmEllD3SDQcL149UTVPhFwmEUmXW0wi+rczRpWdZeCtUVslF0GIkGzLRET83Px3yM7P10dgODva8LX6cCOipK/jkD347H4vE1pkE5FOukPlGHb9K6aa4TKHa2/1GJwoN2YwRnv9zGWdZ+zX5k+lpoPYfwAwMQDAkCg/tFRfKruWHuJc9x0KkcjGRDWQ/jMwmQx7ybCrtmlDBH6TTjgqgcdS1MT2jUwNNmIM/qwq2GjK9zKGv8KIW75KaDzE4I6LeQ5/YwVFjinrstz1gmSI4V2rNQo5g==
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
config: riscv-randconfig-001-20251110 (https://download.01.org/0day-ci/archive/20251110/202511102100.y6n1mtle-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 996639d6ebb86ff15a8c99b67f1c2e2117636ae7)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251110/202511102100.y6n1mtle-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511102100.y6n1mtle-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/page_io.c:29:
>> mm/swap_tier.h:71:1: error: expected identifier or '('
      71 | {
         | ^
   1 error generated.
--
   In file included from mm/swapfile.c:52:
>> mm/swap_tier.h:71:1: error: expected identifier or '('
      71 | {
         | ^
>> mm/swapfile.c:1309:31: error: no member named 'tier_idx' in 'struct swap_info_struct'
    1309 |                 if (swap_tiers_test_off(si->tier_idx, mask))
         |                                         ~~  ^
   2 errors generated.


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

