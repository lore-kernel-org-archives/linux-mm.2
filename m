Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD54ECA5FE4
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 21:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9B06B0099; Sat,  3 Oct 2026 17:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2196B009B; Sat,  3 Oct 2026 17:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C7436B009D; Sat,  3 Oct 2026 17:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC006B0099
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 17:22:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2B321609FD
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:57 +0000 (UTC)
X-FDA: 85282589994.19.C298375
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3DEEBA000B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 21:22:56 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sQX7O8tw;
	spf=pass (imf15.hostedemail.com: domain of 3LnLBagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3LnLBagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791062576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=agV1iLTkSM8BP/RETmEVpwWxRosSitnKJRX5SSlYpX4=;
	b=KRtk/QxoBBEAGfLt1Vmbg/lOor4obYAKHT7Qhyji24Ic0eIWmOlO8DP2hX3zr4eb/Yaemv
	SiyXgfYBPhXG3rF+xMt1UW22UI6Y7Pgc0aWzZa5kXVRx4px4UdOndoolz4z21CLdZhhf1Y
	VBCHDesH/Urn7YNvr91GCS/cTk5fgdQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791062576;
	b=ju4ZrgEERVknElsgdAzDQXaT1MllaIgY83rYvc2HrmTYuFnfLDlDX3wsJrWDeVPM6L0upL
	kh1f5agB7v8X6n/Qo8Hph+jsq+iQvdbtoG8d7UBlfmUQPzWuf27eF99HJI+novI70R200x
	kGBXSc+tMmuJfjcWR3TMI7WkunCdhA0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sQX7O8tw;
	spf=pass (imf15.hostedemail.com: domain of 3LnLBagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3LnLBagYKCHUekbsshZhhZeX.Vhfebgnq-ffdoTVd.hkZ@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6ae14ecef5fso456491a12.0
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 14:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791062575; x=1791667375; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=agV1iLTkSM8BP/RETmEVpwWxRosSitnKJRX5SSlYpX4=;
        b=sQX7O8twyvLWV4Ql7Z3n5UEtL8wI4mKu3+d5G0Oy+yessM9aX1OMHa/7ENhXUBedIW
         jaoXTV9XXDwlOJrS8XTxYYaOgCv9yqhwX5WBtghaLCBOeWQJ1xdIHOQ0rfFBQG8nxXyx
         66SJyHDGjOC+nWAk0rhDS9Eq56GFnkZCot0mrwfA916A0+ZV30f4z1pWlUMIz/N5vJDf
         UOk4qVP058kDoL2JY09RLKMxYqOrSzDFHNvjl4P7KNn18hPsGCX+h4aymL1WLtxBk90i
         q3gso7+0g7GQdQDVk8Qai63Nt0q2cNbe3qQGuJeS/DL/z3AovKhqmjmQjmjUE5QPGHkJ
         ZrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791062575; x=1791667375;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=agV1iLTkSM8BP/RETmEVpwWxRosSitnKJRX5SSlYpX4=;
        b=ozjeToK3yZjmORaagtM0rTj3mWE+j56gUnqXk8LZCAuYdyzt4ldfOu4ak9qKD810MQ
         KBvn7R7N++JuBhBXlPyVUqEj/mPB4Anyx3pvib6xFZcyJbj+WMRhLudobuaS/IQgnN+S
         GPHp1eJmlAMnYSbTZyGk7WD5H2VfrHz0ceQW/X3xxIOG6TJwxuOOLs44yaHyQqUhnmJZ
         o4mbKIeQ2kaDMXpDoRaXPXFPv1wKPCL17Ok48TIgdvYyhbWaDISrK+8OJ7iXxGBNd8Cu
         FAc1d7GChhCZ7BL0tP81h8AwBZB0Ky+aiROMhVgWb032KcV6y1WA8aMTE/nH2Bugyy4a
         P8QA==
X-Forwarded-Encrypted: i=1; AKwUvBxQwCBNWxeuDL2zV9tusoF5jAyNMCr7nsu+gJVihp85ljX3WgslB74nPV2tftnHXRembAzx9K0fvA==@kvack.org
X-Gm-Message-State: AFq9FYIL9ISsa1CUmzjoG2xiA9mAjLJasXr1+VoPcdRjIIMbkeDCseM8
	1FPNTX2o7o3AgDB8TOBJtqBUazRqyjrwSqcFiXDE78Hwq2sayHIDo0ufG/4RTYHJpJ87sSaZkXB
	h9JwtDw==
X-Received: from edqh23.prod.google.com ([2002:aa7:c617:0:b0:6ab:70:34b5])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2753:b0:6aa:fc60:60b7
 with SMTP id 4fb4d7f45d1cf-6af9e349d83mr4895409a12.44.1791062574444; Sat, 03
 Oct 2026 14:22:54 -0700 (PDT)
Date: Sat,  3 Oct 2026 21:22:25 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20261003212241.3432303-7-lrizzo@google.com>
Subject: [RFC: DMA_PMD 06/22] iommu/dma: reserve a per-domain IOVA window for
 DMA_PMD pages
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3DEEBA000B
X-Stat-Signature: 5tq1xwinh4q3ded3imno55uzeihdxgd5
X-HE-Tag: 1791062576-134486
X-HE-Meta: U2FsdGVkX1/OhhA1EnYpiv3MTCNpW3Rqz1YTKkxB9EEyurAaouP/TNAyAp9J1Zk7eOkIbzV17t1+f4aIxSAzK5EqnL8YO4sHEXZDFYjn7Ct9s91nJa7L0uvjz+L4897UifdL2fAFQ8jbvIyapfdtctRs5wmB5FEgDxKVWA2jJIyCUGEmsJBoSXH5bOxcv3Ja72mtJ7piInDexjraTZUPLyP4dGGg8zdN2Z59d77tikoz6JTeF1loOdSz9Ej6mhTgjDHH2N0vr4YmaTRlIyWsgZF4rmgDpeuFCgLEgNQFZ7VYHbmMpT+Au12z3S0PQzLJJwg6dCD7pvoFIPp1OjdHSCYfXApjtlUURcJxdfsm2J/N8qEqiaHfypQCpMo6md+CkaXMk9/epC8ukHDpW+gimcDKXSbDdoLlLztlqnlY7dL66UCpg6m38m83zBZQpsojbq/xpfHbTBnFMm6tKoEOx17M8mFLaqkYNVbHVYIprBEvxdk9FFw0yinH46DxbT3haH3iXh8SK+8Y2CUzhp94rH2adnVdU8zoOZmRelVX+vV/GxPiHJ9Nqe0uKxdfOOIFuE2AP6vmMx1Bsd2BPK5MtOUtuZvbyomi+0bltLrYeatArRxIwHs2LUatVDNw7N9ZYqXonAHW3Tb7wkzSecQOFCoCNMMxrVhtQgYPGvV8t7bD4+XrifAQ6YVJaFbcMG4d8cGpwRMQrVoLilB00Cdj1np+lu9GDpjBs8aGtC0AAcKphQjyuzPIJX2h12IWwhKppcGEoyQ2zhi1kMzQV3z7DzwBhgnyISCv+RLg1Y8bGHSdtt7g00j/dIkyvdaLyhBtUBf9OzFWichtZnRcqOKCZhb1Z4Uqx6vEVy9ESqlFuVSXg9JicO1oBvz3Ui3UgQ5OqnUBC+s17dYmvjnHNDVJXnU1fHRLIbG5l2A6O1fBXc1/033MZo15O/9+Ze5Bw4VQQd1Rh9JVPg2Zc3lah7R
 NtXB4lil
 5tsjqraCuP2sm4Zvlaf8iMGHssYrqBnQMtMuR4Gj2oz0G1bkEs/qcjhUVc4y5J7tqqJEg9TChrAdNPA/TqnDDhMk9AabHY328cIotTGoIdtf7EdV9cUmdOFTWi5aXlEz/r08/OrrtTUvXhPH1eEkGUilToTfjs5hC0nM/+tQAyXz4uMNusHtiVUYF/tr3XZVIphJDLKen40Zou8Rs+GdaLJtT0IVWEX+jdbaow9JpbmwTXcVqmXD5+qZL06H+UZw8BhlHc8hSrYi4s4944b0WQ6yAIIH3eeJCXfg9BHucYGUweT1T/Ns+3ij1g2z6WbPE1KnCvTsicUqRQwwDGrvVv7z+J2pJ4sYveJQy14kfF+EIuC7Eq46SKl+rShinCY9IK0yYWe0h1YcdsS0RDGqdFj2JcDCRVSIsBVxfKyZ9bB4oFXbAB11JYV78DcN/Wyvjzfn/y7w0bgKjMQdsAymyaAFqu/UJMpbOEVHPlobQWPNc5+FjxA6f3AHhTGF1KRFJSO/2jx4EmtEv4IjoyCZAqzPHmOJx5kuZ7KRHdR4q68a6tp9Nbd2gKd+KCyCkcykGaSqpyWK+rq2cq+utzlY0QeS99skdEdEp8/1gfU+u0rCBiKY1MURyF8uvE0gV0gbB5OpBSz0rkLvhWzhIhH3y2CTn0s9M7KrhXvID
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Embed struct dma_pmd_window in struct iommu_dma_cookie to record the
per-domain IOVA range reserved for DMA_PMD mappings, and expose the
cookie accessors (dma_pmd_dma_window(), dma_pmd_dma_iovad(),
dma_pmd_window_owns()) and dma_info_to_prot() needed by the DMA_PMD
mapping layer in subsequent patches.

No functional change.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/dma-iommu.c     | 39 ++++++++++++++++++-
 drivers/iommu/dma-iommu.h     |  8 ++++
 drivers/iommu/dma-pmd-kunit.c | 19 +++++++++
 drivers/iommu/dma-pmd-priv.h  | 72 +++++++++++++++++++++++++++++++++++
 4 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 58c624513cd43..70aee7a3020c8 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -18,6 +18,7 @@
 #include <linux/gfp.h>
 #include <linux/huge_mm.h>
 #include <linux/iommu.h>
+#include <linux/dma-pmd.h>
 #include <linux/iommu-dma.h>
 #include <linux/iova.h>
 #include <linux/irq.h>
@@ -36,6 +37,7 @@
 #include <trace/events/swiotlb.h>
 
 #include "dma-iommu.h"
+#include "dma-pmd-priv.h"
 #include "iommu-pages.h"
 
 struct iommu_dma_msi_page {
@@ -75,6 +77,8 @@ struct iommu_dma_cookie {
 	struct iommu_domain *fq_domain;
 	/* Options for dma-iommu use */
 	struct iommu_dma_options options;
+	/* IOVA window reserved for DMA_PMD pages. Nothing else can go here. */
+	struct dma_pmd_window win_dma_pmd;
 };
 
 struct iommu_dma_msi_cookie {
@@ -732,7 +736,7 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, struct device *dev
  *
  * Return: corresponding IOMMU API page protection flags
  */
-static int dma_info_to_prot(enum dma_data_direction dir, bool coherent,
+int dma_info_to_prot(enum dma_data_direction dir, bool coherent,
 		     unsigned long attrs)
 {
 	int prot;
@@ -1214,6 +1218,39 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
 	return iova_offset(iovad, phys | size);
 }
 
+/**
+ * dma_pmd_dma_window - This domain's IOVA window for DMA_PMD
+ * @domain: Domain to look at
+ *
+ * For the DMA_PMD code's slow paths, which need a window but do not have the
+ * cookie layout. The DMA map path is handed the pointer by its caller instead,
+ * so this is never called at map frequency.
+ *
+ * Return: the window, or NULL if @domain is NULL or does not carry a DMA-IOVA
+ * cookie. The cookie shares a union with the MSI, iommufd and fault-handler
+ * ones, so the type has to be tested rather than the pointer. An identity,
+ * passthrough, or MSI-only domain has no window, and a device can be moved to
+ * one after its pool was created (e.g. via sysfs domain type changes or VFIO
+ * attachment).
+ */
+struct dma_pmd_window *dma_pmd_dma_window(struct iommu_domain *domain)
+{
+	/*
+	 * Also decline in kdump kernels (iommu_deferred_attach_enabled);
+	 * dma_pmd_dma_iovad() uses this check so win->size stays 0.
+	 */
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) ||
+	    !domain || domain->cookie_type != IOMMU_COOKIE_DMA_IOVA)
+		return NULL;
+
+	return &domain->iova_cookie->win_dma_pmd;
+}
+
+struct iova_domain *dma_pmd_dma_iovad(struct iommu_domain *domain)
+{
+	return dma_pmd_dma_window(domain) ? &domain->iova_cookie->iovad : NULL;
+}
+
 dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
diff --git a/drivers/iommu/dma-iommu.h b/drivers/iommu/dma-iommu.h
index 040d002525632..241f8de002e50 100644
--- a/drivers/iommu/dma-iommu.h
+++ b/drivers/iommu/dma-iommu.h
@@ -7,6 +7,9 @@
 
 #include <linux/iommu.h>
 
+struct dma_pmd_window;
+struct iova_domain;
+
 #ifdef CONFIG_IOMMU_DMA
 
 void iommu_setup_dma_ops(struct device *dev, struct iommu_domain *domain);
@@ -22,6 +25,11 @@ void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
 int iommu_dma_sw_msi(struct iommu_domain *domain, struct msi_desc *desc,
 		     phys_addr_t msi_addr);
 
+int dma_info_to_prot(enum dma_data_direction dir, bool coherent, unsigned long attrs);
+
+struct iova_domain *dma_pmd_dma_iovad(struct iommu_domain *domain);
+struct dma_pmd_window *dma_pmd_dma_window(struct iommu_domain *domain);
+
 extern bool iommu_dma_forcedac;
 
 #else /* CONFIG_IOMMU_DMA */
diff --git a/drivers/iommu/dma-pmd-kunit.c b/drivers/iommu/dma-pmd-kunit.c
index 4e38cc5970433..16312014b8976 100644
--- a/drivers/iommu/dma-pmd-kunit.c
+++ b/drivers/iommu/dma-pmd-kunit.c
@@ -140,11 +140,30 @@ static void test_pool_alloc_and_recycle(struct kunit *test)
 	dma_pmd_pool_destroy(pool_wm);
 }
 
+static void test_window_helpers(struct kunit *test)
+{
+	struct dma_pmd_window win = {};
+
+	KUNIT_ASSERT_EQ(test, dma_pmd_meta_init(), 0);
+
+	/* Empty window (size == 0) never owns any IOVA. */
+	KUNIT_EXPECT_FALSE(test, dma_pmd_window_owns(&win, 0));
+	KUNIT_EXPECT_FALSE(test, dma_pmd_window_owns(&win, SZ_4G));
+
+	win.base = SZ_4G;
+	win.size = SZ_2G;
+	KUNIT_EXPECT_FALSE(test, dma_pmd_window_owns(&win, SZ_4G - 1));
+	KUNIT_EXPECT_TRUE(test, dma_pmd_window_owns(&win, SZ_4G));
+	KUNIT_EXPECT_TRUE(test, dma_pmd_window_owns(&win, SZ_4G + SZ_2G - 1));
+	KUNIT_EXPECT_FALSE(test, dma_pmd_window_owns(&win, SZ_4G + SZ_2G));
+}
+
 static struct kunit_case dma_pmd_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_init_and_roundtrip),
 	KUNIT_CASE(test_meta_invalid_phys),
 	KUNIT_CASE(test_meta_pooled_toggle),
 	KUNIT_CASE(test_pool_alloc_and_recycle),
+	KUNIT_CASE(test_window_helpers),
 	{}
 };
 
diff --git a/drivers/iommu/dma-pmd-priv.h b/drivers/iommu/dma-pmd-priv.h
index 39295d0add51d..8104897572921 100644
--- a/drivers/iommu/dma-pmd-priv.h
+++ b/drivers/iommu/dma-pmd-priv.h
@@ -9,10 +9,46 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
+/**
+ * struct dma_pmd_window - A domain's IOVA window reserved for DMA_PMD pages
+ * @base: First IOVA of the window. A page at @phys is mapped, in every domain
+ *        that has a window, at @base + @phys.
+ * @size: Window size in bytes, or 0 if this domain has no window, either
+ *        because nothing has pooled through it yet, or because it could not
+ *        find a free range that large. 0 must make both the map and the unmap
+ *        side decline, see dma_pmd_window_owns().
+ * @domain_idx: Dense domain index + DMA_PMD_IDX_FIRST, used for per-PMD-page
+ *       presence (bit @domain_idx - DMA_PMD_IDX_FIRST), or one of
+ *       DMA_PMD_IDX_NONE, DMA_PMD_IDX_NOHUGE or DMA_PMD_IDX_NOSPACE while
+ *       @size is 0. Of the three sentinels, only DMA_PMD_IDX_NONE is retried.
+ *
+ * Lives in the domain's iommu_dma_cookie. The window is a real allocation out
+ * of the domain's iova_domain, so no ordinary IOVA can ever fall inside it,
+ * which is what lets the unmap path recognise a pooled IOVA by range alone.
+ */
+struct dma_pmd_window {
+	dma_addr_t base;
+	u64 size;
+	u16 domain_idx;
+};
+
 #ifdef CONFIG_DMA_PMD
 
 #define DMA_PMD_BLOCKS(order)		(1U << (PMD_ORDER - (order)))
 
+/*
+ * Sentinel values of dma_pmd_window.domain_idx below DMA_PMD_IDX_FIRST:
+ * never attempted (0, matching kzalloc), or permanently declined. A real
+ * domain index is >= DMA_PMD_IDX_FIRST (subtract DMA_PMD_IDX_FIRST for
+ * the bitmap bit position).
+ */
+enum {
+	DMA_PMD_IDX_NONE,	/* not attempted yet */
+	DMA_PMD_IDX_NOHUGE,	/* @domain can never pool */
+	DMA_PMD_IDX_NOSPACE,	/* no index or no IOVA range */
+	DMA_PMD_IDX_FIRST,	/* first valid domain index */
+};
+
 /*
  * Locking
  * -------
@@ -167,5 +203,41 @@ struct dma_pmd_meta *dma_pmd_meta_from_phys(phys_addr_t pa);
 unsigned long dma_pmd_meta_to_pfn(const struct dma_pmd_meta *m);
 phys_addr_t dma_pmd_meta_to_phys(const struct dma_pmd_meta *m);
 
+static inline bool dma_is_pmd_phys(phys_addr_t phys)
+{
+	return dma_is_pmd_page(phys >> PAGE_SHIFT);
+}
+
+/**
+ * dma_pmd_window_owns - Was @dma handed out by a DMA_PMD mapping?
+ * @win: The unmapping domain's window
+ * @dma: IOVA being unmapped
+ *
+ * Only DMA_PMD pages can be mapped within the reserved IOVA window
+ * so a range check suffices.
+ * A domain that has no window has @size 0, so the unsigned subtraction
+ * underflows to a huge value and the test is always false. That is the same
+ * check that stops the map path from using a window the domain does not own.
+ */
+static inline bool dma_pmd_window_owns(const struct dma_pmd_window *win, dma_addr_t dma)
+{
+	/* Acquire pairs with the release of @size in dma_pmd_window_assign(). */
+	u64 size = smp_load_acquire(&win->size);
+
+	return size && dma - win->base < size;
+}
+
+#else /* !CONFIG_DMA_PMD */
+
+static inline bool dma_is_pmd_phys(phys_addr_t phys)
+{
+	return false;
+}
+
+static inline bool dma_pmd_window_owns(const struct dma_pmd_window *win, dma_addr_t dma)
+{
+	return false;
+}
+
 #endif /* CONFIG_DMA_PMD */
 #endif /* _DRIVERS_IOMMU_DMA_PMD_PRIV_H */
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


