Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61997CCD183
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265DC8E00BE; Thu,  9 Oct 2025 21:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 215C58E0002; Thu,  9 Oct 2025 21:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDCF8E00BE; Thu,  9 Oct 2025 21:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E87B98E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE2C4116C52
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:16 +0000 (UTC)
X-FDA: 83980448832.20.DF493DD
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id F22752000A
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ot5sKEjC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3TV_oaAYKCPouwtgpdiqqing.eqonkpwz-oomxcem.qti@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3TV_oaAYKCPouwtgpdiqqing.eqonkpwz-oomxcem.qti@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vrde2qlU5hqI2CpGGepvHr5s2l9yi26YQf6xU7aW9eE=;
	b=wUNahptXZD0PEVlcIWUIvTnJxayhwiRsdoIfachUd3L1jLMe2mjYFQxAOlAZ9wRUCCy98S
	4TpWAkU/RZQBQiSfw0ZA54ic23j9LdOSpFSZ8MvRej8MB8bjgjQCb2EtqIfzAlzhfOomrk
	4NOSRG+9s/aqgObrCPcLv4V8gUbYmRI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059215; a=rsa-sha256;
	cv=none;
	b=il2v2SS8ZRVbBMrFfydlufEMfqUzUOFplMLnSdfraAAEA/S9BRWmtgnNKi2Mk0OkeSYcOj
	D91uV+5SQAQEbjFP2r7zlxc9IVbAzK3bAioLQ04azo2uyucpLORd/N3Z3GmzB+bzzoCUEr
	0epQ9z5qKXXqsbnnguzFb0P8YuVbaBs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ot5sKEjC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3TV_oaAYKCPouwtgpdiqqing.eqonkpwz-oomxcem.qti@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3TV_oaAYKCPouwtgpdiqqing.eqonkpwz-oomxcem.qti@flex--surenb.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5a013bc46dso2543567a12.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059214; x=1760664014; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vrde2qlU5hqI2CpGGepvHr5s2l9yi26YQf6xU7aW9eE=;
        b=Ot5sKEjC4T5SrQlwh39f41ftN60a+OxqMZm3REO/re9jjZhaDRq2Q6e9JKh/Z/U8If
         klSieJQtp7ZVtJh5hXTfdeR5AZHCRtx3+BtJ+DndEIq8tfAhVd46OfGUrpeOmDCQAaw9
         xVnJEMOMwtrXyFgu3kLxTJkXtI5LejGEokEahbSRmggDyHS5REOS6HnOR851day2Y/Dy
         z1jHaCdMbezdpwoMweMjUDN9RzhZ68JGNNMwZWV2F4QB7j0Hj0RwNlhaSh0mR87pxPmc
         NnklArWYEkA1dNWXN4W2xND+EjR8psOzjTxQqmtVOH0h8cRcjXlEVh/8B5qSZiVare8X
         JKww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059214; x=1760664014;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vrde2qlU5hqI2CpGGepvHr5s2l9yi26YQf6xU7aW9eE=;
        b=JQmhLToi5Ralwd2+E3rWBhMmJQF07DUdV8gXgY5j23whXYQbrBtJNK1XNf+s5AazQI
         atD3l9tT7MS6i2NFtehNyTg6nyL5fnUIZWFOv4NNI4I+a9jBaAXM0EN8PHkYYp1Y9zjt
         vmU/8JdSNj5ndlYyGeYCRsI2lKDTPFGIM4jSzSOAgktbhVS49X55IbNUn6O3Qu+ayclq
         jQFiu097u6rqCNcZn8Ak36ORLtLdnmlqypFtRElGaeh6nJ2A5WRvCoDojl3oprex5DC+
         hxcH5xGt4cHwmjnjuRDk/4f/ahgM18iii3NVEl83V9GIG2dQ3gLAFUfIETVlCVLYa8wZ
         UvwQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDMZSBTyA3SPObMKkhqQUboRoAWeIIMZ2oXDiSeOI1asz+USpvP2BXajx24zIfNUKkEpLss7KQhw==@kvack.org
X-Gm-Message-State: AOJu0YxNotAvtrcVkVB8XrZ1zbTtIgAReUcasLv132L+i6KW2wGTt5cG
	cZsL3CMjN0FtG7sHfkvkiHOfZkvKXVwv9JgQtVKWvGApEKh9JYN/9RYRgyJWvcMqxojwXq+Px8J
	eGePWVw==
X-Google-Smtp-Source: AGHT+IHv8uHGO40bLuN/jD5N/hL/DXXvgcz7LG4u+TAflEKVP3j7kuuG1LjFXB0Jk3SVlTNaWflJDBbA6Ac=
X-Received: from pgew27.prod.google.com ([2002:a63:af1b:0:b0:b55:794f:64bb])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:12ce:b0:309:48d8:cf0a
 with SMTP id adf61e73a8af0-32da8462fb2mr12231761637.54.1760059213708; Thu, 09
 Oct 2025 18:20:13 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:51 -0700
In-Reply-To: <20251010011951.2136980-1-surenb@google.com>
Mime-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-9-surenb@google.com>
Subject: [PATCH 8/8] mm: integrate GCMA with CMA using dt-bindings
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Stat-Signature: xhjm9kti1iqs6xb5s16nbz5x7fpffk7c
X-Rspam-User: 
X-Rspamd-Queue-Id: F22752000A
X-HE-Tag: 1760059214-328340
X-HE-Meta: U2FsdGVkX19e+kguTOOBkEtnd6fYCvbT39AaDrm9LJJHFKQAm/2Ot3/0Z9cwEtqCd/XYOZwrT6cGFGlDAQF9zgAza4pOqZkCis10l/MQyJJDXowygEwwNyBIoaPcavR4IKfwdtpDMcDA47qd8SDUN4jdZf5Pfz7P4/Caco1RY1QuiP/wA1BHx1aiZWrMrma+/dOUN6qS9G7OAw3lM8sBD77msn29Q3BUN19V6Sv321oDeVxIPszEqpp01XERGmHMW/s9A2ZQ94vTXe2WKZVeU/lfpK7nh9edCPyvEQl4BiAn9NqyA4NgUW/FAUJw1ut+6UaVAqDmT0aM97udi62Z2z3jXWlwSkoUOcdRHREIQDG3vvExPkWEhDulCXjLs/iudJahQLaz5w4qicOxCAxb91Kfy7ksoRJtBaqXsLYMw3GfubKInEmOhyZIMnHevYAFivV1Vq6IqyfEGxuoHGUHdEd42c6xOvYyzdOnH/bb2Ip4i9TYLu5oHTP4b0eugWI3Jnpl7pJJvfDHlKFlGsWsNvWyrGLun+XgQpFLQ3/DCwh+NQabJxPxK2gxh7dNKKo/oMnZyQdztaKxwDTVhVJYHkygx2YzbateOt3BrWFDbyqldEkwvZDokNVvHl0Pv+ZXOYfyQ5TVi1ee3IQMUkBjhpyZVe+wIJb8cnk2mjlvP+3GwmhJ/oensHL7Uo8m8F+5RtLx4RaTRKqzusNhZq0++gcUx2Gi6ZIo95S+34jGLcMJESmOkkItOgGA6OJ1MUKx3pHn+wz26tjE3kgwo6JEohUcHjLNz73E1xPox6iL96O/RbPWs28rA/IJA/kJYAMC7Jjl4e9wL0RmHZMxodeOdfzwdlY82CyGdIeGVLGXCI/MQQI2KLdWQ/tCZiIQ9y1oLcZ0wRvGsmVhlaUb8JevqwD5Cyvob9jRG2QY3TFuwmKqG44Prh7jKFT4A3PuqmqAEshde0OfVf8koewR+P2
 VIOTfNxl
 rQnx2/OtOideW0FfBN/IKxf/wi5VeAbzYfQyBcJwHTfaSUGvcLmY3vi/76O51yA7SW/Bp6ZfBY3QEOxcZp/ENS0DknJEUYvTR4p/SiP4Xa+y6EQM52ZrjDyAbSOkgKbneJoHgl5T45BRyH9OaekaImFfiS1oLXkXlN+nQ9/gyCbb0wujdk10R7EUuyv9kh4a8YFEhSQdWInulJfB0eemUduRdyc07DhWmscjYRNt7RjqGVZ/GDu4FnxuAcZvdzRoPbHWmoJfP2LLkg8p0xN9ICHQxqTWdFZVWXgfYkrhRY7rbhIsnlwBZCpfWYGXrjXtd1kx/EXJj31mOEBMYqRqPHAZkatK7JUW8Rde+2CW2uto44N4s7iWLIwYeHRsTM69YRVOHXI5CRiN2Ijbf4NaAQDCP2Uuv5rDTOEaviZMkozTcCM2+CpFS3YRtkeDz1xdXpxiZcy6aV46nPdZG0baGFFrSJtOqkAYMLoDVTy/PgnhLedG+XBnguNFegAaIHuhq5U+Lnyj591+8qpCfS2Xm+I4Ggu0S4bQIbKMabdIHS1OKSngXf2sjM0RtQ6V3S3H4wWiO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new "guarantee" property for shared-dma-pool to enable
GCMA-backed memory pools. Memory allocations from such pools will
have low latency and will be guaranteed to succeed as long as there
is contiguous space inside the reservation.
dt-schema for shared-dma-pool [1] will need to be updated once this
patch is accepted.

[1] https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/reserved-memory/shared-dma-pool.yaml

Signed-off-by: Minchan Kim <minchan@google.com>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 include/linux/cma.h     | 11 +++++++++--
 kernel/dma/contiguous.c | 11 ++++++++++-
 mm/Kconfig              |  2 +-
 mm/cma.c                | 37 +++++++++++++++++++++++++++----------
 mm/cma.h                |  1 +
 mm/cma_sysfs.c          | 10 ++++++++++
 mm/gcma.c               |  2 +-
 7 files changed, 59 insertions(+), 15 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..3ec2e76a8666 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -43,10 +43,17 @@ static inline int __init cma_declare_contiguous(phys_addr_t base,
 extern int __init cma_declare_contiguous_multi(phys_addr_t size,
 			phys_addr_t align, unsigned int order_per_bit,
 			const char *name, struct cma **res_cma, int nid);
-extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+extern int __cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
 					const char *name,
-					struct cma **res_cma);
+					struct cma **res_cma, bool gcma);
+static inline int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+					unsigned int order_per_bit,
+					const char *name,
+					struct cma **res_cma)
+{
+	return __cma_init_reserved_mem(base, size, order_per_bit, name, res_cma, false);
+}
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
 extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index d9b9dcba6ff7..73a699ef0377 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -461,6 +461,7 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 	unsigned long node = rmem->fdt_node;
 	bool default_cma = of_get_flat_dt_prop(node, "linux,cma-default", NULL);
 	struct cma *cma;
+	bool gcma;
 	int err;
 
 	if (size_cmdline != -1 && default_cma) {
@@ -478,7 +479,15 @@ static int __init rmem_cma_setup(struct reserved_mem *rmem)
 		return -EINVAL;
 	}
 
-	err = cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name, &cma);
+	gcma = !!of_get_flat_dt_prop(node, "guarantee", NULL);
+#ifndef CONFIG_GCMA
+	if (gcma) {
+		pr_err("Reserved memory: unable to setup GCMA region, GCMA is not enabled\n");
+		return -EINVAL;
+	}
+#endif
+	err = __cma_init_reserved_mem(rmem->base, rmem->size, 0, rmem->name,
+				      &cma, gcma);
 	if (err) {
 		pr_err("Reserved memory: unable to setup CMA region\n");
 		return err;
diff --git a/mm/Kconfig b/mm/Kconfig
index 41ce5ef8db55..729f150369cc 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1015,7 +1015,7 @@ config CMA_AREAS
 
 config GCMA
        bool "GCMA (Guaranteed Contiguous Memory Allocator)"
-       depends on CLEANCACHE
+       depends on CLEANCACHE && CMA
 	help
 	  This enables the Guaranteed Contiguous Memory Allocator to allow
 	  low latency guaranteed contiguous memory allocations. Memory
diff --git a/mm/cma.c b/mm/cma.c
index 813e6dc7b095..71fb494ef2a4 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -28,6 +28,7 @@
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
+#include <linux/gcma.h>
 #include <trace/events/cma.h>
 
 #include "internal.h"
@@ -161,11 +162,18 @@ static void __init cma_activate_area(struct cma *cma)
 			count = early_pfn[r] - cmr->base_pfn;
 			bitmap_count = cma_bitmap_pages_to_bits(cma, count);
 			bitmap_set(cmr->bitmap, 0, bitmap_count);
+		} else {
+			count = 0;
 		}
 
-		for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
-		     pfn += pageblock_nr_pages)
-			init_cma_reserved_pageblock(pfn_to_page(pfn));
+		if (cma->gcma) {
+			gcma_register_area(cma->name, early_pfn[r],
+					   cma->count - count);
+		} else {
+			for (pfn = early_pfn[r]; pfn < cmr->base_pfn + cmr->count;
+			     pfn += pageblock_nr_pages)
+				init_cma_reserved_pageblock(pfn_to_page(pfn));
+		}
 	}
 
 	spin_lock_init(&cma->lock);
@@ -252,7 +260,7 @@ static void __init cma_drop_area(struct cma *cma)
 }
 
 /**
- * cma_init_reserved_mem() - create custom contiguous area from reserved memory
+ * __cma_init_reserved_mem() - create custom contiguous area from reserved memory
  * @base: Base address of the reserved area
  * @size: Size of the reserved area (in bytes),
  * @order_per_bit: Order of pages represented by one bit on bitmap.
@@ -260,13 +268,14 @@ static void __init cma_drop_area(struct cma *cma)
  *        the area will be set to "cmaN", where N is a running counter of
  *        used areas.
  * @res_cma: Pointer to store the created cma region.
+ * @gcma: Flag to reserve guaranteed reserved memory area.
  *
  * This function creates custom contiguous area from already reserved memory.
  */
-int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
-				 unsigned int order_per_bit,
-				 const char *name,
-				 struct cma **res_cma)
+int __init __cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
+				   unsigned int order_per_bit,
+				   const char *name,
+				   struct cma **res_cma, bool gcma)
 {
 	struct cma *cma;
 	int ret;
@@ -297,6 +306,7 @@ int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 	cma->ranges[0].count = cma->count;
 	cma->nranges = 1;
 	cma->nid = NUMA_NO_NODE;
+	cma->gcma = gcma;
 
 	*res_cma = cma;
 
@@ -836,7 +846,11 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		if (cma->gcma)
+			ret = gcma_alloc_range(pfn, count, gfp);
+		else
+			ret = alloc_contig_range(pfn, pfn + count,
+						 ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
@@ -1009,7 +1023,10 @@ bool cma_release(struct cma *cma, const struct page *pages,
 	if (r == cma->nranges)
 		return false;
 
-	free_contig_range(pfn, count);
+	if (cma->gcma)
+		gcma_free_range(pfn, count);
+	else
+		free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559..3b09e8619082 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -49,6 +49,7 @@ struct cma {
 	char name[CMA_MAX_NAME];
 	int nranges;
 	struct cma_memrange ranges[CMA_MAX_RANGES];
+	bool gcma;
 #ifdef CONFIG_CMA_SYSFS
 	/* the number of CMA page successful allocations */
 	atomic64_t nr_pages_succeeded;
diff --git a/mm/cma_sysfs.c b/mm/cma_sysfs.c
index 97acd3e5a6a5..4ecc36270a4d 100644
--- a/mm/cma_sysfs.c
+++ b/mm/cma_sysfs.c
@@ -80,6 +80,15 @@ static ssize_t available_pages_show(struct kobject *kobj,
 }
 CMA_ATTR_RO(available_pages);
 
+static ssize_t gcma_show(struct kobject *kobj,
+			 struct kobj_attribute *attr, char *buf)
+{
+	struct cma *cma = cma_from_kobj(kobj);
+
+	return sysfs_emit(buf, "%d\n", cma->gcma);
+}
+CMA_ATTR_RO(gcma);
+
 static void cma_kobj_release(struct kobject *kobj)
 {
 	struct cma *cma = cma_from_kobj(kobj);
@@ -95,6 +104,7 @@ static struct attribute *cma_attrs[] = {
 	&release_pages_success_attr.attr,
 	&total_pages_attr.attr,
 	&available_pages_attr.attr,
+	&gcma_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(cma);
diff --git a/mm/gcma.c b/mm/gcma.c
index 3ee0e1340db3..8e7d7a829b49 100644
--- a/mm/gcma.c
+++ b/mm/gcma.c
@@ -119,7 +119,7 @@ int gcma_register_area(const char *name,
 		folio_set_count(folio, 0);
 		list_add(&folio->lru, &folios);
 	}
-
+	folio_zone(pfn_folio(start_pfn))->cma_pages += count;
 	cleancache_backend_put_folios(pool_id, &folios);
 
 	spin_lock(&gcma_area_lock);
-- 
2.51.0.740.g6adb054d12-goog


