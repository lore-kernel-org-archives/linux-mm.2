Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 928DBC5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBBC6B010F; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C346B010E; Wed, 12 Aug 2026 08:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08A026B0110; Wed, 12 Aug 2026 08:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6F496B010A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:18:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 85BAC4039D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:34 +0000 (UTC)
X-FDA: 85092520548.25.68AAEC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id EE1A420009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:18:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=enrNi23S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sjn66HBL5BcMiFsq1jE87/70ep2gVw0orOdl941ZWGU=;
	b=fzV3CdGYAfl1hZQLCNmaw9wljx+hgWoUjmJfJp4Guhm2vouZjypS9XAXOlKKZpDu7aE/nh
	HCVYefRD5fYLk/lqodSj4smcQGj1MNG5EeONsEr/Eit0sGfuTbWUV1vubiRJ1KCd3gnqrB
	P/fArUJb/3NS+ZuS5Cdx4OZa18Ro59s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=enrNi23S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537112;
	b=BcpRnKHmGNKkdgipLzx5qggxn2hZ/SIC6BFXRyywz49KmkMxlcAf5tx2BQ/3bB/zxgqXiB
	NtS9iz5K0agF+BNW++HSg1fr6qHk5kBGH9rkch+zWowf/cvquRG+mQ+7zeOrqUptnczS+/
	/P+cSfz7Ug4QxMSg2skjmHCIF1qotu4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8AC4861895;
	Wed, 12 Aug 2026 12:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F591F00A3A;
	Wed, 12 Aug 2026 12:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537112;
	bh=sjn66HBL5BcMiFsq1jE87/70ep2gVw0orOdl941ZWGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=enrNi23SNkmgjfzNIYWqLPhi43g/P7K8nbDsnMcP+6+uxoBixq/bV9gVYeWsuyguJ
	 ppEnvFW69IqTOvOvfr1omUrs8ZeVdrDQFUzGNtX1JEdD11iCbix4vid3E5446+lStn
	 nMlgghr4dI694h/VFrm26NTY1WdEkPAwF96QzLq41P+KSnUZSWymwWa7ylOM8sGEEM
	 E2OKPZstuIotUFg8CmJgeGVVU7VFD6AFnjdktFo6Mpm6r3JtD7rSrBY8H7wFigegAp
	 vbA9TNxxTriMqfC3Io7VCrSUgCT2v2Yreq+8oXqlRgOaNsJ+Ji/HLuO1JjWWCSpWd8
	 uNt/QOqywdcHA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
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
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH v4 07/16] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
Date: Wed, 12 Aug 2026 20:16:49 +0800
Message-Id: <20260812121658.69965-8-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EE1A420009
X-Rspamd-Server: rspam07
X-Stat-Signature: dqdtcf5wnbe8sik8fdsbimhifzb7tdho
X-HE-Tag: 1786537112-88276
X-HE-Meta: U2FsdGVkX1/Z8wW07cF+9Mj7IuOo6ga1pf85L+EUOMWGDBGHQ4+LMMVKoBr07xswCV0HuacsUPsF8GBW3dbIOoSe10n7avxWK76vO+IXKXjxHzPg7ogSYhjZLT0Zckf21dcJAn7LED6UVbXzr93ZGfRuNSNIXaPsxFxDbfe+MoamczXO1BZ0xKtiWWCtYd9y3pXa0nZD5hZgtjgqKlnDo20nw5CdhT7/whScstpq6phAuDNTOr/1VWcRLhA3u9MprwBnLr0eHBJT1EmiQYs+jDjBEBpFLILFwwFT7dyeIIEZfO3/ylVfrb7rMMFYIJOSn81B/bsoAh+Lf463AWFOd+zX6ySObCoBNB5E42GcVws3j0PzUWl/gab2dArMbFyJfDMiZQu4P3BzDQspFRMRYWqDe9ayrISulZo9Gswjwrr/NZyqcBANzz1s/eP0SLIZbPqczwqCtlq+Nav9qB4IP430YB9mmOl9Ny2JZBjKxfzjSWVgB1a/eNaVPhD0c7OrrR8MuOWK35POSvkhrKNfSH5YdyOqtrtOPxXOELSPbOG3Wz4WhN3OR2VW4jL1fl4Fn3HfgyEZ/Yu/TqgmPvTDceRPxRnB/NrlUPgkv84krcMV6+CVvUZRUZBsS1BTe5RBqKfByoZ2SykPjShzCvn+l5qmP3ilGcJZzcOER2sr6k58pvahmPFRO7MLFTivRjAixoDPz91egilsn44xjRg4x/P0LNOXQVJvzx/AK8kciVqX7cgf4nx9rfQGfjYiJkp9lEsZrsnl8eNbtdzSVB8QhEJOI2brvVzi2w+1NXe7M+hPR5fk0Za3R0QR19UrmCxA/xIIa01mMkfmur3ZMgJ4D5S6Vt7gm+q32TDY5bwTt+e6uf8Tk+2JNBe8IWX/uOFK50G4Mi3P+8MdL9q4RO+w6K5zTGA6Nf7DXoYdwjXS8UcXeXqsao4elM8KP2Gv9WsBj4QaRtUkFMK/O5lMfPL
 q//BpH+j
 e6cF7wlitwB7PJlj4az6l8lvlN5VrxSgjA4HUtTBHLIobSC57oVV6PfsXwGplfTQbX27oG8cUI2oRVKeBQXs9GrSH4SaZJ37kII2fN+rsyIK4uLH/BFpHWRhkoew0RHprbMwj0XrvVHXDpGuPmKlF942c/MDpIPB/dcONVy7bucUD8919tc95Kbl8XA/D3nDFHWnuHTOxaKknKMoLhfmMHFtVKmbgKCc8JlTBrOmIbVJF/EZcmWVucqNTn7Md2qzCxTFEwFKzl0H2k5M5TiWNL0OUOY9EhymfHCotfq+nLVQmdLH+mpau+GaeHCU2x6GuHWoA3RY26qocs5G8OTJcxSJ1aPSg9ovUta59
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
index 10f690389f5d..e0625e6ec919 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3945,9 +3945,12 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
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


