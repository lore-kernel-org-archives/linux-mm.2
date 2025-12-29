Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A231E92734
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 15:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D60D6B0088; Mon, 29 Dec 2025 10:47:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984056B0089; Mon, 29 Dec 2025 10:47:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 890846B008A; Mon, 29 Dec 2025 10:47:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7891C6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:47:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B748C01AB
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:47:29 +0000 (UTC)
X-FDA: 84272938218.22.EAB2C26
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 742ED10000F
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:47:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cwf+fZWW;
	spf=pass (imf05.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767023247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ywa9dnmu7fxspOMuzlqfROXwMTQRNGZ09Fujhkcl6sg=;
	b=ZhlCoxjF1ljUV1DjuIr/zHYMV2mMsh9ZcYH5Lr6WnzUAY+LZ6VHX6gRNEIpFzEQnk8N6gL
	GtNmndqfQgqSFSlZPE71d7/CyzkjlhFxoofCaox+n7UwCBsU21HVUAaY3+9QBI0UfWjm1+
	luEaRU0UltVVNpzjeHMh306jYWXfCNY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cwf+fZWW;
	spf=pass (imf05.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767023247; a=rsa-sha256;
	cv=none;
	b=4GBSACFSnJ5gO8C5/Cq1dCYuUHjavFUKUDvJS5q7yuZah/fRO/omEnrPuBcGe3RVT1Fuxi
	uOyBAs09lMyH99VNdq8LqFjEeJqo7dEKvdXPFxnFslWWlCyNAjv97Cvh3bdIVkWAQKvOB4
	NHsk8z+Peh2FaHqsjYyxYPIUFXMWDII=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b736ffc531fso1668635666b.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 07:47:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767023246; x=1767628046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywa9dnmu7fxspOMuzlqfROXwMTQRNGZ09Fujhkcl6sg=;
        b=cwf+fZWWLFJbKKlt2sTG7ZaYXBb2muRc4mPU/OSv1e2Ekl2cmAJumajYrAEn6E3GM6
         ifoYYwysa+vFGzfcyD6IWx4bn6r4Fy2jkunxxSQZdEiVAnxeja6l2A5uPD+8D/GNcGNY
         XYmcjMesXI2hwmlTfPiBwOtgKD6/jBTHdRcTgQ7PCTQpl8Zq12k0jgNuVtacEFnFKILI
         sRQyZN/HkCZHWR8DJ2mCYvVKWQ5HZrPr4qYFW4V9hXITtaryoOHcnrh7C73KjhIjOgZU
         7sIQ0Yw2hCsauiujeLlk3kTCm2ozs3q3D756Zzrjr5E784YLMyTHxgpBl7S6dShoLt/B
         r9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767023246; x=1767628046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ywa9dnmu7fxspOMuzlqfROXwMTQRNGZ09Fujhkcl6sg=;
        b=eF8ovtAXCCW2ij7sLRHq/eaWr44c60JWEFImQN4HIeTQWiBSLPnBnjmEEeQ6qB0XFO
         /sTV9ZJ2+3UlAmmGPX51YeQ2o8vuiBOaQNCEm//xsq8l4A5XeENpzI2QzIOCY9/Nk0Eu
         yXjWWgYpd+f7tQ0w6tw+UiuqvNIoDPpmGZQqq5KP2slWOARHcM3PYcAtgrQTHLlJi38I
         txHu4odEObhFt96AAhNU7VlCgKF7nNAEZjCgqwv+x4znAOCdQTS77drzkaar0phCaAQ3
         vis3nS/dtcN1YB/1sfL3kg8Hy+aCRavvwy0Ab0fH4IMMPFLUf5+tpltDfWX4pBYrD8zB
         zvvQ==
X-Gm-Message-State: AOJu0YzWExYm5swpjBwvk+kgX2CFfvziEeUa5+sGTCOoCEAAPEjX6RgW
	5JwbT2WFlMkd3F2X/9TT3sBV403x9y24G58bMGjp4dntJPujd8TOUiIA0ODMkmNDcisfj7kYN3W
	FSbdGt3ojH99p9HGgWIFfcTthPQC0w6Y=
X-Gm-Gg: AY/fxX4XKMnUwsrG7aN+1wdNgySji2yRnBhwLTO6YeNLtgwQyOKCkyT7GP7w1nr8L0Z
	K4CFbVYHr7RiJ9aHWbQGqzAWgi5gbnJRKF/07HZivvNU19OfchnW+yxN6gv8wcLnQ7Gny8qgnKn
	9PBLTxd8biIpXRc1HudFmTerM6EFfureUT5d0+yirIH7UKyiqWb/HdymdHg16WcsyYEbXH3s2ks
	MjLq96QDQFdKfRjAzLOpt0D/xK9Eu8oztKpN4dh/4Jd+4ZJ99vvuA5cjqJmt7xWFXQC
X-Google-Smtp-Source: AGHT+IGZ+s5SHenOW4Vly2Sb0Y9M5ta14fOzV0S0fjP0IbhEzicJCemv5U6jH4FST7rpZ/twm0j6iBIdeVj3FmDBsKk=
X-Received: by 2002:a17:907:6d22:b0:b79:f965:1ce1 with SMTP id
 a640c23a62f3a-b803705df6bmr3307019866b.42.1767023245550; Mon, 29 Dec 2025
 07:47:25 -0800 (PST)
MIME-Version: 1.0
References: <20251220151019.19473-1-klourencodev@gmail.com> <aVGLfmQJf4BPDTUq@kernel.org>
In-Reply-To: <aVGLfmQJf4BPDTUq@kernel.org>
From: Kevin Lourenco <klourencodev@gmail.com>
Date: Mon, 29 Dec 2025 16:47:14 +0100
X-Gm-Features: AQt7F2qHNph7awGIazVvhT9O8t9lqmAwXQ8rcxtnj37strCnccnAzIFxse9g_wI
Message-ID: <CAFveykPnTH456rMSRgpDO7VyN2EdP6eOq3pKUBCDdQa1kAJ4AQ@mail.gmail.com>
Subject: Re: [PATCH] mm/memtest: prevent arithmetic underflow in end pointer calculation
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 742ED10000F
X-Stat-Signature: d1mx31g5gmyh6xyfbn81pdc3stpyf45y
X-Rspam-User: 
X-HE-Tag: 1767023247-975293
X-HE-Meta: U2FsdGVkX1/egNU9yUxHvKIkDDTsL6w3XYiWKeUVizb+dur3Fd6lqJgoyh7WkCbh1N+IhD1UX1uy2iGs7LlEi7mal1bw1W8ibzmsTyyX14zrmilSeKjoDIpuvThMVBfexqAwwwCsvTvQFSIioVpinmXq2rPkTPdYTa/e2AnGLXJa/s1zkk7TcWhu+V2NpkeHGIgmbVRVOke6ffBGeE5cNZzA9Q+iFz2C8bLIj2IOkiu3FuWJNndDLmxHHOUQi22Mhkj4B2qDAyiy7GJn8gJfe22vstaf1ZHvQwio+O6fqu103H72W7VPQT7Jed4Y/0Bdfgbv6Nop+m+leLvvSDwosv/KBbFK3dukYZ9qAYuykMnm3MsVk2TerLZIissAHJlEwmKuRORAXY8gdb/CGv84tqYMwOp0oceqyO1Zxa02SUC0VoD8Cj9ofSpcr+vJT3O58qytNXbLun1e7+BQqrLC81DFHzceqyMEKQNQ4hZd6emNLQ6ENFUzq3CH7LNyPa9wO829ZTVYgFv2rCiSdIG581yCh+YxybkEyHTgptesEORNC4JqNePYjvX5kQhm+Y47xFItkCyIc5wZqgdeL66qw5l+VTZIizN7RNEUcqDXa77nkyQVWodeUB1VpaDld2ndUuNDZYMnA/BtFC9Xo2NiroadY3nX+9meeos9tpaZ/fv5QkVMtNUscnuNROIhpRLkdTleV1VpUjgHF0gvQ7dzGSKtTR5L/TkBZdfNXjsh5dXmanj1nyMyPzg+IyaCyXkpmADCZjxCBXAfb1IWISEnAL8FZexSkFTGpqqDeScgAhV1SiXQr2lqi2NaDXI/QPdogR5rOXDvI90Vrafov4Hi4jC5uh8VcM4yK3vYlq6sdkXJSwLXw/wrnRLff3gptDcDzV75pxSmCRZB/ksVRfXbj/+NSc/dYymVTKS8LLzH/zo2Dse6ECb2IEVnUAgLjwxW1cS/hsnNfeLxhn7C1xp
 8ZXSJsai
 Nguo+BopLXxsmufspXssyyhq73SAvsfKjQZXPTfIo/BJFbUOIET2+UjdR+BopkqCTzApHdmSNULvOHtg6woN4Y/MnEY5X0n7Yr0ud
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Mike,

> Is it exactly ~0?

Not exactly - it's UINT64_MAX - (offset - size), but since offset
is at most 7 bytes (from ALIGN), the result is in the range
[~0 - 7, ~0], which after division by 8 still yields ~2^61 iterations.

Either way, if it happens, it's not great, WARN_ON_ONCE usage sounds
good, I'll send a v2 patch.

Thanks for the feedback!

Le dim. 28 d=C3=A9c. 2025 =C3=A0 20:56, Mike Rapoport <rppt@kernel.org> a =
=C3=A9crit :
>
> On Sat, Dec 20, 2025 at 04:10:19PM +0100, klourencodev@gmail.com wrote:
> > From: Kevin Lourenco <klourencodev@gmail.com>
> >
> > The computation of the loop end pointer can underflow when size is
> > smaller than the alignment offset:
> >
> >     (size - (start_phys_aligned - start_phys))
> >
> > If size < offset, the unsigned subtraction wraps to ~0, causing a
>
> Is it exactly ~0?
>
> > massive loop iteration that writes far beyond the intended region,
> > leading to memory corruption during early boot.
> >
> > While unlikely in practice (memblock regions are typically KB/MB), cost=
 is negligible
> > (one comparison), but it prevents catastrophic memory corruption in
> > edge cases.
> >
> > Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> > ---
> >  mm/memtest.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/memtest.c b/mm/memtest.c
> > index c2c609c39119..d86c41f1c189 100644
> > --- a/mm/memtest.c
> > +++ b/mm/memtest.c
> > @@ -41,12 +41,17 @@ static void __init memtest(u64 pattern, phys_addr_t=
 start_phys, phys_addr_t size
> >  {
> >       u64 *p, *start, *end;
> >       phys_addr_t start_bad, last_bad;
> > -     phys_addr_t start_phys_aligned;
> > +     phys_addr_t start_phys_aligned, offset;
> >       const size_t incr =3D sizeof(pattern);
> >
> >       start_phys_aligned =3D ALIGN(start_phys, incr);
> >       start =3D __va(start_phys_aligned);
> > -     end =3D start + (size - (start_phys_aligned - start_phys)) / incr=
;
>
> I believe VM_WARN_ON_ONCE(size < start_phys_aligned - start_phys) is
> sufficient here to detect those theoretical edge cases.
>
> > +
> > +     offset =3D start_phys_aligned - start_phys;
> > +     if (size < offset)
> > +             return;
> > +
> > +     end =3D start + (size - offset) / incr;
> >       start_bad =3D 0;
> >       last_bad =3D 0;
> >
> > --
> > 2.47.3
> >
>
> --
> Sincerely yours,
> Mike.

