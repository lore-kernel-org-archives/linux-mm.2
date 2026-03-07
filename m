Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A735F55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 17:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 277D56B0005; Sat,  7 Mar 2026 12:35:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB516B0088; Sat,  7 Mar 2026 12:35:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FE2D6B0089; Sat,  7 Mar 2026 12:35:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F23A06B0005
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 12:35:56 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C0068C40C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 17:35:56 +0000 (UTC)
X-FDA: 84519969912.29.AE88E5F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf27.hostedemail.com (Postfix) with ESMTP id 56E5F4000F
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 17:35:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EgR6EVyh;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772904953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7S5EOS1eTnYpLDDNMzPfL4nw8QBOEQQpTLyujrcAS44=;
	b=oW9+4oBCuXeQvgJ9wP5llTsUwAUPnAlxMxwzAfklO3zYNE83tNZE1TKwy9QGtN0BI9ZhDa
	ytrNUYClVfjRo1M1kBixrxGL/gZ9oCglkmDmLcy51usJ+BY0BrQnSUUfLNVCbUxtQpV53K
	FPBinSu8iyMpV55JxR1oDovtBLI+pVU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772904953; a=rsa-sha256;
	cv=none;
	b=aPy5nSJGgCKZ1M+3owabVYEeXRFLxFV8gDzTrGkddZ2ccAYbBNLXEEU9j3GgIv2Le5UH6u
	xQJtvobhf34c2TS9at2nN5aWaY/bexwA4GUX9K2txaaPio4AMydmiTdEa7Ppgco4rZ0uRp
	z+UJgDfkKjRbtz+UdKnHbQCCVlcDXoY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EgR6EVyh;
	spf=pass (imf27.hostedemail.com: domain of lkp@intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772904953; x=1804440953;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F8+Oe6iEOQ/Gur29RNoZ3yz2cePACpGoNRWjkfLQ5uA=;
  b=EgR6EVyhCBKbEVFEk9v2EXNzvCBBBXLBJvlXnoN3Z6re4DRGvu1f/Flz
   NtF3NM0mkYXSx76eIzp0rrRfj3+AqERxGNnXdTTjHwRhN5Hobf/Tv+3B4
   NRDPBszRCtUc/iBEgeC2sO2HrBUSiQuFPDRA/yUq09qGIFC+uFF919sce
   W6V4GGzgsbrI5axkZNb0YVhxpwrbufLxgyZfxSLknGclhBmdTIbIOzyoY
   8XyOtat0DDUf4FlQDkn0hZ1mf+ZSIiKKPtTuVTQeklEYSa099JyKcO6CM
   qN49sqoU0QcTSy+jrKdi/zwqoBAjH2+zM2r9tfuncUs/9q+tfeALl/7Wk
   A==;
X-CSE-ConnectionGUID: r58NHG+VQGeM+uQcaxKWUg==
X-CSE-MsgGUID: vFa8epQpSgKDpHNj/2Na7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11722"; a="73956163"
X-IronPort-AV: E=Sophos;i="6.23,107,1770624000"; 
   d="scan'208";a="73956163"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2026 09:35:51 -0800
X-CSE-ConnectionGUID: GJuaGvdURzS227eFCWmoPA==
X-CSE-MsgGUID: dD0xoQxfTcSQVlJ9cARGqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,107,1770624000"; 
   d="scan'208";a="218535164"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 07 Mar 2026 09:35:49 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyvZ4-000000002Ob-0g8H;
	Sat, 07 Mar 2026 17:35:46 +0000
Date: Sun, 8 Mar 2026 01:35:13 +0800
From: kernel test robot <lkp@intel.com>
To: Haifeng Xu <haifeng.xu@shopee.com>, akpm@linux-foundation.org,
	david@fromorbit.com, roman.gushchin@linux.dev
Cc: oe-kbuild-all@lists.linux.dev, zhengqi.arch@bytedance.com,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Haifeng Xu <haifeng.xu@shopee.com>
Subject: Re: [PATCH 2/3] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
Message-ID: <202603080143.ehWbe58J-lkp@intel.com>
References: <20260306075757.198887-3-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306075757.198887-3-haifeng.xu@shopee.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 56E5F4000F
X-Stat-Signature: u8k4u5mxxceddcffcw3p1hh3zuxi4fwx
X-Rspam-User: 
X-HE-Tag: 1772904953-713460
X-HE-Meta: U2FsdGVkX1+tDv1SzEDMqC4BzZJpWhA7GLTi9h7QUBMf7he7Km6O8A3FK3AF6WiZsCdjx9AmSKNVFX0rn9koxOO6Si049gCfdhyhZ157O/teLP7hKX81qDAgYfmhrED7p47MY1q8J/zagpjgD6Y6Fj6dZHwOpNugVwffAPt/o3AXD8GGZhOYxxZfqxASAY/yBeIPDjW2ZtOtRy8Uo+HEOsZJbGO5ePRatEkbeRUrogIyHoP2fTRvFB5sx8GuQLagv6ld7zbcJ4pJV24uMcQfpejY7SjGX3kbMRXQnuynUmoFhAnIr0MIxirJKt3nd53dt0T7C+TjNtJevnY/qdQtLcFjgzGqadYPf0xDoE5i97ZwTwnwsvnxRZMtz2488fiLsx+zfX7I8H+eGFosb2z057DPw7WY87xSektxn5DC+8qhrf3ikwdwj8eM0BgofnSk/tHklJ9ALGBGahkCvbpF6Gyash3AmQQoktaHDK1ydQSeuk9sNwno5XXXP2e9OvHzX+Mm3WCxguTVeacZKytf91zAq72WXWtdSwShzDuZ5n8pScy408yNk9tNN3Vhz0Ca3D/Psmri5QNPsklE89fVdGcnvU0qOzz3Kx38xhd2Ce2IQS6wKsM89JAMpDNajIdiaM49kj1EKjpZG7EyuyckBYZJ0CklQZ2j/2f9kjYfdfFE/7Fkh2pNkeVPlVddfeNsTfp5ehlvkh3S0MFY98pXQm8RN1LDil1ZwA49Df9JUx58I+gU2uJaZ8gstnfn2EXSP06zsOOb3/6O2TfcScsp8odZCMbeuJu9P2vLX1eiMQ8JGPnEJFdZgIEZ+iJRUUaa1e3WTb6xOHvZj5wFXynlUgIAlwn10REiYE4mzB0fsQk27DxzIrujSj3qdatTZf/uGu2LF5BOGBoqhRpt2WLIn76+7SUFaJ+cN0r0cxmYL4znaegh5NgXx5sR3m/04PHgqyUnwjGeJDY6l527CK1
 xulPSQtx
 ITe+UB5wQDT/kz/L0xHKPDlJnxFds0lv6Ry/PbY2NqFl/2gKeUXB29AJHMTuYpAAulAynE9qmRSSNsFgLdxOwS9P7ZI9rVBsfnIb2mrGeUqTm/jj7UbHAXRCwseWqYjHKQKW+ukhgGfdNeIxutF9SKZllBT3wHfn3uJQnBBgEvzyALRjCAiJ9PV6bV+noGczjlGqlZGb9QdsF+V+qEriAv8dtmoBrXDxun5i5defBxuKlXEjcUGWHh+lkkHKfoXjqb56nOy0l0Oc+1AilgZJjDmbJIZPAzS0kpv3rcmeS3fTMDSlmBk/hUBr6/ZzBcwwMGDslj8y77E5VveIpaS8xz6uqNlvnMZgd3Bsi9iS5WOcBj86pKFd3rNX7ugLXiPPTSjWmN60qYV99784IYpY8PIgnpB/Tp7ic+oNWaw3mNY4ADRbfog4IbJmo+dOAve7AoNwBvAXOfX3gEVI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Haifeng,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v7.0-rc2 next-20260306]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Haifeng-Xu/mm-shrinker-introduce-new-function-get_shrinker_id/20260306-160247
base:   linus/master
patch link:    https://lore.kernel.org/r/20260306075757.198887-3-haifeng.xu%40shopee.com
patch subject: [PATCH 2/3] mm: shrinker: optimize the allocation of shrinker_info when setting cgroup_memory_nokmem
config: i386-randconfig-004-20260307 (https://download.01.org/0day-ci/archive/20260308/202603080143.ehWbe58J-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260308/202603080143.ehWbe58J-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603080143.ehWbe58J-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/huge_memory.c: In function 'deferred_split_folio':
>> mm/huge_memory.c:4355:57: error: 'struct shrinker' has no member named 'id'
    4355 |                         int id = deferred_split_shrinker->id;
         |                                                         ^~
>> mm/huge_memory.c:4358:61: error: 'struct shrinker' has no member named 'nonslab_id'
    4358 |                                 id = deferred_split_shrinker->nonslab_id;
         |                                                             ^~


vim +4355 mm/huge_memory.c

  4307	
  4308	/* partially_mapped=false won't clear PG_partially_mapped folio flag */
  4309	void deferred_split_folio(struct folio *folio, bool partially_mapped)
  4310	{
  4311		struct deferred_split *ds_queue;
  4312		unsigned long flags;
  4313	
  4314		/*
  4315		 * Order 1 folios have no space for a deferred list, but we also
  4316		 * won't waste much memory by not adding them to the deferred list.
  4317		 */
  4318		if (folio_order(folio) <= 1)
  4319			return;
  4320	
  4321		if (!partially_mapped && !split_underused_thp)
  4322			return;
  4323	
  4324		/*
  4325		 * Exclude swapcache: originally to avoid a corrupt deferred split
  4326		 * queue. Nowadays that is fully prevented by memcg1_swapout();
  4327		 * but if page reclaim is already handling the same folio, it is
  4328		 * unnecessary to handle it again in the shrinker, so excluding
  4329		 * swapcache here may still be a useful optimization.
  4330		 */
  4331		if (folio_test_swapcache(folio))
  4332			return;
  4333	
  4334		ds_queue = folio_split_queue_lock_irqsave(folio, &flags);
  4335		if (partially_mapped) {
  4336			if (!folio_test_partially_mapped(folio)) {
  4337				folio_set_partially_mapped(folio);
  4338				if (folio_test_pmd_mappable(folio))
  4339					count_vm_event(THP_DEFERRED_SPLIT_PAGE);
  4340				count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
  4341				mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
  4342	
  4343			}
  4344		} else {
  4345			/* partially mapped folios cannot become non-partially mapped */
  4346			VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
  4347		}
  4348		if (list_empty(&folio->_deferred_list)) {
  4349			struct mem_cgroup *memcg;
  4350	
  4351			memcg = folio_split_queue_memcg(folio, ds_queue);
  4352			list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
  4353			ds_queue->split_queue_len++;
  4354			if (memcg) {
> 4355				int id = deferred_split_shrinker->id;
  4356	
  4357				if (!memcg_kmem_online() &&  memcg != root_mem_cgroup)
> 4358					id = deferred_split_shrinker->nonslab_id;
  4359	
  4360				set_shrinker_bit(memcg, folio_nid(folio), id);
  4361			}
  4362		}
  4363		split_queue_unlock_irqrestore(ds_queue, flags);
  4364	}
  4365	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

