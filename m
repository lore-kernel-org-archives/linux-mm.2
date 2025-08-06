Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01445C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D69A6B0096; Wed,  6 Aug 2025 16:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6874A6B009A; Wed,  6 Aug 2025 16:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4096B009B; Wed,  6 Aug 2025 16:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE3C6B0096
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:52:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D37005AC8D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:52:31 +0000 (UTC)
X-FDA: 83747530902.28.35054A4
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6DCAD20002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:52:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AhUmMUVr;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754513549; a=rsa-sha256;
	cv=none;
	b=7oub/lsJc/6vTj4afzH05Enh+49nBtI3+eP9qbcP2KuTWDoBgGYiZLAZkiMOq6ssWDScq+
	qZfpb3s4AxJFI68kwCyfapsHq5t6hlh/H/R+7yixOYeKpxYPC4Dz+PHVKHQJqZ/e9Mpe8Q
	vc7Y0nIYLrjTApAjkK0czzGpJZzuLxQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AhUmMUVr;
	spf=pass (imf13.hostedemail.com: domain of lkp@intel.com designates 198.175.65.11 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754513549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JQyoh+gzaCKzn09oqqu1R7nxKQ1TsNNozTytmOsYr0=;
	b=BC95n05qcezPgnlTGNrOJCOduEkMlqF4SQHvULFH+q4bhkH2zumhMoorNBcs100ZqvlaXE
	D7aRzCGpdxwrqejK75Kx7S19X1/OT1HyU0AwFtg4hCx5hRBdpM2g5ttjPZY7jbi+ot0QU6
	OBe1V23mi3fDxvE7sarNAANJgCobYJk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754513550; x=1786049550;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=QmvpDt2PS2p7demErPhAY+ZhnKGpcjx2LhJW1JzrWGc=;
  b=AhUmMUVrNc0B24oxareVVAf/OQy0t03taWYyrVeLyw+hmSE/IPvWUXoc
   yKPZxcNiCZfwAxIO/cA58Q2pQ5CARGYd+qcJdKlxY6R/tZr0HR+iXu5Rb
   PAOmeRb85jH9kgCKmMdxL+Z700/xEi6QtltEtbefQZXnMVRTZDx5f8LZH
   ECOvWy+Ern21rlSdGALLOyreyUfOJDoB2dZSnDzwz8Did+2XErfRueqSM
   JptmXmWWzNeClzOrr8rYx6Eo6qiI6J/18pOIIkc3hssYzzYBIl6LPxslx
   wm4TcPBGxRn3z86UBlqviW/lb6A3D+gBRkOxpSA5i6l93CBMFWzIE1/XM
   A==;
X-CSE-ConnectionGUID: M77RGt1cTXaj9NbzD9q+TQ==
X-CSE-MsgGUID: SN4Lff6iTuyScIpwNpp6iw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67108561"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="67108561"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 13:52:28 -0700
X-CSE-ConnectionGUID: +2xhNmFsRnGZfDnhagyifw==
X-CSE-MsgGUID: ITvLCpOyQFqptZuo1Oorhw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="169045376"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 06 Aug 2025 13:52:26 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujl7T-00025u-22;
	Wed, 06 Aug 2025 20:52:20 +0000
Date: Thu, 7 Aug 2025 04:51:25 +0800
From: kernel test robot <lkp@intel.com>
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	shakeel.butt@linux.dev, hch@infradead.org, wqu@suse.com
Subject: Re: [PATCH 3/3] mm: add vmstat for cgroup uncharged pages
Message-ID: <202508070450.bjCshoYI-lkp@intel.com>
References: <eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris@bur.io>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6DCAD20002
X-Stat-Signature: 9u9wnsi54edh5dyfjadqsbauxrdyzf9f
X-HE-Tag: 1754513549-378174
X-HE-Meta: U2FsdGVkX1+onpeEpO7sEoTO14fN6JFGe2DoNagj/CWF+XuGC9coZGhgLUl93w9y8brNmZrBstWgHAcQ7s5DFxmDEITDz0mX0nsFvYw2GDdipN9SFImGfngKNTBc91frfgu3+MfLEqHqtCNHazLmSuKOBi+MdPniW4vEyph3rMnvyMmWyhfJ0MUrrFHhYU2QDI1EeHqBu0VXkwtCELuft9R8xPTxPvwHnfhpZq5fxazsREwbJuGVlZP4iX2tnpOWty9WtloT9/6GIfvqC4Ul02EAJGKS3hXz+YS6WKgzFeNcdwDTg2k6maFBdEjNusUkpVBwmZVDwoHFAd0yCG4XCIr/sho+AqqaIY6htEtnFkqTqtF9G02XwjeMTEvHxuBHJWVrCfTsYPY3eauULgoENH/Zk67CjV8BzKDWPWdEv8AQTMRCrtm0rpm1Nfsdqk2IV0Vodq0xP0jPmhl/nQ/C4TtApDFhWk36fzC4F6LL0va8LqAzYMRe84JZkD2bA2vrUqdQYRLRh4LxuRu/ogjnKBWtbfxjZOSbHaxujP2GGf6hpIciKviVaSIsXLk9fFOB/gqVBSf1M91uBMzbQUjhucJTy4DzDJ2gXUaUtP0O1tX0qV90DXKyIH8tfWuEB0Y/bEBcYOWank3CDMDcDSAdVRd9Up79IfTIpLVnvbKUJ+tjWDVTVimlBkimQBrELUB0vj/TATif3hHt3QFp3QI4z6kB7PpGxV+9Px67z5SL2vf3+DUPZQ4GriQXU8mtQFdDYah0PHbrI6sXTsAc06KGdkloCUTFJI7bV7h6tzNrR/W3/eaNjgd00ZdPSJd9Vt4nLwJkD3oC2r9kbdvbzLwrofO56MK/eSmleSupZJEW5b7M2vatlokBzmi8aFoeH7zQ8yrvGRLAAjW34jSUiLxxONKjtqkiwoghdHcJfWLaYDkU9DKo2nowrWcHWss6LlbeNDlhM9J6SRq44PDOceU
 DVJ0+8IB
 aYInx5k5t7RpoGMuQXm1lKerYNTlknMcQ6R/eMcYCfbPuzT/K6WwuSjYkC13H5koW16y77DqVHlEuY/FwaYELCAB1vpEN9dwIS5BD7eGLd1BjyyD/NnB/O7i5iWKn3eGqZBrjwflS8zfj4hR2iwGi2Mvb4f/tK92AzYgHYY+t05GgI1sIF10f2Vr8TuxVCRISIw6zDcpIO+YtlaApRN3feUpk4ZZKjpbFynWEp/nuoS+yCERRHSmjRMHkH+U2rgK6+ubDl0AF950cWz/vyH6e9zO7VYuJpbDEok5HwnuUbI6sslJplNkN9waQfZqkQ3WdHmcBjUbXbLgKwdP3R5UNpRGexosCdgpCxqtj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

kernel test robot noticed the following build errors:

[auto build test ERROR on kdave/for-next]
[also build test ERROR on v6.16]
[cannot apply to akpm-mm/mm-everything linus/master next-20250806]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/mm-filemap-add-filemap_add_folio_nocharge/20250806-130147
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris%40bur.io
patch subject: [PATCH 3/3] mm: add vmstat for cgroup uncharged pages
config: i386-buildonly-randconfig-002-20250807 (https://download.01.org/0day-ci/archive/20250807/202508070450.bjCshoYI-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508070450.bjCshoYI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508070450.bjCshoYI-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/filemap.c:209:2: error: call to undeclared function 'filemap_mod_uncharged_vmstat'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     209 |         filemap_mod_uncharged_vmstat(folio, -1);
         |         ^
   mm/filemap.c:209:2: note: did you mean 'filemap_mod_uncharged_cgroup_vmstat'?
   mm/filemap.c:158:13: note: 'filemap_mod_uncharged_cgroup_vmstat' declared here
     158 | static void filemap_mod_uncharged_cgroup_vmstat(struct folio *folio, int sign)
         |             ^
   mm/filemap.c:998:3: error: call to undeclared function 'filemap_mod_uncharged_vmstat'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     998 |                 filemap_mod_uncharged_vmstat(folio, 1);
         |                 ^
   2 errors generated.


vim +/filemap_mod_uncharged_vmstat +209 mm/filemap.c

   163	
   164	
   165	static void filemap_unaccount_folio(struct address_space *mapping,
   166			struct folio *folio)
   167	{
   168		long nr;
   169	
   170		VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
   171		if (!IS_ENABLED(CONFIG_DEBUG_VM) && unlikely(folio_mapped(folio))) {
   172			pr_alert("BUG: Bad page cache in process %s  pfn:%05lx\n",
   173				 current->comm, folio_pfn(folio));
   174			dump_page(&folio->page, "still mapped when deleted");
   175			dump_stack();
   176			add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
   177	
   178			if (mapping_exiting(mapping) && !folio_test_large(folio)) {
   179				int mapcount = folio_mapcount(folio);
   180	
   181				if (folio_ref_count(folio) >= mapcount + 2) {
   182					/*
   183					 * All vmas have already been torn down, so it's
   184					 * a good bet that actually the page is unmapped
   185					 * and we'd rather not leak it: if we're wrong,
   186					 * another bad page check should catch it later.
   187					 */
   188					atomic_set(&folio->_mapcount, -1);
   189					folio_ref_sub(folio, mapcount);
   190				}
   191			}
   192		}
   193	
   194		/* hugetlb folios do not participate in page cache accounting. */
   195		if (folio_test_hugetlb(folio))
   196			return;
   197	
   198		nr = folio_nr_pages(folio);
   199	
   200		__lruvec_stat_mod_folio(folio, NR_FILE_PAGES, -nr);
   201		if (folio_test_swapbacked(folio)) {
   202			__lruvec_stat_mod_folio(folio, NR_SHMEM, -nr);
   203			if (folio_test_pmd_mappable(folio))
   204				__lruvec_stat_mod_folio(folio, NR_SHMEM_THPS, -nr);
   205		} else if (folio_test_pmd_mappable(folio)) {
   206			__lruvec_stat_mod_folio(folio, NR_FILE_THPS, -nr);
   207			filemap_nr_thps_dec(mapping);
   208		}
 > 209		filemap_mod_uncharged_vmstat(folio, -1);
   210	
   211		/*
   212		 * At this point folio must be either written or cleaned by
   213		 * truncate.  Dirty folio here signals a bug and loss of
   214		 * unwritten data - on ordinary filesystems.
   215		 *
   216		 * But it's harmless on in-memory filesystems like tmpfs; and can
   217		 * occur when a driver which did get_user_pages() sets page dirty
   218		 * before putting it, while the inode is being finally evicted.
   219		 *
   220		 * Below fixes dirty accounting after removing the folio entirely
   221		 * but leaves the dirty flag set: it has no effect for truncated
   222		 * folio and anyway will be cleared before returning folio to
   223		 * buddy allocator.
   224		 */
   225		if (WARN_ON_ONCE(folio_test_dirty(folio) &&
   226				 mapping_can_writeback(mapping)))
   227			folio_account_cleaned(folio, inode_to_wb(mapping->host));
   228	}
   229	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

