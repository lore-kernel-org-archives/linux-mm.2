Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E91606D815
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=j56m8Gaq
Received: by kanga.kvack.org (Postfix)
	id 3604E6B05B4; Sat,  7 Nov 2026 05:31:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3906B05B5; Sat,  7 Nov 2026 05:31:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164886B05B6; Sat,  7 Nov 2026 05:31:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E82CB6B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:31:24 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79F44A7D76
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:24 +0000 (UTC)
X-FDA: 85407956088.06.DDFED0E
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 838F51C0005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j56m8Gaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794047482;
	b=uYWva+yxbLbbc1fceMQQzi+N6m3CSRc6Un5Dk6eIHNvl/woCOh59eA5elotUPvrAfjlgnw
	IfEd1RQXfU6R4o4XXV6vrLXrUL7ASwudI5O+62UpFTctLtGoHX8BmD5oUY6RJoTa/7wTAE
	yTLzK+VaZM+0sYE1vFBPWPcP/VbqUwA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794047482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qa8oAW5DrZueQ/BMJ/7YOYYWqHn60qhqkLUj4/UYEY=;
	b=zsnAG0t3ZigbvCDETDxB5pxY9ueeryhwmL+8qegxx7z2T4iwXQv/dY+FNyKbS6I/eal6MP
	pMcIULI2y5HANlykeoxZ4OVijT2BW5YoWhfp3eZ3TRtxPkvRUwUBgfA2UZs0qDJD5uU8aq
	nj3xt6UwIECXuxdJpSpNp3Mib8UqRu8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j56m8Gaq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.12 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DC3/xFjT+cytEgYhhw4Ov9ae3LqMYLHYR7j8UIs7GXc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794047481; v=1; x=1794652281;
 b=j56m8Gaqvoh+cFzEbg4/MEzg+YppVMNj+sR1fMYzKWYXYWMk2rRjPLTBq8SO1w6np5mAWMKS
 8VeKEBMCAmE8dBSJuEeCcsSEdA1a5gZ2JQuU1TojZXumo3V8uY1Jovsdp75nLJTCjBT+ENf5D8w
 ln0e73O/tbEhcir2eg88or+Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id be80d4488337d4f5;
	Sat, 07 Nov 2026 10:31:21 +0000
X-Mizu-Trace-ID: be80d4488337d4f5
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
Subject: [PATCH v3 3/3] mm: hugetlb: fix GFP mask propagation to CMA
Date: Sat,  7 Nov 2026 18:30:47 +0800
Message-ID: <61ee04513d6cac32347ebec9b295025b8a1f07ca.1794046188.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794046188.git.zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 838F51C0005
X-Rspamd-Server: rspam12
X-Stat-Signature: qgafszaj6h84n4gd6heu9589hcdsahd3
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794047482-18891
X-HE-Meta: U2FsdGVkX1+D0ArryfsrsYTWfcOmco/xNo8MKJdPEjdf9S/ejThScmG5Lyq6HMen4w/LXYZ25X1Dfi7LkIpXIi5e7pZvcdONNTsHTXohLvk+I9QVYrP/femuWTrAKvKjLMr7C6H9JijQsDmyPaRGPs4izsGCZoVdKaRO82YhpskXVsdPCDGJCM0Iz48tfXqaXSkFGD5wxFHFK61ckoS4Ml5N0uy0ciz37pWX6a4O610J45wne+WXcGumcgAnh+Vnqnyn3qDfKYp7NowtYvj9NJomxD0rfICwOON7HNABoM/14aTSfJv9//5ZZmuC/ltgju1dkWkxXfRiR0SCprSkOzl05LFVhrKDbYhQWJJtL7YMgrWc2wUA9c8Am+fPJA1sXgmWiTrC0SBSJbCSIHwgWt9j+bR74+TT/lzlevhT6VDNfiC4DYzFUijWH33JbpldZxACA3FYRj1VTnA9Gp2Pi3hYdAGykb6xZf8MoNQK0VBU3DyF8RFMs9MwwnaSbeRo9+BELuzEdvOxkiFfN3G+TRVwoYx8k9qQtgWjN2O2p/ipqrfeRJaDOfVLLjp6prF8D3JDwesmBg3w+s48+E371Ylxh3S8N0+aPM63xEy5IPs6Dz5fL40a1v0jsq2tQwVbQ8zsvb6Sl5TSkenU1UhlKwmosEbqbpizLYOLpIVfTvLyipeMPNgF4dXRxCVFMsyXbnhm8ovAOatodi4VDoAO1hUUbNXVpvjDx4lHBauyp92vaiKIHlwCMvCq1YIx764qTCnGJDWxAVMvmTJWVYxa6mlSiGwo6GI8+bK70tN8YpMjSHlKC5G2RHxcfaWjB6mu1XkS3C4Nu95o1uaAuHEXAlqMt1ESgOdjrnfasrHbLtxnGy/g3naxfsJkac6CublKnM5onoVHmVLmOlqmLFhitl2KOvobDBqK2WsvLZOjwlCmeab/83jwhoGGt8k2YgPsMQeYk1s4JQ4zGCaNyD5
 fcKrGVj9
 u35IUNcdzTDOfVAkW37ENh1oqzg4W3PZqWRTu7mWkY/gidziAN8aa6OO96GDAGarDfNP/ou9Pd6Lh3SCikj1E4VCi9NJPJ3dGNBkZbBOx9vUpDIXsjDD68GTw+v2MC9taqQl2h4ocO/w8OrCoE7OcUcG2ifFw6uVMdsyLSN6n3D6lA86hg5YEEE88p1gDfOTgmZyYHgmnW41ogCH4/5mX1vwxLeC6fs8X3MBXUI1uKX35U+GDFmC5Erd8ZIW2l5HHVOCtCYYAo6KYGlFf9xe6I8Dm36AKS8lZKmeSojhHNQY5rNFBA23q/E7HpNQvaiiVxXhytESLKXOQ3MqLL/nPXeNLWRkuHaCr3sZQhkDwjw6qCMmrYaIQz7HbU3PZdQf5061Dpn/5WZfi32NVpstF5T8oUE24kD76iAoOZUxbrPr5i1Q=
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
---
 include/linux/cma.h | 2 +-
 mm/cma.c            | 5 +++--
 mm/hugetlb_cma.c    | 4 ++--
 3 files changed, 6 insertions(+), 5 deletions(-)

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
index 9ec1d1fd5dff5..45017ed876f76 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -933,9 +933,10 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
+		return NULL;
 
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


