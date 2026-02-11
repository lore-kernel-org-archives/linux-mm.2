Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0977EB597C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 08:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2DA6B0093; Wed, 11 Feb 2026 03:13:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79146B0095; Wed, 11 Feb 2026 03:13:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6B996B0096; Wed, 11 Feb 2026 03:13:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9328B6B0093
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:13:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FAF8D6742
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:46 +0000 (UTC)
X-FDA: 84431462052.24.D4464D8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0B68F180004
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:13:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JQY/T5b/";
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770797624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMqVjxQuL8aU9wif2n3cfMW7uQkxl32JdDF030wRFzc=;
	b=Dl8WVYh7iu4FiY0U3fWVT7zEm/iFa6kxm5NYZ33c9Ndxa404AHjoF9ToYXEtb1pl35uZZc
	qM6C52BW7iwS0rK1FmB4dqfXtNbqPugNYvK3x2HXVnpPpHAQVFYBxMm/CbEkpjj/CMab4a
	IfI6FqPBgSRparBFI1ACciYXFLe95KE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JQY/T5b/";
	spf=pass (imf24.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770797624; a=rsa-sha256;
	cv=none;
	b=a5ksCeEjrudA3XBaTUU9FtJwHRjxOj6kl1AcL0k568XlEqX7i4f66aL1ActwiZiGB9dRJl
	suHeNE3JCbv63fFwLZC50VYPe7YLJ5LeV4wjXBvHaoL6X+1ITodcVfSJQkKtfzY0UWBdhC
	5VAwTauqsLFuzEPYOfcgN16qchwAgzA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770797623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dMqVjxQuL8aU9wif2n3cfMW7uQkxl32JdDF030wRFzc=;
	b=JQY/T5b/sib6GJ/LcvTpAjaSi2RkbQ/RUwE1Pzy02Z3rcRUkgInPNqGk/AZRugYi6aF/Pq
	5xV4TofbpnrgvEwpdZ18TkPSi0MjqK8Hi7zPaA+FaYyVszH1V2qBQWTpxtlYmfSGP4+m4M
	8+NDNL9tg4AMzmFUqVlwDAd/n8eeddg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-141-15fhnfTcNf-fRvIeDo7dcA-1; Wed, 11 Feb 2026 03:13:41 -0500
X-MC-Unique: 15fhnfTcNf-fRvIeDo7dcA-1
X-Mimecast-MFC-AGG-ID: 15fhnfTcNf-fRvIeDo7dcA_1770797620
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-59e5bf39b83so422859e87.1
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 00:13:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770797620; x=1771402420;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dMqVjxQuL8aU9wif2n3cfMW7uQkxl32JdDF030wRFzc=;
        b=t9pNzFJUniTk7afAft7fdspG0asW7jVw+UQriPMoMFfRtFjKcgR32hOMTTFweNj1jj
         uX4aBcT5+7h77SlR/cyqTS2ETe9FrdlkvYSDq8UipL+XNfwczTw9rYIa2nVCScyMRCCj
         VUW16WnDH45FMcmdBl143YZ2K2ywyi84RzsC6muuuKZ1vddILv3mw7r3tCqDoMD0Jy3l
         hBHBD9Ok5eFiHFnOfGC7N/4Cl/dRD6B5Cuu+jPU3kJr0i8a5IYbu5H6n1XC91QaFy57W
         eWis56RNW94bcU+wArODGt/0i5XyUZ1uAPWuEDz13ewMWc7Z8PSFU/RcDl85OOb1cuPd
         E9qA==
X-Gm-Message-State: AOJu0YzAx6IETj88AznLtsPKhWHtQSwHpz6iXAgcP4R+Y8B+wVqmyf/s
	oMF/EaxO4IaQVgqiHK1GePEDTsRhvI/zfmzVZZgK/hBbElEjKO8XMejR7pILpuexsdTlOaDVW4v
	HjuSde150uFMSUDlcFNA4fTZ8VQ+VYG11AbS8c9saRryG1AMOvnkUCmO9IUBf37qtrtIwkcI8rh
	9eHi6VbNG/lixgT8GIns4P8NMPk+VNJl4wSig=
X-Gm-Gg: AZuq6aKhZCEvCFHxIMob10g3vvdF9+7qoi7icZZrIjQv3qNpxY7gVCyiKzNGGWM1JCL
	f6ptyj93OdTg3MHWPmoSrtpCsCrRuXCqY4c5EOaH+GomVCpzVyzGWOg2DrT1nZ8upgt5w4v2TK6
	s1fwxhWqrRD/F8B6TOVq+SiXxqTIUR4980YpNM9QO3Xm4Cty/F3sMQ5SMV71fmj0mUutAAWDiCD
	C5Jpo57lwIGR3BYRhQUvSZtNHTBcXTyz6ULPhvA99HVgEuTDNNXtoSXmCQOV5AJdtrcIeDhgJQW
	uj6U33Sf5AFVFOQPDy+hmDKzgMcYPqg2g005+cxGqqrsr1fvJmPhkU54+8SciRiHiU1QPjqbmgx
	ACx+iuBSOrUdCJSa9CiFwJZaG8/5a01TSp0ce
X-Received: by 2002:ac2:4e13:0:b0:59e:3c74:82f7 with SMTP id 2adb3069b0e04-59e55bf96e7mr1710593e87.51.1770797619857;
        Wed, 11 Feb 2026 00:13:39 -0800 (PST)
X-Received: by 2002:ac2:4e13:0:b0:59e:3c74:82f7 with SMTP id 2adb3069b0e04-59e55bf96e7mr1710569e87.51.1770797619323;
        Wed, 11 Feb 2026 00:13:39 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e5f568737sm188515e87.21.2026.02.11.00.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 00:13:38 -0800 (PST)
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
Subject: [PATCH v5 5/6] mm: add new testcase for the migrate on fault case
Date: Wed, 11 Feb 2026 10:13:00 +0200
Message-ID: <20260211081301.2940672-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260211081301.2940672-1-mpenttil@redhat.com>
References: <20260211081301.2940672-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eBWL3Rt5XMbdt2mSKrYj5Mj18pIeWDgwx5RKdu_aLkM_1770797620
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6imsrks5sujka41mq8eqjtkr5d9p7j7w
X-Rspamd-Queue-Id: 0B68F180004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770797623-692729
X-HE-Meta: U2FsdGVkX18Ykw6GhexjgS6gBj/DKeNNET+vGbsILlOFdmiNGNvNqQq9/n/FMaoymNi+gTyRGQ7J2YPfh50dIUrIr6Xp6jlfCOY0r0VdnFhnO63JrWqQumji67oVN0mGP0Liul3nc9XdT47lwRhMMwzo1Wv6XcxCHMbFdH/m52RMWBhJy97AK3H9yc3XvfNvSYJXLh8TrHRahaX6Yov9X7e8ZQUWHG561ljfGf8yqz70Ii2U82POH7lGrUekGebkwF2/otRDVi24NazPmJSfTXwwBDVagm3Vqv0gnwVb5aFhLnuhl+JuXTNIrkGew9Hw7ch3EyiZ4F2LtW9fnLrTmZcuJQuInK59/7Q90ymAUp56kvJmyBGSDHNF1Tyl+djwGG0Z8rVfauzjKutq7J3poxv2+SbQ1BrShpS+V2tDLKDw5PMnrQEt2o1RpeR3pvljTX9C/GektVHlx70OVGCCWKvawAgrhDia6Ymrhx2laeq0Zfo2yCzgBv7oThrOvK6UTAtjLbHRtRFlp39Qoyb5NLcBeXqleXqZEjx0XbTGzPpADjhDFp2NDTe33/Z/5EP5Q9S8H8gFT+7fMJidkPgsEGSwECY80KoyH1XVgvwYCk7EmSoJc8cUoIDESVpL9RYOGCmBTevrSzKbCxkaC6zGFSh7nJnKaTijrSpFUm3gVZwrsQrdYFTtcoz5g8EtgzjLy1a4XUjekp4j6K+chntECrkEpkIWWpEw+IYQAY5NHzHCLXIjRUiKV1NZLwhFRegiGwncCrXWUawNw8u+UG8UGmxHCGcOC3gBiAeyyJP86E9LTjN/Rgqe9b6JZsWZDqJgww45CL6IQIT11ccbEDOZ0DfiVf7AaiGQC8A0kKOLk4dIFMd0JzHXokjN25vUM6lOdQMFYUIbEYqT5uI3SbXmLhtffhwIzMT4BbE6k0AY7LK0ZvlSmkpTCp97QIFmXdH1UOs/aYTDECUNsWD2Xxt
 d4u3ArCD
 hoYFfPl/TMdxSyY425+vTSblOoV2itHrMTqqdMNaknk2oh3O9w8kdS80uiL+a7aUUSk4RpmBkNKtYGv0+bBOxiIjVcYoHOKatgbx6PMA9Lgm+/G4xmmPHwZdLEHTeOwcqgZZW8oVzfvfqlYN77yxAA2kcbbwdjxAacwK2LlbXO0PU3vJ8d9I+170CsHF60WpwZOJ+kk/H90yrz+82hwbAdoM3O4YeaTu7MSvGArJFYux6J5Y2I3WFtKAHSkDsKAZCqjPKB36NicbYeedVExR/R2UtL15omTTdh629bgcfJOxwQC8hHiRpElRrCVCDkuuJDnL7rtkGSfiKqsj34YmOy0Rnnsgzbs9oZTFai+7ist3wKHbl5bucRqGUbr3SoTOW8uNJGNnRGutj+CSqtU5vBHi0Iy6N14Wuc597
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 lib/test_hmm.c                         | 98 ++++++++++++++++++++++++++
 lib/test_hmm_uapi.h                    | 19 ++---
 tools/testing/selftests/mm/hmm-tests.c | 54 ++++++++++++++
 3 files changed, 162 insertions(+), 9 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 94f1f4cff8b1..8e8c8970d1f7 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -1196,6 +1197,99 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
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
@@ -1512,6 +1606,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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


