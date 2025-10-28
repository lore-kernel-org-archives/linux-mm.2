Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF0DCCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 02:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB16C80100; Mon, 27 Oct 2025 22:31:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D617C800E4; Mon, 27 Oct 2025 22:31:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A1880100; Mon, 27 Oct 2025 22:31:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC48E800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 22:31:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 466C9C02E2
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:31:35 +0000 (UTC)
X-FDA: 84045946950.10.487B95A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id A0D02120002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 02:31:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZZi6wMhZ;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761618693;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8VEUlF9JhG6FP5SEDR4ze5YZGwCC3RxL0G6kDzkTUDE=;
	b=bsUGkwPi26V3JNwtRTF13OvyuG1mEsXl+7PSPkwade3yFuWcX5FKpGtrChGUVi67g2q7+n
	a22+J5YjEZtvB1IGWM2TVPb+5H5UbFBLpNElNCP9Bdn4ITKeGZZfX4Y1iq1OHDd0kdVsju
	Gc7i2jLpuJUd4KdSB9lK1Ehw/nElHNU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761618693; a=rsa-sha256;
	cv=none;
	b=WEEM1D/15BySJOGReXLEoQ2K/ppI51jF4zsphLjmCQos52Uo/TUXoeMFfu0y9yC8Xd6xWX
	JP9+9uYopcGq40fVEK+SN3diIwvj6bSxkxeR9Eez4tbxrswfyID99WO/mHgeWTyZIHI9nM
	fEyH3K7kyUHMk3oQRVpTgvtZBgAmbh4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=ZZi6wMhZ;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8VEUlF9JhG6FP5SEDR4ze5YZGwCC3RxL0G6kDzkTUDE=; b=ZZi6wMhZQmOlamZhoVFAN+5wJ0
	qn7ptGF3nnBZELZTTvCHFFxYcyQgGikSFr87FwlVC5rFdSl1je3r4NZeExdiMFlJV9n0UnLtoZBls
	kJ2JzKacJBnLvr916Buge0/yhNbkk6VrPnenxxNfx6fCM0XLYKHa1IG5Ay/kr/rNPylYz59mv9uCK
	2cdxz1Q7sCiwTvSQS8ZJMncDcPDgt8uvmVTJQhwonNzSEVJZ+Oeqc5iDEV16aWIXzYYba9BAWVzR4
	MUj1iEnBoNRgiAyJQZKdSLapuYAl2mILpO8J8AZsNBTUWcHHG/1Ladu85KDWZJ9kTw0PoK6gtQTD0
	z49FPwWg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eWf-2Y4n;
	Tue, 28 Oct 2025 00:46:15 +0000
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
Subject: [PATCH v2 09/50] procfs: make /self and /thread_self dentries persistent
Date: Tue, 28 Oct 2025 00:45:28 +0000
Message-ID: <20251028004614.393374-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: xye5aqtjra77rosgnumdb6xx417w1uog
X-Rspam-User: 
X-Rspamd-Queue-Id: A0D02120002
X-HE-Tag: 1761618693-102460
X-HE-Meta: U2FsdGVkX1+yIMaXqZchkQWo90i1ObjMFnGM+U2aHbU4TWUInPjIZ/N5dNKMS4bt7V3JO8tsj69k7Nyzy74+qZmub8RJ/JfXCqopB1uGeeytq2F5d/uANTS29Y3lQf5Nqa5IDRxum67DB2mSKikokQtgS6Wtql5U0n6c3uxKOmkpWuxoDdkrwafwPx+KaVjA1ybPqIbtwONHF78Y+HiU6qrJMneqSSM1NI6rO7wOnOeh72SY4qtkqX7gOVvlNBGNLYIHSJk/g7l4E1fv6aw/k650VB/LH4ImCj+sf9CeRxl/JADNg3xE2Z4yvYhcKAYVZMPV/ZRrkkglNgaoC9Pu+hRYFzWwOReX04/zdvy1QYBFHPTC0Aq6RYDVbt66HtUZCIDpD4oTtYqGLC+K1u8u1Hsq7y6jYQL1aymnJ5pxBpDPGYQpPEQlELnXj7mmlzMKaMhQekDsNyNqAVt48QFElywbEiBgeCzMSI+xpyG8P9KNRSSqEvSFwVeV5LUke7YkDJq89BdYBr5/1b96z7kzU3t+aQFKBm02mBsxFf9JKGF5noshj4gQvyFzWap+4R/Zxfcie7XRi1xFq1TiqSD3lTj5v9kUXdbmswROiFlKZiOsyWK2FGqJS2D7FQG7+dNjXJs2Mep95O+CHBSSbCKW6u0tXPDo2FouvUBzv0A+GfaAWMstzqrCqZCAQ197SaJs5vmGRitb6z1SLsFDwiq55km8VaWxIz1gVh5uU3jAF5Znnvna1OHv0OTS3AUFtpyHzA+Kt6Z73bMbisM4pb3XMYyR5CIu2qxlcbdnm80Bh6Xuql6ktYEFL8pI8Z8Cj5CC/hQmRsTB83WIeHTbudaxw6lpJwqvJEHElBVJ4nqklu+NaOhpB/SOwRudgwwOLgPqMl1hzzy/ZB2L8p7uHA5jn8OKqhdg82vRH42bhMvriPl2lTU8MutnLrLgxeb1g1JVp8DuHfbFE0JFnPDFlXw
 Z1udmADE
 9Zc7z4CegyodyDdS68g5mkOrJVXoADkEjD58kpc3ULrUGJK9V+tdF3pZ1vQM3MQdoaGj57qegrsM2hMNZ2GewNZn8Z2vpwOzpNXajT2E25qhfVwbxilo5i7k7tsiMrXKTL/ikAFANuJ1jn+jfrmFW3GrS/CwhU4floYV8T+9/5d0DQ/jv7xWufYRhZyIO+uJWY2hgqBY36FzsmPjit69p1DKnQkGxd6nelVuS33Z+66XWy4Ws5rdjyD2d89wryyQBD2Bs447a6De0l2Ah8Mjnlh257RZY31vuKFdKFFKM8bLo95ZurvF4ZXvuGemtSPsKk2suL00Wrlu0ooY+uoHBC1/EdT3D3nVhTdIMuXtQYFe578SjlZ5BoWvY6SvjuxxfIz5MRBHr4JprIriay2FLdnTotZGXVye49NPiAB7OC9puQlZX6TRH9mXtO88kzuJWGBrDjEbjjkdTdWa7ECxM+lR8BrR+xvnY9GcQuA+Ule+w6VHYtIIt7aBxjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

... and there's no need to remember those pointers anywhere - ->kill_sb()
no longer needs to bother since kill_anon_super() will take care of
them anyway and proc_pid_readdir() only wants the inumbers, which
we had in a couple of static variables all along.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/proc/base.c          |  6 ++----
 fs/proc/internal.h      |  1 +
 fs/proc/root.c          | 14 ++++----------
 fs/proc/self.c          | 10 +++-------
 fs/proc/thread_self.c   | 11 +++--------
 include/linux/proc_fs.h |  2 --
 6 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6299878e3d97..869677a26332 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3585,14 +3585,12 @@ int proc_pid_readdir(struct file *file, struct dir_context *ctx)
 		return 0;
 
 	if (pos == TGID_OFFSET - 2) {
-		struct inode *inode = d_inode(fs_info->proc_self);
-		if (!dir_emit(ctx, "self", 4, inode->i_ino, DT_LNK))
+		if (!dir_emit(ctx, "self", 4, self_inum, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
 	if (pos == TGID_OFFSET - 1) {
-		struct inode *inode = d_inode(fs_info->proc_thread_self);
-		if (!dir_emit(ctx, "thread-self", 11, inode->i_ino, DT_LNK))
+		if (!dir_emit(ctx, "thread-self", 11, thread_self_inum, DT_LNK))
 			return 0;
 		ctx->pos = pos = pos + 1;
 	}
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index d1598576506c..c1e8eb984da8 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -373,6 +373,7 @@ static inline void proc_tty_init(void) {}
 extern struct proc_dir_entry proc_root;
 
 extern void proc_self_init(void);
+extern unsigned self_inum, thread_self_inum;
 
 /*
  * task_[no]mmu.c
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1e24e085c7d5..d8ca41d823e4 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -347,17 +347,11 @@ static void proc_kill_sb(struct super_block *sb)
 {
 	struct proc_fs_info *fs_info = proc_sb_info(sb);
 
-	if (!fs_info) {
-		kill_anon_super(sb);
-		return;
-	}
-
-	dput(fs_info->proc_self);
-	dput(fs_info->proc_thread_self);
-
 	kill_anon_super(sb);
-	put_pid_ns(fs_info->pid_ns);
-	kfree_rcu(fs_info, rcu);
+	if (fs_info) {
+		put_pid_ns(fs_info->pid_ns);
+		kfree_rcu(fs_info, rcu);
+	}
 }
 
 static struct file_system_type proc_fs_type = {
diff --git a/fs/proc/self.c b/fs/proc/self.c
index b46fbfd22681..62d2c0cfe35c 100644
--- a/fs/proc/self.c
+++ b/fs/proc/self.c
@@ -31,12 +31,11 @@ static const struct inode_operations proc_self_inode_operations = {
 	.get_link	= proc_self_get_link,
 };
 
-static unsigned self_inum __ro_after_init;
+unsigned self_inum __ro_after_init;
 
 int proc_setup_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
-	struct proc_fs_info *fs_info = proc_sb_info(s);
 	struct dentry *self;
 	int ret = -ENOMEM;
 
@@ -51,18 +50,15 @@ int proc_setup_self(struct super_block *s)
 			inode->i_uid = GLOBAL_ROOT_UID;
 			inode->i_gid = GLOBAL_ROOT_GID;
 			inode->i_op = &proc_self_inode_operations;
-			d_add(self, inode);
+			d_make_persistent(self, inode);
 			ret = 0;
-		} else {
-			dput(self);
 		}
+		dput(self);
 	}
 	inode_unlock(root_inode);
 
 	if (ret)
 		pr_err("proc_fill_super: can't allocate /proc/self\n");
-	else
-		fs_info->proc_self = self;
 
 	return ret;
 }
diff --git a/fs/proc/thread_self.c b/fs/proc/thread_self.c
index 0e5050d6ab64..d6113dbe58e0 100644
--- a/fs/proc/thread_self.c
+++ b/fs/proc/thread_self.c
@@ -31,12 +31,11 @@ static const struct inode_operations proc_thread_self_inode_operations = {
 	.get_link	= proc_thread_self_get_link,
 };
 
-static unsigned thread_self_inum __ro_after_init;
+unsigned thread_self_inum __ro_after_init;
 
 int proc_setup_thread_self(struct super_block *s)
 {
 	struct inode *root_inode = d_inode(s->s_root);
-	struct proc_fs_info *fs_info = proc_sb_info(s);
 	struct dentry *thread_self;
 	int ret = -ENOMEM;
 
@@ -51,19 +50,15 @@ int proc_setup_thread_self(struct super_block *s)
 			inode->i_uid = GLOBAL_ROOT_UID;
 			inode->i_gid = GLOBAL_ROOT_GID;
 			inode->i_op = &proc_thread_self_inode_operations;
-			d_add(thread_self, inode);
+			d_make_persistent(thread_self, inode);
 			ret = 0;
-		} else {
-			dput(thread_self);
 		}
+		dput(thread_self);
 	}
 	inode_unlock(root_inode);
 
 	if (ret)
 		pr_err("proc_fill_super: can't allocate /proc/thread-self\n");
-	else
-		fs_info->proc_thread_self = thread_self;
-
 	return ret;
 }
 
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index f139377f4b31..19d1c5e5f335 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -66,8 +66,6 @@ enum proc_pidonly {
 
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
-	struct dentry *proc_self;        /* For /proc/self */
-	struct dentry *proc_thread_self; /* For /proc/thread-self */
 	kgid_t pid_gid;
 	enum proc_hidepid hide_pid;
 	enum proc_pidonly pidonly;
-- 
2.47.3


