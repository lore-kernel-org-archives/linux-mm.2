Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A20E0CD37B7
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 03:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6F76B008A; Sun, 10 May 2026 23:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844A06B0093; Sun, 10 May 2026 23:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70C976B008C; Sun, 10 May 2026 23:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DACC6B008A
	for <linux-mm@kvack.org>; Sun, 10 May 2026 23:30:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 028241A03D7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:34 +0000 (UTC)
X-FDA: 84753711630.14.93EBEF8
Received: from mail-m824.xmail.ntesmail.com (mail-m824.xmail.ntesmail.com [156.224.82.4])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6902640006
	for <linux-mm@kvack.org>; Mon, 11 May 2026 03:30:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778470233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qeQbp31ZyZS8uMhn6EKf3OyCfLKx+RbVqM1BDmchXRs=;
	b=NiW+SbE7BR2lm3W6ttqY/8sL06auttBk1KrinI8mozHq0PWHIKC7MZgOD9ESBCKNeK2IFs
	tNcUoBVifQwoshTGV22kZ9f5eLgTaZ9zJwliR0TypBrcDbrVwAVyEE5+O00FRfUbYfxSJI
	LcQ0JSUABZvYDSEsJyaEBIZ80KMR0Fk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778470233; a=rsa-sha256;
	cv=none;
	b=6V+DMru7XtuDWGr0Qh/k1vJWZm0sqivsRW3mcObE/A6zTmsKFgaI9Smw+I3tFDcP+gfxy5
	FodR9wzgQHilHUqaZh/+JWPZhzwCaBP8xXBTTzlXLesG6QNF63jUDgLhqCOJQiQbr94N/g
	7rqsYM/9gLgdpQL+EKdCnhuupT0vB+I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf27.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.4 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 19f361871;
	Mon, 11 May 2026 11:30:27 +0800 (GMT+08:00)
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
	Zhen Ni <zhen.ni@easystack.cn>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v6 1/3] mm/page_owner: add print_mode filter
Date: Mon, 11 May 2026 11:30:15 +0800
Message-Id: <20260511033017.747781-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260511033017.747781-1-zhen.ni@easystack.cn>
References: <20260511033017.747781-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e15160fb70229kunm0464dab52dcf00
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaT0hNVhgdGB0aGkwdH09JH1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6902640006
X-Stat-Signature: 19xk8tfw1c8aw7m6i4xj5czosj6cb6zn
X-Rspam-User: 
X-HE-Tag: 1778470231-618576
X-HE-Meta: U2FsdGVkX1/aYObwkRF8NA//X3fmw6oqR4g3eKMWNQhA8IgWp8y7OrftUEGVOVwcCNrF00QXmm9OJ416DleIlz2TohcWUhFpDssQPi45Zuh2f+mQ9scBgwvQeb57v/DusnGl9v/I0FjFscbKhnT3AmvAeeMgJHGUt59s08Wx9ilvAllfSx+DmTAamYHfkUCjmjPZroah23HU2N7QDFYkwsq17pF5a0IVAForqSaga48xtzKrsX77dtPmc/n9aeWv6t9K0EaSbdzAQM7+hwSuFXuP7YqqbXv+uXlA/eHeYHfAqV4b9hLP7uXSao1W05f5DB+XwliRyfuCvxcY1OdQG6V4HeP4cbp/MgOVfZKcHgFI7Gks8en4m8AUYdLvDrSa2fbsrJUwZEop8rJHzNQ37LdabQiX0he8PhzoOb9ZcUfgQXtXvaigeRI6P+Wyqc7qCuR1Ie6VZLCUWedYbgkKXoceaWXhGrdWwJcgO5XYNwTlquHmfoFrJr3gaZWNL9D5G5lsusRA9YDt/DSufucHJEv48y6Q1QI9RITR3bHx4bhVa0dTIlHZhCnJTmWVIFjSFOa5M7jkoD4nBtu4bEkUKyBDm5k7nZsstvkIkLvaeyUj/+WcjaLyjtMIkTpgEfm/FflWXPLgyw0Gfy+ja9qP1KjOygt4bsGtNsouflv7lHClP1vlUi2W3y4m6x97REPvAkzIJmLyL6qwnRUlg8C9DmZlQ3HcFT0irVsoTRmiKlplu+Fg/EkrPXjUtIK3fdKXyq8biKkDk+1wVCCKOUDmqk/t0xSZF2E6sNA4ae1dLfceQBy3iUOlIP3aPF20zr4kwHG5KIOjmpjZLiSsjOwxy+LV3SAKNgGcU0tmmbZWHq7HcgwWEwiDsdmbBUKEYttkttmGoBdHCc3I9dnwi0USd1SsIanRmdBPcuTI5KgLVd64GyFK3mfyk94LhK7xpEi5XKp5/PtbfmJJEo4QpvG
 Css7qm9K
 V95KXA+lEwpOuZkR1Ng7+Bki6TC2kfgIMcE1MMNsj8lGn3pVFVd3pPNw2snyj1Lxh1Di2iR/aCPaDCw5qpjcSwpRnBDsdOEUCXY4g4ACSAMsxB5i3XTUn8x/fEYznnFaIg7Y5iTdPLIMrMV8iL3iedUDrcxyCYlBXGHWyw+NizihpKzc=
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

Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---

Changes in v6:
- Remove unnecessary braces in if/else statement (coding style)
- Use stack array (char kbuf[33]) instead of kmalloc for input buffer

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

v5: https://lore.kernel.org/linux-mm/20260507064643.179187-2-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-2-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-2-zhen.ni@easystack.cn/
    https://lore.kernel.org/linux-mm/20260428071112.1420380-3-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-2-zhen.ni@easystack.cn/
    https://lore.kernel.org/linux-mm/20260419155540.376847-3-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
    https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 82 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..27a412c52d41 100644
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
+	if (READ_ONCE(owner_filter.print_mode) == PAGE_OWNER_PRINT_STACK_HANDLE)
+		ret += scnprintf(kbuf + ret, count - ret,
+				"handle: %d\n", handle);
+	else
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 	if (ret >= count)
 		goto err;
 
@@ -970,10 +993,60 @@ static int page_owner_threshold_set(void *data, u64 val)
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
+	char kbuf[32 + 1];
+	int mode;
+
+	/*
+	 * Limit input size. Maximum valid input is "stack_handle" (12 chars)
+	 * plus newline and null terminator. Use 32 bytes as a reasonable limit.
+	 */
+	if (count > 32)
+		return -EINVAL;
+
+	if (strncpy_from_user(kbuf, buf, count) < 0)
+		return -EFAULT;
+	kbuf[count] = '\0';
+
+	mode = sysfs_match_string(page_owner_print_mode_strings, kbuf);
+	if (mode < 0)
+		return -EINVAL;
+
+	WRITE_ONCE(owner_filter.print_mode, mode);
+
+	return count;
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
@@ -981,6 +1054,11 @@ static int __init pageowner_init(void)
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


