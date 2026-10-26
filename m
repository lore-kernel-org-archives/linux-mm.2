Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 925B5606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ox2i2FSH
Received: by kanga.kvack.org (Postfix)
	id A080D6B05CD; Mon, 26 Oct 2026 19:31:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF936B0600; Mon, 26 Oct 2026 19:31:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7666B0601; Mon, 26 Oct 2026 19:31:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB506B05CD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:31:47 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CFEA3C0890
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:31:46 +0000 (UTC)
X-FDA: 85366377012.12.19BE753
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0C954180003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:31:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ox2i2FSH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOZA/d3RnlEXnMB1S+vtRBXnoN845YtQMJ+bQJINkeg=;
	b=6VuS7C+WEl7mFBizNkCVhgs7L9pfcdRNu96Tps/PrBguCfckb8oq8B4Wnu3oU+DqNzjCl9
	oliHOIwgqonphvELkvJ/JL5fxCBDU8XsQgYgUkciqHddr7b7888ywPfe0WS42iOEbpj/NX
	q/DkUMPvkx9iKdQPrUi8q4EwGBoN2Cg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ox2i2FSH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057505;
	b=edex3bODKpjhwk0VhK8XIVcXKojtkc7T79ioE7i0wHdn+ah2VeLtbW9ReJr6sXsJMpARhw
	chNtzpgxlgjX265gEm87ZdxrLwYam56oLdu1ZFMjKtdnQoBXGA56X8vKkZ1drrW6Mv39dK
	KoIxHvi+LP6JfgZ6PjE8pGaBtJld3mY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 56EF940953;
	Mon, 26 Oct 2026 23:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A76E1F01825;
	Mon, 26 Oct 2026 23:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057504;
	bh=JOZA/d3RnlEXnMB1S+vtRBXnoN845YtQMJ+bQJINkeg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ox2i2FSHOypqrcZwgXnwxa5pmucASOgMRL5vDYqMTASHl2rf75YW3wQoVrkuPIuIi
	 qWBaawkuI8mbHfObP4rg08odrulxxwWOwc2kIfSbm6V7kYxzS7kix5XDxbFQgiI57R
	 vd/KGBmW9fqjr2ojLTHGLQyXB6fpiqHp4DCbdpXJvJtGtlMg8tu48HAXtQUxYfibsT
	 JsLarU2SHDjaAj8xnSGSrXvbdAGQU1FoX1lIooc+b6p0m+NHqmvpSisMO7dcd3rVVw
	 AUARD/nIWCCPO2WzwdlkLwUwJeQDZtBN2zbbbs27Pi0cCpSRpugWYDmuEeJDHrz0qE
	 2Nr+Rh3Vvxf7Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:18:04 +0100
Subject: [PATCH 44/46] mm/cma: don't release CMA pages still in use
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-44-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2157; i=david@kernel.org;
 h=from:subject:message-id; bh=nx05kHs+vYnlpcYo2GO368aldzvpDGoDSteIsZANA+4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu359h9zUpMrRK7P9OThHTp6//rRVNZj6uMbl9Wn3v9
 c5EY4H9HaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzk7RKG/1EXTeqmP/GzifCZ
 ePbvbCfeC7W/VWUvTCi5K3vki/Mam/cM/ytneLn+m+4vm8X6VsRtVrGe72WWIDPnlSqnFA5NmLY
 kmAMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0C954180003
X-Stat-Signature: xe8qf14ci5ojunapw79u79mx8xegpqaf
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057504-625242
X-HE-Meta: U2FsdGVkX1959iRN727TqXvbEmXtHFtK/zk9/Mru6+adj9+XnV7nV84Z9N1noOF6qPqa/PkYYA0+eXHtlFrCbNOeMJzZSexwEhOnDfn2jYAdSis594iY6eyRhZn3PoBArfQXMyk7wXoLBsvOpQ03R9LdKu7OycN/XU/Z8yrvcls5XUm1S66UdojL07FIToyEORxRfBNxGjZqFYXy/nefB9GyEiPIE91V1IfCBxJqefKNJl3qTC4KuLz0QOrJ0tyeZHqsfWtWtWYsTy0gIrNtWmHo12/L/rf/EYYmitE1HeJ8rK5BuHzWkzJgrXfulj+3mVXB8VRAms97G3ftbmp8eAhjpexXjK5j8Z/3jtHjtdHOOzbvrokdGmgtthF3AbA+ac66+oC63Z6wdvOXU9zWAP0SLRSFvywrlzoQJT9QxU7THlqP14wacc50EfiImuRW7NObVnLoZV6h0SbrhVPFCVhKWkklRdkw7ckG0C7/gkSqpfhbaU8Sxzj/m85FUbkcKq+BSkv09YbG8JPZ357FvKr3xwXx9WNemfLZ2SnpMSU8SqRzP47rN0na6GASCa4eEZWzlruHrGIIU9WC2hQVzer01DEwNg/kRaIW6f6rYZVPERMM9k/qaaOmvXBiEav73WSjTRxURRKaPIhQiBeTInryL5nvXf2p05QNXfc6GlKwVNYG3XT4X9QO6xZxdihNs+kgeMgoRNPZmAEULjKnUZA1FWL59rBizbEvfdPnwV1iW4n5QTpB20ErYrEddniMln9lYBtd7zo6sp77magdGnlA2yIx53PTob8/PBfFItdwc4diZsZ26SHs5TcJPswlaGWQJXdZ8/azS7/wlPpyANkMWUcMtzgtZr6sYqI1iTWkf6kaENMJZAyy0d8mJr3DYlGcDYo1+tGDIqvHKNLg+rr7sUmvTXD+06MLSgy8t+dpYPTgOxeAao1b2PjSvsi7w8N+1or4zwljctwuxbz
 eXk/EshS
 1FGkv+MKHmVz6cK2lYY2XO1nX1i6yU6ZtC92U+w0K97+x4nuvndMFAXesiObe+jRkvcqvYf6mkWOd2JYjQjFp3WpEDxOtolB7LxZG2Y0ORV3JcFEUC1YVhU9YxoJkon78qzMYk/Mf8TDwzfCXYiaeOsniQjGwVW9GoRnl2Twhro9sgN22rNJt3VNLsg78hGJypfyvUD98k2uJWJVPS2xapV5Zj5fxR1AtntuqPe9A+B0NaIaTcUk3PIo5ROO+o389yVqr31YdylNOuXyVlUXL2HppGKSRNpVlczsOl1wRcweGj69rlz41HIEU9e1919ECtxNMJnmtkG8bpc74+QiDm3K2JXJT/fAXQpMnhqH9cmFhwJIPEAx/ccPZXuma5CW0IJ7Ayhql8psZS8AKvnlVmx0cBs/va8Ia4i8W1ruimHDzqpcPxo5bMwQFDYK5ZhyM2Xxf/4my95q36Eni3Ohk2ckCuQ==
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


