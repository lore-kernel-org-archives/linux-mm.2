Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D59CE63C8C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981E26B0005; Mon, 26 Jan 2026 11:08:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959166B0089; Mon, 26 Jan 2026 11:08:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85B9C6B008A; Mon, 26 Jan 2026 11:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75C8C6B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:08:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 167B8160879
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:00 +0000 (UTC)
X-FDA: 84374596320.27.1DD84E6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf20.hostedemail.com (Postfix) with ESMTP id 014771C000E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:07:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OsLdwa4q
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769443678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcVEbqYjXo+vbfkN5MEuD8sag+j4VsDI2mVcphwug/E=;
	b=1w8p7HX+SmzeXvDN37p3nbjnByEii5NAzHh4+UkIFDXtrSxPdCWsTXQU0GGX2BEo8UB9jw
	Z1cFedjS+B1NvLdRNVcNxKH6W6PvtIJ4WuFCVQWsdUC9i4npSQBDrc99JPQSd7nBp+vEJw
	lTC25taU3rVswuoVCxp7mMbPItMJ1vM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OsLdwa4q;
	spf=none (imf20.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769443678; a=rsa-sha256;
	cv=none;
	b=K/cF1eFt5NorBTjN6T8x7V1GGvEUy3bNUTE/tzDSJK8XxECR3Gi/kPCNm0OlqRuJnu61F8
	se0nwFszbBDyZdlefpsck5i9mlx6jNa4SWG6UuYdbDaVyuqjL8T+tR7YTWVkBruhNB56Dp
	d8bN7x2m78gDBKAXBPrhQ9zY6sQxCUI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=FcVEbqYjXo+vbfkN5MEuD8sag+j4VsDI2mVcphwug/E=; b=OsLdwa4qS2h6tHE1R1H3cM2dNU
	7GYYoJku2Gwjj/WtI0D7hpoRmGQdBBWHE3jt3m7Ffl2eSDgyBVYbPRzbqL8HGKqHz9nVmL641BLxY
	IZCnxvktmiwhoxHjsT85b7HCxuiycygkDqsuWhPVu/9GtWtzeE8ZC0sfX8suSVlZChxRpFrU82/r6
	cxQ0y/xMVzPtOTjFq8J6K/MucUY9V9uVGmGF/wTOPRjkf6mWhGx7R3CBlBmiVpUH9sL4MK70GMcjt
	xZW+44BaDVt2/m6Q2/I69cAQK0j+CtgT0MS2Gvc+F4eQROn4HoEhhRIS+/kw2roOmm/99XTwVWacX
	C+bdbrZQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkP84-00GI7D-2y; Mon, 26 Jan 2026 16:07:52 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 26 Jan 2026 08:07:23 -0800
Subject: [PATCH v5 1/4] kho: add size parameter to kho_add_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-kho-v5-1-7cd0f69ab204@debian.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
In-Reply-To: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=9034; i=leitao@debian.org;
 h=from:subject:message-id; bh=a3/6itsyojDSXSTBztKTcvsoFClmMU0YCgGoRYLdYE4=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpd5FN3jRWa5R68zJ7vUANtZyd+HhEj2dt+9+eD
 HLUzMdQtPqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXeRTQAKCRA1o5Of/Hh3
 bY3VD/9tgnkHEY/vJUUV5MNFlNjAT3ppl5wnL1PJW5WAYWrFpKDUYVh5XRwsoFdVAfBDET59ArC
 aapjFAvwIdsoblbQmr0xEzTeXt528VzrKZj1q7f6p1mBjVusezNSFlOzSmhmsPVa+X/4UIEtEPY
 vYsRxFd4h/8UC6NfSH5eYkw1CvHVBMV+dPXWyyL4KyEGAyS0bNJk7VHfwIswqSWungqecL67V7A
 7xuvP81r6QRibXst0rUCNjrmCCB0TiTxNI2/hBpUccrNTE5lMBUGMgSyimQwi3waRsA6wXRTBGC
 5ANK9YmiPCAWa0nVVTOG5NvZXeQDwi+b1bi/pzsvBrzuQQFJyVXJS2ujOmBLdcCQfPbwkUHsBnx
 X7z3aTaVKT+janNMskszvHrTGUU9KaGzUbk2ShsVXyDyc7K4rU9p15N6nUG2h1dYLT6+ztoKs6L
 c4RIIi5/3uth6m/RU48thqoEyX1mfNWwCGaxJ/buNFtD8U8oSk4+X3VdjIirnW0PlfVumRWj0Oc
 yZaSjZjqPiumCekZbKEG/1boOTdzF87vKQzs7/CjCrtCkgE49DmhKpjLOW9I+wqTO0t5luQjYuI
 k9XzOZBEifZZKvBDEiojfqJUnXpzWX9YVuiE1fZc0A7ykEVSqAw9Zd0Zz3qHsR3ycLfYHMFqekh
 3NKMQ0u0IZN1gqQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 014771C000E
X-Stat-Signature: xh97f3xeq4xjn5hbapmtqtztpnygwi4j
X-Rspam-User: 
X-HE-Tag: 1769443677-322133
X-HE-Meta: U2FsdGVkX18n0fmYfQkjMEv7RjOCxw3vynC7A+7seGHwk7fHE2c7B/H/CWEAjLG/uB6+qF6uI4VPc4lVa+4zx79MbtlURMoC6a/PvrK8zvMJUvuMcKL7ql3DWu+fVE1U+CbSKVKjM2Ez+X0lQW+GFL7fonhbIr0t22w8Kb/6mtSxY3kWq4D63KbBZW4IisfKLxeYjZAdphByuEfTtcEpGK9UE61PoTnnOXx2PokqYa5GCw5GZQOZjIozp29RhaRiAnF0+syExOnAXM9z5p/sHxHr8I5u1MHWsJhmZQVVZE9xVD82gd/VJldd3kzci37n+qw+K9iCmjIcz4RxQMJtiJoGSpU+YpJd7lVvdz+Jldm5vEaMG32GT7wbwbm8Spoyr2GTSFKdZZ2zP6j1eOgmoKcPGc6gzpFTtYN+SLFty3zoOg+ixUEOQjQs4ns+9rTlXEiv/0K5OJmeIgkZ6Oj8L2MUkuOSCSA97du3/5BLPj/ts0rxGTGx2wWgaH3di431U/qXD3ZcFMEkv9kP1V+k0tb46J0I8p+PHhTEFcBc+OnAus7DC8RO9FfytJLO934ZahoY4C1B3jS44y7Zt75RU9iiqrMyUCjAtl2CSoSGnse6xW1ogiYsREOvf1Ijc/lishFBTDqx3C4LoCEfIiLyV03u+yb/zYit2Lw9fpheU2WlLwTkW8iUdy4GP8e+W4a3mYkXvnn8gtdwJLXuhE1rlkLC2CAzWF0ZHhDZg5nBAp2DRO8C7/bS04a0r6qZn5eGxCDMBzItDDTnFI5AVk5WADkmLdynueg+56RF28j48uB8RNVyg43j3TFyJVbtHkVxBXGXtVjbRU6hO/oEalZ0NVJjlFt+fsvQFaSOl4sqc2kJZ/7i3+eqTNS522kh2MRF7nmgR9kRZBeO8Rt9vqY/zuZg1N7m4aBOeYbIpLb/h+BK6LGLzcbsomTlv/mOjjdWswagUrIHHiyWLWf2Jzs
 JYPLXQ9a
 ZyDTa6rB8EzLXffPrIx5TIOytjUgYQ9ckP348/0bf3J/M2xXWqC0S5n2+TpHh3lbmnWnhRDnmB5V8dRVr4onMN5KLmXMRZPMFgbOClykspn8i03xzdWr0ZGAIoEkh3lfoviQEK3tgZK3THtD8uFH/ynYYFBIGjjkalm0mSU1rE//0Thqkoo/4cb0gQUycdmpK1C5NN5kzVirHk4iw6ce6sYX5LHsAF46LdkmG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Also update kho_in_debugfs_init() to compute sizes using fdt_totalsize()
for the root and sub-FDTs it processes, since these are known to be
actual FDT blobs.

Suggested-by: Pratyush Yadav <pratyush@kernel.org>
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
index 8a2b2a7e50fc6..ad2da9e4e6a04 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -726,6 +726,7 @@ static void __init kho_reserve_scratch(void)
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
+ * @size: size of the blob in bytes.
  *
  * Creates a new child node named @name in KHO root FDT and records
  * the physical address of @fdt. The pages of @fdt must also be preserved
@@ -737,7 +738,7 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt, size_t size)
 {
 	phys_addr_t phys = virt_to_phys(fdt);
 	void *root_fdt = kho_out.fdt;
@@ -762,7 +763,7 @@ int kho_add_subtree(const char *name, void *fdt)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false));
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -1402,7 +1403,8 @@ static __init int kho_init(void)
 	}
 
 	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-					 kho_out.fdt, true));
+					 kho_out.fdt,
+					 fdt_totalsize(kho_out.fdt), true));
 
 	return 0;
 
diff --git a/kernel/liveupdate/kexec_handover_debugfs.c b/kernel/liveupdate/kexec_handover_debugfs.c
index 2abbf62ba9424..64970c88c483c 100644
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
@@ -130,7 +130,8 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		goto err_rmdir;
 	}
 
-	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt,
+				    fdt_totalsize(fdt));
 	if (err)
 		goto err_rmdir;
 
@@ -138,6 +139,7 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
 		int len = 0;
 		const char *name = fdt_get_name(fdt, child, NULL);
 		const u64 *fdt_phys;
+		void *sub_fdt;
 
 		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
 		if (!fdt_phys)
@@ -147,8 +149,9 @@ __init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
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
index 0202c85ad14f9..a51f97f0fa0e6 100644
--- a/kernel/liveupdate/kexec_handover_internal.h
+++ b/kernel/liveupdate/kexec_handover_internal.h
@@ -30,7 +30,7 @@ int kho_debugfs_init(void);
 void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
-			const void *fdt, bool root);
+			const void *fdt, size_t size, bool root);
 void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
@@ -38,7 +38,8 @@ static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
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
index dda7bb57d421c..a4721813dd994 100644
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
index a20fafaf9846b..f2d7d9108cf41 100644
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
index b3ddfdec7a809..91d4162eec63f 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2510,7 +2510,7 @@ static int __init prepare_kho_fdt(void)
 	if (err)
 		goto err_unpreserve_fdt;
 
-	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt, fdt_totalsize(fdt));
 	if (err)
 		goto err_unpreserve_fdt;
 

-- 
2.47.3


