Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BBC8CCF9E5
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 01:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9BC800FA; Mon, 27 Oct 2025 21:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A68800E4; Mon, 27 Oct 2025 21:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C75D800FA; Mon, 27 Oct 2025 21:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A68A800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:31:38 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02A1E13A764
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:31:37 +0000 (UTC)
X-FDA: 84045795876.10.8C7BE53
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C76680002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:31:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RcnVZKzg;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761615096;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcFcmzxfGV+3rJDGgJ/eg0JcSdO3AKCKkQ7NxQ/vrvI=;
	b=1VWyPLdwZUh+T5U2Cpckssu1G7ZS6WRqzjkmPsn4yNSqg0Ybc6ddsAlUSClkL6rtYDcNzj
	oXKvl6vV/uePT5iTCOY3DSjgoYBfYrMfxCfM4yl/OJ8uzLEtPhiIkK5M9gwuPbE5juEWWw
	fyTdOHvuzZUaluvW4YT6ZA8of7BKXIc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RcnVZKzg;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761615096; a=rsa-sha256;
	cv=none;
	b=s2Xy1RhGzTOTrK7BAcu8CGTdyIl1YhGfLu+feSQ0KhxWMucDlD6Rre6PHQOvwkeBgXFR5x
	Cq9pvYkoYoCqPSpgedcpS7qA7ZZGXSy1pW2MiE/3EKIj7B9vD8NNksRMuKYHoiy0utMlbz
	4XGamPj2aC7h1PeMFfFV38N0oPl613E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TcFcmzxfGV+3rJDGgJ/eg0JcSdO3AKCKkQ7NxQ/vrvI=; b=RcnVZKzge2ZU1Twimv07i13nqf
	QcTAS7+ds57DbCpe2rtYdEQxTk5PARrtpmJM2BrTn2SFSpRJvutptyWQDosOkBcbfgIkRnl3sKkz6
	l3S0K68HzObgZhlSis7xLOjp8Ap3h3Vvgb9fCy7L7KKIHY6cASWQdyKrYHvQdgeTwnJ1y22zpC5Zx
	J3xHZUgolAhB6fLGwxLd2TtLLgs634TGaQk8UUJGXW8ztkdIzO1tMc9E1WQfsHBGYZMSfrTu71afw
	JqXESNeUsJKgUFYqFzRFwYSJsAf96HUdjMmSbH885RndZRJzjdVYGgQQx3uYbk/spCH9UHwPzJuZG
	zGK7eyUQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eYZ-0dcu;
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
Subject: [PATCH v2 24/50] convert ibmasmfs
Date: Tue, 28 Oct 2025 00:45:43 +0000
Message-ID: <20251028004614.393374-25-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mbbzmb91p4sg1zyen685bpts5n54au47
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C76680002
X-HE-Tag: 1761615096-459301
X-HE-Meta: U2FsdGVkX1/1NAXzpxIfZyb8Tmc6udwq+pSUpzLBXz/crnyrxX1Jm6BxnDM+oqowRwqSd+TKEDcBYZVxDVaSZDnsZHH+TmOk1QUcXBLhUwzH78++jgfH6S4wd08ukS+5mdas9DKKEc1yVolCntTdV4xvJ89bekadel9pRmt6ofDlHwnfNBiPkrbOjuuiihvqmN+1DK41peUeDFdIZV8shIfb4EVm5YdpvS0QauDfF+EtqxzI7qwjhD923c1/rSXkOwnrbtG2yvOWroBCS0iwU+wKqP8HUoafww/HWCaVEV+dIIDBX2s53aoptT4t+3rDxunssIpAKD0lJr4NEIADqcba4fdr0p+tIkQf+o1aPGPuGb9wMoOn8Frkrdfgm5LvVLo32uYnJyecOAoKy9GQg3l7+L9BU5CQ0oMgzuX20nDXTJqJyCoMVZ9aC4zM9bLkJpPSgeDpqO0SKNaPrO8KvbGeZTsEql/cbSG/ERZBwwWU6liFnWDDM88bdqd8HjCmO51e1hTcO8zhm8GoXnvBCgQNk/ut5WVxoSU+/X7qA2t8gbs2oov9UPy3o8inN/gwElrBNRjsK03z2RqYbFAG6cQfjNlOyplP6+pB2ALPNVvyhSu3i5S4GAeBAEuSYNUCtNOapat9egZNFCZnhp7r1/SCXw9Fbxa08cBgPyMQ73TAG7CuBq9YB8AkL14hEXGhlTIqbsscsin2e8InS1sAMZHjZsHTHQpnR8E70fiN4R7eQvfr5dIxYdkGEwQX14LYPFIZz25yYWsYeCyp8NPKtLxzjrqrBwk6bQQ1jBipk+Nxex03gMVugJhXL21KKAE78sZGKOHQWQOhF0RQgMwVGKSZdYqc52zr8yKJgL89psN0ByQgt/PqBwBUqtr/frzqjlId/xNSrRonkou1T34G3Ye7a6RDuUXAr1qm1692KvLwz1apjUNEgRgUiAffwN+llyScfQ7vU4QmNz9tnt7
 6zJN31a1
 FZ7zprY8MShi4hAxa7I3y9MZ4ktBbiaBxNMK7wfo3Zb9mHFA+yBq5Ix2A/n/OIiIK9n5rG4IXjOt198SlWYNFc9v/Sf0r8eMnCz6ipa3mM3VLKPL3AmNYL76jJ+xLzano8MmkDfCUFEi0Coc2FNQlW0JAkds2LXhTToLNC80mFtjuYbZ78SEkKThRLv4vDmSOG9pcCdFZHKT/a2JL5yXVrolMfcXZ2NI94reTQhQ+Luku/PAUaD+Ge7Nfa/swJhAbmE/Rihg6G58qCEhbHWCyVWpukiiqSuJG3SLQLhSdRt58mkgNUV70AiaMdEYuedvnFxwheoFlF4RHznhsba2+KKptA1qIayHO+tDVHK5XTmotw5ttiLmmczcgpkSGnoESBaNix3yl+Z3TShDBd3BZMnyDe4hARGqAQ4Bz
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


