Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8BB0EC1EBC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2906B0092; Thu,  5 Feb 2026 10:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163E76B0093; Thu,  5 Feb 2026 10:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06F616B0098; Thu,  5 Feb 2026 10:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB4D76B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:03:27 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A635DB99F1
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:03:27 +0000 (UTC)
X-FDA: 84410721654.09.BCB09E0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf25.hostedemail.com (Postfix) with ESMTP id 290D0A0004
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:03:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VelJlC0b;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770303805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOfaK00i/IND2Zrci8NnC5AqnIjhLy44iDJ9FLPJqtM=;
	b=WKPqF4W2FF8wVG9kJ+UISinY0ahotQvsesKrpt8ljruA3dMDIPYcgs9hfQKMya3HBySamZ
	/xgkl7MWN9E0cH26CRFrD/pPVr8WZm1AGIbRVQegpTsj37D+0zhZlrWp3UMuZ3LLqSvSMW
	Gxurb2gi4F4ixaSRXapH4r8WzlaoJvA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VelJlC0b;
	spf=pass (imf25.hostedemail.com: domain of lkp@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770303805; a=rsa-sha256;
	cv=none;
	b=yf4E59ODmx+9CaafcFyoKM37mDY+xixUJ8Ic/Q7XWEE2AKXMba44qn6P/Q2II6atzLkUsf
	xRKEYdlkqqbTFjIbwxfaYnp/V/NMFXoAH6DFzsESEPC6UWuzwXaepsmUjs+KkEB4rxODbe
	Ec7KnUc6bxrzyq2UQH08RmrvrsL+VLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770303805; x=1801839805;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QDQNj/v82AkaK8Fs++1Uo4hRK6o19qvCsj3OHG6VXJg=;
  b=VelJlC0bfm+6+bPU0O+bhg5SBtSETjYPuN4uUnnHCT/7dvHpQo4nq74r
   inf921CBnhgCSqO+iQpGXwv73konPyNYulI5cTBW7gHWS0DJ2254Uvmod
   qK9v0ZsV1kTR4TWgO0h+d/U+lpwNNwhUToKcplkZdhWLo6s/566atX83c
   HfZsU8i3ysiRGjkKlo1X1U0LaQLf3BODFNyUkstcEy0F3XgzInC+l730T
   91XLj9LD4W3vMVKsCH1pHsFjFEcApNTU2TW3JU8A7XfV1Ng7rU7hCuZgk
   Q6ePKzp3YWEoKcvczyp59K9UuBWugEGHkUZ3JKieDTUqj5PDc+gV82wSa
   A==;
X-CSE-ConnectionGUID: 6P/NKOM0RWeTUekbcW380w==
X-CSE-MsgGUID: Draz1gS5QZG6g9q/SAslsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11692"; a="82873855"
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="82873855"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2026 07:03:20 -0800
X-CSE-ConnectionGUID: 4pHOlflUQu6YP/w5VkWf2A==
X-CSE-MsgGUID: Ux6D/JXeROW/jL2EVGXy5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,274,1763452800"; 
   d="scan'208";a="210468516"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 05 Feb 2026 07:03:12 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vo0sw-00000000juI-0xrD;
	Thu, 05 Feb 2026 15:03:10 +0000
Date: Thu, 5 Feb 2026 23:02:47 +0800
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
Message-ID: <202602052203.U8hxsh2N-lkp@intel.com>
References: <e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e27edb311dda624751cb41860237f290de8c16ae.1770279888.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 290D0A0004
X-Stat-Signature: 3di6o1tq5ftqonnen1oa8wicuebaugwk
X-Rspam-User: 
X-HE-Tag: 1770303804-916240
X-HE-Meta: U2FsdGVkX18WMryJVZwsXqMbXgbJIjx/cW5ZtjummzlbrTVggLlPDO3ojBp96sCPpqrokB9UbiKAkYEJIIND2m4bJLKjVnCLg4sY35PNa5TnpuLVyMRx5pAqfS6fW+7n9bmUwrYiE5mWwEaxkIcbrukv6VxvLl5qHaz8tMNVgfTkwqh3KCe0X5xgw4A/B0rI0aSoeHKq1TdjVlLZo56HCRZyNFrzEWNcRadMVd6bMxi8MemNBdcMu0PkDjFGJqXdcb0PRG7CvVNvW7BRqDqPnstQ8fmHWcQavq8k6HLCiSKvYR9uyr5vKWo4vbTHHsoSIba3UveNy8nOJuQ0wsiGCnDCjVo5kh2dK7z836YHgPxczqWAZWuYkkV1K9jVQbeeveMMzOVshM3xireR7ZUJrmLTZyWlKODXbxrPrPG192cEtKVC5cCzuPG6v4b0vvPoxFCVQ5o3OjQ/Rt27z7ETt5yokzFehy1T9jRSADUtjoucNA+PnlJ+qjWcgwwQFNNpV+6yh3uf6gs5gO3FVBh+WIXQjKwfjKe9bogbL1LXnF40rk1ZSZItkVdHJBsW+wPLNgoeWy37J8zEsB8382dbdtMXu+YzbjTRKZbZ2K0enaYFrKo3S6LB24SoUCVYwg/2yAKHAzrz66PMyJjvsp9g4jju2rHHOxsO9c4wJdxRxv4eA1TDiUh7mQuqShMmbrk74fnSJ4Myzc2V/gmrVWVuOJIQLOLWpL4ARS6+jufQC5Btc6M7zpuR7vfTq5qeHHaBZUTdnt0b7sn/taySKnbWyHxYeobjLYg6m326hJkMcfM9fy81RamOpeKDGjraKwbRvyvbefBf0cz26I73vhyMI4AnggUSXctGesIHYj6vIMcGj+PtCBqYBvgJdiThhtQZC+gZrZOn6Ab7kCDub0mMG2IpAU6Av9umGEh461dFEW7vRMOCAZ1poXk9ExY12ZOzr7ngPbkbRa9efwjiwxJ
 CmiFsUG8
 exLMTSjxdm4tDszHq+CXTaqoC5LH8cIYNozUB5LuhbKK0I6Wrp/siegmqhs8B3aY8WsFswiWyrl6C73RjwoV91rKV56Mqpzl1H6GHZLRVS4g8dYTjq6OepTSIwG9LKME8IzIWEAWpAK5U8rM8rsHyaRoZwNPVj5IzaIh5qwlWI8rlDuLznk50QfL9OGkWFR1uDK7ZWxTlfeUj7GFmsIYbSgFKHML8tU6vVjJHKLUgZTS84hVFX+POH4JK+Nr05CcVOE+tETsEnLTuJ+srOtUGiTtlwAHJlDAX4JvUvYwKucfe5bedb1WZkfNhwzP5f+FRIMYg4GWgkJ4jIeJ2UZz3+VFqWMb/Sz2YLLhszqDDXEDiWIrbNuGD8556jvQc1K6gvFLl
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
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260205/202602052203.U8hxsh2N-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602052203.U8hxsh2N-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602052203.U8hxsh2N-lkp@intel.com/

All errors (new ones prefixed by >>):

   nios2-linux-ld: mm/swap.o: in function `__page_cache_release.part.0':
   swap.c:(.text+0x4c): undefined reference to `lruvec_unlock_irqrestore'
>> swap.c:(.text+0x4c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
   nios2-linux-ld: mm/swap.o: in function `__folio_put':
   swap.c:(.text+0x2ac): undefined reference to `lruvec_unlock_irqrestore'
   swap.c:(.text+0x2ac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
   nios2-linux-ld: mm/swap.o: in function `folios_put_refs':
   swap.c:(.text+0x384): undefined reference to `lruvec_unlock_irqrestore'
   swap.c:(.text+0x384): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
   nios2-linux-ld: mm/swap.o: in function `folio_batch_move_lru':
   swap.c:(.text+0x4ac): undefined reference to `lruvec_unlock_irqrestore'
   swap.c:(.text+0x4ac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
>> nios2-linux-ld: swap.c:(.text+0x50c): undefined reference to `lruvec_unlock_irqrestore'
   swap.c:(.text+0x50c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irqrestore'
   nios2-linux-ld: mm/swap.o: in function `folio_activate':
   swap.c:(.text+0x21d8): undefined reference to `lruvec_unlock_irq'
>> swap.c:(.text+0x21d8): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
   nios2-linux-ld: mm/vmscan.o: in function `move_folios_to_lru':
   vmscan.c:(.text+0xa4c): undefined reference to `lruvec_unlock_irq'
>> vmscan.c:(.text+0xa4c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
>> nios2-linux-ld: vmscan.c:(.text+0xaa4): undefined reference to `lruvec_unlock_irq'
   vmscan.c:(.text+0xaa4): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
   nios2-linux-ld: vmscan.c:(.text+0xcac): undefined reference to `lruvec_unlock_irq'
   vmscan.c:(.text+0xcac): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
   nios2-linux-ld: vmscan.c:(.text+0xd8c): undefined reference to `lruvec_unlock_irq'
   vmscan.c:(.text+0xd8c): relocation truncated to fit: R_NIOS2_CALL26 against `lruvec_unlock_irq'
   nios2-linux-ld: mm/vmscan.o: in function `shrink_active_list':
   vmscan.c:(.text+0x11e0): undefined reference to `lruvec_lock_irq'
   vmscan.c:(.text+0x11e0): additional relocation overflows omitted from the output
   nios2-linux-ld: vmscan.c:(.text+0x12a0): undefined reference to `lruvec_unlock_irq'
>> nios2-linux-ld: vmscan.c:(.text+0x144c): undefined reference to `lruvec_lock_irq'
   nios2-linux-ld: mm/vmscan.o: in function `check_move_unevictable_folios':
   vmscan.c:(.text+0x15d4): undefined reference to `lruvec_unlock_irq'
   nios2-linux-ld: vmscan.c:(.text+0x1958): undefined reference to `lruvec_unlock_irq'
   nios2-linux-ld: mm/vmscan.o: in function `shrink_inactive_list':
   vmscan.c:(.text+0x2f8c): undefined reference to `lruvec_lock_irq'
   nios2-linux-ld: vmscan.c:(.text+0x307c): undefined reference to `lruvec_unlock_irq'
   nios2-linux-ld: vmscan.c:(.text+0x31dc): undefined reference to `lruvec_lock_irq'
   nios2-linux-ld: mm/vmscan.o: in function `folio_isolate_lru':
   vmscan.c:(.text+0x48a4): undefined reference to `lruvec_unlock_irq'
   nios2-linux-ld: mm/mlock.o: in function `__munlock_folio':
   mlock.c:(.text+0x968): undefined reference to `lruvec_unlock_irq'
   nios2-linux-ld: mm/mlock.o: in function `__mlock_folio':
   mlock.c:(.text+0xe5c): undefined reference to `lruvec_unlock_irq'
   nios2-linux-ld: mm/mlock.o: in function `mlock_folio_batch.constprop.0':
   mlock.c:(.text+0x158c): undefined reference to `lruvec_unlock_irq'
>> nios2-linux-ld: mlock.c:(.text+0x1808): undefined reference to `lruvec_unlock_irq'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

