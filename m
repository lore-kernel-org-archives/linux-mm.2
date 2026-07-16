Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 356FDC44511
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D19386B014F; Thu, 16 Jul 2026 11:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF11F6B015E; Thu, 16 Jul 2026 11:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08436B015F; Thu, 16 Jul 2026 11:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 834236B014F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:16:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3ADC61C0160
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:16:51 +0000 (UTC)
X-FDA: 84994992222.03.29D3C7E
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A77314000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 15:16:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DVWM+/mW";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784215009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqBuWxa0vx7vE0co4ZY41gbuMB1fSwmGyg1K2AK2XRU=;
	b=BglmlbPQqJF0y4BkLzY3mcg/VVLOAtFojJe8vAsBWylO4ad+fn+RMXZXJPxSUpY/766JCf
	12WcmmgQcQ1R1bU5JiZ13iUF7IPCntxN24WwCbQkAECM/cQX15xkYmPWssrdc3OMgRSHlI
	ePb7SQlTFNG1POtEU6bQ3LJuianmHLs=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="DVWM+/mW";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784215009;
	b=TyMh9LDvv1Mv4j7YwnIjdC2RXXTCOYpHH1cwXjvmNbTz920gDE18zxoOvPa/GkJKzZoWF3
	PEpj+L4ZNtVTQWhZEkm23cpGQGfVrGIDD/RRU+SFnEZAz0SBSYapcA/8CHDURPU15hY3OD
	YXD3dG1CCh9nJMJZ1uW8NqWy/mjh4aE=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69a45011a92so1243a12.0
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 08:16:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784215008; cv=none;
        d=google.com; s=arc-20260327;
        b=PzKnDkqAZS5wJ7DSfXhzm355txDaZvdZF81G1ihkr13mGSrlTd+vSQ3nEsKO2u4yh0
         enj77Z1ssPDX9btoJjI5uIX2052yp5BFYi8sCajqp0cFR4HNtPeQ85KzE4sNacYNpewK
         nowUDWfImqM0jMCB0ZZ+Kfj2J2j5T6DNiGn04fDAwbdsV42nH1YyItL4G2RRAFykE5pD
         V3e9lJLTswjkslrh8uyRlJaL5g40qfilS5CfUIFZl0VjBS6KJ8le/cuDcRq8jq1Wfh8L
         wzy0zA9lIzrdYq8jwMAJkxzpi/dgd4vH667YU8knUTrZUhJmyfWUeSZXm4nJaPqDabbF
         An1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iqBuWxa0vx7vE0co4ZY41gbuMB1fSwmGyg1K2AK2XRU=;
        fh=IrHsdY4mGEiv/X6do/nX/c9eOUYf6mqzXhx/5ASBg9U=;
        b=Cf76hhqCpS7BvsIVPYgOwkosWqRddb1u6zFIOxlxFB4Ho8YzmZfrR+1Zza/RmmT+os
         iEJ3w5s09OmKFwJthB1OaOARWUzqr6mFylWCbjy/xhcdtTKcMn/thN9twsSiFwX1SOUe
         P1XZnviNwtLw9UDFzTdLxWpJrKMQTDcfaXmVJu7ToQpG/qC8wai0Ji982xsMxSRaChg8
         FPoaWA3nDzrb3u5SDXu/N3VZSIVoBGPaFmMXcdnrZfx7k+VY7l5l02Z8XBfwIpRw29H3
         LiMUMBysWoXdA+sqT3NZHGHNngkHtYgibtGH58UUGh4Tp1gmhTy0Uq7x5gM7gFOB+pKN
         UM0A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784215008; x=1784819808; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iqBuWxa0vx7vE0co4ZY41gbuMB1fSwmGyg1K2AK2XRU=;
        b=DVWM+/mWF60FtEZzf7brKvNPdvEczaZfY+H1vkvPrqPbI5A4RMnHI6Gxcqvx89YDoj
         6eEgaAhUoPUNT1Itnh1gPb9J90idGvBKShVlxTx6u+E2dZFCwWelsq7k1vskDECo+TD/
         6alaL50SVwJopUOJB0uSWN64GE7QZyFsbMHUo6fYGeU9f63zc/pXJhH6LdY2qpReNcZO
         PdjND8VNUhhXl6kPKz1U6BzpAkQ3FsBs0qSojpg7mlb5uBfaYXQMvA+8O7NiVGEShkPu
         emX2Shpl3VHAogVpiRQm61ejPyF6WB3mGo23+UJ84abgeps6eVbMk3E7o9iHIu9EcDle
         GFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784215008; x=1784819808;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iqBuWxa0vx7vE0co4ZY41gbuMB1fSwmGyg1K2AK2XRU=;
        b=dY5DHBCjnPDt65cDdvtUZzfCCZYqkwVKZ5VNyw0tF8TqNOp/W4ZjRCdtIK65z0gux7
         BpUOCZYjQedSrwh8tbkDIqWVugGdcJ7p4wRIpJZGmHrsdkciOQi3yYXzHXg2tlaHuRqx
         wxM+uhFKD74UpxIux408d4Ch3VPWNFz3CPboTujGfEX8YMIqY+DlFJ1p27BqYzaQGAXd
         DdnoRxHS64a8rvOyc//HIpmgXzRCOXcBeMbjhSLhnXNsEm6E8gFC9MmJCFQE4gBN8lC7
         ji50jLGAy0zwE4zzWFwwYeqVgaF2J/lSiGo0j7nY6U6aawYWO8d0xD1gPtJIcO/wvyVB
         ns1g==
X-Forwarded-Encrypted: i=1; AHgh+RqcA5Wx4UrGIfOkcPZjXigyHBEZj80A/dNb3Wfb/um/jACRigRYI2rwVpPqh89xJR6KETCBxrPwuA==@kvack.org
X-Gm-Message-State: AOJu0YzPdRW2M56M+vHccz9g2vyKfAnveF0nPdyeJS5FvsfRnKxHTnPz
	1wNy0+zSRiJXlNL8QvuWpJHYBFPbQ9iEV+nSfN1m5Cis5aOZe+2vg8MOQEu9Vz73/hxy1FOu9Bl
	mTOWiAO/5Xj33D8f8esCVvBFMTLUCBgggkStFzOPd
X-Gm-Gg: AfdE7cmjBfMfy0AGAhzKljsDoa/nWzZhXraghJr5QWAZfJZws0XZyJNddEMIsOQFpjB
	63/dtrWkS8XsqZBeGV3LaG5xgDb4YwpNKtvW/0AyZsJbjw7qKmqthgqmKC5MPuZAPHzM7KhhXz0
	1VMCoifBQnhl1jlq16iSlQ9HyTcyjxHrvXckmOhPiJOKEejD/iqIyBtY19i7LKMvjbc+NHaWz4R
	2XfrkU92F4JgCkUTNRpMKVkMNbsNONNo51JcsLSr5UHokfjcIgjD8W4nyfqMt72YEjLfrRgYNWx
	EXoM4fv5Sz9rF0RE
X-Received: by 2002:a05:6402:3d5:b0:69c:3005:12aa with SMTP id
 4fb4d7f45d1cf-69e2e3c01ebmr77184a12.6.1784215007276; Thu, 16 Jul 2026
 08:16:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260714205111.2497151-1-mclapinski@google.com>
 <178409777790.255896.16691338963510282908.b4-review@b4> <aljy_-Y7OT6s0kj0@google.com>
In-Reply-To: <aljy_-Y7OT6s0kj0@google.com>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Thu, 16 Jul 2026 17:16:36 +0200
X-Gm-Features: AUfX_mwHtEQCDzSKOWpRsxhX676TcVn98jGTGGvIkOzpKfZmwE7X4hoJWY_RhEU
Message-ID: <CAAi7L5c3fX9cN_s3fDB1x27SSWE=Mut8B2gkXNJ9nuHsuWTNZA@mail.gmail.com>
Subject: Re: [PATCH] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A77314000C
X-Stat-Signature: yifow5514g67chefgg9qx7gn74cfy596
X-HE-Tag: 1784215009-794772
X-HE-Meta: U2FsdGVkX196xUzLkCRSMlWztY/WRIdRNWXhfIWtHEau4FKxmWlWDcu/vu9o3HUW/j/pVyXcAusrIeBZsN/ESbBNk1NZ+nVcemKby+DJMwZVVEPb+ddITRk91SRADyYlLOf+tEdCiNSgRG46MN7q25B/6w62VVIS3q+52Wffjho+29IKmkeZWytR16BQKwjWRwx4iNYjepf1fXQx1LHt63T9YVdmUAZsywFshkJNobi2ktSmhuAXLDM+JdntkAF9ovAHyaMmEO+h+ic0JYbtwj1p2JA7eYt/GsJdMnGy+kuiK42YaSif9jkWCGooECUw1249gwB3pTYu9gZaFKQRYLn3VslbeClQjU6wgvHjKRSnet5k1bvgxPfT8Z3CURk2r3/7V6StBBfjzUGizrzG4yi9PzYVTaM7UjMiXaxHpgnciTq42hha0u/HDSyodaX5SlG8E8W4CNCD3Vrot9NyiLZi8/XtL09g/1W5PpzLyVfoQFu27nFtPSDy8qBlT20fwQJwiin8mriRbwIi2kCoi2rbJ82tFTH1FhN+FoPBLiVu+vfZWHfE0F9blI4FU4yURiPVlC+qJYNCLQQUNBZbMF1MYmfmRD/OwmJWMGy52/o3Iux6r7v+3ICu1zldbBWstvZn/7MiouvHAnUvPqhFZLcU8Lg5JqHXRIxreT7D4olGl8nXFQXhgc3QaHohLSlJXOnuORHnvBcpsdB542X8JBeEe4rUWJXGOZrJN8cF5uhwRVgNMlWmzf9gpweIqcSPe5+U6JtEbfOSjLP1aNpHUqpG2DMVuWMBicaib8TxjXrTzNuMrqxYAamkmuWsH9okJx73A7OjFTKg7OxtVQS1GpUD0putgBdji6SnCeWC6/jKPEj4vie+c153h9AxfEKefJznbQnaacZO0mydRvf0VzuV6dXrscXFJbHjKlZxIHfXQXHuS2oSxipMca09y/s7pW805OdyBi6oqXqnnbW
 YdXo0Kl9
 UZrlJLpO0R/+WX8fao/xyImmZSFlaBUwQQf6vjGPUQIktZ8X1UDMwEH9eQPY6TrxPwKsN7sFKn+IJf6JapN96yPipyvereAA5YKwYEozRFEu8o9uUMQhsenUwuiZU5jG9JMAT9US0EUNvAdAZiBSQHyoyaJh19uQkh3vu3iiKJtHIzXGIrukLpj9PIMEVqjN2Q+5dCr5kqzO6C+zlMxu1gjBlSj9uoCg0yBN4K+hj9XFgHy8Bl7DmW22FdkEWLAluGBHg5pw08/FhM97oFcN7oALQLL2C9djDYXq6L8iqyJFtHPQadJ2HH1lOhPYyzwRlpdR87aHnfHQmQbeAYH18wBpLV+Vx88xjCGkhAe88l07aveE5ox/fjP7zDhWrLM8an9JmoorOJUaCkuoIZsDOwaQG2Pm1o9Qj25XkU/IHjfRzXoGC1vsAFKCmsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 5:04=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On 07-15 09:42, Mike Rapoport wrote:
> > Hi Michal,
> >
> > > I caught this crash:
> > > BUG: unable to handle page fault for address: ff19164fffff8328
> > > RIP: 0010:__free_one_page+0x1a1/0x6b0
> > > Call Trace:
> > >  <TASK>
> > >  [<ffffffff913208bf>] free_one_page+0xaf/0x240
> > >  [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
> > >  [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
> > >  [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
> > >  [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
> > >  [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
> > >  [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
> > >  [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
> > >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> > >  [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
> > >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> > >  [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
> > >  </TASK>
> > >
> > > deferred_init_memmap_chunk() works fine without KHO because free
> > > regions will never be neighbors. However, with KHO, free memory
> > > will be split into (free && scratch) and (free && !scratch).
> > > KHO scratch is aligned to CMA_MIN_ALIGNMENT_BYTES (which on my setup
> > > is equal to 1 << 9 pages) but buddy can look at the neighborhood of
> > > MAX_ORDER_NR_PAGES pages (which is equal to 1 << 10 pages).
> > > This sometimes crashes when one half of the neighborhood is being
> > > initialized but the other part is yet to be initialized.
> > >
> > > To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages=
.
> > >
> > > Fixes: c6073743d0c7 ("kho: make preserved pages compatible with defer=
red struct page init")
> > > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > >
> > > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/k=
exec_handover.c
> > > index 4834a809985ab..50928aaa33710 100644
> > > --- a/kernel/liveupdate/kexec_handover.c
> > > +++ b/kernel/liveupdate/kexec_handover.c
> > > @@ -38,6 +38,16 @@
> > >  #include "../kexec_internal.h"
> > >  #include "kexec_handover_internal.h"
> > >
> > > +/*
> > > + * This is the minimal alignment required by deferred struct page in=
it.
> > > + * deferred_init_memmap_chunk frees memory to the buddy allocator, w=
hich looks
> > > + * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
> > > + * If KHO scratch is not aligned to that value, buddy can access uni=
nitialized
> > > + * struct pages, which can cause a crash.
> > > + */
> > > +#define SCRATCH_ALIGNMENT_BYTES (1 << (PAGE_SHIFT + MAX_PAGE_ORDER))
> > > +static_assert(SCRATCH_ALIGNMENT_BYTES >=3D CMA_MIN_ALIGNMENT_BYTES);
> >
> > Maybe make it a variable and set it at runtime?
> > We won't need to worry about different confugurations that override
> > MAX_ORDER and potentail divergence of pageblock size from MAX_ORDER in
>
> Do those architectures reduce MAX_ORDER when they override it? I would
> hope we could set the alignment once and make it large enough to work
> everywhere, rather than depending on dynamic changes even during boot...

MAX_PAGE_ORDER can't be modified at runtime. It's either 10 or it's
CONFIG_ARCH_FORCE_MAX_ORDER.

