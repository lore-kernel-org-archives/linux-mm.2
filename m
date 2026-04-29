Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C8FCFF8864
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 06:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99D526B0005; Wed, 29 Apr 2026 02:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E5A6B008A; Wed, 29 Apr 2026 02:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864486B008C; Wed, 29 Apr 2026 02:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73CCE6B0005
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 02:41:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 156518C3E0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:41:18 +0000 (UTC)
X-FDA: 84710646636.11.5AF76EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 484FA40008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:41:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6AiIgML;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777444876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHTOJKX4uBZoLme9JzJk08Dz6VD1NLDsMA3l6C4HUE4=;
	b=RjeFTnUvo2sKBKRJpFryhTHqun743qpkg35NnSQ9xEupcpfaytAAjaEmL8rLMWtu41UtMI
	9YNeIhVVgXtcRig/GVnfDedDdCPD6TFa6ae9tVMlRCFuHCdjB37/ZaCIVpKY57Z/PeKf4I
	zem38ePsJkoo6G+M4n8nbl8Ndjky1iY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777444876; a=rsa-sha256;
	cv=none;
	b=gsJNPliA7mJ10HwOU1ek0HcXJTi29L6AoRqhV1hR5hZWawgQR76Uts1pybUPt3iIUQJ5zg
	NeALMQT54R8klo9EMiHpPO5Vz1RxQfoOCmTQnS83xY6dTHp66aOuh9fM9TAfHbDL4gryGy
	Ux/e6aOptO/x1Vk/XTeeF4Y/YQEJVOE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V6AiIgML;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AC3C6024D;
	Wed, 29 Apr 2026 06:41:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C53C2BCF5;
	Wed, 29 Apr 2026 06:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777444875;
	bh=34iTrriJGBhonEZFig54qz1hPF/cmuRTcYTDzGLT6rE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V6AiIgML2tBs8CEIEhaPjcO0tgaxckdky59xlsizuUf7ODpdAN/WYZsrCzIszL6OO
	 +MXzIqPdTNlG5zNN1R4ucSaVrE6C7u+kt4KzOlD5/NAkHD8uvP9qhPVzTcYI/YybzZ
	 RDywbYIrDObILYz85YV9e2s7a7UvmV6KZBxXWF1RfK2M7hC9WrDWYpAfU4Oedj0kH7
	 Q6kmsrK6+lDqXY1xzsGB90FOtDSDU9HUNYZ12oYDr1gLbhre8iDZUCjXAeoAMBZ3fK
	 Ud7c3yLUiz7a/DTv57IG27MvhXsbet3tcALpuzTxlPkXOkZlTcB2iGoo+A/ck42nw+
	 Ah2I7c35jnTWQ==
Date: Wed, 29 Apr 2026 08:41:05 +0200
From: Christian Brauner <brauner@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alban Crequy <alban.crequy@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>, Willy Tarreau <w@1wt.eu>, 
	linux-kselftest@vger.kernel.org, shuah@kernel.org, Usama Arif <usama.arif@linux.dev>, 
	David Laight <david.laight.linux@gmail.com>
Subject: Re: [PATCH v3 1/2] mm/process_vm_access: pidfd and nowait support
 for process_vm_readv/writev
Message-ID: <20260429-gesessen-eschenholz-4b7f54a5a8f5@brauner>
References: <20260428122826.339550-1-alban.crequy@gmail.com>
 <20260428122826.339550-2-alban.crequy@gmail.com>
 <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8b29da5b-e260-4b77-a640-8abb447291d1@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 484FA40008
X-Rspam-User: 
X-Stat-Signature: 97tsbmopncsj657ce7y4n8yzhxdek5qe
X-HE-Tag: 1777444876-313518
X-HE-Meta: U2FsdGVkX18bklGivnlgrcNwh+AMHNMBsNsyy/0F+foKqxxFkgtqYJEZePcr5dhf2Hys7sev4xQX6DNFyb2MmtKhTm1O31bI9SXsF6HuLs8X1yaEVzwsDnALxeoF7InUy94umtul1GARHUv/odTIslYHEOFXOOVUfIhRJhL8dzIklBhGT35z2xFIemRaIjfGD+oAFIFePG5DxnglnUifP87cfZdFXADvdq3abuNopVHIoUcDJvmI5l2Uqs36ejF6drzFRF6Yqtcu1Cw2x41A+ysKXO8C5GYUbJr8F3xcE5e2roURDGKvmNn5J/WTpiqvts6Ask+hRk8AqzZMEHKn34ltOxymKCQ7Qp3pi+m9EW0gmTe4SvSY2+PJ9hCAvUQgVVEJkee/q1MWMVkZdpdZYkREOg8CO0+h/PeXwQeleViMMZDt7MwYyXWubehyD/diRZwaDR7pziE7Wg/TEmHQIsg/Ralg+E7VPIO9nWp0AOmh5IgGI/5hAuecgGcQ9BD6inYkJQMJIYsudAOLp/LseZZMEV8Z+7mTGAT1jA4qjIKho1c5p9q+/gpSlRpb0JpLvCNGs6gfdTvrtKr41Co/t6nmm+WvcsC66I4tNS7DzmxVFaZveXuV0ADFEnTYV0ZcHnQOQq85E6NCLFgx6Y+rzVr3OKv4kpufP/iMrrTmETtu4+BNDDGgq2GFhJRB6R2r+y3tISBymWltsQbmpEc1a1x/T0IN+yYX859n+vxP2GswLXEW67xbnOFmZXCjtqdhrA2MWK35fTKYBv9mvh++Mr777jQdtg0u7BhkZnbHsYk/UFvH/Dub6MvItbSGgrROiBmdOqf+Z+GUxAeEFYK6qDQpJ8defQMxbCjsvPruheEJNytnZXrBbyVWp/3xrUj6vOfdUtxY3w7TNPNWBkwrGMLskwZt6g2GgHap/I1d3KtHNNkSGwDNi6ipguCKhrqN9oLxUotMDphpBeS0ydk
 AYefQ8id
 oI9QZQZJLHlZORWhSp5GzzFV2+fAOrD33fPJr9S1r5sMj08XdODuHyj0jruhPzgedRzDy1dr9wfx2yePMCAnDk6dQUtqfPeHFLbbAqyZXjUi+s8f+nZ28uxMhHoK+I+XvEY/K4/KuaNWVhCPFnX8HclXA2uZOGScYJEKtxbiJKjcXjvEvD90WtNqicen+9+vBQEVO7H4pNnV8z8qXmOPfYXdOhAB9ovk6ZcJKEd8tsNlUnU2+fuS+ZXnB4Ak3mE2hG4mVA+oAKy7PtBpX2XQ86uBN6GOQImtg+cgWVUb5i5OAp+s7fzmLwjWN+MIt6wcrUFGhCztOwQUSFu5QD42j2bh9iF5Qn3gymBFlzRco2URhMBIMUR/WTB/7ttD32r2RjxVDpl94CvEVaSVChrQBm+wZRuMkknENkAYxqU37GHx5W/ac7IYCpVeK644UG7PEBBcC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 10:05:49PM +0200, David Hildenbrand (Arm) wrote:
> On 4/28/26 14:28, Alban Crequy wrote:
> > From: Alban Crequy <albancrequy@microsoft.com>
> 
> Hi,
> 
> some more smaller comments. Overall, LGTM.
> 
> > 
> > There are two categories of users for process_vm_readv:
> > 
> > 1. Debuggers like GDB or strace.
> > 
> >    When a debugger attempts to read the target memory and triggers a
> >    page fault, the page fault needs to be resolved so that the debugger
> >    can accurately interpret the memory. A debugger is typically attached
> >    to a single process.
> > 
> > 2. Profilers like OpenTelemetry eBPF Profiler.
> > 
> >    The profiler uses a perf event to get stack traces from all
> >    processes at 20Hz (20 stack traces to resolve per second). For
> >    interpreted languages (Ruby, Python, etc.), the profiler uses
> >    process_vm_readv to get the correct symbols. In this case,
> >    performance is the most important. It is fine if some stack traces
> >    cannot be resolved as long as it is not statistically significant.
> > 
> > The current behaviour of process_vm_readv is to resolve page faults in
> > the target VM. This is as desired for debuggers, but unwelcome for
> > profilers because the page fault resolution could take a lot of time
> > depending on the backing filesystem. Additionally, since profilers
> > monitor all processes, we don't want a slow page fault resolution for
> > one target process slowing down the monitoring for all other target
> > processes.
> > 
> > This patch adds the flag PROCESS_VM_NOWAIT, so the caller can choose to
> > not block on IO if the memory access causes a page fault.
> 
> What is the expected return value to user space if we run into this case?
> 
> And in the same context: Will you send a man page update? :)
> 
> > 
> > Additionally, this patch adds the flag PROCESS_VM_PIDFD to refer to the
> > remote process via PID file descriptor instead of PID. Such a file
> > descriptor can be obtained with pidfd_open(2). This is useful to avoid
> > the pid number being reused. It is unlikely to happen for debuggers
> > because they can monitor the target process termination in other ways
> > (ptrace), but can be helpful in some profiling scenarios.
> > 
> > If a given flag is unsupported, the syscall returns the error EINVAL
> > without checking the buffers. This gives a way to userspace to detect
> > whether the current kernel supports a specific flag:
> > 
> >   process_vm_readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)
> >   -> EINVAL if the kernel does not support the flag PROCESS_VM_PIDFD
> >      (before this patch)
> >   -> EFAULT if the kernel supports the flag (after this patch)
> > 
> > Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
> > ---
> > v3:
> > - Fix ERR_PTR handling for pidfd_get_task(): use IS_ERR()/PTR_ERR()
> >   for the pidfd path, matching process_madvise() (Usama Arif, Sashiko)
> > 
> > v2:
> > - Expand commit message with use-case motivation (David Hildenbrand)
> > - Use unsigned long consistently for pvm_flags parameter (David Hildenbrand)
> > - Add PROCESS_VM_SUPPORTED_FLAGS kernel-internal define (David Hildenbrand)
> > - Keep (1UL << N) in UAPI header: BIT() is defined in vdso/bits.h
> >   which is not exported to userspace, so UAPI headers using BIT() would
> >   break when included from userspace programs (David Hildenbrand)
> > 
> >  MAINTAINERS                     |  1 +
> >  include/uapi/linux/process_vm.h |  9 +++++++++
> >  mm/process_vm_access.c          | 34 ++++++++++++++++++++++++---------
> >  3 files changed, 35 insertions(+), 9 deletions(-)
> >  create mode 100644 include/uapi/linux/process_vm.h
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 2fb1c75afd16..0f6ce21d6235 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16786,6 +16786,7 @@ F:	include/linux/ptdump.h
> >  F:	include/linux/vmpressure.h
> >  F:	include/linux/vmstat.h
> >  F:	fs/proc/meminfo.c
> > +F:	include/uapi/linux/process_vm.h
> 
> We try to sort this alphabetically. Sometimes we failed. Likely this should just
> go to one more line up.
> 
> >  F:	kernel/fork.c
> >  F:	mm/Kconfig
> >  F:	mm/debug.c
> > diff --git a/include/uapi/linux/process_vm.h b/include/uapi/linux/process_vm.h
> > new file mode 100644
> > index 000000000000..4168e09f3f4e
> > --- /dev/null
> > +++ b/include/uapi/linux/process_vm.h
> 
> Thinking out loud: the c file is called "process_vm_access.c", should we name
> the header like that as well?
> 
> > @@ -0,0 +1,9 @@
> > +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> > +#ifndef _UAPI_LINUX_PROCESS_VM_H
> > +#define _UAPI_LINUX_PROCESS_VM_H
> > +
> > +/* Flags for process_vm_readv/process_vm_writev */
> > +#define PROCESS_VM_PIDFD        (1UL << 0)
> > +#define PROCESS_VM_NOWAIT       (1UL << 1)
> 
> Should we use BIT here? I see some usage in other uapi headers (e.g., tcp.h)
> 
> > +
> > +#endif /* _UAPI_LINUX_PROCESS_VM_H */
> > diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> > index 656d3e88755b..dacef50be0be 100644
> > --- a/mm/process_vm_access.c
> > +++ b/mm/process_vm_access.c
> > @@ -14,6 +14,9 @@
> >  #include <linux/ptrace.h>
> >  #include <linux/slab.h>
> >  #include <linux/syscalls.h>
> > +#include <linux/process_vm.h>
> > +
> > +#define PROCESS_VM_SUPPORTED_FLAGS (PROCESS_VM_PIDFD | PROCESS_VM_NOWAIT)
> >  
> >  /**
> >   * process_vm_rw_pages - read/write pages from task specified
> > @@ -68,6 +71,7 @@ static int process_vm_rw_pages(struct page **pages,
> >   * @mm: mm for task
> >   * @task: task to read/write from
> >   * @vm_write: 0 means copy from, 1 means copy to
> > + * @pvm_flags: PROCESS_VM_* flags
> >   * Returns 0 on success or on failure error code
> >   */
> >  static int process_vm_rw_single_vec(unsigned long addr,
> > @@ -76,7 +80,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
> >  				    struct page **process_pages,
> >  				    struct mm_struct *mm,
> >  				    struct task_struct *task,
> > -				    int vm_write)
> > +				    int vm_write,
> > +				    unsigned long pvm_flags)
> >  {
> >  	unsigned long pa = addr & PAGE_MASK;
> >  	unsigned long start_offset = addr - pa;
> > @@ -91,6 +96,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
> >  
> >  	if (vm_write)
> >  		flags |= FOLL_WRITE;
> > +	if (pvm_flags & PROCESS_VM_NOWAIT)
> > +		flags |= FOLL_NOWAIT;
> >  
> >  	while (!rc && nr_pages && iov_iter_count(iter)) {
> >  		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
> > @@ -141,7 +148,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
> >   * @iter: where to copy to/from locally
> >   * @rvec: iovec array specifying where to copy to/from in the other process
> >   * @riovcnt: size of rvec array
> > - * @flags: currently unused
> > + * @flags: process_vm_readv/writev flags
> >   * @vm_write: 0 if reading from other process, 1 if writing to other process
> >   *
> >   * Returns the number of bytes read/written or error code. May
> > @@ -163,6 +170,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
> >  	unsigned long nr_pages_iov;
> >  	ssize_t iov_len;
> >  	size_t total_len = iov_iter_count(iter);
> > +	unsigned int f_flags;
> >  
> >  	/*
> >  	 * Work out how many pages of struct pages we're going to need
> > @@ -194,10 +202,18 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
> >  	}
> >  
> >  	/* Get process information */
> > -	task = find_get_task_by_vpid(pid);
> > -	if (!task) {
> > -		rc = -ESRCH;
> > -		goto free_proc_pages;
> > +	if (flags & PROCESS_VM_PIDFD) {
> > +		task = pidfd_get_task(pid, &f_flags);
> > +		if (IS_ERR(task)) {
> > +			rc = PTR_ERR(task);
> 
> This could return -EBADF or -ESRCH. We should document both in the man page. (or
> decide to always return -ESRCH, dunno)

No, please don't. Let's not start overwriting errnos that are actually
useful information for userspace.

