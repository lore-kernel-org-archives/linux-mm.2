Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF15D58E62
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 06:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F03F6B00B0; Mon,  2 Mar 2026 01:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394986B00B1; Mon,  2 Mar 2026 01:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272066B00B2; Mon,  2 Mar 2026 01:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16C1D6B00B0
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 01:37:26 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B92BC13BC88
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:37:25 +0000 (UTC)
X-FDA: 84500166450.12.14C3E6C
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id C595340002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:37:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QJXqeCYQ;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772433443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IDl+LWJ8AHh+JYc7/ewc8jtBLdZAOdgB+rr0WmQONk=;
	b=c40qkx7+9MNguO0n8+Ugck6HKhacFG3MIlbUr+wN6p5rdQL7WcZXpXS+kqZ7VVsmxL+WfP
	eL89yPH+naL35GJU+86vX5biqvblZG+x1Y5qobB9X00RNd2J8y/hC6z3t5o2XumSWgO53Q
	j+y/YyfaDZ9ueT6dV//CZDkHj7dqEzQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QJXqeCYQ;
	spf=pass (imf11.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.47 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772433443; a=rsa-sha256;
	cv=pass;
	b=D7HhvTvVyC5bc8O3qxlrX67BMbmcCAcsPFFUDCEMU/zplEDfKTrBuCPEhsd1T9hZhuCh0U
	sP4OzrP8PhU+y3bCv6sTj6JHUSAVkIohDZyxUtmFE+CqBIGPNaYNWKgu4Y/lt7uyY3ZSh8
	YtugmaBLZneLik3aa6jOEAi1OAZVMqc=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-899a5cb04f9so52726886d6.2
        for <linux-mm@kvack.org>; Sun, 01 Mar 2026 22:37:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772433443; cv=none;
        d=google.com; s=arc-20240605;
        b=WBU+818BuRPvmJ1+Mv3m85hZUwLMnWGCxtS420mSqMs89q33KKk6wAUwVUNqxHcEUy
         ZiXSa3UZqckvaId1tP4r7vBCE7RYeGuIu0Kwj6RcfmuFlB6t4y0mefeW1blIPs2CHPJp
         JBRjJLAX6vlQ427w+bb8j/ni5Oez40v087y84irw+vlT56EX9pcR0ouIRkzO3620MGOV
         Dfwbtyqwq984voex27N5LqZOTOCRlW/4YYnlC0u0KY2sZVTzo4c/iKtqOY52Mrpr4d3s
         rgm0TWjvFgh4dr6fkuRVYtm5gWlziwtol40AzNDQjJuPUhNqo/4CO+MhR46vRGxRy/6b
         iqtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7IDl+LWJ8AHh+JYc7/ewc8jtBLdZAOdgB+rr0WmQONk=;
        fh=h+QUFXV0SIqQDhHQxjm4hJ41yVSoFjdRIoQm2hpnoPw=;
        b=LJpukaXxSDkjkd2N+rckn9WWl7xvIkrPLJxmYeqnofMZfHZhJukCyqihPuDjnJfZPn
         vzmTTmMoBM/nAL+7maDkIZmvYQG90CRoIAnOoM7Mbrol+Rkh+DsZq2QQrv8oocVyFbe0
         XDcYVQCdXZPnWy6+18h6PZj5VHAhKs12RiPdGmUByy6xPfx+VAE74Q7SZ8vVfw3g3zEx
         ZHFAvKR0CWYJugZbylPTapnrMT4Xt8mxAQleaQiEaM5oRl30DjWtlFDVpYuMHI9ea0xZ
         iwRFz7PgPlK+fSTBRkaM89+DkU48p0YEArr6KWzWoQKW2NRm92Z0os1B+LusyfNgSfKk
         ryrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772433443; x=1773038243; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IDl+LWJ8AHh+JYc7/ewc8jtBLdZAOdgB+rr0WmQONk=;
        b=QJXqeCYQWO5EYCj3VVWgIQ56Jkus87W4NQAZXSvaPq3GQKfYsXznmXfpbE5o2kqSSz
         lZxrupLEqXze8USs4rol6OQKD7vBGScTiUjpC8rxCC4IFtM/FZjy1jiIzwwYO4sHomrS
         l7g5yRww03F5eNpN6NMoxxG+E+Ei9VN8P2ab0Thgu6FSIGTv6sx+dQAGgIEZydn8YARC
         Q+27NCDKMXgWyAxxJkauC7xelCekTajacKumyOrEgQUCnih5aRbC5mS2GeoiY9fhB4ol
         Gq0ct78Wk8f6A6v/ACmYAtv35yFmp/einMoYn6otWDutbPPm/bet4Lpt/S1JjiiFuXy/
         lU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772433443; x=1773038243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7IDl+LWJ8AHh+JYc7/ewc8jtBLdZAOdgB+rr0WmQONk=;
        b=t2EwhLYpwSlbq2d/ZhOReB2NQnQMysiTfosbTj3+ceIWvVRubPuYcXuHH/AQ/WSSjW
         z0rUtd3Wp+eeKXAvswjecX3170oCBdHYEOjJ7Ff4A7GAqNsZyN29hZrsFmCrlVbxhQjJ
         IYnZtI6Ytq1zFL1xTOYh1NqlROtGoONk6tvnJX/sfY10P0LFwlY4NtALOuJ/dOaJm+wi
         bxS3hoMe7/B4LQqjveb5kF5jRWdRMLnZnN96vLfdOc1/DiQUNH5lNlX1pJGN9hE/Fsjn
         MldNcZFx7Xo3ZHqYZ1CuH+tBWbTrxkYv2h1JsBhHJfT7K1UNMcj4/il+dxIR0hXcLFZP
         Ifqw==
X-Forwarded-Encrypted: i=1; AJvYcCVG/dFK5IY5tpnuhKt5c0XLgDe7lAu7pj27wFv0nnm7ckMfgQ/FOELmiVDyucgK+bgxPgBroCr8fg==@kvack.org
X-Gm-Message-State: AOJu0YwRR5dErqD/Qd1XkuP10VU4YwaRtZ9J0pXcgBz7/O/tNU5gLlUT
	in0s7SVmtR5YJWgXMoCUk5xdvXrbUQUkUlx49Goi5n89fp11V4akr4vpkjx4t5fmKkeccU1pwif
	XDYrijkGv43Kro4QDAEDpt21xuEIMTM4=
X-Gm-Gg: ATEYQzy1tKCS7hxE5LKn8DDM8fO8xJOTfoNZTuqTNmoalt6ElGKppPJfdhb7MsAHeoR
	o9O6kbCmgELtyfExdU2DY9DN2ua0Rns2ALYeUF102os1/YmkMKLZoXTNCNvjANQ5mTJZqYfaUM+
	xG0iIUSf9Y6fycDiUT8SD7FLjrvEKlaWPYzHbyRLP+SlYxCiRDhPa/JoWaESVitqiNMMOOALj+C
	GcXB5L1NelozLFkBbC4urYWtPJm5H+afinrxkguIuUVXfEYNKgxSh+GhQ7S9Wb6htnIBaQa7CRw
	ZZPYVQ==
X-Received: by 2002:a05:6214:21c6:b0:88a:57db:8e04 with SMTP id
 6a1803df08f44-899d1d723a8mr165013276d6.8.1772433442408; Sun, 01 Mar 2026
 22:37:22 -0800 (PST)
MIME-Version: 1.0
References: <20260228140540.1774748-1-dev.jain@arm.com> <CAGsJ_4ynq76B+qJmtJayB44eRehviCbhBNKu0sdU1NcdiSDVJw@mail.gmail.com>
 <1709a9c1-628d-4cf1-bbc6-00b77fe70f3f@arm.com>
In-Reply-To: <1709a9c1-628d-4cf1-bbc6-00b77fe70f3f@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 2 Mar 2026 14:37:11 +0800
X-Gm-Features: AaiRm50fsAbYRFZRh-wj0iSsJ7YEzVEzX760Q7L0ZcAabD80RaMmcptZg6zJ7Gk
Message-ID: <CAGsJ_4w6dT61CSgR5bdnr_xOdgENK8uB9otShJR6_eE2NyPAfg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/rmap: fix incorrect pte restoration for lazyfree folios
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	riel@surriel.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com, 
	stable <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C595340002
X-Rspamd-Server: rspam08
X-Stat-Signature: m7in1jhucmzsbgbobowgptcy7odn59t8
X-HE-Tag: 1772433443-110000
X-HE-Meta: U2FsdGVkX1+2IAnSAATcgDXeuqkakbGTelDix6EIy4UMT0l5u8X6ND/PG89IIVNZIJEwpDwonNHbRIFCYYRt0EApr1ry2v1PTaot+Fu0wNXGZn+xdWFOh+htXEkhT+FbDEnJoSlWH2HLIsq4AiHRstrhznqX0oapIgkb2l7EbQ1oLXqsxIMnIg9jutQ7cXhIZcP/D3WBBUAUMSDQp53BwhyfuJ/PC70uonY598o4OAb5M961eobLqT+phOSBYOg64W2PowjBWaqjuL+4DO3gaCG12VvnuyhUins5en3BivIQ2YuyntLtQKIWB1XYksKUjIcSS8/mRthr4ol0ilvNbfJTRgT/sLaap++6fZoXL7n4iR8ZFekApDRIjjmO4/sXaOJIjOqD5Pf4BtfB2iwt2RRepf62Uld1oyfk6MiQrqsCEU7F5ZrkTdVQs15gzzYnobwfAcUbAsn2ceh9fw3U7P2qv8EeAZVVPVhDIU/tBv3aZkEie/X+sbaXxDHtJNpTpN0nzcpL/C/lGgzZ72aPHZl3JzguWwsOxJKcNKJdvKHIm/CwhXsLUxXz0X6O9+Ncl3t9MVazzJl34AUptMfUOBBppKeAXFpH0QTcDBCwPtZYQ/SX7sHnGm1dt6R287eWjfRTupHI8jM3GK3ho1lFMPxFgTuaFuG7dj0VmZ3wgqYk/hgo6Pgea+HG81vn/DMzxkgZiSREZpNv2y+C3KKd89mmph2f9KzVwqEICtU8faqEMWtwWMNDCLzD/qGt3akxka9VWkiWb7o+bbvqZIUpDpKDlR0RRrOVsibHwKlMorLb3KwTWlmuceZbodHIlzFtvvgEd6wGdNvCFfgfvTKehp9lOUxurBVBeK1IiFbW4eyTSA5uVC15/5JZYQs4I5D4ha9YgYt2MhHxBwnXl+s4qraO9LXSjqyxErsbzlnO2xS15/JGkkYAvPO19hAK6uotFGrmdjSoYOs5KFkzYcn
 Jn1f8Y3r
 W1QFzi+LwPXDtwB0RAntqfQLq87rBEO4Z0GZpRvVleYhFwCs8wlc5XR170rkWTghlxJRyWyqQRbHh2E9J3nPvN5X0Kg9z6GoaT3SkRNrfHWLYqzqZAylfSvDFdRO3wEScjWfz5AfiwrOsObq2b5M+88quyNlyqdw+A+rJqA74iYVOg+7FKZd5RUlw6BU4n4cobZfkIO2/LagRxJwZkyAKXo0hX8l+uRd82k5hyc3ofN7UvWdvbDTd6N3sU85nv2d9shuV9rQPMGQgOI8xRpaqXAK8EufJkiTy6bW+uk7GCfqTHy79+Id0gs1q59omrHar+vmU82N0YXRdyn1KmYY+PlZPjCAGFhuCbAlRc3EQe3ut0sQHiN4K6HTiHsLGsODbOBGyrP3FRTJmcwvPcZ/naFFQx09rSSWVGXYMBcD0XI+ySqmO+v2jLpWZWaH7d/xnSif0kYln/IegelE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 2, 2026 at 12:26=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
[...]
> >>
> >> diff --git a/mm/rmap.c b/mm/rmap.c
> >> index bff8f222004e4..fb64829913052 100644
> >> --- a/mm/rmap.c
> >> +++ b/mm/rmap.c
> >> @@ -1955,7 +1955,17 @@ static inline unsigned int folio_unmap_pte_batc=
h(struct folio *folio,
> >>         if (userfaultfd_wp(vma))
> >>                 return 1;
> >>
> >> -       return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> >> +       if (!folio_test_anon(folio))
> >> +               return folio_pte_batch(folio, pvmw->pte, pte, max_nr);
> >> +
> >> +       /*
> >> +        * For anon folios, if unmap fails, we need to restore the pte=
s.
> >> +        * To avoid accidentally upgrading write permissions for ptes =
that
> >> +        * were not originally writable, and to avoid losing the soft-=
dirty
> >> +        * bit, use the appropriate FPB flags.
> >> +        */
> >> +       return folio_pte_batch_flags(folio, vma, pvmw->pte, &pte, max_=
nr,
> >> +                                    FPB_RESPECT_WRITE | FPB_RESPECT_S=
OFT_DIRTY);
> >
> > Do we really need to differentiate between file and anon?
> > I=E2=80=99d rather just return unconditionally by removing the
> > if (!folio_test_anon(folio)) check above.
>
> File mappings don't need preservation of writable bit. I really think
> we should differentiate this. It improves understanding of code by
> telling the reader that after clearing ptes for file mappings and
> losing the writable bit, the correctness is ensured in the fault handler.

I understand this is the case for file-backed folios in
the unmap path. However, I=E2=80=99d prefer to keep things
simple. If file folios with inconsistent PTEs account
for only a very small proportion, it may not be worth
worrying about.

On the other hand, when we extend the current batching
code to try_to_migrate_one(), the situation could be
different from the unmap path.

Anyway, I don=E2=80=99t feel strongly about this. If you, David,
Lorenzo, and others think it=E2=80=99s better to differentiate
between file and anon, I=E2=80=99m fine with that.

> >
> > If we do want to keep two branches, why not use a flag variant instead?
> >
> > flag =3D 0;
> >
> > /* for anon folios .... */
> > if (folio_test_anon(folio))
> >                flag =3D FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY;
> > return folio_pte_batch_flags(...., flag);
>
> Yep this is better.

Yep, that would be more readable, as it makes it clear
that the difference is the flag.

Thanks
Barry

