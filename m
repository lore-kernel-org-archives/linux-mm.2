Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4654CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0043B8E0006; Tue, 18 Nov 2025 04:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D148E0002; Tue, 18 Nov 2025 04:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59718E0006; Tue, 18 Nov 2025 04:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D327B8E0002
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:01:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 864524CD34
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:01:34 +0000 (UTC)
X-FDA: 84123134508.09.29C3060
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id C20FA80016
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:01:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=g0mv9RTw;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763456493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIO5z+XlaxOUN+dxGxWKQXIfyt7HKUVO8xN2mehuHOs=;
	b=bGO/H6avVGg4nrGJKB+KLDrhE+IrfzHBI1PAFV28PT/R6YSgVPi6dOXEYGhPAsAbR/alnN
	FPiHbLhDRD6vifDh715Q5g0j9RRMGXsogLcwf5ZqjEZKitjGaoUUk3WV2XORnf5e8hcih7
	VHfU1pamvZAWFeIrXCE7lh2J8zD/ngM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=g0mv9RTw;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763456493; a=rsa-sha256;
	cv=none;
	b=c2ey52u0lSlMc8iDFKfoZcOIlPDYvoTRs0wnJ34JptonoEWthwgzaEbDQUiuIMFKGx0EQZ
	suXn0199oquqi6jcJVF7CHYTmqyvGrxt9pkjEKN76NKc1YMoPjDBNSQ6B/XkV3jpmdTiUy
	HVUnJoJtWndOP+DvDrk2YTXumx+HT+c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aIO5z+XlaxOUN+dxGxWKQXIfyt7HKUVO8xN2mehuHOs=; b=g0mv9RTw6hRIGfNojwuJd8DIlg
	XAxjmgYDdyfJFsN0XD3Jfka9gaG3VCqgvyJYgUHM3pHn4tE2GkDDLVYWsS1+nG2WOjG/E/QYbPbLm
	oS8OrknvRjHCSGPkjGufGgVowrmAwSNv3kKFhKSBFVuQ2yuai9WjpyevBpRLNU+NuzLZB55IDIxj2
	Y3OnvimbyRDK7fSziC0/rbfNELdS8QpJ1dewvrXyb3YNWXwdcSbyOFLAHfhcX7R5nCntGQNYmxIC1
	DSgxk9NtEWBm4phOxWU9BtEC7870tYpDVsa6Dxw7UUorh+9/ptM/tkE3aLCy7yxa6f6pbKa718xMa
	Qs6TyoXQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4Z-0000000GEaZ-1Umn;
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
Subject: [PATCH v4 48/54] convert rpc_pipefs
Date: Tue, 18 Nov 2025 05:15:57 +0000
Message-ID: <20251118051604.3868588-49-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C20FA80016
X-Stat-Signature: 4gwcz1fu54mmj53rbnq8sbpxnqbtij5z
X-Rspam-User: 
X-HE-Tag: 1763456492-72832
X-HE-Meta: U2FsdGVkX1+toekbtpnz+GkxkPcWJYDlPrwALdaoTm8lEihxY5tkshlhyPpmdqdaVqeeMshJxOFSCJkSkxL4ZmkkSgTLlqvdTEJ/4LfVrrrLK20lAyNU+UWmePEogDmw0XWskTxFa+aFBrMxWUtBPqonYkTDpGPevU1MFFqU7UwaiSm+wIjWWgsM6PBac5VxSJYHt+EV8gQN1cdWT4AyFNCuvbqWZZ1yB2qFZ9ZlcvyGbKwoi2RmtEsdiApcLtHZmXWs5yLLS3VvkPYEVrACG+vItJyHlIJXwkKRywBa6VtDx5k8nIwcSIDQ40Lr1dG+DgBieBu0oT6fvCflyIgXNqxSbT4V3hBBPrfvb+pGaIoXAiA6vIcasKdhbvr/ggAwQXjC+CW6RXa6Q5wax0QG9DkYkQHWe3MFRtJDkYwrj6c4WO8wklEzVRxR0TAMIkVbRvwNcKacklXdIWAEXXYCF3b/VDY2bK9k2hCwQ4ITx+DtEAX4M2cixzFUS5hIfiwDEynRjvzOvM1Jo4ffTJ5N0tPku246TzIupvCrbFCyBLhbU0CbBUI2BlE2QyvjA9DCYo5r+J5Ndt1MFL26uEolCzkwBjJS29newkgs46DtCjHQT6dURekTV6q/kZFuj5S+2wL+5Vm3pcQu1DpzUH01TL5wu18fC/0y40veEpNVnPbQjcq5WmtcSgatmt5l1WxSTNHJ/ODWzXjB011ES0EglnwWo7GQUDhQ7ZwIl8HQQZpB6xarEMfo5XaymSfK8H11ZmFy1r1b3Pla1FhWCGQbuGep7pDs5PpFv1/O/Ilfb9kZg0Nxp5gvflQhxhsX11fdRYtUVqX3Q0jrCn191ZJ3jVewqPRn8uS/1w0qQqdBL76ggJRNZ05msvq2IstBPafRIWU4Po8goAaAh2HFMfOILV8O2rdnG5YJtqyYleWOWLx1E7Q90CvBOgD0DHh31YU0KvOTqoSKzjHSKjjZZBT
 2rMiNycW
 jqGJbM6G7/5oM18P4ZWJLPGzmrpIw8dTsSDrRsKiGGPr5NPUle/MqrKeQ1W3dWjNDSM1rG7hLSagVsArmN3ck0ISQkb7eYZBXJARYsFdc6uLqUNtW2tpIEpM1/uRuJpjmiY4SO6irwebe/zQkGp01i6YY6jNzQx+amHTO7HDYNtxL6DTHZKu6ZpofFV/89Y+Mjw+vN7ZQLht80fTeMmMPp2/Xq4mb+Psu45hdlOEb3jeD113xfrq63WTakiNrDRAXGRSiBjiQdxNAqp7W2p68h+Bv6F+u7xsq9pUzElBKi+J9VX4T9gXN8IxM3i9FdtEPeqPATwvda9hrH9Zgg2X7glY5SkxjhbPp+dhJQ/voBp6dBw+MFUf10yaStktNtYgoDZCD8+ShgXDi9i3NRHLogqoGwwi9EiNccG8FcyIK2ntjgFPtSbyDaIumMHqpno1gvWgfQxbgxwWePzErdRQnUcmOlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Just use d_make_persistent() + dput() (and fold the latter into
simple_finish_creating()) and that's it...

NOTE: pipe->dentry is a borrowed reference - it does not contribute
to dentry refcount.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/sunrpc/rpc_pipe.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 0bd1df2ebb47..379daefc4847 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -536,17 +536,16 @@ static int rpc_new_file(struct dentry *parent,
 
 	inode = rpc_get_inode(dir->i_sb, S_IFREG | mode);
 	if (unlikely(!inode)) {
-		dput(dentry);
-		inode_unlock(dir);
+		simple_done_creating(dentry);
 		return -ENOMEM;
 	}
 	inode->i_ino = iunique(dir->i_sb, 100);
 	if (i_fop)
 		inode->i_fop = i_fop;
 	rpc_inode_setowner(inode, private);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 	return 0;
 }
 
@@ -563,18 +562,17 @@ static struct dentry *rpc_new_dir(struct dentry *parent,
 
 	inode = rpc_get_inode(dir->i_sb, S_IFDIR | mode);
 	if (unlikely(!inode)) {
-		dput(dentry);
-		inode_unlock(dir);
+		simple_done_creating(dentry);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	inode->i_ino = iunique(dir->i_sb, 100);
 	inc_nlink(dir);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_mkdir(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 
-	return dentry;
+	return dentry; // borrowed
 }
 
 static int rpc_populate(struct dentry *parent,
@@ -657,8 +655,7 @@ int rpc_mkpipe_dentry(struct dentry *parent, const char *name,
 
 	inode = rpc_get_inode(dir->i_sb, umode);
 	if (unlikely(!inode)) {
-		dput(dentry);
-		inode_unlock(dir);
+		simple_done_creating(dentry);
 		err = -ENOMEM;
 		goto failed;
 	}
@@ -668,10 +665,10 @@ int rpc_mkpipe_dentry(struct dentry *parent, const char *name,
 	rpci->private = private;
 	rpci->pipe = pipe;
 	rpc_inode_setowner(inode, private);
-	d_instantiate(dentry, inode);
-	pipe->dentry = dentry;
+	pipe->dentry = dentry; // borrowed
+	d_make_persistent(dentry, inode);
 	fsnotify_create(dir, dentry);
-	inode_unlock(dir);
+	simple_done_creating(dentry);
 	return 0;
 
 failed:
@@ -1206,7 +1203,7 @@ static void rpc_kill_sb(struct super_block *sb)
 					   sb);
 	mutex_unlock(&sn->pipefs_sb_lock);
 out:
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	put_net(net);
 }
 
-- 
2.47.3


