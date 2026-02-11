Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19CD3EB597C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 08:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B524F6B008C; Wed, 11 Feb 2026 03:13:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D4036B0092; Wed, 11 Feb 2026 03:13:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C376B0093; Wed, 11 Feb 2026 03:13:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD086B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:13:42 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 046B613A146
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:41 +0000 (UTC)
X-FDA: 84431461884.11.8CDA0AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id E0D9718000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RDHb5OhK;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770797618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pN7sR3vsA193k+Zi8CXWZHG9IV1B38HGrk2ADk7gKWQ=;
	b=bfhHhzyr4fFYFyfXz3ZqagFF7wJrUa0LfJkWbW4Lke/d/lUSmXG4xG4igJ4WntJuYB6GlO
	dpqnrGa2iYCsJAjUkqqB08nl+/+QiIMKc6CLn9B03yOjTQU6sqziG94uPhNqaXl/0cySOa
	j7ndk/GotKCjCJi+fMHLt9WSDp1FHvs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RDHb5OhK;
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770797618; a=rsa-sha256;
	cv=none;
	b=gKXNj/k5n32OG4/evlfJCMXEWB1C6MrY/mzwkHHiQvvZKPX9nNLK5mYZoYprzkIEHtTSi8
	fSNCHMGetHKNyew2ffrl8NxTeRpj1b9UH/b9xHjmH9GVS9FpIJ0g5qvLF88vrvbSw9S3Dl
	z4pyu6xdKPhHXP64B9IC8GNOlT75z9s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770797618;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pN7sR3vsA193k+Zi8CXWZHG9IV1B38HGrk2ADk7gKWQ=;
	b=RDHb5OhKpWjSvZ4tTAe+oyBWL+Rba2T24jqLT7K6zJxXvS1xTG4msG4tXnu+3QQgFqvUQu
	VRxvTiK9UlNQTmSO+LjOgE13csA/b+CKStY6RO+NjR0sT4J/ADxccRsxT2syycEZ8CCKXe
	JSVLPfWOKoB6PDMjHj1bgUYaOlvVd+M=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-191-bduYMqZuMqi1jkN7F524DA-1; Wed, 11 Feb 2026 03:13:34 -0500
X-MC-Unique: bduYMqZuMqi1jkN7F524DA-1
X-Mimecast-MFC-AGG-ID: bduYMqZuMqi1jkN7F524DA_1770797613
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59b77f5f4cbso3840375e87.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:13:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770797613; x=1771402413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pN7sR3vsA193k+Zi8CXWZHG9IV1B38HGrk2ADk7gKWQ=;
        b=wiZszhaUaaYpaM+lvVTKJp8hK3QBJR5NcqGCISzfGqSjjwMDh/XPeZB7Ok95VH3rxl
         t9ek52Q6GVpTZWar2VBWmlDrWulSvnwfB7/8Ltd2QqyjemtueYO//WxbVSdj2WP+9iHD
         CbQ/26/IqJH80Y+FrahvzYnBtuhc8bEBB2r1WNhCVdmp3MoEKSlKyiLB1W0XhVxvh0KB
         UitFkaWCF7LxwZjGNbPpJoJ8XTEmjrqltZ9KCdtThY67JKOgUGKOw1mihUDSiRHJUg4E
         LKNtIsO+++v9ZVS6E0t6tzIvTRDLwF7eZIMciUfxWuV3mNAvbGy0wviLxFvnQgu4wNFy
         027Q==
X-Gm-Message-State: AOJu0YxvFbtdsIfWW+CepxCTF9/FRTLTsPOp1y9917YH562TkHIQeSy9
	A3eHjxeKYePeh/klTFLuKMlDGb2MJZ/TI9U3ihZhnjv//jbp87IHlVTpcGzGo+sK79iS2PzTPvU
	Hc1UrPBXFkOgWkkDljNm+gOFEFsuST1XgbxGXkpqxFYSMGPdZj3Bk7N3+iMvtr8vd55pekEXAWC
	4kcoCFsnUHib+ytyLVxBrttDm+kAPkh5uW8Is=
X-Gm-Gg: AZuq6aIUs+agdfqyDlQoQX7tyMuag8VGfdJnNL/R8aHmBtAqmGk42o3C3/lDDPmBoqH
	HFr5Cf+sYtkpdzbaHkpfSa7tA2roEyHnq3XCVoD01ZJZ9Q+mbZ4RtyMehvvoKhmg9HD6u5Pa/cO
	9FDN5n/5PHFSkT3XRti0HXmotpBdxPcTVCgh6bYnMierLyJOJbTIlcVbiiUupfo8QOnTbY6aGck
	wRMvqpzA2ZdKN7kUfQXlw/66iNOz3QSyE7sh/EGD1VVEXB9LGXrpFyQ3xm6HTECVwMtrrcPtlIP
	xpL1V00iga/OdFajlXTM2tx8jvtofdOHotBxi0El/L5HeZYs1kWENylnllvIzTZjBD7MjRBrSTo
	R8kIYAI573M6qBo3ov3nlGMuHP6dkU8YmVcW8
X-Received: by 2002:ac2:4bd2:0:b0:59e:4f8f:aa30 with SMTP id 2adb3069b0e04-59e5df4663emr419300e87.3.1770797612942;
        Wed, 11 Feb 2026 00:13:32 -0800 (PST)
X-Received: by 2002:ac2:4bd2:0:b0:59e:4f8f:aa30 with SMTP id 2adb3069b0e04-59e5df4663emr419279e87.3.1770797612413;
        Wed, 11 Feb 2026 00:13:32 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f568737sm188515e87.21.2026.02.11.00.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 00:13:32 -0800 (PST)
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
Subject: [PATCH v5 2/6] mm: Add helper to convert HMM pfn to migrate pfn
Date: Wed, 11 Feb 2026 10:12:57 +0200
Message-ID: <20260211081301.2940672-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260211081301.2940672-1-mpenttil@redhat.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FEu5JhqqfjxmdbbQ4_RsZfSjacUPb4ThZjH0JBgjYuI_1770797613
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: xut5a585oqocq1m51dd4hruuxzmosq6c
X-Rspamd-Queue-Id: E0D9718000C
X-Rspam-User: 
X-HE-Tag: 1770797618-74940
X-HE-Meta: U2FsdGVkX19iZziQmSqUj1uaL9Dv5J90GT4P07qBusidnj8fOASmhpv6NRTXPSIbb2IjIMyXCgBOPfLN6UaOQIVHuvtLVXGAGYt4f6BboPc+UrX93sXBplPkmrlTBP9+bQqBTQi9ZVxVi5LT7ORyaAbDadqLq5f77imBkQfidH5yrwJJ52l4JWNjRGNgzwWjsb/0hjPqjNk7qfJ2trk6kHFxqGFpsNwzuK0YpOu492lg+GOa7U6WDRtcILjTCuJkfxvHX9I8uwhH8UrUxScQRiolZtP4+SvbvfY6PedDEGfljpwDdu2GsWuKvI96Ve/LRfKgsWWuWtDg7y5d3pOnPpfH5ZgtpC2JaYxfc/1HtAcVag0S8N8rYFXQ/nfGtVLoDpazbY7j6ZzEWRD++JgcAtQJA9pYs8qUM+W9K/1wZgXRVugNm2klJTwaMPLTOfkfN+uBrlFTpobhpNSCKP459LVaTqh8q9B4/mqr8gYASBzuIpx12OJelUQYFVc2ZFrwSHOBoYBV2nQd+54c1DbOHV1tBC7u5o0LG4OhrcREVflpGIXe7MP0bbMGxvqHlVNPt1awpGp9YqpF0pfN3dTyTstd25rMJ7J3qmZbrYMwa3tJvR0OjvwZkCPvF/71VnoeqGXOnaxfwfLaQUWuKoxK3vsHttV020+I48C5d3Uc484vNIziTvufU1txTYz7E3WbqG1UfvrdY78s6CDhzh3UlUdr97Vqc0e4ZOUgL6vJfl0DJaMOKKuHPBkYHfHxAhH1uqBOChFSU3a5YR/lbTMvS5mo0N6mQRvwRSZhJX72rAsVnKctpoO+Kk+FtyYIknbrpwxmCrOGQYV/eUvkNtJCxBpDV+ThIF3JnhPhFBmEyYwngxTHuWDI8KUoVlu1SVWnXLRVnaQnDfTEMZM8bZHAYd0EtBLQ/nnI6I30HuiYeF0+Xv/SJmD2RNg/J08ON8ULeD/KfhZ1Xba2B61zrI3
 PY66/O8T
 CjFni34GqERY/Qumog8+1O+zgNYGvYwVQMZTksXkLA7dKa5/6aS5kCmgxte18oHyTlvVYq4OtUjgWnx9Euv1dZvCZNr34bVtQCCKpQPOfrOOH4J+Tu6qF+Dxhha0t0NRGKKCiv49kgY+eQxNbWY99KS2H4UazownRpH1MUMP/htaXmhmSLyQIFQ1iWpMqFO9yf6qrXf4YMfFY0wSFYcRiUBXrCKcVQ5Rj9H/o1uJ9IRMSneUCJtcr18CENx7KanNaolKq3f+bwBXJcMnRW8P59uc+9PZtl3z4ozEpy8+VZ7x1OATgnLfQlhpq4qhZUesUMdqigMkIBMpn69V7R4NCRXR6nLSqz+/kImKJCbwgfkzrfAZEj8lti0wCFb7fg1MFRW6ZV8v5fQEGWpIvLyit5F9pfYvcFqA9UOZG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 26ca00c325d9..8e6c28efd4f8 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -3,6 +3,7 @@
 #define _LINUX_MIGRATE_H
 
 #include <linux/mm.h>
+#include <linux/hmm.h>
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
@@ -192,7 +193,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
 			unsigned long npages);
 void migrate_device_finalize(unsigned long *src_pfns,
 			unsigned long *dst_pfns, unsigned long npages);
-
+void migrate_hmm_range_setup(struct hmm_range *range);
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
diff --git a/mm/hmm.c b/mm/hmm.c
index 4ec74c18bef6..21ff99379836 100644
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
index 23379663b1e1..c773a82ea1ed 100644
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


