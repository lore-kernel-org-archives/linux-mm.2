Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9481BCCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:18:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A7E8E0009; Sat, 18 Oct 2025 13:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E26C58E0002; Sat, 18 Oct 2025 13:18:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C507C8E0009; Sat, 18 Oct 2025 13:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB37B8E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:18:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CE8413B14D
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:03 +0000 (UTC)
X-FDA: 84011892846.24.237381C
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7A036120004
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:18:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W0wQykTD;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760807881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfD7m0Wh+POyh2ZHFs2nL6OUvX1CR9CVkBCFctAX45k=;
	b=dtovmUNaBZH4O8KL9ZMRrgMzbtbaWHaHq7OYJztf4bM2NcuwdyL3yvUg5btZvlNYlC2meP
	Yn1WfIITllLo33renlrLpKzD82hr55FlALwg9Gz2xkA7+qDhEdCSosTzHWIfq5MBAZmgf3
	uQ8LpimC0sxvV2JbplDvJf9SUgXGOoE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=W0wQykTD;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf29.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760807881; a=rsa-sha256;
	cv=none;
	b=RPT1abfnNjG1YOoFAkaURbJ7TlY21lFM/hddNVguZCyW2UVHLXwoQ90M2CXZnaChCA5LpO
	J3CbsJTsqeRBDiLt/z/wyqEYHP0yTKPot2PMU0dimh5ndr7g9h5xSNSGCS7l3n3NFoQrTR
	tcJz35VlV+U02pPV6VtyKGidK8syXRo=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-78ea15d3489so35784096d6.3
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 10:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1760807880; x=1761412680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jfD7m0Wh+POyh2ZHFs2nL6OUvX1CR9CVkBCFctAX45k=;
        b=W0wQykTDOoYa7qmS0+y7b6WSGYsA8utZuY1u8u5W9BxEpavQAtKhTYDvDzPlTTYw8y
         Zw+XjCI1PXKA22zXmLd0qRwugPIbuAMx+77lhrrjR3CrTnWZUT4W4CFQ3WddFm7rqG9l
         0Kh5C2MhFhczqnP5cdMBBQJC56pDmMvFnUMFMrh+EqInx6lLl8Xu8pNbFcQ1ozptFyQE
         KNFHdfaKtc9SRRjDSodcosKFrugMSsiYwRWDJB484vnHpJVJoiEn8/OG3Ll8W2TaU0ag
         oRCf/yCS9+JxFu3RG0MV6E4gBMO9Zr3ibpzD4nEuTp7jGnKO4Ut2YUozyo7Bvs4cpIO/
         e/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760807880; x=1761412680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfD7m0Wh+POyh2ZHFs2nL6OUvX1CR9CVkBCFctAX45k=;
        b=UeQ2Ho4GRLrI/MM+K3NmKFZIrvp3XkaPyPb6Z7NTQcmHRXKbTDm4xWje5o0829A3cn
         YPC5SFRXFp1A965f0BXur8OblHaC4dUsLQ52d2vjWlUGOE3VN0q8CLg36/Dq9/MGk44c
         RePguqUQROid6nZnZz3DFnDzlsB/q2KNDUeEjW7M7cYJ1kk0Kwi2V47GQ4r/V09ErIqH
         g83yYTRsAe3hQfi1Jt3OfK5lip5Ld31y/PArKNghz/ytjQvU9Uorsa2dZA0NlH7pOB41
         RYu0BCpXcXfi2Iyaob+l1C+f6mGJdILDM/5LCaJ77zKMICUe2rBZZy7/mUzmZKj7gzDF
         ii0Q==
X-Forwarded-Encrypted: i=1; AJvYcCW+F4CO9mFdGf8C7LTzMe+0IoTvzBeIdJFUNoN8gxAqJnfHCzBp2p3J2LIkXDRB4OnW6z5gKNe3hw==@kvack.org
X-Gm-Message-State: AOJu0YyIdqopDC8IZb0V9FbSPfx3WqMHt4zllPmdgbFbfG6/DafF0y3v
	/b9CgJVhMs8qtzByloBuBrml8osWuvG3YKdv3EGlyHwT3WJ9TokIBj5z8o6T0bR0Srk=
X-Gm-Gg: ASbGnctXacoKWB+cQKCK3SDqPJG8VCksvkzKLTVloQzFFdUf1sQnLolUUEYtUk+CWvX
	E5UWaxvSSDzK2YSTdTeuan3Uthk6VYexPTIDFeYNhttPEHYBqQF3OYxBBmW307LU17kT9Qz4vtm
	bL8I9dfXx5CQMJx7O8ze7klTXCgOY/yK1TMfucAaCbeci2t7J9Bha++ws0HxOdEm6MFwgYS4LS7
	/PlUs/NTSzAGoU3t+I3hyb/et7iIKvFHc+a+BIVzSRIjEyvBGn/qh87zu5PUjxn/j2bKvwXB+ld
	aVBG0Y2TpGafIwYypl81gYUimBgATmZU47k7h6BPMX2BdBA6ml/eoh+emtNhDu1q+FDaRhj9wFT
	8Wt+09Gg3tjXN3xmK7oUwc7pDIV20hod2vm2jPX9ES//GaYIh3ok4em9qeA3qUrRXPItNb8YZFI
	/pzARY4/MWG1Ojl6bzk2YcPm1RX4mwPFRz+Njer46Uo19sEEOCKdbuvMTGMdWiCKRZhUfUSLxOO
	TbzYIHki7Lr1mrzC0zdo09zkX0Y7kfC
X-Google-Smtp-Source: AGHT+IGUmjXuUPhMdy4O9ccNuWprtdGQ/+tq/+k2LIxGLfXNhcxnux///dIcFzrpPBKzztNYEZUp8g==
X-Received: by 2002:ad4:5d61:0:b0:856:d1d4:d127 with SMTP id 6a1803df08f44-87c2054ebaamr126459036d6.4.1760807880415;
        Sat, 18 Oct 2025 10:18:00 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87d02d8e909sm18478116d6.62.2025.10.18.10.17.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 10:17:59 -0700 (PDT)
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
Subject: [PATCH v6 02/10] kho: make debugfs interface optional
Date: Sat, 18 Oct 2025 13:17:48 -0400
Message-ID: <20251018171756.1724191-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.915.g61a8936c21-goog
In-Reply-To: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
References: <20251018171756.1724191-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7A036120004
X-Rspamd-Server: rspam03
X-Stat-Signature: ron57hsg8gdrjc8qikn34nmquskfmdxg
X-HE-Tag: 1760807881-185688
X-HE-Meta: U2FsdGVkX1++DvyBHIHYy9F43V/cSaBw2JpH2DcNoG0WHwjKrzUOQ/RYQycIxZxi0M+34AH6tE+D7ecCa73wemsr95NDU1xJoXnXU71qY/0o7b/o1TCSZ4fs81zxlFwWw/qFZ1ra7yqndzx8gT9TnqpAHJpohY0UWf0flccXRiWCgsXR8BmrKuxJQEe8JJS5ZZKwOD5yqY4bmVP2DnRRcGyJeM5cfQQiKE9LcNBxd79tmLVkQrnuVtLxQPKVwU8IhQf+pnHf4Yk2jOZ1EievT/YRvmVNA4AJCh/u5UF8HBZQPfzG9y4VMnEfP+l+uKHdC5xAalG9YeCoQwGwz2VPSB4fhPZZ5bOgufa2pUvswzg02gV8rWBoesCQGGCSeUK38OLc+8waFG++vpiZxYrV1A/lskvwZ27LL0RZldK7v00g5mtkMaw8sb84e53XPs62BV3vqamRvkDBOOiqj74BcNKRI/joQjS70TUzTop8I69xBfGOnG+AdB5FrAxHcA4y9Bbv4Rr1pzw9OgafNty//TfPbrkiL5fmMQww6dG/b1V6Nuy2ppPDQcTa4uiBjwvANl3cCkwuaH4n85dg5ZDBreQQTB3EC57X6fMwZQriLtFNvynaDg1vKU5MkIkghHhw/CvcKI6MHLncwSxE0nMRyxAqCsVLL80JJa4SLzE1ft60PL1f9HkNJAw11zcEf8w04+1wFi9hK94SIpemqs9mE/WQrDxUxdNyo4yTe6GCuQb1Q278IVDUAeDvY3UtHWR4LLeCrYmk5Jl8FXaENEbRQU/g474CuIrdJPNBGhPv/LNMprK1A79gkmeDTGS47i3wiFOjKxZ6g1qXevCgjR5y0TOZbTWei7MsPPax2UiPqbdU8FvVLgA4ijbAEs619+hIDOjbcVDgnnT/dcXTg2ejxw2bV0Gl8PgPuUcZfOPIV8o39aU/dL1ewcspqeMb4pd4nJWe92cBD3gwdpcAtxV
 ZfNwl3NU
 m3WkW61BWYYRsegFCVMgitXhrILw4adwFEFNtdVFeEWiGgZEPz8U7s9mFqjYzBSqnUGSaZb8LdtB6/gesnaYGDnw+un6CsK5HrkKGGeyXmSqLaM9pynPUIdERxoi9gel/mMpbSsbPhKfDEtx1VfEpAYohJvpDkGKTP6CKwpeDGc2OlE23o98vfOSLRFJggobR00gJ3/4GFOBGr82AK3DjsSPuNgMH/OvZ1PUDlCPkaeIeqz7M4rH53yEeGDSGvXAClQnVR1yzaX0gUrodhM9s+sn03upUPcyvXFkAojEgH515bT+fCS19J071KrV7TqFyGN6nLMVDMSMwiqJGarurrEgbo/l47Bw3nfLLdT04JPTG8XLh0VO8dIsSOtfJ8CaH2fClYcl6aUq6olMON2GLnTOjKbdGFGXh9t0wjkwlhf2PuIDov6Zq74ruY6r8TTqHUj0hrLSTuI+/r0RgxCtua08FrVNPVzdd1dZS+jZiH2g4KmhcupulPIEk0o4WRBwgRoOYq/Du3MT341s=
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

Add a separate config CONFIG_KEXEC_HANDOVER_DEBUGFS that enables
the debugfs interface, and allows to inspect the tree.

Move all debugfs related code to a new file to keep the .c files
clear of ifdefs.

Co-developed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS                           |   3 +-
 kernel/Kconfig.kexec                  |  10 ++
 kernel/Makefile                       |   1 +
 kernel/kexec_handover.c               | 223 +++-----------------------
 kernel/kexec_handover_debugfs.c       | 213 ++++++++++++++++++++++++
 kernel/kexec_handover_internal.h      |  44 +++++
 tools/testing/selftests/kho/vmtest.sh |   1 +
 7 files changed, 290 insertions(+), 205 deletions(-)
 create mode 100644 kernel/kexec_handover_debugfs.c
 create mode 100644 kernel/kexec_handover_internal.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 545a4776795e..54f627a639b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13775,13 +13775,14 @@ KEXEC HANDOVER (KHO)
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
index 422270d64820..03c3aa6263d3 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -109,6 +109,16 @@ config KEXEC_HANDOVER
 	  to keep data or state alive across the kexec. For this to work,
 	  both source and target kernels need to have this option enabled.
 
+config KEXEC_HANDOVER_DEBUGFS
+	bool "kexec handover debugfs interface"
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
index df3dd8291bb6..06bfe691439b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -83,6 +83,7 @@ obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_KEXEC_FILE) += kexec_file.o
 obj-$(CONFIG_KEXEC_ELF) += kexec_elf.o
 obj-$(CONFIG_KEXEC_HANDOVER) += kexec_handover.o
+obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS) += kexec_handover_debugfs.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup/
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76c34ea923f0..f3627430b3c3 100644
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
@@ -110,20 +108,16 @@ struct kho_serialization {
 
 struct kho_out {
 	struct blocking_notifier_head chain_head;
-
-	struct dentry *dir;
-
 	struct mutex lock; /* protects KHO FDT finalization */
-
 	struct kho_serialization ser;
 	bool finalized;
+	struct kho_debugfs dbg;
 };
 
 static struct kho_out kho_out = {
 	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
 	.lock = __MUTEX_INITIALIZER(kho_out.lock),
 	.ser = {
-		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
 		.track = {
 			.orders = XARRAY_INIT(kho_out.ser.track.orders, 0),
 		},
@@ -465,8 +459,8 @@ static void __init kho_mem_deserialize(const void *fdt)
  * area for early allocations that happen before page allocator is
  * initialized.
  */
-static struct kho_scratch *kho_scratch;
-static unsigned int kho_scratch_cnt;
+struct kho_scratch *kho_scratch;
+unsigned int kho_scratch_cnt;
 
 /*
  * The scratch areas are scaled by default as percent of memory allocated from
@@ -662,37 +656,6 @@ static void __init kho_reserve_scratch(void)
 	kho_enable = false;
 }
 
-struct fdt_debugfs {
-	struct list_head list;
-	struct debugfs_blob_wrapper wrapper;
-	struct dentry *file;
-};
-
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
-
 /**
  * kho_add_subtree - record the physical address of a sub FDT in KHO root tree.
  * @ser: serialization control object passed by KHO notifiers.
@@ -704,7 +667,8 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
  * by KHO for the new kernel to retrieve it after kexec.
  *
  * A debugfs blob entry is also created at
- * ``/sys/kernel/debug/kho/out/sub_fdts/@name``.
+ * ``/sys/kernel/debug/kho/out/sub_fdts/@name`` when kernel is configured with
+ * CONFIG_KEXEC_HANDOVER_DEBUGFS
  *
  * Return: 0 on success, error code on failure
  */
@@ -721,7 +685,7 @@ int kho_add_subtree(struct kho_serialization *ser, const char *name, void *fdt)
 	if (err)
 		return err;
 
-	return kho_debugfs_fdt_add(&ser->fdt_list, ser->sub_fdt_dir, name, fdt);
+	return kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false);
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
@@ -1044,29 +1008,6 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
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
@@ -1116,8 +1057,9 @@ int kho_abort(void)
 		return ret;
 
 	kho_out.finalized = false;
+	kho_debugfs_cleanup(&kho_out.dbg);
 
-	return kho_out_update_debugfs_fdt();
+	return 0;
 }
 
 static int __kho_finalize(void)
@@ -1186,89 +1128,23 @@ int kho_finalize(void)
 
 	kho_out.finalized = true;
 
-	return kho_out_update_debugfs_fdt();
-}
-
-static int kho_out_finalize_get(void *data, u64 *val)
-{
-	mutex_lock(&kho_out.lock);
-	*val = kho_out.finalized;
-	mutex_unlock(&kho_out.lock);
-
-	return 0;
-}
-
-static int kho_out_finalize_set(void *data, u64 _val)
-{
-	return (!!_val) ? kho_finalize() : kho_abort();
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
+	return kho_debugfs_fdt_add(&kho_out.dbg, "fdt",
+				   page_to_virt(kho_out.ser.fdt), true);
 }
-DEFINE_SHOW_ATTRIBUTE(scratch_len);
 
-static __init int kho_out_debugfs_init(void)
+bool kho_finalized(void)
 {
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
+	guard(mutex)(&kho_out.lock);
+	return kho_out.finalized;
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
@@ -1332,56 +1208,6 @@ int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
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
@@ -1396,27 +1222,16 @@ static __init int kho_init(void)
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
 
diff --git a/kernel/kexec_handover_debugfs.c b/kernel/kexec_handover_debugfs.c
new file mode 100644
index 000000000000..96fb9afd8af6
--- /dev/null
+++ b/kernel/kexec_handover_debugfs.c
@@ -0,0 +1,213 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kexec_handover_debugfs.c - kexec handover debugfs interfaces
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
+	return (!!_val) ? kho_finalize() : kho_abort();
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
index 000000000000..042c189af768
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
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
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
+#ifdef CONFIG_KEXEC_HANDOVER_DEBUGFS
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
+#endif /* CONFIG_KEXEC_HANDOVER_DEBUGFS */
+
+#endif /* LINUX_KEXEC_HANDOVER_INTERNAL_H */
diff --git a/tools/testing/selftests/kho/vmtest.sh b/tools/testing/selftests/kho/vmtest.sh
index 3f6c17166846..49fdac8e8b15 100755
--- a/tools/testing/selftests/kho/vmtest.sh
+++ b/tools/testing/selftests/kho/vmtest.sh
@@ -59,6 +59,7 @@ function build_kernel() {
 	tee "$kconfig" > "$kho_config" <<EOF
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_KEXEC_HANDOVER=y
+CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_TEST_KEXEC_HANDOVER=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_VM=y
-- 
2.51.0.915.g61a8936c21-goog


