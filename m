Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA039CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 04:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9376B6B0088; Thu, 25 Jun 2026 00:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F1A6B008A; Thu, 25 Jun 2026 00:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF006B0093; Thu, 25 Jun 2026 00:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50F756B008A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:31:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD3BF16708F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:31:20 +0000 (UTC)
X-FDA: 84917160720.15.916D542
Received: from mail-m825.xmail.ntesmail.com (mail-m825.xmail.ntesmail.com [156.224.82.5])
	by imf31.hostedemail.com (Postfix) with ESMTP id D47622000A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:31:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf31.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782361879;
	b=yHNewylLV03B3X1JGctcTTmvWAJfC7YCwkRWcHlY8qT+a4ElrB5ZuYwZUg7wmSPuvW9+/G
	ozdiahcgIwfQYQUj78EaKgB876U0WvSs6DYQiG9SfJna3H0CsNMJlvKXwnW2ZAULEsJkjS
	uhb0iE+0lqk2fK3NZul1XowNokQa+NI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782361879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wivHc15MmYqf2UKbTAM6Cs87U7fhFeFcmlstMfbbafc=;
	b=I3SvOvDDMph8hvyN4Ry7RRJAabi3WrxLNbmV2NLbQVhjLbzHylOrnnFBIXo/7LIReBHov2
	z0nkcJuYN2ZD+SJicH+fiGKYRHHzzCWSNq4H+FuO2bLJDL+paWw+wACRwYrUjHsttxQt5R
	Uj16U8uPC/WDgjVbspFSwXLuGnYLa5w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf31.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.5 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1bdf898aa;
	Thu, 25 Jun 2026 12:31:13 +0800 (GMT+08:00)
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
Subject: [PATCH v11 1/4] mm/page_owner: add print_mode filter
Date: Thu, 25 Jun 2026 12:30:58 +0800
Message-Id: <20260625043101.338794-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260625043101.338794-1-zhen.ni@easystack.cn>
References: <20260625043101.338794-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9efd0bdb0e0229kunm7d49e2638b4e2
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGkgZVh4YS0pJH0NLQ01OGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D47622000A
X-Rspam-User: 
X-Stat-Signature: 8r36c8sn14ktw7cr5r37s4e836kwzstx
X-HE-Tag: 1782361877-824765
X-HE-Meta: U2FsdGVkX1/Ifak6xuUCWCKsZmR3XDlp5ACKdDB9E/j0UiYr6owjNNA8LiEAlTjCVvu2ZGJv8bO7IirWtUOudwTqhRR+QWS9FbBv1befNjVjTMWSwsyxsCy7JHS3gccN5y9kU+Tzd7eapH8pctJsL5s4qlQwMTwk35VcogdIEV8w8Gs8nGkzKZzRGuShN/Y9xFYbesPtDKx9yCkyajXvP/ss9lUQcRPobaFE4RxHJuXYc8z3KOAeAqFArhCfgFZZEUgIuk/RzdOXCZYBQX2eDmoHcnul7MRFpb+ksMgNWWG4NRSjqRcOXq9FLYdbXpTc3qhFXXpNMfa5UeUlX0a9aygCIxGxqXTyn0+ddb+LXG8/DqoY7UdhWkRgWnFDeufz47DTUN8UjUwehoC1fLS1oMF7gw9CCpwOuxOM32u9w20ySs80oqfrXsBmSlCcbxxMOTmtg6/Pu49PCp6ysVX15JNzlJ96i6k0/BMt9CjG313WFnct87N+IIhar+MoazScx3T1yargadnHiVl13ZSOBHqceRRo+lbhWZskQmGfYFF/EMG0o61EWjR2VaUlU5EDhCEUVeHqCN0XyPIUNkKzo592ODjc9VyE+WvF1DS0mTC5+KdSCJA1S9tH0JoVNgEdof+4+bcxAMd9Bvu7pkp22gElupYaSn6NvT0L5htbwNLufgQzAaf0W0AOeomALS7WKpz8Eeffpb4rQYTsNqyICLE322RLWPeczJGnUheI4V3lsu68bB583tRaQkq1E6BmIKcLQ8c2rQiOt+3RTl89O2jpC9m6D/B3IcDQvVy5QGa54RaX9WSTLW3ad/atPNvQj4porg30CPaZtFgUJHa0jpt787RERx69jRc6h8ZPbY2GnD5sbsFrjOHEaMIMCoe8MOccHXEUr4JHTQo8Myl8eJHx0knRPcLioWunFJpwLYmBPzaRPQzF5UBhUslTQlEQPULow4oVrAAsL7jkVxE
 hKi4II1x
 2U+p3o+J4AT8F3yHz8igWiVVpguIvByfKgr5k7N//54nAfqHbAusHWwHFLoqHczspE1h4WdD3FUUugpzNxNgv+hsUcMbcS9qpn8L/Ka2aHTkE5DzV++8JxIX6w/Ftf2N6VY+t2Cn0vDiuwFtpsJRHDRya/yVkVa6mC7uo1BNxkew76Ow=
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
Changes in v11:
- No changes

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

v10: https://lore.kernel.org/linux-mm/20260618035750.3724613-2-zhen.ni@easystack.cn/
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


