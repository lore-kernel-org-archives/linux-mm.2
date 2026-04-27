Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E03FF886C
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 18:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528046B00A0; Mon, 27 Apr 2026 14:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FED36B00A1; Mon, 27 Apr 2026 14:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EEBC6B00A2; Mon, 27 Apr 2026 14:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 28FEC6B00A0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:07:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAB978ABCC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:25 +0000 (UTC)
X-FDA: 84705118050.24.03FDAF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 477101C0007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 18:07:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uecVsYXV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777313243;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZdRpwKAg3aNUfcXJ9Epmrib1P8FVfkP9korwHTqGYc=;
	b=MAvjHdViltRB0ppnFluw/EteYhAxLn//8GIRXx/LfIoMjygnj0qXbOswALH2B6PzfVvlV+
	9vEzvuv5yf0Cew0giK9FCGbF/kWl8eVQNUZzNKLaGHCMXMMBidh6On64pkIz/h30XjcPcN
	8QYnTO7/+OFGLyrMbgpEwAbSoz6XVtk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777313243; a=rsa-sha256;
	cv=none;
	b=bYP8P2vqGpnclVoeYF7WGiH9FchRCug98hpB6QBkQzTdQsPvweRzlgSor6KqavVtIoDExc
	CD8L5MuY3Jy2o/g2Fslfb8iS4oXKYPXmR63lzgWMxr6Yh2YjIIKvWiATIK9O4jmRMwchfs
	VEsWLzK5ZWQdwmqPicjsDEid9i9brGo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uecVsYXV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CFAF4473A;
	Mon, 27 Apr 2026 18:07:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86E37C4DDF4;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777313220;
	bh=MBJDdRh3tqnWkjaabvjBfwwcCLCcoj+BlqMmh8jqgUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=uecVsYXVPsfU3dimrq4dMrG2CKVmGRwOBl+VoH3TnG0c5x5+EsB7PybwMKcFaAaFi
	 FfBkVLtUw/Knp+ZzVtaya++435mY9e5DCuUu99GnoEAtSsowP1XyIaMM10ebzQ+ouz
	 oh8Ci7LSQXDK/vZ+pV9sDsGPYbnh4tRS9xr6qbrrIxe5quPlCyaAFmEssB961ZgRYY
	 nf6+8hfLNZtp97fcXzXmAMfDUfvb5L3rmE+LrK4z2jgC/AtuTAkoYvChWHQmHURQJE
	 nQ/PTm4IjxSzG5ru0F5TiFp8qiuu//9wW4abKwGe9GIbegxqqu9mEOF5zJxew3ywAM
	 fVEi6HvnEaMlA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F910FF8868;
	Mon, 27 Apr 2026 18:07:00 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 28 Apr 2026 02:07:03 +0800
Subject: [PATCH v7 12/15] mm/mglru: remove no longer used reclaim argument
 for folio protection
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-mglru-reclaim-v7-12-02fabb92dc43@tencent.com>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
In-Reply-To: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777313217; l=2629;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=5MkZqaWFeDlbbVjT1CAX+BljQEXWptawPTTuIO8j3f0=;
 b=mR+MxcXz4S/4V8MORLJC3tJ+UhzfA/ZNwM7r0rjIyEpR04Q4YSg09TK+L9kniBOJLY+GydXK8
 qEetAauTeq2CMCvcNQx+IyWlefD3FlE0+1gzgD7+yxUNUDEp6CbOc18
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 477101C0007
X-Stat-Signature: bp3sj5qb8oy7fbzqcupwsn7mg96ih8sz
X-Rspam-User: 
X-HE-Tag: 1777313241-311963
X-HE-Meta: U2FsdGVkX1/cn4fPNC032kT8us7FSJZd9zpbDv0w2YhCp6DSuZdt2CW92d7gDXfF65eMrJ01hgRyDaWBUPJ5HL72L1suQxhw7FvUuhru0Nb2vMXwXpl0pG5zO08Alz58Yih2i8PF/eAVxQqjHmZ2K21hu53VLgiFlUNBciPB+qzgENarww+afhEUzNcysY+W/QeVdwURfZVPS4Lh8VazNrFb7kiP2erzk2GAFgAh77s+80kzkcGrUObC8hQc1WMrjfQvUTzvdgc5q0LmLrvV0isZ+NjYHrpRKe1JbaaQwAsFBAk2MPliekgDYyN2FmolRET66gTNXFOKamprLpFgfl3z+OiYPLhKEAsKmAoQ2E2whARDd1x5IeZuQyhzYOmD7c6p1oquiV0utIDh1cFNWDfZ1e6Jq2pGqQ2+E5RLrGW7ZLdGs61NXp2qFTA+j2Aw+cNxewkiQa/aMm0oFFf0NSpIfkOSr7dtfb/Mu5UvIY8UQ17UhlTbyl9MEr0RyvcyPFK5lZJ9SInS4A7Okk1zQxmJrn4Kt4elUYyOQ7mikVa83xNIReuQe35LJBkwIzvt2fM+5hfe/oYVnFmlPqlWLlxB9Vyg9UGdNypwSyDBsKzUfNJp6DdQlavdQolGi2pWeXgQtKFW6MO6swAfr3r8vvlxh9mE9asvNHGELguHy8qOIg7Fd7ISkVAJ772Iy54kskQPgrUsj8H+l56oUhxVe/gj8RHTquY86LauNfjwZKw7o0auDSBhfaWmYsrLbizbt87WgC2UzUMOEnyBZutslklGdYbZ4RDyJ4bKZizsOKcJG4aq0GKDR6TNLgBkLakg+RWqC48BTZt3nRJtzH5+e+jy4sdqtH2fBst8tcPXeB5QvAtiU0gigHKjoHVL6ZHvUExMCpADSUuQuBBjXKuNj7zn6id5pOmXVuyEEub3Yzmv3MzGIVyAPuuxRA8QLCtal4iBTRIbBCHpslvEFa8
 BtnePdU1
 BZ0mAyGMY8cmETZxuOhyXL5s7nqw00BEwva2kQiQJ6SB/XX6Gar0kBpEI4mP5pxvQqmdmJSTg4ieWz0NzbpLXRvf2/FgUU0yUoaWCse4wNj8U7O3an/OP/DG6ut647BxiaVZ2hovVXqoEtTSNrEv5OPXuVwWDTiapK7OygAxHV4D+0awDFe9Cv9/uj8qhAEaT7vl6t4VR9TttycCQFpN3l7u22qAIoOZ3RSbAJglloka2IfiIqSr5LyIszCd5lpVyEGlZdSdpEuv6/nyUHaAkbQqcr3NBb+SA/oKuRVdQaV+Jynlx1iuD+1Ig5wEXeJWKo3poFBXGdH5TxsF3fQUc2PJJtjjpxovu6s7QzTGsG0hwgyjJYmtlg4w3ngtZMGRdKDyWPgCjV1L9Hgyk/HDq5uM14Dan1F+OppRfqmroE4T3dRZo2XhiL3iADMRHWfiNlH2gCuuQDeCKHEYfe5tsORzfCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now dirty reclaim folios are handled after isolation, not before, since
dirty reactivation must take the folio off LRU first, and that helps to
unify the dirty handling logic.

So this argument is no longer needed.  Just remove it.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 244cdae99573..eb7eb2ed1830 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3220,7 +3220,7 @@ static int folio_update_gen(struct folio *folio, int gen)
 }
 
 /* protect pages accessed multiple times through file descriptors */
-static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclaiming)
+static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio)
 {
 	int type = folio_is_file_lru(folio);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
@@ -3239,9 +3239,6 @@ static int folio_inc_gen(struct lruvec *lruvec, struct folio *folio, bool reclai
 
 		new_flags = old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
 		new_flags |= (new_gen + 1UL) << LRU_GEN_PGOFF;
-		/* for folio_end_writeback() */
-		if (reclaiming)
-			new_flags |= BIT(PG_reclaim);
 	} while (!try_cmpxchg(&folio->flags.f, &old_flags, new_flags));
 
 	lru_gen_update_size(lruvec, folio, old_gen, new_gen);
@@ -3855,7 +3852,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
 			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
 
-			new_gen = folio_inc_gen(lruvec, folio, false);
+			new_gen = folio_inc_gen(lruvec, folio);
 			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
 
 			/* don't count the workingset being lazily promoted */
@@ -4607,7 +4604,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* protected */
 	if (tier > tier_idx || refs + workingset == BIT(LRU_REFS_WIDTH) + 1) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
 
 		/* don't count the workingset being lazily promoted */
@@ -4622,7 +4619,7 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	/* ineligible */
 	if (zone > sc->reclaim_idx) {
-		gen = folio_inc_gen(lruvec, folio, false);
+		gen = folio_inc_gen(lruvec, folio);
 		list_move_tail(&folio->lru, &lrugen->folios[gen][type][zone]);
 		return true;
 	}

-- 
2.54.0



