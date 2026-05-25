Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B99FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:45:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A4ED6B0096; Mon, 25 May 2026 04:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479E56B0098; Mon, 25 May 2026 04:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F3BB6B0099; Mon, 25 May 2026 04:45:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0F51B6B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:45:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB31E1C0558
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:52 +0000 (UTC)
X-FDA: 84805309344.07.A23F981
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 82A09180002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gQKolyGf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqQpQ/GF7r/UpbjClH/YEY/g/tI3n+T6qxGAQdsX9zg=;
	b=q+atuNc4+3nSssbWloWMf8lg68o8It5P5tcfeoMwVZMhZHOx2uKnYLu30XvJMd3jWlQSoh
	iYazIKKuno4BDvlFZEXL7LlSR0proX51belWfe65wYfu/EPd6hyKWi9fO+tmqiOeo1/QTr
	juVR+lCg5sxBfrzK0T/xcTyHpC5iG4w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gQKolyGf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698750; a=rsa-sha256;
	cv=none;
	b=DfPAZGJlCc4wRZ5EMTzYHFlBL42T3Wc/7ZNHswqP7yLOyFyusnsJ897Xb07Hb0d/Oe0IWp
	qrv+5CsilTxZ67q1Pj/bwZYSXuKvd3HjJaBywIhcGhtNyU/RKtC8MBaFwr6bq2v6TTw5rI
	/M9JIwZ1KO1Pe0PUkc+lb6h+SI/sP1U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779698749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xqQpQ/GF7r/UpbjClH/YEY/g/tI3n+T6qxGAQdsX9zg=;
	b=gQKolyGfKPwdY3Uo6x0ECSnqvi1h7cgYmueiLgWS1Bbn76UKOsm3W6qk198od8FHu8P1Cl
	DMkySv7tELBxOb7okZkDcULyPczXb5TcHTF78sxHDZB2kYQ8zeutWnVEF9bFyHqRcCaG2x
	ZMQA/Obsja5YdYej1P3atTbx7GFms0E=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-KAx8MMwkPtKQUO_jgd4QGA-1; Mon, 25 May 2026 04:45:48 -0400
X-MC-Unique: KAx8MMwkPtKQUO_jgd4QGA-1
X-Mimecast-MFC-AGG-ID: KAx8MMwkPtKQUO_jgd4QGA_1779698746
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38e817d9498so36542781fa.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698746; x=1780303546;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xqQpQ/GF7r/UpbjClH/YEY/g/tI3n+T6qxGAQdsX9zg=;
        b=AlFTvQIERREoBW15WmBBKci5Jhn2c3nTlX52uiz2s36OW81lOr5seOgmP21Kk6W5Na
         zIiENjaWvEZA2JibjrG7Dq5bssY21CoX6aLsZvJtrrkQkHEGiXqTPcc9SHOkAuYW2+mH
         Sh5xmqAzFpYdGX66E62VZ9jj75AsF2Q99BQQm+ndFJcMM7IEkk8XJojSDb3/lJcfNyAb
         Shj6ehOSZSN3FLjDJIsp83eRSrfId7gMeHLbq5EpWiH5LYVBNFkKKz2zweUP1x+Ij6sC
         Dm+4nRDUcMHeEYt+8Ps/I5CXu3uWRjr7ktyZSP0N3UB4nmt1CSmnPBISsnTX3GV5L6Ds
         EwbA==
X-Gm-Message-State: AOJu0YzkOS7r1jauSuGRb9SOlQn3yC3fxTSZlaJGpcMHHOPO9eIXlSSx
	ZgHhZUoVpzhlJ6nxtEnwNPZxtF7GYgJEgT4uzvnQcfyyq0RMk9LtG1jse04XtDC+NMreU9D+XpC
	HuLQQvFYFNLjZ8VDuVjw0cOfSiFuwj5lfqF6vIz//m7xZLb4RbFJx1QmDfzvK3RyfLlO44fueg0
	wIFHLPMcw72hNrY++EaNHPUIcW5hsmD5qPq/lziA==
X-Gm-Gg: Acq92OELpzGDJrUXd7CA4PTx3nKcU2a0eDJczZVCswiv5j2+FDZIycHJjmzPfiKg+cm
	Icl1aRWCEahy2yt1Z7auWxZZ5vTlptIYly4gWCtLgrcqGc96Dp9Vj/NhtD7bKJVuVyrUwsk/j2H
	waUKeGgyaiJGWxCsbz4RNvuND5pXJ6cNRkrejp0bvcDe5I48v/wW0AxZOsK5PPPi1q35jSJaIug
	naC5061F5wlgjSYcShEB406ragV0qhZ7E2Gaa6tgiVj+epaDpVqrGMnEn694DcjtDyF4ZcG4/OY
	97++dwKzjwAhEK1TJai5JQmScIbdjNGVln2WvVdgvJs2CAQNSZIgFgh3FVZSb2lIQ7Za/qfQn2l
	QDEFZgbJ5DQD1yeP7zZ9Mm9DfBWv+RcB1t95r
X-Received: by 2002:a2e:ab0a:0:b0:38e:298:96de with SMTP id 38308e7fff4ca-395d8bd30f6mr43125831fa.1.1779698746392;
        Mon, 25 May 2026 01:45:46 -0700 (PDT)
X-Received: by 2002:a2e:ab0a:0:b0:38e:298:96de with SMTP id 38308e7fff4ca-395d8bd30f6mr43125471fa.1.1779698745867;
        Mon, 25 May 2026 01:45:45 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm21679061fa.16.2026.05.25.01.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:45:45 -0700 (PDT)
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
Subject: [PATCH v12 2/5] mm: Add helper to convert HMM pfn to migrate pfn
Date: Mon, 25 May 2026 11:45:21 +0300
Message-ID: <20260525084524.139868-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525084524.139868-1-mpenttil@redhat.com>
References: <20260525084524.139868-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zRii7B7M9vOkcbOyvaR8qmQ0zRqGm_2Pv6Eg-wJVz1o_1779698746
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: g7ztrgoj7s4jgb8d37ejqmon3dy9k9s1
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 82A09180002
X-Rspam-User: 
X-HE-Tag: 1779698750-269874
X-HE-Meta: U2FsdGVkX1+xAPwKyfRiQPrzMLW3gfN1qf7kHdQQ4ZKnQy1Q8StbCQ35VBkUE6ZE4OaMxpFhzVDhTebC6d/7Jq7lw4MRH90/M0WdgMeOkFsYIOuCTsez81kRVqtDkohgKhAvAkhZtdmHfJvGWmXclh0gitGuk8lhljoQ1/X+med++ULSkQysMBcMGpTLJnRCUAN7UxEgtBycqHgqxyoAkpqctG7Sc2KeOPfE70d2ywukaRsQ3m0OPr4N3crTmIBqmelQYHvHMpgAj3fziMjpCCQHL5HX1caIN4pAiq12PDKRaDAQJGiDW5FbvRqg/bhLyitj8xoh0nJqHsMeAXCMyo70/IG45PmHzq8ViGf6ECwyK7vixNXZzrnJsUqMXsD8pqK1hWfNukzHGBtgnRnKBmwVUGlYTq4XqF28lCtTtBiOAnmsDx7vkcjEvkTNp+CIXYP3iI5sjESvJJrHb42pogOu0MKQMsLOni0jiRCT8hWkUMr4TGv4fpBMqleZds3mC2PAOeqB15Rf4UqCH2Y+LBj4fnWHtIGA4vbVixzd9Lz6AfzKZ+ILtWj2+iQxljdzBFxdD3MS15ps2ljGL/gv03LEoqZcMw6cFJAhtTi3T5vpYRRrzYaMQUozvy3B005yolOw44HtyCwvjp+fmuOhrPhpuDkICW1cMxAwVGmAOjwBavrkClr9ugjvFxSuEbCTDUhPrgUVkCx6Z0lhv8vn2db7kNr0zWcSZVGybsitUQ0VZ6hM4KZPGGsbdoVBq9BnRSp1WNKvMpXZPxrQsQN+S3+u/JUw7igbc3aKRTfVBO/EvY//r9tA/Yoeg4YMExfU1Qf5of+Kk80hRJI4o6L1ayOXaa5Kgcc/i2YlAwLffYE2mUZYO1LpuQ4Udl1+DQegjORQZkMYLKs9RnZg5MpCG1/NnVahD2GwAc3SByaOAV7FpUsETSOC9ukzV5E0HT3xTN1IRDcwkgvfzbrIbv/
 ZzfJOxSk
 9Olssa/XIs/5c/QyC0TPfTUSPyaNBNsTahNoPTYXovDIpM1K90ArDJg9uxpSe3dplHiLLOr+RvOnhkocGgPZ582PWHIUojP1I2JgvqrYx54CHmirihS2L9CTRdycfGZj7MkeE/xUSfpNRjSoQrWESdIAbp5SqittldIUfHwX2y7ZG54R7LXwRhKgyUxLqwdozIo+P/IMHqoU5w6ujFxG1Er3aGG4p8UpLQhwKAdhPcjQASeETjdTgZWcBfdWXAERWnYWaTaGZqBXRyL5o4ff0Y/xmYs9iTZSq2Ecj09wSss2c6WzWvNuZGoxJPhElX1y6kyy+FkQ+B3dNlwEyse87k0dyydhRV6M3q8NOsCfH2uGAavOdiwRJ7KBGNdRvMng1OGpG
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
index ab49d4dcdb60..deb6c944cf15 100644
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
2.50.0


