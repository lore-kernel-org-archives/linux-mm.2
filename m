Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB6BD116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 11:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B776B0006; Fri, 28 Nov 2025 06:03:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4C106B0024; Fri, 28 Nov 2025 06:03:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B896C6B0027; Fri, 28 Nov 2025 06:03:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A8F966B0006
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 06:03:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 39F67160520
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:03:17 +0000 (UTC)
X-FDA: 84159729234.18.9949097
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id C068940012
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 11:03:13 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E66xgJpp;
	spf=pass (imf07.hostedemail.com: domain of fushuai.wang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=fushuai.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764327795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KOhj+NoWnqwi6LvTWbfrvrYcRtxIq25xmrYqKSoPDfk=;
	b=d6GrfdrocJLNjARD0bOqgOqOasYxajENt4UUvFQ0UCd1HZRjlXCwF/2mlBoq2jEP1/Fl0X
	vLiBVJ4e6siJtM00X5PhScwJWze+UpGHSgnyNE4QI+5371gqPIN6Eu/lq+3lB0Tk27xnxY
	vU2mUJzpKy4wqqfu0V1UonI5w3SXwAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764327795; a=rsa-sha256;
	cv=none;
	b=rZaV0L1x5ZAXVu6RspK4IEjrSiseP5UeBvom8Nz5lXZRxPRqNVbNHWfhJPgMfG5PoVQhxE
	cYVPVNFqjvgODv5pUzkn+gXUJLB5WsZT82lENICxGnXl9DRy2hLXZCJ3uoBzIZv4O+VxM5
	iC6G8biErxxV3NppGU/NFMV3Tv20jLM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E66xgJpp;
	spf=pass (imf07.hostedemail.com: domain of fushuai.wang@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=fushuai.wang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764327789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KOhj+NoWnqwi6LvTWbfrvrYcRtxIq25xmrYqKSoPDfk=;
	b=E66xgJppFa7C8eV+Q9htyF3j8lduDQg7MjatMihuPVjL0/WRw80xM6qNNRJ75Gd6hBkIan
	ipQYIDtPItJ0lKlBEbR87gnE5IOdaHxUyTN/MCbmWOL7WzQdQ8q4p0fKWBjFbyZpv970g5
	QYhSZnSKVfxrUeHr2SO/Mx7aLELOo/4=
From: Fushuai Wang <fushuai.wang@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangfushuai@baidu.com,
	Fushuai Wang <fushuai.wang@linux.dev>
Subject: [PATCH] hugetlb: Add guard support
Date: Fri, 28 Nov 2025 19:02:41 +0800
Message-Id: <20251128110241.78580-1-fushuai.wang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ccww914z59gpom5c5u5fx8w4yfyu5d89
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C068940012
X-HE-Tag: 1764327793-892926
X-HE-Meta: U2FsdGVkX19WLSfYT+A35aLAJW6xa53/ZDkHIimc0KyZwTs8vOR4WELxJRFl1MzvSKA7Pf9RfxtzMwguO6X+Akfb5c0vm28PnMznX7AcvomWOhMNqFeigkfqdJ3/u06f6Cyf4A7BdkllCHORC20T4XVXJGiQ823pHq03THCu3OVwnsHk+dNej9mXpGxo52/3P9uo0ZUtmW6qha2OxwgPq3uXYIVaNdcmwbOfpwPBr12Pyn69yYSvQWr3YfloYqGLd7pRaNTMTdrxhn1fLtLk2g/GKTgE9w8CnaMxucX+RNCe2DNnhvgEJ1D+kLFcu11eXMi6f2ormb1JSX1mc5OrTrpq7EY6ofrOSnLIRuiKHfeTHtW4y1zru9BIyA2QDkVXRElFFDK9U/N+qWNSdEVh68I0YKRVGSKWFIjKdq857sYm0M/veNK8OAO3cbvUpTJVyQtR776xi56ZY1PuQjC8xFfZHpTi4uvi4sD9l1afbLkVlNFvKwywyq5MAVvFTaRE1Tf9hHnML7qeZB56KaRQel9J5DM+p5xehaBRLn2ngc/IQSCk0y7Ebpu1UvSJo8B+E02CVtjAXt0fLwIVgbcG1u95KcID8dn/soqQady5Q/VM86k0M86tEcn0TtFMxJYhz2VgKGQ996dWXUHQ5B4V5XCJ05vNBZULEOvaDWTG0TjqFC/pE5bEskW+t1WOIOpDG5KCBgc0jcfUP+1MYnza6leRmEf9Z6sjEPrQInFxbbRSXK9rrw4w5Q0nsZk7nH0DFDO3etqq7bRvp4FwQZo27GojSLgs7A67i1dOGsRMM6hKa5obILW4kEEl9O1ZDaL2GvDZPPG7wYvDVX9I/VgN2aAIqs11uFLKmgSSFLtkfBWFJuxBc3nS+jhNqHnlPZzUwJyDSNWmNKqBo4/4YYUApzaqfMWR0ZLa22oetojEIMqf22V9ATD0yRDj2nog0G9w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce guard support to simplify the usage of the
hugetlb_vma_{lock,unlock}_{read,write}.

Signed-off-by: Fushuai Wang <wangfushuai@baidu.com>
---
 include/linux/hugetlb.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 8e63e46b8e1f..f97cb2f123a3 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -15,6 +15,7 @@
 #include <linux/gfp.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/nodemask.h>
+#include <linux/cleanup.h>
 
 struct ctl_table;
 struct user_struct;
@@ -468,6 +469,13 @@ static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
+DEFINE_GUARD(hugetlb_vma_read, struct vm_area_struct *,
+	     hugetlb_vma_lock_read(_T), hugetlb_vma_unlock_read(_T))
+
+DEFINE_GUARD(hugetlb_vma_write, struct vm_area_struct *,
+	     hugetlb_vma_lock_write(_T), hugetlb_vma_unlock_write(_T))
+DEFINE_GUARD_COND(hugetlb_vma_write, _try, hugetlb_vma_trylock_write(_T))
+
 #ifndef pgd_write
 static inline int pgd_write(pgd_t pgd)
 {
-- 
2.36.1


