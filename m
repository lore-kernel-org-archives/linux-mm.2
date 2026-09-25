Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A290FC98328
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A81A86B009F; Fri, 25 Sep 2026 16:12:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58D16B00A0; Fri, 25 Sep 2026 16:12:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F9B6B00A1; Fri, 25 Sep 2026 16:12:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3176B009F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:12:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB98B806D5
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:12:35 +0000 (UTC)
X-FDA: 85253382270.22.3932FCC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 417772000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:12:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koGG6VkH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i9btTZnCFLC8MMw6KMGK91iVLYRqVa7A+XQvAJcnthc=;
	b=Z91pejt9FCQSRZWN0IRb0rVzWJEZZ0uPEWLOHfe3rq/x5Rdi06zd46hSZOhkZmzD/FT4+E
	Ylo0yPbp4iLaUm6URfG4KNoCWRkHyA5XGcqsCnlQHHYmPW550Y7e0ZPzGXBaRuFaQABC0B
	AHDXx1/v/drTY3uhbIBMLw4PVUuZYP8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=koGG6VkH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367154;
	b=Cq7pHV62YI+X8Gisyu+jTOeZc9noq2T6KZjlGOaak23QFZBNuGTvav4TS/nJKGOkCDZ89y
	g0UovSBzDA6jFH33WPYh1ynjhBMwbtH+hPRp+fZ7JlTJZ122TqRZPKTgJz3mKlhb1xu4Mo
	fEluavx2Tugsb2TzCIPh29+EB45FMQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B841760238;
	Fri, 25 Sep 2026 20:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74D61F00898;
	Fri, 25 Sep 2026 20:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367153;
	bh=i9btTZnCFLC8MMw6KMGK91iVLYRqVa7A+XQvAJcnthc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=koGG6VkHK9sq7MUCsKX6l8GWvGH1X10xvKB/1Gb6IALPCnGNK6OLAn4edc3ppM9tw
	 XF5DLLj+zcIZx0j+zL/F8/pMW1FR8yjWkWYsg0z+hqLvAIEBvGhuRCTS95OSheg3IC
	 i8haH1mXFZ6EiUV4mPNPDYbngmJZJL6fneEkRFBz69DDia5YYUyV+DyyfnCtX2nw9b
	 aFW4fMhecvKfClHGenR6/HrNpp/dpU9NU7ZXVhlKOxZhvXhq4/JGllecZvzt50vRqf
	 5xFwTYJFDrouBhp5qHt7Zk/0avP9tlgacO//JPou+MCvPzoZmO5Vrju3Q2vp+7jOow
	 Wv8x2IhM+uhGg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 25 Sep 2026 21:09:42 +0100
Subject: [PATCH v5 07/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for
 m68k-coldfire
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-rcu-pagetable-freeing-v5-7-31e91065fea4@kernel.org>
References: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
In-Reply-To: <20260925-rcu-pagetable-freeing-v5-0-31e91065fea4@kernel.org>
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
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Greg Ungerer <gerg@linux-m68k.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2031; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wTPS3tObjnit80i5jG0OzSjV+ZJC9LambnmGz9RIJjc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2XWX/nrikwtvb6sJaZkaOMrNvQjuEvKuOTD/x7pxf+
 OXTKV0SHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIZCcjwwZR4ZUL3m+I7wsx
 28EiL/8lbNpvXfG9HGGXd8pt/qk9vZDhv1N3gp7PVQn/0s4L+TtjrpclvJk57XX1tn0fvjKcb81
 azwkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: o7hjrgzuuni1s3gupa7u6sberqjfxhiq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 417772000C
X-HE-Tag: 1790367154-591726
X-HE-Meta: U2FsdGVkX18M5Qr5/ZDtUgv1v6OADJAHgF3tNYzvHFexcdj0eRE9bbWYsJK2QFfh+5mPx2L7YNW4i1xEH3DM0VjzocSWXH5hSI5n/O7RNX/AlUVBDoBULysunmV2Sv+a6FX6RJRrCU14LjVv4nRHZDatrmOa25Dc6tmbSY6oQP12+9r6Qe2OjRu0O2eIsI30MmR2F/wS2Bp2GRyOJLhxZ/61BN48pTPphTo+TJ4SboCkvhmlMnIrwR2v3yLArK8KNVCNLgXlejzKpnNR97jzEf/9javquLKxuYuwTxXYL3NT6Y9Ab+FNoExmtivZKkesOjUKE8g+bCtRkmp/5r3ywdH2KmxEv8O2gXRsgAsaWGdlWj52sIr/ZHEBVn4nXIhEt6M0wbhPgHytWLXEAk7sFLbt78zbeHysJHwvXTQ4KC5qh7bQk6YH+oSGR//gfH8X42SfSMBwfLsv+FcomOItO6KGOzUV7ftkgP5rpbBro4NEkwWLr7K+odIZsPetkPTxMEreK9Ig0hVTyCeYsZq6uuiSoFIvYtCNDtWSihrGvdH6HPbaeLuIn5Tav0hQYOT0S7ii0S7oVqEffAXhRgJ9ks7vGjp8yGUcTk81wudtEGl3/ZUEnX2IWDUrhyOhvkVZF2qxgSPBZPWIbeLljnc97XUK5fVzSqJkdJj6QMlrsYdFTsE8tC2eutlnTivc07kgF4R1Hxxa5/svJtENTC6z58lcyaGe5qA81qY2GA9yrVue6gZz7vyxrRAbSu9+6pGWEZrlwd0fgbPwRXMLraH4WgJRzyWKI66vewtJNr+sdKP1fscDuw0YK3H/v3Iod9JlHD6h2YiBAmsNpmV8b9jsHFfNAYmcxwZUBCABd8+xgyDLW+24OKIFlSpI5dn4axmqH24OiQDnN1n/MIfkAy4VTYobbi3HXMxbqjhFualpAR2B7pBy1+VB76J3s1Ev7M15JzRd5on7pKerBDLyT4x
 v72L7D3d
 o/9MblOLuyrL10mTBVMdn/7soZTkiezNYvIORAexzcy1VDB4dPi63gyyIldJKkaqUItP1l8RfpmCrxe3UaIfULVqORiifycfbs8yN6qJ6uoYQgrCVV/L/XJCFk+i8LbSW8hPEX+PuN9Ioc5UCZ+m3sCgJGv6tNHVZrfOQmYuNK/7kzLyfp4lHP15oeXePr8E0CFKl3NZyRTG4u4MMH7yf1sfZRvuQGSaJam4AC041TwXZzKGDgIcwTbMVJZcYqimXksaqrdFFDb4hDXMsesLO9Jnk5doWd3gUL+RhdfQP8K3qbH/Pq8MJL2nJ5gz8JeQdetC91oeaZ7Jx3CWtULQU0T1cSs96WaW5ZXw1koHmrZQKV86Vwk7M2awdURxpZUw2Ysm4N99d01KBdlfHviunPlXOTF+eBE7niLKKrY8kAWMi0y4=
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
Acked-by: Greg Ungerer <gerg@linux-m68k.org>
Tested-by: Greg Ungerer <gerg@linux-m68k.org>
Acked-by: Lance Yang <lance.yang@linux.dev>
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


