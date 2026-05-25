Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17707CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 08:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4796B6B008C; Mon, 25 May 2026 04:17:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429AA6B0093; Mon, 25 May 2026 04:17:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3413A6B0095; Mon, 25 May 2026 04:17:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2475B6B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:17:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA8B98E31D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:17:12 +0000 (UTC)
X-FDA: 84805237104.29.F7CBB21
Received: from mail-m826.xmail.ntesmail.com (mail-m826.xmail.ntesmail.com [156.224.82.6])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4535B140008
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:17:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779697030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=INUu4dWH4/Mxum4Gqp3vuYNuz+IZwRx53uSoNoH2F0c=;
	b=xlKxAAD2rPaMPp0RwjepFtDEehEkbPyZlTZZ123ICcw6OzzfmlpUG+doyH7EQwSni7iW9u
	wOg1tnAss4ytMbMgcugbPOAzn0BTzI9wr5L7BdpgsqWMAFlpdxBmF1Va9usWzJqO76P7P+
	DhOgtc/Q95KbCsub4jgYIWq/is3g9ZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779697030; a=rsa-sha256;
	cv=none;
	b=YzC0NZu4sZmK8Bl01Viz6I3u2Xf1nuA+arH6IBH6NaTchoHV1TSiHaH4Z/OdKVIhUaADQq
	NFXIgTULpFeTvcwpfeHOp3xhqD806jRwO+w7FqQ97nwnKQKlteIwH/KTcvfpyK/mXAo4TL
	WoGRtTPBNFzhA3BEpjNlmh4UJsRY/zs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.6 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a8ce5df9;
	Mon, 25 May 2026 16:17:05 +0800 (GMT+08:00)
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
Subject: [PATCH v9 1/4] mm/page_owner: add print_mode filter
Date: Mon, 25 May 2026 16:16:49 +0800
Message-Id: <20260525081652.2210206-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260525081652.2210206-1-zhen.ni@easystack.cn>
References: <20260525081652.2210206-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e5e3581b90229kunm9b83604117f12d
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDSEIZVh9LGENKGUwdGUJKQ1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Queue-Id: 4535B140008
X-Stat-Signature: xuhgxzfd7nr6xdjaiq5jepqhgm1fzigx
X-Rspamd-Server: rspam06
X-HE-Tag: 1779697028-984944
X-HE-Meta: U2FsdGVkX1/DYEVDNTWRnD9+GqR2P3RtG11p3RFLQoT02uLsd/TIwKckbCj6MQ4NT82qXePWxF7dQS2il4kC7CE/IwF1AWTkEi6o49D6T1eCH/EDjh0SFPZT0TMf1DFFEUyl3mogKH7h7iFfYZ4YnPdsaDwNpnawmeFAw0+Afyvn21hmio0FaiRzcua8reLgUMxnaF/WY8pGvA6nODdQRccLoqLFmswVR4DxW9T9tj/WMwqx6Z7v0lICnfxiB2evDr8BC9aauRREEmzmxVIXlL8AG6Z5CjtKRg9dE90+XMuMjmrQGACpqB32yndsrRQJ7Yzzi0pUiRAwDA/yBz1sY323NEgZl4NmtJumH7mZxKWwNxlo/yYTDSIl462w7PKlwG/NSMza/HRxAtb3zcMc3oWxU+2a2AlLMnq1Ptb2HSd+r1VHzOghR+7/iwisBUn3DJa3v/oMtWRSJqj7nX3fgaz33weC83f5SSmBGjxg+TWTFxt5hFlxEKWliT3xGsP94acniGNJ/Gfg27cT8uTdKe27dUij+OcjG5JoGJjLODqcmSzi9eAR7GwNY5U1K7WjISARytc98pMbxLEPu6q8K0qoUQ3E2HeAoInAB+8VmvlxPfUDyxQd8G0yvyRjj6MY4sO9cDX1mU55cLDXiMkSspNF/CkctxfqK/Qs5CNp7dRHrpjkTKqxjMWKWrQRxIhYE77qqxFgSrKQRPICI/am47GzSd9XBiM8IcBco9CExiy6T6zYBammG0m6y0Us6f2Jlr8k8RZa1K4nyHYH0zW5pqY2QzXJ4KZZGcuifV+y9jKpQJ8689lqO/FT3g84rUgAm/6I9qjHaHnwSfvmu5/ihe9btN3hDLAKKRSXF6tIHQbGwHvFhr/8tlHSc2MPK3kgD4fQdtwwaNJbwOSEomNkvsVaTB7NzT3JM0wr5M6uRzrhxBL74DQm11mzYktTZpDiiwlKeYfoK0JgODZi8wJ
 YGyUS1wD
 aXMuX3pMNvLpAsHeuLTQaOo12YOWSvJqjJ2mluFC53xcirNypbEHjQu4K83kqGtUvcZL8aQDE20Y8kQPSZO8cUk/8RbaLkIrTNc7m/lNp5WpP2/otOaGbyKlCIytQQLqUwh1cFoiEeEwiPJV3J+jguTGeJjQDYKjuFVlGLpamHbaoKh4=
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


