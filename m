Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB5D7CCF2EA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB03B6B018E; Mon, 19 Jan 2026 06:28:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59236B0190; Mon, 19 Jan 2026 06:28:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861E56B0191; Mon, 19 Jan 2026 06:28:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5FEDE6B018E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:28:05 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AD631606F6
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:05 +0000 (UTC)
X-FDA: 84348489330.22.F0241D5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1169C0002
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:28:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bqSs5oGE;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768822083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
	b=x8OGKh2RnXMQ3HfS9o1aVmxWuSWTiLRbBhbJmJoUeDyv7yPTpgXd8Kj71a7sgagRrI1omN
	nQSScRGELuCAmk5Q1dYFYj5XwVred571I/j5sOM1nc/WRYYjenOU9f9rRu5AmjO9b8SfXg
	1HfCYGWoX0X3COETEFFylAFsYSnInlc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bqSs5oGE;
	spf=pass (imf10.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768822083; a=rsa-sha256;
	cv=none;
	b=X7Q48YiBPnTriZrW6uvudksrambyS6KSAAV6HxbsNOnkc06IJfgAM6dlhbISGg9BdvPd6e
	VtbkwJORAOWONt3qW4oxWGzcsnx8E+peH0z2dEpe6th/lFjprS5uSkF8/9WerppnDsyWLx
	Dbn9oo8RcvpmzKp0VydEjNx776VjK74=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768822082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
	b=bqSs5oGEeU7lWzyrtwVi2zM8+8ydca1ttLfZx0O3YYPllAzXCCarDN7iIFKsgZXiZzK3l+
	ssLz+yg6/6BaZ0wejDe1q7+S0mcW5lVj5vu3pX0DM8gOUh8ttD4Ib6Yt0rSw7Cd7a3pyk3
	TY+ChF9OQ67pyyadNHeOcATRsfYBagk=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-SaTMvnAcP36yyhuXdEVvig-1; Mon, 19 Jan 2026 06:28:01 -0500
X-MC-Unique: SaTMvnAcP36yyhuXdEVvig-1
X-Mimecast-MFC-AGG-ID: SaTMvnAcP36yyhuXdEVvig_1768822080
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3831ba7fae0so32147921fa.1
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768822079; x=1769426879;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
        b=Z6JyC/RXCgtu0puV0KAIctgFCGT8or8Vip1fE9DL93+eCcId/jsiYRNLwII8Iinde7
         oQuNw8zt2Zo3A6ODQbKSVRBjU9aj/5SUXi+fLTvj/z1PKBRlhD5HBtgnQO6faNfxLZLg
         uu6821rk+xyn+7gMtJS8wb7miHijECNLBPkfULhig55bo/dFPVx25P5cWgvC0V82V0H+
         RtLtY73pTxan3Yft+gkw2pGF9CjWN7yhcOUkm7XiHXAQIneCU7ZZK569iRVlhARauOCS
         OFOFn+rpgjoZyJ9+9cmxB1VlbbcsTTey+otBwmkMFvCK9knHae3jmjjbyEUYSOwcYL1b
         /m0w==
X-Gm-Message-State: AOJu0YzTKUR8ocXkxeZy3ARkw+M8MRwLH9WCTOAXgfIpuKzcLvRNskd9
	D5ZJZBD5a2baS5WypSdsR7y9O2qlbQ4p1Dbx6ZZwereGUnwvN/h2ibEitoDkHi9D7mzWpzSNLCP
	rUD8UMn0lK1lW7wC1qc+vp5cgw1LtpDRP0BT867QwtOIEJMKBG4TaMOV7fdj24CWDdBinlTdnIB
	HMeusKS9z0R+BjoTpj8bcqoSTnO9f9ubuNdkI=
X-Gm-Gg: AY/fxX6vDIYzN9EsyJJhGCgIZvdbng03astJsXaPC//31eWlasSRefbZ/gIeo6zGIM+
	oWb0idUJBzSni9ZL4btOSVS27jd3QARqZmTxgnY+YqvRiZtimPjUnc2Umq7VJjdBYNwnuoi6iCf
	swRNgNDW7J0sd0W0lAzybwHnOcCe0H6db88/brdPPIjJYA2xSRlKvUoF4bpSJWh0pB5ftA2b6lr
	PHimcXM01FT1u1t8i3dbh+TaDcKh39mwBmuExQ5QjfhfUmdu3SUPugDk1x6Ffh0wXScE3d565i6
	D5mARNW9mdy3n4QJ5SUGaIwH+jIiwTYYEbpzGYvJG/QGO6RHshYdo6ov5ma0c4nfidqxxL3ILYi
	XnqfTRmklLAbYKBybQ6nvtckw
X-Received: by 2002:a05:6512:ad0:b0:59b:7aa3:9d07 with SMTP id 2adb3069b0e04-59ba719c7b3mr5936534e87.22.1768822079277;
        Mon, 19 Jan 2026 03:27:59 -0800 (PST)
X-Received: by 2002:a05:6512:ad0:b0:59b:7aa3:9d07 with SMTP id 2adb3069b0e04-59ba719c7b3mr5936506e87.22.1768822078707;
        Mon, 19 Jan 2026 03:27:58 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38384f8a1efsm31226411fa.39.2026.01.19.03.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 03:27:58 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v2 2/3] mm: add new testcase for the migrate on fault case
Date: Mon, 19 Jan 2026 13:25:01 +0200
Message-ID: <20260119112502.645059-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260119112502.645059-1-mpenttil@redhat.com>
References: <20260119112502.645059-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0lwQUfpjZDQd-KPvcs__YsF_E8P6TcfoMAmjjiYmEpk_1768822080
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F1169C0002
X-Stat-Signature: ctw97jn9jcikofnh3jr8n83izhafwg6c
X-HE-Tag: 1768822082-876694
X-HE-Meta: U2FsdGVkX193JUHZBk+xz8GnG9oy7Adrr2WUqc9SRDO4iZTagLW4dr0JU1PHHGKP9oWqxDojy3lj5P3M+5To+SBlfQfjC23zJ1G0u6gLMBrm/eeIjz58ujXWa8G8NPRmmRbuvuQLKV+Sk833EnKUVLNVNfBxRRLle2PYX6FtItSXShqGLNtrLEcqydS9/0M2OKi/dZGD9ynJ7OtEcncniPITqbVvo0/Oy7SPlgvAL0IygrRVtUZzg4+REUMJ6+nweV5wUDI+D3faBsIbdb88qmPBYr6U+1pjB+d0XAobTXBBfdxor9OgoFNwbmLYAFMdIver93FtstGAEhTYLpLx4UMZnQO6eEdg8+KLKHvdZA676qeYnC7zQVCaxsOpffvH/6JHPy9/NY3b2CCgafQW7aWdWL55BU0sxoWNrOehYGhUREeqMd0HDayOVQDEXObNSmCVskr3xzM3RSrvOzhzS80W7jC2gOd8uW6OO8LmbIWHo7jUEbSQmhPQ9G8LYkCUhLtkmH2R4mCIufFco+GgAxxhF3D2VGNnd0x/JTTo+jTsaUNLKpo7rsRF72/2q0cNm8febuvbmYX1ZUVAO7CrGiy9/PuagEQY6AX+Vn/svY+lF5ai7bm8AzuYhmfsH0Kd4XL4tWeMBvSbP18H+AMy9prryFO7R8YEXe+OJ4UhZzqLhfrjENJCMpVHizHF2OPYZfz7d6glTt/jdC0cldQMYwWX/dVToJHf7oojgEaO0j6XVcF3V6Ncr1eO7Lg8TpLlaL9g0KFaXZZG+39tTfjBuu/4GDi+lVCfzqcpqotl7nHWY13MXInk6MB0OxOM7LoqiyPm8WAvhtJlJS/hZReCP4y6AK43bhyyVxiuRrcXuG/FSjyFod6py4HinQlKiqaRh3GWSVYqFM2SIYA2F2nwOQsZspjRjvNsTxNtUX/UrDf6pJuiPRZnXJO6rIaIJeR5HsFdiYRbyPpGzFftmOi
 LLtw9xUP
 FP/jpyfrumK2lUuMhb/8IroZi/0r0QgdKAmvmib7Avpfq9FojQ5xaYzfsG7xTmvWFHiEiuF4FYdEyPdySB+yJY++lGkOF51TkitFRbxlySCia844zoilg9ImZ3Hrmjh3PZ2FnYZ4/GnESmwqScEAeNjQv4VW1S7HDxYj6Sj5PWX+a+ZKP7Ai6cNFY/yF//ZCgNV5PcbHoFJ4Ckd7bKkWAqw0KizH83q+WChZO3/PCmZx1Wm+rofMxP5DygU1mrF/CdQLn200pmffNh7wIPcznl9qzxgzpc+XUlrx7of511rPCgSrnatED92A3tAFLETvHU3bUs/VyDsrO7cp+zZPv88ePcU0EVTfX+7o7ZI0R/r0lojaOM8oAofApR//3JgcxfAygTydDeuPVlQs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Cc: David Hildenbrand <david@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 lib/test_hmm.c                         | 100 ++++++++++++++++++++++++-
 lib/test_hmm_uapi.h                    |  19 ++---
 tools/testing/selftests/mm/hmm-tests.c |  54 +++++++++++++
 3 files changed, 163 insertions(+), 10 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 8af169d3873a..b82517cfd616 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -145,7 +146,7 @@ static bool dmirror_is_private_zone(struct dmirror_device *mdevice)
 		HMM_DMIRROR_MEMORY_DEVICE_PRIVATE);
 }
 
-static enum migrate_vma_direction
+static enum migrate_vma_info
 dmirror_select_device(struct dmirror *dmirror)
 {
 	return (dmirror->mdevice->zone_device_type ==
@@ -1194,6 +1195,99 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
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
@@ -1510,6 +1604,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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


