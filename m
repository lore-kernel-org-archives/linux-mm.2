Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C958ECCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6518E00A7; Mon,  3 Nov 2025 11:25:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F928E0057; Mon,  3 Nov 2025 11:25:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4598E00A7; Mon,  3 Nov 2025 11:25:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE63C8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:25:19 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75A265790E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:25:19 +0000 (UTC)
X-FDA: 84069820758.19.1116F02
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf16.hostedemail.com (Postfix) with ESMTP id 38B16180002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:25:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S+xdgrNq;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762187117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ctbyIEO/P7AZFWB3Fx33rn+FNYjmUk1aJIdv4/kWlrE=;
	b=zjb6CE6QvcMEx6hQ7UICvBtLZ6SJOeJqQSH3v4SZUomIhRvOK3jeF7b4g07AtKZADZC5l4
	i2jZyILi5RhP29hKaV8PBHIOBeMwnbW/ZGcY53NKPjuG1/jlbrnGceDVui74AbZDJBLhmp
	toTDdZ0yxh/lBfqHKzKPI41nw/RYt7E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=S+xdgrNq;
	spf=pass (imf16.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762187117; a=rsa-sha256;
	cv=none;
	b=x0aowWLr8yeySe9Pm2oFu+ndrmpGPD4c3fcyCn4fZzHl7YLjwdXtH6snat1PkmQt7hoh/3
	TXFRuac8mLP1HAz5karAH5zuIs7jEPPLBEOv/4hTM5mFtxUKJRn5THz6D4htNwxEF45SwI
	hJqDXuz/obyeWkKGXwLmFJ+5UkvYRrs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762187116; x=1793723116;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=t926oHxXyeoHO/tZR4YDfvuIUGOhvh1nCNJiG044Dv4=;
  b=S+xdgrNqeYk7S0LmtjitrQYfdevZThSi59LTTe08SvtRHDTPSt0Aousm
   CaNUxWIMebHS2+92bQxUdKWsuYOtUgOBl7QwHI2ZL1SdzlwRluc1yAiiw
   MoNagpj1XtaNodd0YlTIonAcdI1+3UIlZbUS+4mI6B+S4b1Ea+YTyE4wU
   k7zgApKhCOD+NKBd/z1PG0aqH0aj3wMz7aAWSzghn5IhVIL7IYa4Jrg2T
   lTrqnQjoe5/mDwHbd1cGsPVhpTMiBoL8VaGjInptbYawOqjFvdt3qKwcC
   sI74e/PpfbF/9Ikgqt8PfA+KRXVim5Gd58FEfSQVs3h/h85s6AwXDcQh9
   Q==;
X-CSE-ConnectionGUID: dAKO6tGGQLOuuLmqHGoyFQ==
X-CSE-MsgGUID: nADeJDaNTL2BOrqeWmVlVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64417677"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="64417677"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 08:25:15 -0800
X-CSE-ConnectionGUID: PnTRSjgDTD+C/2KQbGtg6A==
X-CSE-MsgGUID: kJFZyWkqRdKS4C+GNCdU+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="191251179"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 03 Nov 2025 08:25:07 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vFxMe-000QKi-0o;
	Mon, 03 Nov 2025 16:25:04 +0000
Date: Tue, 4 Nov 2025 00:24:31 +0800
From: kernel test robot <lkp@intel.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
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
Message-ID: <202511032303.n4dF1k87-lkp@intel.com>
References: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38B16180002
X-Stat-Signature: ayga7ah8tr1bhwt67w9rpce5dozmxpt7
X-Rspam-User: 
X-HE-Tag: 1762187116-632439
X-HE-Meta: U2FsdGVkX1/iLjUHW33F4848Mg+SzDUZtouRVIAeO2Ga6FYYGmHUM+OJHVhhhmZKaB7rDP9fDAb9nlxfc84KKMOP0ZdxZ3EOHJdU41B/9teNF10OIdRwMEyoW6pwyKL3FU6eS2mnQb3Qoa/K/OTGrqx05HHpCerl/j4LhhseX9hWGyU5xQAjdwxGXOQiO6hakWnSa8zz/G7bFPz2hC72iqC/CTWjw9dhgwuQOv2QFfBbsl1WED/1QB34AiyH4Dn/NImBOBk1MJhRB4moI1+vWy/xFt/3u3Tg9hetz7SRaiGg43kLBjR6/yMxtvy8Giq88+XN5vauARTqJRi7K5bvMVRSe7aBGjxygMaNusag8mXqnb9rgcwIi0eal29iMciY4gXKiiJY/NTEtz7NlZW4LuvcYSysTMpG0sbNK5VGS8QjmqLkzyQFhBUikJX3zdVuG1XnrqbiiviJQfY7fIGqsIQThOVINKRkPHAPVh+7sU1izCe+XLYAdRvvpyN7HdV/SenG32pDN1Ig5eVrTZH+Z60VLiHU3ipDomKQzxT4yn6YNBNW4xhtgNkgnks7Bf/udbcnO3Sa8v8RJTFeWySMURtp01pqc2og+sMgFV1ItjXTdyP3ow/ZbJUZwEu5Wn0eQHR3dqRN+CRwKAGRC9KneuhnkB/Mbds9Lnn66dUK7WzNP3/nWZm4onJD/grn6rlAYmWQEl8EDhdi/mXbkizW7xAwsvELZgIgJ/Z/ajT10Y6OHXiltGv9Y5FMcE++bUxwQZtI2W2+/ouL28KqHGZhBTufqGj4mTQD82Ho+Aik3+DdhCYoLG8wtkINv4/aL9v8pFOKfrkHx0zOmCY8LjAK1933Qv6WKi26B8jqf5NAbJ2L4gwKKg3Gar8F8OiKgxIJcPjhUZESswZIs7I3tBU7ArFjgYhL9sK6yaOGNxMr4rZdG5A2Pe+PkNwdJUW/fRbEWUruBbWd4txtxd8u+DF
 dfX+S5cw
 f4F9NgWo96/zhZ1vNO0Y5ZR5Fhms9XzlfUOtxDOLffNgSFJYlHbQ/Racw85WC+tKVAcXEbXxqFr5mYdQZOUg6yqzIZmIXc956EUP6BBo0qEYiEE+8a27hMGJg5I229WKV+MY+8HupbW2MNrhzwjuoDUg4il9sTXrvTklr1itTvWGiqzUpPcXLBQ6PEvTRs9QfF6e5NlptdGKGP34LPd5hLyuAYoDkJdEe3xH92+IR2PL6zX+1aYPnfpfTBC4OxNnER5ICyv5+1eDqd5rdvd4iR77xXobCer8YWwQMlzdkEAx2f3bR1HcfJOwPdyp8IXVAncRKV4f6+Oior0531Ow7N4oEdNhPRZ1WSgzDz2tdcJv7vOZG0uac9HNsOqyMbA4fVxU2yC9/qET9MrV/FpoBvLcqG5erCyhPQUwpy4Nq0mn1m/W5aYcZRIpfyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-correctly-handle-UFFD-PTE-markers/20251103-204118
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes%40oracle.com
patch subject: [PATCH 10/16] mm: replace pmd_to_swp_entry() with leafent_from_pmd()
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20251103/202511032303.n4dF1k87-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251103/202511032303.n4dF1k87-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511032303.n4dF1k87-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/folio-compat.c:7:
   In file included from include/linux/migrate.h:9:
   In file included from include/linux/leafops.h:6:
>> include/linux/swapops.h:90:21: error: use of undeclared identifier 'MAX_SWAPFILES_SHIFT'
      90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
         |                            ^
   include/linux/swapops.h:27:45: note: expanded from macro 'SWP_TYPE_SHIFT'
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^
   include/linux/swapops.h:90:49: error: use of undeclared identifier 'MAX_SWAPFILES_SHIFT'
      90 |         ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
         |                                                        ^
   include/linux/swapops.h:28:34: note: expanded from macro 'SWP_OFFSET_MASK'
      28 | #define SWP_OFFSET_MASK ((1UL << SWP_TYPE_SHIFT) - 1)
         |                                  ^
   include/linux/swapops.h:27:45: note: expanded from macro 'SWP_TYPE_SHIFT'
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^
   include/linux/swapops.h:100:23: error: use of undeclared identifier 'MAX_SWAPFILES_SHIFT'
     100 |         return (entry.val >> SWP_TYPE_SHIFT);
         |                              ^
   include/linux/swapops.h:27:45: note: expanded from macro 'SWP_TYPE_SHIFT'
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^
   include/linux/swapops.h:109:21: error: use of undeclared identifier 'MAX_SWAPFILES_SHIFT'
     109 |         return entry.val & SWP_OFFSET_MASK;
         |                            ^
   include/linux/swapops.h:28:34: note: expanded from macro 'SWP_OFFSET_MASK'
      28 | #define SWP_OFFSET_MASK ((1UL << SWP_TYPE_SHIFT) - 1)
         |                                  ^
   include/linux/swapops.h:27:45: note: expanded from macro 'SWP_TYPE_SHIFT'
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^
>> include/linux/swapops.h:395:19: error: use of undeclared identifier 'SWP_PTE_MARKER'
     395 |         return swp_entry(SWP_PTE_MARKER, marker);
         |                          ^
   include/linux/swapops.h:448:15: error: use of undeclared identifier 'MAX_SWAPFILES_SHIFT'
     448 |         BUILD_BUG_ON(SWP_TYPE_SHIFT < SWP_PFN_BITS);
         |                      ^
   include/linux/swapops.h:27:45: note: expanded from macro 'SWP_TYPE_SHIFT'
      27 | #define SWP_TYPE_SHIFT  (BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
         |                                              ^
   include/linux/swapops.h:491:28: error: use of undeclared identifier 'MAX_SWAPFILES'
     491 |         return swp_type(entry) >= MAX_SWAPFILES;
         |                                   ^
   7 errors generated.


vim +/MAX_SWAPFILES_SHIFT +90 include/linux/swapops.h

099dd6878b9b12 Peter Xu       2021-06-15   82  
^1da177e4c3f41 Linus Torvalds 2005-04-16   83  /*
^1da177e4c3f41 Linus Torvalds 2005-04-16   84   * Store a type+offset into a swp_entry_t in an arch-independent format
^1da177e4c3f41 Linus Torvalds 2005-04-16   85   */
^1da177e4c3f41 Linus Torvalds 2005-04-16   86  static inline swp_entry_t swp_entry(unsigned long type, pgoff_t offset)
^1da177e4c3f41 Linus Torvalds 2005-04-16   87  {
^1da177e4c3f41 Linus Torvalds 2005-04-16   88  	swp_entry_t ret;
^1da177e4c3f41 Linus Torvalds 2005-04-16   89  
3159f943aafdba Matthew Wilcox 2017-11-03  @90  	ret.val = (type << SWP_TYPE_SHIFT) | (offset & SWP_OFFSET_MASK);
^1da177e4c3f41 Linus Torvalds 2005-04-16   91  	return ret;
^1da177e4c3f41 Linus Torvalds 2005-04-16   92  }
^1da177e4c3f41 Linus Torvalds 2005-04-16   93  
^1da177e4c3f41 Linus Torvalds 2005-04-16   94  /*
^1da177e4c3f41 Linus Torvalds 2005-04-16   95   * Extract the `type' field from a swp_entry_t.  The swp_entry_t is in
^1da177e4c3f41 Linus Torvalds 2005-04-16   96   * arch-independent format
^1da177e4c3f41 Linus Torvalds 2005-04-16   97   */
^1da177e4c3f41 Linus Torvalds 2005-04-16   98  static inline unsigned swp_type(swp_entry_t entry)
^1da177e4c3f41 Linus Torvalds 2005-04-16   99  {
3159f943aafdba Matthew Wilcox 2017-11-03  100  	return (entry.val >> SWP_TYPE_SHIFT);
^1da177e4c3f41 Linus Torvalds 2005-04-16  101  }
^1da177e4c3f41 Linus Torvalds 2005-04-16  102  
^1da177e4c3f41 Linus Torvalds 2005-04-16  103  /*
^1da177e4c3f41 Linus Torvalds 2005-04-16  104   * Extract the `offset' field from a swp_entry_t.  The swp_entry_t is in
^1da177e4c3f41 Linus Torvalds 2005-04-16  105   * arch-independent format
^1da177e4c3f41 Linus Torvalds 2005-04-16  106   */
^1da177e4c3f41 Linus Torvalds 2005-04-16  107  static inline pgoff_t swp_offset(swp_entry_t entry)
^1da177e4c3f41 Linus Torvalds 2005-04-16  108  {
3159f943aafdba Matthew Wilcox 2017-11-03 @109  	return entry.val & SWP_OFFSET_MASK;
^1da177e4c3f41 Linus Torvalds 2005-04-16  110  }
^1da177e4c3f41 Linus Torvalds 2005-04-16  111  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

