Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 007D7606A32D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 02:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EKPM/T/+
Received: by kanga.kvack.org (Postfix)
	id E89896B05B2; Sun,  1 Nov 2026 21:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A246B05B3; Sun,  1 Nov 2026 21:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D76F46B05B4; Sun,  1 Nov 2026 21:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE6186B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 21:49:56 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D3D7A0BC1
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:49:56 +0000 (UTC)
X-FDA: 85388649192.28.5996C8C
Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F22D20002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 02:49:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="EKPM/T/+";
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.120 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793587794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsq265Y6LzBmkOdoymoFNHjnl3IW2ovvlI+9AwjjAuE=;
	b=VHWVLVLmUolYmoyM4p2AxcTgWx2Rkm6H0+nxhQ62jkojgdy/bP3VIdgDPWwqzsqiYy3MUA
	P5xFtjJ/ImYULkT8lIOgHLKmhkkFwX21WPf1SAhvQXUuKMT03X8OzgxkUqIRuaTR/sj11U
	SVPSl42SR+U5yblwclCIgoQ9AJCwAtU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793587794;
	b=MmuWgZbUG86dLLYuYcV10FMOICz5rXXAR8x+xRClX4CXsN2ll4WNuLDonvkKjFUR8LysXJ
	+8UeyKZI7/4k7+usvZbbUTnexTmsOLks2CzXFQhiMlVt3F8wTFFKQ4dghOp5gFSiRGdT6G
	rQ+m5uP8ECIlqiOP5dhEtoigL8GbCYg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="EKPM/T/+";
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.120 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=j8pQESwrLrfT9Kc/KC2iuBXUJfIeLEImyATEFj6zlDg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793587791; v=1; x=1794192591;
 b=EKPM/T/+fyZPfUGce3JQha20CDV8IN2FPRNcOmK0DL8riFkgbS58yOw2GC1oidgq5ierEgkF
 XcvtGSINu4IDEsSUidFOVkOQFjDSmAHdqQUuVt7TXSNCvnhcc9Jm6Ji7ZfAodvxAmmRvBH6KPOp
 BfOCPH3lpOtabQbt5d7mmxSk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 348b45477b4b0c16;
	Mon, 02 Nov 2026 02:49:51 +0000
X-Mizu-Trace-ID: 348b45477b4b0c16
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Mani Tofigh <mt4022@columbia.edu>,
	Zi Yan <ziy@nvidia.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Chris Down <chris@chrisdown.name>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2 2/3] mm/hugetlb: Preserve persistent flags when returning folios to the pool
Date: Mon,  2 Nov 2026 10:49:09 +0800
Message-ID: <20261102024910.31486-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102024910.31486-1-kaitao.cheng@linux.dev>
References: <20261102024910.31486-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F22D20002
X-Stat-Signature: snkihji9ktjc79hars6ad68msi9344tq
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793587794-509246
X-HE-Meta: U2FsdGVkX1/WbD2RUYtOf5sQ4WnjkAdi9HutNberyesAQSHt2cMj6IxyoitBi0b1HrFDiUYC5MNjboqU6SKmGbyNNyYKkh/VuUwFMP//Kkg+OyZAZPgfXaYxcvAaE0iu2uruh5vnI1Fl7EHDzvlh4U/1YlVZAHCG2iw2GwxDqQK1ZyUs74nrM2fQKDEbU/p54DsWlU+u6MIiIMP5OHZv6fpyHH1CZTwFe1oTrpwEpF8Uhe/fh3HNZydz4O2RQjQdwMc52/3p4VgimeZo0bDXI3tTTvAdYtBRZ5BtIkEMr5waJ3uf9DdPFU3RZTogz5KrQ1FckRrR1p3/UGZNraTbh0Dg3M8ysJDJ9RVEx2/IXXWf8dgk5GUjxBpF04EzLeSimpwzk2Bl3U5UNbnrG2428vKW2peAEDmZodO29El0GzZ+L4+g6hDXpB9ap0Q5jQS664cpXwxEA2ron4eblMgr06xDKI3VEyVNrs9TYgNHRe1RfIHYFzXoLHAbv4AGlmhGtchh0w5nxJ+i1dP2Jc26ZRbwgWlM2pL2+dm0OWiJDKM0xPid8Y8Jq3qLX8p3RcjIBTBRaiIcH2q91lOQ7zqBPqxc3A3M1y3x/ihBh4KvufQ0GuMtkbF5RPoOueIDthey1aXPlDZ05EnQhN9iyR2lQtfRCp3zL91QrPY2SgtoqjHCPYWr+2fDl9jxczdALAVSpUK1+UTqpLUgA3OUHtz6kw9mo+bkDyz+DfWcIzGqHHW78yFu45XOdvLqbCn1z6bF+S14gsEu+b1CATy7iPQBy/qtuL21RltACX3TqloiW9q3zqQFRF14z1WxmB4oPsQNmRO9myz4PkuvK/W6SxImZuV1iFcyHjssfZTSXggk+i2PtuqC7n5vgr5MTTcjCSpi/LcNR0BdAKeQ96BdqkDQ16BjbWPYnF3kNvq0Tf8F4qNEdi8SpUvZ708kAh/n8Ju1uccVBYsgE1NUgRSXHwI
 H5OFy9Qe
 vsIdWwDF9yJoSP2PZpmHHZel5vcySGgqPcgG5rPDzmD9oRMJp/voHjlINUSyA0s0FfeF3bABpvG1rRjBK+xGUhiZf+uwoXON7jJxToaDC3OWuemnpjZe7n+er5SFjJ6AnueyaMtaEL8Z8EddZY0SNmplHatNBtBBRGDHt3L8OqZBStlo+1idr53IrMask/W0Dg1rVdLD5pqNZe/ZxTgUoZvOVJl1XHopsuddnR9GihgA0PD0UxL8/lSTJWErtOKtifLKpNoJxSPW61uW63a+hAzjplYBU8XjXbA4SE9mBUUy+9fohkXLz2dHPkPWtBTeUwmkW/s3JVPao/7YbiFD9JD+o/ptCBw6ISeWQ9DrltU0IzW03aZGPDVRsFYXgag5o1ZYgcu1TiNQLxrulfHD7+FxthC0t9TaC9eK2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

add_hugetlb_folio() returns a folio to the HugeTLB pool when vmemmap
restoration fails. It clears folio->private and restores only
HPG_vmemmap_optimized, losing other flags that must survive the rollback.

Clearing HPG_cma causes a later free to bypass the CMA release path,
leaving the CMA allocation bitmap set. Clearing HPG_raw_hwp_unreliable
loses the indication that the locations of poisoned subpages are unknown,
undermining the checks that prevent freeing or unpoisoning such folios.

Preserve the existing flags instead of resetting folio->private. Callers
already clear HPG_restore_reserve, HPG_migratable and HPG_freed before
returning a folio to the pool. Clear HPG_temporary in free_huge_folio()
before attempting to free a temporary folio, so a failed vmemmap restore
does not leave that flag set on a folio returned as surplus.

Add a VM_WARN_ON_ONCE_FOLIO() check for flags other than
HPG_vmemmap_optimized, HPG_raw_hwp_unreliable and HPG_cma to detect
incomplete transient flag cleanup.

Fixes: 161df60e9e89 ("mm, hwpoison, hugetlb: support saving mechanism of raw error pages")
Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
Suggested-by: David Hildenbrand <david@kernel.org>
Suggested-by: Muchun Song <muchun.song@linux.dev>
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a008afaedf9..931ca3a30773 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1443,6 +1443,12 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 
 	lockdep_assert_held(&hugetlb_lock);
 
+	/* Callers must clear transient flags before returning to the pool. */
+	VM_WARN_ON_ONCE_FOLIO((unsigned long)folio->private &
+			     ~(BIT(HPG_vmemmap_optimized) |
+			       BIT(HPG_raw_hwp_unreliable) |
+			       BIT(HPG_cma)), folio);
+
 	INIT_LIST_HEAD(&folio->lru);
 	h->nr_huge_pages++;
 	h->nr_huge_pages_node[nid]++;
@@ -1453,9 +1459,6 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	}
 
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
-	folio->private = NULL;
-	folio_set_hugetlb_vmemmap_optimized(folio);
 
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
@@ -1743,6 +1746,7 @@ void free_huge_folio(struct folio *folio)
 		h->resv_huge_pages++;
 
 	if (folio_test_hugetlb_temporary(folio)) {
+		folio_clear_hugetlb_temporary(folio);
 		remove_hugetlb_folio(h, folio, false);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
-- 
2.54.0 (Apple Git-157)


