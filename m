Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80748CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 23:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2C788E000A; Mon, 15 Sep 2025 19:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03FD8E0001; Mon, 15 Sep 2025 19:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B41018E000A; Mon, 15 Sep 2025 19:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A33038E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 19:51:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655DC1A07A3
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:51:39 +0000 (UTC)
X-FDA: 83893134318.25.FC636AC
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D6CC160005
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:51:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lV5H0KZx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757980297; a=rsa-sha256;
	cv=none;
	b=Ft7jZBMxRD9PPbMQX7ldrHoGu6miFPcaqcXiJZ+y1xnnyqlWwI8sitoZbc2gajI2r9gI7m
	nAWh2fFM8trLTkvaihQXV0bmG45vOCOtORMtcVWcE4hA4ObWwcsomgv6C56ykp3N2ZinS9
	tUZovZILwsgK14HCaH/y7lT/7jZFBsY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lV5H0KZx;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of almasrymina@google.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=almasrymina@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757980297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+AW5j7gH90N0KHAK5Rp1VJX/iqgngX55U8vMWYrXM/c=;
	b=Fg/hpvgPcKp9d5OHc2B+uc4kR4NFqGIUD6juDX+UTpfNtxrkVsnOgr2nQlDQy1eI/x9xfa
	4dhR3UkqzulDJkFuRYNAEpoxWOYVSN+r/lC9LuU11vkanwmC3lzpzuEssuobqEVBgNAaEx
	z4DJ185Qo99cZzJQp+EZgRn6JRy2DsI=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-560885b40e2so3993e87.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757980295; x=1758585095; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+AW5j7gH90N0KHAK5Rp1VJX/iqgngX55U8vMWYrXM/c=;
        b=lV5H0KZxVAYwEMyGuHli11tLDk//4txywM4zRbSVmXR8Aod37Id6qr8DDaMnfPojMp
         ZDk0NdjyfSvjKG9gWur8oyRnVqG6xHb1Z010CbHq4H49sNEbnlQNg1nG/PNw2MUv/cYu
         VjZYisDyHa2fBobkYS+75SqB/j5pYqkcdQO9xa7uRYya3heSJ3/5XnZOBt+SHgYHBOpg
         CuExcbyP6zodkWfihb4SRPfAxSkhJdlgZk1/XzWsJmPvvzF8MxjcRBBr3VS418Q8NfsQ
         uOgo/w5aVkzoyJvfiksTmUzcffbRfYV0udfgBsmrMUm5NF0QBIP1UIAa/MsmjLexz6LN
         21fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757980295; x=1758585095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+AW5j7gH90N0KHAK5Rp1VJX/iqgngX55U8vMWYrXM/c=;
        b=MPvoheCx/OBeho7djsECPxOY9gRfy2batLhYpYdgjRzJ4CYVnmZbtV46i+lwRk5VJp
         au6WIRBiQMrU8If/m1XgpL0N+WlvL8a6K9K5bAPwVKNrR+BImxAQJfsVsB52EuNC51OS
         cH1siQFff0kJGNORgTBX0oJnQmFIwR19gRnw41y+J1Pd3hhaxhO7HdzTGVvTWzh6f7B+
         q+HQPkArU1K8m07hvy6NIoCSMgm1BVKjO1WEwzvB5ERdulZXdPjzBvYRPZwNnsLc5j23
         +l0dQHrTC775h7QzsSQ9E4XF+aSG9/3zVuoDgSykTDBW0yki7mcyHbAMxnb5BldrlBcH
         HtPg==
X-Forwarded-Encrypted: i=1; AJvYcCUwGVe8iFpb/IjZ/fUCtTiVrXa12GVP+Pk8P2D1MvYFi54wnfEOkWDGLxKWjvIduimIHGhPCN4/Ag==@kvack.org
X-Gm-Message-State: AOJu0Yxk/Tz3r3y6UYaYqTUxzhq5Dy189oUPTfx+87SqrLgX75Uz+MUd
	bvkRv9oXV7BgCebY5S4CJX9X3ZirHEWaC4oyXImNUmovd/6MKdiiXSeq4jZVGQRKO8al85Y72HQ
	chOyGtxMz4uz60ejA5hXTpE2525bvq0ETVWdZZqhz
X-Gm-Gg: ASbGncvR0FIV1VAvNL9vPpcZfjZbtjmnfegvmqnnB+SxwCJEAGhr9cbrSo90S/QLV9B
	jZxQ/FxKRYcvu7fat1zDM0jkI3XqgY/3c5GyLmGAu7sqTwhQk09QibEZBkBBu2sp/1qK7TKHz8W
	SKBBcEgC681dtOOAI/MlFz0LaUAUK4BPGXwnOs+YoHZCEAsHtKYoCcQyNY1i38i1HhMxEEjY58T
	yNFXbHFB9s3dUnnuLUSXYYLvmSe19Mp7C3lQzfQmKlkqET+z2amuNM=
X-Google-Smtp-Source: AGHT+IHxvjAgcwmbl7i4qIGx4IZFATPmsddKAtgs9jLnh4/bbrdOaxSwmwp0X3FOGMej3r5ilGUywPi3vDMfM91nRr8=
X-Received: by 2002:ac2:58eb:0:b0:56c:8abf:2f84 with SMTP id
 2adb3069b0e04-575f17cd140mr128995e87.6.1757980295277; Mon, 15 Sep 2025
 16:51:35 -0700 (PDT)
MIME-Version: 1.0
References: <aMSni79s6vCCVCFO@p100> <87zfawvt2f.fsf@toke.dk> <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
In-Reply-To: <f64372ec-c127-457f-b8e2-0f48223bd147@gmx.de>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 15 Sep 2025 16:51:23 -0700
X-Gm-Features: AS18NWBQSIQoWON_0Lqkp-hzdof6vglmBL66-QqAsvHEfvhsjjn3e7ulAH9_zlI
Message-ID: <CAHS8izMjKub2cPa9Qqiga96XQ7piq3h0Vb_p+9RzNbBXXeGQrw@mail.gmail.com>
Subject: Re: [PATCH][RESEND][RFC] Fix 32-bit boot failure due inaccurate page_pool_page_is_pp()
To: Helge Deller <deller@gmx.de>
Cc: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>, 
	Helge Deller <deller@kernel.org>, David Hildenbrand <david@redhat.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
	"David S. Miller" <davem@davemloft.net>, Linux Memory Management List <linux-mm@kvack.org>, netdev@vger.kernel.org, 
	Linux parisc List <linux-parisc@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D6CC160005
X-Stat-Signature: 1yngc7tmjyimbg15tcjbbbe6dto7eou4
X-Rspam-User: 
X-HE-Tag: 1757980297-13963
X-HE-Meta: U2FsdGVkX191HTKQa3QlYoQWd+BO5RUnbMEvK85RFWRZ6HtlsRgQrx8VjiNFNHggeVYp8vkHk5azszoqhOS600XEogYKVUEr3US7CShiMpNau8BjlU5UHmsrY0BB3E3cWZkhUgNYZsZQcwcub3m0mr/HP+e8uKBS+6J6eoysGc7VlXcifY0dRffFHlgbBRbYd+JPXKEjYcfrPgB80BoiVze+UZ4UF6HixI1HKMNtQsnrWFyFp5zO9PJhhHvzcizeu2n/zyNiR5/gEeDXDrnWA3kOJW2LYW5HnaR8kjH315rXDUXL/oOUAuh7nMV1uQBVNUmYzzBi0tqPNY6WoGwoAFBnNMnyjVASwMPXMk9ULTFyWc2KHdL5dwSViCIQk12vuiudsFoOXZ0rchIpktxAeyUM9gEpjVK00mykcbMrWqtVW80y7bzrKddaUhInidSFg/wY9IDe5z/3zQw6dbSNgixwCntZW3/LZftKCHKEY4OLJQpBdFLlwW5KE+undVLIE0YscpcplzTWSCPOEeU1LwwFCpmd5e9xunNmYQc2EfvUN2FxqT2HhQ1DWxjOj3gfEpE5CVYSh5hJJ5AsJinjNjIMxZFGLjAQcbiJn/mUzPBmumCB2CFTQVD+P0Dxmyqdx8q5Op+3yk9QdgrwHP0jmY39zDBlpqCPJdoF/5pDxNoKJC/zMtgXciXYO8qZO3N2cdXUvt5jxfExTYkQ1cQIoXhDP2WwtwiuPDKjP1i/gHF2XwXRaJqVzjnMkXV2oS58oyPUjWBcBAx0JhToVmDSLiUlU5ToEDLH9JT+v+XdrXE4M3r9jSAYFwTmFQhCJZ7danmLKgTs9+MxfpyjagNNEzKnEcRTM9n22fdrifVtmCWnPKDhxcj52GWDn8/RE1A01MF0MCpx/a3CIelEOcoRQofdECAzQM3SFGIqkheW2GWzIhZ+VfkyW5aZABUO7oymNFbYNYFz+uuu8YSWVnv
 BDUwXUdI
 QHiq2AnZYJdE1Hwwon3uh24OV6GCrW3K+gMCTgJsGzVMxygtCmBHGwNh4DDLg19hyGdQh4yihAQ5sP+O2pT1qh8bedDt0Dqc6rERIl6sF53rlWLiS2/p8e/SzUNK7gIEAFFDMEcx/rYk2dU28DjR2q3lwMDYXBMXz/ZCKAJIIt+g92m/xo1qy8r0dLeEL9RIdyiV9nGKg2dIw6w1Xg+IL4n12yxlm37P5MLXXFhUSvTs0DFUKzjrYHf9MN1VbasjiTLo/YAry+di0Meg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 6:08=E2=80=AFAM Helge Deller <deller@gmx.de> wrote:
>
> On 9/15/25 13:44, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Helge Deller <deller@kernel.org> writes:
> >
> >> Commit ee62ce7a1d90 ("page_pool: Track DMA-mapped pages and unmap them=
 when
> >> destroying the pool") changed PP_MAGIC_MASK from 0xFFFFFFFC to 0xc0000=
07c on
> >> 32-bit platforms.
> >>
> >> The function page_pool_page_is_pp() uses PP_MAGIC_MASK to identify pag=
e pool
> >> pages, but the remaining bits are not sufficient to unambiguously iden=
tify
> >> such pages any longer.
> >
> > Why not? What values end up in pp_magic that are mistaken for the
> > pp_signature?
>
> As I wrote, PP_MAGIC_MASK changed from 0xFFFFFFFC to 0xc000007c.
> And we have PP_SIGNATURE =3D=3D 0x40  (since POISON_POINTER_DELTA is zero=
 on 32-bit platforms).
> That means, that before page_pool_page_is_pp() could clearly identify suc=
h pages,
> as the (value & 0xFFFFFFFC) =3D=3D 0x40.
> So, basically only the 0x40 value indicated a PP page.
>
> Now with the mask a whole bunch of pointers suddenly qualify as being a p=
p page,
> just showing a few examples:
> 0x01111040
> 0x082330C0
> 0x03264040
> 0x0ad686c0 ....
>
> For me it crashes immediately at bootup when memblocked pages are handed
> over to become normal pages.
>

I tried to take a look to double check here and AFAICT Helge is correct.

Before the breaking patch with PP_MAGIC_MASK=3D=3D0xFFFFFFFC, basically
0x40 is the only pointer that may be mistaken as a valid pp_magic.
AFAICT each bit we 0 in the PP_MAGIC_MASK (aside from the 3 least
significant bits), doubles the number of pointers that can be mistaken
for pp_magic. So with 0xFFFFFFFC, only one value (0x40) can be
mistaken as a valid pp_magic, with  0xc000007c AFAICT 2^22 values can
be mistaken as pp_magic?

I don't know that there is any bits we can take away from
PP_MAGIC_MASK I think? As each bit doubles the probablity :(

I would usually say we can check the 3 least significant bits to tell
if pp_magic is a pointer or not, but pp_magic is unioned with
page->lru I believe which will use those bits.

AFAICT, only proper resolution I see is a revert of the breaking patch
+ reland after we can make pp a page-flag and deprecate using
pp_magic. Sorry about that. Thoughts Toke? Anything better you can
think of here?

--=20
Thanks,
Mina

