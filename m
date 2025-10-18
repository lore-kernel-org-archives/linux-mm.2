Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D49CCD184
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 02:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85CE28E0009; Fri, 17 Oct 2025 22:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D908E0006; Fri, 17 Oct 2025 22:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722DC8E0009; Fri, 17 Oct 2025 22:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE3A8E0006
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 22:55:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D47B160325
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 02:55:09 +0000 (UTC)
X-FDA: 84009718338.24.549459E
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id E435C40008
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 02:55:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YYrKx+CR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760756107; a=rsa-sha256;
	cv=none;
	b=yOAGABroVSwvFojNurx2woOdeLsa0n9W4OHaZg1+Jc/dLuaq6mYC993u/9LrrRDEHPYchj
	sO92M0pfL8IV0DUiaDbqEG+Risc03zkVA1VEbuz0PtHl/SxtR32hT0q2xwUdTUWGTQMVXB
	o1ub8n0EhXrNepim+IGiouXoyxbK4S4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YYrKx+CR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf12.hostedemail.com: domain of lkp@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760756107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=COyEg2bktwZwr2RohggXW8/PeNBCT4e4CyjsWH6taMk=;
	b=l3ME5/Vw35WPrgFfrHsudEnFx5a2eUE3oAJl+4UjOmi+0B7UXBk8qg2JPKe1Q2u2y7Y3LO
	jlj9zaq4+RD30xeYHSSWXeXfCwtbpy1fhRDLy+7U9NzKZ+FP3XQtKtGsD1EHYlDTG6CcLX
	dsYEkPTvlPtEs85KKoQOBqLJgtDy3e8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760756108; x=1792292108;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/ZPmH4lYkHsggufwvRdkbwQ+doZooO3d11W3wHF8eTQ=;
  b=YYrKx+CRri78y16hBNDGcoJjBD/OsQ7O1nSKhwduI3SSwH+KgB0JqaWZ
   lU8UyaTdnbTOcjADUojv+fpSO3WGC6CDN+WqLf4z1B3ZDbvyDdoDhUFyu
   AoS/+0Dl4GZjTQHU2UEU3DQesSLDrhivsCXrFmh6nzMtZkPMdRXY+4GT1
   +hM8AKI3Vh8Jzqog1J4W42DVzHhS/h0OLptycbieXt5iBBcuNWkDSKSfV
   NoHbD/iYrubCw7TPbQ80cqBGQM/Lb2d5E4GXt/cErfXNPQ0T1HmqXnIe/
   +Z2wq9xG+iJe2zAhdpQ5/QzYyA07pSdrvi5OGdOwbGWdYKG8Lwjqyw8fs
   w==;
X-CSE-ConnectionGUID: sgY4R/qhTjm7aCnkW5nwhQ==
X-CSE-MsgGUID: 3rTXPDkPSa+XCwuhyatCeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11585"; a="74411062"
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="74411062"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2025 19:54:48 -0700
X-CSE-ConnectionGUID: 2DnvxapsRK+7j8rtICLRzg==
X-CSE-MsgGUID: GxiTUOrDQKmJFNciETW/fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,238,1754982000"; 
   d="scan'208";a="182064327"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa010.jf.intel.com with ESMTP; 17 Oct 2025 19:38:54 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9wqI-00080Z-2r;
	Sat, 18 Oct 2025 02:38:50 +0000
Date: Sat, 18 Oct 2025 10:38:42 +0800
From: kernel test robot <lkp@intel.com>
To: Kiryl Shutsemau <kirill@shutemov.name>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <202510181054.Fmf1S18u-lkp@intel.com>
References: <20251017141536.577466-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017141536.577466-1-kirill@shutemov.name>
X-Stat-Signature: jspfxe65g6wpo4j84jsg4y19rhf6xm1r
X-Rspamd-Queue-Id: E435C40008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760756106-444827
X-HE-Meta: U2FsdGVkX18GuJyjBdfETsBQLQwdLYu1tmDx1fnhtHKRsWNAVXP1ks7KuS1zy4cpYQq/7Uechdy29jTfG/q9vWFW6JNMxj7BCmoi8YPnTBsnRFrVCpHzX2BT0nLO6ii14DrZqntMhQtIBT2L4xq+xVSnbc9TEypwGidi0BENSR5JT5IOm5ULJ3kIIyRSuoopoWw1mvTVWVEjTYi5aKY4TyOPJ6GaXUpsnJuXKIQRBgY8TJm5OH4zxWq23P80h8KJoTB5Ishl5FeNqzRJBzokm0xAx/kusbP+SGfGBZ5v6xaSeWj9Df4jQ3MgUtdlejA13ZPWe7k6MeM3sVbyWkQY5W3AryXAJlBQW94iPEw9JwCmVorhEtU12cTPD0GTe+9i9c6Hua+3oF7y1e90E6yxeT1I0VVqCZHB/Z4s76/4eX1I3IzUTn1bJBsMpAA34S7QQnegLY1tgvX/italYYthmKrHMSood4jg0cDJlczRLxgWa8mHkmS78Qf22nnjruKV/FcQjHEWeHrdOJmwySSVL8hKrDTUokVxapyfMulA8d29w76Q9EVWDovHQdLddoVROxi2CfoVCPLHCVclowx4p6W+Uhu03wDfN0FBKbwJtM7eKxTfUodIoFbjDgTBPejvdlvpNsR2hDIf6sdER63MiCFUWT/o5ybNSGV++rBw8n+Tk7x+EWwdjPkvuR/A9nOwxh8f7vaPlrZw1h/JVAIbqn7haTxF70D2wYrG8Jrw7L51UaqJchN92iTpDFks/GWCOPJ9yNe+K1dCq7E+U3GFAjIYElSwpjRCMOzsg5yWPZeTSgxNlmIrFDKJKEBowyNKHB+poN5QPUD3HZnSMUqkXUkQJhTQcekRQL/zYAjiikVEa5T/TrePh0y/oSuzpyhitUvREPxDZGvsstpTFI3TCB6ISdU9pSgwbCcWxNzMx4UICCEm7GB6+eNYO3ogaB4a+CcTq0vnBMF79HNr26J
 1+R7Ftl6
 iO2ZKTiRsZ46nvaSumXY+cQNq1fGFeljFsh/sl4VuTcvpcuFRhSlARqGiu4Ziiy7RJJHnPpRT8vyeOQflkyVkAr1Scifys9fDPML1S9sNHUatOMkvE1iLiPT7VWj9uGmgEf0VCJ2ufjJ83JbcQ9VeqBOtttdNqF2uIAOiPcWeXGK91HKtTtEoi5p/8f4mCNuGCH4oQOes8Mr9R9x69laID0Gk+2P8ts9pdzEm1dwyvx7kRUxeZh2MzRM/GOVn4ynObpW8n5ZUG+xtevZP12ZjTo9mKLyCFlFTmiC/PPQjl0oN5/DSfJbD7da0Q0on1KeWLiDmiZRdWYgNrz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kiryl,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Kiryl-Shutsemau/mm-filemap-Implement-fast-short-reads/20251017-221655
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20251017141536.577466-1-kirill%40shutemov.name
patch subject: [PATCH] mm/filemap: Implement fast short reads
config: riscv-randconfig-001-20251018 (https://download.01.org/0day-ci/archive/20251018/202510181054.Fmf1S18u-lkp@intel.com/config)
compiler: riscv32-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251018/202510181054.Fmf1S18u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510181054.Fmf1S18u-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/sched.h:45,
                    from include/linux/rcupdate.h:27,
                    from include/linux/rculist.h:11,
                    from include/linux/dcache.h:8,
                    from include/linux/fs.h:9,
                    from fs/inode.c:7:
   fs/inode.c: In function '__address_space_init_once':
>> fs/inode.c:486:28: error: invalid type argument of '->' (have 'struct xarray')
              &mapping->i_pages->xa_lock);
                               ^~
   include/linux/seqlock_types.h:57:26: note: in definition of macro '__SEQ_LOCK'
    #define __SEQ_LOCK(expr) expr
                             ^~~~
   include/linux/seqlock.h:131:42: note: in expansion of macro 'seqcount_LOCKNAME_init'
    #define seqcount_spinlock_init(s, lock)  seqcount_LOCKNAME_init(s, lock, spinlock)
                                             ^~~~~~~~~~~~~~~~~~~~~~
   fs/inode.c:485:2: note: in expansion of macro 'seqcount_spinlock_init'
     seqcount_spinlock_init(&mapping->i_pages_delete_seqcnt,
     ^~~~~~~~~~~~~~~~~~~~~~

Kconfig warnings: (for reference only)
   WARNING: unmet direct dependencies detected for ARCH_HAS_ELF_CORE_EFLAGS
   Depends on [n]: BINFMT_ELF [=n] && ELF_CORE [=n]
   Selected by [y]:
   - RISCV [=y]


vim +486 fs/inode.c

   481	
   482	static void __address_space_init_once(struct address_space *mapping)
   483	{
   484		xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
   485		seqcount_spinlock_init(&mapping->i_pages_delete_seqcnt,
 > 486				       &mapping->i_pages->xa_lock);
   487		init_rwsem(&mapping->i_mmap_rwsem);
   488		INIT_LIST_HEAD(&mapping->i_private_list);
   489		spin_lock_init(&mapping->i_private_lock);
   490		mapping->i_mmap = RB_ROOT_CACHED;
   491	}
   492	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

