Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4792606A334
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=E57uLsjC
Received: by kanga.kvack.org (Postfix)
	id 3F8EF6B05B3; Sun,  1 Nov 2026 22:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0E06B05B4; Sun,  1 Nov 2026 22:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A826B05B5; Sun,  1 Nov 2026 22:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE4AE6B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B1A580A02
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:33 +0000 (UTC)
X-FDA: 85388741466.02.6C332E4
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0E01DA0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E57uLsjC;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589991;
	b=CxZ2gn0/LcVg9moaimdMHiA/dZ4YmyQE1NlMWn7hZut5zMQ73tEyQv9xNQZHtMSmCOIRm8
	Hb+iyDl/xdxPZudvUEJ3uPeCGJ6A1OPUz9ky+jBHcb124jGYxE+W16pH1SpB980slKaw/J
	1+61sh6mQ6DS4l/3TVK3wzH2am1zYTA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=E57uLsjC;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTMXZFe5gyQw5mYi0ReIkJiMtVGiDJG8MERdlHxMBwM=;
	b=j4JzYNK13ol3265ed5z72gFB/Jwu8agwRtO6ctYN/dj3HwuvQCpgI7XjtQ3GpFhPrFU+UD
	N3LuYRrbhU0mke1QhR2JKTMN0AVz5obQamgVF3MeVuvgA15X16Kwcy4qYk/Ogj3Kr+verD
	t1y2PoTMGBQe+Tz40A0dLWLFK5/KJ0I=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cd6a7b62ce8so757897a12.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793589990; x=1794194790; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lTMXZFe5gyQw5mYi0ReIkJiMtVGiDJG8MERdlHxMBwM=;
        b=E57uLsjCY3yGtnIQH/a+oBGs0DDe4wAON5EfkaslQFkQRuyMzxVULNv4XqmVvvqUgt
         9g6VjIb7gPRkJ3W8VbN6rCTd1ql2nU/nWnAUkrHDsjAcIa4PYXZswEgohk4+Ro4TK3Iw
         jJyQTkRnSytDOakAOB+K9R30+dGOr8CGsoLK5ABbOgOmjakGyaY5dQ3ZLSn77+HOGpgJ
         719X8ahwkhbgVIEX6zbsGGvdElyXKfYC+tAeIj0xvRFYnsObHDUqoXT4SY7XhUkz99vZ
         VCcILrUPfdrLcwqZulJd1g1wxXdIV1n6b4wu+ATax2NcHRyjCD5YOq0LT1jXsDZvmH+w
         42NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793589990; x=1794194790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lTMXZFe5gyQw5mYi0ReIkJiMtVGiDJG8MERdlHxMBwM=;
        b=U/uMHFaDp0xwZ8k68Rq9OGX8uWnMVbYsPQiU8fOMhnDukQSrWcUQXiZ5gby8razAot
         fyS/+1QIJHoPDyvRBNhlVVQli9Bd3WkUxCPQdecp7AuJVrYgzowiQpXVn4nXylSy40K7
         kqQ/ovXf5Nr/7hJUtjR+yETYpVSari1s/zkqiweDYBshNFacGllGpIyUQC1Soo59G2Ic
         I023OiGAPcX6VFFyzy6qDVia+YZ4ZxLPUyIr9P34ZleF+myW4omPbWGEx7fvDhpIjyme
         Lrk07OA1Kr3KYV9w4tOw2sKaQ6DKcxlXQHfFv8EXaOlRcwfeUawQR57LLnQr8mk6JfY7
         YqTw==
X-Forwarded-Encrypted: i=1; AKwUvBwfOHP/RKYdE2v10Z7iOV3h/E2UbUn57GBdanyRBdWflZ/6W5pDmdH30mzt67SxsOjeW5cfBC1Z6Q==@kvack.org
X-Gm-Message-State: APuU4Z/deGveZnhJhrEWlqGoXLh7iJNq6SxaoM8T8PjodmaEDcDtpY+y
	aV3rVpodQinmEZsrOucX8NJCWju4TJJNKFTcZiPuB1ukO+GeyMY5KxxHk7L3IdwtOE4=
X-Gm-Gg: AYBFou3j6stuc6cTZVVOcmjYQP58Hg6P21u3o0kDtmN8cCCsSzigAQa9M4TOozAHuAk
	2UcPCByzR3CMZkAHNxeUDbNXsh5BeeMLrRYdVD+TFMbHibTX9/JY5QkhvmGbe4NUaL4oZUSwgHQ
	Rv+J5o/ZNLpqK1j4HG5lebRTKaN1a5nw5eqnbGaxZuaKG/gEOgtHYmBLO569eF5EIygXs03bcG5
	X7CbtCa3DYiAxfpifCLJAQJtbC8XFnWStMtl+y4bwiNyIoJ4VH90mkF0ZQ3nse9V15MWq0I5Fpg
	s6bSye3C6P6PN/JsDBfEI0RVEI1xkLe8bqBJEjU7RRjyV6nz+dhwL7KvoqrxCfwue28TjC9QMVX
	0tcsOPSO0VbLznyC0c5FTyERdEQVUtkqK3Qkq4aTclHISGvhMm++2r7y7Ge4ZeS7uwHGIvMZ9Fd
	HWdJoPTiYd10VEBVe8A7wLwefSl3HA1ILWPR/QfcMPR3zRplPb7tJcOixsVyJfBqJrji7vQ7Os7
	NzvjW9lW4wKY7qX9ioJ91N8Ts3oG9CGxm6Hig3O32xYF0LbdpjxDWNpGWNWLy6yE3M7l3ka9VpU
	x1IkXnwNtHZuF0cJNQRq3ZjZDRj7xMVGdu7d5vmai44WB5dZjw==
X-Received: by 2002:a17:90a:ec8d:b0:3ac:b7b9:6484 with SMTP id 98e67ed59e1d1-3ae897ae130mr6776957a91.45.1793589989738;
        Sun, 01 Nov 2026 19:26:29 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:29 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 02/12] mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
Date: Mon,  2 Nov 2026 11:25:15 +0800
Message-ID: <20261102032525.3597743-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E01DA0007
X-Stat-Signature: g4n6qxbn1bogzjqd3xu9yrydft9kn7jf
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793589990-204433
X-HE-Meta: U2FsdGVkX18SdgqmNCom/zRFLKAfo+wnjY2mORFYcnBhFjcFAQJowaHtHiN21fG3LPHKauwAu2Jv411cwcsdtxF/gYuo+1Plps5hlon0i3cumNwsKDVxhbD02fxogwf+/o/nu55P/kNyDNxMp3tB5kXYt32sxkKn4/Azl8SrxIDxKAZyIC/gB8OskVCuGxesaZeaHMxC/qDJYfZz6Z9rohP6uSeLqSq6qraxfGhjmgebkkAoeFtJoIqZ7pE7hH9on9P41MtoYUjcrAwAxdTGwGGSKxIsEtWCsA3bq9+R74xp/X+GsVMHvgxcJ207mpcQyRy80rpMTsLbrShlvHFaMMuGRuNGmTfGh5GE4cgsFj+b921PLF4ZL7Jf8oIy8jOEEpw2dOmcJTTT3hRmdnM8sDxp36LlCTzDO4TNcVKVVtwg5AC9Rbs9O8S76Gjy1LDJ9Z/NZf0+qE3kvbxTHEH/vwSh6zEBtOoJrPYRESYsGy8nzTuOiC/n8p2v5Rsq7QkO+rkMxfzemBmvttTo+eiKcwGEr1IYJY2PucpWmS2Owt7a3GyMzenYINxYn/Ab48QXVc6507rJi8xCvR7Y1otWtC6cqZ18uzkPhCpFSvgWE5l7jWAsdDz96+U1eX9JSvzq/XYEpArgxF5wZQcB86yG5kXl4W4Rh1gsTZAqkdSkZGTVUwBH0qyPm/0GB/JENvr2W/c8z2vtOzW28GxW5HUPbLQeA6Sc+oZl9uf13ay2nd+rc+lrHj+8Bktk7G5vgbzjiLZ6vtFi3zs0/gl5yKO/XOBjidTuI4tHAayA/sFCkdjNHG6p7PU3WnpNpFyNtoXUnCLl20QGtnglwb9ftW0CCj0wNpodPuA06pINHcX1Yv1oWOyaL08iescrtTKFDDnqXRaXq1Xx+i110oSya2Vl4HCtylrftb8Yri1LLLWOrXtwnfaZ/DgFqs6qaLbi1Vr0oTs+gZDxkrhYurmVI6J
 5BhBrMGi
 CG2JbdAvgQ2wRFAv91LSxzBjqQGPQ2J7Ix9hblD7s8bb5f5r249U8fBQWPPwr+e1CEOV1QWxzfDN18Kba5VGJ1s/03KBz3OMuujenwLGYXvaAPcyIrgeGgUVI4qphNrHDhINwKSSwiNr8XBGHL70nkQf1ZL9W4OFwy2OX/7tIbXULm0phdLWYO1ilrXbHf0U8p6g96M6uT+fZoca5I37EImpAEgU7fh0OGNoAf6U+VOkgx8C7YEcas/Rz/4wdSYpYh4vFB6mmM10PM4HF0SST4J5ZOYbDjCUPj8prSgej7hyiPSC7KVwEr+/WgmXtLpD4x8rUflNqtalKARqmvP3HKuArZs70Q3jN9oIq1s3/mz2ziYvyQnebm7IbmCd/4PXOoeY21ykRQb/zGTjDtV+PLaiyUa8s8ZVJ9IMuGilHqzOXTLin8adgBjDTmGRAlOkjM4bQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
describe fully independent choices. A split-only walk can defer the
PMD-split flush to a later global flush, and a remap-only walk can
defer the final remap flush. However, when a PMD split is followed
by PTE remapping, the split flush must happen before the PTEs are
changed, because stale large-page translations must not overlap with
new small-page translations that map different physical pages.

Replace the two flags with a single VMEMMAP_DEFER_TLB_FLUSH flag. The
new name reflects that only safely batchable flushes are deferred. Keep
split-only walks able to defer the flush, but force the split flush
whenever a remap_pte callback is present. Callers that batch HVO work
can still defer the final remap flush and issue their own global flush.

Current callers keep the same flushing behavior.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Rename the unified flag to VMEMMAP_DEFER_TLB_FLUSH and update its
  comment (suggested by Qi Zheng)
- Update the commit message for the new flag name
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4b73d6ec8dce..63e899cfaac3 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
 	struct list_head	*vmemmap_pages;
 
 
-/* Skip the TLB flush when we split the PMD */
-#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
-/* Skip the TLB flush when we remap the PTE */
-#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
+/* Defer safely batchable TLB flushes to the caller. */
+#define VMEMMAP_DEFER_TLB_FLUSH	BIT(0)
 	unsigned long		flags;
 };
 
@@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct page *head, unsigned long start,
 		/* Make pte visible before pmd. See comment in pmd_install(). */
 		smp_wmb();
 		pmd_populate_kernel(&init_mm, pmd, pgtable);
-		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
+		/*
+		 * Modern MMUs allow overlapping TLB entries with different mapping
+		 * granularities only if they map the same physical address. So
+		 * remapping must not proceed without first flushing the TLB.
+		 */
+		if (walk->remap_pte || !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 			flush_tlb_kernel_range(start, start + PMD_SIZE);
 	} else {
 		pte_free_kernel(&init_mm, pgtable);
@@ -166,7 +169,7 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
 	if (ret)
 		return ret;
 
-	if (walk->remap_pte && !(walk->flags & VMEMMAP_REMAP_NO_TLB_FLUSH))
+	if (walk->remap_pte && !(walk->flags & VMEMMAP_DEFER_TLB_FLUSH))
 		flush_tlb_kernel_range(start, end);
 
 	return 0;
@@ -274,7 +277,7 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 {
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= NULL,
-		.flags		= VMEMMAP_SPLIT_NO_TLB_FLUSH,
+		.flags		= VMEMMAP_DEFER_TLB_FLUSH,
 	};
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -458,7 +461,7 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 	struct folio *folio, *t_folio;
 	long restored = 0;
 	long ret = 0;
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	list_for_each_entry_safe(folio, t_folio, folio_list, lru) {
 		if (folio_test_hugetlb_vmemmap_optimized(folio)) {
@@ -516,7 +519,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 
 	/*
 	 * Very Subtle
-	 * If VMEMMAP_REMAP_NO_TLB_FLUSH is set, TLB flushing is not performed
+	 * If VMEMMAP_DEFER_TLB_FLUSH is set, TLB flushing is not performed
 	 * immediately after remapping.  As a result, subsequent accesses
 	 * and modifications to struct pages associated with the hugetlb
 	 * page could be to the OLD struct pages.  Set the vmemmap optimized
@@ -595,7 +598,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_l
 	struct folio *folio;
 	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
-	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
+	unsigned long flags = VMEMMAP_DEFER_TLB_FLUSH;
 
 	if (list_empty(folio_list))
 		return;
-- 
2.54.0


