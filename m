Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFF7C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 14:47:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0600D6B00F9; Wed, 23 Jul 2025 10:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F064F6B00FA; Wed, 23 Jul 2025 10:47:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5846B00FB; Wed, 23 Jul 2025 10:47:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C43DF6B00F9
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:47:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BB5E14071D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:09 +0000 (UTC)
X-FDA: 83695806978.23.FDC5126
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 87A7220016
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:47:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=TvcyHlgr;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753282027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P16dMjG+eBIby4m6CV13FKaPKlPVREZrX2+cF3fbAz8=;
	b=PDV9FsYSA5kWln5qqERf7o7Fz0C9lwleysqqBLbrnJWpC2vqbYy/rlpElIhn2jy+HomXey
	u3+YrZH40OoBKvnuoIHNon/4TvuGuyGN14cnV9VrQle0SxsFu5Mcl3qLOFYykBr3dnAhRx
	J7Qmu02FojT7iCyr2HLHr9lFEKyCM2M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen-com.20230601.gappssmtp.com header.s=20230601 header.b=TvcyHlgr;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753282027; a=rsa-sha256;
	cv=none;
	b=wZC+iYuPpMVioZkGMLHyN058xB0xIUsEDD+cokB0BFEPHOp8isEL8BjyEVq6byQCcZufEK
	QZP3gtuTmfF1mnaxK7lKj6TnGakqwmB83RU7evTOJa4SdI1W8dULi2JyfT2uw6WXjxSwgZ
	BY2QYdPEb7mUh2l7ZZZwOrFhqthsnrA=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-719a4206caeso20694267b3.1
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 07:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen-com.20230601.gappssmtp.com; s=20230601; t=1753282026; x=1753886826; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P16dMjG+eBIby4m6CV13FKaPKlPVREZrX2+cF3fbAz8=;
        b=TvcyHlgrMrKMeclmwCIa9EN9MUFGz0Pbc/OW63hTosx7nBWVFYARrLVSZjYk/ifQHi
         dC1l20+5Mjg/0/gz23+S2Q5PB8VzrKFvSzktr7xB+tRBhrW73yaECUNYZV+G7+J1orlB
         eLXpz3qLY/V7y/50vRM1CPxLbZqk8AanLAVNrYyIE2cUW/suyZDy2wpzSZvL+DC3Auqv
         XHV3N5T2EUrZNH0YnJlv/FHqtEIISVDWkOR7rgeAH44ppZmIkeLCYQfuP/Y1ajEi3Zy9
         RjmPKR5NuPTcYCS6ck1EA8xGXiVHgqmnjGtIlsU53HMlyMM5ivbWRShU7YFRB9EfkV7t
         E2kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753282026; x=1753886826;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P16dMjG+eBIby4m6CV13FKaPKlPVREZrX2+cF3fbAz8=;
        b=xKbXLHedb1V7xPSu5+3GWz/YqyqIR0ipv8u/FBkifHaLXa4+7JEuM1lNCTC719s/yS
         BUehziCW+anqzKo1rhyChTBusrCSzgopVVwaKcGDbqELiTbnFppqCJ8Z5UPhbupnD2PK
         mYhCcehoBqRDj/oibyRdXtRYO7e/42Qa5OGM60cWj0XxUN0Nqo4HfWuVgoRJ+4U6pULu
         SAuU1c0dEyxEq6OvTsrA4TZMKH8FEoYBFWnvs40MzNnpYhjOPck0MpPq1Jh4j7dsTV0r
         Nh6twgs3HzLpH9guxcyFo6ccIuCu9ssLsZQIGi4O5rOA4pvrkeRAJS+bNdvpCNSHsbcO
         +T7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWbGzSBfqC0ryvXqwAMdngMT31jMrra8Naj/PG6I2gDmKqcqs7p4t1S2soQTmiZ3ev67ukGCRkltQ==@kvack.org
X-Gm-Message-State: AOJu0YyvF0K65eriCkLYz8whvfssFEjDpt1Hpz7T8EGzYNqUHeV4hNA3
	etRRBz8C6eM/vKEXQaCoSEsdRisquMcVwk8JfLPtjSxlag/LKvnBJHXYXi3Ns5UsaRw=
X-Gm-Gg: ASbGnctCFWc8ZbZr5wzDeY0TgCU1R47f+u/d8gCl7Jgxh0U6i9iF3v6KLBu6MyoxUa5
	yf2/2CYdIjYczZVupoHiR+2uti/WpX7yv+SDOFT/G5P4V14Yyzb/2oS/y0Uk9mIGXaNhZphy0Ox
	6RYxvtAN2gF2cco3useVs1V8+dUah/sfcRFDKKsNKh1tp94zRCKxJUtCORlMyB9Ii47NWx6a33q
	LGXvzXaPJBsnrs6meA6jg7OcOudAizZRxy0Oq0k8aUkrSChkaKPXtu+/sbkahL9WCLpJHmBKlTx
	oloNDiiT4FCBSjw7C4kCUlExw2/1Jl8u4kF+HJx33vAuLHytoL1Nd8Ci4zmpClinWr5hLgDvqSs
	kwJzlTgt+BdZSR0By5QOTn+5QsN0ISRlLOe/oB9ssR0iW+sQtbU2Zlec42qYrf8Ah1dRkPwPb1r
	Qrln7E2F3ciTeFDg==
X-Google-Smtp-Source: AGHT+IHWatUs7Hs0KKZ14v/cggc4Ed333ZLRxX+YU0gH76DWBOv1E+jPUtUb0U/ZKTGi/fUUCRdxmw==
X-Received: by 2002:a05:690c:3809:b0:719:5664:87fd with SMTP id 00721157ae682-719b4256275mr41785577b3.37.1753282026373;
        Wed, 23 Jul 2025 07:47:06 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-719532c7e4fsm30482117b3.72.2025.07.23.07.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jul 2025 07:47:05 -0700 (PDT)
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
Subject: [PATCH v2 06/32] kho: drop notifiers
Date: Wed, 23 Jul 2025 14:46:19 +0000
Message-ID: <20250723144649.1696299-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
In-Reply-To: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
References: <20250723144649.1696299-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kb3nwmg9ez3gr9us6r79cxqyh91sx6ai
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 87A7220016
X-Rspam-User: 
X-HE-Tag: 1753282027-817760
X-HE-Meta: U2FsdGVkX1/D1fTfWsZJcIElzDdnxHEa1/X/PaZBHf0llSKY+m7IccDZwRLWTYXPVyMrDF7vObc7N1uGg69A1zfkPKjFaVbYkNrKzhg3aLZysQyvmPb4hKDpEeG4tiA1bWN8h8HufFS+Amy7jAVhinIHWHEzaFNmkE+NeXfCkNbIjLgx710crXNLQym8cZA7h3xWTSZHStSItIKefEAbmkPzWFPuo2+KQEKYeJayZXuuXht8jNk8SUYxGPndqdzduy+xLxScCCJbE6YGrpBDY2vcXBCOvyj6vpNgIZCdo2qNeTT0FBr8vbulxAiodLHBafBv4TowwsTZjK4BEBRa3rrT0S99x6j5BCjZQeJ1Ky2qXQtSMhYOwbZax7Tse4+g+4uYgCq1xqmvqso3Q5IP0quGWiR+n40vL8i6HLqBegNPjhVDTSAThGYNSDLtJhNpTWbQKVmEnSfAHOLxRFALtv+DzWi2CJi8Ih6azXqvIA1ELFab/wosQ1imrVeQSqsK6rokjP/jLZWD15FAYNiPcmPIClpsUx3bOi90wh5WHwjFi1s4wPDLEzvxDPhnibRBS2X8O/FANGkoTruVA2RqCk2CsFHV8mGZSV9H6PbmtIzbzH4IciBNgQL1tSoDLK3xV+r2r7SO95aBZd4h04MJ2Xt0CSyKT0MNw9Bi3bGLWKoW7PyzvPeN6Z1bW5hLSY2z0HwWvVzMW1xVpzleKhE+WH1Z3AMJazPNu7i5270WuTDcLOePnp2VEHlJrz89MWATfLczvmyjwLn5KFKZvfAXOEzwlqcoTsM5024hUFTfa5RCtxDqDb7sNN9iBHV+Mqz/e55Ft0yEL8AZHECzy9kmGyJkTCiEO0Tl/T85LtTuJOonuzrBScQIQnFRrOrxS8wZ8Fiqh2S3lDKY3L+29cIqWvr6i3Cwzeki38HUoCwPKMHE9gzjB4gaz3gVnoFrcHMkl1dnjn2BEfChNw7r364
 QW6qdYhs
 O5LIBcixPcbWytvnwh6h0xz8iCo0zzZX23/cTKOS9JGc21sfYntdA7gOQJkGoXOFZXYPQRH7nv8HhLmhFjz1QC2vylyIQHUdGKvrOPQpuseP2EBGKeZo30p/pGEL4B3ulquTpFMQmA7QeXJEcGBp8UlY3knNnMeIO30joARhM+ufApG1c1/QvK8dze+5RqvVfW1h2C/GDlrKBhzuw/Ur3AfIKrm8jZqaOYmj96qJtaVaJAovUjRX0+/IVr5rLLKA53AJwlm6Bsbf+4cLtvIf6Kp9kK09idEoR/X5IiIbo26YbzzLqYXUVCyVB+hhZe4GiysXiqnesJJoORgWCcCV6CQk7RO2y7bhkgAqC4ep5FnG42AZLJHdDgzbJNadJlpa+99tVFtTy+Me0wkWUUEY8JJoRUtTfx+Eg+kmOmill72CMy53WhNWMTIqipI1izHY3KTL1bg8tKc+y79XLZ1gpW5Fq/kK80uEf4z/+ilvTZfFdQt4l9F75Z9jevFnLIfG5k/I+F9ccEd7HlFn9WMB6LdgEoq11ri1f8mHRRLTysSDCZOw=
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
index 32fdc388752b..30d673f7f68a 100644
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
@@ -763,41 +773,46 @@ static int __kho_finalize(void)
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
@@ -828,7 +843,7 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 	ret = kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
-				  page_to_virt(kho_out.ser.fdt), true);
+				  kho_out.fdt, true);
 
 unlock:
 	mutex_unlock(&kho_out.lock);
@@ -901,15 +916,17 @@ static __init int kho_init(void)
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
@@ -937,8 +954,8 @@ static __init int kho_init(void)
 	return 0;
 
 err_free_fdt:
-	put_page(kho_out.ser.fdt);
-	kho_out.ser.fdt = NULL;
+	put_page(fdt_page);
+	kho_out.fdt = NULL;
 err_free_scratch:
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		void *start = __va(kho_scratch[i].addr);
@@ -949,7 +966,7 @@ static __init int kho_init(void)
 	kho_enable = false;
 	return err;
 }
-late_initcall(kho_init);
+fs_initcall(kho_init);
 
 static void __init kho_release_scratch(void)
 {
@@ -1085,7 +1102,7 @@ int kho_fill_kimage(struct kimage *image)
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
2.50.0.727.gbf7dc18ff4-goog


