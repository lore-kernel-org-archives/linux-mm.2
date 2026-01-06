Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A49ECEFCE6
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D8FB6B0005; Tue,  6 Jan 2026 13:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9865F6B008A; Tue,  6 Jan 2026 13:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B00E6B0092; Tue,  6 Jan 2026 13:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76C7A6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:10:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 492BB1AB78F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:10:04 +0000 (UTC)
X-FDA: 84302327928.21.BDD8686
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id 495DF140016
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:10:02 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1Q2XCkA;
	spf=pass (imf23.hostedemail.com: domain of ubizjak@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=ubizjak@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767723002; a=rsa-sha256;
	cv=none;
	b=3gSYaNgALHY+5POKAvv+g4o19AkvPIP5CRI0NtQjN7uu6pCVR47ZEFDg23H+vY5rabQomA
	3jiGCZ4efhoJu2JBRbkg/UKO+K0IXX3uMX81tAtFRjq3rPGTqr6Mqc8Xh+9h0P120mE/Bs
	HNUQG4Y3hg3S7Kj325u+Bb5x+ZIEtoA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O1Q2XCkA;
	spf=pass (imf23.hostedemail.com: domain of ubizjak@gmail.com designates 209.85.208.177 as permitted sender) smtp.mailfrom=ubizjak@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767723002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tnFJTdAUFhEmW0tR2qamSfQ3pZ9alh5f7uC4JnPOGLk=;
	b=5zxpnppe3b7UxT3sdgO9c5OnBIUL/ZTTGJcq9WHwbzmZV3QzJPGDQvk7ao7r6uHWJdUyT1
	qlQ3S5My/QnR+YNj1MMciAAR7kvI+tNZ0yTX8K0pRxrXXXWEbhWIgREHA+QiLUpD3i+hxR
	+0PDYc7uMAMhUVrha/1DFYyJgh+3bKQ=
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-382fb535b73so2907621fa.0
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 10:10:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767723000; x=1768327800; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tnFJTdAUFhEmW0tR2qamSfQ3pZ9alh5f7uC4JnPOGLk=;
        b=O1Q2XCkASkNW9Psy16hfHJ2rha6tc/8RrWK2mSjsC1HU8uxTMOyNHBAtS7dHC3HqVh
         mVZgMYCtLvVj5ePeDC00VwS0pwtuNzD+fyrHAAvFCaKOaipkdMxlK80CK3EvadrOMBAo
         MYRj8ia0iO5yJQt30FqW1WVkyGaqaVsLtS5g0QPR3cAaxGZijOM1KuJLqIo854lkITFi
         nHIJNDA2p9tVJZ7BUA1u0YWbkJDqqI9vdKKUFl/tbPmYE1+VRTvrf5+nL5G5ts7cWtHW
         vHr/yMb6915LjL++2CUoRj10IMvAFZQN7ikcijCr4aA+U6/6ElkV8KPqK6NhVga2pahc
         pdgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767723000; x=1768327800;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tnFJTdAUFhEmW0tR2qamSfQ3pZ9alh5f7uC4JnPOGLk=;
        b=SOrm3+aLSEE4fH5qz81p9sjfigIiR/ktzr3WZxIrswU/X6IBIoqDgy1jRoPLpBC1Qu
         lHQ2W+izktcRnktDr+xDRNXO3kfxIieHjRaWEkZsE2b4W0LCyxZpn9RX8w0vVe4laYba
         gHGZ44893WxSRQqyhdhe4+KqMupBqA3wL6UDWonZWWdxdZ2ssXbrDVa4+A/06FNSZpv3
         lzDA65D5TAUp5BkP7Zje/uVKtJ2qRkd3rcamisw6Tcs9enmKR5tubxiRrXa3bxxdULD8
         JLcUCgnqFL7ILye+UpaXpgKCbAZscKf0Sb4Ut5hWBljB8w/lwjWlvZ7QNt2uoYitHH35
         2/Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWMmpToolKhhB4TdAQQhZ0X5a6SnqT83r0iM4O0WQ0d3/6cPw3fseTEoj8w8l0gh6hxKJ6VKgpNQQ==@kvack.org
X-Gm-Message-State: AOJu0Yzb7aILs6NPA3YxUuzN5rhtj9MeuLNxJm2UwKd+34mVQZQ5MX5/
	y09Y+PyFSrZnZPb2mckdJfc3xkEQbIzZclAdpNUYEPmBgXck3XxiYrwWexaI71cr1A0sGUtCfF+
	ku1GndcHT/x8fgjmZ1XzhT1CZxWjQMFs=
X-Gm-Gg: AY/fxX5uspd9D+TE0ykGozIFDJvu38oZRUqp8wb3+vXBzuO2ait27CcloUOWqNJfP2k
	9IopPhCvXq7TqNbW1TL3doxvLskOd7wllEKmpJmyzlR5T1vL6Oaz+g8yhKXqPprVurur3fTAiW9
	FZ76CuuzOlVq7K7TdiWJoUzrMCOg6PJ8PhlvSBe9uudf38Y9QGKsgmR/SeAhn+17Krtlb9COrEj
	WW96foyFVns7Jp//bfy4ojQuUmeZW7hCyyIlb6ni1lOG0HCvIkhDqoeh3lY9Aa5PxOiAXuUZZvk
	C7syl4pv3JdXXenh88emqZY5ODxn/tcj7WFxAMNHww0E+NNh
X-Google-Smtp-Source: AGHT+IHMYU+nk1r5SKL7TSwqR3QLSy12FC5m91tH1LYgMH9CNfNRgKMZ574MhYRurVuFQRtgy5OSRqqEEKHj6a+SALI=
X-Received: by 2002:a05:651c:b1e:b0:37b:9976:df0d with SMTP id
 38308e7fff4ca-382eaac3863mr10517641fa.21.1767722999902; Tue, 06 Jan 2026
 10:09:59 -0800 (PST)
MIME-Version: 1.0
References: <20251216212606.1325678-1-hpa@zytor.com> <20251216212606.1325678-9-hpa@zytor.com>
In-Reply-To: <20251216212606.1325678-9-hpa@zytor.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Tue, 6 Jan 2026 19:09:48 +0100
X-Gm-Features: AQt7F2p_W3_5YudECGljLUVodss-gTpK6wtqg-lAs_JJhTsy4VEleAOJ12I6yk4
Message-ID: <CAFULd4bQ-0ZD8PeAYiK1WK6yhKctxTSPksJLGg4gmE1eqzKDNg@mail.gmail.com>
Subject: Re: [PATCH v4 08/10] x86/vdso: abstract out vdso system call internals
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Brian Gerst <brgerst@gmail.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, 
	Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 495DF140016
X-Rspamd-Server: rspam04
X-Stat-Signature: g9hbuhb845733rzk7okx65m7e1gx51wo
X-HE-Tag: 1767723002-305599
X-HE-Meta: U2FsdGVkX19vPXhMyIFYh/UQCFPut9NiIheyRl1aW1AFlc7y1/WpYqQipqkxvVCoB+q57NgD9LPieXEZMRIbLjT3sICdeVplDksTO66i8fu6mCR/8kfLozmv3k0eHplK8fWWVHUf41Yq67hIsDnDiXsrOazSMf8U4YBGYUVEIAVF0de8n4kJ6In+cQ7M0o/NClcxGMtDIpTW0VjuMh7i8AyPymLDSOQIF3rdTSq5a0i+3doYxO9zw+9Fjx9pxp94sje/yzm9DIrx1YZNAnTqdp2ozUJr5nTXpvPK+FW0H7i0nnCxdeEfM4z3M+lZJ0Ka06GqSb9zGJHj+Xu5xY4mbTYKV08BW9FkNj/4v6O+ASBJzC2MAgDm8876jQxsYxOAaO8TqLeVhkSo50fxXEBaEqHgof2Qw14blTck1bieyKoCVcIiJJpfHIRKdeVZWy5xeujEcsX0mb0AtA1RS0aOiSACPH9kpO5nA9P52UmuipZnQkhqaosDE8LHApJnOrOSn96EFE1wZAhExVpYRzcQj8TsbLcNgGgL1fCfLu4ySJ01tqfn3/mpG07Bcpg55UEQgEJssSqg5QfofKdt4qqDv1mhY5FSY5g3lsJnygHBNvqrKy88y7Pxph1kwMcY8I5faioNtAKwmMWjoscnHD9pVxUh3vuQBEOtFX0r/TUChitPX9rmQH3/bxSnXWy8pliWyWWuVn+IAI95v1/QoaFIHr9wIxMPXc/yIMNliF4frrHDnjjLiEoZkN9QbRIHs+3nl/JA1xntKWaRB3HOlVSjkS52njx5Jl4qxugTWSJWuy2ZaQMLjt0XThB3JtnqW50mKm3ZKIixOkLG8jBq09/xyAIfXTFnosAz7rv6VVpDwLthzCLuprcbfaZ78g49zJFIAAkOtNzN3vYJEBffRjwv20sr1R2b7YkSZUfOpHvf4FvikfAnDTh8/qgWiPW/ZHRILxqTBnnwIK3pa2gJInT
 3/FHRyPC
 PayVK8cJPcj01N9PxqfIY+gO2Qbb4vU5BpgGAOhPlh2Jr6yhi3RsKJfLvRTHsL0ExGB52EprhpOq8jEnyYsJMOv+Ztz+gJzcqNF17Q1tH0Md43V9gOOjIVr6OLkss8/vzOc7YSK/sNi41gLrb2YVkEnbRzSjfQCUGH3ls6Ar5YKslY46BcolKv25s+GtlN6Y+UyvtzfiYbttrR59IsmerAgqRuBTecsD7SSRvspAi3s5MXTjKvnL2RK8mWt37dorVehxKFioUgYEVqiBFLWOtdkvenj5GU2mR7Gk0ew2ic0F/so40OQkjJYEtJDxVfkJR3UOo16zIQ0+885gNP6zYJyOaSFvjZQ7Vxg2fylyHnfPUKNyCUD/kb9C+LPvnC11p6Yd1yImBtGtSZA9Gi4tE/znLTd6przCdNL+FZXoazgXz1OZYU9oI1In6RUa5p9d+bv0j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:26=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wro=
te:
>
> Abstract out the calling of true system calls from the vdso into
> macros.
>
> It has been a very long time since gcc did not allow %ebx or %ebp in
> inline asm in 32-bit PIC mode; remove the corresponding hacks.
>
> Remove the use of memory output constraints in gettimeofday.h in favor
> of "memory" clobbers. The resulting code is identical for the current
> use cases, as the system call is usually a terminal fallback anyway,
> and it merely complicates the macroization.
>
> This patch adds only a handful of more lines of code than it removes,
> and in fact could be made substantially smaller by removing the macros
> for the argument counts that aren't currently used, however, it seems
> better to be general from the start.
>
> [ v3: remove stray comment from prototyping; remove VDSO_SYSCALL6()
>       since it would require special handling on 32 bits and is
>       currently unused. (Uros Biszjak)
>
>       Indent nested preprocessor directives. ]
>
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>

Acked-by: Uros Bizjak <ubizjak@gmail.com>

> ---
>  arch/x86/include/asm/vdso/gettimeofday.h | 108 ++---------------------
>  arch/x86/include/asm/vdso/sys_call.h     | 103 +++++++++++++++++++++
>  2 files changed, 111 insertions(+), 100 deletions(-)
>  create mode 100644 arch/x86/include/asm/vdso/sys_call.h
>
> diff --git a/arch/x86/include/asm/vdso/gettimeofday.h b/arch/x86/include/=
asm/vdso/gettimeofday.h
> index 73b2e7ee8f0f..3cf214cc4a75 100644
> --- a/arch/x86/include/asm/vdso/gettimeofday.h
> +++ b/arch/x86/include/asm/vdso/gettimeofday.h
> @@ -18,6 +18,7 @@
>  #include <asm/msr.h>
>  #include <asm/pvclock.h>
>  #include <clocksource/hyperv_timer.h>
> +#include <asm/vdso/sys_call.h>
>
>  #define VDSO_HAS_TIME 1
>
> @@ -53,130 +54,37 @@ extern struct ms_hyperv_tsc_page hvclock_page
>         __attribute__((visibility("hidden")));
>  #endif
>
> -#ifndef BUILD_VDSO32
> -
>  static __always_inline
>  long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *=
_ts)
>  {
> -       long ret;
> -
> -       asm ("syscall" : "=3Da" (ret), "=3Dm" (*_ts) :
> -            "0" (__NR_clock_gettime), "D" (_clkid), "S" (_ts) :
> -            "rcx", "r11");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_gettime,64,_clkid,_ts);
>  }
>
>  static __always_inline
>  long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
>                            struct timezone *_tz)
>  {
> -       long ret;
> -
> -       asm("syscall" : "=3Da" (ret) :
> -           "0" (__NR_gettimeofday), "D" (_tv), "S" (_tz) : "memory");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(gettimeofday,,_tv,_tz);
>  }
>
>  static __always_inline
>  long clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_=
ts)
>  {
> -       long ret;
> -
> -       asm ("syscall" : "=3Da" (ret), "=3Dm" (*_ts) :
> -            "0" (__NR_clock_getres), "D" (_clkid), "S" (_ts) :
> -            "rcx", "r11");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_getres,_time64,_clkid,_ts);
>  }
>
> -#else
> -
> -static __always_inline
> -long clock_gettime_fallback(clockid_t _clkid, struct __kernel_timespec *=
_ts)
> -{
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_gettime64), [clock] "g" (_clkid), "c" (=
_ts)
> -               : "edx");
> -
> -       return ret;
> -}
> +#ifndef CONFIG_X86_64
>
>  static __always_inline
>  long clock_gettime32_fallback(clockid_t _clkid, struct old_timespec32 *_=
ts)
>  {
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_gettime), [clock] "g" (_clkid), "c" (_t=
s)
> -               : "edx");
> -
> -       return ret;
> -}
> -
> -static __always_inline
> -long gettimeofday_fallback(struct __kernel_old_timeval *_tv,
> -                          struct timezone *_tz)
> -{
> -       long ret;
> -
> -       asm(
> -               "mov %%ebx, %%edx \n"
> -               "mov %2, %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret)
> -               : "0" (__NR_gettimeofday), "g" (_tv), "c" (_tz)
> -               : "memory", "edx");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_gettime,,_clkid,_ts);
>  }
>
>  static __always_inline long
> -clock_getres_fallback(clockid_t _clkid, struct __kernel_timespec *_ts)
> -{
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_getres_time64), [clock] "g" (_clkid), "=
c" (_ts)
> -               : "edx");
> -
> -       return ret;
> -}
> -
> -static __always_inline
> -long clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_t=
s)
> +clock_getres32_fallback(clockid_t _clkid, struct old_timespec32 *_ts)
>  {
> -       long ret;
> -
> -       asm (
> -               "mov %%ebx, %%edx \n"
> -               "mov %[clock], %%ebx \n"
> -               "call __kernel_vsyscall \n"
> -               "mov %%edx, %%ebx \n"
> -               : "=3Da" (ret), "=3Dm" (*_ts)
> -               : "0" (__NR_clock_getres), [clock] "g" (_clkid), "c" (_ts=
)
> -               : "edx");
> -
> -       return ret;
> +       return VDSO_SYSCALL2(clock_getres,,_clkid,_ts);
>  }
>
>  #endif
> diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/=
vdso/sys_call.h
> new file mode 100644
> index 000000000000..dcfd17c6dd57
> --- /dev/null
> +++ b/arch/x86/include/asm/vdso/sys_call.h
> @@ -0,0 +1,103 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Macros for issuing an inline system call from the vDSO.
> + */
> +
> +#ifndef X86_ASM_VDSO_SYS_CALL_H
> +#define X86_ASM_VDSO_SYS_CALL_H
> +
> +#include <linux/compiler.h>
> +#include <asm/cpufeatures.h>
> +#include <asm/alternative.h>
> +
> +#ifdef CONFIG_X86_64
> +# define __sys_instr   "syscall"
> +# define __sys_clobber "rcx", "r11", "memory"
> +# define __sys_nr(x,y) __NR_ ## x
> +# define __sys_reg1    "rdi"
> +# define __sys_reg2    "rsi"
> +# define __sys_reg3    "rdx"
> +# define __sys_reg4    "r10"
> +# define __sys_reg5    "r8"
> +#else
> +# define __sys_instr   "call __kernel_vsyscall"
> +# define __sys_clobber "memory"
> +# define __sys_nr(x,y) __NR_ ## x ## y
> +# define __sys_reg1    "ebx"
> +# define __sys_reg2    "ecx"
> +# define __sys_reg3    "edx"
> +# define __sys_reg4    "esi"
> +# define __sys_reg5    "edi"
> +#endif
> +
> +/*
> + * Example usage:
> + *
> + * result =3D VDSO_SYSCALL3(foo,64,x,y,z);
> + *
> + * ... calls foo(x,y,z) on 64 bits, and foo64(x,y,z) on 32 bits.
> + *
> + * VDSO_SYSCALL6() is currently missing, because it would require
> + * special handling for %ebp on 32 bits when the vdso is compiled with
> + * frame pointers enabled (the default on 32 bits.) Add it as a special
> + * case when and if it becomes necessary.
> + */
> +#define _VDSO_SYSCALL(name,suf32,...)                                  \
> +       ({                                                              \
> +               long _sys_num_ret =3D __sys_nr(name,suf32);              =
 \
> +               asm_inline volatile(                                    \
> +                       __sys_instr                                     \
> +                       : "+a" (_sys_num_ret)                           \
> +                       : __VA_ARGS__                                   \
> +                       : __sys_clobber);                               \
> +               _sys_num_ret;                                           \
> +       })
> +
> +#define VDSO_SYSCALL0(name,suf32)                                      \
> +       _VDSO_SYSCALL(name,suf32)
> +#define VDSO_SYSCALL1(name,suf32,a1)                                   \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1));                         \
> +       })
> +#define VDSO_SYSCALL2(name,suf32,a1,a2)                                \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2));        \
> +       })
> +#define VDSO_SYSCALL3(name,suf32,a1,a2,a3)                             \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               register long _sys_arg3 asm(__sys_reg3) =3D (long)(a3);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2),         \
> +                             "r" (_sys_arg3));                         \
> +       })
> +#define VDSO_SYSCALL4(name,suf32,a1,a2,a3,a4)                          \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               register long _sys_arg3 asm(__sys_reg3) =3D (long)(a3);  =
 \
> +               register long _sys_arg4 asm(__sys_reg4) =3D (long)(a4);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2),         \
> +                             "r" (_sys_arg3), "r" (_sys_arg4));        \
> +       })
> +#define VDSO_SYSCALL5(name,suf32,a1,a2,a3,a4,a5)                       \
> +       ({                                                              \
> +               register long _sys_arg1 asm(__sys_reg1) =3D (long)(a1);  =
 \
> +               register long _sys_arg2 asm(__sys_reg2) =3D (long)(a2);  =
 \
> +               register long _sys_arg3 asm(__sys_reg3) =3D (long)(a3);  =
 \
> +               register long _sys_arg4 asm(__sys_reg4) =3D (long)(a4);  =
 \
> +               register long _sys_arg5 asm(__sys_reg5) =3D (long)(a5);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2),         \
> +                             "r" (_sys_arg3), "r" (_sys_arg4),         \
> +                             "r" (_sys_arg5));                         \
> +       })
> +
> +#endif /* X86_VDSO_SYS_CALL_H */
> --
> 2.52.0
>

