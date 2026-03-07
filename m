Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706F4F55121
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 22:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C61C6B0088; Sat,  7 Mar 2026 17:56:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49DFD6B0089; Sat,  7 Mar 2026 17:56:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39DD46B008A; Sat,  7 Mar 2026 17:56:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24BE86B0088
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 17:56:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B335A1A0166
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 22:56:31 +0000 (UTC)
X-FDA: 84520777782.08.5E402B7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B65C140006
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 22:56:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AAJwKln/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772924189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jZB8Ys1RtJ1sZgbEMJfjQU1SjUymJClpA9K2SQ4bUg=;
	b=aBW9pFh7jRw69igIdaFZQ/HcNvT4DLqiz71Nt17x5M329Y5/bKtsQsoEkmEGbeCQH6FCT5
	bans3t99g41XjjfdO1IJRkimNnqBgBud55bbz2sbzy2REHSJVVLFV4zE/ne54cMvaU3X54
	G/N+5kmRAR/545AyLk7OEU/naLscB1s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772924189; a=rsa-sha256;
	cv=none;
	b=wr40a8R0OAyX3fNPaNfTOjbY7wjY3fKGU0Q2/+wXQFDuwl5CCUa3AkJU78PojYn1ZECHcX
	MVJx5ORbK2oGNuPLjv2bS3AkZJ6LFej+Ax7ASjXU7ak23hL3eW6zqiWN0v9kDvbFVpnlcw
	rH6LxRYXOqHt2hIsO9ll0j+Rgf3WwEI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="AAJwKln/";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf09.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772924188; x=1804460188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=S8KcR1LmjqTxj/mWoKrlCUsjydq8SPbkoQLE2AIRIaY=;
  b=AAJwKln/kLqAi0NMPegU9dQZxj52OWH+FytEOaGv72Oz4WyqSGpQPril
   qDNjHEpq7QpdXl02PffkJJ7ESgkR/HNzh5+sX2b/4IViF9D9sXwQpDM1C
   zIsDXHofs/OnvHZGZHK5E24eVXCcvA/hxTl4Y5HkBUVbF0l1zykuprQy6
   2THQpWFI0BvQ+BHTWjRhwpaNPB0SgLONZbz4BQX3SU54MiyGuIEUBOLsm
   cbaBwyiXHmFz9ArwsTLk2+f/z7VaieS7axRrfO/yRZfNQnEfPrIuZ19M0
   EWpw9crE5ugGvl94kLw7ZPYpiYDpI1LQoHLyVHQbRtiVFg3FyE6foTRTt
   w==;
X-CSE-ConnectionGUID: 5ilcsQ5uRf6vHBEojjjKug==
X-CSE-MsgGUID: Sdorl+R2QEKgerhscR3O8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11722"; a="74043051"
X-IronPort-AV: E=Sophos;i="6.23,107,1770624000"; 
   d="scan'208";a="74043051"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2026 14:56:26 -0800
X-CSE-ConnectionGUID: uCIvkWKkSZKiepC7ovznDw==
X-CSE-MsgGUID: gyg//feTTbC9tPeuQ0GjLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,107,1770624000"; 
   d="scan'208";a="218573738"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 07 Mar 2026 14:56:21 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vz0ZF-000000002hR-42FW;
	Sat, 07 Mar 2026 22:56:17 +0000
Date: Sun, 8 Mar 2026 06:55:23 +0800
From: kernel test robot <lkp@intel.com>
To: Haifeng Xu <haifeng.xu@shopee.com>, akpm@linux-foundation.org,
	david@fromorbit.com, roman.gushchin@linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	zhengqi.arch@bytedance.com, muchun.song@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: Re: [PATCH 2/3] mm: shrinker: optimize the allocation of
 shrinker_info when setting cgroup_memory_nokmem
Message-ID: <202603080606.UQEPDmnB-lkp@intel.com>
References: <20260306075757.198887-3-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306075757.198887-3-haifeng.xu@shopee.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B65C140006
X-Stat-Signature: 8ztc6g4ezdu7qrpro437uztrgr5pqqoa
X-Rspam-User: 
X-HE-Tag: 1772924187-665759
X-HE-Meta: U2FsdGVkX1/3pYJELMOQmdJlczPljJT2d2m5vsPRwxxtZ0AEiFhMKtxejouSGIlhVd1yoZu50BUd7lc4z2LY0A0KCxLQYe5xubU8CP4UiH9y2/kvgWwZPiM1MHIKFnY8xEnfxQRbyIGS0kdv44QmGm+avtbaaBOcIAsDBEoGYHgmTRzUyEII/dPXqFJ7kG71BWyNyznHIlzWj8644NwyyM24OHkNO/ZiXbwGdzE4SMKBo/eOJyIDjW5ZwRAQCmbmXLFWK3Z9rGsrCYtjNOKiL0bmR2kpBYvF3mCWDAi69/JdpskL/HITgpNrtG5XhYvpS8VFyD4aZCsEy0TN+sdfVDLhYPgzTHzcTwFC8KNElvM2MDYVbRnsGgdbKNOfxetjPZH2n+Ro/rPMyLQ13EbVB+rCAH5CgIeAqP/c/KwhCtj5UVIofL4BQM+rTVOUZmhamex+FFnKRnDYOI2JuXPTnjX38VdUNsmt/HwN4SUtn3xhH7yLBGJDs01qhcjoUwBOMWWiZpj9DwEXLPiDDtW7UmD0xqboTTjj3upCMqy5po539hdJGyaeFe9ykY4P7UTEik2sv8muQ+nTpWMTaMEmfAsxTLMea9llf6LhpZJHhOLLu2EGPvbN9HgpVIcmPPW9TGLsViRnnU6sDePJKJlbidtR72OY4btJQMdHB+8jZ/PIhGCz3QJxaip/LwFtDbJHjjAZmWg/1xdOdg4S44ivnNNheelVXJb+1hyeaxG5WgiMQj2EW3c2qFhbb+FeVJMwQY+tur6OLB9JgBfM//PZm0xkrxMDqc8ILwEkdOOiVti8JLSg8X9gXEW6YjXltMiwWahPH7vtrqtJS86n6Swmo9uh2yFx9gdWWXG009KITd3WhOkXntLqM6ykTRuPR3bEail/zOfN5HEHsOCHJ/+e9jLVC4L9xhuJOHAUye6eJBZLpr6k+ANQ7WhUJn5K/dW0xs94eBEU3w3Arf5uUoN
 TKEfUhGX
 +LUjExvnW80LSEQYbkkBVHznoGvh1z7bpy2DZECxJqchnkJq7k82H36xc+eqK3/zy0RosTpAIufHPHBhuJ0nnhr5V9shXebOR5YVAFA1doVRqb7RDxRVUubLMaCYI3CmJvWYxGdusg/bSouMbBy0gFQ0c5h6IaSBHQw8mK/NhVAa8Al/fH5QiRHE7/TLDoHQk/qK3vrgKmHS76Ac8GZZ/dHaP93mSCUD7wbbACIWpfNSswubQh5POJo0NYlx48rSRRx3nm39jGxQuon7g4Xk1Cv0lokkoqiwpkQL+DNvHutejRQsY7AVFEXixNuaOjo/g002hAikdU/oonEX6fnuMqif1kORaf1OaXhcOqLhxoOuE1scBGjhklGaZiVtJMecSNMqD31/zjPAxFciqniZqD5RYhwqk5I+CrvjxYJ0XpwJaUvoEo3l3fFyG7EutlSiNEIAMbJxhmOGYpYA=
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
config: i386-randconfig-002-20260307 (https://download.01.org/0day-ci/archive/20260308/202603080606.UQEPDmnB-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260308/202603080606.UQEPDmnB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603080606.UQEPDmnB-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/huge_memory.c:4355:38: error: no member named 'id' in 'struct shrinker'
    4355 |                         int id = deferred_split_shrinker->id;
         |                                  ~~~~~~~~~~~~~~~~~~~~~~~  ^
>> mm/huge_memory.c:4358:35: error: no member named 'nonslab_id' in 'struct shrinker'
    4358 |                                 id = deferred_split_shrinker->nonslab_id;
         |                                      ~~~~~~~~~~~~~~~~~~~~~~~  ^
   2 errors generated.


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

