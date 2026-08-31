Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64FCEC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AA386B008C; Mon, 31 Aug 2026 05:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533046B0098; Mon, 31 Aug 2026 05:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448F46B009B; Mon, 31 Aug 2026 05:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8356B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:23:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 96DEFA0428
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:44 +0000 (UTC)
X-FDA: 85161027168.18.0059517
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf12.hostedemail.com (Postfix) with ESMTP id C44AE4000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:23:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpK4i4VD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788168222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gy3RmBcuruQaR7WrIBsKEmLLWdsVsMuBKWJEzmGMhsc=;
	b=EpJ6Gb0BTMAA3RvNB7G57EcXRcowz69agv5VHLpCScz0uxc4c6pi/PHSKVjBmho37hzo64
	OQ7FenEKzmjd02A/H0eDh8q3V/wPjtTxodX6ZudOGgq/oQKKWXNi9IPoNsZoJUvUnvLqIM
	UAuGUIt7px2uBIDoQIcWpRH5UTB/3gc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YpK4i4VD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788168222;
	b=3C0yj4eDeIhBbRtAI8gGgs8QqWp3Lgex7KCEsxa8qfHLBmQGqrI98gKXBExlFV7mXhkJJl
	HR6X9HKLZn1xBvJWl16C8NBUNMcmaDyObEglgg0ZCBS2B32DYNWWX8TEDYJ85mJWXYqibo
	nuuCKcup6frsGRl6L1ZIyZBJ0D1uk88=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-495437bb891so20189205e9.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 02:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788168221; x=1788773021; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gy3RmBcuruQaR7WrIBsKEmLLWdsVsMuBKWJEzmGMhsc=;
        b=YpK4i4VD/TV5Q9K305zXPSQ/BfB06CiOpQIb0WECD/SjjZkKfVBnzxM1x1j8/mCR6X
         CvCMFxgmaihxAUg01CaYz6jY4gYtCIquLke7Jvh5MxL+v9OjaB4M/d1GaaGeMtR2ycWo
         PqDISrgUEGJbF4baT+088i5ybhAe8Zom52RJsgb6Wgv0YLNKkUtFGcqEEsfgeGh5/lTh
         eV97acvNrSvmUWzHH5VIyEDgLqhIuDoDZ2b6gQfodXtto08n5WP7uU5SNCNSyhsxwWlv
         UbNUq+UGEsDdQQncHlAurpNPniet6bOlnDj9GzEByPENGfzPC7YuaWEaBXjcqgJ6m2N/
         mOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788168221; x=1788773021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gy3RmBcuruQaR7WrIBsKEmLLWdsVsMuBKWJEzmGMhsc=;
        b=A/aiiRzVjgTWy77G5ccgg/MuxcmOHntsvbsnSUf1pYv/DmkPyX0SCu3YCKJHBNYriL
         bii8vN611vPpQJCsBZ49zOm4XeUp61OqhSd0TgQIIc3s9fU/9SnGRVGY57ofCnuwuI+I
         5MQWOUXdCpl7mL7ohPF75HA7hdyoXv1O+pBdBLDTUvpYPa6DV6t0fbxXmJtZaLmBIYSH
         UwZcmsj/MbM2HWmopIMe+TsRP5QHEv0pN0Sf23ZvENgtxDNEFHC25fYXSN50k0qUJoXz
         032a75GinPqfOoL5CjoId2jIbnnVYyRLlEKYVePHsu2HjWx0soF8XfK2N1peKF/6RQMi
         GiLQ==
X-Forwarded-Encrypted: i=1; AHgh+RpXFODpnteioChC92BWBoubwHDdT8F9sIMCy3pMsJgAyjxUYDDVgqMv/A1JUNKACBAZwbQ7PM2G3w==@kvack.org
X-Gm-Message-State: AFuF++nxwAVf4om0eEO7MhH9VKCn7+Y39LF4hYGIHkwphiyUo2uSZOen
	Fee+u/R0gVldSWPwNWrK5J/MKn6uTIYCMAtJ7isBv+k2gLcefhUrtDil
X-Gm-Gg: AR+sD10uiqe2YzbvGu7fAUeWYYQWz++2HzFQV16Ry3ITbyXx96cgIxFueTgesx1lblh
	1WWG5fJDOR4iQJY+GbEeVIPAk3DJk49FV0Rvz3PfODKwxxixDs9DYuL4cramEbzb90jGwAvkgIF
	/c97u8ERAbu8IhYdRc4qy8P19BqX8D+N6iGHDtzn0Vc1V3x49EjpH84WuEQJbHIOXJJxtdiTPL0
	A/l/KE7HbwEzGY/mJWRLovYb7Z3FDc7Zwoj95ZzM1XNqz4vmRUfb2A2Pk0IMV0U/9cOu1RxHplV
	wJ7QYH26XE1c9BMqfnwRHUERp+Vfle692UPVZLx4U7y5MPwN4AlmpFXIxHqST6uQXk2B/Mbz1hN
	oC7F1j60mvE7UgcWu6X/wDURfBOFauTUwYEaPPU6f8lr2W1qgDCUF8UySJfi/QQdUBESZXLnllL
	kdrIrX1kJo6pmACDgy5rcsmnYhqFQV7PkaGxoYPT8YWDY6U/VY5bvJb/tz7RxlYQsBuiu5V3l+P
	Q==
X-Received: by 2002:a05:600c:4f49:b0:495:5d6d:9cc1 with SMTP id 5b1f17b1804b1-49cd52b2c93mr119072045e9.0.1788168221065;
        Mon, 31 Aug 2026 02:23:41 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c80asm318248155e9.9.2026.08.31.02.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 02:23:40 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 1/7] mm: Add copy_remote_mm_str()
Date: Mon, 31 Aug 2026 12:22:59 +0300
Message-ID: <20260831092305.42062-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
References: <20260831092305.42062-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kqmhafo65dz3ne36zf1wnhjkz5y574q3
X-Rspamd-Queue-Id: C44AE4000A
X-HE-Tag: 1788168222-343880
X-HE-Meta: U2FsdGVkX19LolblhPDdzQkDJ6HmRBKprK52bWb8XyeFbxI3+hsy5R57dy4Vd4/4XySMp3QVTW6CVcxg4Vl9mmWqvwoQlcGCw8tpY3RAXj+AqQ/1vmGDqhOgKyctipZChOd7kAWsWCYd+dG8RpnTqt8N/MSuOA6PcZ8gc8WoA0/bEDjTNYeLOQrKFenZapxPMNYfkG+N15AiCd5kTwMhE8mwGduTTvC0jnVr0At1Jif8NVqPoRJwIgsAu8RBslxzmk8Joww03DyW2bmwvaTEiZky8mkcHxbb8AukRD1TiGS88QeyVfTETccB76UJ0AKDZnt8mtDk5OObXMXOYGrCyO5SF7NHBg9kV7tBVKkkxl62wE0rS53ya9UOxIXWopZZkHyjFreOekXjUAtllRKVCJu6XLGwtQutyWDiFFK5ea15NEDIpzmGBfOsedpGg7G3JbM1ixy47nEe/qZ4zIK50ZqECmP5XjU5bEAwzwVNeOV9es2WLaBlikcamvm//rsmqyEjKfo49MlfpZotMfnXBAT5f+NR5IxVBOQ5SjjNX3C9I4akPQH5NA61KoPQibF8qBaCHLjdpk5hSIkvVOAxJU0wDc4n7CahhwvmEPWKtw3P+bEBdrIktgnUX6lW3zg9zA+DOWVzMPPZ8o6IcqaBrZZAWKuLbN+X2UeRs4RLaRJSPWIP5ZGLNZlmCWDf7+m5/5HNX23Zvehi52ALpxHsK2hJE+vVops91NYmWkhWYm0/ayNc4PxYLngqZYKBwBuBJVrn2UoCz0nG/PHzBkPR7bfO9nbH4e98T2C/fYFcsMt8c2rklcnKOXrv+rucFSrMyWHz8LW2hrlMUKKUOR+qVLrJIbbF6UxkDOyl/c3XOGqcvL3Q3ClGEBeSVf/VXSv7jknWrFkCCZIXO4pJXQ8sI+0iVoKrdUylAh689NOFMZAjtkmeTyAExhuVFGs7IF8y0qf9p6e0j6JZp0280G8
 +L7wQerz
 kSxYxYV6eQvIj2lQHZsURHNQ0C5uL2uD1AFdxvtS/AwV1RBu3rAEwVIsYxr2+uRHR0L0dA4Ol+bEcJrIOy1bsV/mHUQ8jiBDoMs2c7bZ3+cs3Y7aiYp/8UkRgLVrq1haJFHsUC2RJwE4yvYkYpsKVNZrqrJkWr5eg/EfZZs+P050NKDKD/L/TuQhdhZKG8aBTRRHDUc+4BNXFEz+1TAFd5MP7fDFFkHHoxkxWTWzciUzB4jh+wFInzgnKH+vQXsoPqwe+z0rWhdpysnnc2SYnop1bAXX10IghC4Q9+ae41S1mMfeJ4m/X5jIdy/NxYe0t2mxkCrmmP/jj1DQwA+lGjNj6bY7GTO6mMq/NpxAIYl2mswjgG9xryZFUZm+s/t3ZclCI9kC3GIXLgdQrZosUefUnR5yJMreWQPSpwQYbYz8fraQ6bbgkazm2xBgplRBik5zrVN4BHXOf7m0n9VK4Zx2YCkKtVQiRSMUx4ijVAu3uqO+JflajTgZpVMEHVWK//1YWxQZ1XtNkoHwXivva7WXQMKDIuaX6/Ftd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_remote_vm_str() gets the target address space from a struct
task_struct. This does not work for an address space that exists but is
not yet associated with a task_struct, such as the mm held by struct
linux_binprm during exec.

Add copy_remote_mm_str(), which operates directly on a struct mm_struct.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 include/linux/mm.h |  2 ++
 mm/memory.c        | 33 +++++++++++++++++++++++++++++----
 mm/nommu.c         | 33 +++++++++++++++++++++++++++++----
 3 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..eede435bf4a3 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3222,6 +3222,8 @@ extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 
 #ifdef CONFIG_BPF_SYSCALL
+extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			      void *buf, int len, unsigned int gup_flags);
 extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 			      void *buf, int len, unsigned int gup_flags);
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 6b8280cfc1db..4c5f0b629889 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7141,12 +7141,15 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  * Copy a string from another process's address space as given in mm.
  * If there is any error return -EFAULT.
  */
-static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
+static int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
 				void *buf, int len, unsigned int gup_flags)
 {
 	void *old_buf = buf;
 	int err = 0;
 
+	if (unlikely(len == 0))
+		return 0;
+
 	*(char *)buf = '\0';
 
 	if (mmap_read_lock_killable(mm))
@@ -7218,6 +7221,27 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	return buf - old_buf;
 }
 
+/**
+ * copy_remote_mm_str - copy a string from a remote address space.
+ * @mm:         the remote address space
+ * @addr:       start address to read from
+ * @buf:        destination buffer
+ * @len:        number of bytes to copy
+ * @gup_flags:  flags modifying lookup behaviour
+ *
+ * The caller must hold a reference on @mm.
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
+ */
+int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		       void *buf, int len, unsigned int gup_flags)
+{
+	return __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
+}
+
 /**
  * copy_remote_vm_str - copy a string from another process's address space.
  * @tsk:	the task of the target address space
@@ -7229,8 +7253,9 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
  * The caller must hold a reference on @mm.
  *
  * Return: number of bytes copied from @addr (source) to @buf (destination);
- * not including the trailing NUL. Always guaranteed to leave NUL-terminated
- * buffer. On any error, return -EFAULT.
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
  */
 int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		       void *buf, int len, unsigned int gup_flags)
@@ -7247,7 +7272,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		return -EFAULT;
 	}
 
-	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
+	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 
diff --git a/mm/nommu.c b/mm/nommu.c
index ed3934bc2de4..94e3709e95fd 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1716,13 +1716,16 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  * Copy a string from another process's address space as given in mm.
  * If there is any error return -EFAULT.
  */
-static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
+static int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
 				void *buf, int len)
 {
 	unsigned long addr_end;
 	struct vm_area_struct *vma;
 	int ret = -EFAULT;
 
+	if (unlikely(len == 0))
+		return 0;
+
 	*(char *)buf = '\0';
 
 	if (mmap_read_lock_killable(mm))
@@ -1752,6 +1755,27 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	return ret;
 }
 
+/**
+ * copy_remote_mm_str - copy a string from a remote address space.
+ * @mm:         the remote address space
+ * @addr:       start address to read from
+ * @buf:        destination buffer
+ * @len:        number of bytes to copy
+ * @gup_flags:  flags modifying lookup behaviour (unused)
+ *
+ * The caller must hold a reference on @mm.
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
+ */
+int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		       void *buf, int len, unsigned int gup_flags)
+{
+	return __copy_remote_mm_str(mm, addr, buf, len);
+}
+
 /**
  * copy_remote_vm_str - copy a string from another process's address space.
  * @tsk:	the task of the target address space
@@ -1763,8 +1787,9 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
  * The caller must hold a reference on @mm.
  *
  * Return: number of bytes copied from @addr (source) to @buf (destination);
- * not including the trailing NUL. Always guaranteed to leave NUL-terminated
- * buffer. On any error, return -EFAULT.
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
  */
 int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		       void *buf, int len, unsigned int gup_flags)
@@ -1781,7 +1806,7 @@ int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 		return -EFAULT;
 	}
 
-	ret = __copy_remote_vm_str(mm, addr, buf, len);
+	ret = copy_remote_mm_str(mm, addr, buf, len, gup_flags);
 
 	mmput(mm);
 
-- 
2.55.0


