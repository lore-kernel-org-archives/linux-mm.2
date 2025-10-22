Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27C69CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76FEB8E000A; Wed, 22 Oct 2025 04:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746D78E0002; Wed, 22 Oct 2025 04:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684538E000A; Wed, 22 Oct 2025 04:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 558A38E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:29:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F72811ABEC
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:14 +0000 (UTC)
X-FDA: 84025075428.26.BFA66FD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf17.hostedemail.com (Postfix) with ESMTP id B2EA340005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SCgJ0xqg;
	spf=pass (imf17.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AH5xpBsUQZMkaXj4mLEuDBYBp01G2IiteB022DXD2+o=;
	b=P1VnB8E6IDr5dgvDAbG8p4VDtuIg04Sdi3qMPjdbmm74ZVakdnc9gYJqP80uAJepNlRM7s
	DGFMND/LH0oaDxyaP42vkHNw7//AHTa7ytm236Q5mhadCqccy3bq/99UhhEhWgwxX0YDpI
	JsxsqsQEaqvFCV6txGhZfqvLez4p+yY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=SCgJ0xqg;
	spf=pass (imf17.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121752; a=rsa-sha256;
	cv=none;
	b=K7Difh1+5EZRVGDf20CMTeoBdjuJgYX3H6G5u5SOraRjgtRjgojO6B1BN6yoDEm5k/LrsG
	BkCsYebcvG1KiOteKNz6/wCXg7a7Ldi/5TDI/L/mmJUNlJOLpcEu6dwDm3kruLgRfvo0H8
	6UTlikbp6TUHFZNxL+m3Om7LticDynQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121752; x=1792657752;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DQWIuIaP4G7L2QkOxVyAjoDdXex0u4FBjhfXyNZJ/DA=;
  b=SCgJ0xqg3JZcqI1NUcLxkpMy2RCADFdCg7Xtx2h8xrWFnvKUXlMtapzZ
   cdkmZl2DWmQuNHISi/4D4PzRqS6bcWd9gwC/3x37wRKQjrAx3Gv+LBApQ
   +2MjA2AQ1fH0+WXiyrsRGjsP5cpv7gsBLOUH+LXsFxdK3aMqWedu2Xrg4
   k/eY2IbNfw3MaZFBiH2M37hyqm5rJ5UJRoXqpm0PmrNKZkMDh+59XCbMb
   O8j2S66gfnk+F5h+a220pN14Tdr+jzVWbL9peEeAtYtw0Y5b6I5VC7izN
   qbs2Cy8+SvYMJvPR1LOk1276izWdC89twhVkWd4lRi3oMyV7o8Sj+PO/l
   Q==;
X-CSE-ConnectionGUID: 4qV39vfxT6apECENYUGCTA==
X-CSE-MsgGUID: lIZy0c5TS4uE7KAxvx4hdA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="62292568"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="62292568"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:29:10 -0700
X-CSE-ConnectionGUID: 40GuBpibRF6wTTdn6B50PQ==
X-CSE-MsgGUID: zG1sKX4NTcOFJ+1kV6INVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516208"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:04 -0700
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
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 0/8] Fix stale IOTLB entries for kernel address space
Date: Wed, 22 Oct 2025 16:26:26 +0800
Message-ID: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 98p9no617acs1rao9kkj93eyospj3b8u
X-Rspamd-Queue-Id: B2EA340005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761121751-257959
X-HE-Meta: U2FsdGVkX1/8xmY+dWLCgMicm0HPuJWcuL3XBIDiWM2R8IuyXrxOCqAVb1Bn+n+R6yIvAWsKgJUGLDo3QqrQGr8hAHzLueEZVvkrKlSbeSvwPRYvsaCvr4132efcLMTLKznw/emsXggv0JsKNsLlCedkoZjlgnK2mkEmVVTHatOiLQIl0N4ZKeGaIeO1Leoyk5KImeSH2INGh3UkegxnUyJr83tr2k4+NvKUKN3IZJM6Q3LJa75BjJUjse0Q9/6AqoljNMyYEjvHjY8g5vq5Yyunl+tTCaPS2gvU3MrUbr3RQaDpOGqj64o2wnydgzuBcJ+O4IC54KhCIEamL3haLjTllceuO4agodwRJK03qRGgNpTWsm/3CflenaCC+rTTHnNWp3JrqarOOJDJ+CBAb2C5Lbz/PwMBhKvU60lvW2m2BdY5NrdH9bGq79bgbrP/0pcqbuTrkTXQXI9cI7CHjx0zR7NiP9f1VqTZab4H5agSl0PrdYHGMP8ABnd+GaHx/PxOMbb22LzGty6SAUJzcxMLVj8B8Q1NvQn+D8fO3u1BBSUNOHAJTnMNewPXqFm2T93IsKqlqEGP6GcFdDrkUIxPdlVFsZouXw8ts/5AcAmI/SCi0WiHqh7Sgd5wORMndiF3tMCzd5Yrg+RST1/WtvUXljdcaMWR9gtIKSkHm1INlTFFam6qK27huqHX0mW7XLYflLuRVn4MxEy0UiI80tVYckeZxCNXmY6OmSi1QB6RLyo8efI0wDUwmkUwTy+G5dLIlmT3q2Mn4P44o00o3gflZyIMvWAJM+uwAzFVbc1s1f2ZMO7IkwltuX4qxD8F1L9tzzYajXs30w7UbyUM6ThLrRcla03di+Tx2Fhw2fL78Q3FZZIxUvdwLrUOuusc
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
v7:
 - The use of pmd_ptdesc() introduced a bug reported at
   https://lore.kernel.org/linux-iommu/68eeb99e.050a0220.91a22.0220.GAE@google.com/.
   Fix this by replacing it with page_ptdesc().
 - Discussed the approach of backporting and reached a consensus that we
   need an extra patch to disable SVA for x86 arch and re-enable it after
   the kernel page table free callback is done.
 - Use "const struct ptdesc *ptdesc" as the parameter for
   ptdesc_test_kernel().
 - Move "select ASYNC_KERNEL_PGTABLE_FREE" to the last patch.

v6:
 - https://lore.kernel.org/linux-iommu/20251014130437.1090448-1-baolu.lu@linux.intel.com/
 - Follow commit 522abd92279a to set/clear/test a flag of struct
   ptdesc.
 - User pmd_ptdesc() helper.
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

Lu Baolu (3):
  iommu: Disable SVA when CONFIG_X86 is set
  x86/mm: Use pagetable_free()
  iommu/sva: Invalidate stale IOTLB entries for kernel address space

 arch/x86/Kconfig              |  1 +
 mm/Kconfig                    |  3 ++
 include/asm-generic/pgalloc.h | 18 ++++++++++
 include/linux/iommu.h         |  4 +++
 include/linux/mm.h            | 65 +++++++++++++++++++++++++++++++++--
 arch/x86/mm/init_64.c         |  2 +-
 arch/x86/mm/pat/set_memory.c  |  2 +-
 arch/x86/mm/pgtable.c         | 12 +++----
 drivers/iommu/iommu-sva.c     | 29 +++++++++++++++-
 mm/pgtable-generic.c          | 39 +++++++++++++++++++++
 10 files changed, 163 insertions(+), 12 deletions(-)

-- 
2.43.0


