Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09533CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C816B00C2; Tue, 12 May 2026 17:07:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4736B00C4; Tue, 12 May 2026 17:07:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FA776B00C5; Tue, 12 May 2026 17:07:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8A26B00C2
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:07:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 17F8940572
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:16 +0000 (UTC)
X-FDA: 84760003272.20.BBCE476
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id B1FC9C0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:07:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X+EGiJ7W;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778620033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KozvVjbx/oxts5t0d1Kf0c1bCJ+8LaI82XbCSjPbc9g=;
	b=pVz+1jdJdMpHH0PgXdXWlCUcpHACaMGRIpBFFDEVH1h88mrk764/0nhtD5UQuQEpEyYysr
	oxorXwo5CIc+ox9m0CbGDAbciWCFTJ27nbVs7mflwqkI1AXO4a7exlMUcklyzP5GdMLEym
	9efSHFwSV3ZLLHDPsIj6WqZOGLG6Io4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778620033; a=rsa-sha256;
	cv=none;
	b=E0ZEuxnmfgbhl2vfJIT9d9ijJ7t1+sBtLXlP/npN6JqUn1tcy5usir88N6IkKnNB7n5org
	YqjdSyc+FOLlmTXZS6ZQis4LGVWNK0BZOoxaWPvFHkY6VY9ruQixSftRnZOLNF2cwuN5UI
	Fy2XOFIldaHvS8S0JxsVeIpeDobcVDA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X+EGiJ7W;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778620033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KozvVjbx/oxts5t0d1Kf0c1bCJ+8LaI82XbCSjPbc9g=;
	b=X+EGiJ7WTExI5/+oORAb3hnWDgNevVCzUpVAhXtSPr5ibhjIobNxEa0Mdx+16SWSuEoI4s
	pbbyMuy8uyXmgOLvsOc5uipGyks1h7LFNAy/E/LTjflHe4UtmyZlTXDDYXpQyfQDEokwb5
	fWAK1jCdAs0g3/D61Xtpgn+dMk/8nK4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-257-dubYxW1dMAyVY2yd-lhj6w-1; Tue, 12 May 2026 17:07:11 -0400
X-MC-Unique: dubYxW1dMAyVY2yd-lhj6w-1
X-Mimecast-MFC-AGG-ID: dubYxW1dMAyVY2yd-lhj6w_1778620031
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-44b2b38648eso4718537f8f.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:07:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778620030; x=1779224830;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KozvVjbx/oxts5t0d1Kf0c1bCJ+8LaI82XbCSjPbc9g=;
        b=qPS/CdlsM4iQmu9bgx75EcW6ME0gkrU8HU/fV5ai+XRZp/Bzxn3snlzU44YOYv/bm7
         a11ayei5vkirnC4Ia4ioPq0KuTLy5oC6s9DjPcVnScR9pJeIGU50FjsJ76+WOmmEZ/Q2
         gZS1r2b7ZJY9nJ0hLO8dZf3tXGIZIljZ80ikg572st0l/gxpp4MgYGKNsnuvgk7M/ENv
         zd1B2NtC6kRhaNNcnlTuksmnnXNFtLLrGQiLi6qwEFPNYEhpViSeGFT99hdzGLVds7L1
         Bz9a7P2ptoFD0L7ha8jY1JUELDl6ZMhw4lATm9twUp3UqjlbicOQCrrVZ12awx/iaZQQ
         6NzA==
X-Forwarded-Encrypted: i=1; AFNElJ+zEBx4Z2oHN1g1CTgr53rup/nmLdzBmfs9Svvmqw4MtBecLyrCXbJrquDoFdtjQSP+AWPRknXDEg==@kvack.org
X-Gm-Message-State: AOJu0YwZJ0Y2m/NxFZ4lXE5qUhlrNUZtUaV/TUtluvnjVVrrDQaWT40+
	F8mJmTwkWUJ9j9vqKrVavymZkVZGKPpHysSDLUCkcFG0jHcpQJ6KnuqakrGolQGK6opdSVGhYTL
	kkdoyUJKaFtFqUBAT+/nf81utGJfrlGfyAgVKT6bOuFxmw9jbjj7W
X-Gm-Gg: Acq92OGtDUtxoNmbn4A8UGXQV7IRKmRfQ653dlOsbnun3tgApfERPeWAGxpm73pXH78
	aY9U2fuk9mRczPl1xibgrFcsN2MOSGatjL709pFakxQaqmbSrmz2RpC+53xens4LOJppKZZDmmn
	wAVoBepTHFnQLZr3gSBm/P6iuJIFsx+a257HvWd9JDX26ZJSNXekdo+JTV78ZKsR/KTvVmJfZfk
	/MwszGZ8O4B+IQQZMfkOX5mE5bSc9AdndbwRr9WCvrWEHreG04GgVn6YcGq2tOkJJnO2ZKGhnat
	n0L/xNsKOZG+U8VEHqbYrJPVHSvdA7nntzbOUrilrGCpQcnxv8UJr8JdpPUDyWYySGU2rXqj7g6
	6uihoORrGaFbTONzuwy7fo4MOPM2fGdPv5Do90Q32
X-Received: by 2002:a05:6000:4021:b0:43d:77e1:6a69 with SMTP id ffacd0b85a97d-45c5a6894fbmr498502f8f.38.1778620030410;
        Tue, 12 May 2026 14:07:10 -0700 (PDT)
X-Received: by 2002:a05:6000:4021:b0:43d:77e1:6a69 with SMTP id ffacd0b85a97d-45c5a6894fbmr498437f8f.38.1778620029903;
        Tue, 12 May 2026 14:07:09 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491f8d4c3sm34970009f8f.34.2026.05.12.14.07.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:07:09 -0700 (PDT)
Date: Tue, 12 May 2026 17:07:05 -0400
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
Subject: [PATCH v7 22/31] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <9a22e0f9bbe1278913754db6df76e291a006181a.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rfTySk7vNWRq5onLL8LhPdAPiWqz1fJNWNT0xpNwhno_1778620031
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B1FC9C0005
X-Rspam-User: 
X-Stat-Signature: yji3xypu53946hr3d64tychx6up7guem
X-HE-Tag: 1778620033-235225
X-HE-Meta: U2FsdGVkX19fPjoEQNxXQxfojasgpRuLNsjeUaevxBodncoFs0o3NxGjBRJLRwM+l42LbJJcJMPUlI7Er6Su4D8FppCN8b9abPWXYvRmDy9in/wDmJHhHvrPuB+G+jP3FhXkbrEo9FhfESbyf45pBP6AxrMfAfVh0jJT69G+yLOQVhjj9YQCP8v5DfN0kWH40Df/aPKduf7BlptzB2T2N0zN/2LH2rC6QXBPBEOWsLjKA1KC02/K5aF6WMEX+KlD6fYmGZYhiqE2BQAnYzYMcH6REtWt3C7I77LmnoHLilRApFWByAC0PmJSjapV5QreeuvJGCFcQkQsUSLMIXdS2pLhpLKQFuuIIa7AHyyfusjqMsaxOHORAUlHEwQLq44LXdM+a0cub4u8u8rZ233VUsrnD0Ggrf9m8as+Bd55rZdVqjvLkGIrHKAgTc8rh1dYq+WYw7Y8dYvbr8KxIUCcqPgnEghcI01eGlMIr2FaIcACIcdOcRWcbnXHEUYzNKNd4SlvgWqDrkNXb0PKvPIuYicrKvzRevUKLVDZc8RP933tMPjzJxOavajtZLYeLcZtiE4vyeh5uMepZIVwcIy/rh5hUg6WINwcQ4+mIt5/9z6Xx0qiiXsHYdB01kw592/R4eKu+3t6mef/vxtdnDRiR+qIWuZzLMZpiLQThL67wuyzvkpXVIGJx9q4YhRAPTVRGqcZMWyHqlK22Dv44Oi/07mR6yr/t5l04FNw5yHepeyyO/anCFeprQf/wk+NEZaTSvsv+00EfMi24ezmWU06v0bKUj1SDqr/EUfVHwNZ4I2ZcH9kwPwZMsrXZZj7KdLqrKZMnfFalU0md3sIhB/lI3Mg7XBeVZx8LqKgABErvI0eqgVmbBUbaK6L4owNT3Gq5vRt4ZFTUbQ4UdJf2Qr4/J7AV/0rZ4qOSWLZwEptbBK2AZMVncZWQnnlpsqReocVSewijrnrT9vNLrGT2CP
 unsIZBgu
 a/kwPGTUOtDVonoNuSOq2fN70YFcCAgqeEFN+X3p1NVvy1eYDF6co71T5+AJHv4h5L2dhhUk1Xny+Com1rmuZHIbH1eoSovNr3u+xs5tOES6Pz4bY/adYj/IqvrPA6BtfvCDCn/uZbjDWaaFK/J0oZIb5aEUIOXXwSnmEdOAGP/MsSOCNDx1GjSbcSC8EIOZ1C81dImP41uzksLV9dEmOSSdt8Rs3t8uKC+0qy9a3IA9zBs3gnWYBrxo96fwKiMnm35s9SKxWXlCoiya4GBPGr1SCOaqz6xzsb1gYAfloxNIr5euWKCNWGTfdaTUwdIIfKzSFUj49+6npnSCLxIBbDWU2UzzHmRmeeYnGhU+A4xoMv85MqFuGhF5a99r6twe+GPM15FJcwZlwz+fymTz4JYr2hhqf3htbAv45CgOtYUlXydv+7GSxBpTT8cYxQRg4XxVE3Fjs2zmoqa4wXYU3cxfL7699JBVAIQImi4SAWYlmD5eHHulBoW0qg0BFCjzsnrpkMbGciBmJI/7NzleMRMhWx8+M+EgbGUwv4MrBTyLNfcY=
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
index d70c9ba6b329..468e8bde7d34 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1712,7 +1712,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype, bool reported)
+				  int high, int migratetype, bool reported,
+				  bool zeroed)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1743,6 +1744,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		 */
 		if (reported)
 			__SetPageReported(&page[size]);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 	}
 
 	return nr_added;
@@ -1754,10 +1757,12 @@ static __always_inline void page_del_and_expand(struct zone *zone,
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
 
@@ -2335,11 +2340,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
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


