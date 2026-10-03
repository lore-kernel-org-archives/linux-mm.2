Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD934CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55C4A6B00AD; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6296B00AF; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AD2B6B00AD; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 08F396B00AB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93CDFA0A0D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:16 +0000 (UTC)
X-FDA: 85282590792.06.CC3B018
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id B935B40007
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NTYcXErZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3QHLBagYKCIcw2tAAzrzzrwp.nzxwty58-xxv6lnv.z2r@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3QHLBagYKCIcw2tAAzrzzrwp.nzxwty58-xxv6lnv.z2r@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3OL/zoqqGDD0aU88aaqUVRrKPVNP3UBVkh8EHXtEjE=;
	b=Zl36SfSijmM71ezEvhuRc4cYRLIBVBs9sKd6THBv2/+0VHc39DlAWqMlBhHzza7JPjIE9D
	wIT5r+4qYcFEdUZVTdNQqEiM8e/jja4AjDJFZbi6kiH22D6FmzO2cUzh86T9OlN5Aa6oRV
	8JRem7Y/GnzIHpWECkShfPr1qHuSLxY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NTYcXErZ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3QHLBagYKCIcw2tAAzrzzrwp.nzxwty58-xxv6lnv.z2r@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3QHLBagYKCIcw2tAAzrzzrwp.nzxwty58-xxv6lnv.z2r@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062594;
	b=2SsDowZe4t9kbLxvbKCjNHtLokS6VwUrudlEQVfpSMPhnWgX+o7Sb7abxg8EE4CnAD1KRB
	dXSbAgokBEQ2vBSm+gQPOuSyPDrKM4L8kNnZyGecD445ZMN0XhjBKNe335aN1TJEQ1EY15
	CseHq2VIzN1I9+EOqHImaW2XQc2+1ME=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a9caf60126so495856a12.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062593; x=1791667393; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o3OL/zoqqGDD0aU88aaqUVRrKPVNP3UBVkh8EHXtEjE=;
        b=NTYcXErZF8gf0tT/JhmtHfD+QHjf267hcHzaO+QFmWj09LSlHt1IuMS/9/bmd9akPq
         Ff5lPW5jMAEYoYgcPrkEZOToTlW2l3qBzVvo6p1sr+pv58hvx4U53Qx8gPKUlwvopCsK
         xD64YC4gfmhwOVUwGG5LkEFtk8Zkc5+mNOhxLmSgWT54T8uP5Jt5D7mDuKzRupml8E+v
         gYQJ6qAluT+UAxM2owMuNr3Vms+IogXxyMJBM+nFjovGChJxBHhObsUBnIDw5Xjqe/+F
         zxVWv8hNUJ2/H3JEh2UPVUK7DxoAT1+toATL8Wd2sFSqhygNz7szUD6uXqH1Bq4/xnZG
         u34A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062593; x=1791667393;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o3OL/zoqqGDD0aU88aaqUVRrKPVNP3UBVkh8EHXtEjE=;
        b=tBZjlHYgPmriVu8kGxhkrMv2g5ZH+chQivzNFpy2o5UIomHOOHcaAUW9R/BYxsJhic
         xY40Xzb+CcAEGPMi77+XCgajBR6JJV/wc/FX+qsgtr7NexzCCow+YQlpBbaaYD3lT9pv
         wSq4OdTgic2URVc3UcqIohHAhTWsyTzJf2wzZX1JI504hJiwB0SlbEgeh5PlCFGEZ0cY
         Et9DE9EtthOknj3uLUdwr0cdj5NXqSKHjKrCbNAdpVCl+HmCL4PbT3rK0+cDaUstoC6/
         3SYS2MR/xh+pRv01Uobe+oDzDSPbCl0abAFbPKC23zmGQKktspsWphV43NAP/0MAdLbA
         UnhA==
X-Forwarded-Encrypted: i=1; AKwUvBxZQGaKG22bsN3lvAcd9kDgISWywUBhGTWdfL8RMcBtRyHGPmJKNl5jFwmqNW4srLdcE/2TnpReJw==@kvack.org
X-Gm-Message-State: AFq9FYLLecnsDhhs7BplwPcPayssR++/FSB1l0LFkP2YOoAv0kqlqxCk
	K66K49BjlB5KUVIguEv8+8+tK79Oo3yYdQmpW+lPpBBQZ58kN+1jClrKWJO8dqUeazXtxXP07hH
	sXNdMaA==
X-Received: from edaa13.prod.google.com ([2002:a05:6402:24cd:b0:6ac:c62c:c5e3])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:461a:b0:6af:9bef:cf6d
 with SMTP id 4fb4d7f45d1cf-6af9e2fc8eemr4684173a12.25.1791062592978; Sat, 03
 Oct 2026 14:23:12 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:39 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-21-lrizzo@google.com>
Subject: [RFC: DMA_PMD 20/22] net/idpf: Use DMA_PMD memory for tx header
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
X-Stat-Signature: t755cz3qr4mx5nz8ougpqnjcfpcotsj8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B935B40007
X-HE-Tag: 1791062594-157030
X-HE-Meta: U2FsdGVkX19NC7m+b4v9Xt9qISqVjFJYXTsti7UaKatuhp0HfMvuS/AT03dBX28ivE9X58h4fhdD0U4F0qLzG46pfMMXljjbob8ZfHa+fozbnlb3n4WE1GksGWv0a3ys/Um0lkjZmzrY017WV9AwFfaoTBMLgWayFkBZ+xWXSOuJfJmemXMm8/0Bimoy6HNY5ef7qpwGwrT0MQ1820EOOvKaOP81vt3KgoTIJEz7LLDTY8pI2mWTZ6f22EAlrcQ7mFBideN3f9511W8s+SGC22b4K6GsTsubxH6JHJsOn1ngmIFSnnljy6MVa9ckKa1E57K1LV1j3ngo5Q4DypUQ/R75BQNxjLJgO8Klr9FmAK7P5zERv1zxS97UDz/gGDMT7n15sc8vlHZ9cnPC/CGEN89ww6ThD2i3qYmpYn3sZrvUV9zQbURt4Ssd6CqXgu8DHAUcLxsYx5W5wiCRKssIKsDejrcEk/uUl0ObYo2ipiq2y4187Noozy3YnNrcouAPWWE7K9+EjiJsnxxFEhaCcMQdJWw3SFsugap4AdadMfmnVVIBrE55W9a2VM5p9a8ZNP0MmQ6y8gCxKeg1I6z5cdmZ1cpWpX+QRkgkXyvqeWk0TuS+SP0K59+vG3MRi4srSDOtUGA0lG2hLshgdxwZyEJJ8YgQAgBl/3MaOp7gNzBvhi+qgrK2YH/nwvB23MaprSt4hlCU9JIVqqar27pgvFFdedloGMCHPAiiVm3cjJXFfLz3k4fahocZsE+ALRcv5xBXdS9WaYafGfi70PPdk0HVwdfeeuipOSsIrpnoGHtOrZ7BQWjSoJbaOSw+a8L50x78xnamC1y5z5lBN+NerBk+Kwr64z3a+wPAhanIj7RtYlivDgFceweYP5HU9FTQMCjGSwEw/dPkH85kAGlKjkRbHB5CiBXTPHIM4FKxV8g6r9OSF55O+RQzxYLkoLgSIFe4EarIVzLxIuIoX0c
 5EoVZWr8
 MCE0tjhUe7+DUGTOpZkZkKPJmXEScj15DvRwe79BpAvB+HvampFscybE4aq1WBRhUt0RML0Q4cYkUfoKoPAJdF8O5NlwXpMS1U4ZdOS9SeHxjKUdOIwmS0MxYFe3CjCqtlSotxIBJERX2jCU4UWYgeTRgrXsRsIRwWQCf7FCEcXG3xv3sm9BxiEm5eZGQUZNWyZtMG22rmtMy3M7RnAuR1SF918Gouj2jeKz16Awpr2wGqQrlEkbhEFgUYnYXOagc7zsQHQlOrmeT3JTn/Xe93gumpO2k9troOfq2hZicvkZ80CGFbJGss5wfonbIBovr9j3siWJwVhNCzQhudYF/U5dE7L5XmFJMe5foQ4V/EAFBynL6xobGIUUu0pjY7pV8VYVaS/O3mR/L5BF7vYM4n8yp7mOnv5CLWhO+zi6PG12OfAS7uHp8SxG+vdSgFlOEY1HHuX3osK0NtE8Fu+rKyuBcdHD7o4UT3P3za89eJDv/GnM6TfuhhL2zaleR6opfdivhgmDPfPOOQUcHU1alJEA4BnQJihv9YpZ+9oSaaKco6IcMckQyjWZj7xOol7zCqDA3DAsIZHqqca/eN2oVbpAg856TgVoSAtMazk1ZdfzhYvI3+IE9BXuyLJzXzLtzA/5p88eiIrlPBa5luDlcOcRh1/ZoEjQTO3I2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dev->dma_pmd_tx_hdrs is enabled, allocate a MAX_TCP_HEADER
bounce buffer per TX buffer slot out of the DMA_PMD arena. When the
linear portion of a transmitted packet is at most MAX_TCP_HEADER bytes,
copy it into the pre-mapped bounce buffer and set the SQE unmap length
to 0 instead of calling dma_map_single()/dma_unmap_page() on every
packet.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   |  6 ++---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 21 ++++++++++++---
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   | 27 ++++++++++++++++++-
 include/net/libeth/tx.h                       |  5 ++--
 4 files changed, 50 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
index e3ddf18dcbf51..24a2dfec6212d 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
@@ -261,7 +261,7 @@ static void idpf_tx_singleq_map(struct idpf_tx_queue *tx_q,
 
 	tx_desc = &tx_q->base_tx[i];
 
-	dma = dma_map_single(tx_q->dev, skb->data, size, DMA_TO_DEVICE);
+	dma = idpf_tx_map_hdr(tx_q, skb, first, size);
 
 	/* write each descriptor with CRC bit */
 	if (idpf_queue_has(CRC_EN, tx_q))
@@ -274,8 +274,7 @@ static void idpf_tx_singleq_map(struct idpf_tx_queue *tx_q,
 			return idpf_tx_singleq_dma_map_error(tx_q, skb,
 							     first, i);
 
-		/* record length, and DMA address */
-		dma_unmap_len_set(tx_buf, len, size);
+		/* record DMA address */
 		dma_unmap_addr_set(tx_buf, dma, dma);
 		tx_buf->type = LIBETH_SQE_FRAG;
 
@@ -326,6 +325,7 @@ static void idpf_tx_singleq_map(struct idpf_tx_queue *tx_q,
 
 		size = skb_frag_size(frag);
 		data_len -= size;
+		dma_unmap_len_set(tx_buf, len, size);
 
 		dma = skb_frag_dma_map(tx_q->dev, frag, 0, size,
 				       DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 4311ffa30bb18..4bdec468ea2ce 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -90,6 +90,14 @@ static void idpf_tx_buf_rel_all(struct idpf_tx_queue *txq)
 	else
 		idpf_tx_buf_clean(txq);
 
+	if (txq->hdr_buf_va) {
+		dma_free_coherent(txq->dev,
+				  txq->buf_pool_size * MAX_TCP_HEADER,
+				  txq->hdr_buf_va, txq->hdr_buf_dma);
+		txq->hdr_buf_va = NULL;
+		txq->hdr_buf_dma = 0;
+	}
+
 	kfree(txq->tx_buf);
 	txq->tx_buf = NULL;
 }
@@ -187,6 +195,13 @@ static int idpf_tx_buf_alloc_all(struct idpf_tx_queue *tx_q)
 	if (!tx_q->tx_buf)
 		return -ENOMEM;
 
+	if (tx_q->dev->dma_pmd_tx_hdrs)
+		tx_q->hdr_buf_va =
+			dma_alloc_coherent(tx_q->dev,
+					   tx_q->buf_pool_size * MAX_TCP_HEADER,
+					   &tx_q->hdr_buf_dma,
+					   GFP_KERNEL | __GFP_NOWARN);
+
 	return 0;
 }
 
@@ -2663,7 +2678,7 @@ static void idpf_tx_splitq_map(struct idpf_tx_queue *tx_q,
 
 	tx_desc = &tx_q->flex_tx[i];
 
-	dma = dma_map_single(tx_q->dev, skb->data, size, DMA_TO_DEVICE);
+	dma = idpf_tx_map_hdr(tx_q, skb, first, size);
 
 	tx_buf = first;
 	first->nr_frags = 0;
@@ -2680,8 +2695,7 @@ static void idpf_tx_splitq_map(struct idpf_tx_queue *tx_q,
 		first->nr_frags++;
 		tx_buf->type = LIBETH_SQE_FRAG;
 
-		/* record length, and DMA address */
-		dma_unmap_len_set(tx_buf, len, size);
+		/* record DMA address */
 		dma_unmap_addr_set(tx_buf, dma, dma);
 
 		/* buf_addr is in same location for both desc types */
@@ -2784,6 +2798,7 @@ static void idpf_tx_splitq_map(struct idpf_tx_queue *tx_q,
 
 		size = skb_frag_size(frag);
 		data_len -= size;
+		dma_unmap_len_set(tx_buf, len, size);
 
 		dma = skb_frag_dma_map(tx_q->dev, frag, 0, size,
 				       DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 93547597efd2a..39458a8e5baa0 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -8,6 +8,7 @@
 #include <linux/net/intel/virtchnl2_lan_desc.h>
 
 #include <net/libeth/cache.h>
+#include <net/libeth/tx.h>
 #include <net/libeth/types.h>
 #include <net/netdev_queues.h>
 #include <net/tcp.h>
@@ -639,6 +640,8 @@ libeth_cacheline_set_assert(struct idpf_rx_queue,
  * @q_vector: Backreference to associated vector
  * @buf_pool_size: Total number of idpf_tx_buf
  * @rel_q_id: relative virtchnl queue index
+ * @hdr_buf_va: Base of the TX header bounce buffer array, or NULL
+ * @hdr_buf_dma: DMA address matching @hdr_buf_va
  */
 struct idpf_tx_queue {
 	__cacheline_group_begin_aligned(read_mostly);
@@ -715,6 +718,8 @@ struct idpf_tx_queue {
 
 	u32 buf_pool_size;
 	u32 rel_q_id;
+	void *hdr_buf_va;
+	dma_addr_t hdr_buf_dma;
 	__cacheline_group_end_aligned(cold);
 };
 libeth_cacheline_set_assert(struct idpf_tx_queue, 64,
@@ -723,7 +728,7 @@ libeth_cacheline_set_assert(struct idpf_tx_queue, 64,
 			    offsetofend(struct idpf_tx_queue, timer) +
 			    offsetof(struct idpf_tx_queue, q_stats) -
 			    offsetofend(struct idpf_tx_queue, tstamp_task),
-			    32);
+			    48);
 
 /**
  * struct idpf_buf_queue - software structure representing a buffer queue
@@ -1131,4 +1136,24 @@ int idpf_tso(struct sk_buff *skb, struct idpf_tx_offload_params *off);
 
 void idpf_wait_for_sw_marker_completion(const struct idpf_tx_queue *txq);
 
+static inline dma_addr_t idpf_tx_map_hdr(struct idpf_tx_queue *tx_q,
+					 const struct sk_buff *skb,
+					 struct libeth_sqe *first,
+					 unsigned int size)
+{
+	u32 buf_idx = first - tx_q->tx_buf;
+
+	if (tx_q->hdr_buf_va && buf_idx < tx_q->buf_pool_size &&
+	    size <= MAX_TCP_HEADER) {
+		u32 offset = buf_idx * MAX_TCP_HEADER;
+
+		memcpy(tx_q->hdr_buf_va + offset, skb->data, size);
+		dma_unmap_len_set(first, len, 0);
+		return tx_q->hdr_buf_dma + offset;
+	}
+
+	dma_unmap_len_set(first, len, size);
+	return dma_map_single(tx_q->dev, skb->data, size, DMA_TO_DEVICE);
+}
+
 #endif /* !_IDPF_TXRX_H_ */
diff --git a/include/net/libeth/tx.h b/include/net/libeth/tx.h
index c3db5c6f16410..2720ab9393e90 100644
--- a/include/net/libeth/tx.h
+++ b/include/net/libeth/tx.h
@@ -130,8 +130,9 @@ static inline void libeth_tx_complete(struct libeth_sqe *sqe,
 	case LIBETH_SQE_SKB:
 	case LIBETH_SQE_FRAG:
 	case LIBETH_SQE_SLAB:
-		dma_unmap_page(cp->dev, dma_unmap_addr(sqe, dma),
-			       dma_unmap_len(sqe, len), DMA_TO_DEVICE);
+		if (dma_unmap_len(sqe, len))
+			dma_unmap_page(cp->dev, dma_unmap_addr(sqe, dma),
+				       dma_unmap_len(sqe, len), DMA_TO_DEVICE);
 		break;
 	default:
 		break;
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


