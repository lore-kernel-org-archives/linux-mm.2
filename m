Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FF69606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T8QpTmvZ
Received: by kanga.kvack.org (Postfix)
	id DE7CD6B05BB; Fri, 27 Nov 2026 07:26:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70B16B05BC; Fri, 27 Nov 2026 07:26:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11A86B05BD; Fri, 27 Nov 2026 07:26:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 94F766B05BB
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:26:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7FF0160294
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:11 +0000 (UTC)
X-FDA: 85480821342.04.4B7B82D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id E2B6B180014
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:26:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T8QpTmvZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795782370;
	b=aS4Cv7A4rzm8RNX7L7DVt81BRnrhGuyl+8HvQmyjePLegSa+yNqe8bFFw8rzMHQ0uel9b5
	hQ1CYzR3QOySpDfqAuJ9YFprhnzO7QpOZaZBcQLjRseQuDqRthThHhusUx7Yi66TUCul3p
	P4XglJ9Xbdh1jXpam/iBmbEfX0SE7Ig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=75kKPzvsdMlgmlPcHulcGoHaZEGP7r10gYVkY3tBkZo=;
	b=egAUWCqjfvcDB+Fk72ETx10uNvBuY5EbHHcJmXPwqY0vL4COf6fMscvIBiWoU/jtfW4ogy
	u+EYq6Vwjlx4mNrK0MKs+U+xfbnMgbdSJT8xCvQ4h9J5WR8tceFZYJ5/MpdRwKCqzmn8MF
	eDzQ8BEwBWu5ahS61PL/cA2OyfEAthA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T8QpTmvZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3ED89432EF;
	Fri, 27 Nov 2026 12:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136911F0089A;
	Fri, 27 Nov 2026 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795782368;
	bh=75kKPzvsdMlgmlPcHulcGoHaZEGP7r10gYVkY3tBkZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T8QpTmvZiK0wxgukaP82PoaUJV9KSkEPe8hR9/n0t45x0yoja6sGvUlEKdXYd94H9
	 cBYtfJaP7iOIcee8+9eETlZ/Gmqj9ijRoN1j9/PE5Xx5OoqT+SHNtmcDpz6+meH1qx
	 JXfxFtV6NcGPCT38HRmFKBnny+8kTBGa2ce+0AszmskMfLGqt/r+mdtmfnbkINb1Xh
	 WC5b3ykpU6M8mNrY+veveaaOqPJFnlt2bWyEWGej+lBoEyxQMZrSmpL8HXyLt5ApzA
	 gnmEecpZ4JThgjK1qM6II+l7qeNwwBoyIVBrw3nDZXXsJS08LvqwF3RjLmRTz9rz+U
	 QYAYHjfLIafEA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	David Matlack <dmatlack@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH 6/6] kho: don't reference subtree blobs as FDTs
Date: Fri, 27 Nov 2026 12:25:32 +0000
Message-ID: <20261127122536.3708770-7-pratyush@kernel.org>
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
In-Reply-To: <20261127122536.3708770-1-pratyush@kernel.org>
References: <20261127122536.3708770-1-pratyush@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2B6B180014
X-Stat-Signature: kow41oyz48gxtakpsumc8ec5y4cj6s7e
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795782369-45211
X-HE-Meta: U2FsdGVkX18In6R2tlndJe7tq3nL67JEcbtbSVFmrSnWpDR1bGyn2Fli/eBt/+oJzE+ZKMJI6tmFov1J04bQ5G4WbCjVkhcgDr9DgHYWyXSJoXsQfH6fqZ7xYg6SQsa0I8+/ORnTcGZC9xvsye7puVKE7j4IIWuJW3QVqkKJ+FKM67vhJgsgKjD/ZprMggAK6lQ85UFdomwxVyMQOaeR+zZcRjDl63VVZLsX30YD80ObyYc2bP6eviv/+Cd8WkCGp4M3bfjJXdXJjmQW4Sx3gvoL0JfNbtkuVyAs41Ur4Mpzy592kTcHEDM8EsFXONMS9aGvfG/vRbwLBCVTvLIie1VdC4J7b2lB3oCm4jBs43tEldqFOx1Gf4pr+0BdQZ0A2kg9k0zUfZ8Jopfbtqs7u2hoR7d+pPuMLXqMZUdarQGCPEIZBS6qdwQsg8snl2CScouXtbqcR3/b2uusCe6XGw7bWUPwOdS9vNvRuFXwHSSL4rVsBj8mC/Fk81sj07kmyJnUXnKszqC6D7QHat8d9209qoTdes3yQlPIGU3QVoQk/ICZ6uBqzoIXKleSWEy33DUzoJwgJVX6IRADel746NhH6Ma9vChkZa5MVL3pLdsS4MaeBmXj0dTP3KJVnnn9BNvY4VLTR9i4cnyFL7+npX1833ClcC84CSyA8JXQW/oIqVIpAG3fW6az61DTidfbg4mmtd8CbPiOetwDPbDQ+owYzKLv8x54Ms45tMgAKZXeEDnKDy0/vWa1W+dfpDAIYyReRMcRK632na2O6OaGQFPqZiCzS1EOhyIqKuQEJoaWRb9/cR2GhhXXe6R+NjDNcA6XrR2Mq4V0oucsyrc+i51D3RmuyuSEsi7zF+y4yi8fd45E/IrIBpBE3xlRvSQV59wDxIGVQrCgDZtBXfVtPrp3jEiRyqXNQ62pdfvF5yeOxKuaz4yANn6zjt1n595KmOQdJs7N3iDymGE86AO
 HS0t31RZ
 7cJMev/TcZPIATgznvWDHD8oDT+QQAZeHr2GhzrYKQCBQFWojwrIK7nsLhinQePtwfg4EIpTgNn0cOXG9OCiHa+UgXn6s04Fe2u1lLRdJTY4SWLyZaE4F53oy8DLje0F5c6eICNnn9cJxZOMAnT3wQPf5TcEKL3DsAOEb1ApDdWOvfg3Qy3IeO7UxVAJs+8U+cwVjpYcBBOQsGri8Hq+dyhuA1xidqNuQE/F8kBBmv+JFKOVR2D79YRb4uAMoLx7RrR31+YKyWr5lExUtH1wzyhJBra47PqcFvHHIWY4q77P4K3vM6vYIUo59ppOgWAo7MX4PkgEu6J1A7TSaZ3QUJUtqaA1wbQWmTAno28fYVAWF/umk3BIfJ+ITxmHNyf83knZvWSZKytt6KO6QnsmEA551eql5N+GO884ZYuhu+ISxBeSEVM0mkCV6sPF0EY1LlB1wViQcHmGswxAEkMsn7J5AZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

KHO started out with using FDT for all subtrees. This is why debugfs
used "sub_fdts" as the directory name and in the code. Since then, KHO
subtrees started also using raw C structs for serialization. Commit
4916ae386760 ("kho: rename fdt parameter to blob in
kho_add/remove_subtree()") updated some of the code to match this
reality.

Still, references to sub FDTs were left around. The data structure to
track the blobs is still called fdt_debugfs, the list of blobs is called
"fdt_list", and most importantly, the subdirectory holding them in
debugfs is called "sub_fdts".

Update all this to use blob in the naming.

The only functional change is the rename of the debugfs subdirectory
from "sub_fdts" to "sub_blobs". Everything else is a pure rename.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kho_debugfs.c  | 50 ++++++++++++++++----------------
 kernel/liveupdate/kho_internal.h |  4 +--
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/kernel/liveupdate/kho_debugfs.c b/kernel/liveupdate/kho_debugfs.c
index 8d04368c1978..1580e1a27566 100644
--- a/kernel/liveupdate/kho_debugfs.c
+++ b/kernel/liveupdate/kho_debugfs.c
@@ -17,7 +17,7 @@
 
 static struct dentry *debugfs_root;
 
-struct fdt_debugfs {
+struct kho_debugfs_blob {
 	struct list_head list;
 	struct debugfs_blob_wrapper wrapper;
 	struct dentry *file;
@@ -27,24 +27,24 @@ static int __kho_debugfs_blob_add(struct list_head *list, struct dentry *dir,
 				  const char *name, const void *blob,
 				  size_t size)
 {
-	struct fdt_debugfs *f;
+	struct kho_debugfs_blob *b;
 	struct dentry *file;
 
-	f = kmalloc_obj(*f);
-	if (!f)
+	b = kmalloc_obj(*b);
+	if (!b)
 		return -ENOMEM;
 
-	f->wrapper.data = (void *)blob;
-	f->wrapper.size = size;
+	b->wrapper.data = (void *)blob;
+	b->wrapper.size = size;
 
-	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
+	file = debugfs_create_blob(name, 0400, dir, &b->wrapper);
 	if (IS_ERR(file)) {
-		kfree(f);
+		kfree(b);
 		return PTR_ERR(file);
 	}
 
-	f->file = file;
-	list_add(&f->list, list);
+	b->file = file;
+	list_add(&b->list, list);
 
 	return 0;
 }
@@ -57,20 +57,20 @@ int kho_debugfs_blob_add(struct kho_debugfs *dbg, const char *name,
 	if (root)
 		dir = dbg->dir;
 	else
-		dir = dbg->sub_fdt_dir;
+		dir = dbg->sub_blob_dir;
 
-	return __kho_debugfs_blob_add(&dbg->fdt_list, dir, name, blob, size);
+	return __kho_debugfs_blob_add(&dbg->blob_list, dir, name, blob, size);
 }
 
 void kho_debugfs_blob_remove(struct kho_debugfs *dbg, void *blob)
 {
-	struct fdt_debugfs *ff;
+	struct kho_debugfs_blob *b;
 
-	list_for_each_entry(ff, &dbg->fdt_list, list) {
-		if (ff->wrapper.data == blob) {
-			debugfs_remove(ff->file);
-			list_del(&ff->list);
-			kfree(ff);
+	list_for_each_entry(b, &dbg->blob_list, list) {
+		if (b->wrapper.data == blob) {
+			debugfs_remove(b->file);
+			list_del(&b->list);
+			kfree(b);
 			break;
 		}
 	}
@@ -99,7 +99,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 	struct dentry *dir;
 	int err;
 
-	INIT_LIST_HEAD(&dbg->fdt_list);
+	INIT_LIST_HEAD(&dbg->blob_list);
 
 	dir = debugfs_create_dir("in", debugfs_root);
 	if (IS_ERR(dir)) {
@@ -107,7 +107,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_out;
 	}
 
-	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
+	err = __kho_debugfs_blob_add(&dbg->blob_list, dir, "fdt", fdt,
 				     fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
@@ -131,16 +131,16 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 
 __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 {
-	struct dentry *dir, *f, *sub_fdt_dir;
+	struct dentry *dir, *f, *sub_blob_dir;
 
-	INIT_LIST_HEAD(&dbg->fdt_list);
+	INIT_LIST_HEAD(&dbg->blob_list);
 
 	dir = debugfs_create_dir("out", debugfs_root);
 	if (IS_ERR(dir))
 		return -ENOMEM;
 
-	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
-	if (IS_ERR(sub_fdt_dir))
+	sub_blob_dir = debugfs_create_dir("sub_blobs", dir);
+	if (IS_ERR(sub_blob_dir))
 		goto err_rmdir;
 
 	f = debugfs_create_file("bootmem_phys", 0400, dir, NULL,
@@ -154,7 +154,7 @@ __init int kho_out_debugfs_init(struct kho_debugfs *dbg)
 		goto err_rmdir;
 
 	dbg->dir = dir;
-	dbg->sub_fdt_dir = sub_fdt_dir;
+	dbg->sub_blob_dir = sub_blob_dir;
 	return 0;
 
 err_rmdir:
diff --git a/kernel/liveupdate/kho_internal.h b/kernel/liveupdate/kho_internal.h
index 5b349f451cf6..22950fe3bcc8 100644
--- a/kernel/liveupdate/kho_internal.h
+++ b/kernel/liveupdate/kho_internal.h
@@ -11,8 +11,8 @@
 
 struct kho_debugfs {
 	struct dentry *dir;
-	struct dentry *sub_fdt_dir;
-	struct list_head fdt_list;
+	struct dentry *sub_blob_dir;
+	struct list_head blob_list;
 };
 
 #else
-- 
2.56.1.839.g22a8290db9-goog


