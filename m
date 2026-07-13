Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 973F8C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FBE6B00FE; Mon, 13 Jul 2026 12:26:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76CE6B00FF; Mon, 13 Jul 2026 12:26:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE786B0100; Mon, 13 Jul 2026 12:26:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78A116B00FE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:26:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C1F08BC13
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:30 +0000 (UTC)
X-FDA: 84983913420.25.E36C9B9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7D11540010
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:00:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pGt+wVwX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCQv8M7VrBm4TU+MPV6p2csh/ijl3jkmOGWWVQbEQ04=;
	b=2/mFIXEwpkZ617FKiqKadCnSgod8F8FvumCs/uK6yteYcv4/an077JcZRPgirRp+y98RCl
	vn1B0AFts1VmR2iXZyX0QmxgD4MHWQTG2/yleCEdoKLf2ZHOBKVQjoFeNn+cS+UC5FcJXw
	Q+Mt29qEL3KBC3fyb6V+U+S6ADHuxwU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pGt+wVwX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951228;
	b=D1BclcWkZQBYaP8mtTo8OAWV6lYC6Wyfn2Emu/gjxYAp+JiTPbFS8aS0U50iSFSaw/xN70
	gxHyUOdz2Q/FImxwahIwh0tl+J5+ct/G1x1mF6gcVrhYDpPkVxnVZvXtDb6tnqmfECaHnL
	2dDPbiqCRqDq7XjncMkb1HqbMUm4qHo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F1DC2103;
	Mon, 13 Jul 2026 07:00:23 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 651783F7B4;
	Mon, 13 Jul 2026 07:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951227; bh=LTSOz6r8IXywEsuWgl9722tiR9WcqjiHFXGXDRX3spM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGt+wVwXPP9bqbNiSoGoTQf7vUj9+h+rjcGEu7v6x9h5jUGGL61je/MuOfCB0IGbL
	 MCwtdgvHi9xbeiGHPrEgzoOWMgwuAwIORymTP+QSMvNXbWLSJ5lnVb/8rcQcLGe2HS
	 V32gOsFvzZEGe9nESYJjvb3kHILH3HN1uCBfzjGg=
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
Subject: [RFC PATCH 19/34] x86: power: use proper set_pXd() for generic compile-time folded patable in resume_one_md_table_init()
Date: Mon, 13 Jul 2026 14:55:58 +0100
Message-ID: <20260713135614.1618183-20-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ybwbtc7jt4b7ysew7d6nbz1zodmjput
X-Rspamd-Queue-Id: 7D11540010
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783951228-430108
X-HE-Meta: U2FsdGVkX19u6C+byKY5agrBEgNiCkxrV3GkYx9VJgJ2QXeY2vgmWs3cPymFMjWACWL7AQZtsiGtgxPLn4T9+MfnUKsnJLCupNX5FLvtCK2vJppODFrXI5Is+kxc3H5h2GWK/a9/1qn3Zl0Lvy6KQKErB3xFIUVYMLVqPaqr94dnFwtTySSyF4kkBth7DEZ1AmikHbL/2/OtPuYR4UhueilTdWuWsCfVYycDKaA0HpNRL5dHRex27C+2I47u9VwjCRpToZzAfar50eL2Pz+zjJm2zS9dbox3sTmkt06R2WNEDR3obGBuF+bQkU4fsIf9DipzSNqI5Bs+bZhApCyeeZ9CaMUgxdfMl0UtWxDlDTBHNx/LUqWGr4j0fhSlev/UXLBSzVM9ZltluTHeTIW8zD2v1a7j9H2pgWi7c1M13KAVE7Fb4Hs9vjZVYcobrol8PAXE25p5laPyowUnLq0XeqLPzm86pEOhSjEo8Af8F+6ttcHA4d1mBLbotFUwEp6TmYFgEgOtUCCYb+UaJW0vFOCkAuNASLI1tLzoOge7oJhFWyIjVAXXaExyaMdFWmP7Gutr9Bn23oNP7lXnharnjyqYPXwy/ocmn9Ag1JIZ0saBx8y4LnFPhtYkWWtyRs1NMAcaRDJIErg+7EbC9kFaDsJckTAWe1Odu0ekIgyyKZqiOqTCx/6YHSs7AzbG3OPZEWQD+K4ZGljEAJ57q4d1THt0lameXDo8EAprB10P+IixjxPwgcsJh3qlIjXiBJ0WSJLcKNOYLSlIhA3zdP04jW55fLnFqG4zJWCkjWCrPniwZrIp5UyN2gSwno13P7gsR0owkiIGebPsMtiT1GSw1rPoQ01KqjcbiZ6YAH/qqdRQA5E1UCqISRG4tornR2xSEV/P60cxwy5OZAjccTeIPMK7dJw6Eze3Ts+6ln/thLU2DqIn+oC+YShfj0NlKNr24k3NQ0DCVhRAqhveeuc
 CJdnXBUP
 b1Cj/CcfjZDxhDuTpFoaHBefXhfbJkpjPMX2frknCehqh9k/ubrVpiCUjbxhEgZ6XdG0J4S7IRDTuuIbU5fip7jQqiImN9Tb0cktCdvWXQPxUnAzZCNe/X/oi8McTBIhezQxS8HLGP2Wzl5UrZFRS6B9V/0GGRFfQyWfADFy2ggJbwjyKQuiysRHHjciyJLhhm6uuLXmUfIwCEeACXGinfAP4H6eclj3ftONxo5TkXAYkHZDNhwbKbzPNqh7zR5d9pL2wB1aXfHYoliTGueceC5T+Ac/r+5ML0JrPWjOIrpToEPcHQBM17VT4H1zrD+U/Addi38PuWedfHsXzPRB7sx9EMwAHnn0afKzqHPkmGtZUokE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic compile-time folded
page tables by disallowing its use and triggering a compile-time error
when it is used improperly, ensuring that the actual first-level set_pXd()
function is used instead.

Therefore, replace set_pgd() with set_pud() to setup first-level pgtable
in case of X86_PAE.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/power/hibernate_32.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/power/hibernate_32.c b/arch/x86/power/hibernate_32.c
index 223d5bca29b86..ab5a203b45cb3 100644
--- a/arch/x86/power/hibernate_32.c
+++ b/arch/x86/power/hibernate_32.c
@@ -29,8 +29,7 @@ pgd_t *resume_pg_dir;
  */
 static pmd_t *resume_one_md_table_init(pgd_t *pgd)
 {
-	p4d_t *p4d;
-	pud_t *pud;
+	pud_t *pud = pud_offset(p4d_offset(pgd, 0), 0);
 	pmd_t *pmd_table;
 
 #ifdef CONFIG_X86_PAE
@@ -38,14 +37,10 @@ static pmd_t *resume_one_md_table_init(pgd_t *pgd)
 	if (!pmd_table)
 		return NULL;
 
-	set_pgd(pgd, __pgd(__pa(pmd_table) | _PAGE_PRESENT));
-	p4d = p4d_offset(pgd, 0);
-	pud = pud_offset(p4d, 0);
+	set_pud(pud, __pud(__pa(pmd_table) | _PAGE_PRESENT));
 
 	BUG_ON(pmd_table != pmd_offset(pud, 0));
 #else
-	p4d = p4d_offset(pgd, 0);
-	pud = pud_offset(p4d, 0);
 	pmd_table = pmd_offset(pud, 0);
 #endif
 
@@ -134,11 +129,12 @@ static inline void resume_init_first_level_page_table(pgd_t *pg_dir)
 {
 #ifdef CONFIG_X86_PAE
 	int i;
+	pud_t *pud = pud_offset(p4d_offset(pg_dir, 0), 0);
 
 	/* Init entries of the first-level page table to the zero page */
 	for (i = 0; i < PTRS_PER_PGD; i++)
-		set_pgd(pg_dir + i,
-			__pgd(__pa(empty_zero_page) | _PAGE_PRESENT));
+		set_pud(pud + i,
+			__pud(__pa(empty_zero_page) | _PAGE_PRESENT));
 #endif
 }
 
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


