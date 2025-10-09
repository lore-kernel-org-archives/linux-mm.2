Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74983CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 04:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F668E0036; Thu,  9 Oct 2025 00:00:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9992D8E0002; Thu,  9 Oct 2025 00:00:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887938E0036; Thu,  9 Oct 2025 00:00:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD358E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 00:00:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1620E465E0
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:00:14 +0000 (UTC)
X-FDA: 83977223148.02.A9F0D68
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id F35AF1C0013
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:00:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MkrjgvgR;
	spf=pass (imf18.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759982412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iOOytkRlRyd08DE1xcHe9XEAQpgq3PU8oBwXXY1s9+g=;
	b=RurpE57kRqUZykXDDQPVe75VHFhtkysKwp/fjvGNMMQqxK92FXt4q3eaq4PQNldeEWfGij
	sYQPTAHbQFgH5ujliDNmtkfQJ8DrL19XdYMXNfqjmK2d5cJxSaEF7nhj1/eYarb88QjihA
	0sw2GtP0qJN4Q//kFMovhb/N6AmeClo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MkrjgvgR;
	spf=pass (imf18.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759982412; a=rsa-sha256;
	cv=none;
	b=SfAgZiKsC61RwtqdFHUhv271m3NtVM+ISEiH7hSrVOVhVkTdhdP6stxGkw+9PAs5KrcWrT
	2yMkfw25TVLf7Ix8s3SFC7qMvyOBiVJOlv2ceXQ021RB2F0EFeRKDX67GqON6h+Ekk+toO
	8dLNBKYMSDwdp6+s1eE1vRMFOyn0gu8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759982407; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=iOOytkRlRyd08DE1xcHe9XEAQpgq3PU8oBwXXY1s9+g=;
	b=MkrjgvgRfgyPGnuIhyfysKjr6P3vl0i3Ost4uZ2ZslTat/0If9Cis5gcRimUW7b0lrRPndLu+GXq+0eSqPj72Jehr7emBm0wkpW7b4iBkqY64sgQDRJ1ydIj9tptReGG0ppXi5Zj09hir2jKTifgYU/lqcozsUlI/RY5fPGB5vU=
Received: from L-G4162440-1116.localdomain(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WphgtMN_1759982404 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 12:00:06 +0800
From: Yadong Qi <yadong.qi@linux.alibaba.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ying.huang@linux.alibaba.com
Cc: Yadong Qi <yadong.qi@linux.alibaba.com>
Subject: [PATCH] mm: vmalloc: BUG_ON if mapping size is not PAGE_SIZE aligned
Date: Thu,  9 Oct 2025 11:59:43 +0800
Message-Id: <20251009035943.526-1-yadong.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F35AF1C0013
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: da7re7wi6kypf51e8iypc56sohsg4gpc
X-HE-Tag: 1759982410-622593
X-HE-Meta: U2FsdGVkX1+AOWGwBhUv5PFHIE89at+lPmVQjFHNqzHIMte03gIJulI6iwvyZMr5fe7yIJqfTeQAJAOLQ+s98aUUjWy4790pRYJ/ElX/OJnT0lwZL6scl9ecch8ZF8myOUksbbLKpw8XgZAFE27rCb+e2sG1tOMzGLiepi6ErFB3F0QJaUhFQ0PWJlbBoNqRrY1GxPpaM/ViucYdV2gBUEavi8nsE0KRIlXnzpELyzUemuPxQHOXeRdqhIHTNJB5CmeMnQAEESBj0SaNzbpmz/pI1DY4MJcIfHY13LqN4QE1b3ytZnPTrfVQeHfR7BupmIkmTIzHUCpacfauyuA+04wHa8GCIa9PsdC57B0Q5mpfKMuOYNozBclSu32/2Dm9FwHSuobSh5ak5XhOUCGdQWAR6sNUS73UHWb2zN2mq2ywb5zyEfPk1F6OVCvXUTcQOraF6cGQ6gbRu67AkfORfAVRxWGGh9VGg9BTjd1/Xfca6fj1ei0/oH3w64VuASlRNM7YI3kG/ji2lqJDAUjU2tLjFhkLw/EVhh1u2Tu8nwhpk4/7bFYnc5THsSqpQMzNEyl96fTs2kiTdBS2/nRuPwYdbD2ZZ2fGYLB6/WH7m+ZqDTL1wuyCditvN0GyjHxPFYSDcVkLXmTUUrnhHStqiB6MphoaBzZAdjnPPwII4IMYd+2G1VW0I+ftkbpIDFx1itfEdRGgG41w3H5HTTdv4rVGJYmuFy1ejmeXaYrw1/uSgH77gsGHceraOkyDzPwqLWBkfahe5Cc9ciAQCj5iJ+EO6Prv2bW5f7aut+NCQzl/QsYqsaEHdLNUjp50s9N2Hasy1WePSDl0PoY6JmYdCUerc9O/PaZsAA7s9aOwULnZZqXqItzg2LhSu2wT0CP9mo4MCk61UHnNg89UMuoNMBBf5A3EN78r/3dna677enzckmnYivRidUZBcXc9OgU4SgxbfKlFjeqSgmNMGLS
 lM3fvQVj
 PtbU47FUiUqQBni+hzYkpEq+BySdyAebSN4AM3ob6oZDjOpBeXYL4K91NIv+jOOpTni4/ep2uZHd602d6gMcgTCSCs7SwHYXhxU7Sv7p2nDf6cL5r1sd5D7+I2whu4LJK7R7XPnghZw5fQ8IL2MD5yx/+eqJKVw1TN+2TbauC6hlcmu7LImumv7kCEsmw0w5Vp68TjaFCG6Gq9TTRckpk8hhUuUkR57tJKjL2j9XHd3rI3UeI7ukzHFK/fSYy70Q4aZytD8NWRy9DWekQtDl3eeJQ4wwr8M7Mf9pAh2VJ8N5x75SNOmkQJCFM7vjxF5ZSNfpPhjjmj4xYzbM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mm/vmalloc.c, the function vmap_pte_range() assumes that the
mapping size is aligned to PAGE_SIZE. If this assumption is
violated, the loop will become infinite because the termination
condition (`addr != end`) will never be met. This can lead to
overwriting other VA ranges and/or random pages physically follow
the page table.

It's the caller's responsibility to ensure that the mapping size
is aligned to PAGE_SIZE. However, the memory corruption is hard
to root cause. To identify the programming error in the caller
easier, check whether the mapping size is PAGE_SIZE aligned with
BUG_ON().

Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
---
 mm/vmalloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2..b54d3ee6b202 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -100,6 +100,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	struct page *page;
 	unsigned long size = PAGE_SIZE;
 
+	BUG_ON(!PAGE_ALIGNED(end - addr));
+
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel_track(pmd, addr, mask);
 	if (!pte)
-- 
2.43.5


