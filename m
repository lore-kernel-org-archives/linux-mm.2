Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24033C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 23:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF7D46B00A4; Sat,  4 Jul 2026 19:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEC66B00A5; Sat,  4 Jul 2026 19:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5F96B00A6; Sat,  4 Jul 2026 19:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 974FC6B00A4
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 19:19:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F229FC3ABD
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:05 +0000 (UTC)
X-FDA: 84952661850.13.EF5CFA5
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24380100005
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:19:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hUr/5pSg";
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783207144;
	b=NXie1WLGPElsSl/9S7MGJmgdJ/KLSGk8AU/ZwQP2+bXhErzksBWPfirMnnqW7Yi39/4Rts
	VbPILfaNRvXHlqkuPwRkJEYJzn1kM/v/wecBRbJ14DvBj5Dfkk51ILYOtIQWUBLEveXHt+
	TwMFCPlVxWZvVfFbU5WwX7ifpmdgOY0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="hUr/5pSg";
	spf=pass (imf05.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783207144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqtkRQqinAG6Jrz4LGBXeDHuxEf95XV0d64FHPSxb0E=;
	b=vEx5Z4lCT46J2DkPxy04dKKqy0A4tSqK7n8h34OSFEO1c+8MCRzz6J/kszoX9MLTy40h1l
	UYvjJ+5pAzzzzXhScE1aSbO0OBUpzqQosVWFDlxf9nuT78mSKPYpQsTu1IvLEH+7metds0
	bvDPOun4/SsjhFVRfYsObJLM99M837Y=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c821a50615so13904015ad.0
        for <linux-mm@kvack.org>; Sat, 04 Jul 2026 16:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783207143; x=1783811943; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BqtkRQqinAG6Jrz4LGBXeDHuxEf95XV0d64FHPSxb0E=;
        b=hUr/5pSgl88DTtwZWvqLpkNxgUqLCAcHMrppmeKejYhkpU3VBL/T3BQwIoyBKf6I/3
         0JK1OHIjPjHXSoSwudMociGUOL6+KK9gYMgbIA8y4g4EN0HZ8ZyO8gNPiSFMUymXQjsp
         kS+US2tquMupJ7JHcgKDT+fMN8q4ZySpQlKgRluSXwpBvaUdU+F6PIhHITR9ZmxQp4x+
         jOZJyqvtjzr1zaCQylAMncLQWg2CYCjzbnH6Oq1wtyqBURsTXcH6g7EWvsmmC7XDCw3D
         767spA1LZDXrtSd1w+CvMmVvJLLHJPGM0gQCk1/fmK+UfD3I3cPCq1nMmWd+6OB8Lpri
         2YHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783207143; x=1783811943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BqtkRQqinAG6Jrz4LGBXeDHuxEf95XV0d64FHPSxb0E=;
        b=Wf6lsNj/UxeV3MPEZhxitfmtQmW9Zsdl4uAfUlLs/fwhkY50S2H/Y4rKYXsgR2Ey7R
         DjS+UEkHMjSadw5goKwnHJvsC6n1YLvizjlwMijaB3OqHUiig4DxW3zh+7st32PvOS0o
         /tbpmO/GCcJ+Kah00dJNG6poJamJ5E4JBpBOoivAysLmiB94jDqfh6LOFkeM/W3OdrEj
         mCu6WLypYTz7z2ARzbi1L25Hv/jI4YpqTi6EkgwIM3OtxKQalubP3+tGWTlQ1YP0EGhG
         F6fyYfqQQ+mKT6MwT+d3HnQKmjXplXoP240IvBiSKoYu0cCPppv/nVyDkyCSpgTjWOwu
         2Z0A==
X-Forwarded-Encrypted: i=1; AHgh+Rqukvr22GWj8Vr9Y1BOmhejuFhS64+FgBvGYlt9G77Rmp8Cdbw/fUic1to3gDQa0AWc+HNh8Uh+Bg==@kvack.org
X-Gm-Message-State: AOJu0YxWJYWliDasS0i/Ya6RBZtMoqiQMt7viycXUXKbBovJf5Rp2dZN
	zwYyEzm/KcbxWMgfV4oBj2vcDbYi3ul5zZ+Atbj7UQhv1RPLN7t507ObSlAzhQ==
X-Gm-Gg: AfdE7cn91OMmfMQN5BT8wHcdjXRULKLJ3t3NcJP4Ij9PAlUd1kxSIFvVFJnX/17JxPH
	nMbxV/c1a/VYHmQ3TguimkfHd5zu9xzkRPNqQ9fOm16gw/fdc+vAIRCUBGWhgEFUObBn7JwIP/x
	qgfldXW0I1lg28f2ppGdqRtoTwvNNbXZYbttavZSEX8Prg5wAuXWNKkocEbbD0LJV5lG3bhFVOQ
	2Qyx2+Mp9PZ2lYa8n41GaaD5dKhDHL8YgUF8vmloCmDArK5hq3zvlb9Mb84rhQ/ut5Gv3spddMO
	rDMgWtDluAsERrhEjDfQQ3KpIHLh0CCpKWkIRazpN1FsyRh6mGFQxSRAZwyT3XGyZTOeVqn2YUq
	pgznDHMS89qISpxmT4vl/GKTE3AqtuLB43j6qpDrsentCOM7WYIW1/EjGurPQSUs1qeGyNrELkM
	iTOu26hz/EpmD8vlxGC6U709uO+Mo3FeBhdKBKSomuARP2Ow48Zg==
X-Received: by 2002:a17:903:46cc:b0:2c9:b48c:fdde with SMTP id d9443c01a7336-2cbb9eb4363mr44524175ad.26.1783207142941;
        Sat, 04 Jul 2026 16:19:02 -0700 (PDT)
Received: from pop-os.. ([2601:647:6802:dbc0:55ba:96cc:892f:32d7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cad776589fsm27088215ad.43.2026.07.04.16.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jul 2026 16:19:00 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v5 1/7] mm: add __do_mmap() and vm_mmap_remote()/vm_munmap_remote()
Date: Sat,  4 Jul 2026 16:18:25 -0700
Message-ID: <20260704231831.354543-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
References: <20260704231831.354543-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 24380100005
X-Stat-Signature: jhk8wxn8xwdn74kynf6muqkqt5gmsxw7
X-HE-Tag: 1783207143-650619
X-HE-Meta: U2FsdGVkX18DK/tqZ0T/mQRggcFZBloMYQikiJeMfGFMNpqjbLTKBTiTiNqoY8/M4UvGkq0elssVq8o+quf1erxT973RBY0x/e+aZuuE+abYliRtcVreeZlStSSIvPR1iiCtp4co+SPMEiIgaw5cHqdnqWmfi9+0RAdxjBAqmPV3KxMBkCbNfu995h1c0NU24vmtUO9oFIicjusKgUofAa5BXKXUZXGLAVzF5660zZZn4271NW+9Y+simjVBvsXyLwSrYWrSDeImy//OAhCi8IQR0NJQvQ7XPvZWieMb5oMPOIrD0fWgBVHlHnxUhxJPB+NMSOKcT2S+rZKLNQj5VZaKsmIPxUaT4UX9yjR1VKCsbDBZ+R5QEbBVkkXOHV15CyJtbFwZRwu3zrtpy5wqdHCrvJQH2Yh8Q0r6EMUBunptVgGUEVazUhAZNiN7xUSeeHXj+gCsPbFggkiiFteJMiLqDSz4/VK5AaO53MmDZ3XZTEOTfDoT63LhBj9yF8J+rOi19UzTu7OL+UGm2/CcQPc4BJaJrYaU7ex9m8YosEv9qMjSe/mnxY2w1ENVwvggzugRuwmgkVaRIoi7e+bqYha3gl28koNBW9O0XTRy/jdIIl15Oy1qUB565lBeKebU/0pNQ0TMdQ7iYgemQ4VodabUcughEVrkW9QgOy3wO9dSHDVzppS4KZ1K2yH3qgkFS/69n+3+5muou6tpVjStRiqefIe82sCO+AlWBzDR4dww3YrBe5Xl28bFbg2lU1v6+QC/h5e/yUDiIki1h1awJE6TYguwZNRn02EnFqsOdYvE9VFce2BlbKvq89aB8PnIN0AZCAavRlnNOcuL0zrMkq+JLmdn0U2WEpMx7L3Jtln1TlPr+wrhzIkCtOIppWalzMq+4iL5Uqv8MenWZ7HIObPJYgbhGSeyN9GRX5oPteqsaBNctSzeA8vLDEEIE4xIpv0pwDLHkna8fqwiXeL
 +/s3qrHo
 tYJZLQjNxo6VX+xb0T/0Fbjfly79ebjc2EXBd3z6PDXiWZKDUzN1rLnf0i96kG05Gz+5WPQV7FdBbvy3fH9DH/h9iHqrYN9jXwR1SVJjK96UXVolFT2ScqLhAaQz7LKiqr071bs9FdsZg+gtBh2me8OC3bungwEmJ17IudZ/7+SfJrOu0FCokaFrCgOs4nQpRHfbG3ZFDR/QMGJ7Vu4jRlYjZ6Deni2Pmj+S2VaDyBFLgyb3qGe2I4UMGoskuvkZmEIBHJ68HgjZ1YR0/2UcDzYUNy8spYFot44Ot3NTqMe0mcr03Vu4bhPVh44KwA2W7WgOBzwtWCeyPTeGBqDgKAzGiPx53kKWaieAy3WvXNHSZ2rUoqLHF1rz6q5R18X8czpTuhT1KUzawjEuWASDMQg12jSORQrMpB9GtvX44VFFctVPdD6+RktxYbocy6zKwL+k7fMyuSlN9diF2atw3ElSfxLHoTIX2XRNatC59aczNRezJO/WwOLr4l/4KjbpD1Ua5rXiAPRHMStzgPA9vf/r6MAlsqki7bZtN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add __do_mmap(), a variant of do_mmap() that installs the mapping into
a caller-supplied mm rather than current->mm. Now do_mmap() becomes a
wrapper that passes current->mm; it also keeps the READ_IMPLIES_EXEC
personality handling, which is a property of the current task and must
not be applied when a supervisor installs into another task's mm.

mmap_region()/__mmap_region() gain an mm argument so the target mm
flows down to where the VMA is inserted. __do_mmap() is only mm-internal,
declared in mm/internal.h.

On top of that, add vm_mmap_remote() and vm_munmap_remote() in mm/util.c:
high-level entry points that install / remove a mapping in a
caller-specified mm without target-side cooperation. The intended
user is seccomp unotify syscall redirect.

vm_mmap_remote() resolves the placement against @mm and pins it with
MAP_FIXED, so __do_mmap()'s get_unmapped_area() path. The remote area
search (mm_get_unmapped_area_remote()) bounds the address by the
target's mm->task_size, so a 64-bit supervisor cannot place a
mapping outside a 32-bit target's address space. MAP_FIXED_NOREPLACE
keeps its -EEXIST semantics for callers that pass a fixed address.

LSM hooks (security_mmap_file, fsnotify_mmap_perm) run against current,
the supervisor installing the mapping, not the target mm's owner. This
matches the supervisor-installs-into-target mental model and parallels
pidfd_getfd()'s cross-task fd install.

Cross-task authorization is left to the caller; this primitive performs
no ptrace_may_access check.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/mm.h |  5 +++
 mm/internal.h      |  8 ++++
 mm/mmap.c          | 87 ++++++++++++++++++++++++++++++++---------
 mm/nommu.c         | 22 ++++++++---
 mm/util.c          | 97 ++++++++++++++++++++++++++++++++++++++++++++++
 mm/vma.c           | 35 +++++++++--------
 mm/vma.h           |  6 +--
 7 files changed, 216 insertions(+), 44 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..2cff6f4e3bf8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4152,6 +4152,10 @@ extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
 	struct list_head *uf);
+unsigned long vm_mmap_remote(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long prot,
+	unsigned long flags, unsigned long pgoff, vm_flags_t vm_flags);
+int vm_munmap_remote(struct mm_struct *mm, unsigned long start, size_t len);
 extern int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 			 unsigned long start, size_t len, struct list_head *uf,
 			 bool unlock);
@@ -4192,6 +4196,7 @@ struct vm_unmapped_area_info {
 	unsigned long align_mask;
 	unsigned long align_offset;
 	unsigned long start_gap;
+	struct mm_struct *mm;	/* mm to search; NULL means current->mm */
 };
 
 extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..3d698bccc100 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1436,6 +1436,14 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
+unsigned long __do_mmap(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long prot,
+	unsigned long flags, vm_flags_t vm_flags, unsigned long pgoff,
+	unsigned long *populate, struct list_head *uf);
+
+unsigned long mm_get_unmapped_area_remote(struct mm_struct *mm,
+					  unsigned long len);
+
 extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
diff --git a/mm/mmap.c b/mm/mmap.c
index 2311ae7c2ff4..81a2f64df6be 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -277,7 +277,7 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
 }
 
 /**
- * do_mmap() - Perform a userland memory mapping into the current process
+ * __do_mmap() - Perform a userland memory mapping into @mm's
  * address space of length @len with protection bits @prot, mmap flags @flags
  * (from which VMA flags will be inferred), and any additional VMA flags to
  * apply @vm_flags. If this is a file-backed mapping then the file is specified
@@ -307,8 +307,11 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
  * start of a VMA, rather only the start of a valid mapped range of length
  * @len bytes, rounded down to the nearest page size.
  *
- * The caller must write-lock current->mm->mmap_lock.
+ * The caller must write-lock @mm->mmap_lock. do_mmap() is the common
+ * wrapper that targets current->mm.
  *
+ * @mm: The mm_struct to install the mapping into. The caller must hold a
+ * reference and write-lock its mmap_lock.
  * @file: An optional struct file pointer describing the file which is to be
  * mapped, if a file-backed mapping.
  * @addr: If non-zero, hints at (or if @flags has MAP_FIXED set, specifies) the
@@ -333,13 +336,12 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
  * Returns: Either an error, or the address at which the requested mapping has
  * been performed.
  */
-unsigned long do_mmap(struct file *file, unsigned long addr,
-			unsigned long len, unsigned long prot,
-			unsigned long flags, vm_flags_t vm_flags,
-			unsigned long pgoff, unsigned long *populate,
-			struct list_head *uf)
+unsigned long __do_mmap(struct mm_struct *mm, struct file *file,
+			unsigned long addr, unsigned long len,
+			unsigned long prot, unsigned long flags,
+			vm_flags_t vm_flags, unsigned long pgoff,
+			unsigned long *populate, struct list_head *uf)
 {
-	struct mm_struct *mm = current->mm;
 	int pkey = 0;
 
 	*populate = 0;
@@ -349,16 +351,6 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	if (!len)
 		return -EINVAL;
 
-	/*
-	 * Does the application expect PROT_READ to imply PROT_EXEC?
-	 *
-	 * (the exception is when the underlying filesystem is noexec
-	 *  mounted, in which case we don't add PROT_EXEC.)
-	 */
-	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
-		if (!(file && path_noexec(&file->f_path)))
-			prot |= PROT_EXEC;
-
 	/* force arch specific MAP_FIXED handling in get_unmapped_area */
 	if (flags & MAP_FIXED_NOREPLACE)
 		flags |= MAP_FIXED;
@@ -557,7 +549,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			vm_flags |= VM_NORESERVE;
 	}
 
-	addr = mmap_region(file, addr, len, vm_flags, pgoff, uf);
+	addr = mmap_region(mm, file, addr, len, vm_flags, pgoff, uf);
 	if (!IS_ERR_VALUE(addr) &&
 	    ((vm_flags & VM_LOCKED) ||
 	     (flags & (MAP_POPULATE | MAP_NONBLOCK)) == MAP_POPULATE))
@@ -565,6 +557,25 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 	return addr;
 }
 
+unsigned long do_mmap(struct file *file, unsigned long addr, unsigned long len,
+		      unsigned long prot, unsigned long flags,
+		      vm_flags_t vm_flags, unsigned long pgoff,
+		      unsigned long *populate, struct list_head *uf)
+{
+	/*
+	 * Does the application expect PROT_READ to imply PROT_EXEC?
+	 *
+	 * (the exception is when the underlying filesystem is noexec
+	 *  mounted, in which case we don't add PROT_EXEC.)
+	 */
+	if ((prot & PROT_READ) && (current->personality & READ_IMPLIES_EXEC))
+		if (!(file && path_noexec(&file->f_path)))
+			prot |= PROT_EXEC;
+
+	return __do_mmap(current->mm, file, addr, len, prot, flags, vm_flags,
+			 pgoff, populate, uf);
+}
+
 unsigned long ksys_mmap_pgoff(unsigned long addr, unsigned long len,
 			      unsigned long prot, unsigned long flags,
 			      unsigned long fd, unsigned long pgoff)
@@ -809,6 +820,44 @@ unsigned long mm_get_unmapped_area_vmflags(struct file *filp, unsigned long addr
 	return arch_get_unmapped_area(filp, addr, len, pgoff, flags, vm_flags);
 }
 
+/*
+ * Find a free @len-byte area in @mm, honoring @mm's mmap layout direction.
+ * Unlike the arch_get_unmapped_area() family, the search runs against @mm
+ * rather than current->mm, so a supervisor can place a mapping in a remote
+ * task's address space (see vm_mmap_remote()). The caller must hold
+ * mmap_write_lock(@mm). Returns a page-aligned address or -ENOMEM.
+ */
+unsigned long mm_get_unmapped_area_remote(struct mm_struct *mm, unsigned long len)
+{
+	struct vm_unmapped_area_info info = {
+		.length = len,
+		.mm = mm,
+	};
+	unsigned long addr;
+
+	if (mm_flags_test(MMF_TOPDOWN, mm)) {
+		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
+		info.low_limit = PAGE_SIZE;
+		info.high_limit = arch_get_mmap_base(0, mm->mmap_base);
+		addr = vm_unmapped_area(&info);
+		if (!offset_in_page(addr))
+			return addr;
+		/* Topdown exhausted (e.g. huge stack rlimit); retry bottom-up. */
+		info.flags = 0;
+		info.low_limit = min_t(unsigned long, TASK_UNMAPPED_BASE,
+				       PAGE_ALIGN(mm->task_size / 3));
+		info.high_limit = min_t(unsigned long,
+					arch_get_mmap_end(0, len, 0),
+					mm->task_size);
+		return vm_unmapped_area(&info);
+	}
+
+	info.low_limit = mm->mmap_base;
+	info.high_limit = min_t(unsigned long, arch_get_mmap_end(0, len, 0),
+				mm->task_size);
+	return vm_unmapped_area(&info);
+}
+
 unsigned long
 __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 		unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..1009acbf7bd0 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1009,7 +1009,8 @@ static int do_mmap_private(struct vm_area_struct *vma,
 /*
  * handle mapping creation for uClinux
  */
-unsigned long do_mmap(struct file *file,
+unsigned long __do_mmap(struct mm_struct *mm,
+			struct file *file,
 			unsigned long addr,
 			unsigned long len,
 			unsigned long prot,
@@ -1024,7 +1025,7 @@ unsigned long do_mmap(struct file *file,
 	struct rb_node *rb;
 	unsigned long capabilities, result;
 	int ret;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	VMA_ITERATOR(vmi, mm, 0);
 
 	*populate = 0;
 
@@ -1049,7 +1050,7 @@ unsigned long do_mmap(struct file *file,
 	if (!region)
 		goto error_getting_region;
 
-	vma = vm_area_alloc(current->mm);
+	vma = vm_area_alloc(mm);
 	if (!vma)
 		goto error_getting_vma;
 
@@ -1190,7 +1191,7 @@ unsigned long do_mmap(struct file *file,
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
 
-	current->mm->total_vm += len >> PAGE_SHIFT;
+	mm->total_vm += len >> PAGE_SHIFT;
 
 share:
 	BUG_ON(!vma->vm_region);
@@ -1198,8 +1199,8 @@ unsigned long do_mmap(struct file *file,
 	if (vma_iter_prealloc(&vmi, vma))
 		goto error_just_free;
 
-	setup_vma_to_mm(vma, current->mm);
-	current->mm->map_count++;
+	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
 	/* add the VMA to the tree */
 	vma_iter_store_new(&vmi, vma);
 
@@ -1246,6 +1247,15 @@ unsigned long do_mmap(struct file *file,
 	return -ENOMEM;
 }
 
+unsigned long do_mmap(struct file *file, unsigned long addr, unsigned long len,
+		      unsigned long prot, unsigned long flags,
+		      vm_flags_t vm_flags, unsigned long pgoff,
+		      unsigned long *populate, struct list_head *uf)
+{
+	return __do_mmap(current->mm, file, addr, len, prot, flags, vm_flags, pgoff,
+			 populate, uf);
+}
+
 unsigned long ksys_mmap_pgoff(unsigned long addr, unsigned long len,
 			      unsigned long prot, unsigned long flags,
 			      unsigned long fd, unsigned long pgoff)
diff --git a/mm/util.c b/mm/util.c
index af2c2103f0d9..4c6f44d45541 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -588,6 +588,103 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	return ret;
 }
 
+/**
+ * vm_mmap_remote - install a file (or anonymous) mapping into @mm, without
+ * target-side cooperation.
+ * @mm: Target mm; caller holds a reference (e.g. get_task_mm()).
+ * @file: Backing file, or NULL for an anonymous mapping.
+ * @addr: Page-aligned address. If non-zero it is used as given (honoring
+ *        MAP_FIXED/MAP_FIXED_NOREPLACE in @flags); if zero, the kernel
+ *        chooses a free area in @mm and returns it.
+ * @len: Length in bytes.
+ * @prot: PROT_* protection bits.
+ * @flags: MAP_* flags.
+ * @pgoff: Page offset into @file.
+ * @vm_flags: Extra VMA flags to OR in (e.g. VM_SEALED), or 0.
+ *
+ * The general form of the remote install primitive: a supervisor places a
+ * mapping into a remote task's address space. LSM/fsnotify hooks run against
+ * %current (the installer), paralleling pidfd_getfd()'s cross-task install;
+ * cross-task authorization is the caller's responsibility The foreign mm is
+ * not mm_populate()d.
+ *
+ * Returns the mapped address on success, or a negative errno.
+ */
+unsigned long vm_mmap_remote(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long prot,
+	unsigned long flags, unsigned long pgoff, vm_flags_t vm_flags)
+{
+	loff_t off = (loff_t)pgoff << PAGE_SHIFT;
+	unsigned long aligned_len = PAGE_ALIGN(len);
+	unsigned long ret;
+	unsigned long populate;
+	LIST_HEAD(uf);
+
+	if (WARN_ON_ONCE(!mm))
+		return -EINVAL;
+
+	ret = security_mmap_file(file, prot, flags);
+	if (!ret)
+		ret = fsnotify_mmap_perm(file, prot, off, len);
+	if (ret)
+		return ret;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
+	/*
+	 * __do_mmap()'s get_unmapped_area() path searches current->mm and
+	 * asserts current->mm's mmap_lock, we have to resolve the address
+	 * against @mm ourselves and pin it with MAP_FIXED, so __do_mmap()
+	 * uses it directly rather than searching.
+	 */
+	if (!addr) {
+		addr = mm_get_unmapped_area_remote(mm, aligned_len);
+		if (IS_ERR_VALUE(addr)) {
+			ret = addr;
+			goto unlock;
+		}
+	}
+
+	if (aligned_len > mm->task_size || addr > mm->task_size - aligned_len) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	if (!(flags & MAP_FIXED_NOREPLACE))
+		flags |= MAP_FIXED;
+
+	ret = __do_mmap(mm, file, addr, len, prot, flags, vm_flags,
+			pgoff, &populate, &uf);
+unlock:
+	mmap_write_unlock(mm);
+	userfaultfd_unmap_complete(mm, &uf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vm_mmap_remote);
+
+/**
+ * vm_munmap_remote - unmap a range from @mm, mirroring vm_munmap() but
+ * targeting an explicit mm.
+ * @mm: Target mm; caller holds a reference (e.g. get_task_mm()).
+ * @start: Start address of the range to unmap.
+ * @len: Length in bytes.
+ *
+ * Returns 0 on success, or a negative errno.
+ */
+int vm_munmap_remote(struct mm_struct *mm, unsigned long start, size_t len)
+{
+	VMA_ITERATOR(vmi, mm, start);
+	int ret;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+	ret = do_vmi_munmap(&vmi, mm, start, len, NULL, false);
+	mmap_write_unlock(mm);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vm_munmap_remote);
+
 /*
  * Perform a userland memory mapping into the current process address space. See
  * the comment for do_mmap() for more details on this operation in general.
diff --git a/mm/vma.c b/mm/vma.c
index 9eea2850818a..2f9159ab5123 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2731,11 +2731,10 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
 	return false;
 }
 
-static unsigned long __mmap_region(struct file *file, unsigned long addr,
-		unsigned long len, vma_flags_t vma_flags,
+static unsigned long __mmap_region(struct mm_struct *mm, struct file *file,
+		unsigned long addr, unsigned long len, vma_flags_t vma_flags,
 		unsigned long pgoff, struct list_head *uf)
 {
-	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
 	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
@@ -2809,14 +2808,16 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
 /**
  * mmap_region() - Actually perform the userland mapping of a VMA into
- * current->mm with known, aligned and overflow-checked @addr and @len, and
+ * @mm with known, aligned and overflow-checked @addr and @len, and
  * correctly determined VMA flags @vm_flags and page offset @pgoff.
  *
  * This is an internal memory management function, and should not be used
  * directly.
  *
- * The caller must write-lock current->mm->mmap_lock.
+ * The caller must write-lock @mm->mmap_lock.
  *
+ * @mm: The mm_struct to install the mapping into. The caller must hold a
+ * reference and write-lock its mmap_lock.
  * @file: If a file-backed mapping, a pointer to the struct file describing the
  * file to be mapped, otherwise NULL.
  * @addr: The page-aligned address at which to perform the mapping.
@@ -2830,15 +2831,16 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
  * Returns: Either an error, or the address at which the requested mapping has
  * been performed.
  */
-unsigned long mmap_region(struct file *file, unsigned long addr,
-			  unsigned long len, vm_flags_t vm_flags,
-			  unsigned long pgoff, struct list_head *uf)
+unsigned long mmap_region(struct mm_struct *mm, struct file *file,
+			  unsigned long addr, unsigned long len,
+			  vm_flags_t vm_flags, unsigned long pgoff,
+			  struct list_head *uf)
 {
 	unsigned long ret;
 	bool writable_file_mapping = false;
 	const vma_flags_t vma_flags = legacy_to_vma_flags(vm_flags);
 
-	mmap_assert_write_locked(current->mm);
+	mmap_assert_write_locked(mm);
 
 	/* Check to see if MDWE is applicable. */
 	if (map_deny_write_exec(&vma_flags, &vma_flags))
@@ -2857,13 +2859,13 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		writable_file_mapping = true;
 	}
 
-	ret = __mmap_region(file, addr, len, vma_flags, pgoff, uf);
+	ret = __mmap_region(mm, file, addr, len, vma_flags, pgoff, uf);
 
 	/* Clear our write mapping regardless of error. */
 	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
 
-	validate_mm(current->mm);
+	validate_mm(mm);
 	return ret;
 }
 
@@ -2957,8 +2959,8 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 /**
  * unmapped_area() - Find an area between the low_limit and the high_limit with
- * the correct alignment and offset, all from @info. Note: current->mm is used
- * for the search.
+ * the correct alignment and offset, all from @info. Note: @info->mm (or
+ * current->mm when it is NULL) is used for the search.
  *
  * @info: The unmapped area information including the range [low_limit -
  * high_limit), the alignment offset and mask.
@@ -2970,7 +2972,7 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	unsigned long length, gap;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	VMA_ITERATOR(vmi, info->mm ? : current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
@@ -3016,7 +3018,8 @@ unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 /**
  * unmapped_area_topdown() - Find an area between the low_limit and the
  * high_limit with the correct alignment and offset at the highest available
- * address, all from @info. Note: current->mm is used for the search.
+ * address, all from @info. Note: @info->mm (or current->mm when it is NULL)
+ * is used for the search.
  *
  * @info: The unmapped area information including the range [low_limit -
  * high_limit), the alignment offset and mask.
@@ -3028,7 +3031,7 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	unsigned long length, gap, gap_end;
 	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
+	VMA_ITERATOR(vmi, info->mm ? : current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
diff --git a/mm/vma.h b/mm/vma.h
index 8e4b61a7304c..4f5222ad2e9d 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -459,9 +459,9 @@ bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
 int mm_take_all_locks(struct mm_struct *mm);
 void mm_drop_all_locks(struct mm_struct *mm);
 
-unsigned long mmap_region(struct file *file, unsigned long addr,
-		unsigned long len, vm_flags_t vm_flags, unsigned long pgoff,
-		struct list_head *uf);
+unsigned long mmap_region(struct mm_struct *mm, struct file *file,
+		unsigned long addr, unsigned long len, vm_flags_t vm_flags,
+		unsigned long pgoff, struct list_head *uf);
 
 int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *brkvma,
 		 unsigned long addr, unsigned long request,
-- 
2.43.0


