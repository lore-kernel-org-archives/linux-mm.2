Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29035C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 04:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6E36B00D7; Tue,  4 Aug 2026 00:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EBF6B00D8; Tue,  4 Aug 2026 00:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C686B00D9; Tue,  4 Aug 2026 00:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 558A36B00D7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:27:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1241408CA
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:48 +0000 (UTC)
X-FDA: 85062303816.16.2A4DEDC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id B903E1A0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 04:27:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aIDWF0NI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785817666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvY3DG2kuXvuZDjGJcBo0Sva6rHYNngOo11VFCjg+Yg=;
	b=TWudYyEKaRM74bZUoRVkwOJeita0C0KfFKknV8Gsvg9ukAh+F4xSJLqL8a8xgh0mCVfIUr
	YkSf46BdkiNIpvAZeRTmktHtwmynj+MJo1Evb1jdiW+sOysoyPWDdbW9+/5XTwuK+QOGlC
	EMm2CEiswqNZ35mrckCdHCi1JPEX1Nk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aIDWF0NI;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785817666;
	b=EFYQFaVQbI0U1lI1wjc3RnGG9UdwQyIaOnp0AXJ+LTsqOdt7LkCaK5THDwcqmPYxUeRw0V
	r8EHOi8mbAjPYUK2dRxbcW2wWfmg9qeDH/DmfB7uwLL9TDenXKhTPaTaFMemGiQkVX9Xpm
	PH5tlJsjTSkAXITanKBhbijgtWja+RQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785817666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GvY3DG2kuXvuZDjGJcBo0Sva6rHYNngOo11VFCjg+Yg=;
	b=aIDWF0NItJT4ciChO3c3z8DQqwh5uvrUAeVA9D5h8YSmI8EWlJLTRrNF9hWKRSPTNYh2+c
	NoaKaJ+aIlPyUa2kk2BlQZme9mQ4gYhDmxB0tHaV9Aq66f0p6mY99oDSZ0TKRQ4Hwlx0Me
	TKw/NjF/COyu2SS6OD3FBezIg/tfxqc=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-YevR8nO8Pmq_rdLr6pNtIw-1; Tue, 04 Aug 2026 00:27:44 -0400
X-MC-Unique: YevR8nO8Pmq_rdLr6pNtIw-1
X-Mimecast-MFC-AGG-ID: YevR8nO8Pmq_rdLr6pNtIw_1785817663
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5b291a1420fso3180785e87.2
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 21:27:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785817663; x=1786422463;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GvY3DG2kuXvuZDjGJcBo0Sva6rHYNngOo11VFCjg+Yg=;
        b=JiZnTHq/h1Cavuq74dnalRU17gTSm8g2u4jjkLbxMVEQXV1m77TPHS+NgGf5UfBMeO
         WbrgiW9yucoird+SoGCDHQGQPFskFrikKxQvAHjatPQD2854qq2RIRJhSAwXwW+LQOJN
         qbtfWNmZv/1+zVg2GmH1AkhM8ANcjRZnBYLhe8zndkjA3yoHdUc45Iwy0562IDqyPTez
         A9Ese/khx9rRHei8Bonh4LqmV5+Zli+sKFSavSBLYxbvvzowWvdOGJ5ZN/cdWHK4Piui
         NjCeD49nG9EaoExYtPKxIJwZKgRpf2sSQQ9A2bAo7BXCdcUd4rEczbh+OZ3kFLfCdQZJ
         3FHw==
X-Gm-Message-State: AOJu0Yzxbi/7w4OfHX9svLpPT35fTqMg36uXWAc9Bb+zzrhJgjqCUvqg
	rra/Dv1hUwXaIkElYox+PuX0UFTW5a3IFZR4m8mwFaZU3seU3yNDPrnlVTP+KL6mRM59PNIMPir
	0dJacGwfYdl2LQMM+LPU0f3CZiUQgwixMvW7yrf3n97JjSpo+Jtt7WfK8+QYNVHljsClDNJIpGy
	Zh2gN1vzne9cuUVWEIIGeMiir4+CLAQQHBo6UKpQ==
X-Gm-Gg: AR+sD113zxqJdSrrwPmyz0u6/dp+UzEwWcoEJ0Ikb55sJPfZ0GF8xKwfRzjX77TJ9Pg
	qOfnji10vJprRtVoyevbBuV17ICtwtW7H5oio+mKZULvtwtDoEJEJIstAMOKJNigVF3c399SCmX
	rfQOdzzTnXyxD5DMXCjsmJXY9NoVX9s32aLHojaRt3kVt83wRZkNf2Zuz5p/FVtxosfW48vgVzg
	cixf9CQY55czqnc0T/hau3kxpPMsp8VmuZKxvf2b/j0O9g3U0p1b6cYTqsb/5rVRXBTujIL5RnL
	a9FOrWjduvnG8NYbKnOb0UilJ6EbtmWxwBIfhadwhtkgS/HNjtmE4297jTe1aDv2XCikBM6XVEy
	Iugxp77HElTJckKGk
X-Received: by 2002:a05:6512:3153:b0:5b2:aaa2:1d80 with SMTP id 2adb3069b0e04-5b2e4f8415dmr1510656e87.47.1785817663193;
        Mon, 03 Aug 2026 21:27:43 -0700 (PDT)
X-Received: by 2002:a05:6512:3153:b0:5b2:aaa2:1d80 with SMTP id 2adb3069b0e04-5b2e4f8415dmr1510633e87.47.1785817662567;
        Mon, 03 Aug 2026 21:27:42 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23c46c4sm2311351e87.17.2026.08.03.21.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:27:40 -0700 (PDT)
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
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marco Pagani <marpagan@redhat.com>
Subject: [PATCH v13 11/11] lib/test_hmm: add a new testcase for the migrate on fault
Date: Tue,  4 Aug 2026 07:26:31 +0300
Message-ID: <20260804042631.2175585-12-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260804042631.2175585-1-mpenttil@redhat.com>
References: <20260804042631.2175585-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 37aU2JG0NB5ePWL9ndKEsB6BO_d_Dq7Sor_qqww03GQ_1785817663
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B903E1A0002
X-Stat-Signature: 4q97qqess87gss1xsh1t4hd1spsi9osj
X-Rspam-User: 
X-HE-Tag: 1785817666-977208
X-HE-Meta: U2FsdGVkX1+2nN3VggDHmhxi05iXUi0YsiasMyUTXWPeiDpgVdtUiwiDgaVN3wVWk29t1aDtIrKpQJp8yShXnm3uhdzarh9vtNCSkIULKNOjkj/p9UtbP9oWRhDIy10PbLmCmG3BbC9XewcPZ61BBP9nHg64kgvihkif7N+ZhGvNNzCY811Fr0x2QyAEoBpDsS4xYeEa05MQj+/Gzg61W3vPobl3IvOKRAuEi9tMZq24pDhXEnaS26j/p56eDmocvfNRhLKUgEOjcNHu/vE3GrELWOKcYNsHaJDwbPfVKiEKi6FmHJKFogCyObCSoNEs1SdrqnfY8Dn5DACRyKB7tj6zMg75nAAYH1LdqYkcMMtJ4/aEHBc3eCv3Sryqywez+7ZG2MhpaSdIytZU1iLPt8TQaZ9FbfDYIQrAFVdBcSW88YEh8rxbHTJ7Q+Y9pfsJ9BJguekGMW1Ttp/9OBWdpFRit2EVEIbJcvpU1QO5b8hsCFpOcjzm830L/bja1lnIloeIaxww6Xs524SRhCqJM5wfpzrMp7EC7LPPEXsjZOCqn9+t296JU2bw0Kl3KQxp3h1NbfGZ2cznkZI3F3LB+VBaxuZyh48LH5ql37v4iILTYDIuWtxzwJy4h1vLo1rdG7ky7fJSnIyYNMjwUaNPYGdY9USW4Ssod1js/rkX6txCWW5PRoakL++9PnERynyHxQYGDmVVFCdz65xMuzR0y2qxU0WvQz/s/ck0lmclj1Gb6yXKOFUr6a7dspTp5uBx7SoNh1MOwuF2eU2ActD6zxOgYtLhGGC4dj+NLGhsUTyNLfN7MdcJ1/QbjdsVK/T99bbGRpURAxWYBUl5tHeOUo8vwdGPD8nLiOYlo3XQWLFy7Z0fVsTSjF8hcnbBQiK0D7QZPED7LYkXVPeg75SBE7+aESYSk2MKkyzUwyrBU3TpFWaP0sima4PI0heESiCouFCNc0tKt0xQmcKtWF7
 ui4V7nnA
 0kkmrAZS2k1YRU9iOVVKfMv1MXTcUcySgx7z1vPV723s+rH47hytMctmH5BR0Fu/247Aa/R0BD3l0HcS91pLERt3ucTb+nS2PTnYeZejytct/fGhGHhGsoPhwlANydOtqqYx6U7tYdSxDriAbu+3QJvqpqQJUS5QjPy7X8j/t9j7fQOFVZyEd/tW+LuC94uQ9b60UHMJUbAfRrxONnLDGQUcxzg5f/6eAekwDTgrYF4MYMFXrFkI9Ui/Sjkbuuzoo4S5DGLAiWq8VRG8DpFdSU+fYncpkIk/wcnzLiOLSK7bCfHeGf1q66Y3JY97KAr6TMU9sBKdP+cy0wcWo2VUlFUDs5X+x16YOvGvZlwZJdixk/XRFE8sIhEV1zRTGCI7dJF7Zhe2ARxTn6KqGLpU+rCRSyqU3agB0CrkqVRhDboyswRM05ju+fFgkc/KQ2HO56bNza5NefRfpt4QPNonn1R+3EKbyic4NICzmC+Sk4GBhEpdRHx8erIi/NI37XA5JmR1U2m5Wxk8TLiwcRMu5/Gr9pkYiDKgHi5i4
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
 lib/test_hmm.c                         | 130 ++++++++++++++++++++++++-
 lib/test_hmm_uapi.h                    |  19 ++--
 tools/testing/selftests/mm/hmm-tests.c |  54 ++++++++++
 3 files changed, 190 insertions(+), 13 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 79cb7487d211..46a83e0cb709 100644
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
@@ -1281,6 +1291,114 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
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
+	/*
+	 * Set this up even on error: hmm_range_fault() may have collected
+	 * part of the range before failing.
+	 */
+	migrate_hmm_range_setup(range);
+	if (ret) {
+		/*
+		 * dst[] entries are empty, so this marks every collected migration
+		 * as failed. finalize then restores the source mappings and drops
+		 * the associated locks/references.
+		 */
+		migrate_vma_pages(migrate);
+		migrate_vma_finalize(migrate);
+		goto out;
+	}
+
+	pr_debug("Migrating from sys mem to device mem\n");
+
+	dmirror_migrate_alloc_and_copy(migrate, dmirror);
+	migrate_vma_pages(migrate);
+	dmirror_migrate_finalize_and_map(migrate, dmirror);
+	migrate_vma_finalize(migrate);
+out:
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
@@ -1547,6 +1665,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index 2f2b9879d100..4ac17cf6f866 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -283,6 +283,13 @@ static int hmm_migrate_sys_to_dev(int fd,
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
@@ -990,6 +997,53 @@ TEST_F(hmm, migrate)
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
2.55.0


