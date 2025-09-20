Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15C18CAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 869EF8E001A; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CBBD8E0018; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E5E8E001A; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1748E0018
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 226E542DCA
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:11 +0000 (UTC)
X-FDA: 83908850382.20.159A5F0
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8AD1C40002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PKvPJeUS;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354489;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kzaFEv9+OIThBqJRm4CcvwF2gfE3udH1o+XUKpNiExM=;
	b=ENbRN8XPRI7LN9EzPQSCxyJ1aldaASEgR3YEkRPSjyplypCtUK9McS/bRsqvlwlJpPT0Z1
	WYpfbe8z+QiVwvKJptxOYx7FDNUoe1XzMq8H8/9TLC33pQ8Y9YIzPKthjp0zuk+FrLii45
	/Ma7CkVDYiWFKwPwhnvSC3zGQA4fPrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354489; a=rsa-sha256;
	cv=none;
	b=UlT7c25Oez2ZqWoJ16kWHC3LfFGMi968rc+ipLwaL3uzJK1zHZQz4GvuHcKQdsUa15rAvD
	7KMWRaFWvRZRARhHIvcrmcX3XGQmB3FTUZI9OQ3dJiasZxNGSbmiRrLbB/zpbUdNFO8O+d
	7uoergWgp7MHfHp0dv/6op/lzDdPBtc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=PKvPJeUS;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kzaFEv9+OIThBqJRm4CcvwF2gfE3udH1o+XUKpNiExM=; b=PKvPJeUSUjSO2jC97UPtEsuYBU
	GhiacjgwtBT6JQG90tbTfMRaSqqvIDDy4hZCGHN867cVzcsKpZxc0ZXU6bd3PB1nZ7RWhPob23QZM
	gfBH5Pyt46stlc2x2of7psdlMvl5xDPys0pjr3+vdSTAlLapKkri20i7gCEwBI0B4lZLfyCHffXWX
	zx1mEDtSqDxvd6k3H1eAiboEEK1/4CtBqGiPdMeVovMQ3YjjX/pUIvyitm8wv2qrDbkBY0MneSVPd
	dmZC4zA52c1iFUpCX/lSvSWWpiYgygmmzNWfUcprkCy7eeGx+OespGnKo2/lrnpSTF8X96df+V+Ir
	INk+Kwew==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKD-0000000ExHf-1LEH;
	Sat, 20 Sep 2025 07:48:05 +0000
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
Subject: [PATCH 27/39] convert binderfs
Date: Sat, 20 Sep 2025 08:47:46 +0100
Message-ID: <20250920074759.3564072-27-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8AD1C40002
X-Stat-Signature: arq75thzwqapbioy9oa9sqzkbq3sfaxu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758354489-803790
X-HE-Meta: U2FsdGVkX18CMaPOPdhgHfqOZgIMQxvNP7BoopuDwVJeP4jDPkefF1d9i2Fv7pN+9HZZREq1lkntOo3ispeI7n8Yo9OSARFKsi+9UXsphvCI7QFoRBIqKJmxOKI2A/W5dmqDdhXnbmiuzZHqQqCL9UsnrLTV6cZgzbt0MkwdwaFF3WxHZJ2qZ2HgZu1w4phUbgh1xpz01QGljB4OWEHpDI7OqslJWE/egPD1g87bTt61JiCmBG3pH22ZFCRZrAZKQiquqA/rITcCHLM3J46434hXbtSKVZWQVLBPvJ+DyhY3XIoPuXykhZ6nefxRke5i5/RjkLI2gBWQTkstVkS8xgQPuTz8+Rmg0A2a7uTTzQ0kdarMjhCqVdX2CrkmsJvtDhsNKkkhYtslAhMo85cDrQo//FrZEya4PhdON3DeCO8CRX/MmDbNBCQP1HuaA2477WO1jfPBypXZZ+daSr3y48UAdf0fkyzrX44RCK/KW+JKCNksXq9EYQ7tvgXEf4NNQ6ScQPf99vBOcVeHal1nm3DICelRsq/svE/K+PZN6aK+jQEQTjJrXSv4Vqr0TXgNMAtUN227ic+VO8M1zEIvnHUxuzn8jQ7QR3/HI0KH5W0di6b8+UHtFvlGVrqWwBkgKGktubiCExL4YuyKAMLvHmJJl1N4fg0f7HLbgfmXtQmc+ZIZiosnzOUkpd7j3U8RRwnnoPzhOV7Gs6bTbqGvbua8lwvsying65l3ZF92arDy9t3I95yWE8HthiiGZEGCPQizOwHaH3G2AN6Usonf1BFl2kyh1r3sfiFvLd4d9aB4JJLWHvwdJbz3gSISDSCeCn20+LJ5OKUwYQYJfOIxK7aKXVX8lUuI+jQLrYMJ0PEmnNF5/uliM1E3wi5i+r4NUPxIa3Ljy757sHRbk96QsRUgvkHTr581+6MT7/kn7K2c/Fp+qILogozINJh0a0/B6C3wwriL7TgpiZ2eam8
 fPfUr+gI
 IpgsFBtgAyzp0Zfv4D37yp/UJC8TsIb246uQHBVzqm6F/2K4cjlHSWaz+N0Bdcb5lFXu3Xw6uTYa4HPSFQJ1LgUNkGenJ8EUTFUDl5mmGbN3k+Ob4rA6Trs8R1jUql5F4NtfAC7N5lADlBpMdhADAM6CbDAvJi5tIFJq5q2ZjsfWXb9Af23UjbCpgSC22sQO7lh+428PWTfWgb4Y1Pzo+Kb8ok2vXwDRiBkkZMk2o8Kd7o9pIGA03Wfe2ofNXVqnuz4s1IaSL6z34qM81IfbXWJWBingrrEVjtrIrLeu+3uTPWduAgoAwPC6HEEuU00cQIEtomitlhh8eWUK3vqebs8iW7LfCkq4fQaeLQw29FAtQaWw1w/F5VDszIn3G1L0vXGlPxVqY6u7nknmY+sPN/AIs6MDCOaCKsMYZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Objects are created either by d_alloc_name()+d_add() (in
binderfs_ctl_create()) or by simple_start_creating()+d_instantiate().
Removals are by simple_recurisive_removal().

Switch d_add()/d_instantiate() to d_make_persistent() + dput().
Voila - kill_litter_super() is not needed anymore.

Fold dput()+unlocking the parent into simple_done_creating(), while
we are at it.

NOTE: return value of binderfs_create_file() is borrowed; it may get
stored in proc->binderfs_entry.  See binder_release()...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/android/binderfs.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index bb81280a3e9f..20c5b34fc775 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -187,9 +187,9 @@ static int binderfs_binder_device_create(struct inode *ref_inode,
 		goto err;
 	}
 	inode->i_private = device;
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(root->d_inode, dentry);
-	inode_unlock(d_inode(root));
+	simple_done_creating(dentry);
 
 	binder_add_device(device);
 
@@ -430,7 +430,8 @@ static int binderfs_binder_ctl_create(struct super_block *sb)
 
 	inode->i_private = device;
 	info->control_dentry = dentry;
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 
 	return 0;
 
@@ -477,19 +478,16 @@ struct dentry *binderfs_create_file(struct dentry *parent, const char *name,
 	sb = parent_inode->i_sb;
 	new_inode = binderfs_make_inode(sb, S_IFREG | 0444);
 	if (!new_inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOMEM);
-		goto out;
+		simple_done_creating(dentry);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	new_inode->i_fop = fops;
 	new_inode->i_private = data;
-	d_instantiate(dentry, new_inode);
+	d_make_persistent(dentry, new_inode);
 	fsnotify_create(parent_inode, dentry);
-
-out:
-	inode_unlock(parent_inode);
-	return dentry;
+	simple_done_creating(dentry);
+	return dentry; // borrowed
 }
 
 static struct dentry *binderfs_create_dir(struct dentry *parent,
@@ -508,21 +506,18 @@ static struct dentry *binderfs_create_dir(struct dentry *parent,
 	sb = parent_inode->i_sb;
 	new_inode = binderfs_make_inode(sb, S_IFDIR | 0755);
 	if (!new_inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOMEM);
-		goto out;
+		simple_done_creating(dentry);
+		return ERR_PTR(-ENOMEM);
 	}
 
 	new_inode->i_fop = &simple_dir_operations;
 	new_inode->i_op = &simple_dir_inode_operations;
 
 	set_nlink(new_inode, 2);
-	d_instantiate(dentry, new_inode);
+	d_make_persistent(dentry, new_inode);
 	inc_nlink(parent_inode);
 	fsnotify_mkdir(parent_inode, dentry);
-
-out:
-	inode_unlock(parent_inode);
+	simple_done_creating(dentry);
 	return dentry;
 }
 
@@ -732,7 +727,7 @@ static void binderfs_kill_super(struct super_block *sb)
 	 * During inode eviction struct binderfs_info is needed.
 	 * So first wipe the super_block then free struct binderfs_info.
 	 */
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 
 	if (info && info->ipc_ns)
 		put_ipc_ns(info->ipc_ns);
-- 
2.47.3


