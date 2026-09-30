Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA59ECA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 14:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECA426B00A5; Wed, 30 Sep 2026 10:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA2026B00A6; Wed, 30 Sep 2026 10:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91E46B00A7; Wed, 30 Sep 2026 10:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADEF36B00A5
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 10:08:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3152FC078B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:35 +0000 (UTC)
X-FDA: 85270608990.28.728C14F
Received: from mail-pz2-f42.google.com (mail-pz2-f42.google.com [74.125.228.42])
	by imf11.hostedemail.com (Postfix) with ESMTP id 62C4440008
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 14:08:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Oh5mQCkI;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790777313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9xel/71txHnw7brYLWC7OAspVaWnOG/eiO9DEfyBSY=;
	b=I2DklIAcO0IHHbuPM8Cw3FsdSKSUBXmGFdnbDWeH6HI9rblVTcJqgkybCO1nDvvHZLI8P9
	vo5a3EtkowQeDb4IrToXs0yd3K1ekGFgm6VpJ4/0OdFHrhxNBd1Pa+XDo00w/QKZN3ug1H
	3m3iS45f5XdOVsN8vW0dnITFMB6np2c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Oh5mQCkI;
	spf=pass (imf11.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.228.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790777313;
	b=zyg2+elVVJHPgNvqZ4aU02k1qMNt3V1umdKlmSd9PHrubF7GzBXBvlTrBIzzgHbmMC6Nw8
	9zI5B2lNQzDXRFdBiVypLixDMjgdj2lAKst5ZClL2eGzR9I3WDifqo58JByBZzc0FRUchi
	mI8V25RvVOhIG3TzcpOVxDFcSJ4Pbw0=
Received: by mail-pz2-f42.google.com with SMTP id 41be03b00d2f7-cc4bdf8abaaso3219249a12.2
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790777312; x=1791382112; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z9xel/71txHnw7brYLWC7OAspVaWnOG/eiO9DEfyBSY=;
        b=Oh5mQCkIjzCYA2AmtQokclSSvTU/ImNJUwwi5bogQreS+xuZefI22r0lCKI/Mfgnym
         SG1zx+2ThhlleSQFsW6HIukKhnneIInW/kvi3H8Z6qNmF5a8apYHa8PzUQuDayGLmZ5B
         XVrCHn8PgxECqBTArQAbDLjmsi2iJOe0o2OzC8QtRXU64dFHjsFJ4iMyCDbe6CZkh5bd
         mEok0TfZS8Joa9gm7iwPe3hYA1ADR/hhYtnVewjTQ4P7f/ukEmmLDC5WKxoeH5yr1H6Z
         WwnzpsxTGFUDgWFlCwUpBobgt2fgrix+lVBE8k+JlG5oK/LWmoVg7E/G+bNBp9CpNOyg
         WCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790777312; x=1791382112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z9xel/71txHnw7brYLWC7OAspVaWnOG/eiO9DEfyBSY=;
        b=ArTW5h4zx4W2vC15Ls6K58jywh2X5hqr9OiYUB79oo+dYQwzGvfHj57e9+amlxAjfA
         PZUdjmqiaDc8JhW2UEyS3UMyzRGaq7Ol6gqsSGsN+6o1mcZHcvSED5guhfLP2SgB8FtQ
         MKyzp2yVMl/d9PXzIsUJEyos9O/gYWLmCYQCwZ/jM/S8vSyLEaLYbXtL1L91G6POML29
         /+g02lBsZqpax0Bdrzb+5cdhGYQ6b9+bupgusug+cSdJSwOsKJAP3P/a7Zz2cwzI4jps
         x97YN3czOp4nD9gPu+HGjgS7r7P3CbWgdu4tPF2m3P1En/l8Mn5GZXMru46xSeviTVUd
         7MDA==
X-Gm-Message-State: AFq9FYJzqSkVFaUy1FIl+Dq0xw1z9NSGCtH4auC5G2jeVM9rGRtnDKl5
	NLp7p52+DDbrRf8HnmkiHYJ1Buj+FK8gbCq8Corbmmmz8aln5IBw9ON8GjVR/tmB70g=
X-Gm-Gg: AYBFou34+CbM1dW4bkE3T/KOGI4ogTzzu15ac36qyn0tDqG2HoSbIjgF5aSA7AFAWQt
	he/gHxDrSDQzYBb7p34HoqS/bJtVCb9+qQKbUBNByQaYC3+uTn3uPFZzhy6trdNjraKEO/IXlBC
	To3q69l/UcgR8JJ6Ny3/8JBEfI8AS4EO/72clh6b1GckIdU+ZXJ4nIfYiUp5HphhEoQN02gpUNk
	LHWGkJeRVLslMdJWWpWhz216fKs3TOq5OptLCecfW7o8O8YYCbdExuJgz1uyS0AAy3s7udFBkva
	z7g9JlTKHT+gTYlx+eyilrpd0H7zLlQ5iCKRml/BDspA+GwRlOM9tz6y0wHQjZaoS+t6Ft7CCa3
	kmrCZ7LKa/PiEIhfgsT4sAM+TfAxBsk25PaMkJhan2Kj40G8zVAPi32ULXk5LCgZ0xZ8WOk0HSG
	2C97d4I/lk30R3DEiJgg7/sBjl4oLMDuHe2E9RDNIqitHwTmbmwjvXzHfp7nCp/0m6kc+S44Oh/
	FJF/s73Pv/NDTNdruCdr6kb
X-Received: by 2002:a17:90b:2e42:b0:3a0:f2c8:9ad6 with SMTP id 98e67ed59e1d1-3a4d193d340mr1404438a91.64.1790777312124;
        Wed, 30 Sep 2026 07:08:32 -0700 (PDT)
Received: from G6L4RL2QG9 ([139.177.225.238])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a4e60ea12csm639509a91.1.2026.09.30.07.08.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 07:08:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v6 09/12] powerpc/mm: switch device DAX to shared tail vmemmap pages
Date: Wed, 30 Sep 2026 22:06:24 +0800
Message-ID: <20260930140627.57431-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260930140627.57431-1-songmuchun@bytedance.com>
References: <20260930140627.57431-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62C4440008
X-Rspam-User: 
X-Stat-Signature: twijkqydi3ccb13p11am9ctcc3af3w3x
X-HE-Tag: 1790777313-155784
X-HE-Meta: U2FsdGVkX18LX+HeeKyC1XoLKzBH3R69M3Dn9sOIws9Qm6g2li9lnjtaSmGJ9zQaoaoLlKuRYNGVBmzZHdiOXF5lV8oRyWcRKXcHCHPqx6LgCxLg5g0Y+/03ZT6Jp82nyxodfRSNURSakT1osOK1ixuYyoghtImLilhWrekGHLZDd8KwSV78jljxERsGi2S2/WqmxXyeOO+z3Cy96eIKv/yXduYxk+9OGYwLKy/JhEbpU656qI5BJTiYmyxd5GDBc+1A/aLwJm6GUXssZrKIERMP1hW2g/ZBU3F3CrCBf0ItQFrl9qOvGM+225UpNI/Eu+mnhmks6WOK8HDvXyeDW6dFv+LChsqbV063kAtgCUqYArROGze6wnQlEoKMP7YtM6L1kNIiHirEdGsH1RWv3T0ZyuorNc4u7H0XCkERkqjPsrq51ookI0aftBlSysFncR10I0XaoK8u/tnYtwtpbCfrLWQHJs+FfwN1A+VFCG3ZSfPD0WsvzNdGOHFaM0Tv2o/yRhYl4Y7+ndP39BVntnHF4Gf0GFurjDGdLKYFKyYyCv0ACn1MzOtCEQT/q3Dy526F+kFVVjubzrhFgCLk7cB4YuVx703aSnBPTNFifuqxghN+1gox0IFsJEvQEKte8/v5sxMYs375XfRvTIeo5N4yIas/ToiNNLZFka9fxFEj5SzG1ATOZEg7FAjUHRK1K03NbOIb+cUxHj4ETNXoFvpN+FwG6Xv28EBKO2LhfMSay3pke4AR4k1ky1hX3KBpntz6DOmwxHGSZpJREMKaWKPk0KrXQdRaP91tXJuQ1T4+Nf4B/LQtyY+BYRAgQfKtr1uqi2yxSzDrCjRmGJfvVwhbDHKfMiI2GwGaVMYAzBBWaQq4C++Im0FWrL6KdTbFnv+8foij3vioMfpHy2IJFAcQRbnpG+SH9hJ8R7nsQbIwzdD7BDQjxBXaKtWSpJBcL0MX0xM371I5v2fRu2U
 SBH+W2rJ
 cVjYOVf2y4GfDOoBN6a0AFO2EqznddR8hrgqiXwkheBRhdkIgx0KNVgooXYwdiQlVDkvNbrzUSdIq6T1vxdse6gD2xtsNV95CjFvqSAiwWHBwOx9zMOSI1hRRU+ki1mnmNQ0HT9iTIpzxNfa9dCq5oAXRBhr1P6nCg7dmjl13Lzkzpdiyrvis/pspLOZDckBReGxOxq+zUlJuthXo8DYcKGP/U0gn0suMK5/sxKWGXO7wPbiF3EUEG1yu5hwTXyi9cS6GnBUSt0cje+jlxsD3Fk8HqgVRsjB2GXysNr7vcny8aki/LCFz2BL+94bQkgbMIvSgfGYNWeq1bcoICn8/UgquO3yS8FwJ5Hn3MMJ2A5TiWScYL64VwTTarxziPohio1JI4EozQj+EDq+WWGfFI7KjyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The powerpc radix compound vmemmap population path still finds a reusable
tail page by walking the vmemmap page tables.

Switch it to the common vmemmap_shared_tail_page() helper instead, so it
can use the shared vmemmap page directly to simplify the code.

This removes the powerpc-specific tail-page lookup and its fallback path
and aligns the device DAX vmemmap optimization path with HugeTLB.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v6:
- Collect Acked-by from David Hildenbrand
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 80 +++---------------------
 include/linux/vmemmap-optimization.h     |  6 ++
 mm/sparse-vmemmap.c                      |  6 --
 3 files changed, 15 insertions(+), 77 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index cf692b2b5f7b..ee068f24a79f 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -19,6 +19,7 @@
 #include <linux/string_helpers.h>
 #include <linux/memory.h>
 #include <linux/kfence.h>
+#include <linux/vmemmap-optimization.h>
 
 #include <asm/pgalloc.h>
 #include <asm/mmu_context.h>
@@ -1250,59 +1251,6 @@ static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int
 	return pte;
 }
 
-static pte_t * __meminit vmemmap_compound_tail_page(unsigned long addr,
-						    unsigned long pfn_offset, int node)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-	unsigned long map_addr;
-
-	/* the second vmemmap page which we use for duplication */
-	map_addr = addr - pfn_offset * sizeof(struct page) + PAGE_SIZE;
-	pgd = pgd_offset_k(map_addr);
-	p4d = p4d_offset(pgd, map_addr);
-	pud = vmemmap_pud_alloc(p4d, node, map_addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, map_addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, map_addr);
-	if (!pte)
-		return NULL;
-	/*
-	 * Check if there exist a mapping to the left
-	 */
-	if (pte_none(*pte)) {
-		/*
-		 * Populate the head page vmemmap page.
-		 * It can fall in different pmd, hence
-		 * vmemmap_populate_address()
-		 */
-		pte = radix__vmemmap_populate_address(map_addr - PAGE_SIZE, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		/*
-		 * Populate the tail pages vmemmap page
-		 */
-		pte = radix__vmemmap_pte_populate(pmd, map_addr, node, NULL, NULL);
-		if (!pte)
-			return NULL;
-		vmemmap_verify(pte, node, map_addr, map_addr + PAGE_SIZE);
-		return pte;
-	}
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1320,6 +1268,12 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
+	struct page *tail_page;
+	unsigned int order = pfn_to_section_compound_order(start_pfn);
+
+	tail_page = vmemmap_shared_tail_page(order, device_zone(node));
+	if (!tail_page)
+		return -ENOMEM;
 
 	for (addr = start; addr < end; addr = next) {
 
@@ -1349,10 +1303,9 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 			next = addr + PAGE_SIZE;
 			continue;
 		} else {
-			unsigned long nr_pages = pgmap_vmemmap_nr(pgmap);
+			unsigned long nr_pages = 1UL << order;
 			unsigned long addr_pfn = page_to_pfn((struct page *)addr);
 			unsigned long pfn_offset = addr_pfn - ALIGN_DOWN(addr_pfn, nr_pages);
-			pte_t *tail_page_pte;
 
 			/*
 			 * if the address is aligned to huge page size it is the
@@ -1377,23 +1330,8 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 				next = addr + 2 * PAGE_SIZE;
 				continue;
 			}
-			/*
-			 * get the 2nd mapping details
-			 * Also create it if that doesn't exist
-			 */
-			tail_page_pte = vmemmap_compound_tail_page(addr, pfn_offset, node);
-			if (!tail_page_pte) {
-
-				pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-				next = addr + PAGE_SIZE;
-				continue;
-			}
 
-			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, pte_page(*tail_page_pte));
+			pte = radix__vmemmap_pte_populate(pmd, addr, node, NULL, tail_page);
 			if (!pte)
 				return -ENOMEM;
 			vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index bd0974b262a4..fa9e9abd6656 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -83,6 +83,12 @@ static inline unsigned int pfn_to_section_compound_order(unsigned long pfn)
 {
 	return 0;
 }
+
+static inline struct page *vmemmap_shared_tail_page(unsigned int order,
+						    struct zone *zone)
+{
+	return NULL;
+}
 #endif /* CONFIG_VMEMMAP_OPTIMIZATION */
 
 static inline bool vmemmap_optimizable_pfn(unsigned long pfn)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index d40a2f5b5fca..e1f8a03e3d49 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -240,12 +240,6 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 
 	return page;
 }
-#else
-static inline struct page *vmemmap_shared_tail_page(unsigned int order,
-						    struct zone *zone)
-{
-	return NULL;
-}
 #endif
 
 static __meminit void *vmemmap_alloc_pte(unsigned long pfn, int node,
-- 
2.54.0


