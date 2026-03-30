Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C62010D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA2A26B0098; Mon, 30 Mar 2026 07:56:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53136B0099; Mon, 30 Mar 2026 07:56:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B746B009B; Mon, 30 Mar 2026 07:56:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89FC76B0098
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:56:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 58CAA1A0598
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:53 +0000 (UTC)
X-FDA: 84602577906.16.7B7A8F3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B8D12000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:56:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J2aD9hm2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv61ajyCc+m1Zr2ihJsLPfcGnhj6kHq30KwJ+MzkSds=;
	b=xx1Lw2gM1wVrRN3lLfC8AHplVIwxZi88hzf1jrwtCuMWgesyeeBdhQ1G25nLC3nV9OT3ry
	MdZ7AMYJAwcGTl/nsiHRXC5rgAQzt/izKdQ5a/feFa4ugNlzc8r9qovDTk3UnpvHaBl5Xu
	gXAEGsfxCUHRdTtyimG12SnoTGqDpuk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871811; a=rsa-sha256;
	cv=none;
	b=XuuJuuJ/6GY6NgSJ6dCiL8s7JAUVmIwAHZmw16JBV03oWjKk/0LgWwLAYIAAl3WsyyRVzW
	tEJTclwQ0N4lw89EBovFMfyRcvSkBk5/VsOccRApQJuVqCxK8vwcLqocIdTQeFI897GLKS
	cJR+Yn5XRiZkaDPukAgziVyn5bvb66o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=J2aD9hm2;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774871810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kv61ajyCc+m1Zr2ihJsLPfcGnhj6kHq30KwJ+MzkSds=;
	b=J2aD9hm2d2yBr9F2HyaFMbqSfJj54FsQ/bsBwIG6eImmxrh/S+qQxfbSycyrnRpPSv7qQW
	g2A3uKhEyALA9E0PrbinaeZ310WkBAaZ8vm+il4ipnRgj/7cPYMkVzV/OHXcnkUXi9zhto
	RTixX1dL1fqpk1Tu0kF2e+oUeMhcL6c=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-gfVD6B9wO_6IvhSFLLbgbQ-1; Mon, 30 Mar 2026 07:56:49 -0400
X-MC-Unique: gfVD6B9wO_6IvhSFLLbgbQ-1
X-Mimecast-MFC-AGG-ID: gfVD6B9wO_6IvhSFLLbgbQ_1774871808
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38a7b2630b7so20037761fa.1
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871807; x=1775476607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kv61ajyCc+m1Zr2ihJsLPfcGnhj6kHq30KwJ+MzkSds=;
        b=HQvDa7RnoPECJSDRBy9h0ASSuA8jdtui56hVzxwhIRlhC23DybBIeNbaswsFxrDU8W
         HmHO9Zf6ZT06LauHX9y6/m5OgaTEZKBpTA9+/qogeWGKCius3IdDd4L5tUu/N6Xvfsgd
         T8Ha7W+l2rTJOOK5cQQXQZlFbVBpGBAdjD+6vlEj+rYQXznU789Q4L2yG2WNXP3nNnnx
         IP8FJZXD5c1yE2WSQy13GVdLgzV5fbdd+IMikIPP5dmmJEjAQs6bWfMJpaspIvbCCFJ+
         2RBVLu/xYkCg9btctB81V2ZCIKVAdd67csMSkVtQqOIIMQ/enin9Vqvq0NiI1C+Rl8cI
         D2qg==
X-Gm-Message-State: AOJu0YzxNJ/kn4NG836S5vZeztuUOxvHHPApPWyXWer93un/v4KaPMB3
	lPpGe/sgU4IymAHTpyC0780pwpJE7p6+2C+oMI2iLt2ypwXLDL02UUTs5YP7AKA5wyIBXy4m4Io
	5kQmXwLzEzfuy9hSg1IqioYVyBPHs35VKWWYdhoaYGQTpQdBgUZbndirD6cNctOg00j+B07TZFs
	AFzszpl+XblIsLj/NzhsyOphCV39tuvp+0CLZVHg==
X-Gm-Gg: ATEYQzzj/vEZT4EeWoT4mzvW/LWE1YALCZWs3J+uOfyY2PPllsXLL+ueNdDgqQ7fMbO
	AiUIxcCe5RUJJwPh/doFGPisa5vO8YT0Prlm/T6FXMMtmg9kNUBYeJwSuImIrL/lAscQbR0dYrr
	VaHsaUx6W/8Uot79kIH+QPcSkh4S7+rLDlaXEz5ivLRrFgxXXohEx9kq4f0M67Mz6GpC+KYWnNs
	7xG4bt0eM8janP80PXlR+8f7Ci3EWeS4w9jlyqXZerP6fd1mab41WMm7VoMjHzHQf5yBPt5OKZb
	XocgTNpuMnQY9ZbgQ7xi+O01PfQsRk0z1MK61BK5UoCYzvm/IQqg8qZeKbbnB73v+iKxbQVCBf7
	ljHR/hyquWekDAt34+g83px+2dptvOrLQaZlb
X-Received: by 2002:a05:651c:994:b0:389:fb7f:3def with SMTP id 38308e7fff4ca-38c73374c9bmr46215041fa.23.1774871807383;
        Mon, 30 Mar 2026 04:56:47 -0700 (PDT)
X-Received: by 2002:a05:651c:994:b0:389:fb7f:3def with SMTP id 38308e7fff4ca-38c73374c9bmr46214751fa.23.1774871806766;
        Mon, 30 Mar 2026 04:56:46 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c838daa4bsm16330071fa.32.2026.03.30.04.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:56:46 -0700 (PDT)
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
Subject: [PATCH v7 2/6] mm: Add helper to convert HMM pfn to migrate pfn
Date: Mon, 30 Mar 2026 14:56:07 +0300
Message-ID: <20260330115611.347988-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330115611.347988-1-mpenttil@redhat.com>
References: <20260330115611.347988-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iAr-W_wwnCXL1MQ0SibtXM9rb_9skhx7GCtV7vsW03E_1774871808
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1B8D12000E
X-Stat-Signature: 668m5b5gibs6yjirifuwodmwpp61haa4
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774871810-490287
X-HE-Meta: U2FsdGVkX1+0WpKfKrZfaSlK6KVMfPQZpqgpo0UBN/jyUtMVk+a9Lle74NJ58tIhmwmmaqy4MNvba6ISgb1C0F/6XxWogZl+sXFjtUglBwOeLTmGTmB73JJZ3goHwonTErCqRqYboSkeIA36/8jTal9Ffa1+X1zjFNCFRVsd78WK+K7mIXNTKTB9Bushl3amDRj71K+VwfgAu46vEd+pRrtmBIJarygUicBD8P7iTuJljEoNjfql6yU8yVwjjG5PQ5HjYWJdRQm9d2TgTla30XXOM1eH+Cfa0sfveHxJvMqLFdpTrdDztyG4bD/lT/qYAxzYMAzvsdZXIFHwzpbNgPIHNtqD7ebNXV6E7EnB4sPiJPl4512mrqDLfv1Kzi/l9mRe7quexDY/EFFzhE1nflk/73TicHhf3DVBA/dqu4uzHQ3fRkd77sec8EdigE+JrWXPptVBMxFjls1C4C7DN3PjOJh2ot9gn0KM/eWKGDtBd6Az3HzcyisiPgIkAOZTmirVfops+frsgIKVI6XxL8mqCel8Y/0FecnWt27dw4Pt22mJLC2YC48RbKD40Z8KEwdi47A1Qbu6D05maJ+AlEL9t9kyGtKxVUEUdVUjhpXAdWqE5HUS8Nz2w7jR7ycJ1aItZTGIeOQIlPamvaNsItEN+g7lyyJI7pGwzNzaHvWi578qUlGhE/L4zKrthEONN4CWBt+dZz/5L2yO8Rcja80UsX08JToFPDPe1q80DjmqwUrkv7NSjfGq+URUzWkKkSgum4fTJQz3tS+g87q23royZFeSvtI2RDnB5Yluf/1xL562xrLO2mca649IN9HG5Pt5OO7cVeJbf34UiV4SAWVC7Dm7APQmya7oH2Wel7wz8FiuRhlZVqDhnLMLde2LSqQfe+emSOPctvDTtnLoWhchffPgjKsRbBbWyh7wRo59LWE/OfYdtiFZ6ILEPB05EgSSq7di8F6hRvYy3Wq
 R4Cr5AYr
 QECSS1/Z9qyokUxMXnDo9P6du+5wrOzFgNP35KkDRj4k0fYFTneo/Z4EmF+DnonWBnHCP5aVwPVMWQnBmUl6cRZlzEN97DB1T5wGfCpqbNy/J6rG4Do+VCpfpmGbDBcJ/U1KVyi0Y0rAfprNnmdDvKdsVtNyN0kvrW4buXXfyh8BaNScYHrrKDEl6nXe2qHXV8Q3dZNpEnCYyN9Oi2pqX95iQwAMoc0r8hW8eisEOveluw9AeMdi/Z7ja6mQpgGdC121u12L9JOjeFLfouIZ0AqbHn8sV8YujAtbxSGHPCPH7Hhmn/RVLl/SQIoSlJ9d5uFwQICsaQiww/Nn43b9hwkAB9HDB5B4dnT0rIUzVbMn2nExuWV4cLN/5OQ==
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
 include/linux/hmm.h     | 18 ++++++++++++-
 include/linux/migrate.h |  3 ++-
 mm/migrate_device.c     | 57 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..9adc22b73533 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -13,6 +13,8 @@
 
 struct mmu_interval_notifier;
 
+struct migrate_vma;
+
 /*
  * On output:
  * 0             - The page is faultable and a future call with 
@@ -27,6 +29,12 @@ struct mmu_interval_notifier;
  * HMM_PFN_P2PDMA_BUS - Bus mapped P2P transfer
  * HMM_PFN_DMA_MAPPED - Flag preserved on input-to-output transformation
  *                      to mark that page is already DMA mapped
+ * HMM_PFN_MIGRATE    - The entry is to be migrated. Note, HMM_PFN_MIGRATE
+ *                      alone without HMM_PFN_VALID denotes the
+ *                      empty page.
+ *                      This flag together with HMM_PFN_COMPOUND are
+ *                      indicators for migrate_hmm_range_setup() to
+ *                      setup the migrate pfns.
  *
  * On input:
  * 0                 - Return the current state of the page, do not fault it.
@@ -34,6 +42,8 @@ struct mmu_interval_notifier;
  *                     will fail
  * HMM_PFN_REQ_WRITE - The output must have HMM_PFN_WRITE or hmm_range_fault()
  *                     will fail. Must be combined with HMM_PFN_REQ_FAULT.
+ * HMM_PFN_REQ_MIGRATE - For default_flags, request to migrate, according to
+ *                       hmm_range.migrate.flags
  */
 enum hmm_pfn_flags {
 	/* Output fields and flags */
@@ -48,11 +58,15 @@ enum hmm_pfn_flags {
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
@@ -107,6 +121,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
  * @default_flags: default flags for the range (write, read, ... see hmm doc)
  * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
  * @dev_private_owner: owner of device private pages
+ * @migrate: structure for migrating a range of a VMA
  */
 struct hmm_range {
 	struct mmu_interval_notifier *notifier;
@@ -117,6 +132,7 @@ struct hmm_range {
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
index 8079676c8f1f..a4062fd21490 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1489,3 +1489,60 @@ int migrate_device_coherent_folio(struct folio *folio)
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


