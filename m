Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B26BB10F9945
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 14:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21B8A6B008A; Wed,  8 Apr 2026 10:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F35D6B008C; Wed,  8 Apr 2026 10:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1090C6B0092; Wed,  8 Apr 2026 10:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01B5D6B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:55:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C1AA1A01AD
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:55:11 +0000 (UTC)
X-FDA: 84635686422.30.605FD05
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6A17CA0019
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:55:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O3sstVkB;
	spf=pass (imf25.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775660109;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wgIIDUfJ0o70u9l3Zid2L+X0IsBnuKW+IYefvDTKd0=;
	b=Wl+4TmVJdqlq4ZAutEbfMAf9+QjpWtg/0Upi5nQYtwPcacGTDA6stO9y3Teor6h9U46Mxr
	7gydR/xIzmtN9Eif880RBU/lomeo43/nsJdi9o0gr8qzBIOQ2rO1Z2TT4Vc2JKwVBKrAc6
	uDAbm7e5CtdFneaXHw48lgDbvlI5cfk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O3sstVkB;
	spf=pass (imf25.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775660109; a=rsa-sha256;
	cv=none;
	b=Ylgz6lFn5h1fpB+S3JgU+JUsdy0In3yg3LByCcts3zJ0GnR6CEtyX2jhrmYBCwaDVvUgPG
	f2GJhc0Vsr7EJ8sReY5Obv4xHrCYxNMx+6nhuQJIgKZo2jiHTts3TPLMgYjio2odPOVOv3
	TuBiKh6fFcSlBYdRNQWYmG4xYhyOvJM=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488ab2db91aso52254025e9.3
        for <linux-mm@kvack.org>; Wed, 08 Apr 2026 07:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775660108; x=1776264908; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3wgIIDUfJ0o70u9l3Zid2L+X0IsBnuKW+IYefvDTKd0=;
        b=O3sstVkB+hD5rpsOokVUp8BWlObKdJlANTm/LtBAoYdYZkToU+LmOjLxzEYUxHHNf2
         RZDfjUxWTpLeAql6Uam2WnWghW8HaQWo/zHufo04NbADcfcNSRErojUQEW274sOV2fn/
         VcjE8UUsjkjMe2+WLUokcg7hPFSMvMFhKXVzvKUZKm6MvJBpqj4YHlvnOTn+v//zCL5x
         Xe0sF2B9uhXIbMXArXm/VvB+kDNqlGy10h93XwxHeN3Fd2yj7Wvxwy5LFvOpbfwREL9J
         q8Z99f2KffSczTavWr4cj/aXrB+jjKnEpUmMJh2kA61m9j1/v7ibxAg8pPb/19BD1aVp
         mc6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775660108; x=1776264908;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3wgIIDUfJ0o70u9l3Zid2L+X0IsBnuKW+IYefvDTKd0=;
        b=jfOEuNBr6GMrFe6yZ+yMJvbbnCa4Ppi4aJXe0me9DNUchViHKmcJ1t/20kE1xwH3YD
         erVX/OGn81tYFoAx+v/Sp8jazchAU0LctdSz9Q8pCy+KKg4/8duMuqwQQe9ADG6g+7P0
         ZPiTNSnF8tH/9YQJnJnK8hDGfaLWaNG4M8Pv00hl2WeJHzWB0mKITrRiwFG+AU332Vhj
         LWeLIKxTS732Xn3U4RafuarGjYRzVL8X7ADKw9VMPRo9X4MODSulBp7QAy07xlehTIHS
         ZirorCzUhW8CxZ1wUYN7GFXrdlPkcjzCuTY+ra1plUuQ6BLp42uv4OAWywq+HylwJhLq
         GNhg==
X-Forwarded-Encrypted: i=1; AJvYcCVBF7G+utmxEx+jMTz+F04UzX2eyfZyK7xiZ9JN4c9o/SkkB2EcljbkDcgPiXWe8iv5YvUKOEJJvA==@kvack.org
X-Gm-Message-State: AOJu0Yw+rZXcoTrgFwckls+w1vfHLtZvcQmmAk8WhYku1XElA7+eDsmr
	AcgPZhO1+f/WIkHOeKludtc7S1wzrvm1/9Sr+Yt/BiaQizRwoqhCewU9
X-Gm-Gg: AeBDieuWVC5NhqphVa5rWUB1BfW9ybKCUZJ2p4OtO7dvnGb9cvPfA+YWJZpUl9PSLRj
	KBO+DS9VEb+eNa/rjPTFLXUnjOzr536PLqIy0rvBEQyY5i8VXCGAJKxR7razW0lLzeN9S45H/IN
	7Zw00/Nf1K4n3lj2+oFNd6cri4+XZ69u+CeAuzkykEsSVG8G9shExhShkbT1Qk8RdRaRXzEYDuT
	c56ggOSw2gSAiaimECKpnTyo8jSV7UiWUgG3Y8cYLAK+MNMFbq3uHHQLc5n4ZTuSTs3ztA396uw
	3K9XmdFVzLYJ+Fb7XswmB08KW+CRpaJvDtrGzETfwlxOKePXW2D82+927sNYEcwpH5r0PCPLIGq
	0xHqSThKcb4Fr7jVm9hn3ILy+mJK1zZJqyrNhBW5d72yloB91iHblTY8TiGcxfu8wXUqDvnpeOp
	6bsCXrbKv/cFdBoUMDdngkx92E
X-Received: by 2002:a05:6000:40cc:b0:43c:ef4f:79cd with SMTP id ffacd0b85a97d-43d292e70e0mr31995209f8f.48.1775660107660;
        Wed, 08 Apr 2026 07:55:07 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::3006])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d1e4f5294sm55762103f8f.35.2026.04.08.07.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 07:55:07 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <alban.crequy@gmail.com>,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: [PATCH v2 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Wed,  8 Apr 2026 16:54:35 +0200
Message-ID: <20260408145436.843538-2-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260408145436.843538-1-alban.crequy@gmail.com>
References: <20260408145436.843538-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A17CA0019
X-Stat-Signature: 4c9fc79h87ipz54rxrb5bjd617uebdbk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775660109-354474
X-HE-Meta: U2FsdGVkX1/57osHYzLRYQw2F614N8GFOAdKjwQkpudMxRs+yUdqcTp3bkisgINiS9rxlZk9s8JmrWst1ISo3pZDRwuTF1JjbZO/ha1mqHL/fcsYoBvWh1NRVDd+C1bfBuRhdIsUYtFyV7d6ElHbhtuLpEXJggeA1AADZPTpHu4I5on4+k7s65PN29JYxFpLuwmIaBRPYLskZOOK1ThymGwKA55ywbiHxipvsYXvh6HxauVR1UB8AShei59EQFwUxkYp1L1d3aFW9kH4oN9fhWlZ8mP4kepKy4sRXB2MrVa4tduVIeVP17Q9o4f2DHpBj/CQJh2oBbDDnceGZ+5ZEXJwTkYkdndZlbBe/0FPD0vCCXanpn3WUYwH4mrLCgdr5w2c8QoMaToDqKAvxlKZTkf5pZtCTEKzcLSnj56HjEC80LJD8O17Dz11wBcnidBXHKPecOfa/mvbJpPqt5TJV3P3CukyaFgq36Tqqn6vSR/X8h65D7e5yx5mQBL3bK3vmPN4WFigeVBilEqf1vMqIirG+pFsJCr2sNaAijtts7QTDD3Qnw/B+rcnfs/sypYsUt7DlyVGJB+PePUGK2wsnFKbSMPyxeC7f+NxO+MP9rxtavGathzUsXCluROMAl6j3mlZP6LzoyTWKvY3ZhAVVkQ8DrerdmEud8Q65iwrOXlc4SE5N7/cz/nIvXG37GwkvBMxW4zCF3BsI6YeDLGJdDhgIdDb0NMBky8WjBoB4ANvNSTYz6cjnoFgxa6YEBJ20AuSSq/weTALQhMfZJo06l0ARWkrzStqcY0wn68/hFTRcfqKa+KPTkornuh4plH7CKQytDQotYpv50+JTX/gCmR3BLaaMLIg19JOC05LcjNqjCulR7flGfwC6okt1q2BXgF/vUyF0TAYp8AuY2OQ1616X6D9PhFduklM2bU+5C1H3SG5Hxj5fXeXGBdG+PyNGc3u6Y442qlxFvHvrNI
 0/Z//soY
 3XQ8NXBPx1+UAHbfcdtlCed/eBrN0l5zZe0DiRFiY80PzUB/EVSVcSrmhCVGaAy/jwhQE6D9NqH4WHTgWsc27DXO2o+ochaEegNWN22qqpdqsUjjreZxxZv/uCELu7TAYCAU1eHDHvgNL1CV2CX+CqQOovJLSdktD7Kv+sUTx1vTKsV6oz9xsLDLxeJ4bq4xOVGfIFG2RZAbcQ9c1oYKJwKMMZSpZwr7Ag6tzCF/PrYuHK+uJyWHi10K8O3XVwCH45z9+Lpvz8IA2nH6zZ6VEsTDu3YgSqa2iYyPfEcYyoohemoIE7qvM8Y1PxXX3mIIvK6Bsj8H0xuc0gsiCIA6SxNWEqgmMTzSDev1qOGv0b/3b4RQGSPelp0ngrqAev3a/kSnZtSKcvk91fS4VgYzl7qkYWA7ewbRNtIrC/BwTytO7qK8XT2UgRsY7cYtjRkKpCupyNJT9fqsoapHGnepe8NgVRAE/sKJ2H3qDYmMyRqHnnA5mQJpcYeAofZqu7c0riA/9l6VkZD9ON/8m1oMRmg4R7RDOH3TyqiLiN6hy8umcisFlQn4okqaYJ/cbuAx79V7UUcxtamBuZa0xzByPcKWpJcE3KK2OteZx9LZ3ExIFFhE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alban Crequy <albancrequy@microsoft.com>

There are two categories of users for process_vm_readv:

1. Debuggers like GDB or strace.

   When a debugger attempts to read the target memory and triggers a
   page fault, the page fault needs to be resolved so that the debugger
   can accurately interpret the memory. A debugger is typically attached
   to a single process.

2. Profilers like OpenTelemetry eBPF Profiler.

   The profiler uses a perf event to get stack traces from all
   processes at 20Hz (20 stack traces to resolve per second). For
   interpreted languages (Ruby, Python, etc.), the profiler uses
   process_vm_readv to get the correct symbols. In this case,
   performance is the most important. It is fine if some stack traces
   cannot be resolved as long as it is not statistically significant.

The current behaviour of process_vm_readv is to resolve page faults in
the target VM. This is as desired for debuggers, but unwelcome for
profilers because the page fault resolution could take a lot of time
depending on the backing filesystem. Additionally, since profilers
monitor all processes, we don't want a slow page fault resolution for
one target process slowing down the monitoring for all other target
processes.

This patch adds the flag PROCESS_VM_NOWAIT, so the caller can choose to
not block on IO if the memory access causes a page fault.

Additionally, this patch adds the flag PROCESS_VM_PIDFD to refer to the
remote process via PID file descriptor instead of PID. Such a file
descriptor can be obtained with pidfd_open(2). This is useful to avoid
the pid number being reused. It is unlikely to happen for debuggers
because they can monitor the target process termination in other ways
(ptrace), but can be helpful in some profiling scenarios.

If a given flag is unsupported, the syscall returns the error EINVAL
without checking the buffers. This gives a way to userspace to detect
whether the current kernel supports a specific flag:

  process_vm_readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)
  -> EINVAL if the kernel does not support the flag PROCESS_VM_PIDFD
     (before this patch)
  -> EFAULT if the kernel supports the flag (after this patch)

Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
---
v2:
- Expand commit message with use-case motivation (David Hildenbrand)
- Use unsigned long consistently for pvm_flags parameter (David Hildenbrand)
- Add PROCESS_VM_SUPPORTED_FLAGS kernel-internal define (David Hildenbrand)
- Keep (1UL << N) in UAPI header: BIT() is defined in vdso/bits.h
  which is not exported to userspace, so UAPI headers using BIT() would
  break when included from userspace programs (David Hildenbrand)

 MAINTAINERS                     |  1 +
 include/uapi/linux/process_vm.h |  9 +++++++++
 mm/process_vm_access.c          | 24 ++++++++++++++++++------
 3 files changed, 28 insertions(+), 6 deletions(-)
 create mode 100644 include/uapi/linux/process_vm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index c3fe46d7c4bc..f7168c5d7acc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16678,6 +16678,7 @@ F:	include/linux/pgtable.h
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
index 656d3e88755b..c6a25e9993e1 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -14,6 +14,9 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
+#include <linux/process_vm.h>
+
+#define PROCESS_VM_SUPPORTED_FLAGS (PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT)
 
 /**
  * process_vm_rw_pages - read/write pages from task specified
@@ -68,6 +71,7 @@ static int process_vm_rw_pages(struct page **pages,
  * @mm: mm for task
  * @task: task to read/write from
  * @vm_write: 0 means copy from, 1 means copy to
+ * @pvm_flags: PROCESS_VM_* flags
  * Returns 0 on success or on failure error code
  */
 static int process_vm_rw_single_vec(unsigned long addr,
@@ -76,7 +80,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
 				    struct page **process_pages,
 				    struct mm_struct *mm,
 				    struct task_struct *task,
-				    int vm_write)
+				    int vm_write,
+				    unsigned long pvm_flags)
 {
 	unsigned long pa = addr & PAGE_MASK;
 	unsigned long start_offset = addr - pa;
@@ -91,6 +96,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
 
 	if (vm_write)
 		flags |= FOLL_WRITE;
+	if (pvm_flags & PROCESS_VM_NOWAIT)
+		flags |= FOLL_NOWAIT;
 
 	while (!rc && nr_pages && iov_iter_count(iter)) {
 		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
@@ -141,7 +148,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
  * @iter: where to copy to/from locally
  * @rvec: iovec array specifying where to copy to/from in the other process
  * @riovcnt: size of rvec array
- * @flags: currently unused
+ * @flags: process_vm_readv/writev flags
  * @vm_write: 0 if reading from other process, 1 if writing to other process
  *
  * Returns the number of bytes read/written or error code. May
@@ -163,6 +170,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	unsigned long nr_pages_iov;
 	ssize_t iov_len;
 	size_t total_len = iov_iter_count(iter);
+	unsigned int f_flags;
 
 	/*
 	 * Work out how many pages of struct pages we're going to need
@@ -194,7 +202,11 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
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
@@ -215,7 +227,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	for (i = 0; i < riovcnt && iov_iter_count(iter) && !rc; i++)
 		rc = process_vm_rw_single_vec(
 			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,
-			iter, process_pages, mm, task, vm_write);
+			iter, process_pages, mm, task, vm_write, flags);
 
 	/* copied = space before - space after */
 	total_len -= iov_iter_count(iter);
@@ -244,7 +256,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
  * @liovcnt: size of lvec array
  * @rvec: iovec array specifying where to copy to/from in the other process
  * @riovcnt: size of rvec array
- * @flags: currently unused
+ * @flags: process_vm_readv/writev flags
  * @vm_write: 0 if reading from other process, 1 if writing to other process
  *
  * Returns the number of bytes read/written or error code. May
@@ -266,7 +278,7 @@ static ssize_t process_vm_rw(pid_t pid,
 	ssize_t rc;
 	int dir = vm_write ? ITER_SOURCE : ITER_DEST;
 
-	if (flags != 0)
+	if (flags & ~PROCESS_VM_SUPPORTED_FLAGS)
 		return -EINVAL;
 
 	/* Check iovecs */
-- 
2.45.0


