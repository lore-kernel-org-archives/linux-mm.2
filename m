Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52048C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:23:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24E966B0098; Mon, 31 Aug 2026 05:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 225656B009B; Mon, 31 Aug 2026 05:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED3E6B009D; Mon, 31 Aug 2026 05:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBC166B0098
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:23:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BEDCA0428
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:47 +0000 (UTC)
X-FDA: 85161027294.30.EE8FC19
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 95ACC20003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="h7/t2X+4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xLhekP1hyFFXIKTW9u0l4JwtljKTcvPghf3/4G/CKiA=;
	b=RiaQd96vjuVAW8QGyd1Fw47IhRBHY9RLr5+JDx6bKidD35oHqMRUyz28+KKUjUiphFTRgq
	k/lYM04lGWwn5qIAEGuUB6uzgsGPHg0RuE8JgX3TGFXV/4OVGsyXyzOrAdI0ljUJ2WIA4x
	/DY1HGuGOKkjTP/+k2HB8pK3wGxUO8o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168225;
	b=0aYxqw9weShyWMuc06saryOjWrvl7EMyTgKis7/7djyi2rpW/nQB6eckpA9SyVhI7jHhZq
	aNeKi2KTBfUxIJBUn4KSbX9yQnNHTZjy054lqs5b5slgGLe0H4QXtwzQEuYRCNm/tOHT8T
	MGfHcofrQKhw6gl3YaL/0DwSgB4nw9E=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="h7/t2X+4";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49b8ce9b733so21740815e9.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168224; x=1788773024; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xLhekP1hyFFXIKTW9u0l4JwtljKTcvPghf3/4G/CKiA=;
        b=h7/t2X+4If+sOnK/ZCFf/7I+Out5+l9vvUh4z403Ww1IX4/w/X8/p2vtx0gQcyS7vE
         p+iRuyNBY5C7ogC1H50Vr/El8oBFlYyQHdKRdnZOOZYHQWHBQtj8NbCMhMuV8dYwUqMA
         h25DJc23khp8VC1P2sq+sUJCOPYgu9UNESUd5C/TU47fDgwNAFzdkKRzMzBMGHxN2t3T
         HShT4u3eE+HQ/YFRLT2savQBzF4+Y9kDsdU+tP9q17TMlZpum+WGVAss+UPOoBSJxsu2
         sQcPykObEIcVolZ05EwD58vT7etWBkgthWZExRT9fVJ0g/faLBBf3LZ76hJOKvhtPlka
         WfbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168224; x=1788773024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xLhekP1hyFFXIKTW9u0l4JwtljKTcvPghf3/4G/CKiA=;
        b=br7hwRtvcl3+6wGrOt6LVSODOTwUmuBnpt+S2X6S9KsNpHEoeIgDx/J8BRaJssMndT
         9GYlqIfTXoHfXaCS43XPYVAbhTLGAneghwc0xBvKIotIDWBtC/txuS2isO+E2pUCK4Kz
         eAj/v8I7o3GiROzEpiT28shW1jthVeKVDCAiEtU9MaI2RoUTP813wNfrm6hjKtHvQ/Fu
         AxDU6OQwDAwa5soFmwJXQVPBGFWTtEyQM/BPEP1TKy3aQwm6egrUI36mUgRJotq9iaeD
         D10d9TY9R5hVEZBZW4kksJKdzwMBRcrAel2iyoz35qiqbxB0QvU7kXNm5b++N1d9KkSC
         gW3A==
X-Forwarded-Encrypted: i=1; AHgh+Rq8l2F3C7u6eyFjlU5TFQ1mszoUO2FgqCndrgSMKJsLZH5fn7rNBmEuNQ+CTq5m18ngdOrcocyGEw==@kvack.org
X-Gm-Message-State: AFuF++kIbfJ0i/j2a1pT7rViOd2VxTz5n+JnnRvHwEUUxd7zBAKlW2KI
	Z2cUV7zhfcxsw9oljbJcVzbeqlpW5orexGv0NaqDDg4BqxwPKT4bXI9O
X-Gm-Gg: AR+sD11PsTYLsabtpfEW3ujm9Qh2zxqvr7YqOoF32JKO3KhgOPV+KCKn2AI9fJGjTdA
	XzL3FD35E9WQfJo068LcXSPqLQfy+eK+YNDk102QJPK0+SZ4gEB64vhq/xx3TIpOlFJedGNiRuk
	nKvpkY1zo7LezxgPwzuiuCJldw4tTd1Vh+cXPbzk/8x/5pdtIZKn9kqsIB8L6IvfVugM9N5ausm
	t+Y+OIKwhfLHyZsN0X5YVADpYnh68HQjZG+nThDYpVfnMWjN8F5N0CQHWWn78cArY6UlPCaL4ha
	uBawgewYqPnu1TVG7VvNSiSDwgIwkh7c/Z2FzzAwP/kZoh2GNkkmVJGJr3/MqFtGbcYiwiqdgO5
	D0rwiavEQYOQ6accOjQ6P3YljVWJmVcNy6P3LipkkO4DGiF8ydUiFheNc35OJlFZ9ZeKaYKlFb9
	Bc+X//O4x+3PfQQShzD8I7JeqpOc/4Z0Ajdhw0SeJYG0k7iFL9ttcWC8jtBCZ8z12CmihET2qtH
	Q==
X-Received: by 2002:a05:600c:3e1a:b0:49c:cee2:a508 with SMTP id 5b1f17b1804b1-49ccee2a541mr225871815e9.16.1788168224225;
        Mon, 31 Aug 2026 02:23:44 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:43 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	kpsingh@kernel.org,
	matt@bobrowski.net,
	song@kernel.org,
	utilityemal77@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v3 2/7] bpf: Add user memory access kfuncs for mm_struct
Date: Mon, 31 Aug 2026 12:23:00 +0300
Message-ID: <20260831092305.42062-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 95ACC20003
X-Stat-Signature: sutyfn9kopiqrdej59npyyc4yrq67guc
X-Rspam-User: 
X-HE-Tag: 1788168225-89200
X-HE-Meta: U2FsdGVkX18MeyBgy7JK81O3Rclehj7lEqsrA6OpMI1IG2w412hO5WKD3eOqRU5qcvse+TyCbrlfgojtELOdH2YjV9OONdNNq0xtaAnThGrh0ZYd83eXhxE+Phn9h+DIoEdUEEWbl8Pr6ckm7en+wLXMgOSMIQfHoO03SV7EFVTsC4yLvgf1B7i5RscHu4LFI5jLgp9F+Ylplbk3A394Z7Ei5r8S9CcUH6wBGlZRvXacRIBiFpPnA4tJcpNGD6stHW7JkJfI86Oei1Np2LKNbZ88P9+fd902hYZKXO3MMUXvZXRnd8I2BtXpdxfcp31Rkb8b2OG80NynPxnJ7tfeuP8hMlR4zleT0pwQvtKexkv8PUF9qBnvxIbZov+tsIuqc2kYPpMKfrWcXt0Nfnht53bMnn59i9tF1irsFwO0J67AhOTo/ozsqxQwev7yzBsNjHkDyzPh3Qtvryq9Qtb2LohJ9gu73jVOFD4gCEB4stXD/47F8OuT0HbjNIGNYWgz7j4Qrr6ZRvjvpb2GDadfST9MIfoO7Kfm9XMmmydnAySh40r5JY4EfswhMKwx1ylQBHlt8Udy3PsyehnoQgcXguEf4FAK8irX8nsZuZxdks6Iupp1xaCkGNvG0lkOJ2yuHQ9IliqzZWjlfQWbC+rm2ZVnL2ifAXTO/ULNp7bA1ZKUTPHrqezrGyLvan9pBr9Bsv46/OA8NnnjVERGWjymDIvEKHZ5cgdtr5gBmRPFADefYKUv/2QAlX3dXkS12mbwuPSc4mDBAkdKR8pPY8+XQNV2kLrJwLDStGWxjkYPrv9PseoxagD18kV2aiYlGZuT5fdGePwbCE3BkRCcTxvZgsD90Y/OY1tY42Y0uEa+GJUnsvS5QomO40Uj7xqPYTfmTIS7W8tLLqlJfw3P5clOj8UEiY+U8mYb8G7+Lc+LwCew6lzJ1ZkyLkc8e5mwanqsAk4d0reQyF1OvBHmPEu
 ElLKpPng
 w50uUWHAZ3YqDdKxL48Mw6XZYIhLC/BtTMG0PCtperF+NR5Y6eMexgOXK/aJYZgxpyI399Hfh0cLHD2LgLZ3i5ZwIjE7CQrHkzmiyPoaV+52uqRUFvkDc0Rqqayas2LxYeSRfg22zv+xl/SIx0QdD/YpH3CbGJAQgkksmcFnR+svcoXTzrc0R58tCMXTaJaimKQP5U15ur7gn+KQgGelArxRxrTZMC5Z9HrDBDq5sAfF3zBNAe69BzrtoWA79SI/kB09BkBmRNQpTfSS6erQATq+yCOV0mvIMDvE99HEH2Rh51L+1W8KUppk8zUYx6DOWC4K5FhUJvdi9eM93AA4/T6h5qydsRnuur6S8tWcyataPV/0zxvzA4V6McWoDGaB+kFLV+cPpXFK6On227tgJqwBzaFguN9z9G7eR7AQ39LwTo/XdvYR9XGYI8bVoM8pK9bbUjux7MYc/7+2exeoOO+jtJHCt7eVg7XX4RCYAAr9JzCbpMN6iOyDSd8mBomDfl0cj+nknNIjXATi8JjIfaK7C6oV1I7rjx8cZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_MMU kernels, when security_bprm_check() runs, the argument and
environment strings for the exec have been copied into bprm->mm. The new
address space is not associated with a task_struct until exec_mmap(), so
existing BPF user memory helpers can only read from the calling task's old
address space.

Add bpf_copy_from_user_mm() and bpf_copy_from_user_mm_str() kfuncs. Both
take a struct mm_struct pointer directly, allowing callers to access
trusted address spaces that are not associated with a task_struct.

bpf_copy_from_user_mm() has similar semantics to
bpf_copy_from_user_task(). bpf_copy_from_user_mm_str() copies one
NUL-terminated string and returns its size including the NUL terminator.
It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.

Register both kfuncs and mark them KF_SLEEPABLE because accessing the
remote address space can fault.

On !CONFIG_MMU, exec argument and environment strings remain in
bprm->page[] until the binary loader transfers them to the new process
stack. They are therefore not accessible through bprm->mm at the
bprm_check_security hook. The linux_binprm use described above is
CONFIG_MMU-only, although the new kfuncs remain available for other
address spaces on !CONFIG_MMU.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 kernel/bpf/helpers.c | 115 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 101 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b3cc5c8fc875..19c01aa734ae 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -32,6 +32,13 @@
 
 #include "../../lib/kstrtox.h"
 
+int bpf_copy_from_user_mm(void *dst, u32 dst__sz,
+			  const void __user *unsafe_ptr__ign,
+			  struct mm_struct *mm, u64 flags);
+int bpf_copy_from_user_mm_str(void *dst, u32 dst__sz,
+			      const void __user *unsafe_ptr__ign,
+			      struct mm_struct *mm, u64 flags);
+
 /* If kernel subsystem is allowing eBPF programs to call this function,
  * inside its own verifier_ops->get_func_proto() callback it should return
  * bpf_map_lookup_elem_proto, so that verifier can properly check the arguments
@@ -682,22 +689,15 @@ const struct bpf_func_proto bpf_copy_from_user_proto = {
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
@@ -3680,6 +3680,83 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
 __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 					    const void __user *unsafe_ptr__ign,
 					    struct task_struct *tsk, u64 flags)
+{
+	struct mm_struct *mm;
+	int ret;
+
+	mm = get_task_mm(tsk);
+	ret = bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
+					mm, flags);
+	if (mm)
+		mmput(mm);
+
+	return ret;
+}
+
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
 {
 	int ret;
 
@@ -3689,7 +3766,15 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 	if (unlikely(dst__sz == 0))
 		return 0;
 
-	ret = copy_remote_vm_str(tsk, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
+	if (unlikely(!mm)) {
+		if (flags & BPF_F_PAD_ZEROS)
+			memset(dst, 0, dst__sz);
+		else
+			*(char *)dst = '\0';
+		return -EFAULT;
+	}
+
+	ret = copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
 	if (ret < 0) {
 		if (flags & BPF_F_PAD_ZEROS)
 			memset(dst, 0, dst__sz);
@@ -4924,6 +5009,8 @@ BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
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


