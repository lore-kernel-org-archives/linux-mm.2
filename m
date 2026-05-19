Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160B4CD5BA6
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 12:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8196B0005; Tue, 19 May 2026 08:44:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 157FB6B0088; Tue, 19 May 2026 08:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E146B008C; Tue, 19 May 2026 08:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E99E16B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:44:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 916B11C0DC3
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:44:05 +0000 (UTC)
X-FDA: 84784136850.22.8AE384F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id DBEB240006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 12:44:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfo4BDRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779194643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jO8lU9nZfaIXvi4aM14Apu8W/4/KaBQAgvYJVbl8iHA=;
	b=3fYedoNCM2xu6jeMvD62ZewWG+bZJ7/V0HPOPCaVCY0OcDC+ISJtz+vUmfvVmFJQKAU6wc
	Xs0yJ8n85dcqzEdASPwKldc5MuOZ1tsU2Js9LXMDQAt1kAUKac+swNMUwIupmyVl9DdjxL
	OqNzn7gbaAjW10Lf/Rajd+PL6g1EtZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779194643; a=rsa-sha256;
	cv=none;
	b=l7gHK+wj7r3XwMjNkPyVcIzRor9OZ3nxBnUi0ufFRuamiK0RhZM0RqiAa1PhzNtbGFP0ck
	RLAu/r5C6gxXbbrKt8hXjPXX+NkP94mhEZ61oKmhAZv3IO9XgkzjnN6MnHbUH8W6gPr06J
	APqoWo+Mx4zd1IGWL3l20YelQcmR/hg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bfo4BDRf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 395EA60129;
	Tue, 19 May 2026 12:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23CD8C2BCC6;
	Tue, 19 May 2026 12:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779194642;
	bh=kMUFbNwBqvJpO+Bjd3l9GBxXRf0w6ZacFORzSNgGrqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bfo4BDRfvA9myn7305sBhrTH2J0JJJLZN41DyiCsBL5RaW4yJzwWoRjqEv4bw7XRu
	 3sS6wrONgvzJAEmXQdyWNoxP7IRgXT+BwOJdEatfiHb5tGo3e7Wv57MRVS0Mfl/KwF
	 x37oBTK95eNvN0DhfsqWoIm8NOxS3mlo/N7lra4/86d92nRL8dOyMRTzXe4aNafoSP
	 zmYFhFt5OepkId8YyQ/JRMelvQ33s7dDez4kr7Q7tGi40FybpnQQzZ966Ac5xeTssH
	 5GqAFt9tX2CAZo6ci+b6JD7q1AC8DXMlEmsrGOnNr7zIOL1N/xCP/W2AdAHZDtwZKR
	 +0JGj8KZOVUKg==
Date: Tue, 19 May 2026 13:43:52 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, surenb@google.com, 
	akpm@linux-foundation.org, linux-mm@kvack.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, kunwu.chan@gmail.com, 
	liyangouwen1@oppo.com, chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
Message-ID: <agxXPfG--tkoPynl@lucifer>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer>
 <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBEB240006
X-Stat-Signature: q4nhun67sn4kdm58ei4yux8inkag8f8q
X-Rspam-User: 
X-HE-Tag: 1779194643-17904
X-HE-Meta: U2FsdGVkX1+oPQLK+yBerkp3OKls0dEobxdbLXQlUmof7b90swH4w+CmA6yw0W5dZZXkvfuw75gRUmGm5XiW5FJf2FEdF1dxt18EGp1IP+GQjhcgkSMgoxB5MrKxnPEx4b6ycCYIee6oz2ZfFBC2FUnAIKP16Vmj2uJLCidcjjDZRWMSiCyHACJ/WQKWf9x4RgbXLTU1Y0kOCDR2JsphWNUy/oIODrG7QYo9T/+Qp4CZm3uV3pwpAnZRGEqYEE0mnBUNPQZ0eYuIeKxQ6Aazl4p4HolS9ehchf2ZY/yVVSYgIX534yuJozgpE916Ht+HvstLiAqA08t6PTtPbtn4kc3jgP6cstPGydkKzq54HALccSEp34EA4E5LvjJdFyRrmjrsMN6l4geuXgikaDLIAYc10GziT/d6/sj+cZANYYVp1+Q+nSJTH9m4AJG0Tj+bAgGwJzBpQi/+i6et6UdoIF2EhAmXt2gWAL3ehLKiF9rKJpg2Nk/HL1bd06TbndljThM+G6GMoCeFpcJOJfJHFG0O4NPQsT/riRaR2dGrB4YC3ij+y5WwFPcp5dQ14wDoxIdrwkvvYDFo69ofoUxNUwR3t4UcanKxf2xg0odEMkN4ZFm2GoWxdURmnp+tobkXVGpBv9XHbjqP3R5wd5xJxDdgc1wcYF/nG7hV8kWslzKzxlh3mt9tvHk6UZSOcxbDaLQqxxfWxVJasFbxTzXJBdsb7Taw2W4XwRd+MzbJW/AX7SG2JE2jqWlAsYreNWTaemZhHgMNc8pykpbNnIlnwysS4NZGvc3MTj1LsBqnsCtgnyghT8GNP2L9XBZ+GIbmHSihNSqZTF4feUKm1MAalM71MtCq9VWq1J7aMLFIz7Di3NhqJIcBbyZ3VwRRxelu/mz7Ky4QyNG+ECLWF7uISnvlXwQ6/VISALMrto6Oe6mGIApiyU7LWK9MjXbMuD1+9lZfh/lVfpsxJaIYbwF
 cmEbWQ4U
 B2kJVK2WEucQKNAPgN60iWwWvLNCOkUuWR2/bgi6cgJI+aFmfRFIcyEMvXhw9aDlYurem5zJwIvPZAJ/6r269wMFNk3hu8BLZYf6BszMSYf+HTJSSnW1Xy+gc3K9pumMR78NxQXbmXU9QvM/Y0WrwSkM10J5NmzOGAsxHr49LuoMoivhU9Ob++U+TkBW68ix7SCB2mEU308fNt5fLD9BIXtO03D6QUBiOqC3iBrZnX760IC2G+VnxQOcS36e1Tl3KIuD/gxCixefz/EqlCcImYBnCUTdM7FYIgasDgqcapitKSpm57eG+c66u/EBxGB6BfgkZBbkLUWKl6lk0jM2T3xD7fBm8sMx33Wdw1yICQmAtmvIIMCzNkEkjm1IPKAkdnrlMDKG13Mv2UgiI4g33cdMNJgeAWDDnFgVavX+Q76rDZMuA31tGSFSu9M3cyZpWelQ/iJhibE5ghN1/W1v1NolMtmtHNYH+OOEZ4k+Dr7+P9NZWqddZTxbkOjs1nMfyMXU+smh1VReIAT0ZyMWGPhJ9kMqZNHhjipZc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 07:25:54PM +0800, Barry Song wrote:
> On Mon, May 18, 2026 at 5:47 PM Lorenzo Stoakes <ljs@kernel.org> wrote:
> >
> > On Sun, May 17, 2026 at 04:45:15PM +0800, Barry Song wrote:
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
> >
> > Hm but did you observe this 'chained waiting'? And what were the latencies?
>
> We have clearly observed that the `fork()` operations of many
> popular Android apps, such as iQiyi, Baidu Tieba, and 10086,
> end up waiting on page-fault (PF) I/O when the VMA lock is
> held during I/O operations. This has already become a
> practical issue. I also believe this can lead to chained
> waiting, since the global `mmap_lock` blocks all threads that
> need to acquire it.

I asked about the chained waiting :) I'm aware you've observed contention on
write lock, you said so in your LSF talk.

So have you observed that or is this a theory?

>
>
> >
> > >
> > > My gut feeling is that Suren's commit may be overshooting,
> > > so my rough idea is that we might want to do something like
> > > the following (we haven't tested it yet and it might be
> > > wrong):
> >
> > Yeah I'm really not sure about that.
> >
> > Prior to the VMA locks, the mmap write lock would have guaranteed no concurrent
> > page faults, which is really what Fb49c455323ff is about.
> >
> > So Suren's patch was essentially restoring the _existing_ forking behaviour, and
> > now you're saying 'let's change the forking behaviour that's been like that for
> > forever'.
>
>
> I am afraid not. Before we introduced the per-VMA lock, we
> were not performing I/O while holding `mmap_lock`. A page fault
> that needed I/O would drop the `mmap_lock` read lock and allow
> `fork()` to proceed.

Err I'm talking about fork? The patch you reference is a change to fork?

So you're saying that Fb49c455323ff which explicitly takes the VMA write lock on
fork, was somehow an addendum after fork didnt take the mmap write lock?

I must be imagining
https://elixir.bootlin.com/linux/v6.0/source/kernel/fork.c#L590 then in v6.0
pre-vma locks :)

I suspect that's _not_ what you're saying, so now what you're suggesting as I
stated above, is to fundamentally change fork behaviour to account for the
existing per-VMA lock behaviour on the fault path?

Again I state - are you really sure you want to fundamentally change fork
behaviour for this?

I am extremely concerned about doing that.

>
> Now, you are suggesting performing I/O while holding the VMA
> lock, which changes the requirements and introduces this
> problem.
>
> >
> > I think you would _really_ have to be sure that's safe. And forking is a very
> > dangerous time in terms of complexity and sensitivity and 'weird stuff'
> > happening so I'd tread _very_ carefully here.
>
> Yep. I think my original proposal did not require any changes
> to `fork()`, since it simply preserved the current behavior of
> dropping the VMA lock before performing I/O. In that model,
> `fork()` would not end up waiting on I/O at all.
>
> What you are suggesting now appears to be performing I/O while
> holding the VMA lock, which in turn introduces the need to
> change `fork()`.

Again, you're saying we should fundamentally change the way fork has worked
forever to work around something else.

At LSF I raised the fact that Josef himself suggested we simply drop this I/O
waiting behaviour for file-backed mapppings. Isn't there a way forward that way
rather than 'hey let's drop locks and hope for the best!'

I am really reticent about this because we've seen HORRIBLE bugs come from fork
behaviour, especially edge cases, and mm testing isn't great so I am basically
opposed to this, and you're not really convincing me here.

>
> >
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
> >
> > To nit pick I think the comment's confusing but also tells you you don't need to
> > specific anon check - writable private is sufficient. And it's not really just
> > CoW that's the issue, it's anon_vma population _at all_ as well as CoW.
> >
> > > +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) &&
> > > +                                       (mpnt->vm_flags & VM_WRITE)))
> > > +                       retval = vma_start_write_killable(mpnt);
> >
> > I think this has to be VM_MAYWRITE, because somebody could otherwise mprotect()
> > it R/W.
> >
> > I also don't understand why !mpnt->vm_file for a read-only anon mapping (more
> > likely PROT_NONE) is here, just do the second check?
> >
> > (Also please use the new interface, so !vma_test(mpnt, VMA_SHARED_BIT) &&
> > vma_test(mpnt, VMA_MAYWRITE_BIT))
>
> Yep, I can definitely refine the check further. But before
> doing that, I'd first like to confirm that we are aligned on
> the direction.
>
> If you still intend to hold the VMA lock while performing I/O,
> then I think we should fix `fork()` to avoid taking
> `vma_start_write()`.

Yeah or we could do something different, it isn't a case of you get to do one of
two options you propose - the maintainers decide which way is appropriate.

Of the two options dropping the lock on the fault path rather than this fork
insanity is my preference but I wonder if we can't find another way.

Let me read through the series and give more thoughts I guess.

>
> >
> > >                 if (retval < 0)
> > >                         goto loop_out;
> > >                 if (mpnt->vm_flags & VM_DONTCOPY) {
> > >
> > > Based on the above, we may want to re-check whether fork()
> > > can be blocked by page faults. At the same time, if Suren,
> > > you, or anyone else has any comments, please feel free to
> > > share them.
> > >
> > > Best Regards
> > > Barry
> >
> > Technical commentary above is sort of 'just cos' :) because I really question
> > doing this honestly.
>
> I think we either need to fix `fork()`, or keep the current
> behavior of dropping the VMA lock before performing I/O.

Yup you said :)

>
> >
> > I'd also like to get Suren's input, however.
>
> Yes. of course.
>
> >
> > Thanks, Lorenzo
>
> Best Regards
> Barry

Thanks, Lorenzo

