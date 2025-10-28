Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CF40CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71EFE800D8; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17737800DF; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BBF8800F1; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8AC800DB
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE38AC02D4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.20.D64EF36
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id E3ABE120005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EnJw0qmw;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJyQ0sQN8CTZJ8YY6THdmavnh3TQW/mMqH0kl5Snbhs=;
	b=jDhZApw5ADkgnHW2pu0NI4Gsc/pnqJQzcCPr/Unor79FyOsfXvrowSKiIbN7sHI32lZHW9
	PEjYxFRmhyZIe+Emjt1CnwqryGyjkOKAmox+WQ70v5SDhNM87EfTlvRGhu2Qh5KneYhAYE
	MUhJNSa9Gq+N/b+Zs77HV7YK6GcVKrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=Ei9DYYOmllJx9mHvHB/bb1G8S1o+kq3R53tuU1RHXxqtHkI2H6EXgnkLA0Uvyye3tIe19i
	N4KZJ9vW6a21sR0BqHPw9Ve8tRv0CS7kK9RqarwWBjrQsyx82z23BYXtBRKOB1p51LMO4+
	fhEV27qXZsM55L/FZWOoZqD8dum9YGo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EnJw0qmw;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LJyQ0sQN8CTZJ8YY6THdmavnh3TQW/mMqH0kl5Snbhs=; b=EnJw0qmwlqcmyocNeFhS6dBbSW
	1oc/tk54h8tJLUV3jtnCFVKV9SAzfc4a2bYuIhkLHFSyHnSHxvnmO5HqsOqRDA3PqL9Zk6LZgPkvx
	YcMuriKNT4TgjVgt+sWOdMq+fgGBoc4zTrg/svOSrV2sDeU+SAq3EqO23MEOeybVqamlG8jLbnlEo
	y/HsdpdTaX3RDCUnOXaJ03nH346+GbeNtOQmdhhN4Tm7H8LjtLEw8RBxU25YzvnbiD3RMQnmvLtFB
	k108O9Ns40dXLKbM2rmZSbK5mlgYsg/XsAcDElak6W1NteqV+jnici7stCuS3qwplcpKtK86fqV/X
	LWoMcYKA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eY2-2qXC;
	Tue, 28 Oct 2025 00:46:16 +0000
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
Subject: [PATCH v2 19/50] convert tracefs
Date: Tue, 28 Oct 2025 00:45:38 +0000
Message-ID: <20251028004614.393374-20-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E3ABE120005
X-Rspamd-Server: rspam02
X-Stat-Signature: wgsz387sf64hwfq57erzm1xbsyd9cdu3
X-HE-Tag: 1761612383-509545
X-HE-Meta: U2FsdGVkX1+Uw01qabXoeqg8Lp0jcGcX3fZFEoE9ab7+p30o7sl66Fb9FLrMy2oovg5rS/fvDL8dNxiiSozFNOwvNod9Hd4i7blcXzinj1NPYR6UROQCdyQWCYprhx9+Z7pN8eHjijLzFCdexIE77ROEuobzv4uEL4EcAyX9JCIZBVMcZF7EVcN64IxfRJR9I814N+2G5wrR46ua2MY/j4f8ZXZD0K8l7pvsfT0LMcTrHoL0wFq/CAwu0gw8wOWy32YHBjQicUUj0YCUDZQYDWGaSDoX3Zhi2ecr6TvJBaYejdCKpxom+vPtsC3imV6lFAG0dBsrtnRCQwGlzV97uz7mSwP3FMFkXB8pPcuwKuLEQ/0EoDIr3Z0GqvEcoG2r0CmIcmIsytOBwqpnbWwpeH6dSCgyJ406kSyfArXD6qVg/bAA7+LJi91NZeYM6MrpIx/JvyA/TqjZWs4FBZQXJ3bnHvZ5GbiU0fPHfxaN0qmb6TyiVKMVetiOrd/oVZMQ1a1s/aGBOcqDfs6pyOcKB2LkCnSuqZMztlY8pG27k9GRGHv7Eqpjbno0r9b10DhpMhScJnqHLpamNYhuvAr4U49teWMWChlAJgxX2XHB+NUcJayT8TpLdbWNSw+56qfrB+uCaB7s77hT5wfMYGy3k/EI8LmaJf4rqYtgWualUXsnzBNRu9k3Xdw05hdSC7slm59omoQFADN/TXx3w4DlS/RXRIkk6ihwAhDw8uloI+8PGuuPw3cdZp0fSv48haLD3nuHZ+xfXHWERNo9lVY+ueGEtoQd9tvy4OpRmqhCRcw5PL5Et+7L6pDuIs95fdcjUkLUtHLeJ/QiQO9z5m/XBhlktDyI7b/Ts/mr+WCY8vOQbfRStZCnpaIOsEKQwfB8479enzyCoc5PXqQt3Fia3n3j15piQXy0DYoZZEPV/72gB6/mtRjFOlFzklnY2YGavLpQC/NXVijkUeEHI5R
 lxUCJYFs
 82Ya0nVA8Yq4v6LEhSlaMwHdyzs+vpJXbYmv/I2sJGnnyQFT7k8hTe1kMW92gcXHTudAWH4UD+NETb/klKZtC+QiD76j/Fl0RltElQdWqnh0BQrI+wpagN0tPq8oWYctl9Xws+xQGExlIi9Yb0bv0jdHGML48+IfR/dkUG8FWOKzIUymyj1QfsScChRrKlZAt4mjRks/v1cqGCgyprsJnC5GA06dgITS4dtVmrpO9OS9PqC848TMo/Z+RBGqO2DlQYa3wtkupsLLPKIlbmYvFS83Xj5je0atpa60ESRK93KL2wskeTKmviyThJpgismEhY3Q1WD2Kqp0fpYbTbGauKhm7h/iPR6uE+o7ym5RPFoyoTzWk0twxiUhEJCz3ieioHOiu
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


