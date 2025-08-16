Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10E60CA0EE6
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 08:58:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18128E0013; Sat, 16 Aug 2025 04:58:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A29C8E000F; Sat, 16 Aug 2025 04:58:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869CE8E0013; Sat, 16 Aug 2025 04:58:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC548E000F
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:58:17 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 192C81A03B9
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:58:17 +0000 (UTC)
X-FDA: 83782019034.25.3FC9D31
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E5CE140002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:58:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=chb5CYJu;
	spf=pass (imf23.hostedemail.com: domain of chenhuacai@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755334695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gkwILOogyhNQVSyZu2xwlQtlQmQLbUPcIp1n50/oZE=;
	b=xfRHOwqWBrSx/6+0/ayAYgbygQmUy3MFRZK3er8jBwe8vhqSgcm1BZnKAcPrAT9XmAnHlB
	2RPVQ87r170Lvnyg1KKoDJwJLfgAi6zsQGXDUQ5+EpL30qo9Ru1DYA5eLttYMgTzL3jBKb
	fQzrCiOihmBDOQbslsgRWuQq44Mwp4s=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=chb5CYJu;
	spf=pass (imf23.hostedemail.com: domain of chenhuacai@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755334695; a=rsa-sha256;
	cv=none;
	b=aFxuFZXq/9o7ETCZrtsxaAjJghdx/z+CncJY8FPjbmzHI686mbBrcQXep0MEDvGpiB2f3S
	7K+ZO6aVr5d5T5NSDYvjcMHFGwaafWXj4+xbngb9k+24RauwN4r9zfOLYfkMX6tyaUtX5O
	4S1Na2Pm4Sg4YYBQJq3xAg82dUyagJA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 230DA5C4D50
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BCCC4CEF5
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 08:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755334693;
	bh=XWv1wUb7FwiPfk7V/wKl3SHRDAdpSUK7VHeOz+yvqXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=chb5CYJu1ht7l5i7YrV7gWWAchmXy5sE2eCSTAbvrNGUZRf2TpEfe24vhioe7wotp
	 TfPfMPCthr5n2mp3FruR0ynDL7cIa3T3TtQqkKWd2VAWhojOI7cDJgMJVbgOPOtb0v
	 SuTKp/zPLfor9bKaKDoPi58sGhCtIHOraF/RKenEy7EoBeKt8M3ljt6p0y1HXSzYqb
	 4ofFWxdfjnm8xM9MPlAH8uwf7BIAXVRTzy5LnFelrbMemQQnHoM1J0Hv9+xtVOSYmX
	 jmjLbx8/bLpihMIrYQ86GVnbaMLslNzIzxeegYlRxkXmRkBE0NjoeQrdZxxjuQk+4V
	 wXvGOK5cnshPQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb78c66dcso378980866b.1
        for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:58:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW8nVH4TMhdqXmESQzqHX7Z4jANi4qBJs3eM5gjBxBpvs6gHnXUqDpR0kzqF552JAH2uia6U3BbEg==@kvack.org
X-Gm-Message-State: AOJu0Yy2AkklnQe/ILcKoASqS5GOHvZV3l0SEATlRAi7kwGy4/bTRkMv
	f4w+NK+m2hYcaOfX77OfxUMgU08JDSlWyrRBWApAksWv6FsU/MDOiMKO5E/8CiyjEd0L+DF3DVx
	tZmQ34qRFMQsF9Rb+dUHFt9IO1CswgeQ=
X-Google-Smtp-Source: AGHT+IEy0yosetTzWD8z1o1bD84L6UgILGNJBWhbzBgcLkL0MDkI2AshzhSJ+MPl3yI8Kj1xPv8aNa4fiTZY65FBooo=
X-Received: by 2002:a17:907:6d0b:b0:adf:f8f4:2001 with SMTP id
 a640c23a62f3a-afceae5a81dmr143819766b.49.1755334691927; Sat, 16 Aug 2025
 01:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250815090539.1578484-1-chenhuacai@loongson.cn> <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
In-Reply-To: <a20d605c-79a0-4d89-985b-9512a990b492@redhat.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 16 Aug 2025 16:57:59 +0800
X-Gmail-Original-Message-ID: <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
X-Gm-Features: Ac12FXx8ET6w2h699uYj6c-MbtVgKvs19eE076Y1Dr6QWvbL6jZ_HWczmWQRNp0
Message-ID: <CAAhV-H470h2HDEN_NY2qNBxUqQrSRQhLzwqZe9PB8GjnNsZVFQ@mail.gmail.com>
Subject: Re: [PATCH] mm/migrate: Fix NULL movable_ops if CONFIG_ZSMALLOC=m
To: David Hildenbrand <david@redhat.com>
Cc: Huacai Chen <chenhuacai@loongson.cn>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Harry Yoo <harry.yoo@oracle.com>, 
	linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E5CE140002
X-Stat-Signature: 1bpe7gzu4xgaaaztjd85ujdsknkjutxj
X-Rspam-User: 
X-HE-Tag: 1755334694-645508
X-HE-Meta: U2FsdGVkX19lthSXzEc2TyGYrmRoLOD30Ia/x/NsG3XcjfZ1mnVllz0LAx1R0s9ioSTm2Ajt8fF2zi56SesbYlMySZG0Y6Dsgf/kqVazMVtkQVpb0pdNS1ONZY0PolfCWD8lK58E/tS0fthpTbzLFCZ/VVlm59T8sKUbBEoam2ouTAB4qNwW2TC2GnbY9Zq2D30or7EXN+2PRgLmhraKMEYw9exHlWPTGIhhaDerFYAo+9vXwwa9+waeR573S25X/P+aIl9FUB/SGsK1Wz4c4oSgEo3rZE6Droostbap/J/7dqYy9PvW23wa0szLZ/b2MOK8BBvo06lIsjwlWBTGmf1hvVd0j8c0K8uKPOEz3a546CHM0RPrXc4/66b2CjDp/v+rU3ctZ2vnEh6HNwfEZ9rvjYwHnh2PFdUuy2vam4dW4PpORFNG2BBYyBZVN/M9KmyMEQskAoSKVL0Rgcjb/ldAYpEmPf6CjXUaA9cZggqhmuDRQ4TDhpjHTjoGDzjnIEjGaoG48thLGs3pib8WIj+/s/LR0h2oygonMsDTTiPWh0OSHGhNTkFrMeFlRQEO3G0holCJfOB4E4Eqmgo28vrqpsVh2eNdaRptvJNe02NUfpW4PGUogNBFUYW0MlDEbhT7Q67zBCOKakbjJLLlkIIIN7UALdAueTSZJL2gg3CiFk73hqe/sF2GXvy7c5KK2BaBvKfAdS/2mUHwrYbaHBnkeiuONk18VGvufqeOi+kIVAL4q81Vc+GKNvjYctOQZBpFQJNlT160vkS68khSW8gxzIr6HMbhwJr0hQLewGiSDanZTYHOpAlUXXISqKXCS54G5FVeYTuKk10rdNkdKnDNFeS6qc6nLMR0F6J7kZoH30k8ppE5kH6hr6ItbQo/7B/ERy9fJw7OtPQCR9SCyXasUms2zHU0TQOaVO9xwjqdHOBy+pxMCzzacpKof9tEqqhJIfJJsj7+sR1JUQX
 LdYdFh1k
 Qb1jiLiFM8b2RF/VkUx59YgJ8PrWMHhnBovK7UadpfUSEoI1z5S/IB7wISgQ50IEQfpPPTr/G1g4l2o5c5B5pTCHLlxE+rt17rnnX3DCRrewDZWy43Cgk9h5q/5np3d9LOywZQwBQKSY+gMNhxv0xHAEGmBf8SFFwqzTJ8RxqiSBSZCoDjWbXJsBj4zR/JSVwsLJqdHbADGged+U4eAHf9GOib4BvdHa+Z1wQIuftpBp01ORE+D16p/7lSn3sJVxN0egeP6+DvKg+9EAhQ+YjcW9S0SWlN9+9aglfAqna/9xBzXdmJoMhhOUl8QGMBiRxVZXYaNECjMReI6GUotd6Vt5US4wCRTkLpwXD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David,

On Sat, Aug 16, 2025 at 3:22=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 15.08.25 11:05, Huacai Chen wrote:
>
> Hi,
>
> please CC the appropriate maintainers next time. You missed (some)
> balloon and zsmalloc maintainers.
OK, thanks.

>
> > After commit 84caf98838a3e5f4bdb34 ("mm: stop storing migration_ops in
> > page->mapping") we get such an error message if CONFIG_ZSMALLOC=3Dm:
> >
> >   WARNING: CPU: 3 PID: 42 at mm/migrate.c:142 isolate_movable_ops_page+=
0xa8/0x1c0
> >   CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 =
PREEMPT
> >   pc 9000000000540bd8 ra 9000000000540b84 tp 9000000100420000 sp 900000=
0100423a60
> >   a0 9000000100193a80 a1 000000000000000c a2 000000000000001b a3 ffffff=
ffffffffff
> >   a4 ffffffffffffffff a5 0000000000000267 a6 0000000000000000 a7 900000=
0100423ae0
> >   t0 00000000000000f1 t1 00000000000000f6 t2 0000000000000000 t3 000000=
0000000001
> >   t4 ffffff00010eb834 t5 0000000000000040 t6 900000010c89d380 t7 900000=
00023fcc70
> >   t8 0000000000000018 u0 0000000000000000 s9 ffffff00010eb800 s0 ffffff=
00010eb800
> >   s1 000000000000000c s2 0000000000043ae0 s3 0000800000000000 s4 900000=
000219cc40
> >   s5 0000000000000000 s6 ffffff00010eb800 s7 0000000000000001 s8 900000=
00025b4000
> >      ra: 9000000000540b84 isolate_movable_ops_page+0x54/0x1c0
> >     ERA: 9000000000540bd8 isolate_movable_ops_page+0xa8/0x1c0
> >    CRMD: 000000b0 (PLV0 -IE -DA +PG DACF=3DCC DACM=3DCC -WE)
> >    PRMD: 00000004 (PPLV0 +PIE -PWE)
> >    EUEN: 00000000 (-FPE -SXE -ASXE -BTE)
> >    ECFG: 00071c1d (LIE=3D0,2-4,10-12 VS=3D7)
> >   ESTAT: 000c0000 [BRK] (IS=3D ECode=3D12 EsubCode=3D0)
> >    PRID: 0014c010 (Loongson-64bit, Loongson-3A5000)
> >   CPU: 3 UID: 0 PID: 42 Comm: kcompactd0 Not tainted 6.16.0-rc5+ #2133 =
PREEMPT
> >   Stack : 90000000021fd000 0000000000000000 9000000000247720 9000000100=
420000
> >           90000001004236a0 90000001004236a8 0000000000000000 9000000100=
4237e8
> >           90000001004237e0 90000001004237e0 9000000100423550 0000000000=
000001
> >           0000000000000001 90000001004236a8 725a84864a19e2d9 9000000002=
3fcc58
> >           9000000100420000 90000000024c6848 9000000002416848 0000000000=
000001
> >           0000000000000000 000000000000000a 0000000007fe0000 ffffff0001=
0eb800
> >           0000000000000000 90000000021fd000 0000000000000000 9000000002=
05cf30
> >           000000000000008e 0000000000000009 ffffff00010eb800 0000000000=
000001
> >           90000000025b4000 0000000000000000 900000000024773c 00007ffff1=
03d748
> >           00000000000000b0 0000000000000004 0000000000000000 0000000000=
071c1d
> >           ...
> >   Call Trace:
> >   [<900000000024773c>] show_stack+0x5c/0x190
> >   [<90000000002415e0>] dump_stack_lvl+0x70/0x9c
> >   [<90000000004abe6c>] isolate_migratepages_block+0x3bc/0x16e0
> >   [<90000000004af408>] compact_zone+0x558/0x1000
> >   [<90000000004b0068>] compact_node+0xa8/0x1e0
> >   [<90000000004b0aa4>] kcompactd+0x394/0x410
> >   [<90000000002b3c98>] kthread+0x128/0x140
> >   [<9000000001779148>] ret_from_kernel_thread+0x28/0xc0
> >   [<9000000000245528>] ret_from_kernel_thread_asm+0x10/0x88
> >
> > The reason is that defined(CONFIG_ZSMALLOC) evaluates to 1 only when
> > CONFIG_ZSMALLOC=3Dy, we should use IS_ENABLED(CONFIG_ZSMALLOC) instead.
>
> Ouch, I missed that CONFIG_ZSMALLOC can be configured like that. I
> thought it would always be builtin.
Make CONFIG_ZSMALLOC be bool can solve this, if you think it is reasonable.

>
> > But when I use IS_ENABLED(CONFIG_ZSMALLOC), page_movable_ops() cannot
> > access zsmalloc_mops because zsmalloc_mops is in a module.
> >
> > To solve this problem, we define a movable_ops[] array in mm/migrate.c,
> > initialise its elements at mm/balloon_compaction.c & mm/zsmalloc.c, and
> > let the page_movable_ops() function return elements from movable_ops[].
>
> Before I took that easy route to just get it working quickly, I
> envisioned a proper registration interface. See below.
When I found I cannot access zsmalloc_mops in a module I considered
the registration interface. But in this case I think that is an
over-design and not straight forward.

Moreover, a registration interface looks like a redesign and not
suitable for hot-fix.


Huacai

>
> >
> > Fixes: 84caf98838a3e5f ("mm: stop storing migration_ops in page->mappin=
g")
> > Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
> > ---
> >   include/linux/migrate.h |  6 ++++++
> >   mm/balloon_compaction.c |  7 +++++++
> >   mm/migrate.c            | 16 ++++++++++------
> >   mm/zsmalloc.c           |  6 ++++++
> >   4 files changed, 29 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> > index acadd41e0b5c..58fac171e4d5 100644
> > --- a/include/linux/migrate.h
> > +++ b/include/linux/migrate.h
> > @@ -57,6 +57,12 @@ struct movable_operations {
> >       void (*putback_page)(struct page *);
> >   };
> >
> > +#define MOVABLE_BALLOON              0
> > +#define MOVABLE_ZSMALLOC     1
> > +#define MOVABLE_MAX          2
> > +
> > +extern const struct movable_operations *movable_ops[MOVABLE_MAX];
> > +
> >   /* Defined in mm/debug.c: */
> >   extern const char *migrate_reason_names[MR_TYPES];
> >
> > diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> > index 2a4a649805c1..a1d2625b5c39 100644
> > --- a/mm/balloon_compaction.c
> > +++ b/mm/balloon_compaction.c
> > @@ -254,4 +254,11 @@ const struct movable_operations balloon_mops =3D {
> >       .putback_page =3D balloon_page_putback,
> >   };
> >
> > +static int __init balloon_init(void)
> > +{
> > +     movable_ops[MOVABLE_BALLOON] =3D &balloon_mops;
> > +     return 0;
> > +}
> > +core_initcall(balloon_init);
> > +
> >   #endif /* CONFIG_BALLOON_COMPACTION */
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 425401b2d4e1..92918fab3e1a 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -53,6 +53,10 @@
> >   #include "internal.h"
> >   #include "swap.h"
> >
> > +const struct movable_operations *movable_ops[MOVABLE_MAX];
> > +
> > +EXPORT_SYMBOL(movable_ops);
> > +
> >   static const struct movable_operations *page_movable_ops(struct page =
*page)
> >   {
> >       VM_WARN_ON_ONCE_PAGE(!page_has_movable_ops(page), page);
> > @@ -62,15 +66,15 @@ static const struct movable_operations *page_movabl=
e_ops(struct page *page)
> >        * it as movable, the page type must be sticky until the page get=
s freed
> >        * back to the buddy.
> >        */
> > -#ifdef CONFIG_BALLOON_COMPACTION
> > +#if IS_ENABLED(CONFIG_BALLOON_COMPACTION)
> >       if (PageOffline(page))
> >               /* Only balloon compaction sets PageOffline pages movable=
. */
> > -             return &balloon_mops;
> > -#endif /* CONFIG_BALLOON_COMPACTION */
> > -#if defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION)
> > +             return movable_ops[MOVABLE_BALLOON];
> > +#endif /* IS_ENABLED(CONFIG_BALLOON_COMPACTION) */
> > +#if IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION)
> >       if (PageZsmalloc(page))
> > -             return &zsmalloc_mops;
> > -#endif /* defined(CONFIG_ZSMALLOC) && defined(CONFIG_COMPACTION) */
> > +             return movable_ops[MOVABLE_ZSMALLOC];
> > +#endif /* IS_ENABLED(CONFIG_ZSMALLOC) && IS_ENABLED(CONFIG_COMPACTION)=
 */
> >       return NULL;
> >   }
> >
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > index 2c5e56a65354..052fcc0d29e5 100644
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -2246,6 +2246,9 @@ EXPORT_SYMBOL_GPL(zs_destroy_pool);
> >
> >   static int __init zs_init(void)
> >   {
> > +#ifdef CONFIG_MIGRATION
> > +     movable_ops[MOVABLE_ZSMALLOC] =3D &zsmalloc_mops;
> > +#endif
>
> No, not like this.
>
> Please add a proper registration function, and use the page type as an
> input.
>
> int register_movable_ops(const struct movable_operations *, enum
>                          pagetype);
>
> Probably best to refuse any page_type except PGTY_offline and
> PGTY_zsmalloc for now, and let the function fail with -EBUSY if already
> registered. The function can have a stub that returns 0 without
> CONFIG_MIGRATION.
>
>
> The you can do here
>
> int rc;
>
> if (IS_ENABLED(CONFIG_MIGRATION)) {
>         rc =3D register_movable_ops(&zsmalloc_mops, PGTY_zsmalloc);
>         if (WARN_ON_ONCE(rc))
>                 return rc;
> }
>
> --
> Cheers
>
> David / dhildenb
>

