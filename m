Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FD30CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 16:27:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F382900259; Fri, 15 Aug 2025 12:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB18900256; Fri, 15 Aug 2025 12:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 007AE900259; Fri, 15 Aug 2025 12:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E1440900256
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 12:27:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 718C71DAB41
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:27:32 +0000 (UTC)
X-FDA: 83779522344.15.709A185
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7ABBF40008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:27:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KvaWzTWN;
	spf=pass (imf01.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755275250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7b8oxrc7pOHrKPjGkqyzBZ/G/DZJKdV/+bSxMfPUC8=;
	b=1d/1UY8+FMPCHZf9AvwJtuDwhZuj2+zLPBns99TUcL1/hQwt6qhnSnnbqqOlVGcTqEVDtP
	usvWUwnESjlD2Kjmbm4IRKrv2P444nKwVrbO8/wKNid3muBROENGYYLnzpny0aPTaz5TvI
	zrZ+ygBHg+IasH+hMe+SX++rEERbtvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755275250; a=rsa-sha256;
	cv=none;
	b=yRuQMbeW5Ey7j+cZ5V6ITVIQMlIEXiDhFLFvZWAVe3x6BTJ61AcI2+XtKkYal+eTxOReLu
	Fdizh4mUg7micMJZDa1G6xKfJtNyn+3KqqGQvnQ0x+7DrvehtJchICrJ3jAe1Yjdxgs5f8
	Bx0NFMlDqgyDO6g2Cn7lRGRhNfuNuhk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KvaWzTWN;
	spf=pass (imf01.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=lokeshgidra@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-617ff2c8e5dso3a12.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 09:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755275249; x=1755880049; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7b8oxrc7pOHrKPjGkqyzBZ/G/DZJKdV/+bSxMfPUC8=;
        b=KvaWzTWNYnLuE857vHyUQ4VUgPgDmfhyVgbNiCloqtVPojUCgKOfNNQFdOpbdrIG3l
         wpXZ9x/ZdMQ0WGipvgFKJC1xUs5NA2HFP2fCG2NVv8DqP2Rr40ZHFhDSHVyqtUGmBeE3
         b6Z3QR+NEsd6QUksR8KJljLV5Rx/bf8AGmhLzrSJx5ySi7kRrYqcum7aoQ1su411pWOA
         55CBERsXFFpojnbrxaGKJ8xAmMgsOeY3gjxugL4SUoXjZSVlx9/crtLFj7REWCA3BtGG
         sUu3fm0taeLpwbB8FbnYK/A3dkAIN9TjpVXDVVpzLzJQPf7oXwfwDhedJzDEOOsmoX2i
         bHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755275249; x=1755880049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e7b8oxrc7pOHrKPjGkqyzBZ/G/DZJKdV/+bSxMfPUC8=;
        b=BOpGJ8HWNYQvr091T4iaO9AzCRwmrUWQOgpKw+0UkyRU9WWYDDQ8JLpAQ/45bK4kxS
         Ceau2hn907n1VemmYVnEnm7NBS23ODcJeOSe7Y3zBAtEBsD8/s8MF9gRrE/pX2b33WCj
         STqKrIwSo22pQtkM8CVrdN+YJCWQqp0MdMnsHU5Xi5a8UOaPTXHyL+1sOr5i+yD4qbus
         Zl1yKHjKwcDhvWRgtyE5uVTvYi/ZMaYAKpDzTtATQlgcRu8lM02You6Xc2sXHai4wLZT
         inztKoX/nK7wnvheXMc80D8b+tFij4ca2XaH5yhPMjswm7ato69bnpKqh34zkNhQQIr8
         Pccw==
X-Forwarded-Encrypted: i=1; AJvYcCVEjlYRIajX/Zq0QvgC20hdYIMN+aEA4nLWJdnF+EItajhva82uaG1X+RdCotwEeW6P13po5XWRrA==@kvack.org
X-Gm-Message-State: AOJu0YyAOMWTaiKRwIf+ZS2ItMkWCGWGEtwc8EBUK8DU8AnL7lLDJk+2
	+kNIZe7dl+08jCOfQE3sBHTC0upXxyWIhnZowoDkfJNlxyBdNB3Jqa8HLwu+lcbVIZIiLSqYm97
	47Nx9cbXrpF/AwJXgExUQmOsycpfW3t+7oDL+R3CQ
X-Gm-Gg: ASbGncs7HlpJy4Rbc1LuJBHf7uY5djCWl98bhPIw13rF0PHaRk6yOH4Tr/zub6zLPmX
	ydGtWmJWPd3zr7CBV5wFs6hykMuL8wCv8q7mi0Oc5gzonN2woI7YHgL3TidxNmdw35WYRaJg56Y
	zZHJmsKGdrjLhmyMBuapj3obKve5UX0i2rRLWtxOWnjCVGIJVRojVk7G4T28YVMGuDZM9QC9/qz
	QArFBPmvJLXkQ==
X-Google-Smtp-Source: AGHT+IGglLepco85oIjAKOpjvDulhB+bg499plT62J5lYXGvf1ludelKLG9gV9n6ae1Z1Lh/JDlQbxUAZ3kI0RpZVew=
X-Received: by 2002:a05:6402:5052:b0:618:249e:e59a with SMTP id
 4fb4d7f45d1cf-618aa4426b5mr115146a12.0.1755275248660; Fri, 15 Aug 2025
 09:27:28 -0700 (PDT)
MIME-Version: 1.0
References: <20250813193024.2279805-1-lokeshgidra@google.com>
 <CAGsJ_4w5bAJHyBrwb5+n_EANqzhz4cFSX+9yZacmOiXVJZ_Dkw@mail.gmail.com> <CAGsJ_4wt_30C82B9_ZoOB2umBi-u_kE441ARvYoJVjkLtLqFCg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wt_30C82B9_ZoOB2umBi-u_kE441ARvYoJVjkLtLqFCg@mail.gmail.com>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Fri, 15 Aug 2025 09:27:17 -0700
X-Gm-Features: Ac12FXzspbKZzAHgIU34G4BfMeoX9CgHPYdykS2bYhWXn8D1iiAdjQDY8h8woSk
Message-ID: <CA+EESO4NfgT6uAP52eQEt4_cx7KPdHv4MxnSw_UwHVSurime8w@mail.gmail.com>
Subject: Re: [PATCH v5] userfaultfd: opportunistic TLB-flush batching for
 present pages in MOVE
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ngeoffray@google.com, 
	Suren Baghdasaryan <surenb@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, David Hildenbrand <david@redhat.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7ABBF40008
X-Stat-Signature: ikihk95bofims3pokg9bodtjajat14ka
X-HE-Tag: 1755275250-579893
X-HE-Meta: U2FsdGVkX19Hl1XPSr6sGy9hF49mdtF8Fc2VcfJCwbAyuywm7DjCB+AWaR1sfciWKaE5ph2y/CJOnpwodT3jh+eEo7lGNfzNXJPcSxd079IN+qOVhtn7PpPkwEzIA4njfvv+DC2YdAWa32CmodyB9beHKKG3CTHSrc+1hr1AyMBpmu8GAx+CCd9UtJP+rv+z+hD2aFE8IetGAPC/wsfzIrVbhJ9GZe2uTerVIbMK1tM9O7Frncxrub83L9bgFJijlQppE4lAsGWvRcTKgpSxG8pLhco+Yg1vIe4PpJhKAKYsjtjl814pGp7RuI5Gsv6i1eDvpD5Ms0waXfRRbXFYiGazWKJfMS0IoJQzJ0KW99h/dVWaInris8+foTUO/vseneCO8n7+LQaC7zgTQesdg2oHQ4ZBeouRQhrSguRHri59xhQOE9wJ583PGxdTAzIMPs77FixXspSd0ChdIWH5SojAEvxotq8+vl5Hl4fJTEP6IEhOvaqpOAphB9EEbw6xwnYg6qlAh8GutzpzXUHhf1ikFE6s8KLTh/GglY1C60iGagJyxjLPzY0n5lDP1YW8LJYzCRH6Ser1MsWlbTH4Q8OrhCQgIbhzVB8tugv9mGpl63OoCDxVX3KoMp8upikLGhqoTiKhylgQ6KsKagH8ffGSDKTRFu+tx8QgUGaX0hJRa6CfNrT1kCdl35kgzCfuLA0Fcw+GMcd4gLcVyGMJHNX41/7pMdJV1oIBuYbQ1CclB8/ZuIOHa1T+fBLLcnSOA2+Y82GTBHC2HnhpVVC3kroBH4dJleo3vA1uSP6iZuGAcxvapsfIgx1pPTAfnCWnJYw9OBkQGHpHJe4qYzbtoFypcR7a5QC0zcHsMQbr26gD3NWPyGnGA5ERzcjNq9PXNXJzTCDEwo/tSoTWfM0kSpj39+wcAZ44dxZV//5fQCK+VUekpAxiKGFKhCfEo72p90j/4VPPgXhh5wS3mPD
 Zn9X+iTk
 GR4YRCY8ekRu17uzPmIuCY+Z1vavkYdGagaKrA0th4luAtYgQQD63F5gHLR5tWl1lCX6eBS0qev+bKVY3caUU08DHDDF5MwL4/icmxGwqpOWl8k6od3LR/B6tdYk52SLpFIElZKOXkHTzQBkY2mw2kszANjnZuJjvjdzFNH1ENNaJRtXLMcNNqP9jjwPfGfBqIpWfa8B9tU57XJSN1s3i7x0a71ci9a3vLnx5qNLdg2W6h+wqQCwlVk/ibbW6szW2/DWIEkkmDOeevoqNNtrd55HchNMjJe36kH8M6y57FqDrLImVuQkmHKWxRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 3:11=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Fri, Aug 15, 2025 at 9:44=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Thu, Aug 14, 2025 at 7:30=E2=80=AFAM Lokesh Gidra <lokeshgidra@googl=
e.com> wrote:
> > >
> > > MOVE ioctl's runtime is dominated by TLB-flush cost, which is require=
d
> > > for moving present pages. Mitigate this cost by opportunistically
> > > batching present contiguous pages for TLB flushing.
> > >
> > > Without batching, in our testing on an arm64 Android device with UFFD=
 GC,
> > > which uses MOVE ioctl for compaction, we observed that out of the tot=
al
> > > time spent in move_pages_pte(), over 40% is in ptep_clear_flush(), an=
d
> > > ~20% in vm_normal_folio().
> > >
> > > With batching, the proportion of vm_normal_folio() increases to over
> > > 70% of move_pages_pte() without any changes to vm_normal_folio().
> > > Furthermore, time spent within move_pages_pte() is only ~20%, which
> > > includes TLB-flush overhead.
> > >
> > > When the GC intensive benchmark, which was used to gather the above
> > > numbers, is run on cuttlefish (qemu android instance on x86_64), the
> > > completion time of the benchmark went down from ~45mins to ~20mins.
> > >
> > > Furthermore, system_server, one of the most performance critical syst=
em
> > > processes on android, saw over 50% reduction in GC compaction time on=
 an
> > > arm64 android device.
> > >
> > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > Cc: Kalesh Singh <kaleshsingh@google.com>
> > > Cc: Barry Song <v-songbaohua@oppo.com>
> > > Cc: David Hildenbrand <david@redhat.com>
> > > Cc: Peter Xu <peterx@redhat.com>
> > > Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> >
> > Reviewed-by: Barry Song <baohua@kernel.org>
Thanks :-)
> >
> > [...]
> > > +static long move_present_ptes(struct mm_struct *mm,
> > > +                             struct vm_area_struct *dst_vma,
> > > +                             struct vm_area_struct *src_vma,
> > > +                             unsigned long dst_addr, unsigned long s=
rc_addr,
> > > +                             pte_t *dst_pte, pte_t *src_pte,
> > > +                             pte_t orig_dst_pte, pte_t orig_src_pte,
> > > +                             pmd_t *dst_pmd, pmd_t dst_pmdval,
> > > +                             spinlock_t *dst_ptl, spinlock_t *src_pt=
l,
> > > +                             struct folio **first_src_folio, unsigne=
d long len,
> > > +                             struct anon_vma *src_anon_vma)
> > > +{
> > > +       int err =3D 0;
> > > +       struct folio *src_folio =3D *first_src_folio;
> > > +       unsigned long src_start =3D src_addr;
> > > +       unsigned long src_end;
> > > +
> > > +       if (len > PAGE_SIZE) {
> > > +               len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_=
addr;
> > > +               src_end =3D pmd_addr_end(src_addr, src_addr + len);
> > > +       } else
> > > +               src_end =3D src_addr + len;
> >
> > Nit:
> >
> > Look at Documentation/process/coding-style.rst.
> >
> > This does not apply if only one branch of a conditional statement is a =
single
> > statement; in the latter case use braces in both branches:
> >
> > .. code-block:: c
> >
> >     if (condition) {
> >         do_this();
> >         do_that();
> >     } else {
> >         otherwise();
> >     }
Sorry for missing that. I can fix this in v6.
> >
> > By the way, what about the following for both cases? Would it impact
> > performance in the `PAGE_SIZE` cases?

I just wanted to avoid a bunch of instructions in two pmd_addr_end
invocations for the (len =3D=3D PAGE_SIZE) case, which is not going to be
uncommon. But I guess overall, it is not big enough to matter so can
be removed.
> >
> > len =3D pmd_addr_end(dst_addr, dst_addr + len) - dst_addr;
> > src_end =3D pmd_addr_end(src_addr, src_addr + len);
>
> By the way, do src and dst always have the same offset within a
> single PMD? I don=E2=80=99t think so. If not, how can we verify that if
> src=E2=80=99s PMD is not overflowing, dst is safe as well?
>
> Have you only checked src? And for src, since you are already using
> pmd_addr_end(), is src_end =3D src_addr + len fine? Why are you calling
> pmd_addr_end twice after your first pmd_addr_end has already limited
> the range?

Effectively, we have to calculate min(len, extent in src pmd, extent
in dst pmd). That's the max that can be batched within a single
critical section of src_ptl and dst_ptl. The first pmd_addr_end() is
calculating min(len, extent of dst pmd). The second pmd_addr_end() is
calculating min(result of previous pmd_addr_end, extent of src pmd). I
don't think I'm missing any overflow check. But please correct me if
I'm mistaken.
>
> Thanks
> Barry

