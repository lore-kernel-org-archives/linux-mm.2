Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A196CCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87908E010F; Tue, 14 Oct 2025 09:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5FBA8E000D; Tue, 14 Oct 2025 09:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C878E010F; Tue, 14 Oct 2025 09:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5F5C8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:07:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76DFD140848
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:21 +0000 (UTC)
X-FDA: 83996745882.08.372F8DE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id C37661C001A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:07:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D6md4wC+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760447239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=18Ew0aAXtEgUbkwE6ixE4TlRDzrx/rkm0Nh96P1QfZo=;
	b=G6AtEZ6/hpyKiNKHDs+eOtQsrHzbqNjSSyNAGx2EsbF43Puw1C1SqmEHG8MzhvjiS4j7Q0
	sba9kaK19T9oAofiYNN4tG1kfWe4Us46f4AX1SZZBTTDIF9vNd5wv/bVuprmaqSkhZAefl
	JyyQBQhPS/ZO781Zj5+ORyCArmzBUGg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=D6md4wC+;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf21.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760447239; a=rsa-sha256;
	cv=none;
	b=LQ2ON+aXk1D29kNvqUc+sLnqkg8gkU59VOqPaJryujXqxx2MMLVPVCgA4KklNtMZkRIcbh
	0+JzpbQj/MYsrnjijHTUyd+WHDEYYyRBFLENzXcZejreQbtfvfyECUY9XsB2DnT+R24/As
	91pRtya9pPYMMR+eCwJFVTDsu5+imGY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760447239; x=1791983239;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+Ij5X6I1pn3tOPVFV6qa8qHb+MGgIveks54UsCnznwg=;
  b=D6md4wC+L4rTDciWpiqaYjENFhz955y1kxH93eRZTIxjmRVD3HdXHtet
   Lx+57y8yym/IItJSdRVHHM6/MAJ4T5SCxptW7Qi+2GFKeyaqx0ARk06OP
   pIU3fFM7gLpLWnt8wJWdoN+laAf3lcBqbZ8yu0HOZveGi3oOpps6Mc7VQ
   0b9ZEcIAO+xTRIk3+sZoOGG6YmhprgvZyPok1ho5u2Udxc0n/4A7CmXcZ
   UyKikZ8fKFQMVz3QaiezE24muGK9+LCMwilSOAG3uhA0T9hIMZXiRjB0q
   j/IZP57wjJ4dRP+2gOTj5CCTpTw/N6i+DlbYiD92eCltFnXkqTJ3XGgDM
   Q==;
X-CSE-ConnectionGUID: 5X60H4mtSRe0ZFV9Ls1qxA==
X-CSE-MsgGUID: NPgXgM+RQmmZAqDH/ctMfQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62515292"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62515292"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 06:07:17 -0700
X-CSE-ConnectionGUID: x1UbzMZCTya0ZQljcGcOEg==
X-CSE-MsgGUID: 1SrbxBknSoO93W5oE+HWXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="182675488"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa010.fm.intel.com with ESMTP; 14 Oct 2025 06:07:09 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v6 0/7] Fix stale IOTLB entries for kernel address space
Date: Tue, 14 Oct 2025 21:04:30 +0800
Message-ID: <20251014130437.1090448-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C37661C001A
X-Rspamd-Server: rspam03
X-Stat-Signature: xet1fhcumfnaqecun4n1887t4jtryh8k
X-HE-Tag: 1760447238-215414
X-HE-Meta: U2FsdGVkX1++g/vMP/NCgBV8vA/2IZy48SpKFVFoO54MML3hCN4mKRwsVy5g6pEFsYzkNzjZlETKCpJcjYChFt3e2nMshu3RDA6oGwrbyZHSKC2Ff44yaympZWzwZsQ/T311fBGVczGvgrfv9W49yjmlfjHWO6eDgG0Ea7OluOh/NXPVMvLowsGnLl4LInAfFhi+3Ru4+eh3fB8bmz7lJU/SXb4f2kMZj3lEvFyj8pLyzsa6g5NlLE/JYAttjsL3B0xmx+4hC/PxfSBxYFj8FPbqNs/DSA2BzoJahC3MOZ/CF1i9SaHsm5FKVha56zsUWqCrGEfgtV30BB8zUfncyzszVqbOptjNsLXDk0ebz7Nt3tdy9n83yNaQbIEaoaxFaITtYAFV5wsv2wJovYvaaRYqusnyBqYYKceZPNpXquTa+BerjuhRZjc1KFORAjk7ym9oYG5HiqTXxUqH2XsXVhL5q+Pb/7PrLuo4fG4FaH3JurDTtWIissCtMlVrEOUax/4Bxu0QxPr1wDTT4UHzEM1kf4tiirqLdogShwwszr/0Es9oETZ3z982+Hgg+0MNGgJwpVKlxYrqAdQ2n0mew2nSnLvtRYcxR/7/OxjcFrLBkURED2IBPQsrr/KeYacZfK/F5OLIQ/Ai7cLs/G7xGWutSQvQMv7jYte/tbdA65I6EtyhmjPzXoBPLVmM81C8BVZ9Rgpw2B7eIagadt3QGgJ5K/Z6i/ZSq5JP+QxV1WOSqnxP5O0lGJm/dYr8qJO3FlU2Cf95siGghxOhE1izr4bZAKU+4hpuChIhZ/wY84Jac5JdmB2IhrwhPmpYLrOa5+iRD51FXdobngjb0JjquAZRa+k4DL/qlcZ0TQ6kxNLwMSH+3odhzfPkXkBILGTZQENXRv8zL+7xYaplbUhEX+r85E1Uwp58kKHkslUrZroMXVs7QkSLWB5cbYksTpfn4HHR/hhHIUL7US9jKjw
 Ryg3Fg8p
 37z3XmRUlbOjfcVSKZPTBb5RP+bGwma0+MCbkpnA7p/3iUxcQLBTdQMQYcSGgYiI/yC2krA581BcqEEqzO84qlNckLtRx5SZza/zaZSvNXQIC2rnotM5FPQJFSKyzMgtMGUmhTjVtt2NL4gxwXh/1dkjRuZS2vPwvlvkg5yoACDSY8jixvqDvbuJ+JTEf+Mmx/We5/UEknkRSIgQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This proposes a fix for a security vulnerability related to IOMMU Shared
Virtual Addressing (SVA). In an SVA context, an IOMMU can cache kernel
page table entries. When a kernel page table page is freed and
reallocated for another purpose, the IOMMU might still hold stale,
incorrect entries. This can be exploited to cause a use-after-free or
write-after-free condition, potentially leading to privilege escalation
or data corruption.

This solution introduces a deferred freeing mechanism for kernel page
table pages, which provides a safe window to notify the IOMMU to
invalidate its caches before the page is reused.

Change log:
v6:
 - Follow commit 522abd92279a to set/clear/test a flag of struct
   ptdesc.
 - User page_ptdesc() helper.
 - Squash previous PATCH 6 and 7.
 - Rename CONFIG_ASYNC_PGTABLE_FREE to CONFIG_ASYNC_KERNEL_PGTABLE_FREE.
 - Refine commit message.
 - Rebase on top of v6.18-rc1.

v5:
 - https://lore.kernel.org/linux-iommu/20250919054007.472493-1-baolu.lu@linux.intel.com/
 - Renamed pagetable_free_async() to pagetable_free_kernel() to avoid
   confusion.
 - Removed list_del() when the list is on the stack, as it will be freed
   when the function returns.
 - Discussed a corner case related to memory unplug of memory that was
   present as reserved memory at boot. Given that it's extremely rare
   and cannot be triggered by unprivileged users. We decided to focus
   our efforts on the common vfree() case and noted that corner case in
   the commit message.
 - Some cleanups.

v4:
 - https://lore.kernel.org/linux-iommu/20250905055103.3821518-1-baolu.lu@linux.intel.com/
 - Introduce a mechanism to defer the freeing of page-table pages for
   KVA mappings. Call iommu_sva_invalidate_kva_range() in the deferred
   work thread before freeing the pages.

v3:
 - https://lore.kernel.org/linux-iommu/20250806052505.3113108-1-baolu.lu@linux.intel.com/
 - iommu_sva_mms is an unbound list; iterating it in an atomic context
   could introduce significant latency issues. Schedule it in a kernel
   thread and replace the spinlock with a mutex.
 - Replace the static key with a normal bool; it can be brought back if
   data shows the benefit.
 - Invalidate KVA range in the flush_tlb_all() paths.
 - All previous reviewed-bys are preserved. Please let me know if there
   are any objections.

v2:
 - https://lore.kernel.org/linux-iommu/20250709062800.651521-1-baolu.lu@linux.intel.com/
 - Remove EXPORT_SYMBOL_GPL(iommu_sva_invalidate_kva_range);
 - Replace the mutex with a spinlock to make the interface usable in the
   critical regions.

v1: https://lore.kernel.org/linux-iommu/20250704133056.4023816-1-baolu.lu@linux.intel.com/

Dave Hansen (5):
  mm: Add a ptdesc flag to mark kernel page tables
  mm: Actually mark kernel page table pages
  x86/mm: Use 'ptdesc' when freeing PMD pages
  mm: Introduce pure page table freeing function
  mm: Introduce deferred freeing for kernel page tables

Lu Baolu (2):
  x86/mm: Use pagetable_free()
  iommu/sva: Invalidate stale IOTLB entries for kernel address space

 arch/x86/Kconfig              |  1 +
 mm/Kconfig                    |  3 ++
 include/asm-generic/pgalloc.h | 18 +++++++++
 include/linux/iommu.h         |  4 ++
 include/linux/mm.h            | 71 ++++++++++++++++++++++++++++++++---
 arch/x86/mm/init_64.c         |  2 +-
 arch/x86/mm/pat/set_memory.c  |  2 +-
 arch/x86/mm/pgtable.c         | 12 +++---
 drivers/iommu/iommu-sva.c     | 29 +++++++++++++-
 mm/pgtable-generic.c          | 39 +++++++++++++++++++
 10 files changed, 167 insertions(+), 14 deletions(-)

-- 
2.43.0


