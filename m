Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F0D3C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A4E6B00A0; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D376B00A1; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792716B00A1; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F96C6B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:54:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB0C840410
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:36 +0000 (UTC)
X-FDA: 84961823352.15.D37771A
Received: from mail-m82147.xmail.ntesmail.com (mail-m82147.xmail.ntesmail.com [156.224.82.147])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B86880004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:54:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.147 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783425274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pqBcI5SKkWC7/S1uWqd1t2HZg1Z+doSvLU4DLcIZVZk=;
	b=wyT/bg0WOWGHd0v8takT9A1DQ1fLeFewYgJPXULWaUelgsK6p1vd283Cxz/FSbp5gw+HTC
	3zSMZL8OFgOtRAL1nCok+Sd1wd6LmY9t/9lAQi9QwIo6I2fnyHXYsJyLpw0O3W3uLlQZtU
	TfIhS/iWjJCirJ+dVAlwNqdj1VplUw4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.147 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783425274;
	b=BSVWToBEcD16auqZW/JSOVmQVimu7wdbBkrYZ+++XDbq+jGtxYpTCbvSWepAeHAS0MQave
	+3/Be3pjAg/zORhj9ts60LgjAC3Yy8p+fPL8HD2WuZ/kxoznWZtQP/qsepPIK1o8neWXm0
	g55n4mfOGA2d8rVyW0a3/AoqGIYdxq4=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1c66e4eee;
	Tue, 7 Jul 2026 19:54:26 +0800 (GMT+08:00)
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
Subject: [PATCH v12 1/4] mm/page_owner: add print_mode filter
Date: Tue,  7 Jul 2026 19:54:08 +0800
Message-Id: <20260707115411.1714314-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260707115411.1714314-1-zhen.ni@easystack.cn>
References: <20260707115411.1714314-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9f3c6df3b80229kunm476cca175fa9a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDQktKVkhPSkNCGUwZQh1MT1YVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B86880004
X-Stat-Signature: 1bwch8jcahdtekz1hx8u1ps3ukcktcff
X-HE-Tag: 1783425272-254656
X-HE-Meta: U2FsdGVkX18iHD42aM6ic/H7ESbM6nJ1+jQ1VMRekHc8Yhf2lUEG/pJ/PBZIiDSQ85+x+bMdxBktlSPNk0QKXgp/aR4z62QDoRiZ+sajWWp3M9TR4bfg2vtP1nQi2t5GgCpbJr+lMjNqWbr6zEsY+Q509T/QLBpVrKMOCU6jX4GbCByOfDsV8vuBnZaEEN5FXe6yyrW5KhK8hfKU2c57mZ1KItnXIeMXx8Mfhk1YaWt890yOGW5kgY/8uhvUWKzRgiHNb6R05TT8WWvZ+Ajt18w7/otEAHoPskgIHNSXDZQgnpA4eiougtCpT5gnle3N1h9mH65EQI14aCDtBQSnz74YhF3Q0dr2UNu7FsnUGT2LP0OEqhdN55uoSKX3DYAJDap9uV2yps2/I9O1Z3HMp5H6+AueKJGeZiaVOOt8UwXtU5rY6i6RH18l19Fl4LtLUPQhOOyWZThmei1YlrsX27kEkeBWSYNxUuVcnUQGzQ7ZidscKQS7IlkH7uhOd2B72Poy9xd4OTVmN874Y5hIJ+goj3FJ/6IKrlTVeVn9/RAOH6Pf0YqaxN/pjjuG10XUnwGxOa3JpgfL7IqL+r+gBJx78z6xt0u0+m6MoZefuhAej1MgjdOqxnwJnE0aAFOm3DnmzqtWbqhx0OQFTdTbPuwSTHu2Vz6n48MLvUBTOYcu9H2Pq6dyJROydXGuDegexUpEW44Q5H3gLXStjv7XMR7TvAOX2rihog9GAhKL6J1VizGQQ3JhjjZ/V7aEgekxsdz9LEdxkXtDpfZqZmVX+TUvLnN9yR7/5VlfyEvDum2Wo0YXIt0XktzBNd58msndLamwhLQZqHKHIpBXZPAPDe7Xpt3kA0BKwZPJK14z0KQmJmF11RBiEnCQnQC1bjSG2dMMVGjXwaDk25Bql9WZ7ghqKDm3dXxiJ7i1OQo6uPVo4bzfItrSVCdtrHKYONIa3Cfk1IWVSJp65b+LsR8
 zm9sLKy0
 MMgYG4rjcrYCQZBfMhl9ekKhvgmdLFpoo4AlE93GfNUJy15VTusnve1hjnhCEnrmkgS7NvZX5KvykVIOGybGLRkLYNfIt8VhctNWiyG61fslUqbfDILvI/7FhxV3irUJAIjbg1rg3P4ZsgtZXKOlaxRHebYFQSBMOCUT1yxp/HxIYAVy6+IIHjETdLuVmLi8z0IOp
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
Tested-by: Zi Yan <ziy@nvidia.com>
Acked-by: Zi Yan <ziy@nvidia.com>
---
Changes in v12:
- Remove spinlock from page_owner_filter_state
- Use literal 32 directly for input length check

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

v11: https://lore.kernel.org/linux-mm/20260625043101.338794-2-zhen.ni@easystack.cn/
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
 mm/page_owner.c | 116 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 110 insertions(+), 6 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..976c2ed6e35a 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -54,6 +54,22 @@ struct stack_print_ctx {
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
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -547,16 +563,20 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
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
 
 	count = min_t(size_t, count, PAGE_SIZE);
 	kbuf = kmalloc(count, GFP_KERNEL);
 	if (!kbuf)
 		return -ENOMEM;
 
+	print_mode = state->print_mode;
+
 	ret = scnprintf(kbuf, count,
 			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
@@ -575,9 +595,18 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
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
@@ -664,6 +693,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	struct page_owner_filter_state *state = file->private_data;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -746,7 +776,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle);
+				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
 	}
@@ -847,7 +877,81 @@ static void init_early_allocated_pages(void)
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
+	struct page_owner_filter_state *state = file->private_data;
+	enum page_owner_print_mode new_print_mode;
+
+	/*
+	 * Maximum input length for filter commands:
+	 * 32: print_mode command max length is 17 ("mode=stack_handle").
+	 */
+	if (count > 32)
+		return -EINVAL;
+
+	kbuf = memdup_user_nul(buf, count);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	orig = kbuf;
+
+	new_print_mode = state->print_mode;
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
+	state->print_mode = new_print_mode;
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
@@ -980,7 +1084,7 @@ static int __init pageowner_init(void)
 		return 0;
 	}
 
-	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+	debugfs_create_file("page_owner", 0600, NULL, NULL, &page_owner_fops);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
-- 
2.20.1


