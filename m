Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADED1CA0EFC
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 14:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3AF56B00D0; Sun, 24 Aug 2025 10:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC1A6B00D1; Sun, 24 Aug 2025 10:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA276B00D2; Sun, 24 Aug 2025 10:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9331A6B00D0
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 10:52:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 35D2D1A0147
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:52:56 +0000 (UTC)
X-FDA: 83811943152.07.9CED053
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 104211C0002
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 14:52:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=g3uIzM1H;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of apatel@ventanamicro.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=apatel@ventanamicro.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756047174; a=rsa-sha256;
	cv=none;
	b=uFB52sWyoa0MLUsrfJV1DSiCS2QgRZpt86sBydSGpEBE6xVZOUwNrirXEIV+ikQkDOI6xR
	CUe00So4UsV/ivdwwKPR4wKwNlTPWCzl+ej/ln9SyIFklQX06ciIkDP3jua6XQxyNaF5JJ
	7WMPTFovkPC1qcltKzQQuMTFcRVfujo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=g3uIzM1H;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of apatel@ventanamicro.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=apatel@ventanamicro.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756047174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4yiekTKoDQWzy0n8EP+AHR0dj1abTnBc4Ihn4r+6Vw=;
	b=pi81/xPoMuBwA0oSykd2a1ZeBtxxbaybPy55/jlhzeDIoBryQfSnFhEtdyxicBmpzdOJ6S
	/S+g+IJZgzliE0VRvZhrqE3hdP5VJcR6uMQyHVg6/nZtB+H+XpkWkKOcjbGzAyY6xtXYPA
	j3aU6cNHUYetXHp0kFEmB3sKGXgD5ws=
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-333f7ebc44dso34834731fa.0
        for <linux-mm@kvack.org>; Sun, 24 Aug 2025 07:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1756047172; x=1756651972; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4yiekTKoDQWzy0n8EP+AHR0dj1abTnBc4Ihn4r+6Vw=;
        b=g3uIzM1HgmEE2u/OUEF83IPG+szKCFV9vcRqM/iZr/Cbhq7K6rg4+27Vyqn7VcGFGd
         L1pxvPOBE2yzKh+RHTOEVocJadZoWfBGl4NYa9EQ+ZY4T6fJr7ro4NnSEUb7585L4Y/C
         +sWY+r5bF8BZhfUr+WIcVYtFo5iS4elnt0aK6vqIl+i8MpH0Nd8iI7mi4Z0v6qt4er7U
         vBf6vK/7rjpsu2c1kLuEYXK+bddGUrntxIKtBEKUoKINchCJUDetw2mIJQO+kNPGHwBE
         +jAs+UML73P2D3n74Y9BCatjjyHu69pUZSvflNXC1a4Y0+Q9Uiw0GWoQuEx0JHkJbMq8
         /Ayw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756047172; x=1756651972;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/4yiekTKoDQWzy0n8EP+AHR0dj1abTnBc4Ihn4r+6Vw=;
        b=Vddrp5LriH3DCxOc3wiwVLeFdzZZw0UheKOrfKp5/xvRYlAMOJKFIS22d2H8t0fbM6
         T01k6xXp2zKw0FdKZaII8ky75DOfrpF38pgwrArMX20SLtPZJq8726+W1teb0mklmWcS
         /IPQgs2ZStl5Uts1ipuCZyBPEOm/1vfO36sGf5/xXBHYxz2Zk8oD4rvr9SLmBzvDVZ/3
         UPK7AtsKm4o5ONs1c1L7gXnoUxsM7C8I+1EMWKkexjawSXpJnknuDAlPlDXVmYnN3SYf
         PnbYA8xjZoSqoWnhaVsmM6m82gHwxzQGIWzraUOwF/WbkUacOnALABbTK0kXJFJVRk3y
         EM7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUS4f2fCBeLZJ02PFR+1MYm/UktPjhom08LU5BJ7xBOrtAnxi7B8dVpYQBsE5MyHaHtxjLlzzAcxA==@kvack.org
X-Gm-Message-State: AOJu0YzI7AtvpFsUuy5ddoxzlcshxpLyEe4m07F10X9jz5fW8193ZjQs
	aR5uQLeMabItb5j9mQyKDkbMlCRLwL+Sf2Mhg16hJusHy3yMydY0JSDZD1QFn2PuAGikylGh2cw
	WZs1aCs73DCO9ASnwkbfLxu5oOb5A8Xz3leFev+6/zg==
X-Gm-Gg: ASbGncuTwkohOzkBYfGrEdBbTYzAETPtjHsHt0iIQCFZyTXsOzKEEygucJdhHzchKyU
	Rn/fuT5r3CxWWYRJli59FvgWBNiqjUAO5BzlRnWbqPGDlJBAFl+C+Wr2lK7SQ8kVE0yDLznMu/6
	+0sFOpzl5jeKGXGLHO6mABcMrIsjYdSLa9ymDbhczYVXQthJRLWWdR9e9L2w/28MGOB6yq5AmsZ
	VFExyVa
X-Google-Smtp-Source: AGHT+IFlSfUi4X6ijV1KcvD3fMurgoahKrmOlnW8+1Y3fiDNHAUbP2L2C6YPP0B/jkjhjtlByXtWu2+fBdmkpiWV1lU=
X-Received: by 2002:a05:651c:41d0:b0:336:1526:7fe7 with SMTP id
 38308e7fff4ca-33615268269mr22774361fa.3.1756047171837; Sun, 24 Aug 2025
 07:52:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250822174715.1269138-1-jesse@rivosinc.com> <20250822174715.1269138-2-jesse@rivosinc.com>
In-Reply-To: <20250822174715.1269138-2-jesse@rivosinc.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Sun, 24 Aug 2025 20:22:39 +0530
X-Gm-Features: Ac12FXzI74g5Ug6WVcpL48bMqkkwTTrbHCPnUoKm2gxXKtW2DUam5Q_iJxl4QsU
Message-ID: <CAK9=C2VEiQsoy_G+kzVkZGVMcAJ-ioHcGQrRxpjuSh9aw66p0g@mail.gmail.com>
Subject: Re: [PATCH 1/8] riscv: Add insn.c, consolidate instruction decoding
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
X-Rspamd-Queue-Id: 104211C0002
X-Stat-Signature: c3grpfs1igxrt69finmyzkohceyfxrhu
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756047173-4334
X-HE-Meta: U2FsdGVkX18zOkyr/8H6cztZmdMCoFwEH88NcapOXRSKIivm+JYe/+68PcQUMSHC42/O/z/OuiImY+JO44TKP7XXufDjaTcM1xThexEPqVzVeXH4JuWYyP2qp6Ml4I7CqYdzTnCT42dPa46d9XPFwpKg3d0g2rQtX5GoLHw2nZd2RHn9uwd3mv8H0aH+7zC7WHbg2moqf3ZlISIgMUA+xEdFcHeewNMNVOjiCJECToR5Eu/wJZ5w8URKeP7A1AgEF9bH9OtZgLKEjFKP/g05XBNyVz6Mpa+wr1JmO1sipCYaatdyKAgjUHNBaYKs/Z4JJ4Fa0FGQFJ68x5vLHUGbBHr5AlxO2pu13hqblA/vTSOhWUCwhZyfqHb0X6TQQ5Ss/uunmLes9JCb+YmkUQT3fmnQG4tpgqw1ob2PVulMITYtOz4Eh0H9MwOc2jQPPY6nBW+vPXDglOI02wRb2kGSxqaJ5utafV++QR6ZaPmbQ/6CxCAY8nC51BL2zyOG+WK+qYIN4jMIvuLA2d5r/Acq3CB3TKkiyePlGx7TTrwgOGb9sabxQO4p27ciO1fd8iLkAVUM+tCsk6tt/ZN1lR7/FEsX46p+e1L6Nh6fo2MK0prdXxBtGC9cIksi9KT3/oMeh9q+PXRHLIVnxjlOu3i9meRUm3Z07NKOLHxrLJTt63Qkdywcsf8sJV2FBj82EJ/M/41ssFvl7csBRSITU/bm3wPHGOlaXfStVhLNzHwErX0bE+pS9m7OpkjY4ZOXPuJHS+sOB2Sc5p+3Lq1gUx2mG2kb8pIXmJ9kT2TTtxe7Syffp53wLu4cgveSF66oIl4BQDABrO+jUxFdMpPN5SAjFaoOY7FRx0umWgkT065vi3IxLStgL/oIac/7G95v3jCcBYSe+75v6zxc9N5TTqZVE2Ml2m+48Ct+1zWB5um9eE8rJyQMIfZTAHihanuBkxOvBNPvNu0akPlRCfIsvOb
 b1XCedmo
 xm915Hm5Su5HP4HJQpW5572Mwpih4TmI8Xn+K+DQB4IMMjTI7fMhmDeVatf15nTluoqEMx8kyaORHiajaCBOnD3qXVdsksUGvU+Ugs/+n/nzU83BxPPeWvHuOHmo3j/lzJ3GFIzLE9jE20oWPV651tsD+gwTyVJG7NobCxcC6FjHs0eivbmjliKrh9+FezmKjXhnKZjGjPVEnslzK8cgQiaGAskK7n8upVH7tX6bKDDdkWjospHQ/LovwVw==
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
> Various parts of the kernel decode and read instruction from memory.
> Functions like get_insn, GET_INSN_LENGTH and riscv_insn_is_c are defined
> in multiple places. Consolidate these functions into the insn.h and the
> newly added insn.c.
>
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> ---
> RFC -> V1:
>  - No change
> V2 -> V1:
>  - No change
> ---
>  arch/riscv/include/asm/bug.h         |  12 ---
>  arch/riscv/include/asm/insn.h        | 131 ++++++++++++++++++++++-
>  arch/riscv/kernel/Makefile           |   1 +
>  arch/riscv/kernel/insn.c             | 151 +++++++++++++++++++++++++++
>  arch/riscv/kernel/kgdb.c             | 102 +-----------------
>  arch/riscv/kernel/probes/kprobes.c   |   1 +
>  arch/riscv/kernel/traps.c            |   5 +-
>  arch/riscv/kernel/traps_misaligned.c |  93 ++++-------------
>  8 files changed, 309 insertions(+), 187 deletions(-)
>  create mode 100644 arch/riscv/kernel/insn.c
>
> diff --git a/arch/riscv/include/asm/bug.h b/arch/riscv/include/asm/bug.h
> index 1aaea81fb141..a2777eb67ad1 100644
> --- a/arch/riscv/include/asm/bug.h
> +++ b/arch/riscv/include/asm/bug.h
> @@ -12,21 +12,9 @@
>
>  #include <asm/asm.h>
>
> -#define __INSN_LENGTH_MASK  _UL(0x3)
> -#define __INSN_LENGTH_32    _UL(0x3)
> -#define __COMPRESSED_INSN_MASK _UL(0xffff)
> -
>  #define __BUG_INSN_32  _UL(0x00100073) /* ebreak */
>  #define __BUG_INSN_16  _UL(0x9002) /* c.ebreak */
>
> -#define GET_INSN_LENGTH(insn)                                          \
> -({                                                                     \
> -       unsigned long __len;                                            \
> -       __len =3D ((insn & __INSN_LENGTH_MASK) =3D=3D __INSN_LENGTH_32) ?=
     \
> -               4UL : 2UL;                                              \
> -       __len;                                                          \
> -})
> -
>  typedef u32 bug_insn_t;
>
>  #ifdef CONFIG_GENERIC_BUG_RELATIVE_POINTERS
> diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.=
h
> index 09fde95a5e8f..ba74e5b8262c 100644
> --- a/arch/riscv/include/asm/insn.h
> +++ b/arch/riscv/include/asm/insn.h
> @@ -64,6 +64,7 @@
>  #define RVG_RS2_OPOFF          20
>  #define RVG_RD_OPOFF           7
>  #define RVG_RS1_MASK           GENMASK(4, 0)
> +#define RVG_RS2_MASK           GENMASK(4, 0)
>  #define RVG_RD_MASK            GENMASK(4, 0)
>
>  /* The bit field of immediate value in RVC J instruction */
> @@ -121,17 +122,27 @@
>  #define RVC_C0_RS1_OPOFF       7
>  #define RVC_C0_RS2_OPOFF       2
>  #define RVC_C0_RD_OPOFF                2
> +#define RVC_C0_RS1_MASK                GENMASK(2, 0)
> +#define RVC_C0_RS2_MASK                GENMASK(2, 0)
> +#define RVC_C0_RD_MASK         GENMASK(2, 0)
> +#define RVC_C0_REG_OFFSET      8
>
>  /* The register offset in RVC op=3DC1 instruction */
>  #define RVC_C1_RS1_OPOFF       7
>  #define RVC_C1_RS2_OPOFF       2
>  #define RVC_C1_RD_OPOFF                7
> +#define RVC_C1_RS1_MASK                GENMASK(2, 0)
> +#define RVC_C1_RS2_MASK                GENMASK(2, 0)
> +#define RVC_C1_RD_MASK         GENMASK(2, 0)
> +#define RVC_C1_REG_OFFSET      8
>
>  /* The register offset in RVC op=3DC2 instruction */
>  #define RVC_C2_RS1_OPOFF       7
>  #define RVC_C2_RS2_OPOFF       2
>  #define RVC_C2_RD_OPOFF                7
>  #define RVC_C2_RS1_MASK                GENMASK(4, 0)
> +#define RVC_C2_RS2_MASK                GENMASK(4, 0)
> +#define RVC_C2_RD_MASK         GENMASK(4, 0)
>
>  /* parts of opcode for RVG*/
>  #define RVG_OPCODE_FENCE       0x0f
> @@ -226,12 +237,26 @@
>  #define RVC_MASK_C_EBREAK      0xffff
>  #define RVG_MASK_EBREAK                0xffffffff
>  #define RVG_MASK_SRET          0xffffffff
> +#define RVC_MASK_C             GENMASK(15, 0)
>
>  #define __INSN_LENGTH_MASK     _UL(0x3)
>  #define __INSN_LENGTH_GE_32    _UL(0x3)
>  #define __INSN_OPCODE_MASK     _UL(0x7F)
>  #define __INSN_BRANCH_OPCODE   _UL(RVG_OPCODE_BRANCH)
>
> +#define GET_INSN_LENGTH(insn)                                          \
> +({                                                                     \
> +       unsigned long __len;                                            \
> +       __len =3D ((insn & __INSN_LENGTH_MASK) =3D=3D __INSN_LENGTH_GE_32=
) ?  \
> +               4UL : 2UL;                                              \
> +       __len;                                                          \
> +})
> +
> +static __always_inline bool riscv_insn_is_c(u32 code)
> +{
> +       return (code & (__INSN_LENGTH_MASK)) !=3D (__INSN_LENGTH_GE_32);
> +}
> +
>  #define __RISCV_INSN_FUNCS(name, mask, val)                            \
>  static __always_inline bool riscv_insn_is_##name(u32 code)             \
>  {                                                                      \
> @@ -260,7 +285,7 @@ __RISCV_INSN_FUNCS(c_bnez, RVC_MASK_C_BNEZ, RVC_MATCH=
_C_BNEZ)
>  __RISCV_INSN_FUNCS(c_ebreak, RVC_MASK_C_EBREAK, RVC_MATCH_C_EBREAK)
>  __RISCV_INSN_FUNCS(ebreak, RVG_MASK_EBREAK, RVG_MATCH_EBREAK)
>  __RISCV_INSN_FUNCS(sret, RVG_MASK_SRET, RVG_MATCH_SRET)
> -__RISCV_INSN_FUNCS(fence, RVG_MASK_FENCE, RVG_MATCH_FENCE);
> +__RISCV_INSN_FUNCS(fence, RVG_MASK_FENCE, RVG_MATCH_FENCE)
>
>  /* special case to catch _any_ system instruction */
>  static __always_inline bool riscv_insn_is_system(u32 code)
> @@ -295,6 +320,10 @@ static __always_inline bool riscv_insn_is_c_jalr(u32=
 code)
>         ({typeof(x) x_ =3D (x); \
>         (RV_X(x_, RVG_RS1_OPOFF, RVG_RS1_MASK)); })
>
> +#define RV_EXTRACT_RS2_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RV_X(x_, RVG_RS2_OPOFF, RVG_RS2_MASK)); })
> +
>  #define RV_EXTRACT_RD_REG(x) \
>         ({typeof(x) x_ =3D (x); \
>         (RV_X(x_, RVG_RD_OPOFF, RVG_RD_MASK)); })
> @@ -322,9 +351,41 @@ static __always_inline bool riscv_insn_is_c_jalr(u32=
 code)
>         (RV_X(x_, RV_B_IMM_11_OPOFF, RV_B_IMM_11_MASK) << RV_B_IMM_11_OFF=
) | \
>         (RV_IMM_SIGN(x_) << RV_B_IMM_SIGN_OFF); })
>
> +#define RVC_EXTRACT_C0_RS1_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C0_RS1_OPOFF, RVC_C0_RS1_MASK)); })
> +
> +#define RVC_EXTRACT_C0_RS2_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C0_RS2_OPOFF, RVC_C0_RS2_MASK)); })
> +
> +#define RVC_EXTRACT_C0_RD_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C0_RD_OPOFF, RVC_C0_RD_MASK)); })
> +
> +#define RVC_EXTRACT_C1_RS1_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C1_RS1_OPOFF, RVC_C1_RS1_MASK)); })
> +
> +#define RVC_EXTRACT_C1_RS2_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C1_RS2_OPOFF, RVC_C1_RS2_MASK)); })
> +
> +#define RVC_EXTRACT_C1_RD_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C1_RD_OPOFF, RVC_C1_RD_MASK)); })
> +
>  #define RVC_EXTRACT_C2_RS1_REG(x) \
>         ({typeof(x) x_ =3D (x); \
> -       (RV_X(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
> +       (RVC_X(x_, RVC_C2_RS1_OPOFF, RVC_C2_RS1_MASK)); })
> +
> +#define RVC_EXTRACT_C2_RS2_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C2_RS2_OPOFF, RVC_C2_RS2_MASK)); })
> +
> +#define RVC_EXTRACT_C2_RD_REG(x) \
> +       ({typeof(x) x_ =3D (x); \
> +       (RVC_X(x_, RVC_C2_RD_OPOFF, RVC_C2_RD_MASK)); })
>
>  #define RVC_EXTRACT_JTYPE_IMM(x) \
>         ({typeof(x) x_ =3D (x); \
> @@ -354,6 +415,66 @@ static __always_inline bool riscv_insn_is_c_jalr(u32=
 code)
>
>  #define RVV_EXRACT_VL_VS_WIDTH(x) RVFDQ_EXTRACT_FL_FS_WIDTH(x)
>
> +/*
> + * Get the rs1 register number from RV or RVC instruction.
> + *
> + * @insn: instruction to process
> + * Return: rs1 register
> + */
> +static inline unsigned int riscv_insn_extract_rs1_reg(u32 insn)
> +{
> +       switch (RVC_INSN_OPCODE_MASK & insn) {
> +       case RVC_OPCODE_C0:
> +               return RVC_EXTRACT_C0_RS1_REG(insn) + RVC_C0_REG_OFFSET;
> +       case RVC_OPCODE_C1:
> +               return RVC_EXTRACT_C1_RS1_REG(insn) + RVC_C1_REG_OFFSET;
> +       case RVC_OPCODE_C2:
> +               return RVC_EXTRACT_C2_RS1_REG(insn);
> +       default:
> +               return RV_EXTRACT_RS1_REG(insn);
> +       }
> +}
> +
> +/*
> + * Get the rs2 register number from RV or RVC instruction.
> + *
> + * @insn: instruction to process
> + * Return: rs2 register
> + */
> +static inline unsigned int riscv_insn_extract_rs2_reg(u32 insn)
> +{
> +       switch (RVC_INSN_OPCODE_MASK & insn) {
> +       case RVC_OPCODE_C0:
> +               return RVC_EXTRACT_C0_RS2_REG(insn) + RVC_C0_REG_OFFSET;
> +       case RVC_OPCODE_C1:
> +               return RVC_EXTRACT_C1_RS2_REG(insn) + RVC_C1_REG_OFFSET;
> +       case RVC_OPCODE_C2:
> +               return RVC_EXTRACT_C2_RS2_REG(insn);
> +       default:
> +               return RV_EXTRACT_RS2_REG(insn);
> +       }
> +}
> +
> +/*
> + * Get the rd register number from RV or RVC instruction.
> + *
> + * @insn: instruction to process
> + * Return: rd register
> + */
> +static inline unsigned int riscv_insn_extract_rd_reg(u32 insn)
> +{
> +       switch (RVC_INSN_OPCODE_MASK & insn) {
> +       case RVC_OPCODE_C0:
> +               return RVC_EXTRACT_C0_RD_REG(insn) + RVC_C0_REG_OFFSET;
> +       case RVC_OPCODE_C1:
> +               return RVC_EXTRACT_C1_RD_REG(insn) + RVC_C1_REG_OFFSET;
> +       case RVC_OPCODE_C2:
> +               return RVC_EXTRACT_C2_RD_REG(insn);
> +       default:
> +               return RV_EXTRACT_RD_REG(insn);
> +       }
> +}
> +
>  /*
>   * Get the immediate from a J-type instruction.
>   *
> @@ -428,4 +549,10 @@ static inline void riscv_insn_insert_utype_itype_imm=
(u32 *utype_insn, u32 *itype
>         *utype_insn |=3D (imm & RV_U_IMM_31_12_MASK) + ((imm & BIT(11)) <=
< 1);
>         *itype_insn |=3D ((imm & RV_I_IMM_11_0_MASK) << RV_I_IMM_11_0_OPO=
FF);
>  }
> +
> +#include <asm/ptrace.h>
> +
> +int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn);
> +unsigned long get_step_address(struct pt_regs *regs, u32 code);
> +
>  #endif /* _ASM_RISCV_INSN_H */
> diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
> index f7480c9c6f8d..4f719b09e5ad 100644
> --- a/arch/riscv/kernel/Makefile
> +++ b/arch/riscv/kernel/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_RISCV_ALTERNATIVE) +=3D alternative.o
>  obj-y  +=3D cpu.o
>  obj-y  +=3D cpufeature.o
>  obj-y  +=3D entry.o
> +obj-y  +=3D insn.o
>  obj-y  +=3D irq.o
>  obj-y  +=3D process.o
>  obj-y  +=3D ptrace.o
> diff --git a/arch/riscv/kernel/insn.c b/arch/riscv/kernel/insn.c
> new file mode 100644
> index 000000000000..dd2a6ef9fd25
> --- /dev/null
> +++ b/arch/riscv/kernel/insn.c
> @@ -0,0 +1,151 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2025 Rivos, Inc
> + */
> +#include <asm/insn.h>
> +#include <asm/ptrace.h>
> +#include <asm/uaccess.h>
> +
> +#define __read_insn(regs, insn, insn_addr, type)       \
> +({                                                     \
> +       int __ret;                                      \
> +                                                       \
> +       if (user_mode(regs)) {                          \
> +               __ret =3D get_user(insn, (type __user *) insn_addr); \
> +       } else {                                        \
> +               insn =3D *(type *)insn_addr;              \
> +               __ret =3D 0;                              \
> +       }                                               \
> +                                                       \
> +       __ret;                                          \
> +})
> +
> +/*
> + * Update a set of two instructions (U-type + I-type) with an immediate =
value.
> + *
> + * Used for example in auipc+jalrs pairs the U-type instructions contain=
s
> + * a 20bit upper immediate representing bits[31:12], while the I-type
> + * instruction contains a 12bit immediate representing bits[11:0].
> + *
> + * This also takes into account that both separate immediates are
> + * considered as signed values, so if the I-type immediate becomes
> + * negative (BIT(11) set) the U-type part gets adjusted.
> + *
> + * @regs: pointer to the utype instruction of the pair
> + * @epc: pointer to the itype instruction of the pair
> + * @r_insn: the immediate to insert into the two instructions
> + * Return: combined immediate
> + */
> +int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn)
> +{
> +       ulong insn =3D 0;
> +
> +       if (epc & 0x2) {
> +               ulong tmp =3D 0;
> +
> +               if (__read_insn(regs, insn, epc, u16))
> +                       return -EFAULT;
> +               /* __get_user() uses regular "lw" which sign extend the l=
oaded
> +                * value make sure to clear higher order bits in case we =
"or" it
> +                * below with the upper 16 bits half.
> +                */
> +               insn &=3D RVC_MASK_C;
> +               if (riscv_insn_is_c(insn)) {
> +                       *r_insn =3D insn;
> +                       return 0;
> +               }
> +               epc +=3D sizeof(u16);
> +               if (__read_insn(regs, tmp, epc, u16))
> +                       return -EFAULT;
> +               *r_insn =3D (tmp << 16) | insn;
> +
> +               return 0;
> +       } else {
> +               if (__read_insn(regs, insn, epc, u32))
> +                       return -EFAULT;
> +               if (!riscv_insn_is_c(insn)) {
> +                       *r_insn =3D insn;
> +                       return 0;
> +               }
> +               insn &=3D RVC_MASK_C;
> +               *r_insn =3D insn;
> +
> +               return 0;
> +       }
> +}
> +
> +/* Calculate the new address for after a step */
> +unsigned long get_step_address(struct pt_regs *regs, u32 code)
> +{
> +       unsigned long pc =3D regs->epc;
> +       unsigned int rs1_num, rs2_num;
> +
> +       if ((code & __INSN_LENGTH_MASK) !=3D __INSN_LENGTH_GE_32) {
> +               if (riscv_insn_is_c_jalr(code) ||
> +                   riscv_insn_is_c_jr(code)) {
> +                       rs1_num =3D riscv_insn_extract_rs1_reg(code);
> +                       return regs_get_register(regs, rs1_num);
> +               } else if (riscv_insn_is_c_j(code) ||
> +                          riscv_insn_is_c_jal(code)) {
> +                       return RVC_EXTRACT_JTYPE_IMM(code) + pc;
> +               } else if (riscv_insn_is_c_beqz(code)) {
> +                       rs1_num =3D riscv_insn_extract_rs1_reg(code);
> +                       if (!rs1_num || regs_get_register(regs, rs1_num) =
=3D=3D 0)
> +                               return RVC_EXTRACT_BTYPE_IMM(code) + pc;
> +                       else
> +                               return pc + 2;
> +               } else if (riscv_insn_is_c_bnez(code)) {
> +                       rs1_num =3D riscv_insn_extract_rs1_reg(RVC_C1_RS1=
_OPOFF);
> +                       if (rs1_num && regs_get_register(regs, rs1_num) !=
=3D 0)
> +                               return RVC_EXTRACT_BTYPE_IMM(code) + pc;
> +                       else
> +                               return pc + 2;
> +               } else {
> +                       return pc + 2;
> +               }
> +       } else {
> +               if ((code & __INSN_OPCODE_MASK) =3D=3D __INSN_BRANCH_OPCO=
DE) {
> +                       bool result =3D false;
> +                       long imm =3D RV_EXTRACT_BTYPE_IMM(code);
> +                       unsigned long rs1_val =3D 0, rs2_val =3D 0;
> +
> +                       rs1_num =3D riscv_insn_extract_rs1_reg(code);
> +                       rs2_num =3D riscv_insn_extract_rs2_reg(code);
> +                       if (rs1_num)
> +                               rs1_val =3D regs_get_register(regs, rs1_n=
um);
> +                       if (rs2_num)
> +                               rs2_val =3D regs_get_register(regs, rs2_n=
um);
> +
> +                       if (riscv_insn_is_beq(code))
> +                               result =3D (rs1_val =3D=3D rs2_val) ? tru=
e : false;
> +                       else if (riscv_insn_is_bne(code))
> +                               result =3D (rs1_val !=3D rs2_val) ? true =
: false;
> +                       else if (riscv_insn_is_blt(code))
> +                               result =3D
> +                                   ((long)rs1_val <
> +                                    (long)rs2_val) ? true : false;
> +                       else if (riscv_insn_is_bge(code))
> +                               result =3D
> +                                   ((long)rs1_val >=3D
> +                                    (long)rs2_val) ? true : false;
> +                       else if (riscv_insn_is_bltu(code))
> +                               result =3D (rs1_val < rs2_val) ? true : f=
alse;
> +                       else if (riscv_insn_is_bgeu(code))
> +                               result =3D (rs1_val >=3D rs2_val) ? true =
: false;
> +                       if (result)
> +                               return imm + pc;
> +                       else
> +                               return pc + 4;
> +               } else if (riscv_insn_is_jal(code)) {
> +                       return RV_EXTRACT_JTYPE_IMM(code) + pc;
> +               } else if (riscv_insn_is_jalr(code)) {
> +                       rs1_num =3D riscv_insn_extract_rs1_reg(code);
> +                       return RV_EXTRACT_ITYPE_IMM(code) +
> +                              (rs1_num ? regs_get_register(regs, rs1_num=
) : 0);
> +               } else if (riscv_insn_is_sret(code)) {
> +                       return pc;
> +               } else {
> +                       return pc + 4;
> +               }
> +       }
> +}
> diff --git a/arch/riscv/kernel/kgdb.c b/arch/riscv/kernel/kgdb.c
> index 9f3db3503dab..aafc1424fc81 100644
> --- a/arch/riscv/kernel/kgdb.c
> +++ b/arch/riscv/kernel/kgdb.c
> @@ -23,111 +23,19 @@ enum {
>  static unsigned long stepped_address;
>  static unsigned int stepped_opcode;
>
> -static int decode_register_index(unsigned long opcode, int offset)
> -{
> -       return (opcode >> offset) & 0x1F;
> -}
> -
> -static int decode_register_index_short(unsigned long opcode, int offset)
> -{
> -       return ((opcode >> offset) & 0x7) + 8;
> -}
> -
> -/* Calculate the new address for after a step */
> -static int get_step_address(struct pt_regs *regs, unsigned long *next_ad=
dr)
> -{
> -       unsigned long pc =3D regs->epc;
> -       unsigned long *regs_ptr =3D (unsigned long *)regs;
> -       unsigned int rs1_num, rs2_num;
> -       int op_code;
> -
> -       if (get_kernel_nofault(op_code, (void *)pc))
> -               return -EINVAL;
> -       if ((op_code & __INSN_LENGTH_MASK) !=3D __INSN_LENGTH_GE_32) {
> -               if (riscv_insn_is_c_jalr(op_code) ||
> -                   riscv_insn_is_c_jr(op_code)) {
> -                       rs1_num =3D decode_register_index(op_code, RVC_C2=
_RS1_OPOFF);
> -                       *next_addr =3D regs_ptr[rs1_num];
> -               } else if (riscv_insn_is_c_j(op_code) ||
> -                          riscv_insn_is_c_jal(op_code)) {
> -                       *next_addr =3D RVC_EXTRACT_JTYPE_IMM(op_code) + p=
c;
> -               } else if (riscv_insn_is_c_beqz(op_code)) {
> -                       rs1_num =3D decode_register_index_short(op_code,
> -                                                             RVC_C1_RS1_=
OPOFF);
> -                       if (!rs1_num || regs_ptr[rs1_num] =3D=3D 0)
> -                               *next_addr =3D RVC_EXTRACT_BTYPE_IMM(op_c=
ode) + pc;
> -                       else
> -                               *next_addr =3D pc + 2;
> -               } else if (riscv_insn_is_c_bnez(op_code)) {
> -                       rs1_num =3D
> -                           decode_register_index_short(op_code, RVC_C1_R=
S1_OPOFF);
> -                       if (rs1_num && regs_ptr[rs1_num] !=3D 0)
> -                               *next_addr =3D RVC_EXTRACT_BTYPE_IMM(op_c=
ode) + pc;
> -                       else
> -                               *next_addr =3D pc + 2;
> -               } else {
> -                       *next_addr =3D pc + 2;
> -               }
> -       } else {
> -               if ((op_code & __INSN_OPCODE_MASK) =3D=3D __INSN_BRANCH_O=
PCODE) {
> -                       bool result =3D false;
> -                       long imm =3D RV_EXTRACT_BTYPE_IMM(op_code);
> -                       unsigned long rs1_val =3D 0, rs2_val =3D 0;
> -
> -                       rs1_num =3D decode_register_index(op_code, RVG_RS=
1_OPOFF);
> -                       rs2_num =3D decode_register_index(op_code, RVG_RS=
2_OPOFF);
> -                       if (rs1_num)
> -                               rs1_val =3D regs_ptr[rs1_num];
> -                       if (rs2_num)
> -                               rs2_val =3D regs_ptr[rs2_num];
> -
> -                       if (riscv_insn_is_beq(op_code))
> -                               result =3D (rs1_val =3D=3D rs2_val) ? tru=
e : false;
> -                       else if (riscv_insn_is_bne(op_code))
> -                               result =3D (rs1_val !=3D rs2_val) ? true =
: false;
> -                       else if (riscv_insn_is_blt(op_code))
> -                               result =3D
> -                                   ((long)rs1_val <
> -                                    (long)rs2_val) ? true : false;
> -                       else if (riscv_insn_is_bge(op_code))
> -                               result =3D
> -                                   ((long)rs1_val >=3D
> -                                    (long)rs2_val) ? true : false;
> -                       else if (riscv_insn_is_bltu(op_code))
> -                               result =3D (rs1_val < rs2_val) ? true : f=
alse;
> -                       else if (riscv_insn_is_bgeu(op_code))
> -                               result =3D (rs1_val >=3D rs2_val) ? true =
: false;
> -                       if (result)
> -                               *next_addr =3D imm + pc;
> -                       else
> -                               *next_addr =3D pc + 4;
> -               } else if (riscv_insn_is_jal(op_code)) {
> -                       *next_addr =3D RV_EXTRACT_JTYPE_IMM(op_code) + pc=
;
> -               } else if (riscv_insn_is_jalr(op_code)) {
> -                       rs1_num =3D decode_register_index(op_code, RVG_RS=
1_OPOFF);
> -                       if (rs1_num)
> -                               *next_addr =3D ((unsigned long *)regs)[rs=
1_num];
> -                       *next_addr +=3D RV_EXTRACT_ITYPE_IMM(op_code);
> -               } else if (riscv_insn_is_sret(op_code)) {
> -                       *next_addr =3D pc;
> -               } else {
> -                       *next_addr =3D pc + 4;
> -               }
> -       }
> -       return 0;
> -}
> -
>  static int do_single_step(struct pt_regs *regs)
>  {
>         /* Determine where the target instruction will send us to */
> -       unsigned long addr =3D 0;
> -       int error =3D get_step_address(regs, &addr);
> +       unsigned long addr, insn;
> +       int error =3D get_insn(regs, regs->epc, &insn);
>
>         if (error)
>                 return error;
>
> +       addr =3D get_step_address(regs, insn);
> +
>         /* Store the op code in the stepped address */
> -       error =3D get_kernel_nofault(stepped_opcode, (void *)addr);
> +       error =3D get_insn(regs, addr, stepped_opcode);

This line gives following compile error:

     arch/riscv/kernel/kgdb.c: In function 'do_single_step':
     arch/riscv/kernel/kgdb.c:38:38: error: passing argument 3 of
'get_insn' makes pointer from integer without a cast
[-Wint-conversion]
        38 |         error =3D get_insn(regs, addr, stepped_opcode);
           |                                      ^~~~~~~~~~~~~~
           |                                      |
           |                                      unsigned int
     In file included from arch/riscv/kernel/kgdb.c:14:
     ./arch/riscv/include/asm/insn.h:555:54: note: expected 'ulong *'
{aka 'long unsigned int *'} but argument is of type 'unsigned int'
       555 | int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn);
           |                                               ~~~~~~~^~~~~~

If you are touching some source then at least compile test it.

Regards,
Anup

