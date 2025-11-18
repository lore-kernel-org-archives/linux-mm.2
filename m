Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A49CED63B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 13:25:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42EA36B00A3; Tue, 18 Nov 2025 08:25:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DFDF6B00A4; Tue, 18 Nov 2025 08:25:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F5186B00A5; Tue, 18 Nov 2025 08:25:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB996B00A3
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 08:25:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9516759664
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:25:40 +0000 (UTC)
X-FDA: 84123800040.17.892617D
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 93AC540011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 13:25:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jYeqB+CM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763472338; a=rsa-sha256;
	cv=none;
	b=Pw39haBBF82JPI/FXYZpsR6WXhWvDTqZVP8oncbgyL43UM2XxKv28d6F4ANFNCbHLW0vAv
	DBeIZ36Kf9x0YuSyrdFAMoXrN6dSCZvdKTBoMQyBYXBaPUs8LsaICrnUapcPmXAk4trspB
	HG3uiheQLzkuCRiN8yZ6mH3CcfJPdd4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jYeqB+CM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763472338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=D/KSGnmYHhpQtAQRF2DGYnHFC5JvS++vMYTx6SfB8k8=;
	b=wvHWLs35kCR4vQZ2ejmOTLX42FNacnJXCYUL+Hl5SuwKYQvkm2FpleuqaHklm9dUq0sDDO
	xgcknlcGEsVECAKY7RQDSK6/KqP0sThRINRWohthPguX+mIkd9T/Cg+vdC5PQMNenSckn/
	rjM9/wlSOOiz1X3LQuOoCQrPozNB+9w=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b735e278fa1so818486666b.0
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763472337; x=1764077137; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=D/KSGnmYHhpQtAQRF2DGYnHFC5JvS++vMYTx6SfB8k8=;
        b=jYeqB+CMNlmWGqmSAoSsv0RkFziJZxil25DjF8kHewdXK9sLtxDa1YSKSeGZiS3q5w
         oyjpuB4UbpglxHrX7tsq0xlEzEXwJT6dffYm//6TSw4Pdi+DtqLQNUkprI8EwrSvD7qd
         cVKlFfXTgLem8rXnvQa0nwXcdpMqVZNdYb3C1yBplOk7cSiPmqnN2l2T6u+qdrZjmNUP
         i0mf+50xtvYBFQ7yiGMn4jqsy1fqaqGZ+HjhpDsj7ClHLh6e35i1j0kG1DsKQQX1ETEf
         +aRkJ7NJE0GKe4cgod9t0FR52dfINQDFhFpPJk4xarIGWyXpecL96+uo+im9LmGOngTr
         3OZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763472337; x=1764077137;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/KSGnmYHhpQtAQRF2DGYnHFC5JvS++vMYTx6SfB8k8=;
        b=ByrTz9FMUbP+ucp0bqC+W/QgrJrB0qP/TGDcal2sXWpb2Gf4doEZL/9NZrtl+m+r11
         2MrscuyJT734du1c0aOQc26S+0ybSHZKGnw7mVlF+yjL7Os/gG29BywWK4OBdam7+H9g
         tS11b0Rtcl08IKC8GDW047Y7gzPTdBU4CJ0uKlFORd3MyEZ5v/X8fHw6j7vJFUtbR4rs
         /t0H4mwZq9Lm32dQtuH0QY38Og9gry4IgF+Huf5HojegiT44yENCt8yNdwkxLhEtZ81g
         pG6uL79IkeITp2UbOyI3bEMU+yCbCj3jnhcNas3kkOsys4wlWhIybbe1aPguB4shw5ei
         IG+g==
X-Forwarded-Encrypted: i=1; AJvYcCXJy7QSNUHTu4AknzkvDTJLzlveDM0inHNCxt0etJLbqYO/kkPJGQfXsOSU1aR3oxrWl/OFgcCp7w==@kvack.org
X-Gm-Message-State: AOJu0YxARyx170e4dIHqT8elxbZ5SbpGaLZLnLIVxqBQZzlO67IAXIb7
	lF+A1Qz5xJMteLNpYvLAaN2cRZ/FBlbCE8tVemrTmDg7I/NQF3nrPcRn
X-Gm-Gg: ASbGnctnrV09LK6wF96lER41GP3o967MdV68l3AzhwnOKT2OX+ZgxoYgg38EmHJ5YSZ
	i5NmfJybMqDN9kWa4v/lYhOQ4Q4iyilsUm7EhIRpF6hnjwik32kZjzoVv6yCkYCgysEK0YFnlEa
	cTyfK0r6DRJulIRRzaIm1YNN/GLpOmX5FcyPH280xRMIDDFql5W4LripbXV2Z1xAgLQSjHrcLm4
	+52kDMd2chRDs8/k+IBc/kDXNsLx/nUi1dlyHXoQyNEM6fcbNOqXJ40qR4sHfGgYRyYn4lYepVk
	BJ0GF44YKFgiVmEwSLXiXQ9TaG8am4FSU+iIh/ebgw9ADw6nwqGADDDCM5i0oVA3sbJkxrhRS9/
	f4m12h+ym7VHBo5tcDx94aPGBiMOUtiePMMosah/4+T0gLBvYYCrRLwLF4BKyJuaTpVq04GGfwR
	4rgg==
X-Google-Smtp-Source: AGHT+IG2x1j6ML0KGvAvBy+bKZskByZJ2z7ymHKf2lVL/7qF2hpWCGHi+QKBlWZtJZn20ow3Mbr2qg==
X-Received: by 2002:a17:907:989:b0:b73:5936:77fc with SMTP id a640c23a62f3a-b7367829d26mr1691732166b.13.1763472336638;
        Tue, 18 Nov 2025 05:25:36 -0800 (PST)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::a7b6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fd80a06sm1339517866b.38.2025.11.18.05.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Nov 2025 05:25:36 -0800 (PST)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <alban.crequy@gmail.com>,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	mfriese@microsoft.com
Subject: [PATCH] process_vm_readv/writev: add flags for pidfd and nowait
Date: Tue, 18 Nov 2025 14:23:48 +0100
Message-ID: <20251118132348.2415603-1-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 93AC540011
X-Stat-Signature: qs7bs4ne75swuzc4rxops4hhinwcf6en
X-HE-Tag: 1763472338-139925
X-HE-Meta: U2FsdGVkX18MCtaSVKTMAqdb1I7qIzcnesF84sOJOr9wDe1ph72tV/LxCjIdVd7G4EDlLly6xKvIzK0HoPdYdT7QoY8WDnCrj9/RPT8P6aGqCNWpOzfGh8bialRELdTqkwQLPCJgyQCFX0FwvYw+K8mpEIH1krmUakH8rCYTxzE+p/uHsCqDZREhQcub50IyJ+B3sUr/BSpN9tNmr8CD4rc20/lKQFLvbbJuEEUea3dds544jTm6AuuTy4rsfwIMkk6rD3bkLYC+b06UfSOdk9Vn999T3HCWP1nmLlvlGbKRi/ONfslXYWjqmJOMKy7wfIFG9J9wKJ0Z2h7YseMKXzJSjkqYDCOhM6LFl/FI2dv92VnFoiwxBC1TCDwdZBFlWHAu5rDGR7CmeTR+uCBN8VutQGXAfpLK0MBosVvfifvzpNd7EzFYmaSLkso4c/GHSKpGTKT17JkXh1Vaq4Pfxgy9g1ER0pLce6SmiHLxq1G/SbzY9ElF3glH6hkVJXoGmuxCgN6JJq7co4c3VBaBwcGSq0fqawFwo55iGiJw9JOAIrLQvvYzD31Ne9rf/j1+OuEc2BCBUnJoeQcEFzBpkNcG84HeNmIfRxfGgrXvAnZZO6eseP4Gy9troQXCJjdja6SxZLYQvniQuRm+wnvvAAIG0dNzz24aFIGoZelmT/BrWjuohuzgGqap1dm+d0xGIH/Akr16tqQvUu2bV7qytYoUp3XTfBrp1njfT6AfgVnp2khoOfR3noRlOzx2BXPCjBgYmOEK6E0p6i6gVzck9Se0Q039kfHB4d4FqWuLHm0VAF628Ifp5RAdwyKgStPAwz2aT3YQVJo7Dcf6l1MJ/t5nhtshwGaTpgEizdXD6ckzHZLohvWktu+MxW5147QqmRLe3gSDN2UOZkHApO54AWsHFh4r2uRGWoYhYeZU4Bn/ryezs7q8PjZ6fB4DC9qHqSv9WH6toqVb+/lIhic
 znZJO3eq
 f9J3M/bxjHTE8VIkj0mi/RqlNZrLq+a3HJeW7GN99/0UDoMVy0kX+7oX+mHCeQAqbgGlEoicwCy7oDqjL6ECEtm+WgUQ5ijdja59PKg7DlxoM81i00fdjH4OgBQprxH8bYoUi45rxAaQ1CJpOm3hIVYTFY+WWLUitK7zIb47o1bCSZVCkEv8FS+7IzAjb/brOo4zAjIVcVwvftWP6q6r3+srjDr/Q6ZKGy+L7pZxbU0L7eJEdyH8+Mz9fCCRneZzxPjZnAudMLSB5acHj9sJJl+afXFTJvrwh+VurKI/V0auBxbz8mXNZnAgI8R6r/3i5Jz6UYG26W48uKYKeWbIZnVkA5YEiyWiBSQCUQWWV5m2lQVhvbiDoy3R1FFay3QzEnBl3Z8P3J0FmG+J5cATrtg+WvTn+9VAopmxtczHj3hNcT3jG283OtlSfyLZlWRT8JwP1CXfX6WOkag57RBBEg7obfkz9Y2mMUQ9/g4XnFXMZ5SC4PJMkMVyZgTefYPbioew5DX79m6pZ8lckeWtLXdOTjP7FrUqN7JYhKZL7b6xDCuPVaKk/izH2kaCOjqAFjiyE+tCf1O6+rO0xVnwmTxrN0Z0X9XfLuvUXAKkI+pShwU1taXnMB72+ZzHiVA1YAy5fhLMxdESkGmXEJMfb0NkAZAQxoECkDyBEFDf4/xx2C+JT2bDRBXIkXjLy2dk4tQDz8hasOkl//rUYKIPY0NCnjOfzVMKWIid7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alban Crequy <albancrequy@microsoft.com>

- PROCESS_VM_PIDFD: refer to the remote process via PID file descriptor
  instead of PID. Such a file descriptor can be obtained with
  pidfd_open(2).

- PROCESS_VM_NOWAIT: do not block on IO if the memory access causes a
  page fault.

If a given flag is unsupported, the syscall returns the error EINVAL
without checking the buffers. This gives a way to userspace to detect
whether the current kernel supports a specific flag:

  process_vm_readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)
  -> EINVAL if the kernel does not support the flag PROCESS_VM_PIDFD
     (before this patch)
  -> EFAULT if the kernel supports the flag (after this patch)

Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
---
 MAINTAINERS                     |  1 +
 include/uapi/linux/process_vm.h |  9 +++++++++
 mm/process_vm_access.c          | 20 +++++++++++++++-----
 3 files changed, 25 insertions(+), 5 deletions(-)
 create mode 100644 include/uapi/linux/process_vm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e64b94e6b5a9..91b4647cf761 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16272,6 +16272,7 @@ F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/uapi/linux/process_vm.h
 F:	kernel/fork.c
 F:	mm/Kconfig
 F:	mm/debug.c
diff --git a/include/uapi/linux/process_vm.h b/include/uapi/linux/process_vm.h
new file mode 100644
index 000000000000..4168e09f3f4e
--- /dev/null
+++ b/include/uapi/linux/process_vm.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_PROCESS_VM_H
+#define _UAPI_LINUX_PROCESS_VM_H
+
+/* Flags for process_vm_readv/process_vm_writev */
+#define PROCESS_VM_PIDFD        (1UL << 0)
+#define PROCESS_VM_NOWAIT       (1UL << 1)
+
+#endif /* _UAPI_LINUX_PROCESS_VM_H */
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 656d3e88755b..b5eac870ef24 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -14,6 +14,7 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
+#include <linux/process_vm.h>
 
 /**
  * process_vm_rw_pages - read/write pages from task specified
@@ -68,6 +69,7 @@ static int process_vm_rw_pages(struct page **pages,
  * @mm: mm for task
  * @task: task to read/write from
  * @vm_write: 0 means copy from, 1 means copy to
+ * @pvm_flags: PROCESS_VM_* flags
  * Returns 0 on success or on failure error code
  */
 static int process_vm_rw_single_vec(unsigned long addr,
@@ -76,7 +78,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
 				    struct page **process_pages,
 				    struct mm_struct *mm,
 				    struct task_struct *task,
-				    int vm_write)
+				    int vm_write,
+				    unsigned int pvm_flags)
 {
 	unsigned long pa = addr & PAGE_MASK;
 	unsigned long start_offset = addr - pa;
@@ -91,6 +94,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
 
 	if (vm_write)
 		flags |= FOLL_WRITE;
+	if (pvm_flags & PROCESS_VM_NOWAIT)
+		flags |= FOLL_NOWAIT;
 
 	while (!rc && nr_pages && iov_iter_count(iter)) {
 		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
@@ -141,7 +146,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
  * @iter: where to copy to/from locally
  * @rvec: iovec array specifying where to copy to/from in the other process
  * @riovcnt: size of rvec array
- * @flags: currently unused
+ * @flags: process_vm_readv/writev flags
  * @vm_write: 0 if reading from other process, 1 if writing to other process
  *
  * Returns the number of bytes read/written or error code. May
@@ -163,6 +168,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	unsigned long nr_pages_iov;
 	ssize_t iov_len;
 	size_t total_len = iov_iter_count(iter);
+	unsigned int f_flags;
 
 	/*
 	 * Work out how many pages of struct pages we're going to need
@@ -194,7 +200,11 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	}
 
 	/* Get process information */
-	task = find_get_task_by_vpid(pid);
+	if (flags & PROCESS_VM_PIDFD)
+		task = pidfd_get_task(pid, &f_flags);
+	else
+		task = find_get_task_by_vpid(pid);
+
 	if (!task) {
 		rc = -ESRCH;
 		goto free_proc_pages;
@@ -215,7 +225,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	for (i = 0; i < riovcnt && iov_iter_count(iter) && !rc; i++)
 		rc = process_vm_rw_single_vec(
 			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,
-			iter, process_pages, mm, task, vm_write);
+			iter, process_pages, mm, task, vm_write, flags);
 
 	/* copied = space before - space after */
 	total_len -= iov_iter_count(iter);
@@ -266,7 +276,7 @@ static ssize_t process_vm_rw(pid_t pid,
 	ssize_t rc;
 	int dir = vm_write ? ITER_SOURCE : ITER_DEST;
 
-	if (flags != 0)
+	if (flags & ~(PROCESS_VM_NOWAIT | PROCESS_VM_PIDFD))
 		return -EINVAL;
 
 	/* Check iovecs */
-- 
2.45.0


