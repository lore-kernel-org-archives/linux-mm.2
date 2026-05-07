Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D7B9CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 06:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808116B0092; Thu,  7 May 2026 02:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 743D56B0093; Thu,  7 May 2026 02:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56F276B0095; Thu,  7 May 2026 02:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4673E6B0092
	for <linux-mm@kvack.org>; Thu,  7 May 2026 02:47:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 045FA160420
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:18 +0000 (UTC)
X-FDA: 84739692198.26.92E3039
Received: from mail-m82134.xmail.ntesmail.com (mail-m82134.xmail.ntesmail.com [156.224.82.134])
	by imf17.hostedemail.com (Postfix) with ESMTP id AE6F840005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf17.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.134 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778136437; a=rsa-sha256;
	cv=none;
	b=VEl6SFFaXZk0t/1sHIkc42oIwMIzQSFmAjNJcnWOPMSAjql/XnAPcbGgECAaFfjwnND08W
	/LjHcpefQlC2mvwpeozaJQl8CHws6qlMXuTBOPA9POCoff+xJThjAyimFCy5ajQQAueUY+
	EaOS+ESN4fGSiH3Cg9ZXMOzN/sNwn7c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf17.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.134 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778136437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1SkBx3hK/MrS+FMBywohizSaX3Hfqi7bzKk7ziazqGg=;
	b=0K9P1BZ2KjDlwMzRgaWGOQaXb5UPEpkSkP4tIzTiR6zTkxifyeOKTUAKERlNYw4skIPV+a
	GoK+TfgfxJy3TxJamwBod3axZXTm1tEbQUnInaKz1JZ5gj97yAsBUwyu6pU3gBnQF52Vlz
	knWe+QxS45DSSozMDM8rtgWWaWbPMR8=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19cdddfc4;
	Thu, 7 May 2026 14:47:11 +0800 (GMT+08:00)
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
Subject: [PATCH v5 2/3] mm/page_owner: add NUMA node filter with nodelist support
Date: Thu,  7 May 2026 14:46:42 +0800
Message-Id: <20260507064643.179187-3-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260507064643.179187-1-zhen.ni@easystack.cn>
References: <20260507064643.179187-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e0130bcd40229kunm3f68df491bc961
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSkgdVk1LSB4YSRlJHRlNGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: earqynzxny8dtk4z3g8qi93xm6xpxbkd
X-Rspam-User: 
X-Rspamd-Queue-Id: AE6F840005
X-Rspamd-Server: rspam07
X-HE-Tag: 1778136436-871677
X-HE-Meta: U2FsdGVkX1+WY1QzYOsFZe15o/0Iv994UD9uf2yj1BeTezmFEJygfK23SMUrbUZFft1arBkcQNBTdBoGx4sl9E72HB/16POQKq/cWdP/a54Z19ewX2dBg/MlbpgxKFba88/b4RRHv2rP8n1QAs5OzV6DrrYMqdcvqR38T6pltLsDRV3IWjCBDDi4O3AM4DcenZny8L3L0PBdBxTqhYv+1tZu4jmvVOp7CXQXXRo1F4teGesOvQpak2r05ovMBvWy8K1JWqY/+c+Flw+UFycb8z1zdzcLSNSQ8qMxGwGOBOsuzry0kuGXPcs8SYRg1h8anY1hs9+IObg8cFlRrzpLagABAb3jUVnaN11Vyb4I6KWZig8Z+xVPTJvNg50JpTgZF83DEjzRPj8/xa5IXb2QprLjIVKlg3+k4+lrxao3TP42yN7m8P1aM1xEEsXskJyii7u8LUQJPInfWXiBTkzIcnUq7shDaY7aU8chE6Io506TnrSIQ2VgZH3BvwQeDJ/qN8rLtw4iEYJsRYY7tN1pUmk1ZlqPx7SjOW0BVrQnfGmv7d6tr9Xr3q6vxdIoHAU4OG9I5Z3/mVF++cMgGTAeVaovSyOuRDzGOdvb+q/4kAxGSCRztRhauwpIe+eBwTKECIS1rOxcS18xpUySwI8lgtTjg+aaQ2vMRSf4WrKvG2/LexgTa71aSkNQX8qWzAR/+KBHLoFkUCQVI/aVAQYW0EMbwV5jRetMaXjL/aYLqMSzmkW+A60ykAqn0B2TnzqsSmZke3tx5Rp/m8lpcgKw30iM2t3YP9Ij1Hcg3qZdbytu5dx0hyxXHQyb5biml/hZb/ZENbppvPXumQJXxGwc9q8m119czy1vTZjW/6m/eIO0SDawf53//oHqgTnfMkFI+fOFEJMtA6dQt1LVMR6RwlxrxzMa8EKMBMk41wHGhHEce9IVtXp2wJ8Zkc1dC4iCOVQ/4eiW0eZwyhnSa+o
 7fKX3DzB
 g0h581HzXsB+lln0AgViW4Pbdvi2eS0z88E1ZnCRFKwNYUxvNEtUXXGn/I9458PgohL6H0V1eqmBQ5Pkiy/16QQNo4xycgIQOGXreTMKK/1U98ygpTrY+CfU0wcOt1e8vfP9fJKiQJyaDlA8=
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

Changes in v5:
- Optimize nodes_empty() check in page iteration loop
- Add __data_racy qualifier to nid_mask field

Changes in v4:
- Remove "-1" support, use empty string to clear filter
- Use strncpy_from_user() instead of copy_from_user()
- Add concurrency safety documentation for nid_mask access
- Rename fops to page_owner_nid_filter_fops for consistency

Changes in v3:
- Remove READ_ONCE/WRITE_ONCE for nodemask_t
- Add comment explaining input length calculation formula
- Simplify "-1" check using kstrtoint()
- Move nodemask_t mask read outside PFN iteration loop

Changes in v2:
- Use nodemask_t instead of int to support multiple nodes
- Implement nodelist_parse() for flexible input formats
- Use %*pbl format for output
---
 mm/page_owner.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 28766c854d02..227a377d6bb2 100644
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
@@ -687,6 +693,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	nodemask_t mask;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -700,6 +707,9 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	while (!pfn_valid(pfn) && (pfn & (MAX_ORDER_NR_PAGES - 1)) != 0)
 		pfn++;
 
+	mask = owner_filter.nid_mask;
+	bool filter_by_nid = !nodes_empty(mask);
+
 	/* Find an allocated page */
 	for (; pfn < max_pfn; pfn++) {
 		/*
@@ -732,6 +742,14 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
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
@@ -1054,6 +1072,72 @@ static const struct file_operations page_owner_print_mode_fops = {
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
@@ -1069,6 +1153,8 @@ static int __init pageowner_init(void)
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
 	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
 			    &page_owner_print_mode_fops);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &page_owner_nid_filter_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


