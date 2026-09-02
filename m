Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8CDC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 268F76B00AD; Wed,  2 Sep 2026 07:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239BC6B00B0; Wed,  2 Sep 2026 07:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128916B00B2; Wed,  2 Sep 2026 07:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA7DD6B00AD
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 645FE801A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:01 +0000 (UTC)
X-FDA: 85168673562.28.7F98311
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 913C4140004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:57:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kcjO6Z2I;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MFL3m+II3S2tPQtHE3+cXmQryDLkT1AODnKmXYgXOco=;
	b=dLWje7CW9PWx6uG5BVS9/NtcV9o9OTbwenlu8Ehmg9dt5soQ1hQrhc6TpUqo3Y4HqilyTe
	mpm4Bh8psjJDMCJPN8oCAbDnymQP3rF4I7ZCfUD9uXIAdYi61OEnk36k9FwZsE6TfWkYaI
	iMxvgZc1rs40IB0ckGUeg+E1NLxpX1g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350279;
	b=wBC012uu8fOFdw1crlVI4YJUmnsMSlmxTeI9uN7/73W3N57UFFzYDp8IZBPRrVnUVOO+3p
	RFtSRdv8qwjH9JbL2dkBtjRQ4FxhTKoiuDIiWMTVD0NUY8cJL9KrZy/1YjUCtX0QYZXxln
	qoYSo3dJTOavitn5Vq+DCCv2DFxzTJk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=kcjO6Z2I;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E4D701596;
	Wed,  2 Sep 2026 04:57:54 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6E5E03F85F;
	Wed,  2 Sep 2026 04:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350278; bh=4LWJfJy7TXbmK1jsHOsA5Cduj3axDboEq3jqgZW+XAM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=kcjO6Z2IEoTe/HyINyieKcV31YZFObovt6HdiGaqWuW8ZFX7j2uXePqstJAJ99uKb
	 65hAIv43SEHY/faHxusjKT1F3tsvqV66HOvX0rVyxaasSz3/aQRSlfH/T7awUquqR2
	 UovQhY1P/4XbROdJyLhGX7IlClJH1lW4wzwNmnKQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:13 +0100
Subject: [PATCH RFC v3 11/21] riscv: mm: use proper set_pXd() for generic
 compile-time folded patable in vmalloc_fault()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-11-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3751; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=4LWJfJy7TXbmK1jsHOsA5Cduj3axDboEq3jqgZW+XAM=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7nqSdfc5oy61STbn1WY9yKrWaY8VpB7vl67
 v+mYyAbeZGJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO5wAKCRBt1cPRWsUx
 M35UC/wJv1BxAxmXQKBVO6K1qHRsfb1nV3J7fTF8qNKwMg+RaCxkXa6csFpbIUc36gvQMQq8YeQ
 PDxFwiPtvtA6OCNGMx4PGsMAx495OcVql9U4fO5+2NuQm15dBHbmLhoOC2kJH0iilzMLNMPTHPk
 g1jh5DN5mbWld9jH2zFpkG3XXueLvpIMXe0iddqPx+NUumFjT9GwvQxYJ541R4RjD0keQbig1R4
 sQwqj1nogZmGMlz7UbmKaPX9myTkU5+9FW4cIN78ezC/OpwfiYyFni2wksiorInu08xiMjs6FTs
 1xHjKNQZSN4zPgbVQISGZzxGFOIKpiajqZghEEkw9HrDuuoxOd2G/jRFRJfgeeWPoZOlUMzkqRE
 Ry98F5Ik7gB+HDOzXojgW1cVUok7mARjiPaKZQug4YCzLKfWR3DaUPictbObWi3o/NCHvlluiag
 I86YMTXiT04Z+KJMf+cILYHf9Tiql0/u+hGNvyBCe9oySTMr3kkSL2OBtFoNAOxkdhJyI=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: nukxtzo6p6uzy843yoaostnunxsrdgms
X-Rspamd-Queue-Id: 913C4140004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788350279-300885
X-HE-Meta: U2FsdGVkX1+sYIlM6qLxlP/e/hCDIPfouF9zTHY0hzw/xNzxFbgBuUHbGv0bLZlfVzkw3Urlh5xwQuo+9mlAX8dh7Ip8qUQK9Z6sd/AQBLKryWUwhBMubzGqaSBb9fxWmFXKtvWCDdyqwM24sv4GQNrzH/B0cP+uC5/gV3yS7N9EjNh0Shx6qd2mNBmJ384qgHsBApCoyymbew4Pv/JG1hRFNAUey5ZcnI0hTgxrDS4sIYD4S51jQp1JoYqbBy35OFVRhtCZMnWxJmwt3Rpwh04xgJ9hdbPrz+L0kJw+T0dotIw4i0ONpE3bp/+diCYUF3s7ZNERNWTrfATitzmqS8sPRn8kvJkuXILIqFrk9T+njvSVACQPQW//Nt4O7zCFQ29UQ/M4llvTsKE57WhPQVXslO9TpWJRUlJL00lRjtEJ+K7Imnb1gcU4tBTEztRCQ4cX0zelQ/QrTbLitL2w1HsC+AwKiDlyitr2oPuge6ds7NH9anA0bBdKkP1WKvQFupsUYa+NRRB2r84fAa1QjflmrnQXuqzxEQPE1FNRlGTkfBbMIgh1e7L5E0UQZSEcADPRegacFlMMSgC0w1SYYPEeYzMy3K9ETJTrwdhObam46gvyD8mWs89dgRvKJ7kJST978oQnqYWKqR9iq/7SmGYbhGRLGci17SEmNIV9YcEpNi5Y3hjsSmt8eLguT+f2Nh+KRpQzSxerzL2y6ZpUTvLjaybc3sckzs0/tNnZ3rRuGIwj7SAnZPMvH6tu/PqoaB63E2hWmj/fIJfDDrf9hRuH+7fmvjGoZMtketZe44NIDUAio/M/Posvh16rANHaw1qmkeJQG1rF/qtW1BXa+G3jdodk+z7aqDF2S9jXVFurjFSR4sNpO7Jn6n6RawZlXwcRBRvxCcn78+rYP6sVGpgHDr0lGsbsCOZygA1gmAu9NB/Z0Rltafl55BEKYzf4Q/sJG7WGvkDtUZyc1XF
 DXlOvI5I
 tfhbyP4JlmuArilxqQJILtA+oWngybXgSfVixfmhGRG6CuRjvUwqgHZ5CHKZ1Q/JxKM5k5xIkTKc5lq3qsGUP0kH4OefvNKhVkMez59hom3fzaEKWyUw+cD+r/2eJrJrFC5kiBfy7g4Ar/4y4kxRsdogzpEJnfKf7uduKpKG6CmmT9rjfbaMd+5JMaECTd3sxzgjt0Q0nrx89Gg3KvehWB22GwcBwUvESZzgRJpjybD8XXWnGxbP6yD5yYcvKVBri2/yub2yniRpWdAb0x3ax/bjuVQmGITFgqxloKQiI1GP4uJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 04ed6f8acae4..b2bcaf10d13f 100644
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


