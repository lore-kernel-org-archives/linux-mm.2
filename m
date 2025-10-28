Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE64CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CCE800EB; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A98E800E5; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37675800D8; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A45D800D8
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AF1281602DC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.30.E830DFD
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id CA8611A000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZhrjS79t;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=AvqPbbVkULYVMuL8APXONoKnpA8ylAO1nTFiO4UCAS/TPa7q5psu9vhm8XTNFysum3YCQ2
	VgiKqnc0ObzV5818Ja/lT29uKyS3xHRCkUC1qBpqCS+JAHvgd5Wl9TTISkGMo9RYSGibCJ
	qxlpnom/kZ+R64iAfKH7Vy0Q9Gu6jwo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZhrjS79t;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGEc3asPoO0BSFThbWpOoQFbGckDO1h86OnlmAxWxbE=;
	b=r70yqV8VKCWnYlP8QB1sEbLUKxMRCnWJZvN8ncSu5ZEpepSmUOZZ1SPptnDrMEQcpcKme7
	fpOGf9hZCe2iTx8fgr1JwH+840CPHLNQ5cec2N/sIFI1BfiiULhvSwGJbX0VGKXVVflEO1
	ZH9thDfwzBqhCWSa21d7A0Hr5WHoHQA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=EGEc3asPoO0BSFThbWpOoQFbGckDO1h86OnlmAxWxbE=; b=ZhrjS79tAsmvkn2E9bfTMdEW4w
	CTmXEOAAykGydCUZFeFSz4dT7zOPnBkkbPDPlZ6BLPJ2OCpqZkLpagKrXDPgoweW+PhbnTu7t1RLR
	xUOuclxX327AHiKz+NzZtsfrfSXR9o9ciddUrkpGUjNTh1/HLLX6M2ZzbZxdYbdTTDeWXIogt5LOD
	NT+qppUvE1hwOdEagwNcqeLCcrUwQXaV8/InJbBDRAjI55yV7KW2N/FqmRfGoKFfVVP4tVxGmrQMI
	g0M1v8++um1YR0f0/u2LHYWaVjNQ5KafrPccWoXHEiCbCBf85LpCCL/ymhhgT4K76vuOJKnM9acW5
	7na4lLAQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eZC-2fu7;
	Tue, 28 Oct 2025 00:46:17 +0000
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
Subject: [PATCH v2 29/50] convert binderfs
Date: Tue, 28 Oct 2025 00:45:48 +0000
Message-ID: <20251028004614.393374-30-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CA8611A000A
X-Stat-Signature: x114j8sn3wfgshwygg9ybkx4ad3bo3yb
X-HE-Tag: 1761612383-820412
X-HE-Meta: U2FsdGVkX1+lBkGPe+PeaE3oc/AEuzrG8r8w4xzesvqpka1eLDzPmKV1sY3BKs8z7VkT67IhUeEiiYI8R8miAWcXPGPBiXmQAdO2DVnJ9JYvlj/loorsjKVQF9eaPBmXQ/TYvTx8NWsdTbhruxxnSmUgMznOLEyIrcZyNWgrhFw+GTzgjJ1K143M4cE+z5SmzkszISAXm/Loh2bYCDhjvh3rHkOU7SfF2AugisVM5GhpqAADaauSjFSnnH8RGYRTQRAICMnyHPEeVeNBbOo8js+6S3LHswxXDEY1HAKBO91PRN0ochuZ0q0DzeQVvCMnArh2+0IuRNq7R0mhqr0JqEzHe4nFuioaqk2/X3A641ulz7wq3xNtHZIpS18nnb1d4vtdcK/LFK5DhDNMJ0RAO0k2Pwpba7NW1V6MQlI0VEFbLY48ViIQjv2Md0YNVE6wsUGRUUNEKJVf0sas17QKJJt/zAqqCMVb0JoNrrQYS8dpMTNI9WeiV/O/DoKuYCbZqZzRXcteIkO0zmjQ88+NWZmlRwb0lDSHqtYVCzd8D9usQkhAGal/FpEsF54kuAPQmJ1hnv6K60oNKQzGaplpMM5On2Q8P8pfxdnwPGVEnZRKCepaNnNAAVkvunM3TkQ+fwnDoin9Ffip0u0Gp27DOkVZYULkkHv1Tn/VX95Q1v0wrvKOq7hG2U2jUzH3pKqZBkEzisA2vrhFQ3bKXAvVHbM+rPGuD5x2ir25g4oGyF8MdghF6rMIy8PE0BDjEa9VCRZ4wn1zQX3tkCGzqYCMeTMkkb4rChgr/t43caGBQV2UnBUDFrrez1Um3Z5ZFJYKqwbLYGM4Nd3ErWaaqC3nTPF0xOP/nBnXlEbX1PM8PGc/qxfA/qEON5u3vLElQM+7XFVN9JgbiMl+WGaSiq69kpKruGTpxkOpp7QJe/tfgCnlB2r/1iX3SYHAZdAiHl8wJbY/wCyGhgMcysp33pL
 XBU502F7
 DzKmDLfngFoIeR6IE3KOLc+UEcCLcAI3mKEVBANlMPck8FKRDCbb8Os1f1nWQdgKQ/+6msXY11RwEVWv3KR7dVNQ6DZIVXxjM3limyK/P/Wbq695aTok9vD7qc4rd2jBlyG+Dy2kv0qyGqSrDnrB23aRcBhWyrffwrtBUVbI35a+IHi/JbzcZYjOe26jRClWS+heJ9+gNcPxwLuy2X6IX2BTV/CX4sxbMwRhANAgm4HUPTSdVB2dvJ+jVMnsncYed37vgN8xBV38ymyeFLfFQShYc+Omdh3u39Ih4Ssurmja5QTbE63IpbYLiBAdhya4hvwzo2Fl0XuprtqtP6ki/SF4qjlnpW/xz0Bw0yHF75FEpxfQJ5+iCKYW+Vo3hD4vRhxjk
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


