Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E10B0C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 19:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAA596B008A; Wed,  9 Sep 2026 15:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C396B008C; Wed,  9 Sep 2026 15:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94ABF6B0092; Wed,  9 Sep 2026 15:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D95E6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:48:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09EAD1A0329
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:48:43 +0000 (UTC)
X-FDA: 85195261326.07.F8E0694
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB02018000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 19:48:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dwPEQtMe;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788983321;
	b=LfjzEiIPbne1GCtOxQSIdTxsBU8If/I7aI+RUOxmyINLSXY+3E3h8XMVFEmEKEJba5YGNZ
	RKDWtBR6hwP23osu7LL8wVzbjVL5skFp8Q9umz5guIGHg78/I00MMvbb4+kuTlwc++dMWd
	Ks9sLvtASXmbeNPFdhwEwSU4Ond6/oI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=dwPEQtMe;
	spf=pass (imf06.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788983321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J47hfMemV3x17DwbT77P3iNi200v7sArNBFyj4FIEqg=;
	b=qZS3Mq+bQnTvcTNicY1lyWzgbwkHR/HbkOETdz7/7WvS9FNWyblOstuY8rQI0ARHcy57WY
	fHz92rb8k0F6+B56Rrpoog352biikKZadQh77D4Lc3dpZcWmVApqt0iU51bom7lDO2r8SA
	+8K0aZ2+zjeGJa82g0uKf+x53CYbboQ=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3887A40E02C3;
	Wed,  9 Sep 2026 19:48:36 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bnu2s_xtow5o; Wed,  9 Sep 2026 19:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788983306; bh=J47hfMemV3x17DwbT77P3iNi200v7sArNBFyj4FIEqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dwPEQtMeNA/0X4YLMHgzSgsrJEReG+/8XquiXTEMnDnzYNtgPhOSI1ZuSGGmf+uhU
	 V5oLCoI78r3zgomqpkBhYGGK+og2znQrV4khKuBGPQqxLpck4AnonixUBFFT+OQ9pO
	 XoUFWUpeutEqUWw6qWZlF4MSezuaZDbfmEkEMesoxESuMOiVSVBIpvn/lv+oZivGlF
	 NbJK5pOApwMB2U2u72e0KDAnjAnnVYBqW7hqQCjgkPVGWIyW67likuKOr8KL2iCigy
	 wfxOcixBxel6j9y0nGeCklkkuo9SS7BzFZrMmfwjY0x8ZNHxCfzFe8nm3kMfbW2SkQ
	 hVt6NGm6loU4cNhNTVlWkweLsqiDVWKEfmcR69gNzENXWQF+DAqzhl1dooy8yRdyQ8
	 hzYMVbv7DEaFBzo345o2SdVnqq8Hbvr6zEs3Jz+soHKZ00hNuarCPD8kKht9ZWHhDX
	 K6qLog8avAPiAmQEstoo2bUscQYMRoJj1G/FpwnavifIGACdSvVBx3KQXFGuPZFI6C
	 LW+eR2FIosDuuKNbgs+V1Q5Aiz3ngAXwHI3OctVEHffGJL4rAUmbrTcA7D2mTokDP5
	 cDqR90QAouoVLFeoaPRexpBIoBjUfItvei9H8egAwCVgnmg67MgfJgP2vnIu6Np7cO
	 rVr0gT+x4+ZZPc8QFps0Hbqg=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0329240E01ED;
	Wed,  9 Sep 2026 19:47:23 +0000 (UTC)
Date: Wed, 9 Sep 2026 12:47:20 -0700
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Paul Walmsley <paul.walmsley@sifive.com>,
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
Message-ID: <20260909194720.GCaqG3yPjDmwKikdIQ@fat_crate.local>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
 <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
 <20260908161740-0d79e592-87a6-43c5-9174-84ce1904e639@linutronix.de>
 <20260908151238.GBaqAl5iKb64meuPJl@fat_crate.local>
 <20260909075156-06ff671c-ab7b-47d8-aaa3-588b570888bc@linutronix.de>
 <20260909144930.GAaqFx-mjH3-u6jLjw@fat_crate.local>
 <F9786718-8378-443D-A21E-77E057B62BB2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <F9786718-8378-443D-A21E-77E057B62BB2@zytor.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DB02018000C
X-Rspam-User: 
X-Stat-Signature: 7h9ozbo3btwmag8r8c17cmnfyen6uk8r
X-HE-Tag: 1788983320-59050
X-HE-Meta: U2FsdGVkX1+MTAV3JTyXBY2OzY9lPCtGMY8yhrUBT0/J+v1MxrVMQnXFulzzmNoIYIAuByfkkABt0fwDKnCipzIQricm/0GplsQj8MkhBiUuICtVjA5/U3bxbnoh6xWgOar+VIhkq+atFNccH7yT0Tv0IJ/sOx99lDXQgsciy2m0XLz7GzPXuCO3fd9YlAJm+OgTt7ZunUbO/B9U4AbAU6MHm3n7D7XO/ZoyzfCAqDKj+fLd8QMwdBJ0RxCsN82NuSf0mMlDFhSX53Nwfdiq+H78zrIcl+XDY2So+TfgPTN1Rg6SIXquVnZuedYUT0Q+8G8WOeU/Li0PRd8QCsb6nq7ztDBKRKYxOLidkxJL/JU/PP8r+O59ewR+4StayZGyPgUVxqaeZPy4FNjX6gzc5U4Urah2807R1HEc/BcuuAGfVyEN1zyApahGkAAYd+jYqcQEHyJkESzEZzcqK6k2ebnbO12Nc2kUZqjK0bJ9Jq0WhUMeIDcZBPV79wVVaTlyGgPRPzaPweYqBmLFHBIGbPYxkCx6J35cY/wUPlVhP8PgcYi9BUIbGrCqrwHOb5fUcjFKlZ4u+Ebi6rC7ZwZaA7w+/vFwrWGu7uJ+q+BbTm1woFq095Z7l4MJq6hPMyUVaDYy62LN3aZC1r9iEwEbrHM2v7BNHOOYr12XR47z1hE7cbCCDJD1v1A6mUhTehk2LjCu+o+oRnNxbo3P51qMH/JZAZEBa8so04vx1EH8esOBjS/qaYlpaNKfgjAD09bfpkiazjwQNImdye1hjapjaHs9L2JM2TlrzrLVuLZYeR3PvN+MA+pd5Arhxk/QmQowMwgdhlpVIKlY6wAVYe4oCRZvEX7QhWbSGPhhFrFiDqClR8eAF0DNK3HXwLTwjCPssjvY3Z2AlF81AIcnGMFD8YwVxG4kAQ1uPzCHjBxvYeHpRG+6KzzZHqTeVJoDn6TSweIIhDHidLppvV9SaTG
 rTaVNzAJ
 cCkEsS08nvjP9AWs7rbUJSfIZr3icCNb6VBeMDTorR0U5+0H/Ukm/2LOjXJMMMXqIpARNpd7QPSdNyC/wUKfkR8+RCRvvm4xFRKCWtstnxNbXS2B/3qwEHAFDWr/02aOqdNMZoKrlpR+18O1MeYOJKGuCT/RhG81660TPIDJuh1AC6gg+hKndtrCmvjElGniy/aIA+7lDdxC0QjM/cyK3keDNUGN/Swe8aiYk0SPSQTXe51prd/Nh4DycfGxLyJXYihpJyT7mYkBplE5uCckzEMlVJpc78YN7MGUXE+8rKvNVE7G5+2wnXzc8QmYOGIaypwnbekcVo2yBm7PJo+pQN5Vl4OZmGajNn3BVqJNCkmEMaBnE9O1O7sCoCiZ1zaU/duoNFKRUEuBNvLAibe52+PBHaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 12:27:30PM -0700, H. Peter Anvin wrote:
> I do believe there are *some* headers that would be reasonably to export to
> tools/ beyond what it is in uapi; a major reason for that is that the tools
> are suffering from a crazy level of internal inconsistency right now. 

Well, as long as it stays "internal" I don't mind.

What I do mind is this unnecessary and senseless exposure of headers.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

