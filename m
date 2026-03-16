Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2794EFCBB6
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130A36B012D; Mon, 16 Mar 2026 02:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB0F6B012E; Mon, 16 Mar 2026 02:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4DF6B012F; Mon, 16 Mar 2026 02:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DE6BA6B012D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6C3298B536
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:37 +0000 (UTC)
X-FDA: 84550937394.20.E917885
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2918C1C0002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClJE6nu6;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V/BrJfOK0p3FatgnyxIgVoOTkPBZ9GV0QiAZnnNuU/g=;
	b=ZXgZMOqDTtpK4yD0pU1CDHB4SCSZIdXyNGmWKtPL+3bqDH9Wm6rpg1/npv/xPUFUCIx7S4
	/T3Oj7A5yppe0Xg5gUwjOwqcvaqNT6C+vjfP4fdWiJbNm4H4FKp4vdzj7Oy6RV2kAnQqME
	QwEGIP0GdD6bLwG7tx2kqxNL+lETMZ8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ClJE6nu6;
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642275; a=rsa-sha256;
	cv=none;
	b=TyzjBlYepqo2hyDR1T9XHIn/r5X9jJEzit7i22s2J9h2Wnmw+UXCt0ioEijGnWcLaUcL7e
	QIWdC2Q0KSqchw9AmVPMablJaCzhHqG7mRa+UX2qMJalh5gIPrpTiayU+nnPRGBk9QaMpE
	UUMcsKCukIKe2nZPfZtyBzzMIljF6yY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773642274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V/BrJfOK0p3FatgnyxIgVoOTkPBZ9GV0QiAZnnNuU/g=;
	b=ClJE6nu61Pn9OPorw9vUhoTr2uRVvEScfHjy/gwM6m1/Dnmfq+UZfDny9TMlsuT5YqsUdm
	Y+Vmbiz5TVbB4ENPvIjxDgmSneAZzK4UtVH7Tk+w9k71fblQu6U685nYs7NnSI9xmyCoD0
	N2y8pREdBzMy/sz1zj/XggvwK7ux2Ys=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-7xBH0Gd-OM2CdLZktwRL4Q-1; Mon, 16 Mar 2026 02:24:33 -0400
X-MC-Unique: 7xBH0Gd-OM2CdLZktwRL4Q-1
X-Mimecast-MFC-AGG-ID: 7xBH0Gd-OM2CdLZktwRL4Q_1773642272
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a155efb888so2269502e87.1
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773642271; x=1774247071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V/BrJfOK0p3FatgnyxIgVoOTkPBZ9GV0QiAZnnNuU/g=;
        b=UFaoM8UBTpEnd20PtxJA8xqvVHtE73WQ7fq4W056zBojH7IW7hgPrQuIzLhQR9bIz7
         5ngyHqHHS1mtaLqHxF9YF2J4DxBa9x3yZ8tIZ7mAsOAC46aIl/OfEor4f0I7yqdC0wta
         ldmDQA6/k4mPsUKzeMRuC4CfisqSimdUlijbH47D8fU1PF5Q6qq9IOAyQBYohkP2k/wa
         EsI06FdxBBNBelpSIJyy9vxiz7QogLhPbC1/8Q887RvYJg2CJypPRG/NiVzMRd54piZY
         V1LX5DwDhsTY6R6Bwcf27M05xSssEp94j4kGurEdXZyg8wLSIEb13Iq/nXrEQB9/s4hv
         mxkA==
X-Gm-Message-State: AOJu0Yz5ewjBBBKsLH3EAuYdDrC8zfamkLzXftvYJIOxGzkxetTI5bC8
	Fo+QM16JdtbLzm0aW8CuxnGpmTWGy0koG0nmetC1zVuKi7iRfynScCOuXpEn86SEkD+I6qOqPIi
	R7xqGVuIoB6kkDFuOPbT+KFYKloeR0QP/gS48U3/IkbiCR0lSr8+k24JC3pLYIW7G28BuAL6EA5
	L84Bod7Xd1tA+Gr8a4fqYZXELYlOh4MIPPp1bYOg==
X-Gm-Gg: ATEYQzz7dqIth6s9fv5ZQvvA3FdCIL1KXjdF6e1hzMBKzz+ZYCVZI9oh5Fd6qMmOSAQ
	JJrGtIAiSChSlIWkxMn+uj0YZej2tNcM9BdtXfWZL9HnlvAAcaG7I6l2nQKLYBNspJ00s5xz9N+
	uLngDljjdBjSOGLGGZ2gOdFhxGF3R/gqcHi2q+3ltdv4XhBOwtk5JgFNpvMdfpiwhtnt9+FFEP9
	b5cDJsq96w/1uodjq3WZKb/Ip6qjpg5JQevGaKzFrdfiNyrpKl2rkjke8xUyZnnaIjSIL0nQphO
	hLcWujpRFsB0dQ2AWPDiCrcBNegRiUvgCJe8k0yUaon9tEWH4gsXsF/9ofhJDyvQivz/S52DbXU
	bNqx8j33GKFxpJPKZWwERNi7yx2eYwQ/NJjti
X-Received: by 2002:a05:6512:124b:b0:5a1:1e44:8682 with SMTP id 2adb3069b0e04-5a162b0d510mr4190304e87.34.1773642271130;
        Sun, 15 Mar 2026 23:24:31 -0700 (PDT)
X-Received: by 2002:a05:6512:124b:b0:5a1:1e44:8682 with SMTP id 2adb3069b0e04-5a162b0d510mr4190282e87.34.1773642270601;
        Sun, 15 Mar 2026 23:24:30 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e692sm3263397e87.30.2026.03.15.23.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:24:30 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH v6 2/6] mm: Add helper to convert HMM pfn to migrate pfn
Date: Mon, 16 Mar 2026 08:24:03 +0200
Message-ID: <20260316062407.3354636-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260316062407.3354636-1-mpenttil@redhat.com>
References: <20260316062407.3354636-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QGG4gDty1CWRpf7Z-BN-3WXeVl7kmd6JT4dJ90kRcYQ_1773642272
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2918C1C0002
X-Stat-Signature: nmztkropxw5aq69mai5n5r1zgcrccyct
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773642274-940605
X-HE-Meta: U2FsdGVkX19EHG0laHGiSkhgv84QYT0rPt0Qq8nRm2X2/X5aj+vK+gE/zPo/qgKN7RrRO8PNpcR4IZVtPvQ6hzM3n5m0ZwivRnMfOghebRVry19wip59sB12SExJ7x53zMkzMPEtbZHFQD/XAslq9+f/kZ9F+jlZsWWcitZv3a8xbLCKRzemo/n27TiEqpH4+gzgCoWBSlrIHgyq3mWLqRdY7iAZ+XlU2ise5O1EhXZBP5jKFby4QWg57WQ5a0rl+AkJbPFFvgA+CUTsE1kU8Lhn1gJqyfh0LzT/Ev3yK+2UlS4kD4GNf2NxgOkq/3hhykoJSZBqLj98xVko1XmNroPFNTu6vIZ6ye1CDrX+/BX6oEzZImprIevecZhB23JnHKPr5qVz+Lejd+ysCMWAK8ZlQVS6ZVyaZ5vc1YHTyuC9dMEmmxhsbImtX6QoTSezPPaFixQft/p0QGLmrTOsR1QjnO5fNjz7tVW3v8A40RbrNVf1CsHhk4AsOUGcxn/ywx5CuJIbprxu3hBE5v6QmnvONiylU8VlWx0BSztte7Ank+/Cgfx6cawLuGfolLZgHMi3z8kiaAKp0f+ZA82SApRkRCtEXT0rVM5LBJ9NO9qfKBcT6J2L7xT1la+P9LPkTD4XTYCVJDc4g65ohvpp6a6Mq0+S7NPKtXKqOvJjWsjJHj7pWLfODPI6MHnkqmBojkMn+eM54mPn81adHc1TjkIx2IEOkTny9DTlafMK+M4iPyWMj1gkUhtkCQQposk4+teaAwcjtApRqCCs6I8mxtvMmo+GdDLG151Iof/D2pi35m9ql/6WpZmmhMcgzuUqkyf35XbYgGRMAdG4f+sXrddwfNO4FHmaWUBQbXXyFZYOxXEvtHjXoeUjmvXfIKq8IZy8hDZK4TMozM4jAL59N7WN0eyF3zXTksxx6Z9tgTynEWsVPw7dGaj8NGZ1IGLVr3S64b6Ws8YwJsLKQNn
 b7aQY4Ap
 6Ht8Bix0lrVaCss0GWtTAENZHTZyMh1e9/jLegrO9pbkIj4CeOVC7DPa38D/FKSVFJt0eX5B856OXv6fGfI9s3KqWhIRlCYuBtuAh6xs+P7Fprb5XiDAZMwKjw5tnxqjaVrkivW+pqBHC0t/dIpI/CkITq6syYbasrLuWY/k3g8oMvWQPORaDiUafKdKd5AtG4d+W6NsTjd1PIPn5nRKTLRk9nWP9BdlysiOC+4cJQHpWivabwvECnhXlBCLdJdubPIzTNqZ/SASRWE81xevLeIY3txDFG8wvIf97vMRPeoMe23/tBRqa07THTi3Vi63Fcjo9IwqXTm7Pq1vIPu09iyFxUC08I7kn2rnznbiGH8f+/nC05mEu/RqaY8KL1qQAV1JuR0U089YIWZvwE6e8L2/w3TOkkVbDaKUV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

The unified HMM/migrate_device pagewalk does the "collecting"
in HMM side, so need a helper to transfer pfns to migrate_vma
world.

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
 include/linux/hmm.h     | 18 +++++++++--
 include/linux/migrate.h |  3 +-
 mm/hmm.c                |  6 ----
 mm/migrate_device.c     | 69 +++++++++++++++++++++++++++++++++++++++++
 4 files changed, 87 insertions(+), 9 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..b5418e318782 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -12,7 +12,7 @@
 #include <linux/mm.h>
 
 struct mmu_interval_notifier;
-
+struct migrate_vma;
 /*
  * On output:
  * 0             - The page is faultable and a future call with 
@@ -27,6 +27,7 @@ struct mmu_interval_notifier;
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
  *                      to mark that page is already DMA mapped
+ * HMM_PFN_MIGRATE    - Migrate PTE installed
  *
  * On input:
  * 0                 - Return the current state of the page, do not fault it.
@@ -34,6 +35,7 @@ struct mmu_interval_notifier;
  *                     will fail
  * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
  *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
+ * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate to device
  */
 enum hmm_pfn_flags {
 	/* Output fields and flags */
@@ -48,15 +50,25 @@ enum hmm_pfn_flags {
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
 
+enum {
+	/* These flags are carried from input-to-output */
+	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
+		HMM_PFN_P2PDMA_BUS,
+};
+
 /*
  * hmm_pfn_to_page() - return struct page pointed to by a device entry
  *
@@ -107,6 +119,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
  * @default_flags: default flags for the range (write, read, ... see hmm doc)
  * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
  * @dev_private_owner: owner of device private pages
+ * @migrate: structure for migrating the associated vma
  */
 struct hmm_range {
 	struct mmu_interval_notifier *notifier;
@@ -117,6 +130,7 @@ struct hmm_range {
 	unsigned long		default_flags;
 	unsigned long		pfn_flags_mask;
 	void			*dev_private_owner;
+	struct migrate_vma      *migrate;
 };
 
 /*
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index d5af2b7f577b..425ab5242da0 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -3,6 +3,7 @@
 #define _LINUX_MIGRATE_H
 
 #include <linux/mm.h>
+#include <linux/hmm.h>
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
@@ -200,7 +201,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
 			unsigned long npages);
 void migrate_device_finalize(unsigned long *src_pfns,
 			unsigned long *dst_pfns, unsigned long npages);
-
+void migrate_hmm_range_setup(struct hmm_range *range);
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
diff --git a/mm/hmm.c b/mm/hmm.c
index f6c4ddff4bd6..44699e28c551 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -41,12 +41,6 @@ enum {
 	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
 };
 
-enum {
-	/* These flags are carried from input-to-output */
-	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
-			      HMM_PFN_P2PDMA_BUS,
-};
-
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 			 struct hmm_range *range, unsigned long cpu_flags)
 {
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 8079676c8f1f..b320ea3736b4 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1489,3 +1489,72 @@ int migrate_device_coherent_folio(struct folio *folio)
 		return 0;
 	return -EBUSY;
 }
+
+/**
+ * migrate_hmm_range_setup() - prepare to migrate a range of memory
+ * @range: contains pointer to migrate_vma to be populated
+ *
+ * When collecting happens by hmm_range_fault(), this populates
+ * the migrate->src[] and migrate->dst[] using range->hmm_pfns[].
+ * Also, migrate->cpages and migrate->npages get initialized.
+ */
+void migrate_hmm_range_setup(struct hmm_range *range)
+{
+
+	struct migrate_vma *migrate = range->migrate;
+
+	if (!migrate)
+		return;
+
+	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
+	migrate->cpages = 0;
+
+	for (unsigned long i = 0; i < migrate->npages; i++) {
+
+		unsigned long pfn = range->hmm_pfns[i];
+
+		pfn &= ~HMM_PFN_INOUT_FLAGS;
+
+		/*
+		 *
+		 *  Don't do migration if valid and migrate flags are not both set.
+		 *
+		 */
+		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
+		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
+			migrate->src[i] = 0;
+			migrate->dst[i] = 0;
+			continue;
+		}
+
+		migrate->cpages++;
+
+		/*
+		 *
+		 * The zero page is encoded in a special way, valid and migrate is
+		 * set, and pfn part is zero. Encode specially for migrate also.
+		 *
+		 */
+		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
+			migrate->src[i] = MIGRATE_PFN_MIGRATE;
+			migrate->dst[i] = 0;
+			continue;
+		}
+		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE|HMM_PFN_COMPOUND)) {
+			migrate->src[i] = MIGRATE_PFN_MIGRATE|MIGRATE_PFN_COMPOUND;
+			migrate->dst[i] = 0;
+			continue;
+		}
+
+		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
+			| MIGRATE_PFN_MIGRATE;
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
2.50.0


