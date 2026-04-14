Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5C24F531DA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1006B0092; Tue, 14 Apr 2026 00:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8246B0093; Tue, 14 Apr 2026 00:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0970F6B0095; Tue, 14 Apr 2026 00:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF02E6B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:13:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F22B14038B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:13:12 +0000 (UTC)
X-FDA: 84655841424.13.3C0489C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5377EA0005
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:13:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D28Qhz4O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776139990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqAgQ7voDB4XQLOQB9ROSGvc4WcHbi476o0Iju78Gg0=;
	b=tL2cRTJeYa/5Z4Ht3dobMibLo+zx0EUbACkrtkCWwh5EifbLWA4Za8Up+ambp/Aa1/OKlz
	h0X5yP2KDObDyRW2QA+NjIPKglKZiyvYyF/0HVMuADK44SDKQrlBsrv5JNUqobMiTGBREA
	2+AHooz3E74Tb+9f48j4+kBul4ud06k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776139990; a=rsa-sha256;
	cv=none;
	b=yzY+MtGfmthflKYkqifGnbg7P2PGL2QGIWKZGjieEo4fgWeex2I/ap5CxsO2ZS1dOOOlw/
	pee8kNoAN9Ad0dGYGKyMycHYCORrIQWat7qUSdZz0qMmLUOuxJF5HLAlUvSl57o8TtEodK
	MgFdrvRF6YO1F0QkWtGIcvUJmgu43YE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D28Qhz4O;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776139989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CqAgQ7voDB4XQLOQB9ROSGvc4WcHbi476o0Iju78Gg0=;
	b=D28Qhz4OmKCqFkmEdnqVUzwB3dlGhAZa+EzJHWkE5p0zBjf5C7+y2ylrbyssapJH7VVtnm
	xfCz5LyRbs4DSY8/wRiVax77XmQJIqWkjWzVOld/jE9oHj4D0dsJ8A1MI4UkOcpBDvChIi
	OUXISko9+bNUtSdOtOtjKiixK6N6hXE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-572-FTRVQ7m7NhGzKQuadDemTw-1; Tue, 14 Apr 2026 00:13:06 -0400
X-MC-Unique: FTRVQ7m7NhGzKQuadDemTw-1
X-Mimecast-MFC-AGG-ID: FTRVQ7m7NhGzKQuadDemTw_1776139985
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a277331b57so4611889e87.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:13:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776139985; x=1776744785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CqAgQ7voDB4XQLOQB9ROSGvc4WcHbi476o0Iju78Gg0=;
        b=iv5aILmuJY8f4ngNvffawImdaWZA1aFLYF4hPQ9TMIASJoY208TyWN6SqtkBnlW1AR
         TRS9lUiyd9fqmGLNXmOUAKBAmmMGShoJ0KFtJGfdL5E1NZNGKfnUkYRpB7e3nOh1NZMe
         iw70P6k7OoAwwrPs6BdLR67xH64meuqfUKW9zgt4GrVX60KRQfhtYLGTU5DKxnLhFepV
         LRpjb2uD1RIjDNEQFROxIyZvWlgqa/QFyXvsQtrKLYtYGG7vMQtSK0ZyfZ9Va60S5sXG
         +lFYQS4zS18m/sdHMX45X1dTrpe059hzfEQY/J8chAPqGiQsIdbYn820YQZwQP+fl/T9
         lR2g==
X-Gm-Message-State: AOJu0Yy3BusWW2JaIo6NccYZL7TFAeqZlJs1UTit+k8imHxtb+zAjqDi
	T4+jzICqbWiI92ZV9t7mwZWhuE369I9gUZy7HFG2l41xuU9nXukQRoAVkLDK3KA55eFfm/aQmoe
	ZyRlbmqj1+GwUASGl3MBuqE0zJZzEptukW7ml8wCrPeilabiiGp5KIcT2f+5+GdOUlH3Z8p01vS
	hKR0FoYUkHqPEaPQ5Ie/YX/LD/e4BOQbcHZdocbw==
X-Gm-Gg: AeBDieuoM2AhGLy2zo/w2A2x8EnCTcx++MkTSxYHCT3lKnuyJvKHm4ac4caV5Q6FeF/
	uL7S4CdAucWiwYFLgkdnZKsxdW+6nnoFp5mpLF7RZ7DSsKiapRlegVHu/Gf94KJz3/sOm/RDnJg
	IY0zmv6WYY5xVuazRYPz03UkKWXTky0hSEa5vZ84V2JzmiURx/CSlR9/GD/MV4uKefJWUsxzM0T
	Zh0etfAdpJl9TiJq5wu+mDVIHTCHSGK7rMogn9rVd92gVplKzmwU3yDWtBMH6uoZG/hxyuwi2Mj
	9BKGTwGlmqu5r1ATsFeV/2MT5LSYAm8WT8TrkqD9r3S3DYhAe/zqjzVyXDySNFU+5YiN056lxxZ
	o/+iNbMIN2UDwUJ7hnNrgWw6dVADVU7bZnJuG
X-Received: by 2002:a05:6512:3094:b0:5a4:d8:ce6e with SMTP id 2adb3069b0e04-5a400d8cef0mr1739038e87.41.1776139984882;
        Mon, 13 Apr 2026 21:13:04 -0700 (PDT)
X-Received: by 2002:a05:6512:3094:b0:5a4:d8:ce6e with SMTP id 2adb3069b0e04-5a400d8cef0mr1739017e87.41.1776139984213;
        Mon, 13 Apr 2026 21:13:04 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a3eee865e7sm3040666e87.10.2026.04.13.21.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 21:13:03 -0700 (PDT)
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
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v8 2/5] mm: Add helper to convert HMM pfn to migrate pfn
Date: Tue, 14 Apr 2026 07:12:23 +0300
Message-ID: <20260414041226.1539439-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260414041226.1539439-1-mpenttil@redhat.com>
References: <20260414041226.1539439-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: GwS7KnmzBx04CwFWcGG4aHMxauHK0LAOmr7LsBwXY9M_1776139985
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5377EA0005
X-Stat-Signature: a4zg6jx9htsqpfcz5bzzo38p6uhdrig1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776139990-355472
X-HE-Meta: U2FsdGVkX19/mz5CF88v5g6M6PdPzOQLXPKPZDsi33Dnc7/WyrsDetv++WdikWzXAY549DZoo28GEVP5VqEjXh1R+62BxifWsYHndnIJkwW9+yXIjn6l63OvypwGeJIOQT7nK487HqLqt8Pz9JTysDbZ7lU+zMlUIZ5x2BU07aDiE+zTuwWG4UsqBtFHO7Sg2ydjYv/aTDSvmOts4VoC9pXjWmcYeGl5UgsLrWS/isicbiolZDQhTh2ulsIQec+cvTHk/nWss1BrekAQKMX254tMgc8Mol5SpOFHLIyUzyM07iXhLSju96AfhPqp0bk617S6K/mNF736xMXpRJUSHBGRGWp1HpuB+W29JfIrvi7Vq8Atb39vFMdXftRRgsyo9utVeHMlOiWalfopSgOuR+3R+KfKJkGkmQQ4RPROxOnjtb/ehcP2TgqncXwjcwaZXHoXtCGDXXrhmY6tgSBF5ABVaI7MviY3ResmPKVOOU1T+y1DXlYlUNTrv8o2IPqCm1tbXjAfUiqTYpFU4LO3ZZ9mpB3mvBSNCji2rr6uujOLPIOPFQC6LV7k+CS/R1dRRaft51SSplosc7gjnvE2t2vohIDNKwYfhKUQYuq7CHVA70FwcKbs1Qjm2BvkzeSJXMqwXlipuvKGX2x3u2xeVByWaR1pChw4F9N3TPpWFTREmQn0kxsd5xiNDgG2vuUo0QnK5btwfSQUrae3o7lMEryV5F0iIa67WydDjiDt7sefo3oGeZ2yMIwQrCLA2BsLaLlAAhvX35dZAT6Rvy1O3AZEBhVdDY4iZ9C51BUExsZ7qwJHYvgMktbpJiZNuUgCA8vmihxhEao6po1F0N+d+1Hw/Ddd3Pp1m+ERj9GTQVdTLKpzK+JgRczcCVnXxjVE0up79qs1GThU/sljn40MNeJqwTgj0lt4C22kdXhmrtlpkyxy3WF1TDnERJ6aqj60WdGbqyhWKScEPGhURzF
 u8JZ+ldA
 8pZzItNydgBlMetMnDruFJaUkH40nrFeqb7AiOIVN2P8ocQiOJq7Vl/Z6W8YOlveFnRla21eobJfCFXUOToRXWqNmCBO0tdg4faClXw+VD9AINqN0FPHGnp7D9Rad/Q/oR0gmM3X3OAlRWG31ErDjSYAc5MG81neMza8Wq4LsluSox9UYCVY09Y/7usUzIh4PUyXG/SFZO20m8HGS3dUMeds2z5TjlDPx0yxPaleinUOCvFcu5nAw3fAuP5kjzj+dEjxIZLyXJiisc1pxKMULDzcHSfr6uKkBNupJ88pw7h6epc2DcbVPr/eJRC4VNsJUdWLIShGiqyi31QjtK18zzz3PV0OjdyJCBCHVlMG71adK2ICBQ67ga8Hb4gbGzCZ3XyxsUaGcGLdh9oy2NEThQ3s/nCgLh508InpW
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
index 8079676c8f1f..6c50cf2d80ca 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -1489,3 +1489,58 @@ int migrate_device_coherent_folio(struct folio *folio)
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


