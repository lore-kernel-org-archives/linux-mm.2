Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8C6AD21687
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:17:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32EE76B009F; Thu,  4 Dec 2025 10:17:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DFCE6B00A7; Thu,  4 Dec 2025 10:17:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C4D6B00D2; Thu,  4 Dec 2025 10:17:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1153D6B009F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:17:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CC43B7132
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:17:38 +0000 (UTC)
X-FDA: 84182142996.15.846C3D5
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9763EC001C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:17:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J+WW2Rf/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861456; a=rsa-sha256;
	cv=none;
	b=G5m+ByHDpF1s+MHO9+/C6uOxfVn0rMhLI9hdt/u8IuZiLX+0HZtDjhFMgdsJt8klfA4PlR
	JoSgqO7svZMsDs4wLbRAKL1YLQb64nsYOmR6KfRgggXeR8zWxdKfPXNcp1T2xV5XHlFRXe
	S+GAUeqvv+nrRAJ1qZsnfW9RW45nm4k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="J+WW2Rf/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSesA1513PF1RTOpQ3ExDpK6F+FkeLsbkbgvrO0OXrA=;
	b=g8Omz1sw8J80710Wy6o7Yt3F5PU9upN6kQgeaqfZC2Aav5GgcpdYGbZxLRMznbJtp/WBLN
	2XSSdPgh2er846ZnZBqJE7abGODfOLuxwbQTRmBNR/9E+8ZYArL4ZYtt7t34EVP7jpHRNZ
	hsECULlCDh0QSWIetRrVEBfGHwC1+eM=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47789cd2083so6928155e9.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764861455; x=1765466255; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WSesA1513PF1RTOpQ3ExDpK6F+FkeLsbkbgvrO0OXrA=;
        b=J+WW2Rf/SUNmz8Y7s+AM8BN9Ibr9+JFStO4RfS6qEhn+qIxcuREfcfFVUzUV1Umuvq
         pZPd5fCEbA3vJVt3xbPARNmfBvcGk+P57kiFtsquDzrDcS//gLLKMmNRA32FHiRiahtw
         LUrMMqfi4mG4jVcVu+Fyj0tj5Jz2CS77dFYtlvBVQB1gKNA0jTQ3J3QeLz2deSA+NkqO
         lOdlg9qBdrsc/qeHY3tl0SMUDlLRLNfU5KGpA3KwxewmDVpSlv06G2nySeL8A/pdy4E4
         Ene/tHfds0ZtOCb34jlrN1rKWI25I+BX+P9udikkeEiGYETiGYapPr2Uct2VVF/HA30i
         fVTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861455; x=1765466255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WSesA1513PF1RTOpQ3ExDpK6F+FkeLsbkbgvrO0OXrA=;
        b=WYuLRFSScwuMuhQuQ5rUEprrxotnpPWceOXcZ+Gx3CyufEfMUTeptuZ4uwdFsSGFmi
         xesNZHPvwuyVhvyU3uc3Y8GqZ03BBDdOUmCC4R0bK9rfRa4te3KDmyZ29flyFdl117i1
         /71GoGBYpwAnb/o4WWoJbb/Cj7GK504NCWsfNQg7hz7wZAhxcC1yAYZp5FmrsxCoU0Bt
         HjwBBbFe7yheVwT+bqtElAzAlt6WOLTq/SZvr9YBhIjKwWRttUfOtaMCYx9bbwgoKkuk
         j70QijTnGr8U9BtYFRec21SXdDJXvjXbTkjX65TfC9YXICZ0VvIhZRR7MleXBP0SDJow
         U5hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIF0jKAurWZ7uIo9KkBSsIMrc1mof70LQc68BpZknFIBAppOGljL8GbH/165o9j3t6Wj4RDscsHA==@kvack.org
X-Gm-Message-State: AOJu0Yz+SCO7JC0YZdMA9ws2JaaqWgaa5DBA7mzAi0TKWiIlK/NuhiHd
	bvbkZuwQK0T2AX58PPdTz2BO5VJq4I+AYOSDR1be2IEAYSmlW31DLG+S2lqeOXNJTkUD7H+oNkx
	uG7l0qSa5XxkHKTp9mNoub+laAhtKlyU=
X-Gm-Gg: ASbGncvYLHTSa9GjG3WhAjDivmOQf88navTIVEDD4+QaTfuewOZdsjKuLjbXnS6dT4R
	rXAg9sQfiTxaz5tjETjDB3QEF5yrBGsZ/2K/BqTZwkPXPxMdDIYxgw1hBXjZJLwAhZaHa8h6E6N
	QljL8gHGJn6dh/s6e8qlmK1dv6Y8kTp0ZG6YPwrT2CnT06gAvSKoCfDfbZOfK28LCTpnnh2Y+Rg
	vIHr9N1jh58EW6vE6zRXyfkrFqejmNHD/3NYLb7gzNfZ4OotQE3pyy0uxs8zzS9LpxwNeOxV9FB
	9E8Jn+4Nq04XB+HFc585FvQr64SV
X-Google-Smtp-Source: AGHT+IGPH0EJYdbaBhvurzXK12QLylFM9zsem4O87iZvWi2X0pfwfrJuILFzMv5S3tf5HYvfRFYstYyfwHvXAaGIFpU=
X-Received: by 2002:a05:600c:3b05:b0:477:582e:7a81 with SMTP id
 5b1f17b1804b1-4792aed9ab8mr67560995e9.4.1764861454794; Thu, 04 Dec 2025
 07:17:34 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com> <20251204141250.21114-2-ethan.w.s.graham@gmail.com>
In-Reply-To: <20251204141250.21114-2-ethan.w.s.graham@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 16:17:23 +0100
X-Gm-Features: AWmQ_blzpwZ5TwYvwfzPgYjtrBP8LQtIvLje7Y_oBdFacKxiRRQT788M4KRtDnc
Message-ID: <CA+fCnZcvuXR3R-mG1EfztGx5Qvs1U92kuyYEypRJ4tnF=oG04A@mail.gmail.com>
Subject: Re: [PATCH 01/10] mm/kasan: implement kasan_poison_range
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: glider@google.com, andy@kernel.org, andy.shevchenko@gmail.com, 
	brauner@kernel.org, brendan.higgins@linux.dev, davem@davemloft.net, 
	davidgow@google.com, dhowells@redhat.com, dvyukov@google.com, 
	elver@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, rmoar@google.com, shuah@kernel.org, 
	sj@kernel.org, tarasmadan@google.com, Ethan Graham <ethangraham@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9763EC001C
X-Stat-Signature: 56zidmd3sezoreoh65csftyramydrsya
X-Rspam-User: 
X-HE-Tag: 1764861456-564630
X-HE-Meta: U2FsdGVkX198zcTRoBLWkqwkuppTTTzKogSytvgCeSvgP10fGLp/t4yzN85HeCXgVzYiZWk8oMfiUvjCvLIYTDhwgmDdJuX9rc68jAgN7NkLv7yO26ra9NXXfuVDKY2DDi68wLsSz4m7CEBECy6QABvypLRXE4BcIWTJ+O3EUX+OY82p3nn+Wy8pxDyEXvJvJdPn+v2ZvpoaL7+qKyb+7G58xEvi26BgHLuly012deuXe2elQAevlh+Wnh7lPefOvJ8iLPFj3Kv5d3nlKLsdpxG+N/692Zsgew4NMpLV3CWWjNMSgW73RViB64zmMly40hQ5Spcf3jQnS9rn4bR1DzggscynjfwiDCH5Q4zLGyIl8My9sCJK2rawKBqTXtNO0HzBwP4coJkGXsvGOKcVC/zahjlPk98zNQX61esbbMMfZHwTm2SVTFOLANUsiDnXqV5H1U7W341K21Jsv6mCbzLrtMjVyA7EfT8O8UarsT/o7M7fGyn6Tw/z60m0C+7xuPfShQj1RsZqomRs5s//P/2rtuAp3ySf7zK2httHRLC3MHzJoVV/kFNyrvDzASs9MaEksFrvuJjpAm1CvHq3/6Jzy7UnjKPfa8n57s+XL/7vy4hejQmWJXbf39fIV53Xivkr7StH/08Hx9cfsnrDIzAcOlrRj5hCqQNEz9MEy6SifKydQS0Wsq8pu7dLfYtm/R399FSnUQORB/Y9KfmKW2av3TS5d04stKhvwnw2tSrPEBrSnnDtsCappU308w4eBBwClikjqDkzc11+IWne6Ag+hGkP1E6dqTGI57UsIepb2eu4rX49m6RqRew2R+8tCvSuSRB5w3V0QQezXG2Ng39gSpdDq+d64tKUqosxiRXh/2Ge2luU/+w2qd0/keZ+PelYcuarps2ejPQdxjgdW1Amtge8buloifEEAeLQlMDDgV3fiZQxFv2wSTrT5r1y5C0X7ZRbWZNHv66csk5
 lHL+5Gyk
 6FvTbNJK6/XbZxz0aXC7aGszZ5++yQnMbjplupODQzxxMvHFTBhSfQXb3NdOK81BsryVsimdjhRn2rXo0m5+ENk2h3vZ8pq8gaq8xbET2t7ccEOLbc8fOv9HQEcMwjxuaMM9Ltm0aWDJH6mtxXUvalt4hzF8lZTgDKPTnUwTGe0614HyJgzxoOFu9c/cE1/vlZPiaAc4cCwPhIHHUX2TiU98JFG7Yi8RXAwm+c/LT2g13SXxNQnfbq4IwewkYpdf+Pi2NRCTvJ5EHKi0vBsba8eGczbtfHynJUKMCWEXWV7/Bfnd/3ipT39xdDQ4taTsPSlpW/TR7coPkTS8l4Vfsu6L/p6fcOy/67ilTvrS3LrnAMRWNP3RNy+40Vevz9r9Ce8b26JOH8UwPAP6m6tBTf5gaOEhMNMIWTNkn43ZyP4mAbPvnFtIIwMjbBLh4urSlWOaSTs76DrjrxXqyKHc7R/QNL6jMUKPsXdrN9DgPBIkUipf7U1XhHXtgDjSubj9OwAbU+t2iMGCA0x0Yqi9rGfve3qJrWTiAceUxZJShcqBBoEg09x50w7tBRtNO4wiVhD6rPzUhqr4WhZ4dZl/tuwVsNxLQ2SAgIVhB0BDJpZT2X8epXhBWyUd0gapQFoLXVFscKFEiIODM1pQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 3:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Introduce a new helper function, kasan_poison_range(), to encapsulate
> the logic for poisoning an arbitrary memory range of a given size, and
> expose it publically in <include/linux/kasan.h>.
>
> This is a preparatory change for the upcoming KFuzzTest patches, which
> requires the ability to poison the inter-region padding in its input
> buffers.
>
> No functional change to any other subsystem is intended by this commit.
>
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>
>
> ---
> PR v3:
> - Move kasan_poison_range into mm/kasan/common.c so that it is built
>   with HW_TAGS mode enabled.
> - Add a runtime check for kasan_enabled() in kasan_poison_range.
> - Add two WARN_ON()s in kasan_poison_range when the input is invalid.
> PR v1:
> - Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
>   kasan_poison_range(), and return -EINVAL when this isn't respected.
> ---
> ---
>  include/linux/kasan.h | 11 +++++++++++
>  mm/kasan/common.c     | 37 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 890011071f2b..cd6cdf732378 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -102,6 +102,16 @@ static inline bool kasan_has_integrated_init(void)
>  }
>
>  #ifdef CONFIG_KASAN
> +
> +/**
> + * kasan_poison_range - poison the memory range [@addr, @addr + @size)
> + *
> + * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, d=
efined
> + * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial gr=
anule
> + * at the beginning of the range is only poisoned if CONFIG_KASAN_GENERI=
C=3Dy.

You can also mention that @addr + @size must be aligned.

> + */
> +int kasan_poison_range(const void *addr, size_t size);
> +
>  void __kasan_unpoison_range(const void *addr, size_t size);
>  static __always_inline void kasan_unpoison_range(const void *addr, size_=
t size)
>  {
> @@ -402,6 +412,7 @@ static __always_inline bool kasan_check_byte(const vo=
id *addr)
>
>  #else /* CONFIG_KASAN */
>
> +static inline int kasan_poison_range(const void *start, size_t size) { r=
eturn 0; }
>  static inline void kasan_unpoison_range(const void *address, size_t size=
) {}
>  static inline void kasan_poison_pages(struct page *page, unsigned int or=
der,
>                                       bool init) {}
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 9142964ab9c9..c83579ef37c6 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -570,3 +570,40 @@ bool __kasan_check_byte(const void *address, unsigne=
d long ip)
>         }
>         return true;
>  }
> +
> +int kasan_poison_range(const void *addr, size_t size)
> +{
> +       uintptr_t start_addr =3D (uintptr_t)addr;
> +       uintptr_t head_granule_start;
> +       uintptr_t poison_body_start;
> +       uintptr_t poison_body_end;
> +       size_t head_prefix_size;
> +       uintptr_t end_addr;
> +
> +       if (!kasan_enabled())
> +               return 0;

Please move this check to include/linux/kasan.h; see how
kasan_unpoison_range() is implemented. Otherwise eventually these
checks start creeping into lower level functions and the logic of
checking when and whether KASAN is enabled becomes a mess.

> +
> +       end_addr =3D start_addr + size;
> +       if (WARN_ON(end_addr % KASAN_GRANULE_SIZE))
> +               return -EINVAL;
> +
> +       if (WARN_ON(start_addr >=3D end_addr))
> +               return -EINVAL;
> +
> +       head_granule_start =3D ALIGN_DOWN(start_addr, KASAN_GRANULE_SIZE)=
;
> +       head_prefix_size =3D start_addr - head_granule_start;
> +
> +       if (IS_ENABLED(CONFIG_KASAN_GENERIC) && head_prefix_size > 0)
> +               kasan_poison_last_granule((void *)head_granule_start,
> +                                         head_prefix_size);

As I mentioned before, please rename kasan_poison_last_granule() to
kasan_poison_granule() (or maybe even kasan_poison_partial_granule?).
Here the granule being poisoned is not the last one.


> +
> +       poison_body_start =3D ALIGN(start_addr, KASAN_GRANULE_SIZE);
> +       poison_body_end =3D end_addr;
> +
> +       if (poison_body_start < poison_body_end)
> +               kasan_poison((void *)poison_body_start,
> +                            poison_body_end - poison_body_start,
> +                            KASAN_SLAB_REDZONE, false);
> +       return 0;
> +}
> +EXPORT_SYMBOL(kasan_poison_range);
> --
> 2.51.0
>

