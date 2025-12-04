Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C2C1D216AE
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 16:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 878F86B007B; Thu,  4 Dec 2025 11:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 850706B009F; Thu,  4 Dec 2025 11:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78DCB6B00BE; Thu,  4 Dec 2025 11:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8366B007B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:39:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42F871402F9
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:39:24 +0000 (UTC)
X-FDA: 84182349048.30.D6DAB5B
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EBFA120016
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:39:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NwbTk6r0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764866362; a=rsa-sha256;
	cv=none;
	b=Cpybe9vG73BpxwnSVDE5FPvZBaKLTT+mHf22dOSSAnA4QXjcRiH2eIxbAVMUK9F+OtU3mq
	di0UO/ydGwGDamr9LT42z3vC8E+iY3cGCYzvKvgnWYCCxXLoOmvnbMjCkqqeJ8NxMfzM30
	vc6Nc+b0AzbTEoGDcxmiStVlU0Fx+34=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NwbTk6r0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764866362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCk7JgdAPLLkYhpcS4mPpcBCsA+/FaiQTCAUq224jgk=;
	b=vprC/sU+Rc2poCcItV0rgoWeZZOukCjGO/Y/8tkQS/P83Yu7F7K62z8bTNHHegKA70mgrL
	OLb1Q9IXslX4TncUmmwwtTcC3o9OdU8umKsioSfUv91dOSmSA7OhtRjrdKLG0x48IDe3o8
	fYkQ3yrFdleQ9gQzCkqMGrWAkNgYl7A=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso710339f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 08:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764866361; x=1765471161; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hCk7JgdAPLLkYhpcS4mPpcBCsA+/FaiQTCAUq224jgk=;
        b=NwbTk6r0YEyUMTt2KxDBVq4wgO0ay2eB27cjV9U5l6Uqv5v/J0+d9zLsZ7UwFUOg4c
         XfQRUJ596/KX/jgHNxy/K/rI3f4Ifljo0BlZUs4wfNz2mTQ1VUxh594lq0dqT1Pz9070
         vXQMy9IbWlIwYR3zBacgpO2qCoeSixTqAFMekcLsBWJprpfGDBWqmogTT+NhgoMfWR6y
         1nlNrmOsUI+bF/Kq+3kHaN+2J6kw3y9A25QGj7wkDzL0Pt78ccjvoVRe6Z+OsXXvqC3N
         jNvE3dta5vb5EsQNZLVaE9nwR/Mw+YDkB4Mb9N8oS0iP0WxVigy0R2bgptShRO19vJtB
         zdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764866361; x=1765471161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hCk7JgdAPLLkYhpcS4mPpcBCsA+/FaiQTCAUq224jgk=;
        b=SiJPlqnREGG7AIaRWoLW1jIDvUeHW7V3WQj+Fl/v5SlwELLrUA/eDTXaA6Dx3QC3jt
         J5g1Dg+msvGAvDBxduepGEjToNYVyZvq0rD02mULwgbzTNdL/njlWIv7SQCZx5CVqDjk
         Fgu1ZB5C0AeQWyYunqYnQ4GJkzd49utSCaEX4bXjVklkaGgpG1YfF3kwZT9VfaKOWfYo
         EV410VIZW1oT9b4gQ8+5OBmSnvRmi7ZJLGsQ/XPMGFK+MnMUIQ2EtbKxXIHywhpOQeys
         3ZeyM4wohYuuUMkCXW9Ix1Skc75b1bHebtjDMUF/Vl9NRKVTBD809YALuC4f7NXO2o8v
         +yRQ==
X-Gm-Message-State: AOJu0YxzZoALOBlZ+aPkfUeEnrJyfwrDYknfx4JnmSUsrwWqH7KarkdL
	fu3ijeui3ZacQZv3leLrFjnKVws7tWHvS2Sfi5pDE3zM9qy33TsTNRB/XtfFPLdpt0hIFvCTMsD
	whD92CTIpIOIYJZ2L+i//yKuWinWPdCw=
X-Gm-Gg: ASbGncu/eWgOvJF2Il8AGCJ2Lpys8L6RRT0xo8ydKv70NRJMqyuQG4Q4PPG+g/KnUBJ
	5szASpyMBmzTDG/SYCZM8+gh6zdNzuC+7TIqGUQ/wIFXr8Hfo7NC861uZdIeobFEj5tn62gU9AN
	XeUyzDTKG2jQJP8lr1D45A1SqceR9Q3xWvl5Rt6ND7HCmmPXF4IJmGacFcMfad1LoozMBgHQh6b
	DDjpabWc34amliCJ9WWMORhwMLQ9qUx5Bsbbg2CnJaVeJ73Ki/xjdGOAsZfzLbwKVwnlDl7SIgh
	tSM8JlhjRXW0w69HLl+StqEhJbiH+aYzYDow44Y=
X-Google-Smtp-Source: AGHT+IH6eC+G7DJcYKZysz/wZNnhwLWNXumkT56cpPFdLUowfZ815U1Yxtr7meerF2BouQRmu9P8dfyDE5ZnzXmcl3E=
X-Received: by 2002:a05:6000:2c0c:b0:429:d186:8c49 with SMTP id
 ffacd0b85a97d-42f731bcd25mr6805868f8f.56.1764866360830; Thu, 04 Dec 2025
 08:39:20 -0800 (PST)
MIME-Version: 1.0
References: <20251128033320.1349620-1-bhe@redhat.com> <20251128033320.1349620-3-bhe@redhat.com>
In-Reply-To: <20251128033320.1349620-3-bhe@redhat.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Thu, 4 Dec 2025 17:39:10 +0100
X-Gm-Features: AWmQ_blUh_06nghjvNtkMSFLLH4KmVbjTWIqXM8ANs1LK16keDIndnTKt6SV0Qo
Message-ID: <CA+fCnZeHZ4+8GOn0untumM0TE9TeSHqja9kAsbEb-+jbEFNQQQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/12] mm/kasan: move kasan= code to common place
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, glider@google.com, 
	dvyukov@google.com, vincenzo.frascino@arm.com, akpm@linux-foundation.org, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, elver@google.com, sj@kernel.org, 
	lorenzo.stoakes@oracle.com, snovitoll@gmail.com, christophe.leroy@csgroup.eu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5EBFA120016
X-Stat-Signature: gnj5gux8bwc8foihki4mftohib3a4of5
X-Rspam-User: 
X-HE-Tag: 1764866362-502141
X-HE-Meta: U2FsdGVkX1/AeJj5qfZRt9Oa4ObuPXi0NUAXx7qpmbe+H4KBYS/s/8YFp+LELbqEQxpaZJ+azwLtRabmvuimFSKpEqjtlpjH2CH9+hljVilPMpBsvAADi6K20Q3qCSGuXxohwWoOCHSiFsCc6vozH51cQjjEuLtkmcTNnLgd1RUzjw6zGU+eyKkPiqgjkI0wWP2HnvUuRV+Sui8z1KoPCRkWzi+ChOJ1glpBDvKM2bwQxj2jocSpvuJ9LH1YklUuzX1q/rgtIhUPefn02YlDDXEm1mkDTOHZbuIhp4YgQDA8/BFflO2FMWKtDHIB4bWXEg3jE1oKTEmsttiCC1uui0tEg3jOnlcMSoFYeSO7vGsi6mivTjkOwTrl/4Nw4MvI5Z3hURAXnkGpsXBR/oB/oyo25q97NIVOtqGTFrqUvgYZ7DnJ+/F/mdWcJswkitH1XG488Uqh6DZDRd4V6nH0cEWGOSmBFWntSO6R0dnCbB7hz7/i7OL5DMyhRoJ4ogX3mLkBEredXU4jRClXLDhPn/y1ddk9Ej31EvR7N0C8iOEdaNPFF0ckZ8J19k34g/7DevEFbIalTYJGyL8CH8Rmt3QJ3jFAfLGlAb9tXR6hJb7FxEmITQeN5PZmoWygZd+h0MuTZVvbdLvMAK3GsB2SwMly5t6DFpRJXhnyO0fo+WjesUB4nwLHFdvsbLtSrFCSHpBAW0mq3Sg7iryWeLx85hINr6Hz6PHGCCsS70LdQsjORfCCG+5xkFg+CrYth1bj4nG9d3hAF+4ZBW9SdbvUctKsBr3YvlbGBIaVncKhGmzRbacCgqc/Bx8ghWOezPdUNG33oNS4iBb7vk7dXfg8vL+FZhSShX25FH7gN2L6zEAO2bXi0OHIVj3SAUZX3scvqqOazI4BF9H4potu+GduJ4sSOsxbxaIUeRVAM8KJSIz8esKgnhhinW0dTo4cm+1amdAF6v+AtQC9vU6Extf
 PpDtWa+y
 dUlLaibHKf5eohCbYg9o4Nvp91XCbT1clx0jc9nnoA7NxfsEYkBQYfLIrF5+Jtu80xxYGgLKdypU73cw+o2ROr8fuUquu2M+hCciTy3thA8DBoWl8fLmpBz4plpWZrOJFObsw9WwdgA6lWfsI/r6tyXYxuziuzj1zCCza0Nkv5mRrVS/1kAf0CapWc7a7mf4fARZCS0pUsWgadUQPRfO8M2q5XGbQvJgy2t7jejaK1vdMKKreSCH/3czN0HnJzYOasf70xd6Ef4CgDls9tw8Fzs80kvfNtrgRmKgO3vqCMToqwVfGQEixUwIy0AjhdjBU2P0mNygbFZ35boM/GJSO8dnx9CzHupJ7HFtvXdPl0O/xk/EeO4cbiENm5GBgGB+CNG2CGd2NaYghIKTgxH7vqcODLhSv4wLL+buZ1P8hjampGPJ0CW9lrFNSfg3aq9Usw33X
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 4:33=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
>
> This allows generic and sw_tags to be set in kernel cmdline too.
>
> When at it, rename 'kasan_arg' to 'kasan_arg_disabled' as a bool
> variable. And expose 'kasan_flag_enabled' to kasan common place
> too.

This asks to be two separate patches.

>
> This is prepared for later adding kernel parameter kasan=3Don|off for
> all three kasan modes.
>
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/kasan-enabled.h |  4 +++-
>  mm/kasan/common.c             | 20 ++++++++++++++++++--
>  mm/kasan/hw_tags.c            | 28 ++--------------------------
>  3 files changed, 23 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/kasan-enabled.h b/include/linux/kasan-enabled.=
h
> index 9eca967d8526..b05ec6329fbe 100644
> --- a/include/linux/kasan-enabled.h
> +++ b/include/linux/kasan-enabled.h
> @@ -4,13 +4,15 @@
>
>  #include <linux/static_key.h>
>
> -#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)

These changes of moving/removing CONFIG_ARCH_DEFER_KASAN also seem to
belong to a separate patch (or should be combined with patch 12?); the
commit message does not even mention them.

> +extern bool kasan_arg_disabled;
> +
>  /*
>   * Global runtime flag for KASAN modes that need runtime control.
>   * Used by ARCH_DEFER_KASAN architectures and HW_TAGS mode.
>   */
>  DECLARE_STATIC_KEY_FALSE(kasan_flag_enabled);

So kasan_flag_enabled is now always exposed here...

>
> +#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)

but the functions that use it are not. Why?


>  /*
>   * Runtime control for shadow memory initialization or HW_TAGS mode.
>   * Uses static key for architectures that need deferred KASAN or HW_TAGS=
.
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index 1d27f1bd260b..ac14956986ee 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -32,14 +32,30 @@
>  #include "kasan.h"
>  #include "../slab.h"
>
> -#if defined(CONFIG_ARCH_DEFER_KASAN) || defined(CONFIG_KASAN_HW_TAGS)
>  /*
>   * Definition of the unified static key declared in kasan-enabled.h.
>   * This provides consistent runtime enable/disable across KASAN modes.
>   */
>  DEFINE_STATIC_KEY_FALSE(kasan_flag_enabled);
>  EXPORT_SYMBOL_GPL(kasan_flag_enabled);
> -#endif
> +
> +bool kasan_arg_disabled __ro_after_init;
> +/* kasan=3Doff/on */
> +static int __init early_kasan_flag(char *arg)
> +{
> +       if (!arg)
> +               return -EINVAL;
> +
> +       if (!strcmp(arg, "off"))
> +               kasan_arg_disabled =3D true;
> +       else if (!strcmp(arg, "on"))
> +               kasan_arg_disabled =3D false;
> +       else
> +               return -EINVAL;
> +
> +       return 0;
> +}
> +early_param("kasan", early_kasan_flag);
>
>  struct slab *kasan_addr_to_slab(const void *addr)
>  {
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 1c373cc4b3fa..709c91abc1b1 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -22,12 +22,6 @@
>
>  #include "kasan.h"
>
> -enum kasan_arg {
> -       KASAN_ARG_DEFAULT,
> -       KASAN_ARG_OFF,
> -       KASAN_ARG_ON,
> -};
> -
>  enum kasan_arg_mode {
>         KASAN_ARG_MODE_DEFAULT,
>         KASAN_ARG_MODE_SYNC,
> @@ -41,7 +35,6 @@ enum kasan_arg_vmalloc {
>         KASAN_ARG_VMALLOC_ON,
>  };
>
> -static enum kasan_arg kasan_arg __ro_after_init;
>  static enum kasan_arg_mode kasan_arg_mode __ro_after_init;
>  static enum kasan_arg_vmalloc kasan_arg_vmalloc __initdata;
>
> @@ -81,23 +74,6 @@ unsigned int kasan_page_alloc_sample_order =3D PAGE_AL=
LOC_SAMPLE_ORDER_DEFAULT;
>
>  DEFINE_PER_CPU(long, kasan_page_alloc_skip);
>
> -/* kasan=3Doff/on */
> -static int __init early_kasan_flag(char *arg)
> -{
> -       if (!arg)
> -               return -EINVAL;
> -
> -       if (!strcmp(arg, "off"))
> -               kasan_arg =3D KASAN_ARG_OFF;
> -       else if (!strcmp(arg, "on"))
> -               kasan_arg =3D KASAN_ARG_ON;
> -       else
> -               return -EINVAL;
> -
> -       return 0;
> -}
> -early_param("kasan", early_kasan_flag);
> -
>  /* kasan.mode=3Dsync/async/asymm */
>  static int __init early_kasan_mode(char *arg)
>  {
> @@ -222,7 +198,7 @@ void kasan_init_hw_tags_cpu(void)
>          * When this function is called, kasan_flag_enabled is not yet
>          * set by kasan_init_hw_tags(). Thus, check kasan_arg instead.
>          */
> -       if (kasan_arg =3D=3D KASAN_ARG_OFF)
> +       if (kasan_arg_disabled)
>                 return;
>
>         /*
> @@ -240,7 +216,7 @@ void __init kasan_init_hw_tags(void)
>                 return;
>
>         /* If KASAN is disabled via command line, don't initialize it. */
> -       if (kasan_arg =3D=3D KASAN_ARG_OFF)
> +       if (kasan_arg_disabled)
>                 return;
>
>         switch (kasan_arg_mode) {
> --
> 2.41.0
>

