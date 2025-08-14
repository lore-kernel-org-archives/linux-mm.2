Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E945ECA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A366900100; Thu, 14 Aug 2025 03:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 779EE900088; Thu, 14 Aug 2025 03:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66954900100; Thu, 14 Aug 2025 03:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 548BE900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:24:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EE1D0C05AF
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:38 +0000 (UTC)
X-FDA: 83774525436.07.5BD701F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id B2C9D14000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MwDtzNlr;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755156276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S7qbCEJdG1qU3nPZdac9XIOo/tgdpNyh0NlyCGdFYfo=;
	b=X5Ke2UN0fnN/p5/+2W1eLCZbCzxdAEf/EUCbNTqW1kss0ngUdhhavMD3Te5Of05cTitPuI
	b47U2ayefT4tzhxtcwRkZ/+tfMggTM+FYK+k1q44iiXBA4Vg27p/ATYiZZ3h61nPvyfHHX
	T06sQrr3YOPpp13YfKHcWmGi5vD/jXo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755156276; a=rsa-sha256;
	cv=none;
	b=WlafzL7lbHzrtnxw0ij8+YoFDiRutWM+T1qMqcJ/8mWvnws/wiMri0NHHxvLih9xeXA5St
	/+Tos7fdFiJCBzdMsY6kiL42CZ+7eR6sM4qNDatJgiLdhPgdEgMyx/8WHShEQb1rtbJbEu
	pPwXezW2gMHrFmT0jLKrVNgDaZilQuQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MwDtzNlr;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755156276;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=S7qbCEJdG1qU3nPZdac9XIOo/tgdpNyh0NlyCGdFYfo=;
	b=MwDtzNlreN+oLEa7II04kOQM1g2PbSJMg2a+Sgrq0pagNcq1LG6WvEojr4bMsMjhwEZaEc
	AfTy6ybGOn24nFVKgQdzEFJc9Mq9371tULcDQeDE8way/YTgkooVG3MZhF9WuDmyrGXGvo
	ipVEp3PdzAAuLMeI83Oryaxs/ZBqRSo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-78-hCoh1pcCOYa00HfX0qXgwQ-1; Thu, 14 Aug 2025 03:24:34 -0400
X-MC-Unique: hCoh1pcCOYa00HfX0qXgwQ-1
X-Mimecast-MFC-AGG-ID: hCoh1pcCOYa00HfX0qXgwQ_1755156273
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55ce521d3ecso282709e87.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755156272; x=1755761072;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7qbCEJdG1qU3nPZdac9XIOo/tgdpNyh0NlyCGdFYfo=;
        b=qjKt9xF1CJmz70H5RoikDRl+1oC/eciaZSV81tzgHTARfIrCZif/+bcTr3lhjK4CHn
         NrmdoCQii3GNESs0d/KIx4a8JZVcIYUJEKHMjqrUWeDoYo57nTwnr9g5oRwQ33hQhhEp
         blueZ92Dj5WU3oTwZRLi9F2nvCNKMRo4b22i5J5jSq6XG2sJG9lBbpWVHi8TL6kOZ8fY
         SG18f0+V4VD5XOA2rZcjsvkLV1z6DiW0Br+VA3RJPjG8kalNiLM5To5tdM5iz86F7GhA
         Ahun2MsXAMlMuDO4gT9Wq+UQoS10V3O8TR2h39U1QVicDN2G01hMg9z7bXCGNDSArkKu
         NxaA==
X-Gm-Message-State: AOJu0YyUGYMg27BCzJhlC2Ny2t3r6vghh954mp7Za6+fqA/5KsJsi0Ae
	oSjRJsf5fpLf2u+HwxUddTmPqQOXC+28bM5anPfozQLEN4X1rnYNktKBftfpfrcd00QaZ7HDT7n
	7qNxXm7jepBWlNUIKpOM/CiSYkEwyGKIJLCx88Oi92YG3b0MyT5yp9EE0dOakrhf+ouwW0gXwyr
	Q71EbHCW73Zrn/1ecgW3mftWLyOyQUnImkljs=
X-Gm-Gg: ASbGnctWyXj7lA9LPos1uofv/3Jmq5tx2/iYmh3qYZ5yQdAmYU/KLPDFfnI9oJV45tW
	58wUqBvrHviu9Qg8PIfuDRmFI0AM4Nu5sBF502L+oJxHMruCUSAHOVirX0tK39xHnHUynNkcvA2
	RIcGw4D4ArlyhKdyU65mDheTEI8Sde1CUMFsKFSDnumzbgLCM0/Mt5/zlxQQJ7hMUx8ZCjBXGgP
	kDNYsj+tarWSfAXyV4aQoU1h9xTszBUS9DjxIaE0VQacTgh/xAskwUugBTB9Vg0Z14oL1NQvPW7
	oic25EMtNX0lI9IUoJL2VjQ2cALCZtcMmcuc9T3tA24u3rf3zwfBqeo=
X-Received: by 2002:a05:6512:400d:b0:55c:c9d5:d347 with SMTP id 2adb3069b0e04-55ce501c558mr640448e87.35.1755156271705;
        Thu, 14 Aug 2025 00:24:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTVhKdmp6e4M2S2jqprwboYLdHjne3GHrTQPewn0l8OaZqpbP/o3ZucOCSpjNeg2931+N2BQ==
X-Received: by 2002:a05:6512:400d:b0:55c:c9d5:d347 with SMTP id 2adb3069b0e04-55ce501c558mr640425e87.35.1755156271046;
        Thu, 14 Aug 2025 00:24:31 -0700 (PDT)
Received: from fedora (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b887f72f4sm5620240e87.0.2025.08.14.00.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 00:24:30 -0700 (PDT)
From: =?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>
Subject: [RFC PATCH 2/4] mm: unified fault and migrate device page paths
Date: Thu, 14 Aug 2025 10:19:27 +0300
Message-ID: <20250814072045.3637192-4-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250814072045.3637192-1-mpenttil@redhat.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: oUQZbDYWujzfLowAEXXBKgsKOcwrUf1iOm67rkZ7i3M_1755156273
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B2C9D14000D
X-Stat-Signature: kft4q65s1zxpcgk98kdggxh8daktyfga
X-Rspam-User: 
X-HE-Tag: 1755156276-104199
X-HE-Meta: U2FsdGVkX1/PthJVwl5lgywvMPglaQr5MX+NHoe9eFuqWq73yVP+GzGN//ns70dpKvjFvSF9Z0VFVSeRgILJ5eVWEQHZ6lgPIV6KP2YeejCMgbmRBvTqUJIZ5fydzzVkHPAx3fFrrp28UnZR1YW694t8vbuP9Pp1kB44TYoK+Skn309d0wCkZbFTw0Qn7n9RHD8fqbl9OeAOFxMXGLw8JvSFRGXBy003/hW77wB95cRilDwnTSBJJf8I2b0kryjgYX80Ce1GbB2y+zEmjrCWwMqDy6YbSl0IvWOkUGFt24fsPjr0i35GD794L9tLKoJm5MVy0eb0CRStTV2BZFLY9tQqHgmVyMdh4LyGK0Z+P6CDBdD/YH719lh15EcknZVlxoPl3w6+rBVjENG3gnVpz63Qm/SV9yQ/IQd7/iVLiFc5knwPaD1MPpUt90/bJj6Q5oVA0W2Q5eIqNC3LMyxKWIqsQ9RtdIw4tBtmMWF8NpQcz9hSmHd8by7oytewMnkrzGJSJ6MjZO+w/KPk/xWrlh/z8J6Jy1U3i+0j1g3k15C9IeVKpm603exGbFsbi8D1ur1Aa8uvjffvvlMu1U9U9YLJMT4pnkZOnos2rOYPkAZa6uWQUX/x1arQvX4sDnGqCAsdPX0tMRSL/EEQZoGTzl+EOPxwqG6rVEqs1n5ohLcv1SqrCEfYrHHiWXMgsHeLWrcETuTHjhOvRpHmAGyVAmXF+ryXKk67p4qSkSIxlDw7fWta8yczopTPQ99J1XvWLbiIrmCAz8lNhHPuBLSRmkXJyU1hQOJWnObcxPFpn4hn3WiVslfB1z9CONoiIjiNbZbR02EMasKwAbOceZhUtK559EH7SPBj6CYJ3MuVXwmDukQC1Mme73zVcvIC9Nr91Mfdtu6g3kNjYzQWX4OkllLUwVzwI05CprDdkeDWPCKHLGFjIoIB7EKXhqJhJ2ErHC2rx5nIg2ZTtxzaBOj
 5Aqtlqlw
 Od7Sd2NfqXnxwqO8EwHoGSpPkWwbpNUMICs5nztfVWcSBADAyUD7HZEGeNB9XIpVrnm5a0+6TIr2s9JMv5+t5jAYag3+dD1vn7g2Z88AowNeRmEWW2SI6DNczRC8vnCGihLBhhpAM3RxHhZTsbSLjTCDYcACG2lqymsjYzx+gxb5j4Qgl2SjGGZn2WqDWkgw4md60VRwwj6QztAAFwCqtXeXwMcA8+3o7bGhrXMesM95MqxkvJI39ShW70Xp3q3lptoandUXACVDUl1UZw/KvFFXGvLUpvEWVSBW31f6GXAA/KkB14TiQ+1Abfn87ggN8ZfiQ9GXvtLK4jC3mHbyZeaLZN5e69B9GspMRB2kUn8KgIV+5hZsl9+anmsv5K1HYbl2y0lAkhzSEMSPsfgCwVSSn2C1USW8M7FyuBFrWhzP+lSuFcAZkC1aIAFH/LvwCs5lkd5h9Bg3ceQ8ZpbdrDOKXLQcLXIaVBOHCZelSOaHVlgtpdhkijwknbYbS5k1LexHK0TJU5qL8BgbcC02U9L4mxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As of this writing, the way device page faulting and migration works
is not optimal, if you want to do both fault handling and
migration at once.

Being able to migrate not present pages (or pages mapped with incorrect
permissions, eg. COW) to the GPU requires doing either of the
following sequences:

1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
2. migrate_vma_*() - migrate the pages

Or:

1. migrate_vma_*() - migrate present pages
2. If non-present pages detected by migrate_vma_*():
   a) call hmm_range_fault() to fault pages in
   b) call migrate_vma_*() again to migrate now present pages

The problem with the first sequence is that you always have to do two
page walks even when most of the time the pages are present or zero page
mappings so the common case takes a performance hit.

The second sequence is better for the common case, but far worse if
pages aren't present because now you have to walk the page tables three
times (once to find the page is not present, once so hmm_range_fault()
can find a non-present page to fault in and once again to setup the
migration). It also tricky to code correctly.

We should be able to walk the page table once, faulting
pages in as required and replacing them with migration entries if
requested.

Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
which tells to prepare for migration also during fault handling.
Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
is added to tell to add fault handling to migrate.

Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>

Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 include/linux/hmm.h     |  10 +-
 include/linux/migrate.h |   6 +-
 mm/hmm.c                | 351 ++++++++++++++++++++++++++++++++++++++--
 mm/migrate_device.c     |  72 ++++++++-
 4 files changed, 420 insertions(+), 19 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index db75ffc949a7..7485e549c675 100644
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
@@ -48,11 +48,14 @@ enum hmm_pfn_flags {
 	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
 	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
 
-	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
+	/* Migrate request */
+	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
+	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 12),
 
 	/* Input flags */
 	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
 	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
+	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
 
 	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
 };
@@ -107,6 +110,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
  * @default_flags: default flags for the range (write, read, ... see hmm doc)
  * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
  * @dev_private_owner: owner of device private pages
+ * @migrate: structure for migrating the associated vma
  */
 struct hmm_range {
 	struct mmu_interval_notifier *notifier;
@@ -117,12 +121,14 @@ struct hmm_range {
 	unsigned long		default_flags;
 	unsigned long		pfn_flags_mask;
 	void			*dev_private_owner;
+	struct migrate_vma      *migrate;
 };
 
 /*
  * Please see Documentation/mm/hmm.rst for how to use the range API.
  */
 int hmm_range_fault(struct hmm_range *range);
+int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
 
 /*
  * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index acadd41e0b5c..ab35d0f1f65d 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -3,6 +3,7 @@
 #define _LINUX_MIGRATE_H
 
 #include <linux/mm.h>
+#include <linux/hmm.h>
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
@@ -143,10 +144,11 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
 	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
 }
 
-enum migrate_vma_direction {
+enum migrate_vma_info {
 	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
 	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
 	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
+	MIGRATE_VMA_FAULT = 1 << 3,
 };
 
 struct migrate_vma {
@@ -194,7 +196,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
 			unsigned long npages);
 void migrate_device_finalize(unsigned long *src_pfns,
 			unsigned long *dst_pfns, unsigned long npages);
-
+void migrate_hmm_range_setup(struct hmm_range *range);
 #endif /* CONFIG_MIGRATION */
 
 #endif /* _LINUX_MIGRATE_H */
diff --git a/mm/hmm.c b/mm/hmm.c
index d545e2494994..8cb2b325fa9f 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -20,6 +20,7 @@
 #include <linux/pagemap.h>
 #include <linux/swapops.h>
 #include <linux/hugetlb.h>
+#include <linux/migrate.h>
 #include <linux/memremap.h>
 #include <linux/sched/mm.h>
 #include <linux/jump_label.h>
@@ -33,6 +34,10 @@
 struct hmm_vma_walk {
 	struct hmm_range	*range;
 	unsigned long		last;
+	struct mmu_notifier_range mmu_range;
+	struct vm_area_struct 	*vma;
+	unsigned long 		start;
+	unsigned long 		end;
 };
 
 enum {
@@ -47,15 +52,33 @@ enum {
 			      HMM_PFN_P2PDMA_BUS,
 };
 
+static enum migrate_vma_info hmm_want_migrate(struct hmm_range *range)
+{
+	enum migrate_vma_info minfo;
+
+	minfo = range->migrate ? range->migrate->flags : 0;
+	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
+		MIGRATE_VMA_SELECT_SYSTEM : 0;
+
+	return minfo;
+}
+
 static int hmm_pfns_fill(unsigned long addr, unsigned long end,
-			 struct hmm_range *range, unsigned long cpu_flags)
+			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
 {
+	struct hmm_range *range = hmm_vma_walk->range;
 	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
 
+	if (cpu_flags != HMM_PFN_ERROR)
+		if (hmm_want_migrate(range) &&
+		    (vma_is_anonymous(hmm_vma_walk->vma)))
+			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
+
 	for (; addr < end; addr += PAGE_SIZE, i++) {
 		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
 		range->hmm_pfns[i] |= cpu_flags;
 	}
+
 	return 0;
 }
 
@@ -171,11 +194,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 	if (!walk->vma) {
 		if (required_fault)
 			return -EFAULT;
-		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
 	if (required_fault)
 		return hmm_vma_fault(addr, end, required_fault, walk);
-	return hmm_pfns_fill(addr, end, range, 0);
+	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
 }
 
 static inline unsigned long hmm_pfn_flags_order(unsigned long order)
@@ -326,6 +349,257 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	return hmm_vma_fault(addr, end, required_fault, walk);
 }
 
+/*
+ * Install migration entries if migration requested, either from fault
+ * or migrate paths.
+ *
+ */
+static void hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
+					   pmd_t *pmdp,
+					   unsigned long addr,
+					   unsigned long *hmm_pfn)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct mm_struct *mm = walk->vma->vm_mm;
+	struct folio *fault_folio = NULL;
+	enum migrate_vma_info minfo;
+	struct dev_pagemap *pgmap;
+	bool anon_exclusive;
+	struct folio *folio;
+	unsigned long pfn;
+	struct page *page;
+	swp_entry_t entry;
+	pte_t pte, swp_pte;
+	spinlock_t *ptl;
+	bool writable = false;
+	pte_t *ptep;
+
+
+	// Do we want to migrate at all?
+	minfo = hmm_want_migrate(range);
+	if (!minfo)
+		return;
+
+	fault_folio = (migrate && migrate->fault_page) ?
+		page_folio(migrate->fault_page) : NULL;
+
+	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
+	if (!ptep)
+		return;
+
+	pte = ptep_get(ptep);
+
+	if (pte_none(pte)) {
+		// migrate without faulting case
+		if (vma_is_anonymous(walk->vma))
+			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
+		goto out;
+	}
+
+	if (!(*hmm_pfn & HMM_PFN_VALID))
+		goto out;
+
+	if (!pte_present(pte)) {
+		/*
+		 * Only care about unaddressable device page special
+		 * page table entry. Other special swap entries are not
+		 * migratable, and we ignore regular swapped page.
+		 */
+		entry = pte_to_swp_entry(pte);
+		if (!is_device_private_entry(entry))
+			goto out;
+
+		// We have already checked that are the pgmap owners
+		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
+			goto out;
+
+		page = pfn_swap_entry_to_page(entry);
+		pfn = page_to_pfn(page);
+		if (is_writable_device_private_entry(entry))
+			writable = true;
+	} else {
+		pfn = pte_pfn(pte);
+		if (is_zero_pfn(pfn) &&
+		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
+			goto out;
+		}
+		page = vm_normal_page(walk->vma, addr, pte);
+		if (page && !is_zone_device_page(page) &&
+		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
+			goto out;
+		} else if (page && is_device_coherent_page(page)) {
+			pgmap = page_pgmap(page);
+
+			if (!(minfo &
+			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
+			    pgmap->owner != migrate->pgmap_owner)
+				goto out;
+		}
+		writable = pte_write(pte);
+	}
+
+	/* FIXME support THP */
+	if (!page || !page->mapping || PageTransCompound(page))
+		goto out;
+
+	/*
+	 * By getting a reference on the folio we pin it and that blocks
+	 * any kind of migration. Side effect is that it "freezes" the
+	 * pte.
+	 *
+	 * We drop this reference after isolating the folio from the lru
+	 * for non device folio (device folio are not on the lru and thus
+	 * can't be dropped from it).
+	 */
+	folio = page_folio(page);
+	folio_get(folio);
+
+	/*
+	 * We rely on folio_trylock() to avoid deadlock between
+	 * concurrent migrations where each is waiting on the others
+	 * folio lock. If we can't immediately lock the folio we fail this
+	 * migration as it is only best effort anyway.
+	 *
+	 * If we can lock the folio it's safe to set up a migration entry
+	 * now. In the common case where the folio is mapped once in a
+	 * single process setting up the migration entry now is an
+	 * optimisation to avoid walking the rmap later with
+	 * try_to_migrate().
+	 */
+
+	if (fault_folio == folio || folio_trylock(folio)) {
+		anon_exclusive = folio_test_anon(folio) &&
+			PageAnonExclusive(page);
+
+		flush_cache_page(walk->vma, addr, pfn);
+
+		if (anon_exclusive) {
+			pte = ptep_clear_flush(walk->vma, addr, ptep);
+
+			if (folio_try_share_anon_rmap_pte(folio, page)) {
+				set_pte_at(mm, addr, ptep, pte);
+				folio_unlock(folio);
+				folio_put(folio);
+				goto out;
+			}
+		} else {
+			pte = ptep_get_and_clear(mm, addr, ptep);
+		}
+
+		/* Setup special migration page table entry */
+		if (writable)
+			entry = make_writable_migration_entry(pfn);
+		else if (anon_exclusive)
+			entry = make_readable_exclusive_migration_entry(pfn);
+		else
+			entry = make_readable_migration_entry(pfn);
+
+		swp_pte = swp_entry_to_pte(entry);
+		if (pte_present(pte)) {
+			if (pte_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_uffd_wp(pte))
+				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+		} else {
+			if (pte_swp_soft_dirty(pte))
+				swp_pte = pte_swp_mksoft_dirty(swp_pte);
+			if (pte_swp_uffd_wp(pte))
+				swp_pte = pte_swp_mkuffd_wp(swp_pte);
+		}
+
+		set_pte_at(mm, addr, ptep, swp_pte);
+		folio_remove_rmap_pte(folio, page, walk->vma);
+		folio_put(folio);
+		*hmm_pfn |= HMM_PFN_MIGRATE;
+
+		if (pte_present(pte))
+			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
+	} else
+		folio_put(folio);
+out:
+	pte_unmap_unlock(ptep, ptl);
+
+}
+
+static int hmm_vma_walk_split(pmd_t *pmdp,
+			      unsigned long addr,
+			      struct mm_walk *walk)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+	struct migrate_vma *migrate = range->migrate;
+	struct folio *folio, *fault_folio;
+	spinlock_t *ptl;
+	int ret = 0;
+
+	fault_folio = (migrate && migrate->fault_page) ?
+		page_folio(migrate->fault_page) : NULL;
+
+	ptl = pmd_lock(walk->mm, pmdp);
+	if (unlikely(!pmd_trans_huge(*pmdp))) {
+		spin_unlock(ptl);
+		goto out;
+	}
+
+	folio = pmd_folio(*pmdp);
+	if (is_huge_zero_folio(folio)) {
+		spin_unlock(ptl);
+		split_huge_pmd(walk->vma, pmdp, addr);
+	} else {
+		folio_get(folio);
+		spin_unlock(ptl);
+		/* FIXME: we don't expect THP for fault_folio */
+		if (WARN_ON_ONCE(fault_folio == folio)) {
+			folio_put(folio);
+			ret = -EBUSY;
+			goto out;
+		}
+		if (unlikely(!folio_trylock(folio))) {
+			folio_put(folio);
+			ret = -EBUSY;
+			goto out;
+		}
+		ret = split_folio(folio);
+		folio_unlock(folio);
+		folio_put(folio);
+	}
+out:
+	return ret;
+}
+
+static int hmm_vma_capture_migrate_range(unsigned long start,
+					 unsigned long end,
+					 struct mm_walk *walk)
+{
+	struct hmm_vma_walk *hmm_vma_walk = walk->private;
+	struct hmm_range *range = hmm_vma_walk->range;
+
+	if (!hmm_want_migrate(range))
+		return 0;
+
+	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
+		return -ERANGE;
+
+	hmm_vma_walk->vma = walk->vma;
+	hmm_vma_walk->start = start;
+	hmm_vma_walk->end = end;
+
+	if (end - start > range->end - range->start)
+		return -ERANGE;
+
+	if (!hmm_vma_walk->mmu_range.owner) {
+		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
+					      walk->vma->vm_mm, start, end,
+					      range->dev_private_owner);
+		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
+	}
+
+	return 0;
+}
+
 static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			    unsigned long start,
 			    unsigned long end,
@@ -351,13 +625,28 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			pmd_migration_entry_wait(walk->mm, pmdp);
 			return -EBUSY;
 		}
-		return hmm_pfns_fill(start, end, range, 0);
+		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
 	}
 
 	if (!pmd_present(pmd)) {
 		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 			return -EFAULT;
-		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
+	}
+
+	if (hmm_want_migrate(range) &&
+	    pmd_trans_huge(pmd)) {
+		int r;
+
+		r = hmm_vma_walk_split(pmdp, addr, walk);
+		if (r) {
+			/* Split not successful, skip */
+			return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
+		}
+
+		/* Split successful or "again", reloop */
+		hmm_vma_walk->last = addr;
+		return -EBUSY;
 	}
 
 	if (pmd_trans_huge(pmd)) {
@@ -386,7 +675,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	if (pmd_bad(pmd)) {
 		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 			return -EFAULT;
-		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 	}
 
 	ptep = pte_offset_map(pmdp, addr);
@@ -400,8 +689,11 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 			/* hmm_vma_handle_pte() did pte_unmap() */
 			return r;
 		}
+
+		hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
 	}
 	pte_unmap(ptep - 1);
+
 	return 0;
 }
 
@@ -535,6 +827,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
 	struct hmm_range *range = hmm_vma_walk->range;
 	struct vm_area_struct *vma = walk->vma;
+	int r;
+
+	r = hmm_vma_capture_migrate_range(start, end, walk);
+	if (r)
+		return r;
 
 	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
 	    vma->vm_flags & VM_READ)
@@ -557,7 +854,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
 				 (end - start) >> PAGE_SHIFT, 0))
 		return -EFAULT;
 
-	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
+	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
 
 	/* Skip this vma and continue processing the next vma. */
 	return 1;
@@ -587,9 +884,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
  *		the invalidation to finish.
  * -EFAULT:     A page was requested to be valid and could not be made valid
  *              ie it has no backing VMA or it is illegal to access
+ * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
+ *              is too low.
  *
  * This is similar to get_user_pages(), except that it can read the page tables
  * without mutating them (ie causing faults).
+ *
+ * If want to do migrate after faultin, call hmm_range_fault() with
+ * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
+ * After hmm_range_fault() call migrate_hmm_range_setup() instead of
+ * migrate_vma_setup() and after that follow normal migrate calls path.
+ *
  */
 int hmm_range_fault(struct hmm_range *range)
 {
@@ -597,16 +902,28 @@ int hmm_range_fault(struct hmm_range *range)
 		.range = range,
 		.last = range->start,
 	};
-	struct mm_struct *mm = range->notifier->mm;
+	bool is_fault_path = !!range->notifier;
+	struct mm_struct *mm;
 	int ret;
 
+	/*
+	 *
+	 *  Could be serving a device fault or come from migrate
+	 *  entry point. For the former we have not resolved the vma
+	 *  yet, and the latter we don't have a notifier (but have a vma).
+	 *
+	 */
+	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
 	mmap_assert_locked(mm);
 
 	do {
 		/* If range is no longer valid force retry. */
-		if (mmu_interval_check_retry(range->notifier,
-					     range->notifier_seq))
-			return -EBUSY;
+		if (is_fault_path && mmu_interval_check_retry(range->notifier,
+					     range->notifier_seq)) {
+			ret = -EBUSY;
+			break;
+		}
+
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
 		/*
@@ -616,6 +933,18 @@ int hmm_range_fault(struct hmm_range *range)
 		 * output, and all >= are still at their input values.
 		 */
 	} while (ret == -EBUSY);
+
+	if (hmm_want_migrate(range) && range->migrate &&
+	    hmm_vma_walk.mmu_range.owner) {
+		// The migrate_vma path has the following initialized
+		if (is_fault_path) {
+			range->migrate->vma   = hmm_vma_walk.vma;
+			range->migrate->start = range->start;
+			range->migrate->end   = hmm_vma_walk.end;
+		}
+		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL(hmm_range_fault);
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index e05e14d6eacd..87ddc0353165 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -535,7 +535,18 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
  */
 int migrate_vma_setup(struct migrate_vma *args)
 {
+	int ret;
 	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
+	struct hmm_range range = {
+		.notifier = NULL,
+		.start = args->start,
+		.end = args->end,
+		.migrate = args,
+		.hmm_pfns = args->src,
+		.default_flags = HMM_PFN_REQ_MIGRATE,
+		.dev_private_owner = args->pgmap_owner,
+		.migrate = args
+	};
 
 	args->start &= PAGE_MASK;
 	args->end &= PAGE_MASK;
@@ -560,17 +571,19 @@ int migrate_vma_setup(struct migrate_vma *args)
 	args->cpages = 0;
 	args->npages = 0;
 
-	migrate_vma_collect(args);
+	if (args->flags & MIGRATE_VMA_FAULT)
+		range.default_flags |= HMM_PFN_REQ_FAULT;
 
-	if (args->cpages)
-		migrate_vma_unmap(args);
+	ret = hmm_range_fault(&range);
+
+	migrate_hmm_range_setup(&range);
 
 	/*
 	 * At this point pages are locked and unmapped, and thus they have
 	 * stable content and can safely be copied to destination memory that
 	 * is allocated by the drivers.
 	 */
-	return 0;
+	return ret;
 
 }
 EXPORT_SYMBOL(migrate_vma_setup);
@@ -1014,3 +1027,54 @@ int migrate_device_coherent_folio(struct folio *folio)
 		return 0;
 	return -EBUSY;
 }
+
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
+			continue;
+		}
+
+		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
+			| MIGRATE_PFN_MIGRATE;
+		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
+	}
+
+	if (migrate->cpages)
+		migrate_vma_unmap(migrate);
+
+}
+EXPORT_SYMBOL(migrate_hmm_range_setup);
-- 
2.50.0


