Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 408F6606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 07:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=t4ae7a2k
Received: by kanga.kvack.org (Postfix)
	id 0E8FB6B05C1; Thu,  5 Nov 2026 02:04:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0BE6B05C2; Thu,  5 Nov 2026 02:04:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3F886B05C3; Thu,  5 Nov 2026 02:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8F396B05C1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:04:58 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 648321C4332
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:04:58 +0000 (UTC)
X-FDA: 85400178276.12.5831834
Received: from pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.1.125])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46087180002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:04:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=t4ae7a2k;
	spf=pass (imf24.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793862296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4l44b+AwhAEl7Y2yYU1zn4HtQwsLDMpz34p1PtYCmP8=;
	b=f5a+uYDnAFeidYkASjTfh3+/jLJV432WXXYr2K4c1Frf5UN2ayQPumU+wlBHrkmwEH/gDa
	fiAuKo0mI3Z1C+eoVoY0AqDGwoyfWkuyFu1LVt/nhIgVGM0fXkyOU9NeSsWtlB0dXH7S6e
	pRWWih+MEgfc4l4102JgGKiugFOFK2M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=t4ae7a2k;
	spf=pass (imf24.hostedemail.com: domain of "prvs=762187284=mkbund@amazon.com" designates 44.246.1.125 as permitted sender) smtp.mailfrom="prvs=762187284=mkbund@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793862296;
	b=nEuidKv8ho/DWz8oLmtfcDCfZtNYg9fe6a2D0xCwypgFnhkGaxzxhMHTySUJpxOlBA91tr
	IqQa/UpBGSsKOyiOsZzfcYl1vdXirej30g4GHh+3AJrCpXnIXt65b1o/JsALt5wLC7cASK
	lH7sgLURU8n5mHdqZzFjxTaCplvopmI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1793862296; x=1825398296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4l44b+AwhAEl7Y2yYU1zn4HtQwsLDMpz34p1PtYCmP8=;
  b=t4ae7a2kHV/RgZ7zzdxyF55LlSiLM+oMQ3ajW9YgbaXYufhUP7Rvu25Z
   Sf+vucnijdDrn//brjwh5azIw/5dSC8HCHKSSSJsHV9zZEh+Prqn9IGXc
   MZuXVzhTqw3WnnD3H+sUvjNoFROwqgSMo83MOCEU1GPQ1I+RSs0TsO8cj
   3qsA9m6EShWbAgRsbetG3bWm8x+tq0h/Q6QktAUjT6YNYNZpXOUGKNp0m
   X5ICrkmHVbo04FobaTRD8zIRT1j0k/O/TdMEjymPMG0PkxrDwXDp/d7JG
   8UBr6fAaCJS0vwUloCcDtgtpBSb7HnTaOV03lMmEFq8JHt15a0u1bdvw+
   Q==;
X-CSE-ConnectionGUID: JwTQVVBvTEuV0LKc2KPDLw==
X-CSE-MsgGUID: SXXMfe1cQbW+BPEL5CX4oA==
X-IronPort-AV: E=Sophos;i="6.27,196,1787011200"; 
   d="scan'208";a="33172376"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-002.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 07:04:54 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:23408]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.15.208:2525] with esmtp (Farcaster)
 id e60c700b-b0ba-4d1a-b314-1637a485e3b6; Thu, 5 Nov 2026 07:04:54 +0000 (UTC)
X-Farcaster-Flow-ID: e60c700b-b0ba-4d1a-b314-1637a485e3b6
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:04:54 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 5 Nov 2026 07:04:54 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <linux-mm@kvack.org>, <david@kernel.org>, yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>, SeongJae Park <sj@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, Mark Bundschuh <mkbund@amazon.com>
Subject: [PATCH 6.12] mm: replace free hugepage folios after migration
Date: Thu, 5 Nov 2026 07:04:42 +0000
Message-ID: <20261105070442.3101877-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: cygjyo5kmdj7sdshsz7h7myd8r99u6u9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 46087180002
X-HE-Tag: 1793862296-805784
X-HE-Meta: U2FsdGVkX1/FevHyUdOvwaMYHxMB7hMqL3BZJlVIVPKUHHQ/qmPGjynZrSNWgbhYxxP9ZgKn5uFShNDSNkoGg6LrMkK/QkQ6/+jc7uri4sHWmoLF0nT+skwfbyvWODWZNTxTGDTCD6Wyxbdf6k/UEkQzdzmjfuyVcWYPgsAz/MoPaeF40qeQoXLbchtFRrTDo+D+pVsx3CE4SHotyFygZiEMg64XZ+yFnLobjDeulzl83LVcRP9silLOowD8cdsQUhqFnnYznjvtLWPAnfVQ5vuSNP77VhdphsvQyniPiKbGD4VT96fPXZkLYGQYq8tMUCBrqPujPkUOfC7mqjQcJt9oLOF82e646uia9NTHHrj4EHBnJtgV/e4wzrIDVNQz0qjWrmlEupxOEL2DbpwxY/lNKqQBRelAIvpr6OErInKgUtoLAk57HFy0me5PgUWU4L0StuHcYjNx0+CXsZOuIDFLtsWhK/eGwtC/8If/yrSjHWGH3vzkeutv1NQx8+BbnXmBgyCLv8vx6SHdrFb6vyv3eWyoGp3oL3MaonE4fznJ268W5ob9BKNyV5D3ZTJCTern2v9tFIwU+gWmy12fh6taJpEWgITX2eKcsrckhL2QYvWTIHHhL4aGC4JxCQDiir/dYtmd0iMD7BPeMd9/x5TkaK21lhZOjN7t1wv8XvS4YPdNyOZC3H/8I4bhyd+LYoPfGSDVh/rF/dXF3zYmVp5TwqOxZU5jBBif/DRXP/3/0LhMyxP7xjaCA58MzYnDT/Ljcs1QkyiaqW7TXlLq8dYWDNMr0qWkOTO/06HSKOjMl4tXA/3DRQIjn3jBG9iWfFxiTtfj5hR/YohQSsfalTnbesVd0t2a1+oJruz78z93XKXYcNQVu+zHt7LV4U/1jmGNmS4lgrJ+UfMG0UI9AHRN6gqH+0NIuznWdqZ8RZs+JvPFkF7Gls8StfuFj2tma7iHI/1zKOHgRo0LI+j
 HztrT3J6
 KY73vL9xbKyWx9EcqMehg9uUvprbz2KfjSpx+DeAYKUqbU4tU84aHwSsV3islauemWsqfEIUAXDFI5yUveYjJoFSD+3ETjFOOhCxkJHCs1R2IKYcP+OXQZ29Avmom6ccdNHigEvytavmRdQJMphWW4bS/aEUT420ncZobzJI6btLb++xDlZh4si/u0ZqV4etSVZyGOjv+oN5/nefsxXeOft9TWtXbiMy8/fRyD3JjJysrlKmFaKYhfyjvOjAseH56APYFH7pnaXlnP/ngwf8zJuBZ6+JXR/Zt3m1QWlSox35eSsEabVTSErQBvGH1pbHz3+7Q2Q5mSo8+AoFABKIqA34R1z2iPXWOiPJqBsYFF+PotZaDoKxn+4FoO62wHqYYDvp7O5p2e/3ajq/pyUdnnhqho+rbjfY4PSMhon72r/EPFMVqas6IH3Vz/nx26ydIzrTFYV6wmDmHPOB3N5IuaqC9qIr/hq14I+oUCtezMm16lgkBk6z+uVZWpoaQxq4Wz014U58oOKBMuwhX+xmPOSH17na1WqrWWFsexHzC/Svza31llM80+1SLSse9nc9qcQ6qQq55PI+Bdg6yiu1PMy7btazSpmTqdf48tDfILCnK+y9VNKi3tWrcuFKksM5BXu9E0n3XS9s/YJczXey2G0Gm2U4b+r8JJ+nMvl4Py/uV9WL/6e6KcF0dKfLn17blOuEoH9XwvwTk41ePW96pEYb30hTOUrir3zN0WNeFkNkgCerwd/RJZqwtTOJilNcdQvaPy574vobxb+OGigUgksZNDn969+AfjFnlmRjiTOraM76XSwZAv6XLQjqCtBuqnX0DerdGwpZLTI2BBw4slbOZR0bWXJjP2QMej5a5fYaV3dUL+20jixT+WeDiIZLipSNCJ5U10kRQJ3yQ3X7IMZQR5rVCpDWbO8zW
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
[ 6.12: Take only the dequeue_hugetlb_folio_node_exact() hunk, so memory
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
index 68e0cc0748ca..b4c6c926a71e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -48,6 +48,7 @@
 #include <linux/page_owner.h>
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
+#include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
@@ -1350,6 +1351,9 @@ static struct folio *dequeue_hugetlb_folio_node_exact(struct hstate *h,
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


