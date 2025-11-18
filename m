Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A939ECED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDC8C8E0038; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E8DE8E003E; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144B78E0037; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 934088E000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6623613AB5F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.23.A86E140
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id B2F8AC000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=tOLkdrdV;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=;
	b=e5+jETvFkh3gMOoTOHsQ9q030ubaRdPDye4ewP3QgpYaVE6R+8OjqFcAqM2q0Ed6F5c9oF
	mIw1nxlwprlBefOVKU24cFrvvRgqqYLJN7Gqelln0Lt08+/Ei+qo9MpSe7O053tUs+ZG36
	vB3oaAXPO5S7RJtHxSVq9ZM/9AaUwWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=NdWUZUHFNJO+fQqNy6zFGeJmVEMO5Ro0QAJl8I2Qn69CnvVpIXqJnIJ1IBghbQNWaCUg1W
	iYKmSqh6Jq4tiIwFqTFT1qoc9FDKmDiJ4wsCecT0ArzanM/AJC0F87/SHnjO39eiWF9dbt
	uUKHEys4cDtvz801XdIr2buPc04lJEg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=tOLkdrdV;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=; b=tOLkdrdVPGe+8vamPHV4LHLTuP
	nUSoapRERO9m4HpmJuY8++Xr/fF7rEWAhfw+OlGddc7M4PSkD3FA79RkZiSUp79G/qgOS0e5SH8wx
	8cExXEihKGJr226ievrjtYF2KAFaQsZCjIlrmDsKKBpfjZW19QUIfsBdAC4RY6seqB/9okn/R1mA+
	nJOmKYPMUmM9XNZDxiJK7G2whfmX8wC9XDy6mUiQTLH2tE743u3IxhyBLoJO9BiwFZd1QKN/T5WOJ
	C4pZEP3xKpXONqJiXUy/bLBxcy5yWS8p5BOFJvUmWxaMMzF1wyOFX1qIsC2zytDygEERu9HsR3Sy+
	xrfRzUPA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4Y-0000000GEXD-1KPP;
	Tue, 18 Nov 2025 05:16:10 +0000
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
Subject: [PATCH v4 45/54] hypfs: switch hypfs_create_str() to returning int
Date: Tue, 18 Nov 2025 05:15:54 +0000
Message-ID: <20251118051604.3868588-46-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2F8AC000A
X-Stat-Signature: 8zrsgewq9r4winnh7ocztymmuncto94e
X-Rspam-User: 
X-HE-Tag: 1763442974-935299
X-HE-Meta: U2FsdGVkX1+2j6UibYX6n9+F6SpIEdm6wQisJiI5giUVlUFfeXWFW/2ZeQTTaZtr9ec5cTttHYu8pDARhC3LmeCpYdT1WqFt5duw30ahK0gwOEM/phH0WOWwGJj6I5+KKikCHwiO1ScPbl0nFp/9CrD92Q/89GPBWvhUWt0XZTxzNvrWsJ3JkHcM3g1JMUe/LrSn5muNP3qkdXCbJrL3AnBEh0wrMe/i138pqr/pd5FGm10OcST6Bc8xmULKbOSWACUFw722hnIBwGdyM7teSyeK7pxAU7tPlFOiRB44r6Y2tO8tGLZbxj0gYMbEkKNKJRu3iZAcGJEYZ1IBNfHEz51Ln8glqeQNoNSttJCF+TLZfg4F/OCXE+i6xQjOzwTFEFLEPv7eBX4HD7HKwbkthVm29IwyREYHT3HA+d4vaA1LVmLLK5wH1xtkBRQ3iCZcj35WQ7J20hP7tjR9Zwl5x6vH0IOSTv7zDPidWfNJ5EyBdxkQHW18BVYxrBJ6k1bV/nrrD16lw4eLa8fvJk+VUJ05Q6dOyrPW+hTqHNllrZFJ4ksxrYmwDqkpCC3j3reCaicYAUUJzDMqklIkklXkcKKffd5zWWoqd/aqbwQEuEyOGRZyWseFxYrOq4GtNK8iBYh208l6hh60FXmQktj3F9qgMYjVCZ+nGKiTIdm3FqdqbG/emj82ATZaqq3KdtSEHKsH/EjMhEdBS5j7k2NcIV+0g/1kuFacWZcwkqdAAzLC3KRt/Tpl5K6Sx07Ag+UAtqIEKdW7Ad9UlM+tIQd5GkwSC44xYeSh7QBOqh7aUqjqMWLCMLkBm2LSUcbsVLeekwuniayq3nmLqGQfYdne93eaBygwsI/n83lF0eKz6MsvfrPODhq3jBkgOd+UEDYul5/1RzhfR2SOPe3fD0l0ZJO8Dh8fg+nUSvYC0IfbR/Vq425dvct+hPddotLRCM7xatSu+0BEsOUuW2qnQSF
 JJc3QGEl
 g1FzS9drtr+yS65BxhrS2NuLtciFY7QwVu5j+BX7gPyfvYhkxAzBot4++w8NPlGUCa3BDAaI9H5qXtG+Kk/mB41tPSsM+wTgKfCkIMvBraskjJpkES1SKjPZiqsCCl5cSjfbB3vixQvNeYfkFeTHDAquQTAMaSs9fAmlx/EhPaSoPIbrJ+dvsOI6SURtiinGGCNrrBhCb2tL9xOnlnNBaU0c9UWjz0O4YX8bsKq9Y+0EV4p8cABHg2rPgIeGHI3BgDtBSoVWVHxxyASrVYfmcshf/y/EfTqBmC64ZgXTnX9asdRMgz3TmVMrEkYc4mAfQAgw3XzWlHBrqMVb/jQqDvOPvtdrxzZi0aciOqIn0es64tt2O3ZKPhpoi3U8ypEOOm+TANjYiNAKWHWJ1/lcLOOdyyJfk9t5yJKssHolSUJpeISH4OfVLxPv5IBKAxVzw69v7/g3c+nW9UBk3hDFNwKSLaw==
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


