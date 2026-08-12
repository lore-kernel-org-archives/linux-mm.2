Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D97DC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25D756B00EF; Wed, 12 Aug 2026 07:12:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E72A6B00F1; Wed, 12 Aug 2026 07:12:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088546B00F2; Wed, 12 Aug 2026 07:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C80B56B00EF
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:12:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D4F9140271
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:18 +0000 (UTC)
X-FDA: 85092353556.04.8679686
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 73984C0004
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pLz/MWmB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZYIXmkyCBXJa09C5v4nt5nRF4vm0/NWKF3uSvZo5n4=;
	b=3axr6wf/GG0JzZoacNaHp2QNfv53aH50uj7WMzKF9ORWvLMJX4iNaGxKQr3J7PZhV879xG
	vvooNt8cZT9fT3Os3u1nqb4Ux1VbGNS/uW0ol3Eept7O4AXK8coAAw3czgqw+USxJIuZ71
	PaOtfiKSgLGYw7DndLGlOquCAmzoGA0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pLz/MWmB";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533136;
	b=4j6UP8PL25qkiLw4nIe18uAxmmGd0B7AFDWJL7Z3udXOdYQtZJfAuWw3XdENcfqQBSLZcT
	2lUIgjzz1PxQ/c0k0nRGH9ylhGK1ooG5BCLecV3qN34c16ItWFYANeLcuKJpcfe4nZmesW
	/bzIc37rAjwgxU0U9ifWAPNQb5SbpAM=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4813ea321cdso1377875f8f.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 04:12:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786533135; x=1787137935; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9ZYIXmkyCBXJa09C5v4nt5nRF4vm0/NWKF3uSvZo5n4=;
        b=pLz/MWmBn3EebmycZJ4tpYsvXh0twS1tLmOyA/5wwXid3oXOh0mzjrlPkwKcUEhCeT
         29SS0jJQI6aYbRKP2p6+SMlhG0wGY31X31BcC8+U+MuVekazwsdn+SJCdf6X07hFnJuf
         C3NH5CeUIEVR7T9uSNa0BLfbpUN1oPBZoWSIPi5fVpLFWl4nJDcaRsaefg2GVxL3G2Xb
         9QAyXt83ScBlLqUkPFpU84yi2zhKJ6h/Gozx/Fv2Qc8l4fX9alIbp4TFIPf4Ddxk1Rkn
         8a6UZbH9FvTnuAyBRTGf7YK2uoUhgUlNiLbEuarN0b9aga00onFX3nQtwEyrd0giQHB9
         9HRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786533135; x=1787137935;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9ZYIXmkyCBXJa09C5v4nt5nRF4vm0/NWKF3uSvZo5n4=;
        b=YlIf5AViLKlJPRoSexrPdGV2Jct50cZSi2pIH8YM71cuYd6/On6YT6YDDlPMp0gkjh
         /rPiqvS2ON6/5p52NdbUkeyTy9LrfCnWAP9PpGXCXBkTlIaimxF+7eREU+uMr1nxn62a
         Mlwd/mvgTS0Ojo4K/sj6fxBZRnoG1RYoKodB3dvLuWeTljImurnWtgRUUpYRF6uzesxA
         Wml5j0F6qL36GnV0+MRNpFTVntXUWZZYTY3GoPKwtB7chVzMs1z15OghNI3iuCODcaBa
         FyQ0u4mHnHxOsWmCQaDYcTKjJg98wwZtQBsziyNnHiOW9Ei393zfr4ECi5UiuOU62jQr
         /GLQ==
X-Forwarded-Encrypted: i=1; AHgh+RrDJDnDwrCstEoq8TzLbAIyhh9faiC42045ZhCqTQmh2zESo+LjXekMmiq6Qn1leB8DUr0tj1r5Wg==@kvack.org
X-Gm-Message-State: AOJu0Yy9AALs30Ebl/x+YhJDvBCD2qAtUGvo8MjEh21MyHCRFyNZBSHq
	sUzdB8x22NtOucso6Dz9VXt/Rjrst74lYuG22FQPon09z85YHCUuW6lt
X-Gm-Gg: AR+sD139l8FcmqfYXmGcCEyjBTG/YcBqLWbLv4UOk+p+NxOcW+6J/Ftttv64TBOA591
	y0faF3K1Y1tcVN7uwV0+95eK02JRF99Tq5a2z55huTN049VwY/DHAbxf0/haQsMGP64y+i/BkwX
	kBXWmSr1THvcDDs+MsGO5b8c74MnfCGOUlVfF27ZKlBKQZrx3p2PoX40KML4w5LRTlQzJL+HePh
	mZZAs8JKea5Iew8c1GuDxeh2QqTAjLCp0L/9xpXNiIaTCo3c4CyI9bfo2+AGBEQ+8rJqR1j5rWJ
	5HBAgjPkes5EHx16peiyisRU3jOuJia/yuXpvQihNLES3qYV7iJFaijgPkOBMNq3J70wwUeQKnz
	5OGBMT65E9+vUzSPAmdpYWOVVQiQ0Ef43zikh9g2g3zKc60yffLmdA1yJhTtj60pOQ5fz79VlEI
	O8sFrymOfY7Ie4Alk2kaiXpNO3yQ6N4pabMGNRKxsbfPa4Ujliig7rki99XW5gRc7QcBsmJUcT7
	5lG
X-Received: by 2002:a05:600c:1d0a:b0:499:59fd:dbfc with SMTP id 5b1f17b1804b1-4997c379313mr43300375e9.1.1786533134636;
        Wed, 12 Aug 2026 04:12:14 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997c9417bcsm54830855e9.4.2026.08.12.04.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 04:12:14 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for linux_binprm
Date: Wed, 12 Aug 2026 14:11:39 +0300
Message-ID: <20260812111140.7762-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
References: <20260812111140.7762-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 73984C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: j4harqhbadd7f1k1cr17hwdr5fpjb4w9
X-HE-Tag: 1786533136-780531
X-HE-Meta: U2FsdGVkX1/6ILBIa7VCHpNzxf1VxTkuWuhb9sf+LMJwOYn6EEBMM8TCRu/yp7Ic8IuwKggvRMio25uiUmfC0Vz7xowWVxl5nlNm1VuDRbJpRIUYO9kqfSvygj/Gbs90sC7tQKPibVn6/IdgXniUXdnZoab/I1fD68vNKNOn3vpDPRr7Gv0yWKXcJaIcev55mzZ5OBvhqGR3/CfCCRkySw0W9TCNuc/XJVVWiJrZT6k82FWx67UTsKKli1b52cXlb7jpBRpXnGs+HuROeUSpoRizOIcYsRQ3LqE1WFCEK4gJA93Om9Mn9UUrHrS1j6By+njFBWJO94Cqqtsj8IbFi/10r15B84NtuQPnTpsyMonSHd20HW0h5XPRy9RlFqU/GDaQ02TTs1v6LqiYsg/KpjKdbqfgzNz6YnQf/Ff5PZKWoKpX/vPFo+uN2Y1NCOnmN0GpPYD/OXSdXpV2TZP87BCtMVqGshxkCmmOXGrEoGxzY+HYinB6iNvxwISnBQS6cHqv766D5b3+3s4mLkdqM0t3klR3LetZ+E+GpxzuoneTKrmowEMd46BFqgmOxC8qLs2wJZBzMepw1ToLUohRwbagy4H4Kei51ex6U1eZ/YambCZBtlOo050b8fSubz3Lm6YSst+LSYYcvX52DqII6VbqIQnYEJAA1mu7E56Jk/ET3GqBknXmIsm9s67ADeQKVVCDGtUFxIT7qslWXqVhBSSiOVCPoF2jSq2ZWIIKOQ/2nkDgWXQCPSPwWZTGhU85myst3oApedzWGMKp8UCfzRKMPFKdcfYzECIrSj3qsZo4YwsTcHrnKk4O48w15hkYqmV0d8U8TjDt23xf3yLk5ndlJGJ4/6CNTCXjBOF9J5kGGhtZXDmh7vIolguUemOMvtXPkL5tMygxOKa0NffI7a3jrAd0R9yjOinb5JIuFnrkKWMvtUjDMxsWFPM17cBnfmvmNmpUzGFee5JSRHL
 Gwz1mtgP
 EtmFzWW/97fhcREIznq/TratO8BkhfngICSFRDAHpn65eH1/fiVqlHbOHzYjb9Y0wK/IO1NxTkegZcbgwL2nQQuTomiCz3xUBe3VxXdp8oEcczMy6qoc01XB8Goq6tMJ1o52ZOq+6DWuUGqrYKmYSBlvr1xIoWzQ6R7LvEf/vfKZQ1NiAfobPj3LL8g/WPFxVfN1WQUMz1/G9Y7BSCdXJvaqVCy5Gs0SziGNJsmshjZtSTTyq55690x4WOuPxqQBmPmus0cm4hwgwR72xc9TU860z21hEo8nJfyCA3WMdFgTYrgwIUqo6Lq1Pf73H/sHEoWgDjFUIwvj5ALaRhujXBZaWYZU4Iv8GUnntzYNtYa7SYL63PxBR1RIp/deutzc7MPRV+XNcNhkG4X562eD9ypyjd7djr3W7+PhWYfV341rDL4J2g14pfuNwKJfPFi6YrfucnX67N4ss797g+A2phWpwhtgvmfmV3Xo2urh0SV9ctWhShdGjbf95a/EDhKP/sAItTQeIHrexHmEvu95j1k5gviJjWAko4mlX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When security_bprm_check runs, the arg and env strings for the exec have
been copied into bprm->mm. The new address space has not been associated
yet with a task_struct until exec_mmap(), so existing BPF user memory
helpers can only read from the calling task's old address space.

This patch adds bpf_copy_from_user_bprm() and
bpf_copy_from_user_bprm_str() kfuncs. Both use the mm_struct provided by
struct linux_binprm.

Register these kfuncs only when CONFIG_MMU is enabled. On NOMMU systems,
exec arguments are staged in bprm->page[] rather than mapped in bprm->mm,
so these accessors cannot read them.

bpf_copy_from_user_bprm() has similar semantics as
bpf_copy_from_user_task(). bpf_copy_from_user_bprm_str() copies one
NUL-terminated string and returns its size including the NUL terminator.
It accepts BPF_F_PAD_ZEROS to clear unused destination bytes on success.

This patch registers both kfuncs with KF_SLEEPABLE because accessing the
remote address space can fault. This allows BPF LSM programs attached to
security_bprm_check to read arguments beginning at bprm->p and reject an
exec based on its command-line arguments.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 fs/bpf_fs_kfuncs.c | 112 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 112 insertions(+)

diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index f1863a891db6..74befdadad68 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2024 Google LLC. */
 
+#include <linux/binfmts.h>
 #include <linux/bpf.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf.h>
@@ -379,6 +380,112 @@ __bpf_kfunc struct inode *bpf_real_data_inode(struct file *file)
 	return d_real_inode(file_dentry(file));
 }
 
+/**
+ * bpf_copy_from_user_bprm - Copy data from a binary parameter address space
+ * @dst:             Destination address, in kernel space
+ * @dst__sz:         Number of bytes to copy
+ * @unsafe_ptr__ign: Source address in the binary parameter address space
+ * @bprm:            Binary parameters whose address space will be used
+ * @flags:           Reserved for future use; must be zero
+ *
+ * Copies data from the nascent address space associated with @bprm. This is
+ * useful for reading the argument and environment strings before the new
+ * address space is installed by exec_mmap(). For example, at the
+ * bprm_check_security LSM hook, @bprm->p points at the first argument string.
+ *
+ * The destination is zeroed if the requested number of bytes cannot be copied
+ * in full.
+ *
+ * Return: 0 on success, -EINVAL if @flags is non-zero, or -EFAULT if the copy
+ * fails or is partial.
+ */
+__bpf_kfunc int bpf_copy_from_user_bprm(void *dst, u32 dst__sz,
+					const void __user *unsafe_ptr__ign,
+					const struct linux_binprm *bprm, u64 flags)
+{
+	struct mm_struct *mm;
+	int ret;
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+	mm = bprm->mm;
+	if (!mm) {
+		memset(dst, 0, dst__sz);
+		return -EFAULT;
+	}
+
+	ret = access_remote_vm(mm, (unsigned long)unsafe_ptr__ign,
+			       dst, dst__sz, 0);
+	if (ret != dst__sz) {
+		memset(dst, 0, dst__sz);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
+/**
+ * bpf_copy_from_user_bprm_str - Copy a string from binary parameter memory
+ * @dst:             Destination address, in kernel space. This buffer must be
+ *                   at least @dst__sz bytes long
+ * @dst__sz:         Maximum number of bytes to copy, including the trailing NUL
+ * @unsafe_ptr__ign: Source address in the binary parameter address space
+ * @bprm:            Binary parameters whose address space will be used
+ * @flags:           The only supported flag is BPF_F_PAD_ZEROS
+ *
+ * Copies a NUL-terminated string from the nascent address space associated
+ * with @bprm. If the string is too long, @dst is still NUL-terminated unless
+ * @dst__sz is zero.
+ *
+ * If BPF_F_PAD_ZEROS is set, the unused portion of @dst is cleared on success
+ * and all of @dst is cleared on failure.
+ *
+ * Return: The number of copied bytes including the NUL terminator on success,
+ * or a negative error code on failure.
+ */
+__bpf_kfunc int bpf_copy_from_user_bprm_str(void *dst, u32 dst__sz,
+					    const void __user *unsafe_ptr__ign,
+					    const struct linux_binprm *bprm,
+					    u64 flags)
+{
+	struct mm_struct *mm;
+	int ret;
+
+	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+	mm = bprm->mm;
+	if (!mm) {
+		if (flags & BPF_F_PAD_ZEROS)
+			memset(dst, 0, dst__sz);
+		else
+			*(char *)dst = '\0';
+
+		return -EFAULT;
+	}
+
+	ret = copy_remote_mm_str(mm, (unsigned long)unsafe_ptr__ign,
+				 dst, dst__sz, 0);
+	if (ret < 0) {
+		if (flags & BPF_F_PAD_ZEROS)
+			memset(dst, 0, dst__sz);
+
+		return ret;
+	}
+
+	if (flags & BPF_F_PAD_ZEROS)
+		memset(dst + ret, 0, dst__sz - ret);
+
+	return ret + 1;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_fs_kfunc_set_ids)
@@ -390,6 +497,11 @@ BTF_ID_FLAGS(func, bpf_get_file_xattr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_set_dentry_xattr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_remove_dentry_xattr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_real_data_inode, KF_SLEEPABLE | KF_RET_NULL)
+#ifdef CONFIG_MMU
+/* NOMMU keeps the staged arguments in bprm->page[], not bprm->mm. */
+BTF_ID_FLAGS(func, bpf_copy_from_user_bprm, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_copy_from_user_bprm_str, KF_SLEEPABLE)
+#endif
 BTF_KFUNCS_END(bpf_fs_kfunc_set_ids)
 
 static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_id)
-- 
2.55.0


