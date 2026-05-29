Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852F5CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B0D6B00C0; Fri, 29 May 2026 11:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C0F6B00C3; Fri, 29 May 2026 11:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB096B00C4; Fri, 29 May 2026 11:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF7F86B00C0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6B68AA0195
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:27 +0000 (UTC)
X-FDA: 84820823934.26.FAF146C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 34D0920002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bvdAz3Yy;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6a9U/grsiUVqQvDGNE/rE2t/3gE4VHHRcC3EwM49fXU=;
	b=22fN3DBpuVitMNoJArIBPguOlej31mCvdahtdtvptSU32Dg1NBeHsmTarowjCQ5bD0/4mF
	50YI0OJxnf0ROM/pNn/224fA8BljRL1a4rlCGFOk8yUo42AF60chKfqAzd2wc7I9m/+b6o
	RoR/aV+nRQQS2DIn2ZXrpsaNPYzCcWc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bvdAz3Yy;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068145; a=rsa-sha256;
	cv=none;
	b=R2Nwz8PGy6xtBO/tafvZt7UceAO21IICssFuvRnU8BBi1ggcsk+gW+eQxFcSIO+FxjK6k/
	2Bt5U62RHW3NdHr4uDvim464GIqJ0h2LguqF/YOnRcAoWZjErDXm7z1UGFD20ks+dAoT5a
	Cfk7XPxYABbAAAEZGtDf50u7wpJgjFM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6a9U/grsiUVqQvDGNE/rE2t/3gE4VHHRcC3EwM49fXU=;
	b=bvdAz3Yy2b+2L7ZCUqVryV/aByeZ7IZimErgqW0dBKXHkJcdPTG+ol/RWC6HFRb/v/XeZX
	0ZzAYlYPhL0qgbMCDNtbDT2wPYb4nh3FaRtOb/vT7maP60ztWN7oHIP0xs9QiB8ZshEnbX
	Wj84L/lLz6co04H9wCro/wtpFCkfHKo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-GJMcNFXhNEqBbJmSLcWjwA-1; Fri, 29 May 2026 11:22:23 -0400
X-MC-Unique: GJMcNFXhNEqBbJmSLcWjwA-1
X-Mimecast-MFC-AGG-ID: GJMcNFXhNEqBbJmSLcWjwA_1780068142
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-45e73a4f1dfso9995581f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068142; x=1780672942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6a9U/grsiUVqQvDGNE/rE2t/3gE4VHHRcC3EwM49fXU=;
        b=JnlHHIVq5m3n539wJ4pXiShMY/0x6C2U4NFpG3OkujkRI7lOrIhwVFxjLgOIxRZyNU
         +h53RoO3uxls8DbJnw/l4YcPvQm9C+8FpCNbqrGfx4ovgMhpiRQa8bV6QvhWnxiQj3BW
         PqK/q4EPdvTSByk19vAKf69CYsLkc59zAgQx6c3HA35SfgKRvQ35Zyfb1ToFoecXu+AM
         /lNtj3KlpraLEmXETKlogcLimSSVdutc4x4FK5n7FkZxFXuXS/5cg/zFsSo+a1MmffYZ
         3zA+JEfiZ/yKNT8tkxfMUP5T3ZMz0Pl+M2kbTF/Ub6YBwr7Z6aFogVCEPHYkodpsIG4o
         JKMg==
X-Forwarded-Encrypted: i=1; AFNElJ+TH5WH5con0l0WeunttEEIbDrNBNOuysVOZD8ftwYgtdx4NmRhRSX0mEE9zlVvjJTwmOF6A1NR9A==@kvack.org
X-Gm-Message-State: AOJu0YxpZN8WAN+1B6U/uGL0AxtdRwKnfBXAUt6kFi7r9e7ggkRWr0oW
	GT5f4oeBd7qHzFd20L7mrD9I8SbdXc3+hOGwRdad/0DUG8MyMHxpXPFryUQZxRXkswCoKkNgMx3
	XgTgLYw3ElmpWg5v2118zai9CZL2B1fCh45LSTRCp4LsW3t+UZkYQ
X-Gm-Gg: Acq92OGPQPmpi0yn9pxO4StrvjcfEwIy6xbLZNnbYUck93pp/SYTSoOmqPWGAhqck7H
	EtW26VeoDaASqdBa98fxyNa2pX8J80YaG6RTGXfjwbvAdaOkdc0P4PQQ/XL81uRE4naBe/gIr2E
	C7GDj14DJPqItDQ9Zy4kniNv2ZakLEobE+01Dk7EC/KRX4TOT8WnuxKIgOWh0UKWbvH2ezERf3g
	1+9rxkBPG4ModdWeZ9gmL779iJS6EQ9/mUNGyez/sMIQHVN2Rdz7gevn7X6ueiax/6N0fvfn7W1
	aVvtBFYF7thl4sm6QHfQCEdeHYnbU11SbO6DyKghSRIhjx0aItI9nVquEijyYmCNi4VVOAcn1yQ
	7UfqkQv+KGzs5PPZt3kHPfukQqk5uaZuCl+mZnJ1Lzs1OD85RkH09dw==
X-Received: by 2002:adf:f2cf:0:b0:45e:f672:40fb with SMTP id ffacd0b85a97d-45ef6b4f72bmr394848f8f.22.1780068141730;
        Fri, 29 May 2026 08:22:21 -0700 (PDT)
X-Received: by 2002:adf:f2cf:0:b0:45e:f672:40fb with SMTP id ffacd0b85a97d-45ef6b4f72bmr394796f8f.22.1780068141211;
        Fri, 29 May 2026 08:22:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354cd87sm3989750f8f.24.2026.05.29.08.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:20 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:16 -0400
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
Subject: [PATCH v9 03/37] mm: page_alloc: propagate PageReported flag across
 buddy splits
Message-ID: <35539ca539f76bec575e8a6abc0cf42add858c0f.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4aqZt-QfrRYkEOFXoSWEbw0bNMdDUTFl4Lbv4zigr9I_1780068142
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 34D0920002
X-Stat-Signature: bedg9ordom4hn9815sqzw3xp5u3k6yip
X-HE-Tag: 1780068145-356723
X-HE-Meta: U2FsdGVkX18N/FsshH4PuTSVwpBZ6UGmyOIZCTcTr2tAZ4cMP/PNG+oEX4HD0r7ReSV0HLBSssSwLCabtvuLGxcgqBKcs963bvc102ap6XU9/ItL6CgjC4CIPERWMZjqqHHTL3riaktMomXdtCZmmNGzulNzM2xg5mRiZzRrc4741mwBGYv3hAQzSaLitllL3jpR5h+piiZZTu5cu9rQqhfPrCGG/0QZloAEyQQ00MfdBVNpey/yv9xERLJ3/UoHtSLVPmZ480WysVBGpNolhGC7b6S2MO2en8ivzrh2ROsobIa+7JIzin/CA/FyBKjiVUojrHhc7LZunO0WWbl1ZzlNEw3LnLAGSSh9FDefhLFeKbMYLYQbshgT3pVs5NulCHCjW2BPFpqdat9PSIPLOjFibitsoh+T6IYrbRaEfeHwdonorffuO2nRfwzd97shtQBUphgQh6c/Hcz80YQC8rJFO7MLTUWZfEhZHfepnMZxLWbhMjv0QAV+uA3KzreLdTOJX7QE8pnUZdX5VRF0vPVkSsbUeIV4kQzsOFDEbEH/nkuA/c0Ha0Jp05aV3ksu62RUKCLFK/l4OkHg9S6t80eza1fjIkJOLF8JaQNI9bLVWdXIMM3zLsxgRtqBEzFSPLXqmin7eBOC5oMAeKSiFRBe0xcPSbmHbD5r1LUHQ8cDxq0DgvqB8vFPc/MEeTDFz8BeVxTMPrU5071peOTcNXyc+k05ITRZT5/rbcAjoV8ZF4yu3woaCqqwwRyVPQe6TR5NL6kTDF5GhVt35+sTER3+umqhv7tQWCZ2W2DPE9tou+NCgJPs5bnogRfAb9Y190sycDJq6TYkisORBkmmgLI7ApJd4e5NdNzX16pUdeAaFuDnlW1vbS2ZqgkbCihOnuKIrFmveII8JCVqA2NnnLK0Ng+dzQIo8uvNmq6oNeQRImZlVj8Pq0GxpVF1GQqqNjWslhuh5nUZEOhYS4Z
 V2TP4uM7
 ByWKL9W5gUAy6PGDd+ooUFc2U2knVlxQId3t0pfuydNv4ulMXVJyiuFTGu/+O01iqvakZzb70AkZDc0GXFC8EDwMn+FYkmoUkC2024jlota4qWCgrV80hhdbOoo7YbH/hTWBL6qRu7YFQS0Tiy7ujsZGCGHmFGn3vgfkcoGfDLwMc8UxmFmJiIErPCODjTcUUZV1ZcAK9jCmR7cUNSFYmw5Xsx7l7aK9a5LD6gXMlhyH3GcCawhM8trAzqb6OcKTAQTmjhCXYG0gC83G6RiYYMO2GntALKLpCH3jwSpSzuDrC5GQAHMnh5yUSASwfwExsAoX6vfdpZyLxOgDo8l7D4kuS8DGjc7YACKXulLCXrJ9Fd5Gkkov3ou143bOWvQUFjQvsm/R8fBjcDqZclDBxhQ5NYfuBkNBLiOYMXqAjh8mHvnS5mQSD7pxEfjt7OvZqjXCt
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
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..1192c4e47da4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1510,6 +1510,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 			      unsigned long pfn, int order, fpi_t fpi)
 {
 	unsigned long end = pfn + (1 << order);
+	bool reported = PageReported(page);
 
 	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
 	/* Caller removed page from freelist, buddy info cleared! */
@@ -1521,6 +1522,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
 	do {
 		int mt = get_pfnblock_migratetype(page, pfn);
 
+		if (reported)
+			__SetPageReported(page);
 		__free_one_page(page, pfn, zone, order, mt, fpi);
 		pfn += 1 << order;
 		if (pfn == end)
@@ -1699,7 +1702,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1721,6 +1724,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
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
@@ -1731,9 +1743,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2288,10 +2301,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
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


