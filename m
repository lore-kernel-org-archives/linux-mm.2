Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E04C44500
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8BD76B009E; Tue,  7 Jul 2026 07:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B633B6B009F; Tue,  7 Jul 2026 07:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0DB6B00A0; Tue,  7 Jul 2026 07:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7997D6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:54:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0008A1A040C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:35 +0000 (UTC)
X-FDA: 84961823310.24.75ADB87
Received: from mail-m82159.xmail.ntesmail.com (mail-m82159.xmail.ntesmail.com [156.224.82.159])
	by imf16.hostedemail.com (Postfix) with ESMTP id E56C118000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.159 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783425274;
	b=3kMnzZCl/5iEuuyPeXR8FbuUHHqCYNGBRgBv327SwaET75YT3nMVR4zcXCnoQPf/7prRii
	PjmqoA/FX+CyKLUCF/Dypchb+2efF2quy1AxpgStMxZKLDIXZS09TeRlThSV/+jwKiOCfn
	L7CISvqLFngrsDnNRx/1CN4sYmx6Bns=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.159 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783425274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1a960TAgaXHCCOqKrsMZYJnlHHfqJlCt0gB1gr6gPIc=;
	b=08pydJ/xmtStXDo9iz4KuCc6fmKQ0pFVHzIA4yXgp+nyWBKC22uXr2sWuvoAfORN6JFafU
	KPhKFYU9n5dTx7GR9YI/VgDtfKhMT1s/zM8uTuKfVmVV/2o/oH31wbG6ee2Ah6JtqKjMdU
	RFgFwOTEZ1g2jh4d2X3VB42oPt06ekI=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1c66e4ef4;
	Tue, 7 Jul 2026 19:54:28 +0800 (GMT+08:00)
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
Subject: [PATCH v12 2/4] mm/page_owner: add NUMA node filter
Date: Tue,  7 Jul 2026 19:54:09 +0800
Message-Id: <20260707115411.1714314-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260707115411.1714314-1-zhen.ni@easystack.cn>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f3c6dfbe20229kunm476cca175faa2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaHhpPVhoaHkJIShhMGR8fSlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E56C118000B
X-Stat-Signature: t4n9ouyup1tfqr7khtuc9ynddtjds4ic
X-HE-Tag: 1783425272-68005
X-HE-Meta: U2FsdGVkX1//Ffo0fB67gnpoMd9VEkJU6T/aRk85DsL5pHGAYtYgOawz7ltF9ujpvj1UYeTH+ZDSYCT4q30OehHF1HNcR5klH0RrLYpukghKqSEx4dKep98I3epwGXkxDmWoJxtP5EFxmyYhtTB0joEZrFgUPx/T6KrsrxMP/ufKbao9fYBY5pWlE3gMBfo2os2YRbEtWmZZjj0oqcxMnuBVtodj6s61QuX/9K291CfxEo/1tmuRm1s8qJVUAJcZAthTEogwXv0tMGcpcVvj/bYVzjgzU3Vra6tzYgLw/1SHqmKq7ym6V/hGipWOopDdbfejLriADLEY/6DdX9danouEVoTdcioy62XScJWoIGfLx8BDBQf6tNvInC12+pftao+4Sd6hQBkFCfWlxY+MV3VHUgXbPoCPouINhoDFok76fWWoctwK+JZLb8ZiuszT20JeuCLCEFfAte1UaP9IF1mJ/pkKkTEwBXVpTkAxrrjytUAa01/oA8mujbimMRzHhJHv+FphQwizOWa1U0Ymh0+Yr+Fl2VzotCY2/+lB0nFUih59qvsVMrprnJ3zVFKIzPvnbuzTuIRRg7CzpVZNCJg9szZy1WrIKCm0NQnxlrtbOLGlXTo/yqLwxKksoYfSWW3vo8fRzecHOsEuvO7+jqNeOZlGWqFAZ+6CLxuu0sVY1u3IhwvQH2vcpIN0cYeFz++IHWgC+Qte8GKGDMqVyWDE6yvzjeWhW89fiktaOssY1jW0lpNqKkrfraJ2ZR6/J87csNcEsa1Ym8uBmjN8VizM1OY3oDfQHyUJaIda+pAAKek8MGbLjp1am77EP0w5dqo5MNT2poHJMZGdbVVYsxGpFd5kjd9U5PsFAvoIADwb77cddvxCrjrIOluusmrULKo1sx3dK1LYdT5OS1gpt+Co+9eDqKclwuUNMZ0M0S6U1/uDn+YzkEtxywxTvn0/7f0R3OOc8TOcD3Siw39
 C3hzTI81
 Kr+6JLVF9MdLKm91FljgIptCaQArWjL5YlOekd8kgHlR2Ophy/diI7oCC8VOhB5uCK44A/ZYjZgQ3FBbL5kyoYPK6RPhve/7vbmhCEvSyxR+s4Bg8cYSicLE6T2AxK3qX0B8d2aXgBoxz7XAyTJ/lfQ11d52jQuWGj8r4hgQNvW0iS23IF6R90yaU8tUF1DOxKTTx
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
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
---
Changes in v12:
- Remove spinlock protection

Changes in v11:
- Remove 'nid' member from struct page_owner to save memory
- Read page->flags directly with poison checking

Changes in v10:
- Add 'nid' member to struct page_owner and record it at allocation time
- Remove need_resched() check, call cond_resched() unconditionally
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

v11: https://lore.kernel.org/linux-mm/20260625043101.338794-3-zhen.ni@easystack.cn/
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
 mm/page_owner.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 976c2ed6e35a..f1d4c205aff9 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -68,6 +68,8 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 };
 
 static bool page_owner_enabled __initdata;
@@ -770,6 +772,21 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (!handle)
 			goto ext_put_continue;
 
+		if (state->nid_filter_enabled) {
+			int nid;
+			memdesc_flags_t page_flags = READ_ONCE(page->flags);
+
+			/*
+			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
+			 * VM_BUG_ON when accessing poisoned pages.
+			 */
+			if (page_flags.f == PAGE_POISON_PATTERN)
+				goto ext_put_continue;
+			nid = memdesc_nid(page_flags);
+			if (!node_isset(nid, state->nid_filter))
+				goto ext_put_continue;
+		}
+
 		/* Record the next PFN to read in the file offset */
 		*ppos = pfn + 1;
 
@@ -779,6 +796,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		cond_resched();
 	}
 
 	return 0;
@@ -886,6 +904,8 @@ static int page_owner_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -906,12 +926,17 @@ static ssize_t page_owner_write(struct file *file,
 	int ret;
 	struct page_owner_filter_state *state = file->private_data;
 	enum page_owner_print_mode new_print_mode;
+	nodemask_t new_nid_filter;
+	bool new_nid_filter_enabled;
 
 	/*
 	 * Maximum input length for filter commands:
-	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 * - 32: print_mode command max length is 17 ("mode=stack_handle")
+	 *        with sufficient buffer
+	 * - 6 * MAX_NUMNODES: worst case for nid list
+	 *   Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes
 	 */
-	if (count > 32)
+	if (count > 32 + 6 * MAX_NUMNODES)
 		return -EINVAL;
 
 	kbuf = memdup_user_nul(buf, count);
@@ -921,6 +946,8 @@ static ssize_t page_owner_write(struct file *file,
 	orig = kbuf;
 
 	new_print_mode = state->print_mode;
+	new_nid_filter = state->nid_filter;
+	new_nid_filter_enabled = state->nid_filter_enabled;
 
 	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
 		if (*token == '\0')
@@ -932,13 +959,36 @@ static ssize_t page_owner_write(struct file *file,
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
 	state->print_mode = new_print_mode;
+	state->nid_filter = new_nid_filter;
+	state->nid_filter_enabled = new_nid_filter_enabled;
 
 	ret = count;
 
-- 
2.20.1


