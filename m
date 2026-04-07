Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DFCCFB5181
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:07:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E0DB6B0088; Mon,  6 Apr 2026 22:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46AD06B0089; Mon,  6 Apr 2026 22:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CC06B008A; Mon,  6 Apr 2026 22:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE106B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:07:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6232F59A16
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:07:27 +0000 (UTC)
X-FDA: 84630122934.14.556A622
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5254840003
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:07:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tpv/V9Oh";
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="tpv/V9Oh";
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775527645; a=rsa-sha256;
	cv=none;
	b=s8IvWFft01vCnTOLKKLGaCGJ9/xKeIL05JO/+1ey2WLhhEVM2djK3qdYw1BOlxJ+TZE8fp
	n2DSQwq3KbedQAsWLLJj7Vp6WI5Z+GWwMXIbKdo8zOA1AutfgWbVMsXkrrgkVZSo4VUG2S
	yB9zx3U/s4RL5HC3kImMh0NowpCB7n0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775527645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zRD8drmtpvaW7u3AYnxWKE0WjDJmYymOaFuTOH+P7/E=;
	b=ebIKklAs9S3R70LSBE6Z2Ip1TZKLbNt31QdKfyfz6XNGBJDMJtDQPvy2Oola0m6fordCx9
	72Tq90xSWwEBWOQVrZNqmVN0NxyWzzEVhGsBvwmDmdT6K+GZkeVD4N58z4kvPS01FcLcG5
	4lk0jIQrBfMfF4//PVREFHqezk2DQ6w=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775527643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zRD8drmtpvaW7u3AYnxWKE0WjDJmYymOaFuTOH+P7/E=;
	b=tpv/V9OhtXG+sz+yP/JXKIRCAbpUWZiZgB7x8rqWKeZAHQ6gfzAkkT6WJ+sPC6ptxvLvfk
	oXuMjV/AaBjJGbQaTJ5Opr3UBxDrUzl4fmd+HgXyqBgeRbYm5q6d99xwrt/bkIHLcuO31A
	Eu/AUJB7q0+MPlYsjjRXkOizm7OQhWw=
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/memory_failure: use bool for hugetlb indicator in try_memory_failure_hugetlb
Date: Tue,  7 Apr 2026 10:07:12 +0800
Message-ID: <20260407020715.2269255-2-ye.liu@linux.dev>
In-Reply-To: <20260407020715.2269255-1-ye.liu@linux.dev>
References: <20260407020715.2269255-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5254840003
X-Stat-Signature: jehtqr6p7qn5a86sdsch54zgn1dth8ex
X-Rspam-User: 
X-HE-Tag: 1775527645-460003
X-HE-Meta: U2FsdGVkX1975juYV0wRUY7Bc1oi1MBNdAyZiSbDqLeqMhL9Xst3hMml9TUv0ZjHc6ssQhgHsx3hNBNqoxaif1BfV7vt2CCI2W3mPoizq82sjRlzIpb2ORzxG/zm1tMZl+Sc5kyc3tKdH4jVbSIrKpCWqooIW/jYcVPjl/4fee5KSLCLNhNri415oTgf0BqcWlXO7gY43YKRQFigBRc6eFoitU4MBWjfriezsHwIpa996aCcg8xLd8SKtJ6Xjcy0qpCU6M+ccq3Bu+/gDrNn3WL1G6xXUizFWgux3iOkwsswMsGGOyGW8/65CgvqS77BDD4LjHn+AcJkbEWxFwiUkauceZLWTUMi4auEK0SLVfhzI046jrYJ9xNYw+xxabiMEQ6P1COTwac+SVdt3ljdPDqqbdPl3MskGVlBogSY4kdu8CSXQ3kiet2cdBwQZ1rwLl7JyqoB0Ya8cs9MGDqfQxd52x1rSGlReDZ8DA7liXq25EJjysdTkPKkZ4ZOGoyoOT/ZVrn5ZK8ulVsjl5xL626bukkfJYhUlY7Ac4rgEJxPayo+UQpA3Y/IkcKYM9Lmzp/o1rr8V4SRap08I4mwD8y3rmdC5d3WTgHv/VpF1vFpF044b8fJ6tBx048J7f8SU8fnd685oyX0mSoFjnODoSTYa6QTAhr4lgx60OYn+P7RFaae24v3F+gCmuhKehTKeeWHNalxJoUf84doNDW61ZaefEGbhxtM1wk0oNVLRjXdnP6eBCGqSaHhYrVXC5SV4Esp6V7LDPwDr5y7n/wfzyXpCkBVyEwmOguYRUWCsT9SqYX8UUSyVKR6zoxulu+1Nc72Jta7pKqi7LEpAsP2on+YeSB+kNI8ooyS+yZSNZYW3BwR/YL6kqNlm3esZcCBRSenazeE5c7w695eL6EmtU27MgjxgJDe5TcSsdlCZdIoYnTU9ZTvFJUbOb1qiY7R0gw5UZwPJvP+CK5D0Rf
 lDfK2aGY
 PWr7boL+Hjikfdy3M0mRdv/YsHi0raI8nR9bRozleYvUDa6GxvSWSs1grIXWJVttvOBMNXxSF4WX2PMqeVUr5GSsL76XmeVzAk6XvGFqoRHhtAGzDEo0UgKWTrkeTZ+CKwf6JUmL1Bhj//eVbfFu1k3gmtAbqber7oyXCYtTVgzJkMmiV69rWqIA1M7IXtCwtzl9GA3T+sHbTLCCwChwMHtNzoM5FVZqBfJmQJErdn6A/ccaKyduydFZUUKSN4pz3gdz3dQSwRKHx4YEboWezGrGGyss56v2OHaBxZZquYPZ06wR4VSFPnqoVhj97bPQOh61Xa98SCxbLeyasOzkl3ZnFE7239xArIbPxseIe7a8Jq84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The hugetlb indicator in try_memory_failure_hugetlb is a Boolean
flag, but was declared and assigned as int/0/1. Convert to `bool`
and `true`/`false` for clarity and type safety.

- try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
- testcase path in memory_failure(): bool hugetlb = false
- clear semantic conversion in MF_HUGETLB_NON_HUGEPAGE
- preserve behavior (no functional change)

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/memory-failure.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d4361309..d25adb390c3e 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2032,7 +2032,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
  *	-EHWPOISON	- folio or exact page already poisoned
  *	-EFAULT		- kill_accessing_process finds current->mm null
  */
-static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static int try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
 {
 	int res, rv;
 	struct page *p = pfn_to_page(pfn);
@@ -2040,12 +2040,12 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	unsigned long page_flags;
 	bool migratable_cleared = false;
 
-	*hugetlb = 1;
+	*hugetlb = true;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
 	switch (res) {
 	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
-		*hugetlb = 0;
+		*hugetlb = false;
 		return 0;
 	case MF_HUGETLB_RETRY:
 		if (!(flags & MF_NO_RETRY)) {
@@ -2107,7 +2107,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 }
 
 #else
-static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, bool *hugetlb)
 {
 	return 0;
 }
@@ -2347,7 +2347,7 @@ int memory_failure(unsigned long pfn, int flags)
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
-	int hugetlb = 0;
+	bool hugetlb = false;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
-- 
2.43.0


