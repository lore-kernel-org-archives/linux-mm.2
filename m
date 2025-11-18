Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF4A2CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056BC8E0009; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBCA18E002C; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D2E8E0025; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 39A0F8E002E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0189487B72
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.24.7D5B06D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53E4540008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cMhlXBqE;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zcrjn9Hoyal2qTn93te4BLRuOf8fYSOuLLeBgOIrdbo=;
	b=dNNcljHiZ+MvOS5zmGLnm12N3qSyqlUNssta/OrDQtwJ+2SCz9KG/Z2vKxjyPEMUVw57+w
	vyrG+W7JMyztQbVVV2rqeerfuU2YseVeXRXTfZ9vt8t/S4KIt8LRh/Vzj7awHGREZy/vd4
	4s6VDQs+qfULDcfRSqXkdrAWi5Uwt9U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cMhlXBqE;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=17mymU8zaDdBkVkl0cuoNCDCfoWm3Qd7m6N+KDevUA3jxOaEuxxw3tUKTw015RwpQJdW36
	/AqGKRfobu48/Im0BbEE5oGCUlc5B1loGE4RX12z35VUxiv0b3jaJZ8Wh2lQcql/K5gYcm
	fVUWtyu02U1TTO9AEMYe1lIdtIGihbw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Zcrjn9Hoyal2qTn93te4BLRuOf8fYSOuLLeBgOIrdbo=; b=cMhlXBqEGcRgFzivtW6c0N9XeJ
	5GoGNtggd/IvFsOSwoxXYFjLNuuucPyNlyXC9RYSslkG2HVqkhhkXopsNdIlCG7dHuTmqENpcMkCW
	1y11RnGPngVleScCDLPtMiEFccZvejq+LsXLe5h3Jpu64iwHmDTVgryh/skc3R/qzpyGfLa/4NEnX
	QzrbT7g12nVRpeqkBNdMWVvVisoqlemJ28304bpBsNN0dZ2QzvYivoQ/dLNwf9c1QWZfGLcJk6nsW
	CgKWdgJB77OjrZB53fmfibtws2x2pG6nmSHorw+hngyXde+felKNRB1P4cCifXGXt+lbUs2oEZ/ou
	nFVCdRrg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GERG-3gSD;
	Tue, 18 Nov 2025 05:16:06 +0000
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
Subject: [PATCH v4 16/54] convert dlmfs
Date: Tue, 18 Nov 2025 05:15:25 +0000
Message-ID: <20251118051604.3868588-17-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 53E4540008
X-Stat-Signature: p1ie5rt3ho6qkedc6cjqzhrfwsiesjme
X-Rspam-User: 
X-HE-Tag: 1763442974-423163
X-HE-Meta: U2FsdGVkX18ya68x6jP9mG6c/qGx1TWPwB9ajnK+PJvRAEzJg05ivj4zipKDX8aREBBsPxwPzgQw7pE9x39IAaC23YVBXlgvEVcfWMKGUv8bQveCdjagxlduJeiIlK9anHsrDAZChyrmHjKq8w1aow+T3fATW8OoCfSHsaQc8tFW1vG1JSAPCVZ76VbOWuxSfk6jXQHDtPZi0QxQKOKGfXftGF0fKjBh91b0B9BPUPslDbP9/2QdyfSuOL3cipvZbQinm+WP/bQlyi3wPd6DDDRni6h+S833HY/21BaOtw2TMFCCjtT+urnIqUehU3VDXdZalV28HOiYZpwkPglbY72UkW4bO92Xcqihg6wjIG4hSaenaHs6+Q7Vqc6ujbsApDFs4jZyd0hU2DtNQBFVfVpFgrRnbM3r5UooxClPFsFnYtRgcZx2we6LzOsmdpakKauMvMyrxNNBpNhRGAkkj1VD6FwD43ShZdDyfIMzL1J4htmQqKMM7dysfz8eQFsCkTfkCQvGSLf8SEKcLcoV8aiwQtLjs4D43UoW/6B4aIS+MD1JioguvZnBPvpdIjH0qqQvssWjPebrRPUh152Y9hjhnTzFXgWoqG9/+6ygmfjJaIvEBpdeFKP1Bbn2XAhsfUiO67sV0bmp1YDbKHIIJNXFzLLpnx3rBVeU2gHsCyKQAj19fOG5GseGBDkM4fg/z5nBSvWK3uwoKZYpGlk/Di3dj/2Kw7uCUSTbgmTp4OXZm00T4pET+UF8bWKWRuYTDU6rvXWA+QasHcUy0hhF5DhkHxZL+COQ2dKTJ50rI6vLaBDKoNncYVOHDGPmWvIRa0o7OVArVkSUpw43sIwJF019FL23EGPHj1B+A3S3Mug19+XE4sd0bJW9rdNgW+v/lK4Jh9vtWPtwGePqdVqMWzaRxCHEty6U+ofLz42c762MTTe11cgiSnVbl4z19q7VZqO+2+DE3SJeF/Kzwv6
 wu+yQI7i
 HzjQGP4MH4vFwbdq/skYsLWtJs7RHfOG8w6sVVY0iNzowoBkWzXyEF8uJFbFYvREjyvwF/1uTtuDr7dcsyKtSg7N5m0LihFCBJrLFal2yv/1quH/uSsnfzcndxAYrAedAtcEZP4YoG88lni6M9F/zKonfJzvclZSFLslOw2j38Ov06mAF6NsuxqYSowYVabgYxJgB6Siy9LWOe9e14V7CcfoqBzhd1zCbt+ueNry21ONncus50q+Jsd1r7eMcIXUPJep6bFupF3NOXBQdTHGTu+PsUJkBFEII3Dxy/iOBsY6gc6203/CenU51CnhcrRp6/puYSIFjRM/uXugoO0BzDHKKfFo/GD/inOOTTZjkeccdQXJFQ2XNCo1s17Dha7psYQugR7bCAG9smNHcGg397zqWl0lu7DzjDt/a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All modifications via normal VFS codepaths; just take care of making
persistent in ->create() and ->mkdir() and that's it (removal side
doesn't need any changes, since it uses simple_rmdir() for ->rmdir()
and calls simple_unlink() from ->unlink()).

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ocfs2/dlmfs/dlmfs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index cccaa1d6fbba..339f0b11cdc8 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -441,8 +441,7 @@ static struct dentry *dlmfs_mkdir(struct mnt_idmap * idmap,
 	ip->ip_conn = conn;
 
 	inc_nlink(dir);
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 
 	status = 0;
 bail:
@@ -480,8 +479,7 @@ static int dlmfs_create(struct mnt_idmap *idmap,
 		goto bail;
 	}
 
-	d_instantiate(dentry, inode);
-	dget(dentry);	/* Extra count - pin the dentry in core */
+	d_make_persistent(dentry, inode);
 bail:
 	return status;
 }
@@ -574,7 +572,7 @@ static int dlmfs_init_fs_context(struct fs_context *fc)
 static struct file_system_type dlmfs_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "ocfs2_dlmfs",
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= kill_anon_super,
 	.init_fs_context = dlmfs_init_fs_context,
 };
 MODULE_ALIAS_FS("ocfs2_dlmfs");
-- 
2.47.3


