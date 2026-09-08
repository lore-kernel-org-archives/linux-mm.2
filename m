Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF40FC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B1E6B0092; Tue,  8 Sep 2026 10:33:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACBAC6B0096; Tue,  8 Sep 2026 10:33:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA8F6B009B; Tue,  8 Sep 2026 10:33:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4016B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:33:24 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 376021A0728
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:33:23 +0000 (UTC)
X-FDA: 85190837886.17.2DD12E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9CDD1C0008
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:33:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788878001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+Cz5ERVkEaR7M7w/Nfp8XjnpMbxd5qHpWGQvy+qtdf8=;
	b=1/F3VwjNN7/FtrTOBe0dtD8fyC4QWNYXKBAzZHfuu/jllu6GHelQPZFKJwxa5TcwQ6niJo
	FRTvuJIgBjsReFJMdwskOIO/ZwPgLwfpYFCrF9nYSlKTKMTCSsiGioJ1eWVLOCZPA1r24Y
	6v5gys0ybbzs0YagxlUfpoWz0ub17cw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788878001;
	b=t8s3uRZdcWQLvZgMojRxbEXE5N6rcsy4uCaLFv79GLWEM3jDiUl6xp4kEtk8Axx+V5hpCo
	CmtMT02dudSTGrXQaMcbsURsg7lVqpwq9nSo2De222lmGJh1ejPgqKctzxTZsrAkcgeRm2
	sfMv+E82iP7BTlvh4Oad9J2bkaqqt8Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 34C5B601DE;
	Tue,  8 Sep 2026 14:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0701F00A3E;
	Tue,  8 Sep 2026 14:33:02 +0000 (UTC)
Message-ID: <1ef2c31d-6ad5-46cd-98ca-0f31485cf8c1@kernel.org>
Date: Tue, 8 Sep 2026 16:32:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/24] x86/elf, um/x86/elf: Move relocation constants
 to UAPI
To: Borislav Petkov <bp@alien8.de>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 Andy Lutomirski <luto@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Boqun Feng <boqun@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, linux-mm@kvack.org,
 linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
 linux-s390@vger.kernel.org, linux-mips@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-kbuild@vger.kernel.org,
 Jan Stancek <jstancek@redhat.com>, Arnaldo Carvalho de Melo
 <acme@redhat.com>, Alexandre Ghiti <alexghiti@rivosinc.com>
References: <20260908-vdso-absolute-reloc-v5-0-3a93791af1cf@linutronix.de>
 <20260908-vdso-absolute-reloc-v5-2-3a93791af1cf@linutronix.de>
 <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20260908135513.GAaqATwXHcQD7plnH-@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9CDD1C0008
X-Stat-Signature: f5ckbo7z3t6qytryzuw8biqjtux3deu4
X-HE-Tag: 1788878001-403693
X-HE-Meta: U2FsdGVkX19q7R/7lt522gcL7mTF5GEy6YRI3Wpm20haVlYC3MH3WcuRu1ePKhK0ql/iG2lKk4/Vt9haJd/gZOV70gTd2nNLvqYcznVe7NDmYG76LqTrCh7KfMqG7Zgel+PYh8NKF2CQKz0sVo0Ef2vq7qJ+k8ZdfGJrBmxyNjVGCnHUWAdMGP9c7eeELecYbnAQQvTKVaXnclPcoR//mCekBK5JJ1WbR6Lq1Dc2hI+eMwD2Ck7BWJMSME+u5bAWtvPOchR5A8qmQ69J/lvbP7nJQSOVDcugha8VGPmr8Eoj85gg731dWGIFBSPNPTBYQtv3bTCNe3uKWtYq9YLyu8zitT009vfhwwtC0q8CWFDOkVCyxGhoPL/TpJNSvaLNnx9KF6o4GPLCDIu+fNticQdv53iEfEzrU4rJRId5FXBbHw5LKaiOrqlL5y1bu6fKxZWeab3qy2QorSXSASl/IY09nkQziq3e43M+2nMo58y28fsG0m4MpStII9ZD7PPdVb7z2JOUVjEEiH+TzKmhTmFruLnZ6encvFHYzGK1gf9SLEkLlruaMnv0xd9vdshnJMqYmuUxNIQ8cM6v2ph6RIryLiJOgoyqW8Gxnoeh/ak7S8/WrKjzqdHI/1mX5c5eoPWeMPWqxxNGqyZ+FO+gkLlG3ZpZVk6YTxaiYQT3+ow7BP8RqmFhGSoHeGLl/0ORbjR4bN13Ui1I1wM/WYxkEihgQjkkI8i1/ZWqYaI6J2fsl5tK2drybI3EGPHI7E0somLs9ywHu/SjJDNXRGGTiKFk/KHRkVRuvIQ8uYRbDrKv3qeTFu2Nfg8NdAGoUt5SSDqQtbWdq95dMaqzXk0V2gwhiWst/Sxz7Q1PYHA0BKbhthw55wVdMwaftXS5DmhwO5ftublD8lCLLrxWxQGYJGeVI4NvKkir9qxdqhy/8hQAYx3VrG3vyxAq9xv81WgKeJdHtJyF+Cl/xxA1ARQ
 X3hSLr/E
 gkGJfJzGggIeeZFlDoSxZU6BInxF+B7YInQfeN9cKl1f38U0kJjNtWb7R++ztcxiIEQoV4NYPSDsuG7W/wqb8g8U5qHuIM8eIy0XB8yLyLwwplcZEogPU2hnC9s0+3cZXYSoluvAeAIeyx92v4oBIIeWAP0QiiBOG6CyZS0GxqvzbY1VPu9Frlk0P6uljFu08A+iSIyYZwyYs7zaiupo83pOgL+HfOxFGGunGjIjP4trFlNCv/vCqBFB/WokIJCmUqX3Z+SmcQ7JQir+fMfRnao31lUEgalB0rzeG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 08/09/2026 à 15:55, Borislav Petkov a écrit :
> On Tue, Sep 08, 2026 at 08:33:36AM +0200, Thomas Weißschuh wrote:
>> These constants are useful for cross-platform userspace, for example to
>> process ELF files during kernel cross-compilation.
>>
>> Move them from the kernel-private architecture-specific header to the UAPI.
> 
> Why UAPI?
> 
> Why not include/linux/ ?
> 

I guess because on some architectures it is already in UAPI, see for 
instance powerpc in patch 5 ?

Christophe

