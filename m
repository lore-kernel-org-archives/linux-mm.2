Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10281CFD2F6
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 00:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECFCC6B0008; Sat, 29 Nov 2025 19:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7C16B000C; Sat, 29 Nov 2025 19:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD316B000D; Sat, 29 Nov 2025 19:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB1516B0008
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 19:28:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 547CF140389
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 00:28:17 +0000 (UTC)
X-FDA: 84165386634.18.66B63FC
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 73CD8100002
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 00:28:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kWZCjvuP;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764462495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdkwplQZXP7FjFnU+v366rZ413pi5bTQ7R9T4YIrwjA=;
	b=uTnFQQQRx8OJQcUx96sV4uxi/R6jNreKeZHMNZNQ5t9gGXZ2pT9COP3FtRWSvzkHyCDX3t
	jY34zOMLcC16PPWR1zSnpyXv37f1bJS6+9zfbdLH5PV9sJWj78ezGW8v7znjtSQKL/9itX
	PHhqbu5/d6u1wVAJJZ3TDuRkAKwMsrE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764462495; a=rsa-sha256;
	cv=none;
	b=vIivgSeTWEfyvNl6gK0ZJ3Xz6Wirc9mt8vRLLDSD2QlPcNH9gJ2NWQPb+inAFOjoayEMj3
	AY5onCQTAt70ZsAaOnwu9O/+Xnr+hpxcZS8C+O6hkhklpuEAIfpciSdlRynlF854754Gsq
	pu1qjWxUyrUPeqfwkKiaYFqK4MoVs1I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kWZCjvuP;
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4ee147baf7bso851931cf.1
        for <linux-mm@kvack.org>; Sat, 29 Nov 2025 16:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764462494; x=1765067294; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdkwplQZXP7FjFnU+v366rZ413pi5bTQ7R9T4YIrwjA=;
        b=kWZCjvuPZy027rJCjbCGN43+jWGUAyRjLnyfWXP0Uo3eN+9/WzZcGTbHNk/y0j4lXx
         wxhsuL9oA6jHbOHZlChED8fxt8FUY769wrLM1ZwvRnA5xH2OvFEmn7sVszwqLbEoAwJe
         +a8+edwcMYIhunqaXi8GjMAsduFXDzq/lhz5XlTZLHXjIs75P1+vMV2LmObTnCgo4GOm
         CBoIhwMqXkLiTyQ6FPsBHWlAu3C0VHP95JNEeXpSX1egstAVYYXJ09urI+SHmnxTwj5Q
         NHraelu3QrqyJ3TE7piWi4cvDQxlR7peY18DAvejRy3cj0S4jfV+SsdMCAUofQ1nzNfw
         T2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764462494; x=1765067294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xdkwplQZXP7FjFnU+v366rZ413pi5bTQ7R9T4YIrwjA=;
        b=dG+w1STKBuEqguH+YlmYn5bXVJDAFoQ1KirDP7Qeu8qQrfsIa/CZtob8y/ipMMILoY
         csvmpkFoZJZOd0xlA8zSUPp6EUVZDDAM7lHNfcd7GvyaDaC+k7PwqW2VHRhXTXkBg24Z
         xoaKcEofc3lMlIXHSbCS4SAxCeKT2aCQ9y3fzdWMA4V3eP0QE3QOI+X0KAiSPpiHZU5N
         ITg8rqBcztVtjoKZzwCjH4NnTC+gv9BeTQPidWqvi2ajSAtHiU4WgjfYbTMdlhKD/kYS
         LDrHqZB4wE41LAN5vFKxgwqRWePMMJ4+qRxtqGqDtmJXYexeYnugBL4y5raQr+kIztBZ
         El4w==
X-Forwarded-Encrypted: i=1; AJvYcCUekLGhVZF9XEEiZVL5Ze5RUBNPwUGpbKtGzhHH7tEPrtTxB4eVstkcjfAQcljb/mZYRZJkYzjeKg==@kvack.org
X-Gm-Message-State: AOJu0YywCKvsRS0VQRKIBRCesRtOWud0WxdvPUFI19LvxuDzZp3Gm6or
	yO63sCG8hKWorKnxwmHWkoADp7nSATnJp8gopksdbIIxHW/VfzjYmOxtL9hz+4CAbt+zbKxOm3M
	loH4fQKwhEUUvptq3rt1tuPf3hrwOMIp9aIRPuetW
X-Gm-Gg: ASbGncvC+LJlaYmdq6MK+0tJPnzpwq1dUw2lWlmgwhqxqpKlNts7qlRh22/oHw3RG8P
	MjErpK1ipzc3ITgYebcbXUMC6FY1YjPY36VSqpHVt2l2aYys8ei7X2GB3f4NJ+9n+2jDIC3f0/F
	ALzWL1q5MCLHNuAkP8pPKev8qlj9MFTdwwxqqHeZnkEG32Npi/YxzMdDhyp33vS+Gn0UlydZe+y
	8gTtWdkluFEauFcK9+oGDNauSV28kSLUDHCkWbSigw0/UlwfrSrMAxox+0ZGon9FuMTE0DNwnRM
	faM=
X-Google-Smtp-Source: AGHT+IHVf3jUEElcRU5UiElII1poREaWD5vAdlvPdSkAXo0sG8wTVz/TvP7Aj2pleN+SVZmwr5KEBBbORX+cZ2IR4bw=
X-Received: by 2002:a05:622a:41:b0:4ed:7c45:9908 with SMTP id
 d75a77b69052e-4efd0ca4d05mr10929131cf.10.1764462494131; Sat, 29 Nov 2025
 16:28:14 -0800 (PST)
MIME-Version: 1.0
References: <20251127011438.6918-1-21cnbao@gmail.com> <aSfO7fA-04SBtTug@casper.infradead.org>
 <CAGsJ_4zyZeLtxVe56OSYQx0OcjETw2ru1FjZjBOnTszMe_MW2g@mail.gmail.com>
 <aSip2mWX13sqPW_l@casper.infradead.org> <CAGsJ_4zWGYiu1wv=D7bV5zd0h8TEHTCARhyu_9_gL36PiNvbHQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zWGYiu1wv=D7bV5zd0h8TEHTCARhyu_9_gL36PiNvbHQ@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 29 Nov 2025 18:28:01 -0600
X-Gm-Features: AWmQ_blhKzVTz_OrE9p2RQX3OU7BXlogLE0D_GARspeRWjGy1hzzkkEbN5F-bD8
Message-ID: <CAJuCfpFVQJtvbj5fV2fmm4APhNZDL1qPg-YExw7gO1pmngC3Rw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: continue using per-VMA lock when retrying
 page faults after I/O
To: Barry Song <21cnbao@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: to78hydpn9cswk3wkinuoc8kmep8ihqb
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 73CD8100002
X-HE-Tag: 1764462495-635597
X-HE-Meta: U2FsdGVkX1+Vck+eU9gEN1o+OXavDT4INXFom7lC5Q3yWZJuKiNidYFfKIqMj8zXrurU4pC8vx8cE/sOgIGNV67q26g2AOnmWcUZH7CD4GpOYSyAYjD0iHnn9VcFaffEbKd3giZYT1QYE8SDHH3AI6+1HPkMbdlhB1+WjUFqej8oNOGucn/T9NSXZ2JutKeBr+PTmiOQ5RNvsnfCBmkVlLZuze7s1CnGkMs30ytEs+BFzEDgYxAzb2eiubhnk3/L5HGhr0hY/OHUTw7T3VJqGdh4MIdscXIaQUHXGA0ab5nbP/nbjXTeK8gnnC9qRgbkNQOy/xjJva+xUEZ1oJFUlLmwRyszTD3CkQVBMYfx1e/0P/qNQLVzPZnHz77DMBne2FyOyQJpgFJt+lktTc8dLZnpN3cT5wvt6icn/XVUjAFZ44y7j8gtiVmCxTVnUEDbIwip03VkKFgpnKCLDcj0n5YRTYfSV2SZdX5p9O6tJUcaBcXujTLFjfgC11ZGSLjwlrwWhSQfw9nQ34rdxFZ+BLOILXrxE3oWlO2dyY+VIlkByXe9d8gesMzTvaMUnmnl7pXJNGP1flkZ/upr6F/xsdZjmDPIAJpByCGxoWYFYcjemg8LbHTDE/FLKCDsIwY3AR7xpeSJqiW9OTJLbv61j+fgn7ZN0CIaZdBxXg5Enffv6C64N5C3/gMTBXE3R2rBeXLI3LN1k/bLzaut4H6SKe9AZG1pxMug7bTsuYu1RjcuJLrkyxfNryz1J+ss7C1YbElVitjN064DZ/9ixdJlxpacLsiUMFIheYwuWrODVhqlPhvuRB8GLjIG14X7/JpL6ADUzCLeO4eBQYQNxpt1BWCdCCrgejRsLAUD+oNRXDwqG36cmHKQrPGwqoXxWyArOo9HzTI6NAP9rjWbY29OxqB1/yTEdFXP7/20kpNcdIwt+qDZKVlbOx08qM7dXMHvBXS/sjFZ5/0dIi0vq6Z
 nA3FRkX5
 dNUIQqKXKLOKg+bYBs9PlYAgaMKccgdHJQxO2KmOP+DPK3V+LHqp9eENuuj0kRMsqTS8fbPG2ojL7vdf/Uez2TJXQb+MSaJhPjhlYb5X7IdP38evtAtI5BrVmtD8uaac0q+SmdUG+qREeAUau2KXloWM3tdh6qym0fMQit/RE06ZQuncnGpc7jDwBm4jf67qJ3SMIuVD6kggdgo9mjLMK6budhdjvlZHJxgWHEpawm5F7TcVRGVl0PTdvqqJvYaX4kL0tD1qJDkDw/9dFB3d7W22fUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 2:29=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Fri, Nov 28, 2025 at 3:43=E2=80=AFAM Matthew Wilcox <willy@infradead.o=
rg> wrote:
> >
> > [dropping individuals, leaving only mailing lists.  please don't send
> > this kind of thing to so many people in future]
> >
> > On Thu, Nov 27, 2025 at 12:22:16PM +0800, Barry Song wrote:
> > > On Thu, Nov 27, 2025 at 12:09=E2=80=AFPM Matthew Wilcox <willy@infrad=
ead.org> wrote:
> > > >
> > > > On Thu, Nov 27, 2025 at 09:14:36AM +0800, Barry Song wrote:
> > > > > There is no need to always fall back to mmap_lock if the per-VMA
> > > > > lock was released only to wait for pagecache or swapcache to
> > > > > become ready.
> > > >
> > > > Something I've been wondering about is removing all the "drop the M=
M
> > > > locks while we wait for I/O" gunk.  It's a nice amount of code remo=
ved:
> > >
> > > I think the point is that page fault handlers should avoid holding th=
e VMA
> > > lock or mmap_lock for too long while waiting for I/O. Otherwise, thos=
e
> > > writers and readers will be stuck for a while.
> >
> > There's a usecase some of us have been discussing off-list for a few
> > weeks that our current strategy pessimises.  It's a process with
> > thousands (maybe tens of thousands) of threads.  It has much more mappe=
d
> > files than it has memory that cgroups will allow it to use.  So on a
> > page fault, we drop the vma lock, allocate a page of ram, kick off the
> > read, sleep waiting for the folio to come uptodate, once it is return,
> > expecting the page to still be there when we reenter filemap_fault.
> > But it's under so much memory pressure that it's already been reclaimed
> > by the time we get back to it.  So all the threads just batter the
> > storage re-reading data.
>
> Is this entirely the fault of re-entering the page fault? Under extreme
> memory pressure, even if we map the pages, they can still be reclaimed
> quickly?
>
> >
> > If we don't drop the vma lock, we can insert the pages in the page tabl=
e
> > and return, maybe getting some work done before this thread is
> > descheduled.
>
> If we need to protect the page from being reclaimed too early, the fix
> should reside within LRU management, not in page fault handling.
>
> Also, I gave an example where we may not drop the VMA lock if the folio i=
s
> already up to date. That likely corresponds to waiting for the PTE mappin=
g to
> complete.
>
> >
> > This use case also manages to get utterly hung-up trying to do reclaim
> > today with the mmap_lock held.  SO it manifests somewhat similarly to
> > your problem (everybody ends up blocked on mmap_lock) but it has a
> > rather different root cause.
> >
> > > I agree there=E2=80=99s room for improvement, but merely removing the=
 "drop the MM
> > > locks while waiting for I/O" code is unlikely to improve performance.
> >
> > I'm not sure it'd hurt performance.  The "drop mmap locks for I/O" code
> > was written before the VMA locking code was written.  I don't know that
> > it's actually helping these days.
>
> I am concerned that other write paths may still need to modify the VMA, f=
or
> example during splitting. Tail latency has long been a significant issue =
for
> Android users, and we have observed it even with folio_lock, which has mu=
ch
> finer granularity than the VMA lock.

Another corner case we need to consider is when there is a large VMA
covering most of the address space, so holding a VMA lock during IO
would resemble holding an mmap_lock, leading to the same issue that we
faced before "drop mmap locks for I/O". We discussed this with Matthew
in the context of the problem he mentioned (the page is reclaimed
before page fault retry happens) with no conclusion yet.

>
> >
> > > The change would be much more complex, so I=E2=80=99d prefer to land =
the current
> > > patchset first. At least this way, we avoid falling back to mmap_lock=
 and
> > > causing contention or priority inversion, with minimal changes.
> >
> > Uh, this is an RFC patchset.  I'm giving you my comment, which is that =
I
> > don't think this is the right direction to go in.  Any talk of "landing=
"
> > these patches is extremely premature.
>
> While I agree that there are other approaches worth exploring, I
> remain entirely unconvinced that this patchset is the wrong
> direction. With the current retry logic, it substantially reduces
> mmap_lock acquisitions and represents a clear low-hanging fruit.
>
> Also, I am not referring to landing the RFC itself, but to a subsequent f=
ormal
> patchset that retries using the per-VMA lock.

I don't know if this direction is the right one but I agree with
Matthew that we should consider alternatives before adopting a new
direction. Hopefully we can find one fix for both problems rather than
fixing each one in isolation.

>
> Thanks
> Barry
>

