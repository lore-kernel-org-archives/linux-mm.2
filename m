Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B19410987AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:35:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41F956B00AA; Fri, 20 Mar 2026 12:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CFF06B00BC; Fri, 20 Mar 2026 12:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BEB16B00BD; Fri, 20 Mar 2026 12:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1622E6B00AA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:35:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B2CDAB7A54
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:35:12 +0000 (UTC)
X-FDA: 84566991264.25.3BDC11A
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id B273214000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:35:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=nu4X1zZT;
	spf=pass (imf26.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HdwGly0+BqBUHkF/IVpHh4nGFQLNRDEsFnAVEweW3Yw=;
	b=o9Ibe2OpIJZRtpx0savsmz6NDVD86VFWMfxaq8rjX7h38je9xWjR5wbVxGawTybxXbgIZM
	ZFBV9TOPV+gAPanMCi8vcCOfLsEnFfYVLy3jew14+w//6xsKsGvggZADhJD0sIgGXH/K0k
	sQM6KIBMuKQcSaMUXQu/GBDNLiYC40w=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=nu4X1zZT;
	spf=pass (imf26.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774024511; a=rsa-sha256;
	cv=pass;
	b=HusD94IOxomTiAWm3EGp8/HBrwy5V4APWgsD+GtJNA1mfX1U4aXY2r5TorguUeSOC5SW/y
	oIiuNy0BYRNCdaQghb+LS9rdcaixk2xlA5Qi2jXeI/76lPxwF1rFBroufZbzWO+tsmSDyq
	3f4eG0/Z8b/PpvR29ilCM63c4WgIOyM=
ARC-Seal: i=1; a=rsa-sha256; t=1774024499; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=kL6TU9SxXmYW0Zx/+kJIt50C7x7C6YJ7xEUjn0GG5n4am89gtGvS20RM8baJngnMB3WLNtnXp7nx8CLFgsymyYdVtDLjBpoEj5SP1DELvHi8kgTSe0wBpNB2bZKaIt5DgIigOrkEqfXE0d2ZH5VyqIPTVYOhnnzYJsrAbRkkeBc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774024499; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HdwGly0+BqBUHkF/IVpHh4nGFQLNRDEsFnAVEweW3Yw=; 
	b=TPcN1HWQ4epDGEcV3r9qKeumPHdQc8aQDqXLiWI6VdaTMIki2UhlHejhxzlATnVhntrG5D0B6ZJ7lkYRM9bHjxN/Sjzy09oSB69sF/8Dg8/HjHDH5qHHcwnwserD8Zud22pPE5LM15LKHp+1V3OdDXCB2jz44nTwWcNi0hC3PME=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774024499;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=HdwGly0+BqBUHkF/IVpHh4nGFQLNRDEsFnAVEweW3Yw=;
	b=nu4X1zZTA9hBK5Ld6MOv5wyDoT6VFY1Ca5zfBveSnqaAz3PidQoayHblWpazYaAZ
	VSgmId83ABif1FBfTXgCLLuWdvBbI/6+BSgfCwhel77epINNP8tspt6q+KpO3LurHRH
	EqTVCT47MbvMtjgx2RCWgVRVUGWN+aee6Aj1KOzE=
Received: by mx.zoho.eu with SMTPS id 1774024497826601.5397544812834;
	Fri, 20 Mar 2026 17:34:57 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Fri, 20 Mar 2026 16:34:54 +0000
Message-Id: <20260320163456.177750-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: B273214000A
X-Stat-Signature: xudfjen6ahrjiiyy8q45a8aqgd73w5u3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774024510-186089
X-HE-Meta: U2FsdGVkX1+GZgzJ9JD6InFRYZu6mlPEvOy7JE+f8Hwv66O9CDNMpClRQ3NpBDnEjnlJBifwWmV3mouHgea5RebWCaZkuajBg+Nci4uaGQRNLhN6pXIzdrSakTOelh1rUcbO087/u8mSyuc3R68Z4/fbQAkR0RpH85ISOCzuWVHDlw8K/7pyUNCdZIwAz9FIOxWIXBYHLLDd/8o034g/7pWWCZm19zmPdZXxm3oi4HDLLUKETbFlWGMwMvrCDjdHgcZigrAk5P01K0Znm6X6+fj0kPs81sCWEg6yB6eATWV0CJmB/tHwGvPjw4hfOxghHohSUn3MDeaOJjvtlbN9gZ3DMOhGqegg6HCEsXMD1oyFMtidx2LbMTFzZK4xYGrW5shRXkgVTISl1/Y1JUEbbnbM5bgaPg7zRtjmwedCR+4aSa4YTgCUKWWuue/CgvT0gzbDLX1dcFkbDgNvHl/gsqu475tMqPRsczWOjxtf6lw5LL/ANz+SW3PcCJ1wa8a8FcxUhHyheYo/olJIZJxZsQYzzZ/RltOwe4F1P2WFuUF/Dx9yxflKnEEkbaUgS+PyV6VSDtzY5h8I6LVp2E5j9xXesTqWbsGnpgiAI8KZBhyLypKxuZI/uHstgQ5WmGbYMj6Q698jo17DNaLcUKR2j+rros2vWWD4iQRKjCHtTtuNXGSnZytZUheOgNtR3Gt/mzCUXfb5C/dXVAVxjeusw4/r2NdwO4SBftycCHNa2YT/txVBVgurcbd/5t7jcAyge26rRLlRL0TU0qfADp9G2WDTTskbaRZRJ1zR8m5QiAQoD2VBsG7+rEH770caFSurfHD5Gf61zK9ouvA3kklSI3rEV1miEnMa3D+b0rn8XKzx7Q1940j3SPfiPatrpTWZn5pUBe/jUnnBfz2+OiWa7GGprcIDZezpAR9rSRJYklWCLPWmpg/1qTF4l/z3SMzrSSSbGbv5SP/iTXz34Sb
 7jE6NhR9
 EX+4WwPn7SZNrdsNrgx4m+RtnpzUAfjdCf/qTMzEahSCHC2v6i5zjrUeI9BFlcFBf1ON7MOEmG+qTYXpDc+QHotkvmeo+zCU/AJRK3ZeD897LEXrLOu4iPa2f01wE40RlSo0n+t5jcdw4g8Lv5J1N6ny7gz4hLBq27Cc6quXEymxjvKgR54GgBYr2rUXWZFB8BcsRcoyXDLd5lC/H1s14b+N4sQ7EQEZ92W1La6rKR97DjOG4Q6sW1huyksq5tRSPXjxcIl5af5MXRNcpdtXfSdiciyV3VrTNDDu+qS8TiG6aWLo645zNevsYIpIT2WR/1LqlSDYKqH+/nXpdWy17/34Xz2k29efUpfSm8tc+6GVBf3gfF2oW0nAHfzbqcy1+hLwxl4Iy8wuWvwsh3XyLmylLjOklDHrYiviyOc5B52fclTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
param_ctx is leaked because the early return skips the cleanup at the
out label. Destroy param_ctx before returning.

Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 576d1ddd736b..b573b9d60784 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1524,8 +1524,10 @@ static int damon_sysfs_commit_input(void *data)
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx)
+	if (!test_ctx) {
+		damon_destroy_ctx(param_ctx);
 		return -ENOMEM;
+	}
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err)
 		goto out;
-- 
2.34.1


