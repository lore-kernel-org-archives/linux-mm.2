Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83414CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4C180114; Tue, 28 Oct 2025 00:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BE7800E4; Tue, 28 Oct 2025 00:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D5B80114; Tue, 28 Oct 2025 00:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0EC800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:51:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 263C31602A6
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:51:39 +0000 (UTC)
X-FDA: 84046299918.22.872FA16
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7DF324000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:51:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Gkj7Zb5B;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761627097;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jWWnLfQnbfazoBZQwErKmRKFUtRFrqyMeJRRkrQTEk=;
	b=7+6KEvDfnyiHBnutI7UW396aD5JDX7pwj6OeFbgx91Iz23+QzsTn/s0nxhLEgjBq4jvsoc
	fx3j/HpJFwjt8UOBFznDZasS37KU9W4thIGHR2Tg+SJGisHaxxJVb3FiwVbyu2TQNp5WEY
	upk9/ivhcBxhC+c748eYvwpUp1bi7pQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Gkj7Zb5B;
	spf=none (imf12.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761627097; a=rsa-sha256;
	cv=none;
	b=foizMUJaIAgh23Iw9+c9eRllvBbwcOAO3xxPzuUuPWes6tRJix0EVqT/+7XyxyJZLwmV1i
	Rri+0GehKhZkmNVv8xWt3H3sv35+MnyrAkKJRPUG8CKew3Tmo2Oz+cc8mx6s9IP8FP0q4E
	e0JoXQysfOGBT6vMswi3ABwz5jtRL3Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5jWWnLfQnbfazoBZQwErKmRKFUtRFrqyMeJRRkrQTEk=; b=Gkj7Zb5BlBFjv4TohuOPBe2E2n
	AKpodpvilfEOkreEX/7LWr03aoVtBDSQZWfnzMbVklJgGB9kpcJbw4BXo+UH1mAWvVCtispBubRMV
	wQtSX1wyJFxeVjjtw8xNa08xl48UnT1xrqIaFFUP21QmbPQdfu7YK3IcWV3pDL/M55JLJaZUHaIkS
	NrbTzq6XSAXX+4KcXv3/FAOf6RhoGu4hK1jH5ajjZCMqZNI8IgSBHmCpNAHIMcEfpyHaEmmK7HnQQ
	zvERgdMHS3AFHHXmQD3uyX1NIhQtZt8vCBGE2wyW7qW014LseG9AmBq62E4L/AVm8vScqqSLqdrFz
	1x5cT7YQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqw-00000001eqL-0YG6;
	Tue, 28 Oct 2025 00:46:22 +0000
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
Subject: [PATCH v2 50/50] d_make_discardable(): warn if given a non-persistent dentry
Date: Tue, 28 Oct 2025 00:46:09 +0000
Message-ID: <20251028004614.393374-51-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7DF324000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ann95gxq3kttzf19dgud1koyh1cr36um
X-HE-Tag: 1761627097-296692
X-HE-Meta: U2FsdGVkX18g6mdDV2/oL4KdBbNS7F1KPeY1EhcbcvkpDb9q5dZyYo4/ZQ9jVdwPJ3Qk/TuS4qtZcC2seymYq1u1s5/SMX4ELTy9Vn1p8yPy/g4FVJzHdgtIofh3/yA3LZv09DDGOhlEPwjnUnuiqNFXIX6P6sjmJf0q5ZY1GsF6Yg94vHJXQ3Dzzk6Lf03Kc8cmWMZKMXOPpWz/Wha+piVh0sznYiBqlLDjv+tW4OupKq72TBaT6lJn2pVxoznJqV2JGGpNu/ByLACfqi2BQZto+9fNEuynW04U5aKgSQBV9G79w04cDC5jZqVC7QZ2Dkz9QUWnfXMmzhyOeyREjr8XCCMn22qevbh50qRFhED7Gh2Q+1WZgn1d1DvCUOnQk6O7Re7d9GF54BBgZrXD6IcyT6wbHafHwxbmenzVRgQXX+xE7QAJ/XfeuDl1EoG4aoj3PlUK2uzn2KLnJl93u4dqpTv/HkC8DGXAHx8vFOwjf2elWPKJSp6Ib6Fkqp8vGCLalRIEutlwTMKsLcBKhJCOZRlaiJhMF5Z/foRqhOBCeIIEoeUYtHP/96vHJCSOaMQ7eixkP4m+u/BdpX5vwAKjHkKNN4Bg/yJhSWQn/ut2UkPsPaegjKdMc7sPxZqi5oE6hnea5epmVh7A15eq8XwBlNZHFSI4XEw3xIRlUZ3CX3KsQ4kRgEvAa9B/AjlyBmcgLww7ZgICnq28GSjl5bOsPuxYbKoQeQoA1O+Mn6SGVsyvDg44XHcaYxkKkfHrbij8prelNgQPVpifGFJIpG5uXJVb+wDwlPo5vv6dvOpPrMS3D2Rph2sglrfvx4sP668JuW0rOYl8nyfQWArrpiNovN3/OfEI39QtWPEj3IoglvhlsuVM/HIsGJWWPjPIwId0QrhRddKbxx6zK8yRaMUc+injSPgDkpGN2kjp8/UAViBdqRN1Xl+RungfTP2MO3SECGR+DviGgIKh0E3
 Mz1bPnlf
 qHW+09P5ovaJ7QaTXJVWACNHrHu3Vnn3ygVhkgpoTA6EhdO4glLviOOb6tsDsnVLqR7OqcGPNIdQFJ49Tl/p20m2RouWiJnf22u8xYo7YyOWuhG4O3duGNGdJU+xk7/P0HK9l0KnhGXgaziAWahRH7M8gTgX0GvAkL6/2j/l9ni0jGYd6BeOQF8olUdDh+/+vThDavrhUNhrZxe+tya19nYCvjhrLBFM70vIafNjFzjWTbl8axiVCatGG05LNnK/9rpqAcXy9Bd5o2iES6hQ7PZzBvb0lwnpNCqIVP3lYdBgrWb1Y6OePpRNdOs3gG2mb1nOZEYlaxjr5xoSeuV13pcnazlkMI//+Xxw7YrAYnBb4jAHwIf18gsxsaTAYN+y3RfY2mHtWOkgsW196mjVSEEyyQTStTatFUq7i26FXMTNH0ABqAVsii5DM+1qu0WKx+CDll6W3vf4zN/RZkJi1TVPI4BZNP/Y1KkX4C8gFw0VMyVFz8QI9eGTdmw==
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
 fs/dcache.c                    |  1 +
 fs/libfs.c                     | 21 +++++++++++++++++----
 include/linux/fs.h             |  2 ++
 security/apparmor/apparmorfs.c | 13 +++++++++----
 6 files changed, 39 insertions(+), 11 deletions(-)

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
index a7fab68fb4c9..824d620bb563 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -931,6 +931,7 @@ EXPORT_SYMBOL(dput);
 void d_make_discardable(struct dentry *dentry)
 {
 	spin_lock(&dentry->d_lock);
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


