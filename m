Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0E2ECED24E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 09:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EFD16B007B; Tue, 18 Nov 2025 04:21:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7B16B00A0; Tue, 18 Nov 2025 04:21:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404E96B00A1; Tue, 18 Nov 2025 04:21:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30C3D6B007B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 04:21:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE77159017
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:21:36 +0000 (UTC)
X-FDA: 84123184992.07.940FAFB
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1639140011
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 09:21:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="tvP+Rm/V";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763457695;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=;
	b=wkiZ28ODdkV6ULdfMGVrHc0yFddqnUf85x3t4xHvrX0f+ociITKCjk/FHETD0LdcsdHREl
	XR1n/RcTyP2ywhuV7fvicClhXv54uGEOOPISmSd1049DuYRg3RxdLJ1Uy3coAbEi7TRHAr
	kUR6/VkwpkLIPbJE8OoAk2NmtzPJE8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763457695; a=rsa-sha256;
	cv=none;
	b=mw8e6dY0ihRkabQz05ImKMFH1bEj7XGskcW/zv78OMOQmCU7b6TInVJydI2bknh/pJdAEz
	UZ+MS/r3BMgHjk5VlhNULDuifdgdFCV4bUAwYHksm+xnx7QfdH8sY8EH92RRB79lr2Tl50
	RxVXlgAxIvdd/UVXOsATikVTZABRlds=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="tvP+Rm/V";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sU0Rwyb1f70hxWqGLaDrX9gfHmhzhxjXEuqfS3xyBnk=; b=tvP+Rm/VUpFEtjTr5flW9AZmbU
	EzRtigGLTzsKq+yofPuIueTOmYfV6zi1I2TwuPtT4PHJPyuXP1Nc9lVhj59h2gYy4cFJq4LhZprop
	8ROzJjA86BGtttEVo7zzpWV8snzvasJlqumptzAGTNUTgNkToBAF6Mo6SjcDieMNQ7YYjtXCzisGi
	xYIVaaWwZiJNaqIArUEL4pOtTYOpcwX81Jc4rYYhr0q/ERBWw7VHcz3FQjVCL3Z1fPKPvorH8ODG4
	+Lr1JnaIN5qc2SyQI2UEBN9yNgcAtpy83rsAK2ffeQM7yd8Lt/4NmPt35xVbfRI9BzvSluCk2t3ZX
	lNMovGhw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4Z-0000000GEZu-0Uh8;
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
Subject: [PATCH v4 47/54] convert hypfs
Date: Tue, 18 Nov 2025 05:15:56 +0000
Message-ID: <20251118051604.3868588-48-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: of15spi8wr818bobb1jifhxwsir64dts
X-Rspam-User: 
X-Rspamd-Queue-Id: 1639140011
X-Rspamd-Server: rspam10
X-HE-Tag: 1763457694-395802
X-HE-Meta: U2FsdGVkX18ev8ebh2g8X6ySJfatk1QjamGkwmo8BFlzbG2A28HWESRQp8DBeTd9MfKIzurW06qnkfx/dP2fCyar+jG+lRaXfuDAYIXUStk5EzDZ2MNYhisfg80pG0UNIWcR1tGc8OTwMWsIe4DTjNjWn+kkoSoYQdqwXax1IBS992orOyKCxJv9fvw+e71voNV6flet8IKRxZufSqD2cR+8DvK8lEVlNBzNEYwoYFSrppv5EQtp5JpdJsVrMU06hiS05l2jBwWgNahco32y8wCjKCTdDpuZtGNUEO7k5uQHJcSsi1y9p19FJ90VYScRoeYmU8CrzLJzj/E9MAVXe0BhE7zBlJKhXz1agZ+Mw7IDLoReDqMoilQEV4O/vqz5bUgGeT4+fxD+FlmOWKaj/OmYwBPoAxwjalWzEGdhHqayyD6NtMkyhXqhGV9L2gHoFvQ2BkmsPxnaC0hn6Wf/Z38VI3MqUu0ttgoE+ns/vDUTyAo/aj8+6Y19rVzzAuKcmYyoBwP9+usvEKxwZZVPtFA2FINIionJi0lG94o84RT2UJcNg54eovp5n+3WOgrFFxIA5eRcN4KuIEO0Q2de5s9srvjvKApWVZShUAnaA4IAHjkHMGNl33w45/UbDW2We14UqCE+4meIxcGP853aB0XUcIkObc+WbAudhVpN03AyTfKsOeq0Jkjmgv5mUrPRbP+qi0Agvsi6Nr1ekVZBvu6fEpidRcNBQLCM4989+PYB+iwiUlwm0ItH/4sRX83kPMvzEjadtJnOKbftmeLdPg3PxlrOigIjtTkH7h3mfMk7itBEr4j0Ipk5bO2F/QapNUqY4LZcK+ecfCGXpe0bsLGpsdKjAGiFxbIOPSpd1wVbm5ZzBFF6uXN837lD3vIxjErfia3eSezFwvQgkWBWlHOcCObFki8dIxjOKmgQ6dWdSmXzo3gDwmP+ntht+/RTawhU7jOy8mkGR0YvPs8
 NUi9Zs1l
 U7E7nWmYuUNTBeqrQmzoHUuLra9A/IVcUmknk79a7kXGcIjBGYQy26UsqDv/LGSc5jdbxZugPTtedvsu9KVM+vWS4vDPx/JFH84JZ35ZVaarFs4G0bPJuhOrMhiYlinB/b4x5h6VvGw2w4Hi38wxZmGw7McLsdfTzkkVlVL3CpqQYV23KD8tAEXRgqPVcqAB2gggL/5pjxNfBlAMnfNG/oIe+dsSpluTS0jJ1TrZ1HpcY8eoVJcp6z96uj1NX53izjL+7p2pxI3sMC7bZphA0JU2+V1/8xP9Ml/hggDW1MlRTDQtxDpx1DJmX+K46/r5WpXxueT/qhNdWR6A2x6z7aLRqScbatLyskf4feMN2eU0O/6s4CNlwH/+A/FdtsxIWAWSZ4RhI1rvf9NRtUdk5GtsEx/bTvxsrqb3k
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


