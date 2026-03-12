Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FCEFED2C2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CAC46B0088; Wed, 11 Mar 2026 23:52:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1792D6B0089; Wed, 11 Mar 2026 23:52:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05ACF6B008A; Wed, 11 Mar 2026 23:52:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E85526B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:52:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17A405A8D4
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:52:39 +0000 (UTC)
X-FDA: 84536039238.06.D5C98B7
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	by imf16.hostedemail.com (Postfix) with ESMTP id D0F8F18000D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:52:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kXiyqY1s;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773287556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MHSJOJ2069+1DMAL/C1TGAvODihTd7SQpfXmTZWQ8N0=;
	b=y/xk0d2veNgYhX7e/IoQQN03kYYFV/NWCcq0azMSnlNbK2XRIzmwlfWkMfrLgzPCrS6zZy
	cVpG/0z3LDwP10wFvPwYYZxrZRc5WziaHGQUQdWNHwiL+nk711t1XAbNDGhsJjLQWwBXX+
	UgK3AuEXOI05+fTcrpd/g9SjzrzhTnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773287556; a=rsa-sha256;
	cv=none;
	b=F+kE4CTzlHPAdWfcFg9qewHlWcoT7fllI5Eawt55cGdGYS+2XoUQZ2yWOhzrpm3TTnO7KA
	WKIqd0mfu1/fRigwJcjGf6QWh0HgnAiBwSYIW2yDT2om7UteSnwEYKpvVZ0Pne7Y5wKuyM
	BCIASHuBRzbLon/Up5yIJ3vLzL3hNrI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kXiyqY1s;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773287556; x=1804823556;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hgT3wFUEL6+EQV3boNcDOYwH0s8O8YUiGYj5Lz8pWeE=;
  b=kXiyqY1svn1P/Bk+sAZNqGayQ4J3zQriZsnao67Fd8bqOY/nT1ZETiUh
   sKcb/dGOG+SCiLAXKaLwVjsvuus42D9PGiW47dVTR3tPKK22apX3kQsVh
   4iBPzppeE5Sz9enh9r7q13oqZ9bTVfCWIQYaEJNDOyKj+N0QEwp+4+azR
   dBK9GCUs0meY2qq7zOftOKeodVnYzLQiN3x3MpwM1rcX2GpfjD9X0V/IL
   Qtw/MpeQ1apreCEhXUCHTZ+miD+iHC8TiOFnzvmo4pLkLGa+Cgc0Nr0KF
   MYk6SuadMJZO1mxnskE5F62Tj0Ch/w9ameEFAROFUlIEmZIi1sUr+oDfy
   w==;
X-CSE-ConnectionGUID: qoLjTRe0SzGNwnAwcxTS5A==
X-CSE-MsgGUID: M389q00iQsmakHmM/o+ZLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11726"; a="91749587"
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="91749587"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2026 20:52:31 -0700
X-CSE-ConnectionGUID: VcIHKcTrQMaHq4Kxx65oUQ==
X-CSE-MsgGUID: gEpSBS05SI+Pg21K9z98Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,115,1770624000"; 
   d="scan'208";a="220863664"
Received: from lkp-server01.sh.intel.com (HELO 418530b1a366) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 11 Mar 2026 20:52:27 -0700
Received: from kbuild by 418530b1a366 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w0X60-0000000022f-3Aoy;
	Thu, 12 Mar 2026 03:52:24 +0000
Date: Thu, 12 Mar 2026 11:51:59 +0800
From: kernel test robot <lkp@intel.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <hoangnhat.pham@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 10/11] mm/zsmalloc: Handle single object charge migration
 in migrate_zspage
Message-ID: <202603121158.g93vlc2U-lkp@intel.com>
References: <20260311195153.4013476-11-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311195153.4013476-11-joshua.hahnjy@gmail.com>
X-Stat-Signature: oaptkz1x4b6u75wwamrnjshw3c3kfdqe
X-Rspam-User: 
X-Rspamd-Queue-Id: D0F8F18000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1773287555-236777
X-HE-Meta: U2FsdGVkX18Ryvg+p/d4DNH+Nd0k2p3k0Yj1it6KpcOWIe9w6F5sY9ZYzZNg/vo8Bxo2wgKskz1l1zK/toxqkvz1zLd+DU8FgNyexiJK/Ds4l+yGBijA6x3gP5qvwAKIATEwWcJ6IHlrU2kpj+jOEW+8wpSH6dW5KxGWaj9+1jpxFDyH5n4eUDt07ZM35E51RRG690sB/7BlTBwI8V/GM4zCVnaF2IxV1iWhOmrVTsDerseuQ/yH8rpYomFUdOm6OofcnuGvIz7W+ZaHo2wLbWzKFCj29XBXkU2uFyh8mmZOVlgo//WyjhrF5zJ9usy3B6nb9l6CFvtiAMtQeRZqxD3e/wmZ5oOELSidOodaW96c7RcUJDVndD1I7zxh5TOUdZPWSE3sgzUu2MH8SPyxwZEowRZ3m43HsX/fEgieuhE7EZ4gqCEsY5G3yh9eXtJmcGUGWzQxzIj0QYLYVg80cuVW5lzw7bguTHOn6HLn/M9iHncpsarMhtgw97PnUYi08w+yFpCZ5K5qej6728HB0MmexKAP1Mk9FyMJkNCJNQIGCnZufEGVj8Q32WUSZCAwvw4TnwL2TYnZGLh3s/lZUIFeZnAP6ZaH/itkRpwi0MC+HWbpBjnWp2JSOKFcuJ7uwyhyJTV523B/+iyaFoElLCuM5dqnHI5rtk0EYmYJXn9VxeSTpBAJFAnBqlKCY9bChncfLwyQcsLtMFQhr+aab2+/y8/ngEb7/xPwZTO6Y/VmMOGb1ulxqHLY5RaQ0myIUUfEO/4sUxzd4x5iordqpBG5RFS8mKu18AvVS/JAuXnAQ5FzqiIf2Mn8HYQDTsbE4iFp7CDRS4fPT4tMyfWoS20CVkglsvNs8WFW2Lytk3HYIDLoYDkYbt1Lzfapkvrj9DyhZuiFLPRdN82ozu5wKJs9OleohwAXjfE1zq8pDzU8WCCJadCFVgvBJAe7fcFzEd/t1IGkzane9Wneqr+
 oz8BeDtF
 C7e2kB1xPoctLpT0ELGPKTftJ2oP+x7Wmd76URbK9mVopi9Cp/YbmwzNQHT483WhlwdLqxUOQ9ql/qTxwFkt2+B77PWqUqd9TJPyGxCAbLDVfAyadVI0bKGcgGGm5mKm+2aK9vtLvntY4R9leYi0yLIRwpUCg6UCoBowzEovw8b0vFM/Xu1zXP9Oc5fCb+yGmIFzUq6VPWKWyTQ3FsvHGN6ZMtecIedyxCgVUmw2JfpkTOBS7dIRhHYm0HOskeondFe+wzs8xNL+oCiLkTJI949f9bo2vCcbhRMq3Vgj0wbtZIzZ+hmJzoiwf9k7PVVzS8LeUsLXpN0tTP3frdJE1l1P/FhVJCWDHn3yXOe4y6L3wE42JV78xCwbEAGhcDyebEpnKEh/IuUuPVYsfidxHRjO0mYvAh24f7k+BSSyZD8ZwCfO1dPu3HvuUZkTs1fxJU1RfnHTHQookd0eCyATeFwixED1Ka4v0ACGmGssYPYDZTVBDd/w312+ASA==
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
config: x86_64-randconfig-001-20260312 (https://download.01.org/0day-ci/archive/20260312/202603121158.g93vlc2U-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260312/202603121158.g93vlc2U-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603121158.g93vlc2U-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/zsmalloc.c:1702:6: warning: variable 's_idx' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/zsmalloc.c:1752:45: note: uninitialized use occurs here
    1752 |         d_zspage->objcgs[d_idx] = s_zspage->objcgs[s_idx];
         |                                                    ^~~~~
   mm/zsmalloc.c:1702:2: note: remove the 'if' if its condition is always false
    1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1703 |                 goto out;
         |                 ~~~~~~~~
   mm/zsmalloc.c:1696:20: note: initialize the variable 's_idx' to silence this warning
    1696 |         unsigned int s_idx, d_idx;
         |                           ^
         |                            = 0
>> mm/zsmalloc.c:1702:6: warning: variable 'd_idx' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
    1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/zsmalloc.c:1752:19: note: uninitialized use occurs here
    1752 |         d_zspage->objcgs[d_idx] = s_zspage->objcgs[s_idx];
         |                          ^~~~~
   mm/zsmalloc.c:1702:2: note: remove the 'if' if its condition is always false
    1702 |         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1703 |                 goto out;
         |                 ~~~~~~~~
   mm/zsmalloc.c:1696:27: note: initialize the variable 'd_idx' to silence this warning
    1696 |         unsigned int s_idx, d_idx;
         |                                  ^
         |                                   = 0
   2 warnings generated.


vim +1702 mm/zsmalloc.c

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
  1696		unsigned int s_idx, d_idx;
  1697		unsigned int s_off, d_off;
  1698		int charges[4], nids[4], partial;
  1699		int s_bytes_in_page, d_bytes_in_page;
  1700		int i;
  1701	
> 1702		if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
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

