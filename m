Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053B6FCD0C6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6356B00FD; Wed, 18 Mar 2026 03:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D216B00FF; Wed, 18 Mar 2026 03:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1E66B0100; Wed, 18 Mar 2026 03:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2516B00FD
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:31:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E467DC2174
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:31:49 +0000 (UTC)
X-FDA: 84558364338.25.A1FCF98
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2491BA000B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:31:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q6yEcEXC;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4eK33YHoFdr17RO57NYgTKQzBSCrnmY/AC+hh3sskTE=;
	b=O8J0DTSF7a/+aenGmIkQx3q7sEIVWynOcpm70fzwDeMPRqGDStenZ533w83woeCs11dfLD
	attg6fuQxD0wn/kuVzSY86lIV+5cNVGHbGZFXi0gUjX+F2OWz7ttrzaowXhG86+FuMqjhQ
	WaNzTBCDlTskrI6jv1EdTOg2myeF7VU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773819108; a=rsa-sha256;
	cv=none;
	b=yRTmcSHxM45mVaQjtLfLGLJTHXldp8Ht5ZYR9HUQWz9dgjeTCbm8H5k6zhyH51KKUGoml0
	KQPoUfGn2zc5tGbRTsU4Iz3w9GD5gOZhDffmQgazxBwDTa6ACkhHKeflRPRAWPT3BzS4rt
	R17c9c0k7eG5pJNHT8HNUn0H+eYMrSw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Q6yEcEXC;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773819105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4eK33YHoFdr17RO57NYgTKQzBSCrnmY/AC+hh3sskTE=;
	b=Q6yEcEXCwrotndBsaTdAD2UOU8SMZjsDebOqSSK2242NaXKEKNJ3dKWnj6cw6tXauhJ5+3
	ApvoZjdH9enWf65rTpw1azIL+hxtPAvrNqvw3cU5EJOtgX9b83CFDe3PBznVVOhGk6lARP
	IUBG6TkMDoGA4VvfgawI5hyyhxRPwc0=
From: Hui Zhu <hui.zhu@linux.dev>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: teawater <zhuhui@kylinos.cn>
Subject: [PATCH] zsmalloc: return -EAGAIN for zspage migration lock contention
Date: Wed, 18 Mar 2026 15:31:14 +0800
Message-ID: <20260318073114.34858-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2491BA000B
X-Stat-Signature: whjytpnz8enzhux94cpfh15oz84k17yb
X-HE-Tag: 1773819107-427561
X-HE-Meta: U2FsdGVkX1/ZKgEWTco+MY3PMUNdREYuUG9wQ+mJ+wpA5dgRnsJ+ArF5qKrL+mHI8GSw4tCH85QagKnzpLKU6MfleVIMdAPX14rL7R2V49XvvnnXqRkaaPJlHZalceXrs8bWFqwYEbKlQEu/NOzzRNILXGmPDwiT/Ew3ZTZ/jkh1lp0qBVJdfw62xqcjy4uiH+KxoOcRI55Jk3Gghm/nHj8TESIWyLS6SxiK4jg/zB6+WfifIF7DSJ4A6gDZMyxSwJDPfBMmc1QPqjTTGRGTPoY6VBSbb4eumTw4ANtAv7oJkOcIyogl7AmlRe/gIPxEb960keB5Wl/+BHMD9cBCe1bOaXJ44lNkcwpJshBs1wHEYsTXFPG6M5oK3QxttUwfnUPbJJx55jWUk0VemMyYA37t01NiJHZE3Di4SfEAj+pXr58q1aKxV1bm4iKCJrtc41tOk7htlWhxhz3wK22vZb8GEgXMKrRAphL1pmD8cUyCZudXFGWyYUAm2Ehj8rNm3zpO2CDj7YISqWX1mKZZm7AV/B7VvpNbOfnMuENdkyyIGy4a0jbJWnUzM4cudSCF2p/+uTVNDi42DVk22x6l6lp2NuYFTYTFEdXhWCH3yCW+1sap2xV4DCyf/9/ng3EE6Pcy5Heo7CXV7G5vBgJTFQxZ0fY6uJH5aABXN2twC0tcYk3dxC8jXS9HenkdNnA3EFDdJ+a13lDIEb3RJVEF922/UpiNq5y5s6fZDquO9FniWeMy36ZYcc+fN9ATxJgIzh7wswVlg34esBlx8zaPivuQiA8SSWHXeU9o2AxsoKbNFkRVS0/Nt4Srd9ORYWAM7nTo18uq2YF3/1vHnPPSNF71jrw7JJcrZlqOJa4afy5Y3iV7FPxID5iA/3HP+lAeKIWljRFZ0H8RKighSeNVc1UGZOGcZFz7erlvaBdRrzUEgxQnKLtLUbqV0JGlo6rfkHCJ0aSZt37Krf/GDZD
 D2RWRTyp
 FH8UX3IZoJUl/4AwzWM6Ucax7ceM0oZG0CXQQFJh2KRQJvVOTXPbOpxNaBq5pBhQNnwQ1DJ8U5M6LbqFcMX1iPTcnIa9FTDfW727PFG6WEb8Lw5wuif/ywU3M0w80KqtYudPWOIhzDspVlWs31Mq/4MSxQGzhzf1Ik95A+ytvie6fggTT3OybZengII3M888/KidB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: teawater <zhuhui@kylinos.cn>

movable_operations::migrate_page() should return -EAGAIN for temporary
migration failures so the migration core can retry. Other negative
errors are treated as permanent failures.

zs_page_migrate() currently returns -EINVAL when zspage_write_trylock()
fails. That path reflects transient lock contention, not invalid input.
Returning -EINVAL misclassifies the failure and can reduce migration
success under contention.

Return -EAGAIN in this path.

Fixes: e27af3f9360e ("zsmalloc: sleepable zspage reader-lock")
Signed-off-by: teawater <zhuhui@kylinos.cn>
---
 mm/zsmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c1430bf8d57..1d26eda7f50c 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1727,7 +1727,7 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);
 		write_unlock(&pool->lock);
-		return -EINVAL;
+		return -EAGAIN;
 	}
 
 	/* We're committed, tell the world that this is a Zsmalloc page. */
-- 
2.43.0


