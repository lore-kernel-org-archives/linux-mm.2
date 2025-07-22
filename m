Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5269FC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E21666B0089; Tue, 22 Jul 2025 10:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA3A6B00A4; Tue, 22 Jul 2025 10:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D37026B00A5; Tue, 22 Jul 2025 10:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1E406B0089
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:12:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B47D140422
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:12:04 +0000 (UTC)
X-FDA: 83692089768.09.D2AA4BE
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf25.hostedemail.com (Postfix) with ESMTP id 60A83A0007
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:12:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753193523; a=rsa-sha256;
	cv=none;
	b=2soqLzdWtwwVIirh7ilbngvPaMLIztn5uKTjRATSc7tw1KZVFoh1T5/pdqjCzYZdoFItr9
	Nv9yQ1/fvXta5B8HdAHCNeQvMiYNAUNhtjMtB2hU7P/oXWbrWsHTd7y6lvCfN4A/+Mg8Oo
	+QNrS/HLwTdt3kzN4f99w4IH9DERu/w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf25.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753193523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QHd/QkWrvUh+S0R6o5f4+JPjcqTokaGMvzcYBtpkdfU=;
	b=L+pO/fE6xHegA5kLk3n+437QbCotI/BsPLqg9a/Zvx25SdNGcr6sbUcoFfPbpJsUXL5EFM
	Y1fif1niaE5XPw3pn9mdGxpJSEa/8nfEi/QSzuUuEmhDK+Sx2L5ynzhqEp085XOK1nElm0
	8Kgc+56ytS4qZGKCsrPd4xM0aJuhj18=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 22 Jul 2025 23:11:58 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 22 Jul 2025 23:11:58 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org,
	oe-kbuild-all@lists.linux.dev, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chrisl@kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aH+cLtTrQtt8qaRz@yjaykim-PowerEdge-T330>
References: <20250716202006.3640584-2-youngjun.park@lge.com>
 <202507190037.RCDNmMsJ-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202507190037.RCDNmMsJ-lkp@intel.com>
X-Stat-Signature: qfbotdoqwh93676qjzinphabm8nrumi8
X-Rspam-User: 
X-Rspamd-Queue-Id: 60A83A0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1753193521-874059
X-HE-Meta: U2FsdGVkX1/kp523EKYlR2/O7K0vwG8GaOm5kv77Z0uXI7xKe0lGa8fyCB6qa8Gh/HxI7sy1Zrmyo8hRwM/ThJ6AEMuJu504uICWstmgfIVkQKXNiNpIc/fYWOFVnakqS8tEgyewjgDAZPQXJ0GtQPRPM65yIFmxrmfvbfD4+plnO6VmhHgIj/Qc7t5uLychckRyxFML26h9OeI2pARMuvuhIUH7hbZQRTc9j+IiVFNZhIiGzEOufBgmU9tCGiaxnkDMoV7j/I0jImf52QFDrxBTRZSXEg4YG8CTQJNeBCuUlHdb2j47Oj9yLMpKEeBZBq7wPcUawOFo4UpO4Mx9eg2u6NO8ofX6CoVMH5w9zBDwNKHy15HlgWor/mnnNBPFYUYw0qHx4p+EUHgtHyhRdf+QQwNX0i4UVBnq+cuEWdC6NLndnPrDuoIFfGKwMKfC8Bl+VocQ6e6PTWzd0tNdZi4cnhRLuXfGDKODq9kph5QbG5W/ErOb9WOokzM3Q7e0Z7zABvWScTVgyvfBBW2EGKMx7hWju64P1TKhB28juvMqIusUy5BeXcbIFW14yfWHCfUfwN3Bu148qf2MIulTrKl45a5cjBQxMDyHLZMfIEoxzs/GDUF/qxy3hsO2sLQ891y7jfkHhsEjzFFkggs0pTKbchC1uRWWrkR/VCc962734OZbkP/iKp/FZWVJ7A44QDQxWuymGpeS/dRVfE/kWK2W9O7ROyAWnePX32TBwyOiO18HgIsMkOwBk3SqA4hTsEp3bIo+DIDy0+ILXf0XOCe8mHDkga9nEcVDn+P0KZKXZgEaO3AUkZE0bmHFrcnd3JVd3OTXeyRMBVYLfCKyu1PsB8b5h3NDTdQJcX6yWMI2mSvEFuVvaxl24XdwkdsjcDoLRJZ3WNbYvs2JTMOlyJWkiNOh0m3Pn/PopsR/6U2szCvhJJSmxkWsxEsWXZFulKfzjTeSmoR/j+LFucY
 9sOmXSr0
 CDQkb8zYtyGFenBJGgJ9tfC8SCyy22YjzNWdkJ6pQiC+YKvm/9E3WD4KVIfVK1N9KORO7DLgZ8C4ksC6cVrmi4w6lNzAKu10gPzOwi/MNJBz2aD4lZAVt9xztG9PsRPxTpx+9BGRrSEpLd0tFWwUktnRqQwEldkn4yPZMxJYdLovudLrtPxsfTM9B5UKqBBtq1C9ct0J0NU/ZjM3oMp1tufi7+nDYXifFJej9XGtDHf6GJnINYGRmJKJk7S8l14Y+3aiIL4w8VIgaFDW9tIpAmpuUBNQ+voBAhniWRPMHrn5yZilAPXouqpRBDRNDpAPE8M3GiqyrzIDbpZBFHqCprAM+uUpyQMD7e7Q4ewv1vRChfESoMFz7ZXdcpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 19, 2025 at 01:08:46AM +0800, kernel test robot wrote:
> Hi Youngjun,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on 347e9f5043c89695b01e66b3ed111755afcf1911]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Youngjun-Park/mm-swap-memcg-Introduce-infrastructure-for-cgroup-based-swap-priority/20250717-042648
> base:   347e9f5043c89695b01e66b3ed111755afcf1911
> patch link:    https://lore.kernel.org/r/20250716202006.3640584-2-youngjun.park%40lge.com
> patch subject: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for cgroup-based swap priority
> config: sparc64-randconfig-r054-20250718 (https://download.01.org/0day-ci/archive/20250719/202507190037.RCDNmMsJ-lkp@intel.com/config)
> compiler: sparc64-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250719/202507190037.RCDNmMsJ-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202507190037.RCDNmMsJ-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from include/linux/rbtree.h:24,
>                     from include/linux/mm_types.h:11,
>                     from include/linux/mmzone.h:22,
>                     from include/linux/swap.h:7,
>                     from mm/swap_cgroup_priority.c:16:
>    mm/swap_cgroup_priority.c: In function 'get_swap_cgroup_priority':
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/rcupdate.h:532:17: note: in definition of macro '__rcu_dereference_check'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                 ^
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/rcupdate.h:532:38: note: in definition of macro '__rcu_dereference_check'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                      ^
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
>    In file included from <command-line>:
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/compiler_types.h:548:23: note: in definition of macro '__compiletime_assert'
>      548 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
>      568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |         ^~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |                            ^~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
>       49 |         compiletime_assert_rwonce_type(x);                              \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/compiler_types.h:548:23: note: in definition of macro '__compiletime_assert'
>      548 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
>      568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |         ^~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |                            ^~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
>       49 |         compiletime_assert_rwonce_type(x);                              \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/compiler_types.h:548:23: note: in definition of macro '__compiletime_assert'
>      548 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
>      568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |         ^~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |                            ^~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
>       49 |         compiletime_assert_rwonce_type(x);                              \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/compiler_types.h:548:23: note: in definition of macro '__compiletime_assert'
>      548 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
>      568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |         ^~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |                            ^~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
>       49 |         compiletime_assert_rwonce_type(x);                              \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/compiler_types.h:548:23: note: in definition of macro '__compiletime_assert'
>      548 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
>      568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |         ^~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
>       49 |         compiletime_assert_rwonce_type(x);                              \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/compiler_types.h:518:27: note: in definition of macro '__unqual_scalar_typeof'
>      518 |                 _Generic((x),                                           \
>          |                           ^
>    include/asm-generic/rwonce.h:50:9: note: in expansion of macro '__READ_ONCE'
>       50 |         __READ_ONCE(x);                                                 \
>          |         ^~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
>    In file included from ./arch/sparc/include/generated/asm/rwonce.h:1,
>                     from include/linux/compiler.h:390,
>                     from include/linux/export.h:5,
>                     from include/linux/linkage.h:7,
>                     from include/linux/preempt.h:10,
>                     from include/linux/spinlock.h:56,
>                     from include/linux/swap.h:5:
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/asm-generic/rwonce.h:44:73: note: in definition of macro '__READ_ONCE'
>       44 | #define __READ_ONCE(x)  (*(const volatile __unqual_scalar_typeof(x) *)&(x))
>          |                                                                         ^
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
> >> mm/swap_cgroup_priority.c:115:37: error: invalid use of undefined type 'struct mem_cgroup'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                                     ^~
>    include/linux/rcupdate.h:535:19: note: in definition of macro '__rcu_dereference_check'
>      535 |         ((typeof(*p) __force __kernel *)(local)); \
>          |                   ^
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:115:16: note: in expansion of macro 'rcu_dereference'
>      115 |         return rcu_dereference(memcg->swap_priority);
>          |                ^~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c: In function 'show_swap_cgroup_priority':
>    mm/swap_cgroup_priority.c:186:30: error: invalid use of undefined type 'struct mem_cgroup'
>      186 |         swap_priority = memcg->swap_priority;
>          |                              ^~
>    mm/swap_cgroup_priority.c: In function 'swap_alloc_cgroup_priority':
>    mm/swap_cgroup_priority.c:285:26: error: invalid use of undefined type 'struct mem_cgroup'
>      285 |                 if (memcg->swap_priority != swap_priority)
>          |                          ^~
>    mm/swap_cgroup_priority.c: In function 'apply_swap_cgroup_priority':
>    mm/swap_cgroup_priority.c:638:46: error: invalid use of undefined type 'struct mem_cgroup'
>      638 |         swap_priority = rcu_dereference(memcg->swap_priority);
>          |                                              ^~
>    include/linux/rcupdate.h:532:17: note: in definition of macro '__rcu_dereference_check'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                 ^
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:638:25: note: in expansion of macro 'rcu_dereference'
>      638 |         swap_priority = rcu_dereference(memcg->swap_priority);
>          |                         ^~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:638:46: error: invalid use of undefined type 'struct mem_cgroup'
>      638 |         swap_priority = rcu_dereference(memcg->swap_priority);
>          |                                              ^~
>    include/linux/rcupdate.h:532:38: note: in definition of macro '__rcu_dereference_check'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                      ^
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:638:25: note: in expansion of macro 'rcu_dereference'
>      638 |         swap_priority = rcu_dereference(memcg->swap_priority);
>          |                         ^~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:638:46: error: invalid use of undefined type 'struct mem_cgroup'
>      638 |         swap_priority = rcu_dereference(memcg->swap_priority);
>          |                                              ^~
>    include/linux/compiler_types.h:548:23: note: in definition of macro '__compiletime_assert'
>      548 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
>      568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |         ^~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |                            ^~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
>       49 |         compiletime_assert_rwonce_type(x);                              \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
>          |                            ^~~~~~~~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:638:25: note: in expansion of macro 'rcu_dereference'
>      638 |         swap_priority = rcu_dereference(memcg->swap_priority);
>          |                         ^~~~~~~~~~~~~~~
>    mm/swap_cgroup_priority.c:638:46: error: invalid use of undefined type 'struct mem_cgroup'
>      638 |         swap_priority = rcu_dereference(memcg->swap_priority);
>          |                                              ^~
>    include/linux/compiler_types.h:548:23: note: in definition of macro '__compiletime_assert'
>      548 |                 if (!(condition))                                       \
>          |                       ^~~~~~~~~
>    include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
>      568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>          |         ^~~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:9: note: in expansion of macro 'compiletime_assert'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |         ^~~~~~~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:36:28: note: in expansion of macro '__native_word'
>       36 |         compiletime_assert(__native_word(t) || sizeof(t) == sizeof(long long),  \
>          |                            ^~~~~~~~~~~~~
>    include/asm-generic/rwonce.h:49:9: note: in expansion of macro 'compiletime_assert_rwonce_type'
>       49 |         compiletime_assert_rwonce_type(x);                              \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:532:50: note: in expansion of macro 'READ_ONCE'
>      532 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \
>          |                                                  ^~~~~~~~~
>    include/linux/rcupdate.h:680:9: note: in expansion of macro '__rcu_dereference_check'
>      680 |         __rcu_dereference_check((p), __UNIQUE_ID(rcu), \
>          |         ^~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/rcupdate.h:752:28: note: in expansion of macro 'rcu_dereference_check'
>      752 | #define rcu_dereference(p) rcu_dereference_check(p, 0)
> 
> 
> vim +115 mm/swap_cgroup_priority.c
> 
>   > 16	#include <linux/swap.h>
>     17	#include <linux/rcupdate.h>
>     18	#include <linux/memcontrol.h>
>     19	#include <linux/plist.h>
>     20	#include "swap.h"
>     21	#include "swap_cgroup_priority.h"
>     22	#include "memcontrol-v1.h"
>     23	
>     24	static LIST_HEAD(swap_cgroup_priority_list);
>     25	
>     26	/*
>     27	 * struct swap_cgroup_priority
>     28	 *
>     29	 * This structure is RCU protected. Its lifecycle is determined by its
>     30	 * owning memcg or when its 'distance' reaches zero. The 'distance' field
>     31	 * tracks priority differences from global swap. If zero, and its default_prio
>     32	 * follows global swap priority(SWAP_PRIORITY_GLOBAL), the object is destroyed.
>     33	 *
>     34	 * pnode - Array of pointers to swap device priority nodes.
>     35	 * owner - The owning memory cgroup.
>     36	 * rcu - RCU free callback.
>     37	 * link - Global linked list entry.
>     38	 * least_priority - Current lowest priority.
>     39	 * distance - Priority differences from global swap priority.
>     40	 * default_prio - Default priority for this cgroup.
>     41	 * plist - Priority list head.
>     42	 */
>     43	struct swap_cgroup_priority {
>     44		struct swap_cgroup_priority_pnode *pnode[MAX_SWAPFILES];
>     45		struct mem_cgroup *owner;
>     46	
>     47		union {
>     48			struct rcu_head rcu;
>     49			struct list_head link;
>     50		};
>     51	
>     52		int least_priority;
>     53		s8 distance;
>     54		int default_prio;
>     55		struct plist_head plist[];
>     56	};
>     57	
>     58	/*
>     59	 * struct swap_cgroup_priority_pnode
>     60	 *
>     61	 * This structure represents a priority node for a specific swap device
>     62	 * within a cgroup.
>     63	 *
>     64	 * swap - Pointer to the associated swap device.
>     65	 * id - Unique identifier for the swap device.
>     66	 * prio - Configured priority for this device.
>     67	 * avail_lists - Connections to various priority lists.
>     68	 */
>     69	struct swap_cgroup_priority_pnode {
>     70		struct swap_info_struct *swap;
>     71		u64 id;
>     72		signed short prio;
>     73		struct plist_node avail_lists[];
>     74	};
>     75	
>     76	/*
>     77	 * Even with a zero distance, a swap device isn't assigned if it doesn't
>     78	 * meet global swap priority conditions; thus, we don't clear it.
>     79	 */
>     80	static bool should_clear_swap_cgroup_priority(
>     81		struct swap_cgroup_priority *swap_priority)
>     82	{
>     83		WARN_ON_ONCE(swap_priority->distance < 0 ||
>     84			swap_priority->distance > MAX_SWAPFILES);
>     85	
>     86		if (swap_priority->distance == 0 &&
>     87		    swap_priority->default_prio == SWAP_PRIORITY_GLOBAL)
>     88			return true;
>     89	
>     90		return false;
>     91	}
>     92	
>     93	/*
>     94	 * swapdev_id
>     95	 *
>     96	 * A unique identifier for a swap device.
>     97	 *
>     98	 * This ID ensures stable identification for users and crucial synchronization
>     99	 * for swap cgroup priority settings. It provides a reliable reference even if
>    100	 * device paths or numbers change.
>    101	 */
>    102	static atomic64_t swapdev_id_counter;
>    103	
>    104	void get_swapdev_id(struct swap_info_struct *si)
>    105	{
>    106		si->id = atomic64_inc_return(&swapdev_id_counter);
>    107	}
>    108	
>    109	static struct swap_cgroup_priority *get_swap_cgroup_priority(
>    110		struct mem_cgroup *memcg)
>    111	{
>    112		if (!memcg)
>    113			return NULL;
>    114	
>  > 115		return rcu_dereference(memcg->swap_priority);
>    116	}
>    117	
 
The build dependency should have been CONFIG_MEMCG instead of CONFIG_CGROUP.
Apologies for overlooking this. I will update the dependency and verify
in the next patch version.

Best regards,
Youngjun Park

