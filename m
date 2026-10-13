Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537D0CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 12:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6596B008C; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3873D6B0092; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DD76B0095; Tue, 13 Oct 2026 08:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F38826B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 08:21:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 746DFA0BAD
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:52 +0000 (UTC)
X-FDA: 85317514464.16.FA77DE7
Received: from mail-m16023653233.xmail.ntesmail.com (mail-m16023653233.xmail.ntesmail.com [160.236.53.233])
	by imf18.hostedemail.com (Postfix) with ESMTP id F355B1C0007
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:21:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.233 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791894110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aehNc7E4zEEFLpDF32oFpifo1IXD7DIMxdL+tZpV6aY=;
	b=62gzO7BhpIIjBao6w0SPAtotg19jS1l1nlYmqP8EIIYpBk8L+TktNxPDj4sIX8qvMqJTYZ
	wYk2bAgXNu44D6CsbfI+nPNPT4RIDUzhv4ZXRDAz7wTx2lXhvwpz1v7Q7havJz+nlVlcT+
	OpAYRLdmTNAJ6sTDGvE9qrhNt4i0k0Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791894110;
	b=OC1FumHOR+sV5w4S+uTUPfNySacAmT0sFk1+YS12cYO/uLxsPmjjQ4g5Ud2KPNzmGttVh6
	jfwfVHpde4ah/nHRqjcniKF+yLrYhuMEbdTimcGgbeVVORsP000BUCppv6dPaadrgR5Nsj
	X7eg6drOPHQ8pxMw/tt4q7kEW/xNrws=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.53.233 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 200407eea;
	Tue, 13 Oct 2026 20:21:43 +0800 (GMT+08:00)
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
Subject: [PATCH v2 1/6] mm/page_owner: extract page_owner_next_eligible() from read loop
Date: Tue, 13 Oct 2026 20:21:20 +0800
Message-Id: <20261013122125.843451-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261013122125.843451-1-zhen.ni@easystack.cn>
References: <20261013122125.843451-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1353625140229kunm0bc94a6a524c
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHRhMVklNTUtNSx0YSh9DGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Queue-Id: F355B1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1355xdub6y8oz1h3quuz73ptt6gzucug
X-HE-Tag: 1791894108-701772
X-HE-Meta: U2FsdGVkX1/tV7SKwbHP0b0Lwj93iOKfnV+HGcWvfFrRrEXNU2hKKRXUwEupb3vw4x0Ra4F0hoN2ga6zckM3t3eLB4kXUCP64riVXN0DAFV69dvI7NiXwsFDlMj3sB7Q6XAwHaAZpTM/vc98Lamj2Fw4zKSlb1onoejZJksZhH6YaRBCbOjaprVQ1glF163NJY9Vbzpp0n7MMNJCyeM4YQwxFCrGGhzFlPp4ttbwEaXYf8s0rpuntfIEscSuNXl5aM3xt/MlC14Awgzopq03N1xjHWkyepnHa36rHiS4poMQ0uM79Dz32akpqWW04HHiny47G1D9GPXhT6PhSfnF1Tsiu6Vv8DsPwld4OH90R/Th34mbgFem7RDrB8Pj/7SIhjx7n2eKE09X2XigJ/Gb45xMNMP37110cbIy7S2wncDuFNfcDwrzjYk9yqeVkgKCN1/G3gL2pD5BLFtYWr3V4cEGtDxzQA2Qy+b2gjW+5jXq12lGRy9mivT3jIMNXpdGUvSO/nmFJWTorTYEMn1i1IXkxQqpPOXGD6MWBq3j9DN6Qr0khTPigOgPtM01B2OnSn/YXrq5cK/ek1754AXiIKzG022Kr/+PFSP5rTjZ+YAnZS8HJQUVqC1Yhl12sTh4ZE20KblHlYjlSZSkuZHep6mjaDHaOXbnlXC86LaY8eoEQBss5RikXnO2YsyywuqEmURlLTBnYQctwzs+sUZ2g70MHgOnksxXeMlKjcZjh+4k3yqsPwQhjrpJehFZG3AR4dBMarsx05wDsVOyBZTtWZB25dGBjAhngFyztywOgfmfELtAO1dH3W7kJ3P1K6Cj4v5cOyUXwqbf8OmcS50OyrkLcX9u5UCAu2NuybXi1uAJdnNbgV2pSn/s3+Oz2X1JyXF3DvJS2WskgdC0ISUeyFpWZ7g7LxJJlFxZx630vq5KJAhtGDYq+Moyg1LmJniba6EL6VZemeu0b8JFVG2
 Y6ngCv5F
 4Nti13jXXU+rTy5x6Fh0soFJ3ALy16Nvny+YuiF2qYfqyqwZBKAEiDP0JRc+OEhUdYLfncxKnHShxnkzbX0Iegd9qJj59nxSLbAuh8VihxnUqs1sT774I2Rlvi0zgefBTfjT9
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
Changes in v2:
- Route the zero-handle case through ext_put_continue.

v1: https://lore.kernel.org/linux-mm/20261009112308.240769-2-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 103 ++++++++++++++++++++++++++++++------------------
 1 file changed, 65 insertions(+), 38 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..56c75a669a6b 100644
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
+		scan->pfn = pfn;
+		scan->page = page;
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


