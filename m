Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97ED3CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 16:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2D836B0095; Thu, 30 Apr 2026 12:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE4E6B0096; Thu, 30 Apr 2026 12:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4986B0098; Thu, 30 Apr 2026 12:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDB756B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 12:54:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 474D99CD87
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:05 +0000 (UTC)
X-FDA: 84715766730.22.5EE6ED9
Received: from mail-m824.xmail.ntesmail.com (mail-m824.xmail.ntesmail.com [156.224.82.4])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1E9B180010
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:33:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777566783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEzbCdGX756P7RboKvO8XJtoxdnO14ut6z0JmIHqDII=;
	b=IuMXQ6e+vMZev3xCqpg/WX+/FyvyQ05RXQRPghUr9PCZ041/DTUHtNKgQ49lPqE2NoFkBd
	BPP06LFp+a0Im4uiwItcRHgUlLSufZx6NSSdCzvxdPoWXlRh95eTY2U9xGvMJ2MA+jw3qt
	Urm9azcjGa8H7rC/+PBWtVXpH9pxdmY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf16.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777566783; a=rsa-sha256;
	cv=none;
	b=KdC13bnyX0kxStDOgAXcZHM7ygZWYEM7rOSaS/NwilhCPMDR4mifQsbnHEPyGNc5QtC/kB
	+fypqJ6Iq1L8QrmvkOlxueAoRhwxKz/r12M4fpSN/CYrESoasI8mBSu8dzBxIDHUfaCuA/
	UEbThhYwEGeO/woAN3qbeMk5HIe4v3s=
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:e24:8c24:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 199a96d4f;
	Fri, 1 May 2026 00:32:59 +0800 (GMT+08:00)
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
Subject: [PATCH v4 1/3] mm/page_owner: add print_mode filter
Date: Fri,  1 May 2026 00:32:45 +0800
Message-Id: <20260430163247.13628-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260430163247.13628-1-zhen.ni@easystack.cn>
References: <20260430163247.13628-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ddf3c86c00229kunm7d32d45d8a83
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDThlMVkwaGR1KGBhKSRpLGVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHklPQUMYSU9BQ0NKS0FDHUxPQUMYSU
	1BSVlXWRYaDxIVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1E9B180010
X-Stat-Signature: feh7aifye3eezuyoixqj9j4ejyr53g4u
X-HE-Tag: 1777566782-626094
X-HE-Meta: U2FsdGVkX19KTU8dcNHhMP3+1Ftceg4aqFEc6HKg7LVB+5Kpu5VEe1axw2xOWmtKa8r3axr2b4gEa7MHfVaGyE5IX106vU0jTqyOBA0JuCaftnk6F9bALmGvkF1f7V2FVXNiCfobOlzZtGUfdmk4H8XhP2OWQbg823Ei/iCAS0PkSyxonRoN7WhFpe/WM4B7SLvJJkW1Vgx+zpPaN0Mgzwdewx9GcBaHZMNRUi+fno1d79akdQlWGsV71lvYNk6mksvYJ0lIuB5WZl+uVA+BdEUGyXzTVh31dPvwNLrwcBddisCi4bduucO/TnJL5+wBsiBIM026jAMIzwJFR/jOBQFab8s9dJ4Fkv79GxtoXb0RNHqbO+3wjOTbKQmyVb9f4D1JIXWxgsDuBGrT8wXeRHyIn9P5qjKm5xIOD7W15y49AdIFTHRI1w2AgCIgBPl7n9VvnSdZgWjndfFRp15qAuxo1gwvK8OIP0q7mQBd658LWr4CLAShX6KobZQumFfdCxrFwby5dm51FaCa+OOzWzTfgRKpL/YtKICQ7mYH4ktb9046G5BQsiYUTSOk75MKBZMM7z11bf9Oap0Xm77cPyJ0AesZ9xgofaFrHHYCE5iXGVj6F5ck/rXTZadPrZPnGZYJJx0N74WlwKkS76JLKjY0Ipvy5djlYwBB7Rpsa1lHGI69gBhiMYgzPPFRD1MXFB8d2PA3x/FlXMaz1CBaWKjH1+hHTC9d2Plze01y6rh8JoFQVg4MSJu1+n908OH+yXMY9+q6Mem7wWsdQZwf0CEhAb0KY6Y4Fj9Q5Q19i+rt9RIgwAcc1Quf8ZrxiwNtUm5GKbX5hOrkizOaCCpiuj9mlC32oSYHWQzV6d0h2yxpZzeDhduVBxF24d6KbmzNV7SbdmIxCscZee1RSFWinqMUtZbZOrS+waQNwumH9EQUI3HIJ5v20i8CLfDq19dAaZJcCVv1P3rVAujWJ77
 ddSRLJUN
 IdsSnjl9aMTXEf34n7TBSsYW0rxwZrTKtQprfjHUlQnuXNFwTnY77XJs1lCxMA1ZdT5OiFLrNl/WTXCztzDLE4VbJMYfV8/M0vL/e3s2f14OlnozIRhnCnYc+3o27UHl9RwPpoFjrBARvvyfujiz7Fn54ZlIBkjIsluqP/aboadtbb3c=
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


