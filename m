Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D549606E4A4
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n40vrBBp
Received: by kanga.kvack.org (Postfix)
	id 6A99B6B05BD; Tue, 10 Nov 2026 00:02:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633036B05BE; Tue, 10 Nov 2026 00:02:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D50F6B05BF; Tue, 10 Nov 2026 00:02:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FFC26B05BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A55D12089F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:16 +0000 (UTC)
X-FDA: 85418013072.01.6CD25FC
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf03.hostedemail.com (Postfix) with ESMTP id B640320007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n40vrBBp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3VaXyagkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3VaXyagkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ebeh5Rs4TXuXQtxviE5PkM1eDaH/25gqcmQnH1h2ass=;
	b=sR37KExXznUQHztH4Drnv0xWBGTWXQAu/GIycpAniliXzc7Rv8qD/VTYAG+O1pL9Ckl55s
	aPosn8du0gjxh+I43kg7Vp3N+9LNtOQCsbyl3hbGogpzeAfmvRv4x5XBRrEbpHtpLzGcer
	3daF/NuOXOq4RlZhWwhqADuHPBHa+Kw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286934;
	b=Cvcpw4iNAjvA3OSsj73OkIpKKguJ+jsgOy/mRzNhQS89IQ2niOQZk+JMtVJ0d7fjI4Oh89
	yBw5yir6idW4Tjt67enSNvjVn0agns8q33Mf+D+38UZcSxN6ott3PWoMN2RBIsdZBg2Ji4
	xQEkbimHt4ntH9pPLLMy6SxLyZV6N0w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n40vrBBp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3VaXyagkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3VaXyagkKCMg7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6a615ab0c06so1441555a12.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286933; x=1794891733; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ebeh5Rs4TXuXQtxviE5PkM1eDaH/25gqcmQnH1h2ass=;
        b=n40vrBBpOaZXA5Jl5I6rF48esWYa+owt+OKNqbp41oN7jfsoRa8U+EQS282XCTF0aa
         0jMZZ6zbCEIN6hao4CuPFvCkC4DdBoCDDPpgNQPRXCNLaDoHEymZ/l/0gsNKZBQM6rbM
         WO5Y1ifPO113jfWNJcsvvzBvEY+hNuiQyWMkvhBZr0XC1+qNwerRhHXO/WxXwOi3rmgy
         fi3JepYagOvJPcpIrMcKnAhcG27Vy5OHh/h3sJTRUG+87ZGH2c7Ck+jXZTr6jew9jm+4
         UZQiVTrgoQf9aHWa0D3BlVfz1TTvFxtxqw3iHNkHWknYnT7R14qfGIIb6OifwUJRpNuo
         3irQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286933; x=1794891733;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ebeh5Rs4TXuXQtxviE5PkM1eDaH/25gqcmQnH1h2ass=;
        b=kh6LQnN6ybbx8RMpafJvLKYZkfBqJ5EXMki5qX98tAmDqTRyApVV38enYjsgOEAaYm
         nisNCa5WXjV+oFoYWNH9N14rqE7r1MEAeNkOkmSqkuvUOm6g+RKL4K9p/dcTwfcGUA1T
         Nwh9mieqZUh0OzuaUrECo/x592UhxRmXff21NQCF7QxQJEZnoKQsAzU/q4Um2cpdJneM
         qPtuRnfpy1ZNPSTijs07SJ0onlp6p0Ex9y9zcpMtmGJqCXTlk+TA8AkXEt+sGRtlDXm9
         QfvzOKgqCUdSu/pgvVR4GzmVtl9KESjzJHAQnmEajPOAj7LG4mqP55sgt+Bm4FSDHrG6
         Y9oQ==
X-Forwarded-Encrypted: i=1; AL+hErHE7X+1JLdBTHJX84eFxf1puUPriV/f4HFD+5/TyFiib7FsE9TJ8NkwaLjiOdImiHywEg0FNa+wBQ==@kvack.org
X-Gm-Message-State: APuU4Z9XiollRAZCRi3JwXMuscDnc3I4dmZ1KP6v12Bvpr/xbVaG6JFa
	o30z9lNPhZ7SIbMfXbUfJC9TxGpT6s5O3u0CXbZZLLUgtE7apenSs0IA5rMNQDSNTLXgLjZfHNd
	+U7fm1lrBu1spmfm/Lw==
X-Received: from edsa5.prod.google.com ([2002:aa7:d745:0:b0:6af:ab34:1a21])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:43cb:b0:6b7:1bb8:5a5 with SMTP id 4fb4d7f45d1cf-6b756ad506dmr1143844a12.19.1794286933123;
 Mon, 09 Nov 2026 21:02:13 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:50 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-8-tarunsahu@google.com>
Subject: [PATCH v4 07/19] kho: vmalloc: Add the feature header
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
X-Stat-Signature: m187qyhja6yfri67mzb8r5j4c1m71pc8
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B640320007
X-HE-Tag: 1794286934-99818
X-HE-Meta: U2FsdGVkX19EsLFP6WCF9/2noUeogC/TRH6JmkbglnQq12FBvv51pBVwJPrMeTxpQBceg1lZSoK+OzO9GgewEv7nVKJWe5GjnzHANaAy6gZEFjDSvS5zJbhXHhlEgpIjgiMDj96BtE0Nloo6bkq2h+oilCox4Tmk6+GUa4a3pndnPCJBiG/bUua6/nBHD1/mbfumC37S3SpmBdAm96Y/OTEg5AA+4x3P2LeWfpEbaJ4BFXLrYt7r4/T7V/rs1lwhMG7gqKEw4gOC8vCAM6Rs93mKV7HcXDk4p/wsFyazs2l35K9FMgbtRVblHHmgyfZ6skmGY3UL2SFNyEmSzMfVFX3pqkoqMW2dVKvqcRlCl1xZIRohIvl8TuVvb5oD+c6+NTR7aUia6e2a8lcOnCeEHlDmSLnBeIe3xSIur36Pw8MiLs7xDlKcdHRgsXXpxsfqLUoBwtwKwkLByC9ATUyLhZsdAuSQI2pXD+dqW8CqYXIfzLEgPICNYIIj/U6LkWmPxeAD7N5LcsbyazduwU4u21Mz/abVoqOutuJxR75Cjr1T6USkiscCDLVhHLQ2sO7VY0vEc6zfLmtiSZG37YxgS5cyBinCsFJv0MwSkerux4WJ2EFPmZay3Ob8NqyiGsaEt2zN5jXYQJuSa41p5BJic9n6JEQcakTVldchPJeziM2rgAsDSn4vnfJDOtwQd1hb/QGZQsdWuI45RLLZK7WLyxuv+RFUuI7bbStKb8yx3Q6DxHGDY+sq3IST8KtHLjDfrDF9YYW8abIrclMcr3RA17C6lk8WjhMI7P0sqRhqp61o1led8TDpTpvfq54M0DD9inLolj+0Mw96Bxi+I5JYCHxj4rNp9jMEwu6MXAjuxaVwkjDaLAOxCko7EyVLZG4CMjvufowomB1Cd17NlItPsC6jjDdu8ZciTscPymXsnc8X0uGW6ncafvf3V2yYo15XwRyCwHNE2uY0dXGvXOE
 6FGyj8PP
 4AnyscK/FhBijFXMR7LeOKMdiXSQW+SYBcqj30JLbwhaMsdHy00Xjm27w3ywnI722f/pAQYzmfV58cir3PWLXD6ZJr2h7UBcl043o1ifcfGZJlkPm8HsmwGAJZddVrjNKkGlfPtut/T3Os1SxLLp+sYIXQ6CqBmbMH5OfHwqPOjZGrVwCv7zLTHf/wZ7tMIZ64J0W8kCEZlw+Tr/w3b8RBbOKchojpQeL2Ol6cO7hqS26D2csyaMvQ90//l4cWT9pdniI9GPNkhHcgGio3OG09RfDX8xOOTT3yuPlevHdrPpl4yz/t9iOzlIf3+7T4fWv1it6lwenckQXXlsyNAJPcji2zeXgC+lp3JPZzJtByqKfy/kZe9Gtsr/HCiU7MjhaAEXZf6bWZdpHu/5ZgPoiZyXq4BlzGhrEZkf7BhfGYB7JeKTPxW1Sdh0oVexywaCzjG12phWLHH0P0H/rhniDyahS54S8MEjUIkGhF3k/cPgZNebrPJ4FRu0Gqvj/gw0cHElTwjxUHbJ328Hv6/PW29fvVhOyzPCZ7Mkn0KM7QT7MPfdAg3mwztgxjUPkxU4pHAsS4FdAyDtGO08aqbQIels1NODRrZvqK/5K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Register struct kho_vmalloc with the KHO serialization feature header
mechanism to allow future additive fields or feature extensions without
breaking live update ABI compatibility.

Add DECLARE_KHO_SER(kho_vmalloc, 16, 0, 0) to register the 16-byte
structure with 0 required and 0 optional features. Update function
prototypes in include/linux/kexec_handover.h to take
DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr) parameters, documenting which
registered structure the feature header belongs to while enforcing
compile-time type verification.

In kho_preserve_vmalloc(), initialize the feature header with
kho_ser_init() and access the payload fields via kho_ser_payload().
In kho_restore_vmalloc(), validate incoming required features with
kho_ser_validate() and access payload fields via kho_ser_payload().
In kho_unpreserve_vmalloc(), access payload fields via kho_ser_payload().
The chunk page format and traversal remain unchanged.

Update memfd_luo and test_kho to pass typed feature header pointers
and use kho_ser_size() for allocation sizing.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kexec_handover.h         | 15 +++----
 include/linux/kho/abi/kexec_handover.h |  5 +--
 include/linux/kho/abi/memfd.h          |  8 ++--
 kernel/liveupdate/kexec_handover.c     | 60 ++++++++++++++++++--------
 lib/test_kho.c                         | 35 +++++++--------
 mm/memfd_luo.c                         | 21 ++++-----
 6 files changed, 83 insertions(+), 61 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ef2b188c8ed0..b52e7a5173f8 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -6,10 +6,9 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 #include <linux/mm.h>
+#include <linux/kho/abi/kexec_handover.h>
 #include <asm-generic/kexec_handover.h>
 
-struct kho_vmalloc;
-
 struct folio;
 struct page;
 
@@ -21,14 +20,14 @@ int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned long nr_pages);
 void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
-int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
-void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
+int kho_preserve_vmalloc(void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr));
+void kho_unpreserve_vmalloc(DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr));
 void *kho_alloc_preserve(size_t size);
 void kho_unpreserve_free(void *mem);
 void kho_restore_free(void *mem);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
-void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
+void *kho_restore_vmalloc(const DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr));
 int kho_add_subtree(const char *name, void *blob, size_t size);
 void kho_remove_subtree(void *blob);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys, size_t *size);
@@ -74,12 +73,12 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
 
 static inline int kho_preserve_vmalloc(void *ptr,
-				       struct kho_vmalloc *preservation)
+				       DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr))
 {
 	return -EOPNOTSUPP;
 }
 
-static inline void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation) { }
+static inline void kho_unpreserve_vmalloc(DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr)) { }
 
 static inline void *kho_alloc_preserve(size_t size)
 {
@@ -100,7 +99,7 @@ static inline struct page *kho_restore_pages(phys_addr_t phys,
 	return NULL;
 }
 
-static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+static inline void *kho_restore_vmalloc(const DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr))
 {
 	return NULL;
 }
diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index bee75a7006e8..f9b9b18f5820 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -13,6 +13,7 @@
 #include <linux/bits.h>
 #include <linux/build_bug.h>
 #include <linux/kconfig.h>
+#include <linux/kho/abi/feature.h>
 #include <linux/log2.h>
 #include <linux/math.h>
 #include <linux/types.h>
@@ -179,9 +180,7 @@ struct kho_vmalloc {
 	unsigned short order;
 };
 
-static_assert(sizeof(struct kho_vmalloc) == 16);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct kho_vmalloc) == 8);
+DECLARE_KHO_SER(kho_vmalloc, 16, 0, 0);
 
 /**
  * DOC: KHO persistent memory tracker
diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 7b49dd6d7e2a..b0597c438973 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -80,9 +80,9 @@ static_assert(!IS_ENABLED(CONFIG_64BIT) ||
  * @seals:     The seals present on the memfd. The seals are uABI so it is safe
  *             to directly use them in the ABI.
  * @flags:     Flags for the file. Unused flag bits must be set to 0.
- * @nr_folios: Number of folios in the folios array.
- * @folios:    Pointer to KHO vmalloc descriptor for the array of
- *             struct memfd_luo_folio_ser.
+ * @nr_folios:   Number of folios in the folios array.
+ * @folios_fhdr: Pointer to KHO vmalloc descriptor for the array of
+ *               struct memfd_luo_folio_ser.
  */
 struct memfd_luo_ser {
 	u64 pos;
@@ -90,7 +90,7 @@ struct memfd_luo_ser {
 	u32 seals;
 	u32 flags;
 	u64 nr_folios;
-	DECLARE_KHOSER_PTR(folios, struct kho_vmalloc *);
+	DECLARE_KHOSER_PTR(folios_fhdr, DECLARE_KHO_SER_HDR(kho_vmalloc, *));
 };
 
 static_assert(sizeof(struct memfd_luo_ser) == 40);
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 641a3b4c88fb..6e428df717cc 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1378,20 +1378,20 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
 /**
  * kho_preserve_vmalloc - preserve memory allocated with vmalloc() across kexec
  * @ptr: pointer to the area in vmalloc address space
- * @preservation: placeholder for preservation metadata
+ * @fhdr:         placeholder for preservation metadata
  *
  * Instructs KHO to preserve the area in vmalloc address space at @ptr. The
  * physical pages mapped at @ptr will be preserved and on successful return
- * @preservation will hold the physical address of a structure that describes
- * the preservation.
+ * @fhdr will hold the preservation metadata.
  *
  * NOTE: The memory allocated with vmalloc_node() variants cannot be reliably
  * restored on the same node
  *
  * Return: 0 on success, error code on failure
  */
-int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
+int kho_preserve_vmalloc(void *ptr, DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr))
 {
+	struct kho_vmalloc *vmalloc_ser;
 	struct kho_vmalloc_chunk *chunk;
 	struct vm_struct *vm = find_vm_area(ptr);
 	unsigned int order, flags, nr_contig_pages;
@@ -1404,13 +1404,18 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
 	if (vm->flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
 		return -EOPNOTSUPP;
 
+	kho_ser_init(fhdr, kho_vmalloc);
+
+	vmalloc_ser = kho_ser_payload(fhdr, kho_vmalloc);
+
 	flags = vmalloc_flags_to_kho(vm->flags);
 	order = get_vm_area_page_order(vm);
+	vmalloc_ser->order = order;
 
 	chunk = new_vmalloc_chunk(NULL);
 	if (!chunk)
 		return -ENOMEM;
-	KHOSER_STORE_PTR(preservation->first, chunk);
+	KHOSER_STORE_PTR(vmalloc_ser->first, chunk);
 
 	nr_contig_pages = (1 << order);
 	for (int i = 0; i < vm->nr_pages; i += nr_contig_pages) {
@@ -1431,33 +1436,39 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation)
 		}
 	}
 
-	preservation->total_pages = vm->nr_pages;
-	preservation->flags = flags;
-	preservation->order = order;
+	vmalloc_ser->total_pages = vm->nr_pages;
+	vmalloc_ser->flags = flags;
 
 	return 0;
 
 err_free:
-	kho_unpreserve_vmalloc(preservation);
+	kho_unpreserve_vmalloc(fhdr);
 	return err;
 }
 EXPORT_SYMBOL_GPL(kho_preserve_vmalloc);
 
 /**
  * kho_unpreserve_vmalloc - unpreserve memory allocated with vmalloc()
- * @preservation: preservation metadata returned by kho_preserve_vmalloc()
+ * @fhdr:         preservation metadata returned by kho_preserve_vmalloc()
  *
  * Instructs KHO to unpreserve the area in vmalloc address space that was
  * previously preserved with kho_preserve_vmalloc().
  */
-void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
+void kho_unpreserve_vmalloc(DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr))
 {
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	struct kho_vmalloc *vmalloc_ser;
+	struct kho_vmalloc_chunk *chunk;
+
+	if (!fhdr)
+		return;
+
+	vmalloc_ser = kho_ser_payload(fhdr, kho_vmalloc);
+	chunk = KHOSER_LOAD_PTR(vmalloc_ser->first);
 
 	while (chunk) {
 		struct kho_vmalloc_chunk *tmp = chunk;
 
-		kho_vmalloc_unpreserve_chunk(chunk, preservation->order);
+		kho_vmalloc_unpreserve_chunk(chunk, vmalloc_ser->order);
 
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
 		free_page((unsigned long)tmp);
@@ -1468,16 +1479,17 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_vmalloc);
 /**
  * kho_restore_vmalloc - recreates and populates an area in vmalloc address
  * space from the preserved memory.
- * @preservation: preservation metadata.
+ * @fhdr:         preservation metadata.
  *
  * Recreates an area in vmalloc address space and populates it with memory that
  * was preserved using kho_preserve_vmalloc().
  *
  * Return: pointer to the area in the vmalloc address space, NULL on failure.
  */
-void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
+void *kho_restore_vmalloc(const DECLARE_KHO_SER_HDR(kho_vmalloc, *fhdr))
 {
-	struct kho_vmalloc_chunk *chunk = KHOSER_LOAD_PTR(preservation->first);
+	const struct kho_vmalloc *vmalloc_ser;
+	struct kho_vmalloc_chunk *chunk;
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_PROT_NORMAL;
 	unsigned int align, order, shift, vm_flags;
 	unsigned long total_pages, contig_pages;
@@ -1487,19 +1499,29 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	unsigned int idx = 0;
 	int err;
 
-	vm_flags = kho_flags_to_vmalloc(preservation->flags);
+	if (!fhdr)
+		return NULL;
+
+	err = kho_ser_validate(fhdr, kho_vmalloc);
+	if (err)
+		return NULL;
+
+	vmalloc_ser = kho_ser_payload(fhdr, kho_vmalloc);
+
+	vm_flags = kho_flags_to_vmalloc(vmalloc_ser->flags);
 	if (vm_flags & ~KHO_VMALLOC_SUPPORTED_FLAGS)
 		return NULL;
 
-	total_pages = preservation->total_pages;
+	total_pages = vmalloc_ser->total_pages;
 	pages = kvmalloc_objs(*pages, total_pages);
 	if (!pages)
 		return NULL;
-	order = preservation->order;
+	order = vmalloc_ser->order;
 	contig_pages = (1 << order);
 	shift = PAGE_SHIFT + order;
 	align = 1 << shift;
 
+	chunk = KHOSER_LOAD_PTR(vmalloc_ser->first);
 	while (chunk) {
 		struct page *page;
 
diff --git a/lib/test_kho.c b/lib/test_kho.c
index cd0f183ff68e..cfd80b8b3c6d 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -34,7 +34,7 @@ struct kho_test_state {
 	unsigned int nr_folios;
 	struct folio **folios;
 	phys_addr_t *folios_info;
-	DECLARE_KHOSER_PTR(folios_info_phys, struct kho_vmalloc *);
+	DECLARE_KHOSER_PTR(folios_info_fhdr, DECLARE_KHO_SER_HDR(kho_vmalloc, *));
 	int nr_folios_preserved;
 	struct folio *fdt;
 	__wsum csum;
@@ -47,8 +47,8 @@ static void kho_test_unpreserve_data(struct kho_test_state *state)
 	for (int i = 0; i < state->nr_folios_preserved; i++)
 		kho_unpreserve_folio(state->folios[i]);
 
-	if (KHOSER_LOAD_PTR(state->folios_info_phys))
-		kho_unpreserve_vmalloc(KHOSER_LOAD_PTR(state->folios_info_phys));
+	if (KHOSER_LOAD_PTR(state->folios_info_fhdr))
+		kho_unpreserve_vmalloc(KHOSER_LOAD_PTR(state->folios_info_fhdr));
 	vfree(state->folios_info);
 }
 
@@ -61,7 +61,7 @@ static int kho_test_preserve_data(struct kho_test_state *state)
 	if (!folios_info)
 		return -ENOMEM;
 
-	err = kho_preserve_vmalloc(folios_info, KHOSER_LOAD_PTR(state->folios_info_phys));
+	err = kho_preserve_vmalloc(folios_info, KHOSER_LOAD_PTR(state->folios_info_fhdr));
 	if (err)
 		goto err_free_info;
 
@@ -109,8 +109,8 @@ static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
 	err |= fdt_begin_node(fdt, "data");
 	err |= fdt_property(fdt, "nr_folios", &state->nr_folios,
 			    sizeof(state->nr_folios));
-	err |= fdt_property(fdt, "folios_info", &state->folios_info_phys,
-			    sizeof(state->folios_info_phys));
+	err |= fdt_property(fdt, "folios_info", &state->folios_info_fhdr,
+			    sizeof(state->folios_info_fhdr));
 	err |= fdt_property(fdt, "csum", &state->csum, sizeof(state->csum));
 	err |= fdt_end_node(fdt);
 
@@ -122,18 +122,18 @@ static int kho_test_prepare_fdt(struct kho_test_state *state, ssize_t fdt_size)
 
 static int kho_test_preserve(struct kho_test_state *state)
 {
-	struct kho_vmalloc *folios_vmalloc;
+	DECLARE_KHO_SER_HDR(kho_vmalloc, *folios_fhdr);
 	ssize_t fdt_size, alloc_size;
 	int err;
 
 	fdt_size = state->nr_folios * sizeof(phys_addr_t) + PAGE_SIZE;
-	alloc_size = fdt_size + sizeof(struct kho_vmalloc);
+	alloc_size = fdt_size + kho_ser_size(kho_vmalloc);
 	state->fdt = folio_alloc(GFP_KERNEL, get_order(alloc_size));
 	if (!state->fdt)
 		return -ENOMEM;
 
-	folios_vmalloc = folio_address(state->fdt) + fdt_size;
-	KHOSER_STORE_PTR(state->folios_info_phys, folios_vmalloc);
+	folios_fhdr = folio_address(state->fdt) + fdt_size;
+	KHOSER_STORE_PTR(state->folios_info_fhdr, folios_fhdr);
 
 	err = kho_preserve_folio(state->fdt);
 	if (err)
@@ -238,8 +238,9 @@ static int kho_test_save(void)
 
 static int kho_test_restore_data(const void *fdt, int node)
 {
-	const DECLARE_KHOSER_PTR(*folios_info_phys, struct kho_vmalloc *);
-	const struct kho_vmalloc *folios_vmalloc;
+	const DECLARE_KHOSER_PTR(*folios_fhdr_phys,
+				 DECLARE_KHO_SER_HDR(kho_vmalloc, *));
+	const DECLARE_KHO_SER_HDR(kho_vmalloc, *folios_fhdr);
 	const unsigned int *nr_folios;
 	phys_addr_t *folios_info;
 	const __wsum *old_csum;
@@ -256,15 +257,15 @@ static int kho_test_restore_data(const void *fdt, int node)
 	if (!old_csum || len != sizeof(*old_csum))
 		return -EINVAL;
 
-	folios_info_phys = fdt_getprop(fdt, node, "folios_info", &len);
-	if (!folios_info_phys || len != sizeof(*folios_info_phys))
+	folios_fhdr_phys = fdt_getprop(fdt, node, "folios_info", &len);
+	if (!folios_fhdr_phys || len != sizeof(*folios_fhdr_phys))
 		return -EINVAL;
 
-	folios_vmalloc = KHOSER_LOAD_PTR(*folios_info_phys);
-	if (!folios_vmalloc)
+	folios_fhdr = KHOSER_LOAD_PTR(*folios_fhdr_phys);
+	if (!folios_fhdr)
 		return -EINVAL;
 
-	folios_info = kho_restore_vmalloc(folios_vmalloc);
+	folios_info = kho_restore_vmalloc(folios_fhdr);
 	if (!folios_info)
 		return -EINVAL;
 
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 4471cced57db..74c1ff5877c3 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -103,7 +103,7 @@ static int memfd_luo_preserve_folios(struct file *file,
 	 * are not set.
 	 */
 	if (!size) {
-		ser->folios.phys = 0;
+		ser->folios_fhdr.phys = 0;
 		ser->nr_folios = 0;
 		*out_folios_ser = NULL;
 		return 0;
@@ -200,7 +200,7 @@ static int memfd_luo_preserve_folios(struct file *file,
 		pfolio->index = folio->index;
 	}
 
-	err = kho_preserve_vmalloc(folios_ser, KHOSER_LOAD_PTR(ser->folios));
+	err = kho_preserve_vmalloc(folios_ser, KHOSER_LOAD_PTR(ser->folios_fhdr));
 	if (err)
 		goto err_unpreserve;
 
@@ -227,7 +227,7 @@ static int memfd_luo_preserve_folios(struct file *file,
 	return err;
 }
 
-static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
+static void memfd_luo_unpreserve_folios(DECLARE_KHO_SER_HDR(kho_vmalloc, *folios_fhdr),
 					struct memfd_luo_folio_ser *folios_ser,
 					u64 nr_folios)
 {
@@ -236,7 +236,7 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 	if (!nr_folios)
 		return;
 
-	kho_unpreserve_vmalloc(kho_vmalloc);
+	kho_unpreserve_vmalloc(folios_fhdr);
 
 	for (i = 0; i < nr_folios; i++) {
 		const struct memfd_luo_folio_ser *pfolio = &folios_ser[i];
@@ -256,15 +256,16 @@ static void memfd_luo_unpreserve_folios(struct kho_vmalloc *kho_vmalloc,
 
 static size_t memfd_luo_ser_size(void)
 {
-	return sizeof(struct memfd_luo_ser) + sizeof(struct kho_vmalloc);
+	return sizeof(struct memfd_luo_ser) + kho_ser_size(kho_vmalloc);
 }
 
 static struct memfd_luo_ser *memfd_luo_ser_init(void *mem)
 {
-	struct kho_vmalloc *kho_vmalloc = mem + sizeof(struct memfd_luo_ser);
+	DECLARE_KHO_SER_HDR(kho_vmalloc, *folios_fhdr);
 	struct memfd_luo_ser *ser = mem;
 
-	KHOSER_STORE_PTR(ser->folios, kho_vmalloc);
+	folios_fhdr = mem + sizeof(struct memfd_luo_ser);
+	KHOSER_STORE_PTR(ser->folios_fhdr, folios_fhdr);
 	return ser;
 }
 
@@ -365,7 +366,7 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 
 	ser = phys_to_virt(args->serialized_data);
 
-	memfd_luo_unpreserve_folios(KHOSER_LOAD_PTR(ser->folios),
+	memfd_luo_unpreserve_folios(KHOSER_LOAD_PTR(ser->folios_fhdr),
 				    args->private_data,
 				    ser->nr_folios);
 
@@ -416,7 +417,7 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 		return;
 
 	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(KHOSER_LOAD_PTR(ser->folios));
+		folios_ser = kho_restore_vmalloc(KHOSER_LOAD_PTR(ser->folios_fhdr));
 		if (!folios_ser)
 			goto out;
 
@@ -567,7 +568,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	i_size_write(file_inode(file), ser->size);
 
 	if (ser->nr_folios) {
-		folios_ser = kho_restore_vmalloc(KHOSER_LOAD_PTR(ser->folios));
+		folios_ser = kho_restore_vmalloc(KHOSER_LOAD_PTR(ser->folios_fhdr));
 		if (!folios_ser) {
 			err = -EINVAL;
 			goto put_file;
-- 
2.56.0.506.g506a7eabc5-goog


