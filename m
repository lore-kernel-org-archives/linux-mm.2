Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F44F3D5E1
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6A606B00E2; Sun,  5 Apr 2026 08:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41596B00E4; Sun,  5 Apr 2026 08:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F456B00E5; Sun,  5 Apr 2026 08:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8960E6B00E2
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:04 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AC83160811
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:04 +0000 (UTC)
X-FDA: 84624504888.13.386C1BD
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7A03A14000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ut+4Vm3g;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393882; a=rsa-sha256;
	cv=none;
	b=NUW7KX25dCIsiNTwNv8IURBACgaFAmfu3glRdy3jXwCAEAiQhcna14Xext6WfPRNFn8Rym
	TlcuCCEEAbyfGim2+yxrhCJBH6/5RXvMHuL6hjwBjqfhhUrZ6muN/A6oG7DgK73r5eorZS
	KJT+h2SkMA2aBOOKHnHnm8KS/eHGU4Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MUKNSIiZkKh812RF4RmJVKT9tRU/GLdSthiF4gOWCSk=;
	b=rQvpmoNSuG4sG+RdaCWKdFRv1BDnC031YVqJxRx7Q/+BbvMZAq06Tp/6owYlpiSMPbZCJp
	z6Wd8lvKM4ceihYGOCVCeaasrLhhL81+AfUUgcwA5p6cjK0Qb/bKbo9RV8/Lp+3n6oKohN
	10/YHQJG5dkwJgmvFODABxX8L59orjM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ut+4Vm3g;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so2876482a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393881; x=1775998681; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MUKNSIiZkKh812RF4RmJVKT9tRU/GLdSthiF4gOWCSk=;
        b=Ut+4Vm3gab8k3AUu1PAQS8xoj2tyFt4qkYEihwVv6S3LKjRAlc1AvdiDIBExl1eRe0
         LyW+BTZxUIm4Y1ihngMbYZwYgS0n2XecPP+F8y9iEdsO4IoStxe5yi3f9b/V3i4ghVRI
         OGjvU4GmOyGot3qquo+h5bqCag826Ml2sIHRWYLmQuQt3f4XdytGPb0qp1awb5iwAFcB
         xUZtj3jnXZeBpO6LUNGDPMddZaPJaEPqE1aNFMie4ChIDV9ar23IcMEwYGAc3hJZ0sq1
         AtDDKcmW6PBx5g+Fy9o45m3S1bjsVEERnSAJ9QFr1ppBkt1YlrixlAAnfajwUEiQbpmM
         zVSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393881; x=1775998681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MUKNSIiZkKh812RF4RmJVKT9tRU/GLdSthiF4gOWCSk=;
        b=XpQ1TJFEstrZQZQKIIa5YZfZwCgjRzZKlaOBVOqfsQpzNNfnIuqbeoMzLyAr2t7BEs
         DJ8Kyo1Sr+E9oIhjBo3kjar41sERvfHgd57Pp97snEndH1nMasOx3Jnm03o0uVW1a4B6
         0tdSp9T5+ZXGPUgVu5XoXplrCNHneswPybUkOLy7vIlLhu30ASKPIe3RvxldxYd5Rx9N
         FQ8Vjq4B7yobL/p1/2AFL1Mvdx+nl6hpO4PDHyRipatTrVootUZBtYp18TiCmKRZNp1o
         a/xNW6IjzwtHglzabW9ZPzfjF7B1/auaUYFnkrOwXkxQlb/D1wfL6LodB5bm2jxbzEbu
         aH3w==
X-Forwarded-Encrypted: i=1; AJvYcCVKye3CrvvuwNMXLim3bCOV0x7xtaF+4JGKrp1NPTOXV4LkgEHTjTM99D0TFGqXABYLqgeCSurtKA==@kvack.org
X-Gm-Message-State: AOJu0YyB37ciQyjGvtJz3KeuKEI2tIzuAhzH44DgXFJvVbLWDjgAWdPv
	7cBdrYzHUHPDiLlFFFlt6YEpfmrTRpQZuWcmTujSd+d4805VcM35SfXJn4c/AdgOEv8=
X-Gm-Gg: AeBDieue8ABRMPa6TAt9S0C4CNO7CMLweJfGSsfBG5ZvYY+v+7ZhjQsXH/O626d5gJH
	ib6r9ZbjTuSDs5MWS/TQMHZPcitBH37FROXZxXSpmVJCer0sWACTbCglNaOAXvDTMRuxCkssHDc
	iDhQ4yf1ZAUQrlhMFCj+WaqWLtW1NZNh78lnhxqXoJZFzgMMhLPULXlyOp4FrxwkuU+KqE6z8TN
	WXo5reoNjZqb313FW3c9J2SNJdGDSN3F3k+f9DrkrMZNPuyBcg9UcUd49+/d5pIwGXFonnX+2S9
	wd1Aa3wk+PVFaAxr1MQIQ9b5p1be4GXZ1CDGILu+PwXZAkIYPQyMRPgo3pwOHp/GrQOagPPybku
	b97SbYupVMRorjoJ6zRUn37Cxr7yM3dot6OkNE0/wJIpcsodnu6bSn+0xcC/YvrUeGNnJt0yo78
	IC/7jUVl/jKUnOIfr1kArezU99FDEVKBmjiJzF/5Z9UZJEHeV470w+pg==
X-Received: by 2002:a17:90b:268a:b0:35b:8d89:7199 with SMTP id 98e67ed59e1d1-35de68ec6eemr8635210a91.15.1775393881284;
        Sun, 05 Apr 2026 05:58:01 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:00 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 41/49] mm/sparse: simplify section_vmemmap_pages()
Date: Sun,  5 Apr 2026 20:52:32 +0800
Message-Id: <20260405125240.2558577-42-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7A03A14000A
X-Stat-Signature: 4yjt8onadmoon6knxpnj39yiryegkx54
X-HE-Tag: 1775393882-741521
X-HE-Meta: U2FsdGVkX1/wJaM63XfKCTt56sHUYxZfR5Tixju5N5skwgdsT0oeLnkXXyxqiwpNTuMoDuxOlmoBVgR01+8qfq9GBTr/CgQPN4MhEb0H3RNQwMM6xLiMfLP/Q93PAFxNoRaSVbCWw97IwWTHJWcwqmrwCMbBygaa1l/T4WdpeRbvj/LP/UTTYWFR3hUUfzH5YKlsq4DOwETFYNPkKJOWTe7zElNix9rs/ZByuvJMqTQquY79FICP6LuPdn4iuBwyk5Fvhqlb5DUpLbDj3zQLY+zQZI2fGm/fyiT+7CEYLZYzFzoMowWSwn9pliQennU1zv2cUAAkbB0ViamcrIyR1NaN0QKI3AbicCZWKxhrJH46MDWg5c/9tR2WNQXPbyZmdivR0tjFPXyqRHvT/NDoIVA1pWJHZ72t38PUhTkz2Lu6Vvg76cxCZEnDLNa6uj8mAwZUkwev7h6cUhCue5hK05iv/fUXqWq7KPw4S5FgLwsjucrOU7v0TnEPY5ySgQUIka/TSYPyNAN7Tn/dksz0HB9VBCakMsV/5uABlDGHS63ufwt/5XgHLIyieqvpSitL866pmYlknuwIQxOW1/PhIZnnVRv4FUylM3B18rHeLVpwDTf4lAIyDLmFa4IwMXg2l7C0cvBZugxgEb5HMcpWMivTJf43ud1qIrQgmEp6QzKPBkTuLtaV8d7uCietbXz0dpH+h5+7eWeY0L3nDW6ybvPLJiux/alUXS+4EYfFUZ3y/KLnt1knafZHSqsFWICGNZimgHmhhYXgEUZnJdoS+9YBVxYpdyuM6lj4R5z1cpQe5a/zAbN5gbc6y4PFHqKSjPwZ7/aNURrjo6Fey8YiS68DWRsOnO/+FyCMyIbonvHcSiNi5jdzCUvV7xEIhPT6sr2AlNZra1X/a/ZOyPXI0kGX8wZHoBINWJO5hMxZ/SBEmfG/dluIdZ7idphGOdyvXV4Tt8EDXspk+GI6oqq
 C7oqPEpZ
 8AOyZxwJae2TVO/tU0dB9FXkbJGU43ZnPJz0ebGbXb0dTgWpUggnhJlmV3O9Poo1JJNmzlyy5+Vb/g/etKF2DRIosqbcGBdiw9o7ll8GKj5BRUG2xz3gFcyiFF9sFsO0dZj/WnwjRB6jf7QI8OuMbCriAmxMzeJJcpom6BwHNEjUAMD4veOfAdnkm32tQLRgu2HuazD/34gRqm8nY4s6IHMpkRQsKc5KawLUlTuMfd1svy0p7yxa+Po/VTTvycHr3WJ0WYuEWpbXBbmo18T0EOitPzIIlYEmGIRbvPWbNRotTeNalELNmnYoH2uvdnEpQECc2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After unifying DAX and HugeTLB vmemmap optimizations, we can now
simplify section_vmemmap_pages().

Previously, section_vmemmap_pages() needed to take altmap and pgmap
arguments to determine if vmemmap optimization was enabled. However,
sparse_add_section() already sets the section order using
section_set_order(ms, pgmap->vmemmap_shift) if vmemmap_can_optimize()
is true and the size is aligned to PAGES_PER_SECTION.

As a result, section_vmemmap_optimizable(ms) is sufficient to determine
if the section can be optimized, and section_order(ms) can directly
provide the order, making the altmap and pgmap arguments redundant.

Remove the unused altmap and pgmap arguments from
section_vmemmap_pages().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/internal.h       |  3 +--
 mm/sparse-vmemmap.c |  8 +++-----
 mm/sparse.c         | 18 ++++++------------
 3 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index b569d8309f4d..7f0731e5c84f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -998,8 +998,7 @@ static inline void __section_mark_present(struct mem_section *ms,
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }
 
-int section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-			  struct vmem_altmap *altmap, struct dev_pagemap *pgmap);
+int section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages);
 #else
 static inline void memblocks_present(void) {}
 static inline void sparse_init(void) {}
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index ba8c0c64f160..ac2efba9ef92 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -608,12 +608,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * section_activate() and pfn_valid() .
 	 */
 	if (!section_is_early) {
-		memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages, altmap,
-							pgmap));
+		memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages));
 		depopulate_section_memmap(pfn, nr_pages, altmap);
 	} else if (memmap) {
-		memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages, altmap,
-							pgmap));
+		memmap_pages_add(-section_vmemmap_pages(pfn, nr_pages));
 		free_map_bootmem(memmap);
 	}
 
@@ -658,7 +656,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		return pfn_to_page(pfn);
 
 	memmap = populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
-	memmap_pages_add(section_vmemmap_pages(pfn, nr_pages, altmap, pgmap));
+	memmap_pages_add(section_vmemmap_pages(pfn, nr_pages));
 	if (!memmap) {
 		section_deactivate(pfn, nr_pages, altmap, pgmap);
 		return ERR_PTR(-ENOMEM);
diff --git a/mm/sparse.c b/mm/sparse.c
index 04c641b97325..163bb17bba96 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -345,28 +345,23 @@ static void __init sparse_usage_fini(void)
 	sparse_usagebuf = sparse_usagebuf_end = NULL;
 }
 
-int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
-				    struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
+int __meminit section_vmemmap_pages(unsigned long pfn, unsigned long nr_pages)
 {
 	const struct mem_section *ms = __pfn_to_section(pfn);
-	unsigned int order = pgmap ? pgmap->vmemmap_shift : section_order(ms);
+	unsigned int order = section_order(ms);
 	unsigned long pages_per_compound = 1L << order;
-	unsigned int vmemmap_pages = OPTIMIZED_FOLIO_VMEMMAP_PAGES;
-
-	if (vmemmap_can_optimize(altmap, pgmap))
-		vmemmap_pages = VMEMMAP_RESERVE_NR;
 
 	VM_BUG_ON(!IS_ALIGNED(pfn | nr_pages, min(pages_per_compound, PAGES_PER_SECTION)));
 	VM_BUG_ON(pfn_to_section_nr(pfn) != pfn_to_section_nr(pfn + nr_pages - 1));
 
-	if (!vmemmap_can_optimize(altmap, pgmap) && !section_vmemmap_optimizable(ms))
+	if (!section_vmemmap_optimizable(ms))
 		return DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE);
 
 	if (order < PFN_SECTION_SHIFT)
-		return vmemmap_pages * nr_pages / pages_per_compound;
+		return OPTIMIZED_FOLIO_VMEMMAP_PAGES * nr_pages / pages_per_compound;
 
 	if (IS_ALIGNED(pfn, pages_per_compound))
-		return vmemmap_pages;
+		return OPTIMIZED_FOLIO_VMEMMAP_PAGES;
 
 	return 0;
 }
@@ -396,8 +391,7 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 						nid, NULL, NULL);
 		if (!map)
 			panic("Populate section (%ld) on node[%d] failed\n", pnum, nid);
-		memmap_boot_pages_add(section_vmemmap_pages(pfn, PAGES_PER_SECTION,
-							    NULL, NULL));
+		memmap_boot_pages_add(section_vmemmap_pages(pfn, PAGES_PER_SECTION));
 		sparse_init_early_section(nid, map, pnum, 0);
 	}
 	sparse_usage_fini();
-- 
2.20.1


