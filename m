Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBCFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 761CC6B0005; Wed, 20 May 2026 01:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711E86B0088; Wed, 20 May 2026 01:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB786B008A; Wed, 20 May 2026 01:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47A3A6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:51:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E48C912015C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:51:38 +0000 (UTC)
X-FDA: 84786726276.21.E0894EC
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id E16B5100005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:51:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NHFUIgWI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779256297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gt9LoBM9h0v+gvRnQ1bJjfV7wmkEM4+ijibPUWac/Iw=;
	b=r+4APqHnjRjlk0IgD3XThyR24Pt29AEIfH9DWWIr7Pk4ri6FlYV5YevDTEQAK5JJ5CR3yv
	AZU2zv4yUu0qN9gdw61+fSxtvMSUfG7APnysppyEdNau2CzM7f6ySK1O3AWp4AMsxSO2ZB
	tmfdh2yCGVLdYS60HQX6XhGdF59UWRI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779256297; a=rsa-sha256;
	cv=pass;
	b=C3iTdZGI8tVb/4QzVGQnGnB0foYcLc2S58BQkAANPytkPsX3rmltlplkTmbs2H8xCkfUEB
	6pRennMMmp1P3WXONVSef5UwuvB6uN+ygGqgWJ/miL4TDXci13EE1wng/rZ5LB7/0lB/Kv
	r+quKu3YqqCv+3HuBraza34VYSo5ef0=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NHFUIgWI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-515548f390fso8081cf.0
        for <linux-mm@kvack.org>; Tue, 19 May 2026 22:51:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779256296; cv=none;
        d=google.com; s=arc-20240605;
        b=jnX/0N41w3uaHMT0CyJU0fhJOgDXbhZ2R4jepzPcHwHhKjpkoz3w9FMcwKxPVQk7cc
         fL1MU62ou9KRuNzA/AD/kkekGOQvuYPgIQa8Knko8q+hNpi12vSwTHl1TCDU99lMXRrV
         RrDNyuosI+rIy4lFP0Jm4RReLYKgS9vyqG2q7Mx2JoUjUSvtMTWwhF5yy9AL9fslmoGe
         Nyj4mgNLp5Pyxa75U+8JDroZtBexfIWQvPQVDEZbcdwsrVJJWGpc0pr1ZFABv71bizpy
         iiVBLWpGieWOb3lw4/R6MtFBCxeYKcWIinhq0C4jPywBxyNKTe0OOfTuX/Bz0b25P4Ck
         UGKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gt9LoBM9h0v+gvRnQ1bJjfV7wmkEM4+ijibPUWac/Iw=;
        fh=g9tjEVSlcbeF/BsL3mo3b9hyI1CfarfVsFZvL/yZLTM=;
        b=NLAkXOTOu8WIxCJAjrOGLbNsJ5SFPAYak8ZvvL7DQbGDJsTESrjjNnaQ49rJs6SwhZ
         /LJYRmIN2twwAPcUggI34h7BtQ6XYy2qTJiu7PfiQBPWvPwmaBfIB7trTFSoGKElhLZx
         ktmkOZ+DQ8P+heDFQFQo4OeP+zpFmT6D/9joULuozzsaFAVbO9MzGxMHE25mEp0oTm6R
         GF1OKfcQzWZqFAF43I1RLFHmcHR0Mv9Nd9NFaHWZy1MusmFASOdwgN2BsBnH47ACSdNF
         tQIsIXTzhibP9IKy2HQLBnrmSH2cYjyu+nNOn7xRNHKj3c8KUrx1XRwd3LNsCKZtd4Vo
         D+Xg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779256296; x=1779861096; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gt9LoBM9h0v+gvRnQ1bJjfV7wmkEM4+ijibPUWac/Iw=;
        b=NHFUIgWI/7rRimru7b4CQPqU6Wp2kX1/M+a775Lq42lbr87bTrlRbKJz7kXqsjJ3Vo
         W9ELlCLw/jcrO1pRpmHdwqknWP6ka0KA03xkp50KXcdNQ3u7HaDKwxeb8qCe4WTGFz2B
         imZmi1LejryX9nO4m0mUQ+/pDeVMQQ3pJuFTLKrynxJSGC62ncmhvz9Ahk5pypWFZTcV
         lug4v/T35BUq6vyQMIZmkc1/k66av+v+mWUmXlB/eL5d2U4dc8+olW2szhduxysXIRMe
         B2QCU5lKxtPFdmEjDcYmTCqPa1zd4KQ2TFAEPnpMpxCyDADoKu6uX57izzd2uvcWey/9
         Pjpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779256296; x=1779861096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gt9LoBM9h0v+gvRnQ1bJjfV7wmkEM4+ijibPUWac/Iw=;
        b=HeYMy6size/i5Czn5f8LTmHUgWiWwJTbyKPzQrbnvM7aGuVvXBNx5x3rTRSOH6jRsW
         vUh041Pvcg99uAsr7bPB/8nUwD0K1GFMr/+nYttNFt6Q7oheNiXkuSsF2OOi7tmIQkeY
         a1C/apBP5Pd5sk/HdFefcVTid/s9nF8uaKDgMC0leUVc3Z4H85HIfkUnRRPGug2CW5HK
         /c0lxj07K4fUliThOYaoq6F4w4rywXyPyx3tccTHc5ZRUn2HsmBelUM0nB5P6coqVGkW
         eoW26rBBbVPTJEy0QfBQ6WzP64V997KYynMtVBm9ccz8jSDt9ABYqXFvS0NaWFab1/GO
         RQDA==
X-Forwarded-Encrypted: i=1; AFNElJ8pevCdnIC3gTuawyEB+R6FW7Shx4pHN/qziJuHIEOjvyAN0kvNsydHKqKA1IONAtMONgmvzqvHxA==@kvack.org
X-Gm-Message-State: AOJu0Yz3V33/B/y49D4y4yLl3OvvIazRV+HMzgD59L+DpC9fHtsTr8Xs
	5ijURIE72P9cN4HQs2L6meFbu1leKvt95lvGda4zj8Mwvn+RBJeRsXkece1gDnZCRi/t7fqqjPl
	G8t7LEv8Q1+FUwFAgPslJOPN3yLhgR7MLz7ErB4Dg
X-Gm-Gg: Acq92OEcZMUsDyOtTMpw74DWOCQB6VY5YwVCjLXjddNnT/jP3AZ/N0dp4+GcnFUzo+Q
	qJlWcJXuaVqXI2opxUWtxkYze+vVhPLfSbyVJ4+6ttbCOW8wGBUmdgOsWeI5DKLgOc82alMk5cx
	5ARyqPSsdxojBE6fl72MFXNgE75asffr0lCRWzVWd5BUcbqL4IeUA+FaRkrH1zpSJ4F2lwMIQPA
	CbKqvh3gU8Fmob9ZtprFbUscScp8Wy1rqAqJ1GC1lvTHf5HPVnTq6vMdr1Yh6XdntmjjtKehWBG
	BUR8W9EYmrWUVMU8tYC660SSNKBKHZoS1d74mBYQLXvckA==
X-Received: by 2002:a05:622a:1920:b0:514:b17e:86f3 with SMTP id
 d75a77b69052e-51679461795mr15633081cf.12.1779256295164; Tue, 19 May 2026
 22:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com> <agxbq1TxJdniMQT3@lucifer>
In-Reply-To: <agxbq1TxJdniMQT3@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 20 May 2026 05:51:23 +0000
X-Gm-Features: AVHnY4KMccW5pUeVLxDyTF9Gnh50gzRE3EOZpgiKFqqXipSU5KPE9rQdYzJrFBQ
Message-ID: <CAJuCfpG2Zmpf5N_ejB6ZDv8LDjpVtTfA_tYQ6sW+Noc9Y+XhdA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de, 
	wanglian@kylinos.cn, chentao@kylinos.cn, lianux.mm@gmail.com, 
	kunwu.chan@gmail.com, liyangouwen1@oppo.com, chrisl@kernel.org, 
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, youngjun.park@lge.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E16B5100005
X-Rspamd-Server: rspam04
X-Stat-Signature: ya96twcpxin715po1aze3nmydc46wfet
X-HE-Tag: 1779256296-702089
X-HE-Meta: U2FsdGVkX1/9xKeRjc+7UqGjBiwaqFInjSUUNCSjP49UmCYjGhBWWbu8IBlhjsc3VGni5RqgZd+ZmV4ehab0STepm6prGDiJQIFx9KPW1pEiuwc7hUWkdDmfXAoKi6IW2ka7EjEsfCoQxw+6zHDOClbAMs/NfYrcpdgz+10epCebV3kPmNEQ07lHmKzsfNrgzo2LGyU8cpXKGUofivHbLY/BugTyBfR8lOb4fFU4ncNhl1qZF28QNYsZw7ocqmphnk9epD57P5YxmH491UyflCPMPhfhgQFUJguKRNy+n/IcaQmh4ctqcA1uGeuBoFwt8CCPLIAVZN3v2GQCNjA4rDKVbQHZWoeT5AzdI5cBWTX4SP4FZOVDIkFbSOloa6GVCSVE/JWCsMnIJxr3ARQjLbx4Z2MvQ6Ab+oDiAAZgHYDyxuW9OfvyQDyZKDZtB2HjLAEXbAdezbn5RySrh+R2ZNCh4aHeJMWL9rbBaePwdAdktnOuukMzLDe5XP8uqJaLTQXzt3AznWqIThiehPYU+g+zUtwpH4JPzlRnrHZ1kuFixxv8GMzcoSiB1SlAcrZ0K/pWS4MJtZrP/c/7E8kw47FoStFDQ8lCEgwIS2E9RAbX9as8IRDv4dt6+dHuXE6l4kp8V4e0g2WzWja6Dv6Ni/fwinUgc99W0mmIthffkAtU63b46LLUbFEax4Wa/bdiriX2FsmCJfuhT8pOrR7pqXFc9O9xm3Yjlls9c1UI/UaXWBRI28fYX7yEOLD3bnSDSo/3UGoCExBJXeGvLdumHOwC0DCj02RftVVTjcWX4FRGjeyZ3KxuhiBnNBct7WAmXgkZ6pPCr9Fe03pANaNvmeBK1zM4wRWGYCPGelMu3jz2cDIjGoUjF2gfkgMHh+3vU8hLgmQiWNak22gKLFqlEE8dYyocoYAauTdR7H7uf23o2qsNsTCmmEWaRsyl+CD7OVzQJWPwwi48YPQGBvs
 InQUjoqW
 KreEMoFP/NSJhWacA7EGgdl2AXQMBvSouaYA+2iMEDvLONHt7VgRk77uUj687snr/X673TWEukQ95c1DIXywaFUsNESVPIs8e4I+B7nZEDNXEdpWg4KscBEufWf6qBBITm8NeY6myOvI2FjJNNqhHWLMOO3MGE1mQ7DdRLdU1ASJZqu8LhHvd8LF8Td9i7xdMmFmU6kE147KHiwLEWqChi/Qd5+/mxoxWCXYsLMI3NQZ25DCLa+LeLH4lohM2xb8rRYEQt+bL+Dm+Ma2qdk+cqpB0FyH2GAKmaRAbjr8TAb+GWlm/uPzH7VXWvvG0S56MygJEgrNPTNvgJeG8PlchmiR/MaKfVTmEb/TDSKb1/pvViC0QiAOExtxcvE4ky9jkfZnJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 19, 2026 at 12:53=E2=80=AFPM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> On Mon, May 18, 2026 at 12:56:59PM -0700, Suren Baghdasaryan wrote:
>
> > >
> > > I think we either need to fix `fork()`, or keep the current
> > > behavior of dropping the VMA lock before performing I/O.
> >
> > I see. So, this problem arises from the fact that we are changing the
> > pagefaults requiring I/O operation to hold VMA lock...
> > And you want to lock VMA on fork only if vma_is_anonymous(vma) ||
> > is_cow_mapping(vma->vm_flags). So, we will be blocking page faults for
> > anonymous and COW VMAs only while holding mmap_write_lock, preventing
> > any VMA modification. On the surface, that looks ok to me but I might
> > be missing some corner cases. If nobody sees any obvious issues, I
> > think it's worth a try.
>
> Not sure if you noticed but I did raise concerns ;)

Sorry, I didn't realize your first comment was a conceptual objection
to this approach of allowing page faults to race with the fork.


>
> I wonder if you've confused the fault path and fork here, as I think Barr=
y has
> been a little unclear on that.
>
> What's being suggested in this thread is to fundamentally change fork beh=
aviour
> so it's different from the entire history of the kernel (or - presumably =
- at
> least recent history :) and permit concurrent page faults to occur on a f=
orking
> process.
>
> I absolutely object to this for being pretty crazy. I mean I'm not sure w=
e
> really want to be simultaneously modifying page tables while invoking
> copy_page_range()? No?
>
> OK you cover anon and MAP_PRIVATE file-backed but hang on there's
> VM_COPY_ON_FORK too.. so PFN mapped, mixed map and (the accursed) UFFD W/=
P as
> well as possibly-guard region containing VMAs now can have page tables ra=
ced.

Ugh, yeah, I realize now this is a minefield. Resolving all possible
races there would not be trivial and might introduce other performance
issues.

>
> That's not to mention anything else that relies on serialisation here (th=
is
> would be changing how forking has been done in general) that we may or ma=
y not
> know about.
>
> The risk level is high, for what amounts to a hack to work around the fau=
lt
> issue.
>
> I suggest that if we have a problem with the fault path, let's look at th=
e fault
> path :)
>
> So yeah I'm very opposed to this unless I'm somehow horribly mistaken her=
e or a
> very convincing argument is made.

So, current approach of dropping locks during I/O sounds like still
the best solution.

>
>
> >
> >
> >
> >
> > >
> > > >
> > > > I'd also like to get Suren's input, however.
> > >
> > > Yes. of course.
> > >
> > > >
> > > > Thanks, Lorenzo
> > >
> > > Best Regards
> > > Barry
>
> Cheers, Lorenzo

