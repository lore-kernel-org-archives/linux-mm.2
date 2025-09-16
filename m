Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36822CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 05:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E058E0011; Tue, 16 Sep 2025 01:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DF38E0001; Tue, 16 Sep 2025 01:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 834A98E0011; Tue, 16 Sep 2025 01:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 721308E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:56:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED33D140852
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:56:04 +0000 (UTC)
X-FDA: 83894052648.18.D3FD649
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id AFB6D180005
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:56:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="b1QXa/un";
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758002163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hgfjV2PnbYT09anTqO8cvi/R0m1PzPvur0flcW0+lc=;
	b=oAQfMdoSe+90t9y57PwH/5kZfS080z+YscFeZ+JOMtk0rirh85t239nXHPSlDMPGOj4BfX
	BFBK6RU6W4jVW6TyyPp0gaGt08cM8z2Ui0FH2gAID7LAk5kwRsFwpoLwiAWd0EUoqSNN0k
	Nf8Neq3jAbWEsCEIBOKSv7z4ERIWSV0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="b1QXa/un";
	spf=pass (imf06.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758002163; a=rsa-sha256;
	cv=none;
	b=KernxXrdYq4Nxr1V9yjUL0engEqBBVVuSxO1ze6JruApIbGoOWfBoobvXnpfwoy04N99hi
	3qBJP+1CSDOWmzMU4u/L5SqroV7G1SHgMvdnMpnJOdp9Sdzt/knxKuljorF6bKXHPHodzQ
	g2Vklx07qQuMDqTDC8fMVHQUXo5Vy8Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758002163; x=1789538163;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=TI1GQ9/fie5SEXhyuw4/SGhlUqJfUF1ZYY8Qg3rWUHs=;
  b=b1QXa/unCpTME2AQ8h9XKMMvOLmxGcC9QOtFffvJOyLGNorApcHWjncf
   HwCGQMsYJmG2sm9TCVmC0lknHG1RhMAitVnSWYcgmvxJIFY1f4/BEDRqh
   8QfFHBBasIm2gYfpftj3rLFUbAZtMpVhBRRBLkw1bSTA1A97NEEGDPpch
   9+cPrHyN0w7msH6FkPqiaU9Mj9MH/Ha4hJsQXGGjb+nrCyffKTGERJJGh
   oNpyphFqe5qCiwcHagMuGb+hvg9DROcH1mWvhW0b7dihLEfz290q8Vfhq
   Kb8g7F6KNrqS6q/1vrj09TQjJJvvvEIMOAqqXcXJFWFhtmDFCoE+8fr77
   A==;
X-CSE-ConnectionGUID: yYMjX0o7Q+eAkpJUVer5Gw==
X-CSE-MsgGUID: idJtgZEgSNyebbzZsdRnog==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="70520756"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="70520756"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 22:56:01 -0700
X-CSE-ConnectionGUID: 4bV9z9nLQ3WfqI99ueea9g==
X-CSE-MsgGUID: LxHVe4F5R4ioJetCgS766w==
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO 5b01dd97f97c) ([10.239.97.150])
  by fmviesa003.fm.intel.com with ESMTP; 15 Sep 2025 22:55:55 -0700
Received: from kbuild by 5b01dd97f97c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uyOfQ-00012O-2o;
	Tue, 16 Sep 2025 05:55:52 +0000
Date: Tue, 16 Sep 2025 13:55:38 +0800
From: kernel test robot <lkp@intel.com>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	linux-riscv@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Deepak Gupta <debug@rivosinc.com>,
	Ved Shanbhogue <ved@rivosinc.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Peter Xu <peterx@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [PATCH V12 2/5] mm: userfaultfd: Add pgtable_supports_uffd_wp()
Message-ID: <202509161304.mQnxOxhS-lkp@intel.com>
References: <20250915101343.1449546-3-zhangchunyan@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915101343.1449546-3-zhangchunyan@iscas.ac.cn>
X-Rspamd-Queue-Id: AFB6D180005
X-Rspamd-Server: rspam05
X-Stat-Signature: fako8u9q4ukgf91hxcpc38otro354459
X-Rspam-User: 
X-HE-Tag: 1758002162-299323
X-HE-Meta: U2FsdGVkX19GECXKBGNWqoidUTRhWqdmrpqAA41hXLnoU5jootwCcHHwTNMnQmHZL/l5vBYUmn3axBtfPBkspDOfin1T98M/2X2jISOiX0UIym6c/kpmBrgMPRBO1GYbBIgKbT8eKbO77lrTZMlJb8UT4RodsfNB0uR2X1bLM4vlHu+y+WH/bx/Yf+/MK6qGRL8GcfQe4/GlNb08Q0FK/b2K7Fcss3zrwQR4EQDfIeWcBuWVMg84o5LMVA4RDJ7fNswkXfcpdyplbPtsPWkW9z9V8jI3cMeNQKy4t54mao6eNl96alsmgClMrX3RUFvddfF7p2TdlGx1xuawaoWgHOMz3A18QlFbZ64voexxhSJLmng5t3uggCg8keQ3yRMOxXR8YlXSdvp7h3El/FL6ALYItIzvQZ+0Tp4Lr7FdswLNUqSFOe7KE7lsTWDOTkoifTsAX/y2ui9cLosjArXn+6S3NjUUKbhNY+oxjOwOpIO9g/1KyuVBfT5uxpdIn0qVqO4sbqyu8hD0TGKRMD5Fpirl8lvwzutoLSQQBLyZUdTZluGGaQtMMYu1gHFfhBO62nGQxJpyiO/GALiHSd5hfv2tRWKEBII2geilGCxOP61B76Ihsf5L0sE7IlD4X5fZTz8h305fbTnQdu9//40uTvdqbKso487WEZS1ngQ6lVYwMaZXqo/+qp2S9y5ReygqC5BsoMSYqFOmWy3IjqWddJPBo4EIgLkk5F7/18Qy36MwK7S+9fKvftLZsoxNjGKt9LLxcTjYEyWwfD/w075kCuO3FXhZjnT0ATnRd9RjIszU/fLavDUtDlbZ02glVst6xdGp0IsxuBDTsvsiZCR24WLimOyDB3Z84s5T4LbK04Yx5OHFsHdP94zwZ1wDuCqLOw8YU+XXka/+49UUvK5is1W1bpvv1r5fcgwVPVjlbQziabTPYEJQEDyNzWJGxmalFd23p3IFFrdlX1ct9eo
 i5NdpAnE
 Op4NraEFFAU9VHZ5qO06AiMKKieCkwoi3XdU03S3xR0ztpzQ2iEr78nqMW86MN/27pqjjmmpLmTQmVj/L/3mEYAgxvT9Jh+DmW4wGkQJFllKFJ+85hKRLKwakRfWU9YsdRmvUZtDVL+ljEXS4ec52GaS4fVqxwuyHGeWVfKIdpWQ0/+v6Hwp6tD6vMRd9CP+YnNgfYLQAovtQU7QkUKeo5XOHHUttIDAfL5AnO6LJ82ZLjiymXXr6MNb9b14BhEachb4HzWhSsX0Le/9N+gAU7y+316Ste1ayo/WmWpJFb59y+VBnId+2ioRx1k431RagKK+Lw6LsORgoeJj626ddT5BZXMWObazmYiB3ojRCOXTClP8gUIdMo4xeVnKvcFYvskowSHBdYQo6QT5+qYquSFHNTAmnsmQE7EhyqlddwCV4jnQUlK8t4E/+rv0o5VVDsf9dbXarI8dw/+YZm2asDuhWDNh2a3bagkamj2TUyob8QCriVXcNvmKnFC19Rz0mcZ2B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chunyan,

kernel test robot noticed the following build errors:

[auto build test ERROR on brauner-vfs/vfs.all]
[also build test ERROR on kees/for-next/execve linus/master v6.17-rc6]
[cannot apply to akpm-mm/mm-everything next-20250915]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Chunyan-Zhang/mm-softdirty-Add-pgtable_supports_soft_dirty/20250915-181826
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20250915101343.1449546-3-zhangchunyan%40iscas.ac.cn
patch subject: [PATCH V12 2/5] mm: userfaultfd: Add pgtable_supports_uffd_wp()
config: riscv-randconfig-002-20250916 (https://download.01.org/0day-ci/archive/20250916/202509161304.mQnxOxhS-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 10.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250916/202509161304.mQnxOxhS-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509161304.mQnxOxhS-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/mm_inline.h:10,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
   include/linux/userfaultfd_k.h: In function 'pte_marker_entry_uffd_wp':
>> include/linux/userfaultfd_k.h:441:9: error: implicit declaration of function 'is_pte_marker_entry' [-Werror=implicit-function-declaration]
     441 |  return is_pte_marker_entry(entry) &&
         |         ^~~~~~~~~~~~~~~~~~~
>> include/linux/userfaultfd_k.h:442:10: error: implicit declaration of function 'pte_marker_get' [-Werror=implicit-function-declaration]
     442 |         (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
         |          ^~~~~~~~~~~~~~
>> include/linux/userfaultfd_k.h:442:34: error: 'PTE_MARKER_UFFD_WP' undeclared (first use in this function)
     442 |         (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
         |                                  ^~~~~~~~~~~~~~~~~~
   include/linux/userfaultfd_k.h:442:34: note: each undeclared identifier is reported only once for each function it appears in
   include/linux/userfaultfd_k.h: In function 'pte_marker_uffd_wp':
>> include/linux/userfaultfd_k.h:452:7: error: implicit declaration of function 'is_swap_pte'; did you mean 'is_swap_pmd'? [-Werror=implicit-function-declaration]
     452 |  if (!is_swap_pte(pte))
         |       ^~~~~~~~~~~
         |       is_swap_pmd
>> include/linux/userfaultfd_k.h:455:10: error: implicit declaration of function 'pte_to_swp_entry' [-Werror=implicit-function-declaration]
     455 |  entry = pte_to_swp_entry(pte);
         |          ^~~~~~~~~~~~~~~~
>> include/linux/userfaultfd_k.h:455:10: error: incompatible types when assigning to type 'swp_entry_t' from type 'int'
   In file included from include/linux/mm_inline.h:11,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
   include/linux/swapops.h: At top level:
>> include/linux/swapops.h:124:19: error: static declaration of 'is_swap_pte' follows non-static declaration
     124 | static inline int is_swap_pte(pte_t pte)
         |                   ^~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
   include/linux/userfaultfd_k.h:452:7: note: previous implicit declaration of 'is_swap_pte' was here
     452 |  if (!is_swap_pte(pte))
         |       ^~~~~~~~~~~
   In file included from include/linux/mm_inline.h:11,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
>> include/linux/swapops.h:133:27: error: conflicting types for 'pte_to_swp_entry'
     133 | static inline swp_entry_t pte_to_swp_entry(pte_t pte)
         |                           ^~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
   include/linux/userfaultfd_k.h:455:10: note: previous implicit declaration of 'pte_to_swp_entry' was here
     455 |  entry = pte_to_swp_entry(pte);
         |          ^~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:11,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
>> include/linux/swapops.h:429:20: error: conflicting types for 'is_pte_marker_entry'
     429 | static inline bool is_pte_marker_entry(swp_entry_t entry)
         |                    ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
   include/linux/userfaultfd_k.h:441:9: note: previous implicit declaration of 'is_pte_marker_entry' was here
     441 |  return is_pte_marker_entry(entry) &&
         |         ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:11,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
>> include/linux/swapops.h:434:26: error: conflicting types for 'pte_marker_get'
     434 | static inline pte_marker pte_marker_get(swp_entry_t entry)
         |                          ^~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/internal.h:13,
                    from mm/page_frag_cache.c:21:
   include/linux/userfaultfd_k.h:442:10: note: previous implicit declaration of 'pte_marker_get' was here
     442 |         (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
         |          ^~~~~~~~~~~~~~
   cc1: some warnings being treated as errors
--
   In file included from include/linux/mm_inline.h:10,
                    from mm/mremap.c:12:
   include/linux/userfaultfd_k.h: In function 'pte_marker_entry_uffd_wp':
>> include/linux/userfaultfd_k.h:441:9: error: implicit declaration of function 'is_pte_marker_entry' [-Werror=implicit-function-declaration]
     441 |  return is_pte_marker_entry(entry) &&
         |         ^~~~~~~~~~~~~~~~~~~
>> include/linux/userfaultfd_k.h:442:10: error: implicit declaration of function 'pte_marker_get' [-Werror=implicit-function-declaration]
     442 |         (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
         |          ^~~~~~~~~~~~~~
>> include/linux/userfaultfd_k.h:442:34: error: 'PTE_MARKER_UFFD_WP' undeclared (first use in this function)
     442 |         (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
         |                                  ^~~~~~~~~~~~~~~~~~
   include/linux/userfaultfd_k.h:442:34: note: each undeclared identifier is reported only once for each function it appears in
   include/linux/userfaultfd_k.h: In function 'pte_marker_uffd_wp':
>> include/linux/userfaultfd_k.h:452:7: error: implicit declaration of function 'is_swap_pte'; did you mean 'is_swap_pmd'? [-Werror=implicit-function-declaration]
     452 |  if (!is_swap_pte(pte))
         |       ^~~~~~~~~~~
         |       is_swap_pmd
>> include/linux/userfaultfd_k.h:455:10: error: implicit declaration of function 'pte_to_swp_entry' [-Werror=implicit-function-declaration]
     455 |  entry = pte_to_swp_entry(pte);
         |          ^~~~~~~~~~~~~~~~
>> include/linux/userfaultfd_k.h:455:10: error: incompatible types when assigning to type 'swp_entry_t' from type 'int'
   In file included from include/linux/mm_inline.h:11,
                    from mm/mremap.c:12:
   include/linux/swapops.h: At top level:
>> include/linux/swapops.h:124:19: error: static declaration of 'is_swap_pte' follows non-static declaration
     124 | static inline int is_swap_pte(pte_t pte)
         |                   ^~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/mremap.c:12:
   include/linux/userfaultfd_k.h:452:7: note: previous implicit declaration of 'is_swap_pte' was here
     452 |  if (!is_swap_pte(pte))
         |       ^~~~~~~~~~~
   In file included from include/linux/mm_inline.h:11,
                    from mm/mremap.c:12:
>> include/linux/swapops.h:133:27: error: conflicting types for 'pte_to_swp_entry'
     133 | static inline swp_entry_t pte_to_swp_entry(pte_t pte)
         |                           ^~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/mremap.c:12:
   include/linux/userfaultfd_k.h:455:10: note: previous implicit declaration of 'pte_to_swp_entry' was here
     455 |  entry = pte_to_swp_entry(pte);
         |          ^~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:11,
                    from mm/mremap.c:12:
>> include/linux/swapops.h:429:20: error: conflicting types for 'is_pte_marker_entry'
     429 | static inline bool is_pte_marker_entry(swp_entry_t entry)
         |                    ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/mremap.c:12:
   include/linux/userfaultfd_k.h:441:9: note: previous implicit declaration of 'is_pte_marker_entry' was here
     441 |  return is_pte_marker_entry(entry) &&
         |         ^~~~~~~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:11,
                    from mm/mremap.c:12:
>> include/linux/swapops.h:434:26: error: conflicting types for 'pte_marker_get'
     434 | static inline pte_marker pte_marker_get(swp_entry_t entry)
         |                          ^~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/mremap.c:12:
   include/linux/userfaultfd_k.h:442:10: note: previous implicit declaration of 'pte_marker_get' was here
     442 |         (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
         |          ^~~~~~~~~~~~~~
   In file included from include/linux/mm_inline.h:10,
                    from mm/mremap.c:12:
   include/linux/userfaultfd_k.h: In function 'pte_marker_entry_uffd_wp':
   include/linux/userfaultfd_k.h:443:1: warning: control reaches end of non-void function [-Wreturn-type]
     443 | }
         | ^
   cc1: some warnings being treated as errors


vim +/is_pte_marker_entry +441 include/linux/userfaultfd_k.h

2bad466cc9d9b4c Peter Xu      2023-03-09  435  
1db9dbc2ef05205 Peter Xu      2022-05-12  436  static inline bool pte_marker_entry_uffd_wp(swp_entry_t entry)
1db9dbc2ef05205 Peter Xu      2022-05-12  437  {
564509f441b4695 Chunyan Zhang 2025-09-15  438  	if (!uffd_supports_wp_marker())
564509f441b4695 Chunyan Zhang 2025-09-15  439  		return false;
564509f441b4695 Chunyan Zhang 2025-09-15  440  
1db9dbc2ef05205 Peter Xu      2022-05-12 @441  	return is_pte_marker_entry(entry) &&
1db9dbc2ef05205 Peter Xu      2022-05-12 @442  	       (pte_marker_get(entry) & PTE_MARKER_UFFD_WP);
1db9dbc2ef05205 Peter Xu      2022-05-12  443  }
1db9dbc2ef05205 Peter Xu      2022-05-12  444  
1db9dbc2ef05205 Peter Xu      2022-05-12  445  static inline bool pte_marker_uffd_wp(pte_t pte)
1db9dbc2ef05205 Peter Xu      2022-05-12  446  {
1db9dbc2ef05205 Peter Xu      2022-05-12  447  	swp_entry_t entry;
1db9dbc2ef05205 Peter Xu      2022-05-12  448  
564509f441b4695 Chunyan Zhang 2025-09-15  449  	if (!uffd_supports_wp_marker())
564509f441b4695 Chunyan Zhang 2025-09-15  450  		return false;
564509f441b4695 Chunyan Zhang 2025-09-15  451  
1db9dbc2ef05205 Peter Xu      2022-05-12 @452  	if (!is_swap_pte(pte))
1db9dbc2ef05205 Peter Xu      2022-05-12  453  		return false;
1db9dbc2ef05205 Peter Xu      2022-05-12  454  
1db9dbc2ef05205 Peter Xu      2022-05-12 @455  	entry = pte_to_swp_entry(pte);
1db9dbc2ef05205 Peter Xu      2022-05-12  456  
1db9dbc2ef05205 Peter Xu      2022-05-12  457  	return pte_marker_entry_uffd_wp(entry);
1db9dbc2ef05205 Peter Xu      2022-05-12  458  }
1db9dbc2ef05205 Peter Xu      2022-05-12  459  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

