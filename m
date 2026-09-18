Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CC6C982E3
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10306B0096; Fri, 18 Sep 2026 09:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC0616B0098; Fri, 18 Sep 2026 09:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C89856B0099; Fri, 18 Sep 2026 09:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C58D6B0096
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:18:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D1A9AA6148
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:30 +0000 (UTC)
X-FDA: 85226937180.24.49FF7A6
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0BDAB4000C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:18:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EByHD8IB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789737509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtBPLqwC7VJbXcngjda2oQbwhTixdm4j9JpsXuMGn8M=;
	b=4ZnThqyIcMsGwvy3+P/ZjQntQ8MtDZYZ90yskOlqH0rQxbx441uSoP0gQEZTsZakmfRi41
	x5Eb8seUo5A0wdxxBB9thi+WLJVcnzeGyW/knF2m6aGkP8+Bh5KbBGHinhDgwk/A2j62aW
	LupcxhA4d/VYzziOIYuYa7vAuDsNKz8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789737509;
	b=K9p1lPHQEpx49upxATj58Qr7gxbQjoNrt07Q5fCsi+AuM/IH45IW22XXKWeAz+VHF214jl
	Js77ftPM0JpzjUPtEIT78Z/e0ggIOhjhwqN/6fmmQuGukBLt3cXvVDT6pJa+wywlz+NJ4c
	P6mS/P6HAUJyoSgIWyfXuPw2eyt3Pxo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EByHD8IB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f633cd78so410931f8f.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789737508; x=1790342308; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YtBPLqwC7VJbXcngjda2oQbwhTixdm4j9JpsXuMGn8M=;
        b=EByHD8IB1OwXbe1Sz4YcBPxLjFFJgnlLbwEWzIcDkKtARwDyFToWqQFhxC2ICAwJ3g
         FgLdbC186CDiomqFsPiuiwx/9Kxn1WOrpxRWmUrmwPi9XlovO5R2Pcg6/rPDdFWzq/5N
         QddhKD9zyyUWKtVqC44mDHoNzdzuMHXpAL5wovlwW0kLt9j3281uiVtBBG/+AEy+XXj4
         ULT5bN+b9aZX/sxnmoC1HX2abYw0pz4y3sAUO8kq87JRnOh3aG1XDvgUBDD3fLAfWNij
         Uy70smEH/Ifxd5jxwUuttwnV+32SCLt808CjcVr0QNcXINijGX10WY1F4O26birUHW5N
         FQZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789737508; x=1790342308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YtBPLqwC7VJbXcngjda2oQbwhTixdm4j9JpsXuMGn8M=;
        b=FyAH2KzIui1Yu4t2DvTasOEdooZzK3hyIjQPIHyUame4Jgq2obz/GH/3F3DcLo8ukR
         lsv0Jol9J46OzUi9skIlAIoBf4vqpqSXEiHXtwI8//XlTL3iFpx2JgiwvD31DPVtC+YB
         i93mcMlNFmekUG03L8ARKGBmM/p1l15VSYZgN3xFPKhCR8GOYf03NPQ07obLAYh+jNrh
         s1xefvh8rX+75Cqoy4Afg/7dEY0r4RmYXWweAiLDu3gdY/Ac2qjQXHPzqS+L5MWGChjv
         MFCYspM+IjLXFyN6C/spVr8xj6TWUIRr0CXalEEUNMYGShHaAlU2GzFuCGKvchFG8tkP
         9iOA==
X-Forwarded-Encrypted: i=1; AKwUvBxPPNvlB0DW8+vO/iUeph8bZRGJQIpY8s6PgCH0jan9so7Hb5bRKaxu9TdcWw4UO9bkRy3HUu1pgw==@kvack.org
X-Gm-Message-State: AFuF++kMdr5nikD7DJCEzIy5Hy1TEu3A9syj8JRJU3TRoTTq9mVe0tE9
	IDCqXlkcN/2wjhfMbcnvnXdvuSgKL3f5T86DPBrYpwQnFnZdIN9EjKR9
X-Gm-Gg: AYBFou1cwBobbZzN8Co4j/CSKAdQJnLDR8VraFMGHQ+vSdiGX5PzvPJL65EgCKrQeqG
	WRR3TppAeEl5Ai3IiUFNbO62K5j7XiF/xWJK25JgvnLIL1ifwuKyb3t5NPVTM199DHdlpDshiE4
	v3k7Y7ShBXu+MCsjuR3ehMki9qL1QN5jS63Q88Qm+StTopJGabNYykPHdLsAV+keIgz35LVw9r2
	CP1yyGBuzKUThoxLbJWRxaD+uwW4+CUCWYnwlfH8FSFJLEIXnxfMmW9a7f2PFTIdHJqnWMfKM3j
	mEtk6zxvG9exwIS1NjuKFofzR/itcchMgccRtyLsFsOTPDYWqkb+qr2qRpkbh6nKSUUNWXb4k08
	X5fJEMrFzF98rqlWA1CDrqBkha0HJ7KtZtFjCcLTsnSFRG8jPpQoazdz93LqYD7TrnOhIx93Lt5
	oSiGJVSkBKgccf7Ho1hcTwDAMO+vsQqVXDGzl9I5kMLS8wPwHKFDaXol/2Rii8T1Ua2jWoMz5M/
	oyWknMDtG15Zdw=
X-Received: by 2002:a05:6000:40e1:b0:482:fd9c:3740 with SMTP id ffacd0b85a97d-4871e227ccfmr3468864f8f.22.1789737507607;
        Fri, 18 Sep 2026 06:18:27 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b4e:8500:290c:210b:1c76:5710])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4871feb5de3sm4424549f8f.1.2026.09.18.06.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 06:18:26 -0700 (PDT)
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
Subject: [PATCH bpf-next v9 3/5] bpf: Add user memory access kfuncs for mm_struct
Date: Fri, 18 Sep 2026 16:17:55 +0300
Message-ID: <20260918131757.42802-4-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
References: <20260918131757.42802-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0BDAB4000C
X-Stat-Signature: i1xf1cn8sw95xz5w3gbrd75hfabna1bi
X-HE-Tag: 1789737508-337229
X-HE-Meta: U2FsdGVkX1/MfuYcFfGvDB/KKxEv6Z/hQ/lcm3TjUaHwADriSmeq3S5vzcgjrtvfzVpvxtO74+JRHJX9CusoWVPCsfAKEzlxxfI9EtaVolHcN3xOwZ169dgYePG22pzLNz8oh/+XrvSWPMbjFA4QIDRADIWB8IivJzRbFMn2ibnR9BEW7YqjUar5ikD08U8C3oOwDsVYBAvg3CwBPHEpXFg97T8lmeuiJgMEkM7vORZtvybIZP8QIiMTsUCmxZf25X9ToxOv5Aihaybg3zrif1ZTRZ7KTnCsaVBw7XVM9NTt1OVJcyA29wm3ufib6KlXYk5Y9PPnEwQtNb6t9CQWcCsEpZsIF8eyWhqDdAZ6fkZzvpAj15HEYZjUHwAD73zvnxuBfxAqVDRbvGVkyklBgW/UQcSdzTd80iEolp1YLbCv+qbFbhlhxNLzq7tsoYwwOQNd9C5dACRkxqYFttheLEoNBezx4Z3zsT5qy9/cHXUvsbwMF8AWCNfFB4KLXqL4iYNwEXNMFSx/0X/EixNbpvsKHjuMfa1FMCao36lnpOB0BC8/RmjSHqffpg0Tu8PWFal7H57F0L7KV+HzpDIA5+GC/LRPo1cA6fL33xVOjZXdIQw3dfHg/WI0vU5vhW301SZKNpJbrSXQ/ifI6GRUz54PZgRnutH9ZTkkSHWXg8+M7xRbEdCaHTHGLL7Q2xkThJLQKQe64DqsIphnmALR0LssER3mynW6eR3NgYPy4OA20Gdz+WwtNjq+BW/lc4+ITmtFRkZ9jjyjUfwnzVnEycwGb4K18U87jlZSKPER9LqIR33ZAkcnppByQqrdD0M/rzp9liwLeO+jwE4fEAyzn3OWMWEqN2kNRxe5CvmAjHbAPO1KjsGfMd/xAOfP70wl/tVa/UCezdOzbp22ZxyxKTOAmvKkf0rx4X2p37Htg920fv2tRfb1O84tZsN8aoSvSvp8zXb2n/2MEhCpxQH
 CbrnwhYM
 f6AJ0w8GooySFJvdoXkmEnaVq4UuMmPxZKwPIVRtYKzcfBquOW3aYy07pN+tqPVp3okcLTFh+9rI0Dkuqi3yX3s+DMkm0Cz3He32iw5fHYLBOJVFyG5pFmWalWNRiBP1y8CqeiPIs3Z4ly+/Vx9iM0Hbq8hsX1nnbrN9dwNhbzjF3RE0cbvY1iNmA6yLscK404xuSlNmq6xTLieBsz5VashgOdCXb1cHcBeVz+gBvZJvFDWTaHfXpuqvZ2CUKrNYfHZVoWFr6Kz7cgIgvB9ezzY0uqtjxW96EVReG0tLJkxvBdXTm2UEipXGFPcXoloZNPZ6e7XG6xAEgrshbrpSe3eXKV94rDLsMHpngx83OIj7b4qO9qDvrL2BGcNjKMd2fypDpg3bg/Pma8lYAetKEJViUfmMbZnEffHfm/e6YE7Vyj2JdwKHBwQptPYnR7gj9g8ObYbW7xKmEAVc1nAw8GAJB19tFHmpkBs4d8j6sBB/tWAKVeXhI8nJRBE32gE4K6wChKsFoWZd4ldztwLPkKbqJ8o4D2EYuFcWvrzceaxPJjnYcO0ycV6CHpSiuE6+voP8nC9RiQ3/7+cx4FSGoD6BfFxSXs1lRkQFe
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
 kernel/bpf/helpers.c | 154 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 142 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 051b6654e57c..82402d97ce67 100644
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
@@ -3659,6 +3697,92 @@ __bpf_kfunc int bpf_copy_from_user_str(void *dst, u32 dst__sz, const void __user
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
+ * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if @mm is no
+ * longer active or the copy fails or is partial.
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
+	if (unlikely(!mmget_not_zero(mm))) {
+		memset(dst, 0, dst__sz);
+		return -EFAULT;
+	}
+
+	ret = __bpf_copy_from_user_mm(dst, dst__sz, unsafe_ptr__ign, mm);
+	mmput(mm);
+
+	return ret;
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
+ * -EINVAL if @flags is invalid, or -EFAULT if @mm is no longer active or the
+ * copy fails.
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
+	if (unlikely(!mmget_not_zero(mm))) {
+		if (flags & BPF_F_PAD_ZEROS)
+			memset(dst, 0, dst__sz);
+		else
+			*(char *)dst = '\0';
+		return -EFAULT;
+	}
+
+	ret = __bpf_copy_from_user_mm_str(dst, dst__sz, unsafe_ptr__ign,
+					  mm, flags);
+	mmput(mm);
+
+	return ret;
+}
+
 /**
  * bpf_copy_from_user_task_str() - Copy a string from an task's address space
  * @dst:             Destination address, in kernel space.  This buffer must be
@@ -3682,6 +3806,7 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
 					    const void __user *unsafe_ptr__ign,
 					    struct task_struct *tsk, u64 flags)
 {
+	struct mm_struct *mm;
 	int ret;
 
 	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
@@ -3690,17 +3815,20 @@ __bpf_kfunc int bpf_copy_from_user_task_str(void *dst, u32 dst__sz,
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
@@ -4925,6 +5053,8 @@ BTF_ID_FLAGS(func, bpf_iter_bits_new, KF_ITER_NEW)
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


