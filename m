Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEF5CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 19:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F34C08E002F; Sat, 16 Aug 2025 15:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0C5D8E000A; Sat, 16 Aug 2025 15:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22448E002F; Sat, 16 Aug 2025 15:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA8098E000A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 15:16:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42CC5B9B73
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 19:16:00 +0000 (UTC)
X-FDA: 83783575680.24.1D2264D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 385AE8000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 19:15:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6q0MgJG;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755371758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaI8lHGRqGM/7P16VRO8mfL6ep/Y8COP/WOz/COW2pY=;
	b=xNhoaFK+eb6Jld0o14EbOfT6iih0zj7HWYgwTY0V91E2XJ2bV+hNCH23PU4zW13K9T59xZ
	bgqBgarVi6oMueZiJka5tOi4eZdhBufWbvrkOnl0kqEWCHWel0wayxQREDLwUqJhJ24pEn
	8BchUDYh0PDsizmDvtadVRBigdoxToY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755371758; a=rsa-sha256;
	cv=none;
	b=OOF5ctJnOpZ8SlW2V9DaMKXB4I6nxG7Lo1lV0xD54exiNL6btiM7UmuuPSUyZYeT1dUv79
	i+7M1Ik0ucBU+Nu+YE25qzLHNkt5NtKMX2ozCP2XfDB9OvKw6e81u0OETLLW7Z6dOwMaPX
	mDMHiEUZYBE1n1dYomKBmuIcCCdrkTw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a6q0MgJG;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAD6445C70
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 19:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E56C4CEFC
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 19:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755371756;
	bh=I0tMp8ZMxQUOM+ZGmkaosXXler31EIT1wqssk9LwdIY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=a6q0MgJG4Bt4m54MHh4DNJEzNf744gtuNpB2tf6BHqj0AB8JMfD6FnztnTbLi9DZI
	 q6OyLLbYAnM/EsJZDDjtnrnty5ZaXCNQiNuGp5ejJh8epJdLSaZODR9Dv0I8gl6v93
	 O7+WGWdVO0F1a+fSEl0AXEdIbzw/5MSRCd53WLSI020LKOjXf/vLEj3thPnPHxxmLX
	 odF3onWLCloL+/gR4CWCZdbOt2hrmuMjeF+ZkvChHH+b/p4LwljpYzr/G/CEJ9D0OL
	 1UnBkAuj9Bufp1AKb28XCE0h584TFPMuHhT3QJl9GjACL2GkJTy2z3bHh97KZ0lxsj
	 esP5YrIlGeG4Q==
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so58775e9.0
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 12:15:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXJa6qyMJVzbeTMia8NA1BbjI6rMnZYtdH0qmhv0HvcieoXQPRNnB8deZhjBKlQh1V+4P6n/mS55g==@kvack.org
X-Gm-Message-State: AOJu0YzGJjL9iOCqyCLVZz+g99jjq2UIk0TlNSGHNmsPanhjQ4frq29J
	pb2NI6lLC52z9BeHmr5AeupkvDqo7c0HVifv4dovE36ZtJqoASvzgpzB8bHSf59fEfp5ZLW2fM2
	9U/Mu0a2Xre0UrI3Z0vXi/g0WkvjzcrKig80LUtIV
X-Google-Smtp-Source: AGHT+IGnoTrnnqoE8ad9OuT4PTDa3XFRStZziu5MdWDOriajB3cTQptUGs9bDKsSy3mFCj2WIyMZAKeiWHIhkayjxhA=
X-Received: by 2002:a05:600c:c081:b0:453:79c3:91d6 with SMTP id
 5b1f17b1804b1-45a26efb748mr1041445e9.1.1755371754704; Sat, 16 Aug 2025
 12:15:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250716202006.3640584-1-youngjun.park@lge.com>
 <20250716202006.3640584-2-youngjun.park@lge.com> <jrkh2jy2pkoxgsxgsstpmijyhbzzyige6ubltvmvwl6fwkp3s7@kzc24pj2tcko>
 <aH+apAbBCmkMGPlO@yjaykim-PowerEdge-T330> <aH/baxIgrBI3Z1Hl@yjaykim-PowerEdge-T330>
 <uyxkdmnmvjipxuf7gagu2okw7afvzlclomfmc6wb6tygc3mhv6@736m7xs6gn5q>
 <CAF8kJuMo3yNKOZL9n5UkHx_O5cTZts287HOnQOu=KqQcnbrMdg@mail.gmail.com> <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330>
In-Reply-To: <aKC+EU3I/qm6TcjG@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 16 Aug 2025 12:15:43 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
X-Gm-Features: Ac12FXyWwdls-FsaRf6mfH0ti9KL3EVSh5eHK7Plqi7oep3Q2Is0FQrFr3qdzUg
Message-ID: <CAF8kJuNuNuxxTbtkCb3Opsjfy-or7E+0AwPDi7L-EgqoraQ3Qg@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
To: YoungJun Park <youngjun.park@lge.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, gunho.lee@lge.com, 
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@redhat.com>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 385AE8000B
X-Stat-Signature: wub9yc85n3x386qbe14hq9hznymgeni5
X-HE-Tag: 1755371758-957367
X-HE-Meta: U2FsdGVkX18X7YPtTAdGwi1HjuxYcoITKFGVa6D3qmTQt7HCRsRascGjDfP4+YZ0T0VOqol4ZK8Lzdy7pJogYhvH/zdwhd6TbPBYIccbJQoVpuFpF/WydVNc7pL99Gckb2LkjF9d7esQeFSD73e6QXS4gKBj0JfOo1AS2qG1yUsjsRy5+arjeP+dFOoZteg7ueBgLBtwD+0VHX2px4Kdi/9mj2nB92/1QV7fKW+JF7OD1s1Fjfm6URm0QCzanRHmoCYbLmx6BFwY6N/hgoFCoV4MbDNTRubunG1NO4sHHtrhlcHZNhGqQxsnR7mntSi93faPc7DzDZpXXufFaHNWVTmXu+v0EW8Taoz6y3GFFryfGclPhWvxTsNcV++U5yxLw7pjNbWnsFW2bNm1gxWceQSp7EGCVi9Nj+jFxPrz1j/tCg5ywSLrzuAma40kZlYu0UEILB1lwUEUl98kQnw9TRq81SHduZK7aSnxnbMTWfmPLUoPBwiESMwPgoL2OpeVd1SrdGAFRphlWavg5IlKP7wVYEP3QK2KKxh2SLmKSOdQehDpDgL8aCmq8KVhzt35mufhe5OLdpeXVe6CfulrmSJ4wyeT4heiQsfQT6cTJlToeoWUkLaDDX9C5Gcz9lgF1shfUA4GtnKMRu+P6B2FUoko4eCqdAyYjLLq7ltkVq+YJ1mN/s1b59mCoiajI1c+THOACKiDN4q3/lhhX+ppuOiqhzqhVmNduI6KhFqm0vN8CgOwE11NzCNPUCNAjoUul5Udaf/SYJsdagVkrd+cQCGBc9BDfOO/WTR5rBiUFgQWOhvjrsJAQLrRGMUPsqlEPuJcUqXrbeq15wMOtECIdRIEjx0FgnEzVzw4ZdBj7JHibPPH4oyQnsnTQXiudilJs5PTFAEtIz6XgUL/z6aGLmUprL+uHTittMxx0QPXdY7ABnw7XfkcJBaLnyadsmoWLqrQfdGJ7ELsLwhWoJl
 a2mUcUP8
 oamCO2s6qBvu7uH3EX8swGT3ioubtaDmSLFH3wQcDA4nbI8FHppBgBi8vYMviy47zksSLE6rszCQRXvPc/al32wAl1a627VRdjFFAL/erX4IvUg+63xOa/om5zD1tNM2nN/41RfUWU/qau/OvyjRz1jZGWxd88q9KxOYq/DiZ/i8fET2OoaIckqoF1tEpz5EpnuJbihRCQkgD8E0VZea9HD3m8ST8HoPkKZy8l8j5BBAFWYIm82QtWckgkXoEKEUeJ6Vl2yo+lcV1G7fi8KgE2Y47sDMEAJlwGv2Td4FPctaQbX+1N/tyNVofIsojBGh0FkjlrpNAfb9ot6fbXKyS7rN50cKlrbTfakI7cb9SdCPwisg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 10:21=E2=80=AFAM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>
> On Fri, Aug 15, 2025 at 08:10:09AM -0700, Chris Li wrote:
> > Hi Michal and YoungJun,
>
> First of all, thank you for sharing your thoughts. I really appreciate th=
e
> detailed feedback. I have many points I would like to think through and
> discuss as well. For now, let me give some quick feedback, and I will fol=
low
> up with more detailed responses after I have had more time to reflect.

Please do, that is part of the community feedback and review process.

> > I am sorry for the late reply. I have briefly read through the patches
> > series the overall impression:
> > 1)  Priority is not the best way to select which swap file to use per c=
group.
> > The priority is assigned to one device, it is a per swap file local
> > change. The effect you want to see is actually a global one, how this
> > swap device compares to other devices. You actually want  a list at
> > the end result. Adjusting per swap file priority is backwards. A lot
> > of unnecessary usage complexity and code complexity come from that.
> > 2)  This series is too complicated for what it does.
>
> You mentioned that the series is overly complex and does more than what i=
s
> really needed. I understand your concern. I have spent quite a lot of tim=
e
> thinking about this topic, and the reason I chose the priority approach i=
s
> that it gives more flexibility and extensibility by reusing an existing
> concept.

I have not questioned the approach you can achieve with your goal. The
real question is, is this the best approach to consider to merge into
the main line Linux kernel. Merging into the main line kernel has a
very high bar. How is it compared to other alternative approaches in
terms of technical merit and complexity trade offs.

> Where you see unnecessary functionality, I tend to view it as providing m=
ore
> degrees of freedom and flexibility. In my view, the swap tier concept can=
 be
> expressed as a subset of the per-cgroup priority model.

Why would I trade a cleaner less complex approach for a more complex
approach with technical deficiency not able to address (inverting swap
entry LRU ordering)?

> > I have a similar idea, "swap.tiers," first mentioned earlier here:
> > https://lore.kernel.org/linux-mm/CAF8kJuNFtejEtjQHg5UBGduvFNn3AaGn4ffyo=
OrEnXfHpx6Ubg@mail.gmail.com/
> >
> > I will outline the line in more detail in the last part of my reply.
> >
> > BTW, YoungJun and Michal, do you have the per cgroup swap file control
> > proposal for this year's LPC? If you want to, I am happy to work with
> > you on the swap tiers topic as a secondary. I probably don't have the
> > time to do it as a primary.
>
> I have not submitted an LPC proposal. If it turns out to be necessary,
> I agree it could be a good idea, and I truly appreciate your offer to
> work together on it.

Let me clarify. LPC is not required to get your series merged. Giving
a talk in LPC usually is an honor. It does not guarantee your series
gets merged either. It certainly helps your idea get more exposure and
discussion. You might be able to meet some maintainers in person. For
me, it is nice to meet the person to whom I have been communicating by
email. I was making the suggestion because it can be a good topic for
LPC, and just in case you might enjoy LPC. It is totally for your
benefit. Up to your decision, please don't make it a burden. It is
not.

If after your consideration, you do want to submit a proposal in LPC,
you need to hurry though. The deadline is closing soon.

> From my understanding, though, the community has
> so far received this patchset positively, so I hope the discussion can
> continue within this context and eventually be accepted there.

Let me make it very clear.  As it is, it will not get my support for
the reason I have laid out in my last email.

> > OK. I want to abandon the weight-adjustment approach. Here I outline
> > the swap tiers idea as follows. I can probably start a new thread for
> > that later.
> >
> > 1) No per cgroup swap priority adjustment. The swap file priority is
> > global to the system.
> > Per cgroup swap file ordering adjustment is bad from the LRU point of
> > view. We should make the swap file ordering matching to the swap
> > device service performance. Fast swap tier zram, zswap store hotter
> > data, slower tier hard drive store colder data.  SSD in between. It is
> > important to maintain the fast slow tier match to the hot cold LRU
> > ordering.
>
> Regarding your first point about swap tiers: I would like to study this p=
art
> a bit more carefully.

Please do.

> If you could share some additional explanation, that
> would be very helpful for me.

Feel free to ask, I will do my best to answer.

> > More example:
> >  "- +ssd +hdd -ssd" will simplify to: "- +hdd", which means hdd only.
> >  "+ -hdd": No hdd for you! Use everything else.
> >
> > Let me know what you think about the above "swap.tiers"(name TBD) propo=
sal.
>
> Thank you very much for the detailed description of the "swap.tiers" idea=
.
> As I understand it, the main idea is to separate swap devices by speed,
> assign a suitable priority range for each, and then make it easy for user=
s to
> include or exclude tiers. I believe I have understood the concept clearly=
.
>
> I agree that operating with tiers is important. At the same time, as I
> mentioned earlier, I believe that managing priorities in a way that refle=
cts
> tiers can also achieve the intended effect.

The per cgroup per swap file priorities has one Achilles heel you need
to address before you can make any further progress upstreaming it.
Putting the extra complexity aside, the per cgroup per swap file
priorities can invert swap entry LRU order between different views of
ordering by different cgroup.
That violates the swap entry LRU order between tiers.

From the swap file point of view, when it needs to flush some data to
the lower tiers, it is very hard if possible for swap file to maintain
per cgroup LRU order within a swap file.
It is much easier if all the swap entries in a swap file are in the
same LRU order tier.

Inverting swap entry LRU order is a deal breaker for your per cgroup
per swap file priority approach.

> I have also been thinking about a possible compromise. If the interface i=
s

The swap.tiers idea is not a compromise, it is a straight win. Can you
describe what per cgroup per swap file can do while swap.tiers can
not?

> intended to make tiers visible to users in the way you describe, then map=
ping
> priority ranges to tiers (as you propose) makes sense. Users would still =
have
> the flexibility to define ordering, while internally we could maintain th=
e

Because I don't want to violate the swap entry LRU ordering between
tiers. Within that context, what usage case do you have in mind?
Within the same tier, the swap device can have finer grain priority
order between them. The part I haven't understood, please help me
understand, why do you need per cgroup per swap file orthering  rather
than the tier order? It is much easier from the admin's point of view.
This app needs to be fast, can't afford slow swap, give it faster swap
tiers.

> priority list model I suggested. I wonder what you think about such a hyb=
rid
> approach.

It obviously will introduce new complexity. I want to understand the
reason to justify the additional complexity before I consider such an
approach.

> Thank you as always for your valuable insights.

My pleasure. Thanks for leading this per cgroup swap file effort.

Chris

