Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C85C9830C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 01:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95D56B0088; Fri, 16 Jan 2026 20:16:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3FAE6B0089; Fri, 16 Jan 2026 20:16:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66F16B008A; Fri, 16 Jan 2026 20:16:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA5656B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:16:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80B9FB7D6E
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:16:53 +0000 (UTC)
X-FDA: 84339691506.05.353A7C1
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E5B1180005
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:16:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uzv+E1Eb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768612611; a=rsa-sha256;
	cv=none;
	b=ZQE3AC0PSAzz0fct6xTBHjh4kMXZEyOCofoiX4ZHsxZJEvR4t2muyjaoN9g66ApgPpGW6a
	O9lDWIvL04e4Hu5/5dJKWndAA88x5Tybrmk92bB5FQ8fFTmxh0o4kgEG0A/7X2RA/4iB3K
	qHx/keDzklUN24rKtn3CBJPPX5qp3zE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Uzv+E1Eb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768612611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gp8dpIv/Dfc5cO3s+321RGbSFnooMWYq+2UyEKL6k2M=;
	b=xV+trABuSC9TSb9X7Xlw2q+SEa4b/BNppFTMOi9YETEZehCz99SOitDoJg3tsY4ve5vX5F
	W16ey6CSfxTMJ1UiwviRNuQzLq8D4qSvhigokVwaBaJrzHhKs04Gxgths61DunyG5KWhwC
	NzMuFKXaRh25+R1c2E7qEZiiltbayyw=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-42fb6ce71c7so2386605f8f.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768612610; x=1769217410; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gp8dpIv/Dfc5cO3s+321RGbSFnooMWYq+2UyEKL6k2M=;
        b=Uzv+E1EbFGqSk5UdzwTFLmwo8pM1m/6lv8GoZr7iM/uowU70zVPlwTd289lPED4Shf
         5K4ufKmwlIOSgs3d40zqZ9xoGCMjzCZ3KWMUsoRrzhO2+H+FS3k/6S58JNj+9OXTs5rr
         ZulSnQT6DtFAJMf35i3lm1EBII96C9w6M8hqfEkb4BeVvJg/sU+zR6Sl+zYR/9s8seg7
         cb+wgeIfqVsGdtTdtKa5Ge6jNd47dplbfCovgOK9BqlYAdtT8ndr32zm5wtzmoWMnq9n
         Nzs1Q1QjnN0H9LGTlFX/iA2CVB4jA6EBO5doSXQ70qAk/YKzcgX22W3U++x1cKysuL/G
         W76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768612610; x=1769217410;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gp8dpIv/Dfc5cO3s+321RGbSFnooMWYq+2UyEKL6k2M=;
        b=GR4UVTuOJ00pBtIJoXeZR7/oKfk4DH6cfCDu2QIFn8Bn/YF0DCA+ViTzsDCDgKQxtp
         eSrucXFxiGwYb0BG3Dtgw6CWojmkuGqiXFb48Ejr1F3N5DM28WNOJd4wo+vLzaEtm+Ek
         sjuYR8bu8zeMW2bwK+n9f0/tv/7ZVq8Y2emhwOadMiaoOn3M4w5Abl7ikAtEcT2FQSnm
         esCckbThN9yYb9VoAmLN6QZpRd4FEkaZ8+bTY+OKLsq691eYesQ6ZJkkCkibCX+lGqxD
         SNKJf7JFnjuCJya8ckJct7B3JKhKUKcB8mFq/o0HRYI4TbKHAI6O9qODzIlCOO9r5qon
         V7qA==
X-Forwarded-Encrypted: i=1; AJvYcCUHA9vX9x3WYppW7ul5q5yVb58cSTbB5AvZtaF3LPWDIv4CWZbTmd/oNAJ0v1vSRbR3H4roQ1H9CA==@kvack.org
X-Gm-Message-State: AOJu0YzZedq+AW8zsFcs+sTqCvf4bwtEegYD/lIrh7GuSzbydv0sVhUA
	fltC9aZwHDGyjiOSpmcOIUZZlFts+XcyejpsVN3R2mlDkXVCvK5LphZLWNy9g/ogXkm/T3RVnWI
	05V2JfU/YGUnyC81OjJuCbVUww4X+OJo=
X-Gm-Gg: AY/fxX5jlKrN0uNaldSz8XNRKYx7rrf6dLKcRiQQrXHdBbj+0iFxztIY7udTfCuZRRf
	dpwhlRUWtZsNW7cniRNk0TF3PGKWW7DUgvgt+HXwIvvRiZ0SrltJVKsETHW1Oz5rgH+JQM1xuPi
	SqQBZztRdrJfP6L3XU5ip0huqwWoLZ0HICjeFetblEMuc8hoQIPSA20MdyAz3D5fQKqgF+sCrc+
	Ynz1cJaN+jInyOlH/pDJAmpnDO5TI+kRP/KtgeSHT9Q404KboNM/2mrSQxNGr8XAk2cUI8NdmVM
	gUydaGVviTubFE/TFzUIuZLZNNy20XUzulmFWss=
X-Received: by 2002:a5d:5f94:0:b0:430:f879:a0ee with SMTP id
 ffacd0b85a97d-4356997f1c7mr6293652f8f.5.1768612609986; Fri, 16 Jan 2026
 17:16:49 -0800 (PST)
MIME-Version: 1.0
References: <CA+fCnZeHdUiQ-k=Cy4bY-DKa7pFow6GfkTsCa2rsYTJNSXYGhw@mail.gmail.com>
 <20260116132822.22227-1-ryabinin.a.a@gmail.com>
In-Reply-To: <20260116132822.22227-1-ryabinin.a.a@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 17 Jan 2026 02:16:39 +0100
X-Gm-Features: AZwV_QiTZME4zVfDXinUP87CAfZ4TJxGgME07itg4LO7utgz1XQ8x_7oq7n1Sw0
Message-ID: <CA+fCnZed4zuPgoacXgEKYjPJ-r5JkZTFcgFFysFLngMLkrhfKQ@mail.gmail.com>
Subject: Re: [PATCH] mm-kasan-kunit-extend-vmalloc-oob-tests-to-cover-vrealloc-fix
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, 
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: i1pkcmm7cjsh3ej4he79esgw7jp16dr1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E5B1180005
X-HE-Tag: 1768612611-804277
X-HE-Meta: U2FsdGVkX195wN1kzuvtb0KwqUOHjPgslgjNKHygvPQZMg7N70CoqlF0vKcWL7rVtF/dRLDxi7HvZvVZH1H3Qjq+MwKsXLgutAajZ8LRjh4ti9XKEEiJWjkhouvTUgNLR9u6fdo70417GOgVCe9RzZqhxPGVlIbCMwa+EMqKUGuPmS/3B320GUanZC0q2JMZvqNzjjo5j9xsxSegEGJuTnkUG8Fu7rXoWGYXG0OS1h518sPek9s3l0yNnpxS/QdHr8X21BU7NENy2O8g5UY/8grVgSO2WbxgZzi0SnDX813kIFqqYpwfrvRqePAkj4HZUtlCdspET+kxD/rs4NGNUk0z4LGwrITYo1KHYjuOFWxgrsTJC7tGCx0zStCFSmAh3daTrOs38v8H7M+l3Ib1XZmCfKALgk8aw8tuGrT7FhKohFv4eUHzINVjMxrqocL3s2FhB80k+iSIosUhD57qBTl0gZQRxNtHIQRqbBsb9UCka43rejLZ3KZJSMHnOdT5hAx1+aCdfbGQNJ45z5ME2zPUyTHT6T+vAbtlJ2yQowhcizU5kDwT87hdleLlauhpx0hq2VhfbpSvfw6yDHNzJeRMXckUkDpoqaIbg6xnTm2bzPsEIM41E+B7UwB2Fip98Sj8+FaFK2JwteeCvx0g/jy2wqqnelp/Zng+pWRdUbGbA2Wzc72z2z71w7I60fpkJDRO40wneLSGotteQNDCxqyki4coh0Xr/6OhAV5YC46u3M7wTmT8aG7khTzIW9iNiYi7w4zvN1JZSXnYPM1K7oBithw0neODc3WSPZW8cG5pihe1q//6AfwrX2slsgo6A5np+HUkWzZVflEfcdXJTzacpcZXDCcOFsi8YWyxmGOu9VbLwUH4yFAi9TXWDdKF+CRgjbelbJ2sMevagyKYK4dfrC6Qj5GVjG7kTvvN60fK4LhfPhd92mB/0aHSY6EnL3MrfQqPvu9nswqCm4Y
 no4PuN8p
 EH2uhKWsgARQZbM7L0B04/6crp6VgcjqPh79CLrdeeb26mM9iGySMWQwMbBdtPjJH5S67VElqpPQvwg1iuxK6AdRdFWfioFXnV5yUWyqMn3Dx7AWywmidFzBm+1ZTH3htcgS9g35b7BC6ukGQ4yTFPWiggpQbpw+E0dgbGFLAJ1R9drVYYo7eshyuDu/DigKM+UN6NRNLmpw0LFCBTQaj+J5IVEzg1d7eJ2TrobmiPySdSxw38xPf1kqHwT8DfX8a8Xx8CTL3TbrM23WYNokcOjkg3Iw+jbxO2+QkBNJbSiJVGBsN5OJISvwfRhv+5cHySX8PYSN0n3IHQ7uAa1BuesQeGN6tfOpASl84MZCKmrBnOgRyW643rGs3yi3zCH5ZqxDmVe5DrsOhaVyVimTao8vedPQtFBhLO/kLsDMEC2BmD5pQ3aSDgn8UnTd6+EIq4QACPDXIrQxW0mfcketrX2HiZ8N6Dldle0Od8ba88SsKRUM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:29=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
> Adjust vrealloc() size to verify full-granule poisoning/unpoisoning
> in tag-based modes.
>
> Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> Cc: Andrey Konovalov <andreyknvl@gmail.com>
> ---
>  mm/kasan/kasan_test_c.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index cc8fc479e13a..b4d157962121 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
> @@ -1881,7 +1881,7 @@ static void vmalloc_oob(struct kunit *test)
>
>         vmalloc_oob_helper(test, v_ptr, size);
>
> -       size--;
> +       size -=3D KASAN_GRANULE_SIZE + 1;
>         v_ptr =3D vrealloc(v_ptr, size, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
>
> @@ -1889,7 +1889,7 @@ static void vmalloc_oob(struct kunit *test)
>
>         vmalloc_oob_helper(test, v_ptr, size);
>
> -       size +=3D 2;
> +       size +=3D 2 * KASAN_GRANULE_SIZE + 2;
>         v_ptr =3D vrealloc(v_ptr, size, GFP_KERNEL);
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, v_ptr);
>
> --
> 2.52.0
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

