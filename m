Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D70C88E5A
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AF3B6B008C; Fri, 11 Sep 2026 15:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4603D6B0095; Fri, 11 Sep 2026 15:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351336B0096; Fri, 11 Sep 2026 15:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10DFC6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:38:22 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C1841A0196
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:38:21 +0000 (UTC)
X-FDA: 85202492802.05.96BF038
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B68ED40008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:38:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqjfjDf1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EqjfjDf1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155499;
	b=yxQD5x56cIuZ0mWihT0MuH4tqcol0tRLnzke+JUh8/hyf2goeE7v7U7EKlfLuIhmwCNij4
	vrYp3e40vxvoKm80bDwRPVwgulFzNyoWSZg5O596L0E/GS2b6UwtTjBcZo4ak7d8YKjB5X
	ILE+x9NUzYlFh+g6Bo6VSPKAgcQkyBY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tvUeWOslwBY4cQSIpSeXPe//if7BG6WqShXhm+v9yeA=;
	b=gQZFA6Kt4ym+yo+nu9/n16xEdg8DdtMt1QGGxezdTg64U6rbXqDI456wy/ftVecM6TqucV
	KlnuiRjXBAQJpFY7cMqqpB4qs0h9IDyYjDsqXr9FqvGWjKxI5IsKb5bNGTlld29rSD0Un5
	oLWc0+gT2iktkCP5zRMfJDOuQq/5tUI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50FD460235;
	Fri, 11 Sep 2026 19:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B821F00898;
	Fri, 11 Sep 2026 19:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155499;
	bh=tvUeWOslwBY4cQSIpSeXPe//if7BG6WqShXhm+v9yeA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EqjfjDf1gmgeoQ6KFnLRIpL/FQ72wHxtrGuPwY8ocWmgpqtGL3bkjU+CQiX6YkBL3
	 aThe6AJsNuEVpKJsvHtwNULbix3u8B/oOusAIOZ2wn2kZ8F3dAssn62nNJbH5CGn2C
	 HbKbJV75ZEbwAgEz8e+Mf5BYAolRYHp5dkMQP1rVjUWBnkJ7uDPrMoE+qheb3IN5ki
	 QOohWbeDcHeGAUqMnPcyj6aFaWp8wbWdCY0XfhMH1pn4ZN4mR5K4b6PzP8FH5Ni/6R
	 ZSNeUBXiUEXA6tntnPtTYT5jD1ZQ/C6YPpFC2ij6F+lOvQHUkLN76ownVowHon7qYQ
	 mje1nqvk4V7iA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 11 Sep 2026 20:36:48 +0100
Subject: [PATCH v3 01/12] mm/huge_memory: zap deposited page tables after
 an RCU grace period
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-rcu-pagetable-freeing-v3-1-7b8c86103821@kernel.org>
References: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
In-Reply-To: <20260911-rcu-pagetable-freeing-v3-0-7b8c86103821@kernel.org>
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
 Stafford Horne <shorne@gmail.com>, 
 Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
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
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
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
 Qi Zheng <qi.zheng@linux.dev>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1958; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/oVUJMuXZzN2Mln0svsuYp5CjufCOLvsQN8v4EfUuTg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKWRDRyXmYNtf+xLTR+69JnAr2pjX8d7SR//Kp5I9WVs
 /j5l0PTOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRtK2MDL++T5Wwlbo4X2av
 hTuf1IKihjWPrLU6DldXzWh1ez2Tv4vhf4TPjX83ejMZY/9xnNtW1bNuPVvaooT6yUys4tWzV17
 PYQQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: B68ED40008
X-Stat-Signature: x9j9ki4q8bhoe76r74fof49xr4bybfwm
X-Rspamd-Server: rspam01
X-HE-Tag: 1789155499-195033
X-HE-Meta: U2FsdGVkX1/TbXnX270Xl/ZJhPjw0yfE245Kcx+DFRpO4U5j6LeVoRYUTIe+V1Yi7Klp0a68q7Ml88x7i3Lu/PKnajhHZYYQR9KwCISANyFj5KugdKnSw+n2SVRrkdhjMZvUQzQrzmjSSvR4NKNWm2cH9oLaHf4gmvNTvj7rc+TAocoQLJR0SEWaBKIUWrz31WUS0+HYX5f+WpHodmKUGQuwS9g1VAITJqFzRGkaSSCUe5cwuMUtOtWgkft60000U3rW6y8OLt/8BMrK3ftMRFXfvs946UR9yl0orJ68GIVwuJHvKgoBnhpew8fslFqoMf9sqvgK6HtoNmSDo7i9W4i9x+luoQRhHPLfHCLvSFC0g9CdJ7y1UPHbTd1y2a1cD/fl7Adsd5IsjZ3gdp8FQBGEKqMZjKi+QXdBMbeGxx+/hVLo6OSlirqBYtAGrj0mzAiiGPds6F6/f/RQrxRBSb9CqeJG/H1SnLBLbB6hrWuihB0msLABG0Q5bQrspfqq+TPSmQYzVNZ8G5GGCj93CvZjFgKuuC7ZvYmMiP6MVSPcC/1ndmeoJTEfTV98vd79MQ3exkp/yG4KbHB9CrydM36hPkksTbnSS6xt3gUowgqN82y1c7QDD7046nTK+9QvD0RfmRF2CtwtF4JEOl/ZTd0UMT93UTqas/52rsdm5vO8Itzv2UDASzKdmA4PWQDDg81tqkiw9sdYJCyWm0nHEWbeSUyIsZBFNMZL+3teOsMvSsl/bJnSvldWJ8qoUtfQQphxPXz2ReWIAUnSD1W0Kq7pRkHiORMW9iuZhuHCCP1QVo3MkxfLVIf+ei0v8Zj3wJZSYghUgOVLn3bo8glxRGriKnPU7r4jEPH5jUrWzVN3t9dQe/IhZSPc7HpLuuNEY+Acyw6Isn1UZWG0hlHuV6PSk1eRgVJ8g3GSCDX92ghh9slzhKC7s0Gn1D5UlKK0mIOCSEqixgVktKe8AjQ
 Dnrjues3
 KcGnZJAGda3YU9P5ZuGd7mMMPwBKnGjqKJDI01LH5+V8hKWIIKZM/UJrhjZXZTddRkpH3n4SC5uDUPU3rBVPWUQO4wzjGhLO8VdIAoRQo68MdHLiDSrDJkdQ/BqaxMFQZ5Qj1lPZz11LI+bugCl6VDB/4A0rZfhl46P7564EUn1zLWPxVBQc0/VdSxM0CoPsp4ZSWuFGOHWXDT/TLexCRs1Ip7bn1Gek9xLGRgPlr5DyxU9rbd4RPjCyFatqTbv4NRLsadNbROqYlkdPtwKO3OPLXtUAICDVBzYejeRZ0+WUjRRaEvxomigx68nDkh4MHUZioYkw0b7azP/DFLjvX2i3pZRfMjDOukr8k3tsmN9Tm3q0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an anonymous mapping is collapsed for THP, a PTE page table is
'deposited' with the installed PMD entry.

This is done in order that a split can be performed without needing to
allocate additional memory.

The freeing occurs in zap_deposited_table() and is done directly without
any delay via pte_free().

This is currently not a problem as existing page table walks are protected
by the mmap or anon rmap lock.

However this becomes problematic in a future where RCU-only page table
walkers exist, as there is nothing to prevent a page table walker that
started the walk prior to collapse having its PTE table freed underneath
it.

Commit 13cf577e6b66 ("mm/pgtable: add pte_free_defer() for pgtable as
page") already provides us the mechanism by which to solve this -
pte_free_defer().

Therefore, as a prerequisite to a future commit which will permit fully RCU
page table walks, update zap_deposited_table() to use pte_free_defer()
rather than pte_free().

Note that the IPI sync in collapse_huge_page() is still required to ensure
refcount correctness against a GUP-fast operation.

This is because GUP-fast might increment refcount, but
__collapse_huge_page_isolate() determines whether it is safe to proceed by
checking folio_ref_count() against folio_expected_ref_count(), so the two
must be mutually excluded.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 54494c3fa983..505f7b62ff28 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2476,7 +2476,7 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
 	pgtable_t pgtable;
 
 	pgtable = pgtable_trans_huge_withdraw(mm, pmd);
-	pte_free(mm, pgtable);
+	pte_free_defer(mm, pgtable);
 	mm_dec_nr_ptes(mm);
 }
 

-- 
2.55.0


