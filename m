Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6ED5C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 22:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43C5E6B0883; Sun, 16 Aug 2026 18:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A2216B0885; Sun, 16 Aug 2026 18:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2658E6B0886; Sun, 16 Aug 2026 18:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E21C06B0883
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 18:47:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4346D8058F
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:14 +0000 (UTC)
X-FDA: 85108619988.23.4B1E554
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4F3CE4000A
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:47:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e j7e+TP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=c72X5jXN;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786920432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vxOkKZOXXy3Z946h/BVNJ6lUnR6XJtenZlUIlDq4Kc=;
	b=B+6nwQ5/3qc1vnFMOGeTo0mNBFPEfDbqSqVqTH4gP00VxP9WAhLfTKYv87Vr1tlDFlilhd
	1dXmJLjhwHsNCbkD+q14AyBQMOUauUFE5VDesIIUMeeZWpftYfd2Zrkjc8ZlxU1Otw7E93
	i4p+aoiUmuDjAcymJ6kOrjnkgAUz7PY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="e j7e+TP";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=c72X5jXN;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786920432;
	b=eCEmPl/EkylX/1YCaC/MMVLkENZfDqKKeN0YQhYbhnVFLmmaRa0xILc6fs5F8+bf/pRWkN
	medNMs1Yc8eTEdGzrbQ1xAb/0wrLkVkawKWUd109IAbMvYVeEFlC8vA22zhIczKIYl/m+Z
	ZV61pSfuXpArug3jSHafUUK8KN27tPQ=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.phl.internal (Postfix) with ESMTP id DBA9414000EB;
	Sun, 16 Aug 2026 18:47:11 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-08.internal (MEProxy); Sun, 16 Aug 2026 18:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786920431; x=
	1787006831; bh=5vxOkKZOXXy3Z946h/BVNJ6lUnR6XJtenZlUIlDq4Kc=; b=e
	j7e+TPdpEvJk+CLODVtOPxNeRaoCzZ07RmVma+BC9p5W4liU5WJax2GG8a6uW/Pi
	Hjeyos4Wx4Bt7aAjpu6D4wQdTusdo98Am1Fyk2O3yNlpRlp4KbL0lqxj0K+suyLo
	jZouI9aP0r/Od4w86Zmvy4TNQCKar1JICU+WlGHHq5JCDJQ1e+d2s8tFy1Rp1zDw
	JYOapaeZ/U/nJCfvLTxauQnuwItFgs3evlxrrES8vEvSvdS9xmdFfdJpGjh2npA6
	1xmK/OqmO8+AUC5vXojNQ7t/xzjm0XTW5FXxt3XVBc2oPibqkGvmvchn/6uS40Oy
	LkfGQ+lH0zGHHHEkcfiGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786920431; x=1787006831; bh=5
	vxOkKZOXXy3Z946h/BVNJ6lUnR6XJtenZlUIlDq4Kc=; b=c72X5jXN4u6nSNsyR
	WoVzIes8h0Ty++u5ddkjgZQm7semKWLzEVDAnZllTZfqeCUFiZHi0GX0mZSHR+7h
	krIjvh/eS+7bzAgopHHnhYnTvpIQqJ/H4dtfiFgIUI+hYIzqwUpS/zGgBE0hCImC
	WxEiWVNLQIZYKAdxanM6kl7oVvcYubWx0WaD5Qk86iEEXz+YJd9cg+gCot5yjfpC
	I64sZFy9xDWQfeAuD4KPiK4Cf0hs3K5W+lHKTwCkTPvGqEU2cSoGc2zYJJwBkUwl
	4odwSvC+uezGPqU92SyCcFEiCVc/XhUC0NMiVe/7ims/vv+eSzEzrxxRU0Aqm1i+
	I0FFA==
X-ME-Sender: <xms:7z2CarxfCkkaYgd1o01iloI4BmxlV3hGfYt72Zemx8W-SUQCrYEG4A>
    <xme:7z2Cas2iixEw1y3Lz0Mgx2w7gtITj_nNH4rEnFk-dKOy24RerI-ufqOZD4Nt8MMQZ
    x64nmC1LvdU6alOvei7Mzrn4C4jX1XuBjORDf3pfOqGgnZMJ2Ze8cI>
X-ME-Received: <xmr:7z2CagxiQaV9WIn4oeQO63CQCucQjrWWroUprZVK1hKZY9Q38rzy6aLUdmk>
X-ME-Proxy-Cause: dmFkZTGQiHMMNOd1xnoN6lXQSIrGAe7MwYo75Qud3VSOh3aIjL1T4IX+wE1i/v23Y8aWnG
    m9SHT5inuXsr6fNeLF7q+XcMZ+pkZJxjpb2XQQyKrFdYKaLz7QDFEiegvQaT+Y5rGxRgjF
    euipinLXiFMtCpFgMqQP9Dwn4SHq3YG285QsMU4KB7YfRQHYWKIG6dJTmdP/7bPKv1qUNe
    3LkhBXaaROXWrLGafj+UVrogU8Abxo2OvgWTBKIlLl3SY5Eb27sggkfdoaZJgpjY1+W5mK
    IYgTH3bmg7umgeRjJmx+WAhyhWPmGn2xLzWKHa3nzXVCTdFk2+6Uh9D41+s+1+4ThvFtIG
    G5k5WQREbOISbTHWF1AMHMtLYEIvOP7kszcil1gNCk78M3Ta+EVbbPBEJ95pPNjpmGGlVN
    UK1pXd2EFV2Ai/H2/QkOYFvsvoHN3YWCaJDX2TUcCxivhtPjIx1k4KDwFwEEeqlImpYeZv
    mJE8eWmYgLKN1rPrVdmcQLlhlCai1L/6WQTF49kw0XwE5e/zmV5JutM4uCFLxO5Bm1qWJs
    6IcR3Tz23zpt8wa7bFHRkr00+f03DT+UWDRr53j3CESqVEAiKRRp67A/tpae6m8HuCS+p6
    ZUHJGZX4VmVY6to7mPwkjyH8FNQMOB1Po5MJl+t/tB6Y7is9ZoGTDP0vL9dA
X-ME-Proxy: <xmx:7z2CakPIXuU2zVaDI2wE8vpckAuLfQKqM0MVUBrxxBR-IDxb3YREzw>
    <xmx:7z2Cat6UDJl4VqoWhGrgygr-bYPjTu2dSf8KwsD9Eb6y62ehRYk8xQ>
    <xmx:7z2Cajcri5U-1feTTYJffei4_-0yipmfCv2zd2EGMNjrbvmshvto0Q>
    <xmx:7z2Carh0wtowCadfnwcHdFnCeQUKvXW5n2xi2pl5R8e_oLKpq4GxIw>
    <xmx:7z2CagvG51okU251Ib4S22MQUI2bQIXJngSz2HaGFb16QNtUkVAdqucU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 16 Aug 2026 18:47:10 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org,
	jannh@google.com,
	willy@infradead.org,
	pfalcato@suse.de,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [RFC PATCH 28/57] mm/collapse: remove the mechanism the engine replaces
Date: Sun, 16 Aug 2026 23:45:40 +0100
Message-ID: <20260816224609.308019-29-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260816224609.308019-1-kirill@shutemov.name>
References: <20260816224609.308019-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k9skyhastghyuoitqpidnker17k5w7hz
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4F3CE4000A
X-HE-Tag: 1786920432-752660
X-HE-Meta: U2FsdGVkX1+uzALVQ869AxZc40Cbcuxb9rN7u+omH9R4zrwiv+nMl4ufk75WSqq+EUWWmrSVsH2TS+8SMk6EfSilMVz+ogK2pGLPx6AVjlbDJ68mRfHW/WocQlwksSDEUQNwj/u/PcHjstRGaABgaB2iCC+IAAfnX6qmj5mUT3LzAYoFuCj+cwE4Xr0CSDLjVtpAsIKLiVsEGRwyWJZX5elWM/ih2mRyZNAmajd7eB0dYlKyRyh9QYKxFfPL1HR7KOVS0yBGhI9rDIHg/nV/dV2GMY62mZJ2syHLPlKk55IzXMhOTNasAtOXeP4z3DAv4vSp5F+OYlZYRAo/+1e3x5XoWI7Ecr2wn4Wi227a9JtnSh3Q8mo6PGHlspweIuedYlautDhzmZBlPzr97FjcZhO2aIu70EKPxYXOuc9lWJakPaixJB9aBbXt8Y1l0gLc0mXjcEI3IhPJxl7tGfPjOuMJ7DUPu2zMGXrFRpE9g1gtLEerbrU6+zwE+r76eq3We2jIlxjvan63fbHCgNtDtm0AwBB54wnA0cipn8l8oqrMGxkmxTql/1tqB5TSY9puvJgpr7/o9O0QTelaauUfPc7fOojwaW1PYKlbSf75BVGyQLbprFSaE2tTC/abT9d7N12Yp13r0V8U4ow85KFIUmiEWDqmYoPIkjBu05FJ5zlhLgcJZPrVB7ekeOYkKKm6G7oBvIpYwcYuaMVY5tBAyRhT8Luw3lPO9wCh++zP6j5U38BP1MGmb/8s+mblR/hm+VB2sBdu3MvqFtv00iLW9Fqmx+bnsveu1+lOSo3MXErFPPMffvhwcNOAS0FZI/NyZQx9NcY5DhNhaYAo121dkDI0oQNZb+DnaLf35Rs7xnIUyvShAQ7UtjWiMKNoraBSIDecz5MyRot1794bzhBEgPJhrjsHgsSfHtOamz++nnVg/e1C/7GVx5Mfw0zQA3FpcAVmD39PbUEw2oSTHQU
 P3kRTNf1
 rZ+WD6JMWUde5SiKDnUeGpn0FIzAFeEuIkUIKUUxtoqar50XSiwVW+FXkdvUk81pRb68tt4b+/iqi6vJ32dFwAtxZQoMA5T50sgrgJCMD6Ld4Hsvsyq7CXwFtoGThQuxgoHvapZVjZRKuHmUt7iZzsVvaNQSmnLaiTRQ5YSb60bGnLWfOkiGgbpAUO7AStmXtp+sr6/BcBwnNsWem4kw+9EKO5DbuRtExwBJ+OFROymaj7H0ERhvU8UBaivS1nWI3UspQsZS2HSIVwQfbFye3ZYbUA93C5m/24Ml3fUUmEb196FX0I+WhDKhuMQ55ZEGjXepOjsmu/x3jkSHmqSXf1VQIdD5jtzlnHuFpKhX9AnbYAToAyxL9FXtcPHdofmRzoBTxjQup3UkxYTpsEXyk6VoGYUTG27UifyJEdvQVlJjzMt3Diwt4BqnTXi8ZJ01lleSknYWax3u07Vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Nothing reaches the old anonymous collapse any more: the entry point was
rewired to the engine, and every function below it lost its last caller.

Delete the chain: the scan, the mTHP order walk, the collapse itself,
isolation, swap-in, the copy with its success and failure paths, the PTE
release helpers, folio_pte_referenced() and the pmd-still-valid check.

What stays is what the file paths and MADV_COLLAPSE still call:
alloc_charge_folio() for a file collapse's destination,
hugepage_vma_revalidate() for the VMA check after MADV_COLLAPSE drops
mmap_lock, and count_collapse_event() and collapse_control_init_scan()
for the file scan.

Four tracepoints lose their only emitter here: mm_khugepaged_scan_pmd,
mm_collapse_huge_page, mm_collapse_huge_page_isolate and
mm_collapse_huge_page_swapin.  Their definitions stay, now without an
emitter, and the engine reports through mm_collapse_candidate.

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 984 +-----------------------------------------------
 1 file changed, 9 insertions(+), 975 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 895183d92fb8..6203473f4953 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -545,370 +545,6 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
-{
-	memset(cc->node_load, 0, sizeof(cc->node_load));
-	nodes_clear(cc->alloc_nmask);
-	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
-}
-
-static void release_pte_folio(struct folio *folio)
-{
-	node_stat_mod_folio(folio,
-			NR_ISOLATED_ANON + folio_is_file_lru(folio),
-			-folio_nr_pages(folio));
-	folio_unlock(folio);
-	folio_putback_lru(folio);
-}
-
-static void release_pte_pages(pte_t *pte, pte_t *_pte,
-		struct list_head *compound_pagelist)
-{
-	struct folio *folio, *tmp;
-
-	while (--_pte >= pte) {
-		pte_t pteval = ptep_get(_pte);
-		unsigned long pfn;
-
-		if (pte_none(pteval))
-			continue;
-		VM_WARN_ON_ONCE(!pte_present(pteval));
-		pfn = pte_pfn(pteval);
-		if (is_zero_pfn(pfn))
-			continue;
-		folio = pfn_folio(pfn);
-		if (folio_test_large(folio))
-			continue;
-		release_pte_folio(folio);
-	}
-
-	list_for_each_entry_safe(folio, tmp, compound_pagelist, lru) {
-		list_del(&folio->lru);
-		release_pte_folio(folio);
-	}
-}
-
-/*
- * folio_pte_referenced() - Check if a folio or its PTE mapping was recently used
- *
- * Return: true if recent access was observed through either the folio state
- * or the current PTE mapping.
- */
-static inline bool folio_pte_referenced(struct folio *folio,
-		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
-{
-	/* The folio was referenced previously ... */
-	if (folio_test_young(folio) || folio_test_referenced(folio))
-		return true;
-	/* ... or the PTE mapping was recently used */
-	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr);
-}
-
-static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
-		enum mthp_stat_item mthp_event)
-{
-	if (is_pmd_order(order))
-		count_vm_event(vm_event);
-	count_mthp_stat(order, mthp_event);
-}
-
-static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
-		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
-		unsigned int order, struct list_head *compound_pagelist)
-{
-	const unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, order);
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, order);
-	const unsigned long nr_pages = 1UL << order;
-	struct page *page = NULL;
-	struct folio *folio = NULL;
-	unsigned long addr = start_addr;
-	pte_t *_pte;
-	int none_or_zero = 0, shared = 0, referenced = 0;
-	enum scan_result result = SCAN_FAIL;
-
-	for (_pte = pte; _pte < pte + nr_pages;
-	     _pte++, addr += PAGE_SIZE) {
-		pte_t pteval = ptep_get(_pte);
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			result = SCAN_PTE_NON_PRESENT;
-			goto out;
-		}
-		if (pte_uffd(pteval)) {
-			result = SCAN_PTE_UFFD;
-			goto out;
-		}
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out;
-		}
-
-		folio = page_folio(page);
-		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
-
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
-			goto out;
-		}
-
-		/* See collapse_scan_pmd(). */
-		if (folio_maybe_mapped_shared(folio)) {
-			/*
-			 * TODO: Support shared pages without leading to further
-			 * mTHP collapses. Currently bringing in new pages via
-			 * shared may cause a future higher order collapse on a
-			 * rescan of the same range.
-			 */
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(order, THP_SCAN_EXCEED_SHARED_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out;
-			}
-		}
-		/*
-		 * TODO: In some cases of partially-mapped folios, we'd actually
-		 * want to collapse.
-		 */
-		if (!is_pmd_order(order) && folio_order(folio) >= order) {
-			result = SCAN_PTE_MAPPED_HUGEPAGE;
-			goto out;
-		}
-
-		if (folio_test_large(folio)) {
-			struct folio *f;
-
-			/*
-			 * Check if we have dealt with the compound page
-			 * already
-			 */
-			list_for_each_entry(f, compound_pagelist, lru) {
-				if (folio == f)
-					goto next;
-			}
-		}
-
-		/*
-		 * We can do it before folio_isolate_lru because the
-		 * folio can't be freed from under us. NOTE: folio lock
-		 * is needed to serialize against split_huge_page()
-		 * when invoked from the VM.
-		 */
-		if (!folio_trylock(folio)) {
-			result = SCAN_PAGE_LOCK;
-			goto out;
-		}
-
-		/*
-		 * Check if the page has any GUP (or other external) pins.
-		 *
-		 * The page table that maps the page has been already unlinked
-		 * from the page table tree and this process cannot get
-		 * an additional pin on the page.
-		 *
-		 * New pins can come later if the page is shared across fork,
-		 * but not from this process. The other process cannot write to
-		 * the page, only trigger CoW.
-		 */
-		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
-			folio_unlock(folio);
-			result = SCAN_PAGE_COUNT;
-			goto out;
-		}
-
-		/*
-		 * Isolate the folio to avoid collapsing a hugepage
-		 * currently in use by the VM.
-		 */
-		if (!folio_isolate_lru(folio)) {
-			folio_unlock(folio);
-			result = SCAN_DEL_PAGE_LRU;
-			goto out;
-		}
-		node_stat_mod_folio(folio,
-				NR_ISOLATED_ANON + folio_is_file_lru(folio),
-				folio_nr_pages(folio));
-		VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-		VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
-
-		if (folio_test_large(folio))
-			list_add_tail(&folio->lru, compound_pagelist);
-next:
-		if (cc->policy.require_referenced &&
-		    folio_pte_referenced(folio, vma, addr, pteval))
-			referenced++;
-	}
-
-	if (unlikely(cc->policy.require_referenced && !referenced)) {
-		result = SCAN_LACK_REFERENCED_PAGE;
-	} else {
-		result = SCAN_SUCCEED;
-		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-						    referenced, result, order);
-		return result;
-	}
-out:
-	release_pte_pages(pte, _pte, compound_pagelist);
-	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
-					    referenced, result, order);
-	return result;
-}
-
-static void __collapse_huge_page_copy_succeeded(pte_t *pte,
-		struct vm_area_struct *vma, unsigned long address,
-		spinlock_t *ptl, unsigned int order,
-		struct list_head *compound_pagelist)
-{
-	const unsigned long nr_pages = 1UL << order;
-	unsigned long end = address + (PAGE_SIZE * nr_pages);
-	struct folio *src, *tmp;
-	pte_t pteval;
-	pte_t *_pte;
-	unsigned int nr_ptes;
-
-	for (_pte = pte; _pte < pte + nr_pages; _pte += nr_ptes,
-	     address += nr_ptes * PAGE_SIZE) {
-		nr_ptes = 1;
-		pteval = ptep_get(_pte);
-		if (pte_none_or_zero(pteval)) {
-			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
-			if (pte_none(pteval))
-				continue;
-			/*
-			 * ptl mostly unnecessary.
-			 */
-			spin_lock(ptl);
-			ptep_clear(vma->vm_mm, address, _pte);
-			spin_unlock(ptl);
-			ksm_might_unmap_zero_page(vma->vm_mm, pteval);
-		} else {
-			struct page *src_page = pte_page(pteval);
-
-			src = page_folio(src_page);
-
-			if (folio_test_large(src)) {
-				unsigned int max_nr_ptes = (end - address) >> PAGE_SHIFT;
-
-				nr_ptes = folio_pte_batch(src, _pte, pteval, max_nr_ptes);
-			} else {
-				release_pte_folio(src);
-			}
-
-			/*
-			 * ptl mostly unnecessary, but preempt has to
-			 * be disabled to update the per-cpu stats
-			 * inside folio_remove_rmap_pte().
-			 */
-			spin_lock(ptl);
-			clear_ptes(vma->vm_mm, address, _pte, nr_ptes);
-			folio_remove_rmap_ptes(src, src_page, nr_ptes, vma);
-			spin_unlock(ptl);
-			free_swap_cache(src);
-			folio_put_refs(src, nr_ptes);
-		}
-	}
-
-	list_for_each_entry_safe(src, tmp, compound_pagelist, lru) {
-		list_del(&src->lru);
-		node_stat_sub_folio(src, NR_ISOLATED_ANON +
-				folio_is_file_lru(src));
-		folio_unlock(src);
-		free_swap_cache(src);
-		folio_putback_lru(src);
-	}
-}
-
-static void __collapse_huge_page_copy_failed(pte_t *pte,
-		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned int order, struct list_head *compound_pagelist)
-{
-	const unsigned long nr_pages = 1UL << order;
-	spinlock_t *pmd_ptl;
-
-	/*
-	 * Re-establish the PMD to point to the original page table
-	 * entry. Restoring PMD needs to be done prior to releasing
-	 * pages. Since pages are still isolated and locked here,
-	 * acquiring anon_vma_lock_write() is unnecessary.
-	 */
-	pmd_ptl = pmd_lock(vma->vm_mm, pmd);
-	pmd_populate(vma->vm_mm, pmd, pmd_pgtable(orig_pmd));
-	spin_unlock(pmd_ptl);
-	/*
-	 * Release both raw and compound pages isolated
-	 * in __collapse_huge_page_isolate.
-	 */
-	release_pte_pages(pte, pte + nr_pages, compound_pagelist);
-}
-
-/*
- * __collapse_huge_page_copy - attempts to copy memory contents from raw
- * pages to a hugepage. Cleans up the raw pages if copying succeeds;
- * otherwise restores the original page table and releases isolated raw pages.
- * Returns SCAN_SUCCEED if copying succeeds, otherwise returns SCAN_COPY_MC.
- *
- * @pte: starting of the PTEs to copy from
- * @folio: the new hugepage to copy contents to
- * @pmd: pointer to the new hugepage's PMD
- * @orig_pmd: the original raw pages' PMD
- * @vma: the original raw pages' virtual memory area
- * @address: starting address to copy
- * @ptl: lock on raw pages' PTEs
- * @compound_pagelist: list that stores compound pages
- */
-static enum scan_result __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
-		pmd_t *pmd, pmd_t orig_pmd, struct vm_area_struct *vma,
-		unsigned long address, spinlock_t *ptl, unsigned int order,
-		struct list_head *compound_pagelist)
-{
-	const unsigned long nr_pages = 1UL << order;
-	unsigned int i;
-	enum scan_result result = SCAN_SUCCEED;
-
-	/*
-	 * Copying pages' contents is subject to memory poison at any iteration.
-	 */
-	for (i = 0; i < nr_pages; i++) {
-		pte_t pteval = ptep_get(pte + i);
-		struct page *page = folio_page(folio, i);
-		unsigned long src_addr = address + i * PAGE_SIZE;
-		struct page *src_page;
-
-		if (pte_none_or_zero(pteval)) {
-			clear_user_highpage(page, src_addr);
-			continue;
-		}
-		src_page = pte_page(pteval);
-		if (copy_mc_user_highpage(page, src_page, src_addr, vma) > 0) {
-			result = SCAN_COPY_MC;
-			break;
-		}
-	}
-
-	if (likely(result == SCAN_SUCCEED))
-		__collapse_huge_page_copy_succeeded(pte, vma, address, ptl,
-						    order, compound_pagelist);
-	else
-		__collapse_huge_page_copy_failed(pte, pmd, orig_pmd, vma,
-						 order, compound_pagelist);
-
-	return result;
-}
-
 static void khugepaged_alloc_sleep(void)
 {
 	DEFINE_WAIT(wait);
@@ -1089,119 +725,19 @@ enum scan_result find_pmd_or_thp_or_none(struct mm_struct *mm,
 	return check_pmd_state(*pmd);
 }
 
-static enum scan_result check_pmd_still_valid(struct mm_struct *mm,
-		unsigned long address, pmd_t *pmd)
+static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
+		enum mthp_stat_item mthp_event)
 {
-	pmd_t *new_pmd;
-	enum scan_result result = find_pmd_or_thp_or_none(mm, address, &new_pmd);
-
-	if (result != SCAN_SUCCEED)
-		return result;
-	if (new_pmd != pmd)
-		return SCAN_FAIL;
-	return SCAN_SUCCEED;
+	if (is_pmd_order(order))
+		count_vm_event(vm_event);
+	count_mthp_stat(order, mthp_event);
 }
 
-/*
- * Bring missing pages in from swap, to complete THP collapse.
- * Only done if collapse_scan_pmd() believes it is worthwhile.
- *
- * For mTHP orders the function bails on the first swap entry, because
- * faulting pages back in during collapse could re-populate PTEs that
- * push a later scan over the threshold for a higher-order collapse.
- *
- * Called and returns without pte mapped or spinlocks held.
- * Returns result: if not SCAN_SUCCEED, mmap_lock has been released.
- */
-static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		pmd_t *pmd, int referenced, unsigned int order)
+static void collapse_control_init_scan(struct collapse_control *cc)
 {
-	int swapped_in = 0;
-	vm_fault_t ret = 0;
-	unsigned long addr, end = start_addr + (PAGE_SIZE << order);
-	enum scan_result result;
-	pte_t *pte = NULL;
-	spinlock_t *ptl;
-
-	for (addr = start_addr; addr < end; addr += PAGE_SIZE) {
-		struct vm_fault vmf = {
-			.vma = vma,
-			.address = addr,
-			.pgoff = linear_page_index(vma, addr),
-			.flags = FAULT_FLAG_ALLOW_RETRY,
-			.pmd = pmd,
-		};
-
-		if (!pte++) {
-			/*
-			 * Here the ptl is only used to check pte_same() in
-			 * do_swap_page(), so readonly version is enough.
-			 */
-			pte = pte_offset_map_ro_nolock(mm, pmd, addr, &ptl);
-			if (!pte) {
-				mmap_read_unlock(mm);
-				result = SCAN_NO_PTE_TABLE;
-				goto out;
-			}
-		}
-
-		vmf.orig_pte = ptep_get_lockless(pte);
-		if (pte_none(vmf.orig_pte) ||
-		    pte_present(vmf.orig_pte))
-			continue;
-
-		/*
-		 * TODO: Support swapin without leading to further mTHP
-		 * collapses. Currently bringing in new pages via swapin may
-		 * cause a future higher order collapse on a rescan of the same
-		 * range.
-		 */
-		if (!is_pmd_order(order)) {
-			count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
-			pte_unmap(pte);
-			mmap_read_unlock(mm);
-			result = SCAN_EXCEED_SWAP_PTE;
-			goto out;
-		}
-
-		vmf.pte = pte;
-		vmf.ptl = ptl;
-		ret = do_swap_page(&vmf);
-		/* Which unmaps pte (after perhaps re-checking the entry) */
-		pte = NULL;
-
-		/*
-		 * do_swap_page() returns VM_FAULT_RETRY with released mmap_lock.
-		 * Note we treat VM_FAULT_RETRY as VM_FAULT_ERROR here because
-		 * we do not retry here and swap entry will remain in pagetable
-		 * resulting in later failure.
-		 */
-		if (ret & VM_FAULT_RETRY) {
-			/* Likely, but not guaranteed, that page lock failed */
-			result = SCAN_PAGE_LOCK;
-			goto out;
-		}
-		if (ret & VM_FAULT_ERROR) {
-			mmap_read_unlock(mm);
-			result = SCAN_FAIL;
-			goto out;
-		}
-		swapped_in++;
-	}
-
-	if (pte)
-		pte_unmap(pte);
-
-	/* Drain LRU cache to remove extra pin on the swapped in pages */
-	if (swapped_in)
-		lru_add_drain();
-
-	result = SCAN_SUCCEED;
-out:
-	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
-					   order);
-	return result;
+	memset(cc->node_load, 0, sizeof(cc->node_load));
+	nodes_clear(cc->alloc_nmask);
+	bitmap_zero(cc->eligible_ptes, MAX_PTRS_PER_PTE);
 }
 
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
@@ -1234,197 +770,6 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	return SCAN_SUCCEED;
 }
 
-/*
- * collapse_huge_page() expects the mmap_lock to be unlocked before entering and
- * will always return with the lock unlocked, to avoid holding the mmap_lock
- * while allocating a THP, as that could trigger direct reclaim/compaction.
- * Note that the VMA must be rechecked after grabbing the mmap_lock again.
- */
-static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long start_addr,
-		int referenced, int unmapped, struct collapse_control *cc,
-		unsigned int order)
-{
-	const unsigned long pmd_addr = start_addr & HPAGE_PMD_MASK;
-	const unsigned long end_addr = start_addr + (PAGE_SIZE << order);
-	LIST_HEAD(compound_pagelist);
-	pmd_t *pmd, _pmd;
-	pte_t *pte = NULL;
-	pgtable_t pgtable;
-	struct folio *folio;
-	spinlock_t *pmd_ptl, *pte_ptl;
-	enum scan_result result = SCAN_FAIL;
-	struct vm_area_struct *vma;
-	struct mmu_notifier_range range;
-	bool anon_vma_locked = false;
-
-	result = alloc_charge_folio(&folio, mm, cc, order);
-	if (result != SCAN_SUCCEED)
-		goto out_nolock;
-
-	if (folio_memcg_alloc_deferred(folio)) {
-		result = SCAN_ALLOC_HUGE_PAGE_FAIL;
-		goto out_nolock;
-	}
-
-	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
-					 &vma, cc, order);
-	if (result != SCAN_SUCCEED) {
-		mmap_read_unlock(mm);
-		goto out_nolock;
-	}
-
-	result = find_pmd_or_thp_or_none(mm, pmd_addr, &pmd);
-	if (result != SCAN_SUCCEED) {
-		mmap_read_unlock(mm);
-		goto out_nolock;
-	}
-
-	if (unmapped) {
-		/*
-		 * __collapse_huge_page_swapin() will return with mmap_lock
-		 * released when it fails. So we jump out_nolock directly in
-		 * that case.  Continuing to collapse causes inconsistency.
-		 */
-		result = __collapse_huge_page_swapin(mm, vma, start_addr, pmd,
-						     referenced, order);
-		if (result != SCAN_SUCCEED)
-			goto out_nolock;
-	}
-
-	mmap_read_unlock(mm);
-	/*
-	 * Prevent all access to pagetables with the exception of
-	 * gup_fast later handled by the pmdp_collapse_flush() and the VM
-	 * handled by the anon_vma lock + folio lock.
-	 *
-	 * UFFDIO_MOVE is prevented to race as well thanks to the
-	 * mmap_lock.
-	 */
-	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
-					 &vma, cc, order);
-	if (result != SCAN_SUCCEED)
-		goto out_up_write;
-	/* check if the pmd is still valid */
-	vma_start_write(vma);
-	result = check_pmd_still_valid(mm, pmd_addr, pmd);
-	if (result != SCAN_SUCCEED)
-		goto out_up_write;
-
-	anon_vma_lock_write(vma->anon_vma);
-	anon_vma_locked = true;
-
-	/*
-	 * Only notify about the PTE range we will actually modify. While we
-	 * temporary unmap the whole PTE table for mTHP collapse, we'll remap
-	 * it later, leaving other PTEs effectively unmodified. The locks we
-	 * hold prevent anybody from stumbling over such temporarily unmapped
-	 * PTE tables.
-	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
-				end_addr);
-	mmu_notifier_invalidate_range_start(&range);
-
-	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
-	/*
-	 * This removes any huge TLB entry from the CPU so we won't allow
-	 * huge and small TLB entries for the same virtual address to
-	 * avoid the risk of CPU bugs in that area.
-	 *
-	 * Parallel GUP-fast is fine since GUP-fast will back off when
-	 * it detects PMD is changed.
-	 */
-	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
-	spin_unlock(pmd_ptl);
-	mmu_notifier_invalidate_range_end(&range);
-	tlb_remove_table_sync_one();
-
-	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
-	if (pte) {
-		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
-						      order, &compound_pagelist);
-		spin_unlock(pte_ptl);
-	} else {
-		result = SCAN_NO_PTE_TABLE;
-	}
-
-	if (unlikely(result != SCAN_SUCCEED)) {
-		spin_lock(pmd_ptl);
-		VM_WARN_ON_ONCE(!pmd_none(*pmd));
-		/*
-		 * We can only use set_pmd_at() when establishing
-		 * hugepmds and never for establishing regular pmds that
-		 * points to regular pagetables. Use pmd_populate() for that
-		 */
-		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
-		spin_unlock(pmd_ptl);
-		goto out_up_write;
-	}
-
-	/*
-	 * For PMD collapse all pages are isolated and locked so anon_vma
-	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
-	 * removed and not all pages are isolated and locked, so we must hold
-	 * the lock to prevent neighboring folios from attempting to access
-	 * this PMD until its reinstalled.
-	 */
-	if (is_pmd_order(order)) {
-		anon_vma_unlock_write(vma->anon_vma);
-		anon_vma_locked = false;
-	}
-
-	result = __collapse_huge_page_copy(pte, folio, pmd, _pmd,
-					   vma, start_addr, pte_ptl,
-					   order, &compound_pagelist);
-	if (unlikely(result != SCAN_SUCCEED))
-		goto out_up_write;
-
-	/*
-	 * The smp_wmb() inside __folio_mark_uptodate() ensures the
-	 * copy_huge_page writes become visible before the set_pmd_at()
-	 * write.
-	 */
-	__folio_mark_uptodate(folio);
-	spin_lock(pmd_ptl);
-	VM_WARN_ON_ONCE(!pmd_none(*pmd));
-	if (is_pmd_order(order)) {
-		pgtable = pmd_pgtable(_pmd);
-		pgtable_trans_huge_deposit(mm, pmd, pgtable);
-		map_anon_folio_pmd_nopf(folio, pmd, vma, pmd_addr);
-	} else {
-		/*
-		 * Some architectures (e.g. MIPS) walk the live page table in
-		 * their implementation. update_mmu_cache_range() must be called
-		 * with a valid page table hierarchy and the PTE lock held.
-		 * Acquire it nested inside pmd_ptl when they are distinct locks.
-		 */
-		if (pte_ptl != pmd_ptl)
-			spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
-		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
-		map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
-					  /*uffd_wp=*/ false);
-		if (pte_ptl != pmd_ptl)
-			spin_unlock(pte_ptl);
-	}
-	spin_unlock(pmd_ptl);
-
-	folio = NULL;
-
-	result = SCAN_SUCCEED;
-out_up_write:
-	if (pte)
-		pte_unmap(pte);
-	if (anon_vma_locked)
-		anon_vma_unlock_write(vma->anon_vma);
-	mmap_write_unlock(mm);
-out_nolock:
-	if (folio)
-		folio_put(folio);
-	trace_mm_collapse_huge_page(mm, result == SCAN_SUCCEED, result, order);
-	return result;
-}
-
 /* Return the highest naturally aligned order that fits at @offset within a PMD. */
 unsigned int max_order_from_offset(unsigned int offset)
 {
@@ -1434,317 +779,6 @@ unsigned int max_order_from_offset(unsigned int offset)
 	return min_t(unsigned int, __ffs(offset), HPAGE_PMD_ORDER);
 }
 
-/*
- * mthp_collapse() consumes the bitmap that is generated during
- * collapse_scan_pmd() to determine what regions and mTHP orders fit best.
- *
- * Each bit in cc->eligible_ptes marks a PTE the scan accepted as a collapse
- * source. We start at the PMD order and check if it is eligible for collapse;
- * if not, we check the left and right halves of the PTE page table we are
- * examining at a lower order.
- *
- * For each of these, we determine how many PTE entries are occupied in the
- * range of PTE entries we propose to collapse, then we compare this to a
- * threshold number of PTE entries which would need to be occupied for a
- * collapse to be permitted at that order (accounting for max_ptes_none).
- *
- * If a collapse is permitted, we attempt to collapse the PTE range into a
- * mTHP.
- */
-static enum scan_result mthp_collapse(struct mm_struct *mm,
-		unsigned long address, int referenced, int unmapped,
-		struct collapse_control *cc, unsigned long enabled_orders)
-{
-	unsigned int nr_occupied_ptes, nr_ptes, max_ptes_none;
-	enum scan_result last_result = SCAN_FAIL;
-	int collapsed = 0;
-	bool alloc_failed = false;
-	unsigned long collapse_address;
-	unsigned int offset = 0;
-	unsigned int order = HPAGE_PMD_ORDER;
-
-	while (offset < HPAGE_PMD_NR) {
-		nr_ptes = 1UL << order;
-
-		if (!test_bit(order, &enabled_orders))
-			goto next_order;
-
-		max_ptes_none = collapse_max_ptes_none(cc, NULL, order);
-		nr_occupied_ptes = bitmap_weight_from(cc->eligible_ptes, offset,
-						      offset + nr_ptes);
-
-		/*
-		 * Swap PTEs accepted during the scan are counted in @unmapped,
-		 * not in the eligible bitmap. Account them for the PMD-order
-		 * candidate.
-		 */
-		if (is_pmd_order(order))
-			nr_occupied_ptes += unmapped;
-
-		if (nr_occupied_ptes >= nr_ptes - max_ptes_none) {
-			enum scan_result ret;
-
-			collapse_address = address + offset * PAGE_SIZE;
-			ret = collapse_huge_page(mm, collapse_address, referenced,
-						 unmapped, cc, order);
-
-			switch (ret) {
-			/* Cases where we continue to next collapse candidate */
-			case SCAN_SUCCEED:
-				collapsed += nr_ptes;
-				fallthrough;
-			case SCAN_PTE_MAPPED_HUGEPAGE:
-				goto next_offset;
-			/* Cases where lower orders might still succeed */
-			case SCAN_ALLOC_HUGE_PAGE_FAIL:
-				alloc_failed = true;
-				fallthrough;
-			case SCAN_LACK_REFERENCED_PAGE:
-			case SCAN_EXCEED_NONE_PTE:
-			case SCAN_EXCEED_SWAP_PTE:
-			case SCAN_EXCEED_SHARED_PTE:
-			case SCAN_PAGE_LOCK:
-			case SCAN_PAGE_COUNT:
-			case SCAN_PAGE_NULL:
-			case SCAN_DEL_PAGE_LRU:
-			case SCAN_PTE_NON_PRESENT:
-			case SCAN_PTE_UFFD:
-			case SCAN_PAGE_LAZYFREE:
-				last_result = ret;
-				goto next_order;
-			/* Cases where no further collapse is possible */
-			case SCAN_PMD_MAPPED:
-				fallthrough;
-			default:
-				last_result = ret;
-				goto done;
-			}
-		}
-
-next_order:
-		/*
-		 * Continue with the next smaller order if there is still
-		 * any smaller order enabled. When at the smallest order
-		 * we must always move to the next offset.
-		 */
-		if (order > COLLAPSE_MIN_MTHP_ORDER &&
-		    (enabled_orders & GENMASK(order - 1, 0))) {
-			order--;
-			continue;
-		}
-next_offset:
-		/*
-		 * Advance past the region we just processed and determine the
-		 * highest order we can attempt next. Since huge pages must be
-		 * naturally aligned, the max order we can attempt next is
-		 * limited by the alignment of the new offset.
-		 * E.g. if we collapsed a order-2 mTHP at offset 0, offset
-		 * becomes 4 and __ffs(4) == 2, so the next attempt starts at
-		 * order 2.
-		 */
-		offset += nr_ptes;
-		order = max_order_from_offset(offset);
-	}
-done:
-	if (collapsed)
-		return SCAN_SUCCEED;
-	if (alloc_failed)
-		return SCAN_ALLOC_HUGE_PAGE_FAIL;
-	return last_result;
-}
-
-static enum scan_result __maybe_unused
-collapse_scan_pmd(struct mm_struct *mm,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		bool *lock_dropped, struct collapse_control *cc)
-{
-	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
-	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
-	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->policy.tva_type;
-	pmd_t *pmd;
-	pte_t *pte, *_pte, pteval;
-	int i;
-	int none_or_zero = 0, shared = 0, referenced = 0;
-	enum scan_result result = SCAN_FAIL;
-	struct page *page = NULL;
-	struct folio *folio = NULL;
-	unsigned long addr;
-	unsigned long enabled_orders;
-	spinlock_t *ptl;
-	int node = NUMA_NO_NODE, unmapped = 0;
-
-	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
-
-	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
-	if (result != SCAN_SUCCEED) {
-		cc->progress++;
-		goto out;
-	}
-
-	collapse_control_init_scan(cc);
-
-	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
-
-	/*
-	 * If PMD is the only enabled order, enforce max_ptes_none, otherwise
-	 * scan all pages to populate the bitmap for mTHP collapse. The bitmap
-	 * is then checked again in mthp_collapse() for each attempted order.
-	 */
-	if (enabled_orders != BIT(HPAGE_PMD_ORDER))
-		max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
-
-	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
-	if (!pte) {
-		cc->progress++;
-		result = SCAN_NO_PTE_TABLE;
-		goto out;
-	}
-
-	for (i = 0; i < HPAGE_PMD_NR; i++) {
-		_pte = pte + i;
-		addr = start_addr + i * PAGE_SIZE;
-		pteval = ptep_get(_pte);
-
-		cc->progress++;
-
-		if (pte_none_or_zero(pteval)) {
-			if (++none_or_zero > max_ptes_none) {
-				result = SCAN_EXCEED_NONE_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_NONE_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_NONE);
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (!pte_present(pteval)) {
-			if (++unmapped > max_ptes_swap) {
-				result = SCAN_EXCEED_SWAP_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SWAP_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SWAP);
-				goto out_unmap;
-			}
-			/*
-			 * Always be strict with uffd-wp
-			 * enabled swap entries.  Please see
-			 * comment below for pte_uffd().
-			 */
-			if (pte_swp_uffd_any(pteval)) {
-				result = SCAN_PTE_UFFD;
-				goto out_unmap;
-			}
-			continue;
-		}
-		if (pte_uffd(pteval)) {
-			/*
-			 * Don't collapse the page if any of the small
-			 * PTEs are armed with uffd write protection.
-			 * Here we can also mark the new huge pmd as
-			 * write protected if any of the small ones is
-			 * marked but that could bring unknown
-			 * userfault messages that falls outside of
-			 * the registered range.  So, just be simple.
-			 */
-			result = SCAN_PTE_UFFD;
-			goto out_unmap;
-		}
-
-		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
-			result = SCAN_PAGE_NULL;
-			goto out_unmap;
-		}
-		folio = page_folio(page);
-
-		/*
-		 * If the vma has the VM_DROPPABLE flag, the collapse will
-		 * preserve the lazyfree property without needing to skip.
-		 */
-		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
-		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
-			result = SCAN_PAGE_LAZYFREE;
-			goto out_unmap;
-		}
-
-		if (!folio_test_anon(folio)) {
-			result = SCAN_PAGE_ANON;
-			goto out_unmap;
-		}
-
-		/*
-		 * We treat a single page as shared if any part of the THP
-		 * is shared.
-		 */
-		if (folio_maybe_mapped_shared(folio)) {
-			if (++shared > max_ptes_shared) {
-				result = SCAN_EXCEED_SHARED_PTE;
-				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
-						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
-				goto out_unmap;
-			}
-		}
-
-		__set_bit(i, cc->eligible_ptes);
-		/*
-		 * Record which node the original page is from and save this
-		 * information to cc->node_load[].
-		 * Khugepaged will allocate hugepage from the node has the max
-		 * hit record.
-		 */
-		node = folio_nid(folio);
-		if (collapse_scan_abort(node, cc)) {
-			result = SCAN_SCAN_ABORT;
-			goto out_unmap;
-		}
-		cc->node_load[node]++;
-		if (!folio_test_lru(folio)) {
-			result = SCAN_PAGE_LRU;
-			goto out_unmap;
-		}
-		if (folio_test_locked(folio)) {
-			result = SCAN_PAGE_LOCK;
-			goto out_unmap;
-		}
-
-		/*
-		 * Check if the page has any GUP (or other external) pins.
-		 *
-		 * Here the check is racy, but such case is ephemeral and
-		 * we could always retry collapse later. Anyway the same
-		 * check will be done again later the risk seems low.
-		 */
-		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
-			result = SCAN_PAGE_COUNT;
-			goto out_unmap;
-		}
-
-		if (cc->policy.require_referenced &&
-		    folio_pte_referenced(folio, vma, addr, pteval))
-			referenced++;
-	}
-	if (cc->policy.require_referenced &&
-		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
-		result = SCAN_LACK_REFERENCED_PAGE;
-	} else {
-		result = SCAN_SUCCEED;
-	}
-out_unmap:
-	pte_unmap_unlock(pte, ptl);
-	if (result == SCAN_SUCCEED) {
-		/* collapse_huge_page() expects the lock to be dropped before calling */
-		mmap_read_unlock(mm);
-		result = mthp_collapse(mm, start_addr, referenced,
-				       unmapped, cc, enabled_orders);
-		/* mmap_lock was released above, set lock_dropped */
-		*lock_dropped = true;
-	}
-out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-				     none_or_zero, result, unmapped);
-	return result;
-}
-
 static void collect_mm_slot(struct mm_slot *slot)
 {
 	struct mm_struct *mm = slot->mm;
-- 
2.54.0


