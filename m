Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8473EC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB726B00A5; Fri, 21 Aug 2026 06:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D256B00A6; Fri, 21 Aug 2026 06:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291C16B00A7; Fri, 21 Aug 2026 06:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 063046B00A5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:26:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8407CA043D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:32 +0000 (UTC)
X-FDA: 85124897424.04.1373604
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 06E2620008
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:30 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nDycVO7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sbrxf+PZdylQ4e8d9YhboPwelpbW3kiqOe9jSbLC3Yk=;
	b=WYrkGJVCzknzbicFkTWPdShc+wKWvfaXP0bBrHY9l/o4639/PWMD1RdN93nlvN4dlChdaL
	sNiD+HA2E+DRTor/7EiRGV/GfHOrKXXBgaKqaX5ng3DzsyL4qzE1uz1Ynx5EXqYgVhQmn3
	UwFFhIeeN5ss0GlA1psxkNdQWMWW1pU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nDycVO7I;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787307991;
	b=0l8QtPZ10KBdvkhGBLx1E+uYw2O8EvqjEONPiFAXZvvmHh+ZZhBNg4M9UgrknnI2sCkMWH
	QCI7ISiMnKd/929VU8TLQM76fC77NAvgUQYLl3fBsIevcLnW3Ic+TkEA/R0rVIdc5xWGwR
	8jthg6X8df+1eze28pfufNo3YsQMs3o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 932A660DB6;
	Fri, 21 Aug 2026 10:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7F6D1F000E9;
	Fri, 21 Aug 2026 10:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787307990;
	bh=Sbrxf+PZdylQ4e8d9YhboPwelpbW3kiqOe9jSbLC3Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nDycVO7Itn7ToZ1y7L33bMcoxz+OF5wNBXiEGMXhkR76hWR+pKRjmDM0iU7wa86b4
	 +GKnyADWlZ7KUaMSVIlHVhN0aQzb7icUPIrqfTI+tPmfZxzeKt3h5veI0og0/zLI7T
	 K2ablnl4jxHm9M6ioeVn6xWugVgamr7FA2qSURfM5S+ORIXa8dLF/ll9Cw1/zD1N7L
	 AeFZ+fmRcC/VXCpTBQGlbp7T0LT1tlccbdV1P8bN/Z7hLe6BSW/U/F4wD9JTjlOZyR
	 vTYPyZVbKuZMFcb966DQydno5oE9RgHF5Iz0bndfIjG2Z11XY1uQKAv0O+BmzSohsV
	 U8rQmdW1++isw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
Date: Fri, 21 Aug 2026 18:25:35 +0800
Message-Id: <20260821102538.22642-4-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260821102538.22642-1-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06E2620008
X-Rspamd-Server: rspam07
X-Stat-Signature: otjqbyfrw9ykt87us9quw76bdegc61be
X-HE-Tag: 1787307990-366424
X-HE-Meta: U2FsdGVkX1+0hZINaIwrmY+ZiESmXUeLWDj1KfWvqKD1FEJ/Qhjz+lg9aVJWInz73rbAHp1AClJ1iPIi1LvaO6Ei7a4MDmf4owZGHTLp/pa6NvyeZUL2+Xptk+ZAA2ElDqmm4CIWKKjoMXMvKfmll39VyYFennGlDozyMqVNzwT8eA4uKAgm0N9s/AtSMQho4wziv82KB/7R8s31i0rZpN6B+1++5AFgCTuINHyIengsKHx8DLhQggWIm2/S551HR+fPdlwhGDouWlzUSscr+a5ZehpxcURSWxxhwLc1neSS6BdIto9bStEeWSocreSFkokMJ1NupsjvgJyq9z6wCGKJxRjWK0rJ1syGwpGkl1i9CLb1E5g66q7BH3/TyKhaCIYZwvE9lVNetBvBCZuoKFqdE6EyPNj/0eYdjr6WrA/WsS3Tf5IEFv58nn7np5TEJvsAVGmF2PayGsr8ON4gLThCO6uRMOITzIorlrggsOht6UIOkXFqU9Qo9ou8VcKGI6f5hsaF8Ahi/lW3DoDyeaSJXt5r6cHmPI7z0SjNAXpkcviyzBvp5cQ0EkNdw2U5o+qurNNU/9aGGgdzqhYOCDwFEqwUQVMmUmhW0LAvwt4BdK4nZcg8i43qGfcgy2Bl+9kjG7D3Z9nuO22emLn2VWvk82KI1PdkT1HlwEb2FJBvh1GwcHQa9MJJuDNgg39YKid19uSJpmuAl9+ksHJpaYX/eYM6wh4vKhIG2uTIdrAlmUyiX6jYaicfE1feq9h/lt7Oiatz8CpNTWN15pQroJ8oaUDyfyWs3/SKfS5KJguaDx4KL9KjFeQd1uLaNsS5WH0BLoQU5v/Zg5Cst29q99h97pPbSJcwfgtMWQsl5F7mXpIXY6RGgOgJMdTPJXFMjORNt8YcykAR0DjlGbDZVKVJLHMxGu50rYVBlyL+Noqh/38kZ1u1E/tzRe288sodMs2+RixvdCmWYM40hYn
 buJZug61
 y1d5oxL19/nYqwqrUHcQfMLKbue9zrs+AajW3lVjFUkplTnhH1kl6jz5utDc41oQbjW0LEgxzOzKRVfZjZzrofjYwJaCHJ+CB3eyDKCHXCqHXKBJLVyVnTwvsnbOc76JZE36YFfQzjBSTbELBVq4QN2BXBuziOH2hGdYuPhxakoMu5XT4piMumxSqOkRUpPEFM4AWsvAbUVbglNISAkfY6MwHbRazzJQnwfvYcri15wHgWVO3Fo3dP66lHoKc2xIn4EY1A5u8f0ZY+B3n1l5NmIRCWKIS4gUSjc5MTUwPHIfzMH6rAQYm3pT+IB0hnOH+nyP1IxAmydCWXEWzRnfIkoWF1MW8W6TGKWiOw+CImeD1r/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During aging, a folio's generation may already have been updated by
folio_update_gen(), even though it has not yet been moved to the
corresponding generation list. Such folios are hotter than those
already in that generation.

It makes sense for inc_min_seq() to increment the generation of
folios that were never promoted during aging and move them to the
tail of the new oldest generation. However, folios that were already
promoted should instead be moved to the head of their updated
generation, just as sort_folio() does in scan_folios().

Otherwise, promoted folios could end up behind folios that were
never promoted, effectively inverting their hot/cold ordering.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 99ee3c833d54..3b618a51cde2 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3946,9 +3946,12 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
 			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
-			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
-			if (gen_increased)
+			if (gen_increased) {
 				delta += nr_pages;
+				list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			} else {
+				list_move(&folio->lru, &lrugen->folios[new_gen][type][zone]);
+			}
 			/* don't count the workingset being lazily promoted */
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
-- 
2.34.1


