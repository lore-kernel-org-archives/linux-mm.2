Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB4D4C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 15:38:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA3FB6B00A9; Tue, 22 Sep 2026 11:38:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7B2F6B00AA; Tue, 22 Sep 2026 11:38:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91EC6B00AB; Tue, 22 Sep 2026 11:38:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3B16B00A9
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:38:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05D4EC0506
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:38:50 +0000 (UTC)
X-FDA: 85241806062.05.5A8ABF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CD561C0008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:38:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBRxSFnR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790091529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=88XZdMnGcr4EoxTKx6ho5XutcNaS7FDI1j17HitUiT4=;
	b=JLLIrl7AtzJ+HUnKhOFpe+EIfpo7E30rcbj2LOhoZVG4diE1SD93pHGrW9VGYqXGqTnOZx
	lm+ick/jMpmBa81dcgaLbkyQRanBbidKvwOZLjSjsjpvJ3kXv8ggPdCxUT4+TXHjdcaPl1
	UHfN3Gom7pYUQgrqKqWrxyTM5lAcWhE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aBRxSFnR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790091529;
	b=Ev6O1Gh+D5+gGHc0HPJBe9beaGCkTeRhho28C2LAKCvf6MMSEo9x62U7+dR1nACditvO9Z
	45alCEjPEon5qEdxetRfpoB8jYxZNm0Lz022grG1v+L2LTRJOHX5W1lWSFM7pM38ejNR9d
	TuzGpYQqBMD3e4kOtopqv33Z/gge/F0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D049260A82;
	Tue, 22 Sep 2026 15:38:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCC91F00893;
	Tue, 22 Sep 2026 15:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790091528;
	bh=88XZdMnGcr4EoxTKx6ho5XutcNaS7FDI1j17HitUiT4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aBRxSFnR+u4B1t5yIchx2A0ERyJsj4YEBy2FNdmU26YxeMEhi9gcCb9tHneGyWX7V
	 nJA2n0nAZt6niS45hsrEtz5mRv+bmTHWLyL+oJf7iHXJbtTqWg6U1myGyYN+KuL2bF
	 WAcY219MdKdF4UBWJmkkHs8N79H5ZCyLjW9lswGRy9mgt5BsV1MqRC/Dtd2Cv4O/uK
	 bHQtLRZzDaNCaipCAP2+QUoU6EvGdFIo3ByBFB0P5J2sY22d0mc7G4O3QBgiFgcVA0
	 yHQ8960BuIKrhx2onEMQBi4KdiPkZDUhRy0xiR0ugjg9aW3G3HPY34Ob27RIyRZOuj
	 7Eruk8db7fl8g==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 22 Sep 2026 16:35:37 +0100
Subject: [PATCH v4 06/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for sparc64
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-rcu-pagetable-freeing-v4-6-fe1ad1f1e303@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2472; i=ljs@kernel.org;
 h=from:subject:message-id; bh=56BKeeSS+gh75h2n7cGmrCDtrwD4bozOQj93IG348BU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI2Lcje8/i97r23G/ndN52avMTmW9S+qlW/r8/evv/+e
 b8tfz5qqXeUsjCIcTHIiimyPP8ivj9IJGxe5wV/N5g5rEwgQxi4OAVgIhKrGf7KiPTw12vyPt4o
 9mE5o2e9KNNMm0SDRRbfuZ/6560W6Qph+MN9YMfdhZ5fxJqmhNXvCP069wGvroPxyimr7v2dvTv
 UbB4XAA==
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: usmkjwq1tdjcjwwdq4d6oqpzpzn4zpir
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4CD561C0008
X-HE-Tag: 1790091529-415656
X-HE-Meta: U2FsdGVkX1/CMMMn1ZuhuY9Vby9Xzq3PrELwQjIbG5JuRdpsHaeWJJs1RCehhpB9sUr7NGn5NPCgIpwWyQhouWKEWNYPPVdbq4Vh6aaAsx/aw7z6fiHvyO+yNjt4arOgeGfjmwDi8eSSzg4nyZlQCyvg/16FGpdXRxbc8QIvP/hiEbic2UwrMOyBvUXFaUGYTWPY/fw13YXUwWJp/a1j5NJHfbhuDSr3AvB/oM+1oyUfurK5Z/rgIh1KLizWa1lIyk9SQy4u/xYZr6JMOo2GNembMVL/Y/mbCA+MxsT1oEwzTdDvkVjq8orsHViA2oBNWqZXx7ius9322V3PKGuHsAku1FsXNE4KAOGT+J+wUWn145TiRufaPqcHYW+CBNI+FuQ5aey0C6+CGmrQQrIueEPvOOitU8ORn1RQiMUBSSRWK7MNc/mqkaTBu5xZN3K7XVvG6TUqvasssuAdIkTkBKAEbPmhF3dAU2D67oA/tVJggSXTaWjGjgSB4dtTh6g/eys95q8yJb5FB88pjQQQXzRUcsrqdd2e5vjScOXoputRctT5sDQkJAuaWE3mrSXh3AaAzS1PM8kxnjJIKTiS6VhT1YDAIdgtFbYsKBqyu8scB67olWUs9evidvVHwDse3vKaU3P2213MhgQ4Ge1dpd6UX+usBVbYjF0P0jmwl9GA6z/1kwncGP1XeB1tFAdBVu2DDfcfo2XsV3PUxBNOquIOO1DQlUFf4hg9peSdUTlE38Ge7yQH8tQ49/RgbF96abH1UEintqeZHWPmABKl6wH1oEJBJmBAnADlkoZEuxpjXp1X2ZU7Ov4dMCG3u1uOyNdem1mL+5+wFkghbHEIQMnTAuyWg1pqt3hpmyOThKRUs4096DS3fd23l3Kwf09yeOlsg5uZLkBGAdySfVLhJGbC1BB3IpaJ1SmN58cE3J9N3iM4PryW2V6xBPSDSKIZsjgxKRfIC0EAnaCVii4
 MSfUqdu2
 CaMnix1m3zQm1vqZ6Mt29IINtzELfTj9RYQ5W2PF+SmJZeGFzs8FvHXYUurnW8RxvlfRPgNWGxH8vpEHLQpbGJNkAmEwSrCZR9zJUy2Eg1sBTCXTG3JwvtdGtoKqpI22VY7oFqrYGq1FzmGjEDUWUVxoB3pbfedfez93rGBvgPZim5aNtFyxsXZzehCoPjGPG6GaduEjkjGo3dHYe6477PnCZsMJ5AAHUNGMsfeD6TFl0JU5do9UBWMRrnNlKMx9q5C4KrxPYFNZJKLRyJCeQHlsr8b4d68aVsFeDiyQPDFzf7bvKstSipSZj0t1JP6vgM1sl5Kq4PUsoET/dNc3E0MhUrodhVFYxgJ70hpOa1DHAcKLhv2+IRMrFvMT9ycVkbVlKGkJ08u07DXsAVU192bOTGZZ1g3cO9VxI1EOxTE0hit8FvE2u1W0Odp2wGNc/UBV0s+lsDKOu2oD/VLkKpjSuzzp0Nje0eG8bMq3WaqNhABA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 4a0100f7546f ("sparc64: use RCU page table freeing") enabled
CONFIG_MMU_GATHER_RCU_TABLE_FREE for SMP sparc64 architectures, expressly
for GUP-fast page table walkers.

Naturally, UP systems do not have to worry about concurrent GUP fast
operations.

However, CONFIG_PREEMPT_RCU is also available even on a UP system, so a
future pure-RCU page table walker requires MMU_GATHER_RCU_TABLE_FREE to be
enabled on UP, even if concurrent GUP fast is not possible there.

To enable future pure-RCU page table walkers, enable
MMU_GATHER_RCU_TABLE_FREE unconditionally.

With this change, it is no longer necessary to have !CONFIG_SMP
pgtable_free_tlb(), so also remove this now dead code.

This forms part of an overall effort to switch every architecture to this
mode.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/sparc/Kconfig                  | 4 ++--
 arch/sparc/include/asm/pgalloc_64.h | 8 --------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index ab77d3f2536e..8d42ebc6d302 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -75,8 +75,8 @@ config SPARC64
 	select HAVE_FUNCTION_GRAPH_TRACER
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
-	select MMU_GATHER_RCU_TABLE_FREE if SMP
-	select HAVE_ARCH_TLB_REMOVE_TABLE if SMP
+	select MMU_GATHER_RCU_TABLE_FREE
+	select HAVE_ARCH_TLB_REMOVE_TABLE
 	select MMU_GATHER_MERGE_VMAS
 	select MMU_GATHER_NO_FLUSH_CACHE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
diff --git a/arch/sparc/include/asm/pgalloc_64.h b/arch/sparc/include/asm/pgalloc_64.h
index caa7632be4c2..b5055d259b74 100644
--- a/arch/sparc/include/asm/pgalloc_64.h
+++ b/arch/sparc/include/asm/pgalloc_64.h
@@ -74,8 +74,6 @@ void pte_free_defer(struct mm_struct *mm, pgtable_t pgtable);
 
 void pgtable_free(void *table, bool is_page);
 
-#ifdef CONFIG_SMP
-
 struct mmu_gather;
 void tlb_remove_table(struct mmu_gather *, void *);
 
@@ -96,12 +94,6 @@ static inline void __tlb_remove_table(void *_table)
 		is_page = true;
 	pgtable_free(table, is_page);
 }
-#else /* CONFIG_SMP */
-static inline void pgtable_free_tlb(struct mmu_gather *tlb, void *table, bool is_page)
-{
-	pgtable_free(table, is_page);
-}
-#endif /* !CONFIG_SMP */
 
 static inline void __pte_free_tlb(struct mmu_gather *tlb, pte_t *pte,
 				  unsigned long address)

-- 
2.55.0


