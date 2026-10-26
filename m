Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D466606A321
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 01:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nlG6lF8b
Received: by kanga.kvack.org (Postfix)
	id 0DA936B05B0; Sun, 25 Oct 2026 21:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0648C6B05B1; Sun, 25 Oct 2026 21:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E3A6B05B2; Sun, 25 Oct 2026 21:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B87F06B05B0
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:03:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 10BD11404EF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:03:05 +0000 (UTC)
X-FDA: 85362978330.03.CA570EE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf08.hostedemail.com (Postfix) with ESMTP id 87746160006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:03:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nlG6lF8b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792976583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=6KypKBxeY4fKgDZu8C15CxK34EeYHCPZ3YrUNtMGVW8=;
	b=MpM94/tMutiGPWwRSD8XE7tXQyVE6sqdaOIZWrggBux5jyHKaVBsnOkvFPzxhkSm0gXzzx
	8OrVT4ldHmBollmqRJJxijI1IHbS5VllIaGhUnDdg60WDPudeeGNN8k5+pAaRbULkP4Bj+
	l9UjQqsGYbGmuC+n4AJ1nCKafq9X8WA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nlG6lF8b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf08.hostedemail.com: domain of yi1.lai@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=yi1.lai@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792976583;
	b=HpJtOC7mKeMiD8rvPIX0z4YcRQieR3J8hBQmL2X1QcdbGo26qcZfnssZv/aVrMCu+jL/Ha
	p6ITbjZgRSQTiXyScir4j7X3RC86/gOZENTa1sJnNeWJXQMP6MJVs3Vwscwd8HqjqjJbGs
	66Wlez3PkNKxoOgrQ8Ghbb3coWFX9Sw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792976583; x=1824512583;
  h=date:from:to:cc:subject:message-id:mime-version:
   in-reply-to;
  bh=MyV6KNfTsD6WaTa9di42yb310veedcMZyi1bBjCc+mg=;
  b=nlG6lF8b3lHKmdRTTqVxBppdhrM5sLAwlVEbpjB+IjxciwVVDmEMsCgF
   vlRTKBCRWSFDfAq0o2ysaBCZqdk1+5HJ2wEA5IkUM8egVu2MyJdL4Ppjy
   6zoyEFsMljXdT3NcAvQ9tCk9JikAvseRQpfqrSX37+DHOcgO0yYBq/y6w
   kr4em2hLL77DyhibHREvG2aA+hDiq8GLuwOHr7CkyB+zj30C0277uClqW
   Ckhhru+c0YyH3Njex2664JHcXcHIu6L7lYhJFs3mQg3ndLBL1gqD6gcM1
   HIGg6vLjSbu4nsGf9ht5G2PXihKopvFvDrZNb3BgBX6fCOR5EjvA04M41
   w==;
X-CSE-ConnectionGUID: NeO0jZsKRj+vwZ2vATr+fA==
X-CSE-MsgGUID: J7IapEGBQ4GoK5S/n5KMrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11946"; a="1625042"
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="1625042"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 18:03:01 -0700
X-CSE-ConnectionGUID: B+/zTdA0Sf+1LPmPJaauPQ==
X-CSE-MsgGUID: BumxbCY3S/q3LJG0eBKPMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,178,1787036400"; 
   d="scan'208";a="4017743"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.64])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2026 18:02:57 -0700
Date: Mon, 26 Oct 2026 09:02:54 +0800
From: kernel test robot <yi1.lai@intel.com>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>,
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, "Harry Yoo (Meta)" <harry@kernel.org>,
	yi1.lai@intel.com
Subject: Re: [PATCH slab/for-next 14/14] mm/slab: do not set SLAB_MAY_ACCOUNT
 for all caches
Message-ID: <202610260827.e64ec9d3-lkp@intel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-14-096800aa3330@kernel.org>
X-Rspamd-Queue-Id: 87746160006
X-Rspam-User: 
X-Stat-Signature: a3qf67tk1fxaua1i7citmmqsdwaof53s
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792976582-482223
X-HE-Meta: U2FsdGVkX19Qy2k/kH8QyXqrMbnotSdZxUjQK2gRsOQ7VZZ6+LALNeb7FonxEQtNmaLpQH1LgXgpKpf+tgQbvJyHq7XtVP/QPQqwgBorcF5nHbRDs3SkIzRcvdZirPqgGFSo7urTxJcYrTqFNT4CKDRUSLJvgSL8TZai8pozlLZhozPu3+bYk44NK29AI3vR7COQfHKKurfWeBXt6HTqchO7qWvR2HYjcFOgvE+qysSKqL25ioOL0KchsOeY3/0WNsbMBSDPILvK80jAnoBuzkodZIylFXywx39/ZbLgiDrJ+LAyGvxCDp+b+4jvZy6JQcjb6uLcttZNmesfeByJXJfEuxvcwMlAuf24DH+6EZyAf0JTm7ZtiOdoSvMOTO2f9O86Nvmt7Sb6XtdMDCSbRALVcfNwXyLsm3m8MKIo7CHN9UYI9vNZSEWOc8kwidCQmL+Ax3wGxV0j/PgHG3SVW4a4qtT4G6qUisFEzIOhPacCe2rfBfGCqmPt+N1UeMDQd4dy5tLEuGpVaiuk9zswLVLYJETHAV01O7K4B6t7pDxqLJvSvr4hPsA5hiCDwIm/K0SXGbs0PpfkWHSPkIM8cp44M5EyIFGDattkJXzkLy+VDWBB4kznHmmQBRSXl0IW15ngKqzF/ABOxU0btd2yx0b3qdA2qKacfXBpKu0PS3k7WPFgqE6Yre4jCbVyvgaSZG6t5RKRZuo2aOvjLS3gS7xizBrjaoVwndaOgqvILC78CkgdKybxmRqc/np4JlIuJ3qpbnD1GRRMCK6hC8zzEpKjov894e8muEg5Zy9AXBtDu3RvZHi7x9T5rL9FIb2pOQ2bpOvlPa0BRwLuVvdoD3pU+TYu3BsKyBu5lDsBPh0gaHsKYJpOL28qCSH3cSYDz0/vI+enuLJe/WHnhxvwCFLA6UtGtC0nkKRBDj+a+D5pep07XKnaU4h2daF7GVWHVuj8cfr/jrGCGXiAdEt
 Ypfga34u
 z6r0DHfBsRN5T+6nQaNeEuLtZ1i+pDCmXmI7gSp9wVgndZzVGGaKeBS9YuBH6npjKYzEaxEZ0dKobrmiVIk8FM6Cg8WFBrtEeRRs2UfnOYx93t8uPxqCRVTVnoq7e3t7/DPYrIK3/qd4QpZWrj02tVugIMPObXhaIm9ND4+oEu9os+76EI51PD3OvaUM8TH5zg6qbhiNtFu+2cFXUrBTrGER7IPE9Vwn17WmMf/KsqMYGMiHVNG2S3qfBlldQsQIW2oItzQSSkxdbMu7peZkIYYoX6VIKPmbuBeJKSz07ysFj3xtXEqn1HIVWDETAshZyJlJcplfwXSBcX/pOcmSQTdX/VEpc1zO23ytu/vJrHxIXcBKfWmhllPbfbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


Hello,

kernel test robot noticed "sysfs:cannot_create_duplicate_filename" on:

commit: 74db9d3510fc1c12bbe4e56d0f034a734dd69d2e ("[PATCH slab/for-next 14/14] mm/slab: do not set SLAB_MAY_ACCOUNT for all caches")
url: https://github.com/intel-lab-lkp/linux/commits/Harry-Yoo-Meta/mm-slab-allow-passing-SLAB_MAY_ACCOUNT-to-kmem_cache_create/20261021-124642
patch link: https://lore.kernel.org/all/20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-14-096800aa3330@kernel.org/
patch subject: [PATCH slab/for-next 14/14] mm/slab: do not set SLAB_MAY_ACCOUNT for all caches

in testcase: trinity
version: trinity-x86_64-d4c26f234-1_20261018
with following parameters:

	runtime: 600s


config: x86_64-kexec
compiler: clang-22
test machine: qemu-system-x86_64 -enable-kvm -cpu IvyBridge,enforce -smp 4 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <yi1.lai@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202610260827.e64ec9d3-lkp@intel.com


[    2.984089][    T1] sched_clock: Marking stable (2784008153, 199498551)->(3129505678, -145998974)
[    3.004962][    T1] registered taskstats version 1
[    3.007428][    T1] Loading compiled-in X.509 certificates
[    3.017205][    T1] sysfs: cannot create duplicate filename '/kernel/slab/:a-0000256'
[    3.021027][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.3.0-rc1-00024-g74db9d3510fc #1 PREEMPTLAZY
[    3.021034][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    3.021036][    T1] Call Trace:
[    3.021055][    T1]  <TASK>
[    3.021059][    T1]  dump_stack_lvl+0x43/0x70
[    3.021066][    T1]  sysfs_warn_dup+0x5b/0x70
[    3.021072][    T1]  sysfs_create_dir_ns+0xae/0x130
[    3.021077][    T1]  kobject_add_internal+0xb2/0x230
[    3.021081][    T1]  kobject_init_and_add+0x81/0xb0
[    3.021088][    T1]  sysfs_slab_add+0x7d/0x1b0
[    3.021092][    T1]  slab_late_init+0x79/0xb0
[    3.021098][    T1]  ? __pfx_slab_late_init+0x10/0x10
[    3.021101][    T1]  do_one_initcall+0xef/0x330
[    3.021106][    T1]  ? __alloc_frozen_pages_noprof+0x145/0x2f0
[    3.021111][    T1]  ? alloc_from_new_slab+0x1b2/0x270
[    3.021115][    T1]  ? refill_objects+0x2cb/0x330
[    3.021118][    T1]  ? irqentry_exit+0x89/0x5f0
[    3.021124][    T1]  ? asm_sysvec_apic_timer_interrupt+0x1a/0x20
[    3.021128][    T1]  ? __pfx_ignore_unknown_bootoption+0x10/0x10
[    3.021135][    T1]  ? strlen+0x10/0x30
[    3.021140][    T1]  ? parameq+0x17/0x70
[    3.021146][    T1]  ? __pfx_ignore_unknown_bootoption+0x10/0x10
[    3.021150][    T1]  ? parse_args+0x117/0x2b0
[    3.021154][    T1]  do_initcall_level+0x7c/0xf0
[    3.021159][    T1]  do_initcalls+0x59/0xb0
[    3.021164][    T1]  kernel_init_freeable+0xd2/0x170
[    3.021168][    T1]  ? __pfx_kernel_init+0x10/0x10
[    3.021172][    T1]  kernel_init+0x1f/0x130
[    3.021176][    T1]  ret_from_fork+0xe0/0x1f0
[    3.021180][    T1]  ? __pfx_kernel_init+0x10/0x10
[    3.021184][    T1]  ret_from_fork_asm+0x1a/0x30
[    3.021188][    T1]  </TASK>
[    3.021192][    T1] kobject: kobject_add_internal failed for :a-0000256 with -EEXIST, don't try to register things with the same name in the same directory.


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20261026/202610260827.e64ec9d3-lkp@intel.com



--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki



