Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8767EC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 14:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FC26B00AD; Tue, 22 Jul 2025 10:17:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0926B00AE; Tue, 22 Jul 2025 10:17:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BFAF6B00AF; Tue, 22 Jul 2025 10:17:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA3B86B00AD
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 10:17:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8AF751403CD
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:17:25 +0000 (UTC)
X-FDA: 83692103250.07.F220716
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A844120009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:17:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mdXHHlBA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753193843; a=rsa-sha256;
	cv=none;
	b=jbj2FHFS7EWWVJAJ1/MJfjs6yi4yN3QMO80RXc8rhOGphRLks0XUHv+pjoTIS2dA2guJS3
	Hyw/3ShGczSURczdmMFlOZXBChCDgoms1pMeCHJ91i6wkWvmVT9rKjTvDvImOYqzDhrHoG
	u3fdBZgAoTThMppMMm/0TmqSEb4rT+c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mdXHHlBA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of snovitoll@gmail.com designates 209.85.208.180 as permitted sender) smtp.mailfrom=snovitoll@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753193843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GboL0eWXtD3fDsEKzgJ1xepA1JQohVF9co6pstDgRM8=;
	b=RPBUH6tEYVZgkga9zPa3lslyXUOflcsMdlyP9rt5KCwJ85GFPm6VYwQDGg8GLBjrIGiyir
	mR48abLGud1J36H0qEIkSKVhZoUE2OmOpaEl2cMwabE+GMuF9Whv3q6nHZH/1EtkLa2XqB
	z/NvFsxCgd6SiBd7Bgc6mcnKP4gG4ZY=
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-32cd0dfbdb8so51051791fa.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753193842; x=1753798642; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GboL0eWXtD3fDsEKzgJ1xepA1JQohVF9co6pstDgRM8=;
        b=mdXHHlBA4A5WeDO3Su/RdsUquO6vXUTLGi3zn8cn1SN63gDzeEj95FiCdZynEa2Vx3
         Dk+c7w5oF3Ujo63ffZdv4fa8J8k5EeJ3ezPnCZ0qKjhK3U5c/sFC34S/08+uK+NUX4eh
         5gqJGXc4CKYjPSTeYU7+m0K/3eozZ6s9+63VPvfpw3AfB6q7jkfXZmfalJ9rXOVxzhh0
         GJ4WMZlKH1SRRLz3+Uu9GOkIGVJ84g9Pv4YHh7yDXT6fqT+XzTPh2yTyjbQaSIpraGrz
         oNZtr7RfhI9EyKSUibt+mUCOWYNEWERWUMBZsIl3lAgwYS5rJnPGCsBsOHJZ/hS1vw+9
         uIgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753193842; x=1753798642;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GboL0eWXtD3fDsEKzgJ1xepA1JQohVF9co6pstDgRM8=;
        b=mzzBlef6E46HurvSd/D9JHc+gCCXB+5d5xsU64lR5JdlmWm35wjXKIe4ft4y13coAr
         fDZp55fcG/l+02M8WZh6AnQed7KP3VEnTfQtOQg3Vt2Pr/chxy5rm96uCn8G9GtfSISz
         coQnsmkbNN8w3LIk/NAaowE3B0Fw7PdpQdpi6QTZau4bN/IG4u5IshqBvh0Fp4HwBTVb
         esObNfAhTL33KTCnA2Ve1XVpceLS85DkjLsAnfocUxEVcP7MLkYm7GhC+xzoesnker5s
         w9fAp181wdDXFxJrur5QjTrWGCEfQbUGF0VMXcmp70zBvBLY/WbPzGt5If7B/LT6djot
         zX5g==
X-Forwarded-Encrypted: i=1; AJvYcCVrDG3OXCg/73wfOuelf7dKG2bjUc7NFR8I5DoCDi1wSKliN7rOU4bOC4cyelLgfU7CYdHGPNI9nQ==@kvack.org
X-Gm-Message-State: AOJu0YwlRw7bDKTG1sje2PupYtJTMyL6t+Vw1zqly+PkBFp+IoSN22/U
	ImTjHpNZOy6wQ4NFLz/ecJTBsHNj3tBgCHMCKpbi1/jTrgYdSVowR8HmcXe2hCcSNUFtJMpzIq5
	2ZQFdIDiLkIHLH4/NOsnjxcoJupw4+GI=
X-Gm-Gg: ASbGncuFP9W7gUu+Af57C7R4lREVsKjYDC+qHjpszJV94Pm4Q3KY6L/8hZIOxFKEhq6
	DjM8hb6guy5PllPzpOAXtBb8lORNJ+QVNHaLR7vb8b/GeCHX5PiyLz9XIJghDCq+bHfzaUoZG0d
	cxuVJc3hGGCqDajG4UfXuU/8oK9wZuG0m5jqq8uRqQup+6qORX5ycv/5kaUs4DkMmBzTNPJekpE
	k/gerM=
X-Google-Smtp-Source: AGHT+IHWyFSdlAJ08NCU6ABmF9BGYFP4zXRYUy0aJCm6G+P21nbWRd00HVhqfmwkvmBdoun3tyqTRuImHuMXXJuHVwM=
X-Received: by 2002:a05:651c:110d:b0:32b:75f0:cfa4 with SMTP id
 38308e7fff4ca-3308f5c95f9mr70998461fa.25.1753193841372; Tue, 22 Jul 2025
 07:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250717142732.292822-1-snovitoll@gmail.com> <20250717142732.292822-9-snovitoll@gmail.com>
 <85de2e1f-a787-4862-87e4-2681e749cef0@gmail.com>
In-Reply-To: <85de2e1f-a787-4862-87e4-2681e749cef0@gmail.com>
From: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Date: Tue, 22 Jul 2025 19:17:03 +0500
X-Gm-Features: Ac12FXzF_nEInn7KovIF1rCbPeOEkryRpoS2Hx7q1NkLYIXq7eXxsmx3CUCidIg
Message-ID: <CACzwLxiD98BLmEmPhkJQgv297bP_7qw+Vm_icFhTiDYN7WvLjw@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] kasan/um: select ARCH_DEFER_KASAN and call kasan_init_generic
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com, 
	agordeev@linux.ibm.com, akpm@linux-foundation.org, glider@google.com, 
	dvyukov@google.com, kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A844120009
X-Stat-Signature: gau6oiek3zx9ng3c716wmotf3dkgt9o7
X-Rspam-User: 
X-HE-Tag: 1753193843-684875
X-HE-Meta: U2FsdGVkX1+d8WXjgz3HD0eggq+o5ssFttT+ow/DV1OL9ZXObhLNLKvvcNGt+yWQsJCovVpbUtY6LvmgMzP/n1NwV4zrbqEbiI53I4I/gZG5F5I1C0FgyR+DSSehmdbNnO/Eju0PXfIxQkhxrSjp/xvzvwZ1JESfXYblKr99rdIR0V4OhoUPBhc6az9pcn5zk9k9HD6iWoYI7yc3SINY9qZ6AJLbSu/pwJpM1DPDnBrl2OrA7AvRxNNbhyORB0yVst2MhlFknp1AZxJLXjMvONQG0g5ipwCSPQsP/N8Fe57+2Cwqhh5/TCcZJFnuTXPT0lhzNi1FuFratyCafNGAi5JNiXnfuFsI57Zbnr1kj0Gi0M1mvsdg7/7EEmlDwTP7MlJG52vAsWQbKm8/+yoAubXtXG/egBsc3YfPBny3k7lJVvapXKI+jUcVjQYtL4E1BjzP7FcdHM46UbrWNf7YgMB2jQwTJ/l+c9I6yFHW8ri/Bs6YTvCrb0qX7DlJ2+R0x+PeEbBJcrKOf8iRAtc43lMHcjdVKVm+G7zsXuNn1iFlwIMpCBngYOq4nNThfKWjNA1KFlv/EcEBvkHK21cMCPfU3OzyMz/1Ug/QsEQKFYzQLCPGSAAFp3kYsAbvnW91gd781YcvpW8Wa8i7BOWl4/B+MUXVLeNbbFdfOLB74jZCxRYtdOKurCIeOTOvUCt+LhAOLDtFHYVkJdWLnQ9lc2eiLFy3UTkXjTGuuSy2uFqzVoxVjh4476I4pHl3L+xLl+C2Kf4NESMm++K6nyq5WhdN2r+DKrOPyiQh4VJoVpBgt8GcisoUxzZ/q7SZQquTVQ8DEGcLTwSUgml0aaKqASR8OTIqAZ3n7IXLEMqPBB0o3FWJsBX9dmhfWo65u56Au4+8WpZLyvLsZNzyXitZE+7lOIcliofAP1g+IVQiIfhcJ9L+iQZ5lwuKOQc0XWJBSvfjPEKWIoN8vaYpFk/
 i8bfBN9u
 FQrfchHA3H3Tw1/qRb3F6So6rwdUk7k1uJ7LmY6H247Cz5HiBPTQ2rm13OsnlQIo8IKAbYfTy9ApKQD5Sg98RqxYKxiP0GkKpOuDQ5GAJPtElU0Sv5ZCSuygqzsF1Y1tqy/GIqNxGobJlMrFYYQeQkVHLwZm9o3sug6bvCMvVHeC0WeM22UO4kdKmIA2KKUTUgXPCoI3rZ9vlxUb/3A1hGlkY21XrMLhWxLw+JRcbc02Pvw/arh8vP1MK+mXlkFyxXbhMpwQJRvDAWnMkKYh6r7yV3pfywd/d7HNQS4h6XR69OMtFCL5SSRYNUKgSvXpCKXqPG4FsQbCBvqxaUIjNcZ/R2wXzQuyF8NnGjnlKAhfvSEvEtOfrh59YEfdA2YVDT0spuPcUQcQmxRZB1qnxYlS+b3Gs4C6JqD+HTo94mN9IwrdK0jmtXif+1mKA+i6zcPMcmqh8NO8k+APty3CsgGuAM7aS9lb9O8RWS1SPHhboWBNU9e3kJAHQgMeoSqIdR5g0/JH4vJAEZyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 4:00=E2=80=AFAM Andrey Ryabinin <ryabinin.a.a@gmail=
.com> wrote:
>
>
>
> On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:
> > UserMode Linux needs deferred KASAN initialization as it has a custom
> > kasan_arch_is_ready() implementation that tracks shadow memory readines=
s
> > via the kasan_um_is_ready flag.
> >
> > Select ARCH_DEFER_KASAN to enable the unified static key mechanism
> > for runtime KASAN control. Call kasan_init_generic() which handles
> > Generic KASAN initialization and enables the static key.
> >
> > Delete the key kasan_um_is_ready in favor of the unified kasan_enabled(=
)
> > interface.
> >
> > Note that kasan_init_generic has __init macro, which is called by
> > kasan_init() which is not marked with __init in arch/um code.
> >
> > Closes: https://bugzilla.kernel.org/show_bug.cgi?id=3D217049
> > Signed-off-by: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
> > ---
> > Changes in v3:
> > - Added CONFIG_ARCH_DEFER_KASAN selection for proper runtime control
> > ---
> >  arch/um/Kconfig             | 1 +
> >  arch/um/include/asm/kasan.h | 5 -----
> >  arch/um/kernel/mem.c        | 4 ++--
> >  3 files changed, 3 insertions(+), 7 deletions(-)
> >
> > diff --git a/arch/um/Kconfig b/arch/um/Kconfig
> > index f08e8a7fac9..fd6d78bba52 100644
> > --- a/arch/um/Kconfig
> > +++ b/arch/um/Kconfig
> > @@ -8,6 +8,7 @@ config UML
> >       select ARCH_WANTS_DYNAMIC_TASK_STRUCT
> >       select ARCH_HAS_CPU_FINALIZE_INIT
> >       select ARCH_HAS_FORTIFY_SOURCE
> > +     select ARCH_DEFER_KASAN
> >       select ARCH_HAS_GCOV_PROFILE_ALL
> >       select ARCH_HAS_KCOV
> >       select ARCH_HAS_STRNCPY_FROM_USER
> > diff --git a/arch/um/include/asm/kasan.h b/arch/um/include/asm/kasan.h
> > index f97bb1f7b85..81bcdc0f962 100644
> > --- a/arch/um/include/asm/kasan.h
> > +++ b/arch/um/include/asm/kasan.h
> > @@ -24,11 +24,6 @@
> >
> >  #ifdef CONFIG_KASAN
> >  void kasan_init(void);
> > -extern int kasan_um_is_ready;
> > -
> > -#ifdef CONFIG_STATIC_LINK
> > -#define kasan_arch_is_ready() (kasan_um_is_ready)
> > -#endif
> >  #else
> >  static inline void kasan_init(void) { }
> >  #endif /* CONFIG_KASAN */
> > diff --git a/arch/um/kernel/mem.c b/arch/um/kernel/mem.c
> > index 76bec7de81b..058cb70e330 100644
> > --- a/arch/um/kernel/mem.c
> > +++ b/arch/um/kernel/mem.c
> > @@ -21,9 +21,9 @@
> >  #include <os.h>
> >  #include <um_malloc.h>
> >  #include <linux/sched/task.h>
> > +#include <linux/kasan.h>
> >
> >  #ifdef CONFIG_KASAN
> > -int kasan_um_is_ready;
> >  void kasan_init(void)
> >  {
> >       /*
> > @@ -32,7 +32,7 @@ void kasan_init(void)
> >        */
> >       kasan_map_memory((void *)KASAN_SHADOW_START, KASAN_SHADOW_SIZE);
> >       init_task.kasan_depth =3D 0;
> > -     kasan_um_is_ready =3D true;
> > +     kasan_init_generic();
>
> I think this runs before jump_label_init(), and static keys shouldn't be =
switched before that.>  }

I got the warning in my local compilation and from kernel CI [1].

arch/um places kasan_init() in own `.kasan_init` section, while
kasan_init_generic() is called from __init.
Could you suggest a way how I can verify the functions call order?

I need to familiarize myself with how to run arch/um locally and try
to fix this warning.

[1] https://lore.kernel.org/all/CACzwLxicmky4CRdmABtN8m2cr2EpuMxLPqeF5Hk375=
cN2Kvu-Q@mail.gmail.com/

> >
> >  static void (*kasan_init_ptr)(void)
>

