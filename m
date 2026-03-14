Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9FE10706EC
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 17:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43FB6B0088; Sat, 14 Mar 2026 13:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F1936B0089; Sat, 14 Mar 2026 13:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9736B008A; Sat, 14 Mar 2026 13:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79D856B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 13:33:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79328160728
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 17:33:11 +0000 (UTC)
X-FDA: 84545364582.23.50DADC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64130C0005
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 17:33:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AA3aXEQ7;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773509589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41VXZgQgbnvbCmS/rhRYp0EZXq1HPqKfWGpIvEEJD5w=;
	b=tMY3SFOzwGvaJd7OpT5czpPoflg4wFecYOyaEc4Pdp8Z1nOF6XbW5M0JlAmBnhY0Tcw0rL
	sgnJTDx28QANT7Aww9JJZBOm4m/fr5Ll5EBoJZJFIPq/3EnAFLmTXnTh+uxZJ5UQVtFnk7
	WrzWhW/LVXzwHuoYCIkzUH7+NnhWTyE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773509589; a=rsa-sha256;
	cv=none;
	b=dPOCAnFuapnY3C3RPGLYD6gwX3cotRAkUl6IsX7X5mJjk7wcoF8ibnhnAwe23pA2YAkBWO
	MsKl7yixlxB2B3V7HKdQ0opos1j+sGmZ0Asbw45i+LBEXVKO/xBJVuR0KcjSXcz4LNw98j
	czQo+wJkgtedQ9Aup6455KMME32wHM8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AA3aXEQ7;
	spf=pass (imf28.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2272E419B8
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 17:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FC6C116C6
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 17:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773509588;
	bh=uB87d/zvXRWzxxn935aAooFDrYiENw87XMfyWWtKnHA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=AA3aXEQ7aTwkZsuETPLqR7MaYA7LYOKUUqfE/VVYVY03rN0RjBpYrc34BWpA9adfp
	 eJkVXeLJQfi66cFnMRvmC72cFV0wsnbz2Gi9Sc5WY742GELaKmfm5VnwGH3eDlkACN
	 LnvdNllr9VWPnTuh7e1ZyDq+L+fyKmv5J50wBUp2jprMhUIjQpcgWhUu9YNhEdlG12
	 oAvAWM6mZJ7IrDD/ZVVk4jP1EtNTOB891/b99GCWPZxzVGXN8Eh6yzYDd5xM3ak0E0
	 QEsCp98Hf51u3kl108WPniSnHC1P3Cd8f4B472Styg0n0oNgVXm1Mva3WP3T0sE0yU
	 ZujK7YYoHeflQ==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-64ad79dfb6eso3854209d50.0
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 10:33:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUlz4grdd4Kw2CPLQO6vyHJYJWHjozxA83MLkN6jElM6C18rjGrTAOaIuqSDhCHhhwSZ7f//o5saA==@kvack.org
X-Gm-Message-State: AOJu0YxxuV5AUxGU29ml8UEjPWJWyw0LpNUSGa5cy747T2J23GIRbRlA
	E6zo4sYvt+3XfcBsaAcMTZwCl7mtzaN2cYBw6LATX7JZ0Yh4Emc8C/tZ9ZipwfWEniDDMQTxn6w
	GF5ITfcIV2eR2GQD6bpOpkh1WjsCQka2n5y/ZUMj4GQ==
X-Received: by 2002:a53:b465:0:b0:64d:6815:25dc with SMTP id
 956f58d0204a3-64e62f25dc8mr5820841d50.15.1773509587281; Sat, 14 Mar 2026
 10:33:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260126065242.1221862-1-youngjun.park@lge.com>
 <aY4bQFvpPRWgnOTM@linux.dev> <aY6hcPNxiolf5jj6@yjaykim-PowerEdge-T330>
 <aZjxP2sTavBRGC1l@linux.dev> <CACePvbU=4f4gT5kHUBq0wD7COHN+quE5g4bPQqJYgJNx_9vuhg@mail.gmail.com>
 <aZpY1FIjYLtLdu5F@yjaykim-PowerEdge-T330> <aaXM58EsMtbGri2B@linux.dev> <aa9+eK/VEealbo8i@yjaykim-PowerEdge-T330>
In-Reply-To: <aa9+eK/VEealbo8i@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 14 Mar 2026 10:32:56 -0700
X-Gmail-Original-Message-ID: <CACePvbXhk2GFTay3OrPoqFU=hRt9N5fgx=FrWFQ6nj4Nyn7b8A@mail.gmail.com>
X-Gm-Features: AaiRm51C5PPhCS5Epam3Drg6lRs23f35CaUZ_or6399Ux8MpfKiEOefVApcbWZ4
Message-ID: <CACePvbXhk2GFTay3OrPoqFU=hRt9N5fgx=FrWFQ6nj4Nyn7b8A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/5] mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
To: YoungJun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, gunho.lee@lge.com, taejoon.song@lge.com, 
	austin.kim@lge.com, hyungjun.cho@lge.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ufw3eig7ddgq36gjow8bd5imdtbww3fa
X-Rspam-User: 
X-Rspamd-Queue-Id: 64130C0005
X-Rspamd-Server: rspam12
X-HE-Tag: 1773509589-115633
X-HE-Meta: U2FsdGVkX19ElyiUysEg+KHUbcudz/dLkgFzCLQxMBUq0BP9xhNlUP5ILZzo2ne0hSyUqqxhyMqjwxpjlXNq+WC/wVEibyKVq8l6MGSJVV/qT1fjY9FvRDCvLLt9zz67fCSgNvnuxlwsXVRrrF0r4LWo/ajwdoHg/hD3StO4q6rPG/bVrNXZM6nC+FfueZqXGTkrISR2Zl4IxJiSNndUnUKI4zbL5F1I4Hfx6stNHvbCS+a2uKr8S0LCK6TkSCEZdF8T119W6FNSncRsMhFx6Xe/aYeAb3EfU9V1yDmcZap99Dkgxnk6dISE7wmLBR2cB1SENdB/YzG2Fy1urGtNUsyg990djX7jx7otTLZRVEzr/dQ41LAKwT9s5CUqIoaJPln6fZrf5aIP8KwAhvxtIhl/0il+P2tGeSChHskKjJkIgJRMhszYbP5ydaSChyCPe+ezCe5bQ6Ls26htgMFkZ0328MBudjDilkFYs3bJKjtZRoofQgSJaPvCZbeXWPVoqFAiHLtc7LOoVn6IlkuS0V7sUhZq5jq6UDIwwvvOdnOlavlXGWZsIEJxRudr/hT0WLJ/06QC/Zm4WKaM2HUhLsxHpyDkA/J1naJhOXRM3bQEvUv0Xa7B3Nwam4+lxek/FwP1w5BpAUlyrzWhsGUgWzOw/n9aRIkjDk7pn2/98FVy1Vcyw3nNY2lKaRf/JlftOBn1wmrHq9hIwC6N85z1lpeYC6DiTDNwa6y0axNiJOlrs2B6K/C/6Sd5QNXsBt8iIPpIJJt0+d841A0zh/w2NyqZ09mCnXzi1UuxiaTGbGYkfMceNjTgRsLDjrZFdKv7sp6hkgBtwB+ov6/sS87Wdn45G36uu9pQvmJ19kPvwJB/3x6mvH7vKoW2C24Npnd2k94Ptj6+tnEDB9WqzZiw0UY4uTRoSwHN0uhku30+QozlfhDMrtyqC/BuHWmXsFUOGysMC1FiLfvoNyBEDK6
 GQiS5Qqg
 HOLoJjF5vYPoFAvUUfn7HQjWwI2ed1is9TZfxz1orpp0IRIrVQTefX9IhoR46noYmkKEQL/2h36Q9r79RByRPA4IQp1/bH6KYucMTR/EBp4G9wzPtbPOEaFZFV2eV2qQyhOk8TM+mYw2ptP+1PGS8zNbKmLjCOnYB3xMSAgQavG/msV+IWhPxH0nu7JGsIw4eHY3yAwABSPcJNBhmqm2SEsKGwyqF6OMaSfc4F/a6l8ucyoVL77nddcPg80ewAzWUtUm5s47EU8Fd9Oeh1JZM8ReNgAc9ePrR/H8IHtt0mnJVU1CYkN6LR4HNlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi YoungJun,

On Mon, Mar 9, 2026 at 7:14=E2=80=AFPM YoungJun Park <youngjun.park@lge.com=
> wrote:
>
> On Mon, Mar 02, 2026 at 01:27:31PM -0800, Shakeel Butt wrote:
> >
> > Hi YoungJun,
> >
> > Sorry for the late response.
> >
> > On Sun, Feb 22, 2026 at 10:16:04AM +0900, YoungJun Park wrote:
> > [...]
> >
> > Let me summarize our discussion first:
> >
> > You have a use-case where they have systems running multiple workloads =
and
> > have multiple swap devices. Those swap devices have different performan=
ce
> > capabilities and they want to restrict/assign swap devices to the workl=
oads. For
> > example assigning a low latency SSD swap device to latency sensitive wo=
rkload
> > and slow disk swap to latency tolerant workload. (please correct me if
> > I misunderstood something).
> >
> > The use-case seems reasonable to me but I have concerns related to addi=
ng an
> > interface to memory cgroups. Mainly I am not clear how hierarchical sem=
antics on
> > such interface would look like. In addition, I think it would be too ri=
gid and
> > will be very hard to evolve for future features. To me enabling this
> > functionality through BPF would give much more flexibility and will be =
more
> > future proof.
> >
> > >
> > > After reading the reply and re-think more of it.
> > >
> > > I have a few questions regarding the BPF-first approach you
> > > suggested, if you don't mind. Some of them I am re-asking
> > > because I feel they have not been clearly addressed yet.
> > >
> > > - We are in an embedded environment where enabling additional
> > >   kernel compile options is costly. BPF is disabled by
> > >   default in some of our production configurations. From a
> > >   trade-off perspective, does it make sense to enable BPF
> > >   just for swap device control?
> >
> > To me, it is reasonable to enable BPF for environment running multiple
> > workloads and having multiple swap devices.
> >
> > >
> > > - You suggest starting with BPF and discussing a stable
> > >   interface later. I am genuinely curious, are there actual
> > >   precedents where a BPF prototype graduated into a stable
> > >   kernel interface?
> >
> > After giving some thought, I think once we have BPF working, adding ano=
ther
> > interface for the same feature would not be an option. So, we have deci=
de
> > upfront which route to take.
> >
> > >
> > > - You raised that stable interfaces are hard to remove. Would
> > >   gating it behind a CONFIG option or marking it experimental
> > >   be an acceptable compromise?
> >
> > I think hiding behind CONFIG options do not really protect against the =
usage and
> > the rule of no API breakage usually apply.
> >
> > >
> > > - You already acknowledged the use-case for assigning
> > >   different swap devices to different workloads. Your
> > >   objection is specifically about hierarchical parent-child
> > >   partitioning. If the interface enforced uniform policy
> > >   within a subtree, would that be acceptable?
> >
> > Let's start with that or maybe comeup with concrete examples on how tha=
t would
> > look like.
> >
> > Beside, give a bit more thought on potential future features e.g. demot=
ion and
> > reason about how you would incorporate those features.
> Hello Shakeel, Chris Li,
>
> Just sending a gentle ping on my previous reply. :D

Sorry for the late reply, busy days.

>
> To quickly summarize the main points:
> (I might wrongly undestand your intentaion, then correct me please :) )
>
> * Regarding Shakeel's BPF approach, stable interface movement would be di=
fficult,
>   so we need to choose a direction. I prefer adding it to memcg for immed=
iate
>   usage, and if it proves highly effective, we can consider transitioning
>   entirely to BPF later.

I am very concerned about locking down the kernel user interface just
because things might change in the future. If we need to use BPF to
get the stable user space API, I am fine with that. Completely
blocking the new cgroup interface because of a worry about future
change is not justifiable IMHO. There ought to be some intermediate
staging we can do e.g. debugfs interface to test and play with the new
API. We should focus on designing the interface as well as possible
right now.

> * Shakeel seemed somewhat positive about matching all child tiers from th=
e
>   parent if tiers are applied to a specific cgroup use case, and I would =
like
>   to start the discussion from here. Chris, I would appreciate your thoug=
hts
>   on whether you agree with this direction of unifying all swap tiers wit=
hin
>   the hierarchy as a first step.

Does that mean all children will only use the parent cgroup setting?
Wouldn't that be more restrictive and counteract the goal of making
the API more future-proof?
For the record, the current Google deployment can uses a different
swap device for the child cgroup, in the current delpyment.
The typical setup is that the top-level cgroup is a job running on a
VM. Then there is a second cgroup level for the VMM guest memory
allocation; swap device selection occurs at this second level.
There is also zswap vs SSD, the SSD is something new starting the
deployment. So it's not just about enabling zswap or not. We also need
to select the swap device.
If you get the current cgroup, it will need to walk the parent cgroup
chain to find the toplevel cgroup any way. I just think having the
hierarchy makes more sense.

> Here are some additional thoughts I had after my last reply:
> (Thanks for the insight and discussion. Hyungjun Cho)
>
> * Cgroup distribution:
>   A direct use case where cgroup A distributes a portion to A' is hard to
>   imagine, but the following scenario is possible:
>
>   swap: +SSD +HDD +NET
>   cgroup hierarchy:
>   /
>   A : +HDD +NET
>   A'(app 1) +HDD, A''(app 2) +NET
>
>   Cgroup A has two interdependent apps, and +SSD is excluded for more cri=
tical
>   services. App1 (A') avoids reclaim with a large hot working set using f=
ast
>   +HDD, while App2 (A'') has a cold working set using slow/large +NET.

The app interface is a huge departure from the cgroup. The cgroup is a
well defined interface.

>
> * Promotion / Demotion:
>   Unlike memory tiers, swap tiers are directly assigned by the user, prov=
iding
>   flexibility beyond just speed. Since swap priority is already a user ch=
oice,
>   this design makes perfect sense.

We need to find customers willing to use this promotion/demotion. I
hesitate to build something while hoping to find someone to use it
later.
It would be good to identify someone who can immediately use and test
this promotion/demotion feature.
We should focus the discussion on achieving a more flexible swap
device selection approach and reach a conclusion on the API discussion
before discussing promotion/demotion. If we can't even have a usable
swap tier interface, there is nothing to promote.

>   With this arbitrary assignment, we can support higher-to-slower tier
>   allocation, similar to current memory tiers, if user properly bind the =
tier.
>   (more flexible as I think)
>
>   Within the same tier (meaning we define it as equal speed(tier)), we co=
uld apply round-robin or other
>   distribution policies via an additional tier layer interface. The curre=
nt
>   equal-priority round-robin policy could also be elevated to the tier la=
yer.


Chris

