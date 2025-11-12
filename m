Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77EB9CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 10:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5DF8E001B; Wed, 12 Nov 2025 05:31:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D578E0002; Wed, 12 Nov 2025 05:31:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794DA8E001B; Wed, 12 Nov 2025 05:31:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 621F58E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:31:22 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EDEEE12DBB9
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:31:21 +0000 (UTC)
X-FDA: 84101587962.22.85ECDB1
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf30.hostedemail.com (Postfix) with ESMTP id 077B780013
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:31:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P+gjXJ36;
	spf=pass (imf30.hostedemail.com: domain of ubizjak@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=ubizjak@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762943480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=waFQrQEMkwV0AnBAZW1IyENDtfIMwyrwUkcDrilArcw=;
	b=RGAH0w4umRRUeS2L93pg+HS9+13M0mhwNBAfM7ZEC+6K0ozvpcVyQj3t0HlrTBrWdqOLli
	1V5/P/lgyGfk8mtkpTQZqf+/oautyTR766dkBrmEJvRtIP0wgJQlHkkfxh7yOHFzn+hsVK
	qM28ddXajOzi3jEKfoDRpW4PdprSp/Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P+gjXJ36;
	spf=pass (imf30.hostedemail.com: domain of ubizjak@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=ubizjak@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762943480; a=rsa-sha256;
	cv=none;
	b=wRoAq8FvKFyD6oADZxV97KiabkQBHk2JyhmCSiUtYaIvkJNmLe6OPSb/8mPo5vPLvkxyOR
	YkLBotI9NNgPxmFcaMQktUd/8WEm5YLdaoaF4w71Jfm7P+U7ofDGqaK1OBxgIu27oVQ65k
	nxJB2a5XOafgh8CndT/Zl9wxikv1png=
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5930f751531so654265e87.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762943478; x=1763548278; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=waFQrQEMkwV0AnBAZW1IyENDtfIMwyrwUkcDrilArcw=;
        b=P+gjXJ36hsvSX3B8298pYSFVegBkgjDAn5aAEYMbmstACTL1XDJwZ66D/JzGkeo3m/
         lR1K2bmyk1ckTw7yj4pJHCMWPEfrsrYc4MdIQ3DLORBFK8eM5A5nqITW5eqG3D5eJVW/
         8+GucgF4AkHv6JrkH1XRTviav3T6ZYFgSv0LKEx2K5pkE3Oj01mStKQCwYd65t0kqMUu
         2TntfhtRkjZTNdvpU5FvXTeElipvf6Xh/sDqrjCPdBsD7+rvr5+fEyzcXXZ4oQXhLdDI
         6ZzmatJ7ELxIkzl0FFARFGyfzdPVdbZ+AeejWtKRteI7wbFlsPFmnivocInGtUOwSZCA
         oKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762943478; x=1763548278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=waFQrQEMkwV0AnBAZW1IyENDtfIMwyrwUkcDrilArcw=;
        b=Be1VS+8w98/9+NM6xH92hrLjCoTL/iBXR33M6eGOIzA0uQGk4eKoHJP5lUh/9ER4GD
         f8AEvOEaZIqWvz7+dXWMfeE/qWBVAl1NXxp/54Kw2BybFBSs2l+r1w1zmNBXA5Uelnv9
         tH+Ruz/sMfiaQQXiRkfoADndDlS9ksddUI+4kDSaCf0ZcyYQjFp3+rn7MLUshPiZow9V
         A7OZ4abmlMrtGugjJOTV3+r3ykmwWnbzDkuJpP+y3RjrFwtYHAi6/8UODZMc5HwyJyFz
         HB75rIq3WutiQdb8aZ1o7hba1AbFe2PnWx3l42gQ2z0haAtiH3UkDp2WmTWmNoBF9bF1
         IgBw==
X-Forwarded-Encrypted: i=1; AJvYcCX0Ry+fgm/6Z/9GV46oM2nL4Ja9UibvSQQlf4E/tPznogvhpoeQ5J9mok78lxfsvo6xf8UO7gziyw==@kvack.org
X-Gm-Message-State: AOJu0YwnQD9UOUjuMI0C9c6LkwzxI1scb0OaqdUkyQPBLdlycRIOWpTY
	HhEoEUXE2SshlQe9QvzcGDrpskcsqs+dHXUgSqPMgwweAtkwgfmOLFzY+BS3QBLWEfe9+3RpxKb
	fH8G96ntXSPzZbUpmXzw0etB517hkNd0=
X-Gm-Gg: ASbGncu/QLlS8o4VbwWN5YkVIaoym/967zNnuBrbI1CzlHUnDDX7bq2aqzXI6RJGI2+
	ZLuOfLa88KZ0imN6GpdT7+O/gNYdx91klhiiJlVm7lDSXZrpIW2kbT/4C4CuKS4iibk3W4NTjPA
	HleHTY2dBjSge2wejOG8Aa+OMjuZnWX7gg42m+qnEH0ZiHGmHmIoY7DNWpdWwLXx3B1o9fCItVo
	DjSCee+jBVNMImrJiZeEa4Tq54SWp4t6tHvJwgmSD6gaF2S/Crr3d5YJQT9QS83/8tMTxs=
X-Google-Smtp-Source: AGHT+IFjqgrhQOtTb5gBhAyMW1L6vKw3JdPMp9cVBsW7gktCSYBmB2KY0NW2W13eaBsDxYqKpi5mZFREAYsMq4231Cw=
X-Received: by 2002:a05:6512:10c2:b0:594:28f6:b065 with SMTP id
 2adb3069b0e04-59576df6d1cmr753013e87.17.1762943477499; Wed, 12 Nov 2025
 02:31:17 -0800 (PST)
MIME-Version: 1.0
References: <20251112043730.992152-1-hpa@zytor.com> <20251112043730.992152-8-hpa@zytor.com>
In-Reply-To: <20251112043730.992152-8-hpa@zytor.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Wed, 12 Nov 2025 11:31:05 +0100
X-Gm-Features: AWmQ_bl_6enZNq-U70wxnLPV5q31f2DKNvw7Lw1-kfdYqLTgPTZDCUhJgguZtAk
Message-ID: <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com>
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 077B780013
X-Stat-Signature: k4t3riy1fwm3qmob5e6zymh7jc4i8fid
X-Rspam-User: 
X-HE-Tag: 1762943479-456672
X-HE-Meta: U2FsdGVkX181Sr/yXfaFY3zpOi9nRsKO0GF47LGynaktNIcRnxrfRZjdIH/aMZjIA+rc9+9s2NPsQADygiedYFvcKK9BGHU73j0jrtJH+vTzks6pywY5UdcGBAUIQcfDi2Zmp5jjehb4lobnI8pgISKcks0RZTvKJLspRzQB7pYAqOf0Qb5CyroBWdAlaoBNGLYrF5VZBkpSTFQSK0CaO9loCEAcDlJIkgDnLL9Sg7LOAPn2rBpma75DfKPBvATH0RYJSJhBJ+ucEaX+aCqCqZ6t3uG3VgVsQ8//xsZVfJMAqNyk7HtWSvUMjrzEdXaoq6pC0kSweJHYLoTNGZReBOLIrbsARaa+47X9ZJ3B7GHVJrl2m1oD6LraprrivrEyQ+39C67CSotVGsGKoBBaIwoJgb/3psuqnDdvJRvDkXv8MDEvrH+4P6+D5ap6EPepcCbZBI/SzC/e/A+XShNxBb6Pd84B9Ay0g4uVmxO5q1AiukHiPxt6nAqFF2CF8+r0hZQ7jeI4a2h3oTywhE7vnbYMVMhhROpM2vZPzXaBKI9eOzJxqdCxHIf0dCWwFZaouKndzVEWSisEqwaAQ0qjt1uUwUjrjygV3u8uQH5m9LMpf3feBYINeJPNjvMmwqUEIKSZklDKVOdq5S/8Ws8EsSvYCwJUQJd6Jjl8BwMjLEVNOhq68aiZYrqdVHDX49nhbwc+vq9fodO7twEou2V95He6rDoGSgyXtbRVRHVB4s7B5h8WcCmuN3FJ49raHj4JpFNxTk7sM0UR9R8+x6pEd5hiZADOnihVHRddtuChTE6kN0Dm86QbQ+UVAw+W8z6n0Ym1iPbkqjRiTJSpX6QZkSD4mPdOXmxPLGI62QVzwBDllt9sjveEE5bz1Qlo5zRk8w2dIRpsq0e/p5wQO0T/UCWkJ7LHpExVF8ueGuAMd6NDkjC/ISPT7rPYILsbB4Bw6O5/WRvml6z3zCaKYpT
 ZIP333V2
 Gjp4iAkew7f7N1Odu7bZJuVg00KMIo/9M1qAIFwtBF4eN8nRDPhSDJ6N7TA/vANIfvJSOwiFFlF9v80AE+YywUhi0odyev6HCUI+dFAIRCvYMAicQdn0LHZn2QoZmaML1QLTp0OQBeIF6KNLv4zvozYpMc5wBaQa8loCfBNFCTn4fzTHZZkG8fxOOw9XvZq2UQv/mWTkbN9KA8HAiRhRLHxT8URVMQGPQ6KSlTXQu0q0rCmnj+Ac3cQGUCIlldvQP/M6OQLH5vD6W7eG9LsDbES7PEimuD37Rc6asJO6/Kx8KgA7TGBgZhvILHIqYMU9fGYJA5tHxCqjGN8F8tPTIC2EAKjx+OBhI65QXTXd88mbNaKvx3HguYipRgZbBNfi5afVrW1Oe3JKYyDEE15C71NNENgesh1QwrH9rEfCuXvk984pKWUFSsVn0rTWGJFNmiFgma/d0DmoevtE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 5:38=E2=80=AFAM H. Peter Anvin <hpa@zytor.com> wrot=
e:
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
> Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>

[...]

> diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/=
vdso/sys_call.h
> new file mode 100644
> index 000000000000..6b1fbcdcbd5c
> --- /dev/null
> +++ b/arch/x86/include/asm/vdso/sys_call.h
> @@ -0,0 +1,119 @@
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
> +/*
> + * Note: only three arguments are currently supported,
> + * because there are no constraint letters for r10, r8, r9.

The above comment does not apply when using local variables associated
with a register.

> + */
> +#ifdef CONFIG_X86_64
> +/* Using dummy output registers instead of clobbers avoids messing up
> +   user-specified clobbers. */
> +#define __sys_instr    "syscall"
> +#define __sys_clobber  "rcx", "r11", "memory"
> +#define __sys_nr(x,y)  __NR_ ## x
> +#define __sys_reg1     "rdi"
> +#define __sys_reg2     "rsi"
> +#define __sys_reg3     "rdx"
> +#define __sys_reg4     "r10"
> +#define __sys_reg5     "r8"
> +#define __sys_reg6     "r9"
> +#else
> +#define __sys_instr    "call __kernel_vsyscall"
> +#define __sys_clobber  "memory"
> +#define __sys_nr(x,y)  __NR_ ## x ## y
> +#define __sys_reg1     "ebx"
> +#define __sys_reg2     "ecx"
> +#define __sys_reg3     "edx"
> +#define __sys_reg4     "esi"
> +#define __sys_reg5     "edi"
> +#define __sys_reg6     "ebp"
> +#endif

[...]

> +#define VDSO_SYSCALL6(name,suf32,a1,a2,a3,a4,a5,a6)                    \
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
> +               register long _sys_arg6 asm(__sys_reg6) =3D (long)(a6);  =
 \
> +               _VDSO_SYSCALL(name,suf32,                               \
> +                             "r" (_sys_arg1), "r" (_sys_arg2),         \
> +                             "r" (_sys_arg3), "r" (_sys_arg4),         \
> +                             "r" (_sys_arg5), "r" (_sys_arg6));        \
> +       })

Unfortunately, %ebp is still special with -fno-omit-frame-pointer, so
using "ebp" as _sys_arg6 on 32-bit targets will result in:

error: bp cannot be used in =E2=80=98asm=E2=80=99 here

Please see how %ebp register is handled in
arch/x86/include/asm/vmware.h, vmware_hypercall_hb_out() and
vmware_hypercall_hb_in().

Uros.

