Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07CD2606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E12ZfgfY
Received: by kanga.kvack.org (Postfix)
	id 79EB06B07CD; Tue, 27 Oct 2026 11:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74ED66B07CF; Tue, 27 Oct 2026 11:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554846B07D0; Tue, 27 Oct 2026 11:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23C2E6B07CD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:46:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5E00C0A36
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:47 +0000 (UTC)
X-FDA: 85368834054.29.6095AD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DE942100006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:46:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E12ZfgfY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793116006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30qAFA6CCzSksl7jqcRR+D8NveKerXteOKC7Yb7cCqk=;
	b=wY9AaGXmlducjUAOvAcsDDaeM7tiSlHZz3RdWW5cTFg1DQC91/fpfmPVAH3DOcNiNs9/1J
	dkZQuv0aAkseox6RtKEGGPprRufflhWPolO5PkLsVYtwOl0tNY7oYC+rVmQU5cbfzhzMEI
	8BvvOXPNeWAZY/9vxRzoDOMbupfrIKs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E12ZfgfY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793116006;
	b=YjK6irk1fJs3Acn8DWaKtxzyH8yVLKey6F1ntWbUz2iCo6QpHT/xNoLcJteY4+aWKQqplf
	qJz8TBfSE4CDDiXptNlhIuqs72c0q03PacTv2gBh/TRhoXFuzO2WTMjqKDIgk4lwSU2CBC
	3B+T0XVSoiID/7DdA7A6RDC3knzi/8o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 369B943E58;
	Tue, 27 Oct 2026 15:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5F31F01825;
	Tue, 27 Oct 2026 15:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793116005;
	bh=30qAFA6CCzSksl7jqcRR+D8NveKerXteOKC7Yb7cCqk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=E12ZfgfY9ynMlsq27sp3+JPTml03yPMJtxySRvItV0bZeT/oBcKyDuGbdDrwJ7G/g
	 /3yTyW3G2KdkQEkm7nATNIpbNf5GGLbUPJ2hlys+9e3n/nP3DQogyfyN/8Ine0Wg8K
	 eTKj345nI26OzTolIvYj2lP0WeVmQMqVWvW7ZfSUBpJewvOxP/DmoDKYrpm8oYLaIt
	 UjUZ+njZG2AOdpBIw79hu+wj6ia6FcGeNNRRRfdbGVMBlP8eaQyw/Je33Fa2uHH12E
	 mANIpIC1zrp6cBBxBwtI4LvzIfFQmKD8Qq9zHZSgOZhdrvfPBJjWQL40tSdbjEoznl
	 zEA2ZqWTrwzRg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 27 Oct 2026 16:46:29 +0100
Subject: [PATCH 3/9] mm: page_frag: refill the cache for large fragments
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-pgalloc-ai-hotfixes-v1-3-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: DE942100006
X-Stat-Signature: rug4jmiepzjaenzk5f1hrz55jwo3otb3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793116005-755019
X-HE-Meta: U2FsdGVkX19Z+lmnID9nHwp72e13jXzVP8EDZTkAV9NgDC23bp60m+gV2MrvOjId1qsCO8DjPVGSR0uiGwpDf0sujMzxz1Cy/YCeeCsK050z4IU+2g6AltuN93l6X+B5IBl8KF4AoOE8b9o95BpYKfJ/MTMitbrqpnLiWX4Dj0a4xxV5iBoCYKqzrBvhXIsAJsIaQE5cHnPJXJUfAU+2dUlh+YNzidCDY7G09KqhNRtJEREADGu8FnYp/aWK3XH0dT73mj5YtLssx9SxyiuYM9otc7YCyIB+VvX1II1jOuAe7UnlU9JKQztMU7ejYk1d2xP0PA4a7hZg6myfmHYEFNA/aHBp852RaXXM8qGvtmNEoD09gl32wj+V5agK4w/Dk5++/2fx+aBUJ7srat3q5U85OOe/XIQ0K70CX6iMY4rmGwFQ8PXlfh4bLiWXIlUfDENnciq9Vc7ImqC/Hw4fs59U968iwM5e3wyWqPB17AnaHIqot9J+KHgP1nD5APt50UAS1rxaApAlOtYlF3kp8TftIuetM85WUu5blTU1RGA3+i0+fhfM4svT6k2CEGcJMwD6Djp8TgjrL3kjUDDYXqIEUdPg5uqSGhwZMI+4yvSXmtACz/RwLVKDZ2lN2v1LX9kUpXde7hhDkuc3kxpxQTiTr9XFWGUsQUvVJ1l2xl1pBDg7WzeYvfpS76TARnjXsxDg2+PpWYWjqCVenNJKb4DTYhAK7hEKT6zodgBgMecH97v79tQTEWkqsz46sRHtqK2RmVD5NQ7Iv70oG5hsOHBp9UDSH0oj1eZDzmkhCpZ7vnQbCeE3nmhX8K6y469sARPHLTi24MOqjJd9ZXl1UVXtQ827Qo3V4D7ydpwQNA6XiVqzJV49uqBi20IjFvFWI7Zy8za6ZsOk+AHj4AsXRBYj2K7OZVqV2MspoKDRnf3GrWBxMnCyHZKbclEGM6A7No/P3vg+BFHq3y9+94s
 a5u5Cyfx
 eQlRE4S0tar4W1FE/Eb5kITPpNSY5h6nY7qv9GXTKRJn5GuLF1fg8wRUdzIeUzr8kQFow+98OhacRqa3AavWBf8HtophHuezOnAv1ZhAthK7jQMX1kocrAUMzJgGyFWDMubkBtU5gf7C0TjhUN50tVTyGp80z230PUwAsezBav7gt8/c049VbZDQCku4Zj3QdpK6G5aNRHBj7q4Xut1ygK5s88yhzwZSeh6EEC3wb8n/67hs5cJIrhVrC9P4XUm7oMU3OeGsHApDPKAktmaGSa6i4YIEo4CKqI2k80QvwT56RxNHSX9XpWUvmhsnHrVBPKxrEo62aeEWQtE8MXhv+iAHPEseCBONfqS7LrKgI3qWyaQ4Y3nUgy9NIySqTEh3knrnvCfO+s/Dfv7FXOR2HOBz1k/6O9Qh4aqPf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

A fragment which is larger than PAGE_SIZE can only be served from the
32K page of a page_frag_cache. If memory is low and the cache had to fall
back to a single page, __page_frag_alloc_align() returns NULL and keeps
that page.

Since the offset counts up, this check comes first and is made whenever
the fragment does not fit behind nc->offset, no matter how big the page
of the cache is. So the cache is never refilled on behalf of a large
fragment: with fragsz = 10000 the first three allocations succeed, the
fourth one and all the following ones fail although memory is plentiful.
nc->offset does not move either, so this lasts until smaller fragments
have used up the rest of the page, which never happens if the cache has
no other user.

The nfp driver allocates its receive buffers with napi_alloc_frag() and
netdev_alloc_frag(). They are larger than a page with a jumbo MTU.

Only give up if the fragment does not fit into the page at all, which is
what the comment describes. The fourth allocation in the scenario above
with a 32k page will thus now proceed to refill the cache.

Fixes: 8218f62c9c9b ("mm: page_frag: use initial zero offset for page_frag_alloc_align()")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
[vbabka@kernel.org: make the comment more obvious]
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_frag_cache.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index e63efe78b7d4..8914437ddc51 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -119,15 +119,20 @@ void *__page_frag_alloc_align(struct page_frag_cache *nc,
 	size = PAGE_SIZE << encoded_page_decode_order(encoded_page);
 	offset = __ALIGN_KERNEL_MASK(nc->offset, ~align_mask);
 	if (unlikely(offset + fragsz > size)) {
-		if (unlikely(fragsz > PAGE_SIZE)) {
+		if (unlikely(fragsz > size)) {
 			/*
-			 * The caller is trying to allocate a fragment
-			 * with fragsz > PAGE_SIZE but the cache isn't big
-			 * enough to satisfy the request, this may
-			 * happen in low memory conditions.
-			 * We don't release the cache page because
-			 * it could make memory pressure worse
-			 * so we simply return NULL here.
+			 * The caller is trying to allocate a fragment that's
+			 * larger than the whole cache page.
+			 *
+			 * Either fragsz is larger than PAGE_FRAG_CACHE_MAX_SIZE
+			 * so this cannot ever succeed.
+			 *
+			 * Or the refill has fallen back to order-0 due to a low
+			 * memory condition. Then we don't want to release the
+			 * cache page to attempt a new large-size refill because
+			 * it could make memory pressure worse.
+			 *
+			 * So in both cases we simply return NULL here.
 			 */
 			return NULL;
 		}

-- 
2.56.0


