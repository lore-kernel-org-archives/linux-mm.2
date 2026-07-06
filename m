Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20055C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDE4D6B00CA; Mon,  6 Jul 2026 09:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5FF6B00CC; Mon,  6 Jul 2026 09:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF27F6B00CD; Mon,  6 Jul 2026 09:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E31B6B00CA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:23:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06D911C7CDB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:23:15 +0000 (UTC)
X-FDA: 84958417950.02.8D24B6F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 74EE71C0003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:23:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AbpJRXB4;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344192;
	b=z1BdOJ5hjbpW+/yyc7K6yslxXm2YTeVBqkdxl5QrHRX9qV6c1sGfIICuTR8ANmrhCoXqNQ
	Mf/TGRgKqD321HBmAAQC2iovAT5NdW+t+zxrc6CRVc1F0xVNTbfWej3ifqd5Y/FhTZWYb+
	JRLoevwF8BJcI1hXa0Dq7b2J62JSyAw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AbpJRXB4;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf18.hostedemail.com: domain of BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+434a720473ee9d4dc2a2+8352+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYVDCtimsPOZOiixQEWTf5dA6Nlk4/p2SwlX7bSOFm0=;
	b=PzqvGN2n/7NqLa23ga1gHbakZoGQ2gGPirdq7VdE8PKUrYtz9pfeLPIH8hMZencYBhfYHd
	yPZicj2q2bzx85zutUURxvxYyd5HsxVCVE0wCX8ImjCFcvLSUUht/Xrxd/Cnnj+7mKD+Az
	3om3urY/DLBmx5o3JtM7yDBrNG89bsI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xYVDCtimsPOZOiixQEWTf5dA6Nlk4/p2SwlX7bSOFm0=; b=AbpJRXB4K57ffeLdThBLAb07QQ
	5zfYQkgErxUKVFDXgs3BexHOISMhtge5IJ8dsVH8LK+yeUGFU9WhY+8k39kwwVRU456RKMzcwvfqd
	J/Ff3loEdSR8/knwEmOrz+Wt90Jg/o43Q+u0u79QdrJ5SKrozCtj1HHG3slZ5cChjfbRKXEKVD/dp
	AQend9n5feptBTs0gDqgf2D58Vd5I0MirdrRl8e/z7XSXRNvIuHnwqna4zmjZXJo3PPouiGc35r2Q
	hP++HZHrqANjr+0QJ0Ghh/KKRNgYZUNs+hg6dV+58D91YV52njiLR8KtEW7lK4b9x70iUWBjpaJb1
	2SpIsPDg==;
Received: from [89.144.223.34] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wgjHv-0000000Caeg-1pw5;
	Mon, 06 Jul 2026 13:23:07 +0000
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
Subject: [PATCH 7/7] mm/vmstat: add NRSWP{IN,OUT} counters
Date: Mon,  6 Jul 2026 15:21:59 +0200
Message-ID: <20260706132206.935272-8-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260706132206.935272-1-hch@lst.de>
References: <20260706132206.935272-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 74EE71C0003
X-Rspam-User: 
X-Stat-Signature: wy5jf1rjwh3bumnwm6qtcqp8ggaozn9k
X-Rspamd-Server: rspam03
X-HE-Tag: 1783344192-39914
X-HE-Meta: U2FsdGVkX19DicvSkIxI1qYTmrOcV7nv9ja5IIwtj0p7v5Q+063A6HTPp2kpkCHVyToPbxYZ8f+8Qfhx5EY0yrtiR+YBXPuyTeAw+K32dSNyihkWiItO2dGRuJXvp9VAi8KXycTPkt2ChysJUzCEsHsCuyZ3crc/UsLrE/se3jrqW0/x4YgwEHCyQ5WtBecF2/FicUTguVDPDCbosYybRw1MQ/8Z+im3yYimGU8aJTM8r2uspaN6dMzGcRHbbbBpPc4L3wOvE/0DkWHe8NyTQ9UjpI8q3zv2PwE7b0OVobrAde+phz37/GoGaT65VzkGX0xrFmAW0V3KH+Uw3O2nLiPP/ygQ+vMk0O6I8Kzv/YwvNtlrTNzbFKo+hWtzKrep0oOMroqvh+1NBURJtoAgTTtwc5uBxyhLlxlO7kBkWhWb/cX/1iGy48DOAHSxDvf+hENRfNWPgS9Fa4wWFoWcYJslHxyPQLWVv/+dLxMcmZlWwppkv5rcRCzn0s2EZy7Grtf93yRr+H1FdS26E6eUsUmXE857jRjoDjGQfX3meZaLi9W2mB7mPQ5CzVKFy1k4/q5Z4IsD+1wi0ARQHpz0gYDbJYLqQAH1Yc9y65gfYEvMbZ4KelPyrMEIa2r43D/dKq0l0/iVShEU9bMtATyKStdA9rpVI7FTaZKhQsiZ1rDowNEs6a7vVXSKfCkDA1ZmfcsrVJObQzjNRl2IUyo/HYyzbH2LLp4tMrDsJ7/uxftgRMel+2KrfDrRgeeDKi5F5DZsLCXAkV7LVkP2J7y9zf8VyVZhyQd2x8K/Kg+2ZLVbHUik1g0JNfFDkwPim08GCs7BMt90vDxkmzrnpzcE72x9oQpywiroM1+Gk/L0Jk3evj+kGMhEKj/SbKLwLMXI4udDF1RHb8e9lH+O09T+41oJ8qrG8TZi7NFnhCvHMVCLhuUsBudZY3El7E/MmMqvCC3OTGAZpxjFHBdIB7Z
 1DeiBYaP
 o29SsfIK3aQKz27om75WkdCC/YTb+t2QY2csc/8cFYYkGeUJryVfT7cTUGeYelxnORBOAKy4hMb8WpyTijKdIQh/vj8mrAO5KXyLl3JH6O77cGumedqwRVX5FjoWtwJ377n0TWAqI2zeZwz7VJP5fEIj5uQb+mu1YGJ7NAsWFV4vPK+NNrpz2Q+a0ydcV/Kx2YNWFYm5tuQRiyU53kJTQM4uZeXH2x2OFxSROuXfI58WblHUJaPXB3aoaqdIK2M1GtUTaVRxnJrqPAz+TgpBRH9cf4+tQR4X7aNOzyIuJzpYi/8R0VWodkkmjZ2BFrb7pH1v62SQM6A0X2XHtgbO++1dRhScgnMLB3efNSTL6H8/TM3yO+VLPcj1+hlllFlfxiPqvNhEqXxJ4KTp8ZExMH3Vt+wSYSDVucid4MWG+851bdReaLzh1R/JWnclROh+wSQz88VFriqBL0NFpZ+lSP/d5QaBSU9Eq20QOvh1eipbhvxU4KcK5fcyWpUieq7KrMBIpCjTQBfKq88ftW43x7BZ7d554DDw+sABicW+SXvARbBf2mLgFXipXrsSIO1S5if2YIYPCJblQulc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Count how many swap I/Os we cause.  Due to batching this can be different
than the current counter number of pages written/read, and tracking this
information is useful to see how efficient the batching is.

The counters are added at the end of enum vm_event_item and the
vmstat_text array under the assumption that the order of fields in
/proc/vmstat is an ABI.  If that is not the case, they could be grouped
with the other swap counters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/vm_event_item.h | 4 ++++
 mm/page_io.c                  | 2 ++
 mm/vmstat.c                   | 6 +++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 03fe95f5a020..2628ccda076a 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -175,6 +175,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		KSTACK_REST,
 #endif
 #endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+		NRSWPIN,
+		NRSWPOUT,
+#endif /* CONFIG_SWAP */
 		NR_VM_EVENT_ITEMS
 };
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 1e29b36cec07..c7681dbcfc76 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -703,6 +703,7 @@ void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPOUT, 1);
 	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
@@ -712,6 +713,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPIN, 1);
 	ctx->sis->ops->submit_read(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index f534972f517d..9559f3c95735 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1488,7 +1488,11 @@ const char * const vmstat_text[] = {
 #if THREAD_SIZE > 65536
 	[I(KSTACK_REST)]			= "kstack_rest",
 #endif
-#endif
+#endif /* CONFIG_DEBUG_STACK_USAGE */
+#ifdef CONFIG_SWAP
+	[I(NRSWPIN)]				= "nrswpin",
+	[I(NRSWPOUT)]				= "nrswpout",
+#endif /* CONFIG_SWAP */
 #undef I
 #endif /* CONFIG_VM_EVENT_COUNTERS */
 };
-- 
2.53.0


