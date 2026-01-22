Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD13D3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2919A6B02BD; Thu, 22 Jan 2026 12:02:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C036B02BE; Thu, 22 Jan 2026 12:02:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1076E6B02BF; Thu, 22 Jan 2026 12:02:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EFDC36B02BD
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:40 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8440140479
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:40 +0000 (UTC)
X-FDA: 84360218880.20.92A4B37
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 15FE24001C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zvnLNIhU2mTgJAxt/cnwNlpPmBju7gEOXSLQfV9wycU=;
	b=j4mpQu7KlkIp6w/Gdymo1ubWt39Y3mo6TYj9n2eha28DYX+qa+0aQgc2+J/DcUGAftMlSK
	yej64RG7HHF3/+CTZTXaWtFPRnO7T8YLa1oK1046F/kSkJ/v26e9aMF0DV6ybhqsutPqeT
	u6Np/BjN1Khs68YnLnzN3uk7/vCfgUA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101359; a=rsa-sha256;
	cv=none;
	b=PKBM7Nk9aWJ8ThY0JF2oPaUI+fwouvY1iRmwRjqVVv1yrg5Y1M73QleoQmT6TJ8GZ0wSmA
	miSRYRvViro0YEABlupATYTojrj4FolWUKux0++0hl+4+ebY5JLQwxyGZtVE4GPTVZbtNS
	iguo4VyJ+jwy8E66GBUDuAtlR1uXXCc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 523D41517;
	Thu, 22 Jan 2026 09:02:31 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 560B83F632;
	Thu, 22 Jan 2026 09:02:36 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Yunsheng Lin <linyunsheng@huawei.com>
Subject: [PATCH v3 2/9] selftests/mm: remove flaky header check
Date: Thu, 22 Jan 2026 17:02:17 +0000
Message-ID: <20260122170224.4056513-3-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4mgqffquugghj5y41xp5ghza3fmtuik9
X-Rspamd-Queue-Id: 15FE24001C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769101358-348335
X-HE-Meta: U2FsdGVkX186eOdJ603l5C+HDmt8HI95QBXaNT12ZGWv7R0gVfcS9G5UJbDgFFsuY/qceh4504BxSXhuMIV30NNtuM3zT8gsFbXaYwj1u/pqCmnd1FnQnuB06lOdtFvNzTwwAyuh1/Gyvo4I+wsUXZ3O5mWYzJX5j9QHG0cRa8Ks813hafDAqvofLaUKHAfyq5c/aDfFcZQb2JY5ZM4+Yfdx5FhMDcaRmidzGKyUbyVCsOZFG3gr8TMlgwg6GmNTlvSil7oPGqR14mZ1NyfpuuDA7TpIATJD2SYXXHfJ7q5dUN6t4CJQPc+jeZ7bAvonxJC04X6ughzO5WsFg4R7Zhrsevv+LpoQDxtIFlGy3j8o2wOvE+UiwHhxhCzSyPrUkGS6w8dppECjs1i3hTh3E9aNm4qHgNSka9l8TqeMarJP3nwtqg9/j7LHFJrR8jeM+e/XECvABoCMgmXzqoGr1LkBfr9gWE+RxOffAxYVWK8CU0lJc4vGh7bJaXNbUqpNvv9tU8tZebpR8RMm+Z6qBksHanBHy5+I5PrtCp0bmkatrnLCh0DMUZrUSQLbUHm2SH1Bo5Gb6UybkiqfEap/hNqeEx8wDjkxI3gA/E1dyrzDvGSdyA1pZkGPLQRwuM9J1tHBBVH9Pr9y+2N3q88pHXTQ2FbJfdXS5CgHYaDqw4DBM0PFGtjQPXrFJWfF4EIc2vRTGl044o1oaUrJd1zVN34YPL2uhoBXYetQuBUVCPqiNAjKAlamGlzdS2wegGnqE3ILwrIEsP1blph373pU2eG//Wmc7g4WNj1iYfNLLQEx67MLn1apUaexJoyNH1XZzctq9dbzsP5Lf0QufMQOJ1sxb9INgNKpwca/J6qAomhTAyr57buVK3Z9ZzoZB1+AoeQw26yrMYnQXPC3OZsZEfpu25SBMWu0TDvrU6qlLzJqnmWWR6qMrMY47o+05xx6FluIRFgMZeh3DUZinrN
 5R+9UhRl
 ruXiTWEZ/Jbdg4DKHVzg4wxKvghLbnadQYxX1kqrdRhTDJos47yw4PPnoT8HeQMYFoTyMwgup19BHpiTT/MX6TKPpCE/JGfka6QKjFULH+cV8P5obBfA5mKew55Z473a4YoHoER+BBu/+kWfseBqS+iYeC9P73qwSNEE9e5hIy7YDZaFKdhRONlfuTrP6Wgao7Y9yjZcHkksQ7XghSUgscNa02OqFfSs+Pp4p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
is not compiled") introduced a check to avoid attempting to build
the page_frag module if <linux/page_frag_cache.h> is missing.

Unfortunately this check only works if KDIR points to
/lib/modules/... or an in-tree kernel build. It always fails if KDIR
points to an out-of-tree build (i.e. when the kernel was built with
O=... make) because only generated headers are present under
$KDIR/include/ in that case.

A recent commit switched KDIR to default to the kernel's build
directory, so that check is no longer justified.

Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/Makefile | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index bb93101e339e..4e5c8a330a0c 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -46,12 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
 
 KDIR ?= $(if $(O),$(O),$(realpath ../../../..))
 ifneq (,$(wildcard $(KDIR)/Module.symvers))
-ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
 TEST_GEN_MODS_DIR := page_frag
 else
-PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
-endif
-else
 PAGE_FRAG_WARNING = "missing Module.symvers, please have the kernel built first"
 endif
 
-- 
2.51.2


