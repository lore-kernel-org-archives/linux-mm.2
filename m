Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A50CF8854
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769326B0005; Thu, 20 Nov 2025 08:16:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741086B0088; Thu, 20 Nov 2025 08:16:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656A86B0089; Thu, 20 Nov 2025 08:16:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB816B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:16:46 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07FBA129978
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:16:46 +0000 (UTC)
X-FDA: 84131035212.06.C8F4C1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62DBC20007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:16:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xivcp1re;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763644604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bEOOG3tizWYev9/D17w3vJ3W1K3hqgh7KrwG/Xy8AwY=;
	b=xMXA/z2nv3ddfhaW7sGm3VXwJV25u8m2s7g3eiwQrIMGwm1XfX5CRx1b9r/c4Uk0tPZTfb
	PAc7Vy3sxVClAdZ0MOaWBULcH/jgPi9rRtVVL3BaVwoRK+wmY4oDl4VW7Qf4+oYshTKnMf
	Wgv9SV/r9Cvv0IfMrRPpYLga8UicyEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763644604; a=rsa-sha256;
	cv=none;
	b=Jf8chPjwkfhGLaRctg984l1RM7yxn2yLiAPVcu3GYpohfd9HUkeZ0L24Bab9poEHIHnXKQ
	9Cpk8kcN6iqxvjw5S51jdKgRAQhL5/DLU0XfVd2NEtB0iie2ClMxpbcPmYZCQG7h8nKNYa
	z9uVcQOMowGP6YHe5uwfQsnk/TINzp4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Xivcp1re;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2002E432E2;
	Thu, 20 Nov 2025 13:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14CFC4CEF1;
	Thu, 20 Nov 2025 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763644603;
	bh=HopaEGtdm8FBrVo2KpU8a97+YpHnH/U2YoiRBVdyAkc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Xivcp1reBev/ocf3Ht4RNUrvB9HPne4LMIEx0lYW8iytX0OYlwhuR+efv+tbV0AXy
	 cH4SJGrWHUukSEmnMlpbd9TTKMOq2tBEE4xxXsarLOyCpMIeH9e3ZD/+k9I3l/Pn8I
	 6zMj0kb7DZMi3vOi54ir/+nEFWUXxsxxNQVlQYHF0RuPd/ncPTMz/XxYYapb3PYLQX
	 OmNLzi8+f0H/zLNySmS1t6cgJzqDooJ/xCeeY1bujADggFHIU2kERESbTxTXjBp4RF
	 N/7u+DVOpUno7M5PtFhbN9OzCdVXSCKZCaiVa2+KQu4AWcaHeAOUYMyErBeeXcIJJ+
	 +ZdBhdcw9JhtQ==
Date: Thu, 20 Nov 2025 14:16:37 +0100
From: Christian Brauner <brauner@kernel.org>
To: Alban Crequy <alban.crequy@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>, Willy Tarreau <w@1wt.eu>, 
	mfriese@microsoft.com
Subject: Re: [PATCH] process_vm_readv/writev: add flags for pidfd and nowait
Message-ID: <20251120-kaputt-zurschaustellen-2148409a972b@brauner>
References: <20251118132348.2415603-1-alban.crequy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20251118132348.2415603-1-alban.crequy@gmail.com>
X-Stat-Signature: 8xp3tf6bcw4bgwx81eywcxxa8xa7krh7
X-Rspam-User: 
X-Rspamd-Queue-Id: 62DBC20007
X-Rspamd-Server: rspam10
X-HE-Tag: 1763644604-283703
X-HE-Meta: U2FsdGVkX1+u9T1XqjJ0aNxfvIPIbF6xlhPOUGfttIeu5eUIiKK5XPKcxWLhBJpQYhfbqrIFSETmkpoW8UrTqO6z5y2JL0NDWyRrix8awXTZ29dm0mLw55k0VJ8JFHRxlUqcom8q6ujUdYco2h2w77Z0zXhP8gvrrh0+oqNlaUSt0r7iiTjo49cISBAwfeM7Y95/voynD4GTocn6t4V1jhmhdA+SNhfNeRHrtmTRoI//fnuqy3Icae6ykKCcGOOVtWCLyQ+/2EsFDIj8SmIFz6ZeMsvJXp4TmnD5bIBcQZwtg+jqkHAzsdu0xcWskMxeM7soAUWuVV4sTdNng66JYVB7cbfVQfapjP7+8MXlUUQ6CS+IGh8FQrdq9vTX9fdZgdHx0lbj581Y1qmrpawW6sK7chn0pT4d6Faxm4o0gWVjoP4aUjKVqb5fdhuceavjv0Rk0mZY69/K/ZKucRg4iM9fQzRK2BLziL9m3vP271MVX+wEpKxDCE7NKSLyGN4vKdlNhWlOVqfdxbjfqh7o9HAuJ7sG8F/66ejEYIcwq+cKveTYlcE01vJ5ne3DsF06Z0rL1nhPGZpmcJ79HMbWh+Ru1HGBxvkR04NyjH6vS+NvSuUeAkxz9JMjuscSzY7fLrQK1V1UbPT2PKOXlxDDNcybOW31rCkeHuRZ9UjzDOcxP3JTPFwNpvK+WSq06M3gHsRtGFJgPiR9WUj1nCtNqbWz18qKHQ5bNU9unW9x0P0QZDf4/OiS/6RPzr8bxkU47kCIEKRPqmxMhyz/tYuBvJnmGui7bM/66KJXbXHsowib0Gk3Q/05AAj6vLD5zJ32r6B70hxc46FR2GVfTp9TBl1uFsSbZszDwnMAElf5e56TtmFHEVR3HRe/5ddAMMjNGu+CNGwY2C6DbhL0otpWjYnmeUUGpx4i4RgkOQ88uoFvPNuSlmL+ttGHZdX5sRI7G6P8K3quwR7PcuuW4H7
 Cg776bgL
 9Gvm9L8N+s9Y45H5FpiglO8RvT2HIk8xb7E+p/byjI18LQeeoDejGu3vE7sMvCNDrJgyXD5CcZBN+RJUuQKl7W8hCi6gPDm7zrptV0pPDN7UuWThrDsaSlf1szQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 02:23:48PM +0100, Alban Crequy wrote:
> From: Alban Crequy <albancrequy@microsoft.com>
> 
> - PROCESS_VM_PIDFD: refer to the remote process via PID file descriptor
>   instead of PID. Such a file descriptor can be obtained with
>   pidfd_open(2).
> 
> - PROCESS_VM_NOWAIT: do not block on IO if the memory access causes a
>   page fault.
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

Looks good to me overall,
Reviewed-by: Christian Brauner <brauner@kernel.org>

I do want to note an inconsistency though we should address - unrelated
to this patchset.

pidfd_get_task() supports PIDFD_SELF_THREAD and PIDFD_SELF_THREAD_GROUP.
This means it allows to operate on an individual thread and not the
thread-group leader.

This is highly relevant for permission checking as stuff like
ptrace_may_access() (via mm_access()) takes the creds of the task into
account and individual threads may have different creds than the
thread-group leader.

So suddently process_madvise(), process_mrelease(), and with this patch
now also process_vm_readv() can operate on individual threads...

except that's not completely true as they only allow to operate on the
individual thread of the caller. Arbitrary non-constant pidfds will
enforce that it's a thread-group leader that was specified and otherwise
return NULL...

We should make this consistent:

(1) Enforce thread-group leader based operations only
(2) Support threads for arbitrary pidfds

Someone needs to tell me what is wanted or needed and then I can fix
pidfd_get_task() accordingly.

The current state is not actively harmful afaict but it's inconsistent.

>  MAINTAINERS                     |  1 +
>  include/uapi/linux/process_vm.h |  9 +++++++++
>  mm/process_vm_access.c          | 20 +++++++++++++++-----
>  3 files changed, 25 insertions(+), 5 deletions(-)
>  create mode 100644 include/uapi/linux/process_vm.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e64b94e6b5a9..91b4647cf761 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16272,6 +16272,7 @@ F:	include/linux/pgtable.h
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
> index 656d3e88755b..b5eac870ef24 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -14,6 +14,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/slab.h>
>  #include <linux/syscalls.h>
> +#include <linux/process_vm.h>
>  
>  /**
>   * process_vm_rw_pages - read/write pages from task specified
> @@ -68,6 +69,7 @@ static int process_vm_rw_pages(struct page **pages,
>   * @mm: mm for task
>   * @task: task to read/write from
>   * @vm_write: 0 means copy from, 1 means copy to
> + * @pvm_flags: PROCESS_VM_* flags
>   * Returns 0 on success or on failure error code
>   */
>  static int process_vm_rw_single_vec(unsigned long addr,
> @@ -76,7 +78,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  				    struct page **process_pages,
>  				    struct mm_struct *mm,
>  				    struct task_struct *task,
> -				    int vm_write)
> +				    int vm_write,
> +				    unsigned int pvm_flags)
>  {
>  	unsigned long pa = addr & PAGE_MASK;
>  	unsigned long start_offset = addr - pa;
> @@ -91,6 +94,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  
>  	if (vm_write)
>  		flags |= FOLL_WRITE;
> +	if (pvm_flags & PROCESS_VM_NOWAIT)
> +		flags |= FOLL_NOWAIT;
>  
>  	while (!rc && nr_pages && iov_iter_count(iter)) {
>  		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
> @@ -141,7 +146,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
>   * @iter: where to copy to/from locally
>   * @rvec: iovec array specifying where to copy to/from in the other process
>   * @riovcnt: size of rvec array
> - * @flags: currently unused
> + * @flags: process_vm_readv/writev flags
>   * @vm_write: 0 if reading from other process, 1 if writing to other process
>   *
>   * Returns the number of bytes read/written or error code. May
> @@ -163,6 +168,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>  	unsigned long nr_pages_iov;
>  	ssize_t iov_len;
>  	size_t total_len = iov_iter_count(iter);
> +	unsigned int f_flags;
>  
>  	/*
>  	 * Work out how many pages of struct pages we're going to need
> @@ -194,7 +200,11 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
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
> @@ -215,7 +225,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>  	for (i = 0; i < riovcnt && iov_iter_count(iter) && !rc; i++)
>  		rc = process_vm_rw_single_vec(
>  			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,
> -			iter, process_pages, mm, task, vm_write);
> +			iter, process_pages, mm, task, vm_write, flags);
>  
>  	/* copied = space before - space after */
>  	total_len -= iov_iter_count(iter);
> @@ -266,7 +276,7 @@ static ssize_t process_vm_rw(pid_t pid,
>  	ssize_t rc;
>  	int dir = vm_write ? ITER_SOURCE : ITER_DEST;
>  
> -	if (flags != 0)
> +	if (flags & ~(PROCESS_VM_NOWAIT | PROCESS_VM_PIDFD))
>  		return -EINVAL;
>  
>  	/* Check iovecs */
> -- 
> 2.45.0
> 

