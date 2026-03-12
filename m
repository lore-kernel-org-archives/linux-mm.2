Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85283FED2C8
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E78996B0089; Wed, 11 Mar 2026 23:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB16C6B008A; Wed, 11 Mar 2026 23:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9DED6B008C; Wed, 11 Mar 2026 23:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC6676B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:52:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 784B6C2660
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:52:41 +0000 (UTC)
X-FDA: 84536039322.25.C3CF835
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id 42AE2180007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:52:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EruP8z4C;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773287559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NVJ4wab0+MXHzN7IIvue383xYr9h1IOLXe0x45tY8=;
	b=pURG5Lrq2lU6re3IY4ijdzvI/UvVrQ8+nnQMygAyrJX5KCpT8rIt4bCCfUEpK4YxTzKA4o
	E5iHm3XvYE9Y96j1VFcvLQbFEC2Ojyjg+E0NSAmIz+e6zg8R2hSfI6vjcfmltGIIGmvl30
	zV5GDw/mmykPpVDfTfoFvKgvST9lz0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773287559; a=rsa-sha256;
	cv=none;
	b=CuU4z19EmtKmai9e0i7iGNjmWDQwQbGGeWvP3oPTduG7GOh/H7ZzyMjLTo2NHs0A50fnbc
	a7z5ekQ7ldGDaPVVO4URorWhkl1WMbHYQbOsZTV16MBTDg9KiQO/ErZDqvbAaBAl9n2BS8
	mTjRie40Y/QW8dQvWDCKAWiNe+pBhnk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EruP8z4C;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773287559; x=1804823559;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NYSMMxWAdzwBiR4jQuYBqPNH2GBmxUx4Fg6ov9K48nQ=;
  b=EruP8z4CyDX6S6VBEfBLxOfrVSF1ehhmWZhAW9CNY6g8Kl2GOk4sIee1
   dBXwwKSWfB5LF2b/I3m3D+fJV6z/r0Ilgwgx6L++CG1kD/If/596Nqwmg
   Q93Lu3HexmmNkEbgnS+EF67aWRIk+ouAwIoI9uFdtA9AZhpez0GFsElSz
   Sppab+AmXSvwLfjCZEXA0st5P3qcTrXao1+4hhj9sbQGGmUwdf9KAeryw
   PdhyyhngYkwVidg2VS5cDnZCm+JZZs326qp6QCvxS8AgVLlb6/3NMlWBm
   K3A3b91rUX7EjgswroN0EOaJ2r34EPDxv+jpxbEpeBjJCE9Jj3kX58NwB
   A==;
X-CSE-ConnectionGUID: sD+bkTX6T5+cT5PxakSA9w==
X-CSE-MsgGUID: m+/t2990SZCMiL/muwSkKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="91749598"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="91749598"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 20:52:31 -0700
X-CSE-ConnectionGUID: pDOIVSnKRbS+/9aixbbHnA==
X-CSE-MsgGUID: P2LnaImdTJCJ3J9r9AYWIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="220863665"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 11 Mar 2026 20:52:28 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0X60-0000000022d-32hF;
	Thu, 12 Mar 2026 03:52:24 +0000
Date: Thu, 12 Mar 2026 11:51:58 +0800
From: kernel test robot <lkp@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: oe-kbuild-all@lists.linux.dev, Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 10/11] mm/zsmalloc: Handle single object charge migration
 in migrate_zspage
Message-ID: <202603121115.dm3Z6KvA-lkp@intel.com>
References: <20260311195153.4013476-11-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311195153.4013476-11-joshua.hahnjy@gmail.com>
X-Stat-Signature: am65rsmunrn8qpyjg4uxpuucd74rwuun
X-Rspam-User: 
X-Rspamd-Queue-Id: 42AE2180007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773287559-215015
X-HE-Meta: U2FsdGVkX1/9FHvM0OR5BveMAgay4oeRLsFfuI1J8FXDA84DNm27TrwPeawWPfO9TJ92HfK2ejKdXaZG5vdGZvTNr/olO8a3MiLcIZdUvnVXdyUCNXN6WRcqhlbbfeKibGKW8QOG4P6zA6pOML0CV0hgP8HRWa9AtLgObU+s7kUDvm+UND8VBCveK1bqt2bYqvuOrl/JIEzkZ5xgvuoeF9wMxLI5vMBkgTk3/ihsGxBDQ1iWT2v24p/y9Id92zvorKacUgzE9bH//MCjAsnw7kLSDJ/LuLwdcCmpnaf9DOOA3qwO/k7VNNO8OSiy2TPdJo5nqN4PsaO52RUezgYPjYeDK8A3hUE4xHb1WXaLL3Is2pxViQLMUcqHKkckGdLxrb1JUABPrer1waapyHwF96pc5/YCrUUPS8qeURsY2YJgWjguDLRM3B/RdlCOoon5WBzGyLD3B5JhKNSTq0tTJwoFrT4RjRmMNFZQv/pAFy4b6wnn+8h1oMEh1lF8ejORN6umRABHmwJgcnhsw6D1gT+YWkA2dmX9HEGuyji2Q7e57jnfKS+oeX+yVyPLkMghQcF8OOCbGqd55Bl4EuhciwNnKVN68I+TTS9FhbD60OjpWPVD+S2sofIROIa0TFpyahO0ydoj1cVfDpl0bl/XqyDxdThND7dBB/xqOemHfCPzmDeTdoPvInGdIFOT+TAs3vQ7nua9gEt+9sct55A2p084x35qsham5FCt+qFyQhV2FSqcyQWTkYc4VymvFIb1PvNd8Sa/uk7Cx5Eag74BCzigGwbDmXfpyVmhwqdzPl9HH/W1/OLQtEuiUo91MzAyK3l5l1zzRX3lRyr3r9tVoCIfrZ9R1kgWeCwE+0KhEhhXh5dJW4QM0wrt7p9GAjAOE3ulnJ1PUNF2SAch4m5SflzVO+SfMySDN1Tsuv4TfL/mSQZv8z9uSDYtwhEx4sZQ3erBOfHS4hZ1ZZcSgWg
 RYzrVAf9
 gg3f1T9Ni8zUrj0KpQdc6VCfrkxSm4Edsaeg1iAeQQU586aOX+FlKl/tjmzV17B/KxHccphMRLnsLVjHNMClWzT2HneFAkhLKi+6nTMHmpHKEobyH9puMDNWBXK8jljh8ewq0UVvSZL0DUDP3ra1ceMbi8XcyfPc9ydt/THZGQRoH4c5USwZsIay6aUwFJhJ5gS568r3iTzyB5HQERacDvCtTj0lGN1n/xKO2uc3c8AZelFnVhEWbExitm+nL/f95NrHvxlWBwXLQgyLOddGtr1Rss1uj7jCD4xeQyYT4a+kp2W+QgfhNMKZ8cj1ynsIMbB7TBHTyO2O2V6WHRBsJKdOGMBtUmzbRnxtwurZXdnYsLL3wPfq64f/NHkOuZ3swDnh+QlBtBpOFaoeP+B76lk1rhLl+gU1Qmabx8BOhJGV4dQhkI3DYWVl0NzG2hd/7N6jxr/PD91IExS37vlS+LF7URqyEqIm7JKygRfFzTTMj2Oj0hiGHy2xgzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joshua,

kernel test robot noticed the following build warnings:

[auto build test WARNING on axboe/for-next]
[also build test WARNING on linus/master v7.0-rc3]
[cannot apply to akpm-mm/mm-everything next-20260311]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Joshua-Hahn/mm-zsmalloc-Rename-zs_object_copy-to-zs_obj_copy/20260312-035531
base:   https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git for-next
patch link:    https://lore.kernel.org/r/20260311195153.4013476-11-joshua.hahnjy%40gmail.com
patch subject: [PATCH 10/11] mm/zsmalloc: Handle single object charge migration in migrate_zspage
config: arc-randconfig-001-20260312 (https://download.01.org/0day-ci/archive/20260312/202603121115.dm3Z6KvA-lkp@intel.com/config)
compiler: arc-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260312/202603121115.dm3Z6KvA-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603121115.dm3Z6KvA-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/zsmalloc.c: In function 'zs_compact.part.28':
>> mm/zsmalloc.c:1696:15: warning: 's_idx' is used uninitialized in this function [-Wuninitialized]
     unsigned int s_idx, d_idx;
                  ^~~~~


vim +/s_idx +1696 mm/zsmalloc.c

  1686	
  1687	#ifdef CONFIG_MEMCG
  1688	static void zs_migrate_objcg(struct zspage *s_zspage, struct zspage *d_zspage,
  1689				     unsigned long used_obj, unsigned long free_obj,
  1690				     struct zs_pool *pool, int size)
  1691	{
  1692		struct zpdesc *s_zpdesc, *d_zpdesc;
  1693		struct obj_cgroup *objcg;
  1694		struct mem_cgroup *memcg;
  1695		struct lruvec *l;
> 1696		unsigned int s_idx, d_idx;
  1697		unsigned int s_off, d_off;
  1698		int charges[4], nids[4], partial;
  1699		int s_bytes_in_page, d_bytes_in_page;
  1700		int i;
  1701	
  1702		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
  1703			goto out;
  1704	
  1705		obj_to_location(used_obj, &s_zpdesc, &s_idx);
  1706		obj_to_location(free_obj, &d_zpdesc, &d_idx);
  1707	
  1708		objcg = s_zspage->objcgs[s_idx];
  1709		if (!objcg)
  1710			goto out;
  1711	
  1712		/*
  1713		 * The object migration here can touch up to 4 nodes.
  1714		 * Instead of breaking down all possible combinations of node changes,
  1715		 * just uncharge entirely from the source and charge entirely to the
  1716		 * destination, even if there is are node overlaps between src and dst.
  1717		 */
  1718		s_off = (s_idx * size) % PAGE_SIZE;
  1719		d_off = (d_idx * size) % PAGE_SIZE;
  1720		s_bytes_in_page = min_t(int, size, PAGE_SIZE - s_off);
  1721		d_bytes_in_page = min_t(int, size, PAGE_SIZE - d_off);
  1722	
  1723		charges[0] = -s_bytes_in_page;
  1724		nids[0] = page_to_nid(zpdesc_page(s_zpdesc));
  1725		charges[1] = -(size - s_bytes_in_page); /* 0 if object doesn't span */
  1726		if (charges[1])
  1727			nids[1] = page_to_nid(zpdesc_page(get_next_zpdesc(s_zpdesc)));
  1728	
  1729		charges[2] = d_bytes_in_page;
  1730		nids[2] = page_to_nid(zpdesc_page(d_zpdesc));
  1731		charges[3] = size - d_bytes_in_page; /* 0 if object doesn't span */
  1732		if (charges[3])
  1733			nids[3] = page_to_nid(zpdesc_page(get_next_zpdesc(d_zpdesc)));
  1734	
  1735		rcu_read_lock();
  1736		memcg = obj_cgroup_memcg(objcg);
  1737		for (i = 0; i < 4; i++) {
  1738			if (!charges[i])
  1739				continue;
  1740	
  1741			l = mem_cgroup_lruvec(memcg, NODE_DATA(nids[i]));
  1742			partial = (PAGE_SIZE * charges[i]) / size;
  1743			mod_memcg_lruvec_state(l, pool->compressed_stat, charges[i]);
  1744			mod_memcg_lruvec_state(l, pool->uncompressed_stat, partial);
  1745		}
  1746		rcu_read_unlock();
  1747	
  1748		dec_node_page_state(zpdesc_page(s_zpdesc), pool->uncompressed_stat);
  1749		inc_node_page_state(zpdesc_page(d_zpdesc), pool->uncompressed_stat);
  1750	
  1751	out:
  1752		d_zspage->objcgs[d_idx] = s_zspage->objcgs[s_idx];
  1753		s_zspage->objcgs[s_idx] = NULL;
  1754	}
  1755	#else
  1756	static void zs_migrate_objcg(struct zspage *s_zspage, struct zspage *d_zspage,
  1757				     unsigned long used_obj, unsigned long free_obj,
  1758				     struct zs_pool *pool, int size)
  1759	{
  1760	}
  1761	#endif
  1762	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

