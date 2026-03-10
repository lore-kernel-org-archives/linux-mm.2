Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1040EB105A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 14:54:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8336B00B3; Tue, 10 Mar 2026 10:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 482A96B00B4; Tue, 10 Mar 2026 10:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2AD6B00B5; Tue, 10 Mar 2026 10:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2AAEB6B00B3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:54:36 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BB209139AAE
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:35 +0000 (UTC)
X-FDA: 84530449710.01.AE271EC
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf01.hostedemail.com (Postfix) with ESMTP id E1F5A40011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:54:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NqRwT0Fm;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773154474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uuUPog/sat/7+aZpFjgpyR9bUfWW9xmLj9hpLXqUPz0=;
	b=OwZM1WkUdfcAFsts1B2g/AC8NQ69u7/gSycZJCUe7Abk7GTQ1pOwbqXnn3R2iQd7IJhSwa
	zL9jkfyMrWjiCQum20peuG50gFFrkVRE8IzPJTG4D2sQo1DG2Fu1ImNubuCAqeISE2d0jN
	tEx2/LmxXB5NGEHGVSh1nNVvXNgW38U=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NqRwT0Fm;
	spf=pass (imf01.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773154474; a=rsa-sha256;
	cv=none;
	b=ArD2ytvVUSopFMOIVQniOi35xz1tSUi6AcH8SeSBHjLvpva6Vcb+SLNKnd32YNCW5jpJpy
	A/RxsZgng3dOtPqpRXIYtyVHjkP0SEr7UrfimXwjdwSKk4qRXRcZakmCjW3Y/V+4QuJC6N
	9Cbl6q+LeAqnJow2gNH+ketdInJTyfk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773154471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uuUPog/sat/7+aZpFjgpyR9bUfWW9xmLj9hpLXqUPz0=;
	b=NqRwT0FmjKurBS8uijqZStk0R4uXypa5ydCIh60zoT51JmyCam2xRx7RNnUj7Tn7disMZo
	z4+VQpi4Mp7pjrF7uEPmv4kl/BI1ZAjZWNWs+m9wRMcAopWE6LbczsrDmPbOEbqD+/2AHD
	xsGdWVOhi6nRUAa376ydbe0mcaoZJtk=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	ryan.roberts@arm.com,
	david@kernel.org
Cc: ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dev.jain@arm.com,
	jack@suse.cz,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	rmclure@linux.ibm.com,
	Al Viro <viro@zeniv.linux.org.uk>,
	will@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	hannes@cmpxchg.org,
	kas@kernel.org,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/4] arm64/mm: contpte-sized exec folios for 16K and 64K pages
Date: Tue, 10 Mar 2026 07:51:13 -0700
Message-ID: <20260310145406.3073394-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: E1F5A40011
X-Rspamd-Server: rspam08
X-Stat-Signature: u89w8yy7xgdgwgctpuexabs6uxh7rc8c
X-HE-Tag: 1773154473-137643
X-HE-Meta: U2FsdGVkX18XLFEnuc1R5zDtzjiG1qATdLvR6dY5EDT00/LkT8eFy5nX7xsrkxvJvkuACGErOZ+zz3S+XSHMCMp4VIdPjs/Ru40C2W0UW7MZp6NI/CPVdAUKMSEE639eFGsv4TgRDMBZ/vnL0hkxrgV3l/ggRS1/2tdPbGo8AgflH4gCbciFTUudkF/7wA5aL4KjauTJ2BoCpRS6G+bzUISxYihEu00/wmbeyRCYwEAjIlrtW235iD9YiJY0fvZo/SAaaIJAhkjpDjG/cgKebdMFjvMS2hRCzc97BPSvh+q2hgClNEAEsp04obfuBjyufWhlK00YDF9o1e00exXFi0GZGer0elYWt5Vg8BCJP6w0Qm++PUSCoRkfcvY8YZqtrBluOnqwITwVoF6aMJo2YZOlO+sX6RcaFVJMRIAn6t8r8YY9PJ36xK8FPusLnhFmySk187l3uQ5+KcOpTcCTHwun+EOH84Ua5UEQNmgdHqSD2vFokO6CVCaV1uQSXzs6mhL4lVHReOkz1PPRu02Sg87juDPrzzeMo7RN6k4HqMntjiX35stDCXzXwHs1AXbCdzj8dFuR7qEoY+Kc+ZGj+9LVbvsCTwXYnFL3RZLj4pKidEhHSZKTUKwLnqr+Yu+5AA4RXV6uRGGgLXdcl6CBf5Bl9si1famYPhzZ7CN+WnuOKIjLRWQTp/Y9whYA/XbB9G6qzxnugFItFC0sUEKO2ObB1OucTMN/GNyqmhTSgf+b/HyoAeR8l/g4Rk2UgEQFvRS6TISiJ611FlpYnv+II9dS/hvWOdq0/ZL5YTvh2crj1VONuDS+XW+RofT2Kc8ftuu3Cuaxk7RfRBXfTAAeqBLXynryJdndclWnaih75m0blls8SQlk9P5j2ZRkD2vwUVeIZQv3gsBy2JLfpIAxUa4ZyJoO9pF3NYrebI0wrYL+u7dIQPPqKM7IOBHNp0PkrSQLzfQD07i5RiSgUei
 QcnfV3ST
 6bPLSAAdOCTemhNjEvxY3Toimcd/nTL6J7KbMA3+xSV6rWW/fCAjuqSsNv+kcrpmNqGmhhCm1jB19gGaZ5IO0zpKDQYxLocjyk9aWcLfzXRUpg0a25nnhlFjf1lf7Xd7712tWbn58NGJ97RQJqyUmPfuM8rfn5tlz3WnSXNj0yxwchrCqvoGM98YuLVrRP1wSjXdPs8pJ0lnM2nQ9Bsch8a1KeQOsnW7YnCU+la0EYqP4RbF7srxj3hxVYcaLC7EX1/wyXWTWGgxzUIqzwnFU3H2290eCHvGfSkPB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On arm64, the contpte hardware feature coalesces multiple contiguous PTEs
into a single iTLB entry, reducing iTLB pressure for large executable
mappings.

exec_folio_order() was introduced [1] to request readahead at an
arch-preferred folio order for executable memory, enabling contpte
mapping on the fault path.

However, several things prevent this from working optimally on 16K and
64K page configurations:

1. exec_folio_order() returns ilog2(SZ_64K >> PAGE_SHIFT), which only
   produces the optimal contpte order for 4K pages. For 16K pages it
   returns order 2 (64K) instead of order 7 (2M), and for 64K pages it
   returns order 0 (64K) instead of order 5 (2M). Patch 1 fixes this by
   using ilog2(CONT_PTES) which evaluates to the optimal order for all
   page sizes.

2. Even with the optimal order, the mmap_miss heuristic in
   do_sync_mmap_readahead() silently disables exec readahead after 100
   page faults. The mmap_miss counter tracks whether readahead is useful
   for mmap'd file access:

   - Incremented by 1 in do_sync_mmap_readahead() on every page cache
     miss (page needed IO).

   - Decremented by N in filemap_map_pages() for N pages successfully
     mapped via fault-around (pages found in cache without faulting,
     evidence that readahead was useful). Only non-workingset pages
     count and recently evicted and re-read pages don't count as hits.

   - Decremented by 1 in do_async_mmap_readahead() when a PG_readahead
     marker page is found (indicates sequential consumption of readahead
     pages).

   When mmap_miss exceeds MMAP_LOTSAMISS (100), all readahead is
   disabled. On 64K pages, both decrement paths are inactive:

   - filemap_map_pages() is never called because fault_around_pages
     (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
     requires fault_around_pages > 1. With only 1 page in the
     fault-around window, there is nothing "around" to map.

   - do_async_mmap_readahead() never fires for exec mappings because
     exec readahead sets async_size = 0, so no PG_readahead markers
     are placed.

   With no decrements, mmap_miss monotonically increases past
   MMAP_LOTSAMISS after 100 faults, disabling exec readahead
   for the remainder of the mapping.
   Patch 2 fixes this by moving the VM_EXEC readahead block
   above the mmap_miss check, since exec readahead is targeted (one
   folio at the fault location, async_size=0) not speculative prefetch.

3. Even with correct folio order and readahead, contpte mapping requires
   the virtual address to be aligned to CONT_PTE_SIZE (2M on 64K pages).
   The readahead path aligns file offsets and the buddy allocator aligns
   physical memory, but the virtual address depends on the VMA start.
   For PIE binaries, ASLR randomizes the load address at PAGE_SIZE (64K)
   granularity, giving only a 1/32 chance of 2M alignment. When
   misaligned, contpte_set_ptes() never sets the contiguous PTE bit for
   any folio in the VMA, resulting in zero iTLB coalescing benefit.

   Patch 3 fixes this for the main binary by bumping the ELF loader's
   alignment to PAGE_SIZE << exec_folio_order() for ET_DYN binaries.

   Patch 4 fixes this for shared libraries by adding a contpte-size
   alignment fallback in thp_get_unmapped_area_vmflags(). The existing
   PMD_SIZE alignment (512M on 64K pages) is too large for typical shared
   libraries, so this smaller fallback (2M) succeeds where PMD fails.

I created a benchmark that mmaps a large executable file and calls
RET-stub functions at PAGE_SIZE offsets across it. "Cold" measures
fault + readahead cost. "Random" first faults in all pages with a
sequential sweep (not measured), then measures time for calling random
offsets, isolating iTLB miss cost for scattered execution.

The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
512MB executable file on ext4, averaged over 3 runs:

  Phase      | Baseline     | Patched      | Improvement
  -----------|--------------|--------------|------------------
  Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
  Random     | 76.0 ms      | 58.3 ms      | 23% faster

[1] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/

Usama Arif (4):
  arm64: request contpte-sized folios for exec memory
  mm: bypass mmap_miss heuristic for VM_EXEC readahead
  elf: align ET_DYN base to exec folio order for contpte mapping
  mm: align file-backed mmap to exec folio order in
    thp_get_unmapped_area

 arch/arm64/include/asm/pgtable.h |  9 ++--
 fs/binfmt_elf.c                  | 15 +++++++
 mm/filemap.c                     | 72 +++++++++++++++++---------------
 mm/huge_memory.c                 | 17 ++++++++
 4 files changed, 75 insertions(+), 38 deletions(-)

-- 
2.47.3


