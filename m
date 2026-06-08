Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79B4FCD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA7D6B00B8; Mon,  8 Jun 2026 04:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D79E96B00BA; Mon,  8 Jun 2026 04:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C42726B00BB; Mon,  8 Jun 2026 04:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0F776B00B8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:38:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76AA093123
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:31 +0000 (UTC)
X-FDA: 84856094022.30.0CB44A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0AC3620004
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:38:28 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kws79ZkD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pR/GrYiW1j/TwC+RCSDEiDzn5vRq7z0PTWnhHKvSevw=;
	b=2JqnBSybpVAYjp4edEnat81qmQn+rBiocfu6X47sSDFYpNT0fcuDyjnoE3TfGYgZn42jw+
	6DhRZ4QodQ3dNiAmCXKofchYwdlPFH7l+OL3d0s2AmTZxa/6/X6RtEhzGoXaf2FbKFXgBL
	4IRkpL10OuOfvH4/RvaqaxON5IU5rlo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kws79ZkD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907909;
	b=gAGpV7x7X9oHC5ta1vO7Vf7Yfeg36REb/CXjZwPAZKINLIfAn0/PfIGaL5QsobfKl77Dz5
	FGhHMi/MTMTdMu4hhxkXdxZCNTXWdkgtKjBN52mMeAdEhftDosbBOKXRUCm8cGOoi9ANqV
	7YETS9YGcxYrxkW8vW39R9MQzNxZGas=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pR/GrYiW1j/TwC+RCSDEiDzn5vRq7z0PTWnhHKvSevw=;
	b=Kws79ZkDcXF5XOSVwOBOqAzQqx9/4EJXAsjqWXLjXNFJku/1D7Sa+ZECADXanoYvZvQwvU
	Ip2NHmlC1HMxX54bSfbGeSSPlB8ql5sIg3AbyCfP09SxcHCRbeXFqVJ+j0je9YVJt2Zpqm
	fXKwAYFjf+QWjmaMekKk9fewGTYym78=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-ehGzA3VOMwehyVqSRHcT4Q-1; Mon, 08 Jun 2026 04:38:27 -0400
X-MC-Unique: ehGzA3VOMwehyVqSRHcT4Q-1
X-Mimecast-MFC-AGG-ID: ehGzA3VOMwehyVqSRHcT4Q_1780907906
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-45eec2ba533so2791351f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907906; x=1781512706;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pR/GrYiW1j/TwC+RCSDEiDzn5vRq7z0PTWnhHKvSevw=;
        b=QwZlVsKvy7Avq+Ip+aEj3mZO4rdM9GdOm+hp0K91IPSUYWXi1Xle0p5+4otJGCUUzx
         Rj4bqEeMzg/66AopdefWCoNxkWBBbUzLKrwYuU+9zNEaakziBXCBDTJmJz38/CmckMrI
         BWdd2UwR/Sv/xQ3PZ/zfxYDm533LhJWLq/2VKulC9UqaJoMkdf6KmqEMeBbH7x48nJnv
         lNUsfga3NPwAVuk+hhuAnxAPEPNuDZkjNQUXnYyAxlWAKZSXIuNwrFsLfRszOVf2Pyc2
         h8zf3Qc/8Hk4Db85cYPfX/eTlNXt2SOPuilRrelX6pkRgFdUhVoPdd0ul+FNXMypI5x2
         Ci2A==
X-Forwarded-Encrypted: i=1; AFNElJ/Sri1uVA0XXkNRQEuTo9vTZJROt2NDbQ9Cxznkj/j8ICOJyH6qUeXvqIzAZT0qwN4+Kto9+6ysNg==@kvack.org
X-Gm-Message-State: AOJu0Yw89Rk/46O/XGX5z4F3B7fyw6QOEQmLKcSSwresjoIYPjH8REM1
	ljLXJ7G5XY9CfPEBSspqSSS3rrNs/QDZWo+WI4DiPKZCIQHnegsFDJPSpYb826M2+TutpMyfPov
	Yke7YeTDMpSWvOqHMjG0XrtbaJzI/bzM2YNd9hX1uKsLyKqDsif8t
X-Gm-Gg: Acq92OErvhY0cld1/XrhAB0KT2xDoZE70qhrpO0TLjqLvkVQ4SZTwEfjSG9+d/l9N0i
	RaxWsxd4+kWDl3G9WgXetZbHQMe3qWRFviQrtQGADzDzUkcuAFcR0M9M2D+wQomoF4zxvk9ItbV
	ljuHEG/ANBx1PSDT3K5zcSgTVhht4o9emuaj0iVVxox6pUPi9VeJyfHIJXmWPr0qVjsJeOQ5/tM
	cM+FakGZ7x7kVcIm8WF20bWSWNS2PmmzjIelnn5rT95DensNUrgtLm8oWtNnqq43L5EGXWGPKWs
	WJHqJRANSoNfb70TQ9Dw9BdqVTe7pIofrDe+Tp7Qi1onHMihtBful1cm5udwGfZbRPSMLfkZD2o
	JGZA6VVP9IfYpGC/vtrxrvug=
X-Received: by 2002:a05:6000:2d10:b0:43f:dfb6:78e1 with SMTP id ffacd0b85a97d-460302e0a26mr15095005f8f.8.1780907905897;
        Mon, 08 Jun 2026 01:38:25 -0700 (PDT)
X-Received: by 2002:a05:6000:2d10:b0:43f:dfb6:78e1 with SMTP id ffacd0b85a97d-460302e0a26mr15094967f8f.8.1780907905416;
        Mon, 08 Jun 2026 01:38:25 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f3444fesm51241760f8f.20.2026.06.08.01.38.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:38:24 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:38:16 -0400
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
Subject: [PATCH v10 20/37] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <a8fe7eb8ee42128e7e74279662316c1d089e138e.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5oiG2VF24atLUoCNE54AjY5JACZ8ATbALg6nJMctITc_1780907906
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0AC3620004
X-Stat-Signature: 3e9dm3s4aws64zymbpsko94ugb3z33cs
X-HE-Tag: 1780907908-448367
X-HE-Meta: U2FsdGVkX18rqovppF7CDB04my6XbEawkXRTOBoCtCZZViWK3fXZ1coLb/EanG3Bn/2O09vBwx7qLZgE690H6EjIwvmcfWknmRz63Fzoxz0VULl/f8nl3Pvrt2KUH8pzxDUEQxvsTIei1Te1wxDklcXRmW6Jx0pshCBT+9erc1fQylgzfo21o9Q8WXhUMWO0lIDbVk6pFg7PGa/oScQ4/NCDs2UcTbdBhup3l4pm4LkPcNH28n8/AQ4Lb3ctKZasN/U4ITXTQjfSmHFBwmIs8zLCWkqJOvBZn5/q2GGGxbPFr/WiALw852x3i28Ydw4X4GtgOz0R8DTxW84/ahmS6J/OUDazP2mcNQrFCwvDvAtqj0KvbA/WMEkO1IUNeH11HhKXSLDunrJ3ENsXU3NT8fpcuYcZ6/TuahV0fKu4kW+HjLysVRlkhSQU9IElbQKsWSnRckNbmay8TxL7Z8vjnlDQ1JMAczD5yB6s7tihRCUMbumUXvnlgn99HCMNYXKNhk+/6bsV2wAF6vdMINEEtH1pm5tEWDK36G79W+hoa3/0WsRkMmpKe+uc1Gazy8xgMPYHnwd1S3Sw6DWpduvs7PAdIgRD1r1qPeAD/YFh2Bw6WWfWIRj2EzBITmyVPtpdvicZc0lLMLfR8UWUVlzYv8hruhuR3kpZ+BfUS58NpPQOGLKjAZ/v4Yz9rxxRr/a6YQ5e5yWADlF+tl2oPi8w2UxysAMS4XkwvLW0qV2EY5t9IVGqNQIRv7kyS7QMV7UQSh1Mzqv7/IyB54L+6XG7Mo6pqVfXs9uhnLygWGGQzDzNG5Y7p948tZLXChOFikWKbPqC0ETxOYYL02/K4ITyziHBMamHoO/clGPNcXGx0ueGLhD9L/cWX+ySFNGpRgagMhQ7HeDvuA2uS6TgCu1n2TcRKty+uLSEM8CrI+UrZqZw+/eVfCBFvnnbr7XD5ErlIDualAKf7aHAggYiEbf
 VdJEOXY0
 CiZDRrxBHO2KEayhdcWbLj9TQafcbaKf41WF79Ds670JZmCa4niv71U+1jvGdek3X1J3ZQuBBDfJeREXlWeLvOkSMJEmQM2GU2JOxDnobvgmiGO3JHQrmV2+LNmv/FqHMrfevPUhl3XlfgQqbSzXHjthtvHOf2kzszYUjFif7oyxRXRBoTA+7NFiNd8Yo/rgI52t+FUiUrlUi0xsJWKW2JGz+3ayZVLdgUOiVJWh1/TMkzoScCWiyzoSBIeGT87i05kclojwibgxWxammbHpEsdUDeKW+qSKoTOSXhfVur3+QTu5QzqXnh/mjN6ZdNovchEb6syYGLHX5TnFnvTWMXbhYBq+piQ87+cJxdlda7MWQ/vUMZ+EQc8MUgrUaeKuO23P1A/6Za/jk1KdpaiMZZK7SBaSD7OvMsVmGwAZwIayt6VBDtLhpgD78R//cJ1aALCbdnGS9pSUs8l6M47qFsw7g4Oqm7gdVbYMrevqyEeJuBtkfWSkcul+mA6lyJ6dm84Ds
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
index a90bca5317c1..7a6dedd716e2 100644
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
 
@@ -2355,11 +2360,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
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


