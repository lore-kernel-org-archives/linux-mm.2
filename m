Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 235C8CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 10:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0391C6B008C; Fri, 16 Oct 2026 06:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0107F6B0092; Fri, 16 Oct 2026 06:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41696B0095; Fri, 16 Oct 2026 06:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD5696B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:08:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B51BC1A0355
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:12 +0000 (UTC)
X-FDA: 85328064024.03.2BF8DB0
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9DDC54000A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:08:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NhIIpwsk;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792145291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CB1vyvwnmys5mHDIckEZtppUuHoCwSvLhJ8lsey9AVE=;
	b=DT1iotEUxlSq8gg/5wFDwfVC2zqkKxdZQctlPOERmZwFWgIOjwXRZu1e9or3jEx1l7sw62
	TRGZ6tT0PTIQAIcpOEFDS2mGG6FgYYA8NWRgmQX84dJzUSVQa1CZaXQj7zRqb6l9yPRh+o
	kAgFW/+6kECJJe6dhRwUvypnYJZBJWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792145291;
	b=MEXYIQIgtsuNpJsbEnJECe72g37eS6+WxsgAnw8sCZ/KyqXLap3rmXs1eqGmOdYtEo2AEC
	Ent880Kz5RN2LJLvD9J8FAclEHuhkMZ72pKRrBVPr0hZ70YuOZeMREaBQOqLupEV01xTS0
	jHsQt1pZxYWdIAzCObrsl501hhivllk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NhIIpwsk;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zWmMzkJXbq05ST8YsgpruScX1WCy110Uh4KRGzMR+c8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792145289; v=1; x=1792750089;
 b=NhIIpwskqSrQgAD2Bml5u+VTKEadhf8jqaIIlxOw8xln0pXXqCHQYYgiN/f/1qeQ7zUbfYjv
 ixnhM3xv4Ric13V1kHjnceP6mJGMIfuTob0h9UxzsKEC3n6HFdOYzgjapC9ktv2iDC7gW1KHdvR
 nideshuLlUDLNG0YQ6Nm6bQw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 203aed561e3bbeda;
	Fri, 16 Oct 2026 10:08:09 +0000
X-Mizu-Trace-ID: 203aed561e3bbeda
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH 1/5] mm: hugetlb: add explicit page size to hugetlb_cma
Date: Fri, 16 Oct 2026 18:07:32 +0800
Message-ID: <fd905db7e48354ad139cc68b66fe776cd7f2dd8c.1792136742.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792136742.git.zhengqi.arch@bytedance.com>
References: <cover.1792136742.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9DDC54000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: c7qfuhytnz4xm9p61oi6ouf3wj419tho
X-HE-Tag: 1792145290-284416
X-HE-Meta: U2FsdGVkX1/eCxol7d22Kqe9TBB4GvRHu77/NJTGA6a26o12b2dVP8H13mVzQAKwtwDJqlNEOiZ08H/f/JnYww3UOWHtjvKNU1ljD7GaGRz1x9z0FOtiyPrgQqszPtM85HK7YPqOKXHR9+4fZhEVJh9MMDmB/mzP3wY5LFvSlO01EpazWvfcPAIAA01hjJ7DHqiL9kP2w7oph0ELlPTfMELm1wlkQTOdJg3YqhDtrvMYxvK1VAhb9PF+pLljkN0qNPUczHt6PMNJCZUW/PvUQc9fl7/r8Zs4+O0nhJvutO4NSjtXxzbbq6FR7+wwU+tIWXDkjfV7XIyoJNPZ41R+7iXxHj7F9yQ346LHR1jLQDUFEMCydvObkMzqEKM3nokqMCj8zeqimCeUMf+3lFSOSYXrkuDZUefiu3juM0y/Sy1TtTINNBnkZMv0Y/UqHbTjjO4BzQJwlmewbGGEq3QUGBu5UPE2+TGgbenW5miV6u5EUm20pvIXY+V+QeuTLZlYJif1t5MhoEQISbL+jMmCMn7nFDN12dC1+FfA3zNAyuLTt2+XOH1wv5gIqoYvnIgSngrrI66umXWAm55y/S64+CDdhI8qsQTmiXZ07R9NWFZ2xer9NGsHcVCBkOE2sZNRsz759DSH9XKK80nLVEpABcEKkFSkT9VkYKmf5AWXLTUQvV7YPsieL1pBibkBwl+2+Eu1YHG5rmGmKO/ABVChLX8gzQP/Ou2d2/qDWvQm4a1U5315Wx4sJ4+inh96ttaku/nr+3LUiaHK/y1DeY0GkHK7QoBa0/6Ab9s/XzDyPQKSjFQ9Ei2ubCEgijyB1amoGy1UM266UncS+z8dWXjHgs/Vx5Lr3Gw1nvxI7Y7INBd9Rco0kC3SRUEms+imXdZcP6PdsQnFnojdn2CK+FsxphzA+cQ4FHtYFs7XMsFAaea4vvLZNEGt/wLJJ76oCzSHcpgsWq77tiX0psyMh2s
 62hPWBgl
 nJJOu6cncf0iGXnoPB9faGIG0qW1f4oXgy4+vSfbeKae9GCIDo/Losb7D4udHaDRIGLYLR5RV0ug1cW4AonGtJvIGUOV6xhno0ZLieCAQZ1euotIF6a27rwqkWwG8WxdfcA8akaNfi5Qubcy3XX5IQfKKV4BeTUdn6hzs1MymcU+HJUoRd9m6GvBGDTiaH0Z84P6u5Jhui59dKJouWKB7e+Goa2i/aLFvmladOwf9WksulIgoBntK6T03OGvkS5aBdqQM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

Accept an optional @<page-size> suffix for hugetlb_cma. Initially accept
only the architecture's existing CMA page size. Preserve the behavior of
unsuffixed arguments and the existing hugepagesz/hugepages options.

Validate the suffix before applying the existing capacity, percentage and
node-list parser.

Save the arguments during early parsing and process them at reservation
time, after architecture-specific page-size information has been
initialized.

Assisted-by: LLM
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb_cma.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 95fd2d190f0d2..a17d32fa5ebb3 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -25,6 +25,9 @@ static unsigned long hugetlb_cma_size __ro_after_init;
 static unsigned int hugetlb_cma_percent __initdata;
 static unsigned int hugetlb_cma_percent_in_node[MAX_NUMNODES] __initdata;
 
+static char hugetlb_cma_cmdline[COMMAND_LINE_SIZE] __initdata;
+static unsigned int hugetlb_cma_cmdline_len __initdata;
+
 #ifdef CONFIG_NUMA
 static phys_addr_t __init memblock_node_memory_size(int nid)
 {
@@ -119,11 +122,29 @@ void * __init hugetlb_cma_alloc_bootmem(struct hstate *h, int nid, bool node_exa
 	return NULL;
 }
 
-static int __init cmdline_parse_hugetlb_cma(char *p)
+static int __init hugetlb_cma_parse(char *p)
 {
 	int nid, count = 0;
 	unsigned long tmp;
 	char *s = p;
+	char *suffix = strchr(p, '@');
+
+	if (suffix) {
+		unsigned int order = arch_hugetlb_cma_order();
+		unsigned long long page_size;
+		char *end;
+
+		page_size = memparse(suffix + 1, &end);
+		if (suffix == p || !page_size || *end) {
+			pr_warn("hugetlb_cma: invalid parameter %s\n", p);
+			return -EINVAL;
+		}
+		if (!order || page_size != (PAGE_SIZE << order) ||
+		    !arch_hugetlb_valid_size(page_size)) {
+			pr_warn("hugetlb_cma: unsupported page size in %s\n", p);
+			return -EINVAL;
+		}
+	}
 
 	while (*s) {
 		if (sscanf(s, "%lu%n", &tmp, &count) != 1)
@@ -194,6 +215,20 @@ static int __init cmdline_parse_hugetlb_cma(char *p)
 	return 0;
 }
 
+static int __init cmdline_parse_hugetlb_cma(char *p)
+{
+	size_t len;
+
+	if (!p)
+		return -EINVAL;
+	len = strlen(p) + 1;
+	if (len > sizeof(hugetlb_cma_cmdline) - hugetlb_cma_cmdline_len)
+		return -EINVAL;
+	memcpy(hugetlb_cma_cmdline + hugetlb_cma_cmdline_len, p, len);
+	hugetlb_cma_cmdline_len += len;
+
+	return 0;
+}
 early_param("hugetlb_cma", cmdline_parse_hugetlb_cma);
 
 static int __init cmdline_parse_hugetlb_cma_only(char *p)
@@ -214,6 +249,12 @@ void __init hugetlb_cma_reserve(void)
 	bool node_specific_cma_alloc = false;
 	bool has_node_specific_param = false;
 	int nid;
+	char *p;
+
+	for (p = hugetlb_cma_cmdline;
+	     p < hugetlb_cma_cmdline + hugetlb_cma_cmdline_len;
+	     p += strlen(p) + 1)
+		hugetlb_cma_parse(p);
 
 	for (nid = 0; nid < MAX_NUMNODES; nid++) {
 		if (hugetlb_cma_size_in_node[nid] || hugetlb_cma_percent_in_node[nid]) {
-- 
2.54.0


