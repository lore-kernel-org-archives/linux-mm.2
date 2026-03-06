Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03054F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:39:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A7346B008A; Fri,  6 Mar 2026 07:39:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 549CC6B008C; Fri,  6 Mar 2026 07:39:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32E596B0093; Fri,  6 Mar 2026 07:39:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CDE06B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:39:51 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB7488BF84
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:50 +0000 (UTC)
X-FDA: 84515594940.28.747A902
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id BF46140008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:39:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hB9MGqs4
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9ZZhOrRGryuFNle00hDqS1xUJYiiR7dmjtWIiWkagc=;
	b=67Zdk/z3KCfdKAbgjIZ/XmKOieI7PGUeENoX+OF00cSkZ9RMWaYWVvHS4ehr7+fzHCRDX5
	SP0p0uJvMAmWmGZj7UYXEhFkxu9+bXk1jc7g3c5XiIycZ480KE+pl1amJvHxJGuWa04846
	xyBhDXuEAWWhYBmBa3cYjJfCsBIEbHg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hB9MGqs4;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800789; a=rsa-sha256;
	cv=none;
	b=dA9abU439MXfagq4o8qlf5ky4vuWTfvN1g05aCkA5eaUX84D4IVTwAJGdVLJeOZq+Ml1ID
	twT4ZEmj4Vrbs8WaGJLmQRQ7gshpfXL8x17UwT6BGIgUSUO+HVZAAi/ezDiRq2NWpho4WO
	s9g2ipL1odKPjvYGjiAAQF2lqOU5my8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=/9ZZhOrRGryuFNle00hDqS1xUJYiiR7dmjtWIiWkagc=; b=hB9MGqs4culLZLiYWcWP3nDmG6
	8dL3LATUrnFdhwEr3deIpYBrFS4ATW2ogSywz3ypFEFuqAVd63tunxm1cK8WjSWYjNSidP+ySbpeK
	1A54Mgp/TxEPAS1S7gT0R3GFlfIeyRP7HAzNokpV+KSG2yF4nUWXMSRp3kaYpar6F/r52+UZONjzF
	//mHO5C64a/pxDXXzsb1RYyv7196ZPAiEL3fJL8W1C5oaw07bQcYYrElU+qA2PnTxkOwBhSdCKLne
	lLOtzEEYiwGqEUZi86quSUTpKD+Zd+vdSkFosHTEGsaF1TPOyVWT+d3oU8pnplQamIscWxQZ+IqLY
	P6chfsyQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyUT1-00HVQp-Id; Fri, 06 Mar 2026 12:39:43 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Mar 2026 04:39:20 -0800
Subject: [PATCH v7 1/6] kho: add size parameter to kho_add_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kho-v7-1-404d14c188bb@debian.org>
References: <20260306-kho-v7-0-404d14c188bb@debian.org>
In-Reply-To: <20260306-kho-v7-0-404d14c188bb@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=9284; i=leitao@debian.org;
 h=from:subject:message-id; bh=aU0aIKTD5Anicm9v3gMTJTcMaA4+bBorKPfkcBjPpeQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqssG94pdUHt2hmIjeeygau4tEj4H7e4RiVM+0
 3hciBh7d6mJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaarLBgAKCRA1o5Of/Hh3
 bV1FD/9q+a1pubFJwKs2Fvw8WVcCZJoO1Xh09djVVEtaRVNIMy3iRNq+Fy7fdj34BmZP58w5TUE
 NTNmmyrLr/1Jol6JJnNl4UGjO0SrEvq2e/i/ypRC7Rdb//UhIQDodVq5NTPkJdOcJzAKnv96iTf
 gyNpB4Y+P2YAceP2EsEtYNudAzVvlfQP/ORXVniZqRX0fTcztGpjk4p6of9TrnG81g51X0uLtIr
 yU6VJB2XeF0OqGBm4ZlyHw9NnILYBPTUd2b6d97jjzzITajP+GlVdBNfwpnZAxI7mJOLuWFkbj9
 xsaLzX5E+QFy6RONDOkExKdyN0zjdpbCPqkzZOcBkEmgesh67NiS5k45CA9BDedXKvmu1/POWSl
 8S0BpxPL6j9hjhcU24WzS+QbkPvv+vcdmFCFUt825p0D7iKy11P0LdMdjV3j6Fx4kny9kmXwwJ9
 ZwNCkJGfs8A/KgpRzj/8bBuY/0GDibSHsw27Jgqkz77WPXNNrPbHyP/b60FODl26RskKjhXuSLa
 CJOxiay+R8+KW7mzHKCJC6wGeUph1YeqnLrBdD7SFWPEIxoYF9PIQSE7Mv19IYIw9aT0ayKgFiU
 /fEi0QRw7CItLpPj4Ht/FkF+IwSxNT4FoGUYkaVhLbZpkPnulNonuZgy8FIx0QhOQ7Ha+tOycC7
 OV19Rd7ZECwmmfQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: BF46140008
X-Stat-Signature: wmh5raehex9w11f1ty46mh73dmt48dr5
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772800788-415331
X-HE-Meta: U2FsdGVkX18Q7D/anYzKNFhr0K4AfWhDCVLgSTdg6sHtYH3TI6h2I9Snjm3ASG/2v1SG2D7o3Jf/ccEBLl6UEXLS82AWgg7t1AF2aG2pdeZJ2EoVLdzDb6/K0i4ePRr0Pg16UrxtbuyKR8OT+E6eqKXE08fYTmi2PcQnjC1z0o7cWVnhNrhNHk1UK0emJQYUrtPX5Wc9XaKmBi94KWVS1vdyC3XYHZClmhWTd8HpKMuq0xtsXimHt/3GUxVkmka4NNoFrOtKfpiVgKQ26gA9RDw4bYnofiOLSS43bPnsRenaqqMlhz6Gz7n3IBeug4GzJK+9BP9AgGceyoN77bULX9S0fFsHpcRcnDUS5N8+nlenF1unsyfbtnCtOBFdvPZqYflpIP+Usev7bMe4Y6Z8UmElV8V7w2WgkhrHB35Y8OCA5J9/2xy04LBeYQou7kuoq9ZoM4UftK4h/F52MN9rvgJ/lpMeViHOfTPlZNF/zJ+Co4ICReaHyvDVcWXDedNn4mDGzO0bDKMMMLsOQ8WWJo8haKt3CxjQgvhnw7M8vFd2YKpiOxPnikFEcavPBrvCmS6HTz4AKp51EzuoFU8GWvkx80+DomS5i72HqXCrJcbqgRr+7yFkFsz8PN2IghAtxlTJQ86vs+hQAYlIjosGxBLJakIKrNVlPhNGxtr2Gfy43xvRYJyMWjrf1AxbPS403rX+kmEELKD23urujhpqx56S41mTA4kAENpCw8ad5ZzzmqxcWTbX1V+23sc427wMWjyzgN3uE+yZgadaAEKUTHFm0pB8n8kQmEM+gZCJjcbszops8bomP6aIuTGEVg02OEPJ0FGQtW8eMf7wN9DsZUdKfhYmVOBC6qXfjd88HtrH6lPH6yPUojlhN0BOVICtxwHTPMfvoOBVtQ/NhHQ0tDn8I6+lRGD8Um6Kc0sLrH+QnH0Dp/TETFMeDs/2Wydf7CQROoXI49Xtgir4vyD
 Wci4FDQQ
 XtUHlum6F/YxXjKxQ5b+jhZ8vtkN52g3vcRxIo6L/tvmX46t1ZUgvTA5CmQr929xecwCCnhWCG6BLKyatbz7yKUo9BVFPL/jBVlm00QuVUnJsbm+CT12O+448zCYX1UTfYXjKzifVlSbHpHxlcIdR8ryLhIw4EGInnFz1HwYGrvlxHR7UZrU2HPEHgZN+kMHOjg1xuUajzA+Q2sQIi4ch9fEIZ32KSeZC7dCt
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
index 3f395fbd978f4..b5a1e09ca8f14 100644
--- a/kernel/liveupdate/kexec_handover_debugfs.c
+++ b/kernel/liveupdate/kexec_handover_debugfs.c
@@ -24,7 +24,7 @@ struct fdt_debugfs {
 };
 
 static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-				 const char *name, const void *fdt)
+				 const char *name, const void *fdt, size_t size)
 {
 	struct fdt_debugfs *f;
 	struct dentry *file;
@@ -34,7 +34,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 		return -ENOMEM;
 
 	f->wrapper.data = (void *)fdt;
-	f->wrapper.size = fdt_totalsize(fdt);
+	f->wrapper.size = size;
 
 	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
 	if (IS_ERR(file)) {
@@ -49,7 +49,7 @@ static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 }
 
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root)
+			const void *fdt, size_t size, bool root)
 {
 	struct dentry *dir;
 
@@ -58,7 +58,7 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 	else
 		dir = dbg->sub_fdt_dir;
 
-	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
+	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt, size);
 }
 
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
@@ -112,7 +112,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
+				    fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -120,6 +121,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
+		void *sub_fdt;
 
 		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
 		if (!fdt_phys)
@@ -129,8 +131,9 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
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
2.47.3


