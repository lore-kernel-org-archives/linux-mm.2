Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 352E0CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 06:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E9AB8E0006; Thu, 23 Oct 2025 02:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89ACA8E0002; Thu, 23 Oct 2025 02:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0148E0006; Thu, 23 Oct 2025 02:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6E0DC8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 02:05:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 164D51409EC
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:05:23 +0000 (UTC)
X-FDA: 84028341726.12.17B1927
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf17.hostedemail.com (Postfix) with ESMTP id 38B4F40004
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:05:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GIQcj2La;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761199521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3IvAY1bPgzmMFy0d5igGjN36rYPGH8m3qPfHMEgRd4=;
	b=np9E9TpdZBWNrb6tZovxEP7q9j4TqL3NVqMkYL81H4fFWDOAheKgAgdIfOIboNDRlRDJdO
	QWucZgk9/NHU9nOidyg7uD8BmiwJkvH8HjsCCWy29PhOHLLxJI7gB5MQ5ml4Cmjxmm7Cqd
	DTGSecVPlU27a9vCBxRifccuGKwKLAc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GIQcj2La;
	spf=pass (imf17.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761199521; a=rsa-sha256;
	cv=none;
	b=FcW5im9uuAP7tcsknQDuu4os+GO0DN1IQXX8ZRQYKGDS6o9HnMZOI8Q09C2vMkQaRysgNW
	+Q2q+ea0hn3/hyA2GZpRNUtgHAZZiLvt/EER1uALwlBTHaMtH8SQp4UrOdb+q15GcJ/cM2
	D2qWri+wpGKnKKkFVQIn8YDWWWpwJWI=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-88e51cf965dso65847985a.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 23:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761199520; x=1761804320; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v3IvAY1bPgzmMFy0d5igGjN36rYPGH8m3qPfHMEgRd4=;
        b=GIQcj2LaI5ZKqjBpbRqVZsrKxLgyvgjLA+fvds9uUcVYXu3GepIE/y5cSrf2LWH6rw
         UVXhG0IS/VS1u7EdAe01vJQOUE3IVL2rg+DUQHKMzfLzzjGsiA/0VcC0W5UCeSS99Q9Q
         nX0waSjnvJyKtBygClkdn269B8qtotJZi48Nb78/G7pgn8R26db5UpOJWyV954dUxNk7
         veiDg5FbYvBw9crwRbfTsIvBWHFDYAjkP0GNR8m3Lscc4lcFQtvcYt32QMBqd4y4CM5Q
         JsgrgAnD8HaUr+9E/UBlw89XtListUsrZyBT/xCcJGErJKqq6b6ZUEaicFB49Yx0w1LU
         1FQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761199520; x=1761804320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v3IvAY1bPgzmMFy0d5igGjN36rYPGH8m3qPfHMEgRd4=;
        b=MVw6Uuu131EwKpARnHoWmV29bsEXiLu2RTyO6pmivu2B9Jg4X2X0tn6jpy5u0mRgLm
         FuGS14EJ4rjqkQASPCyou2CbE1qYpPsCqarMY4nrG+I5/bq4upKvz7LFdWRUQK/ImKLj
         oF0vVgih/z0kZTOleeFhjFGPLpjNU27E2zV+QiL0mtduky7zl3fDHXhmPP+JeglpuRrZ
         PQmCKLfzyteUP/A6VYRquZCyNRC93Be9R1nLJi63+kMq9KZioG/4zV65+qILD5lCRVtu
         u0KOCdyJ0Y+OAPecGIxsIQO1QctQ+FN4bK8MqH6VW5lxw/UT3PpBwTE9rKrkqkpQrOe1
         URJQ==
X-Gm-Message-State: AOJu0Yz3UR2NZCaxgLUwrX2sKcm7mzZ39X4iyTk1wgxnkSWQRZp9teQ+
	aov+jntGo+VmNGCjNbfrwE9f4LYoEsoP7Z/CekFPoJ/qfCfKD2AlTQKjjI/s80t8XIfveKBwKMG
	h3l5fHMi96iQ+hK29MYByMcQfK6tHNaU2xbF8
X-Gm-Gg: ASbGncs7EFSXPjCB/tkBeaIRlODI5zA5rFvG5M+tgo5MI7RQ+O4XIWf6tYXuZ2Kg/m2
	KGRqdap8waD1bIqQxaktKv6Od6wDFcJPBSLyi3boiEKQfEpGlGid65RMkt9tmMi3XuqUiXrk7Z/
	BL43vMfy0DqxfqeLAhVyPvGkajwc/bEbvlgWE/uAx7X9epEf2Mk+6Fr7XgqtmdEsNrUUdqwkV3J
	bsNMpUsc1ADdp8jkdJAFqWsx573gmmKOcfeR0oC950bUy7ZHg/qKawUL6EGyS9GPB23VNG+3CFr
	lpfFhkBZjp7xisMOcN8EIXLuhck=
X-Google-Smtp-Source: AGHT+IGsEfu1WKq3O1sDXpXzxhRNtjQgAHS0IeqKxtmtdBTBKwbMP0JMEIOGBFyK/RlUYPuqFMLN0h8xpTTy4rHsfAA=
X-Received: by 2002:a05:620a:2911:b0:84b:e14f:18c9 with SMTP id
 af79cd13be357-89070114c39mr2580157285a.47.1761199520141; Wed, 22 Oct 2025
 23:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20251022105719.18321-1-ryncsn@gmail.com> <CAGsJ_4zKcxO-Tacy0jCZSs83+fGsgqQYNib9nCXoLTuL+hdLxQ@mail.gmail.com>
 <CAMgjq7CdQK_k_oGfOwCtMm18uAXrGwfwUz93pt7kaN-S64G0Cg@mail.gmail.com>
In-Reply-To: <CAMgjq7CdQK_k_oGfOwCtMm18uAXrGwfwUz93pt7kaN-S64G0Cg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 23 Oct 2025 19:05:09 +1300
X-Gm-Features: AS18NWAOFgLxB_h9QT8-CzNEtRzSIFKqRBnAEOGu-CloGyTvPo1b8C9gv-cX6nE
Message-ID: <CAGsJ_4yidWp9BqJbTa44uLWpJU-d5A+76r8QeErtL+Au+CEqZw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/shmem: fix THP allocation and fallback loop
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>, 
	Dev Jain <dev.jain@arm.com>, David Hildenbrand <david@redhat.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 38B4F40004
X-Stat-Signature: jqaahzqyyxnkzegz9ewwxwaq7a8xxsxt
X-Rspam-User: 
X-HE-Tag: 1761199521-163536
X-HE-Meta: U2FsdGVkX1+xCOuRg+LO4RnluQAyqpDwfd5Csoz0V5IGfCi0GfghkVQ1UvgEXoZLtbgIS3rhmXGlti78xQoUnc1wwFrE05/DK6HgGeLalfAvfO4nb3iIs+j+hvHwvT3UMmDIHUgjV3ac4ZVZM38K/Y9rNGVoGSaLavGPN9U/qAJQY/Xa2u7239z95La/wg/1wndr44OIm5HMTVI1zrW4jEannAA3ZRbL2IhHT4ws+4PWl6Yd8Y1CjobS7w2mpXdYdyShNlh3Sgv53BfafM0TmAdCL/l9drlF9raBhqQg56JRB42kadn0zot0HKp4r8QcMgdJw1+22nCtBlVsPlibk24PcE8vIR4ExPbLlPTbTX/SNNcQziwOJyIfECwZ4i8e3Y3fl/t4ypn+P7H3o36z/42uajYFaKf2MNpKHTtM8+MtGupill0Sggf1BwJaJrbw1GWTYIq/hcJiO2ZIH3erXLkzcSTXHhsHGtuq1GHJjRZ7Wx5FtoPlXxQza7XMvGiHj0miRLG/+xwsTahKuVksojpIV0BlhCg6ISC/JepJqf3iz5amF+pRDhwOnH4fyvMBb5SuxB3gi2BopYbvfF3aO/vuSmpZmZrUzgyr0xTfKUR/Wc4V8Rlp1Z58zSFQRjvVZCLVwJm/uetkcbvH3m09JcNpkU4+Iec0KKT0PhaDclxNfyzpmtRh5tWAUcs6XkV6P0w7uV9J3lOEzm2cwY8V+io06hY9dyiG8Fi5epyFEb4rbaJhYYk3LspZhPIS5JlZ02A4lm55qaKjx07JxRM0YvwdDVoOMsnmp2SgcGRPMSWnAAKvIUxEwT/CzvXHu3HOGv9K88nAjq/STy5BVBGiP0L/Xtf3mcb0WjOkSgVu7bkcVAutM0ZbOxpeXNZ7Z3vFFIm16DMOnH/PML6wTGdJ/3lp791qJOZE2EgGLHbcRrOBZb+lEikLmDbfSO5nIfvluzmWnvMXTh7sCsNBxXV
 S98IK5S6
 04bi3N6wTG20cBAc0SAi09alHWmRzSY46pQA3r+zZ5/J2dh5f/h7qIMIY2kf9Unjsa24yQrbrLL/0Y6b2hJVnPBtCLBSbPZyxkm8A49ALa4a0xlgMssE5yBbGTWeB3+FfUhrRSwh/xw16I+meyuR2PlzGFf27YTXYK3q1B6XiqQa5+QY+6iaV1H4gVc9KZ4EZ7D2fLYmAFL46PAGds6ySdsIiS5Fcg7nU1pLFtW8oljosem9zidIlnmsRuRMwKJ1Nh83an4OMBPFDhDuFcBD+JtqP1O/a6uRx+BkSr9/jxO4Lrq83btR8nSqrNy9jHWFP+LIWxz7c4by8zYg+bCA/fVYB+2mol6X6dbiWkrT4l+y5poqDZ+bPMi3LebaS36n01ulg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 6:58=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Oct 23, 2025 at 1:51=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> > > diff --git a/mm/shmem.c b/mm/shmem.c
> > > index b50ce7dbc84a..7559773ebb30 100644
> > > --- a/mm/shmem.c
> > > +++ b/mm/shmem.c
> > > @@ -1895,10 +1895,11 @@ static struct folio *shmem_alloc_and_add_foli=
o(struct vm_fault *vmf,
> > >                 order =3D highest_order(suitable_orders);
> > >                 while (suitable_orders) {
> > >                         pages =3D 1UL << order;
> > > -                       index =3D round_down(index, pages);
> > > -                       folio =3D shmem_alloc_folio(gfp, order, info,=
 index);
> > > -                       if (folio)
> > > +                       folio =3D shmem_alloc_folio(gfp, order, info,=
 round_down(index, pages));
> > > +                       if (folio) {
> > > +                               index =3D round_down(index, pages);
> > >                                 goto allocated;
> > > +                       }
> >
> > Could this be a temporary variable to store round_down(index, pages)?
>
> Right we can do that, but the generated code should be the same, the
> compiler is smart enough, I just checked the generated code with gcc /
> clang.
>
> Do you think the code will be cleaner with a temporary variable? I can
> send a V3 if anyone suggests, it's really a trivial change.

Personally, I think a temporary variable makes the code cleaner, but I don=
=E2=80=99t
have any strong preference.

The fix looks correct to me.

Thanks
Barry

