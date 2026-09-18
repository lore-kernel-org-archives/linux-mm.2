Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 830C4C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD4C6B0092; Fri, 18 Sep 2026 09:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E386B0093; Fri, 18 Sep 2026 09:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CB86B0095; Fri, 18 Sep 2026 09:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39DFF6B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACC7F1606A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:24 +0000 (UTC)
X-FDA: 85226936928.16.34B741C
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf17.hostedemail.com (Postfix) with ESMTP id D602D40009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OES106Qr;
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBI8Vei6mUKThCIHcgGdefIiyo76m+YulL+4eF81XBA=;
	b=3acwiF4z3kY1FegliLFyH7woJw7ya7tbtIb6PDs1jUp541S4eAjvEEhu2gmWVtReT7Wfc6
	PI5IrIpyX95s8PweedZ5mRZdkjEoLK+Wx+fS60G8BZE01T8nlL/kfbVucH/MICS/Kzawwd
	YhOdU4cxwBVibVP0FqkYkCaJSHeUAiw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OES106Qr;
	spf=pass (imf17.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737502;
	b=WHrfPT8JAuBG63bWCw2zo5Ids7R1dPGj5CDYhcwA1N9HhyqIiFlLUgBrhoL40R30yNhjHh
	OR0xtPpAtTUowTjfISix6ZPEXuI3517nH+kMEcE2L1n8/fadqFEoQumsFpp90y6eerhGhJ
	wv+8VkJOf8TWTnPvlaO4F4b+4XIuz6I=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c2790ccso436656f8f.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789737501; x=1790342301; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dBI8Vei6mUKThCIHcgGdefIiyo76m+YulL+4eF81XBA=;
        b=OES106Qrbg1R7MFtF0mX8H3JD8geD4S9K04u+bF8RC0F9womgMl6/ssUqeHGM+rCw8
         9MYckOM1j9pyog/x+v/4yne/07F0Sj+C29OrREVwJOQ2o36/9bZ1BwFy2Hk8VeCDtsd5
         AD8bNbkcWKWp5+5OWrpEnSxQP4QQ98CbN6V3WiRYMxhC+OtB9Ra+Giqg0ze0/XVMC/OH
         RV7qsVXpAJqoC6MT8nJX7sMrRK/b5JlOEUcIgR4xc6qZKP7d4qmXyDwjAUUq5TE+Gq63
         9M4jcP692bOTdcdSDACEA/JmSIaMjGYdx8DZYBMvr5lIl5xQFcC74hrpvLo7B+4A3PH6
         xFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737501; x=1790342301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dBI8Vei6mUKThCIHcgGdefIiyo76m+YulL+4eF81XBA=;
        b=Tr24zQ1O/BAl4nHCemMP6Z2ZVv0GzVWewmU1wTuCz0Dk0cNnPbY0iwxkXp11IWjywk
         toNz1Dn1XmZGXp8d75PhcPlK3ypShHDjMAYD+lAISQHR8TgiDpVCEDxMXtHWu+5GafMl
         zJVYrBr5jx9+8ALzRQTRyVJkxWj+pa1PITMkimX2+F+Uj3u+Z18zP7k5vVN7y7YZWPZd
         G54IQFsKl9k4c/bKXj7p3k+AxLJsN/H5tfLwNXVIsYzKacTRaB6TOGC2dtorSLYFzD0X
         iGeM7CYxY1BgLIn0G1f2YI/DT5w51KanR9k9cOW8uVsp9RRDRU6OjE6++yaddg5LpWkE
         8FWQ==
X-Forwarded-Encrypted: i=1; AKwUvBzaumj8qy0uzHzeM4mcg9ZAR38QSfz6WqDrGV6ij+SP9D1GEZOx6dCDM6ZJMMS05F2wBUWGflqK/A==@kvack.org
X-Gm-Message-State: AFuF++nAU5F0gHb1J5Aber2lbhwKnwt8wKWNS3HKG8GunRwSl5ajTMup
	UM6xyVkZZRyVWR94PUQFmTt4PxUQX7A2upGqKKV2G917aLRy2S1M5tfJ
X-Gm-Gg: AYBFou1Yc8mO/UqIXfn1fFPd86/plY0WKNi83z0h1Cpb5P3bkvbWCttxMF3jws5FCop
	rKVqyH3zOgQHJO1bdHarNb7oIGcl79901VSgU1oVptQse/nGLfHsYxsmxRweHVY/MWM3HDryPPf
	g46D+N2Q+usCLLiCZGDpChvh/ng8uazjeyj0eaSSQAFdfW/T0l4J2gCywx4Jq4K3Czqnp/BvrE0
	ouzylDetOPOd+aYcBMeXwGodV6ITQ6nElZdnx1D9aX0QtZXJrJgIhqcZBNUJ9OlrXixM6/51+7m
	0zKHWvcq5Q9oT8A2dFSd9ot0SRic86eMzdRDY4KBSaGbyfTI+aD0C8tsG7eZ7NRboeqA5BNy7ar
	mBvdNcpPWVzONuKWoQRqcQCUvYwFXhsMjaV2dRPDwF/EFDlge21yiwg8+C5DMYsfCfvRaEJQVzH
	KYBa/PQIkp+Hlanyjya16OAMZTl7ZnfeKlDkt9PlII5pmnaqrVM9fhKH93WmI0xb16owg5hmYkl
	h296ferMGkbPSs=
X-Received: by 2002:a05:6000:26d2:b0:487:ae2:4d01 with SMTP id ffacd0b85a97d-4871e36cff7mr7099900f8f.22.1789737501308;
        Fri, 18 Sep 2026 06:18:21 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871feb5de3sm4424549f8f.1.2026.09.18.06.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:18:20 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v9 1/5] mm: Add copy_remote_mm_str()
Date: Fri, 18 Sep 2026 16:17:53 +0300
Message-ID: <20260918131757.42802-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
References: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D602D40009
X-Stat-Signature: tb6uu1z1egdwnasakscu3xg89d61a3qq
X-Rspam-User: 
X-HE-Tag: 1789737502-533049
X-HE-Meta: U2FsdGVkX19WjikzDHlZxv6adxHQq3GwuJV62NXZf3oiWcq46hWNYxk64CEsag6P+t5gMh+2tVTrsugDe837/g0uVkq8OIdDVktHCSj8wLU34MORwmofW5/Ve/+y5ezDEkIXP7AxQmw5LdsWRIgFejF6Pl/OTVir1Ddxn/+l2WT+cdVgTq2EGaqlZvy/g9NKwk45i70DLfm4TzvpHWd90bt1y9NvVUeH+WjRenI/Y9qwXKkknyEketFL+f44igKbCRB4Yxgtl09LvZwbn/zyLLrzkSwY618n4tmrqMDqH4hAXfBtd5uc8FQcLAlnLk5uw4JeLjvDm8YVkvvayA0psnBiMueGYnoWSquwvoIymRMByRthxNTQ2i+HEzkmEB72pywFQ6hSbsMdPJE/di85W36mJiiFeO1zdP9ZkS+s1T9R3RoNvSWgawd4CmI30xTnZAOdr+xq4ww7rmAzmQNbRUdUzlIL3sRULbkOZi2/x404g6Zs9BINp3f4lnQB8OZrtTTyzSxqWIYzGxdblBbIChVdob/zlz36125pr785q3jjILLlVYZ1D+ZnpWp9S6PNp0sti6csqKkNVggYbNjD2PTjeCBHIdn5xPHvD7WAJAGGOEtOgWkrGCTtqTKbcD+Oh5Onrjc7da5iWFyRtcDwr/kDyQOODit8nARM6j8BxIXy14bGqH+DXMOmAi+ft+bUpC1aXObO0lncv8O0KfViL8TioY8uG19P0+mhE+5vUs5bMRGVqxp0KePjzWqHlY3YF5ryRyXVDKixn/vbpyRW+Em5nYL1kPiX7ghVjWrohbWZ8LyeW53zoSwJzcaMMakfVAoFFcvJStOxKIB7XdVYGCEGvJyYkDnD8qJ2rfaK9I7z1TwHukVbJzlth1DK2mw3iPCTJeRMH/80+LsWUuhxaIXLXPdYgkMUUF40QVy4Wxg+wWqzs6hyrTvyRgmJMIchNenyfSN+IF1wm2pKywP
 CADLVeEL
 HGktahSM3IKq/tBNs8uG3OP94iLEW30M/AmjdnJm1uUdDtPYnhncbDC3SEl3Q7z/Mf69+JiAMRkJIgSRPU1a16eqtWmBaCxcBEtOGFdvUrVgYkIK9zUyAhOOUBge7tZCs13qolt6jskm98XtWinPsL6WUiNkp4p2UQegVYXYfNVvXtYv7VWxDOVZISDwXo6jL8WcfkJjC58tq/9VYL9OghSHXGfZxK6iF87mI6gbLtK997AFea/oSEQzAavSRzrrlEdsHk/bcEqtw2Sj/pmhyO1Dg+U764J9NUL2zX7OVXg1Fhh23T5Q+1Y8CFuarE1F98CskHoN7n0dWAhUsTYE4LzgJDWqPseWY9ancYJ5r2ViFIP0WHFiv8yNa7N6eYjEu+guDNY7QzPUAfkETZ0gm8MTRqs/Ut42JBUgZcapvurmKoQkk4ofTe9bIe1Zqh+juXMXcvShZl/TuP1mNfqlu9A01gUs0TDEn3HghCLnDedv4D0/btTxPPbqI5DjJ508NquRyNx3ewPAHr1/1Snm9VzGkpXe/QlMOaFTGrzU5BDltdIh584C6m0lEpayg1r609rEZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_remote_vm_str() gets the target address space from a struct
task_struct. This does not work for an address space that exists but is
not yet associated with a task_struct, such as the mm held by struct
linux_binprm during exec.

Add copy_remote_mm_str(), which operates directly on a struct mm_struct.

Use a common internal interface for the MMU and NOMMU implementations
and define both public wrappers in mm/util.c. Preserve the existing
copy_remote_vm_str() behavior, including handling zero-length requests
before acquiring the task's mm.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h |  8 +++----
 mm/internal.h      |  3 +++
 mm/memory.c        | 43 ++-------------------------------
 mm/nommu.c         | 43 ++-------------------------------
 mm/util.c          | 60 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 71 insertions(+), 86 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..63f40e615754 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3325,10 +3325,10 @@ extern int access_process_vm(struct task_struct *tsk, unsigned long addr,
 extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 
-#ifdef CONFIG_BPF_SYSCALL
-extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
-			      void *buf, int len, unsigned int gup_flags);
-#endif
+int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags);
+int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags);
 
 long get_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..7c326965a94f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -25,6 +25,9 @@
 struct folio_batch;
 struct hstate;
 
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags);
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..fa819a8a1df6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7326,13 +7326,12 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr,
 }
 EXPORT_SYMBOL_GPL(access_process_vm);
 
-#ifdef CONFIG_BPF_SYSCALL
 /*
  * Copy a string from another process's address space as given in mm.
  * If there is any error return -EFAULT.
  */
-static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
-				void *buf, int len, unsigned int gup_flags)
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags)
 {
 	void *old_buf = buf;
 	int err = 0;
@@ -7408,44 +7407,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	return buf - old_buf;
 }
 
-/**
- * copy_remote_vm_str - copy a string from another process's address space.
- * @tsk:	the task of the target address space
- * @addr:	start address to read from
- * @buf:	destination buffer
- * @len:	number of bytes to copy
- * @gup_flags:	flags modifying lookup behaviour
- *
- * The caller must hold a reference on @mm.
- *
- * Return: number of bytes copied from @addr (source) to @buf (destination);
- * not including the trailing NUL. Always guaranteed to leave NUL-terminated
- * buffer. On any error, return -EFAULT.
- */
-int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
-		       void *buf, int len, unsigned int gup_flags)
-{
-	struct mm_struct *mm;
-	int ret;
-
-	if (unlikely(len == 0))
-		return 0;
-
-	mm = get_task_mm(tsk);
-	if (!mm) {
-		*(char *)buf = '\0';
-		return -EFAULT;
-	}
-
-	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
-
-	mmput(mm);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(copy_remote_vm_str);
-#endif /* CONFIG_BPF_SYSCALL */
-
 /*
  * Print the name of a VMA.
  */
diff --git a/mm/nommu.c b/mm/nommu.c
index 498e01ee40b0..68b05565e15a 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1741,13 +1741,12 @@ int access_process_vm(struct task_struct *tsk, unsigned long addr, void *buf, in
 }
 EXPORT_SYMBOL_GPL(access_process_vm);
 
-#ifdef CONFIG_BPF_SYSCALL
 /*
  * Copy a string from another process's address space as given in mm.
  * If there is any error return -EFAULT.
  */
-static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
-				void *buf, int len)
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags)
 {
 	unsigned long addr_end;
 	struct vm_area_struct *vma;
@@ -1782,44 +1781,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	return ret;
 }
 
-/**
- * copy_remote_vm_str - copy a string from another process's address space.
- * @tsk:	the task of the target address space
- * @addr:	start address to read from
- * @buf:	destination buffer
- * @len:	number of bytes to copy
- * @gup_flags:	flags modifying lookup behaviour (unused)
- *
- * The caller must hold a reference on @mm.
- *
- * Return: number of bytes copied from @addr (source) to @buf (destination);
- * not including the trailing NUL. Always guaranteed to leave NUL-terminated
- * buffer. On any error, return -EFAULT.
- */
-int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
-		       void *buf, int len, unsigned int gup_flags)
-{
-	struct mm_struct *mm;
-	int ret;
-
-	if (unlikely(len == 0))
-		return 0;
-
-	mm = get_task_mm(tsk);
-	if (!mm) {
-		*(char *)buf = '\0';
-		return -EFAULT;
-	}
-
-	ret = __copy_remote_vm_str(mm, addr, buf, len);
-
-	mmput(mm);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(copy_remote_vm_str);
-#endif /* CONFIG_BPF_SYSCALL */
-
 /**
  * nommu_shrink_inode_mappings - Shrink the shared mappings on an inode
  * @inode: The inode to check
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..75c0fc2061aa 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1061,6 +1061,66 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen)
 	return res;
 }
 
+/**
+ * copy_remote_mm_str - copy a string from a remote address space.
+ * @mm:         the remote address space
+ * @addr:       start address to read from
+ * @buf:        destination buffer
+ * @len:        number of bytes to copy
+ * @gup_flags:  flags modifying lookup behaviour
+ *
+ * The caller must hold a reference on @mm.
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
+ */
+int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags)
+{
+	if (unlikely(len == 0))
+		return 0;
+
+	return __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
+}
+
+/**
+ * copy_remote_vm_str - copy a string from another process's address space.
+ * @tsk:	the task of the target address space
+ * @addr:	start address to read from
+ * @buf:	destination buffer
+ * @len:	number of bytes to copy
+ * @gup_flags:	flags modifying lookup behaviour
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
+ */
+int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
+		void *buf, int len, unsigned int gup_flags)
+{
+	struct mm_struct *mm;
+	int ret;
+
+	if (unlikely(len == 0))
+		return 0;
+
+	mm = get_task_mm(tsk);
+	if (!mm) {
+		*(char *)buf = '\0';
+		return -EFAULT;
+	}
+
+	ret = __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
+
+	mmput(mm);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(copy_remote_vm_str);
+
 int __weak memcmp_pages(struct page *page1, struct page *page2)
 {
 	char *addr1, *addr2;
-- 
2.55.0


