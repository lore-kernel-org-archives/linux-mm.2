Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F2516073504
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MOmPHyhy
Received: by kanga.kvack.org (Postfix)
	id 1F9FA6B07E5; Tue, 27 Oct 2026 11:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15BD46B07E7; Tue, 27 Oct 2026 11:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F17196B07E8; Tue, 27 Oct 2026 11:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA69A6B07E5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:47:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48DA0A86F9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:09 +0000 (UTC)
X-FDA: 85368834978.28.D1000FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9426118000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:47:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOmPHyhy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBhFJBIXzZKs7ic90QOOI2QxO1Yk2LoprMTQRNyieMQ=;
	b=Tlv1dFXjP270JyIw6I2YiIuqP+EajzPXBW0N0x0nlukiP0pAvUkTzDjybCHaIDFpQxqXAQ
	4A9pEW+xouLvhkWpFQhYXD2ailHq0tsgF6LBwGmFlkIZnhnI8pXZEX0NljzMFgMtWQbI0D
	ornvI6OLJBXKbaT/0ytiCJVUbzxTQ44=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MOmPHyhy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116027;
	b=VXh4mUPRzvINQdMfIDT/bV4V1rVPlXPQn/RWMaDmp0opvZcrOt5Xe7jajveIWcSwG9C4l3
	mzbtlkcjAY6Raj6c+vwAMRgjU7E6zsbE2xqZ0Kx1BZpY6yoH5eYXz0OQXJNGiLF65yQtok
	N83hhHxFqpuoDx7C/MaoedSOrspfYuk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33CE860A6A;
	Tue, 27 Oct 2026 15:47:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F751F01148;
	Tue, 27 Oct 2026 15:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116026;
	bh=EBhFJBIXzZKs7ic90QOOI2QxO1Yk2LoprMTQRNyieMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MOmPHyhy410bFWXBSTgsnh2lp8jIVG7tZ4/FRCYWazxrzUPJ/DjI4LUfGghjtOWnN
	 FBQLj4yh04sFykpSdnSXXnNtpHiXHQSEgQ3KdQS384X9n7i+R0czvDWxkmyBmYo3ss
	 ODM/ZwVaIcIdNnonsCCWXV8JAYEEaT1KWRABabFmrpNtXiab5fKRUn+R/4guo+cEes
	 GbxP1iS8Nc/MBtPXHVUTsFGOFjSOaV1s8VNzwsgCsfuf+UIs93+1k1NSN2INFCECDB
	 l5l7d8uDk7C/6810kSXLcZ5VkLTIq0XXorVjjWIaxS4qqy8Bs8ajrvckDyLZMqsc9K
	 mah74uHzq6Emg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:35 +0100
Subject: [PATCH 9/9] mm/page_alloc: check pageblock pfns under span seqlock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-9-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9426118000C
X-Stat-Signature: 84ajzht3wddjqxxqgxk9utouu7t4z6qp
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116027-701187
X-HE-Meta: U2FsdGVkX1/D1Kdm81F8Z03K7N9+4PICwpyz5T26ZvZ25wBMiN1usCsntMqd0BxIIKWrGXIMhtXAUYN2tpRdhraeYingU8Q+vxWL3tGu+1Kr4WcPCM3j87lsKQ3LC0n4TQxjPp75R2idysDDNurxgwxgGYLr9FdOhH/55wPApQMZpnNg13Tc1MB7ZZ70Csd/30OlG2S1NYVJ/C606xNg/gpFjtXuJGmL+nPr4d79Rm+n4+aHbFibJ7iBftPAn3GzosYGwW+earMEIqAWNKPnTkdyaZxZ+ftBsidjorx2YJPiA54m3fQlKMMU/fuPC7Zxjhy3n3mZ4uNqmyq0iPPEP7cjuAEFHvzofceNjM8oxgy9rD0Xh4/ywCw0Qs+q3WIrRmJvVlbVgi+VADAFO1d/eKBInuD7xmLmNhMPQ4TZLOUGkxWhR15DbX3iRWcuIw5LdMxVfJN42CxiE8TL3BAJZmfyDpQwkLIMYisgeuTjk8rFf7TMZHZ83R4i8EBZwVm3jUM1CYYXyOwWFY5KkFWn8z9yTVcFMNw92aDVjiH3PPCRRujkjaAIYCqhQyPDfRMpHYHxdPZLsagOQzaig5fa47AufiRQ6iegbGfplhlSbClZ/1WDp+KwpANW8YwXWtrJP0E4w042VajnWDt053Lm7OOE1BrqadtH4l0xx18dEEE0tbsiGsOuvVlegRsfELS6AGk+HfTlp/jq0GK1L+I4AfnJuw8cnA3WhxY2W9+nUdBXoUwNUNY5F+qRM8s302Vq6rEZ3AcWMP2z/4+SnyXjN3BCSVqPC3FAXg9T61Z1eJM/as77vXnZ8Sm+QbsVxd+m8t69V1dhRDIimqeRRTtPKEYwVwG58Spc4X6X8hXqUb9mBA4Cix/Ib0PKmhPvHcjlPacuw0p44mUAOq5T9HCPJVbksAjYIuLHhgfAZrq+xU9qN/KV5FIxMVUHnC1VlC5HFQVsdhCInhK8JCLM3Eb
 qnEso538
 lEjbDUVkuUCuQiwWHDZQIEcwRvzVbm42a84uE4Zr1Rb4EHUwwRj3rXea6dGTAmEKd0tSJg4o3KTsIH8rG33yoYRH6ZMiWJSw8vycldKoGVTTOsBBmEWHlHmIGCbz3pyDyLZDtTnJoANGNwl7URPMUSWn+DkT9ompS4lqLfjhtQBNrmeN6F0WBaCN57zUJ0q7emQ3IuQbeuyD8vFRLbZpRTWg7qMZW/usp+NIWgglKwFSqqGF/M0478iAncnOu4vTOPk2Qz3qowvXBPIbXYXibhpUJHEZAcMJSbp3pEkorUkgPjrOoVqBWIVTpYaVDxVclAUfsKo+qEgSVRY6tQd06I/a866HL858dG36H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Whenever the flags of a pageblock are read or written, a kernel with
CONFIG_DEBUG_VM makes sure that the pfn lies within the zone of the page.
Unlike bad_range(), that check reads zone->zone_start_pfn and
zone->spanned_pages without zone->span_seqlock.

Memory hotplug changes the two fields one after the other. If the lower
end of a zone moves, the zone seems to end before its last pages in
between. A page of that part which is freed at that moment, on another
CPU, ends in

  page dumped because: VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn))
  kernel BUG at mm/page_alloc.c:372!
   free_unref_folios+0x55e/0xed0
   folios_put_refs+0x2b5/0x530

Read the span in a read section of the seqlock.

Fixes: 86051ca5eaf5 ("mm: fix usemap initialization")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8f8885165045..f7bb0d59efc8 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -357,6 +357,21 @@ static __always_inline bool is_standalone_pb_bit(enum pageblock_bits pb_bit)
 	return pb_bit >= PB_compact_skip && pb_bit < __NR_PAGEBLOCK_BITS;
 }
 
+/* Memory hotplug can resize the zone while we look at its span */
+static bool __maybe_unused zone_spans_pfn_stable(struct zone *zone,
+						 unsigned long pfn)
+{
+	unsigned int seq;
+	bool ret;
+
+	do {
+		seq = zone_span_seqbegin(zone);
+		ret = zone_spans_pfn(zone, pfn);
+	} while (zone_span_seqretry(zone, seq));
+
+	return ret;
+}
+
 static __always_inline void
 get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 			   unsigned long **bitmap_word, unsigned long *bitidx)
@@ -370,7 +385,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
-	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
+	VM_BUG_ON_PAGE(!zone_spans_pfn_stable(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
 	*bitidx = pfn_to_bitidx(page, pfn);

-- 
2.56.0


