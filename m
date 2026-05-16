Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D17E0CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44F86B0005; Sat, 16 May 2026 14:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1C4A6B0088; Sat, 16 May 2026 14:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32536B008C; Sat, 16 May 2026 14:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1A6C6B0005
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:21:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 426701203F9
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:21:47 +0000 (UTC)
X-FDA: 84774101454.19.DE21078
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id E754BC000A
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:21:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nkt7TPGR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x4AszcfE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nkt7TPGR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x4AszcfE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778955705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=I7quuES2Nnz25cpefFp6n1Jxio6jLh72B38wnS1YO2k=;
	b=nVjlneNtCt3+2t19lbr58B8dZYB9rTsZ0R/sCdOvWGeajGlzH402ilVt59reZHroJnnlQ8
	Gw5qe8r30fEYsif9GP9o956KZzbL74Jv/zpF8yOZWJBHEfHUv4LhaYqtEmPVeOrn8eU9I7
	yU96ezvYSBA2e19PyC9J0cgIYgBf1AQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778955705; a=rsa-sha256;
	cv=none;
	b=IkRIv0fmXDmbgDbvvulNWs7CpuTylCQsklonepw66Xdxrrf5Ircud4bKf3P1hg2g3kaVwA
	OR/fLe8bXwX0i1J0nXB7WkjJPBx5FXqEmA8vUz3OfksOaaYfFYLrAcd2MmI09TsYZfnbAm
	kYOskaKQMCXkAd1UO9k2qV2+Onmp7zI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nkt7TPGR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x4AszcfE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Nkt7TPGR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=x4AszcfE;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F0FC76BA9F;
	Sat, 16 May 2026 18:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778955703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=I7quuES2Nnz25cpefFp6n1Jxio6jLh72B38wnS1YO2k=;
	b=Nkt7TPGRN6tIn6Nuyva09wsTXC4GT/jptwqAEI8rJr/Q436SqJNbBOZipuPAttDtOun2dR
	KmzRMP8ccoYzYZOh0WXZUPueO7ZgPk34r8d4iWM0CkyZpzcRikdve4jOulny+cesnS5RvQ
	f+NX+qQOoRDSwj55DSYO7tpQnCBFiLI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778955703;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=I7quuES2Nnz25cpefFp6n1Jxio6jLh72B38wnS1YO2k=;
	b=x4AszcfETqUNTj/9Bn2v+3bby3bLeyNFM6wgXxqe2J14wQORCx7fxfz97TmR1JgBSTPfva
	EnIiQ5dfzwfeX3AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778955703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=I7quuES2Nnz25cpefFp6n1Jxio6jLh72B38wnS1YO2k=;
	b=Nkt7TPGRN6tIn6Nuyva09wsTXC4GT/jptwqAEI8rJr/Q436SqJNbBOZipuPAttDtOun2dR
	KmzRMP8ccoYzYZOh0WXZUPueO7ZgPk34r8d4iWM0CkyZpzcRikdve4jOulny+cesnS5RvQ
	f+NX+qQOoRDSwj55DSYO7tpQnCBFiLI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778955703;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=I7quuES2Nnz25cpefFp6n1Jxio6jLh72B38wnS1YO2k=;
	b=x4AszcfETqUNTj/9Bn2v+3bby3bLeyNFM6wgXxqe2J14wQORCx7fxfz97TmR1JgBSTPfva
	EnIiQ5dfzwfeX3AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 385F3593A8;
	Sat, 16 May 2026 18:21:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id U6jVCba1CGr2YQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sat, 16 May 2026 18:21:42 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [RFC PATCH] fs/splice: allow for a way to block splice() with read-only files
Date: Sat, 16 May 2026 19:21:26 +0100
Message-ID: <20260516182126.530498-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E754BC000A
X-Stat-Signature: s85uq59ndwkj8zq45we3z1e5u4uxoyzj
X-Rspam-User: 
X-HE-Tag: 1778955704-290563
X-HE-Meta: U2FsdGVkX1/JfV0hgp8AV8YsqX8ErrUZ525HZ8igX9Jkoh0LPmfefQrDHsJET8ceI1nTIT/vIXsTFzXrRdgAbcCZypoUXiT/+980IbClbEbHrnN2ue4/0SfyZ89tBuxoJOzJoNiqX3S0E/6jqNy9jvLxFuaCebcv96G5lVOJBj3x0Ts9Qw14sQ5AoBeSvc5Pbv6aSayAu6Rj446DEwqj6pLpnHVOzssO6vrdrZBpAuKoW4t12rbycoMnL1JGz9ZPcuFyE7lo9+Hz4fAXBd1E3QOhMtrHKuxg9V7oupZoym8qfJNjnt8EeBIzdCYCnr5UaJ4QLYjc0PUp2JKireiz081JMqTTayYZ4cPaEwG4yzzLDleak1ey0OdKmKbSQ3TF0LyV0sQgYkJHV7Vaqw/4mDEITV8IIT+x9EU34vObP/vXyp1882zsDGbYfjvQATBcneJTKcH3jKIRv1+qo0MduYTWa797yOrEI5y2WJ3R7HyhgefbkieDNyafenu6m/pIwQ5dgdw/hwHsJzx6co8PvkIlnpBl70ToRP/olEYv4cDnzgffQTm7senG6BNi7hai5UQyMxm3zfh7k8PjNpeKO8QN94a2ubpPOZSIW+xE/vXiK2+/ALZpht74ZHiA1YSgfeBqA+YEjpzeA7SEFVdKMhBlxdTwgU4EPWBPaYpk82TM/MODvoWs2ndTk4XPZPzUDJ2QFt2LZKBZuUL0YtDgGbhXSjHWccrDFEDdNAVmNFNbVl48FgrusJHzHZyLA/vgCyL2aJjS2CWB5+xQ5cP/vkNYVvBmZMrPBLLtIHDgVaJkrIlVSrQlJtjqdUdoxNWn0fxbIAQUQQwD9w2IAHHx0sMm64lfnJUrkI42NDHPlXzysRG9OpDj3m9YDKoeJjltS0QSKQ9QJXnJ+Mu2AP7+jlFavtKKtEOJGusspZYgCzI6eohzo55M3+6CMIox0vv2RxKBBxd3yO9MBFGKpIv
 kwkhxWoH
 ZFA7ykcB4jUs2vfimsVET0hEm23CfdwkBay3Lw/h1dET/pXWwf3f/DBZmJyv9Lv/q4nqyf/2QAayBDq527qu0HK8NacnzB/XdD2qBS7A1uS1iAQkPd8zOJfOBEEyJCAtFhBz+ZBQBsFLqd3kdpv0FQsbLCwlaP5gAw2SsrHnwe5Hbi0HbLdwQrK9VVi/l/K5BIk8e50MUk0sMxsnx4ShdosD5vrI2LYCECwjBODaYzsh4QeS9RNsVrpyqX7HfvQKIYZdX7FuHHpxdLYmNX6kgeA1QsaPkQvZhQypomi+XCuFV4WcHfIXg6FuK5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the advent of vulns like Dirty Pipe, Dirty Frag, Copy Fail
and Fragnasia, splicing a read-only file is fundamentally unsafe.

As such, as a mitigation, add a way for users to block splice() for
files they cannot write to. This eliminates this whole class of exploits
that use splice()+confusion in pipe/net/etc code to gain write-access to
files they can only read.

Users can simply toggle fs.splice_needs_write=1 and suddenly splice() will
refuse perfectly legal splices() from files it can only read, but not write.

For vmsplice(), make due with the address_space attached to the folio. Care
is held to make sure the operation isn't too slowed down with locks. The check
itself isn't entirely equivalent (the mapping's host can be the internal bdev
inode, etc, and not the one in /dev against which permissions are checked),
but doing it in a more correct way would require dropping from GUP-fast to
GUP, and that would be too slow.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---

Hello,

sending this out as an RFC so I can get better opinions from VFS & security
folks upstream. I wrote this out as a way to harden against all the page
cache attacks we've seen lately, that bottom out to splice() from a file
they cannot write + confusion elsewhere on the net stack/pipes/etc.

This is _obviously_ not perfect and not complete. My first (unsent) version
straight up returned -EPERM on splice() for these files. This one attempts
to retain some compatibility by only blocking the page splicing operation,
but still issuing the operation with normal copies (kindly suggested by Jan).
vmsplice() is a complicated issue, because gup_fast does not allow us access
to the VMA's vm_file. I tried hacking around it but it's not perfect (e.g you
cannot grab the mnt_idmap for the file, since we only have access to the
address_space + its host).
I'm also not a fan of having somewhat hairy MM code in the middle of
fs/splice.c but that's something we can simply hoist elsewhere as this gets
un-RFC'd. It's also missing the external-facing docs for the sysctl.

My big questions are:
1) Is this a viable way forward?
2) How hard is it to deploy for users? Could we possibly even default to this?

Lightly tested using [1], which should see (if the mitigation is enabled):

$ ./a.out
[   17.283456] splice: task a.out/275 attempted to splice a file it cannot write to.
This is disabled by the fs.splice_needs_write sysctl. If this is truly required
then disable the sysctl. Performance may be degraded.
splice = 32

[1] https://gist.github.com/heatd/277339eb25df57d1f750d7da757cf7ff

 fs/splice.c  | 83 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/sysctls.c | 11 +++++++
 2 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 9d8f63e2fd1a..624e5cbd42eb 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -39,6 +39,8 @@
 
 #include "internal.h"
 
+int sysctl_splice_needs_write;
+
 /*
  * Splice doesn't support FMODE_NOWAIT. Since pipes may set this flag to
  * indicate they support non-blocking reads or writes, we must clear it
@@ -947,6 +949,36 @@ static void do_splice_eof(struct splice_desc *sd)
 		sd->splice_eof(sd);
 }
 
+static bool splice_may_read(struct file *in)
+{
+	if (READ_ONCE(sysctl_splice_needs_write)) {
+		/*
+		 * Disallow splice from files we cannot in any way write to.
+		 * This serves as a trivial mitigation for page cache splice
+		 * attacks, where attackers splice a file they cannot write to,
+		 * but can read (like /etc/passwd, or /bin/su) and, through a
+		 * complex set of logic, manage to write to these page cache
+		 * pages.
+		 * The set of checks is quite simple: if we can already write
+		 * to it, if we could write to it (by reopening), or if we
+		 * could chmod it (owner of the file), then any vulnerability
+		 * coming from this is futile, as you can already write to it
+		 * normally.
+		 */
+		if (!(in->f_mode & FMODE_WRITE) &&
+		    !inode_owner_or_capable(file_mnt_idmap(in), file_inode(in)) &&
+		    file_permission(in, MAY_WRITE)) {
+			pr_warn_once("splice: task %s/%d attempted to splice"
+			" a file it cannot write to. This is disabled by the"
+			" fs.splice_needs_write sysctl. If this is truly required"
+			" then disable the sysctl. Performance may be degraded.\n",
+			current->comm, current->pid);
+			return false;
+		}
+	}
+	return true;
+}
+
 /*
  * Callers already called rw_verify_area() on the entire range.
  * No need to call it for sub ranges.
@@ -971,11 +1003,13 @@ static ssize_t do_splice_read(struct file *in, loff_t *ppos,
 
 	if (unlikely(!in->f_op->splice_read))
 		return warn_unsupported(in, "read");
+
 	/*
 	 * O_DIRECT and DAX don't deal with the pagecache, so we allocate a
 	 * buffer, copy into it and splice that into the pipe.
 	 */
-	if ((in->f_flags & O_DIRECT) || IS_DAX(in->f_mapping->host))
+	if ((in->f_flags & O_DIRECT) || IS_DAX(in->f_mapping->host) ||
+	    !splice_may_read(in))
 		return copy_splice_read(in, ppos, pipe, len, flags);
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
@@ -1440,10 +1474,51 @@ static ssize_t __do_splice(struct file *in, loff_t __user *off_in,
 	return ret;
 }
 
+static bool may_write_to_page(struct page *page, struct address_space **plast)
+{
+	struct folio *folio = page_folio(page);
+	struct address_space *mapping, *last = *plast;
+	struct inode *inode;
+	bool may = false;
+
+	if (!READ_ONCE(sysctl_splice_needs_write))
+		return true;
+	/*
+	 * Always fine to write to anon folios.
+	 */
+	if (folio_test_anon(folio))
+		return true;
+
+	mapping = READ_ONCE(folio->mapping);
+	WARN_ON((unsigned long) mapping & FOLIO_MAPPING_FLAGS);
+
+	/* If it is the same (locklessly), then LGTM, proceed. */
+	if (mapping == last)
+		return true;
+	/*
+	 * Else we have to recheck with the folio lock held, for mapping
+	 * stability. TODO: killable?
+	 */
+	folio_lock(folio);
+	mapping = folio_mapping(folio);
+	/* May have been truncated, etc */
+	if (!mapping)
+		goto out_lock;
+	inode = mapping->host;
+	may = inode_owner_or_capable(&nop_mnt_idmap, inode) ||
+	      inode_permission(&nop_mnt_idmap, inode, MAY_WRITE) == 0;
+	if (likely(may))
+		*plast = mapping;
+out_lock:
+	folio_unlock(folio);
+	return may;
+}
+
 static ssize_t iter_to_pipe(struct iov_iter *from,
 			    struct pipe_inode_info *pipe,
 			    unsigned int flags)
 {
+	struct address_space *last = NULL;
 	struct pipe_buffer buf = {
 		.ops = &user_page_pipe_buf_ops,
 		.flags = flags
@@ -1467,6 +1542,12 @@ static ssize_t iter_to_pipe(struct iov_iter *from,
 		for (i = 0; i < n; i++) {
 			int size = umin(left, PAGE_SIZE - start);
 
+			if (!may_write_to_page(pages[i], &last)) {
+				iov_iter_revert(from, left);
+				while (i < n)
+					put_page(pages[i++]);
+				goto out;
+			}
 			buf.page = pages[i];
 			buf.offset = start;
 			buf.len = size;
diff --git a/fs/sysctls.c b/fs/sysctls.c
index ad429dffeb4b..1fcd7c9f92d5 100644
--- a/fs/sysctls.c
+++ b/fs/sysctls.c
@@ -7,6 +7,8 @@
 #include <linux/init.h>
 #include <linux/sysctl.h>
 
+extern int sysctl_splice_needs_write;
+
 static const struct ctl_table fs_shared_sysctls[] = {
 	{
 		.procname	= "overflowuid",
@@ -26,6 +28,15 @@ static const struct ctl_table fs_shared_sysctls[] = {
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_MAXOLDUID,
 	},
+	{
+		.procname	= "splice_needs_write",
+		.data		= &sysctl_splice_needs_write,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
+	},
 };
 
 static int __init init_fs_sysctls(void)
-- 
2.54.0


