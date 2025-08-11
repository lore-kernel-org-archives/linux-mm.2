Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FA7C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B938E0029; Mon, 11 Aug 2025 05:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6635A8E000A; Mon, 11 Aug 2025 05:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5796D8E0029; Mon, 11 Aug 2025 05:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 454588E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:41:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E477EBB297
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:41:42 +0000 (UTC)
X-FDA: 83763984444.30.EE02167
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id E11FF1C0009
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:41:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=Ca6z8KaK;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of apatel@ventanamicro.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=apatel@ventanamicro.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cy59ORjyXtIVFFgfYeqm1wmJyEdmnPmaEOXMVqFckn4=;
	b=UxtPoCwpQKy2MyS8iXmmlPMf/xzG6cwDdpBQJXkLUJK4j1o4ATjuDpm75bOdugEPIQBeRX
	bq+jljWF4FeI6o7TUGtPMWx1d07SQ345d0OnA+APqNOLnxI4C/WJIi07cNmmMuBju03EcG
	Zj8nxiAThg7AcfJ+10y+9a0Bo5yR3Gk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905301; a=rsa-sha256;
	cv=none;
	b=XRh59jtKsMSqMJ9mQbmdc7LMpKqM4093TFPr0Li4D9bFFKWcApaysDDLb5aYiDBGOqmDZ0
	vwkcHPXX81oY84MkmZij5oRl73+0k5r3Rvq9gr4aiBdNXg9BcMe2P0MKSDIoVU1H9CU6m8
	yYwVfkG8pZeFS1dFRigx2gZwmTsxzvE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=Ca6z8KaK;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of apatel@ventanamicro.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=apatel@ventanamicro.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-55b85d01b79so4312281e87.3
        for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1754905299; x=1755510099; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cy59ORjyXtIVFFgfYeqm1wmJyEdmnPmaEOXMVqFckn4=;
        b=Ca6z8KaKfeuhvvCpQcu8U+BeZXD/MKS7nYvUKDuuJNa4DfeKwUn1eiLitBEcbIfCKz
         UgwR0ZI1YmztCG5fNbQJeR+PGkmZLQjfPQyUiZXxtGyfHnFBQdRfYFqQ9qBNacNTxFtM
         oOrU2rVJ1teGrUUV2yA9fAVgxnxHiDJgmExRSmSOyfHVq4pdozowucH7vmGz6YwAUV4F
         OizcvMKJTHjA1wx0qvLIHjc/6cSDl95yJxOW09orn903jdKFlbtbwTfZ0f6JPjxT7zDe
         SQIwwmIcNh/QghUsnTmM2D/o4MhGYB50TBpgWDf/1Oiqj3Drpw9+aJd4+NZZUTixT9Zf
         QPQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754905299; x=1755510099;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cy59ORjyXtIVFFgfYeqm1wmJyEdmnPmaEOXMVqFckn4=;
        b=Ov1YEel3hc9ndfVY56wHHDXxn2W/iE/Y3RO5A6IquzX//YoAVQUUESmiPSVyorMvZn
         ypYmKg4Ey0RsAtFqb2uikTWpIINTx29cUyUsKTTgD8+lSaJ3vMScF3IMDWAIGEjDbdbV
         4MWxCA6w/Wvw2Q4iBEK5y+SNHWe6Y5BTP+ViEY7UZQrMkFNcebjKzm3VFX117rZaNns2
         TSmRxUZK/EXnl5GQCtAoq/vkZGABLhhOsTcwbTv4/Vhdd0y4GXbm730r+JYy5USPrU0T
         S75FtQfc/DWH1onxT2aJJQW40zHuviVrhYbap7LLQGLYgAvh7rQcujZepViLx05QeD21
         yluw==
X-Forwarded-Encrypted: i=1; AJvYcCU3wmfVcZjHxMiFByXWjMojPuDOtmh9PWpS6ytEmD4tPPmVpb22flOCiBVVpviWEQeTFAP+3JiG+w==@kvack.org
X-Gm-Message-State: AOJu0YxXMTOF+zIQS/ACS4Z8kZEwwIligBv2rfXmEwvATOI8uG3EKHEd
	J8wJ2SHLEjgS4srDInLYfg+KZMXfgOgvMx6kGSAIPN0XtNEINa6evbZsy51T2Q/PE57eylCVrFz
	oClMO/wGCiczthGVz29x2C+6oyfg6Jhxbsspco8Sxpw==
X-Gm-Gg: ASbGncvX6b13EjhP7jXcDtGD9c+bkmV2PGLKkZc4yJ4983TQOI5QTJ3pf0XxOVNz2hh
	T8vtreUFfYNW3ix92ubXJ2Xu1a2fmhn2jkYXe3tauN9/etrcD1Q7u6OO/TPW+vLTdL130EPEzeQ
	YYbR/dm6Cmj5bZ9Rr9Y4LCYWB/B3TZ8tlbC9WC3rPM31D3gvOQaO1rWcUzJEkQEZKSXiy980S8G
	MkfQ1fP/4OM8PuFs9g=
X-Google-Smtp-Source: AGHT+IGmUn3ZM7jBX7D1YyhKjvaPN2e4dHa6K9n92Zz8n8QotO81v1sGyRseqSkkKtsFNnDYwv8ehf88vLMTTISTp9c=
X-Received: by 2002:a05:6512:2316:b0:553:3a0a:1892 with SMTP id
 2adb3069b0e04-55cc008637dmr3351518e87.15.1754905298946; Mon, 11 Aug 2025
 02:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250805193955.798277-1-jesse@rivosinc.com> <20250805193955.798277-6-jesse@rivosinc.com>
In-Reply-To: <20250805193955.798277-6-jesse@rivosinc.com>
From: Anup Patel <apatel@ventanamicro.com>
Date: Mon, 11 Aug 2025 15:11:27 +0530
X-Gm-Features: Ac12FXzX2WBI8Efn8ZEvJJb1ujk-ZIhK3W3ZYl12yeFcZ1SpyaqkJna1l4oNLS8
Message-ID: <CAK9=C2X2J4ROJ7nKB0hcD9dVav7ZMFWw2Qy+GEsmYN_Tt8DxPQ@mail.gmail.com>
Subject: Re: [PATCH 5/8] riscv: hw_breakpoint: Use icount for single stepping
To: Jesse Taube <jesse@rivosinc.com>
Cc: linux-riscv@lists.infradead.org, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	"Liang, Kan" <kan.liang@linux.intel.com>, Shuah Khan <shuah@kernel.org>, 
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
	Akihiko Odaki <akihiko.odaki@daynix.com>, Ravi Bangoria <ravi.bangoria@amd.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mb3zgdqpcfwyd5gwd5oixrj74ss4t3xb
X-Rspamd-Queue-Id: E11FF1C0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754905300-924430
X-HE-Meta: U2FsdGVkX1+zCyV6TOLta6i3n3EZmEElRw9RYj/gu583yNVUBaAMJpPfc65lBE4rEkixG1hLAIc0ln2JQcAzYjYtGx0kPiRxX54pdSeZzK6CuoX9qDuCfl9S31xZaTcaB+RQvkvTXeeDbRMMstzAzW/1aoWQcmwNL72HKpQDAIl5Ff481WJxcAvCY93o2EnDxy/bDuBVYkBwQrb8N09TylieKkSZBCldU2DQZYxLFytvJ1BFJR3hDTlNtTZpuYswtK2mfaj5u35mN1JJdd3+1StMFSnuvjKcA9jbbxyRWvBb8qROQzoU/20orG9Hnu/f5nrCmBFicoYFvXOPpsDFrXnCDRzrHA5G2zwwljkdkAKaqMBC3PTREs+lpqavsxl8ehuv9qGAHxuBJHfqo4H2KAAFVBW4o7R2xjjNRT4TRET7Z0r9KeIrfXVUHbE/xkRQjTq6ZtmO4VS0LlSJb3COPntzLyyo6Okclb14sU6Uh0MvRD+p84U2d1bxBjrGf466zN8be/s0Orbn2vCsJLrIass+g2UG/i2IEJidh2qsnJcCmg/9P0ZQiiBwNp001blEdqW9Z5jAyTLid5dgeHqCrmVVNmM3/VNLoUqBCN/AC/4fyIxaZdlqLjPc11PmzLOIvMSndpDV8yaCT3pl4BJ8hV9nHDmwAQHOU6sL0dFYuTkyvw2NBrgbJxDMyPfU82C7xxxFAw0DSzJQJahNsfBBrIe2rJUYt2DjLM1qJRB+HVZThCqr4gAkpIT8rr8BKdUm8+2MkJpxV5tf1LPXvIC/SLvoHrnbrQB//oZliKPEmsTmcmRUIAbQXmMS2Dr/qPOvxLaypv5k+QqJlWAHkPTSRNVetOP04n4wuBHydVutyovIZI15HK6zfXDy9Uludm6ii6E/JEWAPWj/uMna/F/oHxTEG93Kya8cQVD9bG6ZPmrhX9fY7b479WAB4/xrBD8uBtqGWYjXq+6bqFjEzrF
 +Sx8LIcf
 bicIgQDBWWLnMfcx2R6pe3pfwykDGlo2zpLleI1d9DeqLfg6/COpc1gaads9iH8boDF3kOl68mWu2KnfTxzKa3U2zxgMGFLas08QmFF7ihohZBW8G7ZmfAvyNwinr5maPoOQ1x3YfuYxT+zQKhW6y3HuJIHT47ZkWlUHI837q7+Aqbhrezos+dqZyOYMizRuRH2QlrxQyYNlGMGFZD/nQ/NsiUqkR09uDmIsF0tu97+plVy0xF7BfQ4WPCymt12gP/LkbdcFWuZT9cBTIFuYINZhowJkDnqR8JUDGSAmxxMpo7S3vNCaasaJAFUoZPMgIVU0Vy6+qOrA8Pg9s3V7z3KuxWPJuxyIQaocVd0r4ABtOz5A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jesse,

On Wed, Aug 6, 2025 at 1:10=E2=80=AFAM Jesse Taube <jesse@rivosinc.com> wro=
te:
>
> The Sdtrig RISC-V ISA extension does not have a resume flag for
> returning to and executing the instruction at the breakpoint.
> To avoid skipping the instruction or looping, it is necessary to remove
> the hardware breakpoint and single step. Use the icount feature of
> Sdtrig to accomplish this. Use icount as default with an option to allow
> software-based single stepping when hardware or SBI does not have
> icount functionality, as it may cause unwanted side effects when reading
> the instruction from memory.
>
> Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> ---
> OpenSBI implementation of sbi_debug_read_triggers does not return the
> updated CSR values. There needs to be a check for working
> sbi_debug_read_triggers before this works.
>
> https://lists.riscv.org/g/tech-prs/message/1476
>
> RFC -> V1:
>  - Add dbtr_mode to rv_init_icount_trigger
>  - Add icount_triggered to check which breakpoint was triggered
>  - Fix typo: s/affects/effects
>  - Move HW_BREAKPOINT_COMPUTE_STEP to Platform type
> ---
>  arch/riscv/Kconfig                |  11 ++
>  arch/riscv/kernel/hw_breakpoint.c | 179 +++++++++++++++++++++++++++---
>  2 files changed, 172 insertions(+), 18 deletions(-)
>
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index fd8b62cdc6f5..37f01ed199f3 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -546,6 +546,17 @@ config RISCV_COMBO_SPINLOCKS
>
>  endchoice
>
> +config HW_BREAKPOINT_COMPUTE_STEP
> +       bool "Allow computing hardware breakpoint step address"
> +       default n
> +       depends on HAVE_HW_BREAKPOINT
> +       help
> +         Select this option if hardware breakpoints are desired, but
> +         hardware or SBI does not have icount functionality. This may ca=
use
> +         unwanted side effects when reading the instruction from memory.
> +
> +         If unsure, say N.
> +

We expect the same kernel image to work on a platform with
icount triggers and without icount triggers.

Please drop this kconfig option. The decision of falling back to
computing hardware breakpoint step address should be at
boot-time and not compile-time.

Regards,
Anup

