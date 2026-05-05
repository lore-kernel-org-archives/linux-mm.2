Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEDDCD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 18:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374CC6B0099; Tue,  5 May 2026 14:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE416B009B; Tue,  5 May 2026 14:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5B36B009D; Tue,  5 May 2026 14:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0599D6B0099
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:45:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 956D816066B
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:45:01 +0000 (UTC)
X-FDA: 84734243202.11.F5F353E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 624B64000E
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:44:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aX6r7shQ;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778006699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjER583RBr0CQSaYsQDNT5myJivjc3r5S+eofqbfVjE=;
	b=id2z762rh4uSvysDsmxyND+uGxJxHDb5jetiBxV4lqDwOUy2EimtttUgsiUpBDLCXrZKhI
	KYqoQQuOWTCY9g9PDEgy6W9S3fQP+JE5vyYmH1EBr/1JHhReFK6J/3FkqrFCGPrOE507bO
	FECbg8sdjmrtbmNKHMfX6ofcIbpfdGw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778006699; a=rsa-sha256;
	cv=none;
	b=VFP4mZoa/F8Sue7yxyhkDsiMKPmk6wMRBZLNCRxFwk4NUgWbLytTyamAGgpZiVCXnzMQ0k
	0rUDbKJ/ZjEkYG/Czcp6tipEID3szPZhiyUlYm6rI2RlFoDZOOCfdJYG86McoGZmo6lqI7
	l3pijZnXrCWzuJK9XhuketkUMoMlEB4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aX6r7shQ;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778006698;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jjER583RBr0CQSaYsQDNT5myJivjc3r5S+eofqbfVjE=;
	b=aX6r7shQHxxkYN8CMPmKqiKK09aqdGRABsgJXlxTZsWIpzC4rIqLJ2/IPr+uqaOtl+i7tL
	lrp7fF19m5B/n6Y7V9LRgM43Wt1yqqecwuwcxuL/fMQJm019OUr4DpaQRJZ5GQMRlhH99F
	AywJGsfsNt8FQ45OVCqy3nwFj9TErt8=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-_aFZhsj9OzG2nm2JYwOR6w-1; Tue, 05 May 2026 14:44:57 -0400
X-MC-Unique: _aFZhsj9OzG2nm2JYwOR6w-1
X-Mimecast-MFC-AGG-ID: _aFZhsj9OzG2nm2JYwOR6w_1778006696
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a74ac32340so2723384e87.1
        for <linux-mm@kvack.org>; Tue, 05 May 2026 11:44:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778006696; x=1778611496;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jjER583RBr0CQSaYsQDNT5myJivjc3r5S+eofqbfVjE=;
        b=obRDNwhg2ZT2G/WdASbaGbKwSutx3N035wJvx77RPt1cOEp4aTmVtsJEZLVsfhnSUz
         P5Ux2df817lEfLMZLgzxog9x4rELTP2Imkr7WQv8UM+7mstIpjJaxyTy/iW7CnWJlcRd
         xvCqB041m54eEAiO1rl8UArJbcVFUU61nRiEhd5JeEEHhfvhN1so2iWnfv93a0/kKG95
         NcZjPhtswaFGBEBSOWGN5Y7l271PzWh7MoXEP8ocZVOzXvpTBvDCkdEVUgT4Yd2qDqtm
         Im91R+N53HdI8cpjpDVsiZS4kj0YLRJLcjhsSsItAyQ43ibSibr+Rd90mZMpyWS3VuBB
         pg2g==
X-Gm-Message-State: AOJu0YzTnYVP9ZxLEFRXQ2EZG6OQNHlfHCQ5La6siTVyxnM7SPcDOmNv
	0+Tcm7plR3yeEczdxEKfvMtVCK0mv+JtdbYOAGvJWK4QwdfMpQNV7xP7SBe9x5IMY1WAHZIXmx6
	D8pbOljCHpuJa05dooqurv/88EoNFcLZxEQmuZl8j2Bw7SWeKWNLH+EDCcSZ0CZjEYhdiguaj6a
	1gIyGC3GCa9HOZgAufkycAxb6CaVNe2v5DDM1NRA==
X-Gm-Gg: AeBDiesDE9g8AI14J/1KupwZT3um2sB8V0v8CZDULgWpFo0yKDGQ/iH7YmY+1YW/gGi
	oNAtJoROm51G0SEdcL9+cgAMo7bEgdo/r5ehpXVHWEbxd2ILK/n23W9rRC7//PA7RVpCalq7N31
	pHI9iz+JvsKOxTQ5Nmm5PJ6lINWCqfTkRmbPVIpBxLu9uXrKLWMUxeEucwtQf1+4VjkNflEtwBg
	5tNG/6A81FV17L3xmyzM+WwQB3cEiZ9SP95UpD7x1SbquAjUapDq7NQxTUejIjotD4QVHCorGPM
	9mkie4eHb4GMplnxL7ojm93EySeB8u2UxgFwOuhcSF1oqdxBVbTNAw517vmZL1AtI7PssglwCgQ
	XOa7lB4gIO6IWKZOF49aSSBF/hs2VMhHngjugNAZt3AolLcA=
X-Received: by 2002:a05:6512:3d03:b0:5a8:6d1b:ce12 with SMTP id 2adb3069b0e04-5a86d1bcf51mr4043260e87.10.1778006695765;
        Tue, 05 May 2026 11:44:55 -0700 (PDT)
X-Received: by 2002:a05:6512:3d03:b0:5a8:6d1b:ce12 with SMTP id 2adb3069b0e04-5a86d1bcf51mr4043235e87.10.1778006695125;
        Tue, 05 May 2026 11:44:55 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a86e65fdf6sm2504437e87.78.2026.05.05.11.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 11:44:54 -0700 (PDT)
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
Subject: [PATCH v10 2/5] mm: Add helper to convert HMM pfn to migrate pfn
Date: Tue,  5 May 2026 21:44:18 +0300
Message-ID: <20260505184421.2324798-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260505184421.2324798-1-mpenttil@redhat.com>
References: <20260505184421.2324798-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 352oGyEYQlFQrVc6K2U2g0bHvlb4D2zH2Wuhzjkl_zA_1778006696
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 624B64000E
X-Stat-Signature: azqs51mawp561be4h33abfxaz56d3wrw
X-Rspam-User: 
X-HE-Tag: 1778006699-948118
X-HE-Meta: U2FsdGVkX18+YK2RluS4eo1insiFnmzideOQsOIxPhgY1337U2GUFsyMzkM/akQzgl9zqL86yEDJkOiEnyayPfuBPC2E5VTlLS37FlqXubs3HY7wxYoSCIbZw1W0qLunu6D2fiLtuEMSVbXdCdnjhnNOmYrn5Af/ba6I9gGNAWcnBqfgsOh5erEwvVtaHuou3cpgtqBi3/jo59kSSSyne0IpwKcK1f44U5ValTyIp7NUr9Zloz2vrQXbq3PIlzFu41Wv8wNH/+zOlNtspp6p/jYQMk0DvsSCcvAMY0WhcTWnrIckLArP/6ONqgheka3X4JjYA0QrVTEV0WWiw/Ve+Yehhv6ektcUXs391AelzpDUAZ/P0L3jpPTt0lL5AECem3ZyKB2wh3ZoGYmouiW6007Kx8rHYgQB5sjUh41LGwEy08R52V+XmyP0H8/ogY07jqUH3g6Pj/qzmHP+Ai/qe1hOqlgq6PxxtYNSHlw/6OjZsT5p3fd39TekPQimFzQ/xzlCR4PoVOhqMflkLIb1uwS+iVqTxqm03ip75hQgVbEUvqdpMTSw+Knov3QiVr1TFh+yrqtrqxkObtiR+JOesM6UM5Vo1CMeW9xyNCeb/9P319JWDmqkKfyyZQKBBpuevFHdFNUJq3Pb41erAlKvb+vS5SiTH8mCkz56WEC02lTnwWM13p1xXHhSX/AaJx/zCd9DddF/FLZef06MA/dDTN9uHw8bsmzJTEFmV1N86qHCov1fhDL73563evm1jY6zaJ7jJLW4Om9+2aZi/YwL5VUKpNxqdXlwzOu//OOKJW4y8fP6X7OJmlvI496djfTvnEwiZBbAnQgTWfuBk5ORdRoZGqcHNWHFiuQIKttFlyNtW9/FnSKFjZ+SFQestkqvHCG3UeqP/7iCaYIrCKQItOBIBqUMXKPrNMPGXHg2GzlmmmJXf1v7EG6GJbC4REdUI2vywshT7fiemx32iyq
 4OUzfTLd
 WTH9AefWLQLM93NzWxwSBMe20G5qtmjDQaNv1ZpsZ2OGWIgyFsb1KkHCmfD+N6AwV+3iSkmIMDxH2FzPNd/OBnb1vDPhVkh4wARWu3EBIbFQqwjX+V5dxssv3bdrA9YC+pw2D24joV7NxbGj3u33eja+jpEiW/vEuaGttJyTIH0ev0eCE5oiQ1PvioVlwH4etd+1vszQ0HYTBkV3LhJXFBxOO/RZoAeBRkM/BVsMENLbdUfWyrExNlgj7jwibawA3NvWqqcgpajoHoDtNWGPM4bmWHN5+UtOwUJsg3Q0g7gBZy6VDhGI2f2VvF/ee3Jeh3ploWPVHGfnhAj8vFiC0KdhSUhGVSH2hYvXS/QyMKC7u7N+t1R1EO5ZV+Wm6DTgpRZu6EUVE0bYm3bC9K5LT0vFaOxtHH4fOxNkvS2XujnQI23MM3J4mH0KKbItVoUpKPrxDpBHC5/suk7hIbMjE7Dq4ogz37lMNDhOjfrs6Va6QJN+XM2zA+nAyBs6ZxE7lY4TL
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


