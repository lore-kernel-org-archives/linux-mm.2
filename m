Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8E9C79FB0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:14:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F00C6B0092; Tue,  8 Sep 2026 11:14:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2496B0098; Tue,  8 Sep 2026 11:14:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 068E16B0099; Tue,  8 Sep 2026 11:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9DC16B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:14:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 778F580513
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:14:00 +0000 (UTC)
X-FDA: 85190940240.21.0E3FC3C
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1839DC0010
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:13:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=fAETnApx;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf28.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880438;
	b=ZLz5AQeo6PYFg3bjFPLg8x3U2dEaiVzdNb3Hi4dR1sT9dQC8/g/YZRyrBjuQR6+BRqSd88
	Jdo93sah54PAO2JjTTbaY0Cb9Hpoc9h+b6GACVUt2YdnsLScDLob8/faUJ7q7zf9PtwyKN
	GTzA+bptf+cXQRGv8vHXbAICi5+r55c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=fAETnApx;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf28.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+dYGUlP4/NCA7NxfzDivtwOTsXnKhj8P8GD9GvMt1o=;
	b=iOkzZ9tXu5N4yDzu2t5Jlm/qFgzdnohHYEKClwA//FMelF8zPwGZ3VE4T0Es6Qr5cuOw0c
	xGW9mdNVyAJc979xdpTsKWUc4BrpliytyYCq8MrpdWpNOI9Ho49ATElGa+Ch5UOuJAW1TV
	Xi4K5PCav5ZWUBuqdSl+wWn37mvjfiA=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 8807440E01F9;
	Tue,  8 Sep 2026 15:13:53 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id APiSMwsJLR9v; Tue,  8 Sep 2026 15:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788880423; bh=SihVXpN4VvNY3Mg5IOkHy8UfEsHqRfkcnelNTeVhEJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fAETnApxBEtfPuqHFKCgIL29nHx0Z2YHgAygdIUM8hU/Mz33/kA4ZUBeN/gRjrvau
	 vtDllihc6pYSe5SXQwgoqpNhfk4/08/8KMfUsCAU9thasCFYYPKC5Y/pV7Y6XU69vH
	 LNwlFlG04npY9qQKxVsZcrZnpWC37yTWxuzhzHRm5KpwYfkHvzNEQeiGPcvB58aLNL
	 CiYr2yyCrB3Kpf/DVc891YwOW/34b2QLG1yPFPyiPhCi535fKHZgiFGNQiM2V+7vT2
	 gPcZgp3ofWVjQmcjoKAe195uX42B3clf9ibePNVbJKWUY1oARNBH9aqSnI0FgzmH5W
	 h3dWuWkymclGp3MUg9haChNnjvPBl3Zfv+FDejA3/AFf/CVXHWsWO5KDUQ2zEgeqt/
	 YAh14BnniVfR4yGoNbbKeldMZUsNF3icLMOF+CXHFJzyhU2PGxTQ2922hXMjHxMdeL
	 Z7VOvQUlIKK4Twu3A1MK/eNhNVBp3Aq4OXXBOciVJLy8/PcJIx0toX/zZ4lcn1jfV9
	 ErcQYDZ5WCkd1WmQQESUO71elKnVOkkPTWwEHl1ZBofjxaMBHmYZWTaJGuyt7QqChy
	 44ZU/2M46IVY51m5w2KmjWEiICeA6W5JNXmeJ3Nh9U8UDaWIWWakyv4XQKa/cqNpso
	 4+S63J9RdOKwhC2R/OGeJJio=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2B8AE40E016C;
	Tue,  8 Sep 2026 15:12:41 +0000 (UTC)
Date: Tue, 8 Sep 2026 08:12:38 -0700
From: Borislav Petkov <bp@alien8.de>
To: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
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
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
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
Subject: Re: [PATCH v5 02/24] x86/elf, um/x86/elf: Move relocation constants
 to UAPI
Message-ID: <20260908151238.GBaqAl5iKb64meuPJl@fat_crate.local>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
 <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
 <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de>
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1839DC0010
X-Stat-Signature: myrz8oukm6chbhty75c55o4g71seqo3x
X-HE-Tag: 1788880437-267891
X-HE-Meta: U2FsdGVkX18uIiyD8KWMf0WeY2t739p+31OmZ9eoj45iz5cPeuiH8/mJMyaIyKu1xb8VkXu6+8FScsuPqlEneFgYU+zgli9ahuF8GKswvDnG22W01U8eOqtDUn+UlBArRWokGJc6mb0j9O8rHgJ5FtTQKx8cuC8u1oBL1vgldcIR+5O7DgnUGS+a9p0dv5Tor4TDfGj/eECgf7k0TMlCu8KZCs2N1f+YQiNZJ6UD/H1FECENMyVe8dTf8uZwjSUUrymzfkA7QDANJwd4qyogeyOqqG26Wsz5fiDkndiGSZtg5/9LCT6cwymOyjzErbD31U+V2wSyuHgc3Ee9/jWjE/Fq8OVd+zFSZ696GnQCoPFYybBeUs8FkgsV4TJiO3HvAAZiTkyeXOYQMZsJO+wpzTF0OQiOUmnvGeTex1arX94/9a4+hnWblSHbu4ZECvMUii6X2IpS2nhl/cDq/J3CWyhTTaaDLDehtxLci9ROKPv/3q1wzn4EltV7SgdlMZ8mpOiYeVr1KwDWRfioMsklnzgyx34ovBJPweRPhjOftDiGezwiz3EP/Zzc1TjXYmClsD9iX1LlHkQPBrzB3s/nLb3P2cSJIcxXn1H5GStXOiVvc7Tci9uw0zY5Yan2NCFBh2URxu76jlavBALqW3UmEy5lTCe2/WyJmhgOTvzZOa/AVMH7zXpq06maRLFKFfRQb2tE8FpZv58VNRzlt67imd9PWA4Ib31RLgieNFLTaSPZNS6xJlL41kaCV7I1X3GkLHc2J+Rb5UDN0dvJef1jb42oQorzEC98lXZbUZDCGn7pucWpWjLEigPA1DErUXqfJdF/rA0hly7x74kR1mqJxmRJLOlUMBroDMtiF+9RbEj3SVxYKn97LqEWF4+fh7efeuWsxEI31do6ENLxyD0W3z3SDMqsgJ5H+ZBPZ2O9e0ZSM/XCzjheiJBYbY4ma/NXoAlwRoj/aHWVYoainy4
 fJ8QOqJe
 MOq3ov4HFSDrc1sr6Nh8dBhSmKBZcKOjyPMpR6dAsEiZ5uNwfIwM7Y2xWmAfO3Oo5bpU2HRg6CweBa1Gzclij8YcISjsgHp6ADwJ3zoC0UJf8jWoUQn2CQ40nC6+iU2IwTeYZNCessEyCcgXrBGny1WfMdgLAf/DcUSF0l9mmqiJZRylstFJgFziz0JbuKeZ9ptOe9rntLoxi3CbjuMOHeZ9fQvkkY57kMaH8+K4Mmoco3xkutMNeFIobutt6IMVjQqN8EZLL+FZuwVbR1JNdUlN/aFLx8sOd7AjrjGN0JpOXTMjtDjeclZbMe9AAWyWgwYymXXKS5yz6RAMel70+RgP+fkhYcJXP2stMQaKyS66NAQnV+KN1fS0T/1EJwgaNDQll8r81u8pjfZ89khtKWiKQYUvg//ae5+XVCVJp3obNq1jsDYVkcNelbVsdqx+9uyJ6Ir9KjR20Xv1GDur3EKuj1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 04:26:00PM +0200, Thomas Wei=C3=9Fschuh wrote:
> The existing, generic ELF definitions are there.
> The ELF stuff in include/linux/ is highly specific to Linux.

And putting them in UAPI casts them in stone. I wouldn't want to maintain=
 them
forever if not necessary.

> Also later in the patchset I want to expose the definitions to the
> tools/ build. Exposing generic UAPI definitions to tools/ is a much
> easier sell than include/linux/.

tools/ *copies* kernel headers on a "they're needed" basis. No need to pu=
t
anything in UAPI for that.

It's even written down: tools/include/uapi/README

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

