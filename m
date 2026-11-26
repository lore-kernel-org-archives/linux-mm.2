Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAD9606A684
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QJo5w1j0
Received: by kanga.kvack.org (Postfix)
	id 4A7306B05E0; Thu, 26 Nov 2026 06:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E8E6B05E1; Thu, 26 Nov 2026 06:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36D6F6B05E2; Thu, 26 Nov 2026 06:18:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7BA86B05E0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:18:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52363A03D3
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:15 +0000 (UTC)
X-FDA: 85477021350.02.94A5438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9BB3D40004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:18:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJo5w1j0;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691893;
	b=RTgez67nqmWIAL1mAiCJM4beY7Q8B/Y5XKFsjmbZQCe0teGq4m4Xh7nz16N3IT+G6wCpVq
	TuJEhig21tqKHXKCKIF78Jm6OQ/MjkTpJW1ABP5ujtShJvaxYcd95ozD/s2b9K94fFXFg9
	v1FI60KY3iQy/GdC3JbosW/6/MZ00fE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfYyn85pUjMYKHSpG7Nmwds+Fo4pM3ejdYfJznX5ccQ=;
	b=oHDV8a7OF0CMxFSRF6M9MlOErkwTwJiVDgaS4uo313Uc5C1vrUqhKwd6Ey15QvVuO06tLt
	86Xob7KB8qFK/asiXGUc+AcosMtEbh+AbfhQOZNQDYoAiHS34CYJl2WhJ12YPX8u/saO1j
	2GRCPATdu7DSmZMx0HiZ2Zr1wY53cvk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QJo5w1j0;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F26CB419AF;
	Thu, 26 Nov 2026 11:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AE21F000EB;
	Thu, 26 Nov 2026 11:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691892;
	bh=nfYyn85pUjMYKHSpG7Nmwds+Fo4pM3ejdYfJznX5ccQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QJo5w1j0YNGG/MVA+7N155ZqRi61HNhq+idbAR7dzgepcTaSSSN+xAPQr/B4U+LMp
	 BLLyXQGrlkuNmkAqtR7dz8Vof5IMsXtBsjhDvz09x6vkSHb44KisyiT2zc91b6fKiF
	 epVtUi6raw9GLDuK3tUSzLuNl8A3gKsBJnlMXAnCd5iSLbGjpGFwIfl2Mdc53Fho3V
	 0IC1AcfgPDA4Pw6cojyD+hOhrBG/fRcdxuqntusHbWpnhLYrajjU5tuNGDAfZv1Wgl
	 TYwLJc1rd7vxclPEfcAiKd46fTu/XAJzcoKbGilWnJ5MpVt4qvcl71XSrrSDsRt/Rs
	 5JDZxjrcdb/1g==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:36 +0200
Subject: [PATCH RFC v2 23/54] x86/mm/pat: allocate the page tables for a
 split by level
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-23-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9BB3D40004
X-Rspam-User:
X-Stat-Signature: u8jpizwsjrwa8ohkt7mg4pgb4enkn7ie
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691893-449606
X-HE-Meta: U2FsdGVkX19s0uV8sB+SMKKSr1VYYXBAxe5/LVj+fri7YLuiFB4qa7Hsx9w7ejpFP15VWUtRvAmlwKSLpfHWN2BN5ipWAoGJFrOwlNdNgWLcvX63mPPpZyU3W6eo0M8oDzHt2xYVZHGCm9fcMHJg8EIRbnpMlm65HxXgZqi2gbhMrmd5JI6u79PTB3htJ36UG6x4UaFjVeGKEF1oE8OMX8LIizebrn8xQd8tyy64JOcVv+p4+v/pcTzLZr807Qu2FfUqZUalpC21Xda4koR00jVn/F2f9VnXYI1km2oH6xZsL+uZCWNWji5Uug/ZJRqLSUGwFcREC7omuQ5hzf/RjHvyma2+5FMesMo4dwN08vrGGHaAuscFMnP+zy4ixUTc0b9h4rCCCU2VHCZKZFn+6z+JBRJ1AUs1sm4NKrd1SMMmL5sepqdDPVc0xQtSzTzIvTsAtaOAT/YBMLmKloAyAWen0HyFQ/zJv+Yr6nw/Lot/QRwbqEFuBBZMsgFtYeRt8at7ck5qapmluGp8VhPD9aYgTMtEuvorF7Y4qI3T5lyX4CNu7jhKdi9N+dWxgimSNNNkPlo9Tws/hfZoq1XcJ/QOLx6FJ7TpKsi0WTtdCrnhaO1ibfrNgz+7STvcbveOicvM9fl6mWbPUZmyuIZ3BF/XQnqmt0Z6+WcHkztjFnuQvo/w7bZT9482JzDk7L+RLViv3Jw/5CbThxo0kBjKvwtMEe5mUOVXP/uiTqNscuBLSUX4XzvAdhB1yvmmusTi36k/suYTaYZUwy7Et2+VGhUK+uxkU6bOdKUn21gkZtfcj5OHvJJb3pjq/8VMPS2pUkg5Z7QUvQ3tC5Atzr3sh7dbCFNf9cPqupllI4lwyUDsY7yyrxZMrfyHXVioHrV23CN+5EaHI2yq4ot1Wr/0vi5M7WOOdnYucVrfnrQQriMvfHhU3a/P8tAnpaMv/LwZprg4c1w/ELs99oTIWA9
 zlsL0Dot
 S+ns4K9SyrWwxe19GwHxSzcjYUzpuY098H0eU5l6JMubM31q70vYPTiop95aMu/O7UQzaHYd2gVtX4tq8resKiVC7ayV371EFxaiicIk7QcWeQEdq2lbqTcGxRoUY/F6zipudKICZczOeyDcTA7OBy+5dyPPmo4YHWoJHMuaz/dndJroFKpi2G0vOIudd4xpJ9noAqHHNgu1Zyb4NwVtVdrnAmitxbIr+qX6GnLaBVTh4DOnoFbN5G9B+X3PRVMWIPhIUrmHxKjBY74wC00v4XF1J9ZyD0Pe9CNEI7dGGKOu7UlEOmZgwG75Hop3MZ11dJcuQ/29L9zEGp8Ww7cRt9FD7mCZeCUEZFAeKtWn0b3In6zq9MmC6ibiUIUUkv5p2n0k6gjkZpNV14Kad9KO365hhdjrkNVUerYWL7ExtEl07Emid+m+/W80waTssY19wr3aEyZ8sdfWKVqqK+joaghBO1J0a1BylOo9yxzv2RjLImcP0vc95QnIZVOd9knLES8J7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

split_large_page() allocates the page table for a split with
pte_alloc_one_kernel() regardless of the level it splits. A PMD table that
replaces a PUD is allocated and announced to paravirt as a PTE table.

While in practice this only matters for the accounting of page table pages,
having proper allocation helpers not only makes that accounting right but
will allow architectures to override page table allocation methods when
core CPA logic moves to the generic code.

Add helpers to allocate and free page tables with the appropriate function:
pte_alloc_one_kernel() for a table that replaces PMD and pmd_alloc_one()
for a table that replaces PUD.

Use paravirt_alloc_pmd() to notify PV guests about the new page table that
replaces a PUD.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index cb503e41340b..0a2d19064f23 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1215,7 +1215,10 @@ __split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf, pte_t *pbase)
 	if (level != PGTABLE_LEVEL_PMD && level != PGTABLE_LEVEL_PUD)
 		return -EINVAL;
 
-	paravirt_alloc_pte(&init_mm, page_to_pfn(base));
+	if (level == PGTABLE_LEVEL_PMD)
+		paravirt_alloc_pte(&init_mm, page_to_pfn(base));
+	else
+		paravirt_alloc_pmd(&init_mm, page_to_pfn(base));
 
 	pfninc = pgtable_level_size(level - 1) >> PAGE_SHIFT;
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc)
@@ -1257,18 +1260,34 @@ __split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf, pte_t *pbase)
 	return 0;
 }
 
+static void *cpa_alloc_pgtable(struct cpa_leaf *leaf)
+{
+	if (leaf->level == PGTABLE_LEVEL_PMD)
+		return pte_alloc_one_kernel(&init_mm);
+
+	return pmd_alloc_one(&init_mm, leaf->addr);
+}
+
+static void cpa_free_pgtable(struct cpa_leaf *leaf, void *table)
+{
+	if (leaf->level == PGTABLE_LEVEL_PMD)
+		pte_free_kernel(&init_mm, table);
+	else
+		pmd_free(&init_mm, table);
+}
+
 static int split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 {
 	unsigned long address = __cpa_addr(cpa, cpa->curpage);
 	pte_t *kpte = leaf->kpte;
 	struct cpa_leaf tmp;
-	pte_t *pte;
+	void *table;
 	int ret = 0;
 
 	spin_unlock(&cpa_lock);
-	pte = pte_alloc_one_kernel(&init_mm);
+	table = cpa_alloc_pgtable(leaf);
 	spin_lock(&cpa_lock);
-	if (!pte)
+	if (!table)
 		return -ENOMEM;
 
 	/*
@@ -1279,14 +1298,14 @@ static int split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 		goto out;
 	*leaf = tmp;
 
-	ret = __split_large_page(cpa, leaf, pte);
+	ret = __split_large_page(cpa, leaf, table);
 	if (ret)
 		goto out;
 
 	return 0;
 
 out:
-	pte_free_kernel(&init_mm, pte);
+	cpa_free_pgtable(leaf, table);
 	return ret;
 }
 

-- 
2.53.0


