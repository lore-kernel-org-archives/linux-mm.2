Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B11D7CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266806B00C4; Mon, 11 May 2026 04:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E316B00C6; Mon, 11 May 2026 04:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1545B6B00C7; Mon, 11 May 2026 04:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 087246B00C4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:55:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B639D120679
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:55:08 +0000 (UTC)
X-FDA: 84754529496.11.A5D563B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7F7E240003
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:55:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eZlLMF5D;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=huIB05uLC0/aRI1yhZqtcpv3ok57gc+RgGl8EPTE8A0=;
	b=TT+vXmUG4PwwzqDn0peud2l6vzL1ICspuylE7tt/7WcO7pCKPQ5ZFCCCU0tCW56SW2EHeE
	HGYl6CQWd4JBkrZcdWQPLMAoYeUSZ4zS9gwXebazAOEMzRpgacaO6fWl7u7hciaQT4wtff
	fqviNTR266py1mBGW6gz1isI1CEwJNQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eZlLMF5D;
	spf=pass (imf07.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489706; a=rsa-sha256;
	cv=none;
	b=zi352NC9B9mnprPIiQN9fIB1KVGG1tDnnrvr68FG/uVEu+D7cIVWKuKf5M1JOCfhNkeD3h
	UnpsXpb43sxAgeY+dH8+4yAlPjpM+VfoG7bv8Ls9rsx69a9i30Vh1TUeMBECvuQEtHDISW
	38Dy/Go3sU/So1oyn3ouNQ/QQrYrpEQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=huIB05uLC0/aRI1yhZqtcpv3ok57gc+RgGl8EPTE8A0=;
	b=eZlLMF5D0QS65QdwP0wIt1xinzAYW4NaJgp+5JtNVeC2kVLWrwDCesYVJ12prr0xNSRyT/
	D2Knjg9Q48HLSYV4U6RM/Zuw04VBRHnUy82SMUKunPFWLzk7NPC9oV2XK96DL621ADWKi2
	WdEtd98aRXbaPIwjbW3qvq/klIzor1s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-692-d6gIlvbJNeW86wInPXWlkw-1; Mon, 11 May 2026 04:55:04 -0400
X-MC-Unique: d6gIlvbJNeW86wInPXWlkw-1
X-Mimecast-MFC-AGG-ID: d6gIlvbJNeW86wInPXWlkw_1778489703
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488c0120047so24122925e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:55:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489703; x=1779094503;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=huIB05uLC0/aRI1yhZqtcpv3ok57gc+RgGl8EPTE8A0=;
        b=rsQGxZHog82v3x3lvVOdwKdFVR+f/xCsmned8daR4CsorZUNPvTKDqrRcXYLAVlxD/
         L29IkXDP5AIFX4P7ERCOlCyeuPHmmdZKdXxVlXE5tDmK3MXiHtQMvyPUHNUZ9eKwvtk6
         OChPloRVsV9O5DQ58tCMdBIHEQUoXcVvXV8Q2LBJkLfaFbhddEXPlSUkUiZwNfcrtcIK
         4Ssf2cgwweqOI8udeZQjITP66uX2DjyjEKv5q5Zpe8MVqisaXK1iG3MtE0i/zBMtK2lM
         70sJumcdwhcaYSVh8oUXP1Bi2939KLCKDjmWJNcXmd+4SbUGi3Fh61CZ+dAVPHJFR1Y1
         EpoQ==
X-Forwarded-Encrypted: i=1; AFNElJ8mwW3ZvrqS4yUTvaTesuiGMlJOmQmOCpff71+9RUG37WxNeTz/qzP5TdvgDzGURDz3t+qrJJpDZg==@kvack.org
X-Gm-Message-State: AOJu0Yxo1W47eaD0F97ubcCbcRmjqRWUb1xJcoYctpQADdsSBMpGdwM0
	X9LDjjauKd8pHot5Sq3ASu5YIZU2I3ezYao1LGI+B2h6hPRzzv3OnyXcV8hPMn/W+T+1BXwLsVv
	WZG4FmYxLanGj//K3jN8ram/XeN/3+V+XZvXeigWh/+UGubi9AeWb
X-Gm-Gg: Acq92OH+0TC8o12peg/YrcOeM/pA9mBeGqudrgpRI7TtktGTqs5sPehh9eheevtuI+f
	Z6xWvPNPY30asmLxlZxYmeATWYXNvPFxvd/kjNG5RnjHg1Rl+d6naqAXwcGdBEdWFgIO1P5VHfR
	IwhhFhIL5uOGSto7iVE66GQgs+iIc0t3OkTVzn3ixdZ5QM0NXQRsaggHfjBC3qMks+FeOKDvr3a
	Y8c0oEos71K7FrBywKBd4X31Ps/L+REXzzLfNRghv133UH2INcfb8znLn1XkSITqNx7DDdd1mVS
	dmmqJxMrjov/eXjPr+9D2F03Evud0diLJutBDi58x+pzcfpDJQcKG/QoXgsuS4CNRlti82Y7HXm
	MxHtubFNSfirm5tg66/AzCOsNm/KDd3WUFU/nE8clgkWSdOKvubo=
X-Received: by 2002:a05:600c:8115:b0:48a:53ea:1408 with SMTP id 5b1f17b1804b1-48e51e1804amr355371055e9.8.1778489702650;
        Mon, 11 May 2026 01:55:02 -0700 (PDT)
X-Received: by 2002:a05:600c:8115:b0:48a:53ea:1408 with SMTP id 5b1f17b1804b1-48e51e1804amr355370355e9.8.1778489701969;
        Mon, 11 May 2026 01:55:01 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702ec599sm154989305e9.11.2026.05.11.01.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:55:01 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:57 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v6 17/30] mm: page_alloc: propagate PageReported flag across
 buddy splits
Message-ID: <6d98a35c94fa44b550afa66923c620511e2826f0.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UgOGWN9CGWzTrDFgCdLWORghzUNZi4v8zPta3_BtzOQ_1778489703
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: s3qngqsyh9nhc5x1ia3t8f67zokydkua
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7F7E240003
X-Rspam-User: 
X-HE-Tag: 1778489706-405167
X-HE-Meta: U2FsdGVkX1856ud+A///+xNRr9YasgWvYDNa+0hWFOOAYQ5lkDgbHRbH4oqsXadQDaYbkrnYJPnSxWYFNcFJ64vjsfQEnFoGTxJFM1peYeYcJVJVs7rk7VxUVjVekJIfbtZPXBo2IoiFAosQCHAfgx6e9lUp9wvCQ+uTNDNz65NuuM1oIHrtL3TPr9NTH2Bwv+hFnlGBWWTYWTWnXyoi15ZWqUkcFI+m0QASJGJ3nNLqh68qTJ4d+V6+Q1BLjYlxXuyWueNxWyv7H+NrfrQOPi9BD1GPQ6dMRYY/iU87/i4WLKMC9PKZ//CWOfap9XzYgqL2h/g/zYp2k3a0UNr75jVTWwS6iIHQk9Hmofj1O1tamT/DNFk2cgeNbsQBKJfv5K/iyKaDgUdX61qUhT29ufBQtao4nMQu7MaSrPqE3g/Vl7txG2WripJgydbGsWAle4socweQHDIxin/08xdfPOxGkNp2bYXIg2ItueeCghcYQX+AwTy6V71WSuHvgrjoa8kSCcHM+nG5GIgR+8chGPZxhep1FG7XCG4hy8CZWSweQ082NalJslRHIGrYNAjjPb8m/hx2L1bVE6FNS9GxOXYHHoLOL7ars83E5c1a5mH388UNRXUS8mirt594H+ZTUYpSYK9CLo6ub3YNuqT0CJm3y0MA8c4uwb8KB6qXVntSG9LyAOaSkKJEYGcyBd/0ElfRh0GVFndjh+VVw1gFj45XB4js2SBudD8KAzACUl4c2BOHltujHgCxHuH1S6v5IfwGgTavvSGU+gCmz+pYHI9CXho/Orcu7ZH05qaH1YPT26t8IgR3+b6AiFFkI4MhgsQ2x0h010WLpD/wHO32v/+03ngLKYIvxtTGgy7ObiXAcl/DldvEUintbOAtcLXY7UX4wdQxmc3Bdq/+IRZBqd17mEpGBHMPU6BFDWBrOfbFbkVGaHCGNH8V6GfAkIDZtUw2+kW7L4t0RARwYXh
 X+3bossU
 eWPpe/2IYFgW5MJoJKYQg6bE7XlAr8WB9f1SEowxBo9bVFzEN8CMxjhRtcZ96XyrK3HaibCnhdKvBMYfBmyKYFfNM2j0hQSieaUd4cTx97pv3LjFgZuXztORyGA0Xeu7vNk4vVDzbOej9hmKxsKpIn176GNKp7Z8F8jaHaEjqdst7xcRRdwrFG4EP8XJ/pfBBfxt6nWv4hRnU2INbqujeQLfAxT8ZprZfkTAp3iFRXA+kT/dU1cTb6dMIfXQ3vzWTvEcsFr54DCayi0uKxslpkRSe4n49fE9aim8DLIThs+MvJtvzGgUcazrkWaPE2UriDIojsABRgK6PCAYmHtSarh8ZMovP1fQfNVAOVnEDSPJJW7HqWV6HbadntzfndMEEwBdW1dzwkn97bneBU1NcNpDbv8EFpXJehjXZItVsRmXiuIrj25R4O4s7+QQhBHLXF10N
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

Propagate the PageReported flag to sub-pages during expand(),
both in page_del_and_expand() and try_to_claim_block(), so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 842f5080d728..76f39dd026ff 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1699,7 +1699,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1721,6 +1721,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
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
@@ -1731,9 +1740,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2300,10 +2310,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
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


