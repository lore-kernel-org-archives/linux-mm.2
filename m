Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC34C624D1
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 11:05:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4516B0123; Tue,  1 Sep 2026 07:05:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCB456B0126; Tue,  1 Sep 2026 07:05:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1756B0127; Tue,  1 Sep 2026 07:05:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6D16B0123
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:05:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D12616037C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:05:29 +0000 (UTC)
X-FDA: 85164912378.19.6C896B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8013C180004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:05:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oC+PeNze;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788260727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrlRHDKkKksSse2z7V875Db2PCZ3B/h/JK+Hse17ruk=;
	b=ORN3aojd1/duRUkJNGAPjec+7lDPrQqIiInFH63YfECnqNLgszV74QC8hTLYkNahWPuI3C
	wyT7CJOzagLUzin7g2bgcQ6PRA/XATd/liX3IfJNnb7gcbnln8g0kg7Yn5ZTcVMK2iN8WM
	IJdOLQel9l6ay59PELVfA0zMxMcZpKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788260727;
	b=lN1mrQWdBFNmgXKOhW1IgPd0rLsa0wU4UkSJ1j/EW4u+wjBbmyqXQxiVG4+KVSvdvODMqf
	eU2cHET4YKIRmZSXMdIhNo7CvhAlHDJ+ltpw4X06yyyb6g32xeJdnIYCuUaZWwTetpf3Ms
	taFo8FG4t9clvhQCSmHAgaD511+rBfI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oC+PeNze;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 048CB601DB;
	Tue,  1 Sep 2026 11:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C5E1F00A3D;
	Tue,  1 Sep 2026 11:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788260726;
	bh=qrlRHDKkKksSse2z7V875Db2PCZ3B/h/JK+Hse17ruk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oC+PeNzeXGgygw1GLni0qWUre/UeVngidRRvYApKsIuI5ZQ9UE2DPzmFOWAvU+g+K
	 Tq/3aDUz7ili/2efyU4PlHqc4GfIWiSDKgHgH3le8IEHHhoy/DUc38Lc+0WQpCeGPG
	 rW1c4ZG9bfi4OATQ6DHNR0fyXdkxqGq3QPbClHaCIRwWu+ABXEXLLxICfHrWXARDtb
	 +LUmHZFDUfMdtRqvbUudVUpWM9JR7VimV6S8ZL7eqX/eWlR187yhtTkD07XSGcPsWy
	 gcqOqwvTpNr8iG4jYGW5qsgXdCFo+r0wg0Wc5KcSpJcv5vsQMVQF/SGuJxP5ELbZHT
	 7A80AG8ayckPQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 01 Sep 2026 12:01:21 +0100
Subject: [PATCH 01/12] mm/huge_memory: zap deposited page tables after an
 RCU grace period
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-rcu-pagetable-freeing-v1-1-5456a81c8212@kernel.org>
References: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
In-Reply-To: <20260901-rcu-pagetable-freeing-v1-0-5456a81c8212@kernel.org>
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
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1907; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QsmXD4bhTqKAKkUCvIrmgq1QZ07I5df5Am7bAMtZYGk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKmbXR/NqX0p/yX2JqF0V1HnP3EWDwWHnX5NpPjjHPWl
 V9mHyu7O0pZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCR5pMMf4W3zTCOEpo4p0nf
 ZKn7zKK0mwzx203Lmh+2vpCbIlL5eiUjQ5vI2p2Ln6522hS/bpW4K6e0j0lI49S9FarGj/2PeQg
 u5AUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8013C180004
X-Stat-Signature: jyyfdz7uae94hn3ujqoyhhd1prjis7zo
X-Rspam-User: 
X-HE-Tag: 1788260727-52950
X-HE-Meta: U2FsdGVkX1+ZoKsP+sH4zUEtQg9TMZIMoPpSmKxlrFdClXVupem6Lp9bcBQkl9l92SAGAk/T9jTJvNOkzrzgSKfCx1BwoDySkssvyaZYEjotTtWdS9BgtHG0TsEGYIzQUJLOyW1uL/26TENz6v/y84kZQCe9qbzhCPWq9s42HywVTENISYjNcw+rkUZsZ16LadRCCvFN9/z4ktwKjL9+KLvP7uItBMd698jD/Nmd6TDjkCsGmohia99VFK4BgOeiOf4VwfiL/e207PZi7r3V/BnU8NrFDx06jzJ4zgGcYv3FQGqxku+DpW9bODTsAncDUBi91UUxDeA2gazNIOiyusO4GA5RTV2gSMw3iPSkfcksfz1KGyCm76HD5VqBUPPsjjxzXUmKhGroBBI3uOy6c4xaOluun5CcNdTjd0oas3vYVQNqGs8dDaxMzH6FSd0a3oCZLLal0qZXv72Edye6PMV1NKfz8WwAzdw8v2Yg4moeowYyuKifeshN7XSnRjjKrvNDqkVMjADMCtd+06d20EcfaucjqX55bZc6LbMliWlAga6xx/hob1OmPMrSqzPqFhxZM335X0q1Lx6CJ3r9C1P6RouWmBSWMEDUG5hnlVdaRSV/JnjukwqF/MYV0FHPaddKUQgL9tTbZyDCWl6olEYP6YhB+ppsgER3loRlu0w6u+u6D/USeP9WVSYKLc7gyKDOhAZAA/xSZMxq7MOtX5b9fxu+ujMzbgctjUvitREFec2QBsJ1Dd5iEx3Pk1lHhMd0Odm5JliHVIr3DN0epy3CVTxulXxFe8pqm+l704bwWwyoFYC8qxdjIoayIndBtx0lo+nsbg2CNZG5M/UsPWp2y0/ZV30+HEAQu/MSbOdwL1JUqn3wD08HtojEqijnz3ovytZoZBkCFn9nhhCqoxZIkuTxLaenlR5Ka61kvaALf1IIWVmo+7RIjCt/QiulzOe76JYY2c8p/EJX+S7
 x522KkBA
 H6gZTA+VrmD2eCsnr9bs6I6B0n5hEJo/XqRn79dhGJF7gtC7jtX08e+0CrUyiPZ6OT0Fn/Mj7fo4kyz7nqd+PRHNncH4rTP+aX3/DeQyCPK3sG+FO1S7PgY95ywaoDUn9zpbftuklQ1s1EHNJcMvmg+1VA05nEbJrKnd3Zd6ucK0Im0mtW14qW6NEhM/tvYKRopggR2tAYGQs9Jt/IIUK+/bGerPhMwXc+VOsudgXA8jdkuCRxoLVVzuzW3eGBGgd68+1RyLt4Co0ZvrUF3dDmJAT4UR0f62NQj4hkSseEL+E4znLtVnDxGtypWRqhQpIYHeHrp1T0W19z4DnW61EyEsIuFU4FuMhglliTSD3eKbV0Hk=
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


