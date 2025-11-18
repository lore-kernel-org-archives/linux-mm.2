Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 597B9CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76038E0005; Tue, 18 Nov 2025 00:42:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9623B6B000A; Tue, 18 Nov 2025 00:42:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831456B0006; Tue, 18 Nov 2025 00:42:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69AD96B0006
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:42:45 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2561612E904
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:42:45 +0000 (UTC)
X-FDA: 84122633490.28.811F9EE
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf23.hostedemail.com (Postfix) with ESMTP id 83500140003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:42:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nbw2hpBO;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763444563; a=rsa-sha256;
	cv=none;
	b=RCAZP672fAG1gzFAAA9qCvppeiWq11L9tBpjCi2TcecaFeRHCM0dDuDsoEkJlpbBXyNuIo
	PT1iOsanUPOIfLQmzVLylkhhsZgQ8P3fz411LseMaA1sTmeAlD71bvtdHrhwwbJmwEn9fl
	RmtAg4Uwzcy5x0Zjzc3IMPXzScxpepg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nbw2hpBO;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf23.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763444563;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QE5WDCT/6E4/9SENMzbAx4/TtK/VNDZoQCVo0AmPFA=;
	b=3MyG3mn4aen8NDd1uYp2q69mddB6zjtLbsT7c+FqBZf3UkYyjUHhJaHlwaZH6XUufgLK1C
	WrJz7nH5bKbaa3LXdRh7E3hWge3FII3wa5IrPm0cV0VYfum479DvtzTFURT6RWJVHTmN1p
	OBNVymqsLdeFUWI7xrYgisOxTwp/5g4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/QE5WDCT/6E4/9SENMzbAx4/TtK/VNDZoQCVo0AmPFA=; b=nbw2hpBO5FUjslRgDpDLHuqSys
	mMp4OF+mLp80JjLP4RwNZxq3tU3uTXK6B7LZOCt12xwnyqibPJY69Qk8Fi9+pab8XCpSvSaN3GBST
	+Njl70OepWLfTkhLZMDAPXxD9ZK5UDhJsIvan2d21SnGbI+fJItPz6jcIfY1xAllTGpgEo83t3zGL
	qTrHMAp1QgyGZdN7VOcfRHEVPZFiwJ5pYnGouUH9gUQo0P78a9sAOmDAHFHMW/chnqo4+WtCcdi1/
	u60C5n85obiT/jGBVsA+k2QUfMjjIbr31iJXh5l/ldtJAEvErtLsCRtJAZs4HirNXI/+hx/Vl3Ug3
	WQmPo/tw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4a-0000000GEgh-38hT;
	Tue, 18 Nov 2025 05:16:12 +0000
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
Subject: [PATCH v4 52/54] convert securityfs
Date: Tue, 18 Nov 2025 05:16:01 +0000
Message-ID: <20251118051604.3868588-53-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 83500140003
X-Rspamd-Server: rspam07
X-Stat-Signature: qwmse6wx5o5jddmmrd9tjn6byijnmfi3
X-Rspam-User: 
X-HE-Tag: 1763444563-823960
X-HE-Meta: U2FsdGVkX1+fR7JXJOHibClR4gXpc1vizw4P3wliDpuAYvmF62vpBsKd9plpkkM3pNGw07E5H1xuhfc097JSPphlUvP+vAncwb4CXzxIHe9xCmlRRM+UWgIVvqMJPh1P8+9GOToLwUEUJaYLTPcjVsy4J7Jd6Ca/buPUghfKlQpN02gqhfcj3DdOATUdCV2QXpznIywEdsF/4uGJF6+N6La9AH1em7nig1BPIf6K0z0mVg+aUOLOCCqKIDTY6/HT4ofo02k57daEljjtcZ1DDelwiV5O7AVRlY9o977vv4ZSdSS37XTZVqavUWP6hfQlC1WKnNcmBdxeBozVhPysIDWL6KzeXOuchXp54r48PSygvGgrwM0hBPI6qJB6B89QYQNxbtF4TomEU0O9tPS17dq5P2VuMMUuq8MN5nk7rlqvGN/mRHCPRH97knd9vZw0z7mMW20XpVcnjkUgPef+9FeJyF93jx/yZH/oyNehlUBdwMAlnu+E8GD/bTVLL3RUtH8UwL4BABX9rK2Bdk5eQALMyCfrKKiDg+e2M9rYdcYFmRdRM9Y7BAB8M4LyAA7q7vRCynJgt0OokZ926JtZthY27a9WqNs9vs2/8tsvdvhVNiERVnbN0rS9abBriz2AIjIupw1QjEbZ+cuTeEfzxMTuFUyIxO+duDIFUZhZKX8VMZCcKu4rZI46Be2jYLQ2qx+nmemchiPFtx7WWaRjJBYj7fU3Ms5DQuhDHARFOkefXlXwHJi/nfgtw2XjP7owj+4qxf53SQGYFMvr1mhJ0QwOUIh8GOB/2mQcZ8/KkcA4E8oWqDpe4bVSdUfG71/6Z3wou9vVhJEulDi2MIEz3Pm1fbrje8eV+4I/umILyDHOILJJwmQoNR02sP9N1WP1YskGZMb/m/YPYB/y8NssC2HHHwHL31CuYMtXfny+uQW145mubg0SOd9WrSAqU9Xsclq2du9y6b2lFifkhnP
 iqcDSpol
 hmKCyMhyUiTWxJ4hsDisX9ovpB2ogcg331sc1hpGtGCMTQ7WznTT24Or+3IUo5kINAhxz7HvbHMCUcX2rmeDkGWhua0C7GWjeKlMLxeLarSImx0fHpSK2mvnw5INe+puuccLtp/ZYkaMana4CrgKcTF9tjbLxOzJ8idhB+MzBP+SxeVvNQ5H6oRnKcd7xGxY5EaVOacSa3Qo5moEKyFgC4PjjYO/g+dfMClRXEdtv696MWR3bULQNFdVckjZE61JTNNvboiiZvVI6zF29JvsWxsa+OgQY40KG7XbgW7ACucZuFO/EblNomIDU20kcPV7FzzWoBDPoBZFEvTtu1+nk3QGfltheNLWClgy71ELvsbc9MKDmObd06MxWRqXjvVHu+T1AFUBZnAPNrF9D+cWVK2tyaeVT2sEhOAhBrrYT+VDWQOkKu6hHcj4CASSmMTShQKwvxNDcvx7u1vly68oOEm1WNnl4XIhrYeHB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

securityfs uses simple_recursive_removal(), but does not bother to mark
dentries persistent.  This is the only place where it still happens; get
rid of that irregularity.

* use simple_{start,done}_creating() and d_make_persitent(); kill_litter_super()
use was already gone, since we empty the filesystem instance before it gets
shut down.

Acked-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 security/inode.c | 33 ++++++++++++---------------------
 1 file changed, 12 insertions(+), 21 deletions(-)

diff --git a/security/inode.c b/security/inode.c
index bf7b5e2e6955..73df5db7f831 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -127,24 +127,19 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 		parent = mount->mnt_root;
 	}
 
-	dir = d_inode(parent);
-
-	inode_lock(dir);
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry))
+	inode = new_inode(parent->d_sb);
+	if (unlikely(!inode)) {
+		dentry = ERR_PTR(-ENOMEM);
 		goto out;
-
-	if (d_really_is_positive(dentry)) {
-		error = -EEXIST;
-		goto out1;
 	}
 
-	inode = new_inode(dir->i_sb);
-	if (!inode) {
-		error = -ENOMEM;
-		goto out1;
-	}
+	dir = d_inode(parent);
 
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		goto out;
+	}
 	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	simple_inode_init_ts(inode);
@@ -160,15 +155,11 @@ static struct dentry *securityfs_create_dentry(const char *name, umode_t mode,
 	} else {
 		inode->i_fop = fops;
 	}
-	d_instantiate(dentry, inode);
-	inode_unlock(dir);
-	return dentry;
+	d_make_persistent(dentry, inode);
+	simple_done_creating(dentry);
+	return dentry; // borrowed
 
-out1:
-	dput(dentry);
-	dentry = ERR_PTR(error);
 out:
-	inode_unlock(dir);
 	if (pinned)
 		simple_release_fs(&mount, &mount_count);
 	return dentry;
-- 
2.47.3


