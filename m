Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157A4CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 05:31:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9678E0007; Thu,  4 Sep 2025 01:31:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1858E0002; Thu,  4 Sep 2025 01:31:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7138E0007; Thu,  4 Sep 2025 01:31:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 495F78E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:31:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E03551DF3CF
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:31:18 +0000 (UTC)
X-FDA: 83850444636.14.D94E11A
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id C8386C0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 05:31:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=fGf6a7mh;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of apatel@ventanamicro.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=apatel@ventanamicro.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756963877; a=rsa-sha256;
	cv=none;
	b=BxcFKWwMv7nFj72MBPq1ehJK/Rte9k+Co+WUi/QvDvZEhfcUdU7hLQZp7w2tGF+SWuRBBU
	F47cW8UHrFN4SGzqmDnFHABZG4nmXXyVFjs4v2WNmT7Xyhe3A0gb+KYoKJQXK/QSKU+tcp
	v0jNV1eLC2d9pPeE85wD6hfP9YYzsXQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=fGf6a7mh;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of apatel@ventanamicro.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=apatel@ventanamicro.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756963877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bUS5HOLhW/VpyZE9onIdkx0oHXwb/D4QXFFEiFH3pRQ=;
	b=M7UgkzUv2VK/wo6mVQ2j+nZ6Xju9+7sPZPaHO+YxlgGKCl5Qy/Ch6M9aDcHMLhvpGEMHc5
	6f1/bWb7a+VqbxhYDkcd57fqBgm8rLittlER7uIVLV2B4SWsmuRbQQzch9CDGyEd+BXJ6u
	gKAJpK6vqAcsnA9fM8+EeG0hSKS0vKQ=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-55f6b0049fbso734914e87.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 22:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1756963875; x=1757568675; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bUS5HOLhW/VpyZE9onIdkx0oHXwb/D4QXFFEiFH3pRQ=;
        b=fGf6a7mhEUf8eUe6adTajBQtzuvbqNjS13IwynV7nOFG88+mOzBS1DPC2u9+5FBNTx
         i2BUGaMuRDMHaoywNGl1HU7iiFqWss/rUGaK1iSbSVnJ+JbzM11F3U3W9yBX81I+OtB/
         j5WEwGlX9fLR2juR5KKBzHW3ZrDaG/kxzk9V9DVLxpRGLnkXEetzAEmy0fm49wlMfdQM
         BOiU58DnkdpT5R4P97GoeifPW9uKqs1XeqmJeca+96JVdChp2sqyGuys4wIuY53T0zDv
         AC1j+uq0jFwehCDvKuWX0xnFMPZe7jNWACQKwMD7lcn7inMwZTYNz7UULB66pTy0jfGH
         AZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756963875; x=1757568675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bUS5HOLhW/VpyZE9onIdkx0oHXwb/D4QXFFEiFH3pRQ=;
        b=NOsqQPU8jjRL8P7ZneCE8vhEuFTfxGeOSE4FQ+VgvM4H1fulbvpLEZgXBF0hVa1dKK
         YN09lIyzIronjEP/ztEORJpdyPe4WyP4NUAHuiU3csI2Z5ZCcIqc7yrWCbX1QvUFTlUP
         j+/81Lh3JIkStghLTh9KixYsUoprY5IUFMmmG3Ulm1BS/sj2DBALHahBs7xl5+Xc1xu5
         i+z2DBAe1Rkc5imMkS6ypJV7cQhJlicVxQVSHJZdzTynqDliK4jzLcye+G0MpacirVsx
         xC7SCQVX+o34X2IWcSSZdDqS2wTCK0cYC9cjCZ/x2/3SPZugbpvgZ0MzX60Ck8hdPBW2
         hUBA==
X-Forwarded-Encrypted: i=1; AJvYcCVJzWnF/wsp8NhbANGd/pSZ/RW1hTExb0vExsMplL+2FaVtMRoTalQQ3lA4Ddjp3z/L5SmGcjtpjA==@kvack.org
X-Gm-Message-State: AOJu0Ywk7N4nIMb4ov+0ysfEqBHG8vYB0ywwt8iABueNAjz9W2Xj2TTH
	t1qbWtETCmTd7WWpMAMs2bYD5ejFxlQIOxCszyUiob4P2aJUA0MOjosD9l3WzJVqnJkKLfJwvBV
	6Fq5gN497poSRtq/CCMyWiUmoLq3bx8f7+bqxuFFZOw==
X-Gm-Gg: ASbGnct8+0LYGQNdQ2SVhmbM6grHHTmmbhu9qyTfcsfweRyYSiPT1g8CrXHzldSIe2V
	gXgneDQ8Llyuvnnog4MujZ828COBaQmYTd3K3+U3uTtRY8DskyLvv5svTNyiE+W4FQ8kjryJ5/h
	UVBCaCmsdyHRj5MXPm4Edpgnd7yKAT8/cNOKqyhTSTi4R/jNlEPuASlyVU2LLOmiFPsS71L43Q8
	JWil5NGqqV7TArpN5E=
X-Google-Smtp-Source: AGHT+IHpG/4DLLscFeJxg9oiSMyrT9Ei4giIfqBu/oq/vW7+cyJh5b4Qc/vs+psL1BC6wQvPjI60Gtk/quL0fGjGJtU=
X-Received: by 2002:a05:6512:1594:b0:55f:6831:6ef4 with SMTP id
 2adb3069b0e04-55f7089c47amr5218029e87.12.1756963874604; Wed, 03 Sep 2025
 22:31:14 -0700 (PDT)
MIME-Version: 1.0
References: <20250822174715.1269138-1-jesse@rivosinc.com> <20250822174715.1269138-5-jesse@rivosinc.com>
In-Reply-To: <20250822174715.1269138-5-jesse@rivosinc.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Thu, 4 Sep 2025 11:01:02 +0530
X-Gm-Features: Ac12FXz_-ibvebvqMYm5-3Nr_6futqZOiLsqEgz-5uDfiWQDjH2HOgDMSF197Fg
Message-ID: <CAK9=C2X=SmJeYqZtUNHuDBZRrUpONCm6Z=qVPH8C1ckz=r6hCw@mail.gmail.com>
Subject: Re: [PATCH 4/8] riscv: Introduce support for hardware break/watchpoints
To: Jesse Taube <jesse@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Liang Kan <kan.liang@linux.intel.com>, Shuah Khan <shuah@kernel.org>, 
	Himanshu Chauhan <hchauhan@ventanamicro.com>, Charlie Jenkins <charlie@rivosinc.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Deepak Gupta <debug@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	Evan Green <evan@rivosinc.com>, WangYuli <wangyuli@uniontech.com>, 
	Huacai Chen <chenhuacai@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Nam Cao <namcao@linutronix.de>, 
	Yunhui Cui <cuiyunhui@bytedance.com>, Joel Granados <joel.granados@kernel.org>, 
	=?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <cleger@rivosinc.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Celeste Liu <coelacanthushex@gmail.com>, 
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Nylon Chen <nylon.chen@sifive.com>, 
	Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Ravi Bangoria <ravi.bangoria@amd.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Joel Stanley <joel@jms.id.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C8386C0009
X-Stat-Signature: 4p7unun4kscxw6et3gr1ozc1qk3h719j
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756963876-301515
X-HE-Meta: U2FsdGVkX18OKtqfVx0L3dQ4h93/kZ4WRzLH6mN8Wixeul+BXqcyaTghDwtn35IEIDrNkMsCQxqc4irAoM6Z/YxOIU/1q02zuOi28y9YmkwWd7xiA4LHifKzdLHFeX7xTeVtyu5OBxEU7VvK9j9SOJtH1G6jZxlRU6gXxWCIPjJ4j270qk+Bmh6q/yOuEzuBnZqCZ9Z+EvP0CxH9zfBVH0WTfe/P60mKSARNekUh4oJM+aDYVeVLf5ccJqIX1dtYUoJGJpFnqq1yLSYlz891K6MCQPmD3Zg7vqUS4WIRqANRVzXcu2f31NX3849e/spATCdAD0DAHbonrpoSktAJoAn1YaQP4kkpDG34SI2ja6Gpli5eY+Z1NZax4LU84D8bZFiTI9hHRXxF46CPUAuHF3iYve0QRLk4D36jo5VGnCN4Qut7JlD3ua3NPOnmeTNKFvIJzn04lkqsJmr6t/ADYNtJfpPs3DgztpQgQ6EftAEm3EpFI+GfvearfLiemgD40qAFrw4fS5M2i3Ye4edNRnkaMkq7Kg1+S4msaQrVEt5JCKeilsbYz8xla48rVtVQBo4IixTLRMpQH5RnuAgJRqSMJjdqkj8pzde18chVdFQ6XF4ETfjSY7iUplVOBz+J0EJ8i+itbO2cmyVpSMl1bXkU3+7wOikWNZNCqFUwIkj5B0srrb7WA9Qg8VbzSlbqxrjFMz6Tl9Kzps7yYrq+ghy9w9zPHsk0knqQoVMr/35azzWoRkb0vahspxV2UDLrwD6/RxC16Z8s+J/1T7sFJv+uueLJXImUPZDI5dbd0nStIv1T5C0vIX8jzsm4OFwz/cLJ0WivvhQsW4a58XVFtfGfZVE1K5J+B1lNi+tzxMX33KHUqGgHuG/Kjc7E/5drwVynxUqgT6YAPB3G6R6Ibbd3OxEQYbsELQLDKKL/IcEOoY3CS0Z+Ul5D9WMT99RTmACRtc/5OlfPffor0Ye
 /umd/6H5
 A5gFhA1KTMAkqUplRm31ySJAF6TJ11RlHUx4ugV0Gh38k4TWNW3omI3nHbelSQ5k4r3R3WZg0BYkw4U0QozcMqAob/Z0u+jelhLpN0fd++e/YjN/Z7iEgjXW7S0OTWomgbsB55XqYPoxrAW4EZTUQOWzKC+Gns9GY85aCAsFS015f478PA0p+l0kvfCFb6Z1V+mGaoiptikbf6CWIEGbIfWeu+Sp7SIZRA9nRJf/nfOGC3Ms4fiu6YtgrzBW3lkVxXLg19KzgoeVXqROKSDnPhob1ZnvsM7anCfGq0JKw7WdK+thvMhNXR1QV8BZ7NDpA72q4ziYHjVcFVD0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 11:17=E2=80=AFPM Jesse Taube <jesse@rivosinc.com> w=
rote:
>
> From: Himanshu Chauhan <hchauhan@ventanamicro.com>
>
> RISC-V hardware breakpoint framework is built on top of perf subsystem an=
d uses
> SBI debug trigger extension to install/uninstall/update/enable/disable ha=
rdware
> triggers as specified in Sdtrig ISA extension.
>
> Signed-off-by: Himanshu Chauhan <hchauhan@ventanamicro.com>
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> ---
> RFC -> V1:
>  - Add dbtr_mode to rv_init_mcontrol(6)_trigger
>  - Add select HAVE_MIXED_BREAKPOINTS_REGS
>  - Add TDATA1_MCTRL_SZ and TDATA1_MCTRL6_SZ
>  - Capitalize F in Fallback comment
>  - Fix in_callback code to allow multiple breakpoints
>  - Move perf_bp_event above setup_singlestep to save the correct state
>  - Use sbi_err_map_linux_errno for arch_smp_teardown/setup_sbi_shmem
> V1 -> V2:
>  - No change
> ---
>  arch/riscv/Kconfig                     |   2 +
>  arch/riscv/include/asm/hw_breakpoint.h |  59 +++
>  arch/riscv/include/asm/kdebug.h        |   3 +-
>  arch/riscv/include/asm/sbi.h           |   4 +-
>  arch/riscv/kernel/Makefile             |   1 +
>  arch/riscv/kernel/hw_breakpoint.c      | 614 +++++++++++++++++++++++++
>  arch/riscv/kernel/traps.c              |   6 +
>  7 files changed, 687 insertions(+), 2 deletions(-)
>  create mode 100644 arch/riscv/include/asm/hw_breakpoint.h
>  create mode 100644 arch/riscv/kernel/hw_breakpoint.c
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index bbec87b79309..fd8b62cdc6f5 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -163,6 +163,7 @@ config RISCV
>         select HAVE_FUNCTION_ERROR_INJECTION
>         select HAVE_GCC_PLUGINS
>         select HAVE_GENERIC_VDSO if MMU && 64BIT
> +       select HAVE_HW_BREAKPOINT if PERF_EVENTS && RISCV_SBI
>         select HAVE_IRQ_TIME_ACCOUNTING
>         select HAVE_KERNEL_BZIP2 if !XIP_KERNEL && !EFI_ZBOOT
>         select HAVE_KERNEL_GZIP if !XIP_KERNEL && !EFI_ZBOOT
> @@ -176,6 +177,7 @@ config RISCV
>         select HAVE_KRETPROBES if !XIP_KERNEL
>         # https://github.com/ClangBuiltLinux/linux/issues/1881
>         select HAVE_LD_DEAD_CODE_DATA_ELIMINATION if !LD_IS_LLD
> +       select HAVE_MIXED_BREAKPOINTS_REGS
>         select HAVE_MOVE_PMD
>         select HAVE_MOVE_PUD
>         select HAVE_PAGE_SIZE_4KB
> diff --git a/arch/riscv/include/asm/hw_breakpoint.h b/arch/riscv/include/=
asm/hw_breakpoint.h
> new file mode 100644
> index 000000000000..cde6688b91d2
> --- /dev/null
> +++ b/arch/riscv/include/asm/hw_breakpoint.h
> @@ -0,0 +1,59 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright (C) 2024 Ventana Micro Systems Inc.
> + */
> +
> +#ifndef __RISCV_HW_BREAKPOINT_H
> +#define __RISCV_HW_BREAKPOINT_H
> +
> +struct task_struct;
> +
> +#ifdef CONFIG_HAVE_HW_BREAKPOINT
> +
> +#include <uapi/linux/hw_breakpoint.h>
> +
> +#if __riscv_xlen =3D=3D 64
> +#define cpu_to_le cpu_to_le64
> +#define le_to_cpu le64_to_cpu
> +#elif __riscv_xlen =3D=3D 32
> +#define cpu_to_le cpu_to_le32
> +#define le_to_cpu le32_to_cpu
> +#else
> +#error "Unexpected __riscv_xlen"
> +#endif
> +
> +struct arch_hw_breakpoint {
> +       unsigned long address;
> +       unsigned long len;
> +
> +       /* Callback info */
> +       unsigned long next_addr;
> +       bool in_callback;
> +
> +       /* Trigger configuration data */
> +       unsigned long tdata1;
> +       unsigned long tdata2;
> +       unsigned long tdata3;
> +};
> +
> +/* Maximum number of hardware breakpoints supported */
> +#define RV_MAX_TRIGGERS 32
> +
> +struct perf_event_attr;
> +struct notifier_block;
> +struct perf_event;
> +struct pt_regs;
> +
> +int hw_breakpoint_slots(int type);
> +int arch_check_bp_in_kernelspace(struct arch_hw_breakpoint *hw);
> +int hw_breakpoint_arch_parse(struct perf_event *bp,
> +                            const struct perf_event_attr *attr,
> +                            struct arch_hw_breakpoint *hw);
> +int hw_breakpoint_exceptions_notify(struct notifier_block *unused,
> +                                   unsigned long val, void *data);
> +int arch_install_hw_breakpoint(struct perf_event *bp);
> +void arch_uninstall_hw_breakpoint(struct perf_event *bp);
> +void hw_breakpoint_pmu_read(struct perf_event *bp);
> +
> +#endif /* CONFIG_HAVE_HW_BREAKPOINT */
> +#endif /* __RISCV_HW_BREAKPOINT_H */
> diff --git a/arch/riscv/include/asm/kdebug.h b/arch/riscv/include/asm/kde=
bug.h
> index 85ac00411f6e..53e989781aa1 100644
> --- a/arch/riscv/include/asm/kdebug.h
> +++ b/arch/riscv/include/asm/kdebug.h
> @@ -6,7 +6,8 @@
>  enum die_val {
>         DIE_UNUSED,
>         DIE_TRAP,
> -       DIE_OOPS
> +       DIE_OOPS,
> +       DIE_DEBUG
>  };
>
>  #endif
> diff --git a/arch/riscv/include/asm/sbi.h b/arch/riscv/include/asm/sbi.h
> index be2ca8e8a49e..64fa7a82aa45 100644
> --- a/arch/riscv/include/asm/sbi.h
> +++ b/arch/riscv/include/asm/sbi.h
> @@ -282,7 +282,9 @@ struct sbi_sta_struct {
>         u8 pad[47];
>  } __packed;
>
> -#define SBI_SHMEM_DISABLE              -1
> +#define SBI_SHMEM_DISABLE      (-1UL)
> +#define SBI_SHMEM_LO(pa)       ((unsigned long)lower_32_bits(pa))
> +#define SBI_SHMEM_HI(pa)       ((unsigned long)upper_32_bits(pa))

These definitions of SBI_SHMEM_LO() and SBI_SHMEM_HI() are
broken for RV64 platforms where a good amount of RAM is beyond
first 4GB.

This should be:

#ifdef CONFIG_32BIT
#define SBI_SHMEM_LO(pa)       ((unsigned long)lower_32_bits(pa))
#define SBI_SHMEM_HI(pa)       ((unsigned long)upper_32_bits(pa))
#else
#define SBI_SHMEM_LO(pa)       ((unsigned long)pa)
#define SBI_SHMEM_HI(pa)       0UL
#endif

Regards,
Anup

