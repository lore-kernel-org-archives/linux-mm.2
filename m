Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF55CC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 02:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 200556B0098; Tue,  5 Aug 2025 22:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B10A6B009A; Tue,  5 Aug 2025 22:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE256B00A8; Tue,  5 Aug 2025 22:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0EF36B0098
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 22:07:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DE0980F2C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:07:06 +0000 (UTC)
X-FDA: 83744694852.21.35E7AB4
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9B2CD1C0009
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 02:07:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754446024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=62uuUfP0Q6obozZGbP4gr8AJs+UqT2RwpM6ejBYgRD0=;
	b=TRTIuU6bcM6PfLbgB23HmnCxjl3BmlEM9x+zlE7jhdzP+oVAA5nYgo91vfZO99NhrORvDA
	hdqrOGGkPIM1dvU03ksskAj4ksbVpl4NsonvNGJQVj+KUSAwZMg1nLdONhXJz8gX+P+QHd
	NMA5EJWr8vYVG8FBXwSF0/nFzqsdgWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754446024; a=rsa-sha256;
	cv=none;
	b=xFcbj2v+c8XSYSNjCnwdPYUv0hiV6sPDYO3pfBkZzuTvU+rUADbH9ObUBYqA5k9TzxPsNI
	TfIG7CRT3to11olAit9OQamm0SyuUsPtxdkrg+AShEpQgfwKXCERVklgR9pYKQfDS4ELV4
	wijSXGiguQWlFps7xBb+EWMjB+zEsXY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bxYTY6JFsz2Cg6K;
	Wed,  6 Aug 2025 10:02:41 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 167D61402A5;
	Wed,  6 Aug 2025 10:06:57 +0800 (CST)
Received: from huawei.com (10.175.124.71) by kwepemo200002.china.huawei.com
 (7.202.195.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 6 Aug
 2025 10:06:56 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>, <xueshuai@linux.alibaba.com>,
	<david@redhat.com>, <ziy@nvidia.com>, <osalvador@suse.de>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [PATCH] mm/memory-failure: fix infinite UCE for VM_PFNMAP pfn
Date: Wed, 6 Aug 2025 10:05:20 +0800
Message-ID: <20250806020520.631203-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.71]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Stat-Signature: 3hop9333ytaq5k33e1oeeosdbdm658gu
X-Rspamd-Queue-Id: 9B2CD1C0009
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754446023-385844
X-HE-Meta: U2FsdGVkX1+FjQylgNMwILXq8yKyiuQCoJ4kKOi/mnbvLXC0kNnls29pszU5NbKkK7EguqPZRXq6+HyzTo8reCJimo0Ds0dIML+v6b3StUHOI5uuRgZVwDW3wl7MZOsp2Z7StnAGdEMdXma8CdJiwltMeDP3BEf43XYDOQMz8fMY2Sqb4TBwELnZZIkNA1btOzjBYlxj7ca5fyJOnIN9A7/bUrIa4sBFo9G9tPCIEcoxboZzN0z8uj7gT05ABbufoKQJok9F6lFUziiI8pw06TM5bA8IpQX21xlP98Di3RAGMGPv5yRFkZ6E37/w7TvquESv6exmekVIYLuwalIcTIGADNRqMX9QTwzvJfJOD1R8iIdGW/TmHb0C0f5i0f4sl7vCAue0b+00tGNrmLcxW1s17Mg63BWISJkOfY/YZvAz/tmRTRo5DOX+TqGHwJx6sgc6i/oqY4j5I02G1TMTTfqdb6DuMhrn3I0A2tjvreyQ1IN4fv8LHnqwLHvd0KxVJafJjrs51qZW82EZkWKXS/ATznneS2oqmBff5RNMTGbGClCOSR0wFIvD9YOqgPBTPfnDp82RVrcx2zyJC/RjHXFtUbvUcpxu1vmm7DmDWlz03y4AxjJuMJ587z7X/D0BE5RgHSJiW7s230ssuYtJG6+SBae//NX7FVmF+ss/jPNNioN08aPPVFOsqmo8404QykTPCbBDcFIqzW3o/fA9/eZnD4FCjhfHpIAUM33yWUwR+4PIgE5NyGDmyuK9LTj1SjIg8Uoz7f4Epohq2KDt7lw6JGdqG59w+4XmOppuSCtP2+vPfUYYA94qJBNHaU7Lr8tvliKCZxU1/CMN+d5ePUCHmM/TDVecBn/+3FqZaJyCKBN3YulCRgkRW9CPYARDLRi0EuhWkq7Q/CLieMgSo/NzlRKNIy64CTDmQwrtTtMGsAy/rC+cgZGDRrUHztT/DuA8KAklrDFdIRKJGY4
 nNgLFj0P
 GGuygi22gSQN//lRUxUHHllhxV2HDj7ttms4bSdTcv5NN1wDDIczkvb2PFI93oSaiNZYv4Gjj7pnxhl7TyKYyfKlMIibizS4uGLeUKizdsxCjVpunqDS+M2McTHt9JAnjeXFGwtn2q2rP6k1D2X6LYt23SsuAUcJbBdfWdPvc5H5htgAEfajXppbP2JbhmwipZiIlm0IrzE1TH0iq3nYDuUzCnkMexH6hGoEnVoJyOMhlCZAfUZpYvh9sJ5DguRNiFQ2hgoB8Cn9GpHZfyyl7KSWK+yQubtT8hUnSeMUlV/VBI4F2bAHPJ8r36w==
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
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/memory-failure.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index b91a33fb6c69..66b0c359d447 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -847,9 +847,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
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
2.43.0


