Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55042F46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF0826B0204; Mon, 16 Mar 2026 07:56:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9DC96B0206; Mon, 16 Mar 2026 07:56:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93506B0207; Mon, 16 Mar 2026 07:56:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94C286B0204
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:56:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DED089140
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:18 +0000 (UTC)
X-FDA: 84551773236.12.30BD4A1
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 36D7E8000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dMJerSV4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wR2D4Vlv0K3VWoQ+q8ZEgWqatcXgCMFwIfCjQmN6kzQ=;
	b=5tCOHgzyLCbiblHQT5IK3iE+HQwqMGfwMO997Ag7/Q6xlWYmTlvDwExtlZ7i2cw+ViTDRe
	gcpqnfKWkECmGZkKSwpr1VmtQYXm9xZtGAmsAlhPwaRGOgbXuACmViwuSJuMo392Nt9TaO
	YwsWpoTZgNwLqvmST8xqJBo5ityZxbw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dMJerSV4;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662176; a=rsa-sha256;
	cv=none;
	b=uOYUxxnIDtgsA+G48+OKCGUBrk1KP2pCKik/1QhmessoWu/TsIN/IF4gnO7JqSX4LUmE5B
	vTYUKarone6/jZYv69V+yxnzg8LIL5vHNNkcdkeyBxOoHxzYIhLBIC8f97cc+jkj5z+1Es
	nAyTWi0f2IIIMG+0wbu6GzgN9+AitlI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=wR2D4Vlv0K3VWoQ+q8ZEgWqatcXgCMFwIfCjQmN6kzQ=; b=dMJerSV4Mo2MYbBXEM69PSlM3W
	FSE0xxylVaUkW+B3rB7PUF0d/xllN+XomolFIi+S24BnKr3RKcGGGHk3cksTgSQKDSXQ7Ij//qLxH
	Agx69pDEyjN2TDENin8uwz7UniLZgfBwFQut4ZgAK+DlEXhgoS6iJQxN0Nn+0tVzxV8iuNIfOad2v
	hz0CRpujeaBV6MMIjvduRUIH1LUbJQHBYWde6bs7AdJskbpxN/55loal0mYbyWusXFclS7V+N+uUO
	0RyMjzIWFHXa9iiT4eIA8jHj3EXO7FWRnIoId6+82yaqARjot+ogPGQEvQ9XwRY6bQqHlkQdnQfgr
	Aj8/72BA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w26YR-0025z6-Oi; Mon, 16 Mar 2026 11:56:14 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 16 Mar 2026 04:54:32 -0700
Subject: [PATCH v9 2/6] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260316-kho-v9-2-ed6dcd951988@debian.org>
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
In-Reply-To: <20260316-kho-v9-0-ed6dcd951988@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usama.arif@linux.dev, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=10604; i=leitao@debian.org;
 h=from:subject:message-id; bh=A5hGUTB5B0dJRe//bQuK51G/RASyzCe8VrBsohQJcGY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpt+/Q3ZH1Cv0gPlft2JktXnWVuSCm8gN3rEeD8
 b2ojEXQT2qJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabfv0AAKCRA1o5Of/Hh3
 bckCD/oCwQ56RbqMQAttItawUCeGpKIaGkkVCcvSAe5uAHHCJ+bOJNuEiUi16QQABPOxIZyIFYx
 /xID8G/oplIbvOvQvBQxh6FTPKBp61duWRBepzDCsctPyXQbZaSRIZcPM2BEpjz2ET2oXGm/+5l
 eq2Z11fGqKwkall0l4bv99sFyNN3LoTJoIxqxhGHf08MOtALoEMy0eVy2i2VkM0PJz+KqwbAzOw
 VqL5iLDnLru/drgRpXnDHfMMKYZ0ItTAWHhI+gBWISAHFP9jysTEvVGyULpry7A1/GI9crjd1wu
 CaDvefDowQGYCjcotGPm9DSWGcrdGeW1Dw/xHa3Bi2PkS7slgLVfqMlsdea4RDEcnmxGIqj2soz
 KJw1YcNRdanKfweBBeBmH7Xzf0GUTfKeBZWWwtMNgYfDLbf0N2MLZzKCF+6VDTszoZRUu0OhaRI
 uE9ket21U+XahlbImPUjgD84dMfnLtiPCDqi9P3bZaQx8adZcnMf8KRnHmAGr/Ov1cVkZWrilI7
 tZ9koGnSmMUGYL4znSIzuzlUhbJYqRSjlfUzXcEJOYHy18SJlSaf+id+gLrcfni61TBQI935sag
 kkzxOy4A0fS9vRxWwoHDNyA6/0B3m7QyaS5l9G4REHyJGsuzojY54O75CtyGtY/rJWD85ocbAUX
 UCi0HZ0zQoIc/ZQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 36D7E8000E
X-Stat-Signature: wk6hry7ks6ao1drd1fydf1oe1ss1wfgw
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773662175-807458
X-HE-Meta: U2FsdGVkX19PG4mJsrfvAnckvsY18cx8mVXaTKFBp6/oKekvvuVy+2jtCH0GqEMo+AcQsKCr258SorJ8Mti0DQ50Bxhe1CkId+d0CRsQWpG2FRolHTtlBbkkuFAuoOtpDvpLVoGVDTmIeP2kwQ4njGW8CK999lVA29m5ZUx+ndLRCV+tNCPk1g1r8Fb6hApOm1sYOlmYuLpAzL3TsTUMY4+yEVmBraoGgG2GDdUTuDbaDB+zfQiUvJOg7eN3ghBiX45VWoQOYyBMx2WtZ0q/PlpqXexIUkEKGK3EAEZXzD+cnh1os9xyDWJ0kNxDNC7S8FFHs3ZYNwTieftWs/K2twtcJ1ezF5bjF/QdXrF+RXh4d0KQJW0zc9J0Z7JF45Cce3kiH5MzVHpXFJC76Ms7hGTHPE1XVpnWJP0G1xKqa3pok4vonePa6xQGIvFp6cu2pZdwAXUH5sy5KY6JnnIbZRTAQzBWRL7k2s9mZwgl4XVcDkrbGb/U9RaA1Yg2YOHDtzC86jR3Ffgwmv6mlEeK6zfFPiyaqRZ/0Jc65iqPt+hlmy/LdeVNp3vnhdhKPV457wpG//LU21XaDh8AdfHcdGdiVxFx5bP2KCEzCtPoCsUlPSStemn+SYHk1KlMdz2fwSSz1g8WUazhnFjRcXD8+OJS4q9mz+aZLG9zBpKpy4r3JQEK2o/5XrgdBXYXckNzEGxr1TvRZfAlK+nnF4m92Mb7lrNv2NYqLqvFna+yJEzNBxMG81VHA/ImiiwiAHeNmguc6hHNcm5abTHpMkrkaEyg7+BbGeU6mdORpAJfrdrzdf6qC5QyJhFFw7CR1x9aGLpOuA4iGIAHGNd53lT+OZZbCpcRhbkAQAf10eNwEqUzzFY/N3ZypDxSoNdeAyo1qJzIUonQnYvdvrmJUvbHR0LivrryK2tHXpgaJ9MjK6dDlcnWWNqFHZWppVzAPAJJB9BGoLcFuYk1sKY5W/q
 0jNLh223
 qKbjPpT6RcFDPJ2kChBvzuvOIBEHw0uOcZJW/316cvobU8EkvbaGzzP5NM4tDCfIM1gCjl1Omel8hq2hXAK6aL01qJTP2urnnb52BmXvsG3bM/joXbscEw+6S+cpAt3cRXNEpdRmzo3LyfklkUBBYCU58ymfPk+Pj0qFug5FVkDKEEiAAo5A2BCtZTe4XZPw2nekDHvLjWbFwHqzz6Fdh7oGTs7j/2ctDnAqoqGMd30IpbX9oMSTvWIAfvDHU2IS0PmfW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since kho_add_subtree() now accepts arbitrary data blobs (not just
FDTs), rename the parameter from 'fdt' to 'blob' to better reflect
its purpose. Apply the same rename to kho_remove_subtree() for
consistency.

Also rename kho_debugfs_fdt_add() and kho_debugfs_fdt_remove() to
kho_debugfs_blob_add() and kho_debugfs_blob_remove() respectively,
with the same parameter rename from 'fdt' to 'blob'.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/mm/kho.rst        |  2 +-
 include/linux/kexec_handover.h              |  8 +++----
 kernel/liveupdate/kexec_handover.c          | 33 +++++++++++++++--------------
 kernel/liveupdate/kexec_handover_debugfs.c  | 25 +++++++++++-----------
 kernel/liveupdate/kexec_handover_internal.h | 16 +++++++-------
 5 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index cb9a20f649206..6a4ddf3440465 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -80,5 +80,5 @@ stabilized.
     it finished to interpret their metadata.
 
 ``/sys/kernel/debug/kho/in/sub_fdts/``
-    Similar to ``kho/out/sub_fdts/``, but contains sub FDT blobs
+    Similar to ``kho/out/sub_fdts/``, but contains sub blobs
     of KHO producers passed from the old kernel.
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index abb1d324f42d0..0666cf298c7f4 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -32,8 +32,8 @@ void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(const char *name, void *fdt, size_t size);
-void kho_remove_subtree(void *fdt);
+int kho_add_subtree(const char *name, void *blob, size_t size);
+void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
 void kho_memory_init(void);
@@ -97,12 +97,12 @@ static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	return NULL;
 }
 
-static inline int kho_add_subtree(const char *name, void *fdt, size_t size)
+static inline int kho_add_subtree(const char *name, void *blob, size_t size)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_remove_subtree(void *fdt) { }
+static inline void kho_remove_subtree(void *blob) { }
 
 static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 55bdc5d2d1929..54fe59fe43acd 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -749,13 +749,13 @@ static void __init kho_reserve_scratch(void)
 }
 
 /**
- * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
+ * kho_add_subtree - record the physical address of a sub blob in KHO root tree.
  * @name: name of the sub tree.
- * @fdt: the sub tree blob.
+ * @blob: the sub tree blob.
  * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
- * the physical address of @fdt. The pages of @fdt must also be preserved
+ * the physical address of @blob. The pages of @blob must also be preserved
  * by KHO for the new kernel to retrieve it after kexec.
  *
  * A debugfs blob entry is also created at
@@ -764,9 +764,9 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt, size_t size)
+int kho_add_subtree(const char *name, void *blob, size_t size)
 {
-	phys_addr_t phys = virt_to_phys(fdt);
+	phys_addr_t phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
 	int err = -ENOMEM;
 	int off, fdt_err;
@@ -789,7 +789,8 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
+					  size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -798,9 +799,9 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-void kho_remove_subtree(void *fdt)
+void kho_remove_subtree(void *blob)
 {
-	phys_addr_t target_phys = virt_to_phys(fdt);
+	phys_addr_t target_phys = virt_to_phys(blob);
 	void *root_fdt = kho_out.fdt;
 	int off;
 	int err;
@@ -822,7 +823,7 @@ void kho_remove_subtree(void *fdt)
 
 		if ((phys_addr_t)*val == target_phys) {
 			fdt_del_node(root_fdt, off);
-			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+			kho_debugfs_blob_remove(&kho_out.dbg, blob);
 			break;
 		}
 	}
@@ -1310,11 +1311,11 @@ bool is_kho_boot(void)
 EXPORT_SYMBOL_GPL(is_kho_boot);
 
 /**
- * kho_retrieve_subtree - retrieve a preserved sub FDT by its name.
- * @name: the name of the sub FDT passed to kho_add_subtree().
- * @phys: if found, the physical address of the sub FDT is stored in @phys.
+ * kho_retrieve_subtree - retrieve a preserved sub blob by its name.
+ * @name: the name of the sub blob passed to kho_add_subtree().
+ * @phys: if found, the physical address of the sub blob is stored in @phys.
  *
- * Retrieve a preserved sub FDT named @name and store its physical
+ * Retrieve a preserved sub blob named @name and store its physical
  * address in @phys.
  *
  * Return: 0 on success, error code on failure
@@ -1452,9 +1453,9 @@ static __init int kho_init(void)
 		return 0;
 	}
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt,
-					 fdt_totalsize(kho_out.fdt), true));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, "fdt",
+					  kho_out.fdt,
+					  fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index ca0153736af13..cab923e4f5c8d 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -24,8 +24,9 @@ struct fdt_debugfs {
 	struct dentry *file;
 };
 
-static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-				 const char *name, const void *fdt, size_t size)
+static int __kho_debugfs_blob_add(struct list_head *list, struct dentry *dir,
+				  const char *name, const void *blob,
+				  size_t size)
 {
 	struct fdt_debugfs *f;
 	struct dentry *file;
@@ -34,7 +35,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	if (!f)
 		return -ENOMEM;
 
-	f->wrapper.data = (void *)fdt;
+	f->wrapper.data = (void *)blob;
 	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
@@ -49,8 +50,8 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	return 0;
 }
 
-int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, size_t size, bool root)
+int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
+			 const void *blob, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -59,15 +60,15 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 	else
 		dir = dbg->sub_fdt_dir;
 
-	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt, size);
+	return __kho_debugfs_blob_add(&dbg->fdt_list, dir, name, blob, size);
 }
 
-void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
+void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob)
 {
 	struct fdt_debugfs *ff;
 
 	list_for_each_entry(ff, &dbg->fdt_list, list) {
-		if (ff->wrapper.data == fdt) {
+		if (ff->wrapper.data == blob) {
 			debugfs_remove(ff->file);
 			list_del(&ff->list);
 			kfree(ff);
@@ -113,8 +114,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
-				    fdt_totalsize(fdt));
+	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
+				     fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -133,8 +134,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 			continue;
 		}
 		sub_fdt = phys_to_virt(*fdt_phys);
-		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
-					    sub_fdt, fdt_totalsize(sub_fdt));
+		err = __kho_debugfs_blob_add(&dbg->fdt_list, sub_fdt_dir, name,
+					     sub_fdt, fdt_totalsize(sub_fdt));
 		if (err) {
 			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
 				ERR_PTR(err));
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 2a28cb8db9b0a..0399ff1077750 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -26,19 +26,19 @@ extern unsigned int kho_scratch_cnt;
 int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
-int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, size_t size, bool root);
-void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
+int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
+			 const void *blob, size_t size, bool root);
+void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
-static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-				      const void *fdt, size_t size,
-				      bool root) { return 0; }
-static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
-					  void *fdt) { }
+static inline int kho_debugfs_blob_add(struct kho_debugfs *dbg,
+				       const char *name, const void *blob,
+				       size_t size, bool root) { return 0; }
+static inline void kho_debugfs_blob_remove(struct kho_debugfs *dbg,
+					   void *blob) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
 #ifdef CONFIG_KEXEC_HANDOVER_DEBUG

-- 
2.52.0


