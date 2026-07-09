Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF1E7C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 22:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216A36B00BB; Thu,  9 Jul 2026 18:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1790C6B00BD; Thu,  9 Jul 2026 18:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B56B6B00BE; Thu,  9 Jul 2026 18:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BC6626B00BB
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:31:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 290C81C8737
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:31:00 +0000 (UTC)
X-FDA: 84970684680.30.C877D25
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 799DC140010
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:30:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dE5kgrOB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783636258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=skdAyX3970evMrszUKHQM7y2G4dAmG1JVxtNPswg6y4=;
	b=ErV5AC1MlJ7I/V7uqTVhVz8sZ4vXHSq0U/pAfJ/ikymAJrQayg/dPkpCxGz6LrY2MUHVc7
	TMrA/bCZVu2KOTF2jr99X/JJ65QMWEkVsPap/ADlsscVMpzWO2ob1bKgXQE5oGzVF2KAO7
	w8eLjWHJrfdLPjpnOuFdYNvHWrNqNLo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dE5kgrOB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783636258;
	b=pLZWi4jDE9Hx0a9yIQQ/kevFxbGKzLCnf8S3kbcX8HI7d6fZ8reM8tKsdhamnlfrt5a6fS
	xtANa0aUOmUB4uM+Gcl3SomFEhDljYm6US9ePtQ9DW3Ll25S4LTXTz4EMTgS27bA/4h37i
	5UZO+EkBzSnxNJ9vQQcRt9VyqXYW7Xg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 11F0A6138A;
	Thu,  9 Jul 2026 22:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3541F000E9;
	Thu,  9 Jul 2026 22:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783636257;
	bh=skdAyX3970evMrszUKHQM7y2G4dAmG1JVxtNPswg6y4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dE5kgrOBcfaEPwffUaYtkQz1jiXWh3rBnQq6uGWTZXRwY+QNO+3T2cms2tHyhIRe7
	 VDucru3IgqCvSZttfAq9Ech+k6ayknA4s5x5YKNWOjLSCm+SiEEGBf/sTl+W3CEg0p
	 EcFuW+DzUMMZW3yEoVEYmc8Na0KGSRvCVqIdjwNkS9g8F7lUEuwgwelvGIy23S/dqE
	 jyGGsbhdIWm71KhgmHn2KdmPn+9H/c4W7G8gTspUVbnW9Hja1dvTm2m33bhIV5No4/
	 Ml6EQ03jQJOKS75u6+L0BYpy8Aw54+v46DZfSB8Iy2YNK1Kjh9BjpDadXEuIeTHZKk
	 kjakhjRaCiCsw==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 10 Jul 2026 00:30:16 +0200
Subject: [PATCH v2 21/23] binfmt_misc: assorted small cleanups
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-work-binfmt_misc-locking-v2-21-2a1c3d4126a7@kernel.org>
References: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
In-Reply-To: <20260710-work-binfmt_misc-locking-v2-0-2a1c3d4126a7@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, Farid Zakaria <farid.m.zakaria@gmail.com>, 
 jannh@google.com
X-Mailer: b4 0.16-dev-4217c
X-Developer-Signature: v=1; a=openpgp-sha256; l=2839; i=brauner@kernel.org;
 h=from:subject:message-id; bh=TPnsqAazRKakxSbfyYI+7zYmksgk7UgLHJazmbDQvTs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQFKHxbt+K25EYb+fDw6etUPjWIt85LD5mZsixV4PVFv
 oVf9hlJdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzkcCTDP/MzFxtlTI5GSW2q
 Feh02fXZ99WJnt9p3748C4np+njy7B6GfzYetUyHsiWZ73tWp+i+XNN2XDnu25dbqWXTP4c55DL
 ocwAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 8ab5we714sfj6exapu7eztp3pcgu6riy
X-Rspamd-Queue-Id: 799DC140010
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783636258-982191
X-HE-Meta: U2FsdGVkX1/1HR/v3oz7YiAnYZBOts6HE30Zq3BzHduYghEd8aA7Hk4MM9nJ5M6serH3KvFTslsV4vATU3bdZZwn/cOlKjZng7ZtcDz5r+Ymu0BXztiqkgljGFq+KfCeBUg5Im5stSIBZexKlYeHX7sAzyOXBbBHVl3esm0bnREZqgwhk0LfgUszivGGa1hiG9Dc6TsLRkr+3OEaGMbIm6IMZ08T8LVwuKM5D1L7htYpMlCVZLEm0Lw49kz+RwsJE4txgIoOJoUVtHbrt7E6Hmf72VwcG2/lNNibK5lJWO6A7X0QLDmac/puXW0Sdeee/nD2yARXCrEFiRChKj+s3wlDvNNJUPrs1jOO8HUxEuk1SFrgykMJhcAGSuSRcbYNBceHq6fmoQFtU07Q4guLzqa7XjbsSFOwOrjT5DbibTWTJcltmlsSAtaCuCI4+2N6tY9WAIXod1CmlSHBz9UygwpNZ/Twh3aWjB4yznod56IOxGGQtulgURJD77+ajWJ6uws7r3lYTtq1aQjSZnFEu3+sU36WNUy5np/d9POzVGYoW2B+xTNs1FFKY7EKSx+1ljmU/qRH2oDfKUjXHsMEZPFFZz9E7nbMf0MSulHJ2qbWHSHbkMiS40PpQAIAmKmr91zhAocvlrCmUYCt+Q+JJI8gzSH10X/EITEWC2VBu1ctFdfRpiws7E2dv889mc/m3mgc7I++uczfzkTiIdhqEvfWA/Mw8wSDcDz2ji6ZmIkXq+VosAK0rSSqs1Fx+QPGXHKgZktKYFewZY93+QiZ8fBnQVEiv2qhjnevuFWlbnov3EcuGcJnNTF+asKra8t54bfgHrJe7LT1lVSEGdqObq0Z4oH2S1J5w0VCe1KHy6f4VyzBXSZ0pFFXAOGVRt+bYg/g+jhSwkQ6SQDvD/mFm4jGffRAx1FoXPYfPTPM3P3n2IBFhi1QcA5cVcCbd48iBUrq3CihCTJETLjf9u4
 uCFK4tva
 RYm/B32kk6F1QupP46y1ggsmSyGd0Z8cO9wwvvGH5MDKgQwG896c6uncP1hSPuGWPiM4D96bcW7/vfmKja0F1077gbj5OxlKKdZtph+Fx+05I5KuQO1rkobblme2A+KpHgfUqnP9bbZQBgVNSgFuly3aXxcGQskvVWCzmySuuMMBvEpLkbWU0iJMMkQMtlYUqfPrBSlSnTnwcSuRbwxoWSNylmHBhl17iKdaJXOrVeoNxC5Pnr0MGiW8mFqHotaVfDS1YecrjMmxmd04L2lyMS9x/rqrO5PZ+G/JdYjsMWSoq3etlRvt6KHAEaUUffFEnrWb6C2x+5+K9txD7nNDWLs4dnmVdMSir+LcWQt0gZgl7jyuAj7mbBG5vIQ==
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
index 6acce58ce405..4c641cacdcc9 100644
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
 
@@ -600,7 +599,7 @@ static int bm_entry_show(struct seq_file *m, void *unused)
 	return 0;
 }
 
-static struct inode *bm_get_inode(struct super_block *sb, int mode)
+static struct inode *bm_get_inode(struct super_block *sb, umode_t mode)
 {
 	struct inode *inode = new_inode(sb);
 
@@ -848,7 +847,7 @@ static ssize_t
 bm_status_read(struct file *file, char __user *buf, size_t nbytes, loff_t *ppos)
 {
 	struct binfmt_misc *misc;
-	char *s;
+	const char *s;
 
 	misc = i_binfmt_misc(file_inode(file));
 	s = READ_ONCE(misc->enabled) ? "enabled\n" : "disabled\n";
@@ -895,7 +894,7 @@ static void bm_put_super(struct super_block *sb)
 	put_user_ns(user_ns);
 }
 
-static const struct super_operations s_ops = {
+static const struct super_operations bm_super_ops = {
 	.statfs		= simple_statfs,
 	.evict_inode	= bm_evict_inode,
 	.put_super	= bm_put_super,
@@ -964,7 +963,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	err = simple_fill_super(sb, BINFMTFS_MAGIC, bm_files);
 	if (!err)
-		sb->s_op = &s_ops;
+		sb->s_op = &bm_super_ops;
 	return err;
 }
 

-- 
2.53.0


