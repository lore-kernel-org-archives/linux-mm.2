Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D34EF06EE
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 02:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBE86B0089; Sun,  8 Feb 2026 21:02:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A99F6B0092; Sun,  8 Feb 2026 21:02:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091086B0093; Sun,  8 Feb 2026 21:02:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9B8F6B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:02:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 760AF1B31C2
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:02:44 +0000 (UTC)
X-FDA: 84423269448.25.29BBB9E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id D024F120010
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 02:02:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RcUnzeUO;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770602562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xh3UuAftVh1vq8L4KSjRdLZZ4LbtPG4AxYDxh9uslYw=;
	b=4qtpyhNVlmOJ2mIpSytlv63OuvYanu6YcmuVXoqKoXQssby5Z1fOS8BtomuNbfohoSOZP3
	RxMXPRBpY7oJjbnzG+qgTnws4z3+25hXhQzr7r+rmjYyfGZhCPeBh8R6S/Ft28w5bFcrNy
	Vr2oFt17FNGkChdJqFHsKayZ5F8T5MU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RcUnzeUO;
	spf=pass (imf29.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770602562; a=rsa-sha256;
	cv=none;
	b=tGWDXXKg5I1HRBkv4hqltcSNHjhnFDSgnFO/1gzg7xfuOCz1RjqnBjxSSzofmSUnoaFJHT
	TWvwlOpEnAkT8d1VAwcneI6j5CS5RgK2AqMtn0NoaTeS4toKaZ7QwGdwVvn15uOsMsD3th
	XNzcQJcfq3YIY4HMVpmjlhHzZ2brfKE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770602562; x=1802138562;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Hyof1hGtCKND6soMP6y8pogc5xszODf48CdRWrawknk=;
  b=RcUnzeUOIp3vcrbSEvq281CClLJ5IwRlzm3bc7utCciGS8H4xuT5rS7J
   cW7/k+xGvgymhM7/2YizyGPSp00fWjbwGVfnR4MEo1DuzKRsHGa/irhCs
   FaIvRNN2zNzHjz8EBdpTD3jfhys4unKZ6eVdJ4RTQ5fqG+WLpUwvpCYk5
   McnO1y4sq66dEPCPCQmHUHTNPpwbkr8HKRpCgY4hAPbVR1BP/0xDTOhtq
   lqBRfYAgFwYfaSJnP0v3Iwo2ujGKJeR+5iCnIszY2+WjIp99gLj5a9Cmr
   cVs/p8Wu+VEBDeTXqnMb2eFtF/q8eGy1WsZ99W0/T5M2kO0/GconnsHOa
   A==;
X-CSE-ConnectionGUID: 1jIDRuE7SP+QKmrL1fZj7A==
X-CSE-MsgGUID: XJfO/shFRHaMPGd9yDIRFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11695"; a="71776009"
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="71776009"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2026 18:02:40 -0800
X-CSE-ConnectionGUID: neDeqpouQsGET94hZxYgPw==
X-CSE-MsgGUID: FuDPVoH/TLet4b2DxkH+dA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,281,1763452800"; 
   d="scan'208";a="234374661"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 08 Feb 2026 18:02:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpGbf-00000000mVY-03Cp;
	Mon, 09 Feb 2026 02:02:31 +0000
Date: Mon, 9 Feb 2026 10:01:32 +0800
From: kernel test robot <lkp@intel.com>
To: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	akpm@linux-foundation.org, hannes@cmpxchg.org, hughd@google.com,
	yosry.ahmed@linux.dev, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, kasong@tencent.com, chrisl@kernel.org,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	lorenzo.stoakes@oracle.com, christophe.leroy@csgroup.eu,
	pavel@kernel.org, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
	joshua.hahnjy@gmail.com
Subject: Re: [PATCH v3 18/20] memcg: swap: only charge physical swap slots
Message-ID: <202602090941.opY2jzUD-lkp@intel.com>
References: <20260208215839.87595-19-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260208215839.87595-19-nphamcs@gmail.com>
X-Stat-Signature: w7o7dhjkfjhhcnypmmsm9tau31kh45x6
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D024F120010
X-HE-Tag: 1770602561-301916
X-HE-Meta: U2FsdGVkX1/88in9z5ZhUhKRo4LwLGgPjI3XR3LEA8voR+PWEXbYUdsm7d4PQTd9bCUjkz/xQT9v81ru4w1h5SUtAFYYYjKh8bJEOHpHQ6Yh+XDslVgRoqB+FxapYfhpF3AEHSsXpEbtTPg0zJpCYGLfageyY8BaU5cDYtLHeQrU7ZskrsVTPDXO0J4ytYKT+oErYnkSqha9/n66NI3QIAONhWJHoGrc5tUoWSOrCKiq0N7KZkpbIYldfDg8GHmsDN74YBVHTB5ZDZ5CUL+RrbSybI2y8QDgYDkLxo5bJ7e8kaJOpSPXQO3a84RtMaLbQn0JvPYThd0gqEetAyRv06I63ZcCZv0xwJtto4m0/nUbYtIuvkLlYu4bnZbLSF3k2l5+K0FuScr9PslSwucs35iw88UOqFXJspN3745OVJeElOk1SwbJqmqpb9oEhnbXJKF6P377TwO8PMNrV5GhztxAkkEs3+jFxon4O01zJftKH+RcK+qqqrh+B+nqEE4/zjfL6R1bojb7TwYENhGr4z53iHwXDWGvDs68x2dRYSl6FtWHLhI0rf5bgM26TLES8yKA3X60GFp71laHavwTzpObniYBqBofmkn6EdP9aXQntYvOjlbNDDJ8T8xcHcEqwHJkINfJ83ZvOic25StCP+cMJrNFsP37AkbfNKHiYN23d6Kxrml68d8YOt1L746HiL7sPlC44+54MJ/8oMd8a7maha37oSPr+LVlKvYwQCX9cjGoX9HBfKXGAgEibHFDb3J6KkA39JgDrHQojgzk5HsM6RllCBmia+0XSbKWZ9lLuCqc262gWNY2ajVCdrKnJqpTVknecx+hsv72Ifu4nIkZFlRcubAK2RYhNM9BWdFOAqSZjdu6rgJEqTx/8Mv0rlTNYNCA4hiQuZ6aXkDmkpUmAzqh4mt1WJWO5dosU1u8Qw0XB5RCKJyLZHAobqyw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

kernel test robot noticed the following build errors:

[auto build test ERROR on linus/master]
[also build test ERROR on v6.19]
[cannot apply to akpm-mm/mm-everything tj-cgroup/for-next tip/smp/core next-20260205]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Nhat-Pham/swap-rearrange-the-swap-header-file/20260209-065842
base:   linus/master
patch link:    https://lore.kernel.org/r/20260208215839.87595-19-nphamcs%40gmail.com
patch subject: [PATCH v3 18/20] memcg: swap: only charge physical swap slots
config: hexagon-randconfig-001-20260209 (https://download.01.org/0day-ci/archive/20260209/202602090941.opY2jzUD-lkp@intel.com/config)
compiler: clang version 16.0.6 (https://github.com/llvm/llvm-project 7cbf1a2591520c2491aa35339f227775f4d3adf6)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260209/202602090941.opY2jzUD-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602090941.opY2jzUD-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/memcontrol-v1.c:688:3: error: call to undeclared function 'mem_cgroup_clear_swap'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
                   mem_cgroup_clear_swap(entry, nr_pages);
                   ^
   mm/memcontrol-v1.c:688:3: note: did you mean 'mem_cgroup_uncharge_swap'?
   include/linux/swap.h:658:20: note: 'mem_cgroup_uncharge_swap' declared here
   static inline void mem_cgroup_uncharge_swap(swp_entry_t entry,
                      ^
   1 error generated.


vim +/mem_cgroup_clear_swap +688 mm/memcontrol-v1.c

   651	
   652	/*
   653	 * memcg1_swapin - uncharge swap slot
   654	 * @entry: the first swap entry for which the pages are charged
   655	 * @nr_pages: number of pages which will be uncharged
   656	 *
   657	 * Call this function after successfully adding the charged page to swapcache.
   658	 *
   659	 * Note: This function assumes the page for which swap slot is being uncharged
   660	 * is order 0 page.
   661	 */
   662	void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
   663	{
   664		/*
   665		 * Cgroup1's unified memory+swap counter has been charged with the
   666		 * new swapcache page, finish the transfer by uncharging the swap
   667		 * slot. The swap slot would also get uncharged when it dies, but
   668		 * it can stick around indefinitely and we'd count the page twice
   669		 * the entire time.
   670		 *
   671		 * Cgroup2 has separate resource counters for memory and swap,
   672		 * so this is a non-issue here. Memory and swap charge lifetimes
   673		 * correspond 1:1 to page and swap slot lifetimes: we charge the
   674		 * page to memory here, and uncharge swap when the slot is freed.
   675		 */
   676		if (do_memsw_account()) {
   677			/*
   678			 * The swap entry might not get freed for a long time,
   679			 * let's not wait for it.  The page already received a
   680			 * memory+swap charge, drop the swap entry duplicate.
   681			 */
   682			mem_cgroup_uncharge_swap(entry, nr_pages);
   683	
   684			/*
   685			 * Clear the cgroup association now to prevent double memsw
   686			 * uncharging when the backends are released later.
   687			 */
 > 688			mem_cgroup_clear_swap(entry, nr_pages);
   689		}
   690	}
   691	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

