Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57EBD19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B256B008A; Mon, 26 Jan 2026 11:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A288D6B008C; Mon, 26 Jan 2026 11:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932646B0092; Mon, 26 Jan 2026 11:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 779F26B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:08:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19CAB1407FC
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:03 +0000 (UTC)
X-FDA: 84374596446.21.C795AE6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf19.hostedemail.com (Postfix) with ESMTP id 602F61A0007
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IFBAArkZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769443681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JGr10StQBeBR7KNeSzsI6aZ5StNmX9VCvqO6kZy3tw=;
	b=wT/gVlwcNuq1ykUtaN/wVrsbFrkaAGVA/bzQwOwZ8pWf7fHl9GrVUbfNaK2zf8IEiCEewr
	Y5PAVUOLcRKfPmRhYKaK5Na618yAIldK6HEQAlmX41ALuved5bd4wmINofKgNm114Xv0Ix
	SHRMCxiGeWklazXm12HGE/uyUGMNVuc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=IFBAArkZ;
	spf=none (imf19.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769443681; a=rsa-sha256;
	cv=none;
	b=355HmHRsGfiTIbxe2NiNVpwNkU+u77/DQF7PN1wYInuq3yA7xUdB0t7douEdwwzj0RFLlJ
	0ziG7G3BUPyDzzH9yc7BFvRsrOru168BwKxYDxzcsbDsJfhjmlwOpY/wV2FlTV0IHRP93H
	nRvsUdDKYjecoeYf/s/KOfS1Rk8BAHc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=7JGr10StQBeBR7KNeSzsI6aZ5StNmX9VCvqO6kZy3tw=; b=IFBAArkZBkmrlMtfkO0gCudcxo
	qjG0+7l1OBtx17boj2WQXW0YKmJlSJIXxV1I1qqGPAVo3pfL+gxP49gylrOHHViitAsr59l0aNEZ2
	Lkd3+Wdt+33LmlJN8l1lLwKt2u5cJaxe2wZJg+h0ADCoNCHqilphtqA6VXLi2W1F9BfSL8GWtNh/p
	UF4EgvVdvmfiSS30vEwWZ4gnCftmPych44tPlDPyUW+3TmBV2Jo1bp8QX8MvdaxDZro8Qr74JbznB
	AbkUz0FgQ0hApMYYIbtrL+6rgdOJL0s/jW/RI5XyBcFz56WS5NYTfFfDzsWmTmPyOaic+VKySSM5W
	gw8UEM4g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkP88-00GI7L-J0; Mon, 26 Jan 2026 16:07:56 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 26 Jan 2026 08:07:24 -0800
Subject: [PATCH v5 2/4] kho: rename fdt parameter to blob in
 kho_add/remove_subtree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-kho-v5-2-7cd0f69ab204@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3996; i=leitao@debian.org;
 h=from:subject:message-id; bh=FxhEMlYSxj7IocH/QDYLiRAsQ2AOrEP3RLJsCaReCLk=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpd5FN9yco88W0GzD0jdb73XAIa/o6fVHCFpXhH
 TUpn882EBuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXeRTQAKCRA1o5Of/Hh3
 bcn/EACKQ20zX7uH+X3Q1wI4dAzNApPR+EwiF3KDnV6lnyAJTk4BFpuLbDSzHXOTZVwVpEEwS4T
 juqOyVNxYcXd1fIm/hLxr1zF/e6J5hdKboBPIt7F+2HtjFvTQ6ntuDE6qVR/z1l1Givlf51ZEaZ
 vmRtOKO4uVsoEHb1eTKupgiVFKxbflitt/bgpkhmzALJy3GLM3nAmNAGN8tGbRfHQCKou6N4e31
 i6eh2s3yQOupy70iiBgMcMaVEu8RBomFWBkHSOCOZp0+3nlY+JfBzLNwBO+TIRSguRE8ZUoh7A3
 j7MFFSjN4rU51mggIBalrOtxG4Z+dPLFCK1usuQPRwxucTl/yvGWWrUmxNbyQq3ht2rStH92+m8
 WErXY1PNCu7uYXBDjxh1nem1umAxhBwnkZRjuM4LcL92GZyBGVBSvlo2z9vQ8fK/p5NldbYFi0L
 4bedgdgMTWJVGXA2cPOx4AtrO48y/DHJi+ZS99Q5lnletvhWgziAbZsJop97xvJt+iXcMnVtT7S
 qNz/CFh+GQv3wLX9A/dr+0fKL0qrn7BFfDfbs9yIteQu0PvFWbNLb+O30HRNcyAKnU+54bK/OPI
 ARrgwpuYPGMfdmhh8IwcrAJDheBQHms5jDKpLJZVVhLdh6GFO2GMeqV2YJ9tEIEbJKAeXXt5BnO
 sxYi0lvNRra3D8g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 602F61A0007
X-Stat-Signature: nudqxutbp43h1mbayinu99kcpwr1dbfo
X-Rspam-User: 
X-HE-Tag: 1769443681-421105
X-HE-Meta: U2FsdGVkX18CMwcTcQR5dCpJ+/yYUOpxa//hTtINtaY+L30LULIeMYKWcpAwPVn2B2qP20cBzWKQuLiGc5AaOp/8aLYiTGDjNom/eeFDqFPZ3q3IiQjh3sJJ3QSEANblG7Qqq5iZvRa5jTM1dKG5yf3rAn1y/7t1bero69a3SB/SX8xdl8G0Sg12l4VZf9ZsUqHrB0yaKQdAyQJFga8osLvgg1gEcWG+G3zL6cf0kFDzhnqOXkSBkVSv1GFu4MIR17/aPRowg6gVZRsaf+zVZISUswDmoN2wHWeVIvbfqBCq1XsBEUwzGxjmMjE5313ZkcO2ECNdYPehNQxRpsXbzRfVNM+JAO5m5UOA4I7NF7zJafgvsJHFsmSNL5mUZP6TDv+5OOXpAz43geyBlSXYatNhJGU5HKVvgxISZcllNG33kXviHkRHZR5D0bCmt+Wd3vh/elgtF4tfsFnlB35wXKIrMIzsQ5U/St5TMpuAF/3DXTlLc6hqPKpLYwVY6SvXDhYiLObkXL2Z708ZrVpwpzS4WCFrcefmBkLOXjqOszCGRzEgOTkG+t/gzCSxHzZhn+GGOrAPfYGcI5Df7NVLsNFdNV8zxkHRWDcW32+UjAuU4RcecpvQdva94ZVrcJEb0+wlXiYmdILxT19q58t+E9p27VI+W+mhKuMq8Tos91GragQJLuW1cnFN6QKReB7bH/h8qrf6CXQzlzCKtg/p5PgDYWh4NDf0fvCvNRFisrEJN1PtDO+epzDpEiI5usBcW0dRDl7wvhtuQWAAOWZr4f/yDS1s5MlDoAP59cPMGe4wuqHeGT5Rp0WL4ZlyCcmDCfqq1muVXKYqtSuYbwDu6fPgK4p3k5OMJ3zWv3uFpIg=
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

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/kexec_handover.h     |  8 ++++----
 kernel/liveupdate/kexec_handover.c | 18 +++++++++---------
 2 files changed, 13 insertions(+), 13 deletions(-)

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
index ad2da9e4e6a04..b1f3222a0052a 100644
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
@@ -763,7 +763,7 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
 	if (err < 0)
 		goto out_pack;
 
-	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, size, false));
+	WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, blob, size, false));
 
 out_pack:
 	fdt_pack(root_fdt);
@@ -772,9 +772,9 @@ int kho_add_subtree(const char *name, void *fdt, size_t size)
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
@@ -796,7 +796,7 @@ void kho_remove_subtree(void *fdt)
 
 		if ((phys_addr_t)*val == target_phys) {
 			fdt_del_node(root_fdt, off);
-			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+			kho_debugfs_fdt_remove(&kho_out.dbg, blob);
 			break;
 		}
 	}

-- 
2.47.3


