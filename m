Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81ED9CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0FE76B00F2; Fri, 29 May 2026 11:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7E96B00F4; Fri, 29 May 2026 11:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD68E6B00F5; Fri, 29 May 2026 11:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB8DD6B00F2
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8970A1A01F0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:44 +0000 (UTC)
X-FDA: 84820829688.30.171D443
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4910218000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h00zVqNF;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19buVa4Rma7mh18uS22QrkEHb5BZSKvMOxe4gXL+M+k=;
	b=7BVC4nLUO0Fi5cVHc9DZoOSc+ku0BI6JN4Sp7SDsuA+raYby8r3S1ZIWyXI6MqagILBkL1
	DccLAmA2bTqWXTFCd60by9Y4Mj25fIUEpD5I41Gp9R1DpXUTijgYXdoSFtmrKCSQWojdGW
	0EYoboLen6EscAElYUnoRgHq3s71nAA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h00zVqNF;
	spf=pass (imf24.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068282; a=rsa-sha256;
	cv=none;
	b=VHSC4L0D4G9Gvp6GeXepKHk5RVSCVw2xjLPwcHs1WaTZpDgLWBH37QiMmVd5bC6aTnc8U5
	ugdQ1uF7cOddVxEt2m0Tit8JPX9ec8bnOfGmAPg9qrjoIlQAJWgzxrlkDrq3MWEbGYMdz6
	CRVYm8QyM+937fRykQCmzSXNiW63ci0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19buVa4Rma7mh18uS22QrkEHb5BZSKvMOxe4gXL+M+k=;
	b=h00zVqNFrYJixR56yl5vg4UMz92pgZgjYLq8hX6sgwEaGpe128Q/m46kixClxlv/DVaho/
	/JlL7qTJ7eDoKwZw+qb17GNA4Fu/Vse/0AMr68h/izKhIIcdcv4dKlImD7ofrWLQL+j456
	FTL+TrOskyKlOVe4+qCj3TVn6TEzyFU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-5kWLQTmKODCifnSEdPLiXg-1; Fri, 29 May 2026 11:24:40 -0400
X-MC-Unique: 5kWLQTmKODCifnSEdPLiXg-1
X-Mimecast-MFC-AGG-ID: 5kWLQTmKODCifnSEdPLiXg_1780068279
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-45eef10d5ebso682492f8f.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068279; x=1780673079;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19buVa4Rma7mh18uS22QrkEHb5BZSKvMOxe4gXL+M+k=;
        b=Nc9cYjS8a+DJsGj0ityWkLZw6f6mayVAZzIF2afFKNe7lgxumWIuRW15YvBpzLsaDP
         4//4yYz9tNz6dNRP+L84x4PY90VUl/ph66+/ai/Qvt0qZ/Jmf5nTs1396xvcMoJxQMFw
         ZrcYzTOyfbAOeJsBMzhp4R0SGavqnTRKEareEnK4dKqOSyqSIL6NNTbYnjiva+GxPpAC
         2ts4QvwoqRRFn2wunf3qnU5NQOQOYGYChrGwR6F5ncuj2Xm47xH79ryLfNkb0fFggVVB
         ccWjWHs3EHJAcIr91EVr/MweK6vwixy4GKkrFXD5Xku6LwUyVTFOPGDYj/MtYz/kwiMs
         2vvg==
X-Forwarded-Encrypted: i=1; AFNElJ+a/75j5ojrHbuCuiTP2LFYWX5zYjYGNESHpHKfVs8RHqr2osV6kJJMbM/Y4wcy1R9wX6qNrMlbXg==@kvack.org
X-Gm-Message-State: AOJu0YwTeWnvm2BE5LugDfXkZuUzIFxDh0eyAlu1Shh2Sk8nYPsVGwaF
	tdMZic1AgC0e6m6ZanHJvJsN/lOo5Be8Dusq1Un3Sn8HaOdGQUIl7m+nlszgrp1M8xTd8rB8AuC
	V7GaJj9jDsIe7nMUK7VDt4udjPx4IiekW9ST454t7lGdQxsRl6RUk
X-Gm-Gg: Acq92OEDqiVrGpn3fyBdebFEOXzeyx1JEZNAv1vrXq2rVLwWHlsIG3W1kn5/xfGavZF
	veG1eump760ERV186JiscT5MQ0s0u/CG7ugVzXv79Rve//kr50gpM0tn10RTqXsnTcyoieL9SWD
	EyA6WM0v4rIhKcw2TP3hlbrJEtkZHSpVNUQlEr3CFSKzGYYFE0XveeKMe14c8kAKzF0WfBh9vtF
	7BBfAWvdve3W+ASjvTiJQveVd18pW5xbwwgkEWZWYgtttcrNBaO8omdqkPRvi6fkiX7mgB7upoY
	f9+JAmtTsRMNrs5XAuJCHn1z3GyIZ/2tgRxxN+5TIrYGQRSZUPemFT1KoiQGLUp9VQWC4bWgyvo
	BRCwUWNE7fTppATeL4g9tTKLmPMe7ZlA3Df0VELhISM73dj+OqWV9Tw==
X-Received: by 2002:a05:600c:4e92:b0:490:8fd1:72a with SMTP id 5b1f17b1804b1-490a2900dacmr2027025e9.3.1780068279119;
        Fri, 29 May 2026 08:24:39 -0700 (PDT)
X-Received: by 2002:a05:600c:4e92:b0:490:8fd1:72a with SMTP id 5b1f17b1804b1-490a2900dacmr2026175e9.3.1780068278476;
        Fri, 29 May 2026 08:24:38 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6975e2sm75803555e9.6.2026.05.29.08.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:38 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:33 -0400
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
Subject: [PATCH v9 26/37] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <d0cf46d1d56304a1aa3ae46d4698d312978638fe.1780067978.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9shQe9zwP7-89rRXee5SNjvO_6m8qskKbrK0lADESnk_1780068279
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4910218000D
X-Stat-Signature: qudt5amnoxe34nhnt83i3h9mc1aoadn5
X-HE-Tag: 1780068282-553562
X-HE-Meta: U2FsdGVkX18CvmJQbjAs3VQrBmkZCSp3LPEyL+Oowue139wZITf/MwKYd4jJPaA4IoJ0Zg3eRPzXQv5CvOZ6ArqW1eaqmAEkuUMLo6iOgXLpAHlepaw/qMnoeKKogjIVAcKxi/rAZ6sFAomSe3ysyeGqSOYgzW6WlXxfE4nH6xYq05nPj0Obz2UoqO8pzi9gVCWJzdqLYozNI1vB1sCOeCGkJPVrIECBa2ug0T78QF9AcxvbXXUNZ7he0HPNHqNz7PtPwt6F5AxpH3VMVjaHzUDodxe4hyfSlbXEp/65GMsadVUKtMMv3NG+FJvTmo7c/YP2ayIUAinYZ0sETUoeegDDVffCCxjHPBwGe3J/oSJcJcjCiETv7GjmOlcyaSEXnTQdXGTaDJPGncUBwToiSTIXeLe2dAjbu7l8MDieETGRxOeXiygbnDHUw1GPEr/UUnj+QdUpxagztu0J3m/hkFEbESs0jF5wo1mLxOGJ0ZroBZy7eT7E/cAOzm8hqXjoN+Y1NLzUCAsS1X/jzRzr0pdEVXjYLKS4DR/7zktB2D95wOt4dFD+CASKk7Zty58DWbiATKet6lqtMMRfrVSxobrlOhWyz/Smg9PzHN9wbixgfF8nCUr4GB3305iEjnSmEm/T5bEl1sxUJJmfYX5SJMD9LJmPXWibbbudbrHSaW/o/qbls73pH+f9IZWtbPR702IbeRNfK/GNbqH92N10rg6DRQCk3soeN95euZHw2bauZTfiPt69Cu4cGl/S+IeQPDoAaf7rS8R7n7HfmaOA8WjrK9EKyKJkrfLqn/CZ9akrJEE9KCsbfcjU6e+TWFCO67vHvxUW3F7QhvTFqSX+HT7ElgIF6wnvgWYuvaSyR7VrJRLe7joQ60Q+646pYnUB8Ld/N6OR4BZNYFD2WIcOBSDfSHD8Iby3bCzlVyu3JH6COmRauBB3YUv/AjVl8P/TEPt8pjOia9dxysZI94G
 onKWj0fE
 Rbp+Pdw4YoaEk5qhRR0hKpJpiLurpmKgKwWUdaZaxOTFf4CA0mWRj1EvrbPyRZU3uXqO7BOUTc9Mn0dinRrm7a8oPRnAazcvx9Y2FiSpRY5VI9XKTsmAdwkcaHCP92XOxSbdTRO/0m0ur8BGogHFehpLXenKE49CWU5jnAqEwy5+SmENccgZsCwADKdQoxYQiYzclEUqX1ET+oMOW6A6/BA63ZCJcNEMw0nULKHN3N0mZUOranlWOKW3JegiU1fLQq4prP8+jyVDnof30lL7d1g2EqQNEisUDYYHdIyyXGuUaLaay2FH2Gt5c8eZ1x2X5cFgzkWxDgJlg6eHjxQzLn7w2ugQ8tVcj4QlmOcNYdRWuOp9OSZh4dIG++8Fdf29MuW7+8RScRTqofaq6/LfEPiwzY/wsDvuZUHkU+EwJ7SWTLg5tSooKFhnINMEtOJLo45IRM8XABmtGH2z6n+tgnWZyB/Zls6fSZI5uTxeyg00Sa43H0GLtEuIenw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Propagate PG_zeroed through buddy splits in page_del_and_expand()
and try_to_claim_block().  When a zeroed high-order page is split
to satisfy a smaller allocation, the sub-pages placed back on the
free lists keep PG_zeroed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ff614e422eec..72e52f049cf0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1715,7 +1715,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype, bool reported)
+				  int high, int migratetype, bool reported,
+				  bool zeroed)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1746,6 +1747,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		 */
 		if (reported)
 			__SetPageReported(&page[size]);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 	}
 
 	return nr_added;
@@ -1757,10 +1760,12 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 {
 	int nr_pages = 1 << high;
 	bool was_reported = page_reported(page);
+	bool was_zeroed = PageZeroed(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
 
-	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported,
+			   was_zeroed);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2356,11 +2361,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
 		bool was_reported = page_reported(page);
+		bool was_zeroed = PageZeroed(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
 		nr_added = expand(zone, page, order, current_order, start_type,
-				  was_reported);
+				  was_reported, was_zeroed);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


