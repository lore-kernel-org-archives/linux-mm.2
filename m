Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37649CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9124F80191; Tue, 28 Oct 2025 13:26:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C32E8013F; Tue, 28 Oct 2025 13:26:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8004780191; Tue, 28 Oct 2025 13:26:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9D58013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:26:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 370D150449
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:26:12 +0000 (UTC)
X-FDA: 84048201384.01.F0159BC
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4A0DE140003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:26:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4dCBXDYn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761672370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JfkiUG6+iw2UhSy31dGJmvgvAekk/kMSwRwnJkf7r0s=;
	b=SAebQX39AxJZdSlVEl5BDrm1s7tIjUje9Cov2KqjQ35+2OULWuy5YIlDY9MAHQ+QQWsJ4H
	4pPilV4gzGxHCT5e/TV0rFps29renzzMiK2mlUOUU804w1IsoM4dasAY5H/cLFSwOFE4Qa
	rJnkXM09Scuvrz9TrYQtger86nrJFNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761672370; a=rsa-sha256;
	cv=none;
	b=4zgFsaqe6UNfyZQswDKKZGnclE3vDeHujJ2oSIsQRaQGLVEGjDOfdeMwLAkFtuJul6B4cu
	UpE08U0yoM0ZpyTGbKJJnBLXswmhv3OvhLcRVy3BOiYIDnYCtQvqtYZ3LSs0bMxRYLj+9G
	im5BDEn/O1FZA5rWyYMbIyG4eeQP8Ac=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4dCBXDYn;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso24581cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761672369; x=1762277169; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JfkiUG6+iw2UhSy31dGJmvgvAekk/kMSwRwnJkf7r0s=;
        b=4dCBXDYnlclCas0X3NQfR7YTg/Lo/zCFwnPdAZqoRPY9+236foqcXMGQ3hrsIC6/1C
         Frou40NDGvn1HCRzrlhXUO57tYyOTlhzN1NQ9ZOMfG+UdQvXJ1XFqy8RHIH2o9QtbZcA
         XrPP4aGolYxDf089ZmcfLH7gDvo6uIGAFPDqix6BYxOHLdgm2kQOjDAr/nVJeF74YxHP
         eUhCmEOwHkb1XvFkgDJ+J2hK+uiEWgqhlWK/TzPNR654Be+tVnVTiCyTqZusKmieXOlW
         UcrgsenIslKpYSVQfyjapW2OyvXQ4wyN8K6Vjk1Hne6IEQDtojFpkvc5tvpaY5WghGzy
         gkJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761672369; x=1762277169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JfkiUG6+iw2UhSy31dGJmvgvAekk/kMSwRwnJkf7r0s=;
        b=lspx1oy9U7TBaxaF0eu6t95og9ucNV28VliKq4c+au/nxpAk4ACxggVjc/fWBJ2GlQ
         yGDyl9Tiv4SdZ62Qavnm3nzXnDDXEbmHNmdMiuRJxpIcVE5+7u+sbfgXswV+3PqM/YPR
         OnNWwjz4d8L9Z3KM82eDb+Kx7Db7T6SXKlslbBOGu9+G4WjcNor0PZoiD6Fm4BC4UMMg
         RPXUvrb2bqEVBv8JmpJCshMrU9lrZfySYMWPGssVsouvYfzJHTNPhhI41R8F6sFGIklv
         xEuPxHbFW1EMLAFU34UlMnAH3ZlWG3CSIqZAxzMUi2b2/FJFEQP/V4dtff40PFUbP4qj
         q3rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL/U+xaglZCca+krB3S11cCleCNYydp8JxsbB1W9WUqjd7NBTWzixo/y/0n3RlZHdYZX62F16Dag==@kvack.org
X-Gm-Message-State: AOJu0YwtZdFJpxwQNUscQJ/j9xATuJkBB+5jIULNB1SdFZtJ/IN+fIXE
	QEW7x8eypCg1FoD6LVV4uYx4M4vwCR7CgS/2XA+NQvF+Hvl2dGVOI1LpMoBRUFjqL7I9Wv5R95R
	VoVuC2JftbcuubexcGHt80nBRu4ZhHszTWC12pp46
X-Gm-Gg: ASbGncs5wqOnim4iU2XyBXhsv2mKc+t++x7terpMEz6QKDrSpQBny3aVluP1K/K4KAx
	hPqr5/t00xzOrKYrI9W2LNgaI+A8GqN3UbxNsFUHtLnk9M8ArjIgffxKkmjJOHypZg2e7NQKECO
	WHsLEE8NyhlMCqmiYF8xMouhcFoUT0pGWB7XgcPqSw/tdXXhYuQ53QycW8V2r9OpPgknvmcpOht
	5bbALpavOsWjfRa2fee9ur+eWzBQBLLPHHCQYy80RpwtTBVfMips3OPa4ILL3ps7iF48LnRslF7
	eG0VIE1DViyA5pgGkoH5Mw3LDg==
X-Google-Smtp-Source: AGHT+IHzoBJIe4jVodZbEvla5R7rampjy3ci2pHKZPMRnGU0o5gKAx9pVCoQf6YY6ezuy6hJhcna9HUVRGij/ntiFOc=
X-Received: by 2002:a05:622a:110c:b0:4e6:eaea:af3f with SMTP id
 d75a77b69052e-4ed1593dc59mr156611cf.3.1761672368890; Tue, 28 Oct 2025
 10:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-3-harry.yoo@oracle.com>
 <CAJuCfpGo=m9vdRQCqa-2MtAb9GBNsF4+6YXm7vzGFYtqsOzq1A@mail.gmail.com>
In-Reply-To: <CAJuCfpGo=m9vdRQCqa-2MtAb9GBNsF4+6YXm7vzGFYtqsOzq1A@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 10:25:57 -0700
X-Gm-Features: AWmQ_bmKilFBM39l_iVIomcjoYMaO1avK7j0mImfETowwXOoO4uxKbRGQDyfLKQ
Message-ID: <CAJuCfpHKWx2HO0cdrynxNe+PYBFnqZ91vDiezrewk=LnKBReMg@mail.gmail.com>
Subject: Re: [RFC PATCH V3 2/7] ext4: specify the free pointer offset for ext4_inode_cache
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: t8x1wpxh6hrsbqopkyy3ue3caamn7ww9
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A0DE140003
X-HE-Tag: 1761672370-141500
X-HE-Meta: U2FsdGVkX1+dNrMaJYVt1XLWvL1+6LwEHI3oOOPHiZDI3L3+A1Lrde9N5W1d21ov9+ujUG16cXY+gK1VVjJcXqAgiDLguiqTWNv6kFjFv6Sn2xwQSw+4LYGbhggCXRhjCc/oFvasjbaBgjzZqjBh9v5WstXYzRd8sBUvWNrQCY15YFZozFrJKytlq84zDcFQEZXNuB4rxyaOaegNFff/TJJDDN10V+AhL1mWkNalLa2ZCCYX4bMPVomx04et9VxKbV74k+5LeL06y49AD4T9Uaa1yqfT7ib48R87/0RB6h8guIqBLdQBku4BEtQ8hvDZjZpFOig8N+hJz+UPvRSgyGTA0sJxlE6SxATtMybGMIIV3tO3LV8qusuMAOzWyc7SrvzUBWkxaKkdTn7NYB1dTIAsOlgIMXc4xIRXqldtna87wEmqXclfNLrnWVX0nsWZ7teLH3GbWIrt1qpnTCnBnWVO8Nc6LNARvtjYoHyrkNv7JxdyE0y7SjDt8Wc8sJt6SZuMXzgmID2dJxAyzXcmxV+70FnNWQAhBVNZ4J805XyyD9G3FvJtGmUGQ2QpqOViTpPmKflAN9F43xCHWSCQQBuR6lo4+JcFB0Dydb4lwqkVgCFzfH8lugJ0Tp0eLNojr/0En6pJ5mmKq6BYVOzRQerX8+ANMM0E+E6giDjSsCAU9MsQTU7aOtpu+6qrzSnbD64twm73Q3rPuIcVk7K9hdsiJOVe9eFa1XCQqDqlYA5ZSpk0TTM6fvOpYhsdN+UF/w5HQ2P49IYQx4f97Rm9snqsjzhZPWlsjCLomhLXlEN2Bo++jv1yGDoG490iE7MgBhz/hr5R3MdMNlWJ0oyOLkegf/QKzrW2EPaIGmXQFPUGpV68obmrwgiGNWuOfm8GIKp1VyahXg3oYal6xgCnWNbPG+/c83cfnHH9HpVnkf+pdCOnbtZ0SZRow7cqkNu7VvU0Z1qAypH1cM0uY+P
 J8EnZIlK
 enLFz9wmx0tM/75w9Jfp6MWDWh7+HjHWlH5SCROozmhoTgofGbXk1KzvnKI7HrR4E9LzdK20dOf08oSvQeSwAzB6Mxt/jG+wZV3q2oTcfx0a8soPwMKjAXOufyWCSsCO4DUYZv3V5ar9rrQh0w4o70WZ7P6oXcdm5wds9DgfSlwJEtNAyDEadlpVq76HkdX/utcJ52bMwVNptmOC5TdW75TjzPOTP7gRYVBN6sYjzW5R8FH+5e/Q29o7K1ILT+1yeFx6DvaOltgXzDZNIP4qiyj4DHVbTWuEX945NxF3zgJbCeahjjpHH3zKMuM/sQlI6mgGr5rB2ZVywzjri+YPI1gZT2xNf042KC30cyh+z+5O6bPuiQeBOKZbEEi5BFILmtTluLuYcSDWqhIsP/5l9/jhy3RsoC02G9fD1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 10:22=E2=80=AFAM Suren Baghdasaryan <surenb@google.=
com> wrote:
>
> On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> =
wrote:
> >
> > Convert ext4_inode_cache to use the kmem_cache_args interface and
> > specify a free pointer offset.
> >
> > Since ext4_inode_cache uses a constructor, the free pointer would be
> > placed after the object to overwriting fields used by the constructor.
> > However, some fields such as ->i_flags are not used by the constructor
> > and can safely be repurposed for the free pointer.
> >
> > Specify the free pointer offset at i_flags to reduce the object size.
> >
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  fs/ext4/super.c | 20 ++++++++++++++------
> >  1 file changed, 14 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> > index 699c15db28a8..2860e0ee913f 100644
> > --- a/fs/ext4/super.c
> > +++ b/fs/ext4/super.c
> > @@ -1474,12 +1474,20 @@ static void init_once(void *foo)
> >
> >  static int __init init_inodecache(void)
> >  {
> > -       ext4_inode_cachep =3D kmem_cache_create_usercopy("ext4_inode_ca=
che",
> > -                               sizeof(struct ext4_inode_info), 0,
> > -                               SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT,
> > -                               offsetof(struct ext4_inode_info, i_data=
),
> > -                               sizeof_field(struct ext4_inode_info, i_=
data),
> > -                               init_once);
> > +       struct kmem_cache_args args =3D {
> > +               .align =3D 0,
> > +               .useroffset =3D offsetof(struct ext4_inode_info, i_data=
),
> > +               .usersize =3D sizeof_field(struct ext4_inode_info, i_da=
ta),
> > +               .use_freeptr_offset =3D true,
> > +               .freeptr_offset =3D offsetof(struct ext4_inode_info, i_=
flags),
>
> Hi Harry,
> AFAIK freeptr_offset can be used only with SLAB_TYPESAFE_BY_RCU caches
> (see https://elixir.bootlin.com/linux/v6.18-rc3/source/include/linux/slab=
.h#L302)
> and check at https://elixir.bootlin.com/linux/v6.18-rc3/source/mm/slab_co=
mmon.c#L234
> should fail otherwise. The cache you are changing does not seem to
> have this flag set.

Oh, sorry, your patches got reordered in my mailbox and I missed the
first one where you are removing this limitation. Let me review that
first. Sorry for the noise.

> Thanks,
> Suren.
>
> > +               .ctor =3D init_once,
> > +       };
> > +
> > +       ext4_inode_cachep =3D kmem_cache_create("ext4_inode_cache",
> > +                               sizeof(struct ext4_inode_info),
> > +                               &args,
> > +                               SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT);
> > +
> >         if (ext4_inode_cachep =3D=3D NULL)
> >                 return -ENOMEM;
> >         return 0;
> > --
> > 2.43.0
> >

