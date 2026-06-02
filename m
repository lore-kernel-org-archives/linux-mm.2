Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC151CD6E4A
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 10:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F5A6B00AC; Tue,  2 Jun 2026 06:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 076D96B00AE; Tue,  2 Jun 2026 06:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEC36B00AF; Tue,  2 Jun 2026 06:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE18C6B00AC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:10:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9EF9E8D018
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:06 +0000 (UTC)
X-FDA: 84834552012.12.D13593F
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id A8F8C180006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 10:10:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZO962bTY;
	spf=pass (imf06.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780395004;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c76SrHoI5fkYZYTcaa/8RFwrM5OKoWVXsmXqH1gEQ1g=;
	b=Rigvk+SiqBPpIKvZCNiN7iyVcHUE7jjQR9x6F4xTYS0gfIDIBryD8A8/5fq1zRPsgH7+5f
	eX5ebSAD6KJWgytcUxCGUrNxs8LG4EHzvPpZBhI03mVs8RsHYmVF8fdGpLlkJvpMTYzRHP
	XPsblEJ6pCg3DalAa43TiMsGE+944zs=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZO962bTY;
	spf=pass (imf06.hostedemail.com: domain of alban.crequy@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=alban.crequy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780395004;
	b=BtPzbP96Fnui8e4+t2naALpVpmACrZWc22+/5KOAn4tDlzizZLZU3xXq2Ahqqhsl41uED7
	x3cvGaP8fzSaxYHjq94K/+bI3Q8sV4GrZfgkZAPX0xyffQToRrsuYcr49MysB99Qp57ZOA
	2EGl79X1HxizU7HfCYvf8KOYC6hKNI8=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef4223be7so2300875f8f.2
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 03:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780395003; x=1780999803; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c76SrHoI5fkYZYTcaa/8RFwrM5OKoWVXsmXqH1gEQ1g=;
        b=ZO962bTYOGRp7MtUrN0TO2+3Zin190q2DAJtWBnUK+vdcjD9HD7T48FM/gTB2558EP
         M8qP0EXJsK6a5oX7U/iCbBTkEMC08UTozsn+EOS9au5QTFfEVXq9pul30q/5HaPSZt30
         DwZQbboK5NwaV1+ARuvgzd9j551FKp022t7inaNYWAff1xjFtD9u3Pk5896FZLUN76gA
         bF+/ZZ+QAWYQxoG6/NfJcj4fU7wk6Dif9Xj9I8+YHPpZULRUbqNuMMb7/w4Pu0Jpn1WJ
         WNNpjqTYLllCfnDvW77FOSshZl6UVUa4WciduTvAwYBHuinIwzoSh78a15KwXa+CT5Sv
         Hecg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395003; x=1780999803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c76SrHoI5fkYZYTcaa/8RFwrM5OKoWVXsmXqH1gEQ1g=;
        b=QrQluWiHd83XovjuM0A3evG87qSZLbzxBBUVa5imnr+y0rqhVfqfpWReCGBpjDt/OE
         7FgyNNmzwzemAnHoRTmdpb0hR5ZbOItIKLYI7vssnk52GkgV06mA2byaxddYze3VPiq1
         sXBbJcONJL0LqCS+jifEWYlZ4pt3qzYgUrIG54+bgIsY24XeH5+9MQmrfVAHPAHbt9OG
         HlAYQ4t1u+dAgfQW1H37PMDWyABqbopb86Zb5N8P472C5ZhFRamKrFGaaQKrwVBlA3eK
         rxNYql1RR0u4YkEqAaneXZ/Y1g4FaFC13fOaF49bKXdn9gcSHLM5eX4Eaks3dOzIFrNi
         CE2A==
X-Forwarded-Encrypted: i=1; AFNElJ8Strls5N6ys7rwtnyfdiNOGZvSrmGx2Dkp/NmvUy0SV5W6ThJAhj6vHF74s/E3gGz03SvLewl77A==@kvack.org
X-Gm-Message-State: AOJu0YyNiBIIpMlX9+iw9hHZ/pqWeGDi0E3rEovXi1cuvctgEAyI6VQu
	K7edCgWIDGxDwURkN1a3AkrlEHyKXK5bqCekhYUglWa3tpb18RG2zmOz
X-Gm-Gg: Acq92OFXpZLIC+9N7rtWXmkd5TXjtPE5KTRqTrxakc5fnKj6DXx+ld4QOzxfPrnpyWh
	vcRMwMfqboD8DpTKYaCutjlO/sA5aAJJWtxKBlbik55wstPJ7l/VFapDsuLCCcpHB2mJQl3GsIz
	PtSG2AcdXUjyGQjXjxtLYfPrRx9WVQPOnLx1KERBJkB1yOvTLFSagzR/UKsfUdQTf+wPS1J5rjn
	eM2uSmeS2km+ilHe5iJ4FahqB+28aqaPllE5aRIA85Mgg1eWncSfeL7IB2oUqmK2lziRxLNPjxE
	/rxtu/t9KC4uGdbi16IhGOqPlhIDQPbrNp0tNv8F4OCKi4mjm6YjN+9Q11N+EnJDvOnM2Mu6KtV
	fDVtCt3Q+w6iKAyC3zxs5ycIgdF9+p+9F6gqiDMdPom3+EfGCsBWAF7VPnxF2onJbtM5vYoMdoT
	OymE9dsUj7uOGnP0Hf5I87yQ24i1RGQK6Xa6Q=
X-Received: by 2002:a05:600d:844a:10b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-490a294935bmr203469825e9.22.1780395003021;
        Tue, 02 Jun 2026 03:10:03 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8308:b093:bb00::d167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354cd87sm30636722f8f.24.2026.06.02.03.10.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:10:02 -0700 (PDT)
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
Subject: [PATCH v5 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Tue,  2 Jun 2026 12:09:16 +0200
Message-ID: <20260602100917.3641359-2-alban.crequy@gmail.com>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20260602100917.3641359-1-alban.crequy@gmail.com>
References: <20260602100917.3641359-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8F8C180006
X-Stat-Signature: f9d65krhnsnwgbnebnpt45y5a36qmb8h
X-Rspam-User: 
X-HE-Tag: 1780395004-464392
X-HE-Meta: U2FsdGVkX1+E1lj0TSP6t2LoSfMKqWrVv+g/akE7Pjv4aXSKooEzyAG3pmGE9zH/O72Q6+xSTCZSTfNtK62xuET3Qt7Ae50jekIodhmsLfXTX8IPGwXsnIJhjHxpfzljXovBIWDJXJPRne1sP2C1vJMHlWpwNBrGegW3Ya8dipckCg/F71yan8AqKFVzy8KG8nBLsZVtPWqJhvB5kcYqQHbO4okzlLkR8LHDeE8GbwWUbxtflvNBnUCyVOLqgEuPQLtV8r6ZG+QKAIWGe5lkAb/0PT8xtOxopCPI3upjf3Osup4+BOUHqHWHq6dMV28sJSV3uioWaU5zDVQFp8SGryaDORmUoqj7Q08n2QTB01EIkVNAN3qtCIOtNiQjMBD+1ODNttZoecM76Olaw+9RSw5Xvv1x2lFMBxFTiFaUOP6TYrbHiDfJocB4rKDRv580tpAHpgsTmK/45jNfupTmrEro0XxE2s/xRONxaBdFlWiVdgf/SyoE310OoBJjh0ggKrKuQZAyKGzJJx+a2epcvH91W5n2WDlah9lg0Dwyo5miAXBrk8AxRjR9lmxNijp5jV/2l5nrgq46XZgNZtnOw9nDAEnz2GsRQ7z3RUkBIFPSur2KXdqdziKdHssZMV/HFVEaCdyT6V3ekmImLp/AHoTAJ7TKlh0+dJzT/uOSq2z+Qa/yVxIklp23jrUvI0KvIpVJXQUbqisS9UP1HjQLee+AgKX4kbINNCqDYIxACta8aODO7KuvJ9Ito83goQp2AFhZR57v9OaAEunogjwqgBD4Bak0t+1M/JGfmTd2WYLk6VNtsczKhMhBTOOCe4RGZPLGAGOERCfspNBU6eKqoHKhEJFMxBQlN36AeZk/N9Uk3eQFj0D9rkCmNYDKWbL6KcWp8cffnyYzrzfMkgDOqEyZfXp98+817ZuLhQ6n6/1f2hUFPP+yJobPGIWycs1Y/exCr6qjezm3AmwuOoN
 lUP/vcLc
 54Rkz7DnpTrtJApUtOLv6/jGhcWjXhPjc3fX3HICM9ST/m5ER4NfhCWkmWwT8H8FgvN0VLwD+dNitgn0rmkJbK3rbANkOqVBJO+VZ4ydC1HsmczxLJxfLuQwiGQ5F7bUflg12877wPGDuyM4t40q48rsyA/8Y9pzPp/uxKi7ZnNXdLdjzFvjVDKaVWdfdw3PYPzpBY4R4VorY8R+vXr/tPE6Pq5ROKWElyh+xSL3vqHOvGFjuqo3oGGuhfw395PKkVR5KGffqIyW9Yy/m1noOsZzDVLRGWjYUZxVP4O+oGxv1+2hc61tTHmaV0FvGD6KMoOuSpiA1zHsugaQRb7jqSvORqFg7IDp9pAT3GBSmxT7JNW+UffmOeBGewHlpRrOlcG3j4UVZQZhnILOqyMpJUbzyECcOa9Ke0URwy3IrWD436AqZL41gTQA4ptpRu7SQtsqdkDAiga05UnLh5hR1iq3URHHwKEwZ0Yx3FKMhFQlVIvXPGwsDthoDbnxnJM70atqEiUF/eDSHRwAhEs91vknPq2LXmmstUiAKqiGseDTKndOVR1p/uTHAj5IcCFbjbQnLrT3bsgi1gK0=
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
v5:
- No changes in this patch.

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
index 9ec290e38b44..1bfce49dd0bb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16800,6 +16800,7 @@ F:	include/linux/pgtable.h
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


