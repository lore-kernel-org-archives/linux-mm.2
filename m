Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADF1CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:49:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8BC8E0021; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF798E001E; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3113C8E0021; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 180A98E001E
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E02B211B0F9
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:14 +0000 (UTC)
X-FDA: 83908850508.11.EAF2368
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D08780004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="K4/e3Rie";
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354493;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=;
	b=EbyNgkj/XErJrieuz835KKy877obXGasU6IuZ4CYxA4kxYWv8D36DGmmEzQUYZGv964A4P
	86sspKfowcN8nLYs+V1yEssc13cfnTq2GwYAu4gWWb2j98SELCSvEHjmWv0WvAN1aSGukc
	jdsF23ifnHy5XUJ3Xg1nu9dKSrW4LEg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="K4/e3Rie";
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354493; a=rsa-sha256;
	cv=none;
	b=8kDxlxAiGHBNhtKNUmPsMc/GJon+wsFqM4dr/5h794W7nPjgjidsB52IMRltgUUXv+V2JP
	HddoaFr3Z4+/lgtVjt6cO5Dg5TJgwA4r3Dkpi91QSw9W+qRf4i5/AjFa80iyesKiEvsjzA
	o6IOWco1N19WgYXHPZ9rkInv4sQqwfo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=; b=K4/e3RieUOijjjl/ehkEvHcQ4Z
	QBK1iY+AOPVRofXOu8+4mdeNcLH4uPJC3gWxWin8DVhGiQ/Mh1Xc8Y+gjCxG2Z4j9osEOGr8cbX3w
	KbrPFmdelDdm+qPmBqPLxdXCucPd78tb8EP+clrbWeNVzNKeGNsD7fLfqX9in/P6X+oiuHGNOLS/P
	ue3YPE2fdcGHviQKX+a6c4NsUbT0eAp0uppImgmQEhuXE7ZvK7x4GwofAE5JTMhW3fSytOSnCTKYm
	l3IswgfSvtxEffSKr6izyp6D9vQE3mvuustvWOj2DDGGWg1Dv/G0DlzJ8W+tnLxN7cJgHMkJ7r3Oq
	jS0fXF2A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKI-0000000ExNS-04OY;
	Sat, 20 Sep 2025 07:48:10 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 37/39] hypfs: switch hypfs_create_str() to returning int
Date: Sat, 20 Sep 2025 08:47:56 +0100
Message-ID: <20250920074759.3564072-37-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D08780004
X-Stat-Signature: 1ehpggiymzrqt7jfujoy5un3jxmyoc59
X-HE-Tag: 1758354493-459565
X-HE-Meta: U2FsdGVkX1/rHXbMVUrJNMuSPDm3Aem/4RGR0lAlM0xKcmYC+7YCUPINn+oFdQqP4K7A5WUo96stf3izbGe8gOO5ovPsGjOqUcbqgBZ/dmD54tTVnKI4FEYlplrjTAb0IM77QbWNLoSJvABaHjrJ5DbQwMzGip0nDPPBimaJthZJe6E/xoj3YL0IQgEnF+e52hKP4AZFfnUr4Wr/GR8sNK0ULqV+pJ/80CV4KutZLm63zO5SCABY3JF2LhpKEJCnUk8VdyNCoRnSx5uiUqPm1xmFBjl+F9YVel1qld8wkcwHWh0mjdU/FgpU/iGmokZAzbo0Fif3q3s5IfykMYsROmjlFg6SqZ3a3jvwNopAfpDeZd5mKe6qHln7j9k8FTdTWzIA4yQja/gCwO+77jQcEtd5IjpyYUtIhUbuzNSH1BF/brX1ThBmMSjL/OdqyNtd8VYpNd8IsiIqG/1Njn94FvigdHgYJmOwtOyQci4wVW/Y60dOTn91snujZHlPmi5vTowp1r68C+7kddQTmAY9vuBH2/3zbBt3HZRHJBSTy5JlcWi7YmX6Bwkw6j4ga/rUPzxAHf7es+yRrUo1m8OUdoOQrR6iKL0MBIWGibmusjaTyw8OBB61KVLQ6O04T8uiDGGREXRXBTtqfhQIj6RePGOQlkIXdm02tKLsNVaYI9duJNChokdU1nHks7uOVjcBd09cJuSG1G2/+i/EwFUpZ/471XJk47GjZd2XX2LdF9BXiX7EG9OSfATTeqzFKWuYdjDG19YmaRFs1ktQLyKDyuzL/EGMDGXYi6Fq+r9xzJRBxLMJzyAcgxZ1byhxJqiVgZpNTYWbLVcC5KSNKzNZYh0TEtwHQzw5R879tfo2jk+3nq64+3FX7oOLjgjnaBAWuUFlFB2qgnfKwlyNgKr3Zjl+6+Vhd+TU4KQl8ugODBhLz3bqnHzTh8HbYOM+nxiqwF2VH4frNBSJi9h09Bo
 9IChdKK0
 WklrtrFjOePFBIX0zYcjVLfY0J31dVnKQyRnPfFJsXbiFHRBg5j6buxKJWiM7usg/O4JSpcm1Q6F5ukpeXD/s5yKgF1oXmGxyG7GKi/z6lFyfAuBZ+H8S/D7+Ic+9Gvo3emcNshc3B2FJa05U1WPcNXHns2qp7i3Y+yeC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every single caller only cares about PTR_ERR_OR_ZERO() of return value...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/hypfs/hypfs.h         |  3 +--
 arch/s390/hypfs/hypfs_diag_fs.c | 40 +++++++++------------------------
 arch/s390/hypfs/hypfs_vm_fs.c   |  6 ++---
 arch/s390/hypfs/inode.c         |  9 ++++----
 4 files changed, 18 insertions(+), 40 deletions(-)

diff --git a/arch/s390/hypfs/hypfs.h b/arch/s390/hypfs/hypfs.h
index 4dc2e068e0ff..0d109d956015 100644
--- a/arch/s390/hypfs/hypfs.h
+++ b/arch/s390/hypfs/hypfs.h
@@ -25,8 +25,7 @@ extern struct dentry *hypfs_mkdir(struct dentry *parent, const char *name);
 extern struct dentry *hypfs_create_u64(struct dentry *dir, const char *name,
 				       __u64 value);
 
-extern struct dentry *hypfs_create_str(struct dentry *dir, const char *name,
-				       char *string);
+extern int hypfs_create_str(struct dentry *dir, const char *name, char *string);
 
 /* LPAR Hypervisor */
 extern int hypfs_diag_init(void);
diff --git a/arch/s390/hypfs/hypfs_diag_fs.c b/arch/s390/hypfs/hypfs_diag_fs.c
index ede951dc0085..2178e6060a5d 100644
--- a/arch/s390/hypfs/hypfs_diag_fs.c
+++ b/arch/s390/hypfs/hypfs_diag_fs.c
@@ -228,8 +228,7 @@ static int hypfs_create_cpu_files(struct dentry *cpus_dir, void *cpu_info)
 			return PTR_ERR(rc);
 	}
 	diag224_idx2name(cpu_info__ctidx(diag204_get_info_type(), cpu_info), buffer);
-	rc = hypfs_create_str(cpu_dir, "type", buffer);
-	return PTR_ERR_OR_ZERO(rc);
+	return hypfs_create_str(cpu_dir, "type", buffer);
 }
 
 static void *hypfs_create_lpar_files(struct dentry *systems_dir, void *part_hdr)
@@ -276,8 +275,7 @@ static int hypfs_create_phys_cpu_files(struct dentry *cpus_dir, void *cpu_info)
 	if (IS_ERR(rc))
 		return PTR_ERR(rc);
 	diag224_idx2name(phys_cpu__ctidx(diag204_get_info_type(), cpu_info), buffer);
-	rc = hypfs_create_str(cpu_dir, "type", buffer);
-	return PTR_ERR_OR_ZERO(rc);
+	return hypfs_create_str(cpu_dir, "type", buffer);
 }
 
 static void *hypfs_create_phys_files(struct dentry *parent_dir, void *phys_hdr)
@@ -316,41 +314,25 @@ int hypfs_diag_create_files(struct dentry *root)
 		return rc;
 
 	systems_dir = hypfs_mkdir(root, "systems");
-	if (IS_ERR(systems_dir)) {
-		rc = PTR_ERR(systems_dir);
-		goto err_out;
-	}
+	if (IS_ERR(systems_dir))
+		return PTR_ERR(systems_dir);
 	time_hdr = (struct x_info_blk_hdr *)buffer;
 	part_hdr = time_hdr + info_blk_hdr__size(diag204_get_info_type());
 	for (i = 0; i < info_blk_hdr__npar(diag204_get_info_type(), time_hdr); i++) {
 		part_hdr = hypfs_create_lpar_files(systems_dir, part_hdr);
-		if (IS_ERR(part_hdr)) {
-			rc = PTR_ERR(part_hdr);
-			goto err_out;
-		}
+		if (IS_ERR(part_hdr))
+			return PTR_ERR(part_hdr);
 	}
 	if (info_blk_hdr__flags(diag204_get_info_type(), time_hdr) &
 	    DIAG204_LPAR_PHYS_FLG) {
 		ptr = hypfs_create_phys_files(root, part_hdr);
-		if (IS_ERR(ptr)) {
-			rc = PTR_ERR(ptr);
-			goto err_out;
-		}
+		if (IS_ERR(ptr))
+			return PTR_ERR(ptr);
 	}
 	hyp_dir = hypfs_mkdir(root, "hyp");
-	if (IS_ERR(hyp_dir)) {
-		rc = PTR_ERR(hyp_dir);
-		goto err_out;
-	}
-	ptr = hypfs_create_str(hyp_dir, "type", "LPAR Hypervisor");
-	if (IS_ERR(ptr)) {
-		rc = PTR_ERR(ptr);
-		goto err_out;
-	}
-	rc = 0;
-
-err_out:
-	return rc;
+	if (IS_ERR(hyp_dir))
+		return PTR_ERR(hyp_dir);
+	return hypfs_create_str(hyp_dir, "type", "LPAR Hypervisor");
 }
 
 /* Diagnose 224 functions */
diff --git a/arch/s390/hypfs/hypfs_vm_fs.c b/arch/s390/hypfs/hypfs_vm_fs.c
index 6011289afa8c..e8a32d66062b 100644
--- a/arch/s390/hypfs/hypfs_vm_fs.c
+++ b/arch/s390/hypfs/hypfs_vm_fs.c
@@ -100,11 +100,9 @@ int hypfs_vm_create_files(struct dentry *root)
 		rc = PTR_ERR(dir);
 		goto failed;
 	}
-	file = hypfs_create_str(dir, "type", "z/VM Hypervisor");
-	if (IS_ERR(file)) {
-		rc = PTR_ERR(file);
+	rc = hypfs_create_str(dir, "type", "z/VM Hypervisor");
+	if (rc)
 		goto failed;
-	}
 
 	/* physical cpus */
 	dir = hypfs_mkdir(root, "cpus");
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index a4dc8e13d999..c5e2d8932b88 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -398,24 +398,23 @@ struct dentry *hypfs_create_u64(struct dentry *dir,
 	return dentry;
 }
 
-struct dentry *hypfs_create_str(struct dentry *dir,
-				const char *name, char *string)
+int hypfs_create_str(struct dentry *dir, const char *name, char *string)
 {
 	char *buffer;
 	struct dentry *dentry;
 
 	buffer = kmalloc(strlen(string) + 2, GFP_KERNEL);
 	if (!buffer)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	sprintf(buffer, "%s\n", string);
 	dentry =
 	    hypfs_create_file(dir, name, buffer, S_IFREG | REG_FILE_MODE);
 	if (IS_ERR(dentry)) {
 		kfree(buffer);
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	}
 	hypfs_add_dentry(dentry);
-	return dentry;
+	return 0;
 }
 
 static const struct file_operations hypfs_file_ops = {
-- 
2.47.3


