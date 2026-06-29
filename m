Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A137C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E120F6B00EA; Mon, 29 Jun 2026 09:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4CFB6B00ED; Mon, 29 Jun 2026 09:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C64826B00EF; Mon, 29 Jun 2026 09:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECD26B00EA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:50:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BC92165616
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:21 +0000 (UTC)
X-FDA: 84933084642.26.F111D19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7724B40007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4ySneqf;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782741019;
	b=6jW06LX3ytmv81/S3L/m3aefgZkF2T1sxaK9N7/mB4TjJ2ASAJibv6Iuq1XKj7A2sWwNFz
	F4FgH5KpbAKHQuIg5FIALrNWZCCqjWvJaO2CB11YprZXPf7IEBFJSlfzlkApTM8MgAtzar
	0EFTMP/xlMfbyUaqX1sO8nKFV+qtQbs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+Zb5D1Rf+1FzByFCFmRO2vzNlcbsbvoAC0fHg7BI28=;
	b=QplKbaTXOWxmiBY47M3C30e1Pd3/yj9O6vSy1xRYVUuu/RlEbvAMA+ntaXQllOUzWHIQAS
	cVdm8fndppH6E8/MLJV4rx9acrxwcFuu0DaxDlErBBPJYUE5UoHaRbErJpZJN6we0T+X7K
	Rc7f0PI6Zt0/JWTb19ugIaJ//yajTb0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4ySneqf;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 13B7C6001D;
	Mon, 29 Jun 2026 13:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C1ED1F00AC4;
	Mon, 29 Jun 2026 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782741018;
	bh=V+Zb5D1Rf+1FzByFCFmRO2vzNlcbsbvoAC0fHg7BI28=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=l4ySneqfVaUVEMCfMQEsv/syXXvFDUFyU/OEbQPG7GK23ps2xOHHI5/ByjuxKSUwA
	 37nhEhRNCLpGd9Qb8QBNzWQF9TCmTTl+rqj9FbvOXe1uH9RwwKk2PGQVRxGc2bO80W
	 wKoxJDlXstQOsa2LBFZQKGN5krmHA6H8yIrDGCcPA2XNoHIP3jWQsED2ls3PFiiJQ7
	 T6tJ0jpD3wP2eok5IoXzcuZfv6yJ9M54LjZy52CDdjpJjDoUTMxOjmQRBGoawQvrIN
	 ckNxvrizn95vak8z4ZZ8cev0bN0K2dtVv47X1gK7k7pEuqT11sbbA7sEuamvgr9p0r
	 +OgpqP9fI1VpQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 29 Jun 2026 15:49:49 +0200
Subject: [PATCH v2 3/3] mm: cleanup clear_not_present_full_ptes() and
 rename to clear_non_present_ptes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-clear_not_present_full_ptes-v2-3-96089871a1e7@kernel.org>
References: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
In-Reply-To: <20260629-clear_not_present_full_ptes-v2-0-96089871a1e7@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Stat-Signature: 47qd5ef81omo6497x13bxxfg5z4hi4da
X-Rspam-User: 
X-Rspamd-Queue-Id: 7724B40007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782741019-210249
X-HE-Meta: U2FsdGVkX18D1GDf8FslxrEh4mJUX4za6tffPFPqjMIOhJKKYAPb5l6u8h9oBy5zgY5soA2sG6AkvnZ+q+LKrMXNofRoHGsype6eJiy2440A/IoMhSEgeRZFa+Dvk2NP/bZS8/pZ5KmGvF7WyQsS3vROBqAjpF7bKE+dFAjCih5IpqElpQfUynKYmTAJEFtEWCYi480Tyu6Sb44vJvWpeuDBT994a/l1eiJSTf4EV0XhPhAGKcuA/XTnMXKJ9bDBdsRyNNVF5XOmtFM1cTimhflTJEh56nlm4QVaWiNcLdnGFV6Za5DPZdNyUoJoOIAgmXo3Yo4f6GtOgIBUyBHSSsce4uIZ6aXA84dbmHxDOJ74nELpf4c20s9moJeaA2B60kHq5+clrO23Vxo5TSUr8Qx+LDH0lHhufUBX2DAzBmNdPB3iQRBUBAGRovJBYZNYMmzmW/Mz6Iv7EuaaRnRl4FUmM3Pd1gqA59Q7IPXaiUO5mry2Xm04QEiK6WpowTkcov0PBTvX7DZPPqrvGdOWkspjxXbXNQRUBC4EMb/+jxbXs4Uu/xqU4RAZbZCO3WUPvW9nAVEsNlIJiZXM6hrsXXw4+upXiKqGxAMVdMMnWaDzJE8kJUbQmU905Lo0tKg+b2XvDMepm+HRgmcXhuL+IAfCA83tVqjgCVFVXhAoCBKTHvsyfz8HUskEsJvFL9SwBo/2QQ8EqZ0nzEm6aOciOvnWndYSogEHBLle19ts67T3XB5291fSpxsY6V6gUJlObe/sGQHmZSR0g7iCAN6Nug7aArnwzkSYDk/bMpOb8B4obPtxU/KJOves07H6YxKFgR2Me18EOXsOyI0X6JnGFZpQ9stNsOof3AH8glJJ3N2rwDqqfrQAKsUslWojbMj2xszU+za7kqiMjSXrbqWftLxWvLNxxYIlNIGP7+Gwm82X0k7tv8fI3kM/7BQii8PdqdHF0BBjNiTCHv0C4U6
 d1GgNAUu
 7VVuQs70br0u9Aqw5sSmUVxWbQBEHIEuYY77hjOam05pEQNyO6HbRNdoFpzsSMXDQuwxbzLQh1iUuVU/d57deM2Fo9o6Rlv8MHos/8f7dVmRKHe1HJUasL1HIf8zI0VbTfgwBsL2/K5xu9/8ioKBMstPK12KbskcfpZsl5EsQA/+P/F7XC2FFM4y+llZUQxN9LgToavLAFRlUK2xUCrRxhFm5uHIdxHJoMiqqbwWQgoesqH0brCL/SY3j0gb6OLNNO3l27c6kJjjmMarw0AHkSKTnaELcmmYi27w+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's clean it up a bit:

(1) There is no need to pass "full" anymore.

(2) No architecture overwrites it, and there isn't really a good reason
    to do so when dealing with non-resent PTEs.

(3) While at it, call it "non-present", similar to copy_nonpresent_pte()
    and zap_nonpresent_ptes().

It's a shame that we have clear_non_present_ptes() correspond to
pte_clear() and clear_ptes() correspond to ptep_get_and_clear*().

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/pgtable.h | 14 ++++----------
 mm/madvise.c            |  2 +-
 mm/memory.c             |  2 +-
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 0b81e396816a5..d52d2a976e5a2 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -988,24 +988,19 @@ static inline void update_mmu_tlb(struct vm_area_struct *vma,
 	update_mmu_tlb_range(vma, address, ptep, 1);
 }
 
-#ifndef clear_not_present_full_ptes
 /**
- * clear_not_present_full_ptes - Clear multiple not present PTEs which are
- *				 consecutive in the pgtable.
+ * clear_nonpresent_ptes - Clear multiple non-present PTEs which are
+ *			    consecutive in the pgtable.
  * @mm: Address space the ptes represent.
  * @addr: Address of the first pte.
  * @ptep: Page table pointer for the first entry.
  * @nr: Number of entries to clear.
- * @full: Whether we are clearing a full mm.
- *
- * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over pte_clear().
  *
  * Context: The caller holds the page table lock.  The PTEs are all not present.
  * The PTEs are all in the same PMD.
  */
-static inline void clear_not_present_full_ptes(struct mm_struct *mm,
-		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
+static inline void clear_nonpresent_ptes(struct mm_struct *mm,
+		unsigned long addr, pte_t *ptep, unsigned int nr)
 {
 	(void)addr;
 
@@ -1017,7 +1012,6 @@ static inline void clear_not_present_full_ptes(struct mm_struct *mm,
 		addr += PAGE_SIZE;
 	}
 }
-#endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
 extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
diff --git a/mm/madvise.c b/mm/madvise.c
index f3cda54c1d6a0..3db143c442eaa 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -695,7 +695,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 				nr = swap_pte_batch(pte, max_nr, ptent);
 				nr_swap -= nr;
 				swap_put_entries_direct(entry, nr);
-				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
+				clear_nonpresent_ptes(mm, addr, pte, nr);
 			} else if (softleaf_is_hwpoison(entry) ||
 				   softleaf_is_poison_marker(entry)) {
 				pte_clear(mm, addr, pte);
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe923..a3fcaf8cfe8f8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1797,7 +1797,7 @@ static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
 		pr_alert("unrecognized swap entry 0x%lx\n", entry.val);
 		WARN_ON_ONCE(1);
 	}
-	clear_not_present_full_ptes(vma->vm_mm, addr, pte, nr, tlb->fullmm);
+	clear_nonpresent_ptes(vma->vm_mm, addr, pte, nr);
 	*any_skipped = zap_install_uffd_wp_if_needed(vma, addr, pte, nr, details, ptent);
 
 	return nr;

-- 
2.43.0


