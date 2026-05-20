Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428A7CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB606B00A6; Wed, 20 May 2026 18:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93BC6B00A8; Wed, 20 May 2026 18:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AA066B00A9; Wed, 20 May 2026 18:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8246B00A6
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:21:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37D3DC1B6C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:34 +0000 (UTC)
X-FDA: 84789220908.19.B5083A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 07A0AC000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:21:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W10NeEB9;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjfty6vgLrS4T7uumYbV6HhVn6mEWZk8nuiVgC9VboM=;
	b=Nlz0RKc6xZCtvUEL/0kTkNbxjO1WAvmHuzm0izXgE4Z+cpf6+bvFNK5qb38Pxpnc9E2vPK
	GGbpIHXgOQbIb2MB+690APTlGPc/3g4O3YW+48p3js1OY/OuEYokV7leT2F5jzKHnDYqq4
	N2eFfld0Q8bGuckKqK81hm6T5NQ67ko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315692; a=rsa-sha256;
	cv=none;
	b=wTb4h88Oerg4cQo9vOYOkXOqbYEEE7FcZjdIZ446raaHbGD+7W3If0ExwPhednVC6iYKUj
	sv7DozpdLfzoMbh4Eo0lP22oYs84yCtTKWmypegATEJnnrpJsZCgqjwaBtgnGzg7fjhdJC
	v279ARlrUzGo8yozGz/fceTCjSjncBE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W10NeEB9;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315691;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kjfty6vgLrS4T7uumYbV6HhVn6mEWZk8nuiVgC9VboM=;
	b=W10NeEB9XVrAaYPTBmsFf2gNs4cFmHHxMlYP1aoRQ6vlGgzF6f9RLwh3LY9PzNn4M9nGEH
	FOOlHj1P7Livlb3wGR3DUIPAlp9hqVkjUYNpNuCBAiA3iaf6JUMvnFn3XfdamPhABN0ZQ2
	ndmbUQVtQDsRYSgeANF+M++1YducH0U=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-26-DFgoVUf-O-S4LmKStHUNGA-1; Wed, 20 May 2026 18:21:30 -0400
X-MC-Unique: DFgoVUf-O-S4LmKStHUNGA-1
X-Mimecast-MFC-AGG-ID: DFgoVUf-O-S4LmKStHUNGA_1779315689
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48fd3449e6dso32251195e9.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:21:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315689; x=1779920489;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kjfty6vgLrS4T7uumYbV6HhVn6mEWZk8nuiVgC9VboM=;
        b=TWC1CI+TAvkad8CnFYXpCGtxuCQSn5RGZPlfk7RhVKrMz25Jil43grsNY8sDTLfyQe
         B3BwmvLoarP/wKsna36DxZGos4ZkXbvBfMj5Npm6pLJSXNvjq30uInFZZh1cpYEf+pbc
         zY9/+ROLL+OSOYxmqwYIUkXINdOT+yYUV7TUjXShbETtk8Af4BWrxUz6r9QJw4ijO0fX
         gDJIqr/APlTa0K84Y1SYSvx5QLSoNZ+TMXGhTifFNLkrd+miIPrPwoEZmQmG2LSwsfS2
         qvbaTQnacn9edCsRmSNgXRIUX5MHdGU6nl5tduUtKn5FwV9/xmnJEFkghWfyqyI0UeTJ
         aW2w==
X-Forwarded-Encrypted: i=1; AFNElJ8XimqEolgdadSSopXHfVjMPNU8vWy/NtZ5DQzYQe2vwzGDKbWrN9pUgJ0n/3vKAQ/Kmwwz9aaoTA==@kvack.org
X-Gm-Message-State: AOJu0YyBaJ2EAuab9tW1vTkIL7Jxy+UYM8BswauLi6ud/1YxyMsJUblI
	fMfKSBw6X9H2SXI+YrD1lP53S8pewHhq3tufYmh4oQ2tulBROyqni/yElt+HXv5uk/OwhCIqWp5
	7jppbv8zWiwLyty880iNScSJ2nKGxbFKVTblSjVfb5XrVA70+Qcig
X-Gm-Gg: Acq92OGnLY8azvI0gFNxlFBKl/he1YZevJzvHECmt4Lcch8EFmxB8b3CEicTR28KaQx
	YdyFxZ2+4FJC3oEp+Tv4J+8pyM9sCQmf+jeYOvoilNcZl2mqh9J0lZlEsZRvhojn5fjkqzbAkW/
	p4G3t9OXRdJGWC6YoGziY897RuR9yj7kDHIlHe58p+NNcqvvGvuYoM7lYSwX1uTVVBg9KOVAZl3
	eLb0g8bSh4ys2oSZl21R824db/7N9YQQDNCmvCNGHlkglnk5evm3ysj1FAeKP9pp1F10tRrwwTx
	eM84XEqtGVMA2LNMPIaI/TQ7DHgCTuHBKQIeVy8tj0WFyzmWgNj07CZAW2zFLiGkZyIiVzzN028
	F8us7GZc1iXskvcyOGpJVEcQJrBVCc/iqnX5hX6ySRM4=
X-Received: by 2002:a05:600c:5c8:b0:488:f453:b976 with SMTP id 5b1f17b1804b1-490360a9e24mr1509795e9.27.1779315688713;
        Wed, 20 May 2026 15:21:28 -0700 (PDT)
X-Received: by 2002:a05:600c:5c8:b0:488:f453:b976 with SMTP id 5b1f17b1804b1-490360a9e24mr1509455e9.27.1779315688284;
        Wed, 20 May 2026 15:21:28 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45da0fe0f72sm61409614f8f.25.2026.05.20.15.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:21:27 -0700 (PDT)
Date: Wed, 20 May 2026 18:21:23 -0400
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
Subject: [PATCH v8 11/37] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <c4b01862c558c99970b2994ea8fad873fd2529cb.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZCY9yvJBy-5HmCa1bmJfNecBkaa-UD3dblVQJQo35_k_1779315689
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 07A0AC000A
X-Rspam-User: 
X-Stat-Signature: asizrb8fr4b3jw73e1ibxanbyzf8rjak
X-HE-Tag: 1779315691-528284
X-HE-Meta: U2FsdGVkX18aShQ23jesEKAK6hrS5kPHsAgRHQGMojBp+Wl+P9QVh8EnKWi1l/7PNAXpOlIJ3P9nrsR5si+oxznYgE4TfSp8545QYUOGhHmFgYpYmuvKlnFG+lxy+Tybb6wCd1t6Ek9X8XyzNGx1/Z5QB0ZbVi48Rq3fADDHiCnxGLoRFDuRvyJP3C4V/KnKHqoMyHehpr3brCFFO76pHGRdvOiqT1YwYpAqFLgmcMDL6yoCbnYl1eC1yMQyElST77CkJ5mPU9VW833l2powpUpioXT27LXCpmLXYUeIaFuX7p4iL2r4B+4arxBuOLO4Wm220teGK6/j3CuY3CYRfSzbt+d5mPxmuqZ9VLBiy7mLBtFMJjHLSR8hKmSMZsprITSDeiPkvU1FxlFCatwgbMSLJDIk0H+HftWlVm1Maw11QLSTq3D2sO7P/Br217a5kVmYII2teeV9Qp5l4cd5rBBYwHJxY8mbzbdPAaLyD6ciryLXayTzSkTdZcTKI5cdsbYzFAIwHjTrVwXtzBafLu5orxS5xHQqYpxd4QiLi1dvg7OHR1XgpbWr1AXEikRnZ7OqA/2AoBw+ThlYfdMdZCB60YTurbXJv4Irnab50Vx12gQFgrQpSsuOdqiUZvw6pjbltV7ibZjzZ8hcemPcWmCCub4LxIDr5hVHwklyT2YxClvdVL3qthWFS8lk7SQoQZhM3XDd8CfA8lhOExd4cdXPahyV2mGHmbOdAhsKf3UKZh6yhsE4cHNVuzkUCZhQbQNqHdywq5f7lI9LpNi489FkRelYTunXg8ftn+DCamYgiR3Qz2UDjJBfiMu/RIJLzQtEiq/iCdNzqKM2sWsGpG2jHTBStSZsPaJYNo9hKNLh+bVEgSr58KNQPPeFoPBI7DDfyKtTkBTD73/YmTqolax5YHKBIIgIU6scm7jst7FyFInR/M99lcsIJmO2R6v7jZqygV0airiXe6zAidr
 +K9/WE+u
 J0eSvHlubBmwKMIZ5+PZ1H1o2ouc9HL1y3hLzwYN1RBPhBjkfJf0Hrwbdojrc8zYy0j4X2bI55QCO+1KslnOUyNW1/KKjM1eScSy3vxxum1zSXqZSZavkfX7isnUKJl5PCPc+3D6lasZNF8do/koY51m0vYbGZk331aPUNEc4G1npM3d7cQK9e/D0Qe93juTYqZNj2PSFL5X4zBakmpO1jvd3lSkKouMwr2ppMLBRNies33812tC4e/SSptZjtL1NEYnkMgjOLdAmQIZLaZmuq4fhyIkyGDOTmJzc83PdtRQUlfn+muNBw0YYzy6fBYEy8zZKaYgITeGdBhXKznfw70GDlUuSev9d86XCjZYnWPHOMMLJDUQzEGIse15CefJroI7QZaLEVvujF94Ub4IZfFDdouyoEzA4apVpz3gAx0mQTdNpQrMHWyEvvRVXicrowfKUHH8M//+IS0POagcJ2Tztn/vHxPc47Vg1f1sOdcyt2VuvnhkPgsZ2Lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Also reorder compaction_alloc_noprof() for consistency. Compaction
currently passes USER_ADDR_NONE so folio_zero_user() is not called
there, but keeping the same ordering avoids a future tripping hazard.

Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/compaction.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 72684fe81e83..4336e433c99b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1849,10 +1849,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
-	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	set_page_refcounted(&dst->page);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
 	return page_rmappable_folio(&dst->page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b725a3b59835..3108ac9061ce 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1877,11 +1877,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


