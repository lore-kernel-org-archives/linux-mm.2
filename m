Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1C5CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1016B6B00AC; Fri,  1 May 2026 17:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 016E86B00B0; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95CB6B00AC; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D385D6B00AA
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B0181A02BC
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:21 +0000 (UTC)
X-FDA: 84720079122.07.0CB34F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 816D1A0004
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BRgJrQ0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669459; a=rsa-sha256;
	cv=none;
	b=8j4N0gip4V/WtSNYEzZMOnuAKBRgIqRQbqB2vb1DvRm3mr8CXtiFkKRtDMM0oEOQXd/TlI
	MGk2KaQd7xb0oI292y40nev73mUMoDGWXsMLttR7VR3MMaXxhNkRWSAyvlBmP0VRAjFxkv
	OPfTot4a2G/SVl647SIJ/Aw8LLH7BkI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BRgJrQ0U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zr8idhp2bfoDuiGSVV+gdv5U9wfx3cVl2pT0LEs0MhU=;
	b=JyCGDHy0qhCQIZ2nSqL4Gy3fdmNIdU1safFY+C2TJpDwv/Xr9BgtGAJVuX4LBXcpOMqWSW
	PhgY6exAHDpxvlJvLrlrvakKoNUOc87WWUpfhFYNiuOJwEApx+6aBaMjG9f/xBN1pJdNaS
	5QL+3e6K8Jg4fzuZPQYC2C1WWh0a2SA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B15F744749;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8FD85C2BCC9;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=IFixioiEcWVbaHjdKqjkGe9G9//zLNm5c6Kw2RIarj0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BRgJrQ0UJNYt/UnBGgEtVE7K4uth2p9QU7i0zC3eOCBDIQIUkVKMymdhxln4WtRjx
	 xiRcX5l8j7V00vbGsJjuLdzqe2ndll6ds8DKIveuZP4j2Lx+cGFG5Z8f7nWDGledac
	 lXb6NMOZxDh0eWSrSl56OoXz+LS5/zRFMNxvEDfXr//94RVtogcDEL0WMqzVa11dl0
	 eD87Z/teeUjaJQB0lD5juOzyrP5BPhyFaNeU0AHmdXMy0f52ypZebtNQU8jFy/brE1
	 voPUY4hSTwRzilsnCESw2B7j4TUVRoCHl+J9gurm8FinX822NQwgbH/erSui10j45z
	 DyRmBWLN05ASw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F0BCCFA13;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:07 +0800
Subject: [PATCH RFC 21/32] mm/swap: convert to new bitwise identical helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-21-913619b014d9@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=1323;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=eeiiyy+su7zYF2XxxCJkB0ii+3kNLayc6qTsNhWAGbI=;
 b=FyZO3KOY9qKBaiu/DIWFcROSEhhGKBxTqumQl6RrGU/2X5SJ5Pyl15i0sP1V8AB44wIWdPUMO
 AKnyGEbam5xBgtdf2RYhHf1fGBdJpGpa9Ss1FHDNVjXiSSeafhu8cev
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 8aef9nxkpbmrh9xgys6s8kroud3wchf8
X-Rspam-User: 
X-Rspamd-Queue-Id: 816D1A0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1777669459-360596
X-HE-Meta: U2FsdGVkX18hSDSCOBol6Val+SOPiwjX+W3O/wgfHSfXayYK5gjDyq4mgdEM4UVmZl/1bvcpkfOBLAR6xFefluYqs7N80dQ/GK0WIvx0kWzziU7fVE/PybmQg6KOKDjK4rO0biMfVkMsgbPbUbu1Stq+wBEiLXtVJoJkb4fhTSrVnf+TC1jG87rpM/22ZTFB12gTyrrHnFKA+kuJK0URd5bOxmF8jEOvy9YEDlKEmyuratm3DPCS0hhlyBav4Rg3FFT+5+Mrln2DnpQuLwxZq4zCLuaz9KxLCjDX7R/jEnp/vxGEbWhzlB59e010B/6h7vc3uyMOBJCM3R6tPT6Z9/1If4+wFgNDyC6MhbIDg7yVrRxxgxNrupaKv12yqhGZiUonj2YBPr4AUuuubEFNXyw9LxLPgwlKBuyYCNWZA6Z/5/I3ltV2WKbaqNi3zylb3OHMMDx2pUMmJifyIFXwfZyHcUflQ1BlQacj8/kdpwsBfiVo0lGdIMqzv2hXfutzpGacJ6z3QxNOUYlkFY1w35GQ9fhoNoF3vYyoc2qtYYlDr0Z0YNWWCjMzOMyRyhBWmtLOI3+y0Dpm1V2HZE8wZULeFy+4qkjRRDCaGqE4kFC5DlyPhRMMZpZjPR6lugKn56Wh3O2iyenG2bxy/3WeAeqBiWYiDomv5geH77rH/crGOVBAq2zaJ+BIpu5ua1aMeQqQzMkCinqnDqpp8Dze9C6pH5IIlfbhZVwMjddAtYL712Ixz8/x+LMxM7ymns4vogjc3/Vbp/jQJQzM6/dMusHAuMobHGFoQAE8YcgxR4VtlP5hYyixz49gb7e6GobcKRUrvrIVp8Qqz5wKVFaMIR+sib51QeKjv108OwX/FHyaZjmGLvwJU7k77le2qiZYcyiTzV5x5tg34joodsP/PucN8+9Ee3KeRlnx0tYF7oSpz4tAjJGPMCiS/JrKzwOsD8UUON0BB2UPParo72F
 toFtmJ+F
 9bjieVlz6CVAtWGPPl52u9S87hD56k3Jbz62xguWSJssuUufKjfKKVSqUAe8xx9zKr8COCqFdlsepyZ3B+ZLfZSLpdYKq5mYpIZBGFVBQTysTki23cE89zK6j/rMXFbHrgi7ulfln6TlODcZxRJdflAk0iJGXjIKeWcSbhzfe6FhsUhis3VyC+AkqVjfjJRlNhoObu8DJOJJKlVif0adO4RxGElZvD0+GHSidUB5GmL8NoFQ0k2nHCrnNS49hek/x/QxHUcJasl0+spD9DkRA8MbMBGxotI7+ylmKNc5tGKZDPP6AjB7QjjSIOWFFbF9u+LNLEOOdr+8r6ZCTi7ot5zGa6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No feature change, just prepare for removal of PG_referenced.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 2250d9db1395..043c4ec708d7 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -629,7 +629,7 @@ static void lru_deactivate_file(struct lruvec *lruvec, struct folio *folio)
 
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	folio_clear_referenced(folio);
+	folio_clear_referenced_by_bit(folio);
 
 	if (folio_test_writeback(folio) || folio_test_dirty(folio)) {
 		/*
@@ -665,7 +665,7 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
 
 	lruvec_del_folio(lruvec, folio);
 	folio_clear_active(folio);
-	folio_clear_referenced(folio);
+	folio_clear_referenced_by_bit(folio);
 	lruvec_add_folio(lruvec, folio);
 
 	__count_vm_events(PGDEACTIVATE, nr_pages);
@@ -685,7 +685,7 @@ static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
 	if (lru_gen_enabled())
 		lru_gen_clear_refs(folio);
 	else
-		folio_clear_referenced(folio);
+		folio_clear_referenced_by_bit(folio);
 	/*
 	 * Lazyfree folios are clean anonymous folios.  They have
 	 * the swapbacked flag cleared, to distinguish them from normal

-- 
2.54.0



