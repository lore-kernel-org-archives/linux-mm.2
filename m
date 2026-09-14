Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3222FC88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C71036B00B3; Mon, 14 Sep 2026 08:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20606B00B4; Mon, 14 Sep 2026 08:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B10AC6B00B5; Mon, 14 Sep 2026 08:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B6BA6B00B3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 055B6A03BD
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:55 +0000 (UTC)
X-FDA: 85212304590.28.6AD51FA
Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1A6AE20002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYkgoaU6;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389113;
	b=YHL0TpzSg/hyHq1jn7DOGVzZDkUuhaIv7XzdGJAUQDWBurXbuaYR3DaJWOkDgKBW3Vt6dl
	R77+kh5T1Rts2DyMT+yG7rQF5cXUqPn5V7qOIHE51X00D/E1zPNXhDlFvE502E1LT2ySp2
	ZU5znBQmc+HoEJB88PpoZXSojTRZgnM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wYkgoaU6;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.204 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/8814UUb7nPWW5EYEi9qWSuk/aQ05KG/PNfJy5mlq8=;
	b=7/CDE1tbn9Kyr3+XeIhyYd54mFmaHJW2EYcmJKUsNWsnSbr5FhMsu6h7+yU///ieuWfWtl
	MuwD4g8FuEKulLLD9/D+JWCJ736zmoybnPmSAhm596yhK//fPGlZPPdxNNSOalJi2ZoUxv
	oaCHqvalqH5nyh3dNkbh8F/GzNUiyCo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/ejeggqsmQIRp7dTYKNmiDe/IHY+KtxEWhGqQu4hgx0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389111; v=1; x=1789993911;
 b=wYkgoaU6E5G+HaUCCWoMRD0G+hvaRhMRpHrtg9TjsUc6zCTZzOct0TXfW5BPTZMA1XL77uQy
 O47QyFA2eba+hZFkLy4q+eXKrkupn8ikqW5s2cAnnZfuRFeUQ9B7/PdH+5rAWIsgtk+2PP4UTjo
 EK3hqej8a0Nf9AP32BKNHcEg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 00067274d6bc2178;
	Mon, 14 Sep 2026 12:31:51 +0000
X-Mizu-Trace-ID: 00067274d6bc2178
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 19/29] mm/madvise: free PMD swap entries with MADV_FREE
Date: Mon, 14 Sep 2026 05:28:09 -0700
Message-ID: <20260914122950.3283997-20-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A6AE20002
X-Rspam-User: 
X-Stat-Signature: pxueopc5octjcr3y5xp7ng1w381xu94s
X-HE-Tag: 1789389112-617482
X-HE-Meta: U2FsdGVkX1+UJ8dzWLajSgoNkx3dkqLlRJaF7SV3BYKdjMX5Xm41s2/3iHvCgC2Y23KZu8+xOTX7QSOsIPCXhlkXLU8lIU9ClzKQ2TmWe/0dPOt2C666IAB6W1ToB52QoZmaRh541VxLjJbO18x/VXWr5VOF8G7kYOuEOmRLZoP0fR5+B6wEFHC2BG1sSYkKhcEKCv0CN/SqL6A2c9N+zhksiViJaQPqEpIg1oqbBY0tgVeVNtZullVR7naQxAWZKheBsKbosLe45b5cDuswquZTupOoytCeAfkXh9/5j9P9HWx7adFUaYW4rjv53+oG733fEAItJhgaYFzcFR8uWT/lcuKPd0mOexR3Hcqk3h3eTcdKCgyx0ujZPKDG8WA9efW5SxxJvjp1T5yxt4OEVf1udVXytcoqQ5p7Qmb5t6uuOpq3bznEvWC16W0pVoqpDBO2MRjZgFZokRGuFPXHHBsbQyx4WCJrp1T690Oy9Afka0esnoKXs8hzWlcR2+ROc9ITZqr4/7vQ6iluTtw2ETJpX2K+iadY4zH0+F1sKByA1qEpSrBG3uZ27GwXoCzqlhgbfAAuArkgIddflxQmBBAUtWSZEhmAG4WOVtsdSWrJBY+x9EQaFl0pBPyY0RcU2Xg9ORcfIUryoCcDnKYHWVZCj1/xj2fi3OMx5yDCHxQkGxYv7hUb3dKRDbwTMeLLnNYYXB/PwLGxQkeuZFhHI0kO+1UUpQNnhqS1mjh5bEt5m6V9iTEmyOukmUNAljjNSxh2TInXznYX1G1EZQ9aL8RDYkS2uSpL/E9BTgXhrIUv7UboD40OMLdxl8wOZSoZP/fjCOsF7B32RVBY0GDTnelbKIKNmOCaTVHjP8ZMf6+GNpAMUEGIWU3e0Bf5j1HMynB6AEnBFDaFt+lf9N/ZDRrE8GVV1oiR+sO8L3RFXUPatzbrJZ0eaF7bFXwcb6stTXAQ07rEOl0VWL3pMm+
 IoWJGuvE
 tc0q2kHj5xqLgs6PYuAx5rWL0b+rYJ+Q06aSuw1izhj+nOWmJCTl9yoD/LFVxSGZHxkw6WBds4slJV+VM7cqi42nPc/9uDFHHk/98XnSzUxQOEfCgDGOoyQH9ofO35b8MachUZdXq5KqRNg5LT/YTokHz6gb06SiTqSkYQb35GNaCDe6G8hRqIaSSFD5Z3aRHrvoODbcKKQSOa39RgQ1R+FlWZIRdTTJgqnMGq6YDc6bXzPax105T9vnmePiMx1wGbPfKOlA7CNplpigVQZTYRsgS8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_free_pte_range() only calls madvise_free_huge_pmd() for a present
THP, and its PTE loop cannot descend into a non-present PMD, so MADV_FREE
over a swapped-out THP silently does nothing. Over the same range as PTE
swap entries it frees every slot, which is what userspace gets today.

Free it at PMD granularity when the advice covers the whole PMD, and split
and let the PTE path handle the subrange when it does not.

zap_deposited_table() moves above its new caller; it is otherwise
unchanged.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 34 +++++++++++++++++++++++++---------
 mm/madvise.c     |  2 +-
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 689a1f4286471..5f3d620c64a94 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2447,6 +2447,15 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	return 0;
 }
 
+static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
+{
+	pgtable_t pgtable;
+
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pte_free_defer(mm, pgtable);
+	mm_dec_nr_ptes(mm);
+}
+
 /*
  * Return true if we do MADV_FREE successfully on entire pmd page.
  * Otherwise, return false.
@@ -2471,6 +2480,22 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		goto out;
 
 	if (unlikely(!pmd_present(orig_pmd))) {
+		if (pmd_is_swap_entry(orig_pmd)) {
+			softleaf_t entry = softleaf_from_pmd(orig_pmd);
+
+			if (next - addr != HPAGE_PMD_SIZE) {
+				spin_unlock(ptl);
+				__split_huge_pmd(vma, pmd, addr);
+				goto out_unlocked;
+			}
+
+			pmdp_huge_get_and_clear(mm, addr, pmd);
+			zap_deposited_table(mm, pmd);
+			spin_unlock(ptl);
+			swap_put_entries_direct(entry, HPAGE_PMD_NR);
+			add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+			return true;
+		}
 		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
 				!pmd_is_device_private_entry(orig_pmd));
 		goto out;
@@ -2525,15 +2550,6 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	return ret;
 }
 
-static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
-{
-	pgtable_t pgtable;
-
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pte_free_defer(mm, pgtable);
-	mm_dec_nr_ptes(mm);
-}
-
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t pmdval, struct folio *folio, bool is_present)
 {
diff --git a/mm/madvise.c b/mm/madvise.c
index fbb72ab49aa64..70acb39b8b3dd 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -678,7 +678,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	int nr, max_nr;
 
 	next = pmd_addr_end(addr, end);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_is_swap_entry(*pmd))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
 			return 0;
 
-- 
2.53.0-Meta


