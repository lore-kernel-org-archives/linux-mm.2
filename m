Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EED0EE7315A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 11:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528956B009D; Mon,  2 Feb 2026 06:26:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0376B009E; Mon,  2 Feb 2026 06:26:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3536B009F; Mon,  2 Feb 2026 06:26:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27CCB6B009D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:26:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E23271A0B22
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:26:53 +0000 (UTC)
X-FDA: 84399289506.07.72C6D76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id BD9142000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 11:26:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LXXggcu+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770031611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjdZBTbH5F5FAhNXGS9BiCoGBFKaNwuIEAGFZo3GXZ4=;
	b=zNkXpn/l7ghujmg8KqPQuHtDU5ikskswIIiEy841T3B40fgFz1lqiAfEKeGAtS1+Py2v1V
	tzlBt0ZZvYJ8VAax7UruP4tlkY3kJ3JRbvx5eH3tY1sxgXS+nUpxBZlSJjvAE92bxbFqky
	wZStJYaRX5y06GG2OrAeu5Rc38UalVk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770031611; a=rsa-sha256;
	cv=none;
	b=d/aStWWUwJbRHB/9hQP7mNsa03LRTXhlLRgV4gGHxIeNZgqLjLPJ25Ne0J89vv/ZDfdJYg
	VZOgMDT5Hr75S0lOvR6iNhhpKa0Ro7pgG7TLULZU6msSTmWUTb91jjUL32u7NUTaFOiWeR
	cJ6L5kSl66kt5/gvKeS9CPTREUJ/LNE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LXXggcu+;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770031611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bjdZBTbH5F5FAhNXGS9BiCoGBFKaNwuIEAGFZo3GXZ4=;
	b=LXXggcu+lrvhsRwf3tNqPB3H4d/3V20yc1gqp357nmk/VC5GXVUpywpQf3vnknR3MaM23+
	5y4dgPkg0RRxiNi80OpyTAg8H82b4U+PnNp9ru7hn0wtkDQ83kDMJv8DlsmUxO0Blq601e
	QjhQlZ0HMVGSOMjuwWn4wGg1LYmD90s=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-456-P_gY-sRJPcWKuuWrUThqbw-1; Mon, 02 Feb 2026 06:26:50 -0500
X-MC-Unique: P_gY-sRJPcWKuuWrUThqbw-1
X-Mimecast-MFC-AGG-ID: P_gY-sRJPcWKuuWrUThqbw_1770031609
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59de4460e35so2397832e87.3
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 03:26:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770031608; x=1770636408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bjdZBTbH5F5FAhNXGS9BiCoGBFKaNwuIEAGFZo3GXZ4=;
        b=Oa4sIoihxhauy1tez/cQbxAgN6WyTOf4fUIlPk4cKdNT5hdtcnSWqU+tJesxXVfR/X
         NPtmwm7pe/3pvyzjaHs8WwEIldQoBFQrDqjVl85OLzM0psdo5U+uzeO3VIDiQRxK7D5I
         T+dYnVvg0/+gEwrX7PMueOdUUiz97bWfFBM59zXWkeHsyA+4uD6EumCBJzKVz1kPpJ9a
         2k9QnUeBI1rx7xZTrxjM/8RpRIOxpJYHaWVTwXMnXtpwr6rdy0E3+kOM/4FTCTjjtmRK
         PMQkohYAd15JjuwioJZH/SIET5+d1kLbXGJHArJuztpZenMhyHjetaEtCC6xEC95GjUh
         L1sg==
X-Gm-Message-State: AOJu0YzHJMg5KQMUIaniygpvUDEG8BwvmXw8hvzyT5QI8AwDVCrG0Spe
	4GJchnnPwK127XBF1RAEd9IvQ0eQL2tM7OArjW9gpMJcGpmUGJ/1aAeOK2clUkaf4wWLCUdUKaO
	PLzjHemIp6v3+NNjzdEPXRMgrnf2cezKdFzXy7uTURektouzKFa2kfquAO7hrPDTNwdfqkp2/so
	PAX8wnhUsxrxmu/kzXSd/rFi0KJfsPnrt62vM=
X-Gm-Gg: AZuq6aJFPG3IewG/3bLkATjrIsuMh6P+BwxMsVGyJXn6bsCo8eEG8dfGwl5/ufJUM4I
	4UZk6QEsoLA3SZPrq2SCC7T9zLj6wmCwwXam7C1HU7/GC/s5bAs+ZJYqBZzlEK56NjukbjQDEpT
	p4uZM/cKMKHJkx2NtMEGxGM289TtfkqXVL3lBXpdLdDJXUrB3TqmdJZ5ro1BFpmdImxANtWCNYv
	qu8IYTwceLBSq9pe+g6uKJtm3HZJg6d50fc48krQnb3JAIV5hPpELDdaIQhPoGlhIG45RG9zO0v
	Of1QtvkBzF5aZuNxghH87w7UMAQrK/C9AfRT78TSGsiTk2LwRK15pkfgM2lTBa8TF5+tyt+Exin
	W6QjVAcyNmyKdBXUQNCQUJO4I
X-Received: by 2002:a05:6512:23a3:b0:59d:f473:aa8e with SMTP id 2adb3069b0e04-59e16432a71mr4510147e87.27.1770031608078;
        Mon, 02 Feb 2026 03:26:48 -0800 (PST)
X-Received: by 2002:a05:6512:23a3:b0:59d:f473:aa8e with SMTP id 2adb3069b0e04-59e16432a71mr4510126e87.27.1770031607562;
        Mon, 02 Feb 2026 03:26:47 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59e0a43e8ebsm3221336e87.55.2026.02.02.03.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 03:26:47 -0800 (PST)
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
Subject: [PATCH v4 2/3] mm: add new testcase for the migrate on fault case
Date: Mon,  2 Feb 2026 13:26:21 +0200
Message-ID: <20260202112622.2104213-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260202112622.2104213-1-mpenttil@redhat.com>
References: <20260202112622.2104213-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QxS6bBlnzLSKiG1UrgPuKx6W1ywpM-H38tzWX183X48_1770031609
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BD9142000F
X-Stat-Signature: 77cxcxp58gaibjyf5ipqmswbhdiha3kk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770031611-850925
X-HE-Meta: U2FsdGVkX19/HhN8FD1LklckB4BBDDeX8llkQzegq6iAJgGfsf94fkQCxq6mulhLPwXgElxVV77hl3ehyjVbSD676WzFeM3bbA7qAwNmHYjsnQPU9z2tK6a7/atT7EXPBjaArSr+DNB5mDMPP2vWf7JoBmdZnYYJ8G/fpTLDkiejZC0z0XjZHxFLZKbqC/iFxTKEJePImCa5R0h9ek31D4jmBIgaAqv9xMiYuDxb4GJf01b8OmDl+47ZQtHnQGCAl+DSpVrqnj9afD+n1cRups4PtO7DMkAAEgFQ7H9iVmw8ER+Ol14r3vdpgFNFf+2EcNG0RchY8g5q9yOvUNUN6bwMiOlX+RqAY7ddYut6FJWcfzUQRv6jXokDL+XhClIFNW+oYjJ/sIufCYjgPvKJu7PyrZkX0YVGUbNpMNpdF21bnh7Iyxec8m/76ZdUNGrAbGNKMM60Dj+KqwVzEDha1FirkXlCLjPuIISlXHr1RyKaKhctRIi7FLQ5vtl3L4zx7RuuGkpHhvttUec43pSVO7ljJu2jQgdAnoxfzUyoXpJTRakiCRF0wK2zvsoG+eSSPETeKKDSaHWSM/0Niop103HKz3CkaSmcBoCOeVdTWB0muYyKpjL+ImVdFqIYSWP0VqFP4WrKi4oNhPPpmxyU+lL9MqcSK+luxDsvY76Va9qw7fZGCZbnv0Z2KrujZAEtLw+BGCcrIphA32mC74oYyVY2gri0Ov/k5bHBiFcRo2QD5ZwporOulMIEZiXmc1TEPiW7V1O1cYuwsOuwCb6t7N6Iz/cllpgZmAR4S+Qfya+NL1z3IhWgSOpwATXhCnuOPZIyfzjl57I4l7RwVwNdEOfBpNlF/vx08OhMVfqxJaRWzCV/hro5vLRYYOUT0xUmkizDu1l5/XstDC2yOTjgv/9IjZPL3qW8hRK7QBgMs+J8lhMMsFB6EwA9WDudx0cwDXdRs98+nLPoDNSMFFf
 Q+OIqpUE
 AqQrSa7l26wV3gMa4NHYMIZF70P0k2r/JJSYZj6P6ulr8bUktbWt7bcXaxipN0Axk4DCVgD+wd9IShH4xLMyOX9vfOATcNs1WzDxyMwRQZaQ1bYMGHJX9cxskDi1T7+7K1bHHL5T//rYnSVnwyo3xlvbrkGmvO7zT17KenLoVtzQqZ+e4452X9jrM41lM/JKPYA+ROG6T5tzZ5fKu4uc9DLjAHcYTc/3s+z2ada9hF8opkykR/hJZZ7eWFk2N+181nN+oGhIVeTNTjDZ4JF23XWKitAgA9DkaHwUt1ZgQizLASscVqGqC6xkL8CF2zN85JG1EJ3Zw66Ujr4daBht78JF8v+R+igzdjL00dfbkX0XYnkQM8RpMyj9nmndqgEvT97JE8uj2vLC4kDk=
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
index 455a6862ae50..8e8c8970d1f7 100644
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


