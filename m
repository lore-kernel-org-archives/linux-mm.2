Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD48FF886F
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:11:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2454A6B0095; Tue, 28 Apr 2026 03:11:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181866B0096; Tue, 28 Apr 2026 03:11:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15CD6B0098; Tue, 28 Apr 2026 03:11:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5EEF6B0095
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:11:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CC24A04DC
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:34 +0000 (UTC)
X-FDA: 84707094108.07.EC2AEBE
Received: from mail-m82135.xmail.ntesmail.com (mail-m82135.xmail.ntesmail.com [156.224.82.135])
	by imf23.hostedemail.com (Postfix) with ESMTP id 66E30140011
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:11:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777360293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RdXHS1hr8RDK14j9xYokQ1hctJShg5bOP/MnalEayIc=;
	b=7HEstzbTeHy1ZRyaXzA+PKgdHWlF9NBycvuiJSL4mrsqWDQdQZkWyflWZ9S+HRgfJX0jai
	MaDX66pZDoBXXsqxdQWUu86PfqcrufyEQp7MzLY089k+Au/k3CAoZljl6TsSriverwRMel
	ZfJJcAfQncXRkegEfmrR79PJ/slP2JU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777360293; a=rsa-sha256;
	cv=none;
	b=hqhnBJKzRc/6fUU43pwL6boY8VKa32pX2itKgli7WszVQgMfO/fXf8+y8XWuIxavavRfGH
	tnkySyiGdFHV9qdOJ4Y7m0gW8auenm63+zjfO6BginomAGPPikMUXfF7Lq5ysxV22LQ/U6
	txs0ENGXi/5p+D4agIRJtGikrvwnR/k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf23.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.135 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 197b49307;
	Tue, 28 Apr 2026 15:11:27 +0800 (GMT+08:00)
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
Subject: [PATCH v3 3/4] mm/page_owner: add NUMA node filter with nodelist support
Date: Tue, 28 Apr 2026 15:11:11 +0800
Message-Id: <20260428071112.1420380-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428071112.1420380-1-zhen.ni@easystack.cn>
References: <20260428071112.1420380-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9dd2edb8600229kunmb0c223f1156f22
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaQ09PVhlCH04ZTEwaHRlNSFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 66E30140011
X-Rspam-User: 
X-Stat-Signature: kkxwwxzn7ugousda5db844imnphfness
X-HE-Tag: 1777360291-189614
X-HE-Meta: U2FsdGVkX19XCJjMb8EW4ZanG7JDoNWAqgoXaGMNdhVxy+TBcgb152ac0obRbrl+jGbnlO4WzZkHmFYIpWn9n3NiEPpR2OSfCaj2PRNgPHR1Hw9uQVMIQxqxEQ5k/r27htuTK0ZJnBAhkR5TiTVnDKa06md0yvjehg7Vf6wvgEjLfm52pqIVduLSMJygNL5M+QRoeqfjL969xM4/CQg/VYqUn9pDWrYsvpN+FVHZ9cMf8+qbp/BUJ1LGKhW90fsYjx86r8x6OK/FkKgII0lHGBF3ule3qQCnz9RDioPBF8AweRKkOuADmow3D19j3XO2g1sLkD17Bm+7WqEa2xFJglPKrV2LmTrk2jFTZfGQ/T5g/al60vhoebeMf7ySMC0MGTNfi7kx79AGDIouULWP5fwMRDHgGNC5iqjKfHbqXVeVZuY0slY1DgDXSWstZXL8605WFanFHgK+CUYb3GHuqLXI1ls0Ao2DAhjEdVi4znVgyoDGDot8Vxso0VR7GIoRHMzPBjsUbhC9laS7j4YEUGpqZBpEzd1W29yH57Emhxq5WkC+BicnJkAKbBJnjWwEU8rPc0BG8iS9UiJJsqu97NeMGqlSGv4x7S3piCF6NCyjk/M068a732YFcN2qb6140owDEmqe+7F18UWHW5/MiSWYPUiq2fF+tQ416XrLbjjgdqmZQXirL24GkGRx8HhgTcZP9vzjvvzEX4GWT7FeQsz4as9jrTF40N7kxBYQWf83b7lZNBCnjIJiVLGwstKiv/N48Dz2+NLnYo733C/+z8/FzQP4gVpG2gXI8WoGgvRzTct6CzwGvGRISZVC0AwL3QnVGqJpn6g/mk64vJhLeHAFf1JxtPXtmgy9gMTk5jZLP2suhwMOazfZ5k0DFKdsRyVxyZEGMsOIF2cVy4mED5HIgQAgfkbvhIhp8hB99UFnQzOBHwoGdm39LITeSHXx0ZaXmuac/oMQ6S9/Qa9
 MA2+juos
 Eo8/KmK4+NNtpDBdyhLY7qe+w17fs9iRvGYzSoPJiNAqu6ZmSBXwzJPBfGl12rILmDf1vKbUj9mkEbzzv+MYqI8HSgTpVSuMSaLCYRkw9luSV0ORbOKohqPQC3Um/7Qn6fZKWwOulaPytM3qgPBwTDM0DTrzddH9mNnAwkISdm+/bTeZvQfTz9ehGHgprEBR7gK/E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add NUMA node filtering functionality to page_owner to allow
filtering pages by specific NUMA node(s) using nodelist format.

The filter allows users to focus on pages from specific NUMA nodes,
which is useful for NUMA-aware memory allocation analysis and debugging.

Supported input formats:
- Single node: echo "2" > nid
- Multiple nodes: echo "0,2,3" > nid
- Node range: echo "0-3" > nid
- Mixed format: echo "0,2-4,7" > nid
- Disable filter: echo "-1" > nid

Link: https://lore.kernel.org/linux-mm/20260417154638.22370-4-zhen.ni@easystack.cn/
Link: https://lore.kernel.org/linux-mm/20260419155540.376847-4-zhen.ni@easystack.cn/
Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

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

Changes in v3:
- Remove READ_ONCE/WRITE_ONCE for nodemask_t (fixes compilation errors)
  * nodemask_t is a large structure (128 bytes) that triggers compile-time asserts
  * Direct assignment is safe for this use case
- Add comment explaining input length calculation formula
  * 6 bytes = ",NNNNN" (comma + 5-digit node number)
- Simplify "-1" check using kstrtoint() instead of dual strcmp()
- Move nodemask_t mask read outside PFN iteration loop for performance
  * Avoids 128-byte structure copy on each iteration
---
 mm/page_owner.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 6d87b6948cfa..e674a374669a 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -685,6 +685,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	nodemask_t mask;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -698,6 +699,8 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
+	mask = owner_filter.nid_mask;
+
 	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
 		/*
@@ -730,6 +733,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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
@@ -1009,6 +1020,75 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
 			&page_owner_print_mode_get,
 			&page_owner_print_mode_set, "%lld");
 
+static ssize_t nid_filter_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	nodemask_t mask;
+	int ret;
+	int val;
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
+	if (copy_from_user(kbuf, buf, count)) {
+		ret = -EFAULT;
+		goto out_free;
+	}
+	kbuf[count] = '\0';
+
+	/* Support: "-1" to clear, or nodelist format like "0", "0,2", "0-3" */
+	if (kstrtoint(kbuf, 10, &val) == 0 && val == -1)
+		nodes_clear(mask);
+	else if (nodelist_parse(kbuf, mask)) {
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
+		seq_puts(m, "-1\n");
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
+static const struct file_operations nid_filter_fops = {
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
@@ -1024,6 +1104,8 @@ static int __init pageowner_init(void)
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
 	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
 			    &page_owner_print_mode_fops);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &nid_filter_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


