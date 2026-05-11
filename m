Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA51CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92A326B00F2; Mon, 11 May 2026 05:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902116B00F4; Mon, 11 May 2026 05:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0A56B00F5; Mon, 11 May 2026 05:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7026B00F2
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2A55140686
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:38 +0000 (UTC)
X-FDA: 84754550916.14.7C4CB6A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id C8DEF1A0008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKuqvzZF;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7pKWc4JWD9TR0gt2XZNvXhAZcErXVmSBtqXvun1gtY=;
	b=rvr3EdNxQrr8D5Xogoqpc2SehxX3D2uJAc8aXPmQAA0QOnGgSTDhfJB2XEKAWJ18G44JN7
	At4MX7n8ATgGlHuBMC/gBski8INIcV5ytOiY+Sb18OuIK6+osQmOTF84LPB1rWOzQJNWgA
	rmM8pXAsdmRppjCBevszHlvVXwX248I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FKuqvzZF;
	spf=pass (imf19.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490215; a=rsa-sha256;
	cv=none;
	b=RAjM3VhLC1T5QGMCKTtOAjGI5/XOAY71IzBTPw77a6iWTHJbhizbJm2ZameVp4L1CwBAqp
	BuRXFgdugJliUGYObNlc5EbFrjXyEOcaKVZoT5uDE6vCnyiWi5bDQm3vQa9RZXMh7SiaPl
	0VYC5hQw7+H6uUBCuVq8eUhyaCgGvL8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+7pKWc4JWD9TR0gt2XZNvXhAZcErXVmSBtqXvun1gtY=;
	b=FKuqvzZFkSn4Q+nwWbpuHHUMPsYf5LdnXkVwq0bkTDV2DxZ5H4eli/ERKYgeF1ss8K/1Gq
	h59aboumRgZVKW1EOrSIdnQRt05X3BDPFyIPgehXZIlA2yQ/w7omZFDJXwL7GFR7lc/6Cr
	mh5psQmfI7NS59trozFAS5ICgVurSNU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-501-vxag1PdZPCiSpeUq_deIHQ-1; Mon, 11 May 2026 05:03:33 -0400
X-MC-Unique: vxag1PdZPCiSpeUq_deIHQ-1
X-Mimecast-MFC-AGG-ID: vxag1PdZPCiSpeUq_deIHQ_1778490211
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-48d127eb013so22820845e9.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490211; x=1779095011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+7pKWc4JWD9TR0gt2XZNvXhAZcErXVmSBtqXvun1gtY=;
        b=qRKq37odrrxiunn8GYXm8SJgnicekxd6eP7fNrlcqvqBspyk2KDpq+NL56yG/9K2ol
         Hy7FdSi776WejYYVn3jGgYad3gUkwwIycYeXv1gvx4o3S77kQTCef2WSI+o/krjqCzPU
         j4DBTdjArZQVlNdkSgn56cw4EmJnFDajPzjTN/DFJqrYIIx/HGDCLlXvB4hjXak+zouA
         kusom1VSesRXHeYkYJBRTI+LGKUlXlU31JX+XT36m1KjRkt23uopsLAl3z0zdhxt3VxH
         DHtoHgxkPks5SUqFoBvYu+iVArLdQgXHy/00pFMU+Ztl9nWID1Up1RQmCJlzmFmDL7dS
         +bfw==
X-Forwarded-Encrypted: i=1; AFNElJ9jKUn+bPF62ZdL/kifgFD8zxmhsD+7296ql0H+Q/vUERz8AgS+WHNnWO97hdx9r4EZuf5oQEf4lg==@kvack.org
X-Gm-Message-State: AOJu0YyYGq2cmQhSXc6xyj/Ld2FF6X/zsg9Y6Tz8hk92a79LUo3YlCGt
	lf4TFsz3h8F8Hs2/3FTA14rEFkEOKNgwJQ77cnKHnh1tOcwjmxAk4kZOZws5obvg8lhz8q4Nuot
	qBx8qF4z6JYYGcMkcGkfNW7eEfkg3HhL1MSoa/TfBrsP6pLRDhRny
X-Gm-Gg: Acq92OH2ZVOzsilxlSouAfqnbDqySKaCJvMCqEQ9KJBHkGKxLxa8fu/cgKraFLTSi4Q
	YqrUyp4fjIbluPuJag9CtjOF6NI69r9Ueq5QOkp5i8kOYNxgqZ96f6wzdojXOx7ypy36/Bp1sWW
	nhX1Cdj+5tqaLyr6Zq4dkeQmheXDIEl2sBFgMOfd72lPq9QWYPdbjT9pmVbHdE+Bt3kPvYnOHKm
	PlJiyfttU8gBU0FRaPCjUuDaSSsjAHdA+sTwafxMt9stC3joYxrgYyO0k3KOKm43yRFguPsezw/
	8QP26ToTcXGW4IyuuBVdWX0MZn9RP2C1vaS5ngZTcUmPSMoQvIJRCoQCaupTMqNTGMoTupc3O4T
	yps2odSZUdrsgtk6tqS8UlyD0YHzGR04aEnQn6dQI
X-Received: by 2002:a05:600d:8496:20b0:48e:86e6:c2f1 with SMTP id 5b1f17b1804b1-48e86e6c38fmr9654315e9.2.1778490210776;
        Mon, 11 May 2026 02:03:30 -0700 (PDT)
X-Received: by 2002:a05:600d:8496:20b0:48e:86e6:c2f1 with SMTP id 5b1f17b1804b1-48e86e6c38fmr9653555e9.2.1778490210030;
        Mon, 11 May 2026 02:03:30 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6f9fc89asm182328085e9.0.2026.05.11.02.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:29 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:24 -0400
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
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>
Subject: [PATCH resend v6 18/30] mm: page_reporting: skip redundant zeroing
 of host-zeroed reported pages
Message-ID: <696f60c35b95b65fcb5872ae3f6ab6ffa194b555.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ujjdEFGMKcMnAlKSMgtPxhe32SEYsSULWQjRPeHVYCQ_1778490211
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: dy7ea1fewopr36ahfp7txbaok75d5s3k
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C8DEF1A0008
X-Rspam-User: 
X-HE-Tag: 1778490215-952811
X-HE-Meta: U2FsdGVkX1+gsN60WLrPaq+GmMLoQunHx4f7h1a7Uo9zILGQtPMPUcVw1BfEIuHBv4bWRwVnJICgYKG6YfnFOCTH/UwMnpFRk/SaQJ12iQD2DRziEMexRhVb6pXYnh4qBiPPSS5bgKOmhJ+8Sko2cBDoHef73RbJhntCB3sJGnH2kYQHeAYhRJbZlMQ/zJT8T90y0dnfPPUGqtUJF2fYYgmUSmNpQ3yQFJu24L5dRqc48cnfXakK9/1n2ojVR6v8Q/T2stcLLIqnfRQa0LKbecMpeaQsAt0ZL/tmkIetWffyO5e8d6EtD/5g7Wqekp9xXEF4JDStXnOxvBWwlu3bn7SIweWjFbJNGudYsrrspdi7Z8zWIjBrvPZx1V3RbA2MW57JuEjpMWIfC7joX1h0hHFWWvCIF7WfMY8YnYC0D+sVVRWbjxRG94Q/Yig441W7XXVZv4ehTI9hm0KzK9fCoZq2fhzGj5wReaCpLtbN4szGgPzIzyKf3Z59hHAns8gHProrEYABE+u0HT70Lol3TsMP6r8SSuU/d1sjoZNGoFEBqRn4bugjbVQkR8FTm2pvMhJO/3ef6TR2Q2gZxASzXdpMAquc5Lnwrr4ics614ihPChw3BrzXvRFIiuUElC1Y+SGfzNZqhreQgAe5r4kI3V4GRXgLJ1AXCrAV6W+ONt5hYvuHfAcYaz69WnJDHSxm9EyJpaQrihXKqWis102NCrltrUo0xR/3nWfUEsPZhZJ5I0gxacJxGlkWDQDUOGG2OlT9Xs23aPz8ZhihacBclY3EtbXsFlMZqsFQt8mrWwsTmi8MMXzi1gm95iDBxZet9KIhcQFyUzuB0CnbGUrQ/oiCA17XW2T0yskWlKtMJFFVMwqnn550RNtISq9t0C/PRV1xBAUGDuZIwWeS07yRosHKBLRPqujQ+pbeHcI9adyjDMkuxeUdYOsEPDgVjStOyZ2B7vKdkTPh9S/vdIH
 1nNerhOe
 MtCDsP10p6cnwxfQvOVPOh4yzoIob8rFCdNEkyNe8Be4I4MIc34zqDjcaM/tcwbo6ZzYIyC8AHaD7AySNlWKEoPpaH4fXh2HSzLXnSceCiVePcy+VWDUAQ1uzI54bJqKhmrn7iMt2PGt1NOLnqW974h7fqToraAgCROJ6or2fPS+kIP68iITsZCjm6LpNqJHAgyLi0coKxUNAq7dqMwenRx1Vv9LHPkv95YDcL6jL0ysZ9qB3QT6zDWoLHtswJIoAXfHUJD8q5r5Tb6zpMPVapxiNzcq2zTaTC/+Z63obX7qCRQKQ/3lhg9+/J3YSsbR5Sh3Ylf918rDtB0AEPAqPKqGFQAJcwrWHG0uHl9CLvKfqnXAp2VjunZKL5Zb5FG3c0VtFO44FgSh68x2EfYjrmNWjQA==
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

No driver sets host_zeroes_pages yet; a follow-up patch to
virtio_balloon is needed to opt in.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page-flags.h     |  9 +++++
 include/linux/page_reporting.h |  3 ++
 mm/compaction.c                |  6 ++--
 mm/internal.h                  |  2 +-
 mm/page_alloc.c                | 66 +++++++++++++++++++++++-----------
 mm/page_reporting.c            | 14 +++++++-
 mm/page_reporting.h            | 12 +++++++
 7 files changed, 87 insertions(+), 25 deletions(-)

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
index 72684fe81e83..0471c5326ec0 100644
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
@@ -1849,7 +1850,8 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	__ClearPageZeroed(&dst->page);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, false, USER_ADDR_NONE);
 	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
diff --git a/mm/internal.h b/mm/internal.h
index 751ae8911607..fa7ffea4d492 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -924,7 +924,7 @@ static inline void init_compound_tail(struct page *tail,
 }
 
 void post_alloc_hook(struct page *page, unsigned int order, gfp_t gfp_flags,
-		     unsigned long user_addr);
+		     bool zeroed, unsigned long user_addr);
 extern bool free_pages_prepare(struct page *page, unsigned int order);
 
 extern int user_min_free_kbytes;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 76f39dd026ff..bd3b909cacdf 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1743,6 +1743,7 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
+
 	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
@@ -1815,8 +1816,10 @@ static inline bool should_skip_init(gfp_t flags)
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
@@ -1825,6 +1828,14 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 
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
 
@@ -1882,13 +1893,13 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
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
@@ -3154,6 +3165,7 @@ int __isolate_free_page(struct page *page, unsigned int order)
 	}
 
 	del_page_from_free_list(page, zone, order, mt);
+	__ClearPageZeroed(page);
 
 	/*
 	 * Set the pageblock if the isolated page is at least half of a
@@ -3226,7 +3238,7 @@ static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 static __always_inline
 struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			   unsigned int order, unsigned int alloc_flags,
-			   int migratetype)
+			   int migratetype, bool *zeroed)
 {
 	struct page *page;
 	unsigned long flags;
@@ -3261,6 +3273,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	/*
@@ -3329,10 +3343,9 @@ static int nr_pcp_alloc(struct per_cpu_pages *pcp, struct zone *zone, int order)
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
 
@@ -3367,6 +3380,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 		page = list_first_entry(list, struct page, pcp_list);
 		list_del(&page->pcp_list);
 		pcp->count -= 1 << order;
+		*zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
 	} while (check_new_pages(page, order));
 
 	return page;
@@ -3375,7 +3390,8 @@ struct page *__rmqueue_pcplist(struct zone *zone, unsigned int order,
 /* Lock and remove page from the per-cpu list */
 static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 			struct zone *zone, unsigned int order,
-			int migratetype, unsigned int alloc_flags)
+			int migratetype, unsigned int alloc_flags,
+			bool *zeroed)
 {
 	struct per_cpu_pages *pcp;
 	struct list_head *list;
@@ -3393,7 +3409,8 @@ static struct page *rmqueue_pcplist(struct zone *preferred_zone,
 	 */
 	pcp->free_count >>= 1;
 	list = &pcp->lists[order_to_pindex(migratetype, order)];
-	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags, pcp, list);
+	page = __rmqueue_pcplist(zone, order, migratetype, alloc_flags,
+				 pcp, list, zeroed);
 	pcp_spin_unlock(pcp);
 	if (page) {
 		__count_zid_vm_events(PGALLOC, page_zonenum(page), 1 << order);
@@ -3418,19 +3435,19 @@ static inline
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
@@ -3821,6 +3838,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 	struct pglist_data *last_pgdat = NULL;
 	bool last_pgdat_dirty_ok = false;
 	bool no_fallback;
+	bool zeroed;
 	bool skip_kswapd_nodes = nr_online_nodes > 1;
 	bool skipped_kswapd_nodes = false;
 
@@ -3965,10 +3983,11 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
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
@@ -4195,9 +4214,11 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
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
@@ -5170,6 +5191,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* Attempt the batch allocation */
 	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
 	while (nr_populated < nr_pages) {
+		bool zeroed = false;
 
 		/* Skip existing pages */
 		if (page_array[nr_populated]) {
@@ -5178,7 +5200,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 
 		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
-								pcp, pcp_list);
+					 pcp, pcp_list, &zeroed);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
 			if (!nr_account) {
@@ -5189,7 +5211,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		}
 		nr_account++;
 
-		prep_new_page(page, 0, gfp, 0, USER_ADDR_NONE);
+		prep_new_page(page, 0, gfp, 0, zeroed, USER_ADDR_NONE);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
@@ -6929,7 +6951,8 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
 		list_for_each_entry_safe(page, next, &list[order], lru) {
 			int i;
 
-			post_alloc_hook(page, order, gfp_mask, USER_ADDR_NONE);
+			__ClearPageZeroed(page);
+			post_alloc_hook(page, order, gfp_mask, false, USER_ADDR_NONE);
 			if (!order)
 				continue;
 
@@ -7134,8 +7157,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
 		struct page *head = pfn_to_page(start);
 
+		__ClearPageZeroed(head);
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
+		prep_new_page(head, order, gfp_mask, 0, false, USER_ADDR_NONE);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
diff --git a/mm/page_reporting.c b/mm/page_reporting.c
index 006f7cdddc18..37e4fce9eb38 100644
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
@@ -391,6 +396,10 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
 	/* Assign device to allow notifications */
 	rcu_assign_pointer(pr_dev_info, prdev);
 
+	/* enable zeroed page optimization if host zeroes reported pages */
+	if (prdev->host_zeroes_pages)
+		static_branch_enable(&page_reporting_host_zeroes);
+
 	/* enable page reporting notification */
 	if (!static_key_enabled(&page_reporting_enabled)) {
 		static_branch_enable(&page_reporting_enabled);
@@ -415,6 +424,9 @@ void page_reporting_unregister(struct page_reporting_dev_info *prdev)
 
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


