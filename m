Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35DAFCA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C665D6B008C; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1076B0092; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B05416B0096; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 822596B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:23:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18E0EC0322
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:36 +0000 (UTC)
X-FDA: 85302852432.15.0DF2521
Received: from mail-m82120.xmail.ntesmail.com (mail-m82120.xmail.ntesmail.com [156.224.82.120])
	by imf21.hostedemail.com (Postfix) with ESMTP id 50C051C0006
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.120 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WcC0Dtp9m4em3Iqmcx7fHXo32hpC93JJyX0q33wUHZs=;
	b=VOA2XFuPY2+NC48ds1tvRbiQ6UXd2ozevHCDxjG/8tECab5tfmL5oFPfKMGWxd0uRDjSxV
	5rjvfqRZUR7ixtMLyV9mbmUa+TD8Tl9xMn0SbvnLCkG2LH/UGPz3aRoaILFOEp4xeGUV7c
	s4xm/J4x3rcnHZPBt2or7o3b/hAho2I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545014;
	b=7fWxLv5+Ic10SFfQZrUmtr49ylx0MuQJXyLUC6usspHRohpYeDvbdCmp6WDvEa7kE6osfG
	e4oWxd3eHDnZgNZaLnyAZ28aJJSQagV3yWjLDRCf3Hz7oImB6USNAC4lDkdp6dDNnUczzW
	R9RwRyR0rMk1FKH2INUs2+PlG8y/K44=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.120 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1fe29019f;
	Fri, 9 Oct 2026 19:23:25 +0800 (GMT+08:00)
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
Subject: [PATCH 1/6] mm/page_owner: extract page_owner_next_eligible() from read loop
Date: Fri,  9 Oct 2026 19:23:03 +0800
Message-Id: <20261009112308.240769-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261009112308.240769-1-zhen.ni@easystack.cn>
References: <20261009112308.240769-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1206756430229kunmd33b3e054cb27c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSRlMVh8dSEsZQ0tJGh9KT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 50C051C0006
X-Stat-Signature: pmfdm7h8ujjdj6jzzq65nn7jfmaucwg4
X-HE-Tag: 1791545012-277476
X-HE-Meta: U2FsdGVkX1/CowFEmcfBZy+kMQLT10flyUy19ey8RYEEi+Mqxf5nNc+ilNdeCvmAMoPWaERMYTcFRIcD1rcq2xL3c0bOi9LwRhGETIx3WHRRG8CjL4pZRXK7xHHuONFIOx6cV6QWMkxy1uVmcTNb1YXJtKHKH7HZQfSpXk5U+JfQQPk5fFRhMNbeys2RMIDt6REB5Ee/mToj8EzgwAXb5bGEeDFAVwSYZZyV99uhXZOBPblYHfHKikGr3uGdRa9HQoKdNwxqeUjYk8SEgdFJlEUmIUZFGMetdFinOMzBrPapwWZmk/VpgrVnVSTF0lOBxYYM4D3CCmWYeEov9SzxoXC9Uh46TzfPLztGwIL7HwYURsgtmu0p6lLGRZYms+bj39JKAb/o+tSlry4pHgEJbF2BGZBnloCVpiC/RaBS5C1vXMaDH9slTda1uEFN9Yk+SmP/weo3cNxW46z2cdkDgGpT4kThv6LxlxdWD/bRNa83InerX7a3ThPfMXqPvOlPFFge5oHWOhSCHUMZ9y3M/Ow1AV2w1VkHeUYBGHsIvzX49nC4wkJ8/64Prwvz8oXVzLaZJkHo9Jvf75z0yDmp8v1hsffwIXjCn2g/ZWgEdmbjS8/nYWqoP7rDcCvNo6Vp9CIJab4l5PjqX38HNNAv0RQUgutRTvbv4BV3W7LZtCBigSUu1JH9bqjB4LK+WjJEwpoV208Ue54kihN5zmLmqdNdNpvV3fUaZQL5GEE6T2x5ewfgzBhug92xkCosxeii1jHS+BbYqYyhqFRXkxTcbKad5Ob3nbNGZEQALfhC8iQYfSxyweMmyoKr2pD7bekeulCZW9p0k+zswv3UuIg7yYc4NN2DEIwGDE447Fl2TaqLIqbv3Asd8EohgRGLZu+RtsDXChdSFF/7bYS23e42NvQVTkvPWwkM+p/A1TgRtAW54+xxe2uY5z2d8nZQWuRQssUgzldHnVVZ2zKRm5l
 nSlaZ93N
 Mfz8+NZ+PykD4EFz2kFB08BxAyncwmVfdzb1MF9S4/IouxftH4Om5PPrVqLa/xP6AwnHrA/rqOBy9YGFzBLOw+7rBCq3nDy2YcgtygnPFPglGbneXLU+czCWjRYDfpZe72waPZ/6oDbHDmidMp+e0uKM6HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/page_owner.c | 105 ++++++++++++++++++++++++++++++------------------
 1 file changed, 66 insertions(+), 39 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..bafe474f3360 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -36,6 +36,16 @@ struct page_owner {
 	pid_t free_tgid;
 };
 
+/*
+ * Cursor and per-page result of page_owner_next_eligible().
+ */
+struct page_owner_scan {
+	/* resume point */
+	unsigned long pfn;
+	struct page *page;
+	struct page_owner po_snap;
+};
+
 struct stack {
 	struct stack_record *stack_record;
 	struct stack *next;
@@ -725,37 +735,24 @@ void __dump_page_owner(const struct page *page)
 	page_ext_put(page_ext);
 }
 
-static ssize_t
-read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
+/*
+ * Advance @scan to the next page eligible for page_owner output.
+ * On a hit, fill scan->pfn/page/po_snap and return true; the caller
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
@@ -798,37 +795,67 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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
-			goto ext_put_continue;
+		scan->pfn = pfn;
+		scan->page = page;
+		scan->po_snap = *page_owner;
+		page_ext_put(page_ext);
 
+		if (!scan->po_snap.handle)
+			continue;
+
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
 		if (state->nid_filter_enabled) {
 			int nid;
-			memdesc_flags_t page_flags = READ_ONCE(page->flags);
+			memdesc_flags_t page_flags =
+				READ_ONCE(scan.page->flags);
 
 			/*
 			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
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
+		return print_page_owner(buf, count, scan.pfn, scan.page,
+				&scan.po_snap, scan.po_snap.handle, state);
+skip_continue:
+		scan.pfn++;
 		cond_resched();
 	}
 
-- 
2.20.1


