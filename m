Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E50CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 03:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A689E6B008C; Wed, 17 Jun 2026 23:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3B46B0092; Wed, 17 Jun 2026 23:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9082A6B0093; Wed, 17 Jun 2026 23:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5CDB16B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:58:15 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7DC1A05DC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:14 +0000 (UTC)
X-FDA: 84891675708.04.82B05AA
Received: from mail-m82155.xmail.ntesmail.com (mail-m82155.xmail.ntesmail.com [156.224.82.155])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7C3AB4000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.155 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781755093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F9AHvl9BBjKqh95RPT6od6GwkKyhdrDT6meEKEXGTKQ=;
	b=05uUw4bBhfymdNI1kJ641dqGDdW5I8C5LoNRe8EvH26wcQgbx2mEd3PZDA3UspJgqHLs/p
	PTSoXHP2HrS40wb3Y+6Ym+LCcxBYm4Bkc4YO8uh603RANAcN9N0kfmkShpq+l5pRCPhYPI
	Gad02FdezyQZegL8e2FfME0n5hlbVQ0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.155 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781755093;
	b=XAbCBKfKFbOGsNVG8qYMKxOcmVDu8fw6TQRNaZzUunfnSeuvkSj6UapU+uG816whqvRj02
	FjokP5zakB42bVN780X+lAhUHIRHLV1Ygg4YBrvhy7ubmtV4DzrlzVEQZ2jnjBE0zbTYYV
	R2s8UOL9vpzczy11PuKBEVk8Fen/LSI=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b9899923;
	Thu, 18 Jun 2026 11:58:08 +0800 (GMT+08:00)
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
Subject: [PATCH v10 2/4] mm/page_owner: add NUMA node filter
Date: Thu, 18 Jun 2026 11:57:48 +0800
Message-Id: <20260618035750.3724613-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260618035750.3724613-1-zhen.ni@easystack.cn>
References: <20260618035750.3724613-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed8e10e710229kunm88c9600fdda9e
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZTEgdVh5MGkJJTxhLTk5PSlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Queue-Id: 7C3AB4000C
X-Rspam-User: 
X-Stat-Signature: bjddi4nqu7tkbynsmui5i4asihoyy6a6
X-Rspamd-Server: rspam09
X-HE-Tag: 1781755092-369065
X-HE-Meta: U2FsdGVkX18aS4BEK3ZJyhCtW2Ql1mGngLvIPNwbk1HmDcEGoAp5VA/RC1tm/K/557tSI75F3yUmnqhIUVPerd6TyKm+vsHju+ephz8V1+ZQ8ZOWef8PIzBIlPbdV/Ahjroq41Y9l5b9y5ekKwgDlQ42S5Q+FhF7i+mii6h/g1zXwiB9jZokr/86ixeR/TAQjLohHjoXBFTqciwuzg8qoCP8UTXz0ERYjFbtIyHypiaXF4mkOs0B/THh15QpHRjTvQ5GZoShLcRjxcDERocIvjaPCWwlLl/c8K2GIfzXb2Rebd9J1+1/9smuZAeMOAFALT5qwDoJwJnAbyZs1Uo9aJ6hksE7iZONzurZPK0JbSKYVQ3TRNtEankEGrTF4n3mBaoeG3zC9bdsAjKt3V5Mnz8b6eaJN5JOJNyIilZo3HBvM9J6wNU8bwm5pyp7GN+YQ9X5qT3ud58GTqag7UiwUpCz0puwBstMGQbq6Iqk+wAQkAk6LXyHhL42N1qU894ygCzqIik+A5sXvt3G1tqSH2RBUqEcmsEb+4eO7TMb43Hv3lJeXvSGnuL01N00VN1xPWqRaH19E5bwnfEGp3S+roOpvZO0/22ZN1miRAiGoQZ8q1vpwbIYaUOgiNWhXaiF1Yl6l9XyzLDMup8w8hCLpI5wFSoEfQj3F95jbKLnHAiMSKi/pm44aL4qPZBpphwbRof3OpANYpgwijAuAHYiMdX47U4NZ6YPCTA7jSX8OZU1DrJCoGWaRgZBFPVkni6G5+Loj2E0avuAJeP6iEw+lWTICZLJWTXickDxuwvRW6MnWKL5DPDLAd0bjfIvB+k6V8YkLJ1pUYMeRVTWsUg72QuV3yhMIkdji34zeY4i8bBK5Lwgiush4H8UAtlpRtlOWBr/0KUTuOMFAe3mjXOuPzPet3Pz/xNCOLRjv+2rQRxCd3Qaj3JIBdosctiB+EHajsfmhATeDURQ0Xb6XSC
 72OouGd8
 8OEMzejFdkNhfx9bd5fPUqgSIQbeKpuS2ufbJcqAviYlw8+JWik2irofkz96CfgxXdz2KGlE/vD3Jom+hT0zm2ZIgEsqBJtBvKYwUmsQd5FEcbzV0HvhE6IIxxqPDI2QdJOZrhTH5PbGaLJ4LiMnA/HshymhnKGAtsaGZvR65gjDWzNA=
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

Record the node ID at allocation time by adding a 'nid' member to struct
page_owner, rather than calling page_to_nid() during lockless
iteration. Since page_to_nid() includes PF_POISONED_CHECK() which may
trigger VM_BUG_ON when accessing poisoned page->flags during concurrent
page free, record nid at allocation time to avoid panic and provide safe
access.

The implementation uses per-file-descriptor filter state stored in
file->private_data, allowing each opener to have independent filter
configuration. It uses nodemask_t for efficient multi-node filtering and
nodelist_parse() for flexible input parsing. Node validity is verified
using nodes_subset() to reject nodes without memory.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v10:
- Add 'nid' member to struct page_owner and record it at allocation time
- Remove cond_resched() in page iteration loop (unconditional call)
- Update NUMA filter to use saved nid instead of page_to_nid()

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

v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-3-zhen.ni@easystack.cn/
v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-3-zhen.ni@easystack.cn/
v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-3-zhen.ni@easystack.cn/
v6: https://lore.kernel.org/linux-mm/20260511033017.747781-3-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-3-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-3-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-4-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 7595735979bf..5538d65dcdac 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -34,6 +34,7 @@ struct page_owner {
 	pid_t tgid;
 	pid_t free_pid;
 	pid_t free_tgid;
+	int nid;
 };
 
 struct stack {
@@ -68,6 +69,8 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 	spinlock_t lock;
 };
 
@@ -268,6 +271,7 @@ static inline void __update_page_owner_handle(struct page *page,
 	struct page_ext_iter iter;
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
+	int nid = page_to_nid(page);
 
 	rcu_read_lock();
 	for_each_page_ext(page, 1 << order, page_ext, iter) {
@@ -279,6 +283,7 @@ static inline void __update_page_owner_handle(struct page *page,
 		page_owner->pid = pid;
 		page_owner->tgid = tgid;
 		page_owner->ts_nsec = ts_nsec;
+		page_owner->nid = nid;
 		strscpy(page_owner->comm, comm,
 			sizeof(page_owner->comm));
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
@@ -698,6 +703,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
 	struct page_owner_filter_state *state = file->private_data;
+	unsigned long flags;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -774,6 +780,15 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (!handle)
 			goto ext_put_continue;
 
+		spin_lock_irqsave(&state->lock, flags);
+		if (state->nid_filter_enabled) {
+			if (!node_isset(page_owner->nid, state->nid_filter)) {
+				spin_unlock_irqrestore(&state->lock, flags);
+				goto ext_put_continue;
+			}
+		}
+		spin_unlock_irqrestore(&state->lock, flags);
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -783,6 +798,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		cond_resched();
 	}
 
 	return 0;
@@ -891,6 +907,8 @@ static int page_owner_open(struct inode *inode, struct file *file)
 
 	spin_lock_init(&state->lock);
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -912,13 +930,18 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -931,6 +954,8 @@ static ssize_t page_owner_write(struct file *file,
 
 	spin_lock_irqsave(&state->lock, flags);
 	new_print_mode = state->print_mode;
+	new_nid_filter = state->nid_filter;
+	new_nid_filter_enabled = state->nid_filter_enabled;
 	spin_unlock_irqrestore(&state->lock, flags);
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
@@ -943,14 +968,37 @@ static ssize_t page_owner_write(struct file *file,
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


