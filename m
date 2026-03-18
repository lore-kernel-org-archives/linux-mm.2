Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3596103E163
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:59:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A5B6B017C; Wed, 18 Mar 2026 06:59:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9108F6B017E; Wed, 18 Mar 2026 06:59:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7686B017F; Wed, 18 Mar 2026 06:59:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 665856B017C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:59:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1BBFB140663
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:39 +0000 (UTC)
X-FDA: 84558888078.21.A160ADB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8A4FC40010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AYu8UWE0;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJu5x2uLTjIhsDpuoLPzs71v39SAQiFydPYWvdNiy2Y=;
	b=zsQuKSQBBR+2aQCbS488UDDapF8nmvAMjjCjRTsmhjOih2vgy723AKWq7kn4DYpKhdplhL
	ja+dgyU1miJWllCwgRvUhWAhCfdOhigyPAAhdZ/yQQNdiJftLIGCeODd4A3K0dLJGl0nIS
	dR9EGZsT1dXwCIiLKpL7FcM5Bue+i8M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831577; a=rsa-sha256;
	cv=none;
	b=ESJXo2tyRrUvqbBWVbOXhgU2QtXru4fjpekSFnm55IwGXui4GveCx8GaECmBVA0l7mvHT/
	fDj0daWG/sWpzIJX0hvtbuqOhLISli8rHKfLFXPMgj20bD51Uf/l5mVt3VYdH+YnS7cv+k
	rZyRwOjLAwrJDuhOYG8c7kEJeR7N2ps=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AYu8UWE0;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B6E96013A;
	Wed, 18 Mar 2026 10:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2464EC2BCB3;
	Wed, 18 Mar 2026 10:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831576;
	bh=3jRGnlRsbxlziNoo+921sbArWCqbGJ6zS/W7kucFKbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYu8UWE0uFP7kB52RIh6t5RHb8Lm82CthAw5o2Oz3/zBoVceCs4mevcwy6gXgoXy3
	 zXfPELcxFDWWiacgMliiuggXx4CV15PRxM42zTRXwcC3AeoBO09S3lAQHEwKxmkc7u
	 S7zXJ3CpTFE4MwPOLMtCKjhcoKMWuzWjdNv96Yp+/yqtszyHDPqhX4x4WIqEjLXCRy
	 S3fvXz5m7LXo+SKILBEx1LpyBkMBSiLRc03d6ukL/MmLsvH4qH3q9/64XLA1d9HPwg
	 5R9bM+nCssf+m8rw1md06HV3Yf1v3AkdohGI5IDu5nkObk79u9DBk47nkf1xIJ97j2
	 QS9n6tdkUUzmA==
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
Subject: [PATCH 5/8] memblock: extract page freeing from free_reserved_area() into a helper
Date: Wed, 18 Mar 2026 12:58:24 +0200
Message-ID: <20260318105827.1358927-6-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: so97oac49futa1p18tc1rms6n63pbz3q
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A4FC40010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773831577-240420
X-HE-Meta: U2FsdGVkX1+KNQBQQpCfp1p1vC8ylS+3D9sled4ZSEuJdGp/U0M2lO/+VN7oF5CccvToZw20/ZNjTpzETHqXUO4R70rzbT4MCvi0WgH5gjClgkDroA81zkLxJTWmfyxx6fzENmA9O9r0MV0APnRmsAiFVGC7Dx0uBPMYBMZJizyPZMdjyGCPh8bXkzm+lzQIt6PS9ySCEctiRyLEBi2wGJRdBmh21ZZ1KL8/dMPJIn7thh3Y5WEIvzPDsuaHc77lBjgmBSVrrXy8OAVYMjz7u3Ti2UNbeeoL90MjLRE0ziN+3jkUI3jkvutvb1jaiWh/sb0toCyg0o3+tFevnlz5HzChc9Gc1QrWLjZMq3ZuEdHeIkepdwt6kA3uCUd5Uc0fJkKv/+lR1/jrclapjBZsEFd4Hyvy4wSZvpUGcPcUyXn/vXK8xbhun6B9tOrYgDpay7eq6VUhZJtmfwPxvmaEtIJ4s8Nl+JPec4ic8Dx4x0rVax7hwp10P6jAsp1QFz4fcUeyR6OS2FrnTvtyP6P1PKI1yu6tcpeNZ651ZjKg92i41g7lv9JZb8omQSlh6v93oyH8Vp4Jur6FASctMUk1+nb3qx5whT/sdpZXm+zzuw1f+WtK0b6HAiOsErtjAe1FWL7V1wCWtd/1iDHCiKgCFj2MADIyZkOnTA8U7HVlsqH7cUhgOphQsPedb+JPR3I2YK2J3Jt1pXyXWyEIId/W0vNwKsPrAG0GlzoFdnX5UypSxYM6qRq481ObpLVBFmpmzpfLZp9MJ5XzSVs4DTKfLxuo4O7uVDV8yTJbN2yBIvMY47o1QeRH1/CtxCfpawAVQ7auTs6j4oxOzOoIi1SMmLQr4MBSwAA+SYtFnivSHK6G7hwAI8L1Ih/tArnWAz8zgr4nCZg//60ok86hQj/Px+zEvVKOS2iwZpeF0ChyW3DHV2r18AFbsZLn6aGbJVHCiZIDrLwks6lreYwwNsr
 8Nlop3f3
 HsB8Fg6bkmcE5TcBgSvZ98RqHj+/eSp53RCoeDbl6WBnxoSqwxy+4Z7V9lRpsd2NnfaG0tlOV9J322CNWuWdAhBmLGwirtAPxj4e1nCEjqUGPMKz+YYdGrWO1yBvAmCTd49J+BTAI3nn+NuSmj2UfeynredKipJQ+vtZBeAvpgBBcoJoTzcKN3Fer31GrSbWThmv9tb9CrGl88mHvmOw1Y1QoKU+ZpTzgS2H1DwQ9plEujiqXQYI9Pp2IX+QPcEhyMggt2EVj7gyWUiZ1KCbH/elkFw==
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
index 27d4c9889b59..87bd200a8cc9 100644
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
-	 * Use the address included in the range for the cnversion and add back
-	 * 1 afterwards.
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
+	 * Use the address included in the range for the cnversion and add back
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
2.51.0


