Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFA7FED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789BB6B0092; Fri, 24 Apr 2026 10:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ECB56B0095; Fri, 24 Apr 2026 10:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8116B0096; Fri, 24 Apr 2026 10:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 459226B0092
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAF24C0E33
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:34 +0000 (UTC)
X-FDA: 84693612108.09.369570A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id C8FAC40023
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CaG0oB7y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039293; a=rsa-sha256;
	cv=none;
	b=nSQ6C2Un3nY2OrB/jAzQabk62lEQxhMtWmZrHuImdiF7+Jw/yyN00NpdA6QWZiXaDi9E9J
	azKWSU0qPmb/MnbCiX+kIPDqlRRCzPyUqRSEmJJff/Ryp3tFizw+6fV6gddNeq0jo5nZID
	zE1/sw5gsHsUNrS59V5HzgzBMQ3EhWk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CaG0oB7y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWp3Jh5blDNrkgFQpMnLzuCIT5hKdgCLSg5wUPxZq4U=;
	b=XNsOfoZ2ya4R4RAh9oynGpPtWQpxjzcZimZI5ayxUVqvbTWd/ifSKHNo24r4wivjtfg2g0
	w1aPXGqYHXyR5moFnn3k1ZHXZ5gqztWcK9hyScT5YKRY+2w5YYV9bS9ZqaAoU4d0PcoBoB
	byMRWkyYy3xKbtbKN8Jq4316WvzA9I4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C88A4465F;
	Fri, 24 Apr 2026 14:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E47CC19425;
	Fri, 24 Apr 2026 14:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039292;
	bh=ArDqKUGEZwiJhWfrZPmHU41Dcmah9WrzPqg0XPgBvRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaG0oB7yE/8MMkLVNptpROnS8QY0hY7zRDigwMad2xHJ4WdtE7xWL9Qy53kDSK4I+
	 vW8Zc/EkjFXCWK59rgGUEcHesVVv+GWXB6weOest7y+gCIf+ljKWTNcOkHW09GAHAD
	 fPcJPxYVJ9g7qDykJeX/fVPlBS11BRHXyzJGxNBBAO9ClIyUOFu0u+o/BY5UItOpfy
	 KOD7k7XOZkMkMqnnwxHCOmjXFqoXjCSEN0X2HwAP+tGW8z1DiPGx81VY8JjyttZGmQ
	 XDrPZR9EsX6fJwfl2Nwy+pawBhFinnvEg+H6Lmgy8aIrTEOqvEvExqFwDHdFpGqGjq
	 BCeAktUcwFnWg==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>,
	Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: [RFC 5/7] mm/page_alloc: integrate page consistency hooks
Date: Fri, 24 Apr 2026 10:00:54 -0400
Message-ID: <20260424140056.2094777-6-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C8FAC40023
X-Rspamd-Server: rspam12
X-Stat-Signature: 8nc733t7meok83zpc59ptegsd3t1t8rw
X-Rspam-User: 
X-HE-Tag: 1777039292-179559
X-HE-Meta: U2FsdGVkX1/QgptBx9tELZV+/61+GLZnh/b1kHnIeo9KtVs+UH/A9PoDcDn8XVUR0KC4i+XMB0MGOFBTruqKBgglBwxttCtn61+dBR8w+DL6KAY2jt4fWY/NpuS/efDUSDA8nyClQLwxRqiZ0A3iEmMkm1nljWyaF6iSU7PoxyLC6rLGQRFXxSnXjZJ6vKoPPjTkI8h8EGDD4ckteY9NOMgccJ3LeBXWMUGtLZmcdkPnqjFTbwsAAJVXGSxqEL0SVzi7dVB0aBOpZJWfay902su/eZ/rd+y8yWqHcScZSbN56YxhjzXRzK//oVgRgZb2LOAiV2UGkUc0iWMnxjn/g0mNM4rs2pLo7Q2kLQFJ/t2of7M1y1ZqHrsasXUp4pUtoqao/TrgT/fG5dFUUL6mWLVtDR5I6Xqj9Lc2LjDgS57iVGqEEBxNpfFFGahnIFEEszDCKn/p112aenI3fn84qiVq2czdO8DoSrowzraeIAdkGycAMFdaauzWVD4ahYKU/MBf2p4pQhMnN4YZYxQWV6T4MA0VesuIQWTEHhClOReErwRtDY8BxPGPMrMplXjgeWbmM99od2BSWUP7NM7U8GFoI9jgd/iyzhJ9tQ9y18XDjG5XLvBkZIN/AkjzzSGt0yot3Potxk838RXdAP9HBj1Ic+e+TsikA+lSXmbX9CBQdMq8bZA58KkP4YALTwiCCqb2Jozh9DuckJzSXM82ciDPjAHsqjz9tS47mcrhdEGUWuk3Y36qeqoOEmj9QAmpnBnYZijvXtJV13FCMojmZSm8FO39XxUAnI+xixE4q4hjyTg4OUgRTgc1VQcIu+T+CHD/Xh7KQD6AAgt3wZJxWVyEQU7zNLBZEbtFe00P0O46Vd9Pu7KnCf1C8tLg/gJ0QYE9ETzzL6sUvXOZO8bRgjRtfqdB1BJRsdgulvXkHfD3cxfpGeu2YNdN3G641h6szERkV/IIUGJRj4i4lRl
 svIIureI
 XNYQGONuKLPhvrXDEfi6RbYrVmU9mkH9lEBzC2f1DVXdYBC0IJRAptjHScIPn+mUorRSXFPqDrSxfEftg47BUP94RgBHqV+36LZKAL0OvF5VnStQ0Zf8LwkJQ9iAcjZYZ2JAYKi/ERisyYNq9aVnvAQ60Gq+6yDBHHlHi4Q/3VnXH+RWi33rgVvrQ0mg++K/twiggXOBdezfCHWZhEcnWI4pLUvOcO/HeTbumI9CqQ6fobLKnDrar7J6H2C22cmaxIuln4xcHN82thA3tUEmmf4myE2XCJzkyipL3zdb4uPOv+1P20ZRCek+VrIJEpcP3LG+IUUt2nBqk6J3aF3dP47YOhiVu8Hs+ynW5Eb/iDkDIigC52VykfVIBfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sasha Levin <sashal@nvidia.com>

Wire up the page consistency checker with the page allocator by adding
tracking hooks in the allocation and free paths. The hooks follow the
same pattern already established by page_owner and page_table_check,
inserting calls at the points where page state transitions occur.

In post_alloc_hook(), a call to page_consistency_alloc() is added after
the page_table_check_alloc() call. This records the allocation in both
bitmaps, setting the primary bit and clearing the secondary bit for each
page in the allocation.

In __free_pages_prepare(), calls to page_consistency_free() are added
in both the early-return path for the hwpoison check and the normal
exit path. These calls clear the primary bitmap and set the secondary
bitmap, maintaining the complementary relationship that enables
corruption detection. The free hook lives in the internal
__free_pages_prepare() rather than its free_pages_prepare() wrapper so
that every free path (including the bulk folio free path) is observed
exactly once.

Initialization is hooked into mm_core_init() immediately before
memblock_free_all(), while memblock is still active so it can use
memblock_alloc() for the bitmaps, and after kho_memory_init() so that
any memory handed back by a kexec-handover source has already been
accounted.

Based-on-patch-by: Sanif Veeras <sveeras@nvidia.com>
Assisted-by: Claude:claude-opus-4-7 <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@nvidia.com>
---
 mm/mm_init.c    | 9 +++++++++
 mm/page_alloc.c | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index df34797691bd..4d9495fb8789 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -22,6 +22,7 @@
 #include <linux/kmemleak.h>
 #include <linux/kfence.h>
 #include <linux/page_ext.h>
+#include <linux/page_consistency.h>
 #include <linux/pti.h>
 #include <linux/pgtable.h>
 #include <linux/stackdepot.h>
@@ -2717,6 +2718,14 @@ void __init mm_core_init(void)
 	 */
 	kho_memory_init();
 
+	/*
+	 * page_consistency_init() must run while memblock is active so it
+	 * can use memblock_alloc() for the bitmaps.  Boot-time reserved pages
+	 * may be freed before SYSTEM_RUNNING without ever having been allocated
+	 * through the buddy allocator, so the checker suppresses double-free
+	 * reports until boot has completed.
+	 */
+	page_consistency_init();
 	memblock_free_all();
 	mem_init();
 	kmem_cache_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 2d4b6f1a554e..ae8f619875e9 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -46,6 +46,7 @@
 #include <linux/sched/mm.h>
 #include <linux/page_owner.h>
 #include <linux/page_table_check.h>
+#include <linux/page_consistency.h>
 #include <linux/memcontrol.h>
 #include <linux/ftrace.h>
 #include <linux/lockdep.h>
@@ -1374,6 +1375,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 		/* Do not let hwpoison pages hit pcplists/buddy */
 		reset_page_owner(page, order);
 		page_table_check_free(page, order);
+		page_consistency_free(page, order);
 		pgalloc_tag_sub(page, 1 << order);
 
 		/*
@@ -1432,6 +1434,7 @@ __always_inline bool __free_pages_prepare(struct page *page,
 	page->private = 0;
 	reset_page_owner(page, order);
 	page_table_check_free(page, order);
+	page_consistency_free(page, order);
 	pgalloc_tag_sub(page, 1 << order);
 
 	if (!PageHighMem(page) && !(fpi_flags & FPI_TRYLOCK)) {
@@ -1888,6 +1891,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_owner(page, order, gfp_flags);
 	page_table_check_alloc(page, order);
+	page_consistency_alloc(page, order);
 	pgalloc_tag_add(page, current, 1 << order);
 }
 
-- 
2.53.0


