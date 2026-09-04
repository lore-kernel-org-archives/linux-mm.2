Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABDC6C79F81
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 04:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33A246B008C; Fri,  4 Sep 2026 00:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C42F6B0092; Fri,  4 Sep 2026 00:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 200E26B0095; Fri,  4 Sep 2026 00:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7DFD6B008C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:29:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 055B84071A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:29:01 +0000 (UTC)
X-FDA: 85174799682.10.22C79EF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9028520005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:28:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=exYsEAhN;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788496139;
	b=T45SDJq03kj9ApPtGPHvaUvEMC0Lh5udp3subUB7NGQybZWyI0N8/cgVZ/2bOE4DSJAP0G
	VZSIzo0PRUKcRNNJZ0FuRj+7WjfVQoqTCk8iaQmFkVLRFXolN54FHBWQwQswn9i8te/FiY
	68DOjQsPPW+wEWwAhE1ty41qFBoswYE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788496139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=adj8Jzm1WIyDJK90mMJ+Bhhku8ZgXzgYRpr860k72q8=;
	b=LcI7RExjBbsUvvG4mi6kqoeR5fg/vdwzEe0Sw/GNyGSK4dzaYT2v7b64xjmxfFQ7XDpo2L
	U+SWnct18ETenJGf2IdAg9ClZN0D3rkWBrZnLlZyCNdgjLrCwKD2a48GuScICaynTmQ0U4
	y9N2OGHqIAJFpINWo2QARCq5Se1UIaA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=exYsEAhN;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788496138; x=1820032138;
  h=date:from:to:cc:subject:message-id;
  bh=WN9sRFSBjG3KbS0pSPM9R/IHsjFtneeG71XFWety+6o=;
  b=exYsEAhN27ceS5zQgCoQIG18Eu6Vv/GUl7Wb8nUFLk2cI0BLj2yxwTTd
   /MoqzZQrghGnyGnVwaYpryX1sh478Mm8HbB2JmdzKX+SVz9S8L5NNg2n5
   tYuwiTnn6GZUvrB+MJ1zXl9aC10mioUJBflvcgZhbNc8M5JIO4iSycgKZ
   5xG83eegMrJ87kAuYtiDD/hKZwV6LXERQK9392aJSvzHPIcSpErZNDhyz
   pGNCzSC/W6Q6tv1k7/DITAU/iYwX2lASb2MW3StXQyGrz49Z2NKcuTxg8
   7VyTcfAiEWUNZBmB6xs2ACAEpZ+Wa0/teQMYKQ0UuFBa4UpktZxQNG8wy
   Q==;
X-CSE-ConnectionGUID: 8LS9K9TPT9iN2rOUnS4oZQ==
X-CSE-MsgGUID: zLgNAkv+QoqAoEv+rudCFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88135123"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88135123"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 21:28:55 -0700
X-CSE-ConnectionGUID: xq2RwAX9S3ahmoD6BPf/RA==
X-CSE-MsgGUID: VpTHI7cZTQCPCI8KHPgImQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="269389494"
Received: from lkp-server01.sh.intel.com (HELO bfac249b2189) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 03 Sep 2026 21:28:53 -0700
Received: from kbuild by bfac249b2189 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1x2LXm-000000005kM-2G36;
	Fri, 04 Sep 2026 04:28:50 +0000
Date: Fri, 04 Sep 2026 12:28:36 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-new 302/317] mm/memory.c:2271:17: error: too
 many arguments to function 'hugetlb_zap_begin'; expected 3, have 4
Message-ID: <202609041213.bgAPQEek-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9028520005
X-Stat-Signature: 1ze6w8ysos4i78gxcgacc4jutgo6ne98
X-HE-Tag: 1788496138-374872
X-HE-Meta: U2FsdGVkX19LeMd0LLeEDQ6PLvpHw+mO3//HWrRk0PKL85NUaFbvkLE3axHCYXdpTuYKcMSVGwgFIM+i0FxfGR0GG5JydII7vZN6/YW9vlqOuk9q40nRiInXcn9GPZ4qnEOfW6FpUH++M3y2m49HjLs4BKmxgtIeMJm2IjUiYMdtto5U/hkSHJ0VvEwYvcBCIlTV1HUVo3P9zGGQCIWnJbhQvGT4XLhIopX9jglPy4jvjUg2F8ISZ53xF/EkcV4iPE81CyQlilLbWus0GaTBDq2FMvtLaY2cv1P7TGX/5Eym+KUolcRw43hN6ovG33er3tOv4OPMXm1DgwPyhgttAOYm+EGJXd/rpwULM1K/VUmWZ9/rO5kDsawO7gDsLqrOykSMZoNlSOa2/GRrguahItECHBMzYpGQbJ55bBOWjAKi2auCmPMLqySob9Ha3k9IcrKryvlXjVgq+WhpqCMKOTNGiP5uArNx31k2/CBQe/JgOKrflNOUQO9AYbPcAguG6E7Rprua51rls0HJNY2BvbjNYAiz6G4r3ZGav+rKdeuh/n3XBBHkXiUXlGAfcLXLhQ/auizrJhrAiy1k+5TU9iPgv2ZwYY3EQH5Y6d2iyycJJWSK48RnxbVvAEZdyN/XOh+mTzAaoHePurVafHdXrS3/7jmtxbvI9ElBGj1jCJCFIQ0HHbogXgr91MV1VNiQAjU3l0XkdmTMcCPvUSQKyLdYO9W/4em62BsYZafksJC1eSEGYBNMGXbOQsAcJSj8JwGEdmNTS6kkxsggHHebyI/IMaTW12zyvACS/6be3Yz5ZWn0Q1FiZv6Qx14FVxDDpEYg42Nhax+EurbCUzB0D3Ickt4sr32Np/qB72MljSKqKegKM/XMH0/PbUJMBWjUy/ohdO+KbTPmfHK8zfyz6vaImOz46fsc6sx9q2K62+YB1Jgw+5/6RGzGwJxZaxj+0IT1nb1wPBNsmPa9Vo1
 MzXshU3p
 LmfWA+3jTXn9wgClD/bwqdo/lCnfVAvut03Pt70e9czjuZv0WcHE2wqKxOXctgk3SBCtKQOQbZXuoYPLKN2487QVl8xZSMOo/1zj7tgcjmlYAa6looBpO7CD1CvxvBxVg6v4NAakQQQDYtd8pcDf4fMP+kbtnzJVleIMLFWw5jljRgb/U5O4rW09BhE98Be1+yqFBLNV6S+oBUQ3IFg1v6CTj4DPyDKj2dBBZ3rNqliE5Iw/A3zG/PnmWw1KdW1zUdgc+mrNwzcQOh/PE09Md+GyCEiGc8y8ixiI0ZyWEqrBuUVjU2ZNq1uwUN5eb+qbHU+cWliLnouV0XNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   2aeb49124a2b3d0c9aa8c0a2124c8cae21ab4e0b
commit: f1fc44daf6183604b96243805877ee0b1626daaf [302/317] mm/hugetlb: don't lock private resv_map during final unmap
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20260904/202609041213.bgAPQEek-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260904/202609041213.bgAPQEek-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202609041213.bgAPQEek-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function 'unmap_vmas':
>> mm/memory.c:2271:17: error: too many arguments to function 'hugetlb_zap_begin'; expected 3, have 4
    2271 |                 hugetlb_zap_begin(vma, &start, &end, &details);
         |                 ^~~~~~~~~~~~~~~~~                    ~~~~~~~~
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

