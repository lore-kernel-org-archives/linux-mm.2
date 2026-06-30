Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFD54C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA236B00C5; Mon, 29 Jun 2026 21:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43406B00C9; Mon, 29 Jun 2026 21:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B32476B00CA; Mon, 29 Jun 2026 21:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC566B00C5
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:29:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 02E41A0348
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:52 +0000 (UTC)
X-FDA: 84934847466.06.EA0C2ED
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id DA83940003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LJ8Tyy/N";
	spf=pass (imf27.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782782991;
	b=cii4U+0u5kFoIwgpfWlVzWMn3/lQVOzsPqxszFB8TCXkSBy50RDbS3HPfHg0rIocZMfVOw
	v1lfF9MM6EneAnpypud3QGwTwexerV2ZC9hYBsh8K3WwbQWtosgNhRcV1euRsr5E5teTzX
	hOT1LEuzQHOV7WeuSGk8p/VYb7qPNOg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+SjXDyaIUskmylTeULQ7YpsBG7g1B+2e1JWTTH/oMw=;
	b=Zk2v/Pp5+/gEF8Zd7pN/UVKuMirAwiZtS6Z/W/6xp77Q+V/xPkPB0G/MqxklaEJeZPkC4p
	2/+p9qJPOsNSBwYlrVFzCQfQvU0Q3+dltyUtRUwcqgG0z7ucsWgu3Y5lJ2ODtsYfD/3joP
	WWybk+duGii7yAd4Lg7q7rokVNnEfWA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LJ8Tyy/N";
	spf=pass (imf27.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782782989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v+SjXDyaIUskmylTeULQ7YpsBG7g1B+2e1JWTTH/oMw=;
	b=LJ8Tyy/NprEhJ1xWl5tZRepKEJ7Bf0iHIWyvd/DvQB/j8JXueF6A951huLjm2u2D+cVJRC
	q+dns6nOTW2bNzOJnTxthMxSXn4oLUUr7N1+ZD/bPOdGaufs0lY8JnEs6PwF54z8GiuLxQ
	J1zBx6IR2GIfBmmIcQp4B6FfUlWqpDE=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	yingfu.zhou@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] memcg: bail out proactive reclaim when memcg is dying
Date: Tue, 30 Jun 2026 09:29:03 +0800
Message-ID: <20260630012909.144372-4-jiayuan.chen@linux.dev>
In-Reply-To: <20260630012909.144372-1-jiayuan.chen@linux.dev>
References: <20260630012909.144372-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pbi7agokercize3rkfxuubgpuiesyy57
X-Rspamd-Queue-Id: DA83940003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782782990-31547
X-HE-Meta: U2FsdGVkX18NSBm9s3FnIO2kOpEHQm+NuX/e3eySWeklwPBbvo5tD4AR0p4ba4FDnCKn8XTNUHyl8LXUO4WwagEdsDLuqJxB7vHlcc23c7RyKmt7TI07HvmOYyFaw3wHP+CP/uEE3BjGl9Q1U+zOocjV36F6f98lU6vJcaFERyEWecl7FQUK5D+baItAQVXdRa8b5/kWCYK87pq7JnS5Pw3UuZomCviR22kjAw7HwioADB7TK0692jZlR4iU83ISkv5If6XV8qI2f6N1AnNEhfxFg7/TO/xh8BdAdMreEEsWSJAs59+yVfEIbPTs4xz/J9Ra4+Ay83rTS0gjOryiUlmlx8LQVZcPOq0swzZZzHzuCMBo+VZUhETye3MxXw77q2P35cRGa0907Tm+bBvP+Z6DOgVrsm1roGl9gOIt9Qvr4DHLU6Q8uvxp9AVG/5DXBhvslKKN8KtCiI+6w4Ov7SNJUZUYFe2DCx9xuMTbxs6NEtI4mlNobS7jn4F5w7RmkCnpP/SZnu+YFjvpt4Z6d/8MyPxrC4LarOjLNJ6/ibQ3rmR6xuSTz9VaKJxW2s0Z4Q3+uuCHfRJnG1Rf+BExTWtDobv3eDF5yKUZTxttME8mGTBPcf4Ovl0UOuGsKZ6VIq74KkpF1wYyvkd8bSJwmTEbW4Og3BRCDB+Y1+XfFFWQ1ePxuBothp6ia0Zhs58+DfEShUeFrGDVXdL5OdcG8s4WspKNFWPYJXvyJu0v9cA0xar3hqnhc1drRkI9E8KX/TCBPu2eTOPQjxrpNHqGJJD86jFMPgWP2/x0qxQ4oUTGqHfvGH0AhcBTxwF3FRo6Uy3xBLG0eKepLeCaucHpqVBaPoS7x/6V5h+Z9wcSXHp8luq6GSyOU8b/updvnbsHyfIXO5lqwtW7BqXnjOaxb38UhjqVZ9bmYdDPQGLWZftaLoBvgSG4HiLrwORa5fV3BZiuup5ksFSZjxASO43
 ZcILRPh7
 Xv6Gtfmxn+3oay/MsrDbkhhTioNvOplmfT6aer66I7Wo8m1SX9nk9I6TSIS0Ie8YjO4QTH+3WeaREdRHMz2krtXRu9jDJgszE4SCVnm0oohX5iMLPpjXwFAkWJgpJy3M1fTqtdtcdcHB9xqkt1uPuUp6Y45P+AD5YIRAvQw7tIMWaUbSFZ4hLJ/cJWtnekk8QOdun9Sc9lEkMIjr2fyGp2RCFnPq08iZ/JGSH02j6vGGA3RunC6lHNBP8+2dnsBpBv8hjdVjTy36XcpsqByhgULVVvbytTmbbbT/xyJ0cc4Uf5/WifeLdaVmMgMBv6VTtbVrf3p5wZoghRrm7nQCCRLiQUn531C9uQN7x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

Proactive reclaim via memory.reclaim can run for a long time - swap I/O
or thrashing again dominating the latency - and delays cgroup removal in
the same way.

Mitigate this by stopping the reclaim once memcg_is_dying().

Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/vmscan.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 754c5f5d716a..091b609cf1b1 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7912,6 +7912,9 @@ int user_proactive_reclaim(char *buf,
 		if (signal_pending(current))
 			return -EINTR;
 
+		if (memcg && memcg_is_dying(memcg))
+			return -EAGAIN;
+
 		/*
 		 * This is the final attempt, drain percpu lru caches in the
 		 * hope of introducing more evictable pages.
-- 
2.43.0


