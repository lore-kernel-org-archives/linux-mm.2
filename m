Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6243DC5DF87
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 13:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F646B00A1; Thu, 20 Aug 2026 09:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6386B00A2; Thu, 20 Aug 2026 09:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10C086B00A3; Thu, 20 Aug 2026 09:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D96AB6B00A1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:18:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D9F11C0098
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:44 +0000 (UTC)
X-FDA: 85121702568.11.3D8C875
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf28.hostedemail.com (Postfix) with ESMTP id 73D83C0004
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 13:18:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WzuFTonz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787231922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QYbEtEXZu+xF5hfb2YmFgZkOm/c5VxJE4N0FZpACyEY=;
	b=Fhc/8AaVw/Te3XyARGBdI4xT6FJ4Vtv4p2JGMVNO6ilM9Q4uXykL9VdSSNEEjQnRJEtTs3
	0HJleVxMndDvMEuDBw3+jnjCDYHNA8oMcP0tqrr1mj9RZx3dc1StmzDlO4mT81cn8Tg+8U
	A2DIzXyXZzT7gK3M9OYOPfHXlzNydUo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WzuFTonz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787231922;
	b=kA0fuNMFGUzIveRl2jPb02zAugKDx5FI8e3pgaqZKeQC3mJt+UHcdccX84D/Ew9JLjUFq/
	jwNGHS5vBGvG+9W46X6Mc4hTEXg3CGb5GBW56/37mF+uG3np6nYezOf1JJIEC/A+dH4WzT
	amfvRWg2nH7JU5PP7Hd8mq9MVQxBZP0=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47f3b39f2a1so1923250f8f.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787231921; x=1787836721; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QYbEtEXZu+xF5hfb2YmFgZkOm/c5VxJE4N0FZpACyEY=;
        b=WzuFTonzsiN70lP/0q5d8bDlbtvxL/YtxJ9pTwXxHQNOjlImiwGO8UqKDe2ib9yrC/
         A8m+gxVrDbFOZBtGQv+Hce8u0y+6KJRBRuAFTkLhfDsFIfjMfeF+dGIG7I8n+XAIJ1E4
         fvdVqJBz4GywtD1e6XZqRHh7VWersL/4G+YOoMqe2dpXy59tOCZhQYsp6so0qpE/FKt/
         sXjeGDSH8c90pg49jJ0n6+X218mUFFOKkbWmqMGuWY/Wbsi1KtQ6JiT5BTt3FfFrhBfL
         OmxLZogxq5U7Zngw79CjfIT8FdVDBO5gHouE03B3psb29S1QQawahcZqxHNfxlOl6TMI
         TCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787231921; x=1787836721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QYbEtEXZu+xF5hfb2YmFgZkOm/c5VxJE4N0FZpACyEY=;
        b=EF4aMxJblO/3BoxtTyvZ0MGck31QAybj6ulXZMd8Et3qoBdjp7/rrnZuGIlRM4WmjO
         FU464EgxiFfJvd4ME3k7CaSSs7QBy3+I06E0kq6ebd8s7qG3ruQzeIg8hEsaNYPaGfe6
         U3878NC13525FFVBYa/eLSwOEKcu9XMoNR+Cu+Y2BjK/f8Ct62LPVe6TeEzTSq8WSo0m
         R84YL7lPRDXGgoUFHjjBIhIAjHss4stzBrC8r1fY+YpU9YcDGhCX3mAqKwOTpCoD7gH7
         OWXaQt4Fgng/s3F3kuMi3Y1ryYqukOhMq5kvkrJyWuxbdWkRokM6+ABxhsyUHkEakrFZ
         HM+Q==
X-Forwarded-Encrypted: i=1; AHgh+RotL3KF8gmMIOie4hSV7asSF6BDde2qcKpJVLl7U3pM1HBZ4D6nDVWsO3ZnsT33f+wGq0FdGCfmhw==@kvack.org
X-Gm-Message-State: AOJu0YyOXMa91SS9M1r32jZUySLSpcakoHhyPbq/vPqqThdNGudhrjmt
	kBYy8oYpP7rzDT7PqOsHBjkKyqEZeDqJKJqMmZ1h7Nk7ZYaWLb94JFQd
X-Gm-Gg: AR+sD13G65T6rSxvZgxPr7cFOu+RAkgYCGu8ew/WEW+ARUZp2MEjdFeWc9KXKFHxoni
	xR1Xn1sggB6Bp3jpujDsyu9sq2RQcb/Y9o6p7Y/mw7Vq3UTWBgd+BQ9njlJaHB0g/OLIbDJjKTx
	13Ry1txLriQFe9HL0XQIKwNG/lytQ+ePO9mrVKPobqRTyMBnVBjaADpPm3e2RktoXR0GpWjfpcC
	CdnokHk4kATqTV1VlQu8O/mGHJ6Xxp84P9oUr5J/pUHMIUOKSu+IE3Frfzqy7use8s5WqzZY/AT
	eZeItIQTH7AY781U4kyGBAoHkIY6r8pteOsatzFXIy4JLOdzR3y/8rSnIkmpVxW4v+eYhMDajog
	2zJUAAi4zyiChrLSZNZRiv7uWcNp2UiShhLvxF5x1CGhVs7ZwgwN5f2YQK0iERhT34yt/R0CtOJ
	FINWaRbMJxr1PwAnkq2KBSpbT2ZaAOSgk2mhDcBMgx/S6Ip73RKtLyMMTFSXDlap0bEcoj7Mkjx
	vdA
X-Received: by 2002:a05:600c:a30f:b0:499:b01e:911c with SMTP id 5b1f17b1804b1-499b01e9125mr101732655e9.2.1787231921093;
        Thu, 20 Aug 2026 06:18:41 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5e:1100:7303:647d:7cc4:8552])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499aa0e473dsm136027275e9.15.2026.08.20.06.18.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 06:18:40 -0700 (PDT)
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
Subject: [PATCH bpf-next v2 2/3] bpf: Add user memory access kfuncs for linux_binprm
Date: Thu, 20 Aug 2026 16:18:00 +0300
Message-ID: <20260820131801.68759-3-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820131801.68759-1-tasos.papagiannnis@gmail.com>
References: <20260820131801.68759-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nwta8w77q4z9jim6x7mqba9pd6ysh4d9
X-Rspamd-Queue-Id: 73D83C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787231922-249233
X-HE-Meta: U2FsdGVkX18DOEnP7w3PSNod3/tRVOU5ey11mXGAlZexD3YqzSSE59/uBaTqCrjdISMsuNTt6C/SojRYVF19OWwd3hQMswgi3BILeY8RpZdxmxiP/4v6XjgS9O9SflMMp7CSuRvu7PuJeHSK0ByERpP0PpgkshyNA99fJeRgBc+pm8QWMb7ln8qn6l9IrBE018PTqb6wjW2mNoY4wC3Nay1M32lE22SWzK3mjIIcwyvO7vVeEN6GflNb3VzJPCGukbJ+bgizg2G+CVVRZDGmo1k+xEaZ7izTC8VXd8/bNYf3CCs5mcd1jve18hWwwnNPgt4VBYUCXX0XIfSrXnCS+ig1w6fSHDSuplZemjuc9f3i0A55ksTeGng3+xP4FHyzp9xhWkVz9QGy+8kRXcZ7QATNV+dpdlaFlDga1GOfbbhIOZbe1UMLc1Pnyo75TPORISkfcXpVRwrZ4A94Dlp/9O6acmxsWPYst/0I2tB/2H27xyx1ogBcDXME9+XgS9F6Jf57kyBanimfIrdG2Q+JuXmkXajJwBVaDgRyskT0h6BP/MgNBpPz3o3UiAtX/Wo5AOkosgiDPzCexRpwjkgLVbvN9aqxjjLzz3jSFVcyxWOy08wi6FWPZY4OT6KFqWaEqUyrwoiq5t/qVISyRHeHrVPkGHr0fHv4q6umpSedouMMzby1zsVQfkZ+xU2DI+FjXCcPbBHNj/JAbHEDDZsvV1pFL1igKyS4s6Lw032jr51kfD6ZtiX0Kb1sjuvkO2hi9BaO+8OtqbGpm8Z0JLOLsIbNQMAFBfUyFa2bsJfk+gYZWg0zax1AjSmq0ZSyjW267WoxS5DySiBaTKkRT1OwdibRg87F1mMaJSxG0AMRnc7tvmCo+f1XVxuBvQADvPMxiIIS295h5sNplVk0aIP2Ggv7OZJsr6+/kTu7an2ZLftEBijgkUHYOTb9+oSdYXLPZxE6tkrvpOHYY5Ocorl
 9I1IamDV
 2LhfHTGlHjHN9rw0C1RXzr9Z5IrRKJe/Zl+zTaR5FeHdRlD/zOQFrWoOZRqxENRlMvaWiTvrrTTpH6RjPsLiNduumDVJFKq8O6erwCKGhD0Zbv0sn2eHEPCJMBY6ggHE+vD9vnlp4tsFaMrsS/bNdog7WZyY7ZydTiw6Udw8RG4Gruz15Um5c3hdrVoqkkIC0Fyr+Ybv0se4e1ugaPteG1eWpTWYL4FIoz7m4sfHtSqHmiDu2WYyqweu2zWV48ijxZXbZDUfSFsPkR67wXO8S8tv9oFx84XaEkbumivCIfrpryQNGNhI/BCL60SO19a7Xj667T7uMgBNoMKdJSnjI4t3RCu8a4LlSpeKTgE+Cbfwds/N4JG76U1uIIy3e3M+Jw3Tv7id7NSHDlPgLXrV6rXAiYR66LFqEhYNsosIzQROwpoD3guJ482aUOfWofPJXZZHucY8H0hKCHo+t9XjCO+R56WtMFjYTxLV7Bbl/KvAlmekWfbLX44qkFT/0PUgDJBAZIPyCo/tDf950MzD425546Fz68Myy46VH
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

Register these kfuncs on both MMU and NOMMU systems. On NOMMU systems,
exec arguments are staged in bprm->page[] rather than mapped in bprm->mm,
so the kfuncs return -EOPNOTSUPP.

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
 fs/bpf_fs_kfuncs.c | 128 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/fs/bpf_fs_kfuncs.c b/fs/bpf_fs_kfuncs.c
index f1863a891db6..1cd06f9e4890 100644
--- a/fs/bpf_fs_kfuncs.c
+++ b/fs/bpf_fs_kfuncs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2024 Google LLC. */
 
+#include <linux/binfmts.h>
 #include <linux/bpf.h>
 #include <linux/bpf_lsm.h>
 #include <linux/btf.h>
@@ -379,6 +380,131 @@ __bpf_kfunc struct inode *bpf_real_data_inode(struct file *file)
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
+ * Return: 0 on success, -EINVAL if @flags is non-zero, -EOPNOTSUPP on
+ * NOMMU systems, or -EFAULT if the copy fails or is partial.
+ */
+__bpf_kfunc int bpf_copy_from_user_bprm(void *dst, u32 dst__sz,
+					const void __user *unsafe_ptr__ign,
+					const struct linux_binprm *bprm, u64 flags)
+{
+#ifdef CONFIG_MMU
+	struct mm_struct *mm;
+	int ret;
+#endif
+
+	if (unlikely(flags))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+#ifdef CONFIG_MMU
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
+#else
+	memset(dst, 0, dst__sz);
+	return -EOPNOTSUPP;
+#endif
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
+ * or a negative error code on failure. On NOMMU systems, -EOPNOTSUPP is
+ * returned.
+ */
+__bpf_kfunc int bpf_copy_from_user_bprm_str(void *dst, u32 dst__sz,
+					    const void __user *unsafe_ptr__ign,
+					    const struct linux_binprm *bprm,
+					    u64 flags)
+{
+#ifdef CONFIG_MMU
+	struct mm_struct *mm;
+	int ret;
+#endif
+
+	if (unlikely(flags & ~BPF_F_PAD_ZEROS))
+		return -EINVAL;
+
+	if (unlikely(!dst__sz))
+		return 0;
+
+#ifdef CONFIG_MMU
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
+#else
+	if (flags & BPF_F_PAD_ZEROS)
+		memset(dst, 0, dst__sz);
+	else
+		*(char *)dst = '\0';
+
+	return -EOPNOTSUPP;
+#endif
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(bpf_fs_kfunc_set_ids)
@@ -390,6 +516,8 @@ BTF_ID_FLAGS(func, bpf_get_file_xattr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_set_dentry_xattr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_remove_dentry_xattr, KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_real_data_inode, KF_SLEEPABLE | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_copy_from_user_bprm, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_copy_from_user_bprm_str, KF_SLEEPABLE)
 BTF_KFUNCS_END(bpf_fs_kfunc_set_ids)
 
 static int bpf_fs_kfuncs_filter(const struct bpf_prog *prog, u32 kfunc_id)
-- 
2.55.0


