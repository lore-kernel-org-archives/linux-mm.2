Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15A49C87FCB
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 01:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23EA96B0099; Wed,  6 Aug 2025 21:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216166B009A; Wed,  6 Aug 2025 21:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DDE26B009B; Wed,  6 Aug 2025 21:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBD266B0099
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6820E81F01
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:57 +0000 (UTC)
X-FDA: 83748267834.26.E23E912
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 91C2B40007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 01:44:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W3E+2UuY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754531095; a=rsa-sha256;
	cv=none;
	b=Dr8J1LfIXKuzlb+wt+dN0w3dHiTFQ/cvTTZoCnizSZHE9g2QZSbuvpmVt1leyfw7U2/k5V
	cZxV4tVK+r6UVsD0QRmT+BePPfuatHBPiRiKHFz4lC58Sh+DtbJJnm7nQuuYqr13j/Be6s
	2/PSLVTqqp89/KptiKsOepH31ICB/MQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W3E+2UuY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754531095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuJY+DJcpvZ8c9vRXHnvTFVehhdRAUYZ2+dB0gIVboA=;
	b=A1k3Jwv5c+BJFHKv9+XaV1bXWcLM/OFqaEqG+s7QJ9FiYsnI4P2FlijoczQIyXgV1PscaH
	WTbVW//HHhqkvPnEKemGBuQvVdiGnzKhoRW3U3vwMMwNhWLkhC3qiD1cB1PVXd8oJik1aS
	49BB8Iih8LJQq1GMTA5EIqKpJIkAe1g=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-707453b0306so5568096d6.2
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 18:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754531095; x=1755135895; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IuJY+DJcpvZ8c9vRXHnvTFVehhdRAUYZ2+dB0gIVboA=;
        b=W3E+2UuYERfuxzlngVgm+kiZ0icWSo03Fy8+MM92tBWxO6HD2vAfb2HD4ao61ePBKn
         93BiblW+tSkhqMS3Ta+8n4O+A/ry+wM+OD4H4lxtJE8Rl4szLTA6SmRYMIUfLo+U+SG5
         6Sauoo3I+loZwSmRkOX8WWXEGqIe6bAEueeu8ppr4bu7x4RqpQrwXacjMaLeEbuT0IF/
         ABd5mmcJguG2EU5lRI01YGzkVX2zzJD+ouAR/ROUsGmvqEYXyCwhfmH8NzXPC9l/y4qx
         CegWaiGHn65pDRysmJWpwtucUpU3XREh2V4eITIVC1R+z+imt7/3viPGw+vE8ec3/Ctu
         YxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754531095; x=1755135895;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IuJY+DJcpvZ8c9vRXHnvTFVehhdRAUYZ2+dB0gIVboA=;
        b=ZwvjFpZN+gqHgud0ioxSCQI1RsorHSwsTrgaMo0Y4pkIkEvQnU4789ziEh/T44Cacc
         wAlp1l2pT1Y1SkWrFsPeeEWqpp5tFze6glV00DwD04sHPx0KllKs+Rsmp5cUQyjX5JsZ
         R1ZXynB3HSS1ZY7NF/LunlXgIPBZ9Pxaqdvjk1GmygD1fITxDYeMzMddai5mpX6pGyPB
         7XjKTExoPTVzYfOikrI6bhFZIV2abYec0GsZEmwD2Cqm3JlTiagTm7ujK8E3iNFkFPEl
         kwvDY/QJ1eCX5OMQ5oos7xttu7Nk+tw0cxFhjZ0aTJrbQ8SkTu082pA0P4pjxc5C9yDU
         IsVg==
X-Forwarded-Encrypted: i=1; AJvYcCXsYZm/eOSTZ6a61FC0EgXXklq5gGeVqEcSo8hX6IlvE0fomV1zOX4lK6lvpC3zCw875HkwqPeCHA==@kvack.org
X-Gm-Message-State: AOJu0YyMaAcbMk82OY89BLtWKTcme/X2H75h4Zma5K72rDdTHEuRlW7a
	T76Kilnr1wT3A4PbuaHWPPI8GvWlEA4fq2ccPkXvZKK5MU7jWql4SzihOCQ3gE0kQ84=
X-Gm-Gg: ASbGnctZOzPzSy4K8uAeiGjTdQ82+8kP9REULS9DYQPqyEHZrUKx+eJsUr8bKBZzxZM
	xzbIE2kbS2fa/BQyvmAKCPq8Bf7AxAsoJ18zFgXeVZsQ/DUkYVMwtURbvBvSMTeFWutYhZmgS2e
	TYJ3evN3LO20Uu3flpE045p+AgDr2iVVLbYUqrAM92Cx2IPGOShvrUH/4CSsKqppRFzQEuKy0Jy
	AJZgMdLbSF3MzNzmqdjqfFDX7KBnukhuddgv76Sqg7pD/p6vQE/qT8SKDBMFFsiTRMNw6uor6+E
	bERJmCgEde9JeVUMYzCn/FqmQ1/K29edqSFLujOsy8FsuIJRPRFyGNZaKfk+s5xrXY6SyV50Qeg
	I1dlj0Ln3wlGIxN6E0g8FZtSwpN4RYWJ0zZDL+CjyTs76d92ocznLz4N2amWYd7brr+ALBYHaTn
	qdeQw5s1JIp0fM
X-Google-Smtp-Source: AGHT+IE1tVM0YUUcEBsMqVCKHVRy1rkAu8tlveZeewH/tKzAaP6qTaZRqK6AkniZb18bLHt5TBKrpQ==
X-Received: by 2002:a05:6214:1c4c:b0:707:56bd:906f with SMTP id 6a1803df08f44-7097ae18869mr69979806d6.17.1754531094496;
        Wed, 06 Aug 2025 18:44:54 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cde5a01sm92969046d6.70.2025.08.06.18.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 18:44:53 -0700 (PDT)
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
Subject: [PATCH v3 05/30] kho: make debugfs interface optional
Date: Thu,  7 Aug 2025 01:44:11 +0000
Message-ID: <20250807014442.3829950-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
In-Reply-To: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 91C2B40007
X-Stat-Signature: x4ez9eb6bptnbzopyt6is71sxd4tc31w
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754531095-852281
X-HE-Meta: U2FsdGVkX19KwOuKyIHg4cs7/llHJNreDs/u2WN4WHOwEX0M+lO2QcRsMpPQ/44VqvnUsZxxFY2od773OnJoul7erObdhOTAaPtMWpb2mi86dJF/neBAJrCdPh1nk9xYh8LGmR8qR/U3ye2L+G+hcf2YN9+GDHBhTMqn2eyLFZeq6B7xxC3gIifVbwN1YWuD2foV6bGUH1+2VF+Tj3E/BuooiVH/WnOE4nvA3aIlvfCiBHQA8B8XjWs3Oj7l8nFdHnwhvXvV+8t/5QEfs9TCGPiJ37T8c7ogFdz9/ORXFONPdLH+cHub/t7xU4rm1WHMIul7gIS2z0RUhAwaySK9C7XVSrFIP4P1NRTAm8ehKE/VTovuh7lNa1CqujhSQnzU9cbbqXc+7jyiARa32a/G9VDiYL1Yf4lu300eR+kGN4g3q8PCjhHBN1XgBDGTEYzw96VDLvc+sAkiPTFUmpR3VLOTYuc+SLi/wUXgrONd/GycqbLazScGOEeUojvPWppB21z5Oq9VoUaPGAMbBMpC/3ythHmP/Vnkq67MNEU7qdfSyOgTZeiQH6St22f4Jq/tXetx0n/FiZE35fHbu8HcXHbJs1Azrac6U5EuyGkaMXwa58HN7jNOGRyEQ+nMwYKF/u3hp92GkecjZhVIGJMhGvOwMZCJwG5lBixc0/ibkR0bZvSYW3Byn8I+86dkrtq/wQeguprWa/XqKkZ0841PtmuRIovMJvjLFov3O8PzGZ1iiaPJYpSgFv8+LGgjUuN/9GOEJkjVgr81skmRtwkupw5nUTTe+aFJTvYGzLC+rQUIJ9blEt+ikFkCdFYdBvwy+sNZ6MQ2/Tg7r3+fShjOpp/qfkK2Jq7VLZ9XnQzJNs2zPYDwQ1U0youRjYc/MsakT//cjrPsXiP2C2RyXRcX9xHaf5WIiGfPMxbiwsrjDALCBuUARuFmNUQQ79oxGmnfWiq/8zjmcuOfHyxbTcP
 a10kcNni
 MpvccYqrr3aBSl03PG+2Jwh+tZSzhykgPjd+RPeZkCNEdTlCLH9KoYOGzWHEtNSaYskPpQFyqOk0iJ0F/ykkXXR/8VBQyAyHA+14mTsLNbc8uNgF4WJHiVz/CVV4eO+5xvkowRvyVcHD39ekByNyUIbWmqd/Xj3hTrIGm2coEoG7oXVEwyF1hqZTcAHCtDk66uBHpPLLfjpN2FnOdWRuhOD7ThQUK5dlf8ibL6jMw2mwSRlfHyHm06bmSvnIAueaJt4Ax7vLmk6jqQNoPdcBNA3P+jdttqEka+i/s1mbCIXAMjdtWuKPrIr1lr4KJwrqeXmupgptJHz9ynhrbLFEFxSsnPs8SLo9SE8Sl7LG+Txm6t5UyNGGGciU0Ez23gUHezLHml5XFHCqaHaiQOoj6eA/vvgf/+jEdsy2uYlrD0DjX1PDHiS4sq9EUEmu0y/pDV+johSxztvqWJRmUGCjiS/8qX7T3TgWM1XdfsnzRv+F7beLkRvWyYji2wWgEaLxAV7gdtorQBy+6KtH+3QSA+2C0MMEkuZzhqWMyauOLgCaiUWIivHStc8UI+g5vhbTaahI0zZmnz0IQrsXv6bVL0wr7uqIC1VStKXminASwD9xQIWehNay0Mb3Ulw==
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
 kernel/kexec_handover.c          | 278 ++++---------------------------
 kernel/kexec_handover_debug.c    | 218 ++++++++++++++++++++++++
 kernel/kexec_handover_internal.h |  44 +++++
 6 files changed, 311 insertions(+), 243 deletions(-)
 create mode 100644 kernel/kexec_handover_debug.c
 create mode 100644 kernel/kexec_handover_internal.h

diff --git a/MAINTAINERS b/MAINTAINERS
index fda151dbf229..ce0314af3bdf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13534,13 +13534,14 @@ KEXEC HANDOVER (KHO)
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
index 1224dd937df0..9968d3d4dd17 100644
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
index c60623448235..bfca6dfe335a 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
 obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUG) += kexec_handover_debug.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 2c22a9f3b278..a19d271721f7 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -10,7 +10,6 @@
 
 #include <linux/cma.h>
 #include <linux/count_zeros.h>
-#include <linux/debugfs.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
 #include <linux/libfdt.h>
@@ -27,6 +26,7 @@
  */
 #include "../mm/internal.h"
 #include "kexec_internal.h"
+#include "kexec_handover_internal.h"
 
 #define KHO_FDT_COMPATIBLE "kho-v1"
 #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
@@ -84,8 +84,6 @@ struct khoser_mem_chunk;
 
 struct kho_serialization {
 	struct page *fdt;
-	struct list_head fdt_list;
-	struct dentry *sub_fdt_dir;
 	struct kho_mem_track track;
 	/* First chunk of serialized preserved memory map */
 	struct khoser_mem_chunk *preserved_mem_map;
@@ -381,8 +379,8 @@ static void __init kho_mem_deserialize(const void *fdt)
  * area for early allocations that happen before page allocator is
  * initialized.
  */
-static struct kho_scratch *kho_scratch;
-static unsigned int kho_scratch_cnt;
+struct kho_scratch *kho_scratch;
+unsigned int kho_scratch_cnt;
 
 /*
  * The scratch areas are scaled by default as percent of memory allocated from
@@ -569,36 +567,24 @@ static void __init kho_reserve_scratch(void)
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
@@ -611,7 +597,8 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
  * by KHO for the new kernel to retrieve it after kexec.
  *
  * A debugfs blob entry is also created at
- * ``/sys/kernel/debug/kho/out/sub_fdts/@name``.
+ * ``/sys/kernel/debug/kho/out/sub_fdts/@name`` when kernel is configured with
+ * CONFIG_KEXEC_HANDOVER_DEBUG
  *
  * Return: 0 on success, error code on failure
  */
@@ -628,33 +615,10 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 	if (err)
 		return err;
 
-	return kho_debugfs_fdt_add(&ser->fdt_list, ser->sub_fdt_dir, name, fdt);
+	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-struct kho_out {
-	struct blocking_notifier_head chain_head;
-
-	struct dentry *dir;
-
-	struct mutex lock; /* protects KHO FDT finalization */
-
-	struct kho_serialization ser;
-	bool finalized;
-};
-
-static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
-	.lock = __MUTEX_INITIALIZER(kho_out.lock),
-	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
-		.track = {
-			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
-		},
-	},
-	.finalized = false,
-};
-
 int register_kho_notifier(struct notifier_block *nb)
 {
 	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
@@ -734,29 +698,6 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
 }
 EXPORT_SYMBOL_GPL(kho_preserve_phys);
 
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
@@ -809,7 +750,8 @@ int kho_abort(void)
 		goto unlock;
 
 	kho_out.finalized = false;
-	ret = kho_out_update_debugfs_fdt();
+
+	kho_debugfs_cleanup(&kho_out.dbg);
 
 unlock:
 	mutex_unlock(&kho_out.lock);
@@ -859,7 +801,7 @@ static int __kho_finalize(void)
 abort:
 	if (err) {
 		pr_err("Failed to convert KHO state tree: %d\n", err);
-		kho_abort();
+		__kho_abort();
 	}
 
 	return err;
@@ -884,119 +826,32 @@ int kho_finalize(void)
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
-
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
@@ -1040,56 +895,6 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
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
@@ -1104,27 +909,16 @@ static __init int kho_init(void)
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
index 000000000000..41e9616fcdd0
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
+struct kho_debugfs {}
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
2.50.1.565.gc32cd1483b-goog


