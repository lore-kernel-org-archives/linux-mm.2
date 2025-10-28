Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590CBCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:50:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 154FA800EC; Mon, 27 Oct 2025 20:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE4F800E1; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 487AE800D7; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA14800EC
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7A8C12A61E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.25.C1FAE26
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14118C000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=f4JAKTKO;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=ZbmicAGo/Zr2cEAXcde/jSylO7zSpSkym75VdLwNFTne/t8I15nN78FlKUtegUPyquzMh6
	ZaRnTXti0BXqdMan03SkwS0OvVpGSJzuoGWUV3z1rx73ZAuL4aaJePwykmSKGyDrFgves+
	CyL+4h934HAwXt+ECtidFvxIvU2h9eU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=f4JAKTKO;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxn4MG/UuDcxk84tNsHI6sa3Q9kQYypoP2eBG9UjNw0=;
	b=Ss4rUGZHxl/Vdcra8YkqlisKz7gFD//JbOt/ceGKu8/I5rRrqxx1A/kT4Cj5uXcGh1vy7I
	ihCHEpJs5a0YUBJ0TUYaQzNdqyRo0I76rCY0sjmGwfQVlNQi2ZrwqYa3ESLls7Ca6IPF1p
	7KFBROa33uoAujR/WxN05L6ApRfnoTU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wxn4MG/UuDcxk84tNsHI6sa3Q9kQYypoP2eBG9UjNw0=; b=f4JAKTKOyUvAjdLI7hZUAhoUfo
	Umj1X11GLfW5MbBiC38ur+8xzYipcDH16+43VSUxKfs/lHaISaeSkVzRaNpFTfyFUYCY+KdHM7KhI
	vD1SFb1t0huHy5LzNuaYBee+aQ8MI356K8GTabzz8vwPsHYG8ARquVPAV0jwve8cZLy6+IaB33B/a
	vx+dI7d90jzzbg/JvrMvk8K3ehJlOqP7J33X9UucwIFiY8i8I80AxuBEIDHDi4WAk1toaAkb+9/68
	MB4VBC0i7KQg5RZoG7H1S/o1eUUEBvKV8dC1zGT/SYE4rP1NzvzsSmrHwljXjO/LoS0yILwrLxu0O
	+p944aPg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqr-00000001eYS-0CJN;
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
Subject: [PATCH v2 23/50] convert spufs
Date: Tue, 28 Oct 2025 00:45:42 +0000
Message-ID: <20251028004614.393374-24-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 14118C000B
X-Stat-Signature: 4cbifs7tgcjzqb8dem8h36tzrnh4u7yj
X-HE-Tag: 1761612383-89673
X-HE-Meta: U2FsdGVkX1/wlU0RrevnMrSUE3sJ7N1E520jb1esA6pol4oPHOzfONmsRDvwtO3/szcMYZr4Y4R6iUAeJbalrshvzdBGqBRnREyV8ckrUVhNItWUiR+szM/10Gtyu253lUjQH8z/6lLDYOh89Ag3iQP4X3cWQH1zpfHtOlC3Hs9qGa4UVLiQJkrkUdKkLtBhdWXtP1TLcDOku1kq1X8NDsbxuxK3q/XqTSJBukvmsnQNPriGp7ZFiz/g5nXaoSYL3MGOIOfPHtp/YZBHbMQwIAlnlOib0WdTDSXQkvh4bfCua59rw7fQkGo7YS4SqLnR6WkaCxQkrMOKkw4soREYBmnEZaqTAmzq3Zmfan0YdW+c5zz31EZAjKKGX/6B16/0kNy+JQxLKy+7mfofj572VOGTNiYoL9VCUqvp0xS3EmhA0v1MN3pt2NS1Nz2+3mmRB2dYs9FZCicjWkksg8mH5N4GC7rskp4rYkreG/U2AuHmeOBEbulZ3jXxqQmsXMz4l+5FyYHzWumD2lUnZYzw7XFf8rmr+xPVZx/O2FXLKe1xe4dGIPIq6UMD6j5IJzRIbcwxoQWMatYRyAp7PSP2hy9JmcG5CkO02J8tEkRl/N/KbmNZMFAi8/UmUozW/7cAxpeAyxTHZqhqrTeGLchjIVXw85n/VrWyc+fNfaMH0EdFRzZ7pj3cQDsxBBxAoZ1NEGjeNKhZJJkC8RRyW3odAJYIJ6zo5zHdEz/c27bF8tKA1gDLfV5qVkFXuJzbsuh0VzzuLo0UgMVf87LgBtZC06gjPk/fnjMEcmgArcrJO53In4YXYrcdpfN8v0clN/83RNOXhBfd84+w9FES5AAMk34ZXVHd0ScfDb77do/mQA432nuo8g9UugJJN6+KjF8R9G+6p3F1keRA5aLYR8bNkUJzxuJQaDExdInm5qEEM/AEFQ8T7V6weFTINSPsto2VwIG0YBqXACkri26Onr6
 RIBC93BO
 DWnmVEwCdq0ZK8jsZUh/wl7z8Huxm+JTa2ZquSflx2chWGpCwugYDD2vXt8zu3y/iJnAgBkQQi7BY0zs/VRjNwzXJymBVJ6VWJknO5UCr5zU2CM75/umDOYzUISYRq0hpr/4Rx0GMmvDLGUH01L1msgcw9hoCmvbkVedDfA0QRE4gMXsBy+MILPHLxCvh30//wVmgyPQUkDq7OYq0EO46MfHCQkAiwhGmgdirWPW5ioH7xXn8RKG3J0WVZWg4sjvmq3E8fhFQodWu8ZMoCvdgp+FO4PRuNxOYjimprrMDU0vaFLjvt80ufie8vY1/LALGLEEhVqUePPRaF3cEEk5/josKWwhDJMJ8rpsUO6J/7BTrnJaLLESm6rrug0HjJy1yBCYFnEaP4jJ+tjFC1XjIxbCx1vyXcI5SlH2H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

have spufs_new_file() use d_make_persistent() instead of d_add() and
do an uncondition dput() in the caller; the rest is completely
straightforward.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/powerpc/platforms/cell/spufs/inode.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/inode.c b/arch/powerpc/platforms/cell/spufs/inode.c
index 7ec60290abe6..f21f7a76ef0b 100644
--- a/arch/powerpc/platforms/cell/spufs/inode.c
+++ b/arch/powerpc/platforms/cell/spufs/inode.c
@@ -127,7 +127,7 @@ spufs_new_file(struct super_block *sb, struct dentry *dentry,
 	inode->i_fop = fops;
 	inode->i_size = size;
 	inode->i_private = SPUFS_I(inode)->i_ctx = get_spu_context(ctx);
-	d_add(dentry, inode);
+	d_make_persistent(dentry, inode);
 out:
 	return ret;
 }
@@ -163,10 +163,9 @@ static int spufs_fill_dir(struct dentry *dir,
 			return -ENOMEM;
 		ret = spufs_new_file(dir->d_sb, dentry, files->ops,
 					files->mode & mode, files->size, ctx);
-		if (ret) {
-			dput(dentry);
+		dput(dentry);
+		if (ret)
 			return ret;
-		}
 		files++;
 	}
 	return 0;
@@ -241,11 +240,10 @@ spufs_mkdir(struct inode *dir, struct dentry *dentry, unsigned int flags,
 
 	inode_lock(inode);
 
-	dget(dentry);
 	inc_nlink(dir);
 	inc_nlink(inode);
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 
 	if (flags & SPU_CREATE_NOSCHED)
 		ret = spufs_fill_dir(dentry, spufs_dir_nosched_contents,
@@ -479,10 +477,9 @@ spufs_mkgang(struct inode *dir, struct dentry *dentry, umode_t mode)
 	inode->i_op = &simple_dir_inode_operations;
 	inode->i_fop = &simple_dir_operations;
 
-	d_instantiate(dentry, inode);
-	dget(dentry);
 	inc_nlink(dir);
 	inc_nlink(d_inode(dentry));
+	d_make_persistent(dentry, inode);
 	return ret;
 
 out_iput:
@@ -780,7 +777,7 @@ static struct file_system_type spufs_type = {
 	.name = "spufs",
 	.init_fs_context = spufs_init_fs_context,
 	.parameters	= spufs_fs_parameters,
-	.kill_sb = kill_litter_super,
+	.kill_sb = kill_anon_super,
 };
 MODULE_ALIAS_FS("spufs");
 
-- 
2.47.3


