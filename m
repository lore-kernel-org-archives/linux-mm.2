Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20246E9129A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:03:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68AC46B008A; Thu,  5 Feb 2026 10:03:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6591F6B0092; Thu,  5 Feb 2026 10:03:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562016B0093; Thu,  5 Feb 2026 10:03:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43AFF6B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:03:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F19BDBA1DF
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:03:24 +0000 (UTC)
X-FDA: 84410721528.10.3519600
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id E64C2A0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:03:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RnDGgUy+;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770303802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0A7mImDoJqYE8iqTqTlwjsy63QXtq7QGHpRpdhDFcs0=;
	b=YiQ/vL7ATELqHavMYj2KLkBPIiiZqezLi4Bp8cMakMlViKKEMCQv8PGyNxf+uEGDp2b8Pf
	1Eq+obSpCdxooJmXAr/8wVVVb42UiFhKOg0wSvRo3YpEMSL3qa8/itvX/2CaogPkMYHq7H
	K+LrzUC53wQTZg5RWwiYvPCNd6hWHOk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RnDGgUy+;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770303802; a=rsa-sha256;
	cv=none;
	b=Q3s+pF0FHgtV1VACFLWrFrZE1wmPuQ98P758DyjONH3gHqWNk67s96CzL8uj0ciCwioSOc
	W73ows85YgzmXcwi28VOghtJ1fDjgswCk8Tmj1mFIsFht3lQtEJM2/IJMXhwuCo8ZtqwzF
	+Ki+qW2+BgmNOUIA+WOxOw0gAIQlPYM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770303802; x=1801839802;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Zpzmafaxz3oopy0yMeDp4c8Ycv/ED5wfk9nLDnD++1Y=;
  b=RnDGgUy+YlBxKmjolnnI1076v+judih2+3UF0V0bc4sU9iUz5BOI0biV
   QAQm9X6sHfIxBRvZgQhTGYFxzeuYDLpGcbVYYB0xZp2s25p+xwYLoy+AS
   gBNjXUyLVIQIuSPVZlDhYrRTeW4VTmFNLDBh6NmFIHauMHVoQkYj0NmgN
   Qs1vNqR0kG32CcfDScb/ECe/W9AQAzy5bT2xg5EOGXDC0VvAlBmsXtEqj
   PvZ/5hKLT+c8vJockbP2ZFGQfXnlzviz8xLHLQ6jmK12onvbzfraZ88Cm
   NbG4Kv+0G6exVWIja6QoWnzrvMqwIQ26xgcy1N9MTN4G82yLOuKFOOzhw
   A==;
X-CSE-ConnectionGUID: /zvY56+nTLOAb8ohsxLV4A==
X-CSE-MsgGUID: /oQxv5tIS3OkMJ7vjxolaw==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="82873870"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="82873870"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 07:03:20 -0800
X-CSE-ConnectionGUID: R/yYo2qkSN2DEOwemuREZg==
X-CSE-MsgGUID: D0Ua/ykVQeCWN8y2HdhW9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="210468515"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 05 Feb 2026 07:03:12 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vo0sw-00000000juG-0Y00;
	Thu, 05 Feb 2026 15:03:10 +0000
Date: Thu, 5 Feb 2026 23:02:46 +0800
From: kernel test robot <lkp@intel.com>
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
	mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, bhe@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 24/31] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
Message-ID: <202602052247.VAoEwR9g-lkp@intel.com>
References: <e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E64C2A0004
X-Stat-Signature: 3rkm6m4dutbdbhctq7tnsaws7iuaqgow
X-Rspam-User: 
X-HE-Tag: 1770303801-624252
X-HE-Meta: U2FsdGVkX1/ZC/EmNL/G26mMMUtKLOl+Wtf4r73lnLETN7qW4vR6QCPv3u6q1/vMtVb40d7PiNFO067xF2oQ/dWsI4vT6+71AE04gY5pCW8d1heqrO58geY1JoXR6tK6bPC++r6oKGvf2BYaLTsFsrFr4RKPSuqwW2ijnF2300Qbx9E764/NI6Z7VfpY6jofTdJhk+nxSb/1Cf48oGwmymxG/T0zG/ezUdMpIp6OJvgGnhPf/wEw+Du7LcC1wCEfCGGLGsPOzkFjrACGfvuAN9iHPiKldAVGZQPo6YV9T11ztgsEvyPus42RHbvDikcSUHEsaAouGGPkAaZIgrwDwaqmOEsqmT4JY7P6tHV8xh3og92XBGIIWTrz2xF6hmP1jWrb3rhhi23FkS0Kkth4WAiWeiDBBuLa6VmOTHXmJ/hYg6hikNlUZ9Chf72+v4UVa2rIT5qgKr83o1WuHrFv2sOSEjGRGCFv6bqcDrRjlXTbBqugHgQDF0n+0m4Wk9geJwy8r9xAC/VHQD3sbrW5IuMpaqkcCUPS5v0aNl2pl5XlTIpWrz4p3Q3Hzar+4pvatM+inMkU9xcGRVFk+CkCdAKsSlb238vGb2hC816wWsK7zOA2qjM0XVG3nDorbZsZIlck/3jMNuh5lqXT4wIW8NTUDda68ny7M39nvECIAlgp6Mhuk9+5E26Mz7cBAt7KJv0WHA72FbxAw4e6gbfzY/hb6zb4Ya0pVzvzO3P0lfaK5S7W9Z4m1DUao5yF9zeV9QD8B3kDqiIWRfqRQ3Bi/kxHEOooi1Gfwx1/fzMJTOE9w/uH7nqtx0MZjEwmzrbvLZtqeugt0G/Vy/YCWPsxRPwec3J+Eu/HR3MnW8Hlx2XLttMNvpRAWSwrN6EVffUjiKmVEsQpBvF+tEtjvNLThYp8us711+9yFQX8MW/1FlcHLNieRcGon9w8hfBQ8/zdQFgYxTGK9CY7J8p4wux
 8iy8W+9U
 vbC3ZTpSjRq34cuE+S3FY1NSDB/QjARZ9HpfQWj5XPnv9GAkgRq57wDtGKysw8M2AQKEINHXLvr9P+LtbsqxtpAyZ4ez4I+X3cS8HpQjF9lT3uOF5t9ylthlohBMKJOWjQ7jL/H+A5iCwxDIrKJuxgFK1Xew3320Zc9HaoBnlvkdL/yN7XTf5cUXh2mwtCa+GaRWVfN/WNTS4r2eD3+HkcoM9nvokY1/nOlvwRY7wOfmr2bNJIhQg6uu41/HMq+eEau1OmEpYuxLtcR4joNg5TAMQZUPYYcQ9BARLZW3KCOWsrsfF/7u/Cf4A6wla3Jz/neMc790e5yBLinp48INA6yh8FfVqy+DHu0awhYh/+7/rQWCBzW4alem2Ru5mlfx9Un5X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Qi,

kernel test robot noticed the following build errors:

[auto build test ERROR on next-20260204]
[cannot apply to akpm-mm/mm-everything brauner-vfs/vfs.all trace/for-next tj-cgroup/for-next linus/master dennis-percpu/for-next v6.19-rc8 v6.19-rc7 v6.19-rc6 v6.19-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Qi-Zheng/mm-memcontrol-remove-dead-code-of-checking-parent-memory-cgroup/20260205-170812
base:   next-20260204
patch link:    https://lore.kernel.org/r/e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch%40bytedance.com
patch subject: [PATCH v4 24/31] mm: memcontrol: prepare for reparenting LRU pages for lruvec lock
config: xtensa-allnoconfig (https://download.01.org/0day-ci/archive/20260205/202602052247.VAoEwR9g-lkp@intel.com/config)
compiler: xtensa-linux-gcc (GCC) 15.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602052247.VAoEwR9g-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602052247.VAoEwR9g-lkp@intel.com/

All errors (new ones prefixed by >>):

>> xtensa-linux-ld: mm/swap.o:(.text+0x40): undefined reference to `lruvec_unlock_irqrestore'
   xtensa-linux-ld: mm/swap.o: in function `__page_cache_release.part.0':
   swap.c:(.text+0x60): undefined reference to `lruvec_unlock_irqrestore'
   xtensa-linux-ld: mm/swap.o: in function `__folio_put':
   swap.c:(.text+0x1a6): undefined reference to `lruvec_unlock_irqrestore'
   xtensa-linux-ld: mm/swap.o: in function `folios_put_refs':
   swap.c:(.text+0x276): undefined reference to `lruvec_unlock_irqrestore'
   xtensa-linux-ld: mm/swap.o: in function `folio_batch_move_lru':
   swap.c:(.text+0x31a): undefined reference to `lruvec_unlock_irqrestore'
   xtensa-linux-ld: mm/swap.o:swap.c:(.text+0x354): more undefined references to `lruvec_unlock_irqrestore' follow
   xtensa-linux-ld: mm/swap.o: in function `lru_note_cost_refault':
   swap.c:(.text+0x1340): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: mm/swap.o: in function `folio_activate':
   swap.c:(.text+0x136c): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: mm/vmscan.o: in function `check_move_unevictable_folios':
   vmscan.c:(.text+0x762): undefined reference to `lruvec_unlock_irq'
>> xtensa-linux-ld: vmscan.c:(.text+0x972): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: mm/vmscan.o: in function `move_folios_to_lru':
   vmscan.c:(.text+0xa22): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: mm/vmscan.o:vmscan.c:(.text+0xa58): more undefined references to `lruvec_unlock_irq' follow
   xtensa-linux-ld: mm/vmscan.o: in function `move_folios_to_lru':
   vmscan.c:(.text+0xc40): undefined reference to `lruvec_lock_irq'
   xtensa-linux-ld: mm/vmscan.o: in function `shrink_active_list':
   vmscan.c:(.text+0xc9b): undefined reference to `lruvec_lock_irq'
   xtensa-linux-ld: vmscan.c:(.text+0xcfc): undefined reference to `lruvec_unlock_irq'
>> xtensa-linux-ld: vmscan.c:(.text+0xe39): undefined reference to `lruvec_lock_irq'
   xtensa-linux-ld: mm/vmscan.o: in function `shrink_inactive_list':
   vmscan.c:(.text+0x1d32): undefined reference to `lruvec_lock_irq'
   xtensa-linux-ld: vmscan.c:(.text+0x1e46): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: vmscan.c:(.text+0x1f3a): undefined reference to `lruvec_lock_irq'
   xtensa-linux-ld: mm/vmscan.o: in function `folio_isolate_lru':
   vmscan.c:(.text+0x2eb4): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: mm/mlock.o: in function `__munlock_folio':
   mlock.c:(.text+0x5cc): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: mm/mlock.o: in function `__mlock_folio':
   mlock.c:(.text+0x8b3): undefined reference to `lruvec_unlock_irq'
   xtensa-linux-ld: mm/mlock.o: in function `mlock_folio_batch.constprop.0':
   mlock.c:(.text+0xd15): undefined reference to `lruvec_unlock_irq'
>> xtensa-linux-ld: mlock.c:(.text+0xe70): undefined reference to `lruvec_unlock_irq'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

