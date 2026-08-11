Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DDA3C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40C5F6B0095; Tue, 11 Aug 2026 00:21:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E33A6B0096; Tue, 11 Aug 2026 00:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D2356B0098; Tue, 11 Aug 2026 00:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D00B6B0095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:21:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 85EFE140311
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:38 +0000 (UTC)
X-FDA: 85087689876.09.AFFD69A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE14820003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:21:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eWCiC7xg;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EI5j2f3e0rorVshjGDKXnzZx89bDqNn4XV41gU2IJnw=;
	b=3IncwNxgUsNwg0l+5cJiQfqLQNhebuf5PQegHb2zkOy1tDeLeF7B8idwN60PKaun8dnwXE
	/aYyVgfXk6yzJ1JIQ4oML057j/CF5oTO2DLfIxP2EoBefnuhWw3U3eJ651PGGtp000gQm8
	nMAeT7EFMObf0JlKsckJiT0k60/hQgE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eWCiC7xg;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422097;
	b=iVhoXhEDDUs6GjQDDVfhVGR67rOr1s3g5hY2LvA2GbExFWWPdsaZo4xCORvObTlMoXpxE8
	/cZDw3Tpp/RyXmYzRDZvaly1AUHmf1lM6YKvbnF70mKZU/1QpA71TKtLtLIBXx1LDv83Gw
	CjFjSIlVUBCGdG9O1bFPQgmajfUeGxk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05D0F1688;
	Mon, 10 Aug 2026 21:21:32 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BCE93F673;
	Mon, 10 Aug 2026 21:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786422095; bh=pfMAQ/GDECbmwo/qWefWNRsbphdRQF7xgYQeIgh1v4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWCiC7xg6Urch6e/NkyTz2nx1jVxQ2+lXNNVl32VkpGHIvNOZKoKK7OwvEvBfhSEE
	 wJbBJKEACAKzuY3XWRWmEiavQBuGK0AQKUazXEqU1d31lkT1Spev7terS8Toxwdnjv
	 EicAFdP1tvM9H1F3vee9RdSt/Ezcn1ReEpkjAW58=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-alpha@vger.kernel.org,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-csky@vger.kernel.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-sh@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC V2 3/6] sh/mm: Stop using pte_ERROR()
Date: Tue, 11 Aug 2026 09:51:16 +0530
Message-ID: <20260811042119.3652929-4-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811042119.3652929-1-anshuman.khandual@arm.com>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r4xd66m8b1bprphnmuc3hk47rnpwkw4n
X-Rspamd-Queue-Id: DE14820003
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786422096-623856
X-HE-Meta: U2FsdGVkX18AomPxBM0N4+b5AcYWrQyGwM9BcvnEXJh96+0p0vq68DEt9njIf7cYCV31SH7rZjjV3V/C5hwlUyum6r/UlUvXe7bg1mwd6sqXVrkL8Y2uYbeMu2gVa6fmUGHWqjP68HjwIYGXnCmsgE/zNtl3aNWDnqE8TaC4A0Z/cS1IrD7LWu4GuqCTHaBZ+bEiRwLKlxXNocv/osv2TIbhSoZLY/EHj/Lel6tpE2lxKfKJ2QAH0lk7uQEAVQI0Nb4BWAgX23nNpM0edPb3o3bULjsj9r+y8NT7rdKihzcfJPX1CCGEtDJZ2E9edm0ChB+mwqwgxI0y03g/BKJmXg0ZTcKet12fMXh0YM+iDc7oMERs083b74ihPqb+VXoSgcwpPnCrgcnaq/NY4KBOtCnYuCnXWamevFLdyvC7lu/mzi1df5I+22zCvJVFOG78e3QDLiYATVZBc7V5S7LZ27JPmI3xpa+HRXfI8xuy+0kX3K8bkZrf5M6Fq4/qNOqZ+vtTw/Ej/CdO6qAO8v6phXY3M1T3zFTIJ03crrGyY6FJ8JT1pQXeb/F5+51FUCJ9ADlYvrP2ZWfmy0B+lGDSTlCaufVMoM1OOU0uNJ8CM9fyyvKqf26H+etljdf6EKyxA5iRwOnQjYtr2TIlAled89PG8n64PUxIwAIBXFxEHfnV3boHHvzjpGjhu4jYo16MESwYIXUEfnIICFbKxcDnIRevH36utGyNk/NbHnivGDsDxd2bdJhoMVgUs3toJtwmgTFH6diEMm5+ihB9cln93ZGXljjhiA7O9FIeCztwfXwdu79IoBf/YB54g06kg/HKdrTMkGNlmXDlg5kIj1hzagWa50/dEroqGABPRIgqEdtgD5zAsgpW4QRje9QxIcMI+rmpjCFBY+VzEfEKrg+t0lgBMBv4G7q9J9rbz3yrRmgSrLRSP4fRSXKisuyhpS1hvZgRBLl3p7DfLM7ZHPD
 o5Z375T6
 ZcMdv6n9vAStn2eG9mexivVY19LIFx0X4QAe2tqOrAsw7sQGvbGIpx5I/Gd77anAibMdps9ONi1BJkiwVGXpw7YZEOHM7R0AxXuwddt9pXCVStJszzZsXisgMnLIduHuWm3J5rMw09YBTYrcQ4F/usZWoWvvisXv7G656z1Wu5kF5gYpnqpCQAxTRq84QN9ma2BOYHaawZAPxQ2pmIHKWZbH/CCKinfXstMiJzf8JsUIGOdxOd+kSbSot5WkbC2QUS9d3iSV2Smy1oWtNNj4cGzyTV6qXseTZE8TOflPEe3InKELlzJ0IWFAzkjdMjirRJgn1g4IdE9c3ZLYcvjIQzA2N00bOqNZMrsw+Ay/h8ooSdfpRJKzDgn7v4i+k0ajf/zJp0ItP+EJrhJ8C/wrUtpVmkPTKtFEYrTLSlmYDavqbWH1BJk7o8gLJ+4ehXtf3ErTRrxHr+O8H1e4vLNSjjrA2NsJsMCrbpkrv7UUikim/93TXbgpDgkRUnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Directly use pr_err() in set_pte_phys() and drop pte_ERROR() which helps in
eventually dropping pte_ERROR() macro across the tree. In this new printing
__FILE__ and __LINE__ has been dropped because they are always the same and
don't really add any value.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/sh/include/asm/pgtable_32.h |  5 -----
 arch/sh/mm/init.c                | 11 ++++++++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/sh/include/asm/pgtable_32.h b/arch/sh/include/asm/pgtable_32.h
index 5f51af18997b..c8eb9a7a4c4c 100644
--- a/arch/sh/include/asm/pgtable_32.h
+++ b/arch/sh/include/asm/pgtable_32.h
@@ -401,14 +401,9 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 #define pmd_page(pmd)		(virt_to_page(pmd_val(pmd)))
 
 #ifdef CONFIG_X2TLB
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %p(%08lx%08lx).\n", __FILE__, __LINE__, \
-	       &(e), (e).pte_high, (e).pte_low)
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %016llx.\n", __FILE__, __LINE__, pgd_val(e))
 #else
-#define pte_ERROR(e) \
-	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
 #define pgd_ERROR(e) \
 	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, pgd_val(e))
 #endif
diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
index 110308bdef01..b3c7fd84ceb4 100644
--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -78,13 +78,22 @@ static pte_t *__get_pte_phys(unsigned long addr)
 	return pte_offset_kernel(pmd, addr);
 }
 
+static void print_bad_pte(pte_t pte)
+{
+#ifdef CONFIG_X2TLB
+	printk("bad pte %p(%08lx%08lx).\n", &pte, pte.pte_high, pte.pte_low);
+#else
+	printk("bad pte %08lx.\n", pte_val(pte));
+#endif
+}
+
 static void set_pte_phys(unsigned long addr, unsigned long phys, pgprot_t prot)
 {
 	pte_t *pte;
 
 	pte = __get_pte_phys(addr);
 	if (!pte_none(*pte)) {
-		pte_ERROR(*pte);
+		print_bad_pte(*pte);
 		return;
 	}
 
-- 
2.43.0


