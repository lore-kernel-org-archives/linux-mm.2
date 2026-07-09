Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 758F8C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE636B00AD; Thu,  9 Jul 2026 14:48:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5CF6B00AE; Thu,  9 Jul 2026 14:48:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F1E16B00AF; Thu,  9 Jul 2026 14:48:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17EA26B00AD
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:48:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A106C1A0273
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:05 +0000 (UTC)
X-FDA: 84970122930.11.B838DA8
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id F05DF4000A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:48:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hwNFxlOW;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783622884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsiSeJx1/eVlqX100B02CqOARqMzp4czdyZ8GjzU008=;
	b=0TIiPSiP36xbj2GVjkcQs1MNth0jEc5C4bJjbcmK8jESk7Weie7C18QCnDmU3NB1gQDBv2
	QbgObalgZdlKnXcMwqTdo7EudaJ7S15AH2YuZkmSRU8W1w13i7c8I4OkD+a17WB+POokyD
	z/Yz4rwOPrRgQMsP+QKw6QVTbaae5cI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783622884;
	b=amobslE1zoVLOUU0koqJW/1tfkcnpdL3m7Wo9vrqmplskhs0nDx/z8za8p5oO+VVteqiTQ
	RkUBSktt9x775KhS0QyApi4xnR3xTQ7Kkr+qxZXtxVZ7qObvYmc7x6umnu+A41dCnLsz4h
	mZOBwb0hTPFMp6xF7BrS8gInTiW4qDo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=hwNFxlOW;
	spf=pass (imf01.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=JsiSeJx1/eVlqX100B02CqOARqMzp4czdyZ8GjzU008=; b=hwNFxlOWUTcTafiTn2yLRDZTdH
	USF5KKVKIjPGtRbAquHdNxr8SVinhl7DP1CUxyQlBVCAN4+JgJCFSu+/jcbdkoq95iTLbWv7y5W6q
	uwCxsNBRSnDryG4qNcWD0tmwtB8BFPAt7HtmCKQ/sVFFo38vemhxHcy/hKrDnsAADczJvoRXF7Prt
	kMVzqYO2j6pH7GDrtoif4jNEoHFjVIyY1h7S/A9SzONSp3Uqujksv3iwCGJNB2LoPWOz8iDbJIHxE
	eGgN/J3hJ5AGPZnJj8T/A55vtDjsCo2SdpEGSg8oP3W5ptFJP2IX0HnRPOCkMMcQR9T3qCnVAjqCV
	BTAq2K2g==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whtmg-00000005OhF-2GEc;
	Thu, 09 Jul 2026 18:47:42 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: [PATCH v2 03/10] filemap: Remove checks in mapping_set_folio_order_range()
Date: Thu,  9 Jul 2026 19:47:31 +0100
Message-ID: <20260709184740.1286561-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
References: <20260709184740.1286561-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F05DF4000A
X-Stat-Signature: yuc8k1g679meqg39bujatomzc7dwoed8
X-HE-Tag: 1783622883-288040
X-HE-Meta: U2FsdGVkX1/neCRmkecCxFher838hqwodZhr1VIA+eTGnZ5abaMeFCwfPx5O428wIgLWQFdYyvOcpoyUyo+4Cx5s/u9DfRqMvk0DqSQxTVHlB9UfblnvSU+/OZJFT4ilAK6Pqu/Zhmb6Y74prxr9gR7PHpxPeHetXYOm2vyJdFasnCm7vjmYfZgfvR1XXW6lc5S5SPNJYsW2ccBwuCvQnA4xQVmLXkx0OnTZRcRPQd5CHainxm/UUYs/iUrnjW6E0VRcqY+ZiQQytDmzfAgZenEQf2xiQ3PnpkXJHMpxTGqLK9roKxamC0B7CZhEGNmFWdssUUmOrV1HZ+FUgiNwNCIrLLyBt5yVlNtZCI1dbDReuihqHtTRykDFE6+Udl2/RCCsjDb6fq0JOcMtGLe3Jn8wobb+nBVqHfFfabB95djipVuBqUg0NHCYGbAUsCurCHmoSANpcXaeHWaGqJLv0UoQBy3XYx6Ib90KIqCHTbxkuR7Kuu9G3nPxyH/0CdEqGkqEQJpsq2oAxyN347V9YfaF1hYwTtaOnngpIzEGp+84qunq+ADgwuDmzC4WPoIZ9ABpBYLd7MQ9xX8+cp6aadAuA+J6md1YBkgoxiIMQ0XthAw/LN7cCOvX8Z2teyPX/YPSomIcfAJQCqwQmYt4NXzn8p1n5Y8DotEwbrCGrzmcikpSbcTQrHxFmnWoieJcXT6TirQHvGAKCdpVA8Dnv5JTeUHHHuOK9ts8+b1IAxOR0/EoW74gBEpB7CDCQP18GCOM5dTkkVioG1zCjWTUSc5nMqJtK/Uxw8x1EC+tltal1qMLnGCGamp0qaU0vCjvV6LpEID0CBsPkImxJMGWsTzKXR+1e9bhjoL7vgSPboirUxYYE73olvARNBHtHspi87HcWrUxXAqDwuU/L1txJLriAOnwcZcxqCPxCG05doVJXTxtvYbIMVKNrYNM4Npx4P7aDSXyWryaDE+qh4Z
 m/3z43wR
 RRPNzzAFcGKlUhoeUzSHnZ5duCzOOeR7kJ0C/Y2w8lAacnzchgXpr0QvKGv56kcsNPvXB5QHXDFc1Rw5roeucc6gJzG8IRIpstDzPzGhboy+lQcjacWN0V58QATsWHQdi6W9ClvEYlj8UCAh0yVK+iMUjOxusU87WGRdrGdT8HmzYls3K9Xs8hVJGwIlW7mD+9BWTN1IAW83BL306bfHzQzEc1M+JdSS1ClRunCwUNuqrbdGJwD8llie3qG70FbvZAMZSNjyeOIJB8AUE0ayZt6FmgFyrCNUv3NWTYEYoHCjQVCtdUuimLAKeblm/ztAaMyKc3deTNaGBfvhdAzZLWRBuTl3A+2b01bSKJo/ZDqeSoZOF0bCP5SqDrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These checks make it impossible to use mapping_set_folio_order_range()
in hugetlb.  They add very little value and can simply be removed.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..d0c9aecaa4ac 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -405,29 +405,18 @@ static inline size_t mapping_max_folio_size_supported(void)
  * @min: Minimum folio order (between 0-MAX_PAGECACHE_ORDER inclusive).
  * @max: Maximum folio order (between @min-MAX_PAGECACHE_ORDER inclusive).
  *
- * The filesystem should call this function in its inode constructor to
- * indicate which base size (min) and maximum size (max) of folio the VFS
- * can use to cache the contents of the file.  This should only be used
- * if the filesystem needs special handling of folio sizes (ie there is
- * something the core cannot know).
+ * The filesystem should call this function in its inode constructor
+ * to indicate which size folios can be used to cache the contents of
+ * the inode.  This should only be used if the filesystem needs special
+ * handling of folio sizes (ie there is something the core cannot know).
  * Do not tune it based on, eg, i_size.
  *
  * Context: This should not be called while the inode is active as it
  * is non-atomic.
  */
 static inline void mapping_set_folio_order_range(struct address_space *mapping,
-						 unsigned int min,
-						 unsigned int max)
+		unsigned int min, unsigned int max)
 {
-	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
-		return;
-
-	if (min > MAX_PAGECACHE_ORDER)
-		min = MAX_PAGECACHE_ORDER;
-
-	if (max > MAX_PAGECACHE_ORDER)
-		max = MAX_PAGECACHE_ORDER;
-
 	if (max < min)
 		max = min;
 
-- 
2.47.3


