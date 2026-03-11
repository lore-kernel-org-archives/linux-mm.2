Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB5C4112586B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B1656B0096; Wed, 11 Mar 2026 15:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C736B0098; Wed, 11 Mar 2026 15:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B9A6B0099; Wed, 11 Mar 2026 15:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22CD36B0096
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:30 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B0FF91603CC
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:29 +0000 (UTC)
X-FDA: 84534720858.11.B85F1B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0DEC9C000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHKnRO6y;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UafEZ6igwxAwqfrSBWBNYof3ZEC7kWBAMoSN0QyaFN8=;
	b=H2sqhJw6izrHZnnFowDRVGolF8B0wRWYA96Ub96kloVo7XADpLAJM90zB7UI1Bfjf3PPwv
	44MXKb+tBHT66AaoXi/bs0CsE7r/ZPnXpNzOuIlHxS410gtioj9Q150663F4RPz4vYNfRO
	cYqejatM+RCSMJ/rzGjrO1/8aHAGbC4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHKnRO6y;
	spf=pass (imf22.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256168; a=rsa-sha256;
	cv=none;
	b=TabFKOwkXBiV3EtbUEFJ7n+JP8Bf+UUenRrNVljYDcKhdbxM2mnds+t9qTm8E/q9taYvgC
	V78jW8lasglKTZchNUOoevjxeMBFF6F9SPf5g2qUZivQWd2bduKESsoIl0epaWjmNawZw6
	Zph2XpfdM9/ystyl9G9Fhnh13Qiqhxo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8496861340;
	Wed, 11 Mar 2026 19:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8658CC4CEF7;
	Wed, 11 Mar 2026 19:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256167;
	bh=8pwuaCiDUSCBcuJ0n9V3xnzMZmgOorpLbuob290/9q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fHKnRO6yqtY5rofM6SDr4DHDapAJhsI0XJQi4O9p65/khxIvwwDdKmxcfP8QYi6A2
	 m104LZo+8JeIN3EoFgQM5Elab2cHsl5k8qdT1jPMH3o3Dzz6r5kBM+nkshU7bgmuWj
	 iEcMBWWDHna5UV8c+CTUfuJ6W6gkfU1mWntrsCIn5VobxHkCLxQcD7/p0cM11R/5kr
	 F2/iLjoVMLIfU9H6nkJoCL4rhAdIR+aXP4WOX2Dvv4Kv8MnhhPCcvvORJXpnDAduD5
	 uVQcX6poI5WbBIl7IXu3Irg6tUKQGpfuh/AJs2iPba4QxwYO9dwxL3VAGMO2PcW34p
	 Tzux8OKSdH0Mw==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 5/8] dma-direct: prevent SWIOTLB path when DMA_ATTR_REQUIRE_COHERENT is set
Date: Wed, 11 Mar 2026 21:08:48 +0200
Message-ID: <20260311-dma-debug-overlap-v2-5-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jjcbh6wfemrzpfdw76jymbjzybfdztjp
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0DEC9C000A
X-HE-Tag: 1773256167-746281
X-HE-Meta: U2FsdGVkX1+qRysYJVqUsc7y241oJ2e0M6s5FRNx0l9PLoXpdzZ/PWsKbUyamk2wMvc5OItRSNmxksQMRLxIcMfzRl14ih7s0BQ7C5QBOklFKjhXD6mhfGJK9JxU24aex7g78XRqv4SczlYt/2YjFU6tIyySkwpBl01tob/K0z/7Z/grCbpZzscNiNd8ih6NXOTG0vT1nvu8GbJyTOetifXJhnU8Z+iQNGB3TGzmVieFv3/RjlNkAwNzZ2IHcfXbt/jz954xLDmSrMPmIZi9+4T6RChmr4RBYeY29N60Rlt9IB9KvzZVyHCdvnNu7VpZAHMM4/2xVmabTwticFlxMmXwp0+PWrcrCGLXtp6QTZfMMIiryLbTd/HsS6Vb6QXEnBSxl5mYCBeFXiE4+ozhBpx+Ijo6ArtHNdkuXClSuflr4UnLj+/mKvVPNfaVlZpu18m8fciPmvp3xgXiOueWiXKVjcFhRiU+mXgovNy35Utjv1Uy01LBnLkCAmazFwUaVj6bMcr3Zmo4kcKzftYcNHveK0HEOPj+UPnOF+B9Y4Z23Usonp9xdxt4WbLkqblCJIREUeKUIZVdLBJIzhUm8UgJdPXP4MNr13EySl/APTzwOGungCjoVyBnKllrE2k9L9zsLP/95uYqP+ZfOmRoGMFJxzHGAmS+Q9fzOvrpaWc1cKDDYZ+VV1rpCpqTqDbF45ibjyyoIh9xwWWGaaTWCkuZyOIYd4xCWIoC/rnn+0ld4elX2NcShdoGSZ1vjpMbyt2l7oMmdlXBJsrStFLp0VklvUOZFR2+9pbR8FhNuWee+vT4TPYcW5XlIIMgYh+mFexFmJYNNuNz6ckytBYmrvy8g+ijh3X/RxZA3NmFOKOiZ29HGBJ3NXSlj3R9wq4SHgRQM9xPny6rQ5pOD+i6V1uZkau/FOxHNvbMKAPpDQpwxGLBi7UYsZ6PSWmiOrExVd9wzTGsvFD6IT6dBxY
 sRJJmnDr
 s4Qcp/zl3drFWzWF75J0U/EIWW4zFiEEuXL89XVZ6PNZedMCltC0sJceMb3S3KXJ367SDXdsFqGpac01xS7dgvqBMNoKZNRz4E6Iba1brEm62E1X5/6PQGa7Vpi4lRZr5GwFCUo5/TX9E8jRkTPTp8teyAqyCk0rhOdk6i1XgK4Mwa4Ije1x0+K1PtG9+3bNeelalzCd2b+VO8TwkAMiRzOYidfrLrNGEfyCqEqzfj4tamVwoAR0/AYvf2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

DMA_ATTR_REQUIRE_COHERENT indicates that SWIOTLB must not be used.
Ensure the SWIOTLB path is declined whenever the DMA direct path is
selected.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 kernel/dma/direct.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/direct.h b/kernel/dma/direct.h
index e89f175e9c2d0..6184ff303f080 100644
--- a/kernel/dma/direct.h
+++ b/kernel/dma/direct.h
@@ -84,7 +84,7 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
 	dma_addr_t dma_addr;
 
 	if (is_swiotlb_force_bounce(dev)) {
-		if (attrs & DMA_ATTR_MMIO)
+		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 			return DMA_MAPPING_ERROR;
 
 		return swiotlb_map(dev, phys, size, dir, attrs);
@@ -98,7 +98,8 @@ static inline dma_addr_t dma_direct_map_phys(struct device *dev,
 		dma_addr = phys_to_dma(dev, phys);
 		if (unlikely(!dma_capable(dev, dma_addr, size, true)) ||
 		    dma_kmalloc_needs_bounce(dev, size, dir)) {
-			if (is_swiotlb_active(dev))
+			if (is_swiotlb_active(dev) &&
+			    !(attrs & DMA_ATTR_REQUIRE_COHERENT))
 				return swiotlb_map(dev, phys, size, dir, attrs);
 
 			goto err_overflow;
@@ -123,7 +124,7 @@ static inline void dma_direct_unmap_phys(struct device *dev, dma_addr_t addr,
 {
 	phys_addr_t phys;
 
-	if (attrs & DMA_ATTR_MMIO)
+	if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 		/* nothing to do: uncached and no swiotlb */
 		return;
 

-- 
2.53.0


