Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15BC1CD0431
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6536B0093; Mon,  5 Jan 2026 22:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5C36B0095; Mon,  5 Jan 2026 22:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E80B6B0096; Mon,  5 Jan 2026 22:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50A276B0093
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:10:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B61F1A0367
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:10:59 +0000 (UTC)
X-FDA: 84300062238.21.A5A7FA9
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf28.hostedemail.com (Postfix) with ESMTP id 40678C0003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:10:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767669057; a=rsa-sha256;
	cv=none;
	b=zHMe9RAVM6jm9L5z8w3gjOzv3bBAfXA0XlI4E0Ql+6FLW2zZKK44BN4xjtKbiHsUxGHtJS
	xVx/uEZufq8Y2aMZNVEdsLCJrNqk2h99OY0BXifAg1ZnMGFDu78K6LdCqqg47Qcz71pXzh
	yCuxRrLiKaq+ybrTlzSwHBav5knFqIk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767669057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rphLXzNrhdKpB3e561pO1wVhwxpImphAdY8BacwJ2ws=;
	b=NAfrd4VO+SlASameqIeY1E9DMWlajehafQrzAClUsVCtjysTUybSUVqYhLDhqR9qbs+MB/
	lOWNEEKN3kBdEpxe/00coUX6ixqBaEJ63nEM8LQbdBKaCLDnw4a/O9e8oxRiUJX/wYJbBp
	GyASXGyHhgNfwBbF9Dm8n9zWFiJrMqc=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with SMTP id AQAAfwA3JVw1fVxpfyHoAg--.25076S2;
	Tue, 06 Jan 2026 11:10:45 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwCX7eozfVxpE1ARAA--.16517S3;
	Tue, 06 Jan 2026 11:10:45 +0800 (CST)
From: Cui Chao <cuichao1753@phytium.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>
Cc: Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Date: Tue,  6 Jan 2026 11:10:42 +0800
Message-Id: <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwCX7eozfVxpE1ARAA--.16517S3
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAHAGlcG0AAvgAEsS
X-Coremail-Antispam: 1Uk129KBjvJXoW7KrWxGr15JFykur17tFW5KFg_yoW8ZrWfpF
	4aqFWFgF4kJry7GFs2k3WUAw1xtFnYkF4YgFZrCwnxZ3WFqw1UZryavr1SvF1ktrWfCF1r
	XF4qy3WYvw18ZaDanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspam-User: 
X-Rspamd-Queue-Id: 40678C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: qg5beijegcszzwbtq4gybwu7iexbrkgq
X-HE-Tag: 1767669057-263460
X-HE-Meta: U2FsdGVkX19t0AjKOdpYck3JR0tqEres7xb/ih4Dzkw+so+D8KBDBk1Se95myYE8t7HKH3vy5D4F2T1RkfQXOcXvcrI10Xk5J8YpoGAFbNF0siLnJbZ4JRRsGeUBrOBb6caa+4nqzpCOVfoyEdtanvppRgAXSst6zHreXIfOhmWSyvE0Jy8uzXPVv4A31zQIMWeqLQTuUPY4wcuhd7m20uHPCQLXdsp9ei44hqkjgmztA66m4F/SLBq6QGlkiyuvZ9l5dNiJ+XwmUYHvEyBHSG2b1V48RCqeTK9szKQXDANypOj7Ei6ihi5zG/ltVSM7/3HoRia3khEBjoIqTboL/4pVZunaZZxEs4kx6rx50lyERW2kasehLF/UMQZxvl4fH1rp6SJYDoeE1e05d74bL975ZFZI2HTTCYageyJTsNggAIVZbvH+THeQEKnwvjZFS02GOX0O4+0DVjYMs1trBU5iN08GNwGdXkbiIls/V7Yh6v286Ron0zwxz8cQY7KFZZ7eBme2Jcu4Y9K4usZtF1mC26uFqzyeZ5vpyndZwQ9DbJ+Hq6sTsVTlzYAK5NIuDcorQ1aZ4kAiy6uxE+Z/5/Q/syVrjYSs/CGSUdKtiCzXR7M47ePcUBGRrf1IrAL9GuJJbGq2FKSRUrFvF8fYwqyEDaVCer73I1dqxrNKh2bFiZIZZrORdiutYXdTspBh2IIuj6xh2DSWW+34k0eHh80Iab9uxKIcRH7TwSfq+V5G870JdDKvmJouYoW1mVWVJYwHDyyDgFfmr8jyjCK0nUCkLaEJfUCuV9XSficnV/AIV6//z8zqGSfH0Qd7Vga+Fn4bswwEpMIyEZWHx+Huaz3HR3mDBFmZ3LBUnsgJVySwjrr96o9DbzMjP0ooL49D2fEe50yrJke0wQlmWweFaiiKnLit5xzYYgmQsmw6uSvg9YF4IZgvKF6CPp6Je2GUXEBAS5UJjw0l6h6kITn
 1/00FZ0u
 MVPpcC5oqA01YERH+4WRrD89KxFYI4JmBAnQE6YMVY3LBCSnnN475HzcP68gqnHmyqLJO4XM87+jzW4AHk1gdPwVXdgGdGLVC37dPZJO71jnQSfDnvApbWfM/Pg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In some physical memory layout designs, the address space of CFMW
resides between multiple segments of system memory belonging to
the same NUMA node. In numa_cleanup_meminfo, these multiple segments
of system memory are merged into a larger numa_memblk. When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

Example memory layout:

Physical address space:
    0x00000000 - 0x1FFFFFFF  System RAM (node0)
    0x20000000 - 0x2FFFFFFF  CXL CFMW (node2)
    0x40000000 - 0x5FFFFFFF  System RAM (node0)
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

After numa_cleanup_meminfo, the two node0 segments are merged into one:
    0x00000000 - 0x5FFFFFFF  System RAM (node0) // CFMW is inside the range
    0x60000000 - 0x7FFFFFFF  System RAM (node1)

So the CFMW (0x20000000-0x2FFFFFFF) will be incorrectly assigned to node0.

To address this scenario, accurately identifying the correct NUMA node
can be achieved by checking whether the region belongs to both
numa_meminfo and numa_reserved_meminfo.

Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
---
 mm/numa_memblks.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 5b009a9cd8b4..e91908ed8661 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -568,15 +568,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
 	 * Prefer online nodes, but if reserved memory might be
 	 * hot-added continue the search with reserved ranges.
 	 */
-	if (nid != NUMA_NO_NODE)
+	if (nid != NUMA_NO_NODE && reserved_nid == NUMA_NO_NODE)
 		return nid;
 
-	return meminfo_to_nid(&numa_reserved_meminfo, start);
+	return reserved_nid;
 }
 EXPORT_SYMBOL_GPL(phys_to_target_node);
 
-- 
2.33.0


