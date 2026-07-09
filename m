Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70944C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830B76B00A1; Thu,  9 Jul 2026 18:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA746B00A2; Thu,  9 Jul 2026 18:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D02A6B00A3; Thu,  9 Jul 2026 18:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1896B00A1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:30:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2E1D1A02EC
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:40 +0000 (UTC)
X-FDA: 84970683840.13.9E63097
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 24237100010
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g0dC48F0;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oFtJhVGRZT4qwD0ueAoZUMszCp8kBi9TEU7KObN/YE=;
	b=eIJ97+0a89IQkw6z8RgEDJI+2Q8gjzVsotXmsdSkHufNTT+K62lU4UZc5dKjAgJc9joAw5
	9SmH5UKneLKtJtfVxLNWJDP6tLkXUpj+APQnZORPcBE0k+bYjtuLaoSY2LRWF2Bmu7b2/2
	Q0g/A8uGQAHJR9+YbkKn9fSOl2NlyZg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g0dC48F0;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636239;
	b=vUX2vJKFQ0HEcvSUtoGdL9q8LDNQs47aCP9aXWAQkbZePCQbDjjwHdM1eLPl6vBvtDvaje
	XbRDqowG2r7W+8Ruvw3YsB1ZEcDk5I5qfcjeaIe6skq6mP4nl1V41cz2/vP05zay4e4iTB
	l4vVIe70QCDkqiecfcGWuReWDOdcSpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BBECC61386;
	Thu,  9 Jul 2026 22:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04EA21F000E9;
	Thu,  9 Jul 2026 22:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636238;
	bh=0oFtJhVGRZT4qwD0ueAoZUMszCp8kBi9TEU7KObN/YE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=g0dC48F0xoSu4CUdKPS6Swe1lKsvTBK69GsWjVqwZG0neYD4JureFmIUCkAm9F19h
	 /SKAj5aioPyBJ+hlM+1O/Wr/SO3fAID9e0OJkx8FB1ByMp8oEUiHR8P8+O0/28jH+G
	 QGjOXgnjCsXRFM8ZF/+sZCsPgCEn2iRT9dWuUFe1WV1SfdDaWRvJftgrItjPek2xba
	 OItdtWdW75hFOJOO0t0zfUDLZzoL4wCTS7I9PJM2OCUeMN20nm8SC5b9n54wtfYsQ4
	 1GJnxQ6bYAL8SefLQyOco45RmIN2SR1sSAtGjruB84JH4EU9D3RDlfykuPPVm0umFv
	 OOU2n8NlOQrVg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:06 +0200
Subject: [PATCH v2 11/23] binfmt_misc: convert the entry file to seq_file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-11-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5017; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2K4A3O9Logs+Jy5myyDQCn4B2ETcK91f2iNAY/W5zLs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHy9dXmPopSqk0cwV6UTF+e7lEcnp9RwH017k9Sie
 DyrheN0RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwESeLmL4K5FzxWIeb0xZa3+C
 4Rled7v5qxR+9BtozLnlJ9lu+PTLREaGVw+2NHn87Vu47UblkjMqvdvaNtSw7X5s85l3v+7GB+w
 yjAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 24237100010
X-Stat-Signature: rr7wyhi8wxdtnnz63f53arof3mk41zme
X-HE-Tag: 1783636238-172852
X-HE-Meta: U2FsdGVkX19+96Su+rgWVO6w6MCXXzJIYQiQ3V84fAy1U1uQ3b8ICjeJ01HFy+PwjGY87aVSncJCXL5+6eBzS98BtVS7XjW+7LQIQFUC70ibx06rb7hdvDlqA5g4q+WFumQ8E5tiG5kfP3HPq6l4eVyPc7sT9gkOYokTMr7lmSKbnw/2+Ua5xAHVhSEV2m6TSLTZp+gqi8C52K0u3xxow8LR1lnO/Ii8H8i4nxvcP9yMx91EksI7zzmCkwpvASsST4lHa2QPluoBkAYmJBfDWSkYE7t5ODO9o0ra39/R2qJ0Vnnwo1pRMp4jfbBDhVh7MkwNkYpK6hiLtCB7xPC9R3hylWsFGnRulv6MvNqkhbqrAKMaM0O+jTrpa18B9L2aXMdmk9M2aujCK9r/zTMefM6WHeuzTdZe4KrQ6cON8wzvxb7j7W8sUs5jdmKmwIwlvFOJGpvtBz3upvLr9ds/DF8nPZEv6WfJ9iRDnT2Xz5qUz5hOV8Egg1AtiAi7mh8J5JbcTgV0K2x6/6rBQLyaJYjeUZTXQ5a1iRBxSSoAzoPrDlYZ2FxJgpBK5wTuD1cfI0AjKA2fVOO0aduOSFID0USiylL7f2OtJjX0YR+fqXhGJqZGH4hwuZlC8AndOs3AiMNTQ/S21RPEEJav0771xj3lrUEYl9AQ/p1/hy4eoo0Bw1jgvgfcuBZUKZBs3EAji8tzKxEU+96J8E6r6KCShKSe5elwDxe8o8MkHeh0IA3b5Gm7/LCX8rOSLJDWIvLy3SY18jwr7HNgooYkBWWpW23vMZ+DTBhZHZVgx8XpmzJIujDYiCC+5h2Rzr7SSZmSl/N8W7SNO9AJ3WP7Th35tF1kI3pAjWQRQHElMfuVJBLlK9C8Qhx9JDOHEZkrHeLQwCL2Gk6xrtDkMRpEkkL1l9DsbcD+XJoUt4ZEEQFJ5O+kGvlWzXJhbtW7V2d5AVCRcYTDYqHjagLCqCkam9f
 /Il14rof
 Np7N/875bkoHjBQmHE/enAgzvpOPOoYSAZwW/L2tG4Md7sWrQIcqb2XwuyAnKPstw16TnStMt3KYjaxzPXjPHzdlaEFbTUljQnZuizrB3Jh+SvCKw09GqK9SFfnwbcRsGF01kEPhrvkzya8+o4gyiO6/wwM3C9McNnqrcXB247xRjuanbdEXEW9WcG18EmFSYRaujbZLjQPKq1tkPHZ7A6BheBDfm5v+yJ7NqUwxvd5jfUs77ttJYUyMW7zd4c1ahBF+AYRm7cCjVatmEgEB/ybo2rL66ylk6LeMIWRQSDoxWD7H5cnQ50YHEa8bqGcLIxI7eE/VbO4kSrjn7ZGuNRQPyAak+PBwVsgjgry41vz5XDz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reading an entry file allocates a whole page and formats the status
into it with a chain of manually advanced sprintf() calls, silently
relying on MAX_REGISTER_LENGTH plus the hex-expanded magic and mask
always staying below PAGE_SIZE. Convert the read side to seq_file
which sizes its buffer as needed and gets rid of the open-coded
pointer arithmetic including the last bin2hex() user in the file.
The output is byte for byte identical.

seq_open() clears FMODE_PWRITE for historical reasons and would
silently turn pwrite() on entry files into -ESPIPE even though
bm_entry_write() accepts writes at any offset. Restore the flag in
bm_entry_open() the same way kernfs does for its seq_file backed
files so pwrite() keeps working.

The only user-visible difference is that seeking is now bound by
seq_lseek() instead of default_llseek(), i.e. SEEK_END stops working
on entry files, which nothing can sensibly use anyway.

The status file keeps its simple_read_from_buffer() as it only ever
returns one of two fixed strings.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 74 +++++++++++++++++++++++++++++---------------------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 2ac82925b8ed..dac2b423280c 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -12,7 +12,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/hex.h>
 #include <linux/init.h>
 #include <linux/sched/mm.h>
 #include <linux/magic.h>
@@ -25,6 +24,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/rculist.h>
+#include <linux/seq_file.h>
 #include <linux/fs_context.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
@@ -573,40 +573,47 @@ static int parse_command(const char __user *buffer, size_t count)
 
 /* generic stuff */
 
-static void entry_status(struct binfmt_misc_entry *e, char *page)
+static void bm_seq_hex(struct seq_file *m, const u8 *data, int size)
 {
-	char *dp = page;
-	const char *status = "disabled";
+	for (int i = 0; i < size; i++)
+		seq_printf(m, "%02x", data[i]);
+}
+
+static int bm_entry_show(struct seq_file *m, void *unused)
+{
+	struct binfmt_misc_entry *e = m->private;
 
 	if (test_bit(MISC_FMT_ENABLED_BIT, &e->flags))
-		status = "enabled";
+		seq_puts(m, "enabled\n");
+	else
+		seq_puts(m, "disabled\n");
 
-	dp += sprintf(dp, "%s\ninterpreter %s\n", status, e->interpreter);
+	seq_printf(m, "interpreter %s\n", e->interpreter);
 
 	/* print the special flags */
-	dp += sprintf(dp, "flags: ");
+	seq_puts(m, "flags: ");
 	if (e->flags & MISC_FMT_PRESERVE_ARGV0)
-		*dp++ = 'P';
+		seq_putc(m, 'P');
 	if (e->flags & MISC_FMT_OPEN_BINARY)
-		*dp++ = 'O';
+		seq_putc(m, 'O');
 	if (e->flags & MISC_FMT_CREDENTIALS)
-		*dp++ = 'C';
+		seq_putc(m, 'C');
 	if (e->flags & MISC_FMT_OPEN_FILE)
-		*dp++ = 'F';
-	*dp++ = '\n';
+		seq_putc(m, 'F');
+	seq_putc(m, '\n');
 
 	if (!test_bit(MISC_FMT_MAGIC_BIT, &e->flags)) {
-		sprintf(dp, "extension .%s\n", e->magic);
+		seq_printf(m, "extension .%s\n", e->magic);
 	} else {
-		dp += sprintf(dp, "offset %i\nmagic ", e->offset);
-		dp = bin2hex(dp, e->magic, e->size);
+		seq_printf(m, "offset %i\nmagic ", e->offset);
+		bm_seq_hex(m, e->magic, e->size);
 		if (e->mask) {
-			dp += sprintf(dp, "\nmask ");
-			dp = bin2hex(dp, e->mask, e->size);
+			seq_puts(m, "\nmask ");
+			bm_seq_hex(m, e->mask, e->size);
 		}
-		*dp++ = '\n';
-		*dp = '\0';
+		seq_putc(m, '\n');
 	}
+	return 0;
 }
 
 static struct inode *bm_get_inode(struct super_block *sb, int mode)
@@ -691,23 +698,18 @@ static void remove_binfmt_handler(struct binfmt_misc *misc,
 
 /* /<entry> */
 
-static ssize_t
-bm_entry_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
+static int bm_entry_open(struct inode *inode, struct file *file)
 {
-	struct binfmt_misc_entry *e = file_inode(file)->i_private;
-	ssize_t res;
-	char *page;
+	int ret;
 
-	page = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	if (!page)
-		return -ENOMEM;
-
-	entry_status(e, page);
-
-	res = simple_read_from_buffer(buf, nbytes, ppos, page, strlen(page));
+	ret = single_open(file, bm_entry_show, inode->i_private);
+	if (ret)
+		return ret;
 
-	kfree(page);
-	return res;
+	/* seq_open() clears FMODE_PWRITE, bm_entry_write() takes any offset */
+	if (file->f_mode & FMODE_WRITE)
+		file->f_mode |= FMODE_PWRITE;
+	return 0;
 }
 
 static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
@@ -755,9 +757,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
 }
 
 static const struct file_operations bm_entry_operations = {
-	.read		= bm_entry_read,
+	.open		= bm_entry_open,
+	.read		= seq_read,
 	.write		= bm_entry_write,
-	.llseek		= default_llseek,
+	.llseek		= seq_lseek,
+	.release	= single_release,
 };
 
 /* /register */

-- 
2.53.0


