Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4E8CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70678E002D; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D2048E002C; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C14C8E002B; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FBAB8E0028
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 521DDB9801
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:37 +0000 (UTC)
X-FDA: 84097415514.12.9BB11F2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id B1F1C40005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fQQLWDOI;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844135;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIO5z+XlaxOUN+dxGxWKQXIfyt7HKUVO8xN2mehuHOs=;
	b=bk3dhkE6P6lVy3th4udt9gruXVLfLmk0TlejcgI8DLuGlgiUbimTAAPwX7Vc4y5vp6AGvD
	pJuZYgYPOZNgxx5XAHilfztQAozKDlBuCdrrblzWcQ5wQDeElwJmDKgIs0Bj83koq5zf7M
	xAKQlPqME2X1Wmo+/JAwxWjqIWneT8g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fQQLWDOI;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844135; a=rsa-sha256;
	cv=none;
	b=EZzTSrFEQlwtG8FPO1jcPU7848jHyamxIPiqkY7h0KKVk1iZEIzkekJ6+HH4U/VGGqMhgn
	3NFl8HZZYZ7QC+JmzZCrU5lWWSZRG+hGtO9pY1+Mn+5D0wONuLyj+GjFdoHDlfcy5IBhhM
	ZFIhwe4ovbscmqgCCDKAtPne1rVQz/Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aIO5z+XlaxOUN+dxGxWKQXIfyt7HKUVO8xN2mehuHOs=; b=fQQLWDOIQU+ymcNCRWD/5GW7sK
	eKR1VjOGfKbsuKfP5Vp260+aAx5GkV678UwOFuvqCmUfpROq3rMVfr9wj5D0b80dNNuSLwodGXcwZ
	bNGraoQ23tvzejiIiNPfhMjLNHtCwb5QC/bnFJRH8ExDJl4BgdeEAM50Lh8SMt66DUVqEmMTiz6dr
	SriBmp6n/sQApLR49n9tAeiqTk+MAPGdQGLrS0K/ugMA7SLP7JtttlfY3mcBHGECo1EiFGrUHP7mL
	HV7N5nsmHf8l4Uhxrko/5FeY2/29X5l8QilfKsIrWojIG8QJvO2ZIvNY/b0k/Rh+zff5LtAsZ8q+i
	3v+9o20A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHr-0000000BxG6-0CNL;
	Tue, 11 Nov 2025 06:55:31 +0000
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
Subject: [PATCH v3 44/50] convert rpc_pipefs
Date: Tue, 11 Nov 2025 06:55:13 +0000
Message-ID: <20251111065520.2847791-45-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1F1C40005
X-Stat-Signature: qsys677q5a97uxqmosmt8hw95pftrd1b
X-Rspam-User: 
X-HE-Tag: 1762844135-43761
X-HE-Meta: U2FsdGVkX1+QAj4EEs2gk/1dWxRQ16Lha8xFTtpzE5+TKPVN21X8wRPs5VIkI1ecyepIaZK0OUeH9Wbfxnf2X7zOKbokBUfXbXw7EfgVa1i0D6K34jKyYEnJ1l0pFWJzPi+y5Pp+E6aOnty9Nc638yhX+GmBrB/8ZZxpBMgv09HPyP0uQfIz9Ypq1O5Y47rdHqsNoFzztQ/LQ5dRKNcEo09F4QgVhlBcJC0uFwC7y5jVs+cY/2rWk7I10UFNLLm2H4zcQspFfAUjh/f0LgJS4Cxn89jo7M1jQ1XZOAx/b41aHvZUykc6bGWrFcRlzKjDmsKZNVgMNktCYBkkVlpdlA4RTBaSiUznuBney1Eank24p9KSYjt2yEGMTJawq4Xl+8vhXEMVKgNG2o094dmyg8TsD0v8ERQBhDjaxF0/V0DWtC+cr0n2co5G1ZcdlLa/zM20LpSpNYQOg9aHzdj88S3ohwx423nKQSexySaI5P/VZlAAhRPMXNwUMgGD5lsmdrVijAVqznU564XddC4yF37UHk4X3KQrPd8r2VIRLDS5boVcGiwV0ztBnd2zBr2VXlLuGyF42z5dFeSs+1L6xGgyMQI7SeXljhXoYOFAEuc0eikd5RkFPMxrEEGFYhsZL68XfArzCR9s+CWlFWVifbxHqsH/GaI0NkppmQHvqfucGtaIdanCjoueI1MWQbbqnc5dlVrRQAmF3PG+9zugDpeAS5yY3bQKU31u6MR7ZnPk30X+uG+ON81Z80N8SRy710hYzDzl/Shi8gUo2aD1dTeRIa1LDnpSByWce/2YLwUaQnkMHBBebzlcSeHwEjh+SZUG7tQr0SCWinOnVXRnE6mIDyZ8+pweQICgi1EoaKgzXLl1TKyxwroSbk07kagSD2ATwVcyjjP2e08HP41jqF8YNQiabQQSoK0owGRJ9CHSAgmBIq+LlI3sRBrSbcTXkgAL5gooq9sjozYPsQY
 rCbApDu3
 TShSee8iRqrPJKyK8RVWiXnPRjM5uOYn8UmVrKlze4UpKsEMGP/x+o+UKDfHZc5iLS8BbM0/xdkc7hUP4TtN5GxVIWk6J4ROz3C3MwYbal+OjFYGCfrE4bcPRXrnoxJ8In0428PzSn9sn+zNm+6+V7gmVLp7byIdYQYTwxYu1+4vXqgorl9znjVcxNL1mLPW/+l/Pa0xMUHSuIs6NdmmwlxHMVO91/KWWIlZhSsnbvyja31yF0nGC4vJscnnbKP4VIxzU9hmbFrGI0f7uA/9LGG23tF1mU0qVWYPy5eWn+8eZiEKTF1gpBX7EJoyQgF0bpy3Pdw2r0qatK0OUbIz+kfS6kDxvizr1baOGnV58qvlWqlvyBpNQfwACi73D16LPV38y4VZ2C4HYfhgxlvnFH77HnK/iLvQ9D4LYfpa6S38xaMSCJ8j5Egn2NU8fdIw0NcBRz535rwO1B7ayWXaA3ucEbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just use d_make_persistent() + dput() (and fold the latter into
simple_finish_creating()) and that's it...

NOTE: pipe->dentry is a borrowed reference - it does not contribute
to dentry refcount.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/sunrpc/rpc_pipe.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 0bd1df2ebb47..379daefc4847 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -536,17 +536,16 @@ static int rpc_new_file(struct dentry *parent,
 
 	inode = rpc_get_inode(dir->i_sb, S_IFREG | mode);
 	if (unlikely(!inode)) {
-		dput(dentry);
-		inode_unlock(dir);
+		simple_done_creating(dentry);
 		return -ENOMEM;
 	}
 	inode->i_ino = iunique(dir->i_sb, 100);
 	if (i_fop)
 		inode->i_fop = i_fop;
 	rpc_inode_setowner(inode, private);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 	return 0;
 }
 
@@ -563,18 +562,17 @@ static struct dentry *rpc_new_dir(struct dentry *parent,
 
 	inode = rpc_get_inode(dir->i_sb, S_IFDIR | mode);
 	if (unlikely(!inode)) {
-		dput(dentry);
-		inode_unlock(dir);
+		simple_done_creating(dentry);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_ino = iunique(dir->i_sb, 100);
 	inc_nlink(dir);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_mkdir(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 
-	return dentry;
+	return dentry; // borrowed
 }
 
 static int rpc_populate(struct dentry *parent,
@@ -657,8 +655,7 @@ int rpc_mkpipe_dentry(struct dentry *parent, const char *name,
 
 	inode = rpc_get_inode(dir->i_sb, umode);
 	if (unlikely(!inode)) {
-		dput(dentry);
-		inode_unlock(dir);
+		simple_done_creating(dentry);
 		err = -ENOMEM;
 		goto failed;
 	}
@@ -668,10 +665,10 @@ int rpc_mkpipe_dentry(struct dentry *parent, const char *name,
 	rpci->private = private;
 	rpci->pipe = pipe;
 	rpc_inode_setowner(inode, private);
-	d_instantiate(dentry, inode);
-	pipe->dentry = dentry;
+	pipe->dentry = dentry; // borrowed
+	d_make_persistent(dentry, inode);
 	fsnotify_create(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 	return 0;
 
 failed:
@@ -1206,7 +1203,7 @@ static void rpc_kill_sb(struct super_block *sb)
 					   sb);
 	mutex_unlock(&sn->pipefs_sb_lock);
 out:
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	put_net(net);
 }
 
-- 
2.47.3


