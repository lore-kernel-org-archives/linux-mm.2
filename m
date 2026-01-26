Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021FACF65DC
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 11:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF4A6B008A; Mon, 26 Jan 2026 06:20:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44EAC6B008C; Mon, 26 Jan 2026 06:20:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343BC6B0092; Mon, 26 Jan 2026 06:20:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 234BB6B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:20:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E26041606E8
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:20:12 +0000 (UTC)
X-FDA: 84373871064.24.A3E50ED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id B8E07140002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:20:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VU7iVSKi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769426410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
	b=G6VpSZPzH2AomhxGaeC8V8pZz/PgXXByqtf5k3V/Y1awTrEkbs/WB/tX360PTWRuTf5L/+
	tvYWxA+RXafQuk1oIu9xImQNZbrXrIRe6wafPu6olywoNkSVVD4DNctLOUOg+3ala3sXq0
	9S4MPafk8XiughN7spYMzJaWTgkuUxo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769426410; a=rsa-sha256;
	cv=none;
	b=FGGU8hW0jHrXSlSqCOQHM4c+umWq47jNvWyCf1s/LHR3GX7uQ9J8meUoXzn7Yf6MrNBEkO
	pfxcwpnmjbMlmCMZTl9d6lW92LK6LG6z90Mc1zyv7EAbtM/NR3Av4MzY5SQ1ITJwudG0PP
	1TsarGrD2lMBpfknFZOL91dzxVKW3hw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VU7iVSKi;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf26.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769426410;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
	b=VU7iVSKi4byVW/25Np2owJo9y1zP2gmGLO+UrymcigwwyHgIwvBna888UUNKojjjTln43X
	lR1ViC/bc+8a1UPct0B+R/4YxcZLJDG1cJVpG4jUzMaL/esPDBeYJ4PRUzJrK4YM+ZEAe+
	SYdacdoQdis/FyGnjxcUTBJFpsQ/wx4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-549-KZTg_0rpMem2GK10KgQHLw-1; Mon, 26 Jan 2026 06:20:09 -0500
X-MC-Unique: KZTg_0rpMem2GK10KgQHLw-1
X-Mimecast-MFC-AGG-ID: KZTg_0rpMem2GK10KgQHLw_1769426408
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59ded18d011so1018819e87.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 03:20:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769426407; x=1770031207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
        b=kLfdbPEG8Tx3795U6R2ymoQZNpqEi++KkkgnarsDumL5aa3mOANCvO7F8b2ULjETtI
         a52Oq2DMnL7a/2oTf8ljPJfPPfpVXapj398fJ2uqwS5FWehdaEc8bvdQWLurLlI5oY77
         sV6Cfx5glID7v6Hne8qEtw8gD1shJDNAJ1czr8Mme2xZ+u3uA6gq7+NSjmlEQVHY8Cua
         qP4B1QWB72Ye7LhMoWJNsimidHfnO9zOO2ChmtFb1puBTYyOdk5T5Pc0fflVZIyXVTDE
         mqM4g8l8SKWbwyB5rxZUM4XJFdjwcffgqX5n0M1GJY0WXfS7dr7kAG21KMb49ZQbh+tI
         RhYw==
X-Gm-Message-State: AOJu0YzF5a4m+v99JXsViM88GU7NsZ75MZi8zclM8ZTJ+/HJ2j4iqh3r
	eojs4abj8Vp3YLYkNeilaoXGfJHROr6QKci0wKD7r4yAJupdY901KWSuEc5NZK4HuJS3+jSFYFa
	qcM72v/Dgfu7PMKzedQ2jC6nLRYB8MJBXh/1qua0kVBc5/hXfzM6pdAD14p0LGctuTfQguuZ9q1
	yNasK/dDBg3O7Zb9AzmaqYe3/84rNTYKP9F+g=
X-Gm-Gg: AZuq6aJTz7b2AgJNyjRP/S6pU/kj+ZvJdx9NG/BPbBPtaZ0OqtyyJm4Fq1ji9P3hLHd
	KcuqA7atbI59vFP0danAYPsNkPfNwMcmhbO8TqiQNRJTti0u78lL1Z+Y0xvXuato0ulw18ilR1P
	PM5/3jUDO4nu5AHfiCoPp7+73ZAvTuXnBNmmHK04E129/JijYm4MvU46DywsWKRf8pAbsDm7mg5
	XqTiawMmNqxd0hu14V0Y0jfNpRCFa0V/hchfmtsGStMyiV9P98wGMWVmtcOuf7ip7oeYX668KKb
	J1KRQy8H9mfmAHOpPgWwman5+fB26/l9seOwu4E2k8tVCWEsgPV6Wj9cmJlK3vzqM8bq9AKDjKJ
	Yy6CwwqWzJ9py55O5JzzR8m57
X-Received: by 2002:a05:6512:1195:b0:59d:f72c:733 with SMTP id 2adb3069b0e04-59df72c073amr961409e87.9.1769426407005;
        Mon, 26 Jan 2026 03:20:07 -0800 (PST)
X-Received: by 2002:a05:6512:1195:b0:59d:f72c:733 with SMTP id 2adb3069b0e04-59df72c073amr961395e87.9.1769426406464;
        Mon, 26 Jan 2026 03:20:06 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59de48e5f76sm2572221e87.23.2026.01.26.03.20.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jan 2026 03:20:05 -0800 (PST)
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
Subject: [PATCH v3 2/3] mm: add new testcase for the migrate on fault case
Date: Mon, 26 Jan 2026 13:19:38 +0200
Message-ID: <20260126111939.1332983-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260126111939.1332983-1-mpenttil@redhat.com>
References: <20260126111939.1332983-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _EGlh9q0eqsQPrPQSUovzogI1fVwhSQuEEhS65Ia34g_1769426408
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8E07140002
X-Stat-Signature: mn3wxm47fttex4sekbwed9jxhbiejg7y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769426410-871450
X-HE-Meta: U2FsdGVkX1/8ITXFNy+jmLlSII5sLzYV9yuEBVtfN2MFzi4tBefii04swT/Q1dNURFyOIKN88rkbVI3T3g6dTMTvjzD2n/MjNYbXQM0YgGTC17Pp5yAFIr1e+dLG1EjA1oYhux6DNCalyMEbKlIUiH3tOvfl2f9+X6yY0lJ0813LGOuPlGaZdr7wQvgi8VcO/2jQrpqtXAiXC6tTKJgsebn0wVg0UW05oUzkpCsZ3aWwwO8yjCccFFgPBYgCNFqcjnYA3bL92UNWfW/F/Qzq0+mN31rApThSS9jKVIDGJFEEGkXgOewJaPo8+mOFkmpW6m0JnmPSuLwf2SuiJGYK2IlcDbfu8Avxl7rUijpdigkWUOzlbwm4fxJBy6zwjzLF0d81UT2E2/MNCqyJW92cDeEo9cVT6r4r8Rm0Em7kRMkI2R95vaFM4GDYOlAFzKOR4A9wTYCJuX6ak3KsqBmjqFBrx9MTAJnCmRn5r0LbEJhjJG/F5ZharUfnzVjYIIv/aG89lGK1vJ8x104ozl88WlmDfTTBOOwAFJRBEo/vPsIUaa/Q3kwsDG+nms4kW+fWsL63pRkCtFab1841aONfYUVk/u3D/PZ1WVMnegIFF9wqkUdPKvXL8c3+gRWCVSRAXH0nZ1TpVtp0fthJJYi4f0d6i+MqaT92cLT39Nzlij5+6h7Paw6ZK57NvIW+Yg/p/bxvnbNShVpQatiTzNSz0JrQa6M78gieFVMmq6kycqia43bJDFc5rUwLrPHlWp2zjiQJ8/Bw3LAs0GmS44ez//F9aZ6Y7OzBjTVspywx1ihNSrQ0pX+yDDKbsHZ2Vi53phWz1CY+2UfMoY14PN7wKFhjMXyR/FiiSYjIW5HIxuaXiJ3TsezPTscDd3R6crtHFrQSUyjhjRqyTgVzJwnLRABMz1r1UIL5MO8Qiav3sJFde8xn6Fh0ulrTJAgXwSaPBELRUJ+hJxkL+PEP6aJ
 ae8Khqgf
 DOvPj6ZpsHoPk5IPeg/qsM88zh+9lQya4Hhl/5SAe5rCSSoUZJcXVC5M1Vdi8RE8oUmh0qVsyJ8ysKX1LxMjikfPUxf3rCE9PWvXWqcR2gVvvdX6fmfzIriZ/LLAj7fkLIy3Enw3bO9x5cB9BY0Idq5RMYf+3hpWGpv2/lR0YUr/t10Lp1RCJ3AJDMxLygtRQzEOgGnUx911NwMGewVsIZyJKSMuKJpFEiUMIDS18fCgH1WzhlnSIEZglNjggJ8mbatbpDaY2xuYFgEgQVViL5EY4ad0WlqPmysSAlWtc7dJOqFV0IPb9tK1JZQ3Q/k+XMqBz7XApn5Bv8OwbE5DQHVr9pI5SP25DVUvFxmwfgjj1f8RTXmq8q9gbd3QdeCN8rv7JNgyQVAcOL+o=
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


