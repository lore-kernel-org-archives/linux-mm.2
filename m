Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F89CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 22:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192B76B0005; Tue, 19 May 2026 18:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169D06B0088; Tue, 19 May 2026 18:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0806E6B008A; Tue, 19 May 2026 18:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9B3F6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 18:02:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AECEC140BDE
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:02:11 +0000 (UTC)
X-FDA: 84785543262.07.9DC8F3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D311618000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:02:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEiINEmV;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779228129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrgSUFMhpGIkWoOChuhQyLYVDUdtSZljRgOJt705GjA=;
	b=HpO3Q3wrWiIetPqfQo+AwhGjfxRPUqJXARoKANh9zArNajtC7PUCR5qB/OESHF7EVFlGi4
	pZiolObBxBzCPkyibb2uSvnXX10nK6LYbMNUkUS2iHlaipmTIKwv//Jsg2Jp4QuR0wv8kK
	dw8h4MWQ40aEcPh1bGnhKr2IhGQ2HQI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEiINEmV;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779228129; a=rsa-sha256;
	cv=none;
	b=TA2E539xSgEur0QBZwuW9HZAtpuNdIEIQ5I2rJg0VvxGZStrGL+U1QE/OZLWerSPBDJLFe
	gjo+A3Iiw/jFVsbv1iPA/lah0ZaRE1G1OfRmmshy3wXuRQQBqV+Uh9VA+mhDuk75gdW3i6
	VJSJdYTJxtUL0+5s7R3DslETV2jcsZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5953060229
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:02:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10F631F00897
	for <linux-mm@kvack.org>; Tue, 19 May 2026 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779228129;
	bh=RrgSUFMhpGIkWoOChuhQyLYVDUdtSZljRgOJt705GjA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EEiINEmV/ttnXkHREkmSNrg22w/pd85GQ24kGDom/qX0DitA92kwK7imrN1F7tfHP
	 /WClIpIcz37rNq9FOtLY4huZKlhKLtBg/gq5tOO1/IYaKENgHCq8w5+Lnv5OFXdXSL
	 2sIuISEhYHzkbmfjMHN6eKzTUmO8K/tDIrzQnMmRv3D90x14h5TzWDmjPA+zx7T0oZ
	 IE8SbeYeLv8dhtCTOAuISA3eqbujACiE+Q9q0u8nfuITSR5e6vuWcd5Iclq1d5zdAT
	 HF4oRjC7RA3KX6/I4zDoQ5jAmNSGhxJ1QKqkbIZT/JE9UU3XCdU3Y9b3mu/a4r3yR1
	 lk/+recZ8aGvQ==
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-651c366f7efso4343992d50.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 15:02:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9khCp2DBnpdkNbQg7hXANeiuOTgTzkCUpJ/OBejZ1oBi62KG+wEorzRbpYGXukRMH+MpQ4jC5HpA==@kvack.org
X-Gm-Message-State: AOJu0YwiAgXtc0npTojOyvUx4N5+DTRCz4DLZDMXrB1THdlyuVUk4MDi
	CvzOa1fGWcA8eRRuHLtRRnO+cmtRTP0VVDFx4CbX+VzLlgLt+p5O12/xjAavKVJPVL0iJ3pN1CD
	7g6XNKu+xrApD3efslbAoDSX9hdDboDo=
X-Received: by 2002:a05:690c:38a:b0:7bd:9899:f904 with SMTP id
 00721157ae682-7c95c7ede6bmr245611007b3.39.1779228128311; Tue, 19 May 2026
 15:02:08 -0700 (PDT)
MIME-Version: 1.0
References: <afNM-gIqxpyJ6ro7@casper.infradead.org> <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com> <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
In-Reply-To: <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
From: Barry Song <baohua@kernel.org>
Date: Wed, 20 May 2026 06:01:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
X-Gm-Features: AVHnY4KXMvR35lLgRvdk-7E8dkEjtOPBxVO6EaEmgpy8kErjRkXyQizjBsuo3fM
Message-ID: <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: "Liam R. Howlett" <liam@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D311618000D
X-Rspam-User: 
X-Stat-Signature: xcb8hdy1as17z6baudjy6b5nisbkmxjn
X-HE-Tag: 1779228129-973055
X-HE-Meta: U2FsdGVkX18zTOX0+uf5C8XLJ/iTm1pJWc58rYF2rbqIzKrydsgr/TmrMWrnYQXjlMhNjnDapEyQnDtDhbAECJLYz8BkwbFtk3E9gDQyM9vHFfyajoA/HnYl4bB/WDW8Q2W8rGC8PgRmPX/K8rnGX7R1hKxAArhPgMUC8cCLGHozBH1C5mcZ3wrChUMBisrsQt6ndxMvIjAHqEexyZTQN7igOsy152DpjminRPmakCtyB0gIBDwCYP9g5bvC5SXSRyP5Kwt9VKYptak51fKU1dVyOn+5GgbYTWzPxhKIEBnXbCt27fX0Vhk9PK68cHPxeEJKls9msggOY6udpnCAspOgVUPdx5LtNWcy79Hy1y+XdRLLmk+dGC8B0ugSrKBYeW3FPXA9n5ghAiS15uw93aRogTqHdXvRU155yK69+eI7z2GpJ89lgqG0WOHsAHpA7MKL067JtgELkY7f+Frd7UQ9T9qjJ3i9EDIW60lTKxBUwa9nFNI+V34fxWDZIZsh4v07EYHlr174Gvxtcdgg34zfXrTWPXM5dFlkcEDwOHhl8S0kkg2BzjqeUIbR8WxmVToRuRCJSAJ2hpHmRkwzcK2dU12Ldic2GKxRyAo6xNXTl8J4onDoiwiP7RjYxjkfL4GCsga0BIYyUYZh4X1ebOZUokKnIYKRQhSEIqivXsnIV3yUhPQxSDSZ8RY4PEc0/FTLDDEtc3C3CrvEgE7RGr26dnkOfRr0Rlyo1fOJwW59XrP2nOCZ8M6Z5QwZJ/oWE0OWR0EGGzRFJNeVjAOW6p+eSF1wJmVy8Yxzo2/ImTOl74J62eMofSvU790icWX+SgzqPg2TLfBUvrMlsK2H884a/ac0FbijTRbzRLUyPD9rfoo4PezwsIbk9jzXVlw1SAoy41FVEMlUgRuLiXGfFDWK1IiP60QHoso40X26hMEoQrko3FzCymTgwGvU1+eLf8BJnDztx4PIvvbBql/
 dOYtoB7X
 Wzyv5obpRy0itvSC91MYdv+Juvd/Ycv7y8YyJIEb7gJkw5REoktXMTusJpBZO8If4h7KnSMnvmPuH4zXRRCHaZCOWr/kSOtYchXVoNXwhVjTuAJ9grjvvJS0fRp5+abYvrYmaDmNpPYJhkJRD4JqP4gUi9BjLUX1ucnJfFA7HAbx99WDyATUf7glXzzqBo/4MZPTt2sUa1Pj87Y9zyTJKkkm7BjiZcn9I57AagoqySj3YKvAE+0wdMbJ87eH2qSt+y/qFjEs7dneAN+DPtHm9TfAzH+pV6HW5DaIHaoClA2rv709m0zTdwq9OQKKs9KvBAculEjVS2+KmvEjrSkDNQZd51NOYnsKff9j2yYb5A45z+PKZrMN8ZhJjwJQg4uPJvQ0JNTxTVQ9wNawSb3l04YIh99w6FhTzwFy8DgoGVqil2zv5lNYGuMMKP9yuSdly+zISACkzZHGZTiUIiqbpq4bkeSV5z+a3sXYTSeOWMzRjOyj6FmQ9JQFj1u7SeaPepGl+a8HSJy6xs1VNeSaNbnzaywBXzyDMaASUYFj9Klfk2eHACpZAkyLcDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 10:17=E2=80=AFPM Liam R. Howlett <liam@infradead.or=
g> wrote:
>
> On 26/05/19 05:14AM, Barry Song wrote:
> > On Tue, May 19, 2026 at 3:57=E2=80=AFAM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Mon, May 18, 2026 at 4:26=E2=80=AFAM Barry Song <baohua@kernel.org=
> wrote:
> > > >
> > > > On Mon, May 18, 2026 at 5:47=E2=80=AFPM Lorenzo Stoakes <ljs@kernel=
.org> wrote:
> > > > >
> > > > > On Sun, May 17, 2026 at 04:45:15PM +0800, Barry Song wrote:
> > [...]
> > > >
> > > > I think we either need to fix `fork()`, or keep the current
> > > > behavior of dropping the VMA lock before performing I/O.
> > >
> > > I see. So, this problem arises from the fact that we are changing the
> > > pagefaults requiring I/O operation to hold VMA lock...
> > > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults fo=
r
> > > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > > any VMA modification. On the surface, that looks ok to me but I might
> > > be missing some corner cases. If nobody sees any obvious issues, I
> > > think it's worth a try.
>
> From Barry's description, I think what he is saying is that the vma
> locking has caused the mmap_lock to become unfair?  I think what is

For now, we do not have this problem. Before per-VMA
locks, we dropped mmap_lock before doing I/O in the
page-fault path and then retried the page fault. After
per-VMA locks, we dropped the VMA lock before doing I/O in
the page-fault path and then retried the page fault.

The problem only starts to exist if we decide to perform
I/O without releasing the VMA lock =E2=80=94 which is what Matthew
is suggesting, because it would allow us to rip out a large
amount of page-fault retry code.

> implied is that the per-vma locking may stall mmap_lock writes for
> longer than if the mmap_lock was taken in read mode?  Barry, is that
> correct?

Not the case =E2=80=94 the actual situation is (if we modify the
current kernel to perform I/O without releasing VMA read locks):

thread 1 PF: lock vma1 read ----  IO ----- ;
thread 2 PF: lock vma2 read ----- IO ----- ;
thread 3 PF:  lock vma3 read ---- IO ----- ;
thread 4 fork:  mmap_lock_write ---- lock vma1, vma2, vma3 write ;
thread 5 :  take mmap_lock for any read/write reason

Now you can see that thread 4 has to wait for the I/O of
VMA1, VMA2, and VMA3 to complete, and thread 5 then has to
wait for thread 4 to release mmap_lock. Both thread 4 and
thread 5 can become extremely slow, because I/O may be stuck
anywhere in the bio/request queue or filesystem GC.

So now we have two choices:

1. Change fork() to avoid taking the vma write lock for vma1/2/3 where poss=
ible;
2. Keep the current kernel behavior and drop the VMA lock before I/O:

thread 1 PF: lock vma1 read; drop vma1 read_lock ----  IO ----- retry PF
thread 2 PF: lock vma2 read; drop vma2 read_lock ----- IO ----- retry PF
thread 3 PF:  lock vma3 read; drop vma3 read_lock ---- IO ----- retry PF

Option 2 is what mainline is currently doing, and what this
patchset also follows. The only difference in this patchset is
that page faults are retried under the VMA read lock, rather
than under mmap_lock as in the current kernel, which is causing
mmap_lock contention.

>
> Since Android is doing something (according to Barry) that should not be
> done (according to Willy), both of these together are causing slow down?

The only thing that would cause slowdown is holding the VMA
lock while performing I/O in the page-fault path, which is not
happening today. It would only happen if we insist on doing I/O
under the VMA lock without changing fork().

>
> >
> > Thanks. Besides the creation of processes via fork(), I
> > am also beginning to worry about the death of processes.
> >
> > One thing that came to my mind this morning
> > is that when lowmemorykiller decides to kill an app, we
> > want the memory to be released as quickly as possible so
> > the new app or user scenario can get memory sooner.
> >
> > In that case, if the app being killed is performing I/O
> > while holding the VMA lock, the unmapping procedure
> > could end up being blocked as well.
> >
> > If we release the VMA lock as we currently do, we allow
> > process exit to proceed.
> >
> > I haven't thought it through very clearly yet, and I
> > may be wrong. I'd like to do more investigation. I hope
> > the apps being killed stay very still, but who knows=E2=80=94we
> > have so many applications in the market.
> >
> > Meanwhile, if you have any comments regarding the death
> > of processes, they would be very welcome.
>
> The oom killer only cleans out anon/not shared vmas [1].  So, what this
> would hold up would be the actual process exit path.  Although that
> would have resources associated with it, the amount of resources should
> be relatively low compared to the amount freed by the oom reaper, right?
>
> The other entry point that's mostly to do with android,
> process_mrelease() [2] will end up in the same  __oom_reap_task_mm()
> function.
>
> So, for the most part, the memory will be freed while the file backed
> vma completes IO and that sounds like the right thing to do anyways.

Thanks very much for your valuable input!
I=E2=80=99m going to run more experiments to dig deeper into this.

>
> Thanks,
> Liam
>
> [1]. https://elixir.bootlin.com/linux/v7.1-rc4/source/mm/oom_kill.c#L547
> [2]. https://elixir.bootlin.com/linux/v6.18.6/source/mm/oom_kill.c#L1210
>

Best Regards
Barry

