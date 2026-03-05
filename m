Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87B8FF47CCC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 20:19:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE00C6B0089; Thu,  5 Mar 2026 15:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8A456B008A; Thu,  5 Mar 2026 15:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CA06B008C; Thu,  5 Mar 2026 15:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C77E66B0089
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:19:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6990D57DE2
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:19:00 +0000 (UTC)
X-FDA: 84513123240.26.71A942F
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3955E140012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 20:18:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=dNz8L5X6;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772741938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjzFn4m2KpajID2eW6dWgmxkcxpNABzXQGduS9dF8ns=;
	b=O9NkWmIkcgEUoQvbSVpwTM7bDuUcH6bK8Sgs5rs2mlXQFL2o1hxwm+uNklNsPcPy2+57mF
	FBImpZfhLBf4X83EN5rZnyl5pNp8AO6jJmGSgEFT9oJ58D/6v53mhBWQlPRUJpZXVFshgi
	VPy/v5E5VnfrOmVTu/NN+NV4PdvK0xw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=dNz8L5X6;
	spf=pass (imf09.hostedemail.com: domain of m.wieczorretman@pm.me designates 185.70.43.22 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772741938; a=rsa-sha256;
	cv=none;
	b=lli9248G3U0JdYbtasQt162UDSCqty7ehn2dVwGi8SyNx6dAS0IYAW+aACAz60SjXwoSiI
	gvvNBD5o+ta7ZoOYnpIco6xEtqzb+62D/wICVdWlgNW7OQeGAUGqOtJch0mP+NDvhtA/KV
	81IsHpYi4rrAyWdjU8+PpMSZZsyk2N4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1772741935; x=1773001135;
	bh=cjzFn4m2KpajID2eW6dWgmxkcxpNABzXQGduS9dF8ns=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=dNz8L5X63nDoQARcDMQxpm32vzIVI1W+y1jCcus19DIdSagIgv54Z7QznvUpUW+yf
	 Ciu2kOkw8iuNDo96EOYRcaD4l4WA34pkf+9a+qhClIk6Q0MRDajnOcXgwrxA+sHYy6
	 A0390rDNYyQDd1ZlTQ+4KUwH0Yt+Plc+nPjyssLGMI3D4lM+7Cqo0cy1L9qLp8ASd/
	 uYPsnoiKCnWWH+YitCnxAFJcUF7oUg3AYn5s4Zzsprbjt9cPa7hBqkJy4scquF8Fbu
	 n2sZk2mskLaGN7p2BUJWMj1gbJJuRbe8DHh9IAbzo8TDHdnDReoAyqPIx3BkuO9M+6
	 /fNj+9wDGGWhg==
Date: Thu, 05 Mar 2026 20:18:49 +0000
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, Samuel Holland <samuel.holland@sifive.com>, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, workflows@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v10 01/13] kasan: sw_tags: Use arithmetic shift for shadow computation
Message-ID: <aanievpHCv0Sz3Bf@wieczorr-mobl1.localdomain>
In-Reply-To: <CAPAsAGxpHBqzppoKCrqvH0mfhEn6p0aEHR30ZifB3uv81v68EA@mail.gmail.com>
References: <cover.1770232424.git.m.wieczorretman@pm.me> <bd935d83b2fe3ddfedff052323a2b84e85061042.1770232424.git.m.wieczorretman@pm.me> <CAPAsAGxpHBqzppoKCrqvH0mfhEn6p0aEHR30ZifB3uv81v68EA@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 5b2989690457c011b9b0d41c90461138ce83d507
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3955E140012
X-Stat-Signature: 46gwo3bhirg6j1yspskzpw1xjrbm89f8
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772741937-77489
X-HE-Meta: U2FsdGVkX19ekaHpBFT+teJHsAfrpHSYuAJN4t14BsuSuDI3loUGvt9KrA+ulw/Uy/7p4yAykCha9a/zSuLnxa5AxzkQ4yxWou74vaO+5bSd8yORa51T50yA3lp/3zg2TY/Nrjop6EWdFshfAkT5TlveBFGkxsPcshqDdg5vvkL/yhOc3xVBFM5x8VkZYIIXEOTrs2rbaUXQV/IVHBcLIT9A4tABvjR+bPMdP8c5mVR1BEthr/PkG51fA/EMVU2IsJhv1dvJXIXgBJ+VskdHpNnlYLN3JjWjZh7jQ1i7wX2lnxeB7PdfLsUCwXx5rzuKRHY1M28bSR9zB90ZU+q2gkI4PZ/6P8fGSTs1LFtPRzbOanwFjNVAQat4RUrpL3qvY5Z5hQ/6pL/SSHCMYONx2lha+y9fGCwhpATWkNIiEzlhl8TcLHmyOs88leiraO3jt9YNpsS1k+dFJPP0RYHiIm+H5pwpnueQbwlCLIrH0TakSY7k2RmNMvrwghk9A0yGjWsLyOTUhGpk4yQYzHcngR1YywXGFwcs6zsqIkt024dgPN63buobBnIqEYpdRfRLzqPovIHZg6K5y9L9pVR0D6kMddLiUui6vitIG7GBmLrZtVPig9b1pPHqBHYvKU3WG4MrrpzR+j98844bTRIsrINnIuwiLjsxBYx9L1i4tgUmrzZxJL6s3p1rSWub3aaJzX/yVH91y3WgkZ4laxYpHZt5EBHwW4Wo9KwrJy1J0xPfXLgIi+AIRv2dj6+bSvrzHtlP6GrgecyaATC6ycQk8A9APQAOZoAV5rQ8z85nIgB1r75xL6NS6wXcpptDNVYCgJUU+pFQuY3p96T6JzmqkTnDqFbtYHrRcWfAAtuKMEkvkaIrdZPugyUDwgGE7tG4WiRgHPwhZQDZyGhAnpGSGatiWQkKBPI9J8PRbKyGIoR7xthvqGtY2K3EIG+h3zmv13kVJ9tYg/45luU0Xuv
 ZIX2AJds
 UVC9Se1mB6hKXDYXMwjhyWAqPvPWa7u052MgxSsDSR49ncrBIHd8gpHifvqeVQ9BYr05e9hId9GRppcOfFdEPZIubV1i/zBxH/uoTFWDDG5EJAaTW54hVYG4jsW4zmCKNAeNuWY71JAzcxh9je+joN/i7d9G+StGyyyPqQz39fOtJ4BOMF/2K1y61bRodkOxKTREEbxxlXLWMidBxuWtVt5xRAV+XhMYivwR47nBKsztBbNRQMZj2zLwEJATxqornPsgO81yJUe6tDa1iCQbOB7EUf36w8qlGUK82DPP3lG9OQp+1047qbNAwFPm7QB6mArSXRusR9j1H/528yPK/3e0+wQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks, that looks really neat! I should've thought of that instead of maki=
ng
separate arch versions :)

Do you want me to attach the code you posted here to this patchset or do yo=
u
intend to post it yourself? I'm working out Dave's comments on the x86 part=
s and
I wanted to post v11 sometime next week.

Kind regards
Maciej Wiecz=C3=B3r-Retman

On 2026-03-05 at 13:05:48 -0600, Andrey Ryabinin wrote:
>Maciej Wieczor-Retman <m.wieczorretman@pm.me> writes:
>
>> --- a/mm/kasan/kasan.h
>> +++ b/mm/kasan/kasan.h
>> @@ -558,6 +558,13 @@ static inline bool kasan_arch_is_ready(void)=09{ re=
turn true; }
>>  #error kasan_arch_is_ready only works in KASAN generic outline mode!
>>  #endif
>>
>> +#ifndef arch_kasan_non_canonical_hook
>> +static inline bool arch_kasan_non_canonical_hook(unsigned long addr)
>> +{
>> +=09return false;
>> +}
>> +#endif
>> +
>>  #if IS_ENABLED(CONFIG_KASAN_KUNIT_TEST)
>>
>>  void kasan_kunit_test_suite_start(void);
>> diff --git a/mm/kasan/report.c b/mm/kasan/report.c
>> index 62c01b4527eb..53152d148deb 100644
>> --- a/mm/kasan/report.c
>> +++ b/mm/kasan/report.c
>> @@ -642,10 +642,19 @@ void kasan_non_canonical_hook(unsigned long addr)
>>  =09const char *bug_type;
>>
>>  =09/*
>> -=09 * All addresses that came as a result of the memory-to-shadow mappi=
ng
>> -=09 * (even for bogus pointers) must be >=3D KASAN_SHADOW_OFFSET.
>> +=09 * For Generic KASAN, kasan_mem_to_shadow() uses the logical right s=
hift
>> +=09 * and never overflows with the chosen KASAN_SHADOW_OFFSET values. T=
hus,
>> +=09 * the possible shadow addresses (even for bogus pointers) belong to=
 a
>> +=09 * single contiguous region that is the result of kasan_mem_to_shado=
w()
>> +=09 * applied to the whole address space.
>>  =09 */
>> -=09if (addr < KASAN_SHADOW_OFFSET)
>> +=09if (IS_ENABLED(CONFIG_KASAN_GENERIC)) {
>> +=09=09if (addr < (unsigned long)kasan_mem_to_shadow((void *)(0ULL)) ||
>> +=09=09    addr > (unsigned long)kasan_mem_to_shadow((void *)(~0ULL)))
>> +=09=09=09return;
>> +=09}
>> +
>> +=09if (arch_kasan_non_canonical_hook(addr))
>>  =09=09return;
>>
>
>I've noticed that we currently classify bugs incorrectly in SW_TAGS
>mode. I've sent the fix for it [1] :
> [1] https://lkml.kernel.org/r/20260305185659.20807-1-ryabinin.a.a@gmail.c=
om
>
>While at it, I was thinking whether we can make the logic above more
>arch/mode agnotstic and without per-arch hooks, so I've ended up with
>the following patch (it is on top of [1] fix).
>I think it should work with any arch or mode and both with signed or
>unsigned shifting.
>
>diff --git a/mm/kasan/report.c b/mm/kasan/report.c
>index e804b1e1f886..1e4521b5ef14 100644
>--- a/mm/kasan/report.c
>+++ b/mm/kasan/report.c
>@@ -640,12 +640,20 @@ void kasan_non_canonical_hook(unsigned long addr)
> {
> =09unsigned long orig_addr, user_orig_addr;
> =09const char *bug_type;
>+=09void *tagged_null =3D set_tag(NULL, KASAN_TAG_KERNEL);
>+=09void *tagged_addr =3D set_tag((void *)addr, KASAN_TAG_KERNEL);
>
> =09/*
>-=09 * All addresses that came as a result of the memory-to-shadow mapping
>-=09 * (even for bogus pointers) must be >=3D KASAN_SHADOW_OFFSET.
>+=09 * Filter out addresses that cannot be shadow memory accesses generate=
d
>+=09 * by the compiler.
>+=09 *
>+=09 * In SW_TAGS mode, when computing a shadow address, the compiler alwa=
ys
>+=09 * sets the kernel tag (some top bits) on the pointer *before* computi=
ng
>+=09 * the memory-to-shadow mapping. As a result, valid shadow addresses
>+=09 * are derived from tagged kernel pointers.
> =09 */
>-=09if (addr < KASAN_SHADOW_OFFSET)
>+=09if (tagged_addr < kasan_mem_to_shadow(tagged_null) ||
>+=09    tagged_addr > kasan_mem_to_shadow((void *)(~0ULL)))
> =09=09return;
>
> =09orig_addr =3D (unsigned long)kasan_shadow_to_mem((void *)addr);
>@@ -670,7 +678,7 @@ void kasan_non_canonical_hook(unsigned long addr)
> =09} else if (user_orig_addr < TASK_SIZE) {
> =09=09bug_type =3D "probably user-memory-access";
> =09=09orig_addr =3D user_orig_addr;
>-=09} else if (addr_in_shadow((void *)addr))
>+=09} else if (addr_in_shadow(tagged_addr))
> =09=09bug_type =3D "probably wild-memory-access";
> =09else
> =09=09bug_type =3D "maybe wild-memory-access";
>--
>2.52.0


