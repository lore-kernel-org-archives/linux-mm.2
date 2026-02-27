Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 750E8FEFB4D
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3AD6B0096; Fri, 27 Feb 2026 08:23:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8DB6B0098; Fri, 27 Feb 2026 08:23:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB91E6B0099; Fri, 27 Feb 2026 08:23:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B40BE6B0096
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:42 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 554E9C20BB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:42 +0000 (UTC)
X-FDA: 84490303884.08.DDCFEC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 99137120012
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mbiTjtOT;
	spf=pass (imf29.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d8g7JbldFQCfCJPV8shJXXeHq3RIT644jJrFb8sBqRQ=;
	b=EO6dWkIGdGJOvrHQj8yKnfgurnm5nnM/wu2NK4azCHQ9/piJQPMdcY2bihUTkuxx19qXNH
	keNgZR6T62jE2gVrZpdPNOm8QUzvd+ukcu/Rv1Iw4wQr4ErGi8DD4Dx+kQZ+S2YD5OSd27
	EPiQU/yo3PHKkA/KDDBANdfgChn3mRE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198620; a=rsa-sha256;
	cv=none;
	b=hcvHYb4lhGO+yHv6md2oYc7iHEPMu6EtI4UMJczpZeNyjJIYze+NMBITyQWYuoPbOmqTsk
	xj+qi+FVPc4VlA5qpkiYauc7mrR6osk+1cqiWScvARXnAoDGw8QW7V7fIBWWgC3MhzxDyH
	pLACRKMT1xcoDvNOL8pBXzct1bXEUMM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mbiTjtOT;
	spf=pass (imf29.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 202BE600AA;
	Fri, 27 Feb 2026 13:23:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7533CC19425;
	Fri, 27 Feb 2026 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198619;
	bh=lO+1PMKRSkJNghp2Ly48vsH4KqRxHWKQohidvl/pe2Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mbiTjtOTtuYBF8BfT7XeQwDLoBt+5a7dz9SjmhZsiT/Ed8nZ0DmC5/uiyq4NhyTR3
	 oLSGEaItLTWcAmVbJqqrihiQ9GKFuYF3DWS12w380+9jcbM/J0s943BD+jdZWPD0uE
	 mKjJTUg2tiq+Y2+Izuo7hzOjguwCiTb6+L/4DhwqO2G4cwzY4cZYe5rhRo/ufQNHR/
	 VjM8EsN/4f4QLEtDsvVSUlt3pmHCi3PYrC1g+69TmOUzcOL+vkjWdTwu1lgKdqRGKd
	 L0vN25+2kKwCx6Lb5BEBrlA0+1vAlWCamvXuZ3Y2S9zkgm3xNN5BOodNjRcv7jNYzC
	 FmxrJ8KBFCMoQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:47 +0100
Subject: [PATCH v2 8/9] dma-buf: heaps: cma: Turn the heap into a module
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-8-454aee7e06cc@kernel.org>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
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
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1869; i=mripard@kernel.org;
 h=from:subject:message-id; bh=lO+1PMKRSkJNghp2Ly48vsH4KqRxHWKQohidvl/pe2Y=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+2W++9zO/z5lufFLSXNFS8W31js/fEI+23H6tPWe
 RaGlbfud0xlYRDmZJAVU2R5IhN2enn74ioH+5U/YOawMoEMYeDiFICJuGxkrJXtEojUePZxXdIW
 M+lfYdyzmvsZw5QiVkd/Et23xmEVe8Rdk4tFrH+yUv2LF2qcNnqVwdjweq3b1eAsndxiJb5N7Nw
 ir5LXrjjZaRxzc67vhM4lm6UlmeUf8nftu+8tL73UeVUJ410A
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 99137120012
X-Stat-Signature: 47hxum84fdamqcw6i1umaf4y3jzw5ns9
X-Rspam-User: 
X-HE-Tag: 1772198620-416244
X-HE-Meta: U2FsdGVkX19Ac9dzOa272ST1H5yTbhp766e4rtUxQh0gvIcYa1VWjYjgH6UTXC79iKZxUjeIufUsG78SNbX9PTXM4oAR5FFIVT+dFpNbzY8DVMuKHzru7dXvVmk5E3yIopMj6oc+/DaPngWbaqL1u+bbBe6jOnoBrZX9Hyj9YQt1YWNvLVHHVVAByjgWyl8XJI6qUOstAIw9A0wIhfr7tz1ZI2lQOr9+CcyfSnqgFdNRF/51PbcdswpXkNzTyp5BvLVojBkgGyY3RBDCImDXEAwMkTHOQM4HhQbHjuBjwobbR2uPFzxjfvS4wTcBpN4X1m9Fm4SeqEKGsauIamct4SI9b0MnbLJPS8NcFM64RjQRPMbBTV6HanS35h59PCg0AOt86XCqEaAOBX5534J5QBnV15XnY3xRWvAVYy7twefPcvjq9UUrOIyjzYGTcnd2kI6ooxBPICeyqQlWaP9oNl+qSYj/U1hbKn2S5Df0cqFTlgW8lHr4/cBd4k4dcOVzUy9T1S71w+TulL+RiSdsmS1aHvjuCRTfzdhnD/urYlBIInLQWaULPMKnOwSqSg0wZJrDsEChI+uU0Vvmnqo2HQVLKyXFcguED8PF9NwSrJCm/J5nkwF3bCFTMZPWU6yu2d6TWJZHr13F2MIHdNtFWsY2mRWlwdy49mzM3m26KpOld5dPClYWsVEbCix04VKNtJeSppt4cWCSS2RkNPHJ0AKx/RSoD2eAo3KasGrSoK0fx1stdw/4/9HiyZizP3AwVXyrAXoEPrEjytFccCz6F5UJS5kdwC9xLVyKVc+CMa98oJx4XSIW1ayFuqxMQpjqjeOiCVKfarQ+Ac8C00woxXgbkn0cI8JPfzqlzkYl8kFz57Tz7dYQLt6bndCfGBPGN+pt+KhPLQTRXi9wGuFGsu/zuFgR0EK0L9gHOzODUAZ/q/Xa0UmdPqIJlyfhfN0PpDjvnZ7Hez5aQZWdipx
 7+7lSBdi
 RIvogAR3KvJ82rI1uGSssOuX1OpG/98Oi3wy2Jj0M1g6rr9w4Fa+raCgBUqrAj4s4e4VAuMpEc8NL8Rm1eieRT2KnS2dUktxTRy6nLdDj2PZrENXiULrIJ9EiqktDogsvXu10x9/np2pQgMTZQv1E9EkOkcDCo2PG2tF2jQgToWWafaAiGtaAbBVyAgr3vYnB0IknA1jTtezhjY/LtBQkXH77tDp865hGND0O5mDZ1jsZwSknuWdPB3VjGUfNyOB9eHof0v3xVXH+Yis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that all the symbols used by the CMA heap are exported, turning the
CMA heap into a module becomes pretty easy: we just need to add the
usual MODULE_* macros, import the proper namespaces and change the
Kconfig symbol to a tristate.

This heap won't be able to unload though, since we're missing a lot of
infrastructure to make it safe.

Reviewed-by: T.J. Mercier <tjmercier@google.com>
Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 drivers/dma-buf/heaps/Kconfig    | 2 +-
 drivers/dma-buf/heaps/cma_heap.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/Kconfig b/drivers/dma-buf/heaps/Kconfig
index a5eef06c422644e8aadaf5aff2bd9a33c49c1ba3..aed0b9b4febf388376cfc41be9843980d010c4e8 100644
--- a/drivers/dma-buf/heaps/Kconfig
+++ b/drivers/dma-buf/heaps/Kconfig
@@ -4,11 +4,11 @@ config DMABUF_HEAPS_SYSTEM
 	help
 	  Choose this option to enable the system dmabuf heap. The system heap
 	  is backed by pages from the buddy allocator. If in doubt, say Y.
 
 config DMABUF_HEAPS_CMA
-	bool "DMA-BUF CMA Heap"
+	tristate "DMA-BUF CMA Heap"
 	depends on DMABUF_HEAPS && DMA_CMA
 	help
 	  Choose this option to enable dma-buf CMA heap. This heap is backed
 	  by the Contiguous Memory Allocator (CMA). If your system has these
 	  regions, you should say Y here.
diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma_heap.c
index f8a3d87f3ccee9630383ba28502eb40b10671cc2..7216a14262b04bb6130ddf26b7d009f7d15b03fd 100644
--- a/drivers/dma-buf/heaps/cma_heap.c
+++ b/drivers/dma-buf/heaps/cma_heap.c
@@ -422,5 +422,8 @@ static int __init add_cma_heaps(void)
 
 	return 0;
 }
 module_init(add_cma_heaps);
 MODULE_DESCRIPTION("DMA-BUF CMA Heap");
+MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("DMA_BUF");
+MODULE_IMPORT_NS("DMA_BUF_HEAP");

-- 
2.53.0


