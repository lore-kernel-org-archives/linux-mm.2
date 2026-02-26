Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4299FD9E1E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F7836B0274; Thu, 26 Feb 2026 18:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A5EF6B0275; Thu, 26 Feb 2026 18:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE86F6B0276; Thu, 26 Feb 2026 18:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D58646B0274
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:03:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7FB7B160363
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:03:14 +0000 (UTC)
X-FDA: 84488135508.24.A863045
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4B862C0012
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:03:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HMk4jFMu;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772146992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5UypsyKKeCREV0I4kkEJ6atzxFAX4PgCgpjS/IkNKfE=;
	b=uqqik6eB4rWV4MAH9ZNOjXYFbTXJQiNfdqJH/dA9IMX/nLIwpwyfrdy9AMqhSpKLyLpQtH
	sB7gzWoLtFbNfZSfvmrs20f25jprI9+YVmoLk74UPLc5WMc7wHgSR5RrtcLqtBoWU0lnU2
	CHPzdMspMZtlZhqfSAT/Etklbb9VyH4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HMk4jFMu;
	spf=pass (imf28.hostedemail.com: domain of lkp@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772146992; a=rsa-sha256;
	cv=none;
	b=7VIQXm5mfXiYGBj5VT/jaS6oYIm8Eiqjw08qb9p75HsObYRZSU8k7K/K2gWP3pkmJgbXzy
	Cq8ByXldpCWo+Q8i9liNG9M/WTIAw1Tgh/kfdN1IWRVwNW43UfXaCpwPa2pk5n3M+Sp2nZ
	kRzM+YUd3ZGsiVSx5fPFb8RjNRPdRYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772146991; x=1803682991;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SreBxnXx9H5+1XCmaSIiW+VRtXmst8sQevpR2PIDGS8=;
  b=HMk4jFMuylR+bigAoymc1mFkVj+R2wgXllFl2hsGVcIMXtm4s1Hv/sSA
   7qVvigm4KfvAoz7FRBeNanbBh8IiVYMUMuEHXiocubKuDa/MExVFCiATy
   OSY7KR/g1K0FKt6Qc6p2Mc1OBpsGpOdDr3z7INSuwz4t06z4L3FUrRo2H
   6cOL4eZM7sFLwte5VjM/59lCeAXdLiHqg7LLqtMzJU4zYjXKU7CKxW7HU
   cwOamXomHU9WDdReNnvsFI+/DfAjyPzfmkFOSUwPMLZt/IxVlikF4zW/6
   HN5krUkh9yCZjc/SkUyM0f7Wzj8jnEipFZBK/yRpLzivKMtICuUCMaNhk
   w==;
X-CSE-ConnectionGUID: PcKZFwweTCCoK0oToGZJVA==
X-CSE-MsgGUID: y6KKFBVlSVy6NNHT6IQCfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="73133992"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="73133992"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:03:07 -0800
X-CSE-ConnectionGUID: ZIvjQsmVT0qcB3SKaitltA==
X-CSE-MsgGUID: APSr2F91RjeZTN3y3woKgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="221716270"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 26 Feb 2026 15:03:02 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvkNm-000000009yZ-3u9j;
	Thu, 26 Feb 2026 23:02:58 +0000
Date: Fri, 27 Feb 2026 07:02:31 +0800
From: kernel test robot <lkp@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: oe-kbuild-all@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 8/8] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B
 per-memcg-lruvec
Message-ID: <202602270614.hOv7KIkV-lkp@intel.com>
References: <20260226192936.3190275-9-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226192936.3190275-9-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Stat-Signature: nie5ir1mb1n3qd45w6boiad7bdexccke
X-Rspamd-Queue-Id: 4B862C0012
X-Rspamd-Server: rspam10
X-HE-Tag: 1772146990-154561
X-HE-Meta: U2FsdGVkX18Z1UKaW23pmXrrOf3VW5SKarM9nKqiNBOsfEVx6aRuSKb2Msv2Mo2YkeOd1hy0WaEwpgaS7zgrTGi8G1+Vl5Y4EDhBhIUocD7uYguLIUthPiLDJzODHgeZXdXVtiWDGZcZH7s/aeGOu4cych42rkWJpV++e77LDW1471l1LVgA7TkgkW7UqkBuqNjIzP8NZhGuwiCe+00Ze4PgPS0GcG8PL2q1dNzXnqiKxApG2bJGavcAffTNB2fpAIfCHCJx+50i6c2GbvZlIwXSLsxrnduCQMymYJSqxuGgEyuDjJEFtTRF7d1lsLeBr4DR6MOvdxXuqgqy1Ytj5I6D2Sg8xd+nQc1Ojcq0Uf9SZ0AetkiPd5OoQXo3qpQBQiHFfWBDLsKa2HaF4RecSFKhoMPBlbaU+eAuf1gNOW3FTrBeY0BP26J5it+/RCW+UtUXGPNsC94+1LPCadTm8Ux2uptyHY7lScHhAyEzkkBVjJQ+9+DJg5WKxc+avVekgYYqq4q4Wc2wlaSam0hJ/8dT9HPgH6U7I7FmYrxQu5OdhrCb1UWwVO6ZDjmbcQtKcoZpaX1Bnhj454J6DjP1WVnkZD//rJSpoSZn+PI4E+hwy8YRjVoloMfnh+iujKBb3xJQTH6WmCoHX58IYQmGgl8ZKWXQ4kLYfSS2LTLgo9AfIRhrNW/kwn3pQvWVL23TZ62j3oPsGQ+TliVa5ByXBnDbUSmIro+eCGDbgP2NAVJhWntTZVskQv2o73qOSn2bM5Tr6cT7TnEfVd+WDeZ0NGDo06QNqJqsyOfvmhKz+cP/APRhCns0yQnYoRB7U5yaU8Cy3oc26ZWGdl+TvzIrf3SSXrDPRAku38FCTWkVLSo1l0b7VM0feOqSnYAwa7FLSn4CX+RY205Tu/GRHIgc+i4vcc4I0o/mvqBLN7oM1MlUO4Aiz/40hhoA4Se1pz8ncwvWnHsAHDCWHL5f4D1
 jGm8NaUp
 v3WwDomZoC0UGMhS9wwuIuIHMig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on linus/master v7.0-rc1]
[cannot apply to akpm-mm/mm-everything next-20260226]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-zsmalloc-Rename-zs_object_copy-to-zs_obj_copy/20260227-033239
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260226192936.3190275-9-joshua.hahnjy%40gmail.com
patch subject: [PATCH 8/8] mm/vmstat, memcontrol: Track ZSWAP_B, ZSWAPPED_B per-memcg-lruvec
config: m68k-defconfig (https://download.01.org/0day-ci/archive/20260227/202602270614.hOv7KIkV-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602270614.hOv7KIkV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602270614.hOv7KIkV-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/zsmalloc.c: In function '__free_zspage':
>> mm/zsmalloc.c:813:24: error: implicit declaration of function 'zpdesc_objcgs'; did you mean 'zpdesc_lock'? [-Wimplicit-function-declaration]
     813 |         bool objcg = !!zpdesc_objcgs(zspage->first_zpdesc);
         |                        ^~~~~~~~~~~~~
         |                        zpdesc_lock


vim +813 mm/zsmalloc.c

   808	
   809	static void __free_zspage(struct zs_pool *pool, struct size_class *class,
   810					struct zspage *zspage)
   811	{
   812		struct zpdesc *zpdesc, *next;
 > 813		bool objcg = !!zpdesc_objcgs(zspage->first_zpdesc);
   814	
   815		assert_spin_locked(&class->lock);
   816	
   817		VM_BUG_ON(get_zspage_inuse(zspage));
   818		VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
   819	
   820		next = zpdesc = get_first_zpdesc(zspage);
   821		do {
   822			VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
   823			next = get_next_zpdesc(zpdesc);
   824			reset_zpdesc(zpdesc);
   825			zpdesc_unlock(zpdesc);
   826			zpdesc_dec_zone_page_state(zpdesc);
   827			if (objcg)
   828				dec_node_page_state(zpdesc_page(zpdesc), NR_ZSWAP_B);
   829			zpdesc_put(zpdesc);
   830			zpdesc = next;
   831		} while (zpdesc != NULL);
   832	
   833		cache_free_zspage(zspage);
   834	
   835		class_stat_sub(class, ZS_OBJS_ALLOCATED, class->objs_per_zspage);
   836		atomic_long_sub(class->pages_per_zspage, &pool->pages_allocated);
   837	}
   838	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

