Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79267C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBFB6B009E; Fri,  4 Sep 2026 10:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B6C6B009F; Fri,  4 Sep 2026 10:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 644246B00A0; Fri,  4 Sep 2026 10:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8FA6B009E
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:27 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CCDDA2074
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:26 +0000 (UTC)
X-FDA: 85176375732.21.428FBA6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id A09DF180006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="m+LCw/HV";
	spf=pass (imf16.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533664;
	b=4gNHyOHDZE6sCpCdqEASTkXeQ/iV2wUdBapayZPFvWQo0IDWovzIQ8xebOzTa1esdF84j1
	h6BKSt4hzXDjdz2DSB1jYOuD2ofqIkazf2gpbjDWotcCF6rJj4votjWMP/R2LTmN3MMjN3
	+v5RWN0LnvBouGCjNGfxK9lzsy+2iB0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="m+LCw/HV";
	spf=pass (imf16.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsJst8PFRStuSDVwSJV/FL2xzbq9iEwS7FDAi7P/CCA=;
	b=p5WPNJiE4qB3C9BBWPCB2GmC0zcMH1SNiL8LqqljygFdEtgNsU2quqb4BbKEaFicuNEmQs
	Db6cFsXaboTCqbkTQERHdYZoo9Kiv1t4/oEpJ/cmfnFqE6p2o2vRjSss2byg2wT6VRH/XS
	J8nUS55JNqFSARjuHzOpbt2csEKQgWg=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-495590dde14so15358635e9.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533663; x=1789138463; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WsJst8PFRStuSDVwSJV/FL2xzbq9iEwS7FDAi7P/CCA=;
        b=m+LCw/HVSnzURn/rjRNiBRgNTWPgQG9rh9tWtBqTWzpi7v3Bh45n+7DFYmHYVdC9xW
         KlmdTUGGL+g555d6jObJU0QBpeg1KCfoLqIEy77sv4btfC9VbW+HhLwpSPP1I+PCg93H
         18nVOf8pMGm8JxWS6xlR1667KAWl0Eba0VJPGJHU7VDwfN5tEcjw6n6cwJokhWUyxD1i
         lekPwM/PlPIFYSCK58IocBXQXXsq++890l5RjwVGS4+hqLNajH6aWLoEYa50BwfE6AE/
         ZX4Eob+YNntZB7XOZfARecM3O5awdd+99ig3/ZMYRexCDEZkEIfOoe/3Cibd673Jgafk
         IVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533663; x=1789138463;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WsJst8PFRStuSDVwSJV/FL2xzbq9iEwS7FDAi7P/CCA=;
        b=CVSzxoWQvzxAQ9Ksm85I9nUX/cSN186vv0uBoZK7cfwZt8yAqJ2duhN5O4aV2MTLli
         ghlkS+4f+KxpCtO+T5VTfE5RW4e5hDVPzje0gThvR6VqO8n9F7WkOLVIM037YKrYv/un
         2v299ZgKGakbi4TUvgest4Xa6gPdYUGlei5vaoepbFdcBUXLpd8PZOF1vjJvkfkYlv2C
         JAE5jShcWJXSj0Ua/0Yg+8CpBQ1jv3E+GSyr3IoMGfABiWs7MP2LekP8PMlySPnD5IIh
         vaxzHepP6ChKeff5fNga11CHPkIGNahwZevXNKis6O6ZKOJOLff8fwutCZXiB/ImU7/B
         murw==
X-Forwarded-Encrypted: i=1; AKwUvBwGJshtL7lZ6nQsjmJ3fi0guDo8Egl8ZyH4oV7Ve8SOozghkfPx7V1HyGnNTmUf2ZULco61fbh8rw==@kvack.org
X-Gm-Message-State: AFuF++muY9NfCcPp5mUVZyRKhTkLp488+ho8PSIXi+Bzs1ToEkLdejmb
	S4VgzuI0PxYXtzQZTQKNNpVw82hdeFIPER8y/QVxHW9AfQqExNLeDO1C
X-Gm-Gg: AYBFou3at+L+O1ZDsgJmUsHo10TcbNwKzJKn+mn246BYFDzXjEz8E284NlcCzk69Zhm
	hTW6rF1uV+BKKMmgcUIVcQlIAD7rf//6AaEggoQQfvpezvdbPs3Wuskiq6SUpSNoC2jRCsKnLX3
	IrkMKb3mtrTVBtOsOBy0xVY4ocq7UIk2EQON3So8CKGXIqyVtxenX++jKf9fNVATC+6emG2pu4p
	PV/VUoqguSKKx26cdXBTLACJNG10gg/kn2Q+GMx6qyd1sDrfTcuPGT05VqVAhZ1gQcvU/6P0+Dl
	9GdHX+vxO1Z5LHwR9SRJA0pxqA2BGPAs+oqaPteYTfTqMUiaYttgFBbO9NMcxAsRPBhvJUU0S/F
	qpcchfvieItAf+/J5FJRz1obZaZj3FKFprqTrw0ww3CU4B5c9lDz6L+FFBiZ8U9Hbd9pgj551JE
	Z9kaRjTyKLiHSra5bY5/mtVJ8njIWHzel4890o16nFN58fEnx+cIhL0qoP7MOnK5kus3CReH/5z
	1F7KJUrcChF
X-Received: by 2002:a05:600c:3507:b0:499:a5c8:c6f3 with SMTP id 5b1f17b1804b1-49cf7fe6900mr106125375e9.3.1788533663103;
        Fri, 04 Sep 2026 07:54:23 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:22 -0700 (PDT)
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
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v4 3/7] bpf: Add user memory access kfuncs for mm_struct
Date: Fri,  4 Sep 2026 17:53:36 +0300
Message-ID: <20260904145340.40212-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nxuhhsrhezkwpub6tag88878p4r5kkgr
X-Rspamd-Queue-Id: A09DF180006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788533664-79127
X-HE-Meta: U2FsdGVkX1/4YK4W8ayqLEbq/tlJdVBnOob4ZGYzPh5VKSifElYQ3GRM7ayFFM539+HtjzBRkpZDm7a8Lbq6/J+E5DlqWR4kWH/N/tHQCG1jvZfofNQYKIak2vZyfv+S/Kcgybq/dMl7au9EsQ5Op//1eonrE1qFIpjhbW79EbZgsoZbxPtawwwR6fALwR7Vhm2VtW97LMas6IwdrSo77+s0wHAHpDNfutPrAziK6xVkLbTEHsLVxZZvx+Rpm/+IfHKaDHV3NfwXr6nGrtLycFkvd7OJF+ksNG5voLIZo9Pj3Ep67J0KpeH6tsLsA7zvSzKtvjZVcv/+ioanIUVQnDeD+W6BlgwXFm726ByWx5rT6jxtX9RcsZVtAW2S3IKsaqUVhngT86RwgIOewB1+r1wSaYSgW/NssNVBYXVnRWgKzOMS9tL9F8bsDDu3sn8tCDpQq1HsuSsie8/lSyKrI+MWlUOBAzBIyRwPCFVhef4oFvHLtt+VNqRFG3xjqbGGQ8MozPQWahE9N8NjDIbbFTTYeLLuuwWgX8EnumZzoP1psX9mPX2x5oQxBFOKjskabAl5VXNOXojbeVYFobPPs/tELrVLKQJT6xU6Kekq5racEM/f3An0IdaG1HBT5UFNuESCijHguh1dtgTJfrr1tmT2IUWIsRh9QlNOTFgo6JPXcy8793yXsiBMfNZghnYBr9OPOYBZv9sRH/33ML3EJFoJz2M4CTt1Huv+tiUzrKI/UwiUIA6gArC1dM3f2I68lSDqo1HDaFLzqAKZSJ2r+XJ0kh7hf7MkqiodD6u3sAPlY3QHzuimPPaO66PVFKGhsbKFp3X2bLVdcYbMWZsEj7jxbU9W75iNF9N7XOezuVIPaqdxuQ9H9AfmiPCag6OKDnRH8ZqVp4Evlm1K5jVZZRXj9cFPN6VObmrR6z9Vb+MlrkQ3/rRMJILL63+MqwHoT9SiBvb0/BWz4mpQe6W
 1DnGaEip
 3DRIetv2/iONircNUhsN/RzdNrLaA0uJwPUBkfLdn3ahJWzV3awbHeAcnzu0xqb4K2XjUh+lyTNArBrfp4BoO83GeP5XwpFfqRN3Bg6j/BhYPW3ME5+VFKdSulGsFlcjujZYzrWngjddDzmmaKKJYKnnuWHQ9Q2pkCgr2/omy0YidF0L9T5kN4HFdfIEmVO7LYKGrIvTrGEVFTAAEW0l4gYnDMbj02C9+SHx1i008ra8p1UuVS0XIWkIg2GlamyZFj3GkEu9uLe+7dturAIbcj+bN8ytsHe/LUZ8p3ucg4CZ/wVWWy65H1Sd+BeiuxyArt0wua/OUZ462v5rarJeXPt3oUAGAKQG+1fK9g7yn7qmHQ1vHWGguDvVoZ0B0O6Qcv0yzlv5vH8zEm8ddXrbxM+DkXf9NishzIzNoVHRHGfHhfSLmvQej5FgcpzWmigCje1Xl+80XpolRnYUEMbVYca4FCsknWKYMrMYZvBvbdmL76Gca4yBMhjDAqNzKOxC9trqQWOziVr49cCfUTxyaIbVRC8BbFjcj9lGg
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


