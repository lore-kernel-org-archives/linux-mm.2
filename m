Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EA45CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460F28010D; Tue, 28 Oct 2025 00:11:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 410EA800E4; Tue, 28 Oct 2025 00:11:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFDA8010D; Tue, 28 Oct 2025 00:11:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 199F2800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:11:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF2B6B891E
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:11:32 +0000 (UTC)
X-FDA: 84046198824.24.63BD4CF
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 14BDE80004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:11:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=dpmtniKg;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761624691;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OHt/Ew+g7B0pNZwOTBE8VBfCIPUfQxC19aVy8itf040=;
	b=JcdrBT32sV6PoVGMDPkfjOD0DslvqEqjedSeyo7dTOjQOcmAgwvHk0gMram8bgi/a7pdwe
	ymmoJO6lV9GW5LmA0oBkNels3gZt13GdpqLMBMJZlLtuOCGM7RROqI7A2121c9rOnFoGrW
	xQ9b4gahY3D/W1Q5D8ajc0qW77hiHeA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761624691; a=rsa-sha256;
	cv=none;
	b=ej68XtJCwBkQ5e2+LZ3DV1Osh3jfI/pgZIL/c4JxpEJgGuAr0m+GJJOoce67qclMx4RYUE
	WlHgaSWDGjqF2UglQOvtQ8C83cZ+F9spAjSozKSFxe1pouU8kJbQiGmy5GSy6vXYj1R+MO
	yDjA6XkWRLCxfar7gMG3M2jXQkeYFxA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=dpmtniKg;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OHt/Ew+g7B0pNZwOTBE8VBfCIPUfQxC19aVy8itf040=; b=dpmtniKgbg5gFqW2xm5+8kdYGJ
	hTEUxg2eRsoiSPIsC4/0/rf1gDnlubESIhlcx13vBoDnu9rk18uA8acv8bEkrsjKUUFm3h3rlpa1A
	fTf+rUS4AP/pzxQuw/nOBIEbP+sTz48lVgnHMf4+zcH8Er6FOrTD70RAkRvxDK2bYKPrzx7Dvmx6f
	EpEQEUKgw/qfWaAKtwjDUYmFOmwj2AFDVB8T4bmUhLFubUeMBhThmgssVXjpFRvReFgAFl54RPJy+
	6mv9CO2WjdrWQnKlDQh2qJmgQ0RF5kUsXnl3Ph4AvSk7srnGMPqRtdr7EXfmJSzPNcx5aa2cqmspm
	/qMvmccA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqq-00000001eY8-39u1;
	Tue, 28 Oct 2025 00:46:16 +0000
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
Subject: [PATCH v2 20/50] convert debugfs
Date: Tue, 28 Oct 2025 00:45:39 +0000
Message-ID: <20251028004614.393374-21-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: dx6ht3tuinh3iunc61p96d6s4p6i66sr
X-Rspam-User: 
X-Rspamd-Queue-Id: 14BDE80004
X-HE-Tag: 1761624690-206956
X-HE-Meta: U2FsdGVkX1+GuGycRIVNZlT6C4NO0lxLu9Ha9UopdkvmjwIMShJaIo+I3//1o7iMTE6WwtQD7SooUFm325OtrxaQ/oHG+xj+0qAu1gxBld8BNJHyalCJ+EZq7UgoXcaeXRwfH7Yfe3aZRlrPVOHC8IM7501xcaw/8nRn+NcpvqSs8J164aXs7C1F8KzjXgo2yU4YwyLzCOTiw/oDEdFE4yAydpDe+CUAThUuX529lCIJg1d3xsjg2pp0YAwUq7QQZRz1E6eLKJ5FYjziTfjl4jHpVl9PhnU1A0hoFrQJ2kzJZsRAhcLr0gBNPtB0uQTkshmdJVoyxkg4OauZ0X4FTmvhCNxer1rZ6D0fDA1YtxydkoaryHYI50NdGGVO+BEhxAF3EUCm5hpqGzo4hJ05OubQh4UhFHjDH1a6lYPrQ1YnN7cfvLD6/9VJSgC/Wr6BD/OG7xKEpMXKLHRezdULvDrsCr/D9teETtlSo9iG3ximzMM239ZHwtfo6xfTgnXnu7PIlWUsoGNB0sxJQHVFko++KMl/eVad9OM0lLbxsi4Sn6uUk+Xv49QxhgyYdqP8/9gyTWqNkp+dLC2qRTLAxcWx9rPLbJUdC1oacWPjxqTe+O2iC6wAWcKLPLvYIUIswGmIis3gin8lO864IZsY5ogRQ2+jCpF2y6+AowbP2fhqiMV1ZDepWxbCNBzzXxtNESDEJEBcZw3FenEYVQiDEHTvRh21qPAlIx3ZC5FJGFisPBmtQaTmu/X9/lQDToBpuWt3DNBks5tr+3zLpZ3Rjt4tGDwDj0RHklZPgGMOyo+QeHa5+G+1nC9YnXX894ZWqEUnjr33DepLH63A1qX06JB9e8yQrL4hvXNqpXWWOxWzJpAKYF/mEfkyt60e7osrFsJcQ30VZ1ztQ5TEuIFyjc09l9v6AV1VZ8h9FUMGPFwx9fwM1jtrIWohYuEZrmMoMfXfkZdtA8dUzOPd5yb
 LZ/3s/A+
 TdHj95erVuW2n28znh3+i8HXqxxqUXmdzOqHFq/67ZlwgpScq4gl73YgxOPGImmVtlKOWB4h56X7obOuS8dcFAFSK5I4WQm3Z7KudxIM7f2x73LSZloOChKNLVOBf4yoSfvryYAVJZfcWfolwDzMFwzsYftF7L6LvVrZ6nFc5vzKOVjJoxPD3CMjol73KD9f+JiBy/vfxPJt+VXUwQq1UE+P/hRjthhB2AkSI8RLZLXN0NLHDjgGqdfJNXSZto9Kf972qEV/MiYXAjWPGhXzklLOizL4ZhADy0SdIK9UbIUQsx33b8E2GHB6wIJPXkcxSQ0SrZJr+edrIXsE32Ryiu8M34O1KH+oyJXxJsi736wOuv+O6qYsv/KGeUNnriPstYgfFVCPHbyFwOyNFjBShVIMiXbt3u5pV238pOlyFyDETzKkWAptHVzjP/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

similar to tracefs - simulation of normal codepath for creation,
simple_recursive_removal() for removal.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 661a99a7dfbe..682120fdbb17 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -329,7 +329,7 @@ static struct file_system_type debug_fs_type = {
 	.name =		"debugfs",
 	.init_fs_context = debugfs_init_fs_context,
 	.parameters =	debugfs_param_specs,
-	.kill_sb =	kill_litter_super,
+	.kill_sb =	kill_anon_super,
 };
 MODULE_ALIAS_FS("debugfs");
 
@@ -405,16 +405,15 @@ static struct dentry *debugfs_start_creating(const char *name,
 
 static struct dentry *failed_creating(struct dentry *dentry)
 {
-	inode_unlock(d_inode(dentry->d_parent));
-	dput(dentry);
+	simple_done_creating(dentry);
 	simple_release_fs(&debugfs_mount, &debugfs_mount_count);
 	return ERR_PTR(-ENOMEM);
 }
 
 static struct dentry *end_creating(struct dentry *dentry)
 {
-	inode_unlock(d_inode(dentry->d_parent));
-	return dentry;
+	simple_done_creating(dentry);
+	return dentry; // borrowed
 }
 
 static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
@@ -456,7 +455,7 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	DEBUGFS_I(inode)->raw = real_fops;
 	DEBUGFS_I(inode)->aux = (void *)aux;
 
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	fsnotify_create(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
 }
@@ -602,7 +601,7 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(d_inode(dentry->d_parent));
 	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
@@ -649,7 +648,7 @@ struct dentry *debugfs_create_automount(const char *name,
 	DEBUGFS_I(inode)->automount = f;
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	inc_nlink(d_inode(dentry->d_parent));
 	fsnotify_mkdir(d_inode(dentry->d_parent), dentry);
 	return end_creating(dentry);
@@ -704,7 +703,7 @@ struct dentry *debugfs_create_symlink(const char *name, struct dentry *parent,
 	inode->i_mode = S_IFLNK | S_IRWXUGO;
 	inode->i_op = &debugfs_symlink_inode_operations;
 	inode->i_link = link;
-	d_instantiate(dentry, inode);
+	d_make_persistent(dentry, inode);
 	return end_creating(dentry);
 }
 EXPORT_SYMBOL_GPL(debugfs_create_symlink);
-- 
2.47.3


