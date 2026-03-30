Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C4910D14A2
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 11:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 847C86B009E; Mon, 30 Mar 2026 07:57:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F87C6B009F; Mon, 30 Mar 2026 07:57:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698CD6B00A0; Mon, 30 Mar 2026 07:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5903B6B009E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 07:57:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25FC6C2A09
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:57:03 +0000 (UTC)
X-FDA: 84602578326.07.A40D797
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2587218000B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:57:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aK5LTQWN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774871821; a=rsa-sha256;
	cv=none;
	b=FvWiGrlBrnCq3HfImL2fWkPkFmhME5osw8Qpvs1wzKct6MZgE5RxzK5jwosVTpVzuV4BWn
	Noj9Llgnb++ZzxTazIMEM2r9WTNVNprlsMMYGAZM96v98CIPl9xZOx2ICbcqGsT6Iv4oQD
	PhQ0+h5E+B5Z7jUN1FHJzeOAmM792V8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aK5LTQWN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774871821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
	b=z0FgDmWgmk70jDP+6VJqb3Wtp7Lt5LvpQdVQ3I7AazuflWKnnj0p5o0onOlvgfukTG8YyH
	PqUBELBz16zS738bOlxi/+E6pCtwmZBlk9Q/wNasx9nCqwgTcWH2Wj5j0eM1mJk1dVO5aK
	/RGYjJubcSR7Ol/0bFOng3dJen6njeY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774871820;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
	b=aK5LTQWNbnf/RlYNH7wMJuyGoxXQQ/mfUhbtMvaFZ7vVrvCz8Hr9z8/4j9skVBU08abkAl
	X99/aJMwAVMqojqKux0mtX4K9dG0+/HsPJTTW8J3AfcDEnZfVFNv8zTia+g8TS60TrfxU8
	M5WaBMfiGV/5Xdy2PbqmXMeUpxa50JA=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-591-b_lxbUD_PoippDaoEriSjw-1; Mon, 30 Mar 2026 07:56:59 -0400
X-MC-Unique: b_lxbUD_PoippDaoEriSjw-1
X-Mimecast-MFC-AGG-ID: b_lxbUD_PoippDaoEriSjw_1774871818
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38a4536bca4so19526641fa.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:56:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774871817; x=1775476617;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ixwVgPxIz/n/uYpN1Wu+O4jklsKJ4ob7dTgnI6cFXT0=;
        b=n9N0ak89xwzfoX6lRfgsVIsrHOVLqNMZ9e8iHwEcq8MQ9hEhfmnGhq8ufno19wHDxR
         X0n3c5McDg+GA4fJxaaaPniAPiJkrCk7HrXhaKexEVyx/RywyO2tO0cGNyeDHl0gG8re
         czfSIjmSr9X//jBt86bD2P5YruAIyoJLicOaMoHhPhWn4sRZI21nXVelfcEWmGK/o2Fn
         tqaKDf03D7dN1wwHZyBHuS2udxubAdZDDQaisgrgWi+JRwWQQ01TsK/TgbM2UPYjmt8P
         mK517kuIJ+9O+B1hVzN2ktonsc5arR/xzqGOQ502hBmkKIGx/IKq89JHwd+QFgpo5ou1
         TxMw==
X-Gm-Message-State: AOJu0YwaQg3kojatpFuWXKWG1YkbyQh1WDFiD9Hp9NX41k61sFnYfRjr
	kQ3DqNM2BFz4j1YybOLxHbHUPAKbHhtrgricDwjHKQ1LT+sMHsL5SF85PtehkN2dPI4FEXG6caw
	pf3YQWFtBw3lc6ZG1wdVo88xoLOuFLoybb6pBO0EpniZuodxUw5QAcnh/PL3zOd5LpDiVx1HOd7
	Rfhc9PwQj/YeiC1/I3DyiTk61Hc1I61hyfmdvblw==
X-Gm-Gg: ATEYQzxL+Ae/qAGIsQzQu9o4InrFNMZ1xxrgb7buIXhnuU/BueFyMXvTsl1p8Kg1kDY
	IElOtYXDuPWpz2vdeO6j3mjZsd4A/g7FgEjxpLE4h1aNnMZEwDtHrmbQcMGR9nS1HA/rbpvwMVf
	zu5HU5ev/aWHy9QK/YN+2038k2NMXfZdQkczx1lnSUn0H970i4mf7NXGTM/oUXhDQx43oPbVTP5
	bsOHtZUfK7CY0WK6LJlH1mBKGcdBS8glIW/kKspIXWzbse7iJ+Dfoyo5yNrOEgX9kGtSTmUYh/u
	eN8buRnonLs1oPXsSt6L3FjR2MYheHiDATtdDBDqH7OSJ8Xvtn3WqGEcfWpuQe26kSc8xs+oHeX
	WN0eaQser9EsBsknL94zxdjlg3LF/7ux9ZhST
X-Received: by 2002:a05:651c:4107:b0:38a:8b97:7ec1 with SMTP id 38308e7fff4ca-38c7405ab98mr23353291fa.23.1774871817128;
        Mon, 30 Mar 2026 04:56:57 -0700 (PDT)
X-Received: by 2002:a05:651c:4107:b0:38a:8b97:7ec1 with SMTP id 38308e7fff4ca-38c7405ab98mr23353101fa.23.1774871816441;
        Mon, 30 Mar 2026 04:56:56 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-38c838daa4bsm16330071fa.32.2026.03.30.04.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 04:56:55 -0700 (PDT)
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
Date: Mon, 30 Mar 2026 14:56:10 +0300
Message-ID: <20260330115611.347988-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260330115611.347988-1-mpenttil@redhat.com>
References: <20260330115611.347988-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ps6iK7x3clLlH7tw1uoG6hOZ2t3LwRynfh8ifIlPViw_1774871818
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mb6k1k9x3hitwemepehujzrjbijr5wmy
X-Rspamd-Queue-Id: 2587218000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774871820-97714
X-HE-Meta: U2FsdGVkX19aLVqhoxY/5JGDJGE/OU89K/2yLXj99267PZUroO15vscqzPFdHYvrDB8P5/4ALLcnbYP/LGlxf4YMdD9wkDKOUF/g1rM0b/KEuUmZL4Dtt0I6GRwVwSQ77s2QFoIGdQUKXRI8Gsha9LsbbWv55dYCNGiyzMfPAqFK1uPkiRlnRoinmqijVwCbJdStFBd/qjf/Jza67ZVnbBDRlxmf5d7GqtV5g+B5+oOfDIb7qF4P0/aiT7eLpuAa4YgPX0aG7rr4c0fOu+2jEqaOX/E/whwl5STdseSCzWls/rv9K+kG3DEfhfG9q1i7QBXJxNdjUcsiHmJGvTjuX7KnFPGGJbvzKp2l00qAmqvKALHuC5Mg4VyiYjEF6bfmhI/REc9ajF+9mp6P4DTPLsQecK1pYLExwcXrzVXdLmSQdUJNGc50gss8HasXK+wGJkMSLqj9gOvG6kYb5k2vc2A32N7E48MnsJCzbd7HQ0V7dAjGeQYa55vQ3yNDh6Bk1dOMB1fjLLYU51P67nEVpYPAal4xBs9gGCf+EH836I3CjVpC2ty/G44usorZwtGaocPPgMyi8684wJZtpoUP4tIIo+DG5+yfh2EDfpqjBgiUQKFOt/Z/StsK0NmyEkTQ5gGwMvK8a2Sfq8sAMUyO5dEa2D9EhsYkTNZ8ZDlb1Sxq9bceoEEycOYJCnXW1iz97kZQy/FDQyuwE0rFhP6gyHHhr1TjG3qMHg7LWWNDjYq+sx+BUKrwQBKSWH6sdyLopsKVRWnCKCSz2Rp7vyQwM4oSw+zjiQntfu8ebfEGsc0a0b2984OSGG27OUpenInJb0vhhkh5/lcZmhY8QrmJMJxP0PiBBmr2hA5nrKZpU7tr+sNnJlLu0h+fLvv1pK+kx3ga5f4JTfjldKw/rhFHQ5ax8s+1aAhluYmp92XEoeF0srJbCGK9COFi06WWie1vhuUHq7j7tNQTCDUQTZ7
 AqtC9zqE
 vJdPf
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


