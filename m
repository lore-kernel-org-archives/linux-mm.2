Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED05FCA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 10:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63BD2900244; Fri, 15 Aug 2025 06:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6141B8E0002; Fri, 15 Aug 2025 06:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5502C900244; Fri, 15 Aug 2025 06:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 42A708E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 06:36:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D66B1C08DC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:36:56 +0000 (UTC)
X-FDA: 83778638832.30.2A4E159
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf27.hostedemail.com (Postfix) with ESMTP id E392040002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:36:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755254215; a=rsa-sha256;
	cv=none;
	b=f53CUSecZlbfeBCfnpiKW2JqojOOAS0p5UpIbrPwaj1PRGlBxm2eM2I9U4ZUyC/u85wQvw
	28Iqls6RiAHJ868TO7hh6PSa8GfUiD0AYLsvA8qOvdshcUHmLUg3wJirqjDa+R6f+SEwH6
	aqQ/Im1n3PHzxWq/gJjR9mk4XO+biAY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755254215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=IP/U6GaXm2MkrlLk3nso8ycNLY7a6Qn0CLNWxUJfpAo=;
	b=KU+2nG5lwG2GsCTxHR/0Dg1jpFR5UtJT+laZBHMLRL9YW9s3FqgiiXSa5GauuPJJjtfhkX
	1NVs4EjE+UVZC/4mt1oQOcUDds44Da2V1Qlmrgw5sZbxoG03kLFCQkrhHusR5Ao1K7zYeF
	ifSUyNB8FFyYCF3xUE8ntec4IBMnNSg=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c3JMZ0cCFzdcD4;
	Fri, 15 Aug 2025 18:32:26 +0800 (CST)
Received: from kwepemo100001.china.huawei.com (unknown [7.202.195.173])
	by mail.maildlp.com (Postfix) with ESMTPS id CEB8E1800B2;
	Fri, 15 Aug 2025 18:36:46 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemo100001.china.huawei.com
 (7.202.195.173) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 15 Aug
 2025 18:36:35 +0800
From: Yin Tirui <yintirui@huawei.com>
To: <akpm@linux-foundation.org>, <rppt@kernel.org>, <david@redhat.com>,
	<Jonathan.Cameron@huawei.com>, <dan.j.williams@intel.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
CC: <yintirui@huawei.com>, <chenjun102@huawei.com>,
	<wangkefeng.wang@huawei.com>
Subject: [PATCH] mm/numa: fix uninitialized memory nodes causing kernel panic
Date: Fri, 15 Aug 2025 18:30:40 +0800
Message-ID: <20250815103040.511627-1-yintirui@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo100001.china.huawei.com (7.202.195.173)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E392040002
X-Stat-Signature: wxoqwkbgo15wfttzgcuhbiftpfe8m7c9
X-Rspam-User: 
X-HE-Tag: 1755254213-964478
X-HE-Meta: U2FsdGVkX18xiLWBCGvPC5fCySmY+U6nZeZbOxirc/bLFKq9SXKNCbCDUONcoNog2ClUPBIvlXDiDQmBOWrFPmRtpLibshUrYowaqz7AEUbikpJSkjyHXwnSUVsdFpkDplTTt5jK/YHBaSJP3JlbDtpm0lgafeAwSUjMdY7CaIHzYv0D0+NM2ridN5D9swkHs27w58uAX2VK/4t51ZO7fCaMRf6y2PycWonQxa5yKWaiqbfmrAULdPwrl0F0dKmQ+NlzG9Q/4GYjtJ3Vbc7USvhKpYhoFG4PJ93yOX8SZEvC2j5wyeZCN7gXj/FPlxFu0bWzqdJmK1m0dGiZWvwXe0rnQN41W+IWxuwt8owoI5YcR7Lbu7FR5AKdCUL0814Sg7W2WNmkN3H8N3Wr3FvZQsQBk73lD3HiNv71783cnk3TKAHwEGZLdOc9H/M2DewzBWF0IXTchyoMBvFNZYbMLrzGNYY3wa79H4RPVbwttqVNCb50IleeEftY1dFYkymTaWEwerttKM9Cn3o7/rn0VJo7d4AhwY75j4FUtptyvtpzhek2D8FF+KaepvsZb0Xk6ib6iXRKDKyDUhG3/KtztAEY5nCh+MouGXapYgv5iuBprDnrUaRCJ+kvQgC9cTxPOa3/1MW1S3zr8dZdMpm2bATvcyMDf6bmclmxL96JHg+u/ymkISjQ8v2PWsAxfQTD3ZvCyZ69xkgx+f82u4MErU+IsMXooNqBrzsaokOsYjOwVEfRnGQvYx7ZIk2QHE30WVfYGPygvyEb7BZa/Arn6/YFbG7yqDiBx7E6EouI7qfyI9YQGoPu5YWSdQcWi8AVRqQeCnjtFnnTOfS3MlBDHr1JJwwtJ6cVO2Mqzlq9riZcuWYd66oMagO3NYsONxBlZ5MqO9A5NRqV4bPlm5ShsSG3AjzcUnwOww166KAJKZ3q2xJjUli71jF/1c2ona+I5RLGZrre31BKXT4Dwzt
 PhICeY02
 0gr8LFJx47eZ5mD3PHmAyMDNpO61c7aaAgIOMIbmY9wJZFnOfVdoEf49C7iWo6qRAA5amUr5VXCLm9xgOrXUVNFRx7K+wRhShEanl/6dn7w6njnXqBXCQHNP2tphJ8sH4kWPTbBbnN/knd9riipcYgDvTlGx+/nJaBM4JRcJwakiqSNnIdgcHLPI8Th+AzZ2C7d6+DnM80YDcsDaTlmpHvZgsRrRwT6cIb3U3Pjh2t/JHnHJXBErD5bMZJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the number of CPUs is fewer than the number of memory nodes,
some memory nodes may not be properly initialized because they are
not added to numa_nodes_parsed during memory parsing.

In of_numa_parse_memory_nodes(), after successfully adding a memory
block via numa_add_memblk(), the corresponding node ID should be
marked as parsed. However, the current implementation in numa_add_memblk()
only adds the memory block to numa_meminfo but fails to update
numa_nodes_parsed, leaving some nodes uninitialized.

During boot in a QEMU-emulated ARM64 NUMA environment, the kernel
panics when free_area_init() attempts to access NODE_DATA() for
memory nodes that were uninitialized.

[    0.000000] Call trace:
[    0.000000]  free_area_init+0x620/0x106c (P)
[    0.000000]  bootmem_init+0x110/0x1dc
[    0.000000]  setup_arch+0x278/0x60c
[    0.000000]  start_kernel+0x70/0x748
[    0.000000]  __primary_switched+0x88/0x90

Cc: stable@vger.kernel.org
Fixes: 87482708210f ("mm: introduce numa_memblks")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
---
 mm/numa_memblks.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 541a99c4071a..1dfe434e71b5 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -197,7 +197,13 @@ static void __init numa_move_tail_memblk(struct numa_meminfo *dst, int idx,
  */
 int __init numa_add_memblk(int nid, u64 start, u64 end)
 {
-	return numa_add_memblk_to(nid, start, end, &numa_meminfo);
+	int ret;
+
+	ret = numa_add_memblk_to(nid, start, end, &numa_meminfo);
+	if (!ret)
+		node_set(nid, numa_nodes_parsed);
+
+	return ret;
 }
 
 /**
-- 
2.43.0


