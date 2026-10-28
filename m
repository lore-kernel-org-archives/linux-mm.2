Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CAF60A2613
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZkxBsnFF
Received: by kanga.kvack.org (Postfix)
	id 277706B05B8; Wed, 28 Oct 2026 11:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24E186B05B9; Wed, 28 Oct 2026 11:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C9C6B05BA; Wed, 28 Oct 2026 11:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCBDE6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:04:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45916A011C
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:36 +0000 (UTC)
X-FDA: 85372356552.23.4F68216
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 96C431C0012
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:04:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkxBsnFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793199874;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Rsc9g24MtPLpVFEqmviyx5L0j/Yg5yRWd8d0hmWbnc=;
	b=iki5IZOvF2WVypKNn/R4/L617Tk1M2s74Fbmq6XNGvwpyX0rE1qC/G7B78PtwJ65PEkmLl
	5vZNhrHKCVfP4QL99eFyRiavepsWRyIWkRoaKjAXO6fKT/CITNwDTsHO3tQfsjtgFWxx/K
	pveXyJXQsVotVDQ4MGQpwjjh7LAJJfE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZkxBsnFF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793199874;
	b=lN3+Xdc9Ge+29B5B8nNM7PISYPP7KOB0cjEk+fH9YkVLJJ9joANt0AWdQslyaEkdrsLlRb
	5LG9qav8W3PYy91FV5YxUi2qcAoX/GoF8AhThUAV1flQ11pkOsZyUof+R7ONCSGBuhxZl5
	MUHJrB+6WJDwiqCzZcmuDDT6tjqTjPQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1147B60236;
	Wed, 28 Oct 2026 15:04:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D381F031E1;
	Wed, 28 Oct 2026 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793199873;
	bh=+Rsc9g24MtPLpVFEqmviyx5L0j/Yg5yRWd8d0hmWbnc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZkxBsnFFHC/9gTRrdBEknTJoTVZswKRDlPDucehz4Dm8MSiKl46eCXT1gByUpUafd
	 jnnLlwddU9v1iqiS4g5eIh2DqyeNhaseMSbKOJPzpRj4Y1cPELGRH+v/WQSuCyAhWh
	 f/dC/tZ4EdQ13mxHFfYgAV+Y1a527tVWVLT/liknT+QPmlmamJuQQYsp9NHiqPq7xK
	 DuwaHnmvGLSZ5yhpngyULqUh69y5/4tUeRPI/7ZillyArv5BpnnLfZQPdBwRXlAS8o
	 tt8eHigoxeUfc/bo9NX5aRFDlx2pFDSsoLSIQdUALqDrV29y4gIKDqfCikxAeAVEg0
	 zeS8UrUwPaGyA==
Message-ID: <sashiko-outbox-188027@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/8] dma-heap: charge dma-buf memory via explicit
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
 =?utf-8?b?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, "Jens Wiklander" <jenswi@kernel.org>, "Sumit
 Garg" <sumit.garg@kernel.org>
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, echanude@redhat.com, mripard@kernel.org, media-ci@linuxtv.org
In-Reply-To: <20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647@redhat.com>
References: <20261027-v2_20230123_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com>
 <20261027-v2_20230123_tjmercier_google_com-v3-2-78d2c4cb8647@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 15:04:31 +0000
X-Rspamd-Queue-Id: 96C431C0012
X-Stat-Signature: 8rttzepqg8rccsmmzf96jqic8u5rx9i8
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793199874-576023
X-HE-Meta: U2FsdGVkX1+e7Ut7NDTPRGW39D5mbihkemJwFxT9b27DXQx/yhrOjJLNc6uQOxcbJVt3eNTvilyI01Nmk/veTdGBHj2VOdMPbSiQGzfv+UtizF9FO2BJ8jv63QTlJxKfdpxoVit4eYsMYWY0GwVz5dMuX3OyVVBTBGiqi0dTPUvFNkGHqYoNRntB9dws2g+1Gv32Cg8bpg9WFh+3Ra41hU1P3gBcWf6fspCAiwx1AWRhdLAx9WPAgri+4762/oaBjSPFQ4fnacorcg7x4MuFdoYt3FVPENateMSayQ/yM9b2kGA9s3a/1NJ2EDoAiYztvBG+2ldYeO1tia0XyNVx7TOFqGV28BV5UAaqlD5LBB7mqdz3ZSCqRhXfpSTdwyFQKSnWkCmawe6R+a4DvvLMhDygtTMaOvE6hhFnTK3hliNDeKs/urI01wgElbY9cgUeZD4/rQjCc+xJWjKbuR6sxgTHdDs3hSsXqFE9gy6v4gWrtflHHKbL8EiW57HoPHk9WheugEO74Iei5rYyQs4OMCO57yKXG7KuUgS4ozEQsyfpQDMWdCofrAvkXoxwgTOshEBK0iRMwTCSf+/oeVfBiZR0UtBPxMl6EHS3VJcM+0MVv6Qu2kUbTksytwlEubwMQkY8pQ5AtzEa+TX4KXS6q8RfuVJldSUrSFs4x3kYyWnfijVEVqF9G+tz6qlOizAc4lUMbhTZViz/PVPdOuT8fnxQzOsdUutWmAGdbTsIdn9puvXOSSu+eLD/JLg/ZsECn2pleNP43hn6F7QUkpQMiA03ZmunDqzWlFdHvz2RSEhFL/V6DwcA7rRXMOHldqW2zDdzIi5z6FJYlUcIN0OYJfsZ3BWoe3YGsVutYbCMAO4bjNGYoKVHIj0s+5NCtiMc8Wnuoiz8CkWSWVMJkjKu/kOoTgRf61RufFLt42aQpgQltPfZrHeAUyPMHCpzwKaZ87O4lL8BMQYRGi1xQm/
 Ztfwb+3M
 DilEUL9JEjIFvx3xBuLJf2zLN9AxX5Y49BEw2f/AWjKBG2FtQ9bps0QtsauRbwFwEePCkeJtad1gyVMbOKBvNqyFgvC7T6mey+tZJ+GHhCMGLkYGEK8t6S8VpiJQcENpvKqdXU4+bov1xxeDoYYFZpMwe6gvgTpzUsNtlep9pZLdSt/Lh3obIn7krhRbbQcUMOMnRPrPXUeL92dhH7HFlzvl/wu+4NHtRZ3TWGxQtnVdRciOnvMxDhTffj0pUyYs8TSkbo+Q1zVoy/fK5504Rf/f0t2o25Bg/vZRcYFMqUSHYkawCjB3QVN5Kn1t4+tfJx/bEU1zB4CFD2IZ0mrh7LXkl7a1zbgV20diLylHh/0f2YBgCMEdEA1vka+5aIZ4aTHzXC53LqpOIEI0k0tIWYdq7/aJ3kUM+sapI1TkY0aEuY0u6sAn0GUDigN1ABUbYQ3n+veKEZ4iSfsl2wJtE6qDYw0xLEjvBynoyF9RZads4fMLB85dY63qE4iGWjaUj0vq0RTflDtkZXRuiQ/OVLWLa06nuzvoEBN77EdvTG6L7OGYMEbtY2PIVPTNxBXXV9vCv4xpfR+pXeljVjMnv+MFlDXOpXertSpfEeViMr7WV5mmx8VQSl5K8u7XTsmAtItA+9VEVCaeEzDssHIF3SsL/ASxn/evMkMFf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] dma-heap: missing permission check in mem_cgroup_get_from_fd()
- [High] dma-buf: system_heap: 32-bit nr_pages truncation in system_heap_al=
locate()
- [Medium] mm: memcontrol: missing EXPORT_SYMBOL_GPL() on dmabuf memcg help=
ers
- [Medium] mm: memcontrol: mem_cgroup_get_from_fd() returns NULL when memcg=
 is disabled
--

commit 961ee31303129349ee7fa6988bef4bc244f22a61
Author: Albert Esteve <aesteve@redhat.com>

dma-heap: charge dma-buf memory via explicit memcg

This commit adds a charge_fd field to struct dma_heap_allocation_data so
DMA_HEAP_IOCTL_ALLOC can resolve a target cgroup from a pidfd or cgroupfd v=
ia
mem_cgroup_get_from_fd() and charge system heap allocations to that memcg.

[ ... ]

> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/=
system_heap.c
> index c8959eadc71d1..adeea8cd328b8 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -17,6 +17,7 @@
>  #include <linux/err.h>
>  #include <linux/highmem.h>
>  #include <linux/mem_encrypt.h>
> +#include <linux/memcontrol.h>
>  #include <linux/mm.h>
>  #include <linux/set_memory.h>
>  #include <linux/module.h>
> @@ -388,8 +389,6 @@ static struct page *alloc_largest_available(unsigned =
long size,
>  		if (max_order < orders[i])
>  			continue;
>  		flags =3D order_flags[i];
> -		if (mem_accounting)
> -			flags |=3D __GFP_ACCOUNT;
>  		page =3D alloc_pages(flags, orders[i]);
>  		if (!page)
>  			continue;
> @@ -401,11 +400,13 @@ static struct page *alloc_largest_available(unsigne=
d long size,
>  static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
>  					    unsigned long len,
>  					    u32 fd_flags,
> -					    u64 heap_flags)
> +					    u64 heap_flags,
> +					    struct mem_cgroup *memcg)
>  {
>  	struct system_heap_buffer *buffer;
>  	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
>  	unsigned long size_remaining =3D len;
> +	unsigned int nr_pages =3D PAGE_ALIGN(len) >> PAGE_SHIFT;

[Severity: High]
Can nr_pages truncate on 64-bit systems when a caller passes a large
heap_allocation->len via DMA_HEAP_IOCTL_ALLOC?

In dma_heap_ioctl_allocate(), heap_allocation->len is page-aligned into a
size_t len and only checked for zero before being passed to
system_heap_allocate() as an unsigned long:

drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate() {
	...
	len =3D PAGE_ALIGN(heap_allocation->len);
	if (!len) {
		mem_cgroup_put(memcg);
		return ERR_PTR(-EINVAL);
	}

	dmabuf =3D heap->ops->allocate(heap, len, heap_allocation->fd_flags,
				     heap_allocation->heap_flags, memcg);
}

In system_heap_allocate(), size_remaining keeps the full 64-bit len, while
nr_pages is stored in a 32-bit unsigned int. Because __GFP_ACCOUNT is remov=
ed
from alloc_largest_available(), cgroup enforcement now relies solely on
mem_cgroup_reserve_dmabuf(memcg, GFP_KERNEL, nr_pages).

If userspace passes len >=3D (1ULL << (32 + PAGE_SHIFT)) (for example, 16 T=
iB
with 4 KiB pages), nr_pages wraps to 0 (or a small value), so
mem_cgroup_reserve_dmabuf() succeeds without charging the cgroup while the
while (size_remaining > 0) loop continues allocating uncharged physical pag=
es
until global memory exhaustion. In addition, values of nr_pages in
[0x80000000U, 0xffffffffU] are passed by mem_cgroup_commit_dmabuf() to
mod_memcg_state(), which takes a signed int val and would corrupt
MEMCG_DMABUF statistics.

>  	unsigned int max_order =3D orders[0];
>  	struct system_heap_priv *priv =3D dma_heap_get_drvdata(heap);
>  	bool cc_shared =3D priv->cc_shared;
> @@ -416,10 +417,15 @@ static struct dma_buf *system_heap_allocate(struct =
dma_heap *heap,
>  	struct page *page, *tmp_page;
>  	int i, ret =3D -ENOMEM;
> =20
> -	buffer =3D kzalloc_obj(*buffer);
> -	if (!buffer)
> +	if (!mem_cgroup_reserve_dmabuf(memcg, GFP_KERNEL, nr_pages))
>  		return ERR_PTR(-ENOMEM);
> =20
> +	buffer =3D kzalloc_obj(*buffer);
> +	if (!buffer) {
> +		ret =3D -ENOMEM;
> +		goto cancel_charge;
> +	}
> +
>  	INIT_LIST_HEAD(&buffer->attachments);
>  	mutex_init(&buffer->lock);
>  	buffer->heap =3D heap;
> @@ -478,6 +484,9 @@ static struct dma_buf *system_heap_allocate(struct dm=
a_heap *heap,
>  		ret =3D PTR_ERR(dmabuf);
>  		goto free_pages;
>  	}
> +
> +	mem_cgroup_commit_dmabuf(dmabuf, memcg, nr_pages);
> +
>  	return dmabuf;
> =20
>  free_pages:
> @@ -498,6 +507,8 @@ static struct dma_buf *system_heap_allocate(struct dm=
a_heap *heap,
>  	list_for_each_entry_safe(page, tmp_page, &pages, lru)
>  		__free_pages(page, compound_order(page));
>  	kfree(buffer);
> +cancel_charge:
> +	mem_cgroup_cancel_dmabuf(memcg, nr_pages);

[Severity: Medium]
Will building with CONFIG_DMABUF_HEAPS_SYSTEM=3Dm and CONFIG_MEMCG=3Dy fail=
 at
modpost with undefined symbol errors for mem_cgroup_reserve_dmabuf(),
mem_cgroup_commit_dmabuf(), and mem_cgroup_cancel_dmabuf()?

In drivers/dma-buf/heaps/Kconfig, DMABUF_HEAPS_SYSTEM is tristate, so
drivers/dma-buf/heaps/system_heap.c can be compiled as a loadable module
(system_heap.ko). However, mem_cgroup_reserve_dmabuf(),
mem_cgroup_commit_dmabuf(), and mem_cgroup_cancel_dmabuf() in mm/memcontrol=
.c
do not have EXPORT_SYMBOL_GPL() annotations.

Should those symbols be exported (or should the reservation/commit/cancel
calls live in the built-in drivers/dma-buf/dma-heap.c layer as described in
the commit message)?

[ ... ]

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index bbd46ba40350b..f66254f52b999 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5661,6 +5661,53 @@ void mem_cgroup_flush_workqueue(void)
>  	flush_workqueue(memcg_wq);
>  }
> =20
> +/**
> + * mem_cgroup_get_from_fd - resolve a memcg from a cgroupfd or pidfd
> + * @fd: file descriptor (cgroupfd or pidfd)
> + *
> + * Tries @fd as a cgroupfd first; if that fails, tries it as a pidfd.
> + * On success returns a referenced memcg pointer. On failure returns
> + * an ERR_PTR.
> + */
> +struct mem_cgroup *mem_cgroup_get_from_fd(int fd)
> +{
> +	struct cgroup_subsys_state *css;
> +	struct mem_cgroup *memcg;
> +	struct cgroup *cgrp;
> +	struct task_struct *task;
> +	struct mm_struct *mm;
> +	unsigned int pidfd_flags;
> +
> +	cgrp =3D cgroup_get_from_fd(fd);
> +	if (!IS_ERR(cgrp)) {
> +		rcu_read_lock();
> +		css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
> +		if (!css || !css_tryget_online(css)) {
> +			rcu_read_unlock();
> +			cgroup_put(cgrp);
> +			return ERR_PTR(-ENOENT);
> +		}
> +
> +		memcg =3D mem_cgroup_from_css(css);
> +		rcu_read_unlock();
> +		cgroup_put(cgrp);
> +		return memcg;
> +	}
> +
> +	task =3D pidfd_get_task(fd, &pidfd_flags);
> +	if (IS_ERR(task))
> +		return ERR_CAST(task);
> +
> +	mm =3D get_task_mm(task);
> +	put_task_struct(task);
> +	if (!mm)
> +		return ERR_PTR(-ESRCH);
> +
> +	memcg =3D get_mem_cgroup_from_mm(mm);
> +	mmput(mm);
> +	return memcg;
> +}

[Severity: Critical]
What prevents an unprivileged user with access to a dma-heap device from
passing a cgroupfd (opened with O_RDONLY | O_DIRECTORY or O_PATH on any
world-readable /sys/fs/cgroup directory) or a pidfd (via pidfd_open() on
PID 1 or another user's process) as charge_fd to DMA_HEAP_IOCTL_ALLOC?

Through dma_heap_ioctl_allocate() -> mem_cgroup_get_from_fd() and
system_heap_allocate() -> mem_cgroup_reserve_dmabuf() -> try_charge_memcg(),
charging to the root cgroup (where mem_cgroup_is_root(memcg) skips page
counter charging) allows a restricted process to bypass its own memory.max
and memory.high limits, while charging to another cgroup allows exhausting
that victim cgroup's quota and triggering mem_cgroup_oom() kills inside it.

Later patches in the series ("security: dma-buf: Add dma_buf_charge_task LSM
hook", "security: dma-buf: Add dma_buf_charge_cgroup LSM hook", "selinux:
Restrict cross-cgroup dma-buf charging", and "selinux: Restrict dma-buf
direct cgroup charging") add LSM hooks and SELinux checks, but there are no
baseline DAC, capability, ptrace_may_access(), or cgroup write permission
checks when CONFIG_SECURITY is disabled, when SELinux is not active, or when
a cgroup directory has no explicit security.selinux xattr (where
selinux_dma_buf_charge_cgroup() returns 0 on -ENODATA).

Also, when charging a remote memcg via try_charge_memcg() breaches that
target cgroup's memory.high limit, try_charge_memcg() increments
current->memcg_nr_pages_over_high and calls __mem_cgroup_handle_over_high(),
which resolves get_mem_cgroup_from_mm(current->mm) and reclaims from the
allocating process's own cgroup rather than the remotely charged memcg.
Should remote charging require appropriate permissions over the target task=
 or
cgroup, and how should memory.high reclaim be handled when charging a forei=
gn
memcg?

[Severity: Medium]
In mem_cgroup_get_from_fd(), what happens on the pidfd path when
CONFIG_MEMCG=3Dy and memory cgroups are disabled at boot via
cgroup_disable=3Dmemory?

When mem_cgroup_disabled() is true, get_mem_cgroup_from_mm(mm) returns NULL,
so mem_cgroup_get_from_fd() returns NULL instead of an ERR_PTR as documented
in its kernel-doc comment.

In dma_heap_ioctl_allocate() (and in dma_buf_ioctl_xfer_charge() later in t=
he
series), IS_ERR(memcg) is false for NULL, so a pidfd charge_fd silently fal=
ls
through while a cgroupfd charge_fd fails with -ENOENT (because cgroup_css()
returns NULL when the subsystem is disabled). Should the pidfd path also
return an ERR_PTR when get_mem_cgroup_from_mm(mm) returns NULL?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027-v2_2023012=
3_tjmercier_google_com-v3-0-78d2c4cb8647@redhat.com?part=3D2

