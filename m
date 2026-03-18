Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F913103E163
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA5546B0178; Wed, 18 Mar 2026 06:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D6F6B017A; Wed, 18 Mar 2026 06:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92FC6B017B; Wed, 18 Mar 2026 06:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B8E5C6B0178
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:59:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45DAC140677
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:33 +0000 (UTC)
X-FDA: 84558887826.04.3B2C545
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 97F21140010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tiqHuDff;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCxMaYBsBxXFKDoyhHps/O9S/t9DBe65sUTVzz1X8nE=;
	b=sDT5fkI5GPqM9p+7iNVn7TnRZKDGxQI7n6BoXzkaiKtHlFFcsu4AO2C//sxDj8RrU4UpDD
	pl4rMB3T1v7lzXUqKz6rATxTga/mikE5H6KELzoiGlmIib5Nu0mmKq0Gz/bSkI69Z+Qcmg
	O0kM0Dy1DB5Jb/UPTfBDEU29OR2TPN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831571; a=rsa-sha256;
	cv=none;
	b=jbuAkNS85qHXKiWfS6RkFnD4IhbV1lpZoz7EOichMMsY3lvVekSXqKLP/mqldZpxJ161LE
	ELx7gpvkIjr0FcKfLTFhBKPAxIZ8sfY6Arabppef7AF0wYlhgQDuHjLqKI/AJ7/0yyM4DV
	Kni+UHFG5TqgnPk81Basmz/TxxzXQJ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tiqHuDff;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C1F6643BDC;
	Wed, 18 Mar 2026 10:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39407C2BCB9;
	Wed, 18 Mar 2026 10:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831565;
	bh=EMwQwmstIDHc8FNs0QO2SlPHAkcDkrQ193OPS3fBl+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiqHuDff+jDdjfstb/ZYgq2TD5ZpMwcm65UNdvRfRBe8PAN3icqQumgjGf0jjMwOP
	 j4nc/ZDV4yAotyjkmHE/A3sTeQSiHgk4XGbx+8PnfOEVuotW+6DjC+n8FzEn0N07ex
	 xwVTZRvNHJmzO1cKw+KDDsxpa6ivmiuE4M/gWBYWIPYVlHgBT4kKgBSZEAuXMBjlX5
	 77Iul3JgDJt2CbM/2QFqakDPRN1MY9jKIxjxmHZ2w5mk+/6blf8d902eLpySGRS5tT
	 qwiMpZ1OvhQHOtEQggRNLvjuWaF43Qy6zBz0ESnJrIw7OmrwuwmUImSs2W6tHshrk1
	 mMgjbGI9FPdTg==
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
Subject: [PATCH 4/8] memblock: make free_reserved_area() more robust
Date: Wed, 18 Mar 2026 12:58:23 +0200
Message-ID: <20260318105827.1358927-5-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 97F21140010
X-Stat-Signature: h478n5m9rpdna7wwxiir4qu5srbf8cjq
X-Rspam-User: 
X-HE-Tag: 1773831569-363430
X-HE-Meta: U2FsdGVkX1/RP5GfdSJqNRtQ5zxf2iWiV0B8Kqw5vaiauGLly9OGOI+7BZZl+G5sovl0g5Jy852Ofg1145vD98UFzz0CKWAvXvHcgpFYFBcVQRjfu+UeGjPmNAXusg6La4xzAwdSGNhePWfBlppQ0TihIm1VQnZKGeqEkdJkL8moNLP/gPRTIEmu9p2HBvQJnPVtNFkq54JTd9bU7aPcl6/Y50IlUtyJxQZesGFvdfQ9xoEkKsheMI/aHxGQ/s/5eB11GNOZnB00YJOAk9BcUcdQUt3tXUyeKQGv5WyTEKMvHsOD+FC7ICduGl/i+6cYFgS6iTSOg+jV5cUkr15G5o/q0oLVtVN7NwnrHPaWaQXAKsHC1c81LmKtGgJm/CLXyDmzF31XTKhh0smxh6+ftGK/8qbTbch7k344qRuHbGJDyDjjLMLfAloT5lsghLy6BIVVWTIAW6PuyXdFNxqdqww0xLVacd1IRYIAfZu8ibX5frlLjjKEKXQvE0khkaT6w29XuBjHfhnMTqvAqfoVouYnrWne+/KaG1q5p2xf8Qe7rWryt+1Pmdsvb64+6mNjGWoIjb+Vn+UiFppZ6//4IqdLmFqZxBwHTulUhBl31uFmT+E+X2Q/YBB2SqVAA5Yb6G5iRglg1rCnTy3BUSLFo15cbGK0jnPlQbA7TYNJ9I5VRQtHUEqsAkN5JkWis+xyARVOTJCKU5rZgUVDMTSL1R7E+YOsWDo0PKQa+q0lxSMXG4LcLueNWpiLXg2GrhyBvtRdEEHOXHY8X6+9bFwnBhV2tpaTy1S4DAsa3F1mFTr+maTo6eQLNKfkjE64hEqh4/5wRhiCcJE2FHdiEKlY6DsM569LoT1ZLU3Xsky5J8Qmm7etWmh/kdvcO6jHX/GjVk+iXIHN9VxjAuu5Dytlpln+JYlc07Hn3igKnZsK1cXoDJIZmMuH35mcl7qgV1tjRpYt59+aAaVq0s3+WQS
 rVdKHq0E
 6hTw/Oygic3dKJ6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

There are two potential problems in free_reserved_area():
* it may free a page with not-existent buddy page
* it may be passed a virtual address from an alias mapping that won't
  be properly translated by virt_to_page(), for example a symbol on arm64

While first issue is quite theoretical and the second one does not manifest
itself because all the callers do the right thing, it is easy to make
free_reserved_area() robust enough to avoid these potential issues.

Replace the loop by virtual address with a loop by pfn that uses
for_each_valid_pfn() and use __pa() or __pa_symbol() depending on the
virtual mapping alias to correctly determine the loop boundaries.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 8f3010dddc58..27d4c9889b59 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -895,21 +895,32 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 
 unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
 {
-	void *pos;
-	unsigned long pages = 0;
+	phys_addr_t start_pa, end_pa;
+	unsigned long pages = 0, pfn;
 
-	start = (void *)PAGE_ALIGN((unsigned long)start);
-	end = (void *)((unsigned long)end & PAGE_MASK);
-	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
-		struct page *page = virt_to_page(pos);
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
+
+	for_each_valid_pfn(pfn, PFN_UP(start_pa), PFN_DOWN(end_pa)) {
+		struct page *page = pfn_to_page(pfn);
 		void *direct_map_addr;
 
 		/*
-		 * 'direct_map_addr' might be different from 'pos'
-		 * because some architectures' virt_to_page()
-		 * work with aliases.  Getting the direct map
-		 * address ensures that we get a _writeable_
-		 * alias for the memset().
+		 * 'direct_map_addr' might be different from the kernel virtual
+		 * address because some architectures use aliases.
+		 * Going via physical address, pfn_to_page() and page_address()
+		 * ensures that we get a _writeable_ alias for the memset().
 		 */
 		direct_map_addr = page_address(page);
 		/*
@@ -921,6 +932,7 @@ unsigned long free_reserved_area(void *start, void *end, int poison, const char
 			memset(direct_map_addr, poison, PAGE_SIZE);
 
 		free_reserved_page(page);
+		pages++;
 	}
 
 	if (pages && s)
-- 
2.51.0


