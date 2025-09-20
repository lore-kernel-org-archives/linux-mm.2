Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EEFFCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 09:31:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE1298E0003; Sat, 20 Sep 2025 05:31:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB91F8E0001; Sat, 20 Sep 2025 05:31:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6288E0003; Sat, 20 Sep 2025 05:31:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A8E3B8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:31:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5467B140974
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:31:50 +0000 (UTC)
X-FDA: 83909111580.30.BDA0B7B
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id AD6A38000A
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:31:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bV2+kI0z;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758360708;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFJhWT682zp2bwEKFvW9i8BSPxz01sZoJXb2oci7JmI=;
	b=3YxQD3Gi5v7cTIubnOBixnTSQPcE+EIXpCaCcqkqx+10dI+4WWY5B/UjOvw0JEdz3Z7wJY
	2hqjwZ1s6nL8tZiI40KVsxeKLHEJGjbbq3E06Ml7V25RlZSyeR2qVq7Gh6VnWGLu/C5ItL
	mMhd6Tlpnrtm55XxSO5nK/B/Tewxqs0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bV2+kI0z;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758360708; a=rsa-sha256;
	cv=none;
	b=YRhWweYAITkrKJkPA6+Fl2qOogNkmygiFc8Bi5jNNOgWqi8UI/WXBdK7A8MEU2E6mO7UM+
	6WRtNy5r0hPQWGp6m1gU/i8Usyk5dXxIM9Rk/q3cRoGIFcRMfHSZz2OV5ENwdGIpzZaCFL
	nKCf3DKXj1DMYHD5yFBpVkzGmiWJvTE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IFJhWT682zp2bwEKFvW9i8BSPxz01sZoJXb2oci7JmI=; b=bV2+kI0zUV6aWxv9SiUc62zyXt
	QIfD4pbsn9XKzGhK9EGj5kWCbG8JdzK0C9YbrU+7/KrnyVAQ3nzAs4g96ZqJXO4Un0JhPRCWdnthr
	MfkA2V9W/BPNyNge6PNYSVNtRt8VtH26NKtKMQ/UU12QF9J+e8v0d+m4/MGdGzoAjF11WWrZrlF4W
	nICvf3SDkwQQr3zKVpEUuuIMnVagx8plgL2Q6LVVNDENjptnU56vz83GAg3UDSWHlPdlRY5T7bMr6
	rQBWLwORIgOnaDV3aY6xXTuJ4FQPWpJUMCjAq+R7Xe2az+7UiQLtOnyHkHV1OZxM3To5+bU6H/nc1
	gum9nxvw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExD7-2o8f;
	Sat, 20 Sep 2025 07:48:01 +0000
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
Subject: [PATCH 13/39] convert bpf
Date: Sat, 20 Sep 2025 08:47:32 +0100
Message-ID: <20250920074759.3564072-13-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AD6A38000A
X-Stat-Signature: 5ref8niaqwe6z5k9t7ga7f9m37nb3pko
X-HE-Tag: 1758360708-511866
X-HE-Meta: U2FsdGVkX1/cbmr/wAm/FSk95+IobSYPSL0F9J1DfZOsPOwse88FHVXisnUGc+yFfbHz/6kJ6jn+GgDicsgo6bfQIly3x+tTKPBm3XxVV28+Q+0EgXsFrs7czLtXbCGWikyCJNy+vzw/Wl7e6Dfn/rdkYcIskEXh4g1FBZqSv4QRITFxKJcu2DISQBYqEvy0qkRjPzpx0clWJJHPDfCvPEklk+rt5uUS5DomUZbQ7D8gZW2qfxNJwk0fKThyJcAMzD7/6yiOySxToS0kQN+OWiy6MEWhc5qeKgVmhFVabC5n4hy/seSP2GxTWutU7MUeoyb/GmggTdmmBcL/EDc2tQjPtr2VhEy775InXzC9Uqg7pdOD1Mebso8tkTNvyv5O+/uNe9oW7iRKoUVfX9imZ5VYCBfkzRPc21vNNmb5O4U5BXGp8MiDEaDU7qJHDU2YZFLAjT3D1g3j0bNcgI5JB/voIcCjQA/C5Th5zdeV4iXKQ6IXbF9n0/gR+ltETOq10W18XMffcCfKDM+Kp7LflaeLBXhNkd3x2ACxs0jMpNLpf8YymyR5i8tLH+vQUD5t1XcRgO5sA6s1U8BuhiPjnfp66iiCBV+TUJPUUhkceCl10p/lNq/yApb+ovlXxXnfDkcIQiGNKzqzo7qCw6rmK1euYc88s9rTrB3FNcTeQvFNWmlW36pY/Dgo/Xw8YdmBgR7n4dXWcyYyRmKnE1EgTMWHtqVB2q1U1KUkziQFY2/Eek7dMsYuE1PaJtFW1ifBliIi3LBfhKviYBlwKEUXN/iH0JCXjN3AFCu3dQk6m23P5NlJMLYFftkDYwrVSOrJShMPwT1U9IVmsedtw0qeYujwBOk9lT9NrY0aPsva0eP47c92aKi56Gucts9ipb0u8N5LE/hWhdrMVO7TtkqGTPf/aNxGT6SPHEMp0koGzdKmNfTffk4cGVFc+tv6evHEJ0o+TGiXkZ2WdomNdt1
 7ixQ+/ts
 19rZVj6cQPE67Jc/3gMERfhBempQG+8BKrhei9wWDUQVCzcvOz+wIId7ZIOvOG1/1xKGsT1JnoEKarBJS7jeg/czwuximLGvBT5yr4hOJbasdhyMqliwca1+XstMqBhrdzj5AiA0J3f44Ss420yKW19Qsd5EEWcjVfXp7OpJVPH0Y/ZSN91/Q9I6ZblFJszU5FgYsmbBO2WOJRzHvw9UXgPKzE+bI9RWqwaq2sX9XZR9E/wAyERaXkZRpA8N8cP5OBS7hFpvnb5uDAqvkSz9PXdEVY8ui2tZdUo0LsgxsFyMaLnaVrXUDQelAngs2pThzDlFquWod/+2aPI1WQ6tIPQZyLiAo1MkzQnew4ktytKR7FNJ3nlupNauUjLgYMII//492p4h59s5pjZ0BY3ygRkDTVCC07Lp/3P9wCNF/1014/G9gPIs7gmevX12Jzo/b+r9OZAUhVIphvfc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation goes through the normal VFS paths or approximation
thereof (user_path_create()/done_path_create() in case of bpf_obj_do_pin(),
open-coded simple_{start,done}_creating() in bpf_iter_link_pin_kernel()
at mount time), removals go entirely through the normal VFS paths (and
->unlink() is simple_unlink() there).

Enough to have bpf_dentry_finalize() use d_make_persistent() instead
of dget() and we are done.

Convert bpf_iter_link_pin_kernel() to simple_{start,done}_creating(),
while we are at it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/bpf/inode.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 5c2e96b19392..b9ef1f80ade5 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -144,8 +144,7 @@ static int bpf_inode_type(const struct inode *inode, enum bpf_type *type)
 static void bpf_dentry_finalize(struct dentry *dentry, struct inode *inode,
 				struct inode *dir)
 {
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
@@ -420,16 +419,12 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
 	struct dentry *dentry;
 	int ret;
 
-	inode_lock(parent->d_inode);
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry)) {
-		inode_unlock(parent->d_inode);
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-	}
 	ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
 			    &bpf_iter_fops);
-	dput(dentry);
-	inode_unlock(parent->d_inode);
+	simple_done_creating(dentry);
 	return ret;
 }
 
@@ -1080,7 +1075,7 @@ static void bpf_kill_super(struct super_block *sb)
 {
 	struct bpf_mount_opts *opts = sb->s_fs_info;
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	kfree(opts);
 }
 
-- 
2.47.3


