Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81312CD5BAB
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98066B008A; Wed, 20 May 2026 03:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6C06B008C; Wed, 20 May 2026 03:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76116B0092; Wed, 20 May 2026 03:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7A386B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:57:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69108120191
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:05 +0000 (UTC)
X-FDA: 84787042410.28.654FB2C
Received: from mail-m128247.netease.com (mail-m128247.netease.com [103.209.128.247])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3FBA020008
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf13.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779263823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HO5+kchXtDb9CAEeKekXYuQet+jplO1WdNxoQF69Lko=;
	b=Xqvr8688CO4PNCFx7nRBnYGph8MNPwquewRaZuTHiqtW6+78X+BrE7f0TWmCSdwp3wl334
	op1UcKHz4ziwUMt3FN+Pk0ECUbglHkemBcJ5kVPoPKV4loSOvln18KRQvvyntrAr1szX4D
	+PAlmM+NJizPf5tVI2TnpeREDSkCtzo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf13.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.247 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779263823; a=rsa-sha256;
	cv=none;
	b=C50zm2tq+2q7tETODhcJ79ezjqxQjekpcSpKMWyJUBsH4ulRxVxAm08OCWO7274dVSjvhe
	g57hPXbkgNeyfaulZMX6isE5STTppOQScv2fOG9Wx905nZNoqfHACbBVXG9g0J4tf2qowG
	4JJldPe6RgKRTsnHP1ZlSUfHHk1j36Q=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a5d18cae;
	Wed, 20 May 2026 15:56:59 +0800 (GMT+08:00)
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
Subject: [PATCH v8 2/4] mm/page_owner: add NUMA node filter
Date: Wed, 20 May 2026 15:56:39 +0800
Message-Id: <20260520075641.1931080-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260520075641.1931080-1-zhen.ni@easystack.cn>
References: <20260520075641.1931080-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e44634d2c0229kunm5cf2619843989
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaT0tMVkhPT08ZHUlLSEwfQ1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FBA020008
X-Stat-Signature: acnejjzpce5s7ca8sn9k16orpht66r3e
X-HE-Tag: 1779263822-134092
X-HE-Meta: U2FsdGVkX19I37jwPR72MtWzTg65dif5O1Q4jQ2kKI1kvcoqhcwkXXLvy10D4vfZjubhpkZezpx6RhVr/J7ylBdGnz9gZkQmIz0fbUXQngStKAn9378Q68zkqOMde3ru8J7bwPZkPlZPlfShf0bjGBp4Wqd6SYSej+PVQhbqXCvFpxt416iTn6dRDEJy5AS/CsQE0Pnx3XdedMabpp/OvaraCjW6LOgcmHOLOuCb3IG4XRw7+UxcaMTvURKRFdkn23d80XQLmjjTTN29ixUEFNthLMNYJrw8CVkJT8kvSJxqJmiBw11nrvrGMAgIbd230m0OVcYIAtD5Q5Uo6BDLkqwxagDOoh/aLZyZDf2s9UuExEer074GeVv2JzIe7v+J2/GuV7nFMhuEbFxRDvrq7wtr0heQXq8xqnzvuMkPDIAqYkbr4MVxsgrDbbGgZUgqYunQqx81NWluLKOUPSX+YNP+JUwiBm34v3OwSB0W4hA8AccoxxTez8jimGKh2e5oE5CB447bKtC95w/07slbPee36/I1SO1c1np78YMQrRXDogbKYT3ocLAbIRHJp9sSad2+62m0UwrWz8RxYob4QsVKTMF/EuJjfUDHY4zHco91W3JWPDGPaeAFEBl0hPr5BuSTDZvhxSsN7ztmkbfjhbgaZ2JcYW0asRVNe+6Ryc754zf7zs3eSemKxo/SVkTAP342ZQka7N1jw/Z3S44v4M9l/XhgtfQmTKR5eR/9re877H/rdzWx/Jy26UHqpXz6j6FRGKoY5qNw07wwNxZDfEqnTOqKMMOruzidgt175zQCQyPxjs2EiO8wkVlKJtJZFgOBhMcoE84lRv7gvr7xZ0FaQhTmLBjV5GCDFJrsNaKUtG4pVcEF1wrvKo7ZPLuVEfRUl4jBSBoW7kU7mHcpeVHgMPdt5xg20wbfULrG+noxjAijuMm5FMHmGknsSKvHXQpUcaRWBdax1Dj2aST
 /jn7qrkx
 ky3Ad/qFvF9NOJpKk7qTi7lMocCbo3r08fo3Jw7cNiu/tiOy/9LZL15zRSybujg2QarktHsFxXz2DI5l29+ARIeP9cji+0YhHmH+GP+BZe2BuqCQL8dKod6R8oTRf7tZvZEiIiMne+rHCYDD5oB2L18pEgiCV+bSV0IlKTikn9Jbake0=
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

v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-3-zhen.ni@easystack.cn/
v6: https://lore.kernel.org/linux-mm/20260511033017.747781-3-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-3-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-3-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-4-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 50 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 47 insertions(+), 3 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index d0c428d6cac3..59cfbc64a117 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -68,6 +68,8 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct page_owner_filter_state {
 	enum page_owner_print_mode print_mode;
+	nodemask_t nid_filter;
+	bool nid_filter_enabled;
 };
 
 static bool page_owner_enabled __initdata;
@@ -767,6 +769,13 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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
 
@@ -776,6 +785,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
+		if (need_resched())
+			cond_resched();
 	}
 
 	return 0;
@@ -883,6 +894,8 @@ static int page_owner_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	nodes_clear(state->nid_filter);
+	state->nid_filter_enabled = false;
 	file->private_data = state;
 	return 0;
 }
@@ -903,12 +916,18 @@ static ssize_t page_owner_write(struct file *file,
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
@@ -928,13 +947,38 @@ static ssize_t page_owner_write(struct file *file,
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
+	state->print_mode = new_print_mode;
+	state->nid_filter = new_nid_filter;
+	state->nid_filter_enabled = new_nid_filter_enabled;
+
 	ret = count;
 
 out_free:
-- 
2.20.1


