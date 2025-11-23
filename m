Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B100CCFD2F6
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 22:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6868F6B000C; Sun, 23 Nov 2025 17:34:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636EC6B000E; Sun, 23 Nov 2025 17:34:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525D36B0010; Sun, 23 Nov 2025 17:34:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 379D66B000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 17:34:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA06713979B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:34:02 +0000 (UTC)
X-FDA: 84143325924.04.7C3EC01
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id B522740011
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 22:34:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g2r6dCZS;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763937240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+xaaXYeJTsLfYFwErrJtkanncBFXfKSs0hFHV/jaI0=;
	b=IJGNcUCjfRwgFQ+BzhVrXAMDV8OI9cmA46DwaL3u71UBFzSuh7AkhbGo4u83PtjY4HsNfM
	dJoe0RdgGZGTYOfFFlAo1tCQ/SdrRQtxCTFYNneHHeXxl36+c+s+WPYhXK49nPBSXgQELs
	Zsuv88NG7JbH+M7hlLotR76nNvPUcZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763937240; a=rsa-sha256;
	cv=none;
	b=6Ws0uEWcQOs4sEaE0I0ONOqeVG3+9vPtMr8t0CdT1zx6Hua8U4g3o8AZrmnMJU7rXz7EhB
	6l8CcR+l84+tJnX+85DEAhiPKZsjPczXV9dnqn8hcalTJzPpxxtWs6XS1vtWK5Q3nanpwT
	L2liE9p/8xMFKLVa6GtnRDco+/Ix1kw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=g2r6dCZS;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b737cd03d46so512495966b.0
        for <linux-mm@kvack.org>; Sun, 23 Nov 2025 14:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763937239; x=1764542039; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q+xaaXYeJTsLfYFwErrJtkanncBFXfKSs0hFHV/jaI0=;
        b=g2r6dCZSj1qsiM0iOEvDiz6uTDTNBQ3la+h016xfp2CeIbQ0py7YcAIME9wU3gc4EA
         oxtdOVZZ3ukizXfMx1rboDx2qUzsoohDUPC/ZIieNOEQNrXWSf1XhoiERm3bXmxxfvSq
         lySfFwpbDrLyaKLT0zwOP41X9PGibgcJ1CPZ6ELifmcdy3Zo2wE+dIdXDWdqPxU/QmOm
         S87REFlnLGyR68bpJX1cUeb//zO1bzxCShuBOLWWYWdTBG9DlG/ZxmYH/npTJlVVmtQH
         eyuwv6b6LjiUBS2CV9kPRqAJVBxxiCKBGLd1lqOunArJZkn239awZRNV5CjF0JOvEq26
         iHBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763937239; x=1764542039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q+xaaXYeJTsLfYFwErrJtkanncBFXfKSs0hFHV/jaI0=;
        b=HiJ4+P5ZxzUsX1mFUDGBCcxK7tgk1v32/QwocEjGWDjXrEki/VCHEbnyFw5uzRN2zB
         4I1QgwFkYbiCGu76W9MvRsnecyEsBDWmyYVV9uqQ9+bWiNDv5E8Vrj3QfjZUU0BR0nOd
         Mzho4oxZ0ClAUwK3VSIJWowO9V/ZyCpybTu5DiP11VOaaZoiqG45s2jfgLM3wC/dbAq2
         jHOKN+FmNQUeH/PiTll6CB+GJPK93ObWgQKbDzKQr/blepPbllEBJvopbameO0ImlizZ
         Uo2YVcYdHmyBvAXIMGKv/PFOwu7j4WYyARTwxwKUQCKpgQIylBpOOtrJy3dbe26Vt1Uf
         T69g==
X-Forwarded-Encrypted: i=1; AJvYcCVRDwGPQPFNvX0IoCK/WTmEN9AGJSSOwzXqWzdc/NWmh+pfAJTzry/FKwS3HJ07mUbGCiM99vGxLg==@kvack.org
X-Gm-Message-State: AOJu0YyvNKQ2ZjOqn6BkeWKgiND5tARUYOKTmvJWleY9G18H+StJIriE
	8bVeQkYxNF0XPKsel8oyH/dHo1yW81EF2rud36fxZh9Y2xzvQKX1sV8qcmqzgmw233tMl7gqt/6
	V+F5PG6fyEGwQ4WWeJk3OTz1A7mlqlaY=
X-Gm-Gg: ASbGncu/scS66VkPuYhGcSM0Mug1HrsQM5QpRMPMQMoBDw4O6wsLew2v/3eN7wHOZfN
	tq4GjI6HACUdQz6A9BFTkBDC3SZbjyHtH1fxZq0Epk8bE6lYjAzsaU4XhPgEXGW/biDHZ78LDid
	B7UAXCnszXNQF/g1rqJ9uECJYG3V96stAld9ehyFYeb0ObzjyW+s4eLWvNdT9H8BKbSSKBiEPoa
	bceM9FAH0baxSngdfLyM7UFY4dk0fFrolds00BUOzG6CqCy7LDVKkn6vHd1/Z5Orc8Y2eT+VCUL
	Uo6X180MBlsBmxjpUAMDz4FNBw==
X-Google-Smtp-Source: AGHT+IFXvH77A1GNkFxxdJpcjuN8AMET7LO3waOT+2UrtrsrcXHjZRSkcYkkB8Bfq+obqU/v491CsjjEyX55c90Fr74=
X-Received: by 2002:a17:907:d08:b0:b73:3e15:a370 with SMTP id
 a640c23a62f3a-b76719d0675mr1014682866b.57.1763937238774; Sun, 23 Nov 2025
 14:33:58 -0800 (PST)
MIME-Version: 1.0
References: <20251123063054.3502938-1-mjguzik@gmail.com> <aSMhj2Q6BTMNSsA4@casper.infradead.org>
 <CAGudoHFjqRPao2DOF35rHrYDOAjVC+dcWJ2kGm+7JqnMNk=o2A@mail.gmail.com> <aSOAcMSYsQ22kPid@casper.infradead.org>
In-Reply-To: <aSOAcMSYsQ22kPid@casper.infradead.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 23 Nov 2025 23:33:47 +0100
X-Gm-Features: AWmQ_bmKbmo39jdCMt0zIKr3h7QyBe_SIlp3ycLDzN2mH_W4b9r8JjCFESrS9e4
Message-ID: <CAGudoHFKo8mgxPYVitf9gGWAtQwJfHos_k-zB-hk=4FiCiYVPA@mail.gmail.com>
Subject: Re: [PATCH 0/3] further damage-control lack of clone scalability
To: Matthew Wilcox <willy@infradead.org>
Cc: oleg@redhat.com, brauner@kernel.org, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B522740011
X-Stat-Signature: sp6bpw7wqjff5dkjxnjppgqofbsg7bbg
X-Rspam-User: 
X-HE-Tag: 1763937240-796264
X-HE-Meta: U2FsdGVkX18srar7+uJqemzL9SL6TaXwcyHn+TBcDfs9UbyBBtiDjey1Io+Bu3jvrJMpAAjj7wyWs7eItyW/VXt9lrdtBg4NqG081a815xQYBJXBSf4STFGtn8JfGs4v7BwaSE+5TYryZFryDIoCpOBQd9VebQGMEZ/TPvOibi3I44wSaGlc5Hjm7nt1Wkv/Q2A+xtoTV1/KCmi8aqgXsgfQXJOJYicMDWagsF/MII2wiU7h05Y6lDU3Pf/oCbC4iNYFidBb4G9ZzVlrrCnqxYXaFo4ZX/Fze6zsMabSl+vGEmXPUnlbrRLuwQc8jyCvez7V9+F92vBP7UtSyNK3UhNORtU8RJVN6NeUjgU4tMe0q2COMYcPbww+RWNNEZPeED1r1AWJvKmuAw7NwneWqIVTJ/GO2cWAJoZYJADhN6rqqulNfaAc+2ysw8gEVvoaKuzelRyDCVvQ3gdZONM8SILbI8K0/HGkS5gGcMPOyjZfB635mQ3O8+63tAKhpdOyWu64Oyd7mUHeLDmC435UGDZdLFZZOGROIEQ299ny2M17xTTz0s4F48KMP8leuhZ3ZiAjlXBqoaBPtVGFuLpj62WiFQdV8XSnYwPO/xNyoFIGqZFj7e0d5BktTFA0jkykIpuwFEZYbZs39ZFuX2h1NqIsfKuqmyVNKiVKAwR0V1pWXn53MvSCR3phDCIWTAP+fRpN3y5f2TQZaJf7OXUHZEVE237sFcM+j/Elmzzm3EHrh4kMb/xQX5W4tOKEt8oJKYa/TN+zonk812JTSs1NN07okB2iIZjtlKPdXOOzmEMyP1E+0og3GQi/MDEY17gcmrgREOvimBRTSLCLAl9XaeEUkhKNONyS1vyinJPq/DeNIN3cGJQkPdroR29IvwVIBwMFpJHmlyGpVBKCkcskEt1DfkRtrlv6Jy3FU2GJ+0UgzQfZKRnr8NMOqD1cLUXL3FUmuUuUgrWquHyy5/1
 jkR2uvAj
 q6U0aBJ/LvgRBrIbwIo7YzUnvxT0wJEMuBygIU6UJu1KUxHDWHBq72UIhWmpNusyiZrl+Ek04KbSkCT38IM+k9yq1hEl9L53SKOPw4cw7vCablaFm/BdTHkQWH2NQ6JIjxMpnHSgcZmJtdbnL8zX9rUlvJYZOf7v2MBC4pvSqjK48SGDxMIJfptytzijYAywb9PRIsWuonRf+3jZ4Ju106WfvJDkQzDYxtxNjc4PFoIn8WmNYhcdpaeYi1iOFkrsRhuLxnc0pvyBKU2bBtxow1ZG3ZRdeG5JTwR+uIXrOg76Zons2EOD0IsV0GKg5OxhY3PeVFVhYdGKKM4vpm3AhScDAgI7ROlMtIzPpH5qOgBjxlPEvczlJv2+aroxR6+5LeHOdHd6Darf9n78d2QUGRYar2fYeT7OQWxCYt2Isi8WNJ8BT8nm8f12vA32JeaVGpL0EZKOA1gLLj1wEEzbzH4nZkVoODmbVYDMWsFL01vPuL4zpd17O+DTrVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 10:45=E2=80=AFPM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Sun, Nov 23, 2025 at 05:39:16PM +0100, Mateusz Guzik wrote:
> > I have some recollection we talked about this on irc long time ago.
> >
> > It is my *suspicion* this would be best served with a sparse bitmap +
> > a hash table.
>
> Maybe!  I've heard other people speculate that would be a better data
> structure.  I know we switched away from a hash table for the page
> cache, but that has a different usage pattern where it's common to go
> from page N to page N+1, N+2, ...  Other than ps, I don't think we often
> have that pattern for PIDs.
>

Well it does seem like the obvious choice to try, and like I said it
even was tried in Linux. It also happens to be what FreeBSD is doing
and it gets better scalability, despite other global serialization
points (that is to say both kernels *suck* on this front, just so
happens FreeBSD sucks less).

> > Such a solution was already present, but it got replaced by
> > 95846ecf9dac5089 ("pid: replace pid bitmap implementation with IDR
> > API").
> >
> > Commit message cites the following bench results:
> >     The following are the stats for ps, pstree and calling readdir on /=
proc
> >     for 10,000 processes.
> >
> >     ps:
> >             With IDR API    With bitmap
> >     real    0m1.479s        0m2.319s
> >     user    0m0.070s        0m0.060s
> >     sys     0m0.289s        0m0.516s
> >
> >     pstree:
> >             With IDR API    With bitmap
> >     real    0m1.024s        0m1.794s
> >     user    0m0.348s        0m0.612s
> >     sys     0m0.184s        0m0.264s
> >
> >     proc:
> >             With IDR API    With bitmap
> >     real    0m0.059s        0m0.074s
> >     user    0m0.000s        0m0.004s
> >     sys     0m0.016s        0m0.016s
> >
> > Impact on clone was not benchmarked afaics.
>
> It shouldn't be too much effort for you to check out 95846ecf9dac5089
> and 95846ecf9dac5089^ to run your benchmark on both?  That would seem
> like the cheapest way of assessing the performance of hash+bitmap
> vs IDR.
>

The commit is 2017 vintage and that kernel has some problems I fixed
in the area. The commit is not easily revertable either.

Even then the hash as implemented at the time looks suspicious.

I best way forward it to slap together a poc consisting of the obvious
vmalloced bitmap for the entire size + hasthable and see if that has
legs. If so, then one can spend time making it memory-efficient.

> > Regardless, in order to give whatever replacement a fair perf eval
> > against idr, at least the following 2 bits need to get sorted out:
> > - the self-induced repeat locking of pidmap_lock
> > - high cost of kmalloc (to my understanding waiting for sheaves4all)
>
> The nice thing about XArray (compared to IDR) is that there's no
> requirement to preallocate.  Only 1.6% of xa_alloc() calls result in
> calling slab.

Technically there is no requirement in idr either, as it also kmallocs
with GFP_ATOMIC inside.

> At one point I kind of had a plan to create a multi-xarray where you had
> multiple xarrays that shared a single lock.  Or maybe this sharding is
> exactly what's needed; I haven't really analysed the pid locking to see
> what's needed.

So ignoring bottlenecks outside of pid management, there is the global
pidmap_lock. The xarray patchset I linked above technically speaking
provides per-namespace locking, but that does not cut it as you have
to lock all namespaces anyway, including the global one.

Ultimately in order to makes this scale CPUs need to stop sharing the
locks (in the common case anyway). To that end PID space needs to get
partitioned, with ranges allocated to small sets of CPUs (say 8 or 10
or similar -- small enough for contention to not matter outside of a
microbenchmark). The ID space on Linux is enormous, so this should not
be a problem. The only potential issue is that PIDs no longer will be
sequential which is userspace-visible (I mean, suppose a wanker knows
for a fact nobody is forking and insists on taking advantage of it (by
Hyrum's law), then his two forks in a row have predictable IDs).
Anyhow, then most real workloads should be able to allocate IDs
without depleting the range on whatever they happen to be running on
(but deallocating may still need to look at other CPU ranges).

With something like a bitmap + hash this is trivially achievable --
just have a set of bitmaps and have each assigned a 'base' which you
add/subtract on the id obtained from the given bitmap. The hash is a
non-problem.

I don't know about xarray. Bottom line though, even if one was to pass
a lock around to xarray primitives but without sorting out the range
lock problem, that would merely be a stopgap.

All that said, I don't know if/when I'll get around to something this.

I think my addition to the idr api is trivial and absent someone
volunteering to do the needful(tm) sooner than later it should not be
considered a blocker.

My worry is, should this patchset get stalled, someone is going to
swoop in and submit changes which make it infeasible to only take the
lock once.

