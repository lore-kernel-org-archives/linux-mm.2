Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DE8BCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 13:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8452A8E000E; Tue,  7 Oct 2025 09:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F54D8E0005; Tue,  7 Oct 2025 09:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4258E000E; Tue,  7 Oct 2025 09:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA3F8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:17:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCB7656642
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:17:04 +0000 (UTC)
X-FDA: 83971368768.18.A1BA88E
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id CFA9C140013
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:17:02 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y5eSduJs;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759843022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGjQstuXxCbXjkgmEtho3zqtbBjdkL7MGqcvpT6Dbac=;
	b=lRA0hZBJuIeHKBzSjp6v3OUijoxJVzusW05u85jHrqzovLSKwIe7kUgtzOz64o3T3VHBXv
	IjevXqOKxGYYK/V6eudmLkw6L4KRYM5jMWiwU5d7k9OH9g0Yv4ny1Psyjo8jWiTtcvXjrB
	eAFMj/OyV2aUUfwIJ5m+nG1QFCM5IVA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y5eSduJs;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759843022; a=rsa-sha256;
	cv=none;
	b=d25aBZF//ZpA7Z2qhwCRo/yg0ChV5toIgN8ZwF94czzHK6QNYS2YEd9vRv3F6O0/UjINJ/
	klvnWjn+1Tmghs/0NnlAPo2jeYiwpXKaR5pdc01iHCqikGm3FyyjQOpEpzjFbtZvXk7gm+
	0peae+AYWXuqky09yw3/mXfEEflE/8o=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4de8bd25183so83848901cf.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 06:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759843022; x=1760447822; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pGjQstuXxCbXjkgmEtho3zqtbBjdkL7MGqcvpT6Dbac=;
        b=Y5eSduJs2mrT7p7+kLDZiFLB7g74RFtx35vls/0bHX8H7yUkPD4UAVZY5bjw6pn3zN
         oZ0NGayW23pL/CQxTPpvxu4vn6m24pCk/RaDj1Wxj6jQQnj83wOG4WCAlleGZ+9qnE+t
         a9BYhFJKO2UOlBulxmZuDLlfaIwCha43omsTkDJn/lYG7VPBu/ozGggYBA3mJVWnOAux
         huJH89D61qy9yyMHv+HQSOq/iqT8H18apVq4j/JYs1/6zFpttB2bjqLws6gE1QlWuxR6
         jAF+cmJ1tCNJml1BCNH8Nb1h9JB/MZpLSSw48Y5MxKfXR8Ix29IzDRwEAaZ212SHS5tq
         VE6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759843022; x=1760447822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pGjQstuXxCbXjkgmEtho3zqtbBjdkL7MGqcvpT6Dbac=;
        b=XRYW42G8snr4MB0/ksxMrlbH0sqO+hxx5K2+nrBh/tBSLkDaGRY4ZbFsGSE3kbq1KO
         oTg2WhW5YPFdZyna874aUNNAd4dqY5v3BW5GA62mqhlwKPuXRSn3bkWcrvHqeP8gKzJ0
         bjCYBkmQYWdhr8WbT4WdENLatl+8ptQC0PTwth+cnE91Z95BfVYl8pLyfvErTRhJlrik
         CAB+7OOszFVqUrw7EQo3D1xVJcPQHxpqBa1SX2ktFKcg6uZHK444Z7Wy8BrFyb8efR3K
         Y6zFGYqEjmPjYJzGTBdKFfaM1iYCrGRRf81i7NJwFuA6tT2cZsnnkoBoTF0NKioT95rT
         7Y2g==
X-Forwarded-Encrypted: i=1; AJvYcCWg65i/g8GEWv9uz6lbzk+eHwEDbzQUQLaYE/KFhv9iq+/RK+n0Bk3aP99AfdShAa0Fiqas/01WRg==@kvack.org
X-Gm-Message-State: AOJu0YyKZl5OS/GA+vOPOy5TbajyUo3wjIJHfui80CHIjpZ+t04/v3p5
	0UjeQd7untz8pCb89EZnUehYPGkHlx8msinDcZE6k6Y31oWZAph8eGLyxlFJtqm4bnOchXT/ai4
	wx2xtqWXSFPLl2a1msL6tx6CDnG1jJoOGtfKCzN9oSQ==
X-Gm-Gg: ASbGncvNyQu9ZfJLBQ8oJ9tAAwX1OvQF3eo5Q6lg6yVJnjw1Tsagd7m6E/zSQfEE8AB
	7t7thTSDMjeYUOnD27AycM02W3GKywOmuqRBB2/M+yc4goBs/KLuBbcz/ehV30dRzxxH8BPbYkU
	oF/5S04wlMRoW6tyUD95O8qElg0QzZQs2EQXTQb/TNyN/5Y5DOUKclccOmy8pghV6odwbEl335x
	EZO5VwT0d9WWm10GoBaHST/ZEVI
X-Google-Smtp-Source: AGHT+IErTOfhbVekCCdPxxpICEbrbhOaEM1jbyw9u/DzKXn3hm20NW7yY7Ebv6K5iiS95Vkga4m4uus70RCOVSYZKBk=
X-Received: by 2002:a05:622a:5884:b0:4dd:8dcc:17f5 with SMTP id
 d75a77b69052e-4e576a569b0mr225293361cf.28.1759843021454; Tue, 07 Oct 2025
 06:17:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-4-pasha.tatashin@soleen.com> <mafs0tt0cnevi.fsf@kernel.org>
 <CA+CK2bA2qfLF1Mbyvnat+L9+5KAw6LnhYETXVoYcMGJxwTGahg@mail.gmail.com> <mafs0playoqui.fsf@kernel.org>
In-Reply-To: <mafs0playoqui.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 7 Oct 2025 09:16:24 -0400
X-Gm-Features: AS18NWCRhwYsguwzm1bh0CindcVLAn8z07AreURWfMoXFjhjQmI0qWqW1QxWkf8
Message-ID: <CA+CK2bCFsPZQQQ0JFErnYt=dbzBx=ZJdV+eNXYWyNUE+xk7=yA@mail.gmail.com>
Subject: Re: [PATCH v4 03/30] kho: drop notifiers
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com, hughd@google.com, skhawaja@google.com, chrisl@kernel.org, 
	steven.sistare@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CFA9C140013
X-Rspamd-Server: rspam03
X-Stat-Signature: 3ftkb6ruas1j7fapjxb4cnpeocdhf33t
X-HE-Tag: 1759843022-273731
X-HE-Meta: U2FsdGVkX19AqFSg7VnHFS9PLFfxA8d2DCSftvfZ4ul960U1l0GeCd9ZsIEF6OV1ysNE5czGMrycIK7RLME/ZFtcYtqm6JUjux7bmy6ji3o03LB+9mTvxsePqESr6L44dD6Plra3s/jNIQy/99cEYbVSTgMMAFtC3PAjmq0ouAl3C5iwyCEA7qRwQKQZfKcU+MS3VNK4NNqgLja7fFFzJN6kgq/8VPM537oLpiEwHUm6vT1VPryqaxuHVvhAKwTpe3IWI9jpI0fg941iIz+xXfKr0goXNfrjfkhODiOLekg7SG0f4716FRJ3azPe5brOhx+PnWWhjk57AgtxFtO/wBTqr/HX+HhOK2wVxeLwHwhdH6CKzEgVU1JQQkF7SoqdY4ATZiU3EaeCPnJaW+8Ji8HCU+tu2kvfh2CamTHh/0NrPfvuN0WI/lrqNOQ5KS6VfvBLbgYe3OtWKiA0bj31NLGMh97K61VVCATO1q24vYTmBatw0JKhklxYWjJU0bv2r9gIMuL2OROumVtOHMqki27RJhtf9yfzif9oUJipHWF1adrJs4M6Fj9IrjgrcOosGMbHf1EgFl1UeeWIG+5yNX/bwP0EoXXpZzEpQ6fteWSfUMhayvVw2LFbpF0yFknscfdCKcSvcKVFxd6WL/2nw1lciU+mtwNH4UJhwYnBoajKOyG5SYuBCbM6vchJrQ44phwqe+q5Q33dDfC3qv956E4Pfkjbe2n4al05M/8NW8btwf/hx6x/CxxDv8TXVQfJJpG90DzZddoJ8N0oP0CNdPinDsoTUihYIfjPVB5NQcBn0PwXeg6H3qeaFR0V6rQE7Pj+3EBSc/0LfudXnBnq0HaEBO3eYRaYXERgaoAAjvZpq5gYM+k23dtuq24ymb7Z+XcGc01lLebTmhLGlvIouc3dVrLTHtAfKkpTxeCjEdUkuDLJPBH2NBWcfavyGF3VxctPYK+hDN3bhrnf8x7
 AITol0tZ
 yAl0zf/+F9FtBHkD9y4xua83rpZ2XWpKQYiiAm3YwKmfqJEcLq/sWNjcosOCM1b0FKKUIVakJE1Mo65ariXz2nQbAS9RbwHX1de9s25j6c/EpSdafv4YcPuCtqhMFafBXrlaU8TLlf04KUd7aQjaCV5xnDS4npkMK0dGxhAqdCkDO7333e//1FLO7fEivcVmK7tJTtuntqO6RmOqvCd5YLgLdVfDmpK4vgRMYTnvh65eMqIq+R7Q/5oQToVtdSoDcEHv/NRNw1LK/3720HuiHXA9tsVNxEDacGdPRyPbJWiPhf5AbmILP161oudhLU+CV6ZjDZrrJAS03q8IyS4MjEp7CqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 7, 2025 at 8:10=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> On Mon, Oct 06 2025, Pasha Tatashin wrote:
>
> > On Mon, Oct 6, 2025 at 1:01=E2=80=AFPM Pratyush Yadav <pratyush@kernel.=
org> wrote:
> >>
> >> On Mon, Sep 29 2025, Pasha Tatashin wrote:
> >>
> >> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >> >
> >> > The KHO framework uses a notifier chain as the mechanism for clients=
 to
> >> > participate in the finalization process. While this works for a sing=
le,
> >> > central state machine, it is too restrictive for kernel-internal
> >> > components like pstore/reserve_mem or IMA. These components need a
> >> > simpler, direct way to register their state for preservation (e.g.,
> >> > during their initcall) without being part of a complex,
> >> > shutdown-time notifier sequence. The notifier model forces all
> >> > participants into a single finalization flow and makes direct
> >> > preservation from an arbitrary context difficult.
> >> > This patch refactors the client participation model by removing the
> >> > notifier chain and introducing a direct API for managing FDT subtree=
s.
> >> >
> >> > The core kho_finalize() and kho_abort() state machine remains, but
> >> > clients now register their data with KHO beforehand.
> >> >
> >> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> >> [...]
> >> > diff --git a/mm/memblock.c b/mm/memblock.c
> >> > index e23e16618e9b..c4b2d4e4c715 100644
> >> > --- a/mm/memblock.c
> >> > +++ b/mm/memblock.c
> >> > @@ -2444,53 +2444,18 @@ int reserve_mem_release_by_name(const char *=
name)
> >> >  #define MEMBLOCK_KHO_FDT "memblock"
> >> >  #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
> >> >  #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
> >> > -static struct page *kho_fdt;
> >> > -
> >> > -static int reserve_mem_kho_finalize(struct kho_serialization *ser)
> >> > -{
> >> > -     int err =3D 0, i;
> >> > -
> >> > -     for (i =3D 0; i < reserved_mem_count; i++) {
> >> > -             struct reserve_mem_table *map =3D &reserved_mem_table[=
i];
> >> > -             struct page *page =3D phys_to_page(map->start);
> >> > -             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
> >> > -
> >> > -             err |=3D kho_preserve_pages(page, nr_pages);
> >> > -     }
> >> > -
> >> > -     err |=3D kho_preserve_folio(page_folio(kho_fdt));
> >> > -     err |=3D kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(k=
ho_fdt));
> >> > -
> >> > -     return notifier_from_errno(err);
> >> > -}
> >> > -
> >> > -static int reserve_mem_kho_notifier(struct notifier_block *self,
> >> > -                                 unsigned long cmd, void *v)
> >> > -{
> >> > -     switch (cmd) {
> >> > -     case KEXEC_KHO_FINALIZE:
> >> > -             return reserve_mem_kho_finalize((struct kho_serializat=
ion *)v);
> >> > -     case KEXEC_KHO_ABORT:
> >> > -             return NOTIFY_DONE;
> >> > -     default:
> >> > -             return NOTIFY_BAD;
> >> > -     }
> >> > -}
> >> > -
> >> > -static struct notifier_block reserve_mem_kho_nb =3D {
> >> > -     .notifier_call =3D reserve_mem_kho_notifier,
> >> > -};
> >> >
> >> >  static int __init prepare_kho_fdt(void)
> >> >  {
> >> >       int err =3D 0, i;
> >> > +     struct page *fdt_page;
> >> >       void *fdt;
> >> >
> >> > -     kho_fdt =3D alloc_page(GFP_KERNEL);
> >> > -     if (!kho_fdt)
> >> > +     fdt_page =3D alloc_page(GFP_KERNEL);
> >> > +     if (!fdt_page)
> >> >               return -ENOMEM;
> >> >
> >> > -     fdt =3D page_to_virt(kho_fdt);
> >> > +     fdt =3D page_to_virt(fdt_page);
> >> >
> >> >       err |=3D fdt_create(fdt, PAGE_SIZE);
> >> >       err |=3D fdt_finish_reservemap(fdt);
> >> > @@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
> >> >       err |=3D fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_N=
ODE_COMPATIBLE);
> >> >       for (i =3D 0; i < reserved_mem_count; i++) {
> >> >               struct reserve_mem_table *map =3D &reserved_mem_table[=
i];
> >> > +             struct page *page =3D phys_to_page(map->start);
> >> > +             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
> >> >
> >> > +             err |=3D kho_preserve_pages(page, nr_pages);
> >> >               err |=3D fdt_begin_node(fdt, map->name);
> >> >               err |=3D fdt_property_string(fdt, "compatible", RESERV=
E_MEM_KHO_NODE_COMPATIBLE);
> >> >               err |=3D fdt_property(fdt, "start", &map->start, sizeo=
f(map->start));
> >> > @@ -2507,13 +2475,14 @@ static int __init prepare_kho_fdt(void)
> >> >               err |=3D fdt_end_node(fdt);
> >> >       }
> >> >       err |=3D fdt_end_node(fdt);
> >> > -
> >> >       err |=3D fdt_finish(fdt);
> >> >
> >> > +     err |=3D kho_preserve_folio(page_folio(fdt_page));
> >> > +     err |=3D kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
> >> > +
> >> >       if (err) {
> >> >               pr_err("failed to prepare memblock FDT for KHO: %d\n",=
 err);
> >> > -             put_page(kho_fdt);
> >> > -             kho_fdt =3D NULL;
> >> > +             put_page(fdt_page);
> >>
> >> This adds subtree to KHO even if the FDT might be invalid. And then
> >> leaves a dangling reference in KHO to the FDT in case of an error. I
> >> think you should either do this check after
> >> kho_preserve_folio(page_folio(fdt_page)) and do a clean error check fo=
r
> >> kho_add_subtree(), or call kho_remove_subtree() in the error block.
> >
> > I agree, I do not like these err |=3D stuff, we should be checking
> > errors cleanly, and do proper clean-ups.
>
> Yeah, this is mainly a byproduct of using FDTs. Getting and setting
> simple properties also needs error checking and that can get tedious
> real quick. Which is why this pattern has shown up I suppose.

Exactly. This is also why it's important to replace FDT with something
more sensible for general-purpose live update purposes.

By the way, I forgot to address this comment in the v5 of the KHO
series I sent out yesterday. Could you please take another look? If
everything else is good, I will refresh that series so we can ask
Andrew to take in the KHO patches. That would simplify the LUO series.

Pasha

>
> >
> >> I prefer the former since if kho_add_subtree() is the one that fails,
> >> there is little sense in removing a subtree that was never added.
> >>
> >> >       }
> >> >
> >> >       return err;
> >> > @@ -2529,13 +2498,6 @@ static int __init reserve_mem_init(void)
> >> >       err =3D prepare_kho_fdt();
> >> >       if (err)
> >> >               return err;
> >> > -
> >> > -     err =3D register_kho_notifier(&reserve_mem_kho_nb);
> >> > -     if (err) {
> >> > -             put_page(kho_fdt);
> >> > -             kho_fdt =3D NULL;
> >> > -     }
> >> > -
> >> >       return err;
> >> >  }
> >> >  late_initcall(reserve_mem_init);
> >>
> >> --
> >> Regards,
> >> Pratyush Yadav
>
> --
> Regards,
> Pratyush Yadav

