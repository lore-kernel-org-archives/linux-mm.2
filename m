Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31AD4C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 20:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC6926B009B; Wed,  6 Aug 2025 16:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9E336B009D; Wed,  6 Aug 2025 16:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4326B009E; Wed,  6 Aug 2025 16:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD9D6B009B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 16:41:13 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 103861606D8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:41:13 +0000 (UTC)
X-FDA: 83747502426.19.2C9C5EC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 35C0320014
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 20:41:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mLXTkAnH;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754512871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g5XLFlH3i2PUkvkEW/UIqda26Lu3w4ZUHFRV+qMAjyQ=;
	b=A3lxsnjmrK96pTx1S6GKStANj62v9lTUKEZ+32V6x7V5bst+u7RQyASZCr+eic3rKa6Ic0
	fU/gJcyA5uGu8HiQ9b5rSqzEZRR/v2hRKHDKKGyY1oNlW6raM48XRw0UMdWdVvvaXusjk4
	g/rbSG8F5SzdtiYQiIdXHVpuSVxb8sk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754512871; a=rsa-sha256;
	cv=none;
	b=WhOChtEuGUCYlyLbbqacT1u/2hfL678ujbXSHB0EkD84+S/tQL6Fd1kjMIlRhvpxF/cT5W
	EF1NZKgM3REKUUB8yS2iEG1jpUfEdvXMoKaUhmjq+thN2kEW6R67zSWQZc/gKnskwVKSB3
	Lhws8n1SVZoaTjy/jXILonf471xkric=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=mLXTkAnH;
	spf=pass (imf03.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754512870; x=1786048870;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+Kj3Cp8LPwva2q9gWj1Lp/dXKJzRTOeU9qOHIURBHpg=;
  b=mLXTkAnHF0HS9NNz625X/fVq2onFipB/THXKoImZs54sgDYzqEswBuNu
   njrVygT/sBBg86P5Y2RyUg/ddhmfqV9fACjkyu7j1OC67NNey3+Yop66b
   f9C1AeFXH3e78G/BCYJT7qW5p8eIo+WOKB8QKi/PSB2CKePoRegJRcTKw
   LpHsYvVt8KxYvFy1XTX4mSuaynaBlHlA1/E51wgQeh3H0OAWiwiBK5VS6
   PFI8fUmwUl9C8S3WbGW/QZ1y3MIXdW+htJh2eP5mmwHTRHVHTKBJwJA+S
   MdJpgol9yZEAsIQ8XfkHJX1pH2Xmxnluhuxey+8dHWznxCvf++wFwGLjo
   A==;
X-CSE-ConnectionGUID: wDVUNuu2ROi+jiHufwKEIA==
X-CSE-MsgGUID: vSGSjTVAQh2NAMMz2yLW1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68292948"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68292948"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 13:41:09 -0700
X-CSE-ConnectionGUID: 4UCBIf49RfezSkorl0A6/A==
X-CSE-MsgGUID: b09J71hZS5icy2vQddJOYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="170139148"
Received: from lkp-server02.sh.intel.com (HELO 4ea60e6ab079) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 06 Aug 2025 13:41:06 -0700
Received: from kbuild by 4ea60e6ab079 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ujkwR-00024s-04;
	Wed, 06 Aug 2025 20:41:02 +0000
Date: Thu, 7 Aug 2025 04:40:16 +0800
From: kernel test robot <lkp@intel.com>
To: Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	kernel-team@fb.com
Cc: oe-kbuild-all@lists.linux.dev, shakeel.butt@linux.dev,
	hch@infradead.org, wqu@suse.com
Subject: Re: [PATCH 3/3] mm: add vmstat for cgroup uncharged pages
Message-ID: <202508070434.6EpRsRF3-lkp@intel.com>
References: <eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris@bur.io>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 35C0320014
X-Stat-Signature: psob4qdei81i7eqs99im9gcftf9rsknr
X-Rspam-User: 
X-HE-Tag: 1754512870-108322
X-HE-Meta: U2FsdGVkX18wqibZjCFKZ9I+M1deVDbiXnNNed/H2gWZX5qjMfBcLvo/uJbExAEeNur/aBpiqufONa2OdepBlojlk4jroO8ArA0cKg8nZD3xBfred0jVtqcQml1uDr92gq10Xzqb4lSl76eXpS0xEf/z0EhA18AKJYyA68vnRYQtYHXOtfEFf0NRCtY9Un41HaJLefrAc+FW6k2f38cWs7iINEbOW8UYEtYajtgDZ7yjVnDbo82A3GZBG7qz2//8CvHxUrsWod13Vl9mUWtVh8blYwZ3URXTCkDxMmrir5ifLmb1OXwXXxZbnsJEwwKKv/Kp5KLauRapXYEe/utUJsXy4MXqbbud+h6MDuWQAMLP8BoANvqT/QPPnBonIRkc6OSNJfl07rzEfcjuXvLMsDvGB3Z97uE7cO/qzxwq03yXsbuYhGIVI2132ktS2fMtVN4Ooi9KliWMYG0RgATZxw9ZwWUy9ByM7W+tCe2cg3cJloIuSlIkRnKTAlSvGWdbfC0xYGxmIwHzYxZpXq2v3rl/ptgoK7051FelsDjQmZj8FTz4Jv/p9Epq4aBehOzaxiDHXyGvI25L6aqFU22XyL1GbKoZV6HxidlWRP0a1pSOW89aORF7xCoSbDZBVnRBogu9IqJLf3KN7rCX8TncWm28HjMYQmlAFeB2KDCHqSLXX9v0qfrUtCL5QVsrPJMtIKboecqF1R884JNxrxFd6CWrf1P/8xkOt7tbcb1U2F/ABg5kqAzYE9lOQ3IGm4pi1vbF3ur685aJudLp1HLrvI5HufVFtr7VOtFs3+mljXXx892DpFSHkoii7y/WVOOgtXypUtBrep9JjDxcTAa4tR6S6IteqaP0W7trRZzI0pYrFLQPqrtQW8DcLtM8FKYafiVoy1d2C+9Ugc+Af3TI0YbjD+cU0doNzb+vWjH5EvrHhQaP/G3cn5pen0lyuWaVZWMUjpN4cmXI8xK2u5m
 4zhGRFRZ
 yazipZgNMPP95YS5Yg5h4SqPxh5vNF3Pb5ejE4chE1VhTqCCy9PGhbtcBxlqOHMREWGkVxCEnGtWxIhfBzJqXsRwhNyBytTceBG6GIa73cooe3nqTen/RCNJOt+wFulSkD/hyirtCXCiau78S9MoZBosdz8KJNIbw2YmSYUCyvfXv5LoIpV6Op7pksYWbI2qxSm0FDxhsEb2THBydOYS6TRdf023neKgSpi5Xkve97vBN1IqkFp4301UTG+xRW3O/5ccBqpqb5/VurHIEqdiGMiAKSpp9Sd/pr7fCUvdpT9xdQdrZ0XIzdW+9xo5Hnpmflf2KGvr5i7On8a6g8ETz1TloLbPHPbT14sxm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kdave/for-next]
[also build test WARNING on v6.16]
[cannot apply to akpm-mm/mm-everything linus/master next-20250806]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Boris-Burkov/mm-filemap-add-filemap_add_folio_nocharge/20250806-130147
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git for-next
patch link:    https://lore.kernel.org/r/eae30d630ba07de8966d09a3e1700f53715980c2.1754438418.git.boris%40bur.io
patch subject: [PATCH 3/3] mm: add vmstat for cgroup uncharged pages
config: i386-buildonly-randconfig-003-20250807 (https://download.01.org/0day-ci/archive/20250807/202508070434.6EpRsRF3-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250807/202508070434.6EpRsRF3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202508070434.6EpRsRF3-lkp@intel.com/

All warnings (new ones prefixed by >>):

   mm/filemap.c: In function 'filemap_unaccount_folio':
   mm/filemap.c:209:9: error: implicit declaration of function 'filemap_mod_uncharged_vmstat'; did you mean 'filemap_mod_uncharged_cgroup_vmstat'? [-Werror=implicit-function-declaration]
     209 |         filemap_mod_uncharged_vmstat(folio, -1);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |         filemap_mod_uncharged_cgroup_vmstat
   mm/filemap.c: At top level:
>> mm/filemap.c:158:13: warning: 'filemap_mod_uncharged_cgroup_vmstat' defined but not used [-Wunused-function]
     158 | static void filemap_mod_uncharged_cgroup_vmstat(struct folio *folio, int sign)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


vim +/filemap_mod_uncharged_cgroup_vmstat +158 mm/filemap.c

   148	
   149	#ifdef CONFIG_MEMCG
   150	static void filemap_mod_uncharged_vmstat(struct folio *folio, int sign)
   151	{
   152		long nr = folio_nr_pages(folio) * sign;
   153	
   154		if (!folio_memcg(folio))
   155			__lruvec_stat_mod_folio(folio, NR_UNCHARGED_FILE_PAGES, nr);
   156	}
   157	#else
 > 158	static void filemap_mod_uncharged_cgroup_vmstat(struct folio *folio, int sign)
   159	{
   160		return;
   161	}
   162	#endif
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

