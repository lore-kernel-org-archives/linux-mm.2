Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDE8FF60D5
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 19:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D9406B0092; Tue, 31 Mar 2026 15:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589996B0095; Tue, 31 Mar 2026 15:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 478426B0096; Tue, 31 Mar 2026 15:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3577E6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:38:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D27A6B7F98
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:38:45 +0000 (UTC)
X-FDA: 84607370610.28.7E1971B
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id CFBC4140004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:38:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NGEfFQSX;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774985923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Ph8Mi8POftBy6RvsuH66drxxw99oOnhJqCjrvUosjA=;
	b=09R9tj8ZDDtt4LabQg5FttqAarEqV2kX7qh3SgmH4seyh12/ILrN02FrlQmAcIMQ2ie7N1
	TdWwg7+zY82vKDDh2kqASKDP4eUBFUvnJpXCZeBBbNb2liQ5v1ToaewBKVJ1g+q7RJCBB9
	KEZ1Mb3e6ygc7kVLgizvhbPVqkf9yks=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NGEfFQSX;
	spf=pass (imf26.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774985923; a=rsa-sha256;
	cv=pass;
	b=vlGwcS8L0kvmdS+/R9w4moApaFdrTMInbtGEgJhXmbm5NzFYffJZd/2jqx3TdYcqlNzdWH
	2qzXWaJ6VVwI7RV6JIynuwhAyT2APxejEHXSWGPNGMhqi5HFGE1VLgSaNE4byEMYRjO9V1
	f9RWFiaglBh5rQVtQ617hLJiUFKSWF0=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-66b2f6e983bso7602214a12.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:38:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774985922; cv=none;
        d=google.com; s=arc-20240605;
        b=Rdw9nhHDw5u4DAK8+w2wK57veDdaCVnQaT4ri9NKXNjt4zYgMOogeleCC4Ia2P3emi
         c4Ps9qEeRFA2GHw/LhSnF5kpVRgU+iLOgSKo+haljgNS+EHlGMGVaBbuhBLcg6i8ia8D
         o2doBjh5Q4f5pOjLpMYsts2wbVXMgBv0uwpWPWW+pOUy+8T2OeBo3AFQ/MQm74HCd2tf
         iG4Qir593LWKRePq8K/uJiNlp/H8XmNRXAMD/0Yv8zrGoS1IJCs2ZlVhQRuQnj+UgyUN
         AKjK85QLGSKXwGc0VvAKTZ439scENVk/V4/ZAMViJ3/T/DiGcR/ZMO3fmu2ChUxpFeL5
         PRaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8Ph8Mi8POftBy6RvsuH66drxxw99oOnhJqCjrvUosjA=;
        fh=jE9ik43gJDfAqluYvUjePSV0qW3i+o5uSnz8mXsKwhU=;
        b=ep6pghxhZ3ugQcTtBJi+hdoVP7UCe5df/FNWZ+luV8iTtC2KYRMrbmsenrsbFPrJO1
         Luw3+nO3oyzXZsJRJc5cYudyEn8necaOQ/u0L/I/eLx8tM58eRngTZPXtQKsmKJj9MjQ
         sKpdGSWJ7rVj2Sgsta/Mdtl2JoeKmQUeWb95rDXuj9M48M9Yo9UL4vLFMWKDEwwnJRDH
         rWI/EEEktHiNQ60iXhmu6Hic6Hx3dr8etjMtXrAbcAKcuu9EatP6LlfN30jpuwQDKtrh
         5//9jxYV7nO+56f4FG12uY1zvTvM942ZTggWp5xH4kAsUNoxPKWgBSffMiMye4eEpETR
         80Eg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774985922; x=1775590722; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Ph8Mi8POftBy6RvsuH66drxxw99oOnhJqCjrvUosjA=;
        b=NGEfFQSXWj0lIz3l42EWn5ZZfUlbw6E8m7E6SRWG+a721xc5vz9zKFDiu0aD6tQRIu
         w8qCr2Owau467sVSaqdeFCNBJ3nlnAZtC/QHZbPjQ2m8JaJbZ4ZAO0UE/xD3KYt4KIrt
         8Nnw7B/QK+YIl72oTIip7Rp84ZQ4T+UkDl1VO5nldS6zFHX6gRpQay2Gm8NaeI7uJ/eN
         CF54u7grxe+6Dob5dF5KCNZg+7nMmb6td2EgD60ySe8Rh97gc9fsCEze4uiCt53Kzv3P
         qAldzMoIOaPE+bybWsmjnN7ElHkF1ibZqlO8wUtDWw7ZvKku6vaojb0JgkI1gA1oPt8w
         HKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774985922; x=1775590722;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Ph8Mi8POftBy6RvsuH66drxxw99oOnhJqCjrvUosjA=;
        b=Nksa8wv3aK8eHNGMk+fGQ1xhlM/Rpa8oZjM9jChz2GczNWqM9RxY2SlBbK4Lb6oeEg
         9ozdUno2BhgEnb3cJJF0yyOfLylHvip6+zrCmTgPAQbS5aa42qLyKMhPqByzteMCv9zo
         X/EJH5T4nER4N9gf43QZbjIA8wlhgDaqJRCHxEhoGJRNbZsd+X59u1xA699M4LgcMFlr
         LioOg4UJfhF9MMFUdcngaiTNRAmJTcU6stOajCp5UTxEEKUVvicBT1Ix0BWAcRh0jXRu
         SL2AZoXbJXHKonZSXDx/g5MWtiO6Mf1i6J1gdslGvJN6RZMnNUcEdRG6/Q4rN6rx4INZ
         SjoA==
X-Forwarded-Encrypted: i=1; AJvYcCWWN24eHCLwMt3iCQPTBeycZgQZKfC5aIsItU5Svd5b7MT/Mxm3L2QkMcJ8dNAE0RO4542jDYkp9g==@kvack.org
X-Gm-Message-State: AOJu0YyPeYCt87OLPEaLQiYHvJe0tR1nNsSzRoll1WJn+CWKUVGX46WQ
	zAneSuM9jSgj/wGe/2IN2keYtnuluaLBNSTOjUqF+ryRIkOljc/9r/du3A5AslqrsXiTrWqi4N7
	5sMb4YXwfbwG/pjctrnYrPCym0hmDAGQTlx/skeJtIw==
X-Gm-Gg: ATEYQzz4MIGvgef6npqRAKH1NoT25cZOigDM13l+rlZhfU7WqqvNRe2FsMhtV4VaQZz
	sN82puMWsWR9FQOYxYBPH4ViIOjzcHkUZqwXj+Mdg7cxS/VC/iE5/mNidsNK58yezTDhPfZYb8c
	ENT8mvOj8/4Gk/snENzwoCeBAMEGCKCZwwJiizjKt6LhmjRQihAkg6ymNIZ1BgUQcxh/f3XuDh9
	I037RVgDZvzluGPM6GGIAbb6SWmvV9V4HBo+/cMhWy7TCOrT98/ehBFxgs8anQzoLRpbW6Xef8q
	iH1drzXZS+PNAj0+4MyiZWvOt/9hBpx3hrrcEg==
X-Received: by 2002:a05:6402:40d3:b0:66b:f15c:e9fe with SMTP id
 4fb4d7f45d1cf-66db0aecf71mr493845a12.17.1774985922192; Tue, 31 Mar 2026
 12:38:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
 <20260327033335.696621-3-pasha.tatashin@soleen.com> <2vxzecl0i8rv.fsf@kernel.org>
 <CA+CK2bDFidSZQ+UevEXPgfF2BWkN1AWkb2iRWGxUNV2iLpJGXA@mail.gmail.com> <2vxz1pgziz2o.fsf@kernel.org>
In-Reply-To: <2vxz1pgziz2o.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 31 Mar 2026 15:38:05 -0400
X-Gm-Features: AQROBzBH3oesWjJOaVpZH0XIUH9Xs8snX9snpgjeOm4fyZwQ45W5SUO3HweotoM
Message-ID: <CA+CK2bALLdQt82GXHYJNEzo_E9mPw8VeC4WOF41EundCTT+Twg@mail.gmail.com>
Subject: Re: [PATCH v3 02/10] liveupdate: Synchronize lazy initialization of
 FLB private state
To: Pratyush Yadav <pratyush@kernel.org>
Cc: rppt@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, skhawaja@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CFBC4140004
X-Stat-Signature: grw58a9kfdsjuddhephp3cuwnqk91q7n
X-Rspam-User: 
X-HE-Tag: 1774985923-292040
X-HE-Meta: U2FsdGVkX18zUlSWq/eEbx37SkwQDVMeTbhKMx7ToDjfdlOxGMBy0Vxw87eKpIOz1cLeSteLqmuOXiauwtHT6b/28gMnx+ckW9aXXUlPjTvurOoicuO975bIRcg62egp1bhsSae80qXCIaUt/AOvT5FU8pSMXK+7bfKGCWRekFRfJ5LqAA1XlnreyK6abiQh6rIZpnDvTPBR4ra8J3K+ERoZxIICz996HYBKc/QB5a8E2oHAx3m9NwEluvQUQFB5x9zI9RgCHj5nnnqA0RZ2z5KNqjhcEvbCfNUWGCy3dWBhjNTnBDzHd5WSiGQSYFAK8cfRDMdbrCPo1jThOM8iHQ9ujpTZUv/07CD8VOuLKzyJRGsq04bIX0uuMxGs/6xNvCB3A5fwx5gEFjZ/Z5hnyPwUL8tUXFdy+Hb393Tcu8kVDeplwK75ppsECYDay+dguevPPBUvwkFlAw0sNyvUfF7oJEV+55NUmDEvUZ58W/tA/9DGwaAeMyjcR3rYrolZJzhQDe2cyF2HgDgGJ88mWdxugclb9/zV85u9CdyayNWG1G2Fd4q2cKGxZcD8P+JoOIPXYctYMe85mrqgtcVPYXKXGGxv1r8u+VBi0n4O5z2+H8ed3jBNJR/85h+xlpV/K2bwH+5gVqETlzZelvXDLZdStqmSlgT/U4P9FCEmwybopdv+b/gIxQMEqLxRb19H7U881snJale14J/44zlIm3zZ9Rro3codAAd/FYvs0rs/ifBCFPMz0ltqXc2IIkpLJbLe+lVPMk322vC2tn80lPK6ms1WtOyQpkksCcSjqBJLOCGRji9HuYb1Vf40Vai0mDUZGr3hNkIEH/MZcYJiyBOr9Ikgt/zVqbH9jso+dl1ioMMeCOEH2tMfQgO4wMyekyXSVWPxAQWMsrGRXvGVEtZeloPyWhw1McHVHWN2bkq8BbfnO2nsV5/hocwwviHoW3gczMqJjdSUFDVwIg1
 +ygzrbjI
 ZFg2wSUydZp436Dx5NcS/XkPjqGbbq6W6dQ72kWttEBJxy2XnQdeWhlJpunfTTtIAxmkKVI6FC2foJTDcsfdRTRfswPK9IWASbKuU0HpcW7aL3HRZhaclq8CX+gLVuErJ7gRJAN/sOAl72YwAujRlcHxcKmyu0/vlGryztYf97eM7joOpiYyM+K3ou+Ofnfs2Okis0tVKsEhtEpp+mg898X/8azY/m9SCW9/OqR75yMejW4rH/VNtVwPCTUubR1Oztqi0XTom9vVb2jdbO4C+C6JwfJyuU9gdiPLVx2PohntYFy6uvxgHzlQ63pQllDRR92mI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:22=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Tue, Mar 31 2026, Pasha Tatashin wrote:
>
> > On Tue, Mar 31, 2026 at 6:38=E2=80=AFAM Pratyush Yadav <pratyush@kernel=
.org> wrote:
> >>
> >> On Fri, Mar 27 2026, Pasha Tatashin wrote:
> >>
> >> > The luo_flb_get_private() function, which is responsible for lazily
> >> > initializing the private state of FLB objects, can be called
> >> > concurrently from multiple threads. This creates a data
> >> > race on the 'initialized' flag and can lead to multiple executions o=
f
> >> > mutex_init() and INIT_LIST_HEAD() on the same memory.
> >> >
> >> > Introduce a static spinlock (luo_flb_init_lock) local to the functio=
n
> >> > to synchronize the initialization path. Use smp_load_acquire() and
> >> > smp_store_release() for memory ordering between the fast path and th=
e
> >> > slow path.
> >> >
> >> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> >>
> >> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> >
> > Thank you.
> >
> >>
> >> But... wouldn't it be a whole lot simpler if we introduce a
> >> DEFINE_LUO_FLB() and get rid of luo_flb_get_private() entirely:
> >
> > We are planning some updates to this code in the near future:
> >
> > 1. David Matlack will send a patch in the next version of VFIO LUO
> > preservation series to add liveupdate_flb_put_incoming() so that
> > caller can protect from race with release of the last FD release that
> > will also release FLB.
> > This change will increment FLB 'count' not only when FH uses it, but
> > also when the object is being accessed.
> >
> > 2. After I plan to convert 'count' to use kref, and also decouble init
> > and liveupdate_flb_get_incoming(), this will allow to access FLB
> > object with interrupts disabled, as requested by Sami for the IOMMU
> > work. I think, that while working on this 2nd change, we can also do
> > some clean-ups if necessary.
>
> Okay, makes sense. I really think this initialization of private state
> on first use is ugly and it should be gotten rid of. So please, whenever
> you plan to do this refactor, include something like the static
> initialization I mentioned.

I am not sure if it is going to be possible without giving an access
to "private fields" to clients that declare FLBs, those sould really
be accessed internally by FLB itself. If that is doable than sure,
otherwise I prefer to keeping the logical separate that is enforced by
"__private"

Pasha

>
> >
> > Pasha
> >
> >>
> >> #define DEFINE_LUO_FLB(_name, _ops, _compatible)                      =
  \
> >>         struct liveupdate_flb _name =3D {                             =
    \
> >>                 .ops =3D _ops,                                        =
    \
> >>                 .compatible =3D _compatible,                          =
    \
> >>                 .private =3D {                                        =
    \
> >>                         .list =3D LIST_HEAD_INIT(_name.private.list), =
    \
> >>                         .list =3D LIST_HEAD_INIT(_name.private.list), =
    \
> >>                         / ...
> >>                 },                                                    =
  \
> >>         }
> >>
> >> I can't get sparse to work so not sure if I need some special syntax t=
o
> >> initialize stuff in .private, but I reckon we can get something workin=
g.
> >>
>
> --
> Regards,
> Pratyush Yadav

