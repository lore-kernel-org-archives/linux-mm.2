Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DDBE8FDB5
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 20:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6C26B0005; Fri, 26 Dec 2025 15:41:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A4356B0089; Fri, 26 Dec 2025 15:41:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A3A46B008A; Fri, 26 Dec 2025 15:41:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AFF66B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:41:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 242A316044A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:41:36 +0000 (UTC)
X-FDA: 84262792992.29.CC5F762
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D8EF180009
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:41:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lyk8J/us";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766781694; a=rsa-sha256;
	cv=none;
	b=CQSirInrVrIycJ3uskLZJ9zwKI6vME/55Xb0uZr41SCucKkRUysd++griCq9SA+xVVHgT+
	Oj+3/zg89qi2VVkfaLiAnPyz6jqOYbAAZM7zQiFzUECTD12nyFlWZ+QqgJpIbCn1OVPInh
	I2E8CBkRwv7DUhhZ9MqWCG5LsV22qkQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="lyk8J/us";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766781694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlUTRy/aP/feRz11lgGhp42/7uFuB3LOGeFmMRHjkXE=;
	b=yJpSgQZAEWk4TC9oB+ajRklun6AHmLVseLBDx94FFSC/24qweP/tXMfPG4BOi6gmH/9MnI
	Rjm7yQf7o0DjixdkYgAvcL91YSdT8GZzfTSQxPpolHALTwFdFSPQ4SGPi676/K/mg3XsMY
	2IvXFyppDROWspPbf2QO/XXF+9SEiDw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766781694; x=1798317694;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zBQzHfUqOC2GvX06d1WmW6+lrYJwfd4jNRhhz+TtBZc=;
  b=lyk8J/usJwLhj9A9m/30iefmcrlVCkc1/T4k2bNTDKcQSCdoIt/BKgnh
   PDk8VezPxNHiK3Zf0WVpH+J3e08RGn7SX4+KLTlaXcM/Xu9bU4wyku7Gs
   D0lI0wNwhrVgHSHjgYs2e0+F2YiDpnPivKbsN+lPPyqTQmm3Bx366LOA7
   8cXLMM+Lo4W6SSaR3+HwIIbj6dJ5pSeUWRv1TlAoWH31Vtr78b3ARm8B5
   5ziyPGVYF9T1sFWzUF43ebpDfGua8/jiOb36OMzVjRH1gduVddgfgHpYf
   ke7P5Tk2Xmu16Xgbz0xje1pZ8coefaX71HE2aziz0jcrUgalVmltYzitf
   g==;
X-CSE-ConnectionGUID: vly+3ctqQUG3UnEoYYrhYw==
X-CSE-MsgGUID: iC1XIh3+R2+b4oEa7swCZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="68458831"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="scan'208";a="68458831"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2025 12:41:32 -0800
X-CSE-ConnectionGUID: FjJZNzGsTxSVpfeh4W0yOw==
X-CSE-MsgGUID: QyamsYnjQEa1dXYFzSx0WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,178,1763452800"; 
   d="scan'208";a="223928691"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa002.fm.intel.com with ESMTP; 26 Dec 2025 12:41:28 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZEcn-000000005LP-17e6;
	Fri, 26 Dec 2025 20:41:25 +0000
Date: Sat, 27 Dec 2025 04:40:40 +0800
From: kernel test robot <lkp@intel.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: oe-kbuild-all@lists.linux.dev, Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/memcg: scale memory.high penalty based on refault
 recency
Message-ID: <202512270457.MunhjmYM-lkp@intel.com>
References: <20251226064257.245581-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251226064257.245581-1-jiayuan.chen@linux.dev>
X-Rspamd-Queue-Id: 6D8EF180009
X-Rspamd-Server: rspam03
X-Stat-Signature: ajbhqt3xuwbux1pw38eutyrnfrr7edsc
X-Rspam-User: 
X-HE-Tag: 1766781693-449345
X-HE-Meta: U2FsdGVkX1/4LAcJCl4JXunD8KvT2Qp+vuudeZxh2CqfdSSSNLMuz94xclUD753QzhTTRjz1dseTQrVRl7r5k0dK+cq/HJpBLVGR/GnHBPzK4nMxRiMQuoGSi2sUmiDUYjRAuJhieR6Y+UgAXKzxL6nHJSgxrTDcegVCXQWKj6b8RKKbBZM1SuVB/S86+e79am8UtCQIcHVRLmyDz4o/5ZciMZvGFcnv70ZW8zDn8rrCuh+fja/vRwn6HCQ+m5J5oF0/B29xQPLFRzNZKO/Z+qbAL/qY0/rESd/ryovOeOSKIlyhdvAX1FJaEH+6Lb7T+Z7FE2vMdRRedxsPAgGcpGBSFkMCzVcZivRjNLDtSeWy1Vd8JFc2yrPaK7/nyaFGChpL2ECqSyvwLYx68jnsQtP7kpK/IC7dy9KKRXSYm1botA3NBjivYfPwt/A/UOJSLnaJsR4ImrncLLZ+Eq0Mb4o1hc0O8H11+2ad6prxwtLwh5HYv83DMbDawxUatBMcpvYC4ZxhdsL1IiciDighjwkTGkJ3nwgJHSkjhp2sHbIaSo0asDwrOQav8HD3Xawh+w8jybxot51LWzbB5jOGGaRfzOJzua3IHkzp4HS5suFEGxl+VTw2KyhwkLjBHkwOOyfjsVsAg/0iQN9ezogMjHjhVzPvGuzKoWCR6//ijLSNpP22pfdJkLJfiwjYnaVplSznDn2pqWEGeqF0FztsEze1Tm1WqkVXVEPIgObdZa4PCP4N6QTfiSnYX9v+EV+SPWw3BGvA898qyWPavEgCXp/whBDa+//kGSwpRF94K1CasIcO2jvdR9pH+79H1kMUN97fEIUZ25366mM465k55oey5nAW3UtlqHe0Gp9hi52oN7zJAGNY6eXOd5zSw4bk9eeUoUViiUcRKNaIVtkRc1M24jtGjR425m5RtQpr5tDh4+tEq7VjlRQHpt+CQ0HxNQw0sRx/nyZJbhdH6cE
 bZgIyQcN
 NgY6cmhXjmQw9AGy4RmgNAF7F+uul47gwK8C7EVhqMH+LjxkkYiB6hcEsIfAwMwMybbzIxnoOv5+hnFYT37h2WbmeQYJ/GSkpTlU0kXB7YXebNZi4RIS6tT88QvDhaH/a3dWvWT00pgo4KhCN8wMLwxWTrEP/88WN4fCTSXQYEK6k5rZINis4FhtaDKRa7LFRQD4UkmfkdnpJTpFNPtsIiU6v/x1aCiWrSm0lggopKniHUoSLqUu6M0KIq2d8UCghni3vhoUwSXRYceW3xDT617z0bVVXe3nu15iS9qXQti49EfALGs8ekad+oU+fhmia7dQeueFI9hM1Ky8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jiayuan,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiayuan-Chen/mm-memcg-scale-memory-high-penalty-based-on-refault-recency/20251226-144331
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251226064257.245581-1-jiayuan.chen%40linux.dev
patch subject: [PATCH v1] mm/memcg: scale memory.high penalty based on refault recency
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20251227/202512270457.MunhjmYM-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251227/202512270457.MunhjmYM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512270457.MunhjmYM-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from <command-line>:
   mm/workingset.c: In function 'workingset_refault':
>> mm/workingset.c:570:33: error: invalid use of undefined type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                                 ^~
   include/linux/compiler_types.h:611:23: note: in definition of macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:60:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/workingset.c:570:17: note: in expansion of macro 'WRITE_ONCE'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                 ^~~~~~~~~~
>> mm/workingset.c:570:33: error: invalid use of undefined type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                                 ^~
   include/linux/compiler_types.h:611:23: note: in definition of macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:60:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/workingset.c:570:17: note: in expansion of macro 'WRITE_ONCE'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                 ^~~~~~~~~~
>> mm/workingset.c:570:33: error: invalid use of undefined type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                                 ^~
   include/linux/compiler_types.h:611:23: note: in definition of macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:60:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/workingset.c:570:17: note: in expansion of macro 'WRITE_ONCE'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                 ^~~~~~~~~~
>> mm/workingset.c:570:33: error: invalid use of undefined type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                                 ^~
   include/linux/compiler_types.h:611:23: note: in definition of macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                            ^~~~~~~~~~~~~
   include/asm-generic/rwonce.h:60:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/workingset.c:570:17: note: in expansion of macro 'WRITE_ONCE'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                 ^~~~~~~~~~
>> mm/workingset.c:570:33: error: invalid use of undefined type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                                 ^~
   include/linux/compiler_types.h:611:23: note: in definition of macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:631:9: note: in expansion of macro '_compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |         ^~~~~~~~~~~~~~~~~~
   include/asm-generic/rwonce.h:60:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/workingset.c:570:17: note: in expansion of macro 'WRITE_ONCE'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                 ^~~~~~~~~~
   In file included from ./arch/nios2/include/generated/asm/rwonce.h:1,
                    from include/linux/compiler.h:380,
                    from include/asm-generic/bug.h:5,
                    from ./arch/nios2/include/generated/asm/bug.h:1,
                    from include/linux/bug.h:5,
                    from include/linux/thread_info.h:13,
                    from include/asm-generic/current.h:6,
                    from ./arch/nios2/include/generated/asm/current.h:1,
                    from include/linux/sched.h:12,
                    from include/linux/cgroup.h:12,
                    from include/linux/memcontrol.h:13,
                    from mm/workingset.c:8:
>> mm/workingset.c:570:33: error: invalid use of undefined type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                                 ^~
   include/asm-generic/rwonce.h:55:27: note: in definition of macro '__WRITE_ONCE'
      55 |         *(volatile typeof(x) *)&(x) = (val);                            \
         |                           ^
   mm/workingset.c:570:17: note: in expansion of macro 'WRITE_ONCE'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                 ^~~~~~~~~~
>> mm/workingset.c:570:33: error: invalid use of undefined type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                                 ^~
   include/asm-generic/rwonce.h:55:34: note: in definition of macro '__WRITE_ONCE'
      55 |         *(volatile typeof(x) *)&(x) = (val);                            \
         |                                  ^
   mm/workingset.c:570:17: note: in expansion of macro 'WRITE_ONCE'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                 ^~~~~~~~~~


vim +570 mm/workingset.c

   529	
   530	/**
   531	 * workingset_refault - Evaluate the refault of a previously evicted folio.
   532	 * @folio: The freshly allocated replacement folio.
   533	 * @shadow: Shadow entry of the evicted folio.
   534	 *
   535	 * Calculates and evaluates the refault distance of the previously
   536	 * evicted folio in the context of the node and the memcg whose memory
   537	 * pressure caused the eviction.
   538	 */
   539	void workingset_refault(struct folio *folio, void *shadow)
   540	{
   541		bool file = folio_is_file_lru(folio);
   542		struct pglist_data *pgdat;
   543		struct mem_cgroup *memcg;
   544		struct lruvec *lruvec;
   545		bool workingset;
   546		long nr;
   547	
   548		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
   549	
   550		if (lru_gen_enabled()) {
   551			lru_gen_refault(folio, shadow);
   552			return;
   553		}
   554	
   555		/*
   556		 * The activation decision for this folio is made at the level
   557		 * where the eviction occurred, as that is where the LRU order
   558		 * during folio reclaim is being determined.
   559		 *
   560		 * However, the cgroup that will own the folio is the one that
   561		 * is actually experiencing the refault event. Make sure the folio is
   562		 * locked to guarantee folio_memcg() stability throughout.
   563		 */
   564		nr = folio_nr_pages(folio);
   565		memcg = folio_memcg(folio);
   566		pgdat = folio_pgdat(folio);
   567		lruvec = mem_cgroup_lruvec(memcg, pgdat);
   568	
   569		if (memcg)
 > 570			WRITE_ONCE(memcg->last_refault, jiffies);
   571	
   572		mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
   573	
   574		if (!workingset_test_recent(shadow, file, &workingset, true))
   575			return;
   576	
   577		folio_set_active(folio);
   578		workingset_age_nonresident(lruvec, nr);
   579		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + file, nr);
   580	
   581		/* Folio was active prior to eviction */
   582		if (workingset) {
   583			folio_set_workingset(folio);
   584			/*
   585			 * XXX: Move to folio_add_lru() when it supports new vs
   586			 * putback
   587			 */
   588			lru_note_cost_refault(folio);
   589			mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
   590		}
   591	}
   592	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

