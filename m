Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ED35D73E9B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 596506B00B0; Thu, 29 Jan 2026 16:53:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543F86B00B1; Thu, 29 Jan 2026 16:53:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4465C6B00B2; Thu, 29 Jan 2026 16:53:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 326906B00B0
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:53:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E91A0B904A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:53:52 +0000 (UTC)
X-FDA: 84386354304.12.1528DDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 975EDA0009
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:53:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPhRv87U;
	spf=pass (imf15.hostedemail.com: domain of andrii@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andrii@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769723631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y5b5kc7UYSmyW4+WPAPre+I7YSl4GAjE0FlW7f56DoU=;
	b=RnEWVvi8/jpahmhgE142pOlW5RK/MmdADZyuz7youeDUuna0D6aKi+uQTxmDKgRBwYuJL2
	tqxyDoSkjkqUVtLEdxM50i1PsWAs+C33DWg/w1DjZ2O22kgKyWgZ8vAhQXQlNL6zhrVYi6
	XQbjA1SQQKYiSW2NDaY0+m4VcQOJ2rw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VPhRv87U;
	spf=pass (imf15.hostedemail.com: domain of andrii@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=andrii@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769723631; a=rsa-sha256;
	cv=none;
	b=i2x6kuTWwmXa6ecZLS+dRncz//Dx+Ey6tHq4ynV0pviFe56c9ldUenmhdFjOLr/eLzZnuF
	3JbB6trRc+3Gyip6gT7VpI5jPvLtVtOrZFbcjGeEBo+gF1OR+dyRzJ1v87/kFGayncpRgd
	75EnsPTlsMAKJPmNwruPRN+J5x/Y55E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC3266001A;
	Thu, 29 Jan 2026 21:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A7CC4CEF7;
	Thu, 29 Jan 2026 21:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769723630;
	bh=wZhSeqTw09iSOExRe/tEpbezwNUiIYxVudwBu58Ttmc=;
	h=From:To:Cc:Subject:Date:From;
	b=VPhRv87Uq+eLWzzGCn7R7S9xIafqbprcJAOGGrYNTc4MMFFjqTl15AU93Lp0KrxZN
	 OJUaQJMhx7W9jM56IXD4CF6R5eqYw9wvfZU67Xp/R9HZSSxBJBOof9bm+Wp/0eoaco
	 BEzFIkMPWLG5kKBDdcV8zwTMoZXt8uW6XnsL8MMKzDGRMPizgGDQq9CIubf3VAmKHe
	 hjgB9cFIj93y7pFV88jVMlJSyKeIixHYpa4/hpnHsoueXtkpwYlthv8jCSLvqr2n3Z
	 zSpeoR9GED/0BwOGk4l/fOip8nt3gX9TKDOYnAB4O031QSIiyusG7s7rDzHk4uwLKg
	 yP70L5T9MhKZw==
From: Andrii Nakryiko <andrii@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org,
	surenb@google.com,
	shakeel.butt@linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Subject: [PATCH v2 mm-stable] procfs: avoid fetching build ID while holding VMA lock
Date: Thu, 29 Jan 2026 13:53:40 -0800
Message-ID: <20260129215340.3742283-1-andrii@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: ce37zgnf6ddy61tz1c45p3j4x748pe1j
X-Rspam-User: 
X-Rspamd-Queue-Id: 975EDA0009
X-HE-Tag: 1769723631-81879
X-HE-Meta: U2FsdGVkX1+lWcYNJfHOB9eVCUpG2Vg6zIAwjbsO5gR83YK22vRZh6tu1GsxET7D4CMRM3sIdKQ45Uzeji9Kx1HrufvpIg6vHkuuYe5hp0408kpskTrgCEsqyupGTD2Wuw1rNB2vxpBRbyQlsRKBa3kinfJqvc5gU6TXRCBIttAl0RfK5HtefFf8y9mjUcZcR35XfInNsEEK14D6ijIxxn7s/DiZtZOymkJSevBLTmn9YsnfjJOQEC+NC5UmPF7SM79GMY20rWcDVAyyv5RM+XKNDn2AXxczRUkAgI0QWDAJ10caotCo6Eg9aMEQFV+y1EBX9mm8VRbFwrWPBvcRTvzbw6LWT0M94Zg/staGh9LULVvnyQCBBa51hxLHWRogiVpgk1orJTzqhMtpd/4EqtUTo0WI4MBzVbM7ALwDIHf/G3RmbEDaHAn7PU28uG/swdP/bVZBOVUtBRt3weXyNqfY5xV/mkakRaw1tYiSd1OBR0fC+qlIRVyzPqpRoon8xFN+WLVeZj9WQz4OugsO9AhD4xkPqGFP7i7gW7OHnRYC2rNSQFatZtbW82pMxMhguW3NZSKuLdqdCHmUizQcr727hZXo2NTeVsgv47shklSCRKe7bJ7DsU3Z7YhJNXi7yWzjCxEGXbppb1GSFKIOs/3B7qhfatzybg4JKHmGP96eyVQi+bRDRhtohBUH9oNAHSbeGcYnQlM3JwE38A0lmTghC02HY9yS2qHoytKRh/Csw9ifTZEFkMCMEs9rATXmSju1/sYO2oyxJspspmHArXRkPBdTI3otzsQtPLxFGN2anuGyGMSRewwHqxlIk8O6Wfby7Fb3Iysz4VU1KnCRQJ1dM+PNEeumjO01cJOOengwo1hioDDodwgg0tnsmVD71G7xRDx87C9jgqek4GgQw+mN1qgIk7jutrn7JNG1IlfOaDKOJi8Z/ZNGQYnJtIS+eqETS2t9tYfse7eefK2
 IQS+arSg
 Rmqnqo1Tcse6g/2L4C/zKKCqs6mfc8vm1Uf9Yq11hOKgG1C/wfSb/7tEjPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix PROCMAP_QUERY to fetch optional build ID only after dropping mmap_lock or
per-VMA lock, whichever was used to lock VMA under question, to avoid deadlock
reported by syzbot:

 -> #1 (&mm->mmap_lock){++++}-{4:4}:
        __might_fault+0xed/0x170
        _copy_to_iter+0x118/0x1720
        copy_page_to_iter+0x12d/0x1e0
        filemap_read+0x720/0x10a0
        blkdev_read_iter+0x2b5/0x4e0
        vfs_read+0x7f4/0xae0
        ksys_read+0x12a/0x250
        do_syscall_64+0xcb/0xf80
        entry_SYSCALL_64_after_hwframe+0x77/0x7f

 -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
        __lock_acquire+0x1509/0x26d0
        lock_acquire+0x185/0x340
        down_read+0x98/0x490
        blkdev_read_iter+0x2a7/0x4e0
        __kernel_read+0x39a/0xa90
        freader_fetch+0x1d5/0xa80
        __build_id_parse.isra.0+0xea/0x6a0
        do_procmap_query+0xd75/0x1050
        procfs_procmap_ioctl+0x7a/0xb0
        __x64_sys_ioctl+0x18e/0x210
        do_syscall_64+0xcb/0xf80
        entry_SYSCALL_64_after_hwframe+0x77/0x7f

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   rlock(&mm->mmap_lock);
                                lock(&sb->s_type->i_mutex_key#8);
                                lock(&mm->mmap_lock);
   rlock(&sb->s_type->i_mutex_key#8);

  *** DEADLOCK ***

To make this safe, we need to grab file refcount while VMA is still locked, but
other than that everything is pretty straightforward. Internal build_id_parse()
API assumes VMA is passed, but it only needs the underlying file reference, so
just add another variant build_id_parse_file() that expects file passed
directly.

Fixes: ed5d583a88a9 ("fs/procfs: implement efficient VMA querying API for /proc/<pid>/maps")
Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Tested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 fs/proc/task_mmu.c      | 42 ++++++++++++++++++++++++++---------------
 include/linux/buildid.h |  3 +++
 lib/buildid.c           | 34 +++++++++++++++++++++++++--------
 3 files changed, 56 insertions(+), 23 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 480db575553e..dd3b5cf9f0b7 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -656,6 +656,7 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 	struct proc_maps_locking_ctx lock_ctx = { .mm = mm };
 	struct procmap_query karg;
 	struct vm_area_struct *vma;
+	struct file *vm_file = NULL;
 	const char *name = NULL;
 	char build_id_buf[BUILD_ID_SIZE_MAX], *name_buf = NULL;
 	__u64 usize;
@@ -727,21 +728,6 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 		karg.inode = 0;
 	}
 
-	if (karg.build_id_size) {
-		__u32 build_id_sz;
-
-		err = build_id_parse(vma, build_id_buf, &build_id_sz);
-		if (err) {
-			karg.build_id_size = 0;
-		} else {
-			if (karg.build_id_size < build_id_sz) {
-				err = -ENAMETOOLONG;
-				goto out;
-			}
-			karg.build_id_size = build_id_sz;
-		}
-	}
-
 	if (karg.vma_name_size) {
 		size_t name_buf_sz = min_t(size_t, PATH_MAX, karg.vma_name_size);
 		const struct path *path;
@@ -775,10 +761,34 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 		karg.vma_name_size = name_sz;
 	}
 
+	if (karg.build_id_size && vma->vm_file)
+		vm_file = get_file(vma->vm_file);
+
 	/* unlock vma or mmap_lock, and put mm_struct before copying data to user */
 	query_vma_teardown(&lock_ctx);
 	mmput(mm);
 
+	if (karg.build_id_size) {
+		__u32 build_id_sz;
+
+		if (vm_file)
+			err = build_id_parse_file(vm_file, build_id_buf, &build_id_sz);
+		else
+			err = -ENOENT;
+		if (err) {
+			karg.build_id_size = 0;
+		} else {
+			if (karg.build_id_size < build_id_sz) {
+				err = -ENAMETOOLONG;
+				goto out;
+			}
+			karg.build_id_size = build_id_sz;
+		}
+	}
+
+	if (vm_file)
+		fput(vm_file);
+
 	if (karg.vma_name_size && copy_to_user(u64_to_user_ptr(karg.vma_name_addr),
 					       name, karg.vma_name_size)) {
 		kfree(name_buf);
@@ -798,6 +808,8 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
 out:
 	query_vma_teardown(&lock_ctx);
 	mmput(mm);
+	if (vm_file)
+		fput(vm_file);
 	kfree(name_buf);
 	return err;
 }
diff --git a/include/linux/buildid.h b/include/linux/buildid.h
index 831c1b4b626c..7acc06b22fb7 100644
--- a/include/linux/buildid.h
+++ b/include/linux/buildid.h
@@ -7,7 +7,10 @@
 #define BUILD_ID_SIZE_MAX 20
 
 struct vm_area_struct;
+struct file;
+
 int build_id_parse(struct vm_area_struct *vma, unsigned char *build_id, __u32 *size);
+int build_id_parse_file(struct file *file, unsigned char *build_id, __u32 *size);
 int build_id_parse_nofault(struct vm_area_struct *vma, unsigned char *build_id, __u32 *size);
 int build_id_parse_buf(const void *buf, unsigned char *build_id, u32 buf_size);
 
diff --git a/lib/buildid.c b/lib/buildid.c
index 818331051afe..9fcbf139bd3a 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -279,7 +279,7 @@ static int get_build_id_64(struct freader *r, unsigned char *build_id, __u32 *si
 /* enough for Elf64_Ehdr, Elf64_Phdr, and all the smaller requests */
 #define MAX_FREADER_BUF_SZ 64
 
-static int __build_id_parse(struct vm_area_struct *vma, unsigned char *build_id,
+static int __build_id_parse(struct file *file, unsigned char *build_id,
 			    __u32 *size, bool may_fault)
 {
 	const Elf32_Ehdr *ehdr;
@@ -287,11 +287,7 @@ static int __build_id_parse(struct vm_area_struct *vma, unsigned char *build_id,
 	char buf[MAX_FREADER_BUF_SZ];
 	int ret;
 
-	/* only works for page backed storage  */
-	if (!vma->vm_file)
-		return -EINVAL;
-
-	freader_init_from_file(&r, buf, sizeof(buf), vma->vm_file, may_fault);
+	freader_init_from_file(&r, buf, sizeof(buf), file, may_fault);
 
 	/* fetch first 18 bytes of ELF header for checks */
 	ehdr = freader_fetch(&r, 0, offsetofend(Elf32_Ehdr, e_type));
@@ -332,7 +328,10 @@ static int __build_id_parse(struct vm_area_struct *vma, unsigned char *build_id,
  */
 int build_id_parse_nofault(struct vm_area_struct *vma, unsigned char *build_id, __u32 *size)
 {
-	return __build_id_parse(vma, build_id, size, false /* !may_fault */);
+	if (!vma->vm_file)
+		return -EINVAL;
+
+	return __build_id_parse(vma->vm_file, build_id, size, false /* !may_fault */);
 }
 
 /*
@@ -348,7 +347,26 @@ int build_id_parse_nofault(struct vm_area_struct *vma, unsigned char *build_id,
  */
 int build_id_parse(struct vm_area_struct *vma, unsigned char *build_id, __u32 *size)
 {
-	return __build_id_parse(vma, build_id, size, true /* may_fault */);
+	if (!vma->vm_file)
+		return -EINVAL;
+
+	return __build_id_parse(vma->vm_file, build_id, size, true /* may_fault */);
+}
+
+/**
+ * Parse build ID of ELF file
+ * @file:      file object
+ * @build_id: buffer to store build id, at least BUILD_ID_SIZE long
+ * @size:     returns actual build id size in case of success
+ *
+ * Assumes faultable context and can cause page faults to bring in file data
+ * into page cache.
+ *
+ * Return: 0 on success; negative error, otherwise
+ */
+int build_id_parse_file(struct file *file, unsigned char *build_id, __u32 *size)
+{
+	return __build_id_parse(file, build_id, size, true /* may_fault */);
 }
 
 /**
-- 
2.47.3


