Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E38ACCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA75B8E0007; Tue, 11 Nov 2025 21:19:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7F088E0003; Tue, 11 Nov 2025 21:19:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95018E0007; Tue, 11 Nov 2025 21:19:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 95EAF8E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:19:39 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 665BA4BEA5
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:19:39 +0000 (UTC)
X-FDA: 84100348878.22.3ACD5E4
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6BB0BA000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:19:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=e7m18XJy;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf25.hostedemail.com: domain of zong.li@sifive.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=zong.li@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762913977; a=rsa-sha256;
	cv=none;
	b=2jQo+UkLOWTNLkrsIonpaH4VTo9IcZi8p6Wxh24s29+U947LlHVG5xMiZUSw9NJyCw/DGo
	siogEFTn75MET442oNOq+vqtPJdDF4ef63a10VeiADS9SOYUf0g2PP/g63XOfvz3IRvIkW
	yHW9Ag+3yPDf16p6amgDHcvbLgPCU4s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=e7m18XJy;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf25.hostedemail.com: domain of zong.li@sifive.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=zong.li@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762913977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugAQKBkBrsHecB9x8Cs9RwnH0DI2WGTlcIm1Ae1jyr0=;
	b=gyg06720qDJxCs0Wk5sUqJhQ9ig2kil8dDW5QV95VvNE2U2HCXO52O1XOPBYbyHkgZy8ci
	ZMdSG9E62G6K2FgD1KE+j6PlLw3MFOjXBb9KcqlzQy1VbNceKLBLextUkvEM1I5IMpMAaF
	9hAUTSPCtLb5fL73Kgkc5DVuUyANVg8=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b72bf7e703fso67155566b.2
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762913976; x=1763518776; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugAQKBkBrsHecB9x8Cs9RwnH0DI2WGTlcIm1Ae1jyr0=;
        b=e7m18XJy8sRsE7L/TLMBWYoQEhnDbxXGkM7v+ZLtS9KbHwHdFBs+NuSalWS/ogjEko
         n36mQNTxs75r04KRlzNPtfcHv8uV3an6kgCOX/HK34Cl2pYZK4QAj63RrWLL9dTjFypJ
         aVFqIAwrvOx8/BlSWJrFwAbshP1/JcOosjpaa53kxkO3Pg5xZHzLyErv6uiXQOu8PyiA
         66FaAu3Y0lI3VNjWEO6WCa9Vz2xYnj2CkT0jjyJJYJKit2D4KuxFbiev3TydFIBJ999L
         nq0vghE/pyYPvg+HVmZ4Qlu8/z2YCAfcjp0QGkLFg6O14JErBG+siez7p44UYWKTMLSq
         nGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762913976; x=1763518776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ugAQKBkBrsHecB9x8Cs9RwnH0DI2WGTlcIm1Ae1jyr0=;
        b=bLojcrS1XY24jFAZAVMvp/OvYhWrF3b7xpNKOzoSuZlBcPk+iUOYO/h1lTJ4gVEJYY
         PBf+kxDrA/vMT6cmkR6tf3YrU5ObNLJXusJu6q01ZBdL9vkai31uPBEP1DPZNHeJ+YDi
         OGFj+rRow88ncIqGF3GoGqOgFtqk2o5VbldvGOaL+Jta3H0usBzVSWaG9OvQ1tToa8Yh
         7VUZ1cyVVJROONJC7cChLOUoelKrvUjG7DzuwzNgAEFbrp3tGGxiIu2qOphSRMAzRjeb
         J1HV55TSWmsM82KMv31SS4+kPxUHsPTCr74Kv60o5k/fQBfQvtxL9XwsHLTW8031+C86
         OlSg==
X-Forwarded-Encrypted: i=1; AJvYcCXadjvOF+9SH85tq1kmzJ9DXoAmmuVo8QCnkybdyu0dyHUBVEKuRqgm97YDTqFXwnc7UZxLZP8wdg==@kvack.org
X-Gm-Message-State: AOJu0Yx4Ale/VIGYN1Y2lh9NyXBFnZ4AGi+EJA0nVLkV8scHzuXe6KIH
	a21HUCM/nbs+Z3cmDtbd2THp5m7rF5JzFtg93a7aM95EBurin1yDYPCDhEZKJP3W5eBJLAmC8DT
	F/hWOyFbxQy0Y2UmecXxZzdhFOLK3RCKzAnFHMmze6g==
X-Gm-Gg: ASbGnctmW6VkO9aR4oQwH6cyLZRy887yHBMUhcjjP0HI9QNZn5k2OAmbFie+w69HxIW
	bIatX1ExlMaBg+rVDWzgjP/xZAYXHDwKQalswAJfFL6ekXBrM0QQsQVpkgXeSBtbhmXB8jHRLmw
	/V14GG6uMipPXo0WcnX+AzvMCU+FuqJhj53HXlTUr3ASLHMoMByMQ1qInmuGs2NvYdI3PT6Mfn8
	x5wS+aG/7f4hmZegG+UJOal+oXwCzAlDkEi35a6kLi/CNcmO8x/TJ2iFAPiOC4=
X-Google-Smtp-Source: AGHT+IE+yEBTlwHkenGiGwu5UyXnAf6gT3RkSyNE+10D+a3qX/UN5XaT1J5EAZetmYd9Vh7p3GgyT6IZWxgqCbtm2x0=
X-Received: by 2002:a17:907:3daa:b0:b72:52c2:b8ca with SMTP id
 a640c23a62f3a-b7331aec193mr102047266b.59.1762913975653; Tue, 11 Nov 2025
 18:19:35 -0800 (PST)
MIME-Version: 1.0
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com>
 <20251023-v5_user_cfi_series-v22-25-1935270f7636@rivosinc.com>
 <CANXhq0oEpCow0G+KsJ6ZPuwsxmAFVqoKGEzygiwSmxFsmntiWg@mail.gmail.com> <aRN-0Z9MNeJ9IZf2@debug.ba.rivosinc.com>
In-Reply-To: <aRN-0Z9MNeJ9IZf2@debug.ba.rivosinc.com>
From: Zong Li <zong.li@sifive.com>
Date: Wed, 12 Nov 2025 10:19:23 +0800
X-Gm-Features: AWmQ_bmKovRTmE80-MSruF1BPvDQmZ8Z-ahD6_kAC3IOhiFoglBht7EGrzIY3bI
Message-ID: <CANXhq0ryrNUoBvACX9hh-=FVOe+L6_6beXrZQn2e1P6eWgcUiA@mail.gmail.com>
Subject: Re: [PATCH v22 25/28] riscv: create a config for shadow stack and
 landing pad instr support
To: Deepak Gupta <debug@rivosinc.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, 
	Conor Dooley <conor+dt@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, 
	Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, alistair.francis@wdc.com, 
	richard.henderson@linaro.org, jim.shu@sifive.com, andybnac@gmail.com, 
	kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
	evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
	samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6BB0BA000B
X-Stat-Signature: 3ksnm6d8ycnszdaw8t6d7gdy7ud4eumf
X-HE-Tag: 1762913977-222701
X-HE-Meta: U2FsdGVkX1+2Zpn21UDvOarK4TvrIPAGzJ66Z5NHxf4m8om9LFtslJRKFX0eEbZuA67z19N+e+4Tn/qmeGl1LDkwUPqtZsWrl9T8zKHTRK/+L2cCAG5sAi9dZDovqmjFkG0Bq4hOA/0vLZSpS35Zbtr4OPoaQ07TETGHdHsJlmrgvgM2dn7sSb1pp6xsqnLj3YnZ2QzYhdSCWsg5+vPrqQrpX5Ps85BkJnOEaiIiYBILiJGwCuxmK1QrXMNXxMveMZdWl/so3OTAM+lHdoKPpirTYQOVSamWTFojKlAAmrp0tfsvw5/Hh6ZeRbbMNVbZQWwGYG8mP2KQQXKJhLTe/I6MwwmnAxBQrUyHeuc0pvTkbaAzw3eUll+PmcQdgp06ijFmOFlMj3ks76p9pjX2VMpNhw77HJi+JGABxD8g6RRnNs/BmieRdWJSHJ7XEG9jryeIK2B2Bd0O+3naJUTa1a9dr899UPBHwnM7qSXY0xLxTlOpye8MJ8LLz6KBOSm0qBMs0Q4rH8GhvsNTNDNoaFo2CqRRv217GvA6L4PHUuWBeHT63hziEazR+Hy3KgNKf6M8hoC/MajbsrIJ/9Bf/VPP9scUmvc1Hir1GP7yzE1qWQMLGk9nIu5s2YbKRI6VXGrdr78BsRyP+LByLk8NvuXdw63SFtpHJ+ymMRx6ULtqfU7Sv1HX/yQf+3HQ42kCkoX5ejA4LXppp1G/rTqtQSgouWHMvYpXSzvCABh1274lrmz7zLs7FccF6ddgsHOWK3V0nbtc+rXs8yy8o0oiT7rVTC4aAIXcVKZZQRKC91fIcLo/HBHof3tpaZsVSh99oo+taQE0d8Nm3WnFyVJnsJrb241Da82d+LqnNCnBZpbGi4ZGJQ4vSPOxQ/lO2JWIZQvztXatd1OwbykkBS+iNkl+9Bq/sR8QtjhGYXHIBeJ5E9kgna9t4g2K9Vy2v/Y+kn4E02vh9p+B3Fq5YeY
 HxF9kVq8
 2RjhcyjNY20i7/jl8R3DbVRRbf536ZPbn0TkTE8rJYd0FVqUypCRRGilHNM6CBjnfDP5tvbeaXizYjLuXH0BfcfiOvOasrKf13md9kTcwnnFZ0xGQ6/8bHIdgk/g1xnhxTGEZkuoEzCW31mgDVcaW8yZv7dUcVhAgSBeXojJh/yy0hwyVzbZvDZz/hTR66yGRt1It3tNl+kCzguBDmZE8TGLW0SzDwVyK2kP6rWvz9FD6GiE6D/jD5KTXPLiMb9mcyY7/8inUlSQuhfixB7fqNn4AF2oWYx/IsUpr03ATlaipsryIqRmAsEoLLsW8IZljwbFJxS5YAniv0m7jYyBoq+y1HvJyOt8xX1vC71n6xtreI3/ewYreg2VTkYo70T2z1Ez5ZuLHiBHM1eX3EzHaQqeTpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 2:22=E2=80=AFAM Deepak Gupta <debug@rivosinc.com> w=
rote:
>
> On Tue, Nov 11, 2025 at 01:58:37PM +0800, Zong Li wrote:
> >On Fri, Oct 24, 2025 at 12:51=E2=80=AFAM Deepak Gupta via B4 Relay
> ><devnull+debug.rivosinc.com@kernel.org> wrote:
> >>
> >> From: Deepak Gupta <debug@rivosinc.com>
> >>
> >> This patch creates a config for shadow stack support and landing pad i=
nstr
> >> support. Shadow stack support and landing instr support can be enabled=
 by
> >> selecting `CONFIG_RISCV_USER_CFI`. Selecting `CONFIG_RISCV_USER_CFI` w=
ires
> >> up path to enumerate CPU support and if cpu support exists, kernel wil=
l
> >> support cpu assisted user mode cfi.
> >>
> >> If CONFIG_RISCV_USER_CFI is selected, select `ARCH_USES_HIGH_VMA_FLAGS=
`,
> >> `ARCH_HAS_USER_SHADOW_STACK` and DYNAMIC_SIGFRAME for riscv.
> >>
> >> Reviewed-by: Zong Li <zong.li@sifive.com>
> >> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> >> ---
> >>  arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
> >>  arch/riscv/configs/hardening.config |  4 ++++
> >>  2 files changed, 26 insertions(+)
> >>
> >> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> >> index 0c6038dc5dfd..4f9f9358e6e3 100644
> >> --- a/arch/riscv/Kconfig
> >> +++ b/arch/riscv/Kconfig
> >> @@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
> >>
> >>            If unsure, say N.
> >>
> >> +config RISCV_USER_CFI
> >> +       def_bool y
> >> +       bool "riscv userspace control flow integrity"
> >> +       depends on 64BIT && $(cc-option,-mabi=3Dlp64 -march=3Drv64ima_=
zicfiss) && \
> >> +                           $(cc-option,-fcf-protection=3Dfull)
> >
> >Hi Deepak,
> >I noticed that you added a $(cc-option,-fcf-protection=3Dfull) check in
> >this version. I think this check will fail by a cc1 warning when using
> >a newer toolchain, because -fcf-protection cannot be used alone, it
> >must be specified together with the appropriate -march option.
> >For example:
> >  1. -fcf-protection=3Dbranch requires -march=3D..._zicfilp
> >  2. -fcf-protection=3Dreturn requires -march=3D..._zicfiss
> >  3. -fcf-protection=3Dfull requires -march=3D..._zicfilp_zicfiss
>
> toolchain that I have from June doesn't require -march=3D..._zicfilp_zicf=
iss
> for -fcf-protection=3Dfull. If that has changed, I think this will need a
> revision.

Yes, that=E2=80=99s what I=E2=80=99ve learned from the toolchain guys so fa=
r, perhaps
we can double check with them. If it is right, I guess we might merge
them into one check as follows:
$(cc-option,-mabi=3Dlp64 -march=3Drv64ima_zicfilp_zicfiss -fcf-protection=
=3Dfull)
or
$(cc-option,-mabi=3Dlp64 -march=3Drv64ima_zicfiss -fcf-protection=3Dreturn)

>
> >
> >
> >> +       depends on RISCV_ALTERNATIVE
> >> +       select RISCV_SBI
> >> +       select ARCH_HAS_USER_SHADOW_STACK
> >> +       select ARCH_USES_HIGH_VMA_FLAGS
> >> +       select DYNAMIC_SIGFRAME
> >> +       help
> >> +         Provides CPU assisted control flow integrity to userspace ta=
sks.
> >> +         Control flow integrity is provided by implementing shadow st=
ack for
> >> +         backward edge and indirect branch tracking for forward edge =
in program.
> >> +         Shadow stack protection is a hardware feature that detects f=
unction
> >> +         return address corruption. This helps mitigate ROP attacks.
> >> +         Indirect branch tracking enforces that all indirect branches=
 must land
> >> +         on a landing pad instruction else CPU will fault. This mitig=
ates against
> >> +         JOP / COP attacks. Applications must be enabled to use it, a=
nd old user-
> >> +         space does not get protection "for free".
> >> +         default y.
> >> +
> >>  endmenu # "Kernel features"
> >>
> >>  menu "Boot options"
> >> diff --git a/arch/riscv/configs/hardening.config b/arch/riscv/configs/=
hardening.config
> >> new file mode 100644
> >> index 000000000000..089f4cee82f4
> >> --- /dev/null
> >> +++ b/arch/riscv/configs/hardening.config
> >> @@ -0,0 +1,4 @@
> >> +# RISCV specific kernel hardening options
> >> +
> >> +# Enable control flow integrity support for usermode.
> >> +CONFIG_RISCV_USER_CFI=3Dy
> >>
> >> --
> >> 2.43.0
> >>
> >>

