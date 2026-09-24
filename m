Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C13DC98315
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB6BF6B0095; Thu, 24 Sep 2026 02:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8E446B0096; Thu, 24 Sep 2026 02:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CA76B0098; Thu, 24 Sep 2026 02:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A509F6B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:53:41 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33DAF16028A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:41 +0000 (UTC)
X-FDA: 85247740242.23.CD5F7DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id F2DC54000A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:53:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QlOlxhim;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
	b=qNot7K5sykwzeFyFVNdXVn/hpaZTU5BnY4RhiXNRCizP28nY4en7i/0VlbGWddoD6yW3/Z
	OGDGFnE4GuxCgSj3CGoqJh0uSHTO2I/62AQ/tAYw4rGM/xhIdcjlVyas43W5PWkVSo2Ty2
	r5JAwJrtN+aLNTUskpFqIGqyWTrzMiU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=QlOlxhim;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232819;
	b=dTjyrjPJYw1xcYngG9ckJOEQ1FZVTMl9XWXQTC5Q4n9mABzkSks/MonKC8gm/Wl3Lf/Z1b
	lPCb509ZOUBhxvZEy24QvsCbB5k4+Gtm4ksDAwZzM12ySn5R1E3Ia03ZgC+PjaxzDwTg31
	Gy6JiSNY7A6OhKVdcxm2P/luzr1NynQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
	b=QlOlxhimajsjWWcWqWyw17Wtiaq1cUJmGLrnaWDDpXfZGlumGLQ+ejEtaKH0IHOIQVf37f
	X7unWH329T/dFwsv7gjc5hR6V7jfNTeXWNvXimHAwSpkSe0s4ONb0Ab1pcDYBY24Fo6JGl
	4FAKmfM1zCt36k0Uj9xEJa2mc6fWqBc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-Qhn9tKMXPNyNIJnp1AzZpg-1; Thu, 24 Sep 2026 02:53:37 -0400
X-MC-Unique: Qhn9tKMXPNyNIJnp1AzZpg-1
X-Mimecast-MFC-AGG-ID: Qhn9tKMXPNyNIJnp1AzZpg_1790232816
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3a5a3189b6fso8703391fa.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:53:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232816; x=1790837616;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
        b=nxrW2bMGbcpvvL6qR2WcPzSLxabA75VrP9dYfhF3Q0ZcetDY3vYwBJYMUW/sBfB5fw
         bqkN/vVYxL6w/eXS6D1j8mrMPpJAScQTe0MqAmmP+sgMbqkwcC4IDRiKfUEqMk3kuWqc
         uoqjHvDrQ2Ez7Xw8tmi6STrVkELhBh5l/OFLTdFRgrftZsmlACpWH2yds2LCje7VmNhh
         5qYOgSQu7jfxdB+uUOZiM0vFiKgT1NGSFXdpBITps+VOz7bBmQKoWTpR+eMw9O07S4ZT
         2z6rxExeTFA7bvFkYhlJEtTrBBQg6g2IXOvVL2EYlk1D4XQuRGXDWvPY4VSrHqnQELRw
         r9Gw==
X-Gm-Message-State: AFuF++ke5pQ12/aLKBsYR6CoviDbmmOySBY1fadk26nAk+Fig2bUVx2Q
	3JDMdFHZ+8vyMCpBAej425iNuNgN9a9TL+NosM+QuXrULFncmzh3JD9DtlSPxD/DLlI0R1iZj+7
	roMOWCIlODWyzHxtGUVbOLpWpEOCyNU7gRGq64C3vg/lxdqjQn0yKi8TS2MWvJDwEPLegX/tIk5
	T6ghzdSxBo9uPW0CnU94f8t6j7VVcOU+/p6EznrQ==
X-Gm-Gg: AYBFou1Wzp0lFKGYq858ooA/12K4L/tF+v3XeKFBtc/gWWat+WiOL6H0hlFfyXsDu67
	aJP9heqF6qStkK1T25B2cEQFIpGzYD1YLA0bF/2/Lr7JouM4qoSrAvNkSAb5G5aQ4AbEdLHwgA9
	uzHVLgPqshyVY2ZKdSqixNXK0rwzQ9TBk6ePd+BIobvd52g9gatSssTVbdnLAJaorjTJRiVRVwk
	cVJ+dNpJUpPyQk17gChB0H4nQXE3u3XdebZsQ6MFj7NHTWIYCj9ctSb0tDyQbkgMBF9uUNd4lUR
	ZmEx0JasHVOG4dK4DcsgDQEbsGXglWbfYTOHXhyD/468kloMXF/3GLMhO9dd3RAprEHh5ccDAZb
	U97n/o+YhzPXZwL6Z56jp
X-Received: by 2002:a05:651c:211b:b0:3a1:980f:5907 with SMTP id 38308e7fff4ca-3a63c086e9bmr3379501fa.8.1790232815580;
        Wed, 23 Sep 2026 23:53:35 -0700 (PDT)
X-Received: by 2002:a05:651c:211b:b0:3a1:980f:5907 with SMTP id 38308e7fff4ca-3a63c086e9bmr3379231fa.8.1790232815017;
        Wed, 23 Sep 2026 23:53:35 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:53:34 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v15 02/11] mm: add helper to convert HMM pfn to migrate pfn
Date: Thu, 24 Sep 2026 09:53:04 +0300
Message-ID: <20260924065313.899730-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 138CLWJNkUKBVFcvIUgep8ZLt0DhRRCUYrs90V3fVU0_1790232816
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xwf6kj9xdok5pk4keqxyeybuyrkyjj7f
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F2DC54000A
X-HE-Tag: 1790232818-934303
X-HE-Meta: U2FsdGVkX1/DQsQ//p5eQ42Ko7YsP3mVA05YxCf2udCPq6qDf/B7uG7K9AASuuLodkqFC/kULMt7b0bzqtLYbNEjF+Jpna10cKtwpKakeeES5p23WKavkm6EeSTIXrYhaUYapiL5tXYEiUqV+fLN6+FaCPaHrpX+VCG5hEZWbah6Sa/1Yllu8s6EUrqtmxvrPD7yzg79ckIYJTKOwLgR/19V0f8M7ZiC9XsDOi5TMXj28d3QcIjNVNTiu1ngEWTOp4jWt5Bp7d1sLxdL81/wYciUe1lEFdKASYttndk2BYLbTWq63YOHTBODTiT8JWQOdmjWHSalkedh07QX2lGP+jv8t99WWWOws+InMe+AVBTiI7p8PgZffnU3c+bT2RfXLie3NybOcDVLf4/DtYYNu2uEq/q833HQKG3zlTdnbI54Vxt1BpVUP+M9pfGc5nzVxhG6/s6ql+7/wjUclyaxAvxo3xL6kfnRDmJaQyEZVVfuzHWuNpQC1phQAcO9D3tEyJ1y7fcnKR4hzTTg+ZIjeoI4Rly/bP6kMKY6Ag8n9MQBMvmhXsm+TxjG27s9xeN/4NAUNvKR+7w+pu+YQYZXP4jpVA+O9W8JFbuKgIm0HbdirmlqBB0bAdYXfSo5Lqa8pIoV70vnAreE6ETY+3fI69cbGb7JdojbSuQ89Ev8J49HQv2EqeW1wpYfapXkK6FvBMqJjNZoZWbdQcYUC9uNBRpqm9l6BD8ll+iuB2OcanUfumJSJN3oo02Th9TE21m7IqXdtgPorvfT9aphxwY7dsyivXVDDGwexG0Sn2+OhKtRJsB6C/7GlIH4iF/hd+I0M3LsIOTwca2ql4ZNY/vdZvrCEhQNkWCu1nJS01Ep5x6yznhA8uEFWa8XXc2Br1cbH+64YGxSK8aoD5l7IT57bq8lVtGJzwq1wVpgCjAt7/y8EJS9/TiShKU2Lwi5fdeEpC4RFhb1q6LuwtmK2rP
 ijYhxndW
 /jX+EVFvlBmdGPqmeVwvu6qW+AKDJkTedX27EzTVcXnP8L75t4ZHko6j+CWjKhfKEhmIZ8ZL4MFHWB76y0hJRJJLJ56BHA2AHpnazSE2WjyCWmOF9f2l8tVKhv3rODl44X1bwXTbAMIQUpv/XrgvLFEI+ilprET48M0pSD+6ksgYBIqxGoAsXye4HjUN6/oBqEY5ZA7Tg7LVo7sZAXo5FImgJxU0fl6CMMNnc5UuQnOiG7A0IE2cYBWrPxi0lU45ymv2azbxfyi9TnnxSoXjT2pOMReGMDFvNsCQy5H+NphVrN/4VFMFzDbWz2LH+JKBUnCIYO04/ddnS+TnRznvgQtwrcVUoi+ks5zEh69ZoCYW+vwc9RkuyVzegLi1F+q2zxftBV9bAwWMG1hSxxrg37lzlAQFXkOBHVU9hrA2lyJx2847kkvgH2ylnJpTCd2U1ycyWTRrKwq8L9JY5AO50qLEMsz6GHQvWdOgdV/10kIlpKKGCulpvuBij1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

The unified HMM/migrate_device pagewalk does the "collecting"
on the HMM side, so we need a helper to transfer pfns to the
migrate_vma world.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 include/linux/hmm.h     | 29 +++++++++++++++++-----
 include/linux/migrate.h |  3 ++-
 mm/migrate_device.c     | 55 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 6f04e3932f5b..4f56f3419cb4 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -13,6 +13,8 @@
 
 struct mmu_interval_notifier;
 
+struct migrate_vma;
+
 /*
  * On output:
  * 0             - The page is faultable and a future call with 
@@ -27,13 +29,22 @@ struct mmu_interval_notifier;
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
  *                      to mark that page is already DMA mapped
+ * HMM_PFN_MIGRATE    - The entry is to be migrated. Note, HMM_PFN_MIGRATE
+ *                      alone without HMM_PFN_VALID denotes the
+ *                      empty page.
+ *                      This flag optionally together with HMM_PFN_COMPOUND
+ *                      are indicators for migrate_hmm_range_setup() to
+ *                      setup the migrate pfns.
+ * HMM_PFN_COMPOUND   - The entry represents a > 0 order page
  *
  * On input:
- * 0                 - Return the current state of the page, do not fault it.
- * HMM_PFN_REQ_FAULT - The output must have HMM_PFN_VALID or hmm_range_fault()
- *                     will fail
- * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
- *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
+ * 0                   - Return the current state of the page, do not fault it.
+ * HMM_PFN_REQ_FAULT   - The output must have HMM_PFN_VALID or hmm_range_fault()
+ *                       will fail
+ * HMM_PFN_REQ_WRITE   - The output must have HMM_PFN_WRITE or hmm_range_fault()
+ *                       will fail. Must be combined with HMM_PFN_REQ_FAULT.
+ * HMM_PFN_REQ_MIGRATE - For default_flags only, request to migrate the range,
+ *                       according to hmm_range.migrate.flags
  */
 enum hmm_pfn_flags {
 	/* Output fields and flags */
@@ -48,11 +59,15 @@ enum hmm_pfn_flags {
 	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
 	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
 
-	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
+	/* Migrate request */
+	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
+	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
+	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
 
 	/* Input flags */
 	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
 	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
+	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
 
 	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
 };
@@ -107,6 +122,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
  * @default_flags: default flags for the range (write, read, ... see hmm doc)
  * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
  * @dev_private_owner: owner of device private pages
+ * @migrate: structure for migrating a range of a VMA
  */
 struct hmm_range {
 	struct mmu_interval_notifier *notifier;
@@ -117,6 +133,7 @@ struct hmm_range {
 	unsigned long		default_flags;
 	unsigned long		pfn_flags_mask;
 	void			*dev_private_owner;
+	struct migrate_vma      *migrate;
 };
 
 /*
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 78424b3824c2..280ec9a866c7 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -3,6 +3,7 @@
 #define _LINUX_MIGRATE_H
 
 #include <linux/mm.h>
+#include <linux/hmm.h>
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
@@ -202,7 +203,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
 			unsigned long npages);
 void migrate_device_finalize(unsigned long *src_pfns,
 			unsigned long *dst_pfns, unsigned long npages);
-
+void migrate_hmm_range_setup(struct hmm_range *range);
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..43e571e82cca 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1528,3 +1528,58 @@ int migrate_device_coherent_folio(struct folio *folio)
 		return 0;
 	return -EBUSY;
 }
+
+/**
+ * migrate_hmm_range_setup() - prepare to migrate a range of memory
+ * @range: contains pointer to struct migrate_vma to be set up.
+ *
+ * When collecting has been done with hmm_range_fault(), this
+ * should be called next, and completes range->migrate by
+ * populating migrate->src[] and migrate->dst[]
+ * using range->hmm_pfns[].
+ * Also, migrate->cpages and migrate->npages get initialized.
+ * After migrate_hmm_range_setup(), range->migrate is good
+ * for the rest of the migrate_vma_* flow.
+ */
+void migrate_hmm_range_setup(struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+
+	if (!migrate)
+		return;
+
+	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
+	migrate->cpages = 0;
+
+	for (unsigned long i = 0; i < migrate->npages; i++) {
+		unsigned long pfn = range->hmm_pfns[i];
+
+		/*
+		 * We are only interested in entries to be
+		 * migrated.
+		 */
+		if (!(pfn & HMM_PFN_MIGRATE)) {
+			migrate->src[i] = 0;
+			migrate->dst[i] = 0;
+			continue;
+		}
+
+		migrate->cpages++;
+
+		/* HMM_PFN_MIGRATE without HMM_PFN_VALID denotes the special zero page */
+		if (pfn & HMM_PFN_VALID)
+			migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)));
+		else
+			migrate->src[i] = 0;
+
+		migrate->src[i] |= MIGRATE_PFN_MIGRATE;
+		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
+		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
+		migrate->dst[i] = 0;
+	}
+
+	if (migrate->cpages)
+		migrate_vma_unmap(migrate);
+
+}
+EXPORT_SYMBOL(migrate_hmm_range_setup);
-- 
2.55.0


