Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BBBF94CB4
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 22:02:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ED436B00B2; Tue, 21 Apr 2026 18:02:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C4CC6B00B4; Tue, 21 Apr 2026 18:02:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B3156B00B5; Tue, 21 Apr 2026 18:02:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B3D6B00B2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:02:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D0B0BE1B7
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:20 +0000 (UTC)
X-FDA: 84683937240.05.550F060
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id B3FE78000F
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 22:02:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fDv61e8p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776808937; a=rsa-sha256;
	cv=none;
	b=cOZ6oh/A8nQLwFtOHJE/5iDvecbOGwy/UqCRt5T5ZtzmcnewXqhiAqUirygjM0apSFPOyQ
	2+6T/aGPslx3dtrb/OzNoLZ6n5gbfd6RLNjeNjlypiJyIout1yleKEAuwpNywjRCTZraBZ
	ceFFLtp7Qx8GoqfwXHgo4fx2P0Agn9A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fDv61e8p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776808937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83Or3bPRvcXeLqEVqfcTGNmNcJ2rHHbe/Ydh3aV3puc=;
	b=MxFkwDpPInZCamEBRzabD5c9UMDOCM82Q4li9fevPihUviX/VsAdfQM/T6lXX4Ozp01uEf
	iQ0lb9EXUhsbrYTNx+ICfIN9TyNd5DTDLWj2F5WGKd3hIVjyw1/0JpvuYU30tl/PHQ79UJ
	julanMIln4bzqcRaZMaBKPeCZ1FhQ+s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776808937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=83Or3bPRvcXeLqEVqfcTGNmNcJ2rHHbe/Ydh3aV3puc=;
	b=fDv61e8p+C+rHNLwKwFrhAjcVbHZ0rTZMXvVCeHkTBp6d0hVv+lFNhzAEgbCopJLfhPl+a
	GTRh1cccuAOFCzZH6dMdSTg3lmJ2em45Nf5NZsSUeBA6O8ccV/XGlmT0YpES2f0/Umg7qw
	QzrQ/tPJytxpCmzuVk6EpKUBaNV3clo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-g1BBP0WZNh6LmVEDwqqbBg-1; Tue, 21 Apr 2026 18:02:15 -0400
X-MC-Unique: g1BBP0WZNh6LmVEDwqqbBg-1
X-Mimecast-MFC-AGG-ID: g1BBP0WZNh6LmVEDwqqbBg_1776808935
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-488c768a9a9so36643695e9.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 15:02:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776808934; x=1777413734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=83Or3bPRvcXeLqEVqfcTGNmNcJ2rHHbe/Ydh3aV3puc=;
        b=jFCqoWCVXZxt3OPh4HuuvE6Fz5/wYnIqZESPAFqplpC7RNG0OwWMFVrdcPz6cTCvIG
         MTfv8mDggYw0U+M2OVWtl+paaXQTNVxPzupZeT5xUjC22b1+FS0FHPurnW75swugUtsg
         8YextAlDY3JQw1Zd8K8ajJJv++RLUiIbzn8gnPlFwlwrzASEyYQA8W4TVUGS7tXcvMX2
         LIi6Y/ISWfsyQJeqQpO1LE1oH2kVk0MYLmsSoz2qwQWx6iLxR1eo4Gz4kB6S+dSViYr8
         YkWxrWgiSorP/zJ+7e/XHQ3do/cswpITZAPe6HgTjJwr4s5SaQMapzOejcMY+QGKnm0B
         dZVw==
X-Forwarded-Encrypted: i=1; AFNElJ/HbYxPpMOUTXd2S6q8nmmV80I18y/F5uGzrvfUncIiS6KIT72MSl18DqbFkrCGO46qwpYh8SfJdA==@kvack.org
X-Gm-Message-State: AOJu0YzfwILuHsctDu/CRrddFsB25Qa+AWuD0JI5xklhLYi4oyIqFjRR
	i/iflbnzds/L1OYs+QcYrpzxjxzwvwz37z2/d8BkeszEYx5JEDSi0FH6gkKmHxS1y0ErV9kgDYH
	Ewpg9+7rjSU2ecm0Yn1LlWbL2B/rX6u8IedTBLmU5DADV5Ydyt/z4
X-Gm-Gg: AeBDietK3XACDQOjq1GTCRDy8mPnD0FrclTi76j313fGeJW1hUDUKq2kmQlYah+Neqe
	kk9+LUVu9DhPU5RtkhsboxI9dtT7Baq6h0OKEeSJ4dgjRX8S89EoIetliHFdDijKYfYfkatGFxo
	78K+Z+ZPE3pgMd4wIgsqJ2s8eR2WXoBy/qnQ7QFr54rvwF42FuN1U4FZttuBW8Czq6ICup9mxRn
	WODBBC5syIkx7HoiU/Afh11wtxdBcqd88ODuhTaEULcrvdxjwPfxnuTQwNXKb0Lft4Pk3EA6RVR
	sAoIAlMtTHpJoafCBiK3qEibpCoxLSodjexsXJp/I9tKpamcyQBgwvgGgnqbg0NF/IVS/7gcHlG
	UZkZhfakJKhtq3pOzsJQj7xK4LkVOzJEKUVjIpKMQVTDvkcXb1Q4UUQ==
X-Received: by 2002:a05:600c:a105:b0:486:fb69:4960 with SMTP id 5b1f17b1804b1-488fb7786e4mr201642695e9.19.1776808934555;
        Tue, 21 Apr 2026 15:02:14 -0700 (PDT)
X-Received: by 2002:a05:600c:a105:b0:486:fb69:4960 with SMTP id 5b1f17b1804b1-488fb7786e4mr201642415e9.19.1776808934123;
        Tue, 21 Apr 2026 15:02:14 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-21.inter.net.il. [80.230.25.21])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a5aa3ae83sm884845e9.12.2026.04.21.15.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2026 15:02:13 -0700 (PDT)
Date: Tue, 21 Apr 2026 18:02:11 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Jason Wang <jasowang@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: [PATCH RFC v3 18/19] mm: page_alloc: preserve PG_zeroed in
 page_del_and_expand
Message-ID: <23f51ec61026f598a30a2a031fcf88100afc1f98.1776808210.git.mst@redhat.com>
References: <cover.1776808209.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1776808209.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZB_Tx27WxhznCoe-ddbVcvnYRhffJrbW6ADMbhKg5SA_1776808935
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam10
X-Stat-Signature: o5kr841at1pi9fczbswqg6rtgbhk6wei
X-Rspam-User: 
X-Rspamd-Queue-Id: B3FE78000F
X-HE-Tag: 1776808937-796657
X-HE-Meta: U2FsdGVkX19lYs1AV+aVu7ADpXbY+NYTh9TMWqAjuLWHO+pIlBtBB8/ZcpRcOS9JJdYvhbjL+3W9eE9+F60UUGeGGSwVMummmiHtmp/tC3i8TWhudRtEWd58y89cV9/BLJhVxWAwuymEKWNb95QYXKkIutd2Qf76SNrpBh/jGJaobDYQ1WChRpG0xktQdRtGTIGjaGAftjwQrrz84nwI/Y18zPLfQwh0oau9PpgajasdJgXEl/ARKWlRiLBscx+6hHAoSB5AINt3erwesXK8wuF5b2tqtSy8f0/tThjmjGc2Jyo0dxBlOcWEIlqY3bCz4hTm+UpfeqQNEEzAlFEkhxuPQ9zRynQlDEfL4+oGqJnWqcIRwKFzqgxG2mK6y1+J6YmY2tZenhMiWQhZnO7QcTwjCGAtLeiyFp65i0/t9dqkSg0X1+kxDb1fdrTAq8lzcpZc3tgtYpr7c/Q9yqJ4a8dA3EosIAmaCOGJtGST7BTBYrAuujBJHJ69m7KyJY4FUUTfYKwoLBwyrRCzjwQRyNsHvTV4PdpChOjeD+Jtx2VttksFdC1uxaIAYE40ip0nNTFQHQAf8cXYlIS3yZixD1H+WLy818TUOyXe75o/AjwXeWIhs/4bd8TBetXS0+xoVRkJKpmVQCRkz3rSdk6/8ED1OLlqc6G9JoZswf9H4MLr6apar4Vtli11wYB8QP6eqJSYwj4jktUHqqWDYm23qbLX1ysey6ZCdAezrBXkgNBIz7tyL/NytMp5Acz4+nr9dpN2a5iqf//FRMj9OHqq5rF753b3Hv0Z6rJeEyA5J4dgO/4/v8X3/fdw9Ld2ZkmlwrpabDrf9JpbtrNVBEhTqN9jKJ1jhI4p8hO4lKeWUUm19aasdoPMhqIeeUa7VBqIotRqcXHGPcRE1prVNzxlh+GyvMQl1Beev2wIJfh06rknveawz9jN2zaF+SgSXaz7HBDO7LMfk7eqQVgelvg
 fX2A8HyU
 16AX/KSnH+7fyJs2fZUJmwScDshOkyxbtl7pNKf6wfDE82JNF4zsLnIXDcoHZ6HfnLwyKk9vOILcRMfUDt+4GnCyx+LiR/IsE2ywgf+MulJPRSRR+6awxpvcwGripaYAGo58WxY56777VKgOFraa7X0Yu/5K2Shr0VfiLvOKHpMFnQg1/gdYTBbTKzx0Ev9gxz/fznh/pCe25BJu65naTmI3Oy5gslvfSkR8VO08WyRKNSxlcVbZBlnED/qUhaOZDL+7RSVlNZzjGJ+mFjNcln8qtJr5hyJHhP9FyKLiT0d8DEwNiAbQWEyt+gCA4BhbKca6F0ej+17uF0xioAVwsSo91hpedl9+4moavwqBYf+FGRl6YZvTOFtuuhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Don't unconditionally clear PG_zeroed for non-reported pages in
page_del_and_expand().  Pages freed via free_frozen_pages_zeroed
(balloon deflate) already have the flag set and should keep it
through buddy allocation, not just PCP reuse.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 mm/page_alloc.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 122b49a6d435..3f5ed022cb9c 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1751,7 +1751,8 @@ struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
  * -- nyc
  */
 static inline unsigned int expand(struct zone *zone, struct page *page, int low,
-				  int high, int migratetype, bool reported)
+				  int high, int migratetype, bool reported,
+				  bool zeroed)
 {
 	unsigned int size = 1 << high;
 	unsigned int nr_added = 0;
@@ -1782,6 +1783,8 @@ static inline unsigned int expand(struct zone *zone, struct page *page, int low,
 		 */
 		if (reported)
 			__SetPageReported(&page[size]);
+		if (zeroed)
+			__SetPageZeroed(&page[size]);
 	}
 
 	return nr_added;
@@ -1793,10 +1796,12 @@ static __always_inline void page_del_and_expand(struct zone *zone,
 {
 	int nr_pages = 1 << high;
 	bool was_reported = page_reported(page);
+	bool was_zeroed = PageZeroed(page);
 
 	__del_page_from_free_list(page, zone, high, migratetype);
 
-	nr_pages -= expand(zone, page, low, high, migratetype, was_reported);
+	nr_pages -= expand(zone, page, low, high, migratetype, was_reported,
+			   was_zeroed);
 	account_freepages(zone, -nr_pages, migratetype);
 }
 
@@ -2373,11 +2378,13 @@ try_to_claim_block(struct zone *zone, struct page *page,
 	/* Take ownership for orders >= pageblock_order */
 	if (current_order >= pageblock_order) {
 		unsigned int nr_added;
+		bool was_reported = page_reported(page);
+		bool was_zeroed = PageZeroed(page);
 
 		del_page_from_free_list(page, zone, current_order, block_type);
 		change_pageblock_range(page, current_order, start_type);
 		nr_added = expand(zone, page, order, current_order, start_type,
-				  false);
+				  was_reported, was_zeroed);
 		account_freepages(zone, nr_added, start_type);
 		return page;
 	}
-- 
MST


