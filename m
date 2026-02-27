Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E380FEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBD86B00BB; Fri, 27 Feb 2026 12:57:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BBB6B00BD; Fri, 27 Feb 2026 12:57:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA3116B00BE; Fri, 27 Feb 2026 12:57:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A53396B00BB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6C21E1A08AD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:24 +0000 (UTC)
X-FDA: 84490993608.14.77AB269
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id D8A0B40005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qp/N2Lh2Uz7eg8gMDrZELt6NrAjawyjuQWmtcBs8hFQ=;
	b=T0V3LEJ3uR0xhh4Y9ehLHbPdgOXKxzVqCGCc60cmDq9W6PZZyM0pOJoL7Nugf4OJ7kt+d/
	i3UPKYrb72sYWR3FbSKC2tOxkTiVWo8LcFd42HrJUuM2ZQo/1THgT4jqrTN3epOof2fEJ9
	qFQGxLu+yNFwOakhgiGDrNu5wqCuuN8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215043; a=rsa-sha256;
	cv=none;
	b=VAeKZA6CF8IkOvztD/zWIAOQgJXDxtuZw2PQ6r0Qdy/sG130AvtvkEZr5EhXU08wQH3bTc
	5lce9ly5w83wqEzTcBlauygsuaIjmP8ZVr8sM5m0dCNlq7SyXK+F7IniwLBHbLd0hVpfbt
	b/G5ejrh8yozotnCeCOrirK/sl8t88k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCC68176B;
	Fri, 27 Feb 2026 09:57:15 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA3253F73B;
	Fri, 27 Feb 2026 09:57:17 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 21/30] arm64: set_memory: Implement arch_has_pte_only_direct_map()
Date: Fri, 27 Feb 2026 17:55:09 +0000
Message-ID: <20260227175518.3728055-22-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D8A0B40005
X-Rspamd-Server: rspam07
X-Stat-Signature: o3nr18n9wyczx4hqbdwnrid7yse4pc6h
X-Rspam-User: 
X-HE-Tag: 1772215042-31259
X-HE-Meta: U2FsdGVkX1+j241eXVPNQUTcbV0xlCkDvYLP4dcFCVOhUtB1k9hvDGJnofLgGwrjtdZPrbpe9towSErAWnoOwokiWQBcRsbNclirwaJ4bRCYgnD1FrpKk85RYOBypJmdsasWRzdIXo+KwEjM6l87GvZThkMXy3rYsJDu82iYRiXTZDdu5G6QjCdY1ljDdKR7azVk+BaGN5s5JhdCckVopcsCaIZKa2nlXakpxnGBDXAdxyXe3nqDKjhy4+OsMPUIeu1e+CwM6KJiPcrvLfqXjg9/vBayuROjv2T2LOc8NgxtqOSihe1QRthpO7EY688U3vAEhsRlJngOvhOnZottGS3EvCSROHh8/T6WPazB9Li87ejEXWC9b0ZYh8hpWlyF2ULLySt23I45gMv+Gy3IYxkY7DJ4EfmOMdnFajROuPke6O12kCf2ySPy8JRSHHxgRU2Xz1dTMVgLvGFOXd7xJ5DnMFxkNA6VpvHC03Kix1TgwGSmWY9CRQCD512Ax+ae+xP0lVlvVqYQZ+gdc0EvLhKOQyB2aEwkVpQjSqhTzbuw2sWAWDM5/TmRfU6QVt4mR14EQwUVIertIiEcIRWoJkGR8Xu3repiUXr2FpEFpmIVm8Jtb18/KG4paavrRmor3IP7v+nmvEZmm2Yg0ADFJwiYfLY9TBSKQGrsiktpJ8/7qFTazDBLqMsgXfvx7Awd5sgcaAEJKzAOnVJqOMBi1/rQjVt9STYx3vuUYfPNx2ve7AlPpocLXEHQJ++eQe8WRpkiHatcJ2zQFQGB6DcC8XKGd0/xsvVCDxGkilFyHqcK6hcBXKp3PMwB1PozSFa4bOqGupLr64LZ3y3fE3zus8htkeBnakxQh1DQGTEmxUSm6lmf5zNmrkMmdT/w04PcbOwH287CKwUDdUJWA+THKCaV7nnJbTrOQeTSlWnvHYHkMQ2ceHkpi0/6fbEMReIbr65cM5GTL6yuMf5RiYh
 X8e7wcY9
 KySMoHd45vRIy7n0DzS4w2/6AOEsnt4ozwnk0HadjMkjEd1vXcBVtUkR96CyndGwGGIhMcrYT1cMrxOjumiH97hytOZIRMJ+fXR+Fop/23kKIBDHlo78UWDn3l5tTU1V97cYmG/jdpFCzYd1t2dn8f182mCXRhjKqM085fTa5FtuMEzuHvkfu1VL/rjh4M+3dpAoy+CGvUFcI95M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the new arch helper, which is equivalent to
force_pte_mapping().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/set_memory.h | 3 +++
 arch/arm64/mm/mmu.c                 | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index b6cd6de34abf..2bf6e0b917e6 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -9,6 +9,9 @@
 bool can_set_direct_map(void);
 #define can_set_direct_map can_set_direct_map
 
+bool arch_has_pte_only_direct_map(void);
+#define arch_has_pte_only_direct_map arch_has_pte_only_direct_map
+
 int set_memory_valid(unsigned long addr, int numpages, int enable);
 
 int set_direct_map_invalid_noflush(struct page *page);
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 09ca62f77a84..a8e982ac5079 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1181,6 +1181,11 @@ static void __init map_mem(pgd_t *pgdp)
 	arm64_kfence_map_pool(early_kfence_pool, pgdp);
 }
 
+bool arch_has_pte_only_direct_map(void)
+{
+	return force_pte_mapping();
+}
+
 void mark_rodata_ro(void)
 {
 	unsigned long section_size;
-- 
2.51.2


