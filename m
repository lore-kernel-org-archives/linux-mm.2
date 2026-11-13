Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606CF606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=hlbjPbIQ
Received: by kanga.kvack.org (Postfix)
	id 5AEC46B05C7; Fri, 13 Nov 2026 14:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58BDA6B05CD; Fri, 13 Nov 2026 14:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C196B05CF; Fri, 13 Nov 2026 14:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1F41F6B05C7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:43:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99194C029B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:43:35 +0000 (UTC)
X-FDA: 85431120390.14.10151B3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf26.hostedemail.com (Postfix) with ESMTP id C8CBB140002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:43:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hlbjPbIQ;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599013;
	b=6bAE7lKsh8uGLMuumtAFm5bqcZmRKTDwhxBDq85IhDBMEAbH0Ymx4H/0cUGMeyuDa8h+a9
	SagAAyGPVJdTuXlPP2BASID6QzbVwvshtT7DIqG42+JRYvuWAbuyM9EWAJMKT3VEiDLM6V
	CCIADqi6EXUff9dWI3io3RsD+2ZzTfE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=hlbjPbIQ;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.17 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4P8j+QMSewuz+uKE5PNg/893eiJ2vhGXM01N1veea0=;
	b=RwL8ZzrijEkQOKcWpPo1tcj0cTcKtSTQuwZLoAUGDSUXV2+Vprb/10bYNSPq32RV8wOS17
	TOT1d57AX1zf2Oxwaz7lJsnti/dq8PB5ZqNjM0IAui4a5YG4g2wpTmTBjV6DbmpQ6XryPN
	1spoWvBLda0/zklkAt1Ns+5xSZNOE7A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794599013; x=1826135013;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Cua/uwgNa005FQjs9yZ0Cq6T2u8yr5c8hJMGRbdb5yM=;
  b=hlbjPbIQNyXeKdBS+pK8V++hvIr+UaXQiQ+3+Bn3vpq2PnNb1a9/ZyTg
   gqnUEhI2giNKilfo756UA8EuTazdu+WagnJ8WrnqGPfTD9qI+4vKiLLmD
   NmiH031OkthcmwoOftocMZcB57LEi1+8CZlXcp6W1a1dJEYst4KhOxcMy
   32vh+vcNxebMjNL2P2yOER2GIdrIsb8GhIAS6v2CMO3bQhnD0T2wphiSy
   srXGJf5Ih/DgECyJlxOH9aBX7Lve9hskvQe6pQ2wNIoCZnQfjyEl5yt3c
   cQSoqM38A770mNTwFPwGn571wpEaHMV+bvX1zDJyih+tZ9/uz22JV+Blq
   w==;
X-CSE-ConnectionGUID: sIQO8kzKQIibB2nwrUHQHw==
X-CSE-MsgGUID: 9Ge0fN+uQQmVmbrV2Dz9FQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3405941"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3405941"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 11:43:31 -0800
X-CSE-ConnectionGUID: pS34q/LXTGORiKyYo7IdWA==
X-CSE-MsgGUID: RUTstUSRRweYGmOOPK6vdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="8841713"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 13 Nov 2026 11:43:27 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRxBE-000000013pP-0yI7;
	Fri, 13 Nov 2026 19:43:24 +0000
Date: Sat, 14 Nov 2026 03:42:53 +0800
From: kernel test robot <lkp@intel.com>
To: Chris Down <chris@chrisdown.name>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@linux-foundation.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-hardening@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 5/6] mm/slab: Support disabling
 KMALLOC_PARTITION_CACHES at boot
Message-ID: <202611140317.3kXloW0R-lkp@intel.com>
References: <9a4caff0336c78a7adc746786c81c9c01f89c40b.1794506262.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4caff0336c78a7adc746786c81c9c01f89c40b.1794506262.git.chris@chrisdown.name>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C8CBB140002
X-Stat-Signature: 3xjydh7n1tfj5q733k3h7yi49aecqrct
X-Rspam-User: 
X-HE-Tag: 1794599012-944650
X-HE-Meta: U2FsdGVkX1+io3M0mSmf1sPvuNH0pT+u6FICsTC/9sGi6OpluLeY/V8ee4gN5jnrlSHn49QzGltVLaoujsgX+fLImFIo2+erTbhjm7ZDGDCgIh/n19Gq3DkdBkM6o53L+oEYxBh/z2Bb9wHL69TJFTe7UWhIuaSZvofY36EQ4GXNFAcs9LD58gtV4+nrPRhBTKQBYRrY2PPZ/WqqzqLOt7Nwtc4WeFOo/2kndzdC6QkvL3o+A/0KAl8aApnq5YF/phhF9IeU7XMjGu4FUZnVfvBtBq4z2GRtehsBpxGroW5RBOJ9Cb5RmsZ6VUq827+Mb6k5gnE9XLYiabM/tmJNJedVQ7xr2AEeC/076POv8O+mVhBiEy627lme9CL3afGtQ3oY+kj5hS5VfjdfioEteeuw7LEW2H/403uSJ+Z36abzNj53CspLjIJD/5v3D+1bFIfVV0YpY3Gf7LNJyp1vXirh6LaQVAnHQad1c3PC2saqm+KN95BGF4/pMnsT7bUNMlgQuMFIp9KIHVKSWvCJI//70Zl4m3OcXM+KJZifqBIVT1N2XrS5QGJySiU9wC8L/B/lmU+9T42xJZaBMe4E8uWb98Vxx6VkE49OWF+MQWDAaUtUvZrAq0lldgPGdgdl1efws+i4mburYBSureFfb5SgHVB35U2jGkhsZmdxkSlNO34Md6AZ41S9R/io6ytLvTnCBa9UKlgYg+3IsAcfs9d88RKBS0qFyM2qIUM1eX0bCL+h/wE85VUF0s7KBZ7wRHTSfBPnJ/gotoZcT2Euv9PiLcjIpD3e8Hl7rwSpaxPFeLnDeq+tUVxAguZdmIqNWlyP63xIlCJ1qqeH65yzP2dtrw+Ty9TiwfeGAyncc7+7LtwvhfLSyimfFr1GiwmaIwLSDtDcI6zHhk4nzd6bLNPKSvVdg/zSchElAe2BPL+HluQDGiA30qINrpGlFH3nKyXcM+bgsYln7E/GBsP
 IC9RniGW
 WOyCRniS0WBThO6LQtnY3P7QYuO3eMSTzpq0whQD30L6TtPsi78A23w8OegH9jXP7ZaEJik4nu9/+exudH40DCXj5654DcOwhdopXgPNVTrgC5XTP3ROoBLrQjd65vAkozutJq5KKUgJzPMFpX10mfk1IHu5XGXo5g6wIoOrC/2nZPLKxR2BNlSv9v//2EVOxbGVGCfMGDSfmKsCsL7TLlBB5+zIUtNC8j2W580gL/0OP+VfMnaHyA22X7Cdgzu6b5OTAAZLrJoue22JFTCjcVmD3+93RYIzeMp9qN5z7amfEbTJk2d72S2DcVFQVsqwVAgaPpFAg/T2/N8L0InPFRmnpJcibac1vF/C9dbmL4/VtczgBNUeGEhNQNU6TT56YVI2T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Chris,

kernel test robot noticed the following build warnings:

[auto build test WARNING on ce6518e61e3b4bf4f97f7ac6204049b9eba7eb75]

url:    https://github.com/intel-lab-lkp/linux/commits/Chris-Down/mm-slab-Enable-SLAB_FREELIST_HARDENED-by-default/20261113-005125
base:   ce6518e61e3b4bf4f97f7ac6204049b9eba7eb75
patch link:    https://lore.kernel.org/r/9a4caff0336c78a7adc746786c81c9c01f89c40b.1794506262.git.chris%40chrisdown.name
patch subject: [PATCH v3 5/6] mm/slab: Support disabling KMALLOC_PARTITION_CACHES at boot
config: hexagon-allnoconfig (https://download.01.org/0day-ci/archive/20261114/202611140317.3kXloW0R-lkp@intel.com/config)
compiler: clang version 24.0.0git (https://github.com/llvm/llvm-project 1b1fed44d3dcca649a9877915d57c3357a98124e)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261114/202611140317.3kXloW0R-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611140317.3kXloW0R-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/slab_common.c:1029:44: warning: non-overlapping comparisons always evaluate to false [-Wtautological-overlap-compare]
    1029 |         } else if (type > KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END) {
         |                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +1029 mm/slab_common.c

   999	
  1000	static void __init
  1001	new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
  1002	{
  1003		slab_flags_t flags = 0;
  1004		unsigned int minalign = __kmalloc_minalign();
  1005		unsigned int aligned_size = kmalloc_info[idx].size;
  1006		int aligned_idx = idx;
  1007	
  1008		if ((KMALLOC_RECLAIM != KMALLOC_NORMAL) && (type == KMALLOC_RECLAIM)) {
  1009			flags |= SLAB_RECLAIM_ACCOUNT;
  1010		} else if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_CGROUP)) {
  1011			if (mem_cgroup_kmem_disabled()) {
  1012				kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
  1013				return;
  1014			}
  1015			flags |= SLAB_ACCOUNT;
  1016		} else if (IS_ENABLED(CONFIG_SLAB_OBJ_EXT) && type == KMALLOC_NO_OBJ_EXT) {
  1017			if (!need_kmalloc_no_objext()) {
  1018				kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
  1019				return;
  1020			}
  1021			flags |= SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
  1022		} else if (IS_ENABLED(CONFIG_ZONE_DMA) && (type == KMALLOC_DMA)) {
  1023			flags |= SLAB_CACHE_DMA;
  1024		}
  1025	
  1026		if (kmalloc_partition_enabled) {
  1027			if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END)
  1028				flags |= SLAB_NO_MERGE;
> 1029		} else if (type > KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END) {
  1030			/* Use the normal caches, which have already been created. */
  1031			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
  1032			return;
  1033		}
  1034	
  1035		/*
  1036		 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and not
  1037		 * aliased with any other type, make sure it's never merged with any other
  1038		 * cache.
  1039		 *
  1040		 * In other cases the kmalloc cache may end up being used for a
  1041		 * __GFP_ACCOUNT allocation so mark it as such. The exception is a
  1042		 * KMALLOC_NO_OBJ_EXT cache.
  1043		 */
  1044		if (!mem_cgroup_kmem_disabled()) {
  1045			if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
  1046				flags |= SLAB_NO_MERGE;
  1047			else if (!(flags & SLAB_NO_OBJ_EXT))
  1048				flags |= SLAB_MAY_ACCOUNT;
  1049		}
  1050	
  1051		if (minalign > ARCH_KMALLOC_MINALIGN) {
  1052			aligned_size = ALIGN(aligned_size, minalign);
  1053			aligned_idx = __kmalloc_index(aligned_size, false);
  1054		}
  1055	
  1056		if (!kmalloc_caches[type][aligned_idx])
  1057			kmalloc_caches[type][aligned_idx] = create_kmalloc_cache(
  1058						kmalloc_info[aligned_idx].name[type],
  1059						aligned_size, flags);
  1060		if (idx != aligned_idx)
  1061			kmalloc_caches[type][idx] = kmalloc_caches[type][aligned_idx];
  1062	}
  1063	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

