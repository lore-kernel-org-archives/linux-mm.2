Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD0CFCED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1A58E0039; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B1E8E0025; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFF38E0033; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A4AF8E0037
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13B2A88BA7
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.14.CE40A43
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6E8B2C0008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="qLj/7H6N";
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkByHERsS9JuCtqGS9wCvZ7R+EhcIoCC8ci4VG063fc=;
	b=MlYCK9Njx0hfxk/65XULslapmGX+w3rg0fetwFJRRR35/EdU0ijlyuRHmrhTwBpMKGzQU4
	nrUFnucgjNh48LBjtqjudvWzdopDsFt2tYyY1obycrO3Tiv5IHTdgGN+sO/Qr1bdBocMpL
	jprxPslkv+eAHM7arwc15Gukf/VN/Uc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=VW9apilbpZkiTJhZaTrAsx9SBzvvD3L67C6KlhNOYj4ZQa+ckInR7YIcnGMphfSAftMQ0f
	0s8DRABB3YD3gB24bxGzOLozGfsKZCCcrnQUD5k6R8y806ZePa+uO4Fg/6UBWW2U85HZe9
	xvKJ+1ImypPeY9/YoGR8aUaRr8nAQeg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="qLj/7H6N";
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bkByHERsS9JuCtqGS9wCvZ7R+EhcIoCC8ci4VG063fc=; b=qLj/7H6NiPG0n94Gna+yDrzg5z
	O8TnSsAYvukbv72G1ptRDOAlg1yKJwNl3/3uOgeYhGYWuSY1Sjr+sp74hJ7lcJG4LR5Y9ZJAscTgd
	wk0/nHfysG3kQYtOETjk9T2+bxfWxaxebX/saqsiuZLJxJc4D4xRL9WbvCxN7x+sxmsowfAmPEg3W
	ouJPGUpb0fSN5LBKZCWhMM8N+NdW+eXlflafssE0DC225nLx710DR3qBiIYGK3BBgdb3Zfkml8xcZ
	eb3nmdV33jV8XJfc527j1AXGZ2F6mA8HtYJFlf3AQyWJ2YRMBV+u9Vv2p4hqit1DT/fuAV9u6PjVc
	asCtLblw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GERY-0jfj;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 19/54] convert tracefs
Date: Tue, 18 Nov 2025 05:15:28 +0000
Message-ID: <20251118051604.3868588-20-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6E8B2C0008
X-Stat-Signature: e9rfz6ijhrxw473381pgf6fiz6t4iqed
X-Rspam-User: 
X-HE-Tag: 1763442974-81570
X-HE-Meta: U2FsdGVkX1+FMsGMV59jwVsq+OJicosTLw6RoP8phmTrB+Oqn0Vut0pKWevwbue+FZ/3U6ltibXf0CTrWSAsKZ73wLi6LxBxrYe/QASs72ctYX/zjgx7pZQm6TX1FtwU4cOExkMBio8ad+U9ahJ+7J62bnM/qERWleRX8L0/fpHmUKBdBDPNq73HVzAPpdeUo393O907fmGtyaFZu4UHP51GJo85ALqbHh1bryCTK1MBGroSR3rRbF5cO6JGUEjcgDSzMYVy9FlDxs0zf5K7+efGuo6n+tqWzqwcSGMEmv9JdqpSL0aKWo7xWghhlLTt4Q8GlEtrJVXYhV635vPyHxY3LRPYvaHBaR7O6IGeLfFg+nHjis2vRupNFXiG6Y0fVOxQ56knxsJfusheXfHG5foh6rEYAFjAxr1vS4yzoNwjAbrky/fWw/PKNAnDZBdnr8kfIRxeIElse3wTfnPESGiFR5lNYmgbnjlX+EZdnkerJp5PID4Cq8ER0pvKZX23zpoo2qkmJsMQ+CXeCM1F2dshgD0G1P68gROD8fodEuvuJROIHtiEVKmuPpvq0qZ+0GBvuaUa9dbapRu3lZFc8WYhG+t+n9ptipsWb5wUDFxk9rj9/zDt9D4CxNgn2IHxXq4UIDlV6yAHD8wVGMg3MreTtzxGgWqKOo5nKPe6UcuMLuLbd+PYdG5q3z5PANI/rYHbAW8Af4nAmEniCpPJdMgJnoNHaSrHHPN/GS4S8ZvVbTkz9YbalKHxVATzEKMuwEJU5u2hN8UeGV04jlGMhvcwjsb7TEayiWeMsRjdCg4FVrPE7k5twzI5r71F2SHXoR4Ll0VFKb/XaSrX66VNgWj1NjZipeMXhwmfTHhO/CPXWtQiE5sq3eU6dVpxyOwbcAagukf6CdLdjMnKBuTgrsngRhTMt6O2bLzLGcHVrO7DnJ0/QI3f7YlGJtMXr+PjqEmmBfbWgXZArSAnUuA
 6tg0/4fE
 FF5lQKT6pqfUX5GV8XND4ZpRon1lVRn+v92fNTgYD3KKWX5c+Eu97TWGD1z6/GsV3cl+8NCOdS278XekUrj3JvnMc8lzCSlr5/JJOSyVZOCPi8mZlUCrWlsMVov7lUreYrcDQQIqIpU8E4d7OsUNwGhcCmMRMHsts2zhW9a0mJr6B+2HIQVaCVf24GZCgrDYyL7TG9z2gBkSTmkF7U27clhGxM3hBfEN481+YfU5SNS/2ok5+uzvYPdn8LiO1BHLTvtH5arcYJcygV7i9HL9mvQyUHpfe1AfW9p3PrtSEyISe+dgKkwOwCNqoj2nZeXp19UI5aKAmOjsh3l9GoOKzsjLiyoT2AY2BoJC+JY3CCqzGRcrPH3c/RDiUcXiR3ZxusQeW0W/fpRyi/bfnWJAEqSiDwOe1sqkIIf/g32VckKmAWlvDEflC9H4OdGgWZwaxVW3mTVIyRYRLbFn35iPOfHL8VXnKIO5DdlO/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A mix of persistent and non-persistent dentries in there.  Strictly
speaking, no need for kill_litter_super() anyway - it pins an internal
mount whenever a persistent dentry is created, so at fs shutdown time
there won't be any to deal with.

However, let's make it explicit - replace d_instantiate() with
d_make_persistent() + dput() (the latter in tracefs_end_creating(),
where it folds with inode_unlock() into simple_done_creating())
for dentries we want persistent and have d_make_discardable() done
either by simple_recursive_removal() (used by tracefs_remove())
or explicitly in eventfs_remove_events_dir().

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/tracefs/event_inode.c |  4 ++--
 fs/tracefs/inode.c       | 13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 93c231601c8e..61cbdafa2411 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -823,7 +823,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	 * something not worth much. Keeping directory links at 1
 	 * tells userspace not to trust the link number.
 	 */
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	/* The dentry of the "events" parent does keep track though */
 	inc_nlink(dentry->d_parent->d_inode);
 	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
@@ -910,5 +910,5 @@ void eventfs_remove_events_dir(struct eventfs_inode *ei)
 	 * and destroyed dynamically.
 	 */
 	d_invalidate(dentry);
-	dput(dentry);
+	d_make_discardable(dentry);
 }
diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 0c023941a316..d9d8932a7b9c 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -538,7 +538,7 @@ static struct file_system_type trace_fs_type = {
 	.name =		"tracefs",
 	.init_fs_context = tracefs_init_fs_context,
 	.parameters	= tracefs_param_specs,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 MODULE_ALIAS_FS("tracefs");
 
@@ -571,16 +571,15 @@ struct dentry *tracefs_start_creating(const char *name, struct dentry *parent)
 
 struct dentry *tracefs_failed_creating(struct dentry *dentry)
 {
-	inode_unlock(d_inode(dentry->d_parent));
-	dput(dentry);
+	simple_done_creating(dentry);
 	simple_release_fs(&tracefs_mount, &tracefs_mount_count);
 	return NULL;
 }
 
 struct dentry *tracefs_end_creating(struct dentry *dentry)
 {
-	inode_unlock(d_inode(dentry->d_parent));
-	return dentry;
+	simple_done_creating(dentry);
+	return dentry;	// borrowed
 }
 
 /* Find the inode that this will use for default */
@@ -661,7 +660,7 @@ struct dentry *tracefs_create_file(const char *name, umode_t mode,
 	inode->i_private = data;
 	inode->i_uid = d_inode(dentry->d_parent)->i_uid;
 	inode->i_gid = d_inode(dentry->d_parent)->i_gid;
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(d_inode(dentry->d_parent), dentry);
 	return tracefs_end_creating(dentry);
 }
@@ -692,7 +691,7 @@ static struct dentry *__create_dir(const char *name, struct dentry *parent,
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(d_inode(dentry->d_parent));
 	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
 	return tracefs_end_creating(dentry);
-- 
2.47.3


