Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1180EC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D066B00B1; Tue, 22 Sep 2026 01:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F53A6B00B2; Tue, 22 Sep 2026 01:35:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F746B00B3; Tue, 22 Sep 2026 01:35:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0E2E6B00B1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:20 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 68A681A03B5
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:20 +0000 (UTC)
X-FDA: 85240285200.24.383ACDA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3556D120005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DpxtELYJ;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rU6cW44LYgRUyAQrC4VYer8F2kJCybD5egmuRztFQqU=;
	b=X30V74RuM3r692MU7zSIbKrL21Nc6vche77HtyBc+7YYxiNc7i0Uf74jcJBJjQtO2NM8gR
	iUl6B4tx7XmmW05tuH2VUF0PSx0C9TAWVnzLxfof+1u4/Gexzv7gB/QmOQZMJWa7dYftQZ
	Er20pplx2mpJ9ZVaETD62reQDL6CbVg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055318;
	b=z/b3O6wd0NEOX5YCQhIbo7nQRyy3aJB/SVLZruRmxYYUMARRl3v2gHKAyJv86cY8t7A7WN
	vi3TzsWq1QKWUcuJghel5km5bw5HQQL8O++1iNco7w5cROpvQb82BqGy1VN5E3jUePCRNv
	soEqpQw51c9brReT4YtK9Ew7PcZD6aE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DpxtELYJ;
	spf=pass (imf29.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rU6cW44LYgRUyAQrC4VYer8F2kJCybD5egmuRztFQqU=;
	b=DpxtELYJT7B21wxeDHiu//xbzOSNEzV6g2tCkrybpLdvmwIw6ZnymmN2d3tQSlfz/Rr8+l
	lm4xDkx2qUJZGS20lxMGTJc8qWVn1qTiKowfW6q+U6so2pgzWxIu8k9SF4iqHa9OXOK/fR
	2yoejaOTTExVPvp4L59/tIh9r0qpvu8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-s4aiEr0QMFuWN6PJY89BVQ-1; Tue, 22 Sep 2026 01:35:15 -0400
X-MC-Unique: s4aiEr0QMFuWN6PJY89BVQ-1
X-Mimecast-MFC-AGG-ID: s4aiEr0QMFuWN6PJY89BVQ_1790055314
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3a468782b61so14482681fa.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055314; x=1790660114;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rU6cW44LYgRUyAQrC4VYer8F2kJCybD5egmuRztFQqU=;
        b=yl/N1HlsfkDWB4xB8QEFK+ZbF+Yw+Fdd/P3bcAXWZi0hAMUabhz2emZxxj2kqTmpys
         cmKxJMnoYNe4mhlzCCepmCELnY5g+SOSXjzJvUPM5pTJIUQ85jkBQH3CLwjivtvkVaV1
         LZv13hfaxlS2+v9+yvEf2Ld1QTBDpChv1cM9MI56vin+9gUQV/mSC163GRz2NebLfCwj
         5OPBZPwVnobusWvv/QmeXLr6gn5gr6hJ8LoqE7DClzaWbaWoDnQQGmXtT9ZWTHObqbDm
         0dDz5xdvx/cWXnogYZbR22jDneohgru8UzLa8P3bXittU5pHqPVpXprUhaJ+Vx3pBmLB
         QAUA==
X-Gm-Message-State: AFuF++mx7j0SJxGVSnhkK5QkH1axLDplis5eEoBJTl1x9WsjKJS/fJra
	YWsg5f5Gav8uoiXe4MIuUvX5jFmq5j/DAVaEuOg6J9Gdn+mDIF+WcOY/NHkXK0jhrHOqYze2Hy0
	7KCaTu2e7osRWm0wBG5WqevPR3SiLqLN+RH5bTZKvpZqdoz36yb5fT22lGZEKvGlyhy2KYSABPq
	sLtJwC++O3hxTXY51HNai/2x2/0snr60x376ZH5Q==
X-Gm-Gg: AYBFou2Cs1fzKMtCG4/Uy3i55RIZ0/iBO8oPji1EqsF6ZdsRlk+HMyqyH9b9AEwwgfu
	brJOWhgmUgUVT6zDLGSVjDDPaqU2gDOyIEp7TLXtd7OfMhYjKYH04ZaZDSoePINGoYHUbP4bupG
	FJ2l/9Kd8cVcISGK3jYp6GxEEPOMC47JfG0zSE68EYIeKhixCCN6YJ4pVLyk1dnzucqPZYSFJU+
	ngp6/+kpqKIi1W5CNNT0cdo/Zg8cIYRKF9CPQyCjCdLBXHyi4DewrpmGFDZs6b6QLaYV2MqjWVF
	25+DQtlSXms1069q8eEkmAfh+T5yiDLpk3FyG3fKRDqAIpT5pL+9rfV4VlZlU5883/FmErVPIJD
	WA2krvW0anNFVJIkMUCg7
X-Received: by 2002:a05:6512:33c6:b0:5b6:183c:5c9d with SMTP id 2adb3069b0e04-5b8c1958e1fmr3832825e87.59.1790055314205;
        Mon, 21 Sep 2026 22:35:14 -0700 (PDT)
X-Received: by 2002:a05:6512:33c6:b0:5b6:183c:5c9d with SMTP id 2adb3069b0e04-5b8c1958e1fmr3832800e87.59.1790055313530;
        Mon, 21 Sep 2026 22:35:13 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:35:12 -0700 (PDT)
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
Subject: [PATCH v14 11/12] lib/test_hmm: add a new testcase for the migrate on fault
Date: Tue, 22 Sep 2026 08:34:20 +0300
Message-ID: <20260922053421.4092027-12-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bYxZx7-gWX2pjO7MPq4Pl39mQTTdGB9a5YWZkznTUHQ_1790055314
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ro9rbbjy7nf3dfsxjgkxnsr44bsrsa8r
X-Rspam-User: 
X-Rspamd-Queue-Id: 3556D120005
X-Rspamd-Server: rspam03
X-HE-Tag: 1790055318-291991
X-HE-Meta: U2FsdGVkX1+IOk66nmTGHaRvqR8+isNp9u1ndkBqXqa5r1LBBJPsVdAPyaOLFMkuhI+MYMuYFdX5hotzpwlXamaBX9hieK2jSnh9UP3O9hGMLfOb40hJfsDLOadhqoIRal499KX/9YIkxRIVNOECfNQRJR3eQlggzghSGrcWJmIzZYi8ABrpuzMz9maSxj/Eu/QCYTWmzmlkLHMIJimvhDNTbeUqcRDRrb3linIh5tmI0t7JbEtxVM85OGGOg5b7gkaWnCv5CdTIdZzTf/+Q+wJhY/xLgRYth1kT9yg+noiJlkNMGAYIKZZpleBzr9u/HTIishYXKm2f9HwSIgGTwWzNZvFzu3MQd2BQus2esO8iETplw34nIb3aO8XEBX91VH7tdCdTjfTJq7NHbzh05W8TR46Kg+5V/jAV0DiEvnirt0GmS5Sc00Ny1yVtNT+30MQ7rgifwifJBoMFM9ve8Cj1oRdFMwNsuc7UIuYAL8Wf6JqNAQ6onommIiuMGb1RuGUjMCONvbwSm8i/FflutqVnFa+v01/F0ALldvHAS9LRiU9PhHYmLz/XXBsd/4T0S2XSHRN0As6pCTJMCKD14xsHzVg5HN31G1FIEcKWF+zOP3ScgZPYi5xmJcpyC5yu2NRZ0BMOUPRKW+W1+K+uVCU+qb0a/PkAr2Ve+CK4vLu90aR7ac638h6ob/fSlKhEvGL/esFiLXi7hhvtyYuqaD9CCRH0T+0qXKF5dROBioHJ4UmRvO7DBJaKUZFdNxspo/xZaNqVo4/Y107oJTwEJsnWtujczwi/P/cwMZCnNzO5PZEnyu0MmuhN4tkg2F2FJYTemT805XjBznLJSIi1K3VO/ubhDUBEusZCbCuxpT8hq35FekfHxt4j82LCSEElJAMM3HG6wUtwkup252aqwAoCwUxkXLg8lxg8tHZ7whUWYBjJctNFng7Kualf4IE/YVoG4JMAYIZvD18+C9M
 i4ZFYPct
 i8a38HgVmaFUtxUtI85OEp1sKaG/772Fh8Bh75Kc05M0LeNJeqdGcOnNrdC29mpvtK0BHW1+asUQxkti22OVSBQgB2ltMZR+dPinMPwe5WtnOzJ75qO2Rzcu9b3D2F3sIlk3lrwwB/dOL20m6v/x/byo2XO0PVffqw+yA803RuG35t8xhewsws2tcQ4lbl6kdRnGafrdXMEsVgqNJdXWkngMSwO2bO4swX2SIwE89P0JrfZNoFaSr5Tk87yA9tJF8oH815sjzrt42W3n2FUlAGNv8NIuT82kh+m/kKaY5m/jxgZBiI3N1S3ckjirP1/eU+EI87sQ+Am3FWl/WREmenu+rljPwPUkK8jlRxD7NejdWfPXWa7eiqsrfE2lsXCZTKukTF1+L/pNKywFrtuI0TiU6wWCmcjY3UyqQqszd2IX/MxeRreIILp6N3ttYUuvuTYalwzbOzbeWaewFsHIGZwD8h1ByaS2Pk0AqKjPoaDuoOA3ytbVP1QhCcYpZSiW51cfJII807Kz0yano55uj7xZKo9/2PShXg+Eh
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
 lib/test_hmm_uapi.h                    |  21 ++--
 tools/testing/selftests/mm/hmm-tests.c |  54 ++++++++++
 3 files changed, 191 insertions(+), 14 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index cd88e8177d0a..b39522c05d83 100644
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
@@ -1377,6 +1387,114 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
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
@@ -1643,6 +1761,10 @@ static long dmirror_fops_unlocked_ioctl(struct file *filp,
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
index ea9b0ec404fb..67d267a3b999 100644
--- a/lib/test_hmm_uapi.h
+++ b/lib/test_hmm_uapi.h
@@ -29,16 +29,17 @@ struct hmm_dmirror_cmd {
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
-#define HMM_DMIRROR_READ_UNLOCKED	_IOWR('H', 0x09, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ			_IOWR('H', 0x00, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_WRITE			_IOWR('H', 0x01, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_DEV		_IOWR('H', 0x02, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_TO_SYS		_IOWR('H', 0x03, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_SNAPSHOT			_IOWR('H', 0x04, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_EXCLUSIVE			_IOWR('H', 0x05, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_CHECK_EXCLUSIVE		_IOWR('H', 0x06, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_RELEASE			_IOWR('H', 0x07, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_FLAGS			_IOWR('H', 0x08, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_READ_UNLOCKED		_IOWR('H', 0x09, struct hmm_dmirror_cmd)
+#define HMM_DMIRROR_MIGRATE_ON_FAULT_TO_DEV	_IOWR('H', 0x0a, struct hmm_dmirror_cmd)
 
 #define HMM_DMIRROR_FLAG_FAIL_ALLOC	(1ULL << 0)
 
diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e2642eca0d02..a2d1b8f494b6 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -334,6 +334,13 @@ static int hmm_migrate_sys_to_dev(int fd,
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
@@ -938,6 +945,53 @@ TEST_F(hmm, migrate)
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


