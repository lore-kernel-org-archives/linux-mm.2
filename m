Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30408606A33C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ILCk1ZJk
Received: by kanga.kvack.org (Postfix)
	id 333796B05C6; Mon,  9 Nov 2026 13:26:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295636B05C7; Mon,  9 Nov 2026 13:26:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 136FA6B05C8; Mon,  9 Nov 2026 13:26:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C66566B05C6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:59 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26115A07C9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:59 +0000 (UTC)
X-FDA: 85416409638.12.A3490ED
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A6F6180006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ILCk1ZJk;
	spf=pass (imf06.hostedemail.com: domain of 3MxDyagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3MxDyagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSPctyA/MS0u6st/7vSe681gFMr+b88P2K2apPB5g58=;
	b=F/c2TPC1e8a6BYI7X8jkK4/sPqy6zY27T0MvZvxxK11RACXk2ZjAnrPeymtyXOXECox+0j
	UmCIQWoKw9DTJbAy/c9JFHOMKqbbJNQpQva4eb3SXY8NewiRdkfYxuC75Cz7fZRWNdffWS
	mt5bq+2ids4w+Ej8snhyx2gmQPCxVJ0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ILCk1ZJk;
	spf=pass (imf06.hostedemail.com: domain of 3MxDyagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3MxDyagYKCHojpgxxmemmejc.amkjglsv-kkitYai.mpe@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248757;
	b=stNzhEw3IhXnogTdIWKpiGRWbzhkzmi7fENt2I3aoAD+rtj6Z2GTXD9HEsgDEAwoLNcKs5
	JO0gFGpiQWLta6EBe9ujTVYMWebmlG/1po8E1lk8WmY8z8LMycxen6K4P5Cin4lIEog6/1
	j2UAc/4a4Z/9y7pjqdC8ousvleBULoE=
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c42888c50c4so110491066b.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248756; x=1794853556; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FSPctyA/MS0u6st/7vSe681gFMr+b88P2K2apPB5g58=;
        b=ILCk1ZJkcc9Y38IyBmimiSPzq0W/PXbCioushjPQJuDx3vReCusA9PZUvox+KEpWAZ
         cUHP8Yr92evTy0IGJo41mnSHYI8FwV9Xb1q3F5eWZE/5RGm35g1YzaZOvK294ipls6U1
         n5utkJfBtuAfOIv3EuwUGtCmPqKh42OLQSiRE4VMicfzSraDsy80Pj5s/b29+9zfrHz0
         wMQLhKu+2JMqq0IShkWJzCX+EqaEy50rfwxaUBPxDBBm+apkYUyOaLACwmfVDKRE4o+Y
         fQxmbVEv5hCgyK+qEfTK3sxFRI3NbTQuZwHDAae2/b4zJBSM0yv7rLUdjuipHO+B6dsD
         20Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248756; x=1794853556;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FSPctyA/MS0u6st/7vSe681gFMr+b88P2K2apPB5g58=;
        b=izEHN88z/Q/4Fom2PNiYaAk4kw0Q2zWtRxGBViQcTO4xj8HA6yXUxpIB30ewHI2AjU
         JYsY2KNz3QdkjsxnyjUBwH8EVhs8LWL55J19A1WkM5kKI/7VxhoRUVFWj+MG75yRIQol
         1EximtFfIHOLjCeB9260dM/0dUE0qH3ACS8D4jqoC47Jdd+zV9J6iYmRfibzAfr9BAc0
         pPlMGayqj92MmQNk5kL99e+BL7BMxhiN7ZNW1uzeSTRKvafuIxX0/zmDF51Qq1cnXisd
         JDsLygVClORH9EYVJddA96J0H/6x4cBNNmnXF3TrXbfceZoDRP1cJSY97aBn6CNX7Isr
         NVWg==
X-Forwarded-Encrypted: i=1; AL+hErGG1PVlU5jM/27C0r8HKX/mjB2AFSKsd2GKDoomVktqJcl3x2w5TUCIiH2FKhQmKwQ2RO55qznNSA==@kvack.org
X-Gm-Message-State: APuU4Z9HPG7LIb1MkKKh4zq5aoKfFJ4Xbx/mGsND/l9NnznJFKTIH3VR
	7OeG7d0fgfjmeFR4of9QLFYiNMpQQrvYjXq2Lb5AT+GU9/u5wgAI+cc2xuKWRtOjGSPuxMnhcQt
	qz2EIkg==
X-Received: from ejblc10.prod.google.com ([2002:a17:906:f90a:b0:c3f:a421:260c])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:3d90:b0:c40:4320:de2c
 with SMTP id a640c23a62f3a-c504951eb58mr16658666b.15.1794248755247; Mon, 09
 Nov 2026 10:25:55 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:26 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-19-lrizzo@google.com>
Subject: [RFC PATCH v2 18/25] iommu/dma: Migrate user pages into PISA for TX zerocopy
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: dcmnfjjcbe73ys6ztngqyk13ss1kwk7h
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5A6F6180006
X-HE-Tag: 1794248757-705666
X-HE-Meta: U2FsdGVkX1/pTeObZtEcNKSaFTnzZATNEg3UQV0I+vyBG3Ax92srwzq7sot7Gb+fd1w3GT0dJd0HDVjXX00GjdPDTU1vU2hCANt/7chSZ0LIhDaymmTFB9sTdRQkZDVZVpj6KjTL0K3Lj8fDFQbWtuE3C9bc7k1sACFeJA8Ny853hARBW9LQ4TQULt2XIHOjxLRjL/8bfX5NrCLDLQ5dotzpgCvJa7NbTksHn4WXVIeBfnIXZuZnB0dsiF8R4XDjUuWoBEXG78sXBbp2IxgVZwJMyDLQeBtQVWxLmmfyqHgiKzCS65g0B3TWu3JZ5JTe8WlcNsVYMYQdnurLm4ZEAY4ubowDTfWjSrMoN29rZxydXHCF345EzT9Rm9tebiH6cLVXjSOrUOZT4UtoUyM02nazsad0UCDy+QNwP/Rhn4SfHo1jndhqJCyQc+bJEJN+Cfa7wKPD2YrBAHOie83t8hPR6YVr2qhjZ06AklN+qu5FdbpFhqDvK5ilYDdD00t4BdNcawMjAoXMXhSXgxbBHB+FFNJKAVx7oURZVmbN2IynLM4HO7S1pJ0Z+mqPGYjWn3x/92/jUzx345TUC4Ao9HVAujYvV3OVUOx9YqxmJ0uzPJgeRj9YZ8Iv0aX73HxWidKznWHca+gRfSQWztuYEuEZfBh3D9ZET91qzZDH6Fke/Z1xPsoQqUXCeRBfzz8kPp5yvXO8c83yF/2xTrF4q6ImGrC4aM1s8LBJ3/NTWuYIBvri/0gaz6tzFft7YjmBzn4IcLw0FPm1FtIomId0EW/q/7S4VsCxk9ZrHnDVcOG0N5Xrt//pjTxFotMJZ+Ijozcvssb0RX2Xug2hNNMy4bLHSMqNmOc+FoWP7oLb4ym9rZbvFFP7w7oqUOtVtO64HkctJPWi1zYuwomWkFVr7Dl8GBmufMf6f/NKI6OOM6WHdPIcwXQpI0StPcgSbkV/2PO0q5Q+0JrOge9+1ul
 Erbgo/Am
 s2UMkIyawQElW0/Mne/5QAHl824GDcGjX6Y+kSyKSeD5OBhGv6sGhkBUrnZ82vSPU3fOjm5Y0sBwMpKJwYBqM59kLGnsBKbMzE4PgZbT3HKcSh6GxWneYlDGR+X2HimmW4/gsPf/wppOIJRpNFg6v0wL0YoVPegugBMaB9L7JC/7IB8DipOAzaifOODlqc814WczGZWW4Cdzh+vK4kD25JAJ9Y0tl61KF4iz7riVCPINWMb5IWbqGF75PwUjEpFgb2u5PFAzlbKR6/MMINslI1fbam6Ouyp7mBgAq3GFJ5ztxjDWWiOjw30XJSnj6WE12Vb5Tb8oEwf6I371SBdmtzdnqVGCkTnZxIEnYkFvvIBz7HhwAS3v60MSF8LAOUECuRUw4Feed9R49e59Bv6cJSzib+VknB1C5/1z27asl7Hm3c47GczWel71rk25gaBcMVFEk35yaAfMzURvExA6cq/aBbhTgtaPI85pOaYolKrtTjiGnLJ92LDCGZljqiReL6UIrAgtuHTtnBPEfYe8PHrhknU7YszC7kj3pTXK+GPQBhLSYeAdwKXLLudN8XcWe6a1tkQCL47iJx2MfGoVxf1dUwHwx/VVjzYD2gCetkEPXz7Yaqn4+q3f1aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

MSG_ZEROCOPY sends map each user page with a per-buffer IOMMU mapping
and IOTLB flush. Moving user TX buffers into PISA blocks once allows
subsequent zerocopy sends to reuse pre-mapped 2MB IOMMU entries.

Add drivers/iommu/pisa-user.c to migrate private anonymous order-0 user
pages into per-node DMA_TO_DEVICE PISA allocators, controlled by
pisa.user_max_4K_pages (0 = disabled):
- Explicit migration via madvise(MADV_PISA) and MADV_NOPISA (also
  supported via process_madvise()).
- Automatic best-effort migration on MSG_ZEROCOPY sends in
  zerocopy_fill_skb_from_iter() when the egress device has pisa_tx_bufs
  enabled. For TCP, pages that cannot be migrated fall back to the
  regular copy path into PISA TX page_frags.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Makefile                 |   2 +-
 drivers/iommu/pisa-alloc.c             |   2 +
 drivers/iommu/pisa-priv.h              |   2 +
 drivers/iommu/pisa-user.c              | 278 +++++++++++++++++++++++++
 include/linux/pisa.h                   |  28 +++
 include/linux/swap.h                   |   1 +
 include/uapi/asm-generic/mman-common.h |   2 +
 mm/madvise.c                           |  11 +
 net/core/datagram.c                    |  82 +++++++-
 net/core/skbuff.c                      |   3 +-
 net/ipv4/tcp.c                         |  12 +-
 11 files changed, 416 insertions(+), 7 deletions(-)
 create mode 100644 drivers/iommu/pisa-user.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 125cf7e813cdc..cd14f80a594a7 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
-obj-$(CONFIG_PISA) += pisa-meta.o pisa-alloc.o pisa-node.o
+obj-$(CONFIG_PISA) += pisa-meta.o pisa-alloc.o pisa-node.o pisa-user.o
 ifeq ($(CONFIG_IOMMU_DMA),y)
 obj-$(CONFIG_PISA) += pisa-map.o
 endif
diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index 7df2ecde32916..1930135880d2b 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -1756,6 +1756,8 @@ static int __init pisa_init(void)
 		}
 	}
 
+	pisa_user_boot_enable();
+
 	/* Dedicated WQ_MEM_RECLAIM workqueue so reclaim never blocks behind system_wq. */
 	pisa_wq = alloc_workqueue("pisa", WQ_MEM_RECLAIM, 0);
 	if (!pisa_wq)
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
index ef3abb1db9049..fe1bff0bba322 100644
--- a/drivers/iommu/pisa-priv.h
+++ b/drivers/iommu/pisa-priv.h
@@ -185,6 +185,7 @@ static inline long pisa_alloc_held_pages(const struct pisa_alloc *pa)
 struct pisa_node {
 	unsigned long		next_alloc;	/* atomic alloc backoff jiffies */
 	struct pisa_alloc	*pa[2][PISA_ORDER + 1]; /* [0]=RW, [1]=RO by order */
+	struct pisa_alloc	*user_pa;	/* user page migration pa */
 
 	spinlock_t		lock;		/* protects @pages and @nr_pages */
 	struct list_head	pages;		/* reservoir */
@@ -278,6 +279,7 @@ void pisa_schedule_scrub_all(void);
 struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool decrypt, bool *clean);
 unsigned long pisa_reservoir_count(void);
 unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
+void pisa_user_boot_enable(void);
 
 #endif /* CONFIG_PISA */
 
diff --git a/drivers/iommu/pisa-user.c b/drivers/iommu/pisa-user.c
new file mode 100644
index 0000000000000..a16909d429aca
--- /dev/null
+++ b/drivers/iommu/pisa-user.c
@@ -0,0 +1,278 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA user and page-cache folios: allocate or migrate order-0 folios into
+ * per-node PISA allocators so zero-copy TX and block I/O use 2MB IOMMU mappings.
+ * Disabled on CoCo guests (user PTEs map pages encrypted).
+ */
+#include <linux/cc_platform.h>
+#include <linux/pisa.h>
+#include <linux/gfp.h>
+#include <linux/migrate.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/nodemask.h>
+#include <linux/pagewalk.h>
+#include <linux/swap.h>
+
+#include "pisa-priv.h"
+
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "pisa."
+
+/* Soft cap on 4KB user pages held in PISA blocks (0 = disabled). */
+static unsigned long pisa_user_max_4k_pages __read_mostly;
+DEFINE_STATIC_KEY_FALSE(pisa_user_key);
+
+static bool pisa_user_init(void);
+
+static int pisa_user_max_set(const char *val, const struct kernel_param *kp)
+{
+	unsigned long max_pages;
+	int ret;
+
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		return -EOPNOTSUPP;
+	ret = kstrtoul(val, 0, &max_pages);
+	if (ret)
+		return ret;
+	WRITE_ONCE(pisa_user_max_4k_pages, max_pages);
+	if (max_pages) {
+		if (!pisa_nodes[first_memory_node].pa[0][0])
+			return 0;
+		if (!pisa_user_init())
+			return -ENOMEM;
+		static_branch_enable(&pisa_user_key);
+	} else {
+		static_branch_disable(&pisa_user_key);
+	}
+	return 0;
+}
+
+static const struct kernel_param_ops pisa_user_max_ops = {
+	.set = pisa_user_max_set,
+	.get = param_get_ulong,
+};
+module_param_cb(user_max_4K_pages, &pisa_user_max_ops, &pisa_user_max_4k_pages, 0644);
+
+/* True once per-node user allocators have been allocated, serialized by pisa_user_lock. */
+static bool pisa_user_ready __read_mostly;
+static DEFINE_MUTEX(pisa_user_lock);
+
+/* Lazily create per-node user allocators on first use (process context). */
+static bool pisa_user_init(void)
+{
+	int nid;
+
+	if (!READ_ONCE(pisa_user_max_4k_pages) || cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		return false;
+	/* Pairs with smp_store_release() below: the allocators are visible. */
+	if (smp_load_acquire(&pisa_user_ready))
+		return true;
+	if (pisa_meta_init())
+		return false;
+	mutex_lock(&pisa_user_lock);
+	for_each_node_state(nid, N_MEMORY) {
+		if (!pisa_nodes[nid].user_pa)
+			pisa_nodes[nid].user_pa = pisa_create(nid, 0, DMA_TO_DEVICE);
+		if (!pisa_nodes[nid].user_pa)
+			goto out;	/* retried on the next call */
+	}
+	/* Publish pisa_nodes[].user_pa to lockless readers. */
+	smp_store_release(&pisa_user_ready, true);
+out:
+	mutex_unlock(&pisa_user_lock);
+	return pisa_user_ready;
+}
+
+void pisa_user_boot_enable(void)
+{
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		WRITE_ONCE(pisa_user_max_4k_pages, 0);
+		return;
+	}
+	if (READ_ONCE(pisa_user_max_4k_pages) && pisa_user_init())
+		static_branch_enable(&pisa_user_key);
+}
+
+/* User pages currently held in PISA blocks. */
+static unsigned long pisa_user_in_use(void)
+{
+	unsigned long used = 0;
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		const struct pisa_alloc *pa = pisa_nodes[nid].user_pa;
+
+		used += pa ? READ_ONCE(pa->blocks_in_use) : 0;
+	}
+	return used;
+}
+
+/* Pages that can still be moved in before reaching pisa.user_max_4K_pages. */
+static long pisa_user_budget(void)
+{
+	return (long)(READ_ONCE(pisa_user_max_4k_pages) - pisa_user_in_use());
+}
+
+/* Is @folio worth moving into (@to_pisa) or out of PISA memory? */
+static bool pisa_user_want(struct folio *folio, bool to_pisa)
+{
+	if (!folio_test_anon(folio) || folio_is_zone_device(folio) ||
+	    folio_test_ksm(folio) || folio_test_large(folio) ||
+	    folio_maybe_mapped_shared(folio))
+		return false;
+	return is_pisa_pfn(folio_pfn(folio)) != to_pisa;
+}
+
+/* Return true if @folio has references beyond its mappings, swap cache, and @extra. */
+static bool pisa_user_busy(struct folio *folio, int extra)
+{
+	return folio_ref_count(folio) > folio_expected_ref_count(folio) + extra;
+}
+
+struct pisa_user_mtc {
+	gfp_t	gfp;
+	long	budget;
+};
+
+/* new_folio_t for migration into PISA memory. */
+static struct folio *pisa_user_new_folio(struct folio *src, unsigned long private)
+{
+	struct pisa_user_mtc *mtc = (void *)private;
+	int nid = folio_nid(src);
+	struct page *page;
+
+	if (mtc->budget <= 0)
+		return NULL;
+	page = pisa_alloc(pisa_nodes[nid].user_pa, mtc->gfp);
+	if (!page)
+		return NULL;
+	if (pisa_meta_of_pfn(page_to_pfn(page))->flags & PISA_DECRYPTED) {
+		put_page(page);
+		mtc->budget = 0;
+		return NULL;
+	}
+	mtc->budget--;
+	return page_folio(page);
+}
+
+/* new_folio_t for migration out of PISA memory: allocators never serve these. */
+static struct folio *pisa_user_old_folio(struct folio *src, unsigned long private)
+{
+	return __folio_alloc_node(GFP_HIGHUSER_MOVABLE | __GFP_NOWARN, 0, folio_nid(src));
+}
+
+/* Migrate the isolated folios on @list; failures are put back. */
+static void pisa_user_migrate(struct list_head *list, bool to_pisa, gfp_t gfp)
+{
+	struct pisa_user_mtc mtc = { .gfp = gfp, .budget = LONG_MAX };
+	enum migrate_mode mode = MIGRATE_SYNC;
+
+	if (list_empty(list))
+		return;
+	if (to_pisa) {
+		mtc.budget = pisa_user_budget();
+		if (!gfpflags_allow_blocking(gfp))
+			mode = MIGRATE_ASYNC;
+	}
+	if (migrate_pages(list, to_pisa ? pisa_user_new_folio : pisa_user_old_folio,
+			  NULL, (unsigned long)&mtc, mode, MR_SYSCALL, NULL))
+		putback_movable_pages(list);
+}
+
+/**
+ * pisa_upgrade_user_pages - Try to move user pages about to be sent into PISA
+ * @pages: Pages from iov_iter_get_pages2(), one reference each
+ * @nr: Number of entries in @pages
+ *
+ * Best effort, process context. Pages that cannot be moved (e.g. still
+ * referenced by an in-flight skb, or in a large folio) are skipped; for TCP
+ * with pisa_tx_bufs enabled the caller copies them instead.
+ *
+ * Return: false if nothing was attempted and the references are untouched;
+ * true if all references were dropped and the caller must look the pages up
+ * again.
+ */
+bool pisa_upgrade_user_pages(struct page **pages, unsigned int nr)
+{
+	bool drained = false;
+	LIST_HEAD(list);
+	unsigned int i, want = 0;
+
+	if (!pisa_user_init())
+		return false;
+	/* Common case: all pages already in PISA, no budget check needed. */
+	for (i = 0; i < nr; i++)
+		want += pisa_user_want(page_folio(pages[i]), true);
+	if (!want)
+		return false;
+	if (pisa_user_budget() <= 0)
+		return false;
+	for (i = 0; i < nr; i++) {
+		struct folio *folio = page_folio(pages[i]);
+
+		if (!pisa_user_want(folio, true))
+			continue;
+		/* A freshly faulted page may still sit in a per-CPU LRU batch. */
+		if (!drained && !folio_test_lru(folio)) {
+			lru_add_drain();
+			drained = true;
+		}
+		/* The reference from iov_iter_get_pages2() is expected. */
+		if (pisa_user_busy(folio, 1))
+			continue;
+		isolate_folio_to_list(folio, &list);
+	}
+	if (list_empty(&list))
+		return false;
+	/* Migration fails on pages with references it does not expect. */
+	for (i = 0; i < nr; i++)
+		put_page(pages[i]);
+	pisa_user_migrate(&list, true,
+			  GFP_NOWAIT | __GFP_HARDWALL | __GFP_NOWARN);
+	return true;
+}
+
+#define PISA_USER_BATCH	512
+
+/**
+ * pisa_madvise - MADV_PISA / MADV_NOPISA on [@start, @end) of @vma
+ * @vma: VMA, with the mmap lock held for reading
+ * @start: Start address
+ * @end: End address
+ * @to_pisa: true to move present pages into PISA, false to move them out
+ *
+ * Return: 0, -EINVAL for unsupported mappings, or -EOPNOTSUPP if disabled.
+ */
+int pisa_madvise(struct vm_area_struct *vma, unsigned long start, unsigned long end, bool to_pisa)
+{
+	gfp_t gfp = GFP_USER | __GFP_NOWARN;
+	struct folio_walk fw;
+	unsigned long addr;
+	unsigned int n = 0;
+	LIST_HEAD(list);
+
+	if (vma->vm_flags & (VM_SHARED | VM_IO | VM_PFNMAP | VM_HUGETLB))
+		return -EINVAL;
+	if (to_pisa && !pisa_user_init())
+		return -EOPNOTSUPP;
+	lru_add_drain();
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		struct folio *folio = folio_walk_start(&fw, vma, addr, 0);
+
+		if (folio) {
+			if (pisa_user_want(folio, to_pisa) && !pisa_user_busy(folio, 0) &&
+			    isolate_folio_to_list(folio, &list))
+				n++;
+			folio_walk_end(&fw, vma);
+		}
+		if (n == PISA_USER_BATCH) {
+			pisa_user_migrate(&list, to_pisa, gfp);
+			n = 0;
+		}
+		cond_resched();
+	}
+	pisa_user_migrate(&list, to_pisa, gfp);
+	return 0;
+}
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 452b8fa20c8d7..d11fd3d663dc1 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -132,6 +132,18 @@ static inline void pisa_task_frag_release(struct task_struct *tsk)
 		put_page(tsk->task_frag_pisa.page);
 }
 
+/* User pages in PISA blocks, see drivers/iommu/pisa-user.c */
+DECLARE_STATIC_KEY_FALSE(pisa_user_key);
+bool pisa_upgrade_user_pages(struct page **pages, unsigned int nr);
+int pisa_madvise(struct vm_area_struct *vma, unsigned long start,
+		 unsigned long end, bool to_pisa);
+
+/* Is pisa.user_max_4K_pages non-zero? */
+static inline bool pisa_user_enabled(void)
+{
+	return static_branch_unlikely(&pisa_user_key);
+}
+
 #else /* !CONFIG_PISA */
 
 static inline int pisa_meta_init(void)
@@ -213,6 +225,22 @@ static inline void pisa_task_frag_release(struct task_struct *tsk)
 {
 }
 
+static inline bool pisa_user_enabled(void)
+{
+	return false;
+}
+
+static inline bool pisa_upgrade_user_pages(struct page **pages, unsigned int nr)
+{
+	return false;
+}
+
+static inline int pisa_madvise(struct vm_area_struct *vma, unsigned long start,
+			       unsigned long end, bool to_pisa)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_PISA */
 
 static inline struct page *
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f686709d71f0..3736786ccc5a3 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -314,6 +314,7 @@ extern unsigned long totalreserve_pages;
 /* linux/mm/folio.c */
 void folio_add_lru(struct folio *folio);
 void folio_mark_accessed(struct folio *folio);
+void lru_add_drain(void);
 void lru_add_drain_all(void);
 
 enum lru_cache_drained {
diff --git a/include/uapi/asm-generic/mman-common.h b/include/uapi/asm-generic/mman-common.h
index ef1c27fa3c570..c4332db8e56ff 100644
--- a/include/uapi/asm-generic/mman-common.h
+++ b/include/uapi/asm-generic/mman-common.h
@@ -81,6 +81,8 @@
 
 #define MADV_GUARD_INSTALL 102		/* fatal signal on access to range */
 #define MADV_GUARD_REMOVE 103		/* unguard range */
+#define MADV_PISA		210	/* move pages into PISA memory */
+#define MADV_NOPISA		211	/* move pages out of PISA memory */
 
 /* compatibility flags */
 #define MAP_FILE	0
diff --git a/mm/madvise.c b/mm/madvise.c
index 0214efd2a014f..0eccb44594b04 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -6,6 +6,7 @@
  * Copyright (C) 2002  Christoph Hellwig
  */
 
+#include <linux/pisa.h>
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 #include <linux/syscalls.h>
@@ -1393,6 +1394,9 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		return madvise_guard_install(madv_behavior);
 	case MADV_GUARD_REMOVE:
 		return madvise_guard_remove(madv_behavior);
+	case MADV_PISA:
+	case MADV_NOPISA:
+		return pisa_madvise(vma, range->start, range->end, behavior == MADV_PISA);
 
 	/* The below behaviours update VMAs via madvise_update_vma(). */
 
@@ -1582,6 +1586,9 @@ madvise_behavior_valid(int behavior)
 	case MADV_HWPOISON:
 #endif
 		return true;
+	case MADV_PISA:
+	case MADV_NOPISA:
+		return IS_ENABLED(CONFIG_PISA);
 
 	default:
 		return false;
@@ -1596,6 +1603,8 @@ static bool process_madvise_remote_valid(int behavior)
 	case MADV_PAGEOUT:
 	case MADV_WILLNEED:
 	case MADV_COLLAPSE:
+	case MADV_PISA:
+	case MADV_NOPISA:
 		return true;
 	default:
 		return false;
@@ -1782,6 +1791,8 @@ static enum madvise_lock_mode get_lock_mode(struct madvise_behavior *madv_behavi
 	case MADV_POPULATE_READ:
 	case MADV_POPULATE_WRITE:
 	case MADV_COLLAPSE:
+	case MADV_PISA:
+	case MADV_NOPISA:
 		return MADVISE_MMAP_READ_LOCK;
 	case MADV_GUARD_INSTALL:
 	case MADV_GUARD_REMOVE:
diff --git a/net/core/datagram.c b/net/core/datagram.c
index ecc30a6f83023..40f20d0faa859 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -39,6 +39,7 @@
 #include <linux/kernel.h>
 #include <linux/uaccess.h>
 #include <linux/mm.h>
+#include <linux/pisa.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
 #include <linux/sched.h>
@@ -632,10 +633,74 @@ int skb_copy_datagram_from_iter_full(struct sk_buff *skb, int offset,
 }
 EXPORT_SYMBOL(skb_copy_datagram_from_iter_full);
 
-int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
-				struct iov_iter *from, size_t length)
+/*
+ * Upgrade user @pages to PISA memory and, for TCP over a pisa_tx_bufs device,
+ * trim non-PISA trailing pages from the batch.
+ *
+ * Return: false to proceed with attaching *@copied bytes from @pages to @skb,
+ * or true to stop and make the caller return *@ret.
+ */
+static bool pisa_zc_iter(int *ret, struct sk_buff *skb, struct iov_iter *from, size_t *length,
+			 const struct sock *sk, struct page **pages, int max_pages,
+			 unsigned int orig_len, size_t *start, ssize_t *copied)
+{
+	unsigned int i, nr;
+	ssize_t keep;
+
+	if (!pisa_user_enabled() || !user_backed_iter(from))
+		return false;
+
+	/* Move user pages into PISA memory, then look them up again. */
+	if (pisa_upgrade_user_pages(pages, DIV_ROUND_UP(*start + *copied, PAGE_SIZE))) {
+		iov_iter_revert(from, *copied);
+		*copied = iov_iter_get_pages2(from, pages, *length, max_pages, start);
+		if (*copied < 0) {
+			*ret = -EFAULT;
+			return true;
+		}
+	}
+
+	/* Only TCP (which sets skb->sk at transmit time) handles short appends/-EXDEV. */
+	if (!sk || skb->sk)
+		return false;
+
+	/* Only plain MSG_ZEROCOPY ubufs (not io_uring/vhost/devmem). */
+	if (skb_zcopy(skb) && skb_zcopy(skb)->ops != &msg_zerocopy_ubuf_ops)
+		return false;
+
+	/* Egress device must have pisa_tx_bufs enabled so the copy uses a PISA page_frag. */
+	if (!dst_tx_pisa_ok(__sk_dst_get(sk)))
+		return false;
+
+	/*
+	 * Trim @from to the leading pages that are in PISA memory: drop the
+	 * references to the others, give their bytes back to @from, and cap
+	 * *@length so that the caller ends after attaching what is left.
+	 */
+	nr = DIV_ROUND_UP(*start + *copied, PAGE_SIZE);
+	for (i = 0; i < nr && is_pisa_page(pages[i]); i++)
+		;
+	if (i == nr)
+		return false;
+
+	keep = i ? i * PAGE_SIZE - *start : 0;
+	while (nr > i)
+		put_page(pages[--nr]);
+	iov_iter_revert(from, *copied - keep);
+	*copied = keep;
+	*length = keep;
+	if (keep)
+		return false;
+
+	*ret = (skb->len != orig_len) ? 0 : -EXDEV;
+	return true;
+}
+
+static int __zerocopy_fill_skb_from_iter(struct sk_buff *skb, struct iov_iter *from,
+					 size_t length, const struct sock *sk)
 {
 	int frag = skb_shinfo(skb)->nr_frags;
+	unsigned int orig_len = skb->len;
 
 	if (!skb_frags_readable(skb))
 		return -EFAULT;
@@ -643,7 +708,7 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 	while (length && iov_iter_count(from)) {
 		struct page *head, *last_head = NULL;
 		struct page *pages[MAX_SKB_FRAGS];
-		int refs, order, n = 0;
+		int refs, order, n = 0, ret;
 		size_t start;
 		ssize_t copied;
 
@@ -654,6 +719,9 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 					    MAX_SKB_FRAGS - frag, &start);
 		if (copied < 0)
 			return -EFAULT;
+		if (pisa_zc_iter(&ret, skb, from, &length, sk, pages,
+				 MAX_SKB_FRAGS - frag, orig_len, &start, &copied))
+			return ret;
 
 		length -= copied;
 
@@ -703,6 +771,12 @@ int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
 	return 0;
 }
 
+int zerocopy_fill_skb_from_iter(struct sk_buff *skb,
+				struct iov_iter *from, size_t length)
+{
+	return __zerocopy_fill_skb_from_iter(skb, from, length, NULL);
+}
+
 static int
 zerocopy_fill_skb_from_devmem(struct sk_buff *skb, struct iov_iter *from,
 			      int length,
@@ -760,7 +834,7 @@ int __zerocopy_sg_from_iter(struct msghdr *msg, struct sock *sk,
 	else if (binding)
 		ret = zerocopy_fill_skb_from_devmem(skb, from, length, binding);
 	else
-		ret = zerocopy_fill_skb_from_iter(skb, from, length);
+		ret = __zerocopy_fill_skb_from_iter(skb, from, length, sk);
 
 	truesize = skb->truesize - orig_size;
 	if (sk && sk->sk_type == SOCK_STREAM) {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 04ae3bb4bd905..739d09615638c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1935,7 +1935,8 @@ int skb_zerocopy_iter_stream(struct sock *sk, struct sk_buff *skb,
 
 	err = __zerocopy_sg_from_iter(msg, sk, skb, &msg->msg_iter, len,
 				      binding);
-	if (err == -EFAULT || (err == -EMSGSIZE && skb->len == orig_len)) {
+	if (err == -EFAULT ||
+	    ((err == -EMSGSIZE || err == -EXDEV) && skb->len == orig_len)) {
 		struct sock *save_sk = skb->sk;
 
 		/* Streams do not free skb on error. Reset to prev state. */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 038063717951c..9214d6213cae5 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1128,6 +1128,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 	int process_backlog = 0;
 	int sockc_err = 0;
 	int zc = 0;
+	bool must_copy = false;	/* copy the next chunk of a MSG_ZEROCOPY send */
 	long timeo;
 
 	flags = msg->msg_flags;
@@ -1289,7 +1290,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 		if (copy > msg_data_left(msg))
 			copy = msg_data_left(msg);
 
-		if (zc == 0) {
+		if (zc == 0 || unlikely(must_copy)) {
 			const struct dst_entry *dst = __sk_dst_get(sk);
 			bool merge = true;
 			int i = skb_shinfo(skb)->nr_frags;
@@ -1335,6 +1336,7 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				page_ref_inc(pfrag->page);
 			}
 			pfrag->offset += copy;
+			must_copy = false;
 		} else if (zc == MSG_ZEROCOPY)  {
 			/* First append to a fragless skb builds initial
 			 * pure zerocopy skb
@@ -1354,6 +1356,14 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
 				tcp_mark_push(tp, skb);
 				goto new_segment;
 			}
+			/*
+			 * The next user page is not in PISA memory: copy this
+			 * chunk, without reporting SO_EE_CODE_ZEROCOPY_COPIED.
+			 */
+			if (unlikely(err == -EXDEV)) {
+				must_copy = true;
+				continue;
+			}
 			if (err < 0)
 				goto do_error;
 			copy = err;
-- 
2.56.0.542.g3ef89b7020-goog


