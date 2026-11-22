Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F489606A331
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 12:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B6YkN1re
Received: by kanga.kvack.org (Postfix)
	id AEAB86B05CE; Sun, 22 Nov 2026 07:48:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC1596B05CF; Sun, 22 Nov 2026 07:48:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FEE46B05D1; Sun, 22 Nov 2026 07:48:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3AC6B05CE
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:48:53 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AA58A070F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:53 +0000 (UTC)
X-FDA: 85462734546.22.6DF2ABA
Received: from mta1.migadu.com (out-225.mta1.migadu.com [95.215.58.225])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1B1C51A0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 12:48:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B6YkN1re;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795351731;
	b=riJ7JiYFDod4x6RP2UyolN5a6AjQ6pZn929Nzudr64oAnKIAH2Yew/ZyoJBfriycmBtVMj
	o7uwP/XKJ5/nxey4nVmNcwUxuCrPfywSqj1dpEMdQpKybzktEJiFEAmcsNY6BsDt0IB5LX
	ikHMc+eK1rKE+X2Ljtc3UtwgQpH5yEo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795351731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKST39Qgob/15JyUvb1jtvUq7sR5vzYjfLPvatIKN2U=;
	b=D8b+H3FRZfgMyiJJMoSQ+5PxNQGIo8ZOGE6p9P0SWNxGWcDOQICyQcvC4Uuz8Yb56FTeqM
	Xc8YfhLpNSEVFQo1dCvY8cXJQIoVAlOZ+lSfJ+p1gBcxcu1wy69ytfBPhLVne2OVQiTeAD
	GdeLV25Z/2Agu4okElBCPQHZg3ZEjgY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B6YkN1re;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.225 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HaBlWQdkD212yi1iVAl8GzzPNT/gn9jVIw4YWXqbYdQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795351729; v=1; x=1795956529;
 b=B6YkN1reqThtuWZ+2vBgvYXSF4caYXUX8OHC4wV0SiliYEnLI2mgL7vXDSXu4NBCooaQMTdg
 Uh4U5x0Ctr5zq52rCELs8Vc54ZC2xfWI91gf7VkO4BDc6G4wWA8kwHInMzyC/AFUwwwNwih8h8U
 TWaJv9WWKVndB8PsQ1WxZxIo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 859b52e110b08025;
	Sun, 22 Nov 2026 12:48:49 +0000
X-Mizu-Trace-ID: 859b52e110b08025
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	baoquan.he@linux.dev,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v6 14/14] mm, swap: skip the overcommit probe when removing xswap
Date: Sun, 22 Nov 2026 20:48:14 +0800
Message-ID: <20261122124814.3489077-5-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261122124814.3489077-1-baoquan.he@linux.dev>
References: <20261122123918.3486916-1-baoquan.he@linux.dev>
 <20261122124814.3489077-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1B1C51A0004
X-Stat-Signature: z4b8no5i1453a3ijdkrhtufgy1u59pwb
X-HE-Tag: 1795351730-679544
X-HE-Meta: U2FsdGVkX18dwX/yba8XpRX9vfSq/XlKo4NQ+Hbo7yEjVPAR8hT8kL1jKf21WK1bcL7d5q1eJnRs+SAlNAWqFba/01v9ZkPaJwklJd/F/MVJnHbvJ9J6FuW46LXd2vkbMcQf+uFN/inlK2DHNyBdcO1xNRdn9RdmRhX6rSolXrs9dE2xwzUmWi+DVsB65a1Xi5gGOlA+Uym0vXhmXKXwXY4NMrSv+IYHnMt1v82CImh/2ni0iMH+PxsvMjhWjQb0yGP5IASbPNIXuVPHnh3zs7gE951+6eebQaUeecEKogZaC5Vs7CvVMAH4liuRqLScLGLdYnvGFM3kSRIvuv3I5ZmQrYBTVPiEllFiNyXm7SAZBX+x74RyZIsj9npSH9vXmt1JAqmRNiN3tqTsFGe1lqW5h7RNgVyra2R383DYWvUFq8DWtJcbcJcC7nzV3OJX4hMsTmgZ/T/iwRepufhiS47ZA3ggx3P5TiLqbj+IC8K3+fjYFp35BEdPMJxRZK1ucrA139bltHr98OdyaJIHVKxMUfb8wmcy+Me6F3TjGUZ/4zCY2DX5dAKcBhxpHbPKToLFdFwlUsjvYXZx8W+8BdY6zTNapexlULJiApjeAdMdkbs38Be3iQWJoOVuluLxFDFy+LRj8A+YPtqJdTctwm24ahgoZBlZW5Qd+6SKGWncQ9wHiZXf4jYsjTVq+kBcjXdW2nrKHALR8z9IVdqZpvikauLZ+mZPa7PF/pLu0oAkJAQ3Kzy3UNmN0TuIwA3ER6DP2WOUHjNbbQZHZar4qO0OVBzeaJ/a//MkaVNQtLDY38M2Nedg176oLkzcDveoXibsfUIoqppp1BLv7KIRAuRlnesyilmDa1aSMZAU3yu0Ijdw6rCJwDvhwJ2qX2w3WkZzONUf/+Z4jeWqrG9Yu2Rk4+v/RJbfehM77J1poP1lk3VnUVmogTiEduEghd2lBZTY3f+f4ix/waBZdPL
 DwxETNTt
 O12OMHZqmA3SJtKQS9KaBCdfL05tSC79S0fW8T07jURrfvkzmB3AhsfU5Dd6UdNynn9giWzXOHeNI69TzfvNp3AZYZYNaJU/luSmKw/bc6esbO3ltBWE7fr9R/mmI/TOLJSjxGxPJoObcO+UX3HBxDPGdtYgFYNcon9cjsQilBb+Rxv9OI+ryBO0M7jv2U6p3zT16IHrLQE4XgPy/Hl4qszCFjUiOFlC7oXM1uxhU2AE6IP2ASw1GUxdIc06YIP9S0fBiKywRPqB79laOsZFKFAokmwGmHdVnK6yfM7CQFnFldn/LI4PN5zWb1WKoxLZ+2lFf+rlNMtVks69WVWnpA8fU7qi/wWS6EKVbqDVLyfvg4jKcREydseMCQadov+Y8voN+Fva9KgjhJSF6bCpK3jgetBzgge3sakrG/LsJEz+aXPakJ56CvffOlifVQjDLvXVuYwsz5KU6BgZIRgcLA04YmzecsuIQezqFgedTOab/XGHwzR88szvf4lTZ/tofLVhQgFT8OVH6Nrs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

swap_info_remove() probes whether Committed_AS still fits under the
commit limit left after the device's pages are subtracted. An xswap
device's pages are its address space, not backing storage, but they
raised the commit limit at creation. A workload can commit into that
headroom, after which the probe refuses to destroy the device.

Skip the probe for xswap until the overcommit accounting for it is
settled. Real swap devices keep the existing protection.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 90f17edce1d0..a65afd35c7d9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3644,10 +3644,17 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
  */
 static int swap_info_remove(struct swap_info_struct *p)
 {
-	if (!security_vm_enough_memory_mm(current->mm, p->pages))
-		vm_unacct_memory(p->pages);
-	else
-		return -ENOMEM;
+	/*
+	 * The device's pages are its address space, not backing storage.
+	 * The commit limit it added may have been committed against, so
+	 * skip the probe until the limit stops counting that space.
+	 */
+	if (!(p->flags & SWP_XSWAP)) {
+		if (!security_vm_enough_memory_mm(current->mm, p->pages))
+			vm_unacct_memory(p->pages);
+		else
+			return -ENOMEM;
+	}
 
 	spin_lock(&p->lock);
 	del_from_avail_list(p, true);
-- 
2.54.0


