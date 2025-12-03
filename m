Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0270CD12D4D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:54:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 366266B0005; Wed,  3 Dec 2025 06:54:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33DAA6B0030; Wed,  3 Dec 2025 06:54:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2540D6B0032; Wed,  3 Dec 2025 06:54:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11B596B0030
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:54:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE4D4BA70B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:54:50 +0000 (UTC)
X-FDA: 84178003140.01.371EA84
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id 01C6AC0005
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:54:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L0dZstzd;
	spf=pass (imf28.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764762889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVGpdLa116dIeXUvqXQFtHZRxIO330oKfcPhDgI7i4M=;
	b=uC84WAoU69SUPvnNAzE0mos0oUwz8TyZdrjJSD0o0PWoq6eMbXGCv4KDLhpv+/csVHnuAY
	jhrEi9slNZHupQFt66od7UYGsvq3ramOX3cDABxzm7q+bnWTQEvLS/FCJmZawgMsV6a0Bz
	AgEMkFxCS0houUi8aVZBHeDd5DQl1DA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764762889; a=rsa-sha256;
	cv=none;
	b=ghOQoy6oIOftFHx2ClOzCwaWNwNclSheWhUZNdeydEFmc4lMfu0DXX8A0xfFJbYpjqYxuD
	bd10Q9WLlbXCmn3j2gCwoMoHq80zqcpiO5BCgEhgc4KYNm8TgbDfZv2pPzEQ4eygeBEmjx
	ctlwLIpkfoveR8VDsYxpwSG/tP8DVzQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L0dZstzd;
	spf=pass (imf28.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b7373fba6d1so1044443766b.3
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 03:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764762887; x=1765367687; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVGpdLa116dIeXUvqXQFtHZRxIO330oKfcPhDgI7i4M=;
        b=L0dZstzd4icqb42CE9pOwmH74Rvub6Idrn6mSni7yTmgvkn+IIpJGT4fjHYOUsESwn
         hxFW6rZF1e3VT3jSp72Xw7Jx9QohvWeb1ttr/p4NyQqQdPjkStdV7wzQ9Gusaov2fhkK
         1zblMKLsu3SmevKvsjyNYZ9ARTvM9BNfpSPr0uZKSnovnTkBjXzaLEYgU405QlraOCbq
         Lht8e0bCeoSIjopz6zI0gkAcyQTI0ZQ7tuuiIo/pHZkUIzWbmaRksilpPPNC/usirqA/
         6ozPaAsibF7HJvzMbmFsc9WH3CgA9mouEszfCq2O3NA2wl/lyJOunKHY0os8GzhFTUbu
         9iPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764762887; x=1765367687;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NVGpdLa116dIeXUvqXQFtHZRxIO330oKfcPhDgI7i4M=;
        b=CRTrw8wDi5jUU2E2b+J/2z78OfpBetoLbrUp4p7F0UcmAvkSiGnetin5psbYvMESk9
         oz5WtdxihcDX+3mVVcPRGCHbZZ7+R3UCYWALZ9CY5HOOu16hSHUOUnJ2J9FcNnVqJ7AB
         pH4QTsrbUoZG6J5RMa0wRH9hQICWysq57Ear9iAwWyfJZLU6Cbj730wbYa2nukBa6Cn4
         9aBxCnuJcMz9Px5yhCnPSL8XkWxoRnbIvmnVQC4UQDXHLavMYBxQK67aiTIdic203S3Q
         8NJ5LkHOBg5LsDCo9K8SM07xqFQVAQVVvn1Z9zkWkD8iV1vUbGIPqDqNWsloI/CvZCtj
         sTjg==
X-Forwarded-Encrypted: i=1; AJvYcCWDb2ckZSQmvgh9zaU6ytq8BJkp36KVvE62nDtGbYE7yWBwQgiafl9K/r09duBFpiCzTum8uDcI0w==@kvack.org
X-Gm-Message-State: AOJu0Ywcqa4mK4yGw4GdRkFaBXESrz2nBnYYCupF7AnQM2KrsIyEEFUA
	Q/7si1djg7gatQ5BrURiwV/roTxr2Hf1tU+9/wx08Lb2T68YfdIM4xy1szWYa4LWxY7zgUmf+BF
	/63wt3u4GS4vCqelYy/asBcqoF4gbQ1V/V64s
X-Gm-Gg: ASbGnctx74Evd2Kunejb0cL1COq1AePLvdD5P5c903wtmQ+4u0w6C67tXPxGdFZ4bdY
	jr53oCJdmx62JRYiuiw/iq3SoqO08Fa7etdcvIHjY4axtDIOn1aRbeMysMVoSDwUff3FruHWwts
	iESRVh00HBk7A3dlFzPSGIl+3pTPrxaeXddCNox+86zfGiAzWymTMq4xCNBK+jTOa7HXydTgAp9
	Eqh5E8Ll5C1pBeQRr8KjaEdmdzyrTV0Uog1G/E5t7CXGn8VFT8TR+JnDam13LhLQBLd5eKZt0BT
	ODxOnrtP/Nf8JMs7gM8fmMCX9Q==
X-Google-Smtp-Source: AGHT+IH2ZIevbSv0QjQ6oVyG39MOtaOZy5YzaXhF18NDvi8PPny1hTtTOHiPWcnHl0Zb1JeuWL/JN3UTDxO8piGzsDU=
X-Received: by 2002:a17:907:1c84:b0:b76:372f:78ac with SMTP id
 a640c23a62f3a-b79dc520e6emr230516666b.28.1764762887114; Wed, 03 Dec 2025
 03:54:47 -0800 (PST)
MIME-Version: 1.0
References: <20251127233635.4170047-1-krisman@suse.de> <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
 <877bv6i5ts.fsf@mailhost.krisman.be> <CAGudoHFZhrNwM8bnkFUkad4x_ibZZqbax_psF7CX_SrFQprJbw@mail.gmail.com>
In-Reply-To: <CAGudoHFZhrNwM8bnkFUkad4x_ibZZqbax_psF7CX_SrFQprJbw@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 3 Dec 2025 12:54:34 +0100
X-Gm-Features: AWmQ_blyrBm5pvxbkfY3lz7jMCx46GDf7UXzl5phU-F17thYs_im5ssjyIVwXKk
Message-ID: <CAGudoHGYC=TdLfzQ0wW5NOrZh1Xy9aSHEYiMLqv_ekX5f52M7g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: Jan Kara <jack@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 01C6AC0005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 6ibckig9ugn48mi1o6opihthjnmn7bmo
X-HE-Tag: 1764762888-636989
X-HE-Meta: U2FsdGVkX19mEFfnt+j5lhp4H6JkS5SIx42N1CeluXX82H2gMWWyMdWQxqPkDIJpMPAzvCnBayUaN/jBZgHnXLErdfVRTbktBbgfu+h6QevgZMM9zLIVFoGgetUL9D7Ll7+241HY5EqnVlb/SzMYLMD6daq21Z3p5Wuh2Xw+13R8uVYEMTgMVSOdocpZ5DsjwxBOjh3W8sW/Nf5Mww5VtOD6GmeIcx0LrAhvmbtLOV2Uad5cY8nvKx9EoQQ8eO9gZifZ4vUjG5sL1JEaIDlvXqOzW4YfLTL3ReIGkaQOunfhufH/y06hWhxHqECL5Lq88QeBl9KW596k/5v+5Q7+07lQNobhJxvnLY/YBJrqTKVOm4DXwUUUfu5At4T06cT36mBclhkqPm2FhXR9qJK3C+nvr6T/i9hSW61kTaIiSIdwWdjHhS8rKIjQmsxly0/rNgEMxiLZ3IQOK5TKJ95425fnZlciIqbE8Y5NlVj3vFUWV5r7h6C7wMS5ayAajmkyF2/zwZZKM+JOmcxFvA1S0TsnFOObUWRwNxUsAfrbC2Bn5J3axVMKyIwZ00XQqvHXtSBMNGyTgrktCCCVzX+40HtSDYnkKX2f+bNNRhdGdRxQux9VFmeYL+kFcYSAuLOvPDss9TKibwwhDR68licYMs91mj5LEvCA8iDNV/RXYaq5baMTPe5vkLQGEO/0SpsnJvvv2hwgR+OZc//6788Lew96hOk6ePwfQm9t6aZbrWX3310eeWJhMlRJUFvj1kI7IZQiP5hpJaILa/1JDkjeQzaQAejSx0BT/Enr072qhda5sWwseb7b6GDpqCKpmpTlrlf4L1rVNMx5e1abWV5iXbqukcT8Z3RMSzU2gTRWh8UOgXZ4Q7qFAYuqz7FlvG8MvEawrDrluLUKq3nHkqWaVURN11n+s7ANpcFMyYbmlDa3D6/7oy5UtjBo47/zFMz4kvV7DKMgurR+vuB/gyW
 ajuPJ8Ys
 o4nKHkRrFxRK9C+osmwD1tdIQjNkVZEfGeWRskjh5hoYGnocVpjkR/lIyyfJBedegfvaHd3ARPf+FeA0tBzrDhJ7Db/yJab89WPFAe088VdH3soks4LRFkfYzWd2EcY/g/cCmsawPhOldax97rNSpIrpW5d2wMSXWQgDJN4fcKNm9OR2E3JwVxvnPQMiOrneusTJN3gMpeA/X4D8+vkHfBxuwJeI+X9EajuN/A9GKSiGsw/NHR5I6HKetzVr+aAsz0jJBI2/Kejje1Cn5RAf4b+UsFB9ZdvCYVsUN1cPkb+jXoxFgmZvzSMR8y9daYV1SCONTfhQOyNa/c1d7Flk82fp7O4vgAhSL7ENsTRuPjPjd6LjANQn2Awc/is8J2aaQI62OTXCO4q9c9A2gVNepuJcuFAx/YxOepuF72bFTkOV4Fo8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 3, 2025 at 12:02=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> On Mon, Dec 1, 2025 at 4:23=E2=80=AFPM Gabriel Krisman Bertazi <krisman@s=
use.de> wrote:
> >
> > Mateusz Guzik <mjguzik@gmail.com> writes:
> > > The major claims (by me anyway) are:
> > > 1. single-threaded operation for fork + exec suffers avoidable
> > > overhead even without the rss counter problem, which are tractable
> > > with the same kind of thing which would sort out the multi-threaded
> > > problem
> >
> > Agreed, there are more issues in the fork/exec path than just the
> > rss_stat.  The rss_stat performance is particularly relevant to us,
> > though, because it is a clear regression for single-threaded introduced
> > in 6.2.
> >
> > I took the time to test the slab constructor approach with the
> > /sbin/true microbenchmark.  I've seen only 2% gain on that tight loop i=
n
> > the 80c machine, which, granted, is an artificial benchmark, but still =
a
> > good stressor of the single-threaded case.  With this patchset, I
> > reported 6% improvement, getting it close to the performance before the
> > pcpu rss_stats introduction. This is expected, as avoiding the pcpu
> > allocation and initialization all together for the single-threaded case=
,
> > where it is not necessary, will always be better than speeding up the
> > allocation (even though that a worthwhile effort itself, as Mathieu
> > pointed out)
>
> I'm fine with the benchmark method, but it was used on a kernel which
> remains gimped by the avoidably slow walk in check_mm which I already
> talked about.
>
> Per my prior commentary and can be patched up to only do the walk once
> instead of 4 times, and without taking locks.
>
> But that's still more work than nothing and let's say that's still too
> slow. 2 ideas were proposed how to avoid the walk altogether: I
> proposed expanding the tlb bitmap and Mathieu went with the cid
> machinery. Either way the walk over all CPUs is not there.
>

So I got another idea and it boils down to coalescing cid init with
rss checks on exit.

I repeat that with your patchset the single-threaded case is left with
one walk on alloc (for cid stuff) and that's where issues arise for
machines with tons of cpus.

If the walk gets fixed, the same method can be used to avoid the walk
for rss, obsoleting the patchset.

So let's say it is unfixable for the time being.

mm_init_cid stores a bunch of -1 per-cpu. I'm assuming this can't be change=
d.

One can still handle allocation in ctor/dtor and make it an invariant
that the state present is ready to use, so in particular mm_init_cid
was already issued on it.

Then it is on the exit side to clean it up and this is where the walk
checks rss state *and* reinits cid in one loop.

Excluding the repeat lock and irq trips which don't need to be there,
I take it almost all of the overhead is cache misses. WIth one loop
that's sorted out.

Maybe I'm going to hack it up, but perhaps Mathieu or Harry would be
happy to do it? (or have a better idea?)

> With the walk issue fixed and all allocations cached thanks ctor/dtor,
> even the single-threaded fork/exec will be faster than it is with your
> patch thanks to *never* reaching to the per-cpu allocator (with your
> patch it is still going to happen for the cid stuff).
>
> Additionally there are other locks which can be elided later with the
> ctor/dtor pair, further improving perf.
>
> >
> > > 2. unfortunately there is an increasing number of multi-threaded (and
> > > often short lived) processes (example: lld, the linker form the llvm
> > > project; more broadly plenty of things Rust where people think
> > > threading =3D=3D performance)
> >
> > I don't agree with this argument, though.  Sure, there is an increasing
> > amount of multi-threaded applications, but this is not relevant.  The
> > relevant argument is the amount of single-threaded workloads. One
> > example are coreutils, which are spawned to death by scripts.  I did
> > take the care of testing the patchset with a full distro on my
> > day-to-day laptop and I wasn't surprised to see the vast majority of
> > forked tasks never fork a second thread.  The ones that do are most
> > often long-lived applications, where the cost of mm initialization is
> > way less relevant to the overall system performance.  Another example i=
s
> > the fact real-world benchmarks, like kernbench, can be improved with
> > special-casing single-threads.
> >
>
> I stress one more time that a full fixup for the situation as I
> described above not only gets rid of the problem for *both* single-
> and multi- threaded operation, but ends up with code which is faster
> than your patchset even for the case you are patching for.
>
> The multi-threaded stuff *is* very much relevant because it is
> increasingly more common (see below). I did not claim that
> single-threaded workloads don't matter.
>
> I would not be arguing here if there was no feasible way to handle
> both or if handling the multi-threaded case still resulted in
> measurable overhead for single-threaded workloads.
>
> Since you mention configure scripts, I'm intimately familiar with
> large-scale building as a workload. While it is true that there is
> rampant usage of shell, sed and whatnot (all of which are
> single-threaded), things turn multi-threaded (and short-lived) very
> quickly once you go past the gnu toolchain and/or c/c++ codebases.
>
> For example the llvm linker is multi-threaded and short-lived. Since
> most real programs are small, during a large scale build of different
> programs you end up with tons of lld spawning and quitting all the
> time.
>
> Beyond that java, erlang, zig and others like to multi-thread as well.
>
> Rust is an emerging ecosystem where people think adding threading
> equals automatically better performance and where crate authors think
> it's fine to sneak in threads (my favourite offender is the ctrlc
> crate). And since Rust is growing in popularity you can expect the
> kind of single-threaded tooling you see right now will turn
> multi-threaded from under you over time.
>
> > > The pragmatic way forward (as I see it anyway) is to fix up the
> > > multi-threaded thing and see if trying to special case for
> > > single-threaded case is justifiable afterwards.
> > >
> > > Given that the current patchset has to resort to atomics in certain
> > > cases, there is some error-pronnes and runtime overhead associated
> > > with it going beyond merely checking if the process is
> > > single-threaded, which puts an additional question mark on it.
> >
> > I don't get why atomics would make it error-prone.  But, regarding the
> > runtime overhead, please note the main point of this approach is that
> > the hot path can be handled with a simple non-atomic variable write in
> > the task context, and not the atomic operation. The later is only used
> > for infrequent case where the counter is touched by an external task
> > such as OOM, khugepaged, etc.
> >
>
> The claim is there may be a bug where something should be using the
> atomic codepath but is not.

