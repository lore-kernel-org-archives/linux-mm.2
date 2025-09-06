Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7519CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 17:19:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D1748E0007; Sat,  6 Sep 2025 13:19:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3823D8E0002; Sat,  6 Sep 2025 13:19:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A068E0007; Sat,  6 Sep 2025 13:19:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0912F8E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:19:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC1BE160533
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:15 +0000 (UTC)
X-FDA: 83859486270.17.F2FD7D5
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7EF2A000F
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 17:19:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VbWpJtwI;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757179154; a=rsa-sha256;
	cv=none;
	b=uEDoiBIvQJ7NEFaIKivrtB2eedPAi3e4fzKFEwHwKIYRKV74+QjygESUMBBjMVF2TGUXYt
	v/mIaBvomh5BBc5rhVdJeWu+xSbKx3Q21Tl6ABt/SDAB9tXTRt/4eROysdeq4K31feKqEH
	AjI0OquXpmSuLhrXYG6Sajv7UqKbKU4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VbWpJtwI;
	spf=pass (imf25.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757179154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcGjqzlEvwGIwrVgChgsqOwM/ch5h0ABA8uHnxnyHmk=;
	b=b2FUxA1mVrtFqwpARaZ9ZNfooxbRzzUReA8h7Ml+0tSKqSocukfJIKDtnYi7qix4ILQLjx
	n/LhidUWyNzArR15U7PQTILR3hyR66rpniNZJehk3XydDSuF5e3KQA0cxK6pqIng6t5BY9
	nfTRMUWzL2wf2DS1GcHp4cxbgTGbIyE=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3dea538b826so2524994f8f.2
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 10:19:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757179152; x=1757783952; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JcGjqzlEvwGIwrVgChgsqOwM/ch5h0ABA8uHnxnyHmk=;
        b=VbWpJtwIZp+6IIEEW7zsYXbdvsm2J2AsD74k6eJ5OAwNCW8VZUZj1e/ZNuKKhcxXK9
         UgapurQMzkuOpaAJPlUOPmGjy07jcpDlAA5iNrgd2CfmhBLGGjcd4hNFSEFxDJrqcE+1
         hgBSb/cm4Dd5pTYfjL5AiV98N+4yJQG2wxHkWidvmJRyRGivokCq0WDQ5IWkANuLXaGe
         1hGGkhhJP7WJra/pR0BBmIT3WTAlBECoQyKwN/i0KBap1tDHGcHrbXx+i6HJhlPIX78J
         R+glA2g4KAvYqAotno9+VVFM93nFWwU/Nl8siEROXhCUGBf67NSz2I4x+MM8F/224V/B
         1Mow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757179152; x=1757783952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JcGjqzlEvwGIwrVgChgsqOwM/ch5h0ABA8uHnxnyHmk=;
        b=oUiNLhe9zZ4dmnOQKWR/wopWxncEY0ykMU712ihJv2cVlAFlfOEubcoJiajXAFlgRr
         LXrGw//wselJPYpccLykWKvAXDyl1e5VtSi7LT6Z6cHs91PWUihLFh6OOv/p1piHyjVD
         8HLAlcWgAl7sWv3bH0aTevgGxfox5/KYfjvhafIGKtNto0AHsVWb/f7jVSTFdqU015ba
         v3FvAJB/T7raOHLDsfCZ0ioSHr11wS67bcGNUmpjNf2v9QiJ8/Y99hFJZOWR++M5K1S7
         4Vxx3QjJKWAvkOqP9uj38comhwQUEJ2QBLs9p0Ly/MzszSIGuXGFVb7rDvqnk6j0fr+J
         /dEA==
X-Forwarded-Encrypted: i=1; AJvYcCW8QApmyKVTht0+ngzR4G2c5DHEpjlevdM2+2aYnXY6QZd3zi19HQfGuiCRdOpB6dK3I/L1jZIZEA==@kvack.org
X-Gm-Message-State: AOJu0Yy/Wf+EcJr2G4743qCXohpLMUcgvquZ6+4DNbvDWr+p2YH2mVYt
	PKucH5XJqRcLl+mMQ+iwVdAByA0+lJhjHP1AtJ6uT4OsolGXSi0sk7AWhuntLa8GUkM1cFy16Ep
	9s48tG1pdTlic0zXDqvBX2T+yQq2I6Kk=
X-Gm-Gg: ASbGnctCVCY+6o4rI4Tzqy/SCyDf5Zlk+3nYZ8agNWMIYP1o1RWdlPOOLh0N5Riy3rx
	2ljOgMK+RB0DZ+J/Bx+7cDExsTo/+wI5g+X3biapnPGfkFBTP3jcmqJxHbcJMJUCI7fneqSFHPX
	GerRnxxMmhFKXYz23R3zJqDzROMhcUwgHoYjMBIlh40zYDZBdQIo6MVEisN2qAFktSWBUPYFAvD
	HNKmHWj
X-Google-Smtp-Source: AGHT+IGoAJcJskVN5y7+9iEe/gHmEkEKOcbve64MMpOwOmuYU3dyMfGKr4WBo2d9j76/N40VbFSKqdY5ksrhgdwi1Ps=
X-Received: by 2002:a05:6000:420f:b0:3e3:5b4:dc1b with SMTP id
 ffacd0b85a97d-3e642027172mr2499354f8f.19.1757179152239; Sat, 06 Sep 2025
 10:19:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com> <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
In-Reply-To: <36c0e5e9d875addc42a73168b8090144c327ec9f.1756151769.git.maciej.wieczor-retman@intel.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Sat, 6 Sep 2025 19:19:01 +0200
X-Gm-Features: AS18NWCTNCapbXl_JpY4w398NCDrxjlYVkaeLQmKTOYiJH6ZL4Fo44ag69k2Lug
Message-ID: <CA+fCnZcMV0BOJyvx2nciCK2jvht-Hx0HnFtRzcc=zu+pQSOdVw@mail.gmail.com>
Subject: Re: [PATCH v5 13/19] kasan: x86: Handle int3 for inline KASAN reports
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7EF2A000F
X-Stat-Signature: wy4mab1nwwszacxzeowmn65dcz8sfr83
X-Rspam-User: 
X-HE-Tag: 1757179153-359956
X-HE-Meta: U2FsdGVkX1/LOodzeuEwGemK6Mi9ZgAQQJWEsRle430H/JZBRi8guVyHbdU4kKbOJUpWYyKI7xa+PZcjTmtt+flf8R0HYzLz47IdyGJFW5Rg4BTHvIKZCvVdNT76JT3Gz+mIlUoVquAjdMmRuNTlbbK+kJebERWONEEpM0zssEzuKSy4mf0I9znbXv5O/f52yQH/fdqtzVp/tIiIOsxNZwY20n7C306xnZ4D6GnqQu65hV/7a3Taah/ZtoTJqOnEPezxWbHy5RA/E2MxZMQb5OCUapOCaMinEufmxIQfvu/hIduceBUkHa1zlGjJns87Tu3iX5RK92SfPpIaequ85EYIm4NXoHJHqcqYKle+NrWOGzn8wazGX9Bc5ID3BPSVyN/mRmG0Ef7/ICXiggZFkieB7i+80INFEhHt6/RiWXznIUjJbrlaQ6kShymt5RDR5Ad4Gy0CXmI/OIcYwxF2NO0oUcqHEhhUeUsBX4VW97iYxZIhcQlox91Debfunba2v8meYUFAGnqkxXZX3aVH2Bwb7lUOi/zL4MbytQ6D6vXy61Rnj9HSeqRL4nZt29jSO9gI4ijaDxWyRPyCAlezTLRM/G2Hkgh70EUTdVD93cZhvSzgXzSWtqdukzV2xFQyreWScHvEjeKvAZ4uCut3e5oZaGq6XVTmHqvSh5CcKsxVdOMDd6kscEmDMtKWckQalpaqLCDmPwgWbSIAj6PO4P65oRAI42UIbP9jXHfyb4IWG0PQK8ZssbtrCyLpIGqB17/wGFwl4DoAvKP8++ceHVScS+Fcc3Am3FyENc6oPUMJ3IU8mTLAvieL1xG/TxCt+k0G2PfIYkzbjhB8UzYigUESK6UTw5ltPPD0Tu5IS4jLth9yhORzWBhkQ0If8n0fpDDpqXMmA4CRhZhwswAZar++EAH9qlSd0ad0dAiJxPYrK/4p6mvkmD05FaagXPiVsHZRzDw+A3NM0seZMGt
 tkflyR7P
 FlW45xPeREHgcOQLZjDO09oPqMiAAi9H8TTha2S97uQ+yE28bCoY8TpRXzDaxkRYD+7ffU1fsdm0extbJFIyGtl++6BSQGa+agYb6K9z9EGTAGpVmzBQdjzuzI86Bf0npmJ7y0FkZM9smkB3Cu7oLQOIULz0QUh897kD1ISaRNuV3UlUJLMDChnBXpo0IUHz07qfoCYhxZ9cFYfGDQbprbEK1oF7vqane5XWYj+IchFqF3VHIBYy5eOIViKzT9Wij129ihGtqL1r4MaUzgjTmWKPTTUkZxUjBFrGhk7FTMQwPh7mCrXT1u4Np58sl3ZB0j02BYIfLGvPhSj/CFK38Mmjw1oiF3ZqnyI9a4hFAVDHmPUkwppUQkOlGwGTnh60k+BF1Gv7Oef5brTxmJxIqMSyRvI+C0L5TfgwU/ay9EC66rp6RUbeEIh5YkvYlm2V8X0xZJfw16fUKxZHsE8nbXCXMtrOPucmDY+YT6g3YhP3avSg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:30=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> Inline KASAN on x86 does tag mismatch reports by passing the faulty
> address and metadata through the INT3 instruction - scheme that's setup
> in the LLVM's compiler code (specifically HWAddressSanitizer.cpp).
>
> Add a kasan hook to the INT3 handling function.
>
> Disable KASAN in an INT3 core kernel selftest function since it can raise
> a false tag mismatch report and potentially panic the kernel.
>
> Make part of that hook - which decides whether to die or recover from a
> tag mismatch - arch independent to avoid duplicating a long comment on
> both x86 and arm64 architectures.
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v5:
> - Add die to argument list of kasan_inline_recover() in
>   arch/arm64/kernel/traps.c.
>
> Changelog v4:
> - Make kasan_handler() a stub in a header file. Remove #ifdef from
>   traps.c.
> - Consolidate the "recover" comment into one place.
> - Make small changes to the patch message.
>
>  MAINTAINERS                   |  2 +-
>  arch/x86/include/asm/kasan.h  | 26 ++++++++++++++++++++++++++
>  arch/x86/kernel/alternative.c |  4 +++-
>  arch/x86/kernel/traps.c       |  4 ++++
>  arch/x86/mm/Makefile          |  2 ++
>  arch/x86/mm/kasan_inline.c    | 23 +++++++++++++++++++++++
>  include/linux/kasan.h         | 24 ++++++++++++++++++++++++
>  7 files changed, 83 insertions(+), 2 deletions(-)
>  create mode 100644 arch/x86/mm/kasan_inline.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 788532771832..f5b1ce242002 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13177,7 +13177,7 @@ S:      Maintained
>  B:     https://bugzilla.kernel.org/buglist.cgi?component=3DSanitizers&pr=
oduct=3DMemory%20Management
>  F:     Documentation/dev-tools/kasan.rst
>  F:     arch/*/include/asm/*kasan*.h
> -F:     arch/*/mm/kasan_init*
> +F:     arch/*/mm/kasan_*
>  F:     include/linux/kasan*.h
>  F:     lib/Kconfig.kasan
>  F:     mm/kasan/
> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
> index 1963eb2fcff3..5bf38bb836e1 100644
> --- a/arch/x86/include/asm/kasan.h
> +++ b/arch/x86/include/asm/kasan.h
> @@ -6,7 +6,28 @@
>  #include <linux/kasan-tags.h>
>  #include <linux/types.h>
>  #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
> +#ifdef CONFIG_KASAN_SW_TAGS
> +
> +/*
> + * LLVM ABI for reporting tag mismatches in inline KASAN mode.
> + * On x86 the INT3 instruction is used to carry metadata in RAX
> + * to the KASAN report.
> + *
> + * SIZE refers to how many bytes the faulty memory access
> + * requested.
> + * WRITE bit, when set, indicates the access was a write, otherwise
> + * it was a read.
> + * RECOVER bit, when set, should allow the kernel to carry on after
> + * a tag mismatch. Otherwise die() is called.
> + */
> +#define KASAN_RAX_RECOVER      0x20
> +#define KASAN_RAX_WRITE                0x10
> +#define KASAN_RAX_SIZE_MASK    0x0f
> +#define KASAN_RAX_SIZE(rax)    (1 << ((rax) & KASAN_RAX_SIZE_MASK))
> +
> +#else
>  #define KASAN_SHADOW_SCALE_SHIFT 3

Putting this under else in this patch looks odd, we can move this part
to "x86: Make software tag-based kasan available".

> +#endif
>
>  /*
>   * Compiler uses shadow offset assuming that addresses start
> @@ -35,10 +56,15 @@
>  #define __tag_shifted(tag)             FIELD_PREP(GENMASK_ULL(60, 57), t=
ag)
>  #define __tag_reset(addr)              (sign_extend64((u64)(addr), 56))
>  #define __tag_get(addr)                        ((u8)FIELD_GET(GENMASK_UL=
L(60, 57), (u64)addr))
> +bool kasan_inline_handler(struct pt_regs *regs);
>  #else
>  #define __tag_shifted(tag)             0UL
>  #define __tag_reset(addr)              (addr)
>  #define __tag_get(addr)                        0
> +static inline bool kasan_inline_handler(struct pt_regs *regs)
> +{
> +       return false;
> +}
>  #endif /* CONFIG_KASAN_SW_TAGS */
>
>  static inline void *__tag_set(const void *__addr, u8 tag)
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.=
c
> index 2a330566e62b..4cb085daad31 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -2228,7 +2228,7 @@ int3_exception_notify(struct notifier_block *self, =
unsigned long val, void *data
>  }
>
>  /* Must be noinline to ensure uniqueness of int3_selftest_ip. */
> -static noinline void __init int3_selftest(void)
> +static noinline __no_sanitize_address void __init int3_selftest(void)
>  {
>         static __initdata struct notifier_block int3_exception_nb =3D {
>                 .notifier_call  =3D int3_exception_notify,
> @@ -2236,6 +2236,7 @@ static noinline void __init int3_selftest(void)
>         };
>         unsigned int val =3D 0;
>
> +       kasan_disable_current();
>         BUG_ON(register_die_notifier(&int3_exception_nb));
>
>         /*
> @@ -2253,6 +2254,7 @@ static noinline void __init int3_selftest(void)
>
>         BUG_ON(val !=3D 1);
>
> +       kasan_enable_current();
>         unregister_die_notifier(&int3_exception_nb);
>  }
>
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 0f6f187b1a9e..2a119279980f 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -912,6 +912,10 @@ static bool do_int3(struct pt_regs *regs)
>         if (kprobe_int3_handler(regs))
>                 return true;
>  #endif
> +
> +       if (kasan_inline_handler(regs))
> +               return true;
> +
>         res =3D notify_die(DIE_INT3, "int3", regs, 0, X86_TRAP_BP, SIGTRA=
P);
>
>         return res =3D=3D NOTIFY_STOP;
> diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
> index 5b9908f13dcf..1dc18090cbe7 100644
> --- a/arch/x86/mm/Makefile
> +++ b/arch/x86/mm/Makefile
> @@ -36,7 +36,9 @@ obj-$(CONFIG_PTDUMP)          +=3D dump_pagetables.o
>  obj-$(CONFIG_PTDUMP_DEBUGFS)   +=3D debug_pagetables.o
>
>  KASAN_SANITIZE_kasan_init_$(BITS).o :=3D n
> +KASAN_SANITIZE_kasan_inline.o :=3D n
>  obj-$(CONFIG_KASAN)            +=3D kasan_init_$(BITS).o
> +obj-$(CONFIG_KASAN_SW_TAGS)    +=3D kasan_inline.o
>
>  KMSAN_SANITIZE_kmsan_shadow.o  :=3D n
>  obj-$(CONFIG_KMSAN)            +=3D kmsan_shadow.o
> diff --git a/arch/x86/mm/kasan_inline.c b/arch/x86/mm/kasan_inline.c
> new file mode 100644
> index 000000000000..9f85dfd1c38b
> --- /dev/null
> +++ b/arch/x86/mm/kasan_inline.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#include <linux/kasan.h>
> +#include <linux/kdebug.h>
> +
> +bool kasan_inline_handler(struct pt_regs *regs)
> +{
> +       int metadata =3D regs->ax;
> +       u64 addr =3D regs->di;
> +       u64 pc =3D regs->ip;
> +       bool recover =3D metadata & KASAN_RAX_RECOVER;
> +       bool write =3D metadata & KASAN_RAX_WRITE;
> +       size_t size =3D KASAN_RAX_SIZE(metadata);
> +
> +       if (user_mode(regs))
> +               return false;
> +
> +       if (!kasan_report((void *)addr, size, write, pc))
> +               return false;

Hm, this part is different than on arm64: there, we don't check the
return value.

Do I understand correctly that the return value from this function
controls whether we skip over the int3 instruction and continue the
execution? If so, we should return the same value regardless of
whether the report is suppressed or not. And then you should not need
to explicitly check for KASAN_BIT_MULTI_SHOT in the latter patch.

> +
> +       kasan_inline_recover(recover, "Oops - KASAN", regs, metadata, die=
);

Maybe name this is as kasan_die_unless_recover()?


> +
> +       return true;
> +}
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 54481f8c30c5..8691ad870f3b 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -663,4 +663,28 @@ void kasan_non_canonical_hook(unsigned long addr);
>  static inline void kasan_non_canonical_hook(unsigned long addr) { }
>  #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
>
> +#ifdef CONFIG_KASAN_SW_TAGS
> +/*
> + * The instrumentation allows to control whether we can proceed after
> + * a crash was detected. This is done by passing the -recover flag to
> + * the compiler. Disabling recovery allows to generate more compact
> + * code.
> + *
> + * Unfortunately disabling recovery doesn't work for the kernel right
> + * now. KASAN reporting is disabled in some contexts (for example when
> + * the allocator accesses slab object metadata; this is controlled by
> + * current->kasan_depth). All these accesses are detected by the tool,
> + * even though the reports for them are not printed.
> + *
> + * This is something that might be fixed at some point in the future.
> + */
> +static inline void kasan_inline_recover(
> +       bool recover, char *msg, struct pt_regs *regs, unsigned long err,
> +       void die_fn(const char *str, struct pt_regs *regs, long err))
> +{
> +       if (!recover)
> +               die_fn(msg, regs, err);
> +}
> +#endif
> +
>  #endif /* LINUX_KASAN_H */
> --
> 2.50.1
>

