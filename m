Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D24CCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87CC6B00A1; Thu, 11 Jun 2026 07:51:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38656B00A2; Thu, 11 Jun 2026 07:51:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4EA96B00A3; Thu, 11 Jun 2026 07:51:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B63C26B00A1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:51:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 790B41205C8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:15 +0000 (UTC)
X-FDA: 84867466110.23.7EDDC7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A98771C0009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RqNu915E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781178673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cd6HE8o5qRluRnnVl/c2b6fi85KlAR03bwglw7I39Yc=;
	b=zsuOffA+R0NgB6mWd5oPsj8Er25HRruub8vW6d+dJylQYLckIHGkFuN5PuMJdVcABrYdO8
	5/YpDSpSGQuzQDHB7IC8vncU9m1ALLNzuZ6LmiKItsb6gaP0QN/IoBGsm7Y2wTy1GxlEO2
	C1XEOY8HiKDa9kCx5LAdd+Ir2y/EUqU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RqNu915E;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781178673;
	b=a970H++moVJukkomdeNtW49/30a5FKtKKBbLjbqfuQabQg1PQAxTK/DnnQRTE1auk/6kHY
	JmjnOInig3W+aQW16gbpqtug5fzkCG/Ckb5dXoncatDoik9eOpJQQADA8T1QOg9vNBxCff
	dU2RtfmKJfbZdE1KDPJltcH1TipdnHQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB8784324F;
	Thu, 11 Jun 2026 11:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8271F00893;
	Thu, 11 Jun 2026 11:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781178672;
	bh=Cd6HE8o5qRluRnnVl/c2b6fi85KlAR03bwglw7I39Yc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RqNu915EgPPafxbXg6CAenB9vC152Hg1JweYucDclKCQHRI3hwgNdfvTBXHr3FF1s
	 RHb1G33OPFNwf2trCId6SrER1UFYtYRrl6zeiu963tO4B7Tpz1/ycN3svbCiGu7GUB
	 UHlByfN85czSp6hFKrX1wFutee6czGd7WayLNFXE7tEHI2+F0LkSrDFPrIMyycjYyB
	 g/SA+o+EH6gimPQi2sqDW35LfHyUd0TlA2ljRVq5gbFNbo17ATBpeFZwJuKr3XbEXp
	 nOTyz9ysmOgmMhg99vCgyWiIWnM/Mk3M+rRBmqkCP7ickGBkyBHQKHnyqHKw84CA4p
	 QEd3X/zgqlmtA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 11 Jun 2026 13:50:49 +0200
Subject: [PATCH 3/3] mm: cleanup clear_not_present_full_ptes() and rename
 to clear_non_present_ptes()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-clear_not_present_full_ptes-v1-3-49865fc82629@kernel.org>
References: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
In-Reply-To: <20260611-clear_not_present_full_ptes-v1-0-49865fc82629@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Peter Zijlstra <peterz@infradead.org>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: f3us36dekxwhaw7hjszuxbj9meneds6h
X-Rspamd-Queue-Id: A98771C0009
X-HE-Tag: 1781178673-721472
X-HE-Meta: U2FsdGVkX18TGJZTSk3fEC2gD58JVD6ad5gEFq9kV50YO65kJEWSd0uD+K93zsS9NuXEXRrbjUjOg0ngroTbG/J/n+srkWCuHQT5llSxRB6FAyoXvOu0PqiA30yynhpQvcGsC8hYRllH9USyFZlC9h6CQ1Z8qzVCWZ6HvCEX61fcM6RwUJ9r7QIXFt909UFlBqTjpn8TNeY6NPNc8YsKu/7fYkFkNjPdqvcds5T1Ot+ThGQv2DMgvkQOudxbKh9TbcukumNxZoX2yztxj8gQEe/v+9SsLKYY7/rae+Zh/G/O50s2+qTHLhVpADY3o1KPNVF9I2Kvfwesleb0+r7feWE9Ok9Pl75s0ihMhlDV5wqvqAvq3IPbSobGOn3x5QrxB610PS58x7qTCAtCB1Xv6oahu/irV0gSuY24U1A2daD9KJtX4yyW9UqiKfX6ur7Mx3IjFBFkMMmjHCDDVw9jitOfa90YpY2SdQybZbDs6s0XqiwGMUgg3j6VmV1jbHLcUULuWQGOiDVfBNLGIP2SSVqpSB6mEXNjJLqDvcwSvMtQTE65ZfkMEnnT61eVws/wQiHVKBWd4ER4wJ6N/0ZRHR+uwLDiHDkEmSe2fmayXHg9xZE12Ckt8F7s7IIAtQ80bvJ/2yqSjR5D1GRN89znd/NuuCh8IO4D2zkTzZhvTb1M/I1aEJ8AB/JZgARaRcdNQPldIJ21HOIywuxSG5opuJ8Pd1SKxZYILSKTcKJjDXfOSKIh84EP+TROCIG4Y5ZMkGDNuBTQEbUeiiqhFkQPcdMlz+9YxrnaJ5vldR/BdOTH4dY5i93pP682/vhfJODZ2KlgDMwnOuTYdzZ59Cyi1pDLm/o4apLzCMhzXuxT0MwmA87nyTnE2M8Tmt5CGM1ma8J7Vx64U4VFDDdu+5nTgeXjX53S1Em7pDjRUld70JwzDFGX9m+s2ipjNgn4fUIAsfvS6+4kaywiqO6/05f
 hsRojpTC
 UhuB/yF0Hd/YAUlll2Zc++banIoLqcKox0avGmeVPswNECSXvy8eKadJfCX7gR9uA9B+8UOUh0SuMQJIAG3dLsK2pgPs9A9SCDMApQN2oYLxRzt1nlx6GMlL1LLP/4Pa5gitEBZrEXr+Suezi1pZK6SndSVoXeoetT7bEzKdvtkOaKcj0HJ7gmtpPWsNMx0q+PPa5mPLk4nIlKEmfgEgZnMXDMe7Knj5Wq7lxjRUeYlR4aDrt/YTwYJAQPQRroljhfUnXkhe6MJSL16fKsQK8AF4haJ79J6X+a1mj
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

Likely we should rename pte_clear() to pte_clear_nonpresent() or sth.
like that, to make it clearer that it is usually the wrong interface
for dealing with present PTEs.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/pgtable.h | 14 ++++----------
 mm/madvise.c            |  2 +-
 mm/memory.c             |  2 +-
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cf328f4d1e12..a72c40708461 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -954,24 +954,19 @@ static inline void update_mmu_tlb(struct vm_area_struct *vma,
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
 	for (;;) {
 		pte_clear(mm, addr, ptep);
@@ -981,7 +976,6 @@ static inline void clear_not_present_full_ptes(struct mm_struct *mm,
 		addr += PAGE_SIZE;
 	}
 }
-#endif
 
 #ifndef __HAVE_ARCH_PTEP_CLEAR_FLUSH
 extern pte_t ptep_clear_flush(struct vm_area_struct *vma,
diff --git a/mm/madvise.c b/mm/madvise.c
index f3cda54c1d6a..3db143c442ea 100644
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
index 56be920c56d7..d4b3540ae659 100644
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


