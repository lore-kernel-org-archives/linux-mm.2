Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0270C606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 23:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLU6OErr
Received: by kanga.kvack.org (Postfix)
	id E9DBC6B0373; Wed, 21 Oct 2026 19:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CE66B07F4; Wed, 21 Oct 2026 19:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62FE6B07F5; Wed, 21 Oct 2026 19:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D783D6B0373
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:35:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5603E120710
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:35:10 +0000 (UTC)
X-FDA: 85348241580.05.B735F5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AD90C1C0006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 23:35:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLU6OErr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792625708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiwpltmOBAEqC1E507in2t/reGPJ/SwkyjEVEuoAspA=;
	b=DZxdYUVNWpZSXZDU4BLt436y+0rQtIKq9cZdWwYOHr30PbFTDFoE82ByE5gdH09HPYPMv8
	Naz0l0a40iRkNztoG2bUuMuCtuokil7WtRObhJqL8dOerwmBQd4/CgV/wLMsR0HH18xuLg
	5/ihMJj/oF310abmk8SQV+ueJzGGkqk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLU6OErr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792625708;
	b=txBtCZ5SeUANByfXHveTQQwwgUwOFYlqGwjIRV8Vtl+95MMdFTpTMhjMYS/5Ytlk4/YQfE
	E90i15oxOMaWaHfNqCghX6F1KzB3l7OmSEZQQc5+A7vRraap7d4S6eCDQ6aTztQzwNEU7b
	obYxApOj96W5dzfJnKWy3KDAYun8jVg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBC4E43667;
	Wed, 21 Oct 2026 23:35:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295B81F000CD;
	Wed, 21 Oct 2026 23:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792625707;
	bh=UiwpltmOBAEqC1E507in2t/reGPJ/SwkyjEVEuoAspA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLU6OErrutYdmJLqV6sgxwlWNOzyDV0FO0p7+QzyIe4739dv8OYNKwqyytbiDjcLo
	 YtZGqB0nphuc4hbRrg58AW3vskzoE1XcdudEIIdh5Wx6J6CerqjAaOc2tnv9Qj1iar
	 P9GvZNk13xyhf6KOJzb7if6iBT/d0kBMKx5E9xi4k3Zr0ONap9uIQltEyE36vTFXNd
	 VneUbALFVd2ABpxmlOcbku6XmrKA+/MHN73hlFaSgsCpYbBQ1XeDmF2Xl8rRr2u4am
	 W0ilwPVMAnoAW2t4xmauaNUVyPv6Xhln7uJ1uXInPm9HzI8ThYLagzYzR1tTbgYzdP
	 BYfTPz2c9KpeQ==
From: Imre Kaloz <kaloz@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 4/4] mm: pass the number of PTEs to move_pte()
Date: Thu, 22 Oct 2026 01:33:40 +0200
Message-ID: <2bc50d2a6829b49ee909e5bb943244859661a40b.1792609488.git.kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1792609488.git.kaloz@kernel.org>
References: <cover.1792609488.git.kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD90C1C0006
X-Stat-Signature: ea6wzjjafiquzfyfi3sq8u9wxhk8mbtf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792625708-803923
X-HE-Meta: U2FsdGVkX1+lXG9/LPW0YhrGGlvul4/wbfPh8wHrFnL67ee1lvbj5k1MFArEK+ITA0IlrpMzSHdj5TbzdkG3LuDgdD+J2AvVxl5clK6z1YQ7eHEAQrVfekv5WzmwzYWN6uEH9H5Va6cCL2TxaedICD90Fr26piCey0sJ0e1URB3tprZjhJMAyhaLhDbheZRAdMwDWFzYOc1waT5ho2qdN4juk1zSormesB8k+q09qGGI8+z5mJEzGCsm35hKVp5bgxfEBadmDgGQ4cn8rqajtXOITeA17oACdHukDpNpojtYL8cB9Y7U1VthMXEituciC1QSIn/DdOX2o3pg3jXMT3LpUgENsdkpMRt5xqZC/zCalV5T4usub00c3iq1U2WJkG2xEf8eR/bpLB4lrpHMuydhJhtqXREmH+WaLNvuWlN48vDJ5oxnXyhhBic2dPApgq13qTkEmwC8xRKRIrTgZZ5ZvEVqAB39CrL012+xNwwoD+eNX4h68UgRTFtiOiFi0sQ5NAf2C/IdkxN3MNhij+NlbM2LXsOnuFoXyPdQdAshRj7evgHq/TymtqOFFDPT2zOreYSVTBpDZbYpGdEOxO5y4nhNLgL7uAqPrl0YaYMJsxyYiuaEtLcKhNYdj4z5sDCaYMJPC793v4XIsv//9Lg8QjDG5OVL5E4sbvSF1u2rwYucDUzxy/5FifP6/Srkf/WKTnkbePnw7w4Tlh906ksUgJxJ5LQuOfmXoiBmVkeAr9XOLN4Py2u2xh6oCUvakO36kP+FWn8NozAfTcVne7RJQTEd9H7ILFPcGe2Y6b8v4j1EWywDqeIU+hDiJFwzA/abNQn9jW4tDeYNKV8UmwHNVDH2atehpQ/iCDM9aM6N/3gnbqltKw9LcvTYSa3an9kGR0pOeEFHyAEQCUBME1V8F4wJD4a33/nTZPefWw3QqYG2IqZ0PKVhIyRplIuBRDKQ7rpgMpnVymr8eX7
 Q8Y8ALON
 O/l+gNUoKtNE+HnGbqJ0TPxZQz5Y/sZ8HvEAkB0iGIUZWalSjrCIyCtfCC7gsvMEyr0Ixgey4ozPvE4kwzglLi5AGiMWl+0G88AHajEQKkNGYRMFS31R0/RD0o61tbxo08fBNyfVZ1peQmU6kw1cgOVzI38HqDfPCOlGFCWkYnWdeXRwXaGAwg5UzxK6+Et/aoYdAreAUB09L1iDJDaIQyP+5xphnYc6hunFipvC1iwEkvShBQZkQ41yGvWKc8+e31c4TOFHgEq8EgHiSTPLqrwe6XMVeakAoaxB8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit f822a9a81a31 ("mm: optimize mremap() by PTE batching"),
move_ptes() moves a batch of PTEs mapping consecutive pages of a folio
at a time, but calls move_pte() once per batch with the first PTE
only. sparc64, the only architecture that overrides move_pte(), flushes
from the D-cache the page that PTE maps when the move changes its
colour, so the other pages of a batch would keep lines of the old
colour. This cannot happen today only because sparc64 has no
pte_batch_hint(), and mremap_folio_pte_batch() then never batches.

Pass nr_ptes to move_pte(), as get_and_clear_ptes() takes it. The
generic version ignores it, and sparc64 flushes every page of the
batch.

Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
 arch/sparc/include/asm/pgtable_64.h | 16 +++++++++-------
 include/linux/pgtable.h             |  2 +-
 mm/mremap.c                         |  2 +-
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 1430489b9ac5..9ca787b3cbfe 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -946,21 +946,23 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 	set_pte_at((mm), (addr), (ptep), __pte(0UL))
 
 #ifdef DCACHE_ALIASING_POSSIBLE
-/* This flushes only the page the PTE maps, so it relies on move_ptes()
- * calling it for one PTE at a time, which the default pte_batch_hint()
- * guarantees.
+/* The nr PTEs map consecutive pages of one folio and all move by the
+ * same offset, so either every page of the batch aliases or none does.
  */
 #define __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, old_addr, new_addr)				\
+#define move_pte(pte, old_addr, new_addr, nr)				\
 ({									\
 	pte_t newpte = (pte);						\
 	if (tlb_type != hypervisor && pte_present(pte)) {		\
 		unsigned long this_pfn = pte_pfn(pte);			\
+		unsigned int i;						\
 									\
 		if (pfn_valid(this_pfn) &&				\
-		    (((old_addr) ^ (new_addr)) & (1 << 13)))		\
-			flush_dcache_page_all(current->mm,		\
-					      pfn_to_page(this_pfn));	\
+		    (((old_addr) ^ (new_addr)) & (1 << 13))) {		\
+			for (i = 0; i < (nr); i++)			\
+				flush_dcache_page_all(current->mm,	\
+					pfn_to_page(this_pfn + i));	\
+		}							\
 	}								\
 	newpte;								\
 })
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 8c093c119e5a..b58c0e98994e 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1471,7 +1471,7 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
 #endif
 
 #ifndef __HAVE_ARCH_MOVE_PTE
-#define move_pte(pte, old_addr, new_addr)	(pte)
+#define move_pte(pte, old_addr, new_addr, nr)	(pte)
 #endif
 
 #ifndef pte_accessible
diff --git a/mm/mremap.c b/mm/mremap.c
index e8df5cdb0ac9..7fcae7f0082d 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -289,7 +289,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
 			force_flush = true;
 		}
 		pte = get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
-		pte = move_pte(pte, old_addr, new_addr);
+		pte = move_pte(pte, old_addr, new_addr, nr_ptes);
 		pte = move_soft_dirty_pte(pte);
 
 		if (need_clear_uffd_wp && pte_is_uffd_wp_marker(pte))
-- 
2.47.3


