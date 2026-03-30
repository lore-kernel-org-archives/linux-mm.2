Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F86FF4941
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 04:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00ABC6B009B; Mon, 30 Mar 2026 00:30:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F20526B009D; Mon, 30 Mar 2026 00:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E359C6B009E; Mon, 30 Mar 2026 00:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46506B009B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:30:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 734A5E0AEA
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:57 +0000 (UTC)
X-FDA: 84601454154.16.A54C784
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6719B40007
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:30:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=apr2692X;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774845055; a=rsa-sha256;
	cv=none;
	b=nzslfDmdP9J5ez4wmbss2/WGHwXyB03Y1PKF8A1C6a2w2JdMFm/YlkoBAnLWxIPTDxvUPk
	vqG4qRSyCiG6+fCURScrKRL1QcejBIarCN857dmz6fTAdhsiz5S1DotP6sO+/GTZpj8IoM
	/zT6V+siwh1hVwb7yr+Pjz4dqnDpyvE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774845055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
	b=vaJDuKYiJydlJE60biHVXfPpx6N2C6eXUroBSHAQMXZHQ8xTZwuo25HKtBMUfYkd5UMShS
	HKktQUAxwZAVZtjQsIHIcv9DNDWj4PPQSBtsoRPozi3pwBzvGTcZFLraMQVzg+SfyqRsO5
	GIVxPSXx6RJ0RZgtggCEHH/E/QRTY+I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=apr2692X;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774845054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
	b=apr2692Xb8Qs42UApzVPwCCwLE6IgvMEJHkM/nOSpaEMjPyyTo9Zfrps+jimd9HR+1oYLy
	3JN25M7IPnbIgbegDsqhNeTm25xcaeKlmYgnA0UaaPHK+OOmodpYFzWovmh2mXctWiVzkY
	H/a26LUThPWO259C4JdRy+2Emniokjs=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-JJgGObK_PneGJ7XJQ1cg8Q-1; Mon, 30 Mar 2026 00:30:53 -0400
X-MC-Unique: JJgGObK_PneGJ7XJQ1cg8Q-1
X-Mimecast-MFC-AGG-ID: JJgGObK_PneGJ7XJQ1cg8Q_1774845052
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38a4c10df12so14945211fa.2
        for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774845051; x=1775449851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
        b=QJmzy9uA/8H4ptu64t5C1aRnS8LnajpCMQ2Y22hpX+AvLgViibpJE33a7o6zxmGSXe
         E55FvSD1mDC1UUO+/KfBVPgAZCpIAxK5NUPCci8dR8bRF1Gk9dP16/o9/pjcxQuYPjwx
         38Paolz2jPgBJZTPUvp9ktQ/7QBMKVOXRtj9mZ6BFdT71EKPuBC8oNtWJNerJ53V4Ytl
         moUU5/OOUlQXoa1UZziKtnK2bpKjGwhFB4OgvDG01a8SQQWQrP14movexMhsvLYjouXZ
         uODl8PPt4/bGW7+pezFFNtgUWi0JXK1mtA2JU+VFAWKAeSPFCqEnAaCVQcdCvzLkk5Ly
         xqpQ==
X-Gm-Message-State: AOJu0YzOKv2gid2HA05zv9MZ0FcugJlx9yMRLanNd2YTO3LeLN4uzwIV
	m3rwD9fhZxF/GF+nAsugHHel8Gy2PKE0nFELJysuk8WT6IFZVsnuXigl5wEANHjNfRAMOePJpct
	knFl1foMVJYz7iue+g37YgmZI/mMflezo+GVYN9VCFOEPcoKOcmEViQS/O5a+N8JCXgjfuXNcjF
	e9W5hgQoaE8om2ayutatkFRofO4f1f06sUnt/4fg==
X-Gm-Gg: ATEYQzyMlsO+iVPlbK8cKwfBSn7aersumzqVh8m50PmJEeCuKwaE27AH36u8WE15C8e
	xzSbTH7abzfWbvV4ZkQLqSENdwqst9DLFQ61d2Y00y8Yn86pIAWEwqQrLLQPRzjpGuJ60n3fjJ/
	Kgo8ASEd4UPKpjZn9fviOoHlL9KaBGKiSL3VrYqkYGiBQHTMTMZ5ofW43Sw9IA5LiLTLYKSxjZl
	rmQOOERrfWvRIcsmUuiUVvAinQFFW2dn5ERMXc57qiK5d7EJKTEQUC7ThgkzJg8zwCCmcpeyVEg
	4xEb3Ya6cBPZqtTUx+oTNdAN7L06d/nUZ4RWymwpU6o4OxnF6+wIFc4ftCIJmNQ9JvkQweBEOZ2
	03brbvXFtZPiFqXeov8pZGaJNOpoctxTRhSiI
X-Received: by 2002:a05:651c:f07:b0:38b:d4a7:fee5 with SMTP id 38308e7fff4ca-38c73121caamr34183431fa.11.1774845051240;
        Sun, 29 Mar 2026 21:30:51 -0700 (PDT)
X-Received: by 2002:a05:651c:f07:b0:38b:d4a7:fee5 with SMTP id 38308e7fff4ca-38c73121caamr34183261fa.11.1774845050231;
        Sun, 29 Mar 2026 21:30:50 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c83729522sm12470671fa.14.2026.03.29.21.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2026 21:30:49 -0700 (PDT)
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
Subject: [PATCH v7 5/6] mm: add new testcase for the migrate on fault case
Date: Mon, 30 Mar 2026 07:30:16 +0300
Message-ID: <20260330043017.251808-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330043017.251808-1-mpenttil@redhat.com>
References: <20260330043017.251808-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KDWeE1n0hGBQ6nPHK6zOXcu2roHOMjDV9sZS8f2bCos_1774845052
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6719B40007
X-Stat-Signature: cf3xcp6dx9zbpuupm5knhuwz9gmqjrzn
X-HE-Tag: 1774845055-270300
X-HE-Meta: U2FsdGVkX1+3siTYlCT+zhjpG/KssEvdHgsVru0AQhN9OOFwZ83IdJ0arwNdXJddJ7oGV0NTSVa86/wv6dxhfHEl0lZXJptW0FdFQv96Ve5l7Skbcl9Q5WBnBvNUJk79dnBhnt595kAnqcnuhi2B9mVPrZQib4Ys+K0aLqvTZ6LQwP+ODyvU2lXDgEKi3kCR27hjREwz4Tcf7yMBoRVkQIxifCAGo731Q64bbhKx8QmZOjIHg30hAWKWcK9qOAdffmkk11r4Jt4TjZ58Km8iM2g89ZK4aznSDueBMr49ZM7dEwrsnGhsnEzhl/ib661/iz09r1ewSbi98lUqm1M4aglDj7z/J3LfoqyFh02XhDkw3EbXqFfbKOfBDHQwqaLXyhEwuQJ25OYcn11aNlfUcvpVUyLVoJPt8fqd8hBe1mvaNeBgIq3bfWj2DW7/XeNC4VhKQIkf0gqJ97zcfF2gN2722p5HVXDw6ZWy5NWj/2u66qYhaF6o+IVpkGElhxWoi+hujJAVy7iDpDC8ihsUwIc4Gy2W09awuOiRGNjt4bZxvcH36k09B+CKDeCE558qjHnqlHwLRIVK4M+Mm0HWJbVlThLizMiP8DgsnlXKr+BZUOmlz+0NuwIGNYcBIHXY0EdmOh2lfcoTjgKVtXbVCmgwj797L/Sqw257IfIHjCyjnR4WZ27B2RB8fcmC/XKc7rCTCuNyMhLb0/LLGb+qIl7R6zYSdu9sSO+EvuIp4yGp7oX+oJKE2xqvuXIjmym1t9URbXtgqz3ugerEhduxw1CkD1RkMedwObN8Iqi0HyPndYs57Bm4HLQXZUlQltYi6Dsk+vXv4y6IDwH4092qqzBLKU7cN5Bpwf+fV6VH1aRtLBqStWKSG0/gXjbAD+w9bd3roviJ99PRQ4r7MFGGo3WBii533xe5c7+wJjAeAEBjPOrdrbQcYe6jdv/Bh5GI7LN1AH3v8wFrB0CxBRQ
 AoM/JCx0
 CCR2V
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


