Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D6F4F483DF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:54:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B396B0096; Mon, 23 Mar 2026 13:54:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF30A6B0098; Mon, 23 Mar 2026 13:54:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A084F6B0099; Mon, 23 Mar 2026 13:54:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE4C6B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:54:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5465D1A0C94
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:09 +0000 (UTC)
X-FDA: 84578076618.11.94C6B29
Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 394081C000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Syb7TVS8;
	spf=pass (imf20.hostedemail.com: domain of 3PX7BaQYKCJQyJy46B4CC492.0CA96BIL-AA8Jy08.CF4@flex--avagin.bounces.google.com designates 209.85.210.74 as permitted sender) smtp.mailfrom=3PX7BaQYKCJQyJy46B4CC492.0CA96BIL-AA8Jy08.CF4@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6mLJgPLWSuoj/P2MAtrzoRO0g8BMHCjkX0hvTYs5nb0=;
	b=Af14cDH+fQkOgFM4qF1dHg2VxZTAW6oDJTcDiwFC3J5O4U6JyFwRwWh3frOSi1HhjO8aQG
	rSd2WIwgwbCIyxk5L8l5yMuwEbZzlTW+kyA2Fzwnb3871avFmw4n5ODKWJ6PGeU8/wjdT3
	rlee/kQYOIdujO843NRm2w3fiPoZAvk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288447; a=rsa-sha256;
	cv=none;
	b=uRqG0oCqYzfLU0f1dwTdS5/oIszim59EaQ7ue0cILRp2LyKE201O1H/wXmrEPmZNsWZeNq
	wt1G9prUOwZo8NKqX1iiye1jxHX7obe4qYtDHjpenp48NfoqBx7PJo4XtvMjd3DJ+e8b0p
	tVGoV7i4csA13lCqFxXXMdsguSWoFfk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Syb7TVS8;
	spf=pass (imf20.hostedemail.com: domain of 3PX7BaQYKCJQyJy46B4CC492.0CA96BIL-AA8Jy08.CF4@flex--avagin.bounces.google.com designates 209.85.210.74 as permitted sender) smtp.mailfrom=3PX7BaQYKCJQyJy46B4CC492.0CA96BIL-AA8Jy08.CF4@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7d7510702e6so2742523a34.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774288446; x=1774893246; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6mLJgPLWSuoj/P2MAtrzoRO0g8BMHCjkX0hvTYs5nb0=;
        b=Syb7TVS8AZ5GtjyMlW1CGI9KnuZ8SA1r+G7jR3Bo3NcukQCyCzsowDlDUhNy5zYYBd
         lV0mLPSe+aM+w3lB1WypA1kHbMf37/4TF0Dp+5+n+sCfj2fkQy6Am73C3I9A9Ber9eVL
         YTrGT92JUOrmR/N11w4THQXFaQeDdCfZVGat8K9wdOhjEHCMMv+xbV0mmsKly0REr9y7
         RMb3xk61+pILlDplCdB3zXiHK4SV3VA5o2lJnSE2NKZquPLBdX/Yc4fENuHqvSa99lKb
         8N9thaEeI7Q3nnJsRb+xccWwSZKj4qATyvH0zCknwmpTkGUVL5ZlYgtDt4sQUQbLv/hm
         vwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774288446; x=1774893246;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6mLJgPLWSuoj/P2MAtrzoRO0g8BMHCjkX0hvTYs5nb0=;
        b=lFdBWxQnZ0is1sUHh0l92sioymfE5T0wI8K93Ki9OlEjuiMs1gZjpBS9xbES7My23W
         X1mYSK/6WEl3WZqVIeuL4xMj4L/kDcF0Hab6mWmAbl1i40HlTcSqsY8/9nO2H+kwegmz
         xyDELdmB88BhhmFxQTroMZTx/qPvYxG5spqeAzuki+PBM7fKPdd5UALAeHDdsOYERtJg
         wYrGz3zN454xiiJInl/Mu+YIkIA7GRqJCWsbhl1Lu0+tkgWI6K1LOC8OZdXa6FKdy2yd
         QY8G+rrK6m3YoHYKtkv94bHt1ThgM1TrmONkiajJhaPXNrx1QARzte4N3lMNXAitD3Fw
         FL2w==
X-Forwarded-Encrypted: i=1; AJvYcCXOw7MZctma4thElXA6B3/k8jUgGejPIcJCBaEiliaHQ0C9qbyOlz0BZHPf5AsN0NRKL65uDSwvAw==@kvack.org
X-Gm-Message-State: AOJu0YysdfFPitf8WlUVNCMk8ME8/xLEtm1/vdBrzRnCw/dPY9IJX8AB
	wUDNXghU2vBigBMGk6DL8oaalzRsuUGBD0/qAaCQhhy80kZwpjOkL2AjTt2lEj6t08eSjDJuBXI
	Ff4rrww==
X-Received: from ilbeb14.prod.google.com ([2002:a05:6e02:460e:b0:4f8:5be9:9dbe])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:612:b0:67d:ec7b:cc9d
 with SMTP id 006d021491bc7-67dec7bd049mr3051580eaf.18.1774288445933; Mon, 23
 Mar 2026 10:54:05 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:53:39 +0000
In-Reply-To: <20260323175340.3361311-1-avagin@google.com>
Mime-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323175340.3361311-4-avagin@google.com>
Subject: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 11dc89qcuwm8sndzskjwib4guwseerrd
X-Rspamd-Queue-Id: 394081C000E
X-Rspam-User: 
X-HE-Tag: 1774288447-709318
X-HE-Meta: U2FsdGVkX19OnAuCzis4aZ2cQPYqUGUuFshvoZevHA9BW36ontq8U0i13VQGPOREFeehWL6CbXysTJ73lc9aBB0JOlVSaP+DxPFEYw8ETfFQ8lQvRRWlh1MPEcjmgutRfr9hMORUuyqPG5607lJWnZUtRrACfLWi1Il6Qz4JOSvGUDv8oTQmn6rDo/Yiphu3vzysL2jO2dKWXg+aGvOb0MwijDVHQsSIreRQRC1g979OFotJUQkkc9GujePhZGHzjQWN7Tl+xVvj05zF5H/uLkdCZfN4fjkvEkctSiOrDuR3dadls07bRn8iSea0elkUmP2RwDZ4JBab//HwOOJC854tJZiAuIg1I8F9TIie0LX3qeOAucA+kGjG7MIZWPteWIzJGpFjOYCQEjRYfffm9L3geyfT1nElLl/xlq06XkPHrJvu2F9SnlXzp3gpqi5LWt/JWy0PlzN2b2JH7B32gSXzaW5ZWX8cb+f/Rq2jmnmMFOOv5/UT88LxnxQx2bb2KbtWEnQ/9ObvHJgjJpyutSjub6Esd5aGxEq9q0oBFCybhsmRV47Uovti8uIVeQD70/npOYbH5kYCfijwBgbpagXCQtaUc+2XXk6C1uejgaZNohod+HvIKo2LcrCHCWKuAdt55zX2cgMhdhDmJ0/Zj1mO4Jxogh8lC1u5PGw+4KzHZjh5vQDC8MwjJrOeKu70X0M6ifEyr+1sJ1X2f5uNn2W8VGCPn3wvx5qMEtKivqZPQGIoLV2/RryUP05Kdo0llMHt5yJiGw/LLEi7xGG0sTLP/0ny5Fb/K4BhcOm2wy+pXcts+oTn0GmHkRjiiSDDFrkKjPHwxsFFR5ejaBUl5c3rm+zeTAX1x7ReQCjXTzA3R+seni1yaoUDgIvKgxIncX9P5eveT31Oc42sOoioucuw3Fj9+A04kTLBYRICJKOuyI+h+5aW34m38kseYpJ6mmRiBxs+0mb7mx/2/UJ
 /muLw4Tv
 zLOP1uOnI1hdd0pcz30a9J4Q65jDKsvBOPOfhu7TkpCR4Np9K8pvdrZ8vNeh/WCfEUWkGhKsw/G4UakqDPjHqdfQmKyFqMqG3A0RefrW9GCtjXz92KZaDK6bVBTJqLeUmBdKxn4413OVyRODqi+v/ils9TC10gSb0bW/O13wyC/zN20ux1XvDnohcITojgraEGVU9FyAFhDSAAY8iZqhjS8xl9Psk6tOXfkZPYo0ayRqt9Y2s5xAm6GhugZVzNrstZz9CTxWrTUQfixQPk/4KmT4n5ZV5/qqJ9Zb6ixhdlSDhbRkA6wakb8elgPEIfvUWbEVCRi+niw3cezLqgms6rI8BgW+A0a4/ZgrQEFVu5nWP1dK7oh263YH5b26xDIpKGS5nGwvdBRqr7fwH/gMHnZdC5DdhPCJSO/jFWKhHa7qT2+hoaEf8FCKPyTbcojYrLSizYqpKn4BDhB7Q7q0CXWS9gjTQ07hVK4+XLR9IxAUEqPCLlgfD9PGNp0GrKgTSnyVg216aY002tAzJ9DIGkCpcnof+eLqmApthBEqPz2Cb55VxhxevXuwRy9/ZT8d4OtEgPRBlPnOvGiihsOu7NdZ9BXKuTO5Y8b+Atx0Ai+cCynx88UP1J1BmSHYBNjDbhbpWGLVsXIuv+r6/M2UPTgdd85sCXDaWTpPyYCp2nT3oGcJ/LmOX+Ydjk4clcGJFjm9UMOZ+65IQ6TNbAsXFKm2XPPTM+7ZX/H5Fx2+Gk4f/szguzOIgCUK+loUct3Zqm81b
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

Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>
Reviewed-by: Michal Koutn=C3=BD <mkoutny@suse.com>
Signed-off-by: Andrei Vagin <avagin@google.com>
---
 fs/exec.c                |  2 ++
 fs/proc/base.c           | 12 +++++++++---
 include/linux/mm_types.h |  1 -
 kernel/fork.c            |  7 ++++++-
 kernel/sys.c             | 29 ++++++++++++++---------------
 5 files changed, 31 insertions(+), 20 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1cd7d87a0e79..dea868d058fa 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1791,6 +1791,7 @@ static void inherit_hwcap(struct linux_binprm *bprm)
 	n =3D 1;
 #endif
=20
+	spin_lock(&mm->arg_lock);
 	for (i =3D 0; n && i < AT_VECTOR_SIZE; i +=3D 2) {
 		unsigned long type, val;
=20
@@ -1831,6 +1832,7 @@ static void inherit_hwcap(struct linux_binprm *bprm)
 		n--;
 	}
 done:
+	spin_unlock(&mm->arg_lock);
 	mm_flags_set(MMF_USER_HWCAP, bprm->mm);
 }
=20
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4c863d17dfb4..b5496cec888e 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1083,14 +1083,20 @@ static ssize_t auxv_read(struct file *file, char __=
user *buf,
 {
 	struct mm_struct *mm =3D file->private_data;
 	unsigned int nwords =3D 0;
+	unsigned long saved_auxv[AT_VECTOR_SIZE];
=20
 	if (!mm)
 		return 0;
+
+	spin_lock(&mm->arg_lock);
+	memcpy(saved_auxv, mm->saved_auxv, sizeof(saved_auxv));
+	spin_unlock(&mm->arg_lock);
+
 	do {
 		nwords +=3D 2;
-	} while (mm->saved_auxv[nwords - 2] !=3D 0); /* AT_NULL */
-	return simple_read_from_buffer(buf, count, ppos, mm->saved_auxv,
-				       nwords * sizeof(mm->saved_auxv[0]));
+	} while (saved_auxv[nwords - 2] !=3D 0); /* AT_NULL */
+	return simple_read_from_buffer(buf, count, ppos, saved_auxv,
+				       nwords * sizeof(saved_auxv[0]));
 }
=20
 static const struct file_operations proc_auxv_operations =3D {
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 62dde645f469..10351af5851b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1255,7 +1255,6 @@ struct mm_struct {
 		unsigned long start_code, end_code, start_data, end_data;
 		unsigned long start_brk, brk, start_stack;
 		unsigned long arg_start, arg_end, env_start, env_end;
-
 		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
=20
 #ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
diff --git a/kernel/fork.c b/kernel/fork.c
index 2ac277aa078c..3880ce0d44f9 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1106,8 +1106,13 @@ static struct mm_struct *mm_init(struct mm_struct *m=
m, struct task_struct *p,
 		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags =3D current->mm->def_flags & VM_INIT_DEF_MASK;
=20
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
 		mm->def_flags =3D 0;
diff --git a/kernel/sys.c b/kernel/sys.c
index e4b0fa2f6845..c679b5797e73 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2147,20 +2147,11 @@ static int prctl_set_mm_map(int opt, const void __u=
ser *addr, unsigned long data
 	mm->arg_end	=3D prctl_map.arg_end;
 	mm->env_start	=3D prctl_map.env_start;
 	mm->env_end	=3D prctl_map.env_end;
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
 		mm_flags_set(MMF_USER_HWCAP, mm);
+		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
 	}
+	spin_unlock(&mm->arg_lock);
=20
 	mmap_read_unlock(mm);
 	return 0;
@@ -2190,10 +2181,10 @@ static int prctl_set_auxv(struct mm_struct *mm, uns=
igned long addr,
=20
 	BUILD_BUG_ON(sizeof(user_auxv) !=3D sizeof(mm->saved_auxv));
=20
-	task_lock(current);
-	memcpy(mm->saved_auxv, user_auxv, len);
+	spin_lock(&mm->arg_lock);
 	mm_flags_set(MMF_USER_HWCAP, mm);
-	task_unlock(current);
+	memcpy(mm->saved_auxv, user_auxv, len);
+	spin_unlock(&mm->arg_lock);
=20
 	return 0;
 }
@@ -2481,9 +2472,17 @@ static inline int prctl_get_mdwe(unsigned long arg2,=
 unsigned long arg3,
 static int prctl_get_auxv(void __user *addr, unsigned long len)
 {
 	struct mm_struct *mm =3D current->mm;
+	unsigned long auxv[AT_VECTOR_SIZE];
 	unsigned long size =3D min_t(unsigned long, sizeof(mm->saved_auxv), len);
=20
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
--=20
2.53.0.983.g0bb29b3bc5-goog


