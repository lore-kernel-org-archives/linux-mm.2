Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C94BFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C597A6B008A; Mon, 27 Apr 2026 10:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C30A56B008C; Mon, 27 Apr 2026 10:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6EE96B0092; Mon, 27 Apr 2026 10:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A83036B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:18:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0579A1C01AE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:18:43 +0000 (UTC)
X-FDA: 84704541726.10.B1976CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3660920015
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:18:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XPy6ZXkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777299521; a=rsa-sha256;
	cv=none;
	b=zTXA/VnmovAFZwmXN0hqRMEl/ZdOEwY9u0mGRt1BrAyQppzlTbCU2HuhgUx4VKbVCnfdie
	zqoHGZm3m8aFBxI8TWZiuN85uYV9HdGHfpq1PRbsPhxHBEuTv3ZqGZpQZIlm6TsOlysBYZ
	HHqFUSX+IhYfdUhUmd5t2Bffz3O0Pfg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XPy6ZXkA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777299521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ji5pC6owolBIYU4bB24ouYRDxvvVgAQBxoU8fSA39c=;
	b=E+qK0aw0L8yw+PN028IC+1eTnms/z9B1Qt50OqX+65/H6oB5KG5NDiT+bPYaWlLg5KFgfE
	bFvYEcyLObFvQz4zEedz2LyvuPU2KCBlRC04iBMPIFWmPsPq1O/TasDfc7R4FYw4BtynPl
	hxk18Kz4lzGPtHF7/EqHQmUlJArQ9eI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16DCC43A9D;
	Mon, 27 Apr 2026 14:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626BCC19425;
	Mon, 27 Apr 2026 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777299520;
	bh=l7cPruqxRuL8cZDdPdNmuQwTk7T49Y8JS67+jg/DKN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XPy6ZXkAopreXAZMZdUpKYx97gPmDjCSm7GpXKBJFSMKpsRHgcT2N9o/2W7UL8OKL
	 lLo8VvooPGdG8loUz1AkIQRscUTQCJWxhglQiEAKCe5WcmblkPnxvn+wj7DMwbvekq
	 jDRaW+S06syAiDvZ3yIpaHQ7bnomqY9IkT2+Xi2nUW0NB9m8qxZDH07LNXOwA4cNtX
	 5vh+4bcuP/ORz2FrtKgYm8WTEVeHcPTU0dq2ywoe4YyHSU9RyUAP+RXYgjnwVFurQv
	 Lb+RI9DQUyFfxsbWhAphc47Kp1vSN6/75dW+CQoJJJ3AIddz5px2VPnKp3E9J1aghE
	 GDTwsjGIpqp2g==
Date: Mon, 27 Apr 2026 15:18:34 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Mingyu Wang <25181214217@stu.xidian.edu.cn>, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, 
	david@kernel.org
Subject: Re: [RFC PATCH] mm/hugetlb: fix resv_map memory leak in
 __mmap_region error path
Message-ID: <ae9tVZbNFtBBet8f@lucifer>
References: <20260425070700.562229-1-25181214217@stu.xidian.edu.cn>
 <BCFCF1D6-8F39-4E60-AD86-0ECF799FFD9D@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BCFCF1D6-8F39-4E60-AD86-0ECF799FFD9D@linux.dev>
X-Stat-Signature: 4oj36agw6ymonpai3xz1acfeyuf6g7ih
X-Rspam-User: 
X-Rspamd-Queue-Id: 3660920015
X-Rspamd-Server: rspam07
X-HE-Tag: 1777299520-835151
X-HE-Meta: U2FsdGVkX1+CgjW6uabUlGT/f/GyWxrgp+feBzJNfLq6mmxelZmygNxJEQ4/BA3+3/iXsZ3+f2z8oEKaNL/v1d324h7ng37xq6Et67y9tRFTfXQtIEy8i5sG1WjaWlPQl/hgGk08LbDP0tFbBFm2FmSESUFQQysLvVxND+mcXkFutfnskl++sWQkT3H62vLXPhS7K1ktmezaarvGgav0hbH3EmC1o7nKTEhsHpnnHeyG8Oai3BhTDC6H2pQIzS3Y21+PdumogxtW3tnk7epnotM8vrXHFjzm/7nsE2/ccgbgdkvKKhNB0CyMz2o2CVE2Xy2Uyanm8rvX8YV0DVgMYh9U2QDWc0zQt3Cd0VzWH2+A+rhs79cKUYNJeIi+N0iKJJ9LNIHGjp41MFQoBHI/vCJ0LqhYo9iDqbwOA0R38KJH4Hqk/Qipj1vrVi1HJCQboAeeFC0PCibBw4NZUlSdfGBME8EwhWdGrxE0SAUZy8dWx1XyLT+zV6uyDmpVbOgG43ekYFlnRz5DBrCGWqIXhg3D7BA7XT5fDhOJ8c39tbffy1N5u91HZXaQdFu/41BW7/E0X70O4b4kijbyd5pcCOf+zPh6f7rZW53n/wDpLIgbd8kADFEcCjvnQEFcCnYA6zlZvIjsGACEnecab3xnRLbyOEetRu8B6etBgvh7jd8OSce8dwuPggJf1K5tV/+6NDeeYaUOpm54ZtYlbq40yVZ5DtQLbDK/mKOar8PMtvqRtJqwxDL1IeORfmaa7/PtyXy/WGrLt8eCtyaCzZOH4k0nR8NfKjep84vusCEo9xXSx8exKbNY4sFwHGWSxJlGx50zTSHQt3GhFcALtCQUiKlgQIpGoerp4SyVxBmLPyFdhBFetCVsFdMLu0EWZOMajW58ZHaPNKzJq0cjm30Qy8a5OiOw929qXLAx4fghfhS7gs5qRROXHPVMRp0apNJ4mg0OFkgzsryjcXEtAvh
 RsKagjrv
 nyQOwxgBzlETmgZEyNIvVZqmXAxyCD2GlVn4f0N42jIFp/RjDX1jknKDQvwZj0tCRpB/b7dBp0UDpM47shoS+yZ/QsBVlYGV8C/u5tMl4YHt2o0SJX8SUfpSS7Qx+Xuvj+M/KMvUbX8gL4LtwFXpdEKUi/5AuDemqNM7QRCr1MCtefCoNK+dZ+0kSY/GZ2knogPzFEgzxTI/yg8gVIrOCUyI7T0fPIg2xW/fIbYH5q8mTVySK/TlpeHiFWqRUFsk8AHhdRj5Wx08U1DDe028nDexgP0i7o5DkaZ/ELMJeeqIx2Ow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Mon, Apr 27, 2026 at 03:55:00PM +0800, Muchun Song wrote:
>
> > On Apr 25, 2026, at 15:07, Mingyu Wang <25181214217@stu.xidian.edu.cn> wrote:
> >
> > While fuzzing with Syzkaller and fault injection (failslab) enabled,
> > I observed a persistent resv_map memory leak in the hugetlb mmap error path.
> >
> > BUG: memory leak
> > unreferenced object 0xffff888110b92400 (size 512):
> >  comm "syz.0.5386", pid 20390, jiffies 4298157188
> >  backtrace:
> >    __kmalloc_cache_noprof+0x509/0x6e0
> >    resv_map_alloc+0x47/0x3a0
> >    hugetlb_reserve_pages+0x758/0x1220
> >    hugetlbfs_file_mmap_prepare+0x492/0x790
> >    __mmap_region+0x1ae6/0x29f0
> >
> > This is a regression introduced by the recent VMA iterator and mmap region
> > refactoring, which decoupled mmap preparation from VMA completion.
> >
> > In `__mmap_region()`, `call_mmap_prepare()` triggers `hugetlbfs_file_mmap_prepare()`,
> > which successfully allocates the `resv_map` and registers a `success_hook`
> > in `desc->action`.
> >
> > If `__mmap_new_vma()` subsequently fails (e.g., `vma_iter_prealloc()`
> > returns -ENOMEM due to failslab), the code jumps to `abort_munmap`.
> > However, the `desc` structure is completely discarded without invoking
> > any cleanup. The newly allocated empty VMA is freed, but since
> > `set_vma_user_defined_fields()` was never reached, `vm_area_free()`
> > doesn't call `hugetlb_vm_close()`. Thus, the `resv_map` is permanently leaked.
> >
> > This RFC proposes adding an `abort_hook` to `struct mmap_action`
> > so that subsystems can properly clean up resources allocated during the
> > `mmap_prepare` phase if VMA creation fails.

Yeah sorry, this is a general problem that I addressed already with the
vm_ops->mapped callback.

I'll come up with a patch to fix this up for hugetlb, thanks for highlighting
this.

I plan to get rid of the success hook in any case, it's only because hugetlb is
doing something really... not great with the 'VMA lock' (really hugetlb VMA lock
I suppose) that we need a VMA pointer at the point.

> >
> > Any feedback on whether this architectural approach is correct, or how to
> > properly implement the hugetlb unreserve rollback, would be highly appreciated.
>
> Please use ./scripts/get_maintainer.pl to get full mail list for Cc/To since
> it is not only related to HugeTLB subsystem. It will also consider the author
> of commit introducing the problem.

Please do do that, I wrote this whole thing, so y'know :)

Especially at the moment I am very very busy with LSF coming up so you need to
make sure you include me in the mail.

>
> >
> > Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
> > ---
> > fs/hugetlbfs/inode.c     | 9 +++++++++
> > include/linux/mm_types.h | 2 ++
> > mm/vma.c                 | 4 ++++
> > 3 files changed, 15 insertions(+)
> >
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index 8b05bec08e04..002bb6d9ca23 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -102,6 +102,14 @@ static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
> > return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
> > }
> >
> > +static void hugetlb_file_mmap_prepare_abort(struct vm_area_desc *desc)
> > +{
> > + 	/*
> > +	 * TODO: Implement the proper rollback for hugetlb_reserve_pages()
> > +	 * and drop the resv_map reference held in the desc here.
> > +	 */
> > +}
> > +
> > static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
> > {
> > struct file *file = desc->file;
> > @@ -172,6 +180,7 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
> > 	if (!ret) {
> > 	/* Allocate the VMA lock after we set it up. */
> > 	desc->action.success_hook = hugetlb_file_mmap_prepare_success;
> > + 	desc->action.abort_hook = hugetlb_file_mmap_prepare_abort;
> > 	/*
> > 	 * We cannot permit the rmap finding this VMA in the time
> > 	 * between the VMA being inserted into the VMA tree and the
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index a308e2c23b82..9320f6699fa9 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -861,6 +861,8 @@ struct mmap_action {
> > * it is not valid to clear the error here.
> > */
> > 	int (*error_hook)(int err);
> > +
> > + 	void (*abort_hook)(struct vm_area_desc *desc);
>
> At least for me, it is not good name to distinguish it from error_hook.
> abort_mmap_prepare? I am not sure if it is a good solution, Cc other
> MM maintainers as well.

Yeah no we definitely don't want this, I plan to eliminate these hooks
eventually.

Really intend on adding no others, these were to work around effectively legacy
issues in mmap callbacks.

>
> Muchun,
> Thanks.
>
> >
> > /*
> > * This should be set in rare instances where the operation required
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 377321b48734..d64cea5b4335 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -2799,6 +2799,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> > */
> > 	if (map.file_doesnt_need_get)
> > 		fput(map.file);
> > +
> > + 	if (have_mmap_prepare && desc.action.abort_hook)
> > + 		desc.action.abort_hook(&desc);
> > +
> > 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> > 	return error;
> > }
> > --
> > 2.34.1
> >
>

Thanks, Lorenzo

