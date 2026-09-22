Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95817C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984B36B00A4; Tue, 22 Sep 2026 01:34:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935896B00A5; Tue, 22 Sep 2026 01:34:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AF5F6B00A6; Tue, 22 Sep 2026 01:34:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 510E96B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:34:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C301140397
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:51 +0000 (UTC)
X-FDA: 85240283982.30.615B475
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 943C8180002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:34:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="buc4URW/";
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055289;
	b=5zLVjxmz3ImM+zl3xQuwKL5JxUiXKDV2jEoW+0Wj0CmZuAg5goS0kcNN9pkPUrdvc0ukWR
	ZgY9NWC39HGdWhIUttEHpSU779k55LDFyNXhGBvIoWSviOBA0sCryZZ3D2qfbbFJO3Ft3j
	thNBRobCAsBoZhu/JOhNotVk1qb2NDQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="buc4URW/";
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
	b=SFWlzKLRjk9ZWs9UEqv6lehZgziw80gpqDMMa3EpWIoPHyc77OL2SlSWvJLJ43rMHhvOoY
	IHPnoNJJyhjKmDxAzYgP7LPNlevaizPtoc7UP+58dZa/M5lvBl10XPgowaOQ+iXF9Qhr/M
	5AMWKe/0HTu9Ru0wEFFw6gJO6U2pEI4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
	b=buc4URW/cSs9Mjmv1WYP1x9blxpske7TcKhzUHcoq5D64DH37EzGePjmXaJ73cNOwLvRnN
	xnCAOIKhMe7glelyxQxff8H4OXM12qSBuQX+WgL+k6TuRAqIf1YlhxHZQDJKFDDarrrpQt
	yW4WFTZVOgEJlI0ViGip0kv/BS4AnFY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-327-7DkqahbwOYiaIofL-fshUA-1; Tue, 22 Sep 2026 01:34:47 -0400
X-MC-Unique: 7DkqahbwOYiaIofL-fshUA-1
X-Mimecast-MFC-AGG-ID: 7DkqahbwOYiaIofL-fshUA_1790055286
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5b8980a1772so1607648e87.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:34:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055286; x=1790660086;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XHN2LiOQU7r0d0fe1KkDFs3khSrbeSD24b1q7hC8HmQ=;
        b=hC1MbgYuF9MLLlbCUiPst5BBxMjU1Yu0no5LsGXFR0sKqsn1YvskrXy5D2XXdVc1uh
         Syx+dpFTDBZPlAE3rK7WSiL1ppuwXC/uX4HcO5VGt0SZSfcWbrukG7thM0VxdErv8x1Y
         RukPHBHBkY/Pdo8cWB6KLTwx0w+LN5EOMTlsAgq1ijlwMt7pOYwkL27bTHc1dMD6a0tJ
         OfXmC3vGvZsjmPZd6tdIyFsCKiSPXQCAmRczC0QopH8NOqZywbC+F7LwoUujTRm4iYqo
         MQVLHLVyn0AUhsElnXS0DYtXoGnVmFzacVk3kn9hwDpbaBP3xwLDGzWZhyOVi+sNISW7
         jSIQ==
X-Gm-Message-State: AFuF++nn2ijQgHKCp3mYSaSLWZ0LllxJvTETkPRsLgDrn2N/pPRwsnQb
	kFrOZXkQeVIn+M/a08jl6y3mRlBOKt0qtVAG2jYoHaT0fEZIHA63uRzJDPShKi2lhOba/1LlDup
	rqAZEtSthq1bEFF6e3AKYqTzTQw6+8olGpYR4T8053aPRyVA0VCMJV/teGwtOcWeto/RAvuGkfN
	RF3mCJiQMIK2tynuGE1ntq0U4qFUtqVmWZv2mBLw==
X-Gm-Gg: AYBFou2QE1s1gzPmopUZimy+X0j3YZ8nv8cRQfT/CEK54CIk95gzgELYaMsHOM6qjby
	txcSj4x9eWu6/QR1Y8zMiRA4dAoDjlLhaoLz2vpMKtzwDllmS9vN6R59BJqJg9HdLAGxMrRL7GK
	GUz69UbeTbNihDVdYSUOky2oyF15VsKk2lFgXMIbZ/4rh+XurtuC3/eB5+77KblUrte02h1CH1G
	AVGZaMdv9zf8o+1JXA/1cTumv1Y+LbrRlxpXbv68zvsl3IoWhrPGR+clWTVni4eOf3VQS5bgTSY
	feHjTAI8SfDaAiFxW2XWtQN8Ym+q2jhsjB4T/jteYFOZ6B5dWLPhrr98BOKApV/CQcYQYQMEoYO
	bXyW6qnBHuC+igC4f90Zx
X-Received: by 2002:a05:6512:3ca7:b0:5b4:fdbe:ab4e with SMTP id 2adb3069b0e04-5b8c184e399mr3985154e87.25.1790055286072;
        Mon, 21 Sep 2026 22:34:46 -0700 (PDT)
X-Received: by 2002:a05:6512:3ca7:b0:5b4:fdbe:ab4e with SMTP id 2adb3069b0e04-5b8c184e399mr3985136e87.25.1790055285556;
        Mon, 21 Sep 2026 22:34:45 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:34:44 -0700 (PDT)
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
Subject: [PATCH v14 02/12] mm: add helper to convert HMM pfn to migrate pfn
Date: Tue, 22 Sep 2026 08:34:11 +0300
Message-ID: <20260922053421.4092027-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: F-_t5AWvPnou1FTpJegA6ozkq2st2541bh8ewV5205w_1790055286
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 943C8180002
X-Stat-Signature: ojkggbimbmdgipnpcsm8tn95iasj89fj
X-HE-Tag: 1790055289-101640
X-HE-Meta: U2FsdGVkX1+mdQe0W6Vk/emoTHjvMTjVsKoyKV7beHmkhMVno6eEVAPmy66Yva+zzbKsg9kgJlvI6op+oB7F7muSKt4ur7Ee4vMyswdLUlhw1AdYEGAhO5z2Lin0JL7En+iR2U4kQOK6jcYwh3U5t5LiIKLMSpHblQYj0t9QpSJVxsjhf6g8IB6qoLYhgbzU/IMFs2iGbfHSNq3C8N5GJMuv5p8O+I/pev369478aIaQ+NR8/2yRONkC+8a3mpxE5pdixr5JA2jN0P81Av2fNUPirY9wtDOVx+10uXgEs6K+wUwYzeIghayhPcPwmm8r9naLWu07XFZMX5TL8gtz5WtpYd3ahulFaSEKJ6XtlzI5srTcrJ1EVO2aFdawuvCi1eeAgERBEt5IS4SpDSxsqcUJBFDnBR7hGgdit1vk/Mi5pwD5TpK7zrCXTj+jhV9utkufYuEcQqyAL04n+FW57RWvQlM0JTmkP83h1wA46WbiPDntaOt533KaYir3M5dZW8n4iAFizQn7iEWLhiayKBUKbX3DKTTiMO+qtVYlYlwaptffNxGESQegcJxv7xrkPsjoQ3irTz1LxUfEP5YPDpXu3ZgwbSJ4tSpOk9d8eztL8b8+AIBGUMIQ1EyzticTiB1SdzxcnD1Rfuu1s9IqxO5l4xxLrxv18TY8Typk2bW01yDz5c/iAR+u+ls3IV7gVnGWOoK9hy+QZqAthxNiYcqCN/ch1kkYQ2hgHmWhNwBbrM7ih8y/lLnKTYPPJTLictvwc6OH9TWkBRlAdZ+C/fF061NTQCE93kwwsg3S9GmKmzD0zG9YXANZ1Otlccbg6Pr9oB3rpIuzwHiEbY4Eymc4F5m4V/eKriJ+5ngn4n9ijFntLDf42DU+eOnAs+oVuyZCq11J4YMIgXNViuVYy6OD5ovtA5xxQWxL5RTnjWS67792XeXE1Y97y6uNHvcY2ui6yB4ll8bQeY2ji4z
 ys5kbVJl
 i9A1kU+iVvAjpheJ/St8UrPA4VzL9voHF2+bhudjDWIzQfGKilJzgpjeWls4qFHi5EfQiSB1FmtxT+KbAKGPZOIHMNRmWGEU1+Pi5J+CHhAuZ3dQKs8oTEFsJuZO0tG3M7GtpKxqSD44F2VPs97Ckjg4F9wAimVsx16rF2kUizj8kWNpRwmEZzMYa7D2JfXS0V982HF97aT3flC1EehRulI9SVSgISqcihl2rkaAUcoohoCql4aFHbgG7qxPqa0CfIWhuKmIgQhaVD+ZjZ6/zCekxtHuvKPODAeDZzAbWLsLu57cZsL5gbnHqHRC3Hk7RqClgOs/0A5uRcV3C8+tuH9Ou0mMlelAjVCXbQzqrFa5XcmBpSitDKgMYMYlqqUOLhEUbHI7z+ImbWH8jE9I9362HP1PNMVQZnF3aDPHLbRFA6vdPlF1jWshhfkIUZMcN2+QYEjX9HjQPTW7ecqqn3Ndb1fzbGyq5U6fwfLh0V9Zlx+FI6+qahiiyWQ==
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


