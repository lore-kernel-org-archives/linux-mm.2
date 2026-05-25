Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 791DDCD5BDD
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7E356B009B; Mon, 25 May 2026 04:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2EFC6B009E; Mon, 25 May 2026 04:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF416B009F; Mon, 25 May 2026 04:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF256B009B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:45:58 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 799A41C0C2E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:58 +0000 (UTC)
X-FDA: 84805309596.29.6A2D0B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 384ED20007
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:45:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggsMS7mp;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779698756; a=rsa-sha256;
	cv=none;
	b=1drIJLt8WT8gROS1rK23ygPlO//uRkumMsIttUTRGt9/P5rvbXs7COniCjwqA0+bEzWBzn
	aX1kNRlNunyft9XbLmjzzNFYWmSdflaogUjkeJqEBFXZklTtT3wUU/ZKM2zDERNy3P7Faw
	LoIidvLAn9NKmUxkv0kz9OXnsX89zZU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ggsMS7mp;
	spf=pass (imf31.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779698756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBIdZie6RpIvBk6Y4z+QSU0EMts/JP8b+GhZQsswjNU=;
	b=Yjnl3cLikls8AEd0+fZwBgk3DpEszIgXlFFYlA7UHPWjSJVOUWVSPj5nVP6ytBPg2VGJkw
	4Mw39v0xMdlx5E2f2t6lmgJP9HLOD75ehdOQftk/zjU7EaXSg4vGFn5u+gnHV/xHgxUXnv
	wG94K882kITBdf4wwxpt19zXPymA158=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779698755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rBIdZie6RpIvBk6Y4z+QSU0EMts/JP8b+GhZQsswjNU=;
	b=ggsMS7mpR7SF0/osTGRlbd1wW/surQgPEbSdjkBM+ZWJHag9RGCmX9mUOEGJRI3R44cF0B
	shPktIqMDk+xo2lhvPS5+BEyejwggAhD7kjjlLURQ+Guz4y5ydsY9dNDl9YpEvUMNdBZD9
	42yP+IBN1d5NKKWZbPLIPbiHUd8N3rg=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-R7VqaABiM32NQdv0O6NM4Q-1; Mon, 25 May 2026 04:45:53 -0400
X-MC-Unique: R7VqaABiM32NQdv0O6NM4Q-1
X-Mimecast-MFC-AGG-ID: R7VqaABiM32NQdv0O6NM4Q_1779698752
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-393964e2aecso34601881fa.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 01:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779698752; x=1780303552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rBIdZie6RpIvBk6Y4z+QSU0EMts/JP8b+GhZQsswjNU=;
        b=HhkKO0wO6rA5vRRSn4E8cJiDPAVuy7pwae4KxYSG0qpRrqOxD4FEDDAAxtmdnQSRnx
         zKH3X1u9JY6q5q+OIxfnINXn7R9ECoLF5hzVWPpZVE/2x85Y5oWZnIH1IXm66iKZ44Eu
         M0OpFurdyu/yl48dBya9MlFzFEJ/ltyZRjywdn57xZkxzCXB6tZC13KW/8py933gqsZv
         RJcNgKYw3hcc/qJz/97d1zc3LkWV0/8j+t0CNr06sFXLtBYi6M0n/WMPTw6QlgFakl6f
         DJsApkp9RVJLByXehKQ7T71K5wqFcCMXNQRFC+TRA5qDRtXErz4sNKcZ6GQRFOZNkhtf
         TGYQ==
X-Gm-Message-State: AOJu0YzF82JJwccZOeITIuWQv0kGXbJXGqzpaThcbdJYclud7NS8sNL7
	/hJM13G+CFrcu8+i3EwLigPEkpTduOKSaF0PQgInppwzTWy2C5pNL1sjrOeFR1JqH9cI0jB9BF5
	lb0/d9wZ+JTV+RukZdHbyY4O5P3X8KRFsEO0LVNkMa/Vn8qO3WYBX4q8lDzgGBDBl5vMTgp4V0C
	9peG5lK3XWiWS4AD10RfOtxisLQeY7uIPH15PLaQ==
X-Gm-Gg: Acq92OGsg1g/KLgIXg+SL/tNz+f2DMd4ca+crOBbaVYByRI1+Dw1gBH8b5apk8VK/4L
	cgcjQbS085XRoHDWixtofpmNt9PA0cHbc+x3uc3/Ic1aJwxN8+PJNMHIPsmwW2vkfv0MxdgIztg
	4XibJPuNeM0R/ZomkG+LCo45rnao9NseeUdmToZe6ZBraGR70v4sgHHweykPjMn/G88cV2MJptD
	BTWCkpdOZYvo/86v8ybcnkuCR4JEjdMn4Jfn0mccB4yiq8JW4wqRGA+E0sQ88nB4IStEzRPQ0Ox
	b0CkI+nmLb+sX1Z2Y2vvxIBTNxb7HJa2FebB+Nm5KIk+piqO2JPR177RoYYxaLnBXtMWbFgMWga
	bnywk3qFfuoXh4LbCa/9AyD2lVGdqHomJflXz
X-Received: by 2002:a2e:bc1d:0:b0:393:5c4c:c482 with SMTP id 38308e7fff4ca-395d8d54765mr51455181fa.29.1779698752232;
        Mon, 25 May 2026 01:45:52 -0700 (PDT)
X-Received: by 2002:a2e:bc1d:0:b0:393:5c4c:c482 with SMTP id 38308e7fff4ca-395d8d54765mr51454871fa.29.1779698751572;
        Mon, 25 May 2026 01:45:51 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-395dca7bcddsm21679061fa.16.2026.05.25.01.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 01:45:50 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
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
Subject: [PATCH v12 5/5] lib/test_hmm: add a new testcase for the migrate on fault
Date: Mon, 25 May 2026 11:45:24 +0300
Message-ID: <20260525084524.139868-6-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20260525084524.139868-1-mpenttil@redhat.com>
References: <20260525084524.139868-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DytIpZrW0ZwwD0joZ9qgFN6coWIDhpwcvjpFjA-iTNE_1779698752
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 384ED20007
X-Rspamd-Server: rspam03
X-Stat-Signature: fngoudtgs14xw41m744u5j51hu5f7gok
X-HE-Tag: 1779698756-496684
X-HE-Meta: U2FsdGVkX1+ypgfyFw20nWizelkd90EklXMoVHt3oz0RRb0eO3R4oX2Bl9lZZuKu4XQXFDJaiN1HAK7MPl+5qxU7mjxvPR77aCFqGPMkoV6emBoyMrYVQOM8aKlbal4tSB7i+jEZVQJwJ+O93yC6gNld6Zz/VD8gff5lBOzm2liW8UDZfKgqY/v8xmR/L6XpEhPI3k1/4f820ac3EGtq6NoiH8Gl2UbT38zl4DJcHrPOdwfYNhS32ZIEqCwZ8FXsOhIi3bGRd8EIMcDE5ImsoHcpDbeCyfCiol133g2pR8hM+IwqiVRgiJV4c2ibanCy3USsqBaaRb46c698dgiDq9AdumHF/E6n92IU4pOkL7VGk9X3UbS+IIL0ONTF+TSwoY/iPqprE0xcD0TiE833NE8GyB93cXvdmu8z+y9rrzp7c0FjY3zzB8qfNk10uvFU3b8DRs08tJg4qXJqMpMfvYPRteUT+9mVYNR60i4JgMloEh7hTR6MX7hTrFq8p/nKJ0O9AAbtG9rstSOFb9MG4jcjhQZUdlqmJycubuM5i1OMca+hpBNdHRmtYMwF0cy1MUosiWE1csFcm6tVVHSvRgkm43OXGnHYLzwxdo75jseU8QVXGN8eCT1rJCfQo/pIh5ZZzPNM7PHUxXxSsN5J/2sgXk2arCFzV4SMiXvU65nJTtHrQcbDl1Nhqe8eF1MxP7KcBZdrc3VBrQdFjtUDJGDds+wyTu7bTK2vHtl3LvlJSrR4TBMhQwfc9t6d1pL6dn+3H0f3LnHIHMfEtmUzaXXq0RI+4JHoM5o+aa2jjQnzJr2hJS2zJF2+5sAJGmli////oUahR3iDHnX9XJIgwXJW9jLECcFRzgBV/4vsnxE2hcQuVqUKTUmtqOrv+h1EZjW2DRXa3lMImGilncWMvl34Ws4inu04cyCQvylqWMd6/7dX5Q5/GxIMMdSGs7whJ0NAeC5ptoFDrg8p9Zv
 2RbsBZHr
 zUVoSkyyxmezXGs8loW9zENg8gou8QncmBpYXmirjAtqkv7azwJXyW69XLeeWH8ew+37ll2MZcKPpKjxOKMRCkNmU9X6sCWPAAl4PEYCnMogDj8qA6Zt3//1LGmJQV6ZHWNcRRiksVqqHBO+VItQe+86yQNXq9XNK2tgnLctaaEbC8RrSZtU5Ccu64ZRdZVg7vDO1R0zAmfOaIJ+oOJ8plVqfyhrmv8AKU67lH9z7EpSlkyOjZh+vyuIkdczIzkIq1Iqvt2UDdvZPCCDxLLbS6TQf6kclrY6q5xmqnIEiZIN0BH+r9xAE3yPvkj4/WplmWauDK4R5cprrR5mk/mi4+zFxxX9iIOtyudt+WhX/QS8SKFzERy5ePU/GjNwab0V3xlBYvz6Au+4d9xLb1t+lxWcndKv2Je3uEjJWKnd7/wr5BAR98zKH+ZtUCfsk0IW2QuZQR5+1m/Cdw365kJoDVE5Iq5PKTbz8uiEQDs+Fhqz4ETb6Km2udJYIyowzCKrQw9a4x1RZkHh3vr8HFGpCCXlRQX4onrcCLyJiNoWmEpPPz8467ZGwLWratcUegwR+pEfRshMu2QAh0H9mlZ2YpV7w+A==
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
 lib/test_hmm.c                         | 116 ++++++++++++++++++++++++-
 lib/test_hmm_uapi.h                    |  19 ++--
 tools/testing/selftests/mm/hmm-tests.c |  54 ++++++++++++
 3 files changed, 176 insertions(+), 13 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 1a3e21325cf2..d45666b51f33 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -36,6 +36,7 @@
 #define DMIRROR_RANGE_FAULT_TIMEOUT	1000
 #define DEVMEM_CHUNK_SIZE		(256 * 1024 * 1024U)
 #define DEVMEM_CHUNKS_RESERVE		16
+#define PFNS_ARRAY_SIZE			64
 
 /*
  * For device_private pages, dpage is just a dummy struct page
@@ -355,6 +356,7 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 	struct mm_struct *mm = dmirror->notifier.mm;
 	unsigned long timeout =
 		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	bool migrate = range->default_flags & HMM_PFN_REQ_MIGRATE;
 	int ret;
 
 	while (true) {
@@ -364,9 +366,15 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 		}
 
 		range->notifier_seq = mmu_interval_read_begin(range->notifier);
-		mmap_read_lock(mm);
-		ret = hmm_range_fault(range);
-		mmap_read_unlock(mm);
+
+		/* mmap lock held for whole migrate on fault operation */
+		if (!migrate) {
+			mmap_read_lock(mm);
+			ret = hmm_range_fault(range);
+			mmap_read_unlock(mm);
+		} else {
+			ret = hmm_range_fault(range);
+		}
 		if (ret) {
 			if (ret == -EBUSY)
 				continue;
@@ -382,7 +390,9 @@ static int dmirror_range_fault(struct dmirror *dmirror,
 		break;
 	}
 
-	ret = dmirror_do_fault(dmirror, range);
+	/* update device page table after migration */
+	if (!migrate)
+		ret = dmirror_do_fault(dmirror, range);
 
 	mutex_unlock(&dmirror->mutex);
 out:
@@ -1258,6 +1268,100 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	return ret;
 }
 
+static int do_fault_and_migrate(struct dmirror *dmirror, struct hmm_range *range)
+{
+	struct migrate_vma *migrate = range->migrate;
+	int ret;
+
+	mmap_read_lock(dmirror->notifier.mm);
+
+	/* Fault-in pages for migration */
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
@@ -1524,6 +1628,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index 77fb4c5d871b..c8d6a3c33ef2 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -278,6 +278,13 @@ static int hmm_migrate_sys_to_dev(int fd,
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
@@ -985,6 +992,53 @@ TEST_F(hmm, migrate)
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
  * Migrate private file memory to device private memory.
  */
-- 
2.50.0


