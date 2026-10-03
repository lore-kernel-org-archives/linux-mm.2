Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A2CCA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2B66B00AA; Sat,  3 Oct 2026 17:23:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BA8A6B00AB; Sat,  3 Oct 2026 17:23:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEBF6B00AC; Sat,  3 Oct 2026 17:23:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 261C46B00AA
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADB4DA0A0D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:13 +0000 (UTC)
X-FDA: 85282590666.19.D555CD1
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1161120009
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UtjmzQoq;
	spf=pass (imf29.hostedemail.com: domain of 3PnLBagYKCIUu0r88xpxxpun.lxvurw36-vvt4jlt.x0p@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3PnLBagYKCIUu0r88xpxxpun.lxvurw36-vvt4jlt.x0p@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ekKJz+HTYRvtVEqBBOEAxTGImVFcYe3lcvJJhW15OKU=;
	b=Yj641Hgb7PARJJmSsDqiG6O+TPNsBMtWOFxZoEpktC1F5RqDXtx9Mg8yhfFcOhSONluuqe
	pUbo5Th6Dxa/uMXlB/1+jbWR4Fr2KwN1lmh00xWtyYL9gRA0Azn8yY1yhczGJSjVoXs8FS
	Ghklzr6Aiq+S6QWzMsVY5JHeV5jxl8I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UtjmzQoq;
	spf=pass (imf29.hostedemail.com: domain of 3PnLBagYKCIUu0r88xpxxpun.lxvurw36-vvt4jlt.x0p@flex--lrizzo.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3PnLBagYKCIUu0r88xpxxpun.lxvurw36-vvt4jlt.x0p@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062592;
	b=owCXsTrUogvYVfoxA+X8eMtAR5jhqBFo0gMk/WxTud9tl6U0i4nfaByHpg0EYFbr83jOQi
	3a4rpL+FkL4YpPREW5OXnCrJkr/Ks0k2zNjHCiTBajBLQMONbmffkXFq3sNQZ1qehHA6KN
	/Zi9t6G5HssJQxR6qXaEmVwE/3xnNog=
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c251c140b41so77585266b.3
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062591; x=1791667391; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ekKJz+HTYRvtVEqBBOEAxTGImVFcYe3lcvJJhW15OKU=;
        b=UtjmzQoq0lTt0hTYQjZd6oVqG/qohxgLxxaQfhpf/b/eIuPDV6kWPy9QIffyX3j4oH
         shEWoEN5zl4g2EBGYetPpzooP/AJAduhRd97gmI6S4ZWabhqm9+vc+1QLRdhwOCWjm8V
         0xU2/2A93dz5xTimPdaNqryvZZt4RlMvSvuq+fdfYxFf4j92OA5tOdk5Xus06z/0y8kj
         +xuFdHTuoRiTy2uLrbe9J/8u7/YPCDW4t+CgtbQ9abKRVkcieYmmMODHQsydxcobMoO8
         70P5Fe4zy1HP3AYfGuLeGBJbh8dDNN/r7WMomwGlkilCwaYSAhBACKonQqrj2wNxFIsu
         jCDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062591; x=1791667391;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ekKJz+HTYRvtVEqBBOEAxTGImVFcYe3lcvJJhW15OKU=;
        b=orEztlyDzoAL/D2kpizpiGTU+Rm3zOVxebGXIr3f7a3dd4Ep3tB9U1SuzYmhV9McO4
         BVIP4NxUzHMGeGEHrJ776PCLoLIqlWJ8LgOfSarW+4bNGwJoQMAyTOtlZLJJwHnmVgyD
         Xu6drEhqRBPfZHsKdwyf1z5M9lDSAk2lz+0xukujkkIFDnsF6jUaFYPSfoxhhZJoZ8Rr
         GNTBkwsK0yn90+4W8OfaNdIzf3G8diA8YJK2iCkPuFpEs7UTverux30TflN0prkuIDkq
         lZUDUxBRrqNGlogtipMutBpUFt86MEWtUyHcw6pTPx5TVoC5Jcmz2Bc64wPo2Nw20zVa
         FbSA==
X-Forwarded-Encrypted: i=1; AKwUvBz0f+GhR/kF2mACyzjyZLoFhZn3CT27E9H0TI+ybyIvM2qXgCbcOt/DPz+PhFe53yh1MvR136SUZA==@kvack.org
X-Gm-Message-State: AFq9FYJYKZZOYIWf6y/89Fcx1XVvetmF8BaxoLARVyXntOoATtSJQA3a
	2dHv4/UB7FUDHSW+qUGUwaDcCuwN72ZdcN/qqxLKrtacXbqMU1ruc7N+5J674iswgpbd6ZvI7C/
	0olgCjQ==
X-Received: from ejbhk6.prod.google.com ([2002:a17:906:c9c6:b0:c2d:efb7:91a3])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:4fc9:b0:c2e:3307:b922
 with SMTP id a640c23a62f3a-c2e4ade0f4emr633013566b.28.1791062590162; Sat, 03
 Oct 2026 14:23:10 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:37 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-19-lrizzo@google.com>
Subject: [RFC: DMA_PMD 18/22] net/gve: Use DMA_PMD memory for tx header bounce buffers
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
X-Stat-Signature: 1twqedsuhnrqwof94cajnoa7f9pzm5eb
X-Rspamd-Queue-Id: F1161120009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1791062591-418401
X-HE-Meta: U2FsdGVkX1/jNzlIX5VkYErKMm5+iBdWt80+AwNFxKPOCtgbjSeIbrkxqgmhd8cu/H4MiX7LEIruooUc0oa2N0j6+4RetIeh/ugdksizMZa7jO9ciwi0g93bBm9im/EYM/VbGZn4rzHjpzHLD9m5m0X2rMyEkGKcIOmcEPPRK1a76hEfaS+XaiyUPf4dqgwNGapjE/+A2gg8rTJDod1uitx6MFfwuQ34rB95y3/0mnYJVlMDbNf95fTub6FM/+cq6Jn3cQas0o1Z/AwdUL5v0EWJVFEjgNXaQA4/KNyrDvEszVRS8I1qtUb4TbC260f+S/Y2B38Pe2EJOf7nCt13aP5tUzGQkt27Rp1CVIONtG9begw1J+uKO4f941dyyyn22yxGEUqF10AmhaX8bditxn8WJEhNtP936gDE5C5elPHuvdooQRjhKC83VdXIIYBhRLpZ2nh2LH9vKE6V7KdkyrUpiTLFPIvBrHBP2caT9Xq9O+dAsYag4Cbx2sHNnXY8yZPvxqVeQE8HCX0NItQRPL+so/fIG352+OGaNHjAwui4O2ZeAzxJDacQ2hzHlC9YKv+pm1Z332FEVvrvIh7ko/UpH9UjkHCsUgSIRytKMDwmrmQXHfea763nKqb0faf9lbOBtF72T96M57szlImicYOVLrg7JH53oWGOTlPt8aVb/jxFXy9xnCfZDEDts6UpI13MGFdFh2CpacvXAbZwqPM6Gm5kD/+XbmypiVsqjUqRrIYgbtzgmc1nz7jNyLt1iMY4TaWOXa9uN8b200QICi8L4I2ju4h/yTVvD9QBdQArcsuSTNowr3/T1AamzSsaEiJQvyp5FSlpyapStiosnmzwV9mkuihGRKP9F9OJXz+xvXN1cQnotVwh/vIzLzLsZar1D7eZ7gLDdyyNFRNXolTLSs05x5ntupBVSCTncSQGtWmUo6mEKikivWcAD4avdLA92+d3L8/gw/cU6LY
 N4MgkjEC
 oQk/0dXj2QdUHx2icJ+kMQDmqRH9c9CYfcHAZ9iWA+57IO0x8/RVfPhhyzTsqSFSV1SgEFQf2KQgsmv8OMUruij0EMbR9m0VvYhR5+0E4kd5VZWxLT51sukB3oNWb+/KNVR4pJISVkGcaAfBKHE85nnVgCMCkEiQE480rojwYwOyOp1NIgwVGjH6eh12M2YiyhDHGlgq2y3VR/fxXcn+nstum+HaTnUddapQu7eSdbJ/GTV38+5lnTDkhKVTpWSJDSQoUkEIoFteCUUMybouJf23sWl5bDPR9DIkxagmNLojLlWeR7wzyBiXyga25JzBUjR3f1HU095heC4S5RALhIcsLaC5F8tQDE0bZndl+fknbVcl6dB5P7HmkSlgCLifJSstPehti0irdkcBMMqqALTf1wAahUUrrawbOrUuVO9sCbC7PUPbYzXYtbu/ANSAJ+/PKEbwHnPIvqb9aesaXL+kiyPdgdqs9YJximuVG5sPeaSwI7JSQ+Q0Nr0WHnAARPiB218DwDgj0F2M9QriKjgfS0jCU6lNYbNNcjQ2tTw+mvyHW5/0UDU4yju7Z4YuTJcxlzA7KPQ7agAXxMJO7v6nm3xHaTNuSsIdBHTUSvWibSC/qmXhY9wQYU+B3HYdQ/trSV72HXnsAhGS+iNkLsRSZ6n0Vq+xME5IA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dev->dma_pmd_tx_hdrs is enabled, allocate a MAX_TCP_HEADER
bounce buffer per TX slot/packet out of the DMA_PMD arena in raw-addressing
mode (both GQI and DQO). When skb_headlen(skb) <= MAX_TCP_HEADER, the
linear portion is copied into the pre-mapped bounce buffer instead of
calling dma_map_single()/dma_unmap_single() on every packet.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  3 ++
 drivers/net/ethernet/google/gve/gve_tx.c     | 38 ++++++++++++++---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 45 +++++++++++++++-----
 3 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 11330404f681b..00e438fe05a50 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -18,6 +18,7 @@
 #include <linux/ptp_clock_kernel.h>
 #include <linux/u64_stats_sync.h>
 #include <net/page_pool/helpers.h>
+#include <net/tcp.h>
 #include <net/xdp.h>
 
 #include "gve_desc.h"
@@ -642,6 +643,8 @@ struct gve_tx_ring {
 			};
 		} dqo;
 	} ____cacheline_aligned;
+	void *tx_hdr_bufs;
+	dma_addr_t tx_hdr_bufs_dma;
 	struct netdev_queue *netdev_txq;
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
 	struct device *dev;
diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
index 79338fd9bf66e..9610b54ef4792 100644
--- a/drivers/net/ethernet/google/gve/gve_tx.c
+++ b/drivers/net/ethernet/google/gve/gve_tx.c
@@ -224,6 +224,11 @@ static void gve_tx_free_ring_gqi(struct gve_priv *priv, struct gve_tx_ring *tx,
 	u32 slots;
 
 	slots = tx->mask + 1;
+	if (tx->tx_hdr_bufs) {
+		dma_free_coherent(hdev, slots * MAX_TCP_HEADER,
+				  tx->tx_hdr_bufs, tx->tx_hdr_bufs_dma);
+		tx->tx_hdr_bufs = NULL;
+	}
 	dma_free_coherent(hdev, sizeof(*tx->q_resources),
 			  tx->q_resources, tx->q_resources_bus);
 	tx->q_resources = NULL;
@@ -298,6 +303,11 @@ static int gve_tx_alloc_ring_gqi(struct gve_priv *priv,
 		/* map Tx FIFO */
 		if (gve_tx_fifo_init(priv, &tx->tx_fifo))
 			goto abort_with_qpl;
+	} else if (hdev->dma_pmd_tx_hdrs) {
+		tx->tx_hdr_bufs = dma_alloc_coherent(hdev,
+						     cfg->ring_size * MAX_TCP_HEADER,
+						     &tx->tx_hdr_bufs_dma,
+						     GFP_KERNEL);
 	}
 
 	tx->q_resources =
@@ -311,6 +321,12 @@ static int gve_tx_alloc_ring_gqi(struct gve_priv *priv,
 	return 0;
 
 abort_with_fifo:
+	if (tx->tx_hdr_bufs) {
+		dma_free_coherent(hdev,
+				  cfg->ring_size * MAX_TCP_HEADER,
+				  tx->tx_hdr_bufs, tx->tx_hdr_bufs_dma);
+		tx->tx_hdr_bufs = NULL;
+	}
 	if (!tx->raw_addressing)
 		gve_tx_fifo_release(priv, &tx->tx_fifo);
 abort_with_qpl:
@@ -423,6 +439,8 @@ static inline int gve_skb_fifo_bytes_required(struct gve_tx_ring *tx,
 #define MAX_TX_DESC_NEEDED	(MAX_SKB_FRAGS + 4)
 static void gve_tx_unmap_buf(struct device *dev, struct gve_tx_buffer_state *info)
 {
+	if (!dma_unmap_len(info, len))
+		return;
 	if (info->skb) {
 		dma_unmap_single(dev, dma_unmap_addr(info, dma),
 				 dma_unmap_len(info, len),
@@ -657,13 +675,21 @@ static int gve_tx_add_skb_no_copy(struct gve_priv *priv, struct gve_tx_ring *tx,
 
 	info->skb =  skb;
 
-	addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(tx->dev, addr))) {
-		tx->dma_mapping_error++;
-		goto drop;
+	if (tx->tx_hdr_bufs && len <= MAX_TCP_HEADER) {
+		u32 hdr_off = idx * MAX_TCP_HEADER;
+
+		memcpy(tx->tx_hdr_bufs + hdr_off, skb->data, len);
+		addr = tx->tx_hdr_bufs_dma + hdr_off;
+		dma_unmap_len_set(info, len, 0);
+	} else {
+		addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(tx->dev, addr))) {
+			tx->dma_mapping_error++;
+			goto drop;
+		}
+		dma_unmap_len_set(info, len, len);
+		dma_unmap_addr_set(info, dma, addr);
 	}
-	dma_unmap_len_set(info, len, len);
-	dma_unmap_addr_set(info, dma, addr);
 
 	num_descriptors = 1 + shinfo->nr_frags;
 	if (hlen < len)
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index ad99cbb77e291..ac69793492c9f 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -176,8 +176,9 @@ static void gve_unmap_packet(struct device *dev,
 		return;
 
 	/* SKB linear portion is guaranteed to be mapped */
-	dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
-			 dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
+	if (dma_unmap_len(pkt, len[0]))
+		dma_unmap_single(dev, dma_unmap_addr(pkt, dma[0]),
+				 dma_unmap_len(pkt, len[0]), DMA_TO_DEVICE);
 	for (i = 1; i < pkt->num_bufs; i++) {
 		netmem_dma_unmap_page_attrs(dev, dma_unmap_addr(pkt, dma[i]),
 					    dma_unmap_len(pkt, len[i]),
@@ -232,6 +233,13 @@ static void gve_tx_free_ring_dqo(struct gve_priv *priv, struct gve_tx_ring *tx,
 	size_t bytes;
 	u32 qpl_id;
 
+	if (tx->tx_hdr_bufs) {
+		dma_free_coherent(hdev,
+				  tx->dqo.num_pending_packets * MAX_TCP_HEADER,
+				  tx->tx_hdr_bufs, tx->tx_hdr_bufs_dma);
+		tx->tx_hdr_bufs = NULL;
+	}
+
 	if (tx->q_resources) {
 		dma_free_coherent(hdev, sizeof(*tx->q_resources),
 				  tx->q_resources, tx->q_resources_bus);
@@ -399,6 +407,12 @@ static int gve_tx_alloc_ring_dqo(struct gve_priv *priv,
 
 		if (gve_tx_qpl_buf_init(tx))
 			goto err;
+	} else if (hdev->dma_pmd_tx_hdrs) {
+		tx->tx_hdr_bufs =
+			dma_alloc_coherent(hdev,
+					   tx->dqo.num_pending_packets * MAX_TCP_HEADER,
+					   &tx->tx_hdr_bufs_dma,
+					   GFP_KERNEL);
 	}
 
 	return 0;
@@ -712,12 +726,20 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 		u32 len = skb_headlen(skb);
 		dma_addr_t addr;
 
-		addr = dma_map_single(tx->dev, skb->data, len, DMA_TO_DEVICE);
-		if (unlikely(dma_mapping_error(tx->dev, addr)))
-			goto err;
+		if (tx->tx_hdr_bufs && len <= MAX_TCP_HEADER) {
+			u32 hdr_off = (u32)completion_tag * MAX_TCP_HEADER;
 
-		dma_unmap_len_set(pkt, len[pkt->num_bufs], len);
-		dma_unmap_addr_set(pkt, dma[pkt->num_bufs], addr);
+			memcpy(tx->tx_hdr_bufs + hdr_off, skb->data, len);
+			addr = tx->tx_hdr_bufs_dma + hdr_off;
+			dma_unmap_len_set(pkt, len[pkt->num_bufs], 0);
+		} else {
+			addr = dma_map_single(tx->dev, skb->data, len,
+					      DMA_TO_DEVICE);
+			if (unlikely(dma_mapping_error(tx->dev, addr)))
+				goto err;
+			dma_unmap_len_set(pkt, len[pkt->num_bufs], len);
+			dma_unmap_addr_set(pkt, dma[pkt->num_bufs], addr);
+		}
 		++pkt->num_bufs;
 
 		gve_tx_fill_pkt_desc_dqo(tx, desc_idx, enable_csum, len, addr,
@@ -748,10 +770,11 @@ static int gve_tx_add_skb_no_copy_dqo(struct gve_tx_ring *tx,
 err:
 	for (i = 0; i < pkt->num_bufs; i++) {
 		if (i == 0) {
-			dma_unmap_single(tx->dev,
-					 dma_unmap_addr(pkt, dma[i]),
-					 dma_unmap_len(pkt, len[i]),
-					 DMA_TO_DEVICE);
+			if (dma_unmap_len(pkt, len[i]))
+				dma_unmap_single(tx->dev,
+						 dma_unmap_addr(pkt, dma[i]),
+						 dma_unmap_len(pkt, len[i]),
+						 DMA_TO_DEVICE);
 		} else {
 			dma_unmap_page(tx->dev,
 				       dma_unmap_addr(pkt, dma[i]),
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


