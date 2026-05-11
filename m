Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D4FCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7BA6B00F6; Mon, 11 May 2026 05:03:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAF766B00F8; Mon, 11 May 2026 05:03:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5B76B00F9; Mon, 11 May 2026 05:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8847E6B00F6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5042EC232E
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:47 +0000 (UTC)
X-FDA: 84754551294.28.FC31328
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 257B5120004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GxDGQ+FT;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIsDJpt3h7ld/REGYicPHvXqVXWObeKhcjO9DGpcUJs=;
	b=jozWrENvDwiyB3BBomuRZY/U+WMtm8ION3OtAC4CnibZ/UJ6HmrZ91ZxVMFsd+hFehio11
	d7YX7phHsqCx4F5IP3QMnhtQZ8hhLB+3EjTtNDLfPtp6LDtbkSUY2EG61kaw55nC9gIw5j
	ZYOEvv6Fr5cvKJ6j1Yq1EAlxorWkDnE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GxDGQ+FT;
	spf=pass (imf29.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490225; a=rsa-sha256;
	cv=none;
	b=Dt1mel780T4A5gky1mWORoHI7iK94SAC9Nd6AeNInaxjBwQ9NQPOE3r1I3p78vhG+Qhf4z
	yXCzOsSfNm6X26qyVyyYTq2YsuFnS4L5cftKCrDH3wBfWOw7RofOIst6cqicoBl8OUqPZn
	l3RO1VmosBlO5XsKYfUk2w27WvQ1aww=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aIsDJpt3h7ld/REGYicPHvXqVXWObeKhcjO9DGpcUJs=;
	b=GxDGQ+FTe5NYbeAY5QkYZtSUvovBiL7PgybFZqU043etoq2P/LzeQxsFQMxNzcQidEwuKJ
	nu6F2xVNN/enJC3RzJqopnwqa6Os9MB1YO5xCnAnfwvj2Y/p4f5ZXS6Pwcz5Cx7+34uPUs
	dmP/yfDD4s+clBnOyj5HkS1hUrJCdpg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-370-9gJYOS7AP6KPMIjao-lh3g-1; Mon, 11 May 2026 05:03:43 -0400
X-MC-Unique: 9gJYOS7AP6KPMIjao-lh3g-1
X-Mimecast-MFC-AGG-ID: 9gJYOS7AP6KPMIjao-lh3g_1778490222
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d1b294dfeso38016235e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490222; x=1779095022;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aIsDJpt3h7ld/REGYicPHvXqVXWObeKhcjO9DGpcUJs=;
        b=T4QKaX24zH7pFtqjUIdC1QZKsCY/qtmEMUED0eXMJCx/6XUwQyFj3MKOtQ3bJj9Zw9
         xgsmLhbLWYL6R050mltVjGJLyDP0L9xPI5/yS56JLZFcI5FsxqWhaPX+trx4CUTKIa1M
         saKfcsSWRVh4ug8rvpCgp0kbJJgaBGSNjaOYp1glOrIRFtAauDuq8YlgFW9SNYg4qy8H
         3cZQb0phVDQO231kZfdU6TZRTjfGIIkQp7qBWeqdh/YJQh49RWvzKGi8zcC0z7fX+VDb
         SNr1wopk/ch7GCD9thJGStXJnRk8PPQMFFGnaH2Sp9HGaozpOZlKOi6crlaHtVwqhmmj
         8voQ==
X-Forwarded-Encrypted: i=1; AFNElJ/TtfPmYb+aALY+rqLyHDOYBFvlHUOOq0RUCNhT5ZQG9GTa9fKbol61ZBN4AqvjP/DrCecgT/mwRA==@kvack.org
X-Gm-Message-State: AOJu0Yz/BxdfyyjdgfZMLVKD1wfodaNJMrMN5Thd16EHHHc7u9Ic3j7y
	jRlCBb7x7uYGN7kDi4y2kqa8XD7xcbc+DU1GLl9P26bH1ucYiQy6gUXw2bzA71Y90j1+ubL6cfQ
	mbZzsRT/fO3rG2ANwfFjSd6POkQqN4H8/HMsXOFIuKfDprNUMEugO
X-Gm-Gg: Acq92OHSDwE+ZpOitczyxJ9iR4qbA6dIV0o+Fy0IujwSIxjon3GUk841eUscUZ5Aw1J
	Vm+d0ebVJX1JO+q/xk7YNx0HuzlXJRwmJI0k1NkbBBsoIMrFmnDZjIy+sbkwRGGvLAk+Bge/QP3
	G3vmYk/SW+ruKrbEQN7bWPBBT19pM9OZy85msWf5ZoaXLfKDzH/N0hv0XPslX12f2daB9q5Kyx7
	XuXxh0Mj1mLCHPt0cfac4kHv/8xK75rOJbbQ4VacDqYlbP9V/eTwncJTTjsEJ+FV1ALpiA77mbp
	+z48nGbiiOA2WXMffZb9I23qN2pZ0FQqDWMRzOgN8H9Ikx60CrJVWffPsr5aKzVheq/CWsT+1nk
	78Dt4SgMdZhICXHDoZAVjaV4F2cAZlu61OdcBtCXR
X-Received: by 2002:a05:600c:6299:b0:489:1c32:210d with SMTP id 5b1f17b1804b1-48e706f120fmr146717605e9.15.1778490221554;
        Mon, 11 May 2026 02:03:41 -0700 (PDT)
X-Received: by 2002:a05:600c:6299:b0:489:1c32:210d with SMTP id 5b1f17b1804b1-48e706f120fmr146716725e9.15.1778490220928;
        Mon, 11 May 2026 02:03:40 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e6fffb9bdsm160295555e9.1.2026.05.11.02.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:40 -0700 (PDT)
Date: Mon, 11 May 2026 05:03:35 -0400
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
Subject: [PATCH resend v6 20/30] mm: page_alloc: clear PG_zeroed on buddy
 merge if not both zero
Message-ID: <a09c1848702368c3545b980c17101b5185ab774d.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rbfnWTU4gWAbEh6by55dQJj7pALjfxRcXpDhXOPkB3E_1778490222
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: wzkc85cdbgf7kez997sid53htibnhwwa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 257B5120004
X-Rspam-User: 
X-HE-Tag: 1778490224-848674
X-HE-Meta: U2FsdGVkX19r29JzhB7mBHjilXuh8Htdkhz8j8aeBnaxwDHsQm6zQ/Isj+jX9AIbmfeqGtGCtYZIhWSGpn6Q75cWEdUc/aUgMqmefJBFE6+wkXqqh5XcqFCa67qrUon0YcfcrPGL9RYnZ/ViLdf7BQuTLrLJEdnotL9n5TyrC35Px38P5XhN2yetNcRh2FrOhEu2+RcMLgyOSPXdoc6ZhT3jP1Wcq/KRXMkemUvD31m14ErBe4ORdzQ5w83EeQylToc8YUgg8Rhw+ugT6lnANB3ryNqZkNDCByuTRmjl9RSw/PrEgCtE3bcBclsX4fw8sOYYQxtsAnVv9P8en8MI+JEkwVLVNMChVGUFCKtptIXEuTQzDmwNzCZOa4dIfHBEJFO/BcKMTN+Yig0mviQfzzkTJG7bAl/E7/WDqCXVARCXYDO8MJHGa66+htJD0V1ECItrbz3JtcLpBpkn8PmE3JdTWj+hP9Eh532fECGluvv8T/Itvwmb7tJ/nn/+GvNQDM9GVP8zdOP8uu7LZPprG74BooNtPWmCHDIIU68yKdWpMSGd551pVIAYUs6+6bkalRaW9s4hg97pmEpj11J6T/ZrYj5oIIW2+Dyl0L8mWXUnUCcBB8lyF83FubJ8PJghpkE2MmW3lWkPDna9RGGkSxXFvHm8w32WNEu6eCLun7pQm2JYTQxn0IqYxt7NcugOYb3Lf0UrG6pWp/NuAWBBtp+x7Yfs03dvi6LEQyos2CGsNaSX+yy24vhCkXRjChU/ll93pGFISGEtROtsfBSeBqnCJ5x9BUoN/JjLQsAgEiLyEjytbkJLUbJipSXrdQvLpW9/PFWrDn83qKjL66oaOWYugJHMy3BHR4z2UQ+8nYIUR1lAZV0REjf42lLWK5k16WxGhmwPqo06wawz3jkRFTebomrVy65DsBiP4m0/gaBphfq6oF3pfQK6Ot6SIFpnas8g168OOf3PRSQPx/G
 Jth7Bz7Y
 OAeh1aUWJdN414xemo9XjjNQfgP+yQN2eUc4uzDpUlclMyx54YzuYW7g2yKN/KS2l5yCwWsdx515rcRg56GkK+9UtkHFGDc+65Ya1ywLJ4LBeWg78tnHvZJVqhM6njz1SP2CxqEiiYJ5Lkymc4dFoYdkzbrCgZnh9JVwWdurRetLj+iz8XXVaAU6466Hbvkt4fc5NRMBrNwSQ22l2MUv/5urwBieMAeqOE+jXn/G1cDbKwLpKHjvpQmxKWb5kqe/kU5oR++QeJd6gZYZOWpw1C+C+6L6zOfi6WnewWRy9igb7meSuxxRU1IdoRITKQ32BzXNnER9vdzcS2DuylvFBnMhQlMlR+NS+VdaG//qjLJfURNCqZNXd0fYDDw6husxUhIJnxxe14wtLOG9yCZ3wVFtxfE7xey7GakAooq8SPz8L8eCn0N+vlVgbBNtCyRcGjXz1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When two buddy pages merge in __free_one_page(), preserve
PG_zeroed on the merged page only if both buddies have the
flag set.  Otherwise clear it.

The merged page would inherit PG_zeroed, and a later __GFP_ZERO
allocation would skip zeroing stale data in the non-zero half.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bd3b909cacdf..d70c9ba6b329 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -940,10 +940,14 @@ static inline void __free_one_page(struct page *page,
 	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
+	bool buddy_zeroed;
+	bool page_zeroed;
 	bool to_tail;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
-	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
+	/* PG_zeroed (aliased to PG_private) is valid on free-list pages */
+	VM_BUG_ON_PAGE(page->flags.f &
+		       (PAGE_FLAGS_CHECK_AT_PREP & ~__PG_ZEROED), page);
 
 	VM_BUG_ON(migratetype == -1);
 	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
@@ -978,6 +982,8 @@ static inline void __free_one_page(struct page *page,
 				goto done_merging;
 		}
 
+		buddy_zeroed = PageZeroed(buddy);
+
 		/*
 		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
 		 * merge with it and move up one order.
@@ -996,10 +1002,17 @@ static inline void __free_one_page(struct page *page,
 			change_pageblock_range(buddy, order, migratetype);
 		}
 
+		page_zeroed = PageZeroed(page);
+		__ClearPageZeroed(page);
+		__ClearPageZeroed(buddy);
+
 		combined_pfn = buddy_pfn & pfn;
 		page = page + (combined_pfn - pfn);
 		pfn = combined_pfn;
 		order++;
+
+		if (page_zeroed && buddy_zeroed)
+			__SetPageZeroed(page);
 	}
 
 done_merging:
-- 
MST


