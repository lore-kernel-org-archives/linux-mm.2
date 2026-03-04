Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00466EF8FFA
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F8526B008C; Wed,  4 Mar 2026 10:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6D36B00AC; Wed,  4 Mar 2026 10:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0888D6B00AF; Wed,  4 Mar 2026 10:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E9AF96B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:47:05 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9BD28BA316
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:47:05 +0000 (UTC)
X-FDA: 84508809210.21.5959122
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3BD0180007
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:47:03 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JfJRwkdN;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772639223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJKMjhDBj+BCkcJ+P1/XFe8Ou/6TfAt4K4DIosZo7dA=;
	b=eOJepdMsKZ4EPpzRsr5HjSVB/UyPElxKFpKAuMTtR1NqR7jZDQj5qOhW6JbKeepXpuJBWq
	kP9uxoJtNN6ia7oTpu3Y1zirU6KD1QatyPWz9ieoukzhZFhQLCG2dOq/DvS1ZXIfqVb1hB
	EiA8YnyMYckDPSD8k9ddYs1XD9QsAxU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772639223; a=rsa-sha256;
	cv=none;
	b=FoxG2G4AuFYcYWK8jqJobuxXOHx4aTpWd6088JQhOsT3cr3WG8Y6d6HNPb4/KMEpPUxv58
	TPjNtwAbfIqoTtiWqpdtUx8qdixoduEN9k3ENESNwvLLMORsmsw3hzrxzNIPcpKneUerBB
	OB+jB7SNkr4jWqEgkI3JlT2ltWeJbG8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JfJRwkdN;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 100766011F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74FEC19423
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772639222;
	bh=wQB8bgrb1VKKNUOrGalau2vuiEG8//rIFR/dkf6y4lg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=JfJRwkdN7Yyws2qaxhR83xOmMfY62C4yRpDsHo5ATw+aJUlLtgEsD8hh5AcnQX29m
	 9hAWoJ96WGutkccfvNDGa5C89SZYkS/TZkczp7N2t9yFnFjnE3gznTm8dcpEo790hy
	 t5KU8QXyP9Pff4Qy7xQKiwnt6tfgXL/GSb3BPaqj9kLnB8yCknBhQvog2JTObrVhyU
	 QASiZikH0OljPget0q1NCyQbbx6lquHQHFLgtdPL6ssZk2Ci1PDFOf+EBiQf3bRcgs
	 EJk77cetBhpWjg1mNsDuZMFgznviPRmOPDdogYyRgBEnEqEaSnuimeBJeV8VlAz69H
	 k9sKNc5DtDm+Q==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-660bdba9390so2503624a12.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 07:47:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUn5eN7PMWDfke7edADUYH7NCwqRSWxgs2Yyl63RWdMIDOV8KnHBWFaHUqeI2GKFtnafEP70bQUbw==@kvack.org
X-Gm-Message-State: AOJu0Yx11uL3VlkKsyX6q1B/pRkGi6YCVVOnSgC4kCEJVc398CnD2fSH
	wc6StxvQD4FP47Wk4Po2EgEynXx7sMiCmkioy7GIXz2DSbLu2Wifgl2YG1sCh3+l8WrIfjvxSSV
	oLJ/bPWIAL/jfid2Z/w8cICcya6gV+ac=
X-Received: by 2002:a17:906:c107:b0:b8e:3957:f0d5 with SMTP id
 a640c23a62f3a-b93f11c0672mr144872766b.25.1772639221431; Wed, 04 Mar 2026
 07:47:01 -0800 (PST)
MIME-Version: 1.0
References: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
 <20260304151120.3512645-1-joshua.hahnjy@gmail.com>
In-Reply-To: <20260304151120.3512645-1-joshua.hahnjy@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 07:46:48 -0800
X-Gmail-Original-Message-ID: <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
X-Gm-Features: AaiRm53P3i4SVo8LADo-vaxVmK5DA7F_E32YhxfCaFssztR0PiWkABtHUAkCC0I
Message-ID: <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wggrq7gdopy8sx3ur493mrwcuoeeqt1a
X-Rspam-User: 
X-Rspamd-Queue-Id: A3BD0180007
X-Rspamd-Server: rspam12
X-HE-Tag: 1772639223-454024
X-HE-Meta: U2FsdGVkX1+7EUwHYzQpubM9WJagJASNDqUbTDs2Ays0Vf4z4wZ6qtnnOize93lp3Jbbyj0pBXB2LiQn6nkcWBqgIy11r8QgK3u2ys67oKoARGwDyQ6ul0Cab70tZmm/FpBscwCaImxDewaDM4qpyyn4Z88exIENMW6Ws5/w586qRDxSZ5xf2w6Hz/h2jKw6h8B+bmYZilR55RJk8kmt4yOmjDTv7c26z/S/18T2D/sgolWXf0fDzX/a6MfroteXeIkvay7jv5giKPV+SCguDPjuZ2nRipqOacO5XHyE7rfNQsFdq0HjdmTeCD1ly8vc3OyfCYpxZZg95StFpfvOtsKify/FJ2LIi0eMuZlKtqamGcH78+1ldUCbRPYdOvqAM7k2yBDpl/aS7LuZfeGBg5raSwPw87bkP+s3R6yTcimqoNLgjnE01r3gWC5s+4vHLyO5S5qHtGkAA1EqbPcs0a2hD7fN32NmhaTzaTi03qh+R4vQ8H55Rk6KiqFyBe/WdSWypuLgnoAqNak21P0XVY6U8AHGnfYGBzixfVkUTokKz7/T3DHQ5l+0HWzbPLc1koO9zu5PsAzCkQDNyNQzINb2hJJCOnsWSbr3EUn1yE2Mtce45d8iMqgwzW+ZldF+KSpOZHJHxwwCseT+IsPmap8Tb5u5uHYlf0OrJynU6PP0mQuEOujsbap0Lv+5H5lxX7kSIWGrM40adIXhFQU2a0p4K4cFlgTqkD/CH6UeA3Q6QtzO/HDXx5sBmyKRKh533nCN8LyXOMFwdghh6DLitGbzww4Kv+6zQCRwF+eLYa65kzchWp7PPZXOa+VfssmMbGfN4Q/ubqQTGmf2xUS1OaII9HrPtaQ3d/XFTaBsrbNsq5VJFdnmyrhcgrX+TSwaPRXx7Y8bVA9PfH20U3egOmUuxzzhuJ0fvKm4S8f1c+NlNOJZCMNJQNPT/THpWjqXTObHNpWYGu4o20msTSW
 NWIVJUwZ
 oKyAGwF1VVgJUjHFp7ObrLxXKe6aHOeFP3j/rAGN1r0kpH/jH5vQxNzgUB4gTn4nsqhTikScVvK/erLWp5lgEiFY8065kJzMmz63Cl1/qj31z8ynIJFJsjQ21pR27zERklbQlVCfUvsxSjbsYm1Z/QxVMvUt3mZiIobOpfNDPIVTPxS9W3JDjbHPHgLJa2O/0JfZFE1qOAva+YegBFEpTXO4Kk/JjVznfhKa1Z+HT5/9o9k5bc7/AO5mfq2ybZ9jO9ZZIKf/g2UBDBzyAZcPkxTFdTEIkT6tDmcugtZ97IUqGNMlYrqfnWfdzeIF1c17pUiCoDkMd1dDYZt8QXtmeSM4ZfB1XwTUfcUr+qfU61TvOukPgH34kiYa5TWd/faLSARmoRJ2+zzWi9iCje/MAsmZOUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 4, 2026 at 7:11=E2=80=AFAM Joshua Hahn <joshua.hahnjy@gmail.com=
> wrote:
>
> On Tue, 3 Mar 2026 15:53:31 -0800 Yosry Ahmed <yosry@kernel.org> wrote:
>
> > > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > > index 067215a6ddcc..88c7cd399261 100644
> > > --- a/mm/zsmalloc.c
> > > +++ b/mm/zsmalloc.c
> > > @@ -963,6 +963,44 @@ static bool alloc_zspage_objcgs(struct size_clas=
s *class, gfp_t gfp,
> > >         return true;
> > >  }
> > >
> > > +static void zs_charge_objcg(struct zpdesc *zpdesc, struct obj_cgroup=
 *objcg,
> > > +                           int size, unsigned long offset)
> > > +{
> > > +       struct mem_cgroup *memcg;
> > > +
> > > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > > +               return;
> > > +
> > > +       VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > > +
> > > +       /* PF_MEMALLOC context, charging must succeed */
> > > +       if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > > +               VM_WARN_ON_ONCE(1);
> > > +
> > > +       rcu_read_lock();
> > > +       memcg =3D obj_cgroup_memcg(objcg);
> > > +       mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > > +       mod_memcg_state(memcg, MEMCG_ZSWAPPED, 1);
>
> Hello Yosry, I hope you are doing well!
> Thank you for your feedback : -)
>
> > Zsmalloc should not be updating zswap stats (e.g. in case zram starts
> > supporting memcg charging).  How about moving the stat updates to
> > zswap?
>
> Yeah... I think this was also a big point of concern for me. While readin=
g
> the code, I was really amazed by how clean the logical divide between
> zsmalloc and zswap / zram were, and I wanted to preserve it as much as
> possible.
>
> There are a few problems, though. Probably the biggest is that migration
> of zpdescs and compressed objects within them are invisible to zswap.
> Of course, this is by design, but this leads to two problems.
>
> zswap's ignorance of compressed objects' movements across physical nodes
> makes it impossible to accurately charge and uncharge from the correct
> memcg-lruvec.
>
> Conversely, zsmalloc's ignorance of memcg association makes it impossible
> to correctly restrict cpusets.mems during migration.
>
> So the clean logical divide makes a lot of sense for separating the
> high-level cgroup association, compression, etc. from the physical
> location of the memory and migration / zpdesc compaction, but it would
> appear that this comes at a cost of oversimplifying the logic and missing
> out on accurate memory charging and a unified source of truth for the
> counters.
>
> The last thing I wanted to note was that I agree that zsmalloc doing
> explicit zswap stat updates feels a bit awkward. The reason I chose to do
> this right now is because when enlightening zsmalloc about the compressed
> objs' objcgs, zswap is the only one that does this memory accounting.
> So having an objcg is a bit of a proxy to understand that the consumer
> is zswap (as opposed to zram). Of course, if zram starts to do memcg
> accounting as well, we'll have to start doing some other checks to
> see if the compresed object should be accounted as zram or zswap.
>
> OK. That's all the defense I have for my design : -) Now for thinking
> about other designs:
>
> I also explored whether it makes sense to make zsmalloc call a hook into
> zswap code during and after migrations. The problem is that there isn't
> a good way to do the compressed object --> zswap entry lookup, and this
> still doesn't solve the issue of zsmalloc migrating compressed objects
> without checking whether that object can live on another node.
>
> Maybe one possible approach is to turn the array of objcgs into an array
> of backpointers from compressed objects to their corresponding zswap_entr=
ies?
> One concern is that this does add 8 bytes of additional overhead per
> zswap entry, and I'm not sure that this is acceptable. I'll keep thinking
> on whether there's a creative way to save some memory here, though...
>
> Of course the other concern is what this will look like for zram users.
> I guess it can be done similarly to what is done here, and only allocate
> the array of pointers when called in from zswap.
>
> Anyways, thank you for bringing this up. What do you think about the
> options we have here? I hope that I've motivated why we want
> per-memcg-lruvec accounting as well. Please let me know if there is anyth=
ing
> I can provide additional context for : -)

Thanks for the detailed elaboration.

AFAICT the only zswap-specific part is the actual stat indexes, what
if these are parameterized at the zsmalloc pool level? AFAICT zswap
and zram will never share a pool.

