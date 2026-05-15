Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1026CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 14:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667ED6B008C; Fri, 15 May 2026 10:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63EB26B0093; Fri, 15 May 2026 10:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5558B6B0095; Fri, 15 May 2026 10:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 44F6B6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 10:34:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F421186838
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:34:25 +0000 (UTC)
X-FDA: 84769899690.03.7ED333E
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 02417140010
	for <linux-mm@kvack.org>; Fri, 15 May 2026 14:34:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N53gJWfC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778855664; a=rsa-sha256;
	cv=none;
	b=TCMmYEZb3xkOv+Yc0fIDltIj5RaoJ1I2VHZ4ZKPZVF/IDsUANKYvTC7/wpIR6Stpt6smh0
	2xYlx2I4mfx1XsQdNmUcC+z+8OBPbH1IB3CYZ3/Chdonnxxb/3IiKkAoCrF2WjFapA/hoc
	2/3VxAjdaoRN9XC40+9sH8gb/iAzqSQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N53gJWfC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778855664;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aKqdeW9L9Zwr/B5n6kGucr9IN/pQ5rUwIlXKTZlA0g=;
	b=1gLA8/8M0G/KhYNG+b3H8LVPOOs7XiKvNT2E3v3/B6hh2HrM/rVLJN51fuHbCF0QkhUm5D
	SJSJemYg0b+KLxuR/0OnAqlh0fbC5sSAc0V+wi4qo3/WkZEQq5KUfwcYP98nbWui7wV9+i
	JbkV9KVeX0ASGdUONX4kk70X6QPGo/U=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-452169ae568so7154747f8f.3
        for <linux-mm@kvack.org>; Fri, 15 May 2026 07:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778855662; x=1779460462; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3aKqdeW9L9Zwr/B5n6kGucr9IN/pQ5rUwIlXKTZlA0g=;
        b=N53gJWfCOxu6EAS5HIzCjpiZtIFvJtmoZFv9fVcbuGLjnsYkDZoUa9AkSwSROlsUap
         XfNoQYw8aPovjtFQw+qJE1t0LgC1ZbbdID9DIacazcqdU03dCnjYP3ei2cqlMxWSwEb9
         dJ9bZHamqH41LJTVwip9qdi3DTsl94RDFP7BDV1vZYk3NkkSu/heHxwlJ6ZKTF7OWS+8
         EMdKyaJxaiL1sqCTVu402CSqZmq9U35wvu++qWoTwKaE97KC34Kb3WkRO8GCgQ0GmGbP
         ragJ8MnZlkU0eEtVPwydMPyVmd+lGzBWrZ6N5WdJ3rbjDgwWfkZfkhGNcAwXyqJrUz+C
         Nn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778855662; x=1779460462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3aKqdeW9L9Zwr/B5n6kGucr9IN/pQ5rUwIlXKTZlA0g=;
        b=l3o6X2SQQzG7svX/lneWyxatCH3TZ8g2ZFICO7KmPkrdJrRFNKK/1MVhOjWrpU1K51
         Trwv5vMsfLPFhL9BsdYCC/ohZXNkMPllyYLpKb6ggVV1HacCd2Gi8pbTf2cJbIrDlnPr
         IEhN3fnKuuXcjD4yGYCuDPujBI3uy3fs29SX8FMzmncGwaUqZ4QcOEQfAEvZNnDy/ido
         mXPB9yIgR3tEGoR4q7CmcjE4UBM/jt7GkAxkIR3WddkXqqs8X2Is855V/KhtRZWep1HH
         Lz+nOu+PqbLz/uft9/3EsCM8dtn92TqBegH6dkyQ8VGwZ5W2U/jqfoM4wz/JjVpy93Oy
         0e5g==
X-Forwarded-Encrypted: i=1; AFNElJ/iMBDK3ThH7lhebegXuISDzKWB6Ix20EHk1WdLuZ3gBix20zAlUz/TNGKhsh7h32VLYfEaWSRTCw==@kvack.org
X-Gm-Message-State: AOJu0Yw24YEcBALz9M2Yw/lLOf08dAdTgcGl48bu6aQhpM8MKt4Bo42r
	oGqZhVsZdPRAPIKi2+uASlPtCUMqwdGC0qT/madN7SqyC7JkgdTTa1xc
X-Gm-Gg: Acq92OHE0XFGU3jPuEIioIjH9cdNe2ETc7/y24PmLbmM7UtDhIAB30za67myJKGGXgp
	EIobqpxsDBUuABNDmLnTDvT+A3F0rkcFXWubdbG0KvEC+mQq/5x1ccoyeh6uigQf3T8uej9B51b
	0hY50aNKW8q3zYNfA/QdnOojyd7Yg1kVGj9XOLV/XVqMkzY3Tvzy7kz5yuAS7p/f0p2T0BlVlxl
	J0CfQydknTsMOWrH/dKPMugnHLX0Rb870zLLiw8/flpb08R3HSx2xorAxz5JZ9WreKE3dGulTSh
	InkWWM131kXIeIuXes/jYaR/Jm8OV7b26jeTzIZe7wLdGju4eRVG6ePbdhxVh2pE3Y5BG9O6jLV
	EhSZ5vKcfOp+yHg6vLGZ0Uxf5ZrXEjrtB2G1bZhK39aMov2TZiOuMmXFcDT509wHelT9+U2merY
	/oAhdFwxrvW1HvToRdEwpk+41S
X-Received: by 2002:a5d:5d01:0:b0:452:a293:4d91 with SMTP id ffacd0b85a97d-45e5c34b279mr6291492f8f.0.1778855662325;
        Fri, 15 May 2026 07:34:22 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::bc35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9e767d16sm15773464f8f.6.2026.05.15.07.34.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 07:34:21 -0700 (PDT)
From: Alban Crequy <alban.crequy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
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
Subject: [PATCH v4 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Fri, 15 May 2026 16:33:34 +0200
Message-ID: <20260515143335.739511-2-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260515143335.739511-1-alban.crequy@gmail.com>
References: <20260515143335.739511-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iqf6gryfkk3adt5fzyxpzfkyu75kdbn1
X-Rspam-User: 
X-Rspamd-Queue-Id: 02417140010
X-Rspamd-Server: rspam07
X-HE-Tag: 1778855663-747570
X-HE-Meta: U2FsdGVkX1/ZQgHgUYzQLl7aYEzKGSYDFm8FpelQUkY4XFfQKU285ykkU/ekDzA3WVCVgPAe13ZgrnnHL9wYZ3LzUFacBNdJW3M5mu8jcYjCeoMkeBeq3MR1004MqYHsvEKqgobnAvK7dGx48hjeKYnWXTqaAHd36O7uBnGQf8gh1aeUNfajnINWcU57/OEfQT1BVXfsAzrdKGOKheaJ0xGmu2CUIH9tSN20t4qrDCRH4ItadNlWFae4atfiMPVukMjCheAeV6LFgtdtyoggLprbm1fPRYc9Sqt8qL+VOZoMkleUiXRY5CcDxQn9Nim18Q6geXaPtfXXFEcE+hjw/1wnUK/FNEukO0DTzi1D+yDhEeJC3iEq1fY4dlJbHpdv7RXtlOLkW+xhv1bFYeQoQZ9I0tMUPzpryPOPf6iOTMg3M//bpd1xdOoSrjIiWoC24ky7TGiCEeoEIwCU4VkC/38jg1ipGka/O7Ae0BAx/Ga1u09zJq+kW1RFjVwVckaYX3hEEfM9u80zTWhFyrcHGenLcldtqoy5iC+R71TuYPf0PxxyE3/FP5QE4t3CNkDjXi44PrWqU2s7MD4mA2WcnEcRNKDaKgFpGXoBuX4OfBgzrEOdyB4a8SRYRD2kZU+tjM+4+NbS7QZRq2amr4qHZFBJ9SEDCPOecGpgPVfinlTM0VtR/RPxXdBddtb6Nb9DNvpK99+yq80Gli/rYs4j2p1S9AcO4xuqNCqQnnTonNTJ/NTBE7NLlIlU/dVgKZS0UCBy7lCvQs086I5f4i53odHYwgmnNMVUCfOSFZ8QpbJVLyZMbGlTGHCRZIUU2lKO7gmhjdPLroI22f/4yOLTajyQU8Ctf1VVJeNUBLoblZp7BZlOMYRhu8pNsArlZrgXMzez+ZyoGEBYURZeyrQg260wlc9ndOcMYPB4ZougtwlFwj+SF9pR2VaHDVovwIujyE7rZy5Ba6KXHcrlZTc
 BvIru1vb
 QUgIrOb8WMcm0uofbzjtbi+RSlQOc4M5HLnjjfmG2UvXPtlevlZhrhHgSwpZ+IdWA0HMiM0uLRVZOPof6WWTSBcIxvP6cEVkg1c0clZ/84Fk66uptA8dTk3qY+IvOTSNL8UqcYqO0qur50fE6anumGEVTrctdyY5l2rGUk4OXKeUyBTtpgyiENUuq2oCQzDuP/ZD9IIe+3vuPhaYjXoda4XHOC0c34SWiA0Pnc5/PHB9XwfGdgZAhjBbi9fRGgWiET2iE0DkHrdnx1O1BBvGtay1EA0F4vi19vbBWtfFg9r+dxOuOL6yGyMQNh6wJEXfHI5YHkD+YscTnCizMk+xV07l4FqVB4CPAgytHGGgoOD84z5hmL9X/LQPPjjEC0pkIrW4JnB58B3PapejtPJCFmEJ/3/XwAxVutmlzR4g+dErgVx0UaPm1KIp7ryiOTfhDr7l8lH2f7WkpzGWQWP/n22LbQ/qXypjVUtyoWkgsFNA6pv+pPC259e3VdaZY+04UrbVQ0QrthBNlcBUwehylvkZXAqXisMlUdMX7MtSIJU0Di5lSLKX1k8mzPH00J3cA+ohsEaNv95ILN9BXdI05OJlqhirJB7I89rXHuwNi4TmePDA=
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
not block on IO if the memory access causes a page fault. When a page
is not resident and would require IO to fault in, the syscall returns
a short read (the number of bytes successfully read before the fault)
or -1 with errno set to EFAULT if no bytes were read.

Additionally, this patch adds the flag PROCESS_VM_PIDFD to refer to the
remote process via PID file descriptor instead of PID. Such a file
descriptor can be obtained with pidfd_open(2). This is useful to avoid
the pid number being reused. It is unlikely to happen for debuggers
because they can monitor the target process termination in other ways
(ptrace), but can be helpful in some profiling scenarios. When using
PROCESS_VM_PIDFD, the first argument is a pidfd instead of a pid. If
the pidfd is invalid, the syscall returns -1 with errno set to EBADF.

If a given flag is unsupported, the syscall returns the error EINVAL
without checking the buffers. This gives a way to userspace to detect
whether the current kernel supports a specific flag:

  process_vm_readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)
  -> EINVAL if the kernel does not support the flag PROCESS_VM_PIDFD
     (before this patch)
  -> EFAULT if the kernel supports the flag (after this patch)

Suggested man page update for process_vm_readv(2):

  The flags argument is the bitwise OR of zero or more of these flags:

  PROCESS_VM_PIDFD (since Linux 7.x)
      The pid argument is a PID file descriptor (see pidfd_open(2))
      instead of a PID number. When using this flag, the existing
      ESRCH error applies if the process referred to by the pidfd
      has exited.

  PROCESS_VM_NOWAIT (since Linux 7.x)
      Do not block on IO. If a page in the remote address space is not
      resident and would require disk IO to fault in, the system call
      returns a short read or fails with EFAULT if no bytes were read.

  Additional error:

  EBADF  pid is not a valid file descriptor (PROCESS_VM_PIDFD only).

Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
---
v4:
- Rename process_vm.h to process_vm_access.h (David Hildenbrand)
- Fix MAINTAINERS alphabetical sort order (David Hildenbrand)
- Document NOWAIT return value and PIDFD EBADF error (David Hildenbrand)
- Add suggested man page update text
  (David Hildenbrand, Christian Brauner, Mike Rapoport)
- Keep (1UL << N) in UAPI header (David Hildenbrand)

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

 MAINTAINERS                            |  1 +
 include/uapi/linux/process_vm_access.h |  9 +++++++
 mm/process_vm_access.c                 | 34 +++++++++++++++++++-------
 3 files changed, 35 insertions(+), 9 deletions(-)
 create mode 100644 include/uapi/linux/process_vm_access.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 7492fefa447c..e64252164191 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16788,6 +16788,7 @@ F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
+F:	include/uapi/linux/process_vm_access.h
 F:	fs/proc/meminfo.c
 F:	kernel/fork.c
 F:	mm/Kconfig
diff --git a/include/uapi/linux/process_vm_access.h b/include/uapi/linux/process_vm_access.h
new file mode 100644
index 000000000000..2196c9c46351
--- /dev/null
+++ b/include/uapi/linux/process_vm_access.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_PROCESS_VM_ACCESS_H
+#define _UAPI_LINUX_PROCESS_VM_ACCESS_H
+
+/* Flags for process_vm_readv/process_vm_writev */
+#define PROCESS_VM_PIDFD        (1UL << 0)
+#define PROCESS_VM_NOWAIT       (1UL << 1)
+
+#endif /* _UAPI_LINUX_PROCESS_VM_ACCESS_H */
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 656d3e88755b..31004dd3c9e3 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -14,6 +14,9 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
+#include <linux/process_vm_access.h>
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


