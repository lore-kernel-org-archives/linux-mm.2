Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB5BBCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 22:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5588E001C; Fri, 22 Aug 2025 18:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9DDF8E0018; Fri, 22 Aug 2025 18:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2C78E001C; Fri, 22 Aug 2025 18:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA25E8E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:14:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 58C571603A8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 22:14:58 +0000 (UTC)
X-FDA: 83805799476.08.2132DE0
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6AEEE1C0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 22:14:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1gxyxU/9";
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755900896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzZSfviXYIPEvuX2dWBngQDyNZJlgkc73v8w1kdFqFY=;
	b=5kbVsAy7/E8TlwtGjPbaairwRVeV++vhsojSAfDOvHjrlUj06jeXGVFDjDu/dpZ3FvAqwk
	/EXwaWovKXMzqUZ3MhCMuYjkpfExHf6C24JC6bgpy1DLNsi53PdKjTGodeQKAIFHrE+5ha
	QzjHZ7Nl5zHiMmvYZmadNKYPcDNAhkQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1gxyxU/9";
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755900896; a=rsa-sha256;
	cv=none;
	b=PcYAvczg+f4+N14NLYTed3ITc6BzufDehH2Ftp4l+PAMUkAkhqDZFN3IbrpE5Iquha6pm1
	WbIwW3QifQ1qaRZMrQs1bl7NW7FQdBwOTZ2F7AZxVaUjUyKz7Gyyt8EUFYme0VTleLdAQq
	Y276GRtvMu+kUyFVwRNRm9TEr2RrhEc=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b12b123e48so106331cf.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 15:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755900895; x=1756505695; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zzZSfviXYIPEvuX2dWBngQDyNZJlgkc73v8w1kdFqFY=;
        b=1gxyxU/9DaM4VXlX3LMw1PUCMt/nOdk6Os8MAfT4rwAcy76QnnfpaQYkpkEZZTaStT
         QMjfNvvykm9nrT7MDxogMCipKenfGt8en5ttJZlajs6Np6GDrb6Q3qpMpOLFIq7EnR0d
         959Fo9+FUZwhDLLhlAyKcYEGhyC1h/0omSpzY3k3ZCMYCIsdAhgtyZU8ejASP7So1RVc
         OMI9CZDlpQEmt5d+vs8OBJBRHe00NATuHletcnbBYTzBQ+xbXHLsWT2zx0xEaY325SV5
         O32bfx5Zg+C3p3NUX0TI7hWIrcaHWBPtGCphkmBj0NyMVfqB8iDnrAMdw7OXijAF89oJ
         c6Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755900895; x=1756505695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zzZSfviXYIPEvuX2dWBngQDyNZJlgkc73v8w1kdFqFY=;
        b=K2UFxb33bXca/ANjBR0iNkzJnfhJJnqWEZ5kcENly7iXRfVdOwR+QtqD1nMgsa/iYa
         zQ6X3hvLZi0DULIbUP/oN5ep1AzawapyUqVQO8RWGWTA8jOC+jpE0h1MdGq9WawMFaZx
         2dtXiUajqq/lYRMYSkxNa2Dbbs6HpAHArDsaTUwC0kA/mAC731nI3EbP89qxfD8RXh6Y
         Lt6LQ7QgJr60mOIcN3c3Kcp1/5rmg1zrkY+Wi2korLvo91W4QmtKK37O4C/1h6wGhmMs
         n+fLowz2jYk+ZF9sBTLBZ9BQTSPojReBKSRf/+lJsk2wh/qcLS3+MtGfQ2VgxedGVTGz
         tvUA==
X-Forwarded-Encrypted: i=1; AJvYcCUEo9XYs8pa5rsHtsEfSBMtr2IHk489oMHYos67y9TL7005NJtA9xT+U1hLQOtC0cYJsRA7leZHMw==@kvack.org
X-Gm-Message-State: AOJu0Yw/mzVw+2PRksM5egbUTFvPfX2Le+cZir/7V7Ks8xUF1ANKQ6Mg
	vxZM4198RycZ1ZghY/9empP+bqiWurjPQwxbI+BSHCFHHHrG++kBtb2yJ3FyXhy6wCprGYxsM0w
	YcOLHZZV+6K1XJ+ACjxBvXUuL/pwuEyKJ1zBIdwqG
X-Gm-Gg: ASbGncsNeg4PRsArBgyObF0CtSXr1jqbBbZhSZ3kyXWXMfGb6S7bPW/I4NbweykuQoO
	MOvwPUdeEfKohy67EY8SfEjri/+mdh+rymn0fbOgz66EqMJK9zkNgyyUcUJgtcqrlv4yaQs96Vz
	bBvIpyG0xyG1hhZG57TNIS1Th2RNF52Rl6uTOqNzHs2fNJ/llYqGsFgS3Oy849nhbpCW7lH0TYI
	y9tpN5ktq70
X-Google-Smtp-Source: AGHT+IEpXpizlhAN0qep6IIUs4y1op5hwhDyRU508ixFdh/d1QuIamAU489hb4IBBG79NUE+ofbFqU0oW+oeUXhRZeQ=
X-Received: by 2002:ac8:5fcf:0:b0:4a7:179e:5fec with SMTP id
 d75a77b69052e-4b2bc44cf74mr495891cf.15.1755900894992; Fri, 22 Aug 2025
 15:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpEWVEqsivd7oTvp4foEho_HaD1XNP8KTeKWzG_X2skfGQ@mail.gmail.com>
 <7944006e-8209-4074-85da-14f5545cd8b6@redhat.com> <Z6H4qCZDthSpI3nN@raptor>
 <CAJuCfpHZFAH4YvzekBgL2Np9UE95tw6ueevxapFzLXpf8UeoqA@mail.gmail.com>
 <CAJuCfpFyJBf1PX_d6NKDVSgg3EhXcbebVCYjMMpti6d5VnAJwg@mail.gmail.com> <CAJuCfpGghAELOpAxcUrAsGt86th-faAdOebw0SfYesS0+2cGmg@mail.gmail.com>
In-Reply-To: <CAJuCfpGghAELOpAxcUrAsGt86th-faAdOebw0SfYesS0+2cGmg@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 22 Aug 2025 15:14:44 -0700
X-Gm-Features: Ac12FXzoTVSLJSaXdsfu2-ndoCaY5thYL1IaQKwkf2fWyWMlXOTJm45tQ7njKzw
Message-ID: <CAJuCfpEXBMBTPB6j3OS9uaKT_NbyqivnpA35hRYRiPikgyO6AQ@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Guaranteed CMA
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: David Hildenbrand <david@redhat.com>, lsf-pc@lists.linux-foundation.org, 
	SeongJae Park <sj@kernel.org>, Minchan Kim <minchan@kernel.org>, m.szyprowski@samsung.com, 
	aneesh.kumar@kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>, mina86@mina86.com, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <liam.howlett@oracle.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm <linux-mm@kvack.org>, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6AEEE1C0004
X-Rspam-User: 
X-Stat-Signature: ezz3ujdeq64pq3ukkt1jq81iut9crajh
X-Rspamd-Server: rspam09
X-HE-Tag: 1755900896-750387
X-HE-Meta: U2FsdGVkX1+SJi3vMDfwMTJMz9UUVj2AgUkb7hqNGmmdAysceJ6ql54RB9XUrrCyZBZAkxRNZmBmQDuuHbkXSjaa+XuJGKBvKnz8s+JAOzNVRWXKHZp0sVsQUbjA3iQbHL21Ra7jLBg6wLsaU/mXj9QgJDG7pXOMm/ioXu0zqdvgWVXRsfCVNMiZ9eNEPwUrKhtua0MWpzLKfw/owE12nv85qGQQNiUL8j47PBOMQ1aQZQCNhDdlzaz4Su9JXMp8AeQ9WXs2pxalx8C3/95PyXGJ9cK1814OP9trcstmI8Xc1K+v5ae5ZO2d0xcprAM1CxfOIJijmDGCRmORNbCsjsRbJMEJ1Iqs1i++tvDyhdWNsKw6typSckO8VFSAw1Bar4My4lAjX3SQLmI4K7LdB8+KHqiq2Nkr6pZQYDMkhKf2oWG/PNiq6Cp1Dgh2smfxGwmjlitHN2szevlwSMSpstCcs7GK1BQXGme1ShIGBJXkJPM+PAmuK+7J7vvieiHn24AWXvF8SYVSICCk+im3L+JI1Va9rtumVZGfzVbAWa3gc8mbJSqYnXHY5db1Mv6n3zXduEIBr4jfplMdkB4wl6OkG8akZ1uKfnGdpCTjSkVZ5QJh4a554lS7ElRzs9CEqV6mgXzNs82MKwOtI0gkeAS/EJz+XXp8RDmiyfdJsOPLakacfYpm0fk7BAoAzEZiAkuxc8QJrXoEQHjuZ+uJY1RsKQL3jvcsjtOK94THrn1u0F4WIq3Wqiv+myFpH25IFLedPQOzheysO8E+o3ZZmW1WKUq8UZNvN41f3O9YHZ0f/UNSKorsDJ2HCWhg4Y4iabOSk1opAtZPDS/RsHAeJY+EfDy4S5SdDOQZqPl1c3RX2lLPlbOTfVlx5r6FY+pA4qCqaUQG0nS30lmXHzaDWy8x9xkAKJPllbng58Eq/LoZnlUpz7GafPYV5hiV5heovRXbSprDO1CZunNd48W
 HwtH0DyI
 35FmyXRyAfkDIZUUrSz86iMgJuCo7nSsM3PlJ2uquSi1rOYF9V1kmCfs0OMN1FJNcWM4edet4oE19//6u9HZfC5HOj799lc+JQM77kIXPevc7R7rZ8V23JotnyxrPa5B8pemozKfMrl2UHe6Prp1mL7thinTTd77mtg8zsgaWWBOOKwtL8szpK3aNPJZHR8o/nGyrxuAR3FExNm6UD/9i7ONL1wzbU7X6DpVApsmkvZE0tIYfPK64YKGSzNm7iio8EZizA3zvZRYKmHUG+1xDZqGxPmhuSV++yp/rW3bDB8m10B8waoL9y34yDEUBPFSf9nzYiG3BJUKpEMI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 2, 2025 at 9:35=E2=80=AFAM Suren Baghdasaryan <surenb@google.co=
m> wrote:
>
> On Thu, Mar 20, 2025 at 11:06=E2=80=AFAM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> >
> > On Tue, Feb 4, 2025 at 8:33=E2=80=AFAM Suren Baghdasaryan <surenb@googl=
e.com> wrote:
> > >
> > > On Tue, Feb 4, 2025 at 3:23=E2=80=AFAM Alexandru Elisei
> > > <alexandru.elisei@arm.com> wrote:
> > > >
> > > > Hi,
> > > >
> > > > On Tue, Feb 04, 2025 at 09:18:20AM +0100, David Hildenbrand wrote:
> > > > > On 02.02.25 01:19, Suren Baghdasaryan wrote:
> > > > > > Hi,
> > > > >
> > > > > Hi,
> > > > >
> > > > > > I would like to discuss the Guaranteed Contiguous Memory Alloca=
tor
> > > > > > (GCMA) mechanism that is being used by many Android vendors as =
an
> > > > > > out-of-tree feature, collect input on its possible usefulness f=
or
> > > > > > others, feasibility to upstream and suggestions for possible be=
tter
> > > > > > alternatives.
> > > > > >
> > > > > > Problem statement: Some workloads/hardware require physically
> > > > > > contiguous memory and carving out reserved memory areas for suc=
h
> > > > > > allocations often lead to inefficient usage of those carveouts.=
 CMA
> > > > > > was designed to solve this inefficiency by allowing movable mem=
ory
> > > > > > allocations to use this reserved memory when it=E2=80=99s other=
wise unused.
> > > > > > When a contiguous memory allocation is requested, CMA finds the
> > > > > > requested contiguous area, possibly migrating some of the movab=
le
> > > > > > pages out of that area.
> > > > > > In latency-sensitive use cases, like face unlock on phones, we =
need to
> > > > > > allocate contiguous memory quickly and page migration in CMA ta=
kes
> > > > > > enough time to cause user-perceptible lag. Such allocations can=
 also
> > > > > > fail if page migration is not possible.
> > > > > >
> > > > > > GCMA (Guaranteed CMA) is a mechanism previously proposed in [1]=
 which
> > > > > > was not upstreamed but got adopted later by many Android vendor=
s as an
> > > > > > out-of-tree feature. It is similar to CMA but backing memory is
> > > > > > cleancache backend, containing only clean file-backed pages. Mo=
st
> > > > > > importantly, the kernel can=E2=80=99t take a reference to pages=
 from the
> > > > > > cleancache, therefore can=E2=80=99t prevent GCMA from quickly d=
ropping them
> > > > > > when required. This guarantees GCMA low allocation latency and
> > > > > > improves allocation success rate.
> > > > > >
> > > > > > We would like to standardize GCMA implementation and upstream i=
t since
> > > > > > many Android vendors are asking to include it as a generic feat=
ure.
> > > > > >
> > > > > > Note: removal of cleancache in 5.17 kernel due to no users (sor=
ry, we
> > > > > > didn=E2=80=99t know at the time about this use case) might comp=
licate
> > > > > > upstreaming.
> > > > >
> > > > > we discussed another possible user last year: using MTE tag stora=
ge memory
> > > > > while the storage is not getting used to store MTE tags [1].
> > > > >
> > > > > As long as the "ordinary RAM" that maps to a given MTE tag storag=
e area does
> > > > > not use MTE tagging, we can reuse the MTE tag storage ("almost or=
dinary RAM,
> > > > > just that it doesn't support MTE itself") for different purposes.
> > > > >
> > > > > We need a guarantee that that memory can be freed up / migrated o=
nce the tag
> > > > > storage gets activated.
> > > >
> > > > If I remember correctly, one of the issues with the MTE project tha=
t might be
> > > > relevant to GCMA, was that userspace, once it gets a hold of a page=
, it can pin
> > > > it for a very long time without specifying FOLL_LONGTERM.
> > > >
> > > > If I remember things correctly, there were two examples given for t=
his; there
> > > > might be more, or they might have been eliminated since then:
> > > >
> > > > * The page is used as a buffer for accesses to a file opened with
> > > >   O_DIRECT.
> > > >
> > > > * 'vmsplice() can pin pages forever and doesn't use FOLL_LONGTERM y=
et' - that's
> > > >   a direct quote from David [1].
> > > >
> > > > Depending on your usecases, failing the allocation might be accepta=
ble, but for
> > > > MTE that wasn't the case.
> > > >
> > > > Hope some of this is useful.
> > > >
> > > > [1] https://lore.kernel.org/linux-arm-kernel/4e7a4054-092c-4e34-ae0=
0-0105d7c9343c@redhat.com/
> > >
> > > Thanks for the references! I'll read through these discussions to see
> > > how much useful information for GCMA I can extract.
> >
> > I wanted to get an RFC code ahead of LSF/MM and just finished putting
> > it together. Sorry for the last minute posting. You can find it here:
> > https://lore.kernel.org/all/20250320173931.1583800-1-surenb@google.com/
>
> Sorry about the delay. Attached are the slides from my GCMA
> presentation at the conference.

Hi Folks,
As I'm getting close to finalizing the GCMA patchset, one question
keeps bugging me. How do we account the memory that is allocated from
GCMA... In case of CMA allocations, they are backed by the system
memory, so accounting is straightforward, allocations contribute to
RSS, counted towards memcg limits, etc. In case of GCMA, the backing
memory is reserved memory (a carveout) not directly accessible by the
rest of the system and not part of the total_memory. So, if a process
allocates a buffer from GCMA, should it be accounted as a normal
allocation from system memory or as something else entirely? Any
thoughts?
Thanks,
Suren.

> Thanks,
> Suren.
>
> > Thanks,
> > Suren.
> >
> >
> > >
> > > >
> > > > Thanks,
> > > > Alex
> > > >
> > > > >
> > > > > We continued that discussion offline, and two users of such memor=
y we
> > > > > discussed would be frontswap, and using it as a memory backend fo=
r something
> > > > > like swap/zswap: where the pages cannot get pinned / turned unmov=
able.
> > > > >
> > > > > [1] https://lore.kernel.org/linux-mm/ZOc0fehF02MohuWr@arm.com/
> > > > >
> > > > > --
> > > > > Cheers,
> > > > >
> > > > > David / dhildenb
> > > > >

