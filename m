Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B615CD31A2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CA156B008C; Wed, 14 Jan 2026 04:20:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274E46B0092; Wed, 14 Jan 2026 04:20:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 177776B0093; Wed, 14 Jan 2026 04:20:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 084236B008C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:20:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BBF2F8B9DE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:20:02 +0000 (UTC)
X-FDA: 84330022644.21.798F33E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 92A4A80004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:20:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d3ZdCyWz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768382400; a=rsa-sha256;
	cv=none;
	b=m5cDrvith0XCer6GMT17to7O2R25bFlafVbZmL9LgwDbC70l1q4iUukjBVmaRIFTV+USZL
	Mmexut/10pY5IBLI6cey9nqPXfwciZdGkBgOIdKe9z6YTpvrxTM9e80c/+ZoN69bXvPWOB
	7H+uVtkfb/B0G8tFMHm0/dAdKBJnliY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d3ZdCyWz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768382400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
	b=r6pmlyzMJ9MRUAFGeu8GQNKMo3c177Btwum2lI9EDhsxJSILotOkeZee43IvlWicgLBgRt
	kGCiofNIDPy85pFeJ7/jheQxe8C64hDNNa5/fuFTk5aZAJEikEPFHT+ltg6I1F0kiKM9B9
	BVSVC1BS1z66yLzAVVtC4/9mcqwkwDc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768382399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
	b=d3ZdCyWzeLYlC3b7M6ZP2dXIWXY9JE0dma6Y0LkXR0A0eywMSlUp6WzhDqUx0iswyDu7ct
	vMeoP0xI3kokS08YKiYqWHPOkswCi3/5uOxfc3NMzBU3w7+zVYKpSF8VsPPeUUibrWiboE
	YL20tI97yG/qdYceUfci6aEDQyGXx4c=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-KNLfs1DDOIa4255Zydh6hQ-1; Wed, 14 Jan 2026 04:19:58 -0500
X-MC-Unique: KNLfs1DDOIa4255Zydh6hQ-1
X-Mimecast-MFC-AGG-ID: KNLfs1DDOIa4255Zydh6hQ_1768382397
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b7bf7ee0eso3381518e87.1
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:19:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768382396; x=1768987196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pe4kihdf5rzPSapoEMxkpwm+CiIoqdx7EKDwdy3eKBM=;
        b=U/7kjkpWvxOzf/GtP1ymzTxhd2xhC+BPekmqfv6s3X3i7Ld9gtlNQcGDYinghHlqDL
         1sqZWHabwXc3DSfHpu6JQrfNoUoif+ysIrSXWQTvLo+lHPH6ReKgcN04VRLsfMuj7MzP
         +SWfaIZMY9d2lAj2IWEDyUIYwGApwDzNn2T1j8ba5+A2DkLs/pR9MqqWGfAYua+jhHo/
         HuCIQ90RKdv9nV8EM1SX6dPgJSSpvSBVmnL+a555M8yh+xg6GLzF5bh3UME/TCKBZkw1
         9zvFxRRBYQpm2TF0v94qp+NoLEAtbJn9fF+zEvWOtK9sBMTGhj8o7gqv0dzz2Ly26dQN
         o2aA==
X-Gm-Message-State: AOJu0YzIRJ7hzZkj5eANc71wsH1EeaghR80ZINCl8mRzIcx8hkYyrqOr
	nxr//QJ9fZIzah7auY/cEzqMXTVEdpLkGxXG6+JMrtvvihd6/06SQNxMjnAOCEfzBrc3YirZA46
	xKJkzst1iKXNLL/TI2QHQLEgIJG/VuPA1ned1+Qd1lg8aEaQeiIuJL7fn3ej9cpdsZ8PJWU9abF
	trWvobUcwGwFiiKQnhzhtqibR6KI+sU6ynjak=
X-Gm-Gg: AY/fxX5Rtn7aIgfbu++TpGYlGqjCAlQye2k8C5TO/DRBZMTJLx5+r/yziXUndz3YfNZ
	IH8AinFZ67JB3aiduNpaTD2z4pFmM9UB68vwLawjPWgaqphj6h7aSJ6asvSiR/zKgxoDXzQAU8f
	Jv7tQ5u0IK4rZD6jGTwdl6QmpLxo08pE3N8qd0qUXRNz3Vkj9eOnbd52EW+FjadqKyffIQOSSSd
	mncQ+I9+dq4+pzQZyFHaoq1L7/Ok0OA0VVf/LmOjPOiUtuquqVFEtHaFOuZh1te9nASDEGQAlkh
	12Fehaw5pO8/5E89HB6+iKBZPW0eoxXM+9auyAZxwt0DSYznbEDOxr+XIehzZgyl9l0mSUHERZ2
	tji7PrCtJxNFbw+53IwqSpCTK
X-Received: by 2002:a05:6512:3094:b0:59b:79db:2061 with SMTP id 2adb3069b0e04-59ba0f76af4mr592761e87.15.1768382396473;
        Wed, 14 Jan 2026 01:19:56 -0800 (PST)
X-Received: by 2002:a05:6512:3094:b0:59b:79db:2061 with SMTP id 2adb3069b0e04-59ba0f76af4mr592732e87.15.1768382395861;
        Wed, 14 Jan 2026 01:19:55 -0800 (PST)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59ba1045be2sm513898e87.81.2026.01.14.01.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 01:19:55 -0800 (PST)
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
Subject: [PATCH 2/3] mm: add new testcase for the migrate on fault case
Date: Wed, 14 Jan 2026 11:19:22 +0200
Message-ID: <20260114091923.3950465-3-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260114091923.3950465-1-mpenttil@redhat.com>
References: <20260114091923.3950465-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Enp1XWV_Gu6N-gXGURyFFV3TZLR44Erk1wzyTM4fAGM_1768382397
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92A4A80004
X-Stat-Signature: k1xgmcz5ra5zsf5z4t3i49ed8cq4rii6
X-Rspam-User: 
X-HE-Tag: 1768382400-861271
X-HE-Meta: U2FsdGVkX1+2F7HVJB96yVTSWAQ0lkKcTjbNF3iaVLEpmiz93aBm+1GWX09wyIAi+TmBpK62vYaQ6jmYwgWJLYmAtJL3+46zGMIg8hmtHM1UM/ir5ZUhl45GV3mm4b9WuIyA3ZhblM/ofs0Iva4SSeBNSQsMPrqlDWB80Wwa0RSb3kvNumfWQMj7TBkTwpcH3ukgQMNT36VHy/0/y+Tlk/llZbfyeWJy+WhNuGbQZJ0pGkwXA/22Y8c5CbvUR8zaVI/9u4c5IH60Fvst24F4vfEc19KoR4vIOuCJ5RqomrVlril2sIljvjWTGm6mTH5JgoiCln+xpkVIwmm8TEHt/zQ5f2moyKDg/kAnwgS40fqql/OOBwL4NPCrGffEQpo99Sw/v46OHJh+tVCqYu4ID2mTGjFZALUgi3aEbSC/9dxNLTlcrzlCLeTzPZ8vfFB8a47NoCo6DhKXa1NxWRiueyMwJWVQiCSMD+cuuAuV05HObhSA4BgzCcTp6qrbX3PXV8F18DZlKf/kBhfw6cnDVRXntIS/B9p8rQRVZFY2veAjUXusdD2O9SKjR6VPXCIxYxqhWiztqGhaCRdCDTTlPleauTQmsaW3ifaOHLrzGwMaVn4vTCv2qhHGK044DYqoKJ2+aasaCAdG0DSXzWshlkOaamIK2ivMbuAyQk9ikeFg1DrqCKqkXWcrVoQkoBeD0uNF8yEYVy+VxuxKXuH3NkZYuS2+l47RF+5wfHZmFs6mFLUt3PUlpD3XgUGn/7toNFmED0lwoP0hdmFMzh+3/FlPC78HIRSvqzDohq3QG696S+WMc4Q3bGa/OPsKXK8N2Jm+7jq9iwzbKK7Ioo8EDH3AidfjX84J1lCmBpPNwwS5Mnu0IvkEkE3L9TyiSfCpb0CSJTxChZHojdWt/KIKK5R3DqOnU5ijMl1yoJBN2qfwv9bCnxiZigPiNkrlKZeYS/R4IEmYkoRFrL4V9of
 ineuXpu9
 bH9Xis658LlfyzY5Ithn+mzyJZYBWqLWJ0RKKLkUXdw3C0g/of8WlGpB4W3nVLtrXlXTKEt+qQUrAvO/zQeDkJURFyg0yC4mLWvrtAenbzD+TjFs1qQZhGfRVLpjUR1KqjO3GCPM1oNHC6iAk9sKor5RlAIbXN7RUbdzaL8aUnlBTaEnCgj18PDq/s2jH3YexRqCfvMzE7WM/35s6R53GJ9krvTK+4h/hAF/1zzIQJvJ+uUflZzWalgcMBp1F31xIf5/070MiH0TSuv2QsSfokxboy2bZWeOserPWv/XKi4aWllBfBm8Ym6tMUSibV8VjpZg0gfuhKmxm1Jwby21LXw1+heFrnI3iAA0Ai79T5Bt2A51v6tBzAI5Z67lFK3m1ba+AWRc8vkFdbY8=
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


