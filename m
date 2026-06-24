Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5EC6CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 09:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95EDD6B0088; Wed, 24 Jun 2026 05:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9101D6B008A; Wed, 24 Jun 2026 05:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825B36B008C; Wed, 24 Jun 2026 05:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 55D536B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:55:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCDA4C1732
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:55:47 +0000 (UTC)
X-FDA: 84914349534.19.ABBA637
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8D221C0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:55:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="VUApR/uB";
	spf=pass (imf21.hostedemail.com: domain of fffsqian@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782294946;
	b=pLV2BRkYTIW+DO/I9YPToTlpHbq7paodyQ43qlNJlaZcKrHSuRjREPMdGLIpPBumB+jP83
	33sZ9eMwZ5QKvtjDHO0HP1dulrhcPHRXLkQA2HnQqPDvjEXOAcGWXQoYk/IJId4HUqUuh7
	spZ6n5/tVrVlc6zrVWnl2gv0FA/GPMQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782294946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oUkW/KEdBAdFt0ECdeaOfS5Jd+P4aZridifd41QEJnc=;
	b=CVYPkXOMPyKi8INtC+QugqpjaFABpMDxIxZlGPgiSZJDyQdIFOl/swNQSSLP5H+4LyYgIi
	FvvsXceeDKM/jTsGgD+ax6yMsX/8oSMUIhAt3KwNxsGA//57EbBL6/kK2fiDJP4R+VMwf5
	se+JbKrQLBGV+ziGf7HGYBZ/O/I+0dw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="VUApR/uB";
	spf=pass (imf21.hostedemail.com: domain of fffsqian@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=oU
	kW/KEdBAdFt0ECdeaOfS5Jd+P4aZridifd41QEJnc=; b=VUApR/uBuoCW7Ev5KH
	+raOi7Z6xmvY+9+9RDM69Elpez01x8QqScwrmjQdN9/WRE+AS4Vhjc1jsl7a1apS
	xnyaOIxlf/QVI0CI7h55VLupFbFU13JCBsPBjfXoKXrHE9uZofu3xZ45eqOPEO/3
	9179CoxGbhW5NzLeZHsiU87XA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3f2SRqTtqDMx0Ew--.31S2;
	Wed, 24 Jun 2026 17:55:31 +0800 (CST)
From: fffsqian@163.com
To: Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: [PATCH 1/1] mm/shrinker: add NULL checks after rcu_dereference() in shrinker bit functions
Date: Wed, 24 Jun 2026 17:55:27 +0800
Message-Id: <20260624095527.277586-1-fffsqian@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3f2SRqTtqDMx0Ew--.31S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCw4fAw1DKrW3Kw1DJFy5urg_yoW5Ar4rpF
	WDKryDJr45ArnYgw12y3Z8JFyFvw18Ca4rJr92gw1IyryFq3ZxXr4xtFW2vry5Ca4fGryq
	qa4UXw1q9r1UZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jw8n5UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/xtbC6hT4w2o7qZQccQAA3E
X-Stat-Signature: dsqecxifd7moa7ctxdtdin1g6hqfmosp
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E8D221C0005
X-HE-Tag: 1782294943-20669
X-HE-Meta: U2FsdGVkX19f/Zcsn/oNwCW1+2hKr5/4/0kfDm2rU8D946y21G4fh0BzPTkyVf10ZU4+IFKNBnrxgVgYUJshJGhgx6Vf/LquxAckxIuOKPgQXj9MWKLsfe8X/NoLGY+Hof5U5HoELirJABiBQrDGG8fp0BYTt7LAsXtM1welse9dF72NJhSOk1h4g24Dhz34DvQQ2CZWJ2+uAbUHRBHYvybfp0yiyCgInZg+IFQ27cBudMlkHz8uY14YxPGkPEM5L9KiZN7aGJ1Zep0SbbgFMK2rtJ91aD+7Vo24RVnyDzS0vH0QRWSxxFp8a92q37usR3uJBWyXS1KtMmrMWBJSlbhGMVTmBigjEJ1KE4aCKf+PjBBJg2ORYuBc1yWhYje9ie/H4cyPqou9BNI/eIDwobHUWzDLQB62p2JRDjEQXcQPO1ItrOvNo57bjetYn1SsCXvl/O+Hw7jLwOYh63UN7mEeL8kZ/uaOjqKvicZmqpf11n5QUx1hR/CTwqDLs4J8GaUJQLbaekrSKrW0fugG2OgsVZcoDatt6/5oV+376xgB7zYGOllDZYIzOmHjPjBe7A+e+KFwH9eS6BmYcggYWhM9w9aFUJodD6EZRwh+HIRctNS0e9/FCiXZiPdYYOfgvXlwmQuOPfiBRZ/1HlAJUGUMqnhO5Fnub5BlstyeJCE54dt5rWGgdSEisyLAYjOr/4O0CsVWYW5yKPhFLaxsLTjG0u8kGkXPIjURZt3PSs3spb6X8aS2lwk0elHaPCtxDAzyJXHE9Nr/S4AoY3F7QAfcIRK/pwJiJOLTvNfT/5j3m+rYTmg4DiLUJx458gh0JGJn+R/Aq2iQMHTWSPTAMG/X6hqMfq3IO+QCmVD1L08HuRchqN7xP/sLWofhV3J0MNFcPJ4GkanZSqyKSrw07Pfvf0tHYKexxtwxXPzN+xIlIPy9G1FzkNeT57duk13+r/q17qYLvQNevBOs6tn
 A68+kQsf
 I5veqjuq/FDUgXQHDyeGnA3KUn02nwEBlFupPeE6PYi4YlBo1RKuUipm3qZNGFhEKR2ZuNz4v5iBb4920EF20veGiE/6JXtRMvQr5dcjWAte/qrViwpMLz3qRd9qQQkB1G1A+bkOoCBQXaoW9PeAeTMZIYhSwk6A84wk+P1pvaKB/Vb1TruU5Xq57Ul1RYoSTyNd8+8S4SpC5oeEDd4jeDU6EIPyptmCqDJPeFfm674X9bu7pUtu3hUDvRt4MGwWLpIx9T3ReGp9LoTNuh0Ln41XGi4N5OqDNLsowOvX547Mmg9HWql1+I1zqwdwwKSX8gdDArM0tBack8UpRt9G2hWcevjjsrxY8nMuJgWtrpjoBgwQW4PbBr4ExWF/Qsp28N4Pb4uQiMDmVRnQ6guSN84XKUEep0WAxTEBBbP0HIl9nWB1o6JgkIMyQHeZpksEFqV92hcrJy9HXHTEy9bnkbEwZxTiRTTb5LzwhC9Gt5K0jisrY4304rS77Xdkz7f2wmwckNQPlQghviH93IfzGvljNAx6vq2uldNNUQZLoXJmNXjKaGiPUbb4skwsCTKWGdGCCoynkk8b43OsNdt95xrfWYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

The functions set_shrinker_bit(), xchg_nr_deferred_memcg(), and
add_nr_deferred_memcg() access shrinker_info fields immediately
after rcu_dereference() without checking for NULL.

This is inconsistent with shrink_slab_memcg() which properly checks
"if (unlikely(!info)) goto unlock;" before accessing info fields.

The shrinker_info can be NULL during memcg initialization or after
shrinker_info expansion failure. Directly accessing info->map_nr_max
or info->unit[] without NULL validation could cause kernel NULL
pointer dereference and panic.

Fix this by adding proper NULL checks in all three functions to
ensure consistent RCU protection and prevent potential crashes in
the shrinker subsystem.

Fixes: 307bececcd1205bcb ("mm: shrinker: add a secondary array for shrinker_info::{map, nr_deferred}")
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
---
 mm/shrinker.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7082d01c8c9d..ecde3cc44459 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -200,6 +200,8 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 
 		rcu_read_lock();
 		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+		if (unlikely(!info))
+			goto unlock;
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
 			struct shrinker_info_unit *unit;
 
@@ -208,6 +210,7 @@ void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 			smp_mb__before_atomic();
 			set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
 		}
+unlock:
 		rcu_read_unlock();
 	}
 }
@@ -258,6 +261,10 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 
 	rcu_read_lock();
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+	if (unlikely(!info)) {
+		rcu_read_unlock();
+		return 0;
+	}
 	unit = info->unit[shrinker_id_to_index(shrinker->id)];
 	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
 	rcu_read_unlock();
@@ -274,6 +281,10 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 
 	rcu_read_lock();
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
+	if (unlikely(!info)) {
+		rcu_read_unlock();
+		return 0;
+	}
 	unit = info->unit[shrinker_id_to_index(shrinker->id)];
 	nr_deferred =
 		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);

base-commit: 840ef6c78e6a2f694b578ecb9063241c992aaa9e
-- 
2.25.1


