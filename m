Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA2C606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=tTEn69Gg;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=/3Od9jAv
Received: by kanga.kvack.org (Postfix)
	id 6BC296B072F; Tue, 24 Nov 2026 09:45:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D056B0731; Tue, 24 Nov 2026 09:45:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55AD96B0732; Tue, 24 Nov 2026 09:45:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28B096B072F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 09:45:58 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A21F0120AC2
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:45:57 +0000 (UTC)
X-FDA: 85470287154.09.C1ECF8D
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id C1A7410000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:45:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=tTEn69Gg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/3Od9jAv";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795531556;
	b=25taIC0nfernEmSfzz8IXZmaG+6HKatJ9U79gonTvvX71WCU8Vygrdh6vfQxk4BkflcKlO
	fOyCuNhRrGhFNZjI+9XM/7pSSEjUI59u+GCAt/0ZIIEWV38V6XhbGoGnUpkYcnIVrWeBWE
	rV0tMRY/i1kXXDvDNj2rbeozIpjoPX4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795531556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQPLtENkICRsya/wldqN4QFqx2tHDnG58pdrhZSAsk4=;
	b=ZmYtZ3noiatfOlMjGwondQr1Rg9ztw/QM4WJZlUjWS4bqjMG13gLdH3LQwDAAIwS4Lfbti
	v723xo6qbI0FV9xchsNmZGx58n/6Mp96nFrpX8YVStRqtoXM1UC1YqgIOR9Z/YR9I1kxK6
	VsDYAiSDnZG8ZQb8Wjg5TH/D7hWqbhY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=tTEn69Gg;
	dkim=pass header.d=linutronix.de header.s=2020e header.b="/3Od9jAv";
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
Date: Tue, 24 Nov 2026 15:45:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795531554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PQPLtENkICRsya/wldqN4QFqx2tHDnG58pdrhZSAsk4=;
	b=tTEn69Ggd5O1AMiiVmsQQNdaOTqjJDDdYLlflDKuGjhjFL/gQSfY2I9NFiQO6fLP7zbcsC
	wBLVqGoKfTMXPn74FoHOoS4TMhpYs1rGXQV251w87aqb1UZvPpsY+IazcI3YviwQjfVXO7
	EOPiGIMGZmKYvkcpUCdX7h60CFgHFea0TF/qhae4wfkoaXSMBZ4h26njD9ZbYjRnM7GHV1
	ihIsfN9rYjAghF8bXBcNcWpaMcihiSg4070bow3P9Px7CGcswo4r/xGRkE3wYO8IvpPFpx
	lmY7yyZ9NPf93M8oelEoFArzHfoIC8MMAAUtARoiWQFgq/oXuWoNAo2HxbQe0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795531554;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PQPLtENkICRsya/wldqN4QFqx2tHDnG58pdrhZSAsk4=;
	b=/3Od9jAvnz4o5peY8lpl50a4JTP+MtAYMfDyacdTmAEhVr9ZKew0yw+rHnnz5TW7KkGRtg
	IgYweoRziAAL8NAg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: sashiko-reviews@lists.linux.dev
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
	Anton Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg <johannes@sipsolutions.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christophe Leroy <chleroy@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>, linux-mm@kvack.org, 
	linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 01/11] vdso: Add the vdsocheck tool
Message-ID: <20261124152519-f59dca8b-4c72-4102-af10-810dc16ae041@linutronix.de>
References: <20261123-vdso-absolute-reloc-v6-0-161e218dd217@linutronix.de>
 <20261123-vdso-absolute-reloc-v6-1-161e218dd217@linutronix.de>
 <sashiko-outbox-231255@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-231255@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1A7410000B
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8y3o1n69rnuxi8ui889j5yshzaiyrawg
X-HE-Tag: 1795531555-340045
X-HE-Meta: U2FsdGVkX1/VfIAxBVldoDM4hSiFNe1HNj+DwCuogumpj1EhdcUzMCkoCxWuzuSUWfs+smunhSdO8kloHU/Hr9Z6YVkLLQHof8fryrFODKMgtcEfpc9/qzyaShcv33XdOOwdD1uM9YTsj4H3IKHvt6ZDb3w4ef870sh+qh1vtTEZ5LvUSBXj9vn3UFMYp67P082VLYSSgCT5uAcNbsFeaiu9XEcvanjZQKvJEn9A0KJgURQ7+EZ+AHubdavO1VJ0f6N0MHf/Qu6fWCB3YPETjZ5AOM2rFVJvKyCyzid+0rv5JMfZ1z5teyfW/dK/IQcxosqwLF4WfRNTpikj6oh1XAKXD+mLR0j/+WzRxBIgN+KWqBCCckNT0rREL+QcmIVK2bruahq1Y2uMZdQwA3E62keRjT8VEUeVH7quaFia05aZqW7L0TbIzG8QxcGyGJIQXXLlKTEf4oAWr4hS3+MS/xn5/fsPNXgV6ehdCu8ABOCT07/jh5s3qke1qQ4gHNsVAp40oQPfpLGF9btCm4Q9V+c/d5xqZpK/D37FSbYr4DVET7qocEr0LF9A9IPSsAQI2Ho4VgnyL34FjdAatjCzwKFFcJ6nXyouIqwxhveF9/NSiyJvptmXuXQS0ZQYQx8ppSZyROa/p7khAZDsXZ3IviTzSdLEPvZDSo6LfrQGeQREngwN2xTGxM/yaIU1Y49YHlg6+J+ZHaFLTlvGIndHYs4Bi8CLEO72Owu2U4I854XQpyOe7FmA+DUil3xCmp1H3kB8Rg4q2ijWgc1lmEag5kbF/TEzI6C4UyHWK/lESQEKGr3BfTWulA4nxjcX7ZSjzN+5xf1aWeOS2YT+DhZ/sMlBGm+s+KgZ9R80Qr14unfRmI1+uMGWixMx7vaMXYsr8G3+GrbFfvJbIUX94gp1BbW3WYl9N09CCPqbUFAC0iRhlerZe4YcaRRKdPT+hQ3P/6YyeIyb6BitT/FkCnh
 p9gPw+yl
 yv+zHTj5PTakor3ZlBm3MXeDiFLHqurQ/799lXv60ZCy2D8PDyRZB7etjTLuOccq/+0aFx1Bk1hl9PwUDOahJMyMETYcW+JnW6Wp8iGbv7IaWa3ckmmO6zoVOAnsbLmSkUQGU7r37WkXPeplv0MUcSsBkX7NKg4kB5cjGEuXdTRVgkLbiQVRv9nuGKtdSD9iH/lBP8BeFFny0yda9Eo+7ULrXW3/2h6BYrrPpJ/aMyAFaR5lYZWFYSR8xLXz6foO1hAe3UDVs06E3B++84G/UzV2a5fOvSmPQBtfy9Uz3gDQjv+h9qAVGfqAhhVyE3WQ21EYxi+BrjXvLkd1nZb7TlNpVtqR1MkJ8puYh+MSVdGDaqxMb6seIXWEguDUt732O2+ubtwYVLbsuGwlP3MCG46mjKE/9cRhr6ce/gE2jlynR8EBEivLF7muBGNH5fF4lCs+a6adS5fyM65obicM9CKO3Gfuqv5XBDPisxfsE7FAjqFhZ4Ub9HBjRGaV1Np8x4GizRnt78RFtbA1qm1ZcbWaTmgdhh5Fzwv3MmIfBgvhaLuqkJEyLTP0SclLUrH0FoZgXaZmrHcyRHHbLnvuBzjtC62Nw3rCdr70BL2MjWPa3OEnjwQO1iHHb0oOVhNW97O56LAild2tTqp+G7k6Vk6WLbfjkgSlz4JaaeLsUJaLtGfLW6TH0KiVOw55JBSSGq3eo1bnCMXNJInsjNEGDJrezKBjIY+C6cidCsex6jOCWz1sJucw3REUhu/ABV4Sf7GDvMXnyP9pugAn5uvh7tXiMky67ySo44HdxhG58mQA+VQ6kK40DWTQCV8/QMQCy/1pM/eyBZBg2MRw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 01:52:59PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential
> issues to consider:
> - [Medium] vdso: vdsocheck uses Rust 1.87 APIs breaking 1.85.0 minimum
>   version
> - [Medium] vdso: unchecked slice in get_data_subslice() and SHT_NOBITS
>   slicing
> - [Medium] vdso: missing include/uapi in HOSTBINDGEN_FLAGS and + on
>   host_rustlib
> - [Medium] vdso: validate_linked_dso() rejects SHT_REL/SHT_RELA with
>   R_*_NONE
> - [Low] vdso: missing scripts_basic prerequisite on vdsocheck Makefile
>   target
> - [Low] vdso: vdsocheck main() prints errors to stdout instead of stderr
> --
> 
> commit ba87ba62d5b7688443f8778322978989d53ab4f8
> Author: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 
> vdso: Add the vdsocheck tool
> 
> This commit adds a Rust host build tool, vdsocheck, along with Kbuild
> rules to validate that vDSO object files and the linked vDSO shared object
> do not contain invalid relocations.
 
> [Severity: Medium]
> In lib/vdso/check/Makefile (lines 18-24), can building bindings.rs fail
> when the host lacks kernel UAPI headers or has an older
> /usr/include/linux/elf-em.h?
> 
> tools/include/uapi/linux/elf.h includes <linux/types.h> (which includes
> <asm-generic/int-ll64.h>) and <linux/elf-em.h>, which reside in
> $(srctree)/include/uapi rather than $(srctree)/tools/include/uapi. Passing
> only -I$(srctree)/tools/include/uapi in HOSTBINDGEN_FLAGS causes bindgen to
> fall back to the host's /usr/include.

For int-ll64.h this is the expected usage.
For elf-em.h I'll add the patch again which copies the header from include/uapi/.

> Also on line 24, the $(call if_changed_dep,host_rustlib) rule for
> $(obj)/libbindings.rlib is missing a leading '+' prefix, so GNU Make closes
> the jobserver file descriptors and rustc emits a jobserver warning that
> fails the build under CONFIG_WERROR=y.

I did not see this warning, but the '+' itself is correct anyways.

The other points are correct and I'll fix them.


Thomas

