Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32C1CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10D476B008A; Thu, 14 May 2026 04:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEA66B008C; Thu, 14 May 2026 04:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFB96B0092; Thu, 14 May 2026 04:38:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB0236B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:38:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 804258D018
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:38:08 +0000 (UTC)
X-FDA: 84765373056.09.77F552C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9403A0008
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:38:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H56Z0KEq;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778747886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=th8EGWjCFh8JoLeao00VFhcC1T5S17Gs+1gWBm1BtIc=;
	b=L/BOJoPGVyLSNk7+/nvbfzipcuWgGvsaZGbJXUT0egQ525OU/3QRHwo11/5Qvpik9vnoZ+
	Z92mvNISc1S+5kHby1KrFUSp0964tf5NmLAu5u+e0xii4xx59HmUK2iBXNfYenm4q8TpPC
	+u2MKP4KI11yKVu9zD2XrWqqeI9s7yI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=H56Z0KEq;
	spf=pass (imf15.hostedemail.com: domain of lkp@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778747886; a=rsa-sha256;
	cv=none;
	b=h5rPtBuu/2T//X0RTS4XVVsvoc8UkKcLRdB1Zc0H4oLFRk0OdqaBZ1MJvXSOIyc0IeAJGS
	kaHeB6wac64oXiLJUCNJdl2eRYIayq9EIYZRDh70/7xd60WC8F6ZJ9/2uNbaK6+wbIG/xO
	cKsj7dF/H7cjHnROM9jumx27tuk3cj0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778747886; x=1810283886;
  h=date:from:to:cc:subject:message-id;
  bh=j0ThepAaKJ3WjfvHf/k3t/FE1agot5fafmNfA332LhU=;
  b=H56Z0KEqjYZsEr0662uH2SoD8w1QihYtjWvc/8hijVjcwLrokvcKreFy
   EUiiUMQCkFrqL1p1LSUWdjeiVK1Oer+Pw1U3lKme80TjHngQUncUhWqkF
   /Xlli/JlP23p3+zqHnGIp+KHgnK3WsqiemhrC5sZyp+udeLqyEwHLqqCk
   dW1O1BGBzQaraoojTPf5lM7Jc/LtWPfcXN1ccvEwxoG25vlmsDMmgdLoy
   YWMe7X70AO3TIpgmt7HCDoEPefIRWHEvZitV8Mor//qztK0vkzI0+ydAv
   1zeiGmr9WcM5PeHlrT3J5/sPO64yR3aXv5ykZSohcLNL8nBX+MOnUUNzW
   Q==;
X-CSE-ConnectionGUID: G3ipiCZRQmSCFIvu3ZJlWQ==
X-CSE-MsgGUID: Xfgh0v5tQyqcDMENDPCDsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="79400265"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="79400265"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 01:38:05 -0700
X-CSE-ConnectionGUID: Vp5QtY92QSeMGVT0OGly0A==
X-CSE-MsgGUID: IGAwUXu7QDS+Udf9/WSFEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="276411331"
Received: from lkp-server01.sh.intel.com (HELO dca79079c3eb) ([10.239.97.150])
  by orviesa001.jf.intel.com with ESMTP; 14 May 2026 01:38:02 -0700
Received: from kbuild by dca79079c3eb with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wNRZv-000000006Db-0EA2;
	Thu, 14 May 2026 08:37:59 +0000
Date: Thu, 14 May 2026 16:37:45 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 mm-commits@vger.kernel.org
Subject: [akpm-mm:mm-unstable 25/274] mm/hugetlb.c:7281:3: error:
 call to undeclared function '__huge_pmd_unshare'; ISO C99 and later do not
 support implicit function declarations
Message-ID: <202605141638.b5ZBd6IF-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Stat-Signature: j7kk4znea91dykdqtegzei3oqbkgdwxd
X-Rspamd-Queue-Id: C9403A0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778747885-78172
X-HE-Meta: U2FsdGVkX18MqiudfD++o/ai9EvKMSPprXaxrI55x1BVVOd8ITlkbSoThbS8Akyt94cUpPk22TUS5U8LcN2pLcXz0hSlZcegZnfGddKSonyzdx73VV6XonCGiYIvfBLPT2MDR6cSj1YHtqV5iSJQGBh+TB8u4eEDPaQWcYzA2XAIjzM4AAL58+9JhA55YizweF1/AeBgDV3j+eTfvbYgcpW88a7B++SG629zDgjkzK2zfT6JqSBHTCE53Bfxr56vzBWk5Bze1k/5ex3Zo0lkVzCnIOs/nDBT1Imqi9R87bOHfwcD5G4Hx7mWo9MAr18PajG2X8MXLeppGffaQmOHvjYWKByViKJBA6l0jmFZsVasBI0AZZC91ckgSqbffyOxHSyLG1sHnrUVMqA7a2L1sugTykkQ9y7AwDIBZ9xYKKaXNJLa3dXecMsGPi4nXaPE+37O70Ig2tYyItVR8akQUB0x03aKLQb+FlzgW30CwhpqCXZHa1UCuCRJNoZVpqey0gAyWqtO28Vws20Fuefy/P1TfghuzKcfKQHi+DrfgmtjeeJCkp1Rgj1uzenNGyIbKAYIxQgoQpoD1eHambe574vaQos6cE2XdKCI+r5aNEVEVvEujizFUGy02kf5oSlJY4S9ree7gLYN/eGpLIQOJUce+iqGQXXJP4AvVvg1JQSymE/69ey0dJAUL1opTaVfv0i2+dDzdGwxSNpzmu9xfngxuOf6Mx5rf/xLzZgQtcaaOxoUw9olMsF5l9/JdGNDJvkXa/t2Mg+QTh1jAo7yqxVwxJSRbynvTnG3KYr72vbPbdQPtIXLJPZ66TsOBbHba3AIylI/nPsHttWyq19ulVN1rO3EM6ODjKQz9xPh8xdNMgYE3GzDOZbqZ44UWqQht7GaKQzz8Brbtp+J7g1nvDfMP5JzACrqfnaVIo3uiseVjl9xir0XTm7+AhvM+pWs6JnGGRZNfBrt5rv/Cf2
 d/VSHimY
 CYcYxPxr0mebLvfvnzjJ4lkArZRadqYo65U6u86Da0ZwMb5d0bZw5hl5L9zdHJJAuMnYieTv88Pp8f42pbODnGfv+8ZHkBh7FLHjgdddl59406eKjK4FuG0xIIb7OoteDG6NN7HP/yvRgyZ7qxDeOLDYBNv4rv0AGspf3Win+p/pElSviRtumV8spTxjEvu24QyBqnPY52Wsb2hBsUbRHq6PL53H3WMFkQzX8/k592UgKHADwH3GQFCWnka8JR8kOX03LR+56TTsGobCJknKDBRdn3QVzqI2fOVqQMHwFwCllQRc9Y/WaTrXDEmt+YVKJFP8g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   444fc9435e57157fcf30fc99aee44997f3458641
commit: 2bb8fe16f7bf4487248c9ff847fcf189c45b9508 [25/274] mm/hugetlb: avoid false positive lockdep assertion
config: powerpc64-randconfig-001-20260514 (https://download.01.org/0day-ci/archive/20260514/202605141638.b5ZBd6IF-lkp@intel.com/config)
compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 5bac06718f502014fade905512f1d26d578a18f3)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260514/202605141638.b5ZBd6IF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202605141638.b5ZBd6IF-lkp@intel.com/

All errors (new ones prefixed by >>):

>> mm/hugetlb.c:7281:3: error: call to undeclared function '__huge_pmd_unshare'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    7281 |                 __huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
         |                 ^
   mm/hugetlb.c:7281:3: note: did you mean 'huge_pmd_unshare'?
   mm/hugetlb.c:6973:5: note: 'huge_pmd_unshare' declared here
    6973 | int huge_pmd_unshare(struct mmu_gather *tlb, struct vm_area_struct *vma,
         |     ^
   1 error generated.


vim +/__huge_pmd_unshare +7281 mm/hugetlb.c

  7233	
  7234	/*
  7235	 * If @take_locks is false, the caller must ensure that no concurrent page table
  7236	 * access can happen (except for gup_fast() and hardware page walks).
  7237	 * If @take_locks is true, we take the hugetlb VMA lock (to lock out things like
  7238	 * concurrent page fault handling) and the file rmap lock.
  7239	 */
  7240	static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
  7241					   unsigned long start,
  7242					   unsigned long end,
  7243					   bool take_locks)
  7244	{
  7245		struct hstate *h = hstate_vma(vma);
  7246		unsigned long sz = huge_page_size(h);
  7247		struct mm_struct *mm = vma->vm_mm;
  7248		struct mmu_notifier_range range;
  7249		struct mmu_gather tlb;
  7250		unsigned long address;
  7251		spinlock_t *ptl;
  7252		pte_t *ptep;
  7253	
  7254		if (!(vma->vm_flags & VM_MAYSHARE))
  7255			return;
  7256	
  7257		if (start >= end)
  7258			return;
  7259	
  7260		flush_cache_range(vma, start, end);
  7261		tlb_gather_mmu_vma(&tlb, vma);
  7262	
  7263		/*
  7264		 * No need to call adjust_range_if_pmd_sharing_possible(), because
  7265		 * we have already done the PUD_SIZE alignment.
  7266		 */
  7267		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
  7268					start, end);
  7269		mmu_notifier_invalidate_range_start(&range);
  7270		if (take_locks) {
  7271			hugetlb_vma_lock_write(vma);
  7272			i_mmap_lock_write(vma->vm_file->f_mapping);
  7273		} else {
  7274			i_mmap_assert_write_locked(vma->vm_file->f_mapping);
  7275		}
  7276		for (address = start; address < end; address += PUD_SIZE) {
  7277			ptep = hugetlb_walk(vma, address, sz);
  7278			if (!ptep)
  7279				continue;
  7280			ptl = huge_pte_lock(h, mm, ptep);
> 7281			__huge_pmd_unshare(&tlb, vma, address, ptep, take_locks);
  7282			spin_unlock(ptl);
  7283		}
  7284		huge_pmd_unshare_flush(&tlb, vma);
  7285		if (take_locks) {
  7286			i_mmap_unlock_write(vma->vm_file->f_mapping);
  7287			hugetlb_vma_unlock_write(vma);
  7288		}
  7289		/*
  7290		 * No need to call mmu_notifier_arch_invalidate_secondary_tlbs(), see
  7291		 * Documentation/mm/mmu_notifier.rst.
  7292		 */
  7293		mmu_notifier_invalidate_range_end(&range);
  7294		tlb_finish_mmu(&tlb);
  7295	}
  7296	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

