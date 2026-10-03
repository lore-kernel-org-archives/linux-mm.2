Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1FE6CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9541C6B00AB; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904476B00AE; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBED6B00AF; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CBE56B00AB
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C474580A19
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:16 +0000 (UTC)
X-FDA: 85282590792.15.3DDCFB4
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id B1F55100003
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SFK2D7t7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3P3LBagYKCIYv1s99yqyyqvo.mywvsx47-wwu5kmu.y1q@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3P3LBagYKCIYv1s99yqyyqvo.mywvsx47-wwu5kmu.y1q@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aZwzLkeC5Zd1WFKT0DwnrS8SKkPjkbpjbdTgKohmOY=;
	b=VIwoqgVvMpw7L9X26id6EZEB5XJJYunRz6/N02mg5L8vLt4HEb6JSQDWVE9dje/siOCaH0
	RQrOpyUithgKr/r4OWmufQgyOJQq7QgC3sCRhniV6i7x6WIjhQVcg0wo1uSJKuLHqNMsqN
	O/WSrVWzM8NW0s8OQsx+CSNqS6OqP0A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SFK2D7t7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3P3LBagYKCIYv1s99yqyyqvo.mywvsx47-wwu5kmu.y1q@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3P3LBagYKCIYv1s99yqyyqvo.mywvsx47-wwu5kmu.y1q@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062593;
	b=jVPYLd0+Kpf6xLQdSDolr90rm5A82wa9qJ6nubUqS1kBzD0B7ikoZlEbb3/DUuuDyqkmBw
	A1SGnaIJURHfkmyRPhw6QdtDrMkuVMLjs/GFZWK/O/NJc4pSM8SvUfTjC8zuomNhjrJfSX
	LZfnrx4VETp1EaB8WQCYN3mr3cxVkas=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a98570af94so805476a12.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062592; x=1791667392; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3aZwzLkeC5Zd1WFKT0DwnrS8SKkPjkbpjbdTgKohmOY=;
        b=SFK2D7t7iCKvHO5hAMSQ6+5RvZClAY8KJ4b8wXs1c9I+rxAwKHY70X9fRN6npNMZzW
         ge4hVhU+beeu1oVXLg69fRXEsbskStbeICdZMxuNDKySn8mabzBKdgQNfmt6npphwpEh
         mz5LS25dxHRKLxlAaN79Dh2NN70ynEZs9D2U9PYVd0sFTubGVjxL1bbwuECbxlJyJUOo
         of7j6SjvVM3ZDZ/182N8h8mmBM/8CuTEPFBnvMjdJtTLgy54eZASsQIR0EOva6Btfa58
         /v4bUEUhfPMFe+4L8NkZpqUlWULpNibNTrckQSIWhrIArkEr94CqsU+LOuPixs3XQX/l
         5qJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062592; x=1791667392;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3aZwzLkeC5Zd1WFKT0DwnrS8SKkPjkbpjbdTgKohmOY=;
        b=rUVfROlCMwSwdCcYt954YKJHp/Ay23I84HCE8EVMfZJF7cPOGML/u+4nJie74lKfxV
         jDUMnbKSCk92j98Fl5uj7bK6Ye1NKie3hR9/cVvqlgGCGBkrQI3MBnFj1n4z6EvfuS/4
         UZtORtXrnGBSr4vZn3zBUsquQy4qfKy6fDRFh/alTSKH+0UcNKvBI4QVzeAsEyq4vYDv
         pOCWGi515Mus9UPrwT6alQv9iddZSu+biCDezYlblXuwhKMCA2Yk3hIFM9ZFIQEUfOpc
         DHrWeM1CWdN5AmdBZtD1Z8MEwk/Bc+rjf+uuF56nXH1hocOa9xfA86dqxgawBJQr9mbG
         Fm7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxKmHcc96XQz+v7RmD4cYNKIGcOK0Frxec0njhMpzZFnzB+B8ea7kPqUGaQjfI7+OIOgCTEcaLChQ==@kvack.org
X-Gm-Message-State: AFuF++kd6zJMINwOPVBPhN/otj+EOjF+Fa6FLUUt5f1X7qSf5HylzWI8
	cJKPCgk3nQN6jTFB5vCpa2E1/c2bEkl0OHFQt+0lvH0pw5oNnWJs3S/HKPDpPfAQyM8ESt9Yg01
	0E6SZeA==
X-Received: from ejcfv45.prod.google.com ([2002:a17:907:50ad:b0:c2e:8121:1730])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9728:b0:c2e:7fe7:2898
 with SMTP id a640c23a62f3a-c2e7fe738bbmr76710966b.12.1791062591766; Sat, 03
 Oct 2026 14:23:11 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:38 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-20-lrizzo@google.com>
Subject: [RFC: DMA_PMD 19/22] net/mlx5e: Use DMA_PMD memory for tx header
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
X-Stat-Signature: aehd15xnt1ebf8dc1wbttzh1rf9rg1rq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B1F55100003
X-HE-Tag: 1791062593-133453
X-HE-Meta: U2FsdGVkX19DuELlT2OGCT5f+dH5ajtYzhNIfpMH6fOYTAvNDYDH6M+ICz5PxHUn73VlZV6awgTgyCEQ4ztQNP15RLXYOtVfG1P150G8wN8bSOtI0Y15iavRs/6Jtg+iGIIc0nkfIibMeCJ+00G92Dhuff6+a1V/1XcGfoiewEXOPwQi3LlV9drDDAujD/kcKjLfjGVEyWmEqYxnvBfPBgMrNK9j/J5tv5WxbfYkV4vDytmHIBTwXITafY0Wx7OxwswjUL7ErTS679SwrxMMUGpcnhxNU3FutVJ18evOCG1mAW0zLI2uZgD8bgi9TXd29bZA3f5jo28Jktu1NTlLTAUafNbMD3OIT+8w0zsUl6KvBLi6TEh1Cdmz+rlD+qwuMKQOJoNg1D8aXk+FZZjtzqP0dtsJGoWeCg4cbl+rs0sw4uv6SOZaLU8RoON09+zxWQfcA4FOMDcaSvvUGiGgegTarTdQiLxMRu0EB0u3HZi1ruHRgmYPqDsIcmngkYaXOorxLxMDStfy5APE5XzooJmdlJ7+vwKn4IbXoh0gYWRgG3T2B4rx4TliQkcEAPfBJYu06ykyv3fEmC1+ODgQY48JjSZi/1aUu/suEP0OTBxi0iVvl7E/OuezSsAL4EbXhms5rsKY5enr+jeTy9z/k/QxQnyoIj0ZcuT7zSfnAQpmJr607ft8OWPSf3cRZ0nN5+dTHKT+iGTuahGA2RaYWjLULFcq4szCEkAwDxi3s34uKoPQmfDnSkn5scUYo7msWj0wKBipH5EYC8SA/tB0GIdzLI6Yjz6RHKWgKrIEDAyMpdH3OMtYShvw+2LIdYO0kvR1M+GdNl6AEQuYH6WGoQEi2w+Hzs54zE/vTZwqneMm542SR1UnLy5/qiZx/IWAPGhGRxsmN7XEmY3zdj3IAo8vKzW9SUoeHVuFN4AEWeF1FMV8uuhvp2QBmhd96TSqBBjwud4yz7qaJFYpe9K
 G0CmuDkk
 2/Cxo9tV8T90z2ao+xzGMdOznH16wJwKhyb3+yz1xsQRnzjmu6xX+2dDl3S+zpDpxKKLlWSPOfl1N5ty9wVQXqDRFYEZmut9xBjLn2R2s0NCVTnfwPZkIwbI/roG2pLLGH4mLbejH4tBjtUX25T0pk8Ak5SZozPMqI4mzRfCwN1r4/bAxgUFxDrBnAym7rrTFIWANBtEj5XfLy32IE9MdbH1tmMfBoiRK2Uq10V4InqFio0hWdQfwPHHZfbhYlrYYSXwLuw21wCfqbKLBof5pI/UFufCZTIOULH6QamKRLDWGDeTVtWo4p1JbLWyoOfdBZfZxkSLfujNJ4MpeMvxV3Kf2g+sfAObt0Q1JJwjJLc+iiJ2xKSWDRzr08giodkgZ9AUjAIEOuwEguiDuYB8a4pR1cU+TGd72PRG1OB7nXZ1+t6+AVY1loRT0e8U52SylEwWRtqiMwEh9nHQK8rx+gzFwVlxhHI8dyoZXJSRDW3F27ZKnYey/v3vtFZb3e1S8kIczxiwrg4DuOVC/zw6G2LbdJRlRu0vSgJSBlSljA0UmnlzjLq48LROLxQpxxRvTgLyCqo9RLGx0bn01uW+9JRWtzTXW0rQOZ7zJLYGrNu4wYtB5uz625D1uCTHUDqPTYTn6DOSSFAljuYSnBu22oBsGJ+rS2f65qQtDrLk1Yic/1sM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When dev->dma_pmd_tx_hdrs is enabled, allocate a MAX_TCP_HEADER
bounce buffer per TX DMA FIFO slot out of the DMA_PMD arena. When the
linear portion of a transmitted packet is at most MAX_TCP_HEADER bytes,
copy it into the pre-mapped bounce buffer instead of calling
dma_map_single()/dma_unmap_single() on every packet.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 ++
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  4 ++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 28 +++++++++++++++----
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index a3945195f454e..d762ad1c1ffaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -442,6 +442,8 @@ struct mlx5e_txqsq {
 		struct mlx5e_sq_dma       *dma_fifo;
 		struct mlx5e_skb_fifo      skb_fifo;
 		struct mlx5e_tx_wqe_info  *wqe_info;
+		void                      *tx_hdr_bufs;
+		dma_addr_t                 tx_hdr_bufs_dma;
 	} db;
 	void __iomem              *uar_map;
 	struct netdev_queue       *txq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
index f2a8453d8dce0..6de7a2a430d72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -365,7 +365,9 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_sq_dma *dma)
 {
 	switch (dma->type) {
 	case MLX5E_DMA_MAP_SINGLE:
-		dma_unmap_single(pdev, dma->addr, dma->size, DMA_TO_DEVICE);
+		if (dma->size)
+			dma_unmap_single(pdev, dma->addr, dma->size,
+					 DMA_TO_DEVICE);
 		break;
 	case MLX5E_DMA_MAP_PAGE:
 		netmem_dma_unmap_page_attrs(pdev, dma->addr, dma->size,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4c6060d54fbed..efd766aa43a02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1666,6 +1666,13 @@ static void mlx5e_free_icosq(struct mlx5e_icosq *sq)
 
 void mlx5e_free_txqsq_db(struct mlx5e_txqsq *sq)
 {
+	if (sq->db.tx_hdr_bufs) {
+		int wq_sz = mlx5_wq_cyc_get_size(&sq->wq);
+		int df_sz = wq_sz * MLX5_SEND_WQEBB_NUM_DS;
+
+		dma_free_coherent(sq->pdev, df_sz * MAX_TCP_HEADER,
+				  sq->db.tx_hdr_bufs, sq->db.tx_hdr_bufs_dma);
+	}
 	kvfree(sq->db.wqe_info);
 	kvfree(sq->db.skb_fifo.fifo);
 	kvfree(sq->db.dma_fifo);
@@ -1690,6 +1697,13 @@ int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *sq, int numa)
 		return -ENOMEM;
 	}
 
+	if (sq->pdev->dma_pmd_tx_hdrs)
+		sq->db.tx_hdr_bufs =
+			dma_alloc_coherent(sq->pdev,
+					   df_sz * MAX_TCP_HEADER,
+					   &sq->db.tx_hdr_bufs_dma,
+					   GFP_KERNEL | __GFP_NOWARN);
+
 	sq->dma_fifo_mask = df_sz - 1;
 
 	sq->db.skb_fifo.pc   = &sq->skb_fifo_pc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 0b5e600e4a6a9..3b6a7a8b0128e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -177,6 +177,27 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
 	return ihs;
 }
 
+static inline dma_addr_t
+mlx5e_tx_map_hdr(struct mlx5e_txqsq *sq, unsigned char *data, u32 len)
+{
+	dma_addr_t dma_addr;
+
+	if (sq->db.tx_hdr_bufs && len <= MAX_TCP_HEADER) {
+		u32 off = (sq->dma_fifo_pc & sq->dma_fifo_mask) *
+			  MAX_TCP_HEADER;
+
+		memcpy(sq->db.tx_hdr_bufs + off, data, len);
+		dma_addr = sq->db.tx_hdr_bufs_dma + off;
+		mlx5e_dma_push_single(sq, dma_addr, 0);
+		return dma_addr;
+	}
+
+	dma_addr = dma_map_single(sq->pdev, data, len, DMA_TO_DEVICE);
+	if (likely(!dma_mapping_error(sq->pdev, dma_addr)))
+		mlx5e_dma_push_single(sq, dma_addr, len);
+	return dma_addr;
+}
+
 static inline int
 mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 			unsigned char *skb_data, u16 headlen,
@@ -187,8 +208,7 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	int i;
 
 	if (headlen) {
-		dma_addr = dma_map_single(sq->pdev, skb_data, headlen,
-					  DMA_TO_DEVICE);
+		dma_addr = mlx5e_tx_map_hdr(sq, skb_data, headlen);
 		if (unlikely(dma_mapping_error(sq->pdev, dma_addr)))
 			goto dma_unmap_wqe_err;
 
@@ -196,7 +216,6 @@ mlx5e_txwqe_build_dsegs(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		dseg->lkey       = sq->mkey_be;
 		dseg->byte_count = cpu_to_be32(headlen);
 
-		mlx5e_dma_push_single(sq, dma_addr, headlen);
 		num_dma++;
 		dseg++;
 	}
@@ -578,7 +597,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	txd.data = skb->data;
 	txd.len = skb->len;
 
-	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
+	txd.dma_addr = mlx5e_tx_map_hdr(sq, txd.data, txd.len);
 	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
 		goto err_unmap;
 
@@ -591,7 +610,6 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	sq->stats->xmit_more += xmit_more;
 
-	mlx5e_dma_push_single(sq, txd.dma_addr, txd.len);
 	mlx5e_skb_fifo_push(&sq->db.skb_fifo, skb);
 	mlx5e_tx_mpwqe_add_dseg(sq, &txd);
 	mlx5e_tx_skb_update_ts_flags(skb);
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


