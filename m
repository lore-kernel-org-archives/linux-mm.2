Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 887F9FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC6AA6B00B7; Thu, 26 Feb 2026 06:35:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8E36B00B9; Thu, 26 Feb 2026 06:35:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D73E96B00BA; Thu, 26 Feb 2026 06:35:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1BBC6B00B7
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:35:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FA17C3663
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:35:03 +0000 (UTC)
X-FDA: 84486401286.14.E3EBBA6
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id C84E540008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:35:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bQvZ3Bk9;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105702;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZL1HqFM5fa36Uz0JOdbh5qV5iDmtrECipMEqRvI7/A=;
	b=r2OCZQwThtL3AjmsQsROp3wOkEDT6IUle1EAwf1951LS7ctZmiqCADwlkqFuOXtjFKR/UY
	xoDGYybvv6BD93+YKnnT6paVL1ZkuuGsbuKr3Hhv1vv/3t553Oe5Y7vNL62UGacwW1ZKbJ
	kh8dWRgbHcqpaGmIXiOajzczyLh2CfI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bQvZ3Bk9;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105702; a=rsa-sha256;
	cv=none;
	b=k/eqITP9VDL0FMsyA8Ij/uZwUAs868fBMQEO7xkZil21WuyzNtwaVmVZY0pPQ1BRilZprb
	Yre+nxpbykJHgCcR71eowdP8T2odbUAoqv7+h85EFnJSARRJoZ02FIDN0g31Zj723/tWmX
	FyPgtZgJmSooBsqCZlhaPnfRa8SAKzo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lZL1HqFM5fa36Uz0JOdbh5qV5iDmtrECipMEqRvI7/A=;
	b=bQvZ3Bk9zABmR2QjQC7aS7RsAH/+WnY/o7rjw0sMM8KWnVjY1pM/mPaqV2KVkr7y1+1yqV
	D95OAuC1N714g5HBViSG7olcJX86gP0ns8b9QPlaHVVrOOimKpItd/woUJYp5+xK0IrmW4
	ebj/YYCu6frGA2CLRuuQD3QUhJIoTZs=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 19/21] selftests/mm: add partial_mlock test
Date: Thu, 26 Feb 2026 03:23:48 -0800
Message-ID: <20260226113233.3987674-20-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C84E540008
X-Stat-Signature: hqe8o4txbcifjctndgu1gcft86d5q6ww
X-HE-Tag: 1772105701-506037
X-HE-Meta: U2FsdGVkX18emmEA69CpfQqJ/6nv7GpdzxWeVzs7wbexleGu2XILvi2btDArWWXScn4ODtBE8QM8aKoA0+3IxoMpNA1VMbWy4nUWmrx5CXNABif7lVcafy5eRDBl65BNBUYwLGvgF7bgO/EI4URA0T049cy7U4STmRMofvd3vCGDWr4qwZfVft8UFdpxNadMKL2wweEyFuTXqTHWVlIdKZK9vdF4wP3lvlVMuzWYUlywIg8+rTxaNJ5hiTRWgviM/BrZN7hI5aSS3vR3chJRcSONm/d9XtJJ6aeEmnPw5aL9yipbe3hLMHvZZQx9gVOiy0wP898hq9rl4tXAAk4/1ut108fcsk1gvGVoSDvNEDuRT3ZjONRX/DEwYE2B7KoejMl7ScgEpTgfHm6FSkvZwD7Vhw9mWBX+jq1VxhZx3+m6T+Li7lSMRD4pn/jdFzGDGnh5FMRUsnWjiESKEntaLG9NLjltIS1bOdlWZlRJGCMICduIpMvKtGp1u/O478JoSomRMcC0JZsOMd8VohDGurtIcj3TCpchCxcCefWsjo+YlYehW0cQjcG97eedQdWFklPI9ZQb5BwqlzBzKXwjUUc83TYIXXvB3wRtmKUKlbDXXK+TbEP02tMffM7wlXGHAJVC2/xuBNhwGnmPT4KSIWKqT1Huw4RyxXP9eDGjOzBuwaIaPKXF4CF6QZMfNDMWkO5nmno6DHlMKb3rZRyzBm3aDN+Wr3VjzM/52ZSmV2W+qwz85DvQjRxc9qOm309Tg0i7osKMiGLpCoPzsxLqlqwK8CQyxNxXmbB0lqTGs8jt5hQFd7CJ3mMqwZ9CZMdgqfkdtlZZGzUPyVjaRoE7pxhoT/EXMH8wS1KYz8dlm0yfLej713NsOeiYJjYR/MziahEikeZlcSCgXLNZYRylsyaqme2Fe+VRRJI7j4XmHv+DKgaao0AEwB/j+Wx/kAphYWkYORKmXvukMOj31Nl
 LjUeuJgC
 dB2kYmip30augZHitexKbjWuJbv3Tifze7miwdmUsW/aoY2ymHsnRxXHoqE10lD/oakOntwMY0VfeOadB17vOtS97xWVjBnabn7hH4UR0xxFDkagQNNwyjM8zkE84lyhHuQpGePQKlY+TBd8E2UJyJG0pQNcCe56XYXoE3lr4GHNfXnVARgo+zHhOtXrUQJs9Gm2hWD6QVuC5Bw+LQTeu5rlXl8PhwQszx2PKQL+McpClohUVv1KIXfog7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add test for partial mlock on THP which exercises walk_page_range()
with a subset of the THP. This should trigger a PMD split since
mlock operates at page granularity.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 .../testing/selftests/mm/thp_pmd_split_test.c | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/mm/thp_pmd_split_test.c b/tools/testing/selftests/mm/thp_pmd_split_test.c
index 4944a5a516da9..3c9f05457efec 100644
--- a/tools/testing/selftests/mm/thp_pmd_split_test.c
+++ b/tools/testing/selftests/mm/thp_pmd_split_test.c
@@ -177,4 +177,30 @@ TEST_F(thp_pmd_split, partial_mprotect)
 		self->split_pmd_failed_before);
 }
 
+/*
+ * Partial mlock triggering split (walk_page_range)
+ *
+ * Tests mlock on a partial THP region which should trigger a PMD split.
+ */
+TEST_F(thp_pmd_split, partial_mlock)
+{
+	int ret;
+
+	ret = allocate_thp(self->aligned, self->pmdsize);
+	if (ret)
+		SKIP(return, "Failed to allocate THP");
+
+	/* Partial mlock - should trigger PMD split */
+	ret = mlock((char *)self->aligned + self->pagesize, self->pagesize);
+	if (ret && errno == ENOMEM)
+		SKIP(return, "mlock failed with ENOMEM (resource limit)");
+	ASSERT_EQ(ret, 0);
+
+	/* Cleanup */
+	munlock((char *)self->aligned + self->pagesize, self->pagesize);
+
+	log_and_check_pmd_split(_metadata, self->split_pmd_before,
+		self->split_pmd_failed_before);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


