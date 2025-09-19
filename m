Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81959CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1636940008; Fri, 19 Sep 2025 01:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6CF8E0008; Fri, 19 Sep 2025 01:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DCC6940008; Fri, 19 Sep 2025 01:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFD48E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:42:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 325EF1401A2
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:37 +0000 (UTC)
X-FDA: 83904905154.24.F8FFB2E
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id D3C2310000A
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fpy/lHX+";
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dacB6SrYT03TVyUEI11wm5aPSS94h+f8NDQT+sbfk+Q=;
	b=AgC3S0Q09Ea+iF50eOA9pxx/WxxVGzyuERtoXP18WjeFx3+d22mDw4BwRtnZSbuNhNK+mk
	RO2XUjec750OItDB0xykeC4ikYm3uIrcLLgrRvwVySoBAlhQVQTMUDIqQWcUZ/LzIQ6bfY
	wrWxmEwEwwc2IA0m/gFBHWYRe8RCG24=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="fpy/lHX+";
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260555; a=rsa-sha256;
	cv=none;
	b=WXlv9fp79LLWlnvoWnYdeozfVIjiawmY7zfWjCkCW5YpPcqHNOBq6DWhWfc/wCvhfoDBoo
	iGQc2jIxVc24eXT9Gi77pu0qQRm8lnPpl4yV628vAEZZGb2ph682C1sJiLPLkvLeDojk91
	HL8YsAFsHZYtn5M3eypYNp8hV/DUbuE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260555; x=1789796555;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xhVIzRvUhQ0G0bJbkpH6EEZgthb9WbtJ6bDS0JSPgGg=;
  b=fpy/lHX+iTJAzCH6on7blue75tEov5ls3KUrEXGooGc/qbe+1euOlWwe
   3J5cQ2ML6GqwoWbgH/WT/LxU9+2vpx3ouaKRqW5MXtbItalEr2VtnFQun
   MaWqYHhA9L3RFzjIZIuN+T8vIiVr28HNuhk+xqoMMa5meT4DOE4CZ5Sn7
   aSMy6JQQ/BdEjJyNFKJD5UZWdj07OMDKJXyECsIzPYranCUP2X6nnvtsE
   b6IhybmHOhT/Xfs43LK/k6RPie8MrROE0B0w54OtxiFqQdUYzsq1ohd+J
   kU5vMCqeQoDsh95lI5oIadRT1hbiisRnhIAz9BK8L9ucFmOMimPYOcv/2
   w==;
X-CSE-ConnectionGUID: VQSkdBN2QBu6KkUgBNjTAw==
X-CSE-MsgGUID: BSYLnRi9Qweg1jv2sUOWMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235705"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235705"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:42:33 -0700
X-CSE-ConnectionGUID: jWFFrS3tQ8i6m5NRhfM0kA==
X-CSE-MsgGUID: rUxpoxp/QxqqP1VMEDw7PA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858539"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:42:27 -0700
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
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 0/8] Fix stale IOTLB entries for kernel address space
Date: Fri, 19 Sep 2025 13:39:58 +0800
Message-ID: <20250919054007.472493-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D3C2310000A
X-Rspamd-Server: rspam05
X-Stat-Signature: broyaa7i19j5a7c64t9u4qoofam5zhnt
X-Rspam-User: 
X-HE-Tag: 1758260554-476031
X-HE-Meta: U2FsdGVkX1+Bfp8utBgnItu4H0YWdQ2iJ04UomQRT6Si3NEjpsrYBIFAFilxCV8fdOq5EOeklE6VG2gNu8nVKDXvu47E5nNd7wtqtwwPkrTGN6o+3WC39+7n1Chplu6M30zroBa9MwPiTV3kMCQgdTc07KJDHf5GA5eLNo2VrHFTWUUo3nokSElZWs41g+ROjRbS1cEVzlqZpd65H+j1w9KdpIXsNxAKydONYR/lmZadHzsJkcW8xpjyCFTKc7EAa9viQJuSekzsmAI2geIZ2roqP4DMj+Ccssmv1rLI0e9ShBULbxnYdqsvRC2T5bTCWUmBGzFVwGdgrL2SnsiOIpaoRfXv+BB97AImW87AyvYC5j6XH4U9/gBOI3fnrgKGwW9w4qTpRl0V/pcdoLZGo7FujbbzOrQVR22D5kDsRNYwu5y+nTnR6hcVWXn+fuabC/h2lYskvOS06Zbp2O7xJ6pu+4E0noKvFvcT/X2lzCpFLlnXgxjCqJEsF3eJy95bmEeWwdGBhZ/aNVmZ3cIANgo0du7BGqIuTw9UrP7lSJ6sWlVUMQC/b3qNjmaF1LsCJc4QpZtiVHxC990ivEJQv5nikeSFc9yJm8Cr8vbbbMWbozwNUeJR5YOjdYhJbYF8Y2EI/5lSmu8X5mYl3KyJSjrTKkznHDvGBA2cwNXiLI2z4DbR1WI1mFXRUQ18ArnTW4Hl26aS5uCOPpnBhk1MaLEEbc0+lHmvLC+m4A5jUmkxpWO0qT/LNVlbpQOrpQDbsjWM7xr0Mnw1jFyuk/834IiDMmNkFPxba9r4z1TTycRaOIWxrHeS7mI8Wu+Jq9DO2lwLQkZpOsxu4efYjb5OEIg92lUT1koszdV80geatHem3Alv9M5oo6hugxvTlIsOZyED1fhfdycSiRKvAoxAZKVObIFG8w/s/9/kY7YHFSbpTGxM/PsjLV1SROA0zFSanGEI1jwGGwj7uDp7SB5
 sRzOS6Ju
 I2sVT3FR2yL8kWQwc5C2zqiN7/PKttgYFi8tTV23redxP13nYiAU59P+1Ly/3Z+SAcrcpM7DfrZb2/k1cAj8pe1foEZ9INUZsnqIGLKZTLusYMovO1njO0HExvaY9oWI+nvLIthpcXY9IacAwvDpyoudJ2uInLJooZmUDUG0kYX1VrmNo49PcSd/QXA==
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
v5:
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

Dave Hansen (6):
  mm: Add a ptdesc flag to mark kernel page tables
  mm: Actually mark kernel page table pages
  x86/mm: Use 'ptdesc' when freeing PMD pages
  mm: Introduce pure page table freeing function
  mm: Introduce deferred freeing for kernel page tables
  mm: Hook up Kconfig options for async page table freeing

Lu Baolu (2):
  x86/mm: Use pagetable_free()
  iommu/sva: Invalidate stale IOTLB entries for kernel address space

 arch/x86/Kconfig              |  1 +
 arch/x86/mm/init_64.c         |  2 +-
 arch/x86/mm/pat/set_memory.c  |  2 +-
 arch/x86/mm/pgtable.c         | 12 ++++-----
 drivers/iommu/iommu-sva.c     | 29 +++++++++++++++++++++-
 include/asm-generic/pgalloc.h | 18 ++++++++++++++
 include/linux/iommu.h         |  4 +++
 include/linux/mm.h            | 24 +++++++++++++++---
 include/linux/page-flags.h    | 46 +++++++++++++++++++++++++++++++++++
 mm/Kconfig                    |  3 +++
 mm/pgtable-generic.c          | 39 +++++++++++++++++++++++++++++
 11 files changed, 168 insertions(+), 12 deletions(-)

-- 
2.43.0


