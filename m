Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 010B4CD4F47
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:53:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C746B0005; Fri, 15 May 2026 09:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCC56B0088; Fri, 15 May 2026 09:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC5B6B008C; Fri, 15 May 2026 09:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 068746B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:53:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6C973120109
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:53:56 +0000 (UTC)
X-FDA: 84769797672.11.1F7247D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id C42DE140009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:53:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A1yx1trM;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778853234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ivwI5IiIhvErdZ7E6I20QYu6EcfGGvw7nsC4oDYXYqc=;
	b=sGvj6VCiGWwECh/QtfD0X48Ma5E/ICbmUDcKkVoAWGDWcHXJjJeT14zFb/S8VGnQ1/7YUm
	ElCfujHOq3KTeqDWEr5mgPRe982qZKwUtkqFlHuztFW192F8FIk9g+zRwv2Q2ZZM6b9vxq
	yIzyeT/exJ3M48tt3wSDg6yUWGnnBMs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778853234; a=rsa-sha256;
	cv=none;
	b=g3KwPQedKMppHc6pmA7x0d4Om+LknSv6pqmxLI9BkkfUy2AliH3cwKtttpXgtDuAkMe1FP
	5isqYmHLa6UsnzOhHFPL+SWF6lVSeyU2jvGpotxmoQSzWakU2crDJdmh8+FScAHSpOUgMQ
	dOGc+aOhkXuNVHLFpJKiLTSiix4RQ0I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=A1yx1trM;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F061B60138;
	Fri, 15 May 2026 13:53:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BFFC2BCB0;
	Fri, 15 May 2026 13:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778853233;
	bh=Y1gyeosz2qkHMid+rX2ftXz6wmVUtQk3hZVNk9+H5Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A1yx1trMAuX4uPgzq30KugkFgBWvGkQ00OTXt4fD7QZY9PIT7MWK279StfLyH0/ZK
	 wR0mCQGAASYvb7XRaKka7b3eG8xalsI55aG1urnDe8Xf2zeqgl1tKvsweZ6RBSz4du
	 Q3dLgvgGJpG//hSbnYPnx4RlJvQyFnt4udgMSCIdKH90bPm2vP3+wpECg63GzaGLE/
	 Ckf/8qWWNBeLmb5/xKUFUR/o+ko9JQJ1t42RauAVv7nFmWoC3C+QX/AZ5TCI9Y/omB
	 70ruKCdTp3nOv0v8ubEIYX1iGJeLH0F4V/f3kALZbYJe19fguIjBCczEgBZZxKDaAz
	 1ZHsw2Kh1vAlg==
Date: Fri, 15 May 2026 15:53:42 +0200
From: Christian Brauner <brauner@kernel.org>
To: Albert Esteve <aesteve@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	mripard@kernel.org, echanude@redhat.com
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit
 memcg
Message-ID: <20260515-hinschauen-effizient-9e3a05a94f2e@brauner>
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C42DE140009
X-Stat-Signature: d9do6hnzwcp5b4kctgkfb45zhwhh5qab
X-Rspam-User: 
X-HE-Tag: 1778853234-877535
X-HE-Meta: U2FsdGVkX1+0nieWX2sormb3LICMaCx+jK1S0RXR2wyJjic1NPl0t69G+ukXl563+hBRo6qkxJKmHcsRs9u8eNZNcdO3MudUruwjPRqCbhOMYZsjJz6VUnUZ3hOswhLaGnAATX/DirCPEL0Iz3VGqZaE+0eaRrpMlQPw/B8MiLC+GQ0LA6O2WNwOzurEu88t5IO5nzBwWyK74MT25UuyiybTfQnkjSuEo59XaZMHhjnfyzG+5tzj27JLYo5A4w8bkzGRoXsN5haQeaEv82R/f616zkllfm188f0CDn7iFlgwzlYh5Nq9WEZzjy7l/moDqc91jcmTWVBTGjE7qV1rAOmaEjjBfy8j00CRmYtKaFrJ9/lsNaSiEmfnt0MQJw2BQbxv+7VRh0FDoptD1xpbcTxvgqEJ3vjo16rFyZCUF/SeXGVvtGgsuQKnIEEPycn9Dc0PxvSZak3fAEdmqIRo6+ieWj0eLHo+jhGxN2Wag1ar3PGbrWe2xJAmULEqFyzyQuDAF7Hke4uJqltIaqhOZZXRA69yiQCOJYLjnoI8/zmxrXgjGc1rBq4Q6maU0xi2G1a1q0Oy1Qo5TUvxxee0gla2p+DKBAjyiiqQFFHdopf+uglatW47udm0MLsYdAQW96BYfdci+b+5bx//ypUVL1pGEuwBZ1XQGmC08DlVcBYK4DPQI7kjhtShOooEOyZe3Dp/pres+joHIgwtEnJSfxuQZ2VEt+K4ot1fhlK1uNf/Fojo+IfL59yG1/QK0tUG9bSFn7+RVnZONwf+yNUyL2GAo07Y0h2n9GG+ofzDg9D3M5Hq1hcGcUnZyQhf32x8Do6Q9TS0wxjjlJgvPiKYkS5q+tgzBCCitu+gmDUseq8JMGJahlKb1bSFcuxIzgJbyTNg2SWpJytMYfw9CqeKpOqSDHEXrWtRpIZp5k4DaWooA93vfq4vQdDIGr07UnZfQVn5wkd3SINKrW87uqG
 TvX8Qd+s
 UqnaXj5UVqW11aPTy7yRdWzokkhLfoEq4gNzAPL6EgVPmpNfZdFb19b/ooLeS/SEhiauDdEmPbFIqCmzFjCv2dRdH4VGW+c5N+oze8e/vxc7jsQLWUUDH0So0M+6O7nVNT6SqExqK3pirZ41ZhAkBtnFoDo5/DXnsf3lkbUhWWg0jSDTyBNoiBk9tk+GddOP93SPoIo/Jb7OjyK1aQocFhTymWuujHljAuxGUUn5XQCuJGfTTBLgGF1EffhcyCXc4bqUON225nsQZmqYjFlCAtKeGuYLB58YnUEAkuRgM5NBjbjOJ7kXnx1dl8wd/9jAmkXrdFuexUpxD5G46c/k/DXouSRquOEI8xubMQRDSX5gjqcOPAzibThUZaIum1Gv2Zk7YvJoOkoi1xRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 11:10:44AM +0200, Albert Esteve wrote:
> On embedded platforms a central process often allocates dma-buf
> memory on behalf of client applications. Without a way to
> attribute the charge to the requesting client's cgroup, the
> cost lands on the allocator, making per-cgroup memory limits
> ineffective for the actual consumers.
> 
> Add charge_pid_fd to struct dma_heap_allocation_data. When set to

Please be aware that pidfds come in two flavors:

thread-group pidfds and thread-specific pidfds. Make sure that your API
doesn't implicitly depend on this distinction not existing.


> a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> the mem_accounting module parameter enabled, the buffer is charged
> to the allocator's own cgroup.
> 
> Additionally, commit 3c227be90659 ("dma-buf: system_heap: account for
> system heap allocation in memcg") adds __GFP_ACCOUNT to system-heap
> page allocations. Keeping __GFP_ACCOUNT would charge the same pages
> twice (once to kmem, once to MEMCG_DMABUF), thus remove it and route
> all accounting through a single MEMCG_DMABUF path.
> 
> Usage examples:
> 
>   1. Central allocator charging to a client at allocation time.
>      The allocator knows the client's PID (e.g., from binder's
>      sender_pid) and uses pidfd to attribute the charge:
> 
>        pid_t client_pid = txn->sender_pid;
>        int pidfd = pidfd_open(client_pid, 0);
> 
>        struct dma_heap_allocation_data alloc = {
>            .len             = buffer_size,
>            .fd_flags        = O_RDWR | O_CLOEXEC,
>            .charge_pid_fd   = pidfd,
>        };
>        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
>        close(pidfd);
>        /* alloc.fd is now charged to client's cgroup */
> 
>   2. Default allocation (no pidfd, mem_accounting=1).
>      When charge_pid_fd is not set and the mem_accounting module
>      parameter is enabled, the buffer is charged to the allocator's
>      own cgroup:
> 
>        struct dma_heap_allocation_data alloc = {
>            .len      = buffer_size,
>            .fd_flags = O_RDWR | O_CLOEXEC,
>        };
>        ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc);
>        /* charged to current process's cgroup */
> 
> Current limitations:
> 
>  - Single-owner model: a dma-buf carries one memcg charge regardless of
>    how many processes share it. Means only the first owner (and exporter)
>    of the shared buffer bears the charge.
>  - Only memcg accounting supported. While this makes sense for system
>    heap buffers, other heaps (e.g., CMA heaps) will require selectively
>    charging also for the dmem controller.
> 
> Signed-off-by: Albert Esteve <aesteve@redhat.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst |  5 ++--
>  drivers/dma-buf/dma-buf.c               | 16 ++++---------
>  drivers/dma-buf/dma-heap.c              | 42 ++++++++++++++++++++++++++++++---
>  drivers/dma-buf/heaps/system_heap.c     |  2 --
>  include/uapi/linux/dma-heap.h           |  6 +++++
>  5 files changed, 53 insertions(+), 18 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 8bdbc2e866430..824d269531eb1 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1636,8 +1636,9 @@ The following nested keys are defined.
>  		structures.
>  
>  	  dmabuf (npn)
> -		Amount of memory used for exported DMA buffers allocated by the cgroup.
> -		Stays with the allocating cgroup regardless of how the buffer is shared.
> +		Amount of memory used for exported DMA buffers allocated by or on
> +		behalf of the cgroup. Stays with the allocating cgroup regardless
> +		of how the buffer is shared.
>  
>  	  workingset_refault_anon
>  		Number of refaults of previously evicted anonymous pages.
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index ce02377f48908..23fb758b78297 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -181,8 +181,11 @@ static void dma_buf_release(struct dentry *dentry)
>  	 */
>  	BUG_ON(dmabuf->cb_in.active || dmabuf->cb_out.active);
>  
> -	mem_cgroup_uncharge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->size) / PAGE_SIZE);
> -	mem_cgroup_put(dmabuf->memcg);
> +	if (dmabuf->memcg) {
> +		mem_cgroup_uncharge_dmabuf(dmabuf->memcg,
> +					  PAGE_ALIGN(dmabuf->size) / PAGE_SIZE);
> +		mem_cgroup_put(dmabuf->memcg);
> +	}
>  
>  	dmabuf->ops->release(dmabuf);
>  
> @@ -764,13 +767,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  		dmabuf->resv = resv;
>  	}
>  
> -	dmabuf->memcg = get_mem_cgroup_from_mm(current->mm);
> -	if (!mem_cgroup_charge_dmabuf(dmabuf->memcg, PAGE_ALIGN(dmabuf->size) / PAGE_SIZE,
> -				      GFP_KERNEL)) {
> -		ret = -ENOMEM;
> -		goto err_memcg;
> -	}
> -
>  	file->private_data = dmabuf;
>  	file->f_path.dentry->d_fsdata = dmabuf;
>  	dmabuf->file = file;
> @@ -781,8 +777,6 @@ struct dma_buf *dma_buf_export(const struct dma_buf_export_info *exp_info)
>  
>  	return dmabuf;
>  
> -err_memcg:
> -	mem_cgroup_put(dmabuf->memcg);
>  err_file:
>  	fput(file);
>  err_module:
> diff --git a/drivers/dma-buf/dma-heap.c b/drivers/dma-buf/dma-heap.c
> index ac5f8685a6494..ff6e259afcdc0 100644
> --- a/drivers/dma-buf/dma-heap.c
> +++ b/drivers/dma-buf/dma-heap.c
> @@ -7,13 +7,17 @@
>   */
>  
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
>  #include <linux/nospec.h>
> +#include <linux/pidfd.h>
>  #include <linux/syscalls.h>
>  #include <linux/uaccess.h>
>  #include <linux/xarray.h>
> @@ -55,10 +59,12 @@ MODULE_PARM_DESC(mem_accounting,
>  		 "Enable cgroup-based memory accounting for dma-buf heap allocations (default=false).");
>  
>  static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len,
> -				 u32 fd_flags,
> -				 u64 heap_flags)
> +				 u32 fd_flags, u64 heap_flags,
> +				 struct mem_cgroup *charge_to)
>  {
>  	struct dma_buf *dmabuf;
> +	unsigned int nr_pages;
> +	struct mem_cgroup *memcg = charge_to;
>  	int fd;
>  
>  	/*
> @@ -73,6 +79,22 @@ static int dma_heap_buffer_alloc(struct dma_heap *heap, size_t len,
>  	if (IS_ERR(dmabuf))
>  		return PTR_ERR(dmabuf);
>  
> +	nr_pages = len / PAGE_SIZE;
> +
> +	if (memcg)
> +		css_get(&memcg->css);
> +	else if (mem_accounting)
> +		memcg = get_mem_cgroup_from_mm(current->mm);
> +
> +	if (memcg) {
> +		if (!mem_cgroup_charge_dmabuf(memcg, nr_pages, GFP_KERNEL)) {
> +			mem_cgroup_put(memcg);
> +			dma_buf_put(dmabuf);
> +			return -ENOMEM;
> +		}
> +		dmabuf->memcg = memcg;
> +	}
> +
>  	fd = dma_buf_fd(dmabuf, fd_flags);
>  	if (fd < 0) {
>  		dma_buf_put(dmabuf);
> @@ -102,6 +124,9 @@ static long dma_heap_ioctl_allocate(struct file *file, void *data)
>  {
>  	struct dma_heap_allocation_data *heap_allocation = data;
>  	struct dma_heap *heap = file->private_data;
> +	struct mem_cgroup *memcg = NULL;
> +	struct task_struct *task;
> +	unsigned int pidfd_flags;
>  	int fd;
>  
>  	if (heap_allocation->fd)
> @@ -113,9 +138,20 @@ static long dma_heap_ioctl_allocate(struct file *file, void *data)
>  	if (heap_allocation->heap_flags & ~DMA_HEAP_VALID_HEAP_FLAGS)
>  		return -EINVAL;
>  
> +	if (heap_allocation->charge_pid_fd) {
> +		task = pidfd_get_task(heap_allocation->charge_pid_fd, &pidfd_flags);

Will always get a thread-group leader pidfd and will fail if this is a
thread-specific pidfd. pidfd_open(1234, PIDFD_THREAD) can be used to
open a thread-specific pidfd.

> +		if (IS_ERR(task))
> +			return PTR_ERR(task);
> +
> +		memcg = get_mem_cgroup_from_mm(task->mm);
> +		put_task_struct(task);
> +	}
> +
>  	fd = dma_heap_buffer_alloc(heap, heap_allocation->len,
>  				   heap_allocation->fd_flags,
> -				   heap_allocation->heap_flags);
> +				   heap_allocation->heap_flags,
> +				   memcg);
> +	mem_cgroup_put(memcg);
>  	if (fd < 0)
>  		return fd;
>  
> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
> index 03c2b87cb1112..95d7688167b93 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
> @@ -385,8 +385,6 @@ static struct page *alloc_largest_available(unsigned long size,
>  		if (max_order < orders[i])
>  			continue;
>  		flags = order_flags[i];
> -		if (mem_accounting)
> -			flags |= __GFP_ACCOUNT;
>  		page = alloc_pages(flags, orders[i]);
>  		if (!page)
>  			continue;
> diff --git a/include/uapi/linux/dma-heap.h b/include/uapi/linux/dma-heap.h
> index a4cf716a49fa6..e02b0f8cbc6a1 100644
> --- a/include/uapi/linux/dma-heap.h
> +++ b/include/uapi/linux/dma-heap.h
> @@ -29,6 +29,10 @@
>   *			handle to the allocated dma-buf
>   * @fd_flags:		file descriptor flags used when allocating
>   * @heap_flags:		flags passed to heap
> + * @charge_pid_fd:	optional pidfd of the process whose cgroup should be
> + *			charged for this allocation; 0 means charge the calling
> + *			process's cgroup
> + * @__padding:		reserved, must be zero
>   *
>   * Provided by userspace as an argument to the ioctl
>   */
> @@ -37,6 +41,8 @@ struct dma_heap_allocation_data {
>  	__u32 fd;
>  	__u32 fd_flags;
>  	__u64 heap_flags;
> +	__u32 charge_pid_fd;
> +	__u32 __padding;
>  };
>  
>  #define DMA_HEAP_IOC_MAGIC		'H'
> 
> -- 
> 2.53.0
> 

