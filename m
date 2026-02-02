Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1971AE65298
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D72E6B008A; Sun,  1 Feb 2026 19:55:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40C066B0092; Sun,  1 Feb 2026 19:55:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F2D6B008A; Sun,  1 Feb 2026 19:55:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8A96B008A
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:32 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B333F1409F1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:31 +0000 (UTC)
X-FDA: 84397698462.22.7A7D11A
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id D0ABC180004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eGMmS7bq;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28/pyoJMGtkXfar6Z5eN1MS6qKjklbYO6LOLeELBWwE=;
	b=f57JNK77RKKTdxeKo5Hg3zY9sVxp2+ZydeDNP+/+9hQq+2jHJbvc+/7oXj88xDfg2ceoUZ
	FsS16BdVBuDTcFF4y/lCvBdgGo4i/bDmhhusKOl9mdTu4gShRlnPx/jEwJ7ydvWqeRZeS8
	JykB+ZeiBNvt+ZOjIS0HIgF9g1qeOOc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eGMmS7bq;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.167.176 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993729; a=rsa-sha256;
	cv=none;
	b=ged0s7IL2d9iHaFAhzb8DrW2/2Jf6SRmt0iRbfozBHLBknHFhoBj56sM9CFHGif71j0i5x
	pMcuxS1Vl+FUW+dvZrisDow0DknAOEVakQ14kXtB/4HPJbJQZVynKvnaxUsJxUv5VkQDpV
	9Qq+VIgemSyd+D+9R5DGOnL/j7aacKI=
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45c889aba0dso3115566b6e.0
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993729; x=1770598529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=28/pyoJMGtkXfar6Z5eN1MS6qKjklbYO6LOLeELBWwE=;
        b=eGMmS7bqxQqoc/KXcHLC4KksGYDO+u4hUEfw6cn2so9r3/4/5JVvYrO5cd3FsoGPDN
         0uyH319e24Or3MFmINbmccVeXxSGqRPOecdLUvVEniI2/v/XG/zV2XsTm4qgcm4cWdYS
         6n9+SH2sObxLtByN8M6T1R0afOSh3iO74SJAtTewh5jeuQcc7+zpAyZFqPbQMLicw7SI
         pEe9u6wFY3//JwHO2e6EEZx/+HEyG/ujvPDppzNcR0pR3JfFoWzjGHC2ylQg4QD3vtBT
         4pw3AIT6D36iIeHtJR4irIjos/FG/AeVsQs/gmwrjAAe6hHUVvCyGATDJu8K8zTYLO7j
         WxDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993729; x=1770598529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=28/pyoJMGtkXfar6Z5eN1MS6qKjklbYO6LOLeELBWwE=;
        b=qzgAERSQBBGW0109Vv0igoyqPPFVFUn5F55ZkuU6t4pE7Rzb1/Bp5+T7rjsbcVpZ2H
         A00nb2dHIKlovGhoc7G3CVVUVjern0vNAzg9Qg05Jq7WZwDY9KZe9lgofeCOFL494B4O
         ozA9De6ht4ThVP3g5kFDXpui5sbBnF9QCJtsiUaVbg+BGhrM9hPu6K5VKcAQr7cFHo+d
         7Zuu6zLrhpPNJPwhpIlaJIrrZSztLhuKy/9GIeVcsiaBlBg480DX9oZW5jX3doImIwQo
         n1z9sasaHNQxTivtENwD4IqZVt8wS/quBQReARv1Bo00UiNDdHF5ZyeE9fzcJox2pxRe
         LINg==
X-Forwarded-Encrypted: i=1; AJvYcCWRCXoXwF0gHrhyY0ru0jZj4+X8cH1GZiglkKFbuXwlTeQgl6SovXxZDgmHiURfHEUwNK8G/cVAug==@kvack.org
X-Gm-Message-State: AOJu0Yw922YrFa3g93PYVVYAB7pCj/zDE7brh1Zko4gS1KIc8VBOFLcl
	2Bjfe7huuAjRIjykhAkvK8AMgTlCtz3Zmh8Z9uilQ4PAPlBxDEQ3UwCR
X-Gm-Gg: AZuq6aLKQz6AxwGc97WYXa6020fFJCT056Zh/WVsXFjOBYykmCtRlBTonVMvUxEUptG
	FNtAh2t6DH+1z3tUnUymHBGbrBQvUjsNmaLWxIy2JvHNAa9TXkDKRKPUfpQpPgH4waQ2dhWffb5
	f0SP596EVnE4t4AUQqD87eq/xxMaiRSBv8j0mXXXvSE4cFaoNDX4O1AM1rv51hm1TmEFJfPUmI5
	XwfmeDTJTeCW/szofplwDxrBOhVEbpAgfOaxGNGmw4tvYu0NOr8JIKSJ4i4q1Rq8sVGhP55lOP2
	oaPSKMr/2hDjjloyRp4YR1IZbb5XY/UCpK8SHsXRwJxwnRR05WKqhsKerabs1xNUAwS4NG+vy5A
	VvesVvylLAUzBMkDPUT+oqR0kHqELitkZmDkIpPNvpjp6Q5j1KrCdXopsh3LUVFSUmlgdZBajNz
	k8EEJ86q8=
X-Received: by 2002:a05:6808:221f:b0:44d:9f05:7159 with SMTP id 5614622812f47-45f1e45761fmr6662638b6e.29.1769993728719;
        Sun, 01 Feb 2026 16:55:28 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:9::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-40980497603sm8657293fac.21.2026.02.01.16.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:28 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 01/12] mm: add PUD THP ptdesc and rmap support
Date: Sun,  1 Feb 2026 16:50:18 -0800
Message-ID: <20260202005451.774496-2-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0ABC180004
X-Stat-Signature: 4k39yay8eakuty1n89qcqjtgpky5y85s
X-Rspam-User: 
X-HE-Tag: 1769993729-85561
X-HE-Meta: U2FsdGVkX18+5o4lAS1GAdzTvISvNM/pjXooWei2D/t2KSWKgnYTBU2uhQOEVesh+zU6HfH/MJAbt9gitOHTWQfZ0Z6+YoUTb1+6VXd7zreCsmE0JUPgqEHVpDlp58TCTgxPeAswYH8q2Ep2CzJo/a73qEnikoW007a0WxSn3FFj494d09S1HlglgnP1lIklYYKbGvDtF5WTpiUCc8wTfXOkYJ9TU4k1eW+wGCb2SJfI4KJsDmpw1Vs6cnuKDxxQTnEbUFlSX5pI4h7woo3Zj4SWmrl6M4ihKsfDUyQTDhPMYkqKD/yABcGDG2Qq1qyVK/5EsywE52fgkfXXdnodfmv8SQhp588tsCOxuw5wWTx9N7vV9jiceoQk4cRp8n8w5lTRTrq4F79SfeaKRJmRWY8YNDSpoInUdE3fJMDz7Ezh9jayH/G31RxZrAWIRPr3j1BWT9X070s+D0LpsiFMh6TaLIYhlf+4M2CGnImAfBeSVICahIBgioSHQEhS1r+mTscw3CcGP2zaOG3jBq6XloG2/U4co9NmIOvRkstJDsKXUV1HKVedeOcUXSBvyd7cvW26WlfE5i8c565YJoU8+pLt0EOmdg1PTlz9iEetl1Y+duI5t8R89gyANAk13csNMJ4+W6V9012cf4WQr9L9iH8LjvIbr0898dSrZny4NhyLLtXF/ZxinExUvroyZRlrvU2XeDFv+nFVkzVwINu8CJHLH3rnUWcAuo/nDL1r+VBXRPloUKNE2nKioKuv8fPJKgTGAunZYXTCLZvbKDLzOPithGKiGgxdrGF0CTSElyvtmXAImSWM3qVPYEoCRMmK1AHnb+qEJtqb3aUpCN6OO8NMeZpGrrZSzuBJJHr4co7LxTrRErmFwYHScGx8bHL+n/9fNKXw14si6L6dPP8/9eupNsXpOuihQ4WrCo89Wj/7BIZ5H3KEvrYU6gqyBkAFgAWOcKsBUqGjvxy80qd
 rbgdqlBw
 qMkZzT1mPXl3FfKvoBtZUnEopM2oTQnqxLiXR7fboO/Fnqzyos2y1wckaHg2TnXeXtEBumrUUF28BPdCV7gagcyVwdGcRZKHNWJgqQvGTIOEjSXbqiIMvACooebgfqZyzRt0RXgqbVjsJ4Hy4WhhIqA9aLn4iz6myLvjrDZ6RIfAy4QfmtfvOrtP640LjZC7HRX83GNkYNJgBXaBBLVk0oiWiBgsj/yQ32cZeV/h6CMzo+s57AdgqFzVAAqt2YtYnld3r7GtVsi0iUfXEPdDfCpexZqn95r+6J7c07k/EfggKEtwEwUSlGtrz3bf8DrZjBjYbna8DuqfE/KGsY750kpEDppnO6ISWWmsyOz2bH7NDOxart87oWhQJ1ZuVlnxPq68FS2EmCheNZPOQPiaydnnl0pzvVXVIRgZ2ZQGVcw83wgVtzRrJbxHw7mG/92GmvDIU4f+f0O78Y/mph+0S4L5Y56pVx8/L2zTC/CP6ubrMcHz51iV8Or8NH9QCHBGMFOyF3ufG0mSkTem7IeDfki/EVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For page table management, PUD THPs need to pre-deposit page tables
that will be used when the huge page is later split. When a PUD THP
is allocated, we cannot know in advance when or why it might need to
be split (COW, partial unmap, reclaim), but we need page tables ready
for that eventuality. Similar to how PMD THPs deposit a single PTE
table, PUD THPs deposit a PMD table which itself contains deposited
PTE tables - a two-level deposit. This commit adds the deposit/withdraw
infrastructure and a new pud_huge_pmd field in ptdesc to store the
deposited PMD.

The deposited PMD tables are stored as a singly-linked stack using only
page->lru.next as the link pointer. A doubly-linked list using the
standard list_head mechanism would cause memory corruption: list_del()
poisons both lru.next (offset 8) and lru.prev (offset 16), but lru.prev
overlaps with ptdesc->pmd_huge_pte at offset 16. Since deposited PMD
tables have their own deposited PTE tables stored in pmd_huge_pte,
poisoning lru.prev would corrupt the PTE table list and cause crashes
when withdrawing PTE tables during split. PMD THPs don't have this
problem because their deposited PTE tables don't have sub-deposits.
Using only lru.next avoids the overlap entirely.

For reverse mapping, PUD THPs need the same rmap support that PMD THPs
have. The page_vma_mapped_walk() function is extended to recognize and
handle PUD-mapped folios during rmap traversal. A new TTU_SPLIT_HUGE_PUD
flag tells the unmap path to split PUD THPs before proceeding, since
there is no PUD-level migration entry format - the split converts the
single PUD mapping into individual PTE mappings that can be migrated
or swapped normally.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 include/linux/huge_mm.h  |  5 +++
 include/linux/mm.h       | 19 ++++++++
 include/linux/mm_types.h |  5 ++-
 include/linux/pgtable.h  |  8 ++++
 include/linux/rmap.h     |  7 ++-
 mm/huge_memory.c         |  8 ++++
 mm/internal.h            |  3 ++
 mm/page_vma_mapped.c     | 35 +++++++++++++++
 mm/pgtable-generic.c     | 83 ++++++++++++++++++++++++++++++++++
 mm/rmap.c                | 96 +++++++++++++++++++++++++++++++++++++---
 10 files changed, 260 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index a4d9f964dfdea..e672e45bb9cc7 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -463,10 +463,15 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long address);
 
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
+			   unsigned long address);
 int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
 		    unsigned long cp_flags);
 #else
+static inline void
+split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
+		      unsigned long address) {}
 static inline int
 change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		pud_t *pudp, unsigned long addr, pgprot_t newprot,
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ab2e7e30aef96..a15e18df0f771 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3455,6 +3455,22 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
  * considered ready to switch to split PUD locks yet; there may be places
  * which need to be converted from page_table_lock.
  */
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline struct page *pud_pgtable_page(pud_t *pud)
+{
+	unsigned long mask = ~(PTRS_PER_PUD * sizeof(pud_t) - 1);
+
+	return virt_to_page((void *)((unsigned long)pud & mask));
+}
+
+static inline struct ptdesc *pud_ptdesc(pud_t *pud)
+{
+	return page_ptdesc(pud_pgtable_page(pud));
+}
+
+#define pud_huge_pmd(pud) (pud_ptdesc(pud)->pud_huge_pmd)
+#endif
+
 static inline spinlock_t *pud_lockptr(struct mm_struct *mm, pud_t *pud)
 {
 	return &mm->page_table_lock;
@@ -3471,6 +3487,9 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
 static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
 {
 	__pagetable_ctor(ptdesc);
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+	ptdesc->pud_huge_pmd = NULL;
+#endif
 }
 
 static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 78950eb8926dc..26a38490ae2e1 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -577,7 +577,10 @@ struct ptdesc {
 		struct list_head pt_list;
 		struct {
 			unsigned long _pt_pad_1;
-			pgtable_t pmd_huge_pte;
+			union {
+				pgtable_t pmd_huge_pte;  /* For PMD tables: deposited PTE */
+				pgtable_t pud_huge_pmd;  /* For PUD tables: deposited PMD list */
+			};
 		};
 	};
 	unsigned long __page_mapping;
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 2f0dd3a4ace1a..3ce733c1d71a2 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1168,6 +1168,14 @@ extern pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
 #define arch_needs_pgtable_deposit() (false)
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+extern void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
+					   pmd_t *pmd_table);
+extern pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp);
+extern void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable);
+extern pgtable_t pud_withdraw_pte(pmd_t *pmd_table);
+#endif
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 /*
  * This is an implementation of pmdp_establish() that is only suitable for an
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index daa92a58585d9..08cd0a0eb8763 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -101,6 +101,7 @@ enum ttu_flags {
 					 * do a final flush if necessary */
 	TTU_RMAP_LOCKED		= 0x80,	/* do not grab rmap lock:
 					 * caller holds it */
+	TTU_SPLIT_HUGE_PUD	= 0x100, /* split huge PUD if any */
 };
 
 #ifdef CONFIG_MMU
@@ -473,6 +474,8 @@ void folio_add_anon_rmap_ptes(struct folio *, struct page *, int nr_pages,
 	folio_add_anon_rmap_ptes(folio, page, 1, vma, address, flags)
 void folio_add_anon_rmap_pmd(struct folio *, struct page *,
 		struct vm_area_struct *, unsigned long address, rmap_t flags);
+void folio_add_anon_rmap_pud(struct folio *, struct page *,
+		struct vm_area_struct *, unsigned long address, rmap_t flags);
 void folio_add_new_anon_rmap(struct folio *, struct vm_area_struct *,
 		unsigned long address, rmap_t flags);
 void folio_add_file_rmap_ptes(struct folio *, struct page *, int nr_pages,
@@ -933,6 +936,7 @@ struct page_vma_mapped_walk {
 	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 	unsigned long address;
+	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
 	spinlock_t *ptl;
@@ -970,7 +974,7 @@ static inline void page_vma_mapped_walk_done(struct page_vma_mapped_walk *pvmw)
 static inline void
 page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
 {
-	WARN_ON_ONCE(!pvmw->pmd && !pvmw->pte);
+	WARN_ON_ONCE(!pvmw->pud && !pvmw->pmd && !pvmw->pte);
 
 	if (likely(pvmw->ptl))
 		spin_unlock(pvmw->ptl);
@@ -978,6 +982,7 @@ page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
 		WARN_ON_ONCE(1);
 
 	pvmw->ptl = NULL;
+	pvmw->pud = NULL;
 	pvmw->pmd = NULL;
 	pvmw->pte = NULL;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 40cf59301c21a..3128b3beedb0a 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2933,6 +2933,14 @@ void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 }
+
+void split_huge_pud_locked(struct vm_area_struct *vma, pud_t *pud,
+			   unsigned long address)
+{
+	VM_WARN_ON_ONCE(!IS_ALIGNED(address, HPAGE_PUD_SIZE));
+	if (pud_trans_huge(*pud))
+		__split_huge_pud_locked(vma, pud, address);
+}
 #else
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
 		unsigned long address)
diff --git a/mm/internal.h b/mm/internal.h
index 9ee336aa03656..21d5c00f638dc 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -545,6 +545,9 @@ int user_proactive_reclaim(char *buf,
  * in mm/rmap.c:
  */
 pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address);
+#endif
 
 /*
  * in mm/page_alloc.c
diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
index b38a1d00c971b..d31eafba38041 100644
--- a/mm/page_vma_mapped.c
+++ b/mm/page_vma_mapped.c
@@ -146,6 +146,18 @@ static bool check_pmd(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
 	return true;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+/* Returns true if the two ranges overlap.  Careful to not overflow. */
+static bool check_pud(unsigned long pfn, struct page_vma_mapped_walk *pvmw)
+{
+	if ((pfn + HPAGE_PUD_NR - 1) < pvmw->pfn)
+		return false;
+	if (pfn > pvmw->pfn + pvmw->nr_pages - 1)
+		return false;
+	return true;
+}
+#endif
+
 static void step_forward(struct page_vma_mapped_walk *pvmw, unsigned long size)
 {
 	pvmw->address = (pvmw->address + size) & ~(size - 1);
@@ -188,6 +200,10 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 	pud_t *pud;
 	pmd_t pmde;
 
+	/* The only possible pud mapping has been handled on last iteration */
+	if (pvmw->pud && !pvmw->pmd)
+		return not_found(pvmw);
+
 	/* The only possible pmd mapping has been handled on last iteration */
 	if (pvmw->pmd && !pvmw->pte)
 		return not_found(pvmw);
@@ -234,6 +250,25 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
 			continue;
 		}
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+		/* Check for PUD-mapped THP */
+		if (pud_trans_huge(*pud)) {
+			pvmw->pud = pud;
+			pvmw->ptl = pud_lock(mm, pud);
+			if (likely(pud_trans_huge(*pud))) {
+				if (pvmw->flags & PVMW_MIGRATION)
+					return not_found(pvmw);
+				if (!check_pud(pud_pfn(*pud), pvmw))
+					return not_found(pvmw);
+				return true;
+			}
+			/* PUD was split under us, retry at PMD level */
+			spin_unlock(pvmw->ptl);
+			pvmw->ptl = NULL;
+			pvmw->pud = NULL;
+		}
+#endif
+
 		pvmw->pmd = pmd_offset(pud, pvmw->address);
 		/*
 		 * Make sure the pmd value isn't cached in a register by the
diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
index d3aec7a9926ad..2047558ddcd79 100644
--- a/mm/pgtable-generic.c
+++ b/mm/pgtable-generic.c
@@ -195,6 +195,89 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+/*
+ * Deposit page tables for PUD THP.
+ * Called with PUD lock held. Stores PMD tables in a singly-linked stack
+ * via pud_huge_pmd, using only pmd_page->lru.next as the link pointer.
+ *
+ * IMPORTANT: We use only lru.next (offset 8) for linking, NOT the full
+ * list_head. This is because lru.prev (offset 16) overlaps with
+ * ptdesc->pmd_huge_pte, which stores the PMD table's deposited PTE tables.
+ * Using list_del() would corrupt pmd_huge_pte with LIST_POISON2.
+ *
+ * PTE tables should be deposited into the PMD using pud_deposit_pte().
+ */
+void pgtable_trans_huge_pud_deposit(struct mm_struct *mm, pud_t *pudp,
+				    pmd_t *pmd_table)
+{
+	pgtable_t pmd_page = virt_to_page(pmd_table);
+
+	assert_spin_locked(pud_lockptr(mm, pudp));
+
+	/* Push onto stack using only lru.next as the link */
+	pmd_page->lru.next = (struct list_head *)pud_huge_pmd(pudp);
+	pud_huge_pmd(pudp) = pmd_page;
+}
+
+/*
+ * Withdraw the deposited PMD table for PUD THP split or zap.
+ * Called with PUD lock held.
+ * Returns NULL if no more PMD tables are deposited.
+ */
+pmd_t *pgtable_trans_huge_pud_withdraw(struct mm_struct *mm, pud_t *pudp)
+{
+	pgtable_t pmd_page;
+
+	assert_spin_locked(pud_lockptr(mm, pudp));
+
+	pmd_page = pud_huge_pmd(pudp);
+	if (!pmd_page)
+		return NULL;
+
+	/* Pop from stack - lru.next points to next PMD page (or NULL) */
+	pud_huge_pmd(pudp) = (pgtable_t)pmd_page->lru.next;
+
+	return page_address(pmd_page);
+}
+
+/*
+ * Deposit a PTE table into a standalone PMD table (not yet in page table hierarchy).
+ * Used for PUD THP pre-deposit. The PMD table's pmd_huge_pte stores a linked list.
+ * No lock assertion since the PMD isn't visible yet.
+ */
+void pud_deposit_pte(pmd_t *pmd_table, pgtable_t pgtable)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
+
+	/* FIFO - add to front of list */
+	if (!ptdesc->pmd_huge_pte)
+		INIT_LIST_HEAD(&pgtable->lru);
+	else
+		list_add(&pgtable->lru, &ptdesc->pmd_huge_pte->lru);
+	ptdesc->pmd_huge_pte = pgtable;
+}
+
+/*
+ * Withdraw a PTE table from a standalone PMD table.
+ * Returns NULL if no more PTE tables are deposited.
+ */
+pgtable_t pud_withdraw_pte(pmd_t *pmd_table)
+{
+	struct ptdesc *ptdesc = virt_to_ptdesc(pmd_table);
+	pgtable_t pgtable;
+
+	pgtable = ptdesc->pmd_huge_pte;
+	if (!pgtable)
+		return NULL;
+	ptdesc->pmd_huge_pte = list_first_entry_or_null(&pgtable->lru,
+							struct page, lru);
+	if (ptdesc->pmd_huge_pte)
+		list_del(&pgtable->lru);
+	return pgtable;
+}
+#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
+
 #ifndef __HAVE_ARCH_PMDP_INVALIDATE
 pmd_t pmdp_invalidate(struct vm_area_struct *vma, unsigned long address,
 		     pmd_t *pmdp)
diff --git a/mm/rmap.c b/mm/rmap.c
index 7b9879ef442d9..69acabd763da4 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -811,6 +811,32 @@ pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address)
 	return pmd;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+/*
+ * Returns the actual pud_t* where we expect 'address' to be mapped from, or
+ * NULL if it doesn't exist.  No guarantees / checks on what the pud_t*
+ * represents.
+ */
+pud_t *mm_find_pud(struct mm_struct *mm, unsigned long address)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud = NULL;
+
+	pgd = pgd_offset(mm, address);
+	if (!pgd_present(*pgd))
+		goto out;
+
+	p4d = p4d_offset(pgd, address);
+	if (!p4d_present(*p4d))
+		goto out;
+
+	pud = pud_offset(p4d, address);
+out:
+	return pud;
+}
+#endif
+
 struct folio_referenced_arg {
 	int mapcount;
 	int referenced;
@@ -1415,11 +1441,7 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
 			SetPageAnonExclusive(page);
 			break;
 		case PGTABLE_LEVEL_PUD:
-			/*
-			 * Keep the compiler happy, we don't support anonymous
-			 * PUD mappings.
-			 */
-			WARN_ON_ONCE(1);
+			SetPageAnonExclusive(page);
 			break;
 		default:
 			BUILD_BUG();
@@ -1503,6 +1525,31 @@ void folio_add_anon_rmap_pmd(struct folio *folio, struct page *page,
 #endif
 }
 
+/**
+ * folio_add_anon_rmap_pud - add a PUD mapping to a page range of an anon folio
+ * @folio:	The folio to add the mapping to
+ * @page:	The first page to add
+ * @vma:	The vm area in which the mapping is added
+ * @address:	The user virtual address of the first page to map
+ * @flags:	The rmap flags
+ *
+ * The page range of folio is defined by [first_page, first_page + HPAGE_PUD_NR)
+ *
+ * The caller needs to hold the page table lock, and the page must be locked in
+ * the anon_vma case: to serialize mapping,index checking after setting.
+ */
+void folio_add_anon_rmap_pud(struct folio *folio, struct page *page,
+		struct vm_area_struct *vma, unsigned long address, rmap_t flags)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	__folio_add_anon_rmap(folio, page, HPAGE_PUD_NR, vma, address, flags,
+			      PGTABLE_LEVEL_PUD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 /**
  * folio_add_new_anon_rmap - Add mapping to a new anonymous folio.
  * @folio:	The folio to add the mapping to.
@@ -1934,6 +1981,20 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 		}
 
 		if (!pvmw.pte) {
+			/*
+			 * Check for PUD-mapped THP first.
+			 * If we have a PUD mapping and TTU_SPLIT_HUGE_PUD is set,
+			 * split the PUD to PMD level and restart the walk.
+			 */
+			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
+				if (flags & TTU_SPLIT_HUGE_PUD) {
+					split_huge_pud_locked(vma, pvmw.pud, pvmw.address);
+					flags &= ~TTU_SPLIT_HUGE_PUD;
+					page_vma_mapped_walk_restart(&pvmw);
+					continue;
+				}
+			}
+
 			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
 				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
 					goto walk_done;
@@ -2325,6 +2386,27 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 	mmu_notifier_invalidate_range_start(&range);
 
 	while (page_vma_mapped_walk(&pvmw)) {
+		/* Handle PUD-mapped THP first */
+		if (!pvmw.pte && !pvmw.pmd) {
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+			/*
+			 * PUD-mapped THP: skip migration to preserve the huge
+			 * page. Splitting would defeat the purpose of PUD THPs.
+			 * Return false to indicate migration failure, which
+			 * will cause alloc_contig_range() to try a different
+			 * memory region.
+			 */
+			if (pvmw.pud && pud_trans_huge(*pvmw.pud)) {
+				page_vma_mapped_walk_done(&pvmw);
+				ret = false;
+				break;
+			}
+#endif
+			/* Unexpected state: !pte && !pmd but not a PUD THP */
+			page_vma_mapped_walk_done(&pvmw);
+			break;
+		}
+
 		/* PMD-mapped THP migration entry */
 		if (!pvmw.pte) {
 			__maybe_unused unsigned long pfn;
@@ -2607,10 +2689,10 @@ void try_to_migrate(struct folio *folio, enum ttu_flags flags)
 
 	/*
 	 * Migration always ignores mlock and only supports TTU_RMAP_LOCKED and
-	 * TTU_SPLIT_HUGE_PMD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
+	 * TTU_SPLIT_HUGE_PMD, TTU_SPLIT_HUGE_PUD, TTU_SYNC, and TTU_BATCH_FLUSH flags.
 	 */
 	if (WARN_ON_ONCE(flags & ~(TTU_RMAP_LOCKED | TTU_SPLIT_HUGE_PMD |
-					TTU_SYNC | TTU_BATCH_FLUSH)))
+					TTU_SPLIT_HUGE_PUD | TTU_SYNC | TTU_BATCH_FLUSH)))
 		return;
 
 	if (folio_is_zone_device(folio) &&
-- 
2.47.3


