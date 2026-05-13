Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46714CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 13:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B01986B00E4; Wed, 13 May 2026 09:11:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8F36B00E6; Wed, 13 May 2026 09:11:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7EF6B00E7; Wed, 13 May 2026 09:11:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCAC6B00E4
	for <linux-mm@kvack.org>; Wed, 13 May 2026 09:11:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AC23855E0
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:21 +0000 (UTC)
X-FDA: 84762432762.02.1B68F11
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4359F140014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:11:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HLVet+wi;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778677879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RjQC+d3yUJ1wS02bTAKTrS34AR4NyzrcQRS2dfL6Y70=;
	b=n2yq23CxD7SLneaOoq63rbeQ1O7TC3MqElmxMvkRW4LtMhfLLZ1crmh+PdA9k/XOy5qTUm
	gNsXnj8JGgcjiGPqVV3N0x70f4yEmhtkoBFoBr2qj44FkRFQNsAx+7uqOkEFhCwpnE/59/
	cz3lqU8e1hmm1KPhZzRs2NaIqx5Y7JM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HLVet+wi;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778677879; a=rsa-sha256;
	cv=none;
	b=rxKadFvxfIZDIu/Y4rsjzmhvosg1btzd2OH9zPwb3ATaHNwwPjOSdMzaXHYR6C55RD/CHy
	zrxoXv+VeJu4bCm8asKF4CzwauF9zqExoywSv3tB/j8+SE1VqcDWdLeH7Aliif3ocnb2Jk
	HbjFWIyg477yzC1LsdM8DrmQewgeVc8=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ba0714574fso37212205ad.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 06:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778677878; x=1779282678; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RjQC+d3yUJ1wS02bTAKTrS34AR4NyzrcQRS2dfL6Y70=;
        b=HLVet+wiHTnAlsz/zVW/hN28y5abE3lP1RdcR9dVA14Gkyhv6F89eaVug+cwa9gV7J
         UexE+IwHjYNkztJ/sdmA4+BZn748SIkPlyKPhit2zgA5IPSooXyajJ/1ZscqRquYDtyk
         oKilKDRpfvytYm//TU/Xp2Ik4mwSNm0994PTxWkXrXPRseNBkjdCPWs3ORvZq2+zfDc+
         wAOvDfE5Qx59DpL08DUJ0lDj1p4OdW3IjX9QZJcPhYZJeTc/wJgLPlxd9riB6psj8A77
         kZBqBtZIJ9wBNoM4tFzOvPgVZqI3AJocw9ep/QSOJa7weLzVvFqQw1IbyDQbolgiCdyJ
         Vsvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778677878; x=1779282678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RjQC+d3yUJ1wS02bTAKTrS34AR4NyzrcQRS2dfL6Y70=;
        b=QuEjGCtqEQgOrx3DN41c1/4ZHmEHiq9srkYxXERANlbIUHdc4gf21BcF/Ak6WguCt0
         Xo1svWoVSCQpOYqSgHruVl0kUoEfqnPZiYhPHne9c38n+80tSK0pOkDS4gpGjh6AtcFm
         IaHDJAs/OqsnMz1W+SQeLRN7Ie3KGCxMKR1vqKcYUQasDAu++1+EURXHRJAT9hnFFqxY
         na1PIkpWYJ3Kyv0L/UMtUXf6kdLzfJym9i5eUn0PessQWeLqnob9NnnQN2T60U5yarVD
         mpGzAqzvejGrBxu1s9luVctkqsEu1DtGjbdrfzo6sVRrxyPDjuZvOBr1FET/xX2WLZzL
         0fLQ==
X-Forwarded-Encrypted: i=1; AFNElJ8jjbDlsBDhysZPYPC0P9KTF4ECrRxvy+yEj0c7ldMPkzlpd/ok68/I7z9o/Pwry8GJ0rZCayjPIg==@kvack.org
X-Gm-Message-State: AOJu0YyT43sBD43xnqIdmzw5EVl3UU+EFPl0KlD8W2fK74YJSAgsQOK3
	FitVCXcUbx1C8HfIhGTIR90DNi6H/gm0Iow28K7L9jifO0cOTEa7KVezdvOMzOq37RY=
X-Gm-Gg: Acq92OHMn58ObjcelTgQ4RHlKmwmri/B58QCU7TVedGdoydFDqgQ00nazmKppkOGLcc
	SC/N7eS27B0mmI6dGvb+L9+g/uOD3SNIWgEDbdMW7sFBJUrR0MPhe5xShj0HlEf6ZIZ3qJog5qM
	RJ3EkO5GTRtdDxDzRkxvTDIMTybLdUrBzEeOynCF6c3YV0uB2TUNJHcj0OH7xBVpug51qB0K3yZ
	BmO7zpeRw7qxWGEk9wKVOh6nCiLt8koH7PLxsuIAbHmlhtDpnpFoO8Fe4hTx46PK68IYaqp/obj
	5+6lapvSbAYZsYbqBJ7P30Kvmt488AFQ9U1itqg9LCXG9p1eXNbRH9/ygU/xe5n4JpU9aEphcZN
	uxyqCbJ0I+dmC3lOsM/yoNk5xWzZQJZYD1bb9ZfqavRftOAtUw7pV4TjK3eiUyuqKwJTPzmkwdk
	BjyTbCirgSrL8V54+FBlZwOXVisAqMavOniJbQof8YEPqQszggIkRMRd/w5As=
X-Received: by 2002:a17:902:d2c9:b0:2ba:3e50:e3f5 with SMTP id d9443c01a7336-2bd2ff29802mr31509965ad.30.1778677878094;
        Wed, 13 May 2026 06:11:18 -0700 (PDT)
Received: from PXLDJ45XCM.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e90854sm166641925ad.66.2026.05.13.06.11.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 May 2026 06:11:17 -0700 (PDT)
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
	Ackerley Tng <ackerleytng@google.com>,
	Frank van der Linden <fvdl@google.com>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 41/69] mm/sparse-vmemmap: Drop the extra tail page from DAX reservation
Date: Wed, 13 May 2026 21:05:09 +0800
Message-ID: <20260513130542.35604-42-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260513130542.35604-1-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4359F140014
X-Stat-Signature: wy4i8ywja7ff15ksu68nfy44835zpk5q
X-HE-Tag: 1778677879-489714
X-HE-Meta: U2FsdGVkX19slZfxhQVcE8m749e3zj8PuWmVYC+WQBWPbkL49tbn+OnWyvwZqWFvaI48snBilmKlacv3aYKakAddDY623SiqPo2c42YYFapyyHr4QzKbHWtFec9ntAPZ/L1OwWIOiNVD3nJxEyfX6MbQfK8dj2ykd9z09YVplS5YkNqYfAappUS5154Yjqubg6M2QByHoY8tcIsh30C/eToOkxNIUE9LAT0kBNq5PQwmPk2S5679XZdDxghszyPzTO+UTMv9/N5jdT57sUWFcQLLfMYuU1KC/7x3zyVfanxYojRsDLEgX/v/qA0LDmHYSXoGpLZGuPGpyykKg6NRWrlxDVDQ3uHplIdFmigv7SGQ/V89kHiiZ/3qKej4UOZi1j/Hd57NghnLDMGI2nhjB2Ndd5mskj+tTYnTdVkmTu8I1jsP42oFKrqHc7f91Wuv3Hevadcft4xY9gz1HJgzFFz1eqVJmKXUxooOE+a9HQUM4X1gNKMk7uACg62z/CtJ9xxh5FxMvGJYxf/6+zKKGl4cD1p3SJXhmHZBpXeCd7Fe6Gj4tSQZ7NOZ+OjG5oRiNdRWy7tgGYdNrLR1PSZqd6fjLdghf+sXXP4KSH2YPlXlL7CO6TjLv+3PQCNBYWPZRw8QToy6KhC7QrOiA+YyLq+edcex4FfZhzxHO9xQlHm9LNTfprvli7Dhow28EdAop6614wPFpFnEc9FKmJFy3CP+DEt+CwY8ZqdQKNxdNg223akwFFjmjD4yPKHvqmtJKqfRn4xR0FJfYecqL4LcrPH9yozetQgnsO2IuHY4S5vjLqV8/TSv1sfNEMzC9RqjBzfLnkk+yqeZw01mG1VaA7LXnRWDcRMBnR67qPNW5+hkCCm/DimioDyZ/7Y2l9dXJOXes2E9+hYMBJH7D6KHGmDpgRbveUWSmm4M4Hx+/+33Xn2i+ZsZFFYqhPC/sBKUfOCHZly9ouDcbQCB4PJ
 Er6pw1Zm
 wcmisEmRiiy5ERe6gx6vVAlf0Y7WiI9yE75jfBKcOrBsO4kS4/yvHqHU/lgmgRH7LoxN9oLVE5mMJPFILXhc24Ga0p5VPkTvweLjTEWBvD1PLGGsQoY/KUW77Xu6UXoGOJhjlv5nizvgOVMSi9cbdKu1VmlchzKDGZ7WFU6kJRXcnKxbyGHnjibn9mrMg/H8KuRAf02K8Tl9a6YRfgxBtHlbZNFqRaCAC4V+lnVUIHIwBqvr95g5LWegFd1gcwUgzdt9cMNFT2Ok0htFdM7gKNBadpggVRyVQj0mrQ2dKHSTHQTIjjhc1eVk8hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAX compound vmemmap population still reserves one extra tail vmemmap
page after the head page, and only maps the remaining tail pages
through the shared tail page.

Drop that extra reservation and let the shared tail page cover all tail
vmemmap pages after the head page, so DAX follows the same reservation
model as HugeTLB.

This reduces the reserved vmemmap pages for optimized DAX mappings to
OPTIMIZED_FOLIO_VMEMMAP_PAGES and removes the now-unneeded first-tail
population from the generic and powerpc paths.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 44 +-----------------------
 include/linux/mm.h                       |  2 +-
 mm/sparse-vmemmap.c                      |  8 +----
 3 files changed, 3 insertions(+), 51 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 95e65ac8cdea..fb8738016b30 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -1217,39 +1217,6 @@ int __meminit radix__vmemmap_populate(unsigned long start, unsigned long end, in
 	return 0;
 }
 
-static pte_t * __meminit radix__vmemmap_populate_address(unsigned long addr, int node,
-							 struct vmem_altmap *altmap,
-							 struct page *reuse)
-{
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-	pmd_t *pmd;
-	pte_t *pte;
-
-	pgd = pgd_offset_k(addr);
-	p4d = p4d_offset(pgd, addr);
-	pud = vmemmap_pud_alloc(p4d, node, addr);
-	if (!pud)
-		return NULL;
-	pmd = vmemmap_pmd_alloc(pud, node, addr);
-	if (!pmd)
-		return NULL;
-	if (pmd_leaf(*pmd))
-		/*
-		 * The second page is mapped as a hugepage due to a nearby request.
-		 * Force our mapping to page size without deduplication
-		 */
-		return NULL;
-	pte = vmemmap_pte_alloc(pmd, node, addr);
-	if (!pte)
-		return NULL;
-	radix__vmemmap_pte_populate(pmd, addr, node, NULL, NULL);
-	vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
-
-	return pte;
-}
-
 int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					      unsigned long start,
 					      unsigned long end, int node,
@@ -1316,16 +1283,7 @@ int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 					return -ENOMEM;
 				vmemmap_verify(pte, node, addr, addr + PAGE_SIZE);
 
-				/*
-				 * Populate the tail pages vmemmap page
-				 * It can fall in different pmd, hence
-				 * vmemmap_populate_address()
-				 */
-				pte = radix__vmemmap_populate_address(addr + PAGE_SIZE, node, NULL, NULL);
-				if (!pte)
-					return -ENOMEM;
-
-				next = addr + 2 * PAGE_SIZE;
+				next = addr + PAGE_SIZE;
 				continue;
 			}
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5281f073230c..86d7cecb834e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4898,7 +4898,7 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 }
 #endif
 
-#define VMEMMAP_RESERVE_NR	2
+#define VMEMMAP_RESERVE_NR	OPTIMIZED_FOLIO_VMEMMAP_PAGES
 #ifdef CONFIG_ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 static inline bool __vmemmap_can_optimize(struct vmem_altmap *altmap,
 					  struct dev_pagemap *pgmap)
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 0c0b54e94c07..b5c109b8af6f 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -473,17 +473,11 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
 		if (!pte)
 			return -ENOMEM;
 
-		/* Populate the tail pages vmemmap page */
-		next = addr + PAGE_SIZE;
-		pte = vmemmap_populate_address(next, node, NULL, -1);
-		if (!pte)
-			return -ENOMEM;
-
 		/*
 		 * Reuse the shared page for the rest of tail pages
 		 * See layout diagram in Documentation/mm/vmemmap_dedup.rst
 		 */
-		next += PAGE_SIZE;
+		next = addr + PAGE_SIZE;
 		rc = vmemmap_populate_range(next, last, node, NULL,
 					    page_to_pfn(page));
 		if (rc)
-- 
2.54.0


