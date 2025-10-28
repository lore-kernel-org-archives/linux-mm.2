Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6411FCCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1703800E2; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B44D800F0; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98EC800E2; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FCE1800E5
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7A9D876A2
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.16.DA8F464
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 037B81C000A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="TQkTG/l4";
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=UoKGWMM9Lj/NXe56UznjcZ9qlxtpjY/967vS6OWzSa+v1To8jB7Il3JYUyTCzp7mm+QKNr
	5TSoiAOdXkffK7eXe8AvML0iQ29AA0iIqp5+R+vIDh/C72AMcV88+W08dCOQpOKlE3mVj5
	c06S+MaAHcoqGL5uc4zHLUP2aXQ6luw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="TQkTG/l4";
	spf=none (imf20.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=;
	b=GzIa8nqd/ukK0UsZcvFIXLb82539R5yRCaiw8ql6WCrDgpON+vB4bCYsX5VTG/s7b5sqSA
	74vI0/nWlDeZ0qN4nrOuDbY2ZVUyYJSaZ8qqmvKNf65ZINySV6MjqgsxKc11ITmwOhe+Le
	19tUZ/FAmOPdS4rg3jTOlqWLBVqxnfU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tZCVSqTQSDDLvQs1X2myYSkLJtZwbiT5pTgxLsDWfWg=; b=TQkTG/l4YgkpOlP+d1PQp7TBss
	TAOduNXarFbVZ1eOoYJJxTY+Ud7jJegjJhyIOx+eaG2xUFAJFZ3GCE9QShuPJsm10n+qKQWfivbMv
	nvIarbTTsx+LKaFS7gNAq6R87GW/s0sSaM5l6+otZMx3PSe098UUVdFfRM0tHZ7qiCcFh5U/Ype2a
	FPYtOk7idQXmkT1QrkNWTEFjZZoI1jzchz3HUfo3WYOEgWqoz/lr5kZqXsrQ18HicEJYZiRxUWisu
	QzvCq1Ay7RAnX7k8UfmtBZ1/16RRWtlb2iWzZjbxWg+CJxmYUDQ1EY45JWQ2cpqLOZkZQ0Jb24aGh
	wI6BtHoQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqp-00000001eWI-1hoi;
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
Subject: [PATCH v2 07/50] convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
Date: Tue, 28 Oct 2025 00:45:26 +0000
Message-ID: <20251028004614.393374-8-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fhn3aehrmkttwaargx4gu61wj57qddux
X-Rspamd-Queue-Id: 037B81C000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1761612383-908018
X-HE-Meta: U2FsdGVkX1/rQ1c6jkSoj/wqihgiL8YbdjRQdVehYt4J070Sr/zD/BsB9FhsiXtK23pERdJxm7/Jb5ppPC5iITZn/F7IkJhK4ZCXdQs6bp0U/AWj5/CJfiKAN74R9/MMImP05mhEKIyXX7f4Rr3pm+860+IGErTf2rA9hwJZ4Md29Nk9mQLhCSaOWSz2SUqlbk9+b4Hbg+QP1h6vOORkbXAToUnOsQ+N4xXth/l/V0Bw1rfeGyV/dDXMiLIvgXsWaEljOCXUU80Z2Uir99rlz4ebUyhOwAF5+3kJSvQEYbxO41l+49PzTXp0eE/b35pD1kfGAiltgsGDiogddzPOBB5GlriJmon0tfZlIXyjtNWfFt5zIOiFnXsrjHQzZRQ4VahVC1jbecdlx/Ih5TgAxsgcL4ed/e/HO3RiCp/yTGuom6icZHDaeoSTJgibbRbHJuwXfwER02LK8Akeo1uHojmw9z8LXZDhfeuXhNaBoHvTsQVA/3A+Sff7baHkrZEvKBG777ob5AMlebDQThEmCiM7UGNqnz7hGkQpjOmStMFYMOFgc6DDEBLe7uyVLn04UCMLbiGlJKe83kroIMZ99W38APEkjAeuFV8h6hXfdZlpe9FMnGIGB6wwMQJWS0VTOUl/DoYP3WsprK5MpiLMcaaGtMs44UYsCHFmnIpkk4zuK+dAVj+A9XVJA1eunmDTaXVWKTik3yHwotU5bsCJXtEaDy1XtfV8Qhf4BXv//hfwyrhtL8r60hIgTwwzRZwAf8M/yUSzIjow8MwNMXdEpKqjCF3xUrIUaVJ/2ZvUsks6NIHXtRyGhSiXP9FVenpGE9CY0Xzouo3u/vkPBjhkJRDaWipWJAwl1+sLViaTq06W4zLn1YbXpcsasYCpRJsJ/cyQbFw5BIza3fKpL8gPYzzCMoal3voFXiksU8MWPf8JhlaVL7/C52azmzb9szGWXx4JuOwMhWjQep5ZSDY
 FeVcRYim
 k2ta/Z3qLjmKTx2aVd7FIbYZQN9IDTNN7M40v1kqTLZdf2+HBag17WSmxpCUTjecdlIQv34R9CDDJUR8vf2u80xk40i2ceJe7ouc1usMmQkQUIh8RysAyM/0ydVCtuKjC+1UCeXADHswhvpELnBc4PdGsq/yKPpJiGDWwuE2h9++2qzaURf+dGkFgQVD7QuVXv3zt4FRy30kKVcXbMLmMYXNkxE/TpyFcQ3GWlifdLpKpE/blBECk285NTZGQ1bWSg5c30hmENAobPvyXTqtNOoK3aVsdVCvjKtG6T5N+JpGcQayjE68jmfBS+hjDu74j4+cSfGSNc+jUOQS8ImgotsPRJsvLbCYvwTLhxTV6c3MG82pl00tCsYQd8QSNBPYL7UHQRJNZsC0KVRrJ+iGVdCsyyjHTxWig5gcW4b1b8V8mm0eGWhxWSUlZGLUY1NbCygPqiR+aIiLY2ikyLp00ghg6pJjSOBKh+hIXlZhp2wazm/iCQhjLGFPLwA==
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


