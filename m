Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 507371075274
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 07:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885AF6B0423; Thu, 19 Mar 2026 03:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CDD6B0424; Thu, 19 Mar 2026 03:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74B9D6B0425; Thu, 19 Mar 2026 03:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62AEA6B0423
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:54:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 12F4414041C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:54:16 +0000 (UTC)
X-FDA: 84562049712.20.13D2D99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 465E6C0006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:54:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhQFQN2p;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773906854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZJlM6g/QcOUSBOg6fM2dyygtO2A6CpgHjPUtdVOtXE4=;
	b=xtoHYa5HnEBpXHrl6/lH1bKxEllfr2MDPs1XTzwx/9F2mk8tbKgr60+q7fz8YJcJoCiZqf
	SEqqpXgPn+7byQWuHU7AbxgTOtUbZ6yPep3pR7mIkdzn6jg6au60sm1s6sPFIuTQBCgm5y
	B39xaTgW8nYjny4mSjBEu+QLEPFUFCw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhQFQN2p;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773906854; a=rsa-sha256;
	cv=none;
	b=SmxOjI11DoB496JoEoPlEqelpUSmKfVioinpev8xoRfsbsa27Wfu+Oo+nr6oUwKsVCNkK+
	DuhD9iUpP5R4DPUjA0UPJVp6iX8mhpTahZLPyb9RZim5ovK3+UPDYWJCVj0Y+11WmkuoGq
	5I2pDUhKfK7FCbHqHF2jFXzIKMwTUqI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3AD1E43F6E;
	Thu, 19 Mar 2026 07:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FDEC19424;
	Thu, 19 Mar 2026 07:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773906853;
	bh=dP5W3Kndpvm9kB8cRcapsSUyxSzs+yEOaxzwwC5+yTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LhQFQN2prXyafTb29mtmn2lHjoY58KytAriVs8or6fr7UgLNLmyzkZnrqNOr89tyF
	 c+SRMME9tiUcQN3zYgFdBZRgb5Cn7p8vkDeBWbjwDj2Oe8I3l/g5CfI4uGsEdZIcVz
	 B4RLC6g5epofAZSfHL9lCCGk/IKa/Ha/LlXM8M7B3aXLbF4eN172sPSQcDOCMNUBUE
	 w9MIihXIDcXMTCnPcMElI3l+n0pvPRBf78dM/40BNAsyQturHIzhSYg+zITc58tqm3
	 kqBBwet/VV1CSKoNtyAqLCJF9iNJVHaiE3lREBoQ89s6qdoeTp+kgLXqabm/YD5RMw
	 Wo+UyfktVi3hw==
Date: Thu, 19 Mar 2026 09:54:05 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Message-ID: <aburnbP64n9axmu_@kernel.org>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
 <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
 <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
 <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
 <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
 <CAAi7L5fvUPUqd3A4m6wubeYh90NH+S2KBRE1R8WKerBYhkU8kg@mail.gmail.com>
 <58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <58A8B1B4-A73B-48D2-8492-A58A03634644@nvidia.com>
X-Rspamd-Queue-Id: 465E6C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: xhb3kdfyddt4k4afzii8u4g1f677deio
X-Rspam-User: 
X-HE-Tag: 1773906854-285557
X-HE-Meta: U2FsdGVkX1/O09sg//nYDNvUwvKih8xGM+yhhNiL5kx7ovs/uAXHgEapmOY1cvKjotQcnjegyN1ssGF3gTuREG/1Gwq4hgerRILsI83CoMZErsxdaYF3QmlBhuOBHbENLd0JYRbzBLQcfG9nwnqep783TlUVqeNzaGZVMbWzDssIHspo8BF9YheGG5GaYZEuqo1h0OySsBornYAR05avwPIm4HIux4Sbwel6lbWdOFxIcOIBHalylxmbgmrhQBHWfoiBgkpaid2vj4T+RobTHnVl3MRXhDVgTghE2MLoJAOThnfgYyWkgoS8cbPPwN5ia2ofykHLVA46RDc5kCGc14OcJwutJpV8vqY/nPX8CNR8q8QVgD49WTlEfpGiX5xBnfrZOTwgY7vyOKKzhzwGKQlXRTwixqTXbMjRK6FG3sE8NPt6anGZ3JAIDIQFZjotEy/dlY0jLZbRrVNWj9irDfAfcF8w7IcJxoBOnPHDepVvunsfAWTfT9uXuNdxYw3fNtjLsOx4JYjE5UbUbEs9lof34WPqOnYMCsj63sMKnmx7ceZKbcwTDJiAKPA/JSa6yAL7mld8E7M/ZWROPZEP7FgtAd3OPmVPYfugU8YXRdhynhY5mSxo57OH4zppWUZ8gRVPXppGfLacs3WQEWhgUUbY93780r+jyHfJrnAj5bremabdfOLATJ8FI9eU94Dpzguqm3re5yE7D2tpdeP1LCcKTQ0F6xZRVTWJYqR5y6VoFI7a7Y66Tj576jn5UmmEpDIGGmO20UxVWZy1qe1qcYW+CQ1QF43DiWt/9p9nvSRnVYzaljaoVgdp8UX6xn9NBwdkwbIF1sKaOhesFk3VtVP2HZ8kqL0ZEtkST2j1/cfkxTOgvEhoqk33hwB0WO4qOMNHI+qBHJ5jSlOgPxyKaG+c9lyJao14a24rSJF3RG9e/miRcZyjMxXwD4frG8lHjsg3HwWuiz6te5Jp877
 oiNV0Lse
 SuT9HgUc+MhmJfEcDVb0wDDXfng96Lf+kbxX0FAW9R5ip+0F7o4Rb5Un5u4zQq6aX5LgY2RTfCFSr5XgLJq0EoF9cMrG+NT94f22PJ0vVQOV05yRbNxqGIQT7xGyVNWwVTigmTk3cWDoY9dbZhRpUPHWcEFMIJ2kXnexPQvwUs6oV5nrPJqx4DivsFlYffTmuR0XjdpVAn9M9fTPPoaYZysruBz64DkdLDmEh0OjNLRD72NGnECZzsvsRvyTCHJXTrzSXFq8S4NDbMppVBXvJDlA8h2Nk3FkniBcJDkVaLKSElxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Mar 18, 2026 at 01:36:07PM -0400, Zi Yan wrote:
> On 18 Mar 2026, at 13:19, Michał Cłapiński wrote:
> > On Wed, Mar 18, 2026 at 6:08 PM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> ## Call site analysis
> >>
> >> init_pageblock_migratetype() has nine call sites. The init call ordering
> >> relevant to scratch is:
> >>
> >> ```
> >> setup_arch()
> >>   zone_sizes_init() -> free_area_init() -> memmap_init_range()   [1]

Hmm, this is slightly outdated, but largely correct :)

> >>
> >> mm_init_free_all() / start_kernel():
> >>   kho_memory_init() -> kho_release_scratch()                     [2]
> >>   memblock_free_all()
> >>     free_low_memory_core_early()
> >>       memmap_init_reserved_pages()
> >>         reserve_bootmem_region() -> __init_deferred_page()
> >>           -> __init_page_from_nid()                              [3]
> >>   deferred init kthreads -> __init_page_from_nid()               [4]

And this is wrong, deferred init does not call __init_page_from_nid, only
reserve_bootmem_region() does.

And there's a case claude missed:

hugetlb_bootmem_free_invalid_page() -> __init_page_from_nid() that
shouldn't check for KHO. Well, at least until we have support for hugetlb
persistence and most probably even afterwards.

I don't think we should modify reserve_bootmem_region(). If there are
reserved pages in a pageblock, it does not matter if it's initialized to
MIGRATE_CMA. It only becomes important if the reserved pages freed, so we
can update pageblock migrate type in free_reserved_area().
When we boot with KHO, all memblock allocations come from scratch, so
anything freed in free_reserved_area() should become CMA again.

> >> ```
> >
> > I don't understand this. deferred_free_pages() doesn't call
> > __init_page_from_nid(). So I would clearly need to modify both
> > deferred_free_pages and __init_page_from_nid.

For deferred_free_pages() we don't need kho_scratch_overlap(), we already
have memblock_region (almost) at hand and it's enough to check if it's
MEMBLOCK_KHO_SCRATCH.

Something along these lines (compile tested only) should do the trick:

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 3e217414e12d..b9b1e0991ec8 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -275,6 +275,8 @@ static inline void __next_physmem_range(u64 *idx, struct memblock_type *type,
 	__for_each_mem_range(i, &memblock.reserved, NULL, NUMA_NO_NODE,	\
 			     MEMBLOCK_NONE, p_start, p_end, NULL)
 
+struct memblock_region *memblock_region_from_iter(u64 iterator);
+
 static inline bool memblock_is_hotpluggable(struct memblock_region *m)
 {
 	return m->flags & MEMBLOCK_HOTPLUG;
diff --git a/mm/memblock.c b/mm/memblock.c
index ae6a5af46bd7..9cf99f32279f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1359,6 +1359,16 @@ void __init_memblock __next_mem_range_rev(u64 *idx, int nid,
 	*idx = ULLONG_MAX;
 }
 
+__init_memblock struct memblock_region *memblock_region_from_iter(u64 iterator)
+{
+	int index = iterator & 0xffffffff;
+
+	if (index < 0 || index >= memblock.memory.cnt)
+		return NULL;
+
+	return &memblock.memory.regions[index];
+}
+
 /*
  * Common iterator interface used to define for_each_mem_pfn_range().
  */
diff --git a/mm/mm_init.c b/mm/mm_init.c
index cec7bb758bdd..96b25895ffbe 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1996,7 +1996,7 @@ unsigned long __init node_map_pfn_alignment(void)
 
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 static void __init deferred_free_pages(unsigned long pfn,
-		unsigned long nr_pages)
+		unsigned long nr_pages, enum migratetype mt)
 {
 	struct page *page;
 	unsigned long i;
@@ -2009,8 +2009,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 	/* Free a large naturally-aligned chunk if possible */
 	if (nr_pages == MAX_ORDER_NR_PAGES && IS_MAX_ORDER_ALIGNED(pfn)) {
 		for (i = 0; i < nr_pages; i += pageblock_nr_pages)
-			init_pageblock_migratetype(page + i, MIGRATE_MOVABLE,
-					false);
+			init_pageblock_migratetype(page + i, mt, false);
 		__free_pages_core(page, MAX_PAGE_ORDER, MEMINIT_EARLY);
 		return;
 	}
@@ -2020,8 +2019,7 @@ static void __init deferred_free_pages(unsigned long pfn,
 
 	for (i = 0; i < nr_pages; i++, page++, pfn++) {
 		if (pageblock_aligned(pfn))
-			init_pageblock_migratetype(page, MIGRATE_MOVABLE,
-					false);
+			init_pageblock_migratetype(page, mt, false);
 		__free_pages_core(page, 0, MEMINIT_EARLY);
 	}
 }
@@ -2077,6 +2075,8 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 	u64 i = 0;
 
 	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
+		struct memblock_region *region = memblock_region_from_iter(i);
+		enum migratetype mt = MIGRATE_MOVABLE;
 		unsigned long spfn = PFN_UP(start);
 		unsigned long epfn = PFN_DOWN(end);
 
@@ -2086,12 +2086,15 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 		spfn = max(spfn, start_pfn);
 		epfn = min(epfn, end_pfn);
 
+		if (memblock_is_kho_scratch(region))
+			mt = MIGRATE_CMA;
+
 		while (spfn < epfn) {
 			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
 			unsigned long chunk_end = min(mo_pfn, epfn);
 
 			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
-			deferred_free_pages(spfn, chunk_end - spfn);
+			deferred_free_pages(spfn, chunk_end - spfn, mt);
 
 			spfn = chunk_end;

-- 
Sincerely yours,
Mike.

