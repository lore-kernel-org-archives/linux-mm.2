Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E379C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 14:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC596B0098; Fri,  4 Sep 2026 10:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383B76B0099; Fri,  4 Sep 2026 10:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FDA36B009B; Fri,  4 Sep 2026 10:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE2A36B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:54:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80835A3A7C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:18 +0000 (UTC)
X-FDA: 85176375396.22.B7C8FA7
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B1E020008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:54:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jrbYUSto;
	spf=pass (imf03.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788533656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gy3RmBcuruQaR7WrIBsKEmLLWdsVsMuBKWJEzmGMhsc=;
	b=cb0OXRu26SmvgKP51OZrbzdkdKkwTmPlwcScxj6NVyK/B83d33Gol6UsJKAUnPEwokpX74
	u7Rvrn9Pdz+dmXItjwfMlnh7kkZ6O9tIV49m9EDgobzOpUfSFrIiibNFe1PdBmK+78B3mF
	uETmmEC5pfvFDe9zb9Jc6YrdM30fkzk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788533656;
	b=n30JvfTripoA2qLSLCnyBY3s/aUiu/ExNSs7UZjGl2kON9fBu24eXyg3a1MIXbHsKxKkyG
	h+XRYJ5DDgaEwPiQ5XSuZfqqbiZwMe/cIeKqoimuUUUq5OaHk9Qfip/X81S1Tend2LhTGm
	4dkz6/wGiT5+uOzAjuMIwPTAHfK3mkA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jrbYUSto;
	spf=pass (imf03.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-49557167508so12566885e9.1
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 07:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788533655; x=1789138455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gy3RmBcuruQaR7WrIBsKEmLLWdsVsMuBKWJEzmGMhsc=;
        b=jrbYUSto0zLEIENq7wlQZwW2A1ES78sllKOwFe21bOYqnm5PkMN+8D/8FxfJV+4B3/
         He4qUBZwh2P3OwQdhOmtEpE6OLvCe6NnOnzO5ewv4w33iCP6tqP56XrljPcQCwKDsbnk
         2/2aGgLFGb01+gFXaxmjR25w3Zt+qArIBe+IvFp677R0PsXQnRAUYSTKtO95QS9qZfv7
         TfG1vkDhJS7tiHH4rOeqsPqYW07D7Xlq8BlJqa5MiZRxEBmCdM2hy7QuP1TzYc+byNio
         TUA23vcwEuNICepG/JsdkcYruzpQBA30U3eleNCfK3UJR6aJU0m14lbXe0FTShUOWJKq
         Hrew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788533655; x=1789138455;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gy3RmBcuruQaR7WrIBsKEmLLWdsVsMuBKWJEzmGMhsc=;
        b=flo1ncvAqTpkvb/rNjT0FSRcpXlBmnMQLLI3jdVwfNEIV+MStMDqLNoVmjEB0hbRGb
         tQ0f9lxptcZRN4b+sUcrPOOQZsCc+EECPMIssS/vxsFxot8ANoiT4SeYNnc2J0nMymEf
         xdnl8U8CueSM6hHEm45tzGNN6fOzKGXy0l8CvkQpyDAAIfYfroObykgc3txIugs/LO2r
         l/1Fo2xEkIDCFsyx9Ulc/EurnJfKKCpGpPl83PS9CXw4PfsjEtwOtCfKDR0qnLLMw+F4
         TWuFTFNOEGfg9dJucxT5QDOPN57bJFCuPNFIPD2OqkusrUKK11Sy0cysLdZhX/yeYVbn
         v8Yw==
X-Forwarded-Encrypted: i=1; AKwUvBwo+bRcC96S4bzOjXZ4du3tH1u1bnSzsD4azBsm/uOvGusmoa80WSEJ/M6JAYiITO0YXzaRG7ewgA==@kvack.org
X-Gm-Message-State: AFuF++l84i2uUTHlTSxdQyOYpi/CK+r1uMEjjW9lTgekO7YTTOlzA/8z
	ZvtHQOoU/aJDUVe/U1f5YIc/L4LglX+acPqwQPU3cPtUsIsgB9GRQ2WE
X-Gm-Gg: AYBFou0WVZTbUWiY3ZlaflQi6zr4J2BLknRDN71dTnyPilDkUD2+ZfbORJPxM22Ovrp
	V7vaE5aaMziAY8KJmVW1besj4GQBv4PSq2a8EdiVW4751B+6yXNMcEEexvHwdpA74hfg8+uOLxr
	pqDhFm7CKoAdD4/EUWNui3nRvEQssytdElV9bRLsC0K0oQcZxtelg5x4pMqkut3b80HrV5KtR8W
	UfGDyBxpdBubSIzIS8PkyBD7or6WG/2dQt+mDVn4tbAM2Se76f8twSygdfu6DdGVt3f7jEli5op
	zgr3TF20xEwMdDjvJNyUlZmrNGQX8RT5nFfVwy3YpTrnwWPCMuSFXsSJrNhXPcr7ZkvMu2bHSPx
	M6lPtGEo0CUeau8p8YxDte7wlcJGaMOFvSdA9iAVEI7GS9TbTLh+bcrJWs4Vxu07TtA/xwr6Rta
	ClE3YwRMERCvARRc1vXIR9Pw3Sv0d6QMbLn0QMBCfhGIyujlRR2fr3bw7vokqpzQod5y1nFpfCD
	g==
X-Received: by 2002:a05:600c:a6a6:b0:49d:3:1f96 with SMTP id 5b1f17b1804b1-49d00032134mr4877525e9.15.1788533654774;
        Fri, 04 Sep 2026 07:54:14 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485885cb03asm6802799f8f.37.2026.09.04.07.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 07:54:14 -0700 (PDT)
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
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com
Subject: [PATCH bpf-next v4 1/7] mm: Add copy_remote_mm_str()
Date: Fri,  4 Sep 2026 17:53:34 +0300
Message-ID: <20260904145340.40212-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
References: <20260904145340.40212-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B1E020008
X-Stat-Signature: u71ajceer9a4n7t6hmgtuxex5335ru6w
X-HE-Tag: 1788533656-386875
X-HE-Meta: U2FsdGVkX18zG5kA2tSlHg88jgwu1SAOTKLGvN5RPvTf2dL/MerQvoqTOcJF1zPL3dmlzIAe7DyLG2+rVWv+lBhF77jPfarIA+C7k29S+zZYLArQj4lrLP8CIeLOntVDuxU/BbjRyZ8RemCXD9xR54g/F0SOQlvXi2YnpGbReTFX+S69TRJaq/brgI5lK6w7Q43bBwDq2Dbd853343fKPZ/dZj5cKBNeS9L65UBkMDiwTGTRuSVU8aZauUqW5QDOh2DXZUy7NEFs1SYFTqrAyiU9CuKCUlDzSZ7G7DLmeFOjp+UuGAB93C7Fc933I4uTGql8tD0nWRWVaTJNDmDWzFzg+MDpbo2sDQNYFh6HopCVSKysb1X7rqjKgOi88gSOUnny5Q6LJvbx35VsWl2HISMp9nClJwRR/5PM4gNIs4GsC2o9wb+0zRcgF6ZWOvTMbG1GvHOWob6i1veFYwcn6kHT1Jab3uJOAxtXkkOk/GwZStOD/1nW9J5PkrBNGrOzmkGyWUYzhaprTCVvjqL889OttwfE0Q12YImTR6Yp8yxEEy/7tTuilTD2ChMkuqRze6uAuww6SFVk8wqOCIjJC/1seKrUYOjJd8Bgj6PV6X6himt/YftAS6jXM5ByeI6LPlon7hzMp+XLkoxZn3GhvAP+UMyE2bPnMSBcB2ppcju1R26HVGhGDBWW9UCt0+YqNN4sKOtzh2wY8AVbPf4tdLEQFBf9ONNKsu7lSICH7/Lwcrus6fwzB7vrZCwtRvwjK4UWIhbCwxGkwBRn3XWkuuDHHR8trpfWRFMi+YVikzAr5jRFbxk50x9TE7aMg1nA34UPWZDHMoCTwIjHTUu12C7wLfY7WeDt8u7523kN0gOpC8cHcSdrUnsBL2Q3qeGmWwwYRxw2GehxFaDNYIJApY4TU4Y9hvtU3eK9nb91ThSgpzIQ9mxx8Yo8RAVMS5yn2Bh8/mTS2W8YE81C5Uq
 T1nNyZWU
 hQ84psTBuDqeM4VkmynHMwbotgotiOQjLdu4GRvTJmdcZ0qjG/ssjtjFEWNLtBIghKbmDxYkhFKpiOtlaGi+vorxsaevDfR+pCmM//uCCk1nFQsSjzEJfahO+lVHxIrJhI8XPkI577M13J3N1e47O9nhYUuQcM5gDrSjHZ6o/kJDkfXY8GPOhzV5EMAi8z4wdAONSm5BvJwZqgOmCZBcpw7fB3xRCfM0OKdZ9hciXVqpvMWe8bRreUwSPXK/WAfSbbRkjlFotVJTXINOGjs+2gcWlRn93jSO3XrbAPHIGrgDvknOKbQ7Ecqvzduu4ssiHwgGXK+AuG8VxPKAw6O/n59MzwPT6lJOhsF3eRGph1RGpsRfF1yMRzH3ZGhqloE46YXnC6lLdhfVN9c8xPK3x+kjL9AYJPM84RbG/7sZjMAzjIvYYxDgSK5Kbj60ucQxBWVPjSN06my91Ga4EO29gVebgN8Ffi9W1WgkHk8elp7Y+braZpBuGBmH3Rv2tvkaLombe6OHIHrqIuLhm56hSE5bDI/15JI4Akweb
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


