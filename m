Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E57606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=REFZ1FZt
Received: by kanga.kvack.org (Postfix)
	id CF00D6B05BD; Thu,  5 Nov 2026 02:02:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7D06B05BE; Thu,  5 Nov 2026 02:02:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04996B05BF; Thu,  5 Nov 2026 02:02:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0306B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:02:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 110DFA86E4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:02:11 +0000 (UTC)
X-FDA: 85400171262.18.8A0DFE4
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id D22811C0005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:02:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=REFZ1FZt;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YIY8kqUIU6/z94NGPeDu4JQpZ6OW4PmQsBTRnwMMORE=;
	b=18T6Q0T16JgFnvu3a+eDTYFsKacg0PGuyEDcLEX1ZQ2qUz1rnoPwRrBuFMQ40r9xaTyN8C
	taRZqVRqscu3ZkQRUWJc+7X3jVXH3vCacqlwrm1DJLach2LtXPnnoS6jWL/JDmh0pOnDGh
	/CdMByNjJ2eGbeF8ljN8ftx1ss3pd4E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862129;
	b=2vDg5bT7/SlIXJGh/UjlA24JkWXuRTA+W0Po/qERc877QtMxgLOokeZro8WLM+uvrrt5WV
	+KSqh+LTi0Ls6HzFn/od6bxMn3G5RJclV9O5UowIw1I3D/app/8jYJ6o1vbqXs6p2rj27f
	6yHtce9/xnTfgr0kdAkWLUmKxG0Ql0s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=REFZ1FZt;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793862129; x=1825398129;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YIY8kqUIU6/z94NGPeDu4JQpZ6OW4PmQsBTRnwMMORE=;
  b=REFZ1FZtXoq5DSCnnux+iGfEfFC291NzsYxroGnw2YzEQiczbamQma/H
   DSV4ESBTqaIx+Mybr/FswJEL3ZuOg2kW6lCt/p2x+o2wmItsE3oPNll6G
   VUMSvBAQ73fU24m6F7jCj46Ed4o7MmlSbymZf0pidssYBHfU/oVGrklcP
   8UKWwNwB+H5botZGeRCnEaZ2KmSepE7uVsgcYW3oaF8mTTa1EfYnzZXwy
   m2gTebGwyM+B4D55Wjmvb5lwSe48fP2ovtOlGsy4oEQxXm9hdupy44j49
   knwQe3oLVLSR+7uz+T/k2r3qNI792AeTtk/hKmWEnF5F8pdbWNs4xttWv
   g==;
X-CSE-ConnectionGUID: s26Q9zbLQAqL8oxZ3zTAJg==
X-CSE-MsgGUID: AHxq8QwUQ/6TSK0SjDwUPQ==
X-IronPort-AV: E=Sophos;i="6.27,196,1787011200"; 
   d="scan'208";a="33069119"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 07:02:07 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:21704]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.80:2525] with esmtp (Farcaster)
 id 8ac5ada2-292c-4d17-9bcd-c9860d19a1d4; Thu, 5 Nov 2026 07:02:07 +0000 (UTC)
X-Farcaster-Flow-ID: 8ac5ada2-292c-4d17-9bcd-c9860d19a1d4
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:02:06 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:02:06 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <linux-mm@kvack.org>, <david@kernel.org>, yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>, SeongJae Park <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH 5.10] mm: replace free hugepage folios after migration
Date: Thu, 5 Nov 2026 07:01:50 +0000
Message-ID: <20261105070150.3093908-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: k8o4dbn7udhwu363g5nkd85qq3f3p3p5
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D22811C0005
X-HE-Tag: 1793862128-651093
X-HE-Meta: U2FsdGVkX19uSUSYrDSIbv8qx15s4FX7vskyxhD9aVCSFd+l19YSXPkhURWPyKi+gnsdFbVqoM/wTg3Rzo0KliJf07KtX+0uGDYdjMakWKRR2oDY1X+2aPIyR0OJx6+xoFcFz7OjtifVQsrsnfEJr5/YKJFrtL5HuyQu1iKTA4EWWjSnuCg0xvbAwGUTZYaN+pAwzwnYYLX8exgASRTc3tH+yDD6JwAVs7Oa7wBBMQ9NJK87eIAN6eNNuY3FyMpnLwLWJYZVIXYTSLggqTRQOf8zOr63HNh3MjoH3W4gZ0wAKqKRyEWFQgL2raxcUAd7f5vpl3ZbXEjalFwgXXCuPGB5CgiQIAfOvVksONPnC+GgOoyJCoYQH9ej0ku6xW9tQflBIr85Fwt3DczQAmCPgm1d13vQZ9lElg3C1Z3q66tp2AfYAcq7F1rpeR0x+AKbIMlhdxVrZeCA5BBkQ96vZdczctyHi9KciQqbWBquIiActGyc0XtgTnrgHIqEp+Bth/ajlzkiheMfQHCWY9cGQ3vK4m9BbTOWqYhyWf8akhPuo5OdFGx1Kl/7yZbA2EBb14GQkHG4WWG5uIlT+ai3owg7vrbPOJKDFhwIZwcJKagWKSW10KXeM5YT6mvrdfxyPxikhH7mlBaI9U42JuzoSG0zjKf9xKYp5Y4BTt8+asyaPO8BGNd4sIV5PRIoMe5AWFm9lE7FPh7hnBX+0DnNOrNDjw1V2FhFwsPAyUlpQjN2ze5bsqT0hRYrtDXnVpgoSYiSoEhCKWTnKuIrPVEjitdPrrhGpC+ocYY7CSbYh3V+vo6rlckuBgpCljh0BZC7IoRmTeeysoTBL8+CwE93kpbwycC/JWyI791RX+rTvQOn4RTlVjNGwTr3Im9DpbUgV3M/iOexOv1QCKyji81ObYO8qwn19V5TroGs+c1NUF7hSU0m6uxPXHEL4gPSs9+e0akaRhm/qTdwDaBJTzN
 dcZH1TPS
 TIyhiL9EyD1V3YlroaTxHR7pl4UKcR6flbgeJbPqBR7yl4wEUObcTNmALy03+j7ykqtvXmtiTUzvY8hmPqKtFLCUXNVSx3LhPqUpj+FyExNp0x/NJEWYyIiKayFa+cU51gCLi6cSBVrck6V99Nhpo60/VXN5Ejmx9FI/XTY3/WLMM2x8h1b8fvixTkWQYfLajd4lYyB0Sb/CMaJAuIJEdqvOpl6DbH+E+UJNqJ4DwXK2UwRuCIDdJU6beicPutWcsvjsIQrYE3n0RLmECT55gzkO4MSDVubs2ahfgJEcZkMOhDzEOWdaipuK8Jr1ov/wg2qLa/o+I8av2yjg8vnTrUgpEz0GHMFKCquP1/5y4BQJArRWXT+VDo9ja0oxWZY1/9j7uWq22jrOVouV0dNaAYbh7l2dhkuDO4hU1fKYTAPFYTnVFv+dEkF1MfHw5tqfCz2a3ba8kAARKVsivXfxW09lQG7o88qjZIpGvyaAMoEBUgFW5f5tL+jRMyBv8ae0Pw+BSsFENO0nN7Cz+MZOCjjo3ooZmSNtluefwZKkMXZaMR4GpjnTyddfaXn/TtJH9ZFb/ZIsc0VEqMsbSJUwxehyFO9GIyXYojVSrd9RXqsXLjNUbkV/bowT3ITuxSQD9X+e+VjfXDRgdh0wDRFA3uwR8daJZCQ1Wj78t7BZd8FyM8zeTXD5jGIQdOgXT6Pt20k2zQelkateWOWgIS9b3fW53rpMef0/zxJoShb/a5vfPmK9EU3AF7J9bm/q/tSjIMYqmdzTDe/vnmBS56wgQk3DlRLtFT7yuTNA5UUSeb9JRP3ycNt6Sndz0sVlsR7CbWFbgYiR28URFG5Az25DiKYT+7OFCN1fGWuD+hy4IPLt+vvQ/vVE/9Jtp72h2eg07yFDAam4Em+TZB+WN2JkGsFxbKuN3XOQLD8ms
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: yangge <yangge1116@126.com>

[ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]

My machine has 4 NUMA nodes, each equipped with 32GB of memory.  I have
configured each NUMA node with 16GB of CMA and 16GB of in-use hugetlb
pages.  The allocation of contiguous memory via cma_alloc() can fail
probabilistically.

When there are free hugetlb folios in the hugetlb pool, during the
migration of in-use hugetlb folios, new folios are allocated from the free
hugetlb pool.  After the migration is completed, the old folios are
released back to the free hugetlb pool instead of being returned to the
buddy system.  This can cause test_pages_isolated() check to fail,
ultimately leading to the failure of cma_alloc().

Call trace:

cma_alloc()
    __alloc_contig_migrate_range() // migrate in-use hugepage
    test_pages_isolated()
        __test_page_isolated_in_pageblock()
             PageBuddy(page) // check if the page is in buddy

To address this issue, we introduce a function named
replace_free_hugepage_folios().  This function will replace the hugepage
in the free hugepage pool with a new one and release the old one to the
buddy system.  After the migration of in-use hugetlb pages is completed,
we will invoke replace_free_hugepage_folios() to ensure that these
hugepages are properly released to the buddy system.  Following this step,
when test_pages_isolated() is executed for inspection, it will
successfully pass.

Additionally, when alloc_contig_range() is used to migrate multiple in-use
hugetlb pages, it can result in some in-use hugetlb pages being released
back to the free hugetlb pool and subsequently being reallocated and used
again.  For example:

[huge 0] [huge 1]

To migrate huge 0, we obtain huge x from the pool.  After the migration is
completed, we return the now-freed huge 0 back to the pool.  When it's
time to migrate huge 1, we can simply reuse the now-freed huge 0 from the
pool.  As a result, when replace_free_hugepage_folios() is executed, it
cannot release huge 0 back to the buddy system.  To address this issue, we
should prevent the reuse of isolated free hugepages during the migration
process.

Link: https://lkml.kernel.org/r/1734503588-16254-1-git-send-email-yangge1116@126.com
Link: https://lkml.kernel.org/r/1736582300-11364-1-git-send-email-yangge1116@126.com
Signed-off-by: yangge <yangge1116@126.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ 5.10: Take only the dequeue_huge_page_node_exact() hunk, so memory
  offline stops migrating huge pages back into the isolated range. ]
Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
---
Without this, offlining a memory block holding mapped huge pages keeps
migrating them back into the block until the offline is interrupted.
Reproduced on arm64 on 5.10 and 6.12 (stock AL2023 6.12.113): the offline
was still migrating after 60 s. With this patch on 5.10 it completes in
0.15 s with the data intact. Also sent for 5.10, 5.15, 6.1, 6.6 and 6.12.

 mm/hugetlb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b23c8b2699b5..4383de6fe621 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -41,6 +41,7 @@
 #include <linux/node.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/page_owner.h>
+#include <linux/page-isolation.h>
 #include "internal.h"
 
 int hugetlb_max_hstate __read_mostly;
@@ -1088,6 +1089,9 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 		if (PageHWPoison(page))
 			continue;
 
+		if (is_migrate_isolate_page(page))
+			continue;
+
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
 		ClearPageHugeFreed(page);
-- 
2.50.1


