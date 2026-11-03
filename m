Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E7EA606D812
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HmV43mOz
Received: by kanga.kvack.org (Postfix)
	id 5568A6B05BB; Tue,  3 Nov 2026 11:17:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529546B05BC; Tue,  3 Nov 2026 11:17:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4677B6B05BD; Tue,  3 Nov 2026 11:17:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C76A6B05BB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:17:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A96891C3C9B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:03 +0000 (UTC)
X-FDA: 85394311926.25.F4F5C04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 35FC22000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:17:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmV43mOz;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722622;
	b=j1cZWOR3jIPBO7vVSUjWxTeq3eBstjb1rCrrB4ANrDN/2/RG5yv6MRbreEPY/JEkzeQhxP
	YURr1ZuPyH/bgyHzp0LBhci1/1UbqNUhM7hbAIHwWt8E9TOrmxsZnktnJre8FRKqktpX8q
	zJ1LpBowxNUeCIGwq669fDrN9bXJZyw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmV43mOz;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=30qAFA6CCzSksl7jqcRR+D8NveKerXteOKC7Yb7cCqk=;
	b=QG+AqtPX6fzFMuYcrEA2h8fT6sTdcFh9ZIJcFWcg+jv1hkg6ycgU14Iz6pkOgdOKKHPpC+
	gM/iARZMM8xDFuSXJvCHRFAzdnGijWrVlWtJ+xTiu8p+kfF29tc1VdPthYPTaAfPsj8kIL
	wsVxlpc9WPAn3hKD6BiztS1NcLK3lFY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A256260416;
	Tue,  3 Nov 2026 16:17:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBE21F0093A;
	Tue,  3 Nov 2026 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722621;
	bh=30qAFA6CCzSksl7jqcRR+D8NveKerXteOKC7Yb7cCqk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HmV43mOzSIYW7Fqzzpqz0hvDqDm1I7mTGmAhF+mOU6G/sV9c35CEfISlK2ItOEFZd
	 WOMktGf0v3XfLMGqV9cgWx97bu0HWn/qgbMbte2d+vi8wEeNrJpwLGYcvhmZZI3ZOf
	 jMBZ4kISM5YzUrGPkNb8ATGwQ4Y/BDN8by9X0l+NL6XwH/rxYd3YJKsY1TVMQbAccK
	 lgHYRTnm19YRWIRjT7g1F2nGjhvitI2NyfFXS4ZC1gehsPXJ+bC06xyR38sfKIwXNt
	 GGZCRMa1i3FpZf9/ReFYE5Q8HrpJZ86OC/kxgaeyyDM7S+iYlmOUlkOrrqAC0TogcJ
	 5ZTISNxEJEpPg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 03 Nov 2026 17:16:48 +0100
Subject: [PATCH v2 2/5] mm: page_frag: refill the cache for large fragments
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-pgalloc-ai-hotfixes-v2-2-e0d2890ab74f@kernel.org>
References: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
In-Reply-To: <20261103-pgalloc-ai-hotfixes-v2-0-e0d2890ab74f@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, 
 "Gregory Price (Meta)" <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Stat-Signature: k9p6y35e3nzaycusn49actb6ksgsjaf9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35FC22000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793722623-891731
X-HE-Meta: U2FsdGVkX1+l2PovltZapezcUfo8kIBuW9uVNQAAW1H7JdjxV8p4kmlhFL7NkPlyJu3qusbTxrI1c74Na7tPZ4MuOCJh5b6cpM584VW9ja1s9cbSlrDH7FHcBlwjelUuOFBgWpBBtkESdgPDTKEZmkVtZ1C4GaXmRKM4jk04FtlB4YpcyWJ5TvbIi3H0yhEwr4C6mDweMgWopRY2US23snwgROeCfF9jShC72WhhhJovNG6vJlZpif1InOOF4kBKgxrqPOPdIruwV8c0+lSIXzScTi3e/PHl+CT/TfLC0hzbCla5nnDfuZJpLAen1mFyQdIzQ6HQl9MmvScP2rBSwh06f0aqPhbKcWjyZwJHYzadctzAKN0OktKELCFTi2SJvZ+LNK1ECz1RPJQC+ad8e+5CH0OePHa9TRCLcrVP+fuSIxXlohLTFVvqPQvtzr5acWcilg1ZgZOV8+cwkN+93B+yqb4hEl0xZwakbS+Ql6CJmkTGiH8hawHFU17vCgNpTWRw72HfY+RzX58iTya4kgBmCQ0TST3JA5p7vfMLBm+iGAlbSJDYJ61W7u/5ELEExpx6V5ltnJuTHLYz6Inlz0CspBvp4DP07rG2GhKqdt+/bWbIp1oiCZ9A1n/FFWB8b6aRX0O6o1kiK6HXn+vO8tuRa9Mx84Nby+R+BFy76RGoBFpIMTH02FdDnNz4CsuTvkQVpjxr1941U+iF69MPUTgy4An23TiuE9JfP0+5C+yt4MPm2MWaGD7zJQXrU5atu0oDzLFKS58UV30FHZv5bdWuZDv5dkh/ixGqe1Bov89Aa1odI+azffhAnCxAonWNVqYG/YBMvcSFQ3OKXDGNed7iRTSBMLcg/TGmEzGDb7Ydh1uRPHqVRXzrG3mjvTnoiMpHhevkho+A3UPkVwqhgPHOBDn3+e3XhBNW9YCJlURDhqaI08eEI0aW7B6KSKxMu24bKS4QkvooqPTruhq
 a8Re/rnD
 x2XlNQsoxfNBKS3Tyz4m7W3JsC7tXzXBrSjtt4BAO2lW/lSqYGKWykmJB78QeOetoKoWJDdMc2TRTKH/Rs4fFoTDd/UiD0IJSjhXBAhD6U9X5+xoSjTtV8wZ2um7YABKk6PEUWNLoUowAKSLZmw+/iTm2rb+I3fNJ1aWwlsBTs7fZCRlRULHOjollEBzNqnTrMb9fi89l8h914BAgws02mwOuKSO20rMeDUBtsbGnivGCbikpF0h6iC65AI+VkZ7mFkdjReHg2c1aCgkk331EjCBmGHJCYY+s1dBEbuniAn9+LznNyDfG6B5Y0djiDoq+bi3rHZnUxKAiv3tI6/fojNnRPF73BTFZ1jjOF5BzmmA8soj1ypgnMyBn5cDfHvwaHda68sSgv7PY5GeANu+wXp+sx2AfRtyq2k6m
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


