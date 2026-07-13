Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CCBEC44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B43226B010A; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A08D16B010B; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87FD06B010D; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 344976B010A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07F8C168BA1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:05 +0000 (UTC)
X-FDA: 84983912370.26.2EAB77C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4391040014
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UsEqtk+c;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951203;
	b=kI0z1rLZlCpnhQWkJmuAjmJiBsjjwhG1lRYgZ8MBetChI22GcSxtM3p60eKP43EXBlSu3n
	o63z1npQJ6XZbgjL0xRewG45r5c6Ip3CAhftPrZKusOfCtaUNA+KZDxBgi2vvijiTb0B9x
	dyQv7U9R0/YHToJxrieyiRJcYNJeO3c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UsEqtk+c;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NDWRchD8KH2V8mQ3WY1eSB0xORjOK5H1qArLOwkvuxQ=;
	b=iJRV6EZCk8KJ1HFwW0in3pW03cnnQ7FViWQ/WwGfS5OcAM7aFVKTpeMSsJyJKESNpnVZu6
	pI8HgmMSzujUBvZ2FgMB7RDJVkvi+gZAEwmUqJNS8dxADpSMlp5xijuhpy0qPPlcXH+bzU
	XWaZLTqTxuTS/O8Ti9V5vGx4p97vWbs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D0A31DB5;
	Mon, 13 Jul 2026 06:59:58 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4A0423FAF5;
	Mon, 13 Jul 2026 06:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951202; bh=I+65AZJkoRfhn+GH9etZuRk4CHGiXZnzyww6oyVz7W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UsEqtk+cAiZUuP+IzC4OG1/Ln0mLQPLm/q4Thfr0WHRuhRzJNhwQgtN7OgYB6+En5
	 OxXqwraGDtjNOVUGIHJ+49g4invce9r8+4VW0pP8v/nCti7UMCeXZfkI0i3vs2IP0x
	 plyrJLt2mE2WdkAZSRxt+tLzwLJRcRjkF9DRii3g=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org
Cc: david@kernel.org,
	linux@armlinux.org.uk,
	akpm@linux-foundation.org,
	ankur.a.arora@oracle.com,
	rppt@kernel.org,
	linmag7@gmail.com,
	chleroy@kernel.org,
	klarasmodin@gmail.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	kas@kernel.org,
	zhangtianyang@loongson.cn,
	wangyuli@aosc.io,
	tsbogend@alpha.franken.de,
	ljs@kernel.org,
	jgg@ziepe.ca,
	catalin.marinas@arm.com,
	will@kernel.org,
	arnd@arndb.de,
	ryan.roberts@arm.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	kevin.brodsky@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com,
	yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com,
	ardb@kernel.org,
	guoren@kernel.org,
	yang.li85200@gmail.com,
	viro@zeniv.linux.org.uk,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn,
	junhui.liu@pigmoral.tech,
	muchun.song@linux.dev,
	vishal.moola@gmail.com,
	namcao@linutronix.de,
	pavel@kernel.org,
	djbw@kernel.org,
	yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com,
	Jonathan.Cameron@huawei.com,
	coxu@redhat.com,
	andreas@gaisler.com,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	geert@linux-m68k.org,
	shorne@gmail.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH 17/34] riscv: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault()
Date: Mon, 13 Jul 2026 14:55:56 +0100
Message-ID: <20260713135614.1618183-18-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4391040014
X-Rspam-User: 
X-Stat-Signature: 7h6ybk1tqtze5udz3fbna7gtxt8is9km
X-Rspamd-Server: rspam03
X-HE-Tag: 1783951203-247447
X-HE-Meta: U2FsdGVkX1+qu3ocn+evmViQVHbGxtwVt/PmBIwCYNwutVFrOF6Fo1U53JPh3M315kjGvaWfTm466a4OrQHMUXDTkUTxDMyuO5Om/Ma1YMfnpfYhBScv7UsrR+1L/0/ZChH+KrqzSK8Vpbo7cocP609R5t7XD2znqG/RMf0ydC7zmpVV69Q/OBYMefTlCliaVx/6nMl6AwwVKukk08hg9pVqCcpIOQKuQvxMvdz1cHzkTH+Xs7AuwaG8xxZMkkEKtXV20xbgMIc2MZ/wDkL5xeaYKAXUP8dlI8Kp6yfH8aU8eUTv3zPeaNsCf3QD9bJjwXtXa2Tz+FRQL4E5Xjcj9TDwcPkv/u0cnt3Tmmcd7l3ah7pU4YLwuYZxZzhTWwTkcAJv2WKXqJGJukYLQtJx7VpEqNHldaZOK6VOBalUHtiLxDjImrKahYeOO/elhpZ2jhVB8hKU0+CjwgHg/n/BRnVAmsqPLDNj2DAfCgHeZ/ZeJT615yCtWIZNY3dLLnVdpQzRdMYXVkAiuT9bkxobDxhyzkqWRQpycfEk0lzmqEAl+cWsYTgc9axzblG3m/AdujKGANw6MGyGEDxzaQ4c53GNJ4bI5qdBIEMCae9GDbwHpJNyJ+KmNQOi+Sn/+dwo2mcI6IrD50ouyBtVGs/ESYjMqrF/JexBJtVGK+GsSQgnXL2M9PQPHTAy5mZrAplS6nbaPTSrClB+8Vx794X4IDK/E1QwJyCiS+UOQoQsZ75Y8cLGEHfmHWvU1SItasSF9RFJU+MCQx+WS8wcQvriU6CW8cYzB52b7Po4Myeqd7I5zuD6lX7CHudJN2qb6qTht98noZroaT04HWKN+StOzMXSPZ9mGh+Q90hmOz4BGKS4cbT2kMExldzwAaxMxU+KQ75Wpx6C4TcKIntsSYrmrpaRrGAXf5M5XBzctfdRuQyj+rdOKC44H40Lp1BVxow8Wks7qA8L/VzUJSQSaYy
 xBdzrJgU
 ab2kO5w/z8ll/oavUpgdCJNaWCad+n1CdK3HIJtE0KKpsp1VqMEmI5H9HbWj4/5EIcwcPEW2mjPyJWBWw4UtXX+MyYlj5ak2TVIzllOv2VNsvGcEVRjail6nxOqvO01RVGLVD3Bleo9KUSs+Ip69A3OnnBIf4x4tOT9w3Nrq6Nq7BOZqETwMhoVvFWgfgceK6Mzf5huRv1X45XBSR3ciUX7wfY64RC9aDje02/Hsilxk2mKpByueqNt59rx5nHA3o7VxHk8jOzgcvt3O0Ueh1ytWABgfp7XgdQW/UKbR4+o5GBHrTJZLAsswgYYkPkygMWzlzzH27Ya/9KKjgufUY7qf153HKbQcqYZgMh80lpx952ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic compile-time
folded page tables by disallowing its use and triggering a compile-time
error when it is used improperly, ensuring that the actual first-level
set_pXd() function is used instead.

Therefore, call the proper set_pXd() in case of generic compile-time
folded pgtable to handle vmalloc_fault() with pXd_present().

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/riscv/mm/fault.c | 52 +++++++++++++++++++++++++++----------------
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
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


