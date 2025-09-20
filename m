Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB4E8CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 09:11:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E8808E0003; Sat, 20 Sep 2025 05:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C00A8E0002; Sat, 20 Sep 2025 05:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC978E0003; Sat, 20 Sep 2025 05:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DB0B8E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:11:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C93681407D7
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:11:37 +0000 (UTC)
X-FDA: 83909060634.15.2025598
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 25057180009
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:11:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="i+OJ/PxV";
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758359496;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tT2z+6P9K4+uWY+P9oa4gJTY9OlBzdKJ3vGtwqwrgNU=;
	b=tdU9eqc47OTWY8Oc9b6WNSy1acJafIRCdUCCd3U1VNGHY1LyIYEdWye1BdmrvBG2CwaSkI
	aVoKaZCQ6SxcAamSCGqd5EoZak5sM8KelPdl//JiCkKJxYHXo7pSFcUSbAUp3WGYsmMAzA
	4nUUY39MWQgjnpRjtHOst1gmSy04E/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758359496; a=rsa-sha256;
	cv=none;
	b=R5fYKGMl3OkwrRy6BH2TiOizt5PzOYYhuWfy7oAMSjPYBOQPy3lhV4z8NIEu+s+RAWVOxZ
	HmxXNOdSlu6oQkGF3RneRgjlZaJh253v7CaAoL1O4W3Pgi93xDbvbF1aa+iRElqCVf4kgI
	wmLOzCu0m4ok6ZGxW7huDG5UEX7FvBY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="i+OJ/PxV";
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tT2z+6P9K4+uWY+P9oa4gJTY9OlBzdKJ3vGtwqwrgNU=; b=i+OJ/PxV0i+zEN1UV/pCBBmAu1
	GBYoW/VweRbwndK24Xf7NdzHCcO8A6oPJjshziH/PW6H11pmEc/lvptcl3mCt1cKQ27KmKAnLCN8p
	275aRw1SGU6kXTRihXlSHxM9lKGBXxOVKhxMjhAZdEwseioNCReGQpylOyklWo7FNXwKn/yHkQAwA
	F5b71tfyHPgUOlR8kfiBq9nob9/7I0lmN+Xlz5lWm6Hy9u+5yJGzf6SXo+GuiMOD3/saKK/YDoSnZ
	OCzUqvjdRYCk7wJMOWseq21+of+x4i/FNzLvjiHJjPeUUZnt53NpidpOpqLQaLMZfHRiCFg8J2Vwp
	I1n3Dl/g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKC-0000000ExGi-2cmZ;
	Sat, 20 Sep 2025 07:48:04 +0000
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
Subject: [PATCH 25/39] binderfs: use simple_start_creating()
Date: Sat, 20 Sep 2025 08:47:44 +0100
Message-ID: <20250920074759.3564072-25-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 25057180009
X-Stat-Signature: e3to4fb4oeqrkngso86b9edx7sseirbn
X-Rspam-User: 
X-HE-Tag: 1758359495-213374
X-HE-Meta: U2FsdGVkX1+16Z1EzPNU3Qi1BI7ZdG3+1Vy7vuMNKXnYPA5eJ+Y9wYQlX0Gpm3si1XqJ3h4HA8s6ClACNddVSySCq2WyaoWIkxfPymViyYs1/zgexsTm58YqAUt9NF2zGu79YmNn/EkXAw/BWLkLvuBC00IcosOoFw61BheytAXjBU+ZX8BdGfISlfrGrdCzXpWEdMHToTL4vsX1rc0pYzN2p/QF0h7oi8SHFJ3u1T1CBhw5xJvgNHTHh58+hZgvXh4ZepalLH9dPfQYdp3pPljKkv9RkUmaQrGwMrM2FZ7W01AuafBr2i025RqCWq4lTAOt5qIfYEfXwJ4wyXi9RB9Z6zudslixMVOLui9JADAIENWOMN+n7LESLd52bGn9ckixr8E6Nnpav+8b0KzuzRsmn1olw5Y9UIPE0i7gw36xOTqH2GC5LbaLtGhXt60ATXlHQ0pfRlSuU9OkXERAFyVSiWkpI2tEU/Zngd7F9X3Ql0mEmrmrW3tbb+3wp9zARVZWwDff3CKI2qyIU4wWK0IptNcBFWL1V8xPyC+XTUMvzN4DNX92thqseTRGyFnXDjVtJPJqlQaSU8TZ/s/y1H8ivb6aDgs4ogSLw2n3pVDUWWoue6n7PGOqcea878f/Bh3CGXzq4Ddl9vY89mh/fNDPGQGLa2rrpvXRUUPPysuB4ysy9ZEWW+Uo9GrR7WzaD3UqdkEAkQeo9uki2sktMVZkJxk29afdqNUpGFHaY05X4F4K0op1Ho4npImbO2M+jD8VejJJqxAQSJWz3GJwPSIVl2acKxhUJE391X+Mb0tkDorOTjz2hIMbbUUcGHeWa0+GlHMazkFVXkgxmIWGF8jXNc265qgM8I4WE4JUVYH+PtAXnUsuDykaRjVYFdb6E2MWTXeyWThSF80FaLuVT5hTYhMICMucHqi7z1dED1Ev+HmKc+9uTpeWUE7fdgdPj4u21i4XqSrhymvHtxL
 BRvUVVsV
 kMTZ91HJPsHWKnK4SQdRneni213nwgnIi79iIU3k5fG14lV/yq4F97Ot9FFeb1UOjXlSOx4b8/Ni00LrpEO6ZzBQtzjsPMdt1nfl3FvAEZfYllOvKqTrR6Ngi90/B+xtxyNIFhVr1CgkpuwLF6QUK8d1rQFRmRLbTOflS8SpV/ZvTVik0NqTSQkWRcEj2wxEXDTM3SA3Y3h0hf4u+7Qp0jQWf3WV9HPiD/WY2uM5EtaxtEDb3yYePt10Ddr/ThycKjUqxzN9nsNYT2k80gDlAHcnZ0G409NhhrxY8lETMrgLI2gyHzz+FLa3/Vd5occRTreGbx0UjZtsCnr88MMcbkKz+yIivFwqjnwtHRz1VfYjNUPTDVyFQf4lsv7yXOkBhtHM82jln3xPhYuDyF1x/uSWIkOkLQrnikxTiPyvHNFyDR1NTDLh1Q5rmw9qGKof+yCNXPrwyegWGB5nfqOND1UIDjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

binderfs_binder_device_create() gets simpler, binderfs_create_dentry() simply
goes away...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/android/binderfs.c | 43 +++++---------------------------------
 1 file changed, 5 insertions(+), 38 deletions(-)

diff --git a/drivers/android/binderfs.c b/drivers/android/binderfs.c
index 0d9d95a7fb60..41a0f3c26fcf 100644
--- a/drivers/android/binderfs.c
+++ b/drivers/android/binderfs.c
@@ -181,24 +181,11 @@ static int binderfs_binder_device_create(struct inode *ref_inode,
 	}
 
 	root = sb->s_root;
-	inode_lock(d_inode(root));
-
-	/* look it up */
-	dentry = lookup_noperm(&QSTR(name), root);
+	dentry = simple_start_creating(root, name);
 	if (IS_ERR(dentry)) {
-		inode_unlock(d_inode(root));
 		ret = PTR_ERR(dentry);
 		goto err;
 	}
-
-	if (d_really_is_positive(dentry)) {
-		/* already exists */
-		dput(dentry);
-		inode_unlock(d_inode(root));
-		ret = -EEXIST;
-		goto err;
-	}
-
 	inode->i_private = device;
 	d_instantiate(dentry, inode);
 	fsnotify_create(root->d_inode, dentry);
@@ -479,24 +466,6 @@ static struct inode *binderfs_make_inode(struct super_block *sb, int mode)
 	return ret;
 }
 
-static struct dentry *binderfs_create_dentry(struct dentry *parent,
-					     const char *name)
-{
-	struct dentry *dentry;
-
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry))
-		return dentry;
-
-	/* Return error if the file/dir already exists. */
-	if (d_really_is_positive(dentry)) {
-		dput(dentry);
-		return ERR_PTR(-EEXIST);
-	}
-
-	return dentry;
-}
-
 struct dentry *binderfs_create_file(struct dentry *parent, const char *name,
 				    const struct file_operations *fops,
 				    void *data)
@@ -506,11 +475,10 @@ struct dentry *binderfs_create_file(struct dentry *parent, const char *name,
 	struct super_block *sb;
 
 	parent_inode = d_inode(parent);
-	inode_lock(parent_inode);
 
-	dentry = binderfs_create_dentry(parent, name);
+	dentry = simple_start_creating(parent, name);
 	if (IS_ERR(dentry))
-		goto out;
+		return dentry;
 
 	sb = parent_inode->i_sb;
 	new_inode = binderfs_make_inode(sb, S_IFREG | 0444);
@@ -538,11 +506,10 @@ static struct dentry *binderfs_create_dir(struct dentry *parent,
 	struct super_block *sb;
 
 	parent_inode = d_inode(parent);
-	inode_lock(parent_inode);
 
-	dentry = binderfs_create_dentry(parent, name);
+	dentry = simple_start_creating(parent, name);
 	if (IS_ERR(dentry))
-		goto out;
+		return dentry;
 
 	sb = parent_inode->i_sb;
 	new_inode = binderfs_make_inode(sb, S_IFDIR | 0755);
-- 
2.47.3


