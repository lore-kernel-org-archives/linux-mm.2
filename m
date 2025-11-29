Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1A0BCFD2F6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 05:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85E2F6B000C; Sat, 29 Nov 2025 00:57:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8153A6B000D; Sat, 29 Nov 2025 00:57:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701BA6B000E; Sat, 29 Nov 2025 00:57:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE7A6B000C
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 00:57:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE9C987C4D
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 05:57:37 +0000 (UTC)
X-FDA: 84162587754.15.A2A6C1D
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf27.hostedemail.com (Postfix) with ESMTP id DDE3A40004
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 05:57:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F5MoRF1T;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764395856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pucvq8UTv64qpwVHdPIZ+2FfvakzVEyw07NIdj5Q+U=;
	b=MElXCuMvfUtNpzWfEcC/v+dILmLiqI/YhJdXk3T2MuGfuLK3U8+yJq2C5h+kp/zr3koiAS
	bdUMxm07GgES5LbPOAPKnEuS0eIVhrzUGAw5duoizmbSQmdcMb7+fYL4cMjs0GAqpr14F2
	YjIu6Zouia53J0N/NxH7A2voAAInM6A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F5MoRF1T;
	spf=pass (imf27.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764395856; a=rsa-sha256;
	cv=none;
	b=ojAGZmrEkZdufboH/xChXCnipmrW7qxQswLuBu2dVBZNy38Xkk4bsm2+3j0jAnw/fBHDn+
	f/a7Jkc6IHSBgy08CMlrcbUQ7O7jBCebY3C81ZX4JgQGocA8ABXbdETuTXdYaW552oWc7j
	1wW+B4J2dVjVszQO8iReIES5/EWN1EE=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-64198771a9bso4810093a12.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 21:57:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764395854; x=1765000654; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7pucvq8UTv64qpwVHdPIZ+2FfvakzVEyw07NIdj5Q+U=;
        b=F5MoRF1Tkbn0kcYb8XmTqZx7lK0vKyNWdYhn0kUplrnJGi4XIjd+RH+yGTvHtFnna4
         vgtwgYhzIY4ZeIiuYk3yZnPE9NuqwrIvGfBjtQLAvmoT5+IPvgjJ8E1Aen0J2V/7Y4Tj
         JMfRSD5Ix6DnLlWI4fV60w7tPz6iTP3dLiLazCPdLUHOBj2uf/uPJD2sonOWhSiKQA9m
         +bRsaMVzWGI7+Q95yeWg70pgPjJIeRvg9Fl/uTIf8qoc2+brchlhYFYdJr2UzsCHO5+1
         JpYh7Q5NIwO2Zp7K/DPSN3j0pS2dilTISvBPF2jv//0Of1RtQ6m4h0JobtU5wW218v99
         Fk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764395854; x=1765000654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7pucvq8UTv64qpwVHdPIZ+2FfvakzVEyw07NIdj5Q+U=;
        b=DCUigYJ/abWTE5NFFlNBATz8AdQXwhF34pwQE9MWQKyC0pzVxbV+4bJYBPzNsauypk
         X2JUDlMzTEuXXblN5t/nT0JTBh3TE9joKtrZ26WsS/VICMeKrCj78CKlxrZdveH3e4V0
         CCH6OIw87qsdt50Ugo7HNDKEvMspxBW+FWhrc/YNdEgtgBc0S3HKKd7pqxUEXEpep1t7
         YntUZqIhdtOGRRnb9winvXSBXXJwbDUHMHM9JuQCs+LusNwGF9AtCpioFQOyP6eQ19Pp
         SlJu1GE2T6VnU0s5DnVzGWnxlxF8viaDKAxQ9+PBhh72i2CId2tLChJytiyaj3BWa5nT
         DU9Q==
X-Forwarded-Encrypted: i=1; AJvYcCWf/AY8uT2f774AiJoBpwkMNO9uCCtKyiplPMi2JFGllc2aF/TxF9yyrFgoIoIYSX0zcIkqakuX3Q==@kvack.org
X-Gm-Message-State: AOJu0YytQkLesarQM36HukEzjZQIXN4MaXq5swPP+tCR6AlwKXrCPOBp
	mkS+OfWuNLxEAptWzd7gfdsF2xCCrL3kzHyIRME1d2qJDYCiPcceUIAJfnH+xeuKBmaiSGhcsou
	YDaTat+Z2ByAsaODwN9l3YV0bKy3xcP4=
X-Gm-Gg: ASbGnct77QGvwLuCZ+kbHclkphwot/QD+xSUHTmmkm1dxIOby1jA2UdL+2vk741+7Xi
	drhhH4ZQBlkNNlDs5BhVouK+9OwalEsSWXzkclcSukN9BfGxCR20JbhfX6VHfG1x1E63AAVbBmT
	Mg52RlS9kMKbuBQeFSlnZnlQ7ObmAP4yzVWnDrU6Vuxs3oq25EaGx4MtXwWIbo6D0x54qC2dkkS
	afBtAqcj5ziR+GTDg3FbrvVGZYbJDyho+5IbvvKUleATHw292ugEpoP08Gg5yCB1hBYcbKmIYUC
	hkrxDli7N6/Y0MYwxhitAh144g==
X-Google-Smtp-Source: AGHT+IGgaoRpdfEmgc8Id6eVtbvXCmDKZ6RVqHgdv+n0xRKP3FUTsLvtBF+027sAzwMYNBHB0rtwcqnSPG2haI6VYHA=
X-Received: by 2002:a05:6402:1475:b0:640:c8b8:d55 with SMTP id
 4fb4d7f45d1cf-64554339bd6mr31939720a12.3.1764395853975; Fri, 28 Nov 2025
 21:57:33 -0800 (PST)
MIME-Version: 1.0
References: <20251127233635.4170047-1-krisman@suse.de> <f1a1b7ba-c084-4e41-9242-8255f2664b76@efficios.com>
 <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
In-Reply-To: <yvghqmbugs3oejsvbh5rrw76rvtr2wfwqysjd7tw67z4tzpdbp@6zehhuzumiez>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sat, 29 Nov 2025 06:57:21 +0100
X-Gm-Features: AWmQ_bn6jVVRbPFZERZlQjSy9G6SnJ7CCksAbVsbn-o8u7rsKoU4Ih49F9s24kM
Message-ID: <CAGudoHEyX1gdwG_MVf-M2KMHBE1Juo6VbfSyp3rbXoS+5JaNtw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] Optimize rss_stat initialization/teardown for
 single-threaded tasks
To: Jan Kara <jack@suse.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Gabriel Krisman Bertazi <krisman@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DDE3A40004
X-Rspamd-Server: rspam02
X-Stat-Signature: npqkdo3k8acg8iydie5hnzn7p3sqx968
X-Rspam-User: 
X-HE-Tag: 1764395855-54506
X-HE-Meta: U2FsdGVkX1+x0ceOWMxsTvjXn+sQWXeRYqECZTwk2A39oqGQkE+yquu/CQvkf/MUtcy8WBWBpitNMh1THSD++YNO3YM8jG01tdp++hGdudXxqd3sSsJEWEbGAUT+Ae4cVfQPplatPWrl0Y2hsstAdGoMIdq9SEI3M0EghjPrUV4xqC8FBfTxRzw7gbQcEU4F48cr0xU+y+ZzQMVblXoBo8chCgY+C0SHwOlxSqozVY8DT4KIGOc7xgWH4A2Uu9uWnjbPifsoaN9zNIYr/cu1+3IY/6FmTWPechR1+KnJxZWdn0u67SrM8yCEm7F7L9iyZyOyg79P6Cl1jOu0qZFOpZ/PwJw/kysxoi4K5nu7qT1M3pkwsDgB0fpN5pU6X5+34ONz6njAhynBWld1EMLANEh9L24lyALWlbruQIh4IiAhZcNSDcQb+pnwTJDmXl7AGj0ul9Nl8KZ+wAraMLG1+/IFwYZgpN4+s80gQtPz/x8ue4rQU7KQOR2WIXcdy4Df4/0hpK+lDs6a2ySYIuuT5CezJepOdm+APfiImqMrRSMPazpGh4JgSPzYZ2Za1Zmg6GRvGh0eJqPAITLyKznuRrTZZbqzAPyFXcYSV41zWTBbnODCo9Ut+Q1SVvL+wyXQaBYMb7XunhQXGYZ+5YLH36zYdIQ79f14AziE87+f6e1yy69QCpGoloXsaHyvQSH8A0OhzOEkrx+ZGdl/FIs7bx9+8R37Hl+YELgtVzLUUEdroed67pfkfzSCn62NDeKo3u9DQJaYM8CiMxDkQmsXUM+0zR1VzMDh3t/1JxdcFV7guHeH/do1m/hPW5jflffQxR4a6alVzv+1GHr23tx2mpsrZg/h9Wz4ibJmKtFFiGl9/8j35Od6fEsVn5gYt7AuTyJ3FjblGdCm7rg+2Tn5IFDkPqzuwLyAbvdBau8Z9qPkXNG2bUJj272F0gxNtCSDozk5SxUL6T0ZbUjY7lz
 Jip//JlL
 12CEU4VQLoEQtUtBatBoYaOQ8DzJwUUosh6nFyj133r1G9Hgz464O/R50yvEYGZkqbL9ZyoXX83GuCikJ0srOOLasCIhSnpwz797qOhXcUuzrpFkTCP+6DAoaRY4Rc5myMhiWvaCNJyHsQUEJueJUf5626tSvPIDB1ibFOPAMzuTw3DcSTtHjmhUC61cvvS8cSqRfUjTpi/JLv1FZUV0focY2Ph+lhQznVZ5+UnjwSRDcd6ZD1Qbc2En3iHLoRkckRqclZUs+E4P3/NrRhwagT1sJqoU4FolP4ENzRfaxshMlgHSO0oI++i6iaQkOMgiMbOCT5kRXuQwbpLJymwX3m0UA/ZG1BCWkmbPmSVlt9QYwLKSfFI00xHe0spZxpwHT4bWzD7fv4hwpTinOWWYmum4oqoh5o8wWy+N/zDXQcElUzUY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 9:10=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
> On Fri 28-11-25 08:30:08, Mathieu Desnoyers wrote:
> > What would really reduce memory allocation overhead on fork
> > is to move all those fields into a top level
> > "struct mm_percpu_struct" as a first step. This would
> > merge 3 per-cpu allocations into one when forking a new
> > task.
> >
> > Then the second step is to create a mm_percpu_struct
> > cache to bypass the per-cpu allocator.
> >
> > I suspect that by doing just that we'd get most of the
> > performance benefits provided by the single-threaded special-case
> > proposed here.
>
> I don't think so. Because in the profiles I have been doing for these
> loads the biggest cost wasn't actually the per-cpu allocation itself but
> the cost of zeroing the allocated counter for many CPUs (and then the
> counter summarization on exit) and you're not going to get rid of that wi=
th
> just reshuffling per-cpu fields and adding slab allocator in front.
>

The entire ordeal has been discussed several times already. I'm rather
disappointed there is a new patchset posted which does not address any
of it and goes straight to special-casing single-threaded operation.

The major claims (by me anyway) are:
1. single-threaded operation for fork + exec suffers avoidable
overhead even without the rss counter problem, which are tractable
with the same kind of thing which would sort out the multi-threaded
problem
2. unfortunately there is an increasing number of multi-threaded (and
often short lived) processes (example: lld, the linker form the llvm
project; more broadly plenty of things Rust where people think
threading =3D=3D performance)

Bottom line is, solutions like the one proposed in the patchset are at
best a stopgap and even they leave performance on the table for the
case they are optimizing for.

The pragmatic way forward (as I see it anyway) is to fix up the
multi-threaded thing and see if trying to special case for
single-threaded case is justifiable afterwards.

Given that the current patchset has to resort to atomics in certain
cases, there is some error-pronnes and runtime overhead associated
with it going beyond merely checking if the process is
single-threaded, which puts an additional question mark on it.

Now to business:
You mentioned the rss loops are a problem. I agree, but they can be
largely damage-controlled. More importantly there are 2 loops of the
sort already happening even with the patchset at hand.

mm_alloc_cid() results in one loop in the percpu allocator to zero out
the area, then mm_init_cid() performs the following:
        for_each_possible_cpu(i) {
                struct mm_cid *pcpu_cid =3D per_cpu_ptr(mm->pcpu_cid, i);

                pcpu_cid->cid =3D MM_CID_UNSET;
                pcpu_cid->recent_cid =3D MM_CID_UNSET;
                pcpu_cid->time =3D 0;
        }

There is no way this is not visible already on 256 threads.

Preferably some magic would be done to init this on first use on given
CPU.There is some bitmap tracking CPU presence, maybe this can be
tackled on top of it. But for the sake of argument let's say that's
too expensive or perhaps not feasible. Even then, the walk can be done
*once* by telling the percpu allocator to refrain from zeroing memory.

Which brings me to rss counters. In the current kernel that's
*another* loop over everything to zero it out. But it does not have to
be that way. Suppose bitmap shenanigans mentioned above are no-go for
these as well.

So instead the code could reach out to the percpu allocator to
allocate memory for both cid and rss (as mentined by Mathieu), but
have it returned uninitialized and loop over it once sorting out both
cid and rss in the same body. This should be drastically faster than
the current code.

But one may observe it is an invariant the values sum up to 0 on process ex=
it.

So if one was to make sure the first time this is handed out by the
percpu allocator the values are all 0s and then cache the area
somewhere for future allocs/frees of mm, there would be no need to do
the zeroing on alloc.

On the free side summing up rss counters in check_mm() is only there
for debugging purposes. Suppose it is useful enough that it needs to
stay. Even then, as implemented right now, this is just slow for no
reason:

        for (i =3D 0; i < NR_MM_COUNTERS; i++) {
                long x =3D percpu_counter_sum(&mm->rss_stat[i]);
[snip]
        }

That's *four* loops with extra overhead of irq-trips for every single
one. This can be patched up to only do one loop, possibly even with
irqs enabled the entire time.

Doing the loop is still slower than not doing it, but his may be just
fast enough to obsolete the ideas like in the proposed patchset.

While per-cpu level caching for all possible allocations seems like
the easiest way out, it in fact does *NOT* fully solve problem -- you
are still going to globally serialize in lru_gen_add_mm() (and the del
part), pgd_alloc() and other places.

Or to put it differently, per-cpu caching of mm_struct itself makes no
sense in the current kernel (with the patchset or not) because on the
way to finish the alloc or free you are going to globally serialize
several times and *that* is the issue to fix in the long run. You can
make the problematic locks fine-grained (and consequently alleviate
the scalability aspect), but you are still going to suffer the
overhead of taking them.

As far as I'm concerned the real long term solution(tm) would make the
cached mm's retain the expensive to sort out state -- list presence,
percpu memory and whatever else.

To that end I see 2 feasible approaches:
1. a dedicated allocator with coarse granularity

Instead of per-cpu, you could have an instance for every n threads
(let's say 8 or whatever). this would pose a tradeoff between total
memory usage and scalability outside of a microbenchmark setting. you
are still going to serialize in some cases, but only once on alloc and
once on free, not several times and you are still cheaper
single-threaded. This is faster all around.

2. dtor support in the slub allocator

ctor does the hard work and dtor undoes it. There is an unfinished
patchset by Harry which implements the idea[1].

There is a serious concern about deadlock potential stemming from
running arbitrary dtor code during memory reclaim. I already described
elsewhere how with a little bit of discipline supported by lockdep
this is a non-issue (tl;dr add spinlocks marked as "leaf" (you can't
take any locks if you hold them and you have to disable interrupts) +
mark dtors as only allowed to hold a leaf spinlock et voila, code
guaranteed to not deadlock). But then all code trying to cache its
state in to be undone with dtor has to be patched to facilitate it.
Again bugs in the area sorted out by lockdep.

The good news is that folks were apparently open to punting reclaim of
such memory into a workqueue, which completely alleviates that concern
anyway.

So happens if fork + exit is involved there are numerous other
bottlenecks which overshadow the above, but that's a rant for another
day. Here we can pretend for a minute they are solved.

[1] https://gitlab.com/hyeyoo/linux/-/commits/slab-destructor-rfc-v2-wip?re=
f_type=3Dheads

