Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EB85EA8124
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A256B0005; Tue, 10 Feb 2026 10:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB406B0089; Tue, 10 Feb 2026 10:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828AF6B008A; Tue, 10 Feb 2026 10:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 72B386B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:00:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2A1F1405DE
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:00:24 +0000 (UTC)
X-FDA: 84428857968.04.5D74860
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67462C0019
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:00:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770735623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7x+sepqJzaiGguFJGDA2SGdYnfQz0dZUriOf1q/rtrY=;
	b=xvjbLyjUSL5ZOxwZC8E7fl/rkahjxryecLm6RP8kCdQZ9Pa6GN1fLTb6ekeI5wREUKDaSo
	1pydEDLuJn1ahNBtHoRvEXtMsmaPSmr1Ru2NOI/3hgEF0i2l7fqhg3E+FpMIju8UHJzK/L
	jlyMbcEcSTPVOc+jpRwfHOExDYNfeFg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770735623; a=rsa-sha256;
	cv=none;
	b=4Hwkcpovvwn7TvEh6HkpkbUQGRwFQ5eliFYP4sSyUpXL5Xdk6RUepZzsSgw1awPg3gXQ+f
	P49ymQomKFrzr6yEAVdJDuGX7qgCJwWsslRtbDjtu7FpUaNwhJUlt0L6UnGln2u09a6NEV
	+1oIWpDsSNOXs0HLBRBXWx1fvbwSlqo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3B86339;
	Tue, 10 Feb 2026 07:00:14 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8D253F63F;
	Tue, 10 Feb 2026 07:00:13 -0800 (PST)
Date: Tue, 10 Feb 2026 15:00:11 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Stafford Horne <shorne@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
	linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v2 3/4] arch, mm: consolidate empty_zero_page
Message-ID: <aYtH-466xOfghuck@arm.com>
References: <20260209144058.2092871-1-rppt@kernel.org>
 <20260209144058.2092871-4-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209144058.2092871-4-rppt@kernel.org>
X-Stat-Signature: fptbafci7a5ugdmtgdpzmji4wwmsiq7o
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 67462C0019
X-HE-Tag: 1770735622-60893
X-HE-Meta: U2FsdGVkX190TLn/fWsjBkQZbbiIQRS020lBY9spgp9Ks7NJh6ExmeQSWsx3seP2kPIGinMT9ZnhoSMEyjm0QzrmJNVB6by6egOr3iSTktogjOa11wcy4npvGBZwbbd8hqc8fJjkzVBaVlNhQaKdnKDbXssIFIBRiOiwVM/aWd1VAlHxn/uu3flgx4jrgUVeHcU1UHbSET/L5w2AC39iIWXxgX0hck4ObSTiSn3COvtMTgY6KgaIOrdUoyx7ZqrV0HFvr9STiOfmKJUJwSs6NFrekIEuPnmt0hHBQpy5BIfHLlFiz/J0c2KNGgKn/HQ3pLt7m8G+PSJpIYMqPTl2c5yMEXxs9yNwJBr9KDPCCSixT+Q5VdIGa2p9ypVU4rJ/Y5f4+7ODwBGeZNN8WnO2yopB9LYjt9pMSB+HrF3g1OmOdUAT9zaDqcBOkGkZkkrq2meER7Qlw8FrMbcr19T6y9cPIGE5O9MaP96/QdHlWFr4OriHgOgtaEL+dmkEsKsCmWyanWr1n2p84edaZFR5CXgn0fwSAHnPzS69tiB9DVfq0VxKeL4W7/DSWQj2SxUkAnJZHIL78S1lYCsQM0A3bbw7Wi2FbWrziu6/A3+7wpHgfWdQMWwjquxwzRmUxe2mlafrPKJTuYtw/VXsJsOs7CRMzWOdLasNTglJJ5MjglXjaeehKWD0fpCb0lVkz4bnY1/SGKzNucMs2g1ro6V6g2WiN3kOoSiFioOJgeTVxzG7Ctjj+IZO7gE7StOqXbZ+fndi+UMdoP+AncyFiLiFTMidetGBy3cEcAp4RSAKtofNgezU81kNGFvlaKDawn+Qq6UF2AoG7EKElhQUvsbd3JUiYBBR9nUYanD92F2jYpJQMMvtFhHVwf0d4MwXCN+h+N9vFd82r/ErgL0yP7hqaFDFzdDHwGCCNskurVeqeDIWS4MFPjMuHYvB7g7xth9RdaiglVXu34+Ww7eHsSc
 sqFHWJWI
 XnJ4MU7Ub+M/+KPmFfvFJ7N1w8psrZSn8AlCdudwPgvVYMTzmHZXBzRqbsnAE5BCz5iu1L0Lhidm71CLb/z9nxsPQqOrVIOaVP3XcoYQexyDMUZImqPde8iCXSc1RxTDl7gm1G9BvHZJeb6fImE74eQHCgTDKCCcMD2C16kg293BdDkElfOwsMdkRRu1A48en5InoBj5DXgQa4ReieOM7x5u5uDfls4hjZdqgz1CTWrbyKv7Gn3xT0VEbOdWtutntZkMj1sdJB4pM70E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 04:40:56PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Reduce 22 declarations of empty_zero_page to 3 and 23 declarations of
> ZERO_PAGE() to 4.
> 
> Every architecture defines empty_zero_page that way or another, but for the
> most of them it is always a page aligned page in BSS and most definitions
> of ZERO_PAGE do virt_to_page(empty_zero_page).
> 
> Move Linus vetted x86 definition of empty_zero_page and ZERO_PAGE() to the
> core MM and drop these definitions in architectures that do not implement
> colored zero page (MIPS and s390).
> 
> ZERO_PAGE() remains a macro because turning it to a wrapper for a static
> inline causes severe pain in header dependencies.
> 
> For the most part the change is mechanical, with these being noteworthy:
> 
> * alpha: aliased empty_zero_page with ZERO_PGE that was also used for boot
>   parameters. Switching to a generic empty_zero_page removes the aliasing
>   and keeps ZERO_PGE for boot parameters only
> * arm64: uses __pa_symbol() in ZERO_PAGE() so that definition of
>   ZERO_PAGE() is kept intact.
> * m68k/parisc/um: allocated empty_zero_page from memblock,
>   although they do not support zero page coloring and having it in BSS
>   will work fine.
> * sparc64 can have empty_zero_page in BSS rather allocate it, but it
>   can't use virt_to_page() for BSS. Keep it's definition of ZERO_PAGE()
>   but instead of allocating it, make mem_map_zero point to
>   empty_zero_page.
> * sh: used empty_zero_page for boot parameters at the very early boot.
>   Rename the parameters page to boot_params_page and let sh use the generic
>   empty_zero_page.
> * hexagon: had an amusing comment about empty_zero_page
> 
> 	/* A handy thing to have if one has the RAM. Declared in head.S */
> 
>   that unfortunately had to go :)
> 
> Acked-by: Helge Deller <deller@gmx.de>   # parisc
> Tested-by: Helge Deller <deller@gmx.de>  # parisc
> Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

For arm64:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

