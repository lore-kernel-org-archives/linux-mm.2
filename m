Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D670EF31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43E3A6B00AA; Thu,  9 Apr 2026 10:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE936B00AB; Thu,  9 Apr 2026 10:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DD616B00AC; Thu,  9 Apr 2026 10:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19DDB6B00AA
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:23:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D87B01A06E6
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:23:06 +0000 (UTC)
X-FDA: 84639234372.18.46D71E9
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf20.hostedemail.com (Postfix) with ESMTP id EF7E71C000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:23:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DsVqzrbZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJmQAm7uioCabLjZN6Eq85fjeQMArpijG7yEfsXm2NI=;
	b=breBngHsAWpo42W70yHMixTiunnlOzNDCNb+jm8cQVwz3pcmCFhqG/pkCb1z//2LrjWeFJ
	5iBdFP3oOZSYdLoG59D6AGq0rYMWSdcoQpYLjPIUGMp5S1O09izWs+M56sZQ+moPBSvXy8
	hwG9ayWl4uSJVapwkbsTIPMKUyVuA+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744585; a=rsa-sha256;
	cv=none;
	b=nh1kn/CwuirvGblxaeU+5XDKGFgpNNDFBkSPRQWy0y7kxruAlc8J7bwGnqmsGpCfgJZM4S
	uDjalgAMGfxQWs5oy+jbOB3pv6OWEAauLLaEyw6HGxj8Ut29xIxHcdO41hyOZGstw2CgnZ
	BfFiZRn4074aDBky+vY7bjSsQSOEUCU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DsVqzrbZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775744582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JJmQAm7uioCabLjZN6Eq85fjeQMArpijG7yEfsXm2NI=;
	b=DsVqzrbZ34fOTPTzExWcZ2ObxDsZWleMA3Zfg4KVUW4iWdnuT0vY9D4CFl9Oz67TOZyFP+
	sl2YKT1idGscHUbyLTju3vlMV53kvr85IXcbdXVEi6vMo+kOJyZcwM28C6IdaI+fx1uIhY
	MZwrfRL74tuJ09Ahc3iql6cHdSVzQA8=
From: Usama Arif <usama.arif@linux.dev>
To: Alban Crequy <alban.crequy@gmail.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Alban Crequy <albancrequy@microsoft.com>,
	Peter Xu <peterx@redhat.com>,
	Willy Tarreau <w@1wt.eu>,
	linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Subject: Re: [PATCH v2 1/2] mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev
Date: Thu,  9 Apr 2026 07:22:55 -0700
Message-ID: <20260409142256.131676-1-usama.arif@linux.dev>
In-Reply-To: <20260408145436.843538-2-alban.crequy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: EF7E71C000E
X-Stat-Signature: 7jjrq35mcisa1sb6u5939cumemyn616t
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775744584-20332
X-HE-Meta: U2FsdGVkX19+p146wjWFBV6MBCLxuiypagi/YbM6Ic7ymb0RiK3T72lx0Dcrxy4tHPl8qvfp6QnNSF4F7EY5XEZ7FRwS8j2jYfILfvnMycv/+hPUSHm/Ybq9Ze10MIrX6xfKAKrVY2qimDm5VSUzHmGbAuwlEIrn/1p2vryQPhOM0TuklW4ZXmkDGIGvOBouYoQ+auDmZlMEa8ivxpI3JGndwb2wU0J7GBBi5cfrUJqDyBIvSFngiW82BpweVHbcQgWazpbB9PM2LEnnPsJel28c5+GlyESkc1WK84IUUNP94zP5gppZYSWj0acChpjCarTUv2oYDE2GitC08QHIT/xn/DD4mVvmPyjbth602FCOM5HXQba8h6lPesZ2tZFmrkraX6WAq00+thYRJztVxJ+Ih1M2FyIGtzwzuOenGUWWJ+IihRkYSHzS2nuJEYgnJL77+ATbPCA5lZ/T08Go7eQIj1Tw0Up2LdTCiq0DsFMZvuzIUbVt3xNCNW1A6UUxQ54Le5mxTpwmL6YLRvMGquJPtvI83+lxYpF+xcaJ7sXqZ9ElkWywScsteJsjw63MMx/WVElsBm60WFO0X3CEOuW5bWH5Mk3ufVw4ABn6QmpwOh538iLpQUb4iqmeLpIRZ+S4lEpHToJAlhUvcY1YrfLWyxhc429Zt44Nt5TXKpzdfMFFzhfA75yT82Nwk8C43B8tJ9w9quc9zqwl8nRw9bHADeK7g8jzIIquD64JpJdgwAAW4O71XEyK5+qY49U81Bt6X+bKAhcUWefmGjAcaO0OR92S1LbA8KLpD5w4i3stsATsYXjOl19IB+Y0pAFga06e6NOvd2n3sfvcegKexSZGoIM7Kyp5/mtpeRhk9VY3TrDNMBWLfVbNmMh6iqUuoUBj3aSmkHysi/Pqmv/rQnFnPqd54ziVKf3zqKOUVmXEFw26xw4wnNUge0cNk/1mCiHMmlUSOeYpf4/1VUL
 udZgqR4d
 wNNuyFQ8nQ+ji85fKXR472tPYtH/lf+4Niq8p5aFAQCauKRLZSIB+rrLyQByeVa1Vw17yLJnkqpg+kVwfksUNOBsq2kY1aCHmFO+mjV42GE0HRDvtC9nC0pwpi5TMR6Y6lu0ugKYzl8AW5BTnEJO+5cMfjDYgAfaJ0GT3WkkD4thLYJ19uDh8hklAnMfV8ADxYpWjaShiBHzIw+vQ18h50Q5r+ZXkEmUA7J5LaUm0X1U25c+3WdTQjGHg4XsEM+kcnAZiXRQ/PU50dpDHphYxn5SXyUnY8IXuMH/YeVOTfhLoNbBLpvH47XFXks6mhlzfX8mza0yoMFGf2dly8EXN0qVu3X70Y9h8HzsLdFPPQF21fNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Apr 2026 16:54:35 +0200 Alban Crequy <alban.crequy@gmail.com> wrote:

> From: Alban Crequy <albancrequy@microsoft.com>
> 
> There are two categories of users for process_vm_readv:
> 
> 1. Debuggers like GDB or strace.
> 
>    When a debugger attempts to read the target memory and triggers a
>    page fault, the page fault needs to be resolved so that the debugger
>    can accurately interpret the memory. A debugger is typically attached
>    to a single process.
> 
> 2. Profilers like OpenTelemetry eBPF Profiler.
> 
>    The profiler uses a perf event to get stack traces from all
>    processes at 20Hz (20 stack traces to resolve per second). For
>    interpreted languages (Ruby, Python, etc.), the profiler uses
>    process_vm_readv to get the correct symbols. In this case,
>    performance is the most important. It is fine if some stack traces
>    cannot be resolved as long as it is not statistically significant.
> 
> The current behaviour of process_vm_readv is to resolve page faults in
> the target VM. This is as desired for debuggers, but unwelcome for
> profilers because the page fault resolution could take a lot of time
> depending on the backing filesystem. Additionally, since profilers
> monitor all processes, we don't want a slow page fault resolution for
> one target process slowing down the monitoring for all other target
> processes.
> 
> This patch adds the flag PROCESS_VM_NOWAIT, so the caller can choose to
> not block on IO if the memory access causes a page fault.
> 
> Additionally, this patch adds the flag PROCESS_VM_PIDFD to refer to the
> remote process via PID file descriptor instead of PID. Such a file
> descriptor can be obtained with pidfd_open(2). This is useful to avoid
> the pid number being reused. It is unlikely to happen for debuggers
> because they can monitor the target process termination in other ways
> (ptrace), but can be helpful in some profiling scenarios.
> 
> If a given flag is unsupported, the syscall returns the error EINVAL
> without checking the buffers. This gives a way to userspace to detect
> whether the current kernel supports a specific flag:
> 
>   process_vm_readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)
>   -> EINVAL if the kernel does not support the flag PROCESS_VM_PIDFD
>      (before this patch)
>   -> EFAULT if the kernel supports the flag (after this patch)
> 
> Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
> ---
> v2:
> - Expand commit message with use-case motivation (David Hildenbrand)
> - Use unsigned long consistently for pvm_flags parameter (David Hildenbrand)
> - Add PROCESS_VM_SUPPORTED_FLAGS kernel-internal define (David Hildenbrand)
> - Keep (1UL << N) in UAPI header: BIT() is defined in vdso/bits.h
>   which is not exported to userspace, so UAPI headers using BIT() would
>   break when included from userspace programs (David Hildenbrand)
> 
>  MAINTAINERS                     |  1 +
>  include/uapi/linux/process_vm.h |  9 +++++++++
>  mm/process_vm_access.c          | 24 ++++++++++++++++++------
>  3 files changed, 28 insertions(+), 6 deletions(-)
>  create mode 100644 include/uapi/linux/process_vm.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c3fe46d7c4bc..f7168c5d7acc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16678,6 +16678,7 @@ F:	include/linux/pgtable.h
>  F:	include/linux/ptdump.h
>  F:	include/linux/vmpressure.h
>  F:	include/linux/vmstat.h
> +F:	include/uapi/linux/process_vm.h
>  F:	kernel/fork.c
>  F:	mm/Kconfig
>  F:	mm/debug.c
> diff --git a/include/uapi/linux/process_vm.h b/include/uapi/linux/process_vm.h
> new file mode 100644
> index 000000000000..4168e09f3f4e
> --- /dev/null
> +++ b/include/uapi/linux/process_vm.h
> @@ -0,0 +1,9 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +#ifndef _UAPI_LINUX_PROCESS_VM_H
> +#define _UAPI_LINUX_PROCESS_VM_H
> +
> +/* Flags for process_vm_readv/process_vm_writev */
> +#define PROCESS_VM_PIDFD        (1UL << 0)
> +#define PROCESS_VM_NOWAIT       (1UL << 1)
> +
> +#endif /* _UAPI_LINUX_PROCESS_VM_H */
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index 656d3e88755b..c6a25e9993e1 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -14,6 +14,9 @@
>  #include <linux/ptrace.h>
>  #include <linux/slab.h>
>  #include <linux/syscalls.h>
> +#include <linux/process_vm.h>
> +
> +#define PROCESS_VM_SUPPORTED_FLAGS (PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT)
>  
>  /**
>   * process_vm_rw_pages - read/write pages from task specified
> @@ -68,6 +71,7 @@ static int process_vm_rw_pages(struct page **pages,
>   * @mm: mm for task
>   * @task: task to read/write from
>   * @vm_write: 0 means copy from, 1 means copy to
> + * @pvm_flags: PROCESS_VM_* flags
>   * Returns 0 on success or on failure error code
>   */
>  static int process_vm_rw_single_vec(unsigned long addr,
> @@ -76,7 +80,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  				    struct page **process_pages,
>  				    struct mm_struct *mm,
>  				    struct task_struct *task,
> -				    int vm_write)
> +				    int vm_write,
> +				    unsigned long pvm_flags)
>  {
>  	unsigned long pa = addr & PAGE_MASK;
>  	unsigned long start_offset = addr - pa;
> @@ -91,6 +96,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  
>  	if (vm_write)
>  		flags |= FOLL_WRITE;
> +	if (pvm_flags & PROCESS_VM_NOWAIT)
> +		flags |= FOLL_NOWAIT;
>  
>  	while (!rc && nr_pages && iov_iter_count(iter)) {
>  		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
> @@ -141,7 +148,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
>   * @iter: where to copy to/from locally
>   * @rvec: iovec array specifying where to copy to/from in the other process
>   * @riovcnt: size of rvec array
> - * @flags: currently unused
> + * @flags: process_vm_readv/writev flags
>   * @vm_write: 0 if reading from other process, 1 if writing to other process
>   *
>   * Returns the number of bytes read/written or error code. May
> @@ -163,6 +170,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>  	unsigned long nr_pages_iov;
>  	ssize_t iov_len;
>  	size_t total_len = iov_iter_count(iter);
> +	unsigned int f_flags;
>  
>  	/*
>  	 * Work out how many pages of struct pages we're going to need
> @@ -194,7 +202,11 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>  	}
>  
>  	/* Get process information */
> -	task = find_get_task_by_vpid(pid);
> +	if (flags & PROCESS_VM_PIDFD)
> +		task = pidfd_get_task(pid, &f_flags);
> +	else
> +		task = find_get_task_by_vpid(pid);
> +
>  	if (!task) {
>  		rc = -ESRCH;
>  		goto free_proc_pages;

pidfd_get_task() returns ERR_PTR() on failure (e.g. ERR_PTR(-EBADF)),
but the code checks "if (!task)" which only catches NULL. An invalid
pidfd will cause mm_access() and put_task_struct() to dereference an
error pointer, crashing the kernel.

