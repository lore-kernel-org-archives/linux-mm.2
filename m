Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB6BCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4858E000F; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B97B8E0007; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB558E0011; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEA7E8E0005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AADA9140956
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:07 +0000 (UTC)
X-FDA: 83908850214.25.A86954D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id F2F83140002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="RvJKajc/";
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=;
	b=m731bQ06nnDMFt+MeSbAfmxS3+/LVTqzGWIjr8XVJuR1W53il5yGmcTiRg4jyX1iTZNUW6
	MJAT0zhrLL899bqXjtrRhlIBTdoq4jQwhCZC1ib6vSZcdNFp9f4MwY8+LiBkdAfGF6yBDZ
	qhog8ZYLIjuFGc7UzMbGns5oQAFO7Jo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="RvJKajc/";
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=mL/LUAXauzHINYPBMtmvHjtvhDB5nTp9BktUsj6UKqke3BJTp6wm6+46D5aKE4fYzYrNMa
	cfxs3P5N72FzsDw5zGUYMG+KlRAXFBKx8AKgjsFiYReJMn0NF4XIbS3gWqn/RYjrgxQEI0
	GrNswaa9tduRFQuKrm6ILzEJiZnduSU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=; b=RvJKajc/aLE6h97xA36ghJ9qPP
	fFdMo+zhA73yW/TSGYb2I/SSIHetp0ThAH63uyAgSftWD2K8HXA+UsPTCluM+D84kmRbEeJ6tMq1J
	c5j+Me6puDm+UJ+plZWT+nBKvzPisxzCJnKxlQ7cADRLcoo+H5D8YDoYZFAqdvCUdB9wGYhIkxaxS
	hGpC3mAVze66Pdh5MV13/zeqCzMWfDb7vTu9qga5GXHSXG+SrCZnMz5qg1kgX/sQRFc04GUKPjKpv
	08Vfu3hLT7ApfULypi5uzF5QOmgg4Zk1xQh/x3WD/uqmGrl8jZTEDcrN1mIQw39arleD/TctUxxn7
	vxXfulzg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK8-0000000ExC0-2p11;
	Sat, 20 Sep 2025 07:48:00 +0000
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
Subject: [PATCH 05/39] convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
Date: Sat, 20 Sep 2025 08:47:24 +0100
Message-ID: <20250920074759.3564072-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F2F83140002
X-Stat-Signature: cgi5wdpptictpdaf3n6gux7b4a1ci435
X-HE-Tag: 1758354485-628199
X-HE-Meta: U2FsdGVkX1/e6UFEbGdHw4iPXReiMoULjdPkdjkvwSccOvpmTcyQEDJuqb2VgdPbEUPig+uBrt7+AKOsi8rhhJH5F9eX5pFwjZunkKnEafiGIg/eAgoBY4bTBpHQDEcJWbpjRc5O52UET8jsL9VWZ6rpZNaCEr3R9bSCLa/bcz25HPT4iVbaD4YlW8pqGh5iI3qbCskpzBoBsOu4H6ZDNAINuhAMYhNrYY7oX6dhjWGDBoLOoP9Co2PAGSEOEkpxb1gBagsAmkbDTyB+NyJQHmOvQMSDFrnEMLLVV29+Zdt5n2uMCinAeZeziyyogetDU+iwi51L29IJ2UVMnJKaBpO0Dq/O406JuVF1dcbADsvwmCNU8/ASQxJTtZcFRwaUlCgX4Fvc1HDC5ZdlQuxTD61svb396VajbBF2OvoepOFDZEEnvtX3xO0UxTnF+Bn/9cxPVKi+dpAVKmq6i30M2C7X2X6ie9mvgHzMRee28fUf2F9ahMHMDK1LkCGrJfM2y6arHYARxL6dvw17t2/d7KvmdDOFBFSbNuq/aYmBcPfoH+zZNX9IgMl+pBqPXCqiENSJDLx/FigMZyMCl5UuEKz8ZlkKomK7XvSoH+lA7S6HsdJRCs8yX8WuyBNAMAwPbu5VvflpKfJxppMtrZ1EX/FI2iHXHtpo6ey+/UgMWrkrxaxAAzzMxU023uR7TvBDWv8NmBAQ8paZ29MDJXrcMGAh4ITQnjLwxuU5sKx8LLSUwuOeIxIOsPCNAxte0Nh6RlV1qKQiLiLSEnjNBgkylgxvyZw9MXiB9hCPGfTfPoEA+J6MiODLQI4mlU5NK2KVRi2pzUNwhryCFKtPx2n634e6NMtla/fP6Rspbdzk7Pa2xogCj8Fiv82KKx+/gYOCjidhZpI3vo+mHrfHM7s5JYqgF66JHY5QiRZw/01xu1e7XEJCQEg9u9yZZtLnEIUjU1RnW9BwHaQcNqvdAP8
 UFRVX+Ac
 A5CLiKcq05w1nrr4l1JANNdI75KsztyCw745cfg2aWun0mEP/qlAjb4d3btsAZENn1ptu6mxU3U7cnJgCPLIZTlNmGt9IkzallUI1CwczP48V0ettPc1L+KO6iTJxQ7Mqt6QlXjqNlGntoKY5jqiif1+HWtmy9EDR7a2qZazmXgdFo6rg5NKRogn7p6KylhnSR6bCmJvqpD2RayG5CmwdDrkC5YmeQwnaTJypP9ik6j+eSsN3RRleXZ+7cOTv6cHBCl1RjyicIgSTDD/8KV95jqFssoEY005yIBt7d5dl7GFIOdX2GksGxa1Nk04pX3mbUZqouRkCZp+U4WyslvMDYfnyKxJV54+o4X8iabgT9gUbuIiOSKeZ/SqQlu3+zWXABr79zn3mhY+V46ILfugHIDLA/h6ZJToZyWzU/5ynJYKnYTpWmvG4tZrCBqPOv4lMNrLmPMUhZ/vyGoXUn39UqMq2wmLFMOYYiH3JGdLX219fGip5kuR+deCr1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Note that simple_unlink() et.al. are used by many filesystems; for now
they can not assume that persistency mark will have been set back
when the object got created.  Once all conversions are done we'll
have them complain if called for something that had not been marked
persistent.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/libfs.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index a033f35493d0..80f288a771e3 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -630,7 +630,7 @@ static void __simple_recursive_removal(struct dentry *dentry,
 				if (callback)
 					callback(victim);
 				fsnotify_delete(inode, d_inode(victim), victim);
-				dput(victim);		// unpin it
+				d_make_discardable(victim);
 			}
 			if (victim == dentry) {
 				inode_set_mtime_to_ts(inode,
@@ -764,8 +764,7 @@ int simple_link(struct dentry *old_dentry, struct inode *dir, struct dentry *den
 			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	inc_nlink(inode);
 	ihold(inode);
-	dget(dentry);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	return 0;
 }
 EXPORT_SYMBOL(simple_link);
@@ -798,7 +797,7 @@ int simple_unlink(struct inode *dir, struct dentry *dentry)
 	inode_set_mtime_to_ts(dir,
 			      inode_set_ctime_to_ts(dir, inode_set_ctime_current(inode)));
 	drop_nlink(inode);
-	dput(dentry);
+	d_make_discardable(dentry);
 	return 0;
 }
 EXPORT_SYMBOL(simple_unlink);
@@ -1078,7 +1077,8 @@ int simple_fill_super(struct super_block *s, unsigned long magic,
 		simple_inode_init_ts(inode);
 		inode->i_fop = files->ops;
 		inode->i_ino = i;
-		d_add(dentry, inode);
+		d_make_persistent(dentry, inode);
+		dput(dentry);
 	}
 	return 0;
 }
-- 
2.47.3


