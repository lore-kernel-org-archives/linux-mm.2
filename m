Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08961C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:19:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 138826B008A; Tue,  8 Sep 2026 03:19:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA736B008C; Tue,  8 Sep 2026 03:19:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1A526B0092; Tue,  8 Sep 2026 03:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9BE96B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:19:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74C4F1403A2
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:19:49 +0000 (UTC)
X-FDA: 85189745298.20.0099658
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf07.hostedemail.com (Postfix) with ESMTP id 914E940003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:19:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="UoZziDS/";
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788851987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvxxmFP38glDv9aUVdeEkTg6ek/m9m390THhoWCfEM0=;
	b=2cC3HPq+FP1iU1isziUdoF5HX+MlKMCrPFgD2qccpnIR14W6kO6Rvv6QWMWl65M2woS7Fn
	Qnx3jphufgJNCddVjay9+7SmFlxwQzK6HbeZvMN0mznfGOpfhtIgITQLYVdoG/ZHOcUW5/
	TqUrFrT1AFWRiUdq6L8dG4dI90mKuD0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788851987;
	b=SUXIA8X13u6T1JmZToP4wPxCCUMxX1qY+fVHUjz1tiaKWXMcokgz7Gv91i//Vjp2HWeRV6
	9O0JH0BSqzsX9iw2Jq7epjJRSuub0/syfJzuBUuuuO9C4udFJRfjDx0kVrjoNLu7M6aNas
	sFc3lf+/qd0Q8lVFBfW20mfgxfnjIFU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="UoZziDS/";
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=cvxxmFP38glDv9aUVdeEkTg6ek/m9m390THhoWCfEM0=; b=UoZziDS/M2tkE9i/kd/fRWxjxG
	xi+fyu0pTnULNJBoBTxWqssjFBpND46iwdm8/Xdasvn1rRlVO3YRTifGQHqQ7Djyr0qN+giJZ+fhm
	VGFo7VQcUzTluQnwuFY/TINjSZwGg2wAu6h/I2aJQekwAQAHDfDRbs5c4653HmcsHzR3/MT7uYBiv
	OHGOF2sDyRO8Ng0HJl/EAucBF+nX0HMCIeEV9AzqfniAsQubp91a/6o38RnF6m5eUvGRXcnh6SFwM
	YSzWSLDv1463xBJzjZwzhVMGY0l1ix+hGiimn09WhCg0UeYSjjmBlFhgA8gLyLSTRRkm2555WQmqU
	gUx+TBrQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x3q6s-0000000H2YA-0CKd;
	Tue, 08 Sep 2026 07:19:14 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5B0713005AF; Tue, 08 Sep 2026 09:19:11 +0200 (CEST)
Date: Tue, 8 Sep 2026 09:19:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, linux-mm@kvack.org,
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
	rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org,
	Jan Stancek <jstancek@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 12/24] vdso: Add the vdsocheck tool
Message-ID: <20260908071911.GU4120091@noisy.programming.kicks-ass.net>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de>
X-Stat-Signature: 3may6gnrga5sfasnsqee9q1eq9p9wo7t
X-Rspamd-Queue-Id: 914E940003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788851986-642340
X-HE-Meta: U2FsdGVkX1/ZWvJEt02D8ENOhCc7DCTliw7C3RtB8PCp8IMxFRGgiAzCNwuMmLcAa/z4BwEtSbMFwy7sRiYlZ+yqUJgC9e101CDk6gVj1CXwU8OGCs+jEAjhqZZqMBbsoaoGtPtksKo074rlYqn4pAjxtkDDfEtbni4dGbY66yzwHAWGLahhDtQmLjCzRZ49Mbh9iYkG6KOlLXZsG3tXIa7eJDT8RCcRhUJ4Jl1vWARL8CULDgNO5KtJXyiU8YWneSKHUvYdRZXjLp9jm2LstSlybK8hyiyfmMooysId1m3JDQ+fsT3U2nEYsRd52QbIu3QvmDZpDCT6E8v0KrVDmAP3h2XVKAMauihZuzBtXdGB41GLlHfRe+mRzPkg4xyinfQGROfKjyxCkEqBcInHJxezcIuZa+DhMbEDNnv1E4VxOL6xKL+wHLz2O0iDEJuGp1BYyYW+W0h0Tx+IbNI+pUaEDCLQFh+wRBaho6BIskDntUVzvJqA5+GjhT4WtUMw5UsBOKa5pK8NSrJ0OGolfMMOHVQtxIMxBcqNG4S46/jk4cTi3OQ3JUW6XYKjUgFHnQXHKo0t96ohSf+N9BZGD558UbhrvdjlAVuvWM7dZ7jd0Ca8Vy3lR76Oa3aGwf9sbZd1zRLNbpxYtCPl77m8jtx+v+qsu+XPCS6bEeJk3goTDb7qXeOFd/tqOf8ZArmhmKdt05MDGvWKguiuEZNxbsjEBcoG7EGs/IghnpzqpTY4mzZohLNtWqqxFgJdcxVt50JoiN5K/fF4Vsqh07Uqvaa7ARkggtrBmVET7LIp19ypDBT+yIBTSZOOmol8X1Xd2mHGWwYsHOt844Sc9ZbM/nBoCNguWm44c2z+/AOiEXU/xdhWOEIuTKPPbXjOe0PwQ8ZEK7FyVD7la33/oODq/JB8SkDw0vLTVkie/oGl9sWjCAjIGP7t8vbOpOkPORTn+74I6YPPzg3JT/B0aA4
 sXdjODPX
 b5uU4K8UHJHN566BK5ihG6Y0zIZ+Q4aInua5RKeSVge5bxidLMBdG+3svDJ/xM21Ow1bO1IVPlsIDfsmsRx0bYn/F8WcJvVx6kN2y5dWs+yE5bE9j8xrEHou1Eon6DWZ2fD9pPYzgyMivwcOUW75iMqfJFDOXAIhHuQ1Oh+yjTnaxndfeQtyvuVzVy6Yn2nprlYnoGKVSUH7UPan8zKbJbiig1bVG1D+5EWOYdoRVyVEcxjJsysEqVzu7NcX8AL1dLkur5/VnAb11UGGxcRWAC1qWwRCzpDxQz6Hi3wCOhX5goA7imEBaz1xEnN9ljGTIuE4DezsKKsRGuGp1jxjLkRHufDqOHu9mR+0qPT7vilQ2Igk/tr6gq2+R3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 08:33:46AM +0200, Thomas Weiﬂschuh wrote:
> All vDSO code needs to be completely position independent. Symbol
> references are marked as hidden so the compiler emits PC-relative
> relocations. However there are cases where the compiler may still
> emit absolute relocations, as they are valid in regular PIC DSO code.
> These would be resolved by the linker and will break at runtime.
> This has been observed on arm64, see commit 0c314cda9325 ("arm64: vdso:
> Work around invalid absolute relocations from GCC")
> 
> Introduce a tool to check for absolute relocations during the build,
> as the current inline-shell logic is not expressive enough.
> The check is done on the object files as the relocations will not exist
> anymore in the final DSO. As there is no extension point for the
> compilation of each object file, perform the validation in vdso_check.
> 
> Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> ---
>  Makefile                    |  19 ++
>  lib/vdso/Kconfig            |   5 +
>  lib/vdso/Makefile           |   2 +
>  lib/vdso/Makefile.include   |  14 ++
>  lib/vdso/check/.gitignore   |   3 +
>  lib/vdso/check/Makefile     |  34 +++
>  lib/vdso/check/elf.rs       | 498 ++++++++++++++++++++++++++++++++++++++++++++
>  lib/vdso/check/vdsocheck.rs | 154 ++++++++++++++
>  8 files changed, 729 insertions(+)

Urgh, does this mean I have to have rust installed just to build a
kernel now?

