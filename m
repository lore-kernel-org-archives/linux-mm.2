Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FF5AC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:37:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468216B0093; Tue,  8 Sep 2026 03:37:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418746B0095; Tue,  8 Sep 2026 03:37:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30AB76B0096; Tue,  8 Sep 2026 03:37:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AD9A6B0093
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:37:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81648120449
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:37:40 +0000 (UTC)
X-FDA: 85189790280.15.CEA2F01
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57AD5C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:37:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=irAwsshP;
	spf=pass (imf28.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788853058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMspgRwQUUIexqKss7dqowtOmwD0tLbRBkFb+1ouQnY=;
	b=xdVnNsjFCP5CeHT6yKBkTg64JiuIrMCxFM1hcSB5jk6QMct2Ys8fjDbPUbgHVitfIc4bxH
	IJN4eXNR1q4wZXr0CyzXSRFedYsUn9zXDlsvjo8WxHkZfGuxvcaRc1mLfWAUbBE7tCIhcm
	71GW1jv/VJrWA83uVnMd8f5YA4EFMoM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788853058;
	b=qe8NyJpS46EV5tgjhCTz0UCSaMUzpQ3N60eupQQ+PI1K3JrobK3S5Z/cwjlmFOMRY3JftR
	1Uw3NmQ365+tOo/tp9USfG7epz8LyNomB1bIy2kM8PGZxZ4Xc5MjIpOORlniYQTHsy+R6F
	YMNNJAXAvGslQ5PeX1QA2wVBf0Au8d4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=irAwsshP;
	spf=pass (imf28.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=dMspgRwQUUIexqKss7dqowtOmwD0tLbRBkFb+1ouQnY=; b=irAwsshPXpU7Uf/rfFaj3uWs6G
	difPdlK64/emyFJJjlL7wNOeoAd6Y+U30iaYxFlQNgUaXhJ5XP9GQvgT7SeejFL749VvbdmXzNQmr
	ysoKC7HRo3DXe9AyxTg6XU4ih3jJvnovv2Ujltj+xakHIL0+9ST9dekY+kWUCq6mECTuqGA167fg+
	YqFWds1pqUcKbMJUd2jIJjqcUYt3toc+D0q3aR2UwfeZbWbAc5JAxTcsD0VD8CvN28YZRwquKZu0g
	pKwTeSbCwX4MUVnlh4QxgKngIIgLaxab029w2jsxL2wYaE+8OY428gXbHH21x+RnEEnFMu/t4r9jb
	gZmtLwfw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x3qOD-0000000H407-3KtV;
	Tue, 08 Sep 2026 07:37:10 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E0348300400; Tue, 08 Sep 2026 09:37:07 +0200 (CEST)
Date: Tue, 8 Sep 2026 09:37:07 +0200
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
Message-ID: <20260908073707.GV4120091@noisy.programming.kicks-ass.net>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-12-3a93791af1cf@linutronix.de>
 <20260908071911.GU4120091@noisy.programming.kicks-ass.net>
 <20260908093302-1a1cf0c7-8103-48b1-9f6a-abd5c5c16523@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260908093302-1a1cf0c7-8103-48b1-9f6a-abd5c5c16523@linutronix.de>
X-Stat-Signature: 18ptby9jdny7to8gmadc93zb5b8rj35g
X-Rspamd-Queue-Id: 57AD5C0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788853058-932581
X-HE-Meta: U2FsdGVkX19NrlzXEYm5ZThOYqO/+R7piT7BLccR+P2/HdgSwvSnn18mm5Zo0B8kGr4wK4rb53x7te/fCL1wMC+Ov2MlRF9xqvjqMkIG6TRA8pyOqQHOJrn/7jJWvd9s5KeA82kIR1KgmzI2P5+kUfD3FOdiFzQknMxg6wrR2YtIPsuSKxM5OuuJYEpRnIqh4PW6xq0ZuKTHb/s7hL2fXPoH1vU89v9Jq4fTyESZn6UjvZkRHm7XM9uoWdNzVgRKzNroW2zVzVFlgsjJ89zwyKcI57CMyDS8Q/p1VMG7cl011GLiXYKfiYRFc/+JEFb1BAv940oZkFPIQamTu089V3mtZ/ZwgBZRwJsG6Cam8m9pQZSWx3Fs1tFD0xV0q4Q5jAGeeggngMi12EmFRhNvEolH4qp3k52F3+W+621ip8az/FO7LgYXph7ljg9Q4/AIitc+IKMIGWbATb0IOo0HiLAmQULtBe9nkeMmAqyRDWDP8Uj2fte9VUPNpsNeYj8XNCLCEuoPA9WxljKi6nuaGReOFF8EE7SKTB9lzn8QHDsmPKkj0wOjUJNQsSWr8Qgc1GvrkjtPRQiyRkSTrxLF6yxAX4pW0Jfe4Cafx0zyCjJ2cNPmRstTs7CzDKwvmJcPSoGmsYiRf/rjWdVpn9PcLDlMvF6tBy9+vVOVpGpEJ2a4B9iz1INj91LxzYXIM7jqzTEYF0jV7aFldhYjg3YOWSZh3ShrID+oXB0uVedPzClKU9sw7RVfp5O6jBbYFgA1rJxxrrpDqpXb705KpI3smiPJwg82xWYZv/lbsKQG7l4yKsTGkufS7NjIRK/zt16fpuLwaqtUmga9VbOcfzFLTJt643VGTZbruNfJGIafYdl6/S7eADuXnZ97v/OQidfxTv+FMNITmnbqkqClTtn6Exg1wSYraLx0Y83sEa8/QUj1bHmwbqYK0+XEPCtxx4t5KgzHQGhn5Jf1r57FU7C
 lK9v/ApC
 F8gU1hJF3jk+dm7c+bzRZ4NjonQjvv+f8RiXsmjwf9qs4kNRiaRZhBppZoroWaCOd6MvWo+lCE+9cgrSBC2TdH6p5+NzhQRQqpdkSIFf0T84DER7MHNO3QdxWudbgWqYIG9UAy2+Fjt9AyzvR4RQss/ul1J3c+6HsxifJS7newoRvZPfm+asPI+vniK8zXhNAvrgG+D4N8DtUdXj4iul/LLdO6VcKpPeQjidZRRfOGZNdUbTIG6oOnpWR423BBsa0hLsbBhfK0UA6UN7EGODDEAHY4Jherp4y9I9EMgNsP4zceb712zW+Y5oLZ6kWcH3vjXZWxX1lGxGoicL8STpLHV9+JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 09:35:46AM +0200, Thomas Weiﬂschuh wrote:
> On Tue, Sep 08, 2026 at 09:19:11AM +0200, Peter Zijlstra wrote:
> > On Tue, Sep 08, 2026 at 08:33:46AM +0200, Thomas Weiﬂschuh wrote:
> > > All vDSO code needs to be completely position independent. Symbol
> > > references are marked as hidden so the compiler emits PC-relative
> > > relocations. However there are cases where the compiler may still
> > > emit absolute relocations, as they are valid in regular PIC DSO code.
> > > These would be resolved by the linker and will break at runtime.
> > > This has been observed on arm64, see commit 0c314cda9325 ("arm64: vdso:
> > > Work around invalid absolute relocations from GCC")
> > > 
> > > Introduce a tool to check for absolute relocations during the build,
> > > as the current inline-shell logic is not expressive enough.
> > > The check is done on the object files as the relocations will not exist
> > > anymore in the final DSO. As there is no extension point for the
> > > compilation of each object file, perform the validation in vdso_check.
> > > 
> > > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> > > ---
> > >  Makefile                    |  19 ++
> > >  lib/vdso/Kconfig            |   5 +
> > >  lib/vdso/Makefile           |   2 +
> > >  lib/vdso/Makefile.include   |  14 ++
> > >  lib/vdso/check/.gitignore   |   3 +
> > >  lib/vdso/check/Makefile     |  34 +++
> > >  lib/vdso/check/elf.rs       | 498 ++++++++++++++++++++++++++++++++++++++++++++
> > >  lib/vdso/check/vdsocheck.rs | 154 ++++++++++++++
> > >  8 files changed, 729 insertions(+)
> > 
> > Urgh, does this mean I have to have rust installed just to build a
> > kernel now?
> 
> No.
> 
> If you don't have rust installed the build will instead use the existing shell
> script for a less thorough check. We only need one build machine at some point
> to have rust installed to report issues and this check to be useful.

Ah, *phew*. Thanks!

