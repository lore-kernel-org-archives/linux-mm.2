Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D34E8CC6B2E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 05:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95F86B008A; Thu, 15 Oct 2026 01:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6EB66B008C; Thu, 15 Oct 2026 01:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A843D6B0092; Thu, 15 Oct 2026 01:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0596B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:08:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E86F640657
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:08:56 +0000 (UTC)
X-FDA: 85323681072.26.B6BF58E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5B0C3140009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 05:08:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gDsAs7Zq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792040934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ptgP00sd/ZHQf8jXyEC6r3P4XBtcjYgBjiI0CN+BPI=;
	b=ghB98lh0oMWYXUrAGvDV1DUX6jN1/B/U5FuGtfWeC/Z6o49YG9CdZX4+WPlJuHF5PMcOIH
	Bt6cC0AuuvCKcViElYn6jcYrkr4DmnY4abRT6C2EWDF+HW6dthZgwMdzCSnhUbMB+QXDGc
	kmK2OFpS+7v18DSXz6RmX3dUuCmTFDs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gDsAs7Zq;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf23.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792040934;
	b=zDJAr+Pc6S+kdanD2NQfEbc6fQCBny/YObTQNr8hrSqzK9G53LWAyt4tlwbbTRpg9fOyCB
	LxFVtZOVig+44DdTiRVZLjuaIst804pYl2i3X0WBCCtTxgxLgFFe8GeSZNhspimA96agua
	P4ltKi9j8Gq7v81JYLh6OKMx62gaYMA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792040934; x=1823576934;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=97Vu4jpYp2aks4nbaPyPADJJAJoPLb1W/mjp/r2Niuo=;
  b=gDsAs7Zqm8nJS526bla2ERKp/KUcU4mwWxu5awYHA5pT6WtD8UTA3yjO
   0B7qAa/CJMUjVIaprCbdmREnE3goG6czJ5FOysOhFK/MukysZbY+2boil
   UKeeFuWHdx+XgKO5YwH006N/W1H2eXR5dzN6NpQWvza6L6DpuOEXfiLh5
   P25keYLEcx4vr8DUMuyv/irct9XqlFTWB6JuZUt36kqkgI/6haGdfsVLd
   a/lWv/HMRkm8R1wjrJgrsNhjY41IvX7/RFJtjwBQ/8MI87Vbd1knPj1nc
   PrMz4mC4CUgvq+6HoHbmRVmsz/dBh7CF7rKt2S0Cje/y5G7gB3GlVpFNj
   w==;
X-CSE-ConnectionGUID: q5sBTz3MTSuOqyeNtfCC9Q==
X-CSE-MsgGUID: gC0vLzd+Ra6jFri9YaXrfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11935"; a="705812"
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="705812"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 22:08:52 -0700
X-CSE-ConnectionGUID: ggnnewxAQhOvKlDMXWFanw==
X-CSE-MsgGUID: t9OZU+hVS8q9thcdNllcrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="1518909"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 14 Oct 2026 22:08:49 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xHDht-00000000FqR-1LPb;
	Thu, 15 Oct 2026 05:08:45 +0000
Date: Thu, 15 Oct 2026 13:07:45 +0800
From: kernel test robot <lkp@intel.com>
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, gourry@gourry.net,
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com,
	peterz@infradead.org, mgorman@suse.de, riel@redhat.com,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	vschneid@redhat.com, kprateek.nayak@amd.com
Cc: oe-kbuild-all@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Li Zhe <lizhe.67@bytedance.com>
Subject: Re: [PATCH 5/6] sched/numa: do not feed tiering promotions into task
 placement stats
Message-ID: <202610151319.LxjGvN6y-lkp@intel.com>
References: <20261014094347.99157-6-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-6-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 5B0C3140009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: m3bmjf49tynofxdsfq98d958o4snyu4h
X-HE-Tag: 1792040934-980366
X-HE-Meta: U2FsdGVkX1+ui5Azcb/kw/5oi2XkMQhh+GpL/01gFuwkaXlvce8b5iaAZ7GOkSNFrDGs8m9ilIkJkHHIFr1UMQgHQeK32y9pibkTjAEm4rh0qYbBkrB8C2fbxZTWd29/vqRcBqxNqA7KF0TYykRtG3niw3mVWzlbxJkVCdqeLNf2JgVjCQaRlBFcX/am7T2lRh0X63W7paA/VoOS9PftU7xPCfBs4RHsowtP0GDpXsbWSIhZkS290r8OSgZ8OkTaY7/NnzcstoGzphz28/3RXlbXb6F7yVD3B4YIR03XT8WtRR+WXJ85gd8SHYHFQhenipMXzmT5Qv0S+lcGlXJ1Uc0c7Lve5itGBREd+e/qwjsLSSxMNV32wjKvpOmlRzw3r9HJLwhD/saY6nzCdpVtqy0l0hp6Bsk8Mthie2lOU7T2ZWne6tBfLNI4EVEvfmTOBVu9BBbFHiTctgq4uy8beX3ZAREaltZz1fT8pmNr9bZozwskvHH/l3rS58EihcG7vKnscDDr9NMLJjagqAFu6e6zTnSqr40DVCIGfT9mR3nGM5vXvP6HcVDNWAc0GYSSkyOxrAydZ7+sN1KoBbBkm1xrK17r2WPbgXJprWriW7HOQ6pl1YgMKlIsFN929d3uwp0OGHqlzt5EgsYTl69JEEgLPzT2Odj36WfhVq0LHxXOWguGBQGQq/hK9bifFE8ZvoA/5jhVFjnb2bKbBKJXYLzU4718a9+byt6Yq3GwTgzoaFTvqddDDWUA7rRkIrIE7hMsnI+BT1AblVtZVY++XiPPt9A3bCFMPMnC5HSDhLNvsEUTZWngDsIeqLZEny5mHxylMJt9uPFeTT9ES388sCqo4dlhS3PtiEjqabMHHyTDZHhacymlYtRChsFNAW7gIjuTrp0XELFArEb75z5dJDReHvmO7uB7xLmvC7EUmpAqd7cmklzipeM6Jrfvajb9/+xk9NZtfAZCUCgEPwV
 9laOInMx
 R0c8C5/njfzlx275RPB7JCSpBuxBG6PNb0c/BCB7VOHkXZ1hgxVzngGU7GEbzWjFTTd1YCqG5o0wUvrb+/ZGXU83X6jCtBVD1ZZ9Lghklwu4OfDP0/QfKB4gncHTx7ii+iSSQh2OCIYjWiJJKbXrKQMQkhZgrj+tefXfwVQFyb+V+3XP4i0MAONxylN3779vkOfmD3AyTiCsWlsyHuK7UmTD+Yna7GdRCp+NLxf5E0rs3LSjqQxQFVSadoFX/eykPQZLn0BI4BRt22VeA7NVAOHkA0lawgvPmVeEpr+B8eCAaycXvxTllpDI01QHDn5xKN4x/oeomTQqIpufA+Phhi+2spq/lBEakSW8zXeug8Lz/yVGt+RBSyUFbjf7uObyLuVRXz5w6e+vK1V6ba7oK4iB/+T99y5ITcKPFVcUjh2LiWnyk6to+nIJxNrcATbIb1WPBR+tS7M7gPPA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Li,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/sched/core]
[also build test ERROR on akpm-mm/mm-everything peterz-queue/sched/core linus/master v7.3-rc7 next-20261012]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Li-Zhe/sched-numa-clear-fault-locality-state-on-execve/20261014-174342
base:   tip/sched/core
patch link:    https://lore.kernel.org/r/20261014094347.99157-6-lizhe.67%40bytedance.com
patch subject: [PATCH 5/6] sched/numa: do not feed tiering promotions into task placement stats
config: csky-allnoconfig (https://download.01.org/0day-ci/archive/20261015/202610151319.LxjGvN6y-lkp@intel.com/config)
compiler: csky-linux-gcc (GCC) 16.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261015/202610151319.LxjGvN6y-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610151319.LxjGvN6y-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/memory.c: In function 'numa_migrate_check':
>> mm/memory.c:6176:32: error: 'LAST_CPUPID_ACCESS_TIME' undeclared (first use in this function)
    6176 |                 *last_cpupid = LAST_CPUPID_ACCESS_TIME;
         |                                ^~~~~~~~~~~~~~~~~~~~~~~
   mm/memory.c:6176:32: note: each undeclared identifier is reported only once for each function it appears in


vim +/LAST_CPUPID_ACCESS_TIME +6176 mm/memory.c

  6147	
  6148	int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
  6149			      unsigned long addr, int *flags,
  6150			      bool writable, int *last_cpupid)
  6151	{
  6152		struct vm_area_struct *vma = vmf->vma;
  6153	
  6154		/*
  6155		 * Avoid grouping on RO pages in general. RO pages shouldn't hurt as
  6156		 * much anyway since they can be in shared cache state. This misses
  6157		 * the case where a mapping is writable but the process never writes
  6158		 * to it but pte_write gets cleared during protection updates and
  6159		 * pte_dirty has unpredictable behaviour between PTE scan updates,
  6160		 * background writeback, dirty balancing and application behaviour.
  6161		 */
  6162		if (!writable)
  6163			*flags |= TNF_NO_GROUP;
  6164	
  6165		/*
  6166		 * Flag if the folio is shared between multiple address spaces. This
  6167		 * is later used when determining whether to group tasks together
  6168		 */
  6169		if (folio_maybe_mapped_shared(folio) && (vma->vm_flags & VM_SHARED))
  6170			*flags |= TNF_SHARED;
  6171		/*
  6172		 * For memory tiering mode, cpupid of slow memory page is used
  6173		 * to record page access time.  So use default value.
  6174		 */
  6175		if (folio_use_access_time(folio))
> 6176			*last_cpupid = LAST_CPUPID_ACCESS_TIME;
  6177		else
  6178			*last_cpupid = folio_last_cpupid(folio);
  6179	
  6180		/* Record the current PID accessing VMA */
  6181		vma_set_access_pid_bit(vma);
  6182	
  6183		count_vm_numa_event(NUMA_HINT_FAULTS);
  6184	#ifdef CONFIG_NUMA_BALANCING
  6185		count_memcg_folio_events(folio, NUMA_HINT_FAULTS, 1);
  6186	#endif
  6187		if (folio_nid(folio) == numa_node_id()) {
  6188			count_vm_numa_event(NUMA_HINT_FAULTS_LOCAL);
  6189			*flags |= TNF_FAULT_LOCAL;
  6190		}
  6191	
  6192		return mpol_misplaced(folio, vmf, addr);
  6193	}
  6194	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

