Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA6EE67A9B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05E96B00BD; Tue,  3 Mar 2026 05:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6356B00BE; Tue,  3 Mar 2026 05:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1A456B00BF; Tue,  3 Mar 2026 05:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9394A6B00BD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FCBF1A03BA
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:25 +0000 (UTC)
X-FDA: 84504339570.04.B8E95BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 883364000A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1cu0ZT4;
	spf=pass (imf17.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n48f++uSIhCbg8KwQrmhtEcgoEjIT2GeKlESFMQX3s8=;
	b=v6I61E7qw0JdoIdqyW1eCPY9YR+heNEKMJ+ywmjRHnc7LqHm58yw3DnDIwBptZHKXny/di
	tdrxCLBocE9WlCiBNcgeuqF/nliRqUvMthJzuirhDN4TtW7DvQpWxZTKVQHPR0msWoUp11
	rCOAnqyYH9pTOvzEH9O1E9xlJ0gdqTQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o1cu0ZT4;
	spf=pass (imf17.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532803; a=rsa-sha256;
	cv=none;
	b=AWoTMsvmK5UCV+xC/x+kI6i6OlSgqpp7UV4NKTmZd5fdpWQKYrRabBcszgXyACeAUbqvNx
	pK+gXbT2LJqc9//LWoXudjl0z4f0bqXVyCWdj3J6KUcuJWKQBejXVNjIUny6piBWuyEEx2
	5gUUYxnJSi6BPV7RGrkUB1EozhPdqbs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF11460053;
	Tue,  3 Mar 2026 10:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC49C2BCAF;
	Tue,  3 Mar 2026 10:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532802;
	bh=OLrC2gz6cLkaWEzaVtzoFaeIC7TEtGhHt07Be27ESoM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=o1cu0ZT4hcrgCfksFQXo7DCXOAmNf2Tt9Lpoh6xYfc8a2tjyThaqi38HLj7O9YwT1
	 juij3uofr3x8zToKvc1OmsGKoFhwvBzunGjqMnUfn4gyeWQuGgs2TLCfQyOkfMLPpu
	 PHUu4BFeOoTgnd6wh9HtTYtgDT0npYK8fszA7P2BF+r1mHzuaKHSNGVo/qIHt8ylOy
	 qYmpLwr+9hslq6i+/KGvI6xibAFY9b8jSl1NOf+UyExyfSRklRYWP2H2mddaVRok+F
	 WvdUhGt9b7YxWWD9i8mT8VevxMijEpSZ6lju+f5f9oVg1fqCDdvXnYstZxoMPAfrDX
	 KAemO7cMvNPew==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:05 +0100
Subject: [PATCH v3 2/8] dma: contiguous: Make dev_get_cma_area() a proper
 function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-2-24344812c707@kernel.org>
References: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
In-Reply-To: <20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
 linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3660; i=mripard@kernel.org;
 h=from:subject:message-id; bh=OLrC2gz6cLkaWEzaVtzoFaeIC7TEtGhHt07Be27ESoM=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtpiclLx3kGf/5vRYa76ZT/++XXtwl4ClullX0jTzC
 zl9jnE8HVNZGIQ5GWTFFFmeyISdXt6+uMrBfuUPmDmsTCBDGLg4BWAiZ6czNhzRX7oyU8B/peFN
 C5E76zj7fy11eThPiytk/8yn0ytlZF1V8865P/tgt/GgyAXtcIGrkxnrtDkPTDmzIy5g+b3PnTw
 5Tbutf/FGFWYbXrMrkJ1y+fakExrzq0TethjsTOKQnNxgI7YNAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Queue-Id: 883364000A
X-Rspamd-Server: rspam08
X-Stat-Signature: 98uxw6iihwto7g7p3eon4aitcgd9jz57
X-HE-Tag: 1772532803-564614
X-HE-Meta: U2FsdGVkX19AFKLPU2ZINgwCNMp/AfiJlNcZUsMRcndqL33RteWwDJzl9oseNdTIzPCBjqrnZ4MllJlO2S569Py1IG2Y0jXuHH9TmyK7tJEELadrCuzdJjRtpv6rkS2O+HXHwbvPQXHSR65L98+lWuWGIqLpcpaHVoMbIAIbU/eKHnDwQUqvV0Fro9+89DGbVNZHqkbO81nTPA+iF3wv2+VohDSsnIZa8ydKYYcXq8izVWlW/xdsAae/4bVaJT9+mXiQdEJDMgD5r07khbQrBavks0RlFdpw3XdUyLDuu4JyPSmncP2OImXa1Il+IpnGfBHB+WCLdByklxIGkJfUFKF+HSwagjruMyBLBdCwzQUWc0YilxiEMbk1aDQUqu98qXzWZSFidbA26oyEubxqn1jLnvpYLBBQbY3bM9n0WSgpWLVQEk62rJsgqSwJm2a3Fbkq2nKAjZxvhuSQB/6lyHkPK5ZHFKZzN8TjvgJXwh6rIyUFAE2ZJrFf3Fg5oivIoSyoLVS2mR5Wr2cO7snvn/IGKUPyr65H9EZd/Rp3Ar/rP2fZjnKhl2B2+1jAf71jIIzBPtpq0JXzdE+eiCkD5r7wEykGwkY4+QrAmJ04aPd2T+ZMR4R6z+cAXd/1lieXYoJ9shR/mB+hm77AWmsDVFPL4shUOU9v5itfQ0THf2RobDspwUWxRXViCVha7hBxJ23BGigzof+TrWhiBNO8xDCgjMop9mzU8yyh8vNYkm5StHzQG1p4HZezFyQsYGB4Hl/rv8/C/LZxW1rM1NSalfhCn4619mP9TFUfbf0XzX+8ktPDbAKLCilZGFDxjfMbDJOdd4Pjg66rcc7WLz573RJ+adB4IdlQbj80OB5l7uzXSHzw/EN2ONCHR8E7Rv+EcGvO1zjPlDiL+1gHgQPPJNKJwMLXkxXlxjXfNKpXZ8Xl40CgOeHSmNatc9cux+t5U+NAscqO1K7f5ym+Sxk
 n8kty25j
 47nOfgMzy9G2hJ1/wLxYGNd8W59T7T2MGxJvT3RaVRcyRCTPGlNn7bqidRtBL3oxWDl0TDed7hT+fZc8xonjCEJqDfy8gPXkEIzcnsicvj0kfj9yCVoTjaQoXxyu5Lrwg1S4cP1CnlKyumYETDdXPoOHRQOQN27E1glO10bLixG4ZyOcgimsCAo+filcKSN6nuoE9eHf7NhqsLM5hANjNOZVnfUKoxb9CIVqztvMw1Nw7Sr8VnNYucU7duogR23qG9UFBl5Wk4fvwKbz3grS1GjrmXQmEZU13beyt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As we try to enable dma-buf heaps, and the CMA one in particular, to
compile as modules, we need to export dev_get_cma_area(). It's currently
implemented as an inline function that returns either the content of
device->cma_area or dma_contiguous_default_area.

Thus, it means we need to export dma_contiguous_default_area, which
isn't really something we want any module to have access to.

Instead, let's make dev_get_cma_area() a proper function we will be able
to export so we can avoid exporting dma_contiguous_default_area.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 include/linux/dma-map-ops.h | 15 +++++++--------
 kernel/dma/contiguous.c     |  8 ++++++++
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 3007c68a8ec5b85990d1938d04a2f05c1a71acdb..6b8e6a2a08e2cb380de764bd6cacb2cb24c22871 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -91,16 +91,11 @@ static inline void set_dma_ops(struct device *dev,
 #endif /* CONFIG_ARCH_HAS_DMA_OPS */
 
 #ifdef CONFIG_DMA_CMA
 extern struct cma *dma_contiguous_default_area;
 
-static inline struct cma *dev_get_cma_area(struct device *dev)
-{
-	if (dev && dev->cma_area)
-		return dev->cma_area;
-	return dma_contiguous_default_area;
-}
+struct cma *dev_get_cma_area(struct device *dev);
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
 
@@ -110,11 +105,10 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count);
 struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp);
 void dma_free_contiguous(struct device *dev, struct page *page, size_t size);
 
 void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
-struct cma *dma_contiguous_get_reserved_region(unsigned int idx);
 #else /* CONFIG_DMA_CMA */
 static inline struct cma *dev_get_cma_area(struct device *dev)
 {
 	return NULL;
 }
@@ -149,15 +143,20 @@ static inline void dma_free_contiguous(struct device *dev, struct page *page,
 	__free_pages(page, get_order(size));
 }
 static inline void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size)
 {
 }
+#endif /* CONFIG_DMA_CMA*/
+
+#if defined(CONFIG_DMA_CMA) && defined(CONFIG_OF_RESERVED_MEM)
+struct cma *dma_contiguous_get_reserved_region(unsigned int idx);
+#else
 static inline struct cma *dma_contiguous_get_reserved_region(unsigned int idx)
 {
 	return NULL;
 }
-#endif /* CONFIG_DMA_CMA*/
+#endif
 
 #ifdef CONFIG_DMA_DECLARE_COHERENT
 int dma_declare_coherent_memory(struct device *dev, phys_addr_t phys_addr,
 		dma_addr_t device_addr, size_t size);
 void dma_release_coherent_memory(struct device *dev);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 14bd54fb758537f01a6fe27318e7b683964e20b1..9a9ed7248fb823105609c5db5a51113e54a40192 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -99,10 +99,18 @@ early_param("cma", early_cma);
 bool __init cma_skip_dt_default_reserved_mem(void)
 {
 	return size_cmdline != -1;
 }
 
+struct cma *dev_get_cma_area(struct device *dev)
+{
+	if (dev && dev->cma_area)
+		return dev->cma_area;
+
+	return dma_contiguous_default_area;
+}
+
 #ifdef CONFIG_DMA_NUMA_CMA
 
 static struct cma *dma_contiguous_numa_area[MAX_NUMNODES];
 static phys_addr_t numa_cma_size[MAX_NUMNODES] __initdata;
 static struct cma *dma_contiguous_pernuma_area[MAX_NUMNODES];

-- 
2.53.0


