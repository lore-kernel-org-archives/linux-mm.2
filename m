Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB1C860A262D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GauLCy/1
Received: by kanga.kvack.org (Postfix)
	id 587F56B05D4; Thu, 29 Oct 2026 16:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EEF6B05D5; Thu, 29 Oct 2026 16:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475D76B05D6; Thu, 29 Oct 2026 16:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 119356B05D4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:44:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98048C04ED
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:38 +0000 (UTC)
X-FDA: 85376842236.16.587438E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AFEF218000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:44:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GauLCy/1";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OmrddnalYvKzrQnN9N4Fpu9NVAES2TsOMe4SsI3z9gU=;
	b=NujfvWXKDxPV4YwGmKonTDlko9H0S+xlB6a9Hn/gntY7Cisg0VWVx9Ktiln6yFr7Ichrnd
	zE6YYMcgeSy3Eh6dJm+DyUHIqp5nnb/RSvNILOT5NLi8ad3qPX+zElmwYE0u85Hpwk+Y2d
	Uwq4smTVQTQ7Sno6d3yNgcjiwCmgvVI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306676;
	b=4oCJo9lv5cCfn+aP5Fn5aTRDiRG9eg4/+nHoJzVDfNB4bsIOo8RBo01MB9EUcUYO/s1B1U
	gB63tjMJPCV06UlUwH3Fe1I6jvUyi4/fKIqnaDACJGXeAkq+mrg9K7dxLu1MLkYBqfhF+4
	+gf8cN2AajefaPzIp/T6c4+rTAUZCso=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GauLCy/1";
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7B8541082;
	Thu, 29 Oct 2026 20:44:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B00911F01825;
	Thu, 29 Oct 2026 20:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306675;
	bh=OmrddnalYvKzrQnN9N4Fpu9NVAES2TsOMe4SsI3z9gU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GauLCy/1HrYbdieZoYJGY/PpIUS1vgONUu0M4PlXJvY7eY+GegQj06Bc3k52Nn7Cw
	 5pUOiZmQPSa/agrZVJmrfiWcTl/MEWxkZ9UQsk7lluRie9slFArS3/SevT9Xccdva3
	 jp2ZFiK7k5Rm5+WgEwWwD32w960RLwKV1pQDqkERuQqbjtkTQtpbzWr7jdja43hl2C
	 c8k7J5I4N2CU6YXX6Fvp4i5opY3LoX3l2OPr87naVfONU+oHtwZSXt5gIoOIzHgVXo
	 jtFFykZR1o4q1kxv0399ek+IcViDhuU9YWAlcP+xsYEpMNrWrwGCMJzm0kwU8GDd9N
	 c2NA3KmLJdFDw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:40 +0100
Subject: [PATCH v2 45/47] mm/cma: don't release CMA pages still in use
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-45-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2252; i=david@kernel.org;
 h=from:subject:message-id; bh=3kpfFp5NOxLKJV7MN0qgqEyHjOOrTqFsf7HE3Qur7Ks=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+16LPZT4EOJ2H3DwG0neWorjk3wfGRVsoy7nXl93
 YOjzLF9HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzk7zaG/wGvIi2+nrw7edI2
 i513/4c0ZS6asqr28e2KUp2fNmp7rUMZfrPoSJ2ovysSvbya44cCH9+H3rqFRjUPV/WUWk7Yv/V
 nMCsA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AFEF218000B
X-Stat-Signature: 7duxx147x3h91xy1sybmdsf6oemmp8ni
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793306676-484773
X-HE-Meta: U2FsdGVkX1+X7QmFv1Gl719GUaQLKtz8WVeyx+hGNSVa13l3gnr6IAIolEwtq9wHv5Mhwb2ZyErBeo0VtD7GixFTL+y3yDr0ANSJT7exqxhiY7vffYrg5Jbfqot1miWJRVGOPM/qh1x+h87syT+yhqYxKpmsA/YaU7nkRtESUD8qLWBXu/tCuGzQ/edsIaZl2w1zxxIWH5wEjS2AvqfKVgaeFDE4kDWYzYEhsuuaWTCm2GAzhxE+FCvsjgJ5I6sHVPWDNCVPUi+uMYSidxSaW64yYf5SwrRM+6cPImfB5ZXqdH1CD9LDXrAFNPNV0axTGUmNVZ7vNltesDkah0QYrzwvmkvdIQ76qKnYHcj6jEmy+s9Xc6iP3WVmKSkPmjyxMYzFX9sMVweNKHWjA+9nzN3KmjnAx79BtfDf3RLxcytjbNFRf3lJyVJbz1ud7XrrBu02QpSsUgndLwOogO5SmQBxxSSHEK8xwymup3osanD0qG7a6cWifzn2cKQqU95yNr2XWqY5Fshv23bBvZQbqjL41UH1IYYObxxBNnWibxHyqi+KdUPe6atWmhWoGwk9+GGBVftU4ztWCnpbxvtcfX2v+9CT7Zj6hjFG0mUMd80Fc3Dp6goinncc38/+m+dAqLKCmRu5jefe7dyVGnxv8JMUWu+eY/WIBcvXb++dCrqfsWgH05R9SdFTjQkgR/4F5OM09IaRnN3S8/HWe6LQlsG125x38R4L3q1cipk1UnpKszG7mq0X8HQ6xtFuYWuHYanHPCLFkFMx/sITjtYs60GtmKVlvW9UEoTLxKpvvJtYPXgGPWx5bSdKO0BXnNNkt8Uk6mLzsQufkw1/kQ5XFdMigiusSJccKGQlgLETmfxVeHTMLMrOBsve2VD1bxi1BFOszsnbwZ5FgRTngEqmwxsRAfKh2G40z6uclv5+f0OTlBf7TZ+JXnWjpVWl057YSWPGy81Mu+9Bj7lxhLB
 DkK5ZTfq
 qKgoQ+hBBZZ098vyhkXIDcpK2+4QZkMk7WSMDS5ePtJQdXGk0UpG0ymAjELUAljczEweMSu7FlOaeYQIKdNQjr2h4Fr2YoVeBtWcCdht4VluT2JkqMkzHsYHzS5c/ga7KDk1XWS3EFlgDewF3tQVXn621UGHfpQU0tK67gIAGoitwOJvuA/JI3XI5vH1gUQVVbQpAXkbl3yQiZ3A7ms6pNPVPHJpQ8KP6VZ9CaQmpL7iGw3jvR02hb86VIRFPwcPeHKfNUKtDQnZeGL+FEtMXMr0ItGdxdsJg0iY1JEGGoB5RE6B8U52yVkjVD4KuZx6e11KWL/oBJUaqCnYPVvWeDGGVQpCnkWE8OAN30Ychz4r4GGV2IRI+S0LbkReBDgDg1PpVrYlxBHjIM/zo+7SI3n/qb9A37mZL4MEnzN2smngG/SXvsx+8dGVmXec7jzIjgxFlVPi6N0XwGL1wrMQddfAheQ==
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/cma.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index a10ea37a261d..871f95c9ae9f 100644
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


