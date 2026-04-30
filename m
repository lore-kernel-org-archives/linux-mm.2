Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FCFCCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B980D6B0096; Thu, 30 Apr 2026 12:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B48736B0098; Thu, 30 Apr 2026 12:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85676B0099; Thu, 30 Apr 2026 12:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 972226B0096
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:56:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4772B121CEC
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:07 +0000 (UTC)
X-FDA: 84715766814.29.60A2A37
Received: from mail-m825.xmail.ntesmail.com (mail-m825.xmail.ntesmail.com [156.224.82.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id E488340002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4q250BtEv4viv+ANI4nfZNkmuWeV+IpraVi9dMDXEkE=;
	b=tqJfjul8XPThQhLGJz9s0xvFLcmezgZJAKYMsrQo75LEyYHpNLxy4HNuD4+y4peI+eZk1x
	7d5ENbDjTTerA6GoPfUNmLjaif/yuxH6luvYr4ojaeMFyCiQxEPSv0UL32v/2YPwoDO7S5
	YmjHO4Be6XuYzLQmjB+wQgO6aH3vEh0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf12.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566785; a=rsa-sha256;
	cv=none;
	b=b/FGP6v9hIwPjYrpx2STDczsGMY3XOpoyYn6F/w6EWTmWdqnSpZUuqsbnc3fgz4IX7E/dI
	VRMzfn2gLxHBg0yx2/4FPKUlv/quSVNG390c0BjWFqq1tWPrNXQJDhZNxung1TdD2vMaZt
	sFRlKhP85DvnGCTiu31UhD5eXrlgZxo=
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:e24:8c24:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 199a96d50;
	Fri, 1 May 2026 00:33:00 +0800 (GMT+08:00)
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
Subject: [PATCH v4 2/3] mm/page_owner: add NUMA node filter with nodelist support
Date: Fri,  1 May 2026 00:32:46 +0800
Message-Id: <20260430163247.13628-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260430163247.13628-1-zhen.ni@easystack.cn>
References: <20260430163247.13628-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ddf3c8d010229kunm7d32d45d8a84
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDThkeVklJH0tMQ0tMSE4YGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHklPQUMYSU9BQ0NKS0FDHUxPQUMYSU
	1BSVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Stat-Signature: dxo4oa8kcn97edq7o1ysiobr7cinwg3t
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E488340002
X-Rspam-User: 
X-HE-Tag: 1777566784-982256
X-HE-Meta: U2FsdGVkX18qnenBBetOYTswLiWKbAGI+ytc2UGsHbQj/dOeUGoqMTN6ra8KM8Qm4ezEYCOYCcd8g9EbKXEGf0OUKtwxSmtsut/3MuR+c4dxk9h3P7vXZfS2pUVNj+0jLkOR7pbTDxWesLasPM2kuQSYqyaUuTfYkPe/Zo5Qg9o0cPY/X54nmbTZu0/7JRswST8sDGpzU8rjJIWBNX1c5yfgmP9HMLqAH5CTY9RTQNYnyc6uKOa7Apqt4Kskhgq+ecfKYizLU7yKAd46DdAZhYPvnIQ2+6cFSc0zIgQAPT6uKe5LTTMBvJFOBr+UrjXbd98RwqWLh5w6sbg+/FtJvA03ZSk44nDd/g8bs0Zy5SaNYjXiUb3wXZkStL25avgMCjPTZZuz38kjhn7LKjKKipnf8YAK20i3cYfofjWhqYMsFLq8Zvc+3vYPgVF9SO4w5JXW+WP3LMYvBX5orYN+EiwBkLuBot2rY2+fRFrx5kAHeKemeCCbw8yg65owWY3HyR4syD239cgE/1X55LaNajO34uue2D/Ug9r/0xKT5qXb4hKqIXl/x/NmkPimEQ1RZ0gnAY7CaxxTG8VrAlEAm3wogEK+rM8Q33rMaT19wz1gx+2D/FG/7GfH4+MFFgO1ZIYysjqg0uJawHpJNZioC12hOu5viHayybpVzk7CJn9iejLmFG5dTMsGrwRHUzQft5AC1iDDaQu0JiVNGoUh20/TnrC2CX6X+1izv17jQD+Cg7A6eIFy4kF+hJWrRBgUiSrKcxaA66a3RCpCnkz9M2jEwJHgsvHlSCjddcjZXThb8UZV2LdGjI3jqNioDj/ubxlLFpOk8mSa9LpsM5AVUyCIhJRzF/7mC5c2YwKPmyJXLfEwI2dyiUMUueUM1f6fhmMJF5RwP10jQBngFEjN4eynBt5Z2kJJdiQ59oPuq+2IKTUdLEK1wItilN0DH3RAqqnmrBvZJ2AZFvEB7il
 cePZLUBK
 Mpm0BCpEhCgr3n4qC7yp9XUaW0Z//53+HzkV7nE2amieVp8NAaHbvaV0ES/oXSEc8CC8T/cWOqppQ3ZhajAHvGdd1YrFr4h9TfxUswcp9zrjsiWBXD6L1zRxoexeGkk6MIPPOsZ8uP4FCZA2OFRjsy3RJ7pdBLp+eii1k7ZI3lBLW+p4=
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
---
 mm/page_owner.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 28766c854d02..68dacf01c822 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -67,10 +67,18 @@ static const char * const page_owner_print_mode_strings[] = {
 
 struct page_owner_filter {
 	enum page_owner_print_mode print_mode;
+	/*
+	 * Access uses plain load/store without locking.
+	 * nodemask_t is too large (128 bytes) for READ_ONCE/WRITE_ONCE.
+	 * Safe for debug use: low-frequency changes, torn reads only cause
+	 * temporary inconsistency in debug output.
+	 */
+	nodemask_t nid_mask;
 };
 
 static struct page_owner_filter owner_filter = {
 	.print_mode = PAGE_OWNER_PRINT_FULL_STACK,
+	.nid_mask = NODE_MASK_NONE,
 };
 
 static bool page_owner_enabled __initdata;
@@ -687,6 +695,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	nodemask_t mask;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -700,6 +709,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
+	mask = owner_filter.nid_mask;
+
 	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
 		/*
@@ -732,6 +743,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (unlikely(!page_ext))
 			continue;
 
+		/* NUMA node filter using bitmask */
+		if (!nodes_empty(mask)) {
+			int nid = page_to_nid(page);
+
+			if (!node_isset(nid, mask))
+				goto ext_put_continue;
+		}
+
 		/*
 		 * Some pages could be missed by concurrent allocation or free,
 		 * because we don't hold the zone lock.
@@ -1054,6 +1073,72 @@ static const struct file_operations page_owner_print_mode_fops = {
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
+	 * Formula: 100 bytes overhead + 6 * MAX_NUMNODES
+	 */
+	if (count > (100 + 6 * MAX_NUMNODES))
+		return -EINVAL;
+
+	kbuf = kmalloc(count + 1, GFP_KERNEL);
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
@@ -1069,6 +1154,8 @@ static int __init pageowner_init(void)
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
 	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
 			    &page_owner_print_mode_fops);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &page_owner_nid_filter_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


