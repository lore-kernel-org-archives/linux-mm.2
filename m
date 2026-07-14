Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC43C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1096B00C7; Tue, 14 Jul 2026 10:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C790E6B00C9; Tue, 14 Jul 2026 10:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F356B00CA; Tue, 14 Jul 2026 10:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90D946B00C7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:06:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23ECF1A03DD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:53 +0000 (UTC)
X-FDA: 84987558306.17.72BFD55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 654571C0014
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:06:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GMJ+Mweg;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784038011;
	b=0qf3GryJeOWg2Jvsq0nEl5UuXg3ewztoPHmSuCVx5r1qHWvWblNBuV+Iipv5p1j9fZNnyv
	xIQvCZkwMUwcQ3Oe/G1EJ+MP9I2XLv1SvonacUGTrz/zS0bV4BjFG1V4zLd5MsQg1WT6rT
	FYjQdZc+ExHqRkuV3/LGDenxqU2E7i0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GMJ+Mweg;
	spf=pass (imf18.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784038011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q94qKUmqqfiS4paWyf1M/XhTiz69R/ac7pRDBBb2HYc=;
	b=XicbWo0KEEQZx5aWa91YP1ZAyE6y3dcz+otL9V4gk1WUxiPNu6PkT5HlK0PKKSX4+oBF6K
	+qutcZjLyiI2Hzscipg5hD9nBREVMY7ZC3THYLHsSJ40v8qZp0I8w+FOU4Ucskx7rK52dD
	8eF3Sb6RwzhmB39ddf+Mwl3fZws3tCE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 648F91C01;
	Tue, 14 Jul 2026 07:06:46 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3991D3F7B4;
	Tue, 14 Jul 2026 07:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038010; bh=xWTuMpf6qcthpUhdZ9Vhm6UlW2cWk5z6914Plajhwho=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=GMJ+Mweg4iK/hY2NAgr6zHJe6LPOAI5rsbTNiAYQyxWefiCu+6VoxAQ21IJMDkVx+
	 ivh2GnjSQemn2gdz2SposUZ6wFQonR0LDcZWwnq1rZX1jAwRhXlTvacd46t1gd3VoM
	 7DeK6ToDs/ry10Z8LOV9mjtgQLtlBMud0j8fDq/U=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:02 +0100
Subject: [PATCH 13/22] mm: account page table pages when allocated
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-13-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2350;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=xWTuMpf6qcthpUhdZ9Vhm6UlW2cWk5z6914Plajhwho=;
 b=Xnk+oBg7ELc/ZeSLJzK7tAUlR2bpnh9Zc229tTiVuKMeFbivMucrP27RTRDStMzPBnxxJrXcn
 geH5EZLthaDBgWisWH5/sH0N2po6PG3n0k30stRCmsudF2ar5ckSV8d
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 654571C0014
X-Stat-Signature: o1x7b5n6td73tdz9kdep6ztrbobq4dds
X-HE-Tag: 1784038011-111189
X-HE-Meta: U2FsdGVkX1/oC5/uMKVtxpgoYDhT4Gc5iLVPqNqUKwAcj/FvmkZ4+DKQovoe7zQA20hhkA3vkxI6VXX3oPsC3k+pFFWxrjnaHqRajB4H/f1PKXpzZDmxrnBzdGGlPGIDBOepqZWNM55ESY/isHqWygYJNL5snnpaNLpjD2gSF6BncU0MPus89sU255RA8WKx/HSUKrr3EVNIAmQ1y+09welP/JYTR6zwWekWR+p6p8rrADHDSd5pdxl9BiPFO0td/fn7+36qejdHQ1WuCLHQ1yFIyzJykxZoI9duajPUGy8N0K9/PJ5J5wCOCuI5Uh0l+SKWm9r0h7Ox9OrB/zuZzFgOcJTkDchhkcdSybnY6o9gja9FrBbw8AoFgVySN3NnyiqIcFuh8/2X6FyEWFHp8acSPMcwzMiZLWzPTICepF4ekjFuztWTKSJgbAMUJBesoAk3nl0rYVigT8Jc9uxHpHSstFu5g/NRAcSXeEegLsA/kvTeFdi16KBdmBh3C5VK2YI1JNeSrS8grXK22HLxRc9Iew1o5oUpES68oGOdTZKFyINZgvklK2/vY9wfCsN2rL9UtiHH7he0fj7XhVdjWUSf8gul0WlcaElmyqfg7+j2pGCPcGwYKl8GU04APd8k9vUidS6py9sFPzcZ0r+lOP57mwizv9ttah9knoxZvBidFbCHPOE6IMGC1DqS8Uwx+7LgLDmdcCv/Fgqxsdf/3bmNPIKzbwmZ4dIHZuHqbnjADT/pXY/Z5l/T7/zk6HrP9bzmewfa3gZYJayHcNPENtFxSW1vML+/C8wPd/m3njR5bhC1jDp2fe6Iht2NXoCUW1KDKGp/e9WM0ugrq/sV8h5Byy9WU54S9Xgvg3Cn8fE6pZ6hWdXwkXEF7taXwryi2bo785AW24wax2kX12qizIvsObpr5O8toKV6Bkc5cq7Io9JqoraFvRawPU5Qs6G2hS9wDUizCB3lM/4J5LL
 b1Wc7AxC
 h9xydSHiGE+X1ZufUoRZB597SunwY2KCuZgpWT/tA6Hh+G9pqdY879n6CHWTHvx4FunfMR1k8Tgh/oqJEprQ4frsej1JoaKigwVOLutqn8Jvg70I9grpjo2TtM7nazhTPkvP+Mcj56OtnMNmV/k35glf+STUiZvkqTyGul0uCU1vEgLm1uUDED5jzG9mmO56m5UQvpxCT6K5M72UxDdzCHbw+QJDpqezCdJKxL8pjZW0xi1H7dK9m3Wj/Sx4gC5WDfm/yI9Mycg+WEFc45l07XDBGJ48EAYTeQjgY+mrj35fyCRPAaQjQMrFoWfyBt07K/ie960WfkdJknuOBSpGzKuKGVQEtQkpJtnoytTbjRJDdEUqEzcRhtgW8UQ5269L5C0kEoJR4TdUXuj6SOeaz7UJ0+lxy0xpOG4wy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As a step towards removing pagetable ctor/dtor calls for kernel
mm's, move the memory accounting from the ctor/dtor to
pagetable_{alloc,free}.

The ctor is normally called after pagetable_alloc() (and dtor before
pagetable_free()) so this patch should have no functional effect in
most cases. Where calls to ctor/dtor are currently missing (e.g.
x86's split_large_page()), this patch should improve the accounting.

This patch is based on Matthew's earlier implementation linked
below, with the difference that when freeing the accounting is
updated in __pagetable_free(), meaning that the update is delayed
until the pages are actually freed in the
CONFIG_ASYNC_KERNEL_PGTABLE_FREE case. This shouldn't matter in
practice.

Suggested-by: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Link: https://lore.kernel.org/r/20251113140448.1814860-3-willy@infradead.org
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/mm.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index b336eb32faa0..361a0d7b74c5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3681,6 +3681,11 @@ static inline struct ptdesc *pagetable_alloc_noprof(gfp_t gfp, unsigned int orde
 {
 	struct page *page = alloc_pages_noprof(gfp | __GFP_COMP, order);
 
+	if (!page)
+		return NULL;
+
+	lruvec_stat_add_folio(page_folio(page), NR_PAGETABLE);
+
 	return page_ptdesc(page);
 }
 #define pagetable_alloc(...)	alloc_hooks(pagetable_alloc_noprof(__VA_ARGS__))
@@ -3689,6 +3694,8 @@ static inline void __pagetable_free(struct ptdesc *pt)
 {
 	struct page *page = ptdesc_page(pt);
 
+	lruvec_stat_sub_folio(page_folio(page), NR_PAGETABLE);
+
 	__free_pages(page, compound_order(page));
 }
 
@@ -3797,7 +3804,6 @@ static inline void __pagetable_ctor(struct ptdesc *ptdesc)
 	struct folio *folio = ptdesc_folio(ptdesc);
 
 	__folio_set_pgtable(folio);
-	lruvec_stat_add_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor(struct ptdesc *ptdesc)
@@ -3806,7 +3812,6 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
 
 	ptlock_free(ptdesc);
 	__folio_clear_pgtable(folio);
-	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
 }
 
 static inline void pagetable_dtor_free(struct ptdesc *ptdesc)

-- 
2.51.2


