Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0502D3517C
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C060E6B0005; Wed,  1 Apr 2026 09:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDA56B0088; Wed,  1 Apr 2026 09:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A4A6B0089; Wed,  1 Apr 2026 09:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A246A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:11:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0204313BC84
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:11:04 +0000 (UTC)
X-FDA: 84610022490.22.ACC80CF
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 82A23A0006
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:11:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LIIdPKHb;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775049063;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mgCTWf7qwfX+f4FasYCf9pvnEVA5J3IMh0t61cA9U0U=;
	b=20DPCVF1F9Z4wAuJSpnj/5jDTKHB0cJp7lbPOYbDd/p+dheaXDOE7Pp90ugCS/nO8Hq4jj
	VdrpLd1944ELeIMJeQ2X2O6vx4vxqxkrMiPity2my1FJq4UDGEpuC0RehYbHnTINdUR/J4
	zL7cWuu2vEUbjWZ9AaZbCZwiLH0f3vo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LIIdPKHb;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775049063; a=rsa-sha256;
	cv=none;
	b=Z7zhiRX4X7sL+LYPbcw/P/XgW85qBM5wf8ZX6nxA5FddDzffI93fHeg4XVGRH4UFbkgEDm
	MtQzi9pwS2RRcQuObAKUaa3nlEOBPKqRyuo7wswj4LzjCfuBc2+oqPF4KLSBzg7RlPcwS6
	xUA3WPOljLuRx88Xxr/SUNc1uXIMVjw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775049057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mgCTWf7qwfX+f4FasYCf9pvnEVA5J3IMh0t61cA9U0U=;
	b=LIIdPKHb+EO+CCRFz7iFJRL70kkuK/rrkRZyrsGbypdgBp4Q2TcJ92y7IpkRczgume3oIo
	16xNCXwa7XwzREZWJbmuhwWJ+3VlWmU4utdtxHYu0BBSyMgp5lNqurzimzBTN7Sr3xtvqL
	7kfp7YC7wDOrFP3VhSLB2rRr21aOyWk=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	richard.weiyang@gmail.com,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kartikey406@gmail.com,
	syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH mm-unstable 1/1] mm: fix deferred split queue races during migration
Date: Wed,  1 Apr 2026 21:10:32 +0800
Message-ID: <20260401131032.13011-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 82A23A0006
X-Stat-Signature: jsbawzih3px4hsazphh33bc4y7nt4y8b
X-Rspam-User: 
X-HE-Tag: 1775049061-364485
X-HE-Meta: U2FsdGVkX19uMIfHrip+W9TqXlCtMAuvfkScxVK7/AUZpHZBXTZdXiIpKTCGN21bH1DzW7W+XSqPujCnKhx7cO4CEb8ZVrjpXe/hLyn9NcxiBMGhf96DlU5ER36GU0VpZFK2Bi4+yHqtAr/mox4esApqcQRJibbAZssN68U2LRsn1z34ETsdssOXrM3P5RwrvtXPcYkWXrk13JT6843y/4iXYiJfmJVBHJc1LAKeGUyNn0Gu4w3j9an7PUok40O2p7V1FS07QMR1Xx9zipw0+ErE8qY33iDKgxvynUOjgGUSEtt/GKMmsoQ9JCRhxbe5f3dHJCGUftTH/YpjQ5CO2AGaqvNUHp2XbQOGh5kYGDozEm4jTgNOuZBxHJ7EwGh1Fu3JU/uywtMG+XjgbJbrTBAZBuupTo1kh8JzbUitgKdtLiUsyV9tIeukPIQfBkoKDs3EWa/LzwNODH95vaf2EGM1mizX4htSxI4BEe+K56Qvx96rGFKlUCP+FOgcvJ+OW/3P2ePtMBtOj9LCb5DnltARdgdQycH1D2sTVm36H80L3aCtlp3oo1lu4Fxa3sTCXgARwB0YQymZIAqIqi5uMOAITic2+Wqe0M9AHjmSAa3nu5zpY2hH/Ut8NadE+Rsw8WNIwiSpFi8BPB8UtxIQj+4bx/ZgIlFDzdPMubqVg+tjxmDFaB1Jr5DreaF4AyomEPOW9LyEGIpaccSnhcYlgsls+2GlWriAcmiHrCDErwmdlegPLf8NyHFiyrXkEtvRnSGUz4lEPSq1b/zzSbh8ifrL6VdCHtLHXL18v7Nr9qi+GS9vgUY42Olc+J0D6duZHnlUBXiygOGKLvqDdNMMuH/fHqJP4FGyH1vAjsm8j8x1h4nk3TZb72uUP39GggijlLleO6y6tCLWF2QLrg0R3ySyR6f7PwOjOFyjMmNZYKnAGYvqXOJycqwk+oL98hJAe58cedB77bdqsVGnTn0
 Z3VXcC7p
 bt5NDoBhD4HT/dyzJCLHXrFnbVy4bC8VVmT+7ZQQWfqo8vqH0pATnZ0yOVoejBZXxl5WXM4BDEDETrg5Xy7N7tjhXIWwBQltY5jDajigsrsSdOpakZjGhRXqjSzc7F/6BAa1Ntyf99TZAsijQk0r7533soCa1FmRaiD8fZvC+Mq19ADd1r+YQRyKqnw9SUlroho4J43udTFbNnfTvdY3bogtwKsncwgGaPctwH9skosabMsVjMxwYJYxAR+0E44uKDwHay7UGadixyXEfUJvr8wziZ61XuFMu80NOUC6tef0QI0pSNnA8G/yRdfBybt8XUF+NnmNNC4ZMLuuxINmuxp7OjAPBd2oheFJxx17lgSbGm0XNrEvv5nHETWbKdbh3eHt34GmUDbIdBn/VvFWMPmhQdTHShu1GwpUOBQccTL2uPaUpCMNO2uAEs2olSTQJCbyMdWM41wrzc8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

migrate_folio_move() records the deferred split queue state from src and
replays it on dst. Replaying it after remove_migration_ptes(src, dst, 0)
makes dst visible before it is requeued, so a concurrent rmap-removal path
can mark dst partially mapped and trip the WARN in deferred_split_folio().

Move the requeue before remove_migration_ptes() so dst is back on the
deferred split queue before it becomes visible again.

Because migration still holds dst locked at that point, teach
deferred_split_scan() to requeue a folio when folio_trylock() fails.
Otherwise a fully mapped underused folio can be dequeued by the shrinker
and silently lost from split_queue.

Link: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
Cc: <stable@vger.kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---

[ Backport note ]
This patch is a follow-up fix for 8a8ca142a488 ("mm: migrate: requeue
destination folio on deferred split queue"), which is currently only in
mm-stable, and should be backported together with it.

Credit for this fix goes to David, thanks!

 mm/huge_memory.c | 12 +++++++-----
 mm/migrate.c     | 18 +++++++++---------
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ff9a42abd1b6..ac6d823e351f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4558,7 +4558,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 				goto next;
 		}
 		if (!folio_trylock(folio))
-			goto next;
+			goto requeue;
 		if (!split_folio(folio)) {
 			did_split = true;
 			if (underused)
@@ -4569,11 +4569,13 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 next:
 		if (did_split || !folio_test_partially_mapped(folio))
 			continue;
+requeue:
 		/*
-		 * Only add back to the queue if folio is partially mapped.
-		 * If thp_underused returns false, or if split_folio fails
-		 * in the case it was underused, then consider it used and
-		 * don't add it back to split_queue.
+		 * Add back partially mapped folios, or underused folios
+		 * that we could not lock this round.  If thp_underused()
+		 * returns false, or if split_folio() succeeds, or if
+		 * split_folio() fails in the case it was underused, then
+		 * consider it used and don't add it back to split_queue.
 		 */
 		fqueue = folio_split_queue_lock_irqsave(folio, &flags);
 		if (list_empty(&folio->_deferred_list)) {
diff --git a/mm/migrate.c b/mm/migrate.c
index 05cb408846f2..8a64291ab5b4 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1385,6 +1385,15 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	if (rc)
 		goto out;
 
+	/*
+	 * Requeue the destination folio on the deferred split queue if
+	 * the source was on the queue.  The source is unqueued in
+	 * __folio_migrate_mapping(), so we recorded the state from
+	 * before move_to_new_folio().
+	 */
+	if (src_deferred_split)
+		deferred_split_folio(dst, src_partially_mapped);
+
 	/*
 	 * When successful, push dst to LRU immediately: so that if it
 	 * turns out to be an mlocked page, remove_migration_ptes() will
@@ -1401,15 +1410,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
 	if (old_page_state & PAGE_WAS_MAPPED)
 		remove_migration_ptes(src, dst, 0);
 
-	/*
-	 * Requeue the destination folio on the deferred split queue if
-	 * the source was on the queue.  The source is unqueued in
-	 * __folio_migrate_mapping(), so we recorded the state from
-	 * before move_to_new_folio().
-	 */
-	if (src_deferred_split)
-		deferred_split_folio(dst, src_partially_mapped);
-
 out_unlock_both:
 	folio_unlock(dst);
 	folio_set_owner_migrate_reason(dst, reason);
-- 
2.49.0


