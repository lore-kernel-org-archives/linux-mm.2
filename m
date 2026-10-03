Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7B6CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D258B6B00AE; Sat,  3 Oct 2026 17:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEB0C6B00AF; Sat,  3 Oct 2026 17:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9A16B00B0; Sat,  3 Oct 2026 17:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4236B00AE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C37871609FE
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:17 +0000 (UTC)
X-FDA: 85282590834.15.1F78FFA
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1B20E4000C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vria0Z8h;
	spf=pass (imf01.hostedemail.com: domain of 3QnLBagYKCIky4vCC1t11tyr.p1zyv07A-zzx8npx.14t@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3QnLBagYKCIky4vCC1t11tyr.p1zyv07A-zzx8npx.14t@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZXqnIYzt9QIr5pps91sOm75Wt59xbsH7uSVOSxPBhc=;
	b=IHVIiFSkCd2vanP4+JjuzB/VhvBg5FBJGAxgUcVA0b0/hkx4uxnpx0bckOdY8+3z1kknRx
	z04GYAjPauCI17QWiATbANzV1Cqx3gIlDfEFuo3KHJRBUeaML9Zxglyq7IAdCj6UKWwLhu
	5+PdQf78Tjf/4HlvZrvTOBAG2s7rZeg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062596;
	b=lOyiBobJd0AbXHnejW4hLNuYtW5/qZhx4EedLAWDcVJubd6IiRUZktlk8ZBvr/Tt5j5Heh
	ORoTt/0QOuQ2f17novXxC8+eUusQ2aaOb9vM+9OnHx5aTBj5Y/cQLlgPYJEIWxE0k3gVyf
	DrPlXC0qr7wbilc46d/A+mD1TcBvxUo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vria0Z8h;
	spf=pass (imf01.hostedemail.com: domain of 3QnLBagYKCIky4vCC1t11tyr.p1zyv07A-zzx8npx.14t@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3QnLBagYKCIky4vCC1t11tyr.p1zyv07A-zzx8npx.14t@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6a9b7c7f405so584015a12.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062595; x=1791667395; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tZXqnIYzt9QIr5pps91sOm75Wt59xbsH7uSVOSxPBhc=;
        b=Vria0Z8hdeKiIahcjG0dh62N9OFL5pop/WXgoUMA1CuWGRHxqfCu0vhETW9Xojk3g5
         w7QYt2Ckz8j7auf4W0ku7UT0DJfWS07s4d/mVHalByHrPf4WXmSBOZaz7qkrB0n7vqSC
         nPELETRXXEOvvW+HIJKfNC2C0ylyQ88MNCUvNp479V2ljHszAlrGvgbxixzwYcEo5G6J
         xzXrTALF7mazgl+BT4LhB7xEhPcbiKjjLsu+KmIv6IHlrHaAMzcZOPDREwmdExIZtZo+
         8nE9SMd3gYZg4n/7rw5rLtp/0k8sT28OcOvn9Il1rWw9y4wdZIL95tX3F1cGNIh9UVNG
         6/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062595; x=1791667395;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tZXqnIYzt9QIr5pps91sOm75Wt59xbsH7uSVOSxPBhc=;
        b=2WVh2hbq2lGmUG9cb5l4lcUMu80cmP1jiP9qbSY69Ymew/LcpUQhreTptnIz6ZhuB6
         7iXz+uaF95kG1CG4tR7+WbgMtb2490+VvYjKD+KbQebepp6/0rD4Xac5c1d8LUKLT5h+
         AcO0uQXW6R4Ego1w9AgzdV13HKtRHNjn62L1+eSsBonz/Gl3Dx8b6M7bCABlcGEHnzTY
         3Z88OWXiRmURR/6pRYLfgEl0QGtLA/cbS7xPnnLZpU8Uc4hG2ikEiY+54clB5vKAH80Q
         a8BjfPGtfJ6Z1LDS+m4w8gtPT2o9NqAs2UZi3PTGM2uMwMsICE4XRsfmbK8IoyJ8aL5e
         4F+A==
X-Forwarded-Encrypted: i=1; AKwUvBy91ZKMSEyfIfDIpr+F34QrxKt0trd7qHq3PREL8MXYR4xa8gpE7frWC3/AAQlJsnE47edDfQ6ahg==@kvack.org
X-Gm-Message-State: AFq9FYLzL+updJNMV4Jv1wKKaQHkn+Zi9vmhIfrkzf9z5p16kxz3JDps
	Qe5AphC1W9jxjgfYBK3Nzw0JQrDSLRXrY67NaOd1gbwZYXQToG4Wtp/uYgHieNpSeAra4ASbtgn
	tnJLyTg==
X-Received: from edev16-n1.prod.google.com ([2002:a05:6402:a2d0:10b0:6aa:e8d7:1a1])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4605:b0:6ac:7868:b68a
 with SMTP id 4fb4d7f45d1cf-6afad8ce0efmr2325349a12.9.1791062594530; Sat, 03
 Oct 2026 14:23:14 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:40 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-22-lrizzo@google.com>
Subject: [RFC: DMA_PMD 21/22] net/bnxt: Use DMA_PMD memory for tx header
 bounce buffers
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	Willem de Bruijn <willemb@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Joshua Washington <joshwash@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, 
	Tony Nguyen <anthony.l.nguyen@intel.com>, Przemek Kitszel <przemyslaw.kitszel@intel.com>, 
	Alexander Lobakin <aleksander.lobakin@intel.com>, Michael Chan <michael.chan@broadcom.com>, 
	Pavan Chebbi <pavan.chebbi@broadcom.com>, iommu@lists.linux.dev, netdev@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1B20E4000C
X-Stat-Signature: 37uskseg9yowu7tw9ogti4cyy8fqt76j
X-HE-Tag: 1791062595-658107
X-HE-Meta: U2FsdGVkX1+BNFaYqZ1DXvSs1x59dPDVuCtq4HjwuGXYbsMbJmMY6EgYWMGYzdSeDeQeeioTVwc21PH4yCL9TnvRSK2z3t3fxf625ZRd2Ii84P79NaotWsA8y7puHM07yMi2NWMgOTlmaI4mkA4VA9shgGmbJVaFtP+C14LMiFy5m1qfLjGB/6KO0YwCk9mnxH8IdN/fnMYaPtkmQBAcZwFaWqiHjo/5XzqhcYKKAh9TZDBx3oiCepySsrlrn22wU3jVVjZ9D9proGt1KuPwu5vVKSCiW+MY0UwojOQd8rDsNANxUY0d+dVb3ozzn2As9SNlny7VHUuFpgnN2g/dwYLkccFz3QX4WOrW5H7Lml+cunEF21mNI+A/JVTx+HfQ8wg88Wha8jqyqsu0KIcKxNpbbEFPwFJLNkmtUVElPQQODJXqmUT/LyVTdTMgWC31BDeRIQOtajXghMqiisLFH1g9ZtnKVz2VIFFSx3fZn6PW43hxV/irq5cUMpRMLG8HDYxiLjmW5a8mihV2RoZJSmlcQEYhe+HBxDMaubwPurt2w7o/SV8Ykqrr67WjkOW6U/5ui0qo1UXdmCYcbBD81UevgzsizDwniw+HlT/k5jw+f3J6jRNgTj3xF14SybK22gwfsBdT7U24VCTYDhZVDAFScwmfBJxVovDlpeulV8p3ejEIkHpd20Ipsh3LOfF/h6BLimtwN8E2Lex/yY0rzRfInREY1+jY2Zx3a8liaalODAmJ+mzqRZaqPc0bUTjYSeTu3bRvqjqGHF+0HdCuFo5hZPPNpOUO6VAkQGhigV6qW+RLamELWr9mh+E4IrdQjSxTaA161uBV2nEemvwk8IOouk+DnoVcVYos645OXDHuFm0kH7oYxK7fu53jO1gNEw9HkioLptyZE/V43lJn2Z/GJY4wH5OMnrcl2I8+XOf4g/DfMi5YAmi9jVwBv0jdbkLcQgUtgljnGpdBnH3
 BM5V0efQ
 1AmdjyZHtz89RJ0lMWRDbqeYEox6XCj+pT59zSFMYxV9CfTIF69Q0AVor2cWde2bK6717HD12vk7+PMvt23LF/KtzSPblwYVL4Y7aROJSKI0J60gKBe70TM+rfuzDnojPjHBpeS/TdlftfPW/rPaT9qx7F/GmQxAyztWI08Q8dK7MrjkaaZ5K7J82GVk0n9IKJ+kUIM6e8rqyHrn2xklq+b3yxVwIAypDrpoxknKJFkPG6nkQ1KCixwHzqiZ6lfwgwhM+DSFp1cUBl2YO+wE7EJTqopK0z6Yxj5tzRkTGFfhySkfTY8LtF9KrNiQlf1J6cjvX3fzCRGvZYUjh4Eo9WYz0NX5k7hBISHjpZWrmYuC0TEa8dcgV8B17+k7gKsA0Nd2qgAFlPelTlI8Ax56EX/IMHCBJ5md2W7beWmzMUOyTDlp2wPygyxqGGCo08UognpzAm0ippVM7YWy1P2vBvj8YNnU/WTC3iSs41yKs/DhCKezXoYspIgWnCptRtSQfhppG40baxH4mYeqyM+qbnr+Erb4cRnO0f7geYpcyejOTBM2G/oAz3qJpSe2bm2NO898PLt+R3i8sniwS/3o7pfZzmnaZr2fuViuEyX50trQ6vYpJ8eXHjEQndcL+6ipRPHi5GazR12Wd8hUq7twx9RkIYsgEHbxWjyA7sjjwF6kLzec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dev->dma_pmd_tx_hdrs is enabled, allocate a MAX_TCP_HEADER
bounce buffer per TX ring slot out of the DMA_PMD arena. When the
linear portion of a transmitted packet is at most MAX_TCP_HEADER bytes,
copy it into the pre-mapped bounce buffer instead of calling
dma_map_single()/dma_unmap_single() on every packet.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 45 ++++++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  2 +
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index d7728d0c5b6e6..b9c91eb3aaddd 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -680,13 +680,22 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		length = BNXT_MIN_PKT_SIZE;
 	}
 
-	mapping = dma_map_single(&pdev->dev, skb->data, len, DMA_TO_DEVICE);
-
-	if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
-		goto tx_free;
-
-	dma_unmap_addr_set(tx_buf, mapping, mapping);
-	dma_unmap_len_set(tx_buf, len, len);
+	if (txr->tx_hdr_bufs && len + pad <= MAX_TCP_HEADER) {
+		u32 off = RING_TX(bp, prod) * MAX_TCP_HEADER;
+
+		memcpy(txr->tx_hdr_bufs + off, skb->data, len);
+		if (pad && !last_frag)
+			memset(txr->tx_hdr_bufs + off + len, 0, pad);
+		mapping = txr->tx_hdr_bufs_dma + off;
+		dma_unmap_len_set(tx_buf, len, 0);
+	} else {
+		mapping = dma_map_single(&pdev->dev, skb->data, len,
+					 DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(&pdev->dev, mapping)))
+			goto tx_free;
+		dma_unmap_addr_set(tx_buf, mapping, mapping);
+		dma_unmap_len_set(tx_buf, len, len);
+	}
 	flags = (len << TX_BD_LEN_SHIFT) | TX_BD_TYPE_LONG_TX_BD |
 		TX_BD_CNT(last_frag + 2);
 
@@ -800,8 +809,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* start back at beginning and unmap skb */
 	prod = txr->tx_prod;
 	tx_buf = &txr->tx_buf_ring[RING_TX(bp, prod)];
-	dma_unmap_single(&pdev->dev, dma_unmap_addr(tx_buf, mapping),
-			 skb_headlen(skb), DMA_TO_DEVICE);
+	if (dma_unmap_len(tx_buf, len))
+		dma_unmap_single(&pdev->dev, dma_unmap_addr(tx_buf, mapping),
+				 skb_headlen(skb), DMA_TO_DEVICE);
 	prod = NEXT_TX(prod);
 
 	/* unmap remaining mapped pages */
@@ -885,7 +895,6 @@ static bool __bnxt_tx_int(struct bnxt *bp, struct bnxt_tx_ring_info *txr,
 			dma_unmap_single(&pdev->dev, dma_addr, dma_len,
 					 DMA_TO_DEVICE);
 		}
-
 		last = tx_buf->nr_frags;
 
 		for (j = 0; j < last; j++) {
@@ -4111,6 +4120,15 @@ static void bnxt_free_tx_rings(struct bnxt *bp)
 
 		ring = &txr->tx_ring_struct;
 
+		if (txr->tx_hdr_bufs) {
+			dma_free_coherent(&pdev->dev,
+					  ring->ring_mem.nr_pages *
+					  TX_DESC_CNT * MAX_TCP_HEADER,
+					  txr->tx_hdr_bufs,
+					  txr->tx_hdr_bufs_dma);
+			txr->tx_hdr_bufs = NULL;
+		}
+
 		bnxt_free_ring(bp, &ring->ring_mem);
 	}
 }
@@ -4181,6 +4199,13 @@ static int bnxt_alloc_tx_rings(struct bnxt *bp)
 			if (rc)
 				return rc;
 		}
+		if (pdev->dev.dma_pmd_tx_hdrs && i >= bp->tx_nr_rings_xdp)
+			txr->tx_hdr_bufs =
+				dma_alloc_coherent(&pdev->dev,
+						   ring->ring_mem.nr_pages *
+						   TX_DESC_CNT * MAX_TCP_HEADER,
+						   &txr->tx_hdr_bufs_dma,
+						   GFP_KERNEL | __GFP_NOWARN);
 		qidx = bp->tc_to_qidx[j];
 		ring->queue_id = bp->q_info[qidx].queue_id;
 		spin_lock_init(&txr->xdp_tx_lock);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index c673b2ce4a0d2..b42bbabc0eb98 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1003,6 +1003,8 @@ struct bnxt_tx_ring_info {
 	struct tx_push_buffer	*tx_push;
 	dma_addr_t		tx_push_mapping;
 	__le64			data_mapping;
+	void			*tx_hdr_bufs;
+	dma_addr_t		tx_hdr_bufs_dma;
 
 	void			*tx_inline_buf;
 	dma_addr_t		tx_inline_dma;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


