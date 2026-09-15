Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51A7EC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 495B76B008C; Tue, 15 Sep 2026 04:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46E5C6B0092; Tue, 15 Sep 2026 04:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3852D6B0093; Tue, 15 Sep 2026 04:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5A46B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:03:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0A44A12036F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:32 +0000 (UTC)
X-FDA: 85215257064.18.EE84344
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3321940004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bc2Ooei2;
	spf=pass (imf01.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789459410;
	b=L3v5rJ7YYesN4cpHGhzxC8lGRd35QmtFdrtEFlyiSN8Xf2NuK4c5KyVon0kovtVWC6vrRC
	bxe6JutREUU+4Pn/dyRhCI9o+cWGNrFqHC5R2hLjva1hs+TB+MW4aAZOplu2y8LSOXW4YE
	1RJfKoxWyaplR0wEm4dfRwIkhgZznZk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bc2Ooei2;
	spf=pass (imf01.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789459410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LNtsDssHmIZmCVL8XDm90qTc9aUzb3Y+uIIuk09X5PE=;
	b=oICI3JFmwnc9XN/E7GKy2CSV2RbBiHxPpeQJducFQZThMVgp0vRdNPT30jaeYlkB821w3f
	atJ0pOoA1IvXbPDIorMtRjWUO/sKwQgF6xgYOBNqQOya/NZOLusHQtGVS6gwDmBocthtM+
	kS6tDi2hoEu3XlZakXoNbJaHaP+xc9A=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e69b9e16aso27351635e9.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789459409; x=1790064209; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LNtsDssHmIZmCVL8XDm90qTc9aUzb3Y+uIIuk09X5PE=;
        b=Bc2Ooei2lkQtFzZ7XjWHDPq8sFVoVINarwUM8KtKm6c43CcYjBJfoiUgUw9s0HQoYA
         HAAtRHaLmaRshumfQC8CpP4tBT31Ex5T6F99G8fZC1IproN2TxM17VxVHxxX/uoKFXpB
         EIF3hEhMnpIP1jjZHQEfL/CyMUvosMxr48FHDSt2hMWdS1djcnAZBayyxFrNKRZWZpQM
         S5MhioBb9GOOTmZ7/CrquKfTzgBY5Fe4S3foMyf/e3gpI2kML/5EJn04oxE3po00ag1p
         taJ9GONT4eBJJ75bmguVsXwBusVy2YmJPbZUxoA7TDiKXBDZ9K8y4RfPKyl0AXzmjArT
         qCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789459409; x=1790064209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LNtsDssHmIZmCVL8XDm90qTc9aUzb3Y+uIIuk09X5PE=;
        b=BFiaQZD1txlxxiJbGWQKqsuJ7+0ZYGKjO86WghesaLyqg1dMSiynL/mnpom4kkdiw/
         onXEiHnLwp6ciXwqvLUaeDeXXRlwLtGJl7bCCyeIdqXfDozFQJ3DxC9cEBYJFLo/s74Q
         TUV5J7t6GAX6yScM0xOwtFzLiiyxmLVREYito3nEARFqHDONGxagmJaLZ1HeAiDyNSCo
         0DF5pQSnpBnxPQLgAl/yM8Ca3xS705Oq77R0Y5a8PSaSB31NLBvYPmqiTBuBs5AfiNPj
         xzrEdxj7kZcVP9fGnThT7g53w9Dss07Ia5tJau/0K+03/rpRTquMa7bRgoDBmA0v6oL3
         hjAA==
X-Forwarded-Encrypted: i=1; AKwUvByfX0lUd5oSrMuLX1YsM8a7pu1XIwX/JGIqOx8Hvi+NLeV4U5PEsY8IGe0C6TP7Bi05Y3lCK80eeg==@kvack.org
X-Gm-Message-State: AFuF++mBEJyVCZGNbT//7ShHibxPjyTeR47fSL1k/pADZg+yii9weKs5
	usadoXlwO+BpxEyM6qrzf6L6GoCLm2RLuglVXZQE+LFnlYLMUgkuAbsm
X-Gm-Gg: AYBFou2JZWsd5vFJODrBs8NzMu6+CedT0qoHGe3YzmJlyDZ6fEGKuVVjvYv+xF44Gxl
	3nFOk4PNt+f5Se0HUbjHrGwNe4mB6AhldDYWzr7pFkeK51jQl0VhU26258QVDaIWFmWgtM3nFLe
	Cy0lV9FW+KAoXQj6f81xSYMfaw/1GtzX5xlTCeK0UDdy4z8Og90MUTJvPYCKOs25s/akV31WOuE
	YPFHpVGaFif0lRYwiFqoq8Kqar/1ABRTjr8ee9n0RDuSWAJgxkP7DDwB1FLBiQlmjXI4Fjci8bf
	1mCfXW6gRBlZu9WemscqEOlDd6zjA3Bcto/1OyXmb+t9ycOb1/Abv2Kx13+/M9wnC8BnomLnE01
	foat7La0Nay8Y0dS1JM3deUj8TbDfXKvUJXhpBZOpb1IUoDcRmB+qgraEdLf0ZmDwkskQUpScKu
	OXoRbAStF4Iwm8b1dsGV9i2FV0k8YPkti3DJEIYc5DQk33cRGPQ2eInVOpn9bScQ1MGOgZWb8CR
	OJT+wPq5DEp6Bo=
X-Received: by 2002:a05:600c:1c19:b0:49c:fa21:1c84 with SMTP id 5b1f17b1804b1-49e7a692504mr84685885e9.25.1789459408392;
        Tue, 15 Sep 2026 01:03:28 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm33764675f8f.33.2026.09.15.01.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:03:27 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 1/5] mm: Add copy_remote_mm_str()
Date: Tue, 15 Sep 2026 11:02:51 +0300
Message-ID: <20260915080255.48929-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3321940004
X-Stat-Signature: i83p55iqcnn4fh8knsmhsarw5wf4xx7r
X-Rspam-User: 
X-HE-Tag: 1789459410-156000
X-HE-Meta: U2FsdGVkX18BZS7ZxvHhbzyt2W4zu9H2mtpGBsl0WtImC9BRB/qWWmVH3BAbyOIWp8C3+KRMVogJznO/PvPD/liKze9ukHGUmApGT1ShXR001yWnuaffhZbje0CR1QpZjc7DEVv+R+8I1izD7bZBDHSoEqSOYT5Jd5T3zwsBq8RUvvaeJs50MxiPmEeiOurru41fKmza0AUfpR8bAnLdeTgcyRQTT6NyS5r77BBy38gQFUNa1eVpiECACgFV/65VcwD7MqZa97kKs6/qgKvZF/81atbHZ6kqnLsP9dEtdglZOc+1Q9P51RGR8cmdEjZ2sezRT8XFUMK1lGMYaiabSYvY4omOYfnkqFh0C3DIT84KRuIkxE2lyFFdSplxrbcJf0rJuodbaUop3dhBNfNoBg+A2gSKj2AIaGQ121JHpp4avi1PKUWS8vYP/1qINXTmXwwGBkdSUwS8z1PB5keyRSFRlG2pkKILtzr8VQdByYl6DmUe7Xjg5kA/ouWIMI7/Tg8m9Ey2yxd1iC2BWGAZg92GxGALdOL1fvsuPug80PayHAT8OmlYPYWtu7kTquhQLFJ/WiyHNkETigw11g1OnLsgtQoxYh88UOyPM/WsTtbUhbDjS+fJD7zF2TsvaygF0qBh4nF6UZKsTAqwhPP09TyH2R6uHdpiBmQ0WwNpkd2K4YCX+QufRlcqkFhCY6pwV3RVOZDV8tukYQV8rE31lKSqpiPFNyKaMQQLpNTmZeWa8DwPwdFvhARJHX781TOowuQ7bDrua7/DOVZvEUS3TzmVoGLkAoW7QjT45+AEPtgB0XShGKZ9sb/obEA2NdzP20WOW58n8lhCDgfehIgvYP3BPD18uAaXehz517KZpNlyeGJopoEbk3V0llivIx8Kw1lDK5uibv8jI368EqF/XCbTMSmpq5MsoTENu4GV9eku0J+TsarPosy7rBFuVhfVGct/Qg1unPlwxE9Ngwc
 Wvrf3d2U
 gZ3f6kRwaFXb0Ir54CnGAO8q9hmyL3rVR/BTphcfhfGLQUibKLOD0PXVj/xR0DYj9A08bhboc/5wrQlEFgyk/66ATCMgOzb+iLPzgcww6bGikmpTdMDUOq4fln5MERtfDNz8bHnKTTebIa2wPPI0hsT7nk/O7caPBBjACgBv/mpz2uEuPnL5f4mxnD/QwB19ysIKN1W8mUmf3h1hGtyeImC9v60CRIJwwcONxHHGN7vGHPt1QNr8BPCYyX7Pt2QoVpI9vld5gQL2CCJ/d5DRaYTE7CXeFk87GJv9Qj4eBHVO+XfKgSBEvUCeUlQHNC6WnvhN9Sa0kxfELij/nvniAUudLbr0fx/B75sBiAJY/WLRuyH9dFG3N5cIeYchLeDpulflFm1uUdUAJfhPp7WSJiUza4p2t4CvI9R0A6xeUfQKRHXkql3W10SEwXpDUN4WhStEVE5oc5IYwKQDpTQOpKn565T1wRGYdl8jcpaoO39CM72VrittqC0GSIJle9vD17eEaRL2AnEj5XPnmhn27UvVgWjq0lcOKlaq2doyRgNd7nfyenOv7JnyvCniQAxJZh+CF
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
 mm/memory.c        | 41 ++----------------------------
 mm/nommu.c         | 41 ++----------------------------
 mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 82 deletions(-)

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
index 8b0c2c735d3d..fe2f5e988fb9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7331,8 +7331,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
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
@@ -7407,43 +7407,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 		return err;
 	return buf - old_buf;
 }
-
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
 #endif /* CONFIG_BPF_SYSCALL */
 
 /*
diff --git a/mm/nommu.c b/mm/nommu.c
index 498e01ee40b0..98596e60311f 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1746,8 +1746,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
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
@@ -1781,43 +1781,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	mmap_read_unlock(mm);
 	return ret;
 }
-
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
 #endif /* CONFIG_BPF_SYSCALL */
 
 /**
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


