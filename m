Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05281CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3616B0098; Tue, 23 Jun 2026 04:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBA816B0099; Tue, 23 Jun 2026 04:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFC4E6B009B; Tue, 23 Jun 2026 04:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2A86B0098
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:26:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2548F1C1EB5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:26:45 +0000 (UTC)
X-FDA: 84910496370.23.7D9982F
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9FD5C8000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:26:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qAj/Ud+n";
	spf=pass (imf02.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782203203;
	b=xJRgBNYYAgYMrUSrWZYqQcTOPSkbn1o5v3HmcDYsT4A6Da645rYZTBxuJK/qdcbsFkBZwJ
	484VvqXUr/cBS0W70DXPRWnzVaQ0S8iqQT21hx4T3vEgeHr8AdqNNHYmQmy72GdeYbkEAO
	mlh1JZBGo7+R1DTMH4wLvVO/YgqUGFE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782203203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oZr4ekvOsJTTwgNBriNjKAByh2c4c4R0Fz9QNeRo4Ks=;
	b=iVXXFlD28K0oY0PNRNKfeZ0wprYkCKaZI+VCQ6edUrcYR6yVg8WrgHYQm+NXnKbqbZ3ZSc
	6UESUKYHYjeTiqHGMuLjjRG3T75RAgJlr6BymhJ20T++qNzFZeu+MrHofXwrUXoqPm6wwi
	eioYyMJ30dElrH5IFelXCuTbAb1CDTM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qAj/Ud+n";
	spf=pass (imf02.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782203198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oZr4ekvOsJTTwgNBriNjKAByh2c4c4R0Fz9QNeRo4Ks=;
	b=qAj/Ud+nweTMsayeeGUcxTOl0Kd5xdG2F15Ph3kKhdRPkp9KTXHmWUWyYVT6ibeLAtdBwH
	aQiMS0x/SOUQKdnSWcWz2ark48GolN0gHgUKcRVw24V12pwXjTI19Smge3CCT7pHCOPOEB
	sYcVM28un3tnYL0NTemL7GspwRGpqzU=
From: Guopeng Zhang <guopeng.zhang@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: [PATCH] mm: memcg: remove stray text from obj_stock_pcp comment
Date: Tue, 23 Jun 2026 16:26:14 +0800
Message-Id: <20260623082614.81621-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: gwqno4q43gzqj6aswio6jbjtto7hjhm9
X-Rspamd-Queue-Id: 9FD5C8000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782203201-49591
X-HE-Meta: U2FsdGVkX1+HYKxbBkBp8qeufcg31+OyRoDmEoillDOVlWJcGy5rZe789OTmhQ6W4SLLqpa+xR30pE53wT2Y1Zu3G2V39fK14YH1kq+kvc0X7iLLU7Ct3YioJ1wbnAdEuo2O0LSK9x6/5C06UYLye3XoIcPAYQPkX0dnkK70f76zsQ3BjHDT2fkNFPfi+oSo35ygxF2BQp25hZAkdbPL0IYxGd0AOCwbeX+vuAqrvtjx/K68nwa2Amzz7nwyMTs82LpBvV6VaDZHEdRT7fhPw/PK78hsJNUC6008yyOesBnjvyB95tI+G+KtKSFwXnBs9FdL9x0y/9907o46YOMcfFu3FMO9gNwnzK+vYtOvMkSgOdE2ouCPA4as7SbQxLmhur4fwrmKJIYRa+G+KT/ms3XSv25nh/N9AzY/P9pB7qRdAwx421+OdUfEcWrc9nJConCf/dOI3hen4UVnUS9OF8tWWi67d86S9EfsWkldytRPLz0Hdm6FRbDmcgXm0UGHB/k5fhefVxPdSTgHXESxbt95NEPz8b5PxDUKeSV+U9KVNLckRCjqVWCDbCEvWj4UptM/d0Qmuvedep0X9JoLQ9XGFHPS8yxAxwPOcsq3mRnQTopc1lwvIGn2x7lEgBIEj0O7VnNwPofRR2csvCCKyvRTpOthYeV7IZferLsxC1S8L3SMi0FXJ2yOKlT/v4KjmQdihPQ69EzPpXjs4V9Yqcb8ur/u2bBZovoffT8k61sHyPD92b9YYSJnlLAyveUEuJeO/N8RrOcvO+hxEsnYwI5EQtF/wCErIJGCvyayQ+Z/W0om846AebL9/QlvT2UuTLLQqfY8mYyyN8rQKhlXpIHI3hsSrjktvt33HB7E85aWW5VvWG/8dthZy489oouA/fggmr4C56tOLciKFHEO62Kqr1fjoY13BBCyJSh9k6mT8iaXcITl6PHn9fRSG5GwOmY6Jlr8Ac+YYc0KFJz
 k0/zPg9h
 gPmdnYqgVKP8Gf4pWDgBt+zUYk0fUsx8NE7ESwqXzjkqb9AYfCZ35J/qEc3BImS14Zy65AVuFRm3y4/089cBLSdD6AupmjPwUZtZPSh7hVobsoNvz2k431G1DTBXsinaknhMiiLqM4B+NpS/rhsl7BcDRHpN4mduTOtGHx2UKYXa4Es2BlFHNsAUBO//PZsaL3oE08dLYV/osjcf/l0Aq45p/pfpEUKGVFZMqFKpKMJTho7PGzEdfTNeK3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Guopeng Zhang <zhangguopeng@kylinos.cn>

A patch filename was accidentally inserted into the comment describing
the nr_bytes field of struct obj_stock_pcp. Remove it.

No functional change.

Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..3eedfc4e84a0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2039,7 +2039,7 @@ struct obj_stock_pcp {
 	/*
 	 * On rare archs with 256KiB base page size (hexagon and powerpc 44x)
 	 * keep nr_bytes to unsigned int as uint16_t cannot represent the full
-e patches/memcg-uint16_t-for-nr_bytes-in-obj_stock_pcp.patch	 * sub-page remainder. Such archs are not cacheline optimization target.
+	 * sub-page remainder. Such archs are not cacheline optimization targets.
 	 */
 	unsigned int nr_bytes[NR_OBJ_STOCK];
 #else
-- 
2.25.1


