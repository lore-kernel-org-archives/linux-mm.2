Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7455C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665CE6B00A6; Fri, 10 Jul 2026 05:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63DD66B00A7; Fri, 10 Jul 2026 05:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555956B00A9; Fri, 10 Jul 2026 05:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9B46B00A6
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:33:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B1F7C1C8987
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:46 +0000 (UTC)
X-FDA: 84972354852.04.10B5F63
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 042AA100006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:33:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXT2CWXl;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676025;
	b=saQBKA0w+Ufg6g0ynQfK5dBjSpQDS+lI93J7WxDaey/VYlV2w7wj9DCLI/8BvjpMUBai8h
	yMcT2vhx/LWU7//GvjgL70yZOqev2AoY76IR75AI16SyeJUksKShy/TDMZMb1pH+VcZJ4o
	YntrTXOj1XvDCc7Tc9lwPpuvjPYZML0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXT2CWXl;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/BS03uzC+ArmuTiTNxC13ftRdbeXFdsWXea4td0krI=;
	b=QIyitjX+rf7vTq+j/Ym1IfIl6omZFtuj7d4+eb+6Dn+XdcvWct1a8EHzvBpmDF2fsR1qi3
	GqfgOrkXdzKGlNCuW8ak31q1DYOajo7tIYTGtC6kW3IiMvp+b+EKVJbrM7UgvTievo7Pt3
	GOChJ1vJTYR4sRgpKROl1WK57S7fCSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94D96601D9;
	Fri, 10 Jul 2026 09:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E654F1F000E9;
	Fri, 10 Jul 2026 09:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676024;
	bh=2/BS03uzC+ArmuTiTNxC13ftRdbeXFdsWXea4td0krI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jXT2CWXlLXDFdzIiBoKHiZDmIdLAQOnhR0r9It9sEuiJEEZgmXdoZdD+lmRh2QsqV
	 7AyfjVtUxv/2n2iEKPqdp/NNyijyoUCEHfgm/IAzHt9S3SZYSHAjNgA9AKeWZ1TeUJ
	 I0Jw/JGV2GN6H9iL1u44XyA+ihL043XQHDEASttWR7iz0uY1gmNKDdd4qlKiiuYEOB
	 gLbxLxyOPl1WzAOVMv+X1QRVXuZI4fXQzPk/9+9pfIlPokY0TG8XN5dMo+SATGL4n2
	 IR6JbNAUF9f3MxRiSfuFai3xrmF4jmILMcIqopIN0r/U4twxu1m3oM6B800pu0yjfC
	 gTGVL89t/zoYg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:13 +0200
Subject: [PATCH v3 12/24] binfmt_misc: convert the entry file to seq_file
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-12-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=5017; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OTn/NJPM1/XIz6h4f+STHHorCIubSZ3Qj/LONNAc7tA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7InbYpzJqfhCW6XtpqbG3vv6eUGhyyMUfgnd/Hj21
 8sPWx10OkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyv4vhn57BqogM7onWe1bm
 5fXU9TZ4vY+69v7qtuZ+u/nVc797sjP8j5aPU3hdZ/X7b+DilOqvW14asO88n2u6q/nlq/RgLZZ
 6BgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 042AA100006
X-Stat-Signature: n98ck85fdtynwimgbk81q1dtqjct1pia
X-HE-Tag: 1783676024-493205
X-HE-Meta: U2FsdGVkX18QhlE1We9dBDvtsFvDImCd+t8oPkMNyci8QtM281WqJxUTe6YlRi4O4bTu2AM1YKqtd2LOtuqaFagtEgGrikxp4exVmGLjMwkMJYVOJExyH20WOZ4GLfT58lRrwBGP6ZVX3LffS3SCtT+M9IEfn0gRSKSHt2xBaunMK9uUYBtka6KxyVx++U/zrDVEqJmvl/sxeoXYKruLp+eMy7d2tRE7LOaOQJqTsbMSSYVT357KwGKTdq1quoZ7LhNBSszKaxG87uyKXo++Zi0aQ+y31hlEYjxSwr/4WkiFVakAufFTdHX+8uYEgl+GXafOLjA+wqubLmMZ+GGUYXakp4FQAgrFvRqfRm6SXpORd97xaaqlmR0Ou41RsL+u2diFPynu31twNj0xzF8LjKVxIHQxCfhQNemgDSXJ7snBbOKFtXLK7mkRpHZ1EhHXwFlX3s+SR2owLjs/s/nmd/DOHbneagy1gSTD3rB1EewRmLEEZykh1lTArYXOjQXltgrowChhEyEKyMW1MBrmvG8yQx3JLrPx+7kkZOociSAZrxqwmt/uzhj8eN/nkoKfYJzoEvotIOUSY9mEudIjYgJiib+Fk5lmL7a3CmXe0esDb+buAK/ZucPAp3uQjCgdBKcPKNhP+gvZk5WP59yh2CHp9JwVnwBBQWHE7/uKy3DmlqkF6IEgS0GcdwkmYSxSvwf/WQsAZZdTOVT6D7CXts/OwUp5CIA3t+kD8UTKOGYpfLsC6Fuk/jexee3u6SblOViVDn4N1M3VmvMWKYvtLQTbx2FzYAqJEgBaBjSaQn7b/Ztd9/piNvCw4ntlOJf4pfv618R3z8HB3SAf38/xF3ZqHbpwC8s4am1yOAmXnDW9uowVz5sqEgHVN/TPRX1sAGI8Fo6sgpOkM6qLqed7SoPcQOtoYru3EhcC9ZMiexaNzLuumpCshEGpV0qqJtHk7gyVCSbLqpteBOxfNeb
 JQGdd6of
 nGeu9QZCg6LlIU9lZ1vpqFW71anFKbQ7sVYCCzKIvB6C/mQIYIfGbp6BBco9Hb9gaXYXMqsduZdnFWLg+OcpjAF+Ki+Il1z/n94N6AqFY/Cw4ypLJxMC0L7o/aXAENrVlU8voVfxNvDPUEH5BhwptL4thCZBSB5+05rHNLt7Lx8zVGjQYpaEm/mtHaKhyDbNgaClmQPkItl4ktxndV6UHujHhTlyd+POiUjIL2CrnfbIEk5gtsW+yVeoqQPnYb8rlc7XBsKr4X5kCbMlp726Klq9gp3gUM4nQDOeXjdwCcfnxcxRNujfm5W9W02n6LJMB/I+G0ARlKwmZZiJLhRMcWmBuLWyt8khFrg2pnU/PhTGvitg=
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
index 252e1f2a8347..23a2020d9266 100644
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
@@ -577,40 +577,47 @@ static int parse_command(const char __user *buffer, size_t count)
 
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
@@ -695,23 +702,18 @@ static void remove_binfmt_handler(struct binfmt_misc *misc,
 
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
@@ -759,9 +761,11 @@ static ssize_t bm_entry_write(struct file *file, const char __user *buffer,
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


