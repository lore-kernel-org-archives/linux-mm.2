Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA147C79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 05:59:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BE456B008A; Wed,  9 Sep 2026 01:59:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A326B008C; Wed,  9 Sep 2026 01:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FEC6B0092; Wed,  9 Sep 2026 01:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47BD36B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 01:59:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C6A44087B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:59:55 +0000 (UTC)
X-FDA: 85193172750.30.D4CD0DC
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf20.hostedemail.com (Postfix) with ESMTP id 979231C0005
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:59:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=CMEIGvTJ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=VonGHAfq;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf20.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788933593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfBuOKvuia8jKU4jKhI6ImQ24+OP+x2lVvStL9kHB6c=;
	b=TDtE0VW2eIqQbE4Q9f5N3TL3Q1xncLLrNha1T5ON9jq5Dou5w5l6PWhY8OMrflxN+NLYE8
	szd+69LOnGyIVA00RrsBdjHODHXTzVLpKp1DGnvoe54yo8EkKW0XRM58eWuJ637Vf1bQcW
	TKoLAJc38i4L3mjIndrwl+/DMz9QI/M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788933593;
	b=WfugI6ZxKeYpJ1fo1K4XWaWAhPpz7Gv8gl/xzSNH6sbUd4RHvUflkrJNOOlHVnMl3BoN/L
	JQzFhvQDbEKC/VdQHZ2/35feUulWyEehiIlj2yRcsoZiBA/7uhia+F/mqRc3Hz6vkR3J/A
	T4rZP39s/WCzNrNn3fHqx/yH4sRMKPE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=CMEIGvTJ;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=VonGHAfq;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf20.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
Date: Wed, 9 Sep 2026 07:59:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788933591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XfBuOKvuia8jKU4jKhI6ImQ24+OP+x2lVvStL9kHB6c=;
	b=CMEIGvTJ+RpDUpaQX63YOGpF9L1xMeGi9s7P9EumAFOOXvZhDn04zc5cDcznjmEwFWcMKn
	aV3mh9HSsioEvvDCuqmuPhxAz0EDxVz5FVZWfmObWfXRSybwQ1ZxDVQ4z0tJ5bj8HKl6QH
	2LpCD9FeG6rAkLbfiSKloV9FiP1FFipkSzlhBo3Zplknr1ofEEQBBTOoi2c+qR7w1FFuf1
	oLRZ1Ohqd/R7qrq1gOVWGdmCLZlvGzRsKpGh6crrwVT4V1hNIEeMZP96qZ+DAKQJ/Yh6qb
	V/ykB9y+Wc32WJFwaNxXjYic0iDsUwgblz+2Yps3KMILiE5BRXmRKCLGA9EuDw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788933591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XfBuOKvuia8jKU4jKhI6ImQ24+OP+x2lVvStL9kHB6c=;
	b=VonGHAfqnQoueeh6Hl3Lomphhnqa2H/lUyc5Ke65gvgt5gNmjnE70KZBPhdx4hgXdpJF0U
	tvpV+04d2I30q5AQ==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christophe Leroy <chleroy@kernel.org>, 
	Boqun Feng <boqun@kernel.org>, Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org, 
	linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
	linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	Jan Stancek <jstancek@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>, 
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH v5 02/24] x86/elf, um/x86/elf: Move relocation constants
 to UAPI
Message-ID: <20260909075156-06ff671c-ab7b-47d8-aaa3-588b570888bc@linutronix.de>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
 <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
 <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de>
 <20260908151238.GBaqAl5iKb64meuPJl@fat_crate.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260908151238.GBaqAl5iKb64meuPJl@fat_crate.local>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 979231C0005
X-Stat-Signature: r8pt67yk16xtq6bpmebo9y3pmpjsyazg
X-HE-Tag: 1788933593-458269
X-HE-Meta: U2FsdGVkX1/mMZtJ9iL7qJ2/hJ7XKD6uhHOofN7APdD6OXiiv0v7yx5j72TsckooiP0gn54TJ+G0zy74eY3e7InGQhKlCcxqIuGHVb3NFQorpTlM3Sd1cFE/6qk2bsuCHgXqR9ffYpRq8e2OIghNRpjSdbHbxmoYdhkzEPlHtGNL0p7yN/jyzti9N2bFA+6xndT4lXmNvp/f58zDKiX4eyNpo1z2wxu9sGFU77AfsH0TSk4MwWvWXseOLMp+OCvAMrNwMQnBO2poAgVplelb5qfznLTUQR5kTb83pIYC28/FG9ymfmg2SXt4HvHOU3zOkq4JHCQ/RtIhThGDGht4tFSsCyqNSrS5HZT7nXZ0k3Xg3XsRO6mQccAu+55BILG9KnIosRnWEfSp3B3j5Z7KxhxiXeygRhNNR2x2wE1dOJ7O5GG1A4gVufiUbzWthr7P3bxMSEE2opUL3QJ2WPFPZdarQcCvr2Ik/dd2suFMIDrRBZlR7PDPdJgyVXVhI9X+43j4nurImpFwzWzgM3iUlAUxd3XyC2yYnWUD+NqxGzKwmsvCsK2YQMAQRHLD/9bd9cCKdfoC+nDo1iWe7oInSRvqpruAr4Vuxe2auf7cqTQsT2NPVF4IICM7/Mb3ys5jajtTK7I3sq1eitSBpxAdcs5nzQBd29PzTJAZjnEm7E/aE/aZRGRb5BWYiGgVJO9VBorfaz/gwdac1wJlS8nWkachgEJt4AtzywVmr4bwWNAzqTK5YX/xDYp/ZAHJ20V42yTjF8u2m66nU3dlYRq5DRXS1qyVCYFw9tEvX2XOHEZ+Yk4onrZqCM1PiDPV7p6jj33haC7KW08nuLgYBIv7a1Ne7OLkcrN/kiOpYnypfwL80DeonpQgxkiQnAK9yaOcbBS89RnaEozWL2OtRJFUqj8L+RtdQAQrC6Be8qgPSQTOXOOGOTps03i/dNNS1z8cKh4epSBbNYZaV4TA9xo
 W4NQBRqZ
 9p+rawJgWD3Fctx26LwMCwxKQT69ozVVBlLvJUz181jYMfJtC/BES5KBa5/+JQLtROLymzELqCYUIeEUu52zaX5+TtzbeFrTFLXlOPpAoLadQH/KKpuHy2yXQSi3y/hXmloknH6Kv9iiIwCGGqKVzHgkoxOyh9M8lMUbMyMkU3Gg9amahW7pBDx5S94dcQyuKSoaWQMKTzd8syW6qzjK9kuP12TYNN62zNXUckR1sySkp2a9LLiy5ctiFIqx4hvoiaYui+1/6Qt6G2X3RjXNm916oFV7JEplsVT7E/uuz9OuAU+nIgNiWgi+9sit17A2g9d0vN2l5wbKvr07sW8IjcqvaHY9WhDrQ5BzJSLIB6Ko6yPvoSl65p73csA3KQ6fQmNek7mSuFFtYArCA83Qw6opPZST1yEP1ThSasqa2B3cqd3TZ9/1yRD7aW5yQeb0FQHIcnFJyqRVUiI1oaY+bNz1t+LqBHOYA5EUxfS1ouQpYys4EWa8O3ZWS8nfIPhu8TWLC7nMvIs7d7B3Ul9X7KQOgVWOaTiczEb/Egnt3EtSUv8hovNKrVt4qP52UlKKboNyq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 08:12:38AM -0700, Borislav Petkov wrote:
> On Tue, Sep 08, 2026 at 04:26:00PM +0200, Thomas Weißschuh wrote:
> > The existing, generic ELF definitions are there.
> > The ELF stuff in include/linux/ is highly specific to Linux.
> 
> And putting them in UAPI casts them in stone. I wouldn't want to maintain them
> forever if not necessary.

These names and numbers are defined by the architectures' ELF specifications.
They are already cast in stone. For example see Table 4.9 of [0].
Changing them would break compilers, linkers, loaders and more or less every
existing ELF binary.

> > Also later in the patchset I want to expose the definitions to the
> > tools/ build. Exposing generic UAPI definitions to tools/ is a much
> > easier sell than include/linux/.
> 
> tools/ *copies* kernel headers on a "they're needed" basis. No need to put
> anything in UAPI for that.
> 
> It's even written down: tools/include/uapi/README

That is the documentation for the tools UAPI headers.

Also we already have other, closely related, ELF constants in the UAPI,
see {,tools/}include/uapi/linux/elf{,-em}.h.

[0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/jobs/artifacts/master/raw/x86-64-ABI/abi.pdf?job=build


Thomas

