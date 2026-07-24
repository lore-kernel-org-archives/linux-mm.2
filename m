Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB47CC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:02:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC856B0092; Fri, 24 Jul 2026 18:02:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C4AC6B0095; Fri, 24 Jul 2026 18:02:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECE426B0096; Fri, 24 Jul 2026 18:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC266B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:02:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12D0412018F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:23 +0000 (UTC)
X-FDA: 85025044566.15.5DF5765
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 40B24C0003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:02:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q3UuEwxK;
	spf=pass (imf22.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784930541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SJ13WqemEDPKEjZObDcoideCrDvXpg5YU7m60Etb0C8=;
	b=sKgrZ+oys4/FXDMNF4QjrhT4JgoFEqFFDgrXWH6MSurzTDdQFjsBbxxVpr0PdN6nBt4fMA
	BH1mJ46upsQRL/ZsHDieqdbOeZF0SRTr3z14odg18KThMPvu4Ufg8b/HB9hgvJV9r2MJQ2
	VLm3hjLvUiegLnWlHGK8mSoZ6lOwzlQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q3UuEwxK;
	spf=pass (imf22.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784930541;
	b=DZX9F5ITuO8ir2DOJ+WgEgE0vLA3p5FR9xagJXxLQ5pJdbSLEfk2P1DXBBVsYg1nyGi31f
	eBLIN0l1kn5aBnMVkPAzDA9YA7f7SkLNHZQpy9f1XLsZMeSrx0TIWAHyDEewsUBW2eEwMC
	nTZ80cvuS78iaUZzoXigqqY+wFIXfqU=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-848761b5897so602210b3a.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784930540; x=1785535340; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SJ13WqemEDPKEjZObDcoideCrDvXpg5YU7m60Etb0C8=;
        b=q3UuEwxKIDQVfej5U6PHxK8YF1loVd+wPM23BsCbgAAxCASrIsGw8xmMmNS+CwYTzo
         9jFNXbxt2U1NpM0gN7cf49IJmNRJVjPvmYR9Lm/I7LJj0QYlI0MJzsnqc7FosfrugGl/
         X4/GQ/1I2TGDp/+XzJIJc2csBxQRiJfPpUxhHIyhwdpoqi3XZvdvnhb0Y13P/H68vbXK
         pdSIJjQv5CqtXiMZt6cx594NuImkKpIiuJqwUPcYrdwYaDOpvuCC2z4dY1yOhogLxU+O
         QOGycCOljOsg/hT63DXPhMyg0wuH6MN7QSURN1CmBCrMuBz/lT3dqPz/MBDsCFTm/5y8
         lRHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784930540; x=1785535340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SJ13WqemEDPKEjZObDcoideCrDvXpg5YU7m60Etb0C8=;
        b=YmNZSBYC2eVGTn4NMGKgX5QSvMi89W9UPENe8L0T2aU0eetuzx9vDrSVKByCi8r++j
         tga5xygoczJF51TtmkrJ1y7i+9GI/UDAtmlnFhG1mj42hlxMWPy1teDO8cgHwo2SZywZ
         hULM30jgtgv67PO4rkhI+wb1ze/85SKDzYsG3z/DokU7jZMmxcs2W0D4ABIN13crskbp
         an+XLXRvU6QIBb0SJiy/ONcO2Z9MKG7rQ3ZJqBJOhjxWyNUH/C7jlkrynenfKN7OjwS9
         LmdBPsa5xRERELP66Rh0Hnocj1re3L14TGkH9KD/8li11rB0M+VydP9WfFzpEy2ReUtR
         19qw==
X-Forwarded-Encrypted: i=1; AHgh+RpVCdiOO2xUi8U6H/bVMqTxmrLDEFvm352vjwlJ2L3a54tX1s8u6kLUWAMc6zu1PEsaL6Qn+LUjXQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9B1BDxihlSCFelrWT3Pg6nVvzt9V3wrSTG5rWvme73al5Ch7P
	zK/8wLhZcsuI+IT0gqC0oYqaEzBTQmaPSC7XL1Ikxeqy9tHw6eRyusDw
X-Gm-Gg: AR+sD129o3uf4FUQC4MQzBBaz3j6igg5b8jlr6xS7vdchB4g+o7W3U/y7++XoKLBIpQ
	B7iZ/s5dUCPw5P5BuyYpeAGJueBmWOHhuvrR4JdocNa9cR81hf9QikkbbN52ncpHuToyw7R2yn7
	Wppky1joiHazTM8JuBFsVjDyZOX9zoteEH38CzEMTF0EzPYI+2Q2Qke2kX9L4WZul+ttWg4edGu
	rwZE0lAUdp7zl16+B1SXRretqMJ7lUhMrTPQ6ezYS6UXoN+91l7aYNCGEqVDe+zd9JQM3kmFFeW
	YwP5DRUZK/xlFN+IgnHogEpBeZcjRb8xaOKTJvvUD8Ez4FWiXVpVxVH9i+KNB44NAF5P/b6+MuA
	MQ1MfPkKebF8SHermj6OE0fq0Iq4kAkvF12TABqDOrQXMP0u0qC0mskvLZuUlGnm4jYdGK/iDt+
	AwEpHKPHhp7tcFyfU0kBRdoH+XQjk1CMoR4zmXfQfvUNUSN/Slz68VNFEyQSbd
X-Received: by 2002:a05:6a20:a128:b0:3c3:b57b:6459 with SMTP id adf61e73a8af0-3c67d9b4062mr167283637.7.1784930539791;
        Fri, 24 Jul 2026 15:02:19 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([2601:647:6802:dbc0:546a:e1b0:9574:3a29])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc5a67f3sm2962631eec.29.2026.07.24.15.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 15:02:18 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v7 2/8] mm: add __do_mmap() and vm_mmap_remote()/vm_munmap_remote()
Date: Fri, 24 Jul 2026 15:01:41 -0700
Message-ID: <20260724220147.214396-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
References: <20260724220147.214396-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 40B24C0003
X-Rspamd-Server: rspam01
X-Stat-Signature: 4c1q9rasxydate4386roy7e9w5k7mswq
X-HE-Tag: 1784930541-739826
X-HE-Meta: U2FsdGVkX1/iQlKDFJ5s8FErDVCtxZeiQujd6gcT63wE0DkMfpU/hBmnF6uLkKSD6U4p79dPEwgnkHAyMFe8BN20dDyJWHntIBhmwiA1styb6BOe9SZpWeI4KidH3oQXUrNJtHOPjNqBH7B8JSTnvdStHp7HX29n30S2Dd/mRpbGppBwfke4MIFP5O/asutCtT4nXtD7KwbL7FQHcEHf9HGffgJb2wUZsGqyKSoZw7qRItfLbcFxz4KXFUd0VD6JVpxRZPTKbSIJjBcE0w96G8rxmE7nlWbTzEGcjAAcdaM3ADTVjYTg2ulCV0523bGL1/d1kaA0zXnC9t8FvPrcl86Lx6vrTWSUv7nV57dhCfBQdOE4XfxlvfjQhqdhXSMif34K7Cm/DUSCIZMxhSWmOAm55SuuelnwYF+hRanQrwnNqHKtvpsJgPbZbMnMZecpYvVeRnwP4Ma4dXRF8jCrN6TEnDZhUMzvgPH4oVRk8jT6oZI6L76x29s4S++y5SFOAgmx+60o+KB9qNV8Cuvc/9I77tns5bbwy9NcdtDTzniNZX7AlsBWQ2bkwIizcjYngH/dCe+KQwQV0tdbbxAgLL5ZcqSs4brz4/Z2EzhGNRtHXlF62b8X4cbctjw64w/AKbM03yhKPsZes4ELbOjh06ToKdQStdB+aUUvULr/J5Nqb/pj+j0pfnBThbVyK9VzdCXVjof5BWvFseuCel0vnHaFs3ATUGvca3eJ8I1sCeuTU/UoAYnA3OA/hXJCiLRX8HnTKag6UcKkoAnHw3XPjrfsYh6+HVC2q+i+xHtPxo5Sa4K6C5Mc1ZzOygjzWVrw5UDtI5eOy6qMRm8NHXytvy1SEhq0yD296/Hk2yn3dkWM7s9tWkk8aWKoG6LEXQfVYT0gatP8q77ee5QvYVoaQRpamHZrGueqQHVMQK661B+KdSjBdSaRweTr3nsuvfpKfLbXct4Rpjc5uorxDTI
 4sAZzT1v
 xWFBDE5SQD8K53/dbsrXOEFc64eJ2QnKpq7TLW/PxPYZOnTQnC7TbsZa6VW5nUUb+76bHMVK/GJZsj4VE5RxjxgUgzfepWKZ/C4F02n0bsqOr4hb6/fGIvq3SIpze0SQ0+XdNhM/ry4O/LXR3gw30Bt2d8/v7KBBkMbtHCeNEelb4SFV80yjQ40FrILGv8K/Qwz6aLs+CCvaO1woxB7oRSIToRJAb/mJAJItiol7OkByEZG7zgwP6pMLCmcHI4h3R2EtADikWboAYZT7YjdJbqkPCj9PITUpyRftk32K5quu6ANOelR4pbc8DnZE/szzLSBfpNXlyKMah6rqwhgqTmxdASkZdMR8Fp+8GmIxD71DR1SeflRks+0a7XfsjVXEqpHFSwqUDLsTADq+NAuRhxBat7qyw734ukSiIQG32/vofGpHdgFQhqDVc0482X0CnSvBuCXAlJdkt9GDMjGpIGnIt6svr/MIrSN9CBaKQpCtJSxwk7H2UtLN9CsUzwTacJoAhSiyXSGTQYE1CFPscsZ6XPAk10UVtYH53
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

Add __do_mmap(), a variant of do_mmap() that installs the mapping into
a caller-supplied mm rather than current->mm; do_mmap() becomes a
wrapper passing current->mm and keeps the current-task READ_IMPLIES_EXEC
handling. mmap_region()/__mmap_region() gain an mm argument so the
target mm reaches VMA insertion.

On top of that, add vm_mmap_remote() and vm_munmap_remote() in mm/util.c:
entry points that install / remove a mapping in a caller-specified mm
without target-side cooperation. The intended user is the seccomp
unotify syscall redirect.

Kernel-chosen placement resolves through __get_unmapped_area() against
the target mm, so (via the previous patch) the file's own
->get_unmapped_area() runs and file-specific placement is honored. The
result is bounds-checked against the target's mm->task_size, and the
munmap machinery is likewise threaded with the target mm so counter
bookkeeping and range checks apply to it rather than current->mm.
vm_munmap_remote() delivers the target's UFFD_EVENT_UNMAP.

Both are MMU-only and guarded with CONFIG_MMU, with -EOPNOTSUPP stubs so
NOMMU keeps linking. LSM/fsnotify hooks run against current, the
supervisor, paralleling pidfd_getfd(); cross-task authorization is left
to the caller.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 include/linux/mm.h              |  19 ++++++
 mm/internal.h                   |   5 ++
 mm/mmap.c                       |  51 ++++++++------
 mm/mprotect.c                   |   2 +-
 mm/nommu.c                      |  22 ++++--
 mm/util.c                       | 117 ++++++++++++++++++++++++++++++++
 mm/vma.c                        |  46 +++++++------
 mm/vma.h                        |  12 ++--
 tools/testing/vma/include/dup.h |   1 +
 tools/testing/vma/tests/mmap.c  |   8 +--
 10 files changed, 228 insertions(+), 55 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 560bc369a54c..fa1d96bc379d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4155,6 +4155,25 @@ extern unsigned long do_mmap(struct file *file, unsigned long addr,
 	unsigned long len, unsigned long prot, unsigned long flags,
 	vm_flags_t vm_flags, unsigned long pgoff, unsigned long *populate,
 	struct list_head *uf);
+#ifdef CONFIG_MMU
+unsigned long vm_mmap_remote(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long prot,
+	unsigned long flags, unsigned long pgoff, vm_flags_t vm_flags);
+int vm_munmap_remote(struct mm_struct *mm, unsigned long start, size_t len);
+#else
+static inline unsigned long vm_mmap_remote(struct mm_struct *mm,
+	struct file *file, unsigned long addr, unsigned long len,
+	unsigned long prot, unsigned long flags, unsigned long pgoff,
+	vm_flags_t vm_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline int vm_munmap_remote(struct mm_struct *mm, unsigned long start,
+	size_t len)
+{
+	return -EOPNOTSUPP;
+}
+#endif
 extern int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 			 unsigned long start, size_t len, struct list_head *uf,
 			 bool unlock);
diff --git a/mm/internal.h b/mm/internal.h
index 181e79f1d6a2..6a510a2fd59e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1436,6 +1436,11 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
+unsigned long __do_mmap(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long prot,
+	unsigned long flags, vm_flags_t vm_flags, unsigned long pgoff,
+	unsigned long *populate, struct list_head *uf);
+
 extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
diff --git a/mm/mmap.c b/mm/mmap.c
index 54915ac478ab..23cf45ed22e1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -277,8 +277,8 @@ static inline bool file_mmap_ok(struct file *file, struct inode *inode,
 }
 
 /**
- * do_mmap() - Perform a userland memory mapping into the current process
- * address space of length @len with protection bits @prot, mmap flags @flags
+ * __do_mmap() - Perform a userland memory mapping into @mm's address space
+ * of length @len with protection bits @prot, mmap flags @flags
  * (from which VMA flags will be inferred), and any additional VMA flags to
  * apply @vm_flags. If this is a file-backed mapping then the file is specified
  * in @file and page offset into the file via @pgoff.
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
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9cbf932b028c..02e90577db25 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -939,7 +939,7 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
 			break;
 		}
 
-		if (map_deny_write_exec(&vma->flags, &new_vma_flags)) {
+		if (map_deny_write_exec(vma->vm_mm, &vma->flags, &new_vma_flags)) {
 			error = -EACCES;
 			break;
 		}
diff --git a/mm/nommu.c b/mm/nommu.c
index d6393bd2844e..15390ef5b784 100644
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
 
@@ -1191,7 +1192,7 @@ unsigned long do_mmap(struct file *file,
 	/* okay... we have a mapping; now we have to register it */
 	result = vma->vm_start;
 
-	current->mm->total_vm += len >> PAGE_SHIFT;
+	mm->total_vm += len >> PAGE_SHIFT;
 
 share:
 	BUG_ON(!vma->vm_region);
@@ -1199,8 +1200,8 @@ unsigned long do_mmap(struct file *file,
 	if (vma_iter_prealloc(&vmi, vma))
 		goto error_just_free;
 
-	setup_vma_to_mm(vma, current->mm);
-	current->mm->map_count++;
+	setup_vma_to_mm(vma, mm);
+	mm->map_count++;
 	/* add the VMA to the tree */
 	vma_iter_store_new(&vmi, vma);
 
@@ -1247,6 +1248,15 @@ unsigned long do_mmap(struct file *file,
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
index af2c2103f0d9..a7d499012795 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -588,6 +588,123 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	return ret;
 }
 
+#ifdef CONFIG_MMU
+
+#define VM_MMAP_REMOTE_FLAGS	(MAP_FIXED | MAP_FIXED_NOREPLACE)
+
+/**
+ * vm_mmap_remote - install a file (or anonymous) mapping into @mm, without
+ * target-side cooperation.
+ * @mm: Target mm; caller holds a reference (e.g. get_task_mm()).
+ * @file: Backing file, or NULL for an anonymous mapping.
+ * @addr: Page-aligned placement. Zero asks the kernel to choose a free area
+ *        in @mm and return it. Non-zero requires MAP_FIXED or
+ *        MAP_FIXED_NOREPLACE in @flags.
+ * @len: Length in bytes.
+ * @prot: PROT_* protection bits.
+ * @flags: MAP_* flags.
+ * @pgoff: Page offset into @file.
+ * @vm_flags: Extra VMA flags to OR in (e.g. VM_SEALED), or 0.
+ *
+ * The general form of the remote install primitive: a supervisor places a
+ * mapping into a remote task's address space. LSM/fsnotify hooks run against
+ * %current (the installer), paralleling pidfd_getfd()'s cross-task install;
+ * cross-task authorization is the caller's responsibility. Only MAP_SHARED is
+ * supported, and @flags outside VM_MMAP_REMOTE_FLAGS are refused with
+ * -EOPNOTSUPP.
+ *
+ * Kernel-chosen placement (@addr == 0) resolves through
+ * __get_unmapped_area() against @mm, so the file's own
+ * ->get_unmapped_area() runs and file-specific placement (hugetlb page
+ * size, THP PMD alignment, SHMLBA cache coloring, device dax alignment)
+ * is honored exactly as for a local mmap().
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
+	if (addr && !(flags & (MAP_FIXED | MAP_FIXED_NOREPLACE)))
+		return -EINVAL;
+
+	if ((flags & MAP_TYPE) != MAP_SHARED)
+		return -EOPNOTSUPP;
+
+	if (flags & ~(MAP_TYPE | VM_MMAP_REMOTE_FLAGS))
+		return -EOPNOTSUPP;
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
+	 * Resolve kernel-chosen placement up front and pin it with
+	 * MAP_FIXED, so the mm->task_size check below runs before the
+	 * mapping is installed. The file's own ->get_unmapped_area()
+	 * performs the search against @mm.
+	 */
+	if (!addr) {
+		addr = __get_unmapped_area(mm, file, 0, aligned_len, pgoff,
+					   flags, vm_flags);
+		if (IS_ERR_VALUE(addr)) {
+			ret = addr;
+			goto unlock;
+		}
+		flags |= MAP_FIXED;
+	}
+
+	if (aligned_len > mm->task_size || addr > mm->task_size - aligned_len) {
+		ret = -ENOMEM;
+		goto unlock;
+	}
+
+	ret = __do_mmap(mm, file, addr, len, prot, flags, vm_flags,
+			pgoff, &populate, &uf);
+unlock:
+	mmap_write_unlock(mm);
+	userfaultfd_unmap_complete(mm, &uf);
+	return ret;
+}
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
+	LIST_HEAD(uf);
+	int ret;
+
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+	ret = do_vmi_munmap(&vmi, mm, start, len, &uf, false);
+	mmap_write_unlock(mm);
+	userfaultfd_unmap_complete(mm, &uf);
+	return ret;
+}
+#endif /* CONFIG_MMU */
+
 /*
  * Perform a userland memory mapping into the current process address space. See
  * the comment for do_mmap() for more details on this operation in general.
diff --git a/mm/vma.c b/mm/vma.c
index 9a6cb0338ed8..788c2a0f35ec 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1333,7 +1333,7 @@ static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 
-	mm = current->mm;
+	mm = vms->mm;
 	mm->map_count -= vms->vma_count;
 	mm->locked_vm -= vms->locked_vm;
 	if (vms->unlock)
@@ -1544,10 +1544,11 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
  * @unlock: Unlock after the operation.  Only unlocked on success
  */
 static void init_vma_munmap(struct vma_munmap_struct *vms,
-		struct vma_iterator *vmi, struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, struct list_head *uf,
-		bool unlock)
+		struct mm_struct *mm, struct vma_iterator *vmi,
+		struct vm_area_struct *vma, unsigned long start,
+		unsigned long end, struct list_head *uf, bool unlock)
 {
+	vms->mm = mm;
 	vms->vmi = vmi;
 	vms->vma = vma;
 	if (vma) {
@@ -1591,7 +1592,7 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	struct vma_munmap_struct vms;
 	int error;
 
-	init_vma_munmap(&vms, vmi, vma, start, end, uf, unlock);
+	init_vma_munmap(&vms, mm, vmi, vma, start, end, uf, unlock);
 	error = vms_gather_munmap_vmas(&vms, &mas_detach);
 	if (error)
 		goto gather_failed;
@@ -1634,7 +1635,8 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 	unsigned long end;
 	struct vm_area_struct *vma;
 
-	if ((offset_in_page(start)) || start > TASK_SIZE || len > TASK_SIZE-start)
+	if ((offset_in_page(start)) || start > mm->task_size ||
+	    len > mm->task_size - start)
 		return -EINVAL;
 
 	end = start + PAGE_ALIGN(len);
@@ -2426,7 +2428,7 @@ static int __mmap_setup(struct mmap_state *map, struct vm_area_desc *desc,
 
 	/* Find the first overlapping VMA and initialise unmap state. */
 	vms->vma = vma_find(vmi, map->end);
-	init_vma_munmap(vms, vmi, vms->vma, map->addr, map->end, uf,
+	init_vma_munmap(vms, map->mm, vmi, vms->vma, map->addr, map->end, uf,
 			/* unlock = */ false);
 
 	/* OK, we have overlapping VMAs - prepare to unmap them. */
@@ -2731,11 +2733,10 @@ static bool can_set_ksm_flags_early(struct mmap_state *map)
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
@@ -2809,14 +2810,16 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 
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
@@ -2830,18 +2833,19 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
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
-	if (map_deny_write_exec(&vma_flags, &vma_flags))
+	if (map_deny_write_exec(mm, &vma_flags, &vma_flags))
 		return -EACCES;
 
 	/* Allow architectures to sanity-check the vm_flags. */
@@ -2857,13 +2861,13 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
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
 
@@ -2983,6 +2987,8 @@ unsigned long unmapped_area(struct mm_struct *mm,
 	if (low_limit < mmap_min_addr)
 		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
+	if (mm != current->mm)
+		high_limit = min(high_limit, mm->task_size);
 retry:
 	if (vma_iter_area_lowest(&vmi, low_limit, high_limit, length))
 		return -ENOMEM;
@@ -3043,6 +3049,8 @@ unsigned long unmapped_area_topdown(struct mm_struct *mm,
 	if (low_limit < mmap_min_addr)
 		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
+	if (mm != current->mm)
+		high_limit = min(high_limit, mm->task_size);
 retry:
 	if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
 		return -ENOMEM;
diff --git a/mm/vma.h b/mm/vma.h
index d0a45718deb9..0c0b9d9c5248 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -32,6 +32,7 @@ struct unlink_vma_file_batch {
  * vma munmap operation
  */
 struct vma_munmap_struct {
+	struct mm_struct *mm;           /* The mm being operated on */
 	struct vma_iterator *vmi;
 	struct vm_area_struct *vma;     /* The first vma to munmap */
 	struct vm_area_struct *prev;    /* vma before the munmap area */
@@ -459,9 +460,9 @@ bool vma_wants_writenotify(struct vm_area_struct *vma, pgprot_t vm_page_prot);
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
@@ -732,11 +733,12 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift);
  *
  * Return: false if proposed change is OK, true if not ok and should be denied.
  */
-static inline bool map_deny_write_exec(const vma_flags_t *old,
+static inline bool map_deny_write_exec(struct mm_struct *mm,
+				       const vma_flags_t *old,
 				       const vma_flags_t *new)
 {
 	/* If MDWE is disabled, we have nothing to deny. */
-	if (!mm_flags_test(MMF_HAS_MDWE, current->mm))
+	if (!mm_flags_test(MMF_HAS_MDWE, mm))
 		return false;
 
 	/* If the new VMA is not executable, we have nothing to deny. */
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index bf26b3f48d3a..6786e43a5a6b 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -32,6 +32,7 @@ struct mm_struct {
 	unsigned long data_vm;	   /* VM_WRITE & ~VM_SHARED & ~VM_STACK */
 	unsigned long exec_vm;	   /* VM_EXEC & ~VM_WRITE & ~VM_STACK */
 	unsigned long stack_vm;	   /* VM_STACK */
+	unsigned long task_size;   /* size of task vm space */
 
 	union {
 		vm_flags_t def_flags;
diff --git a/tools/testing/vma/tests/mmap.c b/tools/testing/vma/tests/mmap.c
index c85bc000d1cb..46c9bf12d79f 100644
--- a/tools/testing/vma/tests/mmap.c
+++ b/tools/testing/vma/tests/mmap.c
@@ -12,19 +12,19 @@ static bool test_mmap_region_basic(void)
 	current->mm = &mm;
 
 	/* Map at 0x300000, length 0x3000. */
-	addr = __mmap_region(NULL, 0x300000, 0x3000, vma_flags, 0x300, NULL);
+	addr = __mmap_region(&mm, NULL, 0x300000, 0x3000, vma_flags, 0x300, NULL);
 	ASSERT_EQ(addr, 0x300000);
 
 	/* Map at 0x250000, length 0x3000. */
-	addr = __mmap_region(NULL, 0x250000, 0x3000, vma_flags, 0x250, NULL);
+	addr = __mmap_region(&mm, NULL, 0x250000, 0x3000, vma_flags, 0x250, NULL);
 	ASSERT_EQ(addr, 0x250000);
 
 	/* Map at 0x303000, merging to 0x300000 of length 0x6000. */
-	addr = __mmap_region(NULL, 0x303000, 0x3000, vma_flags, 0x303, NULL);
+	addr = __mmap_region(&mm, NULL, 0x303000, 0x3000, vma_flags, 0x303, NULL);
 	ASSERT_EQ(addr, 0x303000);
 
 	/* Map at 0x24d000, merging to 0x250000 of length 0x6000. */
-	addr = __mmap_region(NULL, 0x24d000, 0x3000, vma_flags, 0x24d, NULL);
+	addr = __mmap_region(&mm, NULL, 0x24d000, 0x3000, vma_flags, 0x24d, NULL);
 	ASSERT_EQ(addr, 0x24d000);
 
 	ASSERT_EQ(mm.map_count, 2);
-- 
2.43.0


