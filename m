Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FB0DFD9E21
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97426B025A; Thu, 26 Feb 2026 18:15:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AD46B0278; Thu, 26 Feb 2026 18:15:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A19FA6B0277; Thu, 26 Feb 2026 18:15:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86C086B025A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:15:08 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 364E81A03AC
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:15:08 +0000 (UTC)
X-FDA: 84488165496.29.816C018
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf25.hostedemail.com (Postfix) with ESMTP id BAD0CA0018
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:15:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="W/ZpgV94";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772147706; a=rsa-sha256;
	cv=none;
	b=AWj6yd1k9yjYdTXMcGHxabr0TRyEXMTZCncbMHnEi70mN/mEcxkGwYX2SVgwLcySsblIRx
	8RhhmzaIVgg8nl6N3TGrOwYgeSMP4qSAQUhRg0/jDM+ZQND2l0znVQfGwPxSyI69oApGrx
	splc0psut4S/hqd3PmttXKI7JjnWWsY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="W/ZpgV94";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772147706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kYYhRKCToHDsUCIuN4vrAmdcD6m3ohqjAjWv2cZpcwg=;
	b=iteIH1kPpUohuZcQa6SdRdBLPY4s1RGZWiKq8QLfl0M1dRWbX8Idzr+W4uhLGAaI4Q04Sl
	D0O9BMz3VP6eygvBHlA3N3vRQYZFrjPkP8Xjv/kgMsg+QeftF2AoeBEvlnj51XYGLxeadQ
	MMirz7Po0H3TPDlIa0AdVxjg7ht9UHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772147706; x=1803683706;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1QULWzsr2e2b65ZGOCuixqf1C/tdqrHaHG9NUQlBUIw=;
  b=W/ZpgV94GRHdVYKnF6N5yNJUknosuHN70GibP9j7E44ZwMxyznLpep/+
   toTUfntOEl5XlVl4b/hHwSPMy0O4hUQo/pn5M8knfm/qXT1bPUgDH6jRk
   e4+jWrm7qJlRE8LRo7lbEKsNmCkMmGa0eg5b39LpQoBL8JqthuO4xotW1
   Hmj1ToEZI0W7fl9CTo4Z9/3mwANqQ12F1SFSObQ4taYip21q4RNvj+zzY
   3iPC8O8rDheNQdMFU+G/s1o7Rrn224e7x0HBEr4ZYv0ZHOA9fDjgF4OpU
   kHzvh4mPzueODKnoK83ZG2TdiU94Fu84UpCdNPM690IbMHCQF+DSZFTe3
   A==;
X-CSE-ConnectionGUID: 9S9L3+YfRKKNCIXOtVpOkQ==
X-CSE-MsgGUID: X1fGkUCFT8e7cW4pbvCs3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11713"; a="77092927"
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="77092927"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2026 15:15:04 -0800
X-CSE-ConnectionGUID: 2Ujo1zZdSja+vhUZQWZEDg==
X-CSE-MsgGUID: aHK2O8JZRiaf+uBUehWdPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,313,1763452800"; 
   d="scan'208";a="216623051"
Received: from lkp-server02.sh.intel.com (HELO a3936d6a266d) ([10.239.97.151])
  by orviesa009.jf.intel.com with ESMTP; 26 Feb 2026 15:14:56 -0800
Received: from kbuild by a3936d6a266d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vvkYm-000000009zL-36dX;
	Thu, 26 Feb 2026 23:14:31 +0000
Date: Fri, 27 Feb 2026 07:13:12 +0800
From: kernel test robot <lkp@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: oe-kbuild-all@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 5/8] mm/zsmalloc,zswap: Redirect zswap_entry->obcg to
 zpdesc
Message-ID: <202602270738.SxqPEs3Q-lkp@intel.com>
References: <20260226192936.3190275-6-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226192936.3190275-6-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BAD0CA0018
X-Stat-Signature: re64y5zorauz1nwa3r6hhabbhu7bz1pw
X-Rspam-User: 
X-HE-Tag: 1772147705-280350
X-HE-Meta: U2FsdGVkX19ieCnTvbBMhk/r47tc8pqMzX89SRIjmbRw1tTHVN0oy9cZxQnRVKQPOmfp3Hu8DrlXZskZgPbGbGd6rD+wXURo1oP42w+08WBwFEkMgcOy3vVyfx/mIVanNYAvz80xHRFQswIW5No1Z6cdlOglacMXcTEZOSs40Ltk2ItS1ONUNH5La2hhvM+FXG5M/uyTHqX/MEiNmUlUrGWXicCbsXEfUmNuwuYAQ4NjROJeMJEDJBKLbqkf6Y6fd5lNY+mdlFrpdx6H1Mf5rGHhR/Ag1fk9O4rweWWnPuTHv0yzi0bQ7aE/ReMhBCmAATOdAGsUJc5GJrMyY1ddxGMhaaepPWZ6P79CVimIB8HinVcT2U+pflTikyrjwSXMPX7Fq/t1eERAHlBp5X1TraEzvgk4b2dcQ+DyZhnKX/jXM2dsMj1EBjnBJbEef2e/cthfZwCQlH05AIJwMShd1E0hnYwk8SO/RHphu2Y3jSoBx5KXNvkYGW9/PPg3LNPU2IyJ0QYX/rIY2nHTu0IS2pGac9df1CwZDKw1c7wIKLOK+rWMWnkVL8+ai0zYUmXT1TYKTeA3HzRT2o29M11xuZAu9mHTtaJYxF0e+eOh6Hwk34bpH627zuQRBbUPVrRm3IdjP4Q58g36+BNRPk0EDp73TpyH+MKow5NGGpVz19SDs2EgUG8b1pJBabQetWTH23QSzmarEc8lmK0xatXc9eM+iZueZ4mQeahsyKKrjP8TQ/SiLat/VXuSs8+lCMmJm6xz2PFd+s0AxuO3aqM6b3CxuKDxMSi2g3EAI32DshU5t0hDYdFYRZUmPpFS8n0AKNJiPKsZCgCzfyTfTK7DjxE3pOs99l9z5jXGnL/lNR7bwbu0PL/ppkh+rU0YZLxFBYJ4puOGyxRgG97bZ1WgiUcoQ1dwCFBKi0uNTNeSESw5kRdxGgf6b+gwrDhKMF7tbto4ZTMOaJHfEiKKTqj
 0BqIJ8kF
 5T3kGuNe7erjbRap2l63TIncOcfSHrdPxjE7311S1yxZkf/3zk6l4+kRX0BRL11+63yJseJZBP/QVbVIOZq5p9ctEAlIbFga8i3lu+hZOwC2x7Fz+G2DEGjLjCO0qItJljLpQjUgeukJk5MN+s/TEy8wG6BvLPbvvzx6lZpmwBlfy2Jyx6ipevLxzhqYDnIoiOr5tiN0J85GrVmdyUCc9e5V9/iWI+ffl110LXUKxm80S3cHdyN5wKpCUMjKQAD9fbBqtrJyumiQ/PF88njnrYSGJs8Xq9A1HXu1dIxilW2UEb8gycOoYaI9cg2m9CBB1SdiGwJTxFOum1wFl6OOqtExhAS8vcM1tRJX6oGg3v2+QUXwE6bX9oHivDxWNS+7EXN+iTTpkAfunL0MQRa7kWH01VFTcUTCEcoMJtwePhBgNU6uLHgofA424DFIiEr7SO0YaqEESAank2l9VmOoT9Jhp++eHK16LUQbnzVYlGk8g4lMNmfy6qM3NKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

kernel test robot noticed the following build errors:

[auto build test ERROR on axboe/for-next]
[also build test ERROR on linus/master v7.0-rc1 next-20260226]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-zsmalloc-Rename-zs_object_copy-to-zs_obj_copy/20260227-033239
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260226192936.3190275-6-joshua.hahnjy%40gmail.com
patch subject: [PATCH 5/8] mm/zsmalloc,zswap: Redirect zswap_entry->obcg to zpdesc
config: x86_64-buildonly-randconfig-004-20260227 (https://download.01.org/0day-ci/archive/20260227/202602270738.SxqPEs3Q-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260227/202602270738.SxqPEs3Q-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602270738.SxqPEs3Q-lkp@intel.com/

All errors (new ones prefixed by >>):

   mm/zswap.c: In function 'zswap_lru_add':
>> mm/zswap.c:626:25: error: implicit declaration of function 'obj_cgroup_memcg'; did you mean 'obj_cgroup_get'? [-Wimplicit-function-declaration]
     626 |         memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
         |                         ^~~~~~~~~~~~~~~~
         |                         obj_cgroup_get
>> mm/zswap.c:626:49: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
     626 |         memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
         |                                                 ^
   mm/zswap.c: In function 'zswap_lru_del':
   mm/zswap.c:639:49: error: pointer/integer type mismatch in conditional expression [-Wint-conversion]
     639 |         memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
         |                                                 ^


vim +626 mm/zswap.c

   607	
   608	static void zswap_lru_add(struct list_lru *list_lru, struct zswap_entry *entry,
   609				  struct obj_cgroup *objcg)
   610	{
   611		int nid = entry_to_nid(entry);
   612		struct mem_cgroup *memcg;
   613	
   614		/*
   615		 * Note that it is safe to use rcu_read_lock() here, even in the face of
   616		 * concurrent memcg offlining:
   617		 *
   618		 * 1. list_lru_add() is called before list_lru_one is dead. The
   619		 *    new entry will be reparented to memcg's parent's list_lru.
   620		 * 2. list_lru_add() is called after list_lru_one is dead. The
   621		 *    new entry will be added directly to memcg's parent's list_lru.
   622		 *
   623		 * Similar reasoning holds for list_lru_del().
   624		 */
   625		rcu_read_lock();
 > 626		memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
   627		/* will always succeed */
   628		list_lru_add(list_lru, &entry->lru, nid, memcg);
   629		rcu_read_unlock();
   630	}
   631	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

