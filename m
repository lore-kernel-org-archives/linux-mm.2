Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104DFCDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 23:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 976396B0096; Mon, 22 Jun 2026 19:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94CFA6B0098; Mon, 22 Jun 2026 19:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8630D6B0099; Mon, 22 Jun 2026 19:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 53DCD6B0096
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 19:00:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B021EC106D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:00:43 +0000 (UTC)
X-FDA: 84909069966.19.CD8FCE4
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9EAD2180018
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 23:00:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qLxSP0XA;
	spf=pass (imf16.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782169241;
	b=hEEm5NKmFvN4xFihWrWh28UCJcp85bVYsIn4KY8O51/LK2SPwgIilKtfFYBQ9fyfHyczW1
	jXR5UjxqWu7A0YpI/opP+8evJ6PWs9aAUW5Xr4uhwDG/f4bM30c77vWWShmRP+owuuGgC3
	suRlCit9r6Lj4lyCRUotltdPmo6WNxc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782169241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+42+q8Rs66jl3Risg85EoToJVXof57Oaz+y/U1lIlLU=;
	b=gYjYp3wQHAzQnYNZ4B9wRgV72swQmN0kxBFCjK3+8riYovTSe7cD4FSoc55gKkDCFceScr
	GWQK6bSqKap9p/fajppsb3BezaKr5f6NuQx66CSNzQEIawOqU7lkseQjP3RE5EMe5QldS3
	jNyHV/ZNj+PhWE/W0E1v//n37f/aGxs=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qLxSP0XA;
	spf=pass (imf16.hostedemail.com: domain of zokeefe@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5177d1ff061so55281cf.1
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 16:00:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782169241; cv=none;
        d=google.com; s=arc-20260327;
        b=PWttkG30b3QYBMH5a4JTXna5IKbeQwy8hzbFZflkAYFhvP2cZZlBzgfOuLUDhacIgW
         +1Yi7y2f5aE0qKD5zh7odlnAODG4P50tcxchUNpzp30Mh414U6acZDX7uEeh2vRx25Y2
         kP4dS5vJhcxyYPkg82IMeufPLOVyKyhdT9n52kWyM/WYD/qJx/bus8K/yEI2WUKNlyDm
         5IoRHk2Rt5wucZwxwlxTqVFdie4F/2lj9yRnEjtKmN4n7RTSQCRt4z1zZjrFJrU1hXRS
         7suZxfH3sDF6sLyWTrE1x6WWOrxbWy9rHbHB+II32Mk2eDqcHsvsVXd3laj7KSlMQkSp
         UpyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+42+q8Rs66jl3Risg85EoToJVXof57Oaz+y/U1lIlLU=;
        fh=Enxg71LIGGbh2WADEUAK6Yu4+2W1STeGtaFpWLo63t0=;
        b=h5YH6qvW32eLyQAZutSYz4AslLuj03NNOUT/AppktraWj1ghSydQkzVunomQlVrdMG
         xKbIsk+wGztcAEu7Gf/Opy2zroFHvATyNmjDBQkjnpLChdHY45NncEliNNMM1QXnztu3
         /gxYg33ORupw7K3VwRqZZTveVbsFANZjxcs0pHERBgPgXOClnVjcOfh+Me50yjbVSxhA
         hQenASGpNd10meimlFIWgWgEfxTQATWHTSiaLLTp2P/JawYGNzfkIbGnGeyxP0mPNyCb
         ZL9YK4Eas+q76CPjWgSPY2sC6TEaq5+5ScQmfdbNrcAEhdhyPotXsUkc1d/YeyYknWgr
         U75g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782169241; x=1782774041; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+42+q8Rs66jl3Risg85EoToJVXof57Oaz+y/U1lIlLU=;
        b=qLxSP0XAAkCxi6xVHlNQLrw3DJxG7BpLafHm7IgV0OOKCoE4dmZo4RqiR1aLlHrzYp
         YPwhcvnOrp7l8TFbvBtNJwKV640DyaS6u+Bx2d1zXdbV//5OeqWIe3rzS0S/ujwu+ZzS
         17JZSjjaaPMB1+uM/VOHi1ibWi8YFYIgwp6TyVnjDW1JSPwQIdS9EGXRqQmyx4pFlz0D
         npBWayF2AHRhKjC372FKVWEP2KiA9Pf/ESQ3Qj4QeRvCMgxTpIMSzlhwUCYxtYk+9IhZ
         caI2ymXGRgrXNJ0cM6QX7Y/ax67ZlFnkoofZGtNxDxUqkezeY1KHsBhrR+Lo45O2S+Lb
         AvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782169241; x=1782774041;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+42+q8Rs66jl3Risg85EoToJVXof57Oaz+y/U1lIlLU=;
        b=nChjhTVqqpspU8EGCLNggt8cnElk1hIY5yND7qlOg5ni9jLs5kYHPp6tHjN9T+Tu+Q
         L9nNQ+9KCiCwQfzqtav5sZWB4GvlFftEl67WYYZjvw3qTzGU7n4bK+APitXwtnovYoEt
         zOUe/oH3PtbGosRIg1j16FhdlYyGyfVm+cqQg7ugQYFe9BNWMm/r1GKiKV19BW+n77Vh
         Z5wSntcttcOEkZb12cwgQUb4C86Ywv8MRzxIbxcg2OJ/9ahUU548ceEr/zALGTzsViae
         enqz4joHChczhTdrnr4uGn33X0+m5LNQInVZvcj/pW8vtvt5lGpCBoOi9GPa7vO7ak6J
         4dCA==
X-Forwarded-Encrypted: i=1; AFNElJ8NZDRUfOPblrfktSPqbVFoc8gLoxUMwfXypk1vbxk/lhCabKLenoslL/EJJqJQgTYYJKxCTWLwJA==@kvack.org
X-Gm-Message-State: AOJu0Yy8nkSzev8SCYQ7k4pSWDwcFv7H1CKi794j2J4j3efKOH791Vs4
	E7XHf0TCTspLi8XpRL/GsEhXpeqL7rLKTdr7Fj//i29ScsJzMNb1ks2QpC+0ynqK4edekqPX4Tz
	YO/PNNS+JrNUDuMdgZGu6PnjxO9NdFgiTsr8E0MtL
X-Gm-Gg: AfdE7cl9ZH/4k6G9UNKxyHbu0OZooDg5SEybnGAb9zWGhNbhgwlB/nBIQSupGmfhNug
	qsU/zEAKEnzB75q/Yd/Z3JaaN+nA7amHog51arGCKTfz3kVSo8q+9F1WFktbdfwh5eOK1fkrncV
	sAsc2aR+RyBWrsDKm2ryMifbMpBvYq3H8RSyBZwC5u9OhtsiLXQ6AG71f27miMSPc6G/J/sRHhT
	FAJ6VFMCevtYzpIBto+PsIrJaAFtdNkpcqi2bnWKKOZjS2McUnNcyjJ7AxY6XhxgRNCyNxjNw==
X-Received: by 2002:a05:622a:5912:b0:517:99ea:ab77 with SMTP id
 d75a77b69052e-51a53db2b82mr1810911cf.23.1782169239966; Mon, 22 Jun 2026
 16:00:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com> <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com> <dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
 <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com> <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13> <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
In-Reply-To: <87mrwon5uw.ffs@fw13>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Mon, 22 Jun 2026 16:00:02 -0700
X-Gm-Features: AVVi8CcGDBEDyRCzLMOtcAdT6QQeNbUGQ0xGcVw3LrnuK_1OS6uXdjles2piITw
Message-ID: <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
To: Thomas Gleixner <tglx@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	David Stevens <stevensd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>, 
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9EAD2180018
X-Stat-Signature: uprgtffkqtxs5ykgrn8a941itzad8iup
X-HE-Tag: 1782169241-834127
X-HE-Meta: U2FsdGVkX18wg1mr84JcUlLs9CP7dUVlryfnIn2jCWLpb5PARYE9nEd+6jjAFSRX2/hZJQXMq9K3NPY1MX8RJpDUikgbafUdaGm3c4rpbhR7uD8yURVI9/I+OBW4wa5Ws+5rqBhdlJKR0zSISDT7E1IWu9vfU3JdzP6FbpxVt23TqdS9Uf98qm2QAQO4sdND/DMTfHiDtFGBHw935Q0KyttqbnyXfVTFzFd7VTKjhFpICIOqbbO3Kf1Pi1lphzwH9g61QyKg/Mq7KUrxh2zEtKtdr9nztelV53PmsVkWNYQVWDXlxO1ekoW9yqBzlg2kWTh+lvJsL4/0qoFHDvL2Fzkr3XCajkPLSqj5weonRHkKIwo3o1xuvCwkRD9zMjxjMstAzTY5TMiMDP3Mei0ZF3zEzjofjeuRFKSNhkZAoGMYxN+bvT5aykgrWRSOOM2/H8SlaDywjKHZ55zrn1Vb3oAvSBeggq+Flpfh9vEICTVVBTi2uhp/GA31/sb0DyWDqw/E7sV1oMZkwHiGIg7E68Li3eL+9bLTo70rLfFVTkjTf0yEXqMcXPFzNPNC1bNq2yHtiQWgCUR1kY6TTvmT0+D1fz9SI3tnCp4nXsbma73IttI/UUVBUJ+NM48YI9KTq8MqNRFN16cOqfrT+cOZbdS0jeexI4m1tDE/gO6iFKvxifAXOk0amauTSS4d5Puj4B6olVeMLmqqHxDA+c1Pd4umALxlLyvOdJRSOE/HWN5Bcw6VjP5XcClKFbRwqnUYRPiOV5dz2hTn4zcEMVwKKSj6vHPFtqoWRcV/8DnJGDYK/BsFaZ9S1y2Legt9IJ3VXQ6ZAvUKldTZxxpB4psKY8+cD+NhzKAZs9/2AdN3Ewi1FezXgxVJf3gTNMay0KMIeYgG2/QxT1RsNpXSLGAyZgmArOx+SE0JuEo4dzUeaz2z82RrHpQZCV+W96ZPG7cP+65+hm4gUUJaJMNMLXY
 aSnYl7Ui
 OzqR8Vo7H0wSmtkTKP4ssUwWJZbsCLCrDKGF+uy2RcCEgPW6dlexVIuC8tEqI8tXH0qeINehsSVb7fK9kQV2LUAzDk6uP999VAMNu9Xeu9cAdumodnLzMHmOvATodky1I0k80SSAxTH99cYM8cnzHIvOpNV9w4NpxKcKHo40Rad9N8Fui0tnOMEa9pgP/VYv3Hwlgv3C+niYdu4pebsbvE/hd4AH92XC3ZCUuSVz+tte+58/MW66nXI0SsVC4iSKT9BTYohTeWGPUkJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 20, 2026 at 4:34=E2=80=AFPM Thomas Gleixner <tglx@kernel.org> w=
rote:

Thomas, thanks for taking the time, as always, for such a thoughtful respon=
se.

> On Sat, Jun 20 2026 at 12:33, Zach O'Keefe wrote:
> > On Fri, Jun 19, 2026 at 2:59=E2=80=AFPM Thomas Gleixner <tglx@kernel.or=
g> wrote:
> >> The #PF path is considered perfomance critical. But how much the
> >> downgrade matters needs actual numbers to analyze under various worklo=
ad
> >> scenarios.
> >
> > Ya, that's my concern as well, as I don't have a good intuition for
> > how perf critical kernel #PF is for real workloads. If this is your
> > primary concern, I'll take that as a _good_ thing ; i.e. there's
> > nothing architecturally stopping us from doing this downgrade safely.
> > We'll still need the analysis, but that can be a later stage -- we're
> > more than happy to get this data for all.
>
> No. That's not a later stage optional requirement.
>
> You have a PoC which works for you otherwise you wouldn't have posted
> it. So you can trivially microbenchmark the costs of the
> up/downgrade. And that's critical information for us but also for
> you. If the costs are significant then you really have to think about
> the tradeoffs.
>
> Care to read Documentation/process/* carefully? It applies to you as it
> applies to anyone else.
>
> >> I've not seen numbers to that effect anywhere. The only numbers provid=
ed
> >> are marketing material about the memory savings on a freshly booted id=
le
> >> machine. There are _zero_ numbers about the actual real world savings,
> >> but claims about the PETABYTE savings possible.
> >>
> >> Seriously?
> >
> > This is actually the most understood aspect. With O(100B) active tasks
> > fleetwide at any point, it only takes an average savings of O(10KiB)
> > per task to get to 1PiB. At least for our fleet, we know the % of
> > tasks that use only 4KiB, 8KiB, or require the full 16KiB, and the
> > math confirms that we expect O(PiB) aggregate savings. The % of stacks
> > requiring the full 16KiB is minuscule, but it still occurs at a rate
> > higher than what we can tolerate for SO panics. Given the vast
> > majority of stacks never exceed the first 4KiB, this enables the
> > significant opportunity.
>
> I know that the potential savings are well understood and my
> understanding of math is sufficient to calculate how much tasks and
> average saving it takes to save 1PiB on a fleet.
>
> That's a no-brainer, but this is an aggregate saving, which sounds WOW
> but does not tell much about anything else.
>
>  1) What's the actual percentage of savings in relation to the overall
>     memory?
>
>  2) Does the saving allow you to get more stuff done on a machine, pack
>     more threads on it?
>
>  3) Can you actually downsize the memory on the machines?
>
>  4) What is the performance tradeoff for that?
>
> IOW, you fail to tell what the actual benefit of such an intrusive
> change is. Just boasting an aggregate Petabyte number does not tell
> anything at all.
>
> Let me give you a trivial example with a scenario which I have access
> to:
>
>     256  CPUs
>     256  GiB Memory
>     64k  Threads
>
> Let's assume the full saving of 12k per thread. That sums up to
>
>       64k * 12k =3D 768MB of memory
>
> which is 0.29% of the total 256 GiB of memory. Not so impressive as the
> petabyte aggregate number, right?
>
> The workload consumes about 80% of the overall memory and is already
> constraint on close to 100% CPU utilization.
>
> Now let's assume that the runtime overhead of this amounts to 1% then
> this is a net loss.
>
> Let me turn that around and use a made up example assuming the 1Mio
> threads per compute unit taken from some reply in this thread.
>
> Now the full saving of 12k per thread amounts to:
>
>     1M * 12k =3D 12G
>
> which is 4.7% of the overall available memory. Agreed that's a
> substantial number.
>
> That 12G saving does not do anything in terms of hardware downsizing.
>
> The only way that has a benefit is when the system is constraint by
> overall memory consumption, but has quite some compute capacity left.
>
> IOW, if 1M threads hit the memory limit that means that the savings in
> kernel stack consumed memory allows you to add about 4% (~40k) more
> threads. If that ups the CPU utilization accordingly then yes, I can see
> the benefit. But TBH, if that's the case then you are trying to fix a
> user space implementation problem in the kernel.
>
> That said you really have to describe the scenarios where there is a
> benefit and I do not buy this "fleet level" argument at all because
> there is no single fleet which has a uniform workload distribution.

These are good thoughts, thank you. Perhaps I've been too biased by
our particular environment=E2=80=94apologies for that.

We (mostly) punt this problem to cluster-level scheduling, which
ironically exploits this non-uniformity of workload dynamics to
appropriately bin-pack machines and materialize these small savings.

In the general case, I guess a lot hinges on that overhead cost -- in
the best (memory-constrained) case.

> Aside of that. If your argument holds that there are only a few
> scenarios which require a deep stack, then we are better off to identify
> them and fix them up rather than trying to hack around the occacional
> insanity of deep stack usage by adding complexity for complexity sake.
>
> As you say that you have numbers of your fleet which confirm that the
> vast majority of the stack depth is below 4k, you can surely figure out
> the information which call chains are actually exceeding the limit.
>
> I prefer to fix such shitty code and downgrade the stacksize in general
> instead of papering over the underlying issues which probably have been
> ignored for years if not decades.
>
> Have you ever thought about that instead of adding complexity with a
> dubious value?

Yeah, and that is certainly an alternative path we can explore. I was
_hoping_ to be able to maximize the savings here, via the >90% case
where 4KiB is sufficient. If we instead play whack-a-mole with the
handful of cases requiring > 8KiB, the best case is we can move back
to 8KiB stacks. Ironically, I was thinking going this route would be
_more_ of a maintenance burden vs having a generalized solution ;)

To Yourself, Dave, Peter --

I do appreciate all your thoughts and assistance. I'll likely take a
few days to collect some my thoughts, and take a harder look at some
alternative paths.

Thanks again, and have a great day,
Zach

> Thanks,
>
>         tglx
>
>

