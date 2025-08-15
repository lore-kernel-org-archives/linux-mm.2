Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CC5CA0EE6
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 08:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929E9900218; Fri, 15 Aug 2025 04:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 900D08E0002; Fri, 15 Aug 2025 04:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CA27900218; Fri, 15 Aug 2025 04:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 649CF8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:55:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 181D61408D4
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:59 +0000 (UTC)
X-FDA: 83778384438.26.FAE0727
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6EB2040007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:55:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755248156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xScE1ZeqkqR6cVLz8VDAxvPBqz1u2D3A/BF5V85Xz48=;
	b=bQREXlk66BnCPyh8/b3AKxSFbsLSoEjxEq++HfFaOUOmTqTFCD+r4lFHaRRXG1BeUuGR0n
	TWE5jsmgYVFIjvb4F6IhtlmkVUHtYCjenNMM/LFFqQN5IrDPrXd3Kunvp+2LAsuHgY2CrH
	XPxOEA6j7B3jwPzwe7xeIp3WtxiWlts=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755248156; a=rsa-sha256;
	cv=none;
	b=X0n5eL4wvMq24hYF036I0eF5qazw4qpOa1NXc0d/KPU1hUyQxaU5URs8DCFXW/hJk2gogb
	e3FdrIEU1g0/EbW3V2VZPbGCqaxZj57oFQng2SRtL4Yr0Wx7ykjILEsZR1PL9kkjnrTQ6N
	5O5iwNBXaPE6VhqkAwws6tCkPEtSExE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 619F51E32;
	Fri, 15 Aug 2025 01:55:47 -0700 (PDT)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 076A53F63F;
	Fri, 15 Aug 2025 01:55:50 -0700 (PDT)
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
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [RFC PATCH v5 06/18] arm64: set_memory: Implement set_memory_pkey()
Date: Fri, 15 Aug 2025 09:55:00 +0100
Message-ID: <20250815085512.2182322-7-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20250815085512.2182322-1-kevin.brodsky@arm.com>
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6EB2040007
X-Stat-Signature: 4xjjtauqtopm3poty67xb1tn58pm5tr9
X-HE-Tag: 1755248156-703165
X-HE-Meta: U2FsdGVkX1/PXviE1fPvghhlUMZsobiqGNiqM0NB40Wob4fZfKAltS/rZ7fJ+mYWNNXRWyp4DqT31If9MvPFkVD5PvwUSDkCgc2QlT9rOTG2u4rQoKKR/RAI+5VI4XDoF8dMPAV5oDi1044f8yaNV2MRfdYnr7bWJ98Rk63vTfwckXcxLD3GsubLBs1+d0iXPE4uBv3+xT9jObYHZvYCm1dTqBRSs4vQ+fIdFBsd7qwIeYIxSxpje0XBBr+/5UCf/KqsNckHaRj/WD19bHoPIe/Lj1MF84UEwGE5sZBibPfSnyhOIQ2buhp/ItXi/t/CymQi7D97UCCcScS5VHuEDaIvut0OIYgn5KSusQHeZes+pMI2sVb5lKtf3fI4NQlo6DXYVo449EIbnYKyDGDQCVS728rir/lwca490OtMhIgQTg5MPhicmv9+DnblnPghqujMdThj9Igb7HBSIKHjA/4PposSZtjFJUHPJP81FxUXgnV8DMZv/b8rFGmpcSkdyzB7l1REccqiZmD00ElIXjYexFzo9gwFOCw6IgY04kboF76ELyEFkfKWHQl9WTv9VzpJ9WIlntMCN33zh7wWMaS7Gu3nNkndhiItU5gO9U7XpPPRr9Y0ZsCTFWkCcZdq2E5F240MjxpWsJvw2RkU3CuXDD/1FuaqSZ4f0RWFQ3ceHORZEsW0/JeyHdzvFDeU0kSLSZTzupW7JGEfb97AKON7/YjYOSDcuGQqkdd05pWWEMDsw5DSu+kZ8QeadbT0pRSTQEQsHVvZq8EpaYVbSM9LKOcuc1hSKckvxb+cv9XI+HcbdL3k5sIoAH4xH4jIY/jL74aonEIScv6WeDrjR7HUBvuYD36+Jn9KdThYir0RQcopxPiYxV7R2v5SSAFG8dIeR+7txDN+AZH5SzDODwZ0LOTJobuIcvDoRxAb2DgwTpySshhM8Z6NA8WnxQSbZreEcYH8yukx3VKlW8q
 o/DY5yKJ
 u50p2bRZS0VyR6mNnDvz5awsHoo6QzrKM68bo3jo6IlaS5u2lbvm8ti3I4Eo3+uvS6KLiozGzbGgEWhE084skiRUgGZUatkk7QSnbYfBzZOhZe2lAvoUIaXzHSBkUTaOr6VKf/8N8f56oYeyGt1O9PUqENUBGIsNHVktY7AILYJvNE/YJA1YW7WGxs4PbX3etK/y33GWvO/JkSh8VS6F4FaWLS19WkVZqZShxKdP00LEJxgs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_memory_pkey() using POE if supported.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/set_memory.h |  4 ++++
 arch/arm64/mm/pageattr.c            | 25 +++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
index 90f61b17275e..b6cd6de34abf 100644
--- a/arch/arm64/include/asm/set_memory.h
+++ b/arch/arm64/include/asm/set_memory.h
@@ -19,4 +19,8 @@ bool kernel_page_present(struct page *page);
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_memory_pkey(unsigned long addr, int numpages, int pkey);
+#endif
+
 #endif /* _ASM_ARM64_SET_MEMORY_H */
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 04d4a8f676db..41d87c2880fe 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -8,6 +8,7 @@
 #include <linux/mem_encrypt.h>
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
+#include <linux/pkeys.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -292,6 +293,30 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return set_memory_valid(addr, nr, valid);
 }
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	unsigned long set_prot = 0;
+
+	if (!system_supports_poe())
+		return 0;
+
+	if (!__is_lm_address(addr))
+		return -EINVAL;
+
+	if (pkey >= arch_max_pkey())
+		return -EINVAL;
+
+	set_prot |= pkey & BIT(0) ? PTE_PO_IDX_0 : 0;
+	set_prot |= pkey & BIT(1) ? PTE_PO_IDX_1 : 0;
+	set_prot |= pkey & BIT(2) ? PTE_PO_IDX_2 : 0;
+
+	return __change_memory_common(addr, PAGE_SIZE * numpages,
+				      __pgprot(set_prot),
+				      __pgprot(PTE_PO_IDX_MASK));
+}
+#endif
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 /*
  * This is - apart from the return value - doing the same
-- 
2.47.0


