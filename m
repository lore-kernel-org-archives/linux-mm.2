Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CD9E606A334
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hzFCTF9W
Received: by kanga.kvack.org (Postfix)
	id CB87A6B05B6; Wed,  4 Nov 2026 23:08:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8FFC6B05B7; Wed,  4 Nov 2026 23:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57B06B05B8; Wed,  4 Nov 2026 23:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86F406B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:08:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 05580808DE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:23 +0000 (UTC)
X-FDA: 85399733328.02.69EA9C3
Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	by imf26.hostedemail.com (Postfix) with ESMTP id 06868140003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hzFCTF9W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793851702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jhoY+jpmWMSdYwp//JSUuvTndwwXluhkSDeys0thRCY=;
	b=q8bIspkEKFuR+1vcTjHjOCv4+uvAohX5hbs3Bh+u6dU1ECdgNptiu4x7itjh7CjH4F9qyX
	acfsH7Jlhr+2Bxo2tPteYnepZeBKamYeIrCGYdQ7UFW82JFeYkI06rnAK1bs0HIvKo5cbr
	O7fxPdsr6bhsTbShe9v33qMmeK/d5cg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hzFCTF9W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.24 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793851702;
	b=l37N/UFL7eE7BN6SebjWy6VyAiYETA1YoF0/lA7VuP/W8NPZuUmJttnYoRTaAWHTkFno/q
	wFUZItcQLTh23dQ16ciek4xUYIhranUuS54+fW9hRtrWlaOXoCeUPlYyreocC6wbBzeCo8
	tjNg71Y+51BGYyfnb1s5ls8ChFRDfDw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WEbewz6b9wHYALxehhglrOgrV5IZCtm+DbbZBJ1BU2Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793851700; v=1; x=1794456500;
 b=hzFCTF9Wu/qi6Z9WvmibqufnABpILnjdHG3/YE5KtTgLG6adx+diqiWJ8XyitEl4HUGroll6
 UiQL/vbleqH6dO9huCP7B1n+ExiFzwUHFcjZ+AjS9SbQOA0/ntzl6mXYmSjeu0+k/VQaJk0/oyB
 f7XJ7769JlLHeR1laPissX9s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 03a3cfa50fb27246;
	Thu, 05 Nov 2026 04:08:20 +0000
X-Mizu-Trace-ID: 03a3cfa50fb27246
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/4] mm: hugetlb: fix GFP mask propagation to CMA
Date: Thu,  5 Nov 2026 12:07:45 +0800
Message-ID: <ac2de9b321f68c1025333e92e3ce94beadcb0b6c.1793850539.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793850539.git.zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 06868140003
X-Stat-Signature: g3zc7b44d56djo4xh3surzkaw18wsggc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793851701-173535
X-HE-Meta: U2FsdGVkX1/ZUXM9a4MXPtCbtc5PbNgtyQ5y6Pt4Ut23tFtn+8oNi6Eq0kQk61G70psZfcX/3iVvarC1YpJRbsDq2CQz52Y0q1FXsZjs+OiAnai8/Vnu8DKOgOrApXj9cY+83o2qQ6G/OIKaA+u6pu4zPgo8kw1sd+R4vHplHZfTV6d+Ww7F1s98/Nml43d2Y6SwIjFaTkD+nXJT0XGM1b7rYTI2b/0EUY28aZAcFJjSA0h3A3ruW31Ryx/Ryz+hkvFKm1NzWYrreXBa7yl0wsu/YeCsP6cm/w9zGNT2iXKVNP30qi/mr9kf6BL9oT7ikmoblXeWtJky5c2KuNiLTL20XsxoUpShkJBz83MiMt+hhGmTar9Gtyws/4/iZqxfr63RWTN/zBNC55trYm8DnV839MA9Wn/MR31GtW2wQUCQui95QDDVSUtK9PVolYAFJcpfW/ckPfcPZqME4uBSgh6NBvJsLEDCcMshQ6Sww/gju4tbLg9pRfXxprwk8k5bS/5WCqoICW0WvbgIyiInNFuNLKT7nkQ6f/Q/r1PsPlbtZViMeiyKs6EQQ5AsLZfIHRKVkc2a5XOx8O2bx/ZuXPfCV2e5AIo34HCt+j298PWUm62LtRnOv5vFTEZz/b5zzNqRkvPOuJpAopsFRDD/24mlBCyPynJTuCM6v3A0m5SekxwI0jqv7H2fg14EipiLyjDwgIGfnc4tJoi+BeYMnIEJZIN8H9V8mDGFCubnqB9VTu1w+DH45tSUZ4+Flfboz65Lu8D9lFnr4dC63v2Be3Ue/8ktWPs7BKbJz0Y6MzNBWaUMDrCKUGgWnOCt8/u3vTxSHyo0BHk1YWK6QizJ+cP+Q4xsWTgDBP61lHVfZIvFOtCt7ijpBtHdJDA6uKNfmui/DhlRdsPAQW2IosPG1pTVwVKmX0E/QgfDq+pe8FFHk5cHQuzQ22LO+F65Yt7ZrMA/dH04pNopHeg3nJX
 DteXaezg
 yau1AsglCbD0WOqRqbhSFFSHshUAduPGXCCLGv0r0s5Xv4CMcl/YCJZbGGeokM4xyItCIkkX/90RYAt1t07yMH570IS5qjXxFSD8iF8E6AzeKvdXnk3s3KvckRiRUQ8pqqoLraL6Sk1ltA1/wzAqsiJkEiDtGqCa8nRmYlvFdONC8qvhyx14FvUN/besKPYQk0CDecat+j9Aj9kxU7aNbUNHO+nIK+i65qsXFYUbJrlu8bsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
during the first MPOL_PREFERRED_MANY allocation attempt even though
the caller clears __GFP_DIRECT_RECLAIM.

Pass the caller's GFP mask through the helper so CMA respects its
reclaim constraints when trying the preferred nodes.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Cc: stable@vger.kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 include/linux/cma.h | 2 +-
 mm/cma.c            | 4 ++--
 mm/hugetlb_cma.c    | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1a..4539ea5f2c4e8 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -53,7 +53,7 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp);
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count);
 
diff --git a/mm/cma.c b/mm/cma.c
index 9ec1d1fd5dff5..876635a56180e 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -933,9 +933,9 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	gfp |= __GFP_COMP | __GFP_NOWARN;
 
 	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
 }
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 80b2407e9f077..307e5736ecdbe 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -69,14 +69,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	}
 
 	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nmask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
 			if (page)
 				break;
 		}
-- 
2.54.0


