Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB61BC4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614186B00A2; Wed, 22 Jul 2026 09:06:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4ED6B00A3; Wed, 22 Jul 2026 09:06:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5020F6B00A4; Wed, 22 Jul 2026 09:06:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 204366B00A2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:06:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AE3BC01AA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:06:55 +0000 (UTC)
X-FDA: 85016437590.09.A03B51D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3409820009
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:06:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vZGP0+ov;
	spf=none (imf03.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qmP1+k44uQ0XzsS2fg67ij07ScstcQcZVV2Jbwuyduw=;
	b=Joxd3d5Jh8GIgvO2eNQpDy/4VRzknEVWEy+rb4xcOYKXhj6CLH7qmYxyikrvpWwZ3y5l7l
	IEk6TXJP6d4fZYW5NjwVX+JoPsHwYBuZMylE8cQAs6NUtgpdibutlSv9v4SIiD7/wzfPao
	q43+F1Bie3vT3YDTUg4ex7bJjJL8vSI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vZGP0+ov;
	spf=none (imf03.hostedemail.com: domain of BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+371806032f8d6c276398+8368+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725613;
	b=21xDO8Y7ygHWMUe9leguMnGWVIGudTsjv6cuRIAZkVKCOsQWNs37rsHTtofDMIQeqAHVap
	hm5vIaDRw/3WUOArCdRYPKF3zwKflrRhaKSIUGTeC+mr0eAnBkrIQVec+ZXGF5lSNoSKJh
	VjnsycKjTU4eDOUTk7XB93Ie09F9QCg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qmP1+k44uQ0XzsS2fg67ij07ScstcQcZVV2Jbwuyduw=; b=vZGP0+ovGndQzTzHorEOgZRIsX
	SZKZtFESuUcSYvvMJ7SEctBCIYheC8pQ5U48ntqDLN9yH8G0Tc6XjiwtKgJUHDF60XUe3Wg9nmmcC
	P8KapGGgmmkswd1xz2unK7a7Ya+ZcPm0KZ7ZAEB59QAkS1p1ywXI2cI0AiInKYn5SgDByI76LpW1n
	NwsNDP2YfAD6npLdBZlyYhyYtbSUo1BkXUyqaAn+SZJ+qy/ar6ksvkC8y1pKvf/Ty4yiCT1Y5sCI1
	QQcH7NNzIVTR/8YSVR93U87B9NxZrZPFuSfyO3PyQvsZgrL4Pmcvdc6XcHFwQY0XN8VBP6RcGNzNg
	7wbA69IQ==;
Received: from [2001:4bb8:2d6:3a78:eb21:714c:af4c:ee7d] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWer-0000000Bpq3-2owx;
	Wed, 22 Jul 2026 13:06:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: 
Cc: baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	usama.arif@linux.dev,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	linux-mm@kvack.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: [PATCH 2/3] mm/swap: add a new swap_ops.h header to allow for pluggable swap ops
Date: Wed, 22 Jul 2026 15:06:08 +0200
Message-ID: <20260722130615.3163560-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722130615.3163560-1-hch@lst.de>
References: <20260722130615.3163560-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 3409820009
X-Rspam-User: 
X-Stat-Signature: a74485ki38c7cm6a94sgjut9i8s9umzx
X-Rspamd-Server: rspam04
X-HE-Tag: 1784725613-931496
X-HE-Meta: U2FsdGVkX193WGlcBmu56eXvg7X0wUrd4klxxPEb0VUzd07CsSwMUCbStejHff0ogogMxvrXw3unRD4TPo13L+rgiuszhp3nhhX1X6nCxcSfApa9142X44GR0tOoVY3+GZWjDEgkki4a5KCbYUKaa7SKqm6n/gabOjsSzCQiGoWL/ICSn27FZtMzr4t/TDI6rrlV30olmhWpnfSU9jhIVuiG+jmFIJvv0Y4MxNuuCUo7rXvf5no7pOL6l8G9ya3kj0gHNphl1C+RhkPg0ncuFS3H+3bS+eD9Hup3X6qDWFUdsddQ4aCgz8kZtYmYlLMBa6dFKooMcPeiZ7D+meYZtBt1e4fGlSA3GSp0mDxZwKQMkR0Oo2oQYHdFBOPyBhojxYWP4pX8CnrGTP7DdPNqWgxxYRVtvgZ4q+1t5XEQ7z3KORiuFSNOhYDsA1iVVnYKwID+ASsxIF6Tdd74ED9Ecgf7hhZTrhAJVRJi3LKYxHk0KULb74jt4TYWYeqtnwPitqAbzz6slCDFMu1bw9M1dTQ/YIBiufP+2HbJEynR3os4FV01N34P28LIeAiwqKPFfKtrEKjnZ+/YH0z7PsSHGITtt/VxXMMsnVg/sO/4eaP0d76O9q7GX2Yuh+yYZmqKWgmzsuDD12D5JBMavG5MxunRp+geW3fjH7ge2YakeiwjgM/icKc8xWu+lMSANBPGuWBkQ9aRo6ITQbOI7EYryLECRxYvRhxYfBVlNrD7KN6kCMdys6aYByzs6YSRHnHtcvbqCcAdAy6qWbrZ8TdIFsby/NAnfCLRqh1s3f1sXPVFuGKzJGsflmC/uuz3pn1Gsi0y+akOPoBbwYEl0Ap0zn1IHR3Y61izyQ/l9lXWGEIFcNl7zKaf7XD5gUSuHqxRbDVsOm64TKKIJ4RW9gS7nWpPsqdDVDQSNCbN2PuyJFLnOaTI5FSqy7ri4BmauOgnawI4AuIFnnScJhWXFYF
 9oQNqXcW
 eQJnoqYdwTl1EthZiRgegiwHAGYWq/MzBfNsGEOmj+hwSMcb1HysTrOEhAps2HR8qykXJOrgRWMnCCVnG7qwXW08n8VpG6c87zzph0V5bLfVD2AjGc7htEA3v4fc+zjZoek2ULjWoYT9OO5QnFS3pgvg8EFLfWz5JUxIk2ru4NctW21+co9GGKlC/LAs+9hVddv1NQfNg/XNsgOx2RG4Zkw34+AxPAmgaZVjf1JsSkwaYA7kZJQ84EGPCE4PxyJN9TwTe/lNtdN6/jXFi2v4r86vUhFuBfmdPD2b54z8MSagiXYHObftOTBbpPAQ6+nME5zn7Ry9NhMl8KxanHjwlaPjy5swjNdrBI+5gK/P35d50DNzPBHfzqlK5EdjcW/Hs5PRqaW6fnn8JipDisyDzdWm0B/grAA0OwqZjjXC/9dF2OOu+4ipzv9pFzprZhRv4IWOwFYIYArbC4kyuwVERF5akGxuvtR0K0vJRM1B8HhbcTP8TPCQv0dRs5O9AHt/e3HBmIhbVzVUJ86C1BT4eECvYvqTooBEBIEfRcn/TlhSU9eBkGH0LtKgHVmvXBInlEvA6XohKfMZk6kR8xJrNXoT6olnrLSWeziG5D1xH3bDbsIYfy3Nl02oAxZe7UqZrsePh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new header to declare the swap_iocb, swap_ops and swap_ctx to
allow for swap_ops implementations outside of mm/page_io.c.  This
will be used to remove the double indirection for file system-based
swap.

Note that there already is a swapops.h header, which is totally
unrelated to struct swap_ops.  The close naming is a bit unfortunate,
but I could not think of a better name for this header.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 MAINTAINERS              |  1 +
 include/linux/swap_ops.h | 39 +++++++++++++++++++++++++++++++++++++++
 mm/madvise.c             |  1 +
 mm/page_io.c             | 10 +---------
 mm/shmem.c               |  1 +
 mm/swap.h                | 23 +----------------------
 mm/swap_state.c          |  1 +
 mm/vmscan.c              |  1 +
 8 files changed, 46 insertions(+), 31 deletions(-)
 create mode 100644 include/linux/swap_ops.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5da77924c6f0..cda42b7ed945 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17240,6 +17240,7 @@ S:	Maintained
 F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
+F:	include/linux/swap_ops.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
 F:	mm/page_io.c
diff --git a/include/linux/swap_ops.h b/include/linux/swap_ops.h
new file mode 100644
index 000000000000..e92b4f532604
--- /dev/null
+++ b/include/linux/swap_ops.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _MM_SWAP_OPS_H
+#define _MM_SWAP_OPS_H
+
+#include <linux/swap.h> /* for SWAP_CLUSTER_MAX */
+
+struct swap_iocb {
+	union {
+		struct kiocb	iocb;
+		struct bio	bio;
+	};
+	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
+	int			nr_bvecs;
+	int			len;
+};
+
+struct swap_io_ctx {
+	struct swap_iocb	*sio;
+	struct swap_info_struct	*sis;
+};
+
+/*
+ * SWAP_OPS_F_REQUIRE_NOFS:
+ *	When set, all reclaim operations must operated as GFS_NOFS and not
+ *	just GFP_NOIO, as GFP_NOIO allocations could recourse into the
+ *	file system backing this swap file.
+ */
+#define SWAP_OPS_F_REQUIRE_NOFS		(1U << 0)
+
+struct swap_ops {
+	unsigned int		flags;
+
+	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
+			size_t prev_folio_size, int rw);
+	void (*submit_write)(struct swap_io_ctx *ctx);
+	void (*submit_read)(struct swap_io_ctx *ctx);
+};
+
+#endif /* _MM_SWAP_OPS_H */
diff --git a/mm/madvise.c b/mm/madvise.c
index 07a21ca31bad..c179938097bf 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/swap_ops.h>
 
 #include <asm/tlb.h>
 
diff --git a/mm/page_io.c b/mm/page_io.c
index c984a4023a65..e741e67d6592 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -25,6 +25,7 @@
 #include <linux/sched/task.h>
 #include <linux/delayacct.h>
 #include <linux/zswap.h>
+#include <linux/swap_ops.h>
 #include "swap.h"
 #include "swap_table.h"
 
@@ -300,15 +301,6 @@ static bool folio_blkg_can_merge(struct folio *folio, struct folio *prev_folio)
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
 #endif /* CONFIG_MEMCG && CONFIG_BLK_CGROUP */
 
-struct swap_iocb {
-	union {
-		struct kiocb	iocb;
-		struct bio	bio;
-	};
-	struct bio_vec		bvecs[SWAP_CLUSTER_MAX];
-	int			nr_bvecs;
-	int			len;
-};
 static mempool_t *sio_pool;
 
 int sio_pool_init(void)
diff --git a/mm/shmem.c b/mm/shmem.c
index 5071177059a9..797c42f024a0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -41,6 +41,7 @@
 #include <linux/swapfile.h>
 #include <linux/iversion.h>
 #include <linux/unicode.h>
+#include <linux/swap_ops.h>
 #include "swap.h"
 
 static struct vfsmount *shm_mnt __ro_after_init;
diff --git a/mm/swap.h b/mm/swap.h
index abd26588abd2..19ea61c97df2 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -8,6 +8,7 @@
 struct mempolicy;
 struct swap_iocb;
 struct swap_memcg_table;
+struct swap_io_ctx;
 
 #if defined(MAX_POSSIBLE_PHYSMEM_BITS)
 #define SWAP_CACHE_PFN_BITS (MAX_POSSIBLE_PHYSMEM_BITS - PAGE_SHIFT)
@@ -77,28 +78,6 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_MAX,
 };
 
-struct swap_io_ctx {
-	struct swap_iocb	*sio;
-	struct swap_info_struct	*sis;
-};
-
-/*
- * SWAP_OPS_F_REQUIRE_NOFS:
- *	When set, all reclaim operations must operated as GFS_NOFS and not
- *	just GFP_NOIO, as GFP_NOIO allocations could recourse into the
- *	file system backing this swap file.
- */
-#define SWAP_OPS_F_REQUIRE_NOFS		(1U << 0)
-
-struct swap_ops {
-	unsigned int		flags;
-
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
-	void (*submit_write)(struct swap_io_ctx *ctx);
-	void (*submit_read)(struct swap_io_ctx *ctx);
-};
-
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5be825911e64..b76eb3d876fd 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -23,6 +23,7 @@
 #include <linux/huge_mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/sysctl.h>
+#include <linux/swap_ops.h>
 #include "internal.h"
 #include "swap_table.h"
 #include "swap.h"
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e26c6931f5fd..a12eb79c89c5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -58,6 +58,7 @@
 #include <linux/random.h>
 #include <linux/mmu_notifier.h>
 #include <linux/parser.h>
+#include <linux/swap_ops.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
-- 
2.53.0


