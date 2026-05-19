Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46147CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4BF6B0093; Tue, 19 May 2026 09:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ABFF6B0095; Tue, 19 May 2026 09:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C34A6B0096; Tue, 19 May 2026 09:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF506B0093
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:34:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E57EE120377
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:34:42 +0000 (UTC)
X-FDA: 84784264404.06.E117C2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 08936180006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:34:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDTfph8D;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779197681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igLXJd4fTn7BrUWoEo6/WCNhTtAf6rW8Mq0yK1dWozI=;
	b=hLcoiWgkBKnd254nx/0gYWXB2vQW0DAdlN+UDgfOjn3c7DGgE/IDJ3rG7aEgqwbAPQIN58
	Vm4COx3du4DgwpSFQjX4QvGrEd8/A07D2s8AkVSDJDx9t9BsGj0nNWaC0HQZSm9k72Gq7X
	atHK/zUgAc7Wbz0c3iVJacecgvBerlo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779197681; a=rsa-sha256;
	cv=none;
	b=YT5f5c4U1bTvoU5uiz9tn0diodFVVaf92vzouPT4thbSEnTWysPYm/kFZr1cDWJELt5KU5
	eYgUBkMrJgWJKwLsjbdn7n2QAoswiafO2KWyqDJfwt1Y7vm0vFHRGXpe552Jn/pJnxSODJ
	eicH/xQ+d4YB8rPwkoR+gKk2+Z9rTdY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DDTfph8D;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFCEA402FC;
	Tue, 19 May 2026 13:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AA2C2BCC6;
	Tue, 19 May 2026 13:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779197679;
	bh=jZ9eiUfdecTYmnNTglbe4v4suLmPNtkaKYThIKqcEms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DDTfph8DoNxs0r7uOMyzlcGYs56uMr1Oz4qj1hQo+aMCMvqfCj5wWWtFFuzaXr20G
	 yOrNWL62DjLdDDlRviIJLyzu7SLkguP5tlMqTJ2WQIVJWPTnA86I5YPVIip7/TFWQ9
	 FfrnD4ESweJw+hFMJuTvrUpCxGuU6H47B2CfWi24NlBhbxtC8GhtBFvViN70YQOnHi
	 8Ne2TKTGwa05BOzhDmg5PqaztRqe9W0pUc1pz8Dwx2hEmHekf3M22g1B0bmBSyTO4M
	 LSoTbzYoydCPM/mKQeRc4B3bTUv/T+VH4Q+CW5WrMmkFxAUx1H1A4n9+s9VNkHK0yl
	 xbNoiM2Z8+puA==
Date: Tue, 19 May 2026 14:34:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Yang Shi <shy828301@gmail.com>, Matthew Wilcox <willy@infradead.org>, 
	surenb@google.com, akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <agxhwM9i-in8TpIz@lucifer>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com>
 <CAGsJ_4w_-Y8qNLDeLX9OWpLpK01YG2bF-N6_mGypgsauvfCvkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4w_-Y8qNLDeLX9OWpLpK01YG2bF-N6_mGypgsauvfCvkA@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 08936180006
X-Rspam-User: 
X-Stat-Signature: wa4zkyhd39ftrjfsjx13k9sfwtqh4k3k
X-HE-Tag: 1779197680-806004
X-HE-Meta: U2FsdGVkX1+rS9CQECIMCzI94KUjU0Eb+nCwqLHg0EoqKB6HdOhLpUfzTvZ8qP3a+FSfAX9+zLkFMiBXjziq2qktvRBnQdn6xm2KwR6xa5p4PDGzhYVs6+cQ2XH30boYN/FgRJLo2390/OBYgUmi2Z6Qthcyv1lmhX0luNY9tTty0eXSVgbgP4A9ExLcJELiSqenYNwnmiTKX2UqCEkO4vQAjiIVghr8ObgfUVhb/1noGXy/gfeaRMDyzqi1qSyTsWc7Q2l0tTtnD0INDzCKkuppNBCXAQ57TQf/gRTcEWumN7o8a3Ifm2TH2jA6rEcr4KwfuMeCspDx4gLspK9uQL9cjCG1MnHSX3s+BIwEzxiT8c3PDJky8FD7n9gSkyqDiLKiq9hRsPlyZXedbeO2GS0QO+YN7XkMHsVQZCsek9niTeX//WFpFUPwn3P3p7IpACf4+lzkW6wFlu4gJk112V7wrfQBarsHzeVMT9o6WMt4spCUuomIIca9TVv/M9RNrqaLScNht3Z/NyEYrpFcJzLWKlGWnueFrLNQhceh1l1E9pyEnFjA4KqwmIQi0LLEcRHT3fZRVM1Mt6Z30wKDONt5lgNtyRtBjFrWPxVFCvkQp8N3M5oRbb3W7qlGbcvrGZLs6Rs8FjphXBHPdUneE65GkMZKT8cJC/9kHrVJpSXEAulyKp+iKzzyPX8ODEX3PQe0k7PFFo6alXy4TkLVxKCe4F8lOYkFHyRZx7P+DKxjKSJZ1bNJvN5L4PynkH260o3Rtt0ogBSYwwMU8L611fN2riYrIlSa/tY9zzGsz7mGZmKVXGyri81jZe7L2/rsPaTBuBTbqGngVFxnP0NtHo+rqVQjaHoZTbtIV4VPzKsKGpQwmJyoTlfCuTXXyZdKkWHkHfC+uE6/DXreWp8xzfMN+7Ljhd/be5EfZTYTVLjm2fIo0cnxUU5zJ/DhnWGKrDetlPj4M9+cCmXOB2R
 JiQvg/Eo
 ptfUzSYXBjOeO2JCNL/vBiBiHWuNTwoCazTaDOjlyXSswpKxJdZvn4iN6wndJ+vMD/vs/8XNDcrLTTwBGgMIypFgx2ZaUigdBmOVcgj8qkPMJoRNHOEtay189YATpMNosv3vXFlGo3MpfsZe5BpuAnf3Z6bzD6hUSWtpc31984eA0OSU2hkSc4YIofyFT66fTQa6ZVQ3hQKjDbxmf1MumpzkPQNcYp3/9kVsfsA1GoLMZfS9E0UiQdkXVaqOKtZMgax42OZKFaqxE011n3Mb3a121QEEF+rtXQIjBoW9A2n8d1BSowkt/a/n4dUXntAfI6Q5PI4iHW+dXfB5cfu4bjPaCZ+mfas5HumPGQDxRAyQTZB3VD7NEmZPJcHnjdlGbyI+JZrNCLGpqqfeHuEDeit8SL+kBNkv9NKqAI0jcW9uUPYgr5XTBKKXG/CfMzJlnz217jVfCyOTaDJ4QHKk1XdWPgduk/ZZl1E4z8z5ZkqeWHkcqr2LdQhf0Jl+0Gik+A+Ysnno6lr8qnPIg+9GkKs1qYY1le72xydEgIb4pln5iHXywgac9qFZf7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 07:07:37PM +0800, Barry Song wrote:
> On Tue, May 19, 2026 at 5:21 AM Yang Shi <shy828301@gmail.com> wrote:
> >
> > On Sun, May 17, 2026 at 1:45 AM Barry Song <baohua@kernel.org> wrote:
> > >
> > > On Sat, May 2, 2026 at 1:58 AM Matthew Wilcox <willy@infradead.org> wrote:
> > > >
> > > > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > > > On Fri, May 1, 2026 at 10:57 PM Matthew Wilcox <willy@infradead.org> wrote:
> > > > > >
> > > > > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > > > > 1. There is no deterministic latency for I/O completion. It depends on
> > > > > > > both the hardware and the software stack (bio/request queues and the
> > > > > > > block scheduler). Sometimes the latency is short; at other times it can
> > > > > > > be quite long. In such cases, a high-priority thread performing operations
> > > > > > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced to wait
> > > > > > > for an unpredictable amount of time.
> > > > > >
> > > > > > But does that actually happen?  I find it hard to believe that thread A
> > > > > > unmaps a VMA while thread B is in the middle of taking a page fault in
> > > > > > that same VMA.  mprotect() and madvise() are more likely to happen, but
> > > > > > it still seems really unlikely to me.
> > > > >
> > > > > It doesn’t have to involve unmapping or applying mprotect to
> > > > > the entire VMA—just a portion of it is sufficient.
> > > >
> > > > Yes, but that still fails to answer "does this actually happen".  How much
> > > > performance is all this complexity in the page fault handler buying us?
> > > > If you don't answer this question, I'm just going to go in and rip it
> > > > all out.
> > > >
> > >
> > > Hi Matthew (and Lorenzo, Jan, and anyone else who may be
> > > waiting for answers),
> > >
> > > As promised during LSF/MM/BPF, we conducted thorough
> > > testing on Android phones to determine whether performing
> > > I/O in `filemap_fault()` can block `vma_start_write()`.
> > > I wanted to give a quick update on this question.
> > >
> > > Nanzhe at Xiaomi created tracing scripts and ran various
> > > applications on Android devices with I/O performed under
> > > the VMA lock in `filemap_fault()`. We found that:
> > >
> > > 1. There are very few cases where unmap() is blocked by
> > >    page faults. I assume this is due to buggy user code
> > >    or poor synchronization between reads and unmap().
> > > So I assume it is not a problem.
> > >
> > > 2. We observed many cases where `vma_start_write()`
> > >    is blocked by page-fault I/O in some applications.
> > >    The blocking occurs in the `dup_mmap()` path during
> > >    fork().
> > >
> > > With Suren's commit fb49c455323ff ("fork: lock VMAs of
> > > the parent process when forking"), we now always hold
> > > `vma_write_lock()` for each VMA. Note that the
> > > `mmap_lock` write lock is also held, which could lead to
> > > chained waiting if page-fault I/O is performed without
> > > releasing the VMA lock.
> > >
> > > My gut feeling is that Suren's commit may be overshooting,
> > > so my rough idea is that we might want to do something like
> > > the following (we haven't tested it yet and it might be
> > > wrong):
> > >
> > > diff --git a/mm/mmap.c b/mm/mmap.c
> > > index 2311ae7c2ff4..5ddaf297f31a 100644
> > > --- a/mm/mmap.c
> > > +++ b/mm/mmap.c
> > > @@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_struct
> > > *mm, struct mm_struct *oldmm)
> > >         for_each_vma(vmi, mpnt) {
> > >                 struct file *file;
> > >
> > > -               retval = vma_start_write_killable(mpnt);
> > > +               /*
> > > +                * For anonymous or writable private VMAs, prevent
> > > +                * concurrent CoW faults.
> > > +                */
> > > +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) &&
> > > +                                       (mpnt->vm_flags & VM_WRITE)))
> > > +                       retval = vma_start_write_killable(mpnt);
> > >                 if (retval < 0)
> > >                         goto loop_out;
> > >                 if (mpnt->vm_flags & VM_DONTCOPY) {
> >
> > Maybe a little bit off topic. This is an interesting idea. It seems
> > possible we don't have to take vma write lock unconditionally. IIUC
> > the write lock is mainly used to serialize against page fault and
> > madvise, right? I got a crazy idea off the top of my head. We may be
> > able to just take vma write lock iff vma->anon_vma is not NULL.
> >
> > First of all, write mmap_lock is held, so the vma can't go or be
> > changed under us.
> >
> > Secondly, if vma->anon_vma is NULL, it basically means either no page
> > fault happened or no cow happened, so there is no page table to copy,
> > this is also what copy_page_range() does currently. So we can shrink
> > the critical section to:
> >
> > if (vma->anon_vma) {
> >     vma_start_write_killable(src_vma);
> >     anon_vma_fork(dst_vma, src_vma);
> >     copy_page_range(dst_vma, src_vma);
> > }
> >
> > But page fault can happen before write mmap_lock is taken, when we
> > check vma->anon_vma, it is possible it has not been set up yet. But it
> > seems to be equivalent to page fault after fork and won't break the
> > semantic.
>
> Re-reading Suren's commit log for fb49c455323ff8
> ("fork: lock VMAs of the parent process when forking"),
> it seems that vm_start_write() is used to protect
> against a race where anon_vma changes from NULL to
> non-NULL during fork. In that scenario, we hold the
> mmap_lock write lock, but not vma_start_write(), so a
> concurrent anon_vma_prepare() could still install an
> anon_vma.
>
> "    A concurrent page fault on a page newly marked read-only by the page
>     copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on the
>     source vma, defeating the anon_vma_clone() that wasn't done because the
>     parent vma originally didn't have an anon_vma, but we now might end up
>     copying a pte entry for a page that has one.
> "
>
> If that is the case, then your change does not work.
>
> Nowadays, nobody calls anon_vma_prepare(vma) directly.

I see callers? Am I imagining them? :)
https://elixir.bootlin.com/linux/v7.0.9/A/ident/anon_vma_prepare

> Instead, vmf_anon_prepare() is used, and we always
> require the mmap_lock read lock before calling
> __anon_vma_prepare(). As a result, anon_vma cannot
> transition from NULL to non-NULL during fork.

Right, yes the mmap read lock is required for that.

>
> So the original race condition has effectively
> disappeared.

Err the page tables? All the other cases which require page table copying?

Concurrent faults mean that copy_page_range() and faulting with vma->anon_vma
_or_ any of the multiple cases mentioned elsewhere.

And who knows what else serialises on that.

>
> You also mentioned the madvise() case. If I understand
> correctly, madvise() should take mmap_lock before
> modifying anon_vma. Only some parts of madvise() can
> support per-VMA locking. Therefore, we probably do not
> need:
>
> if (vma->anon_vma) {
> vma_start_write_killable(src_vma);
> ...
> }

I like how you hand wave the VMA lock operations in madvise() :)

(Maybe) guard regions being present cause page tables to be copied, they're
installed under VMA (read) lock, and can race now.

And it sets traps for future changes - introducing more horrible edge case race
conditions in fork is just a big nope nope nope.

This isn't an area to play around in.

>
> >
> > Anyway, just a crazy idea, I may miss some corner cases.
>
> To me, it seems that we could remove vma_start_write()
> entirely now. Or is that an even crazier idea?

As above that'd be totally broken. NAK.

>
> Thanks
> Barry

Thanks, Lorenzo

