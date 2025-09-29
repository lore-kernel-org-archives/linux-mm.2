Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7738CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB1028E000A; Sun, 28 Sep 2025 21:03:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEC318E0001; Sun, 28 Sep 2025 21:03:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F1288E000A; Sun, 28 Sep 2025 21:03:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4048E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:03:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38920118DB9
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:37 +0000 (UTC)
X-FDA: 83940490074.09.22BC2CC
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 69C4818000C
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:03:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gWuWX1se;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107815; a=rsa-sha256;
	cv=none;
	b=X/bEu5eIvfvfNgkUjE78SE3oJT+i7Dex5x+nWHAvFoZrPddIPc3f1Izqx1f7C4wlmZ4ZD3
	Cde6yuQoaglhNcSxahEMsqxULvApixzHAmkifqWNDVK9qTGP2vUJilOW5I9dUVnXd806XJ
	m5HhryS0yeFjpNSJBwNd1MxL5EZhbjE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gWuWX1se;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+0a641RVp4eNXltm9Frq8R4NOKxAZQzQ19sOBX9Om4=;
	b=fKD+Ib4fmboCSka0vGG8Z73DjqmzhfCggcQIfm8HrMnpD1wKCMwC3VCCCj3egl7Xu8KmKh
	V52B10ti8uXVg+4bm4u8bHC6Mpmmv43jFliV6rxSi20HCNCAE3lQsl9aXQVlr+/fsnCg0C
	hYvCno1Wyi5DmFAmAiTMYHf7/3fAmUs=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-85e76e886a0so273371685a.1
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:03:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107814; x=1759712614; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M+0a641RVp4eNXltm9Frq8R4NOKxAZQzQ19sOBX9Om4=;
        b=gWuWX1se/0YwM5Jn/CgecM5+w8nLHFnbX97OmYFRTNy9pDvIuz1naRAHAHEc3u79kW
         ee0FPJg/RFrH1aENVslUya6zGCpFwwSPu6h8hJbKum+IVQob15ew7xL2lGsL/o+MxDEo
         Bmyz6iLOXre1v98zkaXRNdMKNd9sFdcgjgO+em2ifSaqCssBZUq6aqA/y1x6HryoEN3R
         wyFZvqUETZX+t1ZE8T2+rorEmdsgN8HMyloppayrJP5I9vZ3yYUsL9TB4IFrzAho2no7
         dDCnISN0qr7kCNe+duhzGg0aVgcckLocy0ztAyzwVbRtnbDmXyTiJMngiSKzSnuXwyLQ
         bN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107814; x=1759712614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M+0a641RVp4eNXltm9Frq8R4NOKxAZQzQ19sOBX9Om4=;
        b=S0u8Y4VflTBCEp9Bxjq60Es14sg4lKxJWN131p18CgK8ASUyce8ysNP9PZcdJ9DJLX
         rfXXr5dT8wBWVVtlSOqu3in4+sHC3DRCFslUWjoFUeqER1sEdBgQSobSivkwhX70OATw
         95N6Qa4rW2GDIeAqaTo6H5WzrvS1tq7F4s7VHp6GjHjf59t1VkmnIM5bPDGydZU3nCzt
         lGyTy1bRRsepJlgQE3ge1WKWeGUyV5MwMWKRVyy3QlgfGRO3uCpoP1lozFNHOEzsl4oM
         u9TCTnWqjdQ0gpoUWZWLvoNEzzob1I5g5UbKMdPOz3luhAP8LCEnI8N4KSzsfSzackwo
         mGrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUc5PwmlvQGpzls5Awx7YSYOYSadOfg7TK3vODgWjwx0jHVAKJaABaenaCZ5VWUT4mnP/ciDuYUhQ==@kvack.org
X-Gm-Message-State: AOJu0YzIwSvn0HJz2ixwGX0HBd3tOJuUbUERzhqggTmo2iZXCsn/E2Lz
	X/IWtUamuMQORzTmSl/DVYjJSjbVPq562MEhLvDnH3rP3jceWPB3oMDlJOsLPKu9f+g=
X-Gm-Gg: ASbGncsVNMm1fQCkPq7SjPJbCIJ8ihLUJQSjZNZi+mFUhBSOdpzvrI+uClg17oeSSFu
	0sPON4vG/tRlXAw5DHXYtFEFfLvLzzT1iW9fIAGNk7XJrg1FjdoVqIu+gjfOgqPHrnSZAjjXfkN
	Qx8WdCKYpvI3hIpf0VJmvRaBlN19RNnuH0ljx4Tq1QKFG8/YN0JjOi4PFRcJaYVtfJDvmQWXQ41
	V30CMAfkgwoWcyfiguipfxWY7b925oAi1s5Piv+UBEKMcdfkoZxZAt/aEHbAX8XmErPhf3t/pm6
	qUUKUOK41Dy9fIdm0AKM9qrTuc56EiE8ZiWg+lYOaU8j/VX/qL4sl8d0998vu0+lexKMyYJgSEV
	NXduR8XVuKLVa5Mer6/WR7yHDhnur7OhMg82Cz1DOBsx+VMmEUdNI/snPaxjE0amvog+asnKdUI
	MCpBRrdR4=
X-Google-Smtp-Source: AGHT+IGonW1CRHUUsXyfbJh6ZoXbzRjlubAVAKY6OPaG8ochgaHRZVLV4raeX9y82h2VGUt1hBc7Vw==
X-Received: by 2002:a05:620a:25d4:b0:84c:e9:f9d7 with SMTP id af79cd13be357-85ae7fb3278mr1782998185a.62.1759107814346;
        Sun, 28 Sep 2025 18:03:34 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:03:33 -0700 (PDT)
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
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 02/30] kho: make debugfs interface optional
Date: Mon, 29 Sep 2025 01:02:53 +0000
Message-ID: <20250929010321.3462457-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 69C4818000C
X-Stat-Signature: 8e5wtm187dzf9wbt1idafpgtqb4r89i9
X-Rspam-User: 
X-HE-Tag: 1759107815-423021
X-HE-Meta: U2FsdGVkX1/2miH9JlgrfrB5TwfEL6BV9JsplEnwfLUjSyDK9Z1PWorG8Rdj7i4TZgOKLpdsB72+/jFLF767Cibabe0wwF+Igm4LWMB41gpEgtajBFCvSc1/q7/umHHpBoJcVk9D4Wd2ILZQeU6/j/H3vw+88whFtMnrDI8wcdRi0J2fi2Z3X21I3S3BWPXf948reeEF5NeTYpSmkmQaogO6euLiZnQwoVt2XXX9ajmDrkEPr3eZrhUEp9PBPlr0PjNNbdNsZpJ3Abr40hVJrcBjH3xHJKq6np40FIvH4BbqIqvw8lQ0IfilZfO7S3e9W4YOO0ZSUIDSeQog8GI2caBtO9y4JrpZJfSCw1N+vW14fxYgPRKKcPD/9eMkZQxCB2s6eB2TV/bGm0LXtqipej00hoIDrg0Gi76FtqQFhGewqg5QPX8UQXk6+AGlF/rjo/+PY0q7+3Q8HPoQhihjfGVzTX9DTZRSX0Q7FKYorYwKVA0JZqMlCIV2JVfnRU/dEzvOH0N2r7ynKXABZbc+AyLcc8CSXxgSvr48iLjGM150panEmASEMzdjfGWsZ0HCn2PrpkLpU1R1ALOd8xnsEUJplgs5bhVKWRbwhB4QCZgZ93dITkVQ7YBuJ8QeNb1G6DBNsPb0mnjqfAlCK/zy+l7T8cyKZr+YMDUmSOc2rTHGhUx4EvCHhC4PIrvXH9SljhMa2xPm2+c3sWEk6tNf/AP4c988cAO6JpC6CtdAGJcp1rTeRK5/eivKNpqzpC+xK0Lg1AXj6WZgfzuRTCqiCpBmB3EWJOZKFBhvvDEMVp64MNwnBGXUG5UR02AaHlyQOMHafZCpqSK4qt8nj1/d9GVYqulJ05WR2f292pgcVLsHjeuAllxp3Qlkidjkv+b6MywSUVPGUUBCd/ZieztNKycMAScQo8aOuEw0zzqs79wurwZWFstbbYEf2obQ9Ol9Un8GgavcillNOZOoEEa
 qrJN5nH5
 tNAFXIKrv1Em7Kq6nwlZorgtMQsvf6T+9aYBC1a/WPJaMVlNynifKwwp5cg3Fva//QUAelF4zidAb1BUPOetYjRNAMuB7yqc4a7ADIo1ECdDHd3AmM8PHkr0W//KpPsp8xcaItkTgtBQBqrnn1A8NXkOWZftGjiBMpy3uWBSgSRCvhkCw8NUDQjmZpuQkypqEHOuWxTVBEK9UEKZNQpUTyg6RiMrYSuEqktWkM20r+xA7ogrHO63HSP3nngu5segQW43T3Ouqk/itS8YcEh9XD/8oAJ+PLGXJ6QTeLS2LZGW0Evv46u7b2bckf+L6X3u39xfaKkPwtWiERnso6sMHeY9qhD7+9raYPAKs/EJGZ2U/f8FZp7hOrgZTHRwooXZL3Fe6ZLF/vYq3WNP/ZqOo6H2gzl4eTti/6IxSyjTpaqsNkxEtg6m3FUVIwR1D9DCZNQTasewMevbfz566cwWpjzo11EfT/pN4kjAhPFsH34xzPoIhYn0L3g2ZAPevfUl3pAWhBPb7aDgEqkKONTCzsVWI10aXxXazRESRdbCzd4KXQbHx2kZUhKWTH8IKxI1V4O63J8ZrPy4KRtfO8S3WU5TtRqzqKKtXqR4I3XSEnDNp5vEG9fhBn3LdJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, KHO is controlled via debugfs interface, but once LUO is
introduced, it can control KHO, and the debug interface becomes
optional.

Add a separate config CONFIG_KEXEC_HANDOVER_DEBUG that enables
the debugfs interface, and allows to inspect the tree.

Move all debugfs related code to a new file to keep the .c files
clear of ifdefs.

Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS                      |   3 +-
 kernel/Kconfig.kexec             |  10 ++
 kernel/Makefile                  |   1 +
 kernel/kexec_handover.c          | 255 +++++--------------------------
 kernel/kexec_handover_debug.c    | 218 ++++++++++++++++++++++++++
 kernel/kexec_handover_internal.h |  44 ++++++
 6 files changed, 311 insertions(+), 220 deletions(-)
 create mode 100644 kernel/kexec_handover_debug.c
 create mode 100644 kernel/kexec_handover_internal.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 156fa8eefa69..a6cbcc7fb396 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13759,13 +13759,14 @@ KEXEC HANDOVER (KHO)
 M:	Alexander Graf <graf@amazon.com>
 M:	Mike Rapoport <rppt@kernel.org>
 M:	Changyuan Lyu <changyuanl@google.com>
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
 L:	kexec@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	Documentation/admin-guide/mm/kho.rst
 F:	Documentation/core-api/kho/*
 F:	include/linux/kexec_handover.h
-F:	kernel/kexec_handover.c
+F:	kernel/kexec_handover*
 F:	tools/testing/selftests/kho/
 
 KEYS-ENCRYPTED
diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 422270d64820..e68156d8c72b 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -109,6 +109,16 @@ config KEXEC_HANDOVER
 	  to keep data or state alive across the kexec. For this to work,
 	  both source and target kernels need to have this option enabled.
 
+config KEXEC_HANDOVER_DEBUG
+	bool "kexec handover debug interface"
+	depends on KEXEC_HANDOVER
+	depends on DEBUG_FS
+	help
+	  Allow to control kexec handover device tree via debugfs
+	  interface, i.e. finalize the state or aborting the finalization.
+	  Also, enables inspecting the KHO fdt trees with the debugfs binary
+	  blobs.
+
 config CRASH_DUMP
 	bool "kernel crash dumps"
 	default ARCH_DEFAULT_CRASH_DUMP
diff --git a/kernel/Makefile b/kernel/Makefile
index df3dd8291bb6..9fe722305c9b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
 obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 0ba5a2dbae28..f0f6c6b8ad83 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -10,7 +10,6 @@
 
 #include <linux/cma.h>
 #include <linux/count_zeros.h>
-#include <linux/debugfs.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/libfdt.h>
@@ -28,6 +27,7 @@
  */
 #include "../mm/internal.h"
 #include "kexec_internal.h"
+#include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
@@ -101,8 +101,6 @@ struct khoser_mem_chunk;
 
 struct kho_serialization {
 	struct page *fdt;
-	struct list_head fdt_list;
-	struct dentry *sub_fdt_dir;
 	struct kho_mem_track track;
 	/* First chunk of serialized preserved memory map */
 	struct khoser_mem_chunk *preserved_mem_map;
@@ -465,8 +463,8 @@ static void __init kho_mem_deserialize(const void *fdt)
  * area for early allocations that happen before page allocator is
  * initialized.
  */
-static struct kho_scratch *kho_scratch;
-static unsigned int kho_scratch_cnt;
+struct kho_scratch *kho_scratch;
+unsigned int kho_scratch_cnt;
 
 /*
  * The scratch areas are scaled by default as percent of memory allocated from
@@ -662,36 +660,24 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
-struct fdt_debugfs {
-	struct list_head list;
-	struct debugfs_blob_wrapper wrapper;
-	struct dentry *file;
+struct kho_out {
+	struct blocking_notifier_head chain_head;
+	struct mutex lock; /* protects KHO FDT finalization */
+	struct kho_serialization ser;
+	bool finalized;
+	struct kho_debugfs dbg;
 };
 
-static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
-			       const char *name, const void *fdt)
-{
-	struct fdt_debugfs *f;
-	struct dentry *file;
-
-	f = kmalloc(sizeof(*f), GFP_KERNEL);
-	if (!f)
-		return -ENOMEM;
-
-	f->wrapper.data = (void *)fdt;
-	f->wrapper.size = fdt_totalsize(fdt);
-
-	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
-	if (IS_ERR(file)) {
-		kfree(f);
-		return PTR_ERR(file);
-	}
-
-	f->file = file;
-	list_add(&f->list, list);
-
-	return 0;
-}
+static struct kho_out kho_out = {
+	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
+	.lock = __MUTEX_INITIALIZER(kho_out.lock),
+	.ser = {
+		.track = {
+			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
+		},
+	},
+	.finalized = false,
+};
 
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
@@ -704,7 +690,8 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
  * by KHO for the new kernel to retrieve it after kexec.
  *
  * A debugfs blob entry is also created at
- * ``/sys/kernel/debug/kho/out/sub_fdts/@name``.
+ * ``/sys/kernel/debug/kho/out/sub_fdts/@name`` when kernel is configured with
+ * CONFIG_KEXEC_HANDOVER_DEBUG
  *
  * Return: 0 on success, error code on failure
  */
@@ -721,7 +708,7 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 	if (err)
 		return err;
 
-	return kho_debugfs_fdt_add(&ser->fdt_list, ser->sub_fdt_dir, name, fdt);
+	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
@@ -1044,29 +1031,6 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
 }
 EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
 
-/* Handling for debug/kho/out */
-
-static struct dentry *debugfs_root;
-
-static int kho_out_update_debugfs_fdt(void)
-{
-	int err = 0;
-	struct fdt_debugfs *ff, *tmp;
-
-	if (kho_out.finalized) {
-		err = kho_debugfs_fdt_add(&kho_out.ser.fdt_list, kho_out.dir,
-					  "fdt", page_to_virt(kho_out.ser.fdt));
-	} else {
-		list_for_each_entry_safe(ff, tmp, &kho_out.ser.fdt_list, list) {
-			debugfs_remove(ff->file);
-			list_del(&ff->list);
-			kfree(ff);
-		}
-	}
-
-	return err;
-}
-
 static int __kho_abort(void)
 {
 	int err;
@@ -1119,7 +1083,8 @@ int kho_abort(void)
 		goto unlock;
 
 	kho_out.finalized = false;
-	ret = kho_out_update_debugfs_fdt();
+
+	kho_debugfs_cleanup(&kho_out.dbg);
 
 unlock:
 	mutex_unlock(&kho_out.lock);
@@ -1169,7 +1134,7 @@ static int __kho_finalize(void)
 abort:
 	if (err) {
 		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
+		__kho_abort();
 	}
 
 	return err;
@@ -1194,119 +1159,32 @@ int kho_finalize(void)
 		goto unlock;
 
 	kho_out.finalized = true;
-	ret = kho_out_update_debugfs_fdt();
+	ret = kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
+				  page_to_virt(kho_out.ser.fdt), true);
 
 unlock:
 	mutex_unlock(&kho_out.lock);
 	return ret;
 }
 
-static int kho_out_finalize_get(void *data, u64 *val)
+bool kho_finalized(void)
 {
-	mutex_lock(&kho_out.lock);
-	*val = kho_out.finalized;
-	mutex_unlock(&kho_out.lock);
-
-	return 0;
-}
-
-static int kho_out_finalize_set(void *data, u64 _val)
-{
-	int ret = 0;
-	bool val = !!_val;
+	bool ret;
 
 	mutex_lock(&kho_out.lock);
-
-	if (val == kho_out.finalized) {
-		if (kho_out.finalized)
-			ret = -EEXIST;
-		else
-			ret = -ENOENT;
-		goto unlock;
-	}
-
-	if (val)
-		ret = kho_finalize();
-	else
-		ret = kho_abort();
-
-	if (ret)
-		goto unlock;
-
-	kho_out.finalized = val;
-	ret = kho_out_update_debugfs_fdt();
-
-unlock:
+	ret = kho_out.finalized;
 	mutex_unlock(&kho_out.lock);
-	return ret;
-}
-
-DEFINE_DEBUGFS_ATTRIBUTE(fops_kho_out_finalize, kho_out_finalize_get,
-			 kho_out_finalize_set, "%llu\n");
-
-static int scratch_phys_show(struct seq_file *m, void *v)
-{
-	for (int i = 0; i < kho_scratch_cnt; i++)
-		seq_printf(m, "0x%llx\n", kho_scratch[i].addr);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(scratch_phys);
 
-static int scratch_len_show(struct seq_file *m, void *v)
-{
-	for (int i = 0; i < kho_scratch_cnt; i++)
-		seq_printf(m, "0x%llx\n", kho_scratch[i].size);
-
-	return 0;
-}
-DEFINE_SHOW_ATTRIBUTE(scratch_len);
-
-static __init int kho_out_debugfs_init(void)
-{
-	struct dentry *dir, *f, *sub_fdt_dir;
-
-	dir = debugfs_create_dir("out", debugfs_root);
-	if (IS_ERR(dir))
-		return -ENOMEM;
-
-	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
-	if (IS_ERR(sub_fdt_dir))
-		goto err_rmdir;
-
-	f = debugfs_create_file("scratch_phys", 0400, dir, NULL,
-				&scratch_phys_fops);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
-	f = debugfs_create_file("scratch_len", 0400, dir, NULL,
-				&scratch_len_fops);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
-	f = debugfs_create_file("finalize", 0600, dir, NULL,
-				&fops_kho_out_finalize);
-	if (IS_ERR(f))
-		goto err_rmdir;
-
-	kho_out.dir = dir;
-	kho_out.ser.sub_fdt_dir = sub_fdt_dir;
-	return 0;
-
-err_rmdir:
-	debugfs_remove_recursive(dir);
-	return -ENOENT;
+	return ret;
 }
 
 struct kho_in {
-	struct dentry *dir;
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
-	struct list_head fdt_list;
+	struct kho_debugfs dbg;
 };
 
 static struct kho_in kho_in = {
-	.fdt_list = LIST_HEAD_INIT(kho_in.fdt_list),
 };
 
 static const void *kho_get_fdt(void)
@@ -1370,56 +1248,6 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 }
 EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
-/* Handling for debugfs/kho/in */
-
-static __init int kho_in_debugfs_init(const void *fdt)
-{
-	struct dentry *sub_fdt_dir;
-	int err, child;
-
-	kho_in.dir = debugfs_create_dir("in", debugfs_root);
-	if (IS_ERR(kho_in.dir))
-		return PTR_ERR(kho_in.dir);
-
-	sub_fdt_dir = debugfs_create_dir("sub_fdts", kho_in.dir);
-	if (IS_ERR(sub_fdt_dir)) {
-		err = PTR_ERR(sub_fdt_dir);
-		goto err_rmdir;
-	}
-
-	err = kho_debugfs_fdt_add(&kho_in.fdt_list, kho_in.dir, "fdt", fdt);
-	if (err)
-		goto err_rmdir;
-
-	fdt_for_each_subnode(child, fdt, 0) {
-		int len = 0;
-		const char *name = fdt_get_name(fdt, child, NULL);
-		const u64 *fdt_phys;
-
-		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
-		if (!fdt_phys)
-			continue;
-		if (len != sizeof(*fdt_phys)) {
-			pr_warn("node `%s`'s prop `fdt` has invalid length: %d\n",
-				name, len);
-			continue;
-		}
-		err = kho_debugfs_fdt_add(&kho_in.fdt_list, sub_fdt_dir, name,
-					  phys_to_virt(*fdt_phys));
-		if (err) {
-			pr_warn("failed to add fdt `%s` to debugfs: %d\n", name,
-				err);
-			continue;
-		}
-	}
-
-	return 0;
-
-err_rmdir:
-	debugfs_remove_recursive(kho_in.dir);
-	return err;
-}
-
 static __init int kho_init(void)
 {
 	int err = 0;
@@ -1434,27 +1262,16 @@ static __init int kho_init(void)
 		goto err_free_scratch;
 	}
 
-	debugfs_root = debugfs_create_dir("kho", NULL);
-	if (IS_ERR(debugfs_root)) {
-		err = -ENOENT;
+	err = kho_debugfs_init();
+	if (err)
 		goto err_free_fdt;
-	}
 
-	err = kho_out_debugfs_init();
+	err = kho_out_debugfs_init(&kho_out.dbg);
 	if (err)
 		goto err_free_fdt;
 
 	if (fdt) {
-		err = kho_in_debugfs_init(fdt);
-		/*
-		 * Failure to create /sys/kernel/debug/kho/in does not prevent
-		 * reviving state from KHO and setting up KHO for the next
-		 * kexec.
-		 */
-		if (err)
-			pr_err("failed exposing handover FDT in debugfs: %d\n",
-			       err);
-
+		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
 	}
 
diff --git a/kernel/kexec_handover_debug.c b/kernel/kexec_handover_debug.c
new file mode 100644
index 000000000000..b88d138a97be
--- /dev/null
+++ b/kernel/kexec_handover_debug.c
@@ -0,0 +1,218 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kexec_handover.c - kexec handover metadata processing
+ * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
+ * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
+ * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
+ * Copyright (C) 2025 Google LLC, Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+
+#define pr_fmt(fmt) "KHO: " fmt
+
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/libfdt.h>
+#include <linux/mm.h>
+#include "kexec_handover_internal.h"
+
+static struct dentry *debugfs_root;
+
+struct fdt_debugfs {
+	struct list_head list;
+	struct debugfs_blob_wrapper wrapper;
+	struct dentry *file;
+};
+
+static int __kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
+				 const char *name, const void *fdt)
+{
+	struct fdt_debugfs *f;
+	struct dentry *file;
+
+	f = kmalloc(sizeof(*f), GFP_KERNEL);
+	if (!f)
+		return -ENOMEM;
+
+	f->wrapper.data = (void *)fdt;
+	f->wrapper.size = fdt_totalsize(fdt);
+
+	file = debugfs_create_blob(name, 0400, dir, &f->wrapper);
+	if (IS_ERR(file)) {
+		kfree(f);
+		return PTR_ERR(file);
+	}
+
+	f->file = file;
+	list_add(&f->list, list);
+
+	return 0;
+}
+
+int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
+			const void *fdt, bool root)
+{
+	struct dentry *dir;
+
+	if (root)
+		dir = dbg->dir;
+	else
+		dir = dbg->sub_fdt_dir;
+
+	return __kho_debugfs_fdt_add(&dbg->fdt_list, dir, name, fdt);
+}
+
+void kho_debugfs_cleanup(struct kho_debugfs *dbg)
+{
+	struct fdt_debugfs *ff, *tmp;
+
+	list_for_each_entry_safe(ff, tmp, &dbg->fdt_list, list) {
+		debugfs_remove(ff->file);
+		list_del(&ff->list);
+		kfree(ff);
+	}
+}
+
+static int kho_out_finalize_get(void *data, u64 *val)
+{
+	*val = kho_finalized();
+
+	return 0;
+}
+
+static int kho_out_finalize_set(void *data, u64 _val)
+{
+	bool val = !!_val;
+
+	if (val)
+		return kho_finalize();
+
+	return kho_abort();
+}
+
+DEFINE_DEBUGFS_ATTRIBUTE(kho_out_finalize_fops, kho_out_finalize_get,
+			 kho_out_finalize_set, "%llu\n");
+
+static int scratch_phys_show(struct seq_file *m, void *v)
+{
+	for (int i = 0; i < kho_scratch_cnt; i++)
+		seq_printf(m, "0x%llx\n", kho_scratch[i].addr);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(scratch_phys);
+
+static int scratch_len_show(struct seq_file *m, void *v)
+{
+	for (int i = 0; i < kho_scratch_cnt; i++)
+		seq_printf(m, "0x%llx\n", kho_scratch[i].size);
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(scratch_len);
+
+__init void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt)
+{
+	struct dentry *dir, *sub_fdt_dir;
+	int err, child;
+
+	INIT_LIST_HEAD(&dbg->fdt_list);
+
+	dir = debugfs_create_dir("in", debugfs_root);
+	if (IS_ERR(dir)) {
+		err = PTR_ERR(dir);
+		goto err_out;
+	}
+
+	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
+	if (IS_ERR(sub_fdt_dir)) {
+		err = PTR_ERR(sub_fdt_dir);
+		goto err_rmdir;
+	}
+
+	err = __kho_debugfs_fdt_add(&dbg->fdt_list, dir, "fdt", fdt);
+	if (err)
+		goto err_rmdir;
+
+	fdt_for_each_subnode(child, fdt, 0) {
+		int len = 0;
+		const char *name = fdt_get_name(fdt, child, NULL);
+		const u64 *fdt_phys;
+
+		fdt_phys = fdt_getprop(fdt, child, "fdt", &len);
+		if (!fdt_phys)
+			continue;
+		if (len != sizeof(*fdt_phys)) {
+			pr_warn("node %s prop fdt has invalid length: %d\n",
+				name, len);
+			continue;
+		}
+		err = __kho_debugfs_fdt_add(&dbg->fdt_list, sub_fdt_dir, name,
+					    phys_to_virt(*fdt_phys));
+		if (err) {
+			pr_warn("failed to add fdt %s to debugfs: %d\n", name,
+				err);
+			continue;
+		}
+	}
+
+	dbg->dir = dir;
+	dbg->sub_fdt_dir = sub_fdt_dir;
+
+	return;
+err_rmdir:
+	debugfs_remove_recursive(dir);
+err_out:
+	/*
+	 * Failure to create /sys/kernel/debug/kho/in does not prevent
+	 * reviving state from KHO and setting up KHO for the next
+	 * kexec.
+	 */
+	if (err)
+		pr_err("failed exposing handover FDT in debugfs: %d\n", err);
+}
+
+__init int kho_out_debugfs_init(struct kho_debugfs *dbg)
+{
+	struct dentry *dir, *f, *sub_fdt_dir;
+
+	INIT_LIST_HEAD(&dbg->fdt_list);
+
+	dir = debugfs_create_dir("out", debugfs_root);
+	if (IS_ERR(dir))
+		return -ENOMEM;
+
+	sub_fdt_dir = debugfs_create_dir("sub_fdts", dir);
+	if (IS_ERR(sub_fdt_dir))
+		goto err_rmdir;
+
+	f = debugfs_create_file("scratch_phys", 0400, dir, NULL,
+				&scratch_phys_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
+	f = debugfs_create_file("scratch_len", 0400, dir, NULL,
+				&scratch_len_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
+	f = debugfs_create_file("finalize", 0600, dir, NULL,
+				&kho_out_finalize_fops);
+	if (IS_ERR(f))
+		goto err_rmdir;
+
+	dbg->dir = dir;
+	dbg->sub_fdt_dir = sub_fdt_dir;
+	return 0;
+
+err_rmdir:
+	debugfs_remove_recursive(dir);
+	return -ENOENT;
+}
+
+__init int kho_debugfs_init(void)
+{
+	debugfs_root = debugfs_create_dir("kho", NULL);
+	if (IS_ERR(debugfs_root))
+		return -ENOENT;
+	return 0;
+}
diff --git a/kernel/kexec_handover_internal.h b/kernel/kexec_handover_internal.h
new file mode 100644
index 000000000000..f6f172ddcae4
--- /dev/null
+++ b/kernel/kexec_handover_internal.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef LINUX_KEXEC_HANDOVER_INTERNAL_H
+#define LINUX_KEXEC_HANDOVER_INTERNAL_H
+
+#include <linux/kexec_handover.h>
+#include <linux/list.h>
+#include <linux/types.h>
+
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+#include <linux/debugfs.h>
+
+struct kho_debugfs {
+	struct dentry *dir;
+	struct dentry *sub_fdt_dir;
+	struct list_head fdt_list;
+};
+
+#else
+struct kho_debugfs {};
+#endif
+
+extern struct kho_scratch *kho_scratch;
+extern unsigned int kho_scratch_cnt;
+
+bool kho_finalized(void);
+
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUG
+int kho_debugfs_init(void);
+void kho_in_debugfs_init(struct kho_debugfs *dbg, const void *fdt);
+int kho_out_debugfs_init(struct kho_debugfs *dbg);
+int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
+			const void *fdt, bool root);
+void kho_debugfs_cleanup(struct kho_debugfs *dbg);
+#else
+static inline int kho_debugfs_init(void) { return 0; }
+static inline void kho_in_debugfs_init(struct kho_debugfs *dbg,
+				       const void *fdt) { }
+static inline int kho_out_debugfs_init(struct kho_debugfs *dbg) { return 0; }
+static inline int kho_debugfs_fdt_add(struct kho_debugfs *dbg, const char *name,
+				      const void *fdt, bool root) { return 0; }
+static inline void kho_debugfs_cleanup(struct kho_debugfs *dbg) {}
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUG */
+
+#endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
-- 
2.51.0.536.g15c5d4f767-goog


