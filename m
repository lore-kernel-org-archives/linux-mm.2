Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2DADCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 17:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA0A28E0017; Mon,  6 Oct 2025 13:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A5B8E0002; Mon,  6 Oct 2025 13:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF2198E0017; Mon,  6 Oct 2025 13:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9B458E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 13:22:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41C6645849
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:22:02 +0000 (UTC)
X-FDA: 83968357284.22.440B019
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4C714140002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 17:22:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=chTiPVKs;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759771320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3CFdIAZSOG3RFljBavldVx+w/X0FNVvOnGYJcNKBpQ=;
	b=KrQKfxG73cY1Ro5h9h4nzSmWY5AVP9Xi26p5CjhCtCOZ7uqLWtGRgxytyb/5Kze1ENmnd9
	HscmoHDTBEenNPSS7P20XEDUUUcp8yzZusUwvsQ79K7+3fWGsJinhHHihQhdO5GcY48EKw
	O7cpeSl4NisoedjiSqTW5g8uV+gCUcw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759771320; a=rsa-sha256;
	cv=none;
	b=nQOsKBNJRtTxpXM4EBEhLggKGZRjPalAyeLeJX/BK+dLYLZ+09ao7qWKZOaG1+zeDeqn+y
	t/kkVD/gypubRVHvIy9Gbnbo/ZCEskfsag//Q0TKRGSBUT6g3AG/Z55kAUX6feHX7aGHyE
	hvHGyPy95hdhLdZr+BGioGy3rSWgsT8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=chTiPVKs;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4dc4afb9e1cso57272771cf.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 10:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759771319; x=1760376119; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3CFdIAZSOG3RFljBavldVx+w/X0FNVvOnGYJcNKBpQ=;
        b=chTiPVKsy9c7zNFJg/48X387e4wVnO3BRqFTTns7+Q7Ww6Qan5dDkH0i5R1CTIrGPO
         2AV/o75rSjD9j6963kYbzDdBVvTkuNNj+f/rLLXR9rlWbhPMIsfr9vmJpgQPofmOUTjR
         79ZkUW54M8FPP1bkblBD8PaINDGjp09EqQGW+AAbrKx3fEip0oNCfNn83xZlBtC8GP0R
         JBh4bwN2V+vN40vN8c15Q/l5DZNogo+DcW9x/jUgfJH9vRmN28NaiIplm3fp+Hr7LDNC
         XPCWQJmQNeumpFGEUM6EQPzcpm9TqccDNIZvQencjYfm4a/r1gh31GsKqw9katgRxVb4
         Q80w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759771319; x=1760376119;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3CFdIAZSOG3RFljBavldVx+w/X0FNVvOnGYJcNKBpQ=;
        b=QIjzjth7RsuUszZN7Uvo4HH1GTCwLSmXcgXBvGA2pyT8qewhNtpwNhj2BG0c91UV6/
         aOYGOPxdSsakc8sTPbtRANRIxgx1HuA18xqCMPUJUYi6CVJ8ERK4ghbXLb5mQJ2pJVvn
         fv4whCUdZtFTHc5BBngm5CHz8XM+oZBYVxAFhmFknUKDyZwIVzAwGmTZ85/+4WAZRwYr
         zf+6dIwAlNQoJAujEbOYPt+bondw8kT94V/CRbhawJmnfAfw15SRN4kMVfYhHiYidjel
         xBRmv53yv/kiEvCBeVYzF+I+eC6jsz9I91gUxM4mJ2Z5S/iUTC90ACjhaV+Nj8vnL9du
         5Lbw==
X-Forwarded-Encrypted: i=1; AJvYcCXssQxVafmSYaxQ2KiaK7YGJr8zd6nA7BAcqRMwla7+IWXtVWtDnByOUhTKrmwUvZiOvvkHu84BtQ==@kvack.org
X-Gm-Message-State: AOJu0YzXIhd6y4ADaQEhSGAfbRfo4o1UCjBJrE98id4k2Ze4MiNxrM4J
	6t99dK9g5hzrKT8MZGZWdquaqtK5bQadKNMYMZxWHDIQxB3O+hZmVmWNbzw6Bz6fjuyJVslMi9I
	wFh4WEpXhuo2YboX7QkWMoBvyvjiw5Va2DtjYCd3oMw==
X-Gm-Gg: ASbGnctj0CoXpuxsjlf77msVU3+LifUj+S4Hi/828c3pvCifUl+XaesCzyIHmpHfqHp
	Srcin+ySNZ6/x4Ggd/Fm8xhzGAFuLj1bPq1R5Ut6lvNALt+taZYCAyNiqTpZko4uPb0RtIoXOmm
	Vw2qmvs29MBoIzQQMGDi5nmyLT1WtfAwfifd0bl8kpj6n87FgOxVMf6JyIZgBrcc+gHq2eu7DDg
	fKgc+T3/aVOUKVHOPzw72kCE05Bgj2XK1qVOYc=
X-Google-Smtp-Source: AGHT+IFM2iasjSwevS/Ww6pNuFkpEMTxLK7Q2uZtw02+A+PsxcuVSjzuu+26bSPV3eDsAJn6N8sfkeveM0JOQLoCA2k=
X-Received: by 2002:a05:622a:5815:b0:4df:3139:d204 with SMTP id
 d75a77b69052e-4e6de8027ebmr6622011cf.10.1759771319077; Mon, 06 Oct 2025
 10:21:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
 <20250929010321.3462457-4-pasha.tatashin@soleen.com> <mafs0tt0cnevi.fsf@kernel.org>
In-Reply-To: <mafs0tt0cnevi.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 6 Oct 2025 13:21:20 -0400
X-Gm-Features: AS18NWCA17JFqGpyH74v5IB7rQGOnAZUihEDBZQPUG896U4mqGpoALvEdvNdCBg
Message-ID: <CA+CK2bA2qfLF1Mbyvnat+L9+5KAw6LnhYETXVoYcMGJxwTGahg@mail.gmail.com>
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
X-Rspamd-Server: rspam01
X-Stat-Signature: 6oa7aqj339u1dn6u8bdaf1ngq7bixezn
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C714140002
X-HE-Tag: 1759771320-214341
X-HE-Meta: U2FsdGVkX18O8OIC5fpaEjfaTCqYoK7Vuqy6oTu1B2ZR+X8CL7gRCKYpPPLg5uErzEYaWsewQaIdJSzGnh8fmrEj3Y3FXRXYoxkdAcOvQWJf6fjenP5ZctG807Ukn8z1vtAwUtuI1YIET91sko/r/7+wNwW3wbvEvK7oIHn4DFR02WZ9TLLzRlha9FS/6j3Ol2EQAbpVI8RrnRGBoW+vZl6+srlOUNEQrnq76c+jXXwf+YQ4dov2uC5IxgN018KnxFV/CC9+zWyMs9RRaQ4T7KBeE92XvEZsmnAVXzV/q+kei7Ek8k+ulqnmDOTJpWYGNLbUfeW5av1DouyakLJsbFXutjvoUPpWPDCGPlIVdpjZjqxxWGoYJTDyzYia8uwqSn25B1pg+EkXb0GTSY9fiQvUB4y8tpVGbylZupzgKtxALtY1/jhlNrnlDkj0BB5UCWnNHTvndtWTQ+X+m6V7f4n4FecN1V8PViPttOnOE89V99veLbUTqdxiwEkuRLXx/572boqGoz0zlyl3AUdIgkuKxrsnZkDkzweBi5bW1q9/kyK8eCNz38httjZn/G5xzo96taozuDx3uIyKyzThDfoSkHtbOOyCGGcOc8FcOTzKX5sv/pOWCrqWyuyivCSkgjwTqZGgO5xCLfGwfpzzNadsuzDRVJX9l2YGrB6bAYwLF/olXIXPvsjxQbVBrT7RY/cOce1o9eVd2pC29XrxZUWRu4Cf7CwhTRwZFLTX7Qx4GXw6PedI2LlASZ5WuLPNeABcEFG7AheMJqHwcOmyCSRkJ+2UmX1uZXqHnNLfgfHz3JddVOERn8Lsv3vylbIwSmYpIYmPg650TYiGni87XTYoItqqOaLkDP3vXsiUeVWl7qKHNbonZOt5fAi1XoWLdjnn3V2vyKevji1KgCdW9vrvqYH6Fem4H/X0sAsncD5VfpdBDpyGZaU2GnSNBz6nf0xeRqpltwW9ZO/meK2
 w5yJvLH/
 OCtMtbnGwA2dwoD2IOgBPKbMsvrwKcubKiuP5sCvpLD6FEouV26o6rwVSZe3LeSKCyCAkjoDhsDYtCsTdGBNBvEOczkqaYw5CyU8FkjdFRiXoC6+ufnd57CrUfgm7fITfAdmCM/LHe8+Z/vGO7b7v9i/VZm57jPDE1X37pUPviTOGCgZmyLtFUmXqaNwHZLNnXf7CfL63dTYaHycOgHl+0I4so7yiBX2mHzrRR6l5821wjTHLhRdUFjrvOHM/ffsTdE5AtgLA1xxWyeUpF3/ZRbvRKiwiXiUG2vc8lEzYcAs1RXe6AEr7v5kSDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 1:01=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org>=
 wrote:
>
> On Mon, Sep 29 2025, Pasha Tatashin wrote:
>
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > The KHO framework uses a notifier chain as the mechanism for clients to
> > participate in the finalization process. While this works for a single,
> > central state machine, it is too restrictive for kernel-internal
> > components like pstore/reserve_mem or IMA. These components need a
> > simpler, direct way to register their state for preservation (e.g.,
> > during their initcall) without being part of a complex,
> > shutdown-time notifier sequence. The notifier model forces all
> > participants into a single finalization flow and makes direct
> > preservation from an arbitrary context difficult.
> > This patch refactors the client participation model by removing the
> > notifier chain and introducing a direct API for managing FDT subtrees.
> >
> > The core kho_finalize() and kho_abort() state machine remains, but
> > clients now register their data with KHO beforehand.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> [...]
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index e23e16618e9b..c4b2d4e4c715 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2444,53 +2444,18 @@ int reserve_mem_release_by_name(const char *nam=
e)
> >  #define MEMBLOCK_KHO_FDT "memblock"
> >  #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
> >  #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
> > -static struct page *kho_fdt;
> > -
> > -static int reserve_mem_kho_finalize(struct kho_serialization *ser)
> > -{
> > -     int err =3D 0, i;
> > -
> > -     for (i =3D 0; i < reserved_mem_count; i++) {
> > -             struct reserve_mem_table *map =3D &reserved_mem_table[i];
> > -             struct page *page =3D phys_to_page(map->start);
> > -             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
> > -
> > -             err |=3D kho_preserve_pages(page, nr_pages);
> > -     }
> > -
> > -     err |=3D kho_preserve_folio(page_folio(kho_fdt));
> > -     err |=3D kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho_=
fdt));
> > -
> > -     return notifier_from_errno(err);
> > -}
> > -
> > -static int reserve_mem_kho_notifier(struct notifier_block *self,
> > -                                 unsigned long cmd, void *v)
> > -{
> > -     switch (cmd) {
> > -     case KEXEC_KHO_FINALIZE:
> > -             return reserve_mem_kho_finalize((struct kho_serialization=
 *)v);
> > -     case KEXEC_KHO_ABORT:
> > -             return NOTIFY_DONE;
> > -     default:
> > -             return NOTIFY_BAD;
> > -     }
> > -}
> > -
> > -static struct notifier_block reserve_mem_kho_nb =3D {
> > -     .notifier_call =3D reserve_mem_kho_notifier,
> > -};
> >
> >  static int __init prepare_kho_fdt(void)
> >  {
> >       int err =3D 0, i;
> > +     struct page *fdt_page;
> >       void *fdt;
> >
> > -     kho_fdt =3D alloc_page(GFP_KERNEL);
> > -     if (!kho_fdt)
> > +     fdt_page =3D alloc_page(GFP_KERNEL);
> > +     if (!fdt_page)
> >               return -ENOMEM;
> >
> > -     fdt =3D page_to_virt(kho_fdt);
> > +     fdt =3D page_to_virt(fdt_page);
> >
> >       err |=3D fdt_create(fdt, PAGE_SIZE);
> >       err |=3D fdt_finish_reservemap(fdt);
> > @@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
> >       err |=3D fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE=
_COMPATIBLE);
> >       for (i =3D 0; i < reserved_mem_count; i++) {
> >               struct reserve_mem_table *map =3D &reserved_mem_table[i];
> > +             struct page *page =3D phys_to_page(map->start);
> > +             unsigned int nr_pages =3D map->size >> PAGE_SHIFT;
> >
> > +             err |=3D kho_preserve_pages(page, nr_pages);
> >               err |=3D fdt_begin_node(fdt, map->name);
> >               err |=3D fdt_property_string(fdt, "compatible", RESERVE_M=
EM_KHO_NODE_COMPATIBLE);
> >               err |=3D fdt_property(fdt, "start", &map->start, sizeof(m=
ap->start));
> > @@ -2507,13 +2475,14 @@ static int __init prepare_kho_fdt(void)
> >               err |=3D fdt_end_node(fdt);
> >       }
> >       err |=3D fdt_end_node(fdt);
> > -
> >       err |=3D fdt_finish(fdt);
> >
> > +     err |=3D kho_preserve_folio(page_folio(fdt_page));
> > +     err |=3D kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
> > +
> >       if (err) {
> >               pr_err("failed to prepare memblock FDT for KHO: %d\n", er=
r);
> > -             put_page(kho_fdt);
> > -             kho_fdt =3D NULL;
> > +             put_page(fdt_page);
>
> This adds subtree to KHO even if the FDT might be invalid. And then
> leaves a dangling reference in KHO to the FDT in case of an error. I
> think you should either do this check after
> kho_preserve_folio(page_folio(fdt_page)) and do a clean error check for
> kho_add_subtree(), or call kho_remove_subtree() in the error block.

I agree, I do not like these err |=3D stuff, we should be checking
errors cleanly, and do proper clean-ups.

> I prefer the former since if kho_add_subtree() is the one that fails,
> there is little sense in removing a subtree that was never added.
>
> >       }
> >
> >       return err;
> > @@ -2529,13 +2498,6 @@ static int __init reserve_mem_init(void)
> >       err =3D prepare_kho_fdt();
> >       if (err)
> >               return err;
> > -
> > -     err =3D register_kho_notifier(&reserve_mem_kho_nb);
> > -     if (err) {
> > -             put_page(kho_fdt);
> > -             kho_fdt =3D NULL;
> > -     }
> > -
> >       return err;
> >  }
> >  late_initcall(reserve_mem_init);
>
> --
> Regards,
> Pratyush Yadav

