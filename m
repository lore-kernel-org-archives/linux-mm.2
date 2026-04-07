Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B3BFB5173
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5C06B0089; Mon,  6 Apr 2026 22:07:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD2CC6B008A; Mon,  6 Apr 2026 22:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925D66B008C; Mon,  6 Apr 2026 22:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 751DE6B0089
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:07:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2289B8C086
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:07:29 +0000 (UTC)
X-FDA: 84630123018.23.3A2667B
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6AA9EC0006
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:07:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YO0NMKTm;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775527647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjMxtyhJaFG5pOQOqH2K0+MdO1zIjVmI2OgbGlmSS28=;
	b=BtNw44U4KZFfDe2zbfbDOOlsrh4Lpi2ktn6/ki/VI5Vl54SCNOIFs1k+HncCKJQ3PkKH4g
	PzaCuRtX4+gyaJ79fConTQOlVH01KCNmswhPIeuLxcwfNta1JOD/SppjcexJxkk99DEEL/
	dbq0T4BP6SFRhLS7cvV1FtvQsdrTCdM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YO0NMKTm;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775527647; a=rsa-sha256;
	cv=none;
	b=j1tXTPWy8aVWwwpuQ4WSoA+sg/WAcPSGCCEosQz99qK6LA07FuKSZ16B/QTeloQu6MIsYq
	5dMfzQqEWuSAeLjccmDJGAMbX3Q2VKc1+SCtNDY2Uwrhp0cKJwJR4/E6mN8gOhGbISwuSH
	8Ol6872IbXeNsBttpP2J5ARsvaiG5bs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775527645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FjMxtyhJaFG5pOQOqH2K0+MdO1zIjVmI2OgbGlmSS28=;
	b=YO0NMKTmD2znsF9cjxHJYmmXM/sq6DtV7ZMmrvc+6adr5Txo+e9agPGjghfMa+XHDhPhpx
	eHqgmU58BE6Spk+lb2EXYbzn5C/avOe9Dirsp4SdKnf9160aBF5EpnL170MrKRJfSuDY+d
	LT2TghsFGGF1jpRte+lH2OXp3GE87ps=
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/memory-failure: use bool for forcekill state
Date: Tue,  7 Apr 2026 10:07:13 +0800
Message-ID: <20260407020715.2269255-3-ye.liu@linux.dev>
In-Reply-To: <20260407020715.2269255-1-ye.liu@linux.dev>
References: <20260407020715.2269255-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 6AA9EC0006
X-Stat-Signature: ujffiyu9uhn5gbbtqgfkw7c985oh3ph4
X-Rspamd-Server: rspam06
X-HE-Tag: 1775527647-179313
X-HE-Meta: U2FsdGVkX19eZT6CNFFKnhGzbZwkSC07H2r9kKOdAlHzLbUuqLpIcsFRqSrynI70EcDxUDKE4lNiKuxuSeSwe2npbyFzY3cdfdV/1+oy71IwxmwSzzB9Z77woLmu+67n54OzJfaDP5OJw0b2WrTFzxd8Gzj8g4aslzlzbxbjIlpad0C2x6KzqPFrIQRklRJJY/L8459Aco8hGzMa0HPuu9oJkM1G39hHjOqiVqTvtglHXfnKw33mkRmFE6+FQZaaR1+X+eDU93ijDBNsG3HqYGHcAESJTOSXCYWPNc20NVw5JIelznfdn352l1Dh4ooNYe6fjITyRelMgeeVUFODrb9dP41WL5byvvcyfPrmdExoLwYIiDORtFePw6p08DZ8D6wKEcNrj3LOfxeBZ67+BpAg2H2s7/LSJi7sO3MoVTjZx3VwGL9csxmn8K047L5cmpEYWD05kIuneRdl311myPSed10+eVBehTNaz4IVmOnGfUysS/XigQXZnOkwmkOro/ma5m2KX8IMhjfN0ewEmAOKxvf7CkCj+J1KKuso/UV78lNwp19UOG2QAj075fhB0f0bbPsmxIALChIXmCndaW8OElUUSk3sQw1WCsM40tS/L+ddSgcXUKMDIF9w6X6pgvot0Q6g1bsa0xpXcP7ArYEwFjwD5bxPPiUQxvmEXxCxTolSYhqnr8gVmkChUEPM/HjRFJz/AYquXyvFVhB7nHUS3tsyovAFX2IO0LRRIusa/ZgQgA2XD2Spv4WAdpBZFFhQ/ZZsRC6MC9B+gic4oZ/ZvJw/t18L6aZkLf8ltdmAP2F4BQuEFrvaawC7MWVffaHSwXtiryJpJAtu89BklcR2pmxBHe1Mb8pDTL9Wa+4t5jXi+/mTeeob9wGQJ0iICPLhPcYKrTebCKg9AJ0ZGzrEh48S8KmF+dG8yg9SqoRr6MSpJ8NCSLLQhM/M/AjVlsfKWtEBQ1oTKUupuy5
 xuabnCsU
 wuCR60JN7CucP19G57bH+QMaB3LsdD3iYQpT6z5SMD40N8XBlXLXlujHn/1uet5Lu5RCo55xabjmRAn/2KMn8Hnzp6+ChQD5IBLmG3hNO5Yo3cB2VdACa/fAW1DakRNXR0qMb+Fg01awhmgTiTSCGS3759dJYt3LQmslW/UzakwG1n63TO8BZ8tZZXmyabtEDp2p4q9Ynf+BUId/TY2DVf7IBVGhGLqSw30dQUIOrvX+Ju02c+mXOUwgz1QYnMXtmNRa6xKZrW2oO7qw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

'forcekill' is used as a boolean flag to control whether
processes should be forcibly killed. It is only assigned
from boolean expressions and never used in arithmetic or
bitmask operations.

Convert it from int to bool.

No functional change intended.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/memory-failure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d25adb390c3e..f355642bc2b6 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -459,7 +459,7 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
  * Only do anything when FORCEKILL is set, otherwise just free the
  * list (this is used for clean pages which do not need killing)
  */
-static void kill_procs(struct list_head *to_kill, int forcekill,
+static void kill_procs(struct list_head *to_kill, bool forcekill,
 		unsigned long pfn, int flags)
 {
 	struct to_kill *tk, *next;
@@ -1582,7 +1582,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 {
 	LIST_HEAD(tokill);
 	bool unmap_success;
-	int forcekill;
+	bool forcekill;
 	bool mlocked = folio_test_mlocked(folio);
 
 	/*
-- 
2.43.0


