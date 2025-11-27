Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2436D116E3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5156E6B0008; Wed, 26 Nov 2025 21:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C59D6B000A; Wed, 26 Nov 2025 21:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5246B000C; Wed, 26 Nov 2025 21:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26D746B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:36:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B993FC0970
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:36:34 +0000 (UTC)
X-FDA: 84154823508.19.E4962D7
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id DDBFF1C0006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:36:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i1cLveWU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764210992; a=rsa-sha256;
	cv=none;
	b=wLikotVSt+YRaeF4bMr5y/C2rfUWPNMgWlm0uXfHzAVyVkpDDJ4R4rzFH7rgvc/6LP4ZRU
	3G+1+9nFV2L0tWZHP03b2LvZqjTQinarNaJdAd2iEmHK4ipFiafTCBGBpHMTs6nDkEGQdi
	+zwifrkldEVcH5ORqVo0eIHhXxQ/sFQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=i1cLveWU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764210992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dG4CF2IMP7M0Y+1dFumBVpCBxoZ8uo+lnVXyk35N/v0=;
	b=yQSmUCaqvcUBKIGbeEIe4m/a8UL6OesM+idMkPbo466rs050DXUuXoxadXWZc1nIBI3fJf
	mgjFM19wrA3JqEPJCfrFernH4cR6986mVZDBvxAXc8J4cqYi5p+XTs7uSndaae7JoDR+oL
	2hyfdz3qMimjcLKT7kn2ke7fNWPTpMQ=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-78aa49cde3dso4412727b3.1
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764210992; x=1764815792; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dG4CF2IMP7M0Y+1dFumBVpCBxoZ8uo+lnVXyk35N/v0=;
        b=i1cLveWUlKwSMRaPVMtkPON7pOy9tUgqV90lLyrBuhDYaIeQyw6PjKjYKSUf+H59+1
         SympLipzsBMjbQ9SrnLWZPc2dNYIfD1H1Yz/0C6j0imruseolTeHaY86ju60/DVW3MR0
         huGujOSStXMSaURJaB/F9A8rpB5KG28fDOvAh0AqdsruALvSxfi2TyEqmgot63HbvWnn
         /QC3uE8+CKsT+PnhK1aMst+apPY7vVV6YESXM+eMS40MFY5qo1z2DyhQZk4Gtek/l8rV
         y7CWUO99AUs6v4D8dRaMRul2D3qZBCfsIE3HOP5v6D9VKRhOrusKYgFjeM63Z3XFZCoD
         ihmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764210992; x=1764815792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dG4CF2IMP7M0Y+1dFumBVpCBxoZ8uo+lnVXyk35N/v0=;
        b=AuesOVl3VX4lRuGXIjOmgls1+q6UCXZXn2vreX3RHtmSReulLJYawROx+UiTAQj3IG
         /nKsGcOXtiuP+OfYG5NKgH5DrNrhROJLevhchpMgQ5fmSNkVyI2zKicb4dD5GyRQMaHR
         ZMcusQRTtHHc9l7obAokdZmuafyEyNG4qNnxcQBksWSTb3R72shj8M48ohDhp17B3p4/
         xUr1TBOPOxdIQN9Dw/sZC2RVHQ0OTgd5WL7DlMrRy5NrTBiWyPuEygC+xN3VUdbeJzI9
         3LJe1pEMIN8VGLTLaZ0xYiSYlAwrBEQswiMfkjlSM2PVG8zpt97KWuTdH0FiCyZCWUgo
         PBHA==
X-Forwarded-Encrypted: i=1; AJvYcCXAePW7kTaxfz6uLDfLHOq9UeN53n2J53F1LKQFIFOu3hMZ3L2GcsUuQqSl7tSDClhZT8x7j5j6cg==@kvack.org
X-Gm-Message-State: AOJu0YydPm9jSFC+OGa54PPJ0tGISb4lYUkJUO6jTYPY50uqMtbjpdde
	TYGnhVWB72YSwD7L2vHlIeiyWTQh0XWIPeX2MoDZ6oaQ6PU47SDNNpy9a6WZX8YHjty/sQDmS7m
	HsHEs+eO4bKp9zqCJF+f0Yk3WWqv0sAE=
X-Gm-Gg: ASbGncu0ecYOExErv+qSZBa1VGu2N1FeljSA0xlQcnHnUQToqlTHlqzFsyoFC0uly5L
	ZKyBlQPQFThQheMBoPm/35AshSDXjWpK/52JKNpYdzdGsNz1mKKcJbAUyTJ/56sr+V/nyXen5tV
	xiYDaQ/l3UhNdBBh5lyKwLjPuGzhVT3CpunvTmuF1MJvf3w65cA4UYqIouDqJ2wyLGB+RD13lP1
	H8PqKw8q7mN+HBmrQhdC7AJGTBf2nsuH+O1CGHj5a/c94x/TYrbC1Q4iKrmKGb6s///yNdcCDEh
	427a69w=
X-Google-Smtp-Source: AGHT+IEfDA/1rHeriKTtWS6bCyAPbkv++vWNjxf3ZtzQfH/D7x8K9kI181xzUZI2IDSfMgR8uq8FIQ6PZ94MkZtBzVQ=
X-Received: by 2002:a05:690c:6087:b0:786:5926:edab with SMTP id
 00721157ae682-78a8b491ceamr194700327b3.17.1764210991823; Wed, 26 Nov 2025
 18:36:31 -0800 (PST)
MIME-Version: 1.0
References: <20251026100159.6103-1-laoar.shao@gmail.com> <20251026100159.6103-7-laoar.shao@gmail.com>
 <CAADnVQKziFmRiVjDpjtYcmxU74VjPg4Pqn2Ax=O2SsfjLLy5Zw@mail.gmail.com> <177c8e4d0567456baecc962bf5c1038f05358cc0.camel@surriel.com>
In-Reply-To: <177c8e4d0567456baecc962bf5c1038f05358cc0.camel@surriel.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Thu, 27 Nov 2025 10:35:55 +0800
X-Gm-Features: AWmQ_blljVhaUoneZ62O-qRbUJWn4XyE-NLR9m4vdRR0mJlvaxy3SlytZXAid4o
Message-ID: <CALOAHbCeRZO6vy6qmnG9OgttpTDBtymrvrUZk4+kRmiN4xrpRg@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 06/10] mm: bpf-thp: add support for global mode
To: Rik van Riel <riel@surriel.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard <eddyz87@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, John Fastabend <john.fastabend@gmail.com>, 
	KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>, 
	Jiri Olsa <jolsa@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Amery Hung <ameryhung@gmail.com>, David Rientjes <rientjes@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Barry Song <21cnbao@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, lance.yang@linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Chris Mason <clm@meta.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDBFF1C0006
X-Stat-Signature: q98759n46j54qhwj4yuyrz5hkgt1o7r3
X-Rspam-User: 
X-HE-Tag: 1764210992-425402
X-HE-Meta: U2FsdGVkX1/jRdyhXaeYNDkvSnx8I9K0POV7916ghIZDmnc70i4SpYGJnWVS0JY2gpceRZJZ/nJYSE3QQ4DIlZncBK8mgeuLt7YyY24GqTv8zoRCGiGukgs9/NSoK7W35297ziBVT1+hUfVbf9i4en+QGtDInzeUFnJEF0LnJ8mTAf5XeJQl+bDAptdQ2VraAJJgYioRsH75VuS42vflCDn2fOiheMKwG3prgpnzE5p1VxyEZP3kykmmFVa3FZNmoaH/x9qVQ+ycpy+ilPmJrPx9Nm7zphHUEsxbTru+7xY+8TFoq5UOoQTrrOOCXVQclRU0pUFC2zDjtrrg8H8wgWWjJ9vRkgr0vwdppL6Vg3NXAkpBP+nVYyl/LfEbcqZt6NSPBeuWxrlZ4rVvnXHmvZ+OcHVAxuj9Ha71kLUgeUM4O8NLDonmIT/VZ0dIXA4O8D7GqKj5cXRQo8mQ+1rC2T3SD9hCREFlRFy/p/c3haCdgnvWPgJ39YTgfTtiN92WwqCetWNG00iaZtpZqVRYh37SQhbmJwf3iL55hzaWoAP+1yl9TxIiUfJKFZDlzkuYXXsiHBsZ3CANkL9VMv24NDlSLPaJwdZEnnayjZGsuZnWnZm9YW0OmZdTICwgk1Is1vG4m1LODjfgsf09YYK+R8oQtCOLW4eaQJau6CT7dWFvsRZNRQ0G6EWmYQtfysMiJcxcFhPBeuAMmqR67pHVmpKRQQHL2g0Oyp+nfCHTIaVNjatX8zPEtDtvshba87B8FlZALNmtHQnpfJkQ6o3rQ5/5vs/GlTf8RcYxYeru+RK3odnBONdfTZ1YTWJhTFAFZqTahVL1NJtl5JRLRRPM5B595Ylv1rGuyc1H8O2R3gyDVrwzd87gy/en8bm15eQU4HkSrpshUyRQzinfkyk2Ml4cZBSwhMkfWOmtk3kY8y84Y1YYN/XeKuSmZ8AHEf60fFMxuwcSD+XxYrlByBM
 vJ5uotjp
 TJU9tGREilr1goi8jOZiwn4ACegB9B4ky7A0sqmhEFcWo1fG8v4zC3dnYGxg9l4ol1fTBM3nE3JfjzCyrxhwStT2QGyfaIm+wug4zRJ+BFMWBIJYbeMkVmrTBeaU8nZw9OXst9SxTKTgyYgDl6fmJs6u3lUL0wkAeG2Dl/yDbkb9/uXPnuGx7LyMhOMot4yw87ij3F5ZD4xDmhnb/HkeKbbJccluG0DHTFWj3e6RWG0JKFNkHkpOTRLS5RLs3N8FsHwxljTOEZFC9OySex7vUgBoJWe2UJIDtaErdxZ8wQtoo2K3Uppch6dz0EN/Y24nlFlWB6RWyGtLwlePjMYlEPvbQJpjWomrAb7+/q4o945l+iOXN8MtEDXfQJCosm+NTJjnsvpYJeWJx/GHSI7Cjy2YjDhZqoXZSUoIgWTC+0cYoGJpa4SXC8neCOWev9n9xJCy8Yu8AJpE09BhbrTIm64DXD7ktnWJK9bI1ty1k6CxCbigBOZd7HxxftkEMWPPIGRZaRXoALaA1JnVL+v1I0vRnI+pLc/p2L7aN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 11:13=E2=80=AFPM Rik van Riel <riel@surriel.com> wr=
ote:
>
> On Tue, 2025-10-28 at 18:32 -0700, Alexei Starovoitov wrote:
> > On Sun, Oct 26, 2025 at 3:03=E2=80=AFAM Yafang Shao <laoar.shao@gmail.c=
om>
> > wrote:
> > >
> > > The per-process BPF-THP mode is unsuitable for managing shared
> > > resources
> > > such as shmem THP and file-backed THP. This aligns with known
> > > cgroup
> > > limitations for similar scenarios [0].
> > >
> > > Introduce a global BPF-THP mode to address this gap. When
> > > registered:
> > > - All existing per-process instances are disabled
> > > - New per-process registrations are blocked
> > > - Existing per-process instances remain registered (no forced
> > > unregistration)
> > >
> > > The global mode takes precedence over per-process instances.
> > > Updates are
> > > type-isolated: global instances can only be updated by new global
> > > instances, and per-process instances by new per-process instances.
> >
> > ...
> >
> > >         spin_lock(&thp_ops_lock);
> > > -       /* Each process is exclusively managed by a single BPF-THP.
> > > */
> > > -       if (rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
> > > +       /* Each process is exclusively managed by a single BPF-THP.
> > > +        * Global mode disables per-process instances.
> > > +        */
> > > +       if (rcu_access_pointer(mm->bpf_mm.bpf_thp) ||
> > > rcu_access_pointer(bpf_thp_global)) {
> > >                 err =3D -EBUSY;
> > >                 goto out;
> > >         }
> >
> > You didn't address the issue and instead doubled down
> > on this broken global approach.
> >
> > This bait-and-switch patchset is frankly disingenuous.
> > 'lets code up some per-mm hack, since people will hate it anyway,
> > and I'm not going to use it either, and add this global mode
> > as a fake "fallback"...'
>
> Should things be the other way around, where
> per-process BPF THP policy overrides global
> policy?

Makes sense

>
> I can definitely see a use for global policy,
> but also a reason to override it for some
> programs or containers.

We have deployed BPF-THP across nearly all of our fleets for over six
months and have enabled THP for dozens of our services.

Based on our practical experience, the global mode has proven highly
useful as it establishes a default policy for all services. When a
specific THP policy is required for a particular service, we implement
it using dedicated BPF maps=E2=80=94such as thp-always, thp-madvise,
thp-never, or other custom policy maps.

That said, I also find value in combining a default global policy with
the ability to override it for certain processes or containers.

The global mode and the per-process/cgroup mode are not mutually
exclusive; they can coexist.

Through our use of BPF-THP, we have found that the most reliable
approach is to allocate all THP at the initial stage. If a service
dynamically allocates a large number of THP during runtime, it can
easily trigger compaction stalls=E2=80=94even on the latest upstream kernel=
.
Therefore, monitoring compaction stalls and memory pressure is
essential to determine when a service should stop allocating
additional THP.


--
Regards
Yafang

