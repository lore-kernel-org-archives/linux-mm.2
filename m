Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B40CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AF9A6B009F; Tue, 12 May 2026 17:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386EC6B00A0; Tue, 12 May 2026 17:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CE16B00A1; Tue, 12 May 2026 17:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19A0C6B009F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:06:02 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CF7D11405ED
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:06:01 +0000 (UTC)
X-FDA: 84760000122.25.D7BD633
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 626721C000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:05:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZytWOlqG;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778619959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ScNqY6XGVTvavY3RuaxUGlH8VyMDuF0XI3V7nGekON0=;
	b=d3PIKfHscHoCAN+dKtysL7JHsu3ftyqohm2C1uSlECs1vYnwVs5AzpTnXYwrRO1H6SOed3
	fNyReH23w9UllFsosYerqMeA3IOY3e6Y2zXAXmcoAOhLqf0cuMIQ80S8yN13q++1Hyyfk1
	86/tdfsmyDFOEDVD8ECVw2wsiv/GRag=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ZytWOlqG;
	spf=pass (imf18.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778619959; a=rsa-sha256;
	cv=none;
	b=zjZ6z5piBax3tinThJ/lxRCdL9WJGtY8gxapOl/Dp0Fjgg1E/lvAs8kB/7sb4av/nXXhIE
	gXCzo4qk1GkXb43bLOycakhDHIcEstT+84HbdJ2UCLJavRb8xpsJcf1LvXz8fA10T57oP+
	vxLP7oxj3/9PpwnW6/0RpjKFAm8Cyyg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778619958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ScNqY6XGVTvavY3RuaxUGlH8VyMDuF0XI3V7nGekON0=;
	b=ZytWOlqGKr32XZxt/C536YECvi7nzMIFcBu3P49vPLA0RwpDfUt9ZcjChirxWrrJpOxhvb
	if4MW2asYrOTIOs7pyc78mMXWBx+ayGKOdYo8+F2d1joi3JDOFy+eNJi6CyvP8cekIsnSI
	aBweNTnSaZYsljh2W8TYffznd+iUU1A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-0L-ifTgvPvOx_pIIihMEzg-1; Tue, 12 May 2026 17:05:56 -0400
X-MC-Unique: 0L-ifTgvPvOx_pIIihMEzg-1
X-Mimecast-MFC-AGG-ID: 0L-ifTgvPvOx_pIIihMEzg_1778619955
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-48d0677b5f7so34060695e9.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 14:05:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778619955; x=1779224755;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScNqY6XGVTvavY3RuaxUGlH8VyMDuF0XI3V7nGekON0=;
        b=VuDhiM35OKORcG3Z3rsxWzZPNwImhA3yXMq8kaj4Qi3+47Zro9UvaPHwhaCl9tekmC
         EFNmvWbv4akWy/xnEDHqJK61RaaK9kpYc/LQxWq52cpyFj2ttU2QfLpcyt1emHB6dNO1
         KxnjOKQqaaqKAtEaK3YDVA0KClULSf+k/Hu5vIvKX0xNoXBJJd/0IGG1JgU6N2a4aAbC
         Lz7nWhvMj5r1aOKKnzR1hX64ZLtoCbUHVoBfbLK9HwskOizsK69SE1CbCoZets+FpTli
         llH5Y0YjCp95MHpEpqND2gQHmy6IxVbUS19fPHEhtddYTI5nvfW+Jt4tmOq2a8M01p8M
         UEQA==
X-Forwarded-Encrypted: i=1; AFNElJ/6u6QxZyAf9uilVIaIacZ8lOTIbcD5SJ1fHrR61bAANDgw46wfU4AgIW0r9W3MEEnOVhqWzJcgWw==@kvack.org
X-Gm-Message-State: AOJu0YzRSU6MCFnCvRkFo2Y+e8rWzUADAWFseZMSzf71IhIZwto2KHVP
	YFE8Qgp4uOgIkpPwjFvy9a3Mi3zcNE8RbRkzqi0lD0RXt6DpL8NbE7p887n6gizoPGS1jdUMdHk
	OBymd91L+OohQ9ZYhm3OY8T74lrKhY1MMdAFXv5ga8AcCuAB03uLe
X-Gm-Gg: Acq92OEJIwFuiOQfLDwDMT/icNyrnrISTigi0pravUNQ2aUlrq5QfMFugFftDyTbg8U
	rx899XLrDVPWKFmCG0t/Pu/U0MPXSnMf8uA6PXtCoiJXkPiG+8Yc3UQZXieeT35CuPY5gOSlsWR
	yz6nAUotACckkJdjwgiyu1G/1+PfPwil1sUCIZZcqsSXSvWyso0F5g579J5+HmTP1co9+ukpK4+
	wrDxHf5T5yiJpv1lnsFIh9goGdJxwBMBem/DW1Q/PCsDPEG8PLZOxUbBqxpDLzmmtHxT9RH8WOB
	UJGrNfOGN5a209dXiqVJxKy+VV03YueRlSGcrUpc51bT44UJmSXpCcR+XO8shboFzi+WONmRICs
	ttU0RG1F3vBQqcQIAFju/fyyn+TChMFcjTyBy8wxB
X-Received: by 2002:a05:600c:8b56:b0:48a:599a:3716 with SMTP id 5b1f17b1804b1-48fc9a45891mr5019755e9.23.1778619954869;
        Tue, 12 May 2026 14:05:54 -0700 (PDT)
X-Received: by 2002:a05:600c:8b56:b0:48a:599a:3716 with SMTP id 5b1f17b1804b1-48fc9a45891mr5019335e9.23.1778619954287;
        Tue, 12 May 2026 14:05:54 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e8f429fdfsm24854985e9.15.2026.05.12.14.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 14:05:53 -0700 (PDT)
Date: Tue, 12 May 2026 17:05:49 -0400
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
Subject: [PATCH v7 08/31] mm: page_alloc: move prep_compound_page before
 post_alloc_hook
Message-ID: <71a446816276ef01ce6dde104c4a44993c07e6e5.1778616612.git.mst@redhat.com>
References: <cover.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778616612.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ApIbO7k_RHsQOSiFplsHI_S92RSk7iRutRRHkvsnL6k_1778619955
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 626721C000E
X-Rspamd-Server: rspam06
X-Stat-Signature: xu8sjow3h7g4a4ajz9d86ppbqpb3nhmt
X-HE-Tag: 1778619959-737885
X-HE-Meta: U2FsdGVkX186KlXIEkIMQtaRNAXOb5TNOfz08ENbtR1Q2DADRZ4dJ3SnfA0vn6yLcJyTIqi6P1vKtWfa5E0A0YEe1oa6RdUKB5MNPphICZM5vjRvZ223n08XWFaOg60k7RPT6O6xSybISz8BFnrlrrDIWu+fbcqvYIB50jMFNc/czWdm9lMc93EqHqHkok1/+e+Qx5a0myR0GJTo6/OMDLVJnGu0iqzj6oOsYsglt/JCGnSqB044CtioOObWLA6DU2YfzNqeyMr3eWtIRqCPj97xyUmQOksLOj6RcPkt6WucTggPj6y74ZpkjBsEabil1aCr+8jllN4r0NOyIli08HkLpY8akjcqBH4rx7vLF4Fbdh/KIAKr0AJO7pGj9exoS2+8h1804FYL1xwaotdRwqiHGYYP1zTx/0rX46AnbgMY126NHJjKthgHkaTZyTFqEsbK2gwI7BW3MeTh/WGS/H3doKHL//sDU/G8gb6y1abkaLkIB5wUhVtllHN/6AyKwy55JQWh/4kwzbqgM6PcCm1KZ+NqczQHXl9HtuHUNTv7U1yTdcoJoJ9SNWtF+X6dsXjCpSAwOHnO4pTpDtUJucNyzVG/MAW1kQ0xL+Ofdmq53xKC1p7TeQLrppjJ7sW9BHt0z9cXSIKx8Po0bWJizUSCDLlTM1h0XsDmoUao6PAsKcXH4hV04hOOG/zc+IYu15Ug+cVnhPGH4UUYG2/CbzpHi3I6XJWWS38G5EyV8XuafJY5ZB/HTFwrRFRfg8EwHB3/UZN/iu4USPcrHmW7pHd2Z7yoX4c3NlAcCWT/Df58J41ScnJOU25wIJlirmkI8gApB44w26O1nsgA4HR1rtUt42iMyH++opYBDRxyk/7GDgmzjq47+gcusqmhN5NBPEggFGUdQ2b6mbxRj70Kc088gxq7oGcndMEAqnyuffQ4SfxJbPe4byrIrZ95qVVs/KWkhxbZsFZWXujISeU
 w8H//ZG1
 L7v1pUYX74Uexpmpa7DGvTeXJube7g6ufGIc4cgh+Bb0bPhI/aNZAVF9lfS86AjIDNk72F9IfW7pwIOz3JKGIBnVP0qE7XYV520Rkr3EscKXPZUSR24BTgdTy1u6nTFGFfbbpdXxWBJfEseSv91g6p598MQgq9TIECr5YzlS9FUU6YkHeEYOVhzl+BMfFkzEOMBxF9ENQ3qnju+iFqrxzzf1tr03oK10B9ujGuJPT6c16fmbLwRVMP/3VLM9azYtPM26DOd954IRceYdMTR8FRquC2iz6KfzlweLTpvB9ywzTz08vUzleh5M7An47MwLQgcBLM+d9dW+PndkdbFY9luUrwQYix8apxjxXE5xgeAXA4l92QoLR30beNzHwVOVLzRJShCpKBGZkk1PWVh2gxKUt0NnL38pO4ZAF6QuoQ+ZhLT5BaQpPK3C4+tcyqZkBrgMY+18XglpUrChTfkVrRU2FeKid1Hc3sm/r0sILbcYWGb09dOu1Mj2pQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move prep_compound_page() before post_alloc_hook() in prep_new_page().

The next patch adds a folio_zero_user() call to post_alloc_hook(),
which uses folio_nr_pages() to determine how many pages to zero.
Without compound metadata set up first, folio_nr_pages() returns 1
for higher-order allocations, so only the first page would be zeroed.

All other operations in post_alloc_hook() (arch_alloc_page, KASAN,
debug, page owner, etc.) use raw page pointers with explicit order
counts and are unaffected by this reordering.

Also reorder compaction_alloc_noprof() for consistency. Compaction
currently passes USER_ADDR_NONE so folio_zero_user() is not called
there, but keeping the same ordering avoids a future tripping hazard.

Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/compaction.c | 4 ++--
 mm/page_alloc.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 72684fe81e83..4336e433c99b 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1849,10 +1849,10 @@ static struct folio *compaction_alloc_noprof(struct folio *src, unsigned long da
 		set_page_private(&freepage[size], start_order);
 	}
 	dst = (struct folio *)freepage;
-	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
-	set_page_refcounted(&dst->page);
 	if (order)
 		prep_compound_page(&dst->page, order);
+	post_alloc_hook(&dst->page, order, __GFP_MOVABLE, USER_ADDR_NONE);
+	set_page_refcounted(&dst->page);
 	cc->nr_freepages -= 1 << order;
 	cc->nr_migratepages -= 1 << order;
 	return page_rmappable_folio(&dst->page);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8c673095c11f..db387dd6b813 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1874,11 +1874,11 @@ static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags
 							unsigned int alloc_flags,
 							unsigned long user_addr)
 {
-	post_alloc_hook(page, order, gfp_flags, user_addr);
-
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
 
+	post_alloc_hook(page, order, gfp_flags, user_addr);
+
 	/*
 	 * page is set pfmemalloc when ALLOC_NO_WATERMARKS was necessary to
 	 * allocate the page. The expectation is that the caller is taking
-- 
MST


