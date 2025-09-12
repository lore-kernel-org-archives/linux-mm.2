Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 536A7CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24736B0029; Fri, 12 Sep 2025 11:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFBD28E0002; Fri, 12 Sep 2025 11:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EAD16B00A4; Fri, 12 Sep 2025 11:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A58D6B0029
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5835513BDCE
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:07 +0000 (UTC)
X-FDA: 83880933654.27.A36EAD9
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 766BB1C0010
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=U20eHk9r;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ltLVlonCLmXqCMj5NKS1dwyzuNto475BJCWDW4VinA=;
	b=Mlaij8vsNpr9li7YWAGm2l0akyU0ciCjmTeZf9XbZTdXp+qHIVNQH5t9q54c9UW/U5FSL7
	hDKRZ6+1pyBZTSZlTuPgilO8x1lwdVedW9iFP6XhFSMufpP2RQ/w5+aIB7yb+PE0OtPenO
	Bd3odgJDHPPljO/xTV3rUnSDJc7U+OI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689805; a=rsa-sha256;
	cv=none;
	b=z8bgl6hu/syEwihxh+wWB4MrTDXrIDF+eir0B0m1hlUayNvtYmU1VKWkNn08O7aLKRx/jp
	pIGobuudNm0Snr4SrGbfuqm+zYTXThMfjK0FlLA8TpJDzs8cl/BuQlei0y1UOs018envY1
	ZwuX/G/NUzL7wTLm6JWiK4RBMgG6aGU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=U20eHk9r;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.182 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-723ad237d1eso18638667b3.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689804; x=1758294604; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ltLVlonCLmXqCMj5NKS1dwyzuNto475BJCWDW4VinA=;
        b=U20eHk9r3Gv8hKtpFgfQaMNt0z4wa/W6Oc3eQelM6CzoV+meoELmETZF0gMcNBa2kb
         Y/weMBMLsBQMC3zF1JYQNQ25Zon7Ojeejh4foDo4/6bf4YCKYyOBINbBku+i2WJVrQ90
         CPdB7QLh+4XdLPYb663hK/gGRHoPxrDDq+Xjtw4djwE+iOW0qMfZlVgGESonm9LUVvFB
         UJa7v2uDKOfPqINRnWdMyuV6m5FhCEpoXw3L9IrKEs+COg3BdDHSEG8xEBG0ZWtTniy4
         0mIqS+Iz3jemB4guc2YB33Sfzs6Tlnwkyt50T7KNR5izbXF80qe/cST+LIxZzYfq6wrn
         c2OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689804; x=1758294604;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ltLVlonCLmXqCMj5NKS1dwyzuNto475BJCWDW4VinA=;
        b=kmHg+LEhlZ7CnVAI4ERJuuz7j9eNpwB+Eo8DKV9pcwg0SE5zDesno+8qX69AJ5TMMa
         d9zTkNusMbJqVHR6Z70YOGB6d8vPD4wJUvFMY3GxveGgLXlS6vUno8dEDMAFr3C5n1ES
         K8OyuKZv/9treXomEhGDfNakRGI8xUOOkV3VRreE5epZ1oKpsTm2plYTwpHcA6UrPU77
         vW6Qi/YXiUwRQJIw8zJyYy+BYgqSJrwosdonEx8nIHW9Lvq8ECXXh0Gu8vngq66iZmHq
         XWYWWwi6YX4c5yspgtLEio1JxZSmcOczcMz791q8FPOcj9mKhSJEDWDCFJzqAQ+Anglo
         OZ4A==
X-Forwarded-Encrypted: i=1; AJvYcCXmt8tiY4mfBSRqPbhRdy0E1F4s+Q6ptzTKgnbJRLU6CNtuh/w6DyAl8t7/3ONdKB2RF8aHm1RzeA==@kvack.org
X-Gm-Message-State: AOJu0YymMocrskQTeHPib7flypug7z9bq/V9YhEAXQV/V34sASiD5/ft
	OVtUfWqv/AX/shG5H7VEr+BlMGG9o5XUxXAhYob7R1/Cq95WvzMnCvilHVGJIABMePE=
X-Gm-Gg: ASbGncuBu97oUbOPXuYZ/D1R+PnKaSC3rtAiBxmJI30XygCaM8UFOk79OwY8a1Wd6LD
	0XnzdDvIXqN1hOwK09QfSBq1p56AQLtxjsO8SXYbzyhfkJkjyL9lG9MD6ma0dSzrUYP5tKuIgjV
	23Kex1ByENXJkSD9WZY2OmCn/tMqPAJvl1oUqL1zki0BW6UN3eXBlYVcbd/72XfHWGpy8ykF5fC
	R+g79cEGVzH899SGuJOdarSDNin262pIkKM7bLDx99FxGbos92BkxYmCeYS7AfoGFdtUdQ/C906
	WSU7cwpoJWNka0m79Doi/Z5Elu6cX24BMurEU8033yHfJaEiPyj4VL94SI5fsBuPvA0ms2Vk3BT
	+WkuvZ1bTamdwxRanHI2/OqcnZ9QmDUZYMyvs3jWs0Cxr
X-Google-Smtp-Source: AGHT+IErKNSDF6fGSUxu7uTin3OwoIqA+uAqwoNBYvN/bvRQQvIrBcXKk9r6zS33h/brxBiiTlCCzQ==
X-Received: by 2002:a05:690c:7442:b0:725:74c3:75eb with SMTP id 00721157ae682-73065da8ef0mr33696617b3.54.1757689804212;
        Fri, 12 Sep 2025 08:10:04 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:03 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 03/16] kmemdump: Add coreimage ELF layer
Date: Fri, 12 Sep 2025 18:08:42 +0300
Message-ID: <20250912150855.2901211-4-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 766BB1C0010
X-Stat-Signature: 9jwdmgzttzsxpcg6tn3sfu7wiq4z43gf
X-Rspam-User: 
X-HE-Tag: 1757689805-409514
X-HE-Meta: U2FsdGVkX1/oK0o3ktJr/ENgg0fnjR5IucHuLO7xfVfbRGn7ayZDRVeXw06owrePl4/xdvamUZxufu/+kJIu+xATmYJK1w3xIFADmXLkJ/IsQrMOj1L2jigE8pQrTAgb6XzTzR5tFyZcX3oscZ3xsUQgeQiJhPrHXbvubIjVtl2KmWugEfhlFjnb41htZzVYbEx70qq69Q/wgDMceEzH7c/MnTjPB/7tLs0tYFWByK08oTDUwTh7p8vR82cizCDZxGmdxCCxJV7zK+CXEEJ/lG5PMTJVVwRi0/Qud8q89cGGRZHjpyKuq7Ocq/6itvMnwVfRa5NXiWsWQKwjTcTtAXbPDSGo2b7nViXV2CSxL/ENQT/pTcpGgu/NLh5tqtXOo4juwaiAFjnwopcuCtD0+6eSuEsN6IYxss4qTv3m2hsR2eXYAmLG1Y+aKl3+6oNi2dVA7dG1yyKzICaFOF9h2eOa2JK1YbEnfKa5mgkjMwZUWfL5Ek54imLOEBh3vid1Mc+V3LwLD9Cu2UKEdD/kCXgQ2UmPTDyGambitBp/McbtRPS3LKb/a1XNd9OF84QgTDYGRXIESfuVubZdpUNm9rFyVfXIT1T+VJU7hx1fV+sniKpfJ2zfJ+oqmNlNJy4QZ19Ns/tnmLa4Ehp+GyHGWdh2D1N6YI2djSOJedt7bSnrQoMRxkBptMAUZp3mS1D4lfdCZf2GRc2uWSIlVzJelTJ9AOo0Y5Yxm0j6CEkJt0zeSCbxsvBcDg2xvnF0V/bsndCwIPe27f2l47yGL4reJtun0XKF2Dm8eBUGXkPcdTTKOnsmXnrf1Qmphpb9cfWgh6hADwXzRVA1ulw55B3hNhGPT/XrOwn38e4SmdmT/N++4bOK11NJaSq1PZOZmjdj4klSga3wJiDD601BoKoJSe/ZGQftUILFvXAq59c2RSAWB1WbCg6MPKGaQ6kMq2xOeilI80iEu+WZ4qWzsDl
 wzTY2VUX
 229/x3Qlz46Acw6p7MMtyY5VY9LH+ZoY8D0wx8HPR/bwYK8DS1fYU259BVTd82g5Guajn/bIrHeQfUmYleeBNl6s/zM6hyDXEIBiXjdVnykp4UKW/175aDIORLOYccQPGabHAWmOLjVkGsVMTBwzTLzLOn2270w0Z++AHZWf+tegD6i0kELNMkErqqBe2igA2uGBMXJwGoqDSZ8I9oSiwqpdHSJDk5aKHBqvNJgOey6gI1I5yd7k3WOC4yFbi7wzOa3FE3h7N8t1QUep7FwdY3uL7CQdKtxhS7AdPxwwY1F6/RkZBVO/KDqav4BlC1kbacDlgmUGcBVRaV+ZKagZXVOxglXT72puBFvtMq2l4Le8AIPgkhUWKQmeqC7M+P/bDicgTzGI+KV2pUC7viO23V197ROJyW4bGgJUkLVTQjdeiD2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement kmemdumping into an ELF coreimage.
With this feature enabled, kmemdump will assemble all the regions
into a coreimage, by having an initial first region with an ELF header,
a second region with vmcoreinfo data, and then register vital kernel
information in the subsequent regions.
This image can then be dumped, assembled into a single file and loaded
into debugging tools like crash/gdb.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 MAINTAINERS                      |   1 +
 include/linux/kmemdump.h         |  67 ++++++++++
 mm/kmemdump/Kconfig.debug        |  18 ++-
 mm/kmemdump/Makefile             |   1 +
 mm/kmemdump/kmemdump.c           |  32 +++++
 mm/kmemdump/kmemdump_coreimage.c | 222 +++++++++++++++++++++++++++++++
 6 files changed, 339 insertions(+), 2 deletions(-)
 create mode 100644 mm/kmemdump/kmemdump_coreimage.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 974f43c3902b..fc8cd34cf190 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13816,6 +13816,7 @@ S:	Maintained
 F:	Documentation/dev-tools/kmemdump.rst
 F:	include/linux/kmemdump.h
 F:	mm/kmemdump/kmemdump.c
+F:	mm/kmemdump/kmemdump_coreimage.c
 
 KMEMLEAK
 M:	Catalin Marinas <catalin.marinas@arm.com>
diff --git a/include/linux/kmemdump.h b/include/linux/kmemdump.h
index 8e764bb2d8ac..ac2eb1b4ba06 100644
--- a/include/linux/kmemdump.h
+++ b/include/linux/kmemdump.h
@@ -4,6 +4,52 @@
 
 enum kmemdump_uid {
 	KMEMDUMP_ID_START = 0,
+	KMEMDUMP_ID_COREIMAGE_ELF,
+	KMEMDUMP_ID_COREIMAGE_VMCOREINFO,
+	KMEMDUMP_ID_COREIMAGE_CONFIG,
+	KMEMDUMP_ID_COREIMAGE_MEMSECT,
+	KMEMDUMP_ID_COREIMAGE__totalram_pages,
+	KMEMDUMP_ID_COREIMAGE___cpu_possible_mask,
+	KMEMDUMP_ID_COREIMAGE___cpu_present_mask,
+	KMEMDUMP_ID_COREIMAGE___cpu_online_mask,
+	KMEMDUMP_ID_COREIMAGE___cpu_active_mask,
+	KMEMDUMP_ID_COREIMAGE_jiffies_64,
+	KMEMDUMP_ID_COREIMAGE_linux_banner,
+	KMEMDUMP_ID_COREIMAGE_nr_threads,
+	KMEMDUMP_ID_COREIMAGE_nr_irqs,
+	KMEMDUMP_ID_COREIMAGE_tainted_mask,
+	KMEMDUMP_ID_COREIMAGE_taint_flags,
+	KMEMDUMP_ID_COREIMAGE_mem_section,
+	KMEMDUMP_ID_COREIMAGE_node_data,
+	KMEMDUMP_ID_COREIMAGE_node_states,
+	KMEMDUMP_ID_COREIMAGE___per_cpu_offset,
+	KMEMDUMP_ID_COREIMAGE_nr_swapfiles,
+	KMEMDUMP_ID_COREIMAGE_init_uts_ns,
+	KMEMDUMP_ID_COREIMAGE_printk_rb_static,
+	KMEMDUMP_ID_COREIMAGE_printk_rb_dynamic,
+	KMEMDUMP_ID_COREIMAGE_prb,
+	KMEMDUMP_ID_COREIMAGE_prb_descs,
+	KMEMDUMP_ID_COREIMAGE_prb_infos,
+	KMEMDUMP_ID_COREIMAGE_prb_data,
+	KMEMDUMP_ID_COREIMAGE_runqueues,
+	KMEMDUMP_ID_COREIMAGE_high_memory,
+	KMEMDUMP_ID_COREIMAGE_init_mm,
+	KMEMDUMP_ID_COREIMAGE_init_mm_pgd,
+	KMEMDUMP_ID_COREIMAGE__sinittext,
+	KMEMDUMP_ID_COREIMAGE__einittext,
+	KMEMDUMP_ID_COREIMAGE__end,
+	KMEMDUMP_ID_COREIMAGE__text,
+	KMEMDUMP_ID_COREIMAGE__stext,
+	KMEMDUMP_ID_COREIMAGE__etext,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_num_syms,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_relative_base,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_offsets,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_names,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_token_table,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_token_index,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_markers,
+	KMEMDUMP_ID_COREIMAGE_kallsyms_seqs_of_names,
+	KMEMDUMP_ID_COREIMAGE_swapper_pg_dir,
 	KMEMDUMP_ID_USER_START,
 	KMEMDUMP_ID_USER_END,
 	KMEMDUMP_ID_NO_ID,
@@ -60,4 +106,25 @@ static inline void kmemdump_unregister(enum kmemdump_uid id)
 }
 #endif
 
+#ifdef CONFIG_KMEMDUMP
+#ifdef CONFIG_KMEMDUMP_COREIMAGE
+int init_elfheader(void);
+void update_elfheader(const struct kmemdump_zone *z);
+int clear_elfheader(const struct kmemdump_zone *z);
+#else
+static inline int init_elfheader(void)
+{
+	return 0;
+}
+
+static inline void update_elfheader(const struct kmemdump_zone *z)
+{
+}
+
+static inline int clear_elfheader(const struct kmemdump_zone *z)
+{
+	return 0;
+}
+#endif
+#endif
 #endif
diff --git a/mm/kmemdump/Kconfig.debug b/mm/kmemdump/Kconfig.debug
index 5654180141c0..f62bde50a81b 100644
--- a/mm/kmemdump/Kconfig.debug
+++ b/mm/kmemdump/Kconfig.debug
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
-config KMEMDUMP
-	bool "KMEMDUMP: Allow the kernel to register memory regions for dumping purpose"
+menuconfig KMEMDUMP
+	bool "KMEMDUMP: Register memory regions for dumping purpose"
 	help
 	  Kmemdump mechanism allows any driver to mark a specific memory area
 	  for later dumping/debugging purpose, depending on the functionality
@@ -12,3 +12,17 @@ config KMEMDUMP
 
 	  Note that modules using this feature must be rebuilt if option
 	  changes.
+
+config KMEMDUMP_COREIMAGE
+	depends on KMEMDUMP
+	select VMCORE_INFO
+	bool "Assemble memory regions into a coredump readable with debuggers"
+	help
+	  Enabling this will assemble all the memory regions into a
+	  core ELF file. The first region will include program headers for
+	  all the regions. The second region is the vmcoreinfo and specific
+	  coredump structures.
+	  All the other regions follow. Specific kernel variables required
+	  for debug tools are being registered.
+	  The coredump file can then be loaded into GDB or crash  tool and
+	  further inspected.
diff --git a/mm/kmemdump/Makefile b/mm/kmemdump/Makefile
index f5b917a6ef5e..eed67f15a8d0 100644
--- a/mm/kmemdump/Makefile
+++ b/mm/kmemdump/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-y += kmemdump.o
+obj-$(CONFIG_KMEMDUMP_COREIMAGE) += kmemdump_coreimage.o
diff --git a/mm/kmemdump/kmemdump.c b/mm/kmemdump/kmemdump.c
index c016457620a4..3827b0597cac 100644
--- a/mm/kmemdump/kmemdump.c
+++ b/mm/kmemdump/kmemdump.c
@@ -28,6 +28,32 @@ static const struct kmemdump_backend kmemdump_default_backend = {
 static const struct kmemdump_backend *backend = &kmemdump_default_backend;
 static DEFINE_MUTEX(kmemdump_lock);
 static struct kmemdump_zone kmemdump_zones[MAX_ZONES];
+static bool kmemdump_initialized;
+
+static int __init init_kmemdump(void)
+{
+	enum kmemdump_uid uid;
+
+	init_elfheader();
+
+	mutex_lock(&kmemdump_lock);
+	/*
+	 * Some regions may have been registered very early.
+	 * Update the elf header for all existing regions,
+	 * except for KMEMDUMP_ID_COREIMAGE_ELF and
+	 * KMEMDUMP_ID_COREIMAGE_VMCOREINFO, those are included in the
+	 * ELF header upon its creation.
+	 */
+	for (uid = KMEMDUMP_ID_COREIMAGE_CONFIG; uid < MAX_ZONES; uid++)
+		if (kmemdump_zones[uid].id)
+			update_elfheader(&kmemdump_zones[uid]);
+
+	kmemdump_initialized = true;
+	mutex_unlock(&kmemdump_lock);
+
+	return 0;
+}
+late_initcall(init_kmemdump);
 
 /**
  * kmemdump_register_id() - Register region into kmemdump with given ID.
@@ -83,6 +109,9 @@ int kmemdump_register_id(enum kmemdump_uid req_id, void *zone, size_t size)
 	z->size = size;
 	z->id = uid;
 
+	if (kmemdump_initialized)
+		update_elfheader(z);
+
 	mutex_unlock(&kmemdump_lock);
 
 	return uid;
@@ -110,6 +139,9 @@ void kmemdump_unregister(enum kmemdump_uid id)
 
 	backend->unregister_region(backend, z->id);
 
+	if (kmemdump_initialized)
+		clear_elfheader(z);
+
 	memset(z, 0, sizeof(*z));
 
 	mutex_unlock(&kmemdump_lock);
diff --git a/mm/kmemdump/kmemdump_coreimage.c b/mm/kmemdump/kmemdump_coreimage.c
new file mode 100644
index 000000000000..a7b51a171d8e
--- /dev/null
+++ b/mm/kmemdump/kmemdump_coreimage.c
@@ -0,0 +1,222 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/io.h>
+#include <linux/elfcore.h>
+#include <linux/kmemdump.h>
+#include <linux/vmcore_info.h>
+
+#define CORE_STR "CORE"
+
+#define MAX_NUM_ENTRIES	201
+
+static struct elfhdr *ehdr;
+static size_t elf_offset;
+
+static void append_kcore_note(char *notes, size_t *i, const char *name,
+			      unsigned int type, const void *desc,
+			      size_t descsz)
+{
+	struct elf_note *note = (struct elf_note *)&notes[*i];
+
+	note->n_namesz = strlen(name) + 1;
+	note->n_descsz = descsz;
+	note->n_type = type;
+	*i += sizeof(*note);
+	memcpy(&notes[*i], name, note->n_namesz);
+	*i = ALIGN(*i + note->n_namesz, 4);
+	memcpy(&notes[*i], desc, descsz);
+	*i = ALIGN(*i + descsz, 4);
+}
+
+static void append_kcore_note_nodesc(char *notes, size_t *i, const char *name,
+				     unsigned int type, size_t descsz)
+{
+	struct elf_note *note = (struct elf_note *)&notes[*i];
+
+	note->n_namesz = strlen(name) + 1;
+	note->n_descsz = descsz;
+	note->n_type = type;
+	*i += sizeof(*note);
+	memcpy(&notes[*i], name, note->n_namesz);
+	*i = ALIGN(*i + note->n_namesz, 4);
+}
+
+static struct elf_phdr *elf_phdr_entry_addr(struct elfhdr *ehdr, int idx)
+{
+	struct elf_phdr *ephdr = (struct elf_phdr *)((size_t)ehdr + ehdr->e_phoff);
+
+	return &ephdr[idx];
+}
+
+/**
+ * clear_elfheader() - Remove the program header for a specific memory zone
+ * @z: pointer to the kmemdump zone
+ *
+ * Return: On success, it returns 0, errno otherwise
+ */
+int clear_elfheader(const struct kmemdump_zone *z)
+{
+	struct elf_phdr *phdr;
+	struct elf_phdr *tmp_phdr;
+	unsigned int phidx;
+	unsigned int i;
+
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		phdr = elf_phdr_entry_addr(ehdr, i);
+		if (phdr->p_paddr == virt_to_phys(z->zone) &&
+		    phdr->p_memsz == ALIGN(z->size, 4))
+			break;
+	}
+
+	if (i == ehdr->e_phnum) {
+		pr_debug("Cannot find program header entry in elf\n");
+		return -EINVAL;
+	}
+
+	phidx = i;
+
+	/* Clear program header */
+	tmp_phdr = elf_phdr_entry_addr(ehdr, phidx);
+	for (i = phidx; i < ehdr->e_phnum - 1; i++) {
+		tmp_phdr = elf_phdr_entry_addr(ehdr, i + 1);
+		phdr = elf_phdr_entry_addr(ehdr, i);
+		memcpy(phdr, tmp_phdr, sizeof(*phdr));
+		phdr->p_offset = phdr->p_offset - ALIGN(z->size, 4);
+	}
+	memset(tmp_phdr, 0, sizeof(*tmp_phdr));
+	ehdr->e_phnum--;
+
+	elf_offset -= ALIGN(z->size, 4);
+
+	return 0;
+}
+
+/**
+ * update_elfheader() - Add the program header for a specific memory zone
+ * @z: pointer to the kmemdump zone
+ *
+ * Return: None
+ */
+void update_elfheader(const struct kmemdump_zone *z)
+{
+	struct elf_phdr *phdr;
+
+	phdr = elf_phdr_entry_addr(ehdr, ehdr->e_phnum++);
+
+	phdr->p_type = PT_LOAD;
+	phdr->p_offset = elf_offset;
+	phdr->p_vaddr = (elf_addr_t)z->zone;
+	phdr->p_paddr = (elf_addr_t)virt_to_phys(z->zone);
+	phdr->p_filesz = phdr->p_memsz = ALIGN(z->size, 4);
+	phdr->p_flags = PF_R | PF_W;
+
+	elf_offset += ALIGN(z->size, 4);
+}
+
+/**
+ * init_elfheader() - Prepare coreinfo elf header
+ *		This function prepares the elf header for the coredump image.
+ *		Initially there is a single program header for the elf NOTE.
+ *		The note contains the usual core dump information, and the
+ *		vmcoreinfo.
+ *
+ * Return: 0 on success, errno otherwise
+ */
+int init_elfheader(void)
+{
+	struct elf_phdr *phdr;
+	void *notes;
+	unsigned int elfh_size;
+	unsigned int phdr_off;
+	size_t note_len, i = 0;
+
+	struct elf_prstatus prstatus = {};
+	struct elf_prpsinfo prpsinfo = {
+		.pr_sname = 'R',
+		.pr_fname = "vmlinux",
+	};
+
+	/*
+	 * Header buffer contains:
+	 * ELF header, Note entry with PR status, PR ps info, and vmcoreinfo
+	 * MAX_NUM_ENTRIES Program headers,
+	 */
+	elfh_size = sizeof(*ehdr);
+	elfh_size += sizeof(struct elf_prstatus);
+	elfh_size += sizeof(struct elf_prpsinfo);
+	elfh_size += sizeof(VMCOREINFO_NOTE_NAME);
+	elfh_size += ALIGN(vmcoreinfo_size, 4);
+	elfh_size += (sizeof(*phdr)) * (MAX_NUM_ENTRIES);
+
+	elfh_size = ALIGN(elfh_size, 4);
+
+	/* Never freed */
+	ehdr = kzalloc(elfh_size, GFP_KERNEL);
+	if (!ehdr)
+		return -ENOMEM;
+
+	/* Assign Program headers offset, it's right after the elf header. */
+	phdr = (struct elf_phdr *)(ehdr + 1);
+	phdr_off = sizeof(*ehdr);
+
+	memcpy(ehdr->e_ident, ELFMAG, SELFMAG);
+	ehdr->e_ident[EI_CLASS] = ELF_CLASS;
+	ehdr->e_ident[EI_DATA] = ELF_DATA;
+	ehdr->e_ident[EI_VERSION] = EV_CURRENT;
+	ehdr->e_ident[EI_OSABI] = ELF_OSABI;
+	ehdr->e_type = ET_CORE;
+	ehdr->e_machine  = ELF_ARCH;
+	ehdr->e_version = EV_CURRENT;
+	ehdr->e_ehsize = sizeof(*ehdr);
+	ehdr->e_phentsize = sizeof(*phdr);
+
+	elf_offset = elfh_size;
+
+	notes = (void *)(((char *)ehdr) + elf_offset);
+
+	/* we have a single program header now */
+	ehdr->e_phnum = 1;
+
+	/* Length of the note is made of :
+	 * 3 elf notes structs (prstatus, prpsinfo, vmcoreinfo)
+	 * 3 notes names (2 core strings, 1 vmcoreinfo name)
+	 * sizeof each note
+	 */
+	note_len = (3 * sizeof(struct elf_note) +
+		    2 * ALIGN(sizeof(CORE_STR), 4) +
+		    VMCOREINFO_NOTE_NAME_BYTES +
+		    ALIGN(sizeof(struct elf_prstatus), 4) +
+		    ALIGN(sizeof(struct elf_prpsinfo), 4) +
+		    ALIGN(vmcoreinfo_size, 4));
+
+	phdr->p_type = PT_NOTE;
+	phdr->p_offset = elf_offset;
+	phdr->p_filesz = note_len;
+
+	/* advance elf offset */
+	elf_offset += note_len;
+
+	strscpy(prpsinfo.pr_psargs, saved_command_line,
+		sizeof(prpsinfo.pr_psargs));
+
+	append_kcore_note(notes, &i, CORE_STR, NT_PRSTATUS, &prstatus,
+			  sizeof(prstatus));
+	append_kcore_note(notes, &i, CORE_STR, NT_PRPSINFO, &prpsinfo,
+			  sizeof(prpsinfo));
+	append_kcore_note_nodesc(notes, &i, VMCOREINFO_NOTE_NAME, 0,
+				 ALIGN(vmcoreinfo_size, 4));
+
+	ehdr->e_phoff = phdr_off;
+
+	/* This is the first kmemdump region, the ELF header */
+	kmemdump_register_id(KMEMDUMP_ID_COREIMAGE_ELF, ehdr,
+			     elfh_size + note_len - ALIGN(vmcoreinfo_size, 4));
+
+	/*
+	 * The second region is the vmcoreinfo, which goes right after.
+	 * It's being registered through vmcoreinfo.
+	 */
+
+	return 0;
+}
+
-- 
2.43.0


