Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AF52C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 09:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83D726B0005; Sat, 11 Jul 2026 05:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EEAA6B0088; Sat, 11 Jul 2026 05:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7041F6B008A; Sat, 11 Jul 2026 05:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44F216B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 05:47:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF0601C3E79
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:47:30 +0000 (UTC)
X-FDA: 84976018260.20.58EC88A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 51ADA140007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:47:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jpy8qtjj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783763248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TyV+Pie9JBAqQMnFyWXKI8aYUqGfkRNwJoegycbNW6M=;
	b=ns9YBkRWVUPifePG0A89iE/BFGxyOyztl3NV919a1NNQbb7zOB3pveCGRCFmsJtw4201K1
	hv5iiU3imhMwRFwn8c2MQ/tMiEvPYpSaC1DY0bxoYWP4B4ANlT0RUfNUvq2gzRwM5zfM95
	9XPHfxBMS6FXr0O4K42Xy66ZpUBrxKE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=jpy8qtjj;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783763248;
	b=Smn89fL3J+gBYfG5q9BNvGItKBvoiiKPGw+evYWb+Q6n3yVKDNpO84olZsTuQnpDGXzhv9
	iGJx0rulYa3HiGMKuM8ZnsZmMt4fEFmNeRS1PbvFd9Pk0Mx9gr6XcKZrwpTb9/mBy9L1ip
	RPcc3d0K4B3eIJoCTA25Wlr2y3uDbTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783763247; x=1815299247;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Myl2BvsXEAApICtxbRdY9p3y0+4hx6JD5C+wzmSOtc4=;
  b=jpy8qtjjV0asLpu7Pu2XKFLKjOc/9qAEcgszjliD5U04ObRcjV4FDajd
   qnXk7R0A+p88TW9KSRseIui/s4jOpraSdZytpm4mliPWmCdFkTJzdG8jD
   s6tGIOD/4ET8MjqUuDKYByYTb2zPNDH64QHhPJN1bA8x3DgBSeZtjTvz0
   8uO2ZFLz6PXVMQW5AzasSlnX1EGAZKjRQ2GAr964iQ8Ui8k8xnjEpEAZh
   bv2GYiO5fVoo1IoOPT+/mr4b5lI2kXNAR8fjhfvTcl39s60LV9A3Vr615
   iBL65Nmvt0WVNm6tLk9skNqZ7RmLb/fpr6rLDYkhbONGQfQdRzY8FARDu
   g==;
X-CSE-ConnectionGUID: QmXS83u8R6aShHs7z0opKQ==
X-CSE-MsgGUID: U4Gl4xiNTtKhnpd7swTZLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84498498"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84498498"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2026 02:47:25 -0700
X-CSE-ConnectionGUID: qoBoc8+uRWGfOe7RGIyXEQ==
X-CSE-MsgGUID: U6O/wZskQk2LG90IzCZg4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="251121304"
Received: from lkp-server02.sh.intel.com (HELO ea128546eb3d) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 11 Jul 2026 02:47:23 -0700
Received: from kbuild by ea128546eb3d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wiUIq-00000000JxC-0CYt;
	Sat, 11 Jul 2026 09:47:20 +0000
Date: Sat, 11 Jul 2026 17:47:09 +0800
From: kernel test robot <lkp@intel.com>
To: Hongling Zeng <zenghongling@kylinos.cn>, akpm@linux-foundation.org,
	david@fromorbit.com, qi.zheng@linux.dev, roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: shrinker: fix double-free in alloc_shrinker_info
 error path
Message-ID: <202607111736.7pLPe0yR-lkp@intel.com>
References: <20260711041823.95135-1-zenghongling@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711041823.95135-1-zenghongling@kylinos.cn>
X-Stat-Signature: ze7fduysywwtxhfdca7x4z84p8a4jc18
X-Rspamd-Queue-Id: 51ADA140007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783763247-699440
X-HE-Meta: U2FsdGVkX1+GnSD3FY8P95Q6fY8BpxsFizPtGu9kmSnyZp1m9tN8ZOA9UqdmXE6ISxh7Ge6WkeXtJrIASU17KAImF54Qle3Z2F0N5Mn4UjxD7FKAIN9DjhmLwe/TVomtrsNivDBEUlu4m1BskpSyNRTDNraRvtn8LrQJG2/NR2xtIj/ReJqrKurqnDKV8yOg1csPvc1aUyOf4ZY8Q2NbGnBhV8fYnzdAn9Wyy48H1PMarRoOgIroNvS0nwM1+yVGmctVJ0XKfO0L4iA6BlBOKkjUTRmStYSchIwzCVmgQLkBuTvtDt+BU5+1byUKxzhIwoteHLKQu3M4RTn5Uoqukyyr6Kg2zSyMFhoUiK30WdQPiR7Qy4lrRnRrtXImpIV1Ht104Kjpfsw4Ia3hQjNbZQQc2E01QBHpUW8vgSBRsn3oRuI8m4n8ueeQMnfi3S9dhGZIRbRZnp6OyfxwMTrS9fHFW8tb31ZK506OtKeeUy3ekwv4t3m6Obz8Vwaj0JVYnusBrCCZrDL9Ru0/PxYMJxgmNE3f5/Ua96Wc6AnCws/uRMtiD2PHgGI6qMvg2PNWm9GOQEEudhkM/asHYGH+e9pZiCCvuB6iCGYjom9RXKbMTrcR+MfiHakA1JuyNSim9fhiLnLGn1cJozanBOn213iOs04XyWnmhP5a98e6X3wIvMpoHK4Nx6m1UECQ900PYqLhygtkerJeoluzw3FqVk+lE86Gp5SIqV84EZEXO4f/kW6ACzMsG4zcGAP8vmy/hZoQwCE8IwamLRBCfeObbdegB2zmIQcNgkQgwpsJR2a8TXeme3Jw4VOjMtYEw1P18njQXyWxUtZkuX/Xr+74tF14Pp9X6q0QwWfI2vhutYdGWIKRBBiEEpbdHUJjX+TpiYsf9+WfWHg7pxWZxhOMJjkpcHtqYIoo8CB7DhyPxZyruURxtM0qwvx7+LNNUatgXHFFJbfCQtCn5+rtmwH
 J2Jx0ifl
 67aMaoEulGI8vGDlxAATxScAYQsDGWMelMaQQIBSSSvwAZj+0KV0tuCCGA9vtcjZF+CmTbiF2ez3e3yog9wKp8J25Tk/9E1nZdr9SaxoDoyqbzbQJxPmS7j1kfXypG8sOXnjpR7SrQN7PTcTJ43MYHdC+Dtvh0SJAd9kAiYE99RSoWwQaWoAQXiwqmGwWfZjLuBppfWtmN7vpIFshlZNltBm9KW/Fr0Ge+R1ZR2NJ1vnyB0EdJ1+AIfzW98oMpSm2r4/2GuRgyE8JuwgSPShLxuaPvVtW3zIumLCaxqUx4k0nPEv4DmXE1IkbMHEXqrwm+Z4Wg5mqgKEe8qSU55vo/krA8mck6O/Z+1DHhslF/8fVK3bT3pyP+F5XHJqd27HIAVFZKL/lfhM9vZ2VE5VRLwDeJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hongling,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v7.2-rc2]
[cannot apply to akpm-mm/mm-everything linus/master next-20260710]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hongling-Zeng/mm-shrinker-fix-double-free-in-alloc_shrinker_info-error-path/20260711-122040
base:   v7.2-rc2
patch link:    https://lore.kernel.org/r/20260711041823.95135-1-zenghongling%40kylinos.cn
patch subject: [PATCH] mm: shrinker: fix double-free in alloc_shrinker_info error path
config: nios2-allmodconfig (https://download.01.org/0day-ci/archive/20260711/202607111736.7pLPe0yR-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260711/202607111736.7pLPe0yR-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607111736.7pLPe0yR-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/shrinker.c: In function 'alloc_shrinker_info':
   mm/shrinker.c:108:24: error: implicit declaration of function 'shrinker_info_protected' [-Werror=implicit-function-declaration]
     108 |                 info = shrinker_info_protected(memcg, nid);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~
>> mm/shrinker.c:108:22: warning: assignment to 'struct shrinker_info *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     108 |                 info = shrinker_info_protected(memcg, nid);
         |                      ^
   mm/shrinker.c: At top level:
   mm/shrinker.c:117:30: error: conflicting types for 'shrinker_info_protected'; have 'struct shrinker_info *(struct mem_cgroup *, int)'
     117 | static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
         |                              ^~~~~~~~~~~~~~~~~~~~~~~
   mm/shrinker.c:108:24: note: previous implicit declaration of 'shrinker_info_protected' with type 'int()'
     108 |                 info = shrinker_info_protected(memcg, nid);
         |                        ^~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +108 mm/shrinker.c

    76	
    77	int alloc_shrinker_info(struct mem_cgroup *memcg)
    78	{
    79		int nid, ret = 0;
    80		int array_size = 0;
    81		int failed_nid;
    82	
    83		mutex_lock(&shrinker_mutex);
    84		array_size = shrinker_unit_size(shrinker_nr_max);
    85		for_each_node(nid) {
    86			struct shrinker_info *info = kvzalloc_node(sizeof(*info) + array_size,
    87								   GFP_KERNEL, nid);
    88			if (!info)
    89				goto err;
    90			info->map_nr_max = shrinker_nr_max;
    91			if (shrinker_unit_alloc(info, NULL, nid)) {
    92				kvfree(info);
    93				goto err;
    94			}
    95			rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
    96		}
    97		mutex_unlock(&shrinker_mutex);
    98	
    99		return ret;
   100	
   101	err:
   102		failed_nid = nid;
   103		for_each_node(nid) {
   104			struct shrinker_info *info;
   105	
   106			if (nid >= failed_nid)
   107				break;
 > 108			info = shrinker_info_protected(memcg, nid);
   109			rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, NULL);
   110			shrinker_unit_free(info, 0);
   111			kvfree(info);
   112		}
   113		mutex_unlock(&shrinker_mutex);
   114		return -ENOMEM;
   115	}
   116	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

