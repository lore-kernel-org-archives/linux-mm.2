Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 402AAFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A02046B0095; Fri, 27 Feb 2026 12:56:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2AD6B0096; Fri, 27 Feb 2026 12:56:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887D46B0098; Fri, 27 Feb 2026 12:56:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 741636B0095
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:14 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B3605B6D8
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:14 +0000 (UTC)
X-FDA: 84490990668.16.6A96E9E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 786CD12000E
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772214972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dlkoq/xt87XyBuDDsxxtPoS7XzuVtfLvfAi4BzdnN+M=;
	b=mrRLh3q5yjtSAnN+n9ZHwxi5iE77PSqBd7XdD9GR48dHQBuoM7vs7lw0LkKt1yTD1+0PRo
	FwcQ4LgODwQ2fhLJnDAKLXjXoDDaUQg3+0PSvw+7Lfo/bAsnUEcCi/Qu+LEKrR9B6mUZrd
	owy8EWoqYzwnzuQYTFRvQ2PprQsN9vE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772214972; a=rsa-sha256;
	cv=none;
	b=gxhdlstKVzn5SrD0kJIZWuHtjIisK5W0U4Jyr25VbaI7M9nsjQquFUanCP4wuZx+qhiEYa
	NEaT61MAWyh/JnTJtkEBvWXzDEveQ3rGjzsdKqnejJ4X8eUQDgQK7cvQDArEt5fJcqqjIW
	9SrDaU7xCSXRXKD4htvRr5PR/WWIo6s=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 601051516;
	Fri, 27 Feb 2026 09:56:05 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 49FE03F73B;
	Fri, 27 Feb 2026 09:56:07 -0800 (PST)
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
Subject: [PATCH v6 06/30] arm64: set_memory: Implement set_memory_pkey()
Date: Fri, 27 Feb 2026 17:54:54 +0000
Message-ID: <20260227175518.3728055-7-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 786CD12000E
X-Rspamd-Server: rspam08
X-Stat-Signature: paun6rhqnmycmnokz4ddm6rwqg6t75bg
X-HE-Tag: 1772214972-6829
X-HE-Meta: U2FsdGVkX18qWYMqL/JOOqUqNUoDiK/1lJDbGFXhVjgToMRh34gIFT5jGbXUV6vP4aAKvTFkQ0/hXX1auHY3xuR4RG7qneNTR+hBiHjZ7Th+qBLuBCoHakBoSEl+UohSn/djkSswBBPAUANFYqPPTSAucGJLYIOsBS5SdMs/e9FL26NSzE+fLKIqKNmMb93bqLj+dOg6jwHaeHb+jAY3dp+uOgpPvY3DhTBhkwSVdAcRIUA2Sm35TvH9tUgugV2zRVaXqiedf+Tx9wBf0tw09pZ3WwcyOxre0LiMsCnOQ/TXwf+gfJERZFZiQIK/FE2fi+w+zGPKVuFMY3wPX3yUSWTm7U3SxdT12+wOSaH4yuTv7f8Ex+azh7zPOcw+FTSP4XYXqIWdlJ0z+a84dXIR1kK53oB9OwU+7nIUg6SEbPo81FRs1na74WLP0GK7OvQHu5V/HidAcrMSiDDPoyXbII94Kt/3ywl4m+953+oae6RHnNMh6hnvM4iVvdlUjb+RSHschWIJkgkfGxIxWKjAWQ4GbRl4juxvqxEWwGxE6uI1a02Z2zh0pqpk/hJk5Rb7ftV5qqUSQIinSZJYaKebwQ1J8JD6FCOzr/eJGcljItjE+tnHDhIs9/o1o8PmgvbW1EoPSQx1Y4zHZTQVyufcfq5JX0NNFrwRcnEjXPhsGcZ3Pj3oOsYGhSxnqIarKdNV9Rx4D6cV3XRijQDBhwxyaaVYk2opQi5wlNCLYwegDjpXKkf7SekAq7vzxarwz63VLqzdgf4g9/XJ29/CFISL4b+RdezhE812hjw3nNa6+g0twIyG5hNdsW7PWFri97tb3HEwC6IUoBjTIXSjsp+r/dkD5Wd/UckuLGwlIzh6ifvkrWPKLNt3UafpqLhObyBpLaHAwdHZKgBcDx+GskuJUEoD5nxL21Pvg/3YGuedRw4/dnJS7GcKWzfKoNEZF1X7iUHjwHfvRYT8oDYsozu
 vV+HaNZA
 TEa52Mw9z0njDFNOcS7s+2N3zQkb8f7vkJ/sN+6O6bQTvOlNwuh9g/yhb10jg0Njn+JxGKC1Y72UoKZ4UDx8snFphSZNNGqryOV+HXfPkVCGB7bnMH8/FePv/0AQXtkoS2g27P0dzhH77nB3cYvsCXECBXvkl63JhdYkU9+eOBt/B4FkIggRoEEJdRGJsOgHkMl+IytSTdmlaUPdKgqIU5nLY0n0Q5z+eZ+PbJbYyayOSaAw=
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
index 358d1dc9a576..d2a7e104a5c2 100644
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
@@ -359,6 +361,30 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return set_memory_valid(addr, nr, valid);
 }
 
+#ifdef CONFIG_ARCH_HAS_KPKEYS
+int set_memory_pkey(unsigned long addr, int numpages, int pkey)
+{
+	unsigned long set_prot = 0;
+
+	if (!arch_kpkeys_enabled())
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
2.51.2


