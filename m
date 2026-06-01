Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A304CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6876E6B0347; Mon,  1 Jun 2026 07:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638D76B0349; Mon,  1 Jun 2026 07:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B9A6B034A; Mon,  1 Jun 2026 07:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2AD6B0347
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:54:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCA3A1C0B11
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:54:15 +0000 (UTC)
X-FDA: 84831185670.14.883E57D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3C1674000E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:54:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j67+pxZj;
	spf=none (imf27.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780314854; a=rsa-sha256;
	cv=none;
	b=KhJMWL5Zz5CX6amCekOS+w240QzG49Zn0qtMa5sb8l+9PLHt6358YVEx+lbHZRwXABLMgB
	6IBiBVFsWLbRP4wn2wvtKYIaNzLKBFqm4ggvea5v99r8hk4/eRTjUife3UGp3yR1OloaNy
	Maillg6CCO4T3QIftSaRgzKGV81iTco=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=j67+pxZj;
	spf=none (imf27.hostedemail.com: domain of BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+04e3d363681e66a0f89a+8317+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780314854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+K7FL8m5EEPhy18o9VcsDRFS9WcWWufO5wZWFflHxE=;
	b=qSwJNx9Kdxd/Y8Zeu2ML4eewNON7BCoHR51ZUsMiffR5cd4AEiSiLaFee5aT6ktFeerGh+
	jlEM1g+fdx+S2nA6HzqehE+YgUY/aVXTD2NHVhTel5w2tHbdqg41Iql1WiJkzgFHDAFYR3
	l3GKnWPFBTv7ogykE/Fu41g9Lf5iPVc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8+K7FL8m5EEPhy18o9VcsDRFS9WcWWufO5wZWFflHxE=; b=j67+pxZjO32yF6aPL6tXb1OfP3
	BfQIQeST0XXI/1jocc2DIjG+2L3KSnaWQfzCFu4UeilUbun74VUYbBxpRvll37kAaSvLvp2MbJycl
	C4AUSIm64ZaZ99UldaSz/o45qL59eqVY1oVYYkEYCb30M4j8h1aSEo7L3u4IMcTI6V7mklgqcIKLC
	16ntffcRe/j/SSt5ye9Z/U6RgECWaYy4TZKWc7wgiPpqz4jS3xJdD9h8cc7U/x+S1WDXkvN4d1/xg
	PmycuthXsMDslkKXcKOEBwbxJcnvSTJHcagmIQcKE610gL3BtgvwEdciaKpJ0eyIfte7VRCwwbWEG
	BbYND3gw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU0vW-0000000AkeV-0nTc;
	Mon, 01 Jun 2026 11:35:26 +0000
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
Subject: [PATCH 8/8] mm/vmstat: add NRSWP{IN,OUT} counters
Date: Mon,  1 Jun 2026 13:34:34 +0200
Message-ID: <20260601113449.3464734-9-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260601113449.3464734-1-hch@lst.de>
References: <20260601113449.3464734-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C1674000E
X-Rspamd-Server: rspam03
X-Stat-Signature: qrmbqo5yo9mxfpgebmknfqdaw9oyaxwa
X-HE-Tag: 1780314854-846554
X-HE-Meta: U2FsdGVkX1+NWVmNzMGia3/7928O+gN9YL97ZjPmD3hzGAg+5WtFHqv4r95dQpzlBpT1dY31bAy5qG+WKmcpa8SqDs6/ahmQKp7t1DuUrn15so5xU3cbDoTZlg2aqNvP7O9S1QmTuObE6eiBtDTBIRx04Xvqg6SNX+57UMkyhCUh6qZehP1anu3QAVC/KVlc8ddc7NfIlF7QB+Dp5asrLeEakZ15s6EbbvzM6Il30mGbHdiIfDo35fyDr6XX0UKZifBF5ogog4qa1ujFcwXQCyDnYEuzIF/ELzUTwPgpJN+OQDKDrGZcV0gvFd11wljMcYZluwnkLlnc0ql+gwYztkfji8kdDn3zU3HCgOzyRcO7E8g19JQ+efzhCQlv+QVe+awcEJzQ47ij3KaJtgnYkcEAZ+V/N21YQInDmWe1al/+HoVmABAtQDgvUH3pjhcvMKnFfdTzIQnAgswOqYejCg4sXEJD1QaKCwUYHOrhZ7cb5XU5ebm3k4Dm8Vtcu9cF3gt+waT0LvuKNrU2o1+Awd/7c3j1ecajMp+lwsDkS7fOwtITPcBvCKip+LI1q2QZgVegH1aKKfffp55D/tfZZDjqRPzYpoTisfyb+0FtIASZ3NOir9vH+mTars/wrysVFkpon0xc8lH+umfWuvTI5hrbTw5gI8g/0rHrzsDxpmln0Mk7bwRJtUoYdmfMm74anu0fXunBhBgWG9cSUN8yva+1K16EiDy8TatWcpBk0VFoLx0xlah+3zZzYTcPxIgVeqZKfmhEbJcvUfeg7fN7g2e4+fumF4gMOX3ghrInfCccqNNVQrXwvKZgWNzLy8+5SGkPblQfqI9m2cGywi+70fHkabhvJjI6zebNWPunAJhcj4YJLtsyY/C8Fl/VzDH6mqC6BkW4WsClHUZSRDkcv2rs412A+eZ3fC9q45T07fnnMd7LXBcYFrDsqhMGvXSo4M1UcWCqRrC74YqLssW
 HDEmgd89
 eorMWKCLsz5ib/Pp4TaPierVX1Fj1RrQvGm+WOi78ucFZC+ULr35J4yQzeMcuGFlUKNQfhP7yoc4GmYu9XWTiK+IoTTaQ1CEouhRTIVNGNgxVv96dutEQ/UoKODMg2+iyQQJHQfZ65+Fl/UGaDhD7M477Kd2eCAHnO3ub8Quc0ukDaoC82jKmhqmdWr8MYB8X40sYkesLxiKSk8DuYZo1FCo6LSA99Et6eCNai353qARIrJ/tHDBdUZKOM5KS75+rViAerU/D7B0Bdy6AIi8Hr6nHZfTFZMyZtuqYgkPpbO9UDToDuaPjEiY+3fg/glkCbTyXWeYnSH/EvQmJlg0V42388vQaCQDfy06rwXfKHEWopi+pnH/ZzjImngnsW824105AsFBm6IPsFifEzSzKhCpYTSQh3L4SID9fCCzzog2ev2IeEzXdni1sajaDC28+URkDVwA3JqjTewb2DjzikOSPRa+QkRRVU7oaYafDz6gHza1NyB26WHPWIdtJjjppJKyOtY0hYvkAPZ7i1IFvT4U6SplZqtFrHSp0pb5F7x9q+AjZFcB8/wtBNOHVX/a34RulJCwAM763gY2JRI7iVwLyug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Count how many swap I/Os we cause.  Due to batching this can be
different than the currently counter number of pages written/read,
and tracking this information is useful to see how efficient the
batching is.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index cdac55d0a2e9..c020e8ebf966 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -695,6 +695,7 @@ void swap_write_submit(struct swap_io_ctx *ctx)
 {
 	if (!ctx->sio)
 		return;
+	count_vm_events(NRSWPOUT, 1);
 	ctx->sis->ops->submit_write(ctx);
 	ctx->sio = NULL;
 	ctx->sis = NULL;
@@ -704,6 +705,7 @@ void swap_read_submit(struct swap_io_ctx *ctx)
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


