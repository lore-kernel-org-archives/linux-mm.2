Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4897DCED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CF928E0036; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AFF8E003D; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C17B8E0025; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EB1E8E003C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E908513AB70
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.24.62F6BA2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 31EA910000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=W5CxE2G+;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcFcmzxfGV+3rJDGgJ/eg0JcSdO3AKCKkQ7NxQ/vrvI=;
	b=7NNl90JxQBHbFEcAhy+HQczyHLJ/T6sMYJDrrnLz24lLozB2XM0hbZFKhAPfYdCVx+3W0e
	1csA0DRNtNro+Q78RFaHiYxZXzq1z5tWFHSpso03ziXC3fAjTakKzFVIvrhFLfHxDFqSyw
	U9L3SN1fxHh1lj1w/Vl59TVkxy2CB84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=IIVdlE+gNyYvYgcYPp9rE60/uIg/Us+nd3vhTZ7maIkmkLiTsZ65XRbII12Ywbfvtu8A2r
	grF4MfBIbsIvkBKE94c1yZFGCMsdATualRGyW0HMVMEaQPu5bIbk5/apAxxeVyx2Bofo9k
	P+idZwsqdtTLSlCmKR3Bpe+MlVwmCKM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=W5CxE2G+;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf05.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TcFcmzxfGV+3rJDGgJ/eg0JcSdO3AKCKkQ7NxQ/vrvI=; b=W5CxE2G+pz0zka36Chgqh74FiO
	cRYX5sQWDySvLhRRmUwtmg4b1hrWJgA5vwF3FtuANeE6NxgQWtwFPgD7T7he47I3ZurEFvJu8GR2C
	Jz7cvj49hsQBuawm1xWIBDKanExaqmCHAmR4G9RIj6yakgAF2DS+ahb1Qf5U1RZ8ll7rixJA/55ia
	bdpXnq5wi3zR1d8OXTCUHspdujQZBKOidarzYCwS0knu+HJku1ydZcLBvOtywlKuAnOqBZs49dlIk
	+W08eu0rhTh98USxk1nWqN0G8NlAy7HmVoIZO7WjuL7DGMvR+xx3EB/AIQu/ueZ0Zz39ee9ra8jce
	dibIiFNw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GES0-2eS7;
	Tue, 18 Nov 2025 05:16:07 +0000
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
Subject: [PATCH v4 24/54] convert ibmasmfs
Date: Tue, 18 Nov 2025 05:15:33 +0000
Message-ID: <20251118051604.3868588-25-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: awkxt7mt6ytr5mkh1x8zz3uzxafag8oy
X-Rspam-User: 
X-Rspamd-Queue-Id: 31EA910000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1763442973-564238
X-HE-Meta: U2FsdGVkX18DrNHtA0UsfJuCBobzAURJuepV+LDiCqvMYIGQr5Q/V6HGF+rtbJtka83sE/FsFZCtzLohNb3ZAUHPFME8jlT/aPnGINiV6MiULcKdYCGNKvXt3BaqYy6K12Cl4CxyhJxoWX0FKOCpj64OMykYHO21kfYOpEkIIZBojJBJ55+oc4TvJThy1qHXwq5J4UPmzxRUs8XNp1j2ERu4Hp5lpBuQyLnY+tH+EE8dnlGNfDKSH0rsSPk5/W9+dlBBIyi3LiICa9L1jCIaAznpDL6QbqtQAWp3ezMgNevYQl0RIxK/PoDRrsLtm7LJV38TnQfk2vI1aDIW0ETpzkbR+d3p9mbSOBP8f8M+YmrJv8cx0LMJcoDWhHSHL24tjhSMJWx78K46LTs49dRPZ91R3vmRPdWdL/4i8RqZCBkuiS8RpzffXQAWQNF2dQ/WBJpp4L5RSjTt7YijDeIF6PXz6YfUh7NkRLaA7JWQw64AB7uFU5N2XaK3ybGllLGygnE3hi/1BnQkAWR5/VhDL2nVgGREGbTzpWec5q55B8KdqC2h5inYp3Ax/+WGvfyo7lzQB4R+CEaN6457DLIKHoD/6lLDnDZ2yUaSf+vIgTK2HihcV/Pb6fcmlmUv4zuhLivb4kYX9+S8B9TiAyEA/eYBYKoO7mnKssmOHx36SiZfrl2rBr/q6PuwmAlLD87qh/zKslXv7Q+AEmHP9DxowigxE98/neSHnPd4q8iMPSJG8F2ThKIxTahI5RoZyTNpKVmL89eMTNhWBcDOb9OTHQJ0I58vlOIcwInoFIR+IDDaQgkmRBCympB8/a3e7oKo+v22KssCL2OKn04E6gnmSu4mc8neQGgXvkdFRWkns9LPFffJ9gYcuMCSNfVKM1PCOKGPjcqTFIltqb4EN46c5aNDTc7f8DrqMTb0nuaU+46nO5KAM6/xK/DXQIJ/A6L+dwpOFt1jflSXrbUC7B7
 RP/uirlu
 BsbOZvGjnnbCpMhIkRNncrVws19cEwcoGoiZsO3p56Oni1iOO2iQXFZD5IBnAvSzgPNZQ35H6sAcnTlanSwW9ciYl4Dm985zMOoHQTsfDmVQGyhGgTlm6iS6rmfEN76Flmx49Zogrox3GREn6XJ5AnSNc+anO0YHJ6RmVp7qqC6cIaUKO9sLNQa8QH2ImXuquCUDmdei8WUCzLliak15yP2Hxj1MAkesRg7kCrOUTuaxiELILYgIdCNlhLbxua4WHG3Uek5qZrUBTb2jj19cSoK2bLaQJnxDIUvbbYt89d3xpzoC+nX9Z1Sh7+ARfVg+6LtvNLhGKU0oQXox8Kqe5CcajcQoYvsXt1KUweTTjr4JolDBIeHyJjHmQJtaVoOXvP8zg8P09xBh42LfUiTQWdj9ISPnIAUjR3JlR
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
index b26c930e3edb..a6cde74efb68 100644
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


