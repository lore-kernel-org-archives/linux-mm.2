Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 048B4D2F036
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 14:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B7CD6B008A; Tue, 27 Jan 2026 09:38:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C206B008C; Tue, 27 Jan 2026 09:38:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B276B0092; Tue, 27 Jan 2026 09:38:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 492856B008A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 09:38:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BC731401A6
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:39 +0000 (UTC)
X-FDA: 84377999958.18.B8014C6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id A64E312000A
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 14:38:37 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PWIeUnf4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769524717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFfwAjrRh4mQezNKju2gMfLCWiP68PLgDj7Wjykp+Uk=;
	b=WFQJeUmmOpJnkCboLctEbr8puN0bffVVlX6AEABPdtQei/pbrCQk/7UiNp9vOyp8KBU3yC
	5ubsOCe6l4F+bDtbkW1B8n5fhtDFJqh2s9eqH3ri77aY1B0CqQmtqGLQGg/2nuB4Q+n6Ws
	rGMioliiW89IcfZ9cZKnCVBkS2BTQvc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PWIeUnf4;
	spf=none (imf29.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769524717; a=rsa-sha256;
	cv=none;
	b=1ATTtm2NZsPXnGUCy1tD+yKzkoj2Fs5w3HzmNUk5LRtdICFRDHFdbjuGRFTWQHUv+DNHPV
	K60/737gmVrvuO5BkRIh8Yke4ElR/BVc0A9qTHl+osZKxbgqxyaV4eu1c3irNRJfY47TbP
	IhpHHDLDj631LYni7qzcATzMwDoJi84=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=dFfwAjrRh4mQezNKju2gMfLCWiP68PLgDj7Wjykp+Uk=; b=PWIeUnf4oRHiE9UCxOc8AVN6JC
	xK1rEZD0FYsudh4HY0nB/2APUnIfyspi1GgozGWy81LPauwPEzWarfK6+hVtmZjnJM9MEbtHP898j
	0DZispTLlFbuzPwsGKECLGxXpt1+pOBCALScHcQWs525+5Lx434FvDRrd/jc8dfQXn64vA8YBYCM6
	wioLHVH8lZNDSFVPoCxBhCd6vdQ4cRrOB/HOq+Kag5UhJgigSnyOjDyl/S3KN4bKSW3r+IKwQMTpX
	Se1rdaToknhAhpWqo+KeHQS3rdMi2eyG6UiBIQvVTD+Ugil5tVdiklKUXR2kYQScdj8PNH+QVuOTC
	tAlWcMdg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkkD8-00H3bH-8P; Tue, 27 Jan 2026 14:38:30 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 27 Jan 2026 06:37:37 -0800
Subject: [PATCH v6 2/4] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260127-kho-v6-2-56f9396681c2@debian.org>
References: <20260127-kho-v6-0-56f9396681c2@debian.org>
In-Reply-To: <20260127-kho-v6-0-56f9396681c2@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=9203; i=leitao@debian.org;
 h=from:subject:message-id; bh=fBFjGCRbh8U8cSZ/cSJa5284Iw7B+/T8EZSL8NRnjyA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpeM3WjdulbFNE7ZsiXr2cBZ7aAadiSvtDild7e
 Q1wcrkuPROJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXjN1gAKCRA1o5Of/Hh3
 bZDPD/9fwANioD6pzsQEgUpAGHOIhaG9zgspZi2bhghkFkExBaoAuxBUE5iLc2xetKfL0DlhiJH
 jGt8hTUWgXxy5gtjQDOipnwCjdpBoMCsSoRmDOVbaNN3SxImfFuO4IgOUd/9+2NdBYXllVqt65H
 Szo8P/ZISwyHgqpWrYuUWcPFhNUCY3JUexB27+OrufuiBcXrDF3PtfoAGSOmO5OfXsjgFkdhPz1
 REiEc0dPmcs/RDJ5z6KnpVesEHIN8tI15Gz0sydtnUC0BdawEwgti36v5i2mDxeJ3qFwCoIubjw
 Jl/V1eE3JbIQI1GSbVeXIK+IS8XH5TPPBlBAVvGanCR9rQ3X55PVSfERC4KqDCeND2DRT1g1tDc
 gLDBsg9K2AWz17PLJhzJaoQR7E0E7SwbZRwVp3dh7pwTtWTvA60XtUncgosDbFTPHbze27A/JuH
 ld84Xnmz07hBvWm749O4quWzy/Eg6w6f+vgS67MvAs9trOGcerCBv+InGbyrssUyVDq1R9q5r0e
 raY7PjnMKgyMSmnpf/pSei/CFIeWTGZyUvlR8xBmuR4BoR6DsTtLuznHHBkPYrkcs3ayDgLD68Y
 xjsp51ZBU9dWvtk8clATOgHTA7JKzb69UlOMCN4mWYQmrGk2BzbI3siulFBcqybvCWHMm41ccEL
 Hes55jBXqIqrf7w==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: ba719ot5o1396uwoz5i3bw897ogahtqp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A64E312000A
X-HE-Tag: 1769524717-571070
X-HE-Meta: U2FsdGVkX18uaHM8We1+nCnXzLdGoQEw2Qsh9J8fboX36AMwLMKVUTCYz9Nn9P6Hhse9B8f0xeY4p2C+TLkNqDisBCOnmrmyWNskiA9lHq+fO9Y4QXumkaT7yAAuT7Rs1lZ8ZwH3BcJ1pDMRWFOYoqcxy38MpLRXv7SVT4DX/LGT8qH9Pp13FHHq2M3RTY1BfKWEQA3zJvaJffRvvB5QN9arirJpJC1sE4j+UJ21drWAnof8lkKY6d1cXBdxS+rAXuT6/1H1rrSWqEsUDUAisKA2R4x2Np6E6trnnVoq82mcCm+wt9Gm2Vg4eS1U9+Q3f2vUgq7iyKaA91VtLGjyS0OLAiG7kQ+2Mu2Ncve553UlThyu619HMVKh2Hf9xqvsVKg6kOqaM8h+DsZhW7eFGf8ILuvQdaoS9+YTbMVv6juYwkhfYPCfaqy5o+A+Ji7QttgQ7435PpRAp6lDZndDZF5R+HojZyckoytoQf0f0gPiUggtYyQHzTEWFl7lVDvqEVPiV4NNnjRlhTgldgQaTIixTwZmwY23o202OI3kgmsSXVk14uzYR5b2Xjz16A6jSyTm6U6N4SsoHE66dYPh+F/xFFiTzlRM8AZ7fXjRYIxtSlaDTLGRusMmh4hLM84PJ43gbpOn0z79+WGKlkg8M73QT5dW88ya0AtrGp0yjvYUaprYJgxvDp91uE03KNApOh2kigDCczg1UmaFxVqor2DkhL9zUJahWvfi8+AQQZePy9Dh3VEHhFdkffmtng+GijDvgTbq6prDjQY78y75UN/T4YSLKmbmba66aVtJREBlBOJSIkGtJwPCCN9kQnDqHs82YQIyJgUUgteFLTojggBYD2friBRQhb3U7+VMum/HQl9VVHZHDUwmpCFhLfxZAxj2HHr5KT0HmfnBzoi2TW260UXZpYdNhJieTaG/cjKt0Dn4m4jDxKE03MiqXqzuch3aDKKPMJrKgAjDyVf
 hykyBxUg
 T1rl/Fu820/VRu39MgX3iER+l1HrZPsFQBi4yayRQg2W+NgOzoPFe/3ndJ7hi7oZ74gq3zClcv8sFrBKKA2WXWeEi/0UB2jKd5KHEZa9fTXyi8TbD25LeqEnshRXlIysvJFJMr42KX49xFuVvfIwp5jpP+3DLscrfFCO2UX6PBFEF/zdfBoNf3WgkKGMEfO5dpqoOZnFxsckx4KY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
---
 include/linux/kexec_handover.h              |  8 ++++----
 kernel/liveupdate/kexec_handover.c          | 25 +++++++++++++------------
 kernel/liveupdate/kexec_handover_debugfs.c  | 25 +++++++++++++------------
 kernel/liveupdate/kexec_handover_internal.h | 16 ++++++++--------
 4 files changed, 38 insertions(+), 36 deletions(-)

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
index ad2da9e4e6a04..e87f77e43acef 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -723,13 +723,13 @@ static void __init kho_reserve_scratch(void)
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
@@ -738,9 +738,9 @@ static void __init kho_reserve_scratch(void)
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
@@ -763,7 +763,8 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, name, blob,
+					  size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -772,9 +773,9 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
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
@@ -796,7 +797,7 @@ void kho_remove_subtree(void *fdt)
 
 		if ((phys_addr_t)*val == target_phys) {
 			fdt_del_node(root_fdt, off);
-			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+			kho_debugfs_blob_remove(&kho_out.dbg, blob);
 			break;
 		}
 	}
@@ -1402,9 +1403,9 @@ static __init int kho_init(void)
 			init_cma_reserved_pageblock(pfn_to_page(pfn));
 	}
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt,
-					 fdt_totalsize(kho_out.fdt), true));
+	WARN_ON_ONCE(kho_debugfs_blob_add(&kho_out.dbg, "fdt",
+					  kho_out.fdt,
+					  fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 64970c88c483c..6fdb558669b7c 100644
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
@@ -130,8 +131,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
-				    fdt_totalsize(fdt));
+	err = __kho_debugfs_blob_add(&dbg->fdt_list, dir, "fdt", fdt,
+				     fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -150,8 +151,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
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
index a51f97f0fa0e6..080a62ad61ea3 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -29,19 +29,19 @@ int kho_finalize(void);
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


