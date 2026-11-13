Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5878C606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Yf8PQ2Dy
Received: by kanga.kvack.org (Postfix)
	id 6A82A6B05E4; Fri, 13 Nov 2026 16:39:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631336B05E5; Fri, 13 Nov 2026 16:39:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FC4E6B05E6; Fri, 13 Nov 2026 16:39:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFB56B05E4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:39:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90CCAA0178
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:39:28 +0000 (UTC)
X-FDA: 85431412416.14.607FC64
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf30.hostedemail.com (Postfix) with ESMTP id E423880007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:39:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yf8PQ2Dy;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794605966;
	b=r16Jbu2rQdXzSgoT1XOUswoeMrfdR9tU8Ws/nM4f3XND/3WZb2+q4I7sMXCb69eqF/dq3H
	cfBulBtveUlc5apLQIDTOIKl1wLaVpx55rnpltdxUl8/xXN2l8D6RtUv7wrAqMAcnNxB9A
	1/vyIOENWzRtzeSl8sDEyCHxigQEW9U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Yf8PQ2Dy;
	spf=pass (imf30.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794605966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sN3tj/FW6lEkb5ESYZ24Fc6VqpV32e4/0iNa9+GF0B8=;
	b=ewchhOZaxrkDKxwzZAkM4zFGWq446euCCGn8sbs5WmyL/ZBYTzuG1/4b6ZEVKB2mNCLTim
	Ve8cDW/a/j1WiPaagdLzMKB/owJ1agpI2xBdUGwGjQS/o34d2wAe/iVH+KiiGFywHzTayr
	conYFwHNQnaY17dy2CH5aNzNtkm4eiE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794605966; x=1826141966;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c9p9t4VE534FXUhXu6OxhZWuIffdCLQSBk4DddauVXw=;
  b=Yf8PQ2DyY/qXrRaiwqWp+CwkloDsHUYjn7xnrfJVQUM1PK4vBMakq9+t
   /qwBuHkjFw0LZFOKbmvLU9JM7AkOfJdkF+Lg2J2DrEOXQCrP8SLuxpy8o
   Ay1QXOEhhiFqyI01yncH1AXKCnQB1Wh/dikiJixzOrNwTcoInHDgkBNJd
   ZupaiIViQY1DghVLLRN+Bi/ZvVedu4Y8j+vcLMdHVh2dn6HUc1Qe+IieM
   WAt0mmfMs+42kDenD1uaTvGTXMs5qRN8s+vV08JhSzYFE3kVHo6UO/8K4
   ZZrVMuSwYzLZCPaU8ZzEV+4zpyne2MhLcUCM7xw/wlQ71zXjc3vSV7wWC
   w==;
X-CSE-ConnectionGUID: cbHZY4ZpRiC7che/ae4Pxg==
X-CSE-MsgGUID: g7eb7S3gT2yvb+lsDKA75Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11965"; a="3410985"
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="3410985"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2026 13:39:25 -0800
X-CSE-ConnectionGUID: 2Pw22IxDSriY6YrYR05Tyg==
X-CSE-MsgGUID: e+pYcP6CSwGCNkglA8Exjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,212,1787036400"; 
   d="scan'208";a="9342060"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 13 Nov 2026 13:39:21 -0800
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xRyzN-0000000147T-03zh;
	Fri, 13 Nov 2026 21:39:17 +0000
Date: Sat, 14 Nov 2026 05:38:50 +0800
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
Message-ID: <202611140551.XAyf9KWi-lkp@intel.com>
References: <9a4caff0336c78a7adc746786c81c9c01f89c40b.1794506262.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4caff0336c78a7adc746786c81c9c01f89c40b.1794506262.git.chris@chrisdown.name>
X-Stat-Signature: wm8h5pu1wdygiaccicadi8y6xecw8itd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E423880007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794605965-606010
X-HE-Meta: U2FsdGVkX19u2Z5wyD2aFgGWzPraZw69LdU1zEduQOd34Mi4cBcxVZrHNJW1uMxI5ypI8lA0VC3PBTkQ/iUYpmxZZJ7HlClBlfY8y09Z814nUqV1+SZLwbklbzRIqLNIFOWfA3fu5PSv1jP2vAcTapMvcpagX2taGMCgR85ecD6rIu73U9h7bLRZQtJtljWkxNgr+yC7C2GC2r2MVBeQNEzlZk9nd/iCqB1FjEU4giExTF2i5Xywk/hPDyaVk236ASFag933teJXq2ut1ecqbqmmO91qmp8LnbfOkv+0C3ZS7FEfBENWKnOCEw2DFan6xOJCdgSXEU5VxFaVVDAM+2wqNM2tFocfdck4mqdqjG1yayEdHJ/ae+aO+6V+l3+AvziiT93XZTIaoc9UAlwkR0RbuQfl79sR7Po/ZTN8m4nHDxPg5z2z8+MpyuNdR+hYNrJ83EIiasdGERgHtJeUg34gf6NXXQMndnNJCkeIX8/vkb+pwg2ObbMyu4BJyglRilkNFxgV5luPKPYMBdBqNLFD3FjmYvvnL3OjiYnCAOr4lHb6mBK/o6Q6nGKAMybAdckHY5n+mT6SElVWxhxV78w9YvYHl06wS7nQiWMbKivueN1QgLsSkHvL3Pj/cVwTuklmiZ92qSceTqWFrus9UaHJkrdlYl0RTeiPtSKW7S0HHh5OkFSywkDjokuVukLH/xt7q0/MTOc+nKj1t2FGdD6GBfVsIGLg51ss4qYbHgaRD5WvyZOZQwdWU2yd/Q3ww9phNiz6gBAvfYbHX4sOwnqFzKQ1sXnE1MOmxVHhxzpbH5vQAHVzvVvBcnPoFjXuPF4KXO1vDZTUOHSAkGe+oPGf8gbIgqcvHTy0zxJV6w9Oa1WZADdCABTBxmKkMpZhpiqCXO3lQbwpD7jmEFC6GWmKdpbf39h43EzeFcwBKieR6CEd/q487TLJ02qi0w8qIRDH8bNA+hahbDzYZoe
 shyGG2vY
 UwggnesDLn+SDW1+pMSGAU2xOsu2Xh7kyYLqXJJsvqispAvl0OvkpCIfbhsxEhgdw/D7inFcnyKeoHXFqgAv5xFp8fz/INxQbM5N8p/Q/eGTVgPJP0qZsCSOkICvHVypzWILFGoGq2upJsclRcPvDMJFfl8sYO7b5uOVRk67Vq0lkOGegWnOAxhOYWIz5MVxkY669MR5/shkzrmouyhEN3XrzbcOSSd+VLXHXd2XqtttKI8AtRRuwseq19LRYvHZJhxcKyeI0m2ynV45VLZ9EGVS2vdmn1nTFCMYELL1zAd97gENkNn6e97T4c37n52zUDpKztXpqj6jfBFCjsraGHeVI4jZ0xDYzUsB34CJL8hMWhnFwOv8HpzS0vLq62gCp4ITvIopQeOVHQhcl2rBmOBmtkas4U23TSrja9UcKWHwbmj4vv6n45wRG7whZyYr8jfuQoJWgUe7C2+gTu+g1JM8tvkWRY1B5A/F0/x3MHeW0wSiAeegKKdRSaw==
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
config: arm-allnoconfig (https://download.01.org/0day-ci/archive/20261114/202611140551.XAyf9KWi-lkp@intel.com/config)
compiler: clang version 17.0.6 (https://github.com/llvm/llvm-project 6009708b4367171ccdbf4b5905cb6a803753fe18)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261114/202611140551.XAyf9KWi-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202611140551.XAyf9KWi-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/slab_common.c:1029:44: warning: overlapping comparisons always evaluate to false [-Wtautological-overlap-compare]
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

