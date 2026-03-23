Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ED3BEC01A1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 07:50:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C79216B0096; Mon, 23 Mar 2026 03:49:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51216B0098; Mon, 23 Mar 2026 03:49:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B671E6B0099; Mon, 23 Mar 2026 03:49:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A75A36B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 03:49:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CBB6BC5F4
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:59 +0000 (UTC)
X-FDA: 84576554118.17.22F8A65
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1DF8618000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:49:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6fPKlxH;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774252198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ajZOG7Wv9bQaacjiwdfbf2cIayCuKBgmgNCXU+gOXI=;
	b=uh7rqaVKCJJFlCf0YM2KkY5uKE7hADmVSawr5GT9PkRb0n4ha3mogQiQo99qqWJMxfUw2p
	y23KdgCglWgKSpDvDzv64O3ujYcr2Q2+OF406vRDvGYJcNuO4EL79ZhHFIdNCMMEp9b7eK
	F+Zwt3RjuKOk/dkXBCDdboHpQa5n+E8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6fPKlxH;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774252198; a=rsa-sha256;
	cv=none;
	b=IAQNsxv5iFOmI9gFUoUUFcpP4x+SqGcNygCNB3ypqExUatdYQxEp6ias3kE5jsiSOpp5DR
	/49xi4OcOzW+OqA35P1AmhMrxat7RzQmxcZw2BxkysRlPiAcbjh5+t+VMeettfV6VUPh7c
	tFjn3RB1c0y5tFA+up0FBEUPTO6KEUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BAAA600C4;
	Mon, 23 Mar 2026 07:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B693C2BC9E;
	Mon, 23 Mar 2026 07:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774252197;
	bh=CusCegPCNb++eRZgEnFYAhQJhnAtG3gjmvQHWQKqyPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B6fPKlxHQgWSYzAKTM8G/WWrhZHeaeNsETUGqkQueGTMK64wv6WfUMzzorQkeopo7
	 hBHZE+Gqs69UQLXKRy/u5tAt1wOavloqFcv52lzntc3bYHhMnIBwNhwWERo67xoRWs
	 e+V1fc4IuFsAILvV17/Umo0CswXHiww2G9w5Xmd5bUZ/65HujbklLiPL0z9Ta4QPPB
	 jXAaAUCkB5sI+cmP91/5BYP+gLzDhZrZBjNKcAP9UvluKbCVPCd5xFSjRu5OWYWMU0
	 Gk6PiNYwrqh+5Y8Mj243Ec5aEbQi2bt8Ki9ITja32vtDHNFNfgb/1VhVG4vtHkAh/C
	 1xTA2fQLh15Mg==
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
Subject: [PATCH v2 6/9] memblock: extract page freeing from free_reserved_area() into a helper
Date: Mon, 23 Mar 2026 09:48:33 +0200
Message-ID: <20260323074836.3653702-7-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323074836.3653702-1-rppt@kernel.org>
References: <20260323074836.3653702-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DF8618000D
X-Stat-Signature: xko4da6hoits1jtzgocatixk3jc5oiw1
X-Rspam-User: 
X-HE-Tag: 1774252197-508097
X-HE-Meta: U2FsdGVkX187QCSXsW1rae5YZpAMyCNiH5h77QbQ04Ki9biUB6jMkt5uY+Z2TMPcUjlYt6ala8E7gzwI/AfeAEeBwIPI0BshzFkvyjUkQkMJb2/kHz2M1fFTHqIufqVLd5qTqfUze9/i5ZYM7d/J4p+Rwxe3Q99oRrO1dnn/z1Sn3xIl8uhPdY2w6ylLce+HeUQUGWkms26KD8XDxaHL5fMhUz0SSYBZAIEoERlFJhyPI26j0ddWKwmvS6E5+gyX1PQaRO8tBOF9d5pnPe8MIG/NQ9shcwT2bnTOsvAdo8ZMBW47M3XXYJunsTPvlciXY68Jh3pYmMNv/2KL2ZVs91bB9fD7DUCRh89XCT/X7PPkgGjkp/U4RGtIsGq60dc3RKbkxfN8G6LFjrBpwupQAty2i8nGjiSpDslEQ43Ma4a3MKf7HXe7lxmeDXySyrqw53gTWYcXfb6xeRgLIf6m+MB0jJ9YZOdnnJOqIioOnVe8na6yYO/XhTGlqkSOCHgUFQfdbWdCgmebINNsb4EMigWsTpmClag2QBmQWa4g8KjUjkIm+4LctBcXDiju37dItrMiED7VVhkAvhqsJeXpy3qUukpNuYbo4LZro0zmNPGOcxeC4fxNfhd+mGaU1ZDj82jRAz8zUpDQsMcVpPzKQrp340SIwFxDB5EP2WJCuRsNwpwCXr66+U110PKKeRzuG4cBxu1mTn5rxJAoql2sHmQhXzwynOobdarBc+68ceruVt4X0h8cGuOx1qL/7Ly6UT2FPCQnGg6+bq+vC7ZT2hpsYFHu4UcReMA1GSKcBWOVy/GfSNG98Kd6Au7B6TpSatNUF5f4T2ZKcc/UpHIHAf7Vx7/XxaaLcC30ZyS7vsXU9vqoqXT+yFiyrFwakaFMX6vQCJbqPSvsJOYA/dvjeXAIQhhJoXxctUbl0Ts9+4bTqPZaW+vEoSuMsSwRrrBF1tuxWPumK1b+TG9tJNQ
 3qVA3a8V
 Bs2m9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

There are two functions that release pages to the buddy allocator late in
the boot: free_reserved_area() and memblock_free_late().

Currently they are using different underlying functionality,
free_reserved_area() runs each page being freed via free_reserved_page()
and memblock_free_late() uses memblock_free_pages() -> __free_pages_core(),
but in the end they both boil down to a loop that frees a range page by
page.

Extract the loop frees pages from free_reserved_area() into a helper and
use that helper in memblock_free_late().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c | 55 +++++++++++++++++++++++++++------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index eb086724802a..ccdf3d225626 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -893,26 +893,12 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 	return memblock_remove_range(&memblock.memory, base, size);
 }
 
-unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
+static unsigned long __free_reserved_area(phys_addr_t start, phys_addr_t end,
+					  int poison)
 {
-	phys_addr_t start_pa, end_pa;
 	unsigned long pages = 0, pfn;
 
-	/*
-	 * end is the first address past the region and it may be beyond what
-	 * __pa() or __pa_symbol() can handle.
-	 * Use the address included in the range for the conversion and add
-	 * back 1 afterwards.
-	 */
-	if (__is_kernel((unsigned long)start)) {
-		start_pa = __pa_symbol(start);
-		end_pa = __pa_symbol(end - 1) + 1;
-	} else {
-		start_pa = __pa(start);
-		end_pa = __pa(end - 1) + 1;
-	}
-
-	for_each_valid_pfn(pfn, PFN_UP(start_pa), PFN_DOWN(end_pa)) {
+	for_each_valid_pfn(pfn, PFN_UP(start), PFN_DOWN(end)) {
 		struct page *page = pfn_to_page(pfn);
 		void *direct_map_addr;
 
@@ -934,7 +920,29 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 		free_reserved_page(page);
 		pages++;
 	}
+	return pages;
+}
+
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
+{
+	phys_addr_t start_pa, end_pa;
+	unsigned long pages;
+
+	/*
+	 * end is the first address past the region and it may be beyond what
+	 * __pa() or __pa_symbol() can handle.
+	 * Use the address included in the range for the conversion and add back
+	 * 1 afterwards.
+	 */
+	if (__is_kernel((unsigned long)start)) {
+		start_pa = __pa_symbol(start);
+		end_pa = __pa_symbol(end - 1) + 1;
+	} else {
+		start_pa = __pa(start);
+		end_pa = __pa(end - 1) + 1;
+	}
 
+	pages = __free_reserved_area(start_pa, end_pa, poison);
 	if (pages && s)
 		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
 
@@ -1810,20 +1818,15 @@ void *__init __memblock_alloc_or_panic(phys_addr_t size, phys_addr_t align,
  */
 void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 {
-	phys_addr_t cursor, end;
+	phys_addr_t end = base + size - 1;
 
-	end = base + size - 1;
 	memblock_dbg("%s: [%pa-%pa] %pS\n",
 		     __func__, &base, &end, (void *)_RET_IP_);
-	kmemleak_free_part_phys(base, size);
-	cursor = PFN_UP(base);
-	end = PFN_DOWN(base + size);
 
-	for (; cursor < end; cursor++) {
-		memblock_free_pages(cursor, 0);
-		totalram_pages_inc();
-	}
+	kmemleak_free_part_phys(base, size);
+	__free_reserved_area(base, base + size, -1);
 }
+
 /*
  * Remaining API functions
  */
-- 
2.53.0


