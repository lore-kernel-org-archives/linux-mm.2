Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048B2CD98DE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 03:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 893936B0088; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 844DF6B008C; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B336B0092; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3726B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 23:58:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 883121205E1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:11 +0000 (UTC)
X-FDA: 84891675582.10.AA42040
Received: from mail-m82130.xmail.ntesmail.com (mail-m82130.xmail.ntesmail.com [156.224.82.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id C8F461C0003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 03:58:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781755089;
	b=AjyrHRmgjD6iNzPPjIgs4pEd/7bwyeZFuzP8zOAbOZSvxlK+c9JhC2GhLIIeizlFHk53j2
	ry3j3WKmiuc2W+I3fBrw/u4swU9e0JS6Q67ZALq6+hWUy064vkazBDMpWZTDFXzsry5OlX
	eaLL/wMGAsiDhL9C1ZuZNG5fkUIe+XM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.130 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781755089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eGd0SRZc+psADwE/NhYHn2xTXoJ7CWMN36/X3hVMYjs=;
	b=Gb2HMjEndTLCLoX8kIMsekEDfHqSILJ+itRP1048ypZEA7IxOWRN5HRlzGSkvL/wXs5ZDx
	M1pcv86ObNVE1Kq2SYxuZiUKtN8JjaWWBMgiHTCVSKsEw9qLuSumedEBQoXwFTDc+N6WYh
	fUIsvPW05fHakuRcxcIoI5uIBOGs19c=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1b9899911;
	Thu, 18 Jun 2026 11:58:04 +0800 (GMT+08:00)
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
Subject: [PATCH v10 1/4] mm/page_owner: add print_mode filter
Date: Thu, 18 Jun 2026 11:57:47 +0800
Message-Id: <20260618035750.3724613-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260618035750.3724613-1-zhen.ni@easystack.cn>
References: <20260618035750.3724613-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ed8e0fce60229kunm88c9600fdda82
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaS01LVk1CTxhPHkpITRoYGFYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C8F461C0003
X-Rspam-User: 
X-Stat-Signature: igg99cqxag5ngquh9qpwxwhxoo5wz89a
X-HE-Tag: 1781755088-854223
X-HE-Meta: U2FsdGVkX195/9fvjO4LgTzzfxYGhxma01hV+TYZY8o0O65NbplWHCeUVwTOcMcdZPF47b24/1YCjB1qh45wfUqJF/wHUDvZ1PIKFjOYyMacZHx1q1FF2qFE53N1M7a2w0Agt6TfcSxX9PRmWzGEIJ3SgohVckE9d3RWGiClOkRXLi3ZrZKpOJAhVSBzzQANsrQS1jsxjrVVZ04Y7m8HFWbA5itPHeGlyYJOsY926A02eIS3GBp/xpIARoGKbRYS05jwsY6A2jqZTYZEymXcMpbN2iQItjzrlujR6JbqM9drYPsxKpdIvKhod0SHHes1K22sV5zsLFg2CGtNuA3L+kAt3evI7+JRfZNtT+XgVvdmt1LpwZpKI6aISm374FcpKImCAR+pO2XlEjepy/LRWPUCeSxsAe+eWXzFlHJy6z7MLMmCUGbxFcGJYp1KGFWn8TwLelse9WLKa2Sgek1Z/wnc29P03cGxWUCAMWSTdAzJ4wuJg4oUx7Fj0c+ob5Pdt4ufg/cRo0jbnM2ScHANlcKZnN9TMmkwJ4/SMVp+pIznRXtQiYYmlvZIJAwEiktGoIq0pqfvoPv8nPpBZMAhk7Dg8vfWbx64JlNrF5NaD8kIiWFvOQgO3Y/VdTZbP6yeI79vwZ2opAYD+ZRCCgaPF9INo/XMqTeiAtmPIyPs+89Evm9U4DU1cpHzi7uCDhP77KE7E/mb+cLDVCgW65CE6xTCjXAb2CR4iboRnqyU6pExRBRAvImMaimbqvki5XF3Hp9dgwtWu2pNQqTiTq/u5ynSg0Uqr8rNcOwPyX+1XsVHljJ6puCDwKG/pI7obi+mYM6Nsp9r5w+DeI/xdzWEWh6X/IQshrTWy8ud/o6wMMouJFTtWFqLL8DvAh8qZ+aVJ7vzkviBDusMN+iZN4q+4Z7sXna4L5P24NmYnjeQK7t49WDK+2I6yrX7eGRy1f5wGdAenA83PJeeBCWDXnQ
 gHVvcdio
 yKkvFL0ycS8SJ3buDYZLao3tK/Qk6ZnW50Nk0eCYVKuqSiQHMNftNwo+TYJzlufHpK6lQ8NJDCksAj0TwVLgYLLoX83MNLVG1rII9YVlBUmXnDYkkEPwGXLHevKSRoZkznTb0i1IYEJh6yVmlW+jYzL7z8YTADGQSgHMIHothQO9YlFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a print_mode filter to page_owner that allows users to choose between
printing stack traces, stack handles, or both, providing flexibility for
different debugging and analysis scenarios.

The filter provides three modes via page_owner:
- Writing "mode=stack" prints stack traces for each page (default)
- Writing "mode=handle" prints only the handle number
- Writing "mode=stack_handle" prints both stack traces and handles

The default stack mode maintains backward compatibility with existing
usage, displaying complete stack traces for each page allocation.

The handle mode dramatically reduces log size and improves performance by
showing only the handle number instead of the full stack trace. Testing
shows handle mode reduces output size by ~66% (84MB vs 244MB) and
improves read performance by ~4.4x compared to full stack output. The
mapping from handles to actual stack traces can be obtained via the
show_stacks_handles interface.

The stack_handle mode prints both stack traces and handles, making it
easier to identify pages with the same allocation pattern by comparing
handle numbers instead of comparing large stack traces.

Example usage:
  # Using the page_owner_filter tool (recommended)
  ./page_owner_filter -m stack          # Print only stack traces (default)
  ./page_owner_filter -m handle         # Print only handles
  ./page_owner_filter -m stack_handle   # Print both stack and handles

Sample output (handle mode):
  Page allocated via order 0, migratetype Unmovable, gfp_mask 0x1100ca,
  pid 1, tgid 1 (systemd), ts 123456789 ns
  PFN 0x1000 type Unmovable Block 1 type Unmovable
  Flags 0x3fffe800000084(referenced|lru|active|private|node=0|zone=1)
  handle: 17432583
  ...

This implementation uses per-file-descriptor filter state stored in
file->private_data, allowing each opener to have independent filter
configuration.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
Changes in v10:
- No changes

Changes in v9:
- Add spinlock_t lock to struct page_owner_filter_state for concurrent access protection

Changes in v8:
- Fix buffer overflow by adding bounds check between stack_depot_snprint() and scnprintf()
- Fix unsafe string handling: use memdup_user_nul() instead of kmalloc_objs + strncpy_from_user()
- Fix strsep() memory corruption by saving original pointer before strsep() call
- Change format specifier from %d to %u for depot_stack_handle_t

Changes in v7:
- per-file-descriptor implementation

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

v9: https://lore.kernel.org/linux-mm/20260525081652.2210206-2-zhen.ni@easystack.cn/
v8: https://lore.kernel.org/linux-mm/20260520075641.1931080-2-zhen.ni@easystack.cn/
v7: https://lore.kernel.org/linux-mm/20260515091942.1535677-2-zhen.ni@easystack.cn/
v6: https://lore.kernel.org/linux-mm/20260511033017.747781-2-zhen.ni@easystack.cn/
v5: https://lore.kernel.org/linux-mm/20260507064643.179187-2-zhen.ni@easystack.cn/
v4: https://lore.kernel.org/linux-mm/20260430163247.13628-2-zhen.ni@easystack.cn/
v3: https://lore.kernel.org/linux-mm/20260428071112.1420380-2-zhen.ni@easystack.cn/
    https://lore.kernel.org/linux-mm/20260428071112.1420380-3-zhen.ni@easystack.cn/
v2: https://lore.kernel.org/linux-mm/20260419155540.376847-2-zhen.ni@easystack.cn/
    https://lore.kernel.org/linux-mm/20260419155540.376847-3-zhen.ni@easystack.cn/
v1: https://lore.kernel.org/linux-mm/20260417154638.22370-2-zhen.ni@easystack.cn/
    https://lore.kernel.org/linux-mm/20260417154638.22370-3-zhen.ni@easystack.cn/
---
 mm/page_owner.c | 129 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 123 insertions(+), 6 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..7595735979bf 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -54,6 +54,23 @@ struct stack_print_ctx {
 	u8 flags;
 };
 
+enum page_owner_print_mode {
+	PAGE_OWNER_PRINT_STACK,
+	PAGE_OWNER_PRINT_HANDLE,
+	PAGE_OWNER_PRINT_STACK_HANDLE,
+};
+
+static const char * const page_owner_print_mode_strings[] = {
+	[PAGE_OWNER_PRINT_STACK]	= "stack",
+	[PAGE_OWNER_PRINT_HANDLE]	= "handle",
+	[PAGE_OWNER_PRINT_STACK_HANDLE]	= "stack_handle",
+};
+
+struct page_owner_filter_state {
+	enum page_owner_print_mode print_mode;
+	spinlock_t lock;
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -547,16 +564,23 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
-		depot_stack_handle_t handle)
+		depot_stack_handle_t handle,
+		struct page_owner_filter_state *state)
 {
 	int ret, pageblock_mt, page_mt;
 	char *kbuf;
+	enum page_owner_print_mode print_mode;
+	unsigned long flags;
 
 	count = min_t(size_t, count, PAGE_SIZE);
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
 
+	spin_lock_irqsave(&state->lock, flags);
+	print_mode = state->print_mode;
+	spin_unlock_irqrestore(&state->lock, flags);
+
 	ret = scnprintf(kbuf, count,
 			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
@@ -575,9 +599,18 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
-	if (ret >= count)
-		goto err;
+	if (print_mode != PAGE_OWNER_PRINT_HANDLE) {
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+		if (ret >= count)
+			goto err;
+	}
+
+	if (print_mode != PAGE_OWNER_PRINT_STACK) {
+		ret += scnprintf(kbuf + ret, count - ret, "handle: %u\n",
+				 handle);
+		if (ret >= count)
+			goto err;
+	}
 
 	if (page_owner->last_migrate_reason != -1) {
 		ret += scnprintf(kbuf + ret, count - ret,
@@ -664,6 +697,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	struct page_owner_filter_state *state = file->private_data;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -746,7 +780,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle);
+				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
 	}
@@ -847,7 +881,90 @@ static void init_early_allocated_pages(void)
 		init_pages_in_zone(zone);
 }
 
+static int page_owner_open(struct inode *inode, struct file *file)
+{
+	struct page_owner_filter_state *state;
+
+	state = kzalloc_obj(*state);
+	if (!state)
+		return -ENOMEM;
+
+	spin_lock_init(&state->lock);
+	state->print_mode = PAGE_OWNER_PRINT_STACK;
+	file->private_data = state;
+	return 0;
+}
+
+static int page_owner_release(struct inode *inode, struct file *file)
+{
+	kfree(file->private_data);
+	return 0;
+}
+
+static ssize_t page_owner_write(struct file *file,
+				 const char __user *buf,
+				 size_t count, loff_t *ppos)
+{
+	char *kbuf;
+	char *orig;
+	char *token;
+	int ret;
+	size_t max_input_len;
+	struct page_owner_filter_state *state = file->private_data;
+	enum page_owner_print_mode new_print_mode;
+	unsigned long flags;
+
+	/*
+	 * Maximum input length for filter commands:
+	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 */
+	max_input_len = 32;
+
+	if (count > max_input_len)
+		return -EINVAL;
+
+	kbuf = memdup_user_nul(buf, count);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	orig = kbuf;
+
+	spin_lock_irqsave(&state->lock, flags);
+	new_print_mode = state->print_mode;
+	spin_unlock_irqrestore(&state->lock, flags);
+
+	while ((token = strsep(&kbuf, " \t\n")) != NULL) {
+		if (*token == '\0')
+			continue;
+
+		if (!strncmp(token, "mode=", 5)) {
+			ret = sysfs_match_string(page_owner_print_mode_strings,
+						token + 5);
+			if (ret < 0)
+				goto out_free;
+			new_print_mode = ret;
+		} else {
+			ret = -EINVAL;
+			goto out_free;
+		}
+	}
+
+	spin_lock_irqsave(&state->lock, flags);
+	state->print_mode = new_print_mode;
+	spin_unlock_irqrestore(&state->lock, flags);
+
+	ret = count;
+
+out_free:
+	kfree(orig);
+	return ret;
+}
+
 static const struct file_operations page_owner_fops = {
+	.owner		= THIS_MODULE,
+	.open		= page_owner_open,
+	.release	= page_owner_release,
+	.write		= page_owner_write,
 	.read		= read_page_owner,
 	.llseek		= lseek_page_owner,
 };
@@ -980,7 +1097,7 @@ static int __init pageowner_init(void)
 		return 0;
 	}
 
-	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+	debugfs_create_file("page_owner", 0600, NULL, NULL, &page_owner_fops);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
-- 
2.20.1


