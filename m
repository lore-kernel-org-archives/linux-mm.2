Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20B24CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 09:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865C06B00E9; Mon, 11 May 2026 05:03:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D5D6B00EB; Mon, 11 May 2026 05:03:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7535E6B00EC; Mon, 11 May 2026 05:03:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 639F46B00E9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 05:03:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31B7DC23DE
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:09 +0000 (UTC)
X-FDA: 84754549698.02.C726714
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id E6377A0009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:03:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H4MNVfI+;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778490186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
	b=DvKGAthU8FQRevAzAEascM4kaUqZEdAGYgA9KrBegIzEOIKD6AzlxSvEkiWUHdkJr3c+tY
	6Gqp41Ny2d05OqpTSS1xuylgbiI4ILCj2eySLG75O7nJl2aHnz1GbLi9a2YfINNE5fVP17
	nfMh2Hmjuq4OdwrpWsTL/GcYC1OmA40=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778490187; a=rsa-sha256;
	cv=none;
	b=Uao6KfK1JzIWkSD+NGoxypC48vG1FyTLlHxWTqOTPk1yJHmVOKTJtgPkIyXmgMHl1hbY2u
	HXqkHnVgYxOY9oxFIpHJR7qOxIBnAHoj1f3kb7sE0+riHOj4n6Z3gkM0fmRa9ig0Ob58sv
	MFICSRSlMLmILkER8ZYgGeRwcHV6ABI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H4MNVfI+;
	spf=pass (imf15.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778490186;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
	b=H4MNVfI+nANAbOxjiQag0VH+A4xKmgWI+w2KEds9QNrKA6Upb3RCl3H2Wrk7xECNCWiLGx
	5jReJmuw/ZqVKEIIKtD6ikMK7zok51M2wTB9Su28BftPb0HfmNgeKYeB9cL36ahxbPLblQ
	h7sc+eQlcsIan/0VCkrgbcB9MLyyGWg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-380-lS_IiUQZMxq7ttSL14QIUw-1; Mon, 11 May 2026 05:03:04 -0400
X-MC-Unique: lS_IiUQZMxq7ttSL14QIUw-1
X-Mimecast-MFC-AGG-ID: lS_IiUQZMxq7ttSL14QIUw_1778490184
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48d144d3428so23314255e9.3
        for <linux-mm@kvack.org>; Mon, 11 May 2026 02:03:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778490184; x=1779094984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=43zcPeyEBahcbXzXBePbjbHiq0vh8NFM/GDJyyFYelY=;
        b=SXm1Rh1MYQbK0f8QeN+AyJaU9zDukEPz/bOoA/Lro+Mc6r2/ctaqcgBXvKzLEN7tm6
         czHdsyqubCYfrigwUwWHzqXiKvXRZQdbi6URMFyLQq7zFuQZXldXiXXSVWv7MY225MIP
         Q9zWHTSI/TkI5BzPdT52OEylRyeSWl4LqmxNplDsPykGX/SPpCl1l47JSpGEYsTImiQ/
         pkjiIsydjWUXAr4/75MI3huFEh2Hz4yqEGPDNXKvyveofivCPHCFYUexjUKfiyxhBwaY
         Ft7/AATkqN+shijf31w8qmTd1nHsKA2khK4E46PET1tK0DLm/kAv/IYYGf9dvOu0u1De
         49tg==
X-Forwarded-Encrypted: i=1; AFNElJ/Wg3Ux+tPj4TopfybnrzMxW4caBuxCcuFFhWKe4SGWTJAfd/WqKtW8EOXLesiKo0NJwAO9Lov2fg==@kvack.org
X-Gm-Message-State: AOJu0YwR4klrGBUxec5+LWefdiOm3gXoYZd10GIsapACYLC4tWiertd/
	jK/IPA52SvacgbctSf4ZEwwClYhiC/ZBbn8IXssV/9wVuq/Oe9GphooAn1YayW8IGOdrZh1jCrb
	mNBVl+Lm2jwyhyoGWDLqVKPleYzuyDDPki1hkd/tSmEhTihj3fHKe
X-Gm-Gg: Acq92OGZX3kWwZ9k1l0xWfc8qBBjX/yebrCb5WjzHTm880jNthodwpJWjkkwT52Wq8G
	5tQMwmlwo+t5f8rgjGZ0wbF9y8t3kKx73RS5RaQluYDUy+xgdCoOoNKu1L7myoqJX5OT3yQ8GMV
	pweb0Y0pPWCaSZ5s8y7bBBeCzBoYfbLsIOA1QNxaKss/boLJF9rzdjbdo2AiP/6un4LjWRQnmpi
	sfjEBj1+Aon70/GliiRZ+RkUPikJB0jCZQqPKsya4Px4uoyLuyxgNCijWi/nPQOmK/VVKOW3awq
	ApFukuciPR+OOVwZgM5GbVFXJov4Fpn5Q3I5lSzbK22vGi2IAqM38D5t1ITYXSZZLImGgoX/Tjl
	pOrIcJbkUnnQohIMp4zk84ju+kLqrPvK/RFPXW2L1xHB4gN7HhlI=
X-Received: by 2002:a05:600c:8010:b0:48a:5339:ef0e with SMTP id 5b1f17b1804b1-48e70687eabmr138059875e9.3.1778490183458;
        Mon, 11 May 2026 02:03:03 -0700 (PDT)
X-Received: by 2002:a05:600c:8010:b0:48a:5339:ef0e with SMTP id 5b1f17b1804b1-48e70687eabmr138058895e9.3.1778490182719;
        Mon, 11 May 2026 02:03:02 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548e6a6470sm20880966f8f.7.2026.05.11.02.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 02:03:02 -0700 (PDT)
Date: Mon, 11 May 2026 05:02:57 -0400
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
Subject: [PATCH resend v6 13/30] mm: use __GFP_ZERO in
 vma_alloc_anon_folio_pmd
Message-ID: <c8768c7c2a4965b5e2dd78680c936b82606cc034.1778489843.git.mst@redhat.com>
References: <cover.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778489843.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cVKDAaLsriMPJZ4D3wnf-e4doFTTyo6Z33TUb_rhXzI_1778490184
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6377A0009
X-Rspam-User: 
X-Stat-Signature: mgk6d4wf5m3sbpbm76tmxfwwwpk6uu3c
X-HE-Tag: 1778490186-177693
X-HE-Meta: U2FsdGVkX18/RtWb96msZnBJg4X7BgLtQjFvPdlC5Q+AClbulLX4ql51kQqrcMmVKrVgPPUp0k/wCwt5zMd2UrJytDoUhzoIrzIY5jR7L2CfJIR2YRH7FMyUhkgFr0yw/6/xEhWILmelIYe4a1rLDjh48FioOhg9/53YlV60aGHyryC9FgkcekOCwGF0Ndx6SFLjrrM86JN47Okedh5tV+BAIeQIAFjsQSb1lN4L5cQXXREC83pK2wVSz9bIu3xJ4RpgJnN0LY+Upbxtui1wyIRAATHBdpQk2d8UA711eu7m0JU/0g24SjTzTc3hEYpLrV7Gj3FAfNEpi+UuZ8FO8MfHK16xijXqbhNr/WFukT/u3TeaG2vWj3Fbb6J35vyTGbD1V25mmNlEwaJEBCVQtTyo0iu+4xCOK0W+p8OmbhtLebBlveRcoIEpqZJyoEQhJwk6Nvarl+rVNZU71/eDmLZGGVSEqAEUo30AOJLgieQ+jtzp6cikCXGp6B704ofTq7MHXE1a6U5djBpMe5dA55apF9c5awoRBAJWeBB9klsJ76gvE/1+zAxmbm/ZkGf4rJXhj1YoOFt6xFlRZ7Hm4JJzOoWZrGCK86IJRxOy82FiW4JrfI0vhgC7dAkDmfTWISfAe2lISjEEIg6KdoB8x80nF0WBtjg4fEz1+dvhdalGACqJ2TrIFG/fQwA4J9drBdPOlTkgRHJVaKkYU6/Zf82PFqQ/+PYxo60lIE1NHgJoo3daXGDT0cBtfRuL4JK3+Vx4TPC73pc/xp4BNyiXMjkmD4b88wTM5HONISzx7kpBgvrC0vMSaqRAeTOD+vlRprPnN4Kfo3OCwdBA7Nk4Tzf0pbmmoVnW09ubWbIUKS5m8dSi9Y/OP2DQPrf6NAYawJdFnwUTC/AtjJ9BxF+JL7EMf6EbKEIIU54mkWo6trhhmwEgcY9A8MTGSMrrpAGVhr/b63UTHKMNmngJ0UE
 EWit68aW
 ymgIwWI08SPWC+zdM1L+Zsq2L2Pn02K0oBUqe3/5mN6l5YjEvbvOJlsZoxyynYzo07DW7j21Xy2P/cMimzZWxktutzHX/Ue0UnO2ylU6J/ZAlZCFNznfwKx6L+qFbeIkf87DSms2jAIA7Y19dXtUkAvyCdkpyazfH/PZL/l19V7CxrIAj7XCFh/VapkDga2yz+j2o9JNnfW9W6mU+UPm8ahmExkrlCc2E39z+68yZlV/GJ/vaWmuj8tpVOo121kM5s/xcblOCF5NF+4Yn6pxNaW2DUB3VToD2zitOIinky8zp3Gmkl/GP6dZLb92Qqhw6A2X4K/E2pjKF3G6k24xU18bv6foari3TETU/0G9AfAPbFn8BK8ht6itkffdU8p5Q8kRo9cpt4seQAafcwdnteXuSDU1DRqZsu6FhaWAn/fwUEXtAIt28s5iHmW6UQTlleLMJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vma_alloc_anon_folio_pmd() to pass __GFP_ZERO instead of
zeroing at the callsite. post_alloc_hook uses the fault address
passed through vma_alloc_folio for cache-friendly zeroing.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 mm/huge_memory.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d689e6491ddb..9845c920c29c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1333,7 +1333,7 @@ EXPORT_SYMBOL_GPL(thp_get_unmapped_area);
 static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 		unsigned long addr)
 {
-	gfp_t gfp = vma_thp_gfp_mask(vma);
+	gfp_t gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
 	const int order = HPAGE_PMD_ORDER;
 	struct folio *folio;
 
@@ -1356,14 +1356,6 @@ static struct folio *vma_alloc_anon_folio_pmd(struct vm_area_struct *vma,
 	}
 	folio_throttle_swaprate(folio, gfp);
 
-       /*
-	* When a folio is not zeroed during allocation (__GFP_ZERO not used)
-	* or user folios require special handling, folio_zero_user() is used to
-	* make sure that the page corresponding to the faulting address will be
-	* hot in the cache after zeroing.
-	*/
-	if (user_alloc_needs_zeroing())
-		folio_zero_user(folio, addr);
 	/*
 	 * The memory barrier inside __folio_mark_uptodate makes sure that
 	 * folio_zero_user writes become visible before the set_pmd_at()
-- 
MST


