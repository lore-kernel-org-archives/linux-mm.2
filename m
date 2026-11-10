Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A9BF606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=G9FU9+1/
Received: by kanga.kvack.org (Postfix)
	id 920E46B05CB; Tue, 10 Nov 2026 00:02:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CBF26B05CD; Tue, 10 Nov 2026 00:02:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793C76B05CE; Tue, 10 Nov 2026 00:02:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45C056B05CB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:29 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFA43A85D6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:28 +0000 (UTC)
X-FDA: 85418013576.06.F56138B
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf20.hostedemail.com (Postfix) with ESMTP id 17B1B1C0005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="G9FU9+1/";
	spf=pass (imf20.hostedemail.com: domain of 3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286947;
	b=ASL5g+KcA34hZddzJRj7pldfk1qo7XvMxeywxdnqJfUEGPo8wXXj7HSTwRnzvGdcItX+yN
	eef445+fnPCtJBMtuFW7QTSgV1qwyMrRUaFSDOgjznkAXcM/FwGo4REc5QcUhZHJGNfwjN
	EsFozNQz8zUMF+1yE72PtkX3fuKGK4A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="G9FU9+1/";
	spf=pass (imf20.hostedemail.com: domain of 3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=3YKXyagkKCNMIzGJCHz6J5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hS6VkHJCMMhJIKk9BuX59tEknsJKMmzlEArInOfp3hI=;
	b=Vu1YEK72lrU1GSaO3eDV23OEqUbCSVy2U2w5kADsbfY2gw4rkiXSz/GqjBd22W3USD1f/Y
	3Iz3RfL2l761185TGvsKTbJ4jph4SLn6BgNs/V7OD6SWe+Pddro9H9kZUH1MdrG1Szvt3j
	wv3riS2BTS4G0RPhWNOE5xKcaKhCnj4=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-6b5e0ce4132so1260301a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286946; x=1794891746; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hS6VkHJCMMhJIKk9BuX59tEknsJKMmzlEArInOfp3hI=;
        b=G9FU9+1/apNK6tZVZNAY/DCCa9/KdN83xOBaMzD4xpzY4+FyRTos4eoZ1gXvS7Jcgr
         2k36B8Daepn3oKKz3qrqfg3Xo9zFt+bI2qqIb1IE9Jh1EUpNoescZtCBkXQuLRe4WKKn
         azBUPYQp6WKemyMwoSjspUF2wjv0NgsJBZlAe9dtpZurqxTjEbrHfH2v9nm/grDRZsoi
         8T/kS+SyKMZDwUBnJeeXxIO+QWK5PjPvAefeZqnZ1hWW3Gz2P7dXnwxy29k4N8vhQfr0
         /vEa0rK9nNZhqxNdi2wa2rzl4ecPBZcK06vZ6g7pHku6XyGxDDXZmfuppNcDHvHd1PkJ
         Lduw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286946; x=1794891746;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hS6VkHJCMMhJIKk9BuX59tEknsJKMmzlEArInOfp3hI=;
        b=iU2EdDZGL6g/0m0iAvCkXHRFnqanYX0e0Zcqy34RGaO0CxH+v+4bzrfq+v4s0usN9B
         ZIql/FFhSiJYSklyg24FUuL3CqJEquu3GMf3IKab0hMoLX+RjCj+LeiwPBn8wo9AwJv+
         oE343HxL7mpIQoVq1X4MX4CK3FXID9To+lH4IzPRm4iBiE7T2yhT2+zaarne97CYH6jD
         J1dbw4X02bIKonKw0hl+MHFYnmwtMpRghQDJ3kcrqIHhooEy0V1iYlINaoVVHms8EOeT
         MiTF8LtV7Z6mwUS1rGVzN7HydIqq/c0ogtAhJwUzRgom0o+JKrRUwPWUq5xNeovAdosn
         rnsA==
X-Forwarded-Encrypted: i=1; AL+hErHvPVgLyL1pIrcgh/qL/OJ3x1F/iOUl8T7WV3GpmmgbrqGbcMTmjQxjbqJEFbJbkCn6WA22VrYF2Q==@kvack.org
X-Gm-Message-State: APuU4Z9D1FPrib6WxpWu7kvvtFUiDQxZPRiYGHC/dIX8b6TVpNKDvtDC
	Hb8kyI/o+vBQEA2H5AGMb0O3xtGa1BxeIKW6ZH0e9s4t0dZxfTPeOsDG4tQjjtjNKMJjrGrm8iR
	F8S3LPjbSoHJ/DmMKjA==
X-Received: from edqu26.prod.google.com ([2002:aa7:d89a:0:b0:6b7:37e3:4968])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2422:b0:6b7:dc8:c824 with SMTP id 4fb4d7f45d1cf-6b756b08c35mr1192059a12.42.1794286944980;
 Mon, 09 Nov 2026 21:02:24 -0800 (PST)
Date: Tue, 10 Nov 2026 05:02:01 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-19-tarunsahu@google.com>
Subject: [PATCH v4 18/19] mm: memfd_luo: Add feature header to struct memfd_luo_folio_ser
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hdybd4s7uss4cqgfi5iq6eywbhsje8cn
X-Rspamd-Queue-Id: 17B1B1C0005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794286946-907824
X-HE-Meta: U2FsdGVkX1/2KZ6U+lJ/DZkqN7oX0hvTT0rgLhiRR5r4z9K5gUW2qg+vZUyjE7GY9iZu48Knghg+4gcksDa99+FhDiVnqoE56qZsLpAURSu2JOfSbibjLBI/H2hAdAG8EA7t4q3i2EQk1lpwwBKiPQhmZWtT4ONZaoMlmI3uWItJy/ahqVyRcTyLdPVm5/FqCjKyvlkM4gyZoH7ujS7OH+D9sdvok2aJJkWLG7e3vuFJ/JvDMQtviRwfPnh52SKqvs3RCqmFLks2xysAecNgOpsnNiG7t7aISTog8bPMMQH8GCBEvPpio0sXpeOAf5206c5R6Hv+nwtjze4uGLAJqC8kcneTesAv4SzhBPHlApvrNnBBODB3pgWJTxtqCdZWDfRrlh+x3Bp/nLZaNPF1MHIsauvHNRCFfGzIehqhOrYjidIdK/zeKp7ri+3D9OJ3kjQ/bcx74z6DrbR5x6l1pQtP8JiKW+r9iUdSWdXyRjXhH7nHtE3wEqN+VdkF3Rr7VHHgEjWIW3GEXN7vV4DLypxPhKoZ59s7p1J+1Y9eoiZOFsoatzEbbkrPSexrew1NlrtIsrgetXmLXCL7biK2O7MDvyhxE0G1rj7EZZgU1NrUR+cheoCakC0oujnAqqvgqFnovHdAHCU2av0j6HVRKEfNzac41JKkxDdTeymgsR0eptNoCzwo0FfWZhXgGHCZzWmIj6ZVsChMQaJt69BOAc19ouQEsZ11BTEAwThikbfQU5YQ2Y7bOMvImzpYG77kxLHXEyMSIxEg1uLl/5K7nJvfWJ0aLSLRjF//XPSNbh1wCpSE4ZkB6sTI9h/eYCm/bRuiPcqhFcz1MiXO3Hiol/sBBv3t7PQGrMEioWSHb5sUovYJLiHNepmBwvIloFJzZY9WhcnrHqZebjd674SQUp4CpG03W+HA3YnaP5FUfynyP5jVyckd7YGZa3zc0fSo4rVKz6Gk8U0X6Wn3ttd
 KVwTqVTD
 CyRO+xbdL6vlgkTDDDlXVC0iTpwq95h5L13khTCJFioHvL0YrENcjtTkCUlvQSQSm78rgcHq2jkk74jnBT6N1pcdNDJ+bfYjzEgzBe8WCYJ/jKexS22dZ930uBq7uQWkM5liS9gh5j0/AGtemSGdNtXg/a3zPJ4/rQB8d3tMRCES1lW70zrahOG+ax3kmt3+UXh5fmFAc6jEsQDtghg683r7BV3VujJIAleFmPiQ9ZlA3Sz+kiEZfiVX87T2dkUdiAkgo/ooCZ039dGzwasCYdOUgxyl2cN5Xhxkx7v7xkmjlZHLbYgQMHxRVLaSAcJPjCj6WheOAbD4+LwSMCHWRodlYeUFbnon5xf7leQen2/fiAPivwRugCP5etpDRR7vcEpeaSqJO/EkJk6KTdhyUJAzVun9Yc9yyA4673gW0E2KuiHxTuWLmqhU5RCtIi4CtPu2PSxzMrx5J0RYVMZpPN/lYkmNlUz1loodjbZXvfifSzqrYJqnJtPj7SqHot51ciBEeJSCS0dhLmVX+3pXM3nVvT5kfmhNXGQmCja505wicAtsZ7IkkKAJ1IZy14lxOxPza0rhA8qEIPGlxB8eyJEbZ2AJ27TPv10ouTAvc7W7UI4g4GT8HLA96bs9B4OpFQgIVvoFsHoHldoifbUX4JC1wQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede each serialized folio entry in the preserved memfd folio array
with struct kho_ser_hdr via DECLARE_KHO_SER so future per-folio memfd
features can append fields to struct memfd_luo_folio_ser without breaking
compatibility between adjacent kernels.

Allocate the preserved folio array using kho_ser_size(memfd_luo_folio_ser)
per entry and initialize each entry feature header in
memfd_luo_preserve_folios(). On the incoming path in
memfd_luo_discard_folios() and memfd_luo_retrieve_folios(), validate each
entry feature header with kho_ser_validate() and advance between entries
using fhdr->size so entries written with a different feature layout are
traversed accurately.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/memfd.h |  6 ++--
 mm/memfd_luo.c                | 66 +++++++++++++++++++++++++----------
 2 files changed, 51 insertions(+), 21 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 27f8880ee593..1aad47ce7322 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -51,6 +51,8 @@
  * @pfn:       The page frame number of the folio.
  * @flags:     Flags to describe the state of the folio.
  * @index:     The page offset (pgoff_t) of the folio within the original file.
+ *
+ * Preceded by &struct kho_ser_hdr.
  */
 struct memfd_luo_folio_ser {
 	u64 pfn:52;
@@ -58,9 +60,7 @@ struct memfd_luo_folio_ser {
 	u64 index;
 };
 
-static_assert(sizeof(struct memfd_luo_folio_ser) == 16);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct memfd_luo_folio_ser) == 8);
+DECLARE_KHO_SER(memfd_luo_folio_ser, 16, 0, 0);
 
 /*
  * The set of seals this version supports preserving. If support for any new
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 94510f73a606..c00daa8a508e 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -86,10 +86,10 @@
 
 static int memfd_luo_preserve_folios(struct file *file,
 				     struct memfd_luo_ser *ser,
-				     struct memfd_luo_folio_ser **out_folios_ser)
+				     DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, **out_folios_ser))
 {
 	struct inode *inode = file_inode(file);
-	struct memfd_luo_folio_ser *folios_ser;
+	DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser);
 	unsigned int max_folios;
 	long i, size, nr_pinned;
 	struct folio **folios;
@@ -138,14 +138,16 @@ static int memfd_luo_preserve_folios(struct file *file,
 	}
 	nr_folios = nr_pinned;
 
-	folios_ser = vcalloc(nr_folios, sizeof(*folios_ser));
+	folios_ser = vcalloc(nr_folios, kho_ser_size(memfd_luo_folio_ser));
 	if (!folios_ser) {
 		err = -ENOMEM;
 		goto err_unpin;
 	}
 
 	for (i = 0; i < nr_folios; i++) {
-		struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) =
+			(void *)folios_ser + i * kho_ser_size(memfd_luo_folio_ser);
+		struct memfd_luo_folio_ser *pfolio;
 		struct folio *folio = folios[i];
 
 		err = kho_preserve_folio(folio);
@@ -195,6 +197,8 @@ static int memfd_luo_preserve_folios(struct file *file,
 
 		folio_unlock(folio);
 
+		kho_ser_init(fhdr, memfd_luo_folio_ser);
+		pfolio = kho_ser_payload(fhdr, memfd_luo_folio_ser);
 		pfolio->pfn = folio_pfn(folio);
 		pfolio->flags = MEMFD_LUO_FOLIO_DIRTY | MEMFD_LUO_FOLIO_UPTODATE;
 		pfolio->index = folio->index;
@@ -228,7 +232,7 @@ static int memfd_luo_preserve_folios(struct file *file,
 }
 
 static void memfd_luo_unpreserve_folios(DECLARE_KHO_SER_HDR(kho_vmalloc, *folios_fhdr),
-					struct memfd_luo_folio_ser *folios_ser,
+					const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser),
 					u64 nr_folios)
 {
 	long i;
@@ -239,7 +243,10 @@ static void memfd_luo_unpreserve_folios(DECLARE_KHO_SER_HDR(kho_vmalloc, *folios
 	kho_unpreserve_vmalloc(folios_fhdr);
 
 	for (i = 0; i < nr_folios; i++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+		const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) =
+			(const void *)folios_ser + i * kho_ser_size(memfd_luo_folio_ser);
+		const struct memfd_luo_folio_ser *pfolio =
+			kho_ser_payload(fhdr, memfd_luo_folio_ser);
 		struct folio *folio;
 
 		if (!pfolio->pfn)
@@ -277,7 +284,7 @@ memfd_luo_ser_init(DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr))
 static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
-	struct memfd_luo_folio_ser *folios_ser;
+	DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser);
 	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 	int err = 0, seals;
@@ -384,16 +391,23 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 	inode_unlock(inode);
 }
 
-static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_ser,
+static void memfd_luo_discard_folios(const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser),
 				     u64 nr_folios)
 {
+	const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) = folios_ser;
 	u64 i;
 
-	for (i = 0; i < nr_folios; i++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+	for (i = 0; i < nr_folios; i++, fhdr = (const void *)fhdr + fhdr->size) {
+		const struct memfd_luo_folio_ser *pfolio;
 		struct folio *folio;
 		phys_addr_t phys;
 
+		if (kho_ser_validate(fhdr, memfd_luo_folio_ser)) {
+			pr_warn("invalid folio feature header, folios not discarded\n");
+			return;
+		}
+
+		pfolio = kho_ser_payload(fhdr, memfd_luo_folio_ser);
 		if (!pfolio->pfn)
 			continue;
 
@@ -411,7 +425,7 @@ static void memfd_luo_discard_folios(const struct memfd_luo_folio_ser *folios_se
 
 static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_folio_ser *folios_ser;
+	DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser);
 	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 
@@ -447,9 +461,10 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 }
 
 static int memfd_luo_retrieve_folios(struct file *file,
-				     struct memfd_luo_folio_ser *folios_ser,
+				     const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser),
 				     u64 nr_folios)
 {
+	const DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *fhdr) = folios_ser;
 	struct inode *inode = file_inode(file);
 	struct address_space *mapping = inode->i_mapping;
 	struct folio *folio;
@@ -457,12 +472,20 @@ static int memfd_luo_retrieve_folios(struct file *file,
 	int err = -EIO;
 	long i;
 
-	for (i = 0; i < nr_folios; i++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
+	for (i = 0; i < nr_folios; i++, fhdr = (const void *)fhdr + fhdr->size) {
+		const struct memfd_luo_folio_ser *pfolio;
 		phys_addr_t phys;
 		u64 index;
 		int flags;
 
+		err = kho_ser_validate(fhdr, memfd_luo_folio_ser);
+		if (err) {
+			pr_err("memfd_luo_folio_ser feature validation failed: %pe\n",
+			       ERR_PTR(err));
+			goto put_folios;
+		}
+
+		pfolio = kho_ser_payload(fhdr, memfd_luo_folio_ser);
 		if (!pfolio->pfn)
 			continue;
 
@@ -472,7 +495,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 			pr_err("Unable to restore folio at physical address: %llx\n",
 			       phys);
 			err = -EIO;
-			goto put_folios;
+			goto next_put_folios;
 		}
 		index = pfolio->index;
 		flags = pfolio->flags;
@@ -524,15 +547,22 @@ static int memfd_luo_retrieve_folios(struct file *file,
 unlock_folio:
 	folio_unlock(folio);
 	folio_put(folio);
+next_put_folios:
+	i++;
+	fhdr = (const void *)fhdr + fhdr->size;
 put_folios:
 	/*
 	 * Note: don't free the folios already added to the file. They will be
 	 * freed when the file is freed. Free the ones not added yet here.
 	 */
-	for (long j = i + 1; j < nr_folios; j++) {
-		const struct memfd_luo_folio_ser *pfolio = &folios_ser[j];
+	for (; i < nr_folios; i++, fhdr = (const void *)fhdr + fhdr->size) {
+		const struct memfd_luo_folio_ser *pfolio;
 		phys_addr_t phys;
 
+		if (kho_ser_validate(fhdr, memfd_luo_folio_ser))
+			break;
+
+		pfolio = kho_ser_payload(fhdr, memfd_luo_folio_ser);
 		if (!pfolio->pfn)
 			continue;
 
@@ -549,7 +579,7 @@ static int memfd_luo_retrieve_folios(struct file *file,
 
 static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 {
-	struct memfd_luo_folio_ser *folios_ser;
+	DECLARE_KHO_SER_HDR(memfd_luo_folio_ser, *folios_ser);
 	DECLARE_KHO_SER_HDR(memfd_luo_ser, *fhdr);
 	struct memfd_luo_ser *ser;
 	struct file *file;
-- 
2.56.0.506.g506a7eabc5-goog


