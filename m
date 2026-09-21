Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B159C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 19:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FF766B009B; Mon, 21 Sep 2026 15:59:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B04D6B009D; Mon, 21 Sep 2026 15:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED386B009E; Mon, 21 Sep 2026 15:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A57D6B009B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:59:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 966721A02B0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:45 +0000 (UTC)
X-FDA: 85238834730.28.7B1F762
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC9FE20008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:59:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiU691py;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790020783;
	b=EnBMiAZUdyUx9wOX9UQbx2gQLYmqReWeZwuZE4GaaPISqi/Kt1v6MnVkIkRIruCjL5WLES
	lH3YMvO99dQ+iHMW5xPC6DHKOXlveatRncqNqpxzlFzAMkU56CEhuMoVWInWSNNcQbYxx5
	ELmhLdJpyCuBvI8MLuvJDUnk/BvXqQM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aiU691py;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790020783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMtBSn8yOXnXVar79nWZLJEdBKm3qvESfKRbNGf93Xs=;
	b=b6Bp8QBWnwJsN2o6fiQbkyvycAnpqjmGMtKhBSsMaGSj4Rb2skq6x2MPZNMVUqS32JNcoI
	bCyDloK8sjmNBnw1WHI8YFTu8mxcGv3+pFk9krL5cxQQzrLqFdjhh9HnTRsrE3dkU3Boos
	2ncMz0Lh25yFx8av6+Ltzasu257fDS8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C5D8601F0;
	Mon, 21 Sep 2026 19:59:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD141F000FF;
	Mon, 21 Sep 2026 19:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790020783;
	bh=DMtBSn8yOXnXVar79nWZLJEdBKm3qvESfKRbNGf93Xs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aiU691pyrUYYyQxU9eU70qvyfBU8JxpmY83EEdT3A/04/6eqGwjXGwdaMTlulVnnf
	 9HFfooLmHjLrL0gE/kIl2vA1lVlP7vj2TOBdK7Slr35sdJ3fPiZoUYK3Pf3m3P62S0
	 JC4XZgaDwFcE6sMhmvqcRYR9F5B6CSVLRRsdjLTd4M5SJGc6BrPVNLARqh5yRpEOR2
	 aXQlz6B7Pxjtfq0dcM2prmQdsj5E66edwcStVbsf8tbBKh/1EQTV4XnxN3cYxJBRHk
	 paxFBqavHzIYpDYbLZBIM1FZs//LAy6gjSZuVytKFapn7niPNpQ2N8X6wqBYT8lsUv
	 3l4S/s+BAGQkA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 21 Sep 2026 21:58:55 +0200
Subject: [PATCH v2 03/13] mm/sparse: move initialization of section
 metadata to sparse_metadata_init()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-b4-sparsemem_cleanups-v2-3-54d81d65e125@kernel.org>
References: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
In-Reply-To: <20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2577; i=david@kernel.org;
 h=from:subject:message-id; bh=3LdazTbWXikkHaUL3kEHoOoL94yCObwwfPuFbE1hFoY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI29rR+PSAo+0AmduX8rVPz3oSf+Dmlz4n5l4XIlOz4y
 U6PP5q96ihlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiKmsZ/occ77274PbJD6v0
 mRKb9fw7RGcvO+l2Re6mxOLm9CdFU5wZ/me/9j3RbrhlwfwTjvzSG5JrMv3bTlisn3dxduFpRYM
 D0nwA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC9FE20008
X-Stat-Signature: fe6j3hyr7mc8hqk8mjzrdfictdz7pcrj
X-Rspam-User: 
X-HE-Tag: 1790020783-653287
X-HE-Meta: U2FsdGVkX1/P1XoZCB3hqUD5wHK8hhORrqpdYvMdwv63vfOSKNoV3pnp6hfExJDmAL0ZQ/ANHSlMYpYRRyDrbBhc3mCbuv20tPPXXRsArT1S5tck+rfOKoF2Q1EB+vrmnkNqq/gvqJPxzRuLtwxIZLD06PjTv7iaFQFugZZVULSWXyIpT5LGOCKMGzRR+k39h/Uh4lVQvUlPktZkhodXsUlPVIfaJfyUM7sy9sruC7bpWw3rlHArIUV1iwHfejJ8CtKUbz/vRKc8J29xpwPyx2U351z8Xqs8hgrODMUqck6MxbkkcwgEpgo2Ldlegg8AWCEfmqKnIsEFhR/WTZzQjAib9OSLKA1c1v4iSvwfUjxOnhU/C6+yZLVjVmNo8AxGruv0P820x0f1H2WQQoUb6Yqv3hQ+QKcswT0tPYGin5T262Y6FxiN4KaUEE2/aUP2TWGEBgueM3d+ZOnrT2AuLSe7iRXefGt3C7hW2RLF7b1iAriDagT9Wc4WXekseSvpSRU+2tQmljnQWoXc4I/uDFOoJ33dyPwG0pYe+gG4DF/xJg3kwi2fc7Oqo0ZgbXHkGce1Edz/xAj200TRiGBu3w+rrUYT4W/Hs063cUZpZ7rlicFQHayfjS4lH7l4e/yjje6OO52RKjNaF4arj8W7jQ13Dc6aJpxlDtapTuG2TelCr3Vrt4vLfYgcfSAkUXUf4EZ04s/4i5nlra4jpVTG26UwN6XLg4DdP8szYEUeZxzVoHwJZux1RT61ceAI/7OZE0054Q2cDqr5CVRCP+eOVNT5K0OCtYJsH6TtfkWIiJ/y3aP9oWfs0+Xvp0IAqepCJw77b9iCm/3mMZwi3s+cljpSGm5AatCxieCWFGs/Z9KD993P7LIa7mRE+/5WBrHGT2AhMYXcCOYErvbqLpYMK289qEaW0e+uWwBQJ34amITnwVZZc3f1tUQyt9Ra2PZzReBGee+fMgFGhy5zUbK
 rD0Bm9it
 QI5GK4jSkIrr+wHov3qz9knA15a83YmCi++CnyHYhNMzcJ0ljgxMm6STI/uaBlabkhuKP1iWKEGY5kqchAoLveCV3Fw7nA5AoISCBCno5X9lQr/pQvTEoPCywf3P90wH6vOLCRO+GZAmS7Q+XbsfyeC4x58eS0Bqw05uzvbWjTIsRgy00kwIg1i3GthRHn/NhxF+t1Rh1tXPVNDXpgA+cfVW8gEXK2dX50XqJIQ9akck1Eeh6Sar4wStfgXMmJPGbFuLQo/tz0wbQE8UeaqB8TrAbTb0/jRneelN5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's move the code responsible for initializing sparse metadata (usemap,
memmap) into a helper. Cleanup the variable while at it (e.g.,
"map_count").

Drop the rather obvious code comments.

No functional change intended.

Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 2b285653abf1e..71288daeb3665 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -255,38 +255,39 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
 	}
 }
 
+static void __init sparse_metadata_init(void)
+{
+	unsigned long start_section_nr = first_present_section_nr();
+	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
+	unsigned long section_nr, nr_sections = 1;
+
+	for_each_present_section_nr(start_section_nr + 1, section_nr) {
+		const int nid = sparse_early_nid(__nr_to_section(section_nr));
+
+		if (nid == nid_begin) {
+			nr_sections++;
+			continue;
+		}
+		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+		nid_begin = nid;
+		start_section_nr = section_nr;
+		nr_sections = 1;
+	}
+	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
+}
+
 /*
  * Allocate the accumulated non-linear sections, allocate a mem_map
  * for each and record the physical to section mapping.
  */
 void __init sparse_init(void)
 {
-	unsigned long pnum_end, pnum_begin, map_count = 1;
-	int nid_begin;
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
 	}
 
-	pnum_begin = first_present_section_nr();
-	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
-
-	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
-		int nid = sparse_early_nid(__nr_to_section(pnum_end));
-
-		if (nid == nid_begin) {
-			map_count++;
-			continue;
-		}
-		/* Init node with sections in range [pnum_begin, pnum_end) */
-		sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
-		nid_begin = nid;
-		pnum_begin = pnum_end;
-		map_count = 1;
-	}
-	/* cover the last node */
-	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
+	sparse_metadata_init();
 	sparse_init_subsection_map();
 	vmemmap_populate_print_last();
 }

-- 
2.43.0


