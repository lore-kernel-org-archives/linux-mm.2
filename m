Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46F6CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BF476B0005; Fri, 15 May 2026 05:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96FCA6B008A; Fri, 15 May 2026 05:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8108B6B0005; Fri, 15 May 2026 05:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64B5B6B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:20:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21C2C14087E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:20:03 +0000 (UTC)
X-FDA: 84769107486.24.749D2C6
Received: from mail-m82149.xmail.ntesmail.com (mail-m82149.xmail.ntesmail.com [156.224.82.149])
	by imf02.hostedemail.com (Postfix) with ESMTP id 53E7780003
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:19:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf02.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.149 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778836801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ODOh5qsK8DTBNTzHUxlE61WnWCL8RothUeeaS2hSf2E=;
	b=RiEllG8Py37Z2eJ8MaDAqyy5E0FO90ichO6TgWXI27OIDCXglUjWbEc9dyLRKloH43t23n
	0IhvKGMrjVH4aGX+CtRPWk4qdwhWJwNwxihssj2bMpv9lfh12l6tKthx2vG1A8QJQuCLsY
	sdj04kv6fYV2XiKvGvZ6RSwpbWYI114=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf02.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.149 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778836801; a=rsa-sha256;
	cv=none;
	b=t4e6n7ZOEXTvmPCizJgAnK0F/Rc7Xz5YmTzxBKlZyM71ALCgXLfDaHwJLeLhL/ZQjUPb3u
	YViH8NOcnv3bLIscvZgWYIF94U/+XOLhTEWHLlrJrlU/xdfMiDSoHTBhkd7LYy7dhndWNE
	/dsmt+CFbXVvyFf/LHLDTNy4eH7bodM=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a2c1b5a6;
	Fri, 15 May 2026 17:19:55 +0800 (GMT+08:00)
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
Subject: [PATCH v7 1/4] mm/page_owner: add print_mode filter
Date: Fri, 15 May 2026 17:19:39 +0800
Message-Id: <20260515091942.1535677-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260515091942.1535677-1-zhen.ni@easystack.cn>
References: <20260515091942.1535677-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e2aef709d0229kunm2e28cf4e137225
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSkJMVk9KTE0ZGB4YSUxDQlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53E7780003
X-Rspam-User: 
X-Stat-Signature: cc4eat7gtjn6pecu1ogsypgi9mbj8czw
X-HE-Tag: 1778836799-984967
X-HE-Meta: U2FsdGVkX18t/L8WLiArw39scJv8CleLhIh+o98VAWyJcxz98IUeje8eMlCE4O8dgg2b6xdS2jTFDVHbEsCvEBE3Ey7lv4VrdpHJMetGcHhOCKhXi69OAdxgNwrIEQ4FhJaYl+diodRIwR4I8mIULDSu3cgCQF1cSNejOZm6Kpr37oSd4HpOX1kvcsKV7NGLixmtf/C6XKZo6/B/NX5AntLAZvsTT+PTlmo9pusTzNWp8DXjDrUqgeulbAvt0+DTs978oz2ngs3mh2nL3bzhVRlvEyICEaIkm1yyRqP/hDPRQU4IoIUk5Ru+ZMe5Ne2DbMumLznm4HCYD6X+bZCVGfjeIJ7Mgn5Xd6sRSBybBN6OlOoMEYaPdwu8DZJKOcYSke2nbfbxXGR5AZH0eoPXj98J1/wUZ0xQRteGYcPEsFom7y62MYVSv0jLlwh99EAqFqNpU2NSerqyVvW17C47yMp469KRAkqTZYROBuK7jFPVSgnQxhR8HiIZBi2eNhdpdpfVzbZCmic04URqmqttT6fYBM+PCVOQQbO67q5G3oREvcuoIMgcxeXPGiQKRUWVzHH1xPD+7YJE4UFtZJOqb0Pzjv4KIEpk1QtsIBpjJ5K7qg6yETeKLwezf+cVIvYD0C3zUH/8LieDaLZAn/xlfYX3JARySTucoy6/+Fp5WkKVXqs79LsDRJWWALFhXg/fXbAxpKXqMJj/Y1YoHtVFpzLOwRCLth62vLVCScL1PDMgTcbE0lh1LD+iDlS1nwnQD6JtbcKnbp9d8yi0S91Rtuns5pkY1YZe+xtsLDMyL0EnQwHUCIsBjar/jjPIMY/RFKe1Ha+I0PdTPUxzSwvv70KeBrHAWxzoC0NjBvHOFA1p+S3g/0hlVPmYi7QDTtbuOA8TJSFRExmGaH8RhqIZybnw6h6SW5X2vtPW+DNQiKwcrmLW9gEsZfTz/k0sPRzX4tOuY/1P2GfY9YvsF56
 jZ9PUULI
 iwi/Fu3lqMlpH4TZEHMd5PkK6/swfkD1clgNYi6/GzJR8alijZHf7qB2nWZ4b4ldw+rf1jziUXJdDTshawz6wb6+lJPPa2fJQcZh9TP8bVfVnr+IepJIDMmEBNdbxXeEsMXyFkV9sX4SLKRFDrap14HAeq9BRdHInGSXysOouHxOT7cY=
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
 mm/page_owner.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 102 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..559d9782ac0a 100644
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
 
@@ -547,7 +563,8 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
-		depot_stack_handle_t handle)
+		depot_stack_handle_t handle,
+		struct page_owner_filter_state *state)
 {
 	int ret, pageblock_mt, page_mt;
 	char *kbuf;
@@ -575,7 +592,13 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+	if (state->print_mode != PAGE_OWNER_PRINT_HANDLE)
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+
+	if (state->print_mode != PAGE_OWNER_PRINT_STACK)
+		ret += scnprintf(kbuf + ret, count - ret, "handle: %d\n",
+				handle);
+
 	if (ret >= count)
 		goto err;
 
@@ -664,6 +687,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	struct page_owner_filter_state *state = file->private_data;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -746,7 +770,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle);
+				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
 	}
@@ -847,7 +871,81 @@ static void init_early_allocated_pages(void)
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
+	char *token;
+	int ret;
+	size_t max_input_len;
+	struct page_owner_filter_state *state = file->private_data;
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
+	kbuf = kmalloc_objs(*kbuf, count + 1);
+	if (!kbuf)
+		return -ENOMEM;
+
+	if (strncpy_from_user(kbuf, buf, count + 1) < 0) {
+		ret = -EFAULT;
+		goto out_free;
+	}
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
+			state->print_mode = ret;
+		} else {
+			ret = -EINVAL;
+			goto out_free;
+		}
+	}
+
+	ret = count;
+
+out_free:
+	kfree(kbuf);
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
@@ -980,7 +1078,7 @@ static int __init pageowner_init(void)
 		return 0;
 	}
 
-	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+	debugfs_create_file("page_owner", 0600, NULL, NULL, &page_owner_fops);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
-- 
2.20.1


