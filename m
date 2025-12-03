Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 069FED12694
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:02:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBFDC6B0023; Wed,  3 Dec 2025 06:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B70466B0024; Wed,  3 Dec 2025 06:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86AC6B0027; Wed,  3 Dec 2025 06:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98EC06B0023
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:02:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4DA2A132F81
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:02:23 +0000 (UTC)
X-FDA: 84177870966.15.110957A
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id 517822000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:02:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FwtFMygn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764759741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zjQYrUnYX1G9wDCWJ9hOUs6jlLepDKVfUAud87QaSZE=;
	b=Mtoxx3Dw0866G13urF98wKpTH5chnqDOPlz2rJqLVSfSyHCnIb4nBa71cZGNwb8gDqu3CQ
	6VHROw5f2r0UqXJUbU7AIr9kvNm8zFvTcrPfky0ClwRW6K+ghrqGry3Yp+BTEhJYZbU6lK
	2gcAvooCXAMkSka2x5FRLGSU61DFaAQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FwtFMygn;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764759741; a=rsa-sha256;
	cv=none;
	b=KI0yVqXkXP6yceeLMd2s+gfx+U/U9ioetDZ3ivOPsOi5ata+TM8VodI59lJYZCiIce5d3K
	XOriywon7bZ6HNHptfbwogzBgbx8zdaNYvsuUEUxRKaXpaYrhTF5OpynNLrhOJJinXiw6/
	p/ccC+yB/Z59PQCehiXkTY/hngkCJV8=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so9842640a12.2
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 03:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764759740; x=1765364540; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zjQYrUnYX1G9wDCWJ9hOUs6jlLepDKVfUAud87QaSZE=;
        b=FwtFMygnStk8rulIlzYzhnugDqFifekRpCfTE+c45YJdBz1UTlNBCMzQL6HTjNd8aa
         QccacdVH2HTdcGyrvf8i3Ltz63KR6SNMS9ZmoE4KAM+2h63+ioX7bNZzvaaQ+GwhYURU
         nBjmqWHymEzeRmjLV0e7Ec+ZTUhFEyW0mlxwPpfqkhduTOryilJ58QFa5l259E4aQTry
         Zfj6Lgvfmz5BKjqMSINGynlQdWS6kD6r5tflWZzt3EFBvS6DCkVKNqVuoA8g04THInXU
         ClOnr5eM0jNEBWPhKzrPFo6YjlOtMj7FhICQmBnfxOBRLDjeSr+Mut5uvsaJr32S76iN
         8hwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764759740; x=1765364540;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zjQYrUnYX1G9wDCWJ9hOUs6jlLepDKVfUAud87QaSZE=;
        b=iu2u7MJFepDA6s2U3I2EMwZan84klF84QmE9ZvGkwHtWXbTYsz2paTcru6ZVo5Horx
         B4PnjpWcfANL9KNnR8xMmAZ0xLbDhPLthqYGSpxAJUr68/aq37Lke7PUMTcU0XaZCs3e
         N9U+MT0BOdycGeXjKzAHLQWC6sJJZthxDlS3mCXwGA7ZYlOa7eNfNEcHOmdv4FD52KuM
         GX+8cv6Ky28FDjErepSEtY4TuZCVXU1vTxMajaSlKfLLOk6HbLzBzf2/+UgtjlYYhn+R
         lKR2/wlCKJhwJnTrgFsvVVqCoMkDVSXrWbRiBYDlkLcq2BCdcFYy02/fQEmASZDTdsse
         EkmQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+BslErsHwSdmu8+xGfxI2aVwW+oHE8Orj0fce5qUn/G0CzXtJv+vt/imTkbmm5qRR/B22a+vPCw==@kvack.org
X-Gm-Message-State: AOJu0YxXNmutWDyjZ0E8qJLd9tRiiVf+d/GW4BM9Gb4584ChIpbJAmnS
	J/PoGdO+EwUtoAJhun6VpU6iNOsZyo5MCqyby3U9MVD7WhFpUaCr3GN0RMM4NNm1lhktMm/hkF2
	zCIgGWRQfWRiJYeN7d0WwyUumcOmgpJY=
X-Gm-Gg: ASbGncu9PFX/eGM0ujEar4W2W9yEjFesx60Ggo7MfAM2ZJE7fFEEWXhIpTFBeL80su7
	jyjb6KnnNtawWEEqlNnr3UZLBA9QNZmoSlij8eJYDBK4opzr7RC0vwcCV8rxC4mLeDydzt94NPh
	Y1f2ieuuUxBG0KPmkRuWcs2B/cpp6uRFpAwXpf3TsgP5So+d+fdMk2k0z/TNxuzyejINv7mG1hV
	nvx4cDxrXdSffLDceUzwoc264D4yiEEPm0kb6Raascf/eLAIR7sBNCMQkmHKZ2rflOq6ldLqyYm
	kyRPpOsrBjLRRV1FfWp8HJ2r3w==
X-Google-Smtp-Source: AGHT+IEQR049x/z36Hoy4skA6q5Rf3EXQ/Q+JEh9RSkhbclOdc2LpB4wKZveqW8J8qqMdVRf6bIjskDhQZBXsHTIZiw=
X-Received: by 2002:a05:6402:34c8:b0:643:8301:d107 with SMTP id
 4fb4d7f45d1cf-6479c4c15e9mr1452948a12.30.1764759739416; Wed, 03 Dec 2025
 03:02:19 -0800 (PST)
MIME-Version: 1.0
References: <20251127233635.4170047-1-krisman@suse.de> <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
 <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com> <877bv6i5ts.fsf@mailhost.krisman.be>
In-Reply-To: <877bv6i5ts.fsf@mailhost.krisman.be>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 3 Dec 2025 12:02:07 +0100
X-Gm-Features: AWmQ_bm0SWtbGrNBIQV7TXNIM9O_HeQOx1RP9_10jbGVkW1uvCtw8rd_7IQW5cY
Message-ID: <CAGudoHFZhrNwM8bnkFUkad4x_ibZZqbax_psF7CX_SrFQprJbw@mail.gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 517822000D
X-Rspamd-Server: rspam11
X-Stat-Signature: 774ab86abrwewgagquzwg4pipnkonkhc
X-HE-Tag: 1764759741-387183
X-HE-Meta: U2FsdGVkX19oIxX4YpCySwuMP5viTHP+XnSQ70Mto1D2F4sysTceMF54vg1YpsUsaLjcXKaCxYx3juyqFP3E3MQtI+53Ll8DP8L2GsSRzophJVcjvCtg9qceRSGwK4DlNhx7K+Tv/MAYdRay/jVjQxSR+PLIsLy1VEHZ9avbKMjPAPzUlwWShqc7MyeTM6/ZtnAcCXOXpOcEdwaQU17tXOXLsxAutLwDufGK7HkQWnojhkpDFGjvXV9D3G+BI11sscgtkxCSUdQpUT0kkQYLbmU3IQuQVpXb6H3WR2VEqpxl1/DPfAh5i8d4fg6d9JqsYYNjkZH2h2wGHQ7nIMiBrRjgRNcvw5jv0YQ+hTA6hSEJwgs9F7YkvQoxarVW4AqO4WFRZfgaR/p/Sgwvaq1gQ9ho60SJw/MEMzfk2lZ2URNBlU6UHuZecW0q4OmLF3P8YXMjJnw7CLPYktqBQM5eGM+iB22ExBmfnT1Hgtd/azDv0TI1B/AsclH5jUs9VHrzlpWKoEI+amAmE57GqhuPj3rJ1FVA41JqGo8+5eCKSgEGjrntD7nW/ERgfsLeQ31ySQyPBClEwPx6nrIe3wwcJWnhStEjp829Zlm7TzhjcMpHjfoantE+6DBTO1VSxPy+gdt6Cs9DhkBNq2IqlsTVldkLvxCJmgoVn9+dSRLWGARaJRmcPaDsvGwLUu3Cc7F74Uwwq4FtqxI3n2G2u8MMn4ZlW6zatpmPhW8HFS6mhlGuOQQtRph42TBbA/SxDyrB9ZmSWwp4+/JJyXwpMg39FJ6XvSV+7IZh8x9KcSkvd2uVqy2fMaRLGu/Qr9jGHu+EgWIpiSjzq8itOwoQx6/ws1StM9hOfr+/9Y5JPzBlSV5ped3KpgU7+d1Zpb+rfHWYZvplK+4tWkfYD4lvSSwAq8TmjrzHe/EwmD4x2f4CH26ZD0xh0a0hp2yZWCRpvSIUHJU1Aqvpk0pEkkrg/jL
 VUxSYEKE
 AdIYMeD4PQM3TDZ1iWjZxZ/05GjGdV/YpPFgvJC9smdmXFj43eaB3vMpDAxSmaU8UorSX4h7wNjeR7iC7vz8MBJvScwZVeXvZOJphTG5FcWWBOgtRk21Z9Bpav3AiFoSZJ7J7RNWwxrVePyghFDJ56BTaiQrbvMk+nX4LBBAVXCignWJRNwTwoiFQYygnQtv36koCX0AEurP/c8U3svo5T0Zy1buj4mQqPrfsDllz5P3/ETA6uQjVoTj0hWJKCxdnHnUcnRiUR5KzuV1SrR8JZcQ6FH3dyGmmNYMrPTfwHOTSSPVWszEwyYc8S09tTSaNfPfguxr7Bm2ZSveYni3Jt6I/N0iV4wDoMtdgvhycpxJFr3XZTczH3YmCyK3I3aFOJXZYPeaMqxZ4oJoqtJLphUl1EEVKkWUFjzhd1AWGiZfvof8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 1, 2025 at 4:23=E2=80=AFPM Gabriel Krisman Bertazi <krisman@sus=
e.de> wrote:
>
> Mateusz Guzik <mjguzik@gmail.com> writes:
> > The major claims (by me anyway) are:
> > 1. single-threaded operation for fork + exec suffers avoidable
> > overhead even without the rss counter problem, which are tractable
> > with the same kind of thing which would sort out the multi-threaded
> > problem
>
> Agreed, there are more issues in the fork/exec path than just the
> rss_stat.  The rss_stat performance is particularly relevant to us,
> though, because it is a clear regression for single-threaded introduced
> in 6.2.
>
> I took the time to test the slab constructor approach with the
> /sbin/true microbenchmark.  I've seen only 2% gain on that tight loop in
> the 80c machine, which, granted, is an artificial benchmark, but still a
> good stressor of the single-threaded case.  With this patchset, I
> reported 6% improvement, getting it close to the performance before the
> pcpu rss_stats introduction. This is expected, as avoiding the pcpu
> allocation and initialization all together for the single-threaded case,
> where it is not necessary, will always be better than speeding up the
> allocation (even though that a worthwhile effort itself, as Mathieu
> pointed out)

I'm fine with the benchmark method, but it was used on a kernel which
remains gimped by the avoidably slow walk in check_mm which I already
talked about.

Per my prior commentary and can be patched up to only do the walk once
instead of 4 times, and without taking locks.

But that's still more work than nothing and let's say that's still too
slow. 2 ideas were proposed how to avoid the walk altogether: I
proposed expanding the tlb bitmap and Mathieu went with the cid
machinery. Either way the walk over all CPUs is not there.

With the walk issue fixed and all allocations cached thanks ctor/dtor,
even the single-threaded fork/exec will be faster than it is with your
patch thanks to *never* reaching to the per-cpu allocator (with your
patch it is still going to happen for the cid stuff).

Additionally there are other locks which can be elided later with the
ctor/dtor pair, further improving perf.

>
> > 2. unfortunately there is an increasing number of multi-threaded (and
> > often short lived) processes (example: lld, the linker form the llvm
> > project; more broadly plenty of things Rust where people think
> > threading =3D=3D performance)
>
> I don't agree with this argument, though.  Sure, there is an increasing
> amount of multi-threaded applications, but this is not relevant.  The
> relevant argument is the amount of single-threaded workloads. One
> example are coreutils, which are spawned to death by scripts.  I did
> take the care of testing the patchset with a full distro on my
> day-to-day laptop and I wasn't surprised to see the vast majority of
> forked tasks never fork a second thread.  The ones that do are most
> often long-lived applications, where the cost of mm initialization is
> way less relevant to the overall system performance.  Another example is
> the fact real-world benchmarks, like kernbench, can be improved with
> special-casing single-threads.
>

I stress one more time that a full fixup for the situation as I
described above not only gets rid of the problem for *both* single-
and multi- threaded operation, but ends up with code which is faster
than your patchset even for the case you are patching for.

The multi-threaded stuff *is* very much relevant because it is
increasingly more common (see below). I did not claim that
single-threaded workloads don't matter.

I would not be arguing here if there was no feasible way to handle
both or if handling the multi-threaded case still resulted in
measurable overhead for single-threaded workloads.

Since you mention configure scripts, I'm intimately familiar with
large-scale building as a workload. While it is true that there is
rampant usage of shell, sed and whatnot (all of which are
single-threaded), things turn multi-threaded (and short-lived) very
quickly once you go past the gnu toolchain and/or c/c++ codebases.

For example the llvm linker is multi-threaded and short-lived. Since
most real programs are small, during a large scale build of different
programs you end up with tons of lld spawning and quitting all the
time.

Beyond that java, erlang, zig and others like to multi-thread as well.

Rust is an emerging ecosystem where people think adding threading
equals automatically better performance and where crate authors think
it's fine to sneak in threads (my favourite offender is the ctrlc
crate). And since Rust is growing in popularity you can expect the
kind of single-threaded tooling you see right now will turn
multi-threaded from under you over time.

> > The pragmatic way forward (as I see it anyway) is to fix up the
> > multi-threaded thing and see if trying to special case for
> > single-threaded case is justifiable afterwards.
> >
> > Given that the current patchset has to resort to atomics in certain
> > cases, there is some error-pronnes and runtime overhead associated
> > with it going beyond merely checking if the process is
> > single-threaded, which puts an additional question mark on it.
>
> I don't get why atomics would make it error-prone.  But, regarding the
> runtime overhead, please note the main point of this approach is that
> the hot path can be handled with a simple non-atomic variable write in
> the task context, and not the atomic operation. The later is only used
> for infrequent case where the counter is touched by an external task
> such as OOM, khugepaged, etc.
>

The claim is there may be a bug where something should be using the
atomic codepath but is not.

