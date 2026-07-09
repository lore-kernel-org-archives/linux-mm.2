Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58995C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0B86B00A6; Thu,  9 Jul 2026 18:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E952C6B00A7; Thu,  9 Jul 2026 18:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D385A6B00A9; Thu,  9 Jul 2026 18:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A4F086B00A6
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AC5B1C32B4
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:48 +0000 (UTC)
X-FDA: 84970684176.29.D962C1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 81CF540013
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEMjWzAF;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upNfzyHTcOZqoGfd7PLX2ebYTtP5AP1hulhKJ8l1RRU=;
	b=AwM3R5GWc4im+ao8xwmMqEbeRsLbkOHbMq8LOZD0clSreVukgqzg51YRDecJ5rbU6rc5F2
	5QQnPXyavzvXCU9Sjaxv1/aSpGDaBpuwNnHtUok+Q3lDfYXWcN4b4yjM4HMbIdj8O1x4Df
	+KU3+OOh9vAopdywClCAXjtu6mc0FYc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEMjWzAF;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636246;
	b=H47elPfhGgLqXbuo0w402BCuYK4Mi3hsynbwnSpn/si2Gc3qsaJ4tM2CP5D5QqLc3NlQL/
	os+behYxZ+gOik0yqYaub2wkVdJV1RTXFrZG4Retc2InD7CRFPtWjfKM1bLQT+++zfEEmj
	43RSLPH9G6mFB8GmluY4qHWsrYwwlB4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BAA361831;
	Thu,  9 Jul 2026 22:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CCFE1F000E9;
	Thu,  9 Jul 2026 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636245;
	bh=upNfzyHTcOZqoGfd7PLX2ebYTtP5AP1hulhKJ8l1RRU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZEMjWzAFHEO/IzPwBcWPZ+f/y3dGc2v05aksYZDBB2GQMv1iC379PRfVrcxiNRIst
	 4bayQi2m2kol1mewfrL6usSRfQuMSb8JZo0/BNLq+1epwE6pvNvp7hWhcMCb+tp1hr
	 6DrvK+RuoAx0HstXjLlYXeAxwhgqPh2HoJ3uyMDwXMrCt6KnyN/ovdhlTqbECV0tg/
	 c/cuOuXZgVyKrzZ23zAFxoJcmlp9hbqRBivMywl/wzQ7ZOS465FhYaw4VlGIhzrIuz
	 XRIWmhSkZEFH7SH8pb4/Spkgz3t6+th58ZTWvxQOEoU3Yzf5xs/UH+EPPm9i6W/ipn
	 Tadu8rTxkYbIg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:10 +0200
Subject: [PATCH v2 15/23] binfmt_misc: give the parse_command() results
 names
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-15-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2934; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fwJ02z6QF7Z8Ypw2tJe56jQoymKZZbPP7tSgPbsf4HU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHxbe7h12d2zlhfSb9jaz+GIt5nJwrPtR90+iX+pq
 0JqbBd6d5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzEhJeR4bX6kus6W7brs9tJ
 BG5X+fXzStbxS+/m9NjKbr8hv8frUgfDHz6LSydkmh6JTjqv9p7jotcWpfUnvJfsXPpPa8aD2ga
 +UnYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 81CF540013
X-Stat-Signature: njnu3icfd5zx9dwdzr6riwwy3dfgrkb7
X-HE-Tag: 1783636246-945614
X-HE-Meta: U2FsdGVkX1/fEkZCDofwTqJHq4x0QKVEFrb7nw2WQ15aymHOGnuvODr/uFR+68xDebkamQi+KmsI8tiygbkXX6V0qLGw5SlYPfAvO7VU7iCjjkA3vwEKYPgV51hdl+E7qf9ryamCu2ffwGH6xkRq9eh//jnRBIfVi1/2LoPIbgGvtcZ4xDSbIk08eApDmPn5TIgvh8t2QTCrVZJcxBTyrOV/4Qr7TRNpjvZY/1q5eOvJAm3Kxa/m+aS3Ol1dNsgP0pWINZDqkQ8TnUbqhr9KM9cP5rBHHejueUPUPkHy9PubK41PlrOWOwjgaZOWkfZ9+lWmxwPEi799PEjzuv3zbCp53jQt8zexT5qXa1VXYZf8HF8fXS5F9xdsXSU7UmG3phMyAeHCjZdICEyMfXf3UPLJX92R5H0PJD/3063+SKqJBDuxA5e1QwsYMtrntQUCrZ8QURLpLIz6SBNkK8N9fdTP2NKTBptJZhbhOGhzgiPCMR/VKrzIV9dzlMzZ8l+5Vau03+afOJ+IjLiWGEq6Qea6GlX/3dG7L3OVE7rsbNgOiLwmx/p9a4AelE3anNKws0pQ+cbzJwahyZjCFyZmkcTNdtPiVaVOzdklhnwlqoVjt2eZahRJI9BAtiI8uVKR67H3BXKBJnGF65GBrpyxarr9KmQNpMGUMBt9P7ghceun0R/8ARiWDrON4hGkrDGlDm1JiRBVqMvxJ7k1fRzpTkdGE2cXHxynJs1ZjyHLErKB5CzPDpdXKvBImt0U9qofC+n9ls2Z5GOD5Ghd40jX953EvCUw62fmk55I7wAb0TdOBLVhJOv6JbQwC0m+nRy3OzDA0XVS/nTEO/7BeSIHAj4NOxeKQZW7pItVhs5qR8+6Vi1Rm0oNy0rH7mm4+Nb22DXG7ZYg95JUvULgcZPUFsW8EgCFU1ZIzM+j2NcuAfCPuk9cxjY3V+w3pc/YecyUaj3hq6ljJW9gHc0XTdD
 p0My+Ukr
 DVCe/aLVuHlso7126HUSYmqKjyh2rOMnCbShFgOtnus3ExzeHZs0wbMzImrZ+O2k/CWaKaMBXwWS+D9HQZLf3blsCyGslDzhwhVoWLCXtFgfYs0Qaf6Wf6Xe2L5yJ/8SwBoH/EPEgIZcQFnTW8/MsNN4JuoL67YlctXZpdNS27Qlc9C0gTZYZX94LkkKEqH/91K3NkQtIASJgkeTneME5rG+O2KzzMR3/JEQ4QsNFvxUKKzx75sH79fYs2m+k3pS1GBr9zxkCOhsvIZXhY/DaGyx28WuVXTBbzzyCoLKnwGWOuKXbQzFDArLKfi5rfQo7rkCsLGP6+xCFSmPkSSdKQquiOe709y7Zy2FZPR+z9eyTnsA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

parse_command() maps "0" to 1, "1" to 2 and "-1" to 3 and the write
handlers switch on those bare numbers, leaving every reader to redo
the mapping in their head. Name the commands and drop the per-case
comments that only existed to translate the numbers back.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 4172c0937161..83f84934d57c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -539,9 +539,17 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	return ERR_PTR(-EINVAL);
 }
 
+/* Commands accepted by the /status and /<entry> files. */
+enum bm_command {
+	BM_CMD_IGNORE,	/* empty write */
+	BM_CMD_DISABLE,	/* "0" */
+	BM_CMD_ENABLE,	/* "1" */
+	BM_CMD_REMOVE,	/* "-1" */
+};
+
 /*
- * Set status of entry/binfmt_misc:
- * '1' enables, '0' disables and '-1' clears entry/binfmt_misc
+ * Parse what userspace wrote to /status or an entry file: '1' enables,
+ * '0' disables and '-1' removes the entry or all entries.
  */
 static int parse_command(const char __user *buffer, size_t count)
 {
@@ -552,15 +560,15 @@ static int parse_command(const char __user *buffer, size_t count)
 	if (copy_from_user(s, buffer, count))
 		return -EFAULT;
 	if (!count)
-		return 0;
+		return BM_CMD_IGNORE;
 	if (s[count - 1] == '\n')
 		count--;
 	if (count == 1 && s[0] == '0')
-		return 1;
+		return BM_CMD_DISABLE;
 	if (count == 1 && s[0] == '1')
-		return 2;
+		return BM_CMD_ENABLE;
 	if (count == 2 && s[0] == '-' && s[1] == '1')
-		return 3;
+		return BM_CMD_REMOVE;
 	return -EINVAL;
 }
 
@@ -713,16 +721,13 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 	int res = parse_command(buffer, count);
 
 	switch (res) {
-	case 1:
-		/* Disable this handler. */
+	case BM_CMD_DISABLE:
 		clear_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
-	case 2:
-		/* Enable this handler. */
+	case BM_CMD_ENABLE:
 		set_bit(MISC_FMT_ENABLED_BIT, &e->flags);
 		break;
-	case 3:
-		/* Delete this handler. */
+	case BM_CMD_REMOVE:
 		inode = d_inode(inode->i_sb->s_root);
 		inode_lock_nested(inode, I_MUTEX_PARENT);
 
@@ -862,16 +867,13 @@ static ssize_t bm_status_write(struct file *file, const char __user *buffer,
 
 	misc = i_binfmt_misc(file_inode(file));
 	switch (res) {
-	case 1:
-		/* Disable all handlers. */
+	case BM_CMD_DISABLE:
 		WRITE_ONCE(misc->enabled, false);
 		break;
-	case 2:
-		/* Enable all handlers. */
+	case BM_CMD_ENABLE:
 		WRITE_ONCE(misc->enabled, true);
 		break;
-	case 3:
-		/* Delete all handlers. */
+	case BM_CMD_REMOVE:
 		inode = d_inode(file_inode(file)->i_sb->s_root);
 		inode_lock_nested(inode, I_MUTEX_PARENT);
 

-- 
2.53.0


