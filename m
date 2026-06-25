Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E67BCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:31:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB086B0092; Thu, 25 Jun 2026 00:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6926B0093; Thu, 25 Jun 2026 00:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7C66B0095; Thu, 25 Jun 2026 00:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 801D66B0092
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:31:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8259A0531
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:31:21 +0000 (UTC)
X-FDA: 84917160762.28.5137F00
Received: from mail-m82159.xmail.ntesmail.com (mail-m82159.xmail.ntesmail.com [156.224.82.159])
	by imf11.hostedemail.com (Postfix) with ESMTP id 88D9B40007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:31:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.159 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782361880;
	b=CnC63SJNVvCm115bMAVZvpURs0jq6OGsKKjhKA6/A7xnphXSKuO6wLGqMlRAlvJhY0S4vO
	Kuaenn6e+ZJhGpm6OhzWAtNI8s7OHwMr6MAx1qcB9IepTu0jBDbbfzVBieahfv9PS+e5zU
	1ztLMVVzrL8EL+MovYHFPnRWDeuywIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782361880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=juaIh4SZpUTrUherJb+p/NKamOyH/T88LRXmOSHNADM=;
	b=Bhv4IfAladRLgIRP5ZCNEswU9wCmSEOYTSKyUy2Id1sTth2mx1r7gUWeQo5PKjKX9Z2uSm
	H1DK6XXb6TJsjNULEyTMvbSoPvCwHl/EXzCusaYftbRykloLPK0mrBbBn3W6A85Me9BGE4
	4KTsA0KcSy4ZexDdLvd4g9CDwTke2es=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.159 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1bdf898ae;
	Thu, 25 Jun 2026 12:31:14 +0800 (GMT+08:00)
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
Subject: [PATCH v11 2/4] mm/page_owner: add NUMA node filter
Date: Thu, 25 Jun 2026 12:30:59 +0800
Message-Id: <20260625043101.338794-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260625043101.338794-1-zhen.ni@easystack.cn>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9efd0be2100229kunm7d49e2638b4eb
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSUpIVksaSk8YSh0YTxpCSVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 88D9B40007
X-Rspam-User: 
X-Stat-Signature: qaoqqk4wxg9qbc5ohzsg6duigkonsdby
X-HE-Tag: 1782361879-846405
X-HE-Meta: U2FsdGVkX19dK6rCnTIySzmPwKjLep7Nvq2mbybgFu2MmwEyzrGpyL/Z+c67GEMdfISlHJWl8Vdfemb4uoYVu1/9qx1XX9lzuF9O11ebwdEaTa/u7U/x8kTZ904XHHK9JtO3N4TBBim/YiH0TEF1eD34LM93w5iSjxxdV4iIYsALClrnsS1srNY/TF5XMTZma6nRc+0Nz9JMQsjVo6IXj3dt+xZ9pKm9Ty+Ad5ZvqveASpfeLEz6p8CTs1Fi9P4oxs06YfSDVaKXU4NoN/ZnR1OoT5SA7yppHpand67PznT/UE7hQi7Re8hg9zRsegqmBADvzPBfxkWp3NBvyN8jQSiBgYmyLS6qmv0Y0q2ViHj8z2t/MfbJorG8UkmMw66uorRjSCl/aQ/PAKR3Ovecjd3zWppjj9XkvIIgVQzkMXwt07iYgENbFTBGFExRteqYaMxbZC62AOVxh4/HWgMLn6flEJr1E/LLmsSPvJbpCEnDTnayrmXqpLckR+VKpK7n+qyr7iounu9o53RZhwinpXop0TO4rsMx9fmXPamL3FPk/EOBJtJ89FPIrAKhJyCKe0itwfXUOi0OoPJ2FZCwsSvUlVE5/qORii7RGK4bws0Lbm9x+Jk9ZLNDCvxRPsRgpkqt0PCzWx8nvcv7JGdMFydVTbNaQ0XOlkUGBefyn64qime4sY6+1Y1oSBZIRIxA2okNto+lYtTFMt8wQPDLFRGwiYwN8CW4PEJ6Sl3cSPDKD0OG8XV5Id5n2lPQOmkBAqp1QnXBiVJjRRXEU7pbFVn3lUCKtJ4W/V+ysGqghmyYaoBj8X2jul4SVASNLAj8LNBw2FtlKtLA1z6F6O2wMatnGs/EwU0k34MYr0U7ONgXyd5zfaqRtzsAMlEeoZ8VbI5gHrpp04ZnwE2CFdcOBPeGEYtUIwREeWApgb+3kah0tgKofZ3V+LkbxKOYk4uUBQYhbbMyE5LWG7goWu1
 cmIr4fIT
 m5IUcwWIn8LAQhGj77GRPQa2uOXuJNtEvAs9Ek+SkGwTTUwoJvIML70+k5k6MAWUw81HdrypBLucFh/iTaLElnnveiE4xDgDdcyiNx0wHn2lvj8c0FPQ9rJo1IuZJvIXC4sHf5ot4gDgR/Mat40Rf15Whvq0HVNyc+WMkY5rh+5CGM/Y=
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
Changes in v11:
- Remove 'nid' member from struct page_owner to save memory
- Read page->flags directly with poison checking

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

v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-3-zhen.ni@easystack.cn/
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
 mm/page_owner.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 7595735979bf..cae5abf0ac9a 100644
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
@@ -774,6 +777,27 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (!handle)
 			goto ext_put_continue;
 
+		spin_lock_irqsave(&state->lock, flags);
+		if (state->nid_filter_enabled) {
+			int nid;
+			memdesc_flags_t page_flags = READ_ONCE(page->flags);
+
+			/*
+			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
+			 * VM_BUG_ON when accessing poisoned pages.
+			 */
+			if (page_flags.f == PAGE_POISON_PATTERN) {
+				spin_unlock_irqrestore(&state->lock, flags);
+				goto ext_put_continue;
+			}
+			nid = memdesc_nid(page_flags);
+			if (!node_isset(nid, state->nid_filter)) {
+				spin_unlock_irqrestore(&state->lock, flags);
+				goto ext_put_continue;
+			}
+		}
+		spin_unlock_irqrestore(&state->lock, flags);
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -783,6 +807,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		cond_resched();
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


