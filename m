Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24E6DCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0E16B00BA; Wed, 20 May 2026 18:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898906B00BC; Wed, 20 May 2026 18:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AECD6B00BD; Wed, 20 May 2026 18:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6794E6B00BA
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 36871C195B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:27 +0000 (UTC)
X-FDA: 84789223134.17.8463F21
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id DFCE818000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M8Rzke9D;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ha0MKvEjPpqKYjU+TNR9cOwfxNwOYM3BFVBNkyNiIfo=;
	b=Jpu+brmYUNhyNLpe2h5EqPKpoobxwv6DrEKPO5J4H5PFISp4TWlRsSNEhgHKcY2/eTtP/e
	ZnxuXUNZICyLPf1hBgX/lLIccHRGUu6m6TqBdxCJlQ5jYXvglDquHzOQxmtbv7AkQq8ys0
	Tc8jzx3UiQtyoutB3gfr0I+/27TEBUc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=M8Rzke9D;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315745; a=rsa-sha256;
	cv=none;
	b=Rb3y9fQ2B/Ue3oAfmIbvXR0wvIGYMfE5mcgTPBOr074Ymk0rnYqbv9WuNiQsqYXvvGurUt
	hRdK+2YfB5F4WFH5PpJU7M/pqDhx37nRPWfj7tjelHl57qwBYOR17eefZe7CMkmoLYIsMQ
	Ycg41cZ/NmrV5uPoWcZ8ka0R5/AdgPU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ha0MKvEjPpqKYjU+TNR9cOwfxNwOYM3BFVBNkyNiIfo=;
	b=M8Rzke9Dcg0AYjal93ef4JM+IULMFy9nSs6XpFb4RwnTIENJHGkVqS26rIFVHGYW6A0okG
	dA5MA2URC/G3oxXfXa4q3NBp9F4ZfSKTNiClL69qmK+TtCxGdndb/V6aH1sk7kVd25QIIe
	BgJBjVKQZkbGb1k5XoiLe3BFRcQfeJw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-EiG2tqA4Ohm_CCyyzA5GgQ-1; Wed, 20 May 2026 18:22:23 -0400
X-MC-Unique: EiG2tqA4Ohm_CCyyzA5GgQ-1
X-Mimecast-MFC-AGG-ID: EiG2tqA4Ohm_CCyyzA5GgQ_1779315742
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-44d83e45febso4336398f8f.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315742; x=1779920542;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ha0MKvEjPpqKYjU+TNR9cOwfxNwOYM3BFVBNkyNiIfo=;
        b=VVACJppOktRwQ35p4gobx5VV0n+XNnjvKE9BdhqK02P513jkvtlWbxYqaZqxqAk6zJ
         ZceK/+N+wvxDCjtNQlxCOOeBydT0vvg5kyVuHDOhi+mrWgMOOMixJ1RAJuaAx3xwIlnp
         IxmaNlQVnYtEfOYzxVY7S5w32qo5FMIXZZcIjSBmrWjo1DLCzzRTUuPYZFaF7WcEu6zI
         yX7UrCDNWLb0q8XV9oPT2B0q+vShnwnIk+xNuZxhje5UjHroDwBDfI3JacZCmXqKyl3g
         nqPCN0hpe100OEBTCitze47pqEbzI5RtLMOvVoKufj6e0+2pFvgY3IDInzpybYkJvrbY
         I/iQ==
X-Forwarded-Encrypted: i=1; AFNElJ9UlvECYRNVxUdLz75DUNZz6hrSK37crf0Gc25OORcQDwSrbjV3YbY4J+e9NUzQheLjO6XefjzeDg==@kvack.org
X-Gm-Message-State: AOJu0YwClh3wxwBYMDCLcKZXbse6bPLJnmN4Uk0NkOINDPxBmpYRQ4/O
	jxIat8++w06DMuJl8etFcbR8Ixez/ABj9CLJtVgZB+5o/5RTAbQHUygzFqU7XKQAJYLLzglmSf3
	FF9sNxAhY6RhnLRjYjbUhp/ERbBfTuH4DP7gSwVPsP5TcYL706WWG
X-Gm-Gg: Acq92OGXlZ/zOm66Xbb1LigKI0ydPcQrBQUa2zJYvBfBo+XoWouPfmwjwEZxHatpVbt
	hHqLjaPWGzftHCGCiFE7UtV7PyPmk6qHZ2Amp0J5qQMIjbyECdjtJl7RJLXQPi0Sjy52eWhrXOP
	/Xzq3roulJtojJPIBzQ2IIOL5C7wKnhaANEReOxIqWv/u4t8Hzw9ptFRUfsQIKwCYgTw/Q05pt5
	Oy+oTOpm18Bin9vn8R5tMVSR5QaiZReL7QELRAFxMV40eztAjuvVQAUfr5by3fUNhHYqHz+g6kP
	tVYEl0eP0K7XF5Ya2GZ/UVjyxsQJZKWp/KcOqKe0wPvTHq5z2kUjr3uvx4VSJQNXGAAy8tIe/lX
	sxow+OJrujGfyn6ED8p9wEDcJvhJCSi05cUZ8/A5W9/k=
X-Received: by 2002:a05:600c:8286:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-4903606a0bdmr2450595e9.6.1779315741697;
        Wed, 20 May 2026 15:22:21 -0700 (PDT)
X-Received: by 2002:a05:600c:8286:b0:489:32b:ac0b with SMTP id 5b1f17b1804b1-4903606a0bdmr2450295e9.6.1779315741251;
        Wed, 20 May 2026 15:22:21 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49033d3f99csm31986145e9.6.2026.05.20.15.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:20 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:16 -0400
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
Subject: [PATCH v8 21/37] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <05befd0e641749ea70c1289f5a6ea7edaed266d7.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dBjm0URVeav5e2j3BypERv-H42tXLy0Y1iF7A8h--XE_1779315742
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DFCE818000F
X-Rspam-User: 
X-Stat-Signature: sikgy5qu9ab7b3nwxzzuy3wiik7hgeqg
X-HE-Tag: 1779315744-740049
X-HE-Meta: U2FsdGVkX1856r+4N2sKyd9/wgKMPPfcYcOJsq++8wsCdxRAh6DBVSppoVy6toPe4BPNkY+2U6zOpghpmCTzZxPdpEwlXzscz6KESq5c3E0oB6T2iaOi6nILMY3vQkfff/TP7Bz8vK/qCuoNiHkTtHFapc18gkVVEUnemS8bcEFUw9y/O8hY/T8rS1JQ+ArhD9uCDZfJufRbdVJgrz/s4Y0xyAdGvnq9Y8yjk4G+uc9wwiporZLOrtkRyxVKDjroUuZ3OaA2qGQJ97IMxQpSVIR7cezMt6lGJWLXIILIsgsoK9J2IanTl6bBWi7e22AwKwFLIvHkInVdabbix24HSH3TgdI4CbjOLX65sv7f/Tmbp3/Yt81X8djtSQ0QV3zyuK2Bp2+7IhtVTCaV6yWGpgxV9ByUivYkbO0vsRfHMlE+EDrqGMpZcDVAc5sWq9Nc1Mfqk62XkdGkhPNTE5E57cBkMWg2L6Vz1Yo23YCQSDpkbqahXp/m3yAo/+WfsEXxnlkHCmayDJtwzMWac+exQM/MDFzfR1ogAw3fdXfUqaNgDN4KTJ4grK2EwHmbTcqAm0M4TiVUGo8C/m+Mknx81fmflZVsKOcT5KQvN9bNHETfIPaBiwQoMx+LnAttxd3vhBtXHI30qRjXbkoJ6jOosmKZ0r/dJ6pc4Ov9WfW/f90arPMAC7p6I+TkLAhG9UbwN6dRUGNRbcjfqlRITG7UlaGFZRjdB5Bi2Gkq+Lh3yzQPPVEluiHVeF/goDlYw0QUPKPR5QOncr5bzi12vhu0tjyZ2zjghcWv6ElEq8ohJATdeWbqgMww2lVlb0aXyxdL5GT//NUCeyK+FMSOjmfcn9UbbAjoHjbwZhPYfrxmk+053KH1cX57bbL/KBEwbelVIVs2Ib+2VWGhQDU1pHgq6zuyN9GzB6qt/f5ECWY/buX4zs2vqhXksVK2etvfumiYsM3rBizDiCs7n8ZnoQu
 LuI4l6zj
 PqG7i/Fsz7PQ0b7vbMNd9pWsx0Doj74irwcENTj1fDS6fXYnyjpD7MAF4TCnu5ZlO8R0WZm1Jj5udkEZB8FiKa5KDK82NMoQKYj/ns4SZRuAW9hLo3GFgMSu4j6T+UIQLwCFC7j/CZtnWhEE7OMHAcRTlXY8Ywanf519ylyfXsoRcbuqNXgP2L5waxAM5MuQ/NmWeng2d56wGGVuGeUIVUS1pDkPLE6Ab/aUKLFshu3Xwj7nSpi5vBDdmRmjTcV6CEsxzK1DHJdf0oJK5yRoYJV6ldIcCj0kXhvhKeRxSNmS8Iec/cMJJKWbH7xNX4Syx2LwAGxfi4R2MuJTokDWNk7Uh2LZ1mMVv6PK0atvneQl73bPnqTmPEaS3vC5N34Se1T7uOmf9mUpODQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/cma.h     |  3 ++-
 include/linux/hugetlb.h |  6 ++++--
 mm/cma.c                |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/hugetlb_cma.c        |  4 ++--
 mm/memfd.c              | 14 ++++++++------
 6 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1..dee88909cf5d 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -53,7 +53,8 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t caller_gfp);
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count);
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 49e5557d6cc0..3d23267014e6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -714,7 +714,8 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask, gfp_t gfp_mask,
+					  bool *zeroed);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1134,7 +1135,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/cma.c b/mm/cma.c
index c7ca567f4c5c..27971f6264ab 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -924,9 +924,11 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order,
+				       gfp_t caller_gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN |
+		    (caller_gfp & __GFP_ZERO);
 
 	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4ccf4eb91d92..649972101ace 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2208,7 +2208,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2224,6 +2224,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
 		h->resv_huge_pages--;
 
 	spin_unlock_irq(&hugetlb_lock);
+
+	if (zeroed && folio) {
+		*zeroed = folio_test_hugetlb_zeroed(folio);
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	return folio;
 }
 
@@ -2308,7 +2314,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h),
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 7693ccefd0c6..c9266b25be3d 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -35,14 +35,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 		return NULL;
 
 	if (hugetlb_cma[nid])
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
 			if (page)
 				break;
 		}
diff --git a/mm/memfd.c b/mm/memfd.c
index fb425f4e315f..5518f7d2d91f 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -69,6 +69,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
 	gfp_t gfp_mask;
+	bool zeroed;
 
 	if (is_file_hugepages(memfd)) {
 		/*
@@ -93,17 +94,18 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 		folio = alloc_hugetlb_folio_reserve(h,
 						    numa_node_id(),
 						    NULL,
-						    gfp_mask);
+						    gfp_mask,
+						    &zeroed);
 		if (folio) {
 			u32 hash;
 
 			/*
-			 * Zero the folio to prevent information leaks to userspace.
-			 * Use folio_zero_user() which is optimized for huge/gigantic
-			 * pages. Pass 0 as addr_hint since this is not a faulting path
-			 *  and we don't have a user virtual address yet.
+			 * Zero the folio to prevent information leaks to
+			 * userspace.  Skip if the pool page is known-zero
+			 * (HPG_zeroed set during pool pre-allocation).
 			 */
-			folio_zero_user(folio, 0);
+			if (!zeroed)
+				folio_zero_user(folio, 0);
 
 			/*
 			 * Mark the folio uptodate before adding to page cache,
-- 
MST


