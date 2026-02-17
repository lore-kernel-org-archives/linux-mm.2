Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692BFE909D6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 346EF6B008C; Tue, 17 Feb 2026 11:33:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E50D6B0092; Tue, 17 Feb 2026 11:33:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E0A6B0093; Tue, 17 Feb 2026 11:33:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 094396B008C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:33:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A45C01B40A3
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:33:03 +0000 (UTC)
X-FDA: 84454493046.11.B430477
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id D4ECB140013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:33:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3oY+2u/Y";
	spf=pass (imf23.hostedemail.com: domain of 3PJiUaQYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3PJiUaQYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771345981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9Ark9R30Qkzih8r6uy5tMYPv262iFz804WfSXpH0hs=;
	b=WHbQrMOafxb4MjSH8jEgEYTiWvL5vf8//PpbISO8nMq8tPM9VPAekgbbEAMRu26SvM1jQt
	O8uTTWh+0VmiQEHw3XeUEX1rApL8t9rSdBdjXt1p/ZACMxqxsUnwBXyiwXNtO/e1sOHx1l
	7A8K9UnTu92mJhEB+jf4w1cbDzsi1bQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3oY+2u/Y";
	spf=pass (imf23.hostedemail.com: domain of 3PJiUaQYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3PJiUaQYKCBMBDAx6uz77z4x.v75416DG-553Etv3.7Az@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771345981; a=rsa-sha256;
	cv=none;
	b=JgTd4zU9ScKqzK2M6SbkA7MCJprmwP6E1T2bRxcUrNHvrS/iU9Ar1Top8dNU1iYjFSOYPS
	15oVMXitKrg2N+fTTID8rLwy5jqPlqoC8SJ2smxzWUjl1bI8X6iAM/eoHWILbqKULX6myy
	Sduwo+Fe+3Jes2t5BGCUBAc0fKwEZi4=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12721cd1a2aso3728674c88.1
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345981; x=1771950781; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9Ark9R30Qkzih8r6uy5tMYPv262iFz804WfSXpH0hs=;
        b=3oY+2u/YureaKPaoKmE8eCUiNOg00QW6HYEJ6ZbKw/OyiP98F9Ccde+Runv9zjFty2
         Xx7Mnf91dGpd+/QazVlqNjbfXx9hlVuef1JM0d/Z9gjRRPJlmBxVNgVxwg6MDTPOw+NA
         eRMQxSUFlGt/ScDr25gQoNWn/j6KWSTdYLZ//qVloao5lOgJL+GygdNAAbrce6wRxE9a
         +y18Gv2RPwrhK2K9efS/i+4zVuXheiSql0LIOJxQewBJ9+qJIqjrfcFz3tmb/Fe0RMa7
         ANAMlpMYwbG3Rf1Kfre+dy655Z9o5lN5X7MzOVtH5jFy/zW45HVq37AbjzK2/H9Bg2CT
         gFOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345981; x=1771950781;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z9Ark9R30Qkzih8r6uy5tMYPv262iFz804WfSXpH0hs=;
        b=QAz5Hvima/kIc7VDIsU1TOATj6y551mBfIpRbvOMXkb/aUTpocPk7RONq/vUhRJm1u
         piZkYqXmQEeoPqnLzw23mL9nCuG9ZL4xHEPWeIGbRGPeCZ3mpmS7ZyYH6bsFYBC6ulkV
         3boBaPdM9v+Swb38LfYdjnbQo7M7GdHOCtFo8GBTKBA+nb0aY/svE0yMUJkB3AJykCsE
         +L4vmGofAwk30GjZQHE1EWGeAGV2qd5SmbxrxzuAWQ0cyrceGVO5BS0KxXeGDQzWPB0u
         5j/oXRsmR9G5N1GKApPTQRe3b+z0z2SvJEXTeWmcBtKHbrE1eFqUpBqHsz7fquWi8zYt
         gu5Q==
X-Forwarded-Encrypted: i=1; AJvYcCW1mLVqA4CUfpGq+hg2jpDKDohFtty6i0GzdOZrPSMUGIkkcu+CN/oPIFb3R5tZBSZSUaNTJljzlg==@kvack.org
X-Gm-Message-State: AOJu0Yyv+TXC/FB9zfEwNap47LNvOol6F22v5Hzq4Tup3O2BfQsrfNr4
	yaqwkYfBS/cDELpDrdwlqI5EyozKQa1aFJZqKXbk0gwYwNJZEoClweWhKbj/2FRuOL7cLIR22y1
	jPpZKJg==
X-Received: from dlbvt13.prod.google.com ([2002:a05:7022:3f8d:b0:119:49ca:6bae])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:250e:b0:11d:f440:b743
 with SMTP id a92af1059eb24-1273adf34c5mr6016405c88.7.1771345980160; Tue, 17
 Feb 2026 08:33:00 -0800 (PST)
Date: Tue, 17 Feb 2026 08:32:50 -0800
In-Reply-To: <20260217163250.2326001-1-surenb@google.com>
Mime-Version: 1.0
References: <20260217163250.2326001-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.273.g2a3d683680-goog
Message-ID: <20260217163250.2326001-4-surenb@google.com>
Subject: [PATCH v2 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
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
X-Stat-Signature: 8zhd97g1cg44ud1ftqkierzzkhtfsd81
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: D4ECB140013
X-HE-Tag: 1771345981-908830
X-HE-Meta: U2FsdGVkX1+jgnR+4eGnOn43RfeSiae9nFeU7ll+F8PS2FJRhJt2KFQpvVjTuURcJMYmLGpaL01nbWN6TMZKXc05WunrZcD0F0HIIaUFGv0CVl3PfOuHKcecSsPOlDzt0i6QL+GAnpeg9zkRnKNbaF9wZFCDHFefzznlybCeRd/qJI/y/WNuptmFHFenCsyOm56ABPxfPj91DDbu9c4onhdKzaHkN6+YjF9xJB09gu4B7S/FNQVbUqwIK52oP9pxMYlKFt6dXZobZ8R///GIW4VEcbEFbEcM916qDmwtjaLPnChiVt3ChDLhFgr0/Pe/ANVBy/INEDkSGibJVWENfTrfLVqRN6lb+LL5Er01auAGBKk6rt1CQ1NzaMaq0/q6IYO45ZQx6IMLkK3SlM97opICpA3KLNMZwZ54nyO6MFxS8d5l1OS65s/nVptVUYbWBSHrE8K2qzAsAiTxs35sm8BuHyHwFQeA3sS4J3n/RiKrMP6GIZa/wSiJPIF1LxZXdnd+tixNpMoxBttPC1JJpkEaaEhUC2UH9jj781obOCnQSFBBYcZN4SuqUA7Jx7HA1sMFLITVCX55qygcSHUqsyx6Th9j6vZOV3z7toaiypDtFi1QWXbA99NNwnfAqgKe/EMe/mFNnuMKF0XLXbm+tiwMYbIZ9HVCKBsH8yE1zNKd/KDCAiWr0wfQ3FuEXSNy7EbJAGBddcFXS/QZHQDolV4bPA2P88/N+8QThFmm2hrhXrrjxlgEVu6qiALxEqt8bC7WTosTYNyWmK9f4D3WQnGItWR0MwiCAn8xJBa4sRdzCLISU5Y3yXt5VQAVgOZLu7uOnKkEyH2YHqVD70S0In2PmGCwDb66HLCJXKfqxbj0c+yKYun4M36Tobq20ZUumjkhVMQD3CTaeo/6Nsl9B0EU0GHF9ubJf0uBwnprd1YmFC3/NKrDeDmE4KQVvDXUzLarE2lk3jgEf0CuLsp
 u8f/+4u3
 ft2VwM5oXQzyHFx4lt23XWyO77Vh92LGUtgih8fUFH6mYDkF7V37BZqKOzNR5kGeLda6RJ2rQaPTq2az5R8TSToeNP96Uld1K9gaZCrUuHzQ/NzxWcjIZj2q0NenRcj18z3y/oY5DomCJPdj74gHrI4dHYZw3b5BNhiCeVfUjagfCWaL6PpocQxHKnIRHFNLKaeIVbGitGthmluEZkgCHiSHLGrFZ1kgNt0wm1OWPlExZBgOcSLvKzkeT1pdZ+P97Hc92UX0OVRJb2tjOp9mN7pWTvkUUc82IKL18fUJzIuIWVbiRSUiCbqk2WaCVAWgssVEIlhK//9nvD5YQAiSpzT8TLjYnsuiJcH3S9p8zR8ULtp9oVIkCxmNyAFVlVJezXZ6jdZ929MyMGdSpxAxU+Kk1FfIDKfEsQ6rfwHT7CbnissytFU0oMxrn3VLEqFnZjTaUDqF9gbv6IknRSAqX3n4AFB6zLT/sLZVw7P0uS+s54yM7i3+04mWZtmWF1qBaR+ZWrNbbmnUkk1NEYGrstpxQgAZ+665D7JFqVX6PHHmEQ78YbRR+5JNt92o+S+kvJfARK+VXtwvLUYrk9aDX5XKcDIgwfrzYX0AJwvnAvQCHKKBD/v4IE83i39TKchqizRkwD1k6X45gjpRg+/ELazjQL0QXD2La8mhIMBVd6uJ+vx9myQ+IUP67dKgC9v+2n8nhMQH3ttOEPJhqe5QRcMIov/TtVGWlE9pIW72Lt0Vz4zZ/HIM1cDrPHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace vma_start_write() with vma_start_write_killable() when
process_vma_walk_lock() is used with PGWALK_WRLOCK option.
Adjust its direct and indirect users to check for a possible error
and handle it.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 arch/s390/kvm/kvm-s390.c |  5 +++--
 arch/s390/mm/gmap.c      | 13 ++++++++++---
 fs/proc/task_mmu.c       |  7 ++++++-
 mm/pagewalk.c            | 20 ++++++++++++++------
 4 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 56a50524b3ee..75aef9c66e03 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -958,6 +958,7 @@ static int kvm_s390_get_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
+	int err;
 	unsigned int idx;
 	switch (attr->attr) {
 	case KVM_S390_VM_MEM_ENABLE_CMMA:
@@ -990,10 +991,10 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		VM_EVENT(kvm, 3, "%s", "RESET: CMMA states");
 		mutex_lock(&kvm->lock);
 		idx = srcu_read_lock(&kvm->srcu);
-		s390_reset_cmma(kvm->arch.gmap->mm);
+		err = s390_reset_cmma(kvm->arch.gmap->mm);
 		srcu_read_unlock(&kvm->srcu, idx);
 		mutex_unlock(&kvm->lock);
-		ret = 0;
+		ret = (err < 0) ? err : 0;
 		break;
 	case KVM_S390_VM_MEM_LIMIT_SIZE: {
 		unsigned long new_limit;
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index dd85bcca817d..96054b124db5 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2271,6 +2271,7 @@ int s390_enable_skey(void)
 {
 	struct mm_struct *mm = current->mm;
 	int rc = 0;
+	int err;
 
 	mmap_write_lock(mm);
 	if (mm_uses_skeys(mm))
@@ -2282,7 +2283,9 @@ int s390_enable_skey(void)
 		mm->context.uses_skeys = 0;
 		goto out_up;
 	}
-	walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
+	err = walk_page_range(mm, 0, TASK_SIZE, &enable_skey_walk_ops, NULL);
+	if (err < 0)
+		rc = err;
 
 out_up:
 	mmap_write_unlock(mm);
@@ -2305,11 +2308,15 @@ static const struct mm_walk_ops reset_cmma_walk_ops = {
 	.walk_lock		= PGWALK_WRLOCK,
 };
 
-void s390_reset_cmma(struct mm_struct *mm)
+int s390_reset_cmma(struct mm_struct *mm)
 {
+	int err;
+
 	mmap_write_lock(mm);
-	walk_page_range(mm, 0, TASK_SIZE, &reset_cmma_walk_ops, NULL);
+	err = walk_page_range(mm, 0, TASK_SIZE, &reset_cmma_walk_ops, NULL);
 	mmap_write_unlock(mm);
+
+	return (err < 0) ? err : 0;
 }
 EXPORT_SYMBOL_GPL(s390_reset_cmma);
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d7d52e259055..91e806d65bd9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		struct clear_refs_private cp = {
 			.type = type,
 		};
+		int err;
 
 		if (mmap_write_lock_killable(mm)) {
 			count = -EINTR;
@@ -1824,7 +1825,11 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 						0, mm, 0, -1UL);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
+		if (err < 0) {
+			count = err;
+			goto out_unlock;
+		}
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
 			flush_tlb_mm(mm);
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a94c401ab2cf..dc9f7a7709c6 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
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
@@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
 		break;
 	}
 #endif
+	return 0;
 }
 
 /*
@@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
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
@@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (start >= end || !walk.mm)
 		return -EINVAL;
@@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(start, end, &walk);
 }
 
@@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		.vma		= vma,
 		.private	= private,
 	};
+	int err;
 
 	if (!walk.mm)
 		return -EINVAL;
@@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
 		return -EINVAL;
 
 	process_mm_walk_lock(walk.mm, ops->walk_lock);
-	process_vma_walk_lock(vma, ops->walk_lock);
+	err = process_vma_walk_lock(vma, ops->walk_lock);
+	if (err)
+		return err;
 	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
 }
 
-- 
2.53.0.273.g2a3d683680-goog


