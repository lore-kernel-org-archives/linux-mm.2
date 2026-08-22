Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCB10C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 05:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9660E6B0095; Sat, 22 Aug 2026 01:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D666B009B; Sat, 22 Aug 2026 01:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853106B009D; Sat, 22 Aug 2026 01:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5852D6B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 01:45:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B104BC02FC
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 05:45:46 +0000 (UTC)
X-FDA: 85127818692.12.9F44A48
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFE1EA0003
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 05:45:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J9gLgLc5;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787377544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jt4NE5CEHHe0Hpmd9B1cMDamBKFXqgEjI0/U0pe3IxI=;
	b=CfCU890g/zfAGlJEdjiPxOAKVoPZDXGuxlQlYilNybC17E/gmwF5TJusk7IP6J03aKYtDn
	76vAsCmAy4KMftzdmyuSBxRDvOWK/jzFa6H1pYljgY0Q4DLVUfU0UaWSEDhLDAisVgT65D
	plMyspQlu0RBp4sr+VseF6HpBFaSH/4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=J9gLgLc5;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787377544;
	b=yEXP6nZcxxKTcGX+ormg6QSBbj4uEUaWL83rP6xlMkQWLvCArFXBQBvHHFdZoS/zO5JNqt
	XA8AK2dvjojpyVeE90WOaZ47fIDfh3aoba+2oy9mbXoLcedrczcM78QN4s6U2DHQt2qDF+
	58a3xHBnJFYujPYkKG0YubQu9PRk1bk=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a082b3671fso2918714a12.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 22:45:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787377543; cv=none;
        d=google.com; s=arc-20260327;
        b=eHbXM2e6XoqfmSmmEvskmcCCKRg5rT6RpbrR+1kjHSxHuogoTi5ESczH2zUoDnH8D0
         1k8scKdL9OGwlruG00bxzN+tk+PdCHEk2VZXqmTpny1AEz0Sa95FgGvK/vg4K7MUNKM+
         1ZEfAihyS/BlKFK5frxzrCzUHRMouFl8gQwV1gajPip+gt0oy6Vgq+ioyO7erCeMSyEX
         +CV3z8++FrKpqHaQLxEF5Bq5sz86gxcGyrwnunOJq5T5K0jNdeUOivKPJNO45ygeKyRC
         TuGhW0LFKWZAPZ4vSt4WXM7ctAUQBgx0/dzbNMPqKvgvJEkZYPyYF8V9TGsC0kBWiI3G
         OA6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jt4NE5CEHHe0Hpmd9B1cMDamBKFXqgEjI0/U0pe3IxI=;
        fh=HL/HIDS1YHgaebKeknBR5beaLP974BAo2FwKgpr7wPI=;
        b=d7KKpBi+KtoacdCEx/ssc/njH2Bme3mydNEDmxAa4CM9BTHK7+OwmIM1HHtQSDgQSy
         RftJhrRtrzuTZB3TOUhUEN6HPBr2UusL7RZD958QxE5+Eeg0EdS1G5gAKvXCnzuiMlWE
         st3KWbRvNTOFvN5I5rQefFRLDXrxnL1ryYxRM6TrUqslaC6watGurWGNouP08b451uvn
         zUUYQbX/oL1IW2OEg/vobQRQHfRXjF3VpaXtWw+sESOzaYF7U0VHtyO6p4DmkWTfHuyh
         +n3gatChkELYxdhnVGaO41mBnac3WVv/VZFMKWvpcV3e4udY9KwGOI1S7kz5GNKYfLNH
         i6SQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787377543; x=1787982343; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jt4NE5CEHHe0Hpmd9B1cMDamBKFXqgEjI0/U0pe3IxI=;
        b=J9gLgLc5+WBW1/gH4ovyNwjAn8lzqCYzxeLnXXbN7ciYYcL6/Zc4bsoS0nVjRJhFo2
         YeCi53Tfq+RE4Qg0ZJNvoPLL9OFxLPuWaaESvw4rIxczKOVXG4b81deTJHG9el6tAU4S
         qQUbQSsTFAbDXrsB3ak6THBEOWUwt8zWcJ1K1Lr4QvtoUSFHCZmBoKACgWF968pQjdHP
         bjosvvoWmlREWmpZASq+GALf6fQmWHl6w/PKti40q4yZFtkkCPfLNRDitVlfLC0VldmO
         eIfQEPWUNju0tEceeb+rtQrDYUP7hFj+3hpBEwcgyHjZELQ4Wovuy3Zt1e69Ae9HWIRn
         W0Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787377543; x=1787982343;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jt4NE5CEHHe0Hpmd9B1cMDamBKFXqgEjI0/U0pe3IxI=;
        b=Z9OiQ1acB0+/TEf+rJ8Tp8KNv1r6lDs74p1Rh4K5ZsGolwqvMdHBaLRacSvMnKcMVL
         2IhqszuP5MGtRHjYJZcYy6d0UIR0T7WyfCKkOM9pbAyPUoVfT44ZpbANnbwl2ft5FTRd
         Je5PHIJZwhxroAitVFkOR1Dw9wOA7/RjTPF/LXWr/QiZ34fM72z6/C6tpo4LUJVxrzo0
         vR9wPmSJPxgbKqZWgLREB2Z0AtgIi/gjcEeLKbEbaxoSS9TAAYOaXnVjIoWyJlpEVrPH
         YgdBYye5y/EEYDch+sv/eZIVH6J86VCLIoa6U9cxIoWLyZjGrVhBEpvyfE6I1veiog/O
         eBjw==
X-Forwarded-Encrypted: i=1; AHgh+Rpe0nUemNdXNEamGnV6eQvMBePHdO4+VS/LPS+kSa8Ujlzt41pdU1TwYhATZEYt3P+ZAn0FCPF60Q==@kvack.org
X-Gm-Message-State: AFuF++kEUQAgtn1pQMp6bKzXWVx3SsaTyL+NVuvG+n8S3KtFmITXfwd+
	TQNhOvU7267OE1mtyNWlJkJsKkaKnb4STG9XFIuz/7jOFfxh6bt5bt9Twq7tsUWbQC59QmW6mXl
	HlVt1I2LKR9g953JX75LJO6yeAnXoW1Y=
X-Gm-Gg: AR+sD13e9LhYUxj2CT42RiJ3XmMyd4YxmMW+Fd67pKeSZ3mv5Wb49S5yy1LN2gOH3zJ
	kbYojHa+i1Q5q7k0klHDy95DVl5ycXw29vyr4GYG9YOWF7zYqjtY+47tS4ZWS+GLvekecTnaPiY
	KKodwm1v5dvMUb7DKZZXgpRQT6lCQQQJjQrOlWQA49nYweE/WrboKCtqjMLvO4X8doCC6BDIJkY
	woV9LGAiFMALspId4yHkpE4jyacCi3u8RCKUaFptLLy+xQFlPGPrs5xJGRUMoMep2KDASKhFtN0
	qA8+xsoFwLi6g4YyaRHNYQXelCqOGBdcsNUPxC9Ik8Ed+rgVPP3H+nNeX0d+h/MPwFalDxnm3Cv
	i6Q==
X-Received: by 2002:a05:6402:e09:b0:6a1:f95b:8cff with SMTP id
 4fb4d7f45d1cf-6a42f14d945mr13426457a12.1.1787377543070; Fri, 21 Aug 2026
 22:45:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-6-baohua@kernel.org>
In-Reply-To: <20260821102538.22642-6-baohua@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 22 Aug 2026 13:45:06 +0800
X-Gm-Features: AcwNN1VJN2OeOLWhMViNtRWRIm8W2yN_OUoOra9mmHumiB9vGb-aFfRI4art-gU
Message-ID: <CAMgjq7AJnWGGH=FNuV7ynXjbffktsDRgdcyagLUJUwJf1ukaJQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] mm/mglru: move folios from oldest gen to
 second-oldest gen from head to tail
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, chenridong@xiaomi.com, 
	david@kernel.org, hannes@cmpxchg.org, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7hjcsswbe6fg1ekcr1ahw9qfi4r1bm7i
X-Rspamd-Queue-Id: CFE1EA0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787377544-716499
X-HE-Meta: U2FsdGVkX19gT84dly35q1aTvqnAtH3dV7Pk+5mGP2r1GBSKRCiPfh+d8vS/fX0qpbjLwQBs1P4Ow/gELZCS0yXaRciF1vkyE1PDp3qClelgCgnB2ph0luUk352Mf6Oy2RDT0vOvLUT8bwd2QLuQxZp9ZzyB0ECG66rQmRDG7yn9KpZAJqgB+80cJ6LFrPbIy0uHAM+X5ppk+tDj7JRjo8EFfocUSUBD+dPgok7FeulmMHvZud0r7X7+rXAMkYhvAQtRORy1PPVSQXvRXgBf3jwSfZxqXkZV/fD726qPUWkvqOrQfK6auxrdzt3LCyUFLDjvum2vI++pVzKGHlkMN1i+or80qmKtn5CCgPlEj/70KWDzbn6fOFfDc2FAste0l5xy8qzkjes70N3r5h8K1uOS60ptatDbhKrOeIe+lxFgvfeztHsoxFKIPtKRBPcIv1h8wLh+69uNZmFSPzujOi9z8XJKHHTBiwwjU8JBQXD4ehg/yoNn0B/HaOgCRJ0g7dvql/oTKx0P5oasdvm60/P4sGaqbID/65z4GH2QLx+cVduCoHHiOM7qtdu63LEvt1Se15ObTJOjKgsd96VsIsC5KVAml8jDZ1OqZw0ER+i6/hlUea94XmnJ3hS5UpgZzmCt7otHzQfSaadSyL63gcvqZP5qSHJgt2Y9hJYgKFWxSKpZrlO5fYpTLYeSwlaxoSyqZI4/26vRnJKSFXi/DuF0AsqKazhUoixBVJab+xmby/ukX7PpzBacWMMGsZrO4mHtYpvQwAtmz+q69H+LcVEnE7JoUn0lbvYqgA0z++fr2hhKUs5uiIUxdTiYdoUdYk40z1PL0SQ6JdArberUJCK5oEt0XUON+7dwtkCivrz2KwqKq0S6T7TVewHUcs1Ud+kCoCG9yJzVLSVS+ySA+ObGgClwGO77jLVY9znk6mO0eeyvxt6RU/PFek0E28WyZwDHOb5XpJyHg69dmkq
 r+Cd25Vn
 4QgblG6F4RAeb4DFyPiQ9tEyb0m4yY3SCvn2dcjX0IsYWPyg9xVTNEtaSeb4ZGu47PeSFfxwkN+XI6QU60pm9VBMF0bTBsVfNQQ8EMSeHlG8tFW3X0UyGK/Sokx/Y/NAJOvuHVyLVyIRUSKbP1jbQMGNIDd1ihfUAk1vi5UO+XJM8+FkSueK7lsJZsXW16PZJn00dqubtCza+cs/Fx8BHTUKgplag5sG77kPrlbrnP/MIuSDoNYwJAJl74qlWY8jHXbRVwCVncYm44HmmL5ckXuBIf6GsB5izceGOg7eF+eQB6DXX/8Lr/yquNbCTOMEg39rYiuZVdD1jun0T1/Gj1I2SKvEUdZH+xV3xonIudf3ATUeTzrEuuUoEQsqIyecLwhpiJI/31Qs+Dacirc1MqJrb3GpqJ9OmJ5h9mjB8vVm2Kv/g20lzlNrHIkMeqBSjJxvXG+0j2tyu4pSnMa9E9A0Uu04Mvdf8Rtok5xFiHyWSEMfiqZBcsiRZvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 6:38=E2=80=AFPM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> For reclamation, it makes sense to reclaim folios from tail to
> head, as folios near the head are relatively hot. However, when
> moving folios from the oldest generation to the second-oldest
> generation, using the tail-to-head order would effectively cause
> a cold/hot inversion.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

Hi Barry

This looks a really good idea, thanks!

> ---
>  mm/vmscan.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 7bd01875fade..2fd82b2ca4d1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -191,8 +191,20 @@ struct scan_control {
>                         prefetchw(&prev->_field);                       \
>                 }                                                       \
>         } while (0)
> +#define prefetchw_next_lru_folio(_folio, _base, _field)                 =
       \
> +       do {                                                            \
> +               if ((_folio)->lru.next !=3D _base) {                     =
 \
> +                       struct folio *next;                             \
> +                                                                       \
> +                       next =3D list_entry((_folio)->lru.next,          =
 \
> +                                       struct folio, lru);             \
> +                       prefetchw(&next->_field);                       \
> +               }                                                       \
> +       } while (0)
> +

I got following warning from checkpatch:

    =E2=97=8F checkpatch.pl: 92: WARNING: Argument '_folio' is not used in
function-like macro
    =E2=97=8F checkpatch.pl: 92: WARNING: Argument '_base' is not used in
function-like macro
    =E2=97=8F checkpatch.pl: 92: WARNING: Argument '_field' is not used in
function-like macro

Maybe you could try b4; it helps run these checks automatically. Feel
free to ignore if you think these warning at pointless.

>  #else
>  #define prefetchw_prev_lru_folio(_folio, _base, _field) do { } while (0)
> +#define prefetchw_next_lru_folio(_folio, _base, _field) do { } while (0)
>  #endif
>
>  /*
> @@ -3932,9 +3944,10 @@ static bool inc_min_seq(struct lruvec *lruvec, int=
 type, int swappiness)
>         for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
>                 struct list_head *head =3D &lrugen->folios[old_gen][type]=
[zone];
>                 unsigned long protected[MAX_NR_TIERS] =3D {}, delta =3D 0=
;
> +               struct list_head *pos =3D head->next;
>
> -               while (!list_empty(head)) {
> -                       struct folio *folio =3D lru_to_folio(head);
> +               while (pos !=3D head) {

Do we need to change the while condition now? Since this commit still
moves folios one by one, will it stop when the list is empty?

> +                       prefetchw_next_lru_folio(folio, head, flags);
> +                       pos =3D pos->next;

I tried prefetching in MGLRU previously, and it didn't look very good
but there is no regression either; perhaps it's very arch-dependent.
Anyway, I think we can keep it here, maybe further optimize the
prefetch later.

>                         new_gen =3D __folio_inc_gen(folio, old_gen, &gen_=
increased);
>                         if (gen_increased) {
>                                 delta +=3D nr_pages;

The rest looks good to me, thanks!

