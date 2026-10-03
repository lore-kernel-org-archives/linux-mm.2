Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A475CA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE70C6B009B; Sat,  3 Oct 2026 17:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFBD6B009D; Sat,  3 Oct 2026 17:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5FDD6B009E; Sat,  3 Oct 2026 17:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 99E446B009B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:22:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 247EFA0A11
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:59 +0000 (UTC)
X-FDA: 85282590078.20.38C9CBB
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D580160004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q1ulcyqT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3L3LBagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3L3LBagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062577;
	b=l3+BCm4amZ3dlFXehQwGSpykeXf33D+IGIzooBRK1KPJvGFK8/hby3sCgdSWsIqnudwtWK
	pT1wiVbzafspgLUQFD68z4msHAT5LrK9vFqtyUQA7l2fhHlWR8G6GOgLfINADfy+SSRXic
	ToRYnYRlSzzZI4JFPEMY6RLcPn+uVi0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Q1ulcyqT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3L3LBagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com designates 209.85.208.70 as permitted sender) smtp.mailfrom=3L3LBagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FsJnhDNmZ9yZ7GqWC0EkiUiITFru0jUY2fS0nDM/wgE=;
	b=m30a0Hpj4cDfykTdpvPN8ired+9PBwKr8pAoZcZO3205aE5MnC0OEBPZ6/s7R6ccq8Dc8E
	Nz+X8gGa3KUZ9r/myUmk51XtZq4b9dSFcSgsNwCoAQUmvfgVFOsLcPP5M5h7L2eZoYUlTy
	s8cwWhvcbuqkjYVAxh6Wz828WpCLvVY=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6a99c6e4d78so697804a12.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062576; x=1791667376; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FsJnhDNmZ9yZ7GqWC0EkiUiITFru0jUY2fS0nDM/wgE=;
        b=Q1ulcyqTphzaRwiJLnJ6PjEZHbU0KCrHme7PypS6Yiq1rnrX55/z75hpWyMI/I9VKS
         eHIIpy5V9nzWIJpif6ad3Dqi8nRKZJXcJzR+2m7+0z5PiywQj2gdh6TYlUnhWhHYR1c4
         eXczed8BtnNeHBV6wkwTFNgcVdN5mh+4kaPyHDw9Zr1K/E4PgP1pO2OzWFdTfBTKimCh
         dYFsCrV2Ev4uwYyukELuL+uMh1b9cvZiNdzl06iSJJnxAF0t+EurXXWDv6AANcJnUQND
         wNv7szjEK73Rjm1HaqVmL96gc7qC/eAOBCOvbMHI1CdFH24foGHNpoxWotgC6g+3SOWY
         Se5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062576; x=1791667376;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FsJnhDNmZ9yZ7GqWC0EkiUiITFru0jUY2fS0nDM/wgE=;
        b=dZ3F90YM32Z8JATAPPceZ+T6c5qj5RXm7ozscWKmjMojCmOYg57oV2WaQGJhtF5n27
         jmumvYZtsjCQ+BnxBsNqc3rH3+2RbHaD3qv+ll6qyJk4qEIWU6uBQsQu+4zS2/6qBY64
         xU/94zosFT2zu1gMoOEUmXs7sdXX3RwnaJB2sDhqThnJVcTq5ixctKMMRtbYUsNn0Xe1
         9XTwAxpY5HvRtxav8xaeqUqO+s8uukqcEMUHvb4M9ZzOJv/jShJZM3j7YPUx9N1xpnfT
         jVLAww/5JSoQklMYGQU827TfPFE51cnhPSlC6+2rDFrImTpyQbkD9JopTaGXnKC8mEtX
         yRFw==
X-Forwarded-Encrypted: i=1; AKwUvBxZ/EIRgnSDuBWqZXIkoAsiVt1ZDHmdOKF+A+IGqF1E+o9b7TXKitcbPqfGJkc1sRycIMrBPuWSkA==@kvack.org
X-Gm-Message-State: AFq9FYInQ5g/+8ywJSi+6ekducsukUG1k7Hib72n3Mdke7LI3pyVhEBQ
	phDoEDbqlQMVLGRXkstML67sIaauP9DWpzclNazj1Ax/LPOdl2BLGBvugFm/DKWrCg51fapuLlY
	wXQcVRQ==
X-Received: from edv14.prod.google.com ([2002:a05:6402:15ce:b0:6ae:2343:be61])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:a0ca:b0:6ab:e30:c9a0
 with SMTP id 4fb4d7f45d1cf-6af9e2e5f80mr4881876a12.13.1791062575586; Sat, 03
 Oct 2026 14:22:55 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:26 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-8-lrizzo@google.com>
Subject: [RFC: DMA_PMD 07/22] iommu/dma: release DMA_PMD domain mappings on
 domain teardown
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
X-Stat-Signature: owytcxd5kxp3wergqgk5t3fca5o8f8qw
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D580160004
X-HE-Tag: 1791062577-775203
X-HE-Meta: U2FsdGVkX18r9sQB3+AmdWnV+W/e6ANYJYEg99M9i15Y91i7y1PXRENDpSbxIWKFMgFgh6sgX4wmpMCiqhQgM8u/t/KBWHRfNubtpDaohDy29mmeojomlQYj6nNM4fwFEkU6g4iRfRPNTjn/AwjvcmHj+tZ9XljWJprBG5lvRnpayhpKq2dJx0Hlb8/kFN9+Kl0c5pZU3y6RoOROndVLo6umUI9u1LHHYlT0AhL26Q0A6EG5V4KOcPzd7Hq0dvSVNVFndeWmISfpHOn91ktTu6pnKy3fOXFuxjGm1c3rwIgiruBZ3wUUFcA6AWRlsdDjO6XPp2QO1dqaeFMoSjhAKTZ+FrC3H30379hZjSLEKf4lG9ayouG+sDRCzv04fnS4WCYu3PPTC2MxZV3zSLF2H2m+TcC7mPXnXBN257RuFMiktiKA2AT6BXgAEgKD/NxWDqIZMjPuwEnZddGGZhVUVLQYKFJ2OqIq8fnpHae/sZ1YzmGWblE9bQbXHqOBD5TO0l0kjXsYdc8FHhKdZZ/qojwmbvzT2SwTZELKDldhR5ipldwldJKp1yBihKBqf5HA5FTIZvzy/PIj/rH1Noo5aYHOSv0kvuEfSoo46Jmcr1JePexINx2w3fw1h5hmPc6Wmewp6OYtpX8Qp1bDwCTy5D6H72KrnHHGpeBjzNw06OCh7yxfeu/R2fm884fc4qFiq7tPPZa80UaPp4peRRjhA5qhbx0N9XgS2eTRFuBOw71KusNVwiox2VY1olNKiv7CMeW7ZsK3ZWV/j4Jcxpj2ErPKwbrjgxySAGpMIb/XfhZM++RzcIwxR/+PX4iA777tp0lYN4fgP1iJbp/E4rYK8AVt7ZR787SsxTujTo5bi/uLSFj0FTrJAy2PcBn/X3IO9/NoMdvYhaT+kY1j1c1Fyg1QiAXvocCUVatBzokzIDEnuLfOsGBkHYanI59c4Fk7GinF/CtHzwqX4xtk1kx
 IoIENIPo
 /xv5p1pGs7eE1mgi2PvVT3Svff93nHMteDhEgimHvdtJoIEa7HoLdQWNIiqdt7Cw7hL3eMp2yZgiAW1j/wutMbIxGVUATWEDq+k4j1pl83kTS7+2ooRzw+NATKqFV+cJXohZHXhSJefIXsXORR9op6/3yM9b0rTg02zpiJd19Fs831DXwHRQt/qFz5sEYQhv85IIvfswwhXYGK7alQcftRn1Fv7+LXBuXQQVu/VfQDZAzxPV1fNxcorpc9s35golHbqlmfxBeGhYKb7EyTdP+yYiV7eTN6tMuaI7e6/n2luaEaQbDXqZDN+PV+2fimqCN6fbPh1RiKm8/Trz94RtwRYX86fs5IHqAkOuyqExkDoxDQxQfOzcU0GJZusqdaM3/X9UjJqnDyk2aulZoXqbyhn+CBab+XIH9dcb3VD2UrbSXGMQiVAP4WtRmLW1+fcaN1j552uQnZjoCKT1RPnK9b9t/iLzUc6XzLYkNn0tuf2yQO2x1fgyv2wVsz0V/6TbseXp8gGZwvsfZXjgqbIgXepaNiQ89Hpq3Pxvyxv05K+bBvPvLgSozWjJTneHsfyFKfCYh4TrNZfH2RP1SqpGvg9BBG/+mDfYTmigBu/iO+G7F+ip97LRp3X7VFRggVTkNqhEa8lJN9zJGt2QWhBUsPi9VHbT2UOE0uyzu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track per-domain PMD_SIZE leaf PTE presence in a 64-entry domain registry
(dma_pmd_domains[]) and a per-PMD-page bitmask (p2m->domains_mapped),
unmapping active domains in dma_pmd_unmap_all() when a DMA_PMD page is
retired.

When an IOMMU DMA domain is torn down at runtime (for example across
VFIO bind/unbind or Dynamic Memory Security domain switches), its page
tables and IOVA domain are freed by the caller, but DMA_PMD pages that were
mapped into it may outlive the domain in per-queue or per-CPU pools.

Add dma_pmd_domain_release() and call it from iommu_put_dma_cookie()
before freeing the cookie:
- Clear the domain's slot in dma_pmd_domains[] and mark it draining so
  a racing dma_pmd_unmap_all() skips the dying domain instead of
  calling iommu_unmap() on freed page tables.
- Walk all live pools (including destroyed pools that still hold
  in-flight DMA_PMD pages via pool->refcount) and clear the domain's bit in
  every p2m->domains_mapped bitmap via dma_pmd_forget_domain().
- Flush dma_pmd_reclaim_work and wait on dma_pmd_srcu so any in-flight
  unmapper finishes before the domain index is released for reuse.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Makefile        |   2 +-
 drivers/iommu/dma-iommu.c     |   6 +
 drivers/iommu/dma-pmd-kunit.c |   8 ++
 drivers/iommu/dma-pmd-map.c   | 220 ++++++++++++++++++++++++++++++++++
 drivers/iommu/dma-pmd-pool.c  |  59 ++++++---
 drivers/iommu/dma-pmd-priv.h  |  34 ++++++
 6 files changed, 314 insertions(+), 15 deletions(-)
 create mode 100644 drivers/iommu/dma-pmd-map.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index de2c3bad9aa3e..e701b36b9b605 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -11,7 +11,7 @@ obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
-obj-$(CONFIG_DMA_PMD) += dma-pmd-meta.o dma-pmd-pool.o
+obj-$(CONFIG_DMA_PMD) += dma-pmd-meta.o dma-pmd-pool.o dma-pmd-map.o
 obj-$(CONFIG_DMA_PMD_META_KUNIT_TEST) += dma-pmd-kunit.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 70aee7a3020c8..ee14175b79bc2 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -430,6 +430,12 @@ void iommu_put_dma_cookie(struct iommu_domain *domain)
 	struct iommu_dma_cookie *cookie = domain->iova_cookie;
 	struct iommu_dma_msi_page *msi, *tmp;
 
+	/*
+	 * Drop any DMA_PMD mappings cached against this domain before its
+	 * page tables and IOVA domain go away.
+	 */
+	dma_pmd_domain_release(domain);
+
 	if (cookie->iovad.granule) {
 		iommu_dma_free_fq(cookie);
 		put_iova_domain(&cookie->iovad);
diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
index 16312014b8976..7f4251845ba49 100644
--- a/drivers/iommu/dma-pmd-kunit.c
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -5,6 +5,7 @@
 #include <kunit/test.h>
 #include <linux/gfp.h>
 #include <linux/dma-pmd.h>
+#include <linux/iommu.h>
 #include <linux/mm.h>
 
 #include "dma-pmd-priv.h"
@@ -142,7 +143,9 @@ static void test_pool_alloc_and_recycle(struct kunit *test)
 
 static void test_window_helpers(struct kunit *test)
 {
+	struct iommu_domain dummy_domain = {};
 	struct dma_pmd_window win = {};
+	struct dma_pmd_pool *pool;
 
 	KUNIT_ASSERT_EQ(test, dma_pmd_meta_init(), 0);
 
@@ -156,6 +159,11 @@ static void test_window_helpers(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, dma_pmd_window_owns(&win, SZ_4G));
 	KUNIT_EXPECT_TRUE(test, dma_pmd_window_owns(&win, SZ_4G + SZ_2G - 1));
 	KUNIT_EXPECT_FALSE(test, dma_pmd_window_owns(&win, SZ_4G + SZ_2G));
+	/* Releasing an unregistered domain with an active pool is a safe no-op. */
+	pool = dma_pmd_pool_create(0, 1);
+	KUNIT_ASSERT_NOT_NULL(test, pool);
+	dma_pmd_domain_release(&dummy_domain);
+	dma_pmd_pool_destroy(pool);
 }
 
 static struct kunit_case dma_pmd_meta_test_cases[] = {
diff --git a/drivers/iommu/dma-pmd-map.c b/drivers/iommu/dma-pmd-map.c
new file mode 100644
index 0000000000000..cffa94a7c7c84
--- /dev/null
+++ b/drivers/iommu/dma-pmd-map.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * DMA_PMD per-domain IOVA window management and IOMMU mapping.
+ *
+ * See Documentation/core-api/dma-pmd.rst for the architecture overview.
+ */
+
+#include <linux/atomic.h>
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/dma-map-ops.h>
+#include <linux/dma-mapping.h>
+#include <linux/dma-pmd.h>
+#include <linux/export.h>
+#include <linux/iommu.h>
+#include <linux/mm.h>
+#include <linux/spinlock.h>
+#include <linux/srcu.h>
+
+#include "dma-iommu.h"
+#include "dma-pmd-priv.h"
+
+/*
+ * Index -> domain, for PMD pages that have to unmap themselves from every domain
+ * that installed them. A slot is cleared before the matching bits are cleared
+ * in dma_pmd_domain_release(), so a PMD page racing with a dying domain sees
+ * NULL and correctly leaves the doomed page tables alone.
+ *
+ * @base is cached here rather than read back from the domain's DMA cookie, so
+ * that teardown never has to dereference a cookie that may be about to be
+ * freed.
+ *
+ * The lock also serialises index allocation, which happens from the DMA map
+ * path and so cannot sleep.
+ */
+static struct {
+	struct iommu_domain *domain;
+	dma_addr_t base;
+	bool draining;
+} dma_pmd_domains[DMA_PMD_MAX_DOMAINS] __read_mostly;
+static DEFINE_SPINLOCK(dma_pmd_domains_lock);
+
+/*
+ * Held by dma_pmd_unmap_all() across the registry read and the iommu_unmap()
+ * that follows, and waited on by dma_pmd_domain_release() once it has cleared
+ * the slot. Without it an unmapper that sampled a domain a moment before the
+ * slot was cleared would walk into page tables their owner is already freeing.
+ * SRCU rather than RCU to avoid holding RCU across IOTLB flushes.
+ */
+DEFINE_SRCU(dma_pmd_srcu);
+
+/**
+ * dma_pmd_unmap_all - Remove a PMD page's PTE from every domain holding it
+ * @meta: PMD page metadata structure
+ *
+ * The window itself is a permanent allocation out of each domain's
+ * iova_domain and is deliberately left alone; only the leaf PTE goes away.
+ *
+ * The bits are cleared before the unmaps, not after. A mapper that observes a
+ * cleared bit takes the slow path and blocks on @meta->map_lock, so it either
+ * re-installs the PTE or waits; the reverse order would leave a window in
+ * which the bit still claims a translation that has already been torn down.
+ *
+ * A domain that has since been released has a NULL registry slot and is
+ * skipped: its page tables are being freed by their owner and must not be
+ * touched here.
+ *
+ * Cost: Slow path (teardown / shrinker only); one iommu_unmap() per domain.
+ * Locking: Acquires @meta->map_lock and @dma_pmd_domains_lock (irqsave), and
+ *          drops both before unmapping. Holds @dma_pmd_srcu across the
+ *          registry read and the unmap, which is what keeps the domain alive
+ *          in between.
+ * Frequency: Rare (only when a PMD page is released back to the buddy
+ *            allocator or when a pool is destroyed).
+ */
+void dma_pmd_unmap_all(struct dma_pmd_meta *meta)
+{
+	phys_addr_t phys = dma_pmd_meta_to_phys(meta);
+	unsigned long mapped, flags;
+	int idx, srcu_idx;
+
+	srcu_idx = srcu_read_lock(&dma_pmd_srcu);
+	spin_lock_irqsave(&meta->map_lock, flags);
+	mapped = meta->domains_mapped;
+	meta->domains_mapped = 0;
+	spin_unlock_irqrestore(&meta->map_lock, flags);
+
+	if (!mapped) {
+		srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
+		return;
+	}
+
+	for_each_set_bit(idx, &mapped, DMA_PMD_MAX_DOMAINS) {
+		struct iommu_domain *domain;
+		dma_addr_t base;
+
+		spin_lock_irqsave(&dma_pmd_domains_lock, flags);
+		domain = dma_pmd_domains[idx].domain;
+		base = dma_pmd_domains[idx].base;
+		spin_unlock_irqrestore(&dma_pmd_domains_lock, flags);
+
+		if (!domain)
+			continue;
+
+		iommu_unmap(domain, base + phys, PMD_SIZE);
+	}
+	srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
+}
+
+/**
+ * dma_pmd_forget_domain - Drop a PMD page's PTE record for a dying domain
+ * @meta: PMD page metadata structure
+ * @idx: Index of the domain being torn down
+ *
+ * Deliberately does not unmap: @domain is being destroyed by its owner, which
+ * frees the page tables and the IOVA domain wholesale. Touching it here is
+ * exactly the use-after-free this is meant to prevent, so the bit is only
+ * forgotten.
+ *
+ * Locking: Acquires @meta->map_lock (irqsave).
+ *
+ * Return: 1 if this PMD page had a mapping in @idx, 0 otherwise.
+ */
+unsigned int dma_pmd_forget_domain(struct dma_pmd_meta *meta, int idx)
+{
+	unsigned int dropped = 0;
+	unsigned long flags;
+
+	if (!(READ_ONCE(meta->domains_mapped) & BIT(idx)))
+		return 0;
+
+	spin_lock_irqsave(&meta->map_lock, flags);
+	if (meta->domains_mapped & BIT(idx)) {
+		meta->domains_mapped &= ~BIT(idx);
+		dropped = 1;
+	}
+	spin_unlock_irqrestore(&meta->map_lock, flags);
+
+	return dropped;
+}
+
+/**
+ * dma_pmd_domain_release - Forget every PMD page mapping for @domain
+ * @domain: DMA domain being destroyed
+ *
+ * A PMD page records, as a bit per domain index, which domains hold its PMD leaf
+ * PTE. Those bits are otherwise only cleared when the PMD page itself is
+ * released, so a domain that comes and goes - which this tree does at runtime,
+ * see the DMS comments in __iommu_dma_map_phys() - would permanently consume
+ * one index per generation, and every PMD page that ever mapped through it would
+ * keep claiming a mapping in page tables that no longer exist.
+ *
+ * The registry slot is cleared first and the per-PMD-page bits afterwards.
+ * dma_pmd_unmap_all() reads the bit and then the slot, so that order means it
+ * either sees no bit, or sees a NULL slot and skips: it can never unmap
+ * through a domain whose page tables its owner is freeing. An unmapper that
+ * sampled the slot just before it was cleared is waited out on @dma_pmd_srcu.
+ *
+ * The slot stays reserved until the walk and drain are done, so the index
+ * cannot be handed to a new domain while PMD pages still carry its bit.
+ *
+ * Cost: O(PMD pages) across all pools, but only on domain teardown.
+ * Locking: Takes @dma_pmd_domains_lock, then @dma_pmd_pools_lock, then each
+ *          @pool->lock, then each @meta->map_lock. Must be called from process
+ *          context.
+ */
+void dma_pmd_domain_release(struct iommu_domain *domain)
+{
+	unsigned int dropped = 0;
+	unsigned long flags;
+	int idx;
+
+	/* Nothing has ever been pooled, so nothing can reference @domain. */
+	if (likely(!dma_pmd_meta_base()))
+		return;
+
+	spin_lock_irqsave(&dma_pmd_domains_lock, flags);
+	for (idx = 0; idx < DMA_PMD_MAX_DOMAINS; idx++) {
+		if (dma_pmd_domains[idx].domain == domain) {
+			dma_pmd_domains[idx].domain = NULL;
+			/*
+			 * Keep the slot reserved until every PMD page below has
+			 * forgotten it. A new domain handed this index now
+			 * would inherit the stale bits, and its first map of
+			 * such a PMD page would skip iommu_map() and return an
+			 * IOVA with no PTE behind it.
+			 */
+			dma_pmd_domains[idx].draining = true;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&dma_pmd_domains_lock, flags);
+
+	/* @domain never pooled, so no PMD page can be holding a bit for it. */
+	if (idx == DMA_PMD_MAX_DOMAINS)
+		return;
+
+	dropped += dma_pmd_pools_forget_domain(idx);
+
+	/*
+	 * Any PMD page removed from a pool list before the walk above is either
+	 * already on @dma_pmd_free_list (placed there under @pool->lock in
+	 * __dma_pmd_free_page()) or being unmapped under @dma_pmd_srcu (in
+	 * the shrinker or dma_pmd_pool_destroy()). Drain the reclaim list and
+	 * wait out @dma_pmd_srcu before allowing @idx to be reused.
+	 *
+	 * synchronize_srcu() also waits out any dma_pmd_unmap_all() that
+	 * sampled @domain before the slot was cleared above.
+	 */
+	synchronize_srcu(&dma_pmd_srcu);
+
+	/* No PMD page claims @idx any more, so it can be reused. */
+	spin_lock_irqsave(&dma_pmd_domains_lock, flags);
+	dma_pmd_domains[idx].draining = false;
+	spin_unlock_irqrestore(&dma_pmd_domains_lock, flags);
+
+	if (dropped)
+		pr_debug("dma_pmd: released %u PMD page mappings for domain %p (index %d)\n",
+			 dropped, domain, idx);
+}
diff --git a/drivers/iommu/dma-pmd-pool.c b/drivers/iommu/dma-pmd-pool.c
index 78f2537772d1d..1d4244ba422a3 100644
--- a/drivers/iommu/dma-pmd-pool.c
+++ b/drivers/iommu/dma-pmd-pool.c
@@ -74,9 +74,8 @@ static void dma_pmd_pool_free_kref(struct kref *kref)
  *    pushed locklessly onto dma_pmd_free_list and dma_pmd_reclaim_work is
  *    scheduled on dma_pmd_wq.
  * 2. In process context, dma_pmd_release_page() unmaps all IOMMU domains
- *    (dma_pmd_unmap_all(), added in a later commit), clears meta->pooled so
- *    new lockless readers stop entering @meta, and queues
- *    dma_pmd_release_page_rcu() via call_rcu().
+ *    (dma_pmd_unmap_all()), clears meta->pooled so new lockless readers stop
+ *    entering @meta, and queues dma_pmd_release_page_rcu() via call_rcu().
  * 3. After an RCU grace period (once no concurrent dma_pmd_free_page() reader
  *    can still be dereferencing @meta), dma_pmd_release_page_rcu() unfreezes
  *    all order-pool->order blocks (already split by split_page_compound()),
@@ -125,14 +124,14 @@ static void dma_pmd_release_page_rcu(struct rcu_head *head)
  * dma_pmd_release_page - Retire a PMD page and schedule its buddy release
  * @meta: PMD page metadata structure (must have all usable blocks idle)
  *
- * Cost: Slow path; clears the membership bit. The blocks themselves are
- *       returned after an RCU grace period.
- * Locking: Must not hold @pool->lock.
+ * Cost: Slow path; unmaps the IOMMU domains and clears the membership bit.
+ *       The blocks themselves are returned after an RCU grace period.
+ * Locking: Process context (calls iommu_unmap). Must not hold @pool->lock.
  * Frequency: Rare (background reclaim workqueue, shrinker, pool destruction).
  */
 static void dma_pmd_release_page(struct dma_pmd_meta *meta)
 {
-	/* dma_pmd_unmap_all(meta) will be called here once IOMMU mappings are added. */
+	dma_pmd_unmap_all(meta);
 
 	/*
 	 * Clear membership before the grace period. A reader that passed
@@ -176,6 +175,31 @@ static void dma_pmd_schedule_reclaim(void)
 		schedule_work(&dma_pmd_reclaim_work);
 }
 
+unsigned int dma_pmd_pools_forget_domain(int idx)
+{
+	struct dma_pmd_pool *pool;
+	struct dma_pmd_meta *meta;
+	unsigned int dropped = 0;
+	unsigned long flags;
+
+	mutex_lock(&dma_pmd_pools_lock);
+	list_for_each_entry(pool, &dma_pmd_pools, node) {
+		spin_lock_irqsave(&pool->lock, flags);
+		list_for_each_entry(meta, &pool->partial, list)
+			dropped += dma_pmd_forget_domain(meta, idx);
+		list_for_each_entry(meta, &pool->idle, list)
+			dropped += dma_pmd_forget_domain(meta, idx);
+		list_for_each_entry(meta, &pool->full, list)
+			dropped += dma_pmd_forget_domain(meta, idx);
+		spin_unlock_irqrestore(&pool->lock, flags);
+	}
+	mutex_unlock(&dma_pmd_pools_lock);
+
+	dma_pmd_schedule_reclaim();
+	flush_work(&dma_pmd_reclaim_work);
+	return dropped;
+}
+
 /**
  * dma_pmd_pool_create - Create a DMA_PMD page pool
  * @order: Block order to dispense, must be <= PMD_ORDER.
@@ -232,12 +256,10 @@ EXPORT_SYMBOL(dma_pmd_pool_create);
  * dma_pmd_pool_destroy - Destroy a DMA_PMD page pool and unmap cached PMD pages
  * @pool: Pool to destroy
  *
- * Frees completely idle 2M pages immediately. Device DMA must be quiesced by
- * the caller first, but blocks already handed to the networking stack (e.g.,
- * RX skbs waiting in socket queues or TX skbs in TCP retransmit queues) may
- * still be in flight; those 2M pages stay on @pool->partial / @pool->full and
- * keep @pool alive on @dma_pmd_pools via @pool->refcount until their last
- * blocks free.
+ * Unmaps and frees completely idle PMD pages. If any blocks are still in flight
+ * (e.g., held by socket queues or SKBs), the pool structure and active pages
+ * remain on @dma_pmd_pools via @pool->refcount (visible to dma_pmd_domain_release())
+ * and are automatically unmapped and reclaimed as their last blocks free.
  *
  * Cost: Control plane teardown; flushes async reclaim workqueue.
  * Locking: Process context (may sleep in flush_work). Acquires @pool->lock.
@@ -250,10 +272,12 @@ struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool)
 	struct dma_pmd_meta *meta, *tmp;
 	LIST_HEAD(release_list);
 	unsigned long flags;
+	int srcu_idx;
 
 	if (!pool)
 		return NULL;
 
+	srcu_idx = srcu_read_lock(&dma_pmd_srcu);
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->destroyed = true;
 
@@ -267,6 +291,7 @@ struct dma_pmd_pool *dma_pmd_pool_destroy(struct dma_pmd_pool *pool)
 		list_del(&meta->list);
 		dma_pmd_release_page(meta);
 	}
+	srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
 
 	kref_put(&pool->refcount, dma_pmd_pool_free_kref);
 	flush_work(&dma_pmd_reclaim_work);
@@ -707,10 +732,12 @@ static unsigned long dma_pmd_shrink_scan(struct shrinker *shrink,
 	unsigned long freed = 0;
 	LIST_HEAD(release_list);
 	unsigned long flags;
+	int srcu_idx;
 
 	if (!mutex_trylock(&dma_pmd_pools_lock))
 		return SHRINK_STOP;
 
+	srcu_idx = srcu_read_lock(&dma_pmd_srcu);
 	list_for_each_entry(pool, &dma_pmd_pools, node) {
 		/*
 		 * Every PMD page on @idle is a candidate, so this detaches one
@@ -734,11 +761,15 @@ static unsigned long dma_pmd_shrink_scan(struct shrinker *shrink,
 
 	mutex_unlock(&dma_pmd_pools_lock);
 
-	/* Retiring must not run under @pool->lock. */
+	/*
+	 * Retiring is done outside both locks: dma_pmd_release_page() unmaps
+	 * from the IOMMU, which is far too long to hold pool->lock for.
+	 */
 	list_for_each_entry_safe(meta, tmp, &release_list, list) {
 		list_del(&meta->list);
 		dma_pmd_release_page(meta);
 	}
+	srcu_read_unlock(&dma_pmd_srcu, srcu_idx);
 
 	/*
 	 * Both counts are in pages, matching dma_pmd_shrink_count(). A
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index 8104897572921..8477a8edfac63 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -7,8 +7,11 @@
 #include <linux/list.h>
 #include <linux/llist.h>
 #include <linux/spinlock.h>
+#include <linux/srcu.h>
 #include <linux/types.h>
 
+struct iommu_domain;
+
 /**
  * struct dma_pmd_window - A domain's IOVA window reserved for DMA_PMD pages
  * @base: First IOVA of the window. A page at @phys is mapped, in every domain
@@ -36,6 +39,15 @@ struct dma_pmd_window {
 
 #define DMA_PMD_BLOCKS(order)		(1U << (PMD_ORDER - (order)))
 
+/*
+ * Number of IOMMU domains that may use DMA_PMD at once.
+ *
+ * Each such domain is given a dense index, which is the bit position it uses
+ * in dma_pmd_meta.domains_mapped. One word per PMD page records every domain
+ * that has mapped this PMD page. Used to speed up map and unmap.
+ */
+#define DMA_PMD_MAX_DOMAINS		BITS_PER_LONG
+
 /*
  * Sentinel values of dma_pmd_window.domain_idx below DMA_PMD_IDX_FIRST:
  * never attempted (0, matching kzalloc), or permanently declined. A real
@@ -71,6 +83,17 @@ enum {
  * meta->map_lock	IRQ-safe spinlock over one PMD frame's domains_mapped
  *			bitmap. Innermost, and never held across anything that
  *			sleeps.
+ *
+ * The full order is dma_pmd_pools_lock -> pool->lock -> meta->map_lock, as
+ * taken by dma_pmd_domain_release().
+ *
+ * dma_pmd_domains_lock IRQ-safe spinlock over the domain index table and the
+ *			per-domain windows. Taken on its own; it is never
+ *			nested with dma_pmd_pools_lock in either direction.
+ *
+ * dma_pmd_srcu	Read side lets the unmap path dereference a domain out
+ *			of dma_pmd_domains[] without blocking a concurrent
+ *			dma_pmd_domain_release().
  */
 
 /*
@@ -186,6 +209,7 @@ struct dma_pmd_pool {
 } ____cacheline_aligned;
 
 extern unsigned long dma_pmd_meta_nframes;
+extern struct srcu_struct dma_pmd_srcu;
 
 static inline struct dma_pmd_meta *dma_pmd_meta_base(void)
 {
@@ -203,6 +227,10 @@ struct dma_pmd_meta *dma_pmd_meta_from_phys(phys_addr_t pa);
 unsigned long dma_pmd_meta_to_pfn(const struct dma_pmd_meta *m);
 phys_addr_t dma_pmd_meta_to_phys(const struct dma_pmd_meta *m);
 
+unsigned int dma_pmd_pools_forget_domain(int idx);
+void dma_pmd_unmap_all(struct dma_pmd_meta *meta);
+unsigned int dma_pmd_forget_domain(struct dma_pmd_meta *meta, int idx);
+
 static inline bool dma_is_pmd_phys(phys_addr_t phys)
 {
 	return dma_is_pmd_page(phys >> PAGE_SHIFT);
@@ -227,6 +255,8 @@ static inline bool dma_pmd_window_owns(const struct dma_pmd_window *win, dma_add
 	return size && dma - win->base < size;
 }
 
+void dma_pmd_domain_release(struct iommu_domain *domain);
+
 #else /* !CONFIG_DMA_PMD */
 
 static inline bool dma_is_pmd_phys(phys_addr_t phys)
@@ -239,5 +269,9 @@ static inline bool dma_pmd_window_owns(const struct dma_pmd_window *win, dma_add
 	return false;
 }
 
+static inline void dma_pmd_domain_release(struct iommu_domain *domain)
+{
+}
+
 #endif /* CONFIG_DMA_PMD */
 #endif /* _DRIVERS_IOMMU_DMA_PMD_PRIV_H */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


