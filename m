Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9A65606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 10:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=EAqwmjiy
Received: by kanga.kvack.org (Postfix)
	id DF1286B05B4; Tue, 17 Nov 2026 05:53:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC86C6B05B5; Tue, 17 Nov 2026 05:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06336B05B6; Tue, 17 Nov 2026 05:53:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABE666B05B4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:53:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D3E11603B8
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:53:41 +0000 (UTC)
X-FDA: 85444300242.13.E50C70E
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	by imf08.hostedemail.com (Postfix) with ESMTP id E177D160002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 10:53:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EAqwmjiy;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794912819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT3Jad9DgAzKR5zvAS87Ds5ad4/2/jBDqrtkMOTLmbM=;
	b=u2IDY5V8p7BVdSgMyClJws+YeMhQwy0Q9f7+Hk83OzgQ526taVcV//wFV+vPvYK+vj/dQe
	4kNVBdSj+gjJXRrhSqOpiWJlv9dhuXWXtxetDwLODCvRitueoF2tEEvcb3AKwoE6wMSsAG
	9TD11Ab/795WINhDWSI3IOJfql2GbNk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794912819;
	b=UGEN9KExwMvV5URfPNFL/n5prhgxzeXPxdPuBxT+860RzbSO8o7wV98mrKb3uGuviBlJHf
	9V+N3cP/Nv6bCS+mkkca49TCknBiRwl8dy7BeUnl4vEjdsi3aSj+wDNctLimJL6mBUNXCy
	WOgWzBqipK862zovUKt88o6c5uCpjcI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EAqwmjiy;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YFNiLL0I2m3i/6cux7HexDCrpEBYBYGPhPSttFoXzUo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794912817; v=1; x=1795517617;
 b=EAqwmjiy79+Z5SgK11fBMosiZI3dH19WB4qihM+Fle0FvohwkOd9AgN1nA8IddLGqyLrXFuw
 oJZox1IhvoJ372DRxL1YlnhFvwvgVvVEBJkqYlFkOkNhBAA8Z5DCBek5XSMCXBIp5ZStd258rer
 IW640LClb/zsCeZ+KxXXvMZ0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 97a83f3fbac5ab3b;
	Tue, 17 Nov 2026 10:53:37 +0000
X-Mizu-Trace-ID: 97a83f3fbac5ab3b
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
Date: Tue, 17 Nov 2026 18:53:12 +0800
Subject: [PATCH 2/2] mm/hugetlb: remove the gfp_mask argument from
 alloc_hugetlb_folio_reserve()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261117-for-memfd-v1-2-fa68f433171e@kylinos.cn>
References: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
In-Reply-To: <20261117-for-memfd-v1-0-fa68f433171e@kylinos.cn>
To: Hugh Dickins <hughd@google.com>, David Hildenbrand <david@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: hongfu.li@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Hongfu Li <lihongfu@kylinos.cn>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794912797; l=3157;
 i=lihongfu@kylinos.cn; s=20260915; h=from:subject:message-id;
 bh=IjnOZZrnZDKRLDKXw32+ol/AbXDeQpA8yo/PMl1put0=;
 b=aoZXwGlYQYYqDn+g+4J6nl2sZww5iBP8Mz0QhL1bZCaCmHxrvz7lIcPdeOHvFAV9roYI82w8y
 OCn7pyxA1VYBEateZai1fyl8qKGeJuurzqktUPxlmZH3aIf+j//3fYv
X-Developer-Key: i=lihongfu@kylinos.cn; a=ed25519;
 pk=rUpDSpB3neoNZRlGG6dHlFb3RepiJakcev+ucyqaZzw=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E177D160002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1htpsym54hruurorfpcrobwae9x54fok
X-HE-Tag: 1794912818-77821
X-HE-Meta: U2FsdGVkX1++qbB2NqpGFHb7aAlMDpo5r9vv9kFjQyk1ENqYcMNlx/4RBP8J6DLOGnLQ4ndO2La6LiscpXkqcA2roNXnT8tqcYbw9WDydCDlgUK00/dFrIMtYiu72yNJAf7rZQxX3uzdaQRcvKkc60GazFO4kXdauhEoWbJLDHP8iKucINRfH3FaX3g82K6y2iIv2oc9/RPCbkeNFJ4cTG6RO7NbjMZGL38HIuXsBTdh+BDY18DXJQr0mGydVmq3Zl1fhQvrPzno+AtnXkibnryRpdhO8UAKSbM9mXG3EGkDHT2Bdj/sNLK2AY/hJ53b+0afbbLAr/HZQ7lUvdSiGR3kcStQKeaC+9h7xQUnw0F9NyDhXne4JOSfjmsjgi1EyX+47GMtau/0PRy4N9XR8TlNhRcgznN6xDaUmBb77G1J7ua92QsO85FYpf5RkmoZf23SxcS9QY+dDm1v7+XVeWac/WOq2yGDE9FNdmkAzomNYbdzcHAk6qFMElyGQR/yn9y0Y6+SgEM+ljdhCfbOV+cSspyzzwjlD5oa79z3VwZHf3dASaaI6GGRAvJPpxhEXt+zhIybPvmXrElI9ArA3yDAvezCI6ohwSxjxsa7yAPp4mPT65HSoSs0BgBbRmcW32WoHSA28vE94YaLB7KoD9smXL3iEycYSaeGu3MechaDOoYIE/tkdcx2bBcy8IiJGnvhFqxnNbsEW5onCXOHJICt9sbXbJ1eVp92WHZrfdv6rVjFV3mbEubJ7aqOyX6LSl2yV8PP352sqrfcr/vkS1gNNcBiGiFkJu/C/+mOtyywJEOQVF+omucMWu2VX5zUbXJe8RBeVPqGZbeNHOHW1i2vcT6UWQLjPrAN5APqq44TmkvtehnTzz/7UK02De/2m1RT8P8pjby+0OVPkXHjaTB0Tu9LekD0wGEKbyOZTDTgfB1AHnZQTwyupdk30xlrqK80w5+xcFv1z3/0jsZ
 7VVzqpRs
 fe1bN8bOGlDp0wr8y7NtvkGdRbyFaqLYiBjCYU05kSVmJNi9gFGU8hoJf5Hj6lx2+DcWZYWRtxtmYFmPCWdlYS6h/bYG1Yt9s3+SZDLT3KSqBpaT8PiXiz6xxL7REpPm5HN6w2SpZssVbPKlA336qN5X0RV/x1kxwMGBiGWO2WSXyyFxi+gsEy8Coap9sJovw+EUnj29hP1Qm8+bbUfo9NTvqzJ6VflzHAkLmuI/uMavuXXWlPIicyT6+cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Hongfu Li <lihongfu@kylinos.cn>

alloc_hugetlb_folio_reserve() takes a gfp_mask argument that
memfd_alloc_folio() always sets to exactly htlb_alloc_mask(h), which the
helper can derive by itself.

Derive the mask inside alloc_hugetlb_folio_reserve() as
alloc_hugetlb_folio() does, and drop the argument.

No functional change intended.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 include/linux/hugetlb.h |  4 ++--
 mm/hugetlb.c            |  3 ++-
 mm/memfd.c              | 13 +------------
 3 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 69732e4cc03e..a88c59476e79 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -735,7 +735,7 @@ struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-					  nodemask_t *nmask, gfp_t gfp_mask);
+					  nodemask_t *nmask);
 
 int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping,
 			pgoff_t idx);
@@ -1161,7 +1161,7 @@ static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 static inline struct folio *
 alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-			    nodemask_t *nmask, gfp_t gfp_mask)
+			    nodemask_t *nmask)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 88c9aa700533..e84203406da3 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2221,8 +2221,9 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
 }
 
 struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
-		nodemask_t *nmask, gfp_t gfp_mask)
+		nodemask_t *nmask)
 {
+	gfp_t gfp_mask = htlb_alloc_mask(h);
 	struct hugetlb_cgroup *h_cg = NULL;
 	size_t nr_pages = pages_per_huge_page(h);
 	struct folio *folio;
diff --git a/mm/memfd.c b/mm/memfd.c
index 8905e3e9efc8..08b9d54b0d8a 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -69,22 +69,14 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 {
 #ifdef CONFIG_HUGETLB_PAGE
 	struct folio *folio;
-	gfp_t gfp_mask;
 
 	if (is_file_hugepages(memfd)) {
-		/*
-		 * The folio would most likely be accessed by a DMA driver,
-		 * therefore, we have zone memory constraints where we can
-		 * alloc from. Also, the folio will be pinned for an indefinite
-		 * amount of time, so it is not expected to be migrated away.
-		 */
 		struct inode *inode = file_inode(memfd);
 		struct hstate *h = hstate_file(memfd);
 		int err = -ENOMEM;
 		long nr_resv;
 		u32 hash;
 
-		gfp_mask = htlb_alloc_mask(h);
 		idx >>= huge_page_order(h);
 
 		/*
@@ -101,10 +93,7 @@ struct folio *memfd_alloc_folio(struct file *memfd, pgoff_t idx)
 			goto out_unlock;
 		}
 
-		folio = alloc_hugetlb_folio_reserve(h,
-						    numa_node_id(),
-						    NULL,
-						    gfp_mask);
+		folio = alloc_hugetlb_folio_reserve(h, numa_node_id(), NULL);
 		if (folio) {
 			/*
 			 * Zero the folio to prevent information leaks to userspace.

-- 
2.54.0


