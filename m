Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA387F46455
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:56:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631BF6B0202; Mon, 16 Mar 2026 07:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608D26B0204; Mon, 16 Mar 2026 07:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3EF6B0205; Mon, 16 Mar 2026 07:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36A946B0202
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:56:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05975B6C48
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:14 +0000 (UTC)
X-FDA: 84551773068.06.C62371C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf15.hostedemail.com (Postfix) with ESMTP id 11259A0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uCBj+Dq2
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcJSSMgXdtqSd0+U3RfszD90qV0ESOhNKpQO5qlUuk4=;
	b=CkkEIqeBnHo8xgor3eomqsXGdW2t6TmC6yMvh1CrhZZDcj/3pClLKpxoxPKHagKiblNl1P
	bjohDpYtgGrj5VvjrkEl+XyCyGbwdsWYxx0M/jmUzc9dZzvm9uNZiGtJAAJfLPmQJ79PyW
	fCXLfsGrWKfVTcqsyiexeiepqdPQWf4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662172; a=rsa-sha256;
	cv=none;
	b=4vwYCw4oHl7bInmyNjYuUCgPvxzeGU2SGA64wTeJ7whlRWRfrfA9yfF8C5ljTsyZ8Lu5u9
	Ja8R4xW4MGUVGwPDv4F76klUlccXyA+dNUwxUZa5V9RQ36XRGn2CCBKEKrd+VA0eKSDJtM
	SpY3NPJBzThRSAyNFYb29AjmHFc+c68=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=uCBj+Dq2;
	dmarc=none;
	spf=none (imf15.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=pcJSSMgXdtqSd0+U3RfszD90qV0ESOhNKpQO5qlUuk4=; b=uCBj+Dq2YKsg9NtvU0RYACTdnT
	/D42zyTmlwd2iMFWUI+GWv0Z4J6oLKf2KbDRrBV0SNbEGNNpMxZhiSt8tmnD1ECYxL1x5Ph2sUiwM
	5gsOQ5nv2vS/74qb8JF1D2svK3U25IorDO5J/jWKjSO9sYhgdkwz3Tj3JTO61N+c2ufPgkN1dCFsR
	HcCYprLUq+cHmdHAbAimKU7KtCkr9RaL+5Se1uNSGN+QLz6sRCqDZbhvthFpX29tmzX6uddHwQ8pp
	ywoh38zgsm4Nbo6MZGQN11DcIn1N1UtAEzVT915zqcjQDw+vKCnP48OAft0vJaOM1oVOsgGT5+zgZ
	eA2qa6CA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w26YN-0025yw-JG; Mon, 16 Mar 2026 11:56:10 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 16 Mar 2026 04:54:31 -0700
Subject: [PATCH v9 1/6] kho: add size parameter to kho_add_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260316-kho-v9-1-ed6dcd951988@debian.org>
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
In-Reply-To: <20260316-kho-v9-0-ed6dcd951988@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usama.arif@linux.dev, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=9305; i=leitao@debian.org;
 h=from:subject:message-id; bh=ZINrtSAqEMynn+IK2Mha2BFhMjVOo8eeR6qkY8mCn3Q=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpt+/QRUXxNVd9164+/pNrm/TpfyExDD5YV1mc3
 hmtdGhCSi2JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabfv0AAKCRA1o5Of/Hh3
 bSAYEACON8fL8GUSVSmsSJg0qQk5osBc0D9+p0+C543bZHSyImySFR8MqvWo92DDQ1C1aSbU11M
 5MEAU7zlEIzVYYulpYTL+AgGmqJTlLtd5f2BGaWwOBNwwO3g70+cUv0EdnZ/6lVjCTGH5oanM0a
 3y+Q/fUZR7VIQfzCyyBYidBA11YyYEVOl58dmezl/1T32V33/T1/zMP40VJT7Bydjjuevnbqc0j
 rCTVSuRjERl3BLIpQHszFp5URKm2REmt6mDq/pzcpcuiC3+aLR64g7So/LYK/KUMqwNCbdV+lxr
 ocSk2Ea50DGzdCO2qKMe5m5rJ+SgG55MNB4SoLONG5OLrFC8+pKUNkQWuLOUa0APxn8iIfLEYcT
 x3gZM3r0yL81+Yk0R1mblWvSRgVMTKugqHRonq7nnKr8GJ8Wpe/qnm9TwNhByyG4ASaBim2VmZA
 LszmN453122tKqMZhjMZBU8kjuSC1SvYMMRGM9M9RvRYn2S9lGFS18QjjTCUr+lOLWase31kymY
 Ha+1dZnOy+WZb2KzG7adZ4crRLAtCYyeOX1NiPLbKcCPEKyTkTxrp3j+SigkWvH1A9L9VoxIjr6
 0b5BDIHK/7xWf17om8vSaC7Vge9G9+RqC3TpwjCTJY7fyrk0a9IE2qlYaGKYdKZS4XyJau/dU/i
 j5cEVemYvfQs30Q==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 11259A0005
X-Stat-Signature: 5fez7cqtz9e19s69yz11jtmjtaqxztys
X-Rspam-User: 
X-HE-Tag: 1773662171-857193
X-HE-Meta: U2FsdGVkX18xcl6/boMoY5ptvQKJtJcn0RwjdJipv51TAEmQAMNamXI5mv0j7I0MPlLI97FsCOK2Pe7+0BaUVUlxcH8NiCCJF7zFwat77g1/4cJZN2laqlrux/VYkMCqHq6cB7kAf+Ks2RRR9YDoQAYQQID0/htK/WrD/bQ+KbDGm/mdmuXYiOfwUjgFvrcMOCr7NGMUJOBjuCrc4QtHMCDFwzaVck+0PUtE358besqhBOLg8mWpyXlJiOLazLd/lum7dnpnp4r/vBu5fxfkCwe7i4ZotpOPcjiH6yD8QyNhleI/x6SQcuf5l6kiRfYMryPGPtFHUm2f9gm7GLW5qB6I8EStPJ013i1FS1cEQiPiEtzGa8ePi6YPgtVcHWRjPmRYd6JxkeWzBovI8R9ReQDq98tnCjKRhImmFPWAZyywN8Pm8sMvvcrMjUlwPq5RJ+Bd8E8sJBjfSaPvcm6jxTthWq0vSYXqKuOfmIucbN3XoiTtXJbG7YtNXHoWr772vfCzgelwy7vFoPcoqoLQTAqiYj0ox9yE2G2mQGU+cvlGvvjKjWAG4ILMHlRokypTlwA6flh5leO6JY7l8eHPLMsmaiv6YSUzrwyENASBx1vjxiUVhz9JwQFnttmQYzhHBYqVnrAUbYLkZc2joWlEpTq1n1oa12GnXTOGaKT+y+U2cFiwDePRlMk26J39itEKTXgUXU1aWjsqChHeBTcomryPsO41lO17dEdBtweSfg/9f9KapmTvQpaYY/0xI4xnd5xlshRS1TU4mimwL9D0iVEl7sT3gGhal2LCXf8r44wyioX4ck1f9r26bnHada4Ea0qzjKPNgKUwVHGIBbggAu4/AOaNYrnk/JgrbvUZOkWP7hvlYxEVlsCAsCeu2aH+/mw8lfc1uNgz0OR/qAw/QG7ohHQeXaqA52Y8UCPkvYhQ4pVFBpQj9Ru4FKiXeqauCCOJv5xXwIgppidI3OE
 jLXLzr/G
 72QHB+vndNNtlpdfLM/ai2pjc0kzmLZ8pQFw8/DgHKdIMvD0dENYxm5ZsQo0kk5NtYiE3WIM/kB/RZPwUZWY1x3hDUihTj22IvjVUcNhH/LyCYC1T9K2mqXDYUJQQLQYanE62zFO911UtQqtONOSrk0z+vFgA4euXLQw2CbC3HVV6Ai6iH3NMH74mcHMi2YohcRd+qbeB6hBGAEY5i4qetMyC6e6eoDl9yfUX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kho_add_subtree() assumes the fdt argument is always an FDT and calls
fdt_totalsize() on it in the debugfs code path. This assumption will
break if a caller passes arbitrary data instead of an FDT.

When CONFIG_KEXEC_HANDOVER_DEBUGFS is enabled, kho_debugfs_fdt_add()
calls __kho_debugfs_fdt_add(), which executes:

    f->wrapper.size = fdt_totalsize(fdt);

Fix this by adding an explicit size parameter to kho_add_subtree() so
callers specify the blob size. This allows subtrees to contain
arbitrary data formats, not just FDTs. Update all callers:

  - memblock.c: use fdt_totalsize(fdt)
  - luo_core.c: use fdt_totalsize(fdt_out)
  - test_kho.c: use fdt_totalsize()
  - kexec_handover.c (root fdt): use fdt_totalsize(kho_out.fdt)

Also update __kho_debugfs_fdt_add() to receive the size explicitly
instead of computing it internally via fdt_totalsize(). In
kho_in_debugfs_init(), pass fdt_totalsize() for the root FDT and
sub-blobs since all current users are FDTs. A subsequent patch will
persist the size in the KHO FDT so the incoming side can handle
non-FDT blobs correctly.

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kexec_handover.h              |  4 ++--
 kernel/liveupdate/kexec_handover.c          |  8 +++++---
 kernel/liveupdate/kexec_handover_debugfs.c  | 15 +++++++++------
 kernel/liveupdate/kexec_handover_internal.h |  5 +++--
 kernel/liveupdate/luo_core.c                |  3 ++-
 lib/test_kho.c                              |  3 ++-
 mm/memblock.c                               |  2 +-
 7 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ac4129d1d7416..abb1d324f42d0 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -32,7 +32,7 @@ void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt, size_t size);
 void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
@@ -97,7 +97,7 @@ static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	return NULL;
 }
 
-static inline int kho_add_subtree(const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b64f36a452965..55bdc5d2d1929 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -752,6 +752,7 @@ static void __init kho_reserve_scratch(void)
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
+ * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
  * the physical address of @fdt. The pages of @fdt must also be preserved
@@ -763,7 +764,7 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	phys_addr_t phys = virt_to_phys(fdt);
 	void *root_fdt = kho_out.fdt;
@@ -788,7 +789,7 @@ int kho_add_subtree(const char *name, void *fdt)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -1452,7 +1453,8 @@ static __init int kho_init(void)
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
+					 kho_out.fdt,
+					 fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index acf3682226824..ca0153736af13 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -25,7 +25,7 @@ struct fdt_debugfs {
 };
 
 static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-				 const char *name, const void *fdt)
+				 const char *name, const void *fdt, size_t size)
 {
 	struct fdt_debugfs *f;
 	struct dentry *file;
@@ -35,7 +35,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 		return -ENOMEM;
 
 	f->wrapper.data = (void *)fdt;
-	f->wrapper.size = fdt_totalsize(fdt);
+	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
 	if (IS_ERR(file)) {
@@ -50,7 +50,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 }
 
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root)
+			const void *fdt, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -59,7 +59,7 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 	else
 		dir = dbg->sub_fdt_dir;
 
-	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
+	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt, size);
 }
 
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
@@ -113,7 +113,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
+				    fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -121,6 +122,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
+		void *sub_fdt;
 
 		fdt_phys = fdt_getprop(fdt, child, KHO_FDT_SUB_TREE_PROP_NAME, &len);
 		if (!fdt_phys)
@@ -130,8 +132,9 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 				name, len);
 			continue;
 		}
+		sub_fdt = phys_to_virt(*fdt_phys);
 		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
-					    phys_to_virt(*fdt_phys));
+					    sub_fdt, fdt_totalsize(sub_fdt));
 		if (err) {
 			pr_warn("failed to add fdt %s to debugfs: %pe\n", name,
 				ERR_PTR(err));
diff --git a/kernel/liveupdate/kexec_handover_internal.h b/kernel/liveupdate/kexec_handover_internal.h
index 9a832a35254cf..2a28cb8db9b0a 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -27,7 +27,7 @@ int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root);
+			const void *fdt, size_t size, bool root);
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
@@ -35,7 +35,8 @@ static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 				       const void *fdt) { }
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
 static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-				      const void *fdt, bool root) { return 0; }
+				      const void *fdt, size_t size,
+				      bool root) { return 0; }
 static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
 					  void *fdt) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 84ac728d63baa..04d06a0906c0e 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -172,7 +172,8 @@ static int __init luo_fdt_setup(void)
 	if (err)
 		goto exit_free;
 
-	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out);
+	err = kho_add_subtree(LUO_FDT_KHO_ENTRY_NAME, fdt_out,
+			      fdt_totalsize(fdt_out));
 	if (err)
 		goto exit_free;
 	luo_global.fdt_out = fdt_out;
diff --git a/lib/test_kho.c b/lib/test_kho.c
index 7ef9e40618696..2631824373152 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -143,7 +143,8 @@ static int kho_test_preserve(struct kho_test_state *state)
 	if (err)
 		goto err_unpreserve_data;
 
-	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
+	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt),
+			      fdt_totalsize(folio_address(state->fdt)));
 	if (err)
 		goto err_unpreserve_data;
 
diff --git a/mm/memblock.c b/mm/memblock.c
index ae6a5af46bd78..29e12ea2a854c 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2488,7 +2488,7 @@ static int __init prepare_kho_fdt(void)
 	if (err)
 		goto err_unpreserve_fdt;
 
-	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt, fdt_totalsize(fdt));
 	if (err)
 		goto err_unpreserve_fdt;
 

-- 
2.52.0


