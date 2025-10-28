Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8B62CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:49:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57416800EF; Mon, 27 Oct 2025 20:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C278A800E4; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F462800E9; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 74752800EF
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D376C02BD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:26 +0000 (UTC)
X-FDA: 84045681972.28.DEF415D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id CFE37140004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=v6jWSJiq;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN/33ifYl1WumRWtJ01j5wECnyYUZIw+8lYgHF3pdkY=;
	b=ZxPwL7xXCCymeFgIy3CiBeSnV9SucKDgI3Z68hakDEHRBy32JOe3/BAK0ldGPrKsLdIQIi
	bcXVJoWt9LKYgEbs0bLEXE++sJzlaGxjLVazidrgCYBmD9WjeUGi/e3Qa5/9kM3mkgSBBL
	N0Ka4+KHfoy35NQFHO1TrkXNNgEvQ8w=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=v6jWSJiq;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=TlPd7C85VerAMAiYPsEe7VBJJEt+VPtOAkO0FRFH4cgU7TPj9qk6S4cdkhxXGfQbtT5F35
	4WZITIBm03Aqvs8psOXS/qLbcX6VMda7/hPgXxbcZ3fCr+S2N5LcsRFVdwqhha7IsooXG0
	Og1KBB8SFyPI0QzYQDaVV4wvttuHKII=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NN/33ifYl1WumRWtJ01j5wECnyYUZIw+8lYgHF3pdkY=; b=v6jWSJiqb9fbWS7IvwWDHA9cMT
	beAXKgY3mYkmJ9R/Yfd2zbK6OnGvRVpEdXZXMc5poQhne20tISSL6b62YeKtuoMd5qVJ2bx0HpH77
	rsL/dEX7pxpoTWZ+cdhTZiv7pZVgdjM5+RsvktFGCFW/mpmSmziRlL9qAEqEku2aQNXzGQ775AMhY
	Z8YameiFR+Ci0RZNgb4fEn8/sZSdXhuEjtuiZQUpCKqJNjbQtNdQ/ejrYfh7vLoUkMs8wIRx2nFNu
	Nx/HjWzJJnzW5eJ6siXJ8N5umjkl0ALbIpi1DX+rtNKvt1EbRYDUsgjuWLya4P5Pp8OLqkVWGfjT7
	H5Gbeoqg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqv-00000001enR-0ZXY;
	Tue, 28 Oct 2025 00:46:21 +0000
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
Subject: [PATCH v2 45/50] convert nfsctl
Date: Tue, 28 Oct 2025 00:46:04 +0000
Message-ID: <20251028004614.393374-46-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CFE37140004
X-Stat-Signature: rf5wkexkecqib75w6xe1t5tx4yarbief
X-Rspam-User: 
X-HE-Tag: 1761612384-73805
X-HE-Meta: U2FsdGVkX1+JsocppuBr1LTB6Z0/qzq1CGjHxHWcT7sZklfbXw8dpTKvHyKKPjXuCY1VbhahJUzXTPKtaepT/pFP8FRacJ9IK/jgGn6+8NytXGODv8Drv1hf+e/dhJTVMeoun9dzTCu6tPuwvLUAA/dcHV8fAxo+t9yNf5Umajk8lbfAfMzV4uQD9df31spAb+zZwbUbhvum4S/VB3b0GvLqRcUr4BYymY7fuh82BozQ0yctp0UKY6rOgEZo2JFmIuZs1kdIkcwb3RPCsfK7VJWxZYb2it7xhOwoMouxK8zx3+1sciwnaT/vsFL7kyVyNKn4vkSfjxFVK0ehB9m4dSqjW9QfA7KAx5pKnS8j+ppCOXZIl0rE7JheosAMJB442aNF22dn1bu4m890cWE1n3nxKID3h4J6G5sH2ZJKPJigtBBp8veNahppWV1ukDhU6+lBSQG+yAqz//H/02Y21sdFHQYDAFLp9nmcLfru9xssNGH82OUZKAjubg3+v0sijDzrHzkVwEO+Sq/KH9W7XMXrsYRETotasm0ssJJTm8Wo74/lB+b7TRv8Rm+eY62EaJDy1U1i3BB+yc+QTxXYH+zRMjFbTNz5v/UakEYAMWwVtlMADq2CpnC+wXN6rmcw7qtjoej+UlMWSmUqruuvKWobekrUD4Kj2gS/4Wp66hb+coxlaDFBxb2cpyt0wH5HH3vZyBTaVfk9t/i4vsIbPh7sFjRyCjf4P4FGjiG9pRdAYeFAIuEt62BM2sE5VL5kiWNyVAYitqscrHPVUK+iZJmFSAfol5l3b01Z35IUCle/A5AWaxy/5BugsHd6bjS2buEJeLaOjflLZYgjqDgRk/G/DYAK/i0CcoOXFwYK9Rt4LVliCToPu7bc0DxZhAp8AR7KLeV3aWAY3EQ/TdVFQGa4Yn5HB/4hEvlq1jGf7WybW0pPihTeqt8AwUw3btwNHJbyEDWjjETzKuSgH2a
 zcmbIfbe
 DVgFS4N6NJHRWCTz413YgVb6feImC9TTv5ZM1H73KQw4NNaDauwdprZvdPNNqic4o5BMWkGJn3oFAPvs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One instance per net-ns.  There's a fixed subset (several files in root,
an optional symlink in root + initially empty /clients/) + per-client
subdirectory in /clients/.  Clients can appear only after the filesystem
is there and they are all gone before it gets through ->kill_sb().

Fixed subset created in fill_super(), regular files by simple_fill_super(),
then a subdirectory and a symlink - manually.  It is removed by
kill_litter_super().

Per-client subdirectories are created by nfsd_client_mkdir() (populated
with client-supplied list of files in them).  Removed by nfsd_client_rmdir(),
which is simple_recursive_removal().

All dentries except for the ones from simple_fill_super() come from
	* nfsd_mkdir() (subdirectory, dentry from simple_start_creating()).
	  Called from fill_super() (creates initially empty /clients)
	  and from nfsd_client_mkdir (creates a per-client subdirectory
	  in /clients).
	* _nfsd_symlink() (symlink, dentry from simple_start_creating()), called
	  from fill_super().
	* nfsdfs_create_files() (regulars, dentry from simple_start_creating()),
	  called only from nfsd_client_mkdir().

Turn d_instatiate() + inode_unlock() into d_make_persistent() + simple_done_creating()
in nfsd_mkdir(), _nfsd_symlink() and nfsdfs_create_files() and we are done.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/nfsd/nfsctl.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 2b79129703d5..5ce9a49e76ba 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1137,11 +1137,11 @@ static struct dentry *nfsd_mkdir(struct dentry *parent, struct nfsdfs_client *nc
 		inode->i_private = ncl;
 		kref_get(&ncl->cl_ref);
 	}
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(dir);
 	fsnotify_mkdir(dir, dentry);
-	inode_unlock(dir);
-	return dentry;
+	simple_done_creating(dentry);
+	return dentry;	// borrowed
 }
 
 #if IS_ENABLED(CONFIG_SUNRPC_GSS)
@@ -1170,9 +1170,9 @@ static void _nfsd_symlink(struct dentry *parent, const char *name,
 	inode->i_link = (char *)content;
 	inode->i_size = strlen(content);
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 }
 #else
 static inline void _nfsd_symlink(struct dentry *parent, const char *name,
@@ -1228,11 +1228,11 @@ static int nfsdfs_create_files(struct dentry *root,
 		kref_get(&ncl->cl_ref);
 		inode->i_fop = files->ops;
 		inode->i_private = ncl;
-		d_instantiate(dentry, inode);
+		d_make_persistent(dentry, inode);
 		fsnotify_create(dir, dentry);
 		if (fdentries)
-			fdentries[i] = dentry;
-		inode_unlock(dir);
+			fdentries[i] = dentry; // borrowed
+		simple_done_creating(dentry);
 	}
 	return 0;
 }
@@ -1346,7 +1346,7 @@ static void nfsd_umount(struct super_block *sb)
 
 	nfsd_shutdown_threads(net);
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	put_net(net);
 }
 
-- 
2.47.3


