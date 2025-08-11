Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F8C1C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 03:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80FA46B00DB; Sun, 10 Aug 2025 23:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7996C6B00DC; Sun, 10 Aug 2025 23:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688376B00DD; Sun, 10 Aug 2025 23:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 543456B00DB
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 23:18:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2C13828E4
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:18:47 +0000 (UTC)
X-FDA: 83763019494.11.4068443
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id C41651C0008
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:18:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754882326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=qWN5qF37GtUeb8p1Qlb7ZNULK7UpEdaM5sl3hEOz93w=;
	b=KXxyq8Foj0d9lEUQIoHE5zutzwzgB/+dP5wgUyDq5HHbshgs1bzFYKgMnYJF3UV4i75yb+
	I3gOoWJNtmm7c+gOxc4bl3yYm5COafL71axXg2RO5dzKUI1AaWiRtWAyH8elXH9SWe8FxA
	r3WagjR/aOHm53ITX/3MDzyQ9jn3SAc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754882326; a=rsa-sha256;
	cv=none;
	b=eAf+dzvMxHhTwsRkpExiMroPvhvcCnjLXmUUr9D5RmWEE/T6eQvlaG+ncTt9k0ViJLdAvT
	0XB03qA0M1/5BPqigEBDXB2K7XNLjuAtToSH3IBy9vJVZg6bzk9WRWBFst2XFj6hAfw0xD
	blu/ENTQRzBvmaNRONkQNOxRSjOMBeg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c0fqx5qX2zLpqm;
	Mon, 11 Aug 2025 11:14:21 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id A0FED1402DB;
	Mon, 11 Aug 2025 11:18:40 +0800 (CST)
Received: from huawei.com (10.175.113.32) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 11 Aug
 2025 11:18:39 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v2] mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed page
Date: Mon, 11 Aug 2025 12:33:23 +0800
Message-ID: <20250811043323.899130-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Queue-Id: C41651C0008
X-Stat-Signature: brkbut3wrpnstx48epwn7zpit11d7d6i
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754882324-503744
X-HE-Meta: U2FsdGVkX18h5V3vsKhVFcB5Mfqa/2MKUyl5BTGDV6SJ2pbChxvRyCSezAFg4stnUoFSiPBwEw8bQgBDY1kHmw8lgZ/3Ui0RKVe3g9hg+tNUhyvClpIG0Q59Nwh+ao1Bf2pRxD7mrnxGg+FHa9BjfUdarYtWxk0RI76gMB4E8VIdyGmAhDnKIgFBYeJbfj2rsLFwcgnHuMd7i2IIeJm3tz+UnRdhu23ilEB22NP9pVCk+fTtma5MxlqvV9BZOEYDBY+DeENuwWCCIGEvBYg47DBwqXf+nCqNx2YU1lwed5QKnlNpoUaMbrP+usgoz5H+MgUNqbyeb5jcf66/PXuK6bS2W8x4g3/NUdNHCKirsx4GjGLLl/lRd6av//d5/6VFOqjj0U5iawstEhmNH3YrQeAuqGCu5cTWQiMtsxHHrkIU0Ih+rieImLGutnwAgriLCLsMa8nVNWZa0FTQXoDlbHpVT+vBkLc3xwjeKK1UT53HaPlvk7u+wxlU14ec+XcVjTbMQfpHeKma/SStq7rd0S7XzDQDP02mxHrJB4/O2hL2dL006BS2UHmSYKOsxUuWcjGS3pRqfj8ACcAq7U3Tz+Tfv1QrJifxdCQHwEm5MU7WzpH4Rf1pxbb9+2060W25l7o1D2KFwY2tBvDU2s7APGqp5nu4EX7zaFmPfVo8/QyBxIYI6dv3kNWdCTqeTu+kYFqpf8IA1+8MK2ak/i0L5CS0j07oejqFkFawW8U3HNtEmV/MoNUU9yCwg7YjNgJS/w2hPeBDi/QGRi7dXuvFkiHnj8/E6s0Ww6Viu/XRDJtSmMOv0or4TzxPOZci/KctrAxKk7/5e9ekCh7lIi2U1EkER17CL3YDQgC7LNr5VNCy6ZZNkO5TqW5n/LyuDpP911RZ7Ekgn0jtuvhjWZlfmbGhHWtIOXijsQNhSU9U+VMuz6G1+nxWtyp1CoWIKwGYfcbGqRwYPN09WPdsLtC
 Lcv2vQ/4
 bj4QQMrrQFneTd0HeA+9w4ZNy0LMtNmBvz7iT/1LyufvIGr0Elfnja2+oK9y5OSog9aGmgI29pTZRU5tjty+j9tuJg3oe9+Ch0Y1LLu6tcHmYX80Td8bFnhZSpTdSXQIQz+nmS0G5BAHnsqykrgUKbdErREz90J8Nq7NHMHdAah0+xsBozT+9cMzhD/2dNcznnv2regzOXmC0ZidhydBoScm88dHnskQDJInOKrrKqe4l9D5jxJtYslcfFbP76rHTOpycl5Kld+K5tFyAwprjkFIoLWp49OuznGwc0HckqgDWehJwJbDp/++X/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory_failure() is called for a already hwpoisoned pfn backed with
struct page, kill_accessing_process() will conditionally send a SIGBUS to
the current (triggering) process if it maps the page.

However, in case the page is not ordinarily mapped, but was mapped through
remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
even though hwpoison_pte_range() would be prepared to handle it, because
walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
a result, walk_page_range() will return 0, assuming "not mapped" and SIGBUS
will be skipped. The user task will trigger UCE infinitely because it will
not receive a SIGBUS on access and simply retry.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

To fix it, add .test_walk callback for hwpoison_walk_ops to process
VM_PFNMAP VMAs too.

Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
Changelog since v1:
 * update patch description, suggested by David Hildenbrand 

 mm/memory-failure.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e2e685b971bb..fa6a8f2cdebc 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
 #define hwpoison_hugetlb_range	NULL
 #endif
 
+static int hwpoison_test_walk(unsigned long start, unsigned long end,
+			     struct mm_walk *walk)
+{
+	return 0;
+}
+
 static const struct mm_walk_ops hwpoison_walk_ops = {
 	.pmd_entry = hwpoison_pte_range,
 	.hugetlb_entry = hwpoison_hugetlb_range,
+	.test_walk = hwpoison_test_walk,
 	.walk_lock = PGWALK_RDLOCK,
 };
 
-- 
2.34.1


