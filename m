Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC658CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 05:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FEAD80116; Tue, 28 Oct 2025 01:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D507800E4; Tue, 28 Oct 2025 01:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EBA980116; Tue, 28 Oct 2025 01:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 01501800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 01:11:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B0231A03E8
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:11:32 +0000 (UTC)
X-FDA: 84046350024.18.A908E26
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id D471620003
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:11:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aezvGRHC;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761628290;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=;
	b=krvDZoBu7q2kUqmMAHJitBpg2IBIjcdudW2fnLS9y+UTJrvSohV93B1tvh5TVmb2IY8drH
	2+HTUNd55y9m83niWo1/Ki3RM4gIMBrhGbJxxfpOPYhWZsfNyocSN8/e0b/awEPv5IfzFT
	ubW/3ZDdvQdYecGaQ40Rk+pOZwsjQO4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=aezvGRHC;
	spf=none (imf03.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761628290; a=rsa-sha256;
	cv=none;
	b=XnhvccWRh9jpJfrj7t+JPKLZr097IC2Ksb5ZiqA1aqVqNYPLcUodbZ8upEc1Y2QOVavqPd
	gYD9C1pT/2Vy4dTW7XUctKkU/Y4EsyTWh01XLBrOhzvdO3Ho/OEtg0nQ3CrA6Dw6ucC16w
	ztDGupLReq6/DilA/XR8bqh39hEhFT0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=; b=aezvGRHCAvghStX3Ot6akRYpUE
	1NYciV5CtxHpLzJAoEByhqUGZCqM2jR9V9yjSv5TtgO478v10dNgSG45eYSF4vEiepoN4lND+f1cp
	xw3HAEKFsvAEXsrc3hs7rvl7cA6u2BsRlakJSCpTDl3WcNXb1vZ6qaNk4ZZ2LXWmHqEGjfpWB5puv
	RLpIbUkW9d/NrEw3RCyXWcw/XhPdPXgCObU59mjLpO6JAiZ466tyzKUwZBn0YeQSggWYHCi+SzqQa
	9FzpN28Wy5jziRDlq1AnNJD0iePGY6o2wVoBpbkOQJAhgTITpW1PqiazuaQmUq3GB8dy/pJ0VmaS4
	Hf4MMDyg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqt-00000001eha-4Bho;
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
Subject: [PATCH v2 43/50] convert hypfs
Date: Tue, 28 Oct 2025 00:46:02 +0000
Message-ID: <20251028004614.393374-44-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D471620003
X-Stat-Signature: b6rw4n3tk7p9e74mr88hd344isdmdkj3
X-Rspam-User: 
X-HE-Tag: 1761628290-989730
X-HE-Meta: U2FsdGVkX1+YLH6Z/UDe4vtRXWZCLv88JatH6DwWd6pzN0jWHjNT6NxeHITLMlmXHY12BnTx8EWrGv0ENeDsnX3frEIN3fR+kSlThJEbL6Ak8LR2P1FG8qO0wqiTQ660deI4r3H2/fkFakWO1U33oETLNzQaZ6dd8UtoLKIuD7A3676/k5vi8QK7gEcHs0pToa9vauXt8Aq2sMt4twJlPU6Eu4bG+mFD+lUFFAWTERNyzQC4jG1unAXhKcPxx6lv5/sn8D1wHX/++7P18QzRFOYEPYSxxdMShlph7BZJTZYojYtCpmRm3wdtdGHoyA7Td8uvkRKORj6ootBYfK1WiNh1ocMtgC57R+Qp0MGZ0ulGnSWAvOwlpU8YLjxRFDQWJhiqM5yINO4NgSPWj//4bcJKX/GXWszzUgyPQ2lg2X4dHM1qkwWrX9IlJO609Zc8avufLqzmKLRO5HMylcblIqewx9ia2GgB/HiisX+zT0DTzEcgCwn5t5vNH3k6SP/YnYDUkZo+k3Ic77PCjS4yadqfeKHeUGjytcjNQoKz8t+H8ci4kqg1s7GPOzNKbZJHEePvB/tmP7qDCy01TH99FMde7vjUa91b6XZ23JRxShkroSGKUywi7NkTmiKEiIjUwVLV9SYqAyQ/BBK1wDJMNdJ71BBPILsNL7qvp9Ynmo2dkkhj5TKbXUnmC7rJs9lYpDJUCzp0kZ8i9cZsZhrZXqdcMKaS2aa1km4IZNEcYfUCDoZLsH0YZBtECyeSpYLPUpTOciMGWd74iGlTugqTBwsNolW7N1h2agNEZxPt2bNUWVlQ7OBXS4LyGSC1rlYR2Ml4KTqlF+CWbHBA6rM+/ATME/2odriYpGOVXGhnI4YMKhWb9V0uSRjjLPxbL+XZUYKO3xA7TZXs+G656W8XTML0P/kOypCFw3bpdDmq8WYBiEyN6skQFTJVwmAPLIy/sJLAW8DQVOKWHCfebIP
 jGrhl/hW
 Fi/iB9rHtWBqgNq1KYgSlmw/S8OvfsumdcR3jL10LOAzhrRZnC/TLZqZAXF1KSJhu+K+eaRKQY+OTeF1XpW8/R+gVXC9KiMOVLyb497fwJXqACCnuqrxOY11RPFV8364FYrKULE1+6nDwELq3tLths/YezRenpORdvX2hSh2J7DhOnjvXsQMDlVTApXq5Q+75Ns/wLK126Hs6AU5ctTJO8jbJI6hg0ejuR/ywEgke8IdNxF2QfHhZ635aAD9QwQdjBCIe6pqdc7FuzR3V/k9iOCz+HfFQ3BY5SKfJ0DjWaNXYd7OHpX/wN9qcwj9fFsGNc/tda8l9Ru80SvzscnCxzqAp77ck65qGSCbfDig2vKAwPHHTdJOCfRHSsCSQcM8Tc0kmPNRJiDLLS+quYhZ0tLOvSFaSzVBQci0Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

just have hypfs_create_file() do the usual simple_start_creating()/
d_make_persistent()/simple_done_creating() and that's it

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/hypfs/inode.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 6a80ab2692be..98952543d593 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -311,7 +311,7 @@ static void hypfs_kill_super(struct super_block *sb)
 	struct hypfs_sb_info *sb_info = sb->s_fs_info;
 
 	hypfs_last_dentry = NULL;
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	kfree(sb_info);
 }
 
@@ -321,17 +321,13 @@ static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
 	struct dentry *dentry;
 	struct inode *inode;
 
-	inode_lock(d_inode(parent));
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry)) {
-		dentry = ERR_PTR(-ENOMEM);
-		goto fail;
-	}
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry))
+		return ERR_PTR(-ENOMEM);
 	inode = hypfs_make_inode(parent->d_sb, mode);
 	if (!inode) {
-		dput(dentry);
-		dentry = ERR_PTR(-ENOMEM);
-		goto fail;
+		simple_done_creating(dentry);
+		return ERR_PTR(-ENOMEM);
 	}
 	if (S_ISREG(mode)) {
 		inode->i_fop = &hypfs_file_ops;
@@ -346,10 +342,9 @@ static struct dentry *hypfs_create_file(struct dentry *parent, const char *name,
 	} else
 		BUG();
 	inode->i_private = data;
-	d_instantiate(dentry, inode);
-fail:
-	inode_unlock(d_inode(parent));
-	return dentry;
+	d_make_persistent(dentry, inode);
+	simple_done_creating(dentry);
+	return dentry;	 // borrowed
 }
 
 struct dentry *hypfs_mkdir(struct dentry *parent, const char *name)
-- 
2.47.3


