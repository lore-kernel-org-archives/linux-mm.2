Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29369EA719A
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED4E6B031C; Sun, 19 Apr 2026 11:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89D716B031E; Sun, 19 Apr 2026 11:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C9E6B031F; Sun, 19 Apr 2026 11:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 63DCB6B031C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:56:05 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00ED1BADD6
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:04 +0000 (UTC)
X-FDA: 84675756690.16.5D713C3
Received: from mail-m82145.xmail.ntesmail.com (mail-m82145.xmail.ntesmail.com [156.224.82.145])
	by imf29.hostedemail.com (Postfix) with ESMTP id A929D120006
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.145 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776614163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OCrYGcKGgL+mbSUJltutu+Mk5jdsyHmuGIkQ9HzIMLY=;
	b=ZmRVntJPfjnANf6O5PryWOmDIQCzWc0b04TKtD1+ixDCfJcHsewVYStv5Q5XfES2Sc7IGv
	TiQAlrgztJSQJrvwryv1pYK7j8Ff9QYE/ERaMa6QPEc2QdtPi8stb6JsCH6dJc18ksOQd5
	x2m8uphukGapCMwBDSWOz33b8fTPfpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776614163; a=rsa-sha256;
	cv=none;
	b=AI2Czo75RRQAOdloh037V4PhGFGxCsD5KD54YUhv3ZVPigbKc1VSRE1GNGReG+bKgHtJd3
	uyBzGsfCjjOWyrYN5pvp3EZyhEx3Hft9UZ5hpHNMAbNmH4cnV03zr7mjJhPXKwBQlveEJ8
	IdB3RRD6mVtn9aIluO58xWyBRghdahA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.145 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1918e52ab;
	Sun, 19 Apr 2026 23:55:57 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v2 2/3] mm/page_owner: add print_mode filter
Date: Sun, 19 Apr 2026 23:55:39 +0800
Message-Id: <20260419155540.376847-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260419155540.376847-1-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9da674ada00229kunma1b4aa74234e8f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHUwZVkJDShoeGkMYSEgfQ1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspamd-Queue-Id: A929D120006
X-Rspamd-Server: rspam07
X-Stat-Signature: z6mi6cx7bgaqb8zyxmzjjfn948qixeuz
X-Rspam-User: 
X-HE-Tag: 1776614162-265256
X-HE-Meta: U2FsdGVkX18v9NhThUwS4yPH3cmRrHu/LZA1Nxr4/5UHKw99Kvvr2gY7FgNjxLW38A7iQ1jrEEfjTe/pOsEWyvMJyall+K/KNulwbJjke4UTF42ADl6CGUSX4eY9y1e6OoJP2QIGu7rxc33XSqTrPZiQ0mkLU0E0cvxI6U//kicdr642lnCVhPILou3pp60DIEU7KVUDGPqAjtKK9pVSxNX+zfyYwlGSyBxKa8g2ryKS7VnL/5IZKwpOtRgbK8AfGDYPrt/zffM7H1lt6gSiMkZ6sxT2gBQwIu9+Wz0aicF8TL2QRKfxM0zHQkDYrAWBOm3cQQ62Baug/ieGSiwysMkkn6mhlNG69FjFC6l9oK5OFKqCt04eV/ZWhrjX5Xgyt7nnFGvMiFXT+l2EyR3ydpyO7JZYbH/4jKXFausNH0KrhCM8ORdm8ONQvKzvHw/WrDnuhpu8DEBj2u7DcEC79UnFPLfOgkaJpNjxqm2Obhitneukr86cUOjaYD0ZWqAtqsbCaW4aPa2n2GzCzDkkHQPgrGhKSe5cUYXvE/AkXosy8BCVRo/+ZoIKfY+pK1ew7hvAFWucwDIeoT5XAr953NfvUbWpjggM9QA1oIH6DpIESH9wbbeB+ZrKKB1KeWrfxoHg/51crW0uBtOzNeA/qA7ctZqrG/h/CHt43My/3YJsqim1UIyTesa3i6f9Wj906u+f7BQIe4H4xAuAfQJ4Uhn6uQ98N/Cp5tuGscj302qP0nuhLwhkFE5dv/TbKUDwxsN+v5ctz/9dFYF8orEW/9z/3//BYwnLODX1TakMLcAtCGSUTvmOh9GGhy8F98j1Y9TqVleL+Eo51kNNh5gGOnRcoQjf8QmojT4PUxxa4fWpjUqY3B/f7KsLpHQzy18z+PmONXIxyAxwNd2tFFViZBj7SRRakbIqi9TuBWtWKwUKZQS6RqZ/ZmwPRNb/5B3/aYX/iTtGt0XW+sJD9h1
 /0eLWLfC
 3COCWglffgfpX4V+UNr4iT2KGw66AVikBUeOzBqa/6raSQYw4wthZG6OmW4DEg63+lnAy7gdz6m9Y3Vk61xY1F222bOaML3blPcMvLgpLkXlKenUuFcu20wUOyStaHwFR99G3tlnLLfmtHMYPsF0W8eNB0VUu+5umV9r0KYAIJ7VZ3UT3d2SEIsyAjOOR3m42bcwsDywhixQIqxBIKombzmrNMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add print_mode functionality to reduce page_owner output size by
printing only the stack handle instead of the full stack trace.

Example output with print_mode enabled:
  Page allocated via order 0, mask 0x42800(GFP_NOWAIT|__GFP_COMP),
  pid 1, tgid 1 (systemd), ts 349667370 ns
  PFN 0xa00a2 type Unmovable Block 1280 type Unmovable
  Flags 0x33fffe0000004124(referenced|lru|active|private|node=3|zone=0|
lastcpupid=0x1ffff)
  handle: 17432583
  Charged to memcg /

Print mode significantly reduces output size while preserving all
other page allocation information. The correspondence between handles
and stack traces can be obtained through the show_stacks_handles interface.

Link: https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v2:
- Renamed from 'compact mode' to 'print_mode' for better clarity
- Use enum values (0=full_stack, 1=stack_handle) instead of boolean
- Update debugfs filename from 'compact' to 'print_mode'
---
 mm/page_owner.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5884d883837e..6d87b6948cfa 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -590,7 +590,13 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	/* Print mode: full stack or stack handle */
+	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
+		ret += scnprintf(kbuf + ret, count - ret,
+				"handle: %d\n", handle);
+	} else {
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	}
 	if (ret >= count)
 		goto err;
 
@@ -985,6 +991,24 @@ static int page_owner_threshold_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
+static int page_owner_print_mode_get(void *data, u64 *val)
+{
+	*val = READ_ONCE(owner_filter.print_mode);
+	return 0;
+}
+
+static int page_owner_print_mode_set(void *data, u64 val)
+{
+	if (val > PAGE_OWNER_PRINT_STACK_HANDLE)
+		return -EINVAL;
+	WRITE_ONCE(owner_filter.print_mode, val);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
+			&page_owner_print_mode_get,
+			&page_owner_print_mode_set, "%lld");
+
 
 static int __init pageowner_init(void)
 {
@@ -998,6 +1022,8 @@ static int __init pageowner_init(void)
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
 
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
+			    &page_owner_print_mode_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


