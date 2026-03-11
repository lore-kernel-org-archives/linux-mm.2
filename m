Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ED30FCC9B0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42AF6B0005; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1436B0093; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB6D16B0095; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94E556B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DC1A160629
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:34 +0000 (UTC)
X-FDA: 84532654668.04.BFD6177
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7DF9F1C0003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JWw+fn4S;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773206972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qk+0xtjMali2REMMB2sBmhDoIShdwHw/14PiE2xR1tU=;
	b=DUZzBXueN9n1Is1yWUoVH14Wf1BmOTE3OegZ8V7auM6v8VZl8XkIGAFRi0DuFOdU0R+EeZ
	wAMQWoZfL5WS0ZEC+DkjHV9LM7oDg1NXGu/z7Bhf0aGn6/nbdBNxArCcd6qxeLCWhsg9Cd
	d0QFl1T667xWRISo0cLJcPdMlDOKfMU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JWw+fn4S;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773206972; a=rsa-sha256;
	cv=none;
	b=r+oymLHpfOWYJHcCHYk5Fn0iSJUVG9K+ISUSVnHOpmGZgyjxSx1sUdwvfE92277tp+nh2i
	iJBcWv9pkKLLq0zEkwSzKnnrdgUzNR/7tbaC5LNEjyOHO28DNu25dFcHB+fT2gpd5XVj/e
	0K6dSMCPVp8TcUD0ZVzgj3AUKLpC/UE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD1A0600B0;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B62CC2BCAF;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773206971;
	bh=7cYdKplDL21iIsxLZsDyZKirI/10a9vKJC4T+MgvDTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JWw+fn4SeVXEJyK2LlrMabr7MCW8ceh7oXjafpjdByQY6fgdPUa+Au9wo5OyE8FaG
	 u0njAgR7wJl/LdCtj6lXrOH5pM4iis3sXjoRuFy5lxWTqhF65RgKVC1qClZL88/Qj/
	 OLPv8oxEwwHcv5ki7k9mjBRR15mtR7yMh7LqojsZxaE/rXxnf6I9a+9QSW4xwmkvWw
	 hie/G4BUkhn2jGp8Omc/x5lzoo9JKEf4I53UNbxcxVfjb16d+5NVxh6PNV2sJq0hRt
	 HAze4P+5OHWMX4Ojp70CVdfK9iIY+nUX0H/5ZDhKrfkAbNfopx92OhAVzj9sIeEAC+
	 iMJts6isaoOag==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/5] mm/damon/core: fix wrong end address assignment on walk_system_ram()
Date: Tue, 10 Mar 2026 22:29:22 -0700
Message-ID: <20260311052927.93921-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311052927.93921-1-sj@kernel.org>
References: <20260311052927.93921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DF9F1C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: nurd7c3mo5jf5gca99s376teypifbg5y
X-Rspam-User: 
X-HE-Tag: 1773206972-583103
X-HE-Meta: U2FsdGVkX1+d+7Y4kwYaBmT5E8SKOObT0ubpqagW8n2eaVUbrLiTjwltvecJx+eCTdtMmHWuTNf8DKSiI+qnkffQQLi/yFY27yU+G7ar8+ZzaB9W5UCL9R6NdEqun7PhDpX068YOspkLMbS5E96CmaEjXnx9ccg59p4CamqzEThz7PgMIc8WSPWmFN61tT+4HlnzarTSecxR3t0eWN5td5VHh/CTFn6IsBZn+Sh0nMQCdiZU6cgCEFE0aJbK9jMQdKhV6/VgBFUwG3zgz5ZTBcm1Qae9Rf+uiyNItri3QlK8H/7xO1KXKKYyVMiZ9bRqqVSCKDRiUEgJhPJhXC79m5kWGepqTjlViGnb7pnulPtTUXuXpfEB6yTnu+W3jeax6+xWq1JdBRt9haK3Nej1zcYbddr1rtbC3dfZwH8+FbsaeP3dkkWkaApVfMbH4h7KTw0uDNq+HyOibmnGb6HMxexcDB0YxpZgCFkN1x5dm/zUrGcolb+kJmYrejwfjBROJj5EjyGSwnR5s0et2yMDWKd7d+oR8zcoSaB5ZTJwzvZvt7sUKwaeijtmGNmBQ1+6F1bEWrZjAi6SOd6OseGy7ernCDGCFeF52IRZ34nTW+TvL3T8ZA1QTkKmGaTu0x+Q5ACBf4io0x2NGz/QWYHV3lBySZoehtHB82CPGP8eFRksDbgXKUH95nfBL9reLZwfexcdfSnUiyIwCldLYaEOyDn59PisrkCm+R3wxLy1uCHbPLJ4mZYD271CmS1IvvmOoCV++ygyCknuBXrUyWfOakAO/rUCw48PRzx/JlKLPLzid08dWSXEjUbMEt+hE4DqbO8f8iP972FzyufT4kTICEarB67fGfdeWms1bAOJH2cIQmG8GtFJwZYuusSlTyDuDIoYp6QA+oZBneM5mo0eDUqH2pFI1Kig/S9C2UapOoP7FMVhFaC3WVTSdBqMfkHJM77E29afcuxVBthTSt7
 VJ4srBTd
 trn3LUDEAboaEPuUWByV1rojURCEqO0X1BnhBTuQY7Zvq8WwX+z7FI9ngrlCXxV87XSGB+ieZ6BZbX2+GUDu8Xvf+BM0Kp4NRcSQwNfpbzYqjHNRQJRnroQC4LnM86zfWxNDXFeBXaVaWXU1JxT2Aj4Is/6UQNPGVsBuMe+FyShpAKA6H0DNFq6gCWf51gWgmet6TvDODEYD+wtJpIYOQ/VZFdWeJsAGfNvUKmvMXz25O0sr7T/nx77e8Itfvubo+ZYr+lXAPgbVgfnKKHr74pkao6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'struct damon_addr_range' and 'struct resource' represent different
types of address ranges.  'damon_addr_range' is for end-open ranges
([start, end)).  'resource' is for fully-closed ranges ([start, end]).
But walk_system_ram() is assigning resource->end to
damon_addr_range->end without the inclusiveness adjustment.  As a
result, the function returns an address range that is missing the last
one byte.

The function is being used to find and set the biggest system ram as the
default monitoring target for DAMON_RECLAIM and DAMON_LRU_SORT.  Missing
the last byte of the big range shouldn't be a real problem for the real
use cases.  That said, the loss is definitely an unintended behavior.
Do the correct adjustment.

Fixes: 43b0536cb471 ("mm/damon: introduce DAMON-based Reclamation (DAMON_RECLAIM)")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2e36024d99506..3925720a172a6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3060,7 +3060,7 @@ static int walk_system_ram(struct resource *res, void *arg)
 
 	if (a->end - a->start < resource_size(res)) {
 		a->start = res->start;
-		a->end = res->end;
+		a->end = res->end + 1;
 	}
 	return 0;
 }
-- 
2.47.3

