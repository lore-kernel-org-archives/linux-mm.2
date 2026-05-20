Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC482CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 22:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6036C6B00C2; Wed, 20 May 2026 18:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA8C6B00C4; Wed, 20 May 2026 18:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFE96B00C5; Wed, 20 May 2026 18:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7E76B00C2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:22:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C5B41C1095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:50 +0000 (UTC)
X-FDA: 84789224100.18.31E6A91
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf31.hostedemail.com (Postfix) with ESMTP id CFAB220006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:22:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PorHVU12;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779315767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdOI4mS59hNGv2oV9kd67xyAhp7b5Wts0l8Olu5Azv0=;
	b=niXF4bt8+lSIDe4njRqIraGUY1kECe6E78cNqeiUG+z1VlrgLuuwNWv1OrK5OxZvHcyLS/
	hMW9HnxmLbu4eQ9ux30r1blP7Ycf13dgfmhBIj9FRX8m6ApxkwqgxNvkTF9VZDyEsxCiRv
	Okyy8aYxeP9a4XraWtztEtHvT/R+MZc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PorHVU12;
	spf=pass (imf31.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779315767; a=rsa-sha256;
	cv=none;
	b=p6IcecYuVokn6bWHMMNNygHyzay1zJqHlFuctcDxfEOoxhVXijcUCCtXzMrQReZfD5b13l
	n/jyYc5C+oAfiw8a4JlkDDAqdJkE3pQhZ+WU0O5zf8jtuO/B8zwRdTkEnpgOlCV1s9Cpoz
	LSF8oOo5mUp8GEWqb09Hlji/XoSDIqc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779315767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qdOI4mS59hNGv2oV9kd67xyAhp7b5Wts0l8Olu5Azv0=;
	b=PorHVU12jvNsgP/C1Cpl5kIuXij8TFOXDOZBZ5dSSUHBxci9+RI3utlMQp0p6+DlJ4DEel
	fEIMquHrwPbbAGR06zVAnArIgz+GDvJlyW2Mi9fnYT/o0rw/4eBQf75tF12KQoQ4FMe8Ma
	nqtkef6dlt1POtflfHSrWAZo50IUT2c=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-194-biH_MOUnMZeSbYCP0CdzSA-1; Wed, 20 May 2026 18:22:44 -0400
X-MC-Unique: biH_MOUnMZeSbYCP0CdzSA-1
X-Mimecast-MFC-AGG-ID: biH_MOUnMZeSbYCP0CdzSA_1779315763
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-45dbbbf8d57so7163689f8f.3
        for <linux-mm@kvack.org>; Wed, 20 May 2026 15:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779315763; x=1779920563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qdOI4mS59hNGv2oV9kd67xyAhp7b5Wts0l8Olu5Azv0=;
        b=gon1JJdL/atr2ex7AkOddIA+AuwQ0llCoj0pakL8nvpMcOhEUcDyxA57ak3Rg1enC0
         B0CCdgySK6ZPFhf0wAZpr5ZEDUoG0P/y6jSNDmPYLRJwVwpGQsUvdXd3njUFk8ncHKnU
         SfPLOMbKhzjxjJe13YqaBkW0F7eRhGIUYLDLykDZaB8BH+W0XK2FFyuGo4o6lXVCesj+
         QZC5DatDTzxugjROMFIpj6985tzinx81USiwWeojuHnN+BHzLBtuh0NQKGRWfbLWFXS5
         tqZs04344Ta28/iarxPfooUnrprdz9+3/prywwALgn/8FG57/yhY8heLA6/dWX87mokg
         mDsQ==
X-Forwarded-Encrypted: i=1; AFNElJ8yiXfkB9Veb6xYYecm9UjoZhgQagRxrNdIlSzjpLjbXo5JTO/18avWD+ieILSp3neBmpYn3CToHQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5EDlGtdX0eDJCJBOQoyFzzX+HGqRUs1PblGG6Ycchei6p4OlN
	VDCwcCPTJh7nUMZEWQrHb/QtF6WuhjJK3N0wUofmh66ZIoEI43N2jXjwTPReCrD9z3sYVhvuGkg
	Sq5aR+P+3NNl9Le3ux3WEdD7NQfxjxAlL4fFnnD+QMeGJ9uDRCffM
X-Gm-Gg: Acq92OEQ/oyOJ9UTXTf0JWdT1/cRwZQAe1+Vp+eIamc0a/PIXcgeAvoep9K+kH0l+EH
	z4t/omQgq1niDeqcp1cfGk5v2UfNgo/Xn9B3lO+El5qXmkHounVLahZdOEYugwcQuqQwHQvqeUA
	ZxuwDQMznpMtiM5g/Tony0nJPjdhRmXjTbyyhuNKkh07KmMIPGsDwRsJ/9C2cBxihzEiSFdkDb/
	PoyVv3R2YlcfEUtiTLWpFeq9udbFQCvz7faaW7oobkrr2bO9KcZq3iEZ2ZqQThh9+nYhuR9EM8g
	il9tNWtQRBybBGze1NZ556enr4SHf2H5NH/3dQ2Za21+9aNckq6q+zNPh3G1zosVhWPOhinTxu3
	U11udyQgqebVJ3K8Wqt4pLzlEOVUDkjX017ohlQkt5XNKtpps6c3EOA==
X-Received: by 2002:a5d:5e92:0:b0:456:15fa:9eba with SMTP id ffacd0b85a97d-45ea3df6cebmr217154f8f.43.1779315762671;
        Wed, 20 May 2026 15:22:42 -0700 (PDT)
X-Received: by 2002:a5d:5e92:0:b0:456:15fa:9eba with SMTP id ffacd0b85a97d-45ea3df6cebmr217100f8f.43.1779315762157;
        Wed, 20 May 2026 15:22:42 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9adc2209sm54072453f8f.0.2026.05.20.15.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 15:22:41 -0700 (PDT)
Date: Wed, 20 May 2026 18:22:36 -0400
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
Subject: [PATCH v8 25/37] mm: page_alloc: clear PG_zeroed on buddy merge if
 not both zero
Message-ID: <68d88e8d227865ec4f8513d47bdbe06d0482851a.1779315441.git.mst@redhat.com>
References: <cover.1779315441.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1779315441.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b-0XXUkFyaaH5vhvTRKupVJtOiKqHFc1LUqBQACGS10_1779315763
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFAB220006
X-Rspam-User: 
X-Stat-Signature: e199jurgp1rhr9oxtwx149ze3us1fwwn
X-HE-Tag: 1779315767-139108
X-HE-Meta: U2FsdGVkX19cuNYjMS0eNPwNfGBVuufMX31NginNhVWPY3yv6aII14BiXnmM6JW8oeZQ/RD7SrXpAa+T2mMOeWQX77xnO0yfy8lKd6P+mKLC6B1JKd7oYvoBTb+wghFz5rdV/HOWqOmPy2bhqgnOu0KfTUeXte2H1IdP93Ud2HUswwK257wvUJ9f5ZCpIu2RnDCoNJogynAhf/rpIOATxSxtJ1W6YefTxrPMppg9BgzKvjGExUpFWNfKeebpj4FxnRHAbbMoMljO0mQkR2UrIx+RgQGL/auP2glnk9cXTlOXVWH7CSf+O5HIZoE+Eo+eHnSjfYMUiZeEELRgMfDSaRTUxAVRMaKxQlv/v68xQXx5ucWuvmzP0+9unfqb2EN00dQeJmNkeys8sdPVl/Jue9O4g+Ix2rILsWOs+gdv2KpNsr7zcAUIm3oAF/L/LLuxc63GG899ABWu2nud62gKRtfCZVlcKvD0zONSqktKEbhXrOAIQz847/KJtYj7lpb+0QO4RbPuIRaHkWa652t356Bqig4ftQlAbWXxxqf+wuI2xMh6DsnXvpB0VRGgbJsiuG6aEU1K9bnFaAA2AYBeFagYsiYP0uuxbqffTg/W4lmsDdbjtOmlH2ce6Dw4kfOsR32hUxc73JAL5zKK17K6lJ9DtDOYCxRBC5lKX+UMsqy3KF8s6Pj/eDDU37NFbKGCSNoSyJbGmwact+/QMLWwABGS5/b9IutD0hSu9uUiylW3opLTM5UO7w+qQ+GIcrfbI+GFAvN6gG7nY+5qBqakJ02UWFhn57cCs/Ynh2f9u+oim383bGM4rdBFGRF1S6F7RgTQqX98ozMAq7cvfO0WKvk3hagLY2g08lRMhw5njTfBYQBo63UtK5zSSzcIeFTjfxAKf4fZaohj0S5pZZWV+7/yg240ki+GAZ3HN/Rfz9vpxcx09vC0dPdGOY4sZ6Q4eox5mD+YFnHnT3ZzJr9
 NTVNFP1x
 47kEKRG4mzWcUjfe13EZ6tjBgA0yUTaHhOgXQUolskL4dF+MASK21tokvfdF8zzINWGtqvt9pHG2etwbHrYKs/WicU9SM10NzhBrBjP5xQ2tLsO6ISKKdFd9a791hZ3890zn+W/RpRFiXli+mhiqTCyAZaUmVauxfELo63ZI1SEVqyWmD8vaSY4DKoworsn2upPbmr/cs/LlfwU/g+eNBB0Ag2/2Tm90yQ04keG9yN9l2Orw2jKrghv+iEVtRli4fK6n2Tecu/AS7cn79lsrprd0F/+E0qACVIqrTIySErpDGh0wijuylYx4AHGfPJP4FtrRL8M7rH1+JXPOwfDP0IHxSexR5uwb+SML3OKIilcJMvlsUNBVvriKFNz7l+hoPNCuV2mtcmA3cm1r9V8sVIRLDByUHNLIEkxm9nFJ+HsvzGPFzv6yk6z+TyOOjxseJKWgXnIQVa4IAbw9nts+fuk9ZCg==
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
Reviewed-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 include/linux/page-flags.h |  1 +
 mm/page_alloc.c            | 15 ++++++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 4ee64134acc3..ff0b192b38e5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -680,6 +680,7 @@ FOLIO_FLAG_FALSE(idle)
  * uses this to skip redundant zeroing in post_alloc_hook().
  */
 __PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
+CLEARPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
 #define __PG_ZEROED (1UL << PG_zeroed)
 
 /*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4cb7e779a6c5..ff614e422eec 100644
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


