Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22F81CDE01B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 07:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA328E0005; Fri, 14 Nov 2025 02:57:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B6C8E0002; Fri, 14 Nov 2025 02:57:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679A88E0005; Fri, 14 Nov 2025 02:57:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56EB48E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 02:57:16 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAA8D884B6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:57:15 +0000 (UTC)
X-FDA: 84108457230.03.1B54C37
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3481614000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 07:57:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gLbl6qvg;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763107034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=hIvA6yLPnKeWMVPtO7BOt8TNUDdATgcSH5aI0bTFcO0=;
	b=NL69POGwrdXhT9x/YiWEjoukDBWGJcQFnVE0xJ8d4wgQhkvu+gmcjlFNVgQmPuCn/Jc1JR
	PgooItVVt1wqaTMALk8EZcVPS1NY1F/95CjpIcCsP8KMKOQZUCJmMCqbMa6N2N9DvuQnB9
	hahJogu/G3VjKQyr/DDK6iCoYdDRIXw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gLbl6qvg;
	spf=pass (imf23.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763107034; a=rsa-sha256;
	cv=none;
	b=tlm0uztBV7N9Dbf7Tr3ZQySYElWObT6bHgXrcD6RG9K9uZkWa9ja9cbLnJMd9kKJN7hn2Z
	a/dOCGLh7Hb4JzaWH8kh/KJMq0kqFNiXkZrPPJn+KEEn2DDNALkHy4/LfAfWcFKN0zVIXH
	yjPg5H+MZSB4OAAuiU1sGE/+uzYeYTg=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640bd9039fbso2994674a12.2
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:57:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763107032; x=1763711832; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hIvA6yLPnKeWMVPtO7BOt8TNUDdATgcSH5aI0bTFcO0=;
        b=gLbl6qvgHyVnQjckjVEg5BJU7cX87n4Ij+AClINI9iYnaTiH/NftcgxrhWuFW5pt71
         inOZf2zJjlEsQxU9rto7485RtgsdA/6Os7eyo0lqYEcF3f10ZIr0NADcI0HmlzXMw5G1
         Jc4LhiiWVn+911rjocA6yhPLbeDBTvs99xzP2/hoSgkqxYbyvY2JC7GyKpHcCHNzlfVB
         tiHpD7wRBNsmdU4VvTpkZHCXy8vplfDo1S9xFGFGIRZR/CvjmjeJOajnwmXmTFxbwGhB
         op0gfBZvvMMgq+mNIJ+yvqM4PDK4sbbRPrZQk7gmESQoyoxstwjnEv8kf6588liU8/xB
         /1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763107032; x=1763711832;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hIvA6yLPnKeWMVPtO7BOt8TNUDdATgcSH5aI0bTFcO0=;
        b=oYVo1sGhKykeUguVDbWd7nyRzg1Bg8AEVrRrH4OcEVrRNTtbZKA20hE64BBnftgLDT
         RPhzsTSTS89fjaSjq43wFCFzlyifyJOMBs1FQHMkDDr/gMQihkkshOlAzD51cNxbUsja
         W8MCRkwU0nEuEsvxe9Iu6aD1d4yh+hV2umdjCQQBw0h4x3Q6sa3Y9RKSPFv3SQbgPet/
         Juw1CsezewyKTezGJp3knaC1qgk7d2/93vL2p5mNmKKu/r0+u7nUru+DP+pza73f/S5r
         xg1gCB9I1IhRYQttb05GgvlsJxPpWG52/urDT0ErLeR/g4xx4j234badmELtG+kys0zJ
         JACQ==
X-Forwarded-Encrypted: i=1; AJvYcCWosPJZhXriXsPWNB6oGbaYN+6sqlRpLrnOFJoxVTYOGPMKkHKMIvCMQV7wz3X7yNjBSxW2AJaTvQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6vOnSif5oVrqdgUPHSAlmPrFK2ari0CQhA1Hhu6QpIw/nqe4K
	7xGuCnm2IC2ssNT/XoE8aBhpnxkUMRBMfdXnIbwKqrASyw8EWhaEpKNP
X-Gm-Gg: ASbGncs6GwhvR7CHJNSrMnDd5ED0zUYsLtHCmOnDqFwoqmlCGQnQlai+g1+VtMzfHI4
	ZRBO9wiDDTV8UewBcYPh5m88ChEkDto77QqV+PxZCVTewIlx6c26KHTS6/EMHqa4HYMyvWIKnk4
	yI2qRbIS/m8IK1eH2RqfXSo0CarHNCfzWt/ApRUzDGh0xY0tT2ULKchKf8FA4Nba7MRLU0JznpU
	caJLV68MB3LRKWZ2/Iyxe4sHZrfS0ar6enPGu8tR3a/4D/OPijdPkhevqWn4r78iAHbBqr4ZHvP
	kcBRWWR8zT4mjLXun5ahi/gv4XEP52S0/5AOXYG0ydQaGP3y6YSXxmi5tdA27hX89Nf7z49AXJq
	97LkPBHHZzwgWMfH4XXuDiMI658RyveQpREYmHZ4ZFZJUwLeoO3EFQcim9lXZc4U51bu76fGSB3
	rgW1Zvb64CGil1OSIkXYoV+BGR
X-Google-Smtp-Source: AGHT+IE0vQE/VL4qK0iqmlw9B7Sjp4IFmBy++J8hyg4y18WBO4JJirL38dV5FBI1kNbDqbxwV7fIpg==
X-Received: by 2002:a17:907:6d22:b0:b04:32ff:5d3a with SMTP id a640c23a62f3a-b73674d2391mr193760566b.0.1763107032366;
        Thu, 13 Nov 2025 23:57:12 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fa80afbsm328466866b.11.2025.11.13.23.57.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Nov 2025 23:57:11 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: willy@infradead.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/huge_memory: consolidate order-related checks into folio_split_supported()
Date: Fri, 14 Nov 2025 07:57:03 +0000
Message-Id: <20251114075703.10434-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: 3481614000A
X-Stat-Signature: 9ozff9mcpgcs66crao8t5eao1r913dy4
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763107033-925637
X-HE-Meta: U2FsdGVkX1+19czwxGO0VA1LnJn+fhC3pTY4w414UjI05wSJTTApBcrpB7fNcN23Dsc5qZx5BH9sPtld70as5JM/r9h5g0+F5m03BxprxQMFi9C/3+n/F78wMDry8Af9sCP3/bbe36dWUYSnvqjHVImu867U2E9FNIEvtqx0Fjlo54wKYn1Rvl9u9B5NWQ2p7n0yYFhrTJvuc9/OzkLk044KnEQo0b6HeQrBT0qUlKLQa46TY5wXCxpphiQIhn0SDsm3RF4gfetUo/NkeIyg/Nvm1oKyb95QL2xolIWlQxftSLSBtVisCok24UEqfjkaOp3G5PLYBBbzLrrWcl/b2+w69Y0dU14NHS15yRFeOORDzU7FMGyqJXhgj3SAcrg2Jc+q3pL3d0rFRdLDoPgleJT4gm31XyrVMdVlGomBiNW1AY5ZOLC3Vhr7xDDRnsmjw4hGO5DjoidfgQm7/L6nkJvQQcaRHCJkwnORddwF7eYq/6slolb7n2sBvyjF8ZihiipgrsUuSR2q2BBPhbxXplnZ87umtqXBYfMY0GbPM8rqa/ZOLj0XrzHNJ0/N2IrkpQAccP4bWTdr1XbHfCeHlNrEnBZaQ7Qv+2K8E2CZq52vE25z8OIOGdiGPcjML7wfr5S5uom4a+BwTwz1NYfYSCGDAu3u4AdsXwAlUJIuzM277dJ2ElKRxl2iJhAB8q1OAeu8GAhUKLlXwX60AogabLTsGgsEy8R4iBRQ0Z+OgKgeT4cm81TG6ufG2VnjgOP1K2zYBCgfPzLv0PSLBX8MMqBGPA4zf/e9Ss9ypeejlBBLf8xiDlKGr42ymoOaN1z1BpBvbqy+zMNVo4athuwkxZUPaYT4divJk9cEU1HD9gBIuLbytmky45w33wfJaE7OeE3bBpGz6wmT7m5p+SoYwzrJJkp/nxTBPdZyQJRk/rGZjRQyFBQ49GbJcqva8GNmfm2wY6emZymF6o/V7aW
 ijXcqt2I
 48nEb5SUayqSImY3GrakCFUbfY7WeYn9WT11MFKsoAP5Tr1DPT0NfnPWFXv1I90DKEuNTmMwK8CbMPxy2dxRvhjZyyW0WCcdg6MJpJhtlNHN4Gyy+1f9nkTA3rwtKFX768FgJ9mhaSj771X01mjOVvHrzsK82KTrfFGSdXjk9HXWiW5rHSje0ZuFsREO8M6WR3JgOjOv/YjIH4YqRhxC4+UvwIkE8xG24mjgLaDRaqvWxHz5lZtcTj7rAC5GdFcfgHn4/QiTPtkduh6aZLH8guynFjdkIXrVpunUE4p/1TpuKp2IyFM3mq/auo2sD1cF2XVgIgsmwpNijXdUvUTFeiEPjRmmRBF4aCCI0kdQ1hRwn/+4BU5vloxkG94NlDA5rqdyrvLl62Lka/O076jVPL7fM5/d9XFMQ/w8bCUK2gYMEcfGsPs7OXrlCLNx/H/hFvg+NnN7mD0s17WMFMaLnWUakgVP4ir3Fj30PxP0bFJzYSgk9PzE89EPIBtlLmq6JjeqPSIXUQlhPQZHyR6IZ9t1vMvVoys3xiMhUuAMq+qznSdHwuzv++Mql7kWQsNxydjq8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The primary goal of the folio_split_supported() function is to validate
whether a folio is suitable for splitting and to bail out early if it is
not.

Currently, some order-related checks are scattered throughout the
calling code rather than being centralized in folio_split_supported().

This commit moves all remaining order-related validation logic into
folio_split_supported(). This consolidation ensures that the function
serves its intended purpose as a single point of failure and improves
the clarity and maintainability of the surrounding code.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
---
 include/linux/pagemap.h |  6 +++
 mm/huge_memory.c        | 88 +++++++++++++++++++++--------------------
 2 files changed, 51 insertions(+), 43 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 09b581c1d878..d8c8df629b90 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -516,6 +516,12 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
 	return mapping_max_folio_order(mapping) > 0;
 }
 
+static inline bool
+mapping_folio_order_supported(const struct address_space *mapping, unsigned int order)
+{
+	return (order >= mapping_min_folio_order(mapping) && order <= mapping_max_folio_order(mapping));
+}
+
 /* Return the maximum folio size for this pagecache mapping, in bytes. */
 static inline size_t mapping_max_folio_size(const struct address_space *mapping)
 {
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 0184cd915f44..68faac843527 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3690,34 +3690,58 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 bool folio_split_supported(struct folio *folio, unsigned int new_order,
 		enum split_type split_type, bool warns)
 {
+	const int old_order = folio_order(folio);
+
+	if (new_order >= old_order)
+		return -EINVAL;
+
 	if (folio_test_anon(folio)) {
 		/* order-1 is not supported for anonymous THP. */
 		VM_WARN_ONCE(warns && new_order == 1,
 				"Cannot split to order-1 folio");
 		if (new_order == 1)
 			return false;
-	} else if (split_type == SPLIT_TYPE_NON_UNIFORM || new_order) {
-		if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
-		    !mapping_large_folio_support(folio->mapping)) {
-			/*
-			 * We can always split a folio down to a single page
-			 * (new_order == 0) uniformly.
-			 *
-			 * For any other scenario
-			 *   a) uniform split targeting a large folio
-			 *      (new_order > 0)
-			 *   b) any non-uniform split
-			 * we must confirm that the file system supports large
-			 * folios.
-			 *
-			 * Note that we might still have THPs in such
-			 * mappings, which is created from khugepaged when
-			 * CONFIG_READ_ONLY_THP_FOR_FS is enabled. But in that
-			 * case, the mapping does not actually support large
-			 * folios properly.
-			 */
+	} else {
+		const struct address_space *mapping = NULL;
+
+		mapping = folio->mapping;
+
+		/* Truncated ? */
+		/*
+		 * TODO: add support for large shmem folio in swap cache.
+		 * When shmem is in swap cache, mapping is NULL and
+		 * folio_test_swapcache() is true.
+		 */
+		if (!mapping)
+			return false;
+
+		/*
+		 * We have two types of split:
+		 *
+		 *   a) uniform split: split folio directly to new_order.
+		 *   b) non-uniform split: create after-split folios with
+		 *      orders from (old_order - 1) to new_order.
+		 *
+		 * For file system, we encodes it supported folio order in
+		 * mapping->flags, which could be checked by
+		 * mapping_folio_order_supported().
+		 *
+		 * With these knowledge, we can know whether folio support
+		 * split to new_order by:
+		 *
+		 *   1. check new_order is supported first
+		 *   2. check (old_order - 1) is supported if
+		 *      SPLIT_TYPE_NON_UNIFORM
+		 */
+		if (!mapping_folio_order_supported(mapping, new_order)) {
+			VM_WARN_ONCE(warns,
+				"Cannot split file folio to unsupported order: %d", new_order);
+			return false;
+		}
+		if (split_type == SPLIT_TYPE_NON_UNIFORM
+		    && !mapping_folio_order_supported(mapping, old_order - 1)) {
 			VM_WARN_ONCE(warns,
-				"Cannot split file folio to non-0 order");
+				"Cannot split file folio to unsupported order: %d", old_order - 1);
 			return false;
 		}
 	}
@@ -3785,9 +3809,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
-	if (new_order >= old_order)
-		return -EINVAL;
-
 	if (!folio_split_supported(folio, new_order, split_type, /* warn = */ true))
 		return -EINVAL;
 
@@ -3819,28 +3840,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		}
 		mapping = NULL;
 	} else {
-		unsigned int min_order;
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-
-		/* Truncated ? */
-		/*
-		 * TODO: add support for large shmem folio in swap cache.
-		 * When shmem is in swap cache, mapping is NULL and
-		 * folio_test_swapcache() is true.
-		 */
-		if (!mapping) {
-			ret = -EBUSY;
-			goto out;
-		}
-
-		min_order = mapping_min_folio_order(folio->mapping);
-		if (new_order < min_order) {
-			ret = -EINVAL;
-			goto out;
-		}
-
 		gfp = current_gfp_context(mapping_gfp_mask(mapping) &
 							GFP_RECLAIM_MASK);
 
-- 
2.34.1


