Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 418EAF531EC
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAAB26B0088; Tue, 14 Apr 2026 00:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A340B6B0098; Tue, 14 Apr 2026 00:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949FD6B0099; Tue, 14 Apr 2026 00:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E91D6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:13:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CB231A03E8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:13:37 +0000 (UTC)
X-FDA: 84655842474.29.0FEA4FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2BB63C000E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:13:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gqECC3Hf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776140015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XEjxSMV/yk/AoEt6Wx4MPcC9cXXlYqLJ1JFlJFTY9ig=;
	b=6PmlLSaVCxArmJPWaAdK7yIUXANWSMHtSZ/7GiJw7rvVyYUzmoq/+clRiVnqi/3aB1XFm6
	NXhEY/ytShoOEJvynTjoJTJfbZqYxU5MAdrfHzpYoMM8uXMiZPTbhDVUbmiqXvcc3spUCA
	RwRfe+8/hNN5nBzjX+K76aW9HlIMecY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776140015; a=rsa-sha256;
	cv=none;
	b=plPmhwujMR4QhB9Q2Rrtr/b9J/mhZU++47tEOY1D+ztNqeFBrJCXLwo/gbZsKTx+FsbFXK
	BoohwrSZPvrd/z+6xApZ3cv0I9wPOC5WftKrgiGLL0vbkG23d2cmmbnJj2SXm4wr2O7iAN
	79NabNyg5q7KZofUtbM03jC73SXaseA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gqECC3Hf;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776140014;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XEjxSMV/yk/AoEt6Wx4MPcC9cXXlYqLJ1JFlJFTY9ig=;
	b=gqECC3Hf4B9cOlqjw1CKP/C4qnDGaz4mwTC4Or+jlZBD6rrMwSpdrxyJahX1LuGhF15gcD
	CElQs/tClrL9WuX24ZylvuLeNxURLqh2Dc6tKzofUBplNhYfOvy+uNKKAXs8RHLJZGj7ev
	Gq1Ij6lIbXKrdGbE8TF8R8IQ05Lr6CM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-QCvzG_owOwmz-m9g1AH-fA-1; Tue, 14 Apr 2026 00:13:33 -0400
X-MC-Unique: QCvzG_owOwmz-m9g1AH-fA-1
X-Mimecast-MFC-AGG-ID: QCvzG_owOwmz-m9g1AH-fA_1776140012
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a3ff732c58so1894985e87.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:13:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776140011; x=1776744811;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XEjxSMV/yk/AoEt6Wx4MPcC9cXXlYqLJ1JFlJFTY9ig=;
        b=L68vP0iNfi1fYcv6BmYbrbagxdhslzD4jzGHJO61jgNfijKaY0hQMzDmogcRkHoyOE
         N4pKHvQ60YGclfR6YbAGjjoDt3Xzf4aDON/+nchvLV762wUkF+bVV5ZZalYo+J4r0E8e
         vmAtvbvhXdaUlZXB3e7rvW4/xIfrh/9n9fJufnbZfZWb1xLytSwzB+GEJ5cDKKy+mBn/
         hFy0/WRaMIC6uoylKCSXlD4bmmFk+i7ksDcN4V8YKzi+i3hDGI5SDmtjHTkkakIkAiiQ
         AvCS825J7H0hWMVYO+Drt9cplAb1hW/QJ0FJOZtxtcujXdyoclqSOm7FFPE1nfiwxGEi
         oxIg==
X-Gm-Message-State: AOJu0YxOHpBWjXItMTfZha0e9FjFoTISw9902GIzVI2yy/n63XQC0tfk
	lhnJrTUI4ScWob52xxnLKOiPB+BA9rwDvYTltg44MJkRsGAmWvbVRaKEdeOiOmF0/Wk+xO1Lr4O
	x1HRxhQpgmKkhqziGpJO1Cl8i08dU6F/sxBSKZQ3WcF1tsgX08wR3x4VN7yDx9L0rKO+/vCbdFN
	pvUuZub1UaH0Rvy4ZjBAhcrQ0XC396UvA7VkhhwA==
X-Gm-Gg: AeBDievaBDy1kHP02824yfh8xzuGsKn5Q6RcvRWkCM1/aWUgjYVRjQiJtFpen59+MG8
	42/2IPfHFBjdGIJDLhJgMuw4AaDVfLuxaCE40UcgafJwRRbTcD/jMrT4+qWrJqvv3mT1VBB+q/1
	fr31X99rKXSv97ld7MBV8IjCm4oRzM6v1LWqUTetyAzHzwlfcmuFvKc+RmaK+qKuYs1IfS+j4+X
	y65clOUdLShLFtmMLs+JGl9/3fshl56t16CdGo/LLCm6KwSDLai0bnJDfpZMS2qk1zITKQmPVB9
	xYrtCRr9JygkaCvWGzRuRrwjvsNo35bNlz65qpEZRdv3cseb2fMzqP7yHMkwWBP3pPzzGSF4VHS
	bPVnrNIPbnurIlstniXkgr/9FLchtIqIzAt6Q
X-Received: by 2002:a05:6512:378c:10b0:5a4:8b:a067 with SMTP id 2adb3069b0e04-5a4008ba0d5mr973339e87.9.1776140011162;
        Mon, 13 Apr 2026 21:13:31 -0700 (PDT)
X-Received: by 2002:a05:6512:378c:10b0:5a4:8b:a067 with SMTP id 2adb3069b0e04-5a4008ba0d5mr973315e87.9.1776140010515;
        Mon, 13 Apr 2026 21:13:30 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a3eee865e7sm3040666e87.10.2026.04.13.21.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 21:13:30 -0700 (PDT)
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
	Michal Hocko <mhocko@suse.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v8 5/5] lib/test_hmm:: add a new testcase for the migrate on fault
Date: Tue, 14 Apr 2026 07:12:26 +0300
Message-ID: <20260414041226.1539439-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260414041226.1539439-1-mpenttil@redhat.com>
References: <20260414041226.1539439-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pslaM1rtC3EOp_olDKVvDAglk1QbeaFAkeDkLBVLJ4I_1776140012
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2BB63C000E
X-Stat-Signature: p8o4knyjcpmp8aikteroa4fkpaaxfuhk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776140015-627773
X-HE-Meta: U2FsdGVkX187hKCJaIvpU1dxqiaRI11vW7bZgcBixd/NLA00Nyr24VjnsBbr1lQxH6FZFXtXRGuwQMihN/fHgMFArWkzIgHrsnWpTyNpGIo+GYaQ8IwgVS+YOhSxmx0Du7es57bmrE9oZoIWfy+vxOKDCvda/cOwqBEc23Io99pIFFqIwotmXFsXlJpzFp2NzUxM9kx8JU5wo0PtTdl1kqbK72ztDaMl+SXjQ5OXIy9VpLmw0UAeK5kqwIkk3x23epR8t3uTTTqLtY9XVA4j7Oxa9jRyGXyvS+TwMAdyr6zAXxipumoO413AzO0tC9TtLEbpfFVcq2n/LTVXr+yVryPnspSTnQpswEODec3MLOHZu6rYfAyiKPXCjQlwuAzxpRwMFym4bgidXFjoTFmKpkGTZabhhMg3sbztjDCxeDrTUcvo5kN/+A+PV5aMEIxpigye6cP8ebjBvDQ55VNPObESejEf6YCDmURDAX5uSJo8HaGwEG/TOsHg7Enukpa+p5sE+3NUv6lpNOQBMHDA4Z+AIAmzWbuOXajyEzkLuEmB3cOdXU78zwzLHFOADC8DDvbdNQPH1y5KY3sRuJE0tdCKDmKtj7ct3RcHzXXdsiNnQ6ho3toEim9YNzmyJxLxhRRGiDM508VxeSmFup0cGFrrYI/JPxtjJDDG+DdZPbyWp1PBi5R+x5e1X9ds8tQldlFdbkjsy/N0G+ewS7LlBcpvtjNzdTFfMgB+RwdUa1XgVGAxYL+7axD3bPzvRgemC2ROajJcR2YvuPavQwGFa4LIzZsuehhCxB2whEyyuGXnPHMNQ8cySvFAokAJGL7mJIiTtZs6+JzHIEC+nqoWGi9bq4B7Rez2aLxz1HqKCZPby7hZBtb76F5YuuLKMBnZFUnvWsCYOWqA7W4ZG6WONNxkTpG3GWeSDJZcDPhIyYVPznpwNWPkNiRcAbP1IRX3fnadNwJ6p7/yZV/WE/P
 0EvMFH3X
 V0eqxf9fu2cMWMZ+NXaJDyjD1NFuK8/dwQIGWrCSK7ofEotlmg3AaPTJpCvspY37n3779UM1g4QBE2aKW/u5mKPJijBf5GV9BZYSvqDbG7VQBNTfZPxpIQmtxJsJ/x+gDZfOyULa0ylvcLWVTk6lbbb+w0H7G2ZzVXJZvQOF0M0j2vg/6gMusUxG6FP//uEqeHgGNP+6EYYK9qIZHdgJRH2ZUyB6vlzza12U3BQBX8KOLdz9k/QIRLSDFJz0olrzwJtYoS2yVZBk1dL26gvp9bl0yzrRPdE3zl2qzadf2AuYK11tMPAf2Rk3YKmGihClxF8rX2LKBTG0O2SpW86tmq4jW828VZO1xdaY9+lWe3s+eh2/zir4SoyIEEZ4VnFrLFQ1vmJoc2kjTVYtpaHmm/FCr5bORsQyxFhyfCH2bsrDMJ2ubAC1NCwxCi8llgEhtGUKMK6M3CmH6cOfHwN14jeo8Fw==
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


