Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 597C0CD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2A646B00BA; Mon, 11 May 2026 04:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C026A6B00BC; Mon, 11 May 2026 04:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B17F36B00BD; Mon, 11 May 2026 04:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A39D76B00BA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A0EC1C1458
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:47 +0000 (UTC)
X-FDA: 84754528614.18.80223FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2FDF8100011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KJBrSiF+;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
	b=jboehrsVTyLXMWUsyFHA/YHDQxxyU8uIsHIqS9FpMTNQ3ZThzrVra0t10mXgEVlRbeyZBF
	iaMhxsyzk8hveOsCHjH0gBNMrySRPEfQEhsWVFnR7jlU+vHyShIAh51wIrIM5aT28FdfBd
	gBhMlQYR/oKCzBJsNXmD8F4dDBfF1+U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489685; a=rsa-sha256;
	cv=none;
	b=jnvhvN38i0RBRtk/r0JW4fGlr/RewfUYNHTIn7wl76h9EkuAC0xVEgDAxgiomk7sWRb1sg
	D5iinJnTLnkJL9qfTOyaH/W6nuFGKgUyMvhD0aDzJHboubolHwtCko2v9JhpyFf0H2XaQx
	rMqQR6Ep4l7v3eLz/o+JCKGp5Qzjat8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KJBrSiF+;
	spf=pass (imf14.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
	b=KJBrSiF+TcofYLNH3d9/XZ20CquK8xb6AND6LzN8hlFqmBhOu8nzLNikIObrn+GowA1R8e
	RCgreMF3X29vXmYvXa1J6coEt9os/i553GHhnBNDrUOrHKVzOO99BKvs+2SWhVGndMRwdU
	nQ72TlKSRUyZhpZR6U3lFXPuo1r+lGg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-lPH2shkJN2aEnIOHtdns-Q-1; Mon, 11 May 2026 04:54:41 -0400
X-MC-Unique: lPH2shkJN2aEnIOHtdns-Q-1
X-Mimecast-MFC-AGG-ID: lPH2shkJN2aEnIOHtdns-Q_1778489680
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48e5eecd0aaso22666805e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489680; x=1779094480;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q0Jd/7EvCnA8N9ANiNsWM9FOCa/+r1oqSAVkRa3NTmw=;
        b=sVlrwj/Wn028o2byfVeaGjWv3mHQHJTn5u9FHZ34v2AoXVEuoNQFwG2ytdQ9sTt5iQ
         xGPJ5MbIs+/Vl+kepvffOvLCdacS9sUbELembQwQsLxeVJWNt7FfMUplfzzKkVYuH11g
         L4UsNaJJpiu72Ni1+if09Z3O9FhXkDZicS8zQqEbi1ySxi0Io19mbUMZ/05Sc81mRJBL
         53B2c0yKd7McSjEm+O4bdYUs6/H4hwIlKTJVDRoN/D9zB/+HriW2HKleDB6cXO4bt4lK
         K1WOlbqwXegW/syt3yBxX60jcGHkyoD8In8yk0epdP78bm+T5XcginecKB+COrDnLQ5y
         OaZw==
X-Forwarded-Encrypted: i=1; AFNElJ8gDoIPg069ZPi7mYyY0EqciwGCpx65xjkErtgYThzT8bx2UJ60SMceODY0mycTJHK18V4EHTaCSw==@kvack.org
X-Gm-Message-State: AOJu0Yw+ZVukoRqzHR2TbGdsr23MnS7K5zk8Zd1CnLVtkn/woABsew4I
	LrNIP+No5lUFvP3QpjoG1JwmgyB7fwAZofQONHyVq0m2/8hixW5GHjs4GFoTPgjMZ725i7Cz+kD
	gUkJvjIcXOqswsv5qoaiubgsRngdkjIKj359EC68uZD0gHLCvTfeb
X-Gm-Gg: Acq92OGO7EJ0QrY9KkE3JBLMgEocgszyZIMx4/ha8BLjFs3OezDQXZuNYnz+EUqGka/
	HMnJFaktN8ayxKG9vhgx/GwBcBEib0o91ogLBURuQxCYSBdBKzpn6h7fJaJ5MLpjNpSLeDZsYsX
	7Cso0b0a0mCwW8OwZ0eqP7HuN8xh07GaYvMWt3c35s/WB409WmtuYu6EMxgHRcsPszVbEBE9Lgo
	M+cQ9QZexs5ehu3Z2UsJA+x6B9nQNB17+r9TscareD0d+P/HAnDx/g8L1U2xh7Dq2JWSBiZxwC4
	sNjiARcZ4ZHxr/s28uWljNoy8jvxCiahoRvGalP6s3mf89WpY+w8zY3MhFbHH4dA4Fv/go1MV+I
	BuqLlgYahQ+3VRkvz/XTrh9hzZw0RY88bvLkgWA19
X-Received: by 2002:a05:600c:c094:b0:48a:599a:3716 with SMTP id 5b1f17b1804b1-48e51f40a29mr268729245e9.23.1778489680018;
        Mon, 11 May 2026 01:54:40 -0700 (PDT)
X-Received: by 2002:a05:600c:c094:b0:48a:599a:3716 with SMTP id 5b1f17b1804b1-48e51f40a29mr268728595e9.23.1778489679389;
        Mon, 11 May 2026 01:54:39 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6dafa6c2sm81289945e9.5.2026.05.11.01.54.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:38 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:34 -0400
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
Subject: [PATCH v6 14/30] mm: memfd: skip zeroing for zeroed hugetlb pool
 pages
Message-ID: <8f111e92b512bf59570021fc0e71eef013289992.1778487000.git.mst@redhat.com>
References: <cover.1778487000.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778487000.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iLM8fnGOHdkV2KOnLCU1WDFLtG0sILwm5QnJU-Xy_rA_1778489680
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2FDF8100011
X-Stat-Signature: giq9rxu5bp31t3zqftny8tjk885da7uj
X-Rspam-User: 
X-HE-Tag: 1778489685-787194
X-HE-Meta: U2FsdGVkX18rdyjOsH57sDYFxVB40rL9g/GWlEyFki/7R31jVDJ1SYPAOFcYpJ47IbwvGbS2fZRfiG8nrqIjoZf3iNKFGBtQrn60KrGh8UYcBC5g0+I0gsAXbfO0AFzwaJ63gyC+qFjY62p54hJIpi8owyKnf7JFDhFHK2OkAzLgpX1CDwxFYIJsPvEixwJhSFN5HoZvA9ebShgwFJV/rtHYkuWteI2Om9rdPeFFDJrYDnrG6Mvbo2lB97L/d9h2i6ofB6iz27UH3FuvikNi2bAMDx7AUvIzLl9ECTDHwQO6bZnAhuq54aEGRnsbwRdEJdd/bOKvFCqxvS2iSfLGQw1qGU1eHdtB2+0gliDBdqv3OeMbmtgtOIDBwebRfe6Ui7XlkQSRSdqF975WuLzlv7x4uQpDLl0zhlkP63UlzTi3wj6gTNUKE0JBnd30icQf4d4VZhCb41NtO/SJKhPmq2DNxPkk7gSEP6xFSbB2NwrF+Ml+GSJm9jKedz6V6t8yeitXYIwd270J/1SdUBIKsBZ+3DeJE70Om2GuUb17ImGC/J1g9lZue1XsHfzFp9N1hLdyIdFlaK0cNv/o1RTdzOSEhcKTXrbxMhPeLYPi0Z1REER9DNRJeGDfDp+gmILj7v40FkOiYn+SfiQ0oj4YrUKQsjndW1pgLY8bPSCm0V4JuZB8pzaZaA+12wYbFSfuVhKEaC5OuNpT7w3vvHYpCdjKwQtCp+WuIG1PzN9lmuCZen0PC1MYijPpRtwisgT/Yd2pGlaUOw8BmjUZRZGcVuloeW67cKRCJ5H34AiFoiN7BHkfQD5jVhzzI39VRi+klGyhAgPmSzrehy2C1KS4Q4M0BukGjVXOWKKdTe+OIB+HZrK5fZhqRPfM+seCzuhtOdW8bq2mwMaklwOw+rj12LxEoneno8RZqsm+ajlG+2c8Avw57WgmIbMK6DKSd5GvP0Xj3xy6Kv8+j98rk6y
 FqFlnNDh
 3b10YaEkLlaikfxKInUb0ZrxXnUJjZidcjoWzXSvk76dq4h0vAQXArgdrS7fHgYQG9C1NSWA4ulIQBQ7af6GfTx8jemhYVyLylME01xlo7Ff/JHA4JRXPYnpjoiHJp4X6GiSeIVFWmIrj6WlOCsAw+2MPHkHjwLhDAFcnF982WIAz+PSar8+Vk9HBYmECKpRr61+dZNrCacHOHgG/HqFdzDEojsERixTedOzs1SwjTXxIgBVFPydBJoTFJWI0Q0XhUiSYhSNafrNi9SsKHtlcenoU5CcEhPx3Xl/a+cDXK5GSIREUuX+5LpSqD2xIuDcbm5HXFdYjU9uXypqlYpyvwd+n5BxZbn0u3lwmPYF19T+VlKhZeGPDvjZRndAop2quGxJPv9jNe9Z2l7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gather_surplus_pages() pre-allocates hugetlb pages into the pool
during mmap.  Pass __GFP_ZERO so these pages are zeroed by the
buddy allocator, and HPG_zeroed is set by alloc_surplus_hugetlb_folio.

Add bool *zeroed output to alloc_hugetlb_folio_reserve() so
callers can check whether the pool page is known-zero.  memfd's
memfd_alloc_folio() uses this to skip the explicit folio_zero_user()
when the page is already zero.

This avoids redundant zeroing for memfd hugetlb pages that were
pre-allocated into the pool and never mapped to userspace.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/hugetlb.h |  6 ++++--
 mm/hugetlb.c            | 11 +++++++++--
 mm/memfd.c              | 14 ++++++++------
 3 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 950e1702fbd8..c4e66a371fce 100644
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
@@ -1142,7 +1143,8 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask, gfp_t gfp_mask,
+			    bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8710366d14b7..03ad5c1e0655 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2205,7 +2205,7 @@ struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask, gfp_t gfp_mask, bool *zeroed)
 {
 	struct folio *folio;
 
@@ -2221,6 +2221,12 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
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
 
@@ -2305,7 +2311,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 		 * It is okay to use NUMA_NO_NODE because we use numa_mem_id()
 		 * down the road to pick the current node if that is the case.
 		 */
-		folio = alloc_surplus_hugetlb_folio(h, htlb_alloc_mask(h),
+		folio = alloc_surplus_hugetlb_folio(h,
+						    htlb_alloc_mask(h) | __GFP_ZERO,
 						    NUMA_NO_NODE, &alloc_nodemask,
 						    USER_ADDR_NONE);
 		if (!folio) {
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


