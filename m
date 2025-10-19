Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9FCCCD184
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 06:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6118E0017; Sun, 19 Oct 2025 02:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474FE8E0002; Sun, 19 Oct 2025 02:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A2A18E0017; Sun, 19 Oct 2025 02:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09F7E8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 02:17:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D96941A057F
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:27 +0000 (UTC)
X-FDA: 84013856934.20.A5F6135
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0D6B40004
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 06:17:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TbzE2ezu;
	spf=pass (imf11.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760854646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iW8m1Nosqs5OYRPteC6KkkFaB5XtsL1cC7HU92fjoGM=;
	b=ETqZbokqR+WC1TKLc0eChp2vXmAcNZ6N5DqMJ+Y/5b5WEFSFkSgkdSwtfN3C6iDOz5RGVD
	fuaOlkTXsyhwws4kqC3jEyJ4KCoFG3PtWbZE+u+nmXMy+E1EZsJbtZzltl7pS5+BBPIzuu
	w9wDphIhDoVkh/Id23RqRz8KMjVW7BA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TbzE2ezu;
	spf=pass (imf11.hostedemail.com: domain of xiyou.wangcong@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=xiyou.wangcong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760854646; a=rsa-sha256;
	cv=none;
	b=ObmmpHcnWqSSn8CB1eMKvYETV/ke/ZDvo1Kg57HY7mleMKMRe7B4fSdIr9Cc8jfrZ+or7Z
	nwqUIA1dtHJRUJwT9KGggxzj5AXkStOze7o6H+oENYqbMjJorvz9hUg8cySuSa8qJnWxjN
	RBieuXg5ikPcbnP9RUs2j4NRXACw/hE=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77f67ba775aso4414540b3a.3
        for <linux-mm@kvack.org>; Sat, 18 Oct 2025 23:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760854645; x=1761459445; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iW8m1Nosqs5OYRPteC6KkkFaB5XtsL1cC7HU92fjoGM=;
        b=TbzE2ezuw38opoA4mApqocZJiLjZHT7BjEDBVuSrsVDUIAw0bgctnLPbmicfGLtaoz
         c7KRXpS5IEnCR1wnOUvyL4ieyLMj9FRymoEsAHImGaXUF+CDy/JDOtdCEUgfbZrxPS/m
         loTVOjPaf4GLA/IanNmCXlcCTlQt6Suoesv0h5cM+xbK45JSNSbfdI2t6/RdOznhTNYf
         fU3iz8xpqfiMuVNRiqV8eVjEpP8uEZmTRl5CgQ/tPdNQMyyJAO188tL5fNeJgE8S0KOc
         bskjVowLf0b1mwOJz2+rBXNIf9tucQa1pr6EzMHaxely+YObtJVtlU4ducVSV2x/uwq2
         2H2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760854645; x=1761459445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iW8m1Nosqs5OYRPteC6KkkFaB5XtsL1cC7HU92fjoGM=;
        b=Di3fFlz+GI3RpBp/ulVbRhCi1VI4U5ejGDq+OHdSDJW3HYjQ2OKmr+WBk0sNsjyYcM
         cvnxfm28550EyRDhelQsRSi2cNWlDJVs+AIl8zkLh8prLvrPfE23CNisLxKKMCyASvAp
         5F7UuGZ64ySC8O0LL7F6Fu9hu3Y59Dm64WarfbJo6rs+TXIhLmufbka1HLBMKEIH5ycA
         FJL8stxMbSGO2Tl1B3oK0T9WM+GNbEzqKD09+FnkaW8QLdVlcSNV7L/sbvJDcI2Ehs0l
         Lvkx3hDKw6oa0lf3AXpZid6FLamdVEm1HChsD4LGiKp8YIKkLPzXU4+h1u3c4PZaxB0X
         GT2g==
X-Forwarded-Encrypted: i=1; AJvYcCX3Ru4eCrQipJBhz/RqGu2JX/HinZk7BqTOWRqSZbuYPq7VFDDJyz0zOqR+VCSiOvA3SmL/EidVcw==@kvack.org
X-Gm-Message-State: AOJu0Yz+OmhgU81KAbbRzGsVPkIDVqj81N4zFtFtxm5LuVRdywaUtDF+
	qeAlX9CV/dcKGfYhOkiGbQYumZ3/H6ILYVUzSXHPW70LMFWXk9Kz9gkC
X-Gm-Gg: ASbGncvShxGDbe/2BBEYwJdxesRAbNefQKfUjSq84rNxpEb6ZzRIy8jmobnDzXUp8sm
	MLKByX+LtDcUcA25faSx6tyLDJK6tLokJp2C7byqYBMrFoo4LNQD/o+XBusm+TNxE1H2hW0wuEW
	SuXisCtufWyhGdXX5pNFwi8nsqcGavT6H/1L76rU/J790sDJyDSenvO96LC5/aHFGcd+YG1YVDh
	XovfXYYnvpNAQIbrgmkGC/fjc+q/J6cQMT8e5ujR10u/hIvaTJPZwxi/cBO1yRKWH5ASriZfkCD
	+PqCw+jLOA4Vjgh0dt5DiHn1GbeHL5roZbs0P1cNpml/8D03bR4pI1asgqqz1iGWWcmIKno5Pi4
	LMNupPvn1lM7aB3iDpizmcvRDmgIwI2Say/KJ+liWyuTcJ/lTbIg9emmIwL3R7TltKxcbaJmIBr
	1B/R5gfIJwgxYpAoE=
X-Google-Smtp-Source: AGHT+IFbKeFyxkkhx6UyR26SVo2nzPpKOqrfEUyuRiwI43B7E0dceQ2zTo4yosdetNp12c9xTjB04A==
X-Received: by 2002:a05:6a20:7286:b0:334:9b5d:388e with SMTP id adf61e73a8af0-334a858b223mr13102693637.26.1760854644467;
        Sat, 18 Oct 2025 23:17:24 -0700 (PDT)
Received: from pop-os.. ([2601:647:6881:9060:bc87:d8fe:3e55:7ffb])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b6f302sm4332032a12.38.2025.10.18.23.17.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 23:17:23 -0700 (PDT)
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: jiri@resnulli.us,
	stefanha@redhat.com,
	multikernel@lists.linux.dev,
	pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [RFC Patch v2 16/16] multikernel: Integrate Kexec HandOver framework for DTB preservation
Date: Sat, 18 Oct 2025 23:16:30 -0700
Message-Id: <20251019061631.2235405-17-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
References: <20251019061631.2235405-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0D6B40004
X-Stat-Signature: 5ow4e4ga9j8mon9smb4sjcktwjprnsmc
X-Rspam-User: 
X-HE-Tag: 1760854645-821528
X-HE-Meta: U2FsdGVkX1/ylVY/WPA1dKlmXy+LVHLn7oHiITrjeP0j6KioeWYsb46gPgdhR/8+n+UF2VrMtF2RRA2Nl4ZW/ZoffQF7pRzLypB4EQK07/w5EL4xPROPeH1/NwCEcv5r+6g5X5EfJXJjInnCMLO6CpNOCMk0hLykbnRGoDWzuQ744Xndez1ycgvfBwABUn2BOBUGaD0Tthkv/cx34d3RdZgw1fVjRzvC0ig13U4hFwwtzcCfQG9SHxe9UaChS31sEcSunoG4tejt3O8Okvae2GBR6ylzgmExNMPV3av4VX78HtJKmHZDtfHdnd86UP2nttSbF0ivDBT3QVKlN3DJJ9zOsSZ5RYyh/iPO0lzMkcnPMna23Jc4W9alv122Ucg6b96J5n/ZG05mfYn7z3lj7M2RGd6oZy7sw9jTjxxgiY4pKU6JuSCe2dUMsnfdyyfnuJJaHJYp6zRvtygGfQZ36PoJk6YhN162VaqkiDc54p5Sc55is7vJkpikjKxRpGc69IOT4VH641Wf0w3DnlSVw0LUtrACREiRe9cEiuWULtSlTgft5djJoWbFJ9qcYLQjfNy3yO/hgAhVqqNQvqLpV+oM8n8TaXyLjGjRL0HkQZgo92ChYBGbADTvJwzWumX8MUpuGc9XjjMuSYNsweIIlPxELwYYHcgCzZIvWyws01Jy01qnAk1B9WpqkUmOlYsOa9Xosb3+bS7yD6g6Q8msaWXdKZ2Xk5LgfBwL5dS9Wkatl6IqLfSwAieLkpPRHCSyZbpMP896MO1E608pukBXf+MrM6Uy94UnOXPur+F7/LX4dhRprTDHGBMPW2oRJ7amZflyg6eiatj1lDII7Vxx+Rx9iiE9RzD+7MEPhK5Adn4mNUK2ddK7i0PiwjqNrhx750xAyo38DYvckMRY24kmTczAYE3JOO3hH6CoSA/3isjzF78ksldU7m2MC18Xf7IXQl1/uJDq64boI4cR7Pr
 lli6t+on
 BlbNGKGYjn2PD0szatHa1h5ZvOfNu0lNrOVhmR3ufIX0YKn/p+f0+xz7F25HSPfEyBijuQ+RdPS5W0rMtcS5sJ5g4nCoufXgWeCLR+dmBJIndHD421KSY3vQNNSnzdxS7c4PLH7PXPOZTZS3scP1ICH0dGMwOZtBDaHGzxSg4i6OaFeIzt+JEXo51OkZGaTrMTQCLzSARhzR9hRIS0TNlY/un3t/+6PG7hSC9pdEF5dlqvi5Tkkd+iVZRerEFjRZd20MvPJ+rnY7R1nuv8A77IhBcd0mW9gA2OrO53URQNkyMNLqICxfDUEFolu+1vcLsvw4WVlA1jLFJeoLR1vu6k8llWdBFp2283CqZwdza346ZAFwlbf65Jobv5TkUn8IIIpS3E5CMyfiRIZJw0qkDxfCVK1xsDNroYWSBwpbjb/Jb5YSErhm4/TaXjdaguOCrNp6rM5+FJzV6zF7hKU+038KyEqPtnKfGri1xlDn/NX9vrMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Cong Wang <cwang@multikernel.io>

This commit introduces:

* Multikernel-specific KHO handling in arch/x86 that differentiates
  between regular KHO operations (requiring both FDT and scratch areas)
  and multikernel operations (requiring only FDT) with conditional
  setup data generation and proper boot parameter configuration.

* Enhanced KHO framework with multikernel-aware notifier chain
  (mk_kexec_register_notifier/mk_kexec_unregister_notifier) that
  provides dedicated callbacks for multikernel DTB preservation
  without the overhead of full KHO serialization infrastructure.

* Multikernel KHO finalization through mk_kexec_finalize() that creates
  minimal FDT structures with multikernel-v1 compatibility and calls
  specialized notifiers to preserve target instance DTBs in shared
  memory for seamless handover to spawned kernels.

* DTB restoration infrastructure (mk_kho_restore_dtbs()) that enables
  spawned kernels to automatically recover their device tree
  configurations from KHO shared memory during early boot, recreating
  instance structures with proper resource allocation.

* Integration with existing kexec_file_load workflow through automatic
  FDT page allocation for multikernel images and proper cleanup
  handling when images are freed, ensuring resource lifecycle
  management across kexec boundaries.

The KHO integration maintains full compatibility with existing KHO
code path while extending it for the multikernel use case. Regular kexec
operations continue to use standard KHO scratch area and serialization,
while multikernel case uses the streamlined DTB-only protocol.

This enables seamless multikernel instance migration across kernel
boundaries, allowing spawned kernels to automatically inherit their
device tree configurations and resource allocations without manual
intervention or complex boot parameter manipulation.

Signed-off-by: Cong Wang <cwang@multikernel.io>
---
 arch/x86/kernel/kexec-bzimage64.c |  16 +-
 arch/x86/kernel/setup.c           |   8 +-
 drivers/of/kexec.c                |  20 +-
 include/linux/kexec_handover.h    |  40 ++++
 include/linux/multikernel.h       |  34 +++
 kernel/kexec_core.c               |  11 +
 kernel/kexec_file.c               |   9 +
 kernel/kexec_handover.c           | 197 ++++++++++++++++-
 kernel/multikernel/Kconfig        |   5 +
 kernel/multikernel/Makefile       |   2 +-
 kernel/multikernel/core.c         |   6 +
 kernel/multikernel/kho.c          | 356 ++++++++++++++++++++++++++++++
 12 files changed, 691 insertions(+), 13 deletions(-)
 create mode 100644 kernel/multikernel/kho.c

diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
index c3244ac680d1..8ed2b49bf086 100644
--- a/arch/x86/kernel/kexec-bzimage64.c
+++ b/arch/x86/kernel/kexec-bzimage64.c
@@ -276,15 +276,23 @@ static void setup_kho(const struct kimage *image, struct boot_params *params,
 	sd->type = SETUP_KEXEC_KHO;
 	sd->len = sizeof(struct kho_data);
 
-	/* Only add if we have all KHO images in place */
-	if (!image->kho.fdt || !image->kho.scratch)
+	if (image->type == KEXEC_TYPE_MULTIKERNEL) {
+		if (!image->kho.fdt)
+			return;
+	} else if (!image->kho.fdt || !image->kho.scratch)
 		return;
 
 	/* Add setup data */
 	kho->fdt_addr = image->kho.fdt;
 	kho->fdt_size = PAGE_SIZE;
-	kho->scratch_addr = image->kho.scratch->mem;
-	kho->scratch_size = image->kho.scratch->bufsz;
+	if (image->type == KEXEC_TYPE_MULTIKERNEL) {
+		kho->scratch_addr = 0;
+		kho->scratch_size = 0;
+	} else {
+		kho->scratch_addr = image->kho.scratch->mem;
+		kho->scratch_size = image->kho.scratch->bufsz;
+	}
+
 	sd->next = params->hdr.setup_data;
 	params->hdr.setup_data = params_load_addr + setup_data_offset;
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 8342c4e46bad..40e3cb19e06b 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -467,7 +467,13 @@ static void __init add_kho(u64 phys_addr, u32 data_len)
 		return;
 	}
 
-	kho_populate(kho->fdt_addr, kho->fdt_size, kho->scratch_addr, kho->scratch_size);
+	if (kho->scratch_addr == 0 && kho->scratch_size == 0) {
+		pr_info("setup: detected multikernel KHO data\n");
+		mk_kho_populate(kho->fdt_addr, kho->fdt_size);
+	} else {
+		pr_info("setup: detected regular KHO data\n");
+		kho_populate(kho->fdt_addr, kho->fdt_size, kho->scratch_addr, kho->scratch_size);
+	}
 
 	early_memunmap(kho, size);
 }
diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 1ee2d31816ae..a27971be555c 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -280,13 +280,21 @@ static int kho_add_chosen(const struct kimage *image, void *fdt, int chosen_node
 	if (ret && ret != -FDT_ERR_NOTFOUND)
 		return ret;
 
-	if (!image->kho.fdt || !image->kho.scratch)
+	if (image->type == KEXEC_TYPE_MULTIKERNEL) {
+		if (!image->kho.fdt)
+			return 0;
+	} else if (!image->kho.fdt || !image->kho.scratch)
 		return 0;
 
 	fdt_mem = image->kho.fdt;
 	fdt_len = PAGE_SIZE;
-	scratch_mem = image->kho.scratch->mem;
-	scratch_len = image->kho.scratch->bufsz;
+	if (image->type == KEXEC_TYPE_MULTIKERNEL) {
+		scratch_mem = 0;
+		scratch_len = 0;
+	} else {
+		scratch_mem = image->kho.scratch->mem;
+		scratch_len = image->kho.scratch->bufsz;
+	}
 
 	pr_debug("Adding kho metadata to DT");
 
@@ -294,8 +302,10 @@ static int kho_add_chosen(const struct kimage *image, void *fdt, int chosen_node
 				       fdt_mem, fdt_len);
 	if (ret)
 		return ret;
-	ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-scratch",
-				       scratch_mem, scratch_len);
+
+	if (scratch_mem && scratch_len)
+		ret = fdt_appendprop_addrrange(fdt, 0, chosen_node, "linux,kho-scratch",
+					       scratch_mem, scratch_len);
 
 #endif /* CONFIG_KEXEC_HANDOVER */
 	return ret;
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 25042c1d8d54..480c4510a9ed 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -64,9 +64,20 @@ int register_kho_notifier(struct notifier_block *nb);
 int unregister_kho_notifier(struct notifier_block *nb);
 
 void kho_memory_init(void);
+int kho_get_target_mk_id(struct kho_serialization *ser);
+struct kimage;
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
 		  u64 scratch_len);
+void mk_kho_populate(phys_addr_t fdt_phys, u64 fdt_len);
+
+/* Multikernel kexec notifier functions */
+int mk_kexec_register_notifier(struct notifier_block *nb);
+int mk_kexec_unregister_notifier(struct notifier_block *nb);
+int mk_kexec_finalize(struct kimage *target_image);
+
+/* KHO FDT access */
+phys_addr_t kho_get_fdt_phys(void);
 #else
 static inline bool kho_is_enabled(void)
 {
@@ -121,6 +132,11 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	return -EOPNOTSUPP;
 }
 
+static inline int kho_get_target_mk_id(struct kho_serialization *ser)
+{
+	return 0;
+}
+
 static inline int register_kho_notifier(struct notifier_block *nb)
 {
 	return -EOPNOTSUPP;
@@ -139,6 +155,30 @@ static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 				phys_addr_t scratch_phys, u64 scratch_len)
 {
 }
+
+static inline void mk_kho_populate(phys_addr_t fdt_phys, u64 fdt_len)
+{
+}
+
+static inline int mk_kexec_register_notifier(struct notifier_block *nb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int mk_kexec_unregister_notifier(struct notifier_block *nb)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int mk_kexec_finalize(struct kimage *target_image)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline phys_addr_t kho_get_fdt_phys(void)
+{
+	return 0;
+}
 #endif /* CONFIG_KEXEC_HANDOVER */
 
 #endif /* LINUX_KEXEC_HANDOVER_H */
diff --git a/include/linux/multikernel.h b/include/linux/multikernel.h
index 3bc07361145b..c463940eb27c 100644
--- a/include/linux/multikernel.h
+++ b/include/linux/multikernel.h
@@ -622,4 +622,38 @@ static inline bool mk_is_resource_property(const char *prop_name)
 	return false;
 }
 
+/**
+ * KHO (Kexec HandOver) Integration Functions
+ *
+ * These functions provide KHO support for preserving and restoring
+ * multikernel instance device trees across kexec boundaries.
+ */
+
+/**
+ * mk_kho_restore_dtbs() - Restore DTBs from KHO shared memory
+ *
+ * Called during multikernel initialization to restore DTBs that were
+ * preserved by the previous kernel via KHO.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int __init mk_kho_restore_dtbs(void);
+
+/**
+ * mk_kho_init() - Initialize KHO support for multikernel
+ *
+ * Registers the KHO notifier and attempts to restore DTBs from
+ * a previous KHO boot.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int __init mk_kho_init(void);
+
+/**
+ * mk_kho_cleanup() - Cleanup KHO support for multikernel
+ *
+ * Unregisters the KHO notifier.
+ */
+void mk_kho_cleanup(void);
+
 #endif /* _LINUX_MULTIKERNEL_H */
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 61ad01acd034..c5ed3fd90ede 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -43,6 +43,7 @@
 #include <linux/objtool.h>
 #include <linux/kmsg_dump.h>
 #include <linux/multikernel.h>
+#include <linux/kexec_handover.h>
 #include <linux/dma-map-ops.h>
 #include <linux/memblock.h>
 
@@ -673,6 +674,10 @@ void kimage_free(struct kimage *image)
 		image->mk_instance = NULL;
 		pr_info("Freed multikernel ID %d\n", image->mk_id);
 	}
+	if (image->kho.fdt && image->type == KEXEC_TYPE_MULTIKERNEL) {
+		put_page(phys_to_page(image->kho.fdt));
+		image->kho.fdt = 0;
+	}
 
 #ifdef CONFIG_CRASH_DUMP
 	if (image->vmcoreinfo_data_copy) {
@@ -1591,6 +1596,12 @@ int multikernel_kexec_by_id(int mk_id)
 		goto unlock;
 	}
 
+	rc = mk_kexec_finalize(mk_image);
+	if (rc)
+		pr_warn("KHO finalization failed: %d\n", rc);
+	else
+		pr_info("KHO finalized for multikernel instance\n");
+
 	pr_info("Using multikernel image with ID %d (entry point: 0x%lx) on CPU %d\n",
 		mk_image->mk_id, mk_image->start, cpu);
 
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index f9979c1d9f9e..44b42ae34ef2 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -329,6 +329,7 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
 	if (multikernel_load) {
 		struct mk_instance *instance;
 		int mk_id = KEXEC_GET_MK_ID(flags);
+		struct page *fdt_page;
 
 		/* Set multikernel image type for proper memory allocation */
 		image->type = KEXEC_TYPE_MULTIKERNEL;
@@ -367,6 +368,14 @@ kimage_file_alloc_init(struct kimage **rimage, int kernel_fd,
 		mk_instance_set_state(instance, MK_STATE_LOADING);
 
 		pr_info("Associated kimage with multikernel instance %d\n", mk_id);
+
+		fdt_page = alloc_page(GFP_KERNEL);
+		if (!fdt_page) {
+			pr_err("Failed to allocate FDT page for multikernel kimage\n");
+			ret = -ENOMEM;
+			goto out_free_image;
+		}
+		image->kho.fdt = page_to_phys(fdt_page);
 	}
 
 	ret = kimage_file_prepare_segments(image, kernel_fd, initrd_fd,
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 76f0940fb485..70bfd4b27220 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -19,6 +19,7 @@
 #include <linux/notifier.h>
 #include <linux/page-isolation.h>
 #include <linux/vmalloc.h>
+#include <linux/multikernel.h>
 
 #include <asm/early_ioremap.h>
 
@@ -106,6 +107,8 @@ struct kho_serialization {
 	struct kho_mem_track track;
 	/* First chunk of serialized preserved memory map */
 	struct khoser_mem_chunk *preserved_mem_map;
+	/* Target multikernel instance ID for selective preservation */
+	int target_mk_id;
 };
 
 struct kho_out {
@@ -1100,12 +1103,20 @@ static int kho_abort(void)
 	return err;
 }
 
-static int kho_finalize(void)
+static int kho_finalize(struct kimage *target_image)
 {
 	int err = 0;
 	u64 *preserved_mem_map;
 	void *fdt = page_to_virt(kho_out.ser.fdt);
 
+	if (target_image && target_image->mk_id > 0) {
+		kho_out.ser.target_mk_id = target_image->mk_id;
+		pr_info("KHO finalize: targeting multikernel instance %d\n", target_image->mk_id);
+	} else {
+		kho_out.ser.target_mk_id = 0;
+		pr_info("KHO finalize: no specific target (preserving all instances)\n");
+	}
+
 	err |= fdt_create(fdt, PAGE_SIZE);
 	err |= fdt_finish_reservemap(fdt);
 	err |= fdt_begin_node(fdt, "");
@@ -1149,6 +1160,134 @@ static int kho_finalize(void)
 	return err;
 }
 
+static BLOCKING_NOTIFIER_HEAD(mk_kexec_notifier_chain);
+
+/**
+ * mk_kexec_call_notifiers - Call multikernel-specific notifiers
+ * @target_image: The multikernel kimage being executed
+ * @fdt: The FDT to populate with multikernel data
+ *
+ * This calls a dedicated notifier chain for multikernel that bypasses
+ * the complex KHO serialization system.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+static int mk_kexec_call_notifiers(struct kimage *target_image, void *fdt)
+{
+	struct mk_kexec_data {
+		struct kimage *image;
+		void *fdt;
+		int mk_id;
+	} data = {
+		.image = target_image,
+		.fdt = fdt,
+		.mk_id = target_image->mk_id
+	};
+
+	int ret = blocking_notifier_call_chain(&mk_kexec_notifier_chain,
+					       0, &data);
+	return notifier_to_errno(ret);
+}
+
+/**
+ * mk_kexec_register_notifier - Register a multikernel kexec notifier
+ * @nb: The notifier block to register
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int mk_kexec_register_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&mk_kexec_notifier_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mk_kexec_register_notifier);
+
+/**
+ * mk_kexec_unregister_notifier - Unregister a multikernel kexec notifier
+ * @nb: The notifier block to unregister
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int mk_kexec_unregister_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&mk_kexec_notifier_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mk_kexec_unregister_notifier);
+
+/**
+ * mk_kexec_finalize - Finalize multikernel DTB for kexec
+ * @target_image: The multikernel kimage being executed
+ *
+ * This function creates a minimal FDT for multikernel and calls the
+ * multikernel notifier to preserve the target instance's DTB.
+ * It reuses the existing device tree infrastructure but avoids the
+ * complex KHO serialization system.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int mk_kexec_finalize(struct kimage *target_image)
+{
+	void *fdt;
+	int ret;
+
+	if (target_image->mk_id <= 0) {
+		pr_warn("mk_kexec_finalize called without valid multikernel target\n");
+		return -EINVAL;
+	}
+
+	if (!target_image->kho.fdt) {
+		pr_err("No FDT page allocated for multikernel kimage\n");
+		return -EINVAL;
+	}
+
+	/* Use the pre-allocated FDT page from multikernel memory pool */
+	fdt = phys_to_virt(target_image->kho.fdt);
+
+	ret = fdt_create(fdt, PAGE_SIZE);
+	ret |= fdt_finish_reservemap(fdt);
+	ret |= fdt_begin_node(fdt, "");
+	ret |= fdt_property_string(fdt, "compatible", MK_FDT_COMPATIBLE);
+	if (ret) {
+		pr_err("Failed to create FDT structure: %d\n", ret);
+		return ret;
+	}
+
+	ret = mk_kexec_call_notifiers(target_image, fdt);
+	if (ret) {
+		pr_err("Multikernel notifier failed: %d\n", ret);
+		fdt_end_node(fdt);
+		fdt_finish(fdt);
+		return ret;
+	}
+
+	ret = fdt_end_node(fdt);
+	ret |= fdt_finish(fdt);
+	if (ret) {
+		pr_err("Failed to finalize FDT: %d\n", ret);
+		return ret;
+	}
+
+	if (fdt_totalsize(fdt) > PAGE_SIZE) {
+		pr_err("FDT size (%d bytes) exceeds allocated page size (%lu bytes)\n",
+		       fdt_totalsize(fdt), PAGE_SIZE);
+		return -ENOSPC;
+	}
+
+	pr_info("Finalized multikernel FDT for instance %d (size: %d bytes)\n",
+		target_image->mk_id, fdt_totalsize(fdt));
+	return 0;
+}
+
+/**
+ * kho_get_target_mk_id - Get target multikernel ID from KHO serialization
+ * @ser: KHO serialization structure
+ *
+ * Returns the target multikernel instance ID, or 0 if not set.
+ */
+int kho_get_target_mk_id(struct kho_serialization *ser)
+{
+	return ser ? ser->target_mk_id : 0;
+}
+
 static int kho_out_finalize_get(void *data, u64 *val)
 {
 	mutex_lock(&kho_out.lock);
@@ -1174,7 +1313,7 @@ static int kho_out_finalize_set(void *data, u64 _val)
 	}
 
 	if (val)
-		ret = kho_finalize();
+		ret = kho_finalize(NULL);
 	else
 		ret = kho_abort();
 
@@ -1262,6 +1401,11 @@ static const void *kho_get_fdt(void)
 	return kho_in.fdt_phys ? phys_to_virt(kho_in.fdt_phys) : NULL;
 }
 
+phys_addr_t kho_get_fdt_phys(void)
+{
+	return kho_in.fdt_phys;
+}
+
 /**
  * is_kho_boot - check if current kernel was booted via KHO-enabled
  * kexec
@@ -1474,6 +1618,55 @@ void __init kho_memory_init(void)
 	}
 }
 
+/**
+ * mk_kho_populate() - Populate multikernel KHO data during early boot
+ * @fdt_phys: Physical address of the multikernel FDT
+ * @fdt_len: Length of the FDT
+ *
+ * This function handles multikernel FDT revival during early boot. Unlike
+ * regular KHO, multikernel doesn't use scratch areas and has a different
+ * FDT format with 'multikernel-v1' compatibility.
+ */
+void __init mk_kho_populate(phys_addr_t fdt_phys, u64 fdt_len)
+{
+	void *fdt = NULL;
+	int err = 0;
+
+	pr_info("Multikernel KHO: processing FDT at 0x%llx (size: %llu)\n", fdt_phys, fdt_len);
+
+	/* Validate the input FDT */
+	fdt = early_memremap(fdt_phys, fdt_len);
+	if (!fdt) {
+		pr_warn("Multikernel KHO: failed to memremap FDT (0x%llx)\n", fdt_phys);
+		goto out;
+	}
+
+	err = fdt_check_header(fdt);
+	if (err) {
+		pr_warn("Multikernel KHO: handover FDT (0x%llx) is invalid: %d\n",
+			fdt_phys, err);
+		goto out;
+	}
+
+	err = fdt_node_check_compatible(fdt, 0, MK_FDT_COMPATIBLE);
+	if (err) {
+		pr_warn("Multikernel KHO: handover FDT (0x%llx) is incompatible with 'multikernel-v1': %d\n",
+			fdt_phys, err);
+		goto out;
+	}
+
+	kho_in.fdt_phys = fdt_phys;
+	kho_in.scratch_phys = 0;
+
+	pr_info("Multikernel KHO: successfully populated FDT data\n");
+
+out:
+	if (fdt)
+		early_memunmap(fdt, fdt_len);
+	if (err)
+		pr_warn("Multikernel KHO: disabling multikernel revival\n");
+}
+
 void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 			 phys_addr_t scratch_phys, u64 scratch_len)
 {
diff --git a/kernel/multikernel/Kconfig b/kernel/multikernel/Kconfig
index a9582a4d0c54..1b0191beffa7 100644
--- a/kernel/multikernel/Kconfig
+++ b/kernel/multikernel/Kconfig
@@ -6,6 +6,7 @@
 config MULTIKERNEL
 	bool "Multikernel support"
 	depends on KEXEC_CORE
+	depends on KEXEC_HANDOVER
 	select LIBFDT
 	help
 	  Enable multikernel support, which allows running multiple kernel
@@ -17,5 +18,9 @@ config MULTIKERNEL
 	  - Device tree based resource specification
 	  - Memory pool management for kernel instances
 	  - Integration with kexec for kernel loading
+	  - KHO (Kexec HandOver) support for seamless DTB transfer
+
+	  Requires KEXEC_HANDOVER for preserving device trees and instance
+	  state across kernel boundaries.
 
 	  If unsure, say N.
diff --git a/kernel/multikernel/Makefile b/kernel/multikernel/Makefile
index f133e1eaf534..3d81a3233bba 100644
--- a/kernel/multikernel/Makefile
+++ b/kernel/multikernel/Makefile
@@ -3,7 +3,7 @@
 # Makefile for multikernel support
 #
 
-obj-y += core.o mem.o kernfs.o dts.o ipi.o messaging.o
+obj-y += core.o mem.o kernfs.o dts.o ipi.o messaging.o kho.o
 
 # Add libfdt include path for device tree parsing
 CFLAGS_dts.o = -I $(srctree)/scripts/dtc/libfdt
diff --git a/kernel/multikernel/core.c b/kernel/multikernel/core.c
index 37dbf0cf4be6..95d27b3b15cc 100644
--- a/kernel/multikernel/core.c
+++ b/kernel/multikernel/core.c
@@ -518,6 +518,12 @@ static int __init multikernel_init(void)
 		return ret;
 	}
 
+	ret = mk_kho_init();
+	if (ret < 0) {
+		pr_warn("Failed to initialize KHO support: %d\n", ret);
+		/* Continue without KHO support - this is not fatal */
+	}
+
 	pr_info("Multikernel support initialized\n");
 	return 0;
 }
diff --git a/kernel/multikernel/kho.c b/kernel/multikernel/kho.c
new file mode 100644
index 000000000000..8f25b4d73fa1
--- /dev/null
+++ b/kernel/multikernel/kho.c
@@ -0,0 +1,356 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Multikernel Technologies, Inc. All rights reserved
+ *
+ * Multikernel KHO (Kexec HandOver)
+ *
+ * Provides KHO support for preserving and restoring multikernel instance
+ * device trees across kexec boundaries using shared memory.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/multikernel.h>
+#include <linux/io.h>
+#ifdef CONFIG_KEXEC_HANDOVER
+#include <linux/kexec_handover.h>
+#include <linux/libfdt.h>
+#include <linux/sizes.h>
+#include "internal.h"
+
+#define PROP_SUB_FDT "fdt"
+#endif
+
+#ifdef CONFIG_KEXEC_HANDOVER
+
+/**
+ * mk_kexec_notifier() - Multikernel kexec notifier callback for DTB preservation
+ * @nb: Notifier block
+ * @action: Notifier action (unused)
+ * @data: Multikernel kexec data
+ *
+ * Called by multikernel kexec subsystem during kexec to preserve multikernel DTBs
+ * in shared memory for the target kernel. This uses a simplified interface
+ * compared to the full KHO system.
+ */
+static int mk_kexec_notifier(struct notifier_block *nb, unsigned long action, void *data)
+{
+	struct mk_kexec_data {
+		struct kimage *image;
+		void *fdt;
+		int mk_id;
+	} *mk_data = data;
+
+	struct mk_instance *instance;
+	int ret = 0;
+
+	pr_info("Preserving multikernel DTB for instance %d\n", mk_data->mk_id);
+
+	/* Find the target multikernel instance */
+	instance = mk_instance_find(mk_data->mk_id);
+	if (!instance) {
+		pr_err("Target multikernel instance %d not found\n", mk_data->mk_id);
+		return NOTIFY_STOP;
+	}
+
+	if (!instance->dtb_data || instance->dtb_size == 0) {
+		pr_err("Target multikernel instance %d has no DTB data - did you write to device_tree file?\n", mk_data->mk_id);
+		mk_instance_put(instance);
+		return NOTIFY_STOP;
+	}
+
+	ret |= fdt_begin_node(mk_data->fdt, "multikernel");
+	ret |= fdt_property(mk_data->fdt, "dtb-data", instance->dtb_data, instance->dtb_size);
+	ret |= fdt_end_node(mk_data->fdt);
+
+	if (ret) {
+		pr_err("Failed to add DTB for instance %d to FDT: %d\n", mk_data->mk_id, ret);
+		mk_instance_put(instance);
+		return notifier_from_errno(ret);
+	}
+
+	pr_info("Preserved DTB for instance %d (%zu bytes)\n", mk_data->mk_id, instance->dtb_size);
+	mk_instance_put(instance);
+	return NOTIFY_OK;
+}
+
+/* Multikernel kexec notifier block */
+static struct notifier_block mk_kexec_nb = {
+	.notifier_call = mk_kexec_notifier,
+};
+
+/**
+ * mk_dt_extract_instance_info() - Extract instance ID and name from DTB
+ * @dtb_data: Device tree blob data
+ * @dtb_size: Size of DTB data
+ * @instance_id: Output parameter for instance ID
+ * @instance_name: Output parameter for instance name (caller must free)
+ *
+ * Parses the DTB to find the first instance in the instances node and
+ * extracts its ID and name.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+static int mk_dt_extract_instance_info(const void *dtb_data, size_t dtb_size,
+				       int *instance_id, const char **instance_name)
+{
+	const void *fdt = dtb_data;
+	int instances_node, instance_node;
+	const fdt32_t *id_prop;
+	const char *name;
+
+	if (!dtb_data || !instance_id || !instance_name) {
+		return -EINVAL;
+	}
+
+	/* Find /instances node */
+	instances_node = fdt_path_offset(fdt, "/instances");
+	if (instances_node < 0) {
+		pr_err("No /instances node found in device tree\n");
+		return -ENOENT;
+	}
+
+	/* Find the first instance child node */
+	instance_node = fdt_first_subnode(fdt, instances_node);
+	if (instance_node < 0) {
+		pr_err("No instance found in /instances node\n");
+		return -ENOENT;
+	}
+
+	/* Get the instance name (node name) */
+	name = fdt_get_name(fdt, instance_node, NULL);
+	if (!name) {
+		pr_err("Failed to get instance name\n");
+		return -EINVAL;
+	}
+
+	/* Get the instance ID property */
+	id_prop = fdt_getprop(fdt, instance_node, "id", NULL);
+	if (!id_prop) {
+		pr_err("No 'id' property found in instance '%s'\n", name);
+		return -ENOENT;
+	}
+
+	*instance_id = fdt32_to_cpu(*id_prop);
+	*instance_name = name;
+
+	return 0;
+}
+
+/**
+ * mk_kho_restore_dtbs() - Restore DTB from KHO shared memory
+ *
+ * Called during multikernel initialization in the spawned kernel to restore
+ * the single DTB that was preserved by the host kernel via KHO. The spawned
+ * kernel receives exactly one DTB and parses the instance ID from it.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int __init mk_kho_restore_dtbs(void)
+{
+	void *dtb_virt;
+	int dtb_len;
+	int ret;
+	struct mk_instance *instance;
+	struct mk_dt_config config;
+	int instance_id;
+	const char *instance_name;
+	const void *kho_fdt = NULL;
+	phys_addr_t fdt_phys;
+
+	fdt_phys = kho_get_fdt_phys();
+	if (!fdt_phys) {
+		pr_info("No KHO FDT available for multikernel DTB restoration\n");
+		return 0;
+	}
+
+	pr_info("Restoring multikernel DTB from KHO (phys: 0x%llx)\n", fdt_phys);
+
+	/* Map the FDT for early boot access */
+	kho_fdt = early_memremap(fdt_phys, PAGE_SIZE);
+	if (!kho_fdt) {
+		pr_err("Failed to map KHO FDT at 0x%llx\n", fdt_phys);
+		return -EFAULT;
+	}
+
+	int mk_node = fdt_subnode_offset(kho_fdt, 0, "multikernel");
+	if (mk_node < 0) {
+		pr_info("No multikernel node found in KHO FDT\n");
+		ret = 0;
+		goto cleanup_fdt;
+	}
+
+	const void *dtb_data = fdt_getprop(kho_fdt, mk_node, "dtb-data", &dtb_len);
+	if (!dtb_data || dtb_len <= 0) {
+		pr_info("No dtb-data property found in multikernel node\n");
+		ret = 0;
+		goto cleanup_fdt;
+	}
+
+	pr_info("Found preserved multikernel DTB (%d bytes)\n", dtb_len);
+
+	/* Validate DTB header */
+	ret = fdt_check_header(dtb_data);
+	if (ret) {
+		pr_err("Invalid DTB header from KHO: %d\n", ret);
+		ret = -EINVAL;
+		goto cleanup_fdt;
+	}
+
+	if (dtb_len > SZ_1M) {
+		pr_err("DTB size too large: %d bytes\n", dtb_len);
+		ret = -EINVAL;
+		goto cleanup_fdt;
+	}
+
+	dtb_virt = kmalloc(dtb_len, GFP_KERNEL);
+	if (!dtb_virt) {
+		pr_err("Failed to allocate memory for DTB (%d bytes)\n", dtb_len);
+		ret = -ENOMEM;
+		goto cleanup_fdt;
+	}
+	memcpy(dtb_virt, dtb_data, dtb_len);
+
+	/* Parse DTB to get the actual instance ID and name */
+	ret = mk_dt_extract_instance_info(dtb_virt, dtb_len, &instance_id, &instance_name);
+	if (ret) {
+		pr_err("Failed to extract instance info from DTB: %d\n", ret);
+		goto cleanup_dtb;
+	}
+
+	pr_info("DTB contains instance ID %d, name '%s'\n", instance_id, instance_name);
+
+	/* Parse DTB configuration */
+	mk_dt_config_init(&config);
+	ret = mk_dt_parse(dtb_virt, dtb_len, &config);
+	if (ret) {
+		pr_err("Failed to parse DTB from KHO: %d\n", ret);
+		goto config_free;
+	}
+
+	/* Create a new instance for this DTB */
+	instance = kzalloc(sizeof(*instance), GFP_KERNEL);
+	if (!instance) {
+		pr_err("Failed to allocate memory for multikernel instance\n");
+		ret = -ENOMEM;
+		goto config_free;
+	}
+
+	/* Initialize instance with parsed data */
+	instance->id = instance_id;
+	instance->name = kstrdup(instance_name, GFP_KERNEL);
+	if (!instance->name) {
+		ret = -ENOMEM;
+		goto cleanup_instance;
+	}
+
+	instance->dtb_data = kmalloc(dtb_len, GFP_KERNEL);
+	if (!instance->dtb_data) {
+		pr_err("Failed to allocate memory for DTB restoration\n");
+		ret = -ENOMEM;
+		goto cleanup_instance_name;
+	}
+
+	memcpy(instance->dtb_data, dtb_virt, dtb_len);
+	instance->dtb_size = dtb_len;
+
+	INIT_LIST_HEAD(&instance->memory_regions);
+	INIT_LIST_HEAD(&instance->list);
+	kref_init(&instance->refcount);
+
+	ret = mk_instance_reserve_resources(instance, &config);
+	if (ret == 0) {
+		mk_instance_set_state(instance, MK_STATE_READY);
+
+		mutex_lock(&mk_instance_mutex);
+		list_add_tail(&instance->list, &mk_instance_list);
+		mutex_unlock(&mk_instance_mutex);
+
+		pr_info("Successfully restored multikernel instance %d ('%s') from KHO (%d bytes)\n",
+			instance_id, instance_name, dtb_len);
+		mk_dt_config_free(&config);
+		kfree(dtb_virt);
+		early_memunmap((void *)kho_fdt, PAGE_SIZE);
+		return 0;
+	} else {
+		pr_err("Failed to reserve memory for restored instance: %d\n", ret);
+		mk_instance_set_state(instance, MK_STATE_FAILED);
+		/* Fall through to cleanup */
+	}
+
+cleanup_instance_name:
+	kfree(instance->name);
+cleanup_instance:
+	kfree(instance->dtb_data);
+	kfree(instance);
+config_free:
+	mk_dt_config_free(&config);
+cleanup_dtb:
+	kfree(dtb_virt);
+cleanup_fdt:
+	early_memunmap((void *)kho_fdt, PAGE_SIZE);
+	return ret;
+}
+
+/**
+ * mk_kho_init() - Initialize KHO support for multikernel
+ *
+ * Registers the KHO notifier and attempts to restore DTBs from
+ * a previous KHO boot.
+ *
+ * Returns: 0 on success, negative error code on failure
+ */
+int __init mk_kho_init(void)
+{
+	int ret;
+
+	/* Register multikernel kexec notifier for DTB preservation */
+	ret = mk_kexec_register_notifier(&mk_kexec_nb);
+	if (ret) {
+		pr_warn("Failed to register multikernel kexec notifier: %d\n", ret);
+		return ret;
+	}
+
+	pr_info("Registered multikernel kexec notifier for DTB preservation\n");
+
+	/* Restore DTBs from previous kernel if KHO boot */
+	ret = mk_kho_restore_dtbs();
+	if (ret) {
+		pr_warn("Failed to restore DTBs from KHO: %d\n", ret);
+		/* Continue - this is not fatal */
+	}
+
+	return 0;
+}
+
+/**
+ * mk_kho_cleanup() - Cleanup multikernel kexec support
+ *
+ * Unregisters the multikernel kexec notifier.
+ */
+void mk_kho_cleanup(void)
+{
+	mk_kexec_unregister_notifier(&mk_kexec_nb);
+	pr_debug("Unregistered multikernel kexec notifier\n");
+}
+
+#else /* !CONFIG_KEXEC_HANDOVER */
+
+/* Stub functions when KHO is not enabled */
+int __init mk_kho_restore_dtbs(void)
+{
+	return 0;
+}
+
+int __init mk_kho_init(void)
+{
+	return 0;
+}
+
+void mk_kho_cleanup(void)
+{
+}
+
+#endif /* CONFIG_KEXEC_HANDOVER */
-- 
2.34.1


