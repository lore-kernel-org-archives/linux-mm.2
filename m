Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6392C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3D8F6B00E7; Mon, 29 Jun 2026 09:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14EA6B00EA; Mon, 29 Jun 2026 09:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B51866B00EB; Mon, 29 Jun 2026 09:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE4E6B00E7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:50:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D241316571A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:17 +0000 (UTC)
X-FDA: 84933084474.30.90488D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E4EC11C0006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:50:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I92ZRMJq;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782741016;
	b=7d3WO0gvnOqXZAoMCFg2LuaH6pXWsSM3HJZqI5PEKu4jIidewjuWWrMKo8KWq2Xh9joZyU
	jXbOtp3OqzrjWJjBNixeE4DlXxHN/HmHbYHG/obMAQEZTRkGEKPcD61IIt2u7Iw7ghoIgw
	46yxVUh8ZQSGjO07kElNIPD7eyQd2T0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782741016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+cZJIOp09dMSw4V2hsqNnLUK/axMUzonrG0MkHxYeM=;
	b=wyAwyRuQD5o1SYqfAz7K0DS6t8biMw9VX7BIr0DnQsn6Xc0+2xnBrKOt6AV8ZH53DjVIV8
	DLXyObRBIDeMvx6n7Qljz6jo7hWt4eGdK10B3e8MimfjGt7oa73v+QR7V/FcbhlWzudl2S
	5UlxBSfRG8FTYE6NdMaB6LFW0HBIZow=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I92ZRMJq;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35CC041AFE;
	Mon, 29 Jun 2026 13:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1081F000E9;
	Mon, 29 Jun 2026 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782741015;
	bh=i+cZJIOp09dMSw4V2hsqNnLUK/axMUzonrG0MkHxYeM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I92ZRMJq75nS6kILiQ6AXqA5GQi202584CnxxXxbFLXGHNUII+jNHHw5FDjnnw4iX
	 yvpiEruTNJWYheMFIpugiQB+jVZPhkbd55yq0UDZYTIhKiEXIzhUgNKVtgJCpVmIqV
	 xd51dzwLl+suxX/2q6Yz8H0vgV9DQDdsMFNHr2NyqzrCZm14q90n8iWGbOvBwnMKtA
	 VA7O9x0iUqRMRNEAvAs2Kc0JrdZ1KL4aCt8X6GBS9YMThQe8nm/RFbl92zqATCUCtk
	 glQT6NuDyA6B++0fXFdaNIaEo16d3RW6ZPsbb0MUwT5mqdGqqYg42QCyTXmjFidUhK
	 NmNq4Bj5LWtyg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 29 Jun 2026 15:49:48 +0200
Subject: [PATCH v2 2/3] mm: drop pte_clear_not_present_full()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260629-clear_not_present_full_ptes-v2-2-96089871a1e7@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E4EC11C0006
X-Stat-Signature: e8qd6x5gttmkfzqsb7p8t7aey4xn6fmt
X-HE-Tag: 1782741015-283076
X-HE-Meta: U2FsdGVkX1+yIvBkRq9drtW2VmhD/KGpkML+lF0lM3ivSzhjfjJHr9FNy6dB3XKrEISxdmcevHkp0h1mIdCQXZOIVlzWh+FopmM3U2lSoOgzotXf6ohOsmMNO5Rku9AcwmCuJ2vMQmAo5GimDlx9Mhwn9tPz64oLmOKBjfjnP6/2lk1Cb+0cToOoIkqwdLj26yt4+BZ6vCYH7WlWq5Mimq2L7t4gjO2kS7diagD1746yORqUZ/igKHH6q/6V3tAB4/DQYZ1LZ2glL13L16Z+5lmzB4rngzX/h00nYCI4GgYly/njn/6bisGjlZqgHsF2Htg6/7eEHkMlshWsp26BRnwgTqpvehrhb5j3Zz3kVIPnwzREE+nhzEqGk8AfrNtDbhDDKVR23L6U//t2jAo8jrY//ZM6rHHP9DpT7ntHatwf1z5/WdmlVLoOOygt7md0cs4fahkadQSyTiorO6Dpw06ghR9dVkSN2HeFOBLtZPv10kIjAUdmG87fVK7ePogPZtclU+PgGJtwBczTryXTTGslZfPvDFuS7mMzHPcShEQDt6qzqqHhIzY5IBzP78sa3+sRRsgG3mIlFYptjtdWakfxGJDiiAaUA/bmBEcSwRS6IyPBsiaeqeq9lXGdivOY9l99zPq+VzZE7KhxgaTVhTUFu/zt/SGsL6LnP7/rKBWE4Nlg9jzDp64WequtivvS3VwAnb5nfHhberSQpPw3pS5uoACWBks4MtQlNpcwua2rMbDKwEp0Wm7n53yn8ZPAaWpj2f62iUTdTyTvg70aChJsDwXvhZawotwi14uYCa1yFKer2EiVGEBBhlv9VDtaxjROUKNeGF1/BSQwNfu6IJvcUmJ58xIKLEdy0o7IYnko0m/nEP4basphCKkoUGThUM0IkY3Gm6XxbXwungASYQLBdB39EJoajgXKDqnbfp1IZBGfD9GQdK6zwoDdhkEODooGCfg1qxpLottWeBq
 N3BL/Xgw
 uFCtk5iJV/2QW3McpWExqrZw/LqxJPQAV0J/VgBw8hzakJXETimp63GlJw/GgWmfyblxyuEDwj/lga1duVa0w6ozDmBdDSI/mCY06zBSuOdhSql7xDzU82sSg1IrpZ7r4IFuOZX87xS//wQzaTAB1irF09iYwlXpREugI0fsTsAk9vbRZLkrNXX7YhWNZ6biqwOm+1AMn2bX854gnMVFU/PcQLl3/kON9b0bVS+EbRWPu060LAi7Afga43nnMU2Rl/vZJS2R1a3QWCHiFegEJgeoC+ck8MdO0JFANAfCOXsyDmi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In general, there is no good reason to do anything special when clearing
non-present PTEs.

In theory, HW that does have to invalidate TLBs for non-present PTEs could
benefit from a "full" parameter, but fortunately
pte_clear_not_present_full() is not wired up anymore ... and there would
have to be something very convincing for us to care about that to re-add
it.

So, let's just use pte_clear() directly now. To avoid the compiler
complaining on some configs about unused "addr" parameter, silence that
here.

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/pgtable.h | 21 ++++-----------------
 mm/madvise.c            |  4 ++--
 2 files changed, 6 insertions(+), 19 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index dc804296d78f7..0b81e396816a5 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -988,21 +988,6 @@ static inline void update_mmu_tlb(struct vm_area_struct *vma,
 	update_mmu_tlb_range(vma, address, ptep, 1);
 }
 
-/*
- * Some architectures may be able to avoid expensive synchronization
- * primitives when modifications are made to PTE's which are already
- * not present, or in the process of an address space destruction.
- */
-#ifndef __HAVE_ARCH_PTE_CLEAR_NOT_PRESENT_FULL
-static inline void pte_clear_not_present_full(struct mm_struct *mm,
-					      unsigned long address,
-					      pte_t *ptep,
-					      int full)
-{
-	pte_clear(mm, address, ptep);
-}
-#endif
-
 #ifndef clear_not_present_full_ptes
 /**
  * clear_not_present_full_ptes - Clear multiple not present PTEs which are
@@ -1014,7 +999,7 @@ static inline void pte_clear_not_present_full(struct mm_struct *mm,
  * @full: Whether we are clearing a full mm.
  *
  * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over pte_clear_not_present_full().
+ * loop over pte_clear().
  *
  * Context: The caller holds the page table lock.  The PTEs are all not present.
  * The PTEs are all in the same PMD.
@@ -1022,8 +1007,10 @@ static inline void pte_clear_not_present_full(struct mm_struct *mm,
 static inline void clear_not_present_full_ptes(struct mm_struct *mm,
 		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
 {
+	(void)addr;
+
 	for (;;) {
-		pte_clear_not_present_full(mm, addr, ptep, full);
+		pte_clear(mm, addr, ptep);
 		if (--nr == 0)
 			break;
 		ptep++;
diff --git a/mm/madvise.c b/mm/madvise.c
index cd9bb077072cc..f3cda54c1d6a0 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -698,7 +698,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 				clear_not_present_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 			} else if (softleaf_is_hwpoison(entry) ||
 				   softleaf_is_poison_marker(entry)) {
-				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+				pte_clear(mm, addr, pte);
 			}
 			continue;
 		}
@@ -1234,7 +1234,7 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
 
 	if (is_guard_pte_marker(ptent)) {
 		/* Simply clear the PTE marker. */
-		pte_clear_not_present_full(walk->mm, addr, pte, false);
+		pte_clear(walk->mm, addr, pte);
 		update_mmu_cache(walk->vma, addr, pte);
 	}
 

-- 
2.43.0


