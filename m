Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F265CCF9F8
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 00:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD948E00CE; Mon,  3 Nov 2025 19:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B852C8E0058; Mon,  3 Nov 2025 19:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC1FC8E00CE; Mon,  3 Nov 2025 19:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD8E8E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:16:36 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F9BC1A0382
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:16:36 +0000 (UTC)
X-FDA: 84071008392.08.0ECDFD6
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 45F9F180017
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 00:16:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CREqH01x;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762215394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ydNYBUGFrLAROdEaoedjyx2P5bsu0AiXwUjgu4DxHB8=;
	b=wU3Z9qZvN+LE+sL70+rVDpbaxu4f1MpMw3Zm7pHt0vPrlx4opx6ihFc9NmokuNMywPKVfz
	nfndz2eGV9jfCBChPSgsMW3XGxyX1TrIt/W/85xQtbApyeAcsJYgUPXri9KW1zmqJaOGJj
	W4PFGBRgfjDiazQOQS2pygbOWTKmfVY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762215394; a=rsa-sha256;
	cv=none;
	b=DN+jjpQZitWierJDaxWcpv8uPwjiwe+2U/MUaTKEOFM7/72iq73IKVILhg3WIBNiBFBxdj
	aDfFHg5g66s3zoJj+iNFtLM/Z3XnV/F7+fHvCWP+3IEMBAYoHr43+SkVpevmwp0/4EHyFu
	wxLEVm135Ob5KlBW6kXhL8N+d1aVeCM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CREqH01x;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762215393; x=1793751393;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zxAXuaKryOZl71JI0V1lAw38LB1v6NuF6Mtj84GNJJA=;
  b=CREqH01x70s42QRyhY8sJ/jAwMw6OS+DAvbZ3EcSuAqe2/0mMFZoVjx4
   eaGx6y3cZefuQuL9t61iEWTSz5MLX6sDHzH2vPA6a58DWaOBB2k2xPDa1
   zFqfw5ck79KurtZ7fRaCXzlm34F981CUfwgljOE1TdKEL2cBxmhJLeyVZ
   qlWE+QT/1DSkLOahLuOqCelqbcNhTg2es5iDs3vHbI+Oo0vX5TLRRISVk
   Q8a0RhphTOLTXtMuS0ThgHHLaKhBKaDCL1l5qZfdKwD+rV24sYkzHvp8F
   Lo/Msbg1617Srbm3z8pMEFK8SqhkFCRBBiCKfRNBSsSOffWi6R5YPTUJL
   A==;
X-CSE-ConnectionGUID: lq8E7ctnTPGOHzqMJE72ZA==
X-CSE-MsgGUID: ZUWPjQoiTb+Se0ujZswDUg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="63315033"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="63315033"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 16:16:31 -0800
X-CSE-ConnectionGUID: xWdJEXLTRK285TprlfyTVg==
X-CSE-MsgGUID: M2sTMn8SRQGukSTiZD9R6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="191352272"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 03 Nov 2025 16:16:24 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vG4iD-000Qeu-2k;
	Tue, 04 Nov 2025 00:16:01 +0000
Date: Tue, 4 Nov 2025 08:15:00 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 10/16] mm: replace pmd_to_swp_entry() with
 leafent_from_pmd()
Message-ID: <202511040851.UAHe93ix-lkp@intel.com>
References: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
X-Stat-Signature: 11foqy3ps1ob4ywnzzeaiy3kfnc6cikr
X-Rspam-User: 
X-Rspamd-Queue-Id: 45F9F180017
X-Rspamd-Server: rspam01
X-HE-Tag: 1762215392-497536
X-HE-Meta: U2FsdGVkX18uQp6euLbn2O0nJl42inG+W/7k/+YCzWz6Qb6vrovTc94NrHqLm9zuz4bHx8jzVvoBVTrS5XEF+1ctUsDJXNMqei2dW4IcVp77N1l7T6dKEUqkq28sqXJ/tgNCxT8YqZZL625hUUP8+FNx77AnL3oalfKy0LP4WrM4zRJHFD85Gfq0tw8MTz6ffb74jkTpih5B3l1qUW0behOpfniQRJwjVaaN5h49G3XTW/nNoruIOIyPZ3u+9oDQJvBF64ZwZbDZaXa9k3OMsjECg4chcEjuHwezpMhYFd8J/36CPXpUd198mS9X4sfgdpXkJ5ByJ2OnltJO+K8mmTRRCp20gLI+Ziu/D6w4RT41xYwCJP3uNNJgBRSkQmq74M73wlCNhJno1FZ1kNZflgSofwfJ9cJC6WrWXepZFXpfPdZ/8H3Q9QK/doIT8vedf++pbrj9sYmTfPqE92ltHRmMh7oErIPdFEHCv/HxD2JaDMxgRkLa9vGtG8ELRl5ORhgk2Jjpz1d6Jh2ZYk8ALNZrchK2WT4JhtGevr8O/S1vViPT1xAx4YVy0be/fIojShNY5LZpU4aHl0uUtUg2eqnwbdGA5l2yhuWr/X6eUE8MsS03A9Zcyukul9ONc592IuKfhCkYSYHnuPXdSlS81TpnsoXxedxNXtijtgXlwWVSCpNk0WTn6EBdDPywS1OC664s+6uEC9caqwVCKjOQBDglkwy7BUbBfYYDpXDhUJAIWAMrLGRNKNaGmiuPAGk/TckQBnXrQlAGFz6WCx6++5+BYEREqd73KC4KWXiFHtu7oswakswy47c9lYLg3cXbYk31dYxhwAL+LxKM8XnvEm3RAUIr4/GXd6rBRGxgHGZ9Ba/WiNNmmRfmmERrBkwSbCZJ7a4kajaz5tEPrDFnheHFVHL8Bz6fOXSczTfEw85tXrfaEpsiG4KDvBpHjCixIP+IAfNo+9lfXkPasVk
 Hr6p25sa
 KlWqvF3Ry594QGbWAHJ62dMbLCxlkQ8RTP8sr4nSclXWYUcMUeun7y7R2pNDE5K07IF/IIYe1vB0yVyUsfw77AKyS7Et9k/HN9apljMcTnL9Me40u9HOzxmVdqp3afHl8YSbxD1I5fvGN5+/uPzp8MOCoPeKgAkSGj/KLgTYBrxO7JhD52Q1xdFnM+jgMLmBQkYRPyjJ+we1HkoUjFcGhFpRP3UtpzItr+hnVYWBox1mdu4CmlsqDVzXMlK4mdglnw+bJTC6/o2VCSnbuL/FSoyPGmhNBIDgn7vM+f+VNLkAvW/74VoeP5m2ePQv/s6dKv1r2e2MREN5INTjTq7EpvA5/o/NZMBMeHpPaTyGZEeCigIQD0jRykPMDw1NU8JpC/RJm8/7g8hvEpm3Ikph4YcRcMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-correctly-handle-UFFD-PTE-markers/20251103-204118
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH 10/16] mm: replace pmd_to_swp_entry() with leafent_from_pmd()
config: sh-randconfig-001-20251104 (https://download.01.org/0day-ci/archive/20251104/202511040851.UAHe93ix-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 13.4.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251104/202511040851.UAHe93ix-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511040851.UAHe93ix-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from include/linux/leafops.h:6,
                    from include/linux/migrate.h:9,
                    from mm/damon/ops-common.c:8:
   include/linux/swapops.h: In function 'swp_entry':
   include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:90:28: note: in expansion of macro 'SWP_TYPE_SHIFT'
      90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
         |                            ^~~~~~~~~~~~~~
   include/linux/swapops.h:27:46: note: each undeclared identifier is reported only once for each function it appears in
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:90:28: note: in expansion of macro 'SWP_TYPE_SHIFT'
      90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
         |                            ^~~~~~~~~~~~~~
   include/linux/swapops.h: In function 'swp_type':
   include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:100:30: note: in expansion of macro 'SWP_TYPE_SHIFT'
     100 |         return (entry.val >> SWP_TYPE_SHIFT);
         |                              ^~~~~~~~~~~~~~
   include/linux/swapops.h: In function 'swp_offset':
   include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/swapops.h:28:34: note: in expansion of macro 'SWP_TYPE_SHIFT'
      28 | #define SWP_OFFSET_MASK ((1UL << SWP_TYPE_SHIFT) - 1)
         |                                  ^~~~~~~~~~~~~~
   include/linux/swapops.h:109:28: note: in expansion of macro 'SWP_OFFSET_MASK'
     109 |         return entry.val & SWP_OFFSET_MASK;
         |                            ^~~~~~~~~~~~~~~
   include/linux/swapops.h: In function 'make_pte_marker_entry':
   include/linux/swapops.h:395:26: error: 'SWP_PTE_MARKER' undeclared (first use in this function)
     395 |         return swp_entry(SWP_PTE_MARKER, marker);
         |                          ^~~~~~~~~~~~~~
   In file included from <command-line>:
   include/linux/swapops.h: In function 'is_pfn_swap_entry':
   include/linux/swapops.h:27:46: error: 'MAX_SWAPFILES_SHIFT' undeclared (first use in this function)
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^~~~~~~~~~~~~~~~~~~
   include/linux/compiler_types.h:577:23: note: in definition of macro '__compiletime_assert'
     577 |                 if (!(condition))                                       \
         |                       ^~~~~~~~~
   include/linux/compiler_types.h:597:9: note: in expansion of macro '_compiletime_assert'
     597 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   include/linux/swapops.h:448:9: note: in expansion of macro 'BUILD_BUG_ON'
     448 |         BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
         |         ^~~~~~~~~~~~
   include/linux/swapops.h:448:22: note: in expansion of macro 'SWP_TYPE_SHIFT'
     448 |         BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
         |                      ^~~~~~~~~~~~~~
   include/linux/swapops.h: In function 'non_swap_entry':
   include/linux/swapops.h:491:35: error: 'MAX_SWAPFILES' undeclared (first use in this function); did you mean 'S_SWAPFILE'?
     491 |         return swp_type(entry) >= MAX_SWAPFILES;
         |                                   ^~~~~~~~~~~~~
         |                                   S_SWAPFILE
   include/linux/leafops.h: In function 'leafent_from_pmd':
   include/linux/leafops.h:111:22: error: implicit declaration of function '__pmd_to_swp_entry'; did you mean 'pte_to_swp_entry'? [-Werror=implicit-function-declaration]
     111 |         arch_entry = __pmd_to_swp_entry(pmd);
         |                      ^~~~~~~~~~~~~~~~~~
         |                      pte_to_swp_entry
   include/linux/leafops.h:111:22: error: incompatible types when assigning to type 'leaf_entry_t' {aka 'swp_entry_t'} from type 'int'
   include/linux/swapops.h: In function 'swp_offset':
>> include/linux/swapops.h:110:1: warning: control reaches end of non-void function [-Wreturn-type]
     110 | }
         | ^
   cc1: some warnings being treated as errors


vim +110 include/linux/swapops.h

^1da177e4c3f41 Linus Torvalds 2005-04-16  102  
^1da177e4c3f41 Linus Torvalds 2005-04-16  103  /*
^1da177e4c3f41 Linus Torvalds 2005-04-16  104   * Extract the `offset' field from a swp_entry_t.  The swp_entry_t is in
^1da177e4c3f41 Linus Torvalds 2005-04-16  105   * arch-independent format
^1da177e4c3f41 Linus Torvalds 2005-04-16  106   */
^1da177e4c3f41 Linus Torvalds 2005-04-16  107  static inline pgoff_t swp_offset(swp_entry_t entry)
^1da177e4c3f41 Linus Torvalds 2005-04-16  108  {
3159f943aafdba Matthew Wilcox 2017-11-03  109  	return entry.val & SWP_OFFSET_MASK;
^1da177e4c3f41 Linus Torvalds 2005-04-16 @110  }
^1da177e4c3f41 Linus Torvalds 2005-04-16  111  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

