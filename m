Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E52A3C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D71F6B00A0; Thu, 28 Aug 2025 13:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188406B00A1; Thu, 28 Aug 2025 13:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04F6A6B00A3; Thu, 28 Aug 2025 13:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E19FF6B00A0
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:47:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0FF684545
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:47:01 +0000 (UTC)
X-FDA: 83826897042.05.242238A
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 96B504000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:46:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/zJc+68";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of mr.bossman075@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mr.bossman075@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756403219; a=rsa-sha256;
	cv=none;
	b=8gFa3c6Ww+0rGtftsH/ofZBOLdHJGXTqgfisXtFBLriKNOlSMRnrHuzwbP/BMAghZnp0yd
	DcLdyO3h2vfUkd5Em9k0hXJgagAxLRYxUClhZx7ca6hMNW0K/7OTHJSvqeLvBbzPVNfUuw
	meSlHOlpoNeT857F39v2JXTIk7yuIs8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="B/zJc+68";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of mr.bossman075@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mr.bossman075@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756403219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5BQ+lgCm+hFgInYum/X7ZXkFamcbZPOD/z43fL4xMo=;
	b=dvEe57JfeG31IQ/+cZle2GSNvHEokdaZGLfaZZtsrvUWgfTNdCsdVtRdCcVt27wfl9cf/t
	SNBcS9zuFpSv7g3GCD9c5/kasPXciOGyOJlh8DwCfNW8RjhMKvQXztiNYeltYPRTFCI/SK
	Zmz9RqPOdXq9S7bo3uxbo1/kLr1Rvr0=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3cdfb1ff7aeso610087f8f.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756403218; x=1757008018; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5BQ+lgCm+hFgInYum/X7ZXkFamcbZPOD/z43fL4xMo=;
        b=B/zJc+68h5SRR3kM8REbD1Io6SvMJR1u8GNxNrSwad6ASsuVogP7hG9T+zLlTzCe24
         kMKIoYXjkhtSzCy4IhCnjJRK/ujsMeyvRSt9sMkoT6Oh+eQU3mU/bOqNyLW+Y0DzbX3N
         Gz9jDC5IzRSwisOpioX346dvHxso3DbxyT491hRc14OKKVAzWt+hzhnfwBKhGnnjLYyz
         bpxQrjRLzEvyhhgqJVutXMCHEoxF6FWln3hsw+++P7yH/op8ZBzTZtiyBgts1pjXzNXr
         EVCvD3KvA3/vbx+zYtkofn5GdLWhX1844NR2jMU3B2MV2xeMwCWlKgOEPZCDuBHnA/wQ
         LcpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756403218; x=1757008018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5BQ+lgCm+hFgInYum/X7ZXkFamcbZPOD/z43fL4xMo=;
        b=WJzlrxOHpM/jSW1C1eUrcFSuhGll9K0fWnIxExn24AKQrLR2is9zPFu+r0n8VHbTVe
         /VsBTTatkBiZu+poHEKM1Pf3rAwVy5vMx5bjYkCwsrJTbHjWkzlmwWhFAzhzcFwRNISt
         2YWzTg6JQcadzM+ZIaM9N5B7/0B7MTWmw3pEUhfVu/AGaU8gGc5quGnZndGZkRwdGM/u
         CjTYFajSnEzpvuHQuv+kG9MyRhqtZvrwR4P3I0kkm5/D+OgQI7QbiHZIFEJwVUXh420J
         jyRJ9eUmAtf1+B/xeb2mNlsKoLgnCDPxHOOpOrGQTlMdHWQ0GLmApMmvdOJNgEoJjbXe
         n1gw==
X-Forwarded-Encrypted: i=1; AJvYcCUvpDVzkMl+jBKTR/ulrnHBW+GsxTlDO7GoxF5/ETqtgqoTbLwbfLO3i7ehN10cXuj9jyJB4vCF2A==@kvack.org
X-Gm-Message-State: AOJu0YyIf52vmNVl9lnW+oTy0s2GZvguoPCEQzwsD5pTscih7WSDxWAF
	cYI1bbNZRNjWf2nzWeOhHPwmKiasFYBKWCypsNvIMSW9e6+FI9qduuSXChRrPkcEPXVhSR1JIkz
	rbPH2Be8g7HV3elLDS60mFOVdaWS6sfs=
X-Gm-Gg: ASbGncs68v3M9Eujr7QxjdUxypKw2GX9/9EZhX/v+QKe3mddD9g4FRoYqgcaY8X0yFU
	u81Bv1/JFEwBBXOufjCMlq4EeWiHRinEQiY3p6qerzEcV1GGfmx3dnCwiI9O9dlxnAcX90x5jE7
	rIal6sR5pL8d7rFHRyLha0lFWPZi8snu8q1dcvdqLRtU//kJ2Gbwihfa1yL93D5hn9tg7MSc1NE
	KwE+dC8
X-Google-Smtp-Source: AGHT+IHvqyc3pb900sJBUTlrQWedECpbYpMB5xKIU+44UTfcRa//ZihI5MLQ29+opQFj6apn6sL8VahQFE2wKNg2fAw=
X-Received: by 2002:a5d:5d0a:0:b0:3b8:f358:e80d with SMTP id
 ffacd0b85a97d-3c5db8ab097mr20611204f8f.5.1756403217733; Thu, 28 Aug 2025
 10:46:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAPd4Wexw_DtndDqRZzXK0PEOAkb4yWB4x8rf5eRdJOLMS-+8SQ@mail.gmail.com>
 <aK68IJPqa4YOo1S_@ghost>
In-Reply-To: <aK68IJPqa4YOo1S_@ghost>
From: Jesse T <mr.bossman075@gmail.com>
Date: Thu, 28 Aug 2025 13:46:21 -0400
X-Gm-Features: Ac12FXy3BQPFYJAdE_d0UGKSqV1g-N92aO_29KxePtztahgp0gtMrPVagjhdXHs
Message-ID: <CAJFTR8QKhMVVGa2BRpBcDvXggq5anX5wjTGH7V0_ex0JZfa7sw@mail.gmail.com>
Subject: Re: [PATCH 5/8] riscv: hw_breakpoint: Use icount for single stepping
To: Charlie Jenkins <charlie@rivosinc.com>
Cc: Himanshu Chauhan <hchauhan@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, Oleg Nesterov <oleg@redhat.com>, 
	Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Liang Kan <kan.liang@linux.intel.com>, Shuah Khan <shuah@kernel.org>, 
	Samuel Holland <samuel.holland@sifive.com>, Conor Dooley <conor.dooley@microchip.com>, 
	Deepak Gupta <debug@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@rivosinc.com>, Anup Patel <apatel@ventanamicro.com>, 
	Mayuresh Chitale <mchitale@ventanamicro.com>, WangYuli <wangyuli@uniontech.com>, 
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
X-Rspamd-Queue-Id: 96B504000E
X-Stat-Signature: xmb3m13kgrbygxnehz5g8g3qbi19a9jq
X-HE-Tag: 1756403219-449262
X-HE-Meta: U2FsdGVkX1+OtJyewBbrUPSt+NhtE0OOF9GK9MUefM/+P84u4h3HBvXN17LqFlzBbZUfQnmVPa1zNS8fBoNGRx9m+xZWtRd06FOKSZqI2SOzKQspP/RFq95Oq57UBoANdqgHId9L9kkrcK71UDjeTvPtreaMA75aNQrbaFgDGhMlZRPFLaLaTbLSvPx+T8gj8WOfMrCWsLxp1iv2rltmtyZ3usgraYjd1SWMlURzOMn3VkGt8CVYpFg68xmCspIvFN96hV5Ia+jxrgCay8EuR306ewxdKN4TyxwIYFZMiLm3DmnhksLTNtVqtD6gq3ik0jGl8pgc/6ypf/fCG9XTVe4tkkx82PPWBzLFyZl7s9WjKO3zPH080a3eRG0CEtN+WuptpJ9xkzQRCcP4UUlCsmh/c3QWaophvvyGvvM32qupN+rzbxH37FVllWIK10FlYDbm+cVsK3y9lY2nnJu+fLBmFfgQVlSulF4xnGSGD4txxVgsxO9+yOvwAraXW6BFIcWz7uqYFi80pfWXjw6ikyXox+4Cu5479uEmBDq9PjQtM8nR2Vu+LknoxjW7aXlIInlEDDs1GmbW3KwqxOQn9nwY7L4PiK1Gjw0REo+Get56cdFZmjdnRHm4b4e9NufVdlVO8zMeCiZUWnbmMcF5ogpq7J9orRlSBracQWCN2/f68pxztmfmPCzdeCKeUHE/ue10dZjcjYYDjmOLAHdSADSgT3uGPFEskWVmCUG3U1jkn6bG/1tSXP69CISh5JVzPNhLV5YSFW5JXBRZ0RYrLAZ4U70Q8/P0tNKeudro4u4zKWbDpM31KFwMbT4eLkKGU+qNxlFYxeqNIp219jyxO8RJo3j8C+orPflvxuFtWuwSTCNndtLnhlvASYt3SiomGFnuMPrXomQ0GfrPi+0rqUabH16IX5TlTXqC7VJ3ktT6KxtqjHC8cAhQSion6TmLVdrkT7FQ09/MgIJPihP
 wOp4vBlK
 8SXX623Inhclqza0egbSxBOORaYk2H2qQfGLfLcPMp2MgWtCW8fQW/q+CIAFYgbQKOkv4wB+fKA7ekETxMJ0V1XRqYYpAvUftAWlU9MiR5XhnnD7OYE8CHXzOsmPSN7mFaOkd71bJCFhmUjnnNX6RV+Nv5lZrvyWiO50YckXFK016VZfo/GMa8edIM3bJogc05iSHJAVGj0YvxaccC8+pu823ZC9xNfdMq03IRcLYtO2N3fUo4ZsDfvLmcokui6KGhLJTAtGFoVkcBGNPreiSkrSFO34x0VBvP0xA8nwZI7SSQJJLTTiq+R0IXpNUukvDlKyNkgVgWpMDwzi2Rx10CHb1R7ksnGb5BwJA9D4aR+TEahUfksXSqA5MQWNmypsP8RmqWn2C2Vq4NkeiUqotaJcYzgDeMuXo16gzcpENQrmzk8Qh+cpqRDJWr56S8JrHq4367KHq7kKAQycjGPDH0AsR/zANnfwAreeeK1iBoHFyP/E1sd88HGZZ2w4+LiMDYw5OIzr0bxDwXIzcHZGyixOQmJCpzWLTqRac1GWrxfyZjeQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 4:04=E2=80=AFAM Charlie Jenkins <charlie@rivosinc.c=
om> wrote:
>
> On Tue, Aug 26, 2025 at 10:08:04AM +0530, Himanshu Chauhan wrote:
> > On Fri, Aug 22, 2025 at 11:17=E2=80=AFPM Jesse Taube <jesse@rivosinc.co=
m> wrote:
> > >
> > > The Sdtrig RISC-V ISA extension does not have a resume flag for
> > > returning to and executing the instruction at the breakpoint.
> > > To avoid skipping the instruction or looping, it is necessary to remo=
ve
> > > the hardware breakpoint and single step. Use the icount feature of
> > > Sdtrig to accomplish this. Use icount as default with an option to al=
low
> > > software-based single stepping when hardware or SBI does not have
> > > icount functionality, as it may cause unwanted side effects when read=
ing
> > > the instruction from memory.
> >
> > Can you please elaborate on this? I remember noticing the absence of
> > the resume flag which was causing loops.

Yes, signal handler based hardware debugging doesn't work, only ptrace base=
d.
ARM64 and ARM also don't support signal handler based hardware
debugging as seen in a later patch.

> Thank you for your feedback. Jesse's internship came to an end last
> Friday (August 22nd) so I will be picking up these patches, but I have
> also added her personal email onto this thread.

I forgot to CC my personal email sorry....

> When a breakpoint is triggered and the kernel gains control, the last
> instruction to execute was the instruction before the instruction where
> the breakpoint is installed. If execution was to be resumed at this
> stage, the same breakpoint would be triggered again. So single stepping
> requires a careful dance of enabling and disabling breakpoints. However,
> we can avoid this overhead and code complexity can be reduced by using
> the icount trigger which allows a direct method for single stepping.
>
> >
> > >
> > > Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> > > ---
> > > OpenSBI implementation of sbi_debug_read_triggers does not return the
> > > updated CSR values. There needs to be a check for working
> > > sbi_debug_read_triggers before this works.
> > >
> > > https://lists.riscv.org/g/tech-prs/message/1476
> > >
> > > RFC -> V1:
> > >  - Add dbtr_mode to rv_init_icount_trigger
> > >  - Add icount_triggered to check which breakpoint was triggered
> > >  - Fix typo: s/affects/effects
> > >  - Move HW_BREAKPOINT_COMPUTE_STEP to Platform type
> > > V1 -> V2:
> > >  - Remove HW_BREAKPOINT_COMPUTE_STEP kconfig option
> > > ---
> > >  arch/riscv/kernel/hw_breakpoint.c | 173 ++++++++++++++++++++++++++--=
--
> > >  1 file changed, 155 insertions(+), 18 deletions(-)
> > >
> > > diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw=
_breakpoint.c
> > > index 3f96e744a711..f12306247436 100644
> > > --- a/arch/riscv/kernel/hw_breakpoint.c
> > > +++ b/arch/riscv/kernel/hw_breakpoint.c
> > > @@ -20,6 +20,7 @@
> > >  #define DBTR_TDATA1_DMODE              BIT_UL(__riscv_xlen - 5)
> > >
> > >  #define DBTR_TDATA1_TYPE_MCONTROL      (2UL << DBTR_TDATA1_TYPE_SHIF=
T)
> > > +#define DBTR_TDATA1_TYPE_ICOUNT                (3UL << DBTR_TDATA1_T=
YPE_SHIFT)
> > >  #define DBTR_TDATA1_TYPE_MCONTROL6     (6UL << DBTR_TDATA1_TYPE_SHIF=
T)
> > >
> > >  #define DBTR_TDATA1_MCONTROL6_LOAD             BIT(0)
> > > @@ -62,6 +63,14 @@
> > >         (FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZELO_FIELD, lo) | \
> > >          FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZEHI_FIELD, hi))
> > >
> > > +#define DBTR_TDATA1_ICOUNT_U                   BIT(6)
> > > +#define DBTR_TDATA1_ICOUNT_S                   BIT(7)
> > > +#define DBTR_TDATA1_ICOUNT_PENDING             BIT(8)
> > > +#define DBTR_TDATA1_ICOUNT_M                   BIT(9)
> > > +#define DBTR_TDATA1_ICOUNT_COUNT_FIELD         GENMASK(23, 10)
> > > +#define DBTR_TDATA1_ICOUNT_VU                  BIT(25)
> > > +#define DBTR_TDATA1_ICOUNT_VS                  BIT(26)
> > > +
> > >  enum dbtr_mode {
> > >         DBTR_MODE_U =3D 0,
> > >         DBTR_MODE_S,
> > > @@ -79,6 +88,7 @@ static DEFINE_PER_CPU(union sbi_dbtr_shmem_entry, s=
bi_dbtr_shmem);
> > >
> > >  /* number of debug triggers on this cpu . */
> > >  static int dbtr_total_num __ro_after_init;
> > > +static bool have_icount __ro_after_init;
> > >  static unsigned long dbtr_type __ro_after_init;
> > >  static unsigned long dbtr_init __ro_after_init;
> > >
> > > @@ -129,6 +139,7 @@ static int arch_smp_teardown_sbi_shmem(unsigned i=
nt cpu)
> > >  static void init_sbi_dbtr(void)
> > >  {
> > >         struct sbiret ret;
> > > +       unsigned long dbtr_count =3D 0;
> > >
> > >         /*
> > >          * Called by hw_breakpoint_slots and arch_hw_breakpoint_init.
> > > @@ -143,6 +154,19 @@ static void init_sbi_dbtr(void)
> > >                 return;
> > >         }
> > >
> > > +       ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
> > > +               DBTR_TDATA1_TYPE_ICOUNT, 0, 0, 0, 0, 0);
> > > +       if (ret.error) {
> > > +               pr_warn("%s: failed to detect icount triggers. error:=
 %ld.\n",
> > > +                       __func__, ret.error);
> > > +       } else if (!ret.value) {
> > > +               pr_warn("%s: No icount triggers available. "
> > > +                       "Falling-back to computing single step addres=
s.\n", __func__);
> > > +       } else {
> > > +               dbtr_count =3D ret.value;
> > > +               have_icount =3D true;
> > > +       }
> > > +
> > >         ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
> > >                         DBTR_TDATA1_TYPE_MCONTROL6, 0, 0, 0, 0, 0);
> > >         if (ret.error) {
> > > @@ -151,7 +175,7 @@ static void init_sbi_dbtr(void)
> > >         } else if (!ret.value) {
> > >                 pr_warn("%s: No mcontrol6 triggers available.\n", __f=
unc__);
> > >         } else {
> > > -               dbtr_total_num =3D ret.value;
> > > +               dbtr_total_num =3D min_not_zero((unsigned long)ret.va=
lue, dbtr_count);
> > >                 dbtr_type =3D DBTR_TDATA1_TYPE_MCONTROL6;
> > >                 return;
> > >         }
> > > @@ -166,7 +190,7 @@ static void init_sbi_dbtr(void)
> > >                 pr_err("%s: No mcontrol triggers available.\n", __fun=
c__);
> > >                 dbtr_total_num =3D 0;
> > >         } else {
> > > -               dbtr_total_num =3D ret.value;
> > > +               dbtr_total_num =3D min_not_zero((unsigned long)ret.va=
lue, dbtr_count);
> > >                 dbtr_type =3D DBTR_TDATA1_TYPE_MCONTROL;
> > >         }
> > >  }
> > > @@ -320,6 +344,36 @@ static int rv_init_mcontrol6_trigger(const struc=
t perf_event_attr *attr,
> > >         return 0;
> > >  }
> > >
> > > +static int rv_init_icount_trigger(struct arch_hw_breakpoint *hw, enu=
m dbtr_mode mode)
> > > +{
> > > +       unsigned long tdata1 =3D DBTR_TDATA1_TYPE_ICOUNT;
> > > +
> > > +       /* Step one instruction */
> > > +       tdata1 |=3D FIELD_PREP(DBTR_TDATA1_ICOUNT_COUNT_FIELD, 1);
> > > +
> > > +       switch (mode) {
> > > +       case DBTR_MODE_U:
> > > +               tdata1 |=3D DBTR_TDATA1_ICOUNT_U;
> > > +               break;
> > > +       case DBTR_MODE_S:
> > > +               tdata1 |=3D DBTR_TDATA1_ICOUNT_S;
> > > +               break;
> > > +       case DBTR_MODE_VS:
> > > +               tdata1 |=3D DBTR_TDATA1_ICOUNT_VS;
> > > +               break;
> > > +       case DBTR_MODE_VU:
> > > +               tdata1 |=3D DBTR_TDATA1_ICOUNT_VU;
> > > +               break;
> > > +       default:
> > > +               return -EINVAL;
> > > +       }
> > > +
> > > +       hw->tdata1 =3D tdata1;
> > > +       hw->tdata2 =3D 0;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > >  int hw_breakpoint_arch_parse(struct perf_event *bp,
> > >                              const struct perf_event_attr *attr,
> > >                              struct arch_hw_breakpoint *hw)
> > > @@ -372,24 +426,28 @@ static int setup_singlestep(struct perf_event *=
event, struct pt_regs *regs)
> > >         /* Remove breakpoint even if return error as not to loop */
> > >         arch_uninstall_hw_breakpoint(event);
> > >
> > > -       ret =3D get_insn_nofault(regs, regs->epc, &insn);
> > > -       if (ret < 0)
> > > -               return ret;
> > > +       if (have_icount) {
> > > +               rv_init_icount_trigger(bp, DBTR_MODE_U);
> > > +       } else {
> > > +               ret =3D get_insn_nofault(regs, regs->epc, &insn);
> > > +               if (ret < 0)
> > > +                       return ret;
> > >
> > > -       next_addr =3D get_step_address(regs, insn);
> > > +               next_addr =3D get_step_address(regs, insn);
> > >
> > > -       ret =3D get_insn_nofault(regs, next_addr, &insn);
> > > -       if (ret < 0)
> > > -               return ret;
> > > +               ret =3D get_insn_nofault(regs, next_addr, &insn);
> > > +               if (ret < 0)
> > > +                       return ret;
> > >
> > > -       bp_insn.bp_type =3D HW_BREAKPOINT_X;
> > > -       bp_insn.bp_addr =3D next_addr;
> > > -       /* Get the size of the intruction */
> > > -       bp_insn.bp_len =3D GET_INSN_LENGTH(insn);
> > > +               bp_insn.bp_type =3D HW_BREAKPOINT_X;
> > > +               bp_insn.bp_addr =3D next_addr;
> > > +               /* Get the size of the intruction */
> > > +               bp_insn.bp_len =3D GET_INSN_LENGTH(insn);
> > >
> > > -       ret =3D hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
> > > -       if (ret)
> > > -               return ret;
> > > +               ret =3D hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
> > > +               if (ret)
> > > +                       return ret;
> > > +       }
> > >
> > >         ret =3D arch_install_hw_breakpoint(event);
> > >         if (ret)
> > > @@ -400,6 +458,79 @@ static int setup_singlestep(struct perf_event *e=
vent, struct pt_regs *regs)
> > >         return 0;
> > >  }
> > >
> > > +/**
> > > + * icount_triggered - Check if event's icount was triggered.
> > > + * @event: Perf event to check
> > > + *
> > > + * Check the given perf event's icount breakpoint was triggered.
> > > + *
> > > + * Returns:    1 if icount was triggered.
> > > + *             0 if icount was not triggered.
> > > + *             negative on failure.
> > > + */
> > > +static int icount_triggered(struct perf_event *event)
> > > +{
> > > +       union sbi_dbtr_shmem_entry *shmem =3D this_cpu_ptr(&sbi_dbtr_=
shmem);
> > > +       struct sbiret ret;
> > > +       struct perf_event **slot;
> > > +       unsigned long tdata1;
> > > +       int i;
> > > +
> > > +       for (i =3D 0; i < dbtr_total_num; i++) {
> > > +               slot =3D this_cpu_ptr(&pcpu_hw_bp_events[i]);
> > > +
> > > +               if (*slot =3D=3D event)
> > > +                       break;
> > > +       }
> > > +
> > > +       if (i =3D=3D dbtr_total_num) {
> > > +               pr_warn("%s: Breakpoint not installed.\n", __func__);
> > > +               return -ENOENT;
> > > +       }
> > > +
> > > +       raw_spin_lock_irqsave(this_cpu_ptr(&ecall_lock),
> > > +                             *this_cpu_ptr(&ecall_lock_flags));
> > > +
> > > +       ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIG_READ,
> > > +                       i, 1, 0, 0, 0, 0);
> > > +       tdata1 =3D shmem->data.tdata1;
> > > +
> > > +       raw_spin_unlock_irqrestore(this_cpu_ptr(&ecall_lock),
> > > +                                  *this_cpu_ptr(&ecall_lock_flags));
> > > +       if (ret.error) {
> > > +               pr_warn("%s: failed to read trigger. error: %ld\n", _=
_func__, ret.error);
> > > +               return sbi_err_map_linux_errno(ret.error);
> >
> > To avoid a flurry of events or messages, it would probably be good to
> > disable the trigger.
>
> That is a good point.

Agreed

> >
> > > +       }
> > > +
> > > +       /*
> > > +        * The RISC-V Debug Specification
> > > +        * Tim Newsome, Paul Donahue (Ventana Micro Systems)
> > > +        * Version 1.0, Revised 2025-02-21: Ratified
> > I think mentioning the version number and section would be enough.
>
> Agreed.

I wasn't sure the best way to cite this, Version number and section is
ok with me.

> > > +        * 5.7.13. Instruction Count (icount, at 0x7a1)
> > > +        * When count is 1 and the trigger matches, then pending beco=
mes set.
> > > +        * In addition count will become 0 unless it is hard-wired to=
 1.
> > > +        * When pending is set, the trigger fires just before any fur=
ther
> > > +        * instructions are executed in a mode where the trigger is e=
nabled.
> > > +        * As the trigger fires, pending is cleared. In addition, if =
count is
> > > +        * hard-wired to 1 then m, s, u, vs, and vu are all cleared.
> > > +        */
> > > +       if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) =3D=3D =
0)
> > > +               return 1;
> > > +
> > > +       if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) !=3D 1)
> > > +               return 0;
> > > +
> > > +       if (tdata1 & DBTR_TDATA1_ICOUNT_U)
> > > +               return 0;
> > > +       if (tdata1 & DBTR_TDATA1_ICOUNT_S)
> > > +               return 0;
> > > +       if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
> > > +               return 0;
> > > +       if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
> > > +               return 0;
> > > +       return 1;
> > > +}
> > > +
> > >  /*
> > >   * HW Breakpoint/watchpoint handler
> > >   */
> > > @@ -460,7 +591,10 @@ static int hw_breakpoint_handler(struct pt_regs =
*regs)
> > >
> > >                 if (bp->in_callback) {
> > >                         expecting_callback =3D true;
> > > -                       if (regs->epc !=3D bp->next_addr) {
> > > +                       if (have_icount) {
> > > +                               if (icount_triggered(event) !=3D 1)
> > > +                                       continue;
> > > +                       } else if (regs->epc !=3D bp->next_addr) {
> > >                                 continue;
> > >                         }
> > >
> > > @@ -477,7 +611,10 @@ static int hw_breakpoint_handler(struct pt_regs =
*regs)
> > >
> > >         }
> > >
> > > -       if (expecting_callback) {
> > > +       if (expecting_callback && have_icount) {
> > > +               pr_err("%s: in_callback was set, but icount was not t=
riggered, epc (%lx).\n",
> > > +                      __func__, regs->epc);
> > > +       } else if (expecting_callback) {
> > >                 pr_err("%s: in_callback was set, but epc (%lx) was no=
t at next address(%lx).\n",
> > >                        __func__, regs->epc, bp->next_addr);
> > >         }
> >
> > Is this just for debugging or do you want to commit it?
>
> I believe this was intentional, but perhaps it is not a useful print.

It is for someone to find out that a spurious debug trigger event
happened as it is expecting either an icount event or
a mcontrol event at next_addr if this did not happen it will send a
SIG_DEBUG to the user process.

Ignore my previous response as it was HTML.

Thanks,
Jesse

> - Charlie
>
> >
> > Regards
> > Himanshu
> > > --
> > > 2.43.0
> > >

