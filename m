Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18DDFFED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AC56B0093; Tue, 17 Mar 2026 12:57:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4D66B0095; Tue, 17 Mar 2026 12:57:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4826B0096; Tue, 17 Mar 2026 12:57:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4466B0093
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2719E1402F6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:24 +0000 (UTC)
X-FDA: 84556160808.18.4A867EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C89C160006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAWwrGlr;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TB7l0jZWT7HkMUp3A/cfbb943jHxugfHF5208iQiBQI=;
	b=PfoT/SYcWISGn915QpzP1If3RgZKM4K9/hHCLhd1MtyYWKcGBmeK2ZbVIjo9wMXAZDI4+9
	QzkntkvSeOrT63hLtrj5a2SXzoJJIEnvBsCQQcRP+/0hzfhP7q9AM5SczJc3G/J8OmpaAd
	jM6OYjbv6UjdOT+jGTuUdkpsnbbqcdk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gAWwrGlr;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766642; a=rsa-sha256;
	cv=none;
	b=fRl7Gr3LwMnZSQgS5G9TsWuErY+da2MtVBPyCPY9Y+fIFikOIXmNenb0iwc6/lnWF0A5iN
	04cVzYciIsNQrD4gQvSHMSOMERWgNZ6Sr7c2WdaidpFV0IhLzwJRe/n3mev0wHYN2xaiTE
	R3I50uURQxQxROWwGiyrX79SwEKIQ70=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F5A84453B;
	Tue, 17 Mar 2026 16:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE21C4CEF7;
	Tue, 17 Mar 2026 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766641;
	bh=c1O1NRiO8RPTnZL/oHNtjrDswcxNKxRxDOqUVt5f2o8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gAWwrGlrXhf6PR29TmnxH1XIh06squZG430WQjfXPZ9K5+UQvscSFqIBaceND290b
	 pABBgZdbP8DrGPOJ+eQYbpA/t8yzeNuQrKx1Z8VYJQJmOi+R6And+umGWDJe7jtWG2
	 11EC/Pf6TwUgCeNqvuPDeXGF5LS4nTQkQhA7J5uszWYQBznPLaF757+7Hh3tZO9nHV
	 hATV7yIvULtcnd00gAb1mhHJOaArLtc9YbpEPt9bF18MEzd1MFw9VrEG02lCa7ltxA
	 uuOWjjVTsrwaIzfYuDVa1RN2D+74d/6sqdc9+aKBm2mBnek7BoE0E0gaRlZAaSNRQO
	 a3NE+ODhyklrw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 05/14] mm/sparse: remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG
Date: Tue, 17 Mar 2026 17:56:43 +0100
Message-ID: <20260317165652.99114-6-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C89C160006
X-Stat-Signature: gykqpnx6b9axehacpswp54af3j3qtda3
X-Rspam-User: 
X-HE-Tag: 1773766642-203383
X-HE-Meta: U2FsdGVkX18FRgTe8xhSJgKLbSVGa5Ubx0rZ/VsbVv+12YQ5M5thQDGqWPRrwJvCWUM0t0DBkKhJjIWE+ib6z1G4ZwOC+3TOx+0lGGqTF1zt2IN0kiHY1G5lwfE2glye1o9KPANkZhbwyRrbYFz48eAkRHr2kTd2gmbVdftjoAtR22OwNIZjhZc9CxksX1j+5x5K4g6kitq54RjKHcyzzs8HRbrsJLn341P/NxON8Lbb8hcwFBkZLe620r28D/7415AUbYE0wllBgHb11nAMWRO7d6M1e9mrUbDUU4B7CsXB6o7MrF9aOwbeAZGAYpKbzXYwc/0peBQu+zSR5CJiHW5e1vitrDU9NmxEoho1nrsoahbzdFFFc139MBUWu1bsdNgoyEMAGpxJWMQiMHsGPXb9CW8c0w357vzzy5XoFgRZWFD07t2p4yz7xQ3fdKFJDi1gVwt1rsDCGGMq5zl6KwYbuOWXM/C8j16nR+vH7/VL5NXODnOIpQDlLQ6x+kA8lkO8b756s/hAfX/zpKKdaL9ZU+Bx4jRamd4TjRPBf3qC1pq+iKTzbwhjgosoau6NfviiUGSkI3igPC45R96Y83Zgk3TWkpHmCYjlklVdzBHMj7xaSOopG5oR67i/Wy0CizhMAwbxsMeg+nn4OFLjVPklO5r+PSJCKZOLi81+gEAJX4z6xUy/o4GZUkwSwbvLuDY4BmEFbl/tC0/nWWQyJcK99agX6+TO4MtaXTxhsm7pa+MGwEFvTnoKzrSPyp4yh4ydMnXjZptiidFCpoKZcCYoKMtBplftjoFRfKEhF4b+GIs3+N4aTuQ1e2lCCW+EvKZeQ4yb8+tpQY1/bqC23LjEqtuMAGkM7sfEi6ngZdQiaywxsxTHFSCWN80twaUqb/eFyPzgedHSge7pZMAy6P78rbg39NWYcN5Twq+N2YPH8Sg5B4fDvCzNBCl3JAzG4P+4J5wFzwd8QQ6/hyN
 qLAxi6qI
 6oJlS/wWrx5D7qxJFt95WpumDDhX8u0lb0kUNCH8PIHrGJdhKQzPVlT1YL0QjhzrDBhK3CNDrNxoUxWZvRzn1FHG+bd8vLuQmR1MjR6uI7Cel9tDQZHBjZRJCu2JfdA+P0TLlGqC3xXjkBCwpB4jMX6bZ2jG5+5Gzuhgu2vTOTCEDFPReq4W2miXi8Cy66jKr1p30Vy2cdyumiL99ficMyioyXYu5cpdfNCQQ3giAwfjh/WTWO2ZbHSsB/7/HTxuVyXN4Wq3P36MZd8w0JdGH+nHLWRv3P5J8IC9ghwTPEDJC4lXLwALA/E3qK3Uvszbu3uf8eCx37OsMw44=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_MEMORY_HOTPLUG now depends on CONFIG_SPARSEMEM_SPARSEMEM. So
let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 61 -----------------------------------------------------
 1 file changed, 61 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 93252112860e..636a4a0f1199 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -657,7 +657,6 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
 	}
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
 static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
@@ -729,66 +728,6 @@ static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
 
 	return rc;
 }
-#else
-static struct page * __meminit populate_section_memmap(unsigned long pfn,
-		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
-{
-	return kvmalloc_node(array_size(sizeof(struct page),
-					PAGES_PER_SECTION), GFP_KERNEL, nid);
-}
-
-static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
-		struct vmem_altmap *altmap)
-{
-	kvfree(pfn_to_page(pfn));
-}
-
-static void free_map_bootmem(struct page *memmap)
-{
-	unsigned long maps_section_nr, removing_section_nr, i;
-	unsigned long type, nr_pages;
-	struct page *page = virt_to_page(memmap);
-
-	nr_pages = PAGE_ALIGN(PAGES_PER_SECTION * sizeof(struct page))
-		>> PAGE_SHIFT;
-
-	for (i = 0; i < nr_pages; i++, page++) {
-		type = bootmem_type(page);
-
-		BUG_ON(type == NODE_INFO);
-
-		maps_section_nr = pfn_to_section_nr(page_to_pfn(page));
-		removing_section_nr = bootmem_info(page);
-
-		/*
-		 * When this function is called, the removing section is
-		 * logical offlined state. This means all pages are isolated
-		 * from page allocator. If removing section's memmap is placed
-		 * on the same section, it must not be freed.
-		 * If it is freed, page allocator may allocate it which will
-		 * be removed physically soon.
-		 */
-		if (maps_section_nr != removing_section_nr)
-			put_page_bootmem(page);
-	}
-}
-
-static int clear_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-
-static bool is_subsection_map_empty(struct mem_section *ms)
-{
-	return true;
-}
-
-static int fill_subsection_map(unsigned long pfn, unsigned long nr_pages)
-{
-	return 0;
-}
-#endif /* CONFIG_SPARSEMEM_VMEMMAP */
 
 /*
  * To deactivate a memory region, there are 3 cases to handle across
-- 
2.43.0


