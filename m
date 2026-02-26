Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A952DFC5905
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:06:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838EB6B0099; Thu, 26 Feb 2026 02:06:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CFF96B009B; Thu, 26 Feb 2026 02:06:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A0B6B009D; Thu, 26 Feb 2026 02:06:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5262A6B0099
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:06:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 116AD160A00
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:23 +0000 (UTC)
X-FDA: 84485724246.06.3CB81C4
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3086C20004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="SA/xKPxf";
	spf=pass (imf03.hostedemail.com: domain of 36_CfaQYKCKASURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=36_CfaQYKCKASURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5I1QOj3Vyf2nTpPPlemTkxt7qh7oWHe4YCv7YkUsRic=;
	b=XRyuoXEbabf03jiAMMQQuN44ba95SysGcNLfBnQImk3T889jj0waIFgAxggoNOoDlF/8DS
	R1SKOwKoSiiktfflY/MPP7qQGNtt+GMkHvBzSgcJvkuZqcYEdRFe/Co4pCNr3UiVjZDBH9
	dZISbsNtlTy+qxuUO+6LIQtews5wo6Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="SA/xKPxf";
	spf=pass (imf03.hostedemail.com: domain of 36_CfaQYKCKASURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=36_CfaQYKCKASURENBGOOGLE.COMLINUX-MMKVACK.ORG@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089581; a=rsa-sha256;
	cv=none;
	b=HZh9tD4WT3CDmBegJMVm+sDU5D0sH5X98rln4l1pWicojUlqtskcU+YhsIypI9zDFw6pUS
	BeB/7jRd82zudh4xrABhtAsKjo77YdLqjRDnPfz7kXoWL6I5KxX9AhG/xPPCdrfMfzg2qu
	D2n+aTfl7MW/fL8/IqlK/hVrIS0Eq08=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bdb58f18f0so6636848eec.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772089580; x=1772694380; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5I1QOj3Vyf2nTpPPlemTkxt7qh7oWHe4YCv7YkUsRic=;
        b=SA/xKPxft08Qo/IbxfFzvKsku8uTbnhl8aWTCPQjCEa+GyMmtp+Z9jSCEDaW5izyTA
         n5afPJcfD+lwJ6l2OYPk+WHMVSc1+mEduLh7GaUPH/MEZxLdYEDViHUyN7YhJjThTayq
         c1aZYHVVxgltbJcQwHcYGz1ye6f8nKr+lcW2B7bdiOq/9fhwjB62aAj1GAw0xqNsSAgA
         q12ofT4cE/RX2bqc3x8plzcYUxN7ezzz/x5oC8rdnJIqqrfPznnZkVgO6qvfNU8md5WJ
         IA4tk7ErlZKNe9Kc22ExWGdKVCYgq2IbLqnmomx2/aOIZEU9GSMR9yPQmJwz77OHo0aT
         ov/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089580; x=1772694380;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5I1QOj3Vyf2nTpPPlemTkxt7qh7oWHe4YCv7YkUsRic=;
        b=q8M6XGPe452p0GhDeT3lwCSWW7rDDGAYB8oKlCxNN+BILXbery+JUiSQXo0EEkDOoc
         kZYgtpBA/MQIgPfqdfOL4hxcLf7ixCzu5WWnHTyPgwd68KWfcajLkv21P2IAoJKapIzR
         aA8h9MQmAHOW5kD8unsaz2qNHPscx7zd8S1WElKJSpxdsM9IayFrDoX9PhJfRd2qr0Ac
         vCk5igZEwwhc2Bq5gc10g8/94F03xKj28Gnh4eFg44APIy8jrHAT8tH5xrfIY6p+j2jl
         +f9w+RB+hW1ZLUMtOtq218MoIvcR6pUDv6h+R1EdipJkrc4wrP+PGZiVCmKWLh4xgY6s
         u95g==
X-Forwarded-Encrypted: i=1; AJvYcCXwVL5ltVGL5Bnv6NO4/WwWd4Ue6bUKCIcQcjQ9CEITfnN1z8TeIqK+RTzoc16NV5UUQiPRMt5Vag==@kvack.org
X-Gm-Message-State: AOJu0YyNaxvet5GJsnHrozFVjwiWBMKDmCZe8iM7b/NCMk2bZVh/mYwK
	+O4SudQuwEakt3fHlWk/ZjXoYyplBTwNsBX0lBivtIbuQ3xFHMVYgTMWv2J9lsXeVpAB5LV/M33
	7HNRXTg==
X-Received: from dybri2.prod.google.com ([2002:a05:7300:f082:b0:2bd:c0e6:3762])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7300:4348:b0:2b4:5b59:af52
 with SMTP id 5a478bee46e88-2bdd301cbc8mr527999eec.29.1772089579483; Wed, 25
 Feb 2026 23:06:19 -0800 (PST)
Date: Wed, 25 Feb 2026 23:06:09 -0800
In-Reply-To: <20260226070609.3072570-1-surenb@google.com>
Mime-Version: 1.0
References: <20260226070609.3072570-1-surenb@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226070609.3072570-4-surenb@google.com>
Subject: [PATCH v3 3/3] mm: use vma_start_write_killable() in process_vma_walk_lock()
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3086C20004
X-Stat-Signature: 41c8b6mhyw8eiskjcda36nrhgpd9nwd5
X-Rspam-User: 
X-HE-Tag: 1772089580-619376
X-HE-Meta: U2FsdGVkX19uou5sH5Xk8UTPvoiatH7JespMCzanJAG7pA4FC2wHTxETSZ8LPaoaNSASA5DCXUhcy6zB92cKC8lcqh7F592/cnl1ZZj7jZoH4jMnL2BOyCBL+m9HKDFN4pr44bPlRk2W5fX+NNvzYxOLAPRCOBj5ZtksvOEcBMfJfwktM5kWR0fBL5SHWRkUyr0hRJpKdPkwZEFyc5H1VOQMQKhYXHoKSPExBASi0J2hBW8RS6OBUwuj3pzmK5tz7Gk9AC9QxEBN5MplNIB4cc3CO7T1V+LQBQ/vdc8qrJCON6Glri4DIjYjSbz4Z39h/g7Jma9tveYz6ocNpaHNxutP0C6VrJq9sipfV4QOGFpyknRym2b/+SiI4kp8J8zRCMAjy7wYDsl8vBvNy+AYjQUdEFpz27iBQeNdcvp80dFCtDiyqyxTf+vnrFemxrtv10xnfiRoWagjGVKoNQXQ3Ll0nOv3axi3I8rk2ZWzwpskO5zW0qoEjFX1bnTiccBItNHlKN71ck2bTdxFPOgfiVhSIn2nJAoLz0amjbzTiRgrSkrnyy1mtTBG+BBeQ7WGBASVhWenMYDf1O2GOm79HO4Azkqz0VUl7QZ6OVJrywNz4BgSeJc4eE00XghNaN4zk4CIGj2vnL047wW25anw8v1uwAxASmObFkkFlL+HhjdV87TbbZMicCnngRF1ABKo11IjhxL7JHIroFwYcrQgHO1ff60I68EoeAJrKrUVTqdQNpECoThvct5mZy6N47oCAT3r8KTV26mqBkz7VBUIN24jX9kcItpL6en++Am2BSzEaK+q1rOqwb5OESRLAaTxBrj1ZtFL9WHRhUTtbX07TPKlcumKlUcQ5s/ZnsG8L6LW9Ii02ISImw0mvToH3V6OWWpCZMQyu8/WeCQgsaX6ie1rQizc2boYzy1pxtFS9b4x0OrPBh1BGHEApTCajP1n7ZCB8BwLK0fHJLJsg4t
 byOCeGzX
 My3g5s4Cq7nfNByUwp5bTw5Hx/h0KRCjYTLrjQE8Fxld7wnzz+5R2Oo8UlTrFZeu27+J+1epYn2d12NrfD8tSrp6LKyfM0Dgwags0U9KYFeYavnAVWV7M53KaigzZ+zpRE//N9VPCC0dUyx1ul4nfsqiFZ4rF4rAhJl57pRnqd4eM9nc5ZBGN9lvj4I3kXK32iKN/gqslPbC9Uc3ZzKWi73/gheSU5Mt8j1GHZD6oW89ujEUAd+MxzF5/pQinc1wHPSmPlJYd4gPcTNYecd1N/RAAQUSHJs72sUnZKgkBkXD53jH5hmSOF+T46Xg//pVOV45Hb4Ns0aDcfwuM481EOuquHYCBNJ4SFKj7F7t2VZXcalQwGK3mgFViOvBA0Mcgrw1EiqNztDx5EbabpAEU4EdkY7l6YEjaEUfvT8eWHuUMjYIaWo3EymhEpyL+I5/EyPxeLMz2SAQsr3VGOy9nnbjZYo7Ohuy3dYOxj60GS7BCh5Ii4FT422xfzw1fXohfmpt1bWk8TXjPIswvALNJa2I4BtHp51MhsOD/4OScNarg13d5rNGBj3DBZh4k1K4uDxQrC1YvvKr9yMBN+wJxilFAP8l76vAM0zCs1T1xYYOm07wV/zMf3On3p39oMVESxNrFgquUpVzVxPWrBpOi95pkQqAL3wqCbLUT2vGNARnmJeMB8TUDVzbq8PHQMGpw4Aqz1QJrn+hvp3YKl36l/VfqXdVjQIp0UtuvJNGNax+XN5MQ3u5i689Eng==
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
 arch/s390/kvm/kvm-s390.c |  2 +-
 fs/proc/task_mmu.c       |  5 ++++-
 mm/mempolicy.c           | 14 +++++++++++---
 mm/pagewalk.c            | 20 ++++++++++++++------
 mm/vma.c                 | 22 ++++++++++++++--------
 mm/vma.h                 |  6 ++++++
 6 files changed, 50 insertions(+), 19 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 7a175d86cef0..337e4f7db63a 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
 		}
 		/* must be called without kvm->lock */
 		r = kvm_s390_handle_pv(kvm, &args);
-		if (copy_to_user(argp, &args, sizeof(args))) {
+		if (r != -EINTR && copy_to_user(argp, &args, sizeof(args))) {
 			r = -EFAULT;
 			break;
 		}
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..1238a2988eb6 100644
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
+		if (err < 0)
+			count = err;
 		if (type == CLEAR_REFS_SOFT_DIRTY) {
 			mmu_notifier_invalidate_range_end(&range);
 			flush_tlb_mm(mm);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 90939f5bde02..3c8b3dfc9c56 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
 			&queue_pages_lock_vma_walk_ops : &queue_pages_walk_ops;
 
 	err = walk_page_range(mm, start, end, ops, &qp);
+	if (err == -EINTR)
+		return err;
 
 	if (!qp.first)
 		/* whole range in hole */
@@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
 				      flags | MPOL_MF_DISCONTIG_OK, &pagelist);
 	mmap_read_unlock(mm);
 
+	if (nr_failed == -EINTR)
+		err = nr_failed;
+
 	if (!list_empty(&pagelist)) {
-		err = migrate_pages(&pagelist, alloc_migration_target, NULL,
-			(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
+		if (!err)
+			err = migrate_pages(&pagelist, alloc_migration_target,
+					    NULL, (unsigned long)&mtc,
+					    MIGRATE_SYNC, MR_SYSCALL, NULL);
 		if (err)
 			putback_movable_pages(&pagelist);
 	}
@@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, unsigned long len,
 				MR_MEMPOLICY_MBIND, NULL);
 	}
 
-	if (nr_failed && (flags & MPOL_MF_STRICT))
+	/* Do not mask EINTR */
+	if ((err != -EINTR) && (nr_failed && (flags & MPOL_MF_STRICT)))
 		err = -EIO;
 	if (!list_empty(&pagelist))
 		putback_movable_pages(&pagelist);
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
 
diff --git a/mm/vma.c b/mm/vma.c
index 9f2664f1d078..46bbad6e64a4 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
 	if (anon_dup)
 		unlink_anon_vmas(anon_dup);
 
-	/*
-	 * This means we have failed to clone anon_vma's correctly, but no
-	 * actual changes to VMAs have occurred, so no harm no foul - if the
-	 * user doesn't want this reported and instead just wants to give up on
-	 * the merge, allow it.
-	 */
-	if (!vmg->give_up_on_oom)
-		vmg->state = VMA_MERGE_ERROR_NOMEM;
+	if (err == -EINTR) {
+		vmg->state = VMA_MERGE_ERROR_INTR;
+	} else {
+		/*
+		 * This means we have failed to clone anon_vma's correctly,
+		 * but no actual changes to VMAs have occurred, so no harm no
+		 * foul - if the user doesn't want this reported and instead
+		 * just wants to give up on the merge, allow it.
+		 */
+		if (!vmg->give_up_on_oom)
+			vmg->state = VMA_MERGE_ERROR_NOMEM;
+	}
 	return NULL;
 }
 
@@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
 	merged = vma_merge_existing_range(vmg);
 	if (merged)
 		return merged;
+	if (vmg_intr(vmg))
+		return ERR_PTR(-EINTR);
 	if (vmg_nomem(vmg))
 		return ERR_PTR(-ENOMEM);
 
diff --git a/mm/vma.h b/mm/vma.h
index eba388c61ef4..fe4560f81f4f 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -56,6 +56,7 @@ struct vma_munmap_struct {
 enum vma_merge_state {
 	VMA_MERGE_START,
 	VMA_MERGE_ERROR_NOMEM,
+	VMA_MERGE_ERROR_INTR,
 	VMA_MERGE_NOMERGE,
 	VMA_MERGE_SUCCESS,
 };
@@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
 	return vmg->state == VMA_MERGE_ERROR_NOMEM;
 }
 
+static inline bool vmg_intr(struct vma_merge_struct *vmg)
+{
+	return vmg->state == VMA_MERGE_ERROR_INTR;
+}
+
 /* Assumes addr >= vma->vm_start. */
 static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
 				       unsigned long addr)
-- 
2.53.0.414.gf7e9f6c205-goog


