Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6CB2C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DF56B00AA; Mon,  7 Sep 2026 12:52:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E396B00AB; Mon,  7 Sep 2026 12:52:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934DD6B00AC; Mon,  7 Sep 2026 12:52:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A8126B00AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:52:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C472B1201DE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:52:56 +0000 (UTC)
X-FDA: 85187560752.03.6E2272E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id E828A180002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:52:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=itgugPfr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYJwxo5Nb9UiMMNksSdgP6g3PKaxvBMYGoOE/hW9Rkk=;
	b=AnsHzwGA7Ad/jjPD8fTCw5RFCgFbam1yOz0ky99V1UUusBfkDGO7epgDHjDx2CG0D8NKk+
	+/93wJlwZ6OUWk13cc0Z+d/AOUfrw6z+ZGKp+8nWyPs2q9xM50dFs+173WKvIEMuXJ7X1P
	WC+O1II+ri3GIPJg+dnxoU1U1e/ODAo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=itgugPfr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799975;
	b=DxVGPq2hMw6U3BwOXHMBAalCTG6ZQes1ij7eQ/NX0smjlqJSJFWgdv5dMuOr9vyhsDJSn+
	N1dAbA5QzliNR6aVyPR7z1GSdRxBQ7ZoJXFhtOE/gVCy5RrSyYrGRkLVxjhxmzSatxOxTW
	coop8bEyZGJcpCnT4CWnofk5h/n+W4I=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49d0da752ffso16216035e9.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799974; x=1789404774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aYJwxo5Nb9UiMMNksSdgP6g3PKaxvBMYGoOE/hW9Rkk=;
        b=itgugPfrzFCAaBhiPMrT9OFTX/67oniRLDlpWIMJSkZMzD15g9vQ4QhL16Ej5Lc/Ze
         IsjuNImNUOyFNVnbkWi25dorf+yhqMcnn0J44O9Hzpw8z3VgnqDEaWKqySospK5ay1GP
         Ga76v3jbWcyS6SVdStxp4cWgBBq8Ns+x/ns4FimWHUpv2EtRlwesUiJYu86H9gVpUkG2
         xiOSEGfgKLXT+kfZwaQncTCqcJEEBFln00HTtjPCpxCHcb3PRem15gYBN+Y1D22O37Pg
         D+LDh0d4A9DdxQPC83gd65xH1Ht8PGa8kN0j4x8Iz7KPsHUkmN71CggqQvr5K5Wyt420
         q0Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799974; x=1789404774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aYJwxo5Nb9UiMMNksSdgP6g3PKaxvBMYGoOE/hW9Rkk=;
        b=V1nb6Z633ofvu7vIwXtVMGMN9RohLELVN7HtXq5vDOKPehDGmwpvItlqyR+P0d0Zcd
         ljQFV3XEU51OX1qvqi/X7cyQ0CQlHz0UnuIZNMgN+PVTRGxMAESa/ol38VlWv8o1rRoO
         qmhQJenc6wl9LtWJwqEe2UNvZkIm8DWQ4hpyw/rIQrF8fwGkf1aQ+mXJONFkJAMK2GCL
         oXX3s18Lu/9151BmuqFvsJd9JpYeC9pq9g3U+jL4fLlFjTCyGHagxe9GXKFiDB3Z6qpD
         2zyBclFY5xwr2c0sUiXZEoNMu9IcdQ4KDJXD9RFBoLkqvmIwNm+fjsVU2/5nEfeyBl3R
         /4Yw==
X-Forwarded-Encrypted: i=1; AKwUvBwFHMjYrcivNl3lWNBguXgHCFHVnCQ4I7xQvTIYTqzL7vE2wtaqUXvKqVKQm3Y3ztQpV3rulS85DQ==@kvack.org
X-Gm-Message-State: AFuF++n4qrxfXuqQB9EgNjry2J6/48sa0E0vTKNa3tDzoDJwnfyRw1wC
	TXqjQ11H0VFu6p2b6lkSOhXtEkC01b1YH+GfJQGOC2QDLNNyEVy1ThpLWG6/oVioyQo=
X-Gm-Gg: AYBFou3KvMmxosnKm2IpMLa8/yf5Bijd3EvDRxxZxd0E7Jrb/H6MYWIRpkgNddnQFm8
	Q8EMdjRtzPmLpJ7UVM8loRtFe9tq6aYsM8tSHlLj3WRJUiiFNg63gahCK2bThpg+R6mMcyUU34X
	bYATGKbEWgNwGfVYpjYiKdjSeu2PQWtPHJ56peYoFphpadfdC7V/0a1w+oRRMIYUjsJ/eXixhZB
	cKSailrs8FeifHqN9fjclbwPWrb06doJvu5P4DHEm5mQEDrUh8hZk2YbqDA8uNWl7CLxSYYErUV
	lycokqW0oxOCuWHFKWseQmgG5SjKSJvQzwL+A7yFqtGlBNO/yDIxHLVbhubI3Kbzw+xfqtWfESm
	Gjgb6Hmn0xM6mz5AdUHQ9av39361RikTG+mYQ8t3UpY5BlDRfZWdy60mziMceH2n/mAnEXMKAmM
	ArJxxLZ4t7Ynbm0SpebsMkPPrvFjwCLmSMYzlBOCNzm9w8ESXx1qZMe9rnYqo/LhLMnN3kWP1Vo
	w==
X-Received: by 2002:a05:600c:4fc9:b0:49c:fc6e:8cb9 with SMTP id 5b1f17b1804b1-49cfc6e8e1emr209497255e9.29.1788799973392;
        Mon, 07 Sep 2026 09:52:53 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:52:52 -0700 (PDT)
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
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 1/7] mm: Add copy_remote_mm_str()
Date: Mon,  7 Sep 2026 19:52:14 +0300
Message-ID: <20260907165220.52431-2-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u143xy6h9bnmmbz6wh1q8b1gphg4m8t6
X-Rspamd-Queue-Id: E828A180002
X-HE-Tag: 1788799974-100578
X-HE-Meta: U2FsdGVkX1+h0nSZrEgxHQ00roe+j272gXL6l/z1uvAQ9MLFsv59ixUd5mm6ckj2xfLOmFZ+B/1Fe7SmkpbIDCIJ3WWMDaWUXcuDAc2r08sCGFaRVV+70Xr+1rxwgUatQRTdUNCRrsYfPoKZpQ40kqFd1tlxNBcSE5HD7BOEgCz3kBc9VLc5An772Sl/Zzz7xZYVvRougL89BjnRRAhUs69GS+d6iztJSbXXZSDk30mOtKoj+R0p1gistqkylHniu4NP0xKRcsValI6ZBwjLGkUXafQLflFhwpYz7ze3OZkDYMaAQq8tNpnh92vwH87iAifK/6Funi9urom8GIr+HncbeIZURRQBdzq8NbvHekiBdfh8AqSSwOxrRbloGCzrrn2QynB4bY7OiqJ3Dbpy2CwpjG3Fq3wBQqa0AiMCoObscRfx5XrDL5p7q8jGZl//hTh+pF9602l8RoiUgqhQOabTfU9MrW9rUdc838tchK/fhTvP8J/YlbboyZl8EiMpQg5hLDSpqVaUSxpu+sBudTKzvv5mBJHtHMOxyZvKvfEpYO28d78a0AlpDDHxDkWVHcM1B4Aa52zV4G0n4hDoMhD2Jh6x+W+QB5RFTzem7J7qRXDGfDJvthHT9mO1OAADatZEfJvmbQk+U/XDaVthovhXjgOyv0fOHxlnghSRsolWTWyxsNyD+POXUQXy+4WCjfjVf+Oz401lV1CdDmTMdqLExj9/JlLIpHDZcoybPEnDw10I71Ax06jd/T6Yc9r+IoLO1/pHQ316sDEh+RTIzDqgCTDxFdBwW2Yi8LBCnNJUbdWoxIkWEfDupRM9ZEFf/8wQuoLKDrXFh4+0+aYlhXQPImxelItepJHxMq5S/AcUdRhotv3JS8YsrFsHm3+uBzK3iZc5hNy+06Jx+/J5CEona9X8gAP1dPbZl0Qc20BIWa+4hsP2yIz/JTasyXTEjU2oRYvLXqUbyzX6ZTZ
 o5fB4KPQ
 EAchBftFf1EY26oxiVxD2xb9xvHB1hreOXKr4x7mb3sQNtmmyLqyVHB/DlPmJuCM0LJX1s7Lkm+atj1wnPdR9Y+xnJ6UvWmF1H2OtoxkJ/eadDXN8V8auHasYa2jv4V0U58i1TsfwZQ273bltmREqKeefiU+BRIXyZrtwqPFvXEm8F7cg8XXWDl56gLvr8aWsmWuz5bZOHqEoU2TCPKASF1Y3c5TET8y9jXgWVj/aXYuNBWif1xTsIf7Kyn9wuG4ZtMEq20REiAbp14ueW5+1JnUuueoByXqZmbON0gf1iijlJw95DvWqAO3eq/6BwcBOqELHbBE5FOhBOhSqhMH1ja4JJ/8nLVYsZ9SHgYmm18H10FprGXZ+XgR8jvHiPqqg35YcNXO60/XUIr4qcjmg6rmQk/li1rleu/88CYUbd9PoAjat33KA9fSC6NdHL8DrUx2VdZ3pU7j54d3jeG/ZiSVp2eZmznCKlZUAFol2yz68DM5tRHeu4lY6AGiGDyCqhQBLTn6Ekil0EzF9aTz+ZStU7sP+ZSKY6/BT
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
---
 include/linux/mm.h |  2 ++
 mm/internal.h      |  5 ++++
 mm/memory.c        | 41 ++----------------------------
 mm/nommu.c         | 41 ++----------------------------
 mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 73 insertions(+), 78 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23..d5bde1f71a97 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3326,6 +3326,8 @@ extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *buf, int len, unsigned int gup_flags);
 
 #ifdef CONFIG_BPF_SYSCALL
+extern int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			      void *buf, int len, unsigned int gup_flags);
 extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
 			      void *buf, int len, unsigned int gup_flags);
 #endif
diff --git a/mm/internal.h b/mm/internal.h
index 38b1165212c9..8264a346d18a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -25,6 +25,11 @@
 struct folio_batch;
 struct hstate;
 
+#ifdef CONFIG_BPF_SYSCALL
+int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
+			 void *buf, int len, unsigned int gup_flags);
+#endif
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


