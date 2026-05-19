Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01789CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691DD6B0005; Tue, 19 May 2026 09:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668DD6B0088; Tue, 19 May 2026 09:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A66D6B0093; Tue, 19 May 2026 09:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1A36B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:42:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DC1621C028C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:42:24 +0000 (UTC)
X-FDA: 84784283808.09.7B5B3C8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 154524000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:42:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxN08qtp;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779198143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s52T8OnJdKYXI50uhhF0DnRneaRKJPrHl5f5Mp7KVPE=;
	b=dNxWaIDzXKRL5eyTOsQoj3HbhR2EvxTtuxA5cmBOONfqs7TwANNR6Q9DYNgOKjFG3n59x4
	Kwb1agK2V9y5CrGi4xHfwM4juZAg5vKEEF/QIbl4hLRBVyKsZhNdlSvqSeCCUlx6pONpWJ
	YSR3lDeAFnCLUvSvYWxKyzjKDepqZTo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CxN08qtp;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779198143; a=rsa-sha256;
	cv=none;
	b=IwFPzOVvLafJuWv4e90xj2/xOvWx3c3TRFptl1QMpI09eZyRxBQzcjD6D07rFK4tYq3w78
	AtYoxOVB0lZyVAjXT78s3EACBTrqxmuBQ/kbttikbaW9JbwVzUzvs9M90IENM1gMhBhcDY
	u60HBQHDMFldprSOX+Bre0XZSdaitCU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 332C041984;
	Tue, 19 May 2026 13:42:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DB5C2BCB3;
	Tue, 19 May 2026 13:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779198142;
	bh=EdZVTx8mq/+o6OdrLkwiHGmu7Bazb8bJvDYV4PghBGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CxN08qtpOBJ8IAiYT1NGbATSMveN2VuvCz+XRydDhhXI+x5QqjrTyhe5UIS691Kb2
	 bS9w1ztocYeYGUfpqcashfOVc/Pb/0rjFRC4zdEfjCwigY5cmMMgpzI1gKRdtA3pI4
	 v/VV+NqUVSeovPsja64sp9wWP72hVhslEn03pxycaef5UGhc7dYBhy2FZ2/Av0j3h0
	 1dh5UBOVeGESCRqbxSUbKDq9gTnfNXjfMTy6NPbKLtEkxHtIHeWDfR+iPX1ZvW7L/h
	 LBrO+E3xuhU/cNw3kbOQoavYiADtcJMriOizeGdr3j5sT3HlIxKigegez3GS/kKTHd
	 Rpyd30xJMvmFw==
Date: Tue, 19 May 2026 14:42:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	surenb@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <agxok1UzYWhLu06G@lucifer>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <b65722ee-6476-4038-bfbb-44a32b3544fd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b65722ee-6476-4038-bfbb-44a32b3544fd@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 154524000D
X-Rspam-User: 
X-Stat-Signature: 1u8e9df9h3fohy78h8bxepn3nkkf9ukt
X-HE-Tag: 1779198142-330140
X-HE-Meta: U2FsdGVkX1+fRu4JLStLQlOsCAyvRvguo52yiXJZuJntzJcSk48jYW1/sVlXn+QCkICuC38ojnWKrW8F2kq9aJ622/jqFGNjRHhPPJyVubk88A1anK4SXM5r6YcAlEeNYQVGZb76FbuaFP4UGeW3j1JyfjfAmgeqt8Mjm0PDi2Bq7UgBM4uYsSTiOC82bk/hNApmpnopgyD3mmnQbe8tb5sewv31gMVf3rpeO/e8s66tmKkopGph36Z2YztF2rfWvk6GzOR7DDUAh8+GRv/qxWqAc8CtTuCEqVqQVyAJ4pT59yoeAvzIPH+UxxKntxqnsF+//b2szHG//Ssjwz/nJXLROYw09pa6Z9BpW06yq4Cq571qGWq5zgWaeMBcu0YbDljl9nRrZFg3xIQ48r3r7FEL0k60MuySwZKH/iMvq/6l2qBa+9Nq9d3y4iQNs5z61UN1utDXWQUpEFcKFoK+sTzZ2ZKeiZ7TdejbgGRsOISkS5aWYHkZMAKmpP+aO29XsexmbmMhiqpsIkwpPOOtOCxHgguIsYYGziy/fhOQ0gdy2/Ix5KmcIGy5YpL/LiMyf5wfKkyCikv6VmUJHomPnVpYGVDSROs+S0vwbKhopenlIfmalqeq0g69m4NoletmwlO7qtWfYD0r5lH3AVGutjYFtz3oVKww/gvmvWcu4BT1vt2Qd7/4p2mF4sLp4Mf8z+5EzEz6qp2p0J7ECM8UFQXFmjXj8KVilv/+gjRIFwMiewvhek5CUtUj6jgJbXIKaPYhNRSUaaXXQgEUNWNHYIYMKP/KMmRic8ty0hHwt1Nz2iAWeEA3Ob8BIRwbNntCXVvRiWaQveoyYog0sRi0r+puPRwaGNYecoW+XDwASwG2Un1g5aZ7rKMTxtG0yTiXZpr63CplhkdKMvYWGlBnm+2JyjIr576NVQTJ56VrsihkVfD98GH6PdJDRe9W3zjxVFUct60teSb9Cl0OkBD
 NNNjBP1j
 vaTrZSL8MO91sEXRfPs+55Jfbgs4yae9WxuIZsl6kxqX8TCge8LU1OUPg3wcoua3VnOCYRKij/yGFpizsyxq8L3zgQvc/88VFhSjE8Y5x93HeTzz7/0nE3QShdjS+nB2OjYUlemW3cyaPP6Qva5wvnLNaxzhDGZqvxvu3UI3ma63uLOPAvrv6SI6He80/QfaMberbSqvM6JFVIiMae6epWjHM1iT8u/ouPk86X/2yIZopwqI4O9o2OgvUaQG1uo5XvS5u94rAh62P+MYPcLPxIKo+4jWH88xtF84JpnYWm0/QNuYsGotuJy9LiupH+89W5ZByQpvJLWkkV3HJVfb6xHnfpYAPYbsMcLI5QdG9ZLrxWhIV3RoyBludxe/UQPia4aeEvXsB4rJv7yfGaiieNALqj3dy0BoXg4rZZtZ3aLYH4xw+YK8ohUkUcLA/X8HG+nLAEICVEKQqwVs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 11:53:37AM +0200, David Hildenbrand (Arm) wrote:
> On 5/17/26 10:45, Barry Song wrote:
> > On Sat, May 2, 2026 at 1:58 AM Matthew Wilcox <willy@infradead.org> wrote:
> >>
> >> On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> >>>
> >>> It doesn’t have to involve unmapping or applying mprotect to
> >>> the entire VMA—just a portion of it is sufficient.
> >>
> >> Yes, but that still fails to answer "does this actually happen".  How much
> >> performance is all this complexity in the page fault handler buying us?
> >> If you don't answer this question, I'm just going to go in and rip it
> >> all out.
> >>
> >
> > Hi Matthew (and Lorenzo, Jan, and anyone else who may be
> > waiting for answers),
> >
> > As promised during LSF/MM/BPF, we conducted thorough
> > testing on Android phones to determine whether performing
> > I/O in `filemap_fault()` can block `vma_start_write()`.
> > I wanted to give a quick update on this question.
> >
> > Nanzhe at Xiaomi created tracing scripts and ran various
> > applications on Android devices with I/O performed under
> > the VMA lock in `filemap_fault()`. We found that:
> >
> > 1. There are very few cases where unmap() is blocked by
> >    page faults. I assume this is due to buggy user code
> >    or poor synchronization between reads and unmap().
> > So I assume it is not a problem.
> >
> > 2. We observed many cases where `vma_start_write()`
> >    is blocked by page-fault I/O in some applications.
> >    The blocking occurs in the `dup_mmap()` path during
> >    fork().
> >
> > With Suren's commit fb49c455323ff ("fork: lock VMAs of
> > the parent process when forking"), we now always hold
> > `vma_write_lock()` for each VMA. Note that the
> > `mmap_lock` write lock is also held, which could lead to
> > chained waiting if page-fault I/O is performed without
> > releasing the VMA lock.
> >
> > My gut feeling is that Suren's commit may be overshooting,
> > so my rough idea is that we might want to do something like
> > the following (we haven't tested it yet and it might be
> > wrong):
> >
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 2311ae7c2ff4..5ddaf297f31a 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_struct
> > *mm, struct mm_struct *oldmm)
> >         for_each_vma(vmi, mpnt) {
> >                 struct file *file;
> >
> > -               retval = vma_start_write_killable(mpnt);
> > +               /*
> > +                * For anonymous or writable private VMAs, prevent
> > +                * concurrent CoW faults.
> > +                */
> > +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) &&
> > +                                       (mpnt->vm_flags & VM_WRITE)))
> > +                       retval = vma_start_write_killable(mpnt);
>
> Likely is_cow_mapping() is what you would want to check to handle VMAs that
> could have anonymous pages in them.

Yes :) I made pretty much the same comment though I forgot the correct helper :P

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

