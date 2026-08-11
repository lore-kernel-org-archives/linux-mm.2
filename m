Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96425C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 09:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BABC6B007B; Tue, 11 Aug 2026 05:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66B9B6B008A; Tue, 11 Aug 2026 05:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5809D6B008C; Tue, 11 Aug 2026 05:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 311C46B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:41:10 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0384160381
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:41:09 +0000 (UTC)
X-FDA: 85088495058.05.D818CC2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C3BA1C000A
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:41:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUQnA5D9;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786441267;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IQ09sUwzujJ2ZKpsadUA18ArsjJ7aUBy1Ie2gyN60sM=;
	b=nhR2SqZ5SUeB19uICbYQ4PtK6++Hr3X6HIkHubSx+YcE/pD4eKLd2drOVjJ2W3QL/j0F4k
	goEv1q0bvwTHdqqk1vZC5Ruxks1XfEXWQwZe3nK9UXSwe8TiqmJrepBnm+qSpPLDt9CPPn
	3OfApkdSy67KTZyTjDaP70kjAr4yT5U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786441267;
	b=xV3RZoZEr3XEGwM2KEL/V6/MMFiLTiN4rxVl261L6C++2+mwGksOfhzDl58lFF1zCMSULZ
	QzJNwhjMsg1kMZ1bF6Dr5UMIhLfiHPn9DxfLGlCNBe88C9XwvECOcpgxeiuk6lzYk1BQxn
	Zjs4snVhnvgf5pm7yWfS7+9gAHg55ak=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUQnA5D9;
	spf=pass (imf10.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B362600C3;
	Tue, 11 Aug 2026 09:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F5E6C2BCF6;
	Tue, 11 Aug 2026 09:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786441266;
	bh=upF6x0o7MEfxdunfBPIzs8sc5yUg/F5ysQ6zU4l78Qg=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=tUQnA5D9IZIc+qWfRvafUjrKqa7i8C4onzAbmmHdXBZHGQlt6mxmO6q1eJswgBhST
	 X4WJtxFJQCqC4GhWQyoeGuBZSbr7qP35D/elS3dHMphliFdZKShlSOWVzH3kHqM5+H
	 lBe3iSyXH/JAE3HQ2lvZs7xhQAtvM8vafhvCbVj5VkKnoKNtT1e+XwGd09GhiMpbSb
	 WOOWkFDcDO18UL71Yij2ZNdWP1zFmGsVpi2Z51EPrhL2goqiAolVuXD52JuLiB34WE
	 X8KKB/wUXqpXr6ZhX3XOFmOq7wiNA2+WrvV3ps20MQdBqyBhu7S/dQHsj1YSaIqGPH
	 c6J3yoU2VQrFg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B97FC5CFCF;
	Tue, 11 Aug 2026 09:41:06 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 11 Aug 2026 17:40:59 +0800
Subject: [PATCH] mm/mglru: fix and remove redundant unevictable folio
 handling
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-mglru-mlock-fix-v1-1-8b2321d0e1d3@tencent.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMyw5AMBCF4VeRWZukbYTGq4gF7WDc0yIS8e6K5
 XeS81/gyTF5yKMLHB3seZkDZByB6aq5JWQbDEqoVGgpcWpHt+M0LmbAhk9UwupG20QnWQXhtTo
 K81csyt9+r3sy25uB+34AG5uiK3MAAAA=
X-Change-ID: 20260811-mglru-mlock-fix-20d8f8d4847a
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Oleksandr Natalenko <oleksandr@natalenko.name>, 
 Suleiman Souhlal <suleiman@google.com>, 
 "Jan Alexander Steffens (heftig)" <heftig@archlinux.org>, 
 Yu Zhao <yuzhao@google.com>, Steven Barrett <steven@liquorix.net>, 
 Brian Geffon <bgeffon@google.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786441264; l=3658;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aS+xGS5ivQ4MJAkh8ZjAYFluAUdKiZoNB6Hp2uOPFCA=;
 b=QzDpMiOdqiQmyPPYubWEQCxOqQVgNxoWgUQfC69RFxUpR41Fgir6Rm9fCjFwnrwJG6Xy3ZmuS
 jd7TJKAvYZWAmDOYhA08FgQYA3LEd5Bkud5u8gVcVBeRXKmO1bJ+qH4
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: C3BA1C000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: h499ecfzejhtd88ix1zru1g5bmr98wb7
X-HE-Tag: 1786441267-890010
X-HE-Meta: U2FsdGVkX1/0tps9azI5IgUAWYAK8kQ2zxj6Tm6YVfStEl1R9MnL2w6g+tjJmJ/oaYqiSH6wfGnG28XrbjNu1lYbaaoKdnJQ7Hdg8JTIivFNyXilqqP4FEMPYzcJ3hu+/6yafdXzu0c0BPVhtzYLF6WeeTesiGCLdupFTFRNBtVNlp6d9mdiUBRV+Nus9DmT7tcFD0cWI022eHCpvllHxYcYZ135vrQK8q23ALQnEAN08wqsgA5dRe8R7LJHnYu5yNq7LE4vRHS3h3m++UdPOevPt0JwA9H4cgCBbCsyVjg24kaMhk4167b571Fh07V2WNpZpE3LZX+b0UnADjSn72zQQB8AbpY4qOdCCPeMH5JofEf6IVOKJsd4UostVN6FSySAToqKmkg/Ez5tEKElYVr9oa6Ls4MNEAf/pQ4eHgMDGtFHNXJ5ybRykEbTISVb6LS9h34sAy/xXFR1+w/Zuk4cyhdTbo9S5BN1O2NSRK5tQihiDw79dGlFSC2s1SgTIPNaogYW71QqPRjnEpyv+p5S2YFuXC/PyLGY/k9hLBul4+5LxvmzV9RWjWsfpnqiuPRSqZPZV+rwF2HYtpNhaq2hYGPJn4Tl7ixBIJds2vc4Z1kyWKq0/YqeWNJ3ydXPTFbMb2z+zvxdqI8g0mj2Pd3+6oQ/60mJbRoP/MST0V8WHuHi4ggrPK7wjn61Iw696RN7Bt2mzw1sLyvrmFhZwHoGiF+pcmOIiIFVvAmTw+YAxJzk8IFDrgc5xUd+lYeO1ELt54oiR799mLIYotMHLWB/CPRgWvgQZ2pSlU4hM8h7A2zOdt1yVSHT0OyRcMvn/0r0PoVQ7z0BJvaXSfuVR9pL57iPljrOTIL0+DNKoDBHgqg7YDbYYZ/Iu3NNv83UE6wVtEbv6R0/HYTfuDes7ypNlf3twb6CnLgTke9KG/wvYrxhpR/3e9tR3GLGLTRMdR9CWI0HP4msxCphjSn
 seTqW/sS
 3cFgyKDt+34U8G7CYPo+VbZPfEVOKgb/jOpNZr+V0QbLC2mujJ7B1TBK5jOiCyZHRJT+y+yXhM2kK3UMmwDZCdQOt0xmiyf4Ew4qT16JnGtP/gXC80sPlVOWdtXveA6NY9Qg8aJJAGazOPQIleaiE3GnSIaGCMjzOc1pSCpGIULcq5ALTm/Ln7j5ywkEhyMhLHqUp/OxmKKdljUc//avEULDOelkWMv0jks7ID4yMG8mhmsNmT4H4mtIgbqTtn7S7XlqGBnaMmuHCiVekzJWeY5tOcL8Ciu1brx+kaiFANXifl1U1CSeRvCogH3BkOkRpHlmr9tkrgTWXmc/RUiJsiz0p1bYftKrabtE9TEGMbx/mAA21ZLsvoD5k/STq2Ofw4VXcCOGuSZy5dlXsiKxj42q4Bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

sort_folio() has a shortcut for moving folios that are no longer
evictable but are still sitting on a generation list.  However, this
shortcut is buggy.  It does not follow the PG_lru usage convention,
and it has a more serious issue.

Unevictable folios are not threaded on lists[LRU_UNEVICTABLE], so that
folio->lru can be reused to hold folio->mlock_count (see the comment in
lruvec_init()).  Hence lruvec_add_folio() skips the list_add() for them,
and every other place that turns a folio unevictable initialises
mlock_count explicitly: lru_add() sets it to 0, __mlock_folio() and
__mlock_new_folio() set it to !!folio_test_mlocked(folio).
sort_folio() sets nothing, and the lru_gen_del_folio() right above it
may have already poisoned folio->lru via list_del(), so mlock_count
ends up aliasing LIST_POISON2, which reads as 0x122, i.e. 290.  The
result is user visible.  On munlock, __munlock_folio() decrements that
bogus count, finds it still non-zero and bails out before clearing
PG_mlocked, so the folio remains unevictable and the Mlocked
accounting stays inflated until the folio is freed.

The shortcut also touches the LRU flags in the wrong order.  It calls
lru_gen_del_folio() while PG_lru is still set, so a concurrent
folio_test_clear_lru() (e.g. compaction, folio_isolate_lru()) can succeed
on a folio that has already been taken off the generation list, may
lead to unexpected behavior.  The generic path gets this right:
isolate_folio() clears PG_lru first, so a racing isolator loses the
atomic and bails.

And the shortcut is redundant.  A folio left on the generation list is
picked up by isolate_folio(), shrink_folio_list() sends it to
activate_locked on the !folio_evictable() check, and evict_folios()
then hands it to folio_putback_lru(), which sets PG_unevictable and
counts UNEVICTABLE_PGCULLED from lru_add(), with mlock_count
initialised properly.

There is no performance concern either: such a folio goes through this
once, and then it is off the generation lists for good, since
lru_gen_add_folio() refuses unevictable folios.

So just remove the shortcut.  This consolidates unevictable handling in
the generic path, and makes maintenance easier.

Fixes: ac35a4902374 ("mm: multi-gen LRU: minimal implementation")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 3194da7dcc79..eca5ff64238d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4648,7 +4648,6 @@ void lru_gen_reparent_memcg(struct mem_cgroup *memcg, struct mem_cgroup *parent,
 static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_control *sc,
 		       int tier_idx)
 {
-	bool success;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4660,16 +4659,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 
 	VM_WARN_ON_ONCE_FOLIO(gen >= MAX_NR_GENS, folio);
 
-	/* unevictable */
-	if (!folio_evictable(folio)) {
-		success = lru_gen_del_folio(lruvec, folio, true);
-		VM_WARN_ON_ONCE_FOLIO(!success, folio);
-		folio_set_unevictable(folio);
-		lruvec_add_folio(lruvec, folio);
-		__count_vm_events(UNEVICTABLE_PGCULLED, delta);
-		return true;
-	}
-
 	/* promoted */
 	if (gen != lru_gen_from_seq(lrugen->min_seq[type])) {
 		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);

---
base-commit: 1029098ee3275ea5b78e329ce132262affa2f8cc
change-id: 20260811-mglru-mlock-fix-20d8f8d4847a

Best regards,
--  
Kairui Song <kasong@tencent.com>



