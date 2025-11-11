Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 255AACCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4448E001E; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DAA8E0026; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3428E8E0027; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE9978E0018
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:32 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 75139C0412
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
X-FDA: 84097415304.14.425AF72
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id C3DD740002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UvWqpmzS;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844130; a=rsa-sha256;
	cv=none;
	b=Qt559et1jIkLePnwjLEYQpaj6YAcGYxzyu7j/ZaHT8WlsFif62cP/DvNo8Al9PZCfyZofM
	iajastKWHZtHO6yW0FviZP1BUWS6gweHnPrpDKR28eVmW3BIsUGZ6ACd9LLF6ftdIxisB0
	Y027PsuHIaWeVo5m/3lDh9zJBpXbPUk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UvWqpmzS;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844130;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGEc3asPoO0BSFThbWpOoQFbGckDO1h86OnlmAxWxbE=;
	b=s4BSH6eM+RbK89R4kgYG8dVj4ONXJP4NKOlE6rkDVscms5gPPAP9bVdyCx8LQL/hBNXpZB
	/IQID/I83CjmQ6m3HlHSZc7JMxOVxfSBWnOWAD+hn5BPlqfq4vfOTLTcCzNrQEhPtc5uc8
	QHGX6b5kL0DgTAImlIJIqzoxNKTfQ6I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EGEc3asPoO0BSFThbWpOoQFbGckDO1h86OnlmAxWxbE=; b=UvWqpmzSbMDpTAbM4vJHUhEZxc
	cL9rerpjlNBRA664QnK8BRyF/s6z6V9pVifcGs8AsISFkqDNVnXZGYK0CxxQk/Dew7CK7WXgXWZfB
	2zZA/IaJ+UDVV885oFb6N9ChQtoydd9IPjN/YYOmv2L03XeLsnNVbQYmHXcnmeYEX/fiqcliZsGeG
	Nj6ug66ZIjjwdghKtnv+Ujxi7cU2hvlrMipw8tHMOBynAz0izZyEgkn32BHuKkicTTcaYRYC90jlv
	zH3Q11tvvcPdfp42u6L7cdZ0o6z3TcA4Qz9c2j7xPFaMnV6fvuoUNl8m2+MlKsrtt17cXn01NIab9
	L0biClnA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHm-0000000Bwzu-0CNF;
	Tue, 11 Nov 2025 06:55:26 +0000
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
Subject: [PATCH v3 29/50] convert binderfs
Date: Tue, 11 Nov 2025 06:54:58 +0000
Message-ID: <20251111065520.2847791-30-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3DD740002
X-Stat-Signature: 1a8s16t7uexge4b7gfjitq9p5yntcf9f
X-HE-Tag: 1762844130-234611
X-HE-Meta: U2FsdGVkX18kGot31zgHxTxAruao0zSU24nRCbyTQBGJgz2Gm/Un/6kh1f+Bo8Dwvx6zV/j+1VSRcW2E5vsl59C99oJo2HP/yHr93VWcks1MVHBdUol9DtUuTSgJ9CPE72uFtzFdG+tteANMuqW9fRIgPdL8FjGH2qzn1vnoV4UVQbcPv7YA8OdBGIK2tCO5lHcnp+PNi6x5Q751ZsaFTl31d+VKTZCOCS5urG/IA7hMSJPXgxDBIfA8Y1eGbUabUKZj3/tqsX9hlPfS176ngkGePh+MZxkEdJLLjSFVlf0iHJxJgZECvReIfHm+5LpGoeam87WAMIoIPpcgC41zWv5tF0xWtxePlQQgiclxgbg/D52qp4ck/R/zqalr/5IdaC34KXxF9hAf2noqld5FBV/2X2+eHnlvwFMo7rnKEFJsrtkpLz9FC8dpfcgFXixVnjyY6dI9BOvkVRF5rNrHJGKIxoKs5r3hN2B+Ree4nZjyaGsuIuhh/um4cjZgdSt8pmNXp3QKo9QcC2y0O+odkClfwK3gwIZEbAxxtigZwwLV3qyQ0oDpM8DNL3mPUQyYjij0Xcu6+kr+SbJQuIAa4y+slzft4fxdgI9/G77/JnihjIa35XXZ3eutzxx2G6FHBiExQBFwbB7XZRTjmInhH/jazmIyB3kA2ZvPoYjM1B01Xcf+PNa1J+4s3S1AqKSCixRuRC9RQe43jqSMPmfOFBzWysbLQzkODtjx3Rb1J/GVkgWwMcTgaKPDQp63efGZOBD/IkXRnXHtBtk2q1pUhAI2YW0Cto4hOakW692E+wM33mEzbqtRd9k1YMh/9R4pOrki99tTj59Z9SE37UG3wiq5f1de6TEZbcIqmBmDfvLXkNjxr6D7IvtTKyLd25RyQaUydLgYkHWZm/kUIwrwcppc5h7Sty3dStbspgYzHDHXqR3FAQgI5X/I4ZqQlf8ZmG5sf5NoRe600SQdOyh
 VZbeVe+o
 +8k1e6IuzDc/YDGRqZ3HfdEIu3nS8FqTDIIl79lHafkuEkgFYpbYYIKkU4OI7kRDd1SIavX4Efne0d+VX0W80+wRPrfSxpAkKXdU0WT+jtyGgxKBtEbgvmXlFxX5WOqjuSxLcZYBgn32JgbwO72p4QR09PjFW1jxhfvq0JI5qxEWR/BYFY/T0Xb34XLH53zFPsDoWxctQn7bcOxZZHip1P0WkugCWNkTWrB+Ts+gQo6ltcSYuH2o+XgcHFJuQiO45ykpOfm9JDBP5m96U4AFkKJv8emwZUPPy4aaq1fbNTn9/XLcTDa98vO+AmJcDFeIyzPtKjeNv7jFfWjc+flLJANT57xrU1q+TUkqJlbCPDXpYgU5KDX+XZG3eIzoUTTdtZiOlVo77DEYWvVZVmuolkpEhqSVuRFMxezAK
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
index 8253e517ab6c..a28d0511960e 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -189,9 +189,9 @@ static int binderfs_binder_device_create(struct inode *ref_inode,
 		goto err;
 	}
 	inode->i_private = device;
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(root->d_inode, dentry);
-	inode_unlock(d_inode(root));
+	simple_done_creating(dentry);
 
 	binder_add_device(device);
 
@@ -432,7 +432,8 @@ static int binderfs_binder_ctl_create(struct super_block *sb)
 
 	inode->i_private = device;
 	info->control_dentry = dentry;
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 
 	return 0;
 
@@ -479,19 +480,16 @@ struct dentry *binderfs_create_file(struct dentry *parent, const char *name,
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
@@ -510,21 +508,18 @@ static struct dentry *binderfs_create_dir(struct dentry *parent,
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
 
@@ -740,7 +735,7 @@ static void binderfs_kill_super(struct super_block *sb)
 	 * During inode eviction struct binderfs_info is needed.
 	 * So first wipe the super_block then free struct binderfs_info.
 	 */
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 
 	if (info && info->ipc_ns)
 		put_ipc_ns(info->ipc_ns);
-- 
2.47.3


