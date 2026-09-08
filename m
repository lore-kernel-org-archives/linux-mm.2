Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA4DC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6B3E6B008A; Tue,  8 Sep 2026 09:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43066B008C; Tue,  8 Sep 2026 09:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59306B0092; Tue,  8 Sep 2026 09:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A0DDF6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:35 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29032C06AE
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:56:35 +0000 (UTC)
X-FDA: 85190745150.16.7605807
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1328A12000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:56:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=ckTRe3AP;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788875793;
	b=0QHu8MsVRzY7cWpZicE/zZPKo1i5BoMa28kM0o1PXiEO9Rgwsl5JCS022useKZrPPquO9g
	sVm/qC4e3EuwdUJ+xMob60cAdx6hTkyU4N37314p22ww4GCZkzh7Wz3FuQLn1qYePrWv1S
	R35kMYKoqWb+vwQek6WU+38ckOFidTU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=ckTRe3AP;
	spf=pass (imf29.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788875793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnDf1uX4BdUZDMIzBfyePh9om2giChK7UzdbMm+aChM=;
	b=oPcbHd2C9lMwqkZsN0ibibEzs+RB6oYOkjO+4bZS2Cf8ZKwVGzIYAVuEIZn8Pv/VSH6wJC
	p7RKDZ7CuJNAdmIJQmGja8c3N3LU4+CrTRcNSxgCsvfWvQKIfZIR+73oT2v3j+J04XO/u4
	bpKcWDS/T9dVswmZmBoa8YyB8AU7qNI=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 3C45940E020D;
	Tue,  8 Sep 2026 13:56:29 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 5qXKlXyyaJ1A; Tue,  8 Sep 2026 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1788875778; bh=kXNkLBcr+MG7BHJqeeHaLokvBdBeeMHnjUE3stY0luk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ckTRe3APsxV8zd3aHLDbRKowGC2zSniJAA24Kt5+oY7o0ve9PWKF5qzBPopM3MPzG
	 nCHC8z+inSEFr65KsTY7v0y5Me+yxQN+yYGf0Kea05MstOcF30c+7CTOeWLs4WHaen
	 saUDiKtXKzodmoUWrICUVq2iX5AeQy5l0ohpxjUzLl6c9IHXEVVo3SiU927VoT+/6x
	 qAopQ5XI0Z3df6psiX43eUXujqenUV0SMfLOjXQ7iu+N/pdMO135Hu0uia3OiezG6F
	 3BQXZyL9gEAYT0T8MlWNODVy867kXqXWDznQLaaS3hnYUtTHX7ZPkioJ+C661mIH9b
	 ic/QzGZYvbQCTW7sP6SYp95dpERxWEEjf4GNtlzOSWbxOHiLn0RHmVPtvW4BYJoWvh
	 c/tOCDFqYnvh5YFTyN9GfAK6l94m91l6GS5sSYV+wFiupKKyMLGl8CaK+9cb3cZoI4
	 mlWKwNA2s4fKHKSubYMAlCtd8a2o6fUxhWShY9aLdMFEqUQwrJenLRWIpJ0ag8aYsb
	 W3QKYQQmTp4Jjf5zXuVHiRwAluE432BXUeWt7qI0luGw7gKHWwuLMGnQL1MEHEyLdb
	 ONqhiiI6fb2L7uOxLcZK3mU619FPi/FBNNiTWRBnrCXpLvKVraEnxfnW1PUmkkdke8
	 34u7wSXUJmbuZU/MSeUYx8hM=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 253D640E016C;
	Tue,  8 Sep 2026 13:55:16 +0000 (UTC)
Date: Tue, 8 Sep 2026 06:55:13 -0700
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
Message-ID: <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1328A12000B
X-Stat-Signature: 88xycghidixnpdbwuwosaa85qwu9ibp5
X-Rspam-User: 
X-HE-Tag: 1788875792-998551
X-HE-Meta: U2FsdGVkX18lceufTKHAsXgzHOtCMlWBWVNs8xQYifE3+NNozUdwtGvDHc59++upoZ8kFHmfMrEU8UNODdPKey/uSgXW+QBWR29QaGAhZQ21caDIVed7ja5ttQ+A1slc9vJI+8lFT+NdjIy25htndeuZ8a+g2cf9ESVowa1E7TbqxaqNBga7bbNEzzZTYuPdfMBByiNKd91eum12iTIsh+bZ3FEbJhm52zy9rTcFsXKUazKMI0WcrbC1hv0Wg9x4EWNsZZj/UW4qwLwe0BlmJxVJcuSs4r7iPhldF9XKYhTjaoXtSc/EIVkbdnsJSNpZKU/Bda8A0ytDfsGzQvrcdfDiz0eS2apbPCoSuxHbxeINH9I36UUUo47W1JhOrP+YnRmRzc3g+7XkyXAvdPRrnlLxVBSXFk7DLTUXT6J45tMc0d0ua5ANsoA1GinGrM2yJ/Emr8GT3pDzVw5cuUUUsbPVJDlOdWNfpUTU+IsDVJEvIiRc6ZwmzgBWxQL3stMqhgKwWQB5lwhAHIlMNO4HKMELypbb3RabXgzAXU63mNOnkp7xOTArr6UrIEsde6o76GDJHMqTzNtbYI0QC4lcZCW4i3rWrS5FBmk2AA/tYnjexobZf3huUdrBhbwqO6DtOADVTEG1mIPLrQDKYu1qNGRFxrIBCxKJRRrU51rAt3epFu0HPAHf3/Hud35SZ6TS8owimfvfzxzQzfFoDBnEVgeQgxPGxwOvXKGvV+6IXFOniyUZCU/u0IYtiTriZPyI1M4ETrMEJLjLseiMlWn/2P4aEQYoG6bOfSi4ZFM6UTojmPcWfkwAP+j1WKGTibMPuwlEWllual6IgV7lNL4wttGIukr7s5K0AOOrRQTkIFSNFKynvHc7z8ubn24GJ18acdHTJPpVPw/FkvBX4UXAcvXJeeQbHofx3C7dTXA5NS5hq+F4cRZ5hA5ubNU1uFE2JIn+asqhwO3jzhfAj1B
 /fSwuLZB
 6yEYOBoApJUWsTgNcMvouK7PdbyIjmMFuJ3/+WqCWPmfIQJFzsAVvEcgYAvx9koQLw8nB0ql6GuFHgrQGXeBY3zZ0sqBdWCuYuG2mg23VJXrzZPkgUbafAdE75K0IW45arQLtXaWQJhN2q7wv7z1H0R0KFuy3KcF40jGxYYiBwnme9bwQNzCHgYYYqKb1PNVPwWqweLY6QDG/ZoH6dk2SQc8Iqav4wYv67PKwZs1A2R6VTm99aZctJXpJeq5IFWP1I3RajGKYfAG/wrghtgey/+QKTvBeaP6r0mwWq4GJ73jJaDdjjliK4ovK4g+f456qsnXEFCpSLB8xvhT3JDcnxQclda0ms3TwDhnvrgWz/oTG1pyIRvFhJA2mGyEWl7bvPEMx02dLagNtTDs3/Ch3F1R4j+l/mJYJCeeHnXXV5UOaxyBbribcdN3svoj/gtkVOB68JFydrQK5weRKY4b5FzS75w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 08, 2026 at 08:33:36AM +0200, Thomas Wei=C3=9Fschuh wrote:
> These constants are useful for cross-platform userspace, for example to
> process ELF files during kernel cross-compilation.
>=20
> Move them from the kernel-private architecture-specific header to the U=
API.

Why UAPI?

Why not include/linux/ ?

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

