Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86D3710AB833
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EEDD6B00BC; Thu, 26 Mar 2026 19:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434F46B00BD; Thu, 26 Mar 2026 19:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D636B00C0; Thu, 26 Mar 2026 19:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0EB6B00BC
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:47:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6E53E156E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:47:31 +0000 (UTC)
X-FDA: 84589853502.09.A3E818C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id 054C0140009
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:47:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gx6HL9cR;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pr9y5GUpJNJd3lJNisErY3ZYebErxMfV83dXNcOOSLg=;
	b=FvALchaPUMWrroAO3NGypscHHP7cptUO2rpwF0+nDuklyFu78M5wLlmBWPof4G0lsiwWqQ
	a4iCUbj53MCDZqzwuBKVpKCveGN+fzRS3RY2aTY24RJ+MDFxWntFkutPPa5HIbM5TnT4ao
	55KP9t/6owRH/rY4bvN2f6bMsVIVqfY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gx6HL9cR;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774568850; a=rsa-sha256;
	cv=pass;
	b=LhXVEi3UxQ7NVMrkKzq5QsRuRRafUDar75PtIdts88slJYrzBKffTu5KQJoNzCCdQ7vaub
	CP0jdJ5ioexMEac2mN7pd8bZvmckrAOLoBedtRsFAd2xIHiT3sKrFtYCR8narBrIgQ69Li
	WV77NVS0zl6VzFGM61q2a1CkhTtnBX0=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-50b6c45781aso245621cf.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774568849; cv=none;
        d=google.com; s=arc-20240605;
        b=iLEx7AUseNHclywLSRG3EXS8TU6pkfKVrDoOAh7bIvPI7d3G5s3jiTu9El9xev1/WW
         lqttqUg2QYSFBBrBzhnTmy1EcuHK5F7sPiHaGZ5Bc0HaPBq+Hf+hQUB+T5+DbXPPWQlF
         9g81D+rZpSt6agzuaf0ftIjHyaXmh0Gnc8OWmZaRnMp/i2i8MQ6koNUFMit/rw8VUIfi
         uc3yeb8Q/pZYuD4IipI/+NPD5tVo75+58F3cGh6ZvhhuC5IDw3ystANz29VCL7CNg+Av
         ACbt9hhZ2MdrxMfyDFGXlOoLFnKP8z5IlTdXSaP/KVvONt92GHN13vSY5tHxqXSrj0xh
         csbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pr9y5GUpJNJd3lJNisErY3ZYebErxMfV83dXNcOOSLg=;
        fh=hlJFR7/ht4DZtXOtLjo+bEV9hYXxg/U9NIVgwxpULxk=;
        b=MpaJRx61ZhHlNf0jjkEm1UEgYqYvDZGidN+7dJ6QHq98p8Ykk40Z7DSl5VP8A2JpUT
         aM4QpNE9dT4LYgaabkxLTqbGRH203WU1iKizWjvheCE9jlhdqM9KoLrDn9j5gmZ1e2au
         5uRPHSOjG1xIgWithpiGu6aELoYGy1z0jNCbsQo7pPBywad3/kESYs7PAv+CCWQCZNpk
         DyT1UcTBVWpxLypmU0AVmnD8SiNTty0bX4yhKF72xVO92hcT8FzPMlUfEAmD7n2Pw1In
         BUMdOAqztnyUGsELFNZVctRxPJ6KNeSxxBeV0vWXHqZ0TKJmvwVCPvj9rKxH3x/1n7Yl
         +zYw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774568849; x=1775173649; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pr9y5GUpJNJd3lJNisErY3ZYebErxMfV83dXNcOOSLg=;
        b=Gx6HL9cROsJQyPj5l9K08VlvNFKVGgi/EFz8HUUxyKfGQ0iMPBdHC/tpFbdQpFgUmN
         6wRX+726gYMBugbGwfu8A1t2WnaCbolTeNZ4NskSAzULkdSFUZhSWkw+r+0LralQAlEJ
         WsO8NTesJU8GXNVRms4p/dyuqxJEsPo40vnj/VTBm9gCmxuV9B6bZKJgqFTHiV3kpq8R
         gV+2NbtX7O6EVSzc/iTjUSn9bPLTBdaWPfYjxyoCzigCnXKxPFOuCIMWQe4ibQyxbouZ
         l8qUF80ZgVvZRT0pGsKQmp5cVlMpurdOV9ozw+efqNrBha5hY2GJWGlfCBZL1lXdRSRT
         OJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774568849; x=1775173649;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pr9y5GUpJNJd3lJNisErY3ZYebErxMfV83dXNcOOSLg=;
        b=p+ToMA30+pdP89offeZVoHYpkfGMpBxRvE4z+9wO+yf3Q0j/AyHoiEjkSP9zZBbEr2
         fj9LRtEjTpLfYrNhmJhLU3NyQ2p3eUF8kt1eitREGELSb/3YXbxwkylSP3iAU9V34Pe8
         UB18KL6IHZwYpGDkfAr5f6427LHohIr8Pn/J1ZsTakv+snh8TgY7U+WBAvwXckzs+Nzx
         zcfPQFNgtACxDFZUZOvHiZSEClk2p5smaArYPrUWM/kZCuBjbiqfs+iofR3QP08nm1H6
         qbgW/UVNtJVCqFei+zKOtvfHkKqpGRr4USexyf9Ij86/+2EcMjjMnT9z5BxWd+R1OS1p
         ieEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqvrLJ+yXrowfMnd7niKD1olKbSW7evsXz5hRYqBLOI4y3xUckUed/h0s/sTsIRtj/azxJ1bnnag==@kvack.org
X-Gm-Message-State: AOJu0Yw4bsWKlmb5w3rtOGlVOAKUvRX0wu8s1Bz43nPcnKOzpdeTB5Nj
	IFbd02ATfxDEupNgOUNDak+CV+YXRDc3U+zTzLIpy9F6qv+Mx4MIxA/GycPMu+fV4TQ7u9JFHuC
	BMjFjMVOszAVW11kUcnWvXsCiA6nVHwDmM9MN75SN
X-Gm-Gg: ATEYQzwiwQ1P0sxVlG4ig25Ti2xfNhqAC3Fl+e1GoBUiTlUYTfEeeR2j59ga/fTzTrp
	XW0fXGBB3Bkts6gIgowW8NdxA/59jBlpxINCZwiVstKsW7Rb+amaDOckZiy/+/MyQChy2fHpYnY
	JNyrqPQVDSHMZ6wEN3EVc0LUqLs+EF5PptgOnwjqQuYQirSwvSl5LPW7euUNOkQx8JGBaL5sAoJ
	hZsIM4JaBE0XmP84vD0o60YYZfVaO8TV9F3BobO0BjjXzFP6rTLf1salCariDC4BKnI7/bZ76e5
	6bmXTQ==
X-Received: by 2002:a05:622a:410b:b0:4ed:ff77:1a85 with SMTP id
 d75a77b69052e-50ba32b3844mr3518131cf.17.1774568848552; Thu, 26 Mar 2026
 16:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260326185629.355476-1-ljs@kernel.org> <0d4e27a2-e9ae-41ca-b327-82296cbb0cfb@kernel.org>
In-Reply-To: <0d4e27a2-e9ae-41ca-b327-82296cbb0cfb@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Mar 2026 16:47:17 -0700
X-Gm-Features: AQROBzAP34vExbpfWo2dLEeB0ybfadM56WymYljfbmpaPr0DtTjwJeOPX-oZALs
Message-ID: <CAJuCfpFY311807PpEP==UKBLqXXDENA3WjXuNnXMpKaOE2JQtA@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kalesh Singh <kaleshsingh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 054C0140009
X-Stat-Signature: o7o8yt87sawm8y9okkwi3swus4gzw9ko
X-Rspam-User: 
X-HE-Tag: 1774568849-907000
X-HE-Meta: U2FsdGVkX19/bCADHExVR49cSUj1pQEH0o0CEJG6iucb+yrup5NLIYJ8G+t1PE445mAyroFgvgt4cI7VjjNMdEMH3yuKGg6X2z2UU2O/0PQerffHU/0sXbHSQBlr+x7KvVAKyEUkUor5I/+/i/Nc170vthr2fSxGWDR38YmQlNkZ2rxWh1ifPYLE00Un1t72g6G89OWeoucdKwTY90FkI6CPAfzSAMG43EzTiuwAXlCgHloWgqKULuEouSRtkcHKRPktH5ddHDVxPObctGH/O1KsUz93BCl179IMlHMQqKXlG0WLMA7Qktmfz7zw4hZgoHvfTqTLYq+CWhGi3Tn9H4FRohcH2efr9ObbFnfg6OjtuXCbfBdy+8Yj3XH+eGM398XIWurOp7QNglTP3fxHTad46KJcv0PcZjtBKJXb8t7bAod3Bf9zSP6cugDeY+5m2W7VDkgFmn57WC9ScCs6qoNRolgTyRHjPy7P7q1s0r26hQDpGLXTndJesHmpHPrgTyvVw/KLaHhGqD+oQT9kuYKfNbeVU+SIqiqVJYtvmSdOV67jiTsAou3H+kQWux5k/glwfOAd/dLGBEAYR7uR85YGNOWv+dgzQeXan5pGALZ0T9RK6CynLhZUpUw9PymQHDgyYiL2KS/NF3K5DGPhqMSvZr0yIj5pe1xEYwYLzFUzvvi+x2qUSgLkMERGB0MgSoyv3or+18y0jFdfe4KLZe9Lf1kCypP1/drDhxszMDxwOL40yU44c2Jwolebwbt5Hh3Ambi5LAe5pm1qB/fuYc2dXm6cuCLHPy/ZlAfA0ccz7WwC98TE9H4X+DEYNWFBTx0pORaFGauifjOjUGyGQxCT7oi+0CU25EzvPthqijAsrU5WX05AOj3fQnfsnxyocEh1jT4I8L2YNQweu7A6Yyj6zIqHY9MRgKUfL0qWl2+/6eWbZhVopzNmPWWq9IXpoVVDYPsdYxHTJGK05Iv
 EdRQfMqQ
 CcBJOC2xQP8zDJ469IQ4vyhqA8SJniyEpZQBzZ5xehyQ2vumL2aoCKzgZjES26TmW+tXdleNhqvFgfE4QO9MZcSnopsClGIy5I+Iq4cfLYhYR/tIZonLZkZwK23uOYqfE2H/DbJVrQrBiZ3Ffn/9H3JluJCS9Bd80xKGh3K0GdJgvy/SvGXoac93ylqEjYZmQCvFk0V3R1CeU0aavN3PFPvsAh8o/YV831cM8kIbBYLMGCNzSIVTBzt+lBX0zownrIQvv3aDsO75gdjm99gUit91LtFsBPSh/VHJQokgBBS6Qg7+qXN7GxOeGdmRMa6Mb5HM1nuIj45rDqxqPYfGpqhkDv0U9pLDSoROkvWWeutaxWKUw++0N5yOjBaQT8kJgB9OJeA87Z+jg1pXFaiq6kNYbtjPUMDvZj+eUCTmCXLstuxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 12:09=E2=80=AFPM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> +Cc Suren as IIRC he mentioned some intent to look into this as well, in =
the
> mmap_lock call.

Not myself but I asked Kalesh (CC'ed here) to get involved in upstream
reviews. Kalesh are you ready to be added as a Reviewer?

>
> On 3/26/26 19:56, Lorenzo Stoakes (Oracle) wrote:
> > We are moving to a far more proactive model of maintainership within mm=
 and
> > thus put a great deal of emphasis on sub-maintainers being active withi=
n
> > the community both in terms of code contributions and review.
> >
> > The MGLRU has not had much activity since being added to the kernel and=
 the
> > current maintainers who kindly stepped up have unfortunately not been a=
ble
> > to contribute a great deal to it for over a year, nor engage all that
> > heavily in review.
> >
> > As a result, and within no negative connotations implied whatsoever, it
> > seems appropriate to downgrade the current maintainers to reviewers.
>
> Seems fair to me.
>
> > At this time nobody is quite exercising the maintainer role in this are=
a of
> > the kernel, but there is encouraging activity from a number of people w=
ho
> > are trusted elsewhere in the kernel, and who have contributed relevant =
work
> > or review.
> >
> > Therefore add further reviewers, and at this stage - to reflect the rea=
lity
> > on the ground - we will not have any sub-maintainers listed at all.
> >
> > Each of the files listed are shared with other sections in MAINTAINERS,=
 so
> > this doesn't reduce sub-maintainer coverage.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> (I assume the newly added people will ack their additions)
>
> > ---
> > (Apologies sent first version of this without MLs attached :)
> >
> >  MAINTAINERS | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 76431aa5efbe..16874c32e288 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16757,8 +16757,12 @@ F:   mm/migrate_device.c
> >
> >  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
> >  M:   Andrew Morton <akpm@linux-foundation.org>
> > -M:   Axel Rasmussen <axelrasmussen@google.com>
> > -M:   Yuanchu Xie <yuanchu@google.com>
> > +R:   Kairui Song <kasong@tencent.com>
> > +R:   Qi Zheng <qi.zheng@linux.dev>
> > +R:   Shakeel Butt <shakeel.butt@linux.dev>
> > +R:   Barry Song <baohua@kernel.org>
> > +R:   Axel Rasmussen <axelrasmussen@google.com>
> > +R:   Yuanchu Xie <yuanchu@google.com>
> >  R:   Wei Xu <weixugc@google.com>
> >  L:   linux-mm@kvack.org
> >  S:   Maintained
> > --
> > 2.53.0
> >
>

