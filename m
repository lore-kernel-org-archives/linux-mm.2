Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BF0DC79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8D3D6B00AC; Mon,  7 Sep 2026 12:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64906B00AD; Mon,  7 Sep 2026 12:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7A5E6B00AE; Mon,  7 Sep 2026 12:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 921786B00AC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E35EDC01FB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:04 +0000 (UTC)
X-FDA: 85187561088.14.C600E0C
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id 11BD3A0009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tOmVWiDL;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsJst8PFRStuSDVwSJV/FL2xzbq9iEwS7FDAi7P/CCA=;
	b=Azsu/jbwlVYTv0cedNybuqfrnCYmLP5jqlAA4US+U8H2lXFvV4r0scoeW7tw1q8HB4uqwf
	s8QRjhiyk7mnYOZNuQuzSTFl6Eb8Iwoc1+JGpDTVV97n8Q61JNRMLXkVdugHWj6b4AuJ+/
	c9CCGashqT2OQu9oT3o7dHx5n1XwyDo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799983;
	b=ZaWT/XFQeuALmcgi5igEwHwDQeEySGBGFsCETC225oMMMs/VzdIug10j0Kjchp+PmeEVjh
	0L8WFEs9XV1En0wNZzzGQiSCHCKNUR/A4BisNbBZaQKp6JVen+gKJ3Jpy+4XYnpj6CSLZw
	9VCXpdRXyWiLhL1xzeWJFxpJ+m2nyQk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tOmVWiDL;
	spf=pass (imf25.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso56667425e9.2
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799982; x=1789404782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WsJst8PFRStuSDVwSJV/FL2xzbq9iEwS7FDAi7P/CCA=;
        b=tOmVWiDLCypbT2EPIUyVwj7QPvqErf4BHmEr31Taeb/O/xaE519x10AOs0vhKzIyUj
         j3CpFM5KwLN8o8UQih5L+p4dkKNMnqyDTqCUibjSG7SHkGlaaHFULrD0KQXLrZBpEYA1
         Pf0LmWhQQzySGv0e6QMzOc9Ltx+r8dNIctVsdPqor5Sj1j0rlIN9zwb73rDaHuN8fV59
         4ap52d2943vxJDsRTAiq2CTjWttgRrjgDDQprmhhOi4lL19RV3zNsMvIr2ix6SKCEcBx
         zIqTz+mVPkj5MYIDuJd9weeZDd9VbAajt376MtET5OROXrHlCbtJHEP871p102oxYyyZ
         Pzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799982; x=1789404782;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WsJst8PFRStuSDVwSJV/FL2xzbq9iEwS7FDAi7P/CCA=;
        b=PX3tIm+gDAQdVu79RaUQpG09Te3lrvA5WEfzCg8Nc3ijF+Z/1PeqKqmLKUoRTLMYsf
         FnsoS+h2RL7HBGYwOkRUHBaNhvaV5cFnVslUTb5gTeK7mTo+6tQzfIgYz3qzaKHpvezi
         gbIZSng910ZKglAF9I0y/G6MQEAI7MdfD17gbYWyJKkjxD+JSoYOCFFTczQCkLjmlG0+
         j5smOXn2w+jMU86aCTPa9IdISAfT9FM6ZXpUpat6GIZj+RKkGwCYzCqQxHJGP9aCgHSZ
         dHCJ4FUZVI/FXQpHNoSEBN3DkZmFNr2zy8eNCme+oz8lCCc10J38j3VRhiXC4jCEVplB
         oWUQ==
X-Forwarded-Encrypted: i=1; AKwUvBxPeThMbarhrwABc3TQMJ3DD6hRjanRGXOvFEU/sXGflLG0x5mF15Kgy+zHauqu1ufdtNKiAu94ww==@kvack.org
X-Gm-Message-State: AFuF++lkD4TaDJCuNfz5nQ3CB6jHvCHoLQP3uqGky6XK3JT/Hl7Vov9A
	vZTeHLmpxQEnOwJ1//ufSihq2KX+3a9nYvceQFPzKGfCDtrj+zWfoJo/
X-Gm-Gg: AYBFou0GL8UNvFloKdVKMyWbi2K677fmtlWpGrPlNKruiqEjmvajswFEt4gmvzI2jvI
	+4BNUvJMAGPa9MVIdsuWpcbETOzFsP9CMR8Sfh7pA2iKqaJR1RbnsF3DZc79i+gLn/coSTBqljU
	of2HqaW0+L3QdZRAbZ2owxfrIomicYIeWnAocOIZ+t7egVwSE0lZSIEvNwA6p4IL9RZgNjCEbWE
	MEsITP9iHNF0jNIa+Rc/XXeAo8fl4iQX4eLqAltBiqTbCd+M4VawHFozeANE8kuBLNKg2cn7Wcw
	BWXfZpeu49wlTZMNrmeoA+w+kSrnDcpNFBtLNEVNdnN45lHW0ZkTAmlnMuRZSdg/Ubp2F9vl8kx
	f4uSFc299805B3YGS9VsXxMt0agYZRbomrJxBOuTKCe8dQHTiBz601GmYhkq8k/97NhhFHWIl0p
	uMhga/L/HtuxH19IOHTD2OWs3Lhc5x7rSdp7FVhjqw/K+ThWZLmCHAG3oCsIkHnh767nB5I9HZe
	w==
X-Received: by 2002:a05:600d:6451:10b0:49c:fa21:1c8c with SMTP id 5b1f17b1804b1-49cfa211d1amr150738145e9.33.1788799981617;
        Mon, 07 Sep 2026 09:53:01 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:53:01 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 3/7] bpf: Add user memory access kfuncs for mm_struct
Date: Mon,  7 Sep 2026 19:52:16 +0300
Message-ID: <20260907165220.52431-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 11BD3A0009
X-Stat-Signature: an5oy5fdxgb4rfmtw6cd6o4y5yxf7d6i
X-HE-Tag: 1788799982-933345
X-HE-Meta: U2FsdGVkX19pEBECzu5PvGu0UQyKCsbIMlM3cSi3si6MrQ7Tfr1AdcJia5IEYpA2+MPtNZtRrHQ87NnYIC9A629oFk9CXWSvVpm36VdZE45iYrr6Bg91sT/ctGSyzIOOQ9cNDV2xxWf3gZwdSeQklam3xbiphkmKCqTP6gXvjZqiaHpl4o89PnKnGx2/hMn1pmnefihFJxeG7xKlJAj6psZqOxPzxiqZh3042L1pLFq/4aa6qnoHeebAfPRRkEnC47yI3z2ZyOKQnqq4Z6VZszxszXZFHsTCdrNXKVsQnKTuu+yWDoTkbbeQIguRViZg+NN/WzWdVbLOmGAcizIOBMnA8d5TG449a+NDjnU+/RdoFqTyYkGETBUZ65xmiDI5XcgWMnMsFGjRZWkrV3ttYY2b4N5pOvXrsTgCbMWYIvHadpAblOKUAKcX6TsFZiAfIws1d57FYGsURyto7qaon1pWNCuGJCBO7Lg5H6Dg4n1z6I+YUeW3JkzObUHVWJzTUKHDL6k2uNMGHVvzssxruHjx0RlyVVCKeuYrqpKhGcrsEg78qClwWQecjYDkFUezAEPtvJH0bjo94e+v0qEz0b4+Fia/b94ck18RF9HenRosTED8xKJ4KpU3HCQ38Hxv0W5z0/GMkZv8C0++LBS4LPRtwzK85uhEYbsDTsWm8i2z+BDFpg+tdQxN5W3mGNhN0nuoeEXHmfGb6a2bZt1NnFR1gZJxz9XQo5j/lJQA+GkzsatGJM0hY0pNzblaMrGwWBOqJsRedvhfR5VIrdRRAXQf2nW88MjQsCvBMC7iv23aFq1tsdbFz9jphR5vut1bAWhnhy2pQAyTZCBKIQfKTiI2xdafbfAW1pEigDJxBZAxEkWZ9syvfawMqmqCLNY6+n7OoW0dECDu9eSKLUulmDiml7ZIWzcs1AXDl4qelqUKy64GcZXQMLq2yKH3KoPemdCr//c3TysM3vAmSjv
 EN66kXLQ
 GoVTGF5K5ghg2j7AbJlD+jP+guL7Vy6anxREjEU9ytwRUF+GkuiDsmqqHyfjKXI3ijuWnp1XlsV6Qpl2HJpI3SxOvTjAZ1QR0KePCF4dXzBrqN6EqEFBjq+bixvXTKcm4HAV1nmxG1ZjF0Yz5IuaU9ZpFtZrB9CzrLjTNCy5fO2dc5EJ2AIC2yBZgKe9QkM9SdPGR+tw+t3WgWMLvVGT+QcYN5HFvpx4D17nlGiW5bmkIQELXZHx4YirffQ6HAKdJWogFr5zB/wP4s4cuIlX+feCZkzyWBMPjiqvyHr+Q8Z2TZ1NjFfseKBCw5TFMThnjFpJhng/buSiQP/NPbHKBBRjfZNC/SA6oJZ0MGpOJ9RtbDVz5KXwcshx1EyVPmD8BWErYqPEtL0RCTa5JsM6fwsSuzu5pvVBjvtsBEUrEzHKh3VbA+72pLxcohq87EtYJakS/Nj3hqNlOcYUWLiYLaRN1413HH+JY5VvaQkHsPyk9TDXuyUOOGR+F7sltMMAL9XsQ0WAXY9+73lgdCCIO8nNRzMcd/fuN1WIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_MMU kernels, when security_bprm_check() runs, the argument and
environment strings for the exec have been copied into bprm->mm. The new
address space is not associated with a task_struct until exec_mmap(), so
existing BPF user memory helpers cannot access it.

Add bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() kfuncs. Both
take a struct mm_struct pointer directly, allowing callers to access
trusted address spaces that are not associated with a task_struct.

bpf_copy_from_user_mm() has similar semantics to
bpf_copy_from_user_task(). bpf_copy_from_user_mm_str() copies one
NUL-terminated string and returns its size including the NUL terminator.
It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.

Refactor bpf_copy_from_user_task() and bpf_copy_from_user_task_str() to
acquire the task's mm with get_task_mm() and delegate to the corresponding
mm-based implementations. No behavior change is intended for the existing
task-based interfaces.

Register both new kfuncs and mark them KF_SLEEPABLE because accessing a
remote address space can fault.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 kernel/bpf/helpers.c | 142 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 113 insertions(+), 29 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b3cc5c8fc875..d3c564437ad0 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -32,6 +32,10 @@
 
 #include "../../lib/kstrtox.h"
 
+__bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+				      const void __user *unsafe_ptr__ign,
+				      struct mm_struct *mm, u64 flags);
+
 /* If kernel subsystem is allowing eBPF programs to call this function,
  * inside its own verifier_ops->get_func_proto() callback it should return
  * bpf_map_lookup_elem_proto, so that verifier can properly check the arguments
@@ -682,22 +686,15 @@ const struct bpf_func_proto bpf_copy_from_user_proto = {
 BPF_CALL_5(bpf_copy_from_user_task, void *, dst, u32, size,
 	   const void __user *, user_ptr, struct task_struct *, tsk, u64, flags)
 {
+	struct mm_struct *mm;
 	int ret;
 
-	/* flags is not used yet */
-	if (unlikely(flags))
-		return -EINVAL;
-
-	if (unlikely(!size))
-		return 0;
-
-	ret = access_process_vm(tsk, (unsigned long)user_ptr, dst, size, 0);
-	if (ret == size)
-		return 0;
+	mm = get_task_mm(tsk);
+	ret = bpf_copy_from_user_mm(dst, size, user_ptr, mm, flags);
+	if (mm)
+		mmput(mm);
 
-	memset(dst, 0, size);
-	/* Return -EFAULT for partial read */
-	return ret < 0 ? ret : -EFAULT;
+	return ret;
 }
 
 const struct bpf_func_proto bpf_copy_from_user_task_proto = {
@@ -3658,6 +3655,100 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
 	return ret + 1;
 }
 
+/**
+ * bpf_copy_from_user_mm() - Copy data from an address space
+ * @dst:             Destination address, in kernel space
+ * @dst__sz:         Number of bytes to copy
+ * @unsafe_ptr__ign: Source address in the address space
+ * @mm:              Address space to copy from
+ * @flags:           Reserved for future use; must be zero
+ *
+ * Copies data from the user address space associated with @mm. The destination
+ * is zeroed if an attempted copy cannot be completed in full. Unsupported
+ * flags return -EINVAL without modifying @dst.
+ *
+ * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
+ * fails or is partial.
+ */
+__bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+				      const void __user *unsafe_ptr__ign,
+				      struct mm_struct *mm, u64 flags)
+{
+	int ret;
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+	if (unlikely(!mm)) {
+		memset(dst, 0, dst__sz);
+		return -EFAULT;
+	}
+
+	ret = access_remote_vm(mm, (unsigned long)unsafe_ptr__ign,
+			       dst, dst__sz, 0);
+	if (ret == dst__sz)
+		return 0;
+
+	memset(dst, 0, dst__sz);
+	return ret < 0 ? ret : -EFAULT;
+}
+
+/**
+ * bpf_copy_from_user_mm_str() - Copy a string from an address space
+ * @dst:             Destination address, in kernel space. This buffer must be
+ *                   at least @dst__sz bytes long
+ * @dst__sz:         Maximum number of bytes to copy, including the trailing NUL
+ * @unsafe_ptr__ign: Source address in the address space
+ * @mm:              Address space to copy from
+ * @flags:           The only supported flag is BPF_F_PAD_ZEROS
+ *
+ * Copies a NUL-terminated string from the user address space associated with
+ * @mm. If the string is too long, @dst is still NUL-terminated unless @dst__sz
+ * is zero.
+ *
+ * If the flags are valid and BPF_F_PAD_ZEROS is set, the unused portion of
+ * @dst is cleared on success and all of @dst is cleared on a copy failure.
+ * Unsupported flags return -EINVAL without modifying @dst.
+ *
+ * Return: The number of copied bytes including the NUL terminator on success,
+ * or a negative error code on failure.
+ */
+__bpf_kfunc int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
+					  const void __user *unsafe_ptr__ign,
+					  struct mm_struct *mm, u64 flags)
+{
+	int ret;
+
+	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
+		return -EINVAL;
+
+	if (unlikely(dst__sz == 0))
+		return 0;
+
+	if (unlikely(!mm)) {
+		if (flags & BPF_F_PAD_ZEROS)
+			memset(dst, 0, dst__sz);
+		else
+			*(char *)dst = '\0';
+		return -EFAULT;
+	}
+
+	ret = copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
+	if (ret < 0) {
+		if (flags & BPF_F_PAD_ZEROS)
+			memset(dst, 0, dst__sz);
+		return ret;
+	}
+
+	if (flags & BPF_F_PAD_ZEROS)
+		memset(dst + ret, 0, dst__sz - ret);
+
+	return ret + 1;
+}
+
 /**
  * bpf_copy_from_user_task_str() - Copy a string from an task's address space
  * @dst:             Destination address, in kernel space.  This buffer must be
@@ -3681,25 +3772,16 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 					    const void __user *unsafe_ptr__ign,
 					    struct task_struct *tsk, u64 flags)
 {
+	struct mm_struct *mm;
 	int ret;
 
-	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
-		return -EINVAL;
-
-	if (unlikely(dst__sz == 0))
-		return 0;
+	mm = get_task_mm(tsk);
+	ret = bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
+					mm, flags);
+	if (mm)
+		mmput(mm);
 
-	ret = copy_remote_vm_str(tsk, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
-	if (ret < 0) {
-		if (flags & BPF_F_PAD_ZEROS)
-			memset(dst, 0, dst__sz);
-		return ret;
-	}
-
-	if (flags & BPF_F_PAD_ZEROS)
-		memset(dst + ret, 0, dst__sz - ret);
-
-	return ret + 1;
+	return ret;
 }
 
 /* Keep unsigned long in prototype so that kfunc is usable when emitted to
@@ -4924,6 +5006,8 @@ BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
 BTF_ID_FLAGS(func, bpf_iter_bits_next, KF_ITER_NEXT | KF_RET_NULL)
 BTF_ID_FLAGS(func, bpf_iter_bits_destroy, KF_ITER_DESTROY)
 BTF_ID_FLAGS(func, bpf_copy_from_user_str, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_copy_from_user_mm, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_copy_from_user_mm_str, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_copy_from_user_task_str, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_get_kmem_cache)
 BTF_ID_FLAGS(func, bpf_iter_kmem_cache_new, KF_ITER_NEW | KF_SLEEPABLE)
-- 
2.55.0


