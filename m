Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED3B109E53E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 02:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF95E6B0088; Wed, 25 Mar 2026 22:36:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA036B0089; Wed, 25 Mar 2026 22:36:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0126B008C; Wed, 25 Mar 2026 22:36:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BAB3E6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 22:36:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8BA99E0F36
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:36:48 +0000 (UTC)
X-FDA: 84586651296.27.F60609B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 52B63140002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 02:36:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GCv94xcz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774492606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxZW/27rveOPzJ71cYW3IsmZ0fCFW7GkgZ4lENzSXr0=;
	b=18DsPFpwFbhgufgKljVB1T4OdXBZgxtbxAVxuIbhlxpwvVf8Wi1QvvxynO3HZvwOe8Imne
	MPUJOK5EMvTMznbnZJKk7WLcTpmrwvQkGdwmGeGlHECDepXU87TRY07pq7rSkpxkE86D5r
	v6H7F2/imTmO1Dm2EtUXZoy9FlXTidQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774492606; a=rsa-sha256;
	cv=none;
	b=OoxyZQ9Y8IWhClSpR8sZFEEkFGBIX5d9ozlivtBQNobIXQxjvz4+5Fpe8ds/PcyjFxH83N
	ak4m8oNp/XFUPolgVZew39sEvdPr9uxldu34tECZUN7+T/EB/UGDTKK6qjXPir+S1PdaPw
	CxUPy0cbW6dIa3FxCHJtLVBlZ45yMqc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GCv94xcz;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774492606; x=1806028606;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=h51sL9PmeyrBKQX01T7ZklE2Ap3Z+ATO2jaqwTZrFf8=;
  b=GCv94xcz9kp7BKrA5mPzShHAfRu5mvWc0Vn2qJdsli/Ts73E01C/clJv
   ERBT2jHQsSF3bEnVeTlj8kO7rz71wCQsqOOWv3lxye3HiY3VueSNWr+b8
   S9hHzYxo+pjM7kdQmwaGGUDrhGbF7wNKnub01Pxz6IyQctbGXeav/k03s
   fyNR+rqG1hoK6jmxVub60b1wRV4636EtAOwcRI95AIOdDVZQOyWnU1Cvy
   SNBv5+ysAngtahtCMw0ceO3JXcP6/wWZu+xd7wcG0A8cgUHhzKg4t12Uz
   bcFDhwxZh+WPRaEj4hOk1bhkARo79ryHOIOoQd9114sZhm7igwXiOkyHY
   A==;
X-CSE-ConnectionGUID: vbp+ZizPSrWiKgdShTaISg==
X-CSE-MsgGUID: V44s5KVURYuyPvmmrw+atw==
X-IronPort-AV: E=McAfee;i="6800,10657,11740"; a="79448438"
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="79448438"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2026 19:36:45 -0700
X-CSE-ConnectionGUID: oXNf72ZoT+K6i0Yp0FJ4jA==
X-CSE-MsgGUID: +tiT538TQOSn1dpq58/bWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,141,1770624000"; 
   d="scan'208";a="224051098"
Received: from igk-lkp-server01.igk.intel.com (HELO 9958d990ccf2) ([10.211.93.152])
  by orviesa010.jf.intel.com with ESMTP; 25 Mar 2026 19:36:39 -0700
Received: from kbuild by 9958d990ccf2 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w5aaJ-000000007DJ-1iqb;
	Thu, 26 Mar 2026 02:36:35 +0000
Date: Thu, 26 Mar 2026 03:35:39 +0100
From: kernel test robot <lkp@intel.com>
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com,
	usamaarif642@gmail.com
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type
 of mem_cgroup_update_lru_size()
Message-ID: <202603260338.GfCrsaVO-lkp@intel.com>
References: <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: 52B63140002
X-Stat-Signature: joumm4f86qc38nh5nrdqgw7m7cz34f4h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774492606-605195
X-HE-Meta: U2FsdGVkX1/kaokMYv+aZMBKUxfIHYZ1vlJibupF/m4S8wBYPewL/NcPj33naHMqXqL1R1elnTNkRVaG/IUhPF781LilsIlV/7W0XbJ+TZQuLUKr7x17xNPdvvMrPw95FfNnTmsxTM1nZMbciIcOAHZuLMdmtuYlc0QWw44ytj7X+t//5yu2UuiZpkyPbiDaEgUS44Az/UA9o9vVb1z+nSLnwPKrJPsyMvHOpYnelbSNAf5XrNs9ufvaYvzhwZAnpqkwvFF+H6GdEz/zhS+jgM+KlfxVG3tsnI+h3n33Z8dxeMfcEUaKtQ/L3UDIeIH01qygE0yVCYhtL9kQvp+bxHGBZt7qG83ZU8AZTsKJ5P167bdQwcN6M5mz/es5a1rk2slx3ymGDNpPa8XB0jOqG3kJm4QtEnbSDZogV8rUijmqROMjhTwEce5dBoB4R0kZ9Kh3QD0n33OrUODbqYR9tsE96pZdzIedhNLuvXrbNsq5nCk0rlsN8ruxhOy1e2LAtKzSvSPl/1YovwqiscBpnQRckQ3yVA76GK6TZinNQmsx1l6UyKjATQm25dXPyRp6aDLigPq6GIwz7Ob4ctSLqLd7ZB7S9r1fN5grO+QoY+r9Wdg+T9EmnKxWpz3Geb7YQOcjr2Qz8d0ODwGJL5v5rmKXtJqOaSxIubUNscJouWy4xp8e5buFT+L5yaraKVz0hB3bimIWVQ6YHYoKBRSmjAloM7a60zdMpYUkpLUGyZmR6ruiDkAwQ0TY49Y/AMsfXl4vQhdg2BQqdYncF9VTxtwJHhJqe6zNepuOUGJvlv8r1zANN+C+m5Z+y8GrGmfrA4E7kth00ZE6ggR1mXphLvopsR8rn3n5SbOcqOauPBx4rU0iuFtWJutP7007Zx6Dtb0BbRzQ+nmFLFJTOt6+NgRNqUSesn+0LhZzwm8kkQ+hyUNpFF8LTD5ad/THSyLBxQV10UzkhjhmLsbuKXz
 C71XwDLp
 AHJm/edDIzMG4ku6C/BbsO4G/8yVT3epY+mKxjgtTKm+WsW/OCmtwc4Mmx84RLVGZfr9Vw815W8d938xhUWxO5D+sTd61cEmqf+7dngVsKexme20q3b11r3EjBg7slIFHGyN/HJNaR4ugLwGQNvMn73br8gz9b40+ufdbfTxe8TOGrOjTVrO4P71u4enaV1473w8t2EajzgSJH1p//uWnjLPX0h7Qd7ILX2PBE5Oqy5y58G+g3Omlnve8bN7W2L8ctCwXuINkAZQFwrfFtM1tHP5DzIuCaS4dsWAs6wciMpqzA8htG0ffi7UCbL5Ij2cY3yxFKX954W+wHC/t0Sd20Vj8exdp6gwMUJYRnHnGa2CH99X9oZGbxxDlU1DprI/HDkEhZR8LsswbWXFUzB393i+QGVoM83XFnp96RCWoynnIblE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]
[also build test WARNING on next-20260325]
[cannot apply to trace/for-next linus/master v7.0-rc5]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-memcontrol-correct-the-type-of-stats_updates-to-unsigned-long/20260325-230337
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/2cf06f9faf51900ce6acbb4740fc60355a2842ed.1774342371.git.zhengqi.arch%40bytedance.com
patch subject: [PATCH 3/3] mm: memcontrol: correct the nr_pages parameter type of mem_cgroup_update_lru_size()
config: riscv-allnoconfig-bpf (https://download.01.org/0day-ci/archive/20260326/202603260338.GfCrsaVO-lkp@intel.com/config)
compiler: riscv64-linux-gnu-gcc (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260326/202603260338.GfCrsaVO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603260338.GfCrsaVO-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from ./arch/riscv/include/asm/bug.h:90,
                    from ./include/linux/bug.h:5,
                    from ./arch/riscv/include/asm/cmpxchg.h:9,
                    from ./arch/riscv/include/asm/barrier.h:14,
                    from ./include/linux/list.h:11,
                    from ./include/linux/cgroup-defs.h:12,
                    from mm/memcontrol.c:28:
   mm/memcontrol.c: In function 'mem_cgroup_update_lru_size':
>> mm/memcontrol.c:1486:17: warning: format '%d' expects argument of type 'int', but argument 5 has type 'long int' [-Wformat=]
    1486 |                 "%s(%p, %d, %d): lru_size %ld\n",
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    1487 |                 __func__, lruvec, lru, nr_pages, size)) {
         |                                        ~~~~~~~~
         |                                        |
         |                                        long int
   ./include/asm-generic/bug.h:133:31: note: in definition of macro '__WARN_printf'
     133 |                 __warn_printk(arg);                                     \
         |                               ^~~
   ./include/linux/once_lite.h:31:25: note: in expansion of macro 'WARN'
      31 |                         func(__VA_ARGS__);                              \
         |                         ^~~~
   ./include/asm-generic/bug.h:185:9: note: in expansion of macro 'DO_ONCE_LITE_IF'
     185 |         DO_ONCE_LITE_IF(condition, WARN, 1, format)
         |         ^~~~~~~~~~~~~~~
   mm/memcontrol.c:1485:13: note: in expansion of macro 'WARN_ONCE'
    1485 |         if (WARN_ONCE(size < 0,
         |             ^~~~~~~~~
   mm/memcontrol.c:1486:30: note: format string is defined here
    1486 |                 "%s(%p, %d, %d): lru_size %ld\n",
         |                             ~^
         |                              |
         |                              int
         |                             %ld


vim +1486 mm/memcontrol.c

6168d0da2b479ce Alex Shi           2020-12-15  1457  
925b7673cce3911 Johannes Weiner    2012-01-12  1458  /**
fa9add641b1b1c5 Hugh Dickins       2012-05-29  1459   * mem_cgroup_update_lru_size - account for adding or removing an lru page
fa9add641b1b1c5 Hugh Dickins       2012-05-29  1460   * @lruvec: mem_cgroup per zone lru vector
fa9add641b1b1c5 Hugh Dickins       2012-05-29  1461   * @lru: index of lru list the page is sitting on
b4536f0c829c858 Michal Hocko       2017-01-10  1462   * @zid: zone id of the accounted pages
fa9add641b1b1c5 Hugh Dickins       2012-05-29  1463   * @nr_pages: positive when adding or negative when removing
925b7673cce3911 Johannes Weiner    2012-01-12  1464   *
ca707239e8a7958 Hugh Dickins       2016-05-19  1465   * This function must be called under lru_lock, just before a page is added
07ca760673088f2 Hugh Dickins       2022-02-14  1466   * to or just after a page is removed from an lru list.
925b7673cce3911 Johannes Weiner    2012-01-12  1467   */
fa9add641b1b1c5 Hugh Dickins       2012-05-29  1468  void mem_cgroup_update_lru_size(struct lruvec *lruvec, enum lru_list lru,
6a3cda9fd4d0f0b Qi Zheng           2026-03-24  1469  				int zid, long nr_pages)
08e552c69c6930d KAMEZAWA Hiroyuki  2009-01-07  1470  {
ef8f2327996b5c2 Mel Gorman         2016-07-28  1471  	struct mem_cgroup_per_node *mz;
fa9add641b1b1c5 Hugh Dickins       2012-05-29  1472  	unsigned long *lru_size;
ca707239e8a7958 Hugh Dickins       2016-05-19  1473  	long size;
08e552c69c6930d KAMEZAWA Hiroyuki  2009-01-07  1474  
f8d665422603ee1 Hirokazu Takahashi 2009-01-07  1475  	if (mem_cgroup_disabled())
08e552c69c6930d KAMEZAWA Hiroyuki  2009-01-07  1476  		return;
6d12e2d8ddbe653 KAMEZAWA Hiroyuki  2008-02-07  1477  
ef8f2327996b5c2 Mel Gorman         2016-07-28  1478  	mz = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
b4536f0c829c858 Michal Hocko       2017-01-10  1479  	lru_size = &mz->lru_zone_size[zid][lru];
ca707239e8a7958 Hugh Dickins       2016-05-19  1480  
ca707239e8a7958 Hugh Dickins       2016-05-19  1481  	if (nr_pages < 0)
ca707239e8a7958 Hugh Dickins       2016-05-19  1482  		*lru_size += nr_pages;
ca707239e8a7958 Hugh Dickins       2016-05-19  1483  
ca707239e8a7958 Hugh Dickins       2016-05-19  1484  	size = *lru_size;
b4536f0c829c858 Michal Hocko       2017-01-10  1485  	if (WARN_ONCE(size < 0,
b4536f0c829c858 Michal Hocko       2017-01-10 @1486  		"%s(%p, %d, %d): lru_size %ld\n",
b4536f0c829c858 Michal Hocko       2017-01-10  1487  		__func__, lruvec, lru, nr_pages, size)) {
ca707239e8a7958 Hugh Dickins       2016-05-19  1488  		VM_BUG_ON(1);
ca707239e8a7958 Hugh Dickins       2016-05-19  1489  		*lru_size = 0;
ca707239e8a7958 Hugh Dickins       2016-05-19  1490  	}
ca707239e8a7958 Hugh Dickins       2016-05-19  1491  
ca707239e8a7958 Hugh Dickins       2016-05-19  1492  	if (nr_pages > 0)
fa9add641b1b1c5 Hugh Dickins       2012-05-29  1493  		*lru_size += nr_pages;
08e552c69c6930d KAMEZAWA Hiroyuki  2009-01-07  1494  }
544122e5e0ee27d KAMEZAWA Hiroyuki  2009-01-07  1495  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

