Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6DBF106F2FA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42DFA6B0096; Thu, 26 Mar 2026 04:08:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231806B0098; Thu, 26 Mar 2026 04:08:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F056B0099; Thu, 26 Mar 2026 04:08:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07CFF6B0096
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:08:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9E4398CC9C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:55 +0000 (UTC)
X-FDA: 84587488230.09.0E3BA75
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf19.hostedemail.com (Postfix) with ESMTP id D87CF1A0007
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:08:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KCcjAlSc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3k-nEaQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3k-nEaQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774512533; a=rsa-sha256;
	cv=none;
	b=YVEOCOLBC5yQn+1D7lpQeR/DE8YQZbQ400wwATaAfk/knNEP+4e6f5xiOIchGIMWaZ69GP
	XL8WBL4boOrapjnje/iFtJu9Mr7efiCchLPCEO5EluoXk+2IVMvwT10+KJ4ORsX9uu6/sl
	QqCj4ZpMUtiA7jKix+OiakzMdWpeULM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KCcjAlSc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3k-nEaQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3k-nEaQYKCM4CEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774512533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2FZ0j4JsuEtXH0QE0EGuqUW1/fY5oq45gPlzlHIXGA=;
	b=VXWXWK4IDkaLZsRUSxjy/uqlD3ORcSzeia9x3DLw14kDMD+waWFxD90Oa1IP3SnkapMXaU
	3304m2HUNM6US/03rHnCEyrydwWczDjaTVchX19QOf4dstXeM9ZV504xp/5qNxocXp91Kl
	LPh+7QmmmZLWj4qWhk9/M5U0eTGI3vE=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c16233ee11so726343eec.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774512533; x=1775117333; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=A2FZ0j4JsuEtXH0QE0EGuqUW1/fY5oq45gPlzlHIXGA=;
        b=KCcjAlScx7l77ra2VhKBVEwhaKYOKHN1far/XPS4RohkLd9qesIAPLMMFTEu0T9CiK
         12MdRdj8NnQzrU03QEx0wGXU1cF50Aip/gvyZKAIjeKf8hOy4OURgppnfpYD5N0U7Xaz
         fKmh4p0mIUAxdRvvT+bzvU+RSmujmC+7XZVZdi3dI/BWuYr+uWP+84iOkVuYFYb+uerB
         sgl36HP7C1lBXG6o5WJULu6Irecf401rPqT+/afsKq+KvTc0rM43qMTq5Mqlr4oSU3cY
         ODMO0hIayrjt/WeD8a21Le0xfdjaJKr7/VN1PoGg/cMUytkJGwIDk2P2dNEHM3C4Ny2Q
         JsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774512533; x=1775117333;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A2FZ0j4JsuEtXH0QE0EGuqUW1/fY5oq45gPlzlHIXGA=;
        b=C4mrQIx3PEo5bD1wohSvHwCTxAvT/o+kctTnXtd+PJ/GTwMvb4g2lfEHIxztNVGJsn
         SbU6teLQ7qtlNaC1zqfj1tduMrGg7BIj7IStcWI7RcK2v7+3PGzcOrdJxxvLKlC/1keC
         lgQAjRBH2CpnGKCVMJAEph5BB6PBF2hsS9x3GItalSAO98NJ4CcRCgsU9etLQiWpE7q0
         20QQ9TerIDyRM+rw+TKvsOLLuqEsDWRznHCQk0kQK8umpiaXM+IQCkQCucIcizfd3GPk
         EEj08LECEdPNPGWnaBkL53HlsnSnAVwPrrdstcyteu3A0BZLdOy+RRRoSnspRKCC5cUa
         6H8g==
X-Forwarded-Encrypted: i=1; AJvYcCWqjqGeKeR0WrtecqqfU/porSEkAbO0TnOJxw9AD9F7F6mVPViHQo6olZuNGN1Jb7Tu5x/vno+YRw==@kvack.org
X-Gm-Message-State: AOJu0YyRbKGVnLg4qv0eOtonrWl6RJAOHtcaiHBQB6SFZBrTTTls3vTA
	Q9IHjKZU9pnETIL6l2jG8ESRaN5/++5ykfwA+FIfl1E/6gNGb/+mXTjsbOwZR/uN5LHhhlbdvdd
	6uoyv1w==
X-Received: from dycrm24.prod.google.com ([2002:a05:693c:2a18:b0:2c1:4f1:c859])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:8b05:b0:2c1:161f:ac39
 with SMTP id 5a478bee46e88-2c15d3e3b8cmr3740873eec.26.1774512531898; Thu, 26
 Mar 2026 01:08:51 -0700 (PDT)
Date: Thu, 26 Mar 2026 01:08:35 -0700
In-Reply-To: <20260326080836.695207-1-surenb@google.com>
Mime-Version: 1.0
References: <20260326080836.695207-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260326080836.695207-6-surenb@google.com>
Subject: [PATCH v5 5/6] mm: use vma_start_write_killable() in process_vma_walk_lock()
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
X-Stat-Signature: 4g45xb9ait8wha5q7gedd786rbijheea
X-Rspamd-Queue-Id: D87CF1A0007
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774512533-292788
X-HE-Meta: U2FsdGVkX1/nNAZ2NIqeSVlPi6HA5ryzWoaUY6g1R9pv/whcrceQE+YDl0jXcjm95GKChhoSWhmQakcEPYfqWoJ1z/zcCwLTevlSCjkAYqGZBV6yWf3Oliz6pPlkRuWXnOrxR3nqpd1TGGxi7WyvRmq3DyysARnIghAejUgglTSTDNoJvzA64WW0zVUJdq1eMm4ENAWFuxALzIutacTfSd6UGvJPlWENaHylmg4k4ZAoMX49BcTQptn2RXd6ANeyff+tf6+AOIg+isfDVcGovvgfJlbD2V1kdVJrTkGi2x4vzHbuBXAHlw2FRmQolmQxjM0sadf+y/J7K3IYwXy/DFs+yrUHxAi8nLJC8gJLd8UOqBaxr6PhMhYiumC06cK3waNgzgB8NKxMDCGS+ODy/oN/U+pjPzXvPLjXEKfD+L1UEc2UihWFHn505vAwSrL3NpGCYuC7aUieOzaRVtyat8SsCz5X/37JgLovKU/PxGsvB+1GAVscBPlXH3BKNoriH2PILNDE4h4IUgK7yd8eG+nkrp17xa1ArDMOJ6SiAL4HJX0zKcDE73i7MAq/jBbTV6cInEJJ0dFehb28RpdCITt9OA7hABu8UnA8t55L1+rYO2yxTl2Tgs3iNjGmCW+l1XCzSvWHMnFk5fXX2ts4YPH/nujcOX/GqTQFk1ZHb/TaBkYWKUmrs1bnllBfvSSzqFJsYfTW0xiJttOeR7NnKxQcrSlzEKhLTROPu9rMe0/lL6WEemp1WoUNABUeQSQCk9iVUxGNrACR/STCKthtkupX5/qcF3Vwt8G1wtzeZ1NAxyPOLnS2GekHRMHUf9rUSydwsq5n/diVd+7KyKDsWZzf1w3q8yk3tIR2CJRQzthY6qctZ1hJJp9sZ52+VLUdhcWAqhdoGbJRyZTUJQmR9GrGYymE15vQsdNAfyrZk10+x//G/58MfJtiIWnSjPmtb2TScn1Vn1sQy+J4eue
 MkCs4Nle
 7HGjh5sq5MWGw+dOz1m1N3Io2dRywYCvTEcJP/2jZRsR3oBwWOJ1EbxN+SkqASSZejgMqg9CHOt8sUZqzf8sGKsCelIo3dGkGBjUCxCiaGdFrszLTcGNW8s0+C5H3+kPHekm0faf1nO4fPL90bKPhh7xT2MDtfIlrUYxk6KenyruFBCt5FYTPIpdHleYiZR0eZIl9aDGHiDhl8SrQgvXMSu9TVB1Gwl8tDkxLfVorKwG2F9TONoupGj7UsxI5SKE2TOIYFCrL+5bRnJbykwFU2/eS5WUAZsMlBZ+QL1ye0eVGW2kSd6aQFn081AXo0cQqa0k+TBQmqDtkLHX1DcPSIIwZuWGqtvK42jCXBoJrxM/ruMKpMXdO5hjNtrygTVFqLUiZi6ritiGHbc0iHuyT9T8PJVaArE/LIMHUuehFnzrRoPoPDYtXjVRoYb2/3eTcP4+MK8rywSkxHQcm7t5LyZVu0QBW17hDqk6OXlI/K63llOtAw9YGzOECkZkk2beFXWaZTwYsTKtc7hoFrRsAbCl0TOFe6hjo3tj7H9p5phpVNGUi27xecJn02njg6NoCArCht1xQbwhGQgu7nLE/GRWh8PFPVa4XcvmLRPy/DyNsl286wSN1rekWjnl1dQdfb4ibgT0P5mY25HrW9/uZnF5MllToJAWbCz7jmqh117AvDKceAH2i4bS32aQt5KItXOKcB0Dg2XIs6X1mEyqq1JGvMYhwe2JB4k007FneEGB5wdUuyfGOoVNLelDenMMNpwY5miLlK9O4ZabNGozuTVoXqWY67kfk9MxGm8L5c/8dGQ8=
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

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 fs/proc/task_mmu.c | 12 ++++++------
 mm/mempolicy.c     |  1 +
 mm/pagewalk.c      | 22 +++++++++++++++-------
 3 files changed, 22 insertions(+), 13 deletions(-)

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
index c38a90487531..336753a4b2b2 100644
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


