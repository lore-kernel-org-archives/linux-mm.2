Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D442CED25D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 10:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5546B0012; Tue, 18 Nov 2025 05:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B736B0024; Tue, 18 Nov 2025 05:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674626B007B; Tue, 18 Nov 2025 05:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4EC3D6B0012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:01:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7AF058CFF
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:01:32 +0000 (UTC)
X-FDA: 84123285624.03.354841F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1719E14001B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 10:01:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RvpCBH5V;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763460091; a=rsa-sha256;
	cv=none;
	b=QFXkldFq0moD4NZKydU7VgAw4rKPO+tCc6oDUr0vMn7w5Wm+TyGfYkn2sTki8YDL/yD6l/
	1gnKUwMUqm6b6YcuTfFnT3Puzlm/YIqNtpS/uw1u4vHTHWiIoRznPptl0KgAa7UbvNGUw3
	uTMbn6LniRuHTNjDJ3NaYbRGZsPtK1I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=RvpCBH5V;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf26.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763460091;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=;
	b=sFExm0UewjOMPYot8D3OVAwWEzvq2l52B9dCsA0VjjgnZc6Y88GHdG09DTN/a+M8Ij4OlX
	Xbff1O+Tlb7VrBm1HF58r/FaALOkh9rJW6wrZOe7k50E6oL1jKDx5LJmbzhoovNAMg/MKl
	wYqmmqhBaLjd1aaaSg7SjCGCeOa+On0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cNupE5WP11QDcgvbWMAmFaE1TAZeWcI3mGTR58jAFHY=; b=RvpCBH5V8xAtvybZWVGuR1nmVo
	MjRxIRyzua4TPQCJjSZVgGMaEW6AwdPEurVjVteGpPWVh1hNGGyLPlT2P+Lll3CBKEX8DagW8UDsl
	k2gcSs3nFAUQ9DuhYjRrsZ8QbqS/P8H65JmcaQH2lmbFSTlt5ZSGl1vBv0mWxeBA0Wga4qge4cdUZ
	w2Bi2HsyUPG/J5vTvjAnNDfTiD/8AmWyW50Z64g4bTj2qPKA0KZ7d3DDdQnAC+RTIcU0dqLzPefS4
	x/KshpPVS1b8B0elsqHv0AQf/7gj6sW9jsquD3KpvvOLIyWYAvJ3hp2ScabcEO2jn5Pa7nuL2MCp7
	4QZFNFbw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4Z-0000000GEZo-00JA;
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
Subject: [PATCH v4 46/54] hypfs: swich hypfs_create_u64() to returning int
Date: Tue, 18 Nov 2025 05:15:55 +0000
Message-ID: <20251118051604.3868588-47-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1719E14001B
X-Stat-Signature: zjeajf9pse4fqbbz8e8ou7rk1kiikzk3
X-HE-Tag: 1763460090-544516
X-HE-Meta: U2FsdGVkX18SGKdxlKg2peFpc/dyOGjmhBxPstqziqYt5NEqj/LSfqUQ1eeEKF6g5FxHOGaIIe9FbbS4QwksaSKn+r00buGW7dDzRQPwZSgN1gRDJlPVfP62FpBbQfEw3SfQD9dTsBP2kqa1v6R7c+MfGYruuXIheL4Ah3VpCT9ZmykXiBIZbC3qXTLcIelMnZilm+YnoETdBLfMdK3O5fgwbGA6kC1JeTKkRpXZBsNcMDu62ukPUApbB9yfyYyytWOUBMSyeKrWfdDuYPSuv4KbmJpFoBdwnSjWurzXkymkDFvG8LCAjrMeE3Rxs2cQjmeHpVKrFxvJ+HALeksYlUQPgp+KQwf931GTFHlwwXZqjEXJb6DrgTBmbFKPVx4wx4nM3yNucdLted7BrafuK3j42MohbkAxhZ1ZDFlCRjfEITwNpUsnbZloApWk4+zT8jrXkTsakvbNnEmjoHWUkVqMJbB+RkChyybNTGNcAwPNHReNlUS26kuZOr487918q9f+8lVc6aMdY9ebXqJXM6IPgx0iFYjDMuFOJn7MuvKxD7Nwb7I0gA6l2AVPyaeR4FUPWl+E9lZz1njX9Wl94yj0glyEiWdLxzK6jEQHP7mBSax81wQcPny4ZuhEw3LU36G2lOL2PG7PYEZcwekCmoZAWpJsIAiLu2+D+KmG0W9Ffk4lh6f77jqVU7ipiZ1NTWo7NYadv7A0q1TcRBeq7mB1OiBttNB0qAjuCg5BS6V095TyvyC/gSa/kCfH1tcybDvDO5Zg1kX4n9KMadp5li90Bim4k1AOQFkxQswUDW0WLET7BiEHV1FCAk+MubdMMH3EOTKd67JoQ1dHBYB6jDHZK7w9aGHj4PfcdMV8mxcXW0FOafTysO8rDpzYJFyfqmZRErD4uZ7N+Zda0hhCSMF6zQlv9vld4tuGD5pWVQMlK89UhcSQTUodHvVto03U7UR1Th5INTcx2uwehvz
 QjJxHThE
 8mYVAoWCEvNz3X0tgM6A/XskQFgj4/6qSs4dWNlEMNmcUcAmAoXPo+8+/nNThTGAGzFr0PkbZBDhLRnoXobBE3nrr6s4R8RtbrwVwlCLAnFVUgq0OtiOnf1CXik3N+73Pyf/GNCe+hwLwawo5b9fqOVMj6ASr9FaO1gj9NXG992Rwv+6+Er8MqexGvO80VfUmv0yJyN3eBvvpz2A6yTV8+YGDFlYaNa+F+X3r0u6jEWIvO3GuAwoz1Hq6suvPs7ADj/hjXpYl8pzBi32E07MZhbP9iNfdQmShVIpRfScEI+La9+kcRJoIqXrEN7UaPhR+NIb/dKIjFnAw84vYMkMcfY0rl12h5l5Vh5mjxprBggEuS4yvDDiUgtiAqdkeYhSJpahY5lt2D4TKuzFX0l6kfiqm4+pL9bJN2ORP+fCo0xcxXNRkozah9PqUxi/HjUEkftfGmgyCI67mKAEVGc/f2dC5qg==
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


