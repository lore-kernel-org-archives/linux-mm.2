Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F08FF606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Y73vzWKY
Received: by kanga.kvack.org (Postfix)
	id 1345D6B05B2; Thu,  5 Nov 2026 02:04:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10C026B05BF; Thu,  5 Nov 2026 02:04:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 049B96B05C0; Thu,  5 Nov 2026 02:04:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6AB96B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:04:46 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66ECB140929
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:04:46 +0000 (UTC)
X-FDA: 85400177772.21.C0CDAAE
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf13.hostedemail.com (Postfix) with ESMTP id 415CE20004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:04:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Y73vzWKY;
	spf=pass (imf13.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0LYlvKnBuyOgTFhE6ZXvSHnkMEzStXd16IsR93SDLcc=;
	b=cRkTeeEuU4H9wv24HgtwA4OEptTfm6PYbL6K+GkmZEAiK4l9OvLBi+W3C6TcHpgmCrg94D
	ZlVKho97hZiXXSYy+d3uwXg3v8UZ0X3pedPPOvbxfijdoIYTu4Yq+d182rfTffdFd4e0Y+
	SLqPhXdRwq0/O+mNCgo4NfvXbsgMlT8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Y73vzWKY;
	spf=pass (imf13.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862284;
	b=ipOU9KvsS5L9ywk1Y2y8bPma9q8xANXcvMmOnCtu1kpCAnC9F6rJrcDDLN6BW7SgDBoM37
	WKx6NClGwB4fY6Fg9FvA0QJYPiOhRATvxdX/VOHPUa/32DQHsCitkwRUioQ9YOmUAcrACF
	FflFtmm3dnJpOr6pGyfE7WbEroS9K2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793862284; x=1825398284;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0LYlvKnBuyOgTFhE6ZXvSHnkMEzStXd16IsR93SDLcc=;
  b=Y73vzWKYhFkVAnb1ESfrVNZYngk2stZk7dS+dNcMZQcu5oXsbCGxYScg
   XNnQI1/dtTk7hv7XGTz2AwN1UFVYaKBeWnUdRHWzpZGM3w9IuuQvLO6W1
   f918r+YDW4tIciL1HBZPuMNfYngdgQiA2nykEOZ3ZVh1jwxjOOdmFvach
   kml6p8bBKRoupS8NmyWQ+BUqDiNUxU5QQM9j+qgtUiEn/Njt63kALpLrs
   WnBsTZ8rQnOJM0gZBVcwjBnTopES0F0fy2a6QVQ5nj1inAdAHDhApTYH1
   JiSY+N3Cihfg6ayCY2rRNjMcQH6L1c7kvUcKwK/s8gL+broqXN78LtVf4
   w==;
X-CSE-ConnectionGUID: LpbQ2qwrT/6iqIU4KMf9vw==
X-CSE-MsgGUID: E0dwvs0oQwitmljC1IpvKA==
X-IronPort-AV: E=Sophos;i="6.27,196,1787011200"; 
   d="scan'208";a="33083042"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 07:04:42 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.182:12999]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.80:2525] with esmtp (Farcaster)
 id 8a7e2f0f-1081-470b-bd38-44d3ccc99dc6; Thu, 5 Nov 2026 07:04:42 +0000 (UTC)
X-Farcaster-Flow-ID: 8a7e2f0f-1081-470b-bd38-44d3ccc99dc6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:04:42 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:04:42 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <linux-mm@kvack.org>, <david@kernel.org>, yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>, SeongJae Park <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH 6.6] mm: replace free hugepage folios after migration
Date: Thu, 5 Nov 2026 07:04:31 +0000
Message-ID: <20261105070431.3100950-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: shsg4ea4kaf1knzdb1frictcu7ybrj9b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 415CE20004
X-HE-Tag: 1793862284-710132
X-HE-Meta: U2FsdGVkX1/lOVAHKyZ5M/dgJiS6+S3CzCvNRzE2mMMo0/oVvQ9psEsO8B4+xMgmt81RSetyu/S77z+CN4pdR4BlqokwxVRw7mK3eLj2WC8ycDR0FOrh9zsB5ZqiVEe1ZOVV+CHtFoCzfSIm/tHtT01T6u4H0sgtBUm9cspgXr4uhG+stSfgriCFF5I+RE7+XIDnHDQY2kn0dlgSqJjdlY54mOomXWA9OcLxzC7Qf9xx7PK9u5Al0yu3X6N2HjwJI5EWLMpiOgO7Bfp3UOvQF4/v2DtEHk5KvbfIKvU1xjAWljRP3fmcWBJSRViLQmfI2xeqSaF6Xt+LXNbmCgvKE+RDUNCofDv5Ak6ln9TWqIU2bpxbTkqWL1tIAC/HI4VAJQuVezd2WYyALIDbDSJTyv/rcFpsPKqhJDanRFcT6PdgmzdCR2HeY67Yi2Im3kNnbQ24D0U//5ZqfRg2YAvpu9kOQFhZQvlFQ5ZtBr+0K3GRECGUF8G1NWrEEZ3ppzU5pUXYyCxpozFVsGsO6CMwAfiB+GC5zA6gfuqF01o1zLBQAMkKUay03CdLy6L+DJyIlqZCYbxPj+CYDn5So8WubCXaOtf4yBckMb1mI9rChYotglNc8DX+xgGRmzCaPsxfq3zVQ1aG25lDXQrjRK3yWHHmlJyCTI9AiaQvcvWnbBVmd2tUQnbf0/5B8f+zgBYRfLnRkO0g9P7XMCDZM83ccakmodowMkMVRMxIaVZbudqsI03ctEe8YEEW52of7obGaQeOCELtwCdGwZWq5TlfIIDjiZf/OUXJqok17xH5NNU8DHfvxR8FZS6OawxpL4yb1HxbJnrMpBooYP2adQeUOPjCfxp/44yuYyRFTjcQG2pQmgC+ieeP9FE4ZS2j1T7vrER+fnQlmL6wrAg0RMtmY3lG7JFFqwy84MYwDgBpBrWW4AOGfYAyy+6z7EdGkRsy8mVRFgrHj/iu8j/Uy3F
 Q5xmeNu7
 BIAIWBVnVLCc9gL3nki3s1YOc9nrzXvzl/X1KXaTE3Ijdz8K+00Z1dCVu3FrRJkEwNRPGAOfcUzgKXQUh9ENL208OnPSSVqN+PokERw7250NJs9fLJwY4snLYsENWtTsCN3Xoh+V2NRGa9Ev9Q/woC4bhYss2wdBaubgXVfIqea4KymN5CgmJ+Li2j8JHTk3zSZz9w8snUE4/dlR34mrowLh7kAdU5io1vjyWsRCcn/56aFy93MyELOMCIB0BL6Bb+nMpyEF8VW4JZk54lDPeSG5QGF0wyRVNs1cg1PZIugyYB5CKhEHSJqoALN4JdSr6Zr1iyzFTU1pwJ3dAmlHLP831ziJ7QgQwF+zFO3Dfe0iMLbx7KDA33x1XSDsopoSp5Ljpkwyeclod41DsncTvk/Ih+tqyaffGEIrg1pOeC+Af1mQ6eDgEyA0dECf3UwJHugfzuxXBaipO0NuVT+tJ/r9ZRo8+GFZM/bMHTVgdU7gWFjMREMJ5WNKsmnMxI/pZpmWFfny6btVOeVtvNhLqH5qNnbHLbsk1CMt7R4eavasVOqfqD97DkEQaeCrKYhscKujv+LetBmQIEgMBMwrFWrARVSlBnlBv/Zo9cHDU8lLzzzpabJigDxJKdWxFpk32CLkY7ltlsXSWOktPsk7uf6FjUSExLezNZsNuoLrIsa76GdVANdP5vA7daEFbKQP6xVm/U2VtDPSjYzIHElqpsQf4EUOYp8CTpsysdcEbfM+ba54Di4xJJn5xZqhLPWgI6hEHCwmqtM4P7FUsIFXy5M19qXx5zX53/TujAP5qGqhY6G/SVdYHF6KIfpr8zngUzOZd4TPwf+PTv7zJawXWF8fsVIEuja+RnI2a6ECw/rryTjvAcFSgmmFkaYTyhPOPGVvi8Dvm2BxzOQwj4GRwkOHmZXo9hCwZfREa
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
[ 6.6: Take only the dequeue_hugetlb_folio_node_exact() hunk, so memory
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
index 8bfaaa84bb3f..8c1a032a6f53 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -47,6 +47,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1344,6 +1345,9 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
 		if (folio_test_hwpoison(folio))
 			continue;
 
+		if (is_migrate_isolate_page(&folio->page))
+			continue;
+
 		list_move(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		folio_clear_hugetlb_freed(folio);
-- 
2.50.1


