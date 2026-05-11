Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBAACD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 03:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97EBB6B008C; Sun, 10 May 2026 23:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86BBB6B0092; Sun, 10 May 2026 23:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8BC6B0093; Sun, 10 May 2026 23:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66CD46B008C
	for <linux-mm@kvack.org>; Sun, 10 May 2026 23:30:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 29E5540569
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:36 +0000 (UTC)
X-FDA: 84753711672.28.E7FDAC9
Received: from mail-m825.xmail.ntesmail.com (mail-m825.xmail.ntesmail.com [156.224.82.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id E7D42A0007
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778470234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ng2Hy5Q6mHskRShtNRqY70LHRNT2NpBWgi73My4TcHg=;
	b=yuDShvAEcsb04nmGLK+YCyN/iBxEakn61ch+8sMVFIiwhsljXoGZpe7/xYxFI/sPwxqxRd
	G/aLXNBj1S78ZJ6oU1f6kmC2DrWZ0iYS3jpEhz/ChF4LnYiHFdgnbyldhtkiSWQHBETaIU
	JfuIz1rkt16BMP66pDfN9qDGIaPShoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778470234; a=rsa-sha256;
	cv=none;
	b=gTChN9a2KEUjXeyadDiVxyvrm4X9jGxqXEeu6Ar6CSNVQZdUhvij0Us2FZGa9rijj9RNaH
	BpXcNthCXFa0vMCbHJX/n+Wmuy7v8LyAoSC+OPSUPov3R7UzuMBInHuNFYKmBsQZ2ShJaf
	KmpLQI1tWtgAGlh0Z/gkBgcaZipLkrU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf15.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19f361878;
	Mon, 11 May 2026 11:30:29 +0800 (GMT+08:00)
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
Subject: [PATCH v6 2/3] mm/page_owner: add NUMA node filter with nodelist support
Date: Mon, 11 May 2026 11:30:16 +0800
Message-Id: <20260511033017.747781-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260511033017.747781-1-zhen.ni@easystack.cn>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e1516158f0229kunm0464dab52dcf0b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCGh1OVk8fGEJCSklKTh1KSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E7D42A0007
X-Stat-Signature: 4dyjt89bair9om71st1grs9hzn336uit
X-Rspam-User: 
X-HE-Tag: 1778470233-299060
X-HE-Meta: U2FsdGVkX18OFrKjAM/DsBk1qJrzY7CQv9oY6qY9agWCf2UKIpJT7vIo3iFtSZ1g8GnJiIsqZlehKTVWNyJTCZ9rRJDO4+g1JHTjf8OvABjRG90f2Lt6/6llk3i/shrn6UyAv2quRnRUJu6yNujxuAEFAvyUyxYKaa/QrFnX4W5k0J6kjur87aERc7nv6nd2ODQF+JF8Z4swhaTt2BpJyxu6k494DmdCAYRkuyST5r5WPoEO2dnJh/h5tpm3CSrhT9pvgJiaXH+tQP/d2fJj7ex2R7AL7cOwmWeUKUG2PgCmomsxFELWaf+oMeJs6qd9Lz5/BvwN7aCLtKzdX82nnMWUdyEFsxZYka3/4YuTRi/xp+B8EtYzJXRr1Fb//8eQ3n7Kx9x8MhkvgodwGdPfFYBYsD+qOgcA99JEti+dc3fpsu7QTsmVLg4QVA7tKMkZCC/LbDq9rIZvMjmrR+zU3p+kgbb5SOGhqcQ2oklIv29gQtQkvfUx6gbQJ5joqtGBT0F4L+EjX98ofwtkrhGn5H7v8B/opi7f/Ow0REXFCB8oP4khHXhheVucjQMuo14p8ybuaak+muBhJjAsm6REGGBd4W2oZ2kIon78c51caWjWkFWP1nK1OnpHuaXQXRzQfb6VdbWCIJezvcbs9dUIKQbtLS8r8OwBiwixXcpRX+fXSMXAyfVLkDk6HuLg7YBGsupCB26gsLQGYTQyTf/NRMm6rHPqtxdRRqTJcJJ/3qifQHV37c6fZJPMcAXZMOkLPmdexScNgJOKO9iMwC9JXp1MAUkiLp3mW8VRDP8n8kgYGjOpIsrBSzL7mvF1G0LkaA3GUxrqSzP+GvbrEUSCl7Ei5PDePgNHCNB+iY35UTJeMJhyIQ4L7AviSQFXAThPgEmVkVGdmEfFpP8GBuot8B7YC63iAxI7oIyfxxLoe4VOwo0WsiAgJjfEf+CbFeoHuzWAYKb6lqC2igtmj2y
 dTwXr3hy
 HyHJ3c66LIIkrkyU34rRRoToVZtFHE/eHmVeODYtmWyutfB6c7zJwBoIwUaTya27KQjwz8uZCpeD+eBIHbei7bq2dE3BoXIgIgnYnsgIq2otfd92y+sZBkDyw8PzbjPD/zIb2Tn3PXXV/TUwhD8A7LiOA9g31mJhW/VkQE+xgRRRFe5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add NUMA node filtering functionality to page_owner to allow filtering
pages by specific NUMA node(s). This is useful for NUMA-aware memory
allocation analysis and debugging.

The filter supports flexible nodelist input formats:
- Single node: echo "0" > nid
- Multiple nodes: echo "0,2,3" > nid
- Node range: echo "0-3" > nid
- Mixed format: echo "0,2-4,7" > nid
- Clear filter: echo > nid (empty string)

The implementation uses nodemask_t for efficient multi-node filtering
and nodelist_parse() for flexible input parsing. Empty input clears
the filter.

Note: Access to nid_mask uses plain load/store without locking because
nodemask_t is too large (128 bytes) for READ_ONCE/WRITE_ONCE. This is
safe for debug use: low-frequency changes and torn reads would only
cause temporary inconsistency in debug output.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

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

v5: https://lore.kernel.org/linux-mm/20260507064643.179187-3-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-3-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-4-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 92 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 27a412c52d41..8a38005539ff 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -67,10 +67,16 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct page_owner_filter {
 	enum page_owner_print_mode print_mode;
+	/*
+	 * Lockless access: nodemask_t exceeds READ_ONCE/WRITE_ONCE size limit.
+	 * Torn reads acceptable for debug interface with infrequent writes.
+	 */
+	nodemask_t __data_racy nid_mask;
 };
 
 static struct page_owner_filter owner_filter = {
 	.print_mode = PAGE_OWNER_PRINT_FULL_STACK,
+	.nid_mask = NODE_MASK_NONE,
 };
 
 static bool page_owner_enabled __initdata;
@@ -687,6 +693,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	nodemask_t mask;
+	bool filter_by_nid;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -700,6 +708,9 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
+	mask = owner_filter.nid_mask;
+	filter_by_nid = !nodes_empty(mask);
+
 	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
 		/*
@@ -732,6 +743,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (unlikely(!page_ext))
 			continue;
 
+		/* NUMA node filter using bitmask */
+		if (filter_by_nid) {
+			int nid = page_to_nid(page);
+
+			if (!node_isset(nid, mask))
+				goto ext_put_continue;
+		}
+
 		/*
 		 * Some pages could be missed by concurrent allocation or free,
 		 * because we don't hold the zone lock.
@@ -1043,6 +1062,77 @@ static const struct file_operations page_owner_print_mode_fops = {
 	.llseek = default_llseek,
 };
 
+static ssize_t nid_filter_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	nodemask_t mask;
+	int ret;
+
+	/*
+	 * Limit input size to handle worst-case nodelist (all nodes).
+	 * Worst case per node: ",NNNNN" (comma + 5-digit node number) = 6 bytes.
+	 */
+	if (count > (6 * MAX_NUMNODES))
+		return -EINVAL;
+
+	kbuf = kmalloc_objs(*kbuf, count + 1);
+	if (!kbuf)
+		return -ENOMEM;
+
+	if (strncpy_from_user(kbuf, buf, count) < 0) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+	kbuf[count] = '\0';
+
+	/* Support nodelist format like "0", "0,2", "0-3", or empty to clear */
+	if (nodelist_parse(kbuf, mask)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	/* Validate that all specified nodes actually exist in the system */
+	if (!nodes_subset(mask, node_states[N_MEMORY])) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	owner_filter.nid_mask = mask;
+	ret = count;
+
+out_free:
+	kfree(kbuf);
+	return ret;
+}
+
+static int nid_filter_show(struct seq_file *m, void *v)
+{
+	nodemask_t mask = owner_filter.nid_mask;
+
+	if (nodes_empty(mask))
+		seq_puts(m, "\n");
+	else
+		seq_printf(m, "%*pbl\n", nodemask_pr_args(&mask));
+
+	return 0;
+}
+
+static int nid_filter_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, nid_filter_show, NULL);
+}
+
+static const struct file_operations page_owner_nid_filter_fops = {
+	.owner		= THIS_MODULE,
+	.open		= nid_filter_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.write		= nid_filter_write,
+	.release	= single_release,
+};
+
 
 static int __init pageowner_init(void)
 {
@@ -1058,6 +1148,8 @@ static int __init pageowner_init(void)
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
 	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
 			    &page_owner_print_mode_fops);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &page_owner_nid_filter_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


