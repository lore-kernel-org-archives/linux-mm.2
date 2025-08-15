Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEABFCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C01490024F; Fri, 15 Aug 2025 11:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5964E90024B; Fri, 15 Aug 2025 11:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACA090024F; Fri, 15 Aug 2025 11:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35A7D90024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:07:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6531137402
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:07:35 +0000 (UTC)
X-FDA: 83779320870.18.2B09E04
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 99E4A20017
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:07:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=dabbelt-com.20230601.gappssmtp.com header.s=20230601 header.b=HvVGHLhe;
	spf=pass (imf03.hostedemail.com: domain of palmer@dabbelt.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=palmer@dabbelt.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755270453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=EHLPRMwsFUXklJ+HOrV/DsMAdiggx2WSG2UfKCJiulY=;
	b=3MqTHdus7cJyDCKeU9nhxeNSvQifRFu8a5eaqFq1SLkzLaA9NtsafGX87cJv8cpsmPonwD
	6Rg+LHokaWVImfVZZKJrvIODOQuOEB2LzHBQpDRcIXHnudOlFZKQ6JLrq+7peH/aHnN3dH
	NvWMsBt1OjmC+GQcUR7HTtAStO3FO1I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=dabbelt-com.20230601.gappssmtp.com header.s=20230601 header.b=HvVGHLhe;
	spf=pass (imf03.hostedemail.com: domain of palmer@dabbelt.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=palmer@dabbelt.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755270453; a=rsa-sha256;
	cv=none;
	b=WOmkNdRabOGtdIcKrAE273OiF574stKcg/1mkXJwkf7WQfCy9mCqQN9wy+qZrHSqJGzONJ
	xTyCftp4R/VOr17dMDVEoAkBYvaAb6FVOO9oILWv4ijUsJunExad5VOhjs+d2SLEyeu4Im
	CTPRyY0h/U7Mb36RPmotxa5suHIobYo=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76e2e8e54f8so1854136b3a.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1755270452; x=1755875252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHLPRMwsFUXklJ+HOrV/DsMAdiggx2WSG2UfKCJiulY=;
        b=HvVGHLhebhie4G/i7+Z9le1HeKgILVCrcTN/7cACibxriXGInnxrCjK8jvuli+ORYf
         WfaEkDJny434RP9uQCoMSWq4CbyDOGQQNMINmj/YFLe6otzKaTPIPCyTX05K9MW3lrRA
         tQPg0NT4roNWb5X0eUAqkJB4aTrNZO5BOl21IuKRuR3ap3O00waM0f4FRYdVztlZzigG
         9I/d2nw44EKfKbL/sASfwypFVbqKnuHqwMXsM4zWoQcwd+BVTpJjaQtwNlPfZ5XHmN7E
         qsj4aPnkEl2l0QX766H3x0s5H2e68IjGmoV/zqkee+2Ry76ewdOSLAljLfI3qGebBf3w
         GPKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270452; x=1755875252;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EHLPRMwsFUXklJ+HOrV/DsMAdiggx2WSG2UfKCJiulY=;
        b=HrxDiD+o4mC6hO1vkaHbeEjhT8E48B+FjidLKtDb8VuIaHpPSeFesEwneGnyPEurdN
         Y+QtxuQxsGPAmyOTlTm1DFbLq2JW0hMZym7LQXJbveaShuP+kjJ487rgG7nNn5aJTlpm
         X56nOXrvWfqhuVeDHtiSdXU5QWR3XFCg1OErB6tantwDtOzvQaaySbqi7uJvS2ZepUfm
         6x2G+096DrNE6IUSTpFSepZrj5kHqO5PhBbPUQxQOsmmT7hImbfOMyG5m0YDQ9jfN/g6
         70mazrdLvBkdBvO/2bhTSLvZyTJYQJCo7n08FDtfYTJYBkua7NkRj1B7dzIf1akvoKXq
         +6DQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU2rv9Hk5zzuYo6e7f+YxgYCb7OP+JOKbmBW2weDr5//PmkWNs/BlOIiP/LJT4xA8LlJ4ctgdL2w==@kvack.org
X-Gm-Message-State: AOJu0Yz65lzr2NOsIGhMn6Nat2JG1zFNphJqgP6lYx759H1xZQCpKfaS
	eqrN4prskpJ50LBm/ZQvPuO42/hjdQuW/a0P3Uqig73dEH05K6IPiqoHM4OgnRKrDWc=
X-Gm-Gg: ASbGncu6VOKgZtFUMOq2B8O/ziIMdCOtVknWVnsNtsjjOM0fN+wMHnTCj89UiiGtqyg
	i0wv1l0jSvAcdQjuDg9fxENSeP/LfdcK3/o5o8b4iNJPC01p1qVU9tZX6pjkJY9CwkIj0UbmGEh
	TgLawmS9lqtlmZG3+kdzxZJgFZJ/2tYLZWsQl3RnQvuI2r48hKGS7eAsY9PuWpcvRzesK8IpQCm
	KrdLXfWfA0IqmXGOa04ENNmTZxmNdgJ0FBTuFRZNsDmEghY8Bszz6TsosCkLL1f2GnWu147F96L
	ksGbK3yxi1H79LnmLZ7QHX2FTWuPu+OmcBzTGg4G75ENvZ36qqjUurZpp9ULXkzg2W4s2NxaHrI
	ggh+7mf3AVfzAVZVo72j6THe79Kqal0NrXLo=
X-Google-Smtp-Source: AGHT+IHmxnV+YR9cR/LeaPBJErhvHjNkppxMDemXEcOX3MCe4Sp9OWex1hLOxvkMk2wkz7dST8S4eg==
X-Received: by 2002:a05:6a00:4f96:b0:769:a6a2:fe1e with SMTP id d2e1a72fcca58-76e447e3389mr3104455b3a.11.1755270452302;
        Fri, 15 Aug 2025 08:07:32 -0700 (PDT)
Received: from localhost ([192.184.165.199])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-76e4558bf19sm1309791b3a.99.2025.08.15.08.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 08:07:31 -0700 (PDT)
Date: Fri, 15 Aug 2025 08:07:31 -0700 (PDT)
X-Google-Original-Date: Fri, 15 Aug 2025 08:06:56 PDT (-0700)
Subject:     Re: [PATCH v4 17/24] riscv: vdso: Deduplicate CFLAGS_REMOVE_* variables
In-Reply-To: <20250812-vdso-absolute-reloc-v4-17-61a8b615e5ec@linutronix.de>
CC: Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu,
  Alexandre Ghiti <alex@ghiti.fr>, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com,
  justinstitt@google.com, luto@kernel.org, tglx@linutronix.de, vincenzo.frascino@arm.com,
  kees@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
  hpa@zytor.com, richard@nod.at, anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
  linux@armlinux.org.uk, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
  maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
  chenhuacai@kernel.org, kernel@xen0n.name, hca@linux.ibm.com, gor@linux.ibm.com,
  agordeev@linux.ibm.com, borntraeger@linux.ibm.com, svens@linux.ibm.com, tsbogend@alpha.franken.de,
  ojeda@kernel.org, alex.gaynor@gmail.com, boqun.feng@gmail.com, gary@garyguo.net,
  bjorn3_gh@protonmail.com, lossin@kernel.org, a.hindborg@kernel.org, aliceryhl@google.com,
  tmgross@umich.edu, dakr@kernel.org, nicolas.schier@linux.dev, linux-riscv@lists.infradead.org,
  linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org,
  linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
  linux-s390@vger.kernel.org, linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org,
  linux-kbuild@vger.kernel.org, jstancek@redhat.com, acme@redhat.com, alexghiti@rivosinc.com,
  thomas.weissschuh@linutronix.de
From: Palmer Dabbelt <palmer@dabbelt.com>
To: thomas.weissschuh@linutronix.de
Message-ID: <mhng-540E0EE0-A9CF-4EE3-9E71-969B40D29C50@Palmers-Mini.rwc.dabbelt.com>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s8odzbhxo16ahqb8rhpjpi9zyao44i8o
X-Rspam-User: 
X-Rspamd-Queue-Id: 99E4A20017
X-Rspamd-Server: rspam05
X-HE-Tag: 1755270453-634040
X-HE-Meta: U2FsdGVkX19Z3orbsH1KlO2ZfxrLsq+a1jnHfuDi+lvyZzoUxTZRkfdjg3mgTtVox/UKacPsKzsr+0q8NEIzNCtlpNsfvgLz8l/pKB6Ght9kzic2z1zXHEoHzy0ANucMVA7bJW/93kS7MAn1mq+ePm0+PfwhZPJVeZNG7waOwc2yeZ2XLGNZTAbvlWpDrRLl57W5W/xfpIGsUQoHyplHGOOnAo1+V10Boe774y/Stmh92XGF3GMPqGzUZGdbC85MBHIR7jWMbcxiXFXl/82iY4KtIcC2cAVZS4ROy7I6nkxQHltnbwAoc6oW9UL5E7SxRosYtkwCtTaXSbHGqDipMXn97dacW6jBEc697bkWMj2UMdMtIrGA3QR3kdQLQNYGButDBX9ZXJS9fBIV7ghkGlHDv7nJVVyMEkTbabrBuJlg8G+MnFyPUHbuEGD0oqLAu9Yhl7A1/OoAT9X/oWKBzTnS5E++FgMerV3ntfwuXSwWJH+bw8Kqe92hsFytPqeSQolSAtjYZxnzjw+9wvWzqKli3H2O8lNx84N5qL8au64oiXp40pU/3ob9J6YZK4YWmI0QXK9nNDnGm+882+PHq4rtkieKA4X/zRoYHGmMirDmCbXJIZtpfNgbKK5zUhGY2Y3EBKJKQxjfInepRIvmym6qFFvoF48WxN0ELPblaq24IP0xhhNVbkTqiyZIN3Jwmid4QNN4yBxgrJqgqOrGm/EuJERqSCYPBkcY0gY6TEUHPJ/3B2QxkP0Y5m2Ivjep0ISp41kRbapqoxzzzZYwwT9/97vP5iuy9PqPRpfLYDTFKfAQ4bwbd5Yro+hdhDbDf/Aa5SRT+4urM/ac9Kx7xlPBfCH8LWE2rgoARSBBckz6hZCiZV43qUg1hS8P/6C/R+thiB95J6oB55/MuUmcQmoURToh8urp4Yd3OfpF5iHA9X+zc3hs+a2NgxDK0wyQ6M3M6LEwcgm3aDduD8r
 OspzgBP4
 8erHSpRrguZeFMk/7YCvkZ37aYlP8AQj+XMuseNNMPDcraBF1O4GL9E8USKWIIqp9epROGber1Y6NpzEBXZdGuuOOKhkzqCvn0gO1MCY0IQ9gObwqIN/pKNM0IUrbs6Gff+qN3Lbn3t+94nePjo66t8nT8Rm0BM4OLb3zO2l59nHiuCsgtS633fFQSK0w2ACDrFXm20NxBgxWt9xQcOIJMfFo9FC6ClwXeTvQdVzyk6L8z/xerMqcvtxZiKhg7NjQ5WKO6YTUBZZ0kWFupOtkVx8shwLLYhTGsiHdtJII+wJ4vDol5KdSY2blXLvyr9kGuwNF3+eZfoZQnVYhtIJF6ouC6Ic56lsl4l0R2MMiwdEq8SQGa6AxfAKCpJbSXDuoRjK0rHofKV3Xh4EMQvq/fF/LaHE8n28x8QyrFsAyjB7K9yNJFie80aWoPdoXYrI4AowfiV/94XFkEFDpnyXAvV97SpP6k4/YxdTAbDhgECnfIKD/XZfAuCJgBdd+1o4QWQXJMV8D1tLGbKq2ggzdrIFg4Yhs5LFApESQxQh05LQW3+Lag+FpFVbAz23d1VTvlmbrZ3qgfbtqKZLIdT9zo4bobfpiSJYNq9owgXr/tcZYB3FhC9jBV/MIYzvFbbzVk9KxRWu5siFRAAtU2WkMnQv82d5bSzELZe/o6kf1gvQjpGxhYrc3qIfuvtccYMRFuVU3oPDXJQrtZGWNRTFydnnAVYl6VIS4qbphLuIPKuXHfyNAgONlg+iTDo/sBMheMx7MWKS9PxlDAMZqMqWXPN3MZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 Aug 2025 22:44:30 PDT (-0700), thomas.weissschuh@linutronix.de wrote:
> All vDSO objects need the same treatment.
> To make changes to both the list of objects and the list of removed flags
> easier, introduce a helper variable.
>
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
> Reviewed-by: Nathan Chancellor <nathan@kernel.org>
> Tested-by: Jan Stancek <jstancek@redhat.com>
> ---
>  arch/riscv/kernel/vdso/Makefile | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
> index 9ebb5e590f93a3228c451dca58e6d5cfbbc03ff7..c19c3c76f7c9f6b2f7523a59269de3b683656323 100644
> --- a/arch/riscv/kernel/vdso/Makefile
> +++ b/arch/riscv/kernel/vdso/Makefile
> @@ -49,9 +49,10 @@ CPPFLAGS_vdso.lds += -DHAS_VGETTIMEOFDAY
>  endif
>
>  # Disable -pg to prevent insert call site
> -CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
> -CFLAGS_REMOVE_getrandom.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
> -CFLAGS_REMOVE_hwprobe.o = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
> +CFLAGS_REMOVE_VDSO = $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS)
> +CFLAGS_REMOVE_vgettimeofday.o = $(CFLAGS_REMOVE_VDSO)
> +CFLAGS_REMOVE_getrandom.o = $(CFLAGS_REMOVE_VDSO)
> +CFLAGS_REMOVE_hwprobe.o = $(CFLAGS_REMOVE_VDSO)
>
>  # Force dependency
>  $(obj)/vdso.o: $(obj)/vdso.so

Reviewed-by: Palmer Dabbelt <palmer@dabbelt.com>
Acked-by: Palmer Dabbelt <palmer@dabbelt.com>

Also assuming you want to take this with the others.

