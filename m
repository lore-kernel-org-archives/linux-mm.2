Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0E2D1088E67
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:07:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066C06B03B7; Wed, 18 Mar 2026 23:07:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017D16B03B8; Wed, 18 Mar 2026 23:07:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FC46B03B9; Wed, 18 Mar 2026 23:07:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D939A6B03B7
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:07:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6336B1B74B8
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:07:29 +0000 (UTC)
X-FDA: 84561327018.22.DA8322A
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf24.hostedemail.com (Postfix) with ESMTP id AEFA0180005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:07:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lLxmA3bz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773889647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6hujQatMDnVNbQ2NGpCAprMmrazeehMBUZspO/yPHpc=;
	b=duqKSzsY1BC3PCJLoWAzwaCzuDgcvTL7uS7gJJTFGBij/XWwirih13ZGeGc6c84hopS3fx
	5vF0sK6VEbMV264X9fEwHd9aJeflCber1V39Bqh/dMntoIlwa6LR4PurdFBeUk5glW+5uL
	mmhSThFn812NjiyRLdhnDU4DjsMnUmI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773889647; a=rsa-sha256;
	cv=none;
	b=dNh6RiqdWkonb8NUXKq7BDwbg8t8yx3DjPJf13wpoGS6Ux+W+EqJ/yhS4QOuUHRLR+Tmkm
	NgZNZFRbOaVzNPgTtFmLH6StPKIV97gHEH+SbZ/VTMJIRNqLD1URwixDhfdmn5lzPHAPzf
	26YrNbk4wIX/NB2Qnrf4SzkJKU/5B0o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lLxmA3bz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773889645;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=6hujQatMDnVNbQ2NGpCAprMmrazeehMBUZspO/yPHpc=;
	b=lLxmA3bz/arCyCkRMch4A6JK6jCtdnU+JSRXE7p0M3FZJ6gXY1Lh4taTdEghRxRgufa6hO
	uEeuM+d3dc5bC0wpIDLXjX7CEsqyh0YCRTV+2sziEAzrrzMiPTeYfoWd0GlNTdFszW9Oz0
	o0H076XKaHzWDiqKYkiu+8UVqL0cFxA=
From: Hui Zhu <hui.zhu@linux.dev>
To: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: teawater <zhuhui@kylinos.cn>
Subject: [PATCH v2] zsmalloc: return -EBUSY for zspage migration lock contention
Date: Thu, 19 Mar 2026 11:07:09 +0800
Message-ID: <20260319030709.62556-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AEFA0180005
X-Stat-Signature: nxq3twwf84xaocnnqwdfnhm6xr5sjm9d
X-Rspam-User: 
X-HE-Tag: 1773889647-215385
X-HE-Meta: U2FsdGVkX1+EoV4Eh0Naek/GGshk51ptW2Pdxua7HslU4DE3+4j5ab7/5Znqnzs5Y5JUYGuUMXAn+IbMLwrjPb95d/6+cQPsss1q8F07EPdFRRkdjPTTwZ/NuGVDzNnuFef4xr16WIorVhjquLVW6iJ400J39UNiUubNBdvIlTgZvBvlq2evvDKUsaxWptm3K2DrpIH53JeWVszT9/PDi424ZrvVak8otA8G3g010yVosJrGP9oryAQx1GvN45rVV+yQtKd2lqDHemf0DuHKtuZKZgNUpHAwysHIuNlJWiGM0kBkISygQ5KRZXoO9yIqbSvyMDDybCT1xI7Ppty7nZjRGI278Pr68Nlyr1tzyKAIMY92f3EukMCRQVNts87jgCDXkqIOMGufuyATB4YXIvzGxQ25rSUtLlEEiTzrsyd00yHKTPSzpKxSYlocjPKvzORa5wQCZVQaiAJuCmtriN25oI/I8aLeNtDZl3cPSIrejJU1xYQXwLzbxeWJy8ivn0ZC8xh4KjqEanYR12SWvmNPPnddypAUFFPnUZZxEbkOT4imJ3hiFLXcidVGLJp6plesKl1LgZaOTDR6cvqHUlpbFroDgDrpnEsjFEFLCaiHmx6mtMgf9jHGS5V2B4ZqCL6y9MKTFTFOqVl9U1PbDiQypJcXkInsAQlwoEsAnHq0uoq74VnG9O+V7m8W8U73eCVZQzJ/zxUkoDveCWhAvS2H7qjCVsRFM1rRw82RAXIu8SuaFoJ1yESScZBrKJVcC7DDB/d4YEqQ8zKEXT0Q1Ph+9sKbtGLwT+wwq/gvxLMYHltRp61R1OVeqNha3t5tjiUSubErXLPKCeXPNkF1akixR7knI39Ct8RTMRRzBBVo/DqeUzAvAWTuYZoWoWzRL2m5JPglmg/PwW93SoveVAOA82iBBi/wBO5jLqT5Qu3cSb34NXHYHsRWDeAG7tyYn8zgTTOqy0r//R33ZRe
 FlyzDuB0
 n1MDNulT5w9IiTH+uKEyJ0m1xMzrqa+CZDguWitSCXeP2hBpzV3vVAIhDnGNwxeo2/ux7MP1HDtK9d7zWO2OU8Yqsvu3Q1v4/ZbGyEPNXeat6ND3XwFhve0oQfKTgsfQLsINcdheL5Ka38gwFTOaUxYeLUAMCWVfXPVKbLz3qdkyzO5/IW+gHGKLpg4eysXmRUxUI
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
decompression. Since migration retries are bounded by
NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no delay between
attempts, there is no guarantee the lock will be released in time for a
retry to succeed. -EAGAIN implies "try again soon", which does not hold
in this case.

Return -EBUSY instead, which more accurately conveys that the resource
is occupied and migration cannot proceed at this time.

Changelog:
v2:
According to the comments of Sergey Senozhatsky, change from -EAGAIN to
-EBUSY and add comments.

Signed-off-by: teawater <zhuhui@kylinos.cn>
---
 mm/zsmalloc.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 2c1430bf8d57..db42ec4ffcfa 100644
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
+		 * slow decompression.
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


