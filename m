Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F7AC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7576B00A4; Tue,  8 Sep 2026 09:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58576B00A5; Tue,  8 Sep 2026 09:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945F86B00A6; Tue,  8 Sep 2026 09:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 654CE6B00A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E4E6C406B8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:45 +0000 (UTC)
X-FDA: 85190738010.29.72376A6
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0C77F160007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XxbgAJ8H;
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8xSsTNyIRZy5PEX3RScePveTfXXWy3/wJHDxgtQYEvA=;
	b=H6orb+I9IztLVA/D9LBNOCa2mSS9/DTtvWPj2M2MqdI0Qgx27BmOByw7c1CJnBlIhUXdy/
	z+EA24tJHa5iQRRhD87lJ+fzR5X4Q74cNtviIuWXnlndFhGVQG43OHuA9RJCZ0WNRdZUpa
	HlAF17u+TxCEeIaP2PXsTNzC3kn2eN8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=XxbgAJ8H;
	spf=pass (imf08.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875624;
	b=tHGe1q8Rv0/OFI04K11f6kAglc+UiEri4eHWwSSlJ/Ll9SnCq2dUn88YpqA7GOa+ZmHijo
	4v6nNltetM5nPw+7GHtkp0yOeaTEewzE9Zncf1FtrK8MgpWnmYIsqQzBhQGWJ8Y32ZKzhd
	d0jjMHu/wrfsb0euIjimSN3hPkAgz/Y=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49b965570d7so53391435e9.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788875623; x=1789480423; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8xSsTNyIRZy5PEX3RScePveTfXXWy3/wJHDxgtQYEvA=;
        b=XxbgAJ8HpKGt+gZFFja0nWTrAwjVBRpM6RxnvcjO2XTM2WqRA4/pVXpjLqp35Th240
         bRDsW7YAhXdNkGM0LsKVymcNbZGbDKD5aKPXr+kgayQkB9uWwy6RSbZYAAqVY+HhFLaC
         0ZqOeA/ZwJeykBiJ9P0lQyARjZaKCZ8PYMzl7pM37qAW3yL5+R0EI08Rtz4ZDznnzbmz
         TfD09NOxYfrffDP6BoOKxEWTJUszqED0o03MraUX0e4R2Cx4I++AzEBH98N3fIb2oTpW
         qaT3cr5qkSj/zodmLmPVCdzQfSq3HP0UdTUE1S7PL/stnOssFYsN5ncP+VCo6L/ks7xB
         mLRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875623; x=1789480423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8xSsTNyIRZy5PEX3RScePveTfXXWy3/wJHDxgtQYEvA=;
        b=pgDYhCoezwXFLMrnFE7Vf3RqmQWtpUOOkrMo/e6PxGF0uGFnS8tIR0bO7nrc6AX6E7
         s6j3v+h0iL6pHqB2UQIr/LDlC8ZapgoXO7bYd8Bh/PA7+mGTNqDwz+79URye0qmwEr4T
         BKmIzsht3Jjh7PGYnYBJ1bjWkv+wvaxfv+47bFaHGkP0Yz9Lj5nA5g2TdjZrNaHn5Vuo
         vZdHA/PhAiMkyomSNpIojzHFGCEph1UJ6osJVShykxtGx1qKPRGOV/RmX3+bEhRjToDK
         TUEBvUZyVp27UkchRdsXoWXIpIPP+clyChMRwzCOQZEPhqwR666310rnmsUz4Br57+TN
         pFGQ==
X-Forwarded-Encrypted: i=1; AKwUvBxSJ9bPNsEtoXOzdl/YUU1dB6MS3t0Kc80u+JRJlIK7Q7LvLDS51rS5A7g8bIs+myIIY14VLInT/Q==@kvack.org
X-Gm-Message-State: AFuF++lZsMh9gQKxQDVz613u/qn4plnH9M7osRZEPJmaEE32o8b+9uzC
	BU1g0sVLnXxeQUqQLoNUkAw5li6arhzBZYW9FgiAU1IR8+QKBpD3epxb
X-Gm-Gg: AYBFou0VLdh5j9jTKr9sB4VUBvSXvfAhR+tZXTZLZcnWB/fKno/xiw4d5r+/obC9Zvt
	UmFJj257HwybJjHlVAv7i1+XkrbkwbJkWdqp2EEHZgDTlQyuPFg64HjNWNaPEpx6QgeuIL1Asxg
	qIenwnWwzKXpcewZ6N1vKT2eLU6UQlAzInJidsBh4oGZg8fgSc+s+VhJ4IqY1b3KFe724JrD9y4
	elwOSMVEe0qHivGlYARZ8Mon5R/KOj/LZjmEEcDzmfX+7vVqNkrtIYrDN8aq72Xl/7fA95GWseu
	DO3uSE//bvVspC0GB+ogH5rgNj60nq6D1Mm1RoCvOp7MCUlq6mZwb4E5ZCJnnMqlMzj3eJAhonz
	xA/pPiPY/V8nyWMJaeipSro1i69Fvj7H6W/9G8bDPnEAqW1xCq6mL/StvlyOj6JmE3OfeW6X7ft
	fJCl5C0ck8jpDTBQ52bx7qsXXT4e12NMM0os1iPdvVdHSbx5ZqRTaJ0VuA/G1K7d0qIzK9SU/1X
	oM=
X-Received: by 2002:a05:600c:a04:b0:499:db27:7b1 with SMTP id 5b1f17b1804b1-49cf82621acmr307894995e9.15.1788875622435;
        Tue, 08 Sep 2026 06:53:42 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5533ffbsm377235005e9.3.2026.09.08.06.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:42 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 3/5] bpf: Add user memory access kfuncs for mm_struct
Date: Tue,  8 Sep 2026 16:53:00 +0300
Message-ID: <20260908135302.74963-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
References: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h3d7rkx7igf88a34wpb3xczq61kzicuz
X-Rspamd-Queue-Id: 0C77F160007
X-Rspamd-Server: rspam07
X-HE-Tag: 1788875623-99742
X-HE-Meta: U2FsdGVkX19/w0KO/KwDNDYrGhPZlZTIvbv5M/Vu8WeMo3cXuCTEu0/qlME13RhDa6xaNeUUDrx5G5nld1u7CERAMuAxeGs4up5o7zsPm4MElG8zP+vXrwq9jLOjyvTHx664rmFTyGgueyXjEw3Xz3Hb3pXWP9twotzyHrBnbSCb3vph7cFqgRfRJGwcYp9iQ6Wfy06hhmcFAZvro86r5fjp79RDxqxsZ8bRM7Cfn56LUtMOtTgJpsPEf4Qdj3rTQBBQ0zJ0WyZIprgMcFYNHFYU8m6A6bN3uxPvaT9TlSFGAjgTu4UGRWhggX6JMUCz1Q3wscgEbamC56FkGqPGESeYjGsD9W8HVWfoO3DINULetsuk8pwLm/rMnjeW2aY6dKMUg76vV+bosnuYTJQKbps2DyBce+i3nGcQbqV/nSQrUMe5ynoq/avcxnMivzrwhwDmhne1vlX6dzWmbjndFsjAypizOUWQ/hGvKnR+frMRpkMG3HHc8HRLokWbhR5u/VLx9AerDQvIEdYLv5/YoXiNmUgGuurPmtm8VzzITRdtAGhvBrWvZnfK22YiP8C7rKOhs/uIeHI4x28clyleQcuBIBqoCB20ShnkpjokArxcZdEcaTi+QrkWhd/q1GiqyZbzWZReB8Y2sgWmVdYxSKjK5rPZZmGQp9nFAjauzloVr7BjyZ9YuyThFZgyTaDwNL1PhcsBMPLrMPxA4f4tP9DGlCWjBEj4H/Qp7OXUFXkRu3pi7yvHXHFz2JmSWa8fKeZ0uuLqUzJRRG6/wdSZuw8xoUztZk7Wto0wKfLzf1qYZEXDFLzp2YozGskjU0vXk1djjdfwCVEwr2A49JoPs2DY2w9QJ0e1YQacEkId1IZgpRD0+eYivDIEPvnTgWkoF4bRLGPvb51IKx+FWxwBMxEfVAfXc7FE/Ey5xKizQt6ACkeo0ZOiciJX6I0KJQIlx2ZCgroT1IWJm9ethQS
 eZD+lWEK
 xCJDLsf54NRxvQuaiu9w4MIJfWyloCkLWEzEZOpyJQvGnQU0fCwTHusA5RrtQDjBCiKXomrA0R+KLkJHuaMLGEFfyadErk5qSt5eMeRBPJlCbsLA9b7wBN0M5bUO5AYLRqKvqYTmKyJf0vSwntrOx5b2vitep5YjstB7mKvG+0tLWroRdFGjXVCk0wRjoQ35alfHEtQdx17f2LfeSNpy+NKjYOO6Bn1nBLr/iishvvu9HnMYZqfe2nZvbc41/1njJL3Dbdmjv8w1oudtHaDwWegcbYPzU/69eahJA9c+X7gvhyihNlOJWr7wwcw/RUSXjVq7hDWkfrYkZH5Bk8/DdAsYoez2L11rmsGOIrYO6eHlZcjICIcXsssGwiHJ03hVAAT5W1jwVjNhU4WqhoHr+BiCngKuEE0/DQQ3QDrDjicYli7/Y5H3QOomvLrV48Ors2R1ZbcU8+zhhxUqqp/6klCtegSWLCJ7OSEPBRRA8I5b/PM+c2q7an0MylCH0+3lMJysviv6z5mrp7J4EcLUP44ApRwqkChBdKGD+
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
---
 kernel/bpf/helpers.c | 130 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 118 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index b3cc5c8fc875..3338bebdd86e 100644
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
@@ -3658,6 +3696,68 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
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
@@ -3681,6 +3781,7 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 					    const void __user *unsafe_ptr__ign,
 					    struct task_struct *tsk, u64 flags)
 {
+	struct mm_struct *mm;
 	int ret;
 
 	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
@@ -3689,17 +3790,20 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
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
@@ -4924,6 +5028,8 @@ BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
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


