Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0A0CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 07:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A152D900102; Thu, 14 Aug 2025 03:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C575900088; Thu, 14 Aug 2025 03:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4F0900102; Thu, 14 Aug 2025 03:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 752F7900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 03:24:51 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51E081DD893
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:51 +0000 (UTC)
X-FDA: 83774525982.03.66FE1D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1CF721C0003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:24:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/71iKe/";
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755156289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NFYh+lMLib5d9aEcym56CimWls+PDkMvSuAlLfaPgCY=;
	b=RdXGFQAUg/1XZ+mFYjY/rkZa92TAR/PtTQNu+6l9Yt5mejoAvXouEGEOYoU+GzlLnRbhr9
	UgE47m/WTIutBBpUYhV94rqhi/Z4rvUPe8omJto5L2/ozRZ12ldmo2+LeN2Hbc02VVYa/b
	ntRTm1mstM8lhsuq0mNUt2uYSO6QP1E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="G/71iKe/";
	spf=pass (imf21.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755156289; a=rsa-sha256;
	cv=none;
	b=5yDiJybolkM2gyIHJVEM1p2wEmTt8r0h3JBUxfaLcnxkcyKBymumZm1XMqYMtxzI/BR/do
	cTO9n36k/5fgk2VHjD+E9W8+38SNKwlPEomaPdAGKPXbMey8rOV9SrZF3d9Pl+Te4uC0F1
	zpmT7xfZpMpa6FSUPqJPn3DBRlLAjoE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755156288;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NFYh+lMLib5d9aEcym56CimWls+PDkMvSuAlLfaPgCY=;
	b=G/71iKe//NQ3+K4tVSu1BqSayZirvxGCh9Md69roWsqEC3bS/uBIdbx+yfVhei0eD8WBgH
	e7sYSkw5xNFx4UIvNeq2wASzCjtPeySQRjPknxdV+arBoOPVPLDbmR43Eub400jyYhw8Dq
	WdtAAWqnVoHXYVhvT3bB7U2wYbdS32s=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-524-UiFUlsKGMiym6clb8v93TA-1; Thu, 14 Aug 2025 03:24:47 -0400
X-MC-Unique: UiFUlsKGMiym6clb8v93TA-1
X-Mimecast-MFC-AGG-ID: UiFUlsKGMiym6clb8v93TA_1755156286
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55ce525d09bso284802e87.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:24:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755156285; x=1755761085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NFYh+lMLib5d9aEcym56CimWls+PDkMvSuAlLfaPgCY=;
        b=btjsf4MW6bBJjT7Hif/St2iBy8QQwqwfypfVA7V/QbTaHjalQFvIs74ng+wrToDiwl
         wDtad/rVm7q1gu+1JxKQhVnoCxw9kQ7SkaNDhLAEHzTSQyl3FQQBWtvMFcvWUxhVbbdA
         zA2wXkChBRRR+AK9bC6FgBsvDTkT5avsMmz25hZptVNClDETAHPlElRC7N+wDqaj5FpS
         H1wHUuWwioDtyMNspOET53T7A673nNi8FcR+iPlB1i0qaKQoDpAp8kRMYkWn/aBqtb89
         eM4G1+i4ZvFv+YSpytINz8ibnZ5h6oBD+MExSU0tpzhqF9RUhnnjFdZ1UHz0b89sCpsU
         5Nfg==
X-Gm-Message-State: AOJu0YzE3ugEbzlGVrGMhUeH+9LWc1Jn/6iDmVkBzLdzz3sHT5WQzxi2
	llIialpbfAPIcNslSGy35yMO1mpj9YVNt5KvkDVIES8IrPCWLUSyTbMyiWmVIfmjc/LbI/QFTfK
	CM/QLIN09DeHLRNyMm+8TfyIQsNOTRJmKx0YDHCIY6HMhKzAnrUGSlZQ7bbX1ZP6VksHUdwtXE/
	yrJqTmEkvxqPm6/E3sdFCS2GMriwODnalqyxo=
X-Gm-Gg: ASbGncultsnW9eOOMfMM4rLPdqsdTn6npp6nijOy1Z4rFT+u2Y36mpTXlhcan+eTpV0
	eSCH/qq564Ej4/z00MiYKBz6VxlLWba/gP+8T+YJXg54NekSScGMAYbvgZw0RvC6sRc0UUwUWkQ
	GrryUZSl+vkGHnWgPJTr1yZw7XLuPRyhtlN9276P1DDz6994DezonnRvs3E/XCnoWH66KZKp/cQ
	/1kzOieoQEjvAfDqhbNNPvwOThB3xBOGjM7KvdPSEPQgwtFIJ/RUgoTFNWN0R13vljNZbFl/ihF
	HRp18PZ5ty38bXYVEEMXVLnms3i1qTCI6+wSTSRshGYZG2gjN1/lKGc=
X-Received: by 2002:a05:6512:3e2a:b0:55b:8767:1b0d with SMTP id 2adb3069b0e04-55ce632aebfmr456626e87.39.1755156284629;
        Thu, 14 Aug 2025 00:24:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFd7JLE7pUvGqP17rdjWY/nMLf4BrFbhcfKO4RBEc6kzKWQaFTl4wfpAS+y5SdrFE3jgmSvXA==
X-Received: by 2002:a05:6512:3e2a:b0:55b:8767:1b0d with SMTP id 2adb3069b0e04-55ce632aebfmr456609e87.39.1755156284074;
        Thu, 14 Aug 2025 00:24:44 -0700 (PDT)
Received: from fedora (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b887f72f4sm5620240e87.0.2025.08.14.00.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 00:24:43 -0700 (PDT)
From: =?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: [RFC PATCH 4/4] mm: add new testcase for the migrate on fault case
Date: Thu, 14 Aug 2025 10:19:29 +0300
Message-ID: <20250814072045.3637192-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250814072045.3637192-1-mpenttil@redhat.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Pi96MVwT5xJvE53RGTRUWLUCoCzRoI24xRV6dkwKmjI_1755156286
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1CF721C0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 93tycm6xzdtqqq9ywa4fc3xcggyx7mex
X-HE-Tag: 1755156288-978895
X-HE-Meta: U2FsdGVkX18qg6jtVF33HTurii2MCFVrkpfl2VTs8pefbrdblvP3dkjO9LhhFs8g4zWWjUfvtttVG5Arz3h7fn38upX7jGWiCaWHmVlpCac0ZGCoWkuOaFr97qYEJtrmFOWYHUtLFKxf24NH8wTwme/zsz4fQ+NQgGqVI0sOKJ3nUlZkhMbLu3kydflC/9VzkH2kQ9GOmqrGgPKNDWlcIHkpUNqaigx4C2u17LY/DxVBrk9mY2PqIlOZgF9DW9MYUjUQ1/3/gHeuTUQFuEDtLOa7lO/tsclE5xj0ZkvjkZdbp9YAVz7zQHbdWS7O8z9OEv8MItu79RQXn+J+xP8CZ3AbiYE7izBloEfa8d9GlKCnhxPwFP83Y6pZZTT8gkr0mG00KigS1MYS3S/kuXTLul0zgdMGD3McGo1sAA+WmZX8z/wn4YEo7hSodYNBo0UINa6ON6OfI0ZrZiZcNJCjxNIzraf+885amYuiOsNmWSUNVRy9J7SoSn2E2lLakHLevGBCLtJ2JlDx+8yhxE+jnqJeacWTv0zC7OalcvDEx+lmnyMoFBqoxTFO0S3rC1feZsHxCCjrV5p9uUo5F9tErBZVqMqTIY5KDvdG0wsVrfT2U2Q4esJOnf8RvjX1MMkk1+A6/mDID1hnqvsRVYuEdbIm133PjbuYUmtPKe8bDJvWNTGPTXaxCZwOAu+iXlRuYwzjio/bqSRvKi3Q7akKG427wqxfs62AVz+1hBXLTbN4S130fbLCgy8+fyvRaqQVUHRS3u0BTWBbvKgkFHGOPhKggz6QBW2vV0xcNLRq1OabVxK698DVtvVOFoEbRaAweUxY1aJ71DLaNLVg4yIvHDsbiDypE+P+wkGD8Jq95/Y0d6QaNw88mavrGEuk1RoJIIZRtv22eVU7T2IH8q8jjmMIhnWVEtWRF783cgEKkBedsv8c+q5TIDWfmzhwnGwAWNZGc88T7gK9u+GTZHN
 4kDH8MX1
 hkZZ0Wth+r1CRRMHKd0+4lY/AiLJRl6/AmbHDOF5kGJA5mq4cyoSPwx9tV4ocxxDru19YVbL/bTML7iW05+GjbcbfUolRHvBbgzm9jQ+phO09TRv19+B1pDdYQ6BCWIrN7h/wswYsIhNKuqvmg6S+Ph4L7570KsUV9/RqRFKVBW7BZ1XjA0b5/GcXcmHiDv/tOfrg/XAhGLIEyPR4FEFASoi1DOsy/pYEZQ6KdAHY8kwFPRPOET6M69vC5wIHXYuXJLH4o9+dMPfJgk14eBhYwnA2MFCaEFScSnpRBp7zJqGvBs+wzabVtf5eJ7DbyvdYtAeDv2dy/0QHwlJuiBbye7oFqdA0BqO7RKUAlxo9sg/+pnDacDMLaGNgDEu3lQ7UD8l2hI2eiQNPZy2lKRfKuN8DhSYK/Ux7WnFgwMixCHAXKUwxHQe9UxdZDTPPOIV8Ynk53Xs6IBWSh3z+UEMNIyz/69VL+g1OHIN31Mdoe2/l/CwekhlQfilD4ByZhT1Tv0wn7P55nwXkRpjLZ9TZPz4xag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>

Signed-off-by: Marco Pagani <marpagan@redhat.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 lib/test_hmm.c                         | 100 ++++++++++++++++++++++++-
 lib/test_hmm_uapi.h                    |  17 +++--
 tools/testing/selftests/mm/hmm-tests.c |  53 +++++++++++++
 3 files changed, 161 insertions(+), 9 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index cd5c139213be..e69a5c87e414 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -143,7 +144,7 @@ static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
 		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE) ? true : false;
 }
 
-static enum migrate_vma_direction
+static enum migrate_vma_info
 dmirror_select_device(struct dmirror *dmirror)
 {
 	return (dmirror->mdevice->zone_device_type ==
@@ -1016,6 +1017,99 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
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
+	 ***/
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
@@ -1313,6 +1407,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index 8c818a2cf4f6..4266f0a12201 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -29,14 +29,15 @@ struct hmm_dmirror_cmd {
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
+#define HMM_DMIRROR_READ			_IOWR('H', 0x00, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_WRITE			_IOWR('H', 0x01, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV	_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS		_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT			_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE			_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE		_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE			_IOWR('H', 0x08, struct hmm_dmirror_cmd)
 
 /*
  * Values returned in hmm_dmirror_cmd.ptr for HMM_DMIRROR_SNAPSHOT.
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 141bf63cbe05..059512f62d29 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -272,6 +272,13 @@ static int hmm_migrate_sys_to_dev(int fd,
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
@@ -998,6 +1005,52 @@ TEST_F(hmm, migrate)
 	hmm_buffer_free(buffer);
 }
 
+/*
+ * Fault an migrate anonymous memory to device private memory.
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


