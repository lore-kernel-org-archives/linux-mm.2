Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F3BFCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:51:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A055B6B009F; Thu, 11 Jun 2026 07:51:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DCFC6B00A1; Thu, 11 Jun 2026 07:51:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919FF6B00A2; Thu, 11 Jun 2026 07:51:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 826C86B009F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:51:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 338B9A057E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:11 +0000 (UTC)
X-FDA: 84867465942.15.D81CD1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6BD4E8000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:51:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MetWtrrc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781178669;
	b=Bjx+yQdfkCuQSQ+aJjsKBWstU8SuDHNoQka/eAuUW7Hue6gACx3RzzCkqT+GYfuX+ONAoB
	yNXwj5lSPYi+W/G9ix6tlbQ7xHcLo5rrnXNtQuaHmm2BDlhi1Eyi0P8/I9HmOY/VH84naj
	6GJTjAh/UDHibI2IDeLZwlhmLsrRzn8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MetWtrrc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781178669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BT1sEEbTnVOk6eL6aYsKhNOuh8LlCELh0FnPZ6pIttA=;
	b=S08UJplNv5pgoLfeB0IpRjpAobYX9NahsiuEaavoblQ8Nk78GHsjWq45F2De3PEbGWt1Ue
	QuPKM6tG06wMCaxIZKLqNovSCr6repEwBnBE1M24CUTlPvNSWgrOXxTJqxln6CuibklnFE
	hNOMbP/F7QzAc6wVCyrUtCtxtVfl9Yc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 82971439AC;
	Thu, 11 Jun 2026 11:51:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB45A1F00898;
	Thu, 11 Jun 2026 11:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781178668;
	bh=BT1sEEbTnVOk6eL6aYsKhNOuh8LlCELh0FnPZ6pIttA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MetWtrrcxVV3T1O0Ds7aVklaV3qE/dS5NabUkyuWVZ9ZdZjZUI+i45WObN3iW2kFD
	 pU5wVL8PfyU8cz6JsLXKFe49YE89Tu+PR261qgm9z+N8DTsdzYf4ZZxzNpLuGucHRm
	 hZWkE9WsI2D4a+D+TUiabrm2PDeN3trtmY5yqzbym0CIJZuR1oQvOkBRZSeoK051zp
	 f2QWcsqltb5kF0vmEArtB3WXSpet+R6vwGtIXyIcmiRd8YsGOBwLg1GJfVHQm74kIW
	 IaTWzEvl1dJRVmybhrdkUIkq/Sr8nPj01DwlJ+WlxIizusSg5WthQngAJU6Fn963gv
	 5VbWHwedvdQsw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 11 Jun 2026 13:50:48 +0200
Subject: [PATCH 2/3] mm: drop pte_clear_not_present_full()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260611-clear_not_present_full_ptes-v1-2-49865fc82629@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6BD4E8000F
X-Rspam-User: 
X-Stat-Signature: m677cujsfio8aj1iw6sbgpy1m79wob87
X-HE-Tag: 1781178669-50238
X-HE-Meta: U2FsdGVkX19c6EVwRwbj1KbF2yYsDRbxLmT7A/C3Gg741kVqPAIhWwUy79Yp+s58130FoUnijpkSBBvnHdvWvS3VkvUFGO/STJvFfw6mmgIssPGbky+EVmTj15CHqWCP0LavmnG5d3WJHh7/S2QN2dBbB1dwdhGj5tfptk7uXYihdhR/tCkJnM/ITKcb/AcZXhBa032yoPOtsv4X/xgTSkTlQmeqXTrKaKlLzpPuz8LWjV6IzGcTLQGByGgnqHZjT+Up783nEWHmv1oRtb6JXoq6UcBt2vVE/NBfQqagcQYXaln2waDZ3BoJ7I0i+jL4q3oXJE/X5/9ffTnIfp502q4/inI6yufJWL04cVq433cbi/xJBdgK5SwgRVM4dlYG9eOo9cUELFWo6xsWJKBysvCfd81PFBAGDPaI++tUb0Jys2oClPfotZMrg+ZfngivN5WO8BFrP/KIiqLOCpzaftKxY487HX+IjEcIAu57UebJlQlfd4DQAv7HDps48HF+quAof+YLNAaQAAF7ClNdCyGp6ubK96DP1ouZE3gGfUjSgSgtZjjRnnRKJk83vn4NHl+HeFR2tWQ3YVSBwvD4BeTlvBytqtYo2IUNXWlOgJoLtZZAKv9cu0bfA7VBW4RsgNgYJyip3sKgqySMKvSvq2K38NEirkqh3EAyV7izlwmWp9VkrQoryTSgeM2QPRzCtCA8hbFCZUry4KLftkzD59FvAuvDEfAaW0HjORIXktwsu8nlvl0ofda6Gm4JmZkKfqqhTdo/HpLz66EpZ6KpNV+wbKCe3ofMIST3eSQf9Gh6gyAAly+HNZbVKNL6PSYAy1Aq6OeHXqYLijJSQNIE+x1iaRTY02yyLCpcNQnN4t95XtZLQnr02uf4EE7b5hof7nQnoSvruSN5rRjN5j0opTQHb2ruip5Bxevoe19xrjk0fLTrhpHmbLuj7PzLG3vxsyp5taISjx5mAGfWX+r
 j9Qzpf2K
 lhKjvRl4b+SqFd/Q6KrlzADfATn9ppQrj9rHNHkmdoOK+2+N7FofBAecqWyxSWX21uZUeUv+4zzR2iWISL8mefzMTd7/Fxt03Xn2MNL/LRN59/r0UnQMRNWxjWVnrqqOBSvho99s26sYiE9XuwGk/M6B7fn0nii/Pl/uffMyF+aeq3PEjSh+RJAGkSGEYCLYdwJZPEo/ymfWrbHkxCw5g8hR8V1xSIOSFKl23Y98n+3ddMkFPf2+qN/LsZ3/JT/9dpdRN70g9j5Yhng6XXwXINWHeK+yenGbwsvgk
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

So, let's just use pte_clear() directly now.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/pgtable.h | 19 ++-----------------
 mm/madvise.c            |  4 ++--
 2 files changed, 4 insertions(+), 19 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index cdd68ed3ae1a..cf328f4d1e12 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -954,21 +954,6 @@ static inline void update_mmu_tlb(struct vm_area_struct *vma,
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
@@ -980,7 +965,7 @@ static inline void pte_clear_not_present_full(struct mm_struct *mm,
  * @full: Whether we are clearing a full mm.
  *
  * May be overridden by the architecture; otherwise, implemented as a simple
- * loop over pte_clear_not_present_full().
+ * loop over pte_clear().
  *
  * Context: The caller holds the page table lock.  The PTEs are all not present.
  * The PTEs are all in the same PMD.
@@ -989,7 +974,7 @@ static inline void clear_not_present_full_ptes(struct mm_struct *mm,
 		unsigned long addr, pte_t *ptep, unsigned int nr, int full)
 {
 	for (;;) {
-		pte_clear_not_present_full(mm, addr, ptep, full);
+		pte_clear(mm, addr, ptep);
 		if (--nr == 0)
 			break;
 		ptep++;
diff --git a/mm/madvise.c b/mm/madvise.c
index cd9bb077072c..f3cda54c1d6a 100644
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


