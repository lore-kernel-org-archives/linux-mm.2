Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4ACC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20906B0088; Fri,  8 Aug 2025 10:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1496B0095; Fri,  8 Aug 2025 10:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBFB86B0096; Fri,  8 Aug 2025 10:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8E876B0088
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:00:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7BC1458508
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:00:48 +0000 (UTC)
X-FDA: 83753750976.01.7565860
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 841CC1A0004
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:00:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AKE0bN9I;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754661646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qqINGqOAKkihtWhqv8aP2ZlDWCyF3eZIl3dlPcJlrEs=;
	b=k+iSXWB0a9r0wjQZ7wUpOuw5pFB0Ljq0RdHvjyWH9YKWPTkgpYuNdE9VjPlsb44/ZazPwh
	kXoWre0LZfbA6504EYNZhTiVfvwm9Lw2NuIeLdi2b+RIFh5VE6mDG85FeB5ad23oaREgxV
	uuSQ2JgGnloQcYVSCZSXbXweKP1PSMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754661646; a=rsa-sha256;
	cv=none;
	b=fAnyDnilgCLUP6b0rOtaIqAtcKV85QHVf0EOSBbmhmNUE4LIwdzWZfjEYlwtEbG15v8Ar9
	0gCXvyeizNK+XuRihhVzdHZmft9mzuATQQaJgvVcmXTq8tlcM9Qr4LWBCb5dSKE6V+Jkcq
	dOQBLzmcA+xuvbMkgvyifgYcDjAY5NI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=AKE0bN9I;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b0848b5191so21410121cf.0
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 07:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754661645; x=1755266445; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qqINGqOAKkihtWhqv8aP2ZlDWCyF3eZIl3dlPcJlrEs=;
        b=AKE0bN9I73zKj3421jNR2+tK+EVOhIA4HZ1Gy5p/6cR7dl6GE7pqUbb6ebuRR+c8c/
         B5eISs9ySlokPFgP/jKXXCYBR0ml6oz99KgXOnAemlygn/LDZD+rQqrqHTlUvuitDDOR
         GKmJiRiYGSBDw/8pgR/h0tB0R3pymGYTEcnhOagHKJjb6clDW4G6sW7u4//nQ90RX5J+
         2eub5lnkrVmZers737pPKNA7KYqSxdG+nPyqG1mGE08IhfWY5rS8HRsFQag+1ICtGnUu
         heTXrEzaL8MZvud9zTjX7b6qTEwRaVMtWxyAdVEbwqLrodJVCVRb3VIAnkFXAi7+BAM9
         PTqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754661645; x=1755266445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qqINGqOAKkihtWhqv8aP2ZlDWCyF3eZIl3dlPcJlrEs=;
        b=RFQUf6y3Pv7QryLHLEQdmUAVDyTJT7SlYWEzpewLk5mv5QfdUwBJ8y2Yg/HeL8blRy
         QJFV71THwVAeP0sI+XRvbZ+SFP1qAnZCIOBUHiOs7rSATLGXiZVpN9gkhCpV+o6JlToO
         G5G/ICFOgru5baDJNYbv+MFCOGgr4Z9ppxywfr+YvAfexnCLS+X5JhU4yyWpDvm0/iLm
         g3vjLjTvHZ6WsBEmdPEw+KHCrHh84eqcPoQWGVmsILWfsST7DE6fC24604SdcyOo0dxq
         g67VrueNBbPCN8eSmyVPlqbOZ/Ucvwh0asFmavWgrx1ODn2mLXGqV4GMeRqM+jHY8GDD
         P8XA==
X-Forwarded-Encrypted: i=1; AJvYcCW42olcH81eIAC7UUezt3AqKxBl8AoSSyhfO9aik44iCobfQxqRkZb0SnbV372GFCbhVS+DLf+0Xg==@kvack.org
X-Gm-Message-State: AOJu0YwPGgB+CE+azrEbGuS9mL0ryL8D/wmWJ/alMA+PgYF3n3WpF93F
	9OHl0gFjnQopOLgTUkAEz05Jt156ftm6ge4igL8NQF8S2s3avWpnpjvF5Ux6W6w2wROvJyvGht7
	nuR0AyPaRq8a64DEnqsXbjMHeRsJ+6cyT8CdFGgdUTA==
X-Gm-Gg: ASbGnctldaZnUrj8MX/f8z0+OEDlMkWDQyph9Cdxl5wZdR9U8g3ippJzZzVd5KVPxk0
	zyXBcDK6zN+U3k3zp7xpLgp479qh6HCDqoKoGTpIpN7ylDSCpnjbuK94dq7cGirnqY6aCRXBC44
	limQHqKAVjBglr3pYsswzCW+v74P0blFjHROdCbEdFBUOUZg1vLQ3qTOzOZl8rjK/rtMPUDuRMW
	GiP
X-Google-Smtp-Source: AGHT+IGU7X5qeX8OS2DQuYKdpYSGfIFno/a95GYTX1d6NB06BqBHy2416czan27fZPJSukzaA24gTw9e0PS+96Ajhto=
X-Received: by 2002:a05:622a:5a0f:b0:4af:4bac:e523 with SMTP id
 d75a77b69052e-4b0aed0f0e9mr39963141cf.8.1754661645094; Fri, 08 Aug 2025
 07:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-2-pasha.tatashin@soleen.com> <mafs0o6sqavkx.fsf@kernel.org>
 <mafs0bjoqav4j.fsf@kernel.org>
In-Reply-To: <mafs0bjoqav4j.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 8 Aug 2025 14:00:08 +0000
X-Gm-Features: Ac12FXyA0-d-njVDnQIR5bUTLVyM1KEOMfZexHnLlS_vPOyE1wA5_qbuL5SMqTM
Message-ID: <CA+CK2bBoMNEfyFKgvKR0JvECpZrGKP1mEbC_fo8SqystEBAQUA@mail.gmail.com>
Subject: Re: [PATCH v3 01/30] kho: init new_physxa->phys_bits to fix lockdep
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
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 841CC1A0004
X-Stat-Signature: krnhws95j59i4rrtzh5zyiypa8mgc7h4
X-Rspam-User: 
X-HE-Tag: 1754661646-513292
X-HE-Meta: U2FsdGVkX1/XgaRYJXyD235bRwKnjXoXrM4WE9PgjUFQr+FCiowpGJwUU8d8MZNy8vpIAbYU1O/+aaP6b10Kk636l5fArFw7nrD06+NDANXqFRNd/d9uzyKDozghyQLiMwe128+6hpQV72mEB45mi2Ntvezw8zNOa/BopcQa4BQ86MyJ0z+o3O5b95kbgS5LfviwrUTbgHwq4QBM3ylveWBaWZObZcT/Vzk5mK+0lSv8WYkubdG/Ms5ocCfvbM3kzzANw+asOP+oO8fq5q2M6uYWQ8uz+nrrU6BZRga1/02lQL4QrRpZ7doQLPWkcRIPOJGU6zJu5xzYNda70BZL8Wo2SwRhNYRcbcgIHgZo3+Y7g2CSGE55VtaQ351BGOgc5ExuHoX4xmsPhIijxdxWyWSmP6pnskpECizF/kKAedZSPlylmFhzTBTLHqhQG00rEgqmL459HQU4N+CQbeE73fMQNgvD2tflCupmC41q64MuBgPTPjRA3P17rS58Nt1+8sJEkQEfvBzQW8GYROT9HD1boGA9I8v7ITHW5CPEolu0Dt5XX2omlX/yV3dsZzRc7FkhUJmZwBVPBpC6rwzOTT7K3A4XoK4tu2LgBlh39sQmLXOZk4IH2gEZ9CUOOjHK2L9/DR+kH7yHtT/H3sIZLpiGtgT7Gw3+OBMjnw3H7MFtcBAjlFOcj6kE/je5LBXXuIAgWnEOCtqhawtwU+dPO5wgrRPfXYGpwMzx4URxH3BM+ku5n5gMoJKt+qWiCrssP2Bc99wzWcpx0J6T5no1jJ1Mqfylg1V0ZXDEisl58vGmQcxgk7LMrtauzJxDBFqRp+psHhe23TiJ7wpIawlJcHZeB8XEFJSoKUBhKup60oul4O1DmxeUEPNJAl8CjsIuRBSUNzCLQNu1/5w/DFboGngbB4iooD/P8o14RaEsyzn6JZrVvQVQRCvbiGCeeAV02BV83OLovnINntUuHOp
 rjw2oL4M
 dMWoi4Uy8meWb9K/jyHVk57qgprdMcQty3oyrNzni8eC4XZTg3YuJrLnDcjbshw9YZTpa/aKnrODjbRfD7bHQVzzYgj0HWRRh9TjyqVpixAFiDxrkP3sBXM0WOg92xxJg6Do1yLTgDJy4AlXshdPKyNNRPNDHBEPPteFI7xLwOMhxREARwmKyWZRfhsmHrI2+It0fKrNTxuLSYbkqqlyI8VXuMsOG6wMX4VfzYhJ2Xg9z+RYZwcFVCp/mSALwH15yyvQ6O4oyt0XsPziMhlz95Gl1qtYK7UGAS6HprneH7fk/+MQAQKsFs6rVbYebefw2IFDVvaHXGaKrJro=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 11:52=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Fri, Aug 08 2025, Pratyush Yadav wrote:
> [...]
> >> @@ -144,14 +144,35 @@ static int __kho_preserve_order(struct kho_mem_t=
rack *track, unsigned long pfn,
> >>                              unsigned int order)
> >>  {
> >>      struct kho_mem_phys_bits *bits;
> >> -    struct kho_mem_phys *physxa;
> >> +    struct kho_mem_phys *physxa, *new_physxa;
> >>      const unsigned long pfn_high =3D pfn >> order;
> >>
> >>      might_sleep();
> >>
> >> -    physxa =3D xa_load_or_alloc(&track->orders, order, sizeof(*physxa=
));
> >> -    if (IS_ERR(physxa))
> >> -            return PTR_ERR(physxa);
> >> +    physxa =3D xa_load(&track->orders, order);
> >> +    if (!physxa) {
> >> +            new_physxa =3D kzalloc(sizeof(*physxa), GFP_KERNEL);
> >> +            if (!new_physxa)
> >> +                    return -ENOMEM;
> >> +
> >> +            xa_init(&new_physxa->phys_bits);
> >> +            physxa =3D xa_cmpxchg(&track->orders, order, NULL, new_ph=
ysxa,
> >> +                                GFP_KERNEL);
> >> +            if (xa_is_err(physxa)) {
> >> +                    int err =3D xa_err(physxa);
> >> +
> >> +                    xa_destroy(&new_physxa->phys_bits);
> >> +                    kfree(new_physxa);
> >> +
> >> +                    return err;
> >> +            }
> >> +            if (physxa) {
> >> +                    xa_destroy(&new_physxa->phys_bits);
> >> +                    kfree(new_physxa);
> >> +            } else {
> >> +                    physxa =3D new_physxa;
> >> +            }
> >
> > I suppose this could be simplified a bit to:
> >
> >       err =3D xa_err(physxa);
> >         if (err || physxa) {
> >               xa_destroy(&new_physxa->phys_bits);
> >                 kfree(new_physxa);
> >
> >               if (err)
> >                       return err;
> >       } else {
> >               physxa =3D new_physxa;
> >       }
>
> My email client completely messed the whitespace up so this is a bit
> unreadable. Here is what I meant:
>
>         err =3D xa_err(physxa);
>         if (err || physxa) {
>                 xa_destroy(&new_physxa->phys_bits);
>                 kfree(new_physxa);
>
>                 if (err)
>                         return err;
>         } else {
>                 physxa =3D new_physxa;
>         }
>
> [...]

Thanks Pratyush, I will make this simplification change if Andrew does
not take this patch in before the next revision.

Pasha

