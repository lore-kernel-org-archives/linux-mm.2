Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A5ACAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 08:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B988E0008; Sat, 20 Sep 2025 04:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCA48E0002; Sat, 20 Sep 2025 04:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719958E0008; Sat, 20 Sep 2025 04:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4C18E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:11:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06FFA42DCD
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:11:42 +0000 (UTC)
X-FDA: 83908909644.06.427E031
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 62A8B40002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:11:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BqjTpvmA;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758355900;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iptZlDUSgeJMZimnaKy5XNXCMU4JgUkSmnMoXg8r0tc=;
	b=6dycFVsPWrveytmPdlhx8GE8Lw2h9BBI3ypzSdKIfg3Jrlj0ey7GZuc32S0rTJ4/kxUrEd
	RQ8oKfgWIMYLEPqoFBczKs3Pk+O86W8RtjZ9ECk/JnfgY49gqKVYXumJtIXwh1Zjov3FX4
	spy9bKX7V/Wq0bojyd7/Zq3jOokZGm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758355900; a=rsa-sha256;
	cv=none;
	b=Z512nyKmzMFdOSURbUCG5z2UL9uzvkgSSE1pUqC0P/Ne1N3GzXKps9RzLMePurnTVB7zfs
	msbtgGLrH0+kTXdbll7Pd82fReAE5b5/AX6qGqMXv5c3RGr2RoYAVXhCpbdKbQM2X2RM2X
	r23rYp1BQFDz+tvt3C8O9OFxzgKnz14=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=BqjTpvmA;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iptZlDUSgeJMZimnaKy5XNXCMU4JgUkSmnMoXg8r0tc=; b=BqjTpvmAp+ZuBLY+me0sMv0oDQ
	FBY5K7U7NuU8mZvn4OoTgrwUVe36YEpYKouzkK9OzJQoTK7cr2lMGBogSQWs6GC3rjHqbYYPag5eH
	7yHIHJUI51199azXGFvUwV0AgvekMFItQRYHeEUlxYQuQ1ddbgveoRMt+GmgdX/5I4jlBd7zNQcrV
	qjKHNC61eTMfhuxgOdmr9VNK+bUSWg6AEbUw7cW4uZPBhAkqCnPMCVL6jSpzwYiiF2kYtBqmMngLD
	sDS3s3qonfFaibrB1hz4zz1BBoDPCAAKe8W1TxsAvCjU97uRExtoZz8UqFn+ZXmXtmUWcEqVNV2md
	I1Mqcwcw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKB-0000000ExFt-3CgV;
	Sat, 20 Sep 2025 07:48:03 +0000
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
Subject: [PATCH 22/39] convert ibmasmfs
Date: Sat, 20 Sep 2025 08:47:41 +0100
Message-ID: <20250920074759.3564072-22-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fqywesh7pca8dfbpwderay8gqiz1zc17
X-Rspam-User: 
X-Rspamd-Queue-Id: 62A8B40002
X-Rspamd-Server: rspam10
X-HE-Tag: 1758355900-691691
X-HE-Meta: U2FsdGVkX1+mAQ2yE7bbcTV5aJ4sjxvloHvqnHaTz+jUPOB59mUQDTDyUqPJueahgmiS9xclJ8OoqNEFuyovnaJMODMpv4ueqk1fyZ18ihpOd+afJicsy2ijtby6NW4KPW1VKhGnmDTZ6BJbASgpXubdj1eMedR+gF5xoaqwxGfHlEXh1WhZJLSORP6TVDg5Dl0siiYtOMK8xu03sFK9Shg7OyXYgvhisl4gU6weOlTvlI5viyTYr2kdTgNXS8IZ625giW+rbONX95gXZdjYbF79HAkhKAuri/5iWw4MWKojueIY50I6DEHDrin6oQY7P2CC63IwIyfHYx1qbPoTONLVLR9EI+pEZ55T+R4Zm04ynbyY8a05zACLkNlzLMoCy9DVnyJpYYpLN/mzt/gEqwQD88AnYIDTGgeoHbJscykxJFL6Z8UOZ0ymPIykAYcTS9Cu1V4mWQrlYJb49GXvYcSlApm4bx0zVME7A90g4PuB6Zqvi9O02afpj/so/tRC9sHmJ21xZJfwyNn+I7kL66pqEQ8r8e5DCp1PDevI4ODFAN1MfCN6dO2P+I9FgImIf7asWTeH39jb7S9wRMOm3SSB424V5T4YW/ga0xEMAhRYyU4/N89fSK9U88C7Cyir3a9PJc/yR1rLU4Y4ZvCSCQZLCyAGPymlXuAhLgRd8JyttWIwftxOg3Sc5hJubGpfGxyEfgUqpRmOqd1tT8QTAQSqLQeayAX79zWfEWZklRSEYF+hTQxl0rFAHvZyajS1SecSLz0t62y8PE6UyubNP2asGArQidEuN4EIiuH8j3BD6jJPFRdSzJEbLHYTckUhD4lfTN+F8s/01zF9wXznn/jsyrAru7RsdXZpC6KdP9mj0l0zlHOSR+25iMlqbllqLhR6oCQt6y/+t73S8wbOEyudT9qj/RIFPZ3wEf5yMBhuLwa8VcoILoxzkQqnJ9kU1WMS+dhGc/zLljq/Txi
 oNVSzdhB
 DUR9wUVGtEZZlek3wZH1OO+0I2Z3/NpWxHEtdob98D77byyHxd3hd+X4C4xkJEyLqGTyH93j9mabD0ZLLU8K1SM/3aUhzYSImheALFoaz7D79zzGNaNBteRVFdu+uJM/sJ7uJI1KG5+pG/Bl54sRTHXzGUsOsgisL9qYcPcFEKd46Zrgzi/3x0d/cYld7h0RS+8FpvRloxs7eYnyz1JT8pSxSiGpiFoph6HvkeuZCOS1G68PtjqplksIdde5CSe6ubEWxd93sJHExhKIaxvFGmuh0Fw+sNOLaN2Y+crqzR3QmMwRzSzf5EZpB7DPqzWOejzDCshcaxCfipWFmk0UvRBZJzM+3BZPoEGVZvMVaoIUCnq0O46dDy4oKhmuRhXRm3V8vt7z7RpYnWgYMqrHyZPSgSB2go5y3zGSx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

static contents for each "service processor", whatever the fuck it is.
Congruent subdirectories of root, created at mount time, taken out
by kill_litter_super().  All dentries created with d_alloc_name() and are
left pinned.  The odd part is that the list of service providers is
assumed to be unchanging - no locking, nothing to handle removals or
extra elements added later on.

... and it's a PCI device.  If you ever tell it to remove an instance,
you are fucked - it doesn't bother with removing its directory from filesystem,
it has a strange check that presumably wanted to be a check for removed
devices, but it had never been fleshed out.

Anyway, d_add() -> d_make_persistent()+dput() in ibmasmfs_create_dir() and
ibmasmfs_create_file(), and make the latter return int - no need to even
borrow that dentry, callers completely ignore it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/misc/ibmasm/ibmasmfs.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/ibmasm/ibmasmfs.c b/drivers/misc/ibmasm/ibmasmfs.c
index c44de892a61e..785ce294f4b9 100644
--- a/drivers/misc/ibmasm/ibmasmfs.c
+++ b/drivers/misc/ibmasm/ibmasmfs.c
@@ -103,7 +103,7 @@ static struct file_system_type ibmasmfs_type = {
 	.owner          = THIS_MODULE,
 	.name           = "ibmasmfs",
 	.init_fs_context = ibmasmfs_init_fs_context,
-	.kill_sb        = kill_litter_super,
+	.kill_sb        = kill_anon_super,
 };
 MODULE_ALIAS_FS("ibmasmfs");
 
@@ -144,7 +144,7 @@ static struct inode *ibmasmfs_make_inode(struct super_block *sb, int mode)
 	return ret;
 }
 
-static struct dentry *ibmasmfs_create_file(struct dentry *parent,
+static int ibmasmfs_create_file(struct dentry *parent,
 			const char *name,
 			const struct file_operations *fops,
 			void *data,
@@ -155,19 +155,20 @@ static struct dentry *ibmasmfs_create_file(struct dentry *parent,
 
 	dentry = d_alloc_name(parent, name);
 	if (!dentry)
-		return NULL;
+		return -ENOMEM;
 
 	inode = ibmasmfs_make_inode(parent->d_sb, S_IFREG | mode);
 	if (!inode) {
 		dput(dentry);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	inode->i_fop = fops;
 	inode->i_private = data;
 
-	d_add(dentry, inode);
-	return dentry;
+	d_make_persistent(dentry, inode);
+	dput(dentry);
+	return 0;
 }
 
 static struct dentry *ibmasmfs_create_dir(struct dentry *parent,
@@ -189,8 +190,9 @@ static struct dentry *ibmasmfs_create_dir(struct dentry *parent,
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = ibmasmfs_dir_ops;
 
-	d_add(dentry, inode);
-	return dentry;
+	d_make_persistent(dentry, inode);
+	dput(dentry);
+	return dentry; // borrowed
 }
 
 int ibmasmfs_register(void)
-- 
2.47.3


