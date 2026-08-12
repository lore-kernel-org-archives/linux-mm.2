Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C14EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3ABC16B0114; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35C456B0115; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BAB6B0117; Wed, 12 Aug 2026 14:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBFDB6B0114
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C7DD14045E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:16 +0000 (UTC)
X-FDA: 85093505112.10.0C3B3AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7D74F40007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDQ6HWSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560554;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKQ9ZK64SbitiD6W78PIBLLLe06gcHU1kE6inDBhVKo=;
	b=21S2xRQy7tAISFaHC9JVNo2Adae5L5KsvPm1rf9fG8aQCzSiRz9y/jtl09ZAsexvL+OxJe
	53oxHp7Cwn3y9WKoN5xcioaMq9FGdq6h155vv3XhOORO9Z5rm6NuPjrK78sdKigyi6hAXy
	mkF/0tcXR4IXjXeKGATYcQ/mIo6Z2qE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UDQ6HWSD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560554;
	b=0IoaWbMTi9bS6/M82gyj7/igReBf/MXV5xLkwruQjLyTfW/RSUxr+ongIexcxJbcHoyQAX
	8vuGLoM3soLtuj73GQZUNj/m0ZLkqCHvpdlL6vsFJdAlhBSEPBh7ZvAhVSqODh/WXAR2WV
	Zeykfsdz+xsvKDNvYl0E6YzMqDFVgS8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB5C943D23;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81465C2BCB3;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560553;
	bh=/AfvPG5wDSljrifmPSVv83+zocjSPM7Rk8tuaUgB0kU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UDQ6HWSDKW14O93sYVnoIM1ZyFdfZaT6T7ER+P9zMGJ3gth9IalZNQTNfwbM8pVCg
	 vihJrvDPhWBXnkKqkZ63J1h+5QIV8u2uaB+K6fGzHh/BwpIV6whsrzJ4xxwXAmxU36
	 o8aiuO0gZA6NWSke56OzqOKKWeIk55wtAIGUNFXBuI1DuBnhrcHuzGf0n8E+0s4b+Y
	 AoQNKt1vcovogMrvhKcJnmb6bVepyHlimN/ZUh436fYny8umyG3yG9i/1vT5J2tKfs
	 jI3Zt53Fh720aqegCDHf8xrly9NxfZXnXqk5Ry2aicIPXJmp1iqe0UpIZFAnBsI9fF
	 0pSR6054JSvKQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61325C5B572;
	Wed, 12 Aug 2026 18:49:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:41 +0800
Subject: [PATCH v2 01/17] mm/swap: fix off-by-one in swap cache replace
 sanity check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-1-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560550; l=1345;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HKVUTdGN+FJkTgGM5Te/fnEGz8LN/83nu6D2nUyiBUc=;
 b=7ITNUdvPj/gYV3ooz4SLYeqrRp+BFlq3B9+0PvGPYQGmXnsYu3j6JsKN+8l16AyavYqqFLtQ6
 2djwBUvEgDuAIk0Z559FssC7mWmr/jv12RAyq/+Qte+tl3Wy1uEtcU6
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: n6azpqu6dhrcfjwe5ttp6r5rr4szpfu8
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7D74F40007
X-HE-Tag: 1786560554-269674
X-HE-Meta: U2FsdGVkX1/ycTzWow/hcoMYFhLx77+xBMRuf2i5VpR/MVABZbRDqlZBUm2gDWlj9+iHYIIvT0iS1etBUQXD/Ebv7ch2q9weRwgIKxApDEZXCfyaADAi6Lwbn+GaRBjXzTBOa+F0IYIus/10lpGQRxDYMPi1W1rcLclcWd92Tm+GjAV9EyASHbtpyEGrHAkj1lewBcSPYqD8PEZ8j4A3nciOqu7r12Xz3XybOCzFpvNysEDG4oJQLEk78i9GVFqCzpNnhY19iE/ZCg0B1rDBKXtLhgF96Bv2p8Q7y2bvy7B0WOv2kJb9SQ/XZ19o7VMb+SntQjNCANPAdtvVWUUjp3T+kTQYhmpAPE6dczYq+myTpk3D0OmW6pwPmWeWk9A8ahDSmshA731jhstyYr0aX1rniaXGqWDPmaRBIsuQbDeN5AhINDH50pwbBkCla5Bw/i24xkNwTJDGonyUZuTZTuOwtn9eayNaqxzlROHe2FEUD7RUK8N/xAfR+QGQHfdrJzn6ic1VDS1/B3xlk11mwzdRh3qt1muP/mU7SgjObaO2OHmicRSuoXMzO5BPKpELDCWuApfGJ7R50qMkIXLaSqgcLOEr/1zScpyPQ8SUMxWRvdsY5wyav27oPmACNfIehXMAVFzAmeJ49Fhmosk7I4DVF95tRH8FhbRtqjxzGlUqrxRfNTrllV4JsH0HUq0lHY8mAltU1JCzaPQzGG3uvWtk1S2qwUZhGIA1b5E+htFTsG5TXxbB2Cx5hdtAwn29xoqnHBjDo9rpMmHHAUWPXDny6o+QFFtyozQMpsyxMsYEq84fAyppS4nil7sgVbCAa2qIKtVtH0FxcJ6+9PlWQRdaYnNNzmFlxqj0di/SaVWEplZ3zsqm015/N8Ca3qRfTBnuuNLQjPQJg9E1/4JTTwxcpSnk5tqqahf6iHCMSgZG4PCFbI/mHfcmlu0KpGaymdmV/BndAJnRBoHj+X9
 NL8An1F8
 wGiaWy0UIyhNuRwk8GJa6sbLEuwDUy9pK0TnDWdIGfdBCXRqDbRAehis6wWEI204b/aarOUCbM8iVA+368rNzDDuWXcFA32dWtsKEnaAx2RIoBVePVZeyvpnUiTS+T1p9SYRZDQAJROsXrAnN1n04LiIMkvPIZOnUnifkOHjfrUiyij8ErdPkuHk72YSW81awr3lklJTyROiaPu4wuMHhp+97VhwG0eNwg9A/tXV0E0cJaEasAJTbbgrAcmQYIQVys4+UOHsKxgkUOoEHZK4yBDCBYw78jAd3rEi1rRk4WJnt1UTruukPBAa9eW/DQfIkFT6zX0SSB1kvGQ1irOnwd+pvFUX6Ra4f//TlbF3mN5/dB0+WIEqFzUlp2T048/5xJz9GFCubJyZ7juKDjVfTG0jyptKNAdgow4OBcQnGx/57a0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The DEBUG_VM sanity check in __swap_cache_replace_folio() iterates
the old folio's range with "while (ci_off++ < ci_end)", so the loop
body runs on the already-incremented offset: the first entry is
skipped and one entry past the range is read.  For a folio split
that entry belongs to the first after-split folio and was just
repointed by the replacement loop above, so the check would warn
spuriously whenever sub-folio orders differ from the head folio's,
as non-uniform swapcache splits now do.

Use the same do-while pattern as the replacement loop.

Fixes: 8578e0c00dcf ("mm, swap: use the swap table for the swap cache and switch API")
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/swap_state.c b/mm/swap_state.c
index 5be825911e64..f1405e5b813e 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -388,8 +388,9 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	    folio_order(old) != folio_order(new)) {
 		ci_off = swp_cluster_offset(old->swap);
 		ci_end = ci_off + folio_nr_pages(old);
-		while (ci_off++ < ci_end)
+		do {
 			WARN_ON_ONCE(swp_tb_to_folio(__swap_table_get(ci, ci_off)) != old);
+		} while (++ci_off < ci_end);
 	}
 }
 

-- 
2.55.0



