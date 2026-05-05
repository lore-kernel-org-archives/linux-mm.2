Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4360ACD3430
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 05:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC8916B008C; Tue,  5 May 2026 01:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52FD6B0092; Tue,  5 May 2026 01:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AD46B0095; Tue,  5 May 2026 01:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 763736B008C
	for <linux-mm@kvack.org>; Tue,  5 May 2026 01:18:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DF8EC1A64
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:18:07 +0000 (UTC)
X-FDA: 84732209814.26.AB70B28
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 034861A0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 05:18:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DuSY8ViO;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777958285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjER583RBr0CQSaYsQDNT5myJivjc3r5S+eofqbfVjE=;
	b=npJ+tPVKPz8abPYDcm3ZXSv/KQCjoaftQjMz8rtNAlzzWOY3NLlYqfiKLCmWK1pYIOYEPP
	lCN3wfp+qTLFjDQiOZPG5bEb843h7j0GUA+KIYuKUASV+/bxT/AQhqEE87N9+s7+PNf5mG
	/UX2U4wT5aFfKeFtxWcN7V6t7Gy4E8o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DuSY8ViO;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777958285; a=rsa-sha256;
	cv=none;
	b=womVmAMTn6Sheq7ZRZTuA2OYJI/O/yFyB0px1t2ORebUrPt1LjygHDKHowrXxYeuRzjWjK
	JYvQl4seN/6Anw84K+84LlRmH8IGrCVGqI0KybEh4u7I9OR+R+7B6EhnWD/O2hZ6mFF7TG
	IeYVOadXdHL6oZiUFcmwyWA2XZYc7zc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777958284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jjER583RBr0CQSaYsQDNT5myJivjc3r5S+eofqbfVjE=;
	b=DuSY8ViO16nvQd12ymKYRnag+O/uACxHqKWxTvdHQlUCSBCDy6VBL3KJafIMn3F/aHUXLd
	GD3vmRs/CSQqIgkdQjWy67t0L/HrFLBBfjD9YxGWEJazyZWwaXwvNs9IGfYx2QtwADADf7
	jn8vjbqz37uLS9XR7K+HeTheCsYcTYY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-JsXSQyFlOJSsp5OZhFYKWA-1; Tue, 05 May 2026 01:18:03 -0400
X-MC-Unique: JsXSQyFlOJSsp5OZhFYKWA-1
X-Mimecast-MFC-AGG-ID: JsXSQyFlOJSsp5OZhFYKWA_1777958282
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-393a63d9681so8197501fa.2
        for <linux-mm@kvack.org>; Mon, 04 May 2026 22:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777958281; x=1778563081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jjER583RBr0CQSaYsQDNT5myJivjc3r5S+eofqbfVjE=;
        b=pf3MbQI5QeA4hdyQUkXp7jK2RM50Y4uab6p+y5iKLxOzhbhoQMeLQLLr0gUTN9BDtg
         Zyc3KXjKC0AFoLOtFL8zvva2fTXQ3DT/Y9m9myMoKiiJF/5IaKVbByPBZLvq811XpXLH
         wLeN3JsWHhypBNjZupzw5RQjp3tMve4Z1JhM8YHDL9f3GFi9sWvp5rfu+CD9wyHneNN0
         7hPG4AD/i/zk9l6UIl7185DTxDQSnuj1Ygo5V4l3g0EPnt5rWj++WyrKSdSwaAHWXg+b
         hPAg4A0FdV/Hq/g5kpCHGRQ2Y+wZD0Evl3of2tnfBB24GDO77AyZfcQNB0knQJvqFjUx
         bGag==
X-Gm-Message-State: AOJu0YzMq1nfW+6G7syeTW/Z83WmOZj9wzgfMR6weXgaYBmc+ZkrhnBt
	pgVd+tYxqFrSDLG8k4KLlUKxjb6ph1wPTmnbnDJ3LA96FPBiavXkBQ8MH9L+AYoVbKld+nu3ORN
	Mm47NPZRe8ZC/f/Trp59Y/BBAOMvCrb56y1K/lF08/iCaaZ7D++0hs9Ra4BQDqdT7VPHL+x2YQl
	GiBDJjPTjcocplaKy/6mW+QKW/2H9U/HW5uK9OeQ==
X-Gm-Gg: AeBDiesPlhsAW7QF/1aVwbbfOfJJ8VO7FH7TkCXDxtBnleQ95GhV+w1pboQUmvaAfh7
	POZdADSFhbohcWkLssRbDLtqusiAZK1TNQ0wIC4YMgYMTR29779Roj9rQ2J57vwHZFJguTa2Pxh
	bd2UFXVtv6wM8WwkKLrTput4F979kranLwcdUalVYP1qv3fsbbvrO+/kp7QfSvYbQEXKLHSjRkv
	IHtIMSFLQHdaXObhBhV911ep7dnsJA8F2LSwC0BnCFN/lfkPUzirLCbIp+GFhv1e2c8jN8PjNML
	ScrLbAsPQIm6679ZmDViB+/VPdmM2RjSBIfGt9F6bJBBGHqPo55VT1WkeG8DLsKksiLYBGpSbIR
	PiMAMxV6BpDDjCccdj67z/G2p9mdq66z/XZc4g0TM2WIOUPk=
X-Received: by 2002:a2e:a60b:0:b0:393:856d:168d with SMTP id 38308e7fff4ca-393856d4ad6mr31366811fa.26.1777958281102;
        Mon, 04 May 2026 22:18:01 -0700 (PDT)
X-Received: by 2002:a2e:a60b:0:b0:393:856d:168d with SMTP id 38308e7fff4ca-393856d4ad6mr31366521fa.26.1777958280487;
        Mon, 04 May 2026 22:18:00 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3936138935fsm37206141fa.41.2026.05.04.22.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 22:18:00 -0700 (PDT)
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
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v9 2/5] mm: Add helper to convert HMM pfn to migrate pfn
Date: Tue,  5 May 2026 08:16:55 +0300
Message-ID: <20260505051658.2219537-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260505051658.2219537-1-mpenttil@redhat.com>
References: <20260505051658.2219537-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3hHfAxVSjRUTbERFOqx_9K7gq_iJ4CA6-3d8_kGwuZM_1777958282
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 034861A0002
X-Stat-Signature: h7umjf9f1rpj7fnnhncfc4mbckkist8h
X-HE-Tag: 1777958284-915811
X-HE-Meta: U2FsdGVkX1+epHAzZ9+AnpQseQEnV7gQTz+XHFSjwctO1cn/2AvhqX2yNo2BD+DxGNQhJKHJOgYkCOn45ZVomC5+xXtvfV6yt5EKUTO8ywKsPnEHEjJI7JtPA8wTkOt+sG48MLXlu/H5xvhWLElQalg60L7/HckTjM+rvAuRJT9y5IAJEpAv8wA5VTzc0MpBjcshPUscG3R7+nognBLIUi1gT7g0dxX49P1OvsV6YhB1dRY0Vlsa1R0GrSHwy3ULOqDpEhbMnC7n4WpYQChARJTSvXgSOP6FsFbFRCvMAtkhdqb11B5fe7DJnwNga+mZEC1/gT03K56S/tSBKONMqhvArbS5z4/Dlfw/TbtdJ1Vi/wncC6rjjprRdqNloVaV0BEVohej2etnL1fXsWbVcRbsRSlehlCIhFF4biiST89K8oIlWVA8Xb107/jZ4hdCovSloHtHDwPusxuB7zcehzYhzUcJXIG+5/HZHARWCJCGBzGBpSd1iKU98OOYbvONK5Tz2L6G2PlZdI6PLiUV0g6L/R+8h/unZI1ons2ZolTHotDq8LKObLG2G3xag843g4glaDiPHi12vs4YgxSG0vEJRGv6aAK0X4vJd7XCquKGxCWuv+6F0N4KZCq7bprOUkd3WvWO/rNFfAnbKg+3rZkjBGZvyDhasM+Z8ORw/jSZDc1RLqGlkkWa2Q1LL7f3mWZGgLZlU7aUeg4TMyKJk3rkERxy0tQV0zZxD94x+LdpUsJiUa/7jxY2Dwus9mRdqPsCGkDUKvn/vBrsPwcssQqV84aqanL1R7yqRre8hBiRCKZ1LjQBRWLuwKpob2ZcI0IVm0YZMJSG52tsNmjLTytY5i58NN+R4tlTZ+lKtt+OdOi59hUJEbVAhOD8uuLSknSIwGTpFmNyHPpStLahpilKlnGzIxRV07L1jJ1tARyz046IKTE51FW1qXKShvJnDeJjcrpchQBTt8WlgNz
 xb8KWcw5
 nDRh0BvCwrx8R9SFmlaAzZRDqoNJDLIro+YevecpoS9YvcbK743wiOuSsqgQF0eprMbvvK+P2EdmLY7ARSPGlNIYdGHsg8bEfY/qRO5rWbQAIh8DrjABf/x3dht2kAA6tBImf/q3MDnMg3t9Lg+QGgOTuTzpvpTrOQlnKSrqmqpFURkpg78xgiB6Hq2NxAa2GBIkgOJebCtCpq5ZSbfHbCvXFbaFi6j+HgsPW5eusjCWZF2G3+YTg6YlOBw878lIf504pPeNT+3dyAO5/FCOqYlsCXrxtxprQKnenaD2+a1chGKoPuG5KhfdIcPwI+7wYAgWIlxCBHMTUqBSctYG0WsvIBsjp+qgghDiB4q2sFIK60VRiXdGJythm7XPb2BkryxO0
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
 include/linux/hmm.h     | 19 +++++++++++++-
 include/linux/migrate.h |  3 ++-
 mm/migrate_device.c     | 55 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..bfedafc1c143 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -13,6 +13,8 @@
 
 struct mmu_interval_notifier;
 
+struct migrate_vma;
+
 /*
  * On output:
  * 0             - The page is faultable and a future call with 
@@ -27,6 +29,13 @@ struct mmu_interval_notifier;
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
  *                      to mark that page is already DMA mapped
+ * HMM_PFN_MIGRATE    - The entry is to be migrated. Note, HMM_PFN_MIGRATE
+ *                      alone without HMM_PFN_VALID denotes the
+ *                      empty page.
+ *                      This flag together with HMM_PFN_COMPOUND are
+ *                      indicators for migrate_hmm_range_setup() to
+ *                      setup the migrate pfns.
+ * HMM_PFN_COMPOUND   - The entry is represents a > 0 order page
  *
  * On input:
  * 0                 - Return the current state of the page, do not fault it.
@@ -34,6 +43,8 @@ struct mmu_interval_notifier;
  *                     will fail
  * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
  *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
+ * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate, according to
+ *                       hmm_range.migrate.flags
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
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index fbfe5715f635..3287053af00a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1487,3 +1487,58 @@ int migrate_device_coherent_folio(struct folio *folio)
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
+		if (pfn & (HMM_PFN_VALID))
+			migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
+				| MIGRATE_PFN_MIGRATE;
+		else
+			migrate->src[i] = MIGRATE_PFN_MIGRATE;
+
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


