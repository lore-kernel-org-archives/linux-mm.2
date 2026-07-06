Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD1A0C44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8118C6B00C1; Mon,  6 Jul 2026 09:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF4E6B00C5; Mon,  6 Jul 2026 09:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A6B6B00C6; Mon,  6 Jul 2026 09:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31CD36B00C1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:22:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A22D2403A3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:53 +0000 (UTC)
X-FDA: 84958417026.15.CC71DCE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id D5793100013
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:22:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FUzebNgt;
	spf=none (imf05.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EE/d+RMTPVzbG3WmUqZoiBzBIiZmUPxVyyicskDG5KE=;
	b=0LLvZ0GcvDv0OWb2FeH7J1pkLZCq6pLVqs5+2pHYR4mavipWuvbb9ZKxZI3mafl1eyXLTO
	LJnK6wZoSHowR6vnOaKpqaX574e71vQqMam2rLwTP6bIwSAaxOhZzrwW8niab2l3HPotns
	B1nGHDtdWK21HgQ2LDxDxRzAqVyj4s4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=FUzebNgt;
	spf=none (imf05.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344171;
	b=QaL3V/D8jwFNWSuAmNSZqpJvb54Da/MSggGdIOgc4vGhvsDZntPrxgs3mzfRONtaMAC/r8
	O3ySjO5vbLsOjZ3texAyg1CXYhm0DS+MO/UfeMrPocwD2eDaTTpjhIy9xboIsbA6AkTKyc
	xc0+d0hJmEL2ULRarOBAbAp4dKcXmfw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EE/d+RMTPVzbG3WmUqZoiBzBIiZmUPxVyyicskDG5KE=; b=FUzebNgt8iEGaL1IwYnK9m63J2
	ZeEnmCkBuvbEm5nvk3dXRRTgQdLM+IC0SqdS2XcEAO/W68EAIRza/Y+4mYZLyu4Q2irBUtj0bHXh9
	O9XC81n2QAODQM1q/L6R73QMgw9C550mp/Os/UhmCc9eSMQrjQr0gE6BqiXW/CKykELV062f689+v
	A0dDZbv+2oRLS9YcfdJVT9Basb80LiHAodUnDTGOp2tUkE1CaVZGsVsU/lIm1DLXH8N9oSOArsx/E
	qneB2n9eZ+7NUpCdgbsEJmI6JbnLZbsZT3c7rkQvSaxTWCAv9EEa7/w5lxa4C5EqP7xbPkKJRxTNM
	QZhMRTgg==;
Received: from [89.144.223.34] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgjHc-0000000Cac3-2UCa;
	Mon, 06 Jul 2026 13:22:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/swap: remove count_swpout_vm_event
Date: Mon,  6 Jul 2026 15:21:56 +0200
Message-ID: <20260706132206.935272-5-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706132206.935272-1-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: kfnn1n9mj6h7wbpb1hx5dfrnqwsbjrrt
X-Rspamd-Queue-Id: D5793100013
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783344171-792572
X-HE-Meta: U2FsdGVkX18t2rPcTXWlPs4rehVjjcZdzDx+kvGIx2pGRnTPy0DOm0zwLjOJwLlHkfiUH4PRmfo8k9Td6agXMq97VXDeG+1FVjr3R9M/q+m0qHGy9i25OZqzTzelFEl1N1c6pCkWE1aPOqBi5f3ehZ/+yOFlC2EH0WO7klRYw7hAdUTkv3fsE5/Kn20ZktN8wQhz++SwnE3bUx4blSNfN8sSanRP74Ra9QwpXGyrqXjw5J2r6oOWZbWqYehFvkF3FKQ1X25Dc0QrUPPXP982ZN/cYI9Q9aiNiXTzErGFUtsg1UtIMAPPq++bAsTaQTrvcLsiPabykg//oGvEI/fU5YI9KHw3u8x18IFSaeiCJqYoXgjhOLXqWSl8Ef0doB8uybMqilKoIIn3FSy0NDGXV0QE319pSLderx8nPCewbtF13V1uICTT0Qyr2eveoKs1zgKxfQvIv3L6OB7N/bG8owNPAxOa9VrFs9GKIJ3jd4z7vcWw/IHz/0PEpmBSNuVbqlMLJ7MOUo1AzylbX37LIS0HgJO9wu8g7cxjNI+ju8U2fHb2g0kvRwP4F6O/vrWtMh10sFDyUMszb52g3D/p0Y41sgsped7sIc+vc0rCDz/2vJwxdXs0pcRsuQoVzBDTb8bvjKo4INljt7FRrEJBxrbaaf44vVQQCB133TVZJBRquU1pkWq0KKAn9v9l8Kgp1FK9CsIvlANRD/XAugPwHnQwz0DySfLJ1nALR4hmNMb1XzMx5Vs9rHBIbhEL4pAqeIvsu7f3E16yV0Z5s18MkiNNSPAebGIhU3DpsTRh4K6CUe+N9t0u3fgUU0qGsYaWx7ozvRJp4oL+s5pMB1NU8edq2dDJHAORi8vPZN6nqX+vP405sWDb1oF8RgDN/I0IR1OL3laiSVlpfIyl8HB1Yrep2xlzBEnX2gJX++0FRb5IJFRn/rhhHbYV/s7hqNN2RVCZoIP67Fmw1gUfu4r
 RTX1c+nN
 JDPiJ+JL612ZfQfhzbyJG5dF20MeClK04Nv/ubPoO/s5pRHWj4EfM+QJHai3MWHJpPCQiaGD3/3E3kEtLS3v9Ku5yKyka1azAx5yujE8O71O6W1CO/UsQMia9GhyMjBVgu+u7HMALAiW55VyIN7CCld4nvn+A0TirYGS7zMLB0tehWIo93Gv3pC5OuuJKLg9kiMvsKa+Zh9AYXT18F4uX4LfXhozlVCrgrTQZ8KzljpC8I9BvzblPd0rMzCu7JU0OcLjn+4GrrmmHp40UGofXxcbJKcQR0lHj/kTqdfCl2h1xWa8r9voPXjBJzeKptPOkOh4X+GFLbxwNA5F7k8ReSL4sPJWJsOyRi/t97fyQPKqQWIeH9y5vuo8fE7PeRoE05XIxP5YczvXcLoKQejHaZIc62dKLsoNJpOvFngh59aVZO9eETImkFfwlmOPIORVsgo71tr/ezg6d4GGQ3ykoS520mzefQD1S7vd5EekwoR+FdGyXaQ4rr2IOIJJX+zZPegH4PNCdJp9hdQlsycDdZt3g1wen/gnPRTZC6gPek+vQPPOVwlcSUUO7gBiTwj1nDqpdkQd+bKm4rasQCg0N95baHtc0Zvey73RtExgPyAGl+QxT8JweKDU/At8+/XwoGuup
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is only one caller left, so merge it into that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/page_io.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index f49e667c2b3a..6009f6991b73 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -254,19 +254,6 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
 	return ret;
 }
 
-static inline void count_swpout_vm_event(struct folio *folio)
-{
-#ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio))) {
-		count_memcg_folio_events(folio, THP_SWPOUT, 1);
-		count_vm_event(THP_SWPOUT);
-	}
-#endif
-	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
-	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
-	count_vm_events(PSWPOUT, folio_nr_pages(folio));
-}
-
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
 {
@@ -396,7 +383,16 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
 {
 	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	count_swpout_vm_event(folio);
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
+		count_vm_event(THP_SWPOUT);
+	}
+#endif
+	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
+	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
+	count_vm_events(PSWPOUT, folio_nr_pages(folio));
+
 	folio_start_writeback(folio);
 	folio_unlock(folio);
 	swap_add_folio(ctx, folio, WRITE);
-- 
2.53.0


