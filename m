Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B42CAC5B8
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 19:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B30A28E0002; Sat, 27 Sep 2025 15:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9418E0001; Sat, 27 Sep 2025 15:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980B28E0002; Sat, 27 Sep 2025 15:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6D08E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 15:30:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E499687CBA
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:30:11 +0000 (UTC)
X-FDA: 83936021022.09.E402F98
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5834280006
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:30:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hcg9T7n/";
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759001410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2mkC74ampDMutYNklgYO35/nFK5XdJ3ovitb5wQLVg=;
	b=5IyzhLhZrWuUanLwTs2LCGLMoYeinpjc6vh4P6PaTM/P8kGiIBxyVsPdRoIL9nIQwKKW6f
	yUZswWmd6yjDTA8c8nILQ05yjT7owxh0dPlNiwvVt8A6yeY5Cc/tqG/iS0UjZvosrluD5i
	lSSHaeEgsS7ouB21kz34qXQ6GgkgpB8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759001410; a=rsa-sha256;
	cv=none;
	b=F8lLzi1034BLMHBo0/QR7jdWzLjeBXaqjg+1RytHZ06S9kz5JZCFvbME5ll+cc0FzDpCp2
	yxmNMoukkmDqMoQo87hwhNP+Geo1o5jQz0KXETgtv5xFB33Z8PByYR2YMGPmT0OjgQuxng
	IY2AJ4XMWEidli+HrGSGf5g4ETz1nZE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="hcg9T7n/";
	spf=pass (imf02.hostedemail.com: domain of lkp@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759001409; x=1790537409;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZmqKSfvKG8Sl31zQDeeEeXhIAVgZkEJsrGTFgAnGr9Q=;
  b=hcg9T7n/367CVYc/J8/Tm1MhX9Kt3nW58O81ky1kACM9pwL7RfjjirQk
   3f82BXr1b1NB2N0qjkfS/mb592/vCXx9WvgZvcSgcWll6vy2NwpN/zfeB
   BE7OpqotUHDHZy8NW0cva5V62YqWD0GX8mZVIJR94gwxS0oYW6+hUNMZ8
   862XGj6AlJtlNE2OIJuSDsJxdqieQJGCp7VoPtZC08JIqn0Nf7O+bSLBa
   qmdskLL7nMAw/3WVFA3y+AQAyJsSf25VeYJ9dG3lPzgo41jbxjo5Cf+/u
   07QEq0hGaWgAw35NVqWq5bmythqMk3A5Jr2YELIruUR+LtajLoAmV7axI
   A==;
X-CSE-ConnectionGUID: I5Kfb8hTTsCdhYA46PrN0w==
X-CSE-MsgGUID: 2InTt+9lSCq2Yj1Tno/W0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11566"; a="48862119"
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="48862119"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2025 12:30:07 -0700
X-CSE-ConnectionGUID: sGeoqd44RgymTRqe2XoVgg==
X-CSE-MsgGUID: R+Dp0UylSICLl5YeQhgHnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,298,1751266800"; 
   d="scan'208";a="182175568"
Received: from igk-lkp-server01.igk.intel.com (HELO 0e586ad5e7f7) ([10.91.175.65])
  by orviesa004.jf.intel.com with ESMTP; 27 Sep 2025 12:30:00 -0700
Received: from kbuild by 0e586ad5e7f7 with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1v2acH-000000005YD-3TdQ;
	Sat, 27 Sep 2025 19:29:57 +0000
Date: Sat, 27 Sep 2025 21:29:35 +0200
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, bp@alien8.de,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
Message-ID: <202509272136.N4ELb64u-lkp@intel.com>
References: <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com>
X-Stat-Signature: x3i8qhxih54zk7p7zpkhphwk19x3nwbe
X-Rspam-User: 
X-Rspamd-Queue-Id: 5834280006
X-Rspamd-Server: rspam10
X-HE-Tag: 1759001409-193246
X-HE-Meta: U2FsdGVkX18mYYjceaSc2Lwb3LIxKnmJvpZ7HtQQKjmxYrQBzOlDdH29EseHUHaXDB5/8HcqwNdKFyzcunOVLfiWl/u6g1YKnctXC34RwFruGc40TImv8JXIEXGuaKjmz37XoXYrkvYBchVN2oikc47tiV6V2Il40DRGPHvhPIJhH91xNkJH5z39/mAkop17xRSQZyaq36Wc+ohBxVXz4O7e68CheZF0W9dqs6uaLWFC/V11rPQRZ2KvKxLG+4ep+jUlEcn6drp+xXPQUI0HQhHMcNvCs3B6pO/10N/BjcGlOrjTdzEJ5Ws+MptdgYrOBeLgcHI7U7Db50UqmlZIZyZWrbb6s4DAS+DPUfyoFdU1N8W+6L9k3456WiEbqTv+IUu/APHH8EkflXxzgJ5WH72cjZiaoN0uTkoSCd2MGHwQbSG0WQy5lYWSmihjSUEViCv7u5IUY00j9qm2HlZDlBUGq7y/VQPj4FcKoJvya6V7Kh6tkjFA8IW5Lhgxl/QztbNf+UXuPBlD9FUamSxDnWw7lnKLLTDUmMUOLW259oCNakqugMRVosIoR4EYaPkDPl4ArduYxIRP2bo2EVzCM9WX1W+ZNBkRpqT/JjlbqrAnPbITrsFORz7g3e239dXCTJ+03bLO+veqd0lCWfe57vu/bbR05zYc7DlOXouw8qt3f3BkmnFSW0QIXEDLB9l3ntD/FBo+JzCGKns5O+aUqIEyfIB75MuZCaLhDWbJZ8wRn/xvLdUUKbmC2GkMdd2DXkSsXHAGMNjScow+A20BbPzg7bqzcFZMUt6GzanclzIqF1vvaDhIzB3c27nMZpYgKzuLEDFMr7NSGLxirY6UBtiPJlAlXswkyKWEaPRHI4UEka+/2b8yAVwVSfZ8oHEX+xhchwbxwA5AEYm1GE8MXQcRo8AEg/LTDWQBrBcndTYa+m+Pl9+6Tf2kE4OXvTEtmx1bayezhJ3Re/uBghg
 RjkMpbAJ
 J6cjr6FmI1Fr219ebMdYIsXqU10qzuVlmQ2x7pERwTfLkUfpDvnvtXjynDYo6KD2utdlzNoBCjGXhPEwai9R+p8CSkRDQ3IgfEbAXWf/FbygLdRkwV4AKW4B6WLaSxil7tuxoRYE+eCTH91f2Obnqq+aFdaZ9peLfbtPL09pizhAKzz5efrFJruI7jdejSZEsE3LHpo7LBVxbYzu/GZbUfgStKQFVTTBU/YmmOabywxVXNeQb79SeetuY2I17FNrqTREWhg+b54TuG6FOvIx+qou42mr1Zk8wjrGi2IvCJupUzvWPz+eScUawWmOtwy2llV9lv8iylUqhGXDTGrObtmLj7Hm7pcOSZDX9uSSvXQO6FTOUwaflJSPeLtYeCwT99YVR9XalzixUWIhef/g6TtesQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Brendan,

kernel test robot noticed the following build warnings:

[auto build test WARNING on bf2602a3cb2381fb1a04bf1c39a290518d2538d1]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/x86-mm-asi-Add-CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION/20250924-230633
base:   bf2602a3cb2381fb1a04bf1c39a290518d2538d1
patch link:    https://lore.kernel.org/r/20250924-b4-asi-page-alloc-v1-3-2d861768041f%40google.com
patch subject: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20250927/202509272136.N4ELb64u-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250927/202509272136.N4ELb64u-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509272136.N4ELb64u-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/mm/init_64.c:747:23: warning: variable 'vaddr_start' set but not used [-Wunused-but-set-variable]
     747 |         unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
         |                              ^
   1 warning generated.


vim +/vaddr_start +747 arch/x86/mm/init_64.c

7e82ea946ae4d0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-06-06  742  
eccd906484d1cd arch/x86/mm/init_64.c Brijesh Singh       2019-04-17  743  static unsigned long __meminit
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  744  phys_pgd_init(pgd_t *pgd_page, unsigned long paddr_start, unsigned long paddr_end,
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  745  	      unsigned long page_size_mask, pgprot_t prot, bool init, bool *pgd_changed)
^1da177e4c3f41 arch/x86_64/mm/init.c Linus Torvalds      2005-04-16  746  {
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21 @747  	unsigned long vaddr, vaddr_start, vaddr_end, vaddr_next, paddr_last;
^1da177e4c3f41 arch/x86_64/mm/init.c Linus Torvalds      2005-04-16  748  
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  749  	*pgd_changed = false;
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  750  
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21  751  	paddr_last = paddr_end;
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21  752  	vaddr = (unsigned long)__va(paddr_start);
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21  753  	vaddr_end = (unsigned long)__va(paddr_end);
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21  754  	vaddr_start = vaddr;
^1da177e4c3f41 arch/x86_64/mm/init.c Linus Torvalds      2005-04-16  755  
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21  756  	for (; vaddr < vaddr_end; vaddr = vaddr_next) {
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  757  		pgd_t *pgd = pgd_offset_pgd(pgd_page, vaddr);
f2a6a7050109e0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-03-17  758  		p4d_t *p4d;
44df75e629106e arch/x86_64/mm/init.c Matt Tolentino      2006-01-17  759  
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21  760  		vaddr_next = (vaddr & PGDIR_MASK) + PGDIR_SIZE;
4f9c11dd49fb73 arch/x86/mm/init_64.c Jeremy Fitzhardinge 2008-06-25  761  
7e82ea946ae4d0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-06-06  762  		if (pgd_val(*pgd)) {
7e82ea946ae4d0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-06-06  763  			p4d = (p4d_t *)pgd_page_vaddr(*pgd);
7e82ea946ae4d0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-06-06  764  			paddr_last = phys_p4d_init(p4d, __pa(vaddr),
59b3d0206d74a7 arch/x86/mm/init_64.c Thomas Garnier      2016-06-21  765  						   __pa(vaddr_end),
eccd906484d1cd arch/x86/mm/init_64.c Brijesh Singh       2019-04-17  766  						   page_size_mask,
c164fbb40c43f8 arch/x86/mm/init_64.c Logan Gunthorpe     2020-04-10  767  						   prot, init);
4f9c11dd49fb73 arch/x86/mm/init_64.c Jeremy Fitzhardinge 2008-06-25  768  			continue;
4f9c11dd49fb73 arch/x86/mm/init_64.c Jeremy Fitzhardinge 2008-06-25  769  		}
4f9c11dd49fb73 arch/x86/mm/init_64.c Jeremy Fitzhardinge 2008-06-25  770  
7e82ea946ae4d0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-06-06  771  		p4d = alloc_low_page();
7e82ea946ae4d0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-06-06  772  		paddr_last = phys_p4d_init(p4d, __pa(vaddr), __pa(vaddr_end),
c164fbb40c43f8 arch/x86/mm/init_64.c Logan Gunthorpe     2020-04-10  773  					   page_size_mask, prot, init);
8ae3a5a8dff2c9 arch/x86/mm/init_64.c Jan Beulich         2008-08-21  774  
8ae3a5a8dff2c9 arch/x86/mm/init_64.c Jan Beulich         2008-08-21  775  		spin_lock(&init_mm.page_table_lock);
ed7588d5dc6f5e arch/x86/mm/init_64.c Kirill A. Shutemov  2018-05-18  776  		if (pgtable_l5_enabled())
eccd906484d1cd arch/x86/mm/init_64.c Brijesh Singh       2019-04-17  777  			pgd_populate_init(&init_mm, pgd, p4d, init);
7e82ea946ae4d0 arch/x86/mm/init_64.c Kirill A. Shutemov  2017-06-06  778  		else
eccd906484d1cd arch/x86/mm/init_64.c Brijesh Singh       2019-04-17  779  			p4d_populate_init(&init_mm, p4d_offset(pgd, vaddr),
eccd906484d1cd arch/x86/mm/init_64.c Brijesh Singh       2019-04-17  780  					  (pud_t *) p4d, init);
eccd906484d1cd arch/x86/mm/init_64.c Brijesh Singh       2019-04-17  781  
8ae3a5a8dff2c9 arch/x86/mm/init_64.c Jan Beulich         2008-08-21  782  		spin_unlock(&init_mm.page_table_lock);
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  783  		*pgd_changed = true;
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  784  	}
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  785  
46b7f8ebabd0a2 arch/x86/mm/init_64.c Brendan Jackman     2025-09-24  786  	return paddr_last;
^1da177e4c3f41 arch/x86_64/mm/init.c Linus Torvalds      2005-04-16  787  }
9b861528a8012e arch/x86/mm/init_64.c Haicheng Li         2010-08-20  788  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

