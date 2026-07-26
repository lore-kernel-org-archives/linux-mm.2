Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0567C53209
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 20:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8674F6B008A; Sun, 26 Jul 2026 16:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8183A6B008C; Sun, 26 Jul 2026 16:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E886B0093; Sun, 26 Jul 2026 16:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4662B6B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 16:56:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 804B1140524
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 20:56:02 +0000 (UTC)
X-FDA: 85032134964.01.E7F1A6F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id EFED520008
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 20:56:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcbZP66i;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785099361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Cy1jhkVJMikuaizngOmkeHoHcCAWhI3GKKlTl+pKDaY=;
	b=pOeccVucXe0aZSEUk3nEKNGT6clmbkh42pJ0PMm3HvezQHdqF01w78xYlBLla0JChU80wx
	Ta9Bok9HOLxFgWvf5i+XMRF9sc+a+ivRa8vnJL12CpNOxGggFcbSogFRyysacv/x7j+hVG
	AZn9JaagrYuPqg0ibgN9Uw9h+f6sibo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mcbZP66i;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785099361;
	b=gd3dWeKvJdAJAszP0o8LXJ/fZ8RFO/khzUDWjy1Z9p8ouiF1XGrBcIAJ7mFpq+EmNBjbU0
	FBdtPECiKgEpyM4qo/iDJlh0qFnRiI42q/d81J0v3XSbRLntVt6zKK4JRM5uNtv3zH46s/
	HdbQwrWM2VnEj3cUXWRZNwNIGE1BMjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E18FF403AA;
	Sun, 26 Jul 2026 20:55:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D4C1F000E9;
	Sun, 26 Jul 2026 20:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785099359;
	bh=Cy1jhkVJMikuaizngOmkeHoHcCAWhI3GKKlTl+pKDaY=;
	h=From:To:Cc:Subject:Date;
	b=mcbZP66iHAvO7Cktqkzc9+AqeuV8RWgPJ5gtYgefh4R164h5kjvdkM3rU7tKU7cWW
	 dPxWFDuItoovOEY4JdMDkayHK9EzSfkYbWIib/xDP/R956LgfAZMrnvTrlPzC7uOO8
	 dnYo8kYcuFAnJeqL+Po92OFFoLcu2sdbnN1ZzXTRYanbemJGHEIwBiExnMGQ12KkP/
	 Q9oylu9KQudphgD/Pc4+9PwbpZ4wFaBXSCej8aLZU7Qcf+ZJnkkhXnMqD4whsmiq/t
	 FErlGOYnWiXVYU/lKnCmJqw5eNuWybGXUQTcXczHNpe0Uhq2+Btjdsdo8C8vRpuEyi
	 k/yV4yJfl4tbw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Honggyu Kim <honggyu.kim@sk.com>,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon: adjust isolated pages stat for DAMOS_MIGRATE_{HOT,COLD}
Date: Sun, 26 Jul 2026 13:55:46 -0700
Message-ID: <20260726205548.2287-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EFED520008
X-Stat-Signature: oei8nx43iukwyzqcx1r5cry17njzyw3t
X-HE-Tag: 1785099360-76418
X-HE-Meta: U2FsdGVkX19A4Hmz7pqu+LEw5DqauWCmsnbpm4M82XyaiFHtpCwMJT34IBbfBxOY9zaLtpL5awvNjqO3OLEP2JR1MvN1p3AelClX2K/nfdq3UynDjWcPsRQfZLqYhBNR9/fFkUanBqOI1AcuBpVBzd9/y1YuHH4sBQ8Wh6nlUsM4NVktZgZhQpW4pcNJ9x6AppDLq5V/vW3b709kgVplEJ/0TqC8CThtHUENBUiImySO6/iVukDMreWHn5PhaqWgFj/VVLPwGi2BaMHAZicfTGEEpFoNwk/R+HyUztdE6VXYyf6w0JibX3+E48cTVM42oy7juXDy0PO7CPehnc9opXdKoMMfrD9FaI+2N9FXQFo5jtHDEwdx+G5sGa4B/L2zJwVI9TWdaDbpuCj445SZJclJkcWjvKMaI6b/QXQ/d4V9MppmerNqvNv8rYQDvBvK/ubzOIOBRmxWb/EpSygcim8F9gjIHNIrfvfOy2cTfcZInSg7kWMrxxC8ok22VnNJ259sKeR5kYR35fWXjV4vBuOG77fVvvMCJiqVZHUW4xSfbxUggZzX90WLAkw0C/dP4FyE3Oyo9CKHWs6FQvOcZZNHZL+OGkX0MoUM+tKU55r+4pIOqAqTF+zMbgQVG8ak/KnIWDLbU1Ga2fH7QCNK+4aPz4M4doIIkStLgc5Wqw8A4tZi8cJuF//lNVw8/Sl+4j4JYO5yqoWv/FiIDURQkPkFas0PoJ2YqU9h9cO0rUOlOVMozrUN7EhdLWuwOneOtSyjKtJ2JuM0HxbQqMzHul8cbIsvUs+EI5rEPi16AJkKe57NL2ZAnj0hoHllCB0EI4sxk35h3ofimzmbqValWHUR/fILRIQYLYq9PosKVXmiM+ALYRepUt8/xVXHqdBVnYgbJ9QHY3/tfk4vY0guD432Rse7eecqZysSys+tRNQ8EsSvGhyvcb9zP5ScDC6HIVtfxf62JBbKSk0zVYr
 +AI7PmzY
 OpHUiy65q+XLeESh9knJLV748o8kIjBWl4uZylkjTQAVGNzeubqPpytLpiKTEOYUDk8uka4T2MEL3/5uQ6TGJ+md7HRhM4XRqneOZaBkzFu3POhKTVrJwxiZBBFJuACRiUi05vBqZfzEZXorpOj7MBqRFT9MEbIBxsDzM5AUwYzkFm1IFlYJS5v1iG17rugnlGJnsNcr62UCcdMhdGDGprD4QPTA9/V8Y+sPEtLY+f2R+Rx0A6BTyYA9SZaCXtn+99bdtnboyXVf4MNKgV05HVb9maPCuqktrA1suRq6odpk5+e/Y9np/1InOnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Callers of migrate_pages() should adjust NR_MIGRATED_{ANON,FILE} for
isolations and putback of the folios.  That for migration succeeded
folios is done by migrate_pages(), in migrate_folio_done().  That for
MR_DEMOTION reason is an exception though.

DAMOS_MIGRATE_{HOT,COLD} call migrate_pages() but mistakenly not doing
the stat adjustment.  As a result, use of DAMOS_MIGRATE_{HOT,COLD} could
corrupt the stat.  It could confuse too_many_isolated(), make compaction
and reclaim to behave in unexpected ways.  The stat corruption can be
reproduced and confirmed using DAMON user-space tool [1] on NUMA
systems, like below.

    $ numactl --hardware
    available: 2 nodes (0-1)
    [...]
    $ sudo ./damo start --damos_action migrate_hot 1
    $ sudo cat /proc/sys/vm/stat_refresh
    $ sudo dmesg
    [...]
    [   80.215554] vmstat_refresh: nr_isolated_anon -5578
    [   80.216842] vmstat_refresh: nr_isolated_file -34400

This issue was discovered [2] by Sashiko.

[1] https://github.com/damonitor/damo
[2] https://lore.kernel.org/20260726164356.87940-1-sj@kernel.org

Fixes: b51820ebea65 ("mm/damon/paddr: introduce DAMOS_MIGRATE_COLD action for demotion")
Cc: <stable@vger.kernel.org> # 6.11.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 2 ++
 mm/damon/paddr.c      | 2 ++
 mm/damon/vaddr.c      | 3 ++-
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index e59f77eca83b2..9809fa12b09a8 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -374,6 +374,8 @@ static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
 	while (!list_empty(folio_list)) {
 		folio = lru_to_folio(folio_list);
 		list_del(&folio->lru);
+		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		folio_putback_lru(folio);
 	}
 
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5a6a78054784a..5c6c3a597fd0b 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -346,6 +346,8 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
+		node_stat_add_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
 		list_add(&folio->lru, &folio_list);
 put_folio:
 		addr += folio_size(folio);
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4976775fe2762..0648400b2d65b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -627,7 +627,8 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 isolate:
 	if (!folio_isolate_lru(folio))
 		return;
-
+	node_stat_add_folio(folio, NR_ISOLATED_ANON +
+			folio_is_file_lru(folio));
 	list_add(&folio->lru, &migration_lists[i]);
 }
 

base-commit: 1e15fbef3a3c465a6a2db0f38e3980d75420bd6d
-- 
2.47.3

