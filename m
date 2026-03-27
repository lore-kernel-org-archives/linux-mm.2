Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF76C10F2873
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138376B0096; Fri, 27 Mar 2026 16:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C326B0098; Fri, 27 Mar 2026 16:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBA236B0099; Fri, 27 Mar 2026 16:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA4536B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:55:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6F3AA1A12BE
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:09 +0000 (UTC)
X-FDA: 84593047938.29.C0EA5A9
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf10.hostedemail.com (Postfix) with ESMTP id A269BC0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Bh4jW0La;
	spf=pass (imf10.hostedemail.com: domain of 3qe7GaQYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3qe7GaQYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774644907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+n3Djg+u5/v209SkkHKUKK85Ins0KyBj2RQsN4UbGc=;
	b=SLmesnRr60PfmiWKYFYNJ8j0aEa1BqiijOGZHgSCM6qnd++s3Dca3F8zwIVZh4jhFrwYj6
	4TqPnXfqdTXzalnTwpsHrCIY7N03irkgRKXMUofq1G7/g+6xD/XH5BGH3v3J+roMI8IGw6
	DcZxqmkuM0iuQ70lmjy1dM7kyGsbs+Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774644907; a=rsa-sha256;
	cv=none;
	b=7E7rV2XKUHaYw5nVVHfwQw5ALOdnqIULbSFvaZdrm58xxwVns4iKen1QXs51M9Mmmh2XXi
	kpqWmJosmRMq1HAwxf70nDBNvXvzMIHZ1KH/AgDfdCr/9WPRAsk1EVqWX8qm4gWaAV7KFl
	hOzO69FjjiQq6NwMrxLrlxd8O34ILg4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Bh4jW0La;
	spf=pass (imf10.hostedemail.com: domain of 3qe7GaQYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3qe7GaQYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so2642257eec.1
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774644906; x=1775249706; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6+n3Djg+u5/v209SkkHKUKK85Ins0KyBj2RQsN4UbGc=;
        b=Bh4jW0LaJQi/ww6WTr/wpTBbxFDKUoBlgEXmXx/QAkmEa0oYjzSATHWraFvCgLDfYR
         wKcbdAb2p+Xi7sNt+yPdGSHtDxkiCMR+gSnlbpE+fkx4wcDz6L3i755YjJa472M//R8L
         /E2iaD1RUlz5uz90kOnDbqAtUYBGg22Xa1R2LnBWLWk3hWy5PshjDMdkY9INsVHxypTy
         MqpbPA0YKcFjrcYvZ0lKzpBqwYTXZWcx+qSqe2ARham/YwI70vqDjNeKhFb60VKiV2Xj
         luUiruO/qvAfZHRuLszcAVRjE60a7ITmnQGsPCekQQhPFc1jbzfAapw5Owihehe9rl5F
         wP8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644906; x=1775249706;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+n3Djg+u5/v209SkkHKUKK85Ins0KyBj2RQsN4UbGc=;
        b=L73XSHz0i0WH4bjfPLgSb6fezV134Vi9ihFc7V6x21GA2xFjK2L1Q1+sNsg7B7jWwv
         EodMtl4bHxNInRfraO3KvwT11HvfWW1kmxYQGT6Jm0p6/y/RnufBh/MXA7tuNYyCIbym
         5Xw910TbysgGt/bLK/bWXHexstlbt4BR/ZPaYZEeMy1Pf5WZGZTeZgFq0VxSivShLhCx
         Usz8lQZC0DKbVgQ17zKHDAYPB7nzRIc21/u667jXkPUEHqINLgKcX2kNFItWe1B74p85
         kSUhum/rIiAb419N3HOSn6F/sKujDbHueXAn2LUNQHsTqJaEVvRmATN2niez1hkO4rUb
         FONQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOAildpPnFPr/cxn9HWQGdLACOQJjntqiDFArLJy5cCy7tmGIWMK0C/Mmo+Clr8wZn1F08dqeFCw==@kvack.org
X-Gm-Message-State: AOJu0YysOBB7/8VeEpW2vQXZ06jFOXYP28eGUE7Wq94m6dN402WpjJCr
	xrioEFU+kdGajjtq6EvCy+O5tjzqyaeqxEyx/hs9uRAmVkfAQEyA/nnYl7MKLpsvY5Z9Iz7vlpW
	pkQbt6Q==
X-Received: from dybsr8.prod.google.com ([2002:a05:7301:7188:b0:2c0:b345:9b22])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:fa04:b0:2c1:6cfd:73da
 with SMTP id 5a478bee46e88-2c185fa842amr1935438eec.32.1774644905874; Fri, 27
 Mar 2026 13:55:05 -0700 (PDT)
Date: Fri, 27 Mar 2026 13:54:53 -0700
In-Reply-To: <20260327205457.604224-1-surenb@google.com>
Mime-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327205457.604224-3-surenb@google.com>
Subject: [PATCH v6 2/6] mm: use vma_start_write_killable() in mm syscalls
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
X-Rspamd-Queue-Id: A269BC0002
X-Stat-Signature: h5dtk3154tmwb4hup3b1hy7b4xyb4bgz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774644907-283264
X-HE-Meta: U2FsdGVkX1+n66Powb3wsKxygiBNyJxTRIhxP25UQeDMeXrKLXSpSOBM+bXJB7TR8+hq8JhK33FzQrWBzmdgV0XJu0JdoAQBZy+ufa5nQnxAIjWbi1OBQhqDgcCgFiG13lbIHDYsXouiSpJRUjwDCIqiQlPhDunFUEO+5hoiLUzQwxU3HZYXkACEFx6RWVNs57fOTh2fmVMHWIlw5upp0hcadkLYkxQPluk6PGuF9JpewiZDKAM5TN9NCaWjoc2SZwK3Z4/YQrpi1zIUOTJsf3mteoD127ut+9MflO3QatwSppeuoB9sKBe5YPOIIM54AbFy8iLcLraO9QCtUdg7nfX8Y42jRSa9pbdULEfs1NIHnoqLPhyLHirfN9Q5GhWTz0dzS5ugR2PUZRdysMsjw/brUrHs9DiRsPU9FzXdOrLFWoiu97U8BJwlwiaak2xvgACTzUOlCR8A3T+BB+m7hfrofx+tZ+qpjY/fVN2lINOoGNeNmQo2472fRs40NBzZ3V5pKdkx0xmrkm+1uHmFWlp4uPUruDMK40oXF+AVMOoRH4wTwOvSpa0Wzefg2GCKxE1jzS8/dmiudfAoWkIAZ6GdyNO/qYB2xiC9tSUot+HdDp1gIuHNLDGkOQkPHveWpPPd0U9kQf1DOJtPexdACanItTTPmPkUjahbezBrW9eLpJPfdmSpmOOV/q4pAvlo+iFYNhE5mVwbfJS3bAD8HQIQUKV6GAGadduEdIq8MMmCTPKUDQ1KPJrcyiCNb2cW65YvTkF04DixYHRbSB0zH1Re1L7daYyy9Nn6/Q9mHQY4PmIvqhDayy/V49jUihjr4LkC3xpV/5sHXR9cyxDC5zPDSqxpyBlbwCqeaE683PYr1x9GDTRAfh1A66/+ObB7wSB4PNOyfI3GJidUCh77URimaFRXmCqRhapnNrpPDEJhIsWIS6M828V6OYGZMD2gXJ7/qLgWLRzW0bFeJLz
 Z7Vn7Coa
 8z6Z5xYgHIm/2/hryaXbXQ4iyKJBEsYE3V0VNLwhuARkIWiRIl1oFGzVmkQKK1vy/OP6rzoqOxGrVH9nY0AvihruK1RRuxZRoXAFh9FAiWJpOtuDV+3/ijQFFUPAD7m0GsMJh73No/GIcaex8SkLUjAdZm4LM2tSBOmwzE96YsSTC/Kys71INOg7jeaZDwiQ6sa++IJ1e+x5dJIDi/yF95Wyf9JCctJ5j39lYwMIHO/zS6XhpGra/ZYlgKZkreOoxwsgDqLkZ5po8y/sm44IXCimb6KxnK8WPVmxDikBB5Eka24+UU8caulba1teBijk8koaBInyQ6+ulj9pKba7r0nG9S79upzzv31QryEOCyUGSqRYRkJjRiwg4kMedwrgvcGZVPG6FLLQpUiUVXLieIjA0pqLu2QMPt7h7bWn9CaEvsjOaYuLV/NQrZoH6Fc9JtCXWJArhdCc+W9jgKl666NgtrVWnNgKEitJ6eiImOs9ZEDJ+fYxypVMbUBUNbexMppw8pe+EdaIMk2SMWZYZE03H8YhxjCyhAJ1+eTbA7pLnJZECF63p/p/+w4sY9KQFnFobuqk9SzvHLbck6z+4TVcMNsOYaFsE8uD5QgM7zvf0Adn6J+iueQjPHp8NXvDvJsvmo00nI8p9oMtACElHx/+uK8wXK9AX7ik2nRj21hzZy0XJBs6Qa2V8+jL3E7CugAY2/9uu5G+mH6uincHhwz5W+B7mttb/XWDtFuqMEsuBeLiSNChF6xaUlcLcXjlLrRAynB/6btfhKQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable() in syscalls,
improving reaction time to the kill signal.

In a number of places we now lock VMA earlier than before to avoid
doing work and undoing it later if a fatal signal is pending. This
is safe because the moves are happening within sections where we
already hold the mmap_write_lock, so the moves do not change the
locking order relative to other kernel locks.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/madvise.c   | 13 ++++++++++---
 mm/memory.c    |  2 ++
 mm/mempolicy.c | 11 +++++++++--
 mm/mlock.c     | 30 ++++++++++++++++++++++++------
 mm/mprotect.c  | 25 +++++++++++++++++--------
 mm/mremap.c    |  8 +++++---
 mm/mseal.c     | 24 +++++++++++++++++++-----
 7 files changed, 86 insertions(+), 27 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..f2c7b0512cdf 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -172,10 +172,17 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
 
-	madv_behavior->vma = vma;
+	/*
+	 * If a new vma was created during vma_modify_XXX, the resulting
+	 * vma is already locked. Skip re-locking new vma in this case.
+	 */
+	if (vma == madv_behavior->vma) {
+		if (vma_start_write_killable(vma))
+			return -EINTR;
+	} else {
+		madv_behavior->vma = vma;
+	}
 
-	/* vm_flags is protected by the mmap_lock held in write mode. */
-	vma_start_write(vma);
 	vma->flags = new_vma_flags;
 	if (set_new_anon_name)
 		return replace_anon_vma_name(vma, anon_name);
diff --git a/mm/memory.c b/mm/memory.c
index e44469f9cf65..9f99ec634831 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -366,6 +366,8 @@ void free_pgd_range(struct mmu_gather *tlb,
  * page tables that should be removed.  This can differ from the vma mappings on
  * some archs that may have mappings that need to be removed outside the vmas.
  * Note that the prev->vm_end and next->vm_start are often used.
+ * We don't use vma_start_write_killable() because page tables should be freed
+ * even if the task is being killed.
  *
  * The vma_end differs from the pg_end when a dup_mmap() failed and the tree has
  * unrelated data to the mm_struct being torn down.
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index fd08771e2057..c38a90487531 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1784,7 +1784,8 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 		return -EINVAL;
 	if (end == start)
 		return 0;
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
 	prev = vma_prev(&vmi);
 	for_each_vma_range(vmi, vma, end) {
 		/*
@@ -1801,13 +1802,19 @@ SYSCALL_DEFINE4(set_mempolicy_home_node, unsigned long, start, unsigned long, le
 			err = -EOPNOTSUPP;
 			break;
 		}
+		/*
+		 * Lock the VMA early to avoid extra work if fatal signal
+		 * is pending.
+		 */
+		err = vma_start_write_killable(vma);
+		if (err)
+			break;
 		new = mpol_dup(old);
 		if (IS_ERR(new)) {
 			err = PTR_ERR(new);
 			break;
 		}
 
-		vma_start_write(vma);
 		new->home_node = home_node;
 		err = mbind_range(&vmi, vma, &prev, start, end, new);
 		mpol_put(new);
diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..2ed454db7cf7 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -419,8 +419,10 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
  *
  * Called for mlock(), mlock2() and mlockall(), to set @vma VM_LOCKED;
  * called for munlock() and munlockall(), to clear VM_LOCKED from @vma.
+ *
+ * Return: 0 on success, -EINTR if fatal signal is pending.
  */
-static void mlock_vma_pages_range(struct vm_area_struct *vma,
+static int mlock_vma_pages_range(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end,
 	vma_flags_t *new_vma_flags)
 {
@@ -442,7 +444,9 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	 */
 	if (vma_flags_test(new_vma_flags, VMA_LOCKED_BIT))
 		vma_flags_set(new_vma_flags, VMA_IO_BIT);
-	vma_start_write(vma);
+	if (vma_start_write_killable(vma))
+		return -EINTR;
+
 	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
@@ -453,6 +457,7 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 		vma_flags_clear(new_vma_flags, VMA_IO_BIT);
 		vma_flags_reset_once(vma, new_vma_flags);
 	}
+	return 0;
 }
 
 /*
@@ -506,11 +511,15 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 */
 	if (vma_flags_test(&new_vma_flags, VMA_LOCKED_BIT) &&
 	    vma_flags_test(&old_vma_flags, VMA_LOCKED_BIT)) {
+		ret = vma_start_write_killable(vma);
+		if (ret)
+			goto out; /* mm->locked_vm is fine as nr_pages == 0 */
 		/* No work to do, and mlocking twice would be wrong */
-		vma_start_write(vma);
 		vma->flags = new_vma_flags;
 	} else {
-		mlock_vma_pages_range(vma, start, end, &new_vma_flags);
+		ret = mlock_vma_pages_range(vma, start, end, &new_vma_flags);
+		if (ret)
+			mm->locked_vm -= nr_pages;
 	}
 out:
 	*prev = vma;
@@ -739,9 +748,18 @@ static int apply_mlockall_flags(int flags)
 
 		error = mlock_fixup(&vmi, vma, &prev, vma->vm_start, vma->vm_end,
 				    newflags);
-		/* Ignore errors, but prev needs fixing up. */
-		if (error)
+		if (error) {
+			/*
+			 * If we failed due to a pending fatal signal, return
+			 * now. If we locked the vma before signal arrived, it
+			 * will be unlocked when we drop mmap_write_lock.
+			 */
+			if (fatal_signal_pending(current))
+				return -EINTR;
+
+			/* Ignore errors, but prev needs fixing up. */
 			prev = vma;
+		}
 		cond_resched();
 	}
 out:
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 110d47a36d4b..d6227877465f 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -700,6 +700,7 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	const vma_flags_t old_vma_flags = READ_ONCE(vma->flags);
 	vma_flags_t new_vma_flags = legacy_to_vma_flags(newflags);
 	long nrpages = (end - start) >> PAGE_SHIFT;
+	struct vm_area_struct *new_vma;
 	unsigned int mm_cp_flags = 0;
 	unsigned long charged = 0;
 	int error;
@@ -756,19 +757,27 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 		vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
 	}
 
-	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_flags);
-	if (IS_ERR(vma)) {
-		error = PTR_ERR(vma);
+	new_vma = vma_modify_flags(vmi, *pprev, vma, start, end,
+				   &new_vma_flags);
+	if (IS_ERR(new_vma)) {
+		error = PTR_ERR(new_vma);
 		goto fail;
 	}
 
-	*pprev = vma;
-
 	/*
-	 * vm_flags and vm_page_prot are protected by the mmap_lock
-	 * held in write mode.
+	 * If a new vma was created during vma_modify_flags, the resulting
+	 * vma is already locked. Skip re-locking new vma in this case.
 	 */
-	vma_start_write(vma);
+	if (new_vma == vma) {
+		error = vma_start_write_killable(vma);
+		if (error)
+			goto fail;
+	} else {
+		vma = new_vma;
+	}
+
+	*pprev = vma;
+
 	vma_flags_reset_once(vma, &new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
diff --git a/mm/mremap.c b/mm/mremap.c
index e9c8b1d05832..0860102bddab 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1348,6 +1348,11 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
+	/* We don't want racing faults. */
+	err = vma_start_write_killable(vrm->vma);
+	if (err)
+		return err;
+
 	/*
 	 * If accounted, determine the number of bytes the operation will
 	 * charge.
@@ -1355,9 +1360,6 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
 	if (!vrm_calc_charge(vrm))
 		return -ENOMEM;
 
-	/* We don't want racing faults. */
-	vma_start_write(vrm->vma);
-
 	/* Perform copy step. */
 	err = copy_vma_and_data(vrm, &new_vma);
 	/*
diff --git a/mm/mseal.c b/mm/mseal.c
index 603df53ad267..1ea19fd3d384 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -70,14 +70,28 @@ static int mseal_apply(struct mm_struct *mm,
 
 		if (!vma_test(vma, VMA_SEALED_BIT)) {
 			vma_flags_t vma_flags = vma->flags;
+			struct vm_area_struct *new_vma;
 
 			vma_flags_set(&vma_flags, VMA_SEALED_BIT);
 
-			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
-					       curr_end, &vma_flags);
-			if (IS_ERR(vma))
-				return PTR_ERR(vma);
-			vma_start_write(vma);
+			new_vma = vma_modify_flags(&vmi, prev, vma, curr_start,
+						   curr_end, &vma_flags);
+			if (IS_ERR(new_vma))
+				return PTR_ERR(new_vma);
+
+			/*
+			 * If a new vma was created during vma_modify_flags,
+			 * the resulting vma is already locked.
+			 * Skip re-locking new vma in this case.
+			 */
+			if (new_vma == vma) {
+				int err = vma_start_write_killable(vma);
+				if (err)
+					return err;
+			} else {
+				vma = new_vma;
+			}
+
 			vma_set_flags(vma, VMA_SEALED_BIT);
 		}
 
-- 
2.53.0.1018.g2bb0e51243-goog


