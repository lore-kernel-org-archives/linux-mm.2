Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E786FD6AAF7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A001F6B0088; Thu,  2 Apr 2026 14:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D76A6B0089; Thu,  2 Apr 2026 14:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9145F6B008A; Thu,  2 Apr 2026 14:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8059F6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:13:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30BE85B818
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:13:39 +0000 (UTC)
X-FDA: 84614413758.24.674E474
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id 48CE34000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:13:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9oje+Xn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775153617; a=rsa-sha256;
	cv=none;
	b=s7PmgRtWDxjcBhjdzUz+igaCpsCPHr1L8qgVxaBjWMi3CzwksfcOX18pbnzjU39W/2NkIL
	Tj/Pp8bZsrdZuG9AHSW4kbyjet1Fi80HzI7bOZsAL33xiMr7Y5s+mCkjZghucWNSL5kw1T
	qsOMF5cumwCIsULq8B/5bRGyQBX4LmY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h9oje+Xn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775153617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IhJBBcdykzyEQ1MtZgTszHZJ1RBYhR6UrojdtXO9EDU=;
	b=tM7EP08vFLhpvaQXpj/y/iFONTI/r08VRT/EfuFgnpS2SjRJXgy+dhq8aKAsCBqZOVR+tJ
	/Lai9DamZkBWVuYALvBFHdHoGAUBkn5eZxufdZTdf6k8vV5ICV7r33s0X2zy7rXsgZZ+ex
	2w6uF2KHnT77njlmajuYXuJOcwmmyHU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775153614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=IhJBBcdykzyEQ1MtZgTszHZJ1RBYhR6UrojdtXO9EDU=;
	b=h9oje+XnElrr8IWvpnms2viVimbvCZmBVbF1wYz3j02sfNujtlzP15uyPJxwbzTY/Iuznw
	pezN7VYQFRrED3Q/5G3iaYFas+yEg18hDeo5b/Wgsi7tTzpZcp1HSpywnk8L+EOwa0UsrP
	fh/PH3i+HT+zacWSqCMJoTucsnxDs7Y=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	leitao@debian.org, kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 0/4] mm: improve large folio readahead and alignment for exec memory
Date: Thu,  2 Apr 2026 11:08:21 -0700
Message-ID: <20260402181326.3107102-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 48CE34000A
X-Stat-Signature: iegghdfwnn8qe1neo9r1mgdfiwh9i6oj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775153617-876095
X-HE-Meta: U2FsdGVkX1++psSjJ5MBvnhLw8ZhWPr15SbZBRHdDhZOw0BXEbKgKpiYcX3qKOr2nFR16tGpsVg8b/tli7iycrOzEJmh9GJcmkkugbHCnmSn3QMSrhyaPJqOL6kjMpF14PxLBGQT+YqyMnJmKXIDu6HZU2p28wXEif2WQ3PjTOHpKLeiTz7ifhhFUDWXneRdTXgV5t60CagwjhOPzlxTiqRb8kmDdHmcOYFAwLfFmuNkPYaod+CcaYYEmTwYVQ39cb59aXrM1oeF/kJGb+fZLZjiiHNPrxnFMkJszzw6DOUFHrIgTnwCoauuhF4br1FuV4RVVFz2Qwc29VrdJS6nFoB/6oGq76cs6PDsR28aV4txcS66J7mDONb7E7q001Zgsc1vp66XJei3lbMJKQHhnAbR5wdf5pIhB8u6uvQaYXXIssnUTn402fBiw0oQl9QxJJX+v7hiUucnaHWo0r2NneWyvwVMjlLN5e7WHmdPgf433YR3cTscUlJf+ZTZLCnPGRwsF2cLF7LhgK1+fN9/TMFrTf2oWA4gIQQrE8snrRiVYyF9l1IlHTAUThcHG37T35880aNt/T/fo66+ypd+WfebXKuWXyYEEeR2As9WSBtUmCU5yWX6WqhHXGDhRYb3ETsOMdoZTgdnwA2IqxVOgxtzktECGaMs0RPyO5Rp8XbmcQ8OXCZi8kiiqGWBaJWSyPWA7fRRXeCXNjFjDCXu38XtgyfcnvWqwKMBAWBLZnFM25EhWA2Mr1/aElr9v909d/rIMLEOFHiCXhM3dQI6u2Or25RnBPa4s/rEmPXgdxVnbv3Bc6mqeFpzJu4xXyp+E6JL6IRMpd3Irp/+cYfqGkmhOdEhDL2XgrCrkS/R0P/O6IOxoC2euFoDU7rLCCgpIQw8QVtmAk+KMAidA72Y4ocMJ8l60qVJ8utwot+PD6DDj53nBg63UboBfK4B/QSH2eS2TPC3wRPUd1g4IRN
 9G9GuOaE
 /TOelGFLrbaJyPmddrjNk0xeGdITjKBIXTKhH8V3o1DM4GL03zU2BSROuSDae5jce2VIpAT2PuRQiZ0Apr3wzk05HntLc2eZDRMl1otY+yfLREEOaNUUW1Qndt7Q+Df8wgOzxsYkMPj5WC8mbITblwrkeylkeiuTo00tDZ3eu0qY4TunA//sKz4wZ4HnckNSbkUb+KR1t0DmQ3iQQsBKmZPjauQ68xMPr/o3C+9B3dF+aBhEMVEBGOLQhdZ1Jz4MJPO7/7gKUbjBOCGjj7dGDd3sqs2u2n9NDMi66MPgMxXnubapdB+3u84tXZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
- Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
  to HPAGE_PMD_SIZE limited to 2M (Rui)
- Reviewed-by tags for patch 1 from Kiryl and Jan
- Remove preferred_exec_order() (Jan)
- Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
  otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
  do_sync_mmap_readahead().
- Change exec_folio_order() to return 2M (cont-pte size) for 64K base
  page size for arm64.
- remove bprm->file NULL check (Matthew)
- Change filp to file (Matthew)
- Improve checking of p_vaddr and p_vaddr (Rui and Matthew)


v1 -> v2: https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev/
- disable mmap_miss logic for VM_EXEC (Jan Kara)
- Align in elf only when segment VA and file offset are already aligned (Rui)
- preferred_exec_order() for VM_EXEC sync mmap_readahead which takes into
  account zone high watermarks (as an approximation of memory pressure)
  (David, or atleast my approach to what David suggested in [1] :))
- Extend max alignment to mapping_max_folio_size() instead of
  exec_folio_order()

Motiviation
===========
exec_folio_order() was introduced [2] to request readahead at an
arch-preferred folio order for executable memory, enabling hardware PTE
coalescing (e.g. arm64 contpte) and PMD mappings on the fault path.

However, several things prevent this from working optimally:

1. The mmap_miss heuristic in do_sync_mmap_readahead() silently disables
   exec readahead after 100 page faults. The mmap_miss counter tracks
   whether readahead is useful for mmap'd file access:

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
   disabled. On arm64 with 64K pages, both decrement paths are inactive:

   - filemap_map_pages() is never called because fault_around_pages
     (65536 >> PAGE_SHIFT = 1) disables should_fault_around(), which
     requires fault_around_pages > 1. With only 1 page in the
     fault-around window, there is nothing "around" to map.

   - do_async_mmap_readahead() never fires for exec mappings because
     exec readahead sets async_size = 0, so no PG_readahead markers
     are placed.

   With no decrements, mmap_miss monotonically increases past
   MMAP_LOTSAMISS after 100 faults, disabling exec readahead
   for the remainder of the mapping. Patch 1 fixes this by excluding
   VM_EXEC VMAs from the mmap_miss logic, similar to how VM_SEQ_READ
   is already excluded.

2. exec_folio_order() is an arch-specific hook that returns a static
   order (ilog2(SZ_64K >> PAGE_SHIFT)), which is suboptimal for non-4K
   page sizes. Patch 2 updates the arm64 exec_folio_order() to return
   2M on 64K page configurations (for contpte coalescing, where the
   previous SZ_64K value collapsed to order 0) and uses a tiered
   allocation strategy in do_sync_mmap_readahead(): if the VMA is large
   enough for a full PMD, request HPAGE_PMD_ORDER so the folio can be
   PMD-mapped; otherwise fall back to exec_folio_order() for hardware
   PTE coalescing. The allocation uses ~__GFP_RECLAIM so it is
   opportunistic, falling back to smaller folios without stalling on
   reclaim or compaction.

3. Even with correct folio order and readahead, hardware PTE coalescing
   (e.g. contpte) and PMD mapping require the virtual address to be
   aligned to the folio size. The readahead path aligns file offsets and
   the buddy allocator aligns physical memory, but the virtual address
   depends on the VMA start. For PIE binaries, ASLR randomizes the load
   address at PAGE_SIZE granularity, so on arm64 with 64K pages only
   1/32 of load addresses are 2M-aligned. When misaligned, contpte
   cannot be used for any folio in the VMA.

   Patch 3 fixes this for the main binary by extending maximum_alignment()
   in the ELF loader with a folio_alignment() helper that tries two
   tiers matching the readahead strategy: first HPAGE_PMD_SIZE for PMD
   mapping, then exec_folio_order() as a fallback for hardware TLB
   coalescing. The alignment is capped to the segment size to avoid
   reducing ASLR entropy for small binaries.

   Patch 4 fixes this for shared libraries by adding an
   exec_folio_order() alignment fallback in
   thp_get_unmapped_area_vmflags(). The existing PMD_SIZE alignment
   (512M on arm64 64K pages) is too large for typical shared libraries,
   so this smaller fallback succeeds where PMD fails.

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

[1] https://lore.kernel.org/all/d72d5ca3-4b92-470e-9f89-9f39a3975f1e@kernel.org/
[2] https://lore.kernel.org/all/20250430145920.3748738-6-ryan.roberts@arm.com/
 
Usama Arif (4):
  mm: bypass mmap_miss heuristic for VM_EXEC readahead
  mm: use tiered folio allocation for VM_EXEC readahead
  elf: align ET_DYN base for PTE coalescing and PMD mapping
  mm: align file-backed mmap to exec folio order in
    thp_get_unmapped_area

 arch/arm64/include/asm/pgtable.h | 16 ++++++----
 fs/binfmt_elf.c                  | 50 ++++++++++++++++++++++++++++++++
 mm/filemap.c                     | 42 +++++++++++++++++++--------
 mm/huge_memory.c                 | 13 +++++++++
 mm/internal.h                    |  3 +-
 mm/readahead.c                   |  7 ++---
 6 files changed, 109 insertions(+), 22 deletions(-)

-- 
2.52.0


