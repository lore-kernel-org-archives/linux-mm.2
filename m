Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65CD3EA71A2
	for <linux-mm@archiver.kernel.org>; Sun, 19 Apr 2026 15:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D6D06B031E; Sun, 19 Apr 2026 11:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 011846B0321; Sun, 19 Apr 2026 11:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3F16B031E; Sun, 19 Apr 2026 11:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C25F16B031E
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 11:56:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8FBE41B897C
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:05 +0000 (UTC)
X-FDA: 84675756690.22.FBA555A
Received: from mail-m82147.xmail.ntesmail.com (mail-m82147.xmail.ntesmail.com [156.224.82.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39F5E100013
	for <linux-mm@kvack.org>; Sun, 19 Apr 2026 15:56:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.147 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776614163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RHNzMtGXTQhrUh51PivqEDDC4JV6naWM8NkJTQ73aY4=;
	b=PlGM9yHTdCYFzupbozW6kKbChFnf109JRJL8ojYqLeVRPZmzqWFEODWlvT7rWD0Nw4N7IF
	vBrXCqVjClw0zrMD/YpYhl323FovgfZtXApKf5K7VjBdZGB9l2YJOc+ZPk6R8SyK0zh6mV
	7uR8QKugWudUo91ltjRb6Yd7VpWCoOk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.147 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776614163; a=rsa-sha256;
	cv=none;
	b=rQFqMrY43C5mYds3/MNxPJ3oKEKlhMCeOobhjzjXwyqdrv+OclP6IrfxNEyIuuWiy0tRsh
	ufwSZA5/xtqNZcK5z5UQrGqWB+L5vDKAae8Z6yqv0IIGkbyLfVAFefvK3jz1A7n9zUa5tn
	uvBlVnd/z6cGyLIGqJ5J6DsysB8TTOY=
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1918e52ac;
	Sun, 19 Apr 2026 23:55:59 +0800 (GMT+08:00)
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
Subject: [PATCH v2 3/3] mm/page_owner: add NUMA node filter with nodelist support
Date: Sun, 19 Apr 2026 23:55:40 +0800
Message-Id: <20260419155540.376847-4-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260419155540.376847-1-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9da674b3dd0229kunma1b4aa74234e94
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlDSh5CVh8fGRlKTR9LTUhKT1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktISk5MTlVKS0tVSkJLS1kG
X-Stat-Signature: zopmyf6xqtucgencrgwzgegyn8pdudsg
X-Rspamd-Queue-Id: 39F5E100013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776614162-340426
X-HE-Meta: U2FsdGVkX1+XgPK3WnnQav5xdWTYsi4IZdLhwWqyO1f7uBbzM+fuWN4R/LYVE1BpFdx4quXEMI4+02TwffPZASTTDG88ljDWUlE2ze2g+MyD+SchK4ezq1IxLPMU24nwyRavbeCOkSURFnhdHlgk4FjWm8eGLI397CJOOFo6xcool8BMiDiev/TkoFmFl8nHdrsBOdXEinSyiIhWq3RnBithpy6rQrq6q//wowKURde0DjcDdAa7q0UbCzbk+pA6RyVa5ox51Xvg6ci0CV7dUlNr2+ABccmOi4pTZQz10CflpTe9Cy0VFABfCjJrG8LFHIW7/rRONQ2n1dgwUkpoNOvLgi/0UawvyYw3FaBAxstZrDMD+obzpH4u/fRD3vJQj0xUlPHLrHMiOKWVHmrZFQwG/ns7xhnOCPALPK1NDj5mP5QWKybz3rf3jNZyThV6kskH+qLxdGf/gSsjM0KKCr0kzzNYYAj+PpsCsSvH62SgjJ7QJQCnW/iHJhikNRPYvyafb0QClK2j/Nu94kbluXuK4TYFIhD95JhcYHZtEg8eVfCdW5iQoAhfYhT396U1xtGYWU+7uGdvdCimrkfTbrmDh3QCHM7rxwha+OkvgNUCbNpZSPiEcS6CUS1GHJW7W76zNMI6ToSRryK7PF7niIG/22LUkNeWFMAEroMKUQ8pl+4csY2HGrLdfbupJuB2FI0ClxFWAnlfbk2xQGyVyZfkJ4AOOhCsoXFPX9EoX9G93kir/DXovm8YPL+5LZqlMZoliJ2yZNup2f2X6ANWmsZt7lxyLuxZy3zF2TW3ZrlHbSvU7hgAAp1BH+Qqez3ZMCrWLHgAlH/uv0kN/ClHJXbFvYpBbbstcj/73xMQMMaV1vcTzYwaxW3a3l5L20yJGGIKgsZgHv3vYt5nvF6BJJyVkTncK9qg5iPPTygJ4aRSrt6NCUbguPc3yHpURaRnvUZCt37EfYutxwZymbY
 M5IKI0gk
 AHogYwV5wvDYLVD5Pkr+nVUakwa+gUp83Nk/GL81Yj2KfrB9HWFhAo6Ub4M7fptY79J5JjUXqntPZnoveSSF8AzuZEO/r12PjE0HbfB9SjUBZBV7z1mUMCb5x4TDoHbwXP9FdzN86HeJBM5+qHf8tZKfYPx6jajdf3+60H9QN3kBxFsyO/V5dW903NmbDyzY9vPfbEmsTvEKrFsE23JKgLiLx6g==
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
---
 mm/page_owner.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 6d87b6948cfa..8c13bb3798d8 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -707,6 +707,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 * user through copy_to_user() or GFP_KERNEL allocations.
 		 */
 		struct page_owner page_owner_tmp;
+		nodemask_t mask;
 
 		/*
 		 * If the new page is in a new MAX_ORDER_NR_PAGES area,
@@ -730,6 +731,15 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		if (unlikely(!page_ext))
 			continue;
 
+		/* NUMA node filter using bitmask */
+		mask = READ_ONCE(owner_filter.nid_mask);
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
@@ -1009,6 +1019,70 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_print_mode_fops,
 			&page_owner_print_mode_get,
 			&page_owner_print_mode_set, "%lld");
 
+static ssize_t nid_filter_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	nodemask_t mask;
+	int ret;
+
+	/* Limit input size to handle worst-case nodelist (all nodes) */
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
+	if (strcmp(kbuf, "-1\n") == 0 || strcmp(kbuf, "-1") == 0)
+		nodes_clear(mask);
+	else if (nodelist_parse(kbuf, mask)) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	WRITE_ONCE(owner_filter.nid_mask, mask);
+	ret = count;
+
+out_free:
+	kfree(kbuf);
+	return ret;
+}
+
+static int nid_filter_show(struct seq_file *m, void *v)
+{
+	nodemask_t mask = READ_ONCE(owner_filter.nid_mask);
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
@@ -1024,6 +1098,8 @@ static int __init pageowner_init(void)
 	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
 	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
 			    &page_owner_print_mode_fops);
+	debugfs_create_file("nid", 0600, filter_dir, NULL,
+			    &nid_filter_fops);
 
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
-- 
2.20.1


