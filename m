Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AFA6E9A02E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 135F46B008C; Tue, 17 Feb 2026 13:01:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0845E6B0092; Tue, 17 Feb 2026 13:01:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E275F6B0093; Tue, 17 Feb 2026 13:01:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9BB46B008C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:01:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 646AE14027B
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:18 +0000 (UTC)
X-FDA: 84454715436.10.AC2B210
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9014E80012
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:01:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=woswjUsa;
	spf=pass (imf02.hostedemail.com: domain of 366yUaQYKCOoMhMSUZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=366yUaQYKCOoMhMSUZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771351276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sNWH6w2foYf8QmhTrAmxhB/CQUCC0ZNVw0ETpO4TRL8=;
	b=TImVR0ygF43+giDbzYzrG3WU73VM1R4QGq1vdg4RE8eKMg+fOrMcyWGzy0KP4qrwmV7Mue
	EJZxUNbpEewtG1fzsFa4873I7YXGoEJ/TaUKF8cfQ3quQLKR2hD25xzaYQne5YX3/r3/eW
	uBd33jyJPqes0oytcV90/4SR7ZXApg0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=woswjUsa;
	spf=pass (imf02.hostedemail.com: domain of 366yUaQYKCOoMhMSUZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=366yUaQYKCOoMhMSUZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771351276; a=rsa-sha256;
	cv=none;
	b=GU9LC63soTkLyN/sohcwpXg+lN/eviaQu/pWNZBdiWa01vjO6hcnlxeKoqwcmPOkm/guGu
	oU78tJX01XxT28iNVPxxhqCfnUaebaC8VUIqiBWUK4BDTqz5BYmwJ+r7S45XyxVDwh4kxY
	n4ytxXg2rYsaHT5sj9vLz91KhCouIdg=
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-679943693c0so23505169eaf.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771351275; x=1771956075; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sNWH6w2foYf8QmhTrAmxhB/CQUCC0ZNVw0ETpO4TRL8=;
        b=woswjUsanlWzeBEg6z5UR53cnL6vjgy97AxZITn0wLQPnNiYfWeVEnKT8/NqOoIE/V
         wMKTplYOGH8YWbJxx6WHnzsAADVHANeHuf0sJwFXk8rMyLPjz1U6LCIIw5aCXsa52uxm
         m5XgrmLh/qhdsV9lP7mxogSVO9WW9YgNK4mlciccu4/k8fQiVt/L8QNS//rI9jyrvmQb
         FOEo37VPZ1oi5EIviEh7TklHcn4OKeFP0XhyJSrpu+VA7JOcwSMxxm+uCZZ7AbTfpnmM
         3DdqJemVkoBO9wwyPbV1+MRYmRLsoMmRFrIZWDNtK553ExEcAKjbj7U+ok1oPk57DREr
         2q9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771351275; x=1771956075;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sNWH6w2foYf8QmhTrAmxhB/CQUCC0ZNVw0ETpO4TRL8=;
        b=NB5LK2GsHeuRfG2aZBlz+vZYWIai82Hs59t8ZxUPa621j35kq7YhfRIxD7/uOr/Mw6
         kHx+qT0DTJho/7Z4F3CsFObaGi6kcfnOidKBsc+91woQjWAjt+Fg4mWeThnsGrQ+xqH7
         BgZ6b/KaOldPKQkF5AoeuHNs5oJXrx0+og+ZqXguF/KoFKqaxI3tj9KUdCnPRVPFtez2
         RhqJaDasiaAYiKovdBF9wdDrzFhcN60zb9gbpQ9s+ZCN3g2okaTSb+xT55jtndE9iRT6
         f79Krt9fEkSGARlYFj4AKT4yDNjPcd3i4u2R4AxjBQe03OGTavZjvxYZjMX86kvP2bU1
         AKyg==
X-Forwarded-Encrypted: i=1; AJvYcCVK+34q+8wdz/vyF1ES+M0rumJ1DZUtndUZ5KQ7tA/UNAIyD7X7J01c9mF7ph0Q2RESCJi9r4NKVw==@kvack.org
X-Gm-Message-State: AOJu0Yw8zeMWOxW+OzUq7tUKlJMm6nvzCKE8fdkWsdo8DuHrDBAbQ5pZ
	L09NXMT5qLGG7uSnB+17463ZNuihrd1YLG6yYRovfGLZNlHgWYtGmDx4ypRUXUWyDoUF8/tDrRH
	IACorgg==
X-Received: from jabko13.prod.google.com ([2002:a05:6638:8f0d:b0:5ce:aa0c:6674])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:1622:b0:66e:e7e:6524
 with SMTP id 006d021491bc7-677690aef69mr8034820eaf.58.1771351275445; Tue, 17
 Feb 2026 10:01:15 -0800 (PST)
Date: Tue, 17 Feb 2026 18:01:07 +0000
In-Reply-To: <20260217180108.1420024-1-avagin@google.com>
Mime-Version: 1.0
References: <20260217180108.1420024-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260217180108.1420024-4-avagin@google.com>
Subject: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Chen Ridong <chenridong@huawei.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Eric Biederman <ebiederm@xmission.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Koutny <mkoutny@suse.com>, 
	Andrei Vagin <avagin@google.com>, 
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@futurfusion.io>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mjyd9qzm345jfkcorf5br69d8wsngqde
X-Rspam-User: 
X-Rspamd-Queue-Id: 9014E80012
X-Rspamd-Server: rspam01
X-HE-Tag: 1771351276-858201
X-HE-Meta: U2FsdGVkX1+YSVDzItPJxpEa62Wy/OSEhhrgMJX3J1sEjEgRjcm0MxAUJrWBcLKC6f/IsZEsT7A2b3t2ZH1SltkZa1KSKrJgap8LN5TihQCjlJeaO/mbXFm2yJBIN27rrjPrV/+4JRECiPgvCmmVFDGW/rS0cT+sDVsEnqkWsIs0zrvLps+GPW6o6cwx4LWkwbgizVoONB/zbICqq3btxJOg3ADojx8VQ6UX0u+hXLARLzpSOdRGEFV6rS5ooCSVFRb+xM38HpuNWOfMiIm5MKMHkp/c/0QAHcjojnXEzGa2IdV5fimoDi/15UJAWPhHpZuViquDfd3gAETjX6/S72pEJ+s+xj5/z38H2SnhAzwZEN3wzM0CB45n4VoaxqNwcsYnQ5mqvzz9lMicUmiwCdOzTFD14MUn2+yrr+C3iGFe6IabUCpRp/nOjF7gPQ07uyR78OM7KgBkWz4rtxiOZ33tawJAlfu/agsgYBiRudY/l88LrrBRTapRFWicHRF3WI41ySW3n7POL7Rn0HPFmm+PjYLv7Ova+AT4awprushOZDcgHSE+zH/aDNsWXmQNNGZGUelFBQTGJ6tLeyV5fMzlaerX4igWCPmg0EvAgumDwA5pSLpdwV2g2uF8uI/hN5GSsgA1Lxv4Rghg9vuPHkhcAzip6NSQYil58WMeIIFxR49/ZWz4p6rhYBYWINFVsTeRROV3ti79LlTuWFraZNFoNJpBmRkVwRCEQev/Iz8WNp0E664TRl3Oa/dP6OGZ9kgzcCZ9yH8Thev60LIMRjN8QgJzgV7FsTwhTkotparvtsfiXFQksnoAUQsF7Ko5KhpJdoo9P2cFyJEmEyzDBzMQfOR68Hg3jJ3V0yl26JxjBvuAyLqDttNq0iuz1eds0EXZjRFuB43oU4W4T4k80axnoQ+GPFg7PGCuiOVEFzCCSI2jlTfHA7hEFR10DID7GsN8g7lFfUSA6HbkgXS
 XXo9e9Om
 5cgKf8pWGuaWMhBrsGpdAJJKW82GbPAtKEAQ402ZHOo2GLqRbsMtmKZn52vZSLeDvETK5Rl3/YqExuaChQOKYxeLBxe4sGx2jmgIdL8xB2GdsehcbONTo8ACDme0PWpWFmYra84AZM7eKBaI9h9Qb+u4DGBIsmA1y/oW2RKmuE3jdLmaeWQsoZUsVbsvC8czCoa1fzgS5c3zie/vyEWby0zEqS40mpL1bpzyn3TObRyURPm3zbDohB8HLfJaGYgqz4Kxcv7Ug58e5KarOfrQeA8BwIIBl8AJliKNhwuBtZyuyd12DOCfrOjra4wEYYafAUDchakGNeoOLSUKK4ulsRTKce/wupTmJO8ZklYkMC0xX9fJ/su2anOM0t0dW4kEpgunhmDCYK/3sr/E=
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
index 9c70776fca9e..8f5fba06aff8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1801,6 +1801,7 @@ static void inherit_hwcap(struct linux_binprm *bprm)
 	n =3D 1;
 #endif
=20
+	spin_lock(&mm->arg_lock);
 	for (i =3D 0; n && i < AT_VECTOR_SIZE; i +=3D 2) {
 		unsigned long type =3D mm->saved_auxv[i];
 		unsigned long val =3D mm->saved_auxv[i + 1];
@@ -1832,6 +1833,7 @@ static void inherit_hwcap(struct linux_binprm *bprm)
 		n--;
 	}
 done:
+	spin_unlock(&mm->arg_lock);
 	mm_flags_set(MMF_USER_HWCAP, bprm->mm);
 }
=20
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4eec684baca9..09d887741268 100644
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
index 2f3c6ad48c0a..d1a95b90e448 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1254,7 +1254,6 @@ struct mm_struct {
 		unsigned long start_code, end_code, start_data, end_data;
 		unsigned long start_brk, brk, start_stack;
 		unsigned long arg_start, arg_end, env_start, env_end;
-
 		unsigned long saved_auxv[AT_VECTOR_SIZE]; /* for /proc/PID/auxv */
=20
 #ifdef CONFIG_ARCH_HAS_ELF_CORE_EFLAGS
diff --git a/kernel/fork.c b/kernel/fork.c
index 4c92a2bc3cbb..e17e57e29b6a 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1105,8 +1105,13 @@ static struct mm_struct *mm_init(struct mm_struct *m=
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
2.53.0.310.g728cabbaf7-goog


