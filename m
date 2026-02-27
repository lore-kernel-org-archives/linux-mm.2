Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D9F3FEFB72
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32816B00C5; Fri, 27 Feb 2026 12:57:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13E46B00C7; Fri, 27 Feb 2026 12:57:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DB96B00C8; Fri, 27 Feb 2026 12:57:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DF6F6B00C5
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:57:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51311BB9A0
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:43 +0000 (UTC)
X-FDA: 84490994406.25.5EA8651
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 974E8A000B
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:57:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YZAY8PrMrhuZaUeuchgM/SkRiM1r6YDBw5eo9d2XljY=;
	b=K1Jm6BB7YzRTgVHwpkpoM82dRV80x+mR5vXFwxK5BGtzoxBZXc1jCL8k87qmbkaWsbvw2z
	K5hDaTMynq0NBMf2hv/xzrN2zWCY/xmA0g5eCOWZ+Sm+fLJCseLhO71lBwPC+Vti3VuD1g
	i4QTGzsm1q6NKXezwGJThuaLgzBVysE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215061; a=rsa-sha256;
	cv=none;
	b=xqri0C9LYtmjXROHIu8CsbFIKEuCx7Dkf/UAwhXBGWoQt2JdV9x0o4EASAFjLWNJhUFQ6R
	37hfkofES+JMHrdImKXdMDXGc8ZDrxIwiJeRwboTbeBAfO5MUlvp4cMCDf4pheE3eSl2Ly
	JAouQ7x36DOkvCMg3jMWN2kbuWIbaH4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7F69A176B;
	Fri, 27 Feb 2026 09:57:34 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C9833F73B;
	Fri, 27 Feb 2026 09:57:36 -0800 (PST)
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
Subject: [PATCH v6 25/30] arm64: kpkeys: Protect early page tables
Date: Fri, 27 Feb 2026 17:55:13 +0000
Message-ID: <20260227175518.3728055-26-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 974E8A000B
X-Stat-Signature: opqfmstaihmuj1gdcf1cqwf4ncg5e9n5
X-Rspam-User: 
X-HE-Tag: 1772215061-891609
X-HE-Meta: U2FsdGVkX19f+s0DYSe8cn9D/T+omhwd9Aj1DTc0zmreiJQcdUElSDOY5psQSlHSV3eSKUBwekn+pL3Vunx0Tpr9UYkbcqppghldNVhGQbLx8qINFa6F8ge51h3y6osPnrG96e7vjOAEpwjiun48WOPn0UT1BlFuzwKjapl7vYN0Y33bo779e0QPScCETo/kX65CGWMm8RcLCJGF1xz+gTr19hA+4Cu2H8r87HJPdCzzFouKsfYy6es/hwbguy7Pmm0tTrat7r8XKeOrJ2jLzqVtpwgRrufqG8FcVPRULv6nRGPEYvikVjfRWqaadQb9SKhM5tUL3hfC8MMYi2DCjirt/2yaDzgsNIFWZ/9Alm0tIvzrFmH4IJOa4pBtV6RvAXpCK4waKaEdQDo02m7cv+AtCCbGXdv5tqSDxdxlb0XbmdpSBL1IsIKmKUhwwaDhcjs0mP4rNV+rSjH5wRiFRqETXr95e3kHh4QGRXFrDrLmeE7TPQJOql9EiKhtidEGsJF7jHlT/DlBgzyoc+gD4QReH27KR9uvi9bdiJs2xxT7OkfqZbTUNzkfDDdiZC4t36z2CCsoC7FBZfdN839ua3eAHngPKy/QroKsp/tYR87Bhn9hWIMy2ITipKRNTLmcr/wrq69PZzPDRvhprJUG7ZAvZ1i05R3r3Cehqq9ru6JTm2/5R1O6dUHyg6L7vUN3HKWk7obsNQYFqAFjRZhysQKBUKs0whEOhTI2sXKOzNdkTnOe8sFEa458+Wj3o2ZWtWuLfvrYC0xUsSD1rhgBMB4f636XnqjGE88JedIXMaB7AUtoRcrCw8xI1hDhM3MB3Rq7ytLJj2FFZDp1qPWw6FlVVAsygpmtrQt/GZwxEJC9pAoS0RRYXK5b6ILeRkqDNLsPa+8SC9bsNjY5XGEuNBBQOxfo/Z5nu3/EoPUaKU78h5uf5mz7yhTmI/mCCdF10W/7S9xwy3Ku6xHHih5
 EHFlf+85
 3+KrwJLnC+DYc3tBEZDbYOGZzq4A/MPBJ4DzCYbVxp3IJ3oeBrLYzxIWIq8cEIWtEQzzOXvDVsgrMo0yYe2GEBK7FTucBr0IXpUPTheDx7pldzJkYvMu0iCKOlUfbFABLN8lxc82f6VTR37pndh8uWOXktgAbFGSUsdHLVIixxyq0kcwoI9j7fT6mQufM6R1Uhf3zG3Li/OImcok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the dedicated kpkeys allocator for early page tables (used to create
the linear map) when the kpkeys_hardened_pgtables feature is enabled.

CPU features have not been detected at this stage so we use the
early helper arm64_supports_kpkeys_hardened_pgtables(). This is not
a concern as kpkeys_physmem_pgtable_alloc() does not itself use POE
or set_memory_pkey().

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 2cee0b7f8a56..7072d5ac0579 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -116,8 +116,11 @@ static phys_addr_t __init early_pgtable_alloc(enum pgtable_type pgtable_type)
 {
 	phys_addr_t phys;
 
-	phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
-					 MEMBLOCK_ALLOC_NOLEAKTRACE);
+	if (arm64_supports_kpkeys_hardened_pgtables())
+		phys = kpkeys_physmem_pgtable_alloc();
+	else
+		phys = memblock_phys_alloc_range(PAGE_SIZE, PAGE_SIZE, 0,
+						 MEMBLOCK_ALLOC_NOLEAKTRACE);
 	if (!phys)
 		panic("Failed to allocate page table page\n");
 
-- 
2.51.2


