Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D071CC53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:25:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677906B00B2; Sun, 26 Jul 2026 18:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F096B00B3; Sun, 26 Jul 2026 18:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479F86B00B4; Sun, 26 Jul 2026 18:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFC76B00B2
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:24:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 624BE1205D0
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:24:02 +0000 (UTC)
X-FDA: 85032356724.23.60C8EC3
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id B4C48C0009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:24:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NweAl4MS;
	spf=pass (imf10.hostedemail.com: domain of 3_4hmaggKCAYpgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3_4hmaggKCAYpgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sE7JJfWSnmXwNSqLQXzEAPpj56tITjEMwhehkr9vEgs=;
	b=AR7MnRD/+uW42B7qwRSxsiYRfDKvqLURkKwmpslUVoIcPv3QgdpncNFv+nteo2WEh1FZcZ
	h4rfdwyY61OSFaI3Xe0WHzeYU845xerK5vvskQJqyTrQYGgZWeHQUG6bhq+pbJYhR+qMaV
	L2pGY2amcbhUXG8paYl7Xl6QSuAxbu8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NweAl4MS;
	spf=pass (imf10.hostedemail.com: domain of 3_4hmaggKCAYpgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com designates 209.85.221.69 as permitted sender) smtp.mailfrom=3_4hmaggKCAYpgiqsgthmuumrk.iusrot03-ssq1giq.uxm@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104640;
	b=wwuWYRWdYCM0awOewjUP12bQoSWrBuacHxw7HCIRoeCstMEe5Z0YBxNyCGW3D5zmqjLHkH
	exPELAzTjgOfomY704TA7uE5uinfqm5Qgb2JVL/OFNCUNZcsuCcvYedRgmgtVFjfyf+cXh
	TfrvpCYbMzcPxkAcoU4fah5drqsReLg=
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f6e8b5996so1987811f8f.2
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104639; x=1785709439; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sE7JJfWSnmXwNSqLQXzEAPpj56tITjEMwhehkr9vEgs=;
        b=NweAl4MS1/EO3TkcvaL7oRofpqSzckouejkEKtcA3dMymnx7J3WKtWVlfCiPIy6zLa
         2FXrE7oSup8cw0d97mRcYqSrmDv3U2hEYIk2bKYsEmIlgY8Y1QLFcLHcBvb9X+Il4ZzM
         e5VYILTZzI7JdT/Suvv8JRUJzUhxV9YyzAmG3UO6lWRwKXJlXqNlBcZJ8xRAS5xzsBum
         U+jpXN+6vKmR4TVDp4mFMQzbcxAY6bgiu2aQv9T1zAzZe6U9/KqRebn/QIN2XZFlL9Gw
         YsQnaEsadIDILfE7LPBNoNvDzB8b8SVi/NpkQzGfHVbSfT4A8b0uohZKo90kbsRsyHJY
         mW3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104639; x=1785709439;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sE7JJfWSnmXwNSqLQXzEAPpj56tITjEMwhehkr9vEgs=;
        b=k4WVNbZs6xPeNyFHorN/Ad84vbvSGEAunESDD0HgDQsvJsYZiTCoNUL5nMyJ/ZKd2e
         KRP6RY99fw/kuahJutL0utJqbAl5s8oQ/GzNdxSPcOVj/gY/C3zZ1AvhK+2CnUgYwEHh
         zqJYtO+oZM+GH3/oYGFoVEnYlTWnMx5JvI+OhtQHbiW98Z7a9AyjJWvOdYpDVUGX++Ix
         EfqOumhAsmtxMHH1wTG7f80HTv43t9mDEwtpnpLS2RSKGUZ6t+8oik9NKsnHSxkFa0OB
         a2MDzpqdpI5boOIm4beuIjCfqix7H97nQr+Wgiim/ozXOQMRfK97EBo4C+cs1jplj8FO
         5nzw==
X-Gm-Message-State: AOJu0YxCYvuq0xPrM/45nTsBTVuJM94p3wN0u00vFmvSAzvUVzBlN8I0
	g9O6GsrC2tJzXQgx4Mw4UDZelNjWYHM2lID0O/y35GYg5+ZHxRReBnIOjx6jxmnoMQlyF+YGfho
	rLNUHw+C0FoZvFg==
X-Received: from wmpg38.prod.google.com ([2002:a05:600c:4ca6:b0:495:49a0:9476])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1553:b0:493:e97c:216e with SMTP id 5b1f17b1804b1-496b5731987mr83419515e9.39.1785104639198;
 Sun, 26 Jul 2026 15:23:59 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:57 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-24-6f5729aa9832@google.com>
Subject: [PATCH v3 24/26] mm/page_alloc: always direct compact for unmapped allocs
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4C48C0009
X-Stat-Signature: yx13rzysnmdgn7gi1rmuxtwcp84jfw96
X-HE-Tag: 1785104640-470205
X-HE-Meta: U2FsdGVkX19IcXi2k4v0icNGBTjIX1zcu443KBkYBHeB3nbkYVtJNkq1jNSFG20TXBOYCCZ2TlszuNnRk9ZrQfZDzlkXrVJSfqc4vdJFuxP2DszicRhbxNWQMb1cpIe7SMkoUgjRc8gLOXlSnLcH0tz9+s8r/R3wNV+Jspyf4ppW8Nl2IlJ3nbofCzv0/Ql1C9yO4q2KrJyifK0iZcyRyidggWsSUKtT1dL/mBdOdxp7piENFih5h+LH39zIC8vPFw4qi+ngmkbczxmB+krXcaHlujt25NwQe4eMpTIhmdxK/v67Q1z+8E8AbrZzRWnBY8R0XFy7SBkubduhMqR4zwfm4vNZ3TE8TfMA9wcjpyUUf9cvBe7L0+I+bssGhGrF57i/9S1JrLYDMZP/DlyDr7L/+n5pL1jj2Z33lbVLQ4TrHWJ5L8OmW+ck/TKGh00Dzk3Jq/amhGsEg2mHNnyLsei2w8A2XwON0GwXCAR/LtzSOiHLt27wYkGa/MmfHeVp4yu3q+Kd8t65tiuK7HfAnKU/aA1nj2LgsxruOf6z4Miz6eRU0KM4CUw1J8ADSdHSWysZA/a5amDJDVbmSnR15GLMzIcz3X4RcNNEtFRegCK5veE9lLKIoGB+pSMQdRD/A2lB1+uutpwpT6C5Bf77fdI+JK89gqpouOHJ9WPY1AJGJKYazb3HSacclynPxnr22hdYa2O92Y/k5RSCWVyXs97or5WvpvmhCnKRYQ3rzn4vfVeTP/Fs4rmNym0p8UK5OfqNHt0Hj9qyq6+AP9YdMFKtABuAvzbwy5Dwr+/bk835/KACgpkptkSPqsvZrEOSbrqWZwG1xPMKNoPgu3pFJQUp086TswB8OPqnFBrvjMJ+u6RzU25tqv51sadOjDdSDRgUFPWZSGJnd9s/lPdGIsztVGnIvjRATjpVDicWD7H1/91pkeIMgr9IVySKYFWlaXgONVGZ0r2KRsx4ksY
 S7h0mfRI
 yXNUcweDtXeH9wKGj7usHhqPi1FN2PHFprVYAR+XMmBBLxjwygT/Fq1wmXOnS58rwdE4rSteD8wUbICnhjr6Ygxvu37ZEIK5gFbdEv/4Hm++RFP5slbfgVubBwOggtRGeSHAIKnUEBma+l3LMplGZIiYn2YhtqF+yqwF8GIsowsDFKtYc5onwXCCVaHNoVv0pnRjKl5IIfTpBT99LzuPntlbWcs9sj/anhHiPs38cC1dljHQbZoC9eGv9NbGQ0cnkGSrcYUyt5jQeRPGyBvEoTjQctKTSCG+g4WSKNRHat3b+anK7tWx99QdhMPdrj7BQBVHVA6fvoZdO6lRLGESI7t6zigs6mhN6lbXexjlgiJULA/gE2DFPI4wuzhWD0+zZX7Sjif0jPI85Ipk8lnplH8ZEdVgDZh8f9bY05h6BfqCDJLDBUtS05tVgMPIQglQcO8JReSa3yp7xA8d3WRgmAu/XI58YK+M6bpnk0XT5IkO06c/Xsbj77sLcZk4VapPxOmfIJpsaWMq6ACpwnBEFtbVtRujWC+JJK/MfCAhS9bcVtLyMCMRRqnwe3Dk5Uwda1k+a0OCoVs4VHOmFvi2chaBG++gQDc4aPEcBBEj1HW/JxvMViwKCXUkMmZ27KUh2kYye/DpJkz3kfr0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the minimal solution for ensuring that compaction can service
unmapped allocations. Without this, it's possible for compaction to just
check watermarks and see plenty of free pages, without being aware of
the direct map state, and thereby cause an ALLOC_UNMAPPED allocation to
fail unnecessarily.

Instead, with this change, promote compact_order to pageblock order for
unmapped allocations, much like defrag_mode. Then, check specifically in
compaction for the presence of wholly mapped blocks that can be unmapped
once direct compact is complete.

This all takes advantage of a major simplification: since unmapped
blocks are currently always unmovable, this can be asymmetric. There is
never a need to promote a !ALLOC_UNMAPPED allocation to compacting at
pageblock_order, because compaction would be trying to generate a
currently-unmapped block to map; that will always fail because it would
require migrating unmapped pages, which is not supported at the moment.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/compaction.c | 22 ++++++++++++++++++----
 mm/page_alloc.c |  9 +++++++++
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index ed12d2fc6fad3..fe1aaf293bbce 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2531,12 +2531,25 @@ bool compaction_zonelist_suitable(struct alloc_context *ac, int order,
 static enum compact_result
 compaction_suit_allocation_order(struct zone *zone, unsigned int order,
 				 int highest_zoneidx, unsigned int alloc_flags,
-				 bool async, bool kcompactd)
+				 bool unmapped, bool async, bool kcompactd)
 {
 	unsigned long free_pages;
 	unsigned long watermark;
 
-	if (kcompactd && defrag_mode)
+	/*
+	 * When trying to generate an unmapped block, check the counter for
+	 * direct-mapped blocks specifically, since we'll need to unmap the
+	 * whole block to service the allocation.
+	 *
+	 * Why doesn't this apply to the other way around too? (Mightn't we need
+	 * to _map_ a whole block, to service a !ALLOC_UNMAPPED allocation?) No,
+	 * because of a likely-temporary simplification: currently, unmapped
+	 * blocks never contain movable pages, so compaction isn't going to free
+	 * up one of those.
+	 */
+	if (unmapped)
+		free_pages = zone_page_state(zone, NR_FREE_PAGES_BLOCKS_MAPPED);
+	else if (kcompactd && defrag_mode)
 		free_pages = zone_free_pages_blocks(zone);
 	else
 		free_pages = zone_page_state(zone, NR_FREE_PAGES);
@@ -2599,6 +2612,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
 						       cc->highest_zoneidx,
 						       cc->alloc_flags,
+						       freetype_unmapped(cc->freetype),
 						       cc->mode == MIGRATE_ASYNC,
 						       !cc->direct_compaction);
 		if (ret != COMPACT_CONTINUE)
@@ -3084,7 +3098,7 @@ static bool kcompactd_node_suitable(pg_data_t *pgdat)
 		ret = compaction_suit_allocation_order(zone,
 				pgdat->kcompactd_max_order,
 				highest_zoneidx, alloc_flags,
-				false, true);
+				false, false, true);
 		if (ret == COMPACT_CONTINUE)
 			return true;
 	}
@@ -3127,7 +3141,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
 
 		ret = compaction_suit_allocation_order(zone,
 				cc.order, zoneid, cc.alloc_flags,
-				false, true);
+				false, false, true);
 		if (ret != COMPACT_CONTINUE)
 			continue;
 
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d12ce84662ab7..5f1dea7eee15b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -827,6 +827,9 @@ compaction_capture(struct capture_control *capc, struct page *page,
 	    capc_mt != MIGRATE_MOVABLE)
 		return false;
 
+	if (freetype_flags(freetype) != freetype_flags(capc->freetype))
+		return false;
+
 	if (migratetype != capc_mt)
 		trace_mm_page_alloc_extfrag(page, capc->order, order,
 					    capc_mt, migratetype);
@@ -4523,6 +4526,12 @@ __alloc_pages_direct_compact(gfp_t gfp_mask, unsigned int order,
 	if ((alloc_flags & ALLOC_NOFRAGMENT) &&
 	    free_to_migratetype(ac->freetype) != MIGRATE_MOVABLE)
 		compact_order = max(order, pageblock_order);
+	/*
+	 * Unmapped allocations benefit from compaction even at order 0, because the
+	 * allocator will actually grab a whole block.
+	 */
+	if (freetype_flags(ac->freetype) & FREETYPE_UNMAPPED)
+		compact_order = max(order, pageblock_order);
 
 	if (!compact_order)
 		return NULL;

-- 
2.54.0


