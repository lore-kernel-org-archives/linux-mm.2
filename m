Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2A8AD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DEE6B00F2; Thu, 15 Jan 2026 15:41:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A9A6B00F3; Thu, 15 Jan 2026 15:41:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12C46B00F6; Thu, 15 Jan 2026 15:41:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFF306B00F2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:41:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 574E51AE5C7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:41:21 +0000 (UTC)
X-FDA: 84335368362.21.63C5F04
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6EE63A0003
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:41:18 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q0rWg290;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768509679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rSbs3tIN9RIRUbD6en7ripUE1slfRw7tIgIYr+GUGfo=;
	b=tKbIfuz9esona/Bm/3MLqPD6faAnQ5VD4/tPnp6VMppyUWiRwflAPCRy42rKJ21BSPSub0
	EtAQELkHmkJYjni2AgKg9hM4WYJsVBv7J9urd+lHYh2v1I+DQiguciat9brYbZoeL7nH59
	TYDDHJVZ6YyAnT/DVmETSTdhO3t98ho=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Q0rWg290;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768509679; a=rsa-sha256;
	cv=none;
	b=ZoFoQKKvdNUSw1PS3xem6RLgCZgnvmG7sE+2YUNQwBuL/HAxoHqYfSor56YOm9QPZS6H7r
	yYUOgGEoXFBalB0paSTFXg1FEZTDL5PcGvJr5/9cjttthbDbHxEXDu1vH9DIX/shDMswLh
	4llyTd0bLGGZrON4v+jgxPvqzomfnMI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768509679; x=1800045679;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AAjwkul+XjVVsm2ipADZ7cB6HXLG1gI1pZUSXZJTApc=;
  b=Q0rWg290gvcixqGBefsQDvOiZBaEmBzWdrpPSwiADGF3wHzjDur9qCuv
   vxHTMrK03bdPdCEzKK/7C//PmuV35oG5gU5JN5a827ZliqPWlK2t76x5T
   MdhQPpb1LPdcMbbrodlJVz8iLItvmFkvlLSjonSQgzD+enfruDn969L1t
   S5uxKCE785BJJsq7Lxyc8/mgg/ySscdHN+DkKFwmEmtmvtzyiLfPqqANk
   zHfilSJtL+5DO/FfNzX336eRyCnKHsZyDdFsoNcoeyax0T8TzhVvovWje
   bFSHeDHItqTTkcVJkAZrn2XKGe8Yo/FOvo/c2WFwS4NFzpouVBC9A0XxC
   g==;
X-CSE-ConnectionGUID: mmarnHq3QkiAfV31DFQhZA==
X-CSE-MsgGUID: G61QpCttQ8q7M3eLlnPPTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="73455736"
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="73455736"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 12:41:17 -0800
X-CSE-ConnectionGUID: jGw9OzYiSK2TZFYmUyjybQ==
X-CSE-MsgGUID: XzuZS3BhT/Gh0C4MIEzcFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,229,1763452800"; 
   d="scan'208";a="204840804"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 15 Jan 2026 12:41:14 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vgU9X-00000000Jy0-2X14;
	Thu, 15 Jan 2026 20:41:11 +0000
Date: Fri, 16 Jan 2026 04:40:21 +0800
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
Message-ID: <202601160405.2XZZtwqw-lkp@intel.com>
References: <20260114091923.3950465-2-mpenttil@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114091923.3950465-2-mpenttil@redhat.com>
X-Rspamd-Queue-Id: 6EE63A0003
X-Stat-Signature: iih6prz4irgrmxnimxmdmu37584rfncg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768509678-827016
X-HE-Meta: U2FsdGVkX1+aJZWERLiwNFNhnzwESYl7jkNqJYO8DNilzbNit6GPQ+VZB8mB6GlvH3KnPab8mnVBj9Byu8jJbUIwL7zX0bnVh/sazwx5vgv9ZMvE3k33bmo/p5hrb5dGGor8GzhBicfyQJ4x28WO2r3xmjnPInlg8AhC6ZQNcbCVR+96P/TCfHleGTaVU+fiaafuebG1xE1+ZLu+zuqhZFgsmaRRYUxi2O5ro+nqfIHI454SwYYrgOa61L8cIHdKJC69Mgvd93AFhEyoVTLmf6RfByPDPLYHb77kCQc6qvP9PSw7rKT/pSmuitbNILy+sunWHi+eMFz53glTshtVuYi/pCmqg85P8qYftvc05uEdP7oO8NCl4a2pqaGscxEoGepzHOwHVt6QpFBeRCU/+aTr5NKkLjTCtU2BQ2vUZxhbtcKvHSSjK6Ni5dpqFjovLk2EpJNwvyK4cKbxHJW1/NGfq8WrO1rJ2/LxJLlimcnScGvD5lqm7LIxL1C6HTQHhecyIJU+EOTQe2XsQL4Nfipn0hsWxX8KN8HQb1xBIPL2Wt3bvo9YnWCzwVDX88M1GpPniJ0N/425OiMNZ5rujtj6G/XPDQiXTperk5VaaiRmv5Z9tZwEvSOySl6s1hbCSAHazP7bMfsWXvio/JpFXGmVRAOZGOW4OWHYfB3hU83NcKQ0UCBzptYHNSNpJ6KUFSwCWkpef/OR2uPRFW83bsd2EjpoA/AauqsSDysNRFRF2X2qBSgA8hVbmzwCKEIstPCLb2HJvPJ9Hgcimou2THG4qGGMwWrM/dVNmoWyDJqO58Jw2FdSlGt0fL404DzUZBV5r6VGG5goCo+EyJ+HWmRiBfpyoWlr8zKLmEreurNOWgDJ3a2wXQFSaCPYYxIpDdzaM0cTAHZuzfyFXvU+JGLYaxw408QuxmtFsY4KB5Hj/C8faQst5j5Uynm3bcj8i+uzLL0Pxu7e3WqCamS
 n3G5at9h
 61hGYYPuyvB74ueWoL8Jt7SAWxe62pkdXb1WAeR4rptpmHhutO9sqoDjMrVVAX4V1HVoPMIJo3NJrzPpYrgnFnyaq/1M/cCIIIRnkMwciL7G+S0wqb2Rd62Vd3ZHv1ojiw20RPedSBSwt9jFYc+3QFq8Z3sqpUk2qkL+3LR4gIW5U9PpwCjbVjSsFmH90p56dlZPhrEjiK+5K+Vza1dUxFUTEPOeuHYFtNukXFhVcmfDiJPNlvSmBQlC45ImYDrK5ci3EFMkimu+wmvjvOYGPlZaM2LFGFvgoJKxmafAkNx9m1vgwanTb9k1OV69s2EIreg8Dyz+RRNPcLi4xWUFpoUtkaSXcrVkTB3c90LxzG7Mh9enBKgxRNYUWHOsMZyiARhvQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-nonmm-unstable]
[also build test WARNING on linus/master v6.19-rc5 next-20260115]
[cannot apply to akpm-mm/mm-everything]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260114-172232
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link:    https://lore.kernel.org/r/20260114091923.3950465-2-mpenttil%40redhat.com
patch subject: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: x86_64-randconfig-123-20260115 (https://download.01.org/0day-ci/archive/20260116/202601160405.2XZZtwqw-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260116/202601160405.2XZZtwqw-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601160405.2XZZtwqw-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   mm/migrate_device.c:179:25: sparse: sparse: context imbalance in 'migrate_vma_collect_huge_pmd' - unexpected unlock
   mm/migrate_device.c:262:27: sparse: sparse: context imbalance in 'migrate_vma_collect_pmd' - different lock contexts for basic block
>> mm/migrate_device.c:743:18: sparse: sparse: Initializer entry defined twice
   mm/migrate_device.c:746:18: sparse:   also defined here
   mm/migrate_device.c:915:16: sparse: sparse: context imbalance in 'migrate_vma_insert_huge_pmd_page' - different lock contexts for basic block

vim +743 mm/migrate_device.c

   670	
   671	/**
   672	 * migrate_vma_setup() - prepare to migrate a range of memory
   673	 * @args: contains the vma, start, and pfns arrays for the migration
   674	 *
   675	 * Returns: negative errno on failures, 0 when 0 or more pages were migrated
   676	 * without an error.
   677	 *
   678	 * Prepare to migrate a range of memory virtual address range by collecting all
   679	 * the pages backing each virtual address in the range, saving them inside the
   680	 * src array.  Then lock those pages and unmap them. Once the pages are locked
   681	 * and unmapped, check whether each page is pinned or not.  Pages that aren't
   682	 * pinned have the MIGRATE_PFN_MIGRATE flag set (by this function) in the
   683	 * corresponding src array entry.  Then restores any pages that are pinned, by
   684	 * remapping and unlocking those pages.
   685	 *
   686	 * The caller should then allocate destination memory and copy source memory to
   687	 * it for all those entries (ie with MIGRATE_PFN_VALID and MIGRATE_PFN_MIGRATE
   688	 * flag set).  Once these are allocated and copied, the caller must update each
   689	 * corresponding entry in the dst array with the pfn value of the destination
   690	 * page and with MIGRATE_PFN_VALID. Destination pages must be locked via
   691	 * lock_page().
   692	 *
   693	 * Note that the caller does not have to migrate all the pages that are marked
   694	 * with MIGRATE_PFN_MIGRATE flag in src array unless this is a migration from
   695	 * device memory to system memory.  If the caller cannot migrate a device page
   696	 * back to system memory, then it must return VM_FAULT_SIGBUS, which has severe
   697	 * consequences for the userspace process, so it must be avoided if at all
   698	 * possible.
   699	 *
   700	 * For empty entries inside CPU page table (pte_none() or pmd_none() is true) we
   701	 * do set MIGRATE_PFN_MIGRATE flag inside the corresponding source array thus
   702	 * allowing the caller to allocate device memory for those unbacked virtual
   703	 * addresses.  For this the caller simply has to allocate device memory and
   704	 * properly set the destination entry like for regular migration.  Note that
   705	 * this can still fail, and thus inside the device driver you must check if the
   706	 * migration was successful for those entries after calling migrate_vma_pages(),
   707	 * just like for regular migration.
   708	 *
   709	 * After that, the callers must call migrate_vma_pages() to go over each entry
   710	 * in the src array that has the MIGRATE_PFN_VALID and MIGRATE_PFN_MIGRATE flag
   711	 * set. If the corresponding entry in dst array has MIGRATE_PFN_VALID flag set,
   712	 * then migrate_vma_pages() to migrate struct page information from the source
   713	 * struct page to the destination struct page.  If it fails to migrate the
   714	 * struct page information, then it clears the MIGRATE_PFN_MIGRATE flag in the
   715	 * src array.
   716	 *
   717	 * At this point all successfully migrated pages have an entry in the src
   718	 * array with MIGRATE_PFN_VALID and MIGRATE_PFN_MIGRATE flag set and the dst
   719	 * array entry with MIGRATE_PFN_VALID flag set.
   720	 *
   721	 * Once migrate_vma_pages() returns the caller may inspect which pages were
   722	 * successfully migrated, and which were not.  Successfully migrated pages will
   723	 * have the MIGRATE_PFN_MIGRATE flag set for their src array entry.
   724	 *
   725	 * It is safe to update device page table after migrate_vma_pages() because
   726	 * both destination and source page are still locked, and the mmap_lock is held
   727	 * in read mode (hence no one can unmap the range being migrated).
   728	 *
   729	 * Once the caller is done cleaning up things and updating its page table (if it
   730	 * chose to do so, this is not an obligation) it finally calls
   731	 * migrate_vma_finalize() to update the CPU page table to point to new pages
   732	 * for successfully migrated pages or otherwise restore the CPU page table to
   733	 * point to the original source pages.
   734	 */
   735	int migrate_vma_setup(struct migrate_vma *args)
   736	{
   737		int ret;
   738		long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
   739		struct hmm_range range = {
   740			.notifier = NULL,
   741			.start = args->start,
   742			.end = args->end,
 > 743			.migrate = args,
   744			.hmm_pfns = args->src,
   745			.dev_private_owner = args->pgmap_owner,
   746			.migrate = args
   747		};
   748	
   749		args->start &= PAGE_MASK;
   750		args->end &= PAGE_MASK;
   751		if (!args->vma || is_vm_hugetlb_page(args->vma) ||
   752		    (args->vma->vm_flags & VM_SPECIAL) || vma_is_dax(args->vma))
   753			return -EINVAL;
   754		if (nr_pages <= 0)
   755			return -EINVAL;
   756		if (args->start < args->vma->vm_start ||
   757		    args->start >= args->vma->vm_end)
   758			return -EINVAL;
   759		if (args->end <= args->vma->vm_start || args->end > args->vma->vm_end)
   760			return -EINVAL;
   761		if (!args->src || !args->dst)
   762			return -EINVAL;
   763		if (args->fault_page && !is_device_private_page(args->fault_page))
   764			return -EINVAL;
   765		if (args->fault_page && !PageLocked(args->fault_page))
   766			return -EINVAL;
   767	
   768		memset(args->src, 0, sizeof(*args->src) * nr_pages);
   769		args->cpages = 0;
   770		args->npages = 0;
   771	
   772		if (args->flags & MIGRATE_VMA_FAULT)
   773			range.default_flags |= HMM_PFN_REQ_FAULT;
   774	
   775		ret = hmm_range_fault(&range);
   776	
   777		migrate_hmm_range_setup(&range);
   778	
   779		/*
   780		 * At this point pages are locked and unmapped, and thus they have
   781		 * stable content and can safely be copied to destination memory that
   782		 * is allocated by the drivers.
   783		 */
   784		return ret;
   785	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

