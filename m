Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84908CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D815A8E0021; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1D6F8E002B; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96038E0028; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 775AE8E002A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DE374BE4D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:36 +0000 (UTC)
X-FDA: 84097415472.29.123645C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id A545C180010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RQCOMeHD;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844134;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=;
	b=UqZQDXgWEv+y/GILkNm2BolFA4AyOL+p8VR1FQc8Gpm7IleCRJylgYVNh9Sy7p+ynfMEth
	4t5hYWObarqlV7T9hQr9U3lKo0k+9b/pc1YP9fW76cF+9oE8Hq3cORnu+X4p6ZKQqP+DSB
	kTZgx8tUI0GUUqUIh4JhwgBB8//Tc0M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RQCOMeHD;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844134; a=rsa-sha256;
	cv=none;
	b=Vh8BVPLjj97xC/YBRhBOmNQXaqvsvtzxQ0J0XCv077rQbW0iKz1xNs0Y9JitfQJEd5UIAN
	kVby7GDbyeH+uuJUBpcLdZcroekEE943PHFg6Tb5Rmn9eGfUyjLdb8wqSzeG6bByeijV+D
	IHjxwrMIDMXaNfYsIR6veKa41ymPmOw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=; b=RQCOMeHDTMsMilhxlrv0z4v2K7
	Uax1Ub263Rf604bstsm5tixvcaZtT4WVJ1iaUIE8BEHoZknV4vdRUMVILyZhiqThaCURM15QSbzNU
	XDbRDWKE5nnVHmhBAZ/LMjfgS6zWKcBwQCsbXTRyEt2lUStEdf8a+zEKSkMDyoCkNrQXHNR53Qqgz
	lgkQoE2tU3nqJHkM94bqdzPnp3ljtAC0tMDWbxR+uPLfN01RjB5NqhEIVcgrTJJ3/Q3fsnp83xhzE
	2sih+Jp16DJAkGsHt8obPqINFFoiq0zPSf4+w9PbSTfWDnw4tal2yXVwLn6Sys3f9Azg4i7IoS43+
	uF5YJCng==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHq-0000000BxEp-1TZh;
	Tue, 11 Nov 2025 06:55:30 +0000
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
Subject: [PATCH v3 42/50] hypfs: swich hypfs_create_u64() to returning int
Date: Tue, 11 Nov 2025 06:55:11 +0000
Message-ID: <20251111065520.2847791-43-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A545C180010
X-Stat-Signature: s6icxna734uwrxf73cimqxpdfmg8c83o
X-Rspam-User: 
X-HE-Tag: 1762844134-226393
X-HE-Meta: U2FsdGVkX1/6IS7tlEeKoD2xfffYYqZwER584hHpBVRaFmEy1UCTdnoPelrR7FLbqZs2ArNRJQ0ugohTIwZ1pjtQ2iBCHYdFZqKoXJXbRSEAQjmi2fHHKIS+relFUH8W5DEtusAiwxKdWkEWo8Eu9hcKrm6PFAvnX/ZUzgfis0UJDdQyGfBNFkj7eLbAgy49vzov2MYoUHb6PbL4rEuwRtQHq4ndvWtNwMlcw+Qrzryl+hCnhUF5fcZTfCm9f6ofB15eCOAFYPEd+/abLqb3fsWn1A1anCasz0YFJWSR21DlvwW7V1AymSLZB+A/LsxMdwkzag1HnFZ1gH/U9oTgVvKemPm0Z3283o2xNnokOnSUYe0HlKz8z5pZEbZiQgYEPO8HEj9HTQ3JCtNxiio7tLR39M2p7zcTzwJg9QPNhR7eqCgBzxW6B16FHH1zB3iMMomaQUELZOeu7ChWfUcYyMDTnQSEWq3zXGcOe1ZvDjo6/Z83PPC5hyS9d/iahPlZkvhWQG9Ag5LOaBSvz7FSHOQwZ58k+WB89B/2JlwW34N9ax5MePknQTydxGg8DpdGWito7wKTMOquLNFHewSOR0ofhxWV1ASKFNSpLrfGdiUFuWxnvhfKd5Bjyhen2T3K1gnwdhgAdjId1atbz+A5KNSJPNbFgAiHNx2PAEdDvPhB1rWioZZnG2ZjSGTgH5oyUoqkdr+UA7VluxdROqD4IryGZkb6fHYxnYhT1B/O8gaInAPbeKNKhx1gPBsZaiWfZrJxLIOIwXJq9y3pu3iCXsz7wma6XPkJrggl47Tx6R/p6MjHD6x3SVMdHH9GPR713//VFj7B23IBQx5qnP2cfZBnkt6wsCegOfnXFC7A6CeDu596OEi7Hck6M42gdvR5tAoDomZs54oDIOv1afk3cyMjMDsQ0PA21TAEmjT78owzTmsSOv+hhIcX74RYAsBQtn1qrDGZDJNq1+Dq7J0
 2AVKYQ2y
 P6+nYY0jQKss8K7USS3nQMcl8H9O3u2EUfPUdtkiKnp+VyJPf37bmwLOaJlXJS2sxLvvVyimHm7rM4E5SEVBaBxInamX/o2SwtZzdkAy09CKqwolCj5g8pFh/pSS52gdxMTXs3uhKxOIP9tsXYxjtflcSnuQAbp9034/alKgJCBrRFMF/OcfyS2PZVIBHc8azCBwfa5VZZfRsHh+BNKSUjDLubpPsYN/Ub5Q004UcClo7dWA9jtD7lBs6466sKnHkhNn7D/X4m7qjm6hb1umIvp0KvS5tcTuoRTxx+ShwzeSE313KZ2dzELlnSjX8QSkPKeCA785VCpPhdv5TgZG8WreJccbZuJt9RDLCVt5UCRpmCwVGlp0GnZ5dMs/GkQXoU0Nsak5AmPCLPjOYGMM5kG+IZryn/IGdu7+9TAeoPXt/9sHBZ8NdkKMZRyBwkjrSyKQOcIH4wlfp/ovkwD8PQdDIIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

same story as for hypfs_create_str()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/s390/hypfs/hypfs.h         |  3 +--
 arch/s390/hypfs/hypfs_diag_fs.c | 20 ++++++++++----------
 arch/s390/hypfs/hypfs_vm_fs.c   | 15 ++++++---------
 arch/s390/hypfs/inode.c         |  9 ++++-----
 4 files changed, 21 insertions(+), 26 deletions(-)

diff --git a/arch/s390/hypfs/hypfs.h b/arch/s390/hypfs/hypfs.h
index 0d109d956015..2bb7104124ca 100644
--- a/arch/s390/hypfs/hypfs.h
+++ b/arch/s390/hypfs/hypfs.h
@@ -22,8 +22,7 @@
 
 extern struct dentry *hypfs_mkdir(struct dentry *parent, const char *name);
 
-extern struct dentry *hypfs_create_u64(struct dentry *dir, const char *name,
-				       __u64 value);
+extern int hypfs_create_u64(struct dentry *dir, const char *name, __u64 value);
 
 extern int hypfs_create_str(struct dentry *dir, const char *name, char *string);
 
diff --git a/arch/s390/hypfs/hypfs_diag_fs.c b/arch/s390/hypfs/hypfs_diag_fs.c
index 2178e6060a5d..83c9426df08e 100644
--- a/arch/s390/hypfs/hypfs_diag_fs.c
+++ b/arch/s390/hypfs/hypfs_diag_fs.c
@@ -204,7 +204,7 @@ static int hypfs_create_cpu_files(struct dentry *cpus_dir, void *cpu_info)
 {
 	struct dentry *cpu_dir;
 	char buffer[TMP_SIZE];
-	void *rc;
+	int rc;
 
 	snprintf(buffer, TMP_SIZE, "%d", cpu_info__cpu_addr(diag204_get_info_type(),
 							    cpu_info));
@@ -214,18 +214,18 @@ static int hypfs_create_cpu_files(struct dentry *cpus_dir, void *cpu_info)
 	rc = hypfs_create_u64(cpu_dir, "mgmtime",
 			      cpu_info__acc_time(diag204_get_info_type(), cpu_info) -
 			      cpu_info__lp_time(diag204_get_info_type(), cpu_info));
-	if (IS_ERR(rc))
-		return PTR_ERR(rc);
+	if (rc)
+		return rc;
 	rc = hypfs_create_u64(cpu_dir, "cputime",
 			      cpu_info__lp_time(diag204_get_info_type(), cpu_info));
-	if (IS_ERR(rc))
-		return PTR_ERR(rc);
+	if (rc)
+		return rc;
 	if (diag204_get_info_type() == DIAG204_INFO_EXT) {
 		rc = hypfs_create_u64(cpu_dir, "onlinetime",
 				      cpu_info__online_time(diag204_get_info_type(),
 							    cpu_info));
-		if (IS_ERR(rc))
-			return PTR_ERR(rc);
+		if (rc)
+			return rc;
 	}
 	diag224_idx2name(cpu_info__ctidx(diag204_get_info_type(), cpu_info), buffer);
 	return hypfs_create_str(cpu_dir, "type", buffer);
@@ -263,7 +263,7 @@ static int hypfs_create_phys_cpu_files(struct dentry *cpus_dir, void *cpu_info)
 {
 	struct dentry *cpu_dir;
 	char buffer[TMP_SIZE];
-	void *rc;
+	int rc;
 
 	snprintf(buffer, TMP_SIZE, "%i", phys_cpu__cpu_addr(diag204_get_info_type(),
 							    cpu_info));
@@ -272,8 +272,8 @@ static int hypfs_create_phys_cpu_files(struct dentry *cpus_dir, void *cpu_info)
 		return PTR_ERR(cpu_dir);
 	rc = hypfs_create_u64(cpu_dir, "mgmtime",
 			      phys_cpu__mgm_time(diag204_get_info_type(), cpu_info));
-	if (IS_ERR(rc))
-		return PTR_ERR(rc);
+	if (rc)
+		return rc;
 	diag224_idx2name(phys_cpu__ctidx(diag204_get_info_type(), cpu_info), buffer);
 	return hypfs_create_str(cpu_dir, "type", buffer);
 }
diff --git a/arch/s390/hypfs/hypfs_vm_fs.c b/arch/s390/hypfs/hypfs_vm_fs.c
index e8a32d66062b..a149a9f92e40 100644
--- a/arch/s390/hypfs/hypfs_vm_fs.c
+++ b/arch/s390/hypfs/hypfs_vm_fs.c
@@ -19,10 +19,9 @@
 
 #define ATTRIBUTE(dir, name, member) \
 do { \
-	void *rc; \
-	rc = hypfs_create_u64(dir, name, member); \
-	if (IS_ERR(rc)) \
-		return PTR_ERR(rc); \
+	int rc = hypfs_create_u64(dir, name, member); \
+	if (rc) \
+		return rc; \
 } while (0)
 
 static int hypfs_vm_create_guest(struct dentry *systems_dir,
@@ -85,7 +84,7 @@ static int hypfs_vm_create_guest(struct dentry *systems_dir,
 
 int hypfs_vm_create_files(struct dentry *root)
 {
-	struct dentry *dir, *file;
+	struct dentry *dir;
 	struct diag2fc_data *data;
 	unsigned int count = 0;
 	int rc, i;
@@ -110,11 +109,9 @@ int hypfs_vm_create_files(struct dentry *root)
 		rc = PTR_ERR(dir);
 		goto failed;
 	}
-	file = hypfs_create_u64(dir, "count", data->lcpus);
-	if (IS_ERR(file)) {
-		rc = PTR_ERR(file);
+	rc = hypfs_create_u64(dir, "count", data->lcpus);
+	if (rc)
 		goto failed;
-	}
 
 	/* guests */
 	dir = hypfs_mkdir(root, "systems");
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index c5e2d8932b88..6a80ab2692be 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -377,8 +377,7 @@ static struct dentry *hypfs_create_update_file(struct dentry *dir)
 	return dentry;
 }
 
-struct dentry *hypfs_create_u64(struct dentry *dir,
-				const char *name, __u64 value)
+int hypfs_create_u64(struct dentry *dir, const char *name, __u64 value)
 {
 	char *buffer;
 	char tmp[TMP_SIZE];
@@ -387,15 +386,15 @@ struct dentry *hypfs_create_u64(struct dentry *dir,
 	snprintf(tmp, TMP_SIZE, "%llu\n", (unsigned long long int)value);
 	buffer = kstrdup(tmp, GFP_KERNEL);
 	if (!buffer)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
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
 
 int hypfs_create_str(struct dentry *dir, const char *name, char *string)
-- 
2.47.3


