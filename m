Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55ADEC61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 04:29:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7A316B008A; Fri,  4 Sep 2026 00:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24CF6B008C; Fri,  4 Sep 2026 00:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C16B26B0092; Fri,  4 Sep 2026 00:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 96CF66B008A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:29:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75B9440716
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:28:58 +0000 (UTC)
X-FDA: 85174799556.19.79A2DED
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id ECCAF20005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:28:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dSjIEgGK;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788496136;
	b=rM690CTAcGJsP0lkjkmCT74FaX5q1Ym7oO+duNhnU2d1qSMz/L2NdS2ZIE/vpgVeq5/BUS
	+kXcAiiKqlYczsOjzmR1n8GdemnDzkdprQANxlDN6eUfihiREgAm/TzPNrLuJ6jULHaefK
	aqyR/GYzbVPcPWcjdWLcR9/OKKCDtWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788496136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=Vs8aCt+UpsdtOljCSfo/M3IV8ycOcnoZmCBAXeMA3jM=;
	b=1moztdJtBSpoqNdXp3GzMT8FILiW8eQRaHCkv9W6anU82Q1GMUPs+OXeo5CawDATxRbMhS
	qeGhHYq/DEk0ZvAvg/mFTZkgmckA8rfIoVs5d9JC8ukwEfSA+Pc/W4yIY7PNbevTdmq+aq
	fp16WkkSdNOBiTj2hVYrJzp/4hZksdg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=dSjIEgGK;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788496136; x=1820032136;
  h=date:from:to:cc:subject:message-id;
  bh=w76Wgyu5ch/AXeo3ZtSdR7LhvuJGWr8xt9NF6O2p8sI=;
  b=dSjIEgGKu++vqCxKJj/vuepnhFL1lizcy6a4siOVoil/ZKRqYhKgp7mo
   zmZcaBmFF/fS+k2uhVLtBFiX7t9PMUAc9hpQjXgdOLgE1WR1RkjHiBxLI
   ZQC0SzdStZ0u5PtJkC7KHfL3PZ8hW5i4oN/ekpZ0TzaHfBBkarsjktIqy
   CftDIoOzbncDFFYROnQvMWMB8Hlg3bIM0m2efrCTkEk2zBdZHA2JqF5vv
   xEWtQbCIWIjBF07y9rK+uxe5AdCUXcbf1Ppnbj5bkcsG0MFkL0cWv63n5
   BeJqQ2lVhR7RZ+7z0Tr8mSsx/3YtAT2WldvpblerqjoFs0S9++DZ3ly8s
   g==;
X-CSE-ConnectionGUID: tq/mLb61Q/C33JVyuox1yw==
X-CSE-MsgGUID: uiOAV1W/TsKnIswKFMzlgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88135118"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88135118"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 21:28:55 -0700
X-CSE-ConnectionGUID: qfwbpt30StaTEgwgfq3FHw==
X-CSE-MsgGUID: 9yl3htK0QHu5TBqWybBfIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="269389491"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 03 Sep 2026 21:28:53 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2LXm-000000005kO-2NR1;
	Fri, 04 Sep 2026 04:28:50 +0000
Date: Fri, 04 Sep 2026 12:28:37 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 302/317] mm/memory.c:2271:17: error: too
 many arguments to function 'hugetlb_zap_begin'
Message-ID: <202609041234.yRUbaeuB-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: ECCAF20005
X-Stat-Signature: 4z8pwjsudszdfwf118knhmogarkt8xzj
X-HE-Tag: 1788496135-978525
X-HE-Meta: U2FsdGVkX19v0LoSNQ14Z6q5nBBovoWc1KpMNm6WTTmYo88KaV5W9N3isSal/QrBzG68PZc6ycAR5YSOZ4tu2xm+Ow7xBur2qk2Ak2QxdmtcJ120zUc7b1JQlljtZUeKRzqtUn5EvmzwuWlLcvybFuhhTiAc/7hBZePU09P+FfFOIs/Z+VfPNqON7f3APC+KvsERj4k4gC+YGZiZmQkoxoE8sBng9nfIeckLqmhOM2uOHDvCi5xq0/T/BDpjIQkKqjHrL8e/rC6TYTR2fFYIVuyCYW5cO0ITciR4gUD0JgzX/FpF2z1RISXWW7prJClw0nlPxfqPwXjuL4YK/YnFV3MOWW89yn3D4k3f4awfTyLQWHPSme2MnvM1hDAWmUit7ef3pxymP8f0rCGrC3rzSapFMLtHV/RF8iDZFSTD+6S0vswU0plp0PYn4/O1aivx/dmKSK5FTDobqFEXyMGKSWx9O/G2cn+PmRWxsh5qsEF0F3ERwBDlAGvGWt1lTTNdDarmHzrC7aT0jW1DMNqnog/+G0DgvDRpno/VzwZLGDdZg//eu5/WGFwuDCjh/XJ31Vulav/iBsf7fyLpgrIdvRz8l/0BIYOZOBRtFHPiqRbjvc23nPTvOOONTex9O1pqdm2iEV+HXW+APxha8zIyIvJWr3eyhMeDC84+iXgVoOo1XAJqT1HL9WinSuMKiKinhhtYevbZF09hKzi7OAkZ0zzttLuNr3417uwCaDLYuAZR2Lkok9/g0/U4CO2StHGwosaTmt+HdEu/WKBOKFGxG0E4YEDyIe6XnUlWqHp6cLV+PbSTC+2fdF0WDXE9asexD5vnITdEuysYbazKHNPUzQyoLm7u7L0M2f5HeBlduTTMoDCC+unsN48TiuESdzTzuma/i8aXYVmYQmjIHRbcW2IVyaGXbeAaTuu6BmW4AmZQUMnMKoAuUcWcs0LEG4HKu6k7fGezbRxbJ3fX1xA
 ndqr0Deg
 t9LVn2Qres5ZQfbyAbOvYGzzMVMaPm9vw0BDa8tTCfqNFD4Nj0osEgu0Yc+jX4KNR8HVbMv7OWuhhLQ+i/fmYKqZ93HMJvLxrH5r7ybfzkKOlrA9S4BjcHvm/HfXmYC4qLPjeBqFpETD/v8O6wa0NdeSqpVQ1vceQjh8wsMhAwuGN6YWXh4oXGCQbNQ8rST+V5NwSeulV3wyFsF4m1TEtdnQ7VP1T5/nVrYr8euAJ454MjDbyRGX+wnuvWVokqUiK3zmSFvodyskFUNZfT9dFSikBmQXZBzZhsCSCXFGEIVSpEI9ZwKXbmvgv274+DxYczVMc757IyhjUFEw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   2aeb49124a2b3d0c9aa8c0a2124c8cae21ab4e0b
commit: f1fc44daf6183604b96243805877ee0b1626daaf [302/317] mm/hugetlb: don't lock private resv_map during final unmap
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260904/202609041234.yRUbaeuB-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260904/202609041234.yRUbaeuB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609041234.yRUbaeuB-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function 'unmap_vmas':
>> mm/memory.c:2271:17: error: too many arguments to function 'hugetlb_zap_begin'
    2271 |                 hugetlb_zap_begin(vma, &start, &end, &details);
         |                 ^~~~~~~~~~~~~~~~~
   In file included from mm/memory.c:48:
   include/linux/hugetlb.h:322:20: note: declared here
     322 | static inline void hugetlb_zap_begin(
         |                    ^~~~~~~~~~~~~~~~~


vim +/hugetlb_zap_begin +2271 mm/memory.c

  2238	
  2239	/**
  2240	 * unmap_vmas - unmap a range of memory covered by a list of vma's
  2241	 * @tlb: address of the caller's struct mmu_gather
  2242	 * @unmap: The unmap_desc
  2243	 *
  2244	 * Unmap all pages in the vma list.
  2245	 *
  2246	 * Only addresses between `start' and `end' will be unmapped.
  2247	 *
  2248	 * The VMA list must be sorted in ascending virtual address order.
  2249	 *
  2250	 * unmap_vmas() assumes that the caller will flush the whole unmapped address
  2251	 * range after unmap_vmas() returns.  So the only responsibility here is to
  2252	 * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
  2253	 * drops the lock and schedules.
  2254	 */
  2255	void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
  2256	{
  2257		struct vm_area_struct *vma;
  2258		struct mmu_notifier_range range;
  2259		struct zap_details details = {
  2260			.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
  2261		};
  2262	
  2263		vma = unmap->first;
  2264		mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
  2265					unmap->vma_start, unmap->vma_end);
  2266		mmu_notifier_invalidate_range_start(&range);
  2267		do {
  2268			unsigned long start = max(vma->vm_start, unmap->vma_start);
  2269			unsigned long end = min(vma->vm_end, unmap->vma_end);
  2270	
> 2271			hugetlb_zap_begin(vma, &start, &end, &details);
  2272			__zap_vma_range(tlb, vma, start, end, &details);
  2273			hugetlb_zap_end(vma, &details);
  2274			vma = mas_find(unmap->mas, unmap->tree_end - 1);
  2275		} while (vma);
  2276		mmu_notifier_invalidate_range_end(&range);
  2277	}
  2278	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

