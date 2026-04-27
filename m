Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B264EFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F253A6B0005; Mon, 27 Apr 2026 03:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC8B6B0088; Mon, 27 Apr 2026 03:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39176B008A; Mon, 27 Apr 2026 03:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2B766B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:56:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B99D1A07FD
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:56:28 +0000 (UTC)
X-FDA: 84703578456.07.96EC7B3
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BC151A0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:56:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4S5OJ67;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777276587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srNLnD8+s9OliipECDwqoPjWKvlwyPl55SmJ7/0HSYQ=;
	b=SuEcK7Uc5o+CQ8jG+YPqWVjV5eK7im/CPivHJZSQPschVorjmCnBMof9lzC23LiP7w3y18
	MtFZqQW+bPWniywgmlmgvGRcCq+cpO5lSah1t3sGxUbIrQhJ5Xwzudr5Thqns/mou2ecQp
	UAGD+XJLy7uBUnaAiVlphEiXG1QShL4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K4S5OJ67;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777276587; a=rsa-sha256;
	cv=none;
	b=jtC1XlcmAdDE+Tcnb3J8OHM5zLVdgRvoSwMFRSqhD+BSi+AhnYCWcW+z0BHyybVPjfLMHM
	7nh4NUdlOkU+Qg7XKX1isB85prs9BA+VwvINV3XXHqkgSu8377KYnB3Tpzcd/qm88TDyug
	Cqkmp0RTEk/XF0I+5EnyK+7ZvL6GUtY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777276581;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=srNLnD8+s9OliipECDwqoPjWKvlwyPl55SmJ7/0HSYQ=;
	b=K4S5OJ67U8gyj75430b7Hm2IHdAalie/0+hRyASPyhuoLIoag6cMS1fT/4Kf5mqEH/u7MN
	nDWYN7ZghYLtpM+MQCM97uk7ztsZPHUrhmemTxDM8aJR8LK8es3CyeFmAAvy8ywTlAE6OG
	D5Rp+2kbrpNyBe3/M1wepTLpgeFUKmM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [RFC PATCH] mm/hugetlb: fix resv_map memory leak in __mmap_region
 error path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260425070700.562229-1-25181214217@stu.xidian.edu.cn>
Date: Mon, 27 Apr 2026 15:55:00 +0800
Cc: Liam.Howlett@oracle.com,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 ljs@kernel.org,
 vbabka@kernel.org,
 jannh@google.com,
 pfalcato@suse.de,
 osalvador@suse.de,
 david@kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BCFCF1D6-8F39-4E60-AD86-0ECF799FFD9D@linux.dev>
References: <20260425070700.562229-1-25181214217@stu.xidian.edu.cn>
To: Mingyu Wang <25181214217@stu.xidian.edu.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BC151A0007
X-Stat-Signature: o9818hqwjzz94tjrjz7tqxze9t7ghh71
X-HE-Tag: 1777276584-192301
X-HE-Meta: U2FsdGVkX19/ulh4B7HWxo7gS1FiOWXzSb3cLTLBSlIi91F8wUppLqxmvywx5o4PiMZDfZ/qds9LOy8t64BzYgUxY04Sz9eIFf0S+D4IPbGa3ty1pVsu0gimEeSInx0kwLM44ZDJNFgSSi3EqCTyUmDF/b8lLF0+eEeIfcnb8HU5RIt5sI0o+YdEy0d+hRrlDqaPB2ZfNM1m5oofGEpPKTUDGB/r7Ogwuijs5Kw72hXcEeJ8Mv79dSsmV+TAE9OqLCIf2LMtIM1nGqQQFmFvslIWLSuHBlwzrHKB2wzP20N3w0KuVP3C2fSKzKmBZdgynB8Dc2t5QTmkIhhx4UlbcF/PXZt58ZEGg+M8Kx0UHH4l4Mko3iWwPp83FVCPYJCjp6rXVnq7ntHkInZWnQBddZDQJeDusHQAVwfgN6ZOKshVQ909yavF5fLOLSN2WMtYYXm8dcCZo3fYKL3zzbUdunnvFA5Dhz+JMptZkTB0KHss/ubtM1Y9RkpjnDbYLNjvO8jTLBAMgsdNrLUW8ppZMysg05MsF1CMIOODO3TTnOv3Nxwk2PNyP6G83VfMu+Addhs7sW36Vfc49DYqGUcrGDJtc1Y+rQKbUXmjbL7VnhQTvGQQYSzWtMvSnH8qoO9BRk/BVB972TOX/lP4rsEjkJPfZdzoKWAa2UYU8D3DGZuDKO8Wg+3GA2tv3nxTAY9145/jAC+yIEvipfIjT+zY0In1hzS392rY3q+cMwgEVZBRZOUEQhdIO7N7AGbDe/AOltZc0AZopYLqlfTj7c1qDh1BYvQnnecPj7l42LzkMpjcWUA77ji+yJGLiYCVtyf+XMlVOSr57jdokhReAFgRni0DQevTi6Fs+fgFmzt2GWpBq6CR3dVE9y6cNZ0rQbJ0xFEKGPtSXCTMq4KVYIa5uxEqTXgakuulT1aQ+bqaWJhg2T7AEhwPihXdKetncGnkx+d3h/ctGvZSuv6Dp97
 2Uq3MuSi
 JbsvimSAtA7CbpYkZDqb95lX4W6BBK74Pdm3Jpz29/XL7dFmvnJyBRk5zF6wPTKrY3h+WfmbJJq8akzDm6F/C/REu7jh7fQn8dG8Aq3Ig+8teOerC3BTDl6rHtSGJ06QpnIrD4g5pEuAcxYSPJ/QyI2x3/Quh/G1L3yX9nBRnevSlGKYyGzLMV9mnIDhXrjG0b/XsuHW1ra0GdKe+eEjLRMFyQ8X4QOHEaQAVKEsJ9sNyeyRo9+kn6H7+TmjMdrsH0xQr6ENyVTtb+Dg5azKhnYIwmwZ+3YcIW9hW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> On Apr 25, 2026, at 15:07, Mingyu Wang <25181214217@stu.xidian.edu.cn> =
wrote:
>=20
> While fuzzing with Syzkaller and fault injection (failslab) enabled,
> I observed a persistent resv_map memory leak in the hugetlb mmap error =
path.
>=20
> BUG: memory leak
> unreferenced object 0xffff888110b92400 (size 512):
>  comm "syz.0.5386", pid 20390, jiffies 4298157188
>  backtrace:
>    __kmalloc_cache_noprof+0x509/0x6e0
>    resv_map_alloc+0x47/0x3a0
>    hugetlb_reserve_pages+0x758/0x1220
>    hugetlbfs_file_mmap_prepare+0x492/0x790
>    __mmap_region+0x1ae6/0x29f0
>=20
> This is a regression introduced by the recent VMA iterator and mmap =
region
> refactoring, which decoupled mmap preparation from VMA completion.
>=20
> In `__mmap_region()`, `call_mmap_prepare()` triggers =
`hugetlbfs_file_mmap_prepare()`,
> which successfully allocates the `resv_map` and registers a =
`success_hook`
> in `desc->action`.
>=20
> If `__mmap_new_vma()` subsequently fails (e.g., `vma_iter_prealloc()`
> returns -ENOMEM due to failslab), the code jumps to `abort_munmap`.
> However, the `desc` structure is completely discarded without invoking
> any cleanup. The newly allocated empty VMA is freed, but since
> `set_vma_user_defined_fields()` was never reached, `vm_area_free()`
> doesn't call `hugetlb_vm_close()`. Thus, the `resv_map` is permanently =
leaked.
>=20
> This RFC proposes adding an `abort_hook` to `struct mmap_action`
> so that subsystems can properly clean up resources allocated during =
the
> `mmap_prepare` phase if VMA creation fails.
>=20
> Any feedback on whether this architectural approach is correct, or how =
to=20
> properly implement the hugetlb unreserve rollback, would be highly =
appreciated.

Please use ./scripts/get_maintainer.pl to get full mail list for Cc/To =
since
it is not only related to HugeTLB subsystem. It will also consider the =
author
of commit introducing the problem.

>=20
> Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
> ---
> fs/hugetlbfs/inode.c     | 9 +++++++++
> include/linux/mm_types.h | 2 ++
> mm/vma.c                 | 4 ++++
> 3 files changed, 15 insertions(+)
>=20
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 8b05bec08e04..002bb6d9ca23 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -102,6 +102,14 @@ static int =
hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
> return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
> }
>=20
> +static void hugetlb_file_mmap_prepare_abort(struct vm_area_desc =
*desc)
> +{
> + 	/*
> +	 * TODO: Implement the proper rollback for =
hugetlb_reserve_pages()
> +	 * and drop the resv_map reference held in the desc here.
> +	 */
> +}
> +
> static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
> {
> struct file *file =3D desc->file;
> @@ -172,6 +180,7 @@ static int hugetlbfs_file_mmap_prepare(struct =
vm_area_desc *desc)
> 	if (!ret) {
> 	/* Allocate the VMA lock after we set it up. */
> 	desc->action.success_hook =3D hugetlb_file_mmap_prepare_success;
> + 	desc->action.abort_hook =3D hugetlb_file_mmap_prepare_abort;
> 	/*
> 	 * We cannot permit the rmap finding this VMA in the time
> 	 * between the VMA being inserted into the VMA tree and the
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index a308e2c23b82..9320f6699fa9 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -861,6 +861,8 @@ struct mmap_action {
> * it is not valid to clear the error here.
> */
> 	int (*error_hook)(int err);
> +=20
> + 	void (*abort_hook)(struct vm_area_desc *desc);

At least for me, it is not good name to distinguish it from error_hook.
abort_mmap_prepare? I am not sure if it is a good solution, Cc other
MM maintainers as well.

Muchun,
Thanks.

>=20
> /*
> * This should be set in rare instances where the operation required
> diff --git a/mm/vma.c b/mm/vma.c
> index 377321b48734..d64cea5b4335 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2799,6 +2799,10 @@ static unsigned long __mmap_region(struct file =
*file, unsigned long addr,
> */
> 	if (map.file_doesnt_need_get)
> 		fput(map.file);
> +=20
> + 	if (have_mmap_prepare && desc.action.abort_hook)
> + 		desc.action.abort_hook(&desc);
> +=20
> 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> 	return error;
> }
> --=20
> 2.34.1
>=20


