Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8CFC9830E
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 01:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7047C6B0005; Fri, 16 Jan 2026 20:16:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B2176B0088; Fri, 16 Jan 2026 20:16:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 593BA6B0089; Fri, 16 Jan 2026 20:16:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A3676B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:16:26 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF29D8B05C
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:16:25 +0000 (UTC)
X-FDA: 84339690330.10.8E2C1EA
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06C22C0010
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:16:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nLYzN0YH;
	spf=pass (imf28.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768612583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8jacRTGEGX5vlMnwDO2iTbDAhG4zdHGWsi458RG2c5M=;
	b=jK40Pl+zbD10ojYGgVYsqKbF3T9q4gy6P34DSr3ugogSzp3pRxWIUqTZ3QUibxF/8zN+Sf
	fBlAMwwlJ+C1i+g3R86KeBhJ3v2N6urXo5uCBdatJ3yCXIOFZ0g+E92jlR+t+1d1NR9hZ5
	k7h1uvsGjBkTUAhbJSid73+L4V5Kzqw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nLYzN0YH;
	spf=pass (imf28.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768612583; a=rsa-sha256;
	cv=none;
	b=sAz3jjZa6m0qx6yVTCqjOj+2srzmqtLy9YXsdtfWoGBsQrv9YoEjJmRQkXnjP1lVMxvEWT
	019IlRW0nrNGJEOlTsE+nO3aHujFR9a6MAIDziqUpcxFeb66N8t5C/lO2kOeYy4mP0cwnN
	8JrvdFBQOYa4XuOtHTggBt/qU28hEDw=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47ee807a4c5so19253315e9.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768612581; x=1769217381; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jacRTGEGX5vlMnwDO2iTbDAhG4zdHGWsi458RG2c5M=;
        b=nLYzN0YHMMft+j5ABL2VGoSZRL00m25bX7hz5DmFrMXG0BA9s7vCYCtyDA8r5XCIhL
         Pwfpi/j1mYPBuo5ZNFkJ24NZ56rDCk12zG5Xkta1FGZDmIo2gJt9BTL/MJrBZZczO7Qz
         yJs8MbiajpaWovFvbntsI6YmQXwZ9aeiFdws3uo2gE13MxOGn1XjlWm1lzVM+IGPTyCg
         NIGYLer9APsfgAV64NH3l/1yyM7Yg309xfqJW+QkUCK0GOihH1LnB9UM6eovuyAC0cgK
         GcIHYHvcCPzRyc0Ai7Z1QM/yjhi3UKeyk+hn1efWRclWvi4p39EjhVhzha2iAcA1Qo+W
         aS+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768612581; x=1769217381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8jacRTGEGX5vlMnwDO2iTbDAhG4zdHGWsi458RG2c5M=;
        b=hMXJat7K29ccyZMP9TNY5EpQQorOgGArAh+hVLbmbvGv49SyxwzNHb4LC6ntMGXAHq
         cw3DukrL0QfNQ0u+AfJBco8E625BfJzTo0b6rCHS2Q1QqYkqXwhuNKmwEB4hFYIE5Rim
         H4FhQk7gBiYI0w9Y9WwLwTEhowfuUrX4jg/YyNxxorkNKTrmDeT1qvwV04qYlDC9DTze
         jK8sIetRIRXb+IO9+bUmkdTHBYAF1S6wHVSD1j7Kx8/bB1zzHQU/jIFVpjxd2u+z7WPZ
         QCo+Ywfd8/XpVdkEsspIHL8AJKa+FejvtNrT8O8Mp5TKk7fs/80shB0LGBK76o1FSLTm
         DkKw==
X-Forwarded-Encrypted: i=1; AJvYcCVgl+DH7yN+3wKWYptkSIIhfsETAHcoih3wppvSFpJjON2ULDHYhGdSOnrLwrHnF6HLypalvSD9sA==@kvack.org
X-Gm-Message-State: AOJu0YwONOGlGGRx0c8Ko0RiwAT4xk4QtqcHypu0cVefJBfYgOTEJ3Q6
	m/QDNmwO2b9dWHcEug/zZLUXkXu4Z8x/hi5j/fKdvCsoGvBfIF14ZMSuzXZYkVPA1HSoRG6gsGc
	/xI8DPAfW/4InzcAC3hTh42vR97qXix8=
X-Gm-Gg: AY/fxX7O4baYjSSHWxu9uh6C4o1fNdDgBElgGzoRVGVjIP2ypvZqtpJchevkqNQ4Hm+
	8DOs3bqbX8FT4EVrKdIWjlGtJzFvroEbTY7TchQUFVT6lwgg4nAgJ05swLXtALbmWcSuWId54Yo
	4cXdWXAdzBiVbQoKann5fKf/qoaQ2Z1jJCfMUBUEd/QNG9GpU73sLVPeB7RIzDQps4bL4uHTP1e
	mPfkaChnVLzz3enI72k83tzCJpFz0xjrrb5ZJFEzxZ5X5x3wYSpxsz3Fb6OaeihQgSpxEvXZT5m
	3I71sIVIp8Qqkf/k2DW08T0MV42V
X-Received: by 2002:a05:600c:45d1:b0:480:1d16:2538 with SMTP id
 5b1f17b1804b1-4801eb03358mr43804885e9.23.1768612581229; Fri, 16 Jan 2026
 17:16:21 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com>
 <20260113191516.31015-1-ryabinin.a.a@gmail.com> <CA+fCnZe0RQOv8gppvs7PoH2r4QazWs+PJTpw+S-Krj6cx22qbA@mail.gmail.com>
 <10812bb1-58c3-45c9-bae4-428ce2d8effd@gmail.com>
In-Reply-To: <10812bb1-58c3-45c9-bae4-428ce2d8effd@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 17 Jan 2026 02:16:10 +0100
X-Gm-Features: AZwV_Qgw2efsxw5nCGxgrSSMx3DQz0LNWwfRwrPgK6uICIY1gvifMYqiZzjGO_4
Message-ID: <CA+fCnZeDaNG+hXq1kP2uEX1V4ZY=PNg_M8Ljfwoi9i+4qGSm6A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/kasan: Fix KASAN poisoning in vrealloc()
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>, 
	Maciej Wieczor-Retman <m.wieczorretman@pm.me>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	kasan-dev@googlegroups.com, Uladzislau Rezki <urezki@gmail.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, joonki.min@samsung-slsi.corp-partner.google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ri8hzzdht4n1tmd9ate8bbzhbichafqc
X-Rspamd-Queue-Id: 06C22C0010
X-Rspamd-Server: rspam04
X-HE-Tag: 1768612582-840438
X-HE-Meta: U2FsdGVkX1/J+LGB1ZSHYLXEePFOOVMBuHICQrS5IOqV41rbmEI9QGPlEfJO/P7DuixrkCzuH8K7eVW2kKjwDgEM5507uPFd0gZa30wjZTw8mWe0P5nXxes46LN6JYwdZQixSttCOEVtHU5msSvxw+3fVW3Zogg2wApDZQUSQ5XmPuF6xYFfWyoMu4qDADd87JGGbEXjqRvABGFas7mnJlWVZ4E5y1lG0X/mA7gZmYKzg64Yq3tDY3Tortk2DZ6rXNSPiNm2RPkR1DoeFm2XprhfRMmlsjinbJZPqPu0b7RyCbS9vb3kXWWKjPfrtRX2EfHks3nctbtKArqQub0zDwlAUqd8koIP+k+9ODkTTQVNJHnVA48U4l2XadeFFKs3OH9NIUL8gny9327gP5VfLx6fuW8qxM7jgQuaCpJDm6yl6OEggUdrrFVpkBmk7ycRRTR3hVBx5iE2ouCf3c8MVrV/EmDNg/UeUBG8q+bSM7aomPcMLK29jojK+PQV/Q1pIJjuts8fMVkknvzVAW9zKG0NG/ckvIoHPFIJhyMAQSKnjeQ8MOoCNFNmvHg8dTlnT8MpoUIB8likyoA/HDb7J8OFRuUIOUzIbnL7MlD2A5YY690zN7KHVM8rxcBb3vKVFo6upnNbeDzXOv2hjfwqiLaDi7krb0R8drwNXgmuGo5QSY3Wk09+Q66QX8RA09oTVC2e++5IhZyNsqT9aoSViUVA0PF1TpfO+RpZAdg+n5yjS3spX6a+51mIEd5mrcWFz0OJzgXWAC+Edu8jemybI+3gKDcAoMwzZWAe6SFB++fMmYcBCoGXcXzANgI5LytTsR8EZBA6kmtlws68cnqvdbcGLYNSk8gV5MyyewawYuveULg1wvWIc2V9jINVwaFncSrq6atVidzc4D5+ZfnCfJWCw9mdjuW4EBVWY1dQxAo5Gi125FXNSitmId5WMbQih36DIGevLGeUMkXNPY6
 1UE9bK4s
 thta1c8yLyy89C3myG2AyUAa9JgdYhMWNT9YEVNV4WBMqGbFzQUTITLFHipzYVxFXhDAFYHlhtXY/b5Pn1gMJYGiWEDRCdK7R4Im7iG/9Jg8CVvD/CiVOJL5GXy8s+K5C/i+kX9fZfQZNXoGqVGP+f6lXLHyrSFRN/m9tpXfxh25JCChuHolDv8o6g7AU8RrT7K9SQz6p7cGWPAkF0+Fyz8Cw/g42f3z+g2TroFdhnAq7LUzpm4VF3jFkk0KoH48vRJ3Ef5rjkWdKfI51EnfK0jbhs7Z9vEJ8RfjJyXZqv0tVD2NV1FuHqSNofV16YESGBwZIfISYlc4qJJXb9+Bj6jfrXdh9wHI1Fywh36o/NBQHUBw57G+GDErBIH8JRdHF4jJTw3Ko0rDoOamgKzW0EcjU6SbpKyYqJMbTmdfeWv9ZNfNghPHI3ObNtTrx2hDPq06Rc7LCl2fR/TIZyKLO6RNd+S9nfDOih4mwgNULE76ldpG8W4BpNLhgur7IM0cxBrK1UG69SEtO9C5OPvz041kQS4bs5AcRh4/v
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:26=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
> So something like bellow I guess.

Yeah, looks good.

> I think this would actually have the opposite effect and make the code ha=
rder to follow.
> Introducing an extra wrapper adds another layer of indirection and more b=
oilerplate, which
> makes the control flow less obvious and the code harder to navigate and g=
rep.
>
> And what's the benefit here? I don't clearly see it.

One functional benefit is when HW_TAGS mode enabled in .config but
disabled via command-line, we avoid a function call into KASAN
runtime.

From the readability perspective, what we had before the recent
clean-up was an assortment of kasan_enabled/kasan_arch_ready checks in
lower-level KASAN functions, which made it hard to figure out what
actually happens when KASAN is not enabled. And these high-level
checks make it more clear. At least in my opinion.


>
> ---
>  include/linux/kasan.h | 10 +++++++++-
>  mm/kasan/shadow.c     |  5 +----
>  2 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index ff27712dd3c8..338a1921a50a 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -641,9 +641,17 @@ kasan_unpoison_vmap_areas(struct vm_struct **vms, in=
t nr_vms,
>                 __kasan_unpoison_vmap_areas(vms, nr_vms, flags);
>  }
>
> -void kasan_vrealloc(const void *start, unsigned long old_size,
> +void __kasan_vrealloc(const void *start, unsigned long old_size,
>                 unsigned long new_size);
>
> +static __always_inline void kasan_vrealloc(const void *start,
> +                                       unsigned long old_size,
> +                                       unsigned long new_size)
> +{
> +       if (kasan_enabled())
> +               __kasan_vrealloc(start, old_size, new_size);
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index e9b6b2d8e651..29b0d0d38b40 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -651,12 +651,9 @@ void __kasan_poison_vmalloc(const void *start, unsig=
ned long size)
>         kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
>  }
>
> -void kasan_vrealloc(const void *addr, unsigned long old_size,
> +void __kasan_vrealloc(const void *addr, unsigned long old_size,
>                 unsigned long new_size)
>  {
> -       if (!kasan_enabled())
> -               return;
> -
>         if (new_size < old_size) {
>                 kasan_poison_last_granule(addr, new_size);
>
> --
> 2.52.0
>
>

