Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56ECECD13D2
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7A98E0016; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BEA78E0025; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601368E0010; Tue, 11 Nov 2025 01:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8FC48E0012
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78999B9807
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.09.C7DE320
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id C70D8C0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=J53TPJ+O;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lB/gWST5s3/zNGGpGrNmQn0s9XjLn6XUo6NFB74HdeU=;
	b=GdpkKHdSI6039KieT83RdsV1NvfAhSY9UtsYpk6674qRVFBxUM+UuR4h/1UkMCSMIWIca5
	23Tn9yvPMSecqEzmNQEC3NlQQXMfkfUzJVKOYFnSd0TWkpUttey7W231LEryJMpZ+4Wtpk
	lrnech//2iujc8C9sxCHKNoBeUJOhOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=fXhs0riCBz1ZX6Czxc4JY7KcUlMail34HMiutsy5XdnHYwa4q1gk9j34TT3tjz6TsbSioB
	S0orIrzQ6DX2rYVr+FYPcOSXbedmSJPDyQw9a0KnPWCiSQvy9te41pB4AkrrYyYs8d7BMb
	g69YW/ddbnBb2oRefuHGCuOsEhqq8PU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=J53TPJ+O;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lB/gWST5s3/zNGGpGrNmQn0s9XjLn6XUo6NFB74HdeU=; b=J53TPJ+OZ5kZaHTrq85iExMJ+0
	ESCvD/mY3AUsQJbPBplyGJvh+DHfa6CJDgQjwYe04T03q5fZxVnFU0fMIh0322RWs9ZOTmhrzBB4F
	M7pYyqB4AJ1pH5/4yHMfI4b55YVk9UTCBH3TyPGbn2v0fBFizfaZELuSNxzb5Gn9xTdxjsRHFHBov
	Vbxe51f2IOsquNV3XRN/456KamzLZYI0lkolF+ELEVzocIV/iNa1VqfookQvrhsRG+cJ5VKjQ4CKf
	g24MHsi3z0nxP8/d+QstBk8c4urCx51+yd1QoDelaMTgnAdd/wT1JKm9FpFgd8pogNRRcXpLYc3aG
	PGOz2OPQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHh-0000000BwtD-1BG9;
	Tue, 11 Nov 2025 06:55:21 +0000
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
Subject: [PATCH v3 01/50] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
Date: Tue, 11 Nov 2025 06:54:30 +0000
Message-ID: <20251111065520.2847791-2-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h4dqkbcqcn4hu76qtjtkbxjn5qgzr4pa
X-Rspam-User: 
X-Rspamd-Queue-Id: C70D8C0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1762844130-73536
X-HE-Meta: U2FsdGVkX19BDTVhRK5mHoFErHXoWlOAhM5vd9a/jzmkhq+nK/lCN+TKz21zH9jKn8Ta19O/DYK05DVGkzbiSH+9f/qE2/wDoniz/msdZc9qPPCLrs1PH2b6NR35Dx7N8QZ0aPuFrOKwkCqOlV4LJ4hYKM33rVnYDaZ0iYoWaWh0E/uuP3dER3mXtA3/dmgehBSPDKLW4eNh1EfudPer6vt6vJJeFxsSl/DOOXSQhfFlLX7APDf4owERujBpJNJuloagHB0KLl8rmT4tp28g7rg+XKcmmzDqA/+cuuDLU9n7GGw5ECHmFZx+8ugc/JtZ4Ak6n1p9h29EQ5sJNWFT2wc4omnZZMPtL3/yagnXhDkR1yD1w3lSpOFjVy6g/hB/ZlMo+ymX543mBRruf9MuA3O2la5dlyOXB45Hxr50SYnmoDrqk7lR5LDwxvUZ+xzazyIVuQT1PlIwAcSTxDFuAtY1TCwcFHMVxod4M5/mAcE2WPfYPJZ1tUdxZUAjQ3I2q2NHqIqCyNF9Pr4nQxXilc2NbQojTNCh4qIghZAk1X7jW7QQq2prRb03+mRl+3vhDUTuXWw011oexPgeEE0yyhRb3ymFSYSh5TEhSg/kR6MP0i2Bm3RgZpURDBWkbHq2rIN8tOp+0fJUZTamhJYBDgT/h7xHO/eA7SDNI46HoEJTVjq5WnyZzf3OxDtzJ/wayzGLWVBfY7sSpvvmp5/hZ/ypF4Qi329tUp6III3XbS5FE2WIhIQXet+Dz1IhCmLk/wwFY3sPcTaodMqe5xA0JC73TpKYwp0sIRu+bg1N/OxI5GQQH7ij9TuiXewxRg9I5CYKo0Y/yv+1ofEmCVklU5uZHxDNoWa0QyMkZ6Tqf7hc1RBG4xQ6f2Xb4M9+lHfZ22s2TLoWMprLjhFC+Hn3PllR743OS0kp8WbFV7vLFqx89hm51ydAFSqMjS73GcQ03YYhvhc945FbQooF7Kg
 rXOmjPQq
 FRfrinxZOj6MK+MvoYmV8M0owL/PdyFQ/DhZUbdGxcxAm6slPui9WhoQTjYGQuxOnn066hMnXQZr1HBnHHZ+D9UeMnMsMc38k5i0eInv00AhYyuBhQZkIdPOuhNRjtr43OuqXoJ7RPhD2tCdRL0KnqDcyRrsikaVPxpXMuHq1I3I6ibH4zof1nnyceKk/N6C0kxjFmE/Fq24YGiMGIaeSv6CtfeZvkGQYq0Xwqq5PGxSZxPNQKCYdfV/s/dfNSzgLhc3NED9+NSYWol//m+jSVjmZ4Byk4QL2sAk1Kr039+UdAc8iwxGl/iH4SZqdmdG7kwL34vqf0CcZwgA0aA48O83NBfK/u7UOfhqnFuObkg9DnSzSMdB3qMzqtaXhY1LCkBhVh+31dXqEmQT2W2vsMMrt6eDiLorW5pXalAH/1ROWlUN3gjPJPUZUEYF/7/OrA6wnWvCniw0IBBsJRLiqjUEGvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fuse_ctl_remove_conn() used to decrement the link count of root
manually; that got subsumed by simple_recursive_removal(), but
in case when subdirectory creation has failed the latter won't
get called.

Just move the modification of parent's link count into
fuse_ctl_add_dentry() to keep the things simple.  Allows to
get rid of the nlink argument as well...

Fixes: fcaac5b42768 "fuse_ctl: use simple_recursive_removal()"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/fuse/control.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/control.c b/fs/fuse/control.c
index bb407705603c..5247df896c5d 100644
--- a/fs/fuse/control.c
+++ b/fs/fuse/control.c
@@ -205,8 +205,7 @@ static const struct file_operations fuse_conn_congestion_threshold_ops = {
 
 static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 					  struct fuse_conn *fc,
-					  const char *name,
-					  int mode, int nlink,
+					  const char *name, int mode,
 					  const struct inode_operations *iop,
 					  const struct file_operations *fop)
 {
@@ -232,7 +231,10 @@ static struct dentry *fuse_ctl_add_dentry(struct dentry *parent,
 	if (iop)
 		inode->i_op = iop;
 	inode->i_fop = fop;
-	set_nlink(inode, nlink);
+	if (S_ISDIR(mode)) {
+		inc_nlink(d_inode(parent));
+		inc_nlink(inode);
+	}
 	inode->i_private = fc;
 	d_add(dentry, inode);
 
@@ -252,22 +254,21 @@ int fuse_ctl_add_conn(struct fuse_conn *fc)
 		return 0;
 
 	parent = fuse_control_sb->s_root;
-	inc_nlink(d_inode(parent));
 	sprintf(name, "%u", fc->dev);
-	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500, 2,
+	parent = fuse_ctl_add_dentry(parent, fc, name, S_IFDIR | 0500,
 				     &simple_dir_inode_operations,
 				     &simple_dir_operations);
 	if (!parent)
 		goto err;
 
-	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400, 1,
+	if (!fuse_ctl_add_dentry(parent, fc, "waiting", S_IFREG | 0400,
 				 NULL, &fuse_ctl_waiting_ops) ||
-	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200, 1,
+	    !fuse_ctl_add_dentry(parent, fc, "abort", S_IFREG | 0200,
 				 NULL, &fuse_ctl_abort_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "max_background", S_IFREG | 0600,
-				 1, NULL, &fuse_conn_max_background_ops) ||
+				 NULL, &fuse_conn_max_background_ops) ||
 	    !fuse_ctl_add_dentry(parent, fc, "congestion_threshold",
-				 S_IFREG | 0600, 1, NULL,
+				 S_IFREG | 0600, NULL,
 				 &fuse_conn_congestion_threshold_ops))
 		goto err;
 
-- 
2.47.3


