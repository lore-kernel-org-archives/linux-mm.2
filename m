Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F69CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98B06B00A1; Tue, 29 Sep 2026 17:53:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6FD96B00A2; Tue, 29 Sep 2026 17:53:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A605A6B00A4; Tue, 29 Sep 2026 17:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5916B00A1
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6D94120622
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:37 +0000 (UTC)
X-FDA: 85268152074.25.497BE03
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3081C10000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UcuNohDI;
	spf=pass (imf05.hostedemail.com: domain of 3XjO8agoKCBM614tHEt1B0z77z4x.v75416DG-553Etv3.7Az@flex--nilayvaish.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3XjO8agoKCBM614tHEt1B0z77z4x.v75416DG-553Etv3.7Az@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Okt1BYM8cWvy94RHyYjUAgOKsz864b3e7Z1IiAGJ5yQ=;
	b=pusV+8B3xvDQgJPkU86Ec7aPvdgcBUGw204DQLqHuRENUKksdu8cPVf9Cg/ccQPx7+Rzp6
	994IbcVn9v15IOAnRgQzzcZVdnAZZpLiY0AY5+qQtiDE9Mew7nyh0GMXkyFTmwDGD8cFb6
	LVeoF7NGpD/2Q2GLOMoVtUErJj3KvlU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UcuNohDI;
	spf=pass (imf05.hostedemail.com: domain of 3XjO8agoKCBM614tHEt1B0z77z4x.v75416DG-553Etv3.7Az@flex--nilayvaish.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3XjO8agoKCBM614tHEt1B0z77z4x.v75416DG-553Etv3.7Az@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718816;
	b=v3nGbGhh5Jko4gIWQEm22sCrbH3bDGGkzc/IfmdTkdn0azAxLSMiYsQRFcDBcgia7ZujST
	Mqogbs9g8+21LcEAVxQEUU+U2Jv8TN/I1Ybp3Uovct0h4ETflsfUVRiuvpqsJrGclq1wrm
	7OjStQmK276tktP/6aXgL3MoWEoRID8=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-341eff9e381so4826619eec.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718815; x=1791323615; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Okt1BYM8cWvy94RHyYjUAgOKsz864b3e7Z1IiAGJ5yQ=;
        b=UcuNohDIgG/RHixYE9hLmwGMzUC+LJUpx+7xLxZzIL2enR4TRRBxk/VTr+MwuTzmk+
         yzfYNA/pryMu4I1zAKil98RkJUgWO4+Kb5nS+B1ORgTW+1lyNx6ufYn+VVfgVs37JRuw
         EfqYZzFW1iazfv26iBskcKm/eRkGEkK3CLUolhMTP9Dkjfu2+sNzPc1Vv53vT7lsdIPZ
         5QgI56CTm8+dMWNA+BoJthjeXkv0nd8ZucThqSc0X0sqVxE/jIXLMPm4xJCj8U+fOCk6
         NGw8urB/pWBLdc6z6wBhBXr/ioprgS4DgyLcoP5YnFgs6uP3JQ0mm3ncgda4GeSEvoFh
         zmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718815; x=1791323615;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Okt1BYM8cWvy94RHyYjUAgOKsz864b3e7Z1IiAGJ5yQ=;
        b=PWgydinI4iYMDbsFhnAeJ1tMijuEumAzN1UxzsSVngUQS+zwiGuuItL3TCGwTH9OKy
         ZfB2vQjYBpNYoJvN2CYjecZ+u5I4/dhB5c2W3BEzxQVeDeBxEvVJDzgdRh6UJoaS+aN0
         8kFB/rJmcX50nRYoKE9jvY/Q1nhTqYfeMU2s1rOcBvh1BxzXB7uheVWFW2vnNTbo9b4F
         poAVdI8jKy51x5jIubigQTau54Ih5Gs0dIMnglCzAAdi5ARp5jKpiU0frl1rOr18IhXn
         dpWNifosgwGMxVLCJLspvcbFkWIw9KjX65ZUPHEm0hPAhw9ryZFO7pfvsNHNsDv21tk+
         R8iw==
X-Forwarded-Encrypted: i=1; AKwUvBwwgR801NY6z7BbLEkcQiXjKeWapvIS0CIo36Zw6Tl259OK0zx865d1UX9E9FiDNIQ9sr6+H/kKXA==@kvack.org
X-Gm-Message-State: AFq9FYLVylfHLap+B6aECoa/upFP0b4ZX4xj0yyQt/G9d5RFf79JLfw7
	V8y1FR/YBccLn7A/0qZuHjJ53v0fa95eDsEe9uTzyPGZhbNOXAxkQY8acidL4VheEZwPVbL/z3s
	11T4R+RDJZ7phk/PP7pvuMA==
X-Received: from dycmz8.prod.google.com ([2002:a05:7300:ea08:b0:341:e362:8413])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:550a:b0:341:8ee2:6f76 with SMTP id 5a478bee46e88-34c676c6ac3mr582951eec.33.1790718814374;
 Tue, 29 Sep 2026 14:53:34 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:52:03 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-13-nilayvaish@google.com>
Subject: [PATCH 12/15] mm/ksm, userfaultfd: replace &folio->page with folio_page()
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3081C10000B
X-Stat-Signature: i9etnogfdndibunmj7x94ofc1acn539h
X-Rspam-User: 
X-HE-Tag: 1790718816-909463
X-HE-Meta: U2FsdGVkX18RJE+lP8Au4dVeoVppmSRnmqc/T0lNiUffvk/BCOyixiFDYvtXAnfq409+0WbxCiNQ7ATtSXAFUaJs+eybD37t4dBei2DF3ir7vOMp1qdSIMA0TLU1odNARM66+F3nPCOO5fdomXOFAqiXOfOCHzRlyiYP5E/Ncmq1yyJXrt/P3EknLzioGgrkP3hCB5R1F42S/Sv9pHdlOpkQ+Z+ROXa1lsQCLEppsov6uWmdg74/7VplVrUH6+9FPCX0e5PKe5f2fx1gYQbjTJXJI4U7OsjEBZUEwKPxUxmv0falXK/UuuZlcWfO1oD96bT3uMjiBuZhiB672L0AXyZSvjG06XShqP+fmLDe/mD761yrOtCCEm4csjykl0/XAPblZX1Y1Dzwc6ZbCNhnQl4SyFpn2LjNxTelL+vnyWSNMOh5nyzRErjxIdv4RNs04pv3+0akyEzfksDwkirkZFOfRg+Ie0mBk8j8HldOkyoxhjKlMN3PtpIWYU3S5eaqLeavGjKPFcKAhH/yAVSMfxAkazcnrnF+7qMCIwLMmEohw7eCaS+8030YjHC4UTGWMZdxj1XTXaH+IJm4RdZuG6EzomeZtS5zhkD2tmPc17TuckJnbBKkhsfx8UCrviti3p8sktLEfEt1TUHt1Ivh7h+GEeJc73IPU1Rztu0v35aW5WTgAJ9hrB5120LohkGo7+j/Qxq9lUE2Md6OJ2MEFvECl8Ug/BjT2s3RXyKPE72OFu1IxQIyAGQllNoxdzjFqEMWANOybleLsmhfOHsYxN6vvRn9lZFeursql+AbzohYNyvNG1erXO/1oybkxSM0DzfQBaAngrQ3zMQEN7EIlDXvEYScyNdMm8wItFo39OdLbyIijPCC/ylVO9HHUHNdgNzofuKs9tmFbQ+GmjsPWFR2JDZGmIpyA7MxyKWpmKoN+8ieaE3G1QSg1/lQJU7klVVShc3hhkmP7+w7DFm
 3CPEYQlU
 607VIhfg5X5Cn+yxVo+EV9vwyfdg0N3svhAc3QK6MjrrOxMnXHMCSrooxXeJ9A1kMWsDnTwSlyw/2Gh7OLjmWLuIjByatds9f+w3Vem+1trEDNI7W+F+zJT6z3UZB7C4sj3zje9g1Oe+vFKr+hIM4PKcvTVKdPY0m8dEevXoA6YVu3kyadjsLRJwN5iik7VqvqpLA+r4Tv8KkpuBINvBxfEo31FGOCqMdp8TSWB/TchmiSEeRV7Qd+QgiLZwc9CCrNEaqafsxBNTYHQr08+9FF4c7j5y7ECP3nlRoVwKbEk8xK2n3gyqvfUHye3YBlxfUXxMZ7oFv2PtwoGZ+YDFUgOx1zR3nDEjcHmk9Lwx6maoP3QcFVkUfsPeQTu7O/nix+/E/cni1DdR7YBxVwA72pXaaYd6QguIkqm9YewsNQznDw5QPFBaeT9UFZ6gARkFL8uvIafsKd/ocJpmLWOlVNsN8jQiCoFPae8ew3bMF+Mk/vmCdddJVy8hF1d6GlnSz2qzyU5myWGC1VuatJUh12uiO5N55Js9fiPAMUvJyfzIX22gBo62reVxnR1VhsGjvfugUWSjQPY/xAECHix9FocV7heWeCFLI77EIjevGPaxdDmBVlUz5/5jioTCzq+EpiQcgTFbSXBjKKAjhVXHen+46lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct &folio->page, &kfolio->page, &tree_folio->page, and
&src_folio->page uses with folio_page(..., 0) across KSM tree
comparison/merging and userfaultfd page population/movement paths.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/ksm.c         | 16 ++++++++++------
 mm/userfaultfd.c | 14 ++++++++------
 2 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index f33523a84a1a..bb8c564d9ffb 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1112,7 +1112,8 @@ struct ksm_stable_node *folio_stable_node(const struct folio *folio)
 static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
-	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
+	VM_WARN_ON_FOLIO(folio_test_anon(folio) &&
+			 PageAnonExclusive(folio_page(folio, 0)), folio);
 	WRITE_ONCE(folio->mapping,
 		   (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM));
 }
@@ -1324,7 +1325,7 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 	if (unlikely(!pte_present(entry)))
 		goto out_unlock;
 
-	anon_exclusive = PageAnonExclusive(&folio->page);
+	anon_exclusive = PageAnonExclusive(folio_page(folio, 0));
 	if (pte_write(entry) || pte_dirty(entry) ||
 	    anon_exclusive || mm_tlb_flush_pending(mm)) {
 		swapped = folio_test_swapcache(folio);
@@ -1355,7 +1356,8 @@ static int write_protect_page(struct vm_area_struct *vma, struct folio *folio,
 
 		/* See folio_try_share_anon_rmap_pte(): clear PTE first. */
 		if (anon_exclusive &&
-		    folio_try_share_anon_rmap_pte(folio, &folio->page)) {
+		    folio_try_share_anon_rmap_pte(folio,
+						  folio_page(folio, 0))) {
 			set_pte_at(mm, pvmw.address, pvmw.pte, entry);
 			goto out_unlock;
 		}
@@ -1893,7 +1895,7 @@ static struct folio *stable_tree_search(struct page *page)
 			goto again;
 		}
 
-		ret = memcmp_pages(page, &tree_folio->page);
+		ret = memcmp_pages(page, folio_page(tree_folio, 0));
 		folio_put(tree_folio);
 
 		parent = *new;
@@ -2100,7 +2102,8 @@ static struct ksm_stable_node *stable_tree_insert(struct folio *kfolio)
 			goto again;
 		}
 
-		ret = memcmp_pages(&kfolio->page, &tree_folio->page);
+		ret = memcmp_pages(folio_page(kfolio, 0),
+				   folio_page(tree_folio, 0));
 		folio_put(tree_folio);
 
 		parent = *new;
@@ -2333,7 +2336,8 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
 		if (kfolio == ERR_PTR(-EBUSY))
 			return;
 
-		err = try_to_merge_with_ksm_page(rmap_item, page, &kfolio->page);
+		err = try_to_merge_with_ksm_page(rmap_item, page,
+						 folio_page(kfolio, 0));
 		if (!err) {
 			/*
 			 * The page was successfully merged:
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3c7fd39deb13..a39d7d40a76b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -565,7 +565,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 				goto err_folio_put;
 		}
 	} else if (uffd_flags_mode_is(flags, MFILL_ATOMIC_ZEROPAGE)) {
-		clear_user_highpage(&folio->page, state->dst_addr);
+		clear_user_highpage(folio_page(folio, 0), state->dst_addr);
 	} else {
 		VM_WARN_ONCE(1, "Unknown UFFDIO operation, flags: %x", flags);
 	}
@@ -584,7 +584,7 @@ static int __mfill_atomic_pte(struct mfill_state *state,
 	}
 
 	ret = mfill_atomic_install_pte(state->pmd, state->vma, dst_addr,
-				       &folio->page, flags);
+				       folio_page(folio, 0), flags);
 	if (ret)
 		goto err_filemap_remove;
 
@@ -1268,7 +1268,8 @@ static struct folio *check_ptes_for_batched_move(struct vm_area_struct *src_vma,
 	folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
 	if (!folio || !folio_trylock(folio))
 		return NULL;
-	if (!PageAnonExclusive(&folio->page) || folio_test_large(folio)) {
+	if (!PageAnonExclusive(folio_page(folio, 0)) ||
+	    folio_test_large(folio)) {
 		folio_unlock(folio);
 		return NULL;
 	}
@@ -1306,7 +1307,7 @@ static long move_present_ptes(struct mm_struct *mm,
 	}
 	if (folio_test_large(src_folio) ||
 	    folio_maybe_dma_pinned(src_folio) ||
-	    !PageAnonExclusive(&src_folio->page)) {
+	    !PageAnonExclusive(folio_page(src_folio, 0))) {
 		err = -EBUSY;
 		goto out;
 	}
@@ -1590,7 +1591,8 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
 			}
 
 			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
-			if (!folio || !PageAnonExclusive(&folio->page)) {
+			if (!folio ||
+			    !PageAnonExclusive(folio_page(folio, 0))) {
 				spin_unlock(src_ptl);
 				ret = -EBUSY;
 				goto out;
@@ -2072,7 +2074,7 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
 					struct folio *folio = pmd_folio(*src_pmd);
 
 					if (!is_huge_zero_folio(folio) &&
-					    !PageAnonExclusive(&folio->page)) {
+					    !PageAnonExclusive(folio_page(folio, 0))) {
 						spin_unlock(ptl);
 						err = -EBUSY;
 						break;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


