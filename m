Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74F79C982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D3C56B00A0; Fri, 18 Sep 2026 05:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ABCE6B00A1; Fri, 18 Sep 2026 05:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CFF6B00A2; Fri, 18 Sep 2026 05:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8B1F6B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:11:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F7321A05D2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:30 +0000 (UTC)
X-FDA: 85226314740.17.FDC5CEB
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6593714000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:11:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hUhZGHtr;
	spf=pass (imf23.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789722688;
	b=bS7Dpd+xIYE1NmtT1fcfh5IfMQVz7xDHWiAamP3NNqnrtMDaaiVY4hKwBqOK0cZK/QYc0V
	O1Kae7LjiaLJxTLwFb34suJctGyvH4CqkqDrA1seIAd+XUpZcbm8C2jhEzvj3UbQTyMRS0
	2ljvJ+HEWF+HSS9ieOT5JMcsWBEHFIQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hUhZGHtr;
	spf=pass (imf23.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789722688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgg2ZQjMkxD6u2VdMZWByOLhVUwC2QQ6a1L3XaBvWsU=;
	b=g+iiJG5/SkQntw9UZPbl2s67TAJESNuFP3sU4N8U7mMhuHXnwNC2vSJ/pesWDMBfgvEUhE
	91VQvghXvFYcJqY83OdNmAnQwT9asiHgbCKg6Wcc2TtwAbdqeBoda7IOJJS/5Wf1b6QR+4
	PNUpwykOsOabGoTwVcsJ2fhBRWwiC/c=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912e2406so2574545e9.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789722687; x=1790327487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vgg2ZQjMkxD6u2VdMZWByOLhVUwC2QQ6a1L3XaBvWsU=;
        b=hUhZGHtr5recGRrh0xoE9OqIlUsvTkSsD6PGwlx3cEfu6ITYMPVwhKNUnPx98sOVSO
         ADVlz2Fo+byivmvLGoYVlZAIQX0nKZPq2ATZkwADmYO+hOFXT9FG09rlqidNZ7TVyXSB
         cO6/mopnf6bKvLtR5F8q3GkepLQGqs//sCiaCZiq5bC6lFaUTyvFFji8z6Jwf0YMc8xY
         lNt4Px0ZpEOY3JwcBmdJ9xWrIUvQA+cMl03lY3gro3G5RF4f74d+ahCerlzeU0YaoZU1
         CYcNRihPyj6W2h0VzDvQIYkf+xPLfj02t6IO/dcFLYxHMXUjGfLpWyRfdTKcT2WhcbBy
         kQAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789722687; x=1790327487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vgg2ZQjMkxD6u2VdMZWByOLhVUwC2QQ6a1L3XaBvWsU=;
        b=kH2zs/fNFg24bH8tjmnd45CaFt4H78fPgxZspSQ6oFB5zQdKF7yvaGDUxKCNXZlaYt
         vfPWhCyWuEZ0scUc3x7p6kYTi9qDvrF8CzYfg3FAfq9VNfbTut02DnYPJskzOMiJoJKa
         bCx5+yAhVQmOzWcLLBm2wENrAUbngRVCDYBjQW/217jtRAQ2bFKYGEAzQ1bnKLbwUiZX
         OGQWYvkPu202+bsMjsRt5ig1u/aXHyexRSk9yvNmDm+h+U4wXQPSYAZfIqwxD6e0ZHwD
         TCZSyQksQzaa/LkBRQqaJouDsPdLRLNsU0gpMLoRA6WrcDUQBn8nX07AnzMfs8yELnc6
         nbcQ==
X-Forwarded-Encrypted: i=1; AKwUvBx+b7JGG785N7v42frhz4AqwbTiAe3qHZhIXZ6aNiDYR3lLdDKdicMQ9JYpUQ9oDR7jm9UCMgdukg==@kvack.org
X-Gm-Message-State: AFuF++nuz1niEdyDR+mEo6SzodMZNDtMJAk4GjhmlPB82QE9+Azgsmsi
	X0OYSJGzm52Ph05pkaJkHKGC6Yu5+snJaJbuAO6FFqWKZLUrdnsIv072OtAS8IyF
X-Gm-Gg: AYBFou1uDrsdbvqekG0AogMmmk6ML7ktdLhcRzIlMrtX6StrbpkE2TjyBhpAwmR1RNE
	KvWn5zvO18N/+HEDYzx5uZ96K5BK5/wwU8o0k6yCt9YVJDHdIkOnRxqzWoQe3WaHN5NSQR1c+/Y
	UWq+wA5WvYRi+uudBc/27gR7aBR17f/U7/dD0fn0q7DlkN01V2tHPW03/KY7Ru0IOdbBxBBfZUc
	b1T9NKfWUGGi7LakH3sQapLoYAhRE7VhwTYCg9vZdht42pqZdw/io0jlD2BBflcuc4qb+O1ERxs
	VIZjBD6CTFZuH99I/X22ZYkMsstMLIzu1ocNMbkTKFTCV07g1u8jq+BaKrIoueDEr79sOmKmLGz
	TNLT+XU2CRbFHPUuiRwd0X7JQSwhFl0MNiXR6qhQr+Qvtuy7QZ+yaP/9rf8hCb1DLNpbMGNvDvN
	qgaEVkvzqokLlhdIX0EYLqj+tIAWK9o0LmC/5GX6GxetVF8gYa7lChZtQ0s5PmEEcDBzv0U/wuW
	iJrgJXyYAN1FD8=
X-Received: by 2002:a05:600c:83c9:b0:49c:f13e:e4d with SMTP id 5b1f17b1804b1-49fc4ff402cmr25215605e9.10.1789722686994;
        Fri, 18 Sep 2026 02:11:26 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0978sm138774275e9.2.2026.09.18.02.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 02:11:26 -0700 (PDT)
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
Subject: [PATCH bpf-next v8 3/5] bpf: Add user memory access kfuncs for mm_struct
Date: Fri, 18 Sep 2026 12:10:56 +0300
Message-ID: <20260918091058.297740-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
References: <20260918091058.297740-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6593714000A
X-Stat-Signature: rk5rudtrt7xf741s1pdykpnx6cnqadps
X-Rspam-User: 
X-HE-Tag: 1789722688-285415
X-HE-Meta: U2FsdGVkX18qr+Vm/MsFYmGE2bqa8Fi/Xtjp7y4WhT4mSrtOMV51RnFUBFduuRBE6WAOWYA67CMb/nSd+zb+UwQ1GMK630jEjV3/Fs94tHS3UDrV+bcS4i/Z79/m8iSdJy3w3lofEqGoiILCnrrgt9tzUDeK3BMyHm5T8OvuDudWBRBEbt6I1IzlguhHhGBpj0TWre6I1eKDvileA5hbqkE/6TZ+zEIUWFyCy+zso3IxDa45lIPKGQzrcnJdXZyIouFDD9uZjiX6GT5+pAq0WgTC7HhirIiirJiSbbxrphI/jxLDCzRm6fAkqfPlvhRtRp3knPyvAkbPvhfAf1dCcX3ApWSQgmFG6fW6Tkjbt/JNDfnniAhIwKlQEfZosILvu5k35o8D/sQ4mWUewmu1mrWm5g2JLBrkbozFYsXbrnF4z/Z5Q1Y49KWM7s4qqxsB6oj/ppGSJvLPs+Z+hCqYFVvtW+OqQuNETUYfNh1SLxWrwNv1aWQzZ4OyFMNayVdgii7MRzirz3UBUFxxkaEDW/YhmBdxXjU7/IPypOkopL1TqOwMAFuM4PmKvNmHjqa1Od4k3V3161qXLrghh62MbgqLpSbYNgCVtFz0H2/QwYDIwyauqMKq7WusKL3GVf68cqboAE+ZmLsKPtSt54zQIV1YIOYT8hjM8nDDPu4a/xSggKDFTm2jAjCmtoxIVA5qi9jrz0TgFNzWuyVMRNifpEzjFbl9CVqcdUOE07mZ1KFL6oNQtadxXiNqhrbVofKAVaE020JXUWYhmBJOnAU4W5l7+8kvBv1ZseemrGbkQ+6S6Rpf1OgQg0DNbUbTJE8kl8ss7eNLDXHrFyUyBesd+8VQ/Z+gVrQhMHnkUnNslsoagDhMQsRuW0a0yHoUNAtFg/lFW+xETT08gkJ34BL30iE8qK10fsJZ7fBeBHVDoIaDLx0URkdJPYcfVhgfJJXcZa+GIr1tFVDR0jnbHHY
 wsoUNz2E
 rMSoDIgo2LVsDNthhZMCU7YG8EEZ3lWt5hkhERK00kretlHLUliDZi6FsUz9nhSEDEBuxmuKT8JwFYl1q69tFCpkq36ErS1+gmZjK6SUGV5EkMv/3Krt96MVUz+bmhAIxGYoFfcaC5hvtDOnTl+jSZd5igu13uMxqE7Safn17SLe6vlgN4u2eVoeM2zFE7LbFEanTwjTfXJRmg2mt5PBSdM/zB2dJcmXmgzSJ4uOz/a+2eNPHzQCBPbcH07mpxxPgFKeByohoMqh6cfOID6hskEBPgD5tEkZNExLVVL/aUZrEpgKNqpgz01k6aJbmuNrcBjIE9ZPiFmngm81i5rqjSqDUCRJn+QyL1wONMBrN76XWFC8kj0M9CPbrLtus6R7odALmX1wgf31ManeD8c64q1alLQGQ6i8HsgLjmpg9v5ymWKRJ4eLihn08A+1IQM38Q32jUAsKDKMArUY1UZrbomR1XcdUfLf3vMFfS2PdMErKauAXJe/HRLR36SEfwvxsKFZKnEq+Bfb/1V2dqx7BfZnM5q4yAtCqVZe6uLNCb+VjDcwkpqrZL43MlqzxFMB8BECplkmoqKtnBLxo/kow0Qn0Ve/Ig7FQAFJB
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

Refactor the task-based helpers and the new mm-based kfuncs to share
static internal implementations. The task-based interfaces validate their
arguments before acquiring and holding a reference to the task's mm for
the copy. No behavior change is intended for the existing task-based
interfaces.

Register both new kfuncs and mark them KF_SLEEPABLE because accessing a
remote address space can fault.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Reviewed-by: Matt Bobrowski <matt@bobrowski.net>
---
 kernel/bpf/helpers.c | 130 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 118 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 051b6654e57c..f6b3eee6098a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -679,9 +679,44 @@ const struct bpf_func_proto bpf_copy_from_user_proto = {
 	.arg3_type	= ARG_ANYTHING,
 };
 
+static int __bpf_copy_from_user_mm(void *dst, u32 size,
+				   const void __user *user_ptr,
+				   struct mm_struct *mm)
+{
+	int ret;
+
+	ret = access_remote_vm(mm, (unsigned long)user_ptr, dst, size, 0);
+	if (ret == size)
+		return 0;
+
+	memset(dst, 0, size);
+	/* Return -EFAULT for partial read */
+	return ret < 0 ? ret : -EFAULT;
+}
+
+static int __bpf_copy_from_user_mm_str(void *dst, u32 size,
+				       const void __user *user_ptr,
+				       struct mm_struct *mm, u64 flags)
+{
+	int ret;
+
+	ret = copy_remote_mm_str(mm, (unsigned long)user_ptr, dst, size, 0);
+	if (ret < 0) {
+		if (flags & BPF_F_PAD_ZEROS)
+			memset(dst, 0, size);
+		return ret;
+	}
+
+	if (flags & BPF_F_PAD_ZEROS)
+		memset(dst + ret, 0, size - ret);
+
+	return ret + 1;
+}
+
 BPF_CALL_5(bpf_copy_from_user_task, void *, dst, u32, size,
 	   const void __user *, user_ptr, struct task_struct *, tsk, u64, flags)
 {
+	struct mm_struct *mm;
 	int ret;
 
 	/* flags is not used yet */
@@ -691,13 +726,16 @@ BPF_CALL_5(bpf_copy_from_user_task, void *, dst, u32, size,
 	if (unlikely(!size))
 		return 0;
 
-	ret = access_process_vm(tsk, (unsigned long)user_ptr, dst, size, 0);
-	if (ret == size)
-		return 0;
+	mm = get_task_mm(tsk);
+	if (!mm) {
+		memset(dst, 0, size);
+		return -EFAULT;
+	}
 
-	memset(dst, 0, size);
-	/* Return -EFAULT for partial read */
-	return ret < 0 ? ret : -EFAULT;
+	ret = __bpf_copy_from_user_mm(dst, size, user_ptr, mm);
+	mmput(mm);
+
+	return ret;
 }
 
 const struct bpf_func_proto bpf_copy_from_user_task_proto = {
@@ -3659,6 +3697,68 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
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
+	if (unlikely(flags))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+	return __bpf_copy_from_user_mm(dst, dst__sz, unsafe_ptr__ign, mm);
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
+	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
+		return -EINVAL;
+
+	if (unlikely(dst__sz == 0))
+		return 0;
+
+	return __bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
+					   mm, flags);
+}
+
 /**
  * bpf_copy_from_user_task_str() - Copy a string from an task's address space
  * @dst:             Destination address, in kernel space.  This buffer must be
@@ -3682,6 +3782,7 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 					    const void __user *unsafe_ptr__ign,
 					    struct task_struct *tsk, u64 flags)
 {
+	struct mm_struct *mm;
 	int ret;
 
 	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
@@ -3690,17 +3791,20 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 	if (unlikely(dst__sz == 0))
 		return 0;
 
-	ret = copy_remote_vm_str(tsk, (unsigned long)unsafe_ptr__ign, dst, dst__sz, 0);
-	if (ret < 0) {
+	mm = get_task_mm(tsk);
+	if (!mm) {
 		if (flags & BPF_F_PAD_ZEROS)
 			memset(dst, 0, dst__sz);
-		return ret;
+		else
+			*(char *)dst = '\0';
+		return -EFAULT;
 	}
 
-	if (flags & BPF_F_PAD_ZEROS)
-		memset(dst + ret, 0, dst__sz - ret);
+	ret = __bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
+					  mm, flags);
+	mmput(mm);
 
-	return ret + 1;
+	return ret;
 }
 
 /* Keep unsigned long in prototype so that kfunc is usable when emitted to
@@ -4925,6 +5029,8 @@ BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
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


