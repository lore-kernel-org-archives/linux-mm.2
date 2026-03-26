Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C33C210AB803
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 18:56:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC6D6B0088; Thu, 26 Mar 2026 14:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D966B0089; Thu, 26 Mar 2026 14:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5356B008A; Thu, 26 Mar 2026 14:56:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DBC966B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 14:56:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FEAB1A053B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:56:41 +0000 (UTC)
X-FDA: 84589120602.25.D8A3D40
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id F132714000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:56:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IVZY7kwE;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774551400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=A0QGewojSw+aC1mVCllr7Z7HYxgWOQ3GJRv0xARyP2U=;
	b=hy1h27CkU5UmT4/sUa3XwTftWXrR5ysQQbMzwwkSd6NUF9ybF8vjgSLCEWQR3meHI22VfS
	G7Dk91vi1HMlbsXLw1NDAGVoLg8DpaHFTwgGXtGCtdP4iarUOrnCf1yEnqnoO1YzGwRyCZ
	6ezeB9STW813JbvAmrqaMh/tzQ23RbA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IVZY7kwE;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774551400; a=rsa-sha256;
	cv=none;
	b=4zc4xxTvbSWpu8zpfc4A1YWEsvQxDLLL6bqI8d6J+AymPKb7ZIgx4eh2SH3svdvM4OOO4c
	qvl02c1fIj/xEH8SBQEJT6m76uExSS+eJYq0HuyTWtVYuUtgZsfZ7aSe3nIPw5PFFE0UvY
	h9Cm6SOr/hiy0HFUjYeMWp6EGUyXZgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4715D60123;
	Thu, 26 Mar 2026 18:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBCAC116C6;
	Thu, 26 Mar 2026 18:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774551399;
	bh=+wQetKlGm/3IURdx1cczlVLWXCfYEZfNp6dSTf9FThw=;
	h=From:To:Cc:Subject:Date:From;
	b=IVZY7kwEb/MKgY6r01wlXb2O6ynTj0T2ANigW9dTrCedhkDuQOsQ4cOwR+wcfMqQS
	 6GgKaM7G0Zwj6vPvYcKLRpgWiYqHp3QSyh+WbFuvFSdoVNOmdpU4ZjNGfslM/fSOBX
	 yQt9aMTrQdyMOzVoNDpIarosqzKNa7NB/XwpzoogWsJhQZaaI5JbnElMPoG93NeDqN
	 0iyQmAoMhHWhvXI9G+Q/7a4nwGV/ZsO6UL1aDRMWnToEaSkFMM4JM7EVTmbykj1ZNt
	 gMxEADcShR9EDMs9uUpBqIXODCh3pBamLBaQjZ94M1nZjdDohWhCb2O5l86sa2EXCW
	 g2cWw9sHzA6mA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: update MGLRU entry to reflect current status
Date: Thu, 26 Mar 2026 18:56:29 +0000
Message-ID: <20260326185629.355476-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F132714000F
X-Stat-Signature: 1ftfkqn6kxegm8373zbgmp1ajtktnnma
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774551399-705600
X-HE-Meta: U2FsdGVkX1/AE3Gq+KtX4/1b/rpGaBGMrXZq/9Gp/8B2Xp+uJ0Kc9gHi9WXrdrGBBk5WcBcTPyyPgdNGrIWuHMfeoKmsBz4knaEF9YUcZ/r8qVHMG4YehATz3ftWCrEXIYNmjEvWw0+un2HWq8ZOVSuB7Ae8pxph4L0EgOT/cAszS8N4k9bHsYqLnl1KWQ720xaNLh4yRzIRd779FqtorDPFhdAH1YPwHkjj9a3gW1D17tRJJUg1XmdX7zB67MqfF879YbBnSZNXA6JpGQ2/WeK6jSCEKZpKPxm1zmPmI9HDph44HbgKDV9nEBYsljaJOuPly2Ga4jjVBwJKpXqQV8k/Ic4SbochQdnLlY/QrIpWv2GxhaAb4tWMv1CwAg6ZEQK6t74oZMjeAXf3t+UYoA6C3Q9O/bv3mqLExVRkjWPNI6ITS9Gq4FBzQQ1bW5ifQmP6SYkiYbZodexZbgG7qSkRK65cq1JD9o5oGEXnbcvtGrldr50FY3hPKN66HmeNWYNo2xg9ec8m6fOeWvuyxp66d/RpoIjC51oFTqsK9f5V+sfR70GDgwNRYA0g8zoKXomVsK7Fg0kgKoc+xockaOSg7l5m2x0oid7HaO6VW1NTr15wZ51M0qmr9nvzwzkDhiDQI57CrPmPSK73m7BM4KjRb762l4QlGp4R541b/Tpvl9Z+P0eOR9TwZpvHDV8STVpWA+7/iPCevQ0k2KQZ3R6rv6nSqR5jn8EZjT+X0ESN58qr1XZBhpm/1Bya6m3+i3XURGTm5vIlwHu1uoY3CEBufNgK5EiaQzvwrlQGeQ9uUVUmJz9sPeDJC3d8P1HHZKFRjYu5Asx1SOKIIyWqQXTcL9VgQxjr46ql187497O7m/Unh+EraGW7soHTy/Lqu6+9egUvOre3ZTbR+WBKzFIECk3dtQzNV+1ay4u1NGJyOhoxW5+ErRog/XYgJwsLPmctD/ipzP5dO2DA5um
 4MB7axL4
 axFfelGc8aAxXAGqZRJuozmHH2IkKCJ25p/Abnp4xiUbcS6aoUzSEppfcx+5faZEdhljovF6jNVYn+wBShpi5zhjpc3pGqwZPIFtRPO2O7G+zl6S5Z661QUTPNzXkBkxUP8nuztYdd50QaFsupYrfy//LxmeE42UFdQmtppiGxQqM0qiiEgbQlX0OrHM1hHSHLKnhI+W6/xDB2inT+3IVtJvfmrVIQj76iILvucr5yxZYTomcSdJN4Q0vbxQfPwMhsr7fJ7iksCMbLt0GCZ9rWg/rUOCU9+SbsdgBr/YOnCW9Y9KqnCdxpdzlZXCMfL0UXjRa/rhCdiWNBlnzEKtt02gcsQ+fSjYY58By6Q+VFyx0ruYiVADRVbvfTW40l2aOoedk8f0TxfNjLnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are moving to a far more proactive model of maintainership within mm and
thus put a great deal of emphasis on sub-maintainers being active within
the community both in terms of code contributions and review.

The MGLRU has not had much activity since being added to the kernel and the
current maintainers who kindly stepped up have unfortunately not been able
to contribute a great deal to it for over a year, nor engage all that
heavily in review.

As a result, and within no negative connotations implied whatsoever, it
seems appropriate to downgrade the current maintainers to reviewers.

At this time nobody is quite exercising the maintainer role in this area of
the kernel, but there is encouraging activity from a number of people who
are trusted elsewhere in the kernel, and who have contributed relevant work
or review.

Therefore add further reviewers, and at this stage - to reflect the reality
on the ground - we will not have any sub-maintainers listed at all.

Each of the files listed are shared with other sections in MAINTAINERS, so
this doesn't reduce sub-maintainer coverage.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
(Apologies sent first version of this without MLs attached :)

 MAINTAINERS | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 76431aa5efbe..16874c32e288 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16757,8 +16757,12 @@ F:	mm/migrate_device.c

 MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
 M:	Andrew Morton <akpm@linux-foundation.org>
-M:	Axel Rasmussen <axelrasmussen@google.com>
-M:	Yuanchu Xie <yuanchu@google.com>
+R:	Kairui Song <kasong@tencent.com>
+R:	Qi Zheng <qi.zheng@linux.dev>
+R:	Shakeel Butt <shakeel.butt@linux.dev>
+R:	Barry Song <baohua@kernel.org>
+R:	Axel Rasmussen <axelrasmussen@google.com>
+R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
--
2.53.0

