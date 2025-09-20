Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A24BCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10C638E0012; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61638E0011; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D9CE8E0007; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4893A8E0014
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16E88140956
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850256.25.74581BC
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F1611C000D
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qGj6Qd1X;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jq+EXFMBexcz4hv/+ZNoaAPHC7nvuwAoAqAXIzjgm4M=;
	b=CY+hUp4/WYk7FbZjagG95Mg6fy2MsADxLFGcSr4t8/KdVZE081JXOSzf2nshr/LpyW5Q3l
	9nb7ALhCwV4JNQxc4B/LEn+w5+K7s//RVFpcaH/2dh/wf+cRqNXFZ6DY+gNP67ljvFqyBq
	ROkjuiRFMxumDHKOoAfpXQXjDgWjnjE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=4O1j2cCb7MwuPpKyU46xsMBCa6bQGkAnUMGUx7q/sw6nNRCmBw4xzkE7i/jYmqgVWlYIFk
	3XaroVyYyiepC68xzo3SUUjQDzSxkGaY5RtmZXgniS8ueSXZhjirIv2eIgz5Qhnz9k67QN
	a+N3+RFHvm7mUPRni6Q8i1qAnHBBpas=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qGj6Qd1X;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Jq+EXFMBexcz4hv/+ZNoaAPHC7nvuwAoAqAXIzjgm4M=; b=qGj6Qd1XokjgMX/A4lEawqmYbu
	alL8tqwhPjue0tgBhcw5Sxy03lWJ9m4wYHo8xpUh6q7TL4jvi4RXrVFQduGY/HeoSj35Rp3FAJo25
	SXacEAK2QID+FsbpDJovwzlVS91WcOd014dnZTSLqhX2qlY4iAWnohdDimuQDnuVlWYiGnUHnOeVw
	Hg42qAQRgnJT3pTXZaons3ZMCLfS4632o4CT9VwcEoJqZsnfn1m/PmU7lbwm24o2FbJ+PWDjslSt0
	OSeamM/KE7vwJygDI7gO78JIO7vikOagNTXVm+td9MSFXYm5tlwg4JLZI/wHwfUKbdatHjWohc7dy
	NO+YlZ9w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKA-0000000ExEW-2fN4;
	Sat, 20 Sep 2025 07:48:02 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 17/39] convert tracefs
Date: Sat, 20 Sep 2025 08:47:36 +0100
Message-ID: <20250920074759.3564072-17-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pzomyta1c3u7ozqg5erqbye5zumap9kp
X-Rspamd-Queue-Id: 6F1611C000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758354486-484322
X-HE-Meta: U2FsdGVkX19zDlsz+VyRHPqrScpcmt4nO4NWRVtiMG/PfyXtZuCGgflJX8pgb6+Y3aZFpDQBxR+T6UQ4fT0mqbQXZiEBrWg2vfLcV1UKWJrzRCEjU7BMTt7auK7ZcsP7ONSm4S181RZAcugNz57YoS2aK3Pyz2jbAqA2Zac1Jin6lINh86u0L6ZZCVLx/R6EBYv8GhCkYpsl0SNTC4Dxa8NOaYeUUFgL/m1VES3wqTth2RmEjw63mTuEOwCFK2Aa107u+cjSX+hy3LO/gvO4KYyClEDnYJIaADUjGd5r6Ukn2GO1yn8Wev+UmWJWXc4ZNEs1LVadyzoMp1VZw2wA2+8khaAt8tPwwkThY1sguxrx9HQ8Opy8vXbOt+Nw3ZdPWUieb4AbEKlfSNFhm3q3go/JPIqI1RYDLPtCaNm4rw67HMJSQ3lClF1lWnRRYLeGX8Db3A/BEgVvlXY/EbxNjWijW0FkNXTyg0NnOnxnWqPpWPe/2E7+PQaQAVjQUx5Q5W8r0u5iOkiXSr5zCZy1g0UTcjYElZp2ntpgrQ9p59qzyLb+VCteI87YOM7u9jT0PJUm9N11aqCFjbHZtiYN+T8VmLzwlaNRl2CoCV7rcxPrHUkuG5ovsliCas44MzIlv1hOH+2XW6rgckYat0/MFxlorpXLESWcr2Fl5r3+Ywe2s+tyTQZTpNg/5zlNcLqHVem9oQwFHh3u9LZK+F40qxwoO8Py6euEvKWCwcB0ILSs6fMtGFVtigf8x93UXHKH/siSYNWTi8BuPyM7M/AVEh2Nc/aKCFA8MCIdZA3kwSaaS9yicvDuqubYad+P1T47DfPk26/drckGQmXsvh53dBj7at5PNgAHee0VUoRIMxbq7qirjKneR3OhEZdN8/Jk8xCNbfPFkrleeLbFbVSb14b21/BdOYXbXhEusIuBeTBd2eQARjMUDb7TxzO4z120y47h/Vfql2StU3mhkJX
 djYghsH8
 RzJBtP4Te+UdUPJZgHk52kt/7QJ9KUsgHHs7KFLmQ1MXQ5ohN9EQ+OzgWnIO1dFTeYF8sEE7xVBnS+fJfgDIupP6z89WKztqjtIHZEqGhe86NHwJ7WA86xFjqwK4un9EG7KIThKEn4hqzs30mKd7s5ogU0KMVhO+z04oiEOfEwPhHNhkZD0nI5+/tkyvGyY4MhlS7Rj33sjpdUKD2DAnKvymdBr0i+leTmZtluGnTAscnMClLZQqcsTGf/YBL8kdADep48RIbBZkb3L5TqJbnxFYgKwX0LzD5K1JPKvrwbr5Bt5vsxV0qfiA7Vg+gDNB4sHC/kQz+hWlOg7a555WTqB2y1/tm2vZZZnAqaqqWmvxlMPsaIvbWdNq+LA2FSVWy/mkSmg38pRvBsBRb1Yk4zPPyya0tGU7Gbpv1
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
d_make_persistent() + dput() (the latter in tracefs_end_creating())
for dentries we want persistent and have d_make_discardable() done
either by simple_recursive_removal() (used by tracefs_remove())
or explicitly in eventfs_remove_events_dir().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/tracefs/event_inode.c |  4 ++--
 fs/tracefs/inode.c       | 13 ++++++-------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/tracefs/event_inode.c b/fs/tracefs/event_inode.c
index 8705c77a9e75..97bb0a79b0cd 100644
--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -822,7 +822,7 @@ struct eventfs_inode *eventfs_create_events_dir(const char *name, struct dentry
 	 * something not worth much. Keeping directory links at 1
 	 * tells userspace not to trust the link number.
 	 */
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	/* The dentry of the "events" parent does keep track though */
 	inc_nlink(dentry->d_parent->d_inode);
 	fsnotify_mkdir(dentry->d_parent->d_inode, dentry);
@@ -909,5 +909,5 @@ void eventfs_remove_events_dir(struct eventfs_inode *ei)
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


