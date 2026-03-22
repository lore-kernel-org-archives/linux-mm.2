Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6ABDFC72AD
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 05:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5409B6B0093; Sun, 22 Mar 2026 01:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5EE6B0095; Sun, 22 Mar 2026 01:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C7D6B0096; Sun, 22 Mar 2026 01:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 14E366B0093
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:43:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ABB468C32F
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:24 +0000 (UTC)
X-FDA: 84572606328.12.8919D5F
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id DEEB0A0006
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=roRxo4BK;
	spf=pass (imf15.hostedemail.com: domain of 3eYG_aQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3eYG_aQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774158203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pyZbVSMoPQsW5Fww5l9TjItBhtVQ4rSW6pB2FXRdwC8=;
	b=vrhkEsJfC0qz/1AcJjPLTMFAMyY5RMgp9kXT/ng79huSLy3h4+U6ez61VhkNv8tKJYHmYG
	pspIlihH3Az1NfJqeGDx8Dabue96IOjTM87I3u80cTlE+XTKgkVMxJU4cdYzkZdWq1sg/3
	YXg97jYblo/qXtHnaIfnpuqqFy5JNak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774158203; a=rsa-sha256;
	cv=none;
	b=Q3awTT8d9Wstmm33jJR+ga5BA1Tf4XAdZfdfgbpJ5Vf6Oq8JkMGEXWS1MCWw1IUjfZlXUr
	ylKC/BKPSuoytaE3GwJWQNR1XfrvcjFAZf9CrOtM7WdEc+aXiPapv0iHLoZuLRBj4swzqL
	8+bU+aLBOdBG8MUAg6zCVRPq/i6u74Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=roRxo4BK;
	spf=pass (imf15.hostedemail.com: domain of 3eYG_aQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3eYG_aQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-1270dcd11c1so2891467c88.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 22:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774158202; x=1774763002; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pyZbVSMoPQsW5Fww5l9TjItBhtVQ4rSW6pB2FXRdwC8=;
        b=roRxo4BKnCpNx//9IAMQln3Y9lV3w+ijDfdoudhBlMhZ6UqdF83KZug524NrS2vCqL
         TnqHagwQZ5sCtj3cuQAeLLkrfvbJ3PbulMGj03nrnOmSS9KN3ulO2zDZEdTRl600f//f
         KY7dxSjam9YBpdTJEO4BcXN/W3DR9MCNlZgSUBE2+YcMfMu4j8K+4AeDDEm+y41RHyMh
         Hf8B3PV+i3xcwAUnA2Wtei8AGAU5YPTQ5TO7sjEoee1QmVFMhp8Hnqilj30Ip7U5Nywl
         dx/UL4fmTNvYYmAelmI32zCMsHCSZRQ+kxFCAAUBLRR2UoQJs35Nm/8eTq3nHmW0d6tq
         j3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774158202; x=1774763002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pyZbVSMoPQsW5Fww5l9TjItBhtVQ4rSW6pB2FXRdwC8=;
        b=ET6xF/2O3pGuhVGqgc11+YOwXDuFT1EVOJpyxXV02wZmRngmwlu4kqG4ldvNhHntNn
         hzv/GkJmjcbH3tcHM8MKwW4DtwH4Ft0Mgsq/P3MGaHhKno/xdBqsAdZBk1ddGyisHNvc
         k5ngijuWdmmsOYo7bCannGyyCfsijGnZMHYsY+8gIcL+uFp/0GOZHSNwqijsKSgLBdL5
         Dp9SdBP6dMEPFKLmNOxHlmPtZjfTKpm2wH2laRtSX/RkoGGiJOdODSb/RxD60PeIeb/9
         UCPzhwpSUJM95WEjGZQC0KP8Lbr69dOVv6U7m1JHJt0yDHqCf+8mvBrAPF5Wn48YjAyX
         YfZg==
X-Forwarded-Encrypted: i=1; AJvYcCWcpYD1G4kvXdIBtMUnitk02XExnLL1z37/zMYq72NLdLe0WNobCiVgOGDV6X4f6tYd5FZIEkkLhA==@kvack.org
X-Gm-Message-State: AOJu0YzueWkqCYTrhmiY6BVhLpgFxpIqlUSERMUJWrmwhIUfA84WzF8V
	IG4I9RH9wZbsrjWp6WG6hhsjOfX4ki6Jr+/Tqn/mX7jAYP4SeHS+TW2ZPUiOlFpa6XIhwmZ+f7c
	hlbGS+w==
X-Received: from dyx25.prod.google.com ([2002:a05:693c:8219:b0:2c0:c743:7f67])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:220f:b0:119:e56b:98b9
 with SMTP id a92af1059eb24-12a726bb993mr3455319c88.32.1774158201439; Sat, 21
 Mar 2026 22:43:21 -0700 (PDT)
Date: Sat, 21 Mar 2026 22:43:08 -0700
In-Reply-To: <20260322054309.898214-1-surenb@google.com>
Mime-Version: 1.0
References: <20260322054309.898214-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260322054309.898214-5-surenb@google.com>
Subject: [PATCH v4 4/4] mm: use vma_start_write_killable() in process_vma_walk_lock()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: w6gpiy5dh6f1i7ropnuwzm5z5qsozrag
X-Rspamd-Queue-Id: DEEB0A0006
X-Rspamd-Server: rspam03
X-HE-Tag: 1774158202-305315
X-HE-Meta: U2FsdGVkX1/f7yYS4r/pa75LwwcGEpAh6HzXoqJqdeVDcN+9cQtrOz+PCyxp6wO8iuhq0QHIbpr3awpN/HaYCrsxwXZ3rQIo5bk7cLax+kCwI5GzzHY7hcwVckDTFcSt2KRc2Hy8Z9a5b4ZTiVAelNOItIb+XULPjWafanOBeAWPX1OSvi086KqPsuwt9RBrnDSN0wNT/nlCoS1Zh4Xczh1jO2ut+/j/U2yXyoDIB+l1HtpK4Zad7dNasq+jtPzOpi2dzV/9yLuChA+cT1xTI8CrJNqnges96zNovqoxLHoBSxhEgQrbH/SQKlbK0OsgYFhjovzyQt3Dv+JMrCopYFUVJE7Vl55B+Pb4KMJNv+aE4CZXsaxvXvF6gC5kNni1VeVKL9Ne0VeE/7N/MIIINVvnk65sG1VR5/L2iNs/5V53JHFxnS2FZ4kmJaUej2iB00f2N3TlzPS4p01ZKvrxtsPTxwdtQ2S4u9vSczUz5dfe/jhXg74rhPXnnu6QhOGvNHFb6qaL811X/jEIl/Zy71YS3Hd+UZXzb3Uqv8BIBMCEvy82tBIe/ckH66dhC0zyaSB7Ndz+Af6OvRouUK1/ZeKNjeFcAqVTyJAlAs4M8g9txNkT50/LE6YZUY1K0g9hqYY1DIecVaoxXVSid6WCtBIyUX/AEniWEb9laiTzRxVSimErFLVOGCIJI61pSgji1H5lviXdC7o8vhGvbOqr62v++fxwTuOS0il0y0+QD8lY2O4wLeZkV2PhUufML6b/547OSgQ/+6VVVNTixZ6YBwJTT6pbNXBoWppbN5VasP5hiKHKNgANBGM55SEVK+faNrmAzePxGLI+o0ADJGZ0oZDRKg4Kv1qsykicKTXOHJAueocIthmQW3OVKpDGUm5ApRNvwM7ODs6GIbhR0gt6+lcyEOJJ+JTdBqjgsWuzbngJNAdz54RuNsYZ+0yWXz9/HUujefDYYfUiNdF7i/d
 bzC1WQC4
 yO+4t+/RcYTMYUIij8S10PGrEVR/WFSc2AViqsf2lElYi55FkiIFJ9fS58f6laWE1ioWjKGRw/Dsif/7RdOgZew3Aad1HKH38ZlqwU66cSwwTqtJN6gwiU/46ob4vyS9eRik9VC9FxbTorNT7x+3trR0j2AfUAXlyMyvtobMvuj0BwMGzqY6xZ+wHEdwc8WN8bJbDBnuUdH1TrjzHw/cGS1btu2XPmt4Oaj96ugbwuffXUQ466FapPCxGqOZrNetNjgYdDlICFkEllJGfjP114h7reGxAOi1gzMd1VxRcWI2vUBatzf4dcpPadaSMMvx9QpS+vrOMdZ6y9Jkp6aZjcdfieR0CKoqlwW0oTuHuTmfWO5WpelvL+XrlTtn8ZJT4RdUkDfZ+WQrB0+s2L0jPNweBpC6CEfnRMcvGiwnH05dh4siXan39aod2bsdmZ+a28DyxTKhJSYAKFTHSeRDCZDQrAEhhwRXVRaE1t384US6UtEoQz1iSO8j4h/slBNvx+SDeTE84F/mhJ2dR9sA1cIbdZTYAbZn1BAZicZ4RcQzy4XzNSkLKOmhpI86YZzfjXCAifjpS1A9XuXfEVlX835aUcnyXJFUAW10D9OZERX42GJIzmj2pG4grUTjt64Ts1W/7r4U2k45/LmPHJsb5jUUXCp2XosoxZ3rkpp2SnW5paIaXbefWiVH33R1FOCLuPdckCoxTe+FKGPzKpruQHw9XFb7v8Q64zFPcPqj2mpy9ARIPPcbx5RI+NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable() when
process_vma_walk_lock() is used with PGWALK_WRLOCK option.
Adjust its direct and indirect users to check for a possible error
and handle it. Ensure users handle EINTR correctly and do not ignore
it.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c |  5 ++++-
 mm/mempolicy.c     |  1 +
 mm/pagewalk.c      | 20 ++++++++++++++------
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..2fe3d11aad03 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		struct clear_refs_private cp = {
 			.type = type,
 		};
+		int err;
 
 		if (mmap_write_lock_killable(mm)) {
 			count = -EINTR;
@@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 						0, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+		if (err)
+			count = err;
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
 			flush_tlb_mm(mm);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 929e843543cf..bb5b0e83ce0f 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -969,6 +969,7 @@ static const struct mm_walk_ops queue_pages_lock_vma_walk_ops = {
  *      (a hugetlbfs page or a transparent huge page being counted as 1).
  * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without MOVEs.
  * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspecified.
+ * -EINTR - walk got terminated due to pending fatal signal.
  */
 static long
 queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index eda74273c8ec..a42cd6a6d812 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -438,14 +438,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
 		mmap_assert_write_locked(mm);
 }
 
-static inline void process_vma_walk_lock(struct vm_area_struct *vma,
+static inline int process_vma_walk_lock(struct vm_area_struct *vma,
 					 enum page_walk_lock walk_lock)
 {
 #ifdef CONFIG_PER_VMA_LOCK
 	switch (walk_lock) {
 	case PGWALK_WRLOCK:
-		vma_start_write(vma);
-		break;
+		return vma_start_write_killable(vma);
 	case PGWALK_WRLOCK_VERIFY:
 		vma_assert_write_locked(vma);
 		break;
@@ -457,6 +456,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 		break;
 	}
 #endif
+	return 0;
 }
 
 /*
@@ -500,7 +500,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
 			if (ops->pte_hole)
 				err = ops->pte_hole(start, next, -1, &walk);
 		} else { /* inside vma */
-			process_vma_walk_lock(vma, ops->walk_lock);
+			err = process_vma_walk_lock(vma, ops->walk_lock);
+			if (err)
+				break;
 			walk.vma = vma;
 			next = min(end, vma->vm_end);
 			vma = find_vma(mm, vma->vm_end);
@@ -717,6 +719,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (start >= end || !walk.mm)
 		return -EINVAL;
@@ -724,7 +727,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(start, end, &walk);
 }
 
@@ -747,6 +752,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (!walk.mm)
 		return -EINVAL;
@@ -754,7 +760,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
 }
 
-- 
2.53.0.1018.g2bb0e51243-goog


