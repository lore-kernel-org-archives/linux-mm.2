Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ABE3CD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AD8C6B0098; Mon, 25 May 2026 01:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336D26B009B; Mon, 25 May 2026 01:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15FF86B0098; Mon, 25 May 2026 01:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC4F16B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:08:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FEAD1C2013
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:08:58 +0000 (UTC)
X-FDA: 84804762756.16.278DA1A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72A324000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:08:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fMwnN6OS;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779685736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqQpQ/GF7r/UpbjClH/YEY/g/tI3n+T6qxGAQdsX9zg=;
	b=ZD6qJ9Qw5KV8Ha1YugTZaNbkOkmQMQSpliGpDCqv+T6ZKdPcBtKFYUrOhGJhO55/SXMcQI
	zS5qY5qYTR+5J4S2/2EFUEpLUl+1I9m06JVwQ6kvecgmITRLLznpPaPGomSkZP65CUz6JT
	HMaiTVtiv0hphuTetM+HaWKD9NOUYwI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fMwnN6OS;
	spf=pass (imf27.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779685736; a=rsa-sha256;
	cv=none;
	b=fUe0hnQ26nbk3zXF+icd9HI7rZj2dKiOuITRxZKjA05hzpY0ovdRLDNU2Dvhrw/rBYTKNn
	2mfWqMocUQE1QJvJaUtZa0Z+Cc2SZ8voA1hML4kR8Tvy0klWJCj1Si2owe1ogOn8sHJXFr
	Qq75I0Id9AgvfQebkuaAgmHD6EGGnAQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779685735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xqQpQ/GF7r/UpbjClH/YEY/g/tI3n+T6qxGAQdsX9zg=;
	b=fMwnN6OSCjIuYQS7fJCwXvjnMVTnrUYcUlyyORgJXqCjtnAuR7Dh/3PgAHzkwVN6S/KkBg
	KbSGaXOYotV9dOjUEi1JiomAMLuJDOk4aNdOSCkLSXe38lSHTyzaHu+XFf56RWp+83JqNO
	DHfNlvvnGlbiifYpddIbLOigGkRaKjU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-MXbn5C-EO5-_5f3OFnijow-1; Mon, 25 May 2026 01:08:54 -0400
X-MC-Unique: MXbn5C-EO5-_5f3OFnijow-1
X-Mimecast-MFC-AGG-ID: MXbn5C-EO5-_5f3OFnijow_1779685733
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a898609ca2so4408950e87.3
        for <linux-mm@kvack.org>; Sun, 24 May 2026 22:08:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779685733; x=1780290533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xqQpQ/GF7r/UpbjClH/YEY/g/tI3n+T6qxGAQdsX9zg=;
        b=VxMTNznTZZbsZAbvx9WJVIEtZOyfUsDYomAVm616CuQi96u1Q5ZHYIzU2mWMZaRA9i
         9hM+GR3YCPbhwYGfXhquhYgdQRUQuINoRPQHWnuMGM5BFJZYK3apwaqTTBK/YurSe16m
         lDvEQhyN+KkL7mgMav3x6o9XDi8Kzcu0TzMberiZX2psEf3ZrmA4qpmW3HZREHOUXV58
         TsjpjBl/qgMba0dd+DFNq5bss6/B0ykf0VT7YehK8UklHub43+fCobpgedEP44GbY7b0
         VN5+vt2x65fz5cGaDlnOdOtbBigRVFz6WJmkUSGBkmD94uoT+P4/xA2Dcy+6S4pxaD5J
         yedA==
X-Gm-Message-State: AOJu0Yykmlyk6XVmqJy5ACstWWPbUnK8ZUXyav9nMISTTEv+WpXzvOis
	OC12qYawbEhrWm69iyAsGtn3crzq6CmEW8965VzQhPUZtOw/5keFL7tpCNaQ/zj12IUCbyF4d8e
	smD4ikfqbHK4FN8fGM7KMB3T1LY26bK7g9OzF3OOauA/hj7GZsf7vDJMq0g+3BSEF3541MaEEgr
	zqEtBg9dva/6SuIeHlmnDNS5XdNcLuGih2+fCNig==
X-Gm-Gg: Acq92OF246e17pSyydDrNmW9R+oTaBOcnX5dRkiQWZ6OTnZnGPOwbJ96tk4pcjnGksw
	VApL/9vWXJivS148nNFkLZPq4QmS/c66/OAdcjVcmCLIDFXiA/H4Q6QRYyewEtWPv2cAjIDn/3s
	MwubAmnMQtqc5SAiy9l2Wn2KUjVsQEtvDsnavpR7wqu/aOAJtxydQrZdCkL4/2SDuPbo1c2Z8rt
	O/hvIgqeZ37cWeqqcyjrOD2DCRftLNu35e7aNhRIIHD6LrXOFvTFZRfDA65AidDPN4fq+6ETmmS
	9IZRnpbdwPYlOX9Obc6/c9lnxOtWljFF4A6TiOv+qqiEdlVAV7lXI93d56cvK9GJ8YrK+nLURz0
	sEAzGOtm/8QBZ/D2g6YdgU2ulxJzSoYYirsQQ
X-Received: by 2002:a05:6512:3409:b0:5a8:881c:9cec with SMTP id 2adb3069b0e04-5aa323a49c5mr2990044e87.1.1779685732780;
        Sun, 24 May 2026 22:08:52 -0700 (PDT)
X-Received: by 2002:a05:6512:3409:b0:5a8:881c:9cec with SMTP id 2adb3069b0e04-5aa323a49c5mr2990014e87.1.1779685732203;
        Sun, 24 May 2026 22:08:52 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm20698161fa.16.2026.05.24.22.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 22:08:51 -0700 (PDT)
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
Subject: [PATCH v11 2/5] mm: Add helper to convert HMM pfn to migrate pfn
Date: Mon, 25 May 2026 08:08:27 +0300
Message-ID: <20260525050830.100254-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525050830.100254-1-mpenttil@redhat.com>
References: <20260525050830.100254-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PtRu7rOhoib9U2QbyXMbU7M-SYJHZmYqBpZJvtIZC7Q_1779685733
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5k5i9t5b1mq5za7343iqcnh1oa7k9zbh
X-Rspamd-Queue-Id: 72A324000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779685736-459164
X-HE-Meta: U2FsdGVkX18OJjX9U8jt9PARwqetlNCTCJUqoBuueSLa3yL280WeaJ+xyNVpDrJYgkA5JZLZuLMxsrdtQbrzJaRmaq+Cuc/rbFmFLXfLkV/WerWOEF5C06jNZ7ahBtvfccz9ZEOlmwF95oeDHu2HO1rHnTrOox+kPX75eMmTBRtwzQbYqRujsHqvj4ZAdDH06THP7ob+1Zah3knALrWr4L9CZZLeOgxG8AgLOFmqylRCJL6a4SQEhcfToZ8FFqHkc90vjjf/fFfAcJ48E/YtXz/5cLFrXXi/sYgkPGewCjvx1pkflxazS5cVVVqUPpzOfCuwsFc/elvB+Np1d5Yze6fmDjjt2cugDbv99ax0I4MR3LlSB8dQrXLkRir7vi0mR/Q8LP39PGgbdK3Pqz+azzANcuVlsQLTGiEV3viQu342tQG9c4YFZYBtXRkxJKxWcAs1TlSbiXupYkbutVxzmIoZHeByBguPjRM5dN01PZd/ZFTh/vmnEmyeFmbg4/K64PYR8DPGpe5/dbUmcpvVYzOx+2YVqq3KrfopJGWZIXY40bSjFTEwjnBQEIjjI6qjrqJ19paBGtNRvpAzhKrx55JFGyhgvSAtXssQcp7M0CbiWcKDda0CPRdMK25HB4LOab2OxgWPztIUC2AWHx7Nn260M5fuxVSEcxLYtzYOzki6VXWST6SwfHuuyGMDdl1IGrQdxz1ZmxC9zvBIltKIJ/ARppGoO9q6UYD4OJGojUdz7BPNAIJaVR7raMcF1IAreKlgoqjK5P/TgXhiFIOclW6SPLvDdVqxDlDHvzinWpfC9l+I1B1r0ywsHV/kPCjazHTFOdtUs1+YdSciSSYJGZEycBgZM9gns9XzstMN0bLc9xx6TzKarr2BZQRXEk2JHjE918+KzqIMNEuWgwtBu5VtdU048WpDUMYSgDzhl185WKBkN1yjkP0lGuVlFsif7Pll1Gb1V+iF1bW9vcl
 GLpKLei3
 NEsJODaY8dE8Jc/H9G0Rl+IUN+QchJ4Z1UNM6rAeG/VKaakf10pBLBpiGE8s0LvsRckUcb95LpSG7LDj/dD66Dj1ir38R/oIo+1mvlMuvTbA9EApoCiOX7PWV6K/k37/Fg5skHmFNnqVKRBqRaGTS70tsp+FtV6hFkqx+49I3darwneQujMHZzhdnuVtm/KptTdGz9Ymk1ePKzfwDdTO0QJbly0y+9S6t77XRRiKB7NFzPhqIFOc7wdYD6Gt3AAmMGok67C6IVlk5qF/HjiswWce57SbsE1sUKyckGqf1xxwQhRHrvUGWBjZfm2GRoXTDWpWev5hCtRtL6ewIbaqrOEY6nN2bDN/TTZ1JofTxeiKYYOH9vLomSfLYQ1iDy9FJETIuTPvQ7A273qb4fSSg/AJxcF2BiLwqTyFH/rY8KoRs03RAbCDo2etr+qZgx0tmf8qe5u90ef/Z2zu0ez1TKTBAF/hHLr70yWT34pppgD6++N3lgtn3fqCzRqgeujQuCmeY
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


