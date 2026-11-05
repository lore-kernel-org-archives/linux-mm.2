Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 065B8606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=m+AWcpVo
Received: by kanga.kvack.org (Postfix)
	id 21E306B05B1; Thu,  5 Nov 2026 02:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F68B6B05BF; Thu,  5 Nov 2026 02:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132776B05C0; Thu,  5 Nov 2026 02:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E55686B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:04:37 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 66B141C4314
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:04:35 +0000 (UTC)
X-FDA: 85400177310.06.D293046
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38ACDA0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:04:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=m+AWcpVo;
	spf=pass (imf25.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=LUkLYCAQG8uZ5fDEy/ZrjWX6jHEgJ9R2DqBFxbgN3OM=;
	b=Qt2jx41tlcjpcDHrY3AVQBsQeoZcO/hsrmXcj8Nh/+UEGM239Bj9/CJObL/xx5mAOQ5liy
	km4L7p6vQujgHySkzBtJXAVWLApOk++ejpRk9TCM1FGEw9FmvUP41ZYfZwbZip4yp1bnbs
	X3LiaLGD9mC6JyqkSae4Ui40eXZrPmU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862273;
	b=CHNyRu/k6ls3XUkloXpW+PLgTm+jYqNgJ+i46wALDnggAQTqMVAqb3/nISPbLfmN63GSjG
	7f13kWGEMhHpATnA4E6wtW1Whi5YHOaQMg4eicTXPu01v8a5Iuy4DYw6aoWnWTZu69o7nW
	LD1kjps9XeQkm6Ojg9TVN4qO6QPlyQE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=m+AWcpVo;
	spf=pass (imf25.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793862273; x=1825398273;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LUkLYCAQG8uZ5fDEy/ZrjWX6jHEgJ9R2DqBFxbgN3OM=;
  b=m+AWcpVo2IP+nJiYpePaen7O07lEJDcSERUthVJ36d4XsSNauwiN75b2
   5nwwIDtmijBcpkDDDhf0l/OZBZg52SQr56tks5Pk3Zg+5ohVmBz2n0SGV
   Kpt6lY8WHDsI5sqjCOD11iISWalz/teYCPxOZW2NUKVRYZdz06bae0JD/
   GPM8U8NMRDpRBB/9SIPCzjPJvm+/yw7y/y8Z3IvMHVSfZJQJfs0OSFLe7
   yG9htWo3ERuOTfn2pTkVxHmiTqDbou4WFC6O/G+EKdaESlb3SyqN2fcRS
   H7rDT4sUBKBOaXXpCI3ojQ6koJe0dtMnFkQ7sMGZkyOyGvOKa5yuYslDg
   g==;
X-CSE-ConnectionGUID: vrDY9AL7QE6n6IHFzeQHIA==
X-CSE-MsgGUID: ow7+GQKLSr667QbihRJPMA==
X-IronPort-AV: E=Sophos;i="6.27,196,1787011200"; 
   d="scan'208";a="33157905"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 07:04:31 +0000
Received: from EX19MTAUWC002.ant.amazon.com [205.251.233.111:23713]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.208:2525] with esmtp (Farcaster)
 id 97f8a510-eb14-487f-a6b5-da15ebf78121; Thu, 5 Nov 2026 07:04:31 +0000 (UTC)
X-Farcaster-Flow-ID: 97f8a510-eb14-487f-a6b5-da15ebf78121
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:04:31 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:04:30 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <linux-mm@kvack.org>, <david@kernel.org>, yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>, SeongJae Park <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH 6.1] mm: replace free hugepage folios after migration
Date: Thu, 5 Nov 2026 07:03:46 +0000
Message-ID: <20261105070346.3099207-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: wzmo88ante5czii88dszjxih8n9on4qx
X-Rspamd-Queue-Id: 38ACDA0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793862272-258889
X-HE-Meta: U2FsdGVkX1/u/pmzpy45ViJpA7sBrVaoNy+2wmNqVdkaGhNrYgPhJt9k43hOjqbqVeWnUKRpscCmW9G11HcqyKtqOtqAwYKKMGnU00lhCkbYAqSFBXuhm5xx4PJrVbfw8tS70qor20UGLIAl0q3xCN31bT0bxyy0rPf84ja5j+2/vRpuQSlfmyCp9+9YkvZEGt77Lyc5naL7L77fYv6bB54f9apFfK0g/9REl+l/GSnRS2FtjBItcHo4tbqDZkwaMpSFygR4OPoMvjitCZ1FcfGKfjw6VmtP6N4dGIcw24Pk9RvUP5ocXU06HIOIsG6xPm81jG+IkKGlm39p1df7COi6Xiw5sxMK7lU5tX7haF8q3qGxC8s+JpDwZrPkJGnwJ0u5WFp+xjB6QotLP71hEY2Du8IoePxtxnh+YUlwpWkDU5zQ9gwDrqybRvbYUKaeyWw24baaWd5A2Nrwo3PzmHeL2g6LunicVM2br63uV7SyY9rLt5Z4u9UpWR9prktlowHI86bdgaIKry09CIsPh7A5mm/OACOtf0X0H9stSjyGHumuuLpTTH19S+/iIs0cAScCQBwCMyOjWCSlqPZJNzjDPONI2N8CnsHRAmtJSR70Wfez+yvyO4HlSDIkA/aNi2jKw2f+r2dEL6wuLaK1lfoYAjmn9I96PGq7V83d/8jlQjtrdqYili4Bb8Qm02QoGXTA1AMnU3v/8HA01GQq4VtxLQOOkXA5zE8BeFdsQTp2nm7brgT54MBpHYCvYCNGP7M2ittkiZAQqAlwkTzFEv7Ng6U4DTIKW3exw85XrTHL+Q1waZixwayEHpt190t1LyG7X8czufVt0L6XaeA4wi/4y/BkjjFrLQr7ZWvXF3lgQx7TEFt0UhtOVM3i7OW7G25njHhy/FtHhWUSgTE8CJIp4mXPmGX52AK6sxqiYhpOukm4zpszobw5VOOJ9c1GmuQcsCZL3977cvXfTVs
 YsKjeEiZ
 lOQzKms+B2yosiXMfgk3OD/9hLXOHTQtrv9OuMGx/fHtgNZ/2otqmK9j4vVCcKQHzXVhJ+fhmTeW1jVtdtZuATejbSxDfjnDSrfp0FlBIOsSc+z8jN0nekEoszqkFhcpxTiXy2iO72I1R4waCQVY4tv9Tx3g9ON9gbBf2vZeC9nuE89i0mPUJVCnG1j4XH1zYvsdutSesHwnz1Qx27qw/I9fexw/+vNFCaN/RfGadwvDQb4CNXWZTO2NaF365pkM3Lx8HoQFmGzkSczrFCEA3FR++QZJgsuaxpxzggYRiMGNKhksaTkAhyEaUmWvLkHFe5GiKLLH12YD6JDbaOmQMCLUC2Esf8CAidGDSRkBiJH5G3fX8DxQvWjL7x8E63ca0TTLOHFCTrTjujQcd+NjUpzpGcfqplWuR6TJNaUCDh7rGqNjWj244kpJtOYHPiUodameYebw76pdWZqF0W/OZSfCgFEOZoELbnRxBQIgd02pACC5Kb3FHnPdXdyDR4VhJpucuI+SSJIHJGjpLMzmYFtt16fkT0jOUrAbqPvWChHHcfBnI0RPq9f8HvLsq4lU3iZKaxrALPj8zIPKHrbJTJW9VUQytPvcK6oUYtMxukhjvP89OO+hNpgRD8UzKYt1jGqPvntx0fEukA39h3fJkuPkYdjK/3Q3p4k+KSMGnowawEe+KpGF2ae4LscCAlbHl4+aRJCm6lJQGV0lVrQcF+OqTbk4B8xjbzT2SI+3zwoBMsai+ap32ipvPhP0i34W6aRBmWs5xXE3lO+QbT0e3Dbnj1whLW3mh/b6B0mbCdd2sPgv7YhN4fWOrHJz3qUfVn4HYGZHz4s4huRvwP+3CsQZSSM4OiaKb1UZOiYRIO2UPcOcNSepoVitq4sRu+C+aby4fMBP3PKMTlhwTJVydzdCwmIFyraYyjZkH
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
[ 6.1: Take only the dequeue_huge_page_node_exact() hunk, so memory
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
index f549adc0b670..d39cd5c582c8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -46,6 +46,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1343,6 +1344,9 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
 		if (PageHWPoison(page))
 			continue;
 
+		if (is_migrate_isolate_page(page))
+			continue;
+
 		list_move(&page->lru, &h->hugepage_activelist);
 		set_page_refcounted(page);
 		ClearHPageFreed(page);
-- 
2.50.1


