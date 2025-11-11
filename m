Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8AB1CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 07:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DAAA8E0015; Tue, 11 Nov 2025 02:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B1248E0002; Tue, 11 Nov 2025 02:21:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FD48E0015; Tue, 11 Nov 2025 02:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DFF9A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 02:21:41 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 96F641A044A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:21:41 +0000 (UTC)
X-FDA: 84097481202.12.2AA3F7A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id E0DE51C0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 07:21:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=DzriejRZ;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762845700;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZUuqKrs+nqWkpfLt5q4RrHggbnk1CWWQm+NX1Cw0DM=;
	b=Wd1poVhSLNYTohw4rgLJhd7FB736NazcjuAeWEk7ZB6bp8P3/F5/UxIXT4En8V0BdTDa8e
	1yPQtLD5UEBp79furvDuZx3xk+SD6h5p5MaX1iy63+z77UPmgPfIQ2/gvUVMKZfKFw/YXH
	SjdKV3hBDyrDFX+MsyC+5itvZWvBuuc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=DzriejRZ;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762845700; a=rsa-sha256;
	cv=none;
	b=ero1G4AuqJQuvVlKuyW4hmEVmFjFi0P6O9wZdIvTYEnPQ5kH/VxBzXdpHY5cmPf39jt7SU
	BcqNmiAqsC4YQ7OvgHiyv6jOv5GPqCETR2OmRyDzi4RIFgroyY14D8v+uevcMhg2N/0Nn8
	LI3k49V+jftY8iVPft1XSFdLumusfd0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FZUuqKrs+nqWkpfLt5q4RrHggbnk1CWWQm+NX1Cw0DM=; b=DzriejRZZQpruszS7u6QC+IdRW
	m8VOUhOtMXPLPfg1uzbUoRaGSvI80iQTbB3p+zXHNIuxZTwBCQVvFgGCz9BSCgvSFvRHYvqidcdDD
	O7PzWdxvMjtiWFwEvZnkF1dhlqSlBrZIWXop+WsyNUkSms1zy+RxzvMLuWaBLkaKJDNrpJxThD3Jd
	68X03LVc81pymNdyvH/wtvo3A6N71LJ6iC9TVhNEWZBfDhCjaQEH8e54sTvmm7XBJcnxG7zOCh2xa
	E7e3c0h19awSVEQDA5mldox9o/Su4zTtUURoXRL+ztaC9dVF/a508XCBHJnnMVFyL66bJV8zCGElE
	RVN/gSyw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHn-0000000Bx4o-2hjO;
	Tue, 11 Nov 2025 06:55:27 +0000
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
Subject: [PATCH v3 35/50] convert selinuxfs
Date: Tue, 11 Nov 2025 06:55:04 +0000
Message-ID: <20251111065520.2847791-36-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E0DE51C0003
X-Stat-Signature: rr1z14tratwkrb9fba4bda75nditrc8p
X-Rspam-User: 
X-HE-Tag: 1762845699-199591
X-HE-Meta: U2FsdGVkX1/HUcfYvI8qn7nCNgDZ7+TQGzMVag/rdspipNZdVyJW3QISVyBNvGDYUcTIVeCu3PtqMX/bBP2GlyJ19wu0JvtQhShfWAJfWNkXC0H2jbByXrBD1QmoO/KYCcfNVpFjM/vmmNamL8pEt70m5UxNIa+EuAwzJH6JkDw3XJBfxiJ4chTCfgFQqfRr5YP5Y6bcFv5wsuQLQaLy3+KamdWzsy7sjes+kUZ/KL0PDZQxaaRdazJDpL8VDjunaysAcwhsli35P4x8IH3ylLDIwWLAmhybannFwlwABPc6dx2C+53sIEoIvfOSKlwZj2IRAFNaRWgXE3FGzEUeb81QjdFidIy6j66z4iJDL00O589DU9eT9LOAg5D1LgCloTBzMuSO55arh7PBPXp7e+wPz8y/8epi03W7kpUKSqD9aLX6RfNK3fvrlfoWCzqM1l88HEb3vYaEU9tvR+iTped9awTbYSOlwAWhPm/1rivThpREX2dT5HO9T8bq8nWvl9sP4ANcGQLTUHjeQpPdHF1loTCoqQSImTgK+v43oKC5/pcqHxyXIqh+RA/ppp1KdJJWkg5U84329XBQVlAa1FJlJlyso6F0i8n+aQiiE6p0US+KAUGwxZXUwQVoW+5wXE8TgV2LRACt5SWcWx9d4NUYC8tU8QUnhbyNKJgrUKFenOsEgTxLZ59+Ed93dTH5UnfdX7ayc9DpwbbgidoJO5NW+P1c5n3he3pB6pIkU32OXdaYnHDAxnCflWC6JjUVvWsaNgF+NjpmRkhckRQLWfFVJRjlZLm2I9rykdkhoHwcBy3z1RwJWkgFF85ZMUwyYsUuthgYUwtgxRlqRpZgwDAVKWdzSVMTg3e4UoFjtyWruOcouxUvQ2eeDFWrbOiKJh1lEkSkHbUWCro1bfOk+iYdYv6GeZd1oNM58mRL9U8l0KdFZUMFuZ2V4WbKAIhBTdpJt2+KwJExNpVEhlS
 h1Vn/YXY
 MexG4gqHE+VC6JSIszvA3ZXqdOD9lRvpQHaO94XfJFc1o3a0fVsJPWP5fudNqJJt4Tal7ziyVS2zxS331EuntzNiGQ69Iwyhrf8eHSIHK/LBHRN33pKuqjYl9CrvIpXc+4g3qGyLl8SMs9YGRth5SBKKKBcjJsalcczcAr3oZtybInBwn/acmz8TG24bJU6nTvjvMA0/q4P/bGuEcvR8sqW0PG+URH6qD3SgmfV6m+wBUNlPGaN0xiuS2n2qmRs6Iod4D3J7SjB6R9WI5Jt3F+Edh+KrnHo6emszkZhYP9c+/QqkVc2yzo5cxx4gPJxNWYm4JSP8kM1YBrpJwd1YtaFMBmVpdBUtEd9vub7pXVVtA9V9AttYDOqDzwhJ5dWoI885Nb0GseBd4mOIT9IfY0b+nN31YnEcVDEu9TsootB1Z0WwEAptEG0ajpWFrouO3q46hEIzPo+9nLV/p9EsnZC382XZU6TUvajA2CVwsgTDTPFs07vuHtENZmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tree has invariant part + two subtrees that get replaced upon each
policy load.  Invariant parts stay for the lifetime of filesystem,
these two subdirs - from policy load to policy load (serialized
on lock_rename(root, ...)).

All object creations are via d_alloc_name()+d_add() inside selinuxfs,
all removals are via simple_recursive_removal().

Turn those d_add() into d_make_persistent()+dput() and that's mostly it.

Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/selinux/selinuxfs.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index f088776dbbd3..eae565358db4 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1205,7 +1205,8 @@ static struct dentry *sel_attach(struct dentry *parent, const char *name,
 		iput(inode);
 		return ERR_PTR(-ENOMEM);
 	}
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 	return dentry;
 }
 
@@ -1934,10 +1935,11 @@ static struct dentry *sel_make_swapover_dir(struct super_block *sb,
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	inode_lock(sb->s_root->d_inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(sb->s_root->d_inode);
 	inode_unlock(sb->s_root->d_inode);
-	return dentry;
+	dput(dentry);
+	return dentry;	// borrowed
 }
 
 #define NULL_FILE_NAME "null"
@@ -2080,7 +2082,7 @@ static int sel_init_fs_context(struct fs_context *fc)
 static void sel_kill_sb(struct super_block *sb)
 {
 	selinux_fs_info_free(sb);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 }
 
 static struct file_system_type sel_fs_type = {
-- 
2.47.3


