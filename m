Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51628CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78F476B0005; Fri, 15 May 2026 08:13:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741EB6B0088; Fri, 15 May 2026 08:13:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62EA46B008A; Fri, 15 May 2026 08:13:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA216B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:13:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DA78C1C0D3B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:13:55 +0000 (UTC)
X-FDA: 84769545630.05.3D8C8A5
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2CA2D1C0013
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:13:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AqvERBbD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3AA4HagoKCI85v4t816B31z77z4x.v75416DG-553Etv3.7Az@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3AA4HagoKCI85v4t816B31z77z4x.v75416DG-553Etv3.7Az@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778847234; a=rsa-sha256;
	cv=none;
	b=Cx6u8NiIry7K5QjmUDroUoQbS1O1Fvf3ccY9vkRlTauImXJKrRhDn+orixKnbGHYWtof/J
	CoYxM1Dq1hOxu+k/xAufg3N7zWcNICgTUFJ6LV67XPu1yI9E6VL6gooKb4sLgaCBG5cyjh
	Y+/A0sP66nWwNp9IPCuRktLJjYEuWvs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AqvERBbD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3AA4HagoKCI85v4t816B31z77z4x.v75416DG-553Etv3.7Az@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3AA4HagoKCI85v4t816B31z77z4x.v75416DG-553Etv3.7Az@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778847234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TAz4CA6Is3STEKSGdLB0WV6Ze302Q8TtADXZ332A6zc=;
	b=HVS+m+/+da7E7TvjzZW27jG5RekEiIleZnWsJ5wFRVxI72C6blha0bBebV69TG4j29r4Y2
	7H4+WC1FtuZBdsqYPbn5g6EQf2roGwpTnGmbK/+WQqYno5LyUtZP5CevZX7GbVaa6JcDz0
	YeP6pq4+JZGifj7qaKpSOIiNvyMG3Nk=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fdb2b0cb8so13681155e9.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778847232; x=1779452032; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TAz4CA6Is3STEKSGdLB0WV6Ze302Q8TtADXZ332A6zc=;
        b=AqvERBbDWL3htGwBMfwkmqBvAjxxLEzexLIZSr6cnlQvJFK/ldnCnhMX6/vMbMEG8w
         syDIqSa7vGnYeE66eacFJIZRkHnEyqiYn1wLIWHii1VifHunKC68c+r2vUOaH2shns46
         lu7KlTNqWl3v3EbJYvcQYXK2C5YDKbT4riq206CtBXh68t5xEXLAWZRJN4kXba2kZpMI
         Ql5wTxrPQ6ZyqT/6GJi4rt7xsFBdcdkwS5woCloUjDbN2+TX1BD+x7a8cblPKjEmDJHK
         Lgw/TTZizawLiHVn5x7K34R9o4dMrLrUJGC7/VpNAeWJ9q9t+7jje3F3AQJbDnZU2FIa
         L9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778847232; x=1779452032;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TAz4CA6Is3STEKSGdLB0WV6Ze302Q8TtADXZ332A6zc=;
        b=gg4TAl8jCSO5iO5C01s6fXUVhncbhlO6eYbyi8mJitGdEGptIbZ/y2/1ktiDwZFfPq
         65xb/ecal1T2skehmDLINtS4EOFq9+vrHQ8699MPllOwKT8DRxNfg4UyoHxFnOg3xHK8
         edVFPYKgjbLEbGPbX49WpaEAcfmVfOXz1p2PC4TAoqbSX9Hd1cgY3DIw+HLtSGRSdXFW
         TKkt8/hk1V8y3Vr6tTRRd7s4yfYiIiaseixcBeh0cEwBQx0CpgyqXqjAIasNzhswfvWQ
         7bEgCFEe/cURw1v0ZYFsSZBaqL5gOlAIux6OrO+t75q3ibKLZCELXQbbMF223tfoVL5+
         vV4Q==
X-Forwarded-Encrypted: i=1; AFNElJ/dZPChC1vawwtUnuHjgQXib2QzSw+EaZz9Zu+AWwrtdQ7YnfRuV47XRKp70/M0ULrvnVs8EB5Xhg==@kvack.org
X-Gm-Message-State: AOJu0YxxKgJ4n+1zToJBpDyGUHTKqOmDRQV+goirp4JkBBSElcqCXn8W
	8d0mZiV6XYn0ecoEeHdW+GO/vMIZ/waj+dgpZJbzWAiBcgAW2xW/FrMsDic+69kmwZMDPdPZkgO
	IRz8HEaQFFlFvdYM04o8IIA==
X-Received: from wmbjg9.prod.google.com ([2002:a05:600c:a009:b0:488:9b69:9379])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d0d:b0:489:1ff1:74df with SMTP id 5b1f17b1804b1-48fe5fcdf50mr51148605e9.1.1778847232169;
 Fri, 15 May 2026 05:13:52 -0700 (PDT)
Date: Fri, 15 May 2026 14:13:29 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260515121329.619995-1-mclapinski@google.com>
Subject: [PATCH] kho: test: include more variety of allocations
From: Michal Clapinski <mclapinski@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, kexec@lists.infradead.org, 
	linux-mm@kvack.org
Cc: Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: bwke4gxaer379mfejd8gh4i1otbb5fy9
X-Rspam-User: 
X-Rspamd-Queue-Id: 2CA2D1C0013
X-Rspamd-Server: rspam07
X-HE-Tag: 1778847233-753268
X-HE-Meta: U2FsdGVkX1/UuEX8R+8pC+yUx1f/6XK/e+KK9dLjI8qZoc/HLHWUSDV3RsKdSSG+tO7K87QSEZkRGzz+xyc2Six1Tvae3m93PamTEfp6EcHoHqXpKgPBHIc1SVGU7pDIICNjneC0yGWbZnI/ZhkOIm4oynuoTpHayk4LpsG/oBLXimgecalGpw1F99Be8dOGB3lbonZcHmKvq++uADazrv/KKA/h2LcrzvxjrCY9ylR1WXeEXsJp3X3xlQE1PyQOuIe54cXUjDVwV2HUaNXetxI1qK8cnxDHgiwiJcnmdT68/E0/3GpwYJUE2R/n1NmIQmctDl92/4UoqCwVN+JT4zV4JTXmGwb83EIajtjMt9IgdgUB8ljvfQrT86QIsWQUi2QWCC76QLVBZ4uAS9KNnQDmmbJR3EobWPIGGcYxph12ba+uS4zCB6Vy7JGGPn/IdJhuyMVwcYY9hHEsCPsRljD2kv2hAzFffqavbgeAYeG9yEe6g464xzlEYVM00RAZ7lYBOChLQTqPovM8gYzIJsWUL1lZfCmroiFyrbPATnolQtvXfwV0ESzgqu2CzMS4jqCYT/u/gzmnBuhS9ieyk1cNgvt+Ny2o/fjVtb1PdlcJGoC5yWsvNfeG9Luef8rBqymU7rRDb7DUYGWGq+nhNqRBSDxMwuPLDZfSftsxPu3T8Wxxk6cIe4AkkPbmMSdq9/ZIUYVFN+LcLF9IHEysPSgk1xvkyiumfcBloWh3xvtEsox/wj5OELGCyA7NF0x3DcOOZxhB/AiSWfFy9ZGkoD8fRlEhLS2eVvDiQpQ4hMPCR0+5ZrU/EWQJvLQnXTj4xLow+ySmKmFt4QhVyZ9X6LaQT1bjALb5/nWHOYlpunoEVDFzwcHeeQCT0xzGgFDutsSyLPCchbd3sqriUEeCoYCsOjtjc6+7SG+vagICu4iA9rvlaLZTIyNqrOu8yVlfD6KOwOT5+QM5MRWU5Ho
 bh3ZKgqd
 TLAVvHNotj3W/vCXvSj54lmQNFu/Jx+c9HeWrwmIqucaOz2zGERI2bAmK2/ewhGhrx/n727Wn5bo7ZCUvuLWE+GSJVCBWzcgRUd8WlaAo0sRmk1kRFmEzV2ubi/Soe5oX9DTaJGjTDYvHaSqDg5yQPuorjaz7XbbY9IpMu2QUXZlyKdSAqd3mAEPksTgdP8QObFYWMPBJw0LYPST1TvqVZCI5pud4MOQDqM7JrOFeCxACkXbyXHv5/ABmMXt2clMvJcjQPRSVwxvOw15gtQKyVUDQUDYGV5KMvRmHs1IsArQL6ZfvuRkVe2LOReBC18Xq16OvSZqcqjx40Wh1yTC/xhYhypP/gR96m/RgFAEBDzrpUe02O3XbNMR6Y52A0VVMYRqHUm6hSEg6tsIX6Qbve2rfUEe4bMwNO4oNhofmEx3c/YU0cxKjtP4l/A59MwxGiuU/cO0M5DFd+wSezmYddytE75vTs6HoPdmuQS9s6W4PO1D/IiUKbMo5BCbREPmE9viz+KFHZiONtzbgUfH3XX76jcyXWFNLTLXida9q1m6HcidQheRlqni+tK6EEtWgpR4O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test early (before kho_init) and late allocations.
Also test allocations on primary and secondary boot, since kho_scratch
behaves differently.

Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
 lib/test_kho.c                        | 167 +++++++++++++++++++-------
 tools/testing/selftests/kho/init.c    |  36 +++++-
 tools/testing/selftests/kho/vmtest.sh |  36 +++++-
 3 files changed, 188 insertions(+), 51 deletions(-)

diff --git a/lib/test_kho.c b/lib/test_kho.c
index aa6a0956bb8b..90a49f7cc9ab 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -23,13 +23,17 @@
 
 #include <net/checksum.h>
 
-#define KHO_TEST_MAGIC	0x4b484f21	/* KHO! */
-#define KHO_TEST_FDT	"kho_test"
 #define KHO_TEST_COMPAT "kho-test-v1"
 
 static long max_mem = (PAGE_SIZE << MAX_PAGE_ORDER) * 2;
 module_param(max_mem, long, 0644);
 
+static bool second_boot;
+module_param(second_boot, bool, 0644);
+
+static bool third_boot;
+module_param(third_boot, bool, 0644);
+
 struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
@@ -40,7 +44,25 @@ struct kho_test_state {
 	__wsum csum;
 };
 
-static struct kho_test_state kho_test_state;
+struct kho_superstate {
+	struct kho_test_state kho_test_state;
+	const char *kho_test_fdt;
+	int kho_test_magic;
+};
+
+static struct kho_superstate kho_superstate[] = {
+	{{}, "kho_test0", 0x4b484f30},	/* KHO0 */
+	{{}, "kho_test1", 0x4b484f31},
+	{{}, "kho_test2", 0x4b484f32},
+	{{}, "kho_test3", 0x4b484f33},
+};
+
+enum superstate_index {
+	FIRST_BOOT_EARLY_ALLOC,
+	FIRST_BOOT_LATE_ALLOC,
+	SECOND_BOOT_EARLY_ALLOC,
+	SECOND_BOOT_LATE_ALLOC,
+};
 
 static void kho_test_unpreserve_data(struct kho_test_state *state)
 {
@@ -94,10 +116,11 @@ static int kho_test_preserve_data(struct kho_test_state *state)
 	return err;
 }
 
-static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
+static int kho_test_prepare_fdt(struct kho_superstate *superstate, ssize_t fdt_size)
 {
+	struct kho_test_state *state = &superstate->kho_test_state;
 	const char compatible[] = KHO_TEST_COMPAT;
-	unsigned int magic = KHO_TEST_MAGIC;
+	unsigned int magic = superstate->kho_test_magic;
 	void *fdt = folio_address(state->fdt);
 	int err;
 
@@ -121,10 +144,11 @@ static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
 	return err;
 }
 
-static int kho_test_preserve(struct kho_test_state *state)
+static int kho_test_preserve(struct kho_superstate *superstate)
 {
 	ssize_t fdt_size;
 	int err;
+	struct kho_test_state *state = &superstate->kho_test_state;
 
 	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
 	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
@@ -139,11 +163,11 @@ static int kho_test_preserve(struct kho_test_state *state)
 	if (err)
 		goto err_unpreserve_fdt;
 
-	err = kho_test_prepare_fdt(state, fdt_size);
+	err = kho_test_prepare_fdt(superstate, fdt_size);
 	if (err)
 		goto err_unpreserve_data;
 
-	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt),
+	err = kho_add_subtree(superstate->kho_test_fdt, folio_address(state->fdt),
 			      fdt_totalsize(folio_address(state->fdt)));
 	if (err)
 		goto err_unpreserve_data;
@@ -202,14 +226,12 @@ static int kho_test_generate_data(struct kho_test_state *state)
 	return -ENOMEM;
 }
 
-static int kho_test_save(void)
+static int kho_test_alloc(struct kho_test_state *state)
 {
-	struct kho_test_state *state = &kho_test_state;
 	struct folio **folios;
 	unsigned long max_nr;
 	int err;
 
-	max_mem = PAGE_ALIGN(max_mem);
 	max_nr = max_mem >> PAGE_SHIFT;
 
 	folios = kvmalloc_objs(*state->folios, max_nr);
@@ -221,10 +243,6 @@ static int kho_test_save(void)
 	if (err)
 		goto err_free_folios;
 
-	err = kho_test_preserve(state);
-	if (err)
-		goto err_free_folios;
-
 	return 0;
 
 err_free_folios:
@@ -232,6 +250,18 @@ static int kho_test_save(void)
 	return err;
 }
 
+static int kho_test_alloc_and_preserve(int nr)
+{
+	struct kho_test_state *state = &kho_superstate[nr].kho_test_state;
+	int err;
+
+	err = kho_test_alloc(state);
+	if (err)
+		return err;
+
+	return kho_test_preserve(&kho_superstate[nr]);
+}
+
 static int kho_test_restore_data(const void *fdt, int node)
 {
 	const struct kho_vmalloc *folios_info_phys;
@@ -284,12 +314,31 @@ static int kho_test_restore_data(const void *fdt, int node)
 	return 0;
 }
 
-static int kho_test_restore(phys_addr_t fdt_phys)
+static int kho_test_early_alloc(void)
+{
+	if (third_boot)
+		return 0;
+	else if (second_boot)
+		return kho_test_alloc(&kho_superstate[SECOND_BOOT_EARLY_ALLOC].kho_test_state);
+	else
+		return kho_test_alloc(&kho_superstate[FIRST_BOOT_EARLY_ALLOC].kho_test_state);
+}
+core_initcall(kho_test_early_alloc);
+
+static int kho_test_restore(int nr)
 {
-	void *fdt = phys_to_virt(fdt_phys);
-	const unsigned int *magic;
 	int node, len, err;
+	phys_addr_t fdt_phys;
+	void *fdt;
+	const unsigned int *magic;
 
+	err = kho_retrieve_subtree(kho_superstate[nr].kho_test_fdt, &fdt_phys, NULL);
+	if (err) {
+		pr_err("failed to retrieve %s FDT: %d\n", kho_superstate[nr].kho_test_fdt, err);
+		return err;
+	}
+
+	fdt = phys_to_virt(fdt_phys);
 	node = fdt_path_offset(fdt, "/");
 	if (node < 0)
 		return -EINVAL;
@@ -301,62 +350,90 @@ static int kho_test_restore(phys_addr_t fdt_phys)
 	if (!magic || len != sizeof(*magic))
 		return -EINVAL;
 
-	if (*magic != KHO_TEST_MAGIC)
+	if (*magic != kho_superstate[nr].kho_test_magic)
 		return -EINVAL;
 
 	err = kho_test_restore_data(fdt, node);
 	if (err)
-		return err;
+		pr_err("KHO restore failed\n");
+	else
+		pr_info("KHO restore succeeded\n");
+
+	return err;
+}
+
+extern struct kho_scratch *kho_scratch;
+extern unsigned int kho_scratch_cnt;
 
+static int check_cma(void)
+{
+	for (int i = 0; i < kho_scratch_cnt; i++) {
+		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
+		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;
+		unsigned long pfn;
+
+		for (pfn = base_pfn; pfn < base_pfn + count;
+		     pfn += pageblock_nr_pages)
+			if (get_pageblock_migratetype(pfn_to_page(pfn)) != MIGRATE_CMA) {
+				pr_err("KHO wrong migratetype\n");
+				return 1;
+			}
+	}
 	return 0;
 }
 
 static int __init kho_test_init(void)
 {
-	phys_addr_t fdt_phys;
 	int err;
 
 	if (!kho_is_enabled())
 		return 0;
 
-	err = kho_retrieve_subtree(KHO_TEST_FDT, &fdt_phys, NULL);
-	if (!err) {
-		err = kho_test_restore(fdt_phys);
-		if (err)
-			pr_err("KHO restore failed\n");
-		else
-			pr_info("KHO restore succeeded\n");
-
-		return err;
-	}
+	if (check_cma())
+		return -EINVAL;
 
-	if (err != -ENOENT) {
-		pr_warn("failed to retrieve %s FDT: %d\n", KHO_TEST_FDT, err);
-		return err;
+	if (third_boot) {
+		err = kho_test_restore(SECOND_BOOT_EARLY_ALLOC);
+		err |= kho_test_restore(SECOND_BOOT_LATE_ALLOC);
+	} else if (second_boot) {
+		err = kho_test_restore(FIRST_BOOT_EARLY_ALLOC);
+		err |= kho_test_restore(FIRST_BOOT_LATE_ALLOC);
+
+		err |= kho_test_preserve(&kho_superstate[SECOND_BOOT_EARLY_ALLOC]);
+		err |= kho_test_alloc_and_preserve(SECOND_BOOT_LATE_ALLOC);
+	} else {
+		err = kho_test_preserve(&kho_superstate[FIRST_BOOT_EARLY_ALLOC]);
+		err |= kho_test_alloc_and_preserve(FIRST_BOOT_LATE_ALLOC);
 	}
-
-	return kho_test_save();
+	return err;
 }
 module_init(kho_test_init);
 
-static void kho_test_cleanup(void)
+static void kho_test_cleanup(struct kho_test_state *state)
 {
+	kho_remove_subtree(folio_address(state->fdt));
+
 	/* unpreserve and free the data stored in folios */
-	kho_test_unpreserve_data(&kho_test_state);
-	for (int i = 0; i < kho_test_state.nr_folios; i++)
-		folio_put(kho_test_state.folios[i]);
+	kho_test_unpreserve_data(state);
+	for (int i = 0; i < state->nr_folios; i++)
+		folio_put(state->folios[i]);
 
-	kvfree(kho_test_state.folios);
+	kvfree(state->folios);
 
 	/* Unpreserve and release the FDT folio */
-	kho_unpreserve_folio(kho_test_state.fdt);
-	folio_put(kho_test_state.fdt);
+	kho_unpreserve_folio(state->fdt);
+	folio_put(state->fdt);
 }
 
 static void __exit kho_test_exit(void)
 {
-	kho_remove_subtree(folio_address(kho_test_state.fdt));
-	kho_test_cleanup();
+	if (second_boot) {
+		kho_test_cleanup(&kho_superstate[SECOND_BOOT_EARLY_ALLOC].kho_test_state);
+		kho_test_cleanup(&kho_superstate[SECOND_BOOT_LATE_ALLOC].kho_test_state);
+	} else {
+		kho_test_cleanup(&kho_superstate[FIRST_BOOT_EARLY_ALLOC].kho_test_state);
+		kho_test_cleanup(&kho_superstate[FIRST_BOOT_LATE_ALLOC].kho_test_state);
+	}
 }
 module_exit(kho_test_exit);
 
diff --git a/tools/testing/selftests/kho/init.c b/tools/testing/selftests/kho/init.c
index 88a41b6eba95..18cf180c3322 100644
--- a/tools/testing/selftests/kho/init.c
+++ b/tools/testing/selftests/kho/init.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <string.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <fcntl.h>
@@ -12,6 +13,17 @@
 #define COMMAND_LINE_SIZE	2048
 
 #define KERNEL_IMAGE "/kernel"
+#define INITRD_IMAGE "/initrd"
+
+void console_log(char *log)
+{
+	static int fd;
+
+	if (!fd)
+		fd = open("/dev/console", O_WRONLY);
+
+	write(fd, log, strlen(log) + 1);
+}
 
 static int mount_filesystems(void)
 {
@@ -29,11 +41,14 @@ static long kexec_file_load(int kernel_fd, int initrd_fd,
 		       cmdline, flags);
 }
 
+#define CMDLINE_SECOND " test_kho.second_boot=1"
+#define CMDLINE_THIRD " test_kho.third_boot=1"
+
 static int kexec_load(void)
 {
 	char cmdline[COMMAND_LINE_SIZE];
 	ssize_t len;
-	int fd, err;
+	int fd, err, initfd;
 
 	fd = open("/proc/cmdline", O_RDONLY);
 	if (fd < 0)
@@ -50,6 +65,25 @@ static int kexec_load(void)
 	if (fd < 0)
 		return -1;
 
+	if (!strstr(cmdline, CMDLINE_SECOND)) {
+		console_log("init: first boot detected\n");
+
+		strcat(cmdline, CMDLINE_SECOND);
+		len = strlen(cmdline) + 1;
+		initfd = open(INITRD_IMAGE, O_RDONLY);
+		if (initfd < 0)
+			return -1;
+
+		err = kexec_file_load(fd, initfd, len, cmdline, 0);
+		close(fd);
+		close(initfd);
+		return err ? : 0;
+	}
+
+	console_log("init: second boot detected\n");
+	strcat(cmdline, CMDLINE_THIRD);
+	len = strlen(cmdline) + 1;
+
 	err = kexec_file_load(fd, -1, len, cmdline, KEXEC_FILE_NO_INITRAMFS);
 	close(fd);
 
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 0014bd76e88d..e7bd1b84bbe8 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -43,6 +43,14 @@ function fail() {
 	local msg=${1:-""}
 
 	ktap_test_fail "$msg"
+
+	local serial_log="$tmp_dir/qemu.serial"
+	if [[ -f "$serial_log" ]]; then
+		echo "=== QEMU Serial Output ===" >&2
+		cat "$serial_log" >&2
+		echo "==========================" >&2
+	fi
+
 	exit "$KSFT_FAIL"
 }
 
@@ -84,11 +92,11 @@ EOF
 
 function mkinitrd() {
 	local kernel=$1
+	local initrd_temp="$tmp_dir/initrd_temp.cpio"
 
-	"$CROSS_COMPILE"gcc -s -static -Os -nostdinc -nostdlib \
+	"$CROSS_COMPILE"gcc -s -static -Os \
 			-fno-asynchronous-unwind-tables -fno-ident \
 			-I "$headers_dir/include" \
-			-I "$kernel_dir/tools/include/nolibc" \
 			-o "$tmp_dir/init" "$test_dir/init.c"
 
 	cat > "$tmp_dir/cpio_list" <<EOF
@@ -98,6 +106,18 @@ dir /debugfs 0755 0 0
 nod /dev/console 0600 0 0 c 5 1
 file /init $tmp_dir/init 0755 0 0
 file /kernel $kernel 0644 0 0
+EOF
+
+	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd_temp"
+
+	cat > "$tmp_dir/cpio_list" <<EOF
+dir /dev 0755 0 0
+dir /proc 0755 0 0
+dir /debugfs 0755 0 0
+nod /dev/console 0600 0 0 c 5 1
+file /init $tmp_dir/init 0755 0 0
+file /kernel $kernel 0644 0 0
+file /initrd $initrd_temp 0755 0 0
 EOF
 
 	"$build_dir/usr/gen_init_cpio" "$tmp_dir/cpio_list" > "$initrd"
@@ -109,16 +129,22 @@ function run_qemu() {
 	local kernel=$3
 	local serial="$tmp_dir/qemu.serial"
 
-	cmdline="$cmdline kho=on panic=-1"
+	# 2GiB of preserved mem to exhaust memory initialized early
+	cmdline="$cmdline kho=on panic=-1 test_kho.max_mem=2147483648 \
+ ignore_loglevel earlyprintk=serial,ttyS0,115200 printk.time=1"
 
-	$qemu_cmd -m 1G -smp 2 -no-reboot -nographic -nodefaults \
+	$qemu_cmd -m 8G -smp 2 -no-reboot -nographic -nodefaults \
 		  -accel kvm -accel hvf -accel tcg  \
 		  -serial file:"$serial" \
 		  -append "$cmdline" \
 		  -kernel "$kernel" \
 		  -initrd "$initrd"
 
-	grep "KHO restore succeeded" "$serial" &> /dev/null || fail "KHO failed"
+	count="$(grep --text "KHO restore succeeded" $serial | wc -l)"
+	echo Successful restores: "$count"
+	if [[ $count -ne 4 ]]; then
+		fail "KHO failed"
+	fi
 }
 
 function target_to_arch() {
-- 
2.54.0.563.g4f69b47b94-goog


