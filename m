Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4460606D683
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oZuVQYTt
Received: by kanga.kvack.org (Postfix)
	id 375836B05BA; Tue, 10 Nov 2026 00:02:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FE676B05BB; Tue, 10 Nov 2026 00:02:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178016B05BC; Tue, 10 Nov 2026 00:02:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D601E6B05BA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B45261404F8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:11 +0000 (UTC)
X-FDA: 85418012862.18.CB348ED
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf13.hostedemail.com (Postfix) with ESMTP id 031D720004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oZuVQYTt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3UKXyagkKCMM2j03w1jq3pxxpun.lxvurw36-vvt4jlt.x0p@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3UKXyagkKCMM2j03w1jq3pxxpun.lxvurw36-vvt4jlt.x0p@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sj2aHvE/30fRUSODl4VGY86EHM+govAz/p3nvPD2KF0=;
	b=N13e02RnIY6hks1dfU0GK1wHaC0abbkuvKLCqCWbGMBSwgRHu8wqaAMmlolJwdqhivXjO0
	miEeUNCWiEVcpIRE0xcWGo8/SR486fldfq+KJkmO7NRRvihSBVcoB4UON3JB+n5qYCw2S1
	fydm8otlZo+hRF5NGm7B3wxahJZdf5s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oZuVQYTt;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3UKXyagkKCMM2j03w1jq3pxxpun.lxvurw36-vvt4jlt.x0p@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3UKXyagkKCMM2j03w1jq3pxxpun.lxvurw36-vvt4jlt.x0p@flex--tarunsahu.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286930;
	b=gp0WQio+q5rD9SAXnDdfqOstg5x+oa+gmAiygqmpfOfAz5ekLK29smUeiWXa9zhk7vmiqa
	35STar6n7jrYl0kIEeSC19tPuC6ZUEEW3g0bCoZasxlNnYjP9QNetSpHGoiYi4SQok1gmd
	zP0DVHrn0F9ssqdSXzyjxFV16WkjcSM=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0c06so1441506a12.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286929; x=1794891729; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sj2aHvE/30fRUSODl4VGY86EHM+govAz/p3nvPD2KF0=;
        b=oZuVQYTtkI5sLK297BdIWIYBE++mZUMeqYHEvBrNaupCDDnc3z0wd3QXEM4JRzP+9e
         z0ocZgy5uc6ekp8qN35e6fUp0bJ1Mnbo+t8Mn0djqg95NJNuo3OMzVdmbpgE6n+gSC/c
         +Y9XXNtxlQryZ5gqfTJo6+bDgG/aWBZqGO9KwenMtJRSUDaOdwPOH5O+pbuZCUI2Bxu5
         MGsFjPhLf1lFsTwDdlXtoSPN3nsa9qnTnv7SjSj+Aok77FmPfFYydm59JN1Tey2I3PL7
         cCn2VFvhkRc7e069to5QAG2MjfUz3/+8d1SrpkXGHV4E68FzxWFXshtXxoCoeWF26NJ3
         Lc7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286929; x=1794891729;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Sj2aHvE/30fRUSODl4VGY86EHM+govAz/p3nvPD2KF0=;
        b=VLiV9xEWK5MetOsLJPGePX4R2jvi32KzzwK+lJg+0F/YAUX8LFDe+g7dC9FEPwy5yU
         YiWFVZbXNzM9D5d6t3v5nYCsGuoGLBN/1M6o5QDTypLUmTAG9H70p3KPz6Z+wGlACMyj
         45WADfOvuuEzCFRmxLXVgCUZLLod1Ya5zhOz9NiWhRJBbWQYX/wFcBdZShBnlDl60R/B
         UCziAdZMtCp7LASV9D3Aysq5h4QrkEJoSff+e2u9uAPA/FdinarJkVvMHmSUVmed/qve
         9nYYSRsO1IeDKfIdk5gGjTG/6LjGii3pgRAJ9ee7xph7Mm6c1u53eshm02Vjeqk4sUo3
         CQrQ==
X-Forwarded-Encrypted: i=1; AL+hErHspQHuIaImGSYfgc8II6rCiWn7MWl2+LioJxkmkRuA8saxb/oQ1rCZvzb52hmBqg98TmVtHKC2Hg==@kvack.org
X-Gm-Message-State: APuU4Z+i8br+N/IdMQmA2DhZO27T23Oepc5dJmHFURm+peaP3GNt7Hdk
	jsWnIbfybN8pQSjGkKvmTRajvLm4j33f5ArPXgbFaosF6QORctK9uAaI9alIU4rTtsglfJV8Q6i
	RxuDIcUOfTetYy/x4iw==
X-Received: from ejczh1.prod.google.com ([2002:a17:907:e901:b0:c42:9eb:1d43])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3f03:b0:c50:475d:9804 with SMTP id a640c23a62f3a-c5049583bf0mr103443266b.13.1794286928328;
 Mon, 09 Nov 2026 21:02:08 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:46 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-4-tarunsahu@google.com>
Subject: [PATCH v4 03/19] kho, memfd_luo: Reference struct kho_vmalloc via
 serialized pointer
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 031D720004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1qzsgm9jisk3da5cqf8u3c61s4cbm3ao
X-HE-Tag: 1794286929-693609
X-HE-Meta: U2FsdGVkX1/bzWeorsenK6k9DccA79V0iFXsoTm9piVcbd0n3n9vvo0HMlDBWR+NXabjU9f3Jb6uEtSri9cQ3fxKsxrA0arJAfbjCi2V6v1auYuPq7K+y2Kn2uOCfbaV/A9QSA7Vt/ChZ1E7NbQ3HQdb/z8FQER8bRoeOJ3gc61kQ5EbcmoQJxQX9ihaNUC+M4zkEd6v8Rswzc3PbYXiyRSHgsBESgqAtnsdfmGK0Zo1sEKKGmfOp1qvu7ss4C5IBausoR3YF/I2Zhan8j4mqYScFuCudMiIABgSN2fyg9c5FkpXLpSiQkz2vnaXIczVqGVJbjOvtPt/st8WP2gDRaF0xfnuiVKxnKhIFQqafrW+x1JsmQrdF8N8MG6AK+vj53aOeJctUYzZFkOH+D8hlh2Yi0xnTdqLN3c6gxsGQeyTSLR4PaohvhB4QP7INHpdhmjXMQaGxo2NzIfHHt2vjt+8E4vA16HnDht26ajIf04RZ28KbPU4rxv7Ixg/rAHxauw8dDmEL/77fZLwtSRYHehZquD0iWXdNyQyWva6GF0IdTkf1pLg+5bGAh/0suWqW9IPCUPyxjJMX1P0YzehxHHy0IW14T+NUJwR0beZ1fByh8kGJeN2wMApxl/x7usAcX7OrQCEB4dD5+bh3ikDnLedj+PhBQjz4UuNKi5owOFk7YmtGZ+fk3HS9YPLBM/dLXX7kihAyoSmL6LFs+QWegAosZMU638GV7igRaBJzeGdeLXHpGyl229YW3R6PZrH1nhhz0WX/RYDjyoLCkiqEgw/cllmaWmkBFYKSJIrtIm+oYV1Ue18h6WQi1uzY8NWjR1MdD9C9+UtqvfRhII2oVlROMgyvrV4cnNyGk2y0SKW3YlEfq+inH/cEHN5INnQ8PAJNOWg7Jsa77fE9YRNN5mfYx/xi6/BHf1QvgANQF8GpLK44jzqQ7BQUCA3uAmvJEoDOlWMB3e1UxdC6e2
 +n9uNyCo
 GI5CYzxWYlOWyJnbdewy1HIHWKjNYWdzHQZ2UahcPAYe78yixzYKiuIjYPi+7hAuC1Cl1XyrqoLmQXZlgtg+hQIYIL1hUTUm34i/nh+udYpVlNqFkWwbkPGib08pBh+eVEJlLiIagBbAH5IfDhWrWpfsw7acsjA8WPNeyISx5XtWKPgwjJySTUrf/wCEP0d4rJwz5ce/2BLi0t/h1o4KVWwvs1QhtwYYWWjcz85UUMGcxLKjOPXY02Ox48/v9MnPmoWvpQc7j+T3HXJzAXka/hNsS9prka5RCe1/VxuJKqbv1rEmfFZvzMebIJNhdTZ0rnoi13GmwwzLhcbZ1TUPUm+B3SfHgxAtaSY4Gc7x+QJ3oAanaWNf/fEPkOzkGri53R2ALWH/WhKWoYUICG1nrbiiOF8oEDm9DMmfnP9Wi0GIWbvU3///iql+rIlxMrawsz1T1Q7NNv1E4KlYfafRVXX3BSO6Api7ASj3tt1kVwAy4E4zmEIERwi6Ls4PEuAI7HFs4wn4NvC8uOTgXrsOYQ8g33lbM6qhXDWZ+IcdtD1M6FC2xwT/9JfBrBm3mpZGgvrxAKacrkzH4a/cvVc9+yycHPmfe98YvproPL91zx21qStkZFYTcOZUI46ckAeENPPFqN212SW6E0Fl76xKnTEMEZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Subsystems preserving vmalloc allocations currently embed struct
kho_vmalloc directly by value in their serialized structures or device
tree properties. For example, struct memfd_luo_ser embeds struct
kho_vmalloc folios, and test_kho writes the structure directly into the
folios_info FDT property.

Embedding struct kho_vmalloc directly couples the containing layout's
field offsets and size to struct kho_vmalloc. Any modification to struct
kho_vmalloc shifts subsequent fields in the containing structure and
breaks the handover ABI across kexec.

Convert callers to hold a DECLARE_KHOSER_PTR pointer to struct
kho_vmalloc instead of embedding it by value. In memfd_luo, allocate the
main structure and struct kho_vmalloc in the same preserved folio, placing
struct kho_vmalloc in the remaining 8-byte-aligned space, and bump the
compatibility string to memfd-v3. In test_kho, place struct kho_vmalloc
in the remaining space of the FDT folio, store the serialized pointer in
the folios_info property, and bump the compatibility string to
kho-test-v2.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/kexec_handover.h |  6 +++
 include/linux/kho/abi/memfd.h          |  8 ++--
 lib/test_kho.c                         | 29 ++++++++----
 mm/memfd_luo.c                         | 63 ++++++++++++++++----------
 4 files changed, 68 insertions(+), 38 deletions(-)

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 6f12f5037ea5..bee75a7006e8 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -11,6 +11,8 @@
 #define _LINUX_KHO_ABI_KEXEC_HANDOVER_H
 
 #include <linux/bits.h>
+#include <linux/build_bug.h>
+#include <linux/kconfig.h>
 #include <linux/log2.h>
 #include <linux/math.h>
 #include <linux/types.h>
@@ -177,6 +179,10 @@ struct kho_vmalloc {
 	unsigned short order;
 };
 
+static_assert(sizeof(struct kho_vmalloc) == 16);
+static_assert(!IS_ENABLED(CONFIG_64BIT) ||
+	      __alignof__(struct kho_vmalloc) == 8);
+
 /**
  * DOC: KHO persistent memory tracker
  *
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 376a724a1d8c..7b49dd6d7e2a 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -81,7 +81,7 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  *             to directly use them in the ABI.
  * @flags:     Flags for the file. Unused flag bits must be set to 0.
  * @nr_folios: Number of folios in the folios array.
- * @folios:    KHO vmalloc descriptor pointing to the array of
+ * @folios:    Pointer to KHO vmalloc descriptor for the array of
  *             struct memfd_luo_folio_ser.
  */
 struct memfd_luo_ser {
@@ -90,14 +90,14 @@ struct memfd_luo_ser {
 	u32 seals;
 	u32 flags;
 	u64 nr_folios;
-	struct kho_vmalloc folios;
+	DECLARE_KHOSER_PTR(folios, struct kho_vmalloc *);
 };
 
-static_assert(sizeof(struct memfd_luo_ser) == 48);
+static_assert(sizeof(struct memfd_luo_ser) == 40);
 static_assert(!IS_ENABLED(CONFIG_64BIT) ||
 	      __alignof__(struct memfd_luo_ser) == 8);
 
 /* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
+#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v3"
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/lib/test_kho.c b/lib/test_kho.c
index aa6a0956bb8b..cd0f183ff68e 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -25,7 +25,7 @@
 
 #define KHO_TEST_MAGIC	0x4b484f21	/* KHO! */
 #define KHO_TEST_FDT	"kho_test"
-#define KHO_TEST_COMPAT "kho-test-v1"
+#define KHO_TEST_COMPAT "kho-test-v2"
 
 static long max_mem = (PAGE_SIZE << MAX_PAGE_ORDER) * 2;
 module_param(max_mem, long, 0644);
@@ -34,7 +34,7 @@ struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
 	phys_addr_t *folios_info;
-	struct kho_vmalloc folios_info_phys;
+	DECLARE_KHOSER_PTR(folios_info_phys, struct kho_vmalloc *);
 	int nr_folios_preserved;
 	struct folio *fdt;
 	__wsum csum;
@@ -47,13 +47,13 @@ static void kho_test_unpreserve_data(struct kho_test_state *state)
 	for (int i = 0; i < state->nr_folios_preserved; i++)
 		kho_unpreserve_folio(state->folios[i]);
 
-	kho_unpreserve_vmalloc(&state->folios_info_phys);
+	if (KHOSER_LOAD_PTR(state->folios_info_phys))
+		kho_unpreserve_vmalloc(KHOSER_LOAD_PTR(state->folios_info_phys));
 	vfree(state->folios_info);
 }
 
 static int kho_test_preserve_data(struct kho_test_state *state)
 {
-	struct kho_vmalloc folios_info_phys;
 	phys_addr_t *folios_info;
 	int err;
 
@@ -61,11 +61,10 @@ static int kho_test_preserve_data(struct kho_test_state *state)
 	if (!folios_info)
 		return -ENOMEM;
 
-	err = kho_preserve_vmalloc(folios_info, &folios_info_phys);
+	err = kho_preserve_vmalloc(folios_info, KHOSER_LOAD_PTR(state->folios_info_phys));
 	if (err)
 		goto err_free_info;
 
-	state->folios_info_phys = folios_info_phys;
 	state->folios_info = folios_info;
 
 	for (int i = 0; i < state->nr_folios; i++) {
@@ -123,14 +122,19 @@ static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
 
 static int kho_test_preserve(struct kho_test_state *state)
 {
-	ssize_t fdt_size;
+	struct kho_vmalloc *folios_vmalloc;
+	ssize_t fdt_size, alloc_size;
 	int err;
 
 	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
-	state->fdt = folio_alloc(GFP_KERNEL, get_order(fdt_size));
+	alloc_size = fdt_size + sizeof(struct kho_vmalloc);
+	state->fdt = folio_alloc(GFP_KERNEL, get_order(alloc_size));
 	if (!state->fdt)
 		return -ENOMEM;
 
+	folios_vmalloc = folio_address(state->fdt) + fdt_size;
+	KHOSER_STORE_PTR(state->folios_info_phys, folios_vmalloc);
+
 	err = kho_preserve_folio(state->fdt);
 	if (err)
 		goto err_free_fdt;
@@ -234,7 +238,8 @@ static int kho_test_save(void)
 
 static int kho_test_restore_data(const void *fdt, int node)
 {
-	const struct kho_vmalloc *folios_info_phys;
+	const DECLARE_KHOSER_PTR(*folios_info_phys, struct kho_vmalloc *);
+	const struct kho_vmalloc *folios_vmalloc;
 	const unsigned int *nr_folios;
 	phys_addr_t *folios_info;
 	const __wsum *old_csum;
@@ -255,7 +260,11 @@ static int kho_test_restore_data(const void *fdt, int node)
 	if (!folios_info_phys || len != sizeof(*folios_info_phys))
 		return -EINVAL;
 
-	folios_info = kho_restore_vmalloc(folios_info_phys);
+	folios_vmalloc = KHOSER_LOAD_PTR(*folios_info_phys);
+	if (!folios_vmalloc)
+		return -EINVAL;
+
+	folios_info = kho_restore_vmalloc(folios_vmalloc);
 	if (!folios_info)
 		return -EINVAL;
 
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6b68220275eb..4471cced57db 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -85,9 +85,8 @@
 #include "internal.h"
 
 static int memfd_luo_preserve_folios(struct file *file,
-				     struct kho_vmalloc *kho_vmalloc,
-				     struct memfd_luo_folio_ser **out_folios_ser,
-				     u64 *nr_foliosp)
+				     struct memfd_luo_ser *ser,
+				     struct memfd_luo_folio_ser **out_folios_ser)
 {
 	struct inode *inode = file_inode(file);
 	struct memfd_luo_folio_ser *folios_ser;
@@ -104,7 +103,8 @@ static int memfd_luo_preserve_folios(struct file *file,
 	 * are not set.
 	 */
 	if (!size) {
-		*nr_foliosp = 0;
+		ser->folios.phys = 0;
+		ser->nr_folios = 0;
 		*out_folios_ser = NULL;
 		return 0;
 	}
@@ -200,12 +200,12 @@ static int memfd_luo_preserve_folios(struct file *file,
 		pfolio->index = folio->index;
 	}
 
-	err = kho_preserve_vmalloc(folios_ser, kho_vmalloc);
+	err = kho_preserve_vmalloc(folios_ser, KHOSER_LOAD_PTR(ser->folios));
 	if (err)
 		goto err_unpreserve;
 
 	kvfree(folios);
-	*nr_foliosp = nr_folios;
+	ser->nr_folios = nr_folios;
 	*out_folios_ser = folios_ser;
 
 	/*
@@ -254,37 +254,43 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 	vfree(folios_ser);
 }
 
+static size_t memfd_luo_ser_size(void)
+{
+	return sizeof(struct memfd_luo_ser) + sizeof(struct kho_vmalloc);
+}
+
+static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
+{
+	struct kho_vmalloc *kho_vmalloc = mem + sizeof(struct memfd_luo_ser);
+	struct memfd_luo_ser *ser = mem;
+
+	KHOSER_STORE_PTR(ser->folios, kho_vmalloc);
+	return ser;
+}
+
 static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
-	u64 nr_folios, inode_size;
 	int err = 0, seals;
+	u64 inode_size;
 
 	inode_lock(inode);
 	shmem_freeze(inode, true);
 
-	/* Allocate the main serialization structure in preserved memory */
-	ser = kho_alloc_preserve(sizeof(*ser));
-	if (IS_ERR(ser)) {
-		err = PTR_ERR(ser);
-		goto err_unlock;
-	}
-
 	seals = memfd_get_seals(args->file);
 	if (seals < 0) {
 		err = seals;
-		goto err_free_ser;
+		goto err_unlock;
 	}
 
 	/* Make sure the file only has the seals supported by this version. */
 	if (seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;
-		goto err_free_ser;
+		goto err_unlock;
 	}
 
-	ser->pos = args->file->f_pos;
 	inode_size = i_size_read(inode);
 
 	/*
@@ -293,18 +299,26 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	 */
 	if (DIV_ROUND_UP_ULL(inode_size, PAGE_SIZE) > UINT_MAX) {
 		err = -EFBIG;
-		goto err_free_ser;
+		goto err_unlock;
+	}
+
+	/* Allocate the main serialization structure in preserved memory */
+	ser = kho_alloc_preserve(memfd_luo_ser_size());
+	if (IS_ERR(ser)) {
+		err = PTR_ERR(ser);
+		goto err_unlock;
 	}
+	ser = memfd_luo_ser_init(ser);
 
+	ser->pos = args->file->f_pos;
 	ser->size = inode_size;
 	ser->seals = seals;
+	ser->flags = 0;
 
-	err = memfd_luo_preserve_folios(args->file, &ser->folios,
-					&folios_ser, &nr_folios);
+	err = memfd_luo_preserve_folios(args->file, ser, &folios_ser);
 	if (err)
 		goto err_free_ser;
 
-	ser->nr_folios = nr_folios;
 	inode_unlock(inode);
 
 	args->private_data = folios_ser;
@@ -351,7 +365,8 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 
 	ser = phys_to_virt(args->serialized_data);
 
-	memfd_luo_unpreserve_folios(&ser->folios, args->private_data,
+	memfd_luo_unpreserve_folios(KHOSER_LOAD_PTR(ser->folios),
+				    args->private_data,
 				    ser->nr_folios);
 
 	kho_unpreserve_free(ser);
@@ -401,7 +416,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 		return;
 
 	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(&ser->folios);
+		folios_ser = kho_restore_vmalloc(KHOSER_LOAD_PTR(ser->folios));
 		if (!folios_ser)
 			goto out;
 
@@ -552,7 +567,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(&ser->folios);
+		folios_ser = kho_restore_vmalloc(KHOSER_LOAD_PTR(ser->folios));
 		if (!folios_ser) {
 			err = -EINVAL;
 			goto put_file;
-- 
2.56.0.506.g506a7eabc5-goog


