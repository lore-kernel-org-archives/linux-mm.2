Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBECEC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6806B00A1; Tue,  8 Sep 2026 09:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7EBF6B00A2; Tue,  8 Sep 2026 09:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 946C56B00A3; Tue,  8 Sep 2026 09:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA966B00A1
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:53:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0810D80630
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:41 +0000 (UTC)
X-FDA: 85190737842.05.C5274F3
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 395484000A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:53:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UBGHfiwv;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875619;
	b=mX39nWtMw9s8/lBzSFGlYiwZSCCZAu6dK+lBSMW9dMQi9XJ4fKRO7TxkBcnH0OUffXTmNP
	Wpsj7/4nKV08weSz6vfxmBv1RmhSEGeso5N+kIwyz9Qu08SB526dPKrwrhj8Y0FRM+SBqq
	Q61vwZ2wUUUu4BOE+jeJ1R7ViXvdlZs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=UBGHfiwv;
	spf=pass (imf07.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99poktiSHLiETVfeHxyXac9wEwytCbkoCCeCU8LCmbQ=;
	b=SFlLvJ2lEM862BLEeLWIAUQqj6o8jL3AZGy2mwLaPeDP357DI2NOQ0Wo1mZtNlcrtLqtxc
	uxZGRt4V714UAcevTFnMVesAx9FwdGnosVa/S30MMkZt1S/A7JDbtdbIDmtWnnU7DKKO1T
	1X/4hfEew0fS6D1GK7BnHit6B3dn2Lg=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso58573035e9.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 06:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788875618; x=1789480418; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=99poktiSHLiETVfeHxyXac9wEwytCbkoCCeCU8LCmbQ=;
        b=UBGHfiwvmXUU0/lmhheihTWv032bwd1X7yiRYqOn8iNTwhyp0lv4/Qdi6M0kNcVE0j
         CrcX1oIint3nsa+xzvXRtPXn7GNZhTdphpmUu3RSYzNuekGmKyii3TkkQZ0LstMaJNup
         8M+sRpoTKIUQVcw/oxJ/G2RtHrby+aGro61MT6ArEezd+eDVnvAhgX+u1IxMQyZhlFfI
         qLZplKPTfzZSrgYtgWywPgek5b0dSQJEpKUeX0JPAmFBeaeUuUEiIPpkoawl5gJwbsx4
         fomdBShL0pXWkxugxSoPuwA2QML6Ku6Y7t5xKepmuqf53Tf8Tv00Nqq6QzB0udVJv4Ny
         /KOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788875618; x=1789480418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=99poktiSHLiETVfeHxyXac9wEwytCbkoCCeCU8LCmbQ=;
        b=ZmteqQXu1Cfc2ys0I1wpMv49VHNETa5V65Gj95PGO2ta8shcYhKUo/ATUSagA39RMx
         AuQ6m62PQ6o5HTPQAewYBEzpRy7yhTqipAFjeYchbEPDc0kvCcVUo8g3DLLzsFw+Ik34
         XezNbzFt0QauTu/RK+ls8EXmb8lS7v7AYRiMmmIvgB6IYGpSSTYJc9q+bHbYTmsxHQzq
         VuCtMN9PQo5l2jJbH/+qnd7N7ytdBc/Y12Ul4rk1Z/2a4ix5+Jgf9x79QvWnksUxARc8
         6DmWl8OwnoEnC7PU1QiGYSm3Dq73W2vb5Ch/YmCYV7CQxQY9Glkai+8WTaFa0XZPGpw/
         xqvg==
X-Forwarded-Encrypted: i=1; AKwUvBz0WqxSPoQ1Bs7zDn6ZCa+kUn/afsA1bbg/v4hxhDcrnwYr5pKSFCNLjQwCs8yi65ynFTSrdu4nfQ==@kvack.org
X-Gm-Message-State: AFuF++mMO+3OYwUvwLaj2UkHUGF9Eoz580lArBtW2d50oVpDXlBLByBM
	JggBG1wKg40ziRURhRTwM7SxdilH96VDrs4+/DGrogJKUygx7eUyULuu
X-Gm-Gg: AYBFou05VjZixujoG8saUw7UUys3I2lxJAfNCgGHXjrlN1qQsebKRh8pcHev9tqPI8p
	tCt3owTzA9Pquwb7unpy0FQJ+TfC5IkXI8A4DWySIjn6UgtNND6mCoEfz3XTrCQxRFttCZtppHP
	0T5Q7Q0+nI8k+1KzxrAxN09g7AVeIsgP9HQvN2qm2FuTXrQBYhYTMpd8uzHO4Ysw28Cakpjh/E5
	vZwu/awpAAMVuwGB01OXv2pxoTyHCdJawtR3mCLTVmkA+4FuXi2FGp9Kj0SU35bW0FIUmVYCL7m
	6jg3I70Jh9SItth3sF/Ww7xGFZXbeCCwv50wNznZAfb3yTKBJRQZJOUsXtZsrRbUztO1YIZ/QBe
	DKSRvhQI07n5Uz6MTMFFlq9ZK9csX5fKyKnW14JRSYhW/+xDOnBoT3sTKkJJY/4E8lqZ97NzZWT
	kntTPaAtPuSBbHwGtQYReYKrsHdR05RVFI8jqipmem3PJa5jGhAVdB61V+PcQ7tnbxxPYoHVq/8
	myNBWWHt3BV
X-Received: by 2002:a05:600c:5394:b0:49c:fc6c:be0d with SMTP id 5b1f17b1804b1-49cffdc89e4mr232121365e9.19.1788875617546;
        Tue, 08 Sep 2026 06:53:37 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5533ffbsm377235005e9.3.2026.09.08.06.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 06:53:37 -0700 (PDT)
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
Subject: [PATCH bpf-next v6 1/5] mm: Add copy_remote_mm_str()
Date: Tue,  8 Sep 2026 16:52:58 +0300
Message-ID: <20260908135302.74963-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
References: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 395484000A
X-Stat-Signature: bjybu8owgua8fypypbfzgatqss4qx56i
X-Rspam-User: 
X-HE-Tag: 1788875619-543718
X-HE-Meta: U2FsdGVkX181yzynarbgbG4kBtcz/m6mJq2CHpZOdneJ5NPzlGULoOSeL5uWIbKfXSm6mhPiNTg2G15BXm/O9GDXNL2ioeUlcMV7p0cX0+7KaYXm4ANyM5pGj4U0F0SSWwjIPfdT+JhQJdwnMFKOTTphNTosHuh1PQHN9oWkEWqL5PewrxX+GkZveliJvcqW4u5RO3sGdPGStjtIKQsWU+iVt4gQ5Bgf8bOyXJAcZgZ1jns7Fy61kKw/HnkSB+IlsU3tMft2v/EVrc+KuE50GWPirhm75vZHCf+pzF93dOQIkvWTicP3/RQ3bPfiy0WaRdwXjYAlPFNpVH7L/4iwK1e12SJOimn7VeYqOoMBIc92tuXh5JAjHK20GOwvv59X/yG1tRxPVGgwYL2ySPr7bMjX4HitfQoOXBQxS6oxDYDOiXsVzjhcsWPhN7mPq1zJHs54vWPgw/H0apSkNrWLDUzSJo2MHFVvMlAc8xhL1+xED5OEcYATJi5iD1akPbrzlOFhkUVvG5uNy52mK/dp5gFRS9VFjYcd6cPwd7nTeBLK8prDASQN7qgH+Te5UMvokASIJIOSE1OJg5uMKphH6hs8+s07XtIM2x+9k1/cBv+aN4dlsJU655+X8MzTaLfAL828+rZ0Xj85B+Ag21R/6RUq7Uf31SlGEqkgiL0xdwbqvbgbYIDWJMVOv1AJfw97Kp2fiPW41vM7S/YSN4Y3NmAFxzYH1PYFV2ymzyytoMcW9qi+JA0JmBFUhuRAaLusHr18w1HjddoCspxuRjn+rR8MpDMT/MbTJUOqbDYMNcSAbMy+ToNgxGS1GLHSC0238uo/1bn2+xEMJ1hVv1VPAlifZiaJ1haMMdkB0mHzT8U2qU2Tc83eoimmYjBl5xXSvL4lGiR/uJsmsXf6ebke80F1SvYHdaPPvw+iXVXnAZ15Rw+krExcPXX0vzdPYF57uqifvWQD7XvuCv/Jy9i
 rrM6qStT
 7tX7e69FAPcwUTkk6Dhb4sGziNNKCdLP3adDyZdor0QSifhZDdOJ3/wEHf0GQBYmi12T12PpaFKVLAxJend/1m5bFFNzsdMdZMvS2G5uRwlTr+Mpil/OaaMVTTGMapwSSZJGli3nAvQ0ytYGHNg5kcoGSaTlRsyZsPvzWa9mB5dkthpf9wAkqiemoeGzQQs6FyXZRdDqXTOWfxssTNr3b37D2Rs8MVxVg3vGAr9/j6koec0WH6pBMZLPrHmEleCCug5DEEQotu8yVTpHZoB4MlbT+VJXJhAkRmhwOAduUIXtmlVetCIHAhcKm4OXhqJ3669+RK4w6eMSfELmlswQd5GNDBAIMDFKBrhcQS5YXDWXkT84fu070AWxMSO/QyIIS/kC3+Q3k2C9+UkNAlnUcr1EJ3pHr+5N24Tc1h+z156mFoXmVpnz+zGeMsTVYcfHjEmazXgyKieDSYaKGSPzyNJNO8mGIVtv73veIqR0SopDucbgTs1ZdsW8DckLrwl0pWJHqVQqNSjKniRUaHX66VeAE7FZ/cmpVKwhqzROF68YIWLG7d0/SFowkRZSP0+cI5WIV
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

Use a common internal interface for the MMU and NOMMU implementations
and define both public wrappers in mm/util.c. Preserve the existing
copy_remote_vm_str() behavior, including handling zero-length requests
before acquiring the task's mm.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/linux/mm.h |  8 +++---
 mm/internal.h      |  3 +++
 mm/memory.c        | 41 ++----------------------------
 mm/nommu.c         | 41 ++----------------------------
 mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 82 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..6f10ce315eaa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3325,10 +3325,10 @@ extern int access_process_vm(struct task_struct *tsk, unsigned long addr,
 extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 
-#ifdef CONFIG_BPF_SYSCALL
-extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
-			      void *buf, int len, unsigned int gup_flags);
-#endif
+int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+		       void *buf, int len, unsigned int gup_flags);
+int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
+		       void *buf, int len, unsigned int gup_flags);
 
 long get_user_pages_remote(struct mm_struct *mm,
 			   unsigned long start, unsigned long nr_pages,
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..557b29381355 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -25,6 +25,9 @@
 struct folio_batch;
 struct hstate;
 
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			 void *buf, int len, unsigned int gup_flags);
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..fe2f5e988fb9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7331,8 +7331,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  * Copy a string from another process's address space as given in mm.
  * If there is any error return -EFAULT.
  */
-static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
-				void *buf, int len, unsigned int gup_flags)
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			 void *buf, int len, unsigned int gup_flags)
 {
 	void *old_buf = buf;
 	int err = 0;
@@ -7407,43 +7407,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 		return err;
 	return buf - old_buf;
 }
-
-/**
- * copy_remote_vm_str - copy a string from another process's address space.
- * @tsk:	the task of the target address space
- * @addr:	start address to read from
- * @buf:	destination buffer
- * @len:	number of bytes to copy
- * @gup_flags:	flags modifying lookup behaviour
- *
- * The caller must hold a reference on @mm.
- *
- * Return: number of bytes copied from @addr (source) to @buf (destination);
- * not including the trailing NUL. Always guaranteed to leave NUL-terminated
- * buffer. On any error, return -EFAULT.
- */
-int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
-		       void *buf, int len, unsigned int gup_flags)
-{
-	struct mm_struct *mm;
-	int ret;
-
-	if (unlikely(len == 0))
-		return 0;
-
-	mm = get_task_mm(tsk);
-	if (!mm) {
-		*(char *)buf = '\0';
-		return -EFAULT;
-	}
-
-	ret = __copy_remote_vm_str(mm, addr, buf, len, gup_flags);
-
-	mmput(mm);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(copy_remote_vm_str);
 #endif /* CONFIG_BPF_SYSCALL */
 
 /*
diff --git a/mm/nommu.c b/mm/nommu.c
index 498e01ee40b0..98596e60311f 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1746,8 +1746,8 @@ EXPORT_SYMBOL_GPL(access_process_vm);
  * Copy a string from another process's address space as given in mm.
  * If there is any error return -EFAULT.
  */
-static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
-				void *buf, int len)
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			 void *buf, int len, unsigned int gup_flags)
 {
 	unsigned long addr_end;
 	struct vm_area_struct *vma;
@@ -1781,43 +1781,6 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 	mmap_read_unlock(mm);
 	return ret;
 }
-
-/**
- * copy_remote_vm_str - copy a string from another process's address space.
- * @tsk:	the task of the target address space
- * @addr:	start address to read from
- * @buf:	destination buffer
- * @len:	number of bytes to copy
- * @gup_flags:	flags modifying lookup behaviour (unused)
- *
- * The caller must hold a reference on @mm.
- *
- * Return: number of bytes copied from @addr (source) to @buf (destination);
- * not including the trailing NUL. Always guaranteed to leave NUL-terminated
- * buffer. On any error, return -EFAULT.
- */
-int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
-		       void *buf, int len, unsigned int gup_flags)
-{
-	struct mm_struct *mm;
-	int ret;
-
-	if (unlikely(len == 0))
-		return 0;
-
-	mm = get_task_mm(tsk);
-	if (!mm) {
-		*(char *)buf = '\0';
-		return -EFAULT;
-	}
-
-	ret = __copy_remote_vm_str(mm, addr, buf, len);
-
-	mmput(mm);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(copy_remote_vm_str);
 #endif /* CONFIG_BPF_SYSCALL */
 
 /**
diff --git a/mm/util.c b/mm/util.c
index bf0513d1d3d0..2eca27b02791 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1061,6 +1061,68 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen)
 	return res;
 }
 
+#ifdef CONFIG_BPF_SYSCALL
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
+	if (unlikely(len == 0))
+		return 0;
+
+	return __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
+}
+
+/**
+ * copy_remote_vm_str - copy a string from another process's address space.
+ * @tsk:	the task of the target address space
+ * @addr:	start address to read from
+ * @buf:	destination buffer
+ * @len:	number of bytes to copy
+ * @gup_flags:	flags modifying lookup behaviour
+ *
+ * Return: number of bytes copied from @addr (source) to @buf (destination),
+ * not including the trailing NUL. If @len is zero, return 0 without accessing
+ * @buf. Otherwise, @buf is always NUL-terminated. On any error, return
+ * -EFAULT.
+ */
+int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
+		       void *buf, int len, unsigned int gup_flags)
+{
+	struct mm_struct *mm;
+	int ret;
+
+	if (unlikely(len == 0))
+		return 0;
+
+	mm = get_task_mm(tsk);
+	if (!mm) {
+		*(char *)buf = '\0';
+		return -EFAULT;
+	}
+
+	ret = __copy_remote_mm_str(mm, addr, buf, len, gup_flags);
+
+	mmput(mm);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(copy_remote_vm_str);
+#endif /* CONFIG_BPF_SYSCALL */
+
 int __weak memcmp_pages(struct page *page1, struct page *page2)
 {
 	char *addr1, *addr2;
-- 
2.55.0


