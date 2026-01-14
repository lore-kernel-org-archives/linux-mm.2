Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6047D39003
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 18:05:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351F66B0088; Wed, 14 Jan 2026 13:05:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB906B0089; Wed, 14 Jan 2026 13:05:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB0E6B008A; Wed, 14 Jan 2026 13:05:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5E16B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:05:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBD5259810
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:05:18 +0000 (UTC)
X-FDA: 84331346316.20.F7DE4EA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDE434000A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 18:05:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R2xXD641;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+M0+6AFaSVTi31FqR6M6pU4s1ldRTCXncxC/hdvcpjo=;
	b=qyj8dDjGzvWwlnWAQ1HMy6YPTWdx2XOYhOddnAVRSVLJ9bZHFxyGUEuQd6+HdKkqTu8PST
	iJFqFQ9xo3YEIcIX3E2elps/8GWlODZt/aQ07Pp5WPgyHa7tzZXWc0N5HkIjgFaHef6BnW
	M65BrCy3XaXYFsQN1J3jat9oChuxtJw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=R2xXD641;
	spf=pass (imf11.hostedemail.com: domain of lkp@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768413916; a=rsa-sha256;
	cv=none;
	b=20ES6SCoUvy7KPQcvfLFIZ7Ng16LLFYoN2ZAwP6dlC4KIS+IgOf4Zy6gv/DHTrnC9TUnM9
	CexqfJoBSZnT7Skrp4SwBmM2+nIuBq20Tq98crxkZ67kqQTFDhRK+OZB3lEWqBzYb+KNnn
	f8/dj+5I5kyfPTNQcH2w81diGkt6ctM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768413916; x=1799949916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LlaGqzTDfng3Tgg+O+lRqxSp3VAlDdxXFdUmlzpIn5k=;
  b=R2xXD641Q/NXFgDRw2W35fWnNcgcbzFBjlvrQJ5697W9VlcLFGjWFSjk
   b4I2V46mMCCTzJ7fixX0Gj1yfe5ZqOUKjUlAODlSwhoA3Z43+ne5z4BtI
   6Tya1hCZW/2W6ikm5oU2WEuM3lj4CNPqsPZXEuWI08WT3wu5kBm07JNXA
   5jk6C9TzV8N9qlXUxmD0iDHMJPaOegNA0PyUZ2yAU5uHKTz9D3IxZxgJY
   TBZqXti4AAZSDwZPcoP7WLEqO+CSuB8KnNRTXm7sopBrDBI91Klj6vTmq
   Z1fPFZNcQq88jgn9K/3H9X8sx9UXwv9Oe7vLQcFknTOSY7J4+i5AL5z4c
   g==;
X-CSE-ConnectionGUID: ibRpYrS4R+eLlMfx9JrQ0Q==
X-CSE-MsgGUID: cPFpEdjTRVadxbvmBkhLjA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="69772255"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="69772255"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 10:05:14 -0800
X-CSE-ConnectionGUID: U60Y1ubTQWmjnHP9IXP1sA==
X-CSE-MsgGUID: 1ucytVeoR+WDdax7RARjhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="203959086"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 14 Jan 2026 10:05:09 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vg5Ew-00000000GnQ-3OSu;
	Wed, 14 Jan 2026 18:05:06 +0000
Date: Thu, 15 Jan 2026 02:04:18 +0800
From: kernel test robot <lkp@intel.com>
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202601150107.djcXDbUn-lkp@intel.com>
References: <20260114091923.3950465-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114091923.3950465-2-mpenttil@redhat.com>
X-Stat-Signature: 1on7m93hekyr6kn74mhnf1zhrz76cf8q
X-Rspamd-Queue-Id: DDE434000A
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768413915-704362
X-HE-Meta: U2FsdGVkX19C/X5KMQQGgoeo0/CQZ6y83BmmHyGbgOWXHpjubTkvWLv2j8SUAzEzVkyJTHQo/iiE8R5nqI3cV4b9dkPFdNq/ctkWxUXhpe1dZteKZ7rpGPRA8QzZaWJ5BE+1dnF3YspcBew2A6lkl7F9OQlXIgZlsPphL/nNTVvnVxr3JBRC+ZBI3DB9jBbSwhdBsnELoEjx5OToiscE+PgOr5Q/x4MpYJ0atgnnRZzGK4Nfj1Qiu95u4xBuYAIz3D2Lu10rL0SbAXzm/D+P847oBr0Xz4/87bTy3zSQ5TyHBjdclCo0i1WQkMrr7CUuxuTVybwF4ZwIm8UIdg/J62S5mbLWygkex68gKnGr10Exb/8HifEaaf7ADaEAAtfRqEciSs/MUl7mYoNyBsOZ+isRdttBF/tRtkcgEl4lWn1Qx3mpIRiJcV42GozQCvnpcHGiIi/1ums7lDietkKG/qjEyYXciQK4YRSb6G6juBgQ+pgLsAt8OKo8bwgb8nyJMlk1jCyRUY5zB+IpwnL6JOhkKp+eWc7LIyHl4P+IJ77hLl9Th07cvnnyj8+LAE54OBtbpCV7UVPPmd5uokvuff0h8S61oFttFyaz7IGrRwWVHab3irYK0Oa0gAkCaI29z+L7+XZ9H0x7PlaFshDo0VoAFeGHuWbnJNR7NIXHHgwpcE45VaD/HYMDhdQjByT6oVUuiOWAWpE//JhK1eSFfU9fyoqcNMsHW6P6kb15DoVtMsAEBaccYGVH4NsOCIFYIm3jPW2Vd8huw/pOv1wUYRyHXkT4CkNia1K/dFJ57Tvxu6kAPrZOzbqFWFolslHMe7ZzNvc8NGFEN5wP99huNZy8A4W0VgibtZy9xGhJPUGg/i9skQc/GL3HiRfw48OP/ka05+88aigHVM8GHklaUaQmadAy6nEv+kFYJ0e6mN3xDpBQT8xnFbNjVH6QexDj8GrWwVO8ye6q6oaLdvE
 eF43D6aT
 ozpzPSdnZDST+M3fHLnJdcxW0MGCywGUWc4sMV0lrwtaWVydgFlEutmIYDvPljQCKDYt809ahCxQPgTWVSQDc8OALHwrBa3kJt+7liNhaWP0erTqCElNWFr6bNHoeTSEMplmvRGuuc0022qBm+yHy+lC6Wpd7RLMoppLLiTV50rTKBRIf222OhKe5Ktc+M1m14wAtJT8TCBKTQ0EGQb8Fx5R7G3JzJ852tY+xjJA7vRYSFNE5i2NJAiXrgQ3iK9lB+8R3Hhu6XKOsqL8lKhkvS0q49Dika2UJsrDEm3oUsfKLUQ6bxzR9kZxx5sk2yc3y1bUHnHnqH8C7w0W2r/w6MzAqeIqHH3XNz/OSM2g5ZOhCbPyCjwZRe4ahJy5Y6X+RgPpl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-nonmm-unstable]
[also build test ERROR on linus/master v6.19-rc5 next-20260114]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260114-172232
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260114091923.3950465-2-mpenttil%40redhat.com
patch subject: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: hexagon-randconfig-r063-20260114 (https://download.01.org/0day-ci/archive/20260115/202601150107.djcXDbUn-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260115/202601150107.djcXDbUn-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601150107.djcXDbUn-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/hmm.c:49:30: error: incomplete result type 'enum migrate_vma_info' in function definition
      49 | static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
         |                              ^
   mm/hmm.c:49:13: note: forward declaration of 'enum migrate_vma_info'
      49 | static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
         |             ^
>> mm/hmm.c:51:24: error: variable has incomplete type 'enum migrate_vma_info'
      51 |         enum migrate_vma_info minfo;
         |                               ^
   mm/hmm.c:49:13: note: forward declaration of 'enum migrate_vma_info'
      49 | static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
         |             ^
>> mm/hmm.c:53:41: error: incomplete definition of type 'struct migrate_vma'
      53 |         minfo = range->migrate ? range->migrate->flags : 0;
         |                                  ~~~~~~~~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
>> mm/hmm.c:55:3: error: use of undeclared identifier 'MIGRATE_VMA_SELECT_SYSTEM'
      55 |                 MIGRATE_VMA_SELECT_SYSTEM : 0;
         |                 ^~~~~~~~~~~~~~~~~~~~~~~~~
   mm/hmm.c:65:24: error: variable has incomplete type 'enum migrate_vma_info'
      65 |         enum migrate_vma_info minfo;
         |                               ^
   mm/hmm.c:49:13: note: forward declaration of 'enum migrate_vma_info'
      49 | static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
         |             ^
>> mm/hmm.c:77:15: error: use of undeclared identifier 'MIGRATE_VMA_SELECT_COMPOUND'
      77 |             (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
         |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/hmm.c:423:20: warning: unused variable 'range' [-Wunused-variable]
     423 |         struct hmm_range *range = hmm_vma_walk->range;
         |                           ^~~~~
   mm/hmm.c:493:24: error: variable has incomplete type 'enum migrate_vma_info'
     493 |         enum migrate_vma_info minfo;
         |                               ^
   mm/hmm.c:49:13: note: forward declaration of 'enum migrate_vma_info'
      49 | static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
         |             ^
   mm/hmm.c:502:35: error: incomplete definition of type 'struct migrate_vma'
     502 |         fault_folio = (migrate && migrate->fault_page) ?
         |                                   ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   mm/hmm.c:503:21: error: incomplete definition of type 'struct migrate_vma'
     503 |                 page_folio(migrate->fault_page) : NULL;
         |                            ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   mm/hmm.c:503:21: error: incomplete definition of type 'struct migrate_vma'
     503 |                 page_folio(migrate->fault_page) : NULL;
         |                            ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   mm/hmm.c:503:21: error: incomplete definition of type 'struct migrate_vma'
     503 |                 page_folio(migrate->fault_page) : NULL;
         |                            ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   mm/hmm.c:512:17: error: use of undeclared identifier 'MIGRATE_VMA_SELECT_SYSTEM'
     512 |                 if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
         |                               ^~~~~~~~~~~~~~~~~~~~~~~~~
>> mm/hmm.c:529:17: error: use of undeclared identifier 'MIGRATE_VMA_SELECT_DEVICE_PRIVATE'
     529 |                 if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
         |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/hmm.c:531:37: error: incomplete definition of type 'struct migrate_vma'
     531 |                 if (folio->pgmap->owner != migrate->pgmap_owner)
         |                                            ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   mm/hmm.c:548:14: error: incomplete definition of type 'struct migrate_vma'
     548 |             (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
         |              ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   mm/hmm.c:548:24: error: use of undeclared identifier 'MIGRATE_VMA_SELECT_COMPOUND'
     548 |             (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
         |                               ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   mm/hmm.c:603:24: error: variable has incomplete type 'enum migrate_vma_info'
     603 |         enum migrate_vma_info minfo;
         |                               ^
   mm/hmm.c:49:13: note: forward declaration of 'enum migrate_vma_info'
      49 | static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
         |             ^
   mm/hmm.c:620:35: error: incomplete definition of type 'struct migrate_vma'
     620 |         fault_folio = (migrate && migrate->fault_page) ?
         |                                   ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   mm/hmm.c:621:21: error: incomplete definition of type 'struct migrate_vma'
     621 |                 page_folio(migrate->fault_page) : NULL;
         |                            ~~~~~~~^
   include/linux/hmm.h:15:8: note: forward declaration of 'struct migrate_vma'
      15 | struct migrate_vma;
         |        ^
   fatal error: too many errors emitted, stopping now [-ferror-limit=]
   1 warning and 20 errors generated.


vim +49 mm/hmm.c

    48	
  > 49	static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
    50	{
  > 51		enum migrate_vma_info minfo;
    52	
  > 53		minfo = range->migrate ? range->migrate->flags : 0;
    54		minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
  > 55			MIGRATE_VMA_SELECT_SYSTEM : 0;
    56	
    57		return minfo;
    58	}
    59	
    60	static int hmm_pfns_fill(unsigned long addr, unsigned long end,
    61				 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
    62	{
    63		struct hmm_range *range = hmm_vma_walk->range;
    64		unsigned long i = (addr - range->start) >> PAGE_SHIFT;
    65		enum migrate_vma_info minfo;
    66		bool migrate = false;
    67	
    68		minfo = hmm_select_migrate(range);
    69		if (cpu_flags != HMM_PFN_ERROR) {
    70			if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
    71				cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
    72				migrate = true;
    73			}
    74		}
    75	
    76		if (migrate && thp_migration_supported() &&
  > 77		    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
    78		    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
    79		    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
    80			range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
    81			range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
    82			addr += PAGE_SIZE;
    83			i++;
    84			cpu_flags = 0;
    85		}
    86	
    87		for (; addr < end; addr += PAGE_SIZE, i++) {
    88			range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
    89			range->hmm_pfns[i] |= cpu_flags;
    90		}
    91	
    92		return 0;
    93	}
    94	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

