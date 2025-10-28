Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D00B8CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB20D800E9; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 523DA800E8; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10570800E8; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 19E4B800EB
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2F601602E3
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.28.15D6074
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CDB320011
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EbPZiJBf;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=;
	b=ClqeZKGEzQwGZNykvk1XYL/Qa0R66+0g+2ws+p0Dr3qo31i04y7LWm4X1nIEBA28ErDaFJ
	NaHKQ6UQrugL77YaXaPPCCRHsXN0DjDP2RBAXEsGt/GBMD41ahinU5lV5Axz8eEb8dWO5b
	qC8LAIqo5f1LDbT9F3WBRIxvQ4EFJcs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EbPZiJBf;
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=8d8iXSIfvkAlLbfraVMYxJHhkhIjxneg8VAgaA+0PEKfT8JHIEP2HXTiyCMgh9oZOOGYjf
	MXE/NXU+yyOP2E+w/AfElaqQ3B4nnTlP7ZSeBPmBu7/WSQtBtOndcqLpQbaJc1r/xcj7F5
	GXNcdmYCTVqoGN9vEmbSMnjY5soGoX4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IB7wA0wn9kq4oYSSbdEKk+jzajBsWCKDcw62G4pXAEY=; b=EbPZiJBf0diW2/Ci6fQPYn6Jp9
	UVF8AdRM7j16koU+AET2zKguIIVi24r8ySvxjcePWT3utUedNDoOcgCHDVrEjJ8MbUeyrIfEKToRk
	ACuPFRIeyuXKTgzWj8GO+HMkQGS0h29HL202KSMMt8vUMaqsO4NE9FAf1YFTyb35bxyE5MpDasvAs
	kGBSugH7dYow7RHC+en6+HsaDrFlS/gkPlw6XWCZGRjnSIPH72kXRnhLYIit9XH3eo5oooarQ8NRf
	Z4XUb7qjfoEAoQ2CSki+R2MK4YrlS67NRW1QEPuyXm2iNr8Bk/fUql8yuX2Z752bTXE8oK2S1N7fA
	rTZFQ1IA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eZT-3KDS;
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
Subject: [PATCH v2 31/50] convert autofs
Date: Tue, 28 Oct 2025 00:45:50 +0000
Message-ID: <20251028004614.393374-32-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9oey7eey68ubfiqhs6sb7b1ko66ewsqf
X-Rspamd-Queue-Id: 2CDB320011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761612383-646587
X-HE-Meta: U2FsdGVkX18RDBs5IpSTv60dtV6shs2V3uNzQaKrmHEu3R3mAXFwubQsM7NvzKLj2gPLYpsje90yDqG9RX60Fax28V+ZTOQWUXak00kbpoRLUzmqzwdi1DWyXwszDQ5u7i+ZDgYZ+GND8xrytpCDFfo8WzlivjlrjwI2Q3tOYv50qfdKUl3i2tRcXu9VYw0oKz+YenFLDT2ddjtjsQ8d7p8el8dkXLYeNNliPB5FVyN0Y4/BAJJ+++Kqig9XqNj4S4fZRAx70XMfnyoeeFy3V0KjGLLdF5YmnJlLt04xyJfEuXJn3xceXsBpfE1VICdZDisd5a5/Mtba1KKQaDUD4EoKipZZepavXnxmwncO7zcnwKbVvHQ8q6ohQhElwS96DuQGOCwYwSNIAyomATlBbcU3sj6TBIdwuXn6jvywaua03nGyGFi4tLfl02wIHkRZD2Zwb/12LKRiY3d5dpYwcIGSEcVAY02bXpewXbb1pYtwJPCUx336TaWMdbSKK7j3tGZ6Uur57o3SXBBPb8TXJiLw/gqRxTzhYZnrr6hBRtkvG0fMJwNYtI7iAlZXpf9JfTNaPFZAb6v1+OVS/nQBxwFH3BEvIHP7BJBLElevDTN27jDOC40qHoEZ6p9+gg8eaW35ASOmxaxUnEKWLXxYK65I49CQuYPKnmcpN1W/eRhYDjC561DW9ydv7h49QPHlBYpsJHRO1I4JLWQO474WIWso0H6EZU8lrSUaKChCm9nYQYXjUOIKV60fA40wbCYcYNd3G7/4jWax5uMhwmEC9BcGKHg44/GE7ErWT5nDdt8xoeqMPUqPUp5ZMzNJM6urq97FeEPEHtohoFX/f2EuXEDY41xwtCuaqaVGIil11HJQ3KbO/W/S00xIkOxO2hv46D0qTsF/OnRpbexSnNxDNPBfQ7cxsaYo8Y9/QbhZRroVppbWI86/ZMlUDM7LljAlQWN6MOt+uoiMYXmn4Hj
 3B8OpDsp
 ex7bC3c83ZmyQx2vjTm/HFK0etyVGwwR8dRQqnRaN+0RmLYk68qGLeeCfe6hz5kgkiMLI1cY826dL6Z37ij4rTWX+FZSCjXbIcUn6rRASPNVMGnsnTi9iPYyyOh+ALoQi2UKJLm/VxOshsTOHTwfsjZKSv56h739aiUxa0FJH4a8q6/1vGR+Wj2ZI6h1KIa9WSBBJs4Sch1KXWyM13i/iuna4DCZafQXeBh6kKV2THN3TmQGoRbBf3wjNUc2F+Zuc7DETsH+Lb38Z8rgU5o7WShqRKb8jlw/Lg5a1fNYuYXLXfBPQwWs0l7RXC75qFfeioT8uKlG2fimo/obeChsa08bKTtYPGuLzyGQ7NShRhjCmqv/NzkyR8m+57REJDEGDz6974giMOifTNI70uqeWZOE6QCHTDPQRVQWKAa3saaxQw7M99cUuIC/aGiBJZW28xG3v97BGuuGyFmLThFp5lSazBtSp0VFxkPPxzsgKg6l4FfA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

creation/removal is via normal VFS paths; make ->mkdir() and ->symlink()
use d_make_persistent(); ->rmdir() and ->unlink() - d_make_discardable()
instead of dput() and that's it.

d_make_persistent() works for unhashed just fine...

Note that only persistent dentries are ever hashed there; unusual absense
of ->d_delete() in dentry_operations is due to that - anything that has
refcount reach 0 will be unhashed there, so it won't get to checking
->d_delete anyway.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/autofs/inode.c |  2 +-
 fs/autofs/root.c  | 10 ++++------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/autofs/inode.c b/fs/autofs/inode.c
index f5c16ffba013..eb86f893efbb 100644
--- a/fs/autofs/inode.c
+++ b/fs/autofs/inode.c
@@ -55,7 +55,7 @@ void autofs_kill_sb(struct super_block *sb)
 	}
 
 	pr_debug("shutting down\n");
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	if (sbi)
 		kfree_rcu(sbi, rcu);
 }
diff --git a/fs/autofs/root.c b/fs/autofs/root.c
index 39794633d484..fb6c8215456c 100644
--- a/fs/autofs/root.c
+++ b/fs/autofs/root.c
@@ -594,9 +594,8 @@ static int autofs_dir_symlink(struct mnt_idmap *idmap,
 	}
 	inode->i_private = cp;
 	inode->i_size = size;
-	d_add(dentry, inode);
 
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 
@@ -627,7 +626,7 @@ static int autofs_dir_unlink(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(dentry);
+	d_make_discardable(dentry);
 
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
@@ -709,7 +708,7 @@ static int autofs_dir_rmdir(struct inode *dir, struct dentry *dentry)
 
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count--;
-	dput(dentry);
+	d_make_discardable(dentry);
 	d_inode(dentry)->i_size = 0;
 	clear_nlink(d_inode(dentry));
 
@@ -739,12 +738,11 @@ static struct dentry *autofs_dir_mkdir(struct mnt_idmap *idmap,
 	inode = autofs_get_inode(dir->i_sb, S_IFDIR | mode);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
-	d_add(dentry, inode);
 
 	if (sbi->version < 5)
 		autofs_set_leaf_automount_flags(dentry);
 
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 	p_ino = autofs_dentry_ino(dentry->d_parent);
 	p_ino->count++;
 	inc_nlink(dir);
-- 
2.47.3


