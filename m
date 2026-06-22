Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1FBCDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6E06B009F; Mon, 22 Jun 2026 10:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7814E6B00A0; Mon, 22 Jun 2026 10:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6978E6B00A1; Mon, 22 Jun 2026 10:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2818C6B009F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:50:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BE33A01BE
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:50:18 +0000 (UTC)
X-FDA: 84907834116.10.353013A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id B151520013
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:50:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JK+kFtzl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782139817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5FxiXI2Cp5YdtBkdSD+qNScBXccHcZeYoAW8t2qi+Yc=;
	b=rqG0wFzb8rjXbMiKL56LjFUDW+ChKglbW7+ZfdP/eUmsYxfCF8XSjGI+oirOJ5O2mjk+nb
	FR2D46zdT8sn/2XGQlKrk2/YsxAkjpOf6VN3jZtCfUripuSFIs2Oa8dBKAtVJiaq727PPX
	IpoNzDFgPEyt1mbMcAvNDqc4BIZNdrY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=JK+kFtzl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782139817;
	b=7ENNCBZ//4bj9Y+Vj7OGo4Diqw8wJNqOe3s2ZBSRVkYQUkT4ITsrPmlakU0JBNgA8uLQob
	Ef4MPcOm1MYz7IVMwEBDYC1O4x2me9di0FjNJRNckWRRzgvgBtH7XWxaZoLAElIsGTZguD
	Yek/oME+dlhlPHwdwzu8GZTJsg3H8L0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=5FxiXI2Cp5YdtBkdSD+qNScBXccHcZeYoAW8t2qi+Yc=; b=JK+kFtzlUAONUzDRoTzYX+brhD
	GKFH0RfbSzUM95BSOrozCSCjOw8vzTHXTIm39G4MXXyBXkGQxtrTmVgQzvzmmmeBEBPZ5Y830BVuk
	fl7AcG6/bn+wbK2Lu1KCjHNA0aPKVEZY6qTmdbEyqF8o+9MMHqTDUmuXwOB5rkZLoDq8h5WSGs3eG
	EZGd4nIcvKQn1H7UodiJAGUOAIvYYdKLQi5gwAqTUvXspEktsI80PoQ3S8uztj6P35PIEY+OtzAci
	pFgaZPJGW47T+bbX3mwQZ0H9RhR2jZxYGZuhZyHbY8K0S/+O2urv10M2x7CACas7uQMjPhjDb5t0L
	Sbnx7uoA==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wbfyR-00000005693-3OS3;
	Mon, 22 Jun 2026 14:50:07 +0000
Date: Mon, 22 Jun 2026 10:50:02 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, kunwu.chan@gmail.com, 
	liyangouwen1@oppo.com, chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <c5soxcu245cerfljr2ddto4h7xqksfxzxti47mq6sqn6pnmnxh@th5kxapvnaj3>
References: <ag4h87CBd-gph9zX@casper.infradead.org>
 <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
 <ag4kj84EcKqamdB-@casper.infradead.org>
 <3be9475b-0e8a-4df8-a130-4262f993973d@kernel.org>
 <CAGsJ_4xC5LdhuoWV1=tK-RZ5rkjc8aOKOkmb1L_8BG_3gtJhDg@mail.gmail.com>
 <ahB6QyHgYq8ksj65@lucifer>
 <CAGsJ_4zxLvZ01i19vdo0xA47T1hxa1VRYvxLmiDhy5q1GDKPRg@mail.gmail.com>
 <CAJuCfpHTxaU4KdNmefU7C7cWZSLCFDLPdUrnqV6yzxzN+8RQ0Q@mail.gmail.com>
 <ajhOUdbWsswgQyl2@casper.infradead.org>
 <CAGsJ_4ybg5LGYopTUJTh5R2rN6X3uR9xoJSL+RdTYVtm1-xqLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ybg5LGYopTUJTh5R2rN6X3uR9xoJSL+RdTYVtm1-xqLg@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: g95sc7e8ws31xdqf1t97f4bc1pjuozm4
X-Rspamd-Queue-Id: B151520013
X-Rspamd-Server: rspam11
X-HE-Tag: 1782139815-174419
X-HE-Meta: U2FsdGVkX18VWwoLJnolhDQB7wAm5PB95G/TF7I6VH27JNnRTr6MvCUsJQgKHQuqTT7G5D4mpmAPC1/DxYDh6oV+ODcbZR2Zmui9insW98zFQgWFHcpHQNxx2kl/ZwyEeJPPfMFBBm+grzwC91RLcU54Xi/yBHEnTn29FDO98fGGT8GW6uLprOCDfZ5SCM8b3CE/qeeJvRem1Yx+CzXzbVUpmM57sihKVAMQumOoLf5oLiCqXmf5MRFU5tMa4ITuEN2comkq58sL+zYNHX40CTal/0TcnM9hFo6fxxU0y5AEnzkj3eWEm6hmmYAh/u4Xj4/hPvATQ2QCzYlMvLERo0gRKuyhOtkojjyV9842VQKNAgMswgMZFCUbI6TKyYoA6ejAkO33adVUbjC5SdA4wue8KvN3bFH6X2y6UcPdP5RUi3LNHjdCZMpJk+GrpU74wcrgpIaSZu6Xba2JykjGRPnswltPGDpj0UKwDg6m8hZPfS+j0FrkbnfK+KDzFLqXFEyxLjR0b1cjimv4lDs5M9Wi+g5XOHV8sd/kkCu2oD4Sfc7LypalglzidwvnasSgHhvjByY3keJv08z1cVdrc9NioqsXHw4j0Y7Y2KnUZxmGVaXovpaO8fMUjJnmbAlqxdqKyJCq5xmweMrBn1bHg7FWBkbPAoSFFZquKywcByCRiRIi5Z76V/TCwfLB87goCPPmt2T9V8Q1D8XVsFMKKXho/PRwkSwYGtIzTN1H/GUBdd1a/R+SYIkdrzyV1BvY0gPfCJLAlwpPJIJVJL94Sxs7i3cv0jGs0Ifo8xyU01cdZfNZ4dln0ldVJyr52iUZa8sXYG1izCxQysupcsX+TyaVFNEIlilwByc5vruh3YszgyGs3Ue/PtFngjhRWzWC9u+WCgcwbxFzUlGCi/TUer0kRau7prilLHFKr6yFgTY9XAy6s198qC4SuR+y8b+6v9cKVQEF+imostSLpfI
 Ny+Zi9zu
 YOaYMy06t89i2tvA54JKCWqSfN+n9l0vHzZ+40fGi7HKcfkV5xFz/6DuV3JD3Dd7l9vSKGMsVP/LvvmnOv+ij5nuRO/Ny7R4536CZnt+c6bYuT4OV/quz1CP3s1GWkc8/hZfK54YkoOnuKR30AcL6HHcmWwPnfpLKyw+woIyrWxDvfNBCuoAfVFiJ2c5VGGQ8tQTQIB/EPMvSIjttzAleym13p+XYKMnkqGRkpyDFBBJPuk4P98998ngsvzCB+KihXFgr71cM3frgxf/Z27P3VWFnCzuMgS0RxTdcx5rOv5azo2DjLlyUn9xiCDxDHx7ZgLpcA/BwrwzQu5kX6cvpMolqEcgrk33c4olZm2o1XQo8LhENZnoE/o9lMjLSBsC23lfnoJFfLe9agDPHDkypECbyemmnpCAM3cWrgbMb0GGivM4hO7rQY2C2Kt3eCJrVVwX39/2xWo6Jck0++z3+ErGx3kdkq9IPVhtvFfu+x9Pe3Qg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/06/22 08:15AM, Barry Song wrote:
> On Mon, Jun 22, 2026 at 4:49 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Sat, Jun 20, 2026 at 04:48:57PM -0700, Suren Baghdasaryan wrote:
> > > Just checking in on the followup plans. IIUC the RFC mentioned will
> > > try to implement the solution we discussed at LSFMM: splitting
> > > VM_FAULT_RETRY into two flags - one for retrying under per-VMA locks
> > > and another one to fallback to mmap_lock.
> >
> > I continue to hate this idea.  I don't believe that those who were
> > pushing for it have ever tried to understand the whole fault path.
> > It's utterly byzantine.
> >
> > I defy anyone to make sense of this:
> >
> >         /*
> >          * NOTE! This will make us return with VM_FAULT_RETRY, but with
> >          * the fault lock still held. That's how FAULT_FLAG_RETRY_NOWAIT
> >          * is supposed to work. We have way too many special cases..
> >          */
> >         if (vmf->flags & FAULT_FLAG_RETRY_NOWAIT)
> >                 return 0;
> >
> >         *fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
> >         if (vmf->flags & FAULT_FLAG_KILLABLE) {
> >                 if (__folio_lock_killable(folio)) {
> >                         /*
> >                          * We didn't have the right flags to drop the
> >                          * fault lock, but all fault_handlers only check
> >                          * for fatal signals if we return VM_FAULT_RETRY,
> >                          * so we need to drop the fault lock here and
> >                          * return 0 if we don't have a fpin.
> >                          */
> >                         if (*fpin == NULL)
> >                                 release_fault_lock(vmf);
> >                         return 0;
> >                 }
> >
> > Wed need to simplify the fault path, not add additional complexity.
> > Josef has said he wouldn't've done the lock dropping had we had per-VMA
> > locks.  We should rip it out.
> 
> I think you have agreed that, at least for anon vma, we can
> keep the current policy, since anon vma is much more volatile
> than file vma.

I don't think any of the above has to do with anon vmas.  Does any anon
vma handling have anything to do with your problem?

This would be needed if anon vmas were being faulted while being
unmapped or merged?  Do we really need a fast path for that?  Note that
anon vmas cannot be merged if the vma chain... you know what, I wonder
how many people know what I'm talking about here... Let's just say that
they can't be merged if they were around for a fork.

So, then, we're looking at anon vmas taking the mmap lock on:
1. single task anon vmas being expanded and faulted at the same time
2. single task anon vmas being unmapped and faulted at the same time

I think that's it?

But maybe I missed something critical about your use case here?

I don't understand why you are involving anon vmas in this discussion,
so I must have missed something with your IO completion issue.  Is there
an anon vma causing your priority inversion?

> Concurrent page faults and VMA modifications can happen more
> often than with file VMAs.

But it's only a problem for anon vmas with per-vma locking if it's the
same vma (or the vma lock sequence counter overflows, but let's say
that's a statistically insignificant non-zero value).

> 
> For file vmas, how much code can we actually remove, given that
> the first page fault might already be holding mmap_lock?

How much complexity can we remove and maintain the performance, might be
a better question.

> It could be the case that lock_vma_under_rcu() fails, and then
> on the first page fault we end up holding mmap_lock before
> retrying. So are we also going to rip out the lock release,
> even if it risks holding mmap_lock for a long time?
> 
>         vma = lock_vma_under_rcu(mm, addr);
>         if (!vma)
>                 goto lock_mmap;
>        ...
> lock_mmap:
> 
>         vma = lock_mm_and_find_vma(mm, addr, regs);
>         if (unlikely(!vma)) {
>                 fault = 0;
>                 si_code = SEGV_MAPERR;
>                 goto bad_area;
>         }
> 
> If we still need to keep the page fault retry code there, it
> doesn't seem like "ripping out" really reduces complexity in
> the page fault code?

This seems unrelated to be above complexity that might be the target of
removal?

Thanks,
Liam


