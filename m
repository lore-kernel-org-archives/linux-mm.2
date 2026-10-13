Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B1FCC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0046B0096; Tue, 13 Oct 2026 08:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3873A6B0099; Tue, 13 Oct 2026 08:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA8C6B0096; Tue, 13 Oct 2026 08:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8A986B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:21:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D109780B46
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:54 +0000 (UTC)
X-FDA: 85317514548.09.6B4ED53
Received: from mail-m93248.xmail.ntesmail.com (mail-m93248.xmail.ntesmail.com [103.126.93.248])
	by imf24.hostedemail.com (Postfix) with ESMTP id 857EE180006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894113;
	b=1P+8F3moqgA5mSEpnY21PsdL+/qMxRMU4KCeHOwO9B4F0A47dFMglRjF0O+mW1BvVNBHCI
	4+Qa4Bxy0q/70sx5iDKAKc4TdJ1yiOg9H2AuSXTrOGvK2CYTERO/patvC5YCCERMXBz5ck
	qdCRn4wOaNG0zBxLzMLgjKqg5Ldm8I8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.126.93.248 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uG+YHEUIcE6zFVNIffdp0hQQQABkx2BfoKK0VbjRZYQ=;
	b=n8eQO+BNlQe1HVG/mO7/+Tesc3VZN83+7NyKHMiGULsLgEHFX7YhvGLIaES+nkauXWjpVk
	ZWbews4aHKLU82EEqzmeMHNgDohu8cneq/dXJy4dwkoyV4sV4pm1KKe5Ny+XbQBlilpPje
	PzrdwV+rSJev89NIuNonQFfBJv0EoUA=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 200407ef0;
	Tue, 13 Oct 2026 20:21:47 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH v2 4/6] mm/page_owner: record the NUMA node in the scan cursor
Date: Tue, 13 Oct 2026 20:21:23 +0800
Message-Id: <20261013122125.843451-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261013122125.843451-1-zhen.ni@easystack.cn>
References: <20261013122125.843451-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1353636830229kunm0bc94a6a525d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGhhPVkgZGUweGhgfTBhOHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: pa1fxny8bm6rm8r3zzpqnpobwjngh3xg
X-Rspamd-Queue-Id: 857EE180006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791894112-92451
X-HE-Meta: U2FsdGVkX19PFfgJdcw06f2Hrmhp4w0j/Eoe+vJNR2nWulF1DTVAMnkAlERQ4ZskUUixAnG3kIux4vgkQMFkbk1eY76GHDM8fZR5WhTDi1XAbQBjbP4RoRrYcTpTfy4/cq8pQ4Z53KbgXhQys3lip8RwuxLZUd5HMxS1WY187vjKQDZwV1ZnsKIqNaWkd52SpQGwROYyFrebj4CH0W6leSkEcxK2M19TDC5TO2WlLBqteK7r1d4NgV3W9dGbBZUY4jbv8Td059Ll9CjROMqDI5qk86PWeiBjXMMGi/RwLmTmEnPrn+/vbrqFGUyy8jnf3sB9x4l6NuHeJIP/SwpnYFwjSkH54q+BvwKWi/e0G8npRGHUcW570O950wI9nHgM6TVb8PCKyTlZqTQf/GiACYvBQO3KH1XLEes81lvOA2k8gzVEwFyFXhZZODn1ln4TmoOdPkcEBPhacWsDs0tWecwWJUMsQHzJOFUwlhQ44vqycMG4/hGs6lU12jks4NWjyctzE6K8wJz9itOES2I35AnOB+A9P3sDmDITO5LDvov5cD3q/B1vwZE2Sdxk6jYR7sqnn7ho7tJX/D+GkSsL4aXgOi+ephA4sQguiaQh2s8z5GkPHnICmVf9RvOoWfTHSwagOwvniV6bO1TJCOHFsJeJ/x5CVpxOj5ivIetGmXJllcgWribebkaDoFa9pEfoQqLkMS5NLRqDUHrvYHxfAS6bop/+l+rxivl7vDucsjLF8GrQZw6p25sRWzPtJk8L8brwhZo4BPrjCd8cYRAobKhQ6oj/8rGBQPssf73UVeHMjHbQm6KEUBmvabPRADDw2IJ3/cLFvt1+im8BYWyeuIHslpVwUtb8AG79H3PxWrVENyLBP19lpx7334Lg+ew3NKUoiEDhki/SjW9/tlhhNofcy5ujrO2Y/IT5pRvZOeTIOFEXTjxXL/iUpGvP4Qc2YvnZH3YUNu+7zZBY9ts
 V+AZ8R9e
 7y7nBvCy+j3uzQqi/VGdcxtpP7OL5AzUn/v4ggVm8FGKypogqHWrGWV7x41XlGK2+8wTcxnmBCr+bhfjlSZxHumSoIUYgWA5N4eQjqq9HE2tYUhvgxHd9Ei5VN6HP+ReWfiYzUoBueVDQcWFze49iMQ0EvcS2d1zUOL1DJJ9wQd8FY63IXmO4y9QpB9Tfa6MlVQM8u7H4Cktn0M9d2KuuSpVcIlbjd8wjXtoJC5KEUQd/fbT0MknW2uwKWNWz9KLW57rfwNFeEliECj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compute the page's NUMA node in page_owner_next_eligible() while the
page is still valid, and store it in scan->nid.

The debugfs nid filter reads scan->nid instead of recomputing it, and a
BPF program iterating the cursor reads the node straight from scan->nid.

Resolve nid at scan time to avoid dereferencing a possibly-unmapped page.
Keep it in the transient scan cursor rather than struct page_owner, so
nid does not add per-page memory overhead.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v2:
- Removes the v1 get_nid() kfunc. The node is now stored in scan->nid.

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-5-zhen.ni@easystack.cn/
---
 mm/page_owner.c      | 28 ++++++++++++++++------------
 mm/page_owner.h      |  1 +
 mm/page_owner_iter.c |  5 ++++-
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 617346a4ab22..113e4e7e0b3a 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -711,6 +711,19 @@ void __dump_page_owner(const struct page *page)
 	page_ext_put(page_ext);
 }
 
+/*
+ * NUMA node of @page, bypassing PF_POISONED_CHECK() in page_to_nid() to
+ * avoid VM_BUG_ON on poisoned pages; -1 for poisoned pages.
+ */
+static int page_owner_get_nid(struct page *page)
+{
+	memdesc_flags_t page_flags = READ_ONCE(page->flags);
+
+	if (page_flags.f == PAGE_POISON_PATTERN)
+		return -1;
+	return memdesc_nid(&page_flags);
+}
+
 /*
  * Advance @scan to the next page eligible for page_owner output.
  * On a hit, fill scan->pfn/page/po_snap and return true; the caller
@@ -782,6 +795,7 @@ bool page_owner_next_eligible(struct page_owner_scan *scan)
 		if (!scan->po_snap.handle)
 			goto ext_put_continue;
 
+		scan->nid = page_owner_get_nid(page);
 		page_ext_put(page_ext);
 		return true;
 
@@ -810,18 +824,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	/* Find an allocated page */
 	while (page_owner_next_eligible(&scan)) {
 		if (state->nid_filter_enabled) {
-			int nid;
-			memdesc_flags_t page_flags =
-				READ_ONCE(scan.page->flags);
-
-			/*
-			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
-			 * VM_BUG_ON when accessing poisoned pages.
-			 */
-			if (page_flags.f == PAGE_POISON_PATTERN)
-				goto skip_continue;
-			nid = memdesc_nid(&page_flags);
-			if (!node_isset(nid, state->nid_filter))
+			if (scan.nid < 0 ||
+			    !node_isset(scan.nid, state->nid_filter))
 				goto skip_continue;
 		}
 
diff --git a/mm/page_owner.h b/mm/page_owner.h
index fda83be69275..e8e52d22abed 100644
--- a/mm/page_owner.h
+++ b/mm/page_owner.h
@@ -36,6 +36,7 @@ struct page_owner_scan {
 	unsigned long pfn;
 	struct page *page;
 	struct page_owner po_snap;
+	int nid;
 };
 
 bool page_owner_next_eligible(struct page_owner_scan *scan);
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
index ac7e69ba0cef..a2b90c874852 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -13,10 +13,12 @@ struct bpf_iter__page_owner {
 	__bpf_md_ptr(struct page *, page);
 	__bpf_md_ptr(struct page_owner *, po);
 	u64 pfn;
+	int nid;
 };
 
 DEFINE_BPF_ITER_FUNC(page_owner, struct bpf_iter_meta *meta,
-		     struct page *page, struct page_owner *po, u64 pfn)
+		     struct page *page, struct page_owner *po, u64 pfn,
+		     int nid)
 
 static void *page_owner_seq_start(struct seq_file *seq, loff_t *posp)
 {
@@ -54,6 +56,7 @@ static int page_owner_prog_seq_show(struct bpf_prog *prog,
 		/* @po: hit-time snapshot, no RCU window needed. */
 		ctx.po = &scan->po_snap;
 		ctx.pfn = scan->pfn;
+		ctx.nid = scan->nid;
 	}
 
 	return bpf_iter_run_prog(prog, &ctx);
-- 
2.20.1


