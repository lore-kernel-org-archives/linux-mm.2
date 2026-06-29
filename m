Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A914C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 16:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043BB6B0133; Mon, 29 Jun 2026 12:48:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A176B0134; Mon, 29 Jun 2026 12:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D916B0135; Mon, 29 Jun 2026 12:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCE7B6B0133
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:48:43 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE7D61201DD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:48:42 +0000 (UTC)
X-FDA: 84933534084.16.DF7EA05
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	by imf03.hostedemail.com (Postfix) with ESMTP id 03FAE20007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:48:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gUXWp+JE;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782751721;
	b=gyGJ1FsjqBfhNlXdmODyJBRt0le8Qa83Wlht7ezw79odiwknf1HrFJOPdq39siPSAC4/wP
	dWwKunKUYreo8QQY78Z4wgwMIih4BB8MwIcABLXwgqtI21lFDX8dEpRsx9HX//2gxtmHGU
	QGbQKi5ztSEZdIPhd58h+nSvpRopyqw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782751721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqu0ijd46YxLc8T2KWk89iPbnUD8g36UVIY5VbePUtk=;
	b=nzRp89Yp0dSOyAqPszCz70sdBCsmrczCwKJqRyORrGiz6rdRq6+fDglLOF+S2WkJKMYdMq
	XNymyNoDARRWRJSYYCdzgDxopOoRVk9v7XXhLfs47Lq7wWNXsZgjELCCWAq+7gmtx0QG32
	xeu8tatgjNiMwwDm9QF/uhpb9V96Iyg=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gUXWp+JE;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.224.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-664c6304683so1672023d50.2
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:48:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782751720; cv=none;
        d=google.com; s=arc-20260327;
        b=JroN1sjePmNPtVIp1Q+3ppgcJTvN+fsdZnSb2Re49CswOnYzka0R1RxorSe24ZcSsu
         8x+Nr87f6bpQIm3C8SzAAQYFJTJRMYhxhK36E2mgk4OXp899GrteR01AcV8INKxmdsx1
         E1nm3E+aoOu8Tyh25ZN/C4EcTvxktoOHMhhc7wgYlmeCk2dI5Tqi8sIxNEi2s1fvoEms
         AG2wnxJNqaoLVllS1oT0Wo8Ki/VIeoul2iiIoSSdNoQDI6jkC5rahR+8/rLdNSL1hN74
         MZOJyoaRiA8Kwf37vemNqOpZHcCOCer8NeZ9W4mhy46VK0idzfIVeCS0ugAnwp4deYNg
         5dpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pqu0ijd46YxLc8T2KWk89iPbnUD8g36UVIY5VbePUtk=;
        fh=LMAeKJCs+cTGSrzccUq4Dc5lBUX+NJ/13Nx9eOX7Nvs=;
        b=ec8Lz4GekgQL+gXS36FcFDU4QOzq7dmzc0HKSLH0bs5oCbgIp50UtUK/sFmVpg6sq6
         8c5ZPnw/pqCuKOuB06DVsAOg8k5S2oDyyqTGmeWkcBGWgoXtNKfQIK1ui0KrqkmXSHM9
         Lhu/Q0M9qhsjTz7E05KnrNl8vnU1YX8L47rjq5qeAJ5ApejyUMXWjUszmODGl+0Qnqtq
         qECJDqn5pcovzVdX3uLB5P4/HVly7M/uoIFI/B5lzQ1L8vX9xint83Zp6hJKwXL2NCJB
         nCm3u8FGnSUllOzjFGv6uJsIGjp/a5A+RzR/YNlNt1Uco5OADvmIgfoXqylb9YOdxQ+U
         tQfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782751720; x=1783356520; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pqu0ijd46YxLc8T2KWk89iPbnUD8g36UVIY5VbePUtk=;
        b=gUXWp+JEuG6toMHvJ/RbLTNsfDU+zMsQRE4Js44g0IMYciVWLSrjajFT3/SmARfauk
         SQanYKHXn4NhfU3LO4c06PkzJfM7WABkfIdK2AElTiuuDGP9sQZ/HzCAsxi2u8axwRkR
         0HExsLW+95jijchuPkVBoJ/3W+DleZN3+iejHFNxVOb+ePfB5S7GQ7+9z+jFJ9BTyHlM
         sRhqEejkEcRQ8KjqT/17kG/t1T5TXSZ9ftJSOtnI1EBEUjaTZ7ozzjSXqo2XaSwpr8C5
         Gqp0/4NIpi2ky6Typ3PJq+HN1luieotmoAQt9lVZSz0zuv62ZzCFSB9mxBHSLX8fK7Js
         53PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782751720; x=1783356520;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pqu0ijd46YxLc8T2KWk89iPbnUD8g36UVIY5VbePUtk=;
        b=BP7o++PEwq+njRKnYlebGc/Io8jpp4nK0XbLQIaMAKECdGtU578oFfydEH5eq63ZwS
         jEe/L2lPS81GUG2d2DE2Xd6DL85k7p8qJOkVRND8FUCyfO37uMMZlQ8lutf63O3JlOkF
         bgHyZDGdHuBBCsekoUbUQ7RCY1kSWdBoVZO31CrHZAwnuNL/h1U6twCAozzjfaEf453S
         pzLBeTDg+diEslQzlEEZ+OHz8/e86XlERWq1449aQUjEkba505wmfezuQdtwm5msE7xR
         zHanAV0f2MQVdEy8Km+uVUMBKr1/kn1Ph+eHbz4DAYdbX8hNVeJJF/5cb4XY4vndNV0T
         qEnw==
X-Forwarded-Encrypted: i=1; AHgh+Rq+5Uk8RBxLGNVz5+mUTpkGUrHFK9RRJKiImkK340+B8bdwSOPOBXmmCye674Wt1qt/Kw6ZMOM5kw==@kvack.org
X-Gm-Message-State: AOJu0YxpgXsIVSbYNTASyeO/OA/5ko71cjJChPeN8PDw4PoZBKXF2euF
	Tiju+cQHUPRD+GgPh53ykvn6x/DPh2zKV8y/Z0y+AbpUj5LaTx2wuw2P0z5BWeKcJlOImXtt5RP
	KoCXFiPYG7HFjxInastkPOgByrZ6zK+E=
X-Gm-Gg: AfdE7ckIWXcq9AUhqumufpCkEOCcujEQLNMb9UenjgXgc5YA6jkT98jPxz4gho7Od0M
	TOlEe9cB/eRXG8SIdn1bMHT8lTmkuPgJVjDli0nM9zRjjFAEM8h474Kl+M/zRmuKOInwe+S126X
	MyHYfmi3+JGSCbeD5yfvLBymnFoE/OctayZzdg+49GuRjfs2W7pD6ziYi2BoG2OGmqVK8h05WiP
	1RRduMajs7xYY8hJzh0JL8jErKaICsEV+8BMrpogaOBjbA+nQax1a8FIYoZ21xuhG6sSg==
X-Received: by 2002:a53:a7cd:0:b0:664:c1a2:36ed with SMTP id
 956f58d0204a3-664f9a828b9mr336123d50.63.1782751719282; Mon, 29 Jun 2026
 09:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260621145919.1453-1-ekffu200098@gmail.com> <aj426bA-YiOKt06m@kernel.org>
 <CABFDxME8wej3m8T5gn8y4dmpOLZutm=tDTa7ZcfhbWwScTu_5Q@mail.gmail.com> <akJafRKJJBd5Jrv0@kernel.org>
In-Reply-To: <akJafRKJJBd5Jrv0@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 30 Jun 2026 01:48:27 +0900
X-Gm-Features: AVVi8Ce7e8tTlZ7wLMJcBpYQ1j4KVXqbB4X7R45vGUUSJRnYUp1U99vuoyq3ILs
Message-ID: <CABFDxMFTfFO_jePBnM_uZXcmLBHJM3db-=VzFE+bxSYgm1G-1Q@mail.gmail.com>
Subject: Re: [PATCH 0/6] treewide: remove unnecessary invalid range checks in
 memblock iteration loops
To: Mike Rapoport <rppt@kernel.org>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Will Deacon <will@kernel.org>, Alexander Potapenko <glider@google.com>, Alexandre Ghiti <alex@ghiti.fr>, 
	Andrey Konovalov <andreyknvl@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, WANG Xuerui <kernel@xen0n.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 03FAE20007
X-Stat-Signature: xizfnfmc8buypu9i7mrrk8q399jek4rg
X-HE-Tag: 1782751720-561353
X-HE-Meta: U2FsdGVkX18gXgUT0eg1X1U0lNB/cNGsXAcECAo0U4ljS3Th8MqiLjx4d1xbHJRX6tRPnVnu1JG8h7G8FFXBLxuQaQOK+wyD10GLvx0zlgmV0xLNoYUdnbeeBUKK6h8omlfA/1UJNHsn4L1Pon8Sf3eQvP8HoWJbad/Jlmu9RNZ8vdm67sspi/Hj22q1q5Dai8jmMrmeSJqsuPZ/L3hAbThJw+hDP6KBaMrUYAxCPOb+QTi7zykEM0B9K3apR+p2PFxeOonz8mARf5AL4VyVpTwxkA/HJGMr+o79FcTEW0g6BxGqweZQR76Y35QPqsUGxYQiU5Bp13BzuYckf6m9VqtqP5c4sJKqCNjho/UAyRoTplHbgJeXYXhobWR8awBe34iSYXuiwSVj6hwf6u737T8InnYBLLsG9Q/vqXueA2TnuTLrs9CfQUivvYdaqbrIH+Fosv+9WvzV3sAw6UG1VtIuwBemgsRJ9nSImak2LCNoHOdrJhTQfTNdYEWU7FsrHPf+j076RRDqjXRFJfuokZcnJdF+XxuNJ3RBcXxWJbM/3suD9oNgGvGGvnfYPfUOsi8khZdKOJbWxwRrxoQlLONFSvs2U1Pv8YMfn1XO4EHXmtJsASA3xLN8jlBZVEC/Bw+WvxAA55UOxh5phj5gAbnrkbGMzd9IEWBuKQn99l1XAUGDsan3aTa4GImbtccUajjr31NAXY5It7qTGaYKcRxJXmRrFH1XDi7h8geUZmQXX+Py22NpvMwIMlKgHA8fbtmXe1xk7sTNcdNKG74IX3AFXNBSJIkXUwSJ4MJC7Txr2HeaxX74PzWkUT7Uh/CCXJfOWYJ+Jsj34fMLX9qxCyJBIoJGnJO/Pc3o8hg5vISif11W/R4XVr0XMFBdJP+8IifLO39dZguOnGdhEenjHNRE1jzNhWf9t0VJsu7R2tRRXFpbv7+ovtmvxyIK1/1ia9jGafsF5xwIFAQbTo7
 kl2mmruR
 wK2pfw8I7aUnJuNv0zxN2ui50NiLVXahjRziFl+DL/L9xegEppz1x/9mPUMH2WQQU7ffjODnwkXoRuwocl8wWJrorIuh3/FSlDT94/s/zr+UpEIFIv3G0YsqlcvykPR3ryzoU/Tht7EQIlSvrsb4hBWWyg/4NuhgqeRNNnNUHTWfQVTCek62PKZA+VCKDe/Btl5Z95TMmcjSf+RUUHvX4E+nEWOiOieR41/TlgWpbn73AqctC7wUX3uhjrvpGONxbDHxo9qe4YaE2bFTWy/5wvUDUXUtM8epZtpLXBcOyNc1PLpfGtd67PT1ad5niyx5JIT/oQms8T6Nrey5rovqU+f7MtZ2anfhXScZbUxA0mBH77xKVwjeY2Ips3OONJosp8tpNe838VfsdF55nhJ3/eKDvooPOrRehp4cbDjYwBZWtNVJXiO0urWbSuN+nSXeDEd0kuPYEyOB9wezjVrqkEVy/W4UzQIo8EUjCvxdYjMCMC9RsoZ0G2E/hYaCdrpk4QJYt86hGxb5TH58=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 8:44=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> On Fri, Jun 26, 2026 at 07:59:22PM +0900, Sang-Heon Jeon wrote:
> > On Fri, Jun 26, 2026 at 5:23=E2=80=AFPM Mike Rapoport <rppt@kernel.org>=
 wrote:
> > >
> > > On Sun, Jun 21, 2026 at 11:59:10PM +0900, Sang-Heon Jeon wrote:
> > > > The memblock API guarantees that for_each_mem_range() and
> > > > for_each_mem_pfn_range() never return an invalid range, meaning sta=
rt is
> > > > always less than end.
> > > >
> > > > Several memblock callers still have unnecessary invalid range check=
s in
> > > > their loop bodies, so remove them.
> > > >
> > > > Sang-Heon Jeon (6):
> > > >   arm64: mm: remove unreachable invalid range check in
> > > >     kasan_init_shadow()
> > > >   LoongArch: remove unreachable invalid range check in kasan_init()
> > > >   riscv: remove unreachable invalid range check in
> > > >     create_linear_mapping_page_table()
> > > >   riscv: remove unreachable invalid range check in kasan_init()
> > > >   mm: remove unnecessary empty range check in
> > > >     early_calculate_totalpages()
> > > >   mm/hugetlb: remove unnecessary empty range check in
> > > >     hugetlb_bootmem_set_nodes()
> > >
> > > I queued this for inclusion into memblock tree.
> >
> > Thank you, Mike.
> >
> > Could you please review and queue this patch [1] as well? It does the
> > same kind of clean up, I just missed it at the time.
>
> Can you please resend them all as a single set?

Thanks for considering, Mike.
I've sent v2 patch series [1] that includes the missing patches.

[1] https://lore.kernel.org/all/20260629163736.1606688-1-ekffu200098@gmail.=
com/#t

> > [1] https://lore.kernel.org/all/20260626032902.703944-1-ekffu200098@gma=
il.com/
> >
> > > >  arch/arm64/mm/kasan_init.c     | 3 ---
> > > >  arch/loongarch/mm/kasan_init.c | 3 ---
> > > >  arch/riscv/mm/init.c           | 2 --
> > > >  arch/riscv/mm/kasan_init.c     | 3 ---
> > > >  mm/hugetlb.c                   | 3 +--
> > > >  mm/mm_init.c                   | 3 +--
> > > >  6 files changed, 2 insertions(+), 15 deletions(-)
> > > >
> > > > --
> > > > 2.43.0
> > > >
> > >
> > > --
> > > Sincerely yours,
> > > Mike.
> >
> > Best Regards,
> > Sang-Heon Jeon
>
> --
> Sincerely yours,
> Mike.

Best Regards,
Sang-Heon Jeon

