Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A55FC982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 23:59:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D721D6B0099; Tue, 22 Sep 2026 19:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D23A96B009B; Tue, 22 Sep 2026 19:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9CB56B009D; Tue, 22 Sep 2026 19:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E10F6B0099
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 19:58:50 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB6F11205FD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:49 +0000 (UTC)
X-FDA: 85243065978.29.87219AB
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf19.hostedemail.com (Postfix) with ESMTP id 126011A0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:58:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=njc6xcoc;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790121528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeVENJt4LIsrgXUQ5UaykSbIE82DoLdeqUsQ6JLwyy0=;
	b=S1BPc/UA1NXxfzEr7/+k/1B+8TGJAg9yqdJXzfsuYoH8vxNDlpeZYJg+H42xoXlHkNFbHj
	AA67U3ExdlzOqs/TkLlHpy7QEAoOzPMEe+QYfn6iqcsGRb+XMj0mhb82W4eACrIO0sXOpr
	aGdQweTn8yUk8b5jvHKFhpkn7lgI/bg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=njc6xcoc;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790121528;
	b=T2WGY4huduco+jXNCEPrMnVtTEkhPfvoCr6A3fUdKuaV6DI8MAx2OGb2wgsPz7driELHN/
	GdZtn6TsmOQL5VOOdBw2SkBHuEP+g+972QaqLcuFEB4WR3OEs5EqiuJq713xNqbfjgcpWI
	liNqV1pjcsmxzcad2QeOyT495hiZT0M=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-52fb766bfd6so4082091cf.1
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 16:58:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790121527; x=1790726327; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LeVENJt4LIsrgXUQ5UaykSbIE82DoLdeqUsQ6JLwyy0=;
        b=njc6xcocaD6TfX6PMLH21L5FpxHoc5bwQ7s4YNXLsWxL0KAFincD7nkk4v4CshByOU
         31zQZ/6GOxSJivVt3M3UbKi9+VcUQKhzLKeNPVP+vOzF/SG4s6L/1mITC8iT6RpJyYIB
         AoYfqsQZxghPWlB45ArrEpNtHS309BQhxiJXFC8pK+0l4oEHDx3NIwIc6NWChAuL27Rh
         p7Z/gCNDen3un1xkijXbwozuqdWBSLABr6l+S9FP/7+rxW7FpMcZNJWvF0mUa/i3CSJ3
         jBF6baxMYFGJuPePBRVxdfWVLQEIAEFv8kMEa3suTgzK/FY/jk1FPNWsjo2oHIkrUfez
         hd6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790121527; x=1790726327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LeVENJt4LIsrgXUQ5UaykSbIE82DoLdeqUsQ6JLwyy0=;
        b=uwwsIjVlDax9x9tDGeLM3MxqBh2hEPUimyBdV4bpKovXOD4p/DK0xuHHQHz7S4Wmmq
         8j5eRIMtlE1kkTFmemvBfIbTC33vMVA9ut2TV12OYzXFXRIWpG6O8wy4z3uxBTRPd8vb
         6WcL+XJGUVSAPtjeQVJOYcDbOSxjvbvlXHqbeXMAJazBzoPBCmJFW0kxsoofTTMEMX73
         LA+mmzEhF0K70lBT80tDjN4oTHB7aPfyTP6994J7pfUSh477WoEB2lTDLaenqGY9JOK7
         ofJvhHqHMjWa8iZUip7coZfTUVp1FbcR/ZfrRRk4DP3+YzYb+JDnPLzJZA/km93z7vHl
         D0mA==
X-Gm-Message-State: AFuF++k6HdcNcaUjSo6fvfoclLrxt15UJkIJSmeX50Wvr+I7RaayoTx6
	lGdxnPEi5mSGiu9U1BUDWUyKTV7GlI2BlkUwzKfI2C5aEjcZxFnsQ+Ja+8vOpEcZDiPjyEKQGKu
	z8sSunxc=
X-Gm-Gg: AYBFou00ua63RxpwgsoH3o+26vPQKmwCV4AbjqUEpHt8j4pp9ZsksObSwJwW2isscmO
	zc1e66JO+3k+rZOZubnRCG4UrOz0WI5jLZ1qG1WDurN5DZvS+0An3f20hkzGda7Arv6Gu7Mt94q
	mi7KN07sU/GSatGNyL63fEO8/YdiThdKeDB+zVLab8VM3pZNHz89gUrg9RhQBL2+quu/HTyDZED
	k9crTNlc1l7dbJ/ZFv8ErGoUculY2AiyGtMLKmkpl2p6Qzjx+yTRa/e/rcg77XXQXRC9fzAhqJD
	y+iV16Xo7IN+R540iCtCClJQtsuGVTvG7TXkpzsUQoqpW1SXghAop2ITQdLemB3XXmLlE2iTnLT
	IpXElS2recWma0e8Rrz54DS5jlJMncffAAOz/6jKa3EC5lx5yszZzgTuyQDgK1AFxZsf5XyILmf
	anC1XDhd8AIz+PyBN/eV5OFu31r+SdzX8eiJdwmNBG2z1H2+TpOXHpcipJZHS9RNvVihbHSwicV
	uGU+XY/lQ6Mberh6mIwy0nN07L00aKDK/eDVTx4CG5F4FTJdgx9zVHmszF+tOQXLqCc86k=
X-Received: by 2002:ac8:5986:0:b0:532:9adc:639d with SMTP id d75a77b69052e-532ead489d2mr18461111cf.65.1790121527246;
        Tue, 22 Sep 2026 16:58:47 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb3c6715sm8323261cf.30.2026.09.22.16.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 16:58:46 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH 07/10] mm/madvise: separate PTE-batch folio processing
Date: Tue, 22 Sep 2026 19:58:27 -0400
Message-ID: <20260922235830.2350770-8-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922235830.2350770-1-gourry@gourry.net>
References: <20260922235830.2350770-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uc7bpj3homathpaowmxtiqb11usw6h1t
X-Rspamd-Queue-Id: 126011A0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790121527-874159
X-HE-Meta: U2FsdGVkX1/Kri6D1gRATTbrdnUeAJU/2ybIFTrc62uMbEiqJmapuXJZUXP2wN75+Xz0uztmBK1B9LyVflUwKlqRneSMxndhzt1IX/9Z0U1bRgtVF0CSWDw1J7UnK6ROWSC3oHS5VpNL8Gvr15A+0NgwoqL2L30HgVJMDvpOD385pS44VkX/xhxzyADM+5hVgDFeiBwUeHPFxpz0CkARtWFQcbr5cQoIOd4ckpWhDGIihHpfy61ELDdI+UkFsOu4QKxvbX7d7prAALHDfk20n8TOvf76DKFpaJY44y7R2CugwdiDVu/HliHA+uDTNlFxYShYUU6aY+A4ESKsq0TBE1iCqtvbMMnf8ZMuDRh3jlGdiuBLqSuDQXgMV2/Ca4B1q1tb2jSQJsfcEbac2AwdmE0vFgCnasbIx3EbbHHFjJYuKZKwHjWDQ5NQ9fFJcEwrqyF/ysQ+24WuzfiD8Ibko3YejfdcFuOQijgWvxcZkD+guxt9lwXtB+8hCGRqkspLyyee3H2voQElOIzRX5idChvGN2PWm/xis9dJUhTMEaqjJIQsFto8H/A8DLuGTZROeyH1IlMrXIbYcPXNqQbMKhTGFZUeAXyVj0YFE/OKZDajUi+96K8TV/LdLkt1KVpDfP+9byd2zxA3A6UBml+jeqF/bO4jEZy6paULRGHVQD5YeL8QhaTzORunH3hfRK1HVHQhqYzJmAxoKvJx2ipv8TrGyHJL7S51V1zZrQc9yYuB2pIn9N7ecb8MlxePABmUmHGVR303f3gezqKdfc+mE1XkbF/EJvQQEw5o8B7NOQVaJ8XbqKldIjjq34F06emTzO/WMbzh0CV48sjRF4ws9Lq8GowsvFpUqaco0LBTIaPnCV2gpXlygDcia1EEBj32FJp5G7aoTMtGb6BoqXZNXfSwNIhcJh/gNLtJf4Mf0vysGr566opD2fRfxrCJQaC+2nvv37JRS4ZdyoJO8Qd
 DwiwVjix
 GwnCKC4zGxHEKsE9eQF8pkZOdi9AGaD4i6Jv9e6GwRbZW2JtGLtiIWTvPEhJAzzl//7uBVLrcL3FMT0NUv+h/I80PfuaQC6Sw24f49h6o34OgIQqbsaLnP67ZV0ZiwKiXEIwSt6jkI70j30j3s8FBOpzH6DMLuMUxPcm5Jzi7nqbduUFl4Tb8oAj+1JFUhvi2DwVGbum3htDVdIU+P56K7Y8maPg90rIsSk/kEW+bM2+lfh6/9qXti40WlqsRb4sSW6Zyn2LjfDAfjUsxIg0aJv+z4Pl+AeWoW4gXkbNO5upCbQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PTE loop combines page-table iteration with validation and
processing of each folio batch. This hides the batching rule for large
folios and the ownership transferred when a partial folio must be split.

Move one batch into a PTL-locked helper. A split candidate is returned
locked and referenced so the caller can release the PTE mapping before
calling split_folio().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/madvise.c | 132 +++++++++++++++++++++++++--------------------------
 1 file changed, 65 insertions(+), 67 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 83b27258c9673..350b854ccc197 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -394,6 +394,54 @@ static bool madvise_lru_folio_is_filtered(struct folio *folio,
 	       (pageout_anon_only && !folio_test_anon(folio));
 }
 
+/* Return a split candidate locked and referenced for use after the PTL drop. */
+static struct folio *
+madvise_lru_pte_batch_locked(pte_t *pte, unsigned long addr,
+		unsigned long end, struct mm_walk *walk,
+		struct list_head *folio_list, bool pageout_anon_only, int *nr)
+{
+	const struct madvise_walk_private *private = walk->private;
+	struct vm_area_struct *vma = walk->vma;
+	struct folio *folio;
+	pte_t ptent;
+
+	*nr = 1;
+	ptent = ptep_get(pte);
+	if (pte_none(ptent) || !pte_present(ptent))
+		return NULL;
+
+	folio = vm_normal_folio(vma, addr, ptent);
+	if (!folio || folio_is_zone_device(folio))
+		return NULL;
+
+	/* Split PTE-mapped large folios before advising only part of them. */
+	if (folio_test_large(folio)) {
+		*nr = madvise_folio_pte_batch(addr, end, folio, pte, &ptent);
+		if (*nr < folio_nr_pages(folio)) {
+			if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
+				return NULL;
+			if (!folio_trylock(folio))
+				return NULL;
+			folio_get(folio);
+			return folio;
+		}
+	}
+
+	if (!folio_test_lru(folio) ||
+	    folio_mapcount(folio) != folio_nr_pages(folio))
+		return NULL;
+	if (pageout_anon_only && !folio_test_anon(folio))
+		return NULL;
+
+	if (!private->pageout && pte_young(ptent)) {
+		clear_young_dirty_ptes(vma, addr, pte, *nr, CYDP_CLEAR_YOUNG);
+		tlb_remove_tlb_entries(private->tlb, pte, *nr, addr);
+	}
+
+	madvise_lru_folio(folio, private->pageout, folio_list);
+	return NULL;
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 static void madvise_cold_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		pmd_t *pmd, unsigned long addr, pmd_t orig_pmd)
@@ -491,7 +539,7 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	bool pageout = private->pageout;
 	struct mm_struct *mm = tlb->mm;
 	struct vm_area_struct *vma = walk->vma;
-	pte_t *start_pte, *pte, ptent;
+	pte_t *start_pte, *pte;
 	spinlock_t *ptl;
 	struct folio *folio = NULL;
 	LIST_HEAD(folio_list);
@@ -515,9 +563,6 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 	flush_tlb_batched_pending(mm);
 	lazy_mmu_mode_enable();
 	for (; addr < end; pte += nr, addr += nr * PAGE_SIZE) {
-		nr = 1;
-		ptent = ptep_get(pte);
-
 		if (++batch_count == SWAP_CLUSTER_MAX) {
 			batch_count = 0;
 			if (need_resched()) {
@@ -528,71 +573,24 @@ static int madvise_lru_pmd_entry(pmd_t *pmd, unsigned long addr,
 			}
 		}
 
-		if (pte_none(ptent))
-			continue;
-
-		if (!pte_present(ptent))
-			continue;
-
-		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
-			continue;
-
-		/*
-		 * If we encounter a large folio, only split it if it is not
-		 * fully mapped within the range we are operating on. Otherwise
-		 * leave it as is so that it can be swapped out whole. If we
-		 * fail to split a folio, leave it in place and advance to the
-		 * next pte in the range.
-		 */
-		if (folio_test_large(folio)) {
-			nr = madvise_folio_pte_batch(addr, end, folio, pte, &ptent);
-			if (nr < folio_nr_pages(folio)) {
-				int err;
-
-				if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
-					continue;
-				if (!folio_trylock(folio))
-					continue;
-				folio_get(folio);
-				lazy_mmu_mode_disable();
-				pte_unmap_unlock(start_pte, ptl);
-				start_pte = NULL;
-				err = split_folio(folio);
-				folio_unlock(folio);
-				folio_put(folio);
-				start_pte = pte =
-					pte_offset_map_lock(mm, pmd, addr, &ptl);
-				if (!start_pte)
-					break;
-				flush_tlb_batched_pending(mm);
-				lazy_mmu_mode_enable();
-				if (!err)
-					nr = 0;
-				continue;
-			}
-		}
-
-		/*
-		 * Do not interfere with other mappings of this folio and
-		 * non-LRU folio. If we have a large folio at this point, we
-		 * know it is fully mapped so if its mapcount is the same as its
-		 * number of pages, it must be exclusive.
-		 */
-		if (!folio_test_lru(folio) ||
-		    folio_mapcount(folio) != folio_nr_pages(folio))
-			continue;
-
-		if (pageout_anon_only && !folio_test_anon(folio))
+		folio = madvise_lru_pte_batch_locked(pte, addr, end, walk,
+				&folio_list, pageout_anon_only, &nr);
+		if (!folio)
 			continue;
 
-		if (!pageout && pte_young(ptent)) {
-			clear_young_dirty_ptes(vma, addr, pte, nr,
-					       CYDP_CLEAR_YOUNG);
-			tlb_remove_tlb_entries(tlb, pte, nr, addr);
-		}
-
-		madvise_lru_folio(folio, pageout, &folio_list);
+		lazy_mmu_mode_disable();
+		pte_unmap_unlock(start_pte, ptl);
+		start_pte = NULL;
+		if (!split_folio(folio))
+			nr = 0;
+		folio_unlock(folio);
+		folio_put(folio);
+		start_pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
+		if (!start_pte)
+			break;
+		pte = start_pte;
+		flush_tlb_batched_pending(mm);
+		lazy_mmu_mode_enable();
 	}
 
 out:
-- 
2.53.0-Meta


