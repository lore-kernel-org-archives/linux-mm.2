Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD1FC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:37:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D581A8E001E; Thu, 28 Aug 2025 13:37:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08378E000F; Thu, 28 Aug 2025 13:37:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9378E001E; Thu, 28 Aug 2025 13:37:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A020F8E000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:37:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 505911402A5
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:37:31 +0000 (UTC)
X-FDA: 83826873102.01.F52443C
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3AFFF4000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:37:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WDpLF5U2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of mr.bossman075@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mr.bossman075@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756402649; a=rsa-sha256;
	cv=none;
	b=UF+YbWOObmc5dQOaBlsZu6gPKX7JkXiooZQcM+5Cxle0kyhCO3zw+yKPttdQ3qzrnbh6Xg
	d+fKPbGQZMkBq06HErClMjAp6oCtvj15+1naHninRRHWraiuq62SbEuLHJbt7Xje+cwmbD
	q3j8R5Rt7wGNDuxIdktYehTFkx1Uh0o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WDpLF5U2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of mr.bossman075@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=mr.bossman075@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756402649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhfsFTd3ugj3WaCECj+MN+N217tq1hZwrKC8ZvrKBlc=;
	b=YdoM8OAVhcMwU+wsl3fMvMEi2Drr4SVXSISXG1O3eBrgNImH1LFy3UeqCdbuOAe4TMPB29
	oyeCoIfl0YdRI89WP31pEigA0gMxIiV70HVIhQzJ6l5mg+hOXWcq2FBe8f2CWya+sfdxbE
	Y59VOPHxAIf2i20cQIEkRJywz0q9lPU=
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3b9edf4cf6cso920504f8f.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756402647; x=1757007447; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XhfsFTd3ugj3WaCECj+MN+N217tq1hZwrKC8ZvrKBlc=;
        b=WDpLF5U2MADM5KHmXGMlm6um6IyUnCV2O4soEryrXIffwFCl2WWsigRqdwao/BMoi7
         M5BzyGSC68pHkdj8zYzcPjhkRHvnaHnRu/L5qw10sRXvXOMrTb94MzUcKEyiD6gARqzy
         sWWGLKSsn1aPEqDqiK+Ok+R/vwafSDqemwK8F+uuP1FXsvGuQqyGBv+leFhVVL2TYHMK
         8TML9VCnvH1ki5/nOcAp660yy6YGVws0CD/q86xrbfXwe8VHb4xAbJrVlpyYD462zwaM
         y+RrpUcfhW7ACp9lqNYoilT3Jx7oYUTzzOi3h1WsxpGTZ4yYrBxFzkLwZ5RBqmeCU8k1
         RI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756402647; x=1757007447;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XhfsFTd3ugj3WaCECj+MN+N217tq1hZwrKC8ZvrKBlc=;
        b=QcjdsDYKNMp4DGK0Chi+ADZZ01xKxJSLRJqQvD58w+aXy4O5S2aRb08IUDddsUq9To
         WtZlrdIW8e0HRwqbMNLYNp4i9muazUK7X5nQdXe08KjHnrQOMXn3yHM9o6l1VqHu9RYg
         oJb7U7V/FhrUrhRxZ4grldpon3K0njBg8HgTkj8nFDh5/ZChegp3guXOtQ9UD0x1NetS
         AFvnejoEgKo+ZfYcezdx7OTqDL5FYSoPGT2ZugboEppLkQhAIJ1FxvOGv36qcXHTOyWb
         iqcKMF3mLHN2MPsZs3Xdnl7i+gzG5NZjcK6iuuloH9frRxP+m2qY/Ty76/n4M0OWhg4M
         L64g==
X-Forwarded-Encrypted: i=1; AJvYcCUG3E3n9UXtfNb6yDv1OAZQ7KOsTQ1Egz8/gaHVcs/P0Ywx3liQD2zlc9bbo09v8F3dtqbsKakpOw==@kvack.org
X-Gm-Message-State: AOJu0YyjBosucbcbIuBJNSV8DmoRIW8sJhODs8+Gj5amJrN3aode0TnJ
	DNeZ2OZtvwTwEVysqNuTYPujdXQez+Suik3D4WmSB0xH0GfQF9OrT4tdxicOLkV2/on7NOVP/rr
	5NA3MqRFtC6IkFF/r6OfE4+4i99Qfkwg=
X-Gm-Gg: ASbGncvF0Nlw6BD8C1IMqcn49YAFoCRwHkgj9xbWvGmyJUaF8g1phFKdcxDPhC8xIXn
	/19pCbDXoihLqqqbYmC0c9zNAzewOTEevL9DF3TUWCnciTV3i876QvuNTjXL2bw0K+k99KHnnrL
	1g2ahb49rI5HzW3hRsZy4tiTuTXzyp2WR/q+/3aOvPXE5/NOMimgosuk+HOLPOKvCeS2AWCC5px
	q3uyhW73caYJI/PeWY=
X-Google-Smtp-Source: AGHT+IEAVReXnUwyT1axvF++ift7//dWehaMjjwTfjlG2/1lkjno0GGS6KXmY8q4/i4hOZ6zrb8yrm2BHGQg6JQsBsI=
X-Received: by 2002:a05:6000:2001:b0:3c0:7e02:8677 with SMTP id
 ffacd0b85a97d-3c5dd3d049amr20289239f8f.62.1756402647188; Thu, 28 Aug 2025
 10:37:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAPd4Wexw_DtndDqRZzXK0PEOAkb4yWB4x8rf5eRdJOLMS-+8SQ@mail.gmail.com>
 <aK68IJPqa4YOo1S_@ghost>
In-Reply-To: <aK68IJPqa4YOo1S_@ghost>
From: Jesse T <mr.bossman075@gmail.com>
Date: Thu, 28 Aug 2025 13:36:50 -0400
X-Gm-Features: Ac12FXxCl9VJ08uZigD8rGMHni88SDoyA04N1066mjR65QEMs3guZ6qtztCYKmk
Message-ID: <CAJFTR8RR2FSME8HET9C0zVFyFRYKdAQ7jAyomMge=hfV5LteHw@mail.gmail.com>
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
Content-Type: multipart/alternative; boundary="000000000000de4c21063d705b19"
X-Rspamd-Queue-Id: 3AFFF4000A
X-Stat-Signature: 7cscyqe58rx65jghoka456mpo9ux4ihj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756402649-455993
X-HE-Meta: U2FsdGVkX1/edeUcnzitm8BlCFsfQ3jLXRdDJ7fUtpp13jAtGnSaAMAI+/DfPm+EYXjIXdd3BqAk8H41j3fAKumkYhvst68OmQE4LuByZWmH1q4E00IRrMGLuqAWSs94Sheig/yTKFD2S+RAV5BVkhmVRxJDVlL1wlS6Y/50Jpc56OzcUulfr6hmDr3ENgJ8XqXv41dbVZxmr31vz8HvAQ8ExqU8yZ4lO/ViaQD434W7+DIlRxtsOc04LTORKW5rIt6R3LMDFY1L7NgLH3dIxNCiDMOzhIYMqqGf0XIaHeta6AslwXwC2lQ2Gn4DI4MA5iaR4iSrSaEgcJHFC2gwqOAsUzz1PcxGvZGNMuIuFzlxk1NW047GWtQG1rh1uMkdFt+2ZywHxwOlxexqUqHKMnpHihmiqcfaFjzpA6I7A9yVCK9Qj4BNN6BqZOuJ7CsUrSVCcqJfHHV0kVHsXIOoa/RwA6zxeMX4zCIA2wK15YkkonbOrJxzSu3waWi86sl2Mm7PyFK2z91RG/G85QSrdzuWK91akzdkX4ohQ6XTqgvrTsgSPA4rGFBwP2nPcpRrQXTy1no6DU17/zMBRDDIH7nKR2RQPMSQkoz/YwHW6aKuoTeOG+53e9L7hFckJ0nTBQrmfffQEZvjg1grQsXmanYSTCAp0oLfkxI99umMC+LmMRxocjLm5ffUaBm2cJeByTvvwFgEOBSxJHdMnFswoj22D2qQFffIST5lh1fvZ2F619MwYzKIdL2SIVpWii43ZsvFGxxYWbnnM40XmP+sdPE5rTaW1u+8wE4V+jGUx3UZzsxqOS5aA0tuuvMQnvmQGbENgvfas7uSV2FL7OPodhCL3yft/9YOSKtiUxdMaElXAIMw+l4znQj/HC5xIpG0vLdC3B2AHtaGLs0RJH8HdvdK3b55bbZgR2ogn5cFVOWTdx5HtAVh3lHgRLW4U4YI54MmE4GXQdrdS0qGgPU
 NJ3FHb4S
 aYDFD6+FTQRXsENEX91JKvcprdtPjntW9hqk1YO7GeGOybhX+PdJ7nUGw8m563e646DWDxJWJSr7rwn0rXgCPVKjdCtD264U0VkKRmupNoBHK5O8LIapW0TMZ7fklhMF7E4XYiPMzN+7Db34UupffqrkwezjZSosXdkOk6KgX0qmlJinRLaQlCgNJNr+19rMHkjNyd45th78wDfZKW4USiNaZiyJ79uJlj2qqTqPNPLgbX6fs0XUImD408b46OprugzVwaciMo8k4jtgvLY32itGTtN5bRBdlfAOf83XO6qYiPBqHYHboe2e1PjooC1eKppiUTRtAQrpkVpQ6lH18F2CYV9hp+piedPvCldYsURAQGBKaqtDE7jRCxVzSZxCpp0UFUYA3IV9FHwzzZSuYrfpZvreTzT3+hQFjFOrANSG3gjxal2bEorwamn2nW/n9bdG5Wzo9PXvTdmDSGTrqnBOyHFQqaj+H7V4yFHykC5hn1Q+tOIlP7Tzim+435GjvXB0uAWyA0qYiWYLwpgEmXhtO87KTBansfgwTv9QmT5p6R0WQ/LEnqe+DltMQIgsfPGQLCFCfDVfw5HBbUjiECZ5Wyh3B/awq8wKyEOnhQZCedQwpuQOqSrSe/1pQnkuBAr9h05YNl30UpEdUAfcppy+AtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000de4c21063d705b19
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 4:04=E2=80=AFAM Charlie Jenkins <charlie@rivosinc.c=
om>
wrote:

> On Tue, Aug 26, 2025 at 10:08:04AM +0530, Himanshu Chauhan wrote:
> > On Fri, Aug 22, 2025 at 11:17=E2=80=AFPM Jesse Taube <jesse@rivosinc.co=
m> wrote:
> > >
> > > The Sdtrig RISC-V ISA extension does not have a resume flag for
> > > returning to and executing the instruction at the breakpoint.
> > > To avoid skipping the instruction or looping, it is necessary to remo=
ve
> > > the hardware breakpoint and single step. Use the icount feature of
> > > Sdtrig to accomplish this. Use icount as default with an option to
> allow
> > > software-based single stepping when hardware or SBI does not have
> > > icount functionality, as it may cause unwanted side effects when
> reading
> > > the instruction from memory.
> >
> > Can you please elaborate on this? I remember noticing the absence of
> > the resume flag which was causing loops.
>

Yes, signal handler based hardware debugging doesn't work, only ptrace
based.
ARM64 and ARM also don't support signal handler based hardware debugging as
seen in a later patch.

Thank you for your feedback. Jesse's internship came to an end last
> Friday (August 22nd) so I will be picking up these patches, but I have
> also added her personal email onto this thread.
>

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
> > > diff --git a/arch/riscv/kernel/hw_breakpoint.c
> b/arch/riscv/kernel/hw_breakpoint.c
> > > index 3f96e744a711..f12306247436 100644
> > > --- a/arch/riscv/kernel/hw_breakpoint.c
> > > +++ b/arch/riscv/kernel/hw_breakpoint.c
> > > @@ -20,6 +20,7 @@
> > >  #define DBTR_TDATA1_DMODE              BIT_UL(__riscv_xlen - 5)
> > >
> > >  #define DBTR_TDATA1_TYPE_MCONTROL      (2UL << DBTR_TDATA1_TYPE_SHIF=
T)
> > > +#define DBTR_TDATA1_TYPE_ICOUNT                (3UL <<
> DBTR_TDATA1_TYPE_SHIFT)
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
> > > @@ -79,6 +88,7 @@ static DEFINE_PER_CPU(union sbi_dbtr_shmem_entry,
> sbi_dbtr_shmem);
> > >
> > >  /* number of debug triggers on this cpu . */
> > >  static int dbtr_total_num __ro_after_init;
> > > +static bool have_icount __ro_after_init;
> > >  static unsigned long dbtr_type __ro_after_init;
> > >  static unsigned long dbtr_init __ro_after_init;
> > >
> > > @@ -129,6 +139,7 @@ static int arch_smp_teardown_sbi_shmem(unsigned
> int cpu)
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
> > > +               pr_warn("%s: failed to detect icount triggers. error:
> %ld.\n",
> > > +                       __func__, ret.error);
> > > +       } else if (!ret.value) {
> > > +               pr_warn("%s: No icount triggers available. "
> > > +                       "Falling-back to computing single step
> address.\n", __func__);
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
> > >                 pr_warn("%s: No mcontrol6 triggers available.\n",
> __func__);
> > >         } else {
> > > -               dbtr_total_num =3D ret.value;
> > > +               dbtr_total_num =3D min_not_zero((unsigned
> long)ret.value, dbtr_count);
> > >                 dbtr_type =3D DBTR_TDATA1_TYPE_MCONTROL6;
> > >                 return;
> > >         }
> > > @@ -166,7 +190,7 @@ static void init_sbi_dbtr(void)
> > >                 pr_err("%s: No mcontrol triggers available.\n",
> __func__);
> > >                 dbtr_total_num =3D 0;
> > >         } else {
> > > -               dbtr_total_num =3D ret.value;
> > > +               dbtr_total_num =3D min_not_zero((unsigned
> long)ret.value, dbtr_count);
> > >                 dbtr_type =3D DBTR_TDATA1_TYPE_MCONTROL;
> > >         }
> > >  }
> > > @@ -320,6 +344,36 @@ static int rv_init_mcontrol6_trigger(const struc=
t
> perf_event_attr *attr,
> > >         return 0;
> > >  }
> > >
> > > +static int rv_init_icount_trigger(struct arch_hw_breakpoint *hw, enu=
m
> dbtr_mode mode)
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
> > > @@ -372,24 +426,28 @@ static int setup_singlestep(struct perf_event
> *event, struct pt_regs *regs)
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
> > > @@ -400,6 +458,79 @@ static int setup_singlestep(struct perf_event
> *event, struct pt_regs *regs)
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
> > > +       union sbi_dbtr_shmem_entry *shmem =3D
> this_cpu_ptr(&sbi_dbtr_shmem);
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
> > > +               pr_warn("%s: failed to read trigger. error: %ld\n",
> __func__, ret.error);
> > > +               return sbi_err_map_linux_errno(ret.error);
> >
> > To avoid a flurry of events or messages, it would probably be good to
> > disable the trigger.
>
> That is a good point.
>

Agreed

>
> > > +       }
> > > +
> > > +       /*
> > > +        * The RISC-V Debug Specification
> > > +        * Tim Newsome, Paul Donahue (Ventana Micro Systems)
> > > +        * Version 1.0, Revised 2025-02-21: Ratified
> > I think mentioning the version number and section would be enough.
>
> Agreed.
>

I wasn't sure the best way to cite this, Version number and section is ok
with me.

>
> > > +        * 5.7.13. Instruction Count (icount, at 0x7a1)
> > > +        * When count is 1 and the trigger matches, then pending
> becomes set.
> > > +        * In addition count will become 0 unless it is hard-wired to
> 1.
> > > +        * When pending is set, the trigger fires just before any
> further
> > > +        * instructions are executed in a mode where the trigger is
> enabled.
> > > +        * As the trigger fires, pending is cleared. In addition, if
> count is
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
> > > @@ -460,7 +591,10 @@ static int hw_breakpoint_handler(struct pt_regs
> *regs)
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
> > > @@ -477,7 +611,10 @@ static int hw_breakpoint_handler(struct pt_regs
> *regs)
> > >
> > >         }
> > >
> > > -       if (expecting_callback) {
> > > +       if (expecting_callback && have_icount) {
> > > +               pr_err("%s: in_callback was set, but icount was not
> triggered, epc (%lx).\n",
> > > +                      __func__, regs->epc);
> > > +       } else if (expecting_callback) {
> > >                 pr_err("%s: in_callback was set, but epc (%lx) was no=
t
> at next address(%lx).\n",
> > >                        __func__, regs->epc, bp->next_addr);
> > >         }
> >
> > Is this just for debugging or do you want to commit it?
>
> I believe this was intentional, but perhaps it is not a useful print.


It is for someone to find out that a spurious debug trigger event happened
as it is expecting either an icount event or
a mcontrol event at next_addr if this did not happen it will send a
SIG_DEBUG to the user process.

Thanks,
Jesse


>
- Charlie
>
> >
> > Regards
> > Himanshu
> > > --
> > > 2.43.0
> > >
>

--000000000000de4c21063d705b19
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Wed, Aug 27,=
 2025 at 4:04=E2=80=AFAM Charlie Jenkins &lt;<a href=3D"mailto:charlie@rivo=
sinc.com">charlie@rivosinc.com</a>&gt; wrote:<br></div><blockquote class=3D=
"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(2=
04,204,204);padding-left:1ex">On Tue, Aug 26, 2025 at 10:08:04AM +0530, Him=
anshu Chauhan wrote:<br>
&gt; On Fri, Aug 22, 2025 at 11:17=E2=80=AFPM Jesse Taube &lt;<a href=3D"ma=
ilto:jesse@rivosinc.com" target=3D"_blank">jesse@rivosinc.com</a>&gt; wrote=
:<br>
&gt; &gt;<br>
&gt; &gt; The Sdtrig RISC-V ISA extension does not have a resume flag for<b=
r>
&gt; &gt; returning to and executing the instruction at the breakpoint.<br>
&gt; &gt; To avoid skipping the instruction or looping, it is necessary to =
remove<br>
&gt; &gt; the hardware breakpoint and single step. Use the icount feature o=
f<br>
&gt; &gt; Sdtrig to accomplish this. Use icount as default with an option t=
o allow<br>
&gt; &gt; software-based single stepping when hardware or SBI does not have=
<br>
&gt; &gt; icount functionality, as it may cause unwanted side effects when =
reading<br>
&gt; &gt; the instruction from memory.<br>
&gt; <br>
&gt; Can you please elaborate on this? I remember noticing the absence of<b=
r>
&gt; the resume flag which was causing loops.<br></blockquote><div><br></di=
v><div>Yes, signal handler=C2=A0based hardware debugging=C2=A0doesn&#39;t=
=C2=A0work, only ptrace based.<br>ARM64 and ARM also don&#39;t=C2=A0support=
=C2=A0signal handler=C2=A0based hardware debugging as seen in a later patch=
.</div><div><br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px=
 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">
Thank you for your feedback. Jesse&#39;s internship came to an end last<br>
Friday (August 22nd) so I will be picking up these patches, but I have<br>
also added her personal email onto this thread.<br></blockquote><div><br></=
div><div>I forgot to CC my personal email sorry....<br><br></div><blockquot=
e class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px s=
olid rgb(204,204,204);padding-left:1ex">
<br>
When a breakpoint is triggered and the kernel gains control, the last<br>
instruction to execute was the instruction before the instruction where<br>
the breakpoint is installed. If execution was to be resumed at this<br>
stage, the same breakpoint would be triggered again. So single stepping<br>
requires a careful dance of enabling and disabling breakpoints. However,<br=
>
we can avoid this overhead and code complexity can be reduced by using<br>
the icount trigger which allows a direct method for single stepping.<br>
<br>
&gt; <br>
&gt; &gt;<br>
&gt; &gt; Signed-off-by: Jesse Taube &lt;<a href=3D"mailto:jesse@rivosinc.c=
om" target=3D"_blank">jesse@rivosinc.com</a>&gt;<br>
&gt; &gt; ---<br>
&gt; &gt; OpenSBI implementation of sbi_debug_read_triggers does not return=
 the<br>
&gt; &gt; updated CSR values. There needs to be a check for working<br>
&gt; &gt; sbi_debug_read_triggers before this works.<br>
&gt; &gt;<br>
&gt; &gt; <a href=3D"https://lists.riscv.org/g/tech-prs/message/1476" rel=
=3D"noreferrer" target=3D"_blank">https://lists.riscv.org/g/tech-prs/messag=
e/1476</a><br>
&gt; &gt;<br>
&gt; &gt; RFC -&gt; V1:<br>
&gt; &gt;=C2=A0 - Add dbtr_mode to rv_init_icount_trigger<br>
&gt; &gt;=C2=A0 - Add icount_triggered to check which breakpoint was trigge=
red<br>
&gt; &gt;=C2=A0 - Fix typo: s/affects/effects<br>
&gt; &gt;=C2=A0 - Move HW_BREAKPOINT_COMPUTE_STEP to Platform type<br>
&gt; &gt; V1 -&gt; V2:<br>
&gt; &gt;=C2=A0 - Remove HW_BREAKPOINT_COMPUTE_STEP kconfig option<br>
&gt; &gt; ---<br>
&gt; &gt;=C2=A0 arch/riscv/kernel/hw_breakpoint.c | 173 +++++++++++++++++++=
+++++++----<br>
&gt; &gt;=C2=A0 1 file changed, 155 insertions(+), 18 deletions(-)<br>
&gt; &gt;<br>
&gt; &gt; diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kerne=
l/hw_breakpoint.c<br>
&gt; &gt; index 3f96e744a711..f12306247436 100644<br>
&gt; &gt; --- a/arch/riscv/kernel/hw_breakpoint.c<br>
&gt; &gt; +++ b/arch/riscv/kernel/hw_breakpoint.c<br>
&gt; &gt; @@ -20,6 +20,7 @@<br>
&gt; &gt;=C2=A0 #define DBTR_TDATA1_DMODE=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 BIT_UL(__riscv_xlen - 5)<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 #define DBTR_TDATA1_TYPE_MCONTROL=C2=A0 =C2=A0 =C2=A0 (2UL =
&lt;&lt; DBTR_TDATA1_TYPE_SHIFT)<br>
&gt; &gt; +#define DBTR_TDATA1_TYPE_ICOUNT=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 (3UL &lt;&lt; DBTR_TDATA1_TYPE_SHIFT)<br>
&gt; &gt;=C2=A0 #define DBTR_TDATA1_TYPE_MCONTROL6=C2=A0 =C2=A0 =C2=A0(6UL =
&lt;&lt; DBTR_TDATA1_TYPE_SHIFT)<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 #define DBTR_TDATA1_MCONTROL6_LOAD=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0BIT(0)<br>
&gt; &gt; @@ -62,6 +63,14 @@<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(FIELD_PREP(DBTR_TDATA1_MCONTROL=
_SIZELO_FIELD, lo) | \<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 FIELD_PREP(DBTR_TDATA1_MCONTROL=
_SIZEHI_FIELD, hi))<br>
&gt; &gt;<br>
&gt; &gt; +#define DBTR_TDATA1_ICOUNT_U=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BIT(6)<br>
&gt; &gt; +#define DBTR_TDATA1_ICOUNT_S=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BIT(7)<br>
&gt; &gt; +#define DBTR_TDATA1_ICOUNT_PENDING=C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0BIT(8)<br>
&gt; &gt; +#define DBTR_TDATA1_ICOUNT_M=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0BIT(9)<br>
&gt; &gt; +#define DBTR_TDATA1_ICOUNT_COUNT_FIELD=C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0GENMASK(23, 10)<br>
&gt; &gt; +#define DBTR_TDATA1_ICOUNT_VU=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BIT(25)<br>
&gt; &gt; +#define DBTR_TDATA1_ICOUNT_VS=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BIT(26)<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 enum dbtr_mode {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DBTR_MODE_U =3D 0,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DBTR_MODE_S,<br>
&gt; &gt; @@ -79,6 +88,7 @@ static DEFINE_PER_CPU(union sbi_dbtr_shmem_entr=
y, sbi_dbtr_shmem);<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 /* number of debug triggers on this cpu . */<br>
&gt; &gt;=C2=A0 static int dbtr_total_num __ro_after_init;<br>
&gt; &gt; +static bool have_icount __ro_after_init;<br>
&gt; &gt;=C2=A0 static unsigned long dbtr_type __ro_after_init;<br>
&gt; &gt;=C2=A0 static unsigned long dbtr_init __ro_after_init;<br>
&gt; &gt;<br>
&gt; &gt; @@ -129,6 +139,7 @@ static int arch_smp_teardown_sbi_shmem(unsign=
ed int cpu)<br>
&gt; &gt;=C2=A0 static void init_sbi_dbtr(void)<br>
&gt; &gt;=C2=A0 {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0struct sbiret ret;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long dbtr_count =3D 0;<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 * Called by hw_breakpoint_slots=
 and arch_hw_breakpoint_init.<br>
&gt; &gt; @@ -143,6 +154,19 @@ static void init_sbi_dbtr(void)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retu=
rn;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_E=
XT_DBTR_NUM_TRIGGERS,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0DBTR_TDAT=
A1_TYPE_ICOUNT, 0, 0, 0, 0, 0);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret.error) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_warn(&=
quot;%s: failed to detect icount triggers. error: %ld.\n&quot;,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0__func__, ret.error);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (!ret.value) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_warn(&=
quot;%s: No icount triggers available. &quot;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0&quot;Falling-back to computing single step address.\n&=
quot;, __func__);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr_coun=
t =3D ret.value;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0have_icou=
nt =3D true;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sbi_ecall(SBI_EXT_DBTR, =
SBI_EXT_DBTR_NUM_TRIGGERS,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0DBTR_TDATA1_TYPE_MCONTROL6, 0, 0, 0, 0, 0);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret.error) {<br>
&gt; &gt; @@ -151,7 +175,7 @@ static void init_sbi_dbtr(void)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (!ret.value) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_w=
arn(&quot;%s: No mcontrol6 triggers available.\n&quot;, __func__);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr_tota=
l_num =3D ret.value;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr_tota=
l_num =3D min_not_zero((unsigned long)ret.value, dbtr_count);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr=
_type =3D DBTR_TDATA1_TYPE_MCONTROL6;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retu=
rn;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; @@ -166,7 +190,7 @@ static void init_sbi_dbtr(void)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_e=
rr(&quot;%s: No mcontrol triggers available.\n&quot;, __func__);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr=
_total_num =3D 0;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr_tota=
l_num =3D ret.value;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr_tota=
l_num =3D min_not_zero((unsigned long)ret.value, dbtr_count);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0dbtr=
_type =3D DBTR_TDATA1_TYPE_MCONTROL;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt; @@ -320,6 +344,36 @@ static int rv_init_mcontrol6_trigger(const s=
truct perf_event_attr *attr,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt; +static int rv_init_icount_trigger(struct arch_hw_breakpoint *hw,=
 enum dbtr_mode mode)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long tdata1 =3D DBTR_TDATA1_=
TYPE_ICOUNT;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Step one instruction */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0tdata1 |=3D FIELD_PREP(DBTR_TDATA1_IC=
OUNT_COUNT_FIELD, 1);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0switch (mode) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0case DBTR_MODE_U:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tdata1 |=
=3D DBTR_TDATA1_ICOUNT_U;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br=
>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0case DBTR_MODE_S:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tdata1 |=
=3D DBTR_TDATA1_ICOUNT_S;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br=
>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0case DBTR_MODE_VS:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tdata1 |=
=3D DBTR_TDATA1_ICOUNT_VS;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br=
>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0case DBTR_MODE_VU:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0tdata1 |=
=3D DBTR_TDATA1_ICOUNT_VU;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0break;<br=
>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0default:<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
INVAL;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0hw-&gt;tdata1 =3D tdata1;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0hw-&gt;tdata2 =3D 0;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; &gt; +}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 int hw_breakpoint_arch_parse(struct perf_event *bp,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 const struct perf_event_attr *attr,<=
br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct arch_hw_breakpoint *hw)<br>
&gt; &gt; @@ -372,24 +426,28 @@ static int setup_singlestep(struct perf_eve=
nt *event, struct pt_regs *regs)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Remove breakpoint even if ret=
urn error as not to loop */<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0arch_uninstall_hw_breakpoint(eve=
nt);<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D get_insn_nofault(regs, regs-&=
gt;epc, &amp;insn);<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret &lt; 0)<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return re=
t;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (have_icount) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0rv_init_i=
count_trigger(bp, DBTR_MODE_U);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0} else {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D g=
et_insn_nofault(regs, regs-&gt;epc, &amp;insn);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret &=
lt; 0)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0next_addr =3D get_step_address(regs, =
insn);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0next_addr=
 =3D get_step_address(regs, insn);<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D get_insn_nofault(regs, next_a=
ddr, &amp;insn);<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret &lt; 0)<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return re=
t;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D g=
et_insn_nofault(regs, next_addr, &amp;insn);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret &=
lt; 0)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0bp_insn.bp_type =3D HW_BREAKPOINT_X;<=
br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0bp_insn.bp_addr =3D next_addr;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0/* Get the size of the intruction */<=
br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0bp_insn.bp_len =3D GET_INSN_LENGTH(in=
sn);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bp_insn.b=
p_type =3D HW_BREAKPOINT_X;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bp_insn.b=
p_addr =3D next_addr;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0/* Get th=
e size of the intruction */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0bp_insn.b=
p_len =3D GET_INSN_LENGTH(insn);<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D hw_breakpoint_arch_parse(NULL=
, &amp;bp_insn, bp);<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return re=
t;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D h=
w_breakpoint_arch_parse(NULL, &amp;bp_insn, bp);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)<=
br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0return ret;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D arch_install_hw_breakpoi=
nt(event);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret)<br>
&gt; &gt; @@ -400,6 +458,79 @@ static int setup_singlestep(struct perf_even=
t *event, struct pt_regs *regs)<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;<br>
&gt; &gt;=C2=A0 }<br>
&gt; &gt;<br>
&gt; &gt; +/**<br>
&gt; &gt; + * icount_triggered - Check if event&#39;s icount was triggered.=
<br>
&gt; &gt; + * @event: Perf event to check<br>
&gt; &gt; + *<br>
&gt; &gt; + * Check the given perf event&#39;s icount breakpoint was trigge=
red.<br>
&gt; &gt; + *<br>
&gt; &gt; + * Returns:=C2=A0 =C2=A0 1 if icount was triggered.<br>
&gt; &gt; + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 if icount wa=
s not triggered.<br>
&gt; &gt; + *=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0negative on fa=
ilure.<br>
&gt; &gt; + */<br>
&gt; &gt; +static int icount_triggered(struct perf_event *event)<br>
&gt; &gt; +{<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0union sbi_dbtr_shmem_entry *shmem =3D=
 this_cpu_ptr(&amp;sbi_dbtr_shmem);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct sbiret ret;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0struct perf_event **slot;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned long tdata1;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0int i;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0for (i =3D 0; i &lt; dbtr_total_num; =
i++) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0slot =3D =
this_cpu_ptr(&amp;pcpu_hw_bp_events[i]);<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (*slot=
 =3D=3D event)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0break;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (i =3D=3D dbtr_total_num) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_warn(&=
quot;%s: Breakpoint not installed.\n&quot;, __func__);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -E=
NOENT;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0raw_spin_lock_irqsave(this_cpu_ptr(&a=
mp;ecall_lock),<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*this_cpu_ptr(&amp;ecall_lock_flag=
s));<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D sbi_ecall(SBI_EXT_DBTR, SBI_E=
XT_DBTR_TRIG_READ,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0i, 1, 0, 0, 0, 0);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0tdata1 =3D shmem-&gt;data.tdata1;<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0raw_spin_unlock_irqrestore(this_cpu_p=
tr(&amp;ecall_lock),<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *this_cpu_ptr(&amp;=
ecall_lock_flags));<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret.error) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_warn(&=
quot;%s: failed to read trigger. error: %ld\n&quot;, __func__, ret.error);<=
br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return sb=
i_err_map_linux_errno(ret.error);<br>
&gt; <br>
&gt; To avoid a flurry of events or messages, it would probably be good to<=
br>
&gt; disable the trigger.<br>
<br>
That is a good point.<br></blockquote><div>=C2=A0</div><div>Agreed<br><br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">
&gt; <br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0/*<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * The RISC-V Debug Specification<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Tim Newsome, Paul Donahue (Ventana=
 Micro Systems)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * Version 1.0, Revised 2025-02-21: R=
atified<br>
&gt; I think mentioning the version number and section would be enough.<br>
<br>
Agreed.<br></blockquote><div><br></div><div>I wasn&#39;t sure the best way =
to=C2=A0cite this, Version number and section is ok with me.<br><br></div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">
&gt; <br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * 5.7.13. Instruction Count (icount,=
 at 0x7a1)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * When count is 1 and the trigger ma=
tches, then pending becomes set.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * In addition count will become 0 un=
less it is hard-wired to 1.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * When pending is set, the trigger f=
ires just before any further<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * instructions are executed in a mod=
e where the trigger is enabled.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * As the trigger fires, pending is c=
leared. In addition, if count is<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 * hard-wired to 1 then m, s, u, vs, =
and vu are all cleared.<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 */<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUN=
T_FIELD, tdata1) =3D=3D 0)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;=
<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUN=
T_FIELD, tdata1) !=3D 1)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;=
<br>
&gt; &gt; +<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tdata1 &amp; DBTR_TDATA1_ICOUNT_U=
)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;=
<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tdata1 &amp; DBTR_TDATA1_ICOUNT_S=
)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;=
<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tdata1 &amp; DBTR_TDATA1_ICOUNT_V=
U)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;=
<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (tdata1 &amp; DBTR_TDATA1_ICOUNT_V=
U)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return 0;=
<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0return 1;<br>
&gt; &gt; +}<br>
&gt; &gt; +<br>
&gt; &gt;=C2=A0 /*<br>
&gt; &gt;=C2=A0 =C2=A0* HW Breakpoint/watchpoint handler<br>
&gt; &gt;=C2=A0 =C2=A0*/<br>
&gt; &gt; @@ -460,7 +591,10 @@ static int hw_breakpoint_handler(struct pt_r=
egs *regs)<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (=
bp-&gt;in_callback) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0expecting_callback =3D true;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (regs-&gt;epc !=3D bp-&gt;next_addr) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0if (have_icount) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (icount_triggered(event)=
 !=3D 1)<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0continue;<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0} else if (regs-&gt;epc !=3D bp-&gt;next_addr) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0continue;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt; @@ -477,7 +611,10 @@ static int hw_breakpoint_handler(struct pt_r=
egs *regs)<br>
&gt; &gt;<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; &gt;<br>
&gt; &gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0if (expecting_callback) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0if (expecting_callback &amp;&amp; hav=
e_icount) {<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_err(&q=
uot;%s: in_callback was set, but icount was not triggered, epc (%lx).\n&quo=
t;,<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 __func__, regs-&gt;epc);<br>
&gt; &gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (expecting_callback) {<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pr_e=
rr(&quot;%s: in_callback was set, but epc (%lx) was not at next address(%lx=
).\n&quot;,<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 __func__, regs-&gt;epc, bp-&gt;next_addr);<br>
&gt; &gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0}<br>
&gt; <br>
&gt; Is this just for debugging or do you want to commit it?<br>
<br>
I believe this was intentional, but perhaps it is not a useful print.</bloc=
kquote><div><br></div><div>It is for someone to find out that a=C2=A0spurio=
us debug trigger event happened as it is expecting either an icount event o=
r</div><div>a mcontrol event at next_addr if this did not happen it will se=
nd a SIG_DEBUG to the user process.<br><br>Thanks,<br>Jesse</div><div><br><=
/div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bo=
rder-left:1px solid rgb(204,204,204);padding-left:1ex">=C2=A0<br></blockquo=
te><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bord=
er-left:1px solid rgb(204,204,204);padding-left:1ex">
- Charlie<br>
<br>
&gt; <br>
&gt; Regards<br>
&gt; Himanshu<br>
&gt; &gt; --<br>
&gt; &gt; 2.43.0<br>
&gt; &gt;<br>
</blockquote></div></div>

--000000000000de4c21063d705b19--

