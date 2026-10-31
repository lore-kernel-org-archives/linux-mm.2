Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63683606A329
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mz4vjtNh
Received: by kanga.kvack.org (Postfix)
	id 7AC196B05F6; Sat, 31 Oct 2026 05:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783A36B05F7; Sat, 31 Oct 2026 05:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6750E6B05F8; Sat, 31 Oct 2026 05:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A8906B05F6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:52:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB9B01C4304
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:51:59 +0000 (UTC)
X-FDA: 85382455158.12.AFD1C68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 036CB40004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:51:57 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mz4vjtNh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nShE2+EwYjVmjC/lA8OKz4kDZ0zHLwWOS1pXqI0CSl4=;
	b=2fsThP+ILHiHeSXGlPAi84zk52PnyJD0t0Z8mTLcghRSAiKrffg/MDCpQ27bE6rFtlk8G8
	EWsPZuJOS4WcvvyxhMUpxaTeP2rNlHwDSQjh1ykDyfbHCE7AgnQV33JWIcAmCH4nBGmf5b
	b5bBfmIc2ifPATcG6jzpu9zJ4rMovl0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mz4vjtNh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440318;
	b=2wbTpPlKoXB7LZO532jb/pVY02us/kENCfEoLpuCkXbeOZUsg6H/mhKrJoqQ9R97ntnuDZ
	1+VVVRjp0SmQVEmWOqLef1OdFEEi+7XHATsqJTvU4AM5NwPTnV3i1prsvQ9gGpP/u5WOiS
	ci8nxxR1tWSbAAtK8EgZuanW17XpRf8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 421BB4120C;
	Sat, 31 Oct 2026 09:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DFF1F000C1;
	Sat, 31 Oct 2026 09:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440317;
	bh=nShE2+EwYjVmjC/lA8OKz4kDZ0zHLwWOS1pXqI0CSl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Mz4vjtNhUqGbGKHRoGXr9r+sytHCDgRAxGO/amotCyXaOFqxF+1ep6MZmFH4ILyUf
	 W0soiCoF85GTYjDhg/9mZh6VMl80OhnxsHPoL552tTLwh9HXYOi/GiwLwpAiF2B8v6
	 VoRkh84fbkFxfEXDlZvUG5VkZQXlGgjq3C1gM8+TqM+BVpxlZsZuu/LxsBtRUhg95t
	 hLzMpxbrGJVxeFzQgGU10iiSU+q4upIDWG/+xOTiXd2Y8NSFyVFl0CvXr4j6iUn8Id
	 kOl8vDpFjXBoTR1k+RutPsfUG9kpI0vTOMC1dK9G3s83qVgo0bmN2ixPWHRJcO3y/C
	 bSgnjcBQSyl0A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:14 +0100
Subject: [PATCH v3 45/47] mm/cma: don't release CMA pages still in use
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-45-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2309; i=david@kernel.org;
 h=from:subject:message-id; bh=571srl9637tWygfCtNc98notNFslusDCyOEoBtogIYA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+eNiHr9s7IJUETNvCvfhoemf2I7a39qzNyn8o+v
 ZvqujLncUcpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQATMS9nZGi4eqt7tvCEDa/X
 PrzjlHcwpuPD07izPb1PXZduX1S4LjmM4a9s/k2VDpvdc58sUZiqG171ZIX0iqVhd7+pGJmyVm2
 fuZYTAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 036CB40004
X-Stat-Signature: 1oggj4u6n96wnn49qpyfet9zybre3q7o
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793440317-833240
X-HE-Meta: U2FsdGVkX1+YwFKnKgCXFB5mAUdv50SGd1JyXZQS2rjCEIK4sW6Svo3SXfNlyAf1BoxpNbbEIGjtqwYNLssOg+0hliQOf0wi0W4jqDnjVFCu9e0NT4HO0OJ8sYJogkWj4UeCOPRTYsLIfJX2CnaLQk7HBlXC6NXK3599wVvEL6/B72XciqXkqr0vBkcTFDCWWQ8KJlVY2+4jIl9iuAWJfCr4DCnHoIpNIhEvkDBKqC0lrXmHzGHqywRDxsPoZ3eLvXKzQp6C7ccRR1BnHCAEMFO+UDHsvROJvK0nyybUC3BqeK4U2X82lHv5ldCfRgoinwTbTDuUNbppqIReTaievj9OUAPnKv0uBxmQZ1422wesNSvonu8iNkoluGk624J8QC848Pq0Ny9YW0GmiRTIA6RJssDLBXo3Z6U8cMMXFUn6t/Wb0hZWapumbMJfMD003U5gDw0Z+yVxwxAzFsKW8qDHwy7heBFKvuvD5zqjratR7FagQmAUak+x8YYPHzK0elPWBKE2gZEGm6HvHfOg5VsGMCLIoWBk6XaTvytTeFlMa4DMKFDRdGPaQwdyxMLRRLvK7+Gcmp/SfbN8gAeB3eAacZuyfetcYARUickrfeveWfkbw+LY+8GiXPAhhI/SPS/IR8AmvbKpeSjDH6u10DDKSi5NxV3XIamm7X4+9IBGftJacbWypTy7MDdYLkYcTDeceFaqTwMBTvu97Ez3BtM7bFB5En6PSRXavajI6yohIJY2Xo4qLZCO/s0FzXrSKcue00wNVqzsR6T5bkV90lE7Z5tNdYvJSOumAvzGmuDJygkAtVQtwwUjaFLA/vKIb19HZwjkkSqPmFGdmJ7XqsDMWNsfqVtbPsy+7RCUrGV2+5CwhDqdpNt+U1fONjIet818v06jv+btRJLh8Ia98K7zWm08APOCEpUpoUhVElcykhN3nWsYswyOWxVXXyfXY7UcP0HBnhMP9yLqw34
 1v1muPDh
 uyJdAfdSuMqiuItwxfMY5HFdjTdFZ/q/zZUzDQPRF2JHT1uUbfteCY3CVbzE8sWrAJ/vxwSZSKfSytYxFemOeoV2AY/NFjurwDDvHD7C16RtJe6kTPMQV2mjXo80ocmdAkqnQ7P03gEtfhrftocxVkeRTTKvy5sSsywN52DTU8ovJFQNRJGC+k3t2wp8Zx2vxdWsoETxdkK+lx9oVmjOPpzAIz9ZnJxn7sE8zlRq+rwfXi5NT1AZXmsRqjEiMliKFCZw3T3xco3JmZxz+oPobxp1q391ereWAlCU40UPh58yF+i1+nHMcSi/RTB1YZJxaqZbQxyy/SzRxdOnVQaHPesoBWiolHcnq2KEPMxr3dk/j7C/nQD05upcxrLdll4kmrxJLgABFX1obmpW4M80KWfvsIEt0QhmDcDyjhUgZEmRpz4a3DIh6H+6oGsUQR4xs3qHkLY75A7n8luO9nx26Qc0J6dVimgQ8EKuuCWIsD7Aj4gLIIK3W8BByMz14oxsYkivultHO2X4JaWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Rik van Riel <riel@surriel.com>

When a driver calls dma_free_contiguous() before quiescing DMA, the
page might still have a reference from the device.
put_page_testzero() there returns false, WARN fires, but the code proceeds
to free_contig_frozen_range() putting a live page onto buddy and clearing
the bitmap. A subsequent allocation can hand the same PFN to a new
owner while the original holder still references it.

A concurrent put_page() that drops the last reference between the
testzero loop and free_contig_frozen_range() can double-queue the page
via page->lru, corrupting buddy lists.

Avoid the corruption by not freeing a CMA region if any of the
pages inside are still in use.

Make it explicit in the warning that the driver allowed a leak.

While at it, use page_ref_freeze() to make the semantics clearer and
switch to pr_warn_ratelimited().

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Cc: stable@vger.kernel.org
Signed-off-by: Rik van Riel <riel@surriel.com>
Link: https://patch.msgid.link/20260811132045.5f114772@fangorn
[ david: use page_ref_freeze() + pr_warn_ratelimited() ]
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/cma.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261da..871f95c9ae9f0 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -1020,7 +1020,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
 	struct cma_memrange *cmr;
-	unsigned long ret = 0;
+	unsigned long leaked = 0;
 	unsigned long i, pfn;
 
 	cmr = find_cma_memrange(cma, pages, count);
@@ -1029,9 +1029,13 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	pfn = page_to_pfn(pages);
 	for (i = 0; i < count; i++, pfn++)
-		ret += !put_page_testzero(pfn_to_page(pfn));
+		leaked += !page_ref_freeze(pfn_to_page(pfn), 1);
 
-	WARN(ret, "%lu pages are still in use!\n", ret);
+	if (leaked) {
+		pr_warn_ratelimited("%lu pages are still in use, not freeing CMA region!\n",
+				   leaked);
+		return true;
+	}
 
 	__cma_release_frozen(cma, cmr, pages, count);
 

-- 
2.43.0


