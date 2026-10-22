Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 265BD606A31B
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W06cjuZW
Received: by kanga.kvack.org (Postfix)
	id B7C7E6B097D; Thu, 22 Oct 2026 11:44:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFEF56B097F; Thu, 22 Oct 2026 11:44:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15C36B0980; Thu, 22 Oct 2026 11:44:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 672266B097D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:44:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3C791C0D0D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:20 +0000 (UTC)
X-FDA: 85350683880.06.ED26279
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 239A020009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:44:18 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W06cjuZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792683859;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7djcSuZ+VkivDbF5yVqI2iBloYUAv2eSmgTqsy+UUpo=;
	b=6p/GG6J7+3xwsSkF6vIhaYgEk6cdRn0sSFB9aYJQY7f76D83AtoGd976f0oA9xDwY9EpHF
	9DL4P9jPnN2h3GexIG0JSdZ548fhJdZnw+MCwYkBfstun4Ul27aTHKjPkvT1b5htNtkG9O
	cwQFsbxFN37it0i7qhtVbZCv6LOtSkU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W06cjuZW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792683859;
	b=z69LWZVUICIUiJ0mZWePiYmq7JrXLbjh0LE+n0cHxqb6giQ1U7grNomCOfOoNR7V+DApKv
	exoZ9QWvKUCS+aFglXeQ66cvQIUfvUQ8rDfjACheSg7Ju19AKORkp8YtRETBmoFpzsYXC6
	xLmLjnS7sBhGNl+FqJVCTRFDlMCISx4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FCB1419D0;
	Thu, 22 Oct 2026 15:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966311F01825;
	Thu, 22 Oct 2026 15:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792683857;
	bh=7djcSuZ+VkivDbF5yVqI2iBloYUAv2eSmgTqsy+UUpo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W06cjuZWWPxaajUZFU2Wwg4ejVWMo7Bk69w/xcOgiEB0Y2gVKfSCd5Ql1rpFj3/od
	 Nd0c3Kr4dlmkL1wrd5w2ggFj5zmwDXAr+5ol+TrpBp46qB0G6YAx4RQGBoeDBgDYTC
	 A4NWE8P1hLktCI+RylJeGRUjk25Qo92EW41R7DzPuQMLDayiWRSC8nV3Fc0jY6OJHr
	 Z6vFDxxvGXD2fPFJGh2pqtzXVdpfskCPKStKZ50RCrnRB22CEhRmgp4qidPO9V6ExL
	 igmaN5FbtU8OF+ONrQby7LX/EClvvTrMppuwq2XyZx5Hg7d+ykaouUe2rMAa4slETv
	 BYzmvkcBcX/OQ==
Message-ID: <sashiko-outbox-181719@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v2 3/8] security: dma-buf: Add dma_buf_charge_task
 LSM hook
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
In-Reply-To: <20261021-v2_20230123_tjmercier_google_com-v2-3-ef6ee2dd8c5c@redhat.com>
References: <20261021-v2_20230123_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com>
 <20261021-v2_20230123_tjmercier_google_com-v2-3-ef6ee2dd8c5c@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 15:44:15 +0000
X-Rspamd-Queue-Id: 239A020009
X-Rspam-User: 
X-Stat-Signature: qm8au6rcp4ub98payubb68hct58tsxay
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792683858-263223
X-HE-Meta: U2FsdGVkX19e2XI/QgI4Q5eU9YXDMi+MpdYCmXMCGyZNITZNzEdBiSrsTrdNX44Bdf+2rbSsUOvAx6EBrTNItGCnzsdq1XUaRpYQREHgXyrCMW/KfGILv0bzzFiOWxV2jPvHe8BihPAe3TWWC91WAPiDvegufFMwNxNMogVaaWzolxXyqhZI8jrCM3EtgP1xhypSjsMfl/4ddQT4aQ7Wg9jj8c2w7OUUSWb1zHY/EMqg9o5odiY3NzPn3MlKId0tX1fQaAo+7yfGKcEjutBF2Re6/FGga9mtk9ihcvXnuMYpXkTStwb648g93+FX+Sxfcu9sZ3ATJgQQyXZG+GrJ7RR/3j6HYUEODp/zA6dkHAHD7VJttBdh3YB2OtXCPVpMhteyTwMb0mHvGYopYq7RDNjsDSAjuMpFf9a8g1IrGOkXgTgAuE8qso6Kh+z3d6K1CHQ98U/tYp2jO5AAU/g+7891PJVonJNxoFAmnHzoqe/foRxCQO9ELqtO8AqR6nYczgaYqtd1NeDCHvo4oyMIoMeKA9y8xbniUVi8RuTkdtfrxb1Avm52JMxjYQhDNzJ2slB+dJSa7zFvZ0wD99ruAGBc41i+FZS2H95nLlBVh79LTfwSN+tK0QOwhxKU8geyGqyRQTaAITtj2kC7Omx/fKITPDkgdqa6iRsAhwtIYeMaS8pvNgmweqE8isyeEFLXjtQNKze6zrnntHvtX3U3F+ds19TMwTKt2uOkfKQvZXlLcqNDKbhAT+30WSHTCiyBjQ2KjIuxJgTjH6Ay20Ll/JKur+78g62FPq8yQJ4/GcD41FQO6Z+fxO5L7L+paP1yk0188/nITsmfR1vdxZdPZhxDK8vOICGc7PPGouFhEaJVzJgvtZyZAW87KYWQzViLEst/yNZ1xbKa8XqfOkS4L7mGIuOuhHCSvQXtFZ9oI+f21xh7s4wEOmACE1gO+2xTHo/kMWUbovUS/F/XWa6
 /j0+l3in
 Ugw/umNOmf4fqu0VNVp10S5tpI+ZEQq7oM1TSfQzBh47hH/N56ghtY8xE3vsVpqYvhy5GYf5jmuCZnbyr+EVwws4UmtnDQ543seIi/qmdLq+D9w+BW1h/97Tx2YVDtzQNvBE988tlrbfXyZHKpGk4jgmwMBK7Kpyb6RjS2WOjy8OMzZ4RlpD1X0gNa2epg17FrVhVwzdAGkkIj/bLAHF+6VsF1+gzbgAC5396mZTP95qBOX0qBEdh0cfbmR1TVYdBryGQ0tuVml+sQwG8yf/gfkBMNhkcjqVmKmG0HkUrDGEyxFQOOJ6FZXkL9aMVocrUP7pvUhbuuaL/i9GoDMBk+c7YZb4McBaPEA51Lxj4/TVVNIvaervd1oj4ViL4u2eaSMiaMXoCp/DfOElwh82Skvc7oeW37qJNnzl8blMO0egu1evQ4Katx59nJfkcr+LHQG54XYiZ5DPqHig04NdnFkNFktev83Li5N2ps8ny+N2tH6J8BD87ON5nWbugfNxYy2jYIYO5v9Xf1vuBZrsQgEYfgpsDJhCVdu91KWXVXVNrQY5bZVkBLXTP0eBxDQWtNNQmLUTuLX7rh4G47j4j+g0cRHNf6IwNIcJNpmXZ7AWI2wuj/RQAEVY3yu5Iikd3lZ/IY1sle0JS48VJ2k44cU1bY6gXSdCovpATYXIX6aHfILi8Asf9KZKi0Av3CJbFyCFLGBKbgYeG96bvOd9Ood/z6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] dma-buf: heaps: UAF on remote task->mm in dma_heap_ioctl_alloc=
ate()
- [High] dma-buf: allocate() runs before memcg charge in dma_heap_ioctl_all=
ocate()
- [Medium] dma-buf: heaps: unguarded cgroup symbols in dma_heap_ioctl_alloc=
ate()
--

commit 4f97d3e850a29378e70a6ab0cb15c71860e1fcea
Author: Albert Esteve <aesteve@redhat.com>

security: dma-buf: Add dma_buf_charge_task LSM hook

This commit adds the security_dma_buf_charge_task() LSM hook and calls it
in dma_heap_ioctl_allocate() when charge_fd refers to a process via pidfd,
allowing security modules to control cross-cgroup dma-buf charging.

> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> index be77a4c168ab0..c315739178867 100644
> --- a/drivers/dma-buf/dma-heap.c
> +++ b/drivers/dma-buf/dma-heap.c

[ ... ]

> @@ -81,13 +82,14 @@ static struct dma_buf *dma_heap_ioctl_allocate(struct=
 file *file, void *data)
>  {
>  	struct cgroup *cgrp;
>  	struct cgroup_subsys_state *css;
> +	const struct cred *tcred;
>  	struct dma_heap_allocation_data *heap_allocation =3D data;
>  	struct dma_heap *heap =3D file->private_data;
>  	struct dma_buf *dmabuf;
>  	struct mem_cgroup *memcg =3D NULL;
>  	struct task_struct *task;
>  	unsigned int pidfd_flags;
> -	int fd;
> +	int fd, ret;
>  	size_t len;
> =20
>  	if (heap_allocation->fd)

[Severity: Medium]
Will this cause a build regression in dma_heap_ioctl_allocate() when
CONFIG_DMABUF_HEAPS=3Dy is built with CONFIG_MEMCG=3Dn or CONFIG_CGROUPS=3D=
n?

In drivers/dma-buf/dma-heap.c, dma_heap_ioctl_allocate() unconditionally
references cgroup_get_from_fd(), cgroup_css(), memory_cgrp_subsys,
css_tryget_online(), and cgroup_put() in the charge_fd resolution block
(introduced earlier in this series by commit "dma-heap: charge dma-buf
memory via explicit memcg" and updated here):

	if (heap_allocation->charge_fd) {
		cgrp =3D cgroup_get_from_fd(heap_allocation->charge_fd);
		if (!IS_ERR(cgrp)) {
			/* charge_fd is a cgroupfd */
			rcu_read_lock();
			css =3D cgroup_css(cgrp, &memory_cgrp_subsys);
			if (!css || !css_tryget_online(css)) {
				rcu_read_unlock();
				cgroup_put(cgrp);
				return ERR_PTR(-ENOENT);
			}

In drivers/dma-buf/Kconfig, DMABUF_HEAPS only selects DMA_SHARED_BUFFER and
does not depend on CONFIG_MEMCG or CONFIG_CGROUPS. However, in
include/linux/cgroup_subsys.h, SUBSYS(memory) (which declares
memory_cgrp_subsys) is guarded by:

#if IS_ENABLED(CONFIG_MEMCG)
SUBSYS(memory)
#endif

Furthermore, in include/linux/cgroup.h, the SUBSYS() declarations along
with cgroup_get_from_fd(), cgroup_css(), css_tryget_online(), and
cgroup_put() are only declared inside #ifdef CONFIG_CGROUPS without stub
definitions when CONFIG_CGROUPS is disabled. Should this path be guarded by
IS_ENABLED(CONFIG_MEMCG), or should Kconfig dependencies/stubs be added?

> @@ -120,6 +122,14 @@ static struct dma_buf *dma_heap_ioctl_allocate(struc=
t file *file, void *data)
>  			if (IS_ERR(task))
>  				return ERR_CAST(task);
> =20
> +			tcred =3D get_task_cred(task);
> +			ret =3D security_dma_buf_charge_task(current_cred(), tcred);
> +			put_cred(tcred);
> +			if (ret) {
> +				put_task_struct(task);
> +				return ERR_PTR(ret);
> +			}
> +
>  			memcg =3D get_mem_cgroup_from_mm(task->mm);

[Severity: Critical]
Can passing task->mm directly to get_mem_cgroup_from_mm(task->mm) in
dma_heap_ioctl_allocate() trigger a use-after-free on struct mm_struct, or
silently charge the wrong memcg when task->mm is NULL?

When resolving heap_allocation->charge_fd via pidfd_get_task(), the caller
only holds a reference on task->usage, which does not pin task->mm. After
security_dma_buf_charge_task() returns 0, dma_heap_ioctl_allocate() reads
task->mm and passes it to get_mem_cgroup_from_mm(task->mm) without holding
task_lock(task) or acquiring an mm reference via get_task_mm(task) (a
pattern introduced in commit "dma-heap: charge dma-buf memory via explicit
memcg", modified here, and duplicated in commit "dma-buf: transfer memcg
charges via DMA_BUF_IOCTL_XFER_CHARGE").

If the target task concurrently exits via do_exit() -> exit_mm() in
kernel/exit.c (or replaces its mm during exec via exec_mmap() ->
exec_mm_put_old() in fs/exec.c), it clears task->mm under task_lock() and
drops the last reference via mmput() -> __mmdrop() -> free_mm():

	local_irq_disable();
	current->mm =3D NULL;
	membarrier_update_current_mm(NULL);
	enter_lazy_tlb(mm, current);
	local_irq_enable();
	task_unlock(current);
	mmap_read_unlock(mm);
	mm_update_next_owner(mm);
	mmput(mm);

Because mm_cachep is not SLAB_TYPESAFE_BY_RCU and __mmdrop() frees the
mm_struct immediately without an RCU grace period, get_mem_cgroup_from_mm()
in mm/memcontrol.c can dereference freed memory at mm->owner:

	rcu_read_lock();
	do {
		memcg =3D mem_cgroup_from_task(rcu_dereference(mm->owner));

In addition, if the target task is already a zombie (having completed
exit_mm() while still reachable via pidfd_get_task()) or a kernel thread,
task->mm is NULL. Even though get_task_cred(task) and
security_dma_buf_charge_task() authorized charging the target task,
get_mem_cgroup_from_mm(NULL) in mm/memcontrol.c takes the !mm fallback:

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

which silently charges current->mm (the allocating caller's own memcg) or
root_mem_cgroup instead of charging the target task's cgroup or returning
an error. Should this pin the mm with get_task_mm(task) / mmput(mm) (or
resolve the memcg from the task under rcu_read_lock() via
mem_cgroup_from_task())?

>  			put_task_struct(task);
>  		}

[Severity: High]
Should the memcg charge happen before heap->ops->allocate() allocates the
physical backing pages in dma_heap_ioctl_allocate()?

Immediately following the charge_fd resolution in drivers/dma-buf/dma-heap.=
c,
dma_heap_ioctl_allocate() invokes heap->ops->allocate() for the full
requested len before charging memcg via mem_cgroup_charge_dmabuf():

	dmabuf =3D heap->ops->allocate(heap, len, heap_allocation->fd_flags,
				     heap_allocation->heap_flags);

	if (IS_ERR(dmabuf)) {
		mem_cgroup_put(memcg);
		return dmabuf;
	}

	if (!memcg && mem_accounting)
		memcg =3D get_mem_cgroup_from_mm(current->mm);

	if (memcg) {
		if (!mem_cgroup_charge_dmabuf(dmabuf, memcg, GFP_KERNEL)) {
			mem_cgroup_put(memcg);
			dma_buf_put(dmabuf);
			return ERR_PTR(-ENOMEM);
		}
	}

Because commit "memcg: Add MEMCG_DMABUF accounting infrastructure" removed
__GFP_ACCOUNT from alloc_largest_available() in
drivers/dma-buf/heaps/system_heap.c:

		flags =3D order_flags[i];
		page =3D alloc_pages(flags, orders[i]);

system_heap_allocate() allocates and zeroes the entire buffer of size len
using uncharged alloc_pages() calls before try_charge() is evaluated in
mem_cgroup_charge_dmabuf(). Can a process inside a memory-limited cgroup
(or targeting one via charge_fd in DMA_HEAP_IOCTL_ALLOC) use this window to
exhaust host physical memory and trigger the global OOM killer before the
cgroup limit check runs?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-v2_2023012=
3_tjmercier_google_com-v2-0-ef6ee2dd8c5c@redhat.com?part=3D3

