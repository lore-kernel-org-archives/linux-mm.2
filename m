Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28EE607179B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RZIrSfUj
Received: by kanga.kvack.org (Postfix)
	id 7797D6B05B8; Mon,  9 Nov 2026 13:25:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DAC56B05B9; Mon,  9 Nov 2026 13:25:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0A96B05BA; Mon,  9 Nov 2026 13:25:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 308256B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A30CC076B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:46 +0000 (UTC)
X-FDA: 85416409092.30.747D6C4
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	by imf21.hostedemail.com (Postfix) with ESMTP id D20221C000F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RZIrSfUj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3JxDyagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3JxDyagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248744;
	b=uGYNz9AYTN0yPoHWFuLJkiGyUEAFHllvD8FqciRjdx8fVJAoeV/aNMCIZ4kAgu/jWG13HX
	cFuP/YtleHga83tfhrZknhRZReumE0k8r/y0/qN/F5EInIKsbtqU1jym4vq1sE1jLUPMt2
	Fqr81cqgvFn04x/wtipelIQnbLlRO90=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uNnpUKLFZFDZAIGfqh/0M8aoCDnLft+kz4dr3EpUusA=;
	b=xovVIRUdso7Ej/U2Zjfi3B6miE1uFVGGlFNa2lY/K6/lOgJul+38esJzBNhDcy1spW6ZY4
	cRbaCorGkyn7WUvP5JS9WmaG8uhgIQuVoFygWCICJFoEi2VjIZlFWA1++FF5zmVJU0fMJn
	Ji9hJKfHKzfnmEAEiPxj8cOThuQnsOw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RZIrSfUj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3JxDyagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com designates 209.85.218.71 as permitted sender) smtp.mailfrom=3JxDyagYKCG4XdUllaSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--lrizzo.bounces.google.com
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c3613c35145so137717966b.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248743; x=1794853543; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uNnpUKLFZFDZAIGfqh/0M8aoCDnLft+kz4dr3EpUusA=;
        b=RZIrSfUjQ+/3c/2jCRFkh60z+scHnFjmJDmSMLBskaEnulmqoeDJ2JJPwm5Jy27Khd
         VJSZf4e2NgJFEnetqC9GCjJPNjqsxsoLriF5i/+IHz8v5yGMluTGgcDhyhqOpjMBLooL
         bgAZWV9pObkxMcpNJqs8EFB8I4G6NZG7aDreFKPdGSlU7WJzsJ7hWgUSnXF3udemDC0c
         mkecICq6stg4pAnGyinjGMEJc9tGE8ZOKbFSkW8frCo3eazaMGKK48+jKRp7dQKy2bfE
         pJGQ4b+7L2vd0XnYrSza3y1SmTgnSO61Szsn8Kpr+RiVZZqxvH9BVT5/EqG2Y/WOpAbY
         z6aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248743; x=1794853543;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uNnpUKLFZFDZAIGfqh/0M8aoCDnLft+kz4dr3EpUusA=;
        b=LPeESyJcOzzpELDcVFzwcbggVftLf4Sxx7flrot3jOkFbmlzwafLpcNIZ5SroeGE9g
         4kqnwgqNa85kha2mjg+s0dN2cJgtDY98LpeobioL+yTnk+dAfkVygMYriNqPUQIcHW3O
         7JEkRfV6/NB3LVGQosNhuLC6nZ9ro9m3AwUuLCqsOtnouCdgBidQRkZuEvhlIYc3epZ6
         f3KV1oUCjE0qUYHLhtLWEFqtS7Y7RHe/66C+FRU9+Fw4N84Nvh4APuA0SUYOoprXgct+
         s+h06vNFKjNMml2nJ/EA6w2qcguyQSSWDrf0vGI8RULGKPGXCLzxunvbBkoNnJ0i7Rae
         vvfg==
X-Forwarded-Encrypted: i=1; AL+hErFd8Un/9PmTUmT4BJOxBsdPDdZi6eOupyOek+z9z0p3rjRja3mmRDpEyYmAzfwDmuJQk//KmtLMbQ==@kvack.org
X-Gm-Message-State: APuU4Z9WEO+kF29oxpCEvbaaH0FbJpspd4NGvfBGn0Z+2VDhzRuL2LzG
	zzaPC0jedvcJJN10yCbR92PakriUCSHB/vC5OqHNm3237ITHM5Gdp/Nl/tmBXH2AuuYrr/N806j
	OUxw9vg==
X-Received: from ejet13.prod.google.com ([2002:a17:906:178d:b0:c3a:bb3c:9317])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a17:906:794f:b0:c49:a539:aa45
 with SMTP id a640c23a62f3a-c50496b6556mr13388266b.42.1794248743157; Mon, 09
 Nov 2026 10:25:43 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:14 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-7-lrizzo@google.com>
Subject: [RFC PATCH v2 06/25] iommu/dma: Reserve a per-domain IOVA window for
 PISA pages
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
X-Rspamd-Queue-Id: D20221C000F
X-Rspamd-Server: rspam12
X-Stat-Signature: ejdckoyttiqq5xe3zuetcrq4rp5qb956
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794248744-240934
X-HE-Meta: U2FsdGVkX191WqiUq+MqfUxeOaz/R3vbZEGs3FErcVDVFYkOnm2c36NraxMxGdWa9FvPZop046Dy0MaIQDHtYiJGBTSRrx/0cBp3AgX6C8cZojHDwOEM6f7U5ovDcWxa8NBZrfgZhR8r/8d/WNHdva8EeT1XJmeP8BzumnsWIbpPucvpDmR1RmOSvkjcTav9J2OSCT4iN0D7xSkid/lqACfzpOcaN/l5qgKcCeLxXJ0SKHJe2/V+Hq4MqIbTA7RimfAlIMckpEFclbckC6fTHmE2qdsyB29QBuv6pf3HdIFzlWSfrMbF5ZKydfp7+fJb1rcW83q7wWifzwils5yV9s5H5FFfRBgZMFPXJPn9aen/jvbMOVj+fPmKPEzuo0CT2t5ZUjttQ1ENIPmWjX9EIcDcoBvjg7i8Szz0X2XBfutnZQk8DeIvxDJT1/bFEeo3PN4kapRqPz6y65rZxjXUjkKOWTKiRdodch8sEdnQINWO26H9zGGM/m71b2RvztMo/AB9JchLDJ8YL0nW1yjiyIVdzXiZnjpvJb61Nlkx4mQfL7pWfEfQ2qLQQAvnTAA8OSaRLeWYgiYfONyqRsduYjq6KiwHcH2xOxgkKgai0cmEQZzk7MwkwonkTETOhXbpkMm63Jxq2fLly7aoTA2gXHbRdEd2ay7JYoLUiLjNEV1tSWPAK/VvhG/Nyq/KANAKGd9PY0Tkhp25AUWieB7PcW0v/cGMNy0PurYhJi7ajD3C/bZOLIEKmDpRQR2f0wqYSA5gckeViYcJQ52brIVXzQBXX3gsMqdAJaiK2yTVTuzvZUZrlM5AmAavtPvEN/hiMJOl2TZX5QaXExUz0jFahEjEAegX3q3E49+kVdgG1KaEHGd/9oGhhblxHU0I3fgZbfW3Ig2reeM9g1ZgoNkp3nReTqoF+eP9QKFs8uzJKq7+eOMG7fu/iFqXyqqYYv/7ED2aQtHCavteBiUBaSF
 RnjKd/tx
 d/DapozaKbWEH/OXQTPZfwSUh5ojmLSZui4HuKuocTj9jkx72j5ccYYB4mX3V/13LAnyYKIQeFYfs2RHY3Y/4nV7t/MMclQcFDOo3G1f3vU0LKSuSrPene6sBhY6BVukhiEOBQkyFmcg489AJyYlvVxSZUiBsjOQacjaidr8gjjzES9GJwWWRbfJM/gf+4w2hZCvpQJ7QhVb5ci6QhyeVqTM8aRExybOr7fGIQ2ibkNunM1HazFmbuIbe2D1ESEQaNx0I6TMJgPYMu2j4y1WEbtEtAVACZJ5ytVTZ5++csUProJ8mfnwNt7qln3J9RYmyXSAYbsCC63MLx5THZWnrU79vTCJ1kdBLay4z9MdAPN+wJzPY+mzJfahS1vflUppsJc6GNrA2LYxZ31OMBn+Q8C3WTitylgCM6EZoPICSya3dPZyGVLn+JdDOJbariyGRdIx+0TLKuXx4AXlNZCgIQKz1hjXy5i7Q+GPmIqgRbPzeI8jAoRBBMkk/YwWB7CXOXb4em0wdjFesvmQzeUZFf0AKouURIYTrt+uU1uPysVwNzf84mInI8H0CCOvx/jOL04Irw8hyLdWFZRostEyUbR5dERtyngKsgOdmH3c4T36v23PvsyJu+bn8NsTLghug9OnApVNNek6yFxb+esbBUe14zQDl4K5Zxg1KppkZsgSvdZJIczdTOzclBrhSRX/oixmR9+i8Ds6wjgJRPCG1//o3iSOnyejeDdoA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PISA buffers need to be quickly identified from their iova, and may need
to be mapped in multiple domains. We can achieve both by reserving an IOVA
range for PISA pages in each domain.

Add per-domain PISA IOVA window descriptors in struct iommu_dma_cookie
and a global slot allocator (pisa_slot_alloc() / pisa_slot_free()).
The window is sized to twice the maximum allowed PISA buffer space,
defaulting to max(64MB, 1/4 of physical RAM).

A buffer is mapped at the same slot offset in all windows for the domains
that need to access it. IOVA allocation is done with a bitmap (1 bit
per 2MB buffer, hence a 4KB bitmap supports 64GB of buffer space) at
negligible cost.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/Makefile     |  3 ++
 drivers/iommu/dma-iommu.c  | 18 ++++++++
 drivers/iommu/dma-iommu.h  | 16 +++++++
 drivers/iommu/pisa-alloc.c | 12 ++++-
 drivers/iommu/pisa-kunit.c | 24 ++++++++++
 drivers/iommu/pisa-map.c   | 90 ++++++++++++++++++++++++++++++++++++++
 drivers/iommu/pisa-priv.h  | 58 ++++++++++++++++++++++++
 7 files changed, 220 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/pisa-map.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index bc58166f9303a..125cf7e813cdc 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -12,6 +12,9 @@ obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
 obj-$(CONFIG_IOMMU_DMA) += dma-iommu.o
 obj-$(CONFIG_PISA) += pisa-meta.o pisa-alloc.o pisa-node.o
+ifeq ($(CONFIG_IOMMU_DMA),y)
+obj-$(CONFIG_PISA) += pisa-map.o
+endif
 obj-$(CONFIG_PISA_META_KUNIT_TEST) += pisa-kunit.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE) += io-pgtable.o
 obj-$(CONFIG_IOMMU_IO_PGTABLE_ARMV7S) += io-pgtable-arm-v7s.o
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 78742aeba932d..fba6084feac81 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -36,6 +36,7 @@
 #include <trace/events/swiotlb.h>
 
 #include "dma-iommu.h"
+#include "pisa-priv.h"
 #include "iommu-pages.h"
 #include "iommu-priv.h"
 
@@ -76,6 +77,8 @@ struct iommu_dma_cookie {
 	struct iommu_domain *fq_domain;
 	/* Options for dma-iommu use */
 	struct iommu_dma_options options;
+	/* IOVA window reserved for PISA pages. Nothing else can go here. */
+	struct pisa_window win_pisa;
 };
 
 struct iommu_dma_msi_cookie {
@@ -1215,6 +1218,21 @@ static inline size_t iova_unaligned(struct iova_domain *iovad, phys_addr_t phys,
 	return iova_offset(iovad, phys | size);
 }
 
+/* Return @domain's PISA window, or NULL if @domain cannot use PISA. */
+struct pisa_window *pisa_dma_window(struct iommu_domain *domain)
+{
+	if (static_branch_unlikely(&iommu_deferred_attach_enabled) ||
+	    !domain || domain->cookie_type != IOMMU_COOKIE_DMA_IOVA)
+		return NULL;
+
+	return &domain->iova_cookie->win_pisa;
+}
+
+struct iova_domain *pisa_dma_iovad(struct iommu_domain *domain)
+{
+	return pisa_dma_window(domain) ? &domain->iova_cookie->iovad : NULL;
+}
+
 dma_addr_t iommu_dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
 		enum dma_data_direction dir, unsigned long attrs)
 {
diff --git a/drivers/iommu/dma-iommu.h b/drivers/iommu/dma-iommu.h
index 040d002525632..f112b47396984 100644
--- a/drivers/iommu/dma-iommu.h
+++ b/drivers/iommu/dma-iommu.h
@@ -7,6 +7,9 @@
 
 #include <linux/iommu.h>
 
+struct pisa_window;
+struct iova_domain;
+
 #ifdef CONFIG_IOMMU_DMA
 
 void iommu_setup_dma_ops(struct device *dev, struct iommu_domain *domain);
@@ -22,6 +25,9 @@ void iommu_dma_get_resv_regions(struct device *dev, struct list_head *list);
 int iommu_dma_sw_msi(struct iommu_domain *domain, struct msi_desc *desc,
 		     phys_addr_t msi_addr);
 
+struct iova_domain *pisa_dma_iovad(struct iommu_domain *domain);
+struct pisa_window *pisa_dma_window(struct iommu_domain *domain);
+
 extern bool iommu_dma_forcedac;
 
 #else /* CONFIG_IOMMU_DMA */
@@ -59,5 +65,15 @@ static inline int iommu_dma_sw_msi(struct iommu_domain *domain,
 	return -ENODEV;
 }
 
+static inline struct iova_domain *pisa_dma_iovad(struct iommu_domain *domain)
+{
+	return NULL;
+}
+
+static inline struct pisa_window *pisa_dma_window(struct iommu_domain *domain)
+{
+	return NULL;
+}
+
 #endif	/* CONFIG_IOMMU_DMA */
 #endif	/* __DMA_IOMMU_H */
diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index de8009fd6fff3..d7b73c3a6c0b6 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -84,10 +84,12 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 	/* Read @meta before freeing blocks; the frame can be reused immediately. */
 	struct pisa_meta *meta = container_of(head, struct pisa_meta, rcu);
 	struct page *block, *page = pfn_to_page(pisa_meta_to_pfn(meta));
-	unsigned int i, order = meta->pa->order;
+	unsigned int i, order = meta->pa->order, slot = meta->slot;
 
 	WRITE_ONCE(meta->pa, NULL);
 
+	/* The page has been unmapped from every domain by pisa_release_page() */
+	pisa_slot_free(slot);
 	atomic_long_dec(&pisa_nr_pages);
 	for (i = 0; i < PISA_BLOCKS(order); i++) {
 		block = page + (i << order);
@@ -426,10 +428,16 @@ static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t gfp, in
 	if (IS_ERR(meta))
 		return meta;
 
+	if (unlikely(pisa_slot_alloc(meta))) {
+		pisa_release_page(meta);
+		return ERR_PTR(-ENOSPC);
+	}
+
 	page = pfn_to_page(pisa_meta_to_pfn(meta));
 
 	/* Fails with -EBUSY if a concurrent PFN walker holds a speculative ref. */
 	if (split_page_compound(page, PISA_ORDER, order)) {
+		pisa_slot_free(meta->slot);
 		pisa_release_page(meta);
 		pisa_alloc_backoff(nid, can_block);
 		return ERR_PTR(-EBUSY);
@@ -782,6 +790,8 @@ static int __init pisa_init(void)
 	if (!pisa_max_pages)
 		pisa_max_pages = max(totalram_pages() >> (PISA_ORDER + 3), 16UL);
 
+	pisa_slots_init();
+
 	/* Preallocate the supported per-node allocators. */
 	for_each_node_state(nid, N_MEMORY) {
 		for (i = 0; i < ARRAY_SIZE(cfg); i++) {
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index 96bc8dbc38fb4..5a2e806e74654 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -10,6 +10,7 @@
 #include <linux/skbuff.h>
 #include <net/sock.h>
 
+#include "dma-iommu.h"
 #include "pisa-priv.h"
 
 static void test_meta_init_and_roundtrip(struct kunit *test)
@@ -179,6 +180,26 @@ static void test_alloc_and_recycle(struct kunit *test)
 	WRITE_ONCE(pisa_max_pages, old_max);
 }
 
+#ifdef CONFIG_IOMMU_DMA
+static void test_window_helpers(struct kunit *test)
+{
+	struct pisa_window win = {};
+
+	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
+
+	/* Empty window (base == 0) never owns any IOVA. */
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&win, 0));
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&win, SZ_4G));
+
+	win.base = SZ_4G;
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&win, SZ_4G - 1));
+	KUNIT_EXPECT_TRUE(test, is_pisa_iova(&win, SZ_4G));
+	KUNIT_EXPECT_TRUE(test, is_pisa_iova(&win, SZ_4G + pisa_window_size - 1));
+	KUNIT_EXPECT_FALSE(test, is_pisa_iova(&win, SZ_4G + pisa_window_size));
+}
+
+#endif /* CONFIG_IOMMU_DMA */
+
 static void test_reservoir_and_scrubber(struct kunit *test)
 {
 	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
@@ -190,6 +211,9 @@ static struct kunit_case pisa_meta_test_cases[] = {
 	KUNIT_CASE(test_meta_invalid_phys),
 	KUNIT_CASE(test_meta_active_toggle),
 	KUNIT_CASE(test_alloc_and_recycle),
+#ifdef CONFIG_IOMMU_DMA
+	KUNIT_CASE(test_window_helpers),
+#endif
 	KUNIT_CASE(test_reservoir_and_scrubber),
 	{}
 };
diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
new file mode 100644
index 0000000000000..2e8d635dec34c
--- /dev/null
+++ b/drivers/iommu/pisa-map.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/*
+ * PISA per-domain IOVA window management and IOMMU mapping.
+ * See Documentation/core-api/pisa.rst for the architecture overview.
+ */
+
+#include <linux/bitops.h>
+#include <linux/cache.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+#include <linux/pisa.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+#include "dma-iommu.h"
+#include "pisa-priv.h"
+
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "pisa."
+
+/* Optional module param override for pisa_nr_slots (0 = auto: 2 * max_pages). */
+static unsigned int pisa_cfg_slots __read_mostly;
+module_param_named(slots, pisa_cfg_slots, uint, 0444);
+
+/*
+ * Number of 2MB IOVA slots in each domain's window (computed at init from
+ * pisa_cfg_slots or 2 * max_pages). Each active PISA page holds one slot
+ * in [0, pisa_nr_slots) and maps at slot * PISA_SIZE in every domain's window.
+ */
+unsigned int pisa_nr_slots __read_mostly;
+u64 pisa_window_size __read_mostly;
+/* One bit per IOVA slot, set while an active PISA page holds the slot. */
+static unsigned long *pisa_slot_bitmap __read_mostly;
+/* Metadata of the PISA page backing each active slot, or NULL. */
+static struct pisa_meta **pisa_slot2meta __read_mostly;
+static unsigned int pisa_slot_hint;	/* no free slot below this */
+/* Protects pisa_slot_bitmap and pisa_slot_hint. */
+static DEFINE_SPINLOCK(pisa_slot_lock);
+
+/* Cost is typically low though the bitmap can be up to O(100K) bits on large systems. */
+int pisa_slot_alloc(struct pisa_meta *meta)
+{
+	unsigned long flags;
+	unsigned int slot;
+
+	spin_lock_irqsave(&pisa_slot_lock, flags);
+	slot = find_next_zero_bit(pisa_slot_bitmap, pisa_nr_slots, pisa_slot_hint);
+	if (slot < pisa_nr_slots) {
+		__set_bit(slot, pisa_slot_bitmap);
+		pisa_slot_hint = slot + 1;
+		WRITE_ONCE(meta->slot, slot);
+		WRITE_ONCE(pisa_slot2meta[slot], meta);
+	}
+	spin_unlock_irqrestore(&pisa_slot_lock, flags);
+
+	if (slot >= pisa_nr_slots)
+		return -ENOSPC;
+	return 0;
+}
+
+/* Return @slot once no domain can translate it any more. */
+void pisa_slot_free(unsigned int slot)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&pisa_slot_lock, flags);
+	WRITE_ONCE(pisa_slot2meta[slot], NULL);
+	__clear_bit(slot, pisa_slot_bitmap);
+	if (slot < pisa_slot_hint)
+		pisa_slot_hint = slot;
+	spin_unlock_irqrestore(&pisa_slot_lock, flags);
+}
+
+void __init pisa_slots_init(void)
+{
+	/* Fixed at boot: sizes every domain's window (default 2 * max_pages). */
+	pisa_nr_slots = pisa_cfg_slots ?: min_t(unsigned long, 2 * pisa_max_pages, UINT_MAX >> 1);
+	pisa_slot_bitmap = kvcalloc(BITS_TO_LONGS(pisa_nr_slots),
+				    sizeof(unsigned long), GFP_KERNEL);
+	pisa_slot2meta = kvcalloc(pisa_nr_slots, sizeof(*pisa_slot2meta), GFP_KERNEL);
+	if (!pisa_slot_bitmap || !pisa_slot2meta) {
+		kvfree(pisa_slot_bitmap);
+		kvfree(pisa_slot2meta);
+		pisa_slot_bitmap = NULL;
+		pisa_slot2meta = NULL;
+		pisa_nr_slots = 0;
+	}
+	/* Size of every domain's window: one 2MB page per slot. */
+	pisa_window_size = (u64)pisa_nr_slots << PISA_SHIFT;
+}
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
index d5ea83745ba47..3ef6e51402ceb 100644
--- a/drivers/iommu/pisa-priv.h
+++ b/drivers/iommu/pisa-priv.h
@@ -13,12 +13,35 @@
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
+/**
+ * struct pisa_window - A domain's IOVA window reserved for PISA pages
+ * @base: Window base IOVA (PISA_SIZE aligned), or 0 if unassigned
+ * @domain_idx: Dense index + PISA_IDX_FIRST, or PISA_IDX_* sentinel while @base == 0
+ * @idx_gen: Value of pisa_idx_gen when @domain_idx was set to NOIDX
+ *
+ * Lives in iommu_dma_cookie. Active PISA pages map at @base + slot * PISA_SIZE.
+ */
+struct pisa_window {
+	dma_addr_t base;
+	u16 domain_idx;
+	u32 idx_gen;
+};
+
 #ifdef CONFIG_PISA
 
 #define PISA_MAX_BLOCKS		512U
 
 #define PISA_BLOCKS(order)	(1U << (PISA_ORDER - (order)))
 
+/* Sentinel values of pisa_window.domain_idx below PISA_IDX_FIRST. */
+enum {
+	PISA_IDX_NONE,	/* not attempted yet */
+	PISA_IDX_NOHUGE,	/* @domain can never use PISA */
+	PISA_IDX_NOWINDOW,	/* no IOVA range for the window */
+	PISA_IDX_NOIDX,	/* all domain indices were in use */
+	PISA_IDX_FIRST,	/* first valid domain index */
+};
+
 /*
  * Lock hierarchy:
  * - pisa_allocs_lock (rwlock): outermost; protects pisa_allocs list.
@@ -32,6 +55,7 @@
  * @nr_clean:	Zeroed available blocks in @clean_bitmap
  * @nr_dirty:	Dirty available blocks in @dirty_bitmap
  * @on_list:	Current placement in @pa (enum pisa_meta_list)
+ * @slot:	Dense IOVA slot index in every domain's window
  * @pa:		Owning pisa_alloc (NULL for reservoir pages)
  * @list:	Node in @pa lists or per-node reservoir (pisa_node.pages)
  * @llnode:	Node in lockless pisa_free_list for async release to the buddy allocator
@@ -44,6 +68,7 @@ struct pisa_meta {
 	u16 nr_clean;
 	u16 nr_dirty;
 	u8 on_list;
+	u32 slot;
 	struct pisa_alloc *pa;
 	struct list_head list;
 
@@ -172,4 +197,37 @@ unsigned long pisa_reservoir_count(void);
 unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
 
 #endif /* CONFIG_PISA */
+
+#if defined(CONFIG_PISA) && defined(CONFIG_IOMMU_DMA)
+
+/* Size in bytes of every domain's PISA IOVA window, fixed at boot. */
+extern u64 pisa_window_size;
+extern unsigned int pisa_nr_slots;
+
+void pisa_slots_init(void);
+int pisa_slot_alloc(struct pisa_meta *meta);
+void pisa_slot_free(unsigned int slot);
+
+/* Return true if @dma falls within @win's reserved PISA IOVA window. */
+static inline bool is_pisa_iova(const struct pisa_window *win, dma_addr_t dma)
+{
+	/* Acquire pairs with the release of @base in pisa_window_assign(). */
+	dma_addr_t base = smp_load_acquire(&win->base);
+
+	return base && dma - base < pisa_window_size;
+}
+
+#else /* !CONFIG_PISA || !CONFIG_IOMMU_DMA */
+
+#define pisa_nr_slots 0U
+static inline void pisa_slots_init(void) {}
+static inline int pisa_slot_alloc(struct pisa_meta *meta) { return 0; }
+static inline void pisa_slot_free(unsigned int slot) {}
+
+static inline bool is_pisa_iova(const struct pisa_window *win, dma_addr_t dma)
+{
+	return false;
+}
+
+#endif /* CONFIG_PISA && CONFIG_IOMMU_DMA */
 #endif /* _DRIVERS_IOMMU_PISA_PRIV_H */
-- 
2.56.0.542.g3ef89b7020-goog


