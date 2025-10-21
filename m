Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2F1ECCD1AB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 23:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDDD8E0011; Tue, 21 Oct 2025 19:07:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC57E8E0002; Tue, 21 Oct 2025 19:07:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02468E0011; Tue, 21 Oct 2025 19:07:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF9958E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:07:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3FA3E1A047E
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:07:22 +0000 (UTC)
X-FDA: 84023659524.22.4213059
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 288A280005
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:07:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k35APQ7J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761088040; a=rsa-sha256;
	cv=none;
	b=Q+9wjEi26v3EYjUTg7Au5jBW7om8r/PnNV7JQ88bMW2s+k7tUl4bonp6d5kvhNn95Kt+GW
	fvaUvOCE1BurYEAKhCe+kvnu3QeF//AipXqA6fd9eMZNC3lHPdW6fJoKIjeQ3Htjhe9h8F
	/UunuBNx5MtZTOQ9b5gp6Wm5qV0XFaw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=k35APQ7J;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761088040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUs/wuT0kfUsxmbimw3WNKm4HpGep0rE6iJ3jKWwffE=;
	b=PVqN3XlCUVmebGFGbAuXXPX527oyfcLJinvGxBO/ekL0w40hSO6yAsdM95YVYnizzg9oSK
	EHQSM2y/vrQ3ejRbjg/gy90M0CJEsx6JEyrXuFiMBsKKPoHlXKC+/1LlSXE1K6iZ/ZQny1
	DnsOCH26DYZaw1yPePr92LATRVG/Q84=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4283be7df63so1882628f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761088038; x=1761692838; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUs/wuT0kfUsxmbimw3WNKm4HpGep0rE6iJ3jKWwffE=;
        b=k35APQ7JG4CcbLd3LZNP5E102LOf8hvikEskzyUt5nGqYPHW9/kzYGFgwt1dRX549D
         I2l7iiaqqYFR5Pye44pCbarRkn9DB6rWwrOUeTv3QTcb1VjfsdrjxKszsb89G8d/VSkF
         MUdFfT6N7gU5aO+VcpIRt9yMDx2CNtkhq5lYAEU9JjrFbDr3H5XJbgdzPshXHtvN0rY+
         N1bwnWtiurXgu+qybSQVLYmnY0KEr8CgrPV3dVo8IqNvMzFQasIvUaIRONYx/oV3LztH
         UQ3TRTcdC81Igfdfbaf4kWt4CYCd6rR6b6gko9Jd0jPW8nT8/AO1T8AjXOyUXKx/xCDu
         9uQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761088038; x=1761692838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TUs/wuT0kfUsxmbimw3WNKm4HpGep0rE6iJ3jKWwffE=;
        b=kFH3oxnJkDY9A1es9C+JCkUD459I1Hioal/ZVParri2eqOEQgYpPdlyxmAD7qXeaS4
         +wORdqZKcPmJzP7fGnWpCAetZ+vh87p41a87iuxS7YauEZqWzLuD7kBxXOW/Mspxe72V
         LxsUMqvNMlBvCVpmM/Xo+cy9ERrD9YoV4Y3MuBGJ6ta/nD1LnViYYvEelUQLVt0wpll3
         quhbobiROABMZcqqKSQqhCv1dyu/3x62cuqJPSI02EL0MTVs5NMcW1ga6cW6m+1orDDD
         gqXqnxN2g77BWiJAe0+FRJBKqAp6tYtEva0fNu4M+w9tL0IIOD1sQ/sAQ95yPPrsquPn
         PP0Q==
X-Forwarded-Encrypted: i=1; AJvYcCX5eGgRa9zuaw/BoPzQfP0DF8wYEqsmOAbi+YAh0v8Qs68ApadT7nBGN7osjDdB9Zf8jwaTpFiiVw==@kvack.org
X-Gm-Message-State: AOJu0Yx/HEkCDCt6qJ+OGWeSeHUFCpbEeKe9msfVer+5ectaRp4Lp/fj
	EABiKezV7qBNU2gVz4h2sUzk7U7NakFalSmkba6KipvhNxrfe37UM5Pa+rwmEdF6LKYcWlqgAUY
	jS8uU2I/V5Pp1X9eSNTnWafEkfOMZfgc=
X-Gm-Gg: ASbGncuLWKLPXwHYP3vCMLKtEGn4tljn1By81PqofcvdNFugy/xUDHYKgkFuLEwU7ue
	x9fsIu+jc8nRmLxY2JQ4E6fTqNsa7T1vQ8n5l5LrC8AFr9tMH6WOgNHYmbHjtybZ7LpGXIWA8fz
	a2rI5NKMSHzEE0wDcrX0iQYUTUck+1MxdMTx93Ya2MoTWM5xMcdYCnfAtbbIhs/NmKfh5FVq2Da
	m2p59VW1yYUQGZo9YHipqy414yoj4MawqVvBQWi+JiH/hd2Sd621D+SK2ni+0rY3Bs8yRy50I2c
	R/CVPwOlXk75WfYUnADbn5YhCTXBav9psbFD7I6l
X-Google-Smtp-Source: AGHT+IGQHFZvIWqZUrqUsZZZ+Q/stC/g2UdHpo6nn0sLp1JYS0sru3nHrLYk6NYzKyTl+sxTOdX9V4AdnflXA+OxrLY=
X-Received: by 2002:a05:6000:4703:b0:427:690:1d84 with SMTP id
 ffacd0b85a97d-42706901d9fmr10929644f8f.32.1761088038428; Tue, 21 Oct 2025
 16:07:18 -0700 (PDT)
MIME-Version: 1.0
References: <20251009155403.1379150-1-snovitoll@gmail.com> <20251009155403.1379150-2-snovitoll@gmail.com>
In-Reply-To: <20251009155403.1379150-2-snovitoll@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 22 Oct 2025 01:07:07 +0200
X-Gm-Features: AS18NWCmo3ddiV-eCF44oMWKYeYFjMfIoy4ZgUCJRQ4FNMTlti9w47Jhqig1JNY
Message-ID: <CA+fCnZfwPU0_LJQsCbatD3kd8vLE-ep06vZikNaR0W6-6UrkDQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] kasan: remove __kasan_save_free_info wrapper
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, bhe@redhat.com, 
	christophe.leroy@csgroup.eu, ritesh.list@gmail.com, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: imjq5fus86s9ajfoxrxb3phhs755q394
X-Rspamd-Queue-Id: 288A280005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761088039-891678
X-HE-Meta: U2FsdGVkX1+T959d1a1qqIgXpMLLt8SmGWuPpAvJ3JEnkpcpD0gaBwoCTqnS7ePlvirx9WmZBI5+kRyp7TafFsdZ4tn7TzB8BpuhMVA+lT6peViSxLCba1JNzVBtL9sAGCUI3FpZVCm0r6ivNdT4FUS6nZiGCqe4iHEsULLu1fZDGUH5wZPQBOulyO6KfLYmfi2iHbBLNhFz/lt6ihndq7GZPihv9VsCQH7JZnGNAZTpRswicMiE87VfTM99AoYh5On/+Ph5bJ3KX79J1O8pyymr4jIa2LBV8IQkAkMMW8JYYn6fxFZn1Dm26kVhg13M22Hr0QY3zNDC8B99wunkO596LnSyE28XZhwX1NsmW2ffUyFKsrdPJFQMPJux2LbJpW86YjRGAVK+9Gxn+zwlpY6GpD00/PpTrezP4IDf9tqi5PMtjINoKCuLkiPirEqBesuvuZC+Jefdnr5giCxD4w41G4XUltJ9w0//D/bsSuqUv2cetrxVaoaSQxXvq4+lC8HruWn0UTBK2DBbMulLGjc/So0CuuSafoBkj3GC1MQusejbVbTUulElqDNetAzXVqEAfAttZrFXNKd6Chqx1mleBzB3sZiOf04DaBJaTksRE1XjxK04uf/r5lf2+5oXfdLQm+XQrhx9aJYYYt5P4moDm9DQYR1RhOi9XWb7T+9dZ3KZS+k+940LYKaXTU+qwCFoJlnfT1Bx286W3hv+/IzFHssCMn4+Qa6/4Fm1YTY9LxFAlvQUZkSc5VpeKLSqopXvvSibwoPsn8vW4loH1uteQ3cTgL5Rq7d6p9UYOxyGxBp6ovr18KAlINMefZXeLgzwwRW77M9ejktTtx8ZJKKGZ4cMdqI42KW92PCPynP4rbaKMx+wIebOnh7mIyHqAX+gwtOOMRa8CiP50USiDN0vHj+IAmsmyjCDnV+oyRxPaQk3BBWOr4/PEchvb4tqVnmSJo9YJGBj39dZjDd
 fMzNGO6Z
 FynBgbw0mkMfqCe/GX0ZoIC6QaIKhhBk/mbjH+dv7yiJovSrxIDHVs4hZcjGOzwkMzsItDIxzu3GgSUyCAWlV56EMF4TrcURhTPoXAIUoG2iME9/aAnYwIf3bzjO8y8Hx/0JAuM+Myscg9lE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 9, 2025 at 5:54=E2=80=AFPM Sabyrzhan Tasbolatov <snovitoll@gmai=
l.com> wrote:
>
> We don't need a kasan_enabled() check in
> kasan_save_free_info() at all. Both the higher level paths
> (kasan_slab_free and kasan_mempool_poison_object) already contain this
> check. Therefore, remove the __wrapper.
>
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> Fixes: 1e338f4d99e6 ("kasan: introduce ARCH_DEFER_KASAN and unify static =
key across modes")
> ---
>  mm/kasan/generic.c | 2 +-
>  mm/kasan/kasan.h   | 7 +------
>  mm/kasan/tags.c    | 2 +-
>  3 files changed, 3 insertions(+), 8 deletions(-)
>
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index b413c46b3e0..516b49accc4 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -573,7 +573,7 @@ void kasan_save_alloc_info(struct kmem_cache *cache, =
void *object, gfp_t flags)
>         kasan_save_track(&alloc_meta->alloc_track, flags);
>  }
>
> -void __kasan_save_free_info(struct kmem_cache *cache, void *object)
> +void kasan_save_free_info(struct kmem_cache *cache, void *object)
>  {
>         struct kasan_free_meta *free_meta;
>
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index 07fa7375a84..fc9169a5476 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -399,12 +399,7 @@ void kasan_set_track(struct kasan_track *track, depo=
t_stack_handle_t stack);
>  void kasan_save_track(struct kasan_track *track, gfp_t flags);
>  void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t=
 flags);
>
> -void __kasan_save_free_info(struct kmem_cache *cache, void *object);
> -static inline void kasan_save_free_info(struct kmem_cache *cache, void *=
object)
> -{
> -       if (kasan_enabled())
> -               __kasan_save_free_info(cache, object);
> -}
> +void kasan_save_free_info(struct kmem_cache *cache, void *object);
>
>  #ifdef CONFIG_KASAN_GENERIC
>  bool kasan_quarantine_put(struct kmem_cache *cache, void *object);
> diff --git a/mm/kasan/tags.c b/mm/kasan/tags.c
> index b9f31293622..d65d48b85f9 100644
> --- a/mm/kasan/tags.c
> +++ b/mm/kasan/tags.c
> @@ -142,7 +142,7 @@ void kasan_save_alloc_info(struct kmem_cache *cache, =
void *object, gfp_t flags)
>         save_stack_info(cache, object, flags, false);
>  }
>
> -void __kasan_save_free_info(struct kmem_cache *cache, void *object)
> +void kasan_save_free_info(struct kmem_cache *cache, void *object)
>  {
>         save_stack_info(cache, object, 0, true);
>  }
> --
> 2.34.1
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

