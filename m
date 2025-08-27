Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CE21CA0FF6
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 08:04:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937F58E012C; Wed, 27 Aug 2025 04:04:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E81A8E0105; Wed, 27 Aug 2025 04:04:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B00E8E012C; Wed, 27 Aug 2025 04:04:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 475808E0105
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:04:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 036A7B9A9E
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:04:55 +0000 (UTC)
X-FDA: 83821801392.09.09E4813
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0A8DE180008
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:04:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Sxx2ewRJ;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf16.hostedemail.com: domain of charlie@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=charlie@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756281894; a=rsa-sha256;
	cv=none;
	b=63d5Dw8D+wCFp0VWcAgsGQ0AgCqDr8GtZFIGu6+FjLMrHJ8X6eyGAkJxF6WRbiL0/m4MpT
	9a0b+pi/V2CmmgaeBQEU62g5JgVrgn3SiNGUcEQlvbLkNbgGh/lZSyJX+NzX5xtg7NnNgK
	8gIW+LA/FdZDNwNFL75HC0GrgYkMQ4o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Sxx2ewRJ;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf16.hostedemail.com: domain of charlie@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=charlie@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756281894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=zjK51+2A52fHet//FxjRNjwkcJGNCioQhxdhxLuT9Eg=;
	b=O1N0cQsJpQxWascJ+aI3sSqHegL1PTjDs/CkwIJ9IpGuJSUuEJ9DZEPsoo8QdG/FzSampc
	se3tmmMYUyi15xvhhzQuAvrU3+3uRa3Rqz+LCNrzd0SvvWQF4+Ku/vMzDrqHjxem3N2rS6
	nSeHnj6pU83w9nzjJqEjtqdr3RjknSY=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b4755f37c3eso5685701a12.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 01:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1756281893; x=1756886693; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zjK51+2A52fHet//FxjRNjwkcJGNCioQhxdhxLuT9Eg=;
        b=Sxx2ewRJy+kqKU4l7471Cj+fP55wPIUURZMqUp/xXknKQUbd0Pjtj+oz+Q2Ub+dA41
         8cUMPu8hYU3NMLOEJYC8ZLH/pWwpizBk7Mxyu8pYsi4otWMtACWlAqoQvwXf2ssdbl/y
         A41wEW08T9D+ij/5CNgxFlVOallTvh2QhY0rxJFzIl56lfPhXrf7COt7M1N47KbxZkbY
         EEOFPzEp3LwdqVe2XuumEiKHQQclL37UeQfxphmV7DrZOT5g2zjuEb0wi/nL5eyPEjX2
         XLu/q85KVTNZsyCErIm4aF1EN+4lRnjY4YID1RDK+L8dcChPe1fItA3vLiOrauvSv5ok
         9H3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756281893; x=1756886693;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zjK51+2A52fHet//FxjRNjwkcJGNCioQhxdhxLuT9Eg=;
        b=EOp3lpb3AkOmI3CbswfctkG5u1wsUsARr62guj+Tr2vfZxElOPnGlHYnLniKlKOQ/9
         BZXFREzagcPKPaGbATKy+5xA+HeUb5H6IH9JIvA6IxrG6lCfVrO4BFwnx3r2Ix8ODLbf
         XynSyUJFlPOa+4ScH2CYakvE2DuKPhUK/U3odT15r+j+rIA3Qj4hB3HGAP+TNpItwrUe
         IkvOfrY8NDLAeDjZzUfefLwHvCug+l9F0FNQGABTj+vwCjgnARDhC3W/VQfGiR5aiGZ/
         zQTaMjDwASVeKMCtgQL3Ihtq0RMeDOlqAUaCybBDWZmS8HkXPyugrgzwqDKQhfV35g37
         Ytbw==
X-Forwarded-Encrypted: i=1; AJvYcCWaM80L0lnUshf63wBgnlXCjICUR6cnMP3mNiP4zejCL4I6c3tjtJtpbcKo1AMr+4zJTH8nNK7bEQ==@kvack.org
X-Gm-Message-State: AOJu0YxtM+zZNQc6ju+mNpwkFcc2Z43XFbSiNZSyOUvsfW4xMRfIOWvD
	oI6Ce5JD2M741FbyjLIGzGJe01kNwslgCgtvwdLSdqNqMoY7h2aVuRXCmRKfPktjsVE=
X-Gm-Gg: ASbGncvkVGQnl8r1RXo2d5b1U1B4Tpj6iRSn7rIrGyLCkux5dw7ADleyMNH7b7d//sv
	lJyu5xCyv1wupjvKsWsyb1gNa3HW8PoIzaPSMO2bAwPf3isWnDs+3ly/V7pvLIinhMUrK1Eoamh
	3vciynfoi4w62w0k6hQdxiewYkHMU5+9VrHj+txSPB3MF9Dd7LU994Y2kiyAENGiPLNGPD1bV8i
	20daGknIkxbncOP+Evi08tn4b1iPO36hfHDqAVI1pVZ+p2aumr6kKuOrWn3TNVp8obokFZEOnw0
	ixs8YfzHRQHNrDkAELKUGJeXlR5hohNwMVirSpMY1lY1bpn5KU4e8bllhf5yBgyBzMkASxOS7xv
	4WZyLaOXXX0I+Zo59mw==
X-Google-Smtp-Source: AGHT+IFmLVeBhKzJEqSUf1IlkeKSrgzItqcCx7zQbQCgDi+N7L9pd7Nncg0iDwIKNaLuKX3UWq7WIQ==
X-Received: by 2002:a17:90b:4fd0:b0:325:c92:4a89 with SMTP id 98e67ed59e1d1-32515e3cad8mr20990981a91.5.1756281892340;
        Wed, 27 Aug 2025 01:04:52 -0700 (PDT)
Received: from ghost ([2601:647:6700:64d0:c960:881a:73ea:37d7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3276f6b7458sm1367809a91.12.2025.08.27.01.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 01:04:51 -0700 (PDT)
Date: Wed, 27 Aug 2025 01:04:48 -0700
From: Charlie Jenkins <charlie@rivosinc.com>
To: Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Jesse Taube <Mr.Bossman075@gmail.com>
Cc: linux-riscv@lists.infradead.org,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Oleg Nesterov <oleg@redhat.com>, Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Liang Kan <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Deepak Gupta <debug@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	WangYuli <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Joel Granados <joel.granados@kernel.org>,
	=?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <cleger@rivosinc.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Celeste Liu <coelacanthushex@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nylon Chen <nylon.chen@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Joel Stanley <joel@jms.id.au>
Subject: Re: [PATCH 5/8] riscv: hw_breakpoint: Use icount for single stepping
Message-ID: <aK68IJPqa4YOo1S_@ghost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPd4Wexw_DtndDqRZzXK0PEOAkb4yWB4x8rf5eRdJOLMS-+8SQ@mail.gmail.com>
X-Rspamd-Queue-Id: 0A8DE180008
X-Stat-Signature: a193mx6ip5krquh1pcysqsfrke73r4up
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756281893-299365
X-HE-Meta: U2FsdGVkX19A2qhpHfoq0aa1aeYpjo9ojiiEQTCJr8+5+N2SjhOuNvxomhumcHXJu+O1u70eS+hUob1lRg+LePhUBXQJ6mULSWrTiKTvKbMd4ziX3jv4gCbZu6hXruW81q5AsuA8Az0OtG+7WabfNDfUOyZoVSwV2p2QXNrBpEIxHEAMvRrd70R6CofNfusJM1kxYjxQT4LJprsRFice42k+oGve5uibFjsKisZzsrQonFWtIpcXWGhyqsbVAAjQhVd44aOOGqHEDx4Z1MKINEy1H6eaZtVwUVXk22phD1n3EcGvljaDLoREDZmEKrwdfc7dGsWHa9DhPys0vtPxdUyPSqD07Mrb3bzVRPnmNT9YWY3MvEmKnIXC+r/9Sb/bFg3M1K44hKTne8jiimnI0qiepgX2XHx0PIKyU1J6HrBt6Ofe18RQPaxWeGzSrvW9YZkHlZNqMvKZPbfWsY4t/PiG680krgZ52HQQrpPwLD0J96yHByPQ/uQl9LJM5ET3V6e7e4VNXQl5QN8P7Mp4ZXteXO0t+dJweoGBJFfTkq2/PfaIpIKZe8qvK0LmMsOPwpfbseaJ9kuzRQKCmrSfJ9VHfHXtV9LnL4iSpjH8w0FF23Qg74792KqrI8KbZ/yki9z1+4PTuZV0Aah4yRW/tGArOllDELrFuEgENfW2twLz6px33l3zowcYDraqMyTKfhFrO31Yika1yeC3jSi5jERqOg4+gmsgZeiYMe6Cnm3FLw9w8bvFWn4iB7Cl0RGPYnHLKsUQC6Baz2t0MHpACqFwzuhJ801U2fBrL/s/Eig+8BRdznIUp7ciEGkbG2lwCsc2++ycS5yMlvciQfB3YsqjPfnEDjZri6LXaBzBcOJjR0PQWYD4uSmil/NWqRvAPHjr0Xz7ia1JCsW1SyHSrIUlgaK/havvDmQT2Z6NCx/ugJ98PVxUOU+3mN1uEZtpKPItBv4Xqb1tTID7q8r
 RXTVrXTb
 pNRY+GQd0sfXywQUb8tAl4QthCf7i/TZVHyDeNCoyfeSBJs+8ew2+ehD9hrE4tO37EjLRVTRI92FO3hR9OWqr6hDdlPMBIFacGzCPEhRf/zW66jBTJ8BLMNpR1Js+pBgiGNcfAxGyr+oK9dGxWKF7NV2Cr92M9wFKq5QQ4MWJuND50A4QQ/8VtUqqNqp+LVZU+TqCDQZPjxxGoSI6pJVtCrwCxztziS/3a/u95KP0M6Az6OCO/whQVVW2vtXnA0677p+RtBPHKCI1qk+mXczxRLTCCSlJ07uhyxO9yr/xLX/VhbXdr0GHhAKzuCe2fdEpsw5uV34OcfLzBatrdvAsEgLgCOknQDXqkLIjvkrLCKSJT5G0EEL+7psqPw9CdWJ/F2B5w/PjvNO+fg3uDpRMYk00Z2uhuvIp7BiMKPzQEKtU1XNhE0ZaxYrIqnTDs4PJv1ru+t4l538IgQ61j6W+Zl4NQdhAI2iCwtD67vkmXDFCZM+bHl5f6gt6Oz/NRcg05LtQyMr4Ajhzbs1kQg/dnh1EqwarRImSPt/ckwSyPzG0R1ysL1TMUADaLOlOxy7LrTw4KoF368PqPys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 10:08:04AM +0530, Himanshu Chauhan wrote:
> On Fri, Aug 22, 2025 at 11:17 PM Jesse Taube <jesse@rivosinc.com> wrote:
> >
> > The Sdtrig RISC-V ISA extension does not have a resume flag for
> > returning to and executing the instruction at the breakpoint.
> > To avoid skipping the instruction or looping, it is necessary to remove
> > the hardware breakpoint and single step. Use the icount feature of
> > Sdtrig to accomplish this. Use icount as default with an option to allow
> > software-based single stepping when hardware or SBI does not have
> > icount functionality, as it may cause unwanted side effects when reading
> > the instruction from memory.
> 
> Can you please elaborate on this? I remember noticing the absence of
> the resume flag which was causing loops.

Thank you for your feedback. Jesse's internship came to an end last
Friday (August 22nd) so I will be picking up these patches, but I have
also added her personal email onto this thread.

When a breakpoint is triggered and the kernel gains control, the last
instruction to execute was the instruction before the instruction where
the breakpoint is installed. If execution was to be resumed at this
stage, the same breakpoint would be triggered again. So single stepping
requires a careful dance of enabling and disabling breakpoints. However,
we can avoid this overhead and code complexity can be reduced by using
the icount trigger which allows a direct method for single stepping.

> 
> >
> > Signed-off-by: Jesse Taube <jesse@rivosinc.com>
> > ---
> > OpenSBI implementation of sbi_debug_read_triggers does not return the
> > updated CSR values. There needs to be a check for working
> > sbi_debug_read_triggers before this works.
> >
> > https://lists.riscv.org/g/tech-prs/message/1476
> >
> > RFC -> V1:
> >  - Add dbtr_mode to rv_init_icount_trigger
> >  - Add icount_triggered to check which breakpoint was triggered
> >  - Fix typo: s/affects/effects
> >  - Move HW_BREAKPOINT_COMPUTE_STEP to Platform type
> > V1 -> V2:
> >  - Remove HW_BREAKPOINT_COMPUTE_STEP kconfig option
> > ---
> >  arch/riscv/kernel/hw_breakpoint.c | 173 ++++++++++++++++++++++++++----
> >  1 file changed, 155 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/riscv/kernel/hw_breakpoint.c b/arch/riscv/kernel/hw_breakpoint.c
> > index 3f96e744a711..f12306247436 100644
> > --- a/arch/riscv/kernel/hw_breakpoint.c
> > +++ b/arch/riscv/kernel/hw_breakpoint.c
> > @@ -20,6 +20,7 @@
> >  #define DBTR_TDATA1_DMODE              BIT_UL(__riscv_xlen - 5)
> >
> >  #define DBTR_TDATA1_TYPE_MCONTROL      (2UL << DBTR_TDATA1_TYPE_SHIFT)
> > +#define DBTR_TDATA1_TYPE_ICOUNT                (3UL << DBTR_TDATA1_TYPE_SHIFT)
> >  #define DBTR_TDATA1_TYPE_MCONTROL6     (6UL << DBTR_TDATA1_TYPE_SHIFT)
> >
> >  #define DBTR_TDATA1_MCONTROL6_LOAD             BIT(0)
> > @@ -62,6 +63,14 @@
> >         (FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZELO_FIELD, lo) | \
> >          FIELD_PREP(DBTR_TDATA1_MCONTROL_SIZEHI_FIELD, hi))
> >
> > +#define DBTR_TDATA1_ICOUNT_U                   BIT(6)
> > +#define DBTR_TDATA1_ICOUNT_S                   BIT(7)
> > +#define DBTR_TDATA1_ICOUNT_PENDING             BIT(8)
> > +#define DBTR_TDATA1_ICOUNT_M                   BIT(9)
> > +#define DBTR_TDATA1_ICOUNT_COUNT_FIELD         GENMASK(23, 10)
> > +#define DBTR_TDATA1_ICOUNT_VU                  BIT(25)
> > +#define DBTR_TDATA1_ICOUNT_VS                  BIT(26)
> > +
> >  enum dbtr_mode {
> >         DBTR_MODE_U = 0,
> >         DBTR_MODE_S,
> > @@ -79,6 +88,7 @@ static DEFINE_PER_CPU(union sbi_dbtr_shmem_entry, sbi_dbtr_shmem);
> >
> >  /* number of debug triggers on this cpu . */
> >  static int dbtr_total_num __ro_after_init;
> > +static bool have_icount __ro_after_init;
> >  static unsigned long dbtr_type __ro_after_init;
> >  static unsigned long dbtr_init __ro_after_init;
> >
> > @@ -129,6 +139,7 @@ static int arch_smp_teardown_sbi_shmem(unsigned int cpu)
> >  static void init_sbi_dbtr(void)
> >  {
> >         struct sbiret ret;
> > +       unsigned long dbtr_count = 0;
> >
> >         /*
> >          * Called by hw_breakpoint_slots and arch_hw_breakpoint_init.
> > @@ -143,6 +154,19 @@ static void init_sbi_dbtr(void)
> >                 return;
> >         }
> >
> > +       ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
> > +               DBTR_TDATA1_TYPE_ICOUNT, 0, 0, 0, 0, 0);
> > +       if (ret.error) {
> > +               pr_warn("%s: failed to detect icount triggers. error: %ld.\n",
> > +                       __func__, ret.error);
> > +       } else if (!ret.value) {
> > +               pr_warn("%s: No icount triggers available. "
> > +                       "Falling-back to computing single step address.\n", __func__);
> > +       } else {
> > +               dbtr_count = ret.value;
> > +               have_icount = true;
> > +       }
> > +
> >         ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_NUM_TRIGGERS,
> >                         DBTR_TDATA1_TYPE_MCONTROL6, 0, 0, 0, 0, 0);
> >         if (ret.error) {
> > @@ -151,7 +175,7 @@ static void init_sbi_dbtr(void)
> >         } else if (!ret.value) {
> >                 pr_warn("%s: No mcontrol6 triggers available.\n", __func__);
> >         } else {
> > -               dbtr_total_num = ret.value;
> > +               dbtr_total_num = min_not_zero((unsigned long)ret.value, dbtr_count);
> >                 dbtr_type = DBTR_TDATA1_TYPE_MCONTROL6;
> >                 return;
> >         }
> > @@ -166,7 +190,7 @@ static void init_sbi_dbtr(void)
> >                 pr_err("%s: No mcontrol triggers available.\n", __func__);
> >                 dbtr_total_num = 0;
> >         } else {
> > -               dbtr_total_num = ret.value;
> > +               dbtr_total_num = min_not_zero((unsigned long)ret.value, dbtr_count);
> >                 dbtr_type = DBTR_TDATA1_TYPE_MCONTROL;
> >         }
> >  }
> > @@ -320,6 +344,36 @@ static int rv_init_mcontrol6_trigger(const struct perf_event_attr *attr,
> >         return 0;
> >  }
> >
> > +static int rv_init_icount_trigger(struct arch_hw_breakpoint *hw, enum dbtr_mode mode)
> > +{
> > +       unsigned long tdata1 = DBTR_TDATA1_TYPE_ICOUNT;
> > +
> > +       /* Step one instruction */
> > +       tdata1 |= FIELD_PREP(DBTR_TDATA1_ICOUNT_COUNT_FIELD, 1);
> > +
> > +       switch (mode) {
> > +       case DBTR_MODE_U:
> > +               tdata1 |= DBTR_TDATA1_ICOUNT_U;
> > +               break;
> > +       case DBTR_MODE_S:
> > +               tdata1 |= DBTR_TDATA1_ICOUNT_S;
> > +               break;
> > +       case DBTR_MODE_VS:
> > +               tdata1 |= DBTR_TDATA1_ICOUNT_VS;
> > +               break;
> > +       case DBTR_MODE_VU:
> > +               tdata1 |= DBTR_TDATA1_ICOUNT_VU;
> > +               break;
> > +       default:
> > +               return -EINVAL;
> > +       }
> > +
> > +       hw->tdata1 = tdata1;
> > +       hw->tdata2 = 0;
> > +
> > +       return 0;
> > +}
> > +
> >  int hw_breakpoint_arch_parse(struct perf_event *bp,
> >                              const struct perf_event_attr *attr,
> >                              struct arch_hw_breakpoint *hw)
> > @@ -372,24 +426,28 @@ static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
> >         /* Remove breakpoint even if return error as not to loop */
> >         arch_uninstall_hw_breakpoint(event);
> >
> > -       ret = get_insn_nofault(regs, regs->epc, &insn);
> > -       if (ret < 0)
> > -               return ret;
> > +       if (have_icount) {
> > +               rv_init_icount_trigger(bp, DBTR_MODE_U);
> > +       } else {
> > +               ret = get_insn_nofault(regs, regs->epc, &insn);
> > +               if (ret < 0)
> > +                       return ret;
> >
> > -       next_addr = get_step_address(regs, insn);
> > +               next_addr = get_step_address(regs, insn);
> >
> > -       ret = get_insn_nofault(regs, next_addr, &insn);
> > -       if (ret < 0)
> > -               return ret;
> > +               ret = get_insn_nofault(regs, next_addr, &insn);
> > +               if (ret < 0)
> > +                       return ret;
> >
> > -       bp_insn.bp_type = HW_BREAKPOINT_X;
> > -       bp_insn.bp_addr = next_addr;
> > -       /* Get the size of the intruction */
> > -       bp_insn.bp_len = GET_INSN_LENGTH(insn);
> > +               bp_insn.bp_type = HW_BREAKPOINT_X;
> > +               bp_insn.bp_addr = next_addr;
> > +               /* Get the size of the intruction */
> > +               bp_insn.bp_len = GET_INSN_LENGTH(insn);
> >
> > -       ret = hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
> > -       if (ret)
> > -               return ret;
> > +               ret = hw_breakpoint_arch_parse(NULL, &bp_insn, bp);
> > +               if (ret)
> > +                       return ret;
> > +       }
> >
> >         ret = arch_install_hw_breakpoint(event);
> >         if (ret)
> > @@ -400,6 +458,79 @@ static int setup_singlestep(struct perf_event *event, struct pt_regs *regs)
> >         return 0;
> >  }
> >
> > +/**
> > + * icount_triggered - Check if event's icount was triggered.
> > + * @event: Perf event to check
> > + *
> > + * Check the given perf event's icount breakpoint was triggered.
> > + *
> > + * Returns:    1 if icount was triggered.
> > + *             0 if icount was not triggered.
> > + *             negative on failure.
> > + */
> > +static int icount_triggered(struct perf_event *event)
> > +{
> > +       union sbi_dbtr_shmem_entry *shmem = this_cpu_ptr(&sbi_dbtr_shmem);
> > +       struct sbiret ret;
> > +       struct perf_event **slot;
> > +       unsigned long tdata1;
> > +       int i;
> > +
> > +       for (i = 0; i < dbtr_total_num; i++) {
> > +               slot = this_cpu_ptr(&pcpu_hw_bp_events[i]);
> > +
> > +               if (*slot == event)
> > +                       break;
> > +       }
> > +
> > +       if (i == dbtr_total_num) {
> > +               pr_warn("%s: Breakpoint not installed.\n", __func__);
> > +               return -ENOENT;
> > +       }
> > +
> > +       raw_spin_lock_irqsave(this_cpu_ptr(&ecall_lock),
> > +                             *this_cpu_ptr(&ecall_lock_flags));
> > +
> > +       ret = sbi_ecall(SBI_EXT_DBTR, SBI_EXT_DBTR_TRIG_READ,
> > +                       i, 1, 0, 0, 0, 0);
> > +       tdata1 = shmem->data.tdata1;
> > +
> > +       raw_spin_unlock_irqrestore(this_cpu_ptr(&ecall_lock),
> > +                                  *this_cpu_ptr(&ecall_lock_flags));
> > +       if (ret.error) {
> > +               pr_warn("%s: failed to read trigger. error: %ld\n", __func__, ret.error);
> > +               return sbi_err_map_linux_errno(ret.error);
> 
> To avoid a flurry of events or messages, it would probably be good to
> disable the trigger.

That is a good point.

> 
> > +       }
> > +
> > +       /*
> > +        * The RISC-V Debug Specification
> > +        * Tim Newsome, Paul Donahue (Ventana Micro Systems)
> > +        * Version 1.0, Revised 2025-02-21: Ratified
> I think mentioning the version number and section would be enough.

Agreed.

> 
> > +        * 5.7.13. Instruction Count (icount, at 0x7a1)
> > +        * When count is 1 and the trigger matches, then pending becomes set.
> > +        * In addition count will become 0 unless it is hard-wired to 1.
> > +        * When pending is set, the trigger fires just before any further
> > +        * instructions are executed in a mode where the trigger is enabled.
> > +        * As the trigger fires, pending is cleared. In addition, if count is
> > +        * hard-wired to 1 then m, s, u, vs, and vu are all cleared.
> > +        */
> > +       if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) == 0)
> > +               return 1;
> > +
> > +       if (FIELD_GET(DBTR_TDATA1_ICOUNT_COUNT_FIELD, tdata1) != 1)
> > +               return 0;
> > +
> > +       if (tdata1 & DBTR_TDATA1_ICOUNT_U)
> > +               return 0;
> > +       if (tdata1 & DBTR_TDATA1_ICOUNT_S)
> > +               return 0;
> > +       if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
> > +               return 0;
> > +       if (tdata1 & DBTR_TDATA1_ICOUNT_VU)
> > +               return 0;
> > +       return 1;
> > +}
> > +
> >  /*
> >   * HW Breakpoint/watchpoint handler
> >   */
> > @@ -460,7 +591,10 @@ static int hw_breakpoint_handler(struct pt_regs *regs)
> >
> >                 if (bp->in_callback) {
> >                         expecting_callback = true;
> > -                       if (regs->epc != bp->next_addr) {
> > +                       if (have_icount) {
> > +                               if (icount_triggered(event) != 1)
> > +                                       continue;
> > +                       } else if (regs->epc != bp->next_addr) {
> >                                 continue;
> >                         }
> >
> > @@ -477,7 +611,10 @@ static int hw_breakpoint_handler(struct pt_regs *regs)
> >
> >         }
> >
> > -       if (expecting_callback) {
> > +       if (expecting_callback && have_icount) {
> > +               pr_err("%s: in_callback was set, but icount was not triggered, epc (%lx).\n",
> > +                      __func__, regs->epc);
> > +       } else if (expecting_callback) {
> >                 pr_err("%s: in_callback was set, but epc (%lx) was not at next address(%lx).\n",
> >                        __func__, regs->epc, bp->next_addr);
> >         }
> 
> Is this just for debugging or do you want to commit it?

I believe this was intentional, but perhaps it is not a useful print.

- Charlie

> 
> Regards
> Himanshu
> > --
> > 2.43.0
> >

