Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A552EC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D887D6B0096; Wed, 15 Jul 2026 17:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D615E6B0098; Wed, 15 Jul 2026 17:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27C46B0099; Wed, 15 Jul 2026 17:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89AFD6B0096
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:20:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 168B2A02E0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:41 +0000 (UTC)
X-FDA: 84992280282.25.A8BBEE4
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2ED39C0007
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:20:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aq72rxGF;
	spf=pass (imf22.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4/w1PFAlDDnNDEoj+FOvtFg06IZcqV0NzLqb9Lu6qM=;
	b=V40nGTL1XFHKTVdKRSSivXPXkcXoz9g8FCJaYoMmh6FyLiYZnfmD+VVF31CR6aCQ/ReRAb
	G8NGdM+H8xMx139rNssvogEE1a7OD1Patv55kfB7/h+HjbAnj3iFwxvJlt8y6LbeIOMP0O
	OD8MmEHRHco9lM+JPWaNVE871Q0FNfk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aq72rxGF;
	spf=pass (imf22.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150439;
	b=odOJJlS2Bg6rYtSnW3JgZFMQPy1gCzuRvHYtKgg2dR0iYICoQxZnP4IfXFTGPD7CEFICe6
	ScobacEr7AIbTJswVHQ37DTsxy/4BX2GaiS2Bzy293NSa3PLCXFHPXQK6s0XcCIuixW82c
	M6XCeqHBDey6RC5iYASMJSLUf4T9XY4=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c9c26a5fb98so1697053a12.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784150438; x=1784755238; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I4/w1PFAlDDnNDEoj+FOvtFg06IZcqV0NzLqb9Lu6qM=;
        b=aq72rxGFOMyhJxKNDRBkYZ2fdSlIaTfyKI/9MbGFuKDP2DJ1aUqJL/2YoNFLPEz8JW
         LcxGP49b0NvSSC1x7PFwBLtDtB769/32NG9kYTJvfq7+jUlhByuiWUxajzrI8do5qS6e
         a3BuDF8v2EkR2k6evwc8d05//LbC2ySMHu/u4jhK4jfhjerk3FpU+BNt6n8thFDYUOj/
         CalavDElyduB0X82FWYib9zrWJoKUqDBPxlyg6b5vjF0OL2iw4LOKJIC+ayuXe/0Xopc
         DloleXkVTx6fRapof4evl4q1AVMmbpZEoM0or8eIe/7AmywCXIGFfPhsY5kYOFfWBtAN
         XDog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784150438; x=1784755238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=I4/w1PFAlDDnNDEoj+FOvtFg06IZcqV0NzLqb9Lu6qM=;
        b=bZa8XJeZ+L9EyCx33ifAPuMkmTkdhq+hfMUHjlPtCNJd3YoaQIVwKUP/QMhHaV1Jce
         p2AAcUishkLni0DLAtk2wbrp+7612P6SA48uDvNMaEKY5tkT1GRKVSIk+ODuwZpBbgLF
         d7gIhamXwpr9NGX+UTeEi74oPV4Wuw+ZKEnmA3ZQP/MgEhRaAy6cZxwTZywImS+2Nj86
         pC2KN6pV3Xd+4ZxbaxRzaJKp//xmc9UB62N097HD7aOIFsK4fCZC5ycLUpWCCykIkHao
         cGpEzbMejwFwMP4qVodBI5O/IWVR0+vcSF2PPRpCsupRDioFra0LtCBKdDQgMTD7or0n
         W3Cg==
X-Forwarded-Encrypted: i=1; AHgh+RpxD6/8cqVSlB/ePmJyRvUAg0TSm0bXzwgU/IjQVw4o+QFlBi1fk1JsFJHcfwfLa8GCGsR0vzN64w==@kvack.org
X-Gm-Message-State: AOJu0Yw4/7lW/wjbb3YKPkdOp7o7W1VOMBPty7B+R/S9d0V5CmfZQbZc
	SMVnv57/08Bgqtf5sHBUmNdJvNmA7EpJ692kdFHPBucNG4V5AZgh221E
X-Gm-Gg: AfdE7clj1sV10ZyOUr6JcDXKxJOgUvw6dckLsndHpQrd6HqwnZBcgdDnNXRmKVoE5zD
	nY81QRQBv0pNnaPrzFt8Dg9Nz4xSaHruMKNcZl+wC3vZ1C2LuWs2RKKjsKSmQZkcfMZ5X8PhOtf
	ANl+aYO9vk3UY28hIvSYgX6pSDGmg2m45OKHMoDPGAIhcj25clxkmXpiyZoN/kaomYV2FldTkfK
	gAzlQ/6pwEwmq+WYddIdv0bAJpMrZPL7N5fNA4rGVDfbuwQ7vtWj735k9OHDcRc9oBa7nL0mdkV
	VR6hll0QD+YfaxeLf/iWNX4TJH9PZ4iOIbfwM+sdMLYMcErGA+y671QzVbKi4SRg6r89tB7kAgU
	TO+uzz91K8gnCfr1ecK9Fa1LRJnSbAf1Nhw1DRx7MUpo/C4VCzEjOu/MG4HUzyDROBpqRZapC8E
	ZSgsZDXjV/HyKhItBXOV9bxzBGH4s0Rhg/YdRkorxPEBhaa3BB/DPRO8g3XQ==
X-Received: by 2002:a05:6a21:4508:b0:3b4:8c67:51d4 with SMTP id adf61e73a8af0-3c384e1a96bmr1002656637.39.1784150437690;
        Wed, 15 Jul 2026 14:20:37 -0700 (PDT)
Received: from pop-os.tail4adac7.ts.net ([129.210.115.107])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13cd403a7f7sm4126844c88.0.2026.07.15.14.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:20:37 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <kees@kernel.org>,
	linux-kernel@vger.kernel.org,
	Will Drewry <wad@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Cong Wang <cwang@multikernel.io>
Subject: [PATCH v6 2/8] mm: add __do_mmap() and vm_mmap_remote()/vm_munmap_remote()
Date: Wed, 15 Jul 2026 14:20:01 -0700
Message-ID: <20260715212007.2382846-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
References: <20260715212007.2382846-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2ED39C0007
X-Stat-Signature: swyuk1p4fxn4fpm51nsqqsqnbgnr661c
X-HE-Tag: 1784150439-773692
X-HE-Meta: U2FsdGVkX1+Khb0Pah8OtBHClMRqgSbtoVwuQtqbguGHQ+38ueSz2aSqwl3gBXxJPJrcE8s8LyZvKghLibpfKkrn6cV3UNEo1xsiFj4n5LBYN3zVRIXnaJLOUJs1+Lwwffy2OzQzwJRalUbxdWLtQ4asqraPhZGrvnob5X5BFw3PnGcb9reTbBZjBCjcNOuTAOM3EnrV2Yl/X3CXTg+elceuxXADzbrLntbOfMOdCLr5Lc9hCpDJga49KcPAticWw+G2UmwmEopmhtSExpE2oC7F1dN3OLEvAwZLzASKIag2XcDpMFbBMiSrmdhQsZfX45YMRGHdFgk+KNyxZBC11gBN9VA847OPCrDQLeW4MkHZfBow+EH9RpvcojvMY00Vp0tOfjpro5ZEgmO1ufuEv1WRNfTOMlFaZnfKffbEu3yT0hJk/cdnNFSD6Ea4A+5QUgst2Z9Yb9+M62byiiL06Ga/mtp+J0ipLy9xH1lllTinM3tPc97irumZg0U7NoSMrqokQvofxEBSiMkJ+Jho5uk9YvlHR/eXgXZwHOHmeI3iJnWtJ0f9DE4vlr+12hSIsVkHASNrB10/rcRGdL33zEY9etdlqpsmU9CRFAKnxYENTJuOnVYemRyN42S2c6iutu6O6RA+FJ6h93+lRGmul8NOTIcMgOHm4aMD/vOfGlVypRG7Ge8iFKUSe0zvX5n9QwYYwF3Oq1sOnO6dGJms+jTE2hsfO0AFoKR6WCy4NKgaU4J6eyWAOMBVDf4RKfhqGUUd/a7hrnF5sjBdK+lSJplZmBTH22Oc9EHTT8bmH5ToLq4VK6c9gwAe//sRxWnC6W3vmXDi1rxWUiKPMUkli/wG15WBTc6RdLT/tUu7cxy7COhZGCwqwQnQ41aT1TtwE7lCVDAxH03orT1edw/AEQtFx8r8SM7aviQVLAu9LAjoLHZj7wptDb0Q1IPM4YPRuQduH2v3psLlywk7CqS
 XcOwbqs9
 FSxtVkU7MdqFdRGprmCBpG1kRDsCVfI6UuByLe8x7EzjMZwbrNCATOtZClef4V9Wd+aGIwpk0ZNyAf0QecjCLujtCzyTlGfNRQ4Raz8xF0KGQdamx5X5CcDsJfb9raZCbAGdPovlqaA4GiQzMv632O9DKro0UKWitwSQdEFb1/94L+1uM/XqeV91O4d702CSqz7Mrb5T7IoigDNu/vsoHfxbporZzUrYatL7WBUp069mmSTbv/vFwTX4VUx+HVP5+bT/27UGhgNtNncrChhH92L2A7UhKuAA4YwWj/J+fFDwNH04tuT3XtticLHkUeDxsT9mM9acg4azRCfGeFXWnNiVAPYj7OMNfBIVbQHIfKNsrbM7LhQPzGtmU2HSCXCrOQTxTDDGYVPEcwB9hADoT+qnDsW1SailM+kMwbkBpwoNJT4baNVE2ufgpS4ZEKR26LgonQArMGVuDP3olnh4J5HqVytCwhVlhAPKtIcQIrdd0Xh4NZJekjMhWDw==
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
 include/linux/mm.h |  19 ++++++++
 mm/internal.h      |   6 +++
 mm/mmap.c          |  49 +++++++++++++--------
 mm/mprotect.c      |   2 +-
 mm/nommu.c         |  22 +++++++---
 mm/util.c          | 106 +++++++++++++++++++++++++++++++++++++++++++++
 mm/vma.c           |  46 ++++++++++++--------
 mm/vma.h           |  12 ++---
 8 files changed, 212 insertions(+), 50 deletions(-)

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
index 181e79f1d6a2..fd3d39f6b4c4 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1436,6 +1436,12 @@ extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
         unsigned long, unsigned long,
         unsigned long, unsigned long);
 
+unsigned long __do_mmap(struct mm_struct *mm, struct file *file,
+	unsigned long addr, unsigned long len, unsigned long prot,
+	unsigned long flags, vm_flags_t vm_flags, unsigned long pgoff,
+	unsigned long *populate, struct list_head *uf);
+
+
 extern void set_pageblock_order(void);
 unsigned long reclaim_pages(struct list_head *folio_list);
 unsigned int reclaim_clean_pages_from_list(struct zone *zone,
diff --git a/mm/mmap.c b/mm/mmap.c
index 54915ac478ab..f379a065a8e6 100644
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
index af2c2103f0d9..2b5254106d15 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -588,6 +588,112 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 	return ret;
 }
 
+#ifdef CONFIG_MMU
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
+ * cross-task authorization is the caller's responsibility. The foreign mm is
+ * not mm_populate()d.
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
-- 
2.43.0


