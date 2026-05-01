Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F39F9CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A176B00A0; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6580B6B00A2; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45CD46B00A3; Fri,  1 May 2026 17:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2242B6B00A2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B961788C8C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
X-FDA: 84720078996.05.92C2A52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0A4B40004
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGgGEF+e;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669456;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9NIOgtBlLyGf15zMxbUbmRCkyrWcio4XBf+3NIV1pUs=;
	b=NCM513btWYBhRto+D0UEtTo0UqsWdDu/A/v2kGPj9w3Tr1SCoRxXBqwDaVzK/2r1XsCxUy
	GT/lZEJzF0i1I1CfqjwLdCICCRgYNqYSH8xXB377oDKRXStHI1Dq1njnIv3zJZxyrHzZJg
	uDZYgfZqHXQMUkKO5rIQ0bCmJq5pM4Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGgGEF+e;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669456; a=rsa-sha256;
	cv=none;
	b=1p7FpRbiWhHXCmIvhuhbelqgW4XygiZEQaLb9COjFiCXtqLVAvdHCMnCQskKDsNhKc7lqu
	DASCyvqrqMCeITRLrNYLwgQbiY9aIzuvjRzf19a87P0aE2T7bI2Nczl2CzmHj+JQrm3pge
	3oCw9gKNGtExoTtqIuht0IW22Hj8Fb4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE36344592;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83997C32781;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669452;
	bh=uw7HtZ5ow/Jkd3cZzVS81z4VEBFR+IcoXXPZBjeqpgM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vGgGEF+etW/Tod5Sq+y12DVbJ5FnObSl2pAt60sfSXE+yYpL/C/uH3I9WIkQfO15s
	 8QOxRXttW1ztRfZIgZL5WWLWo1OmoQW/2xYZ5ca9cnmaH2GQXAp1qjmfzV8FgJqHCJ
	 loFSz7CYDgMraLMFgwcdWGqgOoS+fAYDu4z9Vq9VGqAvrlxqYKl5J8TQKHXiAGOd0S
	 zcBhrgZhfg/2ozyidnWa1I3SXt2+78GU+ytgUSMqqrNwC67kE+AONHuM4H9u8kmwZl
	 B0f5b6S1hQ/CACt+8mtXIoPzIY0YQZxCFN+qfyaiu7tH0b0g9dYMwNnmy8ic6+T21K
	 V267vjg5tSCSA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76EBECD3425;
	Fri,  1 May 2026 21:04:12 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:03:53 +0800
Subject: [PATCH RFC 07/32] mm/mglru: don't reset folios LRU refs count on
 protection by default
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-7-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=2486;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=74TJpGUGa2omgt1UHlZXT4tEjvZggbuhmpXctXzyYeI=;
 b=TdrXt7tP211NvOJLgnbSiBqOADLMZLnktd8QIY73I2m6phygDPVNzZRmaGwGoUSDIgF/Q1Xyl
 raKvqc1OKAtDdWdoH5Lxp8YH0KrFwc8Th8Gyv44avqwtpbxBGDzZMz2
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A0A4B40004
X-Stat-Signature: hrci6zm6ypn7fbpb1geu6iq1kwbwg61i
X-HE-Tag: 1777669456-414844
X-HE-Meta: U2FsdGVkX19qazQCSPnzi14IOIWdDWH4tGB7cDNL5wnDR6FkFIcR2rFnWw0scmjnFnX2zdvuUotMX7u3uz9mrGoMJJbTLaPRRTGTYBPalCAwGwOu/F+q/2F5zX6pCh012PaClr6kHYmPCOXz0V3qSuE9CFiISOdgvVqAWNEKLZRC8ja1qTTFVTbq8NfZq/f5BQ2rrgK2vZtugjPSdzeVmCf28LdsetaPPA39DEFIpKf2OOWg7UimWhAxo0peZCu0PSgjyTHt2jDgfaKvWTCVxc1wPm0ma1J1IBCUnK47Ny3njTxKsZQP5pizpONi7UYsnpHhq7iqbG819C+zzg6ge0JS+jZhd94jJsPPC6HaExEsk3E3BvMXXB3ILyUFu1TSKvg0RYyyNi0TfgCBcsreiZDkH2Ze5EQ7f4YhPer9ixCNCZL4pLgNQVRSERhNHLAB/qkxrYeo1ylBvnD3Ynt6MJqEN9d3g/b7Iwve8SryDDpWPI3fOgkIo1ZhJKS6Bl6X5HsDo9EZgcc5cMdHKLSLb7kv0tioInlemWYaUu+g9MGE3saIDJQLGAqnhGJZVYVMzNe4x0j2U7IvsnKbivVT0Zvh79wtCrZ8746Z6iEp21vfbMy9nNewtHw34wG7MEKDNCirZUqOUST+q1RiZZhQGWyBiS965tsPuCS7n6y/rpiOnXNz/El7LZCNqqQk3uF46Y8w+hj6jsKnHIJI8RhrMWDvtanHHsB2K7kQy8yq5rQCob0qfvu64t4aIrec8RytWvued7QjUTz8+yNaQryyPylzHy+7zQftOpcCsYD4MwiQYoU1jkTHFrxpQmmT6DSF7EAWLbEaglJwMuU0RjEmaHWkM/WwJ5BwpEhlfzEmYkkAcwQbJOjy7YUcLiQBMvreQ+k6bnzn8zQyAghYEUY/Y/iZes67/MiOh783rrq7loSRAujTYCmmQbjAbhXH1UjWyFxjuI+c+yHFYJcu4Mh
 2NZW76GJ
 t5WduVroHMeEsFrNVk9XYYYQMsuZs27VwevmLV+Mf7ZaBkcuN3EHMkpaI5ULX8L2W6NwVp0tD3v76wI/D0rwgJHOnf96A29hng7wjWUCPB6M0VBOejteR47UT1F0vu23Xu5M5kapM4b+BzuJa0GFkWXmBe10n3epcjAo1AQTUqC7nrmRxe6qQTEGtRGRFhW+lQeJrulze8Ap3lzmPeQdVHOiAhyIKOmNl7ukrV6fhDmvPFxRvfVW9p+z5JLdfv4OqYkCO/kmQ1z827PD3M8Zgy76pR5cdulDPX2jH96WCyVgZ+AYl4oMyPagPxpSEtMoRPuy0CQh6ZLh7LkkTKakTVnd/0XKXBCFysmvJGzrt3Uwts0QCPdqChGkRPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Only reset the folio's ref count info when it's being protected from PID
to avoid over protection. No need to clear it if the folio is moved to
younger gen due to other reason.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 026b56828fdb..c6857a933ebf 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3227,7 +3227,7 @@ static int folio_update_gen(struct folio *folio, int new_gen)
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reset)
 {
 	int refs;
 	int type = folio_is_file_lru(folio);
@@ -3247,7 +3247,8 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 
 		new_gen = (old_gen + 1) % MAX_NR_GENS;
 		lru_gen_set_flags(&new_flags, new_gen);
-		lru_refs_set_flags(&new_flags, min(refs, LRU_REFS_WORKINGSET));
+		if (reset)
+			lru_refs_set_flags(&new_flags, min(refs, LRU_REFS_WORKINGSET));
 	} while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
@@ -3861,7 +3862,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio);
+			new_gen = folio_inc_gen(lruvec, folio, false);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 
 			WRITE_ONCE(lrugen->protected[hist][type][tier],
@@ -4607,7 +4608,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 	if (tier > tier_idx) {
 		int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, true);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		WRITE_ONCE(lrugen->protected[hist][type][tier],
@@ -4618,7 +4619,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio);
+		gen = folio_inc_gen(lruvec, folio, false);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}

-- 
2.54.0



