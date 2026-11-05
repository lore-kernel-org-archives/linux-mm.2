Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 696766082BCD
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VmI46hVd
Received: by kanga.kvack.org (Postfix)
	id 944B66B05B4; Thu,  5 Nov 2026 06:12:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C886B05B5; Thu,  5 Nov 2026 06:12:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E45C6B05B6; Thu,  5 Nov 2026 06:12:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 565F86B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA691A09E1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:11:59 +0000 (UTC)
X-FDA: 85400800758.19.389C030
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 604A74000E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:11:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmI46hVd;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877118;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wL9H11c52K74bWFIToeD2nwJm/S5kppGqdHpQpDG0I=;
	b=E9iaGzjW1zm+YAhgJg56BxbCmcw5rbKiJDTdJjB/krHI9KeOaOHp0E0MuMg/ANnBBHIpax
	S2m8ia+NdWnyfFt0KDIKpDXoA1/Fnt4wcFMUid11MJZo4QvCHmjytMSpMM92wknsgsE5dn
	ZqvlwIkHnAo3uhCD5H8rgCHxcHPjBtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877118;
	b=TP+VmUyQONXFlPIk3nvqT16h9SPO1Q49FojPW6CxpkgtZdsYLEXmwEquq14eKsO8qzjfah
	ZPDQXEiz1A/c0C6Xz/J4XbQ5wkBjdmL1Tq7IEk0JZG/ihucEQf4qimHCZQz7GsWQgvteTi
	APAHRfdQclrb1wAfCS79ou8Xpkbueuo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VmI46hVd;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A812760F35;
	Thu,  5 Nov 2026 11:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31781F00A1F;
	Thu,  5 Nov 2026 11:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793877116;
	bh=5wL9H11c52K74bWFIToeD2nwJm/S5kppGqdHpQpDG0I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VmI46hVd9YGz27GAlicu7eRmyRYfUiMYWwHh8vat5Po17sPb+MebtSuE73p/uef9a
	 bi82HORDD5FyjgH0up20UJCTFGGkKmJSiIJhj1CpUAlQZjPYR3a0JFTdFfHLHtp5Ji
	 4bT/sByYe8c8teDcHOBP1GCeUTXHVP7j4P9dcS2nbGz/XDlXp9/Zj5D7VWr15cDXmj
	 yu9Scz4G1TzD11Ho+lIbkedRD3ay0Ky0uQvMD22YMX5w+PJs51+dLSm3NpKwVT4Ya6
	 JRisBkfamAp9lvl9fIB8ZUz/qYK+JvjgN4PhmpnAMGnpq2pFYipDPdVtYp8hAAcMAM
	 9+N/0uqdac1dA==
Message-ID: <sashiko-outbox-198917@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 2/8] dma-heap: charge dma-buf memory via explicit
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
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, selinux@vger.kernel.org, op-tee@lists.trustedfirmware.org, media-ci@linuxtv.org
In-Reply-To: <20261104-v2_20230123_tjmercier_google_com-v4-2-1819a017000b@redhat.com>
References: <20261104-v2_20230123_tjmercier_google_com-v4-0-1819a017000b@redhat.com>
 <20261104-v2_20230123_tjmercier_google_com-v4-2-1819a017000b@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 11:11:54 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: wnfheuxi7yphxs1bgoe4qyejfk7a1wc7
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 604A74000E
X-Rspam-User: 
X-HE-Tag: 1793877118-949117
X-HE-Meta: U2FsdGVkX1+OQ8Yl6UW6ZwRopYEHp1TBoLsEuuBene8R88h/EvsH0qzXOOGiB14Ub17k99Tevub0to9MAeHLMMJOghsSCB4tkif048SeweGB5eqmCb/VXVtRRprOycQ7im0kUthLy5nOJShNTHC2p7RzzIfW4tHETmUakKw5Mv3f/9mWHx/jpyi5GGCkRbJi7eGMR7X727SY0LZjYeUbNGu7hiy87Z72e6bBvv1lAVxDPlWjX1AvpYjr7RLU/EiBRiLwGgTpOgBHi8vebLBCRVHeNLkZrkO84v9NBcZq6LSpl65xNDeAzJbWe4JtiWOYr8/zccD/g1L4ZflmdlDREr7YHtTicm0suo4Qrh+dZz82YbnLedLOzIKTPju73s909bX9gt+atW3bVtODFSzInyF4IQ0+Fb338S94pPoTjF41WoUfbLqYA+uI/n9jHJOF9oT6TxNkerStPXX+OrkVBctDvbkAr2GFRLHhiY30n8hXu7B/AKuOosQFk2PyHAdAqTp3pBDNDS1k8cSKijVnThRWj+lRHSlVAEWIJ5VhPD0k8jstBISpMeEYtwiCdSO9JyueGqh+guXtSkVOq0rQq7led5Ar3Gxmc+tzT3H/BGA9BboSyX37gozTX3bI7X2rNk/INXvvx5lotLW8ib1GtNu+7XVnnhDPPYWP10nccCkAyDibkEK6RWkXK+WqmuGZVDFhxX36ENEo5lZ5rSBlJX2a8ohwKeLBIUlgBDo8+Rv6WXDdOLZqLhF5mTnl0NNefYwjCHDwQCCkBcjR/9hp789ibmkzH0Yzdq5udUJYv2xiTXYdGvDtfEl8hbg+/ov8zt+5eNJPEfcicPAsu2hbx8cQbhBp5xl4cwixpGSZH99BDlt7MU77zw4l2VjIkJPa7grk0V8K71ZIQpPWeq9gyBgWClafkKkZmmSxehVsUj5NJr+SMzU7W5FWEDGV+WIq0qXgtRZsETq80VmUDig
 dfPf/BaT
 2cB0zZTTn/SvAKKX5ba0/vA3v77y9mcHLgqwIxdjs0L2WmzcUxtvcB64nnkKAzGEMzu548aBtx//uPNVUCIMvElAAS4l6bvJKMWv+SZhhsD6Nkwo6XGcc3YMLxuh4Q0fAnfy/iIWWiSROIyZjafC+uc64jeRpimePEZqDkjQ+8Rij4VpvqN0WsACwy/3gSMGQw/rDXzjkwtABEiDS15P45Kd4EZ2ZN8J5dDL56FSzJUe0e36pTGp6Ska9qjexUux2ui3cYyeX6GVr+8Cer9iRfW0+ZUmeprfXGH45N64hr0obuJwpa2Uxnkbfd4s3XVZWBnkzOAsjsDhC/v9Sbm2BUi+7fWrOM3RGMEeyNdDMFgeADe6c9tboaeBbWT7TygoZ2Gk0fp+3Jzrw1EvgKIpls5v3ZIl/hJWVe5fR/+wlh8wwLaEsFcIRbOwjs4UvKti5vMUF2Lef7P4RuqhTxOhl1WM4IAsd8k1j83U80CzLlOa8CftZoGcZeC439EvwmLv32Ic+e7EcBoY7q7kMids8p9ZBoLBnibzMogWqjdRKi6YtFZIXKtL8qWxctBMTLF2+CtoF9PRQuv4Fs+d/IKYa2g3zaxIAFHW+URkSF6nYTlJUIR40Mw2lQbefHOt6KXHODU465t0Tk4FcNVzMUyR9okIyf5mWvggItNjMT5NYbqyQaL7ORUo4SVa6+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] mm: memcontrol: missing permission checks in mem_cgroup_get_fr=
om_fd()
- [High] dma-buf: system_heap: 32-bit nr_pages truncation in system_heap_al=
locate()
--

commit e390a33c5307a75778a81c2ca5beff0530617904
Author: Albert Esteve <aesteve@redhat.com>

dma-heap: charge dma-buf memory via explicit memcg

This commit adds a charge_fd field to struct dma_heap_allocation_data so
that DMA_HEAP_IOCTL_ALLOC can resolve a target pidfd or cgroupfd and charge
the exported dma-buf memory to that memcg via mem_cgroup_reserve_dmabuf().
It also removes __GFP_ACCOUNT from system heap page allocations to avoid
double counting.

> diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/=
system_heap.c
> index c8959eadc71d1..2bd245e1eab8f 100644
> --- a/drivers/dma-buf/heaps/system_heap.c
> +++ b/drivers/dma-buf/heaps/system_heap.c
[ ... ]
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

[Severity: High]
As reported by Sashiko on v3 [1], can truncating nr_pages to a 32-bit
unsigned int in system_heap_allocate() allow a 64-bit allocation length to
bypass memcg memory.max limits?

In dma_heap_ioctl_allocate(), heap_allocation->len (__u64) is page-aligned
into a 64-bit size_t len and only checked for wrap-around to zero before
being passed as an unsigned long len to system_heap_allocate():

drivers/dma-buf/dma-heap.c:dma_heap_ioctl_allocate() {
	len =3D PAGE_ALIGN(heap_allocation->len);
	if (!len) {
		mem_cgroup_put(memcg);
		return ERR_PTR(-EINVAL);
	}

	dmabuf =3D heap->ops->allocate(heap, len, heap_allocation->fd_flags,
				     heap_allocation->heap_flags, memcg);
}

In system_heap_allocate(), size_remaining retains the full 64-bit len while
nr_pages is truncated to unsigned int. Because __GFP_ACCOUNT is removed from
alloc_largest_available(), mem_cgroup_reserve_dmabuf() becomes the only
memcg limit check.

On a 64-bit system with 4 KiB pages (PAGE_SHIFT =3D=3D 12), if a user passes
len =3D (1ULL << 44) (or (1ULL << 44) + PAGE_SIZE), PAGE_ALIGN(len) >>
PAGE_SHIFT truncates in 32-bit unsigned int nr_pages to 0 (or 1).
mem_cgroup_reserve_dmabuf() then charges 0 (or 1) pages and succeeds inside
a restricted cgroup, while the while (size_remaining > 0) loop allocates
uncharged physical pages for the full 64-bit size_remaining until host RAM
is exhausted and the global OOM killer is triggered.

Similarly, in dma_buf_export() and mem_cgroup_uncharge_dmabuf(),
PAGE_ALIGN(size) >> PAGE_SHIFT is stored in an unsigned int nr_pages and
passed to mod_memcg_state(), which takes a signed int val and can overflow
to a negative delta when bit 31 of nr_pages is set. Should nr_pages be
unsigned long (or should len be bounds-checked before converting to page
counts)?

[ ... ]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e53dd7eebc3b5..17fdefc56b97f 100644
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
> +	return memcg ?: ERR_PTR(-ENOENT);
> +}

[Severity: Critical]
As reported by Sashiko on v3 [2], does mem_cgroup_get_from_fd() allow an
unprivileged caller to charge dma-buf allocations to arbitrary cgroups
without permission checks?

When dma_heap_ioctl_allocate() calls mem_cgroup_get_from_fd() with a
user-supplied charge_fd, the target mem_cgroup is resolved either from a
cgroup v2 directory fd (which can be opened with O_RDONLY | O_DIRECTORY or
O_PATH on any world-readable /sys/fs/cgroup directory, including the root
cgroup) or from a pidfd obtained via pidfd_open() for any visible process
such as PID 1.

Neither path verifies DAC permissions, cgroup write access (such as
cgroup_may_write() or cgroup_attach_permissions() used by CLONE_INTO_CGROUP
in cgroup_css_set_fork()), ptrace_may_access(), or capabilities such as
CAP_SYS_ADMIN / CAP_SYS_RESOURCE.

When system_heap_allocate() then calls mem_cgroup_reserve_dmabuf(memcg,
GFP_KERNEL, nr_pages) -> try_charge(), targeting root_mem_cgroup returns 0
immediately and bypasses the caller's memory.max and memory.high limits,
while targeting another cgroup can trigger reclaim and OOM kills in that
victim cgroup. In addition, when a remote target memcg exceeds memory.high
during try_charge_memcg(), the over-high penalty and reclaim in
__mem_cgroup_handle_over_high() are applied against current->mm's memcg
rather than the remotely charged memcg.

Later commits in the series ("security: dma-buf: Add dma_buf_charge_task LSM
hook", "security: dma-buf: Add dma_buf_charge_cgroup LSM hook", "selinux:
Restrict cross-cgroup dma-buf charging", and "selinux: Restrict dma-buf
direct cgroup charging") add LSM hooks and SELinux policy checks, but still
leave no baseline DAC, capability, cgroup write permission, or
ptrace_may_access() checks when CONFIG_SECURITY is disabled, when SELinux is
not the active LSM, or when a cgroup v2 directory uses default genfscon
labeling without an explicit security.selinux kernfs xattr (where
selinux_dma_buf_charge_cgroup() sees kernfs_xattr_get() =3D=3D -ENODATA and
returns 0).

Should baseline permission checks be enforced before allowing a process to
charge memory to another task's or cgroup's memcg?

[1] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
2-78d2c4cb8647@redhat.com
[2] https://lore.kernel.org/r/20261027-v2_20230123_tjmercier_google_com-v3-=
2-78d2c4cb8647@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104-v2_2023012=
3_tjmercier_google_com-v4-0-1819a017000b@redhat.com?part=3D2

