Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3FDA606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iMLr+OMH
Received: by kanga.kvack.org (Postfix)
	id 0B4156B08BD; Thu, 22 Oct 2026 03:32:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065576B08BE; Thu, 22 Oct 2026 03:32:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4376B08BF; Thu, 22 Oct 2026 03:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDAA56B08BD
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:32:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 525A1A8374
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:15 +0000 (UTC)
X-FDA: 85349443830.06.62A555F
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27FD6160009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:32:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMLr+OMH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792654333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xMytu2C8Nmogy0+bbYi+5i1MnS/d18m1VfDgn4wFW34=;
	b=ewLYE3aGV05i1EhxBV93du/mesOQfrNe1LdZpgpK0ka0po3j+le59t1Yr9sVXCWfc1pRyH
	qg1aCbKxsNpXkdEIuKbdFnjiWH6J9ZBsDvubaggqz6PJJll5V6J+F3Tuz3eTc3OJVEWBIF
	K8RODAU9vIjWLEgl4pbMQA7kEQVw+fQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMLr+OMH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792654333;
	b=XO0Zah/jJAfkbzrpjt6W64sKsLQuYOOOa2QqQLinlUwyA8KHmw9EFUolfod3qblzxNwQke
	sk0bqAuCxwbAN4fsKLzD/sRVAe+AxViLx5237/GIxVEppdjTX8qWoqFfmZi1A8bYSWXNj4
	Q3BIzrcd8wGVOtBJVY27hpkNVNUg5eY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=R8xkncJ40MF0d8T0H0YefAgqykP6x4q9Gd1PMHfaYuc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792654329; v=1; x=1793259129;
 b=iMLr+OMHlbMUIb5CEVDc+UvMRUkOJswCJbbdLyAZQBgWvtINFMkn0YbNiNcCYSCbyaRuXif8
 hq3Dk+A3DuxsEf245nTh4+pytpVH8T7jQf4cNiN9Xzr9EWfm6mg1rFGC3tHOmOpsBVcevkuHquj
 3YlZH0NOqhZTxwc6ZrORs6Oo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ef916778793ef3a7;
	Thu, 22 Oct 2026 07:32:09 +0000
X-Mizu-Trace-ID: ef916778793ef3a7
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 1/5] mm: hugetlb: add explicit page size to hugetlb_cma
Date: Thu, 22 Oct 2026 15:31:45 +0800
Message-ID: <1fd7ad70d80ed0da82b90ad5d86de90499a49a54.1792651104.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1792651104.git.zhengqi.arch@bytedance.com>
References: <cover.1792651104.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 27FD6160009
X-Stat-Signature: shgyjkh3rd3mh5ynwgsxdnrb398kkz4z
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792654332-325728
X-HE-Meta: U2FsdGVkX185CSUiFNKiVXcLIx4LD1kfZZR5RQvyRSBKGhECddCm7+2R1kySj4YBu3qvhd9tl7QK+uSzpn1WsqEbBUGBknmYYzAhmrZs/0rbPVeYhRJPJ5C+Fn06WX/IKmnB7ZzNcX11qTTXRmx7UfHcXn9ky8cZMReVYldumnzBVU0ulNlSwuHCqG1IdFr1a9cw2oltzq/NNmfWUXUaWB/QJGhK7kvreMl4jXeLA7vzf29eiG+93alp1IB8xfC4J9B4jo/zoaKCuSh1+QQCB5bHZPtTceTLRiIvTu27bQr0DT1NBHlzOAJM1L12mxrFPwBdieowszaZeOZovFai2QddQkSYXUlmH5Mf30h+hX4uSHVjKtZ9MkBfjS+qY08F61IgiLpxL+F/SihlXOLD5UuCE7uW/foRO4CEBO8KiJ6AEyUvQosIjjtOkxTsqpl2wvyjm8+oXVRYpPuWnPwSetsScOl2PfwwLPgFIvBpuFwzeVjhB1jm02VAhgt4ZoLCFQcDG+4Nsiz+2ZikHf7ssF7FYvQ2WagPg9LYGk3T2PiQEsnaLroxnWxrfUiXgsTN5sGngzNnjDNjxJChwb+QETOFrhtGsPEUNL5fW8FwjclCdv2P94ixbfBcRPgfkBXJnzr0+RM3oKaWGEBWibg1pgM+wftYRl2X++H4/GyyZjKJTF7Zw6NWJRpOSGB4WIpcNEFPrTdtzmovpe71oZLn+r9fz1TJqQ+te2YDiVgV68v5ozlu681spv5YQ9kORzcVrF7scrgTqVOtZFssn4fTkv9f9i22HuCAX8hF+DQWAyR1YOYOJoKzE0htb1r7A5dHwLJuAZdCra350knRjHhH4t9zovkI7ZCtGwUEoTUyed9XGTpJHR9d3v9ER/tu1wF9pXaSTl9oPajOAlhOoJM9RLAn/kCn3Of2+madALIKOdYt30rfTVUXv5YgLqSG+qtWYEUkitPDIqV3dpBto9n
 emCgzV8C
 vqJDxw9FOz+l6635FDe0jpbsI6flo2obgfapy5RY7LM4h/TNlmjlPDzaqDMPfw/TG9LwfoyNVUYR8KHfcAmVo51Aw57lJtjUVc4z+j9b7harEuOrk1TsgnmYPIPohnvjApq1c3gKPW1BV3mWQZhLjXZ8xT4VHmNYCtTzCvkpIE+PeF3192HT6LepE2Tf7atO9l7V3oI+gysC7LlNNdx/rFB5OdkYVhvIntzIIBefFg2O4NX/RchWvfeYU09TR4nQvesLsmdCs0cFQJ7VdmNupCAbZQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
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


