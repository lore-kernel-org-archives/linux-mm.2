Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49F4CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 05:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC5F8E000A; Tue, 11 Nov 2025 00:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB4668E0002; Tue, 11 Nov 2025 00:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2ED8E000A; Tue, 11 Nov 2025 00:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCB28E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 00:59:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FA4913ACCB
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:59:02 +0000 (UTC)
X-FDA: 84097272924.10.749D960
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 12F0A14000E
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:58:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Tb4kW8Lr;
	spf=pass (imf09.hostedemail.com: domain of zong.li@sifive.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=zong.li@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762840740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IN4rRfnCOfr9RMuoqowEQ8Wlb2hMDvz+fZbNk629L0=;
	b=FYI6ULlZ4VRTZj2eZ7DC3EpCu/iv8G4oatIKw0pIYfUUqHYHHXpRZHs6SaBrhBfU9XjTQ0
	iQB3gHYm5JojC/6p7lvcXsBOguD2BtZXGZp8kjlHsxb/uMv1hh0Zpboek+mFLF+KxAzapP
	nvWY81s1Vnxg70TqfVRCqWOgjgLNROY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762840740; a=rsa-sha256;
	cv=none;
	b=xGZ0Gd1ZqfcQyDBUnzu52xmQhh/2DYYayUjOKarMVO1dOog4o7IunvgSC1MGYIQmGojwNY
	LTBO+c4gn8J7UVcdAi9gmr8WI+pV8iXCxHaqBqJdO70vaGT2FDUFDuile8nJUIJ41HIex/
	z+3DEPlNT8loDLYNb0IPN84LwFknyvo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=Tb4kW8Lr;
	spf=pass (imf09.hostedemail.com: domain of zong.li@sifive.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=zong.li@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so5691112a12.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 21:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762840738; x=1763445538; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4IN4rRfnCOfr9RMuoqowEQ8Wlb2hMDvz+fZbNk629L0=;
        b=Tb4kW8LrijPpgWIXrVTg+It6qFi1rmoJVmpDGQJAkhjfHoAeqowBUvnQZPw2eJPbUC
         x2eye8dhW0WTz6rnQhjjr0ViYjyaa/xpzyHE59jPRFtqAPxHJSKiiKN1mBwGWwvrChn1
         OpNiPb5uNXr4amSEsD9T5hRY9cxMnRi6oLVndIwrVhpCq+9+i/qWbEBlVOgHdGZRfuZL
         DgKKQMlT6Wbsjus1d917n0h4SG1X4GT4He1efv4EQ+PzkY07WGmheR3M6WdlVkzqiU/K
         8fyQXVXqqyJTqIwYcDbtdj8Elg0QnSkFEVt3aCqPnpKwmbjFObLOUBAFGdaNElaS2N7t
         B7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762840738; x=1763445538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4IN4rRfnCOfr9RMuoqowEQ8Wlb2hMDvz+fZbNk629L0=;
        b=UydQGJCilPNQAK5ncqAMVgGhDCAL5r0pRdbptRTI2XSY7wl20rGGUQWdo3zh3iNOtO
         femLTlvc0be95Eg5OiGG0opLAs1aH4kE19WubrybVnEPjU6uKsFJDQdt0hzOh8EuWc0K
         bjnboGtdmt7gsYk83tvVoAbVDHaKr5njIGsNPa7UGiZPwd/P59zx22abPjTqZXb2Ra4x
         QYuTC2AeG1m+4cy8L2TEnHNAqfktQyGTvwgjqHHBqAo1lOzrrMyj3MdNyikDz57BEdm2
         KMZzroASU/J6vXUNhHB4zHu0lAFIP2mQezITIjn7dsuIIjZv6GlX2Ha15Ldns81piEfB
         XVAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuXtZ1kRI7G+38FRwZ68fInHG3t5A5LyaJ4tJ8SdrClCHGXhs8NaNHuhLEV/qwISnEowE8fryNcw==@kvack.org
X-Gm-Message-State: AOJu0Yz6wOvEyItbEg6WmC3W3pFyqzJohnX2r2XMLJezUz3Wk0nfjTbG
	o4zOHXyFqMuAA4FS7UvZzq2z8MSkAOa266WFxIRzI6AnAlMY3gtPNJgL2ZbDo+IfOAfjzjzfhU3
	cWMBKlBFirQ55k3VHjiXKVw53rdw5zgCr2Cg8irDL+Q==
X-Gm-Gg: ASbGncuTeur8gIuq+QRIodQ93aUFuenSAPDGfJ4vR7mVyt8MDi0u2g61QV7hgz+2fg8
	415+xKZ5uY4vFw9j9NmmbXbg/QoOBvEtZZbUzTnaCXfBS9LdXlcdugNGKjBN3WUVUxbnTIkndK/
	ZrovRLi+3Lw2yXLGs0LW6mcmVmbqpnZhN1mwe6E8ySzaES22SDhITQlCk30+PVrPUg60eZKnxSl
	HQVgwhK0sP+hVXSBJ85X8SEdmKfox9TRoKTlViHT9yPgDvRp1pLsITwqJWX3txbbaOsUd9zog==
X-Google-Smtp-Source: AGHT+IHHZP/aE/tVJZyLz+gOc0YU9Sc0i9PZJYzJ42dLOfI9Sr7WDBO2F0DsSawtvDJdjI2jksVRQSbzge+KnP9adhY=
X-Received: by 2002:a17:907:1c21:b0:b70:a9fd:1170 with SMTP id
 a640c23a62f3a-b72e05725a4mr966508366b.65.1762840728609; Mon, 10 Nov 2025
 21:58:48 -0800 (PST)
MIME-Version: 1.0
References: <20251023-v5_user_cfi_series-v22-0-1935270f7636@rivosinc.com> <20251023-v5_user_cfi_series-v22-25-1935270f7636@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-25-1935270f7636@rivosinc.com>
From: Zong Li <zong.li@sifive.com>
Date: Tue, 11 Nov 2025 13:58:37 +0800
X-Gm-Features: AWmQ_bmwbidNFRD3Ln7UsJWJk61pCiG6pfhUPXDjXSV4C1IEKiwyDYyiO7oQK-g
Message-ID: <CANXhq0oEpCow0G+KsJ6ZPuwsxmAFVqoKGEzygiwSmxFsmntiWg@mail.gmail.com>
Subject: Re: [PATCH v22 25/28] riscv: create a config for shadow stack and
 landing pad instr support
To: debug@rivosinc.com
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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 12F0A14000E
X-Stat-Signature: 143frzakihhrjcnkqart37nfo94o56uh
X-HE-Tag: 1762840739-242213
X-HE-Meta: U2FsdGVkX1+QmMVoR/8vvfeRcWFGNtvbKRuVlFNum8HcSYH29SAXLmOcHCoO/5P83o0/V1Gj+xzRINMCmbUvn0Kp4tyDIB4ZP6gB5kUCj/OfMjxFcvmTqcpn5QXKde5koH9EvrnzDR9NvW1rNqWSRJkR3qQ0xisGsNQIwknkGSCCbJHJReIM7psaJuObzFO79VluPGdhBYCHESAZzjfv+HVNrrj6vBsZmmPkTOK5MatX2Mu9f6o6Rvx6+jm1SBe1ZGcNqDlyjGeFI6RthfWUH4k1hPGdGp0oCPjj2cctAiUnGTSdvjzUTWj+LcCXzKYEyIEzi3lGNm2Qy26GYnqKtnKAVszgGhyObbaDLPg7+qRQvvB99e47y6UqWHjHzkQJnL3U7guMuhDNg1meaAQkCxBoklPb37QZ6TVNIZWdUvJ/n/g7RTzm3hviJOsrJ0C8GpZ/E7AtTwIBMg9ByCduq0LUoAi488dQx1jMsYvxMw9+Xprom//CP5GivOIs2GXiQ2YmHXCmWbHRwcoX4zT/hjnsCiKw5z5yg7kToTAtlN/6TxZvnf9Cgd0/7xevmxi5HYlIwtEorLvQYMPz5hJXSg6cbzMU4jDCOBgYP2sjSG7BFcyOOoIDD1K7JLlio/Dque1oU5Mh3200z+A1LddMTAf1wz9lhkM7b1C7xtF1KBOLTPcNSLTvPPqIOrHF6iMznWoIiYWGRI823J9iiinBs0eUUzjDnfoIwLLP/OxU71l5zsDlG8EZ14oGkqqapVuVN7wk5v6HOcRSrzuErPo02mr//PbHfCHupSCx0FxybicH4wyaOD9eF9SqmcZT1hc52CoHD/fl9FD3mlYQSe9kFJMbFKYZXeCz8DqeOS3Jf2B3yGPRUda3ar4Nrr+m9em79hNtXzA7g2/ultRUVbW9Sjnhk89yls/LrjiTt6lI37mjKOn1VUyE8MpZqyKBGGjr6p+JAd3+rGKpm4707Ao
 okguDbMB
 veMddcL3oTPZEWX2d1w+QaOa/e05DBmTOyY25vLcHgyCIz6EfER2ZFDpPIhbpZ5N2wWt0oTwkbWXo+BtKXjeduzz477qLP/vj55LNQT3clGCWpa41KqRTKSMKb9hvekjdSY9V2NfLdeKuiBq1JWk5GesNhD6q14u7gDKEJ88gmuOn4Y4vPt3v902Y99x6qxOwGkh2ln7bW0MUf9D2tWEs9fCpEChqwNHZ5WDxkvJO0lG/3lAsTVUNr3WZDprf5OijxRfy8DDNnjY0xyAW+D92DzVMU0eIBp/bA0JlFfuL/YpZtF3/+odGRSXa47G1bB8b0kbb0Hpukn9GN9oe9CEHLmY/dg/UJfop2lncdiZc07MN17wMnMgltkqSATL6pGigK+/AXtDgZjSD84cthmmyo3wqUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 12:51=E2=80=AFAM Deepak Gupta via B4 Relay
<devnull+debug.rivosinc.com@kernel.org> wrote:
>
> From: Deepak Gupta <debug@rivosinc.com>
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
>  arch/riscv/Kconfig                  | 22 ++++++++++++++++++++++
>  arch/riscv/configs/hardening.config |  4 ++++
>  2 files changed, 26 insertions(+)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 0c6038dc5dfd..4f9f9358e6e3 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -1146,6 +1146,28 @@ config RANDOMIZE_BASE
>
>            If unsure, say N.
>
> +config RISCV_USER_CFI
> +       def_bool y
> +       bool "riscv userspace control flow integrity"
> +       depends on 64BIT && $(cc-option,-mabi=3Dlp64 -march=3Drv64ima_zic=
fiss) && \
> +                           $(cc-option,-fcf-protection=3Dfull)

Hi Deepak,
I noticed that you added a $(cc-option,-fcf-protection=3Dfull) check in
this version. I think this check will fail by a cc1 warning when using
a newer toolchain, because -fcf-protection cannot be used alone, it
must be specified together with the appropriate -march option.
For example:
  1. -fcf-protection=3Dbranch requires -march=3D..._zicfilp
  2. -fcf-protection=3Dreturn requires -march=3D..._zicfiss
  3. -fcf-protection=3Dfull requires -march=3D..._zicfilp_zicfiss


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
> +         default y.
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
>

