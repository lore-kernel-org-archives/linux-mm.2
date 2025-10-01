Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 294CDCCA471
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 01:19:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FE3D8E000C; Tue, 30 Sep 2025 21:19:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5DC8E0005; Tue, 30 Sep 2025 21:19:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C51D8E000C; Tue, 30 Sep 2025 21:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E88FD8E0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:19:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A683CBC173
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:19:52 +0000 (UTC)
X-FDA: 83947788624.04.3196284
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com [209.85.222.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id E246FC0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:19:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NKgK/Pt3";
	spf=pass (imf28.hostedemail.com: domain of 3tYHcaAgKCHgfWokjieqckkcha.Ykihejqt-iigrWYg.knc@flex--jasonmiu.bounces.google.com designates 209.85.222.202 as permitted sender) smtp.mailfrom=3tYHcaAgKCHgfWokjieqckkcha.Ykihejqt-iigrWYg.knc@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759281590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ibfSbZvRgj9j6yQ0MCtEacyn1TcRaC1JpE6HwVQGXI=;
	b=LThq3PRzOMdshWF6LdEmWYKtM1vXPganE1R2bqNrFHvxYU39cnrB5Fw6NxDO46kyt/2HrX
	u/Kn43StVlPFimVz2dp67bVJ1dVYF3HrE4DC7d8p5Py5ghwg5ktbxszO2+xYVZBNS/nffz
	OpScO0xzUDx8emRE4ImllUdiU8hgbW0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="NKgK/Pt3";
	spf=pass (imf28.hostedemail.com: domain of 3tYHcaAgKCHgfWokjieqckkcha.Ykihejqt-iigrWYg.knc@flex--jasonmiu.bounces.google.com designates 209.85.222.202 as permitted sender) smtp.mailfrom=3tYHcaAgKCHgfWokjieqckkcha.Ykihejqt-iigrWYg.knc@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759281590; a=rsa-sha256;
	cv=none;
	b=OXfrhsvfF7XNfo1EoeAM2VIum6ARKCBG0915Z3/XkvRN1kxlPf70M5lq1h6xZo43cpP9yk
	Fi+OIYraU9fwKCsAbMOzOHvKnHI/Wu2rSUpEZmpNjYCaPEPVMVX6eirShwZbnf1HJ0yMwT
	LgKw9rlHVD8o7s8JcSDyXuCmBuQTDNM=
Received: by mail-qk1-f202.google.com with SMTP id af79cd13be357-871614ad3efso232547885a.0
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759281590; x=1759886390; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ibfSbZvRgj9j6yQ0MCtEacyn1TcRaC1JpE6HwVQGXI=;
        b=NKgK/Pt31caE19vRr32A7OOwZ7pNrGYpL6tZ6UIIXpcCzlQ5AA48rYUakBNhhN9J7E
         3OgANVcPKQjMp/39XozU52GP2vC64ZMHEOTl8ZTh9QHga1ZIrQ+8mfWqT+R3Yo9lcJhN
         bPuLJNaTHuBE/8t7fHOpju0C00A+fewT44gJcTBeEK5HPqTz6hRzss+UCtwesxXN8qq9
         ehajfPYRHwCGlVH0MdX3m84h7AwY8dtO6wwpXliseFrJQqJVyMza/IvMgaa2HoCpFCyS
         aoXBnVJ5xRlOf3Tf8AmQtKMP0dAMEkzmCZoGqwEPHFpdvEEK00HYyqUvf7iWXAEfLudQ
         xUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759281590; x=1759886390;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ibfSbZvRgj9j6yQ0MCtEacyn1TcRaC1JpE6HwVQGXI=;
        b=gC5QuqQdX33LRb9V5g89kfqbtE/aPjD6jr7Q5fwXIwMRO1iLHYZe1Bfil51zhQQ04m
         XI7MVpt8cJRH5cWaeiPPZBohjZmrQ3mNTXndd+dWp4dWyqoicweEpt90Qbi16dFfaZGS
         zy/AS0eg/S4wGUToYNB2hLWPStUGK1XPRrISkwHqYcgYRBMGFEgVUuqnxlrtKKidzRmH
         aTQUyxsIIAqUXQmXdIyDPX2+nhAtP01NpgZCMUIYvmqEblRUVSxNwVkr7I6cQfUEnSb0
         pE4EpuTT3ACySbAirqKjBScEADTj981oZoGZokOPGdcK58B1DB/soGIHRF4Bi7dKqCix
         ZTVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpWfKxwcnR/xrm7BwC0DBXYmeSbSo3gd7rpvSzePyxABj7/n4FYSuJoLYe6nsGVLXIFuJrZKQbxQ==@kvack.org
X-Gm-Message-State: AOJu0Yzd1JPwvR3AenEY0josk48KImuntYdf3xrNbLUtmtnTeFBC9Vmd
	5eAtmAKxINVlMfiwht25WnYEEJTiBzuVr/Y7YbePzne3IxgRQy1pkQby2e6rHKJcfpH1jhI4VP0
	LCslMTHND0fnueA==
X-Google-Smtp-Source: AGHT+IGndh3BKmmwYu3HLjg8lqiwBwPnFbZVMWVM52TvRbv89JPU+RpTm1KO5ghpiMevFLIMLJgkTv9IkxTRLg==
X-Received: from qkpg1.prod.google.com ([2002:a05:620a:2781:b0:863:2d0a:f9a6])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:620a:4723:b0:82e:6ec8:9887 with SMTP id af79cd13be357-87371172610mr285500485a.24.1759281589908;
 Tue, 30 Sep 2025 18:19:49 -0700 (PDT)
Date: Tue, 30 Sep 2025 18:19:40 -0700
In-Reply-To: <20251001011941.1513050-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251001011941.1513050-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001011941.1513050-3-jasonmiu@google.com>
Subject: [PATCH v1 2/3] memblock: Remove KHO notifier usage
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E246FC0002
X-Stat-Signature: 85uuun71fmmegg8uyydiyh9sp93zyrkz
X-HE-Tag: 1759281590-749891
X-HE-Meta: U2FsdGVkX1/Mz1A3zqDkUVGSKl7HsgIu1VzBXU9h1Jue2HxKjnYzDs0mMNR2Zl+L+OZKLwvufUXvR61Pz2IG8MKA3bauLnWuAzn1Yn7edZX1F6PwHJL0sPBIaEZesuB4XJ4tHaALEirX3eT+7RahF3edkhGgIg5syZK5aTMsdOjnThmIMnLx30ycH6FJ1s8tdpDXLWcrGKN+KKfJVz7b95OG/1mLspmNyZ+JEvLb3ED7hAdfmRo1hDAYIjlj1E9VR2LyorBHkC3l874BIt2MIC7kD87CJoFDCEuOZjpWlzAhCsk0u44EUFTjVuEQakJ1Cnb0k9xsjdF+llGpjZnnI9fXkbaTb8BJnaFwgiEXu7lBtrqVzU/zfgC6/EYCQqHRNmOmVCqepN9W3ZwYm4TcdL7zAKd7fI3vnmevIdcUlmnnFwh1IoSWEOODaIYXT7HN1CkISxmkOcw/iuXjC4U2Npvr6mCIFI7mwN/k/yIOlrBQhwHfUxOP630zSKcPFBqTIlNVzBHUrSUviDhCKGqbzYPS+u6m0JqzwZ6R7J4UNx8jgXLbCIeL7tiy6vdgyeA5taEH4OYiLqNnQJnI/PEwJO3raTgh2UPvW0kEK9c9xqJeJS8LyZA5mgwsh+k8uFCRAk3q7v1Bch9tnaIXInF6NldGcRv5Ucj21IukwTVAlGapoO6UF4BoM2ayalMB7B8rG3QrH+0Vqc95dKBCfSohkeLIkC0MjxL3JHqNggYHtm4SdrOTX3RGC/2KAhZ9pBNlzeA2yhgZrGQbZtuX/XJEj9OYuqS3vyARMnw5JleTqd/mTqOUJfnBeh5H/hFaFLXOLE0KobBDIVG/Jea9RwXAS+k7bDpDLhKRKY+wCU4Z8rtAfS66jOzAfNGbt+SeAlc6uhLlAJoWUtB4qpGfX2N1GcbqtjtpmMBo7tASMQZHOfjsLqPL1xJlgyaOdljxyzP6VU0xau7tctfvY+nzPNN
 /rusSndH
 uDshJoaRVbSz4ycCuoCqud22RlrlCRfy1PTI29V7/KWs0ly2Mg0vLQeLgaETJwkkgoAOepBy39+zTYmVvMnTFXBQheRgBV6vXbaCjlVnoWoKFe/ZcPy3Gh0X9btgkg4cfSdeMmPnzUkISHYYXagWQ+6Vg+ALCzoE2Ae+XKjX/XMQMTy5peNXBk6d9DK9pbhRE5TUx4N2DULgwZ7y65qYqhFzy2RZJQi5o3CWKah9cofdSPnOzVtCKIKMRGiytRL/Sj+a3mIvg3ezm6UjuQYpor/KN5osvc8cauWnFmzJikSCieFoaXHFH8KUu+N/j5VknMf6gF8fd9Xnco4MLMCxQfjbk6PkEIbBKkwJq3H15WjL30VPfjwXZ6d7irV67uPTv0T/vtsIRxJI+gdPkTQqg/y30f5gjzhJyQVCXSCcTX/jSXD39Duy4J8HKnE7QXf0X9Ny/+ir8xET8ARkkeLaqKxm4Fq5Dz3wifF59F/Xlt/osHeyYkLLSHvOmwKTNGFFksWnF3dJyrmt70uRCEOg7Iv9qPBG2lQbZInzc8Ka/UJwPlIXmG23tatEQZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the KHO notifier registration and callbacks from the memblock
subsystem. These notifiers were tied to the former KHO finalize and
abort events, which are no longer used.

Memblock now preserves its `reserve_mem` regions and registers its
metadata by calling kho_preserve_phys(), kho_preserve_folio(), and
kho_add_subtree() directly within its initialization function.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 include/linux/kexec_handover.h |  5 ++--
 kernel/kexec_handover.c        | 48 +++++++++++++++++++++-------------
 mm/memblock.c                  | 45 +++++++------------------------
 3 files changed, 42 insertions(+), 56 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index c8229cb11f4b..9566c90a3501 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -27,7 +27,7 @@ bool kho_is_enabled(void);
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
 struct folio *kho_restore_folio(phys_addr_t phys);
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
 int register_kho_notifier(struct notifier_block *nb);
@@ -58,8 +58,7 @@ static inline struct folio *kho_restore_folio(phys_addr_t phys)
 	return NULL;
 }
 
-static inline int kho_add_subtree(struct kho_serialization *ser,
-				  const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 34cf0ce4f359..ee4f430dfae0 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -640,9 +640,21 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 	return 0;
 }
 
+struct kho_out {
+	struct blocking_notifier_head chain_head;
+	struct dentry *dir;
+	struct kho_serialization ser;
+};
+
+static struct kho_out kho_out = {
+	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
+	.ser = {
+		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
+	},
+};
+
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
- * @ser: serialization control object passed by KHO notifiers.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
  *
@@ -655,16 +667,29 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt)
 {
+	struct kho_serialization *ser = &kho_out.ser;
 	int err = 0;
+	int root_node_offset, subnode_offset;
 	u64 phys = (u64)virt_to_phys(fdt);
 	void *root = page_to_virt(ser->fdt);
 
-	err |= fdt_begin_node(root, name);
-	err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
-	err |= fdt_end_node(root);
+	/* Reload the KHO root FDT to the same buffer */
+	err = fdt_open_into(root, root, PAGE_SIZE);
+	if (err)
+		return err;
+
+	root_node_offset = fdt_path_offset(fdt, "/");
+	if (root_node_offset < 0)
+		return root_node_offset;
+
+	subnode_offset = fdt_add_subnode(root, root_node_offset, name);
+	if (subnode_offset < 0)
+		return subnode_offset;
 
+	err = fdt_setprop(root, subnode_offset,
+			  PROP_SUB_FDT, &phys, sizeof(phys));
 	if (err)
 		return err;
 
@@ -672,19 +697,6 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-struct kho_out {
-	struct blocking_notifier_head chain_head;
-	struct dentry *dir;
-	struct kho_serialization ser;
-};
-
-static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
-	},
-};
-
 int register_kho_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
diff --git a/mm/memblock.c b/mm/memblock.c
index 117d963e677c..602a16cb467a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2510,39 +2510,6 @@ int reserve_mem_release_by_name(const char *name)
 #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
 static struct page *kho_fdt;
 
-static int reserve_mem_kho_finalize(struct kho_serialization *ser)
-{
-	int err = 0, i;
-
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserve_mem_table *map = &reserved_mem_table[i];
-
-		err |= kho_preserve_phys(map->start, map->size);
-	}
-
-	err |= kho_preserve_folio(page_folio(kho_fdt));
-	err |= kho_add_subtree(ser, MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
-
-	return notifier_from_errno(err);
-}
-
-static int reserve_mem_kho_notifier(struct notifier_block *self,
-				    unsigned long cmd, void *v)
-{
-	switch (cmd) {
-	case KEXEC_KHO_FINALIZE:
-		return reserve_mem_kho_finalize((struct kho_serialization *)v);
-	case KEXEC_KHO_ABORT:
-		return NOTIFY_DONE;
-	default:
-		return NOTIFY_BAD;
-	}
-}
-
-static struct notifier_block reserve_mem_kho_nb = {
-	.notifier_call = reserve_mem_kho_notifier,
-};
-
 static int __init prepare_kho_fdt(void)
 {
 	int err = 0, i;
@@ -2583,7 +2550,7 @@ static int __init prepare_kho_fdt(void)
 
 static int __init reserve_mem_init(void)
 {
-	int err;
+	int err, i;
 
 	if (!kho_is_enabled() || !reserved_mem_count)
 		return 0;
@@ -2592,7 +2559,15 @@ static int __init reserve_mem_init(void)
 	if (err)
 		return err;
 
-	err = register_kho_notifier(&reserve_mem_kho_nb);
+	for (i = 0; i < reserved_mem_count; i++) {
+		struct reserve_mem_table *map = &reserved_mem_table[i];
+
+		err |= kho_preserve_phys(map->start, map->size);
+	}
+
+	err |= kho_preserve_folio(page_folio(kho_fdt));
+	err |= kho_add_subtree(MEMBLOCK_KHO_FDT, page_to_virt(kho_fdt));
+
 	if (err) {
 		put_page(kho_fdt);
 		kho_fdt = NULL;
-- 
2.51.0.618.g983fd99d29-goog


