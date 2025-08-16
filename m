Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90539CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 15:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 139CF6B0377; Sat, 16 Aug 2025 11:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA7A6B0375; Sat, 16 Aug 2025 11:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1B596B0376; Sat, 16 Aug 2025 11:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCB4F6B0374
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 11:00:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6FEF913858A
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 15:00:33 +0000 (UTC)
X-FDA: 83782931946.29.AF96D40
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 60E01160019
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 15:00:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pe05GzJ+;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755356431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vul7COE0io0WgsaBqJz6prHxr50hd7AzfA83m1brrv0=;
	b=q/vzrPpkPZZAhQcNHPwXu7L3kvhH6y00PQ7FJaMUklqhws9rUBGM2eTb/WUfEzaltpSt26
	3nekCPrAF0PwKNcL7geX8+m2WnjPeZ5QjqFrAMc5Q9c3ukkcB5JaXIYd7oDqLq0gua97Me
	673fu4KRWPN2yEOUWjYL3isn9q204W8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755356431; a=rsa-sha256;
	cv=none;
	b=zYQFCo2gMtmr0gRHibSABSGgN/psbVYwkEkldCILwm/3k7DzX6tGIcaNjiJFco5cKwFekW
	jH9keAAePpfflf08YiVzUrRZYwqXKq2NWZ33uN3fNNWIcd1begJZbRZX+OeruIwG2bma7a
	TRIJ6ygItGtFuRLHylhq39JfcI9nZ80=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pe05GzJ+;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-618076fd48bso4526a12.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755356430; x=1755961230; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vul7COE0io0WgsaBqJz6prHxr50hd7AzfA83m1brrv0=;
        b=pe05GzJ+xCbKPcpIWwjlrQKFkE67chKNF9TgeKOsqCFS6mYAVzKSAhRvVHaDcbfTs6
         Egn6jddRRmsxT4itZRY1WqwQ4FOMZl9fykd7xJo4wcgN/s8o30bOfrOUusplo2t+W9Up
         6jVx6EXN+/LTYNAticR6mIfY78DPl8IWownDuZOKkG/VWCm+fUzlmmD3ONvNSapiN5Us
         kyb17NwVkK+JpoWt+s/e8mBboJU1iTSTDIqJ70HIhmNYEjvnnYiEp+7+0uFKroNNz48N
         ufMjESFFK2J1ADgphATGl6vHKgqensFCGoK3TeBjaiSWNQkQLdNhaL0wqRxm3Wwgc72V
         9LjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755356430; x=1755961230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vul7COE0io0WgsaBqJz6prHxr50hd7AzfA83m1brrv0=;
        b=ANIXEjC++ZJCxM6sHSTCIrCEcf4/wU6xPJx+Y3ft24E7QiTXlZxsHMkvcGxxkIDs9H
         AFqIbaphc56+uCG233KsvxNSZ51um2LM6UBzIfF7UxohF5RZmx/hNeXS/jrR0RWaEeCx
         qNnjiCz9liYMyf69lkXEuOx/FTdPo4RIQWziJKbb7twqIk6/5Ncfa5vOaDkML1vgm742
         4Dww9Z6dwMOpyXs7XtQ8wHYn56JRDx+6WNhB4EdB+3qNCsfPxW4p3WbDiM/yhJTT31DL
         cdIAD2CN83teQ3O0itkwYTxgTX8o4+wweGc67cLWhZAMPa/Qes7N+BiYmSYBazZKsvMs
         qPuQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0aVwx4rbpqzsa1f5/GF3e6cV1CLbPQo3yQCMj+nIO6AwXaxECXTeJPyeOp5DSfpIN7mn7HG9HrQ==@kvack.org
X-Gm-Message-State: AOJu0YxaiX8W3ChQgicc/8jWMQAAzkXz9e4YRF3AfWoGAzSzedTga6dr
	kHOmw3Y3tW+sVQDJC2h2EykmLoRZ7OZlqP2Ea0oX/UtuPvWx2a3126EZo9gJmozyVH6kc+l459s
	8vgOykBnS3iZMgqLL1d2e+GNe+17tvTw5GDscZY10
X-Gm-Gg: ASbGncv8WwH9riAL1mS/ONvb+JYIMoO/x8h1s9DKHI+P3Xd6m30IKBaWk8AKhSW8sBo
	pFSJ9U+SaaT128Xuyk90aXQv6yJ6KGiHmAQ+ez6tBX1h8sfXKM7xuHRKMgNVNDXf1dlQBx5tZ5I
	BsDYhVcJROySPUxmz2nbvJeBG2kkAa5H0D04vwuuneEF533vHwy2AGx2VmQkDkR7pey1WrLSfV5
	9nOBTaeroIPBTq6hT4C8agfbwJHsNfmv/f/Ibocs+L61aJPX7QzPjSh
X-Google-Smtp-Source: AGHT+IEBzRezYSYENEGQB4vdaRuKAx6mnqwYgnJlL+f4GN/mn8+qaw7DmjcIAZ19UuK4URTXsDvO8Pn1rKjDF7g3rts=
X-Received: by 2002:a50:a688:0:b0:618:8373:30f0 with SMTP id
 4fb4d7f45d1cf-61989f4aabdmr42872a12.2.1755356429386; Sat, 16 Aug 2025
 08:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com>
 <CAGsJ_4w5bAJHyBrwb5+n_EANqzhz4cFSX+9yZacmOiXVJZ_Dkw@mail.gmail.com>
 <CAGsJ_4wt_30C82B9_ZoOB2umBi-u_kE441ARvYoJVjkLtLqFCg@mail.gmail.com>
 <CA+EESO4NfgT6uAP52eQEt4_cx7KPdHv4MxnSw_UwHVSurime8w@mail.gmail.com> <CAGsJ_4wwHMDocUjg=PBGafWYXmyDdbuDOi8kB3Xm2Q=J3VpCbQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4wwHMDocUjg=PBGafWYXmyDdbuDOi8kB3Xm2Q=J3VpCbQ@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Sat, 16 Aug 2025 08:00:15 -0700
X-Gm-Features: Ac12FXzNg6vh5n_QlZ8x6Ax4Y-ZniX5_i1umDqlfb7dKVuW-D5hNIsKUXldoccI
Message-ID: <CA+EESO7cO7WBPvrrC2BqHqT0sg4k4J60c7bQtN-T68kJCWC0Yg@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 60E01160019
X-Stat-Signature: y9b1ibhz93f6k6c76kneay343a6yuq5p
X-Rspam-User: 
X-HE-Tag: 1755356431-954983
X-HE-Meta: U2FsdGVkX19azVU17rDlpytlULZktntfFe7SVTlDduH0MarWyQOWeDvG+xpeIfSls72a8v1vW4qfzzXPdX8hAj5u9crzH/ZsSiFJlVo7vqWa8LEAKr8T7oo9W/5i4Z1EmURL7nzbFakF7f7PGvetI3N69G35Wqn286AFOHRanvL1GsB21S+icIVG23/jiqfHGxpLyDEleYOtAO0zwN1D1spxfJXrGhi41f0TDvkgBdWpf+Q2q5seoLD1plabJ2+UxVHnLShsSDBMNTF4QldVCQW+xqmyfRC51qaD/1OiuRYEG46TQYZv0fBi+o0RWs1MYLlDgOqlxbRF34pd2JyJihI70xatnz9GDg0s3YihbV/+qlAdwqYTBtfrPUPuZk7tfe2YzXF0kvodGvuLtxoixqnCJkswSf5UHMAqbotbpYa0Rl4HA72UP56pZxLYNPd61z169OmYeqPjUKEZU2Pr4Zy+Fagu0FNh2cN6FSitij+UjtXMDtrmJz3Y9jRp44jwumRBhAzOY/78py6QBvf5Toqhr6VSqWp+xJgMn/iuH169ggI/iKJVOTKYmMdAtN/G2ES9///Lmn2RjFIjViSpfmy5y3TfLYwGQc2soF0yAmyajGgia6Eg4VnT3oRORe6PmpzLFe8l0+MdKOQDhS69X4rRNYEcWtfEnCiBrFmtFW+PLJvIMdRdu4ghk9xtyYAbo6WvvVoOXXchUc0qHY3IEFfKJLRdVSutQWdtSEnu8lYT8jU4hU/2XmNzKkJ5NyrhZzibcemvaf/3TZ2HLeyYzZIjgs3DomSJJ+14qmmGCSihdgu3Cf/2oC832sPbkJFbBl/pc3QiqkT7Jxdh0/Ki+j4p1I4GxAG5h7nmo+19OqDSGLkV3+bPApsSGuT7LMcEA+f45ORhpblhBGQJjp8KtyUDiCafqLoagnBl57kTjUpg2mP+TbLDaQI8QgriDoH9hXsO8bJ5mLPFbeNTael
 7ML2sbcV
 rvWAobuEmT2jONa2HK3yaJZ9bGQY2pD88/T6Z0rdQyoc9JfnbIA+FcXSBNBHdijteS1tnAIMPNhAeN5oEq/5MsnpzywwOJW0fZjTp0aczSvxpx1k13YTPLi9h7b7u6U6nhZcHgYkwli+4fIMKMBkKz9AeyvRO+9opPjWy8gJRBhD8lVnzOwCa10xbOPmSLp7dFURoRu33v0V+U8O6t2RWUUWW9c0Bzv974QHdhbwlCaC8hHTm0vNsWuFkOHpbjFqFuQXIbAs7xm44w/j2H7ipqa/VFxn0sIz9zNo84gxPh0gPKC9tCY8Qfjk2dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 11:38=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> On Sat, Aug 16, 2025 at 12:27=E2=80=AFAM Lokesh Gidra <lokeshgidra@google=
.com> wrote:
> >
> > On Fri, Aug 15, 2025 at 3:11=E2=80=AFAM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > On Fri, Aug 15, 2025 at 9:44=E2=80=AFPM Barry Song <21cnbao@gmail.com=
> wrote:
> > > >
> > > > On Thu, Aug 14, 2025 at 7:30=E2=80=AFAM Lokesh Gidra <lokeshgidra@g=
oogle.com> wrote:
> > > > >
> > > > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is req=
uired
> > > > > for moving present pages. Mitigate this cost by opportunistically
> > > > > batching present contiguous pages for TLB flushing.
> > > > >
> > > > > Without batching, in our testing on an arm64 Android device with =
UFFD GC,
> > > > > which uses MOVE ioctl for compaction, we observed that out of the=
 total
> > > > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush()=
, and
> > > > > ~20% in vm_normal_folio().
> > > > >
> > > > > With batching, the proportion of vm_normal_folio() increases to o=
ver
> > > > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > > > > Furthermore, time spent within move_pages_pte() is only ~20%, whi=
ch
> > > > > includes TLB-flush overhead.
> > > > >
> > > > > When the GC intensive benchmark, which was used to gather the abo=
ve
> > > > > numbers, is run on cuttlefish (qemu android instance on x86_64), =
the
> > > > > completion time of the benchmark went down from ~45mins to ~20min=
s.
> > > > >
> > > > > Furthermore, system_server, one of the most performance critical =
system
> > > > > processes on android, saw over 50% reduction in GC compaction tim=
e on an
> > > > > arm64 android device.
> > > > >
> > > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > > Cc: Kalesh Singh <kaleshsingh@google.com>
> > > > > Cc: Barry Song <v-songbaohua@oppo.com>
> > > > > Cc: David Hildenbrand <david@redhat.com>
> > > > > Cc: Peter Xu <peterx@redhat.com>
> > > > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> > > >
> > > > Reviewed-by: Barry Song <baohua@kernel.org>
> > Thanks :-)
> > > >
> > > > [...]
> > > > > +static long move_present_ptes(struct mm_struct *mm,
> > > > > +                             struct vm_area_struct *dst_vma,
> > > > > +                             struct vm_area_struct *src_vma,
> > > > > +                             unsigned long dst_addr, unsigned lo=
ng src_addr,
> > > > > +                             pte_t *dst_pte, pte_t *src_pte,
> > > > > +                             pte_t orig_dst_pte, pte_t orig_src_=
pte,
> > > > > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > > > +                             spinlock_t *dst_ptl, spinlock_t *sr=
c_ptl,
> > > > > +                             struct folio **first_src_folio, uns=
igned long len,
> > > > > +                             struct anon_vma *src_anon_vma)
> > > > > +{
> > > > > +       int err =3D 0;
> > > > > +       struct folio *src_folio =3D *first_src_folio;
> > > > > +       unsigned long src_start =3D src_addr;
> > > > > +       unsigned long src_end;
> > > > > +
> > > > > +       if (len > PAGE_SIZE) {
> > > > > +               len =3D pmd_addr_end(dst_addr, dst_addr + len) - =
dst_addr;
> > > > > +               src_end =3D pmd_addr_end(src_addr, src_addr + len=
);
> > > > > +       } else
> > > > > +               src_end =3D src_addr + len;
> > > >
> > > > Nit:
> > > >
> > > > Look at Documentation/process/coding-style.rst.
> > > >
> > > > This does not apply if only one branch of a conditional statement i=
s a single
> > > > statement; in the latter case use braces in both branches:
> > > >
> > > > .. code-block:: c
> > > >
> > > >     if (condition) {
> > > >         do_this();
> > > >         do_that();
> > > >     } else {
> > > >         otherwise();
> > > >     }
> > Sorry for missing that. I can fix this in v6.
> > > >
> > > > By the way, what about the following for both cases? Would it impac=
t
> > > > performance in the `PAGE_SIZE` cases?
> >
> > I just wanted to avoid a bunch of instructions in two pmd_addr_end
> > invocations for the (len =3D=3D PAGE_SIZE) case, which is not going to =
be
> > uncommon. But I guess overall, it is not big enough to matter so can
> > be removed.
>
> Reducing the number of instructions doesn=E2=80=99t necessarily improve
> performance=E2=80=94in fact, it can often have the opposite effect. It ma=
y lead
> to increased branch mispredictions or make the code more memory-bound.
> In this particular case, could branch misprediction be the real issue?
>
That's true. I didn't even consider branch misprediction. I will
upload v6 which removes the condition, thereby also fixing the nit.
> > > >
> > > > len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
> > > > src_end =3D pmd_addr_end(src_addr, src_addr + len);
> > >
> > > By the way, do src and dst always have the same offset within a
> > > single PMD? I don=E2=80=99t think so. If not, how can we verify that =
if
> > > src=E2=80=99s PMD is not overflowing, dst is safe as well?
> > >
> > > Have you only checked src? And for src, since you are already using
> > > pmd_addr_end(), is src_end =3D src_addr + len fine? Why are you calli=
ng
> > > pmd_addr_end twice after your first pmd_addr_end has already limited
> > > the range?
> >
> > Effectively, we have to calculate min(len, extent in src pmd, extent
> > in dst pmd). That's the max that can be batched within a single
> > critical section of src_ptl and dst_ptl. The first pmd_addr_end() is
> > calculating min(len, extent of dst pmd). The second pmd_addr_end() is
> > calculating min(result of previous pmd_addr_end, extent of src pmd). I
> > don't think I'm missing any overflow check. But please correct me if
> > I'm mistaken.
>
> You are right. I misunderstood your code yesterday.
>
> Thanks
> Barry

