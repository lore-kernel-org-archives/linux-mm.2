Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D82CFD376
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9576E6B007B; Tue,  2 Dec 2025 05:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907EA6B0098; Tue,  2 Dec 2025 05:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E7A6B0088; Tue,  2 Dec 2025 05:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BBCA6B0098
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:45:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 09E968A4ED
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:45:20 +0000 (UTC)
X-FDA: 84174199200.15.845700E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CA6D180017
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:45:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vJdo9i/J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764672318; a=rsa-sha256;
	cv=none;
	b=lj1PWpjbhBJrwwNoGWdxcMOmhCaELqNfZkhjFDaavE4aQ8Rpx6REM0/hRwGSnwOe+j8xkE
	vaunxc56IRyIRfNZYKMJInCRtqKDi0+WS6HT8zNkTjBz47wSkmYMp+XJhAuiXZMNHI5H10
	9ptWT0bmXQ1dueUmQVTAlzN677XsII8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="vJdo9i/J";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764672318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iweqFmibF08yPtel4g6xL8B7SEBkyBp1uVGsjCEVUvI=;
	b=w2ZRZJCJzIA7GnSX8P2gRm4kqHEwaSh6bvA4IiUP3TU1n0IQXeg5MzBUvxJsNBC2cpTP20
	3MaHbapTmY5Z5M+ykMPjC+S0z5yp4AQZRmr59s9mo5//ZeEaI/64WGZ+TEgg/5PK2l/5+9
	NKm+1MJCsgTxC6duiL2EWjELvQi6p0I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA26B60139;
	Tue,  2 Dec 2025 10:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D85BC4CEF1;
	Tue,  2 Dec 2025 10:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764672317;
	bh=eFKHQt1gkMWz2B16+a2YkhZvuXqFwfrnAsK7xxmrnS0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vJdo9i/J8Bb0OIkOFAHO0UEmybPDdLWINtZZvLb4OKPhDHrwpkgVi4IEJBazA6G5B
	 9PjhkR9TjvjoyPcyEaVuhYTy4MO5t6cEpzquPltpQsYF9GzQiZgFZRNyUQKHImeDBY
	 CdmbdygsNmGUeILfdp5hZ9Oa25WgjPnzEmYXvDyAWStXAwgwuNQqQru3frYn1wAXnr
	 vTN0HfuujdVEgzC+0VgcjUSQ5EDCYXlT+D1+QUNCGu66JHi/xSN0xNtWMqwpFj/REO
	 G+q1mgN8j1AExpcjVQMR4k1liAyHSQ1UMwJwrt01xJN6AUbMbRDIqVI5weKTAFm6tQ
	 IIDvGhR2NIx6g==
Message-ID: <9d963e84-9740-4bc6-9d9e-98ba4528cae4@kernel.org>
Date: Tue, 2 Dec 2025 11:45:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] process_vm_readv/writev: add flags for pidfd and nowait
To: Alban Crequy <alban.crequy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Alban Crequy <albancrequy@microsoft.com>, Peter Xu <peterx@redhat.com>,
 Willy Tarreau <w@1wt.eu>, mfriese@microsoft.com
References: <20251118132348.2415603-1-alban.crequy@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251118132348.2415603-1-alban.crequy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CA6D180017
X-Stat-Signature: ak8bwgkgo1y99wowkp1du1ubts7gfg5j
X-Rspam-User: 
X-HE-Tag: 1764672318-211239
X-HE-Meta: U2FsdGVkX19qJg9ViU+IDsoY3TV1rHiOp19rTzAoHoKh9HP1ozbYxpGjuq/fZhNCE6E4U0oDxhRVPRIprfS/YZqCm1ITCUCxSl76X7rQ51gSEhdjA0pp7QflR3ZVVAVYDizaME6sGFuAQiO1irSW3ZFW1wnhYBeut51IV/xB0R3SSCguk58e3VG6cPZb8e2f6wadH3DaI1+rvJZXcwjsJbPLV7a17yZ7XqBGiX5Now/4jgw2nmBxDHbkPZ6eRB8AD72d70GF6sdT5KInjSr4EmscmA/ZXo8ZcUdNEg31FnKXXU1iyhN6bgRSLhHoORSLvwtADRAHGHZGzMmkJN3WEFTkyiSwWGPgqDq9uiS9Cbk5P5d3dRf7wCvvPPqPd1gePbQ4QOInM3QzwTWZYry0wXfweqWv+ZP+bmhQLMfdwM/+Ct06YREkuEGojlNevNP9dztnn/n6wl1GTRTWRNQLvPaBffxlDKHokoIRG6k88NDrhCjOoJuuV4CScSzJ0BzwHJoG/4kdc9dl95Jx2efRQT9TATG3V91HrPf3OpSMzRqJZicPHt+EAWT3iQZbyplCcVdDfYgtEcTlUxCMhjvMetACylaLCCvIiEyqYc33l/9vP3ToF4xOFuA+8prt7toDWavnDoorXXpDz/TwZx6QRqdkiRaKCODOBlImFsStHSl2OhCJW7s/RXMFd9C6dFLzN1nbi9f1Ji+wHF2PSUIw6ZtGF8p/A+kDFECbt2NYfd5iFU9hO1x9anWYZjwRtsUppIUODuYpsPEMpJhGbBqa3U4BQKQ/eJpQQGq3jBAqfieidhxfstNUlSEw6IeFwDWpab65UcHYCmrsk7D/wbsdoLlGzsJfhZATOGkt4JDCTS72rIKqc9io4xHrfODInp2LJnm5Hui3B1W9AIBBQ3ipPWczuVny77I+3CnP9+1eA2qtze0+g/2owg4jO1Nc5KmpbedhGZ09a/rpznd+BLr
 0VsiLuvF
 YRkmglBE/B11pZQ1IEv4kKxqagD+LAEt/REnCGspQJcgSHrt2EbAASrecfoBGSWY2cV1+s0Pblg55CKSubZO2UoCdOWaTusSlNkeHeTe3KiDaBdcJHYUuzlb3Nrly646cbVqJE8FxSJy9zj9obXqrMti5/KpAXa5FyLs48A6KqqFjh3Q7WUVZcXEfS/vHPvA75kn8YCJ/Mr0exQjycyGKQSm2vRAt4j+UXo/PGUtenYY4UYmEHPlN5KIJKRelQaZkY0dVNCCSVF/u6cEbJuvS1dZ73ulj4eg1ajv6cs2TnNbjuECv3W/Zg6saMulA3qIYRaaTTNVfhe9p/FS3H+NzmDybbcREAS2vpVUlLhF2WRDIfxmePijKNqwGn0J2hQjzBw7s4WFNeDZV4yUn4AHex78auQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/18/25 14:23, Alban Crequy wrote:
> From: Alban Crequy <albancrequy@microsoft.com>
> 

Hi,


subject: would probably better be something like:

  "mm/process_vm_access: pidfd and nowait support for process_vm_readv/writev"

> - PROCESS_VM_PIDFD: refer to the remote process via PID file descriptor
>    instead of PID. Such a file descriptor can be obtained with
>    pidfd_open(2).
> 
> - PROCESS_VM_NOWAIT: do not block on IO if the memory access causes a
>    page fault.
> 
> If a given flag is unsupported, the syscall returns the error EINVAL
> without checking the buffers. This gives a way to userspace to detect
> whether the current kernel supports a specific flag:
> 
>    process_vm_readv(pid, NULL, 1, NULL, 1, PROCESS_VM_PIDFD)
>    -> EINVAL if the kernel does not support the flag PROCESS_VM_PIDFD
>       (before this patch)
>    -> EFAULT if the kernel supports the flag (after this patch)
> 

You should not just describe what you are doing, but also why you are doing it.

What is the problem you are trying to solve in user space where you would
require these extensions?

> Signed-off-by: Alban Crequy <albancrequy@microsoft.com>
> ---
>   MAINTAINERS                     |  1 +
>   include/uapi/linux/process_vm.h |  9 +++++++++
>   mm/process_vm_access.c          | 20 +++++++++++++++-----
>   3 files changed, 25 insertions(+), 5 deletions(-)
>   create mode 100644 include/uapi/linux/process_vm.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e64b94e6b5a9..91b4647cf761 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16272,6 +16272,7 @@ F:	include/linux/pgtable.h
>   F:	include/linux/ptdump.h
>   F:	include/linux/vmpressure.h
>   F:	include/linux/vmstat.h
> +F:	include/uapi/linux/process_vm.h
>   F:	kernel/fork.c
>   F:	mm/Kconfig
>   F:	mm/debug.c
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

Can we use BIT() here? I see it getting used in other uapi headers.

> +
> +#endif /* _UAPI_LINUX_PROCESS_VM_H */
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index 656d3e88755b..b5eac870ef24 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -14,6 +14,7 @@
>   #include <linux/ptrace.h>
>   #include <linux/slab.h>
>   #include <linux/syscalls.h>
> +#include <linux/process_vm.h>
>   
>   /**
>    * process_vm_rw_pages - read/write pages from task specified
> @@ -68,6 +69,7 @@ static int process_vm_rw_pages(struct page **pages,
>    * @mm: mm for task
>    * @task: task to read/write from
>    * @vm_write: 0 means copy from, 1 means copy to
> + * @pvm_flags: PROCESS_VM_* flags
>    * Returns 0 on success or on failure error code
>    */
>   static int process_vm_rw_single_vec(unsigned long addr,
> @@ -76,7 +78,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
>   				    struct page **process_pages,
>   				    struct mm_struct *mm,
>   				    struct task_struct *task,
> -				    int vm_write)
> +				    int vm_write,
> +				    unsigned int pvm_flags)

"unsigned int" but you define the flags as unsigned long above. Applies to all
occurrences.

We ran into interesting issued with such inconsistency with clone-flags recently :)

>   {
>   	unsigned long pa = addr & PAGE_MASK;
>   	unsigned long start_offset = addr - pa;
> @@ -91,6 +94,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
>   
>   	if (vm_write)
>   		flags |= FOLL_WRITE;
> +	if (pvm_flags & PROCESS_VM_NOWAIT)
> +		flags |= FOLL_NOWAIT;
>   
>   	while (!rc && nr_pages && iov_iter_count(iter)) {
>   		int pinned_pages = min_t(unsigned long, nr_pages, PVM_MAX_USER_PAGES);
> @@ -141,7 +146,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
>    * @iter: where to copy to/from locally
>    * @rvec: iovec array specifying where to copy to/from in the other process
>    * @riovcnt: size of rvec array
> - * @flags: currently unused
> + * @flags: process_vm_readv/writev flags
>    * @vm_write: 0 if reading from other process, 1 if writing to other process
>    *
>    * Returns the number of bytes read/written or error code. May
> @@ -163,6 +168,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>   	unsigned long nr_pages_iov;
>   	ssize_t iov_len;
>   	size_t total_len = iov_iter_count(iter);
> +	unsigned int f_flags;
>   
>   	/*
>   	 * Work out how many pages of struct pages we're going to need
> @@ -194,7 +200,11 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>   	}
>   
>   	/* Get process information */
> -	task = find_get_task_by_vpid(pid);
> +	if (flags & PROCESS_VM_PIDFD)
> +		task = pidfd_get_task(pid, &f_flags);
> +	else
> +		task = find_get_task_by_vpid(pid);
> +
>   	if (!task) {
>   		rc = -ESRCH;
>   		goto free_proc_pages;
> @@ -215,7 +225,7 @@ static ssize_t process_vm_rw_core(pid_t pid, struct iov_iter *iter,
>   	for (i = 0; i < riovcnt && iov_iter_count(iter) && !rc; i++)
>   		rc = process_vm_rw_single_vec(
>   			(unsigned long)rvec[i].iov_base, rvec[i].iov_len,
> -			iter, process_pages, mm, task, vm_write);
> +			iter, process_pages, mm, task, vm_write, flags);
>   
>   	/* copied = space before - space after */
>   	total_len -= iov_iter_count(iter);
> @@ -266,7 +276,7 @@ static ssize_t process_vm_rw(pid_t pid,
>   	ssize_t rc;
>   	int dir = vm_write ? ITER_SOURCE : ITER_DEST;
>   
> -	if (flags != 0)
> +	if (flags & ~(PROCESS_VM_NOWAIT | PROCESS_VM_PIDFD))

Likely we want that wrapped in a new define like

#define PROCESS_VM_SUPPORTED_FLAGS (PROCESS_VM_NOWAIT | PROCESS_VM_PIDFD)

(likely not in the uapi header but in a kernel-internal one)

-- 
Cheers

David

