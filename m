Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E34CACCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314E48E0009; Tue, 18 Nov 2025 02:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29DC08E0005; Tue, 18 Nov 2025 02:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 165F78E0009; Tue, 18 Nov 2025 02:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 004768E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:01:32 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8C6C61403EB
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:01:32 +0000 (UTC)
X-FDA: 84122832024.07.BE03DB2
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5EA414001B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:01:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Swn8OWC9;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763449290;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN/33ifYl1WumRWtJ01j5wECnyYUZIw+8lYgHF3pdkY=;
	b=BGg8ghpqKdyHsNUXDOk28YuuXm72qCXLPO01pjIWKg48gYvINIRXYD8F7ItZOF1ZRcF3w/
	7b1XVsiyA41J6CY9RA3fLCy6TJNpIWGzZfJCH8Bb1H244ww+cPf26rGAx161kjnF+rJG4t
	/+7HP6IhnuhbmL3BHe7kM7tk0W9e0dI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Swn8OWC9;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763449290; a=rsa-sha256;
	cv=none;
	b=uo2gqxvtW23E1J6kzY9kRte27VP8eW6GQuxAXzTYwbEKLbRJhw4JGnsXdW/IoktGbZACI0
	uZ8jknqX5vtjTkSOnM+f8uSyCqcSg3viwKWk1GyQZqhOfZSBxmUYCgGVMLoOEFqmDsPdYW
	SONN063jTLAa0LB4P0cZX8UmQFs8eA8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NN/33ifYl1WumRWtJ01j5wECnyYUZIw+8lYgHF3pdkY=; b=Swn8OWC9emGgXeb+svd6xyIRtH
	O8+0bfGk7vkeVTnmYyKKioAH2dKMhnaFqOOdCZhfH7DTDKCUSFYkaejYy7x5Ny81bWQhjdQklMl7S
	Kd0VDr5NDP9eF1J4N8xntap3OHNW7LYMKQSxUanm+oLz2/1oJDnE6dgRVdmQLOR5vLoRgU8+aY8O1
	+aFljvFS4ROnasgOFbo/ITPdAlXRonmWAtPelnYbpVkk7vcidV3IaRtWRy+plvzUZekKUcxqbxUCM
	z/GnEDfM/zcm9STlAGaLt6i8N1wM/qw5FGnC6drFm7BAttYg7nCeiSYYhZseGYxd1llCsSW+9Jwv8
	PU9hcoXw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4Z-0000000GEch-2tzA;
	Tue, 18 Nov 2025 05:16:11 +0000
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
Subject: [PATCH v4 49/54] convert nfsctl
Date: Tue, 18 Nov 2025 05:15:58 +0000
Message-ID: <20251118051604.3868588-50-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D5EA414001B
X-Stat-Signature: i7nkehkd7e9im95qmai3dswb6r4j5pui
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763449290-401885
X-HE-Meta: U2FsdGVkX19l7WSLCZSHyVu9ivXM8oHY+fGmDrAJVfyqzEula4yi5r5rU87Wt6LzgJpDfko0JmQdwZwObXa0mD2705/S59afFy8tDP3Y5DQVThAKTgqZmgGBqnvx4p0Atjhv1tp1p44dviMTWHWltA/TVlfz0rcbTh++mLB+1xVdolsyLJVz7nhxHZrzn8DGVGVXwihxaCAsRA/fz/9oWYkSDQfq+45m2Eag0UjfCr41Epq5nlDRWWlcEn5rEeSB786Nd/E3L3OJO1xTqZ7uoeSBM6kBY7lmvUvsfwuZBvI1e6sj/quJybfewPr+uzn5MpTUgIbpuko82qEFVLTY+cV1FQBZ8ePc0Yv9eDyGCI6+q5t3J/UzNQ3I29vGopXvufAnVOzldSgxhqVupFqOZXxPO5ptQH3UAvrjrqE0UE29DZNak7mPN6e3kmBLo1Cu+EHB5EE38pGHw94UqVFYu6+HuC8hrbAeLFqVUMxJIdYTDcDi/ZaZCNqTC4sGJHYfVhV/UcNOhg0jjbZwOPtegNS4p+POzlF41KZ/qAaNShVn+uk9hFbQdU15eC4e3A55sSHvDTi/yDnzGcFI18P0hhMoApEyhteVzKfjQTpOuWJ+dgVpJjPLjLLPGCMT3p8728e1Jo/LMku9RHKn6cO2cbTWf1kMyRg7GGYTb8EfbtHESOQRZw5jF2txJnHvFcQcXen4THSy+vktCRD8jqpslbX7crAbtd1Lex+yqzjgBDTfZss4QQF5Kqv412V3Th+RKMwn8SjpxeOZR/el5oUGxl0viDPC4CPVtP1QbsAKacDqDH3rzrbCxGF3N2neLSlQltVwF9Ru8Y05g4fy454OC0KPxdqDPdOWGtDaFtH9q804A0KBZ6r8J+qweKLuogWBSPBiFHPkstPuddN96R3k0rboAVHfcVNmPaID1wA+DPHvawywtXhmzZ35mDkkxhwAUFT+vLqfERUdGtuvMfn
 uS7bSrA3
 lXFkFOMkFK0ZNkz5O/A/qAHOk9sRTIhuGBa1CkFdvc/qdAGUEVXHi+IZdPxTV9bARC8T48FvC0qTa3NJNp6q7J9xhfW6qFff7Nnyo8Rd0NVlr8nKGmrHig+Mf/5lOdnJEz2b3bYc0CNwW6HiPQNbvxkNLwlgehWWRUCeyPHvYk6MotH5S//k5Oc+WEUR6Pbw4/HtpLPNYJ2IAhdQUFIQQOKVB4Cu0xiccS+E4rDhevzHdXxEqopf6GTPpux8uVvvwCyIlSN0ZMSvWauAq4midsonbI9ewrkwUZTJklJOL7gRFq/pdhPaY7T1yVfA5ldhYPh4KWMyxm3nhwXC6QYsd548X+IFolF1zLKZhDguWRIhUKRrz3DFOXi+E6lnRxAt3q8PTYoFL4wNgm/R0ioC8lFtJkyHizCWjKbxQ
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


