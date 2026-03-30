Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2EE9FF493F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 04:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499DC6B0096; Mon, 30 Mar 2026 00:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4713A6B0098; Mon, 30 Mar 2026 00:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387396B0099; Mon, 30 Mar 2026 00:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFA56B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:30:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8E591A0739
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:49 +0000 (UTC)
X-FDA: 84601453818.17.892BD99
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7542F160006
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BtsMefXT;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774845047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv61ajyCc+m1Zr2ihJsLPfcGnhj6kHq30KwJ+MzkSds=;
	b=2pSvIGv51rUnCq/Q774S3gmdEWJfQ5oLPTJKxrdqlocmqPO3d2QxgqoKawO1WK8poK0x9F
	Y7D7IvU4gD8Us77FZZQ677Vy8IBTwdEZLxKpXTP94SnAGkRb5TJK93KaNkQncpbhkVcAdo
	QPLOacKzE87Vm/Xjcu1gdBfAl7ChlGc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774845047; a=rsa-sha256;
	cv=none;
	b=yT0V/PdH5/KjW1p4cTN53Zw1YCdN7tqX+M5yNi+I0orvEC5CHY5FwFBODfh45TinC5xjmf
	zRENN8b/RXb/XFXCRYXEoekTbyr7bGj8l9v189VmYjx2OnRrfKAV/6pw2GL/prmc9YhGmi
	Ro1BLuaMCM433Ag6QE0lpgs7mGa1kS4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BtsMefXT;
	spf=pass (imf08.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774845046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kv61ajyCc+m1Zr2ihJsLPfcGnhj6kHq30KwJ+MzkSds=;
	b=BtsMefXTW6h5pjePEwlk9bKVbhjfojnTG1T/bmSKEF97I3znqvRGLJ00BLO8jc+XsT/OSD
	2UjbRHKtJeW+9vs0OLjqFZ2Y8YJKkqXzPBwYnNyVmGboQXOdzF3ihrzUdoIVkSpjc/N18x
	l0WQGs23+xqrs7m4boqKhJ0wdFG7JLc=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-Lty0liMlPpuT2GfE0icIvA-1; Mon, 30 Mar 2026 00:30:44 -0400
X-MC-Unique: Lty0liMlPpuT2GfE0icIvA-1
X-Mimecast-MFC-AGG-ID: Lty0liMlPpuT2GfE0icIvA_1774845043
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-38a4c10df12so14944871fa.2
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:30:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774845043; x=1775449843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kv61ajyCc+m1Zr2ihJsLPfcGnhj6kHq30KwJ+MzkSds=;
        b=NZOfE3w3QLtwjulVvPOWX0qKZ7J72VasEOq/NyAFgHSaPyurodB8Z0ZpYm/JjSI0A5
         cW6DIaY00/JII4bGzdtpfI126GPgX3/wrmMVQLlZMKp9AI4V9IJFoZugOYFiPJ5lA2s6
         VFb3l8A1RVVjM9c4/RILZpjv0XQZJYkTxxrTDwJ7xbBrCBasd182/2qi4NkNMX/7y5CN
         67i4hc8BkMX1nfLBEehO3sq1FBxEiSrzcTphWgwQ5vO14n/B6D0fcWaRRfJXP6DHUJya
         aqA+iz8JdhxBdy7M7xNje+VWW3xjKxUXUNmY2FIv5J6vu3aQ9hoDEXemmatnhoYDxxuW
         Hp+A==
X-Gm-Message-State: AOJu0YzEpMBG/y9KlX+cQtg2CloUfLQd7qfFsLE7nHYuWkOZ8U7ZMbmU
	kJ+j8wkr700ruHymIu/7Z/PxifU1umbrQBPTEyZExkA4twEtveASCMIdSdbrMUUq4G8svmpL8Ts
	x0UJFNIiR/5Z7m9jqk6PkRxl0qRV6BjT+am4GFgDo1A8SlUorEx3RRf2fFdISu8UyLN63whvOun
	zSQrKsxu3piItCGZ9zy4JLPK+0C4Q2FEG0RmH8tg==
X-Gm-Gg: ATEYQzwCFv+f9pUf1wUf8a0zg9rIfDNAHjMfTuQVqzIibxN68L1/bNO36riXTXaVfLf
	TfmuziObXjLxPVHbqMdpHGBXOiw1OKvNYho7zy27L0S3BkNbxZjO35VJizkzxNugvJjkVYO+fU2
	oka40uE4LJl2RslgdJwjkZryavWd9rgZv4JXY4G5GHY+pykTW3If015Hc/V3seKUTUVo8BEYxUN
	3DwxvBZ8Qs0lC++oh5HKCfQEL9VYn2lmOUKAJnRC9NxDKj9TAwEwBmuzEbNNEvHM9Mgvi5KKIx8
	y4/SK2ImOTan0Qg4FoF6GAmzHosl6ODZS+jTpkLLVwThwafpi6o5p99D7LBEsbLR2MbzN6VR3Rv
	ZC4FSnZTc2eRndkAGOEPzHqmbwTN+l0EPOIOp
X-Received: by 2002:a05:651c:110e:b0:38a:49d1:3d with SMTP id 38308e7fff4ca-38c732638e5mr30547221fa.17.1774845042730;
        Sun, 29 Mar 2026 21:30:42 -0700 (PDT)
X-Received: by 2002:a05:651c:110e:b0:38a:49d1:3d with SMTP id 38308e7fff4ca-38c732638e5mr30547041fa.17.1774845042124;
        Sun, 29 Mar 2026 21:30:42 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c83729522sm12470671fa.14.2026.03.29.21.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 21:30:41 -0700 (PDT)
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
Date: Mon, 30 Mar 2026 07:30:13 +0300
Message-ID: <20260330043017.251808-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330043017.251808-1-mpenttil@redhat.com>
References: <20260330043017.251808-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dbZPwb1O33MVvpDbMLqSrc9K4EiRW2ATNB9lxXSgPIo_1774845043
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7542F160006
X-Stat-Signature: 1bgsj4fx7qukds8ae4xd97psmf6smanj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774845047-277996
X-HE-Meta: U2FsdGVkX18gidNujc7VgPmlToQdBSsyyxpQvulbnYyGO27fmp7hLpITeO+BTNNBQJdSTskVXTPvD/6Z68frqmk0kDg3joMJmnzI7KuJj6g0AfnA64iULeB+Jft9yVuHXq+Y7QLrSO2ww5qFqJqa5RT1nbgccYAJ6MTyV/jKCCmx1dBHl2eamIPbIMS4bJVxyeu6wlAgd+osOIlmUv9Xsj694DKER1BK04+gs3eVFBuI6JQtXQVequZ5238KIIbYXoEf7wexGpuHjM9ClzoIdPMg3acLi08Dt6BMp6wCkofqerzxFIweqSaxbawb5FAzIEAhfwWTFJ+z5fnzGqCRo4aoI4uKpP09SRWoP7TOLkWr/dsISHBLJid4uDfCKIwGzBpHq9c7Bw7Rso6yL9sjqTVT1bHjG/T7uI/IARFT87HT44fFzL3mh9jV8UYL47HEg3YGmXsVSvGZh03WvaBfSkIA9E68z6xygEw2xMVtPuDDOxF4voWiK3HCtlvd1c1nbEfeI6tDlPZHhKetQ/QDKM7v2/xRU63DqQ1Lpoez3ayxAUTCBIQDLrBm/YIABcFs9xpnNQjLBUB/Wm5IfU4B4bvfIeoWF4wGz+2MW5xoV6ocPERtzLQKCf7QaB6CVLmYIVVvKWVuhY6Ht9aQFRb1HUOvI683SRfoQIFzoY0nQeo2XGyh20yAHIq8Swp8v8csG6w9d8CRJuQ6GxWD85ZcSKqllT/Iag7XJWC9DSOXik5Yzm/cPzUxBCEHe6odfvwRJSz9qtUCBhWagQdNLI4vzvBg0YCEUsFeGHI1nqi/7mA41+xunNijk9BBoYTxrl+7OpStRgtZ1fUk7SBjhpURBfb+JVD9gdCTbU9Wo7qt+AjUHbdGMuzAQAiAObyY6Ear9B/sHsIrFlOEmzk8y0vLMf0/8SJOayLDb3dPCOEdztnUlWKrfeJH5P3AXopi4RQR1pj9k7JgQ7vNpkRbNZg
 fAgN3bmr
 hu3cT4+Tf47KJs235Ki4YnXlDjAn9OewiKhPzp84s2CJt/PVT1lx/Fv/Ec6JrLmP8lFDenU/+87EyIH/G91uTc3UH06EXT3BTU01s8rvir1F88uSpE6tp4X+SFj8YDLqsIXjrhQh8+K3OvldxRCdk2sOaR7RMt2uIHdbonpUfIzjzJWgl6VQh3xzh8LQVuW5vrAjJVDRUZIP3oKil/kkWfWI6sa9GS9WwB2LkFJwLDNIqtOlyiyOZvl+VcaS4dar4bcF94w8VxsLMT16AP9+4Sr27shhawtVUVbTIGImxdxT2TIE1RyW50WPQWNlriVjsgUTMKh6NkUwS7fE7qRjInEEx+21GrZNPqzDX53GS8SDkKF5iaNtPvONKpQ==
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


