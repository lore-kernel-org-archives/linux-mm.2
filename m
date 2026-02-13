Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42FFEF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 06:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7BA6B0089; Fri, 13 Feb 2026 01:04:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BFA6B008A; Fri, 13 Feb 2026 01:04:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7ED76B0092; Fri, 13 Feb 2026 01:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5D9F6B0089
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 01:04:04 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB14F1B3F4A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:04:03 +0000 (UTC)
X-FDA: 84438392766.27.F653C06
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2B276100003
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:04:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770962642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34xgZSWI3hesuGzjmTMGala9a1kYAx47Rf/bSAC3YAc=;
	b=1NYzqwndaJ1tEhsGp9bRc4zNYN7wf2uK+eSHW4sEDplad4hVu/AwUr+DzxT8dGlfWQ/HsG
	I8M3vixY/ecQrzX5LaxXwGddgkoPfh7Ao8G/K49/BfYXrqC4BBiQgyixAJO8ZakI/3Qven
	1aE3yxVbllIQa2HxQ8Z1LFxbyLI6o0g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770962642; a=rsa-sha256;
	cv=none;
	b=N0TNvTXRTuMMGVjSmPHV+vA3QxVFiPKOBI5CZtT7TqtHmB0K7zH1y+O3cgjFKW2DKwWau9
	uJXtcKMwRPQgFnrqtaJ1hxjybw1Cv/N0OkIi+ESiAMyjOLxg1XuDluUaAEE2ndPH2fYgq/
	ccOUGELVoidp+SrFPZ7e1ZpoUEVjfrU=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwA3UqjNvo5pwsgZBw--.1397S2;
	Fri, 13 Feb 2026 14:03:57 +0800 (CST)
Received: from localhost.localdomain (unknown [218.76.62.144])
	by mail (Coremail) with SMTP id AQAAfwAHXuvEvo5pWw0bAA--.32545S3;
	Fri, 13 Feb 2026 14:03:49 +0800 (CST)
From: Cui Chao <cuichao1753@phytium.com.cn>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Mike Rapoport <rppt@kernel.org>,
	Wang Yinfeng <wangyinfeng@phytium.com.cn>,
	dan.j.williams@intel.com,
	Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>,
	Gregory Price <gourry@gourry.net>,
	David Hildenbrand <david@kernel.org>,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	qemu-devel@nongnu.org,
	stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [PATCH v4 1/1] mm: numa_memblks: Identify the accurate NUMA ID of CFMW
Date: Fri, 13 Feb 2026 14:03:47 +0800
Message-Id: <20260213060347.2389818-2-cuichao1753@phytium.com.cn>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260213060347.2389818-1-cuichao1753@phytium.com.cn>
References: <20260213060347.2389818-1-cuichao1753@phytium.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:AQAAfwAHXuvEvo5pWw0bAA--.32545S3
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAFAGmONAkAtAAEsu
X-Coremail-Antispam: 1Uk129KBjvJXoWxCr4rGryDtrWxuFyDAw43ZFb_yoW5CFW5pa
	1agFZYgF4kJryxGFs7u3WUAw1IqFnYkF45GFZrCwnxZa1Ygw1Uuryavr1FvFn7tryfCF1r
	XF4qy3WYvw1UZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B276100003
X-Stat-Signature: wq8hc941973nfhm6j1mj7wx81eksq758
X-Rspam-User: 
X-HE-Tag: 1770962642-602202
X-HE-Meta: U2FsdGVkX18OOnbVu8DuqY1TDFqClNn5agKhblA4AOWajaRIrgEMrAZscKqLzBHbC/NYGSlQNBU2wuGf/PERnCbd5tCT8dUSTh0nEmmhhg8orFJs0FoeBVh9Q33yzDlAbltWv3Y1+x01Dy31bfWYF3oOKARlj/r6Fjcb25zwPSNi0u5eezS+O6ujqm0rPjp13+YBOUakTXL4W/S9maYIWTmXycEtQ4sEplWofrZ8rIf9+/081LJB1TVhqucyUKAFYrmgEYo3uiMWDDXcPb80l2w/YgqgvI1S+OmbwbfzY4dKVjAXhGoHQFPub1HeE1JWWBXqhr66hFhY85ikOYzi7Fl22melZR9unO+TCmCIUKY50rB+4QSLouuADrFUPyP4m7v6P0Gq6/CfqAsdUm0r8gd+jprWQihslUERSd9Pid3Q/U+HY3niRZuL/13BbpmjXm5x6qCX6pAxh/8SZDnHz3qUxcn2g9nedXNb3q/l5TWXmHX5xPxpdfdLl7Z/AHjdic4BuntPtAYuejmUNik0hO3Fu+/WDX3MIf8jXK7YxBFFXRJ3Zeoj3uUJc5UI50Zye2zhs6Sj7lH6Dovit9pwOJ48rQqsGEJUMK1dQEGhk+6+UCgCkcGI24FTslXsmtMF70NkhyYHR5bUui4/PLBW1WLakdo+lVvAHElD0wKiF594IR/M7LCwFJGUrDesaacTdXVI57eXa0yuiUL3HiwOimEZKrWlRn0GmzVYrhFQa9EKFclV+6isHT/GRND8Kjvgi0ufYL+9t4R4YRxc7KE0oMIqb/iC124tF087HJ2jsF9XpVZoz8ScIpsepVUpUKSUbKAmPypEoJx1nhlZhBD8GM0bls2K62+uMxx71QB0F6bQamhaIZpY5M4UHy58J9X+V/u1luM4tOeoXiyAP9yKy8sX0QE9GZBRPMERoDHIRUpM/i3yOyQcwdXQRIOBfACvEL7xgs46w0cAQS7oSsl
 GyzaLv6B
 WZSislSKQvS8V0Gr3X5om5JsRJbQ46mlOVIPYPnI0kt7PmJSUSoZi28ZNdQVrqZG23RTEzotQoveIH9lHbQQU+Whh6fMnkAWmM7Ax4EV1+5nH2FLL2DQwYIzECINCrw+LCDwL6hbazXByuRUgCzZxgeFMsb3H0g5gduLriz/CsqshmSIQkHjUYbyg/AQRettU57D6Pm6vzTB+Q9xrj0E8RQfurxDYHaw4QRxwADXnZ0gH15ggjF60KmBD2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In some physical memory layout designs, the address space of CFMW (CXL
Fixed Memory Window) resides between multiple segments of system memory
belonging to the same NUMA node. In numa_cleanup_meminfo, these multiple
segments of system memory are merged into a larger numa_memblk. When
identifying which NUMA node the CFMW belongs to, it may be incorrectly
assigned to the NUMA node of the merged system memory.

When a CXL RAM region is created in userspace, the memory capacity of
the newly created region is not added to the CFMW-dedicated NUMA node.
Instead, it is accumulated into an existing NUMA node (e.g., NUMA0
containing RAM). This makes it impossible to clearly distinguish
between the two types of memory, which may affect memory-tiering
applications.

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

While this issue is only observed in a QEMU configuration, and no known
end users are impacted by this problem, it is likely that some firmware
implementation is leaving memory map holes in a CXL Fixed Memory Window.
CXL hotplug depends on mapping free window capacity, and it seems to be
only a coincidence to have not hit this problem yet.

Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Signed-off-by: Cui Chao <cuichao1753@phytium.com.cn>
Cc: <stable@vger.kernel.org>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 mm/numa_memblks.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 5b009a9cd8b4..0892d532908c 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -568,15 +568,16 @@ static int meminfo_to_nid(struct numa_meminfo *mi, u64 start)
 int phys_to_target_node(u64 start)
 {
 	int nid = meminfo_to_nid(&numa_meminfo, start);
+	int reserved_nid = meminfo_to_nid(&numa_reserved_meminfo, start);
 
 	/*
-	 * Prefer online nodes, but if reserved memory might be
-	 * hot-added continue the search with reserved ranges.
+	 * Prefer online nodes unless the address is also described
+	 * by reserved ranges, in which case use the reserved nid.
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


