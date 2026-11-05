Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DE34606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SZWNW336
Received: by kanga.kvack.org (Postfix)
	id 0EF826B05D7; Thu,  5 Nov 2026 13:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006356B05D8; Thu,  5 Nov 2026 13:41:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0FE46B05D9; Thu,  5 Nov 2026 13:41:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BE21F6B05D7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:41:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58FE680BD8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:58 +0000 (UTC)
X-FDA: 85401934716.29.3416953
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FA49C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:41:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZWNW336;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904116;
	b=ZIvQ88wf5pV8W2a6y9NC4zdnYUlp7uRMijxzgXcalZ6VOI1Jo1tBfoi0qJAFGEB1MFK62d
	Y5NMV+oziWSh3WJJAFf/6i/Uz9SCgB9wyUnZLORl/WBY+0CIw2/KwpOdjQ4sglcMFwJp5C
	6R7N6j7LgP7YT0/g2p0qHFSOWALys0M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SZWNW336;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WjeqWKNMbOj2IfnQB7/cLqu6IolR411/M21RbM7KJ0Q=;
	b=fioEGWZGE0V9abWxovox+K2UmUH5pQm7T/FQ3km+vHTs9TCAnv5KnpEw69qOXFOY+nw+Rc
	ce5u3EwTQmZcLt2XuXahbfapC4KzZ7PiN4fsp3SSCeVA75NKS2Hlb4PTt3ifX7DTwNkSY0
	vlObZUJ0qBAS3cuadnrMlOwR7zxob0M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z1cBPSmGhHjlikXJzChWDSoswF1O+JWyvo2Vwvu0Pzo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904115; v=1; x=1794508915;
 b=SZWNW336O72rg7Hjnk0P/6ozc5Kgb44dnwqh0Mm6HJZak5E2BCwqOYzbidsvD0K8+0PVACly
 BIRbhiI6xVYGo+j1tk/b/Pd0HTiah80FU9v+A1p73kRHjfBBZ9/wo5jnb69QhIEob60oK9rPn7b
 ACsPISjLt1Do1KwIxNgkzTKM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id dc7789f0cca6bcf0;
	Thu, 05 Nov 2026 18:41:55 +0000
X-Mizu-Trace-ID: dc7789f0cca6bcf0
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 22/32] mm/madvise: free PMD swap entries with MADV_FREE
Date: Thu,  5 Nov 2026 10:39:06 -0800
Message-ID: <20261105183940.2236717-23-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6FA49C0006
X-Stat-Signature: 3wxona5kbo5em7ws7wgz4npie8ndy57y
X-Rspam-User: 
X-HE-Tag: 1793904116-744409
X-HE-Meta: U2FsdGVkX18HmpLvnv24E6epvPfkoEYAdfw0vq5hhhZQd+y1z4UFSKPWwdTobeYG2mfjb6CoXiOmL551/DIPxs0n1pqPrpQT6neX+nfHPoD6RvtqtccCOdFIBt6UDsbyGsmpAfSA/sKb9RXKw05vuWcAWuUc8nWelghtnUQTSmt5ijs+hwotK4Uur8LLlCE5E5B8Y4MjazZpb0jcJTREpgDY5BxZUR5+dJw7f8LQIkqSnODAroHm02m2cxk4rVzrMm863IeKy+Wxg9xQRDGMXR0umPW5gBaAjEuB2xXL9kzdT+FndBxnno/gkTGUgG8Q7RMj4NHaU6v8+FbrFduIbGxijfbl/pgUCXPP1fL5x7AO1NNgDK6eRmqoHGw8NRRk5j7VI1n+qcUy2nQhQEQaflv85TGwNhwwBG5kytimsYjOZoM+FmffTNniGsHX4oCex6as4MdimvUljoefpuspH5SxcO9E/xKVQ0SAJwUBXQmywWKnmJGXKVMjXIbcjqbfgDTLHtxPmBKltn2dNn+Ft0ebG12TMW3NVftHWNSSdW5umLKV78/SnfLC5m6+/sAlRZLhSezuLPAqe+UtA5qMbUi9mfxA5epj+UvYlQkYFDTIZd3tPgVNSmEkLQ735oUrEZuUDCkBV8kqkj9v/mem4zMHUqMC/1rRLAQCX74QsdOOn+I4a/fJ2ivoofEMaCThq4EKMYKt1v5WhhwEKV02VFT1eCDImPIMqKFR15GymS/wvlY4SXprS96/Kl2NPXk07UMqit7Qs+zZBx93IuO0Wipyp2vLhS1SU2e9tpg6Jq81hEyeA9E+P4WBZ/z5WwnlQJXbvqOQ7cH7w0YafccaszslqPxsbkGFE/SS5p/X24hnnYwxpMcf+WI8Fvf+qcgFH0NiBpBxa5lrejfl/YUTIdF6WJ/osiqIss9rOU0RXMX8gvCxQeJaEmmEpdkwldLV8f/d4AtZSXi+MkCR/rp
 DBhwNcgU
 LQsiZ+l/NOHS4B0oWEkzQ22xG4obOqMUdDDuTTHKLt83ppbq7Cb7wTyHIWDI5CZwLtE/pmC6bb+vItOGtctgc2/9Axray5lijvQRN2aL/obCSULFSqZtOXl8TNHTTTEadM0R0jKZ269o/63gv6dLpT3+ELyrwhY2Yq5sHs6BwfbAvb/uGwMNE4/0YzBFeXvnO5G1I9HZx9/00QRwK1uuy3jWxxJ8icD/kF8/cpeqXXVtdsJ/3axd5nvgx63+E1RGpPDjOP1xVl4L0ZTM6Vn9wwO9F6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index f8df5cd723f01..65922d9e4bec1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2425,6 +2425,15 @@ vm_fault_t do_huge_pmd_numa_page(struct vm_fault *vmf)
 	return 0;
 }
 
+static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
+{
+	pgtable_t pgtable;
+
+	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
+	pte_free(mm, pgtable);
+	mm_dec_nr_ptes(mm);
+}
+
 /*
  * Return true if we do MADV_FREE successfully on entire pmd page.
  * Otherwise, return false.
@@ -2449,6 +2458,22 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -2503,15 +2528,6 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	return ret;
 }
 
-static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
-{
-	pgtable_t pgtable;
-
-	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pte_free(mm, pgtable);
-	mm_dec_nr_ptes(mm);
-}
-
 static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
 		pmd_t pmdval, struct folio *folio, bool is_present)
 {
diff --git a/mm/madvise.c b/mm/madvise.c
index e9fa4f71efeac..156290227c236 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -677,7 +677,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 	int nr, max_nr;
 
 	next = pmd_addr_end(addr, end);
-	if (pmd_trans_huge(*pmd))
+	if (pmd_trans_huge(*pmd) || pmd_is_swap_entry(*pmd))
 		if (madvise_free_huge_pmd(tlb, vma, pmd, addr, next))
 			return 0;
 
-- 
2.53.0-Meta


