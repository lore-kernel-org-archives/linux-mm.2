Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D75E1EE57F5
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 09:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2A36B0088; Wed, 31 Dec 2025 04:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D650A6B0089; Wed, 31 Dec 2025 04:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3D8C6B008A; Wed, 31 Dec 2025 04:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF22E6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 04:31:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15E31BB381
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:31:01 +0000 (UTC)
X-FDA: 84279247122.08.DEA83B3
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 29416C0002
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:30:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nocpJOKX;
	spf=pass (imf28.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767173459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QNNZ1SWcX8IRFuo+kQglZ3d2CsHx0KTSSztX9uql4Ng=;
	b=Y6LZGjgjj5NEcMeb8txVUMReqW9Xt4Je9E/215n4lIY05qdFaoGrwiDWHCaEpaGzjc5Opn
	SN6D91K4Vgnb0VvG8xH10+V9FKVvfxjjj2HWlVBIvrk61bbsHesuXueIDMDC9lNtBv4ZDS
	0cG4Kf1bT+Id7a2/FDe2o6cFT1WmyrU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nocpJOKX;
	spf=pass (imf28.hostedemail.com: domain of wale.zhang.ftd@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=wale.zhang.ftd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767173459; a=rsa-sha256;
	cv=none;
	b=bXmJkOvENm80cS4e0N1GwaCbsDUgw08hODAaggbhTG3wQu9tsa7z7D+I+TktyQhGQMNgdG
	52JRYKkIwrtnLgFO2Bw9MW7wGS6gX50PCMBydDJViH8Qcz3OxWqopUMG6Ra1pxR+MvEGIg
	rKb5I3sy2hVqXdfL6BhpBYfZoG7hLQo=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64b4b35c812so14728624a12.0
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 01:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767173457; x=1767778257; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNNZ1SWcX8IRFuo+kQglZ3d2CsHx0KTSSztX9uql4Ng=;
        b=nocpJOKX0dVzfj/uIu+ammtPuUe9/JrRArbz9xAhy1gaicO44yEqERe2/9a33ixoTf
         Tx7AXIYqzoFvt1F1xOSC5WryfHVp9Iv9EXJVe5YLaPeuStwUElEoPSDTjTyUY6yazBBQ
         nuaF5TNKSfDy6g43Ku7Drnk0ZUx0F58TMUezHMrEiq9gW2u5F1btZ2tLmH+NaK4M7CFa
         hMyIJicwo3vJKSHSpTRs0MwAkBrF2qo7Dhn5+rttp8HpujvK/QRmqQOXdOm29P/ecrRs
         tOA8pl3fezAcN1aYIc9uRYS6eVV91nylcE6bo9k+CwaJnTbkZU27++GbjnsND4ekDRMY
         06pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767173457; x=1767778257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QNNZ1SWcX8IRFuo+kQglZ3d2CsHx0KTSSztX9uql4Ng=;
        b=iie5iv6qIwR8rH7sk7qBroTtm6irIoRdNiJ5EeRygcFj81PYLCBNqjA90ByRSDJXle
         L6uSSLOsQAEI6vQoS7grk2Xdvet4qLtHW8Pj5LLkzTBIxNKWlgU4mAJbVqc43v2EQ4At
         83AffGA8gKM6ctCt+iMOZflxUMZwB/Tq7FfFvimTyAeFnwbrTmjV3mT8Ii1cPlz8ED7e
         cA9Hp6VbtHCVakYvzv5SntrAlnI6R0rcRnKWbIfsLYG1QE3iFxBH/P8DRDHlZOP1Amjp
         iUdwgJdEbWM8UeZAvCgzNDIBukyG5gaU1b5vYQeMc4W0L86izLG8p3tbT35lT0LuyeKm
         U8vw==
X-Forwarded-Encrypted: i=1; AJvYcCW0ahQOztfX8g97qo9lsPe9vlel+UqddcYI542SZBLAK3j4SSa65IubiVFp5ZRXFQY/ZlVqyTkMNQ==@kvack.org
X-Gm-Message-State: AOJu0Yy59annd25hL6ay3Ad91tL0cjqR8Mc9Wt0HRopQhInuxNrxrLXK
	Y8OLkBpyFaM/rpxwa4zo4pT+oeXVMXwAxUqqZ/M/a6ksq/K3jMa5afzVf0JUXiQDsjVxGaIwTBF
	X/5cHMn6IQnWUcMN7l3k8GdzPXdDv+Do=
X-Gm-Gg: AY/fxX6I5zNloUZuBQc97xGW6uRxzouEsHnLNAuMltyyDvAVmy9jr3l+6TnJNQlfEXL
	sy2SDBdQdN5DTjhXk99Tw2V/i/ilH0gdSOD7n51cqmZEn8BWBv1xQq/k3i41x6pPhKcLzquRzBD
	QtblruMQM2gsyqxrAVkSIOW2lz3x43kfFt4bSALoY1YFNUlzeRT5YXxPGZHU3ER2r2GpZEXmXZV
	1ereWMzcHVayu02mqLSU2zNUsMy9PB5oDQZNESZGdQUlAejH4lYFZdbAmUZ+f+QaPB/sFCT
X-Google-Smtp-Source: AGHT+IGODOCqZrV3671U1izZzCDUaNjCM/m+76WpKpc8omLqVx+fQHhiZIC3L20b+KCuv/pTDyMeGsdIS6si1P4xUjU=
X-Received: by 2002:a17:907:72cd:b0:b76:791d:1c5c with SMTP id
 a640c23a62f3a-b8036eba988mr3327883666b.9.1767173457265; Wed, 31 Dec 2025
 01:30:57 -0800 (PST)
MIME-Version: 1.0
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com>
 <cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org> <CAGsJ_4w=KuVs5+p+3gZ=L7=rzA3qgnMVQOBJNBEPnMDWx2N+dg@mail.gmail.com>
 <20251230133522.e15135c3a17826428f472a2e@linux-foundation.org>
In-Reply-To: <20251230133522.e15135c3a17826428f472a2e@linux-foundation.org>
From: wale zhang <wale.zhang.ftd@gmail.com>
Date: Wed, 31 Dec 2025 17:30:46 +0800
X-Gm-Features: AQt7F2pgGKSzTMc_VZdPEAh9YbzwkZZ0_b3tGsm_-PUQaMVSg_oZlR50rikCsDY
Message-ID: <CAHrEdesnM4+9Yrq-GfNXaCaw5Qk_eB3_qOQdOouN5fOi9PoCmg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled codes.
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Barry Song <21cnbao@gmail.com>, "David Hildenbrand (Red Hat)" <david@kernel.org>, chrisl@kernel.org, 
	ziy@nvidia.com, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 29416C0002
X-Stat-Signature: yoptaq6tjo7dyh4m4g3duyithhdziksf
X-Rspam-User: 
X-HE-Tag: 1767173458-697300
X-HE-Meta: U2FsdGVkX1/NxpxErAImvKC6jjhP8+GxQf147xHFKAqlz6P47VBKqcY6kW3bL5uIHN6XtKnuI3Zs1vmGMZ5WozMtT/oZfRc7HOIrc+qLzE+M5BOzYorW8RrAUlKHXWbSKcgrKTheIz1S7KAi7Sq84X5SJjHCXmaBPWoIcMsV6W6Mc2Zu9allutPODUMzoFdk/JmeFJAFhEw8vrxXnL2rdmh12p3zjN1kvBAjCK4w7vdDR5WuB/UeqHYTKS7Mh+SXd234cIu5U8ynWN0nLa3eIDrpFVTcAZ3hlomn4wnXJ9OzDW6mjn/J1zIsnFgzQ1RIf7S4v2N4F8MlLnR0EWXLjJUtX263bOK/mgtXdRP5JME3VCTIm90lTyv8BoVppQz/bjKQoF3i2lkjaYR70jlVClgaKsaLqdJLQCnvQtfrf5WOpTivZNcQBmD0vy3c2Ix2MvvJ7QMGPAoxKoLGZqFe/EhtzqV7xh3dV2Igq+Nfc1nlAcsFLRiicvty7jpRqy1tcaJN+KKUqz+DYjddbHPnacto2PWSlYlnNz5IJDATbet1Nnysy67GCfmjLaHa/AN66xBIful6roPORLyvsO5hChrp8547D0tHu3bramsb7q+aUV/rzWZU2X8mgqzyrKpKOw7D5wBKFYPUQbCkQiWwoxUXna+tqoyBcCBwfB0ndgpMaIW0vP4iFX88bMd6Ih5H6I2kTO5dAs4rX1vNhujU/HkI9xq3Tyfbgk3QoRSGEYwac9WcDRHBkB1yK9WM7gn73cHDss9eI3SdvhUdkhrUGCCU+ElgSMgIXqBMRT33CScVGAjV+GRdsF5LiTC2piBhJpQDHa8Dex/fTWaAucPJWYZ3RfG/2CAPy6FPjKzoTAspHOCYgYLOrnVqDlklYuTk8AVYw9BhiRloTF7E+qVRecEPu6+gPdvy9WGEBvxNoyFHUKWq5IpYhXNYjHBOgZb+b0J1qMUx/2FjorIGEAm
 VvcFHkY9
 GEDBnOCq5GDEym6vZU4YbCT55LhEYUqGXAvLOdDLC39QEA3kRTjHIwIIr7ymsnPYXlpWyxK6enm25ZEfSuJx4HhBmFkh/oh8mnJQZOzNvLEbRZTWGGxUkXEcFll7sc4r/SoSXhn4Dyz4RZnZHqR5F9D2exnPsKhzx2brq044UxDvl6ALPveYrQ6D/O/1XY1ObeUhb8MBX5/C00f/vsr27HQCJG9uH7KYrxs5zHomQPDzVtlJ9C+ySgVy7XK/kOEhi8nmyjj018Q9LsuwwhSD8bHlzKr/OXTU5Rf7hnziC85q1OglOblgVoXvgNqeydFaHKIQs+qaIzs9EFLgTexe/GoTcjY0huqsUqK11FbOkR1Tx7OfZCdeRjOTxsY+xe2lcVZlOpoCydTQ1vx3JBJj5hOzmxKlhzrczgi/yTZBpH78YORTFR3SvbigHgnkkRhDpqpAlrd7onrP60wrm2RfAE3612ObViOfasqqKUMHhsdKktyQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 5:35=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 31 Dec 2025 10:28:25 +1300 Barry Song <21cnbao@gmail.com> wrote:
>
> > On Wed, Dec 31, 2025 at 8:50=E2=80=AFAM David Hildenbrand (Red Hat)
> > <david@kernel.org> wrote:
> > >
> > >
> > > > -                     break;
> > > > +#ifdef CONFIG_NO_PAGE_MAPCOUNT
> > > > +             last =3D atomic_add_negative(-1, &folio->_entire_mapc=
ount);
> > > > +             if (level =3D=3D PGTABLE_LEVEL_PMD && last)
> > > > +                     nr_pmdmapped =3D folio_large_nr_pages(folio);
> > > > +             nr =3D folio_dec_return_large_mapcount(folio, vma);
> > > > +             if (!nr) {
> > > > +                     /* Now completely unmapped. */
> > > > +                     nr =3D folio_large_nr_pages(folio);
> > > > +             } else {
> > > > +                     partially_mapped =3D last &&
> > > > +                             nr < folio_large_nr_pages(folio);
> > > > +                     nr =3D 0;
> > >
> > > The whole code was written to avoid ifdefs.
> >
> > The #ifdefs are only for -O0 builds, which are never a
> > mainline requirement. However, dropping functions that
> > contain nothing but a BUILD_BUG() seems reasonable?
>
> Let's not make -O0 an objective, please.  We often make assumptions
> about dead code elimination in order to keep kernel code more pleasing
> to read and to maintain.

Let me think if there is any other way to achieve it.

> > If those functions were actually required, the compiler
> > would fail anyway. In that case, there doesn=E2=80=99t seem to be
> > much value in keeping wrapper functions whose sole purpose
> > is to contain a single BUILD_BUG().
>
> I agree with that part of the patch - if the thing only does a
> BUILD_BUG() then let's simply remove it.  If somehow the compiler tries
> to reference the now-not-present function then we'll get an error message
> anyway.
>

Thanks
Wale

