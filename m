Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95F0AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 094C46B0108; Mon, 13 Jul 2026 12:27:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D546B010D; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D15E86B0108; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98A226B010A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:27:41 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5EA78166158
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:40 +0000 (UTC)
X-FDA: 84983911320.04.5769143
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 75DED100005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:59:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hFiwKMoL;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwLeq0PkyIvlTlg7ku38Xfln0x8pSkKwvMyihtYc5r8=;
	b=F6JoCZum3MlGjfb/iOHT0Yc3wXk8/y93a5DYXAU8FpWr5j4SqqIviBHVF36Cvd8Va2hG5G
	32SMpVoX2tPYvcJaXD2L8GS7JlBZR377C4HjpU5PlnXOIwTciVuQkLsYjyxZvVHQtBfk71
	LB2oGlVbyDp+YOfhtfvALuRBBUX30as=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=hFiwKMoL;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951178;
	b=fkXhxvsuy0kbwDx2LJ+E8PTq8KcoLVAdzYmG87aWw44c/bL5KCWMypnzH8+qZGpsHKRl2k
	ksSAbE6eJT1Fed+HCOQoZCUXvsVewXZ0NvRaQo4WeRkoyWolnDHmlO1AGDyQlibV3ZsHvU
	dmFRXNyBsqowcfbtF/LHfkNKBTHU9GQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F7D41DB5;
	Mon, 13 Jul 2026 06:59:33 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2DF8B3F7B4;
	Mon, 13 Jul 2026 06:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951177; bh=gV2pTsCUztgOvGxrgAt605ARjz7dmzmHzQM9Otey+5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFiwKMoLlCD3BN8OR1BVTk7TGKyMljN5sZjMGiN8FhmafTvDOgG4tq4iifBz0LBGe
	 TEPym80+aPKYKhJUwzOJNb9VKhhRTPH621Ljc/q0DnJmnSnhinhKUbtdb6iKpO4mVN
	 n11BCRxPznqUlnDr4I57hyRYBDnCMWFwyszMYrfQ=
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
Subject: [RFC PATCH 15/34] mips: mm: use proper set_pXd() for generic compile-time folded patable in vmalloc_fault path
Date: Mon, 13 Jul 2026 14:55:54 +0100
Message-ID: <20260713135614.1618183-16-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 75DED100005
X-Stat-Signature: 4o88qe45n7fq7qdphb3b97f1ann75tra
X-HE-Tag: 1783951178-195816
X-HE-Meta: U2FsdGVkX186/7af3iNF7ViB02+q8d9t27I/ch0eV5ADyfNPEpHc39OM6SYqD4R3I04i0DBqK3gVso6eB4djRzsPmmj3drbs0KB7tYcCWdzkSB+tEZPawunQXLL8OL0OoSFbMxann27hE6nPhnpydH7R14U7ulFYRTtjo1DuGZull2lPVrHmzXPAlN9T6/Kho8u4yJFvJhkz0fvaotSLglVggT44CUKzvTmGTNdQL7nWyPwclLdbKxXHRfCghii6OMhqwgdv0Zm1U1jiSQA5NL+nV5KRof4A8L3LimRBrZ9Dz3hLjiQkq/GpOWoQGrvdYIQnTrfjtHrFM8gum+BMwmsakGPysRbJc/pOmxogXlkL140m/NK9ASpze9OqD1k1VP5d6c9+PXxWOsmvGZ3rdTkdcaUVXWUdFWEqhxe+aCqizrXerojTDVI+4z/MaR7e/CYdaaMrEkHEHxx/YmWJgYv9CzRJfAQscbDQF7SSfda95x8lhEhCDqoR3xb1vRdQkLd450zDvL7wP/ujrNOQNuiPc5MHHuxlmUrMHxj+r7qiM85oRubbmSGnHp100kSeCDd1Q8/3j0Tx1D7lVwiV8eIs65Pc8eFbl4flaRyIVlKtiQ0C5R/sPaikMEOO73D5wA0GO0HucVYv1OjNK4mDpqWTtK/ypy1BydivDQpORrHzZObLRYqe8Esz6/D5nYF/az3qExeNrS9FuWejIw6CyuyJCg0zX0cqElkQHCbUU+FpMnEdRqPuRqNPcg1m/mfIxZlRQAIcRdSdOWckjAYA7Ih5c/GmLJN2Z9XT5czMqaw6riUb3UvPmRuQhF4ouPwegPZMIg79kP70j1NPy7iRe5Ib+xTwgAW7yZjXqjFTY0XswZfnaY2CHAEOopf4efVhlskSr8cRM03ytbnKj6/5BgvzvRDLdk1kg8A7WmxdlzQjOQ4Ernw5LJ31TCsazrF+AuiL0wXBxZXRRqRDyl8
 hp4kZcNH
 NBxWTwhJichY7HPAvWpJ0avo7jGxAgoYSX6gPs4nTMCu0oAk3v7VXSl3mFqjyFIPorhUcg26hDDUfKoQK4mIi0icM5pKCOeklfOwt/ng45p0pcQfnJ3qknTC6BBtSMCJBM/NySCCIqNohNk8IsRo7HBwWxOeDAVK5eVWEBX5zMlotp81PGjZcDgua121eda9FI5s1WxbPnkyL6UhxAdvC7RVG9SvWmBx2trn5qKNIl6L+ko7a6R5RLjQaCIHHog42lEbC+t1lYJ8gl0c+cbUTSjUKGfTjSMiQGOuqXWeBipwEb+fBcZKGpVDxn5nrrVPjlT2Fbhzy1v20NSmBp0jjb3/1+EfNTe8m3Q2Lzt62J7RMBSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how set_pXd() behaves for generic comiple-time folded
page tables by disallowing its use and triggering a compile-time error
when it is used improperly, ensuring that the actual first-level
set_pXd() function is used instead.

Therefore, call the proper set_pXd() in case of generic compile-time
folded pgtable to handle vmalloc_fault case with pXd_present() and
drop pgd_present() and set_pgd() usage since mips doesn't support
5 page-table levels.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/mips/mm/fault.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/mips/mm/fault.c b/arch/mips/mm/fault.c
index 37fedeaca2e9a..4ad281a3bf97a 100644
--- a/arch/mips/mm/fault.c
+++ b/arch/mips/mm/fault.c
@@ -289,28 +289,31 @@ static void __do_page_fault(struct pt_regs *regs, unsigned long write,
 		pmd_t *pmd, *pmd_k;
 		pte_t *pte_k;
 
+		BUILD_BUG_ON(CONFIG_PGTABLE_LEVELS > 4);
+
 		pgd = (pgd_t *) pgd_current[raw_smp_processor_id()] + offset;
 		pgd_k = init_mm.pgd + offset;
 
-		if (!pgd_present(*pgd_k))
-			goto no_context;
-		set_pgd(pgd, *pgd_k);
-
 		p4d = p4d_offset(pgd, address);
 		p4d_k = p4d_offset(pgd_k, address);
 		if (!p4d_present(*p4d_k))
 			goto no_context;
+		if (CONFIG_PGTABLE_LEVELS == 4)
+			set_p4d(p4d, *p4d_k);
 
 		pud = pud_offset(p4d, address);
 		pud_k = pud_offset(p4d_k, address);
 		if (!pud_present(*pud_k))
 			goto no_context;
+		if (CONFIG_PGTABLE_LEVELS == 3)
+			set_pud(pud, *pud_k);
 
 		pmd = pmd_offset(pud, address);
 		pmd_k = pmd_offset(pud_k, address);
 		if (!pmd_present(*pmd_k))
 			goto no_context;
-		set_pmd(pmd, *pmd_k);
+		if (CONFIG_PGTABLE_LEVELS == 2)
+			set_pmd(pmd, *pmd_k);
 
 		pte_k = pte_offset_kernel(pmd_k, address);
 		if (!pte_present(*pte_k))
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


