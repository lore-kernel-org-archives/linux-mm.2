Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151E3C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2966D6B0093; Thu,  6 Aug 2026 13:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26D856B0096; Thu,  6 Aug 2026 13:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1836D6B009E; Thu,  6 Aug 2026 13:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED1BB6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:08:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A41F40159
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:08:09 +0000 (UTC)
X-FDA: 85071477498.18.73EDF9E
Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	by imf05.hostedemail.com (Postfix) with ESMTP id BC9B310001C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:08:07 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1XKw5FG;
	spf=pass (imf05.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036088;
	b=OHoYjLaht54Ah9V0EKID3yT5WBHL6hwRExntlOYSkK76DwV0TfaaFgWttdW0qbeikdemWY
	3k4cTMihDLEqaXcQLTEJA+UJBWL5Y70fB6wyULdEBIqUi/u6NNxsBUMbmthll6mkShmMsR
	1RoU3GiIiKtwBorTk4j4FvrR59dU+Ng=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g1XKw5FG;
	spf=pass (imf05.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.185 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QdJIkDZt02KDXWyy13fgX++BhyE6OHznvvIz2+ccsgI=;
	b=sBMqLSGX4mhso26pJ4Oae7v54+ZtmYMI9dSCaYBI/eegxxojSL7GxP7gpaOyKDK9TrKYOs
	kihQAHypo5fgScbAmE7KKKf0d40B4N0g2Lo+FEe4qfWcqq2S8W+/tLqcLyi6yLRWdi34hS
	FtiBy1FVZ4qGFpk9uD/jtB91aeteevY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786036086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QdJIkDZt02KDXWyy13fgX++BhyE6OHznvvIz2+ccsgI=;
	b=g1XKw5FGsoe4d7qJVnWP0XzNu6svQmFhvh4SS8kB1WVNAeloEVM+1ypb8xM3D8IFroznmT
	DYgNXjUV8uumH6y1YCaCYz0K/iaiHCOGSC0nXkZjcepPWlhRNi2FTGH2F+yB56/kHR63oO
	eOf8zp6LL/dDcrc6iIR34+Db37ozCuE=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] mm/damon/core: remove declaration of __damon_commit_ctx()
Date: Fri,  7 Aug 2026 01:07:01 +0800
Message-ID: <20260806170701.79266-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BC9B310001C
X-Stat-Signature: 3pdi9899fdtdi37zurdh4grcc3cezpsw
X-Rspam-User: 
X-HE-Tag: 1786036087-322837
X-HE-Meta: U2FsdGVkX18+CS8eBpXu1Uk/nQhnrTaU+mI+Q0PrMrb7BNAsxdyxV+EdE7t64mSzHhpBDVtqz6D/b8MmoPKo0+pjvsjXkm0e3Jaru9qlzaJRIXlUiWamPX2/M/+g6S+dvZyAVxGv0e+idglMRo9/+MhvbGZZVkCYKAYV9hqv45UY3QMBVu7wcKvj3eBcDaa3nr/q9NC1mzz+utp/K8RyEOZMVuUsbkxlIh+kRIsO/i20LA/1JoWnM9mEO++ylp+brMhEZz9lTsHanHVdgB51p7vRjxKG5JcqPDtGrLNMjAOE2KD78hDa8ZLL+4eMpve+YzOqqhHzsA6HYDr8y67u5tZEjoFA0nOyALvnNkUesxLErCTu4vPmU2BuPOH9FPowdI9zuBjz6GLF0qbgu+huVWVIV4ya/Ehg60Dj0IG6n62eJqjxeEvNKG6uxpCJIEN8e93S9YlyiBRsjyy7BPg3oOzHfOmXqaKwcqdqfH/TQ4P7WG+w8239U4b0j/ts7wzBPIRxk2BYNiJsG6fAe46T6MLiFGbabwRrfbBFd19/GNfocU/oplyt6bfATcHYA2aP4wKJls8V2LnndnlNzMQHTIbFCkmzNSH4TGoLKIVt/+h1skBp4Us/CUZLbx0nwchzEZNVjc7l7UkGEVgWs3rsxqRVSuHBCAmruj688pzFJuMATw8OMtUEDa6IqydcL+DMFZeoxHkcKz+ZXAiHEbQUR1wJggnHu2MxKImcKwRvx2/kunDML4XYy/dIvGQv8jr7ev+tC7HKNvxbY5jUYlCoC9Ogv7wXoKSxSQCTW+ae6fyAAGpXFHeeEGPLTWr8TSOC+Kc94DZZkXaykT3QOrn4FbwIKa3tjHeVcO2/4IvX9eL+v2oANGBlxzIluh51aDtfJl2woI2Arg4ouDVQgaMWJGH+D1/VbUBibCmFRDp4K0DszDtrf8JsARVmwaM8f4ybqqaUhn7AQj2+dpeIt9u
 xGkBsEFr
 xg/RtScUPS9kCsRwIs9TzIGPC8daeiXHtbvo/mlIhQXWnp4CAacIcbYovliZEQ+3IIUBsTboLylB9PdDlnYeOF2aqGJ+GpTZPHAYxEIWh+NwIvDQwWSWSw7gHuqDLWWS7TCAseFyyW/Nlzl0TUDdIIk8Glo5dL/A3FnCM5LpoPXLfpBbrxEvxpZUMhBNpylOeSqF5dBNZivwDl25zG3perGy5ZA+Z0WLnr7+PUyMAoaPQOoQ9TgHuryERsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

It was added by commit b1471afe4d10 ("mm/damon/core: do parameter testing
commit on damon_start()") but is actually not needed.  Remove it.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 mm/damon/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e03df0a61060..fb884b2b1c92 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1954,8 +1954,6 @@ static int __damon_start(struct damon_ctx *ctx)
 	return err;
 }
 
-static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src);
-
 /**
  * damon_start() - Starts the monitorings for a given group of contexts.
  * @ctxs:	an array of the pointers for contexts to start monitoring
-- 
2.53.0


