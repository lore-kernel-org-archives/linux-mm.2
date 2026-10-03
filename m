Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5282CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AC06B00A9; Sat,  3 Oct 2026 17:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2D36B00AA; Sat,  3 Oct 2026 17:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709506B00AB; Sat,  3 Oct 2026 17:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4941D6B00A9
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C7E1CA6E99
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:12 +0000 (UTC)
X-FDA: 85282590624.05.36EDD0A
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id B3EDF40005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CYBHUo4s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3PHLBagYKCIMsyp66vnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3PHLBagYKCIMsyp66vnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7zE5K72n+KulUAR4TVMzQ2qmXtrugcAg+vwkNaLgqTo=;
	b=ZM5emQKWL7jAghSNd0HsR9bOLAULs4U68EpmdOHhaAJvRgRSmmo/HIKzw5gQ12kY2UyqBa
	IyKFOxF3OiuAJdK7d8pit5YsJ1yKqQxQ2hjMrtP55IUEf+nZJfKzhbNiD32oFucZJ7pi0h
	1AtLXZrrODyW+1f8Xnqhf9Net/uyWZo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CYBHUo4s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of 3PHLBagYKCIMsyp66vnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3PHLBagYKCIMsyp66vnvvnsl.jvtspu14-ttr2hjr.vyn@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062590;
	b=MFcBUUy4wl1rw7G0rvAvOQYbnZkEZZuJfDNGRUiysFrQ9llHOlHBbhopWgYpfHlzlHINGc
	9EM2hwmZm4P+qMMZZKF9mVNmBTVvqN0Ofy4GjfTuC5Yt8W35JDw6Nrv1J1u2W0JVFWMTzu
	nNCoUg5/n2yT2iSBj3aqkk5Lpv4/mIY=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c11f2b9f62fso55354566b.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062589; x=1791667389; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7zE5K72n+KulUAR4TVMzQ2qmXtrugcAg+vwkNaLgqTo=;
        b=CYBHUo4sAcX1JuyoQmIfNk4tL3B7fEMxij5JtzVAPMMyh2cEHj0gJN1rvmUYVvLkzJ
         uq7QCGJzeFvxBkd5ZgyN9WM6MTR/qoybKab0IdmmRvROvmzrWCUefpKcUUBa+H3KGV/W
         9MUZSAaArfc2cAh2bPjpx4KLuq6usa21/fiwOW/bOcmOysSQ8KOT08RSK3Yjx8wcoSYb
         EZAOQPBaGzAK8cXW34pTJ4YR79t7elovQUuUdLBdh8l38zKF8e217kbgaY3sx6PavOWH
         PE+ob/M5MUC9bJ4/AA/VaQpf9+DKO+L7gSXV8CCaBdiqjSX2r7dgUrcij7E+iOar5FI2
         rAYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062589; x=1791667389;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7zE5K72n+KulUAR4TVMzQ2qmXtrugcAg+vwkNaLgqTo=;
        b=HnVO0Zs4zvMRqhzlJL74A2od5TKHBg7f7prHfyZAIFtT5Mv2d7JqY1RxZxVFsBXF/f
         rt0Wel+S764XH2Y+CvHfu7EMqzrb1plMs3TsZtAVK+vISu6llsqEKlJQG2yuiTB9g+MF
         r/TzTzluiV357Iz91kBSZr4JtswzX3edZyYOhu8C/96lUCmbZlYJjFjT/aKyH91IEyi1
         7mtWBMOX9lYsG53fPOw2uMM3DvPSmgtI3a1Fy9YVIzg+jk7z4C3sTsiB9LYQDaxIvYpg
         EbWLuyGT+JhcqoeQ5kmQcvWGDnbBNgNFvNTJolqlQnnZKz5D2rnToXppMXifWfLHj/nT
         WD/g==
X-Forwarded-Encrypted: i=1; AKwUvByFTzz56Pbqah1FyabgwhmfaGYyZrZQChVp5gCYcfz7HXPK3BrmxbzD6+IxgeTKbUQRC84N8v/Uyg==@kvack.org
X-Gm-Message-State: AFuF++k3m9oO9UtA+xbFKIdkGYa6M0AiiURbhFoI7pZDRISiCExWzc0O
	NYEIGJE0/GpgceZlvoRLWCeA0AOKJroKigOBj7Y/ZOU9arzxwoLxh5pZtzgr/DPGSuFO0excYtq
	s+jM1KQ==
X-Received: from ejiu17.prod.google.com ([2002:a17:906:ed1:b0:c2e:4ce4:b30])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:94cf:b0:c27:420b:7c90
 with SMTP id a640c23a62f3a-c2e6f278111mr294082166b.48.1791062588878; Sat, 03
 Oct 2026 14:23:08 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:36 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-18-lrizzo@google.com>
Subject: [RFC: DMA_PMD 17/22] net/gve: Use DMA_PMD memory for RX buffers
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
X-Stat-Signature: 3zr73k3rq6dm66c81gpa8ytdau53m3ix
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3EDF40005
X-HE-Tag: 1791062590-82864
X-HE-Meta: U2FsdGVkX193tUg6E+G51/zNUPOmZmcZDHxwQrTIKDnkD0tPwTfgA0vJpl7YU+HXCLMqyqvbN+Gmv36Ys3X12O3V+mtZGljbq2Grq3IR0zdpCVUu6gAqDNvBCMXpGkLYO6zhUWJX16NiyNkEoLuqI+23ePRc12hKQsztmM+AwMW/3EXD4mrKYHPzM+k3eOkGoIuZYSPJxGHm5ZccRJf1H090JW7DE8ES7SyjElubflK+YPXhUgn/mfLWyysB8hDtBiTSKiu4FSiw4IG2wP/s+raFsBpDuup9uQdp38oEI7dcuWDCnqYKTalOH8N/JOdrMQlpU2vKV65G2M+iyPDFR7dibFgcVtAvs0Tt5KOa1zG3RVOo8m7tlT3w2R7ogv3c0Mz0E+9X8RO5ukgmFk1fRwSyyifoVWiW3YVolmGFZEzXKLKcz7nHpmKl7dr2pPwgVn0714A0ZR/HCLts6aOVuRFUnsgWqJZVIp23l8sb+tpmpot/EU9mqGrIApnY9/4F3hVLwYqDNqdr2Y2EOdgSNQmPWwFT1tA0x6KrOyZ5FNlGwOStD6q5Mo3lX9sUsq1XZBYhH4HWzJ8L84MT+MzyKiYSz7zcqRRTvirT8quokXoW3VJsZIME635pBBlBUK3x20XKezRZTcz8iMqsmiBjpjEi8t9LLV5tyZGOZZDncHFWSwwKkggNn/lfSH7rRYXQL3jTbi7EDksbeubgpI15H4CYZxNZ0u732SysppUpR8JoYUIvhwf63rSui/caEIFcPNPEUqxG7HxPoP0c9X0rPKeA6i2qa9Wpd/ZDH+iuqytVc3q/UM3T78O66zlN63desd3wcardXjfhBke4/D9rcWIzkrDu5NyYAF1wtIX3VKxdmPeNlE98SKeGjh8P+ggqY9WSqFRk4XQAXezyvOV/xk31oEdi9PRf0OJAJZXNeLhHlEXgR1sm1KXBV597OeWls3FfoxoB9LR93yIUybV
 OrAcl8ta
 cxY0uqpQLc1clQSoA1GXXc+LDXKYT2g+Pks4TV/U36xKYytWxmgiHddNhBvK6t4dwRUOr7eUO/ryrpvC4dN6Ng22IDEEuU7GGCrfE7HbhKB6JWK7L/a4qu34jv8vqy7MIXOsIkfJtAJrEdm0KPyAf0IhdiwV99d8a17jJuONUnA9uTqkDcnjBB4sXrmoKDVOFTbY5onxeH1Xr65z3rryvHp4BB11hznNq8Ljl6Gm2zVtw0q2r2r09LrrlWVOJT/+iI30Khbz5pq4aQ26SaDT3zcWYO5x3dw6iTxBlDxLmYtXDLEtYHOB8vSufs+EkDgLzwWqGspbhV0m3k1Ok3xZGXvDKLHgCVO+V7sD5mlfbrEUOP2+RscRZTKPinvunT4PnVYlfr4O8pukiLYMP832nU2dBhgxMryRndGmZqP7me0t+ko6jPtkF16+REAWMj2UX7AOM5pW+ne11ZdeJ2/GmQYS/9/6sWPAOy32qq4eyscuBHnZYBSPC/E0EXQyAdFTozqWvuYQKbX6KJu304Xl2NMkYKgoOV6qOPj968zD473wfRRrYERtH5sFb5Y0gczDNorwVV2yoU1uwhn0LmYFJ/8fQW9QgTCx8nNrVmL6XJawnvSEkhl/Q4gTA69dOcKQ09cRlZx48ffOF20oNky1VBR0PdHdMWDhIWn/Hmnajct94zWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dev->dma_pmd_rxbuf is enabled, back GQI-RDA RX packet buffers with
a per-queue DMA_PMD page pool (rx->dma_pmd_pool); DQO-RDA uses page_pool,
which checks dev->dma_pmd_rxbuf directly.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/google/gve/gve.h      |  2 +
 drivers/net/ethernet/google/gve/gve_main.c |  5 ++
 drivers/net/ethernet/google/gve/gve_rx.c   | 61 ++++++++++++++++------
 3 files changed, 53 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index c280ff35ee771..11330404f681b 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -10,6 +10,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/ethtool_netlink.h>
+#include <linux/dma-pmd.h>
 #include <linux/netdevice.h>
 #include <linux/net_tstamp.h>
 #include <linux/pci.h>
@@ -258,6 +259,7 @@ struct gve_rx_ring {
 			u32 qpl_copy_pool_mask;
 			u32 qpl_copy_pool_head;
 			struct gve_rx_slot_page_info *qpl_copy_pool;
+			struct dma_pmd_pool *dma_pmd_pool;
 		};
 
 		/* DQO fields. */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 9cc343a162712..e5631987b050f 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1055,6 +1055,11 @@ static int gve_queues_mem_alloc(struct gve_priv *priv,
 	if (err)
 		goto free_tx;
 
+	if (rx_alloc_cfg->raw_addressing && priv->pdev->dev.dma_pmd_rxbuf)
+		dev_info(&priv->pdev->dev,
+			 "DMA_PMD rx_bufs pool: enabled on %u RX queue(s)\n",
+			 rx_alloc_cfg->qcfg_rx->num_queues);
+
 	return 0;
 
 free_tx:
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 81ea800e66e94..45b5e841efcd3 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -121,6 +121,7 @@ void gve_rx_free_ring_gqi(struct gve_priv *priv, struct gve_rx_ring *rx,
 	}
 
 	gve_rx_unfill_pages(priv, rx, cfg);
+	rx->dma_pmd_pool = dma_pmd_pool_destroy(rx->dma_pmd_pool);
 
 	if (rx->data.data_ring) {
 		bytes = sizeof(*rx->data.data_ring) * slots;
@@ -159,14 +160,29 @@ static void gve_setup_rx_buffer(struct gve_rx_ring *rx,
 static int gve_rx_alloc_buffer(struct gve_priv *priv, struct device *dev,
 			       struct gve_rx_slot_page_info *page_info,
 			       union gve_rx_data_slot *data_slot,
-			       struct gve_rx_ring *rx)
+			       struct gve_rx_ring *rx, gfp_t gfp)
 {
-	struct page *page;
+	struct page *page = NULL;
 	dma_addr_t dma;
-	int err;
+	int err = 0;
 
-	err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
-			     GFP_ATOMIC);
+	if (rx->dma_pmd_pool) {
+		page = dma_pmd_pool_alloc_node(rx->dma_pmd_pool,
+					       gfp | __GFP_NOWARN, priv->numa_node);
+		if (page) {
+			dma = dma_map_page(dev, page, 0, PAGE_SIZE,
+					   DMA_FROM_DEVICE);
+			if (dma_mapping_error(dev, dma)) {
+				priv->dma_mapping_error++;
+				put_page(page);
+				page = NULL;
+				err = -ENOMEM;
+			}
+		}
+	}
+	if (!page && !err)
+		err = gve_alloc_page(priv, dev, &page, &dma, DMA_FROM_DEVICE,
+				     gfp);
 	if (err) {
 		u64_stats_update_begin(&rx->statss);
 		rx->rx_buf_alloc_fail++;
@@ -209,7 +225,8 @@ static int gve_rx_prefill_pages(struct gve_rx_ring *rx,
 		}
 		err = gve_rx_alloc_buffer(priv, &priv->pdev->dev,
 					  &rx->data.page_info[i],
-					  &rx->data.data_ring[i], rx);
+					  &rx->data.data_ring[i], rx,
+					  GFP_KERNEL);
 		if (err)
 			goto alloc_err_rda;
 	}
@@ -319,6 +336,8 @@ int gve_rx_alloc_ring_gqi(struct gve_priv *priv,
 			err = -ENOMEM;
 			goto abort_with_copy_pool;
 		}
+	} else if (hdev->dma_pmd_rxbuf) {
+		rx->dma_pmd_pool = dma_pmd_pool_create(0, 8);
 	}
 
 	filled_pages = gve_rx_prefill_pages(rx, cfg);
@@ -365,6 +384,7 @@ int gve_rx_alloc_ring_gqi(struct gve_priv *priv,
 abort_filled:
 	gve_rx_unfill_pages(priv, rx, cfg);
 abort_with_qpl:
+	rx->dma_pmd_pool = dma_pmd_pool_destroy(rx->dma_pmd_pool);
 	if (!rx->data.raw_addressing) {
 		gve_free_queue_page_list(priv, rx->data.qpl, qpl_id);
 		rx->data.qpl = NULL;
@@ -495,13 +515,19 @@ static void gve_rx_flip_buff(struct gve_rx_slot_page_info *page_info, __be64 *sl
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
+		if (rx && rx->dma_pmd_pool &&
+		    !dma_is_pmd_page(page_to_pfn(page_info->page)) &&
+		    dma_pmd_pool_has_free(rx->dma_pmd_pool))
+			return 0;
 		return 1;
+	}
 	/* This page is still being used by an SKB - we can't reuse */
 	else if (pagecount > page_info->pagecnt_bias)
 		return 0;
@@ -545,7 +571,7 @@ static struct sk_buff *gve_rx_copy_to_pool(struct gve_rx_ring *rx,
 
 	copy_page_info = &rx->qpl_copy_pool[pool_idx];
 	if (!copy_page_info->can_flip) {
-		int recycle = gve_rx_can_recycle_buffer(copy_page_info);
+		int recycle = gve_rx_can_recycle_buffer(NULL, copy_page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(rx->gve);
@@ -665,7 +691,7 @@ static struct sk_buff *gve_rx_skb(struct gve_priv *priv, struct gve_rx_ring *rx,
 			u64_stats_update_end(&rx->statss);
 		}
 	} else {
-		int recycle = gve_rx_can_recycle_buffer(page_info);
+		int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 		if (unlikely(recycle < 0)) {
 			gve_schedule_reset(priv);
@@ -971,7 +997,7 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 			 * owns half the page it is impossible to tell which half. Either
 			 * the whole page is free or it needs to be replaced.
 			 */
-			int recycle = gve_rx_can_recycle_buffer(page_info);
+			int recycle = gve_rx_can_recycle_buffer(rx, page_info);
 
 			if (recycle < 0) {
 				if (!rx->data.raw_addressing)
@@ -983,11 +1009,16 @@ static bool gve_rx_refill_buffers(struct gve_priv *priv, struct gve_rx_ring *rx)
 				union gve_rx_data_slot *data_slot =
 						&rx->data.data_ring[idx];
 				struct device *dev = &priv->pdev->dev;
-				gve_rx_free_buffer(dev, page_info, data_slot);
-				page_info->page = NULL;
+				struct gve_rx_slot_page_info old_info = *page_info;
+				union gve_rx_data_slot old_slot = *data_slot;
+
 				if (gve_rx_alloc_buffer(priv, dev, page_info,
-							data_slot, rx)) {
-					break;
+							data_slot, rx, GFP_ATOMIC)) {
+					if (page_count(page_info->page) >
+					    page_info->pagecnt_bias)
+						break;
+				} else {
+					gve_rx_free_buffer(dev, &old_info, &old_slot);
 				}
 			}
 		}
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


