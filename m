Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDC9CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 07:32:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08EE88E000A; Thu, 25 Sep 2025 03:32:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017B68E0001; Thu, 25 Sep 2025 03:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E489B8E000A; Thu, 25 Sep 2025 03:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4E288E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:32:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 58913584B2
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:32:39 +0000 (UTC)
X-FDA: 83926955238.20.2BBD414
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf10.hostedemail.com (Postfix) with ESMTP id A3057C0002
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:32:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dfsl524z;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758785557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9IKn1FbYkXB/xz9fK/2Kq+b1V04wQVNgo/lxGPqv2I=;
	b=2lSa1XpgouBsYFV0oiS3P1dkFelHAGVVcJFKO9+u+qX7qGWx0uP7ImqXf21RKWbHUxDla6
	p1dlvGylyQkhJE+kKbQObkke3oyiz/Qkpljp8jSi0kOOiY/nmWJbHeYlChAq1D70dquo2G
	RhOHguosVmeya5WM9yTaZ7MqSONKQeE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dfsl524z;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758785557; a=rsa-sha256;
	cv=none;
	b=Xt+855qbKHer0EVSS57gc6V5PlkT5MzZszFHZ5/vezqJDX93MxJo5jNmjxh3iH7rP+a9JU
	Z8oviQ6ZPK759U7iKau473zTVVlfRIai7bAvq0Qprw2ELfXknO0PnCjEwKKrzYsEta0WPR
	LoXWalpkILuQget5Cc288jB21ALuJ44=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758785552; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=A9IKn1FbYkXB/xz9fK/2Kq+b1V04wQVNgo/lxGPqv2I=;
	b=dfsl524z/Hqw2Ajn6fMlPeTcJ/cozgOoAt8yyzThOy0yI8eHW0HtuAXC0xcwSQKbu19yu+/A/kNhW7UuCb36jHceIW0xsDcXylXUq42oBxunhUJT3+SctR8CL7vq6B9AqanNvi1kJMJm8WyfY/KUPmVcxqxm8Pbu8HPOtkOJz/4=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Womw6o6_1758785551 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 25 Sep 2025 15:32:32 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm: vmscan: filter out the dirty file folios for node_reclaim()
Date: Thu, 25 Sep 2025 15:32:11 +0800
Message-ID: <d3560ced59af0b32b5eeae53c0b9569ebd3170db.1758785194.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1758785194.git.baolin.wang@linux.alibaba.com>
References: <cover.1758785194.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A3057C0002
X-Stat-Signature: 4onx83xath937k3et15g8tz8oo3w3u6n
X-HE-Tag: 1758785556-399123
X-HE-Meta: U2FsdGVkX183XD96a3sN/moUn6VkLPLDHzubXIsLjOUjfHC13f2rs1Fvc626cgPeMJ0iCGTqAGj6e/Huiqu1Zl1dIQ6xCKb/KW6RFSzda3jG6hVIe0QGKgT83WPffgIYaoeVMXJiu3rRBe6GLJsWAps5nLUjEcYCj3L62ro2bbMakeH+YPrCW3KnqitvCdMO9nWood6RUaKJAWoFk4bbXwgbokpFYpelY2FjSFdwmnPx6ZLozFRPX/BtVfwDuNMqCthuwYWJgZ4e39dHs16kKSK7+DnR28w69YckPc9KS03qLvuUqSFSEHcvKue20k3DqnRaXFtvttJIgJBbWnctQAf+c1ZHSixDmWLdgGFbOqwZSvd8/9oZujVzn6v2NnHOI71OKb2v3Q4KvwozSeaBXVd8RsJxCRYu1eXFm7LYibQQSx9RqIUG1BlLzxSX23VJuufHRRMRcrAG/NbWZgtkz3E/Z+HL2UIl4WnqylHzXlYfdAjx7/LesFDwt75ml9XMuFqP9/CG/09nGz2z/KzUVhbHaeKPjzUHBPASlbbSOQySqR0eCXxKAs3HbKkIQRFnI0O09niX5caV3Ib+UDRjopGGgR/+dKK+0kVYSyim6wYJyfcj79O9P+3hCtF607AuDLYZEtZ6ebMIAPT9HRL2kaIWs03NRYkR0PRyBiSVRE+kRLk0oOejUkpL8yC3KZ5XIeAiLaUdv9hjKnHWByFuskwwGxPkc9DuvPwkwE0Lfh3cAKoHql3LzDBsDpbeBhlIQFefuhhZQ+WIdpsYAxK+qvFzl/aqNqmTbJZ4Vwzk+IOV9ISkWXpi0+uo7lvyc9qo1hRl46up4X0UD+cbQSv5MQalks1/Fpue2UYLOgccklkvEQVQxdXsU1CPutSYvqbUjiNf5q1raFcpF5T9rwhKsiINCokZrqvHRSasmZYuuOcWgdBqixrgcK2A8k+ZP2XVmD7yHYBCvpvU9o9dttm
 1UbWgKRJ
 VnWcimpz2Jz/jr+zf5EQhAgOTT+JF1Lge3zyrnxznoJit01f/F7X8nWoju9xkwNz6MYKUKVLn1p3YJAS5Ro2EtTmlEA4crVIcwDJlfkXo9Ja6TC0PAntr7ACVc1p5vu+sqotwO0OgHQpc4ldd0kaBdL44NWc5Xkb9g93ndNOtp+SmnrbhcdzywzbNZXnAg1uVOyYkxS4esRRM24T+ih/qaJdRFHl2tMqCxGmcnjseTxnGbo8tuWbq0ycC4y91O6vnbMNsp1X0rfcKGu/N4TKERYCUdf2EQF4KGxbAljowdAv4Jso=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no longer
attempt to write back filesystem folios in pageout(), and only tmpfs/shmem
folios and anonymous swapcache folios can be written back. Therefore,
we should also filter out the dirty filesystem folios for node_reclaim()
to avoid unnecessary LRU scans.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/vmscan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index aadbee50a851..f347865edc70 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7601,9 +7601,11 @@ static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
 	else
 		nr_pagecache_reclaimable = node_unmapped_file_pages(pgdat);
 
-	/* If we can't clean pages, remove dirty pages from consideration */
-	if (!(node_reclaim_mode & RECLAIM_WRITE))
-		delta += node_page_state(pgdat, NR_FILE_DIRTY);
+	/*
+	 * Since we can't clean folios through reclaim, remove dirty file
+	 * folios from consideration.
+	 */
+	delta += node_page_state(pgdat, NR_FILE_DIRTY);
 
 	/* Watch for any possible underflows due to delta */
 	if (unlikely(delta > nr_pagecache_reclaimable))
-- 
2.43.7


