Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCFE606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kx1Ab6qc
Received: by kanga.kvack.org (Postfix)
	id A51666B05FC; Thu, 26 Nov 2026 06:20:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28C36B05FD; Thu, 26 Nov 2026 06:20:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917AE6B05FE; Thu, 26 Nov 2026 06:20:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6577E6B05FC
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:20:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D70011A03E8
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:37 +0000 (UTC)
X-FDA: 85477027314.29.4416AC0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3324EC0007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:20:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kx1Ab6qc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795692036;
	b=tva/CpUYiu0yAedHQQLdG/wIYXk7qYIzNosqMAZ4huBqPA2l0NcivcWi8S2pW7mZlGkoRg
	77ZHJuw7uYTTSvjkpIyggJKc39If8Hl21JZJc5XxMhF+dgEM7HcCsirJGBodaW8EUUj904
	TtiUQUxpnsgn4Xrf7MqEgN0PSRsSEdA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795692036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rM4+cSkBP6X510/nTqJRrow0GCDm2EsnlCpLERs/6as=;
	b=8D7T5lBKhDLHxueqm2KFD8TRJJUZXePk342fkXoxi6NBfZGqP9EBTvnMRgLh8kVK0xQKGd
	hfXlPvrpBz+4/qOf00OShY4VN50glhXO1n0as9fPDwUm/MnHICH8aAZnP3Tqw6AnFrq0IO
	q6ZCir+efFPFxVrz9ON2UNbL7Fm959E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kx1Ab6qc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CA26E630FE;
	Thu, 26 Nov 2026 11:20:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E567B1F000C4;
	Thu, 26 Nov 2026 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795692035;
	bh=rM4+cSkBP6X510/nTqJRrow0GCDm2EsnlCpLERs/6as=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kx1Ab6qcUM54KkRHDXzVtjMBXuOGt7snMFzSHdZ1b+HJhSZECrTxp+suhOQIt05g8
	 ulPmTyAEzO4hD9Ksq3FP/lBfAG0GX3OSIuJUGLtsmT/CJyQNAPUaAFCgsP4m+6oFjR
	 Ji37csI6i2qNNeSvLjaR3D5hcSPiZUbUkK6vvXbTtxl1JjVIa4eHvVFsfTlpvVJCrl
	 tA4ItitFRfmXoZROL1Pe+z85u0flpuI5rw+XvECSxELuxJdBKYYJNObc4IuioomJLf
	 xMxc6AEhf6CPOk0lTAC7OJsOyG9QxzRrmH4CZOpr+pFhI9qGci+fadxeBxhmr+g7Ww
	 yG7EIx3Ocf//A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:51 +0200
Subject: [PATCH RFC v2 38/54] mm/pageattr: let a leaf cover a contiguous
 block of entries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-38-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3324EC0007
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9y9wgwh4retn4fsqnmbs4hspzq9w8fhp
X-HE-Tag: 1795692036-723735
X-HE-Meta: U2FsdGVkX1+Y1EJM2mkeV3B2UR3rQ1E6cVgvVyqMGzT/S7/pfx8WB4W6924ufEb5QIEIw05SAvQR0Zv2Pc186TSvUwPrJ6eXp542tcIIjNRfNf0O09iOqTo9avaDJgCMI3p+lmZj/Tr/lSgWnV5PaAeZg2v471Ue+h1ax5lC4yLtM0GoAPA9pkidzDCc6n0leljzAt9ntLgBuuEyeDjQMWZ29Q77z6emTexI499ZXQt2djZZAGudscDPhR+OrxlYuzNp/4ux6S0vFUgYeqwEWYic68UvYq3qgCDuUwZjBHauko2B5jYIeyu64+DMiL5v3bCHQ+VWGpxoHx7hb3WDrYOBPG1czfelIR9uamExxxM+rJTIJYJd6tGXdmi+kkBcuxPadYKx0BuuYAOhvXJI1BHB7qjatZuRsYv6+L9oHgmc1vfdcr6KEeRJGfetarJndeI2YMXquAp7pQFlNbAWU/E8ypSoHCDoufchfUxmI/F7PyOjDWXVL0ScHFAAI3CS3RDvHe5Jdq99yF/2TRPpuJNiXZpMg3AjosqFgtY7eYP12QpUayEuIH4sboYXirhGSiuMgnzPvX1AW5vAcxTFcxQsYsoIshoZHZc5CN2/c1PTD4Hrzxt56fwSFjTMAkbMP6HaoUH34KrYpnUmerPVTazGoHFrGoFXGubwlPWmYWwPsNn3c2PGLLKCiL+QguE3Wix/CWj0o8kxiZdDGbNwym2zqaTNbQee3CTDiJAVNXIMK8D1v4uGUivgAc5HINW06gKGpHTrQxxILQ3oFjtWqe1jtjxExPSXajdRcHFdcKJsfl32O8qzWwvdgN/7Cxfh65SjyGugIHhxeQLD0FhbPuUEiA4F9RDyzD2oshu6CWSsSYBitnD9+5LcIfNZUYxOU1Ra3UneQKmNUpZl6v6yFNA1FsQByzI4WxJg4r4PN9qxT6ZX/6GisT2CqLx+CtSfe3nBbTLk8gCdRHBc7Tp
 uFgjoZav
 08tVVfl7OvLn6uVCUgq3iMTLGXXqm+CHfo/QDTQiBTNTKFLEv0RjP6E6QR//ZCM4VhhHWOLweqljeYCmLso86WEtHgDh4T8FDWeo+EtKOUlgPEbWMcm/N2V0aZK5fW21LiDA4nl9Fr+KkvuZHc4B+PXL2XAxe8AcVJ566r/pgNbPr78vMqNfO6WzSwZ2SKudKy4xGaA5TfGJLyoFdSelmp/2DPLBjDU9858BXohye4V0JXYraj1ytOjsBdZLZPNRjJhWwohjl44za23Ql6RodpWjGjuo6UABCgNaJvT8HlPQ3PQi1kge3wSeHUX4zZbRD2Pqby6aGsDvYhAi+c7KbWMLjVJdDNAFtn+2wYE9hoPOPxSeQV4UzurBuUIv0otBC+T14fUxLN4fD5bvPGooPKiQQ0RrSFrXdR/kuqBw1GSE3A7DAlR5hvvikcYB1LUgxW4VqkhCtHFsmnap0h31a/kMUiKdIZOURFyxw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Some architectures map a naturally aligned range with a block of adjacent
entries that the TLB may cache as a single translation: the 16K, 512K and
8M pages of powerpc 8xx, Svnapot on riscv and the contiguous bit of arm64.

The entries of such a block have to change together, or the block has to be
broken up first, exactly like a large page.

Let arch_cpa_decode_leaf() extend a leaf to the whole block, so that the
core keeps the block when a request covers it entirely and splits it
otherwise.

Breaking up a block only rewrites its entries and it does not need to
allocate new page table page, so the core can call arch_cpa_split_leaf()
without dropping cpa_lock.

Update the CPA statistics so that they count contiguous blocks separately
from large pages and single PTEs.

The block counters stay at zero on architectures without blocks.

There are no users yet. powerpc 8xx, riscv and arm64 will use it when they
switch to the core.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/pageattr.c | 79 ++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 23 deletions(-)

diff --git a/mm/pageattr.c b/mm/pageattr.c
index 852e0989dac9..2f357a8c24d2 100644
--- a/mm/pageattr.c
+++ b/mm/pageattr.c
@@ -94,39 +94,63 @@ void cpa_report_meminfo(struct seq_file *m, unsigned long levels)
 
 #ifdef CONFIG_CPA_STATISTICS
 
-static unsigned long cpa_checked[PGTABLE_LEVEL_NUM];
-static unsigned long cpa_sameprot[PGTABLE_LEVEL_NUM];
-static unsigned long cpa_preserved[PGTABLE_LEVEL_NUM];
+struct cpa_stats {
+	unsigned long	checked;
+	unsigned long	sameprot;
+	unsigned long	preserved;
+};
+
+/* Large pages and contiguous blocks, by the level of their entries */
+static struct cpa_stats cpa_pages[PGTABLE_LEVEL_NUM];
+static struct cpa_stats cpa_blocks[PGTABLE_LEVEL_NUM];
 
-static inline void cpa_inc_pxd_checked(enum pgtable_level level)
+static struct cpa_stats *cpa_leaf_stats(const struct cpa_leaf *leaf)
 {
-	cpa_checked[level]++;
+	if (leaf->size != pgtable_level_size(leaf->level))
+		return &cpa_blocks[leaf->level];
+
+	return &cpa_pages[leaf->level];
+}
+
+static inline void cpa_inc_checked(const struct cpa_leaf *leaf)
+{
+	cpa_leaf_stats(leaf)->checked++;
 }
 
 static inline void cpa_inc_pte_install(void)
 {
-	cpa_checked[PGTABLE_LEVEL_PTE]++;
+	cpa_pages[PGTABLE_LEVEL_PTE].checked++;
 }
 
-static inline void cpa_inc_pxd_sameprot(enum pgtable_level level)
+static inline void cpa_inc_sameprot(const struct cpa_leaf *leaf)
 {
-	cpa_sameprot[level]++;
+	cpa_leaf_stats(leaf)->sameprot++;
 }
 
-static inline void cpa_inc_pxd_preserved(enum pgtable_level level)
+static inline void cpa_inc_preserved(const struct cpa_leaf *leaf)
 {
-	cpa_preserved[level]++;
+	cpa_leaf_stats(leaf)->preserved++;
 }
 
 static void cpastats_show_level(struct seq_file *m, enum pgtable_level level)
 {
+	struct cpa_stats *s = &cpa_pages[level];
 	char sz[20];
 
 	cpa_size_str(level, sz, sizeof(sz));
-	seq_printf(m, "%s pages checked:     %16lu\n", sz, cpa_checked[level]);
-	seq_printf(m, "%s pages sameprot:    %16lu\n", sz, cpa_sameprot[level]);
-	seq_printf(m, "%s pages preserved:   %16lu\n", sz,
-		   cpa_preserved[level]);
+	seq_printf(m, "%s pages checked:     %16lu\n", sz, s->checked);
+	seq_printf(m, "%s pages sameprot:    %16lu\n", sz, s->sameprot);
+	seq_printf(m, "%s pages preserved:   %16lu\n", sz, s->preserved);
+}
+
+static void cpastats_show_blocks(struct seq_file *m, enum pgtable_level level)
+{
+	const char *name = pgtable_level_to_str(level);
+	struct cpa_stats *s = &cpa_blocks[level];
+
+	seq_printf(m, "%s blocks checked:   %16lu\n", name, s->checked);
+	seq_printf(m, "%s blocks sameprot:  %16lu\n", name, s->sameprot);
+	seq_printf(m, "%s blocks preserved: %16lu\n", name, s->preserved);
 }
 
 static int cpastats_show(struct seq_file *m, void *p)
@@ -137,7 +161,9 @@ static int cpastats_show(struct seq_file *m, void *p)
 	cpastats_show_level(m, PGTABLE_LEVEL_PMD);
 	seq_printf(m, "%s pages set-checked: %16lu\n",
 		   cpa_size_str(PGTABLE_LEVEL_PTE, sz, sizeof(sz)),
-		   cpa_checked[PGTABLE_LEVEL_PTE]);
+		   cpa_pages[PGTABLE_LEVEL_PTE].checked);
+	cpastats_show_blocks(m, PGTABLE_LEVEL_PMD);
+	cpastats_show_blocks(m, PGTABLE_LEVEL_PTE);
 	return 0;
 }
 
@@ -160,10 +186,10 @@ static int __init cpa_stats_init(void)
 }
 late_initcall(cpa_stats_init);
 #else
-static inline void cpa_inc_pxd_checked(enum pgtable_level level) { }
+static inline void cpa_inc_checked(const struct cpa_leaf *leaf) { }
 static inline void cpa_inc_pte_install(void) { }
-static inline void cpa_inc_pxd_sameprot(enum pgtable_level level) { }
-static inline void cpa_inc_pxd_preserved(enum pgtable_level level) { }
+static inline void cpa_inc_sameprot(const struct cpa_leaf *leaf) { }
+static inline void cpa_inc_preserved(const struct cpa_leaf *leaf) { }
 #endif
 
 static pte_t *cpa_lookup_in_pgd(pgd_t *pgdp, unsigned long address,
@@ -253,10 +279,10 @@ static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 	if (cpa->flags & CPA_REQ_SPLIT)
 		return 1;
 
-	if (level != PGTABLE_LEVEL_PMD && level != PGTABLE_LEVEL_PUD)
+	if (level > PGTABLE_LEVEL_PUD)
 		return -EINVAL;
 
-	cpa_inc_pxd_checked(level);
+	cpa_inc_checked(leaf);
 
 	/*
 	 * Calculate the number of pages, which fit into this large
@@ -284,7 +310,7 @@ static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 	 * range.
 	 */
 	if (pgprot_val(req_prot) == pgprot_val(old_prot)) {
-		cpa_inc_pxd_sameprot(level);
+		cpa_inc_sameprot(leaf);
 		return 0;
 	}
 
@@ -307,7 +333,7 @@ static int should_split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 	/* All checks passed. Update the large page mapping. */
 	arch_cpa_modify_leaf(leaf, new_prot);
 	cpa->state |= CPA_ST_FLUSHTLB;
-	cpa_inc_pxd_preserved(level);
+	cpa_inc_preserved(leaf);
 	return 0;
 }
 
@@ -319,6 +345,13 @@ static int split_large_page(struct cpa_data *cpa, struct cpa_leaf *leaf)
 	void *table;
 	int ret = 0;
 
+	/*
+	 * A block of entries is broken up in place, without a page table and
+	 * without dropping cpa_lock.
+	 */
+	if (leaf->size != pgtable_level_size(leaf->level))
+		return arch_cpa_split_leaf(cpa, leaf, NULL);
+
 	spin_unlock(&cpa_lock);
 	table = arch_cpa_alloc_pgtable(leaf);
 	spin_lock(&cpa_lock);
@@ -389,7 +422,7 @@ static int __change_page_attr(struct cpa_data *cpa)
 	if (!cpa_lookup(cpa, address, &leaf))
 		return arch_cpa_process_fault(cpa);
 
-	if (leaf.level == PGTABLE_LEVEL_PTE) {
+	if (leaf.size == PAGE_SIZE) {
 		pgprot_t new_prot;
 		unsigned long pfn = leaf.pfn;
 

-- 
2.53.0


