Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E29C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31BD46B009D; Fri, 18 Sep 2026 05:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27E156B009E; Fri, 18 Sep 2026 05:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16FD46B009F; Fri, 18 Sep 2026 05:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD4486B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E2791205A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:23 +0000 (UTC)
X-FDA: 85226314446.22.18E211C
Received: from mail-wr2-f24.google.com (mail-wr2-f24.google.com [74.125.225.88])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7069640002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DRRDdlkp;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.88 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQCtz3oTX1YW2gbSF1mQxat1U/wMyPCcu5DDLW4b9vc=;
	b=zeNbVDlyTXTMEXX6+L8eqYR5d//BheNcLL0bjbFTPdHu2UVx+aukSAJV24ae82spVWIE9B
	JM/QEZEEFzOEL60AbebSOy5pXtq73+wNBD7Y6DfpZZszxF8seuBPCa1tWbdaOijvIzFK8Q
	qba5CCLAO25AIQjAMlk8ReALRzrLhEw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DRRDdlkp;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.88 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722681;
	b=epaTBn3rweip46+SIYwMaDMtxBrYYR98CMyOzzrF+5Gf0AJIQP0zdhMSIszcfyBMwYt0vW
	Y6fVj6gRNL/xm5JLV2MF1W/gHbFJqpruyOlDDnlIFP0jiJnIoXffY2MoShlvaNBAGe7wLx
	3z2ucpzsPNqKFejNb/bWzLPG8z11JRA=
Received: by mail-wr2-f24.google.com with SMTP id ffacd0b85a97d-482f63546c3so360992f8f.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789722680; x=1790327480; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lQCtz3oTX1YW2gbSF1mQxat1U/wMyPCcu5DDLW4b9vc=;
        b=DRRDdlkpXZNeq7/lcIQ1h5dID7JoC8rKpzWnqfURsvufx0VU+y68/Q0Mp66DGOCYbS
         J//preRUMpfkBMB9gYobaeDwYMS37OZXlzyqogPSx/u4TsjyjUA3Gf9AQkrDYK1ytsxI
         fAMabrztOKeDwhk6CxeuAbf65fTGNo0gC7EP27Jbi9d+6dRQGTSP1ErfMaYSEcb+rMkb
         xS4jnDmgkIh4b5klZGQVQ6M57xtzNBK6rPEjjDVQU0Su0dTSUR8l1x3ZZDBzhpVu52Lz
         xG9AjeGu4kES6kOLYw8AiZlbCfNmv5IbwLF88yLbFpapR9O/m6sNC4+4j6Uuzaunygwi
         42QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789722680; x=1790327480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lQCtz3oTX1YW2gbSF1mQxat1U/wMyPCcu5DDLW4b9vc=;
        b=CGCQww3rlrdgp4YtJOK7qSv+GcWPAyIHrtIQBTeqGn/nELIPseI9KtcWYn21oBt9ZU
         iPKmSRvulPOXb+8d45tv4vta7MUizbJ5TTsSDP1YExr3PsY6osfPYBc9oF9VKLbaDXVV
         JjzBqBFFJ9kUPIal4KSeI+3SacJijGR/4/o3zsClBEmntxGTjvugHECDVkMCLBadGDNO
         W4m6C/7HA5e4VKOYaQo8fWmMZs9oRqWvYc1PacEInDHlY572TrhmvtOj0waH6Y0nefPa
         3VvwQEYpVHfb8jfIa/0TR3PeZLhHSVLB8fzEfzR+WGRKtvtIHYJL6RIeg7VsAYpXdYZb
         Kdpg==
X-Forwarded-Encrypted: i=1; AKwUvByMolvROzecGZZZ/sb0/qL2watTF5cRcjEVOvqcG72KTZg0NtyL4HekuOSdg4E6RrUJqbt5OwWe+Q==@kvack.org
X-Gm-Message-State: AFuF++nDrWMPULZzTWz35Bggo/Vfk4k00lGSwNVgXz4yjnspcuCr0Mic
	DoRCHgC2ty+iSbzeHsnOBiXPMZgTrJ2tVyTfB29A7P6wAmhgbzGwOBhe
X-Gm-Gg: AYBFou3uGAv6zEhS/uC7+xXhoTfCtPqIIo8itQXclzJ/2HKG6vVQ47pgFYaZ8jfVq6L
	OYhlDTaibx9ylSz8C2zvnIWBTFNzTIpgvMl0dkpaKrvGCY38ivJoVopnqLHLh6iPfZKz9u/AZBA
	QMMkSBq2BwxhTsA6lZ4JLKaaR/e6aDfDhY1OFfwtYzDhNwPzzPjmgx1j/MP8gDmlO5LZSdK5Jjl
	FCL+tw6w4f6M97duOD3n30AybxSvanXx5dMS87vRm6Pg5Od6/2Yi+R9RmJqeMQy0oxtgZlaHqNh
	BPslJRtG1iniMkuH1YXSzP7RU5qnIiEgmxhisG8L9YXcDtcjQK2KMRk5c+cAfUnat8l3EAE5WqD
	3ugdvgO/TwzRZeRG5zKHsbBFQm7bVUSaLvh0ewQ84gYOkiHDaZ0Y5NkZlPyV+vcErnkBuwGNGuX
	ulrLut0+/cluLMmv4JQz619Ov0sIi1HwH885P5to62TqZCs0i5zuJvUtQeUd8HUdP6cj9Qepio0
	AEHOGAukQyJN3A=
X-Received: by 2002:a05:600c:4e89:b0:49d:10d6:fd55 with SMTP id 5b1f17b1804b1-49fc5681267mr21914985e9.1.1789722679822;
        Fri, 18 Sep 2026 02:11:19 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0978sm138774275e9.2.2026.09.18.02.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:11:19 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 1/5] mm: Add copy_remote_mm_str()
Date: Fri, 18 Sep 2026 12:10:54 +0300
Message-ID: <20260918091058.297740-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
References: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7069640002
X-Stat-Signature: i6uf5kqdiyzbauxqis559rrmr3ifgx84
X-Rspam-User: 
X-HE-Tag: 1789722681-683136
X-HE-Meta: U2FsdGVkX18PzoFitsgW7Ca/fWrRzVWqhydrYoPs6qwjRDD+Brp3rMApYWjvxdd0vzJbkACFNqkNIdjQZAQtlnRfhoeOXFaoOXdkGFQIxRbBEOIJnsvJjbOUnewtghcw78GZEc4/Sx5kXG1BAamVTSXTzTL5ScbsnJLZydAL93t3jFJSw8KFDUTJ2OoOVgPJiQ11rvazcQH38JDucEMU8HzfKkTjyI1YS5S6uDLkh5J2MQHVO5kJjIGWJbrrFtBLZ2FGcPftST0ztI+w9JEcYYnH8HGetuqdU7K3FKp8kjGetRf3K4ZOx/cqA/S9GlrdeEFK0fZbKeuKLYEPBmT2PHBO/7hXe4ZzrS1jtTweMqAmqtnXjHZQ8j3kZyVFDNUDDylSi7AbUwiPqjVFX/LuPXD3yrN/AwoMeoSuqQwBdxe9/Hown/PuxsXfrY+Pkap+sNWTdfipwi5tnKmMCHVmGm6tkmOYYj+eS4u82VxgNJMzWwVgZ9hE3nEv6Svt30eYStXqZr7O0/4kTazkLdt3P1AuHCWMUtVqCV1dAT4vhUJ2qJI2/1e0uOSbIE8tY7QrfDKhhvbgMmic3hWzmhzQ8sptT1ygFdyvHF36ffHzp/D9b2i3AYKX9zOo02QvbLqzEFOCSQH28BSv/h5hlFs7wa1t5fkxSdssVrI65SKs1pz1UhxoiZeVeZhTOAdV7yyIC3fYlQpIpXoKvmD6TK/VOhl+vqM/2/gRpY2MXoORogv1+klvsnZqfGBWZpqDE0OZjGFNIpG/lOpMQq4GldF8Y0wPXEcVTL7/W87qrpnz2KzZQT+tj60ECQNxIKV6VfnBq7EBTYmwzxD3bHxqkc5K8i1ZHScTQdIy5sDATnOzl3LGSC7XR+46SeenW31bUXm6aWIW5kvExzCrDbrENpAhi/9Zi6Vc7DgUnvJd2m31XoQMk7jEQzPzYJLEDnE2Ygisqi/7kgadoedZvsESgVr
 8BHOcay3
 8G1/WHacksDo0/aJFOCAYjMlblzUMS56RypA1OUaT+EJuuHrj4uq5OY0faJ2isRzb0SrzngMz/epGz9ERmpxpV/gTfvoWkpSHOA61xG/rh7xSO2LcI/vFGhrtJImfkV8+zchgzvecJrhn0pTcnwauaFw8Cjb0CBkbUkdShznE4GIXI/HNIpxVw8JZtNu75K9hFnt1+0JxUZisY+0frejUEI0o9kyZ47w8cu8UH4PdnfKRqxutX/XexLDifvFAWcEhvm/eKmAJR6LWiAxXw503eRcRKTxKiuwk7ewij+qfbEEWsH4JWeEAqE/AMZPfSxoFUow8N/ccqMm6ZRZ6a8fPFUv1JYm+tusHuL8uczKsToYqKwbNQPKcAGLPr61mwI13fbbvOKs9m09dycryNxjcP/4bcgnXxI2+F5nbNm0g7tRUDBF2rKD/gMJhWo+ddVoNgV14DHMMVJF+AeXyX1CT1r0O+71SkpRCjCivBLhnqIiMzj44yXF//XmsVTrRNshXPxy7Jl3aIBOLDPMSfqxLfUDf0T1uexUxjOINwRKUuJlee/0jfWLz1ujInSPG+hybGrwc
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
 include/linux/mm.h |  8 +++---
 mm/internal.h      |  3 +++
 mm/memory.c        | 43 ++------------------------------
 mm/nommu.c         | 43 ++------------------------------
 mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 86 deletions(-)

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
index 38b1165212c9..557b29381355 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -25,6 +25,9 @@
 struct folio_batch;
 struct hstate;
 
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			 void *buf, int len, unsigned int gup_flags);
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..fc6933d7e9d3 100644
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
+			 void *buf, int len, unsigned int gup_flags)
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
index 498e01ee40b0..9a810c35e7e9 100644
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
+			 void *buf, int len, unsigned int gup_flags)
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
index bf0513d1d3d0..47c2e3ae8496 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1061,6 +1061,68 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen)
 	return res;
 }
 
+#ifdef CONFIG_BPF_SYSCALL
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
+#endif /* CONFIG_BPF_SYSCALL */
+
 int __weak memcmp_pages(struct page *page1, struct page *page2)
 {
 	char *addr1, *addr2;
-- 
2.55.0


