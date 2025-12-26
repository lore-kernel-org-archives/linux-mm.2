Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE7BAE8FDB8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 20:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF276B008A; Fri, 26 Dec 2025 15:51:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D69C6B008C; Fri, 26 Dec 2025 15:51:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E33E6B0092; Fri, 26 Dec 2025 15:51:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1757D6B008A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 15:51:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AD35913AE3C
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:51:35 +0000 (UTC)
X-FDA: 84262818150.15.A863892
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf15.hostedemail.com (Postfix) with ESMTP id 31A96A0009
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:51:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kGKb5FZg;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766782293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaRayuL/JsLheaa0A6HWQKq33YpmaANx2VpUvioFZYo=;
	b=R+p9c5+acXp6sLJnhgxjFKdievvF2Hzg9KpCcs1xc+lAxqep6wc3r60GYcUhetR75wm9jW
	lxm7fPgMPmlITmwrofYoz9jLtExXPHjhPwNjjRtGdE3xUAIGVC07kOeKv9sisjXbRz3eBm
	zi7h0/D46KjUpxITnMiAnkVQk+EDf+g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=kGKb5FZg;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766782293; a=rsa-sha256;
	cv=none;
	b=JkDMZx3+6RPHq3GBu7hGkwnrgtXUBwXjCgca/WC8y2gFHxPGltc1mbCoQewOGCw4aP2nxO
	Km81BTtyKME//S8oZ8qa93STueG8HTCL3VGgeeE5Q7f9vLaIZzlQiLRAaqhQieJUkJkuuA
	tz9hJ9sCB1RS3oCDm5QyKIHaHNo7W6o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1766782293; x=1798318293;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cIai1HhnCTdXbz4D4yQFoHY8vOuTPp1/oRc27ajVe+E=;
  b=kGKb5FZgGGkV1R480tQRoYU1qJd6/Bv4HROKwNW3oVkCBz47jMWxbrvu
   HE7btpIQ5/B+sIAIx724XjUmnETmLyvBd/SubILNOy95q5wfVmsPJSAno
   rD/BZchwzxGnAe43cbeAulZ+dC1r6mqh7IG3C2lC9ht1ylR9G91x77eRS
   1F1aP64PfLPFMktZYt/K55n9L/jg/vYxflCRhkX7SeOZxlwvic6DMEc1h
   kWszOqF1eP5Fru+uVDp+GFNJJPcvmIU++NtOv6khynqtb6RF61koDdq7I
   ByoUBPVSzAWdurHhI/LPnGWcG4wSQX29UrZtdWXyiC/KENTKMt0Q8eurC
   Q==;
X-CSE-ConnectionGUID: 10Q9bYMTTvG5EYHl3dG+iw==
X-CSE-MsgGUID: arg4r8x1RkGhFEUKfsH5Uw==
X-IronPort-AV: E=McAfee;i="6800,10657,11653"; a="79246674"
X-IronPort-AV: E=Sophos;i="6.21,178,1763452800"; 
   d="scan'208";a="79246674"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2025 12:51:32 -0800
X-CSE-ConnectionGUID: YqE5d6ZPQYO0wJ3eYfLzyQ==
X-CSE-MsgGUID: xXoAATubQzuBV+NEBEv4tQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,178,1763452800"; 
   d="scan'208";a="201371819"
Received: from lkp-server02.sh.intel.com (HELO dd3453e2b682) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 26 Dec 2025 12:51:27 -0800
Received: from kbuild by dd3453e2b682 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vZEmT-000000005Ld-1ea1;
	Fri, 26 Dec 2025 20:51:25 +0000
Date: Sat, 27 Dec 2025 04:51:04 +0800
From: kernel test robot <lkp@intel.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
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
Message-ID: <202512270405.sx7TY5MG-lkp@intel.com>
References: <20251226064257.245581-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251226064257.245581-1-jiayuan.chen@linux.dev>
X-Rspamd-Server: rspam02
X-Stat-Signature: 7zu1zd7sft1dk35iazbg6kp7epw4dgtw
X-Rspam-User: 
X-Rspamd-Queue-Id: 31A96A0009
X-HE-Tag: 1766782293-48832
X-HE-Meta: U2FsdGVkX1/w43Vg6q7hLJdiWZQEprvHzy2PDWZ6/QXek3BPJhG8/6PNUZC+lRnkBssjiXC8dP/eng4ydsJnSct8R+Dax9uyFtclfM+L+cQTg4JgrnwgC7yKDzhULiq38Dt1/YMSRSlAJAd79llKByz3NEW4adsfZsOyn5aqeRerpFzfS8aemGgYGy9UAvkunnqIRnNiDDeANdapT5PMFQCk09oIU6Lfov8ldUFhjk0mQqFV3Q0WG0X6d3jD4Q/Dt/a4jRZVbA/m35zU3fJQ/BoMPGk2fL0w84/gLG8UC4zsCGzAU1W2eKiXQK7n8gnJu+bj1xyN8fpkozq6sS3BuPi/OhQWp3FYEN9pY2QVVAhs5qZRkQWxpk/vC+aDf7tLEmwXwO0gwHrhKyoUaoVJLb0zySrh24oYdQEbhwaBunlKMy/75MdybSg8Jgshd5bq98SC+EZv5CLm1axirPLFIiV0Y0o/AoeOQ1EPrLRDlj6VxKwYYkUft6yvbRXISr7KBx8cuIm++Pi2/vuzjh+ruU5YPMISBvQILX5JWfMw9b99lCcQ7dbmDvZLxo6QhqEmieYCx0CQ7MAeLreelbrO7YLZp3r6Y5gYr1z0soXTL+iv3+i8KxMrXF5mRvmumCcyr5pUf4dyDU1Is3fwr1OiGvqdHE9VvpRBpl1sEXL6BPldlwSgo6KxNSKQQdKPPUZUAE911YdrNFsf6dVFMjlL4DgO9waE+bsJ0eBL25XUfCFCoTN2yNPkRYWEUimJWgElozbqFmwFwLKcoCtNwo4WHcnqyfz1t1kBaz/fTQDG+MM6Mq5y9s1Wn8nZvvmRfT8yuEdlHhe/RmXr+6PwrsONd+2qlwwM4jW74ZfV4R2769mtIARMvmQHdzkWvjx8CjC0aV1IO8mMUnTMQ5GZ0V1a9NmjU65qEFg0eW5yPhJWtSJI4xvla0RhHLHveMwR6Ru9hRkDxcuEPiTtqCeYGv+
 FjTkKyHX
 I3rxEs/VvG3EI9uBgFsHfPWDXAFPFLwGIBM7BjCAnZfpyFSA84xT6y32oNwsN1KSRAIQTSNttYRcCV0U+LfAdpqmLLtIlqKcC6ZM3N0PRmr4m4OKSHoJXEfYBTRvWoHxBdpzbCR2ifIfhbTLYB7l9NJwIinI/nm21yDPVlH0N05KiHGI+KDAZ1sMGWC4J8v/B4DNExyRrPAjJPMpUbUNPTCuS4/rnaE2H8i5lGkOqGcQNViGcptvK2NIK5mtW8jlvQjW+3fXnjD277yssIToZQQ3/iYXPVoKrflVryDTcGzrfRyp3iC3V4RUCj/sV+cEVX12/0KBBpMP+WcBswRTi2MKgJwDpGZ9/dHEj1Zo7Sg7wpRQ=
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
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20251227/202512270405.sx7TY5MG-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251227/202512270405.sx7TY5MG-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202512270405.sx7TY5MG-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/workingset.c:570:19: error: incomplete definition of type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                            ~~~~~^
   include/asm-generic/rwonce.h:60:33: note: expanded from macro 'WRITE_ONCE'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |                                        ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                                          ^
   include/linux/compiler_types.h:592:10: note: expanded from macro '__native_word'
     592 |         (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
         |                 ^
   include/linux/compiler_types.h:631:22: note: expanded from macro 'compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:619:23: note: expanded from macro '_compiletime_assert'
     619 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:611:9: note: expanded from macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/shrinker.h:55:9: note: forward declaration of 'struct mem_cgroup'
      55 |         struct mem_cgroup *memcg;
         |                ^
>> mm/workingset.c:570:19: error: incomplete definition of type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                            ~~~~~^
   include/asm-generic/rwonce.h:60:33: note: expanded from macro 'WRITE_ONCE'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |                                        ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                                          ^
   include/linux/compiler_types.h:592:39: note: expanded from macro '__native_word'
     592 |         (sizeof(t) == sizeof(char) || sizeof(t) == sizeof(short) || \
         |                                              ^
   include/linux/compiler_types.h:631:22: note: expanded from macro 'compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:619:23: note: expanded from macro '_compiletime_assert'
     619 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:611:9: note: expanded from macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/shrinker.h:55:9: note: forward declaration of 'struct mem_cgroup'
      55 |         struct mem_cgroup *memcg;
         |                ^
>> mm/workingset.c:570:19: error: incomplete definition of type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                            ~~~~~^
   include/asm-generic/rwonce.h:60:33: note: expanded from macro 'WRITE_ONCE'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |                                        ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                                          ^
   include/linux/compiler_types.h:593:10: note: expanded from macro '__native_word'
     593 |          sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
         |                 ^
   include/linux/compiler_types.h:631:22: note: expanded from macro 'compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:619:23: note: expanded from macro '_compiletime_assert'
     619 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:611:9: note: expanded from macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/shrinker.h:55:9: note: forward declaration of 'struct mem_cgroup'
      55 |         struct mem_cgroup *memcg;
         |                ^
>> mm/workingset.c:570:19: error: incomplete definition of type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                            ~~~~~^
   include/asm-generic/rwonce.h:60:33: note: expanded from macro 'WRITE_ONCE'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |                                        ^
   include/asm-generic/rwonce.h:36:35: note: expanded from macro 'compiletime_assert_rwonce_type'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                                          ^
   include/linux/compiler_types.h:593:38: note: expanded from macro '__native_word'
     593 |          sizeof(t) == sizeof(int) || sizeof(t) == sizeof(long))
         |                                             ^
   include/linux/compiler_types.h:631:22: note: expanded from macro 'compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:619:23: note: expanded from macro '_compiletime_assert'
     619 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:611:9: note: expanded from macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/shrinker.h:55:9: note: forward declaration of 'struct mem_cgroup'
      55 |         struct mem_cgroup *memcg;
         |                ^
>> mm/workingset.c:570:19: error: incomplete definition of type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                            ~~~~~^
   include/asm-generic/rwonce.h:60:33: note: expanded from macro 'WRITE_ONCE'
      60 |         compiletime_assert_rwonce_type(x);                              \
         |                                        ^
   include/asm-generic/rwonce.h:36:48: note: expanded from macro 'compiletime_assert_rwonce_type'
      36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
         |                                                       ^
   include/linux/compiler_types.h:631:22: note: expanded from macro 'compiletime_assert'
     631 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                             ^~~~~~~~~
   include/linux/compiler_types.h:619:23: note: expanded from macro '_compiletime_assert'
     619 |         __compiletime_assert(condition, msg, prefix, suffix)
         |                              ^~~~~~~~~
   include/linux/compiler_types.h:611:9: note: expanded from macro '__compiletime_assert'
     611 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/shrinker.h:55:9: note: forward declaration of 'struct mem_cgroup'
      55 |         struct mem_cgroup *memcg;
         |                ^
>> mm/workingset.c:570:19: error: incomplete definition of type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                            ~~~~~^
   include/asm-generic/rwonce.h:61:15: note: expanded from macro 'WRITE_ONCE'
      61 |         __WRITE_ONCE(x, val);                                           \
         |                      ^
   include/asm-generic/rwonce.h:55:20: note: expanded from macro '__WRITE_ONCE'
      55 |         *(volatile typeof(x) *)&(x) = (val);                            \
         |                           ^
   include/linux/shrinker.h:55:9: note: forward declaration of 'struct mem_cgroup'
      55 |         struct mem_cgroup *memcg;
         |                ^
>> mm/workingset.c:570:19: error: incomplete definition of type 'struct mem_cgroup'
     570 |                 WRITE_ONCE(memcg->last_refault, jiffies);
         |                            ~~~~~^
   include/asm-generic/rwonce.h:61:15: note: expanded from macro 'WRITE_ONCE'
      61 |         __WRITE_ONCE(x, val);                                           \
         |                      ^
   include/asm-generic/rwonce.h:55:27: note: expanded from macro '__WRITE_ONCE'
      55 |         *(volatile typeof(x) *)&(x) = (val);                            \
         |                                  ^
   include/linux/shrinker.h:55:9: note: forward declaration of 'struct mem_cgroup'
      55 |         struct mem_cgroup *memcg;
         |                ^
   7 errors generated.


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

