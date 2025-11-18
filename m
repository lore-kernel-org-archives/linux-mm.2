Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04096CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9208E0009; Tue, 18 Nov 2025 01:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0898E0005; Tue, 18 Nov 2025 01:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE3C8E0009; Tue, 18 Nov 2025 01:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 204488E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:01:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0002412E915
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:01:33 +0000 (UTC)
X-FDA: 84122680866.15.5DFB851
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A67A8000B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:01:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=DRouGeZq;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763445692;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCYFuUAfEyL0H++y1+uBZz/Bn18lJwb1nrzO1KgbXu4=;
	b=DtfAGZ6Sh3dUObcTI7N9sQeS5XHZylQjASFsR9t0Fdtp3rqnsTgthouD6gWrMTB9oKHbbs
	kZFwC2PMCP1BcEwpZmC3SkXpioNrhIzwvVLgq9IBPz1dwWldfA5aneqopH9A23q6HGRBK9
	o2q0oD3THvFEPuZLryR8l5RR2BIheBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763445692; a=rsa-sha256;
	cv=none;
	b=FXlMc45v0gxZtSfGCks9qRb4MM0jOWA15ZNPSPw66u354f0QJJsoAC/TDGEYa2i15oRbDl
	ZqEGgG7hd2Vo/a5eIRbKRZiKq7NJA/vRyzGsNJGBeo4xeuFNKB2IXFqPQ15Cmi5eUrsbTx
	Iwx3rZ5JoeMdm89/NyBdIFkLCWUDWak=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=DRouGeZq;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PCYFuUAfEyL0H++y1+uBZz/Bn18lJwb1nrzO1KgbXu4=; b=DRouGeZqIAmgV0s9JobcdlI7wk
	IIomwQcf2p8fEhF8o31xjQnwmbI6os9qPBvWDAuq5AjIlASElFxqvEXeHSw+sIkWo/iouyNaKQAYq
	+1c+sEXO8xXhqzXTqOajw/SBx9/XPOqDw2fjgeCkzATAMn7dee40QMPQ/KYmzrFPOTaETpiSnu8ob
	W92bxUpcOwsMSh7b5IEzVqz4HG3XsDhZYvJcVvhGCY+MYt9tW8uSub4mqfvoxWRN4x6PgW3Kn1c6e
	r8No7lL1TP6iRyhhDcu0pY2ZK1FZTt3qfdMMfZT6+1zlNLhHFR74AnmnHRtYeHOvVjJFfgLVWLELu
	39wfoa4g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4V-0000000GERo-1unG;
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
Subject: [PATCH v4 22/54] convert efivarfs
Date: Tue, 18 Nov 2025 05:15:31 +0000
Message-ID: <20251118051604.3868588-23-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xw7id95k6tzkfsjppnrjiyorutbfrc5t
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A67A8000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1763445692-66710
X-HE-Meta: U2FsdGVkX19v8X/h8ue9p6UXOoWumc0apfAoP/DcARXy1Kx8wlM3Plr+rdWWguQkjM+GaLXuFHuVLm+AmAhlzPNpzy1fllKq1VIk+oznM/G+Sgd1AKzC5nTYPhEgNMALJAIwGYStmv+aZqkcESTilDTE8WOZ6+qs5YGUaHd5q4D7WnVda0R4ccJwCyWZOr1l03LEeQf1FyC0wBklW1+Lcacj50RDyJhiFwRJyMTC6I8Fq8xKri3bRKhEMoWzQqTIMWhtPXJya7xLSXTXwJtLV4/7xC0SNT2Dv6AcjyTZqfo6/axZ9rHBTYYyOVD+rKZYQOoeg1MoBODy5M8Idi81F2cJxFUUzByvofHiolG1ae03ZTMkSSQmaI3NjWAE7a7jo4pHPWirRU8sGuopRwxWD1oKKA1wbhdt/x9+5Y+82b5/v1ihn3m3UfR8DjHk//r+fe8KlJOtzfSjdL6GpbM4VTkzFHFSaONHb1jXkg4EfJQdbjVEiFKw/TmlKHZOcwcU+nVd6PFcBsCGk/I22MS+HsT9iYQ0ZZNkZR1bToVgGyckJB9Ng3xY+XTyVs3E3r4ZNQozCs318r0AABQf74xdKIWF/mYnalvZauK+udbDM6FkcH1L124o3/W/ELacW+PUKYT80yTOjqPX+2aALTis8q0fmzt2uZWNdRvgaciYBwqD6xpC7TLf0bK8hPonwItP7IZh1kLGrb6UyphkPdFbWYD3snd4II/vlYqATNgUpnRHqgdlT72g8K5V3oPiFG26CCMWrbdWdMbJsw637BFdpA6n3ePCIJTiHU4k6pHHHZLsMEVImcKBRAiSa79teT9FoRgXt2mpjJMuMFttaZKVPJjJKbHNTHzaIorP51TUrB/uFJ05f0p8Y1fBJ4EngxVnj/lIA8oub4AxcNBQYjyTYSgIcVnhHaE/eIVBiB33Kwk675Y3CSJrQsNwR0pWDeP66Bz0VAdN65glO38PVTr
 Q/ZLNS9F
 MDRHM8I/WHxHYPh6q3xVTjMv5f4ArpaAOSbFapGUOqaxjmaQtW7PlrX3nKYa3fYNmNdKUW/3D+vLRpcFLKnHk28dZC37ttdTx4XcGjAGkvaJM0abkhV/kuUy+aAlWP2hMKRBC3FNc+sZWzv/iG3JFGz8dAYqOTQ7aYzoduzrVUB7aIJYeEwZZX7vUId3eNXT3DlW/CBtAFBaMUdibQWIEFohY4vPoNP8k3yQAcZDYjnUMqF8a9T8wfA+3M7lAjV8NDj2R0AsqJDCNnl6RXyQATH2BOUrhoP+1ZY+BAwoDkixwk/gsmjtjklkdJGvb981CHurT94Qln+MR8wPEjSaAdn5XGgUXfXepVvRc+pKYlDmdKwcgBjh4WJP95KCnIpN6/Uej4LoZJ88XNcZTs3EoGGPzhJTBCxOZZ+z3eTxk7c6hFvNGDHzm66VbllpM9+7vUpz0Apo6Ca+wBbM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initially filesystem is populated with d_alloc_name() + d_add().
That becomes d_alloc_name() + d_make_persistent() + dput().
Dynamic creation is switched to d_make_persistent();
removal - to simple_unlink() (no point open-coding it in
efivarfs_unlink(), better call it there)

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/efivarfs/inode.c | 7 ++-----
 fs/efivarfs/super.c | 5 +++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 2891614abf8d..95dcad83da11 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -113,8 +113,7 @@ static int efivarfs_create(struct mnt_idmap *idmap, struct inode *dir,
 
 	inode->i_private = var;
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 
 	return 0;
 }
@@ -126,9 +125,7 @@ static int efivarfs_unlink(struct inode *dir, struct dentry *dentry)
 	if (efivar_entry_delete(var))
 		return -EINVAL;
 
-	drop_nlink(d_inode(dentry));
-	dput(dentry);
-	return 0;
+	return simple_unlink(dir, dentry);
 };
 
 const struct inode_operations efivarfs_dir_inode_operations = {
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 1f4d8ce56667..298ab3c929eb 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -278,7 +278,8 @@ static int efivarfs_create_dentry(struct super_block *sb, efi_char16_t *name16,
 	inode->i_private = entry;
 	i_size_write(inode, size + sizeof(__u32)); /* attributes + data */
 	inode_unlock(inode);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+	dput(dentry);
 
 	return 0;
 
@@ -522,7 +523,7 @@ static void efivarfs_kill_sb(struct super_block *sb)
 	struct efivarfs_fs_info *sfi = sb->s_fs_info;
 
 	blocking_notifier_chain_unregister(&efivar_ops_nh, &sfi->nb);
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 
 	kfree(sfi);
 }
-- 
2.47.3


