Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5770BCAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 09:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B0518E0002; Sat, 20 Sep 2025 05:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 761218E0001; Sat, 20 Sep 2025 05:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676BE8E0002; Sat, 20 Sep 2025 05:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5059E8E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:31:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F1F24873C0
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:31:37 +0000 (UTC)
X-FDA: 83909111034.12.9F64BFD
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5022040004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:31:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jYNJJ8j0;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758360696;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=;
	b=hFwfyTALyzffZK9nZB54cveuoEY648aN5NJ6X2jN4XehcZx149ruC43tdrmss6XfzuxmuM
	iPmCVEqZwhA/xgfJ6PuU6BDSGn8kwQeMCz6BEXttz5ZczwurIh5Z+mvGxcNdc1O3njVF6q
	cb2P6A2a6JqhGtNjjjVylQqI2A56prk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=jYNJJ8j0;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758360696; a=rsa-sha256;
	cv=none;
	b=fp3JeDz5kqgUgX9qyLILeqpuJEi+H9h9AOAW4R6/1tmpBm1XZQJV86Pp7S/IP5RkMikQMz
	gfo4jautDqO7iBVclo/I3ppk9OHJjn9jQ8f6U69PdFq4MKDHN8NTvLtmJrfIawo2Gbonlj
	QJlPGFE6X63yckHhBLdwnfOpaHkbuGo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=; b=jYNJJ8j0zhd6zN0CtAkrxUFzG8
	A7fL4aiL3qQ8pbYSj96taeoB/SJfNk8gEaBbVgkYHLIn7TCKsbit+A6jVq4rvhFraclkv4BuH+vBd
	stAC+9JobdFlIz6akUELgYmK5N84sMHKtPc2eIJl0HmJQledD+rAKHALjQeS4ee/Ga1IAl9xn88eI
	rBVxgVSMXyrjEioLwu6YgiL12wK71K3KsRF5r0Z/PKl3cILsBKStAVHr74Qqy1AwQMPfJEM8lHmyE
	A5H3SHgORgsWEQQTeIl8yE4CCUj9F4HPtgzcbaAMWyJTwzRYcnxo2SL6OIRC1UH1/G0oLFyHedVcN
	HTa2Ir/Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKI-0000000ExNr-1zV1;
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
Subject: [PATCH 38/39] hypfs: swich hypfs_create_u64() to returning int
Date: Sat, 20 Sep 2025 08:47:57 +0100
Message-ID: <20250920074759.3564072-38-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5022040004
X-Stat-Signature: eqbb6w7zasrdumhcoseempiukc9gg4h4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758360696-908523
X-HE-Meta: U2FsdGVkX1/kYx6LRWClmKFDimu1QMr8iM1Vndfz+Rmnw2ywwK3r4lLEmu+roKrlAOMGgM9pxLCbhTPlKGiYeQCLBsMuiweDL+2EO4TfcF1yqZOEAq7rkb4grRfd+2ywufTmq9B7y6MtJ9t7xMGddrBFqL4AtpLyBJ0Z8ySMRblvckQV4cMdjoHWaAcTv/blRp5TeqNVim7x51V6hOMxgRmYWOzPFG1VgsMie9+yFmh5Djat8L/uGv8WxBAk0VcUwqsLtSoCT4CJeU1uWc7d6lQzJOfWQQoXbS12AX/86QCRAmCQbo4u1i3qffhZto/h8Rf/TqP1fwxXFA0wG5qxpi0CR72mpCIj/NZxyWdbcdJIwsqaKgxedgZUit1T09KFixQ7R9tZSRYNXmm8ga4g8HrN0iK0PuoSlZQ+sSRRTwo9USNknh1xjGiHpnWERde0FpBB1vrTraxk3+j6EoY3kp9+G2MBtg725rSidbG5OvVog6vBG7m5pDaQovULwfenDG+1xF2gRtQoNYwfxGjBMYSvVRoMZsDHZ0BPaIrkdmNmM0LIA33mTwPN2S4dr+m4lRUtAFGyFy26wcv/f7a+2lOMs24BoNQE6xqWEUa62iaiAShM5CvBAYGCnk2w0/DiqbOl90HhdUS7BSPdKob6qYEQdcPgWi9jvdAerfddUfK/DuYwKZSZ8q7i/BEfog2k27Ehm1gkZT8fkbgEyuJSaVlV6Ey2ofl80mmffrupyLN/KJ2wDEP3/36FudmSya7ZXDAgkz5fl1WdYBopA2QTNV+GYFBMQLaYV9Rjc6fUossN7CKvO50+neW0d+rwKL6yhllq2Z4eXJnuPjYPTCtHgLZUum/DrSF0eS+2ZE9BAtU8qFHwubgG7LoD4lGLaYpEv3v1s83PQaOuiBRjqkZFAIswbzrzQI0CLSN7ciwFNRVcVIJyB5C98MHqXQn/K1IErZ0oRaPHbW84oUhzMoG
 h3u1xPgu
 tbQTaNro2E5R8KwmaSeemWqgKuHPjk6eJCXjIPpNhmAVL7D1TsfeUlM1Sh8Q2yyd/lRcm8y5zKz9DqeI9Y19/Md9BORz+OnSyZO5oKEaoypRXBeWLjyESSSA+2XrOBtKP75wWZlQCcfrJ6vQdDrfn/JwYnKMKez2YJh5ppQ1aDjMOm7PxwbmYMlghLbY15HWiu03vkXQB7DsnQ8+4+aG58MrVeLSIWmnLIMqPV5tCahdTGHfT3wCha6yDU7CO8qRYhQ+nxJRHNRi5Arq8SItyvmutax1of5Gnf1QiY7kG/U6rtFBmqtR4FGTOjrh/58stj/JG90aGwnvmWyWTc8vL92aDlMhiDUbAU8d7G1RRDEGZY3E8qB1E8bX22C/hl9fBhOfNmfUAYRxcFiqyey/rcmWhCaynR1Sxk5QJRI2rxPPPP979fjIN4SOm8bBWMfyqNyxLy2G3rMMdBKCIA/KXgdPDSg==
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


