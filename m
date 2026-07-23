Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73BA3C531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:12:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 044E16B008C; Thu, 23 Jul 2026 07:12:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01CEE6B0092; Thu, 23 Jul 2026 07:12:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75ED6B0093; Thu, 23 Jul 2026 07:12:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDB026B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:12:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 388811A0457
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:12:09 +0000 (UTC)
X-FDA: 85019777178.05.86FAD9C
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4EDC7C000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:12:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=JP7+pHnZ;
	spf=pass (imf10.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784805127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SB9aeDNkucvQoBpLyOVSArAzJd4jwl08LL0fpS0g23k=;
	b=bbD8M7mvMIaEQa1YzOWlKytnm52sDqi8crcwQll+gAMD/4pJvN7V6BXltHmjxuStxPUoiB
	2c1/nX6hkuqCDJ7eMWBZHeFbu3Xzg8vJFGHBm9A0Lrf8LK5MXcoPT9rNKZK81KWKuto0RU
	mH8SmlBkpbH+LyzDZgV4BJgfqbgRHaw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=JP7+pHnZ;
	spf=pass (imf10.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784805127;
	b=3Hrbx6JHmujeu+zRZb/sRK7n/cHmnzGY/hF2PMtj3AszvbdkwtX1oXMZRLCKomNaWIvKPM
	W/BbpZyuQaNava85QYMfTE/vzFygj0wzF9Y7JwRhOfPZFs/UpG/Y+GS4BGg4Vlv3kAzP8q
	LNrqWBHVCCACj37nBFjczOn87MmzF/k=
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id 2558619F576;
	Thu, 23 Jul 2026 13:12:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SB9aeDNkucvQoBpLyOVSArAzJd4jwl08LL0fpS0g23k=; b=JP7+pHnZVbCBaSa1kZwd5jx2XA
	R3X6m4joIiSW5Zai9+G8Zv++sjY0PIuR2Royi1Yo1l9rk5mDFda4GZ+7TzdYnJ4NQW57BMGHI7yzq
	NtPEzmoj/mtyCSgz47Rj/josi5HyhpzlwrfLI0YFYLutXKD4CUL6CE93Fm70KmIpcoWo=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wmrLN-00000001BSW-0aEb;
	Thu, 23 Jul 2026 13:12:01 +0200
Date: Thu, 23 Jul 2026 13:12:01 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: Breno Leitao <leitao@debian.org>,
	Guillaume Morin <guillaume@morinfr.org>, muchun.song@linux.dev,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH v2] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-ID: <amH3AeO-PeAQoc34@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EDC7C000A
X-Stat-Signature: knnttcq4y1r5681o7egzq1knryo7ottn
X-HE-Tag: 1784805127-216506
X-HE-Meta: U2FsdGVkX19NIJ7Z7c7VRJmoScWJ/hZsvyJ2olr5ZILr7appriM9LRJQJhRFQBd0Uc7UB2oPSnD/vxkn8gOju2Yvy/31KkkV2hBJw321llgh6NSs5XH4tBWr3anQvE/csCQgBsi/XjiUYf5V43u774XtsXfRVjQb9onTmirZXCcpvpE+g2wyMOxUGeYStpkJcAErNsdr5g9epdIyKeSOoYgh/1WRCKvec835zsZBiJ3MiZSPssylQmztsUub4lrwLTfAFDxM/sKV7dRa+PQTi7r2s9w5pckVPCmo1oHUMao7jvZK8t2ob7EWV7Rxn9ZJYQHuSLUkPU4f/Y+rO3uzRnzUFq87aEMLAnwJrjvvZKvQNBXmjMF7Bbqy+w+XuFJONkWgQsNlyvrQMGinZhGTWxjRXSevz2ZAkK3g6VI5LdMOfRHwpRopAQF3lqO5ItEGFYo+xyLsmLclx3k/E5kpU1DTeKsv2Vu/j7luEc32UfqfVZTTtYzK7rf+Str7yxEWJrJ8QYy/lbjkWmto02KfWYOUhVbFkPPe2ojpNtjoUhFRlk8DgLVqxkgPp1RsnXUht2ro49EQPJ9jj1pDJtFJsixidMNrndoTpcfvSg+0mvyQ2nulMkywBnInRhgfjkTIVfvdWRX3oGubPA5AhSD0yne/0iQgBisbYVRsbG/BfqbWs1DuplYGLHLAdFqLlAzv8ndt2KhswaMkomukZkpN2MlMCE47KdQrlluALzgRhCTpJTbJ+tOPpRxS1mF5IUIbXJiuXJtL9n/064rpmKtVgidB1Pmu2OWnO/7CsymBxCOga9J3nWnK47V/5kU5Gpw6e2KNF/GMM4Dv3wGDM05Ebf/42MFJF/HQ+qCjB24Z9W/o+7u9VzLtQgYUUvhwXqOsk+Csup06xhE9ABHRuDSjtYOnj5uCJXYFkJvegelBSFgYdgGoyb17flokkIDkD6jeFVwbFsatdRiOaanMC0d
 7R47z/6d
 EkxYmsw7m642+hl/KOcx6Py9zsMHAGpGIbnmdX56d22Pm9ubOG0t8+TnDVjZTKWeszNDWdvQrZkRhmKrTXx24mdcUI9CjIRd5tgq7s9r18jgcye2Oif3yWaqk1v3Np1T+7Yo4nNPFjSswPz/jCWLdNkxDYOx/oUUrq3m7Snvj09Icc83IYnUBX3Y+N2/PtziKvwgW5MR+aNz/GjXztr6neRGtuJDoO0i2Hd/yCDyELF22A7lRILk4W4ZGX6O455lDvRzg9InVd7tNaBlcsNKG/22fcrR7YqlFulD+79NdRIIn+iZSJsN96A6O56kGe0QGvBpB5jHO8rQGYYaoD6P0vqMbQGkpjC2RwJjybbo11fQ6wycsfIbWzQy0+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since df7a6d1f6405, __unmap_hugepage_range can adjust reservations. In
the case of folio mapped in both a parent and a child, if the parent
unmaps the range first, the reservation adjustment will result in
an underflow of the reserved count. Once the child unmaps the range, the
count is restored.
Change __unmap_hugepage_range() to check the mapcount before adjusting
the reservation.

Link: https://lore.kernel.org/all/alEJkwn5VlTTH_ZX@bender.morinfr.org/
Fixes: df7a6d1f6405 ("mm/hugetlb: restore the reservation if needed")
Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
Reviewed-by: Breno Leitao <leitao@debian.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Breno Leitao <leitao@debian.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: <stable@vger.kernel.org>
---
 Changes in v2:
   - Document the intent in comment
   - Tweak the commit message

 mm/hugetlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..3feeac0f8eca 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5244,7 +5244,9 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
-		 * backing page could be stolen by someone.
+		 * backing page could be stolen by someone. Restore only on the
+		 * last unmap, otherwise the owner could empty its resv map
+		 * while the folio is still mapped by a child.
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
@@ -5252,7 +5254,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(folio)) {
+		    folio_mapcount(folio) == 0 && folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
-- 
2.39.1


-- 
Guillaume Morin <guillaume@morinfr.org>

