Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231F9CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 00:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1EE800D9; Mon, 27 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08F38800DF; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A55AE800DF; Mon, 27 Oct 2025 20:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09504800D6
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 20:46:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9BBB1A02FE
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:25 +0000 (UTC)
X-FDA: 84045681930.01.66EB890
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF7B140013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:46:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hzjac2Xc;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761612384; a=rsa-sha256;
	cv=none;
	b=pfRHkIZyeUwHcRkxh0HU5UHEnEQvHIUFg4J2z2awj1DG7CyfMuRgWLcESf63F68Pg+UuiJ
	Ke34z7Y5zJxjPfCDi/Z0/eaDOH3J5lRXtygTFzmhzRuCMXkaGBvOKTguDrv/mk1387N5if
	RwNlrsIjjOO8V39k2lg8Je8MVZfyH+k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=hzjac2Xc;
	spf=none (imf11.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761612384;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=;
	b=bNTDowjslMNqYJktiw0lLykfsiQ9UEdSGPDrOOMchwRKTRi6fttZaAthEzJMp+iEYcPSWa
	P0aA9AMr5uLoE2hRIci83JuupmfsV24hBtCbBHmekn7U0erZfwcCR4g/67eWCz9CpN7eRp
	PSeM45b4z6uo6xtui1f0eYdNgnn2Mpc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NrCfZqIGx2QtH4dFK91zKO0X/du0eTzDDHu7mpHeJ3A=; b=hzjac2XcGzM7vx6iy4y4pMHz7c
	YvrOiKioiAMxlbKNayPq4Ci26DiSpne6cnBNtmW+PLi+Kv8TU/AsNrBvRWrH1/5ldEiEjzGsgYT9Y
	IFR2pYeIQR8b3auleenkSDmUSrEBPVfba1zbhVxMZpn6n9kXEYebKk4iat9MYD76Fp50cGZDcwWl1
	YT4NMiUHbR7zMRs0ZK2mIRrFZ6vKUaZEuVVKEVl5muqIIV0dirc1zNd7KtC3X3UXCWDEX6GuzxIAe
	WhEqFSEgQtKL9A51iu67xl8y+9dVwt7439McsK0XJGIhua2TYgNXwyGzWjrp8cr1EeelG0+qOB4dX
	/DrdQ/KQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDXqs-00000001eca-474A;
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
Subject: [PATCH v2 41/50] hypfs: switch hypfs_create_str() to returning int
Date: Tue, 28 Oct 2025 00:46:00 +0000
Message-ID: <20251028004614.393374-42-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4mrypma91g3uycpezbdjzrn4igiq39w7
X-Rspamd-Queue-Id: DF7B140013
X-Rspamd-Server: rspam09
X-HE-Tag: 1761612383-688185
X-HE-Meta: U2FsdGVkX1/YOgOdPydDd66jog7mL+VsBRCCqbOReiOzYFsQOBF8TvGCTXoaY4V+FgG8LkkSlKG5neLKjQ4mh2VZf0EQAaddlygFnV5jWkgWFJ4mtnmf0StKbJ6ZtauvWed5UR2dDglI9UN6ro12REDqViQB7Kb8P3OiQNT7wC+r4MxGhm3qwWK49ZzZ/BwYU5OZjEv7VCgDqjllAMaolqIrCsI0WJ7Mv52ypEBay8jjeTf/9+4qC/mcTTOWgilAiwrxevVY1Jet4nPJae9axQfnFQb8j8ousUAWTMJzSeg9BsnvlnCrzTIPXYEWKBoGDNHhn1BYCfhtr0j4I8I+l4TlVn7OihSNSD80ndLPyRbRUZvg8/WIrVTqx+JtPD8/rZuJDaHKcj7mXLGFjO0AWOMfZ2enO6+9SrQGsYyPPJ29RXPJ7ygD8GrUu0m22LETGPETTqrIb1Kf3K98/snqiVjYOPsPef322SHs7913NBQf6ieTPfc4KMtkH6iR2QXEKOH/yKNcJEXhub80nlIn04iIXBrh4MEkfBrMJ9W6TbsKD+3O1tB47dQhFc/agDuMZeoh9AmSxj3dbSZcVf0nWeJkOzJ6ApByup+Ngkujyj4feCAk5Iby0raE2B87wmGwCw+ET8bf6WfbuJM2QKKLB8eejHrhhj2IxynoizfkVPz36xIjCCkkJrg6oGu85lj1+Op5iKW6AunnP9Nx1nNT0Us4mGM+RS59LhjCfE2uJw0/+kUXNrCS3mHfKrXKXdnQUzdVv+3mJ8H71XSJQqeY0EkfIvTTef4qWl/jpOLgZgwUFFABFqaNH/ivxGGtvPxUpfpF7BlOna0jPdPHvd7bLRRg6yIleKNZey7BZf8eXCQ8oDF0z4TbrsFqO4D1aVdd6qyA5sPofHx/iv7DutxP488NhHe4LplISOwQuPb8B0dZzdQx8LiauhPMsjbHoTL/QYeRDaBL7ZnxEkXe9qe
 EHMr+mdL
 pUlwCUaj6T5VqsTTHq+nOZ+y7JBMT6fvm/8yqdQHgs2qpbNiHw9TrGkBxXnePgl5DMWaaOBNcF/CHTm7yfQHOUu6NJG+Qp7xtB/q6jSiZq4jRx7YkWn5i8fdjwK7nyLuh6uzG+vSIIKYQ0HD17n18kD4bTc0DadvGQbt71vxrobfXisBNElgTCnn9IaTHQlhP73asMGt+YazRgF6chnHvesLADBEeCRn2q9rUDWS5JPrRg9zzJQUgFjchabHn/sNrsWAAy0VkmIMuS+USklSLxgXZFhH5gJrvB/IV21cxUKE3v0KW++ibHJxxuXLOn5IBcW4uL5u2zyjoPMHF9nDQ3HZUwzFBP7fY/exl/r8HuN8KzKHiKGvdr3GkluBclyP4XcWqaIUczBBYsQajKrsmWZy8WPzxDYZs3ekg4ph6LdjYouZ3xQG5ss0vZbeQrv7mBGavaF8vGXdYW3l7W8Zlno5vbw==
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


