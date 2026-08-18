Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85D9AC5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 671666B07C2; Tue, 18 Aug 2026 10:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 649A36B07C3; Tue, 18 Aug 2026 10:11:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586176B07C4; Tue, 18 Aug 2026 10:11:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3329D6B07C2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:11:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B388EA0252
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:54 +0000 (UTC)
X-FDA: 85114578948.03.4076311
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E95E580003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:11:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pwB51POA;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787062313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XHe1sUYUazjYlpuT7B7U4qpnrUu+h4NJeX3hrVaTl0=;
	b=1qBIsE2toVW3/Y0AiR8P022LMhY8YwQPIkVrjSzW8VMUKnihy9+EA9vfebPpH0rYWsqMxR
	EuxnOAvRtk10X0i15jlcZKTcNwe79IpznuH3CShAuWNkVmxV89vdIGVHIW+u9olvoizxD7
	dRMIYLJMnmIXEEFd3A043GkUhSnCOzQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pwB51POA;
	spf=pass (imf02.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787062313;
	b=EsYKX5VDkVLKY8dmnJL/jSj1P9Eyq0H//TY9XixaSOXm8JGgwnDQSNgBk292Ujcxf55MYT
	tHxN9Ce4oJINT9lUC9Cw6g+ZUYD81gtgxBrMgeMZuZt8N1S15PGofkjnm5RKKG4zYIORN0
	aNW0uLzXSJst6ZxqoERcLTGnyX7+t3o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1656319F0;
	Tue, 18 Aug 2026 07:11:48 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 518103F85F;
	Tue, 18 Aug 2026 07:11:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787062311; bh=kXqkJA8gY7QYt5xJT2jkOr4U63cF8W3QQZTZyl1Ip7s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pwB51POAtGP/9qCYZBXWQWGQqL5WT4YbTPNR+fmalRIg8A9w8lCJfg6u4Bm2bgTMm
	 W7iHo24RtbmP4U3VyqW/bZjJmZDsqfvOpGKTrpjMWFpE7szWiX6NfM/5GP0cAJUcTm
	 56mipm+spPi7X2YF+C4VRUn7xY23jbN4pEjzpN+U=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 18 Aug 2026 15:08:48 +0100
Subject: [PATCH RFC v9 06/25] arm64: set_memory: Implement
 set_memory_pkey()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260818-kpkeys-v9-6-743ad31b2c8f@arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
In-Reply-To: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org, 
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787062276; l=2096;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=kXqkJA8gY7QYt5xJT2jkOr4U63cF8W3QQZTZyl1Ip7s=;
 b=QZRzpO9vg0xNAfLfr8c57o4N38qqxoegwPh4n/5n23eAhC52YuP3yXJcjY7W5PoxB3p2EK05u
 UWBdF8upHmEBUF3cCh3bAeipBSKcWH1pnnpOZcM1jn9k7skm8S4rmwN
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E95E580003
X-Stat-Signature: q19yt7upat5rq7whr39mrcwhfup1ox7c
X-Rspam-User: 
X-HE-Tag: 1787062312-114778
X-HE-Meta: U2FsdGVkX1/VED7AWC9j3XlMFkIkU+Sr06IlC8jnkzSeOyOVNCbNQbFKTTj0aoP0irEj6H0kiB950ZKhk6z5UvEh4I+umpF+ieAsh54oVKojgmi100QvFjLZXz/OOVfx/vE6HSowb5wzvx6R7UZmoabrJkLeS5BvCzsbUCmCXxgkwLSa2n1SV2epu8TsgI3a7rw8QjMHllrVcVg9G6TpRKNfRTG6yRL/taJw3JL4YQhYehHZfQwwWD/RgPhB5u11e6cEO/JEyBSBhIWqORYU4h/99w8W0bzTJ386wEu2TwJhLV9wjug1htKvaJ3Dzhq9bC3SlWDvmswFVnJZMIYfiXVJH+V+QYV2jeTpiclev0l1JyAlOPJBcjhublDjBOBB6Hedwrt4QfJog+VWURiAYuTlP+tY409f9HH25S2WjGcp960uz129U41krUWdDhFfuFD1qVO3YREmMniUzYCs6ntgk5WodRCeLfqIf7M+SIpf0A+YLXUwMjeGcRAU32jJNfCd1Ux3zqdEZtEN/2Y1Vtx8WkB062DeBCr7spYJlOQmu1L8+RKaT+r5qeZEkraeJIVGy/QkI+Z3/QH7mweLiJRgfCVUNzx4KHF0E18TO/V4QuO/5M49UUuGpTVO0LOOl4k+Ry/s72H4YTWKI24dsyBpevOWfZdGyQHInZkgllHaiIvJL8npntvf1vct5bUntnhWDFwOc3T7n8arMjHCuT9NhUl6QL9N8BwRSFwAfwicr+6fqVUeSQPaFtKrXYrKbKb1uZR6CY9j5oLdVNrFXlo/w3gyVFVlr+JXJ/UJsJosLV6dH7cYV+NXZCl45xTHxdJZl979j2g5bUuRlDgg3yrONZZtsN0F1dx0njjaIH3He7Rzkooq/cqcgrlBWYwlwCj2hKtfyeoZmZygxhhxluIUtIe/Ckv7BuJS8LXZmVUutwP00GdUYMo1vIO7nFdeGDoO38vej1198Tc8Ov4
 ONlIqMW2
 UuK2cdmckDbGNUBt1XeQU+tQBs0EARSv99EkkTSLrPBH1n20y60ArYKLwVsiqDru3AcViy8L1NO9FyQPp9lNjkJEl9KI0xKAXbYXxpXWPI8TLUA010vechBMJOIy/U63861EbK8S3zQ0Rkq4PTEqMHnAvT6Z3Lw7QXKAmvCPG6Fp51BLavzpKi1nwDRMuqTsqf3LQVxI7fLDtIY+McQ9BSXPYmgjHPZWe0EiKVFQu6v6emuIw6sML+FE0aU/xScwN2xlGEI/7gkYV4ZcvVpXO535LxBD1kbwp1RcaPt3DjOw/z28BJlzKFcTfOt5XP6qEJPcLXQV9xADb5QsO/0KJnl9T1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement set_memory_pkey() using POE.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/set_memory.h |  4 ++++
 arch/arm64/mm/pageattr.c            | 26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

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
index bbe98ac9ad8c..4d79f39570ed 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -9,6 +9,8 @@
 #include <linux/sched.h>
 #include <linux/vmalloc.h>
 #include <linux/pagewalk.h>
+#include <linux/pkeys.h>
+#include <linux/kpkeys.h>
 
 #include <asm/cacheflush.h>
 #include <asm/pgtable-prot.h>
@@ -365,6 +367,30 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return set_memory_valid(addr, nr, valid);
 }
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	unsigned long set_prot = 0;
+
+	if (!kpkeys_supported())
+		return 0;
+
+	if (!__is_lm_address(kasan_reset_tag((void *)addr)))
+		return -EINVAL;
+
+	if (pkey < 0 || pkey >= arch_max_pkey())
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
2.51.2


