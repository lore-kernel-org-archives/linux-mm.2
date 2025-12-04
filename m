Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42362D21696
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987BD6B00B5; Thu,  4 Dec 2025 10:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9376A6B00D0; Thu,  4 Dec 2025 10:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8267B6B00D1; Thu,  4 Dec 2025 10:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4B96B00B5
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:26:45 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B998B7297
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:26:45 +0000 (UTC)
X-FDA: 84182165970.13.92738B2
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2319120004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:26:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fYXLDovd;
	spf=pass (imf13.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764862003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRDq8VRZX7ObisK4LUGIJP6XjIFCzmZAVr9+RtuDKSA=;
	b=RIr2NXzcluc7zV7IWwRI7MGrXgxsHhrCBTAjOMmCSroGpgAulfRct0KPpEXVf12nxlqd1b
	itJsQ4odeuUFtTiJ8G9efR4e/0lQtq7XJMcxmYyEQqq7v8gtY5lmq3TUIeOcMwKzkPkWLl
	TLCmlUZEZzUtbI3zFAjN47eabchieAo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764862003; a=rsa-sha256;
	cv=none;
	b=V/yazSKoFNM4LSavq4wrjZc4RozAErO9VK6sLm/zd2ebq05lAND2H+rxdMTCIt5VVO8BxA
	SIDmw4axPOhJ/6EjtWir6hTnbx5lGKK06K6DjCGChfOgpOLX0MlXl3m9YyFHvp08zireQj
	mrwLdd8w0uZuQVYrbzDbpZPNJd7RFwg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fYXLDovd;
	spf=pass (imf13.hostedemail.com: domain of andy.shevchenko@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=andy.shevchenko@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7633027cb2so175586466b.1
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:26:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764862001; x=1765466801; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRDq8VRZX7ObisK4LUGIJP6XjIFCzmZAVr9+RtuDKSA=;
        b=fYXLDovdTqYFQfqsWVy53tuIOOAu0jEcyU6MfY6bspq70lugsGkMKJYmkqMzds+fbR
         S/7mMU5avpSD0sGQoAzUet5xOoeVjCiq+WAwgXbo69YvA0AkyB5+zfmN1710cWAmUbSR
         hLa5aFK0ADVd3GTviab2P94oUKEAdBmNN5NGYKxavAMaxx2ZNsOIO2YWb/So57yh4RgJ
         6z+VzJpfkoQ1+W76AAAbGJfEJTbp4/EyjXym587L+uF8kNmd8nvT6OQhFBr3LzFAdK6m
         LJgAUZ5z3PDPJkgkgkfWxWMnAPRjn5GCfDSBgMy9B8iy+lShZVZCpYMKjSTHqgpAdS4J
         8sbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862001; x=1765466801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hRDq8VRZX7ObisK4LUGIJP6XjIFCzmZAVr9+RtuDKSA=;
        b=A15CPmylpbxWTw+D3r4L/6rJTjAhJhI7w2LEii5gEJU9fHq8efU/ox+sUqnyqBSFeN
         XyBlL1CpgrYUKbNOmtqKPsVDGKxWEsZglcIkwVitS0wh+xBlfuU8DtyIZAn7AK+io6dM
         W8ynWuhLKwZIqMWmjkYB+uEnZaiPDAI6vfNkFZa6/PY/QdbZerf6lVpZwmGtEUA97H8+
         x2EUNi+yqlyajyzLaGXOWJy2X0jwNlYKKsPctIdrIc3ZUsShiK6yDmoHMkAnWHWes9YJ
         fd5amLgi1hvj258QMp0afEP/E0IplLe7lZqTgTNRvlRDkVAMTRjCWm3fQwuHx1K7ZYnm
         xVZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXIce/V0vlraQVK13ouOCqimV/z64LxGYym/s2e193zOFalmxOemfFibytLnoI+7esCEL6AsS0jUg==@kvack.org
X-Gm-Message-State: AOJu0YxkxbroS+mPlhdGSv7328GfxafDHasMoLLPvE6rK8za2/EyHFn+
	oMzmooyDoVyar13mum4Fd9V7GJM35NA8TH9gugn3cTB0ZyWBiQ/wmwCqiCgdUCTCoFTK9LuqsmC
	lXC+J1ednojnwTl1ndG15kUxEp0Metlw=
X-Gm-Gg: ASbGncvhcHPMi2TaIpS3XNLm5/902LNMinSAZ20Ic5yWb6v++UjwBZEp2Z4lMVzPSI2
	USZL2Erh9UNikJQCGwIFuYKy3+qswq2YJyUdr6oFxut8otTSTH0bHHg17mKdCu/TNhUE8FeudJW
	IeW4G9NJxpwtfzXC+99fcqp7iYx9SVFy2N7rlPyOQG7VEYu7Nw5juILW2LI++Zqwu6+oF0L/Kau
	f1AiegETq8O4dHo+XedkMtz8Ub8INhmNDm813grgNBgDF3zfRFvQ7CuKl3K91Ug1jokONEy8Ydb
	uT1bj64JYrgWxYKCpItFybsxGOlZarLeOPqIBauAjfaiC2IOe6hNs//thdMoph6Tdz4wEF8=
X-Google-Smtp-Source: AGHT+IHf4+6vdMmQuH6atM/AUDdteHFf5jPA5YYue6DOqMU4c8+wmNtqOkyMXD6oyoIIyUvm8ALQ6uS3zQy9c2rbSf4=
X-Received: by 2002:a17:906:6a09:b0:b73:210a:44e with SMTP id
 a640c23a62f3a-b79dc51af33mr666433666b.30.1764862001190; Thu, 04 Dec 2025
 07:26:41 -0800 (PST)
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com> <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
In-Reply-To: <20251204141250.21114-10-ethan.w.s.graham@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Thu, 4 Dec 2025 17:26:05 +0200
X-Gm-Features: AWmQ_bmIoeQpAWoaWpHaqI6dnG4PTWdKQq3rnGgG66adF0zPHqO5BwO2Z5x6PEQ
Message-ID: <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: glider@google.com, andreyknvl@gmail.com, andy@kernel.org, 
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2319120004
X-Stat-Signature: qgiyqocoh6txw71skbtqwd9zjasuz6zw
X-Rspam-User: 
X-HE-Tag: 1764862002-93780
X-HE-Meta: U2FsdGVkX1+qnAREF3IjkRKTlKxWaHtM6BdC4hX9be65MJghi6EzMVTWpPObi0dBP5bHmSaJq0BhuZjDxJdCfCZyFbz/uLaMY5lM4vDQ/JX+fngq7JF+MNX3U+hQARj6z9dX003wrBHB2GGdGCAHTa5Eqt1GYbV475zTZ16CrgzkFXEw3ykF2FncPw14dkHtIawVrqkMeiK23/R5qqI720caEPI+ndvba/Z/C4DzYSGCFzxF494nuKZotJNhBWPIcPzovO+9+RQwcQqAm1PskUKov5ENultreuAT7AHGkEQdZSEi5EtMqANhrmXb7cOaI55G/ZCzQPNt128g64mvtkAeltNw2nndPFaHU5FUyeQ3MnrZcEVWKd0D/wE1cNBML+MaEv/trP5dLxsJrWtmD2RvL1VGQwFd+ITGAfh7PdOLdaviHTilRCuk2bYXtKQo9pI9q3eJkhTDjQLSNTJZ4fnbtAQvy57x7fTBxCwq4dzuaIB6RdYaOEktkSR7qxHl7hvXtAuTrhYwdk6aPn7DrWMNXTsQ702XmijwD5Xx9iL/RCslSE8W63XG6mFuOu4iCk3Z6CxrF7hvkJMYQRTZ7RyJynx+GG7iUXrHrGSQhZMT38efJ+fOWphhrxv9XHJ8oYZS0kKPQlMOnJZ1FW7RCn9IrcM1/+8k6NkP3MKA0EefMaWdLdA9t2iRbqYVW9RSr6E3mQoBGGy0puPkePEey47YFlJ+Vy5YOZZ1yeVnKK56WVO7rSHxYpszn0MU+T0zkq01ZmL+62flrUXZDroV8A5xjSfpX8vNoLWhY15Zo8oPCpfr3ILKMC8H4atYLXFzcbdR7+nj5ElfwIxN6fjhaATvjyg0VAFZs+RgFBAmzKJOOU2+QcCunBYmzPtTGxPeVy8GsVZ4oE86P0CVhzPnGpgCsROQfsVRE15Ljee5r9UF73ibA6/NehJlifZBNaJ8KOCemyvNLvFQKl1KWo+
 qMm26HgB
 X5Ta91bXp2/BsHeof3fxEwGFF40GcgnzfhtV7A21ra7O3+kuCR/BiLyaPqI9F5w3vKqC4pFILR20edIM5ydvkWhU7UTW/+tSie7gXM5ok5H3i7BcezGtPPEK985TJY0Bdv0brQTiimGrTPXTJW++03Y2bTAV3bLMlwT54rv2eNs4DgCjD9haWPjAaKYBCxckeBWmVfh21f5fuahWAMY5jTeCS011DGxq0yYxraZbXKL0zB11ShkFUwDtKzLS+vhRwLvM4wHziFz6Jdaitcrzw7YaJjxxUjb78Ce+NMl+PhiAFwSwNT8+6koy8uoglntgL00o2Mj5WdEZ0L4AgmWRBi4tAf8GsVzPNF7xXajge8/b38ealQotRkgmLaNnWRcM0r+LIuFVqFH+EYgEn+5Kwe7/7JRw6cLG/UAu21WGYQPwseCkhKCfPsKuGcAYTwWhbVVB3rAdCCoAbjzeh7Mit5HK+DgvPNXPbgRZyfXz1AD4to5W8RBE1HiuBsGDwYgxxwuyTWFR3RUi/EnD+MTC0j0y/UhFt7pBYVGT9MbnBsd/IFbM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 4, 2025 at 4:13=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gmail=
.com> wrote:
>
> From: Ethan Graham <ethangraham@google.com>
>
> Add a KFuzzTest fuzzer for the parse_xy() function, located in a new
> file under /drivers/auxdisplay/tests.

drivers/...

(no leading /)

> To validate the correctness and effectiveness of this KFuzzTest target,
> a bug was injected into parse_xy() like so:
>
> drivers/auxdisplay/charlcd.c:179
> - s =3D p;
> + s =3D p + 1;
>
> Although a simple off-by-one bug, it requires a specific input sequence
> in order to trigger it, thus demonstrating the power of pairing
> KFuzzTest with a coverage-guided fuzzer like syzkaller.

fuzzers

> Signed-off-by: Ethan Graham <ethangraham@google.com>
> Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>

I believe one of two SoBs is enough.

> Acked-by: Alexander Potapenko <glider@google.com>

...

> --- a/drivers/auxdisplay/Makefile
> +++ b/drivers/auxdisplay/Makefile
> @@ -6,6 +6,9 @@
>  obj-$(CONFIG_ARM_CHARLCD)      +=3D arm-charlcd.o
>  obj-$(CONFIG_CFAG12864B)       +=3D cfag12864b.o cfag12864bfb.o
>  obj-$(CONFIG_CHARLCD)          +=3D charlcd.o
> +ifeq ($(CONFIG_KFUZZTEST),y)
> +CFLAGS_charlcd.o +=3D -include $(src)/tests/charlcd_kfuzz.c
> +endif
>  obj-$(CONFIG_HD44780_COMMON)   +=3D hd44780_common.o
>  obj-$(CONFIG_HD44780)          +=3D hd44780.o
>  obj-$(CONFIG_HT16K33)          +=3D ht16k33.o

Yes, this level of intrusion is fine to me.

...

> +++ b/drivers/auxdisplay/tests/charlcd_kfuzz.c

So, this will require it to be expanded each time we want to add
coverage. Can this be actually generated based on the C
(preprocessed?) level of prototypes listed? Ideally I would like to
see only some small meta-data and then the fuzzer should create the
object based on the profile of the module.

Input like:

bool parse_xy(const char *s $nonnull$, unsigned long *x $nonnull$,
unsigned long *y $nonnull$)
Or even with the expected ranges, and then you can generate a code
that tests the behaviour inside given ranges and outside, including
invalid input, etc.

But okay, the below seems not too big enough.

> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * charlcd KFuzzTest target
> + *
> + * Copyright 2025 Google LLC
> + */
> +#include <linux/kfuzztest.h>
> +
> +struct parse_xy_arg {
> +       const char *s;
> +};

> +static bool parse_xy(const char *s, unsigned long *x, unsigned long *y);

Is it still needed?

I mean, can we make sure that include in this case works as tail one
and not head, because otherwise we would need to add the respective
includes, i.e. for bool type here, which is missing. Also I *hope&
that kfuzztest.h is NOT Yet Another Include EVERYTHING type of
headers. Otherwise it breaks the whole idea behind modularity of the
headers.

> +FUZZ_TEST(test_parse_xy, struct parse_xy_arg)
> +{
> +       unsigned long x, y;
> +
> +       KFUZZTEST_EXPECT_NOT_NULL(parse_xy_arg, s);
> +       KFUZZTEST_ANNOTATE_STRING(parse_xy_arg, s);
> +       parse_xy(arg->s, &x, &y);
> +}


--=20
With Best Regards,
Andy Shevchenko

