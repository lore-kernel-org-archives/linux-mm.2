Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5EA1C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD136B00C9; Tue, 14 Jul 2026 10:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3F76B00CB; Tue, 14 Jul 2026 10:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BBFD6B00CC; Tue, 14 Jul 2026 10:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6371B6B00C9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:07:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF935C03C1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:07:00 +0000 (UTC)
X-FDA: 84987558600.12.26F814A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 174144000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WLxWEHcb;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zQydgPZJ7Jyvl0nKZs4MsunHOywP/c9ek9M9Qkn7Jk=;
	b=d0QuqwC3nqlzFywGOoIs0ZxN18ULnW1SPnWOqF8UC4owjlIGakjp/SdElBAcyNafBQIYs4
	Eb8M4qjAFDfL0k3am6saDi7QgOECATq73ygY6ZEJkL7q2pkKZ3WMbRfwIQvoXx5hTD+zdd
	e6c7MNENfTlx7Iy7j7dEYeC+Vd6hIuY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WLxWEHcb;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038019;
	b=2bt5rwHI7r9rJYkNVSQcBWnTPgDljvKj5O47cMxPLFM61pDSWzB3DeKRh8mR4Z3eywjRc7
	eYl7U43dezA436I8CxrtoQS5GSt6UO6TpLJh0DfsEhy5PODjVpQrPY0qXKJd6suJ53S6uL
	i2IvHKzJ9oiPv8U0+MvRs4p1rXjpWqY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AFDD1C00;
	Tue, 14 Jul 2026 07:06:54 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB3453FBB1;
	Tue, 14 Jul 2026 07:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038018; bh=4PNxqxq/jrUer27xvNkwvequvxQnPhBMXV3o8mC51Ps=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WLxWEHcbiO2GB5LbtNB+92/zwEdWv+8J6pCRQbs3PGmarOdTkL8G1gUMIDPggJIxD
	 N9phhhgOR7QXBCkkB6FWwKpw6kiO73Y49hy9kAZeBD1ExbuR501MLF5gHb3/X1UjRF
	 0YbOoaXts+8XwZ3/78QN/pRZ3IolUppQVMb9mRqM=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:03 +0100
Subject: [PATCH 14/22] mm: set page table page type when allocated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-14-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=3368;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=4PNxqxq/jrUer27xvNkwvequvxQnPhBMXV3o8mC51Ps=;
 b=0VdQOf0nra1WPYggXNBDDOliZvhTj/vQmWZ9BxkvIcGSO9bbshMd8ZPkLRqWmNwzRE1zk4sMb
 RKD72ZNcXaiBd0YaTV+GgCHvQw7s/IzNuDs0JxkPVAN8TuJt7kaNkpn
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 174144000A
X-Stat-Signature: 1ajkjcujk7kzm5xddmzk8izf1fw68ri1
X-HE-Tag: 1784038018-985216
X-HE-Meta: U2FsdGVkX19pL+h9R/nJfdb84aaTQWOHLRTdiObW8WIM3LO/Ium2KlsKbBSDX9eDSXYuEQqxjm1gHfvrkncJLVlUspjJsmVZNTL53pvlqtTxsXIVGfF6sp3l30gBYafChb6iRvSe2/U7dLci8ggKAy2RyOnAAdULmTHjo22UXMzYhu74kAlfeozGLYKN95hib2aNu0YsRkl7uIOv/RwQgFuotpIku4rhQhr2wafjdfvPzGyVDW3YzwnGXm1BCQElgtx+6EWCwlJNoyKmH9XH8wcoVpcVdagiwKJvVln+QTlFyPkEMunWYW/DpBMPfc9VGbFbL9+EPDx20ctCjoKR7o+C4GwvnAXm1PnGfIK/6VIYLPgxKGn1R++fsnFiw8hi3RpzwuIjDkFBosfyix9OKUJY2cAjAuBdf3U9ehWSQWyiowl8ECJb3we5lfDotJgw7vVzPJO2xJpwRzLVQ9wkJ3Tr9PQ9g4yQmBfeShmgu0U9cwRDdyqtcIqZrGn+FOOI7ehYDbkFV8UHxmJKNREOT96Eh25eVd+BleF7VIp53/4j2b4sXirbVJtJe3qDzc4gx3il+fHNFUyl2+qW12mi9e2dHeDWqMEUtCYg4dqEP5UPFHb8K+upfPGNOndsgMpQyATp76fcgdD3HdBV77vNWO7lDRe5vHpKC4Qh3HCpcTz3QkphxoRNev/oB3we9uWVRkY2vHBndnat7w8Rcr0/A9i4bDFnvvMzGQzQCvXwuVkmg79yXWgZczT1pQzgf/q56wwV03Sj2+fotuWSW3F+yMzGT0wOAP8Ou2WjokNfkMfIAZmlblL7BZHF1Rfn4YBsw5lfydxCKXny+t2au/aPWcGczQoUE7S3Nu7cKoUVD6tgJ9OPdZrxre9XlH2WcG0x2PARt3WbKqFx7TB9cBqQwlWL/SVGHozx3KKZAyKwUkHyO9/45i4629+Tbb+zyA39G27urs3yqaHJfdHNfzx
 YCAQTPjE
 BrUq+WjXNIiGAtfktlrw1Sufo1F5W1oCyurcrAns0egqIL6d1+XrgMqxu3gowlBJJ0J2ZVE+w+FX7UTOriKluSlUomdgYw/CFiqSybCXbltzds+CEZmYqjuTr4X7rgQcdGWudk9vW2PtEGuHl/8kxbw6Q2KUNOBwUg2gIO45trtVaBoiR8jLHr1M79J2Pkc9XeqHdjT/bXwLbObBOSYMwvjLeLvfa6ZxzGHlxh4icoPr5ZDcbM938G0ePn4Tjy/e/iiGiphDQIEhUOfhrMKWRI2Tp1v0GDZttWNnfPrnz035HN01WiQdfd2VJmloU2Z92AwmQvnjSgpCivr/uU+VYwM4uhvPlP88Ptt0Vdh0zETKqzf817p6L3VK0Rrt7aWYgQmiPjB1CnBl7umcE/IPHR202wqwJ4iUSTYVI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As a step towards removing pagetable ctor/dtor calls for kernel
mm's, move the page type updates from the ctor/dtor to
pagetable_{alloc,free}.

__pagetable_ctor() is now empty so remove it;
pagetable_{pud,p4d,pgd}_ctor() will be removed at a later stage.

The ctor is normally called after pagetable_alloc() (and dtor before
pagetable_free()) so this patch should have no functional effect in
most cases. Where calls to ctor/dtor are currently missing (e.g.
x86's split_large_page()), this patch will ensure the page type is
set correctly.

This patch is based on Matthew's earlier implementation linked
below, with the difference that when freeing the page type is
cleared in __pagetable_free(), meaning that the update is delayed
until the pages are actually freed in the
CONFIG_ASYNC_KERNEL_PGTABLE_FREE case. This shouldn't matter in
practice.

Suggested-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20251113140448.1814860-4-willy@infradead.org
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm.h | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 361a0d7b74c5..94f0fb1c662a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3684,6 +3684,7 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
 	if (!page)
 		return NULL;
 
+	__folio_set_pgtable(page_folio(page));
 	lruvec_stat_add_folio(page_folio(page), NR_PAGETABLE);
 
 	return page_ptdesc(page);
@@ -3694,6 +3695,7 @@ static inline void __pagetable_free(struct ptdesc *pt)
 {
 	struct page *page = ptdesc_page(pt);
 
+	__folio_clear_pgtable(page_folio(page));
 	lruvec_stat_sub_folio(page_folio(page), NR_PAGETABLE);
 
 	__free_pages(page, compound_order(page));
@@ -3799,19 +3801,9 @@ static inline bool ptlock_init(struct ptdesc *ptdesc) { return true; }
 static inline void ptlock_free(struct ptdesc *ptdesc) {}
 #endif /* defined(CONFIG_SPLIT_PTE_PTLOCKS) */
 
-static inline void __pagetable_ctor(struct ptdesc *ptdesc)
-{
-	struct folio *folio = ptdesc_folio(ptdesc);
-
-	__folio_set_pgtable(folio);
-}
-
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
 {
-	struct folio *folio = ptdesc_folio(ptdesc);
-
 	ptlock_free(ptdesc);
-	__folio_clear_pgtable(folio);
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
@@ -3825,7 +3817,6 @@ static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 {
 	if (!mm_is_kernel(mm) && !ptlock_init(ptdesc))
 		return false;
-	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3917,7 +3908,6 @@ static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 	if (!mm_is_kernel(mm) && !pmd_ptlock_init(ptdesc))
 		return false;
 	ptdesc_pmd_pts_init(ptdesc);
-	__pagetable_ctor(ptdesc);
 	return true;
 }
 
@@ -3942,17 +3932,14 @@ static inline spinlock_t *pud_lock(struct mm_struct *mm, pud_t *pud)
 
 static inline void pagetable_pud_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_p4d_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 static inline void pagetable_pgd_ctor(struct ptdesc *ptdesc)
 {
-	__pagetable_ctor(ptdesc);
 }
 
 extern void __init pagecache_init(void);

-- 
2.51.2


