Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6A72C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 13:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689156B0005; Sat, 11 Jul 2026 09:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63A606B0088; Sat, 11 Jul 2026 09:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FB86B008A; Sat, 11 Jul 2026 09:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 357596B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 09:27:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A97E3C4608
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 13:27:20 +0000 (UTC)
X-FDA: 84976572240.10.74CAA87
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3B1B520004
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 13:27:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G+OCdfCK;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783776438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s87WjN77G0DVhLBM472FG/d18pLao9dff8DrXNYV22Q=;
	b=WgsNeDBf3BhCy4kzW4Fwx5Um+AUdO8Bmxj0n0LuMG3L7SNEB5ne9CGBdghI4brWZbVMWNO
	LOmYEulSIKs1gUG22fgE7sbpFf1B41OxF/ehGsPHR0hktghOibiNb80EZ/rZnhacbjA6tK
	BhzUMALxRWyWSzQ+T/xY6TOPnnkjqTU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G+OCdfCK;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783776438;
	b=tY8VE89RAy93cKGj6QMf5zDGfVWVcYaAtXCGJAuStaH08xutP7JuQpMNIxa/SQ6A6nJ4qf
	GB7x/RxfTOcgUIRElRVlmeE4fQa0js5OlHtM9CN92gJkfPRBXqLISI/s0L85/0pp5z5lNP
	1uAA5TieNEr6wYVCAd3xjQotZRydZko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783776437; x=1815312437;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QMRwmmcabKQsDt2EYSGPCKTrdu5/Efzn6kpB0nGGT5U=;
  b=G+OCdfCKBuvHMAK+YLkGpfpCuTOwMagZ6ahWeB1t8WiBDiZ/Ls2Dnr0b
   kaT0ubYAhZ6khLDrlkUFin95LiNZXHQwf1PlFG0dGOi7IemHrfTVJNMuf
   hVN7vWrA0F9L4u0MQl0ND5l0dVHIolO0JnsRj2XTlZY8f7cInLYBw5Erj
   dhgv3BCG6NLr2ukvjA29GY5bYOkNxImSR63W/ry/+JY0eiRiDjmK95rmj
   iG5IWYfJF/HRJqT7SMr+noly8k3dNqGAcdSIS8Q4Y/AzfPHOPHKrToBT7
   LKnEoerSQ+lk77LQYvviIpzcC69d/MYPzcCDCJLAWLX8SXJkG80uSMjp2
   Q==;
X-CSE-ConnectionGUID: 6ZGlOm7jTK6/ye6CMDh27Q==
X-CSE-MsgGUID: D2xnyDNTRHmS0vTTDOPXlQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84649715"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84649715"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2026 06:27:16 -0700
X-CSE-ConnectionGUID: km0FdE8EQwS8E6vFC4DnIw==
X-CSE-MsgGUID: AFD9okqYQpmb3ZBBQN83ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="250711149"
Received: from igk-lkp-server01.igk.intel.com (HELO e5a8ed462067) ([10.211.93.152])
  by fmviesa006.fm.intel.com with ESMTP; 11 Jul 2026 06:27:13 -0700
Received: from kbuild by e5a8ed462067 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wiXja-000000003M9-3DKs;
	Sat, 11 Jul 2026 13:27:10 +0000
Date: Sat, 11 Jul 2026 15:27:06 +0200
From: kernel test robot <lkp@intel.com>
To: Hongling Zeng <zenghongling@kylinos.cn>, akpm@linux-foundation.org,
	david@fromorbit.com, qi.zheng@linux.dev, roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, zhongling0719@126.com,
	Hongling Zeng <zenghongling@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: shrinker: fix double-free in alloc_shrinker_info
 error path
Message-ID: <202607111559.uTGMAUhC-lkp@intel.com>
References: <20260711041823.95135-1-zenghongling@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711041823.95135-1-zenghongling@kylinos.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3B1B520004
X-Stat-Signature: n9xaq8t9w6yx7pqc8xwk39tnf1ankebc
X-HE-Tag: 1783776437-292048
X-HE-Meta: U2FsdGVkX1/My3S701Z1evzDe6BNCYrkrKtFJg2p/ImJv9pETR1+mxXZ54yJ+SoVumLobeoBRk/peetnPGwFNdhqb88gPHUq85uEuDqrvHl6al0oi+UBTy9Arkj154zeev3bNJf9l/n2Vi74jn7AhtPiGTnAMlxB+XrYIZ9DbzqTRyyv0HJrMENVwSpLQx+cSyx3ekpExLaswv1I/Cgd2HIebCiSrva0Mq9Xy2bsVQkRXIcQtIQxDokscmkXMomlPnr7BQ7syVJWODTTvo24q1fSNQ9HaL0KAhbsooK6b0Edzivt0FinZjJX5Hs3uNmG//kIBosVfTzd3Y2mlJCEg2ZRKEKk1u34IVacERwqJ+7yGjnKawXu9+1wzi1BC5YtbLJywJ6vjdMkX6y1cHpDXl5NayJXaXQ24gkhH4eCTHPNPdonkxMv1u+oNkE04j4q0UZhhBvifXgxY0luo922F3bZUpusxTY+GN3DQ7uW5FhlAKV91lOyc9XbETgduZqyhSEa9UoQoCVZYe0wsRTwcQkd1i2v0Wp8Rjcg+IeBwkQsyPIRYGyVyZ8e1qwkqBZUK0HNos3/IvGn4FQRfsfyiFUJZOpMRELNZx+KHw92rYW5pdWFLtL1Q+Cr96DMU1peqQpfb8Zm9wdSemJ4Z3CTngwapUVxLt2PzgW78YD9IOFDWq8uYGaQM68rFKo9ZKCiXR4fOX1avYDb/e4eYJQ/xP3/G2Sj0eF87/yXk8dH8PE4RD4rZcdK8NK78cT5B9X5uK2YiTtQRtYuvVzhKCZV0cgWMRpxEYxQkaDLfm+ANXebhnDafR58AFFt5y85f59g4hKXs0HLC8rTaAy9+l3IN1OOcQpZyHWPj76Q1/CM9Y69shv3aEaY+rJ9wyejL6ZD7+X13SkUTi2YuGtKKErUubGg/vQjAtkHk2XaKmwiElu4XIMnVlI4mHjvoWbUMVF6EzryTyyR9m8wllc5v1g
 kt59PkC7
 itfP21kipSLkYsiu4Q2VJMyQnwVpphfMdys2X24J4epWy8ujDru3X11xkd+42y8LWcDuaotkHeVXeygCUiHtJJVHGN7Yqwe4VuEEdpYf7jUZXYqzBXA529ygNjhPyJJNmG9Dj3uNmiDRKgyU6Q9D+KaYJCvXRufZJ2DJzSgPVKms28XLURpb/Qcj8Qp+sx79USyMZfNo+zQ8flrTOWniKE1/0PUDJPzXkG0Ce9TyuTQtHrn6p9/QnEPsNMKcTPuCqrQSF6QMe42YG/Ey7BXofYQDN6HNzxH1L07fbu05c42ioP1kpBKACvghaLEglMKYvhn+62JN+K11ixNc9JjctOwwKAvhaZ6ufM6PPFwTfGlhV4F7lJkmk/0MYWeTZqLH32sE74109aZQevW4l0m3snI/+N8Ku7+6+ZGctAGYySd1JWSw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hongling,

kernel test robot noticed the following build errors:

[auto build test ERROR on v7.2-rc2]
[cannot apply to akpm-mm/mm-everything linus/master next-20260710]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hongling-Zeng/mm-shrinker-fix-double-free-in-alloc_shrinker_info-error-path/20260711-122040
base:   v7.2-rc2
patch link:    https://lore.kernel.org/r/20260711041823.95135-1-zenghongling%40kylinos.cn
patch subject: [PATCH] mm: shrinker: fix double-free in alloc_shrinker_info error path
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260711/202607111559.uTGMAUhC-lkp@intel.com/config)
compiler: clang version 22.1.8 (https://github.com/llvm/llvm-project ca7933e47d3a3451d81e72ac174dcb5aa28b59d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260711/202607111559.uTGMAUhC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202607111559.uTGMAUhC-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/shrinker.c:108:10: error: call to undeclared function 'shrinker_info_protected'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     108 |                 info = shrinker_info_protected(memcg, nid);
         |                        ^
>> mm/shrinker.c:108:8: error: incompatible integer to pointer conversion assigning to 'struct shrinker_info *' from 'int' [-Wint-conversion]
     108 |                 info = shrinker_info_protected(memcg, nid);
         |                      ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/shrinker.c:117:30: error: conflicting types for 'shrinker_info_protected'
     117 | static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
         |                              ^
   mm/shrinker.c:108:10: note: previous implicit declaration is here
     108 |                 info = shrinker_info_protected(memcg, nid);
         |                        ^
   3 errors generated.


vim +/shrinker_info_protected +108 mm/shrinker.c

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
 > 117	static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
   118							     int nid)
   119	{
   120		return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
   121						 lockdep_is_held(&shrinker_mutex));
   122	}
   123	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

