Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5920CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B79B8E0021; Mon,  1 Sep 2025 04:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 440CE8E001E; Mon,  1 Sep 2025 04:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30A988E0021; Mon,  1 Sep 2025 04:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 157498E001E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:34:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1F08160711
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:44 +0000 (UTC)
X-FDA: 83840020488.26.AD4EDD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1C84916000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:34:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3FYys+6;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756715683; a=rsa-sha256;
	cv=none;
	b=miQ0u7V0wswZLlXQ2vduTBKMtiKHjyd9vjT7fnuxJxU/NATGMDq0VGkTWCG8uRZ+EtvX4F
	M6+ZPClXBicQSE39iW02H7wks+pfunCKMIjYIz6qvS37DcsTcIX47XRoCNmFnXsW6JOeH9
	mbij78Qc0H0wikJlRKscGsNaqZ0Q1Tc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3FYys+6;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756715683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LxqjbtoFs7hKCwNoiBDCjRFrBvhwkGwXdNtKF8gSi4k=;
	b=F0+x0yAFSg7QxlxjvtdFv0giJ1th8eTlSMcXwEVGVKvidZoXKSFeTRJCtxO9oxT0N7LUWK
	TbwlEYikPjbuEvPms8nZPyvM248jiMJ7HCi0nrG3pEgLU3i/Mc+od+h55dIdelQpRXVQOt
	gRWYz0cGFXnNfvn+Oc3N4EnfwQIdOwk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F4AB601D5;
	Mon,  1 Sep 2025 08:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A5BC4CEF0;
	Mon,  1 Sep 2025 08:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756715682;
	bh=tijAz1eNA4UUi3u0ThL/Z8I1a2cgIFLE3T1W4G+WSyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3FYys+6jyvfehPZwHKVP9GBRngDIMaxwrEHCeOB1+TGU7YqF51o0r0e0KBBOGgfQ
	 JVrUiwNutdKf9IQk3s/4DfVAbPerLVWa+aqDcguiQV/yxliTGj53ownmsEPk0YNT1Z
	 v7tkPG1pCNXAmcsRQBQRU+CD5rxRicwuudydwlaLykfYa4DDPihjPXVfy8wRY/Y4Wr
	 kOc909JfqH1g0uLfCcWkkcQzCPfl81v/EJwnV9uSxQADi6pnKhmiz/hrnoz1/EClnl
	 N1hZdjPzmqLVjAqIGJspdjjCWzkE0IIadd+sEXE+ILmdDlQLUHox5z6N85D4ORf2Eu
	 fI+TeLKW52OzQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Wei Yang <richard.weiyang@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v2 3/4] mm/mm_init: drop deferred_init_maxorder()
Date: Mon,  1 Sep 2025 11:34:22 +0300
Message-ID: <20250901083423.3061349-4-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250901083423.3061349-1-rppt@kernel.org>
References: <20250901083423.3061349-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1C84916000F
X-Stat-Signature: bi9qwzc76ju8hc9xpn8rccr3xrhgp1b5
X-Rspam-User: 
X-HE-Tag: 1756715682-465171
X-HE-Meta: U2FsdGVkX1+nQeKV+K0LHK2yl36VtB73iZvb2M+gd+nHTLuCl7sLhJwWuo968lWs3bsJKlC4arg7ffq9DPCvQzg9Es5T7luso8r3K3kVATSrIm6lqWnmrL9Z5l5wAa4pxHIXOj5jApoxw38UyJ4nbtUuAibXfh1Hi4IzR4z91vDyyQY71KOLaoPx+w8jCOBTXVAkEfyNlBDicHcpbZ7MeI4lWXvAU135Ydnat1JJUIRFYWBGfnVmnmVwWIQOvrOT1+16XWIzJGZhUL6fIR8UN6Q+ep4ZFugYM3f0dvRD0jyr057azoufoBMvwYODTKjjtBidYQQ+oK3IrU2MrwYhMzuYtAnRLFFS02Ys8NIDl2XQm5KHWkdjtDxJqscGqAWv96tZPLUlpnh4FRqXCoOrvCsyfH1ltRo62Dstg90RPXEAoITYwK72PLR8Kvoijf2ZW6PcRXvfJVK/hGYL7tPKwpvXIcwbeKLAKnivCpIvG9J7fG+yNV8P7cz2fWEbsBRDl0NVWU0IPlDMfHASWvOPS5lQBM2snhaJaKW6cCpol9nSuAkzcYxKdc3fiqcvZ7DQhAFv2Ww0n673dNbqQ8iUf2lL9b8slXvHmBtE/zrEOSmZkeStXCmP0LHPM8M3RYWZ1O95QeHaiPByXIusGsJyys4OVr84cQzDNXjemEwX7YisnYEIeU0zdvbCBCA4oyYLzIbzJSo4Oxx5d078Ve+iwJFXj6bxIBDpmROA4pm7ojrILP9KCfS9bzAfOjkP4aIJiM5m23pvBJVN+Oh44fMScFa7/K/3aBJ2CuFTGxJRaJHCscqFDDTo4SjZpVYbp44yaaRHHJ+duWwSg/ZruQtJYAUQTd5MZmksrpZzTONV1L290PqyOft1Rye3p4HZOUWE1gIp9dfPmZ6BeNVFKdUUuhFYKQMSA2QVm7P/Quws/FS5OLkxSs7lTpFAe2r29sHHf3PQjSrSRs9MYOagE44
 otQHV+E7
 9y3OP/KovGqlm/UNBabAwU5aSGKnTAGczRlhpTl85cb7Kjwiv8FzWfc2KvaeOCDqiwkXMAjHYhpcxsPTPTQs4rcbi61Jw3AFx5pqbHx1Se7h4juixrGbIdhGhowF3e4uel98WAC/uFaS8nFdy+MXiPCUt8egmAE3/S8SZjEJQtsu6uHdWQ6AOZ99/3yAER1AohGoH3Fr0/zJs13b3CLfwxH+bsbYbFXuLcJwFgUX4hf7KqRo8BUcgwDfAj+cd9F/WKW6IsSkhe0seP1QftAyU8fufQYSyByRen/1JNGEUXcXvU+idKEkXSvc8AbzmsK8xMNY/ydfMMW7T4vI+d1eJ/kCeANoxuXZmYpU8tSQIm6lqWDsNUvF4DbdAe2BFl6I/vSoDa4sjyXWmbYexMrH1V6XtuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

deferred_init_memmap_chunk() calls deferred_init_maxorder() to initialize
struct pages in MAX_ORDER_NR_PAGES because according to commit 0e56acae4b4d
("mm: initialize MAX_ORDER_NR_PAGES at a time instead of doing larger
sections") this provides better cache locality than initializing the memory
map in larger sections.

The looping through free memory ranges is quite cumbersome in the current
implementation as it is divided between deferred_init_memmap_chunk() and
deferred_init_maxorder(). Besides, the latter has two loops, one that
initializes struct pages and another one that frees them.

There is no need in two loops because it is safe to free pages in groups
smaller than MAX_ORDER_NR_PAGES. Even if lookup for a buddy page will
access a struct page ahead of the pages being initialized, that page is
guaranteed to be initialized either by memmap_init_reserved_pages() or by
init_unavailable_range().

Simplify the code by moving initialization and freeing of the pages into
deferred_init_memmap_chunk() and dropping deferred_init_maxorder().

Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Link: https://lore.kernel.org/r/20250818064615.505641-4-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 127 +++++++++++++--------------------------------------
 1 file changed, 32 insertions(+), 95 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 57b256ea9e6c..7e5e6984bb5d 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2046,114 +2046,51 @@ static unsigned long __init deferred_init_pages(struct zone *zone,
 }
 
 /*
- * This function is meant to pre-load the iterator for the zone init from
- * a given point.
- * Specifically it walks through the ranges starting with initial index
- * passed to it until we are caught up to the first_init_pfn value and
- * exits there. If we never encounter the value we return false indicating
- * there are no valid ranges left.
- */
-static bool __init
-deferred_init_mem_pfn_range_in_zone(u64 *i, struct zone *zone,
-				    unsigned long *spfn, unsigned long *epfn,
-				    unsigned long first_init_pfn)
-{
-	u64 j = *i;
-
-	if (j == 0)
-		__next_mem_pfn_range_in_zone(&j, zone, spfn, epfn);
-
-	/*
-	 * Start out by walking through the ranges in this zone that have
-	 * already been initialized. We don't need to do anything with them
-	 * so we just need to flush them out of the system.
-	 */
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, spfn, epfn) {
-		if (*epfn <= first_init_pfn)
-			continue;
-		if (*spfn < first_init_pfn)
-			*spfn = first_init_pfn;
-		*i = j;
-		return true;
-	}
-
-	return false;
-}
-
-/*
- * Initialize and free pages. We do it in two loops: first we initialize
- * struct page, then free to buddy allocator, because while we are
- * freeing pages we can access pages that are ahead (computing buddy
- * page in __free_one_page()).
+ * Initialize and free pages.
+ *
+ * At this point reserved pages and struct pages that correspond to holes in
+ * memblock.memory are already intialized so every free range has a valid
+ * memory map around it.
+ * This ensures that access of pages that are ahead of the range being
+ * initialized (computing buddy page in __free_one_page()) always reads a valid
+ * struct page.
  *
- * In order to try and keep some memory in the cache we have the loop
- * broken along max page order boundaries. This way we will not cause
- * any issues with the buddy page computation.
+ * In order to try and improve CPU cache locality we have the loop broken along
+ * max page order boundaries.
  */
 static unsigned long __init
-deferred_init_maxorder(u64 *i, struct zone *zone, unsigned long *start_pfn,
-		       unsigned long *end_pfn)
+deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
+			   struct zone *zone)
 {
-	unsigned long mo_pfn = ALIGN(*start_pfn + 1, MAX_ORDER_NR_PAGES);
-	unsigned long spfn = *start_pfn, epfn = *end_pfn;
+	int nid = zone_to_nid(zone);
 	unsigned long nr_pages = 0;
-	u64 j = *i;
-
-	/* First we loop through and initialize the page values */
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, start_pfn, end_pfn) {
-		unsigned long t;
-
-		if (mo_pfn <= *start_pfn)
-			break;
-
-		t = min(mo_pfn, *end_pfn);
-		nr_pages += deferred_init_pages(zone, *start_pfn, t);
-
-		if (mo_pfn < *end_pfn) {
-			*start_pfn = mo_pfn;
-			break;
-		}
-	}
-
-	/* Reset values and now loop through freeing pages as needed */
-	swap(j, *i);
+	phys_addr_t start, end;
+	u64 i = 0;
 
-	for_each_free_mem_pfn_range_in_zone_from(j, zone, &spfn, &epfn) {
-		unsigned long t;
+	for_each_free_mem_range(i, nid, 0, &start, &end, NULL) {
+		unsigned long spfn = PFN_UP(start);
+		unsigned long epfn = PFN_DOWN(end);
 
-		if (mo_pfn <= spfn)
+		if (spfn >= end_pfn)
 			break;
 
-		t = min(mo_pfn, epfn);
-		deferred_free_pages(spfn, t - spfn);
+		spfn = max(spfn, start_pfn);
+		epfn = min(epfn, end_pfn);
 
-		if (mo_pfn <= epfn)
-			break;
-	}
+		while (spfn < epfn) {
+			unsigned long mo_pfn = ALIGN(spfn + 1, MAX_ORDER_NR_PAGES);
+			unsigned long chunk_end = min(mo_pfn, epfn);
 
-	return nr_pages;
-}
-
-static unsigned long __init
-deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
-			   struct zone *zone)
-{
-	unsigned long nr_pages = 0;
-	unsigned long spfn, epfn;
-	u64 i = 0;
+			nr_pages += deferred_init_pages(zone, spfn, chunk_end);
+			deferred_free_pages(spfn, chunk_end - spfn);
 
-	deferred_init_mem_pfn_range_in_zone(&i, zone, &spfn, &epfn, start_pfn);
+			spfn = chunk_end;
 
-	/*
-	 * Initialize and free pages in MAX_PAGE_ORDER sized increments so that
-	 * we can avoid introducing any issues with the buddy allocator.
-	 */
-	while (spfn < end_pfn) {
-		nr_pages += deferred_init_maxorder(&i, zone, &spfn, &epfn);
-		if (irqs_disabled())
-			touch_nmi_watchdog();
-		else
-			cond_resched();
+			if (irqs_disabled())
+				touch_nmi_watchdog();
+			else
+				cond_resched();
+		}
 	}
 
 	return nr_pages;
-- 
2.50.1


