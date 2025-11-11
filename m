Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00B7ECCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26ACC8E002F; Tue, 11 Nov 2025 01:55:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D2128E0032; Tue, 11 Nov 2025 01:55:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F29158E0030; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1D248E002F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A05A9140428
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:39 +0000 (UTC)
X-FDA: 84097415598.17.840DC1B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 33E0B4000C
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=mCtTlOKV;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844138; a=rsa-sha256;
	cv=none;
	b=Du/h9yzPYcGwr7AlL4KrXb1y6QMaBxyFMkn2SAEPpNyvZzd3gcX1lbsQQkWWftsAoElXrz
	NBt4hlWgCHA97KqiD63Jm4rqhtTtXlznt5cyckF1ltm3vX/48VDQnKzKdQsgFhjEZ8UHuS
	yMZQjXJ8yT3wBw9nH+8lh8ofSwCtDJ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=mCtTlOKV;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf04.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844138;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+YJfK1JQC1qMGUqrxdt1F1Oxcx2pv8iNDDBzggBjk0=;
	b=04FLxcSrKKWBZ5ldlGdYsa85TCW3xjVyPgCKpnCAyIm8meTJeucKeTa1+7XAo6zIiDLstt
	EBmtFLdtgCqWN6kJ1/9MVTzUcQDrdiSLNmCU96faFtS1c5PjaGxFQYw0BgsZ05XzkyhiOE
	K9LetbYHd9qIEhEVlhKwrHwe10XmT2Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=q+YJfK1JQC1qMGUqrxdt1F1Oxcx2pv8iNDDBzggBjk0=; b=mCtTlOKVOGtAV3Fd6s6t1TxgRe
	XpkebMhkQJ23JdJ50DloJJh1lPBIgODF0uHNkVHCF0nN4mFnY8p5mCYD7GufmCSBVONhWbAxx5OQU
	i8tS+ba8dzGs9SHCOePSmdZiJoXKqSw2KQLgDlbl/2pNRodja8ORO2lDdpp6DxKXw0ame4bvrW/Kj
	PbJ/KBuJFManx7Sho2+mSf+ksoI7PV9UBotmKpRDaa+CtwveOgvlbJ8rDNI2gp8ZQhlbqmfZebR7x
	9VdzGf0QSTCffumZdqTIi1ODwjGBvi5zgelxMVKWQAFaz9BD/7ZTYuvHi+9t/kaeW9T+tiLc0y3fU
	BcyH9PFg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHu-0000000BxRd-0qMW;
	Tue, 11 Nov 2025 06:55:34 +0000
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
	bpf@vger.kernel.org
Subject: [PATCH v3 50/50] d_make_discardable(): warn if given a non-persistent dentry
Date: Tue, 11 Nov 2025 06:55:19 +0000
Message-ID: <20251111065520.2847791-51-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 33E0B4000C
X-Stat-Signature: uu3nshs5ws3mcnqag3g9njcb5ydz1dmk
X-HE-Tag: 1762844137-784130
X-HE-Meta: U2FsdGVkX183T7SpkfstNeLeBPD8k5JAh5C2jnxSzTULWoa8yj4exkMoSoEfy5BgWTAyJxVhEKyAS6+7pFkuPf9mrZti7++j4zqqs/XpTdGLnxCfOkAFko4dMAtBtE714vcIfY7HbG3gYEjMnGnYDrsgMkUeJ70n8qu4DT/DtAWEwHlCpqNZWUiBh5IDBrUNs4IZME+LtSbA87Dz72zSm2GF8NY8ZZX6OBq1h6zoBeFcDXhFE7RtJr5nFcyagcSXrvYQX4VljXG7cGUIR5YZtdIiS3eEn6LwctEQYbTAsD78m8xpwAjJRcvwE2+rDnGO4uYDdIIpXMkaL1kFS+GKa3zHTmCRmngQ9vEmdOI4SjbM8Zcr0SBEhEa6+T6922ByIXx8ImjjwwYCCx5edhcCFEcmlbGLJ6yK/Os9D8GyQiioy846icOq/mrfP8f6Ugw+W3o6dKr5I9uQzljYPOcwIDF6oRA7ECkZWweF4gzLbJpaQy1ElC1VWzF7V5OmY2Rquk+CFyaCo1e9x5JnUoDQRQ8SEpwbqxojYrekxlN/tcTsZGdJ/AOTgoSjWYaGdYddFkgYSDW636sO6hgJB3GLq1XPIHh4vvgu3OtGubWe5X+aUV+3pkxbgALGXN3pki/cThfYvOI8H3T4ARFdiVghZNi/xwXwQ6vEfvG+nQ9wnGqmPVmu9M5xQlDhML6OTz78DK7ulEUo5chzGdBop0Ab9LT3oc/Sv/DT5zQjTfYu9iWcH50A8vsEilTuCGqURcmL9cIJZtKlpdlZBXpcRuM95PFUpWeeDb8JdxpszIWuNx8QXCqPksGymOBDj0bcsOOPvIozI/GLbM++Zy6ehWd6dIUW7EhLFZ9VzLnw/2wbc8lP0nFEZDh1qjBRAfEicffm+UwS+3OBTtcI5SlA1mLfLSyCPD6iLDGJF3VmdbJ1M3WX4IA6F7f5Ldamf1a3X2pv/aMhNp9e4JNKvyQnET1
 Q2T3WNkL
 80Cue8BaAXcGi4p01iCcov+No5My67UfE0ILbGVnkw6ayxoYlW+y+maNpZL17cLI/W32bZ2gHsviKO+hqG4gyrRdZEYKvOP3sQtjK+zxAg+jBMlx6DDEidEpp4cbDgiohEepC4k5sXMpX+/ZGyd/3WFI3pKjV0TW47BdoFGo56hcd2/ErlkZTgmQVxRraeuS7+fy5
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


