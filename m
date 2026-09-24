Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57337C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EAE76B00A5; Thu, 24 Sep 2026 02:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89B9E6B00A6; Thu, 24 Sep 2026 02:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73C5B6B00A7; Thu, 24 Sep 2026 02:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44D846B00A5
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:54:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C64AB14029A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:12 +0000 (UTC)
X-FDA: 85247741544.06.79DDDA2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 80F50120008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:54:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UHbcLD07;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790232850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2s7sy+SVvRc4UpGAfkya5y1O6jc//tVZw1Co8TmbAlo=;
	b=IwUvCNt8nClCJLRWCPYkych+MTNJdUyNGf9Ym23CFLbPE8xt6nGHExfxaK9fZvaZgEL7kn
	/kUqSWJgOhBqXVyzUVQkX1l5VfvASCr3VLf7asjBlNeRSp//kw8in5DRcoDCTMMGmtfpns
	8lsCw0mMSccTn+4AgvStn1OfHGgw69Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UHbcLD07;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790232850;
	b=pJ7TAWqa3QQacxU2yIZ8i/PnE8RzIFvg5DLi8QwLa/cU6RkmaxwTnFMfhdqWDXxS6iX9AO
	4iP+6syIX/NoCC3Jnj3v30UHVxzrq7eL1W5fYWSUeFAdC4Evq0LZRUCUM2rK5X4TDQinuF
	w8cjrmCa2S6Hw3ODG/QZhgj+w0zdoq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790232850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2s7sy+SVvRc4UpGAfkya5y1O6jc//tVZw1Co8TmbAlo=;
	b=UHbcLD07+fhmSglViDYTB2Qx5McEW83uB8CLJnDeZ9XFzjYyCFhkKTC44vdCM8nEWeLx7B
	FUE2aruRV3pphlZ9Sop3RLW6giBd9/DrFfUR7RNqX+GnM5KloojALruMqc0Bl/1WE9PuUr
	8t7x4v4tCnM1WdwTBKiwfknVN+UVPnc=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-BO7Dqrf2MJyDBsvbRSQXnQ-1; Thu, 24 Sep 2026 02:54:08 -0400
X-MC-Unique: BO7Dqrf2MJyDBsvbRSQXnQ-1
X-Mimecast-MFC-AGG-ID: BO7Dqrf2MJyDBsvbRSQXnQ_1790232847
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3a27d89a894so7817891fa.3
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:54:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790232847; x=1790837647;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2s7sy+SVvRc4UpGAfkya5y1O6jc//tVZw1Co8TmbAlo=;
        b=bYCfx7Gqj7K/1euZtgkiHYukvavF6Sgwal6tOHptVLXZqgT8NXcisMrQpKDZA40KIf
         7oeUrAVd1B85Jt44kjOBpEmQn+mS94s3g9FhKkbVUYKxLzDydHcFCXSSPW7f2BzEjIVL
         //Yvo7xQPpDvZ+E064ahBdFINN1DMSruhjcoHjVelCZ2Qd6IzLKyd33Fjx3zEyw0nJga
         uby6xaNDGe+VtzeOWQBPiTYonC4eOT8Va7tzH4UJXZRsiu+hN3xFy9rlgTlcp0v386DW
         quyDulv9quGja68QppNYxJia6+vKDitacDFBdxfN3KYse5my1jCUOxN2E/wiqYxA9qOO
         cqGg==
X-Gm-Message-State: AFuF++m/33MNYbMbbxZj8HqDiwDjKJWkk2Nagk4FL/MfkQ9cTrIgzZCf
	/TcT2xoDm3E86NjcNh3LDqLjIX5sUgt+2NtWpwUgMtQMd+MCtFcupKxnG1lglTO0lD46LjaDNO8
	a6W6bNq6GNLpR7jbTe1eoyE25Umh9k/btRn+XOO5lCMeruC7hzeGYvJDET49yo1zehqlKQP0WQy
	ctN8ugw4RvQf5Q0+83BE8Xt9T0YKlTA2PPTL5Usw==
X-Gm-Gg: AYBFou2aXBj8upnurfPzgwUrx5QvAWhhc8O+0C17ZU/KafUCs9DzBrf3R7RT+Oxn5l7
	AP4jQwGIbHnE3SSdxlYUGK559O4h9chnmo4VMheMByOC5iS4gmOMWVtyFnI4nfsttx0bqdIV/cn
	mHq0smShuvePiSPUnvLRoeIWIiZcUnAb1l9/vFUx7XIjUogN2KGoI47JfBOt6307VODCHDY79Ka
	d8o8ZuQme0TwDw6nSJ+3dg646ivH9UMPuSmoDWP9nZ1ULonoAys5qD6JhFiP8aWVq9igPkFCyfU
	OXLXg5USD03o1Y5JbpMaVN/sliNkGIdUpfxOOkbseoPXBMaVhSD6lTeTlL5JGNvEyBNL0mSGzbJ
	/phyuHfG1+zNO1+mwO0kj
X-Received: by 2002:a2e:be1d:0:b0:3a5:dfe2:7f5c with SMTP id 38308e7fff4ca-3a63c0df7bemr3353141fa.16.1790232847063;
        Wed, 23 Sep 2026 23:54:07 -0700 (PDT)
X-Received: by 2002:a2e:be1d:0:b0:3a5:dfe2:7f5c with SMTP id 38308e7fff4ca-3a63c0df7bemr3352851fa.16.1790232846449;
        Wed, 23 Sep 2026 23:54:06 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a63bf57909sm4803141fa.29.2026.09.23.23.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 23:54:05 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v15 10/11] lib/test_hmm: add a new testcase for the migrate on fault
Date: Thu, 24 Sep 2026 09:53:12 +0300
Message-ID: <20260924065313.899730-11-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260924065313.899730-1-mpenttil@redhat.com>
References: <20260924065313.899730-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0Yj8G4K7ZvnHbVwuoyu_8POS4_olArNbSDsPxw_gN4Q_1790232847
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80F50120008
X-Stat-Signature: peaj83ifrsakicjfp36h63owdscjw4ax
X-Rspam-User: 
X-HE-Tag: 1790232850-177004
X-HE-Meta: U2FsdGVkX1/LH0JMjW/9GautNXnDvmFIzJPjHJ9PjphAk3c3yNEwd39IwpKmPaZv3oaRQac2qjWiaU7jUpo3rADh40rzmbLxo9HhX5MuboKVOijnaq/OVI0LO2tn6MY7rjIREYJSKayzkeATE6K/IT1M1DAz0ChXnN3jv94xHcrJFtOfX/8Vm/2a2KKtrDHbJFyZHREvLXetxc4g90d3+i/h/cSUmFCeu7b9y1D8sbB6M9Fb8eTnYP8ck9cLJTjV64HT+aHJkRupvHNhud9jVTzXnQ6kWH7kcuBt6xYXTq89MzM1ghNhBOhda5El+j9TdY2UKgw4K0oAO7DCUCxQB7vhgtu3JFsIxcph88wpor6TRjM7KLVSCmeyya7EVsqFac2bo2owGn5Z/SE0bEX8frv3M2HdnoXHgOoW7trrklnCiBeCLzlIXyO30IqfQNJnrwxXTmzFcz2Hj+XAx/1y1xW5RsFx3KLPYcQdyiX0moifxqBSry3vkU6PtrFIlLwChblgaXEaxfHAcE1UrDwnMKXhKH59L6XO4sC1j6O6K5cPcyaU7VRmgpInPwG3yz+WOJkuWEeHIt4XmWZAXQQjTqSmkgU8+J6hG8b7LSlxFFKVF5FBxtjzUmPgtdA1r28xr3D4/5uMH4MOPDClN4U+BTJPdMP5NA7Yg3yd/Hi+N+a+gvaEMLQdPKGYme2lKk6FmzUZoTZPWiUhc6Y28dfOO8qYA95gKc2oGu+hRBEOOdqXW63U7ZqyrsJGR8D3ESdJqT6QgY2fkGCDJ+dUnsUpBc7h10zAKzCIbFwiG6ifj/hGlMOm7IW48I2wNK0ZaKWRGGLQktWy6RWZVGldbP8+uhq/inQdhsXXLjEOc9EmNstSjzr9L0AunhlS/ZqduSJ8rdVNqta6YnTiH7DUynbBCGvzdUY79h3FQuSDzyPIg2ohFP18GDbBzh72DSBw9C5fEwUKRMpibbIT+uSJmKW
 q8AVPvkp
 1s/ZkzDlysFJC3VZIF+oVXX/qymruiuKUMxmBRKjkcSJEdW/bGNWSSNQxdoYRaC0I0uetv6x3U7JnnKaZ6JzdwujSO4nDLxYo2Q8dAC1KGExm4kVqCtxhAEHZf3a68mpuPvd3kksw1XbCgWhy4yVREYKcx4niSoQZORZBVqvhGBCr+H8WPB30hhonkY4yJemJoMxoUIerDa4KH+5GQEqB/S3/DxWCc9X5bLK2R61HLD3I621Inz/mxDqnWbltf9Tp081Q+GjYqByuZUZaeNcwTgAXCJxleJNjUd8ogXyx4cbOKKfuWsza/iiMaKZ2JO45kI3CEZ6jrXBJmSiImB9bjN+VbVZI+FhYpDvslFlkIv/GYV8FH6Qdr8MXicRN7PoNQDVzSsA3aMVusHKep77p3FXfGkAAyCOp+HABDJDoJhaIPqSH48gf92xx+k5FqipWQNsyENGSwnNuqi9d0IrZw7H3wZAWBU7N7zyTqXMuBVp08Wyp9ysGT1o1peMEFe3m2MM86INcn+93Fo0FGYpIFhgXzKQUePTVod5+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Enhance the hmm test driver (lib/test_hmm) with migrate on fault case.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 lib/test_hmm.c                         | 172 +++++++++++++++++++++++--
 lib/test_hmm_uapi.h                    |  21 +--
 tools/testing/selftests/mm/hmm-tests.c |  54 ++++++++
 3 files changed, 224 insertions(+), 23 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index cd88e8177d0a..31608b6998bb 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -355,6 +356,7 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 	struct mm_struct *mm = dmirror->notifier.mm;
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	bool migrate = range->default_flags & HMM_PFN_REQ_MIGRATE;
 	int ret;
 
 	while (true) {
@@ -364,9 +366,15 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 		}
 
 		range->notifier_seq = mmu_interval_read_begin(range->notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(range);
-		mmap_read_unlock(mm);
+
+		/* mmap lock held for whole migrate on fault operation */
+		if (!migrate) {
+			mmap_read_lock(mm);
+			ret = hmm_range_fault(range);
+			mmap_read_unlock(mm);
+		} else {
+			ret = hmm_range_fault(range);
+		}
 		if (ret) {
 			if (ret == -EBUSY)
 				continue;
@@ -382,7 +390,9 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 		break;
 	}
 
-	ret = dmirror_do_fault(dmirror, range);
+	/* update device page table after migration */
+	if (!migrate)
+		ret = dmirror_do_fault(dmirror, range);
 
 	mutex_unlock(&dmirror->mutex);
 out:
@@ -994,8 +1004,12 @@ static int dmirror_atomic_map(unsigned long addr, struct page *page,
 	return 0;
 }
 
-static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
-					    struct dmirror *dmirror)
+/*
+ * Map the migrated pages into the device's page table. Caller must hold
+ * dmirror->mutex.
+ */
+static int __dmirror_migrate_map_locked(struct migrate_vma *args,
+					struct dmirror *dmirror)
 {
 	unsigned long start = args->start;
 	unsigned long end = args->end;
@@ -1005,9 +1019,6 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 	const unsigned long start_pfn = start >> PAGE_SHIFT;
 	const unsigned long end_pfn = end >> PAGE_SHIFT;
 
-	/* Map the migrated pages into the device's page tables. */
-	mutex_lock(&dmirror->mutex);
-
 	for (pfn = start_pfn; pfn < end_pfn; pfn++, src++, dst++) {
 		struct page *dpage;
 		void *entry;
@@ -1036,17 +1047,27 @@ static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
 			if (*dst & MIGRATE_PFN_WRITE)
 				entry = xa_tag_pointer(entry, DPT_XA_TAG_WRITE);
 			entry = xa_store(&dmirror->pt, pfn + i, entry, GFP_ATOMIC);
-			if (xa_is_err(entry)) {
-				mutex_unlock(&dmirror->mutex);
+			if (xa_is_err(entry))
 				return xa_err(entry);
-			}
 		}
 	}
 
-	mutex_unlock(&dmirror->mutex);
 	return 0;
 }
 
+static int dmirror_migrate_finalize_and_map(struct migrate_vma *args,
+					    struct dmirror *dmirror)
+{
+	int ret;
+
+	/* Map the migrated pages into the device's page tables. */
+	mutex_lock(&dmirror->mutex);
+	ret = __dmirror_migrate_map_locked(args, dmirror);
+	mutex_unlock(&dmirror->mutex);
+
+	return ret;
+}
+
 static int dmirror_exclusive(struct dmirror *dmirror,
 			     struct hmm_dmirror_cmd *cmd)
 {
@@ -1377,6 +1398,127 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	return ret;
 }
 
+static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	int ret;
+
+	do {
+		mmap_read_lock(dmirror->notifier.mm);
+
+		/* Fault-in pages for migration */
+		ret = dmirror_range_fault(dmirror, range);
+		/*
+		 * Set this up even on error: hmm_range_fault() may have collected
+		 * part of the range before failing.
+		 */
+		migrate_hmm_range_setup(range);
+		if (ret) {
+			/*
+			 * dst[] entries are empty, so this marks every collected
+			 * migration as failed. finalize then restores the source
+			 * mappings and drops the associated locks/references.
+			 */
+			migrate_vma_pages(migrate);
+			migrate_vma_finalize(migrate);
+			goto unlock;
+		}
+
+		pr_debug("Migrating from sys mem to device mem\n");
+
+		dmirror_migrate_alloc_and_copy(migrate, dmirror);
+		migrate_vma_pages(migrate);
+
+		mutex_lock(&dmirror->mutex);
+		if (mmu_interval_read_retry(&dmirror->notifier,
+					    range->notifier_seq))
+			ret = -EBUSY;
+		else
+			ret = __dmirror_migrate_map_locked(migrate, dmirror);
+		mutex_unlock(&dmirror->mutex);
+
+		migrate_vma_finalize(migrate);
+unlock:
+		mmap_read_unlock(dmirror->notifier.mm);
+	} while (ret == -EBUSY && !time_after(jiffies, timeout));
+
+	return ret;
+}
+
+static int dmirror_fault_and_migrate_to_device(struct dmirror *dmirror,
+					       struct hmm_dmirror_cmd *cmd)
+{
+	unsigned long start, size, end, next;
+	unsigned long src_pfns[PFNS_ARRAY_SIZE] = { 0 };
+	unsigned long dst_pfns[PFNS_ARRAY_SIZE] = { 0 };
+	struct migrate_vma migrate = { 0 };
+	struct hmm_range range = { 0 };
+	struct dmirror_bounce bounce;
+	int ret = 0;
+
+	/* Whole range */
+	start = cmd->addr;
+	size = cmd->npages << PAGE_SHIFT;
+	end = start + size;
+
+	if (!mmget_not_zero(dmirror->notifier.mm)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	migrate.pgmap_owner = dmirror->mdevice;
+	migrate.src = src_pfns;
+	migrate.dst = dst_pfns;
+	migrate.flags = MIGRATE_VMA_SELECT_SYSTEM;
+
+	range.migrate = &migrate;
+	range.hmm_pfns = src_pfns;
+	range.pfn_flags_mask = 0;
+	range.default_flags = HMM_PFN_REQ_FAULT | HMM_PFN_REQ_MIGRATE;
+	range.dev_private_owner = dmirror->mdevice;
+	range.notifier = &dmirror->notifier;
+
+	for (next = start; next < end; next = range.end) {
+		range.start = next;
+		range.end = min(end, next + (PFNS_ARRAY_SIZE << PAGE_SHIFT));
+
+		pr_debug("Fault and migrate range start:%#lx end:%#lx\n",
+			 range.start, range.end);
+
+		ret = do_fault_and_migrate(dmirror, &range);
+		if (ret)
+			goto out_mmput;
+	}
+
+	/*
+	 * Return the migrated data for verification.
+	 * Only for pages in device zone
+	 */
+	ret = dmirror_bounce_init(&bounce, start, size);
+	if (ret)
+		goto out_mmput;
+
+	mutex_lock(&dmirror->mutex);
+	ret = dmirror_do_read(dmirror, start, end, &bounce);
+	mutex_unlock(&dmirror->mutex);
+	if (ret == 0) {
+		ret = copy_to_user(u64_to_user_ptr(cmd->ptr), bounce.ptr, bounce.size);
+		if (ret)
+			ret = -EFAULT;
+	}
+
+	cmd->cpages = bounce.cpages;
+	dmirror_bounce_fini(&bounce);
+
+
+out_mmput:
+	mmput(dmirror->notifier.mm);
+out:
+	return ret;
+}
+
 static void dmirror_mkentry(struct dmirror *dmirror, struct hmm_range *range,
 			    unsigned char *perm, unsigned long entry)
 {
@@ -1643,6 +1785,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
 		ret = dmirror_migrate_to_device(dmirror, &cmd);
 		break;
 
+	case HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV:
+		ret = dmirror_fault_and_migrate_to_device(dmirror, &cmd);
+		break;
+
 	case HMM_DMIRROR_MIGRATE_TO_SYS:
 		ret = dmirror_migrate_to_system(dmirror, &cmd);
 		break;
diff --git a/lib/test_hmm_uapi.h b/lib/test_hmm_uapi.h
index ea9b0ec404fb..67d267a3b999 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -29,16 +29,17 @@ struct hmm_dmirror_cmd {
 };
 
 /* Expose the address space of the calling process through hmm device file */
-#define HMM_DMIRROR_READ		_IOWR('H', 0x00, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_WRITE		_IOWR('H', 0x01, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_MIGRATE_TO_DEV	_IOWR('H', 0x02, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_MIGRATE_TO_SYS	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_SNAPSHOT		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_EXCLUSIVE		_IOWR('H', 0x05, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_CHECK_EXCLUSIVE	_IOWR('H', 0x06, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_RELEASE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_FLAGS		_IOWR('H', 0x08, struct hmm_dmirror_cmd)
-#define HMM_DMIRROR_READ_UNLOCKED	_IOWR('H', 0x09, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ			_IOWR('H', 0x00, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_WRITE			_IOWR('H', 0x01, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT			_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE			_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE		_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE			_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_FLAGS			_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKED		_IOWR('H', 0x09, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV	_IOWR('H', 0x0a, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e2642eca0d02..a2d1b8f494b6 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -334,6 +334,13 @@ static int hmm_migrate_sys_to_dev(int fd,
 	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_TO_DEV, buffer, npages);
 }
 
+static int hmm_migrate_on_fault_sys_to_dev(int fd,
+					   struct hmm_buffer *buffer,
+					   unsigned long npages)
+{
+	return hmm_dmirror_cmd(fd, HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV, buffer, npages);
+}
+
 static int hmm_migrate_dev_to_sys(int fd,
 				   struct hmm_buffer *buffer,
 				   unsigned long npages)
@@ -938,6 +945,53 @@ TEST_F(hmm, migrate)
 	hmm_buffer_free(buffer);
 }
 
+
+/*
+ * Fault and migrate anonymous memory to device private memory.
+ */
+TEST_F(hmm, migrate_on_fault)
+{
+	struct hmm_buffer *buffer;
+	unsigned long npages;
+	unsigned long size;
+	unsigned long i;
+	int *ptr;
+	int ret;
+
+	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
+	ASSERT_NE(npages, 0);
+	size = npages << self->page_shift;
+
+	buffer = malloc(sizeof(*buffer));
+	ASSERT_NE(buffer, NULL);
+
+	buffer->fd = -1;
+	buffer->size = size;
+	buffer->mirror = malloc(size);
+	ASSERT_NE(buffer->mirror, NULL);
+
+	buffer->ptr = mmap(NULL, size,
+			   PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS,
+			   buffer->fd, 0);
+	ASSERT_NE(buffer->ptr, MAP_FAILED);
+
+	/* Initialize buffer in system memory. */
+	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
+		ptr[i] = i;
+
+	/* Fault and migrate memory to device. */
+	ret = hmm_migrate_on_fault_sys_to_dev(self->fd, buffer, npages);
+	ASSERT_EQ(ret, 0);
+	ASSERT_EQ(buffer->cpages, npages);
+
+	/* Check what the device read. */
+	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
+		ASSERT_EQ(ptr[i], i);
+
+	hmm_buffer_free(buffer);
+}
+
 /*
  * Migrate private file memory to device private memory.
  */
-- 
2.55.0


