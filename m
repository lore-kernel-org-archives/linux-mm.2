Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49E92C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 466116B00CF; Mon, 21 Sep 2026 06:57:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416086B00F3; Mon, 21 Sep 2026 06:57:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305AA6B00F4; Mon, 21 Sep 2026 06:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED9D86B00CF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:57:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73B9F40140
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:54 +0000 (UTC)
X-FDA: 85237469268.20.BC1496D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9AA961A0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:57:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b2oxv8G3;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988272;
	b=8FhA473HpRkYGd0tOzMmUjg9VVFF8wteR2bwEk5WEBkhtZQ4XQD8VFEQgMFTsRL1mw3/fS
	Eo/AJTtSNXkbEq6IDpMUmA4i1LdkNzE38AHpNQPmuGsN3HiE9fuVlAwj1EI4axxzuGBPEW
	S+XWEpEtrG3eVf7vf/qgId/yobAFI6Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=b2oxv8G3;
	spf=pass (imf19.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQeg6N8tF3c2ZKXl0aeVJdIb4rnpiEyWbh6rBzOCUVQ=;
	b=3HmlgO0PaUM4Vh7e+D0HdFIoiO3YyjnU3nBxaTl4g2uTg1BqKF7n1/qsOCE1w66GlYP61x
	6fCqelMS7/49SbI81C3boKBeQMOlJEM7nCQWGseMFmstSSr2NgyoYtGPq+rHFd1kmo0Gqv
	KpxWOeu0ukQwwRNK1Z1xtJDPrXWb9xc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 589AC1CE0;
	Mon, 21 Sep 2026 03:57:48 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98F113F9AB;
	Mon, 21 Sep 2026 03:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988271; bh=uF4DfWzXa9EkGf1I0Bn2aL3RfBnTbP81TBjbavbJ8QQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=b2oxv8G3acXR+b4U8Ke9KSVZQ8NqKzHIB8Xl/ycl/nGOLEQlcX18PIjAeIg7B3tpb
	 7HmCy4J3ydk3qZfbtrFLpV4tABhoN+2/B17S+yQ+WsYgwEYTPLCQRkt0ZeSX/hLPMx
	 Aa+nRIFl1reImGlNGptnuq9oq9dvqnppsyrc+NyE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:33 +0100
Subject: [PATCH 11/21] riscv: mm: use proper set_pXd() for generic
 compile-time folded patable in vmalloc_fault()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-11-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
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
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1QAg31Sog0FCjc3kuChuSeE5nwlfWLMD4sT
 IBC+fegfX2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUAAKCRBt1cPRWsUx
 Mx8TDACfGiY1tFbMNuqJzhqG74lnH8gGDp7+4K0KfmvivFAxuHooIWaalWIlCiXzXZGwXVbHHwy
 EPxRgkJ1uw1jlH3gDOGxNETf15cT+KdPWxc2IPcZjimn44GpN/tHq3ie/ILysREci576iJCfLl4
 hZhn/31gf80m5wAoruCFpkdOoDK9vI2gDH1iAE7dcktlPtXovnfLAUzOVfzwDk1sJuYI3BsByOn
 l1dM0H6rX2RhzKIfJT02RA3stLjqjS4aqMUOuIEyQ7uCm/vePyl/toLHSfNlXeAFt+vkDA1BaNk
 G2Mqub8YtbPcYMJILsZALUoZGulrUViemuEn1MQuFSk3xeW6LvdIps5z0pgD/hyMDOQMsf9zlaq
 43upc2P7Di2WqF1BalL1zetYzreAC4iO8Ass4iBh3zl5KSk4v4cizRvztC13VZGm8bZN2nr/A/H
 LW9L0Tf5m0dkB2RXOoknui/VOBmrN6PvMrEVqP3go7fwbJPESPNAgPLiosUQHnJ16thBo=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9AA961A0003
X-Rspam-User: 
X-Stat-Signature: ezab56p464xp5qbast3tsybunua648fg
X-HE-Tag: 1789988272-443498
X-HE-Meta: U2FsdGVkX18L2p8BZDMVVpeEe/a45rhEI6Zwwkc8h7KzhJ9prXgqWWr5bjs8IEpolVMjQpWOGYSUqCiAyVMqUqZ6Ixy7jsEQsOWh4eD1odKqo30VncJfCEkvCNieLPAI5hVDSAa9Li+oCfBujYbpIEvOaxOZCd4tAMu12KactHAkXZ05aSmShbDKHeP96HZb7RRPmGONaNbBHs8h85RB0tV3qmK1v2YFgyRV3IVcacH2feeQr3H6V5QX65n1eIZDHQtu7pG6jPO4WX5w9N8tPPB6XqcLHUh47PYHaiMbMLImLT+uwKyYtx9mTNXruPkU4uUdjKcMaX2gtN5HtseIziPiDnxp2S6OXZcVo5+Mr6HfEqLIFQQQ3XmmH9sMVmLYn6lYPPFllYXWWBTCuFdg/bRylTsa7aJdfGViWk/HqMrMbxbiblnCOVXwxx6yISeFEBhmmOL2f7yl68NThS60FL1GIKOEvLnpxuwnHJSD/D4WWZf9Xqz4CZWEHrQIjma0qprU5SY6c1QwLkszfjEAsxuw4j2AgVKb6/bVcsw4xvF1RM1KhZV6foLbz/nqmQSXkZZy93yoMnXum3jTdIdAZVt+GETzO+ZjPz1xpekVJKQSiXW+BnUXuJ7y9PunvA+WIkiNIy6DbKZ7WgcgK/VsoGpXY2W00Wd9zLQ9kaSvbpkhu65hkm9HUd3WhP3a52B1KrTt/gp/gFUl0yqv8NolyxMYdmZElKtC72rdb1tB/YIUqaSHQm005ATKHTAcV8a4gOVCaNI0mtlKxXPu9BQqdOZMRqru1g5Bu5Nj4VMPGLBT5jSUlwCvGxgHEfNPtwNeLJSHm4OXJ6DIugH8IXcsyzlXS+OpArlYKI+gByiHJsEbs8AiLo4kLqQj3ntylH6N5BhbWZYvh7jvSq0ZixJ9j2j/UMi6vcy/7qiuRIzKTpKPEr9paMrSyPAFeE1mSAwtLeCcEoUM2K1uiwPgYEH
 fQnWy+Mn
 0/R1S0HhhyZxD4zebtoYfvBSMl7Oivabl/+tVzgnUjhQNxXyPJ/ALHL7vBftGl8xvK2rUzcv8zqqgnq13+dlztEtS2LHSzHsj5JZT1Rr5F/dD7G2flSmxcaa558KdfjDGuK0Z2f6XPjkZ0/bKEraxAc31iFmLeygqL3+1vaZ0m8oxAPu3orDC+wKNMoqTyxF+Xi+0qUXmSE47A8jDDJSdtVUJgAqEgaRKCRq8ojJgEFKnHcJqJbMnu4oA2+yeD06AXPtX4S7FAUjWWS29APNrMjdgw/D1yd6Iix5QUp9QZ1CRjls=
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


