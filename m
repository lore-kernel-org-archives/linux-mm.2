Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B04CED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4A28E0015; Tue, 18 Nov 2025 01:21:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5928E0005; Tue, 18 Nov 2025 01:21:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26DE78E0015; Tue, 18 Nov 2025 01:21:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 142508E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:21:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6953C039F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:35 +0000 (UTC)
X-FDA: 84122731350.14.F59AD17
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 244561C0004
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:21:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HKkg+A6i;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446894; a=rsa-sha256;
	cv=none;
	b=mY7ShrVSjEKxBhe9SbjEIhCqIGNidpOSUVs863pl8gKDrRi1gK/AXlQxOOLIx5h0JFBnhE
	RPhReAOxUY74Z3w3W3EQFoUxcvaaAO7uxDkeddvv7enhMjkLhw3oiM+P5y1p0+Z4z/1IZY
	i1dOOq3wOV7wp3/F9K0SRpts78mPvMQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HKkg+A6i;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446894;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iatHkZ5szHUbSV6QRCjJzQR1r0SBUitYfnCBfKmo74w=;
	b=xVqywccuOLG3g1RI9jyio3z11zT3YDYEo7aRurC+9blE+krgMDrQ+1eX/05dIahxdlehtI
	YyTIKiuT2VVTrI8qcEGTCoYXK7xzH3+O4/zyXn206VUzMw9VhBpb3neqlKeVr7QWNlG4Dk
	1pdWWGV8jgK8Ch85hEo38ofo7mX3v4M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=iatHkZ5szHUbSV6QRCjJzQR1r0SBUitYfnCBfKmo74w=; b=HKkg+A6iw446C1m+bFq5Rf4+zr
	WtzxBAxyNorJmfhyRzyCutjKbpfkUzb6VIIyZ8TGu3Pv492wCgVw6ATyFzN71gfh3aqxSmOywa+XX
	hXtWrNHEkFK2PL9+dRu7Z8frLeV186SMrTIwduMMNxQZA9WWgu1Xbuyqc4rH/zZ81ikczrbh/IxW2
	l/WWnVRxQ8RLKxM4KmzKbRVt4W4vhEj97gnK9cNxyXq1SbFlL+YtfCYjF6ajQqNa5BbTGC4R+ah0y
	xsxXQFz05BzncgXE23HUlDxD4flK2OxwCSKMJomxPUGuCy8x6RtOchSX9D93+FkOLWlu2GhngN0ZD
	53y4+dEQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4X-0000000GETl-1pH7;
	Tue, 18 Nov 2025 05:16:09 +0000
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
Subject: [PATCH v4 41/54] convert functionfs
Date: Tue, 18 Nov 2025 05:15:50 +0000
Message-ID: <20251118051604.3868588-42-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 244561C0004
X-Stat-Signature: bqq1xw7mk63su5uee5bu5xcg34ncjmai
X-HE-Tag: 1763446893-263567
X-HE-Meta: U2FsdGVkX1/nuMp30C4hHdFmh+7BfhyvKVdmBRoHJI7M7SKLjawPxTmTGGeQ8zPf2nUxbRUVPMlqxY2mbOBRUJ6g/K4cvoiTpOqA1giBhC6nN5WniTwIMzbVUnRILNGa3O908bCjslgyOQctjzTG2dfwP/cTfTyWXkmJRgRYLT8HvH560P9Ut7d1UERtQCc8PWXy2mq03PTmgBW9V4jgX7WNsOrrMrZURW2DU5TRonTJSIkId7VFrDUgUNiSxA+A998UMynj0UEoNP4tSsparc1D4FEkLsvGqVmHGonb94qkaUsO7H9G3m+ljQiIWj8mu8zS0vG0M1XArE1ZdMZLpNrmcuT/HBBsRUy86JEIdaonFu+jSGiRlkSvcyMicHsN/2l5D54CIxPYxrW7UYGuY/ucfLESR2WhqqyULJZOIl8l635CZgeKriv3A3M5zLBMqJgZSYGA/jTe40renehqRRZVVOpHSc/n0kj58IaAeMupez+malOOnwfs5JxdQXbMiXJqL3NO1Kt63m6by/uzqjwrkNVdHZcqAfyP0eyvdRMom7u44kJR2le0RlaACDd3AnXR+s3g/sRg6Oy3R1vLgtzwqrEuJhRRDP+9NUNzm3LE57SJJEZsPxLGLK8YslF/mOFlCeiBl/4lu/4+Sx6aRPYcO489UVwFFwPhpJVUSj9/mKy4OlP1XGNO1Yw/K9D/iI/l3j+vXFrTUYCrrt0BORZDW8cfqJO4thlqE9Tv6YogFcO9729vSZRsxt43Yh5jJuu2WVNKIz+tFK1XtKtRSfvJrE5rP2N5wcMh6rNq4kd9UkOH+8IwOXbN9p36WrFfC9Nry+ZCsI3c83bkYC1c2rkKD7ln5mxSlX6eLqWMj33+0ZYYV/e4IGXsvyo52vdR52nrinxhXpJA8/xUN0nXqU07P1vR79uo9lQ9J8dA+Kb06yV7mCpz8Q71OpbWZN4MzWlqZGeDU7zNQfJ4CfH
 2QKYh1es
 5C9KiMblGkohL51a1o/uk4a5GY14TcLUwG9xQhrJEJSznnilOY6Jfk/S9SFgbiCvR3f94PxAHVXpwUwi0cngdJHrKOLlv0EBxAGUdDnE9FFtgEhyZoBC+ZTJ9OJl+2CGTe5a92Rcl7P8vDcgISEITPcUhVsvoDcNsZE+cW3cJLij8Uzl5uAoQdkmV/a047CLMMLPVKotw5uFx0KwrelB3uu7jbuwhJIv/t41mwIYVRLWqLGMxq1TUBHx8r802Fl4by6fHuGd+kbGQIFdvNNzJCzl0NSCBLAKSqeN9aYgZXaIGpadMSNJmjp9uS8ZlviWH+QRZ0tU9OWRducW41Tjl7cXKf5qDJ1E8gTIRjadfKWALNDsHLj+8+LfVpCF0ofJPs14hO/aPGX8eRdwWyWHPsCLY6RaSaHyyb6gn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All files are regular; ep0 is there all along, other ep* may appear
and go away during the filesystem lifetime; all of those are guaranteed
to be gone by the time we umount it.

Object creation is in ffs_sb_create_file(), removals - at ->kill_sb()
time (for ep0) or by simple_remove_by_name() from ffs_epfiles_destroy()
(for the rest of them).

Switch ffs_sb_create_file() to simple_start_creating()/d_make_persistent()/
simple_done_creating() and that's it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/function/f_fs.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 40868ceb765c..4bf61017b42d 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1899,17 +1899,18 @@ static int ffs_sb_create_file(struct super_block *sb, const char *name,
 	struct dentry	*dentry;
 	struct inode	*inode;
 
-	dentry = d_alloc_name(sb->s_root, name);
-	if (!dentry)
-		return -ENOMEM;
-
 	inode = ffs_sb_make_inode(sb, data, fops, NULL, &ffs->file_perms);
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		return -ENOMEM;
+	dentry = simple_start_creating(sb->s_root, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		return PTR_ERR(dentry);
 	}
 
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
+
+	simple_done_creating(dentry);
 	return 0;
 }
 
@@ -2098,7 +2099,7 @@ static void ffs_data_reset(struct ffs_data *ffs);
 static void
 ffs_fs_kill_sb(struct super_block *sb)
 {
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	if (sb->s_fs_info) {
 		struct ffs_data *ffs = sb->s_fs_info;
 		ffs->state = FFS_CLOSING;
-- 
2.47.3


