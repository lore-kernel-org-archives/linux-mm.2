Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29EA606A334
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0446B0927; Thu, 22 Oct 2026 08:28:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC75B6B0928; Thu, 22 Oct 2026 08:28:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C075D6B0929; Thu, 22 Oct 2026 08:28:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B7D36B0927
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:28:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 10EEB40834
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:28:16 +0000 (UTC)
X-FDA: 85350189792.18.4726EAA
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6E4CD140004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:28:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lL6HT0fV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792672094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CPqnyF5S+r1Kaagrptzy8zg+kN7I2FQmxGKs9M2Lbgo=;
	b=xKQ0md7qceI55/urr1O9LCw/52o59FTqu/SXgNNKiV0YTG2DjfgPpGPRDvbsS1Luzs0wA8
	zhr7BdMBEox9wSOl9a4ncpxRr1k+wlipWhyXT9ersAkrFldZ2WuKenBOA9U7JcQ4KfuBQm
	8hHscmjf+tdWijNevl4NYToQePtvBwA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lL6HT0fV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792672094;
	b=DLEc0/ZnVWQolp2FFK/YNHPavJHLdd43xZ7b6awZ+RCGRs4oFDfj3kE5K58H6qxwCdRaV4
	x96vbzPEqttBm1nqx2VSJaZ5kzbmBWtSuM7U0BMOGTraIy5ixrumj+mnyXYpRFrYGwAvBQ
	rjMbUJJ3On6w50OpsqAspmJHRBVC1EA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RaO38nP1XUoYBIOSBrcJ/lr2ZncC6R8OQavI7uqsSh0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792672089; v=1; x=1793276889;
 b=lL6HT0fVMXdH/cfbNz+Bkobw+qtTRWP68b1DxyAqguoMxnsiFz7MgDtWv6bxo/5fr/3ueh78
 wLEF0NaaDqaqxhtWTFUhFHg2040axbMgBx+2VExBgWfDc2kNfeew+aLOWlBbplESAlj8VXJj7K9
 lFhigJO3rnICUqgmfS0075Us=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4fe0cf934d8eb657;
	Thu, 22 Oct 2026 12:28:09 +0000
X-Mizu-Trace-ID: 4fe0cf934d8eb657
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: rppt@kernel.org,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH v2] mm/page_alloc: mark pages freed by __free_pages_core() as not tagged
Date: Thu, 22 Oct 2026 20:27:52 +0800
Message-ID: <20261022122752.74774-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E4CD140004
X-Stat-Signature: 5ksd6wb7b51zri91cfz7zybmfrk8cfbf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792672092-734613
X-HE-Meta: U2FsdGVkX18O+Ws2xyk6jBMqN59CSpKrJ+otAFddwLTwOGfKyg4YEXa06Mrzjn+3IGM9K+4z1TbFYvL2D/soEznF048KVuhuWY8SOS7tyj/fa6lb6mv7wadUy/PXAy3o9gYSSbJen9bQze+Mj5MNMk5PgrpQHmnuN2cQQ/lHG7g1AIdkf5L9QHqdx9rWVNFtweQCU75qHPU0nIJ+5/VP3M5U2xZ7sDmuJ/BoOsm/tbOS85csuOVU5pj8SdhAEpnoOu31Ya503k8TulYXG8pTobNIGFcn3VFYfxh6FWGAfXWNXnbrlpqLF+cNl9XIInCm0wSvpCCHfYLpofM+WQC+qS+k6jlKk6Ub47xDygUjHKzVWh4qaM61LivsMuDzinOx7e2W1+eAMfGWap+mAQe/wnwyksqemHImGLXr+v/yJXp4qvF5SP/nTtJermJhyGYn7kN9RqDMIvO5jPMQRXEJYj/CdJGBvz0lSqhecGfMzV0+Yb396a4cs7tguRXWIYpu9H8PAB5EpdDbPiQ5+lhrydEJO0GkT6fccrMImsIdHV+9dSU+nP/mYiL8e33dViuZknvFHw9babjCjQqqLY5/qYKtXwYBXEOl1SlZUBrVlQ/JOJgRx3Kpbl4sbtORcSCpYvnn/yBrYWgaANJE8XOoZMCVJzdN3ROArKuv4qpJZfKF1QooYfbAAINDWZdyQdBwy8hn3Zm0/QZYjfuUxXC6tgClF3iwOh+RNPYgYDCr46yRfYotuCI1cMLYzTqjXTYkbUspSU4iJ3XKXqzIc4PeoAkOZmgB1MuKydgAHjNVynD2qRdg8JOe6u93AjwtLv8r2YDabTY7qmZXWWwM/hNjArwzLTWgcPlaKi8Sn0dmOuQaQQSscUYj3Rluxh4g+glr80OxpytV2UBVd1sBWUdaVQzWOh6YXpFQVepMMpsx1rB3YSpt/hVUz2IDkx96blr4rVKF9kWhJa6+bp32qvp
 DFmroYUU
 JPhoPMu8W/CwO2IaXo8LRntLHtd82OhB3omgCr1Erd+/rfudVJfHpSt08/7oK1gQ//74yJAG0Wl7zTjADzJBtCpNAn1LtS9fs2pBFFsHrz4DlK7MDUGBdVD4sfBKw1z+FtqKTLx0RTeSgf6c+x23tT6gQP2b/PNDq3gtoOBTNzJfDk5haKKwmv4zi5O2eXdfMaKOubZ/lrQD/tKc9jBvofxpw4xrHqHiEGlu6cb8a1x5hvW/MBjMfJTF6CB4/r+iuiRdr9RlV2HS7pL8M1XsONNhK9eZs3iepLrVFcdm1P5Qjhos=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

Onlining hotplugged memory (e.g., a dev_dax device bound to kmem) with
CONFIG_MEM_ALLOC_PROFILING_DEBUG triggers:

  alloc_tag was not set
  WARNING: ./include/linux/alloc_tag.h:166 at __pgalloc_tag_sub+0x1fc/0x254
  Call trace:
   __pgalloc_tag_sub+0x1fc/0x254 (P)
   __free_pages_ok+0x14c/0x6ac
   __free_pages_core+0xa8/0x188
   generic_online_page+0x14/0x20
   online_pages+0x220/0x3b0
   memory_subsys_online+0xfc/0x198
   device_online+0x58/0xe0
   state_store+0xf0/0xf8

Pages entering the buddy through __free_pages_core() have never been
allocated, so their allocation tag references are NULL.  The free path,
__free_pages_prepare() -> pgalloc_tag_sub(), expects a valid tag or a
CODETAG_EMPTY mark and warns otherwise.  Paths feeding never-allocated
pages into the buddy are therefore expected to mark them with
clear_page_tag_ref() first, like init_cma_reserved_pageblock() and
free_reserved_pages() do; of __free_pages_core()'s callers only
memblock_free_pages() clears the tag ref itself, and the hotplug
onlining path was missed.

Since all __free_pages_core() callers free never-allocated pages, mark the
head page as not tagged in __free_pages_core() itself instead of relying on
each caller, and drop the now-redundant clearing from
memblock_free_pages().

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---

* From v1 [1]:
  - Clear the tag ref once on the head page in __free_pages_core() for both
    meminit contexts, instead of once per page in the MEMINIT_HOTPLUG loop
    (Sashiko)

[1] https://lore.kernel.org/20261020161053.59879-1-zenghui.yu@linux.dev

 mm/mm_init.c    | 2 --
 mm/page_alloc.c | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 01fb46be3d25..92e4a78207ca 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2475,8 +2475,6 @@ void __init memblock_free_pages(unsigned long pfn, unsigned int order)
 		return;
 	}
 
-	/* pages were reserved and not allocated */
-	clear_page_tag_ref(page);
 	__free_pages_core(page, order, MEMINIT_EARLY);
 }
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e71e514ea18d..0396c50b96f0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1617,6 +1617,9 @@ void __meminit __free_pages_core(struct page *page, unsigned int order,
 		atomic_long_add(nr_pages, &page_zone(page)->managed_pages);
 	}
 
+	/* pages were never allocated */
+	clear_page_tag_ref(page);
+
 	if (page_contains_unaccepted(page, order)) {
 		if (order == MAX_PAGE_ORDER && __free_unaccepted(page))
 			return;
-- 
2.56.0


