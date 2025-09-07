Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED8E8CA1013
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 05:16:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471DA8E0006; Sun,  7 Sep 2025 01:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422568E0001; Sun,  7 Sep 2025 01:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3106C8E0006; Sun,  7 Sep 2025 01:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16E728E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 01:16:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2EDAC06C0
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 05:16:42 +0000 (UTC)
X-FDA: 83861294244.29.739CD83
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id C34B840003
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 05:16:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EMId8wSw;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757222200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ShjqWXCQdzz5P/csLgvS4g4rnUjrvvtx5BIFMZzRD/s=;
	b=v0l4f+2O9zxHV0cVZ/yrrF+2qe2VQGzV7yCzITya26QYObV2yU/q04UOdJHNwiv/o9gsuw
	lVtIh9BrmP+74IdSDoNHGG5myyD0wDEVdGePVsRq6+2nEWWNsyuHfV5Wy9ceKZBUEAHSRr
	qPFJSu3ZBJ1xOzri4lj5dWW37/coJf0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757222200; a=rsa-sha256;
	cv=none;
	b=ckH0Q5+jvN/FH2mcczkomzWrJNJ8f6AoysAz6WuhAL0OigPcctFlEViFeEk7S4NuzaaSZi
	XjwxBz+5A9trKzigMTEXxfobrESSTXj7SvjkKefztzuabJPJDGraBHIPhVcLBZeOyiVHFm
	3LITCfsr1HYWDB9pI4RQGF5RPWvtAok=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EMId8wSw;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b4bcb9638aso472461cf.0
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 22:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757222200; x=1757827000; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ShjqWXCQdzz5P/csLgvS4g4rnUjrvvtx5BIFMZzRD/s=;
        b=EMId8wSwhvyc3SEav3RKRfI4prqVvZLH8FlgsxWvPnTTP6lrJ4SwMfRLA5ksCVo3CG
         xSublAfXmRE8eeRmgzAMxWGe/8mKNppsbLy4wzxiuSSvXE9+YWL/f2W+6HDeNmQ5Ge3J
         ogKpFJ7MKGEMVKSMY1nTyT9GwZ/bT45osjyx7A+mn4AGPVzIh+J1/NME39VNxiVeYa5w
         QmYJxqzHAGqcK51IVmLeUBPkllgTCcGvNie1Ln66qlt7OgMb3sh6TsteZnrXO98qCRcr
         QwjRgg/xottgTAB5ylfuvpQSdvz9emuy4WB23PJ1z8JbEUq8vyTYVwkrBoCVtXSf8CmS
         6uaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757222200; x=1757827000;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ShjqWXCQdzz5P/csLgvS4g4rnUjrvvtx5BIFMZzRD/s=;
        b=u/WFB++qV338J4vYomF5dGxaYcOukSKeQ8xLYFyaL9vd5pXtclqu35UqSBr7d0kVER
         +LbmGKeiZDE8sCMp/Ei+pQwLheGeYilnWWnHw6oBkJ+i8bDVVHEb2Dqd06ry99AVraM7
         ZaNYBslaErcwZGzYrug6CY9mVVyfpPh4gWdihNrFaPV2SUZCn2SKkN5b8rE1ZWGfXQHe
         hzMZwxipXP7MtMXZyEytCyxr6vXmMkFMtxsIDFgUU3MwUtN9nDogOFxoA7m7XQdT31B2
         PCmMS1L+fvelr4YNo8itufJ8QWMaOwGy+h/pFfUXw1TH3icWbAQ80T+kgs0KL18IozxH
         Yk0w==
X-Forwarded-Encrypted: i=1; AJvYcCXK2AvRapYUTOwazx/HOLWwpmun/VskYjW6wYcQ08t4K0SYLE7vmakU/+ycRVpTnFc3hyUNQJjzlw==@kvack.org
X-Gm-Message-State: AOJu0Yzkzfug9Z8Q8BvlINWmSv5C/L+IKAQupzbg6Rr4rkaTwKA31nAQ
	knD+gUD84hDBW2uhmQLLgWy/XIxZfH2WIdodC1sfG47O6dU77u6h00kccC1ltGySSXkye7v8HEV
	ap5Q5gZ3EHCrioa1/ChZTdP4Etqz/4W46YmxXOxzkHbV4+Wh0Jd6gt2KUgaE=
X-Gm-Gg: ASbGncsyRuCuVrubdiqL6SP1iWBr0M+rg1q75TsS8rRGS+/MsUfNgLJpF8iA9d9/aba
	JlK+gWQXBN7rfeFZ26FaR63k0K2j67CR9W1HODQqoHmvQW6Q0BZ1kqAI70dtNdEr8nvyIEtafUQ
	Hxsywr0P14lNIsu4JtCQkZU5P6o1qQeCGBVM/rtKDa8uZOCcWwkXpsrQJlOVZ08XvBmpQKi5kfa
	twgT/aM5DUzE3yjQDQS1nX+WC82XZl17hKi8ALse3m8GKv5
X-Google-Smtp-Source: AGHT+IH2UlbxM/Uzxg5uqSqTaCsgQbK9Rw3KZwBmRi8V/IgoDIQG7Ath+K7o+B3tDBsSn2aHT+JwtXNqSdoRpTn2O0c=
X-Received: by 2002:ac8:5981:0:b0:4b3:509b:8031 with SMTP id
 d75a77b69052e-4b5f83cd080mr4076281cf.13.1757222199461; Sat, 06 Sep 2025
 22:16:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1755190013.git.pyyjason@gmail.com> <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com> <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <CAJuCfpHyXWwrKkFmmbHTGtG9L-JK2eCt03ku9364i4v6SJKFbA@mail.gmail.com> <5o52rxp4ujglel53cs6ii2royaczuywuejyn7kbij6jknuglmf@frk4omt5ak7d>
In-Reply-To: <5o52rxp4ujglel53cs6ii2royaczuywuejyn7kbij6jknuglmf@frk4omt5ak7d>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 6 Sep 2025 22:16:28 -0700
X-Gm-Features: AS18NWBwfIS7dirB4t0GoXLCzK48DFFhzngu30-yZfZ5H5ufI_4DrJL5bIsH4mQ
Message-ID: <CAJuCfpE3pXB5=sZLywPgCk5sU1t-=G00TG-dLaXpYheSPYz1RA@mail.gmail.com>
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yueyang Pan <pyyjason@gmail.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sourav Panda <souravpanda@google.com>, Pasha Tatashin <tatashin@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C34B840003
X-Stat-Signature: k1q53qogrzubbgpjozum1adrkpfz3jst
X-HE-Tag: 1757222200-269272
X-HE-Meta: U2FsdGVkX1/2SqBnwGY/q6yMlEe5cA8E2uGpy2chtIMql+sNgmBkG95BqIbljo0ZTjkYqA6pZh3JcrA7NcMiuACWnP8dtpQxYNrHk7E9XL2/ZQah/yP16qwUuBDtq6Kt3BZWv8cetQ4V/8m2W+bu4F0lphGfGy11tzxgQ1cDUwbzAmGgMtccJtVB0MGjXpTDAF6vn+8YEd6XbC/NM0v0/ycBdAHnz7WIrceGjx5QbdTv4BhAw18h7OaotFh7l8pG++OCx86rFWcswKi3lwykSsVZEr40mVetxr/lkfxtepqTA+XTGSM6NA0itc26nAplj9EVv/LyfINw26UgdkC7hK19n2c7ay3MFSRPZndo66DHODyVHd6xY1hEFgd2oGyfoqCH2yWByUA+PaZnkZYVdKMc/2fFAaSPKGZDYBN1NhfT43PBVDEcJe88Ay//K3Tyk7hQZIkKBdFVixlYrRTAt1PsmSDYIew1zlVH/tH/I9WnFhxOAvWgISzhdl6KGdDmXOQV7UtlIgAcO8eG3h2yUeMrQmqXftKxMTYdkiQktozSZMNPkntORrmQDf0SbPnJdje56huYSbRGDsWYznTVMzCtguI7CE/XOnGivFhkAicl1Rt0RUds3Wx+GlEDfaL7hj+gNckWVdphw9U2ncrfGqagDLeAfLPfe2V6SrLmz2EgxEEplfTXBwUp/9xuU8ap6CiVm91knY211BfnFBo88hVpgjKBOni0yKWi2dzF1sv3LEAzbHhT5m1THaLT2n+SUHp0+UK9bCvSMGWN9rK9M4PJAwDtPjMfQkiI/GsHS1UJkAAPsm/J1Pq7tVDWkCt1zwRFPUDG2N7lKFvVf2jze03hsQT7+82rfO5P15Cxpq6gc7LlBY1nZIWTDoB+v32thmRdn4YVNcWLNfRU3YmDIUbYBzTZGZKhbhJE2xnDX11zK85CCE0yP2M6lQq5x+upNPtaLOOK5KUcH/Ka92y
 gwxj4ESl
 ZxRlI4bOdnF0QKD8b+3fCojgshcD6x6BGkGTZ0mC3AN18MOLgMdfPepCn7MumfA1DyEZHNRo+T6dmuZCz9s17kg6G0yHojT+XPm0y38OLyyrgaqiIPMXgUkGQiJ1bFPKfGWiAsmBKlmxczamLw7zVD3Q/U3w+r8+pujS9GQbZrnEhSdUBWN3dz3YZA3S8fjmjHTlE3XC1voKMPIMxl6gNMSY6Q6VPBNc/s1bR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 2:15=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Aug 26, 2025 at 07:32:17PM -0700, Suren Baghdasaryan wrote:
> > On Thu, Aug 21, 2025 at 12:53=E2=80=AFPM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> > >
> > > On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
> > > > On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
> > > > > On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
> > > > > > Right now in the oom_kill_process if the oom is because of the =
cgroup
> > > > > > limit, we won't get memory allocation infomation. In some cases=
, we
> > > > > > can have a large cgroup workload running which dominates the ma=
chine.
> > > > > > The reason using cgroup is to leave some resource for system. W=
hen this
> > > > > > cgroup is killed, we would also like to have some memory alloca=
tion
> > > > > > information for the whole server as well. This is reason behind=
 this
> > > > > > mini change. Is it an acceptable thing to do? Will it be too mu=
ch
> > > > > > information for people? I am happy with any suggestions!
> > > > >
> > > > > For a single patch, it is better to have all the context in the p=
atch
> > > > > and there is no need for cover letter.
> > > >
> > > > Thanks for your suggestion Shakeel! I will change this in the next =
version.
> > > >
> > > > >
> > > > > What exact information you want on the memcg oom that will be hel=
pful
> > > > > for the users in general? You mentioned memory allocation informa=
tion,
> > > > > can you please elaborate a bit more.
> > > > >
> > > >
> > > > As in my reply to Suren, I was thinking the system-wide memory usag=
e info
> > > > provided by show_free_pages and memory allocation profiling info ca=
n help
> > > > us debug cgoom by comparing them with historical data. What is your=
 take on
> > > > this?
> > > >
> > >
> > > I am not really sure about show_free_areas(). More specifically how t=
he
> > > historical data diff will be useful for a memcg oom. If you have a
> > > concrete example, please give one. For memory allocation profiling, i=
s
> > > it possible to filter for the given memcg? Do we save memcg informati=
on
> > > in the memory allocation profiling?
> >
> > Actually I was thinking about making memory profiling memcg-aware but
> > it would be quite costly both from memory and performance points of
> > view. Currently we have a per-cpu counter for each allocation in the
> > kernel codebase. To make it work for each memcg we would have to add
> > memcg dimension to the counters, so each counter becomes per-cpu plus
> > per-memcg. I'll be thinking about possible optimizations since many of
> > these counters will stay at 0 but any such optimization would come at
> > a performance cost, which we tried to keep at the absolute minimum.
> >
> > I'm CC'ing Sourav and Pasha since they were also interested in making
> > memory allocation profiling memcg-aware. Would Meta folks (Usama,
> > Shakeel, Johannes) be interested in such enhancement as well? Would it
> > be preferable to have such accounting for a specific memcg which we
> > pre-select (less memory and performance overhead) or we need that for
> > all memcgs as a generic feature? We have some options here but I want
> > to understand what would be sufficient and add as little overhead as
> > possible.
>
> Thanks Suren, yes, as already mentioned by Usama, Meta will be
> interested in memcg aware allocation profiling. I would say start simple
> and as little overhead as possible. More functionality can be added
> later when the need arises. Maybe the first useful addition is just
> adding how many allocations for a specific allocation site are memcg
> charged.

Adding back Sourav, Pasha and Johannes who got accidentally dropped in
the replies.

I looked a bit into adding memcg-awareness into memory allocation
profiling and it's more complicated than I first thought (as usual).
The main complication is that we need to add memcg_id or some other
memcg identifier into codetag_ref. That's needed so that we can
unaccount the correct memcg when we free an allocation - that's the
usual function of the codetag_ref. Now, extending codetag_ref is not a
problem by itself but when we use mem_profiling_compressed mode, we
store an index of the codetag instead of codetag_ref in the unused
page flag bits. This is useful optimization to avoid using page_ext
and overhead associated with it. So, full blown memcg support seems
problematic.

What I'm thinking is easily doable is a filtering interface where we
could select a specific memcg to be profiled, IOW we profile only
allocations from a chosen memcg. Filtering can be done using ioctl
interface on /proc/allocinfo, which can be used for other things as
well, like filtering non-zero allocations, returning per-NUMA node
information, etc. I see that Damon uses similar memcg filtering (see
damos_filter.memcg_id), so I can reuse some of that code for
implementing this facility. From high-level, userspace will be able to
select one memcg at a time to be profiled. At some later time
profiling information is gathered and another memcg can be selected or
filtering can be reset to profile all allocations from all memcgs. I
expect overhead for this kind of memcg filtering to be quite low. WDYT
folks, would this be helpful and cover your usecases?


>

