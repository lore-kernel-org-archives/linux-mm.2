Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2B8CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 06:38:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BC4390025F; Sat, 16 Aug 2025 02:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893188E000B; Sat, 16 Aug 2025 02:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D05790025F; Sat, 16 Aug 2025 02:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D3E58E000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:38:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAD6C16037C
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:38:44 +0000 (UTC)
X-FDA: 83781667368.08.A333D7F
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	by imf06.hostedemail.com (Postfix) with ESMTP id 184F2180009
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 06:38:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gSP80f+V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755326323; a=rsa-sha256;
	cv=none;
	b=g7yJcp+/Cq/EzERlvf+0758jItFtCAVeYZaiTl26jg7BcakOHIM+N+z22Ln0L8rMAm4nCx
	qdR9SXPI4WdHa9t4oV2Ikr0h4waqyVjrlPGrosmdbZvbM6Bxd2UnprAN4HTAQQESvA/7V2
	E/Ubb7gU3aUYz1ZFaL/ppfZuectF8Rk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gSP80f+V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755326323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQnIeoP+s7VQU+kygRJWTfXX5/GWV+imwlaAnb6OVOA=;
	b=cnyQZl3EEQshBm6wic1IOEZl1kM/Lar29uRzJinlnFxxyQY3L0doRjuDDlRB4oZqMP2Paq
	u8ARUuqKZfs8M6P4DKGlaUbHlSEAWjg9ec7k4IKpvpdXovCgTGiqy9KQTjKrUI60zcE/Du
	N51xNhSrHtsoG+zMUzJxTIkNgYBJ4Ac=
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-53b174dbfceso861387e0c.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755326322; x=1755931122; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQnIeoP+s7VQU+kygRJWTfXX5/GWV+imwlaAnb6OVOA=;
        b=gSP80f+Vm8GoQPEiadLTuZBc4q3tfxijpOpYXv6WeuyAGa4HDeKeRKvIjATyyaxTIm
         JreySf6smwuhjALRfVaICo9mQG9tdhfALviHO6N+GEs00YIjAhgPLabzCJzOQjyaIiKS
         9QYO+57WQ7D0vRIMjFo9qLDvxEmx5o/MhJFoF82G5YBZ6WBMCNLbQIOd5Sdy6bh77ndb
         +qy0CiI8FkuhcUWaJ9eXQb5vamB4Zj9fvWkMn7ImLPlcv4wjvRCja1a8KxRSkyjwAwLA
         3gOZn/b4K5rYckY5nsisahd5VFLCD2ycs03cdit5MSpyOo8/2p86lvHEAz+Ko4B0YIyg
         uhPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755326322; x=1755931122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQnIeoP+s7VQU+kygRJWTfXX5/GWV+imwlaAnb6OVOA=;
        b=vvOvbihsWyC9EqslGL3iTxOn4C9PyTfLUfMJaz1UrTASFYl1vmvaUJoYXRvvNMZCVA
         RQAKhyTzHdoDD/P77D/dUjRi6BHkixd73NdpmYYA4EBqY+RXprWMvD2l41MMrnDu2v1J
         XZMogcfmUMzAGNraIctrW/KUI4IjIdbTPbzBlzygrZ6wTrypH6GwqdeuZZAYofXL0hww
         mtxHe5XBsiQu9RiWBI37Xb8oIKPtv0xuxFJbMw6aGwKoNnzDp05xOHAS30btrqCIuw3S
         yAgEeesACwJSwUYuJ0Ok2Yk8I+3P+kQoz8wLamjPbQx2P+mLGBMMiz2D6+Zle1d8vDXY
         JHxA==
X-Forwarded-Encrypted: i=1; AJvYcCXjtvQNiLhFyTaRtujxalXMGekkuWlU/fyLPrxfgtcF8DTWq1SBljR+Ok3yloEtBk2S2OH4XiTOnw==@kvack.org
X-Gm-Message-State: AOJu0Yx9sbD/XY+ivmPJZcBfMntv2yoBkU7iG/Vh1cMNVfAq0Wfdcfec
	53lA2wJ5bYqrHpBQ9cyvT1y+kOlbULzRGyOJEuV2mMOstVQxM4Ygj3sd50W9VSqDsnFK4jFEuzt
	zOHpKrW3qmUsDX4471eBdcZQ3S++DVg8=
X-Gm-Gg: ASbGncuBI+FjWXxehp3TADmDCj0eg1NAJEzCg5oIRHsbBDJ141PxdCjke5BgiXr69G9
	c4J3ge5wSy0oWSu3qcunW/ZNZgJa9PrYFrbvWyhHmc9xbqDWyAUE7At+shYc3QmqrI9CbBj9rY2
	n8h+gq/fy6fOsoWTjleHGizDrk9UhyilovMersI5kOdxwJUfD085oy8PK2qJm0r7c6u8P+V/g+d
	3K6UEjdvkj7EboqHw==
X-Google-Smtp-Source: AGHT+IFTBt0NsG+0QYclG+jSrN2ZA3xi0vSYGNE0ci5JVOTRpGQ3xUkVJgoW/6nmW62VzJSlkY+L7UjQUUl9QZNp72M=
X-Received: by 2002:a05:6102:508d:b0:505:ff14:8e0 with SMTP id
 ada2fe7eead31-5126af225afmr1907875137.11.1755326321996; Fri, 15 Aug 2025
 23:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com>
 <CAGsJ_4w5bAJHyBrwb5+n_EANqzhz4cFSX+9yZacmOiXVJZ_Dkw@mail.gmail.com>
 <CAGsJ_4wt_30C82B9_ZoOB2umBi-u_kE441ARvYoJVjkLtLqFCg@mail.gmail.com> <CA+EESO4NfgT6uAP52eQEt4_cx7KPdHv4MxnSw_UwHVSurime8w@mail.gmail.com>
In-Reply-To: <CA+EESO4NfgT6uAP52eQEt4_cx7KPdHv4MxnSw_UwHVSurime8w@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 16 Aug 2025 14:38:31 +0800
X-Gm-Features: Ac12FXzp4854qVOc_OABL1f6f01YvG2rCYIPXU2drb4n_pA96sDmbgBZnCK5-6g
Message-ID: <CAGsJ_4wwHMDocUjg=PBGafWYXmyDdbuDOi8kB3Xm2Q=J3VpCbQ@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 184F2180009
X-Stat-Signature: tsbx199xpo1n9z6nrzx85oncdf98w693
X-HE-Tag: 1755326322-776292
X-HE-Meta: U2FsdGVkX1/KNHERV8bCv0vEcDy6FyL/Mj2bTwspJymfA5DKilI4sDSthMovQo1K24pWOXkvvOrs4wsg2PQBclIGk35nHc9jnz76hru5jNfTi4wg846EB2copJrAr0Ogpskr4BAnCcMnYtMCtasPFaOQ5Aon3pYROwJXZ0krwoqGNQB8sxDG3Ho2+nUa9O3ufn3am/huQ3AhAWRW8dd47u/3ok37OANZh9JczWK3QsNoegemJ6brrKFUlXsRkAenQyTpiNNHjk6Y8HR8Slj24j6CeTkOAvlO1MWvil56/W78CMem0aRvED8ENm5cYkjZLMCsp8P1m9yEgSY/Ob7GAzxbjPx2ikv3wt3j6JVL1njtLZcpUNBytM94XExVTUByo1DTekqxpJrreUfjmcMYi2XrfWJFRhR9a4Z05JaR/nIM48ljwByS3vL5yvw4NO8Ki4/q3E8DWFBoSOONruXWC5e7GeJoe9RHIrWy619rePGkWVrBzOqchN9BomNAUEPiF8VTeR8mTY1MTRS0i8N2TaAtkgJRscastZPqWw5HaCutFmtMPtZnOm22bQ/dT9QBBcEXB4re59ujB/BJGfrcLFzSG7aEYtLaj5eC6xSvIDfEn0wrTkZxO/rSnlmxn9tL4zwc2cdfFFK/hvsnKzxMAWa+fm3LkjNZ+xmGmYNBV/metGZSJ0BFJAZVmgEceWNpzs70kzHYnzsfjhlKs9fTepaqPZ1DRfVrC9L92ksz0K+NSaTrisM/iQhJV2RqVIj9yPmfbgpqoyOE7pjzJ81u1dFePjD0cnO3wtQ7tymZVVlsuOI+ejncK2VvnfL3/X1K8Y5lVWSWfiWc67H0bpblO5ecso9/QsK9BZKeiusp2jdPIIlGQvfm+CeKZR9Fb00aTpm2bxyl7avpoMyolcpMXu5ntWy8oYK26EBuwCDO3PiMZJ4sY2ffOby1u8RBQyGN72MA2E5NAnhdfljvbi7
 QqSD68+1
 LMx2iNv8FJlTd3VwY0HT59nAGYfgnqDKecrvTnLDINMApgUXCtA00UE940AlS3CjoTOlqijuHw9yfkVnhF5kvjBfBO1t+WVgKi43mgn9exH7hO/0HSHH5uKPEJv2QFmeFWirnwc/c+gfyr20fCFqBm9FVaWVTQC1xvkBjKaRjKvkIceSg71FMfCVNsLxOM1gBi5U0qiEe97W+vtD4YuSifSUwzvGzSO3xJTNlnREbf3vUJwz4Qr4BUSBcOpHop/iaM8uravM0Z+on7GFBW/fjf6lwaqNos+c7GHIslRB+KEu7Oi+y2IFUIoY6u5c8O72L6ye6d6P5dvwQBtq8OIsexI/oMTN8tdoqO1hGE3V1cEtkNxtv9AHvVyERTcE0P36mWw7M+K7hE6+s5clBq+Q8crsKfY07ELIQOE3RatAQmiOAy41u08EG+sadbe8MqinGwjoSCP2Lo3DYar4pJPIraEwJTA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 16, 2025 at 12:27=E2=80=AFAM Lokesh Gidra <lokeshgidra@google.c=
om> wrote:
>
> On Fri, Aug 15, 2025 at 3:11=E2=80=AFAM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Fri, Aug 15, 2025 at 9:44=E2=80=AFPM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > On Thu, Aug 14, 2025 at 7:30=E2=80=AFAM Lokesh Gidra <lokeshgidra@goo=
gle.com> wrote:
> > > >
> > > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is requi=
red
> > > > for moving present pages. Mitigate this cost by opportunistically
> > > > batching present contiguous pages for TLB flushing.
> > > >
> > > > Without batching, in our testing on an arm64 Android device with UF=
FD GC,
> > > > which uses MOVE ioctl for compaction, we observed that out of the t=
otal
> > > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), =
and
> > > > ~20% in vm_normal_folio().
> > > >
> > > > With batching, the proportion of vm_normal_folio() increases to ove=
r
> > > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > > includes TLB-flush overhead.
> > > >
> > > > When the GC intensive benchmark, which was used to gather the above
> > > > numbers, is run on cuttlefish (qemu android instance on x86_64), th=
e
> > > > completion time of the benchmark went down from ~45mins to ~20mins.
> > > >
> > > > Furthermore, system_server, one of the most performance critical sy=
stem
> > > > processes on android, saw over 50% reduction in GC compaction time =
on an
> > > > arm64 android device.
> > > >
> > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > Cc: Kalesh Singh <kaleshsingh@google.com>
> > > > Cc: Barry Song <v-songbaohua@oppo.com>
> > > > Cc: David Hildenbrand <david@redhat.com>
> > > > Cc: Peter Xu <peterx@redhat.com>
> > > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > >
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> Thanks :-)
> > >
> > > [...]
> > > > +static long move_present_ptes(struct mm_struct *mm,
> > > > +                             struct vm_area_struct *dst_vma,
> > > > +                             struct vm_area_struct *src_vma,
> > > > +                             unsigned long dst_addr, unsigned long=
 src_addr,
> > > > +                             pte_t *dst_pte, pte_t *src_pte,
> > > > +                             pte_t orig_dst_pte, pte_t orig_src_pt=
e,
> > > > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > > +                             spinlock_t *dst_ptl, spinlock_t *src_=
ptl,
> > > > +                             struct folio **first_src_folio, unsig=
ned long len,
> > > > +                             struct anon_vma *src_anon_vma)
> > > > +{
> > > > +       int err =3D 0;
> > > > +       struct folio *src_folio =3D *first_src_folio;
> > > > +       unsigned long src_start =3D src_addr;
> > > > +       unsigned long src_end;
> > > > +
> > > > +       if (len > PAGE_SIZE) {
> > > > +               len =3D pmd_addr_end(dst_addr, dst_addr + len) - ds=
t_addr;
> > > > +               src_end =3D pmd_addr_end(src_addr, src_addr + len);
> > > > +       } else
> > > > +               src_end =3D src_addr + len;
> > >
> > > Nit:
> > >
> > > Look at Documentation/process/coding-style.rst.
> > >
> > > This does not apply if only one branch of a conditional statement is =
a single
> > > statement; in the latter case use braces in both branches:
> > >
> > > .. code-block:: c
> > >
> > >     if (condition) {
> > >         do_this();
> > >         do_that();
> > >     } else {
> > >         otherwise();
> > >     }
> Sorry for missing that. I can fix this in v6.
> > >
> > > By the way, what about the following for both cases? Would it impact
> > > performance in the `PAGE_SIZE` cases?
>
> I just wanted to avoid a bunch of instructions in two pmd_addr_end
> invocations for the (len =3D=3D PAGE_SIZE) case, which is not going to be
> uncommon. But I guess overall, it is not big enough to matter so can
> be removed.

Reducing the number of instructions doesn=E2=80=99t necessarily improve
performance=E2=80=94in fact, it can often have the opposite effect. It may =
lead
to increased branch mispredictions or make the code more memory-bound.
In this particular case, could branch misprediction be the real issue?

> > >
> > > len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
> > > src_end =3D pmd_addr_end(src_addr, src_addr + len);
> >
> > By the way, do src and dst always have the same offset within a
> > single PMD? I don=E2=80=99t think so. If not, how can we verify that if
> > src=E2=80=99s PMD is not overflowing, dst is safe as well?
> >
> > Have you only checked src? And for src, since you are already using
> > pmd_addr_end(), is src_end =3D src_addr + len fine? Why are you calling
> > pmd_addr_end twice after your first pmd_addr_end has already limited
> > the range?
>
> Effectively, we have to calculate min(len, extent in src pmd, extent
> in dst pmd). That's the max that can be batched within a single
> critical section of src_ptl and dst_ptl. The first pmd_addr_end() is
> calculating min(len, extent of dst pmd). The second pmd_addr_end() is
> calculating min(result of previous pmd_addr_end, extent of src pmd). I
> don't think I'm missing any overflow check. But please correct me if
> I'm mistaken.

You are right. I misunderstood your code yesterday.

Thanks
Barry

