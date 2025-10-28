Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91AFBCCF9EF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC611800DC; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD63800F3; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2169C800E4; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0D256800DF
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB3FE13A7EC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.02.B9A54E4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 025BA80004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="BJ6n5q/J";
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=;
	b=JKkm1GYbl4Ct73Pew6Dw3gBrtuG5oUcaEmo7n374FcpS7uW91IcLL99FoQey+v0YehKYHF
	Xntlykop9KnpEc4PvhHUam1ZDwTK1iyRGLkZuVPZOJB2VfDYuPZuU5sedlhppu/4l0gOAX
	gyoNxjblEIg5bdxu49r8ZvkhMifjGdI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="BJ6n5q/J";
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=BbSx7aVe3jWesytWw2j8uALdassYYzZh/G8U856KXvFNTovb1egVc9nRLPQv7KoLOiIy84
	27rT6UY3WY5h9mPNA4WQ6CXl4cU7QqL14UHL/TSyfkmeielnzc2k8wfpwl8ILfFkSj48Dc
	WYmH3ZDfU4S48QPU4RG4aDbJ2c7/UQs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=; b=BJ6n5q/JJc/d0w54hGGOhLn4B4
	v5hSfTaNqMn/MiiifDqppfBCBOb0ZVucm7VNLPLNUTXAmCtPk04TpjhJdbcmMfFi12ehwp9x7Tu9N
	25fE4WvqrtoziAxn4kvNRcEXvv0VG2Znr9eshnw62e6lv0kHWroVzADqIYdNLgC8Pj4f4Cjz/nodZ
	dJrDpFZgg0r3fNg/wNU/zBvoCEf8hVXBHqC95Nn72/Afrdrnn/kM3020nXRRefdHrJs9G7RfEcaSr
	uLIsJJez9qxNFtGAtnz1iIL04x3/wr/C0ak96GHJ7xUPlyW/JvnXib9q5WXHINEZEYlLbiW037w9i
	99vxjDdA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqt-00000001edd-0w8x;
	Tue, 28 Oct 2025 00:46:19 +0000
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
Subject: [PATCH v2 42/50] hypfs: swich hypfs_create_u64() to returning int
Date: Tue, 28 Oct 2025 00:46:01 +0000
Message-ID: <20251028004614.393374-43-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qnuafhydatozwfy1ofrgnkapqs31kgaa
X-Rspamd-Queue-Id: 025BA80004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761612383-328021
X-HE-Meta: U2FsdGVkX1/UVHp3+LBIEL1PWUnhCEjPKOXFjUAhyEMDN66X8uG2AM9Q3jTkDR2rfuhUD67fN+f9HvKAahJrIrJCkQdxYUy8W3tXrUiwnI/l5NGQ05phjqkuDvia8KAdNoaGneWaiDslZsxbs69dBoNUwBAZKofSJfgSE81OMejfjAOickIPOCeG1Vl5S0xpyM5rJm02TjcwQ4E1JcN8zxWWksfRsvnpl5+qhruaU73OQm5KVp+KIpFV1Ms31MlBXI3sC5ShkXHrypPLNCp3/UlHTfNRwHVkQQSikR6xpMseIlpMMCfJcT17AImLztAV5rLU/keiaZNIXGhvFk/xSzxeilvjMhEGsWZsnmHyfX6mbqUfGH+HBPeHiFnwSjkkkrnrQ4ukbZl6Svl9P61lQ6gqW133+dtBR9iJenbb3/emjHj/QTaHPEGxVR2zKvZmiGc1aaRuTZAH5bMj1wSihGKiywiM+LRiQOr3hhYIK8xHz4++J+MydoMIZaBI++jSCDA7+qcC65gCzLJn5wQWCMrGrO9zW6feS1IYLAjORFgfDTXXHRqf8F5eD33xzIzyladwW1IxRfOI8xr9fZXvK7zy9OPnFs7LioD2yHwcLGnjzER4bzkJTTi/7KT+ivF7l0tCUpC4GCo8G93A1rO9voV17ODXL4g71ZyNRAVO1e1wQ+viim+CQft5WxXSzVnk28J1u0TedGGvbDU53TTocb69PlJSABhRbasA4z9fdwzgQDVkwXGpwq6cCs0Gk6Ojp2mlvgnlGGot0KO8QN8IqRusBhh2T5SGfhx3qBDD7UgKdp7o2F4R0+EFDvFjbtWibXK4v/SMM37NAUeDOjPAPmuPnf2626I9JlGv8795qvp0reBH2lHQUbAIL7hqZII74iwaD+HJcAw5n/+EjiE681iwoABapwJ7Jh+oQ7smQNGR9y3myanOPBxLc7dniARP+EywJdebHcs7iNsCAg8
 1ZhzvuQb
 1JQe2nH2bOhmA3f9Px12ERpkU5BfmuDp0e/KUTnQKzSthnBKpa+pHItg3JPLIkbBAzuFeIw+g8P+PtrDOELv7Hg8wg//sy3o8DYb9ljShnCib5oKqSvs4HW+k/zCUIZfkoRjnB/dTzfFave8pqE0eAW77mQy89tiEIBTSlSqNyezJ+N2JPKdC51jzMRKTwwGg9gDI+yHgT1Ihld2LESW8Qlq2zmnZQoLOL30hxWpYipCIKLuxGmEu9H2AU6glHZAOVvj+U+3UtW8brfgF+Oss3Mu+84XcXnzEAARDlhCQrNn72UrxYay75xZp9VYRPBQodDJgvEPPQSrFE7a87kIiryqZ/keeXSml3/HvmKTdzAG+k5W114dQnRkfWpFGmecxa69ebyL+SxFrlJ3fBXPRHFvC6cCqoNL3NG2ojzK9bpHbqiYSP39gzLVR0MR9SMKcwwcvEBNWlqEYObC4lfQNY64GYA==
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


