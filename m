Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38297CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77CF68E0029; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5998E0021; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA31A8E002A; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B013C8E001F
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 81CEE160443
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:35 +0000 (UTC)
X-FDA: 84097415430.20.7CCE936
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id D5E8EC0009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bU5nMRV1;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844133;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=;
	b=fff++wP/LIkFeijLu8lxDS+0Xz0KyIIbs/KAMcpgwomY8iUthGpFJ5BTatV30vrHm0uB2h
	WsUCScKhmmu9VYvwvp2iP0cAGhT3FRoLXc/rrMVsCC16yhQtyAcc+ny9D01WB2Ht3Plw9z
	CjmBrE8W2SxY39pkz4JvnlKpTMDPQWY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=bU5nMRV1;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844133; a=rsa-sha256;
	cv=none;
	b=M0nx4EBWePipqeWpAaROcO4W8SrSh7To8rRxedjGahxYZIreI5M0kLyQh5NXMt2d1GvTFR
	YYGU6AjtZBl3K3+mnIrSsKqob6wwtDLzvtp10OXey5Or8vDIgEOyshX2s7/yM9RNl3GZbV
	cfqZ6dUqNqiEnvT8QcXHHW0yqnVZAUk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=; b=bU5nMRV1HYIpzFuIj1mxnQVWFT
	n5MlL7sdQ4oFxAKmM3zgYB4MJa1s+CqH9ZNp8B+3Ya1Sk2/4un/w7RJ19EUnMyzYfuYu8qrRk7hcH
	oTDp3KIiXF4tCG8m0sjz7UOahMqzTzhzG7KRPXSFEHjjYQ7qLr/gKVI236b2dFyvffsabXoyb4psw
	DkIWYkpSFC7pByhnnBnQBOGDNjxrUmDbOap+jvLg8ryyflfD/qsK/ZwW54E6ih9xa+6z61jLA2jER
	FCKsCM4k6ydDGoxsiMGR9KTlQ7i744lbTyMfdrz3LAoDhXJaikJo4uOoFBfg8DLTBoPqaoI0tbfsP
	CK5V/4YA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHp-0000000BxBh-2EXa;
	Tue, 11 Nov 2025 06:55:29 +0000
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
Subject: [PATCH v3 41/50] hypfs: switch hypfs_create_str() to returning int
Date: Tue, 11 Nov 2025 06:55:10 +0000
Message-ID: <20251111065520.2847791-42-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D5E8EC0009
X-Stat-Signature: yg1ww3ghyatpj3a683d5chqqoazpgsf7
X-Rspam-User: 
X-HE-Tag: 1762844133-766079
X-HE-Meta: U2FsdGVkX19S4mZ9kDEWL/hPd4s2WpqobLlEbtkXUxW9ozRmROlbITY1EwJSW/qyvr7SkzKS0tj/QdrZj4ud9jR/xjKmfKB5C7iNoAya36dJpbzqzArHSbmp2d6wJDse5DFueaFzxUKcHpxu9VZhKPJz2svJKF3jGUm+2nnUfIpKx1iQVGudicWm0K/T9luoMJrzvVevWXw1kimqozXk3UlNGM2OARElVmWUyxhFgU4eb+JfTQU+wh6m0UI6CAOFA4UkQawJRc0JEOek+TWmoTB3Mklj70xkoloRNmpflyGOZUjorug3oLjRN1eYPdunpawGJUKXhuDdgTbx6zzqSOX7V2poE6s9WY0pCNOVpf+lN4Nfc9AQMPtPmrGXs7L5kVWuPQKvTAf8F2+hOkucJQ3eGIqb/PqcAEh2lniCGuh8Vxlc94vCW/UKE8gdB1yLDq5yFCfl45Tu4BUNi1VQsV2m9ZGQm73g1qN199Xj8/oTV4S+++PfzOOTSw4qIguRTuCMNMJjXGrwIJW0vm5XPhudvLiNjvr9mPfS+txLNSR4e94ChYVveYfzsjxo81nzj99fd2LEwcgtRd76MrnkWhGfymEMUkMCya4NqpaSxuVubLTbtCmlafc6si2VCepRRP7QmV4vnqhgUMDTUHg2ylt+s1bTIKw0vEcr7DVT8fK6cvqmw0rubM1z4E2NqEdqjKlE2aTL55ylozyjwM1G5gncovMymevuYhU7brY7CBh1Xn0Tyc7/Xh7b5BceKsMCya+xvWnMEZP+hPwMB+S0xwrjX0VeG7woF4mP6XyiYBfoyPY5D71axVbPafvKPYoaOKffqfPmbXUcnqb6FvZlEWhMXFCvJYWNpf/lBxFmNcmVwM8Zuv6C/YXwafI0nCbCTYHeROdWWsR7gRiA5Ym1mhwOKjgyZfNFFGsUN9cHd1QkGbhm+iO/GRJ36Pbz586LvCnm5LXMGUkeM5gadKW
 cDFN2yDN
 dcHfkFLSNgN8Q6tFch2CBQVkcZmb98OZCnnfS5fKoiXhAJlilx6W9CZFtZVj6nl/ah7A6uJwuXtsoE8EmUImF7v3f97EIdbb3XdIr7WKa9a+mPvYhWRf6yJJsp90fg4eyaXve1PPZ9DKZxvQ4w9TJNFMaFqhUy1ZLErg84OvKvYBU7sa4+Ddssc1/YQejSc3jTtJx1CHK3qB3S0zaXTbRTIBGosnPpyP1SzM908mn6GMWd0T5NA8V9/xbOe4syw1Ca3If0rwuRCExPog6kmK34eHHf8RCnkVV7YJiRG3Xspg7lZcsag0bjJ8+f5keFYEtEvwi+TlxM7B+17yjLhfj0N+aCgmo6N30dLQF2HhrhgG61kNX8FpPLiPPUZx9osB/ufgjWZXlOw22BDOm4T3oiNSzTLsMFDnGGWup1ley9WK5DjF2D3Cjyj6gCml8+Yv9wU712N2/GbdciZ4RmLCNb3QYtg==
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


