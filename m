Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E8BC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 09:34:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33586B00C2; Fri, 10 Jul 2026 05:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC256B00C4; Fri, 10 Jul 2026 05:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A85826B00C5; Fri, 10 Jul 2026 05:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CE626B00C2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:34:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E77358DCC1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:05 +0000 (UTC)
X-FDA: 84972355650.06.A08760D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 194B2180010
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:34:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kbjC5F66;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783676044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xm+j3OgjLK3HnfdON0ysf0/V6hafzJtdTjDpiV8v8kA=;
	b=Nk++4xUzs7/xKa6zgKdBb3VeXFq2QnuSoIlUGRR6d0uD0aSRHPpV4DPETwYWIAXxer2PwP
	DaMqvULKeWobYXipjjzJN2DrQK5aGQqIC8qr5jSUYnW38jiCLLHtPNltjvMSa148FvdlgS
	HCGVAgAKwrAJYmWb5IGQGYgjKA6Pza0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kbjC5F66;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783676044;
	b=rR49OisS2kIwzEX564lyH5nvRkXv6VPMcommuVqIZ0UVNGnDmEeme+jehjpVi80XpwyU8Z
	YWhoAYV8SbLogBQ23fYaaZP+lFKkVWs8btOL2pYFh0PCOBhZMy+INQrqpsOWvZZjOngiGf
	lxdamOGX9kNNF37WWswQ9g0GxmuBAio=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6820340227;
	Fri, 10 Jul 2026 09:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E368E1F00A3D;
	Fri, 10 Jul 2026 09:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783676043;
	bh=Xm+j3OgjLK3HnfdON0ysf0/V6hafzJtdTjDpiV8v8kA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kbjC5F667wVKUx5SVd6rCkZBMjrEORAPXzCtMF8ZIrG6oZhdm7/5jcIK2PBwObf96
	 MGrkNEuTAuapzv0pAnoD/gwQZb/faPLmh0RuFeM2EW5nIl/74ocHmQG4J+fHnrtGc3
	 Uk/2BmtTZF1lLOON7GBzVaxlYklzLsg5xZfWwp/559pjqqzJp5+aPPAkEthxHqiQPr
	 uN00rt5b5MenS2OEUuA5GAxGILm4QvA2wsg+B4fJz8b8W5AOyadvWi76dYtk7FwDel
	 BvQs+wly0FNkV88FDJ3fBDV7YPMdwTCW5hEvKhi7JSW7EFeZt7dzrvkIY6GDBzLQhw
	 EmNhGC7KEZABA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 11:33:23 +0200
Subject: [PATCH v3 22/24] binfmt_misc: assorted small cleanups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v3-22-a162f7cb58d6@kernel.org>
References: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v3-0-a162f7cb58d6@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2839; i=brauner@kernel.org;
 h=from:subject:message-id; bh=DxaXDtPSL/Yhx8IE2WZ2kfrmFA6eNfkRrm8ZRKyCQfw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQF7IkvnmP0tqS9ajbX8twFiY8bfDYxZK3caH4wViNyw
 89dCZGLOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACai+oXhf/ilu6qHHK5drZBc
 +ut4xf6cskqlKJ0L575cYbogvXPHKXaGf7breZboHRL3XrhLovB6ZvOJnG97pnT7cE2P0/q4/1O
 jMxMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 194B2180010
X-Stat-Signature: ec4cr93ffrejtdfggz61punicesrkk3r
X-HE-Tag: 1783676043-846002
X-HE-Meta: U2FsdGVkX18ca4EPDfChrRUhJbYzBbB39fWipzXnKKYyGKpBwWb0vqeBlYeWoTGOBA6W9wUmZdzor56JWP/MSwrCOD74wekLrj30EHAt2SRT4nOcvd/IzNse953rp17EqclCeTyuq/7vdyGIYTLazqqtRnw80X67QX7eZMBehbb1QZouzMKjoyDXI/wUBKM5TrYcJAjw6PJzUBU/vJtsQbEpoyt95mcD0QwLGE5Y51M0mCyAQ9HWiVouL5AruXzMb0R0Org+aszUWWCZ1MAcCE5cKDZaS9jztXMMhs3s0lPtH6d25vbHGoeVWPzWeqxXtVrLhbjXeu2PZbwQhJI0DDLDBSyVOOstQw1NTHyhI9VUNbxJqsVdoWsqcfF7DbFTdNRQQxcBoi6dcDfXH0sQLjLpmP6D9KNQI43Itg7FJv5UYTFVuELVIQ57AnyMLu0kU0Jv09alghNtGFA2ZY4PRzm4OH/VnbXLrQk2kGm+B0ApFRVyCpOaa0Tb/ZX7FxH1G5rFyS0yAou0rjgxZmxxJrIHTwXkQ1cIAQpF5mNxTTHW/hq6K5vePUfOINFKjo17hBqIAVU2edTLOc5rE66O9yHutQNwm+c1Z2E2az5nid7KhxfxHh9dqIzyji5kJZEY5LzD8nOIPKTLEnCgK6ahvGuzplcCaJfLm4CI9zTUF6Bqk3jgtYR3zeYm0bdbXWN2uO8TNXj1xGQk6cGgWUqxVwH2RIDEvE7+bA9JFsgWwUAJG81tGDm1IjNHvM3pZZXkffTDyJBD2nnb54OeA3txCR600rljL9p47VZsQH14j56QajJcSYsrK3CJbBy8jsKBCtz2C5+51vRoi9mqSjrXqbv1QUJcUwxVEmPszmvUVMRgknXMHxfQYdKYSA3BLGzI1PkQ9ISKXhpJ8C5/P5Xt+laGv25YhgXO6xywAdm/pPvsJcmXIgFniSzr2u+XH2YBtYMMzu2V2jl5+HmPJKE
 uIP+Nx8H
 NE5lqmQNg4LvjEWM30BrUSqm3LKNFppmsZof7PdMVowBgngLKLmjWELbITxjKYgkjnL1AlUnzQS9iMwRx332h8jjnkDtG+VDV40eMtMaF33RcKVjz+LUe5eyzr1bOLE8gDkZOw4VpHkvz4BVMvbmQnf5lJbnANqRLNApj4QnjVMbqCvJV9yRsrCdNDGx/NexVqp7QEa1tNm0abLqyfB07Ub+eU7uAjqm2ZJV5JZ2tLUm0s8EI821T4ZosIQ1kC4+9cSGEbaGEaFJlYwUl2EvAkO/yBKo6kfpDTlqaFDLRKGz2Cd7mJdm3BaEgoStRWaDHLXsXbWMl5vzofNTO+975TU3MV1rvN2fi9rdI4Dj7NHNYCOc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use umode_t for the mode argument of bm_get_inode(), constify the
fixed status strings in bm_status_read(), give the super_operations
the bm_ prefix everything else in this file uses, replace the stale
scanarg() comment which still described parameters and an err
variable it lost decades ago and fix the delimiter typo plus a
missing space nearby.

No functional change.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/binfmt_misc.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index eb56aa6a3ca2..189b9218e5a6 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -291,10 +291,9 @@ static int load_misc_binary(struct linux_binprm *bprm)
 /* Command parsers */
 
 /*
- * parses and copies one argument enclosed in del from *sp to *dp,
- * recognising the \x special.
- * returns pointer to the copied argument or NULL in case of an
- * error (and sets err) or null argument length.
+ * Scan the argument starting at @s up to the delimiter @del, recognising
+ * the \x escape. Terminates the argument with a NUL and returns a pointer
+ * past it or NULL on a malformed escape.
  */
 static char *scanarg(char *s, char del)
 {
@@ -309,7 +308,7 @@ static char *scanarg(char *s, char del)
 				return NULL;
 		}
 	}
-	s[-1] ='\0';
+	s[-1] = '\0';
 	return s;
 }
 
@@ -458,7 +457,7 @@ static struct binfmt_misc_entry *create_entry(const char __user *buffer,
 	if (copy_from_user(buf, buffer, count))
 		return ERR_PTR(-EFAULT);
 
-	del = *p++;	/* delimeter */
+	del = *p++;	/* delimiter */
 
 	pr_debug("register: delim: %#x {%c}\n", del, del);
 
@@ -604,7 +603,7 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 	return 0;
 }
 
-static struct inode *bm_get_inode(struct super_block *sb, int mode)
+static struct inode *bm_get_inode(struct super_block *sb, umode_t mode)
 {
 	struct inode *inode = new_inode(sb);
 
@@ -852,7 +851,7 @@ static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	struct binfmt_misc *misc;
-	char *s;
+	const char *s;
 
 	misc = i_binfmt_misc(file_inode(file));
 	s = READ_ONCE(misc->enabled) ? "enabled\n" : "disabled\n";
@@ -899,7 +898,7 @@ static void bm_put_super(struct super_block *sb)
 	put_user_ns(user_ns);
 }
 
-static const struct super_operations s_ops = {
+static const struct super_operations bm_super_ops = {
 	.statfs		= simple_statfs,
 	.evict_inode	= bm_evict_inode,
 	.put_super	= bm_put_super,
@@ -968,7 +967,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)
-		sb->s_op = &s_ops;
+		sb->s_op = &bm_super_ops;
 	return err;
 }
 

-- 
2.53.0


