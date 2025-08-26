Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FBEECA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 04:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3778E0096; Tue, 26 Aug 2025 00:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373798E0090; Tue, 26 Aug 2025 00:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23C9E8E0096; Tue, 26 Aug 2025 00:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0BB8E0090
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 00:38:19 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 68AAE118CBE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:38:18 +0000 (UTC)
X-FDA: 83817651876.09.BBDA237
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 809592000C
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:38:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=m5f2yWQ9;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of hchauhan@ventanamicro.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=hchauhan@ventanamicro.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756183096; a=rsa-sha256;
	cv=none;
	b=LG8KbHS1QXLeExiKulqOwvgTBYTrCYDNWovKw+TukFlBlMqOYmSLe+Ejc7IrNPaKEP23EB
	/4He08f7N295Oib2RaJW8XRhTwqJ3eVImN3dTi6dqDYAyX3R6wCQGp2MYcxFRyMZy5fw/J
	7T/OWQACW1nujXD7ocadWGfYAn+sfmM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ventanamicro.com header.s=google header.b=m5f2yWQ9;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of hchauhan@ventanamicro.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=hchauhan@ventanamicro.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756183096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFgnn+/KkXNVaL/+B3uRwl6TtlDHiFj4dBOMY55dlhY=;
	b=ihaQetgPkvuHyKGY8J35aT2xCXWK69P/WblBOWEPIB+heftVfIqSDcZxGircKDJCVOpu4W
	AuM7OpY9BMXHzW41MlvWVbDAQPSfLkV0DwlnoWfVAqCibKr4LrIjcRsV9cJkDDGaUA3u9n
	5DrP2lGjbFomykMhe5nwFt8YQ/405ro=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b109912545so67921551cf.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 21:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1756183095; x=1756787895; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFgnn+/KkXNVaL/+B3uRwl6TtlDHiFj4dBOMY55dlhY=;
        b=m5f2yWQ9DVC4y6esJViRzj6Rt/Vx3duOAIBGP/UtEizzQYq9JoofbQWbNXanguyX2E
         0pVK9SHdueWE/dIDQlOxD06a4umHdXg5AN9pRPzlJCkgt/jxKxEORK44+hF6ArAw3EqU
         +dIQzSZeR49NsBORcUTzxXrNBuMN3M215M+Q8XlUsE5L+1NZvkNtjsQGUVFfjAYkRtUB
         F7kLBPloJyQM+eGJpKuwpmQzDYLeoRoR1bt80WW6gGrforow3Qpbaj8Xdqi32Lnezpyh
         1MVLoIW3MDU0laZ/90RCEph8iAUEY1jafMFsNNGpDdk/8utN3yJAZHR0kselZZJKV+ZN
         iKSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756183095; x=1756787895;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pFgnn+/KkXNVaL/+B3uRwl6TtlDHiFj4dBOMY55dlhY=;
        b=H/1c9TJ1Wn123HStceeRfPJaXeWK4ADNfvwxb9ICKz+2JRuB6wQ7W1dl9XYjPieZ/t
         ezES3N1XVqwYyrAWHA2D/GBpt9xVX9VTyNauB+d0iREiX5paHjC1yUa1XHLtcNID5mtH
         o2+HZimQjM7OCrw5kEk/7IwYNUJv23KYnjVumzi08vcky+GhNaoHvQ3eYvV4hswScXBe
         /7WVJYg0NSnwy+94lsCc1wOPpBLqyDAKMs7EURoPWdFyaTR5R8tq/wpZZ16udKcbuKng
         BZxlIwvqilZpBISzmbVPfZYvDaCUazsz1z0saxPu8SEarkGHcTOl5RnIxeu7IQSynoHw
         BJCA==
X-Forwarded-Encrypted: i=1; AJvYcCXza5LKy3qBdpo/IdIIWEVkXOqjT1xQaWjioIWy0bd03V+ZHWSd1L81TjyC/PXfE7Jj2LZ2nOdWbA==@kvack.org
X-Gm-Message-State: AOJu0YxGBg9xUeNdQbiNoG+NAc/ohsO8BQPZYKKr6g2yFb+KQ0v3XjAF
	12UAMehhVnEnBDqiP5l9Kx2/8hzbqIC4CaZcVHUyY73gDNw950YCzVKQTnczhLoOMNrvH6BxSqe
	6yS7fSag9z4jnxTREEp+FtdA326YAlW1r6cAcIFRoOg==
X-Gm-Gg: ASbGncv+473NbAK+Hp3c275gLUVjDmwtvD9mcOtqOb0L6Vf/svX1Zv6w2FpOMk9bMjd
	KGiwoKkd6gMZ0s2P+DJmYXy2Ife/qiusWKkTv/qz6eeeqvq6aHDpOWh/kFxQ2rEifRvA0Z57pep
	W322cEpAhqoAdMmlwZx5vZIrAueNMhlkuty73RGUzszreJvElgBFx/PBbcYuQRVdbTk3B2+cT1U
	GBk
X-Google-Smtp-Source: AGHT+IHEa8+pSI1Wy0Fw7b+dsO/b6DhMiB4aK96KXN4AsIVMUjL2PWvpxHoNQpi2wUkC4qjdixdxGk6/65/eeyTbpoI=
X-Received: by 2002:a05:622a:1818:b0:4af:1cd4:d782 with SMTP id
 d75a77b69052e-4b2aaad2b0dmr171048541cf.45.1756183095317; Mon, 25 Aug 2025
 21:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250822174715.1269138-1-jesse@rivosinc.com> <20250822174715.1269138-6-jesse@rivosinc.com>
In-Reply-To: <20250822174715.1269138-6-jesse@rivosinc.com>
From: Himanshu Chauhan <hchauhan@ventanamicro.com>
Date: Tue, 26 Aug 2025 10:08:04 +0530
X-Gm-Features: Ac12FXyOy-huds2B1fJwOJPw53ZPIRvf9djC3OVxcNJyBPYY2odcHNK5kYVsNfY
Message-ID: <CAPd4Wexw_DtndDqRZzXK0PEOAkb4yWB4x8rf5eRdJOLMS-+8SQ@mail.gmail.com>
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
	Liang Kan <kan.liang@linux.intel.com>, Shuah Khan <shuah@kernel.org>, 
	Charlie Jenkins <charlie@rivosinc.com>, Samuel Holland <samuel.holland@sifive.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Deepak Gupta <debug@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Anup Patel <apatel@ventanamicro.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
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
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 809592000C
X-Stat-Signature: j7jg6byubak8q9p4aoiyzuzh3ap3drzg
X-HE-Tag: 1756183096-351640
X-HE-Meta: U2FsdGVkX18yrNsG22A3q6uc7MmOpBNXtHorZLL6zV4fptUjgrNkTSl484qTK/gOTGAl+Rtkeu2PBWW6N6mbENN5qg6pNghqWj7nqok8xqhO8ggF/QC1EIXq3yKKCwUgk6ukKYlElaTDZ3po7YPukIo5XN+aMpHfY5JFRgQCHUu5SHzD+5XNvYC2qSDfabjtNboE2P9u3upbQMjMJUYNXb7YEU544h56cPH9zp0b54PpDEILRh0lga+JIhewWSprP4+G/YpM5o7a8VYtmyz3twUT41sX+2JrGrQIpeaFwHYiIBzvkvW5YgbbQ2QiCZAehsJQkBKaYg6DptcIuPOvFS0cPFQOImn/wbqml9YvsPvJYWfiAznDt1YytH1H8YJqc5zlJjJ2daOIGXs4lf98Ur6ISxpps8BsA9KziQLZr+eU7KTDKDv2tXLySo/et4fWkmVdXVmO+XxqLjs+ecObeSMRmiWODQMDFmLgOlqFlvpvjA/UsNQcLLroxsU5464cK30yxO8yB+O1m1VtZqOCoxDv29e15sm+f3aSyC72a7S+oydZXRv7CPIECEu8BX9CYeFyI01lc3WCWkhJ0B4GgN8IMoY3Men9AINcckyyt/PVppM16VY3Z05SquPNxk4+6PiErIxACKvoHhtycb0WBBa4YUR2IlQVyUKCEJ0qjJ1y4e6I52I7iHGI6rDbfhh15RYLOUSd8q6GdUg6AGZU6FMlAZMoaJId0YGV0EXvv4tXn3iERwjyjwl+u3h5rpi8q9OQ0in71NYNuiE7wN+wXMAOabhKZ3rGIL8ZHHTcnSq8a+ORl7jO6pkLE9q7/2o2MzgC3wy3cH2CXTdZf4a6FmAuJNOMDvMF2KBtUUhszhKngNoC/fydD1dZLA3OTBF2lMfH15j6xS/5qkztqAPkc4I8hYbvLBWMQPteZ1oP+SDf8ulIAWVKmlBbrK7HyqHJw89BHagqyTwoGb3ofAX
 n//vqbDU
 qgxBIQ1G0ltwjB82I5Imgt+57rCiuodXSSVabebVutnClYYRU9fvPwHpG/zSecJKDFfsMW9SNm/VBFlMNJLS+ruK4mLntIDEMrBf+QLG4Yu9MkJ63A0A93N4jWYUdDBm1472SLPNmD1A/xwOHHzAbjv5L77zmyyDSvUS/DWc1XB0nYT3bI5rNFj8Oqn5OnlmZ00n2fpS6djWzVP1gRP9agqO+wmTGhYNP25uTGm6oUu+zFgqEECkcBFH7oQ/ALlcOpLaWTJRuM/ZwbMs5ZFbByYCtQBHEILoghW3iPGEAcLbwMiOxr/oe/JxiowEsScO/ZA327t1tlOdDu/bzDH9iTP7WP+ILhm3T39xpCJ3AuuM9j3I=
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
> The Sdtrig RISC-V ISA extension does not have a resume flag for
> returning to and executing the instruction at the breakpoint.
> To avoid skipping the instruction or looping, it is necessary to remove
> the hardware breakpoint and single step. Use the icount feature of
> Sdtrig to accomplish this. Use icount as default with an option to allow
> software-based single stepping when hardware or SBI does not have
> icount functionality, as it may cause unwanted side effects when reading
> the instruction from memory.

Can you please elaborate on this? I remember noticing the absence of
the resume flag which was causing loops.

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
> V1 -> V2:
>  - Remove HW_BREAKPOINT_COMPUTE_STEP kconfig option
> ---
>  arch/riscv/kernel/hw_breakpoint.c | 173 ++++++++++++++++++++++++++----
>  1 file changed, 155 insertions(+), 18 deletions(-)
>
> diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_bre=
akpoint.c
> index 3f96e744a711..f12306247436 100644
> --- a/arch/riscv/kernel/hw_breakpoint.c
> +++ b/arch/riscv/kernel/hw_breakpoint.c
> @@ -20,6 +20,7 @@
>  #define DBTR_TDATA1_DMODE              BIT_UL(__riscv_xlen - 5)
>
>  #define DBTR_TDATA1_TYPE_MCONTROL      (2UL << DBTR_TDATA1_TYPE_SHIFT)
> +#define DBTR_TDATA1_TYPE_ICOUNT                (3UL << DBTR_TDATA1_TYPE_=
SHIFT)
>  #define DBTR_TDATA1_TYPE_MCONTROL6     (6UL << DBTR_TDATA1_TYPE_SHIFT)
>
>  #define DBTR_TDATA1_MCONTROL6_LOAD             BIT(0)
> @@ -62,6 +63,14 @@
>         (FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZELO_FIELD, lo) | \
>          FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZEHI_FIELD, hi))
>
> +#define DBTR_TDATA1_ICOUNT_U                   BIT(6)
> +#define DBTR_TDATA1_ICOUNT_S                   BIT(7)
> +#define DBTR_TDATA1_ICOUNT_PENDING             BIT(8)
> +#define DBTR_TDATA1_ICOUNT_M                   BIT(9)
> +#define DBTR_TDATA1_ICOUNT_COUNT_FIELD         GENMASK(23, 10)
> +#define DBTR_TDATA1_ICOUNT_VU                  BIT(25)
> +#define DBTR_TDATA1_ICOUNT_VS                  BIT(26)
> +
>  enum dbtr_mode {
>         DBTR_MODE_U =3D 0,
>         DBTR_MODE_S,
> @@ -79,6 +88,7 @@ static DEFINE_PER_CPU(union sbi_dbtr_shmem_entry, sbi_d=
btr_shmem);
>
>  /* number of debug triggers on this cpu . */
>  static int dbtr_total_num __ro_after_init;
> +static bool have_icount __ro_after_init;
>  static unsigned long dbtr_type __ro_after_init;
>  static unsigned long dbtr_init __ro_after_init;
>
> @@ -129,6 +139,7 @@ static int arch_smp_teardown_sbi_shmem(unsigned int c=
pu)
>  static void init_sbi_dbtr(void)
>  {
>         struct sbiret ret;
> +       unsigned long dbtr_count =3D 0;
>
>         /*
>          * Called by hw_breakpoint_slots and arch_hw_breakpoint_init.
> @@ -143,6 +154,19 @@ static void init_sbi_dbtr(void)
>                 return;
>         }
>
> +       ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
> +               DBTR_TDATA1_TYPE_ICOUNT, 0, 0, 0, 0, 0);
> +       if (ret.error) {
> +               pr_warn("%s: failed to detect icount triggers. error: %ld=
.\n",
> +                       __func__, ret.error);
> +       } else if (!ret.value) {
> +               pr_warn("%s: No icount triggers available. "
> +                       "Falling-back to computing single step address.\n=
", __func__);
> +       } else {
> +               dbtr_count =3D ret.value;
> +               have_icount =3D true;
> +       }
> +
>         ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
>                         DBTR_TDATA1_TYPE_MCONTROL6, 0, 0, 0, 0, 0);
>         if (ret.error) {
> @@ -151,7 +175,7 @@ static void init_sbi_dbtr(void)
>         } else if (!ret.value) {
>                 pr_warn("%s: No mcontrol6 triggers available.\n", __func_=
_);
>         } else {
> -               dbtr_total_num =3D ret.value;
> +               dbtr_total_num =3D min_not_zero((unsigned long)ret.value,=
 dbtr_count);
>                 dbtr_type =3D DBTR_TDATA1_TYPE_MCONTROL6;
>                 return;
>         }
> @@ -166,7 +190,7 @@ static void init_sbi_dbtr(void)
>                 pr_err("%s: No mcontrol triggers available.\n", __func__)=
;
>                 dbtr_total_num =3D 0;
>         } else {
> -               dbtr_total_num =3D ret.value;
> +               dbtr_total_num =3D min_not_zero((unsigned long)ret.value,=
 dbtr_count);
>                 dbtr_type =3D DBTR_TDATA1_TYPE_MCONTROL;
>         }
>  }
> @@ -320,6 +344,36 @@ static int rv_init_mcontrol6_trigger(const struct pe=
rf_event_attr *attr,
>         return 0;
>  }
>
> +static int rv_init_icount_trigger(struct arch_hw_breakpoint *hw, enum db=
tr_mode mode)
> +{
> +       unsigned long tdata1 =3D DBTR_TDATA1_TYPE_ICOUNT;
> +
> +       /* Step one instruction */
> +       tdata1 |=3D FIELD_PREP(DBTR_TDATA1_ICOUNT_COUNT_FIELD, 1);
> +
> +       switch (mode) {
> +       case DBTR_MODE_U:
> +               tdata1 |=3D DBTR_TDATA1_ICOUNT_U;
> +               break;
> +       case DBTR_MODE_S:
> +               tdata1 |=3D DBTR_TDATA1_ICOUNT_S;
> +               break;
> +       case DBTR_MODE_VS:
> +               tdata1 |=3D DBTR_TDATA1_ICOUNT_VS;
> +               break;
> +       case DBTR_MODE_VU:
> +               tdata1 |=3D DBTR_TDATA1_ICOUNT_VU;
> +               break;
> +       default:
> +               return -EINVAL;
> +       }
> +
> +       hw->tdata1 =3D tdata1;
> +       hw->tdata2 =3D 0;
> +
> +       return 0;
> +}
> +
>  int hw_breakpoint_arch_parse(struct perf_event *bp,
>                              const struct perf_event_attr *attr,
>                              struct arch_hw_breakpoint *hw)
> @@ -372,24 +426,28 @@ static int setup_singlestep(struct perf_event *even=
t, struct pt_regs *regs)
>         /* Remove breakpoint even if return error as not to loop */
>         arch_uninstall_hw_breakpoint(event);
>
> -       ret =3D get_insn_nofault(regs, regs->epc, &insn);
> -       if (ret < 0)
> -               return ret;
> +       if (have_icount) {
> +               rv_init_icount_trigger(bp, DBTR_MODE_U);
> +       } else {
> +               ret =3D get_insn_nofault(regs, regs->epc, &insn);
> +               if (ret < 0)
> +                       return ret;
>
> -       next_addr =3D get_step_address(regs, insn);
> +               next_addr =3D get_step_address(regs, insn);
>
> -       ret =3D get_insn_nofault(regs, next_addr, &insn);
> -       if (ret < 0)
> -               return ret;
> +               ret =3D get_insn_nofault(regs, next_addr, &insn);
> +               if (ret < 0)
> +                       return ret;
>
> -       bp_insn.bp_type =3D HW_BREAKPOINT_X;
> -       bp_insn.bp_addr =3D next_addr;
> -       /* Get the size of the intruction */
> -       bp_insn.bp_len =3D GET_INSN_LENGTH(insn);
> +               bp_insn.bp_type =3D HW_BREAKPOINT_X;
> +               bp_insn.bp_addr =3D next_addr;
> +               /* Get the size of the intruction */
> +               bp_insn.bp_len =3D GET_INSN_LENGTH(insn);
>
> -       ret =3D hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
> -       if (ret)
> -               return ret;
> +               ret =3D hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
> +               if (ret)
> +                       return ret;
> +       }
>
>         ret =3D arch_install_hw_breakpoint(event);
>         if (ret)
> @@ -400,6 +458,79 @@ static int setup_singlestep(struct perf_event *event=
, struct pt_regs *regs)
>         return 0;
>  }
>
> +/**
> + * icount_triggered - Check if event's icount was triggered.
> + * @event: Perf event to check
> + *
> + * Check the given perf event's icount breakpoint was triggered.
> + *
> + * Returns:    1 if icount was triggered.
> + *             0 if icount was not triggered.
> + *             negative on failure.
> + */
> +static int icount_triggered(struct perf_event *event)
> +{
> +       union sbi_dbtr_shmem_entry *shmem =3D this_cpu_ptr(&sbi_dbtr_shme=
m);
> +       struct sbiret ret;
> +       struct perf_event **slot;
> +       unsigned long tdata1;
> +       int i;
> +
> +       for (i =3D 0; i < dbtr_total_num; i++) {
> +               slot =3D this_cpu_ptr(&pcpu_hw_bp_events[i]);
> +
> +               if (*slot =3D=3D event)
> +                       break;
> +       }
> +
> +       if (i =3D=3D dbtr_total_num) {
> +               pr_warn("%s: Breakpoint not installed.\n", __func__);
> +               return -ENOENT;
> +       }
> +
> +       raw_spin_lock_irqsave(this_cpu_ptr(&ecall_lock),
> +                             *this_cpu_ptr(&ecall_lock_flags));
> +
> +       ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIG_READ,
> +                       i, 1, 0, 0, 0, 0);
> +       tdata1 =3D shmem->data.tdata1;
> +
> +       raw_spin_unlock_irqrestore(this_cpu_ptr(&ecall_lock),
> +                                  *this_cpu_ptr(&ecall_lock_flags));
> +       if (ret.error) {
> +               pr_warn("%s: failed to read trigger. error: %ld\n", __fun=
c__, ret.error);
> +               return sbi_err_map_linux_errno(ret.error);

To avoid a flurry of events or messages, it would probably be good to
disable the trigger.

> +       }
> +
> +       /*
> +        * The RISC-V Debug Specification
> +        * Tim Newsome, Paul Donahue (Ventana Micro Systems)
> +        * Version 1.0, Revised 2025-02-21: Ratified
I think mentioning the version number and section would be enough.

> +        * 5.7.13. Instruction Count (icount, at 0x7a1)
> +        * When count is 1 and the trigger matches, then pending becomes =
set.
> +        * In addition count will become 0 unless it is hard-wired to 1.
> +        * When pending is set, the trigger fires just before any further
> +        * instructions are executed in a mode where the trigger is enabl=
ed.
> +        * As the trigger fires, pending is cleared. In addition, if coun=
t is
> +        * hard-wired to 1 then m, s, u, vs, and vu are all cleared.
> +        */
> +       if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) =3D=3D 0)
> +               return 1;
> +
> +       if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) !=3D 1)
> +               return 0;
> +
> +       if (tdata1 & DBTR_TDATA1_ICOUNT_U)
> +               return 0;
> +       if (tdata1 & DBTR_TDATA1_ICOUNT_S)
> +               return 0;
> +       if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
> +               return 0;
> +       if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
> +               return 0;
> +       return 1;
> +}
> +
>  /*
>   * HW Breakpoint/watchpoint handler
>   */
> @@ -460,7 +591,10 @@ static int hw_breakpoint_handler(struct pt_regs *reg=
s)
>
>                 if (bp->in_callback) {
>                         expecting_callback =3D true;
> -                       if (regs->epc !=3D bp->next_addr) {
> +                       if (have_icount) {
> +                               if (icount_triggered(event) !=3D 1)
> +                                       continue;
> +                       } else if (regs->epc !=3D bp->next_addr) {
>                                 continue;
>                         }
>
> @@ -477,7 +611,10 @@ static int hw_breakpoint_handler(struct pt_regs *reg=
s)
>
>         }
>
> -       if (expecting_callback) {
> +       if (expecting_callback && have_icount) {
> +               pr_err("%s: in_callback was set, but icount was not trigg=
ered, epc (%lx).\n",
> +                      __func__, regs->epc);
> +       } else if (expecting_callback) {
>                 pr_err("%s: in_callback was set, but epc (%lx) was not at=
 next address(%lx).\n",
>                        __func__, regs->epc, bp->next_addr);
>         }

Is this just for debugging or do you want to commit it?

Regards
Himanshu
> --
> 2.43.0
>

