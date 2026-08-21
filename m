Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFF6C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 06:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32C46B0095; Fri, 21 Aug 2026 02:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE42C6B009B; Fri, 21 Aug 2026 02:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC4E6B009D; Fri, 21 Aug 2026 02:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A987B6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 02:41:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25DDF1A038D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:41:18 +0000 (UTC)
X-FDA: 85124329836.26.40D8AC8
Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E46B80006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 06:41:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=erA3EBmz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of enlin.mu@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=enlin.mu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787294476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=sOwOeAkjdzft5eJ7i45oa+rAz5wPdiDKRyJIYIlSSBA=;
	b=vCxahOqwShmORUaslY0njJi5RD5ji5NqyE4prFQBWCGtlp76RIoORPZxH+SGw8vmABBRZd
	ecbgNQccLEf8VhgiFWVR3bEcKc+l+TWlNG+WsxfEVi5qXMA0V1UDc1sKuQcxR4HXUock9a
	CVywpdGYwxtvD+0FJouyHkVbsoRwc/4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=erA3EBmz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of enlin.mu@linux.dev designates 95.215.58.191 as permitted sender) smtp.mailfrom=enlin.mu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787294476;
	b=G2Mt9BRglLHycHDK0rNKWn2ssP5beFRfjff3hz26zq08KP9JzjVKty/a9BlRvORX+YPhgl
	C5w7tE5XwNvN9cMeuHpzvZwYw3jUbZlgZr9WnP6e3Cy80a2b6jyd9AvttuA4J4vRl7mBkm
	BIIi8zLsHwcPf45KU26Tarmcpo0UvcQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6KGQRjY1sVeRKd6gftJizGDGbmdsHlLRR9CVuOhEP0U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787294473; v=1; x=1787899273;
 b=erA3EBmzkORpxx/RqIQsKH/u+7Ooe29W+Nm4jg0lBh2mO76TrE5Df91dwXzf8n+MCOJXArv8
 cmb2GIEMrK5O7ASgB/1oaHam/ArLWjkf9H10cTqmAP2kaEv+ZabZSsl4vb3RSf1XFrqsTqSBjcF
 sjOOqAg9frXbaFaekDoUMg+8=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (2408:8411:24a0:401:66b7:563b:1733:817d)
	by mta10.migadu.com with ESMTPS id e84666c61e62ed05;
	Fri, 21 Aug 2026 06:41:12 +0000
X-Mizu-Trace-ID: e84666c61e62ed05
X-Migadu-Flow: FLOW_OUT
From: Enlin Mu <enlin.mu@linux.dev>
To: akpm@linux-foundation.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	enlin.mu@unisoc.com,
	enlin.mu@linux.dev
Subject: [PATCH v2] mm/vmscan: fix comment logic in balance_pgdat
Date: Fri, 21 Aug 2026 14:40:57 +0800
Message-Id: <20260821064057.4081-1-enlin.mu@linux.dev>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E46B80006
X-Stat-Signature: 96z6bmn7negdqhgiz3rxx1rks6n1kn9j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787294475-198153
X-HE-Meta: U2FsdGVkX193BK5XeKBbkaYJEn72t7OB+tAaGEcKKxuNRI3dgJnu5vtpLZueuVNIzISk4881FUJ55rL31BS4MYraIGdIKj3fjaue//gKYm71SyiuzM0/p40Z7eLQBDRMJp8dDcDFdPLsclxUVY6vEAXWgYahtZpehiEeToBT6it1w2+C/zjt9bpOuiCMczwjTpEYiTb2APUVfO1//LsvGxC7ji02HDdUM4rMbYRtoOHA2bCg5driiEH3sEb6Tvp+xAiP4zJZYqmiPf3h+8Dxm/r7M3d4jaJZ6B2r+ew6vd0vTe1GZXN3oNFKGTAJPP5JJni3SdnTA88qU8Kc0RbQji3HpxrUITbEmZ5BOwDrSMPRX605EsHVpbLRtHxZ7iM3tE0jpwpkGEZI93QW+ftfnaqYSmIleLJRdhymb2T7zCa/L0X3tzb5Lj0AaGyATSqXnohkCO4T7/WOfSCuzZkC0PY7Wj+v18xtsVQfg6kLG5PaSn0dtU9VuhTLPugQz7lJCNHVwg3LVaT+FmQdGXpnlFAzrb92/wg66cE70znBujVa6U1ytZPfKHp21D8Bj3+dpf/+0Wp9KV4z/BOY8hnKKT0kC70QhM6uMYysfsbHCMI3keCLZve1dmWKWTWMyDiwLaAs+V7tiwBbYvx+Yo/GiLtdmlmmoJI2w9eGGeM0cBOL4vZCOZeJDwJNpLTM0TXnHhZAXJMlpDasuI4o5bDU+nqzKHTqPzfOhwwoPE3CiqiCWLs6a0Bc4EyvdnYuCYmgQ32ulJBwIv98oxOP4gcaEGh0VoUgSVHYxGmAp9xTrLaIVE75s6f0+UTn0Qb6JWltEpiEdJgRGiG+JtLEsb+C5LrqVv5nTIUvnN6RTh9d/8TIlAAV0uY2yb5OZiZ7OcczgQn8Pq6raTw4tLj1x8RB7OiEAmMwQomyIx1dy4EpPhP2+cTUJ45ytkJDrIhPCzXQnVyML5vqlemKulpnIhJ
 ECH02wiN
 zLlqCXBVULpQaCPOOA3qEgGIxe1gdFdE/0CXMkv93b/cuF0S3ke8+ycg0zZuh2lnMPoeHCom4ThmLuCZ+RxSFB8Nf6LbC01ZLIeLCdZBFHuhLKQnPnEIoFB9ZKAv1g6YxHcFkGikNM6UvLb5Y86OufvhvwPr9x5Qks08b4s5t0l4X+/aeU3lpDYxpKUsXdZi0s+bNcSudEAIs2pk2RB2y63IyahD4R+/hYqshd10Qd2HQ52/sMEV24ijEslDtVxe7mvu126NkbyoSqPXtSBc2CjUi74N7nmJqnvDtDszZ0UTaaVmEUiA1RPcP6ZJpvOaa4BUBLoOHaA9pYxwVLTvOuXx2QA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In balance_pgdat(), when the low watermark is met, processes sleeping on
pfmemalloc_wait are woken up because they are able to safely make forward
progress.

However, the comment incorrectly states "they should not be able",
which contradicts the actual code behavior. Fix this typo to accurately
reflect the logic.

No functional changes are introduced.

Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
Signed-off-by: Enlin Mu <enlin.mu@linux.dev>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..8c4766b4c29c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7188,7 +7188,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
 
 		/*
 		 * If the low watermark is met there is no need for processes
-		 * to be throttled on pfmemalloc_wait as they should not be
+		 * to be throttled on pfmemalloc_wait as they should now be
 		 * able to safely make forward progress. Wake them
 		 */
 		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&
-- 
2.39.5


