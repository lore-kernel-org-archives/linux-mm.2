Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165C5606A332
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 04:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GbJ9CBTf
Received: by kanga.kvack.org (Postfix)
	id 020616B05B5; Fri,  6 Nov 2026 23:32:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12F26B05B6; Fri,  6 Nov 2026 23:32:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29E76B05B7; Fri,  6 Nov 2026 23:32:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB7B16B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:32:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2EEF4A7C66
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:34 +0000 (UTC)
X-FDA: 85407051828.18.685D834
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4AE0D1C0006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 04:32:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GbJ9CBTf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794025952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BY1PW5EQCsSwahWNQsNirKWCM+cX6Fs3QmmMD9rosww=;
	b=ewv2qwsTAZxLp+Hyd2+Up6JvsQsHBbNIpjuNWpAD5gN5ZSj01A16aou9crbMAY5c930jtC
	aWlkZc6AVE5Ae40ddShklQ7E+HSQUdtAs9O/1Do2hueH6+dRYBKdkU131/kQqi4uocLJwf
	pGgP6GfucKXwAob2dstkUfqezBd2Tpg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GbJ9CBTf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794025952;
	b=pA17m/Rr64CKeBl1nmxQeF6y9gMDlOx9Q3BpX2+AAhpOm0XYnAQkA3iDl76nmn5kl4I0fK
	O+OuV9gVsj8DwJJuOyagg/89lRxprpGxzqhsjc9PS84f7oXpZSIsc+WJEif2dmhlyspt6X
	NtOgcLmIMaEZQPYWehCQYYypVGj68UE=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ed2b4348fcso5131395ad.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 20:32:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794025951; x=1794630751; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BY1PW5EQCsSwahWNQsNirKWCM+cX6Fs3QmmMD9rosww=;
        b=GbJ9CBTfI1oHy7SzYaFARMvFUt/tcQAo5ERAmI30uOC7AVe3DxHGMZJYXuTAjvBmxO
         pwSPYLwkXvHTTEXlr1hCe4EzdZRK/gOgaqX9hBAwwEzEVmxmThdbd44dhI53YjZFa2bi
         R8yl2K9uxT9Hu7hR0x06Hrwd/24aUWtLCnFWj0OP4IlZ1Bl4nSGEZ6z0IxN8jfpwG5i3
         iLTMJfpG5P0309MpIhbJydZqctXg62RGDki5/fAqlf05tIxfpvaxFkLkK3KiiZ0AFo1a
         VCx2IGRhvJcfPuodD17+ZhdvnTKlSI0DGukYJwUs7rzKslAbtZGTjA8HpfJYsGcLMNIO
         HJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794025951; x=1794630751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BY1PW5EQCsSwahWNQsNirKWCM+cX6Fs3QmmMD9rosww=;
        b=f1BnqjnPk1Hdi2kTwumpA1sCks60C7uH9CB7fwa4T/BXf2pFfI+8dyZSnfTJZClMuS
         cfhXXjkPXQFArqieYu1N0TDhmYt2mvofolsXDG227FxPzHWofpG9Gz+k8YX2iMSyjheO
         bImCzUqbbYuqXzvzftKXLsuGyUNX9D+FcekiTQat//fBIDOhyO4DogICea1AWCsLZeVw
         ZPCzcWSDRjirt1ZvnUQgMfIRAalwGJGexMD69i6Cqh2yoH7o/ODoOD4m9Fo7ZaaRW4r7
         ZZBhWP/3zi69wL0PRSezy15GWBW/CiupgICqYBHsdBaGpV3d1EeyOXsoe2yE4evPidlu
         eYYw==
X-Forwarded-Encrypted: i=1; AL+hErFEjE2b8O23U3hnNbR2JgYM9rQXlSZxR7+OV9N18QtFAc04l3PBx3LPhZEz2PCr4Grx7Gy58v8zpA==@kvack.org
X-Gm-Message-State: APuU4Z/5zPDECHHPZxv9NIttFSFiXVcB5nBikq+mNFyZELdbYt6Cre5F
	WxmU1p+7+j93r5yMl95aqGTcl4rDbArzrHSC87+WaGs1Ob1PAyPu54AWlonB36FYN9Q=
X-Gm-Gg: AYBFou3kFZhCAQEsDhLkZ0mQGy9ckMxPWLjRiWZYgueeiZTj/f2dTI8UZh4yJsYZEp+
	tcTz0WQMoNq8c6Q58r7j7ucE1s1vkS7r6JJy6606IOIknjtpGWHMLYIc1f7cV2hMDjPZJQCQzqN
	k0FpwDp2pC80I/l9PrLJ3DkO+EXb3cyapJLvD61Um0xCo5taD+FgW2qCnnlf9RXlP3tfqe9ic0S
	l63m8d/D15xwcdzTJMfINUBsKrkJ/i5AcF2kzOAQ/iXsU8VD7v9WVR/728awlF20Mes2pyli7Lx
	qtPS18tMOs78Ny4q9qIEvV3CXYEImaOYABCUd8K2dt/OL+OC5WzS+nU/95p6mBjLytLuL9MTjzS
	a7m4uWtpyKw9zQfJJr7PqFUJ547kG1QgUkz3A2vHnK6zZvhQbMsAJG1DYx1d1gGxe6DLPnToO4z
	wvi4cjGdvvwjyUHqncDRKp5gqYAZugrnbhDSCIz0Lp2muTZ5Opci3wFyPjEflvNSdgFbl6SzPIT
	N20p0q3ru1HL4pfupPHVBXfOfkSXQWN57e7ZtuT3Pu+XD/MmhGzsxzTO7B+mJHshb6Ps3cSOP+R
	aB6rV987cUegHQ9+25Teh9Dh7Hls9bN4kjBSeoLX0z6VvE4+7XgBTUmVx3LYNezIsk65Ta+Fw9y
	ctdJPkg==
X-Received: by 2002:a17:90b:530c:b0:3a8:59d3:530f with SMTP id 98e67ed59e1d1-3b0db71d480mr4559125a91.57.1794025951057;
        Fri, 06 Nov 2026 20:32:31 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b10584b66bsm1578451a91.14.2026.11.06.20.32.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 20:32:30 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 4/5] mm/sparse-vmemmap: drop vmemmap_can_optimize()
Date: Sat,  7 Nov 2026 12:31:21 +0800
Message-ID: <20261107043122.25650-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261107043122.25650-1-songmuchun@bytedance.com>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4AE0D1C0006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: opg6turqmnkm563qzxqefjou3qa7wkrb
X-HE-Tag: 1794025952-11775
X-HE-Meta: U2FsdGVkX1/4qvKhnebSdnwUX+cF6IPdyUKmWjMASekPn2tA4s5rvXBVd3oQ3iKZmUoncuWxae1DZmZm+CwXovngCS1wTxa4Plh7MJcKnmS+PQZPhtlZHuWP3PLDny0Scr531jMnsTsBxyVLzeKbQqhtZHw268glYFmWr3rntePwj8rp0Vv4BMXvN++Y3zOaH+uGZk9ul4PXct6rzT8O0opFWN9t6v36JXQzbw193mhJtj3z4/QzNPvdUl+sbydzxbeMGdS4FleEz/T8z453L8l5UJC0+IJvuSDSeWnf05f5E9haFHJAIXWJIPd8Hz3/FEFytpfoHuc3qH6lc4vb8PrZQ+PhZUJlmr7DObfhtzcvCLFiyleYBjAN9ZBqQhBXrEhZQk5Ua3/gj3qpN9vuyQuxDFJwCNtfhdBzPeuJeOMYyursr1m133eFCAJz6Isg1j26G5dkeVqODYm3Qxqvi/eJMqf8CkxqNmvKtynYY/9viaRd0Hh2Zh+RaJDRX1WKMsWCYcUJPfhR8PjCySV8o3B5RP7a/2NrO1vqgjZNq5nX6NJl3w/SwtPGK65O3MRU2Cs38nUtMz79Vbk+8Yktps8/drDZMDSCcY8FvQCfa/fKR4i8xxSXxdB2EtKkA+dsUC5rLIVzggjsancl2XZDFU58B5o68puSh4zVHH6vio88Hs0GxPtZzBZN+Nc11VMrliBEwVBi9hWQJ3R4YMUFD5kWogiz3gUS/kmzrIAcY2jq2eS+/cWe8/kUOZniAiV8J/+YKpSh+NBw9RNmRzSfP3KJYr/s0RFFUDEAi7abs/DQVEy+qJEKh2348usTEthUr+iJzt6Z5trrnwS/HeBjjeyOs0bIEGXVljzdxAim8Vsmess3Ykg2R+lYRAVqrYBE1sGaBzZdTO0ZWQUVuQdEQVQ2r4ItnaZEWKD/bfyGqUuN8zjzfS7i+VkJyx3H8sutXEWWfE7xq6mxuZjBSLZ
 tI7B4ABv
 2ZN3PBJUJru3s9S71W15V5WmuBcnDYzTZBOP1lloRZ/kZnfEh0SP8iDGgwsfXfHn9fJONXBG8WULFv9704bZQrzuNdFC73lTxXkTcaeyYe02uE6/E1/n2I99iUYWmAj2VCxx3kXwOvuFSKiGmlSTxTF4K3HHkoRV5iYbcMiAB4kxbIg7mB3UEj3m5VF4S29vTk1QjxwTjfHlPh5e8uXvlLHyP0Fgan4GHY1KeajhPHWs4W8PTo0+gCUsHN8tQbefB8oW1aZOfbv6DKUocv87syF03Ceeh686/lsIcTONXv2TWgI7qP8wIIO6l8pnPaiShOkJI+g2ehG0FM9GrM1H5cikOzkeSMowfa9W+0y1cPAhSEWPoZ4hM+Ggk69tWDTRX0TA0nngGJrl/MWR3PuQo4S0MaJ6BgUfZ0ndREYNfYl7W4ne/dEe2uyhe1cK8FlFG22E3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

section_vmemmap_optimizable() can already decide whether a section uses
vmemmap optimization based on the section compound order. The DAX-specific
vmemmap_can_optimize() helper duplicates that policy, so remove it to
simplify the code.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Ignore non-optimizable nonzero section orders while retaining zero
  as the reset value (reported by Sashiko)
- Use section_vmemmap_optimization_disable() for the altmap fallback
- Move vmemmap_optimizable_order() before its first caller
---
 include/linux/mm.h                   | 37 ----------------------------
 include/linux/vmemmap-optimization.h | 25 ++++++++++---------
 mm/sparse-vmemmap.c                  |  6 +++--
 3 files changed, 18 insertions(+), 50 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2d0b8a4c9974..43eb19474d26 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -38,7 +38,6 @@
 #include <linux/bitops.h>
 #include <linux/iommu-debug-pagealloc.h>
 #include <linux/kcsan-checks.h>
-#include <linux/vmemmap-optimization.h>
 
 struct mempolicy;
 struct anon_vma;
@@ -5385,42 +5384,6 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
-static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
-					  struct dev_pagemap *pgmap)
-{
-	unsigned long nr_pages;
-	unsigned long nr_vmemmap_pages;
-
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!pgmap || !is_power_of_2(sizeof(struct page)))
-		return false;
-
-	nr_pages = pgmap_vmemmap_nr(pgmap);
-	nr_vmemmap_pages = ((nr_pages * sizeof(struct page)) >> PAGE_SHIFT);
-	/*
-	 * For vmemmap optimization with DAX we need minimum 2 vmemmap
-	 * pages. See layout diagram in Documentation/mm/vmemmap_dedup.rst
-	 */
-	return !altmap && (nr_vmemmap_pages > VMEMMAP_OPTIMIZATION_PAGES);
-}
-/*
- * If we don't have an architecture override, use the generic rule
- */
-#ifndef vmemmap_can_optimize
-#define vmemmap_can_optimize __vmemmap_can_optimize
-#endif
-
-#else
-static inline bool vmemmap_can_optimize(struct vmem_altmap *altmap,
-					   struct dev_pagemap *pgmap)
-{
-	return false;
-}
-#endif
-
 enum mf_flags {
 	MF_COUNT_INCREASED = 1 << 0,
 	MF_ACTION_REQUIRED = 1 << 1,
diff --git a/include/linux/vmemmap-optimization.h b/include/linux/vmemmap-optimization.h
index 22e5a322be0b..985a37dfcab7 100644
--- a/include/linux/vmemmap-optimization.h
+++ b/include/linux/vmemmap-optimization.h
@@ -31,6 +31,17 @@
 #define VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES	(VMEMMAP_OPTIMIZATION_SIZE / sizeof(struct page))
 #define VMEMMAP_OPTIMIZATION_MIN_ORDER		(ilog2(VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) + 1)
 
+static inline bool vmemmap_optimizable_order(unsigned int order)
+{
+	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
+		return false;
+
+	if (!is_power_of_2(sizeof(struct page)))
+		return false;
+
+	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
+}
+
 #ifdef CONFIG_VMEMMAP_OPTIMIZATION
 static inline unsigned int section_compound_order(const struct mem_section *section)
 {
@@ -40,6 +51,9 @@ static inline unsigned int section_compound_order(const struct mem_section *sect
 static inline void section_set_compound_order(struct mem_section *section,
 					      unsigned int order)
 {
+	if (order && !vmemmap_optimizable_order(order))
+		return;
+
 	VM_WARN_ON(section_compound_order(section) && order &&
 		   section_compound_order(section) != order);
 	section->compound_page_order = order;
@@ -109,15 +123,4 @@ static inline bool vmemmap_optimizable_pfn(unsigned long pfn, unsigned int order
 
 	return (pfn & (nr_pages - 1)) >= VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
 }
-
-static inline bool vmemmap_optimizable_order(unsigned int order)
-{
-	if (!IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION))
-		return false;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return false;
-
-	return order >= VMEMMAP_OPTIMIZATION_MIN_ORDER;
-}
 #endif /* _LINUX_VMEMMAP_OPTIMIZATION_H */
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 57aa5c2d8034..f6a8b8e51b6c 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -490,6 +490,9 @@ struct page * __meminit __populate_section_memmap(unsigned long pfn,
 		!IS_ALIGNED(nr_pages, PAGES_PER_SUBSECTION)))
 		return NULL;
 
+	/* Altmap-backed vmemmap pages cannot be optimized. */
+	if (altmap)
+		section_vmemmap_optimization_disable(start, end);
 	r = vmemmap_populate(start, end, nid, altmap);
 	if (r < 0)
 		return NULL;
@@ -717,10 +720,9 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 	struct mem_section *ms = __pfn_to_section(pfn);
 	struct mem_section_usage *usage = NULL;
 	struct page *memmap;
-	unsigned int order;
+	unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
 	int rc;
 
-	order = vmemmap_can_optimize(altmap, pgmap) ? pgmap->vmemmap_shift : 0;
 	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
 		return ERR_PTR(-EOPNOTSUPP);
 
-- 
2.54.0


