Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 691B9C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:03:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4949E6B0095; Tue, 15 Sep 2026 04:03:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447A16B0096; Tue, 15 Sep 2026 04:03:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E8426B0098; Tue, 15 Sep 2026 04:03:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 047FC6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:03:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF2B2140370
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:37 +0000 (UTC)
X-FDA: 85215257274.20.6089636
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1095818000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:03:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qDAGD6UF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789459416;
	b=jGdEe5FA6dA7kzAfYFe+2tOvXoVitKEVEoRs4F7GMbKE5Dlg+QOJ43QyQ/kdInObfefx2A
	1qkU0n/5vmTTQWyNXhKYgBP5l06KSaTjysc0RDJfeK79u3Ip58zwHrebFijHPIM+XcJzvr
	PDHBLMGOBYAje13Q/HsTgvUBeVxMiIQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qDAGD6UF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789459416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByCPXnnC7KpXzoaLnGFreo/33oFOqB5OMw022838T44=;
	b=tX/3nFKLaPSPJStnBSA2KcGXpyyaQqN9fxZW+Mp3DJ2clxg0/+/kpH07YUAloYoEp9hxCs
	2Wbxv91w7ff8wKKlGyRObGAO2nmkTzCafy84vO67TKbD/PJPZWRd6XutqBfYZ5UOWe7umA
	LUg8MbUAVXsJEKL0L9jogi2Vb9G6gIE=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f89so1467927f8f.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789459415; x=1790064215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ByCPXnnC7KpXzoaLnGFreo/33oFOqB5OMw022838T44=;
        b=qDAGD6UFoHhqEGLL/w61FdvGOYtBpa5/03umEEm8GYL7NZ3WtEUTTLgXwJUP3EhFXP
         GVFWzUZaMUZtTa7g9ARzkGm48ZflUebN0W3XqNCsvJUdgnzeV19KiCCEqFJqINuBchMu
         gBVD0+4sQ8Wh9IcbP6oIAlIgaKUtn4psJDhk0JjjLhINzrf/lH/J8EmDYD0qiGmk/JpI
         vAi/rky+7k/92YuZzIESukdJnED61BMuN2UhhzXtXaOILCTwf0Ct/QX3hAxIiFSJvNlJ
         4efworXDrDhrg03PFylFXoKR3cob7VxtJ7aVfA2V3uR0Z4ciwkO7V0clHzblcb3nGzba
         WtiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789459415; x=1790064215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ByCPXnnC7KpXzoaLnGFreo/33oFOqB5OMw022838T44=;
        b=h3B8elsxesYnmLntKAhNojmrBbUhaeLRBZW8JhhEJm4kgIoVzCDOsxpefhhSvURA5h
         +8FXgG1wGvk5usJJbc44zSbQEId3w/UXkOdVag1+eyBl8WgvVEdkuk4P4tdHQp4HASzN
         uV71S8LbLtT6UPci0hrXFCXCuqlLpNoTAeCMrScdcwiZDumD/oMrxiRmbyQOjMkbfgYL
         FtuNuq9ygmTl4cMAZaFA6QlkuGgMMyLgsYweQq/MvbU25Exq+pTrai96baocucrIqeSI
         dAwNgV0vahmW5dzv90/J39/gDwiskOLhspFxYcmkpYD/r/wC0DkMnYkK1PaDlLOv8SRk
         OKdw==
X-Forwarded-Encrypted: i=1; AKwUvByQC6kKL5HLMPDC0Z4zp+fLgREew8lRA8oaLFkxZs6ntXVcHkMQ1h3QPKyoyN6pmzn1emyGY+Gl1w==@kvack.org
X-Gm-Message-State: AFuF++kGhbzqRnQ4XpQtxL5KTBCYxKwqjBncTqTONK3oQg1VfWMS6+i/
	wqLdlhO3khZNKbzXcP1f6Q1fVfKfpz3w5795IQw6iwoiisdSHaapuBGk
X-Gm-Gg: AYBFou2rZkRbmHIyVmQlNLjROVa8z0xO5yFGt0kinYDbyEydn/FqVEXaA1/EiyeW2R4
	KMSFPGgcHudd5Y0Sbmj8O4vYax0GFZOB8WhzvAxR5L92FiTXsa0gbt7ErmaJgWoxzAljkZTbbHl
	3J5FaCLuXXKFxraZCdbXsC/cuONHaoHxYerw+7wnD7v5lESkYjafbmSN0g7dQgBeV/jaMc+6VI4
	hyDS16/ovGxFqnz0+mPqsj7l8qdeqYm3hd9u/202/rVCgKkeGV9mgX7lERCn7gHuqTY4cptoec+
	SRoXpOqJdlr3NRnVSFdlQAROXr9xwi/tbdPPy2FL170Li5D5CVlK2PNabjk8gToBir5Lg1B6qNo
	T588RzD2Uml+Lz9HvlfIp4ggaSfWUGFGaIoEoxDOdNKylOJnknM7U6unPNV9XnrqTLkNnPy86IX
	SjCMXAUo/gDnnNXueRpCbeeCw+BcNm/Pfag3TC3K9UwJc5ZxSef1Cfimb98FtW8ZKO0A1dIn0qh
	5Njr2QOtCbOqas=
X-Received: by 2002:a05:6000:178d:b0:487:77c:f6c4 with SMTP id ffacd0b85a97d-487077cf6f9mr1897099f8f.35.1789459414412;
        Tue, 15 Sep 2026 01:03:34 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb35c071sm33764675f8f.33.2026.09.15.01.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:03:33 -0700 (PDT)
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
Subject: [PATCH bpf-next v7 3/5] bpf: Add user memory access kfuncs for mm_struct
Date: Tue, 15 Sep 2026 11:02:53 +0300
Message-ID: <20260915080255.48929-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
References: <20260915080255.48929-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1095818000C
X-Stat-Signature: mfywtq6tm53z63mhcodkeyzzabyp1e5n
X-HE-Tag: 1789459415-507942
X-HE-Meta: U2FsdGVkX1/NKHc3Mwrzaxgjm3L7sw/MUv7968iCQvlRUWRG8Hl4smn+obPOFM+azzeb0lK2K5xiIzR04AuhMbPYObh8kEIuluzPKt3HBl9N5jZ11mrZLkKdCmCS9+7rSQoxGEBEFsGO6nC/yk5+GhUSmSxjffFqzIdmT+Z9X4/LKRflC72Zv7Uekf/gJxONUb/qISc6HPZ5X2A4pY2Z7oGp9WZ+LCHzVO+eOQgU85G//5DLvnbzzxolPVR1PrRCsm9wOsajEtptSnjHCOG+D4AJnDWGiH+f5b63OjbUHR3/dvzdbHM60P+KHMUCV+bPo4yZ/V9NSTzCXUdkjMcpgyLdG/mnkaGO0lfA7WceUtMPaoEiaEKu0NXqvDdkUX5wH1TTjddXjWJK20DziPKjcpvVkr+f8HAASn5HHGUHnni6wph6xM5EKG51BiU8IJE2X3xEkO/WOps2FurHQ7RLizCZ6Fdccj+AvYEumlXJrmhTYtCWa6jk4GsTbUP0Ene9CRuWTJxF0NMKbjmDcBOxV3rowyFtXcdqZVIBfp+VTJrxzqRow3OvH7LKIIXqa5B5kFJHVbo7SeMXe0AS8eZEMz/NE7UyyuZZSe/34SjEpwSQTqgchvp3NgV9cihmoSOnuwVg1FimdD+l1yoS9MEGDVu51VoZNNSeFO6zx6opVucBkwA73EXEKOuzHdi7p2q8JgNs7BpFXDlSLVKa7JRSqD/syXczZGjz+uMxw9BF8IhQ9zkF1UUp8416DII0nzQT/lVevPGctIYLjBTCCuOaLSDE1VlsYx9enHu39Y5Ia4qywsAu6BAgp7kqA086fojaX9NsfmPSYTGASEUbiHD8ihvNEiYtn5UUuNRPemPZhO/tIH0BJRbdt/p/SEkcAqRit0tSvQp9uvOmhPYxDbXOBkzY47dRSGASPy1d+osDQYWMXTZaiJvZT3D0axxUu91VJcRoFqxZ8z/1M8j0RRh
 i1qJj8B3
 DvDPp0OfZ21LvH48725boC1GaWErJAP3nFqbf8/lhj4E+wK/W+0lEDEhj9MtZdpwSKCbKCKwgRZ7cRdfb5J2bWzjHAO+FIaeK/LTXGE8bDAuIPp3vAxgqrYEc0rge7zW1UcQmFQvmp60wk7QYMPrXwzM0ZRdddjv6mCyP3VqigLIxIR5YqD5lQcOhcFgEl7Tf9CwG4vc+7pFhKajsbgCo1/jo2AKGpDqzz9TytEdwj/CWL2ocm9cw9MfTBNR86q0VrNbXJXzhaYe1NS9VFQDMXWTU5I1zDujtTcmB/SYZ0jvDBNXYXzLy++6/JPS9jxWWAmWLjx6h7D5MQ5KOkTZRy21bggWpHeVgtyzH0n0xuQ8VDRHM0ec0kAuxGCL0qeWTXTGMhOpGCjUHS8oaMh+fi/jGw9QmMzVOigtQOxBTUZFE4vJpL6dWjagvCYjp2I4I9uI+COtCUscULS9KW3doe0AsyYeigFSNxVKEsMUcazIyTIUIlnfnW+B2KRXRhunyRrFF+uXysJjEKjna4oXky6be97Sb4BPoZ7Y4
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


