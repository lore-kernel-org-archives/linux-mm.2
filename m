Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4007810F286F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 493EB6B009B; Fri, 27 Mar 2026 16:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4441C6B009D; Fri, 27 Mar 2026 16:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 333386B009E; Fri, 27 Mar 2026 16:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21DE56B009B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:55:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C377013C7F4
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:15 +0000 (UTC)
X-FDA: 84593048190.01.A257A66
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0EF9720003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rSxQs09h;
	spf=pass (imf03.hostedemail.com: domain of 3sO7GaQYKCP0xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3sO7GaQYKCP0xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774644914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEJVuDKnjdgqU8zwIL3/sLmobVk+HSWnDM5ddTiDQu8=;
	b=qIWmUzbh2Wnp2B9Ua/IW32S7dj/7yEi2h2Laj37u3eU7d1rJCSx3dnqxtkPltmiyDgjjst
	YOBnqo+7JbeLIYOmZHlhhZX3Nf8e+Hqqb18c0ZtJcuBQVIzS0WSwUbLcJ5shnRs8LFw7Vy
	sWA9ZRQp2O5JhGKJgF/At1fjCLcqn7Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rSxQs09h;
	spf=pass (imf03.hostedemail.com: domain of 3sO7GaQYKCP0xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3sO7GaQYKCP0xzwjsglttlqj.htrqnsz2-rrp0fhp.twl@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774644914; a=rsa-sha256;
	cv=none;
	b=pvQ4qLNYVAq/HrPQkPiyb03zt6VeAyGIRimyvYreLm2GVB3ocFPG5azh5FGn6q/Ntow152
	CFWVgudK8NHOYvBSi8mzn6e4S90vH5gR7QsYxhjJ5dBDSU42VWPRRqrVwAl2hzSSuXaYGN
	MplccA9pXIl/FfrDMUDUN9PPSseCAq0=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-127876be621so1606525c88.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774644913; x=1775249713; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gEJVuDKnjdgqU8zwIL3/sLmobVk+HSWnDM5ddTiDQu8=;
        b=rSxQs09hH/bzzZE3T5MvkbKek0szhoZet390E9GHT+AH14afqpo9DRboiLOCMp7EdU
         V76kpyunOsY8QuTca4rkBfXxt6ijxX20FVVQc/Yy9Bmx0rrrjYbutg2gKaO2CPNcmYFl
         lVtx/efBQGE2qr8jEwV+SBi8RocRmO2VMH8eWYlPlctzFIJxQaVi4CS26emJ7EZ9NLOH
         wuz1bXSL9vuVSJbNIv7u/mxWOQalCp2N9VjAbXDk1IjRIjxcOdUWaYx0reOmbNvOaReO
         PrsECPcJ62ML80BqYwW0YuOA7fFnj3OJ3llDE1+aHPqA/hjwI1E51GUbjASQMYErgWGG
         /dEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644913; x=1775249713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gEJVuDKnjdgqU8zwIL3/sLmobVk+HSWnDM5ddTiDQu8=;
        b=ZMZzmel3pos6blT4KWCHpGZI8hke4FKdHWs2Wy6la0Lr6tcV4BHxuTqus7jiJcaLqp
         NoM8RAEzrgI4A4hFaqDk6McShCkWcXxnsLcd24w4Kiu2kIFUkzmCkFyVtj0qHvjDUKnc
         SwBL/ZS5WCjaqfCmR3saQFbzSfoqemHK+ebzcxQ6H6CMFSwTLM0Q+tAvOIECQBvLLq1G
         ogR1RyzIoM7O6HNwN4rqF05+fPLFpzRBA7Ceh5F+LW/YjjN4XGMFW0W0Dsl17zDiKxaT
         V22R16P4o50p6Gyx850udSB+0AUjSoZG3FUvUtmViWH6x/n//behs6bVthKONG88PQqx
         zvlQ==
X-Forwarded-Encrypted: i=1; AJvYcCURZ+vejvFLD7Lb11de8iRZ34FzjPPudjD+tlN6feLiAI5h1r/RbyTsZzQas9WxpbcrdbOJExGS7Q==@kvack.org
X-Gm-Message-State: AOJu0YwSsM51qE05/b19uxsAXYVxm8gFkJzhbTZ4if/o1vLBFWBUNhBd
	+urINLCvOaAguybGq3wcGGzj/GJeuMYkkGRruTJm4rH9fD301ZoNPI6g6k0sQ0PUkH80N4tj2l1
	6dXTk2A==
X-Received: from dly16-n1.prod.google.com ([2002:a05:701b:2050:10b0:12a:7f27:56f7])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:6099:b0:119:e569:f874
 with SMTP id a92af1059eb24-12ab3045876mr1405563c88.17.1774644912438; Fri, 27
 Mar 2026 13:55:12 -0700 (PDT)
Date: Fri, 27 Mar 2026 13:54:56 -0700
In-Reply-To: <20260327205457.604224-1-surenb@google.com>
Mime-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327205457.604224-6-surenb@google.com>
Subject: [PATCH v6 5/6] mm: use vma_start_write_killable() in process_vma_walk_lock()
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, ljs@kernel.org, baolin.wang@linux.alibaba.com, 
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
X-Rspamd-Queue-Id: 0EF9720003
X-Stat-Signature: bof9byiicgnyrmaotqcxei8ampezode9
X-Rspamd-Server: rspam06
X-HE-Tag: 1774644913-855675
X-HE-Meta: U2FsdGVkX18AKsrngSYWiDxNoNr11V131Q8sAu8mFsHyNHT8tp5muFtYwcBMlR0bXjDae4ybiuAO+eur1O2H1FvJNME6K1BuRvYWH2sxJ/vfwAWvWoy/sA0yKRHeTPdT8r1htD9ATrelDoRIb6QDmpwe/IYUbbceCfyo7sNQdU9j7FEMloXRBv7vZj6+I5D4MZYWj8tmzZh00A8iwr/bmHkYjwCC2pTLpWsvEv4Jh9bBHsqw5JLAgIzw540Barw99jLNrkwc4+aW8Pnl6OVRZtybwXZRWivn+V71Do4utXzXMr0GmujNtESHPs0iwd2/BqRTwQSfXiEzq+Y/V5xyUJYzMU/BIs+2BI2S9laJYfr8PiwyqXNfX8HN2I3egsbKFaOB671NmPUvEx/3nJzjjdkA7oTJH9IsvJOQX5VFWnr0TEKOjw/Wn806VzCtaOQrTqVgIkOwQ91C4qEBLVY/9SXXxrbW612AffR6xvaMMYSOmeLJFFasm/SVKTlrzRV3M2osvSEdiBYVxNTSNs6h7MZbfa4K+wHFlMwHi7BmBiiGuVwClyQaBGqT48/tvGHMuhfXnS9bOFGjThsMDKII0MYDQShfTpd6ovr0QQ53ONsAmrnxwWs4n3lLvSia0LVSZFy47v3a6BSRW0kcc/aKPwZmPlVjn2Tu77dy9pdr3BuIoxdDJ9bcQZvjQRIJuzQ/f3BIpAiIRBxtTBJaNR25iR8ms1ZbYlU6bGi/2g06Ivd977K4cdyrI4Q85+Y+pIgL+6ikGAiBZfRG+ko+VeQQQ9drunuG00N+DLwjzs5tmcnsCFrsDTmgTGahn7D1sYNID4aO3ADHkghOW8uesXT52WoktvevS2IKjiBhNWpEP4h2AgufnSsN0JPlwmFlx2Xp/Y7KaAldQO9TAD3hbf2YqkAk/MN/QfNtHPB4kAt3uc9cpmqJTyF25InR64MHWMeJbVgKAH2hNCdBGwxKY3u
 LnUVNrmw
 4AFqk5Plt56nxcW1KV6Nt0Wy9osC8/JW9PTBHKX8Q3Xp1eK66O8NNH72NyJF/cQbXrzhHVsfuyynTcIKBDVXiQmDHZZXRPpHh4rOQ0lqM6VjhtV59MnmtXIDHdw6OSz/88Ht8T0AI/NhO6ekmPsKY3CkbK81VEuloGxTjto+XcgTtEUUy/FUA0AmBaUnQ9jL4dNvRi6BtwNcRNoCs8yZTCGP6MOsHylsENqECHWV1shRZLYgmciEz6y702S0nyu2g8Le8Ymuqg/aolpIJ9G5dl941BKdtzFL/02JlZ8wtw0M8Df41f8+bDzcY+2OZx1kVDNIfqm1SD9O/VBBSDoVQaLHLFPhJ9qNVqBNWkanHoCMxe6/qxHe1Wtbi+8o5i3SiHok623Xmk1bF4nYOmL5pazf0wEsiVQZE7+ZcIhL0iuAcC/GDh9zZHidHuaM0sFikiUDCecMQ+Gu6orZNTCrVLA3WYjS4+TOM1Kk+HTCkuo9QUYr3zUYbr61aqiNAkVZPgolfUVan+rhhFvAzHb0zuZXUmn182REgk3aJwrdhmpsA5JdMRMEqXyY6TmOux4iMRAq/03y60QyNEqn8JWKfcEuhJt36MwfKHkmJJsN9lgVEoiOcxcq7HmVaE7rzHX861iiglVcixcndIZJ9lVFrRzK1//NW3XJWu1UpnmNRAL63EbsBKM9XO6hLT5K5guHadxuRsQqjYJYBJmoqF5ntAMF3+aVGuPEOoQ4b+f6B8d7i3pwkYpZMwqP4oHCmng81SyeSzzJ/PfqXSR1abLCj1sgntlsGjHbWI0Y9R+dJf8j+yKo=
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
it. When queue_pages_range() fails, check whether it failed due to
a fatal signal or some other reason and return appropriate error.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 12 ++++++------
 mm/mempolicy.c     | 10 +++++++++-
 mm/pagewalk.c      | 22 +++++++++++++++-------
 3 files changed, 30 insertions(+), 14 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..33e5094a7842 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1774,15 +1774,15 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	struct vm_area_struct *vma;
 	enum clear_refs_types type;
 	int itype;
-	int rv;
+	int err;
 
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	rv = kstrtoint(strstrip(buffer), 10, &itype);
-	if (rv < 0)
-		return rv;
+	err = kstrtoint(strstrip(buffer), 10, &itype);
+	if (err)
+		return err;
 	type = (enum clear_refs_types)itype;
 	if (type < CLEAR_REFS_ALL || type >= CLEAR_REFS_LAST)
 		return -EINVAL;
@@ -1824,7 +1824,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 						0, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
 			flush_tlb_mm(mm);
@@ -1837,7 +1837,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 	}
 	put_task_struct(task);
 
-	return count;
+	return err ? : count;
 }
 
 const struct file_operations proc_clear_refs_operations = {
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index c38a90487531..51f298cfc33b 100644
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
@@ -1545,7 +1546,14 @@ static long do_mbind(unsigned long start, unsigned long len,
 			flags | MPOL_MF_INVERT | MPOL_MF_WRLOCK, &pagelist);
 
 	if (nr_failed < 0) {
-		err = nr_failed;
+		/*
+		 * queue_pages_range() might override the original error with -EFAULT.
+		 * Confirm that fatal signals are still treated correctly.
+		 */
+		if (fatal_signal_pending(current))
+			err = -EINTR;
+		else
+			err = nr_failed;
 		nr_failed = 0;
 	} else {
 		vma_iter_init(&vmi, mm, start);
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 3ae2586ff45b..eca7bc711617 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -443,14 +443,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
 		mmap_assert_write_locked(mm);
 }
 
-static inline void process_vma_walk_lock(struct vm_area_struct *vma,
-					 enum page_walk_lock walk_lock)
+static int process_vma_walk_lock(struct vm_area_struct *vma,
+				 enum page_walk_lock walk_lock)
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
@@ -462,6 +461,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 		break;
 	}
 #endif
+	return 0;
 }
 
 /*
@@ -505,7 +505,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
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
@@ -722,6 +724,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (start >= end || !walk.mm)
 		return -EINVAL;
@@ -729,7 +732,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(start, end, &walk);
 }
 
@@ -752,6 +757,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (!walk.mm)
 		return -EINVAL;
@@ -759,7 +765,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
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


