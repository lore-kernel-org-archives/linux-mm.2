Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF12CCD1A4
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460F38E000A; Sat, 18 Oct 2025 13:18:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4119B8E0002; Sat, 18 Oct 2025 13:18:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3568E000A; Sat, 18 Oct 2025 13:18:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 135598E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC9D0140248
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:04 +0000 (UTC)
X-FDA: 84011892888.30.C6BAC63
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0CAF2180006
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jEIXHyeo;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807883; a=rsa-sha256;
	cv=none;
	b=mX/Boh3wNw0dphsVSsoOW0FTShHV1MCAOFLZS3PmbXS9teZyhXRX+RTEneF9hq97rDnTQK
	j63WOqE1S5IbkcA74D4usujeWgDCy/LPYw7fo3d5Qgi0cYyz3IJAQslfxDqSWnympvhyCo
	VQ4ptxfqYZQiQdRutdhUSx+mF+fCWTg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jEIXHyeo;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZY/HjXpMYmQ0uSsMwFz5AY8mYULbafnePj9I1rlgRgo=;
	b=tG77MOZ8QqHviYy2bH1+63Vsm+OksWHJdZiuA2AYrIJMrB2Imvf8gcR2fcr9+Sno/8NbOl
	guNdFa7W8CdGWOx2WT5542YWnEhcpNhXWyJFvKIbXgA9N6E0Z6n8QvZyYrb23+3lIvzpuT
	As/gDoLMKsQ+/93Ev7u/wthWdp8AymY=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-87bb66dd224so40340886d6.3
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807882; x=1761412682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZY/HjXpMYmQ0uSsMwFz5AY8mYULbafnePj9I1rlgRgo=;
        b=jEIXHyeobCY/4IHfj3LsuK7TaEVV1Lw3v1UsBiY8us5riRQKBUYKMFbV4WzGcm6kie
         vHq60GpwV40Knzb1vFZEUr6QUXm1/AW6sV2IcHtFVS1htNd6Lyr4GGYaPjVkiKhHXTkr
         VpEMrD826spXF6SmvAr0tA9AqYH8qH0WrQsZJQdTqE76SCp2xCZ02/QCTMKwwYGFr6tp
         zcoMC5zfSaULWXKc1DaZlboC6k9czYLk9zXrhdyMYdRO9O2Tr8ZtBHJaAOm5ZQb1plb2
         C2olovRz09pYkrSojqzTfaiNJCzrrBg/F/uJaXkk2ZApAFemfpfntsZ7EeplGE2fumOi
         9VrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807882; x=1761412682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZY/HjXpMYmQ0uSsMwFz5AY8mYULbafnePj9I1rlgRgo=;
        b=AqRqj5KK/LEaJGzezVhG9QvHU28X9heR/MloUxbtDi+LLH27M2jOL+LhUQkdw1HRsk
         4hXSftRpRrVbNhBNvtREW8i/mNLDPEdXRr9Bj+fBVG1mxrjsMu5+bSWwpKxExMQPDYbi
         tSWawn+49B7s+zy1RRw4D5u+/bDMZI77gzPvS6ZCPybpKgnTucwFAUbOD44HwKv30RN6
         juxFZdpBqbhzj/AUkMP4BMydVRFfeJG/KmIw5q5vkhb7vJEP1JBNLoj6QHV6wokmUU4L
         lJZyc7vz0VkDRWpuiODNPJ9ckW+inZs+mH2CwHZjpbF+VE36Xq4/Vq+qaquRxaJcaXKP
         8Aig==
X-Forwarded-Encrypted: i=1; AJvYcCWlPORx0pBk/2ub+3AzNKcd45l4tx+sz8TuAtAnZ3q06RRZ2ngWwtN0UTaLgRPltSi7zPSHsb+gGQ==@kvack.org
X-Gm-Message-State: AOJu0YwspVPt6vpvdW6Q/j8NvqdjHb9y3gfHe9wG8xRCVKMyMbVUvC3Y
	KhlwPrKz1CBih6AqTwkMdRRlmGs1H44fzICfX+rRl3l1TlGlPsJXSgtEZ5omDNmfEaY=
X-Gm-Gg: ASbGncvjjAevuTazMFfZy9j78bRJkPbSDzPPfEAHGnoaoi5deR6aZbYzntjmH0r7orU
	pJ1VVs3JiESt1iNHvOYuXGbybMdV2HfOBCN8FMPuxJMJFOSydUVc2o1Up/TIun2+dALM75Jbf2x
	pNamr4338QYatwTO2Kpke5ch2vadWu5KFHeBFbFmq3UjKDVFYeCjsjdONyGYpbAochLunnVMAX8
	k58zrFzjfWz0dE6DVqu0Mo4FY8aeMZDMeCaN2CGK8pE5HZLcD6UuHSppaXVXTxCvu4jgs2GQqGi
	V+SvoJNxfM1WbYvX29SuREqvyWluEq3gYkhAivdeaH3rFJb4N9GYRtfQiv4slKwYAmGDUfTbTeB
	s3KGDrXebQf6m52mPChAphj1V/W/MXkpA1bBA2Ric1bIeXb79OjYn2CRL0RPFA+gaPMJKc9MzlO
	dRENh+3zpYIHVLpkLjm5YsR/njjsTR74Z8++C0XgerMbi8jTlZqkro3I0TvHYyDB6fNGkZIhgol
	m++LKoACA3StvvrGwUybDrjhvtxmVF+
X-Google-Smtp-Source: AGHT+IEmfOOiW8srLwk1lm0jxUxxXdkIwDR6niHlzuMAgc/RIDwCL+Bi+LrRDYrYfHkzcneqwF/bjg==
X-Received: by 2002:a05:6214:5196:b0:87c:1fd9:da4a with SMTP id 6a1803df08f44-87c2055e680mr144656946d6.2.1760807882033;
        Sat, 18 Oct 2025 10:18:02 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:18:01 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v6 03/10] kho: drop notifiers
Date: Sat, 18 Oct 2025 13:17:49 -0400
Message-ID: <20251018171756.1724191-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: d9mbea4axs5atsb89oiuksuigk4f46dr
X-Rspamd-Queue-Id: 0CAF2180006
X-Rspamd-Server: rspam09
X-HE-Tag: 1760807882-448397
X-HE-Meta: U2FsdGVkX1/66kocd2oMEXmfNa/I9tfoq1jtz7dPbDY8H9m3NKcmFMBhT1foJi8QTkXwDTIto/ktuDbLsBmFdqvzBgCBniuAxfsoLbUVlKSmmX/QAzNoP8i8wPVxoHM29eJGhdRk40NMEfBGSSHJ3LR2D+za3yo3c7uI4YuWizZtWSPy6YlVYGE8GeV5awyyTDizT+ZxFFaQB3ABY5LQX+dzZsI4sVKzqHV64mk8pNrLdlUVrLOdzuxCTb7UAWFVBPeVAJsHQ5UoaaWyu7V7mUGcVuvHPVl67Jp+8OV0k8+SICesvwqpQFtJEQm/jifveO5rA/cZNIc3ml+Tsn/jCghKb6+pKbJldyLlFrx9bxwjK3gQaR+NByyL9eC82vCwD3WdHeVIiizkYCcIJO83kQ5sJwY7RwnrZLoyxYx1WVWp9+wqoZlq01Dz+2xpM8ne/PU6VhuEAnAjA8yhWnSAyJCL6WFfdze5CfxkBD34gsb8EJ2mAFNyNSiC0UteDnshabgcE1GTxXSHol/lxGhMG5xbBkV1q5GvMB8jd0/icCtrV7SYcbHsFAV8gpPKUlIzmik/Xb2fM0zcA+a0+k7LsE1FMLkpkPftKtLpfYqIbEsAUMHcEeq7f/QRApTCetOBFkXbNjGwWgPxq1WeKMID1iTBJZpP4k0QE6+ShhDlA2QJigkAYOuO7taWtHo3Hl6/EIeDOZwqWMh932wKDQ7oAQWEmAda+wAQ6T1lhSNL6maD6JKOBPSVjIqydnzeHTEtouXYICJfF9W9iRZJrZGaygNqjQ17mJ12oVUspgst8OzqfzH1IzZTytKvxMSvZQ/ziwNwvbmxDGXzUfGnqBWw2JqntCgYaHJ6WYNVWEh49CVlkjk5i3NwovnkuwPZlj9pDzWREnhQ/Pw3DtR4GFZzKzq+/pNDHNMQJDFIZzKqYSdwIQFEqDqmQFioaM1jEmJxJ9KWfUoX6skaFo09mZT
 BluMULNX
 CReHCxDk2jVR1O/ZcYKgtAzZFdH90Gj38GpATulEEbaTPSwahFsuPt/wNPCfVPnOZga8o/zz7Ukqh6qZLfyQYdL1rUXwnPNkAFGwE6wHgZRxJ3NAbU8qfeNLNm0hI+TX/CFMUSxmLy0g1MrTZ51exprzT9zJzCJEhtEMOfTA9QT2kDO72S+euc2Qa5NJjmOxBYSNRm7AWBk4/ClwzFLx5B8EDBVjJ74ZwzzlcIEh2owSujdhfSjavnlv8E7FdVPJYLPxUC+TsMOTCXgEepS+ZgMXPgl864TJWVokhzcP9b3GwueSSYA0f+21n3LMZhm0QUFVO6c39IYq5ngiUTPVkDcQodLDoTVMJq+Pxtt9J0kUvYP8ohpoxno6BYJQeto9L4cXr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

The KHO framework uses a notifier chain as the mechanism for clients to
participate in the finalization process. While this works for a single,
central state machine, it is too restrictive for kernel-internal
components like pstore/reserve_mem or IMA. These components need a
simpler, direct way to register their state for preservation (e.g.,
during their initcall) without being part of a complex,
shutdown-time notifier sequence. The notifier model forces all
participants into a single finalization flow and makes direct
preservation from an arbitrary context difficult.
This patch refactors the client participation model by removing the
notifier chain and introducing a direct API for managing FDT subtrees.

The core kho_finalize() and kho_abort() state machine remains, but
clients now register their data with KHO beforehand.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h   |  28 +-----
 kernel/kexec_handover.c          | 164 +++++++++++++++++--------------
 kernel/kexec_handover_debugfs.c  |  17 ++--
 kernel/kexec_handover_internal.h |   5 +-
 lib/test_kho.c                   |  30 +-----
 mm/memblock.c                    |  62 +++---------
 6 files changed, 127 insertions(+), 179 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 04d0108db98e..2faf290803ce 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -10,14 +10,7 @@ struct kho_scratch {
 	phys_addr_t size;
 };
 
-/* KHO Notifier index */
-enum kho_event {
-	KEXEC_KHO_FINALIZE = 0,
-	KEXEC_KHO_ABORT = 1,
-};
-
 struct folio;
-struct notifier_block;
 struct page;
 
 #define DECLARE_KHOSER_PTR(name, type) \
@@ -37,8 +30,6 @@ struct page;
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
-struct kho_serialization;
-
 struct kho_vmalloc_chunk;
 struct kho_vmalloc {
 	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
@@ -57,12 +48,10 @@ int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 struct folio *kho_restore_folio(phys_addr_t phys);
 struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
 void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt);
+void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
-int register_kho_notifier(struct notifier_block *nb);
-int unregister_kho_notifier(struct notifier_block *nb);
-
 void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
@@ -114,23 +103,16 @@ static inline void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 	return NULL;
 }
 
-static inline int kho_add_subtree(struct kho_serialization *ser,
-				  const char *name, void *fdt)
+static inline int kho_add_subtree(const char *name, void *fdt)
 {
 	return -EOPNOTSUPP;
 }
 
-static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
+static inline void kho_remove_subtree(void *fdt)
 {
-	return -EOPNOTSUPP;
 }
 
-static inline int register_kho_notifier(struct notifier_block *nb)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int unregister_kho_notifier(struct notifier_block *nb)
+static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index f3627430b3c3..e6890fe6a171 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -15,7 +15,6 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
-#include <linux/notifier.h>
 #include <linux/page-isolation.h>
 #include <linux/vmalloc.h>
 
@@ -99,29 +98,34 @@ struct kho_mem_track {
 
 struct khoser_mem_chunk;
 
-struct kho_serialization {
-	struct page *fdt;
-	struct kho_mem_track track;
-	/* First chunk of serialized preserved memory map */
-	struct khoser_mem_chunk *preserved_mem_map;
+struct kho_sub_fdt {
+	struct list_head l;
+	const char *name;
+	void *fdt;
 };
 
 struct kho_out {
-	struct blocking_notifier_head chain_head;
-	struct mutex lock; /* protects KHO FDT finalization */
-	struct kho_serialization ser;
+	void *fdt;
 	bool finalized;
+	struct mutex lock; /* protects KHO FDT finalization */
+
+	struct list_head sub_fdts;
+	struct mutex fdts_lock;
+
+	struct kho_mem_track track;
+	/* First chunk of serialized preserved memory map */
+	struct khoser_mem_chunk *preserved_mem_map;
+
 	struct kho_debugfs dbg;
 };
 
 static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
 	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.ser = {
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
+	.track = {
+		.orders = XARRAY_INIT(kho_out.track.orders, 0),
 	},
+	.sub_fdts = LIST_HEAD_INIT(kho_out.sub_fdts),
+	.fdts_lock = __MUTEX_INITIALIZER(kho_out.fdts_lock),
 	.finalized = false,
 };
 
@@ -362,14 +366,14 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
 	}
 }
 
-static int kho_mem_serialize(struct kho_serialization *ser)
+static int kho_mem_serialize(struct kho_out *kho_out)
 {
 	struct khoser_mem_chunk *first_chunk = NULL;
 	struct khoser_mem_chunk *chunk = NULL;
 	struct kho_mem_phys *physxa;
 	unsigned long order;
 
-	xa_for_each(&ser->track.orders, order, physxa) {
+	xa_for_each(&kho_out->track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
@@ -397,7 +401,7 @@ static int kho_mem_serialize(struct kho_serialization *ser)
 		}
 	}
 
-	ser->preserved_mem_map = first_chunk;
+	kho_out->preserved_mem_map = first_chunk;
 
 	return 0;
 
@@ -658,7 +662,6 @@ static void __init kho_reserve_scratch(void)
 
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
- * @ser: serialization control object passed by KHO notifiers.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
  *
@@ -672,34 +675,45 @@ static void __init kho_reserve_scratch(void)
  *
  * Return: 0 on success, error code on failure
  */
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
+int kho_add_subtree(const char *name, void *fdt)
 {
-	int err = 0;
-	u64 phys = (u64)virt_to_phys(fdt);
-	void *root = page_to_virt(ser->fdt);
+	struct kho_sub_fdt *sub_fdt;
+	int err;
 
-	err |= fdt_begin_node(root, name);
-	err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
-	err |= fdt_end_node(root);
+	sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
+	if (!sub_fdt)
+		return -ENOMEM;
 
-	if (err)
-		return err;
+	INIT_LIST_HEAD(&sub_fdt->l);
+	sub_fdt->name = name;
+	sub_fdt->fdt = fdt;
 
-	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
+	mutex_lock(&kho_out.fdts_lock);
+	list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
+	err = kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
+	mutex_unlock(&kho_out.fdts_lock);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-int register_kho_notifier(struct notifier_block *nb)
+void kho_remove_subtree(void *fdt)
 {
-	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
-}
-EXPORT_SYMBOL_GPL(register_kho_notifier);
+	struct kho_sub_fdt *sub_fdt;
+
+	mutex_lock(&kho_out.fdts_lock);
+	list_for_each_entry(sub_fdt, &kho_out.sub_fdts, l) {
+		if (sub_fdt->fdt == fdt) {
+			list_del(&sub_fdt->l);
+			kfree(sub_fdt);
+			kho_debugfs_fdt_remove(&kho_out.dbg, fdt);
+			break;
+		}
+	}
+	mutex_unlock(&kho_out.fdts_lock);
 
-int unregister_kho_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&kho_out.chain_head, nb);
 }
-EXPORT_SYMBOL_GPL(unregister_kho_notifier);
+EXPORT_SYMBOL_GPL(kho_remove_subtree);
 
 /**
  * kho_preserve_folio - preserve a folio across kexec.
@@ -714,7 +728,7 @@ int kho_preserve_folio(struct folio *folio)
 {
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 
 	return __kho_preserve_order(track, pfn, order);
 }
@@ -732,7 +746,7 @@ EXPORT_SYMBOL_GPL(kho_preserve_folio);
  */
 int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 {
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 	const unsigned long start_pfn = page_to_pfn(page);
 	const unsigned long end_pfn = start_pfn + nr_pages;
 	unsigned long pfn = start_pfn;
@@ -828,7 +842,7 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur
 
 static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
 {
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
 
 	__kho_unpreserve(track, pfn, pfn + 1);
@@ -1010,11 +1024,11 @@ EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
 static int __kho_abort(void)
 {
-	int err;
+	int err = 0;
 	unsigned long order;
 	struct kho_mem_phys *physxa;
 
-	xa_for_each(&kho_out.ser.track.orders, order, physxa) {
+	xa_for_each(&kho_out.track.orders, order, physxa) {
 		struct kho_mem_phys_bits *bits;
 		unsigned long phys;
 
@@ -1024,17 +1038,13 @@ static int __kho_abort(void)
 		xa_destroy(&physxa->phys_bits);
 		kfree(physxa);
 	}
-	xa_destroy(&kho_out.ser.track.orders);
+	xa_destroy(&kho_out.track.orders);
 
-	if (kho_out.ser.preserved_mem_map) {
-		kho_mem_ser_free(kho_out.ser.preserved_mem_map);
-		kho_out.ser.preserved_mem_map = NULL;
+	if (kho_out.preserved_mem_map) {
+		kho_mem_ser_free(kho_out.preserved_mem_map);
+		kho_out.preserved_mem_map = NULL;
 	}
 
-	err = blocking_notifier_call_chain(&kho_out.chain_head, KEXEC_KHO_ABORT,
-					   NULL);
-	err = notifier_to_errno(err);
-
 	if (err)
 		pr_err("Failed to abort KHO finalization: %d\n", err);
 
@@ -1057,7 +1067,8 @@ int kho_abort(void)
 		return ret;
 
 	kho_out.finalized = false;
-	kho_debugfs_cleanup(&kho_out.dbg);
+
+	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
 
 	return 0;
 }
@@ -1066,41 +1077,46 @@ static int __kho_finalize(void)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
-	void *fdt = page_to_virt(kho_out.ser.fdt);
+	void *root = kho_out.fdt;
+	struct kho_sub_fdt *fdt;
 
-	err |= fdt_create(fdt, PAGE_SIZE);
-	err |= fdt_finish_reservemap(fdt);
-	err |= fdt_begin_node(fdt, "");
-	err |= fdt_property_string(fdt, "compatible", KHO_FDT_COMPATIBLE);
+	err |= fdt_create(root, PAGE_SIZE);
+	err |= fdt_finish_reservemap(root);
+	err |= fdt_begin_node(root, "");
+	err |= fdt_property_string(root, "compatible", KHO_FDT_COMPATIBLE);
 	/**
 	 * Reserve the preserved-memory-map property in the root FDT, so
 	 * that all property definitions will precede subnodes created by
 	 * KHO callers.
 	 */
-	err |= fdt_property_placeholder(fdt, PROP_PRESERVED_MEMORY_MAP,
+	err |= fdt_property_placeholder(root, PROP_PRESERVED_MEMORY_MAP,
 					sizeof(*preserved_mem_map),
 					(void **)&preserved_mem_map);
 	if (err)
 		goto abort;
 
-	err = kho_preserve_folio(page_folio(kho_out.ser.fdt));
+	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
 	if (err)
 		goto abort;
 
-	err = blocking_notifier_call_chain(&kho_out.chain_head,
-					   KEXEC_KHO_FINALIZE, &kho_out.ser);
-	err = notifier_to_errno(err);
+	err = kho_mem_serialize(&kho_out);
 	if (err)
 		goto abort;
 
-	err = kho_mem_serialize(&kho_out.ser);
-	if (err)
-		goto abort;
+	*preserved_mem_map = (u64)virt_to_phys(kho_out.preserved_mem_map);
+
+	mutex_lock(&kho_out.fdts_lock);
+	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
+		phys_addr_t phys = virt_to_phys(fdt->fdt);
 
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.ser.preserved_mem_map);
+		err |= fdt_begin_node(root, fdt->name);
+		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
+		err |= fdt_end_node(root);
+	}
+	mutex_unlock(&kho_out.fdts_lock);
 
-	err |= fdt_end_node(fdt);
-	err |= fdt_finish(fdt);
+	err |= fdt_end_node(root);
+	err |= fdt_finish(root);
 
 abort:
 	if (err) {
@@ -1129,7 +1145,7 @@ int kho_finalize(void)
 	kho_out.finalized = true;
 
 	return kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-				   page_to_virt(kho_out.ser.fdt), true);
+				  kho_out.fdt, true);
 }
 
 bool kho_finalized(void)
@@ -1212,15 +1228,17 @@ static __init int kho_init(void)
 {
 	int err = 0;
 	const void *fdt = kho_get_fdt();
+	struct page *fdt_page;
 
 	if (!kho_enable)
 		return 0;
 
-	kho_out.ser.fdt = alloc_page(GFP_KERNEL);
-	if (!kho_out.ser.fdt) {
+	fdt_page = alloc_page(GFP_KERNEL);
+	if (!fdt_page) {
 		err = -ENOMEM;
 		goto err_free_scratch;
 	}
+	kho_out.fdt = page_to_virt(fdt_page);
 
 	err = kho_debugfs_init();
 	if (err)
@@ -1248,8 +1266,8 @@ static __init int kho_init(void)
 	return 0;
 
 err_free_fdt:
-	put_page(kho_out.ser.fdt);
-	kho_out.ser.fdt = NULL;
+	put_page(fdt_page);
+	kho_out.fdt = NULL;
 err_free_scratch:
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		void *start = __va(kho_scratch[i].addr);
@@ -1260,7 +1278,7 @@ static __init int kho_init(void)
 	kho_enable = false;
 	return err;
 }
-late_initcall(kho_init);
+fs_initcall(kho_init);
 
 static void __init kho_release_scratch(void)
 {
@@ -1396,7 +1414,7 @@ int kho_fill_kimage(struct kimage *image)
 	if (!kho_out.finalized)
 		return 0;
 
-	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
+	image->kho.fdt = virt_to_phys(kho_out.fdt);
 
 	scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
 	scratch = (struct kexec_buf){
diff --git a/kernel/kexec_handover_debugfs.c b/kernel/kexec_handover_debugfs.c
index 96fb9afd8af6..6ddcd17fac3c 100644
--- a/kernel/kexec_handover_debugfs.c
+++ b/kernel/kexec_handover_debugfs.c
@@ -61,14 +61,17 @@ int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
 }
 
-void kho_debugfs_cleanup(struct kho_debugfs *dbg)
+void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt)
 {
-	struct fdt_debugfs *ff, *tmp;
-
-	list_for_each_entry_safe(ff, tmp, &dbg->fdt_list, list) {
-		debugfs_remove(ff->file);
-		list_del(&ff->list);
-		kfree(ff);
+	struct fdt_debugfs *ff;
+
+	list_for_each_entry(ff, &dbg->fdt_list, list) {
+		if (ff->wrapper.data == fdt) {
+			debugfs_remove(ff->file);
+			list_del(&ff->list);
+			kfree(ff);
+			break;
+		}
 	}
 }
 
diff --git a/kernel/kexec_handover_internal.h b/kernel/kexec_handover_internal.h
index 042c189af768..de90a678274d 100644
--- a/kernel/kexec_handover_internal.h
+++ b/kernel/kexec_handover_internal.h
@@ -30,7 +30,7 @@ void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
 int kho_out_debugfs_init(struct kho_debugfs *dbg);
 int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 			const void *fdt, bool root);
-void kho_debugfs_cleanup(struct kho_debugfs *dbg);
+void kho_debugfs_fdt_remove(struct kho_debugfs *dbg, void *fdt);
 #else
 static inline int kho_debugfs_init(void) { return 0; }
 static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
@@ -38,7 +38,8 @@ static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
 static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
 static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
 				      const void *fdt, bool root) { return 0; }
-static inline void kho_debugfs_cleanup(struct kho_debugfs *dbg) {}
+static inline void kho_debugfs_fdt_remove(struct kho_debugfs *dbg,
+					  void *fdt) { }
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
 
 #endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
diff --git a/lib/test_kho.c b/lib/test_kho.c
index 60cd899ea745..8d57049e8c8c 100644
--- a/lib/test_kho.c
+++ b/lib/test_kho.c
@@ -39,33 +39,17 @@ struct kho_test_state {
 
 static struct kho_test_state kho_test_state;
 
-static int kho_test_notifier(struct notifier_block *self, unsigned long cmd,
-			     void *v)
+static int kho_test(void)
 {
 	struct kho_test_state *state = &kho_test_state;
-	struct kho_serialization *ser = v;
 	int err = 0;
 
-	switch (cmd) {
-	case KEXEC_KHO_ABORT:
-		return NOTIFY_DONE;
-	case KEXEC_KHO_FINALIZE:
-		/* Handled below */
-		break;
-	default:
-		return NOTIFY_BAD;
-	}
-
 	err |= kho_preserve_folio(state->fdt);
-	err |= kho_add_subtree(ser, KHO_TEST_FDT, folio_address(state->fdt));
+	err |= kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
 
 	return err ? NOTIFY_BAD : NOTIFY_DONE;
 }
 
-static struct notifier_block kho_test_nb = {
-	.notifier_call = kho_test_notifier,
-};
-
 static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 {
 	phys_addr_t *folios_info __free(kvfree) = NULL;
@@ -102,6 +86,9 @@ static int kho_test_save_data(struct kho_test_state *state, void *fdt)
 	if (!err)
 		state->folios_info = no_free_ptr(folios_info);
 
+	if (!err)
+		err = kho_test();
+
 	return err;
 }
 
@@ -203,14 +190,8 @@ static int kho_test_save(void)
 	if (err)
 		goto err_free_folios;
 
-	err = register_kho_notifier(&kho_test_nb);
-	if (err)
-		goto err_free_fdt;
-
 	return 0;
 
-err_free_fdt:
-	folio_put(state->fdt);
 err_free_folios:
 	kvfree(folios);
 	return err;
@@ -326,7 +307,6 @@ static void kho_test_cleanup(void)
 
 static void __exit kho_test_exit(void)
 {
-	unregister_kho_notifier(&kho_test_nb);
 	kho_test_cleanup();
 }
 module_exit(kho_test_exit);
diff --git a/mm/memblock.c b/mm/memblock.c
index e23e16618e9b..e3bef9b35d63 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2444,53 +2444,18 @@ int reserve_mem_release_by_name(const char *name)
 #define MEMBLOCK_KHO_FDT "memblock"
 #define MEMBLOCK_KHO_NODE_COMPATIBLE "memblock-v1"
 #define RESERVE_MEM_KHO_NODE_COMPATIBLE "reserve-mem-v1"
-static struct page *kho_fdt;
-
-static int reserve_mem_kho_finalize(struct kho_serialization *ser)
-{
-	int err = 0, i;
-
-	for (i = 0; i < reserved_mem_count; i++) {
-		struct reserve_mem_table *map = &reserved_mem_table[i];
-		struct page *page = phys_to_page(map->start);
-		unsigned int nr_pages = map->size >> PAGE_SHIFT;
-
-		err |= kho_preserve_pages(page, nr_pages);
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
 
 static int __init prepare_kho_fdt(void)
 {
 	int err = 0, i;
+	struct page *fdt_page;
 	void *fdt;
 
-	kho_fdt = alloc_page(GFP_KERNEL);
-	if (!kho_fdt)
+	fdt_page = alloc_page(GFP_KERNEL);
+	if (!fdt_page)
 		return -ENOMEM;
 
-	fdt = page_to_virt(kho_fdt);
+	fdt = page_to_virt(fdt_page);
 
 	err |= fdt_create(fdt, PAGE_SIZE);
 	err |= fdt_finish_reservemap(fdt);
@@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
 	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
 	for (i = 0; i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
+		struct page *page = phys_to_page(map->start);
+		unsigned int nr_pages = map->size >> PAGE_SHIFT;
 
+		err |= kho_preserve_pages(page, nr_pages);
 		err |= fdt_begin_node(fdt, map->name);
 		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
 		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
@@ -2507,13 +2475,16 @@ static int __init prepare_kho_fdt(void)
 		err |= fdt_end_node(fdt);
 	}
 	err |= fdt_end_node(fdt);
-
 	err |= fdt_finish(fdt);
 
+	err |= kho_preserve_folio(page_folio(fdt_page));
+
+	if (!err)
+		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+
 	if (err) {
 		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
-		put_page(kho_fdt);
-		kho_fdt = NULL;
+		put_page(fdt_page);
 	}
 
 	return err;
@@ -2529,13 +2500,6 @@ static int __init reserve_mem_init(void)
 	err = prepare_kho_fdt();
 	if (err)
 		return err;
-
-	err = register_kho_notifier(&reserve_mem_kho_nb);
-	if (err) {
-		put_page(kho_fdt);
-		kho_fdt = NULL;
-	}
-
 	return err;
 }
 late_initcall(reserve_mem_init);
-- 
2.51.0.915.g61a8936c21-goog


