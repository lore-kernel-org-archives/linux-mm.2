Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A094E606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CD56B06BE; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23EF6B06C0; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11DD6B06C1; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF176B06BE
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:24:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 646FF1A0502
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:57 +0000 (UTC)
X-FDA: 85346401434.02.4E6345E
Received: from mail-m606.netease.com (mail-m606.netease.com [210.79.60.6])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3F545C0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:24:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792581895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=a6dY8R/bQis1rIq1yZh1AAI0QczoTtw4exwtDutCO9s=;
	b=bUYuCd00L++cctzM/nC88aC2GyeKCSlPENQknzY7wXJCKi3/jxFzi8KWmWe0mMOrr9dKKJ
	5s+hL/G2s9GxPB9IuFhfa+/317kj8RCObnv3dDiBQm0LG2vNcvX2q13e6vrDUkEeleofKL
	1S30w6EzUYOmtm1fjVpRnwjO2wTlikk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 210.79.60.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792581895;
	b=520Oslj0oP0j1hF/xzigqwfGGRsRQMKpkVFQXnfdxJPNCEE+qTG5lt6V0UTrad1pZcmJ5K
	MV5gYmkzMaHzCcTxhuMcnv+sWl+1K+IHUc94OMKL5w4dQsZUzNdFXOhaJ044dsRJv0rk0V
	B90riyWz3RdxeQ6SmYzfPDSWB5nzEWE=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 204f151a5;
	Wed, 21 Oct 2026 19:24:49 +0800 (GMT+08:00)
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
Subject: [PATCH v3 1/7] mm/page_owner: extract page_owner_next_eligible() from read loop
Date: Wed, 21 Oct 2026 19:24:31 +0800
Message-Id: <20261021112437.1799213-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261021112437.1799213-1-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa15e34eca80229kunme08c1fd526acd0
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDHU9CVkMdQk9CH09KTkJOGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Queue-Id: 3F545C0008
X-Stat-Signature: 6g31tmdtspow5zeei8x3h4a7jcr13kct
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792581893-634576
X-HE-Meta: U2FsdGVkX1+/UQDis8S0gzDTZ99QPXIi/AcS1jrHeznZc95i1pwF9iFIEJFeYZsjP3joG3S89Dp6xaayBH7iukYaj4Ci9BvqjRfzIzMZymWBPajSOEtjaDNE4Xy/oymSiSfS8v0D4P7nRPFk1TF3zXmPwGJfxqlrMYdTGA/NMobfBbEBAMH3+Sm4NaI5UHdN8vgdbrhYKRR0dF0CyadaG9EWOA+VvRcVhhJspjAQPa0+1DjVuEQk3AWOfHzD+m7wgehB+gm3dDv8h4R9jO1V40TiTMZerft7RhdkaKx+NTkqXwpbQqukoKUtGKDtyEJKk/lE0s3lKZ60Hconh+KvP96Ql1P6tDcsW63VHZmIpQXEBK9Yo2NMtRPRTBui47MNs9/hTZS6lVluCEJk38bWgfMMr8BCLlACV779aajyMtSr7gtJiAAI5XIHzlLk8pkLcrODp8UHTeW3tq4mZ0CUDzLMdcTj+4UsO0nSeBJg9eO31j4G2tbYkv1TEiV7rkb7kg/3/VUXqPt/EYNIQUgijOaj3u1K/6f0d1rktQfPDusI7z/vm61lMyEUYiCY6GB0d57PiK+AW0LUkyjNN3vosN3HXejD2tr67XlNdjvlbLGvHEcVX5QM4xbhYyrpkwdOtOX7/L2Q1N73WbOS9OFGKeU5DLZA9wce75nX6zFQaDrkWhxilUXCBMtS0rdJkCitlR8k4Ji7tFGi6Ak7GluQgzqHes0eZZkSOSTT75Fu+myg8U+BFE33H1bhilePIRonWJGEXNQKv1OpIW1y+Qtapbd2DdXQnJ88I0Seqdz4WuK/R6vAJ2OBliuWIKYq2m1UjXtsoLkSsl6w/V543pKe3gmv9i2uo8TUrJr5sFuX9LW0ffE+YFiL4PyvkZ5oDaAAM+4Lu0rqbVjITLG/bVEkbcwxhV+ocNOloSxnm81rlI5WBtl3ZiRiImxqn17Unf9BasS6yd8XVYtHbuZb6T9
 sVTkTQlG
 pFhjUaMDGUzJJ8V5KQxrQXOuLnSnpPOEyDrm45CLuKNlUP/yn36rhq52wNiB8BHLTobII1sWwHF9Y3SbxCayqOWGmy4rx4Lpu+L6S2mKGY80t3CGyMkvljzSaxWvoxwyWfaTbOsgsZOxlJ+5jMRSr4+vNqqVx0vYqak0lmsdEVyi9aPDrDeKpdFishAsdjmOykIrVVOSWMxZWtq6+Kphw6lW8N2OuMkkY9wYO8fESRDuipQgP793/WduN+c/2rcBEmAcv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the page scanning logic out of read_page_owner() into a dedicated
helper, in preparation for using it in the page_owner bpf_iter target.

The helper advances a struct page_owner_scan cursor to the next page
eligible for page_owner output and returns true on a hit. On a hit it
takes a snapshot of the page_owner record inside the page_ext RCU
window.

No change to the output is intended. handle is read from the snapshot,
taken before the non-zero check, so the validated and reported handle
are the same value.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v3:
- Drop the page field in struct page_owner_scan.

Changes in v2:
- Route the zero-handle case through ext_put_continue.

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-2-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20261013122125.843451-2-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 101 ++++++++++++++++++++++++++++++------------------
 1 file changed, 64 insertions(+), 37 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..92a92cdf74ec 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -36,6 +36,15 @@ struct page_owner {
 	pid_t free_tgid;
 };
 
+/*
+ * Cursor and per-page result of page_owner_next_eligible().
+ */
+struct page_owner_scan {
+	/* resume point */
+	unsigned long pfn;
+	struct page_owner po_snap;
+};
+
 struct stack {
 	struct stack_record *stack_record;
 	struct stack *next;
@@ -725,37 +734,24 @@ void __dump_page_owner(const struct page *page)
 	page_ext_put(page_ext);
 }
 
-static ssize_t
-read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+/*
+ * Advance @scan to the next page eligible for page_owner output.
+ * On a hit, fill scan->pfn/po_snap and return true; the caller
+ * must advance scan->pfn past the hit before calling again to resume
+ * the scan.
+ */
+static bool page_owner_next_eligible(struct page_owner_scan *scan)
 {
-	unsigned long pfn;
-	struct page *page;
-	struct page_ext *page_ext;
-	struct page_owner *page_owner;
-	depot_stack_handle_t handle;
-	struct page_owner_filter_state *state = file->private_data;
+	unsigned long pfn = scan->pfn;
 
-	if (!static_branch_unlikely(&page_owner_inited))
-		return -EINVAL;
-
-	page = NULL;
-	if (*ppos == 0)
-		pfn = min_low_pfn;
-	else
-		pfn = *ppos;
 	/* Find a valid PFN or the start of a MAX_ORDER_NR_PAGES area */
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
-	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
-		/*
-		 * This temporary page_owner is required so
-		 * that we can avoid the context switches while holding
-		 * the rcu lock and copying the page owner information to
-		 * user through copy_to_user() or GFP_KERNEL allocations.
-		 */
-		struct page_owner page_owner_tmp;
+		struct page_owner *page_owner;
+		struct page_ext *page_ext;
+		struct page *page;
 
 		/*
 		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
@@ -798,13 +794,45 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 			goto ext_put_continue;
 
 		/*
-		 * Access to page_ext->handle isn't synchronous so we should
-		 * be careful to access it.
+		 * Take a snapshot of the page_owner record inside the RCU
+		 * window, then validate it, so that print_page_owner()
+		 * reads the checked handle from the same snapshot.
 		 */
-		handle = READ_ONCE(page_owner->handle);
-		if (!handle)
+		scan->pfn = pfn;
+		scan->po_snap = *page_owner;
+
+		if (!scan->po_snap.handle)
 			goto ext_put_continue;
 
+		page_ext_put(page_ext);
+		return true;
+
+ext_put_continue:
+		page_ext_put(page_ext);
+		cond_resched();
+	}
+
+	return false;
+}
+
+static ssize_t
+read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+{
+	struct page_owner_scan scan;
+	struct page_owner_filter_state *state = file->private_data;
+
+	if (!static_branch_unlikely(&page_owner_inited))
+		return -EINVAL;
+
+	if (*ppos == 0)
+		scan.pfn = min_low_pfn;
+	else
+		scan.pfn = *ppos;
+
+	/* Find an allocated page */
+	while (page_owner_next_eligible(&scan)) {
+		struct page *page = pfn_to_page(scan.pfn);
+
 		if (state->nid_filter_enabled) {
 			int nid;
 			memdesc_flags_t page_flags = READ_ONCE(page->flags);
@@ -814,21 +842,20 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 			 * VM_BUG_ON when accessing poisoned pages.
 			 */
 			if (page_flags.f == PAGE_POISON_PATTERN)
-				goto ext_put_continue;
+				goto skip_continue;
 			nid = memdesc_nid(&page_flags);
 			if (!node_isset(nid, state->nid_filter))
-				goto ext_put_continue;
+				goto skip_continue;
 		}
 
 		/* Record the next PFN to read in the file offset */
-		*ppos = pfn + 1;
+		*ppos = scan.pfn + 1;
 
-		page_owner_tmp = *page_owner;
-		page_ext_put(page_ext);
-		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle, state);
-ext_put_continue:
-		page_ext_put(page_ext);
+		return print_page_owner(buf, count, scan.pfn, page,
+				&scan.po_snap, scan.po_snap.handle, state);
+
+skip_continue:
+		scan.pfn++;
 		cond_resched();
 	}
 
-- 
2.20.1


