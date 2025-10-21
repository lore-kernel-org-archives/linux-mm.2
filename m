Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D012CCCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 23:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2138E0012; Tue, 21 Oct 2025 19:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9418E0002; Tue, 21 Oct 2025 19:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF7C8E0012; Tue, 21 Oct 2025 19:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EFFA78E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 19:08:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3C74BAAC1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:08:07 +0000 (UTC)
X-FDA: 84023661414.21.FDC21E7
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id B2BE0100003
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 23:08:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fCzzms0K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761088085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H37xO2Fy8H7/W951P5nhrd9q2BRvh9lu87ubrZUHMGY=;
	b=hQNv0PtERiPW6y1myCAlu48tvdIjo+sDWJExJ++326oOHKw/gLHeNgFDgfVV+QJzv8coSe
	TbCuvRlXAxi0XjmL7r/JwiF7UdkwELFx4d5xZ+dpAGDizU9vpkoO8eEUn09F/Ug869+iSU
	VJTLhqCmF7QqeHFyD521UzAEYpb12qs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fCzzms0K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761088085; a=rsa-sha256;
	cv=none;
	b=fFdrg7mUOXay+pIFVrZoPqLN631mHi8jMj954QOWrGbtVwA6lSIGXQK0nsSizgNObarn1M
	DuOv4QmyjtdicN+xjQgSTX5d2Dl6fbvbZ5ULENHwawJ9PI8ILlKaK9cFKLS/FT+gHD3+38
	vHh4Qy2ejNsWqUEI5sZnnifbbEda3es=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4283be7df63so1882710f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 16:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761088084; x=1761692884; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H37xO2Fy8H7/W951P5nhrd9q2BRvh9lu87ubrZUHMGY=;
        b=fCzzms0KZlD9wwWf+VZsKu1POX/Tlk1q3p49seJMJ1ACAqCzv4CadSoKylBoyvTFVY
         XCQPaslaOSw6yVItEqfnTrY+SL7ZulXt0SkBz96DVa8ymsvhifKVwrRVRn+GK4rfRzFE
         Utg0go2QXt2kj/WGNvSRHO6DMweMvGDBRsEZbceYexOFj0i1qOVAGGLr82pb238ofwYI
         /xRnhQniR5/9GgImplzqGsNcmBgYhDeA9s/orxMSIcbFLrjjwG6yrszca+Q0VxdEXRSV
         IGcHe1NoxLv6eV8qq+pkjl6WUuwHJz+RPi0xtsgVvuHeYt01LOBInRpsmF6LLGHTGpAq
         rogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761088084; x=1761692884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H37xO2Fy8H7/W951P5nhrd9q2BRvh9lu87ubrZUHMGY=;
        b=ZGLuZNAG3DngW0FVL7BsskKKsgLFUj+JVGunh9xDBOKi+OckMKHJjHpZgDORVYDyz8
         P7nQ5vwCqDJSR4KyZIg8Q2nuvRfZygIyt+srv3vLvt6lkFqolQK+s3yCpcDcKq9Cnxyw
         pgJOsNRA/wTgqdealUOGcQT2wBcoxo5HkqLXPd/9B+Js7cS1qDvWOboByA3mt0OUTN4i
         HJilo06z3SL0MZA+mhPAnqxO2sydwN0v9t2r5n6OrfbOkKCLCfcOY5O4iegoAMm7JOM6
         kN/KyigjosZExuqybxyjWduyKa8nZrZMyXqjKoNBvwmq7CqXiG3bJijUQ4PB55OYa/c1
         JbYQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzOqfhma1e9s/Up4O7ijYqNVW2h+EgS6QCB1EPM+VVbom3XCwEW4t/iv1SSDzvE8hx6YMZlugo0w==@kvack.org
X-Gm-Message-State: AOJu0Yy95BPMh0Scdtg+PjsevSVjc51qxysaL2zXctC36eq683GOg/+b
	xxyydbH+LK9Qgl4gQtQPMdek0lnOEi4z2b9vn+FyFwJL2VS/e93v6tmU7OVK7IJOE/an5xSxpYB
	E1o8a7DmPJh6OessdIMIWA2NUszDgmgY=
X-Gm-Gg: ASbGncsO+pp+R7A5Sb48RohgZULc6JZiy8qTXD/P7y4B988GCqJZ0jydxw6ZtdbnwPa
	dqw3a+cfN1YVdiV9EGJIggO6M+yFJhtk1aQ9KvtS7cU00JORbAm2x42bdD0O5q31p+zOHut0GFs
	nJV39yIplzmeD0q+PjZvOgIM2HAedvFWVkLx2/UZqRArWRlztiwSCsQ12tVNofgSGyrp959tNF2
	fKKACZdH/wZc1aohI/qYMHsh5hu0SrNFWDMAxGrVlNTCH1cGD40Fgzfz83KR4INAaNA1ZQrsYAC
	EldcE/ZDJTxc5HFbvRo=
X-Google-Smtp-Source: AGHT+IEWPj2I0xxnPz4/dkJe7RhQBxRU9fyNVOntXO7PLacZpfmaJiw0Rgj9CHaIbpqxxcmt9zLxveNrifPcF4PaPoQ=
X-Received: by 2002:a05:6000:22c6:b0:405:3028:1bf0 with SMTP id
 ffacd0b85a97d-42704d49805mr12349472f8f.10.1761088084218; Tue, 21 Oct 2025
 16:08:04 -0700 (PDT)
MIME-Version: 1.0
References: <20251009155403.1379150-1-snovitoll@gmail.com> <20251009155403.1379150-3-snovitoll@gmail.com>
In-Reply-To: <20251009155403.1379150-3-snovitoll@gmail.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Wed, 22 Oct 2025 01:07:52 +0200
X-Gm-Features: AS18NWA2pgO8GYU1ySDNiDCWOQnFDbtDo8I_YJWXlOsSYh4kVXxVQK2mbQ2GsTM
Message-ID: <CA+fCnZeqtp2jqa7YTzDSbCkhso3dAaMGSEcmVtzU+Mrobark8w@mail.gmail.com>
Subject: Re: [PATCH 2/2] kasan: cleanup of kasan_enabled() checks
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: ryabinin.a.a@gmail.com, glider@google.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, akpm@linux-foundation.org, bhe@redhat.com, 
	christophe.leroy@csgroup.eu, ritesh.list@gmail.com, 
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B2BE0100003
X-Rspamd-Server: rspam03
X-Stat-Signature: p7oyywpredgac6p913fudx5g7xufgq5h
X-HE-Tag: 1761088085-569259
X-HE-Meta: U2FsdGVkX192NWhWM9dGUX8MhlC0WRrUSJ8JufDBaaGhowXLyhfJ1lwpfvXSRpST1jU74pW6D0rjnXA0abDubJFCjaI5cklU2LaFGEZ3pUUBQno6FFOij3Xd1dzBew+R207m/ImmR+JeJuB1saJcDRCmVaR6F0yFAnBQRqyQUbtiL/31gP+C47PMQwe7C0cAKja2Qr02u6Vh2BX8fTqhgyOxPbbaq5GMMMZmUovkOOXdYGIPBCrG3iixMUxaJ+TR8MuZ2h8bZ+UkwSHs6Qmt9Hj+XNKE8Vms0q69kLF0u/7DgwLmJU016Llhhj6gYgsiVJ/8K1LJzEyh4abUQ7RUJok5vFBajpsJUlaXbQPWIk7n473A0L+A7Dnc9fCviSM0BUfyAPtbZt4p2tjo2aABkPj92o7Vnpckp+k0O+IDgsbAwJ+81O6/F8of+X34PKLJC3XQ9ds0+y/Ck5l++TeVNVf3QTpFgSTlbynrsdXtouQ/wWsnK4ya3A8wT2jfDQf7qMHLsWEmGA92BIzBvFsSBkcGA76GkdAL/ndmFJk0i7oX2cilUrN6WaYIvSBD9hxBen4T+q4LoO43kvklvTJI7mRMF52emMr8Jyuxxu1x+5Xnv8XlDRVN2ZzDNvA47IfJ3ub4X0Ur7NDP650ZtIe2bOlOyxXESsydEBXkfcHYT0fjpFtEZJIiSnJ5c5le/JbKsjzkvm28Y8Q1fOkGSS1VMoqCR9VzMfkCvVpI4B9rTFT3XAVeTZY6Mnpn4sR8cRLWDI6tT8/848p6Ux9W7Nt76W2XGwHyd0F3kLDVqpBIYFERfMuVPg5eT6HGC4loM1Uv1EiYC40xzFDlW26NpL35KiKqghLbA7mKIMYmbMhhmaZHTCrFWzTfocgInXNVySUhIoVlGx1FAE1dzPNGv+OuDzV1nO2vEOLbebuOxyUmcMbqsl+qV7kRlwLFzfYirznuGdt2BmABxzcwdbCcpjF
 PB4V4b0T
 tnxBsm5/Lgs9loZTfEzRg/Mtse7V5RR3bdux2m8vH4GRsy7qnwYoxX7i7xDw9PqoKhsfrpWyvwLpgEWcHiOcQ+7bkVdODKZXC7fK+ZEDOiEqkZKbZnRNbfPdUPdeaHr9jOFgfLIvm3NJffiW0w7BydyJpS21RjiGX7YncpF0iFHL3JbQfNrred1/FCtgFWvMFimK3EFPveW/4nkJexeaujd7yW4mb/wZAnd0Dg7j+ved5JZ3PyUS5SMhNALx+FBwY6KdcLDtOn7X0WjRtQIVkaZSmoG53398IL+djwvu/cX8BnRXhBiBjg9pgNjjsEI0kX/cnxBDu0bLKHW9PIKwPUaxCnIKlOnhRf/6gsd29KQTRxIuvG/7qZJz7OmgYYkMAjjepQzIJdz4WML5wJXxRB4hfn2lAI1fsnYQhdwP9GFhhtFkqQPBE42bmwLAiBWRAdjPR4zvWHw1B3Vw=
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
> Deduplication of kasan_enabled() checks which are already used by callers=
.
>
> * Altered functions:
>
> check_page_allocation
>         Delete the check because callers have it already in __wrappers in
>         include/linux/kasan.h:
>                 __kasan_kfree_large
>                 __kasan_mempool_poison_pages
>                 __kasan_mempool_poison_object
>
> kasan_populate_vmalloc, kasan_release_vmalloc
>         Add __wrappers in include/linux/kasan.h.
>         They are called externally in mm/vmalloc.c.
>
> __kasan_unpoison_vmalloc, __kasan_poison_vmalloc
>         Delete checks because there're already kasan_enabled() checks
>         in respective __wrappers in include/linux/kasan.h.
>
> release_free_meta -- Delete the check because the higher caller path
>         has it already. See the stack trace:
>
>         __kasan_slab_free -- has the check already
>         __kasan_mempool_poison_object -- has the check already
>                 poison_slab_object
>                         kasan_save_free_info
>                                 release_free_meta
>                                         kasan_enabled() -- Delete here
>
> Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> ---
>  include/linux/kasan.h | 20 ++++++++++++++++++--
>  mm/kasan/common.c     |  3 ---
>  mm/kasan/generic.c    |  3 ---
>  mm/kasan/shadow.c     | 20 ++++----------------
>  4 files changed, 22 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index d12e1a5f5a9..f335c1d7b61 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -571,11 +571,27 @@ static inline void kasan_init_hw_tags(void) { }
>  #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
>
>  void kasan_populate_early_vm_area_shadow(void *start, unsigned long size=
);
> -int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t=
 gfp_mask);
> -void kasan_release_vmalloc(unsigned long start, unsigned long end,
> +int __kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp=
_t gfp_mask);
> +static inline int kasan_populate_vmalloc(unsigned long addr,
> +                                        unsigned long size, gfp_t gfp_ma=
sk)
> +{
> +       if (kasan_enabled())
> +               return __kasan_populate_vmalloc(addr, size, gfp_mask);
> +       return 0;
> +}
> +void __kasan_release_vmalloc(unsigned long start, unsigned long end,
>                            unsigned long free_region_start,
>                            unsigned long free_region_end,
>                            unsigned long flags);
> +static inline void kasan_release_vmalloc(unsigned long start, unsigned l=
ong end,
> +                          unsigned long free_region_start,
> +                          unsigned long free_region_end,
> +                          unsigned long flags)
> +{
> +       if (kasan_enabled())
> +               return __kasan_release_vmalloc(start, end, free_region_st=
art,
> +                                        free_region_end, flags);
> +}
>
>  #else /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
>
> diff --git a/mm/kasan/common.c b/mm/kasan/common.c
> index d4c14359fea..22e5d67ff06 100644
> --- a/mm/kasan/common.c
> +++ b/mm/kasan/common.c
> @@ -305,9 +305,6 @@ bool __kasan_slab_free(struct kmem_cache *cache, void=
 *object, bool init,
>
>  static inline bool check_page_allocation(void *ptr, unsigned long ip)
>  {
> -       if (!kasan_enabled())
> -               return false;
> -
>         if (ptr !=3D page_address(virt_to_head_page(ptr))) {
>                 kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_F=
REE);
>                 return true;
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index 516b49accc4..2b8e73f5f6a 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -506,9 +506,6 @@ static void release_alloc_meta(struct kasan_alloc_met=
a *meta)
>
>  static void release_free_meta(const void *object, struct kasan_free_meta=
 *meta)
>  {
> -       if (!kasan_enabled())
> -               return;
> -
>         /* Check if free meta is valid. */
>         if (*(u8 *)kasan_mem_to_shadow(object) !=3D KASAN_SLAB_FREE_META)
>                 return;
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index 5d2a876035d..cf842b620a2 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -354,7 +354,7 @@ static int ___alloc_pages_bulk(struct page **pages, i=
nt nr_pages, gfp_t gfp_mask
>         return 0;
>  }
>
> -static int __kasan_populate_vmalloc(unsigned long start, unsigned long e=
nd, gfp_t gfp_mask)
> +static int __kasan_populate_vmalloc_do(unsigned long start, unsigned lon=
g end, gfp_t gfp_mask)
>  {
>         unsigned long nr_pages, nr_total =3D PFN_UP(end - start);
>         struct vmalloc_populate_data data;
> @@ -403,14 +403,11 @@ static int __kasan_populate_vmalloc(unsigned long s=
tart, unsigned long end, gfp_
>         return ret;
>  }
>
> -int kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp_t=
 gfp_mask)
> +int __kasan_populate_vmalloc(unsigned long addr, unsigned long size, gfp=
_t gfp_mask)
>  {
>         unsigned long shadow_start, shadow_end;
>         int ret;
>
> -       if (!kasan_enabled())
> -               return 0;
> -
>         if (!is_vmalloc_or_module_addr((void *)addr))
>                 return 0;
>
> @@ -432,7 +429,7 @@ int kasan_populate_vmalloc(unsigned long addr, unsign=
ed long size, gfp_t gfp_mas
>         shadow_start =3D PAGE_ALIGN_DOWN(shadow_start);
>         shadow_end =3D PAGE_ALIGN(shadow_end);
>
> -       ret =3D __kasan_populate_vmalloc(shadow_start, shadow_end, gfp_ma=
sk);
> +       ret =3D __kasan_populate_vmalloc_do(shadow_start, shadow_end, gfp=
_mask);
>         if (ret)
>                 return ret;
>
> @@ -574,7 +571,7 @@ static int kasan_depopulate_vmalloc_pte(pte_t *ptep, =
unsigned long addr,
>   * pages entirely covered by the free region, we will not run in to any
>   * trouble - any simultaneous allocations will be for disjoint regions.
>   */
> -void kasan_release_vmalloc(unsigned long start, unsigned long end,
> +void __kasan_release_vmalloc(unsigned long start, unsigned long end,
>                            unsigned long free_region_start,
>                            unsigned long free_region_end,
>                            unsigned long flags)
> @@ -583,9 +580,6 @@ void kasan_release_vmalloc(unsigned long start, unsig=
ned long end,
>         unsigned long region_start, region_end;
>         unsigned long size;
>
> -       if (!kasan_enabled())
> -               return;
> -
>         region_start =3D ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
>         region_end =3D ALIGN_DOWN(end, KASAN_MEMORY_PER_SHADOW_PAGE);
>
> @@ -634,9 +628,6 @@ void *__kasan_unpoison_vmalloc(const void *start, uns=
igned long size,
>          * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ig=
nored.
>          */
>
> -       if (!kasan_enabled())
> -               return (void *)start;
> -
>         if (!is_vmalloc_or_module_addr(start))
>                 return (void *)start;
>
> @@ -659,9 +650,6 @@ void *__kasan_unpoison_vmalloc(const void *start, uns=
igned long size,
>   */
>  void __kasan_poison_vmalloc(const void *start, unsigned long size)
>  {
> -       if (!kasan_enabled())
> -               return;
> -
>         if (!is_vmalloc_or_module_addr(start))
>                 return;
>
> --
> 2.34.1
>

Reviewed-by: Andrey Konovalov <andreyknvl@gmail.com>

Awesome, thank you!

I believe the check in kasan_byte_accessible() can be just removed as
well? If you do, please run the tests to be sure.

As for the other three (check_inline_region(), kasan_poison(), and
kasan_poison_last_granule()) - perhaps, we can leave them be.
Otherwise, we would need to duplicate the kasan_enabled() checks in a
lot of compiler-inserted functions.

