Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 026A51077617
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62EBB6B0320; Wed, 18 Mar 2026 16:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606396B0322; Wed, 18 Mar 2026 16:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543AE6B0323; Wed, 18 Mar 2026 16:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 442006B0320
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:40:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D3951C185
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:10 +0000 (UTC)
X-FDA: 84560350980.02.C574D8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4DBA51C000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:40:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zu1L7gfj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773866408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKoXCGTFrjKR9YQhKRVyfzAYO0ptqFTZGCMe35oRCSI=;
	b=YNBnjIGJKck62W4D8dAVDYanBfw9V6e72GtPZybiqabi3q5NRPcYaBzpDxII5SBSdOyaPa
	nHb3gxP+9NcWupcfbS1n9eDTAXAkiZmQmkX9vNVQt4PYgyWXVWsCnOl3A6hv2osmhKKSrj
	BsqxEJRzGdLv1N0n0N+4IdjcsGpsYcU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773866408; a=rsa-sha256;
	cv=none;
	b=H16o/ng4zv3fKg4VY42G2eV6VSG4RKmCbl5/DZ9iHKzzLXo5UQPchjxvoJLmlCU554oux7
	IhSY9SCmpLek2mdV4tqv2ojgPCItrT4RrF3w/++fHqjxjly2lATn45WwYw4AfVtbz9hNN/
	mzWZCiNKuWKgrIR65qYchGTtj9jQB/I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zu1L7gfj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5806B43B19;
	Wed, 18 Mar 2026 20:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE49C19424;
	Wed, 18 Mar 2026 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773866407;
	bh=7Zih2Kv0Dm+TrjDetzDdmQ+LGnrh29EyXLjilJ0KrRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zu1L7gfjbQFmjKt1J6VBjQ1d7W1ZUN6DCgHduL35Q1r56dv5jtqd2SVAdmtF8MenG
	 UHmbv21UlczDU7YSEwXY4glnWufkHg3qNjRue1ZXCNLeMm7XBHznw+zHQQ+7e2OBUM
	 SEhwFoK1SsEFnsbV9g+f7RD9tfkblSAKHKEEYETGWUfAm85p+PSEpWo6jkad3xNWnD
	 CI/LqRjVQuWEND/quhDHS5654NtqaL6cO+mLZkLZy52stB7CD9IWO+/y9XsJNKKFA0
	 9yHinYu2OigIAOOyta9aZaOCrL19O2Bo57nsBfsD1SkX2mZS8F5njyknLQ/9vmy9wP
	 FIgyWXKZuhfcA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
Date: Wed, 18 Mar 2026 20:39:25 +0000
Message-ID: <20e00d784adf1540c32b46024a709dfe1be93019.1773865827.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773865827.git.ljs@kernel.org>
References: <cover.1773865827.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4DBA51C000C
X-Stat-Signature: j5zd785ptknbkj5iu6kdo3recfmbyjo4
X-Rspam-User: 
X-HE-Tag: 1773866407-726650
X-HE-Meta: U2FsdGVkX18U4RkJGC8m7MuHqe/WhFkHW1RiJ/zlMwHGaC0Gqgj7AakQr72kpaHWxAHDNkLVtJSFBXpWJgw961BXtO84Ie0YnUAyXBJl7oyowz2ZBtPFlH96FfkJTYevgZsjouD7ZCKUQySbenJBR8jOtSp651GNud1nVuB3/Uzm+NKLyGBx1D0bl4Jzc0dtS5n4ItQgk92QqxgwJ6WnCrzyIYe64As2MAz8rUXQoizclzco3PQ1/23qPp1fzqra1piHwlSsBHpp/6aJtA8rrD6BAm0ur8FPQTA18dJXr+mw8rfhHXPpBJROjgTkkTH4YZ2gWx2ugHc6+bu+xmCD2D+5Dhc20Of1P/0xHFTLDjduAv19wb4sVQvkNFqMo6DDj2mqdNQ/B1VzYo4M+lZqG48tNhYuqV0J/r0WqWhIJPWbblzl0lmdZtL0ve6xEChNQ0GZi8H1oYNaf/aZPvftqa4j7+deTbDFo8BcKyEUUcae+BJTANYEUNXXiDSgXxpX/om4XuBl0nppRmCVy4vVgbBjuskexGNPQjrFZwRT66fkmenX8zdaAchoyGMAAL+KqLrZjnl9xJHo96izx587x4JDT88HzyHbIzgpbMhBRG0/09U17SOo4g9jwPzegTL/2R5zAbav/ThC0AXNF62W0lsdy9VXOoxifqsGGH0BkdsWhYzkRJhnyZgY7mBo9j5qEHogME1L6Am6QMnimNKfvQxMnGX/t9MKFW6aC6tUKa331tJ1t9MxIs17yFV5TsYU8wORV8V0A7ddbuMqL20sOwBEcfQxZQBEqYXRbJNZigmOlpdK3zDywZzgQK/NrQL/1yIPpYGppSAdYd1BjKqIGz+diNQTNsJuCtjctwtd19p3uqh/H/TTuxWhfN48fL13mEkPMDp/l+ngN8IofOd7EOUxiIHtoSWOapmr3Z6dQJSNiJMQFhye4R1ecUi0KykeW8zEfq5pbZQoBqHys+g
 tNHybFMg
 g1Trqd+n93nsI/6OYI3JZqMaXk66cBuuRY20mE4E6AxN4KwYhQdZs8FLdWO6fZhkjJlvZXqoUT3n9w2IM4GFdP8coKuXKEnkz46/EwgAZFWQQnU8mMNlT2DeSCsDtPCDU9nAXKNltvu3aBmQ4AJmJDjhFhy064+vw7hae5vpQkc+NGArTFF/zqMPIMcUJskrbnm5XgGzx6PBjCNtCrvNfykz6MxVn+RhFIDlvqmHwyu9quTspJYJusUh8R+pL9h4VqvXuqTThXIy5N6ayfFujYFQ39u0P0m7wkWKS9vE8V/vMuzdTe23XRU2qEOcmNqcfZ4qj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's no need to use the ancient approach of returning an integer here,
just return a boolean.

Also update flush_needed to be a boolean, similarly.

Also add a kdoc comment describing the function.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/huge_mm.h |  4 ++--
 mm/huge_memory.c        | 23 ++++++++++++++++-------
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 61fda1672b29..2949e5acff35 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -27,8 +27,8 @@ static inline void huge_pud_set_accessed(struct vm_fault *vmf, pud_t orig_pud)
 vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf);
 bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			   pmd_t *pmd, unsigned long addr, unsigned long next);
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
-		 unsigned long addr);
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma, pmd_t *pmd,
+		  unsigned long addr);
 int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma, pud_t *pud,
 		 unsigned long addr);
 bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4ebe1f19341e..bba1ba1f6b67 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2418,11 +2418,20 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 	mm_dec_nr_ptes(mm);
 }
 
-int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
+/**
+ * zap_huge_pmd - Zap a huge THP which is of PMD size.
+ * @tlb: The MMU gather TLB state associated with the operation.
+ * @vma: The VMA containing the range to zap.
+ * @pmd: A pointer to the leaf PMD entry.
+ * @addr: The virtual address for the range to zap.
+ *
+ * Returns: %true on success, %false otherwise.
+ */
+bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		 pmd_t *pmd, unsigned long addr)
 {
 	struct folio *folio = NULL;
-	int flush_needed = 1;
+	bool flush_needed = true;
 	spinlock_t *ptl;
 	pmd_t orig_pmd;
 
@@ -2430,7 +2439,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	ptl = __pmd_trans_huge_lock(pmd, vma);
 	if (!ptl)
-		return 0;
+		return false;
 	/*
 	 * For architectures like ppc64 we look at deposited pgtable
 	 * when calling pmdp_huge_get_and_clear. So do the
@@ -2445,13 +2454,13 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		if (arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 	if (is_huge_zero_pmd(orig_pmd)) {
 		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
 			zap_deposited_table(tlb->mm, pmd);
 		spin_unlock(ptl);
-		return 1;
+		return true;
 	}
 
 	if (pmd_present(orig_pmd)) {
@@ -2465,7 +2474,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
 
 		folio = softleaf_to_folio(entry);
-		flush_needed = 0;
+		flush_needed = false;
 
 		if (!thp_migration_supported())
 			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
@@ -2499,7 +2508,7 @@ int zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (flush_needed)
 		tlb_remove_page_size(tlb, &folio->page, HPAGE_PMD_SIZE);
 
-	return 1;
+	return true;
 }
 
 #ifndef pmd_move_must_withdraw
-- 
2.53.0


