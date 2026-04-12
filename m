Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72DD3E937EF
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 16:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5EC6B009E; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6705D6B00A0; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44CA26B0099; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 141E66B0099
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 12:48:24 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D106CE402C
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:23 +0000 (UTC)
X-FDA: 84650486886.07.4C51042
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D065720003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 16:48:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vJLEa8i+;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776012502;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fzffUEqtILrf5+Nis4puoJEOa0aQGit1eaneNGZTvw=;
	b=5HeYUDHgMuno/++xc+KlwJsqWtBJxym/mfLs7V5S4YnaPE60mgMc0iBJ+VC+7ffn+JTrIN
	ASMht44kB1oSje8D6sRcp8zzY1XFxPS/i9VnsRpa4po7CQJfu9HzVThf/UN4O2X9TERhTv
	pGJTFhIaF5JQBWjz0TELKfKAgNJTlNA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vJLEa8i+;
	spf=pass (imf13.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776012502; a=rsa-sha256;
	cv=none;
	b=uhryiCve+0waPekEXwK2LUaUXOpt9holW99hVh5hTUdRzq+hdGgMj/zPZrHjeopn8AhvVP
	lmyGkjPiUOp8w+00ieIxFMqQf0eQM8UnQ5E02Wv1brvHU14n/ra4fSz7QDK4hc7qjMqm61
	XpyCOLExM4zXiv9jwq8DqPG1QpsV2FI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E40D445A5;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B169C2BCFB;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776012500;
	bh=DH43CHmYFrRpRdSTPsxFpCPHd33dckhbiin1ffPiNag=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=vJLEa8i+aX8QvIlehLGwxOg3T3CMhEFRRo4Co9voOpreBJQsfKcgwlbhKrQSZUDMx
	 uhaNG89qFCwoDcsMVU9aVQ3kgQYirSdzFPGUXwXfiRH0pWpk5RJ/FO8yvJ2iCh7sPs
	 kkKZrgM2NVPzqWBSzS4JeF/CxUEYQBAW+BSunhtTpbxuilrrKiIhhEgq9go3AUh3D1
	 wquV3yrI3X6+6iMDo1vT3+VpGl4oGE7CUVfpPQ23Z/tRPRYjkgXDLvdb9F/tgX/gWQ
	 wEUXl1KQSpYgp6d/eB8Mg6BUEvJZAJFSB/0/bIdPXA/YwqVl0XT/p5TrmtPcTrfQnd
	 HVQYP7J5/m4qg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03271E937F1;
	Sun, 12 Apr 2026 16:48:20 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 13 Apr 2026 00:48:20 +0800
Subject: [PATCH v5 06/14] mm/mglru: use a smaller batch for reclaim
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-mglru-reclaim-v5-6-8eaeacbddc44@tencent.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776012497; l=1039;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=cCINFuu/NooJEcPm2HlqwvibVWHBQhV3ICWUZupnUcY=;
 b=czGn94K9K1jdbOOkNLS5zct45nApfHrU6B0v59GrTBrrU4MfT0KsnQXq5eAQKD5I6PEbmH2s9
 k0ysFGD0Hs7CuvfJB1cjGcleNjQBgcv8FdK8u54pnz8ntAZZJzIzIHz
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: D065720003
X-Stat-Signature: cupsxne4umwhi63txn8x5j5gqhk1tjni
X-Rspamd-Server: rspam06
X-HE-Tag: 1776012501-236471
X-HE-Meta: U2FsdGVkX19vEge+78UhrQYCW0mA35aP/dQqGa+Cp3+SgQ9oYZVaGoNhLYGG4q0J1n2nMWF9f3T2+i8oVNnxkBAYdJ7XYBWiFlkFLTMga9L3Pb+ToY9NJiHf8Jz18IbeZZ+hr+443uuzcqeLXyCGb3UI4dEcG7bHYx1Be1zSXX+1/n9szJqJB+x2r5qAhoOjRqTP2wd/DKs9AD2Ft4/2p8wDfyDF+9pwibdvgoQD2kl2+YC5EqJrlGOvnzgCWGbkXCn7zSYTPKhtM9rYhTdRcD2k4BWh5KKM5FhYyYTUhZNR6l/Kql9hVwMT7OFmw0UBgv7xovIaYKLtKEtxWlf6hlD68Xgvr8CgW6Tz0ZIsxFTQBN3UK48AN8NE5lNpPA5rdKpzG4NErBZpO/D4CrMfRjJH21g4jZcsY6DGXjyGXWv8exHaqaKphIHWjwhWKd/dh4h8S9royyEjacxLO/pA5MSDc5hyhus0PmaLuWNkoWF4td0GfHOqx+Itbs2UohCbFdKhFKC4OyhumBy+kiwR1ok3ZduxaPTKhkf8Vjo2biwaT7CkFL6rMpRrPk9t2rFpNuB0SBEamndG0EUwa4QOl/qdPhq3zIZPA6h01k05/bcHDB4gZXIg2t9QLil3/2MJSrT+rXpkj6EJUvNZ6nZPTfXbugpPLtxW8b4H2+O/IMX0hSDBYEditbPyksBldqOuEmkYJW5DBzy2+D+umfRzq/mM0cDFJmIBkp87+x8tis+UU7pGlpDyXm+XduhJWuaCagZFWt0o2KlQsU5fylJoM1sYvOg+OqxBc2waSdwacjJst4zhST1UhT0MMx5VdIyNupDcZpsINR/bJOFtRoH2NUMGE7r+JL+UMFgSjUaAR5FIE7dvEthz0iRj+Hgn7nJUuwyV6hjD399MPoj+WZszmc36Neum9DhwKEyvCDxLhUAxyqK1Gdcn3neWiorqG4oeVj53zXyklsx3O8+RxjX
 5gKMaDHq
 OmxkazqUh+/SySZPZ7U7yjCpKcZCQsLa3vqpCD70ao6VuMJBOyo2q6IdMU9fxpsbmiDBJT/vSaniSgY7SsHGNbYuVgabyqvkFtkqCQAUQEJrILqsEMAjflYG2QiJ9uvbNnVZyrXysZ96WLKozL+ztJaRexZZw9zAkTNn1ZHHk/ZYjH1qU3oY00C8RDIKxatiWJPTTApeDowlFr0AtVftK785rArf9YGdN9+3cF0EnSeLUFyEJFKCW8HTlnDYt/T5IjL/QaUMu26MBrTNDEOtCWeaA+SMMi79mTNoUuFfaf2fasK1jYmZA4RcewqHIOhgn+KRvd9srT0nnxuknRpyYRoi3fzkGh5gf+NtQUMxJ3Nu7FC1mdW9wsGk06tSQgtP6FRA+pHFVvMEVQr5Yi6DRLQFUZDYBevOY0fE4sXLnUsEdsw2mldY8LBrJtdlJNmcaNrxuPmgRxVkTl0jYWYB5UAi+y73fHA0F9+k4lWLPSGIoURDUTZTjSBjXHxW2vtREPwVX8TcoP/cGD+i6t4AH1CAf1YHu5O6Dj7m9ZW+Vqsuq7Ez0vkBrkX1LH1piLFTj+DFv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

With a fixed number to reclaim calculated at the beginning, making each
following step smaller should reduce the lock contention and avoid
over-aggressive reclaim of folios, as it will abort earlier when the
number of folios to be reclaimed is reached.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e3b68b008376..cfb10052e350 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5008,7 +5008,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
 			break;
 		}
 
-		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
+		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
 		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
 		if (!delta)
 			break;

-- 
2.53.0



