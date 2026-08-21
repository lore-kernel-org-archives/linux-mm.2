Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65962C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 10:26:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63C776B00A4; Fri, 21 Aug 2026 06:26:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614136B00A5; Fri, 21 Aug 2026 06:26:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529AE6B00A6; Fri, 21 Aug 2026 06:26:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 267296B00A4
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:26:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8AA7A0CD4
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:28 +0000 (UTC)
X-FDA: 85124897256.28.1F95F05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 184DBC0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:26:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iF+sSeP3;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787307987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xaIllxSu2Y9u0+sAmWxSLKA+YkGfX6Fr0GdsHrBYVUM=;
	b=y+T+i2GRgxM+ds5DxuDRkiPqB4M3VSueZ4HCxSw3j5XKHNg9wrBCdxHoikw+EANNxbpNio
	jlUpJgAfA3jAsXS6djtxvpeTXoZwHSRGUfcjK4xtrT1FOtjjjLy3s9gG6ktwX5u33pcrBZ
	wR02qJ2GLpGExfzZi7GIre5rqLDmeYI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iF+sSeP3;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787307987;
	b=cFkgMaP8ljAMUp3XCu86q9XZ2/7bkmDKqAe0MAld/NvY5dT+P93k0QPk9nxVxcdnb2vYj0
	AaLurkdTzDPC+ixI4l5TEgpncsC8nSap59K/8qK8eT1YLhAjn+FBclO327xeibgM0kqDL0
	cOVIYSBJYVAGoEFFzma9Xqn984582cY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 614FD4396C;
	Fri, 21 Aug 2026 10:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11C61F00A3D;
	Fri, 21 Aug 2026 10:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787307986;
	bh=xaIllxSu2Y9u0+sAmWxSLKA+YkGfX6Fr0GdsHrBYVUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iF+sSeP3VoDwF86my97C70bwVVWVkjD5QSlZlwlruiEgMQBn/wy4kKdvZxjcR0zf3
	 A7I6SU/Zc44/mWsYmI1/wNYCD+kqtBjXd8SV+Gt+1qcvjl+0so/AZyoLkULtlkc4i+
	 Va6Shven2L5OX538x0k7mskcxIQIel19UF43jFTDu/ka1e635+7jped0IeMdt7zC7r
	 ES32xrFLVvOKt8/Gn1G8HlYjR4bFLp3qFI8hXJ3MpEj4MG5eITovty9B6ksi+FEu1g
	 1R4t7tARNjrks8gs45n5MDZFwGQgQGvpwQFmgRrVCNEAomavSljfze0nWzH1V4np0U
	 jOoythJbV4TXQ==
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
Subject: [PATCH 2/6] mm/mglru: batch update lrugen->protected in inc_min_seq()
Date: Fri, 21 Aug 2026 18:25:34 +0800
Message-Id: <20260821102538.22642-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260821102538.22642-1-baohua@kernel.org>
References: <20260821102538.22642-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b8tq47d6qwp1aunhb7wiudqxqeiz19ai
X-Rspamd-Queue-Id: 184DBC0004
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787307986-796146
X-HE-Meta: U2FsdGVkX19hgJFO+lWdomGQsEMPv+4IZRhLiTIIfvnJbTqUeyfh1zjoQL2sSO3EfnH3Sg3zpX4AozzUudOemt1BeViO62GCQYp5KcTjIH80b8vSoHqbsWXmOhqKDA+uPqpqnI0dBMS+GCoM/+pxqmI5IrMSYG2K4GFRhfx8noDrwv+5Iwhc31o4BeZvoKBP/6tMCeTQWX88yjEzT3kc0XLEz7NNTkb7ZEM2sYRxIlZDTL+BEdaYieXApGsJ9k/CrvsYgnsrgn7BdWFSE7xLwAcbYohSn/W2V9UcllMwKZna2TFKHB5rRCaspQ7qEpeW4TUL5i6nkPs4ANyIDxz8fCoTaPy8G1eIO/snzNhnUwokluSkcF/AmJEseQOGjKd1qaOmYGBvG/fIxBpPMmaJwJzuQnLvm87+O4J1/8XZ1A9GXmT3UXguZBzdKl0t1520ZqMsnU9YHA80zQ8+lGFpnMzHDHIV7wA5tSArUY9ZTcIe4ikzTDGc91wPUc7g/5ipRHo99nIVG02M0AMlOWtepJRCeupjzWRTHxvhfCgT1Uwcz923sX4KzREImJAW82zg76yPZB42pEWZrmfvh1RDcE3pfDsHy8/i5QgU97+HGFXb1g66sIvnoFMUToGRWlwUAJGC4NkKrs15ftm7kHgzIsdyunnQUWG2LLsidJTlJ52F5u7EHYscUpyvQkdOB5jA8Rv3bIqVNzs3s4ghCAjezaL+3lbgm7y15jF969oEFXShwgGN4dFjbdX1kB5Cun1kyoK5Eee5inF6DroNj7K/V7QYQceHwnQHnNQNlU084+12yvk73G+0hX7Vbd5m4VsVFhfyOso3m23p7JcD0S9pBJJl2zB3hkVy3wpi51t0dbApLlIjx0iSbX/2tLrRicI96e9JL9PEwrjZId9O2FOnsCqZ/ZTgN+uQUWzVZGx1PndS4//O7lstDBOv2zqXPT+843y0MKgbi2fn/xsge02
 +VZXubvB
 diBv/GbIFYy9FSXnC9c0p8N/oRLfJhiFIoBqrx/BkH6RW5WwBYZ2Eo2cUkWkZd20SGfJXLRBKn6eP4Ap/FkmlIQdUsGiXjs3c3MTRHTp1wcvcCA41+qngTOdf0Jk8/oBwOLofX7+7TcIKbqOmykxz17tx84tP4fq8680AT9XVBqzf0jwYO5roBxuAHtlsn3a0UZHnoZMGmtjrdlFyHy28tjbQMnj3Q0oMj2/WzVL8Sq5dUEn1XslXtDxvhX5hlpNc+irZ32ETrs3T5DP3IeRYowbmxzTrhn/I98Fe8zGxfKiKn/BlQgJt/kQ4wbjqYrEmLH6nRPfYEFkSQ6evYehq2qzEUQ425tSRiuG9G5viU7AhfxD7uZ20gevldnXPASHbCJf0Mi5jELBPIho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Avoid updating lrugen->protected with WRITE_ONCE() for each folio,
which may prevent potential compiler optimizations. Accumulate the
updates locally and apply them in a batch instead.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0d74fc00abd3..99ee3c833d54 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3931,7 +3931,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head = &lrugen->folios[old_gen][type][zone];
-		unsigned long delta = 0;
+		unsigned long protected[MAX_NR_TIERS] = {}, delta = 0;
 
 		while (!list_empty(head)) {
 			struct folio *folio = lru_to_folio(head);
@@ -3953,8 +3953,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
 				int tier = lru_tier_from_refs(refs, workingset);
 
-				WRITE_ONCE(lrugen->protected[hist][type][tier],
-					   lrugen->protected[hist][type][tier] + nr_pages);
+				protected[tier] += nr_pages;
 			}
 
 			if (!--remaining)
@@ -3964,6 +3963,9 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 			   lrugen->nr_pages[old_gen][type][zone] - delta);
 		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
 			   lrugen->nr_pages[target_gen][type][zone] + delta);
+		for (int tier = 0; tier < MAX_NR_TIERS; tier++)
+			WRITE_ONCE(lrugen->protected[hist][type][tier],
+				   lrugen->protected[hist][type][tier] + protected[tier]);
 		if (!remaining)
 			return false;
 	}
-- 
2.34.1


