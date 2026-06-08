Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D669CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C17136B0095; Mon,  8 Jun 2026 04:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE986B0096; Mon,  8 Jun 2026 04:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B03D46B0098; Mon,  8 Jun 2026 04:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3C726B0095
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:34:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 43ADD1C2B49
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:34:56 +0000 (UTC)
X-FDA: 84856084992.22.72CB019
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0945140009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:34:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GlvlVEzX;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907694;
	b=vIrqvCdAYVgn1gOvyB/JE+nZ/SUOdMy/8se+4I7WMWZV8licy1ZBIZ3INJLWC8vk2pFgYl
	qhIcponfGTwsDVhHAyQ6vxy2VuSFNAY6ADX6QuSaZhWVHJWeiuEYcctTxyrmIqFteJNELm
	HjRGL9QFjAHwLeKT+Ztup8hNrxg4jbM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GlvlVEzX;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BG5vFIZuWkBfCpPnsH5jvRyFO8VXn5agYH6VILwADzw=;
	b=I7KYZOlmRlnm88I+jySNaBy4No3YlEUlTq40IUWp/CQ3M8YYuQ1Ur0K+a4a3WjYIzIGLdS
	IIIlwxx2X81hKkNNm8w6MI6RdsdGdKRNr5BRYH6T34b1VfOTRD/CFH/w5/dO6aLx74HksI
	U3yHRBaLOFZrFElGduAxOei+8bqoaIs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907693;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BG5vFIZuWkBfCpPnsH5jvRyFO8VXn5agYH6VILwADzw=;
	b=GlvlVEzXF2/x4tTmzwSSU3dKXk6YHAkjBM2z8Zw5T/FHg8lI01TnFdXVANRpFzkIHpNJi8
	GAyxBUdFxcEeY/sAxJ3uQDEZcsgJkgeUUVS6X0mQpXs4xbMWo2h97zIxB95f3Lw2432TOs
	9mwSM31G34DNB7h3qL2G5NZdlLAOfdg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-586-tI7OnRu4Nci3CpHjnSoJnQ-1; Mon, 08 Jun 2026 04:34:52 -0400
X-MC-Unique: tI7OnRu4Nci3CpHjnSoJnQ-1
X-Mimecast-MFC-AGG-ID: tI7OnRu4Nci3CpHjnSoJnQ_1780907691
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490b2f22ea2so42614065e9.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907691; x=1781512491;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BG5vFIZuWkBfCpPnsH5jvRyFO8VXn5agYH6VILwADzw=;
        b=JkpKhZdCJ4qNJVid3Djf5IHCrXBfhkTtlYD6GDgDe+Yc9eXddXMBJrq52xiNHQ059k
         8lQE2Q+OZJdtiluxyjgJuZRmDmPDqdFQOBKn3bKkAEifnCgn+xXhsZ5eKLGMG++QmYQT
         lc2i68jVjzb9bV7VnpBI2R4IXxMR9YcsuQd9nPG9MjuYOdYODBpnh5LoD050CgSFDIRB
         Q9BRXuF/HqqFpX+D4TnAu9kIyqcdUTu4lXWC79q5bmJuZud/nsR7Q3RpHbRn/YWOs76a
         UbKY7pyp39Y1rqmjOrDrYQrfnRHXZPa+Y25/LpfT0nmyHP07JsWynq6xEvvWpALYZ9Hb
         vVzA==
X-Forwarded-Encrypted: i=1; AFNElJ+dm2LLCGORGuABnehjNfz1mNmlOrZpPtdDombpm5QL73OmUvhQQ9rcEbS62UEOlg8Dp54ii/H7kg==@kvack.org
X-Gm-Message-State: AOJu0Yymu9Auk5DyhVg97fz0+1OXqDDdXUYyrZasDYLFunJPG93S8mr1
	XN4LOTQzTF2bOitYSaPCiPbt1TeTBXYwzZ923PZxSI0RjTd6JJguczdxS1G21MbeVf1iYIobIBq
	iBPcTWTBchdhTVZLmBgv5ASuCIHKCoOM8MsvDpjn8DgjgNnRAg0C4
X-Gm-Gg: Acq92OEEQhrqk5dAWp6HLAXN+flIhtjwKan0MOtLztVw7OZFXcurxgISgUYXTD9pQaQ
	2TrmRRNG8o8skM4HQdIU6c09KnqpfLDhGRNyGkCyTvmv5wZdkDJvqUtostp7wfzo82wBXir8XcC
	YW8NVgLqCC6SB/Gzs7DuRPqrsSoz+JVk+/6klK5TWLNs6ZzVf1UM5y7GauGQk080S7CoV2cuFNi
	9ruz8x9zkhbmtaRT9tMV1Ou/KMh63YzH07zUOgZE50zOqGmGrmB9XzmzAoVnMJCBvkM97RqAuSR
	yrMc8Ef0J4GXeKyrLlg3t4rrnfFLucnFD5LIHkGDVHTxRIGjgjroXziItGe6qR5ij4avmd1B8XI
	Jv6M65EGnLJ8v/aO6GUnKWLw=
X-Received: by 2002:a05:600c:a011:b0:490:58ef:cea7 with SMTP id 5b1f17b1804b1-490c25ee058mr246872115e9.22.1780907690556;
        Mon, 08 Jun 2026 01:34:50 -0700 (PDT)
X-Received: by 2002:a05:600c:a011:b0:490:58ef:cea7 with SMTP id 5b1f17b1804b1-490c25ee058mr246870995e9.22.1780907690081;
        Mon, 08 Jun 2026 01:34:50 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ed944sm52009994f8f.13.2026.06.08.01.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:34:49 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:34:39 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v10 03/37] mm: page_alloc: propagate PageReported flag across
 buddy splits
Message-ID: <1a407d39a9ebd95e9de67e44f9ad2db37c9f31e9.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nBNtbxwFhMB9u3KmUZbNsNMmFhdaUANag3Ick65DiXk_1780907691
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0945140009
X-Rspam-User: 
X-Stat-Signature: m8ma8xu5nkc9nqwy7czysuaufui1cdnj
X-HE-Tag: 1780907693-787268
X-HE-Meta: U2FsdGVkX1+hrCU2A5KArrc8a0Mryhf0VcK7O/YhCX7FYevF1/SFDXhh7qKoiczAK2Dplc4FRLFmf/fiUK27WP+EwIRQfB2/IrrXYjUUaN25+ApTAoXRTuibXNE1JzSD5Kyi2jMliywPNvUEexz0YMKROQfvMhloIvnnJeiVovuo52n7FslInYwL6Yl7Gha30l+dlSsBWh8zVCDIRCYy8cQWaEtnBO2ksDEAs51nG1Z2hRskVJBgb/BJ+W8dQPwM7STX1Qsr145HAou0fQa2flMOmJELixRZr6viNLwbymD4obxKZNVpFlnhT+GKdsrxR9Nlzuyg5Fi67gP+l3+mBZiwidG0/cmRjgNPMhXC9F+6p+NLxZWHtkOQIk+pjFZqC4UDMje1NXvohj8uX7Dbgju4+3rhWBpzFjnfQwmD9BfZBm+tDAytfbzS0aE5cZnSrUKUNAB3WPEKQShPjkk5s7xDQMXFQnbW5tycJT7TRVVou4qZinfisSS2aNYdPokGGwriqBVjg/HCV4nnrPB54Xu9elJHduldfrvATxAlFfsvluLufcnvbzo4ypwpSdjQ9hrIgaCTvGfim3raxXEoCZxc+m1OwZudsDt7o6C5Stp2dC60t14C4Erxk96SCdgloUJe/kzsEkK0+jNP6UDbrv6tUxPht5tnmT3XSEzS+TnL0LkVmhMRmM6Yb57sqx95W2G1qgbNd8MfHskrdjs5b9Q1LTp+tFZjWpbk7zS6bmYEbKo/3msE0/J7yF4C4YU/7RJdrJUpJGjZNtXA6PIoOcdLGpom72Mb5iTzY46UnQNAuAAnhEVBwT5g47nlu0qmotdD2M7ZrKG223JR5KIzyjB+uUgdGc2LD9P2QMIXqxT3G6QGBfLuUA7v5ArwNp/482DFt31JIy97+Q9wxvkbDuDiZP8MOVOykF2XnyQvNYU5UYEJifTENjVKf4y5LG1i5P351Ytk92J1ek9q6Wd
 gWKWMrC6
 QZQjHzEGL2n6tfND825wL4zwC8/XBf5mBPGhDc3pnbRFxmvtkKnZ0j0VEFGLlxhBgHDcWotBX/GzLjtNjPLlq+RDUetpAOwXmUO1++GdCXZx5jvKn2C2dCXsElNYCTz/lKNXo0pbNPhSr0s+S5XqD8pttokRRRUblsSaPlYh0R/nSfDwf4OnL3tT0koSXe8qJx2Ld8/OT8Vn02S9OSbfyTjwXTp44EW0nP2p8csfy1Sci7e1rqQ5LEgMuGC4lzB8INrBe8X+a0ih3v5r3XoTT8CGDhT4Dfm+By+fUmQ7kp5Qgn6lUw4oTjyicfjBvTr98BDaFCHnfR4TBDoCpuUrOx/UXnTu//h6AkTSNbt17kzSTWicQk49CDGLmyi/LsbtwOhF7e6flTb1XRwKczxUPIIEHE03RRYr9hZbhqacH+GNUjo1ViUZkQ7LcRVBpGvxQ6peH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

While I was unable to quantify the performance difference, it is
an obvious waste, even if small.

Propagate the PageReported flag to sub-pages during expand(),
both in page_del_and_expand() and try_to_claim_block(), so

split_large_buddy() also propagates PageReported via a bool
parameter: the caller saves PageReported before
del_page_from_free_list() clears it, then passes the saved
value. The flag is set after __free_one_page() with a
PageBuddy check, matching the page_reporting_drain() pattern.
Free-path callers pass false (freshly freed pages are never
reported).
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 32 +++++++++++++++++++++++++-------
 1 file changed, 25 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d49c254174da..8dae5b3f5876 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1502,7 +1502,8 @@ static void free_pcppages_bulk(struct zone *zone, int count,
 
 /* Split a multi-block free page into its individual pageblocks. */
 static void split_large_buddy(struct zone *zone, struct page *page,
-			      unsigned long pfn, int order, fpi_t fpi)
+			      unsigned long pfn, int order, fpi_t fpi,
+			      bool reported)
 {
 	unsigned long end = pfn + (1 << order);
 
@@ -1517,6 +1518,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 		int mt = get_pfnblock_migratetype(page, pfn);
 
 		__free_one_page(page, pfn, zone, order, mt, fpi);
+		if (reported && PageBuddy(page) && buddy_order(page) == order)
+			__SetPageReported(page);
 		pfn += 1 << order;
 		if (pfn == end)
 			break;
@@ -1559,11 +1562,12 @@ static void free_one_page(struct zone *zone, struct page *page,
 		llist_for_each_entry_safe(p, tmp, llnode, pcp_llist) {
 			unsigned int p_order = p->private;
 
-			split_large_buddy(zone, p, page_to_pfn(p), p_order, fpi_flags);
+			split_large_buddy(zone, p, page_to_pfn(p), p_order,
+					  fpi_flags, false);
 			__count_vm_events(PGFREE, 1 << p_order);
 		}
 	}
-	split_large_buddy(zone, page, pfn, order, fpi_flags);
+	split_large_buddy(zone, page, pfn, order, fpi_flags, false);
 	spin_unlock_irqrestore(&zone->lock, flags);
 
 	__count_vm_events(PGFREE, 1 << order);
@@ -1694,7 +1698,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1716,6 +1720,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1726,9 +1739,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2116,11 +2130,13 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	/* We're a part of a larger buddy */
 	if (PageBuddy(buddy) && buddy_order(buddy) > pageblock_order) {
 		int order = buddy_order(buddy);
+		bool reported = PageReported(buddy);
 
 		del_page_from_free_list(buddy, zone, order,
 					get_pfnblock_migratetype(buddy, buddy_pfn));
 		toggle_pageblock_isolate(page, isolate);
-		split_large_buddy(zone, buddy, buddy_pfn, order, FPI_NONE);
+		split_large_buddy(zone, buddy, buddy_pfn, order, FPI_NONE,
+				  reported);
 		return true;
 	}
 
@@ -2283,10 +2299,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		bool was_reported = page_reported(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  was_reported);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


