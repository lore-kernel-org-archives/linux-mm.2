Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CAF1CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB4F6B00C4; Wed, 20 May 2026 18:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2256B00C6; Wed, 20 May 2026 18:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2A1B6B00C7; Wed, 20 May 2026 18:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E15406B00C4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD7A68D7B9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:54 +0000 (UTC)
X-FDA: 84789224268.17.1DA40B4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 73B9D40003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="A0s/s0mN";
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19buVa4Rma7mh18uS22QrkEHb5BZSKvMOxe4gXL+M+k=;
	b=cpruBc/bqgj+Xb88YNEu5AwGMBSBdcS6dTVxd94zSk9GxgPmS6wuKtQnc82k9OcU/nzLSf
	bamk5zXyBu23BkifaMY6qV+xJpVY5MO8cHLLCCk8+23Gf6Q2B3PvWx9MsL6/aKb0C2+KSW
	n+bC6vDRF6SuWpGwEA/en8oHYOzzlW0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="A0s/s0mN";
	spf=pass (imf11.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315772; a=rsa-sha256;
	cv=none;
	b=MIQbM+L3Edl5QFHoyZZKGGIydiTc2W0uiv5xvQsj91hrTfWoXt3DUsuKaCDuXEMxcWByAx
	kiYY7qbHSuyA+z2x03ROBY34C6eAErpSvcf8xz91mhQecTysHtD+FESUXfCK6HjIesRAE3
	NmxCpOI5cUe9Jt70Ifr+lnwZzQtOxsg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315771;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19buVa4Rma7mh18uS22QrkEHb5BZSKvMOxe4gXL+M+k=;
	b=A0s/s0mNsU5e3257f9jBWEdIehKR1/Yd9UY5zabkUgAPLHiIr83hzPQiat67k2vLjlKsoX
	+LsHx2hXmnPaEbLVxB84qYRFGApXiwq8T2kqHhTe5mEettWYfIUQch6zg1+mTq2T1HuUD4
	ZkXXlKEU2qJyR7DEbcxoX26isQV70YU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-Y_cSXBVJPFuiJEFos1kPvA-1; Wed, 20 May 2026 18:22:49 -0400
X-MC-Unique: Y_cSXBVJPFuiJEFos1kPvA-1
X-Mimecast-MFC-AGG-ID: Y_cSXBVJPFuiJEFos1kPvA_1779315768
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48ff0eb77b5so51033335e9.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315768; x=1779920568;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=19buVa4Rma7mh18uS22QrkEHb5BZSKvMOxe4gXL+M+k=;
        b=eR15OmmgFnlsbaYIXXsKP1/ytDz4HkbgH6dOh5ICVKoObableA6Wnj8mOsqUuN29mQ
         B7YBOIHPsREcjNh5fGOk+1lCcFrbBg615EpAtPiY2BQqNs5unmkk6Ov7TtjerJIH26Z6
         ERed0uTDAmFX4RKrnNYd7F8M2RenAIGmqB4252NwNEY3ED+Jy3Yuj4zl1K4nB7qJqwZs
         BtIE+yZmio4YggvNZZdJ80hu8CHI/mMmz9fmx3C6541QBPMdCygMswMIT2ZymHZ7CtPZ
         afXVA+/x9G1Vys8fVZRzeMgktoolm03lC7vZ0ZiQENIr5qYe1pkXDv8l2r6KUGiGzUqX
         vFUg==
X-Forwarded-Encrypted: i=1; AFNElJ84YcUXFnjd1Fl7PfYp4HZS9Gf7twVt+Zd7xhDp8hmxTkfNttOMywOY+0XHULOlbSDpRmVpL+QDUQ==@kvack.org
X-Gm-Message-State: AOJu0YxSMX/iQ+y3jvjonukmEUjE9dBiE34LoA/5wVriDZGCMwdmtqTJ
	iFR0WBDIkBlT70wpYBu3gYOq7FEOQi4MvxVQCLQR2rZYDHUMSQxwvmSLCN25o0z+4ZtfUO9zs45
	eFEH8+h2XI11wa2JsyB3cVOhRTsY9S7dYAi872VegibjyXn+AkcF2
X-Gm-Gg: Acq92OGjjLcTf3wwRZNfrRbyZEkNQ8sK7zHtROEJXam/6XtkehGmDi4f5xf9mq56Ir+
	a23PiKdFjFtIF7GTnGvmiUFhkeiQ6ucnbRvUDqGvznKikQrJ6rjKcC8o7cyA6k2Dx6U9OQ33y86
	eTSUX0NwQ/0rv6wlPCBmOmvvICSJO4E7R4M88eDnk+zHoASbEo1yjNErFN6bF1bCwv2ObIfuXU6
	IPY/Er9pPrX60ugmnNCAFiAOLVzaz5ahJdNg3TEx/9+r1jp5NMFMmW2YhLfmMdS+7ynqDc+5O5a
	kdjzxgCEI0j7tfS5jkUuQ8NLDzPyuyiFVpp44y9kkTcD5J9Q8DWIIimvGzLoLT8CEmngecsVxmx
	hfxgcP4Xlxoo+az3DXy3xcjf7/TH9RZr+bOh7ymTglYk=
X-Received: by 2002:a05:600c:c086:b0:489:1c5f:3a9e with SMTP id 5b1f17b1804b1-4903606bb2cmr2183225e9.13.1779315767661;
        Wed, 20 May 2026 15:22:47 -0700 (PDT)
X-Received: by 2002:a05:600c:c086:b0:489:1c5f:3a9e with SMTP id 5b1f17b1804b1-4903606bb2cmr2182985e9.13.1779315767276;
        Wed, 20 May 2026 15:22:47 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035f52a0dsm1490795e9.24.2026.05.20.15.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:46 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:42 -0400
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
Subject: [PATCH v8 26/37] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <c260659c001161c5630d36a466dcdb293790917e.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r2XGBn85MALXJX5_PMS3NnOpy_oamiyyW7ogZt7oDyA_1779315768
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 7njrqraj544ddepmintmympnjnnoa5ux
X-Rspamd-Queue-Id: 73B9D40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779315772-527808
X-HE-Meta: U2FsdGVkX19ZsCuBl9IMqsLs0a86x8wdWTCJ1DoOIh1CRCg5wfaaaccpR4otz3kwP7t9RscHWjJ46Ho8/jJDN0n7wW57jKyERQjKnlvYzIsc5YORwQxaXBTh+Y5KSuHG3CwO/gNEN9Nou3fQFIAHEuC3740Mdz4efWza0jFbnPNhZk8fDlXqt/YNvrVJYYQSka3DWdkJrRGVe2pGN9yrpfPyK9F+9EXZBYXtwH7caGjPwS0qEOENx95f+MbA/K672iAl9+ljYQefctaWpqUBpkZKWrujOTOytJceIURRznAbpi+5/f/BBc5S+dboj+nyXd7vgNczm8POOUXMGAInQlW4Doowb0eGPKdZ+HTL8xkIjvsLeDFEtgZdl7gBeMYWy/xSXdjwt0UUVeusZCnFzUImoeNyQbH0CyAeTplx1Sfb2XlvPsBis6ErzI91UeQDJL5fQCFzKa1Wn0thEW6aKSfVROjR2EHWuKBYjap+8HfVmDsqz5B4Cxg1aBMsXu/pF+CkGgWAa7rvRSYSXFG2oVV/+6DU/EIbSQI70AcBokoOTyUOAyNjb4PJZ/8J8ftnot9N1Yge/mNHE7Tiv2o0T2iPEzBAn2T/ER3BNmtgLikvmaymwx1oTi07AdwZ81oBf61sQDw10XtC343TrEB3CMsAb7Cln/PObR/8sXeM79YpED27wkJKQjXNLey0kOsc4LaH81NRCDxWtf8KCGT5H1S/1EBTxt/Or1vdbIvcEqRRhLbRjCE02w1TFghnhkdk3FKVcpBEKeO2AJHNFL3vEdnPD6wUEOKJ2eTKSECikAaIqUznS1UgntgvrPAjVRsy5K69K9TG3aJx8jGx6hPjE6my6yYRMosbfVMNxc/Zwu4kOqk0ppRMbYs4vwSvNRJGYgk8APZbE415dPQOf5z/ejN0aoPa2Hu4ObxCnllXqWwAZwthZ4/3uQR5c7VT/gUa4CD27llAdMbDnF8D/W6
 O7jhG4Mk
 hjxQxVgwzJgqYeaFLnJOs6jGj5sWieNPhYR11PDUHuaKGKikH42iYzaWgpkGbcz+swU4ciEku8FvLfyAtRvapJxB2mllcJ9SEKhMUYld1kLcD9Tkcei7TVrSUDOGb5Lr84lJYTRx1UH9Y1qjsla5yFUKBkUkk8iKbs+nPYv1rli2qKxIVv+jvffVMj7bb5wsXU2ayADXosUL7zpff2pZIVCVwD0yRB/G+AteMKYyqfrw+86usEMwSKFvd7oSrWNNE6bwlFWagog6bVht624V+jSqD0PE5njLLWPJyzGCJ3TVsNelKb+4RRMuvGQiCH9EseoJjvAfDdsiXEhRjFCZtkowwUHKDg94B7oX5UvRM+mDI06ZWAFPyP8hgYxGxlA2ldC7EyPwUtyjDKiXmKLi+CMCbGB6ETygM5ZDSlL8zTeScDUM7IxFSd3/LApD3fRR6WzIk4KIqS7zsWRA34gL5yJ9x/q4EthDgHxXm30RnvPAaypb38UKEGuq45g==
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


