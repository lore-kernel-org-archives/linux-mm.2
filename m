Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78354CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD16A6B0088; Thu, 30 Apr 2026 21:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7496B008A; Thu, 30 Apr 2026 21:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDA16B008C; Thu, 30 Apr 2026 21:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3EC6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:23:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 423C61408D7
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:18 +0000 (UTC)
X-FDA: 84717095316.05.446BA47
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf10.hostedemail.com (Postfix) with ESMTP id 62C7EC0008
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:20:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=lkodVcL+;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=whyFbj0nqiCp1WYUzqSUPE+tBGDoPibJEA9HVyy+B+Y=;
	b=uL5uDiEKUHQ3wWg2OgMZpLN0k8brLZAi7NuLZotOpYN7NqSLtkT3svSHYvOonyzt+wUm9d
	MaLalhb87XVkKm2ycWZhIh60vDkVvnJcflWxMaoOZ2Qr0XUnfDiJPhY9XhNUVgl4jNzXn8
	lI8p0tl6eQefUM8rmZRH2eJu3yGRJCY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=lkodVcL+;
	spf=pass (imf10.hostedemail.com: domain of skinsburskii@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=skinsburskii@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598416; a=rsa-sha256;
	cv=none;
	b=Pbgl7y3BAChvgW33r7TQyIHoAPnXFxbP+yDD35qjTJXRRMJUw4604EEh2gdIpcKT4pCdGr
	C1i99FWIN71Cx35xtDMEZMg77g21srzOIE33xy6Sf/zX/p0i8pyjBtf6KBDBLTRcaS9yRB
	VvWvYNV/jmiM5KVSUK0gfMvyvwHUuVM=
Received: from skinsburskii-cloud-desktop.internal.cloudapp.net (unknown [4.155.116.186])
	by linux.microsoft.com (Postfix) with ESMTPSA id 60E8B20B7165;
	Thu, 30 Apr 2026 18:20:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 60E8B20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1777598415;
	bh=whyFbj0nqiCp1WYUzqSUPE+tBGDoPibJEA9HVyy+B+Y=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=lkodVcL+t7p5idRS70Ba09XCVdeZVg2RpAXmGDb+5a+dHbsTKT28hk/bVv0jufvAt
	 u9MoANAzJG4G5PMRJla9o12rvxD25aHBH0W5Tyy4XFl9a8vvWJmnGC7Y3QoBxOVKoh
	 wORQbJzWb1/BB8BKZWdCIdJRTQxRA6vLvRGjHtIU=
Subject: [PATCH 2/3] mshv: Use hmm_range_fault_unlockable() for userfaultfd
 support
From: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
To: kys@microsoft.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 akpm@linux-foundation.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, corbet@lwn.net, leon@kernel.org,
 longli@microsoft.com, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, wei.liu@kernel.org
Cc: linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Date: Fri, 01 May 2026 01:20:14 +0000
Message-ID: 
 <177759841468.221039.10642975915360903873.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
In-Reply-To: 
 <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
References: 
 <177759835313.221039.2807391868456411507.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62C7EC0008
X-Stat-Signature: cg4uiac8xjb6tdanweqjeqq3zw73au1y
X-HE-Tag: 1777598416-171093
X-HE-Meta: U2FsdGVkX18w1rurYCFZqITojBPnSd0KSgf9P1P7vvtNnj/TGMZ83vtJLYkEkpN6CWUkwSg6ZMmb+si0MmkNUzTEL/p+1I3KFJXy5nBG0QKEbAC/HbSPIBUNpnooKLOiYJWJOiI2y4oFoUS8XZb8O0BTyC/rYlxJs6KZJZBmckACDf6YGrxJWObDbE14k+jZypukRueB6L421YnX1Ia7ngwaHqwGWqtDeMcW6GJOwzk0ZE+cNx7H8hYaz6lsg5g51SRzjZIKi6fI8V/2789FdnEbWFFYdn65KQEzPwoioMitrtG/pwXzs1XKWDjJwQU+t3r4pnL5N+YobHgNMC91b6OW7DM19oZSrbk9RTRz0v74LAj0ZOUgJpQu5gbipXrg3aPXZEd8Xst4pqOf4HPE3L1OnZxFj/VCbMuDgvSqvs6CL/x+bqSYZ0+TmhrbACxXSajbMcVrmHfXOD9BoNHpz59/bv5j9Bmo/6uoTLDRhu1T2kAI90WBTPUqF+0X4JtvJ5MArPQsMuEZ5NRlEBGv00bsMdciRISPtQLDMOiO2JOGOrbqQIaY0puY70JEnDLbd5VNNeb3aNSZB8Y6JcNyfOblMpo/jrsxZIncSVb/TD9iG9YbbdkRC8+CXMxOMWeFsreXnnRg/qjOkM5zbn6TWWoosvgv6CMnK4AjJD6AOj162i+5PPnG0PENkdNUaFJlMruFuGuH3mH9qge3Ee5njzNIsQGBOTVrcbnvLpTaOeGVVPBXZ59GRefIrosPnxTDVB3EpZWBcM/bUG5K+dv46e6hFDYiEw+pIlkG9hbYeJIia3w6CiFeSDGb3h+DxAVadx18rrUOzlRUyytA1CVZxpwHc1qRdvsm+3yxL53+rBIyRQRetkAh0a3InBo7Up8yW+h6FokxACpf+3W5Ui3sUt1gyXv3bjYV0ylE8hWzdfbkvSqdxA0g8eSfloi8GhNcHIANQZv6POnPvNwNib/
 ZDI4KKNT
 E6ZmspuXeVmqaxxxoWLvmsKgWeMS84MvUOZis0VkUBdY/79+XcSTH3UtOQWWtRn3vZQv7S9hy4O8Ecg6J/cmJZBByei/efJ1BfqwxOZStuvpvQvpzLZvn28sSPSYB9+mCotSi0senDBb4qMJfuctAWCzol+CpLeVKphA4cCVAz58AJbjilNgPKppNjdWnnBKExoHHbiDtzPvJomIDaPOAtq1tEO0bRMgzG+P9tNyrzUTLAeFF9mcf59uh0rB8dlkLkXFsNKOnLh+smGluI3nERPnL+7q3WvnZJ1WBnHmjWLjv5AhhcdEDU8QUewpLQpIyIjsLPf8CK2JeN8kPG7ylOHPhfG+FAy+aUpOP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the mshv driver's HMM fault path to use
hmm_range_fault_unlockable() instead of hmm_range_fault(). This enables
userfaultfd-backed guest memory regions by allowing the mmap lock to be
dropped during page fault handling.

Extract the per-VMA walk into a dedicated mshv_region_hmm_fault_walk()
helper. The outer mshv_region_hmm_fault_and_lock() handles the do/while
restart loop: if the lock is dropped during a fault (userfaultfd resolution
or similar) or an invalidation occurs (-EBUSY), the function restarts the
entire walk from the beginning with a fresh notifier_seq, since the VMA
layout may have changed.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
---
 drivers/hv/mshv_regions.c |  127 +++++++++++++++++++++++++++++++--------------
 1 file changed, 87 insertions(+), 40 deletions(-)

diff --git a/drivers/hv/mshv_regions.c b/drivers/hv/mshv_regions.c
index d09940e88298e..05665446ca6d9 100644
--- a/drivers/hv/mshv_regions.c
+++ b/drivers/hv/mshv_regions.c
@@ -565,6 +565,75 @@ int mshv_region_get(struct mshv_region *region)
 	return kref_get_unless_zero(&region->mreg_refcount);
 }
 
+/**
+ * mshv_region_hmm_fault_walk - Walk VMAs and fault in pages for a range
+ * @region : Pointer to the memory region structure
+ * @range  : HMM range structure (caller sets notifier and notifier_seq)
+ * @start  : Starting virtual address of the range to fault (inclusive)
+ * @end    : Ending virtual address of the range to fault (exclusive)
+ * @pfns   : Output array for page frame numbers with HMM flags
+ * @locked : Pointer to lock state; set to 0 if mmap lock was dropped
+ * @do_fault: If true, fault in missing pages; if false, snapshot only
+ *
+ * Iterates through VMAs covering [start, end), collecting page frame
+ * numbers via hmm_range_fault_unlockable() for each VMA segment.
+ * When @do_fault is true, missing pages are faulted in and write faults
+ * are requested only when both the VMA and the hypervisor mapping permit
+ * writes, to avoid breaking copy-on-write semantics on read-only mappings.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+static int mshv_region_hmm_fault_walk(struct mshv_region *region,
+				      struct hmm_range *range,
+				      unsigned long start,
+				      unsigned long end,
+				      unsigned long *pfns,
+				      int *locked,
+				      bool do_fault)
+{
+	unsigned long cur_start = start;
+	unsigned long *cur_pfns = pfns;
+
+	while (cur_start < end) {
+		struct vm_area_struct *vma;
+
+		vma = vma_lookup(range->notifier->mm, cur_start);
+		if (!vma)
+			return -EFAULT;
+
+		range->hmm_pfns = cur_pfns;
+		range->start = cur_start;
+		range->end = min(vma->vm_end, end);
+		range->default_flags = 0;
+		if (do_fault) {
+			range->default_flags = HMM_PFN_REQ_FAULT;
+			/*
+			 * Only request writable pages from HMM when
+			 * both the VMA and the hypervisor mapping allow
+			 * writes. Without this, hmm_range_fault() would
+			 * trigger COW on read-only mappings (e.g. shared
+			 * zero pages, file-backed pages), breaking
+			 * copy-on-write semantics and potentially
+			 * granting the guest write access to shared host
+			 * pages.
+			 */
+			if ((vma->vm_flags & VM_WRITE) &&
+			    (region->hv_map_flags & HV_MAP_GPA_WRITABLE))
+				range->default_flags |= HMM_PFN_REQ_WRITE;
+		}
+
+		int ret = hmm_range_fault_unlockable(range, locked);
+
+		if (ret || !*locked)
+			return ret;
+
+		cur_start = range->end;
+		cur_pfns += (range->end - range->start) >> PAGE_SHIFT;
+	}
+
+	return 0;
+}
+
 /**
  * mshv_region_hmm_fault_and_lock - Fault in pages across VMAs and lock
  *                                  the memory region
@@ -575,11 +644,9 @@ int mshv_region_get(struct mshv_region *region)
  * @do_fault: If true, fault in missing pages; if false, snapshot only
  *            pages already present in page tables
  *
- * Iterates through VMAs covering [start, end), collecting page frame
- * numbers via hmm_range_fault() for each VMA segment.  When @do_fault
- * is true, missing pages are faulted in and write faults are requested
- * only when both the VMA and the hypervisor mapping permit writes, to
- * avoid breaking copy-on-write semantics on read-only mappings.
+ * Faults in pages covering [start, end) and acquires region->mreg_mutex.
+ * If the mmap lock is dropped during the fault (e.g. by userfaultfd) or
+ * the mmu notifier sequence is invalidated, the entire walk is restarted.
  *
  * On success, returns with region->mreg_mutex held; the caller is
  * responsible for releasing it.  Returns -EBUSY if the mmu notifier
@@ -597,47 +664,27 @@ static int mshv_region_hmm_fault_and_lock(struct mshv_region *region,
 		.notifier = &region->mreg_mni,
 	};
 	struct mm_struct *mm = region->mreg_mni.mm;
+	int locked;
 	int ret;
 
-	range.notifier_seq = mmu_interval_read_begin(range.notifier);
-	mmap_read_lock(mm);
-	while (start < end) {
-		struct vm_area_struct *vma;
+	do {
+		range.notifier_seq = mmu_interval_read_begin(range.notifier);
+		locked = 1;
+		mmap_read_lock(mm);
 
-		vma = vma_lookup(mm, start);
-		if (!vma) {
-			ret = -EFAULT;
-			break;
-		}
+		ret = mshv_region_hmm_fault_walk(region, &range, start, end,
+						 pfns, &locked, do_fault);
 
-		range.hmm_pfns = pfns;
-		range.start = start;
-		range.end = min(vma->vm_end, end);
-		range.default_flags = 0;
-		if (do_fault) {
-			range.default_flags = HMM_PFN_REQ_FAULT;
-			/*
-			 * Only request writable pages from HMM when both
-			 * the VMA and the hypervisor mapping allow writes.
-			 * Without this, hmm_range_fault() would trigger
-			 * COW on read-only mappings (e.g. shared zero
-			 * pages, file-backed pages), breaking
-			 * copy-on-write semantics and potentially granting
-			 * the guest write access to shared host pages.
-			 */
-			if ((vma->vm_flags & VM_WRITE) &&
-			    (region->hv_map_flags & HV_MAP_GPA_WRITABLE))
-				range.default_flags |= HMM_PFN_REQ_WRITE;
-		}
+		if (locked)
+			mmap_read_unlock(mm);
 
-		ret = hmm_range_fault(&range);
-		if (ret)
-			break;
+		/*
+		 * If the lock was dropped (by userfaultfd or similar), restart
+		 * the entire walk with a fresh notifier_seq since the VMA layout
+		 * may have changed. Also restart on -EBUSY (invalidation).
+		 */
+	} while (!locked || ret == -EBUSY);
 
-		start = range.end;
-		pfns += (range.end - range.start) >> PAGE_SHIFT;
-	}
-	mmap_read_unlock(mm);
 	if (ret)
 		return ret;
 



