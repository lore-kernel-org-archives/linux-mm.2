Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D454C624D7
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4A66B00C7; Thu,  3 Sep 2026 06:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58C966B00CA; Thu,  3 Sep 2026 06:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B9A6B00CB; Thu,  3 Sep 2026 06:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20D166B00C7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:31:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A56791A04AE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:46 +0000 (UTC)
X-FDA: 85172085012.01.50147E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0B0358000B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:31:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y8F0VVCc;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJU74baCN+KwgiN86h9H4UkA08hQ8pAQbKi+Rmo0fUM=;
	b=Dnapr+pSirgLegro8kUY4Wd1r9X72bIVqqelgwWxvW0RRUPXEPYzLXLlJBLeVf5KD1Ko8+
	FD1Huc0R1Vi3T50LzLYAtkIiwKwbArIDwWL2yYOR5AaljixU8KQSDEZL7vnte7r6qwjuSx
	j7Qyf1VDfqPPE+VJLB80rZqzGiAANmY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431505;
	b=pipL/0Szs1dPTjrfbIgdxRk2mxn5FImdN7giRgAKgRkCBx2C19XzOOJpEZ8nRPyjgcTy79
	t4zayExmUd0TUaQAjWeV3QTrHUSzaygqgkoYt60YChDm6aDVtJFmoSAdx09dNritorNuxF
	k71PduijSObNKz6QspC1pdVgI2Pf96k=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Y8F0VVCc;
	spf=pass (imf02.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58601165C;
	Thu,  3 Sep 2026 03:31:40 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F0A0D3FA32;
	Thu,  3 Sep 2026 03:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788431504; bh=O0VT6PN+p0N3DcZl+XBb/wJGiZ2FVgkE19Nq8WoZJ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8F0VVCcChrrr0cBI7rnp1ARVvTx43edXevEN/zoEI2YC9Lg5GDUugXXY8YrKUaWq
	 mS2JoUgkevK0SvLmnzRR1s/ldifBo+JMMM6Stx9f8CX/7MBduutu1Yt6rEe96u8Les
	 jesuyKP7q9hVikqD+dnvZSKkHFrkiw4AZKWdyg3U=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	SJ Park <sj@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	ziy@nvidia.com,
	pfalcato@suse.de,
	agordeev@linux.ibm.com,
	ryan.roberts@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-kernel@vger.kernel.org,
	intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-parisc@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	damon@lists.linux.dev
Subject: [PATCH v2 6/8] mm/kasan: use hw_pte_t for the early shadow PTE table
Date: Thu,  3 Sep 2026 11:29:58 +0100
Message-ID: <20260903103002.1091859-7-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903103002.1091859-1-usama.anjum@arm.com>
References: <20260903103002.1091859-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B0358000B
X-Stat-Signature: uxztqoizc8hf9x8h5ekcgpb66an9bb7z
X-HE-Tag: 1788431504-359209
X-HE-Meta: U2FsdGVkX1/UGreDGS9dOf1/xVRNwfy1m7IbktkV6MyTQi1ZABj0KNYbjyGKfLWCPhgfzyefJXnMo2Xr3OX+u0dflsfzNnkDfepWuVa04dkBRB/34DHMEla1JJaICqabC74KlEcV2FHl2GXpA9Ji+3UipOpumuRH6iPCgTQvPpt9X/See64ERNjvfLEX6kthHdK2qywyzUechxMKv7bJAdm+i71PXwuqgOw1fvqqFhYiXK07lPdu4DHL1odyQShq4X/me1eG2nfB8zMTArGKlGV7elmLAgyJ4fZUCk4HYLihamJm9m8hAXtbvi++9NYEdKLA46MS9YNbLNu5fQyB7ye9ytzbqRDV1btSD5lftabSsu2WqWA0yjotKdr76HhhQz2LjB6FqS8OxMP3BVZiO7AJ7ZKbON4sQ/IKf/jQD/Ef/7H6P29CrrBJWjgF+oMewWjFbJigEmLIRo6JpfExyQfkkWyftsOKAiA6AyZJilBOao+pIcAjRDTK33lK4deh3emcEXlsTWROlXb1YdiPcTIakEcxbps0oIh8peibzMqvl2Gv7eOWPBc7sZ/fHl3CHTshThLY5feeL91y/MEQM0VGPNQ5Rl0rIBD9q30+xcKxIkyvwIfqYYva/N21QXH3Fwi9b+P2YLyE4xbPBd2r5soWWEmBPnp8fT/ndwOvm8ME/MV/gklDl3r9PncmHjxmwVmvpUb5rCY4r2Mn9CcZhuPZE48NZ7DrQKabruohwjPsQhZbvyFLmwARlV6AqXCBnSt/iwUlwqGbonLjS9NCg49bT6UIVuFyL1ir1OHcfgCzR/SHUwlYzj9wZJBKZCwCSO56aO5pthFE0Dox6bqgDHsc4fU6FLOhDFoPjd3TNbiJRRBWAnw5S2SZEUcF4xSRvDMoX8oZV6d9+ODyrv7qgpzpNPtHxpFM2pPLMPiSezM0V0wKWb31cLftRsE1YwkAqqTmNAagOIfnfuzzit/
 Sru05zMD
 FRDbNCsUuXxOdawo7xqAdvPm2kN756PgN3GMwXO3pMqBdGwCRN8DgQbHfcV5WIjwmV9ksC9wR3GjEDqFOflpDCIBsCmdzCsjHai0lXUUErdTWvIVL51VoXvSr9urQ2BJnsq6DP2Y1oj5YLFwZWJPq/TQxAcNTYoFurp3OniFkwk2knU2pn4w2eGt311PxGQFxa/lNA+dW+9As+jzt4TwFoeivzwQzoL5mPN+r1EoKQUwhv71n5pXAYRrFIKkPy+1LqCFRe1znqEzJopdOt+d6IyVEPW7lwF/1Z3KF8TJU6jFAnOiSlkc7HbrOX+fmIgD4UFdZ9+vFgBH37dbiJuYHVtGg1E8i8cTqjgpQd2gD+7w3+PI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_early_shadow_pte is a complete PTE table rather than a software
PTE value. Declare and define its elements as hw_pte_t so the object uses
the PTE table storage type.

Read the first element through ptep_get(), which returns the software PTE
value expected by note_page_pte(), instead of accessing hw_pte_t storage
directly. This also uses the accessor selected by the architecture.

No architecture selects ARCH_HAS_HW_PTE_T at this point, so the storage
representation remains unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v1:
- Use software PTE value terminology.

Changes since RFC v1:
- Update the description for the architecture opt-in model.
---
 include/linux/kasan.h | 2 +-
 mm/kasan/init.c       | 2 +-
 mm/ptdump.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index bf233bde68c7e..ff41949c0ac08 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -51,7 +51,7 @@ typedef unsigned int __bitwise kasan_vmalloc_flags_t;
 #endif
 
 extern unsigned char kasan_early_shadow_page[PAGE_SIZE];
-extern pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
+extern hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS];
 extern pmd_t kasan_early_shadow_pmd[MAX_PTRS_PER_PMD];
 extern pud_t kasan_early_shadow_pud[MAX_PTRS_PER_PUD];
 extern p4d_t kasan_early_shadow_p4d[MAX_PTRS_PER_P4D];
diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index 30c5266eaf37e..9bbc2a41d23f0 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -64,7 +64,7 @@ static inline bool kasan_pmd_table(pud_t pud)
 	return false;
 }
 #endif
-pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
+hw_pte_t kasan_early_shadow_pte[MAX_PTRS_PER_PTE + PTE_HWTABLE_PTRS]
 	__bss_pgtbl;
 
 static inline bool kasan_pte_table(pmd_t pmd)
diff --git a/mm/ptdump.c b/mm/ptdump.c
index 376880071ca2a..8f19f20be3c44 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -19,7 +19,7 @@ static inline int note_kasan_page_table(struct mm_walk *walk,
 {
 	struct ptdump_state *st = walk->private;
 
-	st->note_page_pte(st, addr, kasan_early_shadow_pte[0]);
+	st->note_page_pte(st, addr, ptep_get(kasan_early_shadow_pte));
 
 	walk->action = ACTION_CONTINUE;
 
-- 
2.47.3


