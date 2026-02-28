Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDB91FEE4F4
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 19:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D5F06B0005; Sat, 28 Feb 2026 14:13:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD496B0088; Sat, 28 Feb 2026 14:13:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F5F6B0089; Sat, 28 Feb 2026 14:13:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 240806B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 14:13:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC2081B6E84
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:12:59 +0000 (UTC)
X-FDA: 84494812878.01.0E4B321
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf21.hostedemail.com (Postfix) with ESMTP id 280661C0002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 19:12:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gb865JZM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772305977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgGqj04tzqLMeU6u6aiOMC1T52JoUte7eNbsxdqtu4I=;
	b=mBPG2VBUMZgjdy2BueGmJakLj952H8uZWXKZJl+WiQy1F/kM4Gg/uqVQAxMHYmyJuA0ZYU
	yIUHnuvjN4qgWT/CvAM1fMEpKwvXjKuZ6MKNXUBj6cwzVaTS3dOLPjCLxlkhR0/ljVDYpz
	aKPKmmHr9WCH1Cr6h0BgZ+OviN8GU8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772305977; a=rsa-sha256;
	cv=none;
	b=It8hioyghKv5YKtP7YTH5pHUNs+6Hn1mw7T++MZbmV+m7mBCN8P4MXhcRNKApmwCmMVQf+
	UHl6KZDku3H2oMTElYepygZrpgE3OZuXTSHfQ9oa3O6JmdU1THy8BSyKYpQ5mS2UbmOcTu
	J5ioXmZhJ0ssb2sajvi/XURwXKkz7S8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gb865JZM;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772305975; x=1803841975;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MckWxqbgh5DrSU/HBZQms30a1sgsvjX2SXgXhCL4lr4=;
  b=gb865JZM9cxAfFqUS3aXit/kHw/RE3fjGP9bitHpGJ2zOWbgDWjOXI+G
   z/sQUDj3edKifubOuAaOQCNyZxxf3LySkV18RqLfVkGruAy8UGnfr1O6o
   15hyjAvmHebSK5/xaSbxxa29rVn4GsCKr8blFXaz4P7pDwmRTSm6+9hBX
   4xKUhP0x1Rg2tTbOYnOES1MSpguHo1zbpiNWVCCjFMh1q42PIVTvLxsHq
   D3j0t9HrNJ0w2Hton412i2mAbURsmHYz+6CnWxgWwi+NJv/vjhXycLFIV
   atJ3xhdbrXgk/I57IKZZDc5e9VxKkoiV5GPGjQ+fAu09DPdJYOBp+SA6e
   g==;
X-CSE-ConnectionGUID: QN3A+3IhQXSsDEEBnUECfw==
X-CSE-MsgGUID: oNbwqG1PR6yWZRjSj190Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11715"; a="84833291"
X-IronPort-AV: E=Sophos;i="6.21,316,1763452800"; 
   d="scan'208";a="84833291"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2026 11:12:52 -0800
X-CSE-ConnectionGUID: y1nGi1NdQYaXJjGfWT4TdA==
X-CSE-MsgGUID: fEj4+ox+TGyLTEhQU+eH+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,316,1763452800"; 
   d="scan'208";a="222193345"
Received: from lkp-server01.sh.intel.com (HELO 59784f1c7b2a) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 28 Feb 2026 11:12:48 -0800
Received: from kbuild by 59784f1c7b2a with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vwPk5-0000000007t-0dSZ;
	Sat, 28 Feb 2026 19:12:45 +0000
Date: Sun, 1 Mar 2026 03:12:38 +0800
From: kernel test robot <lkp@intel.com>
To: Leno Hou <lenohou@gmail.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Leno Hou <lenohou@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Barry Song <21cnbao@gmail.com>, Jialing Wang <wjl.linux@gmail.com>,
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Message-ID: <202603010315.rTOWjv41-lkp@intel.com>
References: <20260228161008.707-1-lenohou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260228161008.707-1-lenohou@gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 280661C0002
X-Stat-Signature: xfgigijw73yctu4sycxo5da6wqtsrowg
X-Rspam-User: 
X-HE-Tag: 1772305973-792475
X-HE-Meta: U2FsdGVkX1+oi7blnhAbGkCEPqUIxa32Zgaz/lCvmKETyc2HcaSvffu/WpFYovGXrKIul4e5njgX+SmKu5Z5MKyjQItbRQT1REgoZYTm5I9+KoHg/TGO6Y4TFsnZVZXcoxRh3BxT0vHNOa/6immGo6xK8PiaV6Avl3fgE6gDkr9W7HM8ISh3Z9FfK3vZbr0Ax6A0LY1OOpKS7qdPU85GGeLHFxCh4o7mHUq60tA5QaWAKCdoR1HRf6qW3S67r8NOHvFayxB2X6mduXEk3kbH2X6EmfJOZ3QJoaOjKHnkCSAwjV1KKtIcj/QwkMO12fnDIiZscpbB7vH7Vqd3KgbI2QL6kbIuaHyofh4wwZlWp7Hmm92ogGHovmTrt7t3vKxz+MeqDmVD4nxx+kBh6TMC74XqPjMeSupcy7hC29hJrFmWahI6Gr8blScCeAw9pq3o3NkrqUeMEbyUDJAZn+BZWuQ2OL+8WMbcpqnpdSToZvJ1IQbxG3yS5J3qeCJb9RU3iAHu8ax9hCj7pr3jELS+r0+lDEbc0EuAXFjKXmXi72M9l84b1qhhuP4ZOxo+WlNCTpNJTQ3q02pHC8Tmgtb90Kd0LXGirLBUfaWJzcGkUEHsBoHccXx6tVNgYTsiWwVALsWIGC0wdJZtbfkxucRDj/YtdkDD8XoAevFLvZDzbI+a1a7o0kyDpiZqbRvlIuQ/qfWL5zswEzVPTilONP+ygeJRMTrQvuvJaKQmK/N4Bwhy/QyCAAfFHCVl/dYRn6vNAEF1fNAzFj/eChipR0CoOFKJi12RWZgjjR/Z/xjuNs7tmiq0Ng/FnLbV+CqxVBP25WmIotBxHIKJNZEQ9JyFBCSdb2taPgaeEj0Kw2NsQDZh6BPJZbqSpkIppp1mR45ZHlCw0Uh+XJp0iod9Ln53X8c4YKghwXNsBgGdYv+b2W6C3iOMO4UxFHXCeHksxpGX9cp27dApq+pHoHBNGs0
 LdZGix9z
 l2KMt/oWmSwJ3GbLGht99voRruYp11GNg/FJ9W6nNxU0MipXr5GJiHt9tjiYIgZkt9Ytcypy88w6dkvUy0JZ8XVe7B7I4ewthhoPk1/xwYzPgCs9RptlWZ2BYS13vY6qcy4IQWVFjYEl4As4qDEBG/mmQUugHejW/df3oK0R+iayK+D1rK36qPg3Zmg3vlU2XlQV6qdpCe+LJTjlmEZXyM+sCKbc8PPddq9AN/1Y2emELLOWqryMMZsgxpam3nWtoYJiDNjVO/7bChN8o7VFnfktI+wC/2A4Dn19xDubIwHetRkoPnzilPtX6lCrCT66/z1kQI+7bT64tVzQIu7wQxyOUBeLklgglKFBLSb8zyjl8EwkT5CMRxWxjKi38Xv9oCloFQIdk03+hmnPWhkXqny8RGdAw0qjf53GtGSm1l+XModVA5sb3MPBXPFnhwW7MV5tR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Leno,

kernel test robot noticed the following build errors:

[auto build test ERROR on v7.0-rc1]
[also build test ERROR on linus/master next-20260227]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Leno-Hou/mm-mglru-fix-cgroup-OOM-during-MGLRU-state-switching/20260301-001148
base:   v7.0-rc1
patch link:    https://lore.kernel.org/r/20260228161008.707-1-lenohou%40gmail.com
patch subject: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
config: x86_64-randconfig-001-20260301 (https://download.01.org/0day-ci/archive/20260301/202603010315.rTOWjv41-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260301/202603010315.rTOWjv41-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603010315.rTOWjv41-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bitops/generic-non-atomic.h:7,
                    from include/linux/bitops.h:28,
                    from include/linux/thread_info.h:27,
                    from include/linux/spinlock.h:60,
                    from include/linux/mmzone.h:8,
                    from include/linux/gfp.h:7,
                    from include/linux/mm.h:8,
                    from mm/vmscan.c:15:
   mm/vmscan.c: In function 'shrink_lruvec':
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   arch/x86/include/asm/barrier.h:68:17: note: in definition of macro '__smp_load_acquire'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                 ^
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
   In file included from <command-line>:
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:642:53: note: in definition of macro '__unqual_scalar_typeof'
     642 | #define __unqual_scalar_typeof(x) __typeof_unqual__(x)
         |                                                     ^
   include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
      50 |         __READ_ONCE(x);                                                 \
         |         ^~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
   In file included from ./arch/x86/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:372,
                    from include/linux/static_call_types.h:7,
                    from arch/x86/include/asm/bug.h:141,
                    from include/linux/bug.h:5,
                    from include/linux/mmdebug.h:5,
                    from include/linux/mm.h:7:
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/asm-generic/rwonce.h:44:73: note: in definition of macro '__READ_ONCE'
      44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
         |                                                                         ^
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:9: note: in expansion of macro 'compiletime_assert'
     709 |         compiletime_assert(__native_word(t),                            \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:28: note: in expansion of macro '__native_word'
     709 |         compiletime_assert(__native_word(t),                            \
         |                            ^~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:69:9: note: in expansion of macro 'compiletime_assert_atomic_type'
      69 |         compiletime_assert_atomic_type(*p);                             \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:9: note: in expansion of macro 'compiletime_assert'
     709 |         compiletime_assert(__native_word(t),                            \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:28: note: in expansion of macro '__native_word'
     709 |         compiletime_assert(__native_word(t),                            \
         |                            ^~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:69:9: note: in expansion of macro 'compiletime_assert_atomic_type'
      69 |         compiletime_assert_atomic_type(*p);                             \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:9: note: in expansion of macro 'compiletime_assert'
     709 |         compiletime_assert(__native_word(t),                            \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:28: note: in expansion of macro '__native_word'
     709 |         compiletime_assert(__native_word(t),                            \
         |                            ^~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:69:9: note: in expansion of macro 'compiletime_assert_atomic_type'
      69 |         compiletime_assert_atomic_type(*p);                             \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
>> mm/vmscan.c:5785:55: error: 'struct lruvec' has no member named 'lrugen'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                                                       ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:9: note: in expansion of macro 'compiletime_assert'
     709 |         compiletime_assert(__native_word(t),                            \
         |         ^~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:709:28: note: in expansion of macro '__native_word'
     709 |         compiletime_assert(__native_word(t),                            \
         |                            ^~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:69:9: note: in expansion of macro 'compiletime_assert_atomic_type'
      69 |         compiletime_assert_atomic_type(*p);                             \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5785:31: note: in expansion of macro 'smp_load_acquire'
    5785 |         bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
         |                               ^~~~~~~~~~~~~~~~
   mm/vmscan.c:5786:53: error: 'struct lruvec' has no member named 'lrugen'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                                     ^~
   arch/x86/include/asm/barrier.h:68:17: note: in definition of macro '__smp_load_acquire'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                 ^
   mm/vmscan.c:5786:29: note: in expansion of macro 'smp_load_acquire'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                             ^~~~~~~~~~~~~~~~
   mm/vmscan.c:5786:53: error: 'struct lruvec' has no member named 'lrugen'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                                     ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5786:29: note: in expansion of macro 'smp_load_acquire'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                             ^~~~~~~~~~~~~~~~
   mm/vmscan.c:5786:53: error: 'struct lruvec' has no member named 'lrugen'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                                     ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      49 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/x86/include/asm/barrier.h:68:28: note: in expansion of macro 'READ_ONCE'
      68 |         typeof(*p) ___p1 = READ_ONCE(*p);                               \
         |                            ^~~~~~~~~
   include/asm-generic/barrier.h:176:29: note: in expansion of macro '__smp_load_acquire'
     176 | #define smp_load_acquire(p) __smp_load_acquire(p)
         |                             ^~~~~~~~~~~~~~~~~~
   mm/vmscan.c:5786:29: note: in expansion of macro 'smp_load_acquire'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                             ^~~~~~~~~~~~~~~~
   mm/vmscan.c:5786:53: error: 'struct lruvec' has no member named 'lrugen'
    5786 |         bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
         |                                                     ^~
   include/linux/compiler_types.h:686:23: note: in definition of macro '__compiletime_assert'
     686 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:706:9: note: in expansion of macro '_compiletime_assert'
     706 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
..


vim +5785 mm/vmscan.c

  5774	
  5775	static void shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
  5776	{
  5777		unsigned long nr[NR_LRU_LISTS];
  5778		unsigned long targets[NR_LRU_LISTS];
  5779		unsigned long nr_to_scan;
  5780		enum lru_list lru;
  5781		unsigned long nr_reclaimed = 0;
  5782		unsigned long nr_to_reclaim = sc->nr_to_reclaim;
  5783		bool proportional_reclaim;
  5784		struct blk_plug plug;
> 5785		bool lrugen_enabled = smp_load_acquire(&lruvec->lrugen.enabled);
  5786		bool lru_draining = smp_load_acquire(&lruvec->lrugen.draining);
  5787	
> 5788		if (lrugen_enabled || lru_draining && !root_reclaim(sc)) {
  5789			lru_gen_shrink_lruvec(lruvec, sc);
  5790	
  5791			if (!lru_draining)
  5792				return;
  5793	
  5794		}
  5795	
  5796		get_scan_count(lruvec, sc, nr);
  5797	
  5798		/* Record the original scan target for proportional adjustments later */
  5799		memcpy(targets, nr, sizeof(nr));
  5800	
  5801		/*
  5802		 * Global reclaiming within direct reclaim at DEF_PRIORITY is a normal
  5803		 * event that can occur when there is little memory pressure e.g.
  5804		 * multiple streaming readers/writers. Hence, we do not abort scanning
  5805		 * when the requested number of pages are reclaimed when scanning at
  5806		 * DEF_PRIORITY on the assumption that the fact we are direct
  5807		 * reclaiming implies that kswapd is not keeping up and it is best to
  5808		 * do a batch of work at once. For memcg reclaim one check is made to
  5809		 * abort proportional reclaim if either the file or anon lru has already
  5810		 * dropped to zero at the first pass.
  5811		 */
  5812		proportional_reclaim = (!cgroup_reclaim(sc) && !current_is_kswapd() &&
  5813					sc->priority == DEF_PRIORITY);
  5814	
  5815		blk_start_plug(&plug);
  5816		while (nr[LRU_INACTIVE_ANON] || nr[LRU_ACTIVE_FILE] ||
  5817						nr[LRU_INACTIVE_FILE]) {
  5818			unsigned long nr_anon, nr_file, percentage;
  5819			unsigned long nr_scanned;
  5820	
  5821			for_each_evictable_lru(lru) {
  5822				if (nr[lru]) {
  5823					nr_to_scan = min(nr[lru], SWAP_CLUSTER_MAX);
  5824					nr[lru] -= nr_to_scan;
  5825	
  5826					nr_reclaimed += shrink_list(lru, nr_to_scan,
  5827								    lruvec, sc);
  5828				}
  5829			}
  5830	
  5831			cond_resched();
  5832	
  5833			if (nr_reclaimed < nr_to_reclaim || proportional_reclaim)
  5834				continue;
  5835	
  5836			/*
  5837			 * For kswapd and memcg, reclaim at least the number of pages
  5838			 * requested. Ensure that the anon and file LRUs are scanned
  5839			 * proportionally what was requested by get_scan_count(). We
  5840			 * stop reclaiming one LRU and reduce the amount scanning
  5841			 * proportional to the original scan target.
  5842			 */
  5843			nr_file = nr[LRU_INACTIVE_FILE] + nr[LRU_ACTIVE_FILE];
  5844			nr_anon = nr[LRU_INACTIVE_ANON] + nr[LRU_ACTIVE_ANON];
  5845	
  5846			/*
  5847			 * It's just vindictive to attack the larger once the smaller
  5848			 * has gone to zero.  And given the way we stop scanning the
  5849			 * smaller below, this makes sure that we only make one nudge
  5850			 * towards proportionality once we've got nr_to_reclaim.
  5851			 */
  5852			if (!nr_file || !nr_anon)
  5853				break;
  5854	
  5855			if (nr_file > nr_anon) {
  5856				unsigned long scan_target = targets[LRU_INACTIVE_ANON] +
  5857							targets[LRU_ACTIVE_ANON] + 1;
  5858				lru = LRU_BASE;
  5859				percentage = nr_anon * 100 / scan_target;
  5860			} else {
  5861				unsigned long scan_target = targets[LRU_INACTIVE_FILE] +
  5862							targets[LRU_ACTIVE_FILE] + 1;
  5863				lru = LRU_FILE;
  5864				percentage = nr_file * 100 / scan_target;
  5865			}
  5866	
  5867			/* Stop scanning the smaller of the LRU */
  5868			nr[lru] = 0;
  5869			nr[lru + LRU_ACTIVE] = 0;
  5870	
  5871			/*
  5872			 * Recalculate the other LRU scan count based on its original
  5873			 * scan target and the percentage scanning already complete
  5874			 */
  5875			lru = (lru == LRU_FILE) ? LRU_BASE : LRU_FILE;
  5876			nr_scanned = targets[lru] - nr[lru];
  5877			nr[lru] = targets[lru] * (100 - percentage) / 100;
  5878			nr[lru] -= min(nr[lru], nr_scanned);
  5879	
  5880			lru += LRU_ACTIVE;
  5881			nr_scanned = targets[lru] - nr[lru];
  5882			nr[lru] = targets[lru] * (100 - percentage) / 100;
  5883			nr[lru] -= min(nr[lru], nr_scanned);
  5884		}
  5885		blk_finish_plug(&plug);
  5886		sc->nr_reclaimed += nr_reclaimed;
  5887	
  5888		/*
  5889		 * Even if we did not try to evict anon pages at all, we want to
  5890		 * rebalance the anon lru active/inactive ratio.
  5891		 */
  5892		if (can_age_anon_pages(lruvec, sc) &&
  5893		    inactive_is_low(lruvec, LRU_INACTIVE_ANON))
  5894			shrink_active_list(SWAP_CLUSTER_MAX, lruvec,
  5895					   sc, LRU_ACTIVE_ANON);
  5896	}
  5897	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

