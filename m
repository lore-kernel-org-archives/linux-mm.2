Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26D8E606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=eLkrJGok
Received: by kanga.kvack.org (Postfix)
	id 10B196B05BE; Thu,  5 Nov 2026 02:03:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3696B05BF; Thu,  5 Nov 2026 02:03:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01FE46B05C0; Thu,  5 Nov 2026 02:03:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C75AA6B05BE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:03:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA08412091D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:03:50 +0000 (UTC)
X-FDA: 85400175420.07.C1B7FF5
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7113E14000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:03:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eLkrJGok;
	spf=pass (imf09.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862228;
	b=nDk3McU2GY6b754l6wKjgPO1UgkQXoCggTooDfMB9C0abpEPEY+/vRBDPkvJwqyPm+hY6g
	1ldvMMlr1aSE+1E05GCxMvMpabzqJYFgC6uPQesN16B8toqilvve7BURQGnkcA1EA0AWWq
	e9He/oxWooxGpKjLI/9yAa+uSxdx4vo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=eLkrJGok;
	spf=pass (imf09.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fvQJZD3XLmj+V8GZDkyRwcnTerFRSlnUb09suoHH/o4=;
	b=i5VgQSdr5NBT74EvcZMetlh6P9xTl67lCQ7fo0KkibGEe1zvnnt3dXYEdjixOJwNZHDriZ
	wnrxzHNS9PhKmhEu96iHZzvHeJeXB88pudIto5/Ei79ZRjm2KMcOtVepdIcx3ZDL/xOUXb
	5VfeFyCBhL6FTUI/JZC9jMsksbSqByQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793862228; x=1825398228;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fvQJZD3XLmj+V8GZDkyRwcnTerFRSlnUb09suoHH/o4=;
  b=eLkrJGokED92tkOJerFcuCN5zpO+a+NYJ1FpZzSB/k9NxT66DrxPMG4L
   6CsDupRVMiA+oDTn6N5gRUNrbP6bcLxiCMlqkzc3r2ErK5VL6r6uh+BVY
   2kSbj+Al3yDABfm8lt0nSONT4rG/WxCkvrJCDpbno0HVKpBL96Zr2Lxlr
   uMrEN6ob9Nwio1lpPv0ubzNWN+ggKwiwizLxL3Md6qJZnUX6AYu6S1m7O
   yUNFvFjNtC9pyMk+x2OXjqRT27aZlGS9Vfa+DT7yEpJwL180cMeCHEoRH
   41S8IT4+TG3+CxrmUtQUM1ZLsosDlKk8w3h8psARMTZSLZpJQ72jzIZrt
   w==;
X-CSE-ConnectionGUID: g+K16sRRR0W1NVflLnpqRQ==
X-CSE-MsgGUID: cNLdWNkkSTO0CWOPDLBthg==
X-IronPort-AV: E=Sophos;i="6.27,196,1787011200"; 
   d="scan'208";a="33031176"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 07:03:46 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:2395]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.21:2525] with esmtp (Farcaster)
 id 36cb82fb-703e-4a8b-9c69-0f3d4ec523ab; Thu, 5 Nov 2026 07:03:46 +0000 (UTC)
X-Farcaster-Flow-ID: 36cb82fb-703e-4a8b-9c69-0f3d4ec523ab
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:03:46 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:03:46 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <linux-mm@kvack.org>, <david@kernel.org>, yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>, SeongJae Park <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH 5.15] mm: replace free hugepage folios after migration
Date: Thu, 5 Nov 2026 07:02:06 +0000
Message-ID: <20261105070206.3094675-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA004.ant.amazon.com (10.13.139.19) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: nxq5ont4j59n6fneteqh6ny15cmn981x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7113E14000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793862228-709560
X-HE-Meta: U2FsdGVkX1/a8xyjucQolembLE7GZTqqxhqZkH/cQyxEyqLOrOChu20rs74XJX79PMywr91WLAx79PEOrkNo1t3ZRnh6ajPVOYz1TQI8UTsdJLMpSovvMRyW0ubhrbHSiP7FV8/ABjscQMw1GQ+1Iha/nKx54RjLmwvCF73dims2A+KftZWhA+i4vK0CiOg0ldUjD+HbOq1f2uS44VI+mfZ9YMX5BVC08ev5c5iscFAdGxExNBEeSw8VtbcJAdQ8/kZAe/q2JiVhKuiXfHvKJIkTpA4B8YO6O5Te8FK2LfWxUxW8d1D3XCy41AtZQ671KudLoiOuXz4IzmmqntIkouzA4hnt6UcNNgMDNWYMmMgvc3M2hPSg/GRx1jUA9eKwYP74YZTMQwiOEwvI1sTT6wTRGssVrpSbIZASksgX+TybzyW/eo4DVRoPnsmNvD6+4hprp/QlWJikuwXUz+y/gdSh87aKz9l0Yai0A7ioGGHGAhfmOM8J9GgsZOGEK8cJM5j5i+z02CK89JvDG5DWYOVPVdQa6FcWunEfR6j/1+9uklM4i0N8KgPBQ/WF+gBPdVCAQlCSzO+fakAmVsey8+TUbSBwQjVfAz1x7DjZy1jwp3erixbZtcMHNGa2T90Pe9PhFCJlYNFYvI1Ri0KiYdZiQMUhYvJZpiPJl54MdJMvoOTFgDPAxB/mEBrot2fodNGEH/7BKdFfYPu3eFHfFFCTQqJT1SUE6dfacFBZfsN/t8x0CWptGvWd+IKg8Q48wf6BfCZT/YTbnSXiSuI9xjjltIoJNt4VZttQH6xXdiPRAQm7chAyl+MjprV/nVoeYDP/cEjyHE5XJJTI/F9E5I0T0AN9UhiX46ySA+rVyMpWL35NkxuGW928wTHqjm6WpDPLgzINqaqMdczyzw/EqMYKh5MwZ9H4vTbcNqxT701sqwuKfmt3ueuFFwoRMvmmT+Up5aRWVyj2bVDzLqF
 F2Fs2Zo3
 Dn2svOxpHmhj9iAdh310bzPBJu59frL97B7hFK/pBg0bo1gyDI7U0rElNs1ibDpFenHB6ZzML1bXqnk4OEPF/sj7pRp1FA5lt+4peyyvvxgr8Pz5AxIuRUweW2BsJTmTbbuoAJvl2DgTOe8jjAOhuSeHvP7qzasv47tFnaL0ejSM5T7qphLlrexSSFoZi1TrPRbCywJVIMAzUtJwSl7JhboSgqzMnGiBficzdeLNhuzTjZ7E7LA1/f8nUVO2gSndGwgHaW6vcNUVyJSV8fwYCRJowSyO8HiJ5DttUoErhEoBmXyN9q8cHweGtUL2kOv17cUdCtuJWqiuRgMURaKPYCPNbosLRUu53qiTGcKmoDMDMoEBcFcPNnfm3QixTtQoPNzEzasp+g+GOa3BRtqhThZiNV4YmZ7NwtmqKmRaEa9EK4SYjC4aSHDxF5ipdrHIJ93FEOIH/h6DtGjAJu5Tpy2Zjso+8wc4NKwn0s+yGoLJsfzW4OONRDcyltKP4am+1K/kqJutOmxeuLNx8MM9in5wL1a9bMB+qRzdzq6PiYM3g8suUpSWAgCzqeoAxcHqA74o+NP/Q4jC4pKVyzmo8AmQXZnXI6U7WBMhb3NdzESbaPpLEOQWurSles2KRHV3gxNCXjz3IxeUy434JRwr+tJwM3CMIk0XYNnlBgUktGxv2yFKH2j7pYyRwwYDpYE9BB/8pCbFFTeW0sNZAK+kwFeojJxAAG7MZ68R2m55NvTKvUKVjRhGHj3MTt64Eb5Dc8a6Yv9MlbAQFlcNCwYY70QKgl9IWVIqAorMyrXBhGGTj6A2PhntauptW66G1fo2EnCoQRf77GM/nY/j3yojMlK90u4nr2/rXhO5PZbcfqo6noMdbtBon/2DfbdttcsNQh0uNrGmKYC0i0t2ZxqvP3XnqBA==
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
[ 5.15: Take only the dequeue_huge_page_node_exact() hunk, so memory
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
index 947610e37a33..6df31569ce36 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -43,6 +43,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1095,6 +1096,9 @@ static struct page *dequeue_huge_page_node_exact(struct hstate *h, int nid)
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


