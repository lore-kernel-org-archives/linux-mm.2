Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63AB7C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D45F6B00CF; Wed, 22 Jul 2026 11:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ABDD6B00D1; Wed, 22 Jul 2026 11:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C1AC6B00D2; Wed, 22 Jul 2026 11:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35EBB6B00CF
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:32:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3999A0155
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:32:01 +0000 (UTC)
X-FDA: 85016803242.08.9C3313A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id D736440011
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:31:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nVelSNf4;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784734319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cIB5IFjA/msY7pe+YjGAvqAGZ97Q2e6OFCnXIp9pmc=;
	b=y/Djxx/SeCjgf0sNKgJyMupjZpqSOUiPlDc+O/5lhvHyHMTlgNQn9qcUG+CH0rnJekGmCC
	cxDPP2XyIACGRf13EopYzZ0ppPRo0jgBHiJ0ctw1wUeIVIW/++5fzS9lzsfF4XprfTfD0I
	yiYviQbpr1VVdxHq3CZ2o326YNzUbwM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nVelSNf4;
	spf=pass (imf17.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784734319;
	b=NDe5ykVahcTV7/Cl23DmkQsPKprRugOtDkcpNEXoAXe8X6emXgPQHBXmYFxxxS4lBFhlL2
	nWNl1rtFSfSaTmBim4sMdw3ssMHIxHEY8zrOJfLiSBrtuK8w6NtrsSGBCL2PTDNmnOr1D5
	rGWV+7qhW5LTlrzfQ+feRSqnsvVcxNk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04DFF168F;
	Wed, 22 Jul 2026 08:31:55 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3E1793F66F;
	Wed, 22 Jul 2026 08:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784734319; bh=BNyk8CyAqeItQBxLsodWIbDNqn/FKn1s1a5JbLMyXg0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=nVelSNf49Z/PL4hzvXi9I+ovhPQfFxpTrcgba4IRwiDsXJb4/lzfB0w9E9AWpTlN+
	 XlypdXX8Tzqi2lH77UMU8VJtU6eJOKMbqc+YbYqWRa5Kx3iuZABWvg+6uw7VwdTRoS
	 ysSsRjUkavfDsjm4KGRTkngrHYS8Lx6cmli2e94c=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 22 Jul 2026 16:30:19 +0100
Subject: [PATCH RFC v2 11/20] riscv: mm: use proper set_pXd() for generic
 compile-time folded patable in vmalloc_fault()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-dummy_ptxp3-v2-11-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3559; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=BNyk8CyAqeItQBxLsodWIbDNqn/FKn1s1a5JbLMyXg0=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqYOIUSdwhibi+Kg+43xsNkAmyGIM2ZSt8npnJG
 thQJjBQU3qJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCamDiFAAKCRBt1cPRWsUx
 M86vDACbfe2rqA5JLqwB1r2aI6NQY8HpJ6AiH6Necl3qXVG5NA8v7qXLIu86OSNbGaWGJ5Oj4xH
 r4xfGOv6rRCSuAPQ0+GAp1RRXiyUpQzL4oh++vcJlHnF3CdNLFnmC9yolfc3CAJ2/4KYO+6yZoi
 V6Oq9MSAmPb6L+hHPZZ1qFldjbj9rCdFcXeUwNZNoFRMVdwRT6Ajsn/Mk9cN38ql69vS6eu3856
 LAiSDPE4Zw0UyIaN/DylptMhvwB7Vo/wjwfvDA5xQxSQTIW59wpMhTQw7YMDjrYsTPv9pmUMrZU
 CLY+c7nUOZRDF0UXenprqUBoCZPbWxF5PqKjxPfqXHnd8tJxjPKZmjJ1hMSUWD3ajoFnwv52pnN
 Dkbzx6nQ5R8jdPmyw9nbrEA82HMKttxQcn+/YrYglMcgE9Bsj+Wh7lurQq5VLQQI4cc4lAyx++0
 TAcQofCfpAZCyOs5StFomNl9gnNc+L3qDSQwYy2ruGceQEd7vKIINnTsQHiC8FLmyYI4Y=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Queue-Id: D736440011
X-Rspam-User: 
X-Stat-Signature: mbqznkpaqysao98fbxq694re5xqkg8hr
X-Rspamd-Server: rspam04
X-HE-Tag: 1784734319-984483
X-HE-Meta: U2FsdGVkX1/I/vQqg+i1GIdPMEfxG++wUmZWtqy3t7GG4gVndh5LNI69DRSm8oWfhOOpFrSlhe/9/YffVJU4VgWpHUPRHORcoegru2+o/NHU0kWVSUy8Hw7Wj7najizFkEHk38qqPjA+xYSzEQrmYDSKzNoKBK1edB2spdRgyn0HrrZPRnBq6cS22Fc2EIVEJsL7sbFp+dtAxvTR2BXPic+vDzHPqu5+t+FWs7g5DM6k31bmCjcU/Yw21MtDMuSb+swxuxWukrqwaji3tRYXG+nJnshHhL3A+1QkPXrlJwfJ773lhYXZeL2JZgdTeYjli5necIjkNr0+ImztDZLbfwQfitZEQOAR5jnqt7ftdsqx8jfRz+h0o8YPjzi0KTCPscVTLqof8iKkp2YFWEIqi0IE+0rYzMWE+tIfhujs9MLeQRxXFlw/wtstlusB8f39EVTyPZpqDR+7CEuk3kRWrpJyOVC7BVpYlORQfKeYFNoSPlAV0SmEmGX0LGkIkFv3xTJpu/FdFdeJSBZ8PNNHNv8XdB8Ur5JC8RPHoUQoYXn02p0LjivII26usYIKBKYzAhvqWRzCNhw36w26hg0vFZNkA22yZcpTnlyzYd1OPnOnUyvYAuWv2dTeFZ/Z3HI2Q3sza/sFhgL1qlAR7hmZZ1vCuWAUXpCatDWCdwc7AP7MIVF1nyUAyNEBLodEZwaDuHeB6ivu+0lB92+/ch0S8YPcTyBx/+YaMvKiTAPwjNfGjTQ907ng5w2dO+6pp9wVmynCCcvI/ZQHcP8vlIRRkSQx1FGWS/7GMzpoIubkF+do0XLiXWb1koCyHAe/1xgzQEnjMJDl3hBYHtoJhQ7aLCfVK94IjeSEVCByhWpLkfAJpq+PPZvf9wuSUBA3GHUPHxTUcObQklUFpV+XHoQkEmD2fCsXtNSYkfWNvbQojMv3RBD9XVdKPM5w89PYfeSw45JeVOVXc3l5SrSafeO
 5EMJsyvH
 xH25w6nI24V7ZCHn0+B80+8rt0MqLe5MGIr9XQ0h4xH2CRwGukSnICJ8xA2VotnNhvKsOaihH4kV2z7yw2g6NUfZek3pNGRX5furdd+MnOslbJsBZJoVKPFHxymOlwTxo/pKKCKs1Dk5m7Xfaj88uXLdGs5EXlgEICJPFoOFNF9sIZkiNQOs+7JTeOlGydM4UvSUwll1zkAvy1yaLhlvCmLL2hLqw2TCwdSZXB/aEy+walvzQobsqX10z5iPxIL5qcW3x9u5AqUs3hv9aXB5Djav07vPaN8zhhSJjI2YqvmMqmfE=
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


