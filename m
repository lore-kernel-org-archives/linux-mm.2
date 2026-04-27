Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EFFBFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:26:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8DBA6B0093; Mon, 27 Apr 2026 11:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17446B0095; Mon, 27 Apr 2026 11:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CD46B00A0; Mon, 27 Apr 2026 11:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A0876B0093
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:26:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6BDA5160384
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:20:21 +0000 (UTC)
X-FDA: 84704697042.21.009D5F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id AC1931C0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:20:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMFZSqMd;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777303219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zHe5/nvvXNFdOD8qJOMq75qC+klX67w0vPbNZZUT58c=;
	b=UeyaAy27TUXAx/e0oYPj/sqNQLb/NANbDzJ+xpylwe5yBf7C5PeY8VcPdWFFpKgr/KQoWI
	bEoWbg+oReLBLtPCWy9JtJClZvbj2c68v/mSYR6TzTqqLUyweg3tC7ATUX8WSYmXV70P3G
	zsAWaoCchlsMWkcw7zhc4NlczDqxriE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777303219; a=rsa-sha256;
	cv=none;
	b=eYLVBZA9p5QEhPxoVaUXTWQhBJbL0Bhok4WUI8fOgZaP6tWj9++wLSeLdCtzQc2liU8+Ns
	k+asAfJ2btocXnN8jQE7dZa8DMvJnDHGN0KR8JQWo5DlsS/9AH+PdEnjtE3PIEU05G9S+P
	0p8/YG8aprGndFnwnrzxaqyFPuAWO0M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sMFZSqMd;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E397E60154;
	Mon, 27 Apr 2026 15:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138B8C2BCB4;
	Mon, 27 Apr 2026 15:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777303218;
	bh=5QfFreQMi3AW5+NsyiW9Hbi6a/x7RZzCTbf0zZ/T5xo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sMFZSqMdIbwB6/uQt0JAY/jfCmownyzp9YcTBc/LOnQnkWM+7yomhafWMST66SYRn
	 RKjlKUr1r1wHEkafTiGKDTKcA4thZ2IXHYTNYPkgxaO/FTfh5e6ns3RcDUvtDg7ZHe
	 l7pag5GxlRQub1k0yUGv4/RqB6c/DKo99NGaKu8lVuaHfG4Qrg4FHuh0QT1tgg+nvo
	 cMV7ZIGNJGhbD095t9UpHdqeS8zCSDGu4ndkR1ckI/wKJIbZt+/F/h81nUfLc6N/Km
	 Bs4qw6WNFylYRIcWEFUGMH9V8aVZi1gudiVbzx4Yeq3i3uOT3ies8RVDAeEdXc0WB/
	 pnx+cirFvw5ww==
Date: Mon, 27 Apr 2026 16:20:13 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: =?utf-8?B?546L5piO54Wc?= <25181214217@stu.xidian.edu.cn>
Cc: Muchun Song <muchun.song@linux.dev>, Liam.Howlett@oracle.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, 
	david@kernel.org
Subject: Re: [RFC PATCH] mm/hugetlb: fix resv_map memory leak in
 __mmap_region error path
Message-ID: <ae9-UhMBMqEAA4Fg@lucifer>
References: <20260425070700.562229-1-25181214217@stu.xidian.edu.cn>
 <BCFCF1D6-8F39-4E60-AD86-0ECF799FFD9D@linux.dev>
 <ae9tVZbNFtBBet8f@lucifer>
 <5c504419.9025.19dcf61abcf.Coremail.25181214217@stu.xidian.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5c504419.9025.19dcf61abcf.Coremail.25181214217@stu.xidian.edu.cn>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC1931C0007
X-Rspam-User: 
X-Stat-Signature: 3p5h5h499hdark5dab8bbshs6fj3uncn
X-HE-Tag: 1777303219-103070
X-HE-Meta: U2FsdGVkX18b6hTdZegSDGQJAu0ZFAEn+dsQSXprJBTK1o0TKFajwArruQug2kutqe6AuSg6spZDG7Q2vrHNA5KVtBUj2ybOp+Jhc9Ulvt995wl6Wt03up4aUuSDp4WZz+17t2yQOScB7t+DCYWg0XDkCJD5uF/3t+ADBjqpkKFhrw+1cWf5A7sPa7AqX5ymsk0vWcbb4ZIz7ZHREzuB1n5jWV7C7s28xvNjwRvWiNwQvQkRej08mfYo3eyPAm45VE3y5bOWvJhH7XrMjgwhYkjRqXlCm8qV7RKY4wboKS/6UHn/wFLjkYF+I8y5bJyFmEryHvNYgibrqlho3b97QUCPPk4MxtGu7/bqbzUFBWJpb53mW+XjsT8PgURTxwYXBmWYp+e419LWrfIO49QcgTl7MAyeA7wGZhUva5Mt19xKe3WGoEniSl/Y9RghFATVPpYniHZAZymow6HlOy2OZo7Xg5W+AQOifx8uQalmLwVuGT5RTm5S1Xkc+j6/yJ71GJfRljz3k27f3kpwwo7eeQr7/xwFT/EP1nZSpcc/41LQqNu3dQ2cKBq8sqh+e/SIsAoO2U7yz9fF2OovnygEuU0P97unXM5SGjkkT7EU57tZZXm6G4UULH0azvZiUPgENZbEctP/luNXuzaUMmCTqbSv1nXddN3NMieAdwzPm+7F+QFD1TzrnVjqZ1QtXcxetXvi7UZtOu91K+jv+5a0GI4zMDOEyGfdT/9DqVO5VkLKN9eZstdb7uWM2xZ1WeGn9uiUEHndFnWU4YUx2w7OxROrGQGSI+CDiLQQb/ZwsQmsPlPtTItqKSCO9UwboTPnibfrBDiAqOd1p6azoLH4eNW7capD4CyQ70cNb5MLxo9X4Ox4JSPIqheir1+xShehGspgRT1irxijAkqmEt6EgokCWQMBY0hDlJmGjuYcyGIpfJoCgwj2BbH40/C6NkDfog0j0tWkrMePtoTqGyY
 fJSIg/75
 BmQVM2SUDBmsVzIakUMzIwQO0fU+9NedjG4RbbD0Yyh8JAW5oq4mrfqK5YTrkb+5G3jZh4yf36w6AgkoBtxSbJAOcIyHsnqVuYjVPcM7NmzkwGZU/Gw4Mf7ptFH5oB5DHexZKt6s5roKIB5/ZVckmZJPkyli17iBgGtyVM5iN979+8fEILLDS5Y9FSuYZEkx6BDGUHMqs3tq/IWBayR5TYNL4Qsa7X8yPjNzHB2im+sDgCPVQWEqVBCiQGYxOBVx93q8LvHBoFzplPz7HEtp/Qxe7PuIFmjr/yduSPjJiL0lbEBwiTu9Pj5B1FjoIC9Jrui6Uw+xDHrwBkEPBd8f4MMiW0LZGBOrlnOp4Ihhkpf7mJlhcI+dL1+aDERIQoHxbibyTQdAjinQpHtR8Rc0GDjGOaJPphaQORuBhd0rfeEdU39dMTGQhK1q/N9AOwAW8I4OC722R0Pq1ZbQZUC03tBRFZde5rE/ufPPxhHdKaVbMp4XGlrFyBP4AnemdJ9tH5dC7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 10:39:37PM +0800, 王明煜 wrote:
> Hi Lorenzo,
>
> Thanks for the prompt response and for taking over the fix!
>
> I completely understand the architectural direction to eliminate the hooks, which makes perfect sense. I'll watch out for your patch.
>
> Also, my sincere apologies for omitting you from the CC list originally. My university's SMTP server blocked the email due to the long recipient list from `get_maintainer.pl`, forcing me to trim it heavily just to get the report out. I'll make sure to explicitly include the original authors in the future.

Ugh sorry to hear!

>
> Good luck with the upcoming LSF/MM!

Thanks!

I will come back to this, it's not going to be straightforward, hugetlbfs is
a... pain.

But thanks again for raising this, there is very much an issue here that I need
to address.

vm_ops->mapped won't do here, as hugetlbfs (of course) requires data that the
interface (intentionally) doesn't provide.

I may have to revert this (ugh), because mmap_prepare should be idempotent and
this is just an error on my part converting things a little too one-to-one.

Anyway, shall return to this! :)

>
> Best regards,
> Mingyu

Thanks, Lorenzo

>
>
> > -----原始邮件-----
> > 发件人: "Lorenzo Stoakes" <ljs@kernel.org>
> > 发送时间:2026-04-27 22:18:34 (星期一)
> > 收件人: "Muchun Song" <muchun.song@linux.dev>
> > 抄送: "Mingyu Wang" <25181214217@stu.xidian.edu.cn>, Liam.Howlett@oracle.com, akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, david@kernel.org
> > 主题: Re: [RFC PATCH] mm/hugetlb: fix resv_map memory leak in __mmap_region error path
> >
> >
> > On Mon, Apr 27, 2026 at 03:55:00PM +0800, Muchun Song wrote:
> > >
> > > > On Apr 25, 2026, at 15:07, Mingyu Wang <25181214217@stu.xidian.edu.cn> wrote:
> > > >
> > > > While fuzzing with Syzkaller and fault injection (failslab) enabled,
> > > > I observed a persistent resv_map memory leak in the hugetlb mmap error path.
> > > >
> > > > BUG: memory leak
> > > > unreferenced object 0xffff888110b92400 (size 512):
> > > >  comm "syz.0.5386", pid 20390, jiffies 4298157188
> > > >  backtrace:
> > > >    __kmalloc_cache_noprof+0x509/0x6e0
> > > >    resv_map_alloc+0x47/0x3a0
> > > >    hugetlb_reserve_pages+0x758/0x1220
> > > >    hugetlbfs_file_mmap_prepare+0x492/0x790
> > > >    __mmap_region+0x1ae6/0x29f0
> > > >
> > > > This is a regression introduced by the recent VMA iterator and mmap region
> > > > refactoring, which decoupled mmap preparation from VMA completion.
> > > >
> > > > In `__mmap_region()`, `call_mmap_prepare()` triggers `hugetlbfs_file_mmap_prepare()`,
> > > > which successfully allocates the `resv_map` and registers a `success_hook`
> > > > in `desc->action`.
> > > >
> > > > If `__mmap_new_vma()` subsequently fails (e.g., `vma_iter_prealloc()`
> > > > returns -ENOMEM due to failslab), the code jumps to `abort_munmap`.
> > > > However, the `desc` structure is completely discarded without invoking
> > > > any cleanup. The newly allocated empty VMA is freed, but since
> > > > `set_vma_user_defined_fields()` was never reached, `vm_area_free()`
> > > > doesn't call `hugetlb_vm_close()`. Thus, the `resv_map` is permanently leaked.
> > > >
> > > > This RFC proposes adding an `abort_hook` to `struct mmap_action`
> > > > so that subsystems can properly clean up resources allocated during the
> > > > `mmap_prepare` phase if VMA creation fails.
> >
> > Yeah sorry, this is a general problem that I addressed already with the
> > vm_ops->mapped callback.
> >
> > I'll come up with a patch to fix this up for hugetlb, thanks for highlighting
> > this.
> >
> > I plan to get rid of the success hook in any case, it's only because hugetlb is
> > doing something really... not great with the 'VMA lock' (really hugetlb VMA lock
> > I suppose) that we need a VMA pointer at the point.
> >
> > > >
> > > > Any feedback on whether this architectural approach is correct, or how to
> > > > properly implement the hugetlb unreserve rollback, would be highly appreciated.
> > >
> > > Please use ./scripts/get_maintainer.pl to get full mail list for Cc/To since
> > > it is not only related to HugeTLB subsystem. It will also consider the author
> > > of commit introducing the problem.
> >
> > Please do do that, I wrote this whole thing, so y'know :)
> >
> > Especially at the moment I am very very busy with LSF coming up so you need to
> > make sure you include me in the mail.
> >
> > >
> > > >
> > > > Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
> > > > ---
> > > > fs/hugetlbfs/inode.c     | 9 +++++++++
> > > > include/linux/mm_types.h | 2 ++
> > > > mm/vma.c                 | 4 ++++
> > > > 3 files changed, 15 insertions(+)
> > > >
> > > > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > > > index 8b05bec08e04..002bb6d9ca23 100644
> > > > --- a/fs/hugetlbfs/inode.c
> > > > +++ b/fs/hugetlbfs/inode.c
> > > > @@ -102,6 +102,14 @@ static int hugetlb_file_mmap_prepare_success(const struct vm_area_struct *vma)
> > > > return hugetlb_vma_lock_alloc((struct vm_area_struct *)vma);
> > > > }
> > > >
> > > > +static void hugetlb_file_mmap_prepare_abort(struct vm_area_desc *desc)
> > > > +{
> > > > + 	/*
> > > > +	 * TODO: Implement the proper rollback for hugetlb_reserve_pages()
> > > > +	 * and drop the resv_map reference held in the desc here.
> > > > +	 */
> > > > +}
> > > > +
> > > > static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
> > > > {
> > > > struct file *file = desc->file;
> > > > @@ -172,6 +180,7 @@ static int hugetlbfs_file_mmap_prepare(struct vm_area_desc *desc)
> > > > 	if (!ret) {
> > > > 	/* Allocate the VMA lock after we set it up. */
> > > > 	desc->action.success_hook = hugetlb_file_mmap_prepare_success;
> > > > + 	desc->action.abort_hook = hugetlb_file_mmap_prepare_abort;
> > > > 	/*
> > > > 	 * We cannot permit the rmap finding this VMA in the time
> > > > 	 * between the VMA being inserted into the VMA tree and the
> > > > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > > > index a308e2c23b82..9320f6699fa9 100644
> > > > --- a/include/linux/mm_types.h
> > > > +++ b/include/linux/mm_types.h
> > > > @@ -861,6 +861,8 @@ struct mmap_action {
> > > > * it is not valid to clear the error here.
> > > > */
> > > > 	int (*error_hook)(int err);
> > > > +
> > > > + 	void (*abort_hook)(struct vm_area_desc *desc);
> > >
> > > At least for me, it is not good name to distinguish it from error_hook.
> > > abort_mmap_prepare? I am not sure if it is a good solution, Cc other
> > > MM maintainers as well.
> >
> > Yeah no we definitely don't want this, I plan to eliminate these hooks
> > eventually.
> >
> > Really intend on adding no others, these were to work around effectively legacy
> > issues in mmap callbacks.
> >
> > >
> > > Muchun,
> > > Thanks.
> > >
> > > >
> > > > /*
> > > > * This should be set in rare instances where the operation required
> > > > diff --git a/mm/vma.c b/mm/vma.c
> > > > index 377321b48734..d64cea5b4335 100644
> > > > --- a/mm/vma.c
> > > > +++ b/mm/vma.c
> > > > @@ -2799,6 +2799,10 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
> > > > */
> > > > 	if (map.file_doesnt_need_get)
> > > > 		fput(map.file);
> > > > +
> > > > + 	if (have_mmap_prepare && desc.action.abort_hook)
> > > > + 		desc.action.abort_hook(&desc);
> > > > +
> > > > 	vms_abort_munmap_vmas(&map.vms, &map.mas_detach);
> > > > 	return error;
> > > > }
> > > > --
> > > > 2.34.1
> > > >
> > >
> >
> > Thanks, Lorenzo

