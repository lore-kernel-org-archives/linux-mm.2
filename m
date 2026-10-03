Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC89CA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116796B00A1; Sat,  3 Oct 2026 17:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDE26B00A2; Sat,  3 Oct 2026 17:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0416B00A3; Sat,  3 Oct 2026 17:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C19BD6B00A1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:23:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FE761609FD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:06 +0000 (UTC)
X-FDA: 85282590372.12.F58F7CB
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05F03180006
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:23:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Izb3my/y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3NnLBagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3NnLBagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062584;
	b=ZYJ5wPEsZ0DlEZ4SVIS0TdgqExpeA716y9iYdXXAkbpBlndJk+2P0Kzx1wb8YJ0nV+1fad
	WVxJMUg//WfW4nMeTwUgCi7U2OFDk0VQqgWz7YC7nCpxaNq4nGw4PwIWa6FcnpuVrSUNis
	v04HEhWws8wBqL2HdBwWqRW+gHFFcqs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Izb3my/y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3NnLBagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com designates 209.85.218.72 as permitted sender) smtp.mailfrom=3NnLBagYKCH0msj00phpphmf.dpnmjovy-nnlwbdl.psh@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Y6eccMU3oNOC6nPRXFDlu2gRIyDfLt0ekbGijFBkOg=;
	b=dCWMx+EV2D3iA/tCv24V3PAy/gmHtbr3H3NBUrHCCzIpZM6wXSU4Q1rwK0Glpkks96t1I+
	ne+vn0Ky9eplYGm3wl1C1YZ6yuw5nGqeVsLYlz4AX5VFcuLE9+riAGQ/Jj0/0al/eWir21
	e3m4P0sHekYRVDlPpg+4Y64L2z5M9pc=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c2e6affec80so71661566b.2
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062583; x=1791667383; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9Y6eccMU3oNOC6nPRXFDlu2gRIyDfLt0ekbGijFBkOg=;
        b=Izb3my/yiuEWHzpHLV83mk77vE3NR5+uZHtWsJPiKTNLH6eRQIYUMT2BIHJlLy7HH9
         S1WSzKYAZ5ZanIPMDXKprB8z+X2YAQQgYYI7pgAs6cwCfaLvNiN1YkuDsbGT5qp6ZqGq
         KfmhHoXXQurrd9jBVYK+PMfEncbTCHcrSKHSxL5imNuXaNNXN7THNtMcklAweD1LL+Gg
         3Zhdy/r253aq0E4YtwE/ryyca36C1+wNT59X8/B4ZaV618UIKMqTUM3mY7eBsRayVACL
         zT9F2giOzUAhVlc3KkQ/Qy9ZFtw0lEamvfQUAH23Vrx3gnYU3bF7NjhKIqIbw+KmpCaK
         V9Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062583; x=1791667383;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9Y6eccMU3oNOC6nPRXFDlu2gRIyDfLt0ekbGijFBkOg=;
        b=q/C0l8ZPFryJw/GbSo4PBPWcKeNvuv/BLZJrIqWY+LRW9amvbwufyuPgHKw/8lMoCp
         uafOl5BVY8jtJtSon0Wz7M/Y/d89HaBT9WJ0BrN78FkcU8/cnaw6Ma9Twce9Nz1ZXkto
         VF1cJir+tO57mnKgROgnrsGYDykIlDygpjFyEl2zf3hWhZn4y3Ncrgaj1d8xMV2NQTYS
         /Q5FFZXR9viVlqtKJi7mYTC5MrzslzN0n18fMxXF46PDetC55agyr0EkWkyMyvKXmDwG
         1JYx/bIyvpHBxpLIfLeTwnSVOjSbDLTOCPUeXdsDqY6PEcc0THRz+XiJrnqsoAdD2dcm
         eHuQ==
X-Forwarded-Encrypted: i=1; AKwUvBx7v8iHP4J5/13VlIFgf7aNA+SfIT7czltKkS/Ve9S00sG1u6bX40Gzv4F/3GGJC3yM4jPURisJXA==@kvack.org
X-Gm-Message-State: AFuF++mKUk1tozrvNEJwwGQPQDseAIetiV9+QEu11y2QcJFTZYj2r4Qs
	B+IaxqXC9Yz7owDpWOMFsE/Kew7Z9tq/CdX9LLjztkiPXFQkgP08n45U1J+b/LSUd12xhxAK8yz
	mBY37YQ==
X-Received: from ejbs7.prod.google.com ([2002:a17:906:607:b0:c2e:1f26:6d02])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:72cf:b0:c2d:cbc9:3529
 with SMTP id a640c23a62f3a-c2e4af393e2mr567647366b.20.1791062582284; Sat, 03
 Oct 2026 14:23:02 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:31 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-13-lrizzo@google.com>
Subject: [RFC: DMA_PMD 12/22] net/core: Use per-CPU DMA_PMD pools for skb_page_frag_refill()
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
X-Rspamd-Server: rspam06
X-Stat-Signature: kw1ny4yq8zk6czjpddkco7tpapnhu5i9
X-Rspam-User: 
X-Rspamd-Queue-Id: 05F03180006
X-HE-Tag: 1791062583-434677
X-HE-Meta: U2FsdGVkX19fIMKPer4K30WdvTE4s5LNUquDllSNnXbsZk6TMQUAvcP3zxa+U7fXRf6fRSiAXBPrpSfPixoxfJeWMEO9izc/EGbJpqHkLsEAQQw5UAzPiG8gUeLUr6QiTCKbrV1O9fkZK6w2DLZErVSOriLBza7AqLR3qkTZIN4HKU3M1wUndVPK+VTHVxYz5z+8V515X2P1QwwRTQi/1Fnk9PA1cQgP+tuq6teThJ9r+seYKUoulczSvLEwY4xOG7i7XmmR77pEHsLRoUw1HDyqJ/Jr252yUy473PsC9sP1vyboNRto+r+nZQFFFVgbygD60xkx9IhXGjMnqWVIzzKB/OgK6jzYuGaNhFwGxpc5V4/RqIlBqtt88Xh8KrUyQgYYp9p6m9jwSwlV18GlMdhU9IOp1OR+csxSyPAwQaXT040u56x7VJT1eylJS/KB9tDGV/Ra7EEC1E848rE53m8qqI21c7VmP62hhkLMs3grLkOqFtYldqWjrcFuFQjew5R1uVTBE8o3b9zBbqGYtVDLBOXnGhKpotvzY4QEDrBz3gjohKf15ibIkw7ZUlutXVqw1rd1M6kwF0U1Vospli0ovyp+OxN3/KLU4bz+5YPoOAbkPRkyJkgDxCOVhdRD63+D6KtlEd2WB5wuAGMULILDGvsiBllRo2dzSVqIyw7hQDjUDCkOTlgzEyZZSLI2lQ3c/iBiQ2u9KJkTJ/wdwKej3cnoeqkevoUPrBJOjpfzcAnbFCxy3LJDwov7iJ1cPx0HPDMup/L3URh+Cp5h0EwEb8Ibn9ExqQvmqirxsmkS5ReFgumYtasL5ASD09eAQfhk/ssalqjfBoEXaTODpLI2tmieDE007kVUKFMUii7I6DsbOa635ec7JqClrSzCuQCb2tyeXx3l1uQIm2vs6JiLvc71kNQj0CChgkusZDkmDfDkpkFjkqVu769v/5+3bZgIpWtspEv4yOzsyS+
 oa9pBt6I
 pVAMRwfPbwLcqzSlDMRtCYKrqQJ82M/OFWMZGl66TcBnIYOVKt9fB3NfFbXZlfAlNLVsHmT5isDS2geo1kFf/HpEb8Ie27JN/9MLEXBIDHkKo/Z8gpf9sZ1ZbwfEKqfK8DYmyYHkBbD5Q5qJ7JBNdCvIeWNkaR+Jd/9i9B3bCIwm5vFp1OSjRrm5jR8SopgDyv0VooFmYY3AV/MI/AFC4GlsheGzLH+4snduumUejQXNLT9Tv9zyVUxC+P97SD/p0rSMtoyCiG6zHSnyj8TWB8vEdeZDk73yB5GeYsChADP3i7DHS+9TGUK2c8nnCbE/a+H3GMVAcz8C8m+0GqtPxiQa8yi1VxlUm1dFB2OehKQtbtz5QFQ5PJ6SPrhwfyWIOB8YB6kr2ycalt56jwcjMfrEF/OCMZdHeoxDxL9zT8ytMH4s9XxFYar5RtV8PFaRD4bp7TSdmbdGtRprnY9xinTHpCGgFPIuNHG7qkkgyzb4RiMVlAXOoM8IKBMI5DsMB5W0/NdOcfCO32+t1zOSVgR+s1OnmdYvYo/ORDZqfWpybtfhrJlf9ZI3nqlQbPyo+rbbJr2uIdwTor+xPoiATnud++S0wuiY2Neve5elzS4Jv0RPq1ugCB6Lsp/EUgtiuwwQUS7CWlyosDpBXPfwY0XQuQeA5zTO6QJhf4y33d6cKA2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add sysctl net.core.tx_enable_dma_pmd to back skb_page_frag_refill() with
per-CPU order-3 (32KB block) and order-0 (4KB block) DMA_PMD page pools.

When enabled, TX socket buffer page fragment allocations draw fragments
from DMA_PMD physical pages registered with per-CPU dma_pmd_pool. The
first allocation maps the entire DMA_PMD page, subsequent allocations
reuse the cached PMD_SIZE IOVA mapping locklessly without per-packet unmap
or IOTLB flush.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 include/net/sock.h         |  3 ++
 net/core/sock.c            | 86 +++++++++++++++++++++++++++++++++++++-
 net/core/sysctl_net_core.c |  7 ++++
 3 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 60ea55dc18854..a06b53e9ff225 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -3092,6 +3092,9 @@ extern __u32 sysctl_rmem_default;
 
 #define SKB_FRAG_PAGE_ORDER	get_order(32768)
 DECLARE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
+DECLARE_STATIC_KEY_FALSE(net_tx_enable_dma_pmd_key);
+int net_tx_dma_pmd_sysctl(const struct ctl_table *table, int write,
+			  void *buffer, size_t *lenp, loff_t *ppos);
 
 static inline int sk_get_wmem0(const struct sock *sk, const struct proto *proto)
 {
diff --git a/net/core/sock.c b/net/core/sock.c
index e8551df8330ff..1fd338a547ce1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -115,6 +115,7 @@
 #include <linux/memcontrol.h>
 #include <linux/prefetch.h>
 #include <linux/compat.h>
+#include <linux/dma-pmd.h>
 #include <linux/mroute.h>
 #include <linux/mroute6.h>
 #include <linux/icmpv6.h>
@@ -3173,6 +3174,87 @@ static void sk_leave_memory_pressure(struct sock *sk)
 }
 
 DEFINE_STATIC_KEY_FALSE(net_high_order_alloc_disable_key);
+DEFINE_STATIC_KEY_FALSE(net_tx_enable_dma_pmd_key);
+
+static DEFINE_PER_CPU(struct dma_pmd_pool *, tx_pmd_pool_high);
+static DEFINE_PER_CPU(struct dma_pmd_pool *, tx_pmd_pool_order0);
+
+/*
+ * Lazily initialize the per-CPU DMA_PMD page pools on the first write to sysctl
+ * net.core.tx_enable_dma_pmd.
+ *
+ * Once initialized, the struct dma_pmd_pool descriptors remain allocated for
+ * the lifetime of the kernel so that lockless raw_cpu_read() in
+ * __alloc_pmd() is always safe against concurrent sysctl
+ * toggles. If pool creation fails partway through, all pools created so far are
+ * destroyed and per-CPU pointers are reset to NULL.
+ */
+static int net_tx_dma_pmd_init(void)
+{
+	static DEFINE_MUTEX(mutex);
+	struct dma_pmd_pool *pool;
+	static bool initialized;
+	int cpu;
+
+	if (!IS_ENABLED(CONFIG_DMA_PMD))
+		return -EOPNOTSUPP;
+
+	mutex_lock(&mutex);
+	if (initialized) {
+		mutex_unlock(&mutex);
+		return 0;
+	}
+
+	for_each_possible_cpu(cpu) {
+		if (SKB_FRAG_PAGE_ORDER) {
+			pool = dma_pmd_pool_create(SKB_FRAG_PAGE_ORDER, 16);
+			if (!pool)
+				goto err_cleanup;
+			per_cpu(tx_pmd_pool_high, cpu) = pool;
+		}
+
+		pool = dma_pmd_pool_create(0, 16);
+		if (!pool)
+			goto err_cleanup;
+		per_cpu(tx_pmd_pool_order0, cpu) = pool;
+	}
+
+	initialized = true;
+	mutex_unlock(&mutex);
+	return 0;
+
+err_cleanup:
+	for_each_possible_cpu(cpu) {
+		per_cpu(tx_pmd_pool_high, cpu) =
+			dma_pmd_pool_destroy(per_cpu(tx_pmd_pool_high, cpu));
+		per_cpu(tx_pmd_pool_order0, cpu) =
+			dma_pmd_pool_destroy(per_cpu(tx_pmd_pool_order0, cpu));
+	}
+	mutex_unlock(&mutex);
+	return -ENOMEM;
+}
+
+int net_tx_dma_pmd_sysctl(const struct ctl_table *table, int write,
+			  void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write) {
+		int ret = net_tx_dma_pmd_init();
+
+		if (ret)
+			return ret;
+	}
+
+	return proc_do_static_key(table, write, buffer, lenp, ppos);
+}
+
+static struct page *__alloc_pmd(gfp_t gfp, unsigned int order)
+{
+	if (!static_branch_unlikely(&net_tx_enable_dma_pmd_key))
+		return alloc_pages(gfp, order);
+	if (order == SKB_FRAG_PAGE_ORDER)
+		return dma_pmd_pool_alloc(raw_cpu_read(tx_pmd_pool_high), gfp);
+	return dma_pmd_pool_alloc(raw_cpu_read(tx_pmd_pool_order0), gfp) ?: alloc_page(gfp);
+}
 
 /**
  * skb_page_frag_refill - check that a page_frag contains enough room
@@ -3200,7 +3282,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 	if (SKB_FRAG_PAGE_ORDER &&
 	    !static_branch_unlikely(&net_high_order_alloc_disable_key)) {
 		/* Avoid direct reclaim but allow kswapd to wake */
-		pfrag->page = alloc_pages((gfp & ~__GFP_DIRECT_RECLAIM) |
+		pfrag->page = __alloc_pmd((gfp & ~__GFP_DIRECT_RECLAIM) |
 					  __GFP_COMP | __GFP_NOWARN |
 					  __GFP_NORETRY,
 					  SKB_FRAG_PAGE_ORDER);
@@ -3209,7 +3291,7 @@ bool skb_page_frag_refill(unsigned int sz, struct page_frag *pfrag, gfp_t gfp)
 			return true;
 		}
 	}
-	pfrag->page = alloc_page(gfp);
+	pfrag->page = __alloc_pmd(gfp, 0);
 	if (likely(pfrag->page)) {
 		pfrag->size = PAGE_SIZE;
 		return true;
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index eb35da3556f4a..d9a7d9cb349e0 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -651,6 +651,13 @@ static struct ctl_table net_core_table[] = {
 		.mode		= 0644,
 		.proc_handler	= proc_do_static_key,
 	},
+	{
+		.procname	= "tx_enable_dma_pmd",
+		.data		= &net_tx_enable_dma_pmd_key.key,
+		.maxlen		= sizeof(net_tx_enable_dma_pmd_key),
+		.mode		= 0644,
+		.proc_handler	= net_tx_dma_pmd_sysctl,
+	},
 	{
 		.procname	= "gro_normal_batch",
 		.data		= &net_hotdata.gro_normal_batch,
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


