Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B0DECED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E2C8E002B; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67BC8E003E; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 821098E003E; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 291D28E000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D487B888BE
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.19.D96C60F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 02B6220002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qfAn7jn5;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=KLlcLIIXRuetH+UCNFuk+4UOqP1VcJ8AyaUg2APN7DIu76Ct+DXpFHyHYyPHbfNvTzQxST
	jYP+g+O4KsEVdKD6wTulET5w4HaTPxpa5WqWJz6zraSIOLujPmy+93wptth0ugbNfskvYM
	vq4we/QTPLRUuGtNDtSKqjmuZEIbcx8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=qfAn7jn5;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGEc3asPoO0BSFThbWpOoQFbGckDO1h86OnlmAxWxbE=;
	b=poZO6hSPBHE2gh352UXJA+mbPi381lHNtb00chWGgtPIG4Xc1vatZz/LiPqAQbd3jsQRGK
	G9yO4f/EwsTL/dZskB0TUeAvH+8Ci1dZLfVCieuKSXDc3YGNWO6Fu9uElsf13VqiqhTiAl
	vGx+gmxct2CzihBeWcJCRc3RGcT/c+U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EGEc3asPoO0BSFThbWpOoQFbGckDO1h86OnlmAxWxbE=; b=qfAn7jn5dVpc+8HYRW2PUrosYN
	3GyMgetrQNMDWIBRpoqaUBQ0b+RFMDBY7AmEWMJ/1ToP+BTNE23iXsKfKcAptmf8/ZEjXo4+5u52n
	CkyMVH2xjlmc1or6jRdhCAyYReRS4tsSZWL19CwyiR4xi2AGqmOMGPpqXNRxR+gu8H6VV3puDZHkD
	V/dnp1+9cq/0hW+scBmASeTBkXX27NsmuIQDBgWSiY1otP/WfkiiyHP2WuFbXeJTkvwqKG6b5Fqyd
	7/+XjHcQQcwfS6akaWW4RNqIYsWEL3XqSQWLc/logPlJp7jGMwMmRr8P2vBtBI0hvpJCQmrfvAmuC
	Yh5+ixHQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4W-0000000GESX-0eve;
	Tue, 18 Nov 2025 05:16:08 +0000
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
Subject: [PATCH v4 29/54] convert binderfs
Date: Tue, 18 Nov 2025 05:15:38 +0000
Message-ID: <20251118051604.3868588-30-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 02B6220002
X-Stat-Signature: 8bwto1t9z8cueis6cmfrj5bexqpmse9c
X-HE-Tag: 1763442973-988584
X-HE-Meta: U2FsdGVkX18wH8WWOqcPSIB4qY6On5Z+3C6MhwC3r42rWcMbVRqhsd0om677/xYBTwWIbhMHBzdMBvuLV7JgjBBCMwjoyKy6IJozHduEBjRX7zSgH3ZDJMojwg7jJtw4AUbSVux/sNiWZSpjr+Mnv4BRizl+GG7fN8BkbO7rWPVdsUd+MoBwU82e5MPWcZWIW6MWrttiB4pr8214P7cnq7N5oW1aewLMqoT5jsvBO9YN0YGw3WYWWBrbub1htqTUqbI2sMSOzqWuZOxq+uORU9365a1kpAhrxl/ZEnnT0g9eVuwfpRgz2HBTRyvQzHH/SN+ENLAwh32X3kjwOMOQ6PqNbKGG9zlwR33mwqEjMhOppJHY9zwGEjhSyeN8oX5PjoS8k3co/7YljrXUq5sl2qsFKRpeoGCSqJqXQSy4ICo3Hki8nVX0BYTqRUb7dHk1YqNPe4NDzS+eJ9MXgFrH9B/zZ4tpxUEwoAxuKOnlvQv4Q5MELfLgBTizSExmn4nDgyUfuiyazJxdwZgYPyAB0oyLP8JuAmUv+5pIOXBH3H47skEu13GE0xQfT8mT3hL60DdywIZhI+XEpvxwK3FBXqqI+3P4p0h9k0ogXRXV7dg6PnHRb4SgcZGXmPBRKXzLhih04lnvNUGUuqd/rXyIfeXztKY1WTAgtovbln6b/DVnfx7PROJallQEkbQPhJGdTwe1oNNn9bmrFWi/6U9wO0tysstoI41cAHREDtNa5GMKFt890Zh16xqMfBSBiaDmD6GK59BMnMqplTq3jsTnl+gYNsV29BhZger4ASSNuzBiRfDVkI0o2xpvlF+d9CLIWKj/2j73+qHplCvHsvlV0P5b61LHFYZNmSGS67+wfIWsLlt3QBPjNLsaNSSYLI6Blf3FyfCv0S3Ao903vSqflgaxL7HDi3ul0z+sxKf7DWKufhGD5krsq6tk+8fA5acPHyQGBOy8/tqnSLeiHNS
 ZbEeOGJl
 fCyw6D1/VnYSw2kJUUE89vfZX1xW7/Hwl+kMB5DN1fiKDI12z+H/vzHMzbkkt86M5Hlekp0gyYxP9C/vpXqPQOlQG1DCf98tzvIwasNA0tsK+YJ42xxbEHnApazAmeynVNzvFgXwTytzYJwg7G05CPWqZVo3cv8TcMpNZ2Oz/UNRNGQFSHVDzDQK7+LcDwDGxWdlBcalrhSrnapPECzzUHVDnj7ArG6qn7h3VJxsX9rQrFx7TTBhcHbdjSjMVnzORrfhbz0Y+0pkdoDHlgSKrAWIlr/lHptcigduq+D4WDLELE17Sy/jKGTiZYqFHoJAj7UbOt7q576PHoInNq8obhmpiP7Bry8Yq4WsBUasmfFtUIXMBAMLqiD0XNffbKa+h+sMrX7htjxpuZqvgZbcCf/ksPOMv08PXLv7i
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


