Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3476BCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 08:30:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C02F8E0013; Thu, 16 Oct 2025 04:30:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 770B48E0002; Thu, 16 Oct 2025 04:30:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F3C8E0013; Thu, 16 Oct 2025 04:30:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 54F448E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:30:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 09454578B7
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:30:04 +0000 (UTC)
X-FDA: 84003304728.02.CBD438A
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06648A0019
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:30:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=MRs8qKBK;
	spf=pass (imf15.hostedemail.com: domain of zong.li@sifive.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=zong.li@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760603402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3dZ3zNJcojA/sJlGgESgs39Z0uRLTeXYPBFHIy0pECs=;
	b=RE1ozu0f7u6HWfTQKgm3s8sK13JFTWWP78GdrdWlxyUv+VcruX0hdAtCF3sUW8KzJtTX2H
	093Cj+URW0A0KGHhWPzI0fa2nlmjf8e1QJmsMEuPuq/Swly3GOQqe3ANxwM90a1HZyK/d3
	u5PCtvxeP8NxSfC6rPh1xuH9mX/FXeI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=MRs8qKBK;
	spf=pass (imf15.hostedemail.com: domain of zong.li@sifive.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=zong.li@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760603402; a=rsa-sha256;
	cv=none;
	b=ve97qOn9jEdr9KNHBhENZaU4aw27JqAZbI9lZJmXMokqZLbI5vyAzNpm/lrLgcL/ipe7U5
	SScYpsOdpZF8heNVuGzpn7TbmzTW1gDGhSQY3GJ1nc5tgDnhP4d/P4QqeRs7N4dWgyWiNW
	Qmxt2niZdaeapoaITOj6aHPX68GJsng=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6399328ff1fso839157a12.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1760603400; x=1761208200; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dZ3zNJcojA/sJlGgESgs39Z0uRLTeXYPBFHIy0pECs=;
        b=MRs8qKBKTlv6bQ18ZQuI+1dS1ByemBVi0dBTba0DU6Qa93kXpnZVZA3Wi3qD4V++h1
         2TtvZCqYp5lvqseGFYCCVe4Z0o96VbwaGIFMmaxkVr6EU3P8sj0UEvhb+4KcbxtuOsaT
         iiUrikMLTJu0p3iwZ4rlaFOASdcIzEXN30hyaATMrcP/uzI3IdDi3+tEKcokm1d91Mgw
         tz0QlFqxvJBjXi1x8qY0c3YcVHUAWd+poQaUbKa0UoWUvyvJ+RwpM95W8Vj+KonJd/Fv
         RLY9c729pKRIkoq2NsGXzvYlDL4hY0p5U0Z2imsIDrIR8eoaakzKR3l/up2paomUQXcz
         pdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760603400; x=1761208200;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3dZ3zNJcojA/sJlGgESgs39Z0uRLTeXYPBFHIy0pECs=;
        b=TldEKUn7HsAlN+JWJc6yU1dmqQU8MB7EJX0iLRPmy6I5PMpLdOWHIVLI1MGdpfWR7l
         cY/3uqVeemnRCpaIR8aLmgHMz5oxOZRnrpYEQ4weynbEf/gx3OgPi5ZuBJhekJRWbaJD
         H4PpHQhixyprlTuUdSP6bK4fryStsiXejmcM6jV2JHjPniQWuHhL1At0Ge5YOdaK0SGl
         9rWtRk/lYPgwT0/Uit9mPt3s8t3Ps1zCP3c4RIYHU5yT9XG9n03f0QDfblVqMOnBzJxS
         PnzVlZBnArzPTfeMz7mzWFqGfV4bIgTVDQypjl4RWDPI1nn3iOVzEfw4VSu1nkN9rAUW
         c+5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmdGwly5iTkQQkoWS7kESaczMCbjX4ppUhD4s/pIgGLf7NthP4MeUF497e7TgYtgoNNRRnbRekaQ==@kvack.org
X-Gm-Message-State: AOJu0Yz74M35+QSKrArB9aOqmfpnAl4qZPdzz1l/GA8vUOxG0lwwERKx
	7DgP5NL3vHpZS+oNiE3zjTq3kHVprXQ7Sz3QgvLfixUzYH35W1gxLo42C6k3YcjUOzA+64zz1bl
	45HKIm44cdfiJVUtosoVirMIDNAv1OsiDfZ2TNUfkLg==
X-Gm-Gg: ASbGncv3nyH0w6+wKSvMA833c49vMHzclTOjtPYlS/w/+kDbTSBe9rT47KAXJjb9RB9
	VlL5jvhD1OvEJqTfmEznj/ypER7QNNqV6yVwpTwslruk3OeE0z0Jk0Tw3xhd4GG3Z8m+R4IwWQj
	9iqxtNsQeXRvD5Jzxb9Oos7x++SN/9A6aH2iLmFfUOe3MJzLq2yB5XQO8BZy5IqCPom3w4ezYpF
	66jkiAls2sGQ7kfVwt7ERlyJj4M6gPUW2sNG/bfwEZm1gAa1BzBIu0OO5kL2uFHOUzgiI1lbg==
X-Google-Smtp-Source: AGHT+IGyB7jwp1R/sb2SSrLIrlHDUB3Rfhzku7rZfdn97lwiX7fw79YoDZXn2zqSu6ScM4J5e0VHXW4a+hMbV7/+6J0=
X-Received: by 2002:a05:6402:35d2:b0:63b:dff7:8956 with SMTP id
 4fb4d7f45d1cf-63bdff78c26mr7390999a12.7.1760603400109; Thu, 16 Oct 2025
 01:30:00 -0700 (PDT)
MIME-Version: 1.0
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com> <20251015-v5_user_cfi_series-v21-25-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-25-6a07856e90e7@rivosinc.com>
From: Zong Li <zong.li@sifive.com>
Date: Thu, 16 Oct 2025 16:29:48 +0800
X-Gm-Features: AS18NWC3gX9SfykK7BeQoaaUJU9Tso-y_BcITA4tZMgogw7A7IijvQhu4Ma2nRQ
Message-ID: <CANXhq0qHT=nnwG3SX3s_D3G2QqKGmQBbdzFwiQ5MMkimxCHJHQ@mail.gmail.com>
Subject: Re: [PATCH v21 25/28] riscv: create a config for shadow stack and
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
X-Stat-Signature: 8esrujx4k7sygreexhhf6kpz4t5oxndj
X-Rspamd-Queue-Id: 06648A0019
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760603401-384212
X-HE-Meta: U2FsdGVkX18sn5H0XhAqILKgzPjto0aNDV2G+/4HJmI99IwNuLnG2TfWQe+h/x2GXN7pt9vuTcT8IUdIFBqAkpEvlC6B5Jq7hLaYKOYo1R8DSjjIsEVvz4+9k9PzrLidsqUQtt0jbw2WgAj6oSV7PJZxnxBhw5p0Kaewh0XjgE2hufrpEjpaL/yToMkfDQW78c/H1iIsNy2sRgxWRLIrlzu9Ql21Brd14+x91JIrEUmLiM4WjgSbL4I/XmbsRt4jg7aVb4xzplZ0cHTRX9xYek7y2noC1CaFVfqlBeCeJHq2AyPALYH3QzBOe1xnyQ/G0ClTzYV4y2SdxB36sq/gZ9Ft8tOn6/rG51XNBDertCyYJIWu6a+1tGKdny/fuusHVMBgzMBPlYd9nXBuY8MpSMdkl2xsnxULVOs9/NMoYGNGL5iCOtFFwFbVENakJA6/HkFOvByPy77IjWRPzA6fY4cZV1Kw95QlYcUR9fQrADJTO0Ppfx3CXyzWk/s1zQbVYkbYo5vQwboWsTuNIsRclDV46cRJ+Hp4me0Sqgt79cH2BXYHwyCHlUSmiqOGvtwtAYeYuwZlIsOGOvyYlXK2+oEdXPBOt5GbP3+eoAcjgbcIFgkOYB2s5aM7cSED/TREeQvytMgGty0ewq/4ZTjN5Ebk8tna7W02iYHyNyDkZgBAFezPFV1NzY+Hng3kWON751hBGu4lyu9Bq3mgp1v17gr+eZjptG3yUUkjYv599Utr4lRxLlIbHfnoUu8o0U4FASpZMkXt5qPVr8xjR+hLXAbuUnB4mSOrRnzfN1xlznXaDZMxhebIlBXPSMLrGUtJr72V831IcDlmC7I5Dp2N373oqQf7e5M26R6OOW+S0UBJNUY8w7GDjMlw7GyC6pN1nRxoLmzvWyPnxvSUT0Lll8lHX+C9VWBt1bXp45TXGo+z+yULh+kl5KvzVR3sLXnnRyPkNjkWoFu+mqJznrR
 4yRj8HT0
 JRz7NrvSYqzTMfS+qfvFMxALJPu/icICCxXw6TpS2arW0Elu3r0XVUyT73nHkQUP0ytYoGAB5fDgo15qZdj4XnzEQVaKa/yGdA8gY3wIymJJMWBEG1rbcwKI8izR9YA0nEDk1+Z2VxlKaVvXxwib3v666DlCNCahJa0SvQF5G6zQzeP4g6bSyqvXDWaMaIT/eWOLo7bjzAvUAN4FT2WmIxurY5SVDjwFFpVtGuQRHJt8WipML6uz/EZQn7AtVZigC4H/N3GH2tKVLh3b0sXdTvWpRAGvwl2LeDt0STpr7+5bPilCcNRk9dSjlD/k03FNoGb2yCWVlVULDDWcJX042I485fLAWqFIJy7Om2KwjBAmgFZXHu4a7Fe4b2WW3t/UNQIK8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 2:14=E2=80=AFAM Deepak Gupta <debug@rivosinc.com> w=
rote:
>
> This patch creates a config for shadow stack support and landing pad inst=
r
> support. Shadow stack support and landing instr support can be enabled by
> selecting `CONFIG_RISCV_USER_CFI`. Selecting `CONFIG_RISCV_USER_CFI` wire=
s
> up path to enumerate CPU support and if cpu support exists, kernel will
> support cpu assisted user mode cfi.
>
> If CONFIG_RISCV_USER_CFI is selected, select `ARCH_USES_HIGH_VMA_FLAGS`,
> `ARCH_HAS_USER_SHADOW_STACK` and DYNAMIC_SIGFRAME for riscv.
>
> Reviewed-by: Zong Li <zong.li@sifive.com>
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  arch/riscv/Kconfig                  | 21 +++++++++++++++++++++
>  arch/riscv/configs/hardening.config |  4 ++++
>  2 files changed, 25 insertions(+)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 0c6038dc5dfd..aed033e2b526 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -1146,6 +1146,27 @@ config RANDOMIZE_BASE
>
>            If unsure, say N.
>
> +config RISCV_USER_CFI
> +       def_bool y
> +       bool "riscv userspace control flow integrity"
> +       depends on 64BIT && $(cc-option,-mabi=3Dlp64 -march=3Drv64ima_zic=
fiss)
> +       depends on RISCV_ALTERNATIVE
> +       select RISCV_SBI
> +       select ARCH_HAS_USER_SHADOW_STACK
> +       select ARCH_USES_HIGH_VMA_FLAGS
> +       select DYNAMIC_SIGFRAME
> +       help
> +         Provides CPU assisted control flow integrity to userspace tasks=
.
> +         Control flow integrity is provided by implementing shadow stack=
 for
> +         backward edge and indirect branch tracking for forward edge in =
program.
> +         Shadow stack protection is a hardware feature that detects func=
tion
> +         return address corruption. This helps mitigate ROP attacks.
> +         Indirect branch tracking enforces that all indirect branches mu=
st land
> +         on a landing pad instruction else CPU will fault. This mitigate=
s against
> +         JOP / COP attacks. Applications must be enabled to use it, and =
old user-
> +         space does not get protection "for free".
> +         default n.

Maybe it is default 'y' instead of 'n'

> +
>  endmenu # "Kernel features"
>
>  menu "Boot options"
> diff --git a/arch/riscv/configs/hardening.config b/arch/riscv/configs/har=
dening.config
> new file mode 100644
> index 000000000000..089f4cee82f4
> --- /dev/null
> +++ b/arch/riscv/configs/hardening.config
> @@ -0,0 +1,4 @@
> +# RISCV specific kernel hardening options
> +
> +# Enable control flow integrity support for usermode.
> +CONFIG_RISCV_USER_CFI=3Dy
>
> --
> 2.43.0
>

