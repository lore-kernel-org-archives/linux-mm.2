Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472BE606D81E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tdms6Q4U
Received: by kanga.kvack.org (Postfix)
	id 5522D6B00EF; Tue,  3 Nov 2026 11:17:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52AB26B05B3; Tue,  3 Nov 2026 11:17:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467546B05BE; Tue,  3 Nov 2026 11:17:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28F4F6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:15 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A89BB404A8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:14 +0000 (UTC)
X-FDA: 85394312388.15.DE64E8B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id E694D40007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tdms6Q4U;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMZMvZpZdtJea8xxGpJL71ybZyZNgDny+0BeBBkUktE=;
	b=a4WB1WaawKsdhzrJZBRp2IMfMaDapHvPEXhafkXLnYqTWpp85dUynFe1kwjTuw4uWGZ8B4
	8Ilme7f40z1FnyvAEPMPCexF+jqRtD/vpgO6Z9m0tGUsRGTwtg5DvcyUzPHV722vvFobi4
	yf01D1Glfw2TsImg3ofHF2NjUj2ZRCw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tdms6Q4U;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722633;
	b=AIikaqUKWBAOTGsF7XPhvim+pNwbrQWwWcbcknF5WOn7HOF4Ru0JyCSP1/OVxk3xEOWVcW
	AfBb99Fbuf5UZ68bWlH0mbkb3q/ZmobYrGWid+/flv9AcLRAhrCNhh+a2ids3d+J//6pwM
	0oHmxz7+TpHqRvYsTIwgOT9TY1hXx6Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3012B43C94;
	Tue,  3 Nov 2026 16:17:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF5081F00919;
	Tue,  3 Nov 2026 16:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722632;
	bh=FMZMvZpZdtJea8xxGpJL71ybZyZNgDny+0BeBBkUktE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tdms6Q4UWHlY9evtVY26SY666VGRVDiqz6LOSvJc2XVieo0g+lhSmUBzTmQK0fXOd
	 fs8FcsZXidCPiB/D47lmDgTEmthu55EQ0+xL56qqscDdUNxWCa93gezbvp9vf75HvF
	 HkNBU/0CnHTwEJpCZIyk5tdQjzaya3iUdUungReDLqKAuhBSqcrxk/7b7zbO/BBZSS
	 7n4Lv5ORNf/E884FHGRmdnjAlQpXXBRgEczHwZT9DMJ08BHBaBZs1OncwCXzIlMckR
	 hBHQT0JXJ9eIpkJYyVXE6M3ofBob9vMk+lNYjZmX7PsWxu3R4WaZ6bF+GWGsOiqeDD
	 fhTKu5jfv4cxQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 03 Nov 2026 17:16:51 +0100
Subject: [PATCH v2 5/5] mm/page_alloc: remove the zone_spans_pfn() check
 from get_pfnblock_bitmap_bitidx()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-pgalloc-ai-hotfixes-v2-5-e0d2890ab74f@kernel.org>
References: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
In-Reply-To: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Stat-Signature: 6p1wc4yxkbcqp3au8si76e4ts91judg4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E694D40007
X-HE-Tag: 1793722632-230736
X-HE-Meta: U2FsdGVkX1/KD40Nnokad4LXb57D6ehHWSYoJgEuwEC0UE4IANioefmcefVuXSUefGY8UF0/ZQUrIeF31+/xPJj9nx9NT56nATlxerZOBHGXwJag3Spl515xdKUTdDgJ+PRS5fBjPpyh3UnDLYFnZoZOa/mpt9Blee9hUXSf9QEEkpLd3q4aRCqGm0h/QH6Zkr7GDFKp8nPrrEcyFbHjWSyJlorItgUAzspaRGM0KtBxNYiA7kueku5cr2Ja1ZMsE7KLu1Wl86pKuK53xzU8HICgy8sWb85sU1RFQP+eVp1At8oQnMVjTOHRNj869V9KwRHnS3RYW1WsP2FrLwTfPscDA8STUH011FPeUQFX0O5NdomnajqKBDIjTlxHWbOB8czjCimwyIyuUHsa5sbhQxRB9hnouaoEvrDzGEYj5CM+5lJ5VwQzGHa1qTrxdhZ7iNJUIXC2lGnhEMa8DW50lUyj2CsHC0YUOylB84wVPX5nwVTXg2Fz4SWrgt3WWEPRjYCEQ4q7qoKmB+N3nHtnDSvBVPGqC488I72DWLcqoxOW2gOIUOYjSZaUwYJq/A28bbVbzZoGeM8+8eciyxYXLHNjB0Ymot2C2OQ1kfSSO9DjEePCAp+qGzsO1sIGmfqMa3emVa6BRye/iazFRg1SlMXCaS38AMNn9XPzWIOVKdX6x8oDHu4JUQRD417i0t+6mrfw2wz2SSFXAe31N3+zQwggvVEam7L9Bznd8cS5z3IjIgP/zEITqx+C1Vws1Hc+Ae6q0Tz8EssEcuAE/z+309q1SJjNGd4eROdJVUzVsCY9PJR8WJ7AEaOHMCGehQM7CwhB1sqtUsV2/muOjMcbrptyD7Yb7Un+K4SvTH/sL510CUQRTbKbnCAfDUzzdw7GR3vhAMctBbBM8ggZR19ACXXi0wYw57DCY+SJTG7aU+zxEk6KgJ9GMo810DvWaEkA4zKje3Ikim+YEcmo1vV
 QgwjDXjT
 zezG9aAHkLQdzbcp1DTHIwRlcp12i5DI2Vv/geIKaGkmHyh+A2k+n2szDEqYyPoD37VuDMYrwNlHFdjpRj5lWJH1nP22+50lU68Cp6R729HU+z1uFGtsBPQkETqLIJPaGfD8uedFJlawot0vBhUBd1kXhZy7QoxQOKAl1UStJFvXT3+iZLlRmBkIFYvrUFd6yY5iTcCaqYxTjZAtEpcpWj7YqAMVTWCbkpEfnWi+fQ4b2XpIm3C1rSt4oY1qzQShEQXfohgF1GqPCQ9G/cZQdR3vyGDP2OTkdr3e95QpNyrv2T0IAwUo19fBjG15ecddjd8OIXAUrS5MkAjRDOXd7EyWraLC2y5Khn0No
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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

An attempt has been made [1] to fix this with the span seqlock check.
But that can trigger all sorts of problems in restricted contexts, as
noted by sashiko [2].

Since this is just a sanity debug check and anything with BUG_ON is
frowned upon anyway, just remove it altogether.

Reported-by: Josef Bacik <josef@toxicpanda.com>
Closes: https://lore.kernel.org/all/20261027-pgalloc-ai-hotfixes-v1-9-9c7d1aca801e@kernel.org/ [1]
Link: https://lore.kernel.org/all/sashiko-outbox-188081@kernel.org/ [2]
Fixes: 86051ca5eaf5 ("mm: fix usemap initialization")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 41fd80c0c762..3a7b9b533368 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -370,7 +370,6 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
 	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
-	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
 	*bitidx = pfn_to_bitidx(page, pfn);

-- 
2.56.0


