Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C82EB10F3DDF
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 09:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59E16B008C; Sat, 28 Mar 2026 05:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E314A6B0095; Sat, 28 Mar 2026 05:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6DDE6B0096; Sat, 28 Mar 2026 05:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C88266B008C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 05:55:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 617F813C891
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:55:24 +0000 (UTC)
X-FDA: 84595014168.05.EAE2441
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf24.hostedemail.com (Postfix) with ESMTP id 78B03180009
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 09:55:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hkuxzz9E;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774691722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gknCErwFLXx695YJjbLTqwIvARUBNy1rmhVtqZDtwbE=;
	b=rqHHcVsTR8o9BW95PxHhpI3eSNPxmoQ7mBPwno0zXwd4CGXQhcS9IqXMKdOHk/bGwJjqYY
	Bb2T6haNoikfOALW1TasdFkWejkmIPdJxlwZUbF09TzKcdIOG4CC9ZINxnqQXQKNqLKkZs
	w54sfAUlkdd4Kh3yIi2/RIjLk6NFraI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Hkuxzz9E;
	spf=pass (imf24.hostedemail.com: domain of lkp@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774691722; a=rsa-sha256;
	cv=none;
	b=6tLcnLAfxv54AMKvGHC6cwHFas1dg8uV0Llw+b2Lrmfb6xD0gzaoBhTQIZeTpbYtZR2PYo
	U5Ps2LB7BTNjrb1xDchClRCUP3rJxLjK1M7kaHUOIQoEDd1e4hQ7lhNRdwwhVZ8v9BGt/I
	SriTGFWW5dLxAU+0fJbD5U62Yz6fnN8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774691721; x=1806227721;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tGRNjEkmKkP55RyI36TLF24P2O39ClA0J2pu35ocaXQ=;
  b=Hkuxzz9EHUNvU0EM4Vb8gqXVbxRi/wlLh+g82DQaDrsTNs7f/sUFh32F
   kIq8tcCThrRt329pMoVqQs+vZM1iUQEI/1aky9F+xdjnM3jYpcsJ48AvM
   kq/0g5eYnU4N+fOOOJU0vWnB4CcuLzAlMRnWRgUAqeGMfUUPLNm06O+38
   3TpCzZeL/ClVV6ECXhuy19BSyeMdKzbB2fH0ZoM+aYwqZ5jqsFUjSGudV
   9TqzJmmtEy1bnHnzHmd4vqWZLWRiwNQjcfoaBUY5CqXmi6ZmQViQl0gf4
   rCoM90f+cwDM9VaJ55e8tdaSHgYMKpHfbgJ+bl6fVaLkPeGfas+g5WREw
   A==;
X-CSE-ConnectionGUID: 2tvuNsMYRdOfJDvfxePlcA==
X-CSE-MsgGUID: bd3ch3jiS/i0LoeDEIxkKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75633819"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75633819"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2026 02:55:19 -0700
X-CSE-ConnectionGUID: v9BKKQRJS6W2wyd96Ksx5Q==
X-CSE-MsgGUID: kuXnB5WIS620/P7LJwxCMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="248786208"
Received: from lkp-server01.sh.intel.com (HELO 3905d212be1b) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 28 Mar 2026 02:55:13 -0700
Received: from kbuild by 3905d212be1b with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1w6QNp-00000000BI1-3ouf;
	Sat, 28 Mar 2026 09:55:09 +0000
Date: Sat, 28 Mar 2026 17:54:51 +0800
From: kernel test robot <lkp@intel.com>
To: Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: oe-kbuild-all@lists.linux.dev, Chris Mason <chris.mason@fusionio.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v1 07/10] mm/truncate: use folio_split() in
 truncate_inode_partial_folio()
Message-ID: <202603281704.ILlsxaUM-lkp@intel.com>
References: <20260327014255.2058916-8-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260327014255.2058916-8-ziy@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: de3pk6iyopdhkrehp1gwmm4xdjuoc6bf
X-Rspamd-Queue-Id: 78B03180009
X-Rspamd-Server: rspam09
X-HE-Tag: 1774691721-979934
X-HE-Meta: U2FsdGVkX1/QBS8sgiHFkjNGwPcPoVrv8I5xgEZD09uQbjpXjCdWb90skJiLH1hBKJzgtiOXWMPc3wDZludIHn6x9bzlrSik/Qohv1HZbHmoJtboxeiT8r8G8wt/K8lU2wXoQ9LoEfvNHU+JfTATgo0xnE42YRDDfW1jN2B/FPgxs1QZBfMbhpuQy2Fr7lSXdnXMl5JERr0iru2leDxjcvy2pF31Q4ZaIpnEXrRcZQ8oJ8zEWq2HObYlMWc2Hkh01QIAl45mtLO/efbWVMLowcXjv2w1fdcgYr6N9MmNS5Mc1zm4erBYjNTlqtkKiuJU70rxRkxF8ahnm0Cb7rlGGWLTrleKaKVvEgArfP0SmIbdfQtyVH7UMEQf8Z8NgmcmDnRZ26l1lCbDJd4FpHG6e/xCI+9AfgEfZ7zhXh3XbFSO6vA5G2zS991WQK7QOnkgw4x+6tKpeDlrcIfkwR/0RuSViB5XUlPeAgwKSsxTnQ2f9R8PLCiekZ14q6q0OsPh5BMurGzW5GbhZkSX0vVDGWt0cQqiTY8jOTu9Qhj9+At0cqS87dH+xfb/TP51x7dWvgMH/T5URXW6geAEekVnF+y56HobGlDMBpgxUh4elP+nVoc8bo9qZitBLYagUdcqwzH8kz+FLzlHyi19KcVoEhhicjmtUVdG2J55NhUj3EtnL3pF33ywr/cpLdIFTJDQw3er0JQ6NFDlryIthr4H45eparO5QpMds1VqlOUrUEamatZt6GJU2TKHoHaCsPg+6zcdU36TysD1gmwQR4P+RuvxARA6kVBtcimii2usqgSiIt5/vlyu8w2HD9Udpm2vvjPWtzMRvtz+wsPOEO761i5+EycPgyf/L9vhNDuibooTsuKCQVypPcHesbs/HWUfUQMZ/aLrh8tSV59q7ldLJM2tiwzI3m/h2xl3FRu7GFSH3uSCbvwSoL3R7WyL+vAdHChvNUtVWzj70Ebtxzb
 BlWAn84K
 mmKKCUpCCusdyyKQDHK31LbeibSkmISd26FfXJXFCD+iGXAFqn3E+CYTnS/PM8axAEOwz2NyV1fyBK5gnTJRtM1FcDXOgxp2WkJLsHJ0UxjBdiT0HEtEXoXthHqGwXtiUMZw2r16wCi2VdZNcsGKpPW5sptMgXgvUPVvWOpLal+nLNessGq0+L53ubEJn5J6oOCW56BSvZLcw0dy9IJ6y2hOmX9OED6RjLZWQiGqVEpq7A3YWa9ux+eLWKE4ecI7fzHLF9pD/m/xLRRqW7G1kZ1/R2oRLWL2e4GisCZQlAPxlE1pX0Z1zBpSlqi/8WapLBNHTEu1UtxGzusrG4r44zdAP1ysSM9tlqLjJdojKemXlH7g6zopt49XyfybA5VQt1GvY0giUxmoLRAPUFWz6H7h+tyb7e6a4H5xAG2YMqwkOK+nAgFRXxxUvmDE9eaUH3qmD7wwZFxx2JNg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]
[also build test ERROR on brauner-vfs/vfs.all kdave/for-next linus/master v7.0-rc5 next-20260327]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zi-Yan/mm-remove-READ_ONLY_THP_FOR_FS-Kconfig-option/20260327-142622
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20260327014255.2058916-8-ziy%40nvidia.com
patch subject: [PATCH v1 07/10] mm/truncate: use folio_split() in truncate_inode_partial_folio()
config: nios2-allnoconfig (https://download.01.org/0day-ci/archive/20260328/202603281704.ILlsxaUM-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260328/202603281704.ILlsxaUM-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603281704.ILlsxaUM-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from include/linux/mm.h:1746,
                    from include/linux/pid_namespace.h:7,
                    from include/linux/ptrace.h:10,
                    from arch/nios2/kernel/asm-offsets.c:10:
>> include/linux/huge_mm.h:625:1: error: expected identifier or '(' before '{' token
     625 | {
         | ^
>> include/linux/huge_mm.h:623:19: warning: 'folio_split' declared 'static' but never defined [-Wunused-function]
     623 | static inline int folio_split(struct folio *folio, unsigned int new_order,
         |                   ^~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:184: arch/nios2/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1337: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:248: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:248: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +625 include/linux/huge_mm.h

e220917fa50774 Luis Chamberlain 2024-08-22  622  
9ee18d22957981 Zi Yan           2026-03-26 @623  static inline int folio_split(struct folio *folio, unsigned int new_order,
9ee18d22957981 Zi Yan           2026-03-26  624  		struct page *page, struct list_head *list);
7460b470a131f9 Zi Yan           2025-03-07 @625  {
a488ba3124c82d Pankaj Raghav    2025-09-05  626  	VM_WARN_ON_ONCE_FOLIO(1, folio);
a488ba3124c82d Pankaj Raghav    2025-09-05  627  	return -EINVAL;
7460b470a131f9 Zi Yan           2025-03-07  628  }
7460b470a131f9 Zi Yan           2025-03-07  629  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

