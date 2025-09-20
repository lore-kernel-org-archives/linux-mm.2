Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88271CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 08:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53728E0006; Sat, 20 Sep 2025 04:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD958E0002; Sat, 20 Sep 2025 04:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CED008E0006; Sat, 20 Sep 2025 04:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B22B98E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 04:32:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A20EB89BC
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:32:03 +0000 (UTC)
X-FDA: 83908960926.18.8CAB619
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id CD7A140006
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 08:32:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=iOX+SvVu;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758357121;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqA6uNnelhHPNdxaTr+BMqt87A9Hf9N7voNPs9LM5YI=;
	b=By6v3ncEQtGAq1cXo7QrfcVzaNX6CTfIW5Ozwr3KQ6YX3j6fJOeuL7mS1oO19Hdpv7pM1r
	DBrL301uxyEZZArOeyWjUgkSHxDbtV7iNfLBrz8I7WYPGhlsX36LEYtYsittCBkBWUoMF4
	5716l8m0F0H/ACLeksovEwFbGO7AYyk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=iOX+SvVu;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758357121; a=rsa-sha256;
	cv=none;
	b=oZG+hsT4gCm54/3Y6ZatpDYNbyxmGHR8PiUY+ZOdDjVdyA7skeWPEzmdo+kB14QJUVUWBg
	1lbFk8aiTEss7f6e5JNzTxHvUW0WiTWKitMSAtqSAxD4bzewHYfDK61lhxt6nxSmyaUrrr
	gz07nrEQu8jq80K7Lkefefpb2ZVEucw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=lqA6uNnelhHPNdxaTr+BMqt87A9Hf9N7voNPs9LM5YI=; b=iOX+SvVue18PtFh4vqwMLsvM3g
	nT+og5qvc1RpyWQNYEig7PwPyghWWW2axPiENKqw94Oeg3NsfhJAaGwuMuylM13vmzV+4nxHoftHW
	xVnc+onOTPvXe6MxIzPME6L3qYb2E7lOjrLkvZZ7ZPfCb3DcdIomj/bHJvv92EuDeH7UM0n9I2yGW
	nO9VriKQlu8YMExmaHFEuFK004y/0pCqU4RhcPZgXw7igdOLM/05eFAYhCj+dYT9/Gga0NdDYheTr
	+pFfCai9roXTbAGbbyD13fGeumpQEBrdNokPvc8EUC9bwINP+sRtYGd8XFU+vhCNfg+9owwSoQatJ
	Iv+GtRNQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsK9-0000000ExCv-1nhF;
	Sat, 20 Sep 2025 07:48:01 +0000
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
Subject: [PATCH 11/39] convert hugetlbfs
Date: Sat, 20 Sep 2025 08:47:30 +0100
Message-ID: <20250920074759.3564072-11-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD7A140006
X-Stat-Signature: 85tuzww6xqzs8bma6f7dndkmjc96n3s7
X-HE-Tag: 1758357121-670175
X-HE-Meta: U2FsdGVkX18A/UIFao7slalX153a73hh/wt2pd1I31OEGBhCR7oJqe4ckWl+cQYKF0m2nUDi6uXuibBNsvnfN/rBjIrM3mwQ0tC+GDwRivGPiiEjeXT2YMgA+C0uNy8CfUCmZJlLvdS6tW+Y03+HiIfQhKcmyhC2g1aX97vHYJPkHnwvlosm/2731LvLOIlKDSMkz3hYGrNBmtMM2ZYecPD8v0N/eMQ1KmQss+yPAPe9e1Jsyy+c2GWgU0tqYX/QXW6F2HveDLHf6hmxEtte1+E8eN7b+zf8K3+LTkxNkUHMhPzOv4N07qnEQxWStjZ4WvSt6bHZsnPhYgRJfxLVq82/7DFQHcVrDN76wTA8ork/JAL4eRizTZC4pKRiUodue47xnTK0qKFegLFjsZYmrXrRRmQW1jdyUkZ5VceHvWPNIGKzcKEFtMLKcIi/3HtOORIdC3wmfrdCOVvia1nxjb6zUmp5s2mMiiTOjHlfqOPkhITUpC5XcJDu6cvzoXVwEqNcwhMe5bqq1jt7QMru188uO5YUzwegXP/7DNkGiEwKGSqI5RorbhsUh5hgvQLX2svdrf7h/v6WK+IM920fjNkM9rMYHlHszjsHmYlGFC39+0hbo1ZsDeCpmc+XFtel2A2g5H0smwFRDAAA7+vT0P3O1GNILUdovXApMoKjpNcxPsgJ2JvvB8MTPQc7/dkCDXvvd0ESQTfhdOHX++FWyeS/3P+6VMU/yX4Uc8UDFmfA8BLNvFskg6ouodDR399k3EEhNAeZWC2HRIOH6ZUtcFFnZgMGUZ+j7ZxDuBlTpuH9gm9ME/BMSnThoXCFy60c4Ltt1Zs0CeiPUDde/OV2ufrWSLmJBZqBY39eldg+njTNSXhgvhfxdueTxSbYyq3B2q00Mqzf71RAVY4szdKqTg+j3CyUzW/JFLcCDmdzdQiwCXKDOBndSPl3UDfNTTSYmHUgWYDO0XpwO7UMOOH
 99+R6LNH
 PDals8vru0o1PnijD6HuOATXoUg8Dj/kcswR9hl/fA85HxzY3kk4FNdUVbtuD3obQIGzfoijIHtU972Jd+podrHg4kF6i5srKNSUpiG+aJ7fUACpq8yPbSz0tJvezd8OaBp7P0ylfL0E9lt/GYtHj8n1MORf0GRCFhLtbRGT6kGxikYihOMD/hWEUR6ihWY07rh4cdOxyHm28myvEjdnJbs1Ve6O5i+qh+kUBcNDs5/t7h43y94EXL4gNVN41Lq6GRtKsCNeN5lh6t6h7R3K7/08tR1+RoN8xj1/HuqZU3UTkTgdB43x+6yNtdr78RC13f/BjuiEQV0UZbZ+sTSXcZ+sJuET7pyc4XGBG9IvJwYcnMnK571qN00ZQYmfQmu/b5y/d9gfbOYoES1MUqt+yNZ5eIXKeUienYD43L5Y30EioFGNeBxf93lumgBjMRRg3lsqnBr5W2G1KS7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Very much ramfs-like; dget()+d_instantiate() -> d_make_persistent()
(in two places) is all it takes.

NB: might make sense to turn its ->put_super() into ->kill_sb().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/hugetlbfs/inode.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 09d4baef29cf..f77fb71f78fc 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -985,8 +985,7 @@ static int hugetlbfs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	if (!inode)
 		return -ENOSPC;
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
-	d_instantiate(dentry, inode);
-	dget(dentry);/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 	return 0;
 }
 
@@ -1033,10 +1032,9 @@ static int hugetlbfs_symlink(struct mnt_idmap *idmap,
 	if (inode) {
 		int l = strlen(symname)+1;
 		error = page_symlink(inode, symname, l);
-		if (!error) {
-			d_instantiate(dentry, inode);
-			dget(dentry);
-		} else
+		if (!error)
+			d_make_persistent(dentry, inode);
+		else
 			iput(inode);
 	}
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
@@ -1493,7 +1491,7 @@ static struct file_system_type hugetlbfs_fs_type = {
 	.name			= "hugetlbfs",
 	.init_fs_context	= hugetlbfs_init_fs_context,
 	.parameters		= hugetlb_fs_parameters,
-	.kill_sb		= kill_litter_super,
+	.kill_sb		= kill_anon_super,
 	.fs_flags               = FS_ALLOW_IDMAP,
 };
 
-- 
2.47.3


