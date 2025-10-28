Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBACCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 03:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031FA80105; Mon, 27 Oct 2025 23:31:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2467800E4; Mon, 27 Oct 2025 23:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC65480105; Mon, 27 Oct 2025 23:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA271800E4
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 23:31:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6109788168
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:32 +0000 (UTC)
X-FDA: 84046098024.05.8D8A2D1
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id E5A3F40006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 03:31:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=w10996o+;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761622291;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aIO5z+XlaxOUN+dxGxWKQXIfyt7HKUVO8xN2mehuHOs=;
	b=F+MtmM9rnSXVK5sG7PD5htgl7p1uJsWotwIVSb6aERyykUC2Nb3JCuaHX7pGDnWvEWFCbo
	faAp4JRVUFMNIj3MxkCY61fy9t55dUhPcPPM7qrpK6537HfSMdDA+osa+4Uz9Oexs4w1/3
	Jh7YIje45Yx7Kz9pkCCkvg897FTnhEc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=w10996o+;
	spf=none (imf27.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761622291; a=rsa-sha256;
	cv=none;
	b=XOwP3bdc/IK0tDydI0ZWe5Mw/DjIDNpNpKEAhWO8OWsB4SZEIMhmOzmeEMd3wwointzHWH
	RW5jf9SSh/S9noL8+WLLsGJeeagWGTcVIXRYsjwU9oGWi0NMhFwbfsZj/LN5deK+w4OaBa
	DHvc+uB/OCnMPhzhhEmeu4AkWGhqciw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aIO5z+XlaxOUN+dxGxWKQXIfyt7HKUVO8xN2mehuHOs=; b=w10996o+4wBACa8wFc2VJLTe4l
	AE6SJfEeRlDJBYm9lG/BAJ2sno1dzvFxIr+TtSNTtBOWzrsOCuWNgNAkAt0vBEbh1UMQG+wJlVBHQ
	sr8OKStPsOoMhX34Qf9DmIY46eYtxaTPX5hENvuK30W7LXSkmdHMOhCs1ztH4929mgSkNcSTduvmQ
	Ra/dafUsYAby60kk2NLpCI2h5RjB+QHXiUdARFd5c+bM2avsNoSpvSX4Qomh81V30TPn/scJZlW+K
	oeoNBr+ZulzfdrkHMiokpoHrOb3j9iKluVu8L+IDFhPH2OH6bFaWMaGGhse1QPURBnFF6IceB3uY/
	fm9paVBw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqu-00000001ejA-11In;
	Tue, 28 Oct 2025 00:46:20 +0000
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
Subject: [PATCH v2 44/50] convert rpc_pipefs
Date: Tue, 28 Oct 2025 00:46:03 +0000
Message-ID: <20251028004614.393374-45-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E5A3F40006
X-Stat-Signature: ndrz6qtx7iohaqixftqzxuwukhyoyqqp
X-Rspam-User: 
X-HE-Tag: 1761622290-762775
X-HE-Meta: U2FsdGVkX1/5aKbXXmhDoIBDjxQPdEihkcd+jOdxWdzHBjcctjUUQTRdWicuHNdsKJXFrMMTXRO8vC363Fmn74GfebNdMJnJ+TFF0BWyk09roWemLQDL1DpPL48aXEieFPS+72T/mTzavtUQs1VRcv2eMpKa56nFtfZhp/8j3oG89nbgqo5n/7sLnxm7mR9DOFCfKJlEaIw+1IJwye984IIZH17FuOEmH8ZkNSqrLeZqNbjrhjMAUw3hWCo8x+ptG8XAurnif2JUMpyzA5d8IxmJXwjFo4OS+jLvF+eTVb7BH4IfQoomKGOUfAMqMWVCScRSUiA5BUwi4QX3C9Y4PBtsJyBg/BylEPFDo2ub/8z+YB88XY1hg+CtPzUD9PJMdTTOkqRBNdbNGaXRQCQhf4nkZbvpkOIYoYm/dZ2ExrwGxI6c6soCq4LFjkvmpXwHp3/hnu7CzbipkZvUXA5MDSnsqRMmOK2AyPbtEGDPUOJhrfjGI8GJlKxaXghGX3X6Yjg4+hlWs5iNHeb4XXngIAsrzUN+EhrkSEU1oeWmpaGDEWC/XVLArRiaGSfCGtTjWNVYTgS11oH4tuZfkEt03+g50qzOnLg0EL1EDKgfnPge0f3QsnAKIQKudEdaXSFBftUEDc4Q8SS02s7Du4od+LW7bj3FbPG6MUbpfICAd46RdEoXs9S8du2ymViAhIx3Ejme6d61aKIpYhE3dfMvJwsiwBCgN+jeHsPA3CBBpZFIVOk08+EnkvUUG8Xyd+eoLQgYixuvy2hnrGbB3pCgVlZINrJlxIiGLPcCvGTWMK3MdHKHzsvLNxtsB1FoaMdt1JjzG8VRZr1qF88bOQsDK5hoZu17IiV0oaRuV8ipmkTLle69GcOv2tP1iUBMmZUsISXRguUZ2O9W34+qq6k2Bc4pqfCiQzgxx9AbqydwYMH2clnjcZNfH0OuGkxIrloKeF9B6DommeZHvjTUi2+
 vhCUfjrn
 zWnw3gJ0RqLCAMhz4hXI1pmX6Ks1xhzV+UigkPymoc6V07Cz9fSIG8Y10g4AR6NW89m85ZV4mtjc2TDL4ATbSTD9VNFvZltLVDGTDyMF3Jinky0R7YakxAPt2uGj3ACsrWMCV5Fg8PAFsWbYnv9Yg/XnMJjtu7F6B2nge
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


