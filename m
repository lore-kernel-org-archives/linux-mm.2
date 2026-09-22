Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37FBC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D8F6B00AB; Tue, 22 Sep 2026 11:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF52E6B00AC; Tue, 22 Sep 2026 11:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4706B00AD; Tue, 22 Sep 2026 11:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 947DF6B00AB
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:39:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3456C1A0505
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:39:13 +0000 (UTC)
X-FDA: 85241806986.25.333DC49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 59CEF1C0010
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:39:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMqHdadW;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAMKCdWX5FPiRKf/xR0S9vZ7DBMPzl1KsARK3tocs/E=;
	b=XEiMCFfXYm4Chrh1iYBJeM7SMcgFjcR5m0goKgjCkoi991wUgrsJlztIcTEyiwYB8cHIZD
	FPdQEceXOYVji7r5eWbZW3bAk10LxrhLsNtgPTibDRCQBL5BrX02/XN8TACEL1a6Zg+DUr
	VOYSuMLl2zjhxk5niksaqHbvcTnvx2U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YMqHdadW;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091551;
	b=4ucbzukHACRXvR/Spo6NJU7mcPix9DsSY9DdiFGAfOg0AnXrMf5CNsZF4wS2Le1+icpu8y
	mkUy2zV5n24lMdu/7UXzo2V6d/nDFFZQf6vBszBTob+uIvMLLNeLSAV1G+Rv9c4Nn3pBlW
	Ul38C8UoNryOFBCUv8r1LboWOmBikBQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B88643F42;
	Tue, 22 Sep 2026 15:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104DB1F000FF;
	Tue, 22 Sep 2026 15:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091550;
	bh=AAMKCdWX5FPiRKf/xR0S9vZ7DBMPzl1KsARK3tocs/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YMqHdadWNJEO3nv+PyQF5bVEZubijamwPceNJ4F8tT2+2ZTV+UP1+hpAtqqBUk1Fd
	 voiXsP6pb6YTENL+WTRClpOH0TMQ40BAFAqSgDKZIOVDwLm1HJoQ6G0eRWVohQdgum
	 Nl8dEFGs1KeJ0KvfjLwvm1mRbV/OC+0QARjQRhXrmu+CUCXPtNUIlItZ9fmFFh/4lk
	 Cd+7gDypesGbNgTkvr4sgDfjCXnp+ZHQNy74dphXcSKDVwEt33Sx2mZ81N4Kql5n8E
	 VPYMPcglZkBnOox3M7uLnWPrS83jiJKvEcBCwqKNcVq2pwp+Ns6KW1BlRLT+YsBTdv
	 pSwqpEDGHSJtg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:38 +0100
Subject: [PATCH v4 07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-coldfire
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-7-fe1ad1f1e303@kernel.org>
References: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
In-Reply-To: <20260922-rcu-pagetable-freeing-v4-0-fe1ad1f1e303@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, 
 Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>, Rich Felker <dalias@libc.org>, 
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Russell King <linux@armlinux.org.uk>, Vineet Gupta <vgupta@kernel.org>, 
 Michal Simek <monstr@monstr.eu>, Chris Zankel <chris@zankel.net>, 
 Max Filippov <jcmvbkbc@gmail.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, 
 Richard Henderson <richard.henderson@linaro.org>, 
 Matt Turner <mattst88@gmail.com>, Magnus Lindholm <linmag7@gmail.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Mark Rutland <mark.rutland@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Arnd Bergmann <arnd@arndb.de>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org, 
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev, 
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, 
 linux-um@lists.infradead.org, Hugh Dickins <hughd@google.com>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-doc@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1893; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BvcyYBL/6DvMpTsf26rSU6vpsqM4Qkuzt9TqOJJPzlE=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2LchO7lPnkNFb6m/L/nyu7j/vVyJfNO9dt7n/f2af5
 sKaK4e6O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR1ycY/nsf0VwbWJQ+SXe1
 Udg/Z9f7lsvu9GmKiXzd+u5tv/JZQW6G/6GVnR+mLzi8ee7FGXqSBg6bjuWJnz3tl357s8ulqb5
 F/lwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 59CEF1C0010
X-Rspam-User: 
X-Stat-Signature: 56zdyz9asgxpbb3sekhxsoy3os5bjy6t
X-HE-Tag: 1790091551-137794
X-HE-Meta: U2FsdGVkX193XLcusQonhB/dSLre2VNFrwNSrJOG7/b7YennOfw7KTHSvplVPf7M8VrdsqLdsYz2/EwG/Yp1hDgprd8+o31UpJr4/s6i8aGdxcJHFMMM0BN1J7gaihtsF8DwLWY38e+BOwnVQInjDXgBNZo93MTq+6ZoQakPxvQFT4EBw6bh6OMbixzcM/WIcUlBV9IkYduOAZJNDj4CeARIgexiFY6exq1kAyjhGezsMF4xmbGJyFJHPaS5hYn9wCMXZyYAebowCTETxSQbzoeZjetCL47v1kyPW4vc2/wPxl0+DdracVccxXTjzobRSO5GPo+x1Rx2nbbednvVymFL+NuceDHcbUjJB1TM50JNcPA0p0aurb8byW+UNSVKNSVExPF0NfDqTCrTQD/xSvNXDA97XRsBW5cvDYsCdqSgeRYlyWzd1aOB2oGe4tMwL8wSgGwjEc8FlKtTSTyQCmTJ1VeY7iqzs0Ahcph5CMWNAuXcWIhzi6WhZFMo4w56EdMx6f75wVBdtt8CBUnn/ohHAUtws/xYH4DHPm1rDCS0o/i3Ccy9gG/QaGnj9Or8SiNS4wnBdpyLhBkz5BauL0BYGk8u5Hseoe3EE1qjxPedfNO4WM4Jd072EStkN1T1bkP4k/bv5HXuwao3SRh1QdCjE//oIsl5lqfyMABGsf1SFIUm9iLwK8ippNPtOOUiCGOqVwf4xxNIGl+94g+/AtmNZx/5qT4WisZZGXazLThIi8YK6Yb3hrItCeZ6dtIqUuy8hke72XtRlL8otzpsx/hxOIVOR4EwADd55V5o+hs5uBbATJskdAYlI43JNA4cmNIYRd1CLt2P92cwD0vmmxBcT/tHSGYzrt3Hu9syFIwPmS2sKZ+PGw9iti8r8jNwRZKOYJa7GsVsaOSe55O5kuIZ+3dorpxD9Sr2gwjz1BobGbDT6x8B/95C1uhblYqDTTkhUXV6cKLqiB6/RU5
 98iGNLSn
 ieSNphnFe1zHNoNnkzOywt3KG0PxLpEUbS4HBunpMn3jVjLHf3tpU97OMVuQtdiFXUF4Y9mWMYwlhcJbTOcpZ2dCVk+Fn8mro5R2QTwsBaFXiAw8LoftiBHFlm0gS2GziexAwSCRcPDMFGf91ZQxTDMK6rnC+mrP8ZQqBB9Tw3SglGcbqAwtMWU63FJK36GSdSnwbz7a5pCPfniJLtUFa9Bo9LUHUMPh/xmBzOJK6V0izRQTnD/Tet3AG8859pxiof66NrfXbmxaJ7Es2cIbXv3O0aaDa+/Ni7P/AQIzS5uN7qzJrT9SzhE57UKoT4ASKTrCoc5bCKZxha8+1tGL0oMZqB4wfVhlJM7+vGRLQs45JSaZSLZJazCpjjXGG3pjq7wjPCNWTXCnyv8wo0le2S9SNbGfEBYTrSj/uns/g+f0t735ZePU357hgPQlMfj5NMCgqlF5QQMDqo7w7CCah5Bsu5zI25Kx1XCxItzwte0mIvPo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to sun3, the coldfire variant of m68k uses 2-level page tables.

Update its __pte_free_tlb() function to use tlb_remove_ptdesc() in order
that, with CONFIG_MMU_GATHER_RCU_TABLE_FREE, page tables are freed under
RCU.

The page tables occupy a page each and have no odd semantics, so this
change suffices to allow enabling of CONFIG_MMU_GATHER_RCU_TABLE_FREE for
m68k-coldfire, so do so.

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/m68k/Kconfig                   | 2 +-
 arch/m68k/include/asm/mcf_pgalloc.h | 5 +----
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/Kconfig b/arch/m68k/Kconfig
index e29610fd1240..6b8ec67c86fd 100644
--- a/arch/m68k/Kconfig
+++ b/arch/m68k/Kconfig
@@ -36,7 +36,7 @@ config M68K
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_UID16
 	select MMU_GATHER_NO_RANGE if MMU
-	select MMU_GATHER_RCU_TABLE_FREE if MMU && SUN3
+	select MMU_GATHER_RCU_TABLE_FREE if MMU && (SUN3 || COLDFIRE)
 	select MODULES_USE_ELF_REL
 	select MODULES_USE_ELF_RELA
 	select NO_DMA if !MMU && !COLDFIRE
diff --git a/arch/m68k/include/asm/mcf_pgalloc.h b/arch/m68k/include/asm/mcf_pgalloc.h
index fc5454d37da3..b53ff0950db2 100644
--- a/arch/m68k/include/asm/mcf_pgalloc.h
+++ b/arch/m68k/include/asm/mcf_pgalloc.h
@@ -39,10 +39,7 @@ extern inline pmd_t *pmd_alloc_kernel(pgd_t *pgd, unsigned long address)
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pgtable_t pgtable,
 				  unsigned long address)
 {
-	struct ptdesc *ptdesc = virt_to_ptdesc(pgtable);
-
-	pagetable_dtor(ptdesc);
-	pagetable_free(ptdesc);
+	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pgtable));
 }
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm)

-- 
2.55.0


