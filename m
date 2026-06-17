Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D9ACD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 16:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED03D6B0088; Wed, 17 Jun 2026 12:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7046B008C; Wed, 17 Jun 2026 12:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98086B0092; Wed, 17 Jun 2026 12:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE21F6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:39:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36032A04C6
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:39:36 +0000 (UTC)
X-FDA: 84889965552.25.34C40C0
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 777BF20002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:39:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rJwCIhNd;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781714374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RzwjJirdKF9aL8pyYUOcGplzpLd9E6wSMPKnUXgb9XE=;
	b=y8tfZopFqpznQm614OhMbOuTAVhi/v8vgzkcXw+xwldV70s3zHLK4NyCqkBHuresIkf5c/
	1wgSqcbs6PgEGhqvxJuc8DhqrKwR/1+VvqCmEs1qSU8gqVpwTAcZJpe062/iktEf4DJQjy
	3nXmje1odRyocRDvOBN0atYsd00nFhE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781714374;
	b=KPvqwBskINGZMmkRVp4dx8yaVPb3aVbhbaMqyjNj+LnNZPBjiKtxDvp52je0byg/pZIC+X
	W5ey2w4aVHvAA6pqJpvUKz88yu0533b3JsFmufNq8v49jkvl5YJnqp3u11eKvSund0kAe9
	LjjA4cZFuqopFNz8HcmOkkLLq7lM80k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rJwCIhNd;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36dd65b95f2so886815a91.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781714373; x=1782319173; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RzwjJirdKF9aL8pyYUOcGplzpLd9E6wSMPKnUXgb9XE=;
        b=rJwCIhNdIpnuCAa0QLuOgnmOr+mw9SnGwdkZovVjli7pMOy4CFi2I23/HPCq0rqhWf
         gxBNHMvhXgUIgutBS6ZYq6HXeo5sQng9PC1oDoGBFUN7WokIEK8ao4Mt8f+GwgJVtjCA
         pdA2NCXrDrlcj2Bpljrel9Rq6x4wE5ceds/oB3PIIZvaEfeFv3ozWokPle2sXrTFoOl2
         UyWb4iRGoyd/dF8YIP57qiZOg0cC0W0jZVyMGCubgtm4ehU197xqIDbDysIixpuMP7nO
         JlBFR7mByfcjMb5T9c0nsIEDE+SiXrgV9XMgZ+BQFEuj06UNZnPP5t1HRcT0ojKkUhYG
         t/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781714373; x=1782319173;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzwjJirdKF9aL8pyYUOcGplzpLd9E6wSMPKnUXgb9XE=;
        b=ffi1dENf7g/ef/GAxEafL0jM0WIYgqnUjMpglrEXKk5/90TOvjrREaiP3nJ3GAj2h3
         5wvP79qCmed7UlZJS/+ywz0Z8oq6wVUUS94K+2WSaVlF2IwRGHNuJmy7otnPx/2+MtO2
         PMaxzLPM+1bg2PheRXYRl0EM0rFAbWhPP7lgs3x7d3sRe4geIBtwH+wPZ5P0KGpbd5uO
         XQuVHEtrL2gopOXab/5uvTw7it+ENDNmA+Af8hhjdX9DCLOwRL3AIqPawQ6gWdtoPq2/
         7tdJMpGUwe3hej8zYEtJ7WxpcSm9mhuLHdiUQJbeK8gPpKkWLTTs16QD69mdd46yDhrM
         56Jg==
X-Gm-Message-State: AOJu0YwWFY4q9HB3KGtl3mFkO1nOxZcAVJhSwJZuyC7iP8QRgpu1ubIv
	uRpNe+raItgzU1iBxGJ9Cp4rfqdYUoMOe/LccNtZ1IQhBHwZvnI206bi
X-Gm-Gg: AfdE7cmm8aqb4hPtKd5aJUFH2E7i7yooCYr4fTzWl88mbkjm1GZKALndz/f6PwtoD8n
	fVl5nspRCsCBQxLPDihQGiJmc0HQ+qCiRk2YaH9vUmkyfHQ+IQYDInkS023bAh0XlJJ0U5mtmDG
	QcL2C0W+M/T+iz7pBFGUIO+fzcnsG4OGke4XVk6fWUw42cZC7YQ1+KQEgG1i8folzXMkHklxKJJ
	m+kdFiFhTAAGHSHOOycn2K67dHaB49UI3YP4RzLCiwfuSWBWYz+4J0Z4HvV6oeDVWUi4A+xOinG
	PwfdxWNA3iwTD2JJana8H46N5DtYnDuA7EovU88/Hx+ll+BBITuWF9eFPY1r5zf3aiJpKU8eHuf
	99Q128egOPGhHWnIaYk/cABRB/YKmOmfMOtZAqQRtVcTZmf+ULUZQg12zFbrusyuJ+2sjxNOfc1
	rlqyGhwtE7FWor6VwDVA==
X-Received: by 2002:a17:90b:2dd2:b0:36b:a162:a1be with SMTP id 98e67ed59e1d1-37cdbcf285bmr183369a91.4.1781714373182;
        Wed, 17 Jun 2026 09:39:33 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37cccdf0923sm734949a91.1.2026.06.17.09.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 09:39:32 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arch_numa: remove redundant nodemask clears in numa_init()
Date: Thu, 18 Jun 2026 01:39:19 +0900
Message-ID: <20260617163919.2544899-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 777BF20002
X-Rspam-User: 
X-Stat-Signature: 6mrqm5tzhm5ymfcd7mbryuib4jxa3xxq
X-Rspamd-Server: rspam08
X-HE-Tag: 1781714374-116160
X-HE-Meta: U2FsdGVkX1/lg4uAs1058tprP816lVgAkIsKG2yNIx7wNah9EnqIuTNDfsga++COgzi934f8czeFYuYEj+/19VetnZyA5+GuSWlxwqV/tPMW/q4WiwjXrZJAhQhXjOHFcQeUjurKj2P9SLj0kCzVo4kT0rEhDPG14L2gOJD47VHgum9W11acFQ28/Cz6wH0bo/u3vqTuERp7+H18VYhniCWJxty/ffQU9TLB1va6GZQ4nQRd1XAXAnY7Da6hdCasP9aS4GHzXA5kEdtK6UKeJ2Vw1x7dqiDlev7l6Xw6LagVqn2oAw8hJ+Llxdk7AAyvRINWKJqDk4DWVto093F1xvkqm9Jbt9GRJx70vDuOxtvlWqgVF5iQ6CdZ1QtvH9S+WCTxP4GoRx2hdALgMhNcjhqt9yHImZgZp7U0pHnzq77/EnsR0xIySJxOG6K8qd1HMVowCbqyyT6xAGKslB1G1nK5cdaXT0CsiYql+WM/KtJjIzURz7RhzMqbUXe+M3i4hw5CG5wxYwdhXejKxZ3KwRWIggC1Xdb06LXLWyiOZA1GY0L7GP/LUCfGwlJnUi/Cdtd2mE+/0y+fmCGXiyrGqxQ4q2iPTUirvPwnez/SA1TkNx+AoCAhM5JZ5tmG74Qql8F80bBxBu54bGkQ6g8mEHdEJiv1KH+ODH7tOsyq/itGa2wJpjgJIIG5P5PQOkMgn1CroaCu8+VuO4HMRLOP100POTKBUHjlkSWEkF+VjssRO5IPvZtqt304FyBYoVrFI9rtIolvNJRxsAsFJhgr1Ibnln8fchMtrtO/9GJcTnv6meaB+Bmx31NJIV6OWdS+P/viVtxOYBheSiFEEpH3KRgbzbwAJdRVBLcCOK7KiVZT+Q8JawmJGMRMM8sV2kFrCbYiSVi6Gc9p2XXjLEOZPB/Ehkdiyd7iKZwIqP1V9aqpT5zOq9gCjPb9FvFK64FVEnpR6m1PlL2zIiWtOY8
 X+nftJ26
 SSlv+r83TGbSu6X0Cu1ub+A430Ef2N/tKr+iJajUPBdgjvM9pX8NlRhcBkBv+gZi8zoXrUtTiRrI0TgxsFzU45K/uYK6kgxUSBGuGGViq8Al+9ilMr4vM/FQoR3ZwG5YWipLWXA5o16a91D3YTKN1oLJ/9n3o7g+Uf6ul3JWpaniUam5cwR2BvjGOt89vcWI9K7XpvF6C/A9Ym0Y2Xvv703NruiIWJFdkZP/Hiz4mIgCozAgkwB2ncmG7+OlMmtCsEwqZWl8bBT1SIdQHZhJbuZgUNL7BNUO4EtljJZ7oSJrAqrUtc/n8EGKjQugpAI+xhKmb5bjXgX290pH0BeiMm5FGOus0sBvYFNuF15L/553ckg4KpP3dhmQM2ihuHhdvcSsHAXh+lAHSRlMZxFStgAyFbQmiqOVuxgRTYymcEEMRfqMT0hPKEKSukSNyUpCYXDqGAg7O4K/00bhaaG6ZQ/Hu5V+7ce7Aglw3Rx5f0OMjg1cjaA9MUYhZiqp08EOABfshUk0HiAm3wI9UqGXv7Qm9LpcC4z2gy0Fk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_init() clears numa_nodes_parsed, node_possible_map and
node_online_map, then calls numa_memblks_init(), which clears the same
nodemasks. Nothing uses them in between.

These clears have been redundant since commit 767507654c22 ("arch_numa:
switch over to numa_memblks") made numa_init() use numa_memblks_init().

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 drivers/base/arch_numa.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/base/arch_numa.c b/drivers/base/arch_numa.c
index c99f2ab105e5..442ea239bba7 100644
--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -231,10 +231,6 @@ static int __init numa_init(int (*init_func)(void))
 {
 	int ret;
 
-	nodes_clear(numa_nodes_parsed);
-	nodes_clear(node_possible_map);
-	nodes_clear(node_online_map);
-
 	ret = numa_memblks_init(init_func, /* memblock_force_top_down */ false);
 	if (ret < 0)
 		goto out_free_distance;
-- 
2.43.0


