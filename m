Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F578CD4F39
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9E406B0093; Tue, 12 May 2026 17:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B763F6B0095; Tue, 12 May 2026 17:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9798E6B0096; Tue, 12 May 2026 17:05:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 76C946B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:05:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D4E9160501
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:34 +0000 (UTC)
X-FDA: 84759998988.26.C9F214B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04F92180009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IaQOp+B7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rtq/ad55zrZyrod+V9Nt+5t6fAHZwxPdckwVickks5c=;
	b=o0/nygJAgRCaN1qNivMio3TQB/xJrO6wWveeVYrJQjAkKn3a9+c/auscb0Uv7Zg3w+4/NK
	u1mrZCVLbYUUrzm6llw6LbxiDc8wrYKSwMFs8251hkqX+ZJ93JPovw/ELpH8/0UASTTrNH
	ydTi13rOkVEDJwP6+Wzu47jaQtngaGk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619932; a=rsa-sha256;
	cv=none;
	b=F64prsGydKIL4ahE97FqbKl9a+pDIBhd0jxhYqBP6n1muUfv8PMxqV12V3G4/wWswcHjgo
	rkSYIpcE4OFb/QQCzpZ7wihZVRALDnrbjC0t8pM1237Dl5jCKdAfEBInVCIeYBcOBS2Kts
	0QuQFSOB0tP9FH6XWtg7bRaju9qXSyg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IaQOp+B7;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rtq/ad55zrZyrod+V9Nt+5t6fAHZwxPdckwVickks5c=;
	b=IaQOp+B7ic3BOaT029m1PZVoBHWVjRk4f0Eu46NrsQTlZh3KKV+Q+qrzQdDuojJuGWxrB2
	usYGpSyH0IOuUrvAzZgFZuSdiv/VWHgo27Z2xIITlz+Xagw1FCc8ToVPuXlBXFoK5TypzH
	3I4+IZIdINm/qTfjf0DDEf66zvUatis=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-pNn9yM8YMSmKd-XMlAIDyw-1; Tue, 12 May 2026 17:05:24 -0400
X-MC-Unique: pNn9yM8YMSmKd-XMlAIDyw-1
X-Mimecast-MFC-AGG-ID: pNn9yM8YMSmKd-XMlAIDyw_1778619922
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48e7572b739so19890115e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619921; x=1779224721;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rtq/ad55zrZyrod+V9Nt+5t6fAHZwxPdckwVickks5c=;
        b=mAwInUJcMC1c2W9al371Ry0uj+ShGX4f8kWvnaAjOGJeeJ/PZWdlYamoxmrF13Ru1Z
         WAnuaVWi3QijsUjAFgwDsiPe7+jAH5UVfJzkDJ6QQ5fyeYpbyUq2d+MDOvO5dn5lTc43
         Gl1HtNs+wFIPsZxgCvY6OaRRgIGFYujOGl0MIJ4aL6fUuftLgrJxSzz+6G1DAt/PKYg+
         7GrXn45mRgSOQcVskU0oewoW1G39cCUrooKALO7DRBYkM3LKrJ96HX42MSN3jB0Mjh+6
         P59osECoqTbwvDBDhvlL0mixAt2lv3WckWEH89UoN1ETIZsHR4jlqiBhlloTCCKDbOEl
         oUoQ==
X-Forwarded-Encrypted: i=1; AFNElJ/pjAYafH1uHJW6Um/ty3RKpfuWix4FBP0xgUUcP+4RVl3ClP7diUFuvjZbECPUlVu+ygYzhV4ccQ==@kvack.org
X-Gm-Message-State: AOJu0YxXDwMtwCPdt0sTPbyzNcZTT4AaMrtAfJvDzc18ePLSI2EJuJPH
	hzw+m+svTyWYLkzufKs4GmFWtTry4+wwWEGB24mbFbDY0Ac0pID5oiIW/Sr7+46Rjg4BXZnVnve
	bUn9oAG34UkdBVaCvL9GtXa0ghwLq3x2F+h+Lbed2HvxJJe4ln2Mt
X-Gm-Gg: Acq92OECcB3x3faAw4h2sVqq2r77M0QYqlp+vew2yymK+oHvRg3RqC2p7Ezs+wi6toA
	r6sfi/lNrNbowj1xLl5bK7SWsAu9VnUZbnSP3xfpGd3ZQpipniB82R1Joq94gnPM9CnknaH5E2y
	sGIbp9/C+V0R9OucUsxgkHAb6UG0qCRnmY4a0ftFXSExDwuKbBP0Kt4io0Dd2V47sVW+s+1QakZ
	/E0Ojn7pslSYxFmvouRMTS4R4NXCzYECcHBwYQpEI/Kq5dz1pac2jtjjNc2gExvLw6ZMzcMgfM1
	+dE41OAwmhGYn8pmX4AlpDMlnO7XBTyg4kXXW9RTnKvfOz8Mvf3HAcsE1b/49gFGAOm5oYpn4xN
	VZxfHUvgZ2u3yGThwLrkw62CZ8WFNWtdfatNhaf+F
X-Received: by 2002:a05:600c:848c:b0:489:e696:8362 with SMTP id 5b1f17b1804b1-48fc9a30a6amr5860715e9.13.1778619921389;
        Tue, 12 May 2026 14:05:21 -0700 (PDT)
X-Received: by 2002:a05:600c:848c:b0:489:e696:8362 with SMTP id 5b1f17b1804b1-48fc9a30a6amr5860115e9.13.1778619920806;
        Tue, 12 May 2026 14:05:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8d27667sm18044215e9.7.2026.05.12.14.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:20 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:16 -0400
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
Subject: [PATCH v7 02/31] mm: page_alloc: propagate PageReported flag across
 buddy splits
Message-ID: <feab82b370b3e66b58b9cfbc1efaf26fe6061d2f.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9hHkl4sCeI01Mr7yLP9zWNS6zK4TlHAMzKJCrqmaxnU_1778619922
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04F92180009
X-Stat-Signature: 59d7t4j54ygf67eu56iu1ggy7rgnnjqg
X-Rspam-User: 
X-HE-Tag: 1778619931-612094
X-HE-Meta: U2FsdGVkX1+Yj6V9UxhJ4AOOqHPNcJp3wzU4fOtiewXr0BncnE0LmEIZC6Vb0dJNw2+khpbkgBE1Q390yOl+Se78zjr1FgmEPr9JmrJctm8yHs6W+ty8P0bDU9MijzzT+8B4vEiJa6B65eGcM7YnsquMfyeABxkWrrujPvIXzKrbNfJDP1KLA5cdknuK4RJNSB5aVIESmaEBp6UADKZlj8YcdGFzUTLv7k9s96jkoS/8zmDimPIRYqM99q0/ESLLOOVc6NeowBRTOW+DUc9Lx9wYgd5qGI94FvRypVZK3ah8Q+HtpDNykIeP4Gr0Dp1zkIKap05X4/lnVNzr64FQXpYVU5XpXmbXTlkqQvm6EFUb5kEFe/6fz2UFGYL9jEXUbJbDhwdFyUxjJqmjOi6QrvXcB2KERH5nHK6I1QMDuBHeQoef8i1mjTtuvGoRRoYVMiDsxQlOQWhG7GH8r1PG4GI/eZd1JFAKyRvXvo90zjW4E1v3va9L5LJoGaIG0AisYYuTvwppbwWlteyzoUvDDaeN1aYEvxhR58s9BBkOk8n4fXaUdDZNlEi9CLzYMmyHZN9jMPG+I+C2fBWRS45kYDYRQFHpXnJSDkX/KqRcV2mcG8MGnS9ex8S0Yyyadgl7fp1ahyZzzYBXJOLtuIMil6mpHAl57hcditQWDj9jA8tuk5/aoMXH52X0AZYkEIrWIL/7boMBaoEu8ayrv+qWYvFdFejdcOKWElPngWJWjL+hP7kNJFqkxIC/j4+DC8TpOBP7rYPWLD+5ulK4Naan8QaOen38ZspEedHXPXuipSw31ow4ZBTXbBGYMSU19wvpqao9JprWw9sgVDhM6WuHXwTOc7vLMZcv/MzaF7R0Xha43DjR/tSZcx6OojCmBxZPralhjIjhTw61ODjQtRpJLknIdAv8lD+0WshFrJeQNaZ5gvWr9nr4KxMj3gF8aa8Cq6QzBVsjM6A37kkkA8A
 BGc9OTpm
 Hl+uYNaa9M+xOq8sr9I0jW3AJOVmibjeo7lCT31urhyDHpdc2ZnJoKvZ8vWLyPaUecHyuFiOEA0EP3/oRzVxr7u1gyvTIdzCCqCNbvoUF8xc38PO3BQydcsJ3eIOqatDp03hc69zkJ95LGIgQyxzaz1O7EGCfaF/yPV4hVIrleD6dBGYT5MYYE8hsXsXm3A7ziY3Gfq3p9dEm7Qi/28OijJAkv2mPCF+c03mwQebGrrNrQIKgnKsjDDdcGw+K7R0HUdMPWLgZcFYX5KfLJoM3H8oT3ZlEYL/t3+B0tr85lm45PuGC91czbT9ApZf/8We+F2ItLKxV85sxCSrOD0SmREDyV6hJh/qSmfeveA+b+2mDv0xwA/gV/UeNDOU9Snd/j++meyrxqDoD+fcjtDwIKOYiOscqg1eOExqFyYHonIBA3aDPrbHO43gKXfhPcBPhgeSaguRCNY484i4C5/GZOzycTIC8Yt5/A0cS7j+FhI8faXs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a reported free page is split via expand() to satisfy a
smaller allocation, the sub-pages placed back on the free lists
lose the PageReported flag.  This means they will be unnecessarily
re-reported to the hypervisor in the next reporting cycle, wasting
work.

While I was unable to quantify the performance difference, it is
an obvious waste, even if small.

Propagate the PageReported flag to sub-pages during expand(),
both in page_del_and_expand() and try_to_claim_block(), so
that they are recognized as already-reported.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/page_alloc.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..e40fd39acbd0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1699,7 +1699,7 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype)
+				  int high, int migratetype, bool reported)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1721,6 +1721,15 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		__add_to_free_list(&page[size], zone, high, migratetype, false);
 		set_buddy_order(&page[size], high);
 		nr_added += size;
+
+		/*
+		 * The parent page has been reported to the host.  The
+		 * sub-pages are part of the same reported block, so mark
+		 * them reported too.  This avoids re-reporting pages that
+		 * the host already knows about.
+		 */
+		if (reported)
+			__SetPageReported(&page[size]);
 	}
 
 	return nr_added;
@@ -1731,9 +1740,10 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 						int high, int migratetype)
 {
 	int nr_pages = 1 << high;
+	bool was_reported = page_reported(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
-	nr_pages -= expand(zone, page, low, high, migratetype);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2288,10 +2298,12 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		bool was_reported = page_reported(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
-		nr_added = expand(zone, page, order, current_order, start_type);
+		nr_added = expand(zone, page, order, current_order, start_type,
+				  was_reported);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


