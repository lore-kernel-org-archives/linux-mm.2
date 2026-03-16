Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337CCF3028C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 06:24:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082236B00B5; Mon, 16 Mar 2026 02:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CD66B00B7; Mon, 16 Mar 2026 02:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DB06B00B8; Mon, 16 Mar 2026 02:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2ED46B00B5
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 02:24:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80F9EBDCEE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:44 +0000 (UTC)
X-FDA: 84550937688.24.845F5D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5D212180009
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:24:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=etYrX6lC;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773642282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
	b=GwSb5UFXJr1IWng0WaqyI004YnfzGBlyh7ZYkZDmqaIe2cnFohLm1b89P00UrHWsEhJQr9
	dy+Hk9TO1VP6ykeu61X0gV96qaqLE1Due6Xx7y/q9+/qTWjlJD89wIlkK/QhHMekmegbSx
	RBHVTxBagFWi5kq/EQmH8fNArDJ3CYY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=etYrX6lC;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773642282; a=rsa-sha256;
	cv=none;
	b=7jlIeiAFxq6gCZYK3wHUDncBoyXhxStY7z5KZWNGVvFQ9fJ/0PCGjU6182ftf6LrQ7m9Ul
	mDofrex3sLDh/zlyiuPvJRLaFeCFJna8ONfFAq+EhyAxD9IPqBZAhcPE67HZmxBPvvbLff
	r/9MoFGsakvr579YlSmo1jaBH+lQ9/8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773642281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
	b=etYrX6lCPcLwS0erlwjIty+OCNiNL8ZZQ2aUQRraYMUKjbinN/V09GvPAClHlwQcqWsTc/
	HOnFK6WhWQrRBCxkDYzcO1QRaViMnpXRWApdJt0UcQKAZjBA8a2PYqmeF0GdsArz384I2h
	7gT3RQIelv/GUla14/mIrVJOP9mYyIA=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-EHRsvBriNHqaz4hTi3VwYQ-1; Mon, 16 Mar 2026 02:24:40 -0400
X-MC-Unique: EHRsvBriNHqaz4hTi3VwYQ-1
X-Mimecast-MFC-AGG-ID: EHRsvBriNHqaz4hTi3VwYQ_1773642279
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a14d43e5a0so4299633e87.0
        for <linux-mm@kvack.org>; Sun, 15 Mar 2026 23:24:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773642278; x=1774247078;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
        b=ZriBLIPvHniTh5RT/LHOJE4Q4vN/qF9XLqVihqiPwcvykITDD1gbFiI21Xv+VEGAHy
         HlPxW5MV7QkmcURTkud5EMlUHr6T3Y22FAoC+JGW9+fc0UXYeHH8kvKoceSTK9rbI8M3
         lXw2HTN/YoARk+wbhkwP2Wy7lHYYgljo/kIqHXMqPlnI/BqmkYrk0DvoscATESSEPxEo
         f1vtbL2mVuuQ9d+Uv34rJQ9/+oiNEFxQigXRXsy+XFOwbXCOl2Hofc/RKBTk0uGgpVlH
         BepXuYquaqB0y8H+mJvXpNStJV5g6LO9X7mFYcnFGDStrMEjyDFHJ8hBCHTaOD9tf26d
         mlFQ==
X-Gm-Message-State: AOJu0YxpyQ7tpYtP4vwC+vd0JqM6vPynDLyqYMA+cJUyj+m0+tRpds4V
	Ae9l5LTv2oSsakIeSygsq2c0OMcHkQHzbsxyo9TVo98Rh6txNsw4JmD+9xOgPC0l6HH6vrqqkwi
	lUKVWnWlAFiVPkfbsyWtNhRS41FBlVwN5uUUHDZF0oonK3aOPLy+QfGyA/iACu1FJzBpajAfILB
	1v2mTa2UXTkikCtyVsXBh8QkFeuDHypCWYGgCdWQ==
X-Gm-Gg: ATEYQzwvyhSCbj6kiZXbDwbAD5n1f3wrUWSRYrC/YI4d9mPtH1olDWrhDgIhO+QPRSH
	kQ/fwcthqYraiOtdJ6upqpK19OK/NNM2OdCA9B84QoF6f6Ntr289qRD1rqnOzAQWE3g64/t0wag
	Tonrs9MDxmujos8MxxVqiD8FG5IAiySGLOOGo4AnBJt5xsl9oAw2UcYCbaopGZM8CqfuQ+g48fW
	08bYU7vAOAEFBq8axBlcAE8DrWPL+y/5g8RgQO+UGlbK8b2wBsLV7D37can9LnXdKbZsa1pDIHo
	PGhRY4S4MrGbZsZTK0+QW+67HEY1EpOUtfogv7v0vfBPFBLwQWzHFptohVx8VKKNvwGUK0AkYTZ
	ElAYskYHlkE1l2H+HoYeIOFTBUuPt6dORa8uB
X-Received: by 2002:ac2:43a3:0:b0:5a1:37ab:312b with SMTP id 2adb3069b0e04-5a16270fe48mr2994965e87.15.1773642278089;
        Sun, 15 Mar 2026 23:24:38 -0700 (PDT)
X-Received: by 2002:ac2:43a3:0:b0:5a1:37ab:312b with SMTP id 2adb3069b0e04-5a16270fe48mr2994943e87.15.1773642277527;
        Sun, 15 Mar 2026 23:24:37 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a15602e692sm3263397e87.30.2026.03.15.23.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2026 23:24:36 -0700 (PDT)
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
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v6 5/6] mm: add new testcase for the migrate on fault case
Date: Mon, 16 Mar 2026 08:24:06 +0200
Message-ID: <20260316062407.3354636-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260316062407.3354636-1-mpenttil@redhat.com>
References: <20260316062407.3354636-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0VIrUXR38H_RCW1IRxUH0j-zsEdWqSqNIyjXbiRqAn4_1773642279
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D212180009
X-Stat-Signature: a8txwxmj9yysbf8fph3txo8dsa6kt1g8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773642282-364616
X-HE-Meta: U2FsdGVkX1/FVqb7kY8qL/0aGDQDhcKeD2UZDYv3k2A/jMKN96Q9Aft8uZG6Fs2UIUf1sXqZyPdoFgSnO3+4DpOwtUy+cWYmQaRswWE3EHNr/onrpyQ69A1xq0KrMxW2tnIuHaFI15VCFQ1JjrGrBHYDpysn4zhhd5tczdcko3nmqaLHQKanA3ojNbWZKsbuT28W2s7KZta7nPoE5wLIFHSuHiE3r6xmMyYkwUYLxcMNl6qAiYjja2H6Tg51ui+0+LqP2CJusgs221gXy+183mz20CYsRj5RI221OhwQNCZ3SfAovs8GkzFkOThQEdgfz9PBofE4n11fGlY7wrFnJG9EQq6XRq0pTAkXbqaUsKYSU5u67wVTpAjIUQL9yt5UCMr0TQoHS6+IB1n2JX23yWptQu57UqoLLLW9fDpD6bh8Ov2v78Lk51Fwd5feRgmbgU3g0/BUMKTY2Oq3NuKrO1CE5AzqkXYzm03JGi4FfG2N800A0eW8rnTTiCFpOMo5DLMhZ7EeGbSSKEWY2Le9yMj1VMrTgZt2clFct4bCEfaxP5GhPf4ZfEBhe75eTgFMw1SHSsqkkGf3kEM16zjnTt5YDZ9xrxRL+k3Qp7JcQbYM5VSH0PhNa4GSAa0qsCPKibdt51v3CCTW+CBiYIlagQBShUls8o4zcWATAHJBADgABx9gFLHs640xBFju9KisFNpbqSf2RO9jtyVd17z5GT6kyFEZ1l5xbXVpQhB4spN2gmnsB1dYC0Bh1F0ZzlxfcX5q7AOVDF/4kMuJOagPGfcWN7thejnjTgw8DZSZJSbfziG7JD6nHZT1b/OcmLzUn8mbnUjZL348Wi9/YofqqHGmmX5taNecLYUzIIscYP5AH0/Z+z4TzXvlJ7Vyb8sRox9LVlXPBQYIBnqliPuXqWjxPZ2cNW4pwHnV2yBnHWALdcFPIXGlPWiAChjFvrMpFIlqP+xErDOBG04Oz8C
 h7FZRvGn
 nCTJWbQuvx0iwby0WScRUfRaHyFiTD9JESC64Vgjn36qfYfNjGU+rHX2DGk8dTUntDLpIQ9YhnhBC4vaXqffGokOTeTvq0tQimGGf/C3IoH3ur+Aamy7l1e5iclRqrak6bcuzzHjyn03YAwSBkOhskVaG6w6pp5x0VjQ+c4iYNqqhnvYF7B6NY8lRnyBzTmwMQz+WMPodYrDAIpKlZORV5Y4s5i5BG6UuKM/Vh/X1RNOYi+E8u6Fy83JzGRyQmw9ODqf1McNsxbbLnBsDalmleHTQ62XsAri0lzAcVsP/DW50XomcfN5yO6BSDW3MwLNqH8btbSy80iE+XpGMxgoVj1tjjz1cqHtycZrCH8EEEVZh5UP44En2iErrVCH/cOSjBmLdzm8Qn01cD+F9H2WuI8zy68qTRuCO8mNe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

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
 lib/test_hmm.c                         | 99 ++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    | 19 ++---
 tools/testing/selftests/mm/hmm-tests.c | 54 ++++++++++++++
 3 files changed, 163 insertions(+), 9 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 01aa0b60df2f..5ddcec056dfb 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -1196,6 +1197,100 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	return ret;
 }
 
+static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+	int ret;
+
+	mmap_read_lock(dmirror->notifier.mm);
+
+	/* Fault-in pages for migration and update device page table */
+	ret = dmirror_range_fault(dmirror, range);
+
+	pr_debug("Migrating from sys mem to device mem\n");
+	migrate_hmm_range_setup(range);
+
+	dmirror_migrate_alloc_and_copy(migrate, dmirror);
+	migrate_vma_pages(migrate);
+	dmirror_migrate_finalize_and_map(migrate, dmirror);
+	migrate_vma_finalize(migrate);
+
+	mmap_read_unlock(dmirror->notifier.mm);
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
@@ -1512,6 +1607,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index f94c6d457338..0b6e7a419e36 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -29,15 +29,16 @@ struct hmm_dmirror_cmd {
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
+#define HMM_DMIRROR_READ			_IOWR('H', 0x00, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_WRITE			_IOWR('H', 0x01, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT			_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE			_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE			_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_FLAGS			_IOWR('H', 0x09, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e8328c89d855..c75616875c9e 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -277,6 +277,13 @@ static int hmm_migrate_sys_to_dev(int fd,
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
@@ -1034,6 +1041,53 @@ TEST_F(hmm, migrate)
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
  * Migrate anonymous memory to device private memory and fault some of it back
  * to system memory, then try migrating the resulting mix of system and device
-- 
2.50.0


