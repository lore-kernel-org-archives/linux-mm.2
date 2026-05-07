Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21ED8CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 06:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14B26B008C; Thu,  7 May 2026 02:47:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6B96B0092; Thu,  7 May 2026 02:47:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DA96B0093; Thu,  7 May 2026 02:47:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 864706B008C
	for <linux-mm@kvack.org>; Thu,  7 May 2026 02:47:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F21D8C71B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:18 +0000 (UTC)
X-FDA: 84739692156.18.0C6702D
Received: from mail-m82132.xmail.ntesmail.com (mail-m82132.xmail.ntesmail.com [156.224.82.132])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97F77A0007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 06:47:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf25.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.132 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778136435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vEzFKfROnIC3mtTJqH1QfURQL2clshI9fxSWNfidBLQ=;
	b=VdgJWo/tM1ZO4/CYH0bNVzFUYRWD0CWec68akz21BGsTnds3QBXxfz28TekeR30gHeaJqu
	Neq5z1jyEWp4LbycFqwhos+344piCW195LNmJdqHjBx4LpY40Rd6j7CDmmGK92xjI2r8oe
	2hleFQ22YOc0a3kS+avbwNyZW1mQuc0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf25.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.132 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778136435; a=rsa-sha256;
	cv=none;
	b=wpYaifcj+BGQoaqxS8zISt2t3Oigc94cMqiThupJlna8BpHOkD7L1h44+jxzc/9vFCj03y
	0fWTBvlLSarqfIQVshpggv5K1ekoRqcWKRqUt6ZtQnpv6hSFJnZ6vFzQUonqoHpz2gWAxK
	hHS+TG5Sic2gazBI2jAIY/pwfWcGpGE=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19cdddfbc;
	Thu, 7 May 2026 14:47:09 +0800 (GMT+08:00)
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
Subject: [PATCH v5 1/3] mm/page_owner: add print_mode filter
Date: Thu,  7 May 2026 14:46:41 +0800
Message-Id: <20260507064643.179187-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260507064643.179187-1-zhen.ni@easystack.cn>
References: <20260507064643.179187-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e0130b1c80229kunm3f68df491bc94f
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTx8fVkpJGBkYSR5DHhpLT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: kryw54ni8hzj5i3kwaq5k5ot73jx55ob
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 97F77A0007
X-Rspam-User: 
X-HE-Tag: 1778136434-165348
X-HE-Meta: U2FsdGVkX1+GZWfNfUROC+SVmb6h6Zl45dDmDICKuTKpb8FnDQbBb93STxsnitMqyC8CVU53hH0bxkbwgICUfDtb1GAUP3pOv4L7lsjVbdxG4w5BJGKAWnA7ACT3GbUq/pWWal7BZzCg3XSMZohRbJCrKYQZmC921NsGihG1s49yO7Rym09Y9KCjgcGejkuQBMMGkAcdxl8fxTkft3rajY0NNxfzSc/Wu+Uw4HP6jg9Z29yRIWFUv4GfTd0bCJ4KSJEplMm+sHgVe2JGU8BPlNec3JNNI4fZDqyOwdm/hWLtuC+2yhygxpqeE0ugqnwV1wjV6FxfR0H81LIE4wQMcAZYdlOnuqzf5/c9Ql3Bcp9D7RnITe5FK1b1BfDAg358SEzM2YwaoWMTjpzx/RUD6JHdIEw6K8SufPfH+cVKXECFQmtRzHKUaj45R9TKzWGun0iJSB9lXl7alkQzBJzShPI/5TgTfyPrLV7bbbAZPz3i4vs5UpJwA86kXiL6rAiiZiiYUXcVLXazEhZGrPtuXI96/tLk9rc/I+LBNH9Mdh3tYzRuS2qQZoIcqODKLYUdKT6JBLQNNEIgFm/FvOXTSFpliUwgC36lF1jULzPeP7whhfbomN3IETJgEmNvMKBwguKG00jcW6h5v+QCMFn9uAykUijtIPX1lZE581AJ0Rmhsx005gqwi1PiG7Fu0kOiLEdyj1VuMypmGRbmpCYmmY1n+RphI40MALlCpYHzJR4w6wl+u5qSKBuqyi1k6Wn7qDr/WRLezyP+ev4MD7CT02T4DhFxR0binPG5gSFDT7DR1NeM6qCN89F1f7cBq21T1WpH82T0J2gPIVATKUf+r57dAR8fJiUo3zrNh1ac+orwnGgFcQkyABmD+0LYTCESRIivlqHBRLHjxBoyHQFMT0KsMcfWXelo3jUW9j6RSCItjRuIQ7W13Nh9+EcsZO8nOiT3czBWpfxVR9ITGrB
 8C567ZhD
 gQ8as1ZWGsl0ct8u66xDNrHW//pSnUY1NjNF6gJ71jWboHpbrjnGWqED0XX1I099bjcT5nJH8N7E95bTFrYXKnSVnhGKW8WcAaztNrhaYPvVvdd2EcWkwDEXgTuIZWIGwlwiWL0swRdqQa0A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a print_mode filter to page_owner that allows users to choose between
printing full stack traces or only stack handles, significantly reducing
output size for debugging and analysis.

The filter provides a string-based interface under
/sys/kernel/debug/page_owner_filter/:
- Reading shows the current mode with [] brackets around active option
- Writing accepts "full_stack" or "stack_handle" strings

The default full_stack mode maintains backward compatibility with existing
usage, displaying complete stack traces for each page allocation.

The stack_handle mode dramatically reduces log size by showing only
the handle number instead of the full stack trace. The mapping from
handles to actual stack traces can be obtained via the
show_stacks_handles interface.

Example usage:
  # echo stack_handle > /sys/kernel/debug/page_owner_filter/print_mode
  # cat /sys/kernel/debug/page_owner_filter/print_mode
  full_stack [stack_handle]
  # cat /sys/kernel/debug/page_owner
  Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
  pid 1, tgid 1 (systemd), ts 123456789 ns
  PFN 0x1000 type Unmovable Block 1 type Unmovable
  Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
  handle: 17432583
  ...

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v5:
- No code changes

Changes in v4:
- Change from numeric (0/1) to string-based interface ("full_stack"/"stack_handle")
- Merge infrastructure patch into this patch

Changes in v3:
- No code changes

Changes in v2:
- Renamed from 'compact mode' to 'print_mode' for better clarity
- Use enum values (0=full_stack, 1=stack_handle) instead of boolean
- Update debugfs filename from 'compact' to 'print_mode'
---
 mm/page_owner.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 91 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..28766c854d02 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/debugfs.h>
+#include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
@@ -54,6 +55,24 @@ struct stack_print_ctx {
 	u8 flags;
 };
 
+enum page_owner_print_mode {
+	PAGE_OWNER_PRINT_FULL_STACK,
+	PAGE_OWNER_PRINT_STACK_HANDLE,
+};
+
+static const char * const page_owner_print_mode_strings[] = {
+	[PAGE_OWNER_PRINT_FULL_STACK]	= "full_stack",
+	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
+};
+
+struct page_owner_filter {
+	enum page_owner_print_mode print_mode;
+};
+
+static struct page_owner_filter owner_filter = {
+	.print_mode = PAGE_OWNER_PRINT_FULL_STACK,
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -575,7 +594,11 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE) {
+		ret += scnprintf(kbuf + ret, count - ret,
+				"handle: %d\n", handle);
+	} else
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 	if (ret >= count)
 		goto err;
 
@@ -970,10 +993,71 @@ static int page_owner_threshold_set(void *data, u64 val)
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 			&page_owner_threshold_set, "%llu");
 
+static ssize_t print_mode_read(struct file *file, char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	const char *output;
+	int mode;
+
+	mode = READ_ONCE(owner_filter.print_mode);
+
+	if (mode == PAGE_OWNER_PRINT_FULL_STACK)
+		output = "[full_stack] stack_handle\n";
+	else
+		output = "full_stack [stack_handle]\n";
+
+	return simple_read_from_buffer(buf, count, ppos, output, strlen(output));
+}
+
+static ssize_t print_mode_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	int mode;
+	int ret = count;
+
+	/*
+	 * Limit input size. Maximum valid input is "stack_handle" (12 chars)
+	 * plus newline and null terminator. Use 32 bytes as a reasonable limit.
+	 */
+	if (count > 32)
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
+	mode = sysfs_match_string(page_owner_print_mode_strings, kbuf);
+	if (mode < 0) {
+		ret = -EINVAL;
+		goto out_free;
+	}
+
+	WRITE_ONCE(owner_filter.print_mode, mode);
+
+out_free:
+	kfree(kbuf);
+	return ret;
+}
+
+static const struct file_operations page_owner_print_mode_fops = {
+	.owner = THIS_MODULE,
+	.read = print_mode_read,
+	.write = print_mode_write,
+	.llseek = default_llseek,
+};
+
 
 static int __init pageowner_init(void)
 {
-	struct dentry *dir;
+	struct dentry *dir, *filter_dir;
 
 	if (!static_branch_unlikely(&page_owner_inited)) {
 		pr_info("page_owner is disabled\n");
@@ -981,6 +1065,11 @@ static int __init pageowner_init(void)
 	}
 
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+
+	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+	debugfs_create_file("print_mode", 0600, filter_dir, NULL,
+			    &page_owner_print_mode_fops);
+
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
-- 
2.20.1


