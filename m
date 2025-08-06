Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F523C87FCA
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 04:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48C76B007B; Wed,  6 Aug 2025 00:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9DD6B00AD; Wed,  6 Aug 2025 00:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E9386B00AE; Wed,  6 Aug 2025 00:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 903046B007B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:37:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09F98135922
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:37:59 +0000 (UTC)
X-FDA: 83745075078.13.114FF2C
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 11C32100006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:37:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y+tdVkHY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754455077; a=rsa-sha256;
	cv=none;
	b=zAIWzqmjsT3EbvaeNtWo/YpYwAGRqZuSCumwwr0vT6Z6z/TD85ge8vW/5Uz4XG8uiMNb9+
	OiIb81oxiB2WoYEQy7zP1Huc10bYMIUoO7nScfpmBHqVM3IMo5oazzVJUPfCMKnIkIFgVM
	c+bFSOQcmyi1hS5jpzcgpaYYN2x4sls=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y+tdVkHY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754455077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qo/Viw2qcvpv/MoBS3iI99BxX9ghV/qd2Tz3ezwRf/E=;
	b=AsbjQO9iN7foIjTgA9zy2M11nwBuyPgnLlom7etn6PEEyBULqhf+4TS8DSYdvO6LKLRQEh
	wPVyhg7c1WvJF+3b6FEXysL3foFFMYkn6AsdYO7Xemadxgtiiy41MiMB2F05LV5BGxljZO
	ZzYRqjgI95EnswDwTZiPo/PB8spS1nI=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-332612dc0d1so26097831fa.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 21:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754455075; x=1755059875; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qo/Viw2qcvpv/MoBS3iI99BxX9ghV/qd2Tz3ezwRf/E=;
        b=Y+tdVkHYWkrikwY4jghKnqutizwj0dx3BGrylTF3YJISyESn3ayOaYXJkFatogG7NH
         WBTJk/STOBJzuxEz+1h7ZSz2c2gU2SgwCD5A4SzfR4OdMaagJXrZ2cF+rKu9MBlx2HSZ
         v6Lbw3NdWsrDH7QLGBChgcSp8yI4jdfHkftHIRHg08c2Spf4KSZ8NU4RffuxWQlaasnL
         DGns8IaEdM6geArPYxhoMVwFUMmCKO8X65b6OewREVG3hr+d1Di4XgaF/Yf4C1PNTdGH
         EANtypGHSiYGPzsGahhD51xQDr32H4NQsk3SWSUDGvlBS7NnLmlU0jmoyTXdssme3cUF
         naZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754455075; x=1755059875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qo/Viw2qcvpv/MoBS3iI99BxX9ghV/qd2Tz3ezwRf/E=;
        b=e5VWrtUxC1/SwC8n3oKpYMUAp1sFbNtE4VZN1Uu3G7FuzkilVJ0k+0NNmtARnl5kAG
         d+VabO5FUDs6i5YVcz9QfcEG4dGWTv3XrO9jgEZGY7YBWDosWctQgHpDqPjA3DkQt5TX
         GhwAK1oiQ3ONabhHJzm7yV3aBEou7ZFs7fxqiLFSXVM2kleaBkjTJnxtKRel1JLTHWSU
         6cViuNnBC6zOTi0Vf8v8IotazmeGkTt1pwHkiPhS8DpceHccgHFz92Syi5+IsfPrOlpN
         dJ3tqkDeCM4Xa7oyeI2DRjWeIsNn+/6Sj7WRHv4kTB0YXal+o9hJZzn7zIX02D5019FR
         ctgA==
X-Forwarded-Encrypted: i=1; AJvYcCUdhmD4AucB5XvxWjeAYnE+ZZ5Qwpq5B9ZU2PTzNa5HkeuWdEevMwYw2Xh0gRrMEaLSE7yEWPwRfA==@kvack.org
X-Gm-Message-State: AOJu0YzLbJ1B5rfuM9ryg/UP/bprwmmqLjXjG5EMPoCpnw+Bs2fkRqV5
	qklSu0ZM2q4bxijBj7F0tgoudSoNc4IMkJrodpeuTbwMyVX/2Tc4dTkNvkd9OxL4+yrl0k26D6K
	GmFRND44jrz/WeU0lRBVNo9NmFjqJZJ4=
X-Gm-Gg: ASbGncumN77qexV4TvsY9Lr389mC/Eg2k6bo8f5BCAygR7fuDmX2sNn21AbXeYawL0z
	NKTTGBCtX6GJRHE2r+dFNZJ9KzIq9TfYnLaIUG0RWs/AM1+7ZWBrVvLbWEDoxOFcasRgBTSfIS9
	2y5i3VEOsozB/ctwxmjJEEjL1weux3XXNbRfpjYOLA/0RPgo+mDwXbgPOdyMkz1fpaqG0OZg3Mi
	lABHho=
X-Google-Smtp-Source: AGHT+IFdsEW+IENwPRijll82h/DPiknLKACQZ/o9KWIJ/PhoBk1+OGng4Q7CbEgSQ8dHEzo+wdS/ckXYJp2kTJF5j88=
X-Received: by 2002:a05:651c:1509:b0:32a:739d:fac with SMTP id
 38308e7fff4ca-3338144cd8fmr3796161fa.36.1754455075078; Tue, 05 Aug 2025
 21:37:55 -0700 (PDT)
MIME-Version: 1.0
References: <20250805142622.560992-1-snovitoll@gmail.com> <20250805142622.560992-6-snovitoll@gmail.com>
 <e15e1012-566f-45a7-81d5-fd504af780da@gmail.com>
In-Reply-To: <e15e1012-566f-45a7-81d5-fd504af780da@gmail.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Wed, 6 Aug 2025 09:37:38 +0500
X-Gm-Features: Ac12FXyJN7pElMlaw_o-aZoTkQ3byDjTMvUiVf1-1J0u8uF_nrAwTbgiBAXxjhE
Message-ID: <CACzwLxj0nOQT0+Z+AFDG3Cvun5jGaET6C3mp9PnLbCHjdw51Pg@mail.gmail.com>
Subject: Re: [PATCH v4 5/9] kasan/loongarch: select ARCH_DEFER_KASAN and call kasan_init_generic
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com, 
	agordeev@linux.ibm.com, akpm@linux-foundation.org, zhangqing@loongson.cn, 
	chenhuacai@loongson.cn, trishalfonso@google.com, davidgow@google.com, 
	glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6yty5ndeh48pt5wop7awwitprs6hik84
X-Rspam-User: 
X-Rspamd-Queue-Id: 11C32100006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754455076-335611
X-HE-Meta: U2FsdGVkX19srhCYqVt51MeFNzYI3mW05LFoIRGHQBbOMMTWycGM0DCeQdE5M1m7ox/js80T9hFN7A+lARdATYxIRzyq8fIYiEnrtB3P1ycPI/xA8/uiBtZdGDdSHd0G1rPhapfIuda+4K3IM3zbS7wOv8dVkMwTPjDsoecNFz80Op6+gwGO36JyKtZ0M7nXCx8mTFF+hZzTbkeiHu2dPw7Zn0Gpgns8yma0uJO2DyzIpMPLew29cIjcu+XSKmXow4D+SRmsTtP5ZGatv08hfwBGNvOiX88J3w6gaLpjnLOwMF5bTKxv4OXetJ/mIBxXxOedxcg9ha7T+AOfluDB0SIMFdc43H2/AEEwVvrNnYyTxEviHL7cmgtGuq0az87CdUrBxRThycq2BlNjf9b8LKCZQ9xc0cgezz6jEIFq7zgs9AvwUTTY/TRfsFX4Wt6KP9NMkj8rz44ufWpRR3MrUysguOnMBsLp9HkfvqWtN78GQ/Kakc3vWPxKbeJDdPr/Qu/Ayg5OtZvu2eH6gne81qe0hFthJKrCgpZW4xhZ//VWo5Q9SZTmuZLoW/NuC0aNuXnXWiYDxSjGD9pCZPByFz/2bu6mVY+8xYf4sFAFKWeTvefzrr3Ve6K3Wcm5tzoQnkrWcBTru4lkYZQq+gfgKVOWb/UB3iexz/TqqrtR/Ka8RnLo+jzZhs3JiO3wWtlB6shHQeI7e65vwtXAZjQLfOsb58mlhWOJCa0hxLA6nXLNABo17r86LH6AbvdNCdT0gPEIzjXSNksPepYxyQQBx7CPCoA1Cf+/o/eb4pKURL0MpmyrXmZru1YZqH0xUPrVM6bbBf8/Ews6bnqKFrevObBbCLwpv/0eRcyRQxKwL1clyiumJqoE2ltUj1aDjSY7feLj4RgRAZma/9hStkscE3lZ6Ch3AWrsAOh1/Y40nEw3OuS5jHM7XRQeUT0s8M3g02awUe2K7ozTFDeuAL+
 plb/XmPU
 68LX0k1BKracc+w+Qx500PJaUP4wgLDu2vjlvDya8Go/4VWzmEf3LaX/24HaJAtdnOtdomosRVLvwLpCsU+tkK6O/6A4AEXYn+DvVHXqmg3ZFmAtfGt2ziaRzmRck3CkRdhxcGeLOSyQJzUJW1I1Zw/RRNd4DcKo6CyjmIQsKQT8034tmGYzxYJULD2m180Es5siDe/xEddJrPa4WB7PZanCX6ze3R/hoQFheXPClFgIg7pM4fYjvn32A6rZo3AWN46BNXAKGU6kOFkA3Ns+GKPrzFfo7IMnyvCzOJOQSE1cPrA1E52ajeMWFkdkLNqq3B1Xcrt+lykisFE53D20EoPqqWaJrYhRb52z1TPtj2aRNiWYlx967w3e7f/oKejQWKv95EhMnH/WA1qmRlgFNasqoiatFneFXtURwa4NxePPGRL1v/VhvZcTlQS9qBWXU4GHWcJVoXfGLIpVTZPjEqnKSEz3hN56GC9LGU2LnwN2sbn8fg81tfp1ONyuzhsBD3J4kXiRT+QbEIbGNapRuUez2Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 10:18=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
>
>
> On 8/5/25 4:26 PM, Sabyrzhan Tasbolatov wrote:
> > LoongArch needs deferred KASAN initialization as it has a custom
> > kasan_arch_is_ready() implementation that tracks shadow memory
> > readiness via the kasan_early_stage flag.
> >
> > Select ARCH_DEFER_KASAN to enable the unified static key mechanism
> > for runtime KASAN control. Call kasan_init_generic() which handles
> > Generic KASAN initialization and enables the static key.
> >
> > Replace kasan_arch_is_ready() with kasan_enabled() and delete the
> > flag kasan_early_stage in favor of the unified kasan_enabled()
> > interface.
> >
> > Note that init_task.kasan_depth =3D 0 is called after kasan_init_generi=
c(),
> > which is different than in other arch kasan_init(). This is left
> > unchanged as it cannot be tested.
> >
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217049
> > Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> > ---
> > Changes in v4:
> > - Replaced !kasan_enabled() with !kasan_shadow_initialized() in
> >   loongarch which selects ARCH_DEFER_KASAN (Andrey Ryabinin)
> > ---
> >  arch/loongarch/Kconfig             | 1 +
> >  arch/loongarch/include/asm/kasan.h | 7 -------
> >  arch/loongarch/mm/kasan_init.c     | 8 ++------
> >  3 files changed, 3 insertions(+), 13 deletions(-)
> >
> > diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > index f0abc38c40a..f6304c073ec 100644
> > --- a/arch/loongarch/Kconfig
> > +++ b/arch/loongarch/Kconfig
> > @@ -9,6 +9,7 @@ config LOONGARCH
> >       select ACPI_PPTT if ACPI
> >       select ACPI_SYSTEM_POWER_STATES_SUPPORT if ACPI
> >       select ARCH_BINFMT_ELF_STATE
> > +     select ARCH_DEFER_KASAN
> >       select ARCH_DISABLE_KASAN_INLINE
> >       select ARCH_ENABLE_MEMORY_HOTPLUG
> >       select ARCH_ENABLE_MEMORY_HOTREMOVE
> > diff --git a/arch/loongarch/include/asm/kasan.h b/arch/loongarch/includ=
e/asm/kasan.h
> > index 62f139a9c87..0e50e5b5e05 100644
> > --- a/arch/loongarch/include/asm/kasan.h
> > +++ b/arch/loongarch/include/asm/kasan.h
> > @@ -66,7 +66,6 @@
> >  #define XKPRANGE_WC_SHADOW_OFFSET    (KASAN_SHADOW_START + XKPRANGE_WC=
_KASAN_OFFSET)
> >  #define XKVRANGE_VC_SHADOW_OFFSET    (KASAN_SHADOW_START + XKVRANGE_VC=
_KASAN_OFFSET)
> >
> > -extern bool kasan_early_stage;
> >  extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
> >
> >  #define kasan_mem_to_shadow kasan_mem_to_shadow
> > @@ -75,12 +74,6 @@ void *kasan_mem_to_shadow(const void *addr);
> >  #define kasan_shadow_to_mem kasan_shadow_to_mem
> >  const void *kasan_shadow_to_mem(const void *shadow_addr);
> >
> > -#define kasan_arch_is_ready kasan_arch_is_ready
> > -static __always_inline bool kasan_arch_is_ready(void)
> > -{
> > -     return !kasan_early_stage;
> > -}
> > -
> >  #define addr_has_metadata addr_has_metadata
> >  static __always_inline bool addr_has_metadata(const void *addr)
> >  {
> > diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_i=
nit.c
> > index d2681272d8f..57fb6e98376 100644
> > --- a/arch/loongarch/mm/kasan_init.c
> > +++ b/arch/loongarch/mm/kasan_init.c
> > @@ -40,11 +40,9 @@ static pgd_t kasan_pg_dir[PTRS_PER_PGD] __initdata _=
_aligned(PAGE_SIZE);
> >  #define __pte_none(early, pte) (early ? pte_none(pte) : \
> >  ((pte_val(pte) & _PFN_MASK) =3D=3D (unsigned long)__pa(kasan_early_sha=
dow_page)))
> >
> > -bool kasan_early_stage =3D true;
> > -
> >  void *kasan_mem_to_shadow(const void *addr)
> >  {
> > -     if (!kasan_arch_is_ready()) {
> > +     if (!kasan_shadow_initialized()) {
> >               return (void *)(kasan_early_shadow_page);
> >       } else {
> >               unsigned long maddr =3D (unsigned long)addr;
> > @@ -298,8 +296,6 @@ void __init kasan_init(void)
> >       kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_S=
TART),
> >                                       kasan_mem_to_shadow((void *)KFENC=
E_AREA_END));
> >
> > -     kasan_early_stage =3D false;
> > -
>
> There is a reason for this line to be here.
> Your patch will change the result of the follow up kasan_mem_to_shadow() =
call and
> feed the wrong address to kasan_map_populate()

Thanks, I've missed it. Here the upcoming v5 for this:

diff --git a/arch/loongarch/mm/kasan_init.c b/arch/loongarch/mm/kasan_init.=
c
index d2681272d8f..0e6622b57ce 100644
--- a/arch/loongarch/mm/kasan_init.c
+++ b/arch/loongarch/mm/kasan_init.c
@@ -40,11 +40,9 @@ static pgd_t kasan_pg_dir[PTRS_PER_PGD] __initdata
__aligned(PAGE_SIZE);
#define __pte_none(early, pte) (early ? pte_none(pte) : \
((pte_val(pte) & _PFN_MASK) =3D=3D (unsigned long)__pa(kasan_early_shadow_p=
age)))
-bool kasan_early_stage =3D true;
-
void *kasan_mem_to_shadow(const void *addr)
{
- if (!kasan_arch_is_ready()) {
+ if (!kasan_shadow_initialized()) {
return (void *)(kasan_early_shadow_page);
} else {
unsigned long maddr =3D (unsigned long)addr;
@@ -298,7 +296,10 @@ void __init kasan_init(void)
kasan_populate_early_shadow(kasan_mem_to_shadow((void *)VMALLOC_START),
kasan_mem_to_shadow((void *)KFENCE_AREA_END));
- kasan_early_stage =3D false;
+ /* Enable KASAN here before kasan_mem_to_shadow() which checks
+ * if kasan_shadow_initialized().
+ */
+ kasan_init_generic();
/* Populate the linear mapping */
for_each_mem_range(i, &pa_start, &pa_end) {
@@ -329,5 +330,4 @@ void __init kasan_init(void)
/* At this point kasan is fully initialized. Enable error messages */
init_task.kasan_depth =3D 0;
- pr_info("KernelAddressSanitizer initialized.\n");
}
--=20
2.34.1

>
>
> >       /* Populate the linear mapping */
> >       for_each_mem_range(i, &pa_start, &pa_end) {
> >               void *start =3D (void *)phys_to_virt(pa_start);
> > @@ -329,5 +325,5 @@ void __init kasan_init(void)
> >
> >       /* At this point kasan is fully initialized. Enable error message=
s */
> >       init_task.kasan_depth =3D 0;
> > -     pr_info("KernelAddressSanitizer initialized.\n");
> > +     kasan_init_generic();
> >  }
>

