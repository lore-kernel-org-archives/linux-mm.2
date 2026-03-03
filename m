Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C3CEC049D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53CF06B00C2; Tue,  3 Mar 2026 05:13:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA7F6B00C3; Tue,  3 Mar 2026 05:13:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40AAD6B00C4; Tue,  3 Mar 2026 05:13:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30B8F6B00C2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:13:38 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6F22877DD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:37 +0000 (UTC)
X-FDA: 84504340074.30.1D10121
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2878E100005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:13:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hNLBgPiY;
	spf=pass (imf14.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=59noAXpH6473ChzVPWVCaW5/Ounf9VZcy2bUBgpx5Js=;
	b=MtMLj2WD5MnZP2otKP8E03cxABXsdgFJ/R02odQTqtd6/ZRl3pb08Q4zZN7PGEvne2Kvr/
	n6PUUv9TsRrS0WgpkBO9jCIlNNHgsxaIdVngtO9AVs79oDc+4bhVotuq19R9CKCm0HMQFV
	RgALPyuC2LqCpatEusOzDeUPwuSKMzg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532816; a=rsa-sha256;
	cv=none;
	b=mbwxuP0YHbBhlD3Ph7lzLEUUGGbkfbc3bJsj9b+fleBW5eFEun5Uo8x4SKArAnE4P1qxq2
	Cp/TXj0mFpL23qM+QaAKBe/coEOFHLWtV33+Mp6a4ljQRjtk5iqJ4BEn+ZnOTsAudvIuN4
	Yb5WBJ1zhpwAnWh9wJijltRa8tg9I7U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hNLBgPiY;
	spf=pass (imf14.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B8EF4457E;
	Tue,  3 Mar 2026 10:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8734C2BCB4;
	Tue,  3 Mar 2026 10:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532815;
	bh=uocFqI6buKhD72I9T9guormXJl46wyFDpX9g7jostug=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=hNLBgPiYlGA3ROspXiwDWvGd7UDC3eLt9KG+LRpD2ykmSpbvDT4i2lecDwEEQ4jRi
	 BSriPRPByLDuUP07IrVg5AWs0lHcb/j5vNyXlRdfXxPb9Gmh21vG71c0O4goDaA8DR
	 viJH+W2PiOP/skvF0y52/p3n1Sl8m2jC7WrjZr0ZyA4FFArGVbBpfR0/p7mifhP9zc
	 vuxDO4mW0g4VCQk13LnYA04RoubMyd71KF6RRslLiRJyJYV8teAEPkxI4Uiht714lw
	 Su6WskTLu+cqYWbaT0LYNfkORzEllBz+OkTHo9zVAvRkED584wGHpfE//bQQ6aVFHI
	 qI0XQT+J6gALQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Tue, 03 Mar 2026 11:13:09 +0100
Subject: [PATCH v3 6/8] dma-buf: heaps: Export mem_accounting parameter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260303-dma-buf-heaps-as-modules-v3-6-24344812c707@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1114; i=mripard@kernel.org;
 h=from:subject:message-id; bh=uocFqI6buKhD72I9T9guormXJl46wyFDpX9g7jostug=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJnLtpg51J64F2S+Qnv20d4+vXl7NF2OTUzZEbiAw+DT1
 DTF2JqujqksDMKcDLJiiixPZMJOL29fXOVgv/IHzBxWJpAhDFycAjCRpGmM9W4hG/rbaxtq+/t+
 TFZ9WZrIxbMl1Z5rxh2PTpe4RweTlh6aWsVRvk2v0+9XgXIBZ/ljxobDb3+d2ZoTr5IvGT05qeb
 NJsfWxCKRfpEylf23TWZPncb3e4tml+rbq5MZild+d9gZ/h0A
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Stat-Signature: rccb8gdf36nqrf6bjd1nsg1m1gyaskft
X-Rspam-User: 
X-Rspamd-Queue-Id: 2878E100005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772532815-305657
X-HE-Meta: U2FsdGVkX19J303MxeTCJlZMjiJGDqBDJtftUQGlJmHrxMXXBSobNyFuwLYd+SuM1xV1DOtKyvswmpKC44cSOWqaXTLG/wSFzg7IkkCNUhbjPOC78cc9sQu2OUlaig6Q4yJAehd4voM44sGOKhlnZpFI7PCerOmx9XNg5GnJPSD65eoEA7QOjA9PSATgw1G1KYxVsZ+HK2jZkBmTMGkBtJTHUKoGkZagYgl2DV12dggjBljE8UwZsK1OJ2U/0Cg60A3OBCkzkDw5jC0MH9vHIZ10hEyjwfO6BIu7qlLW+STXE1zYwFjVfkHznzWdJEDyD1KUPfwExbU3gqEraavG7ak2Ldj2KNpkCt8iQtpxBlhLyEYyzaVg0cj1VhlEa1PfB1S7gaigdoNN0GHpNuRYFVFVkdIK65Rd3tQ3ktwWrDeAwF64o5OLh0YohbrK+q+UlVbvoygnRKybrYP9x3wRe1AukuBfHActDYdCSE/g9pQdNDLDzT3WRrOqHcYQALv/Dv+2j3Jlgs6R1EUuluesGVZ6TEHLKuy/mGbBtAEgERo75/coC/JOY1ESzEJb0UZOVcjnK06NERZ0WR/QQ8/6ODu6IIfBqm+HuklHqwCfduqrBuOzQDD1Has7F4tAScKK4ravfPdSEHRK3THwiOtJkk3wNAMP1coGa6jpkTe7+RiHP0IiKIwOp9cgBKYgeZaDv2BAHbCP4IzEYAPSZA4X302BBo49393sV2lmKBquIH6UbA59bQoWIkRrDlfCMpwF4z79yYaani1TPxw6CZkpHXjonnuypgpMkvnajcL0O3WSxQ1G8ITGsAYwb1JR1vM+NF1uFPDKHp4K0PEPctCR1Rt/OBbEdrBFLYUgu4d9UpiR6w81sqVcVpKgQC9m+lwxcnVlEM1i4Wq60Ng6MssWPcQGTsm5I5seEUJuf9jd+TlrPmLNaye3b0/CF5mtEG8+iThYCej1HtmH7kKDxlF
 JignRiNA
 BSB+ZYUG/uEMAxQa0mPLZ7QOKPKcUQvT4VZoyCqC1pbPiaAlJejSi4XM45qUSXVtXhs9+WrdJJNCjJLfgWRAEeF7klOlWe2FjhamTFnh1/H/VtNTqbhwKPx5/6lmp10esvOlZY7YjMZ76hQBS69AIEb52HMmUJB63+SxxLyh4FF2bJmm4HX7QCJxEebIsuhWwbHmWLgvSPgBTfutk4Z3q8oMsbhYx1AhlAnQflMXPE2KfCbXt0OyDzf3+v1FBPb+GG8DbdJqgddu/cJ98PG2Gc3h73NKGwTKLcCjik66knA0njSmgNbO2aPr3Izl0AgnpjYd1G7y/iHE5y16zHFF+1C+B2uxIZ+QnQoL4e5Mj52KrNYotTRSMP5tTwsjpjwUYg9DQCsYNV/pzUiy7HsRM+xD8XaRxb8KyyRh+/VUZpiEaAFIRD/cyDD0LdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mem_accounting kernel parameter is used by heaps to know if they
should account allocations in their respective cgroup controllers.

Since we're going to allow heaps to compile as modules, we need to
export that variable.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/dma-heap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
index ac5f8685a649496c0e1c6decbf263b63fa472d04..a76bf3f8b071a3d5bf39a8513f31e9e8aa16e02f 100644
--- a/drivers/dma-buf/dma-heap.c
+++ b/drivers/dma-buf/dma-heap.c
@@ -51,10 +51,11 @@ static DEFINE_XARRAY_ALLOC(dma_heap_minors);
 
 bool __read_mostly mem_accounting;
 module_param(mem_accounting, bool, 0444);
 MODULE_PARM_DESC(mem_accounting,
 		 "Enable cgroup-based memory accounting for dma-buf heap allocations (default=false).");
+EXPORT_SYMBOL_NS_GPL(mem_accounting, "DMA_BUF_HEAP");
 
 static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len,
 				 u32 fd_flags,
 				 u64 heap_flags)
 {

-- 
2.53.0


