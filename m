Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D1F3C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1C86B009B; Wed,  6 Aug 2025 21:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682926B009C; Wed,  6 Aug 2025 21:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54B4F6B009D; Wed,  6 Aug 2025 21:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 432B86B009B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA3FFC01A3
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:58 +0000 (UTC)
X-FDA: 83748267876.15.93E93D1
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 16DAE1C0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Hfk3sMTl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ffw72xt7ZzTFODVs8KzGvNRDPuQerrnNgMWkdlg1ha8=;
	b=F+8+E8NU8PSYlaau+bEaOQKeGiKWfpTEMRzQa1KJ/J8mAs7KR6zp5GXOmqWLoqDEMeSk60
	hSPWdpy5yA6wZsgnkVH7wi/LsoV0R5oQLekr1pBwlg7pHt1g1N+8HFe2dx5HxuyLbSHAVf
	LhaFppXIIrbKzP5Y6HlsazEXGebznk0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531097; a=rsa-sha256;
	cv=none;
	b=N1MkWELIPb8CAts1VG9RUpQRSQBkxu5Oy7DKr3HDNmSv7kd0ecNHxzq0/zmvPApkF2VtT3
	stCVQsA6CRVBfjSc3z+hZAmLXlqQP8dElos1XK2c8KaHnv64EFWgUQdmfrk85Xnk8R0QTc
	YhHXLj5JDh3r9AVL7HXWOMliXUxI8UY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Hfk3sMTl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-70744318bb3so5125806d6.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531096; x=1755135896; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ffw72xt7ZzTFODVs8KzGvNRDPuQerrnNgMWkdlg1ha8=;
        b=Hfk3sMTlQyNxs7SY5iV7sFX6KlVi8f6tgg3y7X4lqIz7xG0+DAYIlGemjdme+Wf+F4
         qEcjq2u+odanOoffbJzPI6xtaBEYYMGYiF6DA+I8g4xsngPN4bt1om5Pbh24YtbNGRbV
         tcFKyd6dLh04Cg2HE6jfw4ZLxcDIEe8Q2Nt+ZuLKuKVTDjG65Q4olhUwNtoLJMrtZl3m
         5PYlXpoUXpKsKC7gbnik5Bgim0vcKLEyvPyQTq7m+YBXDwFu2n0BV0CLQJwqYhGcp7m2
         7Usr8WthL3uDe/9flxSur+EDgAgMJLceIOykd1S/jdK1bSAGff3S/BTeKxxvllOd/eeS
         GmpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531096; x=1755135896;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ffw72xt7ZzTFODVs8KzGvNRDPuQerrnNgMWkdlg1ha8=;
        b=bMDCorxYtiFQQd42054YVDGEd8kqHgzSte16SpbWztIvykIn66uQ2D/py9nF9Xc7qX
         9zPWtFF1CuQ5SGn8Mv+Niwzf+pJti6f62ncspZP9tsi4wFeVJbaxvqlQyeYdO2RNu75U
         fhIau2dQSGDvlLIzji+L8K9oJ+UEmyAjDRfUmN90lPtneQJZDBBqnXnRU+AhFI69sVWt
         75gjT7nzNzYKoOUxj88oxZtcoHGX43+FCW84p1zSpeXd0g2tuv9HhfM6tBUVqqG0lkap
         d/44Q9oUE+0det8bWQMNYtXARQdjpEDajFrVv26pTg8jYUTxqzd7tl+SmzUK9CoKLie+
         3BiA==
X-Forwarded-Encrypted: i=1; AJvYcCVNTSA6RhsrI4877uq110iqU0GOCsjVtRBmjEJCxPoSWayRopXVgH9lVJHW90ofIDPP9G/+wz/vcw==@kvack.org
X-Gm-Message-State: AOJu0YwNFhLXohxssNFoiKRhZe6bBDFO1ASeedia3az1JgJHa7yIFlbY
	pn6sXIcgO/BSKwfR2QErfE8ExOw00x8eYo3icVpV0itheFK96FbJxR5yvoHjPNaPyb4=
X-Gm-Gg: ASbGncthL8xy+g4ChcIyk1FMOlGFiBfGd7BlGLEKPYvv3JFGsns2xep7CLNt/7fkJDW
	1kohR4Q+outMRCtQspjFHZIVjtCnggdm9PXJXUtIC5r7DpLTn5ZbnYys00sF5Xxnj5/bm++Gogf
	6iL6mC/ylnE0qs9kJoYUp4ZXhevF7BMUOVZcn8qOGS8BAQg65HGRvrG9XvwhkVGhitD4EI2gR5w
	gVNB3777rnFVh9Cuyc8x8uaFm+oHEJctSgpPTyfmYVXD2T4PVIayk7pJpAqxlyqwFGcF35VLjzU
	j0N5TUJI8xJi5gxBNGpzJ8hdDmdoZRKCXo/+WSlsyEPwf/EAiv7lsDlKZOyq+jb7aOog2DVcVd+
	2VAnMD+C6NwdS+jgNzroBxuFKJIl2bAa6Sqx0lMBU0eppowqkJvSd1tUniHPdvK+ODeJrovlb3v
	t6qd3+YvVrWGk60wFmIE+9fThHu3bLIiYwPg==
X-Google-Smtp-Source: AGHT+IGcMMIR2SPPfJvG2NQQfbq95evg3BY5gAEft4jor8DCsZVbXoS61W9VF5v5vMwwYxadOs7XvQ==
X-Received: by 2002:ad4:5f8f:0:b0:707:4daf:637 with SMTP id 6a1803df08f44-7097af1440bmr64538336d6.29.1754531096014;
        Wed, 06 Aug 2025 18:44:56 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:55 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com
Subject: [PATCH v3 06/30] kho: drop notifiers
Date: Thu,  7 Aug 2025 01:44:12 +0000
Message-ID: <20250807014442.3829950-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16DAE1C0006
X-Stat-Signature: 3m6j4ktkzo6xbnrp19p5k6ege1bke3eo
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754531096-590975
X-HE-Meta: U2FsdGVkX1+6reuVgWyScIP83wkLIuXlg7mG0zDD7a5VYicRgp31OOYmr/zfPt7c3ClzOl7jtRlEeMLGNsbeD39iHHM7i9OazaykJqqc8g82W+ovwHb8XsdOcYrjwKVThUsuXYKSvd3ggTtWXn6BxHVzRp+jz8zzBPjhsoCJ0ZjyGbAi2n2oNs3y2G/6RLr9Dz+CBJEUI9dmjyiCSB4oURugtvm+J9gOS0MzEcxd+dTeLMYN1zxuMqnMNvMy/guAfMwYlWo40xbIfPd8q8B57d8vrAODO/brer1KR3q+q/d3VOm4YJ1o0k03y1F4ji/+NnNDe+coBNLxadB0SCgTr5tjfRh0cBE1bKrVax1UeuK1waXt/KB6uc1FPvmAiPHMc4LUfLnu2bQBp5e1HpliScLpy3v1e4ynqphJbCIhHyZsI8kS5nKP9FYUBvbVfUFJj0bwqKv8DVQ58h4OyBOryGaw/XmclWjVwOb3gWkL6ScNAHC1kqNpZ6ksyf/xyHEAR7cCAiXB2WMM2KCajBbb4nGy4Be+rfnyvRGJ+LU1BzBWR2rfznQ9Qcj0kGRP/C+cEX7XgnqM7vQzv2K/KDDlGCiHG5ZHbXOx/Am2OwbsvsrsjVU8OCd5Ewn814ZJXozuWHfF19sGuHjOfS+ggKwf02ZRUQbZ8SFpjP/jcABmBqP4wBhA1QJ0oO+98uyAXnc/G0vnDsNP+rY1o1O0TUWucLmfizRZVsMczIgcoTPpUSVjaUDHTgaU2L7+wqWgJuxnKuKfQizbnqc8vpVYnDIZKtw0EcVQe33vzhIWNxqYdR2OdAfqw8uOoBEV7FDkc+Ae7TIU28PAueOAFqxaePrkphjtJZzE1Dsu4UhH3LvU3RlkE6Ld9of7wS+F0NTplmzqpqslc3JkL4B/hNvYxiHjHiG0yrQm+kSGTMujBd/02R/juxRkGrshoG4la0p764KI4TACkasPu04/Jd+D9nD
 YQqWQk7t
 FhzSUXi/w37SaZOPlvibmvAZKx8jhZu5D4XRWk7UvE4DW4WVvvbBn3h/WO6sGw2oL7VWa71Md+pwghTYPHtZ77PW2Ossf3ofYa/DjDYqbZ+vChlU6QDqhzhr/Mqk5pCpnt6+QmkqhOpXs+kkLV7uDjNsuKckKODr6/IgFJPA/Ke+bztXWthpcn0UeM/2iGS0U6kFP1WYunKd3PEFNo8U5y06aGLIhoUYnK3ApTwYIO2NxvyAPHxxc2peCG2DC9uRPeLLqrPV5wnErIZ/WMGg+fX4szpTIRAw3zB3y4sfIwPMX6i4pHalgw4poIvbaUG97iqHPLarLCdCbECKTmhMyVJVh/lXbtmCpQN95pF9gyAhJ/y3rdKx9q8spFtKoIXk/NX/Z3b37xmWfjJj9sL7TFnOjMn74y7bXySKw8Y+y0FFFD5aCnQIotMHHqjWTt3ZL/oTdUXnNZ5yrr4k=
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
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/kexec_handover.h   |  28 +----
 kernel/kexec_handover.c          | 177 +++++++++++++++++--------------
 kernel/kexec_handover_debug.c    |  17 +--
 kernel/kexec_handover_internal.h |   5 +-
 mm/memblock.c                    |  56 ++--------
 5 files changed, 124 insertions(+), 159 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index f98565def593..cabdff5f50a2 100644
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
 
 #define DECLARE_KHOSER_PTR(name, type) \
 	union {                        \
@@ -36,20 +29,16 @@ struct notifier_block;
 		(typeof((s).ptr))((s).phys ? phys_to_virt((s).phys) : NULL); \
 	})
 
-struct kho_serialization;
-
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 
 int kho_preserve_folio(struct folio *folio);
 int kho_preserve_phys(phys_addr_t phys, size_t size);
 struct folio *kho_restore_folio(phys_addr_t phys);
-int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt);
+int kho_add_subtree(const char *name, void *fdt);
+void kho_remove_subtree(void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
-int register_kho_notifier(struct notifier_block *nb);
-int unregister_kho_notifier(struct notifier_block *nb);
-
 void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
@@ -79,23 +68,16 @@ static inline struct folio *kho_restore_folio(phys_addr_t phys)
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
index a19d271721f7..8a4894e8ac71 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -15,7 +15,6 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
-#include <linux/notifier.h>
 #include <linux/page-isolation.h>
 
 #include <asm/early_ioremap.h>
@@ -82,11 +81,35 @@ struct kho_mem_track {
 
 struct khoser_mem_chunk;
 
-struct kho_serialization {
-	struct page *fdt;
+struct kho_sub_fdt {
+	struct list_head l;
+	const char *name;
+	void *fdt;
+};
+
+struct kho_out {
+	void *fdt;
+	bool finalized;
+	struct mutex lock; /* protects KHO FDT finalization */
+
+	struct list_head sub_fdts;
+	struct mutex fdts_lock;
+
 	struct kho_mem_track track;
 	/* First chunk of serialized preserved memory map */
 	struct khoser_mem_chunk *preserved_mem_map;
+
+	struct kho_debugfs dbg;
+};
+
+static struct kho_out kho_out = {
+	.lock = __MUTEX_INITIALIZER(kho_out.lock),
+	.track = {
+		.orders = XARRAY_INIT(kho_out.track.orders, 0),
+	},
+	.sub_fdts = LIST_HEAD_INIT(kho_out.sub_fdts),
+	.fdts_lock = __MUTEX_INITIALIZER(kho_out.fdts_lock),
+	.finalized = false,
 };
 
 static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
@@ -285,14 +308,14 @@ static void kho_mem_ser_free(struct khoser_mem_chunk *first_chunk)
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
 
@@ -320,7 +343,7 @@ static int kho_mem_serialize(struct kho_serialization *ser)
 		}
 	}
 
-	ser->preserved_mem_map = first_chunk;
+	kho_out->preserved_mem_map = first_chunk;
 
 	return 0;
 
@@ -567,28 +590,8 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
-struct kho_out {
-	struct blocking_notifier_head chain_head;
-	struct mutex lock; /* protects KHO FDT finalization */
-	struct kho_serialization ser;
-	bool finalized;
-	struct kho_debugfs dbg;
-};
-
-static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.ser = {
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
-	},
-	.finalized = false,
-};
-
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
- * @ser: serialization control object passed by KHO notifiers.
  * @name: name of the sub tree.
  * @fdt: the sub tree blob.
  *
@@ -602,34 +605,45 @@ static struct kho_out kho_out = {
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
+
+	mutex_lock(&kho_out.fdts_lock);
+	list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
+	err = kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
+	mutex_unlock(&kho_out.fdts_lock);
 
-	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
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
@@ -644,7 +658,7 @@ int kho_preserve_folio(struct folio *folio)
 {
 	const unsigned long pfn = folio_pfn(folio);
 	const unsigned int order = folio_order(folio);
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 
 	if (kho_out.finalized)
 		return -EBUSY;
@@ -670,7 +684,7 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 	const unsigned long start_pfn = pfn;
 	const unsigned long end_pfn = PHYS_PFN(phys + size);
 	int err = 0;
-	struct kho_mem_track *track = &kho_out.ser.track;
+	struct kho_mem_track *track = &kho_out.track;
 
 	if (kho_out.finalized)
 		return -EBUSY;
@@ -700,11 +714,11 @@ EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
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
 
@@ -714,17 +728,13 @@ static int __kho_abort(void)
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
 
@@ -751,7 +761,7 @@ int kho_abort(void)
 
 	kho_out.finalized = false;
 
-	kho_debugfs_cleanup(&kho_out.dbg);
+	kho_debugfs_fdt_remove(&kho_out.dbg, kho_out.fdt);
 
 unlock:
 	mutex_unlock(&kho_out.lock);
@@ -762,41 +772,46 @@ static int __kho_finalize(void)
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
 
-	*preserved_mem_map = (u64)virt_to_phys(kho_out.ser.preserved_mem_map);
+	mutex_lock(&kho_out.fdts_lock);
+	list_for_each_entry(fdt, &kho_out.sub_fdts, l) {
+		phys_addr_t phys = virt_to_phys(fdt->fdt);
 
-	err |= fdt_end_node(fdt);
-	err |= fdt_finish(fdt);
+		err |= fdt_begin_node(root, fdt->name);
+		err |= fdt_property(root, PROP_SUB_FDT, &phys, sizeof(phys));
+		err |= fdt_end_node(root);
+	};
+	mutex_unlock(&kho_out.fdts_lock);
+
+	err |= fdt_end_node(root);
+	err |= fdt_finish(root);
 
 abort:
 	if (err) {
@@ -827,7 +842,7 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 	ret = kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-				  page_to_virt(kho_out.ser.fdt), true);
+				  kho_out.fdt, true);
 
 unlock:
 	mutex_unlock(&kho_out.lock);
@@ -899,15 +914,17 @@ static __init int kho_init(void)
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
@@ -935,8 +952,8 @@ static __init int kho_init(void)
 	return 0;
 
 err_free_fdt:
-	put_page(kho_out.ser.fdt);
-	kho_out.ser.fdt = NULL;
+	put_page(fdt_page);
+	kho_out.fdt = NULL;
 err_free_scratch:
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		void *start = __va(kho_scratch[i].addr);
@@ -947,7 +964,7 @@ static __init int kho_init(void)
 	kho_enable = false;
 	return err;
 }
-late_initcall(kho_init);
+fs_initcall(kho_init);
 
 static void __init kho_release_scratch(void)
 {
@@ -1083,7 +1100,7 @@ int kho_fill_kimage(struct kimage *image)
 	if (!kho_enable)
 		return 0;
 
-	image->kho.fdt = page_to_phys(kho_out.ser.fdt);
+	image->kho.fdt = virt_to_phys(kho_out.fdt);
 
 	scratch_size = sizeof(*kho_scratch) * kho_scratch_cnt;
 	scratch = (struct kexec_buf){
diff --git a/kernel/kexec_handover_debug.c b/kernel/kexec_handover_debug.c
index b88d138a97be..af4bad225630 100644
--- a/kernel/kexec_handover_debug.c
+++ b/kernel/kexec_handover_debug.c
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
index 41e9616fcdd0..240517596ea3 100644
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
 #endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
 
 #endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
diff --git a/mm/memblock.c b/mm/memblock.c
index 154f1d73b61f..6af0b51b1bb7 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -2501,51 +2501,18 @@ int reserve_mem_release_by_name(const char *name)
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
@@ -2555,6 +2522,7 @@ static int __init prepare_kho_fdt(void)
 	for (i = 0; i < reserved_mem_count; i++) {
 		struct reserve_mem_table *map = &reserved_mem_table[i];
 
+		err |= kho_preserve_phys(map->start, map->size);
 		err |= fdt_begin_node(fdt, map->name);
 		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
 		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
@@ -2562,13 +2530,14 @@ static int __init prepare_kho_fdt(void)
 		err |= fdt_end_node(fdt);
 	}
 	err |= fdt_end_node(fdt);
-
 	err |= fdt_finish(fdt);
 
+	err |= kho_preserve_folio(page_folio(fdt_page));
+	err |= kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
+
 	if (err) {
 		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
-		put_page(kho_fdt);
-		kho_fdt = NULL;
+		put_page(fdt_page);
 	}
 
 	return err;
@@ -2584,13 +2553,6 @@ static int __init reserve_mem_init(void)
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
2.50.1.565.gc32cd1483b-goog


