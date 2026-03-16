Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A4D2F53D89
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51376B0350; Mon, 16 Mar 2026 15:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB286B0352; Mon, 16 Mar 2026 15:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDDD06B0353; Mon, 16 Mar 2026 15:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A73926B0350
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 546C3B9670
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:18 +0000 (UTC)
X-FDA: 84552859356.29.1BEC2EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D4BCE40008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nQIpRZVj;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeY2pweBzJW77nlydbnAhk3zZO0kbKITvaq77hXlPKI=;
	b=C2TnpwrAaEDVVMkNdP2EXxF6LBprc5seJipJfUeP9wyCNPkkZUuol0hYWqGq84bPY7Zty+
	6s0HVXAFWQAInMro+/FmSGy96VnLLhiHx5cqxjSYNtYthg25/0MKyf/ClMuTOLc44Cbs6K
	9wO64bzxnlPzfSsYL3qjJook+W4Un9Y=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nQIpRZVj;
	spf=pass (imf11.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688036; a=rsa-sha256;
	cv=none;
	b=JHDmVy3tq/FBJdow5e8LBmWEshKYrCyxyoRiZEc0UJcw0v8gffHKX6Z+lI9AQHQ5aqEBbE
	4QJsdofrwVVMLVRFtKl0afEPB/qkn3I/js1MkoUpUgdXuH/1BK+8cfPMbEly1si6jSG1pB
	TznHv72Me3cP+ZG2X4jsxCcO/SBABX0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C0776012B;
	Mon, 16 Mar 2026 19:07:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 486BAC19421;
	Mon, 16 Mar 2026 19:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688035;
	bh=Y7IxYgFPwpNVvKXeK9nR1uoDv1sEB/976av/0RuDIXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQIpRZVjrncGcv6d61BCi0UIP3qGV+iU9yUSpZ6PURLBwRW7JYFCHFMYWeHe4GRIf
	 67NzuI4t53eJ9xpRRZFfeEOPe8Es5onXjA3FLT+wVEbm5aWunQunwM+Wo9mlmv6XCQ
	 dBr7Hn4O/6PSBLZz3JYlNc+m6yvDDz4JU2hIZH2IXfM+TusARyzUz0q9S+VWzUShC3
	 oVxc482tMyBwhbuiiu2S/D5giAKlSCRt6DEryHmlrEhBu0hsfKZSE/9RgYFaICUi2p
	 p8wemyHg4PTBEkUgVHopxGVm2DagRESjBhEIyJPoPhx7ObOrygks54kKAjC4oMGbv1
	 +Bc4Q+rFSZQ5g==
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
Subject: [PATCH v3 2/8] dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
Date: Mon, 16 Mar 2026 21:06:46 +0200
Message-ID: <20260316-dma-debug-overlap-v3-2-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D4BCE40008
X-Stat-Signature: xje5ojhx5gnpf8i4g15banketitwkfuq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773688036-124322
X-HE-Meta: U2FsdGVkX1/cm0DvgkzxqzfR2H1lBKc0AS5OE94rBA1I1UzwxJsG54vV+OX+Umm/RtgqXiq5t5mrx/5rl1PabDV8bRiOJRPBG4q8htyMLHisHC8cYVkjYL+pwgcuAXsoXKHeeuNJGJV4m2hTKOklwqnPS1ZNT7iBFXoFdrRkszqhxF/kea03o3CgEfBECwmJBEzzTUmB0sLeqV2/MujWSXRfPQSaJDU5J8BMeN4NTAXzrzVmhW2+I4vs94MnJ3kZy9e5Vfa6Rs/jZCAkRJSyNP9uquZ1ullTinW8Hr8l5GOvMe2i/9E1pYP/x2RhbJFJ2j/E2/T02oQ5UJnfA/wdK9utFmKT5m6fK3DeQ9E1Arc68bVAr6lEjwghX7V74l9aJY+SK1q/50gdG4HCtnqIk2+HoQ6QwVm7hdSIZAQ4hHnzPdrX043nzpVonxb/H3dnU0AjHSAaGxnEQxxh0F8D+dyf89YI+R+YOS6ITxTuG27/V5EX+j5JgHGtq5WYC4wQN/STb8WiXy7DCyUmRscbPjTP4YNSrOp09tlCQhaYaoW/6hYK2aFjhwNrbK80HF6ysenozb3XjcTzgNDnbTng7k7UkvqXghXWnbC8QD/Qeb1sweOqZeRedmS+5qxZi71ziv3Y+WgaFtUW0zEpTouNJUqx4z9KgN9f46N4QQOSXHtdHfvLrxvf1J/22iKK+QXQF3San4eX85H6NcoE5ipCUGYj813wX+fraHxY06ueSXjTljkmPCzFmykrxTuCRzlukhG9kB6tgGoCVDEgDAtGt5PZwPPM8QcYcdhimkeH4CIPMYk+v+9gpHzUBYbopBCZZiXhgSG2/cBRUVWN8TmBrC9NwZK0avGXpB6RRredjdNjMsD423CRchJV1toPoPryReiAO9ZjdgUSYdqZqyzH3A==
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


