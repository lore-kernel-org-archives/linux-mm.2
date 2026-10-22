Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C5C606A326
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HLfFQCw3
Received: by kanga.kvack.org (Postfix)
	id 72F9D6B097B; Thu, 22 Oct 2026 11:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7089E6B097D; Thu, 22 Oct 2026 11:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6450D6B097E; Thu, 22 Oct 2026 11:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 231C56B097B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:44:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78E3180190
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:18 +0000 (UTC)
X-FDA: 85350683796.10.550906F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA9671C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLfFQCw3;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683856;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hk/ssgrdkq8/qRRZXVzyxWia5Ficp9oJf+3Qtn+7r0E=;
	b=nNFeJ1NzbnNdpf7OBVQWfOxhzXwTD/Y90zVSpkPhcPBNsqMU+v1b1l6pwk0Swp+Oea/IR+
	U9DbFrxih1znYTXhvj6RApHrco1iqlg41HrPWEV+HAIooXxSCos+U8rJuEvMT40I8YLKk8
	/HqUs4OZqAGO8MtCxjpIPGbd2klnmkI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683856;
	b=LuuHZtIAVw7xUoBN2bcT9X0hreNE8lLSgO6RIHBFVy5uAyWtT2cF4sAzK1h1A8ouUZ3Hy/
	4b/kNFu7eZ/UpUqQb2iS8Tqpx3J0mijoKj9CQlT5Q8EpTMfiMPF+4GRIqPo62Er8lJSeiP
	I9GaWjObl/ccdD+rludLhZR+0VkOmK0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HLfFQCw3;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AE24439A7;
	Thu, 22 Oct 2026 15:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD751F031E0;
	Thu, 22 Oct 2026 15:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683855;
	bh=Hk/ssgrdkq8/qRRZXVzyxWia5Ficp9oJf+3Qtn+7r0E=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HLfFQCw35QAZKM3oc9hlBiQXn69xCnF8xSNmpeDoic8f5QCE+aKcxtksbvb6FxAQu
	 q1qlc3cKbJUFOrn34LE879xlXJ/IwFJpJm/eXley7KuwCQqOIWuHNTHypiCG39oF2H
	 XUosBF3HjQTSB+pSG7vpjOQ6tX/v9HZolXkECzqqaWGOyGiXDH01+tkIMFvadaW475
	 syntUvrfe3WKl2b3s7iL+zq/7BlV7e9htmJ9jfgGTG6u2dyv89kZn+adlbF4xY0RSg
	 IoD/dYfEsto7ANh38xv/N2np2eA4x9oidCg3bqgk/O8GokU+eSgnBQgfjHHa+DJPDj
	 uXzz+qrFdWXPA==
Message-ID: <sashiko-outbox-181718@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 2/8] dma-heap: charge dma-buf memory via explicit
 memcg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Albert Esteve" <aesteve@redhat.com>, "Tejun Heo" <tj@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Sumit
 Semwal" <sumit.semwal@linaro.org>, =?utf-8?b?Q2hyaXN0aWFuIEvDtm5pZw==?= <christian.koenig@amd.com>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Benjamin Gaignard" <benjamin.gaignard@collabora.com>, "Brian
 Starkey" <Brian.Starkey@arm.com>, "John Stultz" <jstultz@google.com>, "T.J.
 Mercier" <tjmercier@google.com>, "Christian Brauner" <brauner@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "James Morris" <jmorris@namei.org>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Stephen Smalley" <stephen.smalley.work@gmail.com>, "Shuah
 Khan" <shuah@kernel.org>, "Randy Dunlap" <rdunlap@infradead.org>,
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, mripard@kernel.org, echanude@redhat.com, media-ci@linuxtv.org
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-2-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-2-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:44:12 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BA9671C0004
X-Stat-Signature: 5g1mtxqhdrbtafbiyp331rcge9pmdktf
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792683856-942354
X-HE-Meta: U2FsdGVkX1/ihN4YmKVzB5G2t2Pl1fn94zq3Xxhu+KIr/n60f81xokyfs631Xebn7vkAqQdOWgHsrkIuFfMsjllee8/+4OU1WZydwJ1kOyvZ2J0CapATu0UGBq/GV4iypVl/i0bZINZHmrInr5CObnysXXXDqtciBJJt+9cKs3rQ5ReCAQzqsb3DLwVhuyQ/oWyzaCB72RrEgcJPT+KYdSf6hResw11xP1GWC9mFX6OytVxCQYJw3MCexf1BzBeFlGIgqgY2OxV8pqnzPhqSyqAuHYwc5JmpM1UGdT/6lTFaBhaP4Q3dwhdna5wNayKfcov0FTJULPwVtg1ByRGw+q5Rsnt+dkb/CkUDBq4hry5O3kOay76Yot15bofhjCKAyWqXmHyGwB+niI7LWPkofYatB7UVgEFFSZBpxJuJODMj9sgrvDZBpf1ivOqJB5cFIIGLF0TCizf6LN4nv7T3ZurhK5okxj76GopyBylFYiq7kGAUwQQR6PxJux2ZoqAdYVlthEBTpY9JHVUFAWMP7d0cBZO0wrphjM3z3gW3SrKFttxLWdxDHhZNwIFGDxxU19eXE/y+bUbt6SU3VC3lsFidnZt665LLyobVBgtYniNGXBdOXCJ6sS1c4MywDFdgXsHtme0qQ4WKx468tfclLTZo3WKjzfRyIhnytflFQINy9/ZBPg5UElmAzJW4eDJpaJuiuSg8ogRb1zMvCX7Uo2LWoh9d1BeBSdZJjZ7OezBcEOMjtV/W9KnCpvebpex4QBXC7f+rX//vX32Q1YOM6pMN7ai5fcl1nzQYGJ7dRop7+iGmWgBK4wx7wtF0m0qrm6TcousoFfQl+vpjw8xD/m2L1+gGsQlLwU+QNqhre/BDkF+WKvNZoSyvsnhWNOZrhrSVSdUNNrOYR4/vFg8Ge2WlzhWDCIz9FPtl3bRfT5JI/kDWxwHdwChwNjMtLIjdqCsUyET2N58qABw9uV8
 dngh816i
 gowRbkLsVAk6n2zwCgLEaPR3IAafrIVPMt+wRtt5aQu9tFsmCKDf3BRmoEP6AP1s6EYZ3y7WLFn/VOXm8fhaTOFAB0Vr3LxpjIfOJMOpIvxUJP949IyjNRYproKyNLqh2c57oZ660XUYSAl56BRfHk5bRYbUgV3moPeaQ0pFjUq3NaO4kYEoP1s2jqnVRb1sistsduveB1Vv9vjqUhBiNHbb/cd+QtVD55e3/5SyOQeSgYVm5jQV86Byx+H1F+divB5/MNKrVSRfoFj2pH7HvtwrwXEIlRfxReT6s13qYpX6YYRzyTH4AT5Geh9Zd3j7QcmZLbV6uB0gDvpMvl6moXhVZ1ZzZWdz+LtKlqeFJZJQw72MhTrAnbqTTMB2sWikhbGupSAC1C0uQv3inAFAkdRmtQlBdv+Bz4ptxPXvXd55MtaErmWJx8Np2zn2vEx/3FEY4v3UPB0zFQc2fhzeajTwZL40nl/WbH2rAAXJq5ZkvgZmxCtb2T+1j4TRAmvUW6ZjomUlobQuyjQqtnxcUAZ0cGH2BE01J6AEuVAJzkQNfLvc5Sd+ho5FPxAelumwbHhI5FmlhDdpU3IBpOxsJUTfSioxmCJ/4j8kAEM1Z3iWgWyWX49UBW7331yK+SU8CQkrOT18SRGU9NdaCLXKzwmx26nZFfSmQWHfN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Critical] dma-heap: UAF and wrong memcg fallback on task->mm in dma_heap=
_ioctl_allocate()
- [High] dma-heap: missing permission check on charge_fd in dma_heap_ioctl_=
allocate()
- [Medium] dma-heap: missing __padding validation in dma_heap_ioctl_allocat=
e()
- [Medium] dma-heap: physical pages allocated before memcg charge in dma_he=
ap_ioctl_allocate()
- [Low] dma-heap: build failure in dma_heap_ioctl_allocate() when CONFIG_ME=
MCG=3Dn
--

commit 662cb8c6d2fd1fbf166b582f9ede716df0713b4a
Author: Albert Esteve <aesteve@redhat.com>

dma-heap: charge dma-buf memory via explicit memcg

This commit adds a charge_fd field to struct dma_heap_allocation_data so
DMA_HEAP_IOCTL_ALLOC can resolve a target cgroup from a cgroupfd or pidfd
and charge the allocated dma-buf to that memcg via
mem_cgroup_charge_dmabuf(). When charge_fd is unset and mem_accounting is
enabled, the allocation is charged to the calling process's memcg.

> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> index 8a6c2b6e0cc60..be77a4c168ab0 100644
> --- a/drivers/dma-buf/dma-heap.c
> +++ b/drivers/dma-buf/dma-heap.c
> @@ -7,14 +7,18 @@
>   */
> =20
>  #include <linux/cdev.h>
> +#include <linux/cgroup.h>
>  #include <linux/device.h>
>  #include <linux/dma-buf.h>
>  #include <linux/dma-heap.h>
> +#include <linux/memcontrol.h>
> +#include <linux/sched/mm.h>
>  #include <linux/err.h>
>  #include <linux/export.h>
>  #include <linux/list.h>
>  #include <linux/minmax.h>
>  #include <linux/nospec.h>
> +#include <linux/pidfd.h>
>  #include <linux/syscalls.h>
>  #include <linux/uaccess.h>
>  #include <linux/xarray.h>
> @@ -75,9 +79,14 @@ static int dma_heap_open(struct inode *inode, struct f=
ile *file)
> =20
>  static struct dma_buf *dma_heap_ioctl_allocate(struct file *file, void *=
data)
>  {
> +	struct cgroup *cgrp;
> +	struct cgroup_subsys_state *css;
>  	struct dma_heap_allocation_data *heap_allocation =3D data;
>  	struct dma_heap *heap =3D file->private_data;
>  	struct dma_buf *dmabuf;
> +	struct mem_cgroup *memcg =3D NULL;
> +	struct task_struct *task;
> +	unsigned int pidfd_flags;
>  	int fd;
>  	size_t len;
> =20
> @@ -90,15 +99,56 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct=
 file *file, void *data)
>  	if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
>  		return ERR_PTR(-EINVAL);
> =20
> +	if (heap_allocation->charge_fd) {
> +		cgrp =3D cgroup_get_from_fd(heap_allocation->charge_fd);
> +		if (!IS_ERR(cgrp)) {
> +			/* charge_fd is a cgroupfd */
> +			rcu_read_lock();
> +			css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
> +			if (!css || !css_tryget_online(css)) {
> +				rcu_read_unlock();
> +				cgroup_put(cgrp);
> +				return ERR_PTR(-ENOENT);
> +			}
> +
> +			memcg =3D mem_cgroup_from_css(css);
> +			rcu_read_unlock();
> +			cgroup_put(cgrp);

[Severity: Low]
Will this build when CONFIG_DMABUF_HEAPS=3Dy and CONFIG_MEMCG=3Dn (or
CONFIG_CGROUPS=3Dn)?

In drivers/dma-buf/Kconfig, DMABUF_HEAPS only selects DMA_SHARED_BUFFER and
does not depend on CONFIG_MEMCG or CONFIG_CGROUPS:

drivers/dma-buf/Kconfig:
    menuconfig DMABUF_HEAPS
        bool "DMA-BUF Userland Memory Heaps"
        select DMA_SHARED_BUFFER

In include/linux/cgroup_subsys.h, SUBSYS(memory) is guarded by
#if IS_ENABLED(CONFIG_MEMCG), so memory_cgrp_subsys is only declared when
both CONFIG_CGROUPS and CONFIG_MEMCG are enabled:

include/linux/cgroup_subsys.h:
    #if IS_ENABLED(CONFIG_MEMCG)
    SUBSYS(memory)
    #endif

Additionally, when CONFIG_CGROUPS=3Dn, include/linux/cgroup.h does not prov=
ide
declarations or stubs for cgroup_get_from_fd(), cgroup_css(),
css_tryget_online(), or cgroup_put(). Referencing memory_cgrp_subsys and
those helpers unconditionally in drivers/dma-buf/dma-heap.c:
dma_heap_ioctl_allocate() breaks the build when CONFIG_MEMCG=3Dn. Should th=
is
resolution block be guarded by IS_ENABLED(CONFIG_MEMCG) or moved into a
memcontrol helper with a !CONFIG_MEMCG stub?

> +		} else {
> +			/* charge_fd is a pidfd  */
> +			task =3D pidfd_get_task(heap_allocation->charge_fd, &pidfd_flags);
> +			if (IS_ERR(task))
> +				return ERR_CAST(task);
> +
> +			memcg =3D get_mem_cgroup_from_mm(task->mm);
> +			put_task_struct(task);
> +		}
> +	}

[Severity: Critical]
Can passing task->mm directly to get_mem_cgroup_from_mm(task->mm) in
drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate() trigger a
use-after-free on struct mm_struct or silently charge the wrong memcg?

pidfd_get_task() only increments task->usage and does not hold
task_lock(task) or pin task->mm via get_task_mm(task). If the target task
concurrently exits in kernel/exit.c:exit_mm() or execs in
fs/exec.c:exec_mmap() -> exec_mm_put_old(), it clears or replaces task->mm
under task_lock() and drops its reference via mmput(mm) -> __mmdrop(mm) ->
free_mm(mm):

kernel/exit.c:exit_mm() {
    ...
    task_lock(current);
    smp_mb__after_spinlock();
    local_irq_disable();
    current->mm =3D NULL;
    membarrier_update_current_mm(NULL);
    enter_lazy_tlb(mm, current);
    local_irq_enable();
    task_unlock(current);
    mmap_read_unlock(mm);
    mm_update_next_owner(mm);
    mmput(mm);
}

Because mm_cachep is not SLAB_TYPESAFE_BY_RCU, free_mm() frees the mm_struct
immediately while mm/memcontrol.c:get_mem_cgroup_from_mm() dereferences
rcu_dereference(mm->owner):

mm/memcontrol.c:get_mem_cgroup_from_mm() {
    if (unlikely(!mm)) {
        memcg =3D active_memcg();
        if (unlikely(memcg)) {
            /* remote memcg must hold a ref */
            css_get(&memcg->css);
            return memcg;
        }
        mm =3D current->mm;
        if (unlikely(!mm))
            return root_mem_cgroup;
    }

    rcu_read_lock();
    do {
        memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));
    ...
}

In addition, if task->mm is already NULL when charge_fd is resolved (for
instance, a zombie task after exit_mm() whose pidfd is still valid, a
thread-group leader that exited via pthread_exit() while other threads
remain alive, or a kernel thread), get_mem_cgroup_from_mm(NULL) falls back
to current->mm and silently charges the central allocator's own cgroup
(even when mem_accounting is disabled) instead of failing with an error
such as -ESRCH. Should this use get_task_mm(task) / mmput(mm) and return an
error if mm is NULL, or resolve the memcg directly from task under RCU?

[Severity: High]
What prevents an unprivileged process with access to /dev/dma_heap/* from
passing an arbitrary pidfd or read-only cgroupfd in charge_fd to escape its
own memory.max limit or trigger OOM kills in another cgroup?

In drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate(), charge_fd is
resolved via cgroup_get_from_fd() or pidfd_get_task() and charged via
mem_cgroup_charge_dmabuf() without checking whether the caller has
permission to charge the target cgroup or task:

1. sys_pidfd_open() in kernel/pid.c allows opening a pidfd for any task
   visible in the caller's PID namespace (such as PID 1 in the root cgroup
   or a task in a peer cgroup) without permission checks.
2. cgroup_get_from_fd() in kernel/cgroup/cgroup.c only checks that the file
   descriptor refers to a cgroup v2 directory and does not check write
   permission (unlike cgroup_css_set_fork(), which checks
   cgroup_may_write()), so any world-readable /sys/fs/cgroup directory
   opened with O_RDONLY | O_DIRECTORY or O_PATH can be charged.

While later commits in this series ("security: dma-buf: Add
dma_buf_charge_task LSM hook", "security: dma-buf: Add
dma_buf_charge_cgroup LSM hook", "selinux: Restrict cross-cgroup dma-buf
charging", and "selinux: Restrict dma-buf direct cgroup charging") add LSM
hooks and SELinux policy checks, there is no baseline DAC,
cgroup_may_write(), ptrace_may_access(), or capability check (such as
CAP_SYS_RESOURCE). On systems without SELinux enabled (or with
CONFIG_SECURITY=3Dn or other LSMs), or on SELinux systems where cgroup
directories lack explicit security.selinux xattrs (-ENODATA in
selinux_dma_buf_charge_cgroup()) or tasks share a domain, unprivileged
cross-cgroup charging remains unrestricted. Should dma_heap_ioctl_allocate()
enforce baseline permission checks on the target cgroup and task in addition
to the LSM hooks?

> +
>  	len =3D PAGE_ALIGN(heap_allocation->len);
> -	if (!len)
> +	if (!len) {
> +		mem_cgroup_put(memcg);
>  		return ERR_PTR(-EINVAL);
> +	}
> =20
>  	dmabuf =3D heap->ops->allocate(heap, len, heap_allocation->fd_flags,
>  				     heap_allocation->heap_flags);
> =20
> -	if (IS_ERR(dmabuf))
> +	if (IS_ERR(dmabuf)) {
> +		mem_cgroup_put(memcg);
>  		return dmabuf;
> +	}
> +
> +	if (!memcg && mem_accounting)
> +		memcg =3D get_mem_cgroup_from_mm(current->mm);
> +
> +	if (memcg) {
> +		if (!mem_cgroup_charge_dmabuf(dmabuf, memcg, GFP_KERNEL)) {
> +			mem_cgroup_put(memcg);
> +			dma_buf_put(dmabuf);
> +			return ERR_PTR(-ENOMEM);
> +		}
> +	}

[Severity: Medium]
Could calling heap->ops->allocate() before mem_cgroup_charge_dmabuf() in
drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate() allow a process in a
memory-limited cgroup to allocate and pin physical memory far beyond its
memory.max limit before the charge check happens?

Prior to commit "memcg: Add MEMCG_DMABUF accounting infrastructure" in this
series, system_heap_allocate() passed __GFP_ACCOUNT to alloc_pages() when
mem_accounting was enabled, charging the memcg incrementally as each page
was allocated and aborting as soon as memory.max was reached.

With __GFP_ACCOUNT removed from system_heap_allocate(),
dma_heap_ioctl_allocate() now allocates and zeroes the entire requested len
of physical backing pages inside heap->ops->allocate() before
mem_cgroup_charge_dmabuf() calls try_charge(). A task confined to a small
memory.max limit can request a multi-gigabyte buffer and force the kernel to
allocate all physical pages (potentially triggering global reclaim or global
OOM) before try_charge() rejects the charge. In addition, if the allocation
would only fit after reclaiming from the target cgroup, allocating the
physical pages before try_charge() prevents cgroup reclaim from freeing the
target cgroup's pages prior to the physical allocation. Could the memcg be
charged before invoking heap->ops->allocate() and uncharged if the
allocation fails?

[ ... ]

> diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-heap.h
> index a4cf716a49fa6..bfcd1c25bc7ea 100644
> --- a/include/uapi/linux/dma-heap.h
> +++ b/include/uapi/linux/dma-heap.h
> @@ -29,6 +29,11 @@
>   *			handle to the allocated dma-buf
>   * @fd_flags:		file descriptor flags used when allocating
>   * @heap_flags:		flags passed to heap
> + * @charge_fd:		optional pidfd or cgroupfd whose cgroup should be
> + *			charged for this allocation; 0 means charge the calling
> + *			process's cgroup when the mem_accounting module parameter
> + *			is enabled, or skip charging otherwise
> + * @__padding:		reserved, must be zero
>   *
>   * Provided by userspace as an argument to the ioctl
>   */
> @@ -37,6 +42,8 @@ struct dma_heap_allocation_data {
>  	__u32 fd;
>  	__u32 fd_flags;
>  	__u64 heap_flags;
> +	__u32 charge_fd;
> +	__u32 __padding;
>  };

[Severity: Medium]
Should drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate() reject non-zero
values in heap_allocation->__padding with -EINVAL?

include/uapi/linux/dma-heap.h documents @__padding as "reserved, must be
zero", and dma_heap_ioctl_allocate() validates heap_allocation->fd,
heap_allocation->fd_flags, and heap_allocation->heap_flags, but never checks
heap_allocation->__padding:

drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate() {
    if (heap_allocation->fd)
        return ERR_PTR(-EINVAL);

    if (heap_allocation->fd_flags & ~DMA_HEAP_VALID_FD_FLAGS)
        return ERR_PTR(-EINVAL);

    if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
        return ERR_PTR(-EINVAL);

    if (heap_allocation->charge_fd) {
    ...
}

Whereas a later commit in this series validates arg.__padding !=3D 0 in
dma_buf_xfer_charge(), dma_heap_ioctl_allocate() leaves __padding unchecked
throughout the series. Also, using charge_fd =3D=3D 0 as the unset sentinel
without a flag in heap_flags makes it impossible to pass valid file
descriptor 0 as charge_fd and causes older kernels to silently ignore
charge_fd. Note that extending struct dma_heap_allocation_data here also
causes tools/testing/selftests/dmabuf-heaps/dmabuf-heap.c:
dmabuf_heap_alloc_newer() (which places .garbage1 =3D 0xffffffff at this
offset) to fail with -EBADF at this commit until the selftest struct layout
is updated in commit 0809a03b2fbc81e6f2b637ef5c0744b2c8ae99f1
("selftests/dmabuf-heaps: Add dma-buf memcg accounting tests").

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-v2_2023012=
3_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com?part=3D2

