Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D530606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ZW1gGc+m
Received: by kanga.kvack.org (Postfix)
	id 8A1AE6B05B9; Mon, 23 Nov 2026 00:36:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A8D6B05BA; Mon, 23 Nov 2026 00:36:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71ACB6B05BB; Mon, 23 Nov 2026 00:36:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42EBF6B05B9
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87F93407EE
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:21 +0000 (UTC)
X-FDA: 85465273362.16.6F3B630
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id C233FC0008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZW1gGc+m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412180;
	b=ODWxPyALZ7vaZi9AONxIYap5S1CvML8Ksfa3GAG1UdPsZeE2VTQk7tQtPdD7zJq/UozcFI
	Es3Qk6xPS9lxdRzqbdq5gHdHOE6YHCS7ofjVfLKFESeB8vr3ymmb9FR1dHTTXz/uPVXRyC
	AaU0hBfq0xEscLpWUeR42vwQWP6uMqY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xg8YZ8p+TkRwUgTmewIihPwbZly9Da4auRWQMv/tzLY=;
	b=tA/dNnjT0utpyjmdfGiYZEpWZaXEZNwbODyTMeEawWq2CBUJ6TGWLxmiRdSDL5HHjhFT1p
	1JU52WFPXtge0pyQuzUrQqZfS51TU6mBUXjYeVa3NtWM0O0JHiQFk/abRMnT5XvUPRLsBG
	4EdK+vZ1dVEFx3LpZZBO8Dc05ryRH5s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZW1gGc+m;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8D091476;
	Sun, 22 Nov 2026 21:36:15 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 281843F632;
	Sun, 22 Nov 2026 21:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412178; bh=evAM/edRrXuRZTUvGCLG+8YoxwPE0dWkSoAKDM0Q+xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZW1gGc+mD7W2YsWPMN1s+atua4dsgCMxQY0pdLMKNTmkTKEMSSeZl8aerTcna1HyJ
	 IiXqZDw0IBLFMmjgTx6KAJb4PyRqjIM1TaOnfP5n26e8ab8SPG/jshxigymcPaSvcL
	 hDaEVK/QKrU/6/yYyj6e9Y7Xp2TZ5gP7ilBOfROc=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 3/8] mm: move anon-exclusive batch helper to rmap.h
Date: Mon, 23 Nov 2026 05:35:37 +0000
Message-ID: <20261123053543.295467-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C233FC0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3c18yx5zq51cwb788txmhde4j6p5ci3k
X-HE-Tag: 1795412179-888135
X-HE-Meta: U2FsdGVkX18gIB7kAxkdI0fiN3xmtseskVJxUXz10LzyMg6OtHuDemLiBurzTy7APdjvdvjdFbSmQzonx5m2yNiCdvJ91YfxeNAZl+waA5s4H8xFQsWrczSCLhqJyWR7WPz2LKd0TMwWbmBEb2qTZn/qZ4tdDIoVE70rN/GMFTi4kDhyLAmhuhS5wEy42Cm36xOhUy6DfZcH9UVWXA5QFHLXlZcK+HDjcoAb3QhmRhQpyEs1xhSRL48iLtAoEZHxnYg0DA2fuqmN64JS4lTeBqMCoXxF/v4HuK7skRbxpx8FTF+bC9Mivq52LVLyvNGm41TR/zOAUdg1gMayaT7eKdyQyFBty1t56hMV88aGRExTSONCDWCJ3hgUSWH1j0XOEa+BYx0nsHYHEvYB7iaphe34sT2Oq52dZzxOPWKqgjOk0l92Pljeufw1/H58pPFiXPisi8XFOSPiRlqA0u+T/2m7LNNT1uqxK93e76l59BwjZoJpxutzoj8O8hT2gSF5e+ha1ids8AT00raG5CMJBvOiLplOhzTxpqbVB+0ZLtWMfwWJuPR9yETHksr+U+zMO53VIz7uHF9UVnOVtgoMJiMa2h6FlGNu8nY20j1QnO+cFtK8ia5VJ18YplxbqiKhCFOD8fV2R6emglqDIgc/drXfOWc38Dr4qyWsgOtFgjwHp9KgcQzXK695wP+ea6JzWrW6B5YSdk2wYr4QsZltiD20okgEPj0ho6ja/8vvCkdS/1yQQZGyAMbD3ym6BH3JUWtx8oZ71gsI3aXYSzYjac0u2xUlnsK/ySeJR1EdY3/I4cBnq5R65u2qj0ZA3G/5OZEX935ZzRDdUbksLIdYW4z4gNinr5xJFZtrAdetPAHixSSNIsv9NrQEhftNx7huOgE/JDAQblYCvJpkq5XMTMgButKCTjNAwNi/4BqzQUSk75wO8n40y9PClTSk++umecmrEoSo9zKUIOl+oqG
 X54JvoKg
 wrUr2djDf8cfaMeF3M/AUszJIBHlEa/l73eB5AfQ6t+LcuHq4qFbWHsMQKxz0cYa1Ew600Am1bJvf5neHwzbQTgxvGQudGnPcPQyVvWIGwV2jhxUtYuRAHRZCEY9OwE0CDfhYzi9xyCtxeU2div5XYoJbRlUARVrcabLLWLyUyPyQtwU0EihR67rvMdHAL/UFvos01rPPCk1uYuY3cMCmqYaG3z3IHKKQi5zzLYqam+JMc+BqW4YEfAhLuEsmbDLwQ69YWA/3F9hgJsDNx08p/Rk2g+kMgo1U66HecWx+tkWgkS2jiIvAVoDO1MQe+b4ij3I9ec4ifKrq8pEs5NTyRPqyrFLAsRwVfaJD4Uyu9k3oliuqRhm4NFU5d4o40E6KOins11R5XxBcYQMpKntCk8VXwPdbnLp5N+2f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation for optimizing large folio unmapping, we need to reuse
the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
existing use in mprotect.c .

Therefore, move it from mprotect.c to rmap.h.

While at it, change return type, start_idx and max_len to unsigned long
type for future proofing against THP support at >= PUD level. Also
make the helper return the anon-exclusivity state through an output parameter.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 18 ++++++++++++++++++
 mm/mprotect.c        | 25 ++++---------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 9f5bfa317a5c..ec1e85855be1 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -106,6 +106,24 @@ enum ttu_flags {
 
 #ifdef CONFIG_MMU
 
+/*
+ * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
+ * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
+ * that the PTEs point to consecutive pages of the same anon large folio.
+ */
+static __always_inline unsigned long page_anon_exclusive_batch(unsigned long start_idx,
+		unsigned long max_len, struct page *first_page, bool *exclusive)
+{
+	unsigned long idx;
+
+	*exclusive = PageAnonExclusive(first_page + start_idx);
+	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
+		if (*exclusive != PageAnonExclusive(first_page + idx))
+			break;
+	}
+	return idx - start_idx;
+}
+
 void anon_vma_init(void);	/* create anon_vma_cachep */
 
 #ifdef CONFIG_MM_ID
diff --git a/mm/mprotect.c b/mm/mprotect.c
index e18d4e12fc34..00ae73284907 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -30,6 +30,7 @@
 #include <linux/mm_inline.h>
 #include <linux/pgtable.h>
 #include <linux/userfaultfd_k.h>
+#include <linux/rmap.h>
 #include <uapi/linux/mman.h>
 #include <asm/cacheflush.h>
 #include <asm/mmu_context.h>
@@ -138,23 +139,6 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
 		tlb_flush_pte_range(tlb, addr, nr_ptes * PAGE_SIZE);
 }
 
-/*
- * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
- * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
- * that the ptes point to consecutive pages of the same anon large folio.
- */
-static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
-		struct page *first_page, bool expected_anon_exclusive)
-{
-	int idx;
-
-	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
-		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
-			break;
-	}
-	return idx - start_idx;
-}
-
 /*
  * This function is a result of trying our very best to retain the
  * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
@@ -173,16 +157,15 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
-	bool expected_anon_exclusive;
+	bool exclusive;
 	int batch_idx = 0;
 	int len;
 
 	while (nr_ptes) {
-		expected_anon_exclusive = PageAnonExclusive(first_page + batch_idx);
 		len = page_anon_exclusive_batch(batch_idx, nr_ptes,
-					first_page, expected_anon_exclusive);
+					first_page, &exclusive);
 		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
-				       batch_idx, expected_anon_exclusive, tlb);
+				       batch_idx, exclusive, tlb);
 		batch_idx += len;
 		nr_ptes -= len;
 	}
-- 
2.43.0


