Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7272107760E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:52:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DA96B0332; Wed, 18 Mar 2026 16:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F56F6B0334; Wed, 18 Mar 2026 16:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B406B0335; Wed, 18 Mar 2026 16:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE236B0332
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:52:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD2281401C1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:52:40 +0000 (UTC)
X-FDA: 84560382480.26.AE9B54B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 17B111C0010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:52:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7zvu5MI;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773867159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0KbAbSrDD+LwNPPQOnmwucCZsjcovNfZ7tqg9JQnkM=;
	b=PMgn++Hvx+rYBDxoNe4IXsc0TaU8wMUUiefJM7Qd+j8D2VL4kGLANm637Wl6pt4PO9dMQV
	am5NqMRrN4nODgq72t3VAMW4P/aCGd58sYFESIz2EN9byl9lKY1gKykW/vc0uNJ0rTzkUt
	5BQSwGRferWt4SGMn0X1oNpwGsTXBHM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7zvu5MI;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773867159; a=rsa-sha256;
	cv=none;
	b=iw39wM1+kPNiLhHZ2cp7RtHv4B7f2gyi1ODw1ecebFkD1lKyIq93Ful1DjXwKm7W/H80vY
	LlZ1eNzDCSKnXEfmeGxZcl8X1YuLQp87VbP2qlm1IB/a/T7tpT1Ev+W363dfodM6XmNIhN
	uKVYcgZpDuxNlPIo7KM3/M4HgkWElrU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3D39D6011F;
	Wed, 18 Mar 2026 20:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF7BC19421;
	Wed, 18 Mar 2026 20:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773867157;
	bh=kbGM3c4xh2xtlPKItuu8b0plWdnAptUOEmkS13CYnz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7zvu5MIc5CYIGmjWx+P+mS8/hs2GooJWHfXhDPqFeWyum4sz6NQ2neYQyXlUtlCv
	 SOoz9lLS4EQYDGViVf0oRa8oUQ4wZWHCy5DjVMkrRZlzhDZfSxX8btIRC6pKKcZtqq
	 HqFvYKZdPu6NZcu/RPV8yxBpMtnFC8Ki3vcf/rOBJrcG5AcAzdMR2gnTomxyf7IP8H
	 zHZMPsz/wlq4Amx6dQtpM7EHwIuIilXwCtH35+nfGyIdYuPry8qYRVdyy1g3sS3ITk
	 esmcmpAq0Qm7xqoPTPtpTIaBIFFTr4xbzEGttviQsDf6G2SgDxhQSQi5C5yhB9KCwG
	 yOFQuYZFuGWzw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 9/8] memblock tests: add stubs required for free_reserved_area()
Date: Wed, 18 Mar 2026 22:52:21 +0200
Message-ID: <20260318205221.1402161-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 17B111C0010
X-Rspamd-Server: rspam07
X-Stat-Signature: axqtfknudq69wo3xc881fepongmcmono
X-Rspam-User: 
X-HE-Tag: 1773867158-134539
X-HE-Meta: U2FsdGVkX1+HfWU50UwDuxEx7T5k0hj3Y2bO3+RPd7rZjWiI6zb0QnM9lScqBxfp/svYZ7ae91sH6ReAaX0tZeijQpAk0P5VKmLDQvmY4Cl/hYnKoDuiXBUk6mdghuJGI1UhWGZmQ718uAzuxebkEU8SmQAmFiSFD9cW3zqRPTcuS220eLN88Tf26d5HGlCMwRw2EdHm4GPnWVyi/i5mKLbuQ2KHZrdswWNfzQBxF8eAy3R2IkQ3vZJL9kfQhcuxdngPMSeBlfNMWLqAA624J4Rvxw3MEqaZ/FDLNucHT3yI7zo7g9QHOv2BGxwmKa7QURVxmNRirpstESrxkZd5tUdymxbKQ3vEQa7F0HZLZRPiN7tKWuhAkgMbHIZtOlauEhGCkTmPkQP/OqPw8EA29StI0SGL79vDRofpbw3VfywYjnHrkWgNBN7kZZrZFOiLIzSSPnD5rXhrhDKm49xebABMBBH61rlMb+fIUQzQ7VDvy1gmYDKg6C66ejBQuvz2JeSW/RpyUYQWDj1JbnlSKaN37fJ1tQQrIYTM9jkfR9vCF0OigpQcPeQhGzd0HGaowOdmnz+z/1nLpDAKj48qPYhLhZfJmQ+HxLgEGjG4/P9Cxzp4r3uSJk3I3NGOEq+fvDdtYe2XA56fLv6jT0BWpfkcOoX2gv+sLAgFO3DYFS98JmPtR4niVBPGfobtChUWE8ZhPUnzwRMtuJMGDv/B3c4Og4p4Q9sKFw2oARMJBqS0RVaU0e52jgaVDxiYfPt/HWI8T4glyL8isDRVgifVjXE+61uhEKYI2m/vcu4ZV4Mh21/zBiS/Sq9iKbHcVxXbZBidmUNCfpK/5G6V+V4Wkw3LELQoEmOm0Ft3IWfeda0KOOjjCnBO4UT8ct0RMfNKO0LXjlyALTgdmB+jeTKSSZcKBI4VpAikHowW+A8QeCZ6/U7EpkPP1uDdDAHvV+AJZahrC4y4vXl5UdG9rGy
 dyXmg+IF
 1kFIvBsK8W9RxDs6ap3qJvE++ywWMUXuz6K2ZCrpwXAFKcTMg3Y+D6zSqloK6Id/KmquV5t0GQwI5Bh59jbhHLShLcAJLK4AG3MUBv2uMGJrGYch3YVGwfKYJpha2qkSYfPN3rGjAnYPOLDC7nDKeNo1LueujjtieF2BudnBFicijFOOtn8QQuKzXXK+vW4c/c/9KWTNSqPQ7YOHN8cHSzmpHWO44ZZxkO8xUXteJq/jGlO+RUN4MgUxP3BtWQkOixKhO7Rm9xyFtPiLMp6zhLBfo6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

After moving free_reserved_area() function to mm/memblock.c memblock
tests lack stubs for several functions and macros this function calls.

Add them.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/include/linux/mm.h          |  1 +
 tools/testing/memblock/internal.h | 28 +++++++++++++++++++++++++---
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 028f3faf46e7..4407d8396108 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -17,6 +17,7 @@
 
 #define __va(x) ((void *)((unsigned long)(x)))
 #define __pa(x) ((unsigned long)(x))
+#define __pa_symbol(x) ((unsigned long)(x))
 
 #define pfn_to_page(pfn) ((void *)((pfn) * PAGE_SIZE))
 
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index 009b97bbdd22..7ff61172ab24 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -11,9 +11,16 @@ static int memblock_debug = 1;
 
 #define pr_warn_ratelimited(fmt, ...)    printf(fmt, ##__VA_ARGS__)
 
+#define K(x) ((x) << (PAGE_SHIFT-10))
+
 bool mirrored_kernelcore = false;
 
 struct page {};
+static inline void *page_address(struct page *page)
+{
+	BUG();
+	return page;
+}
 
 void memblock_free_pages(unsigned long pfn, unsigned int order)
 {
@@ -23,10 +30,25 @@ static inline void accept_memory(phys_addr_t start, unsigned long size)
 {
 }
 
-static inline unsigned long free_reserved_area(void *start, void *end,
-					       int poison, const char *s)
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s);
+void free_reserved_page(struct page *page);
+
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
+
+#define for_each_valid_pfn(pfn, start_pfn, end_pfn)			 \
+	for ((pfn) = (start_pfn); (pfn) < (end_pfn); (pfn)++)
+
+static inline void *kasan_reset_tag(const void *addr)
+{
+	return (void *)addr;
+}
+
+static inline bool __is_kernel(unsigned long addr)
 {
-	return 0;
+	return false;
 }
 
 #endif
-- 
2.51.0


