Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA900CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5336B008A; Fri, 15 May 2026 05:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3558A6B008C; Fri, 15 May 2026 05:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A3D6B0092; Fri, 15 May 2026 05:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0460F6B008A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:20:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAC351A08DC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:20:03 +0000 (UTC)
X-FDA: 84769107486.19.A2CF58F
Received: from mail-m82157.xmail.ntesmail.com (mail-m82157.xmail.ntesmail.com [156.224.82.157])
	by imf11.hostedemail.com (Postfix) with ESMTP id 79FB64000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:20:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.157 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778836802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JxGrdnm+ISWJ5h/DvlkzIEIqXX+aFewOBtoUjnI0IFM=;
	b=fAOssNj6g5GNP/HZ9GlKiR/8gBUDp/LCRDAuPShUV4vGn6/45WSMDt4ZNV0uQvCoWsThKf
	YMkCOUTC4yOsMaXPtN8GE5Z+oTnj1B2F7L+3/HUppjR1Z8z8XJEAT6SHsAkiIV8jqK/b0i
	ETd1PTXm4ZmFcvuSpda99xMvG+f4b1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778836802; a=rsa-sha256;
	cv=none;
	b=8cJ4I8xvVSBqUMzRzyaTITCLibnW6szbkDCEei/A6Lx/uouzRKI6b0fQNRDc09agCZC+7z
	QIeN/U4tEFfvHiaYRb+nHf6a2Qd62TfEvKeovewFYI9nx7kj0fZuf4rtMb2ciGaEPjArQv
	LRjSDRbNV5CubmeAu8+lZ7l2ciSxCUM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf11.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.157 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a2c1b5ae;
	Fri, 15 May 2026 17:19:57 +0800 (GMT+08:00)
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
Subject: [PATCH v7 2/4] mm/page_owner: add NUMA node filter
Date: Fri, 15 May 2026 17:19:40 +0800
Message-Id: <20260515091942.1535677-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260515091942.1535677-1-zhen.ni@easystack.cn>
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e2aef775d0229kunm2e28cf4e13722f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQxpIVkJOGE1JTB9CS01OGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 79FB64000A
X-Stat-Signature: 7pzwde4pnzgz54po5xju7jrws6g87bdf
X-Rspam-User: 
X-HE-Tag: 1778836800-926666
X-HE-Meta: U2FsdGVkX1+OeXHrl8BJvpcewqUjcHsWBYBzXtEVKOSbX9ugndRFWP/oMV1SwQxpDxh1k4Jb1IeMhRlhStvyiKQkcDg6y3wVwuxB4uf+zpLou3BN8JM1HJ679kGk0N9o5M6Rh8NiSiJDHbwfDyd1zmO0fSEpqPFs107Iw39Rj854u9NrAqQqHou+b4XqYl/ZGj/UHvFyPAHjxyQqhrtq9Bg7bIi/AXe9rxwW+avugMlACRVMZUHj0Rzvq3m+f4ofnhHAzuip0Fkzc6YQIgRCwaeDv+KVzIZ4HUhfvCxKWk/8/5oeWNE0agNTx84xWmRfQXzeO9qs1eH68Esx2Y2Gmsl1xFqkUzNguzYjdu0ca/eMbQwZg+0gMEl3jilFVGcjAKFSwvJOIBqTAnNaF9AMECGCuvrV4LbyFSYK9wCkJ/Y1c0a83QzgliNyZwdwERaTjp9QeBdBeCYmbgWZHAT0BIMCB/Ijw/RzNvK/hMJAO/2Dbg+pPTovg3eeYxhqORN+y3lzqEqXllkImpj9H9X7TBQKpf340Vd6yXNPCNcTjfSHRFxpohWqChQrtdcisQWhobrO5V2R1pjdfq/yxM+VSybHN/aP57EymNTKl4lKlDNkyGgTa/du0djzDKMkpY/uyqAtkg388S/iRNiOH53brZtwoMF28kbBraZnKNqJlK5bJ4Ze4R8NyQ2dq7TzEoSElC6EJ8eFU9fusoPHk+GykF+q9mBscHo0zbPmliJ6A8N9eyIxO4FdgL/Gkzcz4z0l0WA1w0v4qoL1yW1cqfJCkWz3cZSgmmk3wguA8iSd7YhKdwxFkps9NDB2qpwr1iqjjBecGo19sORIjvwZAh5/8KzUNz72yF1JtbprZzxoQ3NZXI5Jf5WmLvwPOOqA6kyv4D4GS6K836CNF79O6qwaJbC3/Yq3t3QiwHb/xkYw1vTNW/CT/kR0njTLX8SiA+VjvCSq5NXdfpaXBlHWNjw
 dw/VcyIO
 rVqfR8FIjtdJA/uzu1PpLeG5n/SvYsUxG/oep1mFus7Qn+AuYZx113CDusW8S+gPBn6IGTI/+OLAtUsp+FnzsHyKLKx1wr8YUOaUUqAR+N4HIdQXYHBNxY/QzLjDKLh5vpsVlSx5Md8idqWza1M5U5gHwYCM6+oMHiGuNYnXIaEFeOD0=
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

v6: https://lore.kernel.org/linux-mm/20260511033017.747781-3-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-3-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-3-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-4-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 43 ++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 40 insertions(+), 3 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 559d9782ac0a..1e5f27cdc177 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -68,6 +68,8 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 };
 
 static bool page_owner_enabled __initdata;
@@ -764,6 +766,13 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (!handle)
 			goto ext_put_continue;
 
+		if (state->nid_filter_enabled) {
+			int page_nid = page_to_nid(page);
+
+			if (!node_isset(page_nid, state->nid_filter))
+				goto ext_put_continue;
+		}
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -880,6 +889,8 @@ static int page_owner_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -899,12 +910,18 @@ static ssize_t page_owner_write(struct file *file,
 	int ret;
 	size_t max_input_len;
 	struct page_owner_filter_state *state = file->private_data;
+	enum page_owner_print_mode new_print_mode = state->print_mode;
+	nodemask_t new_nid_filter = state->nid_filter;
+	bool new_nid_filter_enabled = state->nid_filter_enabled;
 
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
@@ -927,13 +944,33 @@ static ssize_t page_owner_write(struct file *file,
 						token + 5);
 			if (ret < 0)
 				goto out_free;
-			state->print_mode = ret;
+			new_print_mode = ret;
+		} else if (!strncmp(token, "nid=", 4)) {
+			ret = nodelist_parse(token + 4, new_nid_filter);
+			if (ret < 0)
+				goto out_free;
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
 
+	/* Update state atomically */
+	state->print_mode = new_print_mode;
+	state->nid_filter = new_nid_filter;
+	state->nid_filter_enabled = new_nid_filter_enabled;
+
 	ret = count;
 
 out_free:
-- 
2.20.1


