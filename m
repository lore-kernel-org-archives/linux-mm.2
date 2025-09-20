Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A58CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 892308E000B; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C5C8E0008; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE6F8E0001; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 337688E000E
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2A0B1A0919
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.02.18023FC
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5F2A4180012
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=t9iONXrV;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rblw1/+FVpnDSF+tGzA58CitG6ZVFpPLgpN9TawlUAc=;
	b=48zYrqcNsPd3pOvGFNF1ezq6QPMOP8vocVuFs3OVUHsqNRhAaKKQcOUcUj6LPcFayqSYaZ
	o16p+549ZoyvrHsJAHNghc8hrWY9KpcACCKRe1G0t5bjHh34XH6MSWS8oPdZPvTk7Qalhm
	4/kuV1nDdHRHw7BMvh6bs/DHACcCeVI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=t9iONXrV;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=2Kwq8xDywwInY3HdmCFmyM4eRmUqM7mMSzAHDzgcpgZFjOWk1/+5GBRJstfdbw9mcdhR/3
	YklSiWc5v8iIlB+fW5KvRIclhJ1cmxZEaw9/yW0qSZQvuz2OdHMDc2LHJ6i2A27zUUA/nZ
	fHxYtiIzOR0k3/I+SBeZ5Al7lTmBUL0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Rblw1/+FVpnDSF+tGzA58CitG6ZVFpPLgpN9TawlUAc=; b=t9iONXrVV2xYR0Ohv6Uqq876VT
	EOLP68t82ONpzCjT6GTEie1WbU4Z5xuFIUQfrY7W3q92BniOaKvWeviTTUUvh/+gK6WzBnInI47DQ
	x3iQ1kIlshSd70ZWXETqVX7uIwzov3t0WdsszcElheVQ2bY76i0NDZRonXWE7dQyC9EiAmEQ6Bscb
	CjwXDS52jAujjzTldVIar/giui3Tc2BusRDf1/9QdkxmGstJBQO+kgyXUVlaXTOwelnzqjDTz1r+S
	6EokSysi9b0Fmqf/9VicVzGeuaGtZddJ9ODEOvwWRo69viMy5RpA5RqkrUcO3jKzhP58lRog6xhzc
	2jQZqg1A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKA-0000000ExEK-1Zwa;
	Sat, 20 Sep 2025 07:48:02 +0000
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
Subject: [PATCH 16/39] convert pstore
Date: Sat, 20 Sep 2025 08:47:35 +0100
Message-ID: <20250920074759.3564072-16-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5F2A4180012
X-Stat-Signature: t44xa15sauc676c18uob4kfd6u34yktm
X-HE-Tag: 1758354486-510920
X-HE-Meta: U2FsdGVkX19h87JRXUp2Y/+6yWpL8nYqlK2CIx3B1A3qAMoVNlG39e6r+BhCJt3O9sjjIq/xR3bN7NJYJ0AMNtTZQRlKRnUesVk4F8vcFG7OFWYn+TzakEU0CLOyr9QurGB186YnoxWC4kep30WbGmJJF0Qj7tppmhu6ZbVXO8Fx4Eouh/34GLF7LecWAsBN3MEol1wNksgGDa5T5DnWG3oz9Yre+nwQe1xAoJKfciSk4tmC/ovV/fmHNfFWqfmAyfculCdGgTFt35IIU7UykRCwF/YUA8SF9Q0CrHyA5Vwkk4cvU0N9xvgN7GD6YUIFlc8wVqD1c4McGwRWxdZWxkKvc6/ilX5p2FNuqCLGy+k8uUfW8sPKmRP4jbS4i2IvNH+J2wUsk4qqpZo4/y9T9/rUIjUk4wf+rVn1XTKv9ND2gwtGlvJ5xgc0KuIEelzpEMAWSMzjVoOz7zXyVJuvtqVrzs/Ts5vMBiVosC7a9D7Ab2rJ1G4uvTZXpMuMzmK0J3akYNF/zW0SoGUpPxVyOCvkJRervTXr292x0f2xnngvTZzMkF5CXiDxbUFn54unPZtAk4Z2JosYrCvW3QS0W1zdAhENqJAxrRBUog6cwDnYbP5EAJ0VUsIlM1219WJCR+3WudbdOToXFEjJSs14/qjBA8h/2CSxj0NBOvYVcw/8BxVq16dTCc7FQGxccB5PfO6bIrtQVjotJh6IHtRGy6VUQmeTssEPUMQQh2C0SM/mvDJoTfWnX4ycj1OUJ3FOJ6mkZid2k69c2G4mEkCNULQW73RNcXHnHU3KLGvh3TXVC0/gGdFiXnmMviFvupo9NnS2lBPwCIP1bVCrASnO54mCYCIbpNAzTWj/sPrSgvgfDGKzPxyfbkBjLDYCCqDL4DB/blaaCF4nCqKRCJaVxddMlM9vFtamdCHPZUP9Cacnv5K45QnwHpTomt2t/n8yK4FmqP5ggVAXVw8gsmB
 02YwLgTn
 qKB59wheNmXeuM3GM1n1k6hDAb//NmG+mmiqKO1Zw9mdpijncB4EpqNGW0spA+92M/yIRkAsE8L6u4JEX0A2r4TPnbXICZSM88dyy1pxgA1kNQIo9BGVf7ShCDppPs0tmo2PxExZ4flqHS7curITRSI4yM/vymPk7kx7+e5+eGGADIU3UUvdnrdC+f8SlL8m4ny08XBAcOfb0tSr8itcJ11sPtYr1WTYvuduCR4FFeIy3HZV9ut3n3tNcSXKvjiS0xC6d45cmHjzwInFFXqXc/9FQpQPf6otoZ8uaqYEl6QVbdz+zXHYu+SBqdlH1EjwC8lSUvUI9bp0Fp3MaLLtRhvzy0qzh/KJ4UGDmlO9GAR5SSlnp7ObXZ4oYFdf0rWokfMvDTU/FVOMTjLMg6DTOVKKFwr3jbglQkz2j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation by d_alloc_name()+d_add() in pstore_mkfile(), removal -
via normal VFS codepaths (with ->unlink() using simple_unlink()) or
in pstore_put_backend_records() via locked_recursive_removal()

Replace d_add() with d_make_persistent()+dput() - that's what really
happens there.  The reference that goes into record->dentry is valid
only until the unlink (and explicitly cleared by pstore_unlink()).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/pstore/inode.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 1a2e1185426c..bad479fbb0ff 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -373,7 +373,7 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 	if (!dentry)
 		return -ENOMEM;
 
-	private->dentry = dentry;
+	private->dentry = dentry; // borrowed
 	private->record = record;
 	inode->i_size = private->total_size = size;
 	inode->i_private = private;
@@ -382,7 +382,8 @@ int pstore_mkfile(struct dentry *root, struct pstore_record *record)
 		inode_set_mtime_to_ts(inode,
 				      inode_set_ctime_to_ts(inode, record->time));
 
-	d_add(dentry, no_free_ptr(inode));
+	d_make_persistent(dentry, no_free_ptr(inode));
+	dput(dentry);
 
 	list_add(&(no_free_ptr(private))->list, &records_list);
 
@@ -465,7 +466,7 @@ static void pstore_kill_sb(struct super_block *sb)
 	guard(mutex)(&pstore_sb_lock);
 	WARN_ON(pstore_sb && pstore_sb != sb);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	pstore_sb = NULL;
 
 	guard(mutex)(&records_list_lock);
-- 
2.47.3


