Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60312CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 13:02:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4089940007; Wed,  3 Sep 2025 09:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD188E0026; Wed,  3 Sep 2025 09:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 731A6940007; Wed,  3 Sep 2025 09:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5C74E8E0022
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:01:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EBB1E1A0683
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:55 +0000 (UTC)
X-FDA: 83847951390.02.BFA8A76
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 07A6A1C0012
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 13:01:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YHLh5vhI;
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756904514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rxOgjN7WdDoAv2rvG3Wc6cb+dOveWBvcqA5WgB2sqzo=;
	b=j0wUgpA1e0nJKXXmAe4O0wNkNLWxiefbTpCAjiTRTLCYOBHJ0EYcZrBtfaBC/cWBPe9x1M
	4DZucl/BsmjHvnxeReeVAnKcv2AL/JkC3Sc2fmz8OO0cPq46nJM09w8jdWoCYlmf7baNL3
	QMEvacJl90ADVjaMG3wESJmJy/Z4Yog=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YHLh5vhI;
	spf=pass (imf20.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756904514; a=rsa-sha256;
	cv=none;
	b=HTfOSeNM6pgZP2ZDedAMl6NSHKWhvAbtsXza+AwtqXzEwohZ5+6uPOVm8V+cgvScqEuCvc
	C5PkX9vHJ7K7BOov3rHXvB6SNhOu4oumlIxBgRrL0i77t++iTgBZXjBP19r0mmgtaLYWIA
	waTn+r8vzJPpXLWb1js0nV+TQNlSZ18=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3e014bf8ec1so13049f8f.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 06:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756904512; x=1757509312; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxOgjN7WdDoAv2rvG3Wc6cb+dOveWBvcqA5WgB2sqzo=;
        b=YHLh5vhI4kgUQLl6GcTihgUmXdOd7lVawwRHSdOO/dzgZiQ/PI/lh8I17NfFypc7TK
         25neuTbKPLxnUlyWhiFf7j2Uq/f7k3b5syc79+9+U7lAugvuAbxkAKZG8BbSr1L1g/6m
         4ZGpCv6FxFnCeCnKEnkmIb1vxoORh6mqddHEWR2MqkKWOe7SYmV47zDg0S+DleZtB3H+
         PGI7c5cdo7flvle8yELk5RJ9RIWo1by+r74niHwEwb9ZvxehUQXNew496XvBgTFRtqQH
         Ro/XcKSYFIs/BdGBTQpDZZVtP3vnwBHR/MFHPIhLnoTSAj1pkUlpyC/xeaHgPPm+HNsh
         PxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756904512; x=1757509312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rxOgjN7WdDoAv2rvG3Wc6cb+dOveWBvcqA5WgB2sqzo=;
        b=MMqPTDY41vHD/xcitLF066amYUbKjKI37JSv4iz1ZeQha2oDE7b5DUnzWIaeuJdR3z
         AyeOO99JOy+mUspNaiUitoe2tbJO7aXujW09w54qEv6SZunJCRKZd+XtG+eN7Hx1a8aY
         CLIojRNo8K/NAkNljC5apeNBl/J1vTiM6G40T8O8T0DiUoFAeGEeHC0waxwaldz8B2Pi
         Y+uapWNnGmWi0QaXEJtDblSPccP4YXScvOja16IBiii2LELEYWQg+Dr9tUNH2ePZpQDC
         hHU1LVZMQhL0uKCAiMpigKZnQqBXgkMg/AnD+hnU1hwEaeCov2TdUton2yjObLvmG1O3
         qr3g==
X-Forwarded-Encrypted: i=1; AJvYcCXm6moRNa3VVapjd4BqXDIWQgtMfMHiibMyN4y3xVvVvQ8UEJ5tQ7MvRjD2VFIVcKeL0by28fQzmA==@kvack.org
X-Gm-Message-State: AOJu0YxYieOK/HnqkLg0vTYJh28GgdiU7PyeBQtSP0Dx2Tj01EoEIWNj
	Rg5D8qC7Z73ZQXy/Ib3kmt/fkybYYv0EvFamyX8G6TC6/cjAZulM2KplGVyHRn/Wy5BA4XcJB9g
	lMy6ZoCmiUPDklWFP+w6y8bOaQ5go/LM=
X-Gm-Gg: ASbGncuqFgZI29vOc0UqWtEgkzf8UmFeeTezKbiqwt2vaeeNxbwQxyJydoaoKK3UkdV
	W1E7EzsxqqwZrAk3KHBb8/3d7ex/4d/v9uuRX/igMRONjESZzUKj0v2qZE+xZeK6YcSdkFbqIiZ
	ACKyssUY5Ntw8e3ZjTXscoBJpQ7QjOhGcDhazKPG7Roqjogag5NroMEPejXMlioqcxl+5y1I9Dl
	RHwLUeM
X-Google-Smtp-Source: AGHT+IHaI9QHXphQW4NL4BWXS0uWqM/wJHgXqqOYeELhPBU/zEzYKTUTZN/+1NM3wCGA2AyzOKaLxaL5ucEtc3zspBA=
X-Received: by 2002:a5d:5d0a:0:b0:3dc:3b91:6231 with SMTP id
 ffacd0b85a97d-3dc3b916271mr3074458f8f.12.1756904512228; Wed, 03 Sep 2025
 06:01:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250810125746.1105476-1-snovitoll@gmail.com> <20250810125746.1105476-2-snovitoll@gmail.com>
 <CA+fCnZdFp69ZHbccLSEKYH3i7g6r2WdQ0qzyf+quLnA0tjfXJg@mail.gmail.com>
In-Reply-To: <CA+fCnZdFp69ZHbccLSEKYH3i7g6r2WdQ0qzyf+quLnA0tjfXJg@mail.gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 3 Sep 2025 15:01:40 +0200
X-Gm-Features: Ac12FXxqG38KSSLGvfY5HirQQyjqsvLS5blUVLw1nroWjuASE3O6kwm-RqaVNbQ
Message-ID: <CA+fCnZdkHATBYG4RJ8rR8MciKmeV4QGwVwoQjkhc-O_igpUBTQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] kasan: introduce ARCH_DEFER_KASAN and unify static
 key across modes
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: ryabinin.a.a@gmail.com, christophe.leroy@csgroup.eu, bhe@redhat.com, 
	hca@linux.ibm.com, akpm@linux-foundation.org, zhangqing@loongson.cn, 
	chenhuacai@loongson.cn, davidgow@google.com, glider@google.com, 
	dvyukov@google.com, alexghiti@rivosinc.com, alex@ghiti.fr, 
	agordeev@linux.ibm.com, vincenzo.frascino@arm.com, elver@google.com, 
	kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 07A6A1C0012
X-Stat-Signature: mkger1swyasd519aym7nuupqhkjhoewy
X-Rspam-User: 
X-HE-Tag: 1756904513-396621
X-HE-Meta: U2FsdGVkX19Ox2XwNzPkZFn8CQfxj+zckchEMZE3UPtLwcDei0oGSMCqaJAINuJph+iCoHtpkGBSu8gyaimYon+XUvQ0VdUCvB5omncIHGuoLcC/28edECSsfBQ0X87XtYxzjAarNpYbm3jG7jiuBvREMxAVcI4W9eg1egrZ1Ap5Tnl5nSGnMvLTs2/n/2OuF5IK111sT85tpze8pzBZNPU3OQThH4jODfVRxf8oqyDvtIsvcqpnEAXreXPZWkz+rhg4lkwDfjv5l31iC5DX3vov0430u6ZAb9IMFH+P2b2CXJOftPG+kiWVw8H9T6uvHjBcHJoXlfnY5hkZT7sVpB7PkUXnJDHjdNj5EaQkXTI4jsHrJjyuqPMkHNslLBeH63HI733LDczpkX5pa3l3L3IvsCSdYPY9My9Cwom4fp2+9apfdZchdi7OoCze4YmP6S8j7yD8z85vUhT7HZynxxj/hmxNm5JduKlTUgbJpdHnmpRWtX2LoNhxxasPkm517x/vwWd5jqaPXM6H7wTWhaUzeG/Q286JscSzRGq7l2jqovGX+dN6lXz8e+4g/p3rVexRvdxJxb1z2GLJUiO5IyLlqUEaCQUyB52fRkMZhehuPrI/YlzCQWhQhoA8DOz6lhKukMqCxkR+nMXi2uk4aPDptn+7GxKFCK5DDj6NgEvwgavlLhctj9HP7CwkZU04DY0C+TJZO2xbkgQ+IFxrPAA6lcgUj11rBbLkA+kq2lIVQkjG9xxpxeTd3Zr6y2AZXkaeHz2bvkE1AtkgMwRqxOlJqYj+Rb4J77rptDOSuKYdhhhFpNzLq+jVEiOsJk8c+tnIUwrSaD9pQRnq9wOlViMArYG8SPDNzdo6PuRtUiMDInwjELj/p8NAz3ZUdG7O6biVG2/r+MVILms7UNQQAtz4/Hpf1eOYfhjNbb11Ufp4kXlvMsJU7nBL+MrpHlNGusMhYGnPhzg6qkRbHbr
 10KJlVTp
 OaWaBTdXvg7AG/nFJ+S4kNLv7y7cU/WrORmedja5bXJUJ/nZpTHDtU/xzd2V8Q76ErVwyU/rV0goX32VrkhQBiwRymFZpQrCQULkE400VnuPvckSINZhvtfOttqvSC7equdHbA/OH1svc2cmPylJ4P/rnDiwu/vbibjbpftOPlZFAepLDs8vmmuZ31cHmxpaVEEdCe5ijCxsb+LO/P9KZRj7J85dncHJy5kJDTHoDwlZDL5AX+FkTr1YRLs31R4Y/j0phRCSlF6li0KyNL88YOFwFJHotSaiymjdOTu9TD10MQo4QiboTgiQR04yGoo/obWKUOF6vGoHH+UD9aZIT8N0LsAW5iQJyjSpEcKgYtFdKaADbIFQ8LR7e7zDkUMzqcSUqr2OP+GG4z6TX0TSjpwoG5h5NFRp6WKkZ1Omlzti6zF8sOJnknlx2XrUFoJQQ4Bto3uTTkyY1oO05mNwnJfpLrNozFj1/MoESooH3LnXDaXVCRcu0PdWb8s7SiOW76Q9e524VCVzvkd5+QFyL+IOcEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 3, 2025 at 3:00=E2=80=AFPM Andrey Konovalov <andreyknvl@gmail.c=
om> wrote:
>
> > +void __kasan_save_free_info(struct kmem_cache *cache, void *object);
> > +static inline void kasan_save_free_info(struct kmem_cache *cache, void=
 *object)
> > +{
> > +       if (kasan_enabled())
> > +               __kasan_save_free_info(cache, object);
> > +}
>
> What I meant with these __wrappers was that we should add them for the
> KASAN hooks that are called from non-KASAN code (i.e. for the hooks
> defined in include/linux/kasan.h). And then move all the
> kasan_enabled() checks from mm/kasan/* to where the wrappers are
> defined in include/linux/kasan.h (see kasan_unpoison_range() as an
> example).
>
> kasan_save_free_info is a KASAN internal function that should need
> such a wrapper.

... should _not_ need ...

>
> For now, to make these patches simpler, you can keep kasan_enabled()
> checks in mm/kasan/*, where they are now. Later we can move them to
> include/linux/kasan.h with a separate patch.

