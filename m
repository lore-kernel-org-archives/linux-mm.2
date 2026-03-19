Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 989D7107526B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 06:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEF926B0403; Thu, 19 Mar 2026 02:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA0D06B0404; Thu, 19 Mar 2026 02:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9964D6B0405; Thu, 19 Mar 2026 02:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85C2B6B0403
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:59:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0DDB11A03E4
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:59:44 +0000 (UTC)
X-FDA: 84561912288.18.F2D32BF
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3326F40006
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:59:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f77AfviT;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773903582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MqgwjOgYAgCvdM+KEzOVlrYDCZwrzcZ5oUrc3PxO6ls=;
	b=jhJ6N8CHLd+1Z9OUwkW4NxV0WZLKvXhsFibjc1itaj0OaZ24LhsHiQnjl/UytQQTYz8VA9
	Ij6eDodouIut+69mpm0zzv5DuPgK6CSsCdGrP19JxwfVwrKHMtqM2tIN+P93bd9yLRnfVL
	FbncfDAtuc3tUnp0StTyRtABHB1C7iY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f77AfviT;
	spf=pass (imf27.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773903582; a=rsa-sha256;
	cv=none;
	b=c+S/IIlHI8eVDUF3tiF2cz1hbVBVZmOd71zpQZFRRqHFqQmwdmsbnEPJFJmv3TGtVJaERz
	UZUIb5CaT7I77YMmsKz/SLt5gIbEcn2WQcN2aETNvBUuoiTgOW7smkuQMnNgOxjSioGQwI
	yc9e5Vstn18IppirCYnDyZgwSV9iZIE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773903578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MqgwjOgYAgCvdM+KEzOVlrYDCZwrzcZ5oUrc3PxO6ls=;
	b=f77AfviTCa3A2iLW9blXxrDruz8cCYgr5yLo+h5gX+KDVCyDyen+xKEyIMFeTcErPpXZDq
	GP+/ve/NhwcNVBZlo/A/+g5O0lglmhg8Hsd8Ns63Ts7xpZpr2UxNIDvtH4cksMYyd5nAIn
	dYcDs87YHhTdNadxnFQ+PlohXiTJOJI=
From: Hui Zhu <hui.zhu@linux.dev>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: teawater <zhuhui@kylinos.cn>
Subject: [PATCH v3] zsmalloc: return -EBUSY for zspage migration lock contention
Date: Thu, 19 Mar 2026 14:59:24 +0800
Message-ID: <20260319065924.69337-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3326F40006
X-Stat-Signature: 67qfy51cgk5p9mrwejgfr14wrxikxxw9
X-Rspam-User: 
X-HE-Tag: 1773903581-167815
X-HE-Meta: U2FsdGVkX1+SKsIN5Lxh7Y1OX4zyso3QxnOgKbtAQV5FrWNeTDewA7fwvY/P4MGI9RW/FvYzg1FLzWZqVcqBOMzeffMVUl/1TCGM6G6Rky2VNWtorY51kqmf2vWhi0txOe0n57+pdosbkqdLbZKRYbBR6aSNbMZjEJGtSI+wc5Wv4/9SBug+Q3Zae9e7N589EN4LwlxLl6XmHwFDsA7MRnqZ+a9SK5eSdi2UBGBimwPzkpy1P56IBw9cmODuwO+W5Ew+jkT2G4gBVDSK0rmjG+LssrjFoh/2yEEAG+1WUbDBs3os4qXHftfiCqYDrgHGKLuh/odEanUJ5G0ZKXldCIF2aWDhJrg0l6Spg9Szl4NiwJzYE64jCW6dyODmh0ZiNTJLQGI3mv4kOJqRiAzszPETyR/XwQHaUY/EuFaMxWzwKru4ECdtHy6r0fetJKEfwtKXehkj4lqUEUemS9y8sdF27G/3fwuWCFb3IjXlMmMHjrYp/f5sYfk1idDNZy7fLemRW2w0LbFvY/MO/9G6uD1Uylydeo42/igPBGBpjez6IiyNN3LRPFyPLfq+/zoOocWTrR+lZO+0v6OpR9goyRUVwfl3fk9VsfKtN2oKku0hsnnjwsv4yMgotG4yRzZN8BkDoxldGHJn+ynpM4uN9iOQL75y3NE62Ncnl99i8kq5mzfDBABktseON9xmekXIgts6DKvWFIRomuqwgU7lWg2ZeWxGl2KcVvnhkPwWOgk6LsSy69jPqCk2MxSIJpmF3faNqSYCfwELABTb0CafvK1c/sEzpCRTrcSjzNeKjNYOLe/FFOzo+rb1HQF+d1UA/k0YX9a8qfmV/owoFMlBU0y4vN4bbxKOmuO96r6J9ZP2YfrtHdXNIlmpdu3ua8PnFv1kZGmGfj5u2YqUBzs1dzOIHoxnapsPXdqmZmsVlorCakyygJJDKMChDFm/5ZjjVyH9UWI0SzRXMeBXOJE
 FKiQ+lDG
 2a81+BA/wEhmEwtbn27RPTMEB0w7hPjIWyzhdehalP/6pEKLISuQzQuECLIy+V77xwSMpVfdYbt4Ci7ceWFEs5mnhic3XOuIXdpgB12RlJ8ZIuhCewvZsjc1q4Aqmmn6HfPCeInUCfHQfw7jJdeZeOGbLLCK2o10lgcbJft+Deqnb9LhsfGeJOWBiHYaPi1l1Vtq5q3RYBYOc8x7HgYXVQdtP+Omrs8s5nHpF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: teawater <zhuhui@kylinos.cn>

movable_operations::migrate_page() should return an appropriate error
code for temporary migration failures so the migration core can handle
them correctly.

zs_page_migrate() currently returns -EINVAL when zspage_write_trylock()
fails. That path reflects transient lock contention, not invalid input,
so -EINVAL is clearly wrong.

However, -EAGAIN is also inappropriate here: the zspage's reader-lock
owner may hold the lock for an unbounded duration due to slow
decompression or reader-lock owner preemption.
Since migration retries are bounded by NR_MAX_MIGRATE_PAGES_RETRY
and performed with virtually no delay between attempts, there is no
guarantee the lock will be released in time for a retry to succeed.
-EAGAIN implies "try again soon", which does not hold in this case.

Return -EBUSY instead, which more accurately conveys that the resource
is occupied and migration cannot proceed at this time.

Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: teawater <zhuhui@kylinos.cn>
---
Changelog:
v3:
According to the comments of Sergey Senozhatsky, update the comments.
v2:
According to the comments of Sergey Senozhatsky, change from -EAGAIN to
-EBUSY and add comments.

 mm/zsmalloc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c1430bf8d57..e7417ece1c12 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1727,7 +1727,19 @@ static int zs_page_migrate(struct page *newpage, struct page *page,
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);
 		write_unlock(&pool->lock);
-		return -EINVAL;
+		/*
+		 * Return -EBUSY but not -EAGAIN: the zspage's reader-lock
+		 * owner may hold the lock for an unbounded duration due to a
+		 * slow decompression or reader-lock owner preemption.
+		 * Since migration retries are bounded by
+		 * NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no
+		 * delay between attempts, there is no guarantee the lock will
+		 * be released in time for a retry to succeed.
+		 * -EAGAIN implies "try again soon", which does not hold here.
+		 * -EBUSY more accurately conveys "resource is occupied,
+		 * migration cannot proceed".
+		 */
+		return -EBUSY;
 	}
 
 	/* We're committed, tell the world that this is a Zsmalloc page. */
-- 
2.43.0


