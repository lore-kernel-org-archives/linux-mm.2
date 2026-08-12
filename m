Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F947C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 12:19:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769BB6B012A; Wed, 12 Aug 2026 08:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741F16B012C; Wed, 12 Aug 2026 08:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F166B012E; Wed, 12 Aug 2026 08:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 444886B012A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 08:19:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BDE08120346
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:19:10 +0000 (UTC)
X-FDA: 85092522060.14.E3E771B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 36FE5160009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 12:19:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BsFRzI2n;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786537149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOSrpdrgv6m75PZgqu/T7iS0CPPWanT5qI9R6irTmB0=;
	b=Rk9/5xfmknzxOM8TTodbfxOudRNBdbDtfaxjHF+ombnbKE/mHykdigyq4ZIZDV2R9LpfUo
	74f0QNp9UVcnfWDG0KUwTLEt5xnPUdeBeyKwJYZWXFJRp5qA8jV5DVtAhr5MiCYOfnxDqb
	b44OaXrCvBF88/Eg57+ELhbFfIednjE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786537149;
	b=wbB/cSxJ3SOQ+VRR9Pk0vBQR+J4sDDzhWHvWWZrUxLLZCFFZ735bLk1+NJ30sHKXfNifyk
	owsPKfa/90skhrqXWSRxeaH7d7XE/5pdE8m5XCbEiL+uohav44zuWJUN6Xphs4jznf4gg3
	s8vmeiGs/9unFp8p0Sb1RlyagUueu7I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BsFRzI2n;
	spf=pass (imf08.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7EBF60A9E;
	Wed, 12 Aug 2026 12:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99A31F00A3E;
	Wed, 12 Aug 2026 12:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786537148;
	bh=SOSrpdrgv6m75PZgqu/T7iS0CPPWanT5qI9R6irTmB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsFRzI2nY/1moZp4Yo1jlnOlYcl3kc9gOA06lA5u6dIR0/qRsH/qbcaotVI9o6wVc
	 D7f2GopsSziedN0lyRn9BqFZ7s2cLl4ptJQVjlnLdsGkT0JaPDJqYjYH7uOrugOp06
	 +MazIwctBjQKUerp5d4ILwNXf74z6BkGGmtr23nDuDeWS6qRXK6aHL/nlazZekMNAo
	 JtEaAspJfrtH0EgLKph41ZGAWAfIUUSx+A47N4QFWZfBlBFtZo70kSZ3vA7ZOFpRRo
	 3HI2LzekNYZsaoANA0beFRJaWuyBIGBJZiEXxjQ9fFzaCTF+KjHJaAKWQSp600T82H
	 94rX0SYL89juA==
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
Subject: [RFC PATCH v4 16/16] mm/mglru: reduce folios pulled from the oldest gen in inc_min_seq()
Date: Wed, 12 Aug 2026 20:16:58 +0800
Message-Id: <20260812121658.69965-17-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260812121658.69965-1-baohua@kernel.org>
References: <20260812121658.69965-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s3ccky6egnjh7okm71ii3kosak418ibo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 36FE5160009
X-HE-Tag: 1786537149-570430
X-HE-Meta: U2FsdGVkX197EQVbE5Am8/HcOgxd8araiOjqs9aGEsgKWzzIDT4qwjcsDWUBG0u3XpFtcliRwsWDfuH4dzkyhhb/hPuE3wmT1bQwCx8+I5/PZOcNY8yMyr7MR549WBHinvfGZUx1xRjrPIAo/qpEjyM/CSOa6sqLVMeIhemNGBUWyuVnQDGJzPzckcchfsIPG/f7vMUU4Q6jsyZBLkxz/00j/YG6sNwuwRTnh+ze/bOR9pEBiiefYOMRriezIMibOnGzIadPWRI2QNMesYUh6dnxlInXLzsR375JWqjNANu1xtfENoGPKCXznY67yGAsNoMzQS6mQxfy34S3GZvEt7yEP7e0Aa+3rxZXQ+uOv+Xv1SX78zOJbAcAjLtjG3k/Qe47o2mpFM/SOehE0HJXMdF/6RX3kpLe4iqZy6qsnZ0KQgRJ7UcNxjoEHKfqabBE+pJajzR9gfZvvEsNXCdTVKgTls2zgKbOMrU0ZiGwGo5+zMkrla65huJK/fgfpmZvLvm4ayymJ4QQ/Zo1W0Cg0YPpAw/c7MkbjOq3JXtJo2oxl8P82MN5/DTDrZxL16eT5ZtAHr7B3t9kB9qDQ/L515BzKj8SoYSmQ4M2rhjHJm42MRTcnjYgkufumzN63IBa8CExtVPOFo0JbhP+tVXFf9VaJ9QH+Oyv4T8tbxMta0jcU4x8uc2H659dmEZETIxP5eMiapcogNAzL9ydRxjaXFPkPHREQzBpg/3dZPSIMR+iZ0sixzUi9/nJ2hH74BezLStrForjV0LPbrMbmO3Kd4hXzQn4RGpColy+XPj9eS1eGfCMmtH++P6QRwzL9PeLOXG9ch/CWBm/M/33ajNvmMMgZ6ruoVdvr3y0JFjuD5Oz9f8w1gcc0QNQ2k/j6TQ8HPDFST1ZvFMBp0X6y42OwIyS7ZJICKODx1mrSRZHKqe9tMvcI3AbTlADj035fl4WQeqknMRCkRet1Mfzlq/
 8XeC4Olf
 Z7UcVbL0q1N7WNqqYNJ1Hznfxhk04oOAbAzJDZiEv3lRvn7qxfJcOQOYjAP6zjpRqxZ3B0D2iU4cbCRApgE7GZzSG3HG3xActbWAw04Un4MEI2md3wi4GNDYTV+7N3lAwIknQe7MTn1yA2bHaFJNPvadvElsAYlO/h3Z8lJodPXs33/f3eGrdUrTfuaOTNRQhH+rMwTwESyfizUvneTluD8AGEBMyYg2htIQ1E9yM68T74yISviiMsvOeoOM/4YrC2ipTQyQIFphDdpp1HNAt13Pr9MMKkfMcgnC1cFXHHzEeXKieVKGe0/Dj/y9CPnAaphlxbTkO5Cd4n/dyhoPlRwbX1JXZpL/7nx5U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pulling folios from the oldest generation to the second-oldest
generation with MAX_LRU_BATCH can take a long time, as the spinlock
is held throughout the operation and blocks other users.

Reduce the remaining batch size significantly. This reduces the lock
hold time, allowing concurrent reclaim, lru_cache_drain, and other
operations to make progress.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c0350a8b61d1..8e6fcefe0353 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3945,7 +3945,7 @@ static inline void flush_lru_batch(struct list_head *head, struct list_head **ba
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MAX_LRU_BATCH / (is_extreme_swappiness(swappiness) ? 2 : 8);
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-- 
2.34.1


