Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3CCFCEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10EFF8E0021; Tue, 18 Nov 2025 01:21:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF758E0005; Tue, 18 Nov 2025 01:21:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2608E0021; Tue, 18 Nov 2025 01:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF2908E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:21:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8322C1A037A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:38 +0000 (UTC)
X-FDA: 84122731476.16.26A2112
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3376180002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=W02RSBpz;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446897; a=rsa-sha256;
	cv=none;
	b=tYosiKW+bx0vDX/gOLq4a599LG0R6YggzQohhBLsuhJaE38JGdUfbJzVN7Lk4Hd1I27xn3
	/iDELBAbp14GtIQ93Bm1BaTygnnfaZe6hCqIUo9vtB/6/ZnFfMukeVMHiIgPw6MoimdGFs
	dJBZLUBB1EC9OF//NSBZLjOhHcY4t28=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=W02RSBpz;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446897;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+YJfK1JQC1qMGUqrxdt1F1Oxcx2pv8iNDDBzggBjk0=;
	b=r98Eok/aj6FsCSw1Qsg3ugaeQmQNL302Slnfo6iZvmHSwXP5up39tEDR07pmcpe1j295JQ
	pHWOOtWogz3gQpqjHFzO2yTCzZjpGOB9KcYBikclUdoNl3cTL/qw4yPp0//KdAUUxLdpRK
	RL0WEWAMrfMUiuR3tJCFht20OHpcihI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q+YJfK1JQC1qMGUqrxdt1F1Oxcx2pv8iNDDBzggBjk0=; b=W02RSBpzlMqLVn0YEvFbpQLGIB
	B1xtSWS2Xpn5FsRTVUCuXxS441ywMkx4Q4tChzkjpM7OdOos6vsjpmlA1Z2zqliUAdAeOUrCkl4yA
	twLanctiYTm2TrhF2JuqprNKCx5C1OgDEb5VhVrEDOG4oYqHSyhhlHLvUdR7ySIDu1QcIqufjvDFz
	fg3BoTHlt4zzzoBRHhd9UFriLRJjA2XkCxlzuQgjqFrQEqBFrbljk+W561fXXGncu3vcxrWfCZ3rA
	av77KdzetMrnx0X53ANKFtJe4tSqLpECx0Ve4j/MSoRKo15Xs40u5Op0OOtatpBT+hfkjzgtievvq
	B+fD3mwg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4b-0000000GEl1-2wuq;
	Tue, 18 Nov 2025 05:16:13 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 54/54] d_make_discardable(): warn if given a non-persistent dentry
Date: Tue, 18 Nov 2025 05:16:03 +0000
Message-ID: <20251118051604.3868588-55-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E3376180002
X-Rspamd-Server: rspam07
X-Stat-Signature: qyhngo6ayfxfj1ddgzcjqyfcsmxom8as
X-Rspam-User: 
X-HE-Tag: 1763446896-662899
X-HE-Meta: U2FsdGVkX19oW51xjwkT7P8n19DD7qHpk7huP45U1iX2FIYvN3Evf45/IzbcBgtLS2LfXNXHsk/XxGbfkiVSX3/QiQKSBUC2uexnICVvHUoAbvNnvVGHzm3JSS5/flAhICt5rjj6h+r1raCBvQ+iBMk/fodB/ndQ+bvyRPd8zPE9BKAUDS3GxajZgv+SJqfZoZ8Eqkswoe+BM+jiZT9xBEccMPPThrFY5WtFyUjAOG+lXUn9NK2zbDlIDjojj3Fz1kBaopEmv85ifKazktiqJjnrGoLwePLvTjwBPhoGc1/4f2wiEEEermpdUE0wrwifEGGdYGKSCjG1MMDpq+EZKbgQypMS5+ghh7b9IvsSbS3vN5wIWPbn9lIWkqJjTHFjmuwT5zTENAr+iWUvWj9sOBvqVE/f2K2OP2x/gIV3tnyEhKRRofEf59fHaQ6hPcHuqdyRCSdxTm9tfJaHkcQVuTKpdb0B/D4U3fHDhES+b5yGT3sR+Z31a/LnY9A5MWYGT7JZQB81oOH2if7dB3bjJKLXTe2Np/M+BpIseuHPbliIA3xQ5p9osgf44IlGhS0iXVtR26QA9zUsEgUz1v25PH0qnNrHb1CwpYnmwy9n/K8WNW5wij+o235pyeyoyy9kVkR4YLJhKUPf+TEqqV0kp6nUlguONaoiuvcT/ssHINDfu1gquFTx+V7fj4Fl2SofrIUyTKkP0Z4BganaijS24JeigZKE5hquGAvqkd6En8tYVi2fITg/MygPBL/DYpf9xq7UWD9jHyMsZHvWg8a8Y8yWZ+Gu9qE6O6MoHOSofqyTXGxDaXfExnGq5bbcjZiVRd6XY96z2erfhpvVg5KRLBLYt+Yo/rvlQc8BcoUOuStTD4AB5zH/z+dWRgg/k6RnuGj6YIeZqIQA9rDmeafgJl++ZQf/FBIlVz+t/Z6lzNGTPQyxC6+L8TDci3wE1oT0NUSOolbXL/bVBGqyg8K
 /qiAOEBS
 uMGKs7ruct42Oy3My+itKfzqJyGIJEMdyePFI4/HI/dQZuMNol2VePJ+oKDHF+5spzBV6BjaHyC385U7YgUJ8Yrxn4XJnYJU9xd+Xx3XuKsAoeH11tjQM6YxAnHBRQXIkcvA1SSqVwKp3tnsZ7pQ2WOITiYZbuN5cMi496nB3Uq0BHqJ55lSS+Za1nHl0oq2Fj4xYxdFPLDx9C4nbIGwoPzf4yL5lseID4o+vH0c00GvmZwZ1/9lYmymrXKJ6sWrVgFMDbvERgUDu0+12tGFPf/cODgyzoEzT49SyVMF3f4MB2huIxY/WcdXopPttb2VfRwDd4Fn1vzTpxsOi2u73M7+jK1n0ydRj1JiL1CqEsB+Hfo8Jf4pPjZoMHyg2O46LUtM4ud9RasgzDJl9XYSAjm7wWCxBQMvPZEIxKmcRAbDqwvcoIgxqdlRYTH0odwipFdifCpKF/T/KruifgcHcAlh+JCw/TK7vvMJTB5gmKjXZfxp3JH+/2OL+oQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At this point there are very few call chains that might lead to
d_make_discardable() on a dentry that hadn't been made persistent:
calls of simple_unlink() and simple_rmdir() in configfs and
apparmorfs.

Both filesystems do pin (part of) their contents in dcache, but
they are currently playing very unusual games with that.  Converting
them to more usual patterns might be possible, but it's definitely
going to be a long series of changes in both cases.

For now the easiest solution is to have both stop using simple_unlink()
and simple_rmdir() - that allows to make d_make_discardable() warn
when given a non-persistent dentry.

Rather than giving them full-blown private copies (with calls of
d_make_discardable() replaced with dput()), let's pull the parts of
simple_unlink() and simple_rmdir() that deal with timestamps and link
counts into separate helpers (__simple_unlink() and __simple_rmdir()
resp.) and have those used by configfs and apparmorfs.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/configfs/dir.c              | 10 ++++++++--
 fs/configfs/inode.c            |  3 ++-
 fs/dcache.c                    |  9 +--------
 fs/libfs.c                     | 21 +++++++++++++++++----
 include/linux/fs.h             |  2 ++
 security/apparmor/apparmorfs.c | 13 +++++++++----
 6 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 81f4f06bc87e..e8f2f44012e9 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -400,8 +400,14 @@ static void remove_dir(struct dentry * d)
 
 	configfs_remove_dirent(d);
 
-	if (d_really_is_positive(d))
-		simple_rmdir(d_inode(parent),d);
+	if (d_really_is_positive(d)) {
+		if (likely(simple_empty(d))) {
+			__simple_rmdir(d_inode(parent),d);
+			dput(d);
+		} else {
+			pr_warn("remove_dir (%pd): attributes remain", d);
+		}
+	}
 
 	pr_debug(" o %pd removing done (%d)\n", d, d_count(d));
 
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 1d2e3a5738d1..bcda3372e141 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -211,7 +211,8 @@ void configfs_drop_dentry(struct configfs_dirent * sd, struct dentry * parent)
 			dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
-			simple_unlink(d_inode(parent), dentry);
+			__simple_unlink(d_inode(parent), dentry);
+			dput(dentry);
 		} else
 			spin_unlock(&dentry->d_lock);
 	}
diff --git a/fs/dcache.c b/fs/dcache.c
index 5ee2e78a91b3..824d620bb563 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -931,14 +931,7 @@ EXPORT_SYMBOL(dput);
 void d_make_discardable(struct dentry *dentry)
 {
 	spin_lock(&dentry->d_lock);
-	/*
-	 * By the end of the series we'll add
-	 * WARN_ON(!(dentry->d_flags & DCACHE_PERSISTENT);
-	 * here, but while object removal is done by a few common helpers,
-	 * object creation tends to be open-coded (if nothing else, new inode
-	 * needs to be set up), so adding a warning from the very beginning
-	 * would make for much messier patch series.
-	 */
+	WARN_ON(!(dentry->d_flags & DCACHE_PERSISTENT));
 	dentry->d_flags &= ~DCACHE_PERSISTENT;
 	dentry->d_lockref.count--;
 	rcu_read_lock();
diff --git a/fs/libfs.c b/fs/libfs.c
index 80f288a771e3..0aa630e7eb00 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -790,13 +790,27 @@ int simple_empty(struct dentry *dentry)
 }
 EXPORT_SYMBOL(simple_empty);
 
-int simple_unlink(struct inode *dir, struct dentry *dentry)
+void __simple_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 
 	inode_set_mtime_to_ts(dir,
 			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	drop_nlink(inode);
+}
+EXPORT_SYMBOL(__simple_unlink);
+
+void __simple_rmdir(struct inode *dir, struct dentry *dentry)
+{
+	drop_nlink(d_inode(dentry));
+	__simple_unlink(dir, dentry);
+	drop_nlink(dir);
+}
+EXPORT_SYMBOL(__simple_rmdir);
+
+int simple_unlink(struct inode *dir, struct dentry *dentry)
+{
+	__simple_unlink(dir, dentry);
 	d_make_discardable(dentry);
 	return 0;
 }
@@ -807,9 +821,8 @@ int simple_rmdir(struct inode *dir, struct dentry *dentry)
 	if (!simple_empty(dentry))
 		return -ENOTEMPTY;
 
-	drop_nlink(d_inode(dentry));
-	simple_unlink(dir, dentry);
-	drop_nlink(dir);
+	__simple_rmdir(dir, dentry);
+	d_make_discardable(dentry);
 	return 0;
 }
 EXPORT_SYMBOL(simple_rmdir);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 95933ceaae51..ef842adbd418 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3621,6 +3621,8 @@ extern int simple_open(struct inode *inode, struct file *file);
 extern int simple_link(struct dentry *, struct inode *, struct dentry *);
 extern int simple_unlink(struct inode *, struct dentry *);
 extern int simple_rmdir(struct inode *, struct dentry *);
+extern void __simple_unlink(struct inode *, struct dentry *);
+extern void __simple_rmdir(struct inode *, struct dentry *);
 void simple_rename_timestamp(struct inode *old_dir, struct dentry *old_dentry,
 			     struct inode *new_dir, struct dentry *new_dentry);
 extern int simple_rename_exchange(struct inode *old_dir, struct dentry *old_dentry,
diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index 391a586d0557..9b9090d38ea2 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -358,10 +358,15 @@ static void aafs_remove(struct dentry *dentry)
 	dir = d_inode(dentry->d_parent);
 	inode_lock(dir);
 	if (simple_positive(dentry)) {
-		if (d_is_dir(dentry))
-			simple_rmdir(dir, dentry);
-		else
-			simple_unlink(dir, dentry);
+		if (d_is_dir(dentry)) {
+			if (!WARN_ON(!simple_empty(dentry))) {
+				__simple_rmdir(dir, dentry);
+				dput(dentry);
+			}
+		} else {
+			__simple_unlink(dir, dentry);
+			dput(dentry);
+		}
 		d_delete(dentry);
 		dput(dentry);
 	}
-- 
2.47.3


