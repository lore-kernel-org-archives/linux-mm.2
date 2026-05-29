Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2970ACD6E53
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730076B009D; Fri, 29 May 2026 11:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707A36B00C6; Fri, 29 May 2026 11:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61DCB6B00C8; Fri, 29 May 2026 11:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 534016B009D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 16D2A1C0D0B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:59 +0000 (UTC)
X-FDA: 84820825278.29.90B7BF6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC73220011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PmylRccW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gi0K9k7DoK/Ig5tkAzEbdYCqiHQSfFH4LjBzL6zaPFI=;
	b=Rp5pqKHn9UsaiMDTDh5VnY4M5WAMd/qU0g8YMcOvuH119plkeeQ4cNUfwbhhgAZAiuNmWb
	POiKy2iApWtXHLMwL1m4FMbgM5/j+mvEYs1lwZ8C7cdJrbcqn6EZF0lLBYE3vzChanxZA8
	L166uggdbFUpNRpsv+MFX9aFmHgSXug=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PmylRccW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068176; a=rsa-sha256;
	cv=none;
	b=I66Q4hOqb6RfUSm5+BD5p8zfCOhOXjphz4k2+X7ndXpGMGKDnR5XNDcwGAzWR5cfWdUpz9
	HCmODObWclon4Rgd+SimNtHBpqErz2ZObwZ+vVmm+FuSJWPdPY49Ykst/dqAwZDhZyAogz
	74UbSPRJkMbExDsMQlDXRsKQqw4+RSc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gi0K9k7DoK/Ig5tkAzEbdYCqiHQSfFH4LjBzL6zaPFI=;
	b=PmylRccW311Z+MMvDNCLSaMp4VU4TesskMljMXNNTRLlMNHIswo0TXL5SL+ZnNIM52aEoF
	2NNVIproN2COG6zti4ap3kHWF1cjU7MMwqRZ/OW1f7pWJvQXD8phGjy9A3sILto6MmnYkg
	HZsZEUYPS0uO/D4Q9H8BJ9ZTz+piL0I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-444-vAjRHHy3P9OaZeJfE2bBAg-1; Fri, 29 May 2026 11:22:55 -0400
X-MC-Unique: vAjRHHy3P9OaZeJfE2bBAg-1
X-Mimecast-MFC-AGG-ID: vAjRHHy3P9OaZeJfE2bBAg_1780068173
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4909deb82d0so5868535e9.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068173; x=1780672973;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gi0K9k7DoK/Ig5tkAzEbdYCqiHQSfFH4LjBzL6zaPFI=;
        b=KBkvAJixIFiA2cWOuDlSSYeIjub1bS8JJKWnX4+iAQgJw7NuBhB+nP0KGQnfjLApmo
         kP9NVsa743E68lyCG/Wy1tkoDTXMTNhNL7UftqnAWP0ZV9pXjm6zByv1R+5LBsvKnz+X
         JaW4KXu7BFGCYWkOIaV4iXpgfpGU7tfwo6Mc04OGFt+Rogp7Rj3Q0r7WJlwfZ/7BG071
         sAXVDLEL0IGUjAbNjMxn8g4nlP9PnD5of6BbwpERIQyGIaiNvZghdh8xRtxJ6d/7lifv
         sh3o/IPzXQTF3G8oSSKKisebKeghyMPN7rSoiPnLRuIMNXuGXmZ7b9MAa5GgMzLq2po7
         jOIg==
X-Forwarded-Encrypted: i=1; AFNElJ+0JnHmawZuMTOUT4Q2l7S4k+8ov/dK6X2jd85pzABxPkUUjWDDK5uwgfjYLGr7QHO+7T6UFLAi1Q==@kvack.org
X-Gm-Message-State: AOJu0YyfIwRbV5fCr8GGURukbUmUedVaxMjWy8+MAFq7FG/HsyqYNnGY
	8L69D4ynK3C9sIftoXS47YLB47Eh6J4PTZw1NcP6/p/rqaTLPYXkSoA6NxPu9dk/XP14zeh0TCa
	+DChm9X+3pDRBe4PzAkuPQqdME4nk9G9xwUrKVGjBwo/QSCJkJK8h
X-Gm-Gg: Acq92OGgKc5ZFzIWPaqHHTEPKkoZOq+P54XbP5yc0LHWlPW6JSB9ibEucwen18Bm609
	ioiQr/lmPxwlMeOKujAzdloRkMpWzCsJMN0mDxp0CnyDfulpDYopaVg7XZvaMAkd9aKonJWTfIQ
	44p8TlxErw8Bfdpbai/WJ4qTIU0PG8h7weAIdkX+KuPy7ovlspM5TrBQiidT2Qmz1JevWnmwzyb
	QVA+/w59Nuoqw0Ttb5ZYqimLbQcLuzOILu7y+a7GTpIpGtbLduFDJDAd4AP+8l8/4b1dEwuxxhE
	9AL9roiOvf0aPI7OgY+9f9MfHy3tRRwdJJFPDDfZaFVhWN23iLT9doXznQlqWMOgdFunjx7UPiH
	NAb/wZ5Y1mhbf+U2aO47z5yBcqJjcH1fk6H7caGjiR8IiFUnGnO60EQ==
X-Received: by 2002:a05:600c:4715:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-490a293bcaamr1010315e9.19.1780068172592;
        Fri, 29 May 2026 08:22:52 -0700 (PDT)
X-Received: by 2002:a05:600c:4715:b0:48f:be94:d82c with SMTP id 5b1f17b1804b1-490a293bcaamr1009735e9.19.1780068172085;
        Fri, 29 May 2026 08:22:52 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909d6975e2sm75634355e9.6.2026.05.29.08.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:51 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:47 -0400
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
Subject: [PATCH v9 09/37] mm: hugetlb: thread user_addr through gigantic page
 allocation
Message-ID: <cb0902af6b75ffbba69d091189090b9850152ec7.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LemWT5Q2aEn3Xpnm1JQLRmWBpHwaYpBtlvOOXB27yW8_1780068173
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: w1oog88nrmkgznitg5d6s45ftkfas7ke
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC73220011
X-Rspam-User: 
X-HE-Tag: 1780068176-864671
X-HE-Meta: U2FsdGVkX1/OuHrZ8VpLX3YhFWk8SFp7BcPip9PqalC2L+SxT7BDsgypQGG9t1kYSg3f4UmG3WewXHUL7fOUToHjw/D5zPlSEu9QVT75kQ8CVJDfRhfzEZAEU569pyr5IzCebexs4qyLoQdbWysfOwSkx4/6wyRCnaZSm20Tx1/ydNE7xIUWrSESksDQzMiwxuSYmH/jaQd9WtfrJP70+M54oP/ZBoD4zC78J7L6cJKic1S3hER1FqNXrUx2OkesCh56t6nazokzi1NYB59Ir5Fh/0UQE4NopysouiVToOeGyQw+dByxGy7BPdNxNLG+bnUhrUeX8qcZCiMihJ6uduAxT6il1Y+HMOgzKcMFtZBSs6z5dIqt8iEKdiGgAbP41lrAln0/T6vvyBs9kGsWkBmswpWqKg15XnQtwH7qb3JY4LdMyrUz0p+bhDm2wOus7YU+rof1EBCAYJ1QzG3wK3OKGgtiFCZe6/h61Hn7hZ7bCHcn+L86oqRDc+262locQL+vTRcIDagorC/kmkOm9zP2CyHfbVJJxTbTV1ssc69YEPU1+/8FD+FtmIgFUD1CGY2oqO/O4EhS8lv6TqyIlo9fD6JPNMoD3N8gXr1kTG+dNWPcYkxi1iKe5U/47f4qmVKymeHWxKMK3sDkRs4kKifKifOqL/3pn6dZ5ARY/l6AWFfB/6/uFVRNzTis0Ax7zLVxUOSELv/9s2/hUGNxIqACJxDFiBzvOBd8DOP44k0kW0w9UyYebEovQLm639eqkyHc4/PCrUpwignoho+BuxW71m+IOaUTZwfUY/dBnJdueZ1r1LqaNjFoHIM3zxym96d3+4j1zzLc8uhNIVSX6hDU0WF0z2TnQnQJA8JX3CNcO2Y50T2DlODDUDSSdaCQ0MXfpL501xceZJtCZj9ilIUbdxwRL4l6Mp9Vs2bVeisrzqngrWFey3SAaFdoBCH/KlioFh2I6j23wgL0ZuR
 jJIJacOu
 5HJ17A0xxDGCL5e689cuucPGciKKEpy7w7oh1kvUOxXO/v3ddj3wsIQMPf83b45Wr4cZmuK8IxtZYHdlqnJJXyhKpL75ogy8nPXyNpPmEX7CXoawJQelrjHzshEzAvk4VvmRfsC4UbKe1fBJ95S1cp5+E8Y7r8dGjenb06zyIYGnLa6q8rfSym+KEU/v9Ut0z+ULR1D3ZPcLwHAyi3Do54JD8B39pCfPsoBDXdwuExX0oTnWWRzv4jjayp7+fD2lFgbVVoVfN0d+krxGI3MshxDJakaE66d9l38Vi5jP5/MzhRtl0il6eP3BxizdbzdvtoJsv0cJ6a477l0VIxho9o1QU+fXV2nHvRxoVEbE2LfQ/XNZsjcoC+a89v9NpdIVUczFINgZRzr8fv9AipnavMwQt/sEzhd4mH8xKCLQg+nddxQ/qLM7ZWZ+J6BZQdmeCtI5tvwhWpCPkegHP5nVt+zoD0xzt/HdtP0zw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thread the user_addr parameter through alloc_gigantic_frozen_folio so that
gigantic page allocations can benefit from cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/hugetlb.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a999f3ead852..3a6afbe99116 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1375,7 +1375,7 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 #if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nodemask)
+		int nid, nodemask_t *nodemask, unsigned long addr)
 {
 	struct folio *folio;
 
@@ -1386,13 +1386,15 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
 	if (hugetlb_cma_exclusive_alloc())
 		return NULL;
 
-	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
-							  nid, nodemask);
+	folio = (struct folio *)alloc_contig_frozen_pages_user(1 << order,
+							      gfp_mask,
+							      nid, nodemask,
+							      addr);
 	return folio;
 }
 #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
-					  nodemask_t *nodemask)
+					  nodemask_t *nodemask, unsigned long addr)
 {
 	return NULL;
 }
@@ -1862,7 +1864,8 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
 		nid = numa_mem_id();
 
 	if (order_is_gigantic(order))
-		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
+		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask,
+						    addr);
 	else
 		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
 						 node_alloc_noretry, addr);
-- 
MST


