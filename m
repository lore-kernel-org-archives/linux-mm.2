Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D84C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 11:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C89C6B0089; Fri, 25 Jul 2025 07:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0876B008A; Fri, 25 Jul 2025 07:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6EF6B008C; Fri, 25 Jul 2025 07:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2956B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:26:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 107C81606D5
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:26:56 +0000 (UTC)
X-FDA: 83702560032.26.556D18A
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf18.hostedemail.com (Postfix) with ESMTP id AAD2B1C000B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:26:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b="ZmS/G6NE";
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf18.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753442814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9lBchv8Xl3/zU+kUSWuOOJSWBoJGBapA/sirJQnK+E=;
	b=ILZi4ZV5WiEcZcxMjqHHp72nz9PkXcjx5jKu/cZNVUoH6eN1bcnnCqgDcpyT1p/Y2zFP9N
	VrQUvWagiWasI17ukV76gdRsVn/duvZHSuxpKUku4wTnPkTmkuZG28IkMc3+Ney6BhHsTW
	l/gga3qURraDhYmlstntY4DbgwXt1U0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753442814; a=rsa-sha256;
	cv=none;
	b=yZwVwMOgcFrYmrszJguJQyJwrQ+3tEcKz/dPZqXNWIhAtH0BI/+C+WLAkTBz2DzMRonoWA
	fQeTX+/V6wb6SwTwY5Hcjl0UYaLelCqKAGKpWn4Lz7Fex44blGNcx9iO40lYVIHclf7wyx
	BjRW59lCYyBV8bD7qHa8OAFL3Dk0xEU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20210705 header.b="ZmS/G6NE";
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf18.hostedemail.com: domain of heinrich.schuchardt@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=heinrich.schuchardt@canonical.com
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 5F1863F858
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1753442811;
	bh=/9lBchv8Xl3/zU+kUSWuOOJSWBoJGBapA/sirJQnK+E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type;
	b=ZmS/G6NE0qUg1V957DIYHb7IGJZEnMQt8O5YlwNVfbu8mGAW2vaIXz5JZLQDIA6+I
	 JEQcvxKF/yUkk5/QpVZRSADffJoYFlOQGfDZUMtnHnQ/6H3H6b8tKOCJhTpDzUUjdh
	 N5XZ77wxToegPxk3wDL3/N8shtJUJ/97mUlkJ4GtvA9Qgg6ovWS02h4IWTB/a3JHOF
	 8SoWlEjZSMCum0T8dhS9wrL7mgPK8812Y665h6hy+LlmmkqBUX8aVv9laTt+qVI/tH
	 OQOof1wyf/7VQhECjYZVj8p7xbDEaQp9Lve1ijikMcsjaTUyWo9AaD8Hn/Sd0eDQz4
	 0tw0gBJb+LV4w==
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-ae3c5ca46f2so159139966b.2
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:26:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753442809; x=1754047609;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/9lBchv8Xl3/zU+kUSWuOOJSWBoJGBapA/sirJQnK+E=;
        b=lmNXSKnYIb8rVoxTdocyj2AizbP0gs3VpPLuPkCFz9TgDXV2mh2/Ksay+l/FpaRxDk
         iIn/Kw2mOjU/y5hHy68+4OMCgiZNto10wj4N5kuxzopk8+DAGuc/CLvtPFc7kzEqDZ/B
         RokqfontAdR9O001EKiFzW6cScJQK9FgCD2YgUzak6Fym+CeoDe94BMWI+B9VZh8vYNY
         TMEYWbFa38ei1LWvHnsUjU2PSxMTGt0mEN5ufDf7cl6keiqlHXE9uVngezjCu1uoTQH1
         0Gs80k3501pD8iUxWh2ihbGrhzCPK8luA2W0pW2/vh12CFf5Azbmb5a1RkW2Qg202Pnq
         ArRg==
X-Forwarded-Encrypted: i=1; AJvYcCXwxz2XRvI8kSIkIPsv7b/ERmaqHmPm4c8V4DHvITgESJ68YvMUGeaqhn3iKWle4ihBfJNgjMTvdQ==@kvack.org
X-Gm-Message-State: AOJu0YwdoPVs4ozIfSxlYp8kLa+yhSFS04gYmEutIgzICKxuUjIAiRWu
	PW1LUAIF8gxMAwd9/3b97XApK+7qLt5QtWXBgASd/yZYY1UNz7vNC6d8si+Yv5Gne0V3IAtIHJ0
	o9fDkzJNVL7JGcTXa0FVFPN3jL7l4ZvZmdaD8VdQe13U6FlZa0/bfF+94ZGtiCbCnHjMA
X-Gm-Gg: ASbGncsEeUsf2WsqfT5f9kZkBBQpWm2AEFX+nPJfoUDODtniiSgeXN+e6E+9hBsW4Ml
	SoRHR5Ev5mCkpGzqjT3/7x9eT+R0IOledOvisMaYrhSNPiTipbgoLrLKFeAKss5nyDqUKUylHCw
	ejhVOOnhgb0OfDFwGK5F9pKR7JRQvLAfs1g4BlDHCKjzuLZmgv7WjvbL9i3oL7AQEqJSxfA2eUJ
	NsCfFkrClLXiDHZaBMoSKFXmQnyE9lEMjwtkE31YR5h9z42lTgEFfcHNpD1JiGq/gyCjy5D+PHS
	JpRWoCy5z9XfnaJ8jTTCmZIZ/+XF4DDbyOVnvJ+68i5cngTV4z5h/J7dpQ5FMdVnL5jdgE3KJSw
	bijp7+vVEKiH4ujoz9/cewCiNYJckHGCgxtp9
X-Received: by 2002:a17:907:868b:b0:ae0:dd95:1991 with SMTP id a640c23a62f3a-af619efda7fmr218779466b.51.1753442808349;
        Fri, 25 Jul 2025 04:26:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF62wP3IqAMJ1/E1mQqpiMFCO0fY8T1aVjgbgNEGN4i3p5BpL7PdyFIzDt2eRf4SEXlVdUVvQ==
X-Received: by 2002:a17:907:868b:b0:ae0:dd95:1991 with SMTP id a640c23a62f3a-af619efda7fmr218773366b.51.1753442807745;
        Fri, 25 Jul 2025 04:26:47 -0700 (PDT)
Received: from [192.168.103.102] (ip-005-147-080-091.um06.pools.vodafone-ip.de. [5.147.80.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-614cd31ac41sm1898416a12.54.2025.07.25.04.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jul 2025 04:26:47 -0700 (PDT)
Message-ID: <b50da4ef-53ca-4edf-bd74-f5e037a14f99@canonical.com>
Date: Fri, 25 Jul 2025 13:26:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/11] riscv: Kconfig & Makefile for riscv kernel control
 flow integrity
To: Deepak Gupta <debug@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com,
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com,
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com,
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com,
 andrew@sifive.com, ved@rivosinc.com, Paul Walmsley
 <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor
 <nathan@kernel.org>, Nicolas Schier <nicolas.schier@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>,
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-11-04b8fa44c98c@rivosinc.com>
Content-Language: en-US
From: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <20250724-riscv_kcfi-v1-11-04b8fa44c98c@rivosinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4b8c149huarissorfctp8ua7b811nyxk
X-Rspamd-Queue-Id: AAD2B1C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753442813-599630
X-HE-Meta: U2FsdGVkX1+MZYs63fKsQabC/eO1JNXuu/dAhrDw0MTWiPx7Gj+m0iqcosAZiO+7POwM9jz4dz3rev5vSMr4I3+wOpy7E8B0VkAMS6rKWUeXRSfYMirGBI5aUT7KdfJN4wX3sf5bCj28LyA75IgUV9qs25l8xoGd2ZypX6c0ApHXf1vly5ATQnm8mVw/+tG8I1FimAuXRUl3U2rDQAEqDx+bmuYPHaDYezpaKLzBl2IDgBGWGYgEyMau7k9wjbAUZlu4QBIIuLvr7Lr/ehJxdq71D8uxcKe6dh+gLYhR9VzIJARm3UP7FzOLZA1yKLkzKvvEmQ+UC6ERjEqPMJ9c7YW+9FQ7d/Y0Iud4CnoJqPqzYFNXNpk+bJG13exu2ID8uR9rZbZvjnm9ylWMioJHXfEM4/a8+nzrUm4yTKEoFoG271Pyhxl+XBe4pfo42Y+TSkp3ihTtWS+aOktOzipYHeV/DDQ1qsDj1acdzj1QtxjBtqb9H5AGgMfHRXDOiG93IvubGdEqLmy1kobhZF6NuqMSTNf7TJkrSidXxYeMA1buzBncEDiKWaXqZkDsGOELxoHpHohgDCJIDD0HRko5ZjRakJTzc2dJ7hHGCCuwsMGkIn3vwHCAmRDvviqcg2GYLTrm+Abw+zAOO4T6zZjdO3vq7pwkFhLx8YoZdtVkvg7PSHRhU2gxqE/qsZc1f4feEXiaSmQDiSMI0ECqMGuAKXeoPpYfGvgpyEeicuy2vfA3UDd+jow3RTLnddakMBx7Wr+GzrZfg+X3AbDSiUqirOKzgNoS5uMwL6aB4xAwdq4MQZFiwPFFGaoc6oIHZh4r/uMSD5fFPH7K2/BHgbfEdG7g9ArZsmTJdkBeYMZDTGYhbPlWwm15Dg683yalMTmShzdEluvWeHmQAVYOMDdyAhL5X3+Uw7/i/pDUulazD4/iXjU5dtnlzODhYrobr8GIExw/V9V691+5JgvGVVv
 K9nR33C8
 bH+Cx+A6tRZ0WLEUi7V5o6Oqvw+BeL40/MYw09IYkLwwpVG1C3EEu3smwn10d8D/jjVraVy4SpNRwhtpoJ3hr2Yh93D5kNu2NhXYTnsPKHWGLBw9GtWUlcEi/ijMLShS77A18//IrN1rEDtzgvYAzXANLN6o+3F5/5In/gv/hr0ZQF0pulG8Uma5Ne0EEIB62Zqy5EHNC0lCIwaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25.07.25 01:37, Deepak Gupta wrote:
> Defines `CONFIG_RISCV_KERNEL_CFI` and selects SHADOW_CALL_STACK
> and ARCH_HAS_KERNEL_SHADOW_STACK both so that zicfiss can be wired up.
> 
> Makefile checks if CONFIG_RISCV_KERNEL_CFI is enabled, then light
> up zicfiss and zicfilp compiler flags. CONFIG_RISCV_KERNEL_CFI is
> dependent on CONFIG_RISCV_USER_CFI. There is no reason for user to
> not select support for user cfi while enabling for kernel.
> 
> compat vdso don't need fcf-protection (toolchain lacks support).
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>   arch/riscv/Kconfig                     | 37 +++++++++++++++++++++++++++++++++-
>   arch/riscv/Makefile                    |  8 ++++++++
>   arch/riscv/kernel/compat_vdso/Makefile |  2 +-
>   arch/riscv/kernel/vdso/Makefile        |  2 +-
>   4 files changed, 46 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 385c3d93e378..305ba5787f74 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -245,7 +245,7 @@ config GCC_SUPPORTS_DYNAMIC_FTRACE
>   	depends on CC_HAS_MIN_FUNCTION_ALIGNMENT || !RISCV_ISA_C
>   
>   config HAVE_SHADOW_CALL_STACK
> -	def_bool $(cc-option,-fsanitize=shadow-call-stack)
> +	def_bool $(cc-option,-fsanitize=shadow-call-stack) || $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp_zicfiss)
>   	# https://github.com/riscv-non-isa/riscv-elf-psabi-doc/commit/a484e843e6eeb51f0cb7b8819e50da6d2444d769
>   	depends on $(ld-option,--no-relax-gp)
>   
> @@ -864,6 +864,16 @@ config RISCV_ISA_ZICBOP
>   
>   	  If you don't know what to do here, say Y.
>   
> +config TOOLCHAIN_HAS_ZICFILP
> +	bool
> +	default y
> +	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp)
> +
> +config TOOLCHAIN_HAS_ZICFISS
> +	bool
> +	default y
> +	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfiss)
> +
>   config TOOLCHAIN_NEEDS_EXPLICIT_ZICSR_ZIFENCEI
>   	def_bool y
>   	# https://sourceware.org/git/?p=binutils-gdb.git;a=commit;h=aed44286efa8ae8717a77d94b51ac3614e2ca6dc
> @@ -1182,6 +1192,31 @@ config RISCV_USER_CFI
>   	  space does not get protection "for free".
>   	  default n.
>   
> +config RISCV_KERNEL_CFI
> +	def_bool n
> +	bool "hw assisted riscv kernel control flow integrity (kcfi)"
> +	depends on 64BIT && $(cc-option,-mabi=lp64 -march=rv64ima_zicfilp_zicfiss)
> +	depends on RISCV_USER_CFI
> +	select ARCH_SUPPORTS_SHADOW_CALL_STACK
> +	select SHADOW_CALL_STACK
> +	select ARCH_HAS_KERNEL_SHADOW_STACK
> +	help
> +	  Provides CPU assisted control flow integrity to for riscv kernel.
> +	  Control flow integrity is provided by implementing shadow stack for
> +	  backward edge and indirect branch tracking for forward edge. Shadow
> +	  stack protection is a hardware feature that detects function return
> +	  address corruption. This helps mitigate ROP attacks. RISCV_KERNEL_CFI
> +	  selects CONFIG_SHADOW_CALL_STACK which uses software based shadow
> +	  stack but is unprotected against stray writes. Selecting RISCV_KERNEL_CFI
> +	  will select CONFIG_DYNAMIC_SCS and will enable hardware assisted shadow
> +	  stack protection against stray writes.

Please, consider adding a blank line for better readability.

> +	  Indirect branch tracking enforces that all indirect branches must land
> +	  on a landing pad instruction else CPU will fault. This enables forward
> +	  control flow (call/jmp) protection in kernel and restricts all indirect
> +	  call or jump in kernel to a landing pad instruction which mostly likely
> +	  will be start of the function.
> +	  default n

For Linux distributions it is important that the same kernel can run 
both on hardware both with and without CFI support. The description 
provided does not help to understand if RISCV_KERNEL_CFI=y will result 
in such a kernel. Please, enumerate the minimum set of extensions needed 
for supporting a kernel built with RISCV_KERNEL_CFI=y. I guess this will 
at least include Zimop.

Best regards

Heinrich

> +
>   endmenu # "Kernel features"
>   
>   menu "Boot options"
> diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
> index 7128df832b28..6ef30a3d2bc4 100644
> --- a/arch/riscv/Makefile
> +++ b/arch/riscv/Makefile
> @@ -61,8 +61,10 @@ else ifeq ($(CONFIG_LTO_CLANG),y)
>   endif
>   
>   ifeq ($(CONFIG_SHADOW_CALL_STACK),y)
> +ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>   	KBUILD_LDFLAGS += --no-relax-gp
>   endif
> +endif
>   
>   # ISA string setting
>   riscv-march-$(CONFIG_ARCH_RV32I)	:= rv32ima
> @@ -91,6 +93,12 @@ riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZABHA) := $(riscv-march-y)_zabha
>   KBUILD_BASE_ISA = -march=$(shell echo $(riscv-march-y) | sed -E 's/(rv32ima|rv64ima)fd([^v_]*)v?/\1\2/')
>   export KBUILD_BASE_ISA
>   
> +ifeq ($(CONFIG_RISCV_KERNEL_CFI),y)
> +riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFILP) := $(riscv-march-y)_zicfilp
> +riscv-march-$(CONFIG_TOOLCHAIN_HAS_ZICFISS) := $(riscv-march-y)_zicfiss
> +KBUILD_CFLAGS += -fcf-protection=full
> +KBUILD_AFLAGS += -fcf-protection=full
> +endif
>   # Remove F,D,V from isa string for all. Keep extensions between "fd" and "v" by
>   # matching non-v and non-multi-letter extensions out with the filter ([^v_]*)
>   KBUILD_CFLAGS += $(KBUILD_BASE_ISA)
> diff --git a/arch/riscv/kernel/compat_vdso/Makefile b/arch/riscv/kernel/compat_vdso/Makefile
> index 24e37d1ef7ec..552131bc34d7 100644
> --- a/arch/riscv/kernel/compat_vdso/Makefile
> +++ b/arch/riscv/kernel/compat_vdso/Makefile
> @@ -69,4 +69,4 @@ quiet_cmd_compat_vdsold = VDSOLD  $@
>   
>   # actual build commands
>   quiet_cmd_compat_vdsoas = VDSOAS  $@
> -      cmd_compat_vdsoas = $(COMPAT_CC) $(a_flags) $(COMPAT_CC_FLAGS) -c -o $@ $<
> +      cmd_compat_vdsoas = $(COMPAT_CC) $(filter-out -fcf-protection=full, $(a_flags)) $(COMPAT_CC_FLAGS) -c -o $@ $<
> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
> index 2b528d82fa7d..7b1446b63ebc 100644
> --- a/arch/riscv/kernel/vdso/Makefile
> +++ b/arch/riscv/kernel/vdso/Makefile
> @@ -17,7 +17,7 @@ ifdef CONFIG_VDSO_GETRANDOM
>   vdso-syms += getrandom
>   endif
>   
> -ifdef CONFIG_RISCV_USER_CFI
> +ifneq ($(CONFIG_RISCV_USER_CFI), $(CONFIG_RISCV_KERNEL_CFI))
>   CFI_MARCH = _zicfilp_zicfiss
>   CFI_FULL = -fcf-protection=full
>   endif
> 


