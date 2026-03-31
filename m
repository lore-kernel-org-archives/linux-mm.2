Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675AFFF60FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC87E6B00A5; Tue, 31 Mar 2026 06:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79756B00A7; Tue, 31 Mar 2026 06:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F146B00A8; Tue, 31 Mar 2026 06:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A84E26B00A5
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:16:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50F14140C89
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:16:49 +0000 (UTC)
X-FDA: 84605954538.11.CA444C6
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id A900A40011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:16:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E9ZaGMxs;
	spf=pass (imf27.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774952207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rT8LZjKw1WlLbKamhMIT2ihOgjShZoBPzAgEywAby0E=;
	b=Q3w1FPTqEO1uPwT7mjh5NwRRLVjD1L/4oN5JGhl/aGQFCR9O44VAkHDBLhnbq7FUKY5RLZ
	Dxfe+MSTvipowY1C8Wxq0DzcR//LQ9KssoxFXJCPpB0i7KefLx1H2itoVqv30GdojA7Kqh
	0clM41qzfmJHuqboaKdQiYogsBRWCc4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E9ZaGMxs;
	spf=pass (imf27.hostedemail.com: domain of liu.yun@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=liu.yun@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774952207; a=rsa-sha256;
	cv=none;
	b=p7dyyo2WZrEB1QIDTnsJFZEvqFYxbTwNM3n7nm9Cx001gA9JmuoIwmchNqJtkpC8Gvyjom
	QhnNLQT4bxUFdV91Dfyh1QxAhwxWjvrCItyR+KzhdqjYcEANVtYg0rxoXZxUAXrH4MYG6Q
	VrDOCoAR8nBCuEldKhoxsBsFwh6wV8k=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774952206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rT8LZjKw1WlLbKamhMIT2ihOgjShZoBPzAgEywAby0E=;
	b=E9ZaGMxsk5ZSeEzCJcAjKxNwly6MDE8ag6MKYVFEyr5jtbHaMnTsG0n8PCbIWCPFgX6vyz
	n2H2dibnFzYo6m1QdiQ2Vmu3sZEPhu/gTkwqN8+BWLvtVrJLq55N56ZTJcRMcRumRrw62E
	Wt7XDa5dkae56hxnJk51sEMq7M5RdIU=
From: Jackie Liu <liu.yun@linux.dev>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/stat: fix memory leak on damon_start() failure in damon_stat_start()
Date: Tue, 31 Mar 2026 18:15:53 +0800
Message-ID: <20260331101553.88422-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 7zwdu7q8jkkmwb7qgeyuhujkirhx1q34
X-Rspamd-Queue-Id: A900A40011
X-Rspamd-Server: rspam09
X-HE-Tag: 1774952207-987765
X-HE-Meta: U2FsdGVkX1/nXO3BRFWlBbaEiC+ya2i0KI3Vbo1yzgklLviTPG7Ma9SNHne3JScaDMR77VUStJFVzw1uk/QvU10vse+eWobhDWQ0/JlPSgBtWNm18Mi1cCtSrfcNox8516aRRJIpq2CTIdVO2YohBZAxTSONvN/K9lLaYMcKTUUHrKg6112BViM+v++20eVrytxzAMCawYUaP3Xz8y9ESFYB1MwvX/xbsgCRDEMw9FpcAmAeT/vRBwlKXkJkMi/tgslCXK5TkEjWaq+lTP16d87zFESLZU5hlbbQpWtnaYxuCRFoShn0VE1pmQXI5o66E7qlu1j6N1MGUhzaIkJGTGTuGRvNwkUMQJ+aj9E5URZD7yb/8Cl5nLxi933XD2lR6ro/GEj21AryAG2sp7pC9yfzfpsyzDk3m7xxwpi1p3JYaFK8NwZOszgK87zGB9MlAtnqkhwSJncOAc5ODBBxaiZsCIFGguf2uoildLKUbgDtxPenOG1xQXwRdcuFyt9nI5xZWoVxpHMCUVjJbKBvoxZtpGq4BLg5Bj+4aRwnWounPPySg44lOYNt/PeVoNYZiLAOoZdUzSt+2uHarIL7fO8RU9mfhcsi/gz+jg/1KklbGT3PYbFY7W9cSssEndSO9UpcnaDynLrox2Sl9TGMoFOY1UQmxuRubmLhnzYgcTYBO+7z13qwg3hzrkrGcHuQDeEL/oQ2uSNzpNumhkvSZIGEJGfOWristSROq6lWeAtKQIvtWY8NK9mXmiOgv2KvqlKhVs+rG/zz9bfLtk9UwSM/PdXLQNuqh0eJWEVmhCCPxoQLVeDsSNVORaqsItVsnoT9a0lIyFE8XiPhIquRdfJg39RA+08z4Hm4vUhlqbxfrS1ojVVISs6OlbfysBl1fEm84F3kZVI9KdIQP6Q2DWpsQGBASWb5+pz+dKJCoHbc0uyFq8ZTpysoh6Ento8DGbT9KUyCM5RktJZgsBI
 IacGBnJs
 AO6gzGpNCzI+St4aa79JbvyXU9W52e2HpuJFKzF4OYRx3oiDvXUThyekTZW/zrrzIStdT21VuX/6VTFiEnUj1hoDEv1Jv0XH6K8LokSB1QPymjhEDOMO8vncHHCjDWN5YJM5nIfRm0Y/ltgnGmKmwdEdkiJRvHs9VJwphS9jMSXNbZ7oFe7iYHmzV/0Bg5gjQUDcKXBNnKrYQMG/7Klie2J3gAv/f4LL41aVCBxri7ID1j/3n/0WfGoxynw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jackie Liu <liuyun01@kylinos.cn>

Destroy the DAMON context and reset the global pointer when
damon_start() fails. Otherwise, the context allocated by
damon_stat_build_ctx() is leaked, and the stale damon_stat_context
pointer will be overwritten on the next enable attempt, making the
old allocation permanently unreachable.

Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
---
 mm/damon/stat.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index cf2c5a541eee..5a742fc157e4 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -249,8 +249,11 @@ static int damon_stat_start(void)
 	if (!damon_stat_context)
 		return -ENOMEM;
 	err = damon_start(&damon_stat_context, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(damon_stat_context);
+		damon_stat_context = NULL;
 		return err;
+	}
 
 	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
-- 
2.51.1


