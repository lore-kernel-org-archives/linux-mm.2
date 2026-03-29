Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9DEFF3D5FF
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 11:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CFF56B0095; Sun, 29 Mar 2026 07:10:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031446B0096; Sun, 29 Mar 2026 07:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C256B0098; Sun, 29 Mar 2026 07:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEF6A6B0095
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 07:10:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97F6D160457
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:10:53 +0000 (UTC)
X-FDA: 84598833186.26.9E65FB0
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6BA7280013
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 11:10:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OL9KUyvS;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774782651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ld21qlHZQ88yPOIxV7geSt0rjLvnET0oI3mtiSnvUqI=;
	b=gtGYBwmnl5XRNLv075v2dd9BTWq4x+iTQxYCXb9C15d+0cRSL/ErO154zV9agHTrGcafMR
	CmZncjgXxTemNGbMB8crQNL7ISE57YEuE5CZq192GVvlQkGlQJBACz0b3i4YrhxvnaegE6
	Q41ViMePGzUfRJbRja/oNbEzORxy1q4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OL9KUyvS;
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774782651; a=rsa-sha256;
	cv=none;
	b=Qzn1jXV8Sean3fTZaG22X6R11ygoPYBuFE3k8Xj7cnOhdivOKHnH+6lgsFEFNCi3hdpjuP
	XJ+B5xuW2JPs6mdc8exWunUFfXp+juaVOz2EpocUVg/A6hOYBzzMeEAytSieFR2r3+NBk4
	6r9qHXh1/X7vGBxaLsa9Ef/ZY87mqg4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774782652; x=1806318652;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=HSIx2LO02QH/6HF5EjjOZpEuKotkH/5qG4AaR3HsyBQ=;
  b=OL9KUyvSurZEl5dDi2D+6AKQuhCR/EaUYXRMQ8qFWtHf0h3dcYZLlRK2
   U4nqwG+hBptUdZpBiomixEHqB37NLeWauuNofnOlsKN5izWHTzzoqV0Vm
   IsK9aDTH/lUMDOfnHDdgDHIzNL9HeBuby00l9hXvtrcki635LMpa/IT2N
   4eaP7DXptyj6JKonCOJPI3wzTaUJXq6px5IiQ4v9040+lhTsf04lh4mj+
   FrqR8Km16D1sGZJ8GrA33DgmwKJTxHvFdlSCUVDB7Tj1ey6tIrokyLtQy
   dhBObmKXhuAzSF/t/DXnYvPLNqabIFP1DX95yx5icWNNZc/SCw/NJt00Q
   A==;
X-CSE-ConnectionGUID: RkvkR4SqSICPyGrxsMG2QA==
X-CSE-MsgGUID: eSvrBKsAQpaYOlG2+JPEkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="93179812"
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="93179812"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2026 04:10:50 -0700
X-CSE-ConnectionGUID: TIhXxH2NTkiv3cMrceKMMQ==
X-CSE-MsgGUID: Q79xZq8XQEujZC6TnehROw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,148,1770624000"; 
   d="scan'208";a="229848130"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 29 Mar 2026 04:10:45 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6o2T-00000000CJ7-1TfT;
	Sun, 29 Mar 2026 11:10:41 +0000
Date: Sun, 29 Mar 2026 19:10:20 +0800
From: kernel test robot <lkp@intel.com>
To: Youngjun Park <youngjun.park@lge.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Chris Li <chrisl@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com
Subject: Re: [PATCH v5 3/4] mm: memcontrol: add interfaces for swap tier
 selection
Message-ID: <202603291945.9q4pyvON-lkp@intel.com>
References: <20260325175453.2523280-4-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325175453.2523280-4-youngjun.park@lge.com>
X-Rspamd-Queue-Id: 6BA7280013
X-Stat-Signature: g83mcf16qh86xnu6zfwzb1gtdsjxdzob
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774782651-166723
X-HE-Meta: U2FsdGVkX1/qYaveqvvObRF2UMvxKvm0UZ4swyRIMsD5vCmgqkF9La6AelyNq3u+bqod6jtQSlFx7/ozrIpsLeNHpS3sb1h5vFbEd3SVECrpupkr0Ud16qYGGZnKfxtHd2qmEM5tkFcemaQ07lxOJoAG5zFnxr0nsx57pkmDjUXY3TBdiMiP31ZW0DpHi6EKRiNs/QWSrqDXyoFDZnvfE083KyPEqwMadX1FZAQsiFZ9qyb8BfCYbaL3Th1blLYoy/TRLaYa6UmR/njMeq+EVP3xVJd/9pQ+JV8q8oRUelGnGIPCNTOsyF8n1ZUgpgEvs2Uvj5gZAt9c4C7JGsZ49/I9aZGlT5If9z3X9s4VmpSnu/z1wRcSVprEQWUz20DRfXGpNCgWAtotGpodoNTvdyWo/U0yqQnOPEqEu0o/O3kcWheLb6FHJGvOj9Cpm4cnYJZSG3ajwhhUVIoCrMObtLXqh4ez2rRs0YKHc7/2eA344iN+GTP3G4e2yt6Uj8Fvae3/Ad7M6uz5blHlBPPk3x2o0hnkdC7dRvSJPq8Yh3K2goSQ7dDJeIONAq2syFWTi+qretO0+IY8fEC+R1P6SiFzw6v6omvRHWDKrp1+qhZuVRYTgMwcrxAnKWqybUmachjSms7/hlAIqwxLem0+z4pgVUsIPdwwW/KeAIZqZtneUezTDI8pTSkDI6faolY6AcBH+Ywi5Zr+exz9Vo7D7RQRGxYhKPcCIxA1HOXkzCTL6NLFPxhuB/XflKzLW8x81RE9xJWKuiYYxpBiH7LqOIQMnZ2+K0UFtDQqT23i0Vaut1tU+85zKzZ73Px3Lp92AxxA9c+PeG16gyR7Mfy6+Fb2MBJ2VQ9E4wCNurUmI8ynG6QNa1LWU/6me1iULfNSPONIU6bSB/ttyy8uBqA/k49n5ullTJ/QhQ5drUKO1YK41c3u4tCEwpUVg3F/IsJDVOrrOQ3HoP4V+qvdGQy
 Hq2kzeXc
 TbC81UPa7XcJaijScrcyhW2LeRiXKwlHFZVSXSFSt2bGwJ8IZnqh4eTw6FR6d40XrtyvytJUBJREjO/1I6nDxazx0/PRijtTdRwvWquOua6BETWppjLvrpktMeFCQERn+G4dTpDkG00CSv/B7lTkVxkpnZlMoCg7Pj/Er/wQYKc/vz+N2PunWpQpV4o7DqiPSMQ0dBLuXtO6aS/ctfsLr+dHa6YK/o4TwC5xhM19mQpMDyFXW5TxW4uT7HK2iptf99LRx+qNTYZpfhHSCoAaCHbAqtZaXdG+gcAGQjUvfw7jDUHmCYmNjep4gn1z3We+H9sodlNScsc0WKIUqP8tJZfBuznr3/vwJtZYq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Youngjun,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6381a729fa7dda43574d93ab9c61cec516dd885b]

url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-introduce-swap-tier-infrastructure/20260327-203639
base:   6381a729fa7dda43574d93ab9c61cec516dd885b
patch link:    https://lore.kernel.org/r/20260325175453.2523280-4-youngjun.park%40lge.com
patch subject: [PATCH v5 3/4] mm: memcontrol: add interfaces for swap tier selection
config: hexagon-randconfig-002-20260329 (https://download.01.org/0day-ci/archive/20260329/202603291945.9q4pyvON-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 054e11d1a17e5ba88bb1a8ef32fad3346e80b186)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260329/202603291945.9q4pyvON-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603291945.9q4pyvON-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/swap_tier.c:141:10: warning: format specifies type 'long' but the argument has type '__ptrdiff_t' (aka 'int') [-Wformat]
     139 |                 len += sysfs_emit_at(buf, len, "%-16s %-5ld %-11d %-11d\n",
         |                                                       ~~~~~
         |                                                       %-5td
     140 |                                      tier->name,
     141 |                                      TIER_IDX(tier),
         |                                      ^~~~~~~~~~~~~~
   mm/swap_tier.c:33:24: note: expanded from macro 'TIER_IDX'
      33 | #define TIER_IDX(tier)  ((tier) - swap_tiers)
         |                         ^~~~~~~~~~~~~~~~~~~~~
>> mm/swap_tier.c:342:8: error: incomplete definition of type 'struct mem_cgroup'
     342 |                 child->tier_mask |= mask;
         |                 ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:343:8: error: incomplete definition of type 'struct mem_cgroup'
     343 |                 child->tier_effective_mask |= mask;
         |                 ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:420:20: error: incomplete definition of type 'struct mem_cgroup'
     420 |                 = parent ? parent->tier_effective_mask : TIER_ALL_MASK;
         |                            ~~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:422:7: error: incomplete definition of type 'struct mem_cgroup'
     422 |         memcg->tier_effective_mask
         |         ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   mm/swap_tier.c:423:27: error: incomplete definition of type 'struct mem_cgroup'
     423 |                 = effective_mask & memcg->tier_mask;
         |                                    ~~~~~^
   include/linux/mm_types.h:36:8: note: forward declaration of 'struct mem_cgroup'
      36 | struct mem_cgroup;
         |        ^
   1 warning and 5 errors generated.


vim +342 mm/swap_tier.c

   330	
   331	/*
   332	 * When a tier is removed, set its bit in every memcg's tier_mask and
   333	 * tier_effective_mask. This prevents stale tier indices from being
   334	 * silently filtered out if the same index is reused later.
   335	 */
   336	static void swap_tier_memcg_propagate(int mask)
   337	{
   338		struct mem_cgroup *child;
   339	
   340		rcu_read_lock();
   341		for_each_mem_cgroup_tree(child, root_mem_cgroup) {
 > 342			child->tier_mask |= mask;
   343			child->tier_effective_mask |= mask;
   344		}
   345		rcu_read_unlock();
   346	}
   347	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

