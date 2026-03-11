Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B7D6112586B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D236B0092; Wed, 11 Mar 2026 15:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D069C6B0093; Wed, 11 Mar 2026 15:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD976B0095; Wed, 11 Mar 2026 15:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE5206B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5CDD4C18D2
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:14 +0000 (UTC)
X-FDA: 84534720228.04.0BC6552
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B0D0314000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PZjly+FD;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeY2pweBzJW77nlydbnAhk3zZO0kbKITvaq77hXlPKI=;
	b=0qD13gzRlc1Imt2hAtQSK7r2qqcSoSyphgii8NrPtcc8liI4aBCYfYEU+bwFl8voqvlgnQ
	WJKd4rSNGaUOXFiGtbIPv78J6Bn5JnBJkIWbLUmKuIjHqxjMXtmwzn7GK+6ZsvfcZq59C+
	ZmvhOqYHyrD9CG4cgnMjksMutj9TiyA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PZjly+FD;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256152; a=rsa-sha256;
	cv=none;
	b=Ft5W3fwBcQpdRYJB173tKRMDZRTFrMNP9dpGypCnMT5HG1ZDvtvnGm1lfz3dd6FiCHQ59B
	vDcb+7kJ7U8f2ojKfXGLF1IUvnvhIdVw1FH4csjsU6sGpU++sDtHGiSjCFP/3uJUrkKUgT
	csTzZYDkDhe5rKdEcwk5Fmfh+8anx1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C8396133D;
	Wed, 11 Mar 2026 19:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AAC1C116C6;
	Wed, 11 Mar 2026 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256151;
	bh=Y7IxYgFPwpNVvKXeK9nR1uoDv1sEB/976av/0RuDIXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZjly+FD7RhrJxb1JD1VgY4spyEehNCANCCnx9mVnO9J4cWhenNclePe/JK1Iy/Zy
	 +lffzBEJ96sc2SLnsy9exQHyisEszVRb6oOq7EVzSXq8W0Yh6WxIr+2XUnyKA/cLf1
	 m/pz6fl6AezPbzmXIBszDFIE6tSwhBG826fO3jBsXgikveu0HxOOIIzjIiVCwod0no
	 h8cuXF1gV1UO9KAr6ZbxDb+aFehyKFej3C2cqyHB/TvpuI/c+GbC7iBQIckvCaERVV
	 LBj5kuI7vjP92AtWxD4vuJJ7/CW8N+ksu9l1OeuVKXABVX+04P7FuPyblNDEpBBNcp
	 5RSfo2p/vb5sg==
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
Subject: [PATCH v2 2/8] dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
Date: Wed, 11 Mar 2026 21:08:45 +0200
Message-ID: <20260311-dma-debug-overlap-v2-2-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0D0314000A
X-Stat-Signature: y4b1n93w3bkuwza31cqswskpsk57yoi1
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773256152-368652
X-HE-Meta: U2FsdGVkX1+fmen2oietMjwAYcLRpnpji+aiAzphxwnLA9fm5ADFh/Jlm7FLk7kIkPjbnHXoq8SrPDhoVvdpqkFP/lkvvMwvEumcTaPn1AsQQhH+S5R3NL5aNj5q92ycOaH4RB8knaMq+CNgYvukAwL18gMjKwJFISMe6HGc2glM6wAsi74Ad5/aPdTiNDHQDxhn3JeD63uguwd6qfYfLAk5h+9kmyDuALhReXVYFXuKFmPsRKHD51HAcDyymM+q4uDG/oVU9brjyspCIGc0aD5CKcVaJNbaTgp3dEJdZ/Q2+QzuF/RQdAHKq+qMvB08uhsxwzrVqWL5htM2G09/tv70mL5A7f1T+5y9S+TUBv5L4I7dxWVQIgRtzmtcftZ7DeFL1V2iuHdRbX1xFJcygcs1wXQP9THpPoQl0M90We+Xaw27jonY0RlA9RpJxlWbMJ+7WJSIjSwRPR+Ya5aaIRLOlPnUGPG5ukORj2xgEBqShDUI+nCAjSL8f7vmrej7cJ6Pc0JbBNxt3kNYEZcOANU6x92Hc1SN/ive9irc8zjFTJz92jPdNSkhy3oD+ZpaPpqbJc8Mdzl7jdnUqFzcWLyo9FQzR3YWBl6qBSzHuNgtgAop8tEXqpVzgtoHBNAlVAi7QEnMX5V8AeSfP71dQUchGBgI4BoDIGfu3WapoHefB9iQ3MY8dmMkTZo8DwJ+QnJZo1ei1JX1fsnFNY7YImrN0ovS5ybUYhJVz8Dedoq6jZzghcLZBY/g/D76SOT2Hh16H7daO/JhWStG7qzrNbf3llzlnwpfR/tpYl5VKAqURXVS45BRThpf51FkKThH+KvoeWa60RcS/YiXcOk8TrqLwLkpAEYp0o5glPQC6XYG5Zzi123HLyiedRp3RtdAj9UpmKa+sNQYEVinefhGfHPMcWAyBUYzd/x7ev7Nr1wikqPf8iMXyrNYjVh4BSvgqZoV1ZtxHbq7wyVPDR+
 3eFZb9Os
 c9ehsdG2WXO55npA8NmXGKAwh+CorJ+OlVJ09hhweT3Plvp73EADLB5xJN56YEmy+ecHa0rLtBplBF7+6LMvFTDMGs2PNw/SF3S1pDVjFxdNCoZYgO42EJIx5Dnq/6JOC6cwQb8YwmQZdPwKAVP/RWyrsr0vYGz9MSi6tIbTZHBgQ53VaPwaeb6vuYf0gCKZYsGIe+iMhiOBzD4UKT4c04v8fDopsh0J+kbXm8f8lBQOGX+CpnVr/B6erwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Tracing prints decoded DMA attribute flags, but it does not yet
include the recently added DMA_ATTR_CPU_CACHE_CLEAN. Add support
for decoding and displaying this attribute in the trace output.

Fixes: 61868dc55a11 ("dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/trace/events/dma.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/dma.h b/include/trace/events/dma.h
index 33e99e792f1aa..69cb3805ee81c 100644
--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -32,7 +32,8 @@ TRACE_DEFINE_ENUM(DMA_NONE);
 		{ DMA_ATTR_ALLOC_SINGLE_PAGES, "ALLOC_SINGLE_PAGES" }, \
 		{ DMA_ATTR_NO_WARN, "NO_WARN" }, \
 		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" }, \
-		{ DMA_ATTR_MMIO, "MMIO" })
+		{ DMA_ATTR_MMIO, "MMIO" }, \
+		{ DMA_ATTR_CPU_CACHE_CLEAN, "CACHE_CLEAN" })
 
 DECLARE_EVENT_CLASS(dma_map,
 	TP_PROTO(struct device *dev, phys_addr_t phys_addr, dma_addr_t dma_addr,

-- 
2.53.0


