Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980ACCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388B56B0088; Wed, 20 May 2026 03:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1E36B008A; Wed, 20 May 2026 03:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053306B008C; Wed, 20 May 2026 03:57:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E838B6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:57:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA2EC1C0117
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:03 +0000 (UTC)
X-FDA: 84787042326.02.71226C3
Received: from mail-m128243.netease.com (mail-m128243.netease.com [103.209.128.243])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D0661C0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:57:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.243 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779263822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVHWz8VW/2tvRzu+CqtTEeZvDDdFzXfMhIE5Z4w+SZQ=;
	b=h5NmED14VQQO/ExYrJFhev8RY1p48BhoRmBLMKMF5MKTcJH378QduR4QRAOnbIvmPavTSO
	806sUL2bi+XAGAEIGR+o8mH1DcFz5phZ/6+94POGEZocClR41kNNJ+uaLVCdGqfXsE5PdA
	1X0jtYIbV8itzobbosL7qXP8ffXmiis=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf18.hostedemail.com: domain of zhen.ni@easystack.cn designates 103.209.128.243 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779263822; a=rsa-sha256;
	cv=none;
	b=rYHy2Y650EMOaPY3qP3LEkm3qTeRCa/aIyBi8wL605VsG4ug4sk1n3rhdOtSpRYJ/HP9yq
	aZUxuNCNgIaDNisjepVyMKu1oeIcbnah8szD2h9GsmzQyVS1D7zz3ZlN61Dda76dczPnrU
	4zTO9YJMH63HZObi4J1noxR7P9G7DCU=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1a5d18cad;
	Wed, 20 May 2026 15:56:57 +0800 (GMT+08:00)
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
Subject: [PATCH v8 1/4] mm/page_owner: add print_mode filter
Date: Wed, 20 May 2026 15:56:38 +0800
Message-Id: <20260520075641.1931080-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260520075641.1931080-1-zhen.ni@easystack.cn>
References: <20260520075641.1931080-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9e446346e60229kunm5cf2619843985
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSE1PVkhNTU5LTx0dGBpISVYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Stat-Signature: 3pfoi7ezcxfpnysfb4hnued5gjog1fcr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D0661C0005
X-Rspam-User: 
X-HE-Tag: 1779263820-172267
X-HE-Meta: U2FsdGVkX19563oqY+lY9O114oiamrQ7X4kBBNN2kG9jefm6MK+stRVMLzJ7hfz1Cf2RQ/Z9nDcfGBUrJu+vh3Gz5n63FmsSQQx2JXnIqAMb/VQDef2eyuKphERKR2V/L6wQebF7WUceVjGOUSXipClaG6G2ZYgjt+gKFihVFhv2NeLXIOnNYxuKkK8rc11xFxxVMwOt2pEfrHvdeios/Tk57l2Q0+IRSqQRcBiwzVj4r17tVFlSapjrWhUAQkWMP/JgR2OxUUbMm89cmfA/X7/QSu20tnwECC1kclrjpkXRdK7VnNHlroA0Lshocj+s8lefytRKPcezGFUNcjTXK8jfP9bm3jY/Cvpao6/bdyEaR8yQxIqVAkyxbIY8XCtDD16nsU98U0Z4MROoUIkIcCHdr7is3Qju9BbplXbomfo6Pmoik+YiJ1NdVpPYNP7BSHN82JPNknDzJXXEuoOeXB94yzEKuycO8r+L+svoNBBtAaXggZ3FXMcb7km03l7GJxoKnyJqZnAdaOTAajmSUSN9OYt+EEenq09+Ai5QLKXgzIkXvw4QyDPIfQ5X8gDHWh/M4VfTG/78QGthHq/anH79VlS1gTG5rVsASFSSS99b/Hehgi14HmM0dR9w6XHyozI4Wi16uT1L1HJElI9ENl9tJT4JER4hx3GA/Hl5rS0P8d+KWurkohOhVJ+wmJKTdUpdUYB+5jYgKqNv0n9/dC0Dlw+7FAPBT9PhzOFAswSxKXklpVQ+LOVb6v9PBniDUqsXYrL+K1hY/WIsZs/7metkV+3Do1fLYwZxzljxWM4GZWXfIBWRUj5S4WZgmWTp43HxBLdlwZDuQFqqOcFdelK87ozPQkoFPhdWZp9zS3zzWEUAgxtCnLZb8zy7bS+RVSucCt45yqKo8lndsj8msCyAKOrRPWTuzSwW9MjzueU5EgK5/Xf4Ug/PhE6Y9kvgrAvVWxaS4BjA4icK3jJ
 KsU1o/qL
 VsCJ/9rM1Jb50VWAcI42yFxcWUVmMZfOWAzHIYMD2ZfjFNwTv5xEN0krmxscEBF6p/xdgWEWAIEaTKKB0CEA6pTZlP0ovpBvQEhgNjMPbwNR1qpsREquTvvlhQxhuwdsnqpmYEMW0TxZmbY/3fLgCu3XaLhWNC4EKiLTMhg4KD/dXsYg=
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
 mm/page_owner.c | 111 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 105 insertions(+), 6 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..d0c428d6cac3 100644
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
@@ -575,9 +592,18 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 			migratetype_names[pageblock_mt],
 			&page->flags);
 
-	ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
-	if (ret >= count)
-		goto err;
+	if (state->print_mode != PAGE_OWNER_PRINT_HANDLE) {
+		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
+		if (ret >= count)
+			goto err;
+	}
+
+	if (state->print_mode != PAGE_OWNER_PRINT_STACK) {
+		ret += scnprintf(kbuf + ret, count - ret, "handle: %u\n",
+				 handle);
+		if (ret >= count)
+			goto err;
+	}
 
 	if (page_owner->last_migrate_reason != -1) {
 		ret += scnprintf(kbuf + ret, count - ret,
@@ -664,6 +690,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_ext *page_ext;
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
+	struct page_owner_filter_state *state = file->private_data;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
@@ -746,7 +773,7 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
 		return print_page_owner(buf, count, pfn, page,
-				&page_owner_tmp, handle);
+				&page_owner_tmp, handle, state);
 ext_put_continue:
 		page_ext_put(page_ext);
 	}
@@ -847,7 +874,79 @@ static void init_early_allocated_pages(void)
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
+	kbuf = memdup_user_nul(buf, count);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+
+	orig = kbuf;
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
@@ -980,7 +1079,7 @@ static int __init pageowner_init(void)
 		return 0;
 	}
 
-	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+	debugfs_create_file("page_owner", 0600, NULL, NULL, &page_owner_fops);
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
-- 
2.20.1


