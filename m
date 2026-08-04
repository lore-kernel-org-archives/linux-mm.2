Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA980C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60FC6B0095; Tue,  4 Aug 2026 00:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11AA6B0096; Tue,  4 Aug 2026 00:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9606B0098; Tue,  4 Aug 2026 00:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 63A606B0095
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C1EECA08CB
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:03 +0000 (UTC)
X-FDA: 85062301926.16.FF3DCB6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8364D40008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cgANNcrJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihGGkS1db6JGdRXvy1Z/cqvAlkfUAiXTBTA07KJEz14=;
	b=3BZ77aH4/rNNqGLd68qnkpDdNq7/nQ9QrEHx+ms+Wiz6gZiZnhtXabuxPXDYpr6o1vPWSb
	OU8EXe2xzawsGbW+TMwYUEcc2J6VWhyzy88fgJYqvG8TqmzyY/Mg+guKj30MblB50leHiJ
	rrA357PD+uf7Mm6fxw4sutylwc1Q6jc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cgANNcrJ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817621;
	b=rWaD9yGZn/cY1BOcpUt0pPAuRPcV9AIw2aiDUssGLNmcFj3/udBYp2QIj7tvUukZJWieyV
	11atA/kjOVo4nemqNBvoJaH1nz36hlItxmSFz8s42g4E4V3edrDMOMPPEc4xA1loTw0Ypf
	itbsV8nGRPTEzCCFK72J9Ywn7bWoKPc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ihGGkS1db6JGdRXvy1Z/cqvAlkfUAiXTBTA07KJEz14=;
	b=cgANNcrJwSKW0d5pENmqC5EXj22CGP04NXzbYcTp9T45OVAV+GBdArZfdTTAKcYp9gKA7K
	TGq7BNHf1ewBsE3pxpX7KDVa9H0KIV3S3nOn0QKl0jh81Cdn9xFNxbw4339WaMlPx64Mv4
	2pnJaxJHzT7lJc7uepFlghewb+0VzY8=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149--rg9LGAJMmqpYKS98KioZg-1; Tue, 04 Aug 2026 00:27:00 -0400
X-MC-Unique: -rg9LGAJMmqpYKS98KioZg-1
X-Mimecast-MFC-AGG-ID: -rg9LGAJMmqpYKS98KioZg_1785817618
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5aeb9e6a8feso3021994e87.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:26:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817618; x=1786422418;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ihGGkS1db6JGdRXvy1Z/cqvAlkfUAiXTBTA07KJEz14=;
        b=GjprYeO4KlxIEGT4psO5ZqnumODIt6oB7+oGhomYyI+A1x/pCiDFFBQxvf8XOso16k
         9v5G9jLu7lKKcvpGkzwX8gox256QW66uwYmeX6LotPGN4fcMrGV9FxMDltqwPaxvgrz6
         hunbQa7CFisVMzckWPGmmqvXi/Apg9w56G+k3UaLkFdqzEPBvlRy25f9u/yg6Ymr/ObX
         VLwTB3UjfXL5Z+zJKbi2SSLyjBufdp5CO3Avr/7xuRMH4WEvcyn0McVzeX2d4K3HOFPh
         VWHDkFA9Dp75CRRQNVYMQT/F8saEXtgEUru9dVcuNLtqSQXsF3SxnYVFJkUbCe3Hi7Ak
         ByCA==
X-Gm-Message-State: AOJu0Yyzr9h9V1r9+7/++axhnYpLwutfLIBWocQSnz5tPyl/+J4rggXd
	Ks5YIe82gx88xxxMguXXA+H+/JRJMn3mW9gLPZvPWN8lDjOhQAT7CgrJqadMQ+f19qGYP33S0cU
	orcS5tpV8HOW9IW+0NWyLIEmBGrSQ9qf6PJBMHAW6mySahY5rB4C/LM84Bu4ZM0oZKgUKcsUFMY
	KM0OS1UXu8VUtQdPURQJc/vfu5ITSQQp2/tJZLPQ==
X-Gm-Gg: AR+sD111Wk4/qmep2SSc7AlKpVpdDzRIsvhGjmWoEndJ1vPt/2GgW/fwvtWuTP49j7M
	NWDmwcbJEYtEiH7DcNqtNXnnv8bPo9c8T+5ypM46UIc060WiYc2wTZXDZWFbcygXzbiNDaa7Kqu
	RbMFRnyWFlwNmF6bljyumZlS+oAwOG3+tpgjGFArlsCglpEXt0gH7GxjMyPEhoeGInagtQAnBjq
	tkaYGKmhsdZ2nTDoGXrQI2FYdL7JPIq4xjJR08fDPhgTTQS6l4dZPUEbpvcl/MNXMQDbYLr/eOh
	mznatzQZ2nxp563gLWce01aPhDUB8dgKFWyjVimJA3xRdeEoPGNeN2XcgNlGLydO/i/1R+vNlpe
	EIcTFW/fmzviVFWtA
X-Received: by 2002:a05:6512:39c3:b0:5ae:bd5e:95f7 with SMTP id 2adb3069b0e04-5b2e4f1aed0mr2402084e87.4.1785817618272;
        Mon, 03 Aug 2026 21:26:58 -0700 (PDT)
X-Received: by 2002:a05:6512:39c3:b0:5ae:bd5e:95f7 with SMTP id 2adb3069b0e04-5b2e4f1aed0mr2402060e87.4.1785817617697;
        Mon, 03 Aug 2026 21:26:57 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:26:51 -0700 (PDT)
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
Subject: [PATCH v13 02/11] mm: add helper to convert HMM pfn to migrate pfn
Date: Tue,  4 Aug 2026 07:26:22 +0300
Message-ID: <20260804042631.2175585-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: AKknh_wsda7KYPhWoU9LFCtJLAPA5oMKOsq-n142NQk_1785817618
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nbkxnboirgyjrny4a5hmynfxm3xh44x6
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8364D40008
X-Rspam-User: 
X-HE-Tag: 1785817621-729140
X-HE-Meta: U2FsdGVkX1/GZFNFVdjSWYrPDzbQJSC8s1cJ0GHgpnS9b4Fv16eW0MHvrpzT0OkUBfWmDIwd+BINmKJlaQ68gRuN2Phn26O7MyO9EwkxYQM5wwRIEolC+5m/Scpk3mSOTihQYWVnUYcid8Peezk/k9lmYxSU9ngwZDR8Rxq6OD7yi52TzyVQzO2s8w12BIX4NbcDtQMsnDUWK61cTnYdFCEJN+1ggc1eQCoLiCXXwVGkTWXEtoqzTM28nJhJMCiXhciuFmFKmhZJFRJLx3W3QnCxuyNqMKydQtS4QnluAnInOwfhMahwLN0KgJL9dRjMXqVUfVpsn18bXoFQI76f3yOb1Fz4it+WtQZM/wcRepJpseTAGHMSmMP3Y392K9gC3M3cIDjDuebRht6hHyCb5S2V2Pq7TZiL90TnWEuYzwyc9Lwo9xKl5DDo4fz2yMcUEPyIWQ1hE0ea13yvBeYjl6tQ2segIxxlbVfLMljW9NoEUG9y6QqQBNyy3JuebCTC5vSG3kJSNIZyZTOyc4Q683iS3YnRNgq7Gyfug8X4q6S6+4Pe7JX6yh/r1Pfafe3e0uD1ZcwjESiRiZouFT3MDUPzvSNGY5JQamnDCUk3mXV5mmoPxcbSBUptaiinKV9QsDkon2PEtuQPPtP2KwzLDoicrxyhQtCDuUTNFGRlgXzlcSCuiZVnaPyhFXuyonxIYKUp5P3G1KtCBcTVfB5LZpsvoZa1by402rpbpptSwMAnIOpYwenb1U464B3ZiwUQKoFQs/E/NAlQ2H4CLbQCJP09ZrXggQk31VArfIY+1z4IIHrqzzFGP7nvjqV/hp4vm/JO9Tcukf8D2gzA9c7vgAzwPILJefyY52suz1RnhmsFXBv9wxypLnuzhR8XoA18gepgCne4BhumVLg+ns0bEWoxKOMK60nza5LzyvlFrtjWhUTuhpvxK66FAui8crcK+epDfBtfQFwuTEByoCK
 n/r5M51C
 9HoFj5GGtk2Rhogqh71rCKDuEg/ifEYXdzee3D4JVhYZTk49oQyuTlV4o/ou76UkVIiivYmFrttlRHC2CEKPnQI0d6c4nDxBQWc4HI+Tzo0ZJVyw659JXdS8Qnh/RngaJSYZ3Z+lAeu1ZTG8sccmo4zv3ODDOmGhDW0y57AyJ7PDDugetSuKnzMC9+XucMdewKsji0smw52QxVXTjXmQXljuEjTBfSxuNQP7CPN+6SAcrVkHdtM3Zuu3ljvBmECwWFkmWFmH1QDxxr2dmjyD7BpPH3Jc51Uh/K1yS7dCQcle/pbV2RMWC+xOOtRdPN9co+Y6o9WpStIyrPIt8/wN8j9Kk174rluu6RlpAQF2xBo/KTmDP/X9AoNrat1XpEyRo1Y432Bi7V8PpGAWbR1V2ZvkPKXVQkhFKziJWWa5YW+nSnFyqXglfLqUbKyFxSdfHpSx+p17nSGOI9U3nClpIwx6pW7rBpxe29iDrzWgL/6DoUcpvNUosCgSV1w==
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
index 908d2d4ec43a..a6df6566f89e 100644
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


