Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E798CD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2DD6B00A7; Mon,  8 Jun 2026 04:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7832C6B00A8; Mon,  8 Jun 2026 04:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCDF6B00A9; Mon,  8 Jun 2026 04:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B97D6B00A7
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:36:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 095F0932B0
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:08 +0000 (UTC)
X-FDA: 84856088016.14.20194D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id A1AB41C000C
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:36:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bPGpzErd;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780907765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hi0+oeNecn4eOEAyUzBbvo1srbN9H1YpFSy6pKNCWwo=;
	b=tyCFn2EXa/W20CMYiJ82m8/zoWC1Z+fMNvciXPqq3GR5r7jvEXDZshRvMv/UJFNuECoWIW
	927gfPv2ShDWviuMIKdD3IAFv8gEDO5mlAWTdPivi6iXE0tS3ubEgOiKsB1wfw+HcRsW3o
	ypLy3E1l2B/WdO84FETESmB/5QrI/DY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780907765;
	b=mzCcl9Dp/9CFpErXmvLfOJbpJLv0yA8nMx5eGjzgIR+TLXi/k3+Be4MtgGDbW83G0nu8iS
	tXn+wVeVt1MWqJv2cu1W1ebabGcWB/yaOonSpLeJWLgqiX8PS19a0Ytzb4Qp08WzXzA9Ex
	pFkDR6TD63TLIEt1OpbrYyvrokwBzsg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bPGpzErd;
	spf=pass (imf21.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780907765;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hi0+oeNecn4eOEAyUzBbvo1srbN9H1YpFSy6pKNCWwo=;
	b=bPGpzErds6FSQ98XFDWl5Aa7Z5tMKZsOnMGhTCu+rQYWzh+vlu2vqzaz5De5o8bXO1tGIv
	nIcuDdtLmY5PfwivCE44HVGFFLS/3jd+TVfV8t6SMtA41a3l4AwyI+3gxwlXrcMgrd+FmN
	19uYXZ2nmWW0nwlL0pZtn8SnxdLmAdQ=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-r-4jHvKMNhOGKHUW-jINaw-1; Mon, 08 Jun 2026 04:36:03 -0400
X-MC-Unique: r-4jHvKMNhOGKHUW-jINaw-1
X-Mimecast-MFC-AGG-ID: r-4jHvKMNhOGKHUW-jINaw_1780907763
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-46010bc0f1eso2338135f8f.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 01:36:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780907763; x=1781512563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hi0+oeNecn4eOEAyUzBbvo1srbN9H1YpFSy6pKNCWwo=;
        b=nwZZtgokCUAyMUCDC5XXISWFO42ApT7nAAAzr+ux6IO8uxZ8Dv4KH21L5iu5shmgnu
         0bzE79fpkYExhedO5SoK9DzTibO/Nad1W6XJN8kE4fEYFxsb7e0y1MixxTdNLiHRnssW
         uKA02wfAYlvXB4TuffCo9ZVv08rYXwTF6g68o8YjV17H7TQO2mM8COncieYS8pCEOUb1
         vxNNavScuk6vDGes4ASmc6YjT9QoqmD3LJ13abSWxVrJSmU2lMm+lbeBK553sk3h2nyo
         QXyuyEYpTjWOmzNGO2vz7gI+BP5Vs2515tlNfWonQ5HVJCQrQATDLDIu9VGvbjRSXH0y
         YRTQ==
X-Forwarded-Encrypted: i=1; AFNElJ9kVLlZqoGBUsr7tSWuqh1rp5FoVEtbHWFb/O5YbM40QPjQHrbFRbB2iQqm/wwWsNaAbVj8Wb+v6w==@kvack.org
X-Gm-Message-State: AOJu0YzQW+PYw3THkTWIJTBPfdPGOW7b2IvlbyLdfGMNXcA6UJDDFmb0
	1FymJocEJ4XMmc2EhX3sf6yiCcU8ToM2nD7+iO+9/ikaHGHErLBsiX2mX6Ij/B66Sw0Mu7yaM/h
	LtOXHWRTTPFiTBSK5lGk/b90Sv5LTX9ZvvU4y+8su61MjZiGWIc7j
X-Gm-Gg: Acq92OE2RHWsJpQLQ/OJLg4mS2IXOvrj+TJUc6cS09oBWp87c+ZvtzBKhvCiAgfxWPJ
	048viJ7lznWVfaF/anRfF1WO3cUdQE9Tr4W/4URgqE/6bsncPslRAifkd9nkh0GUsBnuLakY4R9
	5o1F6VZOaUKs82mCnFvW89DxiYcCHZkcaSR8c9Q8zQdibKqOcgNjPKuYTTIX9fCuFcLtJM+ykAs
	5eqMkDLmGF4K9XtU4wkYSeb+WTh1PHAz/Nbk9qv2hAFmHdMk7j+k5SbZgmXjSfrp8l+PbdDnia+
	4cjIi2tQZzGtLwjkeZS0zbKW3NCwsw9FaPRv5hadSre1If1pWNnYf9vhpEjWe5V4UPeBjMeRg4y
	zkYXtNZPCgQTLToc0dNIVpsQ=
X-Received: by 2002:a05:600c:6096:b0:490:b115:e03f with SMTP id 5b1f17b1804b1-490c25ba56cmr240971835e9.8.1780907762512;
        Mon, 08 Jun 2026 01:36:02 -0700 (PDT)
X-Received: by 2002:a05:600c:6096:b0:490:b115:e03f with SMTP id 5b1f17b1804b1-490c25ba56cmr240971115e9.8.1780907762056;
        Mon, 08 Jun 2026 01:36:02 -0700 (PDT)
Received: from redhat.com ([31.152.37.159])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2c9ea37sm425199295e9.0.2026.06.08.01.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 01:36:01 -0700 (PDT)
Date: Mon, 8 Jun 2026 04:35:44 -0400
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
Subject: [PATCH v10 09/37] mm: hugetlb: thread user_addr through gigantic
 page allocation
Message-ID: <c52f3d4252a63ac75ef7eaf07c1ee65784a3024e.1780906288.git.mst@redhat.com>
References: <cover.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780906288.git.mst@redhat.com>
X-Mailer: git-send-email 2.51.2.2891.g4157995a80.dirty
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MXa048WqFnbD9PYfh_0Y48GhbA2_cEk-FCWXsN2DB68_1780907763
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1AB41C000C
X-Stat-Signature: pjgidiuudxou9wjqruaki778tpgdnchf
X-HE-Tag: 1780907765-612373
X-HE-Meta: U2FsdGVkX18MxZkayqDnO9IzcO1EozdCYnLMNYkKg0sxfbA9mWaq/+9xLsV8j+8gGDfjjCtRolRijTS8G+D377uLYUYlyc6n/2H7gwAOJN9yYWddmmIIZ8xzJpTepIHcoVi6W3ROx5sZn9yhe+5gNrOmnujBI6tiVXhxqhnjfmSXWj0J8jGs89hXO+LJEL9CaG8L5qdOD+Qu5VvrbuvHs8Fxo7xYWbKYxj46bBtATR7+ZqAyR4CN1rCYN8oASLAyuGFp/In79sSkBGBEUYts91nLosfPD4/8HNGiQl5l1e+wXPRh1r8qntHc9KT0zYRtx4tysz3ObsLr8lquRSH9zckytxoky+8hv7waYCUnDF51Xoek7h9Yono4qKblXPMAMRCaufCWPXJbO5PYyP1o7EJ8AK1B/zowPkAMQBmUW/KOFd0Ir2XoGcqbsNnNFv9DXu/V2Jr23Zi3VVvQk3wOZERcYcJviP7+hMOJ9fJl2EXXscVlPOW4JRBj0k4gs/6sb5+sUi0W4fTeEOoJ5rqqZvzDEPVoBVtSIQDJVd3uZdZsEqoJB6/9E3G/j5ICswxtdL9Kqzt0UbVwcnB7nqWAzceOdlS0zaViYzlMbOhnmWYRLFfHuXHGKnqxC4+znEc5TuRwf85ZEWOD4yH91BtgDivTOV2uW6FFh6KDIOeK6YmrZwnXEhlr1jjpmpafHifXPm7eM7zG3w/zzSxwtZnizZSGLrR9ExMrbBnvyFdIJFnWl0f/KpiuaPcycYirh0N7dzEZqmgTjQMidwNIzJv9ov69qFuzKzOF7ZwfXjcqapmdueHEGc1YhjglMkw+MT5NFbpBMLWNZbZ/mU1hGedB60pN6bBI/g0Us0f6mZIsLboDAz2TbbSyxJVnkRVb1jo48xbnI/By7vckUKF1u2FbFhjh/XIi8KIngl6vfXID5g0Tju85xpRADEP2AXK1xB6AL3q3Yv7JmpWH3lNpFJx
 r5tkQLft
 gHBJDeowsNYxV3dctn7Wg/FnMLgO/mtLQLKPcY6FUyir6J1+dI/gh4X/e2BNlP3PI74zSrZLh73vQZkGvuqcJkmyOEmqr5Y2f6nO+RX5ZqH+fijDrJ+ersVYipYy0qD4om/pzfMoY0IJvx0MoxGWKVwz/++Meuk/l/sXCRJvCNr3/e02YVN67Y+MlFwdrMUZ5D70o6CCYL7V9AUw7FZLK9MR27iuwZS9ZWB5muouV9coyGByRvQSk98Zt+OWj5vdzM7gVh9Wl9S46s2Mv+YwfE1G1w0JvxP//4ZHUWH0HsYxcFYHGk3TEQeQtOqmHLSARtxL7h7tiDRW+MBlGNTiROIBlv84RKJQZSI70Wi23Lr7jImr4nh4eOkdbdB86HCCwi6uzAx1s5goAbU9tZ2IX5xbfihNK0S7y7OmHbAafDm2J+litYG5WckC1+e/6cjoDLMLG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thread the user_addr parameter through alloc_gigantic_frozen_folio so that
gigantic page allocations can benefit from cache-friendly zeroing.

Note: the CMA path (hugetlb_cma_alloc_frozen_folio) does not
receive user_addr because CMA uses alloc_contig_frozen_pages,
not the _user variant. CMA-allocated pages get zeroed via
the normal __GFP_ZERO path without cache-friendly addressing.
This is acceptable: gigantic pages are rare and the CMA path
is a fallback when buddy allocation fails.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/hugetlb.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index f3bc15a7889a..5d7e546565f5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1355,7 +1355,7 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 
 #if defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE) && defined(CONFIG_CONTIG_ALLOC)
 static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
-		int nid, nodemask_t *nodemask)
+		int nid, nodemask_t *nodemask, unsigned long addr)
 {
 	struct folio *folio;
 
@@ -1366,13 +1366,15 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
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
@@ -1842,7 +1844,8 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
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


