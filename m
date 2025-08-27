Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCF6CA0FF0
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 00:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14486B017A; Tue, 26 Aug 2025 20:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC46F6B017D; Tue, 26 Aug 2025 20:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3AD6B017E; Tue, 26 Aug 2025 20:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 850E76B017A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:18:07 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0028B58A7C
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:18:06 +0000 (UTC)
X-FDA: 83820624972.18.82D2571
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1FCB340008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:18:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jbWMkxbT;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756253885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gp4LSdxNbv5Dt0BS6dytNsVUntkhEs+H9PnGvk1Ynzc=;
	b=Kue1l56iOZ7xBAbqPXlRf75QbQ0o/lioEFMPNkEWjAsdyRk24uCozIcqFAPLOJDkkGJQ/y
	OET8hqTDhQxlKSyB6+5YgGbBAFSxwMjqAMzNsfGErzfFwvo/Jjikf0zoDo6odm37mWSzw4
	yyp9ch7DoYnv72eDR/q6OHYmul/5NMo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jbWMkxbT;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756253885; a=rsa-sha256;
	cv=none;
	b=mvzdOtJ7ikerdFcB3JbJMSQdTLzKjzIInbFjNBPAlGkJMNwC3UKnORD2gPq4WWv54v6IZk
	+bbLF3Zm/pMcAOepZ6aSGUm6CTRZmwhSxzUcML9e2q1kLdbaakVA2g2IwHTgIDUjSip8Gf
	Ypc5bEwn19jr/t0vuFDFtFVXkkZScxI=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b29b715106so79821cf.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 17:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756253884; x=1756858684; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gp4LSdxNbv5Dt0BS6dytNsVUntkhEs+H9PnGvk1Ynzc=;
        b=jbWMkxbTNc6x63fXAWEZ6XOwxYofR3V/PE3OGs6w6XBG/RzXIqZU9HQ4RebV9yOVFO
         rqOp0j1JgeQ+AKxfv90AIlYpqhZHN8W6mOSGurzwwUxOiZi38A952cQb0a3/0sfMGhP5
         Dlw88zI6sNgu0j9Q/6QmFlms6YWWCr2tWiT/MMDfAo1aL+X7uLAHe/61IveiLsppuDTu
         tMDMaRv53S3ZssAM3vZia/rn3BBqhwe24c8H5nzhddASoBCWj2P6x1H6OxFs98u0IR/g
         ShfBpQpQYIpEXmkX7+uV8OKFJfPZ3bGJ0MeBSHBKBg3CQgVD2JZh4bYdKN//iPdZNIfA
         4qAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756253884; x=1756858684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gp4LSdxNbv5Dt0BS6dytNsVUntkhEs+H9PnGvk1Ynzc=;
        b=vYjK4gNyGjrh7M03FPkYrE4M7T3YLVdRlQxq0oc/bLTO/Lg4tzELEPkTwBc0RivZL0
         AJOIxArtTIZhl40RLJyslqXLBuOhCMLQxiRbXgB1hUfS6tqzJhzZ1akd3XwPdHCj6ks3
         oy/QyFZIkRcKt2tjr8jaGW6uO9DTOXFY/eejJf29SpPGa4nR8j+HuFiPryVgfUpK9reF
         BIj0xky65imEwhsFOMvdeQL1RcZLc98a78MslDnh6J/raWK7yrj768X66lZlTYbtWyTI
         JQp70Iz0Or6YcD+fyO7U2Fm8xJoSIGm/nbyw4uRMPJVROgroeJIpuLBpUtl7fUzMjbdw
         dCNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXROQ7GTmyjMGr+pKd5IuzGbTyvQwHLK8djCYszQOwef25/4dMkwFFY05ktJ8WensDOlx5poTnfFA==@kvack.org
X-Gm-Message-State: AOJu0Yx2RCZcsTOUqBG8UnYqd0jze31u70cHl68Fq3v/Y9WD22ZIlQtx
	tDy3oGhxwPP2zu8baQXT6DDOLiZ34I6fPOTVElJnw0lwcg4Evh1hl2rTXRaZy76/6+BsgC1iAXE
	I0X0Ovi0eKnVJLaujhWkN6g0VoyqHiH66r5EVkgAN
X-Gm-Gg: ASbGncuJKFiJt5R7etS4UAAGeLqkdRxCzU8UYi6G58VUOIwC6L29/Lu7pI1Pt4k3LP1
	2kpWsD70hJFNOkmUsO+ABRTHQN2sSpuCDyCl/W76phVMeLGxVitUB2i0sQpP7fT8ArtoS5z8kdM
	+cnKdnY7o6axnL9nB3XVsEmCtezzyqT6lUygPX6J/PIQpRfsf4VC6vDKaRT7XJ3RIEqPBtwuT9s
	KanGbSza1kR
X-Google-Smtp-Source: AGHT+IEtSWdZJL7MjcUOvhCc2wKrYhqNNA4gbAATREhJbEStyOj8EYbXo7ZgZokHhID4ohn9sTEduJJSb+sMXCD1kFM=
X-Received: by 2002:a05:622a:5143:b0:4b2:9b79:e700 with SMTP id
 d75a77b69052e-4b2ea8688bdmr5000831cf.4.1756253883627; Tue, 26 Aug 2025
 17:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com>
 <7944006e-8209-4074-85da-14f5545cd8b6@redhat.com> <Z6H4qCZDthSpI3nN@raptor>
 <CAJuCfpHZFAH4YvzekBgL2Np9UE95tw6ueevxapFzLXpf8UeoqA@mail.gmail.com>
 <CAJuCfpFyJBf1PX_d6NKDVSgg3EhXcbebVCYjMMpti6d5VnAJwg@mail.gmail.com>
 <CAJuCfpGghAELOpAxcUrAsGt86th-faAdOebw0SfYesS0+2cGmg@mail.gmail.com>
 <CAJuCfpEXBMBTPB6j3OS9uaKT_NbyqivnpA35hRYRiPikgyO6AQ@mail.gmail.com> <d3177175-86d6-437b-8084-9d3521161146@redhat.com>
In-Reply-To: <d3177175-86d6-437b-8084-9d3521161146@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 26 Aug 2025 17:17:52 -0700
X-Gm-Features: Ac12FXxYuXiWZ_9HZPUPQraGj7WN2hl2JYJsC5_UZBmEpv6autsqdoWRJIb0TPo
Message-ID: <CAJuCfpFBgYrOsAD5JbuBOMUVJo7H5e_qDxjxPsqHH1SSQum9Xg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Guaranteed CMA
To: David Hildenbrand <david@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, lsf-pc@lists.linux-foundation.org, 
	SeongJae Park <sj@kernel.org>, Minchan Kim <minchan@kernel.org>, m.szyprowski@samsung.com, 
	aneesh.kumar@kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>, mina86@mina86.com, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <liam.howlett@oracle.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iynqufh8z7xgiib4njzmkji686ag85d7
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FCB340008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756253884-381250
X-HE-Meta: U2FsdGVkX184d2/Q/OnyEvSxQyjr70b85CG94AbTYruI/SKrezZorI0dUCoHHPcKv2D75HkJWJDj3n7jnxBYRo3R3BfeOcfUmRZeBL4yVl3JZC0oAAwGs6EisIeRU3UmG1Cr5YTn/KrczfHcYf48b9jc8XOu8Np36ycBxhxpie8VkuuNmMlOiW8JlQ1pdXljxqP84t83tjdq5sFwf0128ugun6OBqVmyiYhfljVVmoKM0Uyn7O1fYRJGg3X5xMjRQrddFVXowAedHE3TbyoH64wmV+oobkUMHcSaceqkn6wLYHJnwl0hfg+rLkC2uU/orpAzX+pko/imk6leqd9i4Ioikbc3NcFX+rb2A1jhdlQjiuLMrpNoXYD7GcpohLLWwSR/L/BI8c6+BWPPEWWw0VrL9w0oyXzxZOYiaLFINbykS6AikTs0iYnWXUDXNQmZe+KZBqpn3ncDbfSJhF1qvp/4ZV0lmJvlhLy5DHsKgXXAEoJXgyeT7YPNJ2hkHemwQWuslCQIM++eIAUvI1Ra811XblYjKpVNIMfp04JPHUXgu0BZiLljaTHVGnIR1erl+oltB0fTVLgj2wwnf4UPsTgC8hJSxPf/XAMRWKbOnykfwhWcwGJ3oyzjnSWmtX4i9sbJV7VtfsPhqMp48Z6wOVKlntYkuQ/YwxZBXONLpRyRVBTTK5CDWrOz2F5ky6q90Oh45exncM6BuYkXIVzzUTe1pIlk3skT+4lfALQc7spo/z+FdR3V52Ja+kXA64Mq/Xo05ZI94/r9cjzo4PXN6TW1KL9ylr5764XW6sFKlSTJ+MsJEutuYfP0bCt0dN1e6QzBBNAs0N2O/sSeGzydoLQWaozO1GY4J/BHsydSeqQcFkX+9uYvg1kcf/m78LOoKpHehKFFp4g8ShyAlI/js1OWIeNLauURDwNt93s7jdDV/IX6nlOY3MljWNiBEDper1fuN7g190bjg8Ef9R1
 q3SyIe27
 4Ebj+h5S3BoUbPKsCdHo+a1R2+V52/gEXn8aKr33OGwFtgkNCN32y86jLEDdO8GlVHTgOrPVDplecNdFiQks+rZz3NaEDz0HCkKfPhgs0d0dhgkf2i71/MJNYsgpHOE+xxBCs0Nl/fvyXVxRsz6A6VjgOyETKojDfXJoXHsf5SgdwfkdMahGzZFIIIi9HCnOi8SJzBmaLgKrCsePcedpHHp/dHDdffTDxn7s26gzLinzjtE3c2SmXrOrKqA+PffXwURQEaa7+l2saoebECuINco9t05YDRShiydRHa87R6+ewRT5VPv6a10cZ7puD0QP+0tqUMvizMcqpGVs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 1:58=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 23.08.25 00:14, Suren Baghdasaryan wrote:
> > On Wed, Apr 2, 2025 at 9:35=E2=80=AFAM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> >>
> >> On Thu, Mar 20, 2025 at 11:06=E2=80=AFAM Suren Baghdasaryan <surenb@go=
ogle.com> wrote:
> >>>
> >>> On Tue, Feb 4, 2025 at 8:33=E2=80=AFAM Suren Baghdasaryan <surenb@goo=
gle.com> wrote:
> >>>>
> >>>> On Tue, Feb 4, 2025 at 3:23=E2=80=AFAM Alexandru Elisei
> >>>> <alexandru.elisei@arm.com> wrote:
> >>>>>
> >>>>> Hi,
> >>>>>
> >>>>> On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wrote:
> >>>>>> On 02.02.25 01:19, Suren Baghdasaryan wrote:
> >>>>>>> Hi,
> >>>>>>
> >>>>>> Hi,
> >>>>>>
> >>>>>>> I would like to discuss the Guaranteed Contiguous Memory Allocato=
r
> >>>>>>> (GCMA) mechanism that is being used by many Android vendors as an
> >>>>>>> out-of-tree feature, collect input on its possible usefulness for
> >>>>>>> others, feasibility to upstream and suggestions for possible bett=
er
> >>>>>>> alternatives.
> >>>>>>>
> >>>>>>> Problem statement: Some workloads/hardware require physically
> >>>>>>> contiguous memory and carving out reserved memory areas for such
> >>>>>>> allocations often lead to inefficient usage of those carveouts. C=
MA
> >>>>>>> was designed to solve this inefficiency by allowing movable memor=
y
> >>>>>>> allocations to use this reserved memory when it=E2=80=99s otherwi=
se unused.
> >>>>>>> When a contiguous memory allocation is requested, CMA finds the
> >>>>>>> requested contiguous area, possibly migrating some of the movable
> >>>>>>> pages out of that area.
> >>>>>>> In latency-sensitive use cases, like face unlock on phones, we ne=
ed to
> >>>>>>> allocate contiguous memory quickly and page migration in CMA take=
s
> >>>>>>> enough time to cause user-perceptible lag. Such allocations can a=
lso
> >>>>>>> fail if page migration is not possible.
> >>>>>>>
> >>>>>>> GCMA (Guaranteed CMA) is a mechanism previously proposed in [1] w=
hich
> >>>>>>> was not upstreamed but got adopted later by many Android vendors =
as an
> >>>>>>> out-of-tree feature. It is similar to CMA but backing memory is
> >>>>>>> cleancache backend, containing only clean file-backed pages. Most
> >>>>>>> importantly, the kernel can=E2=80=99t take a reference to pages f=
rom the
> >>>>>>> cleancache, therefore can=E2=80=99t prevent GCMA from quickly dro=
pping them
> >>>>>>> when required. This guarantees GCMA low allocation latency and
> >>>>>>> improves allocation success rate.
> >>>>>>>
> >>>>>>> We would like to standardize GCMA implementation and upstream it =
since
> >>>>>>> many Android vendors are asking to include it as a generic featur=
e.
> >>>>>>>
> >>>>>>> Note: removal of cleancache in 5.17 kernel due to no users (sorry=
, we
> >>>>>>> didn=E2=80=99t know at the time about this use case) might compli=
cate
> >>>>>>> upstreaming.
> >>>>>>
> >>>>>> we discussed another possible user last year: using MTE tag storag=
e memory
> >>>>>> while the storage is not getting used to store MTE tags [1].
> >>>>>>
> >>>>>> As long as the "ordinary RAM" that maps to a given MTE tag storage=
 area does
> >>>>>> not use MTE tagging, we can reuse the MTE tag storage ("almost ord=
inary RAM,
> >>>>>> just that it doesn't support MTE itself") for different purposes.
> >>>>>>
> >>>>>> We need a guarantee that that memory can be freed up / migrated on=
ce the tag
> >>>>>> storage gets activated.
> >>>>>
> >>>>> If I remember correctly, one of the issues with the MTE project tha=
t might be
> >>>>> relevant to GCMA, was that userspace, once it gets a hold of a page=
, it can pin
> >>>>> it for a very long time without specifying FOLL_LONGTERM.
> >>>>>
> >>>>> If I remember things correctly, there were two examples given for t=
his; there
> >>>>> might be more, or they might have been eliminated since then:
> >>>>>
> >>>>> * The page is used as a buffer for accesses to a file opened with
> >>>>>    O_DIRECT.
> >>>>>
> >>>>> * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTERM y=
et' - that's
> >>>>>    a direct quote from David [1].
> >>>>>
> >>>>> Depending on your usecases, failing the allocation might be accepta=
ble, but for
> >>>>> MTE that wasn't the case.
> >>>>>
> >>>>> Hope some of this is useful.
> >>>>>
> >>>>> [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34-ae0=
0-0105d7c9343c@redhat.com/
> >>>>
> >>>> Thanks for the references! I'll read through these discussions to se=
e
> >>>> how much useful information for GCMA I can extract.
> >>>
> >>> I wanted to get an RFC code ahead of LSF/MM and just finished putting
> >>> it together. Sorry for the last minute posting. You can find it here:
> >>> https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.co=
m/
> >>
> >> Sorry about the delay. Attached are the slides from my GCMA
> >> presentation at the conference.
> >
> > Hi Folks,
>
> Hi,
>
> > As I'm getting close to finalizing the GCMA patchset, one question
> > keeps bugging me. How do we account the memory that is allocated from
> > GCMA... In case of CMA allocations, they are backed by the system
> > memory, so accounting is straightforward, allocations contribute to
> > RSS, counted towards memcg limits, etc. In case of GCMA, the backing
> > memory is reserved memory (a carveout) not directly accessible by the
> > rest of the system and not part of the total_memory. So, if a process
> > allocates a buffer from GCMA, should it be accounted as a normal
> > allocation from system memory or as something else entirely? Any
> > thoughts?
>
> You mean, an application allocates the memory and maps it into its page
> tables?

Allocation will happen via cma_alloc() or a similar interface, so
applications would have to use some driver to allocate from GCMA. Once
allocated, an application can map that memory if the driver supports
mapping.

>
> Can that memory get reclaimed somehow?

Hmm. I assume that once a driver allocates pages from GCMA it won't
put them into system-managed LRU or free them into buddy allocator for
kernel to use. If it does then at the time of cma_release() it can't
guarantee there are no more users for such pages.

>
> How would we be mapping these pages into processes (VM_PFNMAP or
> "normal" mappings)?

They would be normal mappings as the pages do have `struct page` but I
expect these pages to be managed by the driver that allocated them
rather than the core kernel itself.

I was trying to design GCMA to be used as close to CMA as possible so
that we can use the same cma_alloc/cma_release API and reuse CMA's
page management code but the fact that CMA is backed by the system
memory and GCMA is backed by a carveout makes it a bit difficult.

>
> memcg doesn't quite make sense, I assume.
>
> RSS ... hm ...

Yeah, I'm also unsure. I agree that memcg would not make sense because
this is not some memory that can be reclaimed and used by others.

Thanks for the feedback, David! Hope we can figure out some rules that
make sense here...
Suren.

>
> --
> Cheers
>
> David / dhildenb
>

