Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4320CD216BC
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 16:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF196B0095; Thu,  4 Dec 2025 11:56:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AC826B00C1; Thu,  4 Dec 2025 11:56:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2B56B00C2; Thu,  4 Dec 2025 11:56:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9BE6B0095
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 11:56:26 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFCF41A022C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:56:25 +0000 (UTC)
X-FDA: 84182391930.01.108CE5E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A5FC12000F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 16:56:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2rWkL1Xy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=fx0jXRJ2;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764867384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9+6XlmLlKbjUhjn7O7UGpoRgL/0BI1e50erzPzpDlQ=;
	b=DppcT37tLOQK/BKhwPRLxmO8kitM11jiKmdC0KH4oyS7elx0LPs9uermRz0LQJ8NghVFCK
	IoPjavDqCdDn9P9/6aSJ0bnS2SlIIOrA6rPTHdfFTzhgimyqv7o+FJEItXMmZDVqIiD4c5
	g4/eze131OC5kiLqYB/EEPicXhd/HX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764867384; a=rsa-sha256;
	cv=none;
	b=r2BCqByOAaBXYcKi1e8nGJoueIBPapNKNx29JIm9xCQUddYEExIebVBe45ZdD3hgvThbIZ
	kExsoFSEAt0uoKHJ0WYRwYFwzmD2+VAIXB7YF9U3PiY2iaZ0bQxmsNeYC0hJsm22qL2QW3
	owaGhyVIQvCxwAuy4VPm5mxI2cnoMMA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=2rWkL1Xy;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=fx0jXRJ2;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Thu, 4 Dec 2025 17:56:19 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764867381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c9+6XlmLlKbjUhjn7O7UGpoRgL/0BI1e50erzPzpDlQ=;
	b=2rWkL1XyAhcgyqrW14MMF3qaUQSr8YYDNiCKry0x0QBsV4l5x3+Ycw5+Jmi0h0i54S8RRK
	E+E1i9Sf249ovLQIsdHJYJbyeELFizphpxVyW0iv3gMQVsNLZQNI3+0uo8gMM5+J8gdwAU
	TQlFxaGVQAKpquAo5xJmu7Sg3eUNUg0oqHbXewl81F1jiHSx62cUQYCc3/lDBDD9nZaXUb
	D0kNhjyLt3Lx6Iynot+ksQqb9CYSPxpgVVg03P7IjPAK3p6UMbKbdvfL0mIG0Mr+TozaUc
	Idwaz543w+GDt5FHrMnfh8wFNTyTtt6ss8MbiHwTTQI9/sWdQYGNRLif/kaz1A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764867381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c9+6XlmLlKbjUhjn7O7UGpoRgL/0BI1e50erzPzpDlQ=;
	b=fx0jXRJ2uwCZoiAF6TP+4b8/8ynViDEX2+cIYHls3j9u/NOxevNN3FgjINA/To4UgHgvMH
	l2OPXdUE9HBBQkCw==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Deepak Gupta <debug@rivosinc.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Brauner <brauner@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Oleg Nesterov <oleg@redhat.com>, Eric Biederman <ebiederm@xmission.com>, 
	Kees Cook <kees@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Benno Lossin <lossin@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
	andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, atishp@rivosinc.com, 
	evan@rivosinc.com, cleger@rivosinc.com, alexghiti@rivosinc.com, 
	samitolvanen@google.com, broonie@kernel.org, rick.p.edgecombe@intel.com, 
	rust-for-linux@vger.kernel.org, Charles Mirabile <cmirabil@redhat.com>
Subject: Re: [PATCH v23 24/28] arch/riscv: dual vdso creation logic and
 select vdso based on hw
Message-ID: <20251204175055-fefb76ff-2ff2-48b8-b92c-3d3ce33ec9f5@linutronix.de>
References: <20251112-v5_user_cfi_series-v23-0-b55691eacf4f@rivosinc.com>
 <20251112-v5_user_cfi_series-v23-24-b55691eacf4f@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112-v5_user_cfi_series-v23-24-b55691eacf4f@rivosinc.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8A5FC12000F
X-Stat-Signature: fyqzyfu5ebbdgx1mdh86d8iryr6c8xa3
X-HE-Tag: 1764867383-345701
X-HE-Meta: U2FsdGVkX1+T27ib8eQybMsRq0GJdkkZf1YmBrQxXP1Nff0/OuxdeAi7M49cvEVOfJ6n8SasiWw6GkmB8ave99D8dnJfoI/ueGrvjtje8fB4ntlOsnF4s+BX+mHqVqr57loubp1qrbOfpENhvL6nH1XJD6b0cviGvbGbvpwZ2riR4IELMSe+nmAXMvuVZA617RZ1+y7HFUpmjxjWtfSCz7MW4XWoSeP9WzrLopxMQPm+1icO5LoTmTHohm2TdG6eFpkf0ah08m0NSElxm9WdWmCyn0QC87lV0JUqBvi0LiLTPVfeLqbXov9jEsvknbOxSuRTIwN07kzO2gDt+mGcOEnz7EDYgaI698bJqcW1r3JH9R0pJg+K4RupqttgDsN5LBMh45eVfgGmFTQqFXkHwxMnUvNl/5LH8kdwPDh8Wh228Sxiz9G3Wr+6pxN1N+S9OsYNTjDxURR4zHldeEqv44t2cQRT/CU/YM2nYC7isu/kpCB0/w37l0w0G+Uu9IAwaoJjfQzDh8dnQWzDJbJkzBAdNC86iLe5oCCtsg8s5E0M+B2gQSG0fv42nNlOvgkAMudl1tJ74A0gpRB/DUaeZWFk/G1bSU21W5K4vGow2pKz7r9eXfadtYSLEbT+Zo8Rx7OE68BKbpVt0OORc3dhpWY1F0HeGrDsEt1H6Rc9cDz8OAHnmWqsHrNNmreCYGuEuh3+vSlXvIfuHRb3ULLVVisLlqGczTBElvEB+pXAEa4MKYcz8QII408k4jkds2JwZL5K/hG48UfvnOwB4gYhMnWDSQnaFLJYguVcMAhvHDWy+VWbLTWtjrlP3kMBdEpY+fnbqvr/rrD0G5XoU0VhbiWUg3MgJYXhIom+s+J+Plc+x/Dj13FEOOl6aMcXK2J4WkIXdPqCzW8EOUkZWwPwDFB0Mk15qFTxwidIP5XNR3iTwAbe2h3foUjEPk+MTC05D12frvCnaWMmMjktL4r
 NndX6M+s
 W4sSgKRDgkmQSilPBDzh3fF01VftiM+jlQaD1ohUeRuAWV8mSYzCyC5Sg33RJF5XDnLFDdlINT64mTm4hzm+1B5ncv+sM3+gIID8pDxlTS5BrL8AHnQtNdf0S4tVLPTGQXLTNTfHSDfI374I5wbZ0lGXyQ9K+7e1AAzUz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 04:43:22PM -0800, Deepak Gupta via B4 Relay wrote:
> From: Deepak Gupta <debug@rivosinc.com>
> 
> Shadow stack instructions are taken from zimop (mandated on RVA23).
> Any hardware prior to RVA23 profile will fault on shadow stack instruction.
> Any userspace with shadow stack instruction in it will fault on such
> hardware. Thus such userspace can't be brought onto such a hardware.
> 
> It's not known how userspace will respond to such binary fragmentation.
> However in order to keep kernel portable across such different hardware,
> `arch/riscv/kernel/vdso_cfi` is created which has logic (Makefile) to
> compile `arch/riscv/kernel/vdso` sources with cfi flags and then changes
> in `arch/riscv/kernel/vdso.c` for selecting appropriate vdso depending
> on whether underlying hardware(cpu) implements zimop extension. Offset
> of vdso symbols will change due to having two different vdso binaries,
> there is added logic to include new generated vdso offset header and
> dynamically select offset (like for rt_sigreturn).

If the used vDSO variant only depends on the hardware and nothing else,
why not use alternative patching and avoid the complexity?
I see that RISCV_ALTERNATIVE depends on !XIP_KERNEL but the vDSO code is
moved to dynamically allocated memory in any case, so it is patchable.

> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> Acked-by: Charles Mirabile <cmirabil@redhat.com>

(...)

