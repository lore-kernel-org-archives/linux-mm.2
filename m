Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 063BE606A8B6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RsFLsyf1
Received: by kanga.kvack.org (Postfix)
	id 4B01E6B00EF; Mon,  2 Nov 2026 06:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411A26B05C8; Mon,  2 Nov 2026 06:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DA106B00EF; Mon,  2 Nov 2026 06:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07B6B6B05C7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95362160C4F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:48 +0000 (UTC)
X-FDA: 85389941616.13.D0F364E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id C577BC0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RsFLsyf1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQeg6N8tF3c2ZKXl0aeVJdIb4rnpiEyWbh6rBzOCUVQ=;
	b=gTE9Pq7cy6hPytV9lCRooWr+83RHCUkG2OZh73HXszLAWoLsLRm7oKXoxuKW+AA6mjBBWE
	bUh9pMhbzkgzW1S2gqIGO0ogzAgqdvxDjx2amR6EJZmxrF7BZZdZNADFGRyUBYy/l9mFnH
	oCdsRgfpTnUyM9+m22ql6f1Y6G+WY1o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RsFLsyf1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618566;
	b=FOFPUu6Bgkh9SaLlsOsC5SvvjfynfqONms45cuJiDeYcPULSDt1oyN3yerqrCfa9jbmJqj
	xHumEKAbauYIKnl226ooY31shkFA6cNDQiPQCmohTrqe6AZU/cLcP+PETwAA5gMeJFDTf8
	HrMjgQfZll0dB1UyBXvDd8Sz2wHS1h8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D37871691;
	Mon,  2 Nov 2026 03:22:42 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C7FCA3F632;
	Mon,  2 Nov 2026 03:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618565; bh=uF4DfWzXa9EkGf1I0Bn2aL3RfBnTbP81TBjbavbJ8QQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RsFLsyf1Ata7d0KOtqzPB7spCrIFhZHbMA0SSIsc3J50ctwBwFtCV0Z2YINZYuYl1
	 axvMSatrzTWBN5HpeQBgg1ibhRlgnvCAtI4rJkD/9rMna30Ury4ZYSO33jBiVAAtlf
	 YwBemrzcCZNlPsQc3YLM94WSry4c46hzaYal8oLs=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:24 +0000
Subject: [PATCH RESEND v2 11/21] riscv: mm: use proper set_pXd() for
 generic compile-time folded patable in vmalloc_fault()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-11-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3753; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=uF4DfWzXa9EkGf1I0Bn2aL3RfBnTbP81TBjbavbJ8QQ=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI0EhHemhFZT76+hkFEHBElBSQOBJI6GP7jl
 ZStUURgzUeJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyNAAKCRBt1cPRWsUx
 M84jC/9S9/aAhhSrKviCbj48B1rRZZrYq4NqcKgkdwxZVfhy+7gtmxs99D6rhsaJdl68LkLYoQ6
 VyH1mb7ItqGWTah++FtNBeXOorhLS2mYEFR/1jKSDb62UfF4DimM3s3wrPH2+G4W8vvlAvA9RE0
 vr0L8mQ6lrGmyqUgbKu8GrSpaYgd9J8fM6EZpFE4KhVkJqxOe3/Mthnaa+nc/wTvPsTP2HZG9aP
 uFtGA4pIhDaYRHFox7AQfkAggATajLnNd/gKUF11QNNhxNNbQAcKOkf8XVo3/CqE5rLVNR7FIN9
 X3jUHSsR4I1853YVKxn9Y6y2Cp9ckjoZXCZL8WtyyAUe+43XVI3EL0dADQQ1EIrjm0Xjd2VgmyC
 nnkYstSWKwOQigSOlu+TvlKk/0yA8Xn9AdXJ5rXSOb6e0D5pYbVuIhtyLEjNUQpYzjDKKfKfoLm
 Vx9lj3xIhnAxthINB3ejIGFbqbn5Os3x2fKnddFMK2B19loCvjy5L66p6hupOcw5yRg5U=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C577BC0002
X-Stat-Signature: ounqxyewd7prq1wa1fkad3b93m8g3szm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793618566-33027
X-HE-Meta: U2FsdGVkX1/IfeF1FP/7WG2IfSx6L9Do3tk/OJwyOrOaQbkVi6CUQ8PtlxiCfXybXWDiHWVPa/sJf+z6WoCcotxVG0buOlSDdxcuKtICDr9gxgTwhFdfFNZ/bvC9XUTS6IelHcYneZuIDSm6cK28b1TqeQq7dmaF1xPA5M4dykGeRGTm7n+5UOmgUoJc2r9Y8hDZdbRk5G+TvbH4fFnnODtfID71vqSXS6rmKFmZ3D7jeKP7FUy9oXoyGqviTXWPqPXpNZpLNC7LNPM7IlLNuhf5g3o5cenynXnXqUfluQ3GECuWPc4AGQL1C6YLYUEqklAjMWegK7iVfaFHWK9ji0HkQ8woEkOkKiRnylZj/tu+xO5tCjVon3nG43047eZQehMwf0V0iuC37H33BhYg4Bb0aSJFUeNveWS5hSUAwkneZeCSx4BFwWF+t5ghCQE2ltFBhCxPDthxk+YAwhpUlM0Q+BIHF/nvIBRdYt7uv9IyaOtffkhkZ1Ixj71mH23jJEmLHv5rmX0ZZqfKCsB1xlhj9xrPMa2eAcGn/nidbQAdcBKrZUgAmR9SvNduiGyBCm5AotxzjvV1D5icgUCxLZHcTelXoIL07cfYnUk3cVOCGUXayE+FbwFu8myy0lQ7AtBI46X+766akgnJluBIvdSZiBjWOCxMmsKhYRILxErqVyEUUU4FyIR355zVT9OUVSXcZ30/A3FW8bH9kD8L3pw3ZtK2a49cOTXfuCdBNS7GZc5jLFWD94YUiwkeaPhD5aM9UAa3268H1CHpL/uN3cmt81ZNe9yu1mChRnRbDPE/Rdce60d9Ijs/kkJGn8YRRP9Twf05KNBHR6reMKPVYlcxXjHNWO3HrlXhatt+F95MWO6uJIGbm4XTycMiYEHQHWH9o7XPA3po8BmswsNiuKlIJOqmSEagI0lYyTQTNw+H9SNlRW7CpO44tfy0N0663A/rdhzDf2crdNBRKda
 62/Wik/C
 kFl8yKebA16aihnVaSADR5/n9pcH+8BqQ3XGZlV+6pD+zg3qa9gYAwvtlC3SJv4ObmaRagOFR5MLZCfk+mUN2vIs5DlsnWovksJKvM+vz7waWF9DF53zCK4slKEBHhwxXNBRIBe0lq3q9woagtqD++wcTJmAuvDwo703JyWzWT1qRx74YRHKR5a1+U/yhu9KseqSKUXG1VFC3lGT6YrMBCnk+oafXuGfNxJ2FSlD4CvCk3YrQ04FbeKzM8rZLW+jsstE/aQit2l8zhNIuANZcuHhW3QnrhkqG5sjfcqMeumkHar4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The behaviour of pXdp_get() will change with generic compile-time folded
page tables, making it invalid to use set_pXd() with the result of
pXdp_get(). Instead, the appropriate first-level set_pXd() must be paired
with the corresponding pXdp_get().

Therefore, call the appropriate set_pXd() for generic compile-time folded
page tables so that vmalloc_fault() continues to handle folded entries
correctly when checking pXd_present().

There should be no functional change.

Since most architectures use a similar pattern to handle vmalloc fault
by syncing the faulted entry, it would be worth cleaning this up by
introducing a common helper in the near future.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/riscv/mm/fault.c | 52 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 04ed6f8acae4f..b2bcaf10d13f1 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -167,14 +167,16 @@ bad_area(struct pt_regs *regs, struct mm_struct *mm, int code,
 
 static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long addr)
 {
-	pgd_t *pgd, *pgd_k;
-	pud_t *pud_k;
-	p4d_t *p4d_k;
-	pmd_t *pmd_k;
-	pte_t *pte_k;
+	pgd_t *pgdp_k, *pgdp, pgd_k;
+	p4d_t *p4dp_k, *p4dp;
+	pud_t *pudp_k, *pudp, pud_k;
+	pmd_t *pmdp_k, *pmdp, pmd_k;
+	pte_t *ptep_k;
 	int index;
 	unsigned long pfn;
 
+	BUILD_BUG_ON(CONFIG_PGTABLE_LEVELS != 5 && CONFIG_PGTABLE_LEVELS != 2);
+
 	/* User mode accesses just cause a SIGSEGV */
 	if (user_mode(regs))
 		return do_trap(regs, SIGSEGV, code, addr);
@@ -189,39 +191,51 @@ static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long a
 	 */
 	index = pgd_index(addr);
 	pfn = csr_read(CSR_SATP) & SATP_PPN;
-	pgd = (pgd_t *)pfn_to_virt(pfn) + index;
-	pgd_k = init_mm.pgd + index;
 
-	if (!pgd_present(pgdp_get(pgd_k))) {
+	pgdp = (pgd_t *)pfn_to_virt(pfn) + index;
+	pgdp_k = init_mm.pgd + index;
+
+	pgd_k = pgdp_get(pgdp_k);
+	if (!pgd_present(pgd_k)) {
 		no_context(regs, addr);
 		return;
 	}
-	set_pgd(pgd, pgdp_get(pgd_k));
+	if (CONFIG_PGTABLE_LEVELS == 5)
+		set_pgd(pgdp, pgd_k);
 
-	p4d_k = p4d_offset(pgd_k, addr);
-	if (!p4d_present(p4dp_get(p4d_k))) {
+	p4dp = p4d_offset(pgdp, addr);
+	p4dp_k = p4d_offset(pgdp_k, addr);
+	if (!p4d_present(p4dp_get(p4dp_k))) {
 		no_context(regs, addr);
 		return;
 	}
 
-	pud_k = pud_offset(p4d_k, addr);
-	if (!pud_present(pudp_get(pud_k))) {
+	pudp = pud_offset(p4dp, addr);
+	pudp_k = pud_offset(p4dp_k, addr);
+
+	pud_k = pudp_get(pudp_k);
+	if (!pud_present(pud_k)) {
 		no_context(regs, addr);
 		return;
 	}
-	if (pud_leaf(pudp_get(pud_k)))
+	if (pud_leaf(pud_k))
 		goto flush_tlb;
 
 	/*
 	 * Since the vmalloc area is global, it is unnecessary
 	 * to copy individual PTEs
 	 */
-	pmd_k = pmd_offset(pud_k, addr);
-	if (!pmd_present(pmdp_get(pmd_k))) {
+	pmdp = pmd_offset(pudp, addr);
+	pmdp_k = pmd_offset(pudp_k, addr);
+
+	pmd_k = pmdp_get(pmdp_k);
+	if (!pmd_present(pmd_k)) {
 		no_context(regs, addr);
 		return;
 	}
-	if (pmd_leaf(pmdp_get(pmd_k)))
+	if (CONFIG_PGTABLE_LEVELS == 2)
+		set_pmd(pmdp, pmd_k);
+	if (pmd_leaf(pmd_k))
 		goto flush_tlb;
 
 	/*
@@ -230,8 +244,8 @@ static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long a
 	 * addresses. If we don't do this, this will just
 	 * silently loop forever.
 	 */
-	pte_k = pte_offset_kernel(pmd_k, addr);
-	if (!pte_present(ptep_get(pte_k))) {
+	ptep_k = pte_offset_kernel(pmdp_k, addr);
+	if (!pte_present(ptep_get(ptep_k))) {
 		no_context(regs, addr);
 		return;
 	}

-- 
2.43.0


