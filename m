Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F10ECAC597
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 02:37:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 814F38E00C3; Thu, 18 Sep 2025 22:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5358E0008; Thu, 18 Sep 2025 22:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4048E00C3; Thu, 18 Sep 2025 22:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55FDD8E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:37:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D065160555
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:37:40 +0000 (UTC)
X-FDA: 83904439080.13.B69028E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4803B1A0007
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:37:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pc16PK7N;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758249458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4OmscKP7caG1hctrOxPpLqadzGXFXMsf9gd/ZcKG/0Y=;
	b=TXickoF11ZnjFxmXYTQtsm+ef556hc3o1CbtbZ2dlqd4XjeALUeEwA2AkhCbOmVXzbupx4
	0oVY33rf94NgQ/G67XwPxc7Mn4gVQfjasXZIlnpo7TxoPRgTLqD5Ak24g66vXHcx0Bk0NF
	uzMmSXMSI8Ba0mglcpAhWxdsQnUGUGI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758249458; a=rsa-sha256;
	cv=none;
	b=7KTb/wxZ043hU0FeOtY8sTS3Ree/oEp1gU9Bgry/W0+FKMjIE1EVHXdHcq5dQ3BAmVSuu5
	CGWVRjzrYWHBowtToB8O7Kfp2+LCPSRHTPTr1zQ9FkeNEr7aRmW5U0IM6cyoyei/VEf4YC
	wZUyV467+Hh6R2dMwuROfRy7s/ER7ZA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Pc16PK7N;
	spf=pass (imf19.hostedemail.com: domain of lkp@intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758249457; x=1789785457;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=h5TvndhgvzWQ0fKI5pe8nKg8uL509Wn5hzYwPG8DYIQ=;
  b=Pc16PK7NiVlYnR2owpTo8yUbWmBRYcfFY6e4o2dJguyAx2z16imyPNDZ
   4x+2r/zwbvLtESzvJLC/M8MsKW7pk/GT5LuTMRmWj/aHQWbchURzdQo6y
   FXlfMygygoOuWloO9J7xAKZVjO7V68BK0HRYl8fsVfAg9xQg4PiKUQyyC
   6yBOcH1AXMFethgCUXaIElcxMuVTUBA7qGR0ctuGG7sQjGCPcnZWQA+ix
   3ApS+/EaFpfTgGEE7kcttinXFGUMvEwNWM7Bq7sV6+HetCdyvQYCTGh7d
   9rlMts1YDKcFyMAEqyWz5aKcJKo0ONLSEB0FokXdbxHjytflFCPKCtGnv
   Q==;
X-CSE-ConnectionGUID: 1Opi4gL/SdG0BApJ7V5P9w==
X-CSE-MsgGUID: kXmdi1/1Rb66sDAi78I03Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="78197323"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="78197323"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 19:37:36 -0700
X-CSE-ConnectionGUID: IZLqUNwjR7it8w3kD8lxdg==
X-CSE-MsgGUID: JF9OfBR1RL6vnkxS2ZwomQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176522880"
Received: from lkp-server01.sh.intel.com (HELO 84a20bd60769) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 18 Sep 2025 19:37:34 -0700
Received: from kbuild by 84a20bd60769 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uzR07-0003vP-2G;
	Fri, 19 Sep 2025 02:37:31 +0000
Date: Fri, 19 Sep 2025 10:37:27 +0800
From: kernel test robot <lkp@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: [akpm-mm:mm-everything 254/254] kernel/kexec_handover.c:970:50:
 error: passing argument 1 of 'kho_restore_page' makes integer from pointer
 without a cast
Message-ID: <202509191034.SM82Oaij-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: w6dzmrkpt37kuqzkwu1r8m86mdfbjxtc
X-Rspam-User: 
X-Rspamd-Queue-Id: 4803B1A0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758249457-243145
X-HE-Meta: U2FsdGVkX19yT/Pb2RADpBzzdxwIWMR2ROvXlgQFAtt5limIfH0wRSGt2Vtf9Rm48vKmIpGY2l9Ww8zhHcEzap/uGD2PkyGIBRWILnjF5j4UCTq6GKFPo0cVSBfxXgOJyUxgVlpvkQ7DwS1ITgg1ahsJen5uwrgdaep3L2C4UY14vhWYyrTosVGmq41rHoyKDCboGBZ7+PzpOQw/EfcPUJleEbU+h24iUof7V+Xeo5G02OMusuwWSuoPLCXJBYSgTuscOTPrvXXqeI/sQvSO46ZHCRkqe39LULGNr8kcNGvqItEx6Vj+43FMalav1Qse9BC+UNw8P3SmK/gvMVnQcdQZDxLtSDsyUv2LzskrgL9pyo2lAKxLQOMBfac9POh1Kwlf+YBKN9dN4UVgXMKIQEcCZZGB3+6A/mrNtISZSISZwmx4CWCKsAikmlSj81qzXHViD90R5F8VdVDCU4Lm1cxo+6yBYOmoER+f00ftaZfOb+/1KnKiluY2ZF+g2+dQ170ld4y9upgxMRAQAVu6BbUWN+1bVDKlHHVDAI7tVwzfNUYRnrxMeqo709XSCQ8wVztjLCUToiQZARMM4dge9ld5wsdPa8SfByVTcHahJBLnNMlB6RGqGwQ7S+neP+sj3rJz/kZw3RNs0hKWiIVeEiMYKnKXszSbHuhiTuqAWYLh+YQCof5DybiRXB/Zk/QMRaX+mp3y/ZuFE4jupp4QYHIiJpNSTV7j6L3BY7PehiGWtm0oQ2RJLPcEoveUGJySz1A8Fw1GHuQbNg0FzQzAzbcUDtccffkk16pwEu4aZ0FguFEna1UqhXAHIEokoubfrK/0L6gkrxOtqYdhjvmAp5xsJzs6fzQypUaEc7HhJ5uXAgzqSx8PDVbSZnckBnr3lxT+KpYGjBtHGWRTlG3PdgxASnggi7whaHgHp+1SvAdolBzpKJQ5fuOi3KoJz5Q4fV8iIgCTPBqPAjpKauZ
 Y+LtnOsQ
 /3WpJMUIhR189P96Ub4vb5PAyrVF5vnqaaSGRXsIIkoGUrSp55DfwPT1eUqzrW1td9ma/pP4bihDAjPO/b6mL2fQiNAW/KALGSmHOeHlGhCelG+4/YD0WoGBOUclNaAbWaJl2pt9nhiWi/l3jjvmvJUMS3CrKaidYTYYzeZzrkkSWYvshRX65x9nlvFipsWF8Mc3eYwomavENRZ8sql08u3BMDhC0s66qFlZXvNxUc+Z0V6PJkkNkcsP25YVzejBTI0Ri+bqeeDR17DsZcoCAmfHXelh9RsmujY/IiZ1Aa69EZyERruTaxmPXlHxKt7/zCi2pvQ48oAlyjXRki9HCYtqDxkQ78/ac7Yabmo0zRPlWHU636rmWoUPlscWPsJBFC/EqpHnLfrgJj9WPcEIwNPFqH9ClAf6vO1f4K+OesZQLTFbUnbeM1EoCdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
head:   46735c0743fed990d0ed8722a131ef54006c45a3
commit: 5369505b204b3fc65f839f7558640b6ecd675461 [254/254] foo
config: x86_64-randconfig-071-20250919 (https://download.01.org/0day-ci/archive/20250919/202509191034.SM82Oaij-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250919/202509191034.SM82Oaij-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202509191034.SM82Oaij-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/kexec_handover.c: In function 'kho_restore_vmalloc':
>> kernel/kexec_handover.c:970:50: error: passing argument 1 of 'kho_restore_page' makes integer from pointer without a cast [-Wint-conversion]
     970 |                                 kho_restore_page(page, 0);
         |                                                  ^~~~
         |                                                  |
         |                                                  struct page *
   kernel/kexec_handover.c:229:50: note: expected 'phys_addr_t' {aka 'long long unsigned int'} but argument is of type 'struct page *'
     229 | static struct page *kho_restore_page(phys_addr_t phys)
         |                                      ~~~~~~~~~~~~^~~~
>> kernel/kexec_handover.c:970:33: error: too many arguments to function 'kho_restore_page'
     970 |                                 kho_restore_page(page, 0);
         |                                 ^~~~~~~~~~~~~~~~
   kernel/kexec_handover.c:229:21: note: declared here
     229 | static struct page *kho_restore_page(phys_addr_t phys)
         |                     ^~~~~~~~~~~~~~~~
   kernel/kexec_handover.c:978:34: error: passing argument 1 of 'kho_restore_page' makes integer from pointer without a cast [-Wint-conversion]
     978 |                 kho_restore_page(page, 0);
         |                                  ^~~~
         |                                  |
         |                                  struct page *
   kernel/kexec_handover.c:229:50: note: expected 'phys_addr_t' {aka 'long long unsigned int'} but argument is of type 'struct page *'
     229 | static struct page *kho_restore_page(phys_addr_t phys)
         |                                      ~~~~~~~~~~~~^~~~
   kernel/kexec_handover.c:978:17: error: too many arguments to function 'kho_restore_page'
     978 |                 kho_restore_page(page, 0);
         |                 ^~~~~~~~~~~~~~~~
   kernel/kexec_handover.c:229:21: note: declared here
     229 | static struct page *kho_restore_page(phys_addr_t phys)
         |                     ^~~~~~~~~~~~~~~~


vim +/kho_restore_page +970 kernel/kexec_handover.c

1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   926) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   927) /**
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   928)  * kho_restore_vmalloc - recreates and populates an area in vmalloc address
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   929)  * space from the preserved memory.
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   930)  * @preservation: preservation metadata.
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   931)  *
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   932)  * Recreates an area in vmalloc address space and populates it with memory that
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   933)  * was preserved using kho_preserve_vmalloc().
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   934)  *
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   935)  * Return: pointer to the area in the vmalloc address space, NULL on failure.
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   936)  */
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   937) void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   938) {
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   939) 	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   940) 	unsigned int align, order, shift, vm_flags;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   941) 	unsigned int idx = 0, nr;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   942) 	unsigned long addr, size;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   943) 	struct vm_struct *area;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   944) 	struct page **pages;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   945) 	int err;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   946) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   947) 	vm_flags = kho_flags_to_vmalloc(preservation->flags);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   948) 	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   949) 		return NULL;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   950) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   951) 	nr = preservation->total_pages;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   952) 	pages = kvmalloc_array(nr, sizeof(*pages), GFP_KERNEL);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   953) 	if (!pages)
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   954) 		return NULL;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   955) 	order = preservation->order;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   956) 	shift = PAGE_SHIFT + order;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   957) 	align = 1 << shift;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   958) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   959) 	while (chunk) {
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   960) 		struct page *page;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   961) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   962) 		for (int i = 0; chunk->phys[i]; i++) {
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   963) 			phys_addr_t phys = chunk->phys[i];
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   964) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   965) 			if (idx + (1 << order) > nr)
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   966) 				goto err_free_pages_array;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   967) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   968) 			for (int j = 0; j < (1 << order); j++) {
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   969) 				page = phys_to_page(phys);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  @970) 				kho_restore_page(page, 0);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   971) 				pages[idx++] = page;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   972) 				phys += PAGE_SIZE;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   973) 			}
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   974) 		}
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   975) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   976) 		page = virt_to_page(chunk);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   977) 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   978) 		kho_restore_page(page, 0);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   979) 		__free_page(page);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   980) 	}
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   981) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   982) 	if (idx != nr)
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   983) 		goto err_free_pages_array;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   984) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   985) 	area = __get_vm_area_node(nr * PAGE_SIZE, align, shift, vm_flags,
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   986) 				  VMALLOC_START, VMALLOC_END, NUMA_NO_NODE,
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   987) 				  GFP_KERNEL, __builtin_return_address(0));
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   988) 	if (!area)
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   989) 		goto err_free_pages_array;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   990) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   991) 	addr = (unsigned long)area->addr;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   992) 	size = get_vm_area_size(area);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   993) 	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   994) 	if (err)
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   995) 		goto err_free_vm_area;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   996) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   997) 	area->pages = pages;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   998) 	area->nr_pages = nr;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17   999) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1000) 	return area->addr;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1001) 
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1002) err_free_vm_area:
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1003) 	free_vm_area(area);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1004) err_free_pages_array:
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1005) 	kvfree(pages);
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1006) 	return NULL;
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1007) }
1e0bdd5d414970 Mike Rapoport (Microsoft  2025-09-17  1008) EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
fc33e4b44b2717 Mike Rapoport (Microsoft  2025-05-09  1009) 

:::::: The code at line 970 was first introduced by commit
:::::: 1e0bdd5d4149706f75f7f3bcc952bc963f352e2b kho: add support for preserving vmalloc allocations

:::::: TO: Mike Rapoport (Microsoft) <rppt@kernel.org>
:::::: CC: Andrew Morton <akpm@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

