Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422DC103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABECD6B0176; Wed, 18 Mar 2026 06:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6FE56B0178; Wed, 18 Mar 2026 06:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985996B0179; Wed, 18 Mar 2026 06:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87A0E6B0176
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:59:21 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 321B5BA33A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:21 +0000 (UTC)
X-FDA: 84558887322.01.A641862
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7D1D512000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rU9KH6SS;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4TJ14scGXya7L5qIy83bRnI04jJ13R4AZwbJ8XhE5M=;
	b=3eIMs9kTgksYLHbwroLuIofGe9e0NvhkBCXv3edhSnJHdRsHss6TaUgiZEZfDOR07SNRSY
	JM0ISiRDGYwgzfy5tEOD9g/EDUgFOkMSrnDFuGdXNb3O1zbxKqVGOMk28fe9GEJwfHAUwq
	46YgXLVzHv8M/IohHtx5erDt4SjZvU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831559; a=rsa-sha256;
	cv=none;
	b=svG1M+XMwjZS6nJdWG/Lkr1ETsEDcin1M1ThEJJ/4iwT4JoJwCSStTTkf4uLj7HfLFgfFH
	DebSpJGFdC8KBfkn8sOU2mVlyZ+d9x7KCatwJNy/4XRYfWMaMNK1EPpqWPUsJV65vE0oG9
	8umdWlr+3yMjW8KbNKbhfGCBo5FEHUU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rU9KH6SS;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D43484474A;
	Wed, 18 Mar 2026 10:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF89C2BCB2;
	Wed, 18 Mar 2026 10:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831554;
	bh=Zoj4gf8i7wyLd0/obmXgnP8SmqlA2rGZ2C3jdfoF95I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rU9KH6SSU1eVwCpzSqG52mlBGTcHrnXJ5NciS3FbIP6iXmaONG7+xGMFW+GrF35KS
	 zApVxwPoOJ5fh+Co7piBNJXn3gxE+VHO8+L3iQYdzjxIlcHmmjxtFljUbD8p1qNJoT
	 z/1yZqOnDz1d497ur2v46avMjjrGtSJk9mzG1pXYvXZuFRG3crBPg1olXJFtQVl1yF
	 fNWDB+4gQ6fV+7YL6m3tMRlyfsZiQWIlpYAnNSJ2HqhGu9LvLzjynIP10m2Jc3PE8u
	 h1HkHzkZfEUXm8Q9p8zEJnkpY6RZa5ZmY6CN8WUzLeIxFjjq2BkX7EHPJYF8Wiua/3
	 UCiMaIWQPw4rA==
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
Subject: [PATCH 3/8] mm: move free_reserved_area() to mm/memblock.c
Date: Wed, 18 Mar 2026 12:58:22 +0200
Message-ID: <20260318105827.1358927-4-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7D1D512000C
X-Stat-Signature: ugcyzaj5ek8pw7z4t9f7hg9gddh1p3m7
X-HE-Tag: 1773831559-374192
X-HE-Meta: U2FsdGVkX1+MdKmF3RXcZt5fy5eyOr4nNhznG+FEFVItDx/m21v75Xm9yeN8gtUHZTX0DLNuritU5UvpaPNslYkXp3WHPFEV/cNrU6Vgre81KtsIQtUab6lk6T5V3KTulNSuDY4u0LhTLdkyL9uq2WJcv+jzvtL1sLGdFAfRJJyf88kv7qr14vXDwer82nxKfbm/UnIi5ie1YP3X9Zj/GQhsZfVKKaozNc1n7m7//SaQtwXWGLhTa6qU+da4C/kcW34U45+SvEB8o6klGGOxWkKLi5wuC60Ys4N/IZXvAokNnG/OtOeJm5q2Gk3PYlBK0UQsuNlkK51oAzEVPTUWAhHKdQ1ituH9PKETgYKibE1UmhtqNyQ1N3Mb+KCn7By3xglLCWcjUGVQYVOgE9UluiYifNdqfNrZgylBAvuBQQVutZIXrrBKEGTJlmuS7G68i0h3/ySaUc3Ad9ZNcDt3YAzSMagZAhdSxKsnSH8S+cBJdzSO7uhyajzNkYA+s5FzNCPfiVg0g7XuTDRIUh0XVloJZ1DbbkMP/D/WbCDgEgkPHj70B8iViGXlmy5zPzOGsUwTISgNKSQfLSVQQaMEAdC3KVXkjAvv2fuNZyZWvHZwV6GpMkVSQYzoOqNYk59rfHt333AhAF/KF2ZjXHO4F2iKMg2R0jmp/aMmGN5IWVdSBwnaaUKoXncsOIRNUqKeiUnFnKr6i1H5KjCZYtScH43+M0bA+Z1AqGNhXM1Y5AsjXM0/XgcLn30pIKaZrb4hF7u4QJpVvtgeng/wNqqI3RdGJreYkHVNsQ0Qt0vgCcZYKBuZEW5WxszZXiK2Ap6xe4SE9It+m9wKeA1xez94+DTepUjwnQosPeC0EZs3gZI5MBX+vjjXrr5Iwc35XYAnIHpqi0mHcPPppfHCcc15Wuo00KXHk/lJL0c99Glp1Mvi6EOw3yw+lf+3bAEcEINrKgIMLS9TuD0dUx0i34R
 6wvShips
 ko9sKeMnRssxb1P++Sxma2ycrZNyDNsHEvS5/kGXmF2MiKe3v5M+oE5551zKDMO1Ogy16D21Vf7Hl29Zfzb8Il5QPfIw76hGtCPccke0lig8KSBB84hMZpwwABg0w6Kp9pao1qWkZ/SE12/gl3wSEnOKCVi2lw/m+XkarqSL2jEAh9t8bW4j/pg5PYDwrzWEOJAqnG7rvupXWB6LU4Mhx6oJ1gmTuGQ2+3SO/LvSFpd4zqor8nyQDHPPJD1iCX/Vk3e0EtMddEstvg548tTbi7hBk/PhsD5X1AjKy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

free_reserved_area() is related to memblock as it frees reserved memory
back to the buddy allocator, similar to what memblock_free_late() does.

Move free_reserved_area() to mm/memblock.c to prepare for further
consolidation of the functions that free reserved memory.

No functional changes.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/memblock.c   | 37 ++++++++++++++++++++++++++++++++++++-
 mm/page_alloc.c | 36 ------------------------------------
 2 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index b3ddfdec7a80..8f3010dddc58 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -893,6 +893,42 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
 	return memblock_remove_range(&memblock.memory, base, size);
 }
 
+unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
+{
+	void *pos;
+	unsigned long pages = 0;
+
+	start = (void *)PAGE_ALIGN((unsigned long)start);
+	end = (void *)((unsigned long)end & PAGE_MASK);
+	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
+		struct page *page = virt_to_page(pos);
+		void *direct_map_addr;
+
+		/*
+		 * 'direct_map_addr' might be different from 'pos'
+		 * because some architectures' virt_to_page()
+		 * work with aliases.  Getting the direct map
+		 * address ensures that we get a _writeable_
+		 * alias for the memset().
+		 */
+		direct_map_addr = page_address(page);
+		/*
+		 * Perform a kasan-unchecked memset() since this memory
+		 * has not been initialized.
+		 */
+		direct_map_addr = kasan_reset_tag(direct_map_addr);
+		if ((unsigned int)poison <= 0xFF)
+			memset(direct_map_addr, poison, PAGE_SIZE);
+
+		free_reserved_page(page);
+	}
+
+	if (pages && s)
+		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
+
+	return pages;
+}
+
 /**
  * memblock_free - free boot memory allocation
  * @ptr: starting address of the  boot memory allocation
@@ -1776,7 +1812,6 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 		totalram_pages_inc();
 	}
 }
-
 /*
  * Remaining API functions
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..df3d61253001 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6234,42 +6234,6 @@ void adjust_managed_page_count(struct page *page, long count)
 }
 EXPORT_SYMBOL(adjust_managed_page_count);
 
-unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
-{
-	void *pos;
-	unsigned long pages = 0;
-
-	start = (void *)PAGE_ALIGN((unsigned long)start);
-	end = (void *)((unsigned long)end & PAGE_MASK);
-	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
-		struct page *page = virt_to_page(pos);
-		void *direct_map_addr;
-
-		/*
-		 * 'direct_map_addr' might be different from 'pos'
-		 * because some architectures' virt_to_page()
-		 * work with aliases.  Getting the direct map
-		 * address ensures that we get a _writeable_
-		 * alias for the memset().
-		 */
-		direct_map_addr = page_address(page);
-		/*
-		 * Perform a kasan-unchecked memset() since this memory
-		 * has not been initialized.
-		 */
-		direct_map_addr = kasan_reset_tag(direct_map_addr);
-		if ((unsigned int)poison <= 0xFF)
-			memset(direct_map_addr, poison, PAGE_SIZE);
-
-		free_reserved_page(page);
-	}
-
-	if (pages && s)
-		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
-
-	return pages;
-}
-
 void free_reserved_page(struct page *page)
 {
 	clear_page_tag_ref(page);
-- 
2.51.0


