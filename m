Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E25BAC54F55
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8936B007B; Tue, 28 Jul 2026 15:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C89B46B0098; Tue, 28 Jul 2026 15:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0A66B00A0; Tue, 28 Jul 2026 15:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9447F6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:29:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AC421C0C80
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:14 +0000 (UTC)
X-FDA: 85039173828.19.B8C844A
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4A03F8000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:29:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="NYFcB/DZ";
	spf=pass (imf02.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785266952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4YgO1orHjh7QIzz77gxfj0yhNZhXEz+zslRmT6LZB60=;
	b=daxijFiVLmxlIFLhE2a3/WJVeMVPUPNYWTdqNB8WnzM8qnT0NxAoqMal6gbUIxVzICpzfP
	DsMxQUcPp/sAlQxQ4NP2fKeE/9GPk2hKKQUPaVdmVCdceDsWIWiFflgY99v4KJfljDcaXr
	JRnRXg52gRUkknnbmI4kfT+j2WOCjvU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785266952;
	b=o5qeVzdgYcVB+YaqvPoyGIYthCZ3QKiSP7T0SUCOqENEmO7J1w+slmjWVxMjDraOxctacp
	HtOHHR04n+RbYulUyxiGa/tvfwrrn0+EWtdMuYiRy72b1lj01hnUHSIOfKkxwWdcKXgtg/
	SLZTdsANl53li88Pp3FqU95RhoXl54w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b="NYFcB/DZ";
	spf=pass (imf02.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.4 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp4-g21.free.fr (Postfix) with ESMTPS id B74AB19F5AF;
	Tue, 28 Jul 2026 21:29:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=4YgO1orHjh7QIzz77gxfj0yhNZhXEz+zslRmT6LZB60=; b=NYFcB/DZhxFwLXso1wBHvSu12P
	Z54Nwr/tRQLeZPVyxVREzgzeXn852D0gr0DWpscGiLG994e4m6X70zI3UAmOsJ3t61L268gmugOwQ
	CzlnkcPs5pQOSz82OilU771q8h3uHBsF0YKzDrmUpFXBuMyoq1hu7YU2vqcfu1YBuN54=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wonU7-00000003rCK-2olx;
	Tue, 28 Jul 2026 21:29:03 +0200
Date: Tue, 28 Jul 2026 21:29:03 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-mm@kvack.org
Cc: Breno Leitao <leitao@debian.org>,
	Guillaume Morin <guillaume@morinfr.org>, muchun.song@linux.dev,
	Rik van Riel <riel@surriel.com>, david@kernel.org
Subject: [PATCH v3] hugetlb: only adjust reservation during unmapping if
 mapcount is 0
Message-ID: <amkC_1Ya6OiUoiLZ@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4A03F8000E
X-Stat-Signature: xcpkuuf4qjsspf3uqakposx7akhrbgog
X-HE-Tag: 1785266952-980024
X-HE-Meta: U2FsdGVkX1+nrrVGgQv6e0VqrzRC3lR/N18f0Lnzl6f4g1zl1aQpfoc2nz6wDSpu9nmF5LnnozpfxE1rEUWZpx3OmzRQPZUWkLp/DVTCcYAwx/53ZP76qM01IMJEh1h6PziO2/vp/Vq93q9mVc0h6JQGzcYqQGEKihpD9xA3Vo/GimxCp3fK3GNjWFaLktMjxFhxZwZtMJR81ydWh4B/sDo33qFLv4cDixWC3+b4iBE/uF+ETt2CBttQ8iSINm1KLhG1ZeWckOFc1A2jxnOtfdZkNUDMUICkJ7NWXSd4Xo64PME/Si4Zr5fiaAEsgpV7ss+epQcFJty1JPOYfmtE8j7d25Yu5xcHead5+UOJFwdazcT/7Rjhx/cElYgz64wEr3/42aTCj+OlYFwrTDvpn6RKLks1FL0wtsUMx8IzgbV9kOrcGEpAakF6eyBJmj+ni32jb70PdF9JMgKlVBbS6VXgvzAKdEVjnCatzUp0XEYEK4t0q1Et8Szdk4GKs5/yBQoecE2fqqv16K1d0x3U55XFu1lumH8jUIouABfCJ+gOvKpuD2AT47gIgiqLm3IYEL+d2YLEmsceqbgxhAv1e0hReHBv22DP+wrKhDELbaKI4Gnm4xnLN/oQHCNp69Rt6yU0I5jnwxKxCWPjeyo064vEo+kS4mlsLFSyQ/4zxAHXuKfmbB/mIoTFpnT+HF/I/g+1u7UNuPtz4TChqYnA0XsT4R+4D89iNATTdvPxkwqpK8MH7s/j8t+rI7PFukDBYUzyDmkT4Ow7IsPHNiPKJGDf0ZOTz74muPtqBCGf2mvSdmpF25kWrDfJbuzK4Kcpu/Zb/qnh2angKuatLBpIVtpRwFcpGqh135zLi7VOUeH2GbRLdflCpg+Bf1zWeoPCQzWJo1i8p7sJ05zfZ+uqvevyJOkPklua4pcDN5xDY5LOEXZoSZrg2rA5xt9Xh9vpx9nrgZkwPykFcYxGMpv
 fQP2l0Qv
 uqWAtRmoNj7YZsNAv+bYnhZXeXJ7yUs5BxSPExxszfbkqit5mvPHegTgsD1iKdSto0X6gkN9qQFzFAA1oGWhwyHLKNTXWr9txnuZIkkzHpVA9O9WoOUrMpvuXX2VF0ay08FWL/gK3v2qZe93cf0HPxR8jdxXWUd4+tdtEsQ2dEoBf4YEtgHUlPLXhmXu7PihG6C4R65XQVRoeyBJsprybXnp5Q0wQqN0B+CPtQIeuv/fUic3wfTqoiVdkncZ2AmXire70i2yewT88KpDgrx4o4nwtMDNSUJPCecsRqkAC403hqDC5RCJyoeB7FajP4pyBgeXBWzyzV0jsuMDCbhEielDvP/0zGOTGRSMhX2CbYoQceez+VNCHUA9N1g==
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
Cc: David Hildenbrand <david@kernel.org>
Cc: <stable@vger.kernel.org>
---
 Changes in v3:
   - Document locking requirements
   - Use folio_mapped() instead folio_mapcount()

 Changes in v2:
   - Document the intent in comment
   - Tweak the commit message

---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e93c4d2456aa..77022c4c59af 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5157,6 +5157,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	bool adjust_reservation;
 	unsigned long last_addr_mask;
 
+	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 	WARN_ON(!is_vm_hugetlb_page(vma));
 	BUG_ON(start & ~huge_page_mask(h));
 	BUG_ON(end & ~huge_page_mask(h));
@@ -5248,7 +5249,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		/*
 		 * Restore the reservation for anonymous page, otherwise the
-		 * backing page could be stolen by someone.
+		 * backing page could be stolen by someone. Restore only on the
+		 * last unmap, otherwise the owner could empty its resv map
+		 * while the folio is still mapped by a child. Note that holding
+		 * i_mmap_lock_write is needed to check the number of mappings.
 		 * If there we are freeing a surplus, do not set the restore
 		 * reservation bit.
 		 */
@@ -5256,7 +5260,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 		spin_lock_irq(&hugetlb_lock);
 		if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-		    folio_test_anon(folio)) {
+		    !folio_mapped(folio) && folio_test_anon(folio)) {
 			folio_set_hugetlb_restore_reserve(folio);
 			/* Reservation to be adjusted after the spin lock */
 			adjust_reservation = true;
-- 
2.39.1


-- 
Guillaume Morin <guillaume@morinfr.org>

