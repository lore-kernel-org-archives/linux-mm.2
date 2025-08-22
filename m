Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA2FCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 18:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3A1B6B8002; Fri, 22 Aug 2025 14:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EB988E009D; Fri, 22 Aug 2025 14:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9876B8002; Fri, 22 Aug 2025 14:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7653E8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 14:00:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3DE5582F89
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 18:00:01 +0000 (UTC)
X-FDA: 83805157002.08.70503E8
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 642C44000C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 17:59:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ZzX3gbAH;
	spf=pass (imf07.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755885599; a=rsa-sha256;
	cv=none;
	b=mAC1ydCZC17GxZES6SNlCQuh3rUJgzcdY3o/Ryug6RbjVVgx200lUITwWXyKG+unKk2WHq
	Wj6mBpHM/Wxd55Xahj0Cy+1ktXBujoE9Kt+ob/kHekvRMsVb8sxfiJMbdYb3N/1F3n9GLg
	8HAsovuPW16bUmJe/tSUlT1n/zU2NZ8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=ZzX3gbAH;
	spf=pass (imf07.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=jesse@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755885599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W9fNzpGQYiY8hUTovQusQUuPvFziC263n9KoSaKQGOM=;
	b=pOL6tznc2gLy3FW8N3kQT+wFd+wsR2w0708rO6I7SgweLGrKTaqE83/sudSSMoVO6FNvJT
	zdmeQOjbuWcbBF4rWlIR8BDAXD4sGxT9yl1D2nRXcYAR7EzyeKqIFiGfvlSFD93imd3jue
	/XHwYreKuWGO+OnHFmc8mqklK+kp4js=
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-53b17185751so799683e0c.0
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 10:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1755885598; x=1756490398; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W9fNzpGQYiY8hUTovQusQUuPvFziC263n9KoSaKQGOM=;
        b=ZzX3gbAHdy14wNAGp/K4RodNDohQRt1vN4+rHLdGx2Q8IVXs/KKpXly8Suy3+mAS2/
         /hRqQdOtrfEsFIG2cSD1cXaX21xaKo62S5ITE4Hf5qdglAu+1GnQryKYr7Ynp5FIbU6L
         jlBCIDBS9KI26RroHW6oAGXk2wpiNey5qg3BZLqR7Z5ztJ4d/5HwYD7wgcnZHyTPWt1z
         WTrJlEjTg2cuntRw834G4DGC/260HggNnHarTQK2XVD6S5gLBueVl/5Rq9BitihshZqz
         Z81/8xBzsFAKMC+ZKFSGE4Ut3qt6/9y5YXDz6uwK+lyuoiBLFM3RmUfxivHKt8YZmdJ7
         Olvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755885598; x=1756490398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W9fNzpGQYiY8hUTovQusQUuPvFziC263n9KoSaKQGOM=;
        b=LtqH0Bv+8+oOA/WWQavlArvb1ssIyl0bbwlYF+QeQbz6QgPHTdWpBq3jMQP/hJPrJn
         Syn5sVA9IgWBS7hdthjEyTpGd0s5HF2+fVIgdWbt1Kd41yvZ02cC4SnHyi4WJd5JK4TI
         0q5vzacrGu9Fn0gVdwo4b4qW/0RoWKeDGO8im0aP1Ntfp2klZq2bnZ4yI5HoiRQsUfv9
         sijaba6rBWj/rWeTh5kCqhJL0AloxeGcenzZIObiI+W4BD4AcyLRSBgIWg8rQVm4P3m2
         j3VQVxx5QkogkbHiegI0ALaC73wYbkA5E4Y+Tdb4mddJfEzMMha4WmADh71cjKnlCxCY
         Sajw==
X-Forwarded-Encrypted: i=1; AJvYcCV1Wvd2O7aYHdF3IEsm69TYbQluJdLdiAuRMdQchH6Kg6QN1pjfiSd3ifMx77zDwcNOH7Gp/9mWhQ==@kvack.org
X-Gm-Message-State: AOJu0Yw1VOIcwne2SJBVnI7FAcittGwDpLC6N2i9j+sNp4L91ze1WTCU
	1jsqdcrv/+b9fVt4YaUyMppCeCAkKqIhquxY2OwwfnyX7oSxN49XEocGoavdFnP6cisqzKxytUi
	FMcB6ZdvLEeu435HA9HoEUjFX/M75XlDHDfcgjNGknQ==
X-Gm-Gg: ASbGncsd4dj2YgdaBn3zkkxNsE6cqTbj44Cz+9ei0pic1eokq15patNS9jcP3OtTYUJ
	yw4dqHBYUzXyDzQ/JJG/7LKYxdNrfc3wTdnxM6mBtiI+cGyKSGpjVQDid/hqajA5MZH+Ci1nXVi
	/h+g46Wzx44DgXsPWZRf1f8DqPpPYUYXF3Hub/ggI0A5NwIAenfrn/DmmeIa7d7Ia1V7f7by2HQ
	kGjve2j
X-Google-Smtp-Source: AGHT+IGn5vdUvXU42asTYKNQVZYOTWSFQylr/vzhKnTrBq4lq3wiMD7MVYIp2kAGpgvKTA1X/43JEESbQNKODDhNtrQ=
X-Received: by 2002:a05:6122:2502:b0:539:27eb:ca76 with SMTP id
 71dfb90a1353d-53c8a2ea9admr1107586e0c.5.1755885598348; Fri, 22 Aug 2025
 10:59:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250822174715.1269138-1-jesse@rivosinc.com>
In-Reply-To: <20250822174715.1269138-1-jesse@rivosinc.com>
From: Jesse Taube <jesse@rivosinc.com>
Date: Fri, 22 Aug 2025 10:59:47 -0700
X-Gm-Features: Ac12FXx85Q9pdAS3tmJucpDWbmumN5hD5YReh0RpBOKeYl8mPi6vXHz7zLBXbxM
Message-ID: <CALSpo=aQyb+E0HHDRoXs0f5vvxJtMpCA546ROkq0e3B-ur9QBg@mail.gmail.com>
Subject: Re: [PATCH 0/8] riscv: add initial support for hardware breakpoints
To: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Oleg Nesterov <oleg@redhat.com>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Liang Kan <kan.liang@linux.intel.com>, Shuah Khan <shuah@kernel.org>, 
	Himanshu Chauhan <hchauhan@ventanamicro.com>, Charlie Jenkins <charlie@rivosinc.com>, 
	Samuel Holland <samuel.holland@sifive.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Deepak Gupta <debug@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Anup Patel <apatel@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, Evan Green <evan@rivosinc.com>, 
	WangYuli <wangyuli@uniontech.com>, Huacai Chen <chenhuacai@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Nam Cao <namcao@linutronix.de>, 
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 642C44000C
X-Stat-Signature: 11xx9z387154bfwdfxu4p7fi64kc6nrf
X-Rspam-User: 
X-HE-Tag: 1755885599-383516
X-HE-Meta: U2FsdGVkX1/8LxnAgwiovUhkA4dfod12kDx1RcrO9J7jmdWuoWiRy7hIK+dIFBKMB4hllZVSup2vZqzA19JPKcysnrQ0iUBACfBOnpOcQBd6mYnbUuS6rmsvdUJMioOz1JQ4wmzkp8/QJpRSg7qQTejkeoOOfr01GJIRno1VGuaIAV7oEjJxl+tjqg4ejy21zD2b5CGbcDkxcPUHWXAtxwyA+/Ta17GQgXR4uIIPThzao12+CN69HISdeQHj48plZXq+46CBKpW//tBxI0o6QivEw2ANfCwl90aGmQrIVqYBNkhrMt72wBMM3lq3O3kUyEH1S3ZhQ2LH0zX8g7pLpyz2k4HAAs/2MDSdcVIpNOljUakP3l5LOuo2QQf/E2Tx2vQy2pQccnR2S4EbV22tSeyBu2HZYldQYbup50bMJWZ4bCzPV3NMvqngCymdMSZJpPgfjUwJaGyTVeX4Oieqa8wuUzRP8bymgrLr0pBTtdkhNZhl/Z1fTaI3egmGSqkoGpA/ROLORlNE+Wcsih/JflFT8krdOlOCoY/T4BK85kI6UJley3R5o/NR163IfSvBwug8Fu0oR4UVr9+aeZKzicsE2M3YK7bHClxn2Sfg8Rza7/S7WA7kEkkIO4l8JEI8cU0Fb798jSCWNeHu1cT2MbeuBuG7/G7jrgheOqFsqz/vOjYfeLcCYIQtRamzeLIFGlqW7jB6PC8UwqQQgWbBgFM54nRh0tsEoo+XdeGZGLrowvmJaDkzDmIXTDAyrQReF9kVULxT9mwbchyWVLHtMvh1QG5JRsVTAjmvRwKcDx/UkF123deOlw1/9WZUO3scZJIRssPu/Kvt1S5yKJYyBgnoBNLASGMfSsi2XRGr8bUDLdILuPnGM7DYnCaO0BSbM+VziybMFoOnVU/N9CqDEDZyepgLcIKyt94GiR5cdKyV5XuwMPu88d8edesxkqpg3SF46YjI3oeS5IHTjfC
 j18RzOpg
 3Yxlge0xdCiGpNlm7K23dnI/wylcDhhBascA3Wy+tk8vJncJazp/4b/TJAbGAwYlmNsl3yJ0drT9i48O0RcBNlF210veKsCQr6ZTOsaMAJ1lYqDZNRLnWUCVFz4x7K0zOzZThxTRDiRLBVz6QWLLmn0OPsbsP+14u/KHhjzfvGCZcJSuaodZIToLOvXyIJwmL9QQhyWTQvhQZB/uvGmS5x/kMLr/rhDeCNedHhDoYrf/MPanwf2xNmOfFwiUJx38YNuo/Ou1HBD46PedXtceqHurLV4hf+8svqcQP+6ak+KfvHYhSUNlaGVhtvK4AmMZ/SVJvt4361f1RD5YgSzhOAC+pMekIKsTSZ3eNaDLVbaSLmX8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 10:47=E2=80=AFAM Jesse Taube <jesse@rivosinc.com> w=
rote:
>
> This patchset adds initial support for hardware breakpoints and
> watchpoints to the  RISC-V architecture. The framework is built on
> top of perf subsystem and SBI debug trigger extension.
>
> Currently following features are not supported and are in works:
>  - icount for single stepping
>  - Virtualization of debug triggers
>  - kernel space debug triggers
>
> The SBI debug trigger extension can be found at:
> https://github.com/riscv-non-isa/riscv-sbi-doc/blob/master/src/ext-debug-=
triggers.adoc
>
> The Sdtrig ISA is part of RISC-V debug specification which can be
> found at:
> https://github.com/riscv/riscv-debug-spec
>
> based off the original RFC by Himanshu Chauhan here:
> https://lore.kernel.org/lkml/20240222125059.13331-1-hchauhan@ventanamicro=
.com/
>
> Second RFC by Jesse Taube here:
> https://lore.kernel.org/lkml/20250722173829.984082-1-jesse@rivosinc.com/
>
> Himanshu Chauhan (2):
>   riscv: Add SBI debug trigger extension and function ids
>   riscv: Introduce support for hardware break/watchpoints
>
> Jesse Taube (6):
>   riscv: Add insn.c, consolidate instruction decoding
>   riscv: insn: Add get_insn_nofault
>   riscv: hw_breakpoint: Use icount for single stepping
>   riscv: ptrace: Add hw breakpoint support
>   riscv: ptrace: Add hw breakpoint regset
>   selftests: riscv: Add test for hardware breakpoints
>
>  arch/riscv/Kconfig                            |   2 +
>  arch/riscv/include/asm/bug.h                  |  12 -
>  arch/riscv/include/asm/hw_breakpoint.h        |  59 ++
>  arch/riscv/include/asm/insn.h                 | 132 ++-
>  arch/riscv/include/asm/kdebug.h               |   3 +-
>  arch/riscv/include/asm/processor.h            |   4 +
>  arch/riscv/include/asm/sbi.h                  |  33 +-
>  arch/riscv/include/uapi/asm/ptrace.h          |   9 +
>  arch/riscv/kernel/Makefile                    |   2 +
>  arch/riscv/kernel/hw_breakpoint.c             | 763 ++++++++++++++++++
>  arch/riscv/kernel/insn.c                      | 165 ++++
>  arch/riscv/kernel/kgdb.c                      | 102 +--
>  arch/riscv/kernel/probes/kprobes.c            |   1 +
>  arch/riscv/kernel/process.c                   |   4 +
>  arch/riscv/kernel/ptrace.c                    | 169 ++++
>  arch/riscv/kernel/traps.c                     |  11 +-
>  arch/riscv/kernel/traps_misaligned.c          |  93 +--
>  include/uapi/linux/elf.h                      |   2 +
>  tools/include/uapi/linux/elf.h                |   1 +
>  tools/perf/tests/tests.h                      |   3 +-
>  tools/testing/selftests/riscv/Makefile        |   2 +-
>  .../selftests/riscv/breakpoints/.gitignore    |   1 +
>  .../selftests/riscv/breakpoints/Makefile      |  13 +
>  .../riscv/breakpoints/breakpoint_test.c       | 246 ++++++
>  24 files changed, 1641 insertions(+), 191 deletions(-)
>  create mode 100644 arch/riscv/include/asm/hw_breakpoint.h
>  create mode 100644 arch/riscv/kernel/hw_breakpoint.c
>  create mode 100644 arch/riscv/kernel/insn.c
>  create mode 100644 tools/testing/selftests/riscv/breakpoints/.gitignore
>  create mode 100644 tools/testing/selftests/riscv/breakpoints/Makefile
>  create mode 100644 tools/testing/selftests/riscv/breakpoints/breakpoint_=
test.c
>
> --
> 2.43.0
>

Oops, this meant to be V2.

Thanks,
Jesse Taube

