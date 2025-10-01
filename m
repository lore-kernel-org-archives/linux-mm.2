Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3C99CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 18:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3548E0005; Wed,  1 Oct 2025 14:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB0C8E0002; Wed,  1 Oct 2025 14:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8998E0005; Wed,  1 Oct 2025 14:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE0878E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:16:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 99FFB139CCC
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 18:16:06 +0000 (UTC)
X-FDA: 83950349532.11.52B0B9A
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id C741E14000E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 18:16:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RW5fzXJT;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759342564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Mdub60HiTWo+g+tF/XVv2omv5wDiDEFkmBEPHIx+T4=;
	b=k2kqLD2gGIcG2W4C9blBKQEQF7DyPnvkPkLuOAo9U3ev6m/XSipro6+LLaXWlavx6LmB6H
	8wFVEu5ft3enVwTUUyg5KuzCnYZ6ghZj5FXgMuzqRu3BIUN7pYZzCsU7438W6xLABvRj1x
	KJzlexLZxO+LbttUjfOHVjxYoaiY0hg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759342564; a=rsa-sha256;
	cv=none;
	b=R9J6UwnaqXN/HI5KXmibLVwTQ2vLR/EY7yLqDj97ENLSGZWk2OO55jgE9bhit7S/kdpp9V
	3+ZcdQTnsP37XdH8JLXB+SY0XOVh4vesoBPE4Ssvnwtmb+Th7+RC8mWJH3HgwECVh+N64i
	wVb2exo4F2j/RLxsPwKEnVpZy03DEL8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=RW5fzXJT;
	spf=pass (imf26.hostedemail.com: domain of lkp@intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=lkp@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759342564; x=1790878564;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qcrmoc3s3sksxYRsdt5U6g9JOBi2RNp8WJie6nSUIYk=;
  b=RW5fzXJTu93OznJc9CK2ZOVr5OSsd23zSb+d7KzE5fI7GmseOe4ysNfm
   rJV1mPTsmHTeT4AHmnHERqcrdGCbEu7YSaZlS+XoUYZS7sn/1uEDEnayw
   jqwG5mDsAafuMDHvzGTn0lhPRceIQJbdowKDMulV70WKlS872LB72Nth9
   e9cOgC/DnCB0wHkYEk+hhS1XsZw2Mv3D93a6+GoZYHDZQEHYadr7AFfv+
   h0S7vFHkSfLgzO4/+1ZRpSIlKkWYRPlE3vdM6uFYLWijFJre8IIIciWYD
   eFDbnZOhtAVmNU4zpmNegY/qXzl3tdSxE3Nmd6m+YyPHK8cElUgJ7WNft
   g==;
X-CSE-ConnectionGUID: Iw59p4tbQ3e7ljxqOjvypQ==
X-CSE-MsgGUID: AULYg1lxQKurWr8xoAaVdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="61790921"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="61790921"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 11:08:35 -0700
X-CSE-ConnectionGUID: WdspEPscT/meykkINjzoBA==
X-CSE-MsgGUID: rPWEaq2eSuK3OcfRFceIAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208";a="179266909"
Received: from lkp-server01.sh.intel.com (HELO 2f2a1232a4e4) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 01 Oct 2025 11:08:30 -0700
Received: from kbuild by 2f2a1232a4e4 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v41Fc-0003Fb-0f;
	Wed, 01 Oct 2025 18:08:28 +0000
Date: Thu, 2 Oct 2025 02:07:46 +0800
From: kernel test robot <lkp@intel.com>
To: Jason Miu <jasonmiu@google.com>, Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH v1 3/3] kho: Remove notifier system infrastructure
Message-ID: <202510020105.a05LM8TX-lkp@intel.com>
References: <20251001011941.1513050-4-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251001011941.1513050-4-jasonmiu@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C741E14000E
X-Stat-Signature: hy7ezupabyufo6eiuemgwpdnq4gej6uf
X-Rspam-User: 
X-HE-Tag: 1759342563-939417
X-HE-Meta: U2FsdGVkX1/R5fu/bKF1P2Z9FU3/gN7SQvhR1UEoWQRWMJdWtlVMJ4Aw13r1ln+bIG4T7vgyGuB2JVgVYVqsczSb+hJVzsK8UtrOqclqXeL9s82pPPF5/g4PmdavotvbbTN/CxNp14U6FGKlfCX51Yol3GPe3a8kGHrzpLdCeJ72EKMFUViq0tDAJNZDb5hV7S+8lfV0O7V7eibXR2sIOQp6d+zRs7RjOSCaJyN/oQiSIKypVvNY3cr0v7cIIk4MKzJFZEa+OfmaxQAvC+NZX1aTnQD+avBYsGrgwD3fYhjQE9ek6vqX0QlHYMb/nKXMzzxYS3OpdwVIkXtU7VVZo0v6ohnFtUyorcFgM/PEd0k7dnWliwgH3btaBw8rZ1CCLBEDmadsWGy6X3oTYxqfSnDBo9/eSMPSoURi3SvniVhOhCJfh0xWUDqn9QJKgCPJV7ep1ptoN3TP1f3QT5jrEaXY/8gD8u2LHft/J5YPWslSXTAPxl4Z/rCVSkJAyn28xM9sT+Uur7W+W+oI4wZqhClixiYE/F7AKlWahx24YZVi+qMqOOnaRk6GiDNDdAMcGE5/KRrhrdQFvJBz8hQiyO0oDbcpViKDh6Gpk7ye9Cqy+e7LY3UX8EDb9z5v1iezNsqwghfCsQoP7DfU2Rg07Y3N18hsDos36HE3l6cj4B745p2H+RIrkTdpa8p1lfdsY7akgkV2miwLXfAfUm+F2qxciUuN4wqP6l0R/gG+wPaOa1v9xISa5d6YzKdD/Eul908ZZd4DJgnoNtKmdg3igiECUV8oMojwkcdZVFWEchBkLxRqSxCZjohSwjMhq1ABYm/LRhGlx7ijS2OThfFT+4sRFfuikdjTgIlqBvN7BH5d7hVPhzBz6zjBkYYeREa7fILt+ew6VbV2hAyM42tBIKD7+LqdwtmOU6B06xJKW61D2MqsG1lCkZ2p1BqkPINsBgHZoLcb14bEu7w9VHh
 sWs3mkxg
 r46xmCW8IHDNpkf2L6eJzV5SiC8kna+1wqVkzXoc9PyzYDwmwt1PMOy4wRdk1/kvYpe3slUh0L46L1nN/oH/s1QG5FmYGN+cajiVmJVf4KsQE4fHI4MRf6WHtIpiuPqAzGY+ftnipybcPEKh6NtZYu8PV3eq8kU08BOW+IkoHwJhtmKavE0+hfUX2dwFUxKYaZnxYTZqmysRSUAXkg3PMuX8ZlTNNdzvPjpfdNlVyIkYxawFmjALhDTlv2yXeOmNVeUo3oZep3fJewOfp7MOakVoXLm8pVXdm+7emXsp1PJ3EgouRqHJGSqdUYZCQCl5LwFhltzzqxQTy3YLPWMxtIrkvdr8XZXsFSEg5NADD3owWjPJko7AqoWQaHfbGw5Hh4OJ1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

kernel test robot noticed the following build errors:

[auto build test ERROR on rppt-memblock/for-next]
[also build test ERROR on linus/master v6.17]
[cannot apply to rppt-memblock/fixes akpm-mm/mm-everything next-20250929]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jason-Miu/kho-Adopt-KHO-radix-tree-data-structures/20251001-092230
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git for-next
patch link:    https://lore.kernel.org/r/20251001011941.1513050-4-jasonmiu%40google.com
patch subject: [PATCH v1 3/3] kho: Remove notifier system infrastructure
config: x86_64-randconfig-003-20251001 (https://download.01.org/0day-ci/archive/20251002/202510020105.a05LM8TX-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251002/202510020105.a05LM8TX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510020105.a05LM8TX-lkp@intel.com/

All errors (new ones prefixed by >>):

>> lib/test_kho.c:49:7: error: use of undeclared identifier 'KEXEC_KHO_ABORT'
      49 |         case KEXEC_KHO_ABORT:
         |              ^
>> lib/test_kho.c:51:7: error: use of undeclared identifier 'KEXEC_KHO_FINALIZE'
      51 |         case KEXEC_KHO_FINALIZE:
         |              ^
   lib/test_kho.c:59:44: error: too many arguments to function call, expected 2, have 3
      59 |         err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
         |                ~~~~~~~~~~~~~~~                    ^~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/kexec_handover.h:21:5: note: 'kho_add_subtree' declared here
      21 | int kho_add_subtree(const char *name, void *fdt);
         |     ^               ~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> lib/test_kho.c:194:9: error: call to undeclared function 'register_kho_notifier'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     194 |         return register_kho_notifier(&kho_test_nb);
         |                ^
   lib/test_kho.c:194:9: note: did you mean 'register_module_notifier'?
   include/linux/module.h:745:5: note: 'register_module_notifier' declared here
     745 | int register_module_notifier(struct notifier_block *nb);
         |     ^
>> lib/test_kho.c:298:2: error: call to undeclared function 'unregister_kho_notifier'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
     298 |         unregister_kho_notifier(&kho_test_nb);
         |         ^
   lib/test_kho.c:298:2: note: did you mean 'unregister_module_notifier'?
   include/linux/module.h:746:5: note: 'unregister_module_notifier' declared here
     746 | int unregister_module_notifier(struct notifier_block *nb);
         |     ^
   5 errors generated.


vim +/KEXEC_KHO_ABORT +49 lib/test_kho.c

b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   40) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   41) static int kho_test_notifier(struct notifier_block *self, unsigned long cmd,
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   42) 			     void *v)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   43) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   44) 	struct kho_test_state *state = &kho_test_state;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   45) 	struct kho_serialization *ser = v;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   46) 	int err = 0;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   47) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   48) 	switch (cmd) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  @49) 	case KEXEC_KHO_ABORT:
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   50) 		return NOTIFY_DONE;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  @51) 	case KEXEC_KHO_FINALIZE:
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   52) 		/* Handled below */
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   53) 		break;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   54) 	default:
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   55) 		return NOTIFY_BAD;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   56) 	}
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   57) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   58) 	err |= kho_preserve_folio(state->fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   59) 	err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   60) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   61) 	return err ? NOTIFY_BAD : NOTIFY_DONE;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   62) }
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   63) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   64) static struct notifier_block kho_test_nb = {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   65) 	.notifier_call = kho_test_notifier,
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   66) };
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   67) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   68) static int kho_test_save_data(struct kho_test_state *state, void *fdt)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   69) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   70) 	phys_addr_t *folios_info __free(kvfree) = NULL;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   71) 	int err = 0;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   72) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   73) 	folios_info = kvmalloc_array(state->nr_folios, sizeof(*folios_info),
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   74) 				     GFP_KERNEL);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   75) 	if (!folios_info)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   76) 		return -ENOMEM;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   77) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   78) 	for (int i = 0; i < state->nr_folios; i++) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   79) 		struct folio *folio = state->folios[i];
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   80) 		unsigned int order = folio_order(folio);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   81) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   82) 		folios_info[i] = virt_to_phys(folio_address(folio)) | order;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   83) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   84) 		err = kho_preserve_folio(folio);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   85) 		if (err)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   86) 			return err;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   87) 	}
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   88) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   89) 	err |= fdt_begin_node(fdt, "data");
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   90) 	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   91) 			    sizeof(state->nr_folios));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   92) 	err |= fdt_property(fdt, "folios_info", folios_info,
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   93) 			    state->nr_folios * sizeof(*folios_info));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   94) 	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   95) 	err |= fdt_end_node(fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   96) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   97) 	return err;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   98) }
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27   99) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  100) static int kho_test_prepare_fdt(struct kho_test_state *state)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  101) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  102) 	const char compatible[] = KHO_TEST_COMPAT;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  103) 	unsigned int magic = KHO_TEST_MAGIC;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  104) 	ssize_t fdt_size;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  105) 	int err = 0;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  106) 	void *fdt;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  107) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  108) 	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  109) 	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  110) 	if (!state->fdt)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  111) 		return -ENOMEM;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  112) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  113) 	fdt = folio_address(state->fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  114) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  115) 	err |= fdt_create(fdt, fdt_size);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  116) 	err |= fdt_finish_reservemap(fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  117) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  118) 	err |= fdt_begin_node(fdt, "");
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  119) 	err |= fdt_property(fdt, "compatible", compatible, sizeof(compatible));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  120) 	err |= fdt_property(fdt, "magic", &magic, sizeof(magic));
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  121) 	err |= kho_test_save_data(state, fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  122) 	err |= fdt_end_node(fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  123) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  124) 	err |= fdt_finish(fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  125) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  126) 	if (err)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  127) 		folio_put(state->fdt);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  128) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  129) 	return err;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  130) }
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  131) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  132) static int kho_test_generate_data(struct kho_test_state *state)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  133) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  134) 	size_t alloc_size = 0;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  135) 	__wsum csum = 0;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  136) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  137) 	while (alloc_size < max_mem) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  138) 		int order = get_random_u32() % NR_PAGE_ORDERS;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  139) 		struct folio *folio;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  140) 		unsigned int size;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  141) 		void *addr;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  142) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  143) 		/* cap allocation so that we won't exceed max_mem */
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  144) 		if (alloc_size + (PAGE_SIZE << order) > max_mem) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  145) 			order = get_order(max_mem - alloc_size);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  146) 			if (order)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  147) 				order--;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  148) 		}
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  149) 		size = PAGE_SIZE << order;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  150) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  151) 		folio = folio_alloc(GFP_KERNEL | __GFP_NORETRY, order);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  152) 		if (!folio)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  153) 			goto err_free_folios;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  154) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  155) 		state->folios[state->nr_folios++] = folio;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  156) 		addr = folio_address(folio);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  157) 		get_random_bytes(addr, size);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  158) 		csum = csum_partial(addr, size, csum);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  159) 		alloc_size += size;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  160) 	}
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  161) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  162) 	state->csum = csum;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  163) 	return 0;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  164) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  165) err_free_folios:
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  166) 	for (int i = 0; i < state->nr_folios; i++)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  167) 		folio_put(state->folios[i]);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  168) 	return -ENOMEM;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  169) }
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  170) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  171) static int kho_test_save(void)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  172) {
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  173) 	struct kho_test_state *state = &kho_test_state;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  174) 	struct folio **folios __free(kvfree) = NULL;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  175) 	unsigned long max_nr;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  176) 	int err;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  177) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  178) 	max_mem = PAGE_ALIGN(max_mem);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  179) 	max_nr = max_mem >> PAGE_SHIFT;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  180) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  181) 	folios = kvmalloc_array(max_nr, sizeof(*state->folios), GFP_KERNEL);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  182) 	if (!folios)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  183) 		return -ENOMEM;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  184) 	state->folios = folios;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  185) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  186) 	err = kho_test_generate_data(state);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  187) 	if (err)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  188) 		return err;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  189) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  190) 	err = kho_test_prepare_fdt(state);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  191) 	if (err)
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  192) 		return err;
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  193) 
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27 @194) 	return register_kho_notifier(&kho_test_nb);
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  195) }
b753522bed0b7e Mike Rapoport (Microsoft  2025-07-27  196) 

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

