Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D61606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=saYThnMd
Received: by kanga.kvack.org (Postfix)
	id 232D76B05BD; Tue, 17 Nov 2026 04:34:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3426B05BE; Tue, 17 Nov 2026 04:34:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 120A86B05BF; Tue, 17 Nov 2026 04:34:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E72F06B05BD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:34:34 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2840F120388
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:34 +0000 (UTC)
X-FDA: 85444100868.13.816C2E1
Received: from mta1.migadu.com (out-17.mta1.migadu.com [95.215.58.17])
	by imf18.hostedemail.com (Postfix) with ESMTP id 331DD1C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=saYThnMd;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908072;
	b=e+N/6/apE6GDOpIqNvquztj7g34sBQsdgfJ1iJa9pPO6KLygE7aguGwrQd5sEMcV7RoZ5J
	bVqbwWn+V5fu5856Qx7fkj6S3BbuukN0x11O5Uk8Ed/wuK+eLcWDFJR5Qd8G4/Tl5983oy
	rF632yIah2ePf+y02FRrI+KcL+xESxY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=saYThnMd;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.17 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pabw/uWm1cjpx9kdTQH80s4Ttm/z+LkqjaBTBCm9M1Q=;
	b=515TfHx943Ii0r+Uz60MdnkObDOjg2zgZIfCH+h9l1zD31Zxt9CvpFKzWP92/DO/I+UlKb
	O/TQDeiCE2qY9xgvGNV1WO/BtWVh+8Oi6dgOqQEmV1O5fQKACRRSTKM4jwrTEmfmp9iG0O
	RfEm6IxAPKevkuOFbVJpCSPkkwrvafM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ILUpJ4Ob0pNFnAX2ltHw4R7fKp4fmf8Un2vNiqYU0SU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794908070; v=1; x=1795512870;
 b=saYThnMd25FwYHaO2dELkyNcwQBLYWupj19AW6inLkyGWKuqxuwnJ7ByyqAK4RKHv5kR4OdX
 Yhthf3WKRsuyJF/YVmDE/nUeZdzdiTEoE6/ot9JYdsNoQUFHSzDvn9QLDFjMJUAbiyip/DfJkfK
 juSSztSXah+aHs3j+DHUY7HQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 81f6557a191836e0;
	Tue, 17 Nov 2026 09:34:30 +0000
X-Mizu-Trace-ID: 81f6557a191836e0
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev,
	fvdl@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v5 3/3] mm: hugetlb: fix GFP mask propagation to CMA
Date: Tue, 17 Nov 2026 17:33:59 +0800
Message-ID: <990efc61c4c3b2a4186cd578a56c6a74348fcdb1.1794907279.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794907279.git.zhengqi.arch@bytedance.com>
References: <cover.1794907279.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 331DD1C0008
X-Stat-Signature: cyxtgwhum9nyir5yxbtgamkc47cxj56c
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794908071-822097
X-HE-Meta: U2FsdGVkX1/aLB7W4r8hkjFLipE6ePS8sxeznLaAONQ+X/rIUpxXZilji3okrwI16PXY9UlxVaZIVWuJ+wK30IaJP2eR89VzFZASKOwPrmIk4HKZPN2aRrN8H7m0wvXNUOyncVWPbJMRqq+WoE345/6r903Fj0ZrqsRqQlreIF7ISDIJ0DWAbZdi4byyqXciIZZ5HoAKPI8hES3PPyx9AC3PR7hXscPv9w2ic6T4un96u1+/cJkQNFbtJLkjqR7kO6Ft0RTOzRzRep8ZwrUk5FsQncn1d8jWUCllnrNh6H4fVskRuxyzz1gsFYMS2GbYeRjlzWCSAKVZ3/Z+GEk34rpCbnHKc4mAFcNFhRDh3pqL0lZP31ZDT6HKkUNpGeS5S/RnjAEujFEWMyUcPMJyrQ8d/DtcLfVpdplzRaYHMCROH16HTPedrhORLNk70ZmU6tgi3nDCaK+E1if/dWqD2J3WzPFYtUTr+kV2o3gH689uDngA0a6++ZnaXZ0+xwQRoJNO0rrdSBBQPZSNJ9Y1BqoN7OFCfyalmMsmlRwElOc9P43c87tW98x/7OFlxcbOhlLuXtHxKDnXRKoHdInDRc2tCpv0PmIyZxtrISDo6WJvq+PYUDwILRULb/DTdEx/dAoEddewmANps2bXOEM8/YLKbGCehjVmTl9TH7g/1mbSCOoHxyaW8BkbD9+P9FIOXx4ZvL3a+qzLzWHvSqHx4PHvjelGYmQ/sHPgHFN4krP2iOJ6pHTeXDriTeJJJtkrisI83JbcJgyKNAvP70xe+H6pA37ZUkReK7xggHv+0I/Mp/rzJAWniEE6V09Isi4DRr6nExZi9Vi9tvP4reMPmXyfex3aqgPildT7v99O4r02wfoqCHjuk3YWHtU2lzXLm2gJgsa9AZpXE4zPFpkNbLHR08ZwD39x7eKaROK3oGgMXPJkXeW/t3ltFKjJ5mv0BxVVDzDBCIIh0ZzD5F7
 5rj7+TNh
 v1uSxOncwwa1Xp5T+ndsMBm8CQWUj6HNzeoFJVtFW/0Frmh7ppfSUs5BBiQbU3qPmnu5PCRMxRYoR+JlwYLiJudAELssVp+pfbQGotMzfXPXBq2Hozk7tGZCAczMoOL8uTIQVY/zBkMLWzhHEvqwXDXEztuFLVThnxPUt4CXNJA+9c3rfQF9y+Z6XuymDFzq52Q0olJVs2RYNJNJ6bv6JFmYxOqy5XL6yX/fI984KS0jqWqdUTGc+xKaYvXvTAJ+nBGLT
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
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
 include/linux/cma.h |  2 +-
 mm/cma.c            | 10 ++++++++--
 mm/hugetlb_cma.c    |  4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index d829fd0355bae..d6e97e831d970 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -56,7 +56,7 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp);
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count);
 
diff --git a/mm/cma.c b/mm/cma.c
index fea5d1015319d..225e3bbaecf9a 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -944,9 +944,15 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	/*
+	 * The only caller of cma_alloc_frozen_compound() is hugetlb, and
+	 * hugetlb constructs its gfp mask via htlb_alloc_mask(), which already
+	 * sets __GFP_COMP. Check here for usecases bypassing htlb_alloc_mask().
+	 */
+	if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
+		return NULL;
 
 	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
 }
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index cd6f64da31a2c..1eb9d8d8732ba 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -71,14 +71,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
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


