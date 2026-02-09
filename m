Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 429ECE7E0CD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 17:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F2E06B0088; Mon,  9 Feb 2026 12:12:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD9A6B0089; Mon,  9 Feb 2026 12:12:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9456B008A; Mon,  9 Feb 2026 12:12:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D8AE6B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 12:12:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4123CB2810
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:12:59 +0000 (UTC)
X-FDA: 84425563278.01.3281D1D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2A2A3100003
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:12:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m4Yhz0p1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770657177; a=rsa-sha256;
	cv=none;
	b=p0NZccNK56deLrDrDvKhgKbfwwCV8hUOPMod7Ul2XqZou1hPOFQHxNJzLNQmfTK707v3o3
	RFH8UQ9Jv56H6LZZan1HnRcLXR8LnMZvT9Wp34OZ/kEmHC8PrmKbcR5o35HD6vMyUf04kq
	jckbEGbomjNeyWKbaXuzCHX3y4Gy8vg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m4Yhz0p1;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of lkp@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770657177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHG80cNLOTnnJm1UrutLtsSI/97fF9XWzn50Z9GVgng=;
	b=tP1EGs06tpVwuGBP8ieOyDs69Hs0hl4gu92MRXHNoKtAaOMa64r4G9eUFV9OcZhHVnaR50
	tfzn/OSQu0lgtJ3ua6D1qdRkyTUJ49v4NY+qkT+lgL7QPvZz9AAOuSztdkjZZkqOUdv+x0
	Ys4scx14q2MeyREPZDV1sibNvvkcyGM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770657178; x=1802193178;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8Sub0P0wBitsQtcQWQoClr/YneNNLGxR7ML8aT1JB/s=;
  b=m4Yhz0p1eHj0r4WD8QIgOFRxhrH/OfZt9RsrjCuzXCIRJpASVfqM1BmP
   QKe1M/FVY8Icv7DzypnucMDMpmglQ3QdgFi4aoIT8qDYAEl2/x4YHRFey
   AxHWWBjiVZi7v4Egll+LxFEsZeERrRQ6ceXxjtThLrFbkhLvdn3Z62a3n
   jZEDvgIkEWUP3j7X/7vjQss2DPG9V+/3kVCv3KiCDTC1KCO840Blhr8jV
   Y5hgwJvEy8Bnnw5uXYAnv3qWmMEmXCxCfZLa+ctPHQ+d5XcpsCPB6Huh5
   t+Ib/mSdag59RH692QoRZoG5WEaCedz6FlmCEvQMZ9fgxPaeBkaD9bqmp
   w==;
X-CSE-ConnectionGUID: 2sBTUXunQdm/z0qgBf0MVA==
X-CSE-MsgGUID: dB1cPqCARuehDkYPiKfPMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="71812457"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="71812457"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 09:12:56 -0800
X-CSE-ConnectionGUID: kodm8n0eQkyUGfi1VPkc5A==
X-CSE-MsgGUID: Q2xaUuuRTp+sireEBbIn9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="211699525"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 09 Feb 2026 09:12:49 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpUoY-00000000o9a-0q0J;
	Mon, 09 Feb 2026 17:12:46 +0000
Date: Tue, 10 Feb 2026 01:12:17 +0800
From: kernel test robot <lkp@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, akpm@linux-foundation.org,
	hannes@cmpxchg.org, hughd@google.com, yosry.ahmed@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com, chrisl@kernel.org,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu,
	pavel@kernel.org, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
	joshua.hahnjy@gmail.com
Subject: Re: [PATCH v3 09/20] mm: swap: allocate a virtual swap slot for each
 swapped out page
Message-ID: <202602100110.Au8uHgc8-lkp@intel.com>
References: <20260208215839.87595-10-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208215839.87595-10-nphamcs@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2A2A3100003
X-Stat-Signature: 33jcicpw3adupxw8sa5w43gzbyuaa9pm
X-HE-Tag: 1770657176-938492
X-HE-Meta: U2FsdGVkX193EM0QwaNTLeDtDzqATn8h4XUjw3LL2KiPynjwV/0B5Hj2xlLUnsUsjcnZilVVuaTNp//cyAs17zt/7+0Rw/kEK5HR7vy6Lxzq4xNK42gaFUnc/bqDBUSz0m6rUuLn+ncg0egLVqHsdSzzW5Kud3zGDR9jkwuEFwgPu76YzeKsUdmUQ/GKzEZJZmLJYrlhSIPvHiUUrZJrgwbqWUzAP3LVfsmnnx3owK9J4vEFM1zbVu0AUrgdwADSsb1AGnF+kT4NSHH6rNvjFH7C1hg/SoAuBLY5KNY0jCL4DAeS8tM9vc/ACtp+wEgYhVAPqC3qz8b7+km3RzhO8Mo5U0suck8ehQS/C7ftXAoNCyPI2Td9gE1yOKtQ7+bIIGuFHkQLLXZ/BhUtpfRlPJa7jPYgtHWjjVXSkUR7PQnU+W//BiFfhCzMk0gKqMhC8ow/GTrLV8MpToEsAmH7mq2yD8pwsIXkZjHK309G5OlIlHJELqv96ERxRhK7gD3wSn7lpUm9rXetZc3R6dTeovJc5RJKApPXyJV72o9rQSEnZHkwbgPZ6RMw3ZoX4BsPtH/VRWIA4pMBSmpiPkVCdyCtScQba0NkHALeU3GfJxgX21PW1S0TnADVyrVpXatdKVSXWOnxPoAGNDzJsqJQ68KSGwp08I/R98sXARMDuuRtGnvJm50ClM3bdnPl1DWsudlQJ0viM5hXueS4QE2UhdyyyG11xbBQWfSvvA4LMZ0gnGC25rH5wieBJ8dvx6WBSWF/CpfYKBhGxJKyfz95OXma0m5Jx3L426eGrOWbmBbbxkHACnWQefJNU+FTvObx03D7TAtzq5RqdR8UxsI4ivHYIHZG1JihsPbYu1DnnqjNSbcRl+TYBYXGwSowoL+KdkH5yy/mk4chErKgO1+kN0UWjRf9S4PX4QMyBNr+HzF0URgnTXIZjYuPCX6OpgXm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on v6.19]
[cannot apply to akpm-mm/mm-everything tj-cgroup/for-next tip/smp/core next-20260205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nhat-Pham/swap-rearrange-the-swap-header-file/20260209-065842
base:   linus/master
patch link:    https://lore.kernel.org/r/20260208215839.87595-10-nphamcs%40gmail.com
patch subject: [PATCH v3 09/20] mm: swap: allocate a virtual swap slot for each swapped out page
config: s390-randconfig-r134-20260209 (https://download.01.org/0day-ci/archive/20260210/202602100110.Au8uHgc8-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.3.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602100110.Au8uHgc8-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602100110.Au8uHgc8-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> mm/vswap.c:653:9: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct local_lock_t * @@
   mm/vswap.c:653:9: sparse:     expected void const [noderef] __percpu *__vpp_verify
   mm/vswap.c:653:9: sparse:     got struct local_lock_t *
>> mm/vswap.c:653:9: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct local_lock_t * @@
   mm/vswap.c:653:9: sparse:     expected void const [noderef] __percpu *__vpp_verify
   mm/vswap.c:653:9: sparse:     got struct local_lock_t *
   mm/vswap.c:665:9: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct local_lock_t * @@
   mm/vswap.c:665:9: sparse:     expected void const [noderef] __percpu *__vpp_verify
   mm/vswap.c:665:9: sparse:     got struct local_lock_t *
   mm/vswap.c:665:9: sparse: sparse: incorrect type in initializer (different address spaces) @@     expected void const [noderef] __percpu *__vpp_verify @@     got struct local_lock_t * @@
   mm/vswap.c:665:9: sparse:     expected void const [noderef] __percpu *__vpp_verify
   mm/vswap.c:665:9: sparse:     got struct local_lock_t *
   mm/vswap.c:182:36: sparse: sparse: context imbalance in 'vswap_iter' - unexpected unlock
   mm/vswap.c:284:17: sparse: sparse: context imbalance in 'vswap_alloc' - different lock contexts for basic block
   mm/vswap.c:413:19: sparse: sparse: context imbalance in 'vswap_free' - unexpected unlock
   mm/vswap.c: note: in included file (through include/linux/rbtree.h, include/linux/mm_types.h, include/linux/mmzone.h, ...):
   include/linux/rcupdate.h:897:25: sparse: sparse: context imbalance in 'folio_alloc_swap' - unexpected unlock
   mm/vswap.c:570:9: sparse: sparse: context imbalance in 'swp_entry_to_swp_slot' - unexpected unlock

vim +653 mm/vswap.c

   643	
   644	static int vswap_cpu_dead(unsigned int cpu)
   645	{
   646		struct percpu_vswap_cluster *percpu_cluster;
   647		struct vswap_cluster *cluster;
   648		int order;
   649	
   650		percpu_cluster = per_cpu_ptr(&percpu_vswap_cluster, cpu);
   651	
   652		rcu_read_lock();
 > 653		local_lock(&percpu_cluster->lock);
   654		for (order = 0; order < SWAP_NR_ORDERS; order++) {
   655			cluster = percpu_cluster->clusters[order];
   656			if (cluster) {
   657				percpu_cluster->clusters[order] = NULL;
   658				spin_lock(&cluster->lock);
   659				cluster->cached = false;
   660				if (refcount_dec_and_test(&cluster->refcnt))
   661					vswap_cluster_free(cluster);
   662				spin_unlock(&cluster->lock);
   663			}
   664		}
   665		local_unlock(&percpu_cluster->lock);
   666		rcu_read_unlock();
   667	
   668		return 0;
   669	}
   670	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

