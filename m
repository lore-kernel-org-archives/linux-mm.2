Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB14C5DF9C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:10:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C69ED6B0096; Mon, 24 Aug 2026 22:10:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A756B009B; Mon, 24 Aug 2026 22:10:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33AE6B00A2; Mon, 24 Aug 2026 22:10:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8A03B6B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:10:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E3855A02CC
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:10:36 +0000 (UTC)
X-FDA: 85138162872.13.318158A
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id E570BC0004
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:10:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JniZxRFc;
	spf=pass (imf28.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787623835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fqz/IppBFZNSiXxLuZJ0TqRQwlSW6z7COhswY04kJ74=;
	b=HNkJZ5Ro6L/bnc6aHNY80nOEmXRQpDw0c3TPjuijZj0L0Aku4z813Rpg6NTirjio7Vxxzn
	oowbYJIQF9MP6KIyHZSTK3fLHct5VpN9GFk3vINCKB4bNfjjwKkMnqAAXr3eB5DHwQkNjB
	qgWCnryWxkJxDSnwoqlaDK3nXBnDeko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787623835;
	b=hfNWyJYKa4LyyVYTFE/6Vy3CK8OTjzrnGWicbX5FKwOr7KhhOHnGCBEk92D1bffXqxrNMY
	CY0tjUQ6ISxK+RZNfsPHqKL4oBiUEKIL9U2ARkBJg2qUBF04bZkoQaZdBIKIpxBPJFQhFL
	WLA3MetimGGl06YMfn4wTuGgD2tuCjY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JniZxRFc;
	spf=pass (imf28.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sz2kKPbexaSAMQ67g6lWgaRO+H52ytnVjVAZyyUbZXc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787623833; v=1; x=1788228633;
 b=JniZxRFcSNwVQ4T8iie8WOcb1WCcFwqd9LrpUgrC/0lndZus9EGo+/cB/wOGz6XMiENohjuH
 JEVluGpTfXPiXe7Zkub5vfp2RG510Os1TRcnEov3svEhG070y8rPAsiWU00/aGLP6Ony+75UKJJ
 HLPnVXj5l3GKYDrJQP8ivCvU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.160.239)
	by smtp.migadu.com with ESMTPS id cc9adeca0ea53b17;
	Tue, 25 Aug 2026 02:10:33 +0000
X-Mizu-Trace-ID: cc9adeca0ea53b17
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	steven.sistare@oracle.com,
	vivek.kasireddy@intel.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/hugetlb: fix resv_huge_pages double decrement in memfd error path
Date: Tue, 25 Aug 2026 10:10:13 +0800
Message-ID: <20260825021013.25672-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sgr1rdz56sa4yzgws1qm4cnbmnknx7c4
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E570BC0004
X-HE-Tag: 1787623834-853040
X-HE-Meta: U2FsdGVkX18urLp2iaI/evVcddBekHb441Daapc65wALA/nUXUEipvUH6pUK4/Cw/E/4iYHRMpkRKl9JocjVB962B1hPz+VoX3Ac7kha34y3pY3Ta/DfCcb2nnp+JEnqQQbfKDRbdnCOorUj6ZsNYgoZEpSt3GpYMukEp8Nqc9SW5KpvCW1ZIL2UwG+tKsUSqzueD8/U91aTqZ1hf3DB/5Np8TUSyH0YYZLQS1PUnD+XfHNaSIK1LjKHV/I4qhzj9dHs/b6wBT0OCAjidIvVRFyevdhtyTcjJ2q39oGYZR7idt1F1pZ818TUEwdbkgbDz5xuhuKxM4HBIRCr+WpNckTh3QVMqpBvaXpcEEPV6vp83KgbuGOJd2Um0OOcoh8C5UvYoEeBYFWKTxJdGWX7UIRj028ZpNoi3gP/JgWeBTBE8ezauMCDKD8gD3dXhIV1uHI25gr2pXsTpKHs32nE8MAsdLJE97fnvdFrPX4C/eam0ZLZA3qcaMbWDy2/6gGq1F1njq9urmpP2X3S+QIXKl4X6v3LZTBBUwip7NPbArGuh5O4eFvb7Dsw0cHyuM20dbW6i9AuGQuxlWeduhgvvZ7sgvP2n8zHVn+CjZTCOHLf17X/cDqzB0WMb0FiHPIVFdaAnfNADvC3LGrrb5FtOicJDB5V51fO/7Pi2bIsAcbB7yY+zAMSHUg9NKetEHAPSAlHdStX05eaGRTI+en7y1cr8SATC0ZRWOWBOnS+Tl01UTbl6E1aYtM+DI1YWVkJsdnipqNBBE2BymivIwLxONuclqqfQ4A/1/jOsfYQebahrCL4MhYfy5fXxHQb1l0ymPWSINeW4qS4PyzrR+jGD7VhmT4VvM89InxBIvVLHNZS8R91x7QCacjp1NYUG6SiDVi//EmCqCwS2yaRZrSwilb1ibbt5f2GlwmvYr67T9nMEWT6X79SOk9lMWdQr/Etx7Lr9K8uFjJ7+VnswzK
 qwxqenhB
 UY3qr2Ydk1GqBd6STv4MVbyRCo32e1XIASo0Ei+UgDZEfDeBDEc6GjYKToUucsn3sgoLjZKJTL3Xs7VbirHqEafgAzPPDMS2NxJ6okPyyV+kayjhgT/hjYfLzOBbhwRt/FJETSoVzsSEFmhG0U6hGThDFwtkcZwqCtoiD5V03n4T+buBYV+VwTOhx47qrMD97j39olhTiev+PTh5pzu9KJQmTRNfFSR1BLKAz28JFNqZLTND2ncsI0fA58dUnw/7SGXKZE4ml9yxEytXp0ykkwjk9Mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

alloc_hugetlb_folio_reserve() decrements h->resv_huge_pages when
dequeuing a folio, but unlike the use_global_reservation handling in
hugetlb_alloc_folio(), it does not set HPageRestoreReserve on the folio.

Its sole caller memfd_alloc_folio() pre-allocates a reservation via
hugetlb_reserve_pages() before allocating. When hugetlb_add_to_page_cache()
fails, folio_put() drops the folio without HPageRestoreReserve set, so
free_huge_folio() does not restore the reservation. The subsequent
hugetlb_unreserve_pages() on the err_unresv path decrements the counter
a second time, leaving resv_huge_pages off by one for every failed
allocation.

Set HPageRestoreReserve when consuming the reservation in
alloc_hugetlb_folio_reserve(). On the error path, free_huge_folio() then
restores the reservation before hugetlb_unreserve_pages() releases it.
The success path is unaffected, as hugetlb_add_to_page_cache() clears
the flag once the folio is added to the page cache.

Fixes: 26a8ea80929c ("mm/hugetlb: fix memfd_pin_folios resv_huge_pages leak")
Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/hugetlb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d8849196ad9b..fadfe1dbc047 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2178,8 +2178,10 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 
 	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
 					       nmask);
-	if (folio)
+	if (folio) {
+		folio_set_hugetlb_restore_reserve(folio);
 		h->resv_huge_pages--;
+	}
 
 	spin_unlock_irq(&hugetlb_lock);
 	return folio;
-- 
2.54.0


