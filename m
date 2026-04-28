Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63C89FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 12:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD2D96B0093; Tue, 28 Apr 2026 08:29:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83316B0095; Tue, 28 Apr 2026 08:29:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B723D6B0096; Tue, 28 Apr 2026 08:29:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A00496B0093
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:29:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5DD1485E28
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:29:19 +0000 (UTC)
X-FDA: 84707894838.02.29F0F36
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5BC574000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:29:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=euIb0Ehj;
	spf=pass (imf07.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777379357;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxy6ZGKNTBMlQ919OQUf8LPjYtJBrijDPBcvlSgOSGs=;
	b=Z21EOhLwgAUqNyFPgUK+ceuVf5APnMw+ZoEOwxKNXG7WSUT1gCH1B1hV2pvbotUONpbuj5
	qHfNER8tGUDKj9xtEHaCoY92s2byusJpYdSFMTZnviYyM2I/pbzd5xrgyBFKJiZeq+ZB5a
	8LePdhXU00/LpHjhP3gtiwSYH5HTwGQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=euIb0Ehj;
	spf=pass (imf07.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777379357; a=rsa-sha256;
	cv=none;
	b=g4PJrKiHEY57SOCweFInUS0+tfTJ8xQFISBojVd4yJd4tXVwyXNVjXU65VZ/rdjCPIVTcR
	QeDTbpji80gQ7SERA/rsgyXfs8EOE7WHOML/F7uIF7qiKkP6XWviR6jcjvP0gpYTwruZcM
	1iyy+6k4BNRmD8HD+JzoA6T7f43eo9o=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-48374014a77so146798095e9.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 05:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777379356; x=1777984156; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxy6ZGKNTBMlQ919OQUf8LPjYtJBrijDPBcvlSgOSGs=;
        b=euIb0EhjhKtBqED28D7463kyKMpilWEtFEypnq47VEsKDPaILZSKP6fJ1NtGlhHTgB
         cnVr+OuupEjXzzpLTJ1du7hYdX2ojcs6CvS2dfZxLIC4W+vQCANanzs4qEl6PKFOzZr5
         NgzYoqrnsBd5nENJv2MoDxczHsPox3NDyLXn8hwG/9kw9hicu/PPlnf+AL9tcSwXtR0a
         HeYAFLuzKcBPYOrF/Qu4JSmBTouYnnQKSlGz95jUcj87jhpqzoKUNklHFGF8uyQVZsvd
         yAcI2hN5e3JxsSMHEpDFrkiVkzLIClkV1orpfPcdHggpa/ubet7f5Zga/qryABjRwPrZ
         CVLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777379356; x=1777984156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxy6ZGKNTBMlQ919OQUf8LPjYtJBrijDPBcvlSgOSGs=;
        b=LTcNYQLsKykA2DnPevd125HYFfKOrEYm0zhB+kHejLjq2FG5IO1juY44skttXdn0fV
         Em+6R6ZEkJE+sJx4T0hPb88DB4i5qpzxv065lbvQ24pJ3uXS2bEMjWgtwRzI9wVp82v+
         WeruAFgdbyCqnVfDafnNAJXjq+U0E4RpP39pM7cm1PwqzrKMI7yfyvwxQ4fmBAGS8G75
         5h75aef75TfLa307A0AbC9rqWNnKyvVT/ULWtdU6f3mrQdJwZTzyqgptMyaYj/OfUPjD
         K6HcyxwvUvJl10O55lJI9BWR/mtlUXmKN8QccjHIemjYue69L6vEODlbeus20lf6Z1VP
         J2tg==
X-Forwarded-Encrypted: i=1; AFNElJ+dexZ6Gof0hdueyE4cLyvca5LcyPWL6Mhudrh/RcuxwKScs7kZOJLBaxtlik+AuOIJSA9N74exzQ==@kvack.org
X-Gm-Message-State: AOJu0YxCGZmyn0BBu4Rg9H4iN88uuikT3LFhbGxlotuS91iEFHfgBKw5
	Ezt16ZSXs+JMr+R1AbakelSZ7Jm5f8wknOu6Xkir3vWbpTlWY19e2Dmb
X-Gm-Gg: AeBDievl1cJmQ1VB/E/AUJEzQa1x8+bSjX+Pa/f3b3J7oEXjKe6zuGTLKP3bIMYH7+v
	c6uPLNc2PNw77Mjx/lwVZ0T43+IGpKzRSaognfEGH3S/qNcOZSlj8iRbahfUSo7OAXri2jyHaK8
	o2KF3pbWbhIsKiY4hEwkJsZnCh7GC2g/Q3z1fxHz0lfH8M6BdGg9tZMj1MlfXmY/cRlKqPOm0Ha
	Or9N3qcptXFX/aXfUKvYSM7NqVQW1XWmZv8mTBMs+UXbgWxMAhCHkEKBt2vDlH0iJtXO/l41QNT
	8bHo4SrZJLuUyPoqD2O//jPJU131c34gG5Gx2Z+rLQKQiw2vJzwGojgelkYFhP7pyIzKqzJb096
	fw3fwyqTYTbTxsT3y+swmTF3W0GgAZVFBQA7a5vTwBX1kit9GJCPaU6qgZAwwDmMRqtsgfaIaO4
	GvkGhkxVSmzv8GHzatUhlOpukvvpw6r1AJmmErst6FHeraGMccKKdtnzuwgnD0OqHfQacpVGuaO
	A==
X-Received: by 2002:a05:600c:1e8b:b0:489:1ff1:74d3 with SMTP id 5b1f17b1804b1-48a77b146e0mr45595125e9.20.1777379355653;
        Tue, 28 Apr 2026 05:29:15 -0700 (PDT)
Received: from localhost.localdomain (90-181-198-146.rco.o2.cz. [90.181.198.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a77af1b86sm47479045e9.5.2026.04.28.05.29.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 05:29:15 -0700 (PDT)
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
	shuah@kernel.org,
	Usama Arif <usama.arif@linux.dev>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v3 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Tue, 28 Apr 2026 14:28:25 +0200
Message-ID: <20260428122826.339550-2-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260428122826.339550-1-alban.crequy@gmail.com>
References: <20260428122826.339550-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BC574000D
X-Stat-Signature: si81359s6jx39ddsau3so58t3znzqzxi
X-HE-Tag: 1777379357-776536
X-HE-Meta: U2FsdGVkX19uRozXoPCISXPV/RrXQwyw+3LMSprTLObS/v7jTcNwoqlqG3/SDxOWhfIuBadX0ywWTIsbeOMOkf30RViJdsssyVjROru+pMFqHkx1OCmpFp5HFkO3IeoFRnqAqkQZnWJIYSwD7iqYqCHATv83Jdjp99/bf5veES05xtr1LNrxaJWzCpJc3XxxbsRbN+EHhBwU3raFzwamR8zX+SHOEZHdNq7eP1QOUQtXj6snjtkrg4QvoBxjtoGFB6w5s0bqsCupkarMHDQHPDm7q4c1j3VI5lclYjIcL0+lXaR4jVlHaZhGu4RCsTYeSuWNQpo4mTnxS2P0wx3np5nSFr0ljXvpUoFHAT65zqwTRvxrCkD635djQKRXhq7L5FzeR0f9sZlSJuNa2Zy4nmIcbwOxfny3rwARTQ1IGvf+HHLefBX+3+rdp3CxD+Pl8uPfEBumoJxaGOt8W6wZ59fb1lbOsaWFNpjb9llTXKNHyhpwkFjBrc8CX31jR3IcsMLs6DzxRQKWMHq2y0ucvc/xnNTObluDfDz2PLSl2xJ5frNgK/KbhSbG3xC++RxYiLfP+qPNFXzTxT5D0woxv8CNes+KUp4VOFck82J/Mr5Nfn3z+NIvK3fwNZHzftXeDofSE2H9eXs27kG4bEQHX7f8PCHN6UQh4/fcpvdLJNqiyKURfb+uHLy6BBYZysFNmZxQHQOMvCmn0kx396IAo+eRx7sVVqrosyRdAVvLDhPSu8TXo5JWdFsUWhEbU2eHoTX7NVMH59bKvuQdHVLXtymESkLJWftfU27Y/wSRxin9dN62nutTZp1qsFmmnD8GkF5ve+krJe55qVS24YxpNGgQrkQ5Wo5EBC/dsWc5dKJ8lJV0yGLYovoH8N75JI1qJ7RkmLN9SkMtE7avINdDJVWp2fY7msWdD+UziP7ZLuiGxhz0N2bhSsLiqy2HlWc1v2F02EZdcPgI+SkUWH6
 nH3ZxtEm
 d9IjcXW7MX1K8Jb/aTiKP+Z68j4LN6Bzpnf4hfaYMtmqMdhOr8qIUPowth8XyNTh79faZViVXw5P91gWAsIv1sbrXgKgRvaFxs98FtxiLKzgVCZMFnGDSfJa7cnKpak9INUeaRCYnp5muhdqumHGoTMwOT3pKVDRqsExgm7YaI0nSmnFtZ79dQ4M1CKlyLdZl4QnDkOaEPvBmwCFccTjs8uH+5b8Zkz8j83o8U2QTyAV2n6U4xQVHqmfi6FHgCpYFNUj17trcm/gbj9fsNACqni43GuaAdiXMkjOVvpO4vC1TlrZmCB/8LB0LEiskJchT83QxVbei2YAlTtrvhJMFvgIy494qA24KwouXjVHVkPU2cbP6hTNkNkmC6K3taHKdxz3APKv2xkAmKFZ1Up+VGSeGNeghnNadP0FwPeZxJLIOpZyz3AcOX4JYmTDCA9oDocjxL8AwTAxcG51Y+5hvOoenWBTI09FVXP6c+ZkjczJSljNFv2c1lMhqkLLvpPqmSXy1yneAFAK6HC8P316fr16t6b6XPwtbPgCoL0WIzZPkioHyOWLegbbb4J4OY5thtnUu6Kp2Fm3+9UaLgEonX15PqicQGNzQuNCRE5+oc25myWf+JdQNyytlQUdvM8QGS+ybPlA3tUpt03Mh5WcGMVyxSA==
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
v3:
- Fix ERR_PTR handling for pidfd_get_task(): use IS_ERR()/PTR_ERR()
  for the pidfd path, matching process_madvise() (Usama Arif, Sashiko)

v2:
- Expand commit message with use-case motivation (David Hildenbrand)
- Use unsigned long consistently for pvm_flags parameter (David Hildenbrand)
- Add PROCESS_VM_SUPPORTED_FLAGS kernel-internal define (David Hildenbrand)
- Keep (1UL << N) in UAPI header: BIT() is defined in vdso/bits.h
  which is not exported to userspace, so UAPI headers using BIT() would
  break when included from userspace programs (David Hildenbrand)

 MAINTAINERS                     |  1 +
 include/uapi/linux/process_vm.h |  9 +++++++++
 mm/process_vm_access.c          | 34 ++++++++++++++++++++++++---------
 3 files changed, 35 insertions(+), 9 deletions(-)
 create mode 100644 include/uapi/linux/process_vm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 2fb1c75afd16..0f6ce21d6235 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16786,6 +16786,7 @@ F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
 F:	fs/proc/meminfo.c
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
index 656d3e88755b..dacef50be0be 100644
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
@@ -194,10 +202,18 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	}
 
 	/* Get process information */
-	task = find_get_task_by_vpid(pid);
-	if (!task) {
-		rc = -ESRCH;
-		goto free_proc_pages;
+	if (flags & PROCESS_VM_PIDFD) {
+		task = pidfd_get_task(pid, &f_flags);
+		if (IS_ERR(task)) {
+			rc = PTR_ERR(task);
+			goto free_proc_pages;
+		}
+	} else {
+		task = find_get_task_by_vpid(pid);
+		if (!task) {
+			rc = -ESRCH;
+			goto free_proc_pages;
+		}
 	}
 
 	mm = mm_access(task, PTRACE_MODE_ATTACH_REALCREDS);
@@ -215,7 +231,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
 	for (i = 0; i < riovcnt && iov_iter_count(iter) && !rc; i++)
 		rc = process_vm_rw_single_vec(
 			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,
-			iter, process_pages, mm, task, vm_write);
+			iter, process_pages, mm, task, vm_write, flags);
 
 	/* copied = space before - space after */
 	total_len -= iov_iter_count(iter);
@@ -244,7 +260,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
  * @liovcnt: size of lvec array
  * @rvec: iovec array specifying where to copy to/from in the other process
  * @riovcnt: size of rvec array
- * @flags: currently unused
+ * @flags: process_vm_readv/writev flags
  * @vm_write: 0 if reading from other process, 1 if writing to other process
  *
  * Returns the number of bytes read/written or error code. May
@@ -266,7 +282,7 @@ static ssize_t process_vm_rw(pid_t pid,
 	ssize_t rc;
 	int dir = vm_write ? ITER_SOURCE : ITER_DEST;
 
-	if (flags != 0)
+	if (flags & ~PROCESS_VM_SUPPORTED_FLAGS)
 		return -EINVAL;
 
 	/* Check iovecs */
-- 
2.45.0


