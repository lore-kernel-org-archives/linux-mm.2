Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F4D8CD1297
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262C18E0023; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D868E0026; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E18728E001F; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 713E98E0014
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4924E12D04F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:33 +0000 (UTC)
X-FDA: 84097415346.01.EB66428
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 98479100002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=OsRGle84;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkByHERsS9JuCtqGS9wCvZ7R+EhcIoCC8ci4VG063fc=;
	b=yWlgNrbYqZt/HNUVeFD5OTjwEr7uzDpLgaXZDIb0NrBc2WF8V+w6frVtCyjtmwSMSbNCVS
	IUfNzRk4MkYgTy2n5889GcbH2kkKw3XH3w91blTfdB21sBG8k5BWEuT232qZjB6tA8Tsjr
	ozHO6rYuUtZc1gwxvEmwk90e98kloMI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=BLUlC6aPH9W+zJCyrn3KKhZd5uZjSTVmim8xbdL8/qGE5WGic1u67pPa1HPASKiINKWais
	Ihpvo9M5Nr6sc3BNpC1t9Evq5UfN5VVoaMoXU8VGRzM+a8JLz3haeaaGrmFrEV+qyU2+cc
	VqeMaQhhXq3ruVNkI7KiXfnmO/7lXV0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=OsRGle84;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bkByHERsS9JuCtqGS9wCvZ7R+EhcIoCC8ci4VG063fc=; b=OsRGle84xX6lCMsOqbmX88O9Vv
	QCGMmghlcMX+6qLKlD9YKtDKt/l7fD3/fJuRQCcxCewWhB6+puUIARCAP4cdHhdwrk97PNTrKy26Q
	8csjifXGqpFVsO9ko9DNm/2juQyXZvXFmkWFAeWU+31WAdIv7cfWan9d4z/6lgn5AjPSiVVRTdXaU
	VhylboWKmDvf+1FPY/jegeXzt69CLtlo6J62v6F96sm5LguMFUuvDL6c0RASnXkK+tYJuZ/c+7FMb
	jUPSTT+hCcfBeXvrWHIi3KnwppTrUqUdM5EsI3H7rnVi1AuKn23uRGHjcgBa/LO4606zdkJpk/K1m
	OCyq9HEQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHk-0000000Bwyi-0fof;
	Tue, 11 Nov 2025 06:55:24 +0000
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
Subject: [PATCH v3 19/50] convert tracefs
Date: Tue, 11 Nov 2025 06:54:48 +0000
Message-ID: <20251111065520.2847791-20-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 98479100002
X-Stat-Signature: x5fwcgcnf1dputqz1ocphwkx53ngmr7m
X-Rspam-User: 
X-HE-Tag: 1762844130-855552
X-HE-Meta: U2FsdGVkX18zobb/DnYrkwEOwXRmSZrCJjaktleMipCtrgKoaF4NyAi86IDnfXNy5pSJlcisOO+iqoFxgpBbTsrMTlALo/GuDbz9JOFibXYEWslUboxHpsVZThISK7OcR9Sdh/Enu1Hsd4NWzyNamGhqNNA6ikncSoJtixjmih4gw4Y73F8zOcOStufvm7mgwh5/ZCEyk/viPE/H975S9dbfrHQQL7Oafd3bP+xleqyclgDp67b5biuzg/gzVfqZcq0kmXT9K7BRdqm8SfPHZhI9mlG24udMiTrCakigJTLmG+QROip/sjSb7MGtWK3lZmK6nSqJSdCVvSJ1lLXRE96JCUk2h1ZSjnW0Dtyy3ajgV7Ol6WTuMi/s85Uua3MGuVw9GJtqgoOd9DAVuF6MNr/FTrKcloH7121xBv5ssK86UDVEZDKoq/P5coJzv370/Q0WLm9HbSlBekq71jikk6K02yaIPuS6O/B/2LvdC3R7t4EIe0sN48iPzfP6wvcIcW/dXTubckBtNOAXTNU9kpkM9GpcEQ/0jxdPD9QvZTX4K/DapUmMepJT1XfPFDsGN5D0SmqccL+IOUUd8SrpwUfIZGjuDUlTFXhlbcIlttkmKlm0YkLNjdm0A97ra0HbITFqexxoFsykRiFw3xnWUmfv+TQ+Oz9AML9SNYmUOOpbusjRjEFdo2fr1DZckEMLfrUXJ2dDR92G4ql0jiD45e9Jv55O2rDLZsQ0vNgvs3AhzocVqJXHEF6uv/ZTLUBghF0eMN/Lray0BBzyCj1OW+7w2eGRCUow0xTBCriHW4fL5OWe0xzbGyZDN+n/E7TxNTTVgXVpLTdhEvAOg51c6Ixh5BYyTGcTWrKZujw8prE6LEKO4Wng8aACF2C6aXXEP0jJ8yntrlxRbh8Rs0zX54H0okHu68AoPrdeX1Asx3e0xWN1b8Hbf/yJLO3BVOwT0vcQcLb89S/Vv/yBPH8
 UNVdp5yY
 frsTYwrjljhQ96ZhVDthbg/PwhIyo4ZP174RZuq3nAWbSdD5gJAVPnIuevFcTJpr5P20IC9n4Kx1DXEezdklS+SP03jS7BZ+7XRrqMEHOdrDy5sw=
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


