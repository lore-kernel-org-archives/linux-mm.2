Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8588CC2A06C
	for <linux-mm@archiver.kernel.org>; Sun,  4 Jan 2026 13:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59476B0092; Sun,  4 Jan 2026 08:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B06EB6B0093; Sun,  4 Jan 2026 08:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08F96B0095; Sun,  4 Jan 2026 08:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0726B0092
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 08:44:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18D045C864
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 13:44:11 +0000 (UTC)
X-FDA: 84294400302.23.20C7015
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C2B5C0006
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 13:44:08 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767534249; a=rsa-sha256;
	cv=none;
	b=X5etKiPvEifRwTM6duzMHwGqTqeu4zkFA2XWHM4iABptNdUhVTUwG0IBi2rWiI9LxKrE+h
	+Jo1T4Zs4bAMiimF67cBe6ODwq9586Csh/R93Y4Cos+tnK4kuFgnyKzUqqWYWsuLne9IIT
	MMpCi+O6zoGPa1jmbnAAtPzApteTzfg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767534249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=31alRJjH9aMomaXC5Ty+m1cilsBmQIpUnm1Eg7pXAIE=;
	b=H7L9RdkI4at5+Qi+kD61NqIalKT4qHxIUMNxCvZTMXyTnQ3oE9hwQ0fXI3jfJ6u++uOnu9
	lfIMcIw0dM/AlUiVRm+8KEIIvW2uOTKBi+H0ylrPJtFkoDfgRwjhUlBSw15WxUQjNdIwcp
	fMwwmoAGMZwzRcDo4wGECmw9YZh5G9o=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 20FCF339;
	Sun,  4 Jan 2026 05:44:01 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D41783F5A1;
	Sun,  4 Jan 2026 05:44:06 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v1] mm: kmsan: Fix poisoning of high-order non-compound pages
Date: Sun,  4 Jan 2026 13:43:47 +0000
Message-ID: <20260104134348.3544298-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C2B5C0006
X-Rspamd-Server: rspam04
X-Stat-Signature: wwdncfup6izg7rusm9jwx4cjsxwwd9wa
X-HE-Tag: 1767534248-802544
X-HE-Meta: U2FsdGVkX1+RThFGNuaO1It7nOVLlCp15rRTdo7PKqZ3+KcqWrgbAc05+B25ikkhEFdL159rJm6iRajFsceHswcp//deFYKJZzfbpiE+zh3XvvykIVXDUgUlaF2fCgBMIUW9rbOL1vnqSC30TOX7YVi6RICIjQXVXJWd0ofioZNErQ4IUqjq+m66c42S91ia2QJ4FJjTsS04xiVlJJV0oySnvDtCfV4mjtOF8WrIzH8bIlooUu/o4Yq3LhFhkvqi5Sr5oo/XpYm8j8JleNTcgT8cfeKp33N1LjrXpOREY/EzbJVOtuhh1HsscD9TErLjmYFgnwssGq0/Gk5HTctSyeGtQlq1veHFXxRQTR2pOAMdo+MSka9aukhvzgG4LsfBF424qqbTQu8yjSaQeWrZEgc1H8IPHxF7BH4Y1LuNuvqDWwA5sSblINSAko1TkXke4P1yxxxeoujB8OyFFLhn8kBXll/FFynt/yA/16ftuhwjdqOVfzmI696QFJWX/Ba4+bmTqFN2Ic8xhXl7JbXFYbKftj0KjDvOgGmC90+k98i+HI2H8iEPhOhlEpyQB3PYZBJMWFzvKDZ7P+VxL2BWAF9Ujcl6CB0ZYqpPt0Ptn4v2Vj+cWdhg/MWpz0oPGHbpUvmHc705pEFaIVj3A3n/Tx2VEMAWN9uYOGDSJEqJgkm3EK/S8BeoOj6Tlbu6Tv/BUH4U9quLIdJxNHd8knx6azqzEz/cssUYRO5T1WuX0FAM2bLeOGBvpIv87QKGaLM4AJNZ0EeYWox94NZ85sjvueBISSCr6ruQGYVxMxzfAkYGNFM8WO0j52urlqy7Uo7ZZNy+RuyqygKr2FyCKRCdwKg5+nCIkj1CZtTg5SGoNNLB6yZjc5e+RyO4Em/IdkN0SLjWE4rsQeeoM2tvoYWy4MC+mSuBVjCNC+gqQgdEDJ6vN5A/M8/oocgM2aJRF63EoNc8q9raBjEhv96ZG4S
 3zRRncdl
 Ng2lyAIeL8+LPzAT2TXWIZ8uzmj10V7oePOXEm/++8DaT3AXrLUot9lGIeZVACT9FmS5C2sEpCA72d1vicxCPvFAyK312AOfk2w7li8C8VKymPuX7q8sPAsqiVdj8F9j3G413167eIKLhLmFKv+7f8koFXaVE5Hwu4+VafBR5Bdi1+2M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmsan_free_page() is called by the page allocator's free_pages_prepare()
during page freeing. It's job is to poison all the memory covered by the
page. It can be called with an order-0 page, a compound high-order page
or a non-compound high-order page. But page_size() only works for
order-0 and compound pages. For a non-compound high-order page it will
incorrectly return PAGE_SIZE.

The implication is that the tail pages of a high-order non-compound page
do not get poisoned at free, so any invalid access while they are free
could go unnoticed. It looks like the pages will be poisoned again at
allocaiton time, so that would bookend the window.

Fix this by using the order parameter to calculate the size.

Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Cc: stable@vger.kernel.org
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---

Hi,

I noticed this during code review, so perhaps I've just misunderstood the intent
of the code.

I don't have the means to compile and run on x86 with KMSAN enabled though, so
punting this out hoping someone might be able to validate/test. I guess there is
a small chance this could lead to KMSAN finding some new issues?

Applies against today's mm-unstable (344d3580dacd).

Thanks,
Ryan


 mm/kmsan/shadow.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index e7f554a31bb4..9e1c5f2b7a41 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -207,7 +207,7 @@ void kmsan_free_page(struct page *page, unsigned int order)
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(page_address(page), page_size(page),
+	kmsan_internal_poison_memory(page_address(page), PAGE_SIZE << order,
 				     GFP_KERNEL & ~(__GFP_RECLAIM),
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();
--
2.43.0


