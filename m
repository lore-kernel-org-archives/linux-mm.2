Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B579AC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB0B6B00AC; Fri, 31 Jul 2026 16:28:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3276B00AD; Fri, 31 Jul 2026 16:28:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFEB6B00AE; Fri, 31 Jul 2026 16:28:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E04A6B00AC
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:28:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A81318011D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:28:00 +0000 (UTC)
X-FDA: 85050208320.27.BC878AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0B044160008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:27:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFIjkNX0;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785529679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9qfPqO6NrOfLYn7J/1lyzBCINOrMbaXhOXxJLpXlDBk=;
	b=BMiOGJD8uv8uOhaTn0jhNZwJpDbZS52FY0ER8K8A9p8f/orQdcz/530G5iYKu56cToGI2z
	ut7xFvQiU4MWbzEkQU+m2i/lclxQ337Flkk9pG5i4ELOj5dO/iJlPVOHsgkKUmOE3gsE86
	8gZD5vAb4juwuFUbYG/QCsyMjocl5m4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFIjkNX0;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785529679;
	b=N3wIUuU2wAaVn0Z3dBjCzvf/uwkyZnctuZ9r3PUrevxinynxwslQa7M7WW7DxbuejsVpOS
	bczzFamfsDAg2DUFejIJVnvk75m8HDrFNJX0php1CEAd5AyFGAF8eQyKv5shitDRnMMFdN
	a1e1Pfzh8M6cuUBCZLBSoW4cSizpKVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 848AF600C3;
	Fri, 31 Jul 2026 20:27:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26181F00AC4;
	Fri, 31 Jul 2026 20:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785529678;
	bh=9qfPqO6NrOfLYn7J/1lyzBCINOrMbaXhOXxJLpXlDBk=;
	h=From:Date:Subject:To:Cc;
	b=CFIjkNX0/mn+iwlSjgM5yeRja1CmlZeC4sfDNOh4l+ry6LAVWl6faT4OZPMJoyYLM
	 iN7lVe/Z1eSsz+AWv50TNXaF3Qh7HkD9Bv6+3RyTPATzXQYuREwbltG/T4cO+jj8O/
	 uTbsUvi1DpbMujI788V6TYeCdIzifxMGxZr+Bb+RTj5qBMhNJD+7UFbT1E+hqscYOu
	 wjhance+0jzDI5wbD2vcDIAXyRbqj/3j6z3G8GM7RBzZJ0MONcGeWFDwu42dKS/2/w
	 p1RJ0bm7O5YLxCcYpJX1AQGHD+GYbx9uwzEaQnCaFNE09S7BktO8Pvoxgdf0sgiCMa
	 lLaTHtQ9MHK4A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 31 Jul 2026 22:27:53 +0200
Subject: [PATCH] mm/gup: fix always draining LRU caches in
 collect_longterm_unpinnable_folios()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAEgFbWoC/yXNQQqDMBBA0avIrBuIxljaq5QSYjLqtJpIxoog3
 t20Xb7N/zswJkKGe7FDwpWYYsgoLwW4wYYeBflsqGTVyKsqhRvQvY0N3kzUJ7ugmeJq2xFNF0e
 KLGqlpdS6udXKQ87MCTvafovH82/+tC90y7cLx3EC44Xgq4QAAAA=
X-Change-ID: 20260731-check_and_migrate_movable_folios-43500556943d
To: Andrew Morton <akpm@linux-foundation.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Ackerley Tng <ackerleytng@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0B044160008
X-Stat-Signature: 1apnm4m1i6b4xw6wyz7squycckfamixu
X-HE-Tag: 1785529678-147429
X-HE-Meta: U2FsdGVkX1+vf5zUPO5/tOOizEZOYoFd8pvDCOovG0yX01T+6hHbdjLsEeMBM+RtaKiFYx33bzOUQF5F7c2/40QHPtV1yV9GZ/mypwHADcPd3krd5om+Eqg9HmB3fZRbIauUdGKp1iNATT+S2xnSz8e8vG50piLCO/ggldv9EpdOFFQZJ4p4S1X5KSMeVZ3j0wFGAutR7QvVqb/xyb3QI5zoRUqu99647AhiN4jYp2IZy2sDlk2bK7R1MX10rMwMCFCSbBSUnDR27VJ5h9scj7YKyqExHB0XmbstyAEwW9qOIQ3iZemW0inga51wWCR5mgQKQTPEty0k2BpgmGeV2dkDD9Z8aDq4n8c+iZ8spR+qBuYttJgg0pdQkdIy9mQMnLuSgLjso1ShFp+JPP6SzpQsYln7vqXSnpU7NzFmXT2Yn9dpnl5NEBqwWm2OYkpH8ge7kmlKuPyfYc8YMIkBm4wMRoxVeJGLZRhnaJIZL2y81fZ1CxOAXMfIK/1/XwHZ0EQDWYO397mVQHC7Ej0cEuWRh1pI4NmMlKhHUFBoP+9BI6W40z8PYmJAQQwwPU0alnIF/uA7WkfoocYwOPmAypgv0NeZ3Kge592hwyvIX9u/b02XFx0e/8zV8dpicP09vzbeRKP7IhEPv6O8jCrEd4Qn76yPq5MA7u/V2o4OmFvd8ObHnaRBxiwvY7yn29zJWWr7+CJmuLjBn+4ex46bEtxd/7Wzsc4Ce7ILGsIGu4g3qYcG9A7mammC9rFvLaV6KNMs42bLuC+fWgGmqDtR4vamvsxP1Zt2Bg/53aXZAucgrAFxf9PqTjYf5JwFO6jbEw9AfGCqsQ0BqjpMYMrF0sNWVWoKCVAceDmwWBmmWZOJ9BaNRD91Amyl4KXl5rYoJHnvLxY6S/glx1jL87GzGvjm1D9pKBmNwevF09KPZFhYbN9VbGru1sW6TcregHENrzLATEAOUX+FuwXfL4O
 iA7XIash
 UsvGEzZBn7xbfUHtfx0FuHPYdZ0uK/df8c0b9Wimep0CuFyeIT3z7XFskpe0prSU7AXJMjIzqD4ZvB0LD+Wm+Ds/tuK/Lmy4TKHDZQIcP5lb4xDfCtzMhnN34bmMH8tQNuUEU6/lCvdJ3pbMHVomT2gBuRFYYcspHCIUmjVWtzlkWPU6kVykqgLp10W44T1DhkHsmwAbqWtQqH+phVqxhrWvMM8/HhYxzyD2l67+Sa+ObHEevAUgDnJWj6DEJ5jvl5sMr7PjsUorJp5WLQ6jdEhkCe1er0s0kqio3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_may_be_lru_cached() is currently only true for small folios, and
for small folios FOLL_PIN adds GUP_PIN_COUNTING_BIAS references instead
of 1 in try_grab_folio()/try_grab_folio_fast().

Consequently, our

	folio_ref_count(folio) != folio_expected_ref_count(folio) + 1

check in collect_longterm_unpinnable_folios() will currently always
identify "reference mismatch" and first drain the local LRU cache to then
drain the LRU cache on all CPUs, as collect_longterm_unpinnable_folios()
is really called after pinning the folios with FOLL_PIN.

Add a comment because the current code is not quite intuitive: we used to
drain only to make sure the folio_isolate_lru() would succeed. But then we
also started draining to make later migration more reliable.

We'll refactor that code soon a bit, to also make it usable in other
context where we really want to remove any references from LRU caches.

Let's add CC stable, because having an easy way for excessive LRU cache
draining on all CPUs does not sound right. In common scenarios we
don't expect to every have to drain.

Fixes: 98c6d259319e ("mm/gup: check ref_count instead of lru before migration")
Fixes: a09a8a1fbb37 ("mm/gup: local lru_add_drain() to avoid lru_add_drain_all()")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
Found by code inspection. If someone has a testcase that can easily
trigger this and result in migration problems, please test! But this
change seems to be "obvious the right thing to do".
---
 mm/gup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 99902c15703b0..41c3317e0f0f4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2273,6 +2273,7 @@ static unsigned long collect_longterm_unpinnable_folios(
 
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
+		const int pin_refs = folio_has_pincount(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
@@ -2287,15 +2288,20 @@ static unsigned long collect_longterm_unpinnable_folios(
 			continue;
 		}
 
+		/*
+		 * We drain not only to make the folio_isolate_lru() succeed,
+		 * but also to remove any other folio references from LRU
+		 * caches.
+		 */
 		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain();
 			drained = 1;
 		}
 		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain_all();
 			drained = 2;
 		}

---

base-commit: e5492213654050379e78ec6f9acfd6c9fe00f334

change-id: 20260731-check_and_migrate_movable_folios-43500556943d

--

Cheers,

David


