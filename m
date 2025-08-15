Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA834CA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 07:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC7F90020F; Fri, 15 Aug 2025 03:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35CDE8E0002; Fri, 15 Aug 2025 03:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299A490020F; Fri, 15 Aug 2025 03:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9968E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:45:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0CA7138B1E
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:45:44 +0000 (UTC)
X-FDA: 83778207408.24.88108AE
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf18.hostedemail.com (Postfix) with ESMTP id 226E61C0003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:45:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755243942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=/mTpbTezYQcV1ejYWOOR9the09fs2SFusqcq5EzODNw=;
	b=JWo6MBKA0HLGMgFGE6/nnDJTDUT0R2ijJwUfQR1IWGw8Y1eFe1+x+y8uhl28wVWIA59vZI
	rn2tqAOcb4GReDiG5buXpOEORjhsg2JNKRtAE/XlzzBvUhHG2XHzd7b+ZTKZd9b3a6GbNr
	UCmFVOdBxvkrRQQENAY3JANXUQKfILM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755243942; a=rsa-sha256;
	cv=none;
	b=rOFC6q68OknUnBm4Zf9XvVS/bG6Dnw24FnzJB8G+ctbyRccIqoA3i2EvFdQUk5IiJG4RIJ
	3JjgR7YAVYEoWc+ZowHrLwxfG3SU2Eid5N8HI35Ub/VCnHF19kLKTkuu54e0fJgjaADXA+
	tvTQcA7Rf8F7VZN2kBIRQAvXJrznUD4=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c3Ddv3pSdztTFG;
	Fri, 15 Aug 2025 15:44:35 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D342180B58;
	Fri, 15 Aug 2025 15:45:35 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 15 Aug
 2025 15:45:34 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<jane.chu@oracle.com>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH v3] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
Date: Fri, 15 Aug 2025 15:32:09 +0800
Message-ID: <20250815073209.1984582-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Stat-Signature: 3izxai8g1z9pezeyi8zdn7h6seck66nr
X-Rspam-User: 
X-Rspamd-Queue-Id: 226E61C0003
X-Rspamd-Server: rspam05
X-HE-Tag: 1755243940-155802
X-HE-Meta: U2FsdGVkX187SGlSd9kPzW1bdwSye3jki9eKmvFIAplRSVh4lK8JK4XsAFlh3m5o+iwc+M0JxRXRSZ2Z8YgQ4LJNI3HF9kEap6MnCQKC6BqREAQCizQocEqzziUYxARK5FHbxYR4Vp79c6LeF8Zh0eQbzVZ+yrGTZgohIxyahegvEZCSEdPcbzmZDHS05bqBr2Zn1Wq0j4CI7IjMQI/xs5ZbA9Jp6+Ak0GRkdj0ALZPJCgVlOnZHsifYmUKz++JkiUnGbiMMs67ZVeWPEigE6vfJfAOZHJO40pNLUpDjP6hnDS3iimB04io37kkZBUzHZPWmj4ZClv+IAjawPnSdkPS8Gzg/6ZHlfmXjTAknpSqSqTCxmHpzC0KbSJ9B+OfoLPAqGVS//dziRkU8DiompJoTs1bYvWG60xQ3JEWSuEii4OXpziihscmgHXA5tGmKGyhWCuJW3Srprti3pj1Rq7QL9vtCFaiuc5AhfCCQpfJRrZGPmPhaVkNjWSDb3/4krer5LFoNQg4uxR6JHXdDd3wy16BNcz7QBZijE1Mt0KG+kskLcu34Zrym8dalDjpePFYQ8Q/Jyr7NRa2lG6QrNvw4kaC5ZZk9tMbrtmapAH0lvf17vcf2fqNA7jY9ZKRUUoVWb2rkWmNbE8OC3i8nM1j8fU5buGu4WlGIArJqRxQk2pvfdDYuqmhb6Aqwu+LfSey1Jnkj8MZYfGu8KKwer/zCEb+uofJVd4d4wuiN9CyRoo05lXWL7noY0vxOT+uv24aWRfasQcCqFmkYpVrOsPb5l7JfoVv3xAZ/7webQOPu3weGnIsANTu93N6SeOrnNdi64KCtQWtCdJEP0lFheQcCJDaMx87E+lM8TTFrvVZMbM7bbmgqk2qS9fV2SiWpJbAKpIaJkoIouHaImTXa3I/oA94etOeV9w3ZIYOBTiGjZTv4lULOX9WrLg5MUikI8JJm+oGlojOGFg8nMTA
 lsCGi1ZW
 3UAq2KiHXIj7yC3Hfb9G+TyzYAC5vBVYfDV/q/ubUMZ7ur5WwN5Q0GPhKQi3HVTmOmC7PYhlo71/UcCJu+GChv7RXftCREm2NpbrPhyYGNvdOxRmfWQDILjCFXg+P33hUmf5aDJd8T6lBtkudB4+U31aEDnfsRUhuWNSS6FCWUIhbdXgQzhrq6SSkwgfhORAUSbB37nEHX8y05s2VlqhtInnmeeyS0Y91MMNMRhUWGJTm1FSddfBy1U7LFUsq/cQ5Y9R+jlmXEmMn7mZpFcPOA2kZTHvJzRiIK43qnRGC0VF44On99r6rkvXu/XLmpfA7zQw3fg2tpfl0m5z0JXAPs8TMBj+01NAaXCv2fb8tL/CjXspECHhqW8CM9lLAc5KNj7sm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory_failure() is called for a already hwpoisoned pfn,
kill_accessing_process() will be called to kill current task. However, if
the vma of the accessing vaddr is VM_PFNMAP, walk_page_range() will skip
the vma in walk_page_test() and return 0.

Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
with recovered clean pages"), kill_accessing_process() will return EFAULT.
For x86, the current task will be killed in kill_me_maybe().

However, after this commit, kill_accessing_process() simplies return 0,
that means UCE is handled properly, but it doesn't actually. In such case,
the user task will trigger UCE infinitely.

To fix it, add .test_walk callback for hwpoison_walk_ops to scan all vmas.

Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---

Changelog since v2:
 * add a comment and cc stable

Changelog since v1:
 * update patch description, suggested by David Hildenbrand 

 mm/memory-failure.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e2e685b971bb..fc30ca4804bf 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -853,9 +853,17 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
 #define hwpoison_hugetlb_range	NULL
 #endif
 
+static int hwpoison_test_walk(unsigned long start, unsigned long end,
+			     struct mm_walk *walk)
+{
+	/* We also want to consider pages mapped into VM_PFNMAP. */
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
2.43.0


