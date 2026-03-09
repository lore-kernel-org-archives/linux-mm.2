Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 174D1F3C24E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:42:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6016B0092; Mon,  9 Mar 2026 09:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A3176B0093; Mon,  9 Mar 2026 09:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF826B0095; Mon,  9 Mar 2026 09:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B8BA6B0092
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:42:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 17913887E5
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:34 +0000 (UTC)
X-FDA: 84526639428.29.F40F4AD
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2093D1C0003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ispJttgT
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9d/snK4xVbWikBAE/m/zmi9nqno2C5hPckyJRYlDt8s=;
	b=RTHCtYrHjLfuSYVL+kIgvXnFmaWWYyUaeNR20FnPQOHzp2JfzzNesplLhtiR51kNnvhB5N
	JQx9vDsm83wKb0pOf8TXrD5go9r4BTKaolMo7PMOBIaEtqQoQSk93biD7lxcV37+7qpoMJ
	TDdlDUAg7WYRlqmyIdmtQuOGO79Dta8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=ispJttgT;
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063752; a=rsa-sha256;
	cv=none;
	b=TU/gqF7/c3kYlSkXwrZ9ximghS6DTmDltWJVEDcM0uaXdaQAGgSaarwB2ydyJk7LcPhzDR
	y/pVWYilVrmvM5lIf85A3P/Ia96LACj+bzfpJYO49LHCEXdYStkaz/QqztinWABeP4n5QP
	gZlNaazTLLGAq4KwtJJv9rhyiSSceuI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=9d/snK4xVbWikBAE/m/zmi9nqno2C5hPckyJRYlDt8s=; b=ispJttgTKZuUuNl9uz2O19j/TS
	XTDKJszUFwGRh0B1vgPte46/UyHled4rILSSd/STz5zcA0WBBFHGZL9kp3OHfmAtTAz7DqQaIxYFE
	Bs75b6PDZtfQUZYo9/OyeCI3z7MXff718ybN+jlU7LLL7m1omfhGMYYifOetji2dsKSpRXGNynUsA
	OwkDErIFg2f9IZoEoSJehfO8quZ3NMLP8mD/ZZ9X69XrNch9GP9GUk+pTitWNQP+Sp4nTarCM/Ej2
	V0au41yJ6dLn0kpdt/Soc0DRDqRJG261yaly5Uror+hj3JAY/U8BooxLq4vHLAOLMLsDuJ9nEI7M4
	kI9FezuA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzasK-002G3Q-9T; Mon, 09 Mar 2026 13:42:24 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 06:41:45 -0700
Subject: [PATCH v8 2/6] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-kho-v8-2-c3abcf4ac750@debian.org>
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
In-Reply-To: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=10553; i=leitao@debian.org;
 h=from:subject:message-id; bh=YDthdgiQbZvgrpt+Me0u+UlmR+Dfg+aF1caFkoII/jo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprs4yIwriGYppcItJb79pnuFcumHUllGkpjheZ
 4ZCM2nxaTGJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa7OMgAKCRA1o5Of/Hh3
 bf9iD/48CLBfW2ZKolE5ndIKiButWnvgudDa1uIOBW2MDCb2rmPNP6u0Jbo0F1rBoQAVMFcN8fE
 bxAtp9xo9qham8OqEDDVKJCd9trNznYhMDYZiaDooMBMlNw1o7BBTCMfmTweLJyaYTNCH0i9j65
 ivQRWZA3oh+uwBcoVv8syD+vILmZbpNCEBXcftwwmQwKdTpdb1wN2hAqepbGYpkQIZL1UPHUsVr
 KXENuncC2DJ7Xk7aFPtOZb1tw2Tw+nUJn9fKuT+l4afWBlu+8E6O7jxgdFmeXCrkkRkHNFipFeu
 ZQ0IzoJS9sHDpxQLk46wFwFatFCmUONn2nFNUqmjVExW5BzUJgZY+Z+WBN22dT13BVd4E+LiP84
 S+VBCnspJneZuts5sbnkWHLW9g+XSfhk0FSOLjxhN3B9+MLVraWLnzjjlIBpoEU5Dt0hmkpMvTF
 xmIsvVwMoue0J7qMkUHV+Zj2+Teq+ovRu612Kx2t1O0/9/Yu2wyIpzWK1pO3pXJYHPfvaBqZogZ
 7YmtL3VrFP/AclZio/11pYSqpW/ziJEaRlYBuJXm0evj68cEN2mnT66m1EBLSlVpbc6X1lQMvSZ
 8cb70FMSvdmbHaz7RFau2OJdf/wCMb+YfIyHdSKo6D2kEUzWAfelAw4X+55LwVe+jPQGmaE/4Ef
 5zPtZP+celYcjaw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 2093D1C0003
X-Stat-Signature: hm3jrzfsup1opzkdcnjthkojoi8t3qii
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773063751-447436
X-HE-Meta: U2FsdGVkX19JdaYpbFmYGh1THtirrjszSL3fuglLDncUGH9D0pTrlfeqHFDj7xhcKwJA5S/6NCAHkFA5oE7nCBLIIwBdg+oVKFtAwSlK4e5iw8lyW/U4btqPMXRQYwjESYjx93D6v9DunlAT0jCwAO9l+pYPOD+iXkUKSPeCcSQ5tJghNf8O0u5Bi/S8uXGDxuU7msUZ8q7tR4Zn8mV7sO042njNVaH2KYsC1bQV0edZoGkTHQdow7mbw24EzGrPsDvOF6QgY6u6Kxf2zIX5Gnq6Prkkaw8r/cCMQBtHXzfzAizXyYn6TmnqAh0cyoNDssUQhvQpNw9ez4QHvj7LQqaSuPlxC/t31SI7OwHUzwDUTFUB930kDksbb2J0wMIfCm5TxSB/5tgTqzNOLz7ZDO/2PMAbe3JaOI/GHROFI268brv6ym6oyCuMRqvzARn9Q/ZTdfJicwTvF6v7XjlJ+BhiEPhY1HpjZy5kqpyxPOCNfQH87f3ujDFgzzjG6+HXoaXc8SAH1blJYwpSLMQGIlXOikNOlBVY6mlJsowHulrWd+DeUXB1xABpwAET/t8MWpGCf50dm5lT1TFRsGW0N5l8wJ+A2Rd7ZjvxKbc9SobsWQ9NaB3wYaRAB/u2sKLecUFsxj/sVJ/Y4AJo30I/ykFGNQyeLQVPgMWvi0Q0u0oBNlR1z9wa1N/bda0en1dwhu2dhzi1a8TiAWbvhMuNu81QmQV5EnZt96AYQkF7QMcm7Ulv+nIM/Mn1CgxyLUIF5QuGaHXdIPsWAvrct/3GqjMMwa9+Y83ue1pF3umT3e/QxhSmfn2H9A5xWV6ugY7kzutFIaLHsEEfPHm6Ck0F6uWgx45ldtwGKQ7isq2j+mhRg6S+z3EVPQMyfJxctl4zNgPABz6rwgOu6NFvccb4+9Ck4raixZ485tdT8RgppRmTbr1ElgkhxA5T38k7IRQzpx/8arJt1JF8LH7UnqT
 woDnrXUp
 PxhqZ8c1+XrlePgtv0DK6rh6NCC1+t3I4BvveCLzM8Q5c4vOP9Zu23ZTVC3CYVv5f98vlmmCHvjyinflz8D7ju64/vcU9jiVgCuXTzxwaKQ1CaYYZJQO20NEx0/rtqM3QcUH6RSt9LC336gsJBWAMESjgJRr73zZST7P/3YvGgeAtrDSIa+rGP9rVYfnhgCOe2SmBA2B2okTQAhORMSTS9QjXE9QKcJ/UjZ9PhX7hhyTjNHIz0N0sjmJZth4JToDseMyO
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

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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
index b5a1e09ca8f14..7a100f2bf3947 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -23,8 +23,9 @@ struct fdt_debugfs {
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
@@ -33,7 +34,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	if (!f)
 		return -ENOMEM;
 
-	f->wrapper.data = (void *)fdt;
+	f->wrapper.data = (void *)blob;
 	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
@@ -48,8 +49,8 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	return 0;
 }
 
-int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, size_t size, bool root)
+int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
+			 const void *blob, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -58,15 +59,15 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
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
@@ -112,8 +113,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
-				    fdt_totalsize(fdt));
+	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
+				     fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -132,8 +133,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
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
2.47.3


