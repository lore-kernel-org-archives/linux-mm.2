Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAC54FC9ECB
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 04:05:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DE2C6B0089; Fri,  6 Mar 2026 23:05:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094FC6B008A; Fri,  6 Mar 2026 23:05:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78396B008C; Fri,  6 Mar 2026 23:05:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF0336B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 23:05:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8673B1A04C7
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:05:51 +0000 (UTC)
X-FDA: 84517928502.07.FE75A48
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8010614000B
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 04:05:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N6rgNZaV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772856349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=zHuXVPim+hIkFrbmdT/riYDZGjPHj34eitKY9y5WM7o=;
	b=C2F/C4jAvAuwmcjUAJQ+0sYKy+KiHZ4K+BzBsO0uEXd8ua76b291k0SvQ67dpR6QgE5Un6
	PqKSurJ/HOuxi9yJBBr33mSUZkLnUQ2FOE0UcFvB+paZaMok7fsSHWDCMhs3b6SRrE8Ako
	RsEhgEQA0d9H2Xl8+bRfGx+PL4dZvUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772856349; a=rsa-sha256;
	cv=none;
	b=Mqpn3bT+tGH7V1jtuUijgwukUdulj49fKHzf16fpDQkkBuRja7VJlpXI48NuHEudBvHBAn
	UPYU5CIfLrO9UX8pC9rpDGrKE1hSGN8ODlxvmqzNAsK/cO0BBlhMLcTlgM7Pl8UrYmWJvB
	iJc6GPZkOmdLH7ZPh3+Sa55kOaWaNgM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=N6rgNZaV;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=lkp@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772856350; x=1804392350;
  h=date:from:to:cc:subject:message-id;
  bh=dF5amXua2iK/Qs7c+TgqaoVGmwfmgrUCxP1NrcCKbCo=;
  b=N6rgNZaVxSCIucFspygnXZfsuC6alq60FmHmfdNPNJE9UviEG6pvBwKx
   yU/np8B3ckuPv2HsR17PVFxqmcIGAOjUpy1kn8sSnRx6owi1mXB/e5Y+r
   OW+OH74anoq+TaQPuUwRwpOV0VljbRC0J/cVTKuDosv6O4NdIbn5RTbtG
   Rd+v9ru0vwtssk1KQJcC6c6sQsSPZDY7Q7DqP3J0Fgl3myAFRgi2VLt3i
   UAjS4AaXOvt0WJr5Gzm7CWve4dtN4RImtH5rBZ7/MRX0cDKWRNWkIC9bw
   7j0BUY9wN+eQBhEz+b8JZKBIruA9yJzPG8Ar5yxg3YGmIBKWWI65IjSLg
   A==;
X-CSE-ConnectionGUID: 1jAwxxR0TAqkezkl4i58Cw==
X-CSE-MsgGUID: M6Yq76GxSc2NUvx3a2bVWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11721"; a="77814839"
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="77814839"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 20:05:47 -0800
X-CSE-ConnectionGUID: YSYIdRfcT/yCBxERlj8N8Q==
X-CSE-MsgGUID: 2SPV/+/qTJW3vATg0pffng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,106,1770624000"; 
   d="scan'208";a="224151077"
Received: from lkp-server01.sh.intel.com (HELO 058beb05654c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 06 Mar 2026 20:05:44 -0800
Received: from kbuild by 058beb05654c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vyiv3-000000001ff-0kbE;
	Sat, 07 Mar 2026 04:05:37 +0000
Date: Sat, 07 Mar 2026 12:04:55 +0800
From: kernel test robot <lkp@intel.com>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-unstable 34/207] include/linux/hugetlb.h:1214:9:
 error: call to undeclared function 'linear_page_index'; ISO C99 and later do
 not support implicit function declarations
Message-ID: <202603071118.PmcGAhcg-lkp@intel.com>
User-Agent: s-nail v14.9.25
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8010614000B
X-Stat-Signature: 4b17j3ysjdgo15kn9zgao1z9qs7uujfu
X-Rspam-User: 
X-HE-Tag: 1772856349-432535
X-HE-Meta: U2FsdGVkX19wvYS6WpMnaHHyfQE1Sok9G+lCAn6gEDNDw95hp811/MuAgasJbKzlldfjVJOGxRg3hnn8bqIP/ShT5H6ENAqdYwvAxoiFY+gDJn+pRgpwBu2wXnJ5aRXndLOFHZpaxqzpZcQOkbl91wyq3NSEaVuVAuv265EE5TX8nKG13JCcxcN1K+b3t460QxwW3Hivg85CXwCG5UqH5u34fvxxir2BVcNZa2Uw1OJGUhe4sL3a/d7+P8wGpG94i0+a4NBlJ2uGdNs8QbwzPLPdQczPnpB7FKokb05gfGz/7uWfArcxQEpIhjynAZCesQeGpbY4306J1GHEVE4qxZ++N5vNXHyWpbP87OBN3f5EIH3EA40Akad9L9nC8WpmverokkLpJO1mnkSVWEjgaZq8Ivb2yiKQgadWMktOM8jS7uPK9XO7eGbawplaO8qRJ36i0qOqGR6yO+5HyLEvXec5UFewieexCInASvS0yu2g25Tijnb+cxP1dWoL0h3oVVpf23xvFk41/WJ3He810+in6ICxwclRZhTM+j+oGpL7FHY91P/7HT1HQLwXbO5GLt5nMT73jJFgKX53Fb3Q+aKRxpyhAg1TA9WeEooUB3s5mWc6G1gJB9yNGbVMxzsMGfnI+vCT7k5wZ6doM4JZKdlfueF5E5mjIq/NHm7ziMSB7YI8vMAKiE9ZKW0yDzwwa6tDkPtxuiIQYQ47jwwL3/+6zkfqHSqfgeuuQl0fCSEZv8+r/tFUG9XCYS7e+DFUHbmiIxXyK+cy+bEni5TubUVv7+mhkcFmRM+m1dHk3v3fgseCjvUV3V2BjMFm4nK8L0XMI/ldOHORMkuafPt5RnXgyCP0z0xqJLvrQ0ApsNyoJL2hbY+jqE7Ib2pL8xvcEJwm3USaoF2FZya8zqzweLxGwGfET1FEzM7D7XBdLBqbMq+zYHevuGQO2ANLTrd7O10GNnn16MWOLf6WjfW
 2L+raeO6
 V2tA1IGLPMbsy6NXwzSTU23B3jTHuxmNsCVQfRS/K8QqT216VQOuFL9zula1sDv4FMZM2T6yPPtrIyIlx2Jf9zjzyzoNI/5J9Fck5x6+jEkBhMOHuNmCKxnhWsj7D9KuthdjHE202RDae6mDAJLAJtZNBwcN7GC+fBtnoWQWfV3Lje/FtTuxlW00NSae3um/PSHEFy3Jo6P7xo89oXILAuw+PHwG2uuZV0uYkuCsjIzzor0oF0dTq9m404QMwZbbkII0H2L20+jJuhyJDFN3fEE18Q19TOG344L4vj3M/OhgK+I+D9rgkIEIXJBNmZUblzXex
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
head:   49cb736d092aaa856283e33b78ec3afb3964d82f
commit: cd9119a9480d9d93fdf06792f8f9917cc4f9999c [34/207] mm/userfaultfd: fix hugetlb fault mutex hash calculation
config: x86_64-allnoconfig (https://download.01.org/0day-ci/archive/20260307/202603071118.PmcGAhcg-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260307/202603071118.PmcGAhcg-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202603071118.PmcGAhcg-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from mm/show_mem.c:12:
>> include/linux/hugetlb.h:1214:9: error: call to undeclared function 'linear_page_index'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1214 |         return linear_page_index(vma, address);
         |                ^
   In file included from mm/show_mem.c:15:
   In file included from include/linux/swap.h:13:
>> include/linux/pagemap.h:1079:23: error: conflicting types for 'linear_page_index'
    1079 | static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
         |                       ^
   include/linux/hugetlb.h:1214:9: note: previous implicit declaration is here
    1214 |         return linear_page_index(vma, address);
         |                ^
   2 errors generated.
--
   In file included from mm/vma_init.c:8:
   In file included from mm/vma_internal.h:20:
>> include/linux/hugetlb.h:1214:9: error: call to undeclared function 'linear_page_index'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1214 |         return linear_page_index(vma, address);
         |                ^
   In file included from mm/vma_init.c:8:
   In file included from mm/vma_internal.h:23:
   In file included from include/linux/ksm.h:13:
>> include/linux/pagemap.h:1079:23: error: conflicting types for 'linear_page_index'
    1079 | static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
         |                       ^
   include/linux/hugetlb.h:1214:9: note: previous implicit declaration is here
    1214 |         return linear_page_index(vma, address);
         |                ^
   In file included from mm/vma_init.c:8:
   In file included from mm/vma_internal.h:31:
   include/linux/mman.h:157:9: warning: division by zero is undefined [-Wdivision-by-zero]
     157 |                _calc_vm_trans(flags, MAP_SYNC,       VM_SYNC      ) |
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mman.h:135:21: note: expanded from macro '_calc_vm_trans'
     135 |    : ((x) & (bit1)) / ((bit1) / (bit2))))
         |                     ^ ~~~~~~~~~~~~~~~~~
   1 warning and 2 errors generated.
--
   In file included from mm/mprotect.c:13:
>> include/linux/hugetlb.h:1214:9: error: call to undeclared function 'linear_page_index'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1214 |         return linear_page_index(vma, address);
         |                ^
   In file included from mm/mprotect.c:15:
   include/linux/mman.h:157:9: warning: division by zero is undefined [-Wdivision-by-zero]
     157 |                _calc_vm_trans(flags, MAP_SYNC,       VM_SYNC      ) |
         |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/mman.h:135:21: note: expanded from macro '_calc_vm_trans'
     135 |    : ((x) & (bit1)) / ((bit1) / (bit2))))
         |                     ^ ~~~~~~~~~~~~~~~~~
   In file included from mm/mprotect.c:19:
   In file included from include/linux/mempolicy.h:16:
>> include/linux/pagemap.h:1079:23: error: conflicting types for 'linear_page_index'
    1079 | static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
         |                       ^
   include/linux/hugetlb.h:1214:9: note: previous implicit declaration is here
    1214 |         return linear_page_index(vma, address);
         |                ^
   1 warning and 2 errors generated.


vim +/linear_page_index +1214 include/linux/hugetlb.h

  1210	
  1211	static inline pgoff_t vma_hugecache_offset(struct hstate *h,
  1212			struct vm_area_struct *vma, unsigned long address)
  1213	{
> 1214		return linear_page_index(vma, address);
  1215	}
  1216	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

