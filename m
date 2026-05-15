Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0239CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 02:02:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646056B00A1; Thu, 14 May 2026 22:02:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F5C76B00A4; Thu, 14 May 2026 22:02:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531136B00A5; Thu, 14 May 2026 22:02:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 437516B00A1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:02:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E29F21207C0
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:02:11 +0000 (UTC)
X-FDA: 84768004062.02.2B1DB67
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 47CDEC000E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:02:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wbo7kjAx;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778810530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zNLJeNO+f9Rrpgd0tK7WrJ+7+se5J9d6U+663BWu6VQ=;
	b=VrAZfoUZViVCqlB4Phh7JgT0TlfcntzcRic3c2EVtM18UtBLKrK94M9pCbaOFbSGJq7qGK
	3Fq0Dfo6XOBAB8XetpdDcfnkVXg5TpR+GGEeS4lfl/Ycr+O4M0RfbXC7ywF4+DSd9isixo
	c/EMq04GvPr5K8PirwAxqNHPHyeIXcw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wbo7kjAx;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778810530; a=rsa-sha256;
	cv=none;
	b=I3aV57Wwn2c2peL4C08eAneaPxK/2gkvlIovSkb1cFRkkX+epJRk9xcpQzoVmXMyEpNlOf
	J79U3PiIpgocnwC16P9aUIpL2zgd2445fGHXcy9M4kqwzPSYDa/8ZAIpUBiw50ft1svYyT
	hCAgjEn91ve1PuOJoVYKyoi22O/20Dc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778810528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zNLJeNO+f9Rrpgd0tK7WrJ+7+se5J9d6U+663BWu6VQ=;
	b=wbo7kjAx4is6sAv32uJCEZiELl0HzcsiV5DpyE4Xh6uljQGHC40z95AJbrADDKMuVrtw1m
	P3+UJTIPgqVAvL9v8sMt/9uAtj4rJO82L40shz9VpJL64REfTFca2rQly8rYlfkSMoBlCS
	/anMXij7UWvE1Wc4esa6L//Lm0mO+nA=
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/memory-failure: remove hugetlb output parameter from try_memory_failure_hugetlb()
Date: Fri, 15 May 2026 10:01:43 +0800
Message-ID: <20260515020144.164941-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 47CDEC000E
X-Stat-Signature: ap7cs1kjxzgqqqwnhqud5ed6omc3qh9x
X-HE-Tag: 1778810530-44619
X-HE-Meta: U2FsdGVkX18Flc/BIYr2hB5MMaU/PjaNR+uMYw6zeGOVSevkPzZ0Hhn3hofKMVeZO/pNzyfXtlnKbAbfo2/oQpajiiQnadgfciomJoY7HYZyUps2bONjsajvjCYcu3fmxfQ/nANC0wyfHFWMX7NkADPtue8jguHhBFh6xZKALljmSGxQ/UNWSpHTHWgrEPPT+N4SzSI/IAiqEROFNJKA2U4s0M1kEAHnTG+zjRrWnufUKSOtmiW0Gon7pWrN2lbbjpYcZ3S2XNM96GtKMfSWTVsxDCRzn78s5XK9PBqD5IXHmLvoc4+xmnTWV4F8nTilM6y8uRsfzsOZtPufSFg9TcOfb36IRDpS8nlmW+mX6pxSso90axKQu0W41vBlA/dk7/wlif06Pe/XWCoZM1OTCxR1x9U0124T2kbxh/v8k3namNCkZp+1xBbwZJNRhtv/D7w678To0ZJCktz1m4O3lxV+UOJqGcKO0iS/75fjs0o1LVhbqatfKwZu2xSmxzhjnka/OcapIaTObmD2m3Y7PDjFcbPuETofVO1E24nmxS3F8TXX41pNl0frRo15N/XorHt4z3ZYNGvciEtWJC1ECFBafWax5/6ghwoW8IZDP09vBuC8OGA3eYub90a20zmb9E1pryFGOlpRCWLKAu7Cl4JlUUkLzNmyfWPUaBvA0O09GLrHB5sYnO+00cPa0mHfFyEG6qDWWiiqoZcHsWpa4zI7dto5r3EZN8djotpucQq9l6cSnsHx5T5MR4AixHSNYswwSyHom2ihjaWHPeayQ1RGsXZDbCUSeQx1XH0E0rDu+m8r6RzTwIaTXG7U5aOgPBRWETVY2rxc/s3x7GCQI4DHCAoI2tjcqPBlqCUTXjZ0MWY8yltMYElGnd+ii7vNUJhRdTt/ryatNHIsvcg16waEQFKf3iLgYstISLMaqPyhndm/2DxUQtz8FoUmNGg7Ad+NeI2bVccfe2maoXW
 b1n1+nMo
 NikjinCRUtWQq8oPR3ie1274m0SWLwJ/KAVnwltSVRWSz/pGFNtPcDbA8/GiRDlA9TJTJrQEXb/gpSDGXH6CEw7i90UpAWPG3Y96kIOwD+BmLSSEYgWHPMeV8cVMfaOkBaLXADWvDuthzsq6AaEMuPtzAxboE2BUbk4Y7sfPZV6fN9LczFe6BdqyOuEZe19JYDFePTQ1zSJks+2yI1BxNE5Qnv0If2cFhY2/vcTykQ0+O8Jf3HuvcHnpkVk16j/i6NQ8CJaOjxoU6d4IplcXPoMavlroF8Hhn7xXFoRKkvLT0RMa2YtSgMKP4mKqhsAw7JwP/pR46xeE6HMht2BjQitNcLkMFHLMzd5413fRyyjnIoA4VtpEldDqhYDO+/I3xzbX9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Use -ENOENT return value to distinguish "not a hugetlb page" from
"hugetlb handled", instead of carrying an extra output parameter.

Suggested-by: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes in v2:
- Remove the 'hugetlb' output parameter from try_memory_failure_hugetlb()
  as suggested by Oscar Salvador.
- Return -ENOENT for MF_HUGETLB_NON_HUGEPAGE case to let caller fall back
  to normal page handling.
- Update memory_failure() to check res != -ENOENT instead of using a
  separate boolean variable.
- Link: https://lore.kernel.org/all/20260513024853.65566-1-ye.liu@linux.dev/
 mm/memory-failure.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 866c4428ac7e..e7cf952221df 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2026,13 +2026,14 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
  * So some of prechecks for hwpoison (pinning, and testing/setting
  * PageHWPoison) should be done in single hugetlb_lock range.
  * Returns:
- *	0		- not hugetlb, or recovered
+ *	0		- recovered
+ *	-ENOENT		- no hugetlb page
  *	-EBUSY		- not recovered
  *	-EOPNOTSUPP	- hwpoison_filter'ed
  *	-EHWPOISON	- folio or exact page already poisoned
  *	-EFAULT		- kill_accessing_process finds current->mm null
  */
-static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 {
 	int res, rv;
 	struct page *p = pfn_to_page(pfn);
@@ -2040,13 +2041,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 	unsigned long page_flags;
 	bool migratable_cleared = false;
 
-	*hugetlb = 1;
 retry:
 	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
 	switch (res) {
 	case MF_HUGETLB_NON_HUGEPAGE:	/* fallback to normal page handling */
-		*hugetlb = 0;
-		return 0;
+		return -ENOENT;
 	case MF_HUGETLB_RETRY:
 		if (!(flags & MF_NO_RETRY)) {
 			flags |= MF_NO_RETRY;
@@ -2107,9 +2106,9 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 }
 
 #else
-static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
+static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
 {
-	return 0;
+	return -ENOENT;
 }
 
 static inline unsigned long folio_free_raw_hwp(struct folio *folio, bool flag)
@@ -2347,7 +2346,6 @@ int memory_failure(unsigned long pfn, int flags)
 	int res = 0;
 	unsigned long page_flags;
 	bool retry = true;
-	int hugetlb = 0;
 
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
@@ -2386,8 +2384,11 @@ int memory_failure(unsigned long pfn, int flags)
 	}
 
 try_again:
-	res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
-	if (hugetlb)
+	res = try_memory_failure_hugetlb(pfn, flags);
+	/*
+	 * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
+	 */
+	if (res != -ENOENT)
 		goto unlock_mutex;
 
 	if (TestSetPageHWPoison(p)) {
-- 
2.43.0


