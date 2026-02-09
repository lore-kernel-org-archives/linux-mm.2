Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADA61E7E0DA
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0EB6B00A0; Mon,  9 Feb 2026 14:06:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8E016B00A1; Mon,  9 Feb 2026 14:06:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47516B00A2; Mon,  9 Feb 2026 14:06:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACB626B00A0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:06:21 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 659E98A979
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:21 +0000 (UTC)
X-FDA: 84425848962.28.4821DE2
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id A3BA91C0013
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:06:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vEAubxfE;
	spf=pass (imf21.hostedemail.com: domain of 3KjCKaQYKCAch2hnpunvvnsl.jvtspu14-ttr2hjr.vyn@flex--avagin.bounces.google.com designates 209.85.210.74 as permitted sender) smtp.mailfrom=3KjCKaQYKCAch2hnpunvvnsl.jvtspu14-ttr2hjr.vyn@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770663979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4G/yDIBINwPi2+ikRkQ7TO2ayApdYAt//QBA3TmHUE=;
	b=jHs3o6iGF04stESV2vRNpkewJEBGaH9UiUTXP1j77ZI1lKMcOKcx2T1k1l6fj0KyS6L7Uh
	MthOjw3iEkBuVOqSkj4ouuV4D5r1Iq8XIrupFbL8m8fL1/RZ4tf1IeuhSdgV+3mdJHhmZv
	ixS71lc5h9tqGh0VTEn38LnM3ZTs1IM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vEAubxfE;
	spf=pass (imf21.hostedemail.com: domain of 3KjCKaQYKCAch2hnpunvvnsl.jvtspu14-ttr2hjr.vyn@flex--avagin.bounces.google.com designates 209.85.210.74 as permitted sender) smtp.mailfrom=3KjCKaQYKCAch2hnpunvvnsl.jvtspu14-ttr2hjr.vyn@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770663979; a=rsa-sha256;
	cv=none;
	b=Bl7c8+yMGVXLJL1J+wH9HtafNrtSfzOHLjeMWv5EhRr5JmH6J4wAOCkGkEtS9k8ao2c1pN
	6kylaLXSTiA0ZZT8TFNlSZ13smeQQggPllYBl6iOyWqJ4H3sDXaa2HrUBkxBM1Xa4PnAL2
	ci07b9kT/ULrTQTuWyj2n3umwldsqG4=
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7cfd0f67288so8910252a34.3
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 11:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770663978; x=1771268778; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I4G/yDIBINwPi2+ikRkQ7TO2ayApdYAt//QBA3TmHUE=;
        b=vEAubxfE+1qPsm8mDEQhx93wBVAy+kvC9MEqayOm8Ezu8622YbXxybg9AEMdoJ5VO6
         6E7uugr+J5kl90AfSMYpRPUgzlNbaOLFhymMSWglB1RobxixaOnezGZvhUk5cmXiNbsx
         +3eI3xuK/y77u1yrAYUzn18dZKNPr27G4cxk46w+Dyqi0S1a+ztXH70Fsjr38iI/ahLY
         mlvrzyh0tonaMBcMu+qZgPAca0G3lz0vcAFylOjSkuyRzD72oizuwdpcbP7CBpLBtGsH
         MaQRoTA7aPAHeKRGuBRN9VheyqYzygbQkYami9xRS1RpA8dZlXeA0Tu6zMqqU+hnsMa1
         NETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770663978; x=1771268778;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I4G/yDIBINwPi2+ikRkQ7TO2ayApdYAt//QBA3TmHUE=;
        b=Pij74UeNk+r8WuAlho7X+bLNKje96Oiq1hJdc9fg9q/w9xqB/igdsX9lnQEAbD2qUd
         fRQLpgkQ8AqU5lhKaqEW7lVqEQERlWaCv2oWl9EZQntScW/uCHFa31GAPylS+ux9CArN
         mI4FjdBP0u0N4TIiXEK3g9fN0RQr4JQMu9LMdg+HwWaudug+CjJJK4zbTpwgLFlCv4du
         aqWcpk0vXorRJ0KFUq9qbZvmb3bkiexZydpowscSiPIRJKjBizPgYTG/0ApLurWGNswW
         MfR2GsFC6CUAVf66NxBHs91efOSEyfq6lq4aPp8n8W3idm+9qrf93uebWD50O7vUJedP
         FuZA==
X-Forwarded-Encrypted: i=1; AJvYcCWk1JHibySer0zdXWdPwOCVheNvYPJxo63KzCmTj62HP5Q2hyVstPRo1xyYjd5ua2oE4unLvvG4sA==@kvack.org
X-Gm-Message-State: AOJu0Yzu+xOn6QFlZ4hJfRrR/0qmHCERSjNjbOKpfrpjLNikM+j+39Vz
	/Ks+xyH9FqojkixNRJVmH5oYUWaGPMLisshSV/ZZkQyDxMdAjGNzHg3qaPUEqOkhQiMmatgEDnw
	90h5oFA==
X-Received: from ilsl17.prod.google.com ([2002:a05:6e02:5d1:b0:447:81b5:ae2a])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1356:b0:667:7e1a:204a
 with SMTP id 006d021491bc7-66d0d10b35bmr5231904eaf.71.1770663978454; Mon, 09
 Feb 2026 11:06:18 -0800 (PST)
Date: Mon,  9 Feb 2026 19:06:04 +0000
In-Reply-To: <20260209190605.1564597-1-avagin@google.com>
Mime-Version: 1.0
References: <20260209190605.1564597-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260209190605.1564597-4-avagin@google.com>
Subject: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A3BA91C0013
X-Stat-Signature: zcn9bxhuxqsyr5ygwq1jepj3fdnk96wq
X-Rspam-User: 
X-HE-Tag: 1770663979-118362
X-HE-Meta: U2FsdGVkX18D05HunW4lJNXCsIDt4X2aggMcm7PkwnrcpoMrYMjJFRIPxlbqIJYm0YmnXYYogTbV64pz0qRv21iSiEO14ye2x5C25D0WeyWPc7o/nopdEyyK/QRvI1qS5NQ4fKw4OYMS4L4J6M6eksg5IOQij+Ke/ZfwaqG24loCBSmXIfkbetBZiqJwHGfjGuSuhLwIMVDhTaeYnRtw88m6MiynJPM9wen8CRcRmZrUDZjuTk5C/50gJ/r9M7Vw13ef43me3RoRdpI4WcaOSaqXtMUGK6gkYY8we8DRWUZ+fHuSMYC0NkD6lFlQb1ZS6+IiVH4Jz4vDWue9J5z3MgGbKl5gun1w8XoCyCSVXtVslBBMRjpAYGpSAh/ec+sIN6lOFAdKZ3kVjpabxR8lPDVeDaEiYqDUSlqIsvV1zNcPalAUFPsUmg7R5V0gqRcT/zoWvJdvy3kVMh0/Xx5JPGd4gROW9ZyVPAUMhhPjquEO+Q9Mu/i4raZ6lyrjceBZ9RXO1009jH+CevILWKwfx7La5Ke0EezbkHJumk+cw4TTVBkyzymiiDkCZ9FKTXB5vGfUOtHPU8oSKLiCADbmA+y3AodtcjhEc3OgA3hDlG1TCSTMi2gUNk6Rw+HkLwIP44J8A4qu4ZvWtNNxWUzkBDm7/Xw1lITVvfQzjBfyXbYRG3gFWisaaqB40CHvXae7el71ESoKw2m5bue0dpaLxicTetVq7IttPealu9Epim4756/HTwA3XBJ1VONL4Omi8fTy4n3/X9IfJ5qQlLmqeyDjkvSFZ9IJE25Xsc8KqCZDStUgSHCqLYNRczyv/r1PbBrhnTrTs/4uFfx9VwvNRgwupyJ3SvV5+SfoIZdg1s5mATEee1PFaBkJ1zpzrQYe9RVkVXN7MBFSc+e7jOwlyR/Fn4ZE7wh7sI+m7RPtBy6t9+1FPE2sHMdTztHwKNG9Ynefuow9TyWIy370eC+
 fdu482jZ
 cSCd6CTUDZ1178SlzRKR7F8uiFJgX2LN9dDFHTX+Ya0mYUvK9ptDopS8ihoWbTO1STVtSUvvMoW+VT4R64+UdJoEM7IAiRctZI44mYf0IOISksYreg5BwGj7RmtgqK1NCjAL5yR8umLY+vvLS2jE6gmdY43IcdRO7xItdLgDAq8eLBnL+zh6jZUqQke2sNQx11Cjbl7fPN32+igslFJ61/VnGbzBg5BkZ5rEDD6K8DnlpmxJOazLa8ml9e5PJKIbZiscwLoH/01937vdyT1tg95uHYs5KzJJVvae/oNrgWCOtTJNtXaC8qXsdDXW02D42l8etanUnYjPBUGdxBLyn7gzvLhFNbJMUPPcYBAHtTv8xJ6vRGP2/g5P3t+4mkbAfDVZwl3JfpJ0GUY/eqgHOZ+4p4wWxCXffBGYCpyICyKuv2EIFgj3PhV0GAeSx/HEysMFI3qnEyHH15q4tMH70OkStDxjeLwaSonnO2NrwyzCeVgPClFMMnJODZ9VaJkQ9gTqLJ9Q4IjYRFzYgv90B6taaczvcBOQKy4sBX+v7iA9ESYquuvsSkd8RFsxYJpTKNYKFdD3Yj0Dw6+YVTfmi7ydcmctj4u8wTdJsKhlyoefSkVLWJLA7mxH8mZjkkZWkmFYmoGZnQQqZ7zryn01c7rD9ePDoOFxK+VV5MCLec116Hbwnmt2crFSAeQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mm->saved_auxv array stores the auxiliary vector, which can be
modified via prctl(PR_SET_MM_AUXV) or prctl(PR_SET_MM_MAP). Previously,
accesses to saved_auxv were not synchronized. This was a intentional
trade-off, as the vector was only used to provide information to
userspace via /proc/PID/auxv or prctl(PR_GET_AUXV), and consistency
between the auxv values left to userspace.

With the introduction of hardware capability (HWCAP) inheritance during
execve, the kernel now relies on the contents of saved_auxv to configure
the execution environment of new processes.  An unsynchronized read
during execve could result in a new process inheriting an inconsistent
set of capabilities if the parent process updates its auxiliary vector
concurrently.

While it is still not strictly required to guarantee the consistency of
auxv values on the kernel side, doing so is relatively straightforward.
This change implements synchronization using arg_lock.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/exec.c      |  8 ++++++--
 fs/proc/base.c | 12 +++++++++---
 kernel/fork.c  |  7 ++++++-
 kernel/sys.c   | 29 ++++++++++++++---------------
 4 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7401efbe4ba0..d7e3ad8c8051 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1793,6 +1793,7 @@ static int bprm_execve(struct linux_binprm *bprm)
 
 static void inherit_hwcap(struct linux_binprm *bprm)
 {
+	struct mm_struct *mm = current->mm;
 	int i, n;
 
 #ifdef ELF_HWCAP4
@@ -1805,10 +1806,12 @@ static void inherit_hwcap(struct linux_binprm *bprm)
 	n = 1;
 #endif
 
+	spin_lock(&mm->arg_lock);
 	for (i = 0; n && i < AT_VECTOR_SIZE; i += 2) {
-		long val = current->mm->saved_auxv[i + 1];
+		unsigned long type = mm->saved_auxv[i];
+		unsigned long val = mm->saved_auxv[i + 1];
 
-		switch (current->mm->saved_auxv[i]) {
+		switch (type) {
 		case AT_NULL:
 			goto done;
 		case AT_HWCAP:
@@ -1835,6 +1838,7 @@ static void inherit_hwcap(struct linux_binprm *bprm)
 		n--;
 	}
 done:
+	spin_unlock(&mm->arg_lock);
 	mm_flags_set(MMF_USER_HWCAP, bprm->mm);
 }
 
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4eec684baca9..09d887741268 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1083,14 +1083,20 @@ static ssize_t auxv_read(struct file *file, char __user *buf,
 {
 	struct mm_struct *mm = file->private_data;
 	unsigned int nwords = 0;
+	unsigned long saved_auxv[AT_VECTOR_SIZE];
 
 	if (!mm)
 		return 0;
+
+	spin_lock(&mm->arg_lock);
+	memcpy(saved_auxv, mm->saved_auxv, sizeof(saved_auxv));
+	spin_unlock(&mm->arg_lock);
+
 	do {
 		nwords += 2;
-	} while (mm->saved_auxv[nwords - 2] != 0); /* AT_NULL */
-	return simple_read_from_buffer(buf, count, ppos, mm->saved_auxv,
-				       nwords * sizeof(mm->saved_auxv[0]));
+	} while (saved_auxv[nwords - 2] != 0); /* AT_NULL */
+	return simple_read_from_buffer(buf, count, ppos, saved_auxv,
+				       nwords * sizeof(saved_auxv[0]));
 }
 
 static const struct file_operations proc_auxv_operations = {
diff --git a/kernel/fork.c b/kernel/fork.c
index 0091315643de..c0a3dd94df22 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1104,8 +1104,13 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
 
-		if (mm_flags_test(MMF_USER_HWCAP, current->mm))
+		if (mm_flags_test(MMF_USER_HWCAP, current->mm)) {
+			spin_lock(&current->mm->arg_lock);
 			mm_flags_set(MMF_USER_HWCAP, mm);
+			memcpy(mm->saved_auxv, current->mm->saved_auxv,
+			       sizeof(mm->saved_auxv));
+			spin_unlock(&current->mm->arg_lock);
+		}
 	} else {
 		__mm_flags_overwrite_word(mm, default_dump_filter);
 		mm->def_flags = 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index 6fbd7be21a5f..eafb5f75cb5c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2147,20 +2147,11 @@ static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data
 	mm->arg_end	= prctl_map.arg_end;
 	mm->env_start	= prctl_map.env_start;
 	mm->env_end	= prctl_map.env_end;
-	spin_unlock(&mm->arg_lock);
-
-	/*
-	 * Note this update of @saved_auxv is lockless thus
-	 * if someone reads this member in procfs while we're
-	 * updating -- it may get partly updated results. It's
-	 * known and acceptable trade off: we leave it as is to
-	 * not introduce additional locks here making the kernel
-	 * more complex.
-	 */
 	if (prctl_map.auxv_size) {
-		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 		mm_flags_set(MMF_USER_HWCAP, current->mm);
+		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 	}
+	spin_unlock(&mm->arg_lock);
 
 	mmap_read_unlock(mm);
 	return 0;
@@ -2190,10 +2181,10 @@ static int prctl_set_auxv(struct mm_struct *mm, unsigned long addr,
 
 	BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
 
-	task_lock(current);
-	memcpy(mm->saved_auxv, user_auxv, len);
+	spin_lock(&mm->arg_lock);
 	mm_flags_set(MMF_USER_HWCAP, current->mm);
-	task_unlock(current);
+	memcpy(mm->saved_auxv, user_auxv, len);
+	spin_unlock(&mm->arg_lock);
 
 	return 0;
 }
@@ -2466,9 +2457,17 @@ static inline int prctl_get_mdwe(unsigned long arg2, unsigned long arg3,
 static int prctl_get_auxv(void __user *addr, unsigned long len)
 {
 	struct mm_struct *mm = current->mm;
+	unsigned long auxv[AT_VECTOR_SIZE];
 	unsigned long size = min_t(unsigned long, sizeof(mm->saved_auxv), len);
 
-	if (size && copy_to_user(addr, mm->saved_auxv, size))
+	if (!size)
+		return sizeof(mm->saved_auxv);
+
+	spin_lock(&mm->arg_lock);
+	memcpy(auxv, mm->saved_auxv, size);
+	spin_unlock(&mm->arg_lock);
+
+	if (copy_to_user(addr, auxv, size))
 		return -EFAULT;
 	return sizeof(mm->saved_auxv);
 }
-- 
2.53.0.239.g8d8fc8a987-goog


