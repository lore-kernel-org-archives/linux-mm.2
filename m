Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF152CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 04:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11156B0092; Sun, 18 Oct 2026 00:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AB76B0093; Sun, 18 Oct 2026 00:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B026B0095; Sun, 18 Oct 2026 00:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9345A6B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 00:35:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 17BDDA0411
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:35:15 +0000 (UTC)
X-FDA: 85334482590.18.6426755
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26B2CC0003
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 04:35:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LlfSMJUI;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792298113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UP34xPhDFhtAM+cWwkHeUJ1O9EQe7R6dx6I7BN7Iz7U=;
	b=B7pQ5AJgT4Psnlef0tc/rKYhkRwclkq9Uo4FS8ZvnwMQiU+fdYXcJxdc3K1v8TVeJfxuDr
	huLQoiBOfMSABpCxu170yi87KkkQlstvdLZZxAeK902Su3BvsYndWdrbdNOfrGKFQ//kEU
	Zy0z2/V+6m8dJbaDsGStI5CdX6J7Q2s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792298113;
	b=uu3YEH7Srkk8HO2Uxk+HMK7PKbKs3vZEOlrfXg4KoVVEPdw8ByebQefCTJkOE1ifGiwuCM
	JRgMIaS5r1MGgQDsIWCzeIDKg1MLrckLfLFNHWLLc50JoKcGcL5dc/UjJi26kbnXF4YGiG
	3pLXvv2vMb8RHdpcrJR+ThV5qGt/1AM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LlfSMJUI;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2db80fcdf8bso5721565ad.2
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 21:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792298110; x=1792902910; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UP34xPhDFhtAM+cWwkHeUJ1O9EQe7R6dx6I7BN7Iz7U=;
        b=LlfSMJUIj/SQ8UNAOmSLPL8qIa3Lk2xzQ7BZfkSOKZKKUbRBgjJtAnjbOFzLyP9mXZ
         EIgrv85FuGUzWhbY/35q2flGMDFBrhRmHk1FYLbza4BWUoFe4WNA/ABMVk/X61CVUpVa
         /Jgpb4WTq/YrATPonxaLrUWoXnk08l76wlfpvJwUR3+qVdbbzRarErgjuFyCEtHQiJ4b
         uamC+xCob+ObR84HlAL9fH3NhExDgFZwyJwaAO2r8lQLO6skWk16b7eQjynEbzAEDJ91
         xIJYtRd/FSRJKPLhOXJ4Ek5vjGyAU05MOYsEuJHo8QRhp8s9mpB1S8K1br5vl6/2ZVBP
         K9lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792298110; x=1792902910;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UP34xPhDFhtAM+cWwkHeUJ1O9EQe7R6dx6I7BN7Iz7U=;
        b=ZqaPVeQbS4DIPFOfKrgqBhXlCCQOphOGQC6MsSRzOq/VXnITgbVs6jlNT5ziFpfSMg
         riQmFfNSGTS5vPxSkDQJ44p9KmK2+TDTsWY3yjquExvnOZYAg+elA2IiFz1yghw7Xy5M
         /AUzveO6ORqlBuvSLmgg7iXxrPitCY7LtxjTguiXtiJFgUP8+8U5oqw+RnaVXFIndOH9
         q+aiRpZsPKhXYYd1iWZTKLvDIGmDAzRRyokZIDwhLD2CERNlywX+eABfchIVOaUkJ1kN
         EYdpOVWJcIiiYGzg77QAyWQuN1EsZgWK7Y/5LLDllTVo2KSZLVfgE8NiujNbiqHxsNgd
         gdKQ==
X-Forwarded-Encrypted: i=1; AKwUvBzH24QkoQD+R9D0jucBpsOaa4SSlegkBJGwB01pSNIRCiA2s8Ho0XToFRzHWgCNe2ac3N+QmPAtrA==@kvack.org
X-Gm-Message-State: AFq9FYKUMrGuQSyrB+cK5Hxr/ytERwJSgDyKHY1XxOHLn/DgodS6i9WU
	ReiDKgK6NVT9HjFa1lO7f/URJTH9eH33uHQnZqX98vo4v4ob0PAUbmfPt3+4tXjql20=
X-Gm-Gg: AYBFou1srnG9TlGHP3e6fBQWbVJRktkjdyq8XvSMgHdlZxVkFax5+gS8S265ZwddPX+
	6jVJ8jYg+Z0k2snTlTRzibOxb+b0Ga83rta377ILdw7VVsERdYb5nv6vdcKrX2OoyeBsjI1bo9I
	WUqyr0RhZJ10fMc2+JkR65QUL2GDj7e6inx3G04AE52kAwmkuUbtQ1mrKAOHoyILJMu/Q5yIr9B
	r3ClG/MQyLDaYy3c7KPzFzCZFGHQUuxnaNg6kSw6qN45EMQyTVsd3NKp21ITXvuSKh8hyagl//X
	WHgscbm8TR6GwBwtO3wMXFO5rcTrOuED5BTIPJPVfJvXwaOS+/r//nXaw1F/OiDkN/fsFheHuP+
	G+nGwa/K+JqU5cHXZnHKq8/vq6rCrEKolFEI5GVlft9Ae23Bn5OSB6ew0PFo29XN5sBPkpAZ9IY
	RBYPbLY3+YX2ZA+noW3gTDjmHLiwwOMtymT2HrLpFo0aR+Y4ChnHb1flcgRV+2w8ygVMDxGZ+xJ
	O5+qJP9MgJHVNFvo5rwEeMONt59X7GPceMOQZUoX/jHGt0NHFxXTciTNCKwH2oRk/Q6xJaXWsPH
	zkFqjUKUxgRXqYi/+kG4kVM=
X-Received: by 2002:a17:90b:55cb:b0:3ac:9c37:9431 with SMTP id 98e67ed59e1d1-3aceec251a0mr3458188a91.19.1792298109782;
        Sat, 17 Oct 2026 21:35:09 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc487cccdsm10412082a91.8.2026.10.17.21.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 21:35:09 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Dan Williams <djbw@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH v2] kasan: fix runtime shadow page table synchronization
Date: Sun, 18 Oct 2026 12:35:01 +0800
Message-ID: <20261018043501.3257632-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n9j1etay618cm5r9memgeo45h5t5jy49
X-Rspam-User: 
X-Rspamd-Queue-Id: 26B2CC0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1792298110-809615
X-HE-Meta: U2FsdGVkX1/cpzXp0U8v1U/6BU2fShuIrIMT9K+VvrDAY0n1fnb+C/CejHRmiFOvNBgrYy0YLMRqyDTvzGOIm44VmXqSdYu9hBE0bBj337wH7/+qIKN7rYnafKmqMfnT5LJmQttImov7Kb5XXQ23l+eXRbhmwlCobHJd9VfMJXRP0baF7+9czQMsglKj/zOvVryD/rAD+PS+irZPKWfKmfbSyu6WeTu8E2sUtL9PkpUr7N6cw6IzTo5FtyBy3yJG8Ydkoo4jMubQARMjdKM48JJLAvrdaIcOob+dhACUGRkId4UzkZUt/MSs6KyIHZVfGZDrgITUlgCn6gyT4DjcDfzhehFO2veIC1WYw6AAkpJTrhuSogItOdhJRyu6DkmRxz5EmJ+moTvS5swgCpdw3x2rXa1PoY1pZYspBYB1u6giRa1l+jjPxq9tup4BGOagt2j34aInQhXcs05baxhnrKaJCjWuxGT2p1RUrEjfWLHiInFRpe/wLylgkkFRCFLHLK5BtY8J2TL8wCS6EbtM1uIvvSC5D6Dra/PEGmvYZHscz5gNlWU8Zis8pDsCQZDXcKMekySnmEIIzvxzBFj/02fL7WMTwZcCas8ESqZQJN0cmrVFqVF/IXKHEkyocr1Jh9J0+264TzMkjnxz4C0dP6dZqYK99Ouk8QMUbqsIwsCQG9m5Ef+uMm1/mLjG4OJF4jAjNDu5kQZ9+81oWel1jyKVtkAK24Wmn7A+jmUT8slYF7/8qdNe7UDCbqqZrn9T/o4h2uHd+KhQfVvUlbzg2w2MgE3LvWuus+NbqeSYfsxgrXuawA6vwRcx1DbEjxkltHwhLSblZWgaLJEVXv5se4PyjB8lT9eTXD4uOsDdjov14e9OYLUdY15lZL23P/N5txegycFtk6DgZl867A04CHWDpzv4KB3slxfy+7T/cWfSJW1E8W8eipjmcb16yDaGhdpyl5AfBqYAzzvOVce
 EJTc7eN0
 gagm1fr97G32VwrFNEPAQmdl8R9wgzn7D9EN81PH4aPqxrA9VXqGU5tl9lH83Z9Q1aQIwnQxsCMZ9oGJEaPmrl+VGxG7ydBR5LWcvqt0q6TrWPITps2VUViUbfKXNzjQKV+CyLWbJ2T/5Otsb4AaGykk6vkyAD2pqJEFg1lLlkTMiYFTAkNWgpAct/mjZAR7CbXTj5/4MzfQBo8ilL4E+9+Y1WCQ+dfiupqcA6nYyVN0iUsn4x+CKf5a5uawLqlwCC7LkljSJ911xgp8B3clRSX6iju9jXQiN2BpfJvEhaPYK+egsdkfsLky6X7pGtlfIojh8jsyu26uU/B6wNbzzaz0mUqisqCxA3n0iDpyzjUNCEv1NUbkJI/WUQEkEhFDfIBETMbvPvZsabo+hwXnzfxZlYDJxFy4YS1Ix
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_populate_early_shadow() is also used after slab becomes available
to install shadow mappings for hot-added memory. When this path allocates
a new page table at a level that requires synchronization, the new entry
is initially published only in init_mm.

On architectures that maintain separate kernel page tables, runtime
changes to the kernel page tables must be propagated to existing process
page tables. Otherwise, the KASAN shadow mapping can remain unreachable
and fault when the hot-added memory is accessed.

Use the existing page-table allocation tracking helpers to collect the
modified levels, then synchronize the affected kernel mappings once after
the walk.

Once synchronized, an entry remains in other process page tables. Clearing
only init_mm and freeing its target table during teardown would leave stale
pointers behind. Retain page tables referenced by synchronized entries.

Fixes: 0207df4fa1a8 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Use the existing page-table tracking helpers and synchronize once after
  shadow population (suggested by Andrey Ryabinin)
- Fix aligned shadow population to reuse existing page tables instead of
  replacing them (suggested by Andrey Ryabinin)
---
 mm/kasan/init.c | 125 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 90 insertions(+), 35 deletions(-)

diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 66a883887987..f94f461d864c 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -17,6 +17,7 @@
 
 #include <asm/page.h>
 
+#include "../pgalloc-track.h"
 #include "kasan.h"
 
 /*
@@ -107,7 +108,7 @@ static void __ref zero_pte_populate(pmd_t *pmd, unsigned long addr,
 }
 
 static int __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
-				unsigned long end)
+				unsigned long end, pgtbl_mod_mask *mask)
 {
 	pmd_t *pmd = pmd_offset(pud, addr);
 	unsigned long next;
@@ -115,25 +116,26 @@ static int __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
 	do {
 		next = pmd_addr_end(addr, end);
 
-		if (IS_ALIGNED(addr, PMD_SIZE) && end - addr >= PMD_SIZE) {
+		if (IS_ALIGNED(addr, PMD_SIZE) && end - addr >= PMD_SIZE &&
+		    pmd_none(*pmd)) {
 			pmd_populate_kernel(&init_mm, pmd,
 					lm_alias(kasan_early_shadow_pte));
+			*mask |= PGTBL_PMD_MODIFIED;
 			continue;
 		}
 
 		if (pmd_none(*pmd)) {
-			pte_t *p;
+			if (slab_is_available()) {
+				if (!pte_alloc_kernel_track(pmd, addr, mask))
+					return -ENOMEM;
+			} else {
+				pte_t *p;
 
-			if (slab_is_available())
-				p = pte_alloc_one_kernel(&init_mm);
-			else {
 				p = early_alloc(PAGE_SIZE, NUMA_NO_NODE);
 				kernel_pte_init(p);
+				pmd_populate_kernel(&init_mm, pmd, p);
+				*mask |= PGTBL_PMD_MODIFIED;
 			}
-			if (!p)
-				return -ENOMEM;
-
-			pmd_populate_kernel(&init_mm, pmd, p);
 		}
 		zero_pte_populate(pmd, addr, next);
 	} while (pmd++, addr = next, addr != end);
@@ -142,80 +144,93 @@ static int __ref zero_pmd_populate(pud_t *pud, unsigned long addr,
 }
 
 static int __ref zero_pud_populate(p4d_t *p4d, unsigned long addr,
-				unsigned long end)
+				unsigned long end, pgtbl_mod_mask *mask)
 {
 	pud_t *pud = pud_offset(p4d, addr);
 	unsigned long next;
+	int ret;
 
 	do {
 		next = pud_addr_end(addr, end);
-		if (IS_ALIGNED(addr, PUD_SIZE) && end - addr >= PUD_SIZE) {
+		if (IS_ALIGNED(addr, PUD_SIZE) && end - addr >= PUD_SIZE &&
+		    pud_none(*pud)) {
 			pmd_t *pmd;
 
 			pud_populate(&init_mm, pud,
 					lm_alias(kasan_early_shadow_pmd));
+			*mask |= PGTBL_PUD_MODIFIED;
 			pmd = pmd_offset(pud, addr);
 			pmd_populate_kernel(&init_mm, pmd,
 					lm_alias(kasan_early_shadow_pte));
+			*mask |= PGTBL_PMD_MODIFIED;
 			continue;
 		}
 
 		if (pud_none(*pud)) {
-			pmd_t *p;
-
 			if (slab_is_available()) {
-				p = pmd_alloc(&init_mm, pud, addr);
-				if (!p)
+				if (!pmd_alloc_track(&init_mm, pud, addr, mask))
 					return -ENOMEM;
 			} else {
+				pmd_t *p;
+
 				p = early_alloc(PAGE_SIZE, NUMA_NO_NODE);
 				pmd_init(p);
 				pud_populate(&init_mm, pud, p);
+				*mask |= PGTBL_PUD_MODIFIED;
 			}
 		}
-		zero_pmd_populate(pud, addr, next);
+		ret = zero_pmd_populate(pud, addr, next, mask);
+		if (ret)
+			return ret;
 	} while (pud++, addr = next, addr != end);
 
 	return 0;
 }
 
 static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
-				unsigned long end)
+				unsigned long end, pgtbl_mod_mask *mask)
 {
 	p4d_t *p4d = p4d_offset(pgd, addr);
 	unsigned long next;
+	int ret;
 
 	do {
 		next = p4d_addr_end(addr, end);
-		if (IS_ALIGNED(addr, P4D_SIZE) && end - addr >= P4D_SIZE) {
+		if (IS_ALIGNED(addr, P4D_SIZE) && end - addr >= P4D_SIZE &&
+		    p4d_none(*p4d)) {
 			pud_t *pud;
 			pmd_t *pmd;
 
-			p4d_populate_kernel(addr, p4d,
+			p4d_populate(&init_mm, p4d,
 					lm_alias(kasan_early_shadow_pud));
+			*mask |= PGTBL_P4D_MODIFIED;
 			pud = pud_offset(p4d, addr);
 			pud_populate(&init_mm, pud,
 					lm_alias(kasan_early_shadow_pmd));
+			*mask |= PGTBL_PUD_MODIFIED;
 			pmd = pmd_offset(pud, addr);
 			pmd_populate_kernel(&init_mm, pmd,
 					lm_alias(kasan_early_shadow_pte));
+			*mask |= PGTBL_PMD_MODIFIED;
 			continue;
 		}
 
 		if (p4d_none(*p4d)) {
-			pud_t *p;
-
 			if (slab_is_available()) {
-				p = pud_alloc(&init_mm, p4d, addr);
-				if (!p)
+				if (!pud_alloc_track(&init_mm, p4d, addr, mask))
 					return -ENOMEM;
 			} else {
+				pud_t *p;
+
 				p = early_alloc(PAGE_SIZE, NUMA_NO_NODE);
 				pud_init(p);
-				p4d_populate_kernel(addr, p4d, p);
+				p4d_populate(&init_mm, p4d, p);
+				*mask |= PGTBL_P4D_MODIFIED;
 			}
 		}
-		zero_pud_populate(p4d, addr, next);
+		ret = zero_pud_populate(p4d, addr, next, mask);
+		if (ret)
+			return ret;
 	} while (p4d++, addr = next, addr != end);
 
 	return 0;
@@ -230,15 +245,19 @@ static int __ref zero_p4d_populate(pgd_t *pgd, unsigned long addr,
 int __ref kasan_populate_early_shadow(const void *shadow_start,
 					const void *shadow_end)
 {
-	unsigned long addr = (unsigned long)shadow_start;
+	unsigned long start = (unsigned long)shadow_start;
+	unsigned long addr = start;
 	unsigned long end = (unsigned long)shadow_end;
 	pgd_t *pgd = pgd_offset_k(addr);
 	unsigned long next;
+	pgtbl_mod_mask mask = 0;
+	int ret = 0;
 
 	do {
 		next = pgd_addr_end(addr, end);
 
-		if (IS_ALIGNED(addr, PGDIR_SIZE) && end - addr >= PGDIR_SIZE) {
+		if (IS_ALIGNED(addr, PGDIR_SIZE) && end - addr >= PGDIR_SIZE &&
+		    pgd_none(*pgd)) {
 			p4d_t *p4d;
 			pud_t *pud;
 			pmd_t *pmd;
@@ -251,34 +270,46 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
 			 * puds,pmds, so pgd_populate(), pud_populate()
 			 * is noops.
 			 */
-			pgd_populate_kernel(addr, pgd,
+			pgd_populate(&init_mm, pgd,
 					lm_alias(kasan_early_shadow_p4d));
+			mask |= PGTBL_PGD_MODIFIED;
 			p4d = p4d_offset(pgd, addr);
-			p4d_populate_kernel(addr, p4d,
+			p4d_populate(&init_mm, p4d,
 					lm_alias(kasan_early_shadow_pud));
+			mask |= PGTBL_P4D_MODIFIED;
 			pud = pud_offset(p4d, addr);
 			pud_populate(&init_mm, pud,
 					lm_alias(kasan_early_shadow_pmd));
+			mask |= PGTBL_PUD_MODIFIED;
 			pmd = pmd_offset(pud, addr);
 			pmd_populate_kernel(&init_mm, pmd,
 					lm_alias(kasan_early_shadow_pte));
+			mask |= PGTBL_PMD_MODIFIED;
 			continue;
 		}
 
 		if (pgd_none(*pgd)) {
 
 			if (slab_is_available()) {
-				if (!p4d_alloc(&init_mm, pgd, addr))
-					return -ENOMEM;
+				if (!p4d_alloc_track(&init_mm, pgd, addr, &mask)) {
+					ret = -ENOMEM;
+					break;
+				}
 			} else {
-				pgd_populate_kernel(addr, pgd,
+				pgd_populate(&init_mm, pgd,
 					early_alloc(PAGE_SIZE, NUMA_NO_NODE));
+				mask |= PGTBL_PGD_MODIFIED;
 			}
 		}
-		zero_p4d_populate(pgd, addr, next);
+		ret = zero_p4d_populate(pgd, addr, next, &mask);
+		if (ret)
+			break;
 	} while (pgd++, addr = next, addr != end);
 
-	return 0;
+	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
+		arch_sync_kernel_mappings(start, end);
+
+	return ret;
 }
 
 static void kasan_free_pte(pte_t *pte_start, pmd_t *pmd)
@@ -286,6 +317,9 @@ static void kasan_free_pte(pte_t *pte_start, pmd_t *pmd)
 	pte_t *pte;
 	int i;
 
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PMD_MODIFIED)
+		return;
+
 	for (i = 0; i < PTRS_PER_PTE; i++) {
 		pte = pte_start + i;
 		if (!pte_none(ptep_get(pte)))
@@ -301,6 +335,9 @@ static void kasan_free_pmd(pmd_t *pmd_start, pud_t *pud)
 	pmd_t *pmd;
 	int i;
 
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PUD_MODIFIED)
+		return;
+
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		pmd = pmd_start + i;
 		if (!pmd_none(*pmd))
@@ -316,6 +353,9 @@ static void kasan_free_pud(pud_t *pud_start, p4d_t *p4d)
 	pud_t *pud;
 	int i;
 
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
+		return;
+
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		pud = pud_start + i;
 		if (!pud_none(*pud))
@@ -331,6 +371,9 @@ static void kasan_free_p4d(p4d_t *p4d_start, pgd_t *pgd)
 	p4d_t *p4d;
 	int i;
 
+	if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
+		return;
+
 	for (i = 0; i < PTRS_PER_P4D; i++) {
 		p4d = p4d_start + i;
 		if (!p4d_none(*p4d))
@@ -377,6 +420,9 @@ static void kasan_remove_pmd_table(pmd_t *pmd, unsigned long addr,
 			continue;
 
 		if (kasan_pte_table(*pmd)) {
+			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PMD_MODIFIED)
+				continue;
+
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
 				pmd_clear(pmd);
@@ -403,6 +449,9 @@ static void kasan_remove_pud_table(pud_t *pud, unsigned long addr,
 			continue;
 
 		if (kasan_pmd_table(*pud)) {
+			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PUD_MODIFIED)
+				continue;
+
 			if (IS_ALIGNED(addr, PUD_SIZE) &&
 			    IS_ALIGNED(next, PUD_SIZE)) {
 				pud_clear(pud);
@@ -430,6 +479,9 @@ static void kasan_remove_p4d_table(p4d_t *p4d, unsigned long addr,
 			continue;
 
 		if (kasan_pud_table(*p4d)) {
+			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_P4D_MODIFIED)
+				continue;
+
 			if (IS_ALIGNED(addr, P4D_SIZE) &&
 			    IS_ALIGNED(next, P4D_SIZE)) {
 				p4d_clear(p4d);
@@ -464,6 +516,9 @@ void kasan_remove_zero_shadow(void *start, unsigned long size)
 			continue;
 
 		if (kasan_p4d_table(*pgd)) {
+			if (ARCH_PAGE_TABLE_SYNC_MASK & PGTBL_PGD_MODIFIED)
+				continue;
+
 			if (IS_ALIGNED(addr, PGDIR_SIZE) &&
 			    IS_ALIGNED(next, PGDIR_SIZE)) {
 				pgd_clear(pgd);

base-commit: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
-- 
2.54.0


