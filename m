Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD96CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388756B00EA; Fri, 29 May 2026 11:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 360136B00EC; Fri, 29 May 2026 11:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F066B00ED; Fri, 29 May 2026 11:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10D376B00EA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:24:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D099A1C0272
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:24 +0000 (UTC)
X-FDA: 84820828848.24.336D25D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 90CEB20005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:24:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrGi4OlM;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9A9ndauF873xtwqkChKCCeJTzSdyA513zveCjMygaEY=;
	b=fZB9AJvgV4TvZkHXTaNiYAibO9vW7XkZJYVp07O0AhhP7nyXY/Fd1/VkqH2Qr8PsslFpTD
	6midJ7ym9+ntZQKB5vQAVjsTkF1ktCzWrVEE6lSbrcbRuqXkbXWC9Z94HjxwZUn1CtGuUv
	Lj1Wineo3GJwezZWE/lVqJtHRZJ14XA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068262; a=rsa-sha256;
	cv=none;
	b=SzczMPn0SFJ2MrD/fwltozV+wuzzu/m5TJ+MASV3J1kwUYCfBG360iVAd2Ib3J2L/b1A9j
	f3A4VkyCX6MS/4Ugl1EQWj4sORs6wRw+x6LhEgQ8kJh6tMeM1jG61JHYI4SI6vSBHqyaoL
	S7+bd0n5NFBdxSjcLkAmOj9qUadIZ7g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MrGi4OlM;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9A9ndauF873xtwqkChKCCeJTzSdyA513zveCjMygaEY=;
	b=MrGi4OlMb69JuM5tOzOvW0wIQdN2IneoUXpVw7bvrwj1QXanS79MMrmYCrrGEGaF5VN5fn
	2brVTk9vc4Dq0Ahw2uzYqzheKyzWF9gGprsPkPrvi8XtYySqniIOA3e6gA8gMo6EN3odVV
	7fZM5nL/ETLLTkTJkN3Gjcb4sprLebI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-TedQFZI5NW6_wfFxCF2p0A-1; Fri, 29 May 2026 11:24:20 -0400
X-MC-Unique: TedQFZI5NW6_wfFxCF2p0A-1
X-Mimecast-MFC-AGG-ID: TedQFZI5NW6_wfFxCF2p0A_1780068259
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45ed830a0eeso2797761f8f.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:24:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068259; x=1780673059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9A9ndauF873xtwqkChKCCeJTzSdyA513zveCjMygaEY=;
        b=qzVr4Qwjbx6ito+hXgU8z2k94zQmTp74Al3PunShORLEWhm7m0UqFbgHs+AgTHFNoc
         Q6GG7pccjRGB+MXkw167KvSJfPmIkx7AbPu4tnPHAmkWWY3iaOI1d/KDmnEMdW7dTJiS
         sBg0XPz/XIveLZjGKzdgqoHMiVMKATv+D0xLiWOYeKbCfr8FzxnFw0iyKb+fa3+wHb/i
         /Kyc7dMvOBaueeJmZsI+ED/YjX5MSda6TXCe18vVHwTOm4+734RtAolib2R8aGdrId7U
         m+OQXr+tuiav7NKiHYgTCSJD3qRg/SIPKZfF3jZ57goEcK86QkL+80yVNspKlRNjDHJl
         HSdg==
X-Forwarded-Encrypted: i=1; AFNElJ+uuPYuIJyl3c4O6WRA1UHlxiwSxl4KEKW8SeAJFgqNTXDIPp+tyMz6NlDWglvwyA8MZ3mngxwcsg==@kvack.org
X-Gm-Message-State: AOJu0Yyft07VAOlWGiGE3MPrbzFSOU1hnCdmZgjryD9tlSLQEwW0uiHE
	pT20eRZX1GENs7Ds66gf0jSsywG3dxUUvz+Em+1NtknhDSZojj/LKytaGWFWp3auk7sc0ZQc/KQ
	Bpf/MG9qu9hMqm4rBesX7DSuQ9TJKlouZtbX14htuxNqJ1p55RsST
X-Gm-Gg: Acq92OGr+bLkfQHOy7lUap3p4m8yo3Gh6Z82p0GB7S0AKaXENROLHlyqfrY7+Cl4PXX
	4elpoy1GoY8sKjchuw3VbJdV3WLrUCkpchin20Fbxj0oQoqozKz4emzgTOgIsE7ziDyjnitphpN
	sZBZRiOJCLu+kI9Tz5HBZmL1EggIhp1/GaQd5TlhweV7tO+SEM+75kygkRkxuJvdgDVxqdAlh97
	LnfjUysBrDSufdzWL+u71oPPg5fO6Qv1THA/VJNe4O+uxzWh6/Mcs6YrmdpfbBBwBOY91QGL0RN
	gl6cbswMTRF8SZtr6B/C79ThfKNGPL+oxt3Wdxb0bzkjr4uVtBfW/hcvn/QSk6CV6H9+lquOi/3
	ENyH3Wb8MlwjWj11seugn69DwbMab7Ad3DHW2H7kTQM9lVk4fuwUbpA==
X-Received: by 2002:a05:600c:8582:b0:48f:d1c0:721e with SMTP id 5b1f17b1804b1-490a2921e1fmr1318835e9.12.1780068258684;
        Fri, 29 May 2026 08:24:18 -0700 (PDT)
X-Received: by 2002:a05:600c:8582:b0:48f:d1c0:721e with SMTP id 5b1f17b1804b1-490a2921e1fmr1318075e9.12.1780068258076;
        Fri, 29 May 2026 08:24:18 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909cab0e94sm51175135e9.12.2026.05.29.08.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:24:17 -0700 (PDT)
Date: Fri, 29 May 2026 11:24:13 -0400
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
Subject: [PATCH v9 22/37] mm: page_reporting: skip redundant zeroing of
 host-zeroed reported pages
Message-ID: <9c83fa52fe2e3cff6b14ea1819d8b4b6c6f7cb7c.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mayi7fe0rcKj50jHiDY1BTuqqfyrLywdCldWaY3ROTU_1780068259
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Stat-Signature: jk5zdtfh353to9k61uxxxn1wisfxz57g
X-Rspamd-Queue-Id: 90CEB20005
X-Rspam-User: 
X-HE-Tag: 1780068262-291246
X-HE-Meta: U2FsdGVkX1+v3s9e5mXGhktJS1W5spAQtPOJdi1btufeIb3t13D+VLQYUyEi8pClPbB5hFQAS4ieTXyBcCHPVkmuPHJXLIJD6MBmte4vH2A0uQF74LgcviXNYimI1L5SOv/2TiKLDwjmfbyNNBf6JDMwZPQhVNFuSZjNCyq/JapwBucLdqA1oT/nf27WmGEiKe/nlqxAZt/g2jTKGRrlrp56jRQVqYRTqHQc8tuWPy+KK7FeCSyP2H/2z87PO0EcB8WqsmaOU9PaFF9CNrbRU6hdsnyrOrIhQKtkHL4eAKT9NRJ+rjTczzbxJbo0dGX3hi8wineABVydwyCLSRdPAGJPqNJb+3b1u6N49JvunxMN/l+LrXb4GAqlbiaw1rW7tESa1nWooxrlaoGwN7AttUXJq4gPbdMRqflYCUDNhmCg5JBPgld3E3S5Fm/Qne2jqq6BX4J0ovZM7WOqIYRzGsZnYzPGwMHfPJZTaJAcKZ7e5AMcCD/bIuhLimcKt+PtPwnF/l8Mmf4IxBk3ryk3N2oNaiDxQa19COxuklEECrct7+fG5/KlJnsIanPlXUX1sH0l8x5Mkx5oaAA2hUGRIMVImSS+x3AlYEjQy2J0ZU2kWdKVvDLfHY459IotsYS0W3WypTyXLik37ACvcMwtOWmk7GvKbw5KiS6CYHvGYkWb9HIVG5e9fIop7Bcqdq5vOeaKvR7mCwoo5LqysJwlRjLfAygaL08j7nwNRpJtQVrPWroCRmkUDnclqHTGq+44yKfOn3Avo69H6p5o6QrX4iWw0+wBJV92qIBuAjNaxg2Iq3iBqBmWldou6VSdk+hPtLMObWfXcBZo8V4Vfi3aHpgrojsOnjtBt02F90dir5DtCevsyg6zUqC6zCQbnicjDBZajY7HOYqrxhqHRyd2BXglfCh8CNtQJCC/RDDcB0xim+MTlVKuGg1bXOjDdZt9Gwr6ZUI0LgE4s4kusru
 L2LkSMra
 egQqX9/BejdMkoy9ZBeW3hsSPw/DI4GnhitK4SZNLyNZ17axxnApeIgJ/zigi0EQCp4aYeNd8qfzr/UInf1u8KDh0wocxB9YVwyoVmVtRQv9VNfx3T2DLYHVjNZc0TU+P5gHprdhoSj1szrgIH4RWdL+FSXq6PYDWdg3CP+GlVqFvz0niVZexBZLimH+PEoc8Dk9LtlxXy0pkScuHrjQGrXu5O2pqaxTGI6+2EnFzT2a2pw0HxZOpvEACVm20OKuR4I+joZhoasjOX2ssyStPEOrkXDMVmWT0plTE6W9xhrE0qJbuurXmbd7A62+3CEEQdjdNxTRL95uvbny0BmrZhqftJXqjUeRhL3QyZEQ0yPZ/FNtmFGlujquXG+wxTi62UeOmZgV+WzCcCEKLRj66xpplIMameiFB74PFmsxMHNlVuGvKINvKgG90AtPTeTfEv2b3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a guest reports free pages to the hypervisor via the page reporting
framework (used by virtio-balloon and hv_balloon), the host typically
zeros those pages when reclaiming their backing memory.  However, when
those pages are later allocated in the guest, post_alloc_hook()
unconditionally zeros them again if __GFP_ZERO is set.  This
double-zeroing is wasteful, especially for large pages.

Avoid redundant zeroing:

- Add a host_zeroes_pages flag to page_reporting_dev_info, allowing
  drivers to declare that their host zeros reported pages on reclaim.
  A static key (page_reporting_host_zeroes) gates the fast path.

- Add PG_zeroed page flag (sharing PG_private bit) to mark pages
  that have been zeroed by the host.  Set it in
  page_reporting_drain() after the host reports them.

- Thread the zeroed bool through rmqueue -> prep_new_page ->
  post_alloc_hook, where it skips redundant zeroing for __GFP_ZERO
  allocations.

Currently the PG_zeroed hint can be lost when pages are
split (expand) or merged in the buddy allocator.  This is
harmless: losing the hint just means the page gets re-zeroed,
which is correct but suboptimal.  Follow-up patches propagate
PG_zeroed across splits and merges to preserve the hint on
common paths.

No driver sets host_zeroes_pages yet; a follow-up patch to
virtio_balloon is needed to opt in.

PG_zeroed pages may pass through PCP lists before being freed.
This is safe: __free_pages_prepare clears all
PAGE_FLAGS_CHECK_AT_PREP flags (including PG_zeroed/PG_private)
before the page re-enters the buddy allocator.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page-flags.h     |  9 +++++
 include/linux/page_reporting.h |  3 ++
 mm/compaction.c                |  6 ++-
 mm/internal.h                  |  2 +-
 mm/page_alloc.c                | 68 +++++++++++++++++++++++-----------
 mm/page_reporting.c            | 14 ++++++-
 mm/page_reporting.h            | 12 ++++++
 7 files changed, 88 insertions(+), 26 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 0e03d816e8b9..4ee64134acc3 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -135,6 +135,8 @@ enum pageflags {
 	PG_swapcache = PG_owner_priv_1, /* Swap page: swp_entry_t in private */
 	/* Some filesystems */
 	PG_checked = PG_owner_priv_1,
+	/* Page contents are known to be zero */
+	PG_zeroed = PG_private,
 
 	/*
 	 * Depending on the way an anonymous folio can be mapped into a page
@@ -673,6 +675,13 @@ FOLIO_TEST_CLEAR_FLAG_FALSE(young)
 FOLIO_FLAG_FALSE(idle)
 #endif
 
+/*
+ * PageZeroed() tracks pages known to be zero.  The allocator
+ * uses this to skip redundant zeroing in post_alloc_hook().
+ */
+__PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+#define __PG_ZEROED (1UL << PG_zeroed)
+
 /*
  * PageReported() is used to track reported free pages within the Buddy
  * allocator. We can use the non-atomic version of the test and set
diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
index 5ab5be02fa15..c331c6b36687 100644
--- a/include/linux/page_reporting.h
+++ b/include/linux/page_reporting.h
@@ -14,6 +14,9 @@ struct page_reporting_dev_info {
 	int (*report)(struct page_reporting_dev_info *prdev,
 		      struct scatterlist *sg, unsigned int nents);
 
+	/* If true, host zeros reported pages on reclaim */
+	bool host_zeroes_pages;
+
 	/* work struct for processing reports */
 	struct delayed_work work;
 
diff --git a/mm/compaction.c b/mm/compaction.c
index 4336e433c99b..8000fc5e0a2e 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -82,7 +82,8 @@ static inline bool is_via_compact_memory(int order) { return false; }
 
 static struct page *mark_allocated_noprof(struct page *page, unsigned int order, gfp_t gfp_flags)
 {
-	post_alloc_hook(page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	__ClearPageZeroed(page);
+	post_alloc_hook(page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
 	set_page_refcounted(page);
 	return page;
 }
@@ -1849,9 +1850,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
+	__ClearPageZeroed(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
 	set_page_refcounted(&dst->page);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
diff --git a/mm/internal.h b/mm/internal.h
index 389098200aa6..fd910743ddc3 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -928,7 +928,7 @@ static inline void init_compound_tail(struct page *tail,
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
-		     unsigned long user_addr);
+		     bool zeroed, unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index ad0655387e9d..5158f7e23d18 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1746,6 +1746,7 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
+
 	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
@@ -1818,8 +1819,10 @@ static inline bool should_skip_init(gfp_t flags)
 	return (flags & __GFP_SKIP_ZERO);
 }
 
+
 inline void post_alloc_hook(struct page *page, unsigned int order,
-				gfp_t gfp_flags, unsigned long user_addr)
+				gfp_t gfp_flags, bool zeroed,
+				unsigned long user_addr)
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
@@ -1828,6 +1831,14 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
 	set_page_private(page, 0);
 
+	/*
+	 * If the page is zeroed, skip memory initialization.
+	 * We still need to handle tag zeroing separately since the host
+	 * does not know about memory tags.
+	 */
+	if (zeroed && init && !zero_tags)
+		init = false;
+
 	arch_alloc_page(page, order);
 	debug_pagealloc_map_pages(page, 1 << order);
 
@@ -1870,7 +1881,7 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 	 * through a user-congruent mapping.  Host-zeroed pages
 	 * (zeroed flag) don't need this: physical RAM is clean.
 	 */
-	if (!init && (gfp_flags & __GFP_ZERO) &&
+	if (!zeroed && !init && (gfp_flags & __GFP_ZERO) &&
 	    user_addr != USER_ADDR_NONE &&
 	    user_alloc_needs_zeroing())
 		init = true;
@@ -1903,13 +1914,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 }
 
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
-							unsigned int alloc_flags,
-							unsigned long user_addr)
+			  unsigned int alloc_flags, bool zeroed,
+			  unsigned long user_addr)
 {
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
-	post_alloc_hook(page, order, gfp_flags, user_addr);
+	post_alloc_hook(page, order, gfp_flags, zeroed, user_addr);
 
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
@@ -3175,6 +3186,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	}
 
 	del_page_from_free_list(page, zone, order, mt);
+	__ClearPageZeroed(page);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -3247,7 +3259,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *zeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3282,6 +3294,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	/*
@@ -3350,10 +3364,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
 /* Remove page from the per-cpu list, caller must protect the list */
 static inline
 struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
-			int migratetype,
-			unsigned int alloc_flags,
+			int migratetype, unsigned int alloc_flags,
 			struct per_cpu_pages *pcp,
-			struct list_head *list)
+			struct list_head *list, bool *zeroed)
 {
 	struct page *page;
 
@@ -3388,6 +3401,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3396,7 +3411,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *zeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3414,7 +3430,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, zeroed);
 	pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3439,19 +3456,19 @@ static inline
 struct page *rmqueue(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
 			gfp_t gfp_flags, unsigned int alloc_flags,
-			int migratetype)
+			int migratetype, bool *zeroed)
 {
 	struct page *page;
 
 	if (likely(pcp_allowed_order(order))) {
 		page = rmqueue_pcplist(preferred_zone, zone, order,
-				       migratetype, alloc_flags);
+				       migratetype, alloc_flags, zeroed);
 		if (likely(page))
 			goto out;
 	}
 
 	page = rmqueue_buddy(preferred_zone, zone, order, alloc_flags,
-							migratetype);
+			     migratetype, zeroed);
 
 out:
 	/* Separate test+clear to avoid unnecessary atomics */
@@ -3842,6 +3859,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool zeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3986,10 +4004,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 try_this_zone:
 		page = rmqueue(zonelist_zone(ac->preferred_zoneref), zone, order,
-				gfp_mask, alloc_flags, ac->migratetype);
+					gfp_mask, alloc_flags, ac->migratetype,
+					&zeroed);
 		if (page) {
 			prep_new_page(page, order, gfp_mask, alloc_flags,
-				      ac->user_addr);
+				      zeroed, ac->user_addr);
 
 			return page;
 		} else {
@@ -4216,9 +4235,11 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	count_vm_event(COMPACTSTALL);
 
 	/* Prep a captured page if available */
-	if (page)
-		prep_new_page(page, order, gfp_mask, alloc_flags,
+	if (page) {
+		__ClearPageZeroed(page);
+		prep_new_page(page, order, gfp_mask, alloc_flags, false,
 			      ac->user_addr);
+	}
 
 	/* Try get a page from the freelist if available */
 	if (!page)
@@ -5191,6 +5212,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool zeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5199,7 +5221,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &zeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5210,7 +5232,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
+		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6950,7 +6972,8 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
+			__ClearPageZeroed(page);
+			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7156,8 +7179,9 @@ static int __alloc_contig_frozen_range(unsigned long start, unsigned long end,
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
+		__ClearPageZeroed(head);
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, user_addr);
+		prep_new_page(head, order, gfp_mask, 0, false, user_addr);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index a6ddf6fafc20..8d52718be876 100644
--- a/mm/page_reporting.c
+++ b/mm/page_reporting.c
@@ -50,6 +50,8 @@ EXPORT_SYMBOL_GPL(page_reporting_order);
 #define PAGE_REPORTING_DELAY	(2 * HZ)
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
+DEFINE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
 enum {
 	PAGE_REPORTING_IDLE = 0,
 	PAGE_REPORTING_REQUESTED,
@@ -129,8 +131,11 @@ page_reporting_drain(struct page_reporting_dev_info *prdev,
 		 * report on the new larger page when we make our way
 		 * up to that higher order.
 		 */
-		if (PageBuddy(page) && buddy_order(page) == order)
+		if (PageBuddy(page) && buddy_order(page) == order) {
 			__SetPageReported(page);
+			if (page_reporting_host_zeroes_pages())
+				__SetPageZeroed(page);
+		}
 	} while ((sg = sg_next(sg)));
 
 	/* reinitialize scatterlist now that it is empty */
@@ -390,6 +395,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -414,6 +423,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
 		/* Flush any existing work, and lock it out */
 		cancel_delayed_work_sync(&prdev->work);
+
+		if (prdev->host_zeroes_pages)
+			static_branch_disable(&page_reporting_host_zeroes);
 	}
 
 	mutex_unlock(&page_reporting_mutex);
diff --git a/mm/page_reporting.h b/mm/page_reporting.h
index c51dbc228b94..736ea7b37e9e 100644
--- a/mm/page_reporting.h
+++ b/mm/page_reporting.h
@@ -15,6 +15,13 @@ DECLARE_STATIC_KEY_FALSE(page_reporting_enabled);
 extern unsigned int page_reporting_order;
 void __page_reporting_notify(void);
 
+DECLARE_STATIC_KEY_FALSE(page_reporting_host_zeroes);
+
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return static_branch_unlikely(&page_reporting_host_zeroes);
+}
+
 static inline bool page_reported(struct page *page)
 {
 	return static_branch_unlikely(&page_reporting_enabled) &&
@@ -46,6 +53,11 @@ static inline void page_reporting_notify_free(unsigned int order)
 #else /* CONFIG_PAGE_REPORTING */
 #define page_reported(_page)	false
 
+static inline bool page_reporting_host_zeroes_pages(void)
+{
+	return false;
+}
+
 static inline void page_reporting_notify_free(unsigned int order)
 {
 }
-- 
MST


