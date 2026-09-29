Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C19CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D93AF6B0098; Tue, 29 Sep 2026 17:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6B826B0099; Tue, 29 Sep 2026 17:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C818C6B009B; Tue, 29 Sep 2026 17:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3B46B0098
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29DD0A701F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:26 +0000 (UTC)
X-FDA: 85268151612.20.54B4862
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7799340006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f9WJTtIO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3UjO8agoKCAcupsh52hpzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3UjO8agoKCAcupsh52hpzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--nilayvaish.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bJjhQdW+p+tLNJzNm6XENykAkGAtvvXL7czwPhgmpfM=;
	b=wshq8usvv/TE4mlGt2AT2zd5mSwVUWCZb/B4CDY5m84+VuQoqUG1o0V0cdujeuoA3mbh+u
	7xlwaClJlAY5kxY6AorEzA0UUqOmujmSVNJRH5//MSb9l5d9tn+8Ihke9jrFxiBBvpdF5c
	4If136Y5wYPIA3ZW5yIgW/dZByuo03k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f9WJTtIO;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of 3UjO8agoKCAcupsh52hpzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--nilayvaish.bounces.google.com designates 74.125.82.200 as permitted sender) smtp.mailfrom=3UjO8agoKCAcupsh52hpzonvvnsl.jvtspu14-ttr2hjr.vyn@flex--nilayvaish.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718804;
	b=Wg6fhE3nSjB2uQcI0utqgT+R+lQ9DCOVyWXWJ7gDSBmDaG4ehjr70K/cbiK9oP9VHA0d5Z
	MqcjUXuSUUvCk/Nez175g3AQPQ4BXtQt55Lmc4h30o2kYPhO54r7lYqpE21RW7qmUAq8XV
	4Roq5kgvoe6wWdPhGx/gGbv/jelO4kU=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-34344599f01so3532840eec.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718803; x=1791323603; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bJjhQdW+p+tLNJzNm6XENykAkGAtvvXL7czwPhgmpfM=;
        b=f9WJTtIOWUfz7+3n7pGSiGwYi7dN1zyaGIGUhKHU3QEC82GqtKL+NUKCHJ1LKNhClU
         UJNAN+huhb40SkyNVscrexqBmdKpsSNZTcLmTa8xAPLNZvoC4mF1pfOglRgaZGrKmzhd
         inIbgvSrtC4BFj1riWuE3GcV/n1qFh1Yk4Gmj+gghTAnzL5HLKZQS8h7toQSKvWrjHMQ
         vA+gjMA54WlP2wJb/OJgEYGugRHIRUfOsQHEJIWLHXW5IoG1x4rgHvuIeiNjpjzAwn+z
         e8Xh83XQs8mDmwbumvZeISrBY7DwHV3X3Spp+o04HcLxW3jEjmbvDCZJ0FPs8awgA0xb
         JDXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718803; x=1791323603;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bJjhQdW+p+tLNJzNm6XENykAkGAtvvXL7czwPhgmpfM=;
        b=SNGLMUoO5kVBZf50+ssv0DwXpUiRp+0OMFUGGHhHwc3ZV3VD9/QRQZIeAWx6q11LrN
         ITHBmAcMNkoYrnB2dPUyKy5MeuTiofIJ825WwM1ZnZ17sh21G0XY+87kX4dLg+RB7zSM
         etbWDvXaZMLg9ZXq7GGbs6fCK6ISw+qskQmmr3fFEi0g3GgJb6Uicu5cThAYRBlFdjbL
         pt/lBM2ajjuXxnR5kPB8MgoWM0Ve9l5yvokNkFz39Hw8yayLKiISngAKKkcRnAOEd40w
         FSx62+gBnsE+YgrRQ+F9TvrNVyUfr09WFgSYZDzzdUD/Nevdu5XQW5ejJjoR9Qjy0j8L
         aqog==
X-Forwarded-Encrypted: i=1; AKwUvByL5oicqk1leJAGQfw3+lAyMRdgmOHJfSPKUVIU94ompgEKdUHFM8DuNjl3cXHvfKI+/vpXOvui7Q==@kvack.org
X-Gm-Message-State: AFuF++kTpegi/a+tLrS9YHDZgPA2PE4michFifo6GEPQaAw5/e36Rbqt
	9jhlBpLonaFaTKpl5Bikw8rjfkPEOUR/jBgMvqvHwzazsJMVbeNmpzyM1PvizGQxIwkT2T7NOnR
	F8tGhGvINlTczOF6qxjh11g==
X-Received: from dlbrj21.prod.google.com ([2002:a05:7022:f415:b0:146:33a4:4ffd])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:451b:10b0:146:606e:1f62 with SMTP id a92af1059eb24-14c9e29a175mr556620c88.41.1790718802962;
 Tue, 29 Sep 2026 14:53:22 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:57 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-7-nilayvaish@google.com>
Subject: [PATCH 06/15] mm/hugetlb: replace &folio->page with folio_page() and VM_BUG_ON_FOLIO()
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 7799340006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: kh698mihj835ygerazn5w1n11o5wdda8
X-HE-Tag: 1790718804-589330
X-HE-Meta: U2FsdGVkX1+KgHI0EtrTThF36D4g0okP8JDawRQ2VjEwrJtX2D/5xfsVrE1fl8SLJCzHcrr8qm2/vyOw0nSZm/48lyFSPlCRyEDXakqjuhzQ14QvluVetFjauG0J10Q6iaqtwLsjChZozQSazlI/IlXDjTzxyMm6tY5UkUoFsGOhNzIpvD1P3Co9cZEXN06kX/G3WMuHfmtm7SIy7L4CU2njfOI5kTijOKoH8N7fshVwKoJXLa4qrHuheGU1OM69sSK8tQs6yWabLotCrycKmfv6jBT6JhNEWvBlHbwlhvgJNfQJeNZ8Ku57Z31oPb4UxvHA899T0+0P7GEeym289VJXKXLnmcB5LY2ue+4r/DCvkb5bKIZ8otJ2+VBQ0DCH/8KPV2ledrXWKh/tjvGgwpKauULhoEqrAChAHe5+fGe4yZ01CWfrPkh8uQST3TUmXRXSIf/brFlWiTwKBRfDb6OoXEFrWPjYWo9S9oJ9WRhzOhNBvKHw8XJRLCWg8NpZvBNWx9K0gJKpH9lv2j3af3gWXCkFverfOaJwRqVs+HZxx+dLVvLJZImOQExLinVADDPdiJtdnHmjMDDIuemVUl0S14sh3c3mFesbTOc2JncCoFHNtCJgSmy3fndlT1Ifer+rrR3DsWTx80f/AspDGcQxVQTeThtDCZb+5bRdeKrPEK8JL2xkeZoLgCd8jUuOW0tnh0HBMipCgsJ1TEmQOh0laDezsbH/f+0LWacpl8DBjA+9Zzei25P0C1ufYdE9erlsr/HOynwuCMHxjAhw+4F0phFqFIhJ2liq8ddjEr9mrodyLBO6ielelvnpARFd+97v7IFkTsM7SIzLRLDLJEm2DZcrDTcqG4sYMsYhK0/jQXxi2capH5KXxEMEofqlWzkoVy/2t/sFr4+5RAxFZ8qqMwOYRv8vobjpHPJXjXo/EjVV/uBuQBJ/caY2aa3id/hqmvKmUWQt3AdiNkO
 BXt7ri6i
 /9BaUtgYZs/rQlmjZwl+Oc+vMZc8rVORRyxXl29mDmdZl5EjaICHQz1vqIBZ7uZuXaeeOoS+R9Wca08fPtBmwaPxGEtD5u9Y2ZJxSmY9UteajJNu0Eh1o0P5NTOqwh+Nji37vr3+6L3VpL/3pBGQ9AzuVzl09pmUcD+fZmpzLoEkRiP2erKf4j5fNEougdXFmHleGyY9xveVDnj7XFxzv6LeE9CSbDhbc5C+lsu4oyB1IfHfjMP6bvghZAK4ChzPViAowrLrFT0O1bOFApi8zmIuTm+z/+z7dn+UtNiVQPQ2ZC/cwqAOR0jNTzynGy39RaQ7sK5U+vdKZu8hX3DPKzwlVx+6tZVcOwuzoz4CbmBqVMkjtPVkeWrZ5w3Ba2OqIdxZQYynriAbF3efDkukY5VL05lD+rhBJaywHgu7fwytYegz2Uu1L/7LGaqRqi/SyKXrneRr/qPfSp34Vo7wNPY8XeAYaHK7wBlUBn7bB131InXRJVmK/LEyKBxAuBaKA++rOuKTQS8jWIxbCCNdr+KaahZQrFUjvvLRZCE24hRhU+rhU19AH+o/KRWRwMW6vWxF2T2WY/oOF7DqvpHVFU7PlM7qvGwRCqbTRV6NARpofm5D7ktCfZjZX4wkvuRDMok9ws3sxtAfS9vdlEbiIqjqufA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct &folio->page uses in mm/hugetlb.c with
folio_page(folio, 0) and convert VM_BUG_ON_PAGE(..., &old_folio->page)
in hugetlb_wp() to VM_BUG_ON_FOLIO(..., old_folio) as a 1:1 replacement
that avoids referencing &old_folio->page without changing behavior.

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/hugetlb.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a1b51251103b..31ca8777ccba 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1274,7 +1274,7 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		if (folio_test_hwpoison(folio))
 			continue;
 
-		if (is_migrate_isolate_page(&folio->page))
+		if (is_migrate_isolate_page(folio_page(folio, 0)))
 			continue;
 
 		list_move(&folio->lru, &h->hugepage_activelist);
@@ -1511,7 +1511,7 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 	if (folio_test_hugetlb_cma(folio))
 		hugetlb_cma_free_frozen_folio(folio);
 	else
-		free_frozen_pages(&folio->page, folio_order(folio));
+		free_frozen_pages(folio_page(folio, 0), folio_order(folio));
 }
 
 /*
@@ -1701,7 +1701,7 @@ void free_huge_folio(struct folio *folio)
 
 	hugetlb_set_folio_subpool(folio, NULL);
 	if (folio_test_anon(folio))
-		__ClearPageAnonExclusive(&folio->page);
+		__ClearPageAnonExclusive(folio_page(folio, 0));
 	folio->mapping = NULL;
 	restore_reserve = folio_test_hugetlb_restore_reserve(folio);
 	folio_clear_hugetlb_restore_reserve(folio);
@@ -3238,7 +3238,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
 	 */
 	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
 		__init_single_page(page, pfn, zone, nid);
-		prep_compound_tail(page, &folio->page, order);
+		prep_compound_tail(page, folio_page(folio, 0), order);
 		set_page_count(page, 0);
 	}
 }
@@ -3259,7 +3259,7 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	ret = folio_ref_freeze(folio, 1);
 	VM_BUG_ON(!ret);
 	hugetlb_folio_init_tail_vmemmap(folio, h, 1, nr_pages);
-	prep_compound_head(&folio->page, huge_page_order(h));
+	prep_compound_head(folio_page(folio, 0), huge_page_order(h));
 }
 
 /*
@@ -4004,7 +4004,8 @@ static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
 
 		list_del(&folio->lru);
 
-		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
+		split_page_owner(folio_page(folio, 0), huge_page_order(src),
+				 huge_page_order(dst));
 		pgalloc_tag_split(folio, huge_page_order(src), huge_page_order(dst));
 
 		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
@@ -5605,9 +5606,9 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * be leaks between processes, for example, with FOLL_GET users.
 	 */
 	if (folio_mapcount(old_folio) == 1 && folio_test_anon(old_folio)) {
-		if (!PageAnonExclusive(&old_folio->page)) {
+		if (!PageAnonExclusive(folio_page(old_folio, 0))) {
 			folio_move_anon_rmap(old_folio, vma);
-			SetPageAnonExclusive(&old_folio->page);
+			SetPageAnonExclusive(folio_page(old_folio, 0));
 		}
 		if (likely(!unshare))
 			set_huge_ptep_maybe_writable(vma, vmf->address,
@@ -5616,8 +5617,8 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 		delayacct_wpcopy_end();
 		return 0;
 	}
-	VM_BUG_ON_PAGE(folio_test_anon(old_folio) &&
-		       PageAnonExclusive(&old_folio->page), &old_folio->page);
+	VM_BUG_ON_FOLIO(folio_test_anon(old_folio) &&
+			PageAnonExclusive(folio_page(old_folio, 0)), old_folio);
 
 	/*
 	 * If the process that created a MAP_PRIVATE mapping is about to perform
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


