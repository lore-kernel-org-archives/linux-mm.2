Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12D4C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:06:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE9C6B0088; Wed, 22 Jul 2026 09:06:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7FAE6B008C; Wed, 22 Jul 2026 09:06:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91FBB6B00A0; Wed, 22 Jul 2026 09:06:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 693E66B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:06:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3ADF40191
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:06:38 +0000 (UTC)
X-FDA: 85016436876.11.ED90557
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 10A7A140003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:06:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wBCFQGFL;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf09.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AJu6W+cDK+vrIV3o8PwkdnGRy2RqYD0RDxVBwAOMbr8=;
	b=XlLbXEAzbrmpOs4il2nlWJRQ7O0zWkMcBZhEle+xERJ3qspJPBiEVnz+wDMMz+15l20kvv
	l/zBgUajX5iVwFsIdlSSPvIl2IQM1s0sKNh44knNSv1Cb346gQ+x3NcaEiTo3Jj3QJtZk0
	ZbwkF9nhFuveOkBuRHsY1nOLKAYROyM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=wBCFQGFL;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf09.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725596;
	b=7Hidkc0Isg2rSzZ8T8oekIx1a2pb26LZv79ESQTHJ9lKqKyUS+3P0mqPuoy0bi9xFBi73q
	oTlHW1ZPgywtCTCCIp7YZ1EGg4bW2ppLQxHwhTDPJbkMQAOHF8seeow1rH8Ox9RArffi8d
	0+x60EFzF5DcbqNBTRm1bCs90kYfzO0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=AJu6W+cDK+vrIV3o8PwkdnGRy2RqYD0RDxVBwAOMbr8=; b=wBCFQGFLFtCcB4Yaw6R2yS+bIU
	FxxTWZwNsSFVLylygCqH0P18xh6Ze4pD7kroAlyDWFMmHdnjc2RcJBmsetsW1+JGn3UNElSoAU3Yr
	YjpfKOJn/E6cZhxNBDDYtDDc6iAdfOlwFAHb9Ksn5I9Qj140vLAqwLyIijhTCQx5GPtV8AUnVgLTq
	dkWRzH/FsDoqmj8wfiq8p9oDQrppLLtr+wKlv4zq/ln4GAV749HYf3HtzqimYXqgNG6QLYKOnOJoS
	j0z7EfPPmR3OhHDFVfjuqPD4Fj08ESri1FXeYHCxasSGF80m78yzbewf0uCRx4W9y/hmKAj5Ib8jr
	hnmijh2g==;
Received: from [2001:4bb8:2d6:3a78:eb21:714c:af4c:ee7d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWea-0000000Bpp9-1eNe;
	Wed, 22 Jul 2026 13:06:29 +0000
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
	ryncsn@gmail.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	linux-mm@kvack.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 1/3] mm/swap: revert to single-folio writes for synchronous swap devices
Date: Wed, 22 Jul 2026 15:06:07 +0200
Message-ID: <20260722130615.3163560-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722130615.3163560-1-hch@lst.de>
References: <20260722130615.3163560-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10A7A140003
X-Rspam-User: 
X-Stat-Signature: ocujufco8w5noh1itwzfi4ne5t93mmsp
X-HE-Tag: 1784725595-912039
X-HE-Meta: U2FsdGVkX18SBXonbua4zYLtjG54cJdEqJxKtJO4ihy6FMfLqvuNWbVtTyN2roqWBCfdptrDJIw2SE1iQfJNf8Q/jrNu2+UT8TwKQp0bAGFT2/6I/D2gRxZv6YhpZCc6mUw8iYDUz+L9eUpppeqKKmR0q+WOoxsPnYPzmAemHbxXXXl2VsUnT4168uwRWEls8ADLkHueX5+dmQ1i5E5pgbumT/T5gKFTMcn590vivBtqVzB3QHYvO0KqB4RFfGQvaywBmsTwGY1ehDaggd561W1aM4rFMJR24+F4/j/dLzAnX6FpX2kM5fGUy/Kv6bJl5OtScfNtkY31EdXLgunJwNJAv1SwS4/L+/vPqkPm17U22evkTrr7LFv8Cyjjn9r6NrKkETPHUo5xue5Lpr9+7Y0yEsfENMs34BumvH0ycuM67Vi4QcHNGLSAXhI9EplGd0cw3b4ikoR9bmjKzZ2DPaaskEfSJbMmlGswQX7uENpNawkxGXL9fyoRk0qiSpMzxHgM3DAOcMbO++kgDRcuFu79NCNayYkuHquYakhK+GxNGUd80R9HGCdX8MBGuBnEFSbOCp66LPxmX8lsOxlx+t9mDoKzeN0aKcase2ptFGizHYnIz9iK8+ygT3UYyvGrbfm7YcKF3qnUkNBXIIF1xB8nqy/92gzeR+3SF7kjamSME+LazgKYX83Le1JL+lE7eLCCd7yjMjiiGMff1Cixg6AmzJQmwl5ulKd3Iv8d8mVqp9IgLMityJBQ2fZchGXvhSYoqUsn/qJwnap7B5d4ijGw6EDFzVLG9taeDz+ogYqTitDvrOaX7OnGp8xnigUkyNSwzswJHBozRhaag9GhFhuSchLL581x1s4JSp7eNBrDTaIlzV53agP6BleoR+J1XBMQMpb/eUaDgpLL0ZMdlnnv8gv6yWAiiw9CZXGkad+i9YTtfk3eTrxAiemuziyOGn/Vj9IwT8WEZuV7Dwv
 BevYBHhJ
 Vajw0niLXWJpK8KFUCv2fuiRo8Y2aPwJiiQvaZaAA/p9h1uXj1zjNJqafmsVq7Wltk7ggsgDmMO8avPMInkj7MhyjePUNyP6rrpeCVGORN7Sj8CZP7hXaFNlqrhX8t3E3c+YpbyOasPhiS0HEjTNcz6aW6DL9KTVxX+avnfuGZCuFFDVeTfAxnFv378cAJxCF58+uZa//5aDX+xmuPd35l/AC5aOaw2yo86EBDeAAJa/Ba8vRAPHIkDrpFfN7PM2S1lg+SkFG6gh/71fLoHII8NGtr348B9gv3OETY5LKiAoYGAhuYMoVMKgZwIGD0tLi4dHG9wtjr9p98J8zPgmZblLOVnd4qgZ5Rej0/sNHlSlDOmZukoAi0nwBe+1/SwsPrCrLexZNQizKJ6uf0onurGP7sgGVKc4TpCGVObmf/Yyyhceg9Dg7gHH1Kgq0eqAOM3hIyPRZGK+0+Dx4cSiUguFh7hNBiEK9dhW2ojPNKti+rwfko/WXDLS4pp6Hf2QrYO8qEWmEflIOG6voWb8Fuwmu+C2y8s7KCLJhd9wXS0OFoZxb3DJKykbYz4UHkaCnJxNMUFLFoQR+GjD3rRAzqtxuEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song reported that zram benefits from submitting each folio
directly instead of batching up I/O because the classic LRU scanning
benefits from clearing the folio writeback bit in the scan loop.

Accommodate that by kicking off reads for synchronous devices for
each iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index e4fa7ffffe8b..c984a4023a65 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+
+	/*
+	 * Write out the iocb if we filled it, or if the device is synchronous.
+	 *
+	 * The latter is to work around expectations in the classic LRU code
+	 * which make synchronous clearing of the folio writeback flag in the
+	 * reclaim path beneficial.
+	 */
+	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) ||
+	    (rw == WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
 		if (rw == WRITE)
 			swap_write_submit(ctx);
 		else
-- 
2.53.0


