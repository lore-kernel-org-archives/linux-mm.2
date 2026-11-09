Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5C3606B595
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=IpFXtm0k
Received: by kanga.kvack.org (Postfix)
	id 15DFA6B05CA; Mon,  9 Nov 2026 13:26:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E9416B05CB; Mon,  9 Nov 2026 13:26:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55266B05CC; Mon,  9 Nov 2026 13:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC59E6B05CA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:26:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31E59807A1
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:26:03 +0000 (UTC)
X-FDA: 85416409806.30.4B589AE
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6972620007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:26:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IpFXtm0k;
	spf=pass (imf03.hostedemail.com: domain of 3NxDyagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3NxDyagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248761;
	b=Xh7X7drB3xfI9UYJLO0dDIpwqEGUbPa+9UEBCrbtq4eragCLjcLJ5FiLkaI9YrBndubwgA
	xBgjJdRi+x5PScfKXvZW6hVqVy4zTyqL//I3ksoV6D0eS1dkN6XPwUVHYGMFyM0iTxvGOb
	kNYAs/NOBQmXUQhvkpcIqaej5nvQdTI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=IpFXtm0k;
	spf=pass (imf03.hostedemail.com: domain of 3NxDyagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com designates 209.85.218.70 as permitted sender) smtp.mailfrom=3NxDyagYKCH4ntk11qiqqing.eqonkpwz-oomxcem.qti@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X6oblkqCvojP6e7fV/VhIpBJOcN4NASJcWrnm45v9hk=;
	b=RlY3hR8v38//ujie1ZiEV5zzWZUgr7hJAEWs7A5FW1eu17HN57Skniqr0KrBeoK7ReYGjP
	DIEHIV9EFfd9zH215TXKaRkkaifblxsQv3yMi/Bqe2IRcppPW3HYiIn2iXZHg9FfOg50qx
	jmBcAODhx8NcoNto49ZvXN3e/Ui+GtY=
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c4108bfb63dso74363866b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248760; x=1794853560; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X6oblkqCvojP6e7fV/VhIpBJOcN4NASJcWrnm45v9hk=;
        b=IpFXtm0kEvNRFrkI3MoKCq8bGxss9aO0ErKM433cfdL+4dYxPUVlTEcUFcxHU90E/P
         u/XSOT6Tm8W10lHwAPBnjvvupIAAnjVLIP3H6pd/JtvqtYw0417xeDaWrSFVZ/OVG2mh
         rcXPP1Jle1itT1I9AAia4Agzi7zvTajvXZ7EcBDR74Ert+b2IcI9+MfSOeKrjyYANuQF
         +3h6jgyi/OewSZfQRuJ0Vh57YfvXw0gSoLTRaJYQSgrujMB5iKO+nLRcmUEo+C9/IJxa
         V3ugIXyXHy3vcfcYGKYAIDlWebC8o3P/8qY9QoI8ZSVNv050toevDezk4FerKdqgzDRA
         dR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248760; x=1794853560;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=X6oblkqCvojP6e7fV/VhIpBJOcN4NASJcWrnm45v9hk=;
        b=xgljoKlWwSc4+Tt61/HJ/UCTNsKd0fU/drzhsMdQr7hdCu3Wvuse/b2TzJsL9tllmd
         1/Mg7EXz0vllJ8twLnxYqSvRcE97f/A1dG/WO5Vcv1qoC7ph+bgszcNgBNUMOurdKvYJ
         EJ0KmBPHX1qyG9tLPV0RJyBI2V85rooIHRhrOv8Lk9cJ5H6GzwQ4DRdelBEi7PK1Pfwx
         Xg4y7F84mA70x5v1fiYOJ4F+v3jdUMW2YktWP7+Su6CoPnLPo7cylIGrvKo6nsZYepTl
         RKqe9Yqay2bZAFU+LEFN3keDV3Q+PSjYxA+PfFAAZ6smjZXFoAOSGRo3aS0+qCqZqxx7
         kqGw==
X-Forwarded-Encrypted: i=1; AL+hErG4RZkDF9Tbjxoix09J5/lDFK1OpM6Rqi6O4NQrbZgXQPTYNG0dNWoKZvseTSpxcDLAdgYcbQTIpg==@kvack.org
X-Gm-Message-State: APuU4Z+cCCkoLRvYdZNufyQErXiVFY3zo1txsQfJSXSpCRwdZysM2sEu
	p8LzhICVmdZB8lIkJhMDH88arjd/9Oi0NdS2Sl1NaJl4kllhn51gVU4CXxw2q3w2qVYEKN1gWUq
	v/sEObg==
X-Received: from ejblh15.prod.google.com ([2002:a17:906:f8cf:b0:c34:bb1f:3bc4])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:944f:b0:c3f:98d4:dfd0
 with SMTP id a640c23a62f3a-c50495f01c0mr14975066b.45.1794248759870; Mon, 09
 Nov 2026 10:25:59 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:30 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-23-lrizzo@google.com>
Subject: [RFC PATCH v2 22/25] net/gve: Use PISA memory for RX buffers
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6972620007
X-Stat-Signature: 8dckzkejc6zeyfipcx7i9dxss4tdrrfk
X-Rspam-User: 
X-HE-Tag: 1794248761-62076
X-HE-Meta: U2FsdGVkX19X0c9BaF0Fv8FdJrsbQUV15QzWrmu5sH/j5N9wXrc8qa1ieOnVtQJKy6wAaDha+x0VlUKDvdy0kjZIPTGpiYvK2aG0LBbwuUsoF/qIx+Me2QFRoxJzr9SCl9PhMThXDHmfhqfX/dHpQazuB9mHcpGq1Kqt33PJy88866ZMpD2SReZLkGfndZ9npJYgYUY6pktq0OvM5S2pXUtVrReEKkei3cRov3UmlHiG9AqKliQiDsMuI8uv/EuTXD22teobRpJbTXg7LVYFJjZT+W1pyAw4jHkVgka5gPM5x96t7Bxggn6WPIkkOd3YCQfZ698biZrZeoNzpuVZ8BBNUpg2xdlfgef9tAgsulKRvhmdKJmJNaq42HeLcIge/SyUuZei1+tBX/WDnoE/oZ1WvcaxqSGtkLZ2cWxxmayNyXsO4h/O8CM0SvAiPg4itXUxbozy5SCy0wj05D+TliehIDGFJmrGSA3ca/N3WY7RyG4OhYeKeomCQg/gUXV9mkv3sWsnotw+qXE8VEN2P7T6fKmWYSoZNKKigX/qypQf5SMIr9hB6dl4jp6DsJ5CkDNM01LPi8gqxuHAn/a5EtlpDm5jkkUKqxrXKlljJ0NxxUWi7kdPonYCW07FAbE6oPbR77bRBQmq0j4vnIfIIXchbu2yD/JrADWA+wWZvkrQJj3ALiuk4d9ZhevvVce8YV089tosFgNE6QYe97qXQHvJG1q02Y/hsgYLEKH1iNPquZYjDTh6oFIBjizOfYYs6cuKOijZtgcNriDytkz9mtyn8LHYuEjQI69Rj0TPVZo/mEnTxzxFuabizs+Os/dCFXt6h56CALMUtf0eTP1nGuoKy0twDm8gnXcr6mtgfkJQ1ofFE42E+jeETbdDAL7+oCAbptMrsH53JyC0Q9yw4NZKQEy6GiQiv4lvrvvxv79C7DeBxUxTZW19FTOko3nDaU2D/agLFThjRxZFwzN
 ljr+xxFv
 syqf0IizFS9ckuQ+IlQtiDHTE0cbqzlpMcU7hDT14GQdTtPrTUmbKc9PECod9i4NQNMp9EtLesvlsguKH73ek59pnPHpjQMrV62wHoym0awwAdmDmtphq6a4HlBG8wd7/vRTpJd8QAA5lUxvvDY9KyFYFTza9x1h6jnWrvYuHuKOUt/JrGCmZgIluNgkfAsgMG61LrZ+shAl8en6LG0KwAZ/QUDW9oBARLhQS12VRwz9e+ofElwjv4BKWMloE2eYdjqjjbIkQ4luYOV3/hZuwTXZUEe/5zWu1myKcEt9hFeNoMRMfNRvYZ3OuFSsexrXdHy/bwWC2g0u194smgYmF2UHiMlj0/tRd28luCMoGh7Yj4Yo92z5WjQunWY8aYcLKwGZ2WYwD0xHN0jUe+Qxxs6kkmjuz74wnyQRcpSNpZidBncPp6NL1UkSOfoFpJytjgTXq/mysrGq23QkkeH7eqhHai3/RjNFrK/tWfXbJoxJtinrgIVxVieErOyZvh5+k0WHsk6GZhAqAtBUNWfpRobbgq8PX5CLK1CcaTtzXf9wVG6iiAknrD0BdoW5tqdHcVAW6941tD6hmhYrgS6i6gd0eYh7Xw8Ka0FTJ0i67aQrDhKHlypiv34/Fcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When dev->pisa_rx_bufs is enabled, allocate GQI-RDA RX packet buffers
with pisa_rx_gfp(dev) so they come from the per-node PISA
allocator, and evict plain pages when a free PISA RX block is available;
DQO-RDA uses page_pool, which checks dev->pisa_rx_bufs directly.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/google/gve/gve_rx.c | 32 ++++++++++++++++--------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 89f287b678bf0..85c243bbdeb33 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -4,6 +4,7 @@
  * Copyright (C) 2015-2021 Google, Inc.
  */
 
+#include <linux/pisa.h>
 #include "gve.h"
 #include "gve_adminq.h"
 #include "gve_utils.h"
@@ -170,6 +171,8 @@ static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 	dma_addr_t dma;
 	int err;
 
+	if (rx->data.raw_addressing)
+		gfp |= pisa_rx_gfp(dev);
 	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE, gfp);
 	if (err) {
 		u64_stats_update_begin(&rx->statss);
@@ -499,13 +502,19 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
 	*(slot_addr) ^= offset;
 }
 
-static int gve_rx_can_recycle_buffer(struct gve_rx_slot_page_info *page_info)
+static int gve_rx_can_recycle_buffer(struct gve_rx_ring *rx,
+				     struct gve_rx_slot_page_info *page_info)
 {
 	int pagecount = page_count(page_info->page);
 
 	/* This page is not being used by any SKBs - reuse */
-	if (pagecount == page_info->pagecnt_bias)
+	if (pagecount == page_info->pagecnt_bias) {
+		if (rx && rx->data.raw_addressing &&
+		    !is_pisa_page(page_info->page) &&
+		    pisa_has_free_blocks_rx(&rx->gve->pdev->dev, 0, rx->gve->numa_node))
+			return 0;
 		return 1;
+	}
 	/* This page is still being used by an SKB - we can't reuse */
 	else if (pagecount > page_info->pagecnt_bias)
 		return 0;
@@ -549,7 +558,7 @@ static struct sk_buff *gve_rx_copy_to_pool(struct gve_rx_ring *rx,
 
 	copy_page_info = &rx->qpl_copy_pool[pool_idx];
 	if (!copy_page_info->can_flip) {
-		int recycle = gve_rx_can_recycle_buffer(copy_page_info);
+		int recycle = gve_rx_can_recycle_buffer(NULL, copy_page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(rx->gve);
@@ -669,7 +678,7 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 			u64_stats_update_end(&rx->statss);
 		}
 	} else {
-		int recycle = gve_rx_can_recycle_buffer(page_info);
+		int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(priv);
@@ -975,7 +984,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 			 * owns half the page it is impossible to tell which half. Either
 			 * the whole page is free or it needs to be replaced.
 			 */
-			int recycle = gve_rx_can_recycle_buffer(page_info);
+			int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
@@ -987,12 +996,15 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 				union gve_rx_data_slot *data_slot =
 						&rx->data.data_ring[idx];
 				struct device *dev = &priv->pdev->dev;
-				gve_rx_free_buffer(dev, page_info, data_slot);
-				page_info->page = NULL;
-				if (gve_rx_alloc_buffer(priv, dev, page_info,
-							data_slot, rx)) {
+				struct gve_rx_slot_page_info new_info;
+				union gve_rx_data_slot new_slot;
+
+				if (gve_rx_alloc_buffer(priv, dev, &new_info,
+							&new_slot, rx))
 					break;
-				}
+				gve_rx_free_buffer(dev, page_info, data_slot);
+				*page_info = new_info;
+				*data_slot = new_slot;
 			}
 		}
 		fill_cnt++;
-- 
2.56.0.542.g3ef89b7020-goog


