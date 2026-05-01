Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3F2CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97ED6B00AA; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFB9B6B00AE; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC0326B00AD; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ABE996B00AA
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F0241C0159
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:21 +0000 (UTC)
X-FDA: 84720079122.10.9AAE851
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 67436100003
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oQObQMgm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zGqjzrYflldBY5h/orQnCvSEAg1aeWym/QQV/p6J7iA=;
	b=zmvT0VMDSXlFPEf0ciNnTeAKx+CIkCKp747l1a+jrgKVeoo/h4rNJxEU1cmXacaSCHD5cH
	ypgE8RtMq5S75S2SqeqhcxUcOsiizg0FxH/8z+bDqHZBeY1eph243nYWvCzMCuEteW7Yi/
	HB/s8Ws8zz6/JFT9K2rwNzoguXJeqzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669459; a=rsa-sha256;
	cv=none;
	b=hIuLSYTMjGuVNUj80pBLpxsNx/0S2Rei4kDGgdSRT+3if9dI2BuI32nPBN4VOIQaJoKPbs
	1GOzZkGLi+LG5CNpyyqCHu4ZUSqelsHwb3hHLHC1MB7sAgniy8aOqpmRJ84dUnp7X4agwN
	Y86FArsYOmAusJ8sxrZCjQkmWjll8Io=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oQObQMgm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCACF43A73;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6655C2BCC7;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=Ftr4whPMGYa53GufT+XufxiyT6tMyEQKBh59LOxSBJg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=oQObQMgmFXVM+ojV1ZQhu2uRkqYo1dWgZeEHTqq7n0bTL1gBkGrarL6XzRMHWhA6d
	 Fy8F3sWH++ILt09ufGzg2DqedIzH0Tvs4oEn2SngyuFPkIpElaoluAe2snmq9to+zl
	 gDRftzA/xd4E+Se18cfLrNQ2MyCr4hazdtAk/t4PWFrMptTIUFZl/LcBx9JOu8ccdg
	 gvAjezGliysBGiQVm6HCZDPtxATW3h0p8onipO7xouF6RhVnQkvl0tT856xBa2afNR
	 OXfWDdKfSWZq0mgV01vR9ORYo6xkPP+ZbUgf6qa5WyC5QAQOocIXLOWEVlzlSlSUeC
	 8QmZhkm7PGqug==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC107CD3423;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:09 +0800
Subject: [PATCH RFC 23/32] mm/workingset: rename the nonresistence age
 counter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-23-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=4861;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=RZ75CFKx9NHBtI4cGuTrtP6eqoZNh7E9CBvqbHcahSE=;
 b=6CUaoS9oIH44bJ2AntcJ9Npik2Ryxt5O6dYw7eQBmQWbjWLTWtWLbYQjxusIpbsC+fbHre9/X
 LYWbK2P1T1OCsWFUfQfEBXJKiNAl+i7YwNq4D52rScVPa3Jkg1GqBLa
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 67436100003
X-Stat-Signature: zxx4qj4mu4aafpamem97c97csiz645a8
X-Rspam-User: 
X-HE-Tag: 1777669459-159821
X-HE-Meta: U2FsdGVkX1/jl9sT+UIGyfyL9VzBYeiST980sH/bDAW1LGNmeVHUk0g9lNjnnQRHO7JRoDzG0aP5AdOAYNqkIoD/qrG3chJJq/rHt7En5C9DG0mWYpOx0fBx5hsy78uAuPMJs38FlUdw0j2x0ehX6wK79LrnWYsdo0dgw+Du8f4fHPrYNJB0aGLm2uX7Lz8lSE2JfmVisM6Lk2RkP41CU58ANZAM13Bkle6kuhdX/Y0B7X9lU3akZwc9jBYT/82jaywDv4STIvUvH/OpjyFbat1XBoOnrwV1f7d779NuydmO0Z2Vs+pPd1ZoVmt3/7jPYo3tRO7hcJua8CB5ipKtFAqZqcnj4Ik04LYqe6r2faOmqnz9gAcbkRmROM5P66/9+9lPSpimlobC3un6Y9xC+2LkQqAfkjxshEdCAzsypvTz3rx+4Q2kN0wUDZT8lnGVhyHtPdhna85L8EZHbSPusGyZAqX99JbFJdrCpzqON7vaS+baKyu8pU19QFXx5aq+Vqmu5v/JpMVepF3EDuMz41USoPs0j9vSrcRQry32PCEILXGQ9bOzuR8Z9KQZM2/n4m6hWpb8XFIg4T2aliqjwgJY+wIfzgoO0LJwePQA+Tark9rlWODSSjuoLn9AydqvJV1TcgsXYW3vqHzP7eUKNZTuE1BG2z++NojeBvKsjAG1vgCisY/FDGhs8ArNoIPZxWMBByZ8lBQjUACiD2y6nv5EpcvoGULIec03noUQDMhzq8ZDygkRUnv/Kh+Mj3vxXr020HwizLAsH/hnR2sLV/zD+8m1zr9Io3Dek5/ZMYor/Ik31WUJvwxJQJ5LPZTjlmQGwR3lw7IulD8UCK19fC9IlmRK8+nvCHcv6pzksaUJSP4XTHdQzbVsUnq1qemXnx4xYwsEUz7bC6WNUbrzDfP+nIPfhDIxPAI9r00UrjST9m3G3VHsMVxjYk2n3c/P+0bLnV9dX+J21rjM/Gw
 9O12AalT
 IyMDnBSMcCHA6dm4rljxzCfyuxd6yLw8K+UJ1tNpgzFerUpj9iXpRDneLTqQuk4j+loMrIzQ6SQvjpAIG8o0LjGIfeQ/u63rnNCAAYbGwL4HQBtiwK+5JV40/2d/tbuQp1IkkRq1na/MgcO4lWqg9kE+fSQlh/cX0Acgs66yht/pS+KJRf2v/VQz8aW29WXE/CpPQQO4xePC1i5VOjvVNm+V0mhZmM6dm/QuPZvxp4d+D36IVkqogaeaYIFIUnmaGDPBKaBL5WKnOKQvcJUzJP2Ajnw+c9pPt/qssT126BcsO5/fScFtVbP0QGeDbNUqthLC56wHbVXa0f2q+wZbZcqF9PA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Clearly, now nonresistence_age just means how many pages has been evicted
from this lruvec. Rename it.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mmzone.h |  4 ++--
 mm/workingset.c        | 27 ++++++++++-----------------
 2 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 393bbea75838..6747e1c6079c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -799,8 +799,8 @@ struct lruvec {
 	 */
 	unsigned long			anon_cost;
 	unsigned long			file_cost;
-	/* Non-resident age, driven by LRU movement */
-	atomic_long_t			nonresident_age;
+	/* How many evictions has happened */
+	atomic_long_t			evictions;
 	/* Refaults at the time of last reclaim cycle */
 	unsigned long			refaults[ANON_AND_FILE];
 	/* Various lruvec state flags (enum lruvec_flags) */
diff --git a/mm/workingset.c b/mm/workingset.c
index 01f6e9a72cdb..aac68cecdfbf 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -66,12 +66,12 @@
  * thrashing on the inactive list, after which refaulting pages can be
  * activated optimistically to compete with the existing active pages.
  *
- * For such approximation, introduce a counter `nonresident_age` (NA)
- * per lruvec. NA is incremented once for every evicted page, and each
- * evicted page's shadow entry records the NA value at eviction time as
+ * For such approximation, introduce a counter `evictions` (E)
+ * per lruvec. E is incremented once for every evicted page, and each
+ * evicted page's shadow entry records the E value at eviction time as
  * a timestamp. So when an evicted page is faulted in again, we have:
  *
- *   Let SP = ((NA's reading @ current) - (NA's reading @ eviction))
+ *   Let SP = ((E's reading @ current) - (E's reading @ eviction))
  *
  *                            +-memory available to cache-+
  *                            |                           |
@@ -143,13 +143,6 @@
  *    the benefit extends across a broader range of S/M as a smooth
  *    transition rather than a cliff.
  *
- * A secondary effect: NA over-counts pages that are refaulted and
- * then re-evicted (they contribute to NA twice over their lifetime),
- * which inflates SP for older shadows under heavy refault churn. The
- * feasibility bound SP <= NR_ACTIVE would over-activate in that
- * regime; tightening to (A+I)/2 dampens this without a separate
- * correction.
- *
  *		Refaulting inactive pages
  *
  * All that is known about the active list is that the pages have been
@@ -180,7 +173,7 @@
  *
  *		Implementation
  *
- * For each lruvec, a non-resident age counter (lruvec->nonresident_age)
+ * For each lruvec, a non-resident age counter (lruvec->evictions)
  * is maintained. It is incremented once per evicted page.
  *
  * On eviction, a snapshot of this counter (along with some bits to
@@ -390,7 +383,7 @@ static void workingset_age_nonresident(struct lruvec *lruvec, unsigned long nr_p
 	 * the root cgroup's, age as well.
 	 */
 	do {
-		atomic_long_add(nr_pages, &lruvec->nonresident_age);
+		atomic_long_add(nr_pages, &lruvec->evictions);
 	} while ((lruvec = parent_lruvec(lruvec)));
 }
 
@@ -421,7 +414,7 @@ void *workingset_eviction(struct folio *folio, struct mem_cgroup *target_memcg)
 	lruvec = mem_cgroup_lruvec(target_memcg, pgdat);
 	/* XXX: target_memcg can be NULL, go through lruvec */
 	memcgid = mem_cgroup_private_id(lruvec_memcg(lruvec));
-	eviction = atomic_long_read(&lruvec->nonresident_age);
+	eviction = atomic_long_read(&lruvec->evictions);
 	eviction >>= bucket_order[file];
 	workingset_age_nonresident(lruvec, folio_nr_pages(folio));
 	return pack_shadow(memcgid, pgdat, eviction,
@@ -501,17 +494,17 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset,
 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
-	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
+	refault = atomic_long_read(&eviction_lruvec->evictions);
 
 	/*
 	 * Calculate the refault distance
 	 *
 	 * The unsigned subtraction here gives an accurate distance
-	 * across nonresident_age overflows in most cases. There is a
+	 * across evictions overflows in most cases. There is a
 	 * special case: usually, shadow entries have a short lifetime
 	 * and are either refaulted or reclaimed along with the inode
 	 * before they get too old.  But it is not impossible for the
-	 * nonresident_age to lap a shadow entry in the field, which
+	 * evictions to lap a shadow entry in the field, which
 	 * can then result in a false small refault distance, leading
 	 * to a false activation should this old entry actually
 	 * refault again.  However, earlier kernels used to deactivate

-- 
2.54.0



