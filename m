Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AD3CCD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03046B00D4; Tue,  2 Jun 2026 06:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65186B00D5; Tue,  2 Jun 2026 06:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955336B00D7; Tue,  2 Jun 2026 06:12:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8034C6B00D4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:12:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46CD8C2AD4
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:19 +0000 (UTC)
X-FDA: 84834557598.06.F46EB84
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77A8CA000E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:12:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X+XgbQ5Y;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJaZoYtZ6J61gHq76uPvOqmXDVgTt0Xo6SthcejktT8=;
	b=5kog4HNZ51x72ecKlmVMIY2hmRKncY1vo0wCNDX8ljAoFo83XzMkOBgqfdVfxc7JGnyrzh
	hRnbi9kY8E8oWSwRf5WuzH/n5NkkjmNpUnfaB7zfxovoL9wSuYGVjpBCvskxs1hY/aEK0x
	HuaAhYZh3p7GI1eLpEciOMyUxCwnu4Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=X+XgbQ5Y;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395137;
	b=UeA8NUTGWyUVYU4uU9bkH+HAkiq2a8QijAjVNKmqgdts9fP3e53hKFZFDeS7YM033nTMLK
	F9EzyTyC+kHvaX89XsoSm0QfJWR9RV23uYTRrHC36LO1gYQbr67nCnRNhi/1eKxJwpG+T2
	q/NCVRK6FFzu9IYDBiKgseU3T6I38TE=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8423f626a65so895556b3a.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1780395136; x=1780999936; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oJaZoYtZ6J61gHq76uPvOqmXDVgTt0Xo6SthcejktT8=;
        b=X+XgbQ5YfFoeBg5ZexExFgbQSKebvGlhnIbN69MSCqy6HqsfGEQLiCyxMSSz2xFRNh
         EkEFCRSi7fuWm/R19ExUnoAf3R1IwOk/tqdjLVjWOOuZoq1nJsg4YZdd5jwb2PbWWObH
         SHRA/sTiy6TBQi61jQBh9f01eqhqIu8ois+jpEHrncfxsYcQKK5NUM54w97H8i+l3+9h
         /fLqbB0E4znCq5O6ym5hdf5BarISIWEun7wd5NAvWZfJOHdZUE7kWE+PgwtDeGcBkzbp
         bfVXKHsmwDDi6pjBaaU/ucpwxwOuaI4XllFTylhjQ16l/SYZvqnIzKJNXpcOrNDSlRQ2
         Qb9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395136; x=1780999936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oJaZoYtZ6J61gHq76uPvOqmXDVgTt0Xo6SthcejktT8=;
        b=Lu9djnRDEss76SJnCEYj7bfIrBkXl9NgPbCeOaUxaAYYb5vL4tzFUa8+6Ce0w5WFQH
         KPMbvsF6pl6vsZP/8WZ2tYTPnjLaMWlJ4HUiWAlP9KmR6ngNHfissawD7zqhdMTZSNfj
         BL6z2sa3J1QfWA78niIjOV3oQxBhgcHR9mwpx7194qgGoj0bh4lFJ7fjKDCM0gljAyjV
         +rLm2xvQsCONK7i2guJKy6ES+ZNxJJcOYtHNBMCx6ZqP9d5TwMEe2cSsSXhbVx2U+O0y
         zIiYyqonHQrtiTEFjmJJaffkh+pevfIZEsSBFmtFYBPwG3w6RZqnYCQBhaNlq0NetfsY
         rKIQ==
X-Forwarded-Encrypted: i=1; AFNElJ/YYP6vptHsp6kOAjVxkfb7ZX7fhJXPtBb4R3/b9wXiROeUhGPO1mvl3WB79reO9phfwUyuc3WdLQ==@kvack.org
X-Gm-Message-State: AOJu0YxYcJUs6LFBqqQ84T+PV6XVAfjpnzqI5LcZoVOrsUgazejbHh8+
	qmldxNKuwg1JoS1QhVZpBGHZW3RwU5H7qBHEbtdUcVI9ujeVdfR5XcHtUZ53fCZAilM=
X-Gm-Gg: Acq92OEr4UfblA2DM05eERYzMAHHas/DI6Tvu8jXvykqXJbteRkZiepqMQnL1ylpDUK
	ChfK8OkrMTsalFRl843CP1SxzGqq4kHHyj9twjXO3KpCiNQkLY4uFL4jbCxCu+vLOShBgDXAZNW
	uCnGYVYMQ81OCfOPpaMWgj30dx+996Z/z/fOJmq1w0uEFK0WtjzXs2UCg9biAreI7igx6qi+39U
	RZe6UI+miK7kTw4Os1suhr84p6QWyu74Zz61xJWZHgBUpkDr/nlK+m+zXuXq9YmBF4dZ05zWW9I
	NxoxjNW74EO7lhvdarCTiby8ye+Qmp4RjEM126Mu7H0N7NDEjZM/XB1Ns+5ae/DEEamiRnZvd3n
	jpDcUZwrRsenQthOlnY3d6L45++7RvdbxZlmrPFyJMSbwCEIR+silaYbg53UAq0YPshyfzRl53n
	tMAJZ6pGbC7d8ZFs1HQibMpi7tGsg1/85lrkT9JwNXl6B5NpXLHOJWI04=
X-Received: by 2002:a05:6a00:b806:b0:842:655d:1232 with SMTP id d2e1a72fcca58-842655d14a9mr4627780b3a.0.1780395136206;
        Tue, 02 Jun 2026 03:12:16 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm12015507b3a.60.2026.06.02.03.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:12:15 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 15/19] mm/hugetlb_vmemmap: Move bootmem HVO setup to early init
Date: Tue,  2 Jun 2026 18:10:35 +0800
Message-ID: <20260602101039.1867613-16-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260602101039.1867613-1-songmuchun@bytedance.com>
References: <20260602101039.1867613-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 77A8CA000E
X-Stat-Signature: tqmgyfez3uoptnfwsirp7ect1b3gegks
X-Rspam-User: 
X-HE-Tag: 1780395137-174407
X-HE-Meta: U2FsdGVkX19OlMAqnnKMYaavyDazAer3vGOurUDcbWSLb2TYUm0s2TxpxFentWAqFDpzHCY85Q3i70Lk4D+8PflwartIzq0OIuPhyk8Qn9/H4QBs2R37nX18asz/Ex8ehg8QTTGHZH1Yp05mf8WEV4c9W6jDUVc7zEfwFMRo0TPwZazXhblem4X/ABAucE7v+Wr+tBNYXjTs7s9bT5ETTnBQ32klOyIYHol7QSfJE3hi3jFqptsdbakGY5m+Poc2LItC0N5i7kB9tPk5hva5yZVqbu9NPThTM1CksvcwUDN38RiiVG/3xPmxPyvwjGeFn751T+C7cR2qfBbLjL3J5FZXujmjO+q9VLfaVK53dwxlDIH0LbhWLRHHNR8/CDA2rOI+56VfdIVm6X5Wr6+pzoMVZlZoFaSwb+yZJccPLX1jwoEEppmSQh7by8cvwUVhqbC9TdOfNnGOqb7qdyF4ijZZW6+kciArLPK4/VOqZ07RywaiiV2CEXb1lo6KApj6DaMe4IYcmxPoa17vBSdeiP9zkPv/uRm0J6YbRdHj9o7sEYwdiQc9wrRhmGevBNPK9ZkLRTMkRkFHEKwNWUBEqfwqlJA7PsijJYpYgGAiXZkl501rJmbcHkPCk/lKJPNjCweugL0lKmEEcGCcl2x6tE/eFYA7xOor7d8QfgzAOOh3u8lI/POw0JfN9ptemWOBz19bSKH9flDkM8Dxwt8g9Ht1HkCBc+qoxD6VfB8/CewzNds/g9fvQ/LWyqDmumSxpcqJdwZcjFk/sFF9OpFdmpH+eB63gjnnftM/8qCEtnLFuftEnkQMiLhZjJMY0SRQtZKEDlsn4DOx0TJlN1MgWxyK/3xWfBB0W6DD0nAUivlW4HhwAoJnE/CEaE5GfQlyH0kYkYXyr6cpgd8At1NbTVu5U/qtDxRHrgUDecCua+MsV1R0m6X4oh3pqr3H6rnnb0zhIWY+C6RnApDKMRp
 RKa1frW6
 l9hn12AdeF0xDgLqDUTwtbvZomrzFpOaAO/NNat3ssQZbuZtQhxcQH+Ick3Y0Mtobn6Rg+AMtDj45LkCMW2hLqR5iUql4Sp+w0Pe5bX8K9qOw03XrhTmGkIwm1SQ2Th//qkcPpgY2HK1lUB/OLIAo+GYAoi7BA6RwZqO1wrIzWiCjjmCBeJBjSZe3n5QCdIadYbyed9bPmDjLKfdPrvi3eWm24/zULK+6F+RCvXMYouXJRKVblpqqWSgWMsaJDj9vzpaEA6o9K/+R6Hun51QxXjcVCjUjF8Ujb0qrUF9igMB5MoxyJa8GL9pv0U4OzNULrj+YcuUet0oldCwt3rrMP6y9nyHqL+16/pbHEVk30IY4clqfjZvIYX84Aviti2MKoa9tz4dkLJV5vIfYlfS2wJ93E+IY+bTJtgcYWf7fnGcdrESnQ5jCTZZ2EXz1US/sX1e5X0aJnTL8wBs4fR2UsEWHjnOJHxyBwgHWJPrAOVFA5K8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bootmem HugeTLB pages currently defer HVO setup to
hugetlb_vmemmap_init_late(), because the optimization needs zone
information.

Now that zone initialization is available earlier, the bootmem HVO setup
can be done directly from hugetlb_vmemmap_init_early(). This lets
gigantic HugeTLB pages apply HVO as soon as they are allocated.

Bootmem gigantic pages that span multiple zones are now filtered out
when they are allocated, so the remaining bootmem gigantic pages seen by
later hugetlb initialization are already zone-valid. As a result,
hugetlb_vmemmap_init_late() no longer needs to handle bootmem HVO setup.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 67 +++++++++-----------------------------------
 1 file changed, 13 insertions(+), 54 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index ea6af85bfec1..464578ee246e 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -745,6 +745,8 @@ static bool vmemmap_should_optimize_bootmem_page(struct huge_bootmem_page *m)
 	return true;
 }
 
+static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn);
+
 /*
  * Initialize memmap section for a gigantic page, HVO-style.
  */
@@ -752,6 +754,7 @@ void __init hugetlb_vmemmap_init_early(int nid)
 {
 	unsigned long psize, paddr, section_size;
 	unsigned long ns, i, pnum, pfn, nr_pages;
+	unsigned long start, end;
 	struct huge_bootmem_page *m = NULL;
 	void *map;
 
@@ -761,6 +764,8 @@ void __init hugetlb_vmemmap_init_early(int nid)
 	section_size = (1UL << PA_SECTION_SHIFT);
 
 	list_for_each_entry(m, &huge_boot_pages[nid], list) {
+		struct zone *zone;
+
 		if (!vmemmap_should_optimize_bootmem_page(m))
 			continue;
 
@@ -769,6 +774,14 @@ void __init hugetlb_vmemmap_init_early(int nid)
 		paddr = virt_to_phys(m);
 		pfn = PHYS_PFN(paddr);
 		map = pfn_to_page(pfn);
+		start = (unsigned long)map;
+		end = start + hugetlb_vmemmap_size(m->hstate);
+		zone = pfn_to_zone(nid, pfn);
+
+		if (vmemmap_populate_hvo(start, end, huge_page_order(m->hstate),
+					 zone, HUGETLB_VMEMMAP_RESERVE_SIZE))
+			panic("Failed to allocate memmap for HugeTLB page\n");
+		memmap_boot_pages_add(DIV_ROUND_UP(HUGETLB_VMEMMAP_RESERVE_SIZE, PAGE_SIZE));
 
 		pnum = pfn_to_section_nr(pfn);
 		ns = psize / section_size;
@@ -800,60 +813,6 @@ static struct zone *pfn_to_zone(unsigned nid, unsigned long pfn)
 
 void __init hugetlb_vmemmap_init_late(int nid)
 {
-	struct huge_bootmem_page *m, *tm;
-	unsigned long phys, nr_pages, start, end;
-	unsigned long pfn, nr_mmap;
-	struct zone *zone = NULL;
-	struct hstate *h;
-	void *map;
-
-	if (!READ_ONCE(vmemmap_optimize_enabled))
-		return;
-
-	list_for_each_entry_safe(m, tm, &huge_boot_pages[nid], list) {
-		if (!(m->flags & HUGE_BOOTMEM_HVO))
-			continue;
-
-		phys = virt_to_phys(m);
-		h = m->hstate;
-		pfn = PHYS_PFN(phys);
-		nr_pages = pages_per_huge_page(h);
-		map = pfn_to_page(pfn);
-		start = (unsigned long)map;
-		end = start + nr_pages * sizeof(struct page);
-
-		if (!hugetlb_bootmem_page_zones_valid(nid, m)) {
-			/*
-			 * Oops, the hugetlb page spans multiple zones.
-			 * Remove it from the list, and populate it normally.
-			 */
-			list_del(&m->list);
-
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-			memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-
-			memblock_phys_free(phys, huge_page_size(h));
-			continue;
-		}
-
-		if (!zone || !zone_spans_pfn(zone, pfn))
-			zone = pfn_to_zone(nid, pfn);
-		if (WARN_ON_ONCE(!zone))
-			continue;
-
-		if (vmemmap_populate_hvo(start, end, huge_page_order(h), zone,
-					 HUGETLB_VMEMMAP_RESERVE_SIZE) < 0) {
-			/* Fallback if HVO population fails */
-			vmemmap_populate(start, end, nid, NULL);
-			nr_mmap = end - start;
-		} else {
-			m->flags |= HUGE_BOOTMEM_ZONES_VALID;
-			nr_mmap = HUGETLB_VMEMMAP_RESERVE_SIZE;
-		}
-
-		memmap_boot_pages_add(DIV_ROUND_UP(nr_mmap, PAGE_SIZE));
-	}
 }
 #endif
 
-- 
2.54.0


