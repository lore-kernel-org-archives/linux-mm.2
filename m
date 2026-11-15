Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F138606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dnLp+SXf
Received: by kanga.kvack.org (Postfix)
	id 298496B05B8; Sun, 15 Nov 2026 09:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FAD6B05BA; Sun, 15 Nov 2026 09:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 186716B05BB; Sun, 15 Nov 2026 09:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EBD456B05B8
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:39:47 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 790451C416C
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:47 +0000 (UTC)
X-FDA: 85437612414.27.30AAB61
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id B60161A0008
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:39:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dnLp+SXf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794753585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C36S7WPR2YYhjD8S8SUsmlfuQc7R28qqteWGQjqPDCE=;
	b=ApnIDgzmCNWyPIMXf/rnzoFn3Ip3sYgDeKqO6zJx5b+2+/xlTGtt6ImPLQNEIU57Y1SXhn
	Znob+XwkQHc8A32tTDM91/KgUX7D3FS46tyz7MrctcAylz4n8NgsM7sU2f4CXNI5ji2tqE
	30KoMZ9kzKXLs3NwsOn1nzLX09zT7Gw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dnLp+SXf;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794753586;
	b=kjJbIaert+4puFBKaUh4OCztpSnmYIrA/Gpl/TA77X2JoSpCIUsxPSd0sdUz6fzp3lehEf
	HiPfReAcTd+ufx0DSEiULYWJEOPpP7XoWMF/SymcaUn/+4orDA494IQM2K2jZqxrKneaWz
	JoUt0i977x30PLakeXv1dMH2dzmmOJM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DFEC1516;
	Sun, 15 Nov 2026 06:39:41 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BAFDA3F85F;
	Sun, 15 Nov 2026 06:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794753584; bh=JAPamEnS0a1chQgUFkxhCVz/QqaVzoGJWTMnsu0MSow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnLp+SXfNe4kywfpAolf/jEON84hcyW8iFL+ACGxEpijlA0N0hB5cRN8/ArQfUW0Q
	 RalspDqSzsvjkb77Pr9FPhItI4XX8gA7mpwpvLNnqCOrwbroFM/mNG2MiosTgd1tmr
	 Bz03LvLUtHNkUsz0MTwEBeQvEbUI6lX/KgVT2tfA=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
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
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	anshuman.khandual@arm.com,
	geert@linux-m68k.org,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v4 3/9] mm: move anon-exclusive batch helper to rmap.h
Date: Sun, 15 Nov 2026 14:38:58 +0000
Message-ID: <20261115143905.3045084-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261115143905.3045084-1-dev.jain@arm.com>
References: <20261115143905.3045084-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B60161A0008
X-Stat-Signature: qi4ysiawapgumdwo4x5ui7n39jcimm9n
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794753585-967064
X-HE-Meta: U2FsdGVkX1/tE4NkMCrCD2B8JhtIKL6F4YFpmuv2iAFEmZLTWUqseMS+y33rPFcJL5bROUi4vKE3hRMt0OVXbXcZsbQYAxfnr4mjitcSp2BVF+ZeU7qoP9ROTkGIVrBFOnDDLTNaE+Go+/xDqvojJMjsRK0RiZPEojnDMrOeU+RMhvtaRbLWJGoCubGWNamSy0xHy36jUtcIxbijDnlxNot4bwdDiDixUNz+HZJHdW/Z8oSPlRZ+y0TS+ZbJOgfTMtP3dZK4q73HK/DgAAJFdzlJanX21ZqW/BiMGb0aoeeqMxF5gvDNE5bpHiu88ZwPPG7Mvg8I86t3KIZOz57sLoJJn1ezgazXiG5MZvQgwZLs7+1lXZ4I5ZKhsI2sScEJqwBmqZYA4bB8H8z/1DxNW8waUDhK6jRovrrdwqEJ+NpxD9mVIgzlOTxbuOYQyauU7ZQtsYV0aTap8aWis0U6DNvVrVrSjmbVMn0u90gp512eoPcbU91sNqDJntRCr3mguPD+/NKxWDoR4LPN1R3jRNHxJOXF6Tg7IFup7FcZm4yOorRUIXN55plmk+dCCeKDXrSahv3cqkCFuo1oWhDPsHcFVOgN85NWjyQbFfaaGqYsdYvYRDa1We0apBFdi03GJaf+xLLQWq24Xkgvz+E9d6LMBUe8hjVsfv1seBu7IkiTIY4m9Nbj1RU/dI2W4ws7cmXYFVKaetLibMYLa+/476frZ2zE3+Idszfie+vT/q4S2ckZBVXd/+73Q5Ky+8BRKnTN1+9fmXoC2seI/8VYa9MQmOXrm0teFSowbnfl8P+ypL4TDwZ2M7yUjIDo419hg1nlGnrJ5BFHO3kkeKyAXT67KAyJBF6tv58QDCeUCnD7ZueLky0otEhb0e+gogmBlnqoMoKg/IyXCs8nmh7bf/G71q+w98HfBy/Avwq5CKEu4ZCgldIQPGchrD2HHTEFy/4ZBG9/xHx5aXcoWcP
 /N/Wf5ZM
 utREIJZ0m5XWQCJS3rrXU1raHkRf3+xR4zJa3IRjrITQ0pJSig+uDkgsuk3gPLu78N0lfY+jHcpVWa7sesPjPMt8G/6vVyaUbvziWBaVDiihhHI0an6T03PNB7y6Uq6IjR+F/SofHXICGjgxyc9fOVfrJSrOMRcLncIOdnKkkrtzuBYdGwgzhX0MaQUlrhi3Chgv9XOK7pNTR4eHhppEOyXRZBEVFHU4IOe9RMeHSmOr/HONXdCVkxEGCtLesHCFPaLZqqyp8cR8gnpw=
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
make the helper return the anon-exclusivity state via a pointer parameter.

Shorten 'expected_anon_exclusive' to exclusive for brevity.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 18 ++++++++++++++++++
 mm/mprotect.c        | 25 ++++---------------------
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c7264..43d6bbecd2fab 100644
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
index ef4e7188e24da..0048a2406ed34 100644
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


