Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4620FC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 11:19:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 300C16B00A7; Thu,  3 Sep 2026 07:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2651F6B00A9; Thu,  3 Sep 2026 07:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C1E6B00AA; Thu,  3 Sep 2026 07:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6BFD6B00A7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:19:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63A60C04DF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:29 +0000 (UTC)
X-FDA: 85172205258.25.C6E7CD0
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7DDEFC0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 11:19:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788434367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y1946i/Bvb0I22VUx0rYwTDezQgJiJywL1Rw27Ab3pA=;
	b=LDlu5c2lfysMLSOhJBAHpX1bNtyqCfamdAToNamYzpaH7hAikqkvlXS565ci27PloCDJs/
	pTwx93ZtljnCghV8QCydyV5/zuhOC248g49sjW8O7LAb3AF2mP6fZRovtqUKH0UXsU4Y0U
	tDtG/u+kb34V+PgnYjkjOwOqeOAu1j0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788434367;
	b=u1tFqzYxMKekLQuU1kX3Qak1bvpXNRaMQ0elap42nEAdJ3yh72FAlxjCQqRkiRJQyjKxW4
	2O+Hjg0KH1xM4T59Pcb3huf/qpB2OQ8hJTHL4VP9SlAmZ29+DnlFur0mHNma9hE42MmNnI
	rWfJISEzEslSSoN81CySofUEKs/2LC4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d1edb05fc0e93de7;
	Thu, 03 Sep 2026 11:19:26 +0000
X-Mizu-Trace-ID: d1edb05fc0e93de7
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hch@lst.de,
	harry@kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>,
	linux-usb@vger.kernel.org
Subject: [PATCH 07/13] usb: cdns3: Don't use GFP_DMA when calling dma_alloc_coherent()
Date: Thu,  3 Sep 2026 19:18:30 +0800
Message-ID: <20260903111836.1777265-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7DDEFC0008
X-Stat-Signature: yiyj6ufp64yyffmi5kf8uwph1h4tx5zq
X-Rspam-User: 
X-HE-Tag: 1788434367-434850
X-HE-Meta: U2FsdGVkX1+aDcZgfxv2oVazVTWiBrML8Pn1PhWSHbTST6P1ZdjssxbyYuzwX5UntdC9Y+OVJPmLtQ5okC+3RqnTD+wucizjd2nyoN2Dg8E16D3UXv/q2zecSWaTsRqkbE5Ok8mgPyAfruLGzfvtvu3pYBFOdQDKWZJSPS4XIrLFx50sg+dtbrX7mampaSjmf4WIVhnfUkrC6Pa649oqNIpYhV0NmSuQfOYBmX3xbjkPoJtJgbgS5Y6QUvM52JIKc08Tt9bLw4YkTZvX5apNezH7XaY0UA6RUlWBOBZ4cz5i2KrLcKXHuxzySEWm4LcqXZ3sIgrEHr5u21+13fnEEZb6qXZkJsllnBja4E4kgvsFAb6iEM+0jmZfqdytxle5YN+uyQdRveyYpRWVtqa5SJ62rsuR+fMHYJTc1AZ65dgAdSglpA5h89MVCfNF8nhUsG3VisJTl01rU7VxanjGasHwQZjJTblXFzVlbl7x3dlQw+FpKnGzZ9Tc/B579vZETko0MpGxUEIxVUO9whwotdjJZfSaQnypaYBlfZo7Oi6uuuZHWWZFUHDyS8T/i7Ty9xH352hzh5Oi6XpOriu+YMAHAz6SmZYzFBM2xfY9NgiZfe9SIXsWyXhn7Opw9GO3I48hMujj/1gF7YuDOZUlzdWNX0S2f5x0QawccrARborgcv85d+ZfRAE7R2//oGIAgrEiZOCR0kbt+iUUMvDcyHe/8U+aIeHiwrDuIzqW8ZTj1ywCEXWSMBbdH8Hqa1SV7JKyC+wfpmaBAGjJ+DyXzBBGwzqIO6OBfQaSvhd/egsP+JV/RwD1GfVIJggdxgbQNiFAjegXlBsoLb1MNrr3+mm1CWgPZ0oaAimxH4aLANqMYvCrjpQEB34/4/bSGCwb/qafNepBo6UxVAPwYzPvd9Gxj1n/3OH8ITi1sBH0Xpw2220h0F93PtPGu8/SUyzKKRl5Quphs8DKHeeCAEJ
 yA87xuaV
 8BJvXpzLVNwA8YwhNaXsXW4/oNSqUHAkEW1UIP0mvrQh+XFo5W3Qt9TfKy9RLTqkKuthn5sONRKUzJvbvVpYAi7vKqvkkOm6X3/KSiNCtLljyKcJHFXD/YTEOgtZHF+dhUik4fsRlQNSIuDa90XPx8Hp4WqKUtgVKH0cLE72R49l9ZMP/z9AkK+QH5C8eLNbzPyH2ZKvoSc0o8y9eqXnjqP49km8SzbHhRIXBpeh7AsOPNYxzOgCjIihRi42e4B7vHEqXyLjocEyCuQWKwL36W05nF0pjth+ATRF8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

dma_alloc_coherent() allocates the DMA buffer with the device's
addressing limitation in mind; the DMA core picks the zone from the
device's coherent DMA mask and ignores GFP_DMA passed by the caller.
Use GFP_KERNEL instead so the allocation may reclaim as usual for
probe-time allocations.

Cc: linux-usb@vger.kernel.org
Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 drivers/usb/cdns3/cdns3-gadget.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdns3-gadget.c b/drivers/usb/cdns3/cdns3-gadget.c
index 42311c1bfada..484d3128cf08 100644
--- a/drivers/usb/cdns3/cdns3-gadget.c
+++ b/drivers/usb/cdns3/cdns3-gadget.c
@@ -3376,7 +3376,7 @@ static int cdns3_gadget_start(struct cdns *cdns)
 
 	/* allocate memory for setup packet buffer */
 	priv_dev->setup_buf = dma_alloc_coherent(priv_dev->sysdev, 8,
-						 &priv_dev->setup_dma, GFP_DMA);
+						 &priv_dev->setup_dma, GFP_KERNEL);
 	if (!priv_dev->setup_buf) {
 		ret = -ENOMEM;
 		goto err2;
-- 
2.54.0


