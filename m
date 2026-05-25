Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8B7CD5BCB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8718F6B0093; Mon, 25 May 2026 04:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822CC6B0095; Mon, 25 May 2026 04:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712266B0096; Mon, 25 May 2026 04:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6221A6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:17:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF31A40188
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:17:13 +0000 (UTC)
X-FDA: 84805237146.11.A9FDAD6
Received: from mail-m825.xmail.ntesmail.com (mail-m825.xmail.ntesmail.com [156.224.82.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE39CC000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:17:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779697032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/FzRVqYbCRPBbxwdEiGOEysz0IgA5R42nKjxYUzSY54=;
	b=6Lwz0Bqko7Dvp5xgoCrHnMtQVBpxWXgkENGMM4frnaSN0wrhUMRfzzZFeVX44dZyQPYuG8
	mJKFDNFAFsMwe4R/MqGNjtoO0+OgVsKY1/rbECCqdwL69btvI81Aa4OEvA0KBlIaTa3Dgz
	e8tY2HVP4u8+UUPqgWeTSyNmDePTJoU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779697032; a=rsa-sha256;
	cv=none;
	b=zj1J6kqPG7ONzzwQtZKD1Hc7qVzbd8cWQOUHbDjEOayMSBxuYo7CZEWo72Ue9nOCczfN0b
	uoVSOI5yWZ+FYwM6M643zvMcbc222it6ARjzmMC7nViPjfBSHCqUuI0BEiUXNB8grCtHOx
	DB0e8yPy7KitnneAANSydyl/r/PfsTw=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a8ce5e03;
	Mon, 25 May 2026 16:17:07 +0800 (GMT+08:00)
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
Subject: [PATCH v9 2/4] mm/page_owner: add NUMA node filter
Date: Mon, 25 May 2026 16:16:50 +0800
Message-Id: <20260525081652.2210206-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260525081652.2210206-1-zhen.ni@easystack.cn>
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e5e3589e10229kunm9b83604117f13f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTEIeVkgfGkweQx5MSh1OHVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AE39CC000A
X-Stat-Signature: fjzspkyis11q98bu7wurd86aein1a9kz
X-HE-Tag: 1779697031-187415
X-HE-Meta: U2FsdGVkX19gfgSgHqRc/TPMXjj/uX0Xy1789WNhFxMDWidjsRGaOhyFkjzcx1z1sOkwW1YEShZnvkLfRdon/z3Y80u4svXqVXNyg/ruCuaOYxk9hY5raqxADodOCKbv8gvG13pIYdr35aJwZ27OlAPKm+YXQ2oEcKoZgBUeXJ/UISwE1agBlA+Pixc7LCgNjZaVGSev9cbBhV3fNT1h8DohyL+KjmwJA7bXh3G7jC62XUZg0+OBPwG+D3WJNIxXR3eQlaq4DaOnZLi07YsYBOA4931/kxE2+lCwR0DhVTtboCIMgg/pXZkeSrrkdiPbmmAocil+cwel6+HFkWqqVh0xbqwzWGmXvwO3PTQaM4zI9ABJg5qi3x7I0cahHZwASAyFsZ6HyMOMXe19h2Whuf53dtpBcqRO2XAd8ICXebvCd96tx5vv6d4Ut2QhfN4fP3pk9XUqyddBzsrd83VikDSaUoNuZ/wxyNlyJMgSwrteZY2z4xgt9L8cYnoS5kdQ4GEYQlxu+f+nEH/ZNlBQkamW1i7rVf0zNciJethOAgtjiCx8WEitG2IWiMHDh5JMA04Mv/vO+5rxIJU40ChG2HIDP/AXSZta/EEdwAqW/y3KvnggfqXUnrJKPDw1VLc7n/GpeO5oH0QuDtNIfaiMUDLzls8cwdFOlcGNUiBhzQwSmA+RyDOfUhwdTnnWQ5YqXvbf7IPklc6l3jiwYuaPKkgvS7GwcQY16pDuy30UTiMDCG9EzNPyPKUscQkMrc+cnCs448ty0jt32gNeuNUPMQeOZ8pBvnQduql/15+DG1e//pM9WYTSMLAov/wBI/CDmjZlolCcl0+o1+te9AzK/AwTbt4E9crDbXsg4KSP/ivdZfzAFUvZbQqTowIAS7Hdr9MsmeShJfoWvbD38Nsh691Y1wenHLOhNfVgLoGi9fh8lFCTlvn2E5Tl+lBDQ18P8MHGWV7HuJl1ghsFS5M
 AzaGdlP6
 0IAshJ9fcSM/70EHPMstTGFJUbHEaeHXRW/AFsNPdPw2R60sAnlHvANKwXKkXJPvquCPqmPECMFtqKnOYTfM2iyUqNMB57Q+nCw4Ndy1Vvd/1ZZ+eZUvuhbRYz9S9Hl+5WWAVtc2R4n2B/MNj9IHPtl9DfsYsAsRZ1z8xmMhbj5b0IN0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add NUMA node filtering functionality to page_owner to allow filtering
pages by specific NUMA node(s). This is useful for NUMA-aware memory
allocation analysis and debugging.

The filter supports flexible input formats:
- Single node: nid=0
- Multiple nodes: nid=0,2,3
- Node range: nid=0-3
- Mixed format: nid=0,2-4,7

Example usage:
  # Using the page_owner_filter tool (recommended)
  ./page_owner_filter -n 0-3
  ./page_owner_filter -m stack_handle -n 0,2-4,7

The implementation uses per-file-descriptor filter state stored in
file->private_data, allowing each opener to have independent filter
configuration. It uses nodemask_t for efficient multi-node filtering and
nodelist_parse() for flexible input parsing. Node validity is verified
using nodes_subset() to reject nodes without memory.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v9:
- Add spinlock protection for NUMA filter state access
- Use memdesc_nid() instead of page_to_nid() to bypass PF_POISONED_CHECK()

Changes in v8:
- Add cond_resched() in page iteration loop to prevent RCU stalls
- Reject empty nid list to avoid enabling an empty filter
- Improve comment: "Commit all filter changes"

Changes in v7:
- per-file-descriptor implementation

Changes in v6:
- Add node validity check using nodes_subset
  to reject invalid node numbers that don't exist in the system
- Move bool filter_by_nid declaration to top of block
- Use kmalloc_objs instead of kmalloc
- Remove 100 bytes overhead

Changes in v5:
- Optimize nodes_empty() check in page iteration loop
- Add __data_racy qualifier to nid_mask field

Changes in v4:
- Remove "-1" support, use empty string to clear filter
- Use strncpy_from_user() instead of copy_from_user()
- Add concurrency safety documentation for nid_mask access
- Rename fops to page_owner_nid_filter_fops for consistency

Changes in v3:
- Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
  * nodemask_t is a large structure (128 bytes) that triggers compile-time asserts
  * Direct assignment is safe for this use case
- Add comment explaining input length calculation formula
  * 6 bytes = ",NNNNN" (comma + 5-digit node number)
- Simplify "-1" check using kstrtoint() instead of dual strcmp()
- Move nodemask_t mask read outside PFN iteration loop for performance
  * Avoids 128-byte structure copy on each iteration

Changes in v2:
- Use nodemask_t instead of int to support multiple nodes
- Implement nodelist_parse() to support flexible input formats
  * Single node: "0", "2"
  * Multiple nodes: "0,2,3"
  * Ranges: "0-3"
  * Mixed: "0,2-4,7"
- Use %*pbl format for output (e.g., "0-2", "0,2-4,7")
- Use dynamic memory allocation (kmalloc) to handle variable-length input
- Follow cpuset's max_write_len pattern: (100 + 6 * MAX_NUMNODES)

v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-3-zhen.ni@easystack.cn/
v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-3-zhen.ni@easystack.cn/
v6: https://lore.kernel.org/linux-mm/20260511033017.747781-3-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-3-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-3-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-4-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 7595735979bf..9e0fb679303f 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -68,6 +68,8 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 	spinlock_t lock;
 };
 
@@ -698,6 +700,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
 	struct page_owner_filter_state *state = file->private_data;
+	unsigned long flags;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -774,6 +777,26 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (!handle)
 			goto ext_put_continue;
 
+		/*
+		 * NUMA filter: if enabled, only output pages from specified nodes.
+		 * We cannot use page_to_nid() here because it calls
+		 * PF_POISONED_CHECK() which triggers VM_BUG_ON_PGFLAGS() when
+		 * the page is in an inconsistent state during concurrent allocation
+		 * or free. Since we're iterating pages without holding the zone
+		 * lock, we need to extract nid directly from page->flags
+		 * without the poisoned check.
+		 */
+		spin_lock_irqsave(&state->lock, flags);
+		if (state->nid_filter_enabled) {
+			int page_nid = memdesc_nid(page->flags);
+
+			if (!node_isset(page_nid, state->nid_filter)) {
+				spin_unlock_irqrestore(&state->lock, flags);
+				goto ext_put_continue;
+			}
+		}
+		spin_unlock_irqrestore(&state->lock, flags);
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -783,6 +806,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		if (need_resched())
+			cond_resched();
 	}
 
 	return 0;
@@ -891,6 +916,8 @@ static int page_owner_open(struct inode *inode, struct file *file)
 
 	spin_lock_init(&state->lock);
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -912,13 +939,18 @@ static ssize_t page_owner_write(struct file *file,
 	size_t max_input_len;
 	struct page_owner_filter_state *state = file->private_data;
 	enum page_owner_print_mode new_print_mode;
+	nodemask_t new_nid_filter;
+	bool new_nid_filter_enabled;
 	unsigned long flags;
 
 	/*
 	 * Maximum input length for filter commands:
-	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 * - 32: print_mode command max length is 17 ("mode=stack_handle")
+	 *        with sufficient buffer
+	 * - 6 * MAX_NUMNODES: worst case for nid list
+	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes
 	 */
-	max_input_len = 32;
+	max_input_len = 32 + 6 * MAX_NUMNODES;
 
 	if (count > max_input_len)
 		return -EINVAL;
@@ -931,6 +963,8 @@ static ssize_t page_owner_write(struct file *file,
 
 	spin_lock_irqsave(&state->lock, flags);
 	new_print_mode = state->print_mode;
+	new_nid_filter = state->nid_filter;
+	new_nid_filter_enabled = state->nid_filter_enabled;
 	spin_unlock_irqrestore(&state->lock, flags);
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
@@ -943,14 +977,37 @@ static ssize_t page_owner_write(struct file *file,
 			if (ret < 0)
 				goto out_free;
 			new_print_mode = ret;
+		} else if (!strncmp(token, "nid=", 4)) {
+			ret = nodelist_parse(token + 4, new_nid_filter);
+			if (ret < 0)
+				goto out_free;
+
+			if (nodes_empty(new_nid_filter)) {
+				ret = -EINVAL;
+				goto out_free;
+			}
+
+			/*
+			 * We want to filter memory allocations by numa nodes, so make sure
+			 * that the specified nodes have memory.
+			 */
+			if (!nodes_subset(new_nid_filter, node_states[N_MEMORY])) {
+				ret = -EINVAL;
+				goto out_free;
+			}
+
+			new_nid_filter_enabled = true;
 		} else {
 			ret = -EINVAL;
 			goto out_free;
 		}
 	}
 
+	/* Commit all filter changes */
 	spin_lock_irqsave(&state->lock, flags);
 	state->print_mode = new_print_mode;
+	state->nid_filter = new_nid_filter;
+	state->nid_filter_enabled = new_nid_filter_enabled;
 	spin_unlock_irqrestore(&state->lock, flags);
 
 	ret = count;
-- 
2.20.1


