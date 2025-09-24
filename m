Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCA7CAC5B1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E736C8E000E; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AF78E0001; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FBF8E000E; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B38A38E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B4751A0887
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:11 +0000 (UTC)
X-FDA: 83924454222.19.0FB5524
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6267E160013
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kUPem1D/";
	spf=pass (imf08.hostedemail.com: domain of 3dwfUaAgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3dwfUaAgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RoJVCKwzHTvI9L15TyOM+QFTR+4mknbbnsqq6MMe4q4=;
	b=O9cjIIfwmFOx4rHeIanhIyNmxWiZsg0oPL1M5f7/AVxL7q9z+DoZ4Vn5bo1jPybwEos9a1
	8znG4dlYKqCMIgNbgCt856ccy1W8G3ykM0iQcC8EVdXyRjeCe1SlJ2rx/JhiUIqXZ4LjFm
	vwgMIMbnmf7oVfdRM/V4UFJgKvtc0Gc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726009; a=rsa-sha256;
	cv=none;
	b=BWs7dtzfD2uheDaM7qCG0h6UOwrT27tfZ6kISqq3mKEfeRbpVwXfh1UyYyc2NC6Mhrioif
	V/JG2jiCf1y8btOIbZn1hP7tYsbTTMf8Y4Lwerjt4Cq4uVPg9gH+c7G2Tmt4ifcPc/IITl
	lagEzA9QDox7GXQwHSXnQ1CNrS7YX+s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="kUPem1D/";
	spf=pass (imf08.hostedemail.com: domain of 3dwfUaAgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3dwfUaAgKCCQJACKMANBGOOGLE.COMLINUX-MMKVACK.ORG@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ee1317b132so2449917f8f.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726008; x=1759330808; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RoJVCKwzHTvI9L15TyOM+QFTR+4mknbbnsqq6MMe4q4=;
        b=kUPem1D/6dZ+BnZ+f+c3TcjkjCyGw/oxOM4MoF+ElyKDIH8RtIQsMqvLLmFCcsS8wS
         NHycbVQCgFBLO4oKOFDces8v7dO7l6Nr+RQSZKxh85STRbMfcH6sXdjQA3/YyOHvTW+k
         7a1BFuq/9oa3ZuXgOa8L1SRqB45qqjwpWf0waZjtZeY5dpQFb9jEantZnp7fm/YNnEHG
         k/IF0FANGZXcvzqZHyKyA9zYskG+0lZtVHNBk31wInsd84zLfXU6xdHzmzboWQuZA4+O
         2d/PDGKy2r957BDldvbIzDnyKhU4SbqRF/nSCRlUjgzYrqhYjsInHtK/YTSrs3yBM1kE
         lxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726008; x=1759330808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RoJVCKwzHTvI9L15TyOM+QFTR+4mknbbnsqq6MMe4q4=;
        b=tJVnDfTTNZ0qeGf8mkH5NUrLj5mLj2GQd2MFGiPOpd6p0M/iu769PycXnM5OS2bLUo
         YvudMm5Ce81E2+Y9NJiILUL8mDr5Ur/wMMM/TvAqJs9qYdYxhCezLtRsTB1+ISUxAjdt
         TfoKXBu4qvDFDxmW8aR86/WWtm2+Jrhp81fADNP/RmVMc3vS6x3xzRtHrCxvFPdy42MW
         WEfM1ldQxa9XI6pwRrD5C9KFTpabeuyi6NDTYUc5FvtqQJ3OybDkkoomFBptDyTLD+Ff
         vZiZD13YB1M55IjT/mxBV0kVo9puDHYZ2XFoFjfbdpJaDeLdvpvWMIikBJf/Iy5sH8ql
         bdcA==
X-Forwarded-Encrypted: i=1; AJvYcCUTJz3tIIJ5XEKU/zXddg92KaXeJqarDOLIR96XIy53LVvFftJRLOfmQLg8EddKioDYvCEeg1j9Rg==@kvack.org
X-Gm-Message-State: AOJu0YyYpfVDMsxF2baUbO2KInM7w4zC+Yrnu+UclDXi/IbZrtbbPX0N
	vsNtn7naw/xuqS1SFhLXEptwqmIgjxoc6X3PfIvxVFZrUDqB38zqxE8Ndgo9xEzuEV3KjwGXmxH
	LAagV+QtPArftSQ==
X-Google-Smtp-Source: AGHT+IFYCM81xG8NnhOZnthImfsZs9y4y2Mpes3SZt0+UDE3H8DpBmBpiCVfYNrs7AMA4PJb8IINbQbGi/I5sw==
X-Received: from wmbej13.prod.google.com ([2002:a05:600c:3e8d:b0:46e:2291:a3a4])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2484:b0:405:1925:4972 with SMTP id ffacd0b85a97d-40e46515005mr243422f8f.1.1758726007585;
 Wed, 24 Sep 2025 08:00:07 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:36 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-1-2d861768041f@google.com>
Subject: [PATCH 01/21] x86/mm/asi: Add CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: twbz6ffctk7ynwo8bn6j3msytts7nr4p
X-Rspamd-Queue-Id: 6267E160013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758726009-616030
X-HE-Meta: U2FsdGVkX18r1JMLZ7I6OVUxsHlFr2o7PUHJLOMMiOWKs2x3gGsGHrN96kfri07+tX99hnHESqT3MC74WnmjadRbU2AQWSkHPKU6ddZDxOgv1zMqIE9gGULm4XdGf5ChLOsMnEKxewEbS4aTMb+YNeLTD7CSFbf+ld+iIYbcIMmXlEtZrsmNQA4Zj8UF+C5VRM88L+Xgu1tob/OkRRdPwn33NMPzt6X4vywPplJ87WIyHHB2wHmLSAWeUPs6PyuDATd/6i9OM2P9YNzhRsdPUrYzlpcMrEwlP0cuaN+P1jfLV0xrD4ZOhvEU2lC7fdbunbjgmyR+sixX0cLf6g73+OCsh4Z7MY0ro6mdpivGLeYJ3HX2laCQy2B6rRKlbC8MhyVm8wauH/Y5M1aWbYIHo11E41yIEnPf+mUFOGyhaJo6hClPpfLoYLM5+qSzezdl65PbWWxDZL3IGz5fiKT2v2Kw9jAtY2y5tssEvPmsNuZsWJQdMwG1FdOhYXz3v0Ra56imbQL+VW+QIDCfayKfeGYgce2bfftDnuVdv7z7iC2sUKNMo09gqdvEBAzkGhAfBwzH6sqVRD4ut1dojpLAdMYe0HyuTE7PSfuMA827uFbef/uxz6GpLETaY9fqRZQn/3WIFiLIrShz9H1YgB2XKOxG7UBOHmkfyy3eUiDG9wdTklj1qu22tu4wY0KxNX3qJ7WywhqIcfXHbeWSizaQV2oyvxi8erqxh44N954JSxY+oYmRGS+m5q/Pr44Z8oLxsVTV3u5a2Na0X5ZBgy5Ld7rcvsyfPovpAk+BmRPqhH02nlHM7jF+qzQmtfboDZcEpaV3UuP79kYPacv6uehhDkM3rgDhhd+3SFt7OWmBM4F3WLpstHnAEVD1GceSCd51/X9XPaSf86TkIdnceQC4Q973utZGM/wejyrBmPOsPe1zNjqvgYWcDVvyiTAzP0ydwR6SXnUo0n4PAJR909R
 hFSFShka
 ZISPVwc09ebpT2AeeP8EPK+55CwWFj4efWEaHhL/IudXeSrmtv8jHo6HGSyAe9qPJOzaAyH1/l2QKRw9UmRlcJTKrs/2OXknVNG8RvhrA0bwWAass/NMIp4SYDYX2ufYfkTyFogo/aRWeM9/HADUox93YBE9trKabcCgFLyc9ZLKgvktycbn5KsiLMDYxyANJuIBUYnVivEZ29Zfc1C+vylea0aw7Gx37+Jq09VSD8gsvjie6FQXCfwN7jWdz/B89Dsz9X73hXOVcnenjrSd2O+qCFKWVtrEdWZqK4GQc6Uz5z3DyMzH5nI/JnNIYfsCItoa/vWXPdCSFDb/9hnw6pRXBfSZWu2D+XkN/Ylb+8EMEn3ufSQ3RmYdVAV+UrTK3J9GkdZ3jmVKNuXFxAv/UwzrDlZ+PkRhc9FGpCWH5fwh31cPEP/H5mP4tm3+L37luSpGZkuqfJprxPN91PHLgjc/RqR5++VzVLnAviec+k51AHamdQ/+41AjWlyDGmU1yqyufFq7JG9xFvR9uRlNCPsudAP2b9Xbko5yMLeels51plP/ebvV4ysDHInnvr/D16CDaqWbC7+deb/JHTgZRTca1tSny2lEspY+C7KMiF35O1ow=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This long awkward name is for consistency with
CONFIG_MITIGATION_PAGE_TABLE_ISOLATION.

In the short term, there isn't much arch code. In the medium term, it
will mostly be x86 code. So, put the code where it will need to go
instead of just having to move it soon.

In the long term, it should probably include other archs too, so
things should be as arch-specific as necessary, but not more so.

Follow the proposal by Mike Rapoport[0]: a generic header includes
NOP stubs for ASI definitions. If
CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION is defined then the asm/ tree
must have asi.h, and that gets included instead of the stubs.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/Kconfig               | 13 +++++++++++++
 arch/x86/Kconfig           |  1 +
 arch/x86/include/asm/asi.h |  5 +++++
 include/linux/asi.h        | 10 ++++++++++
 4 files changed, 29 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index bae871976d36f7b6b2af0be40a067ca2b3fd3d14..ad99637630406e5a484173f5207bbd5a64b2bf1f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -17,6 +17,19 @@ config CPU_MITIGATIONS
 	def_bool y
 endif
 
+config ARCH_HAS_MITIGATION_ADDRESS_SPACE_ISOLATION
+	bool
+
+config MITIGATION_ADDRESS_SPACE_ISOLATION
+	bool "Allow code to run with a reduced kernel address space"
+	default n
+	depends on ARCH_HAS_MITIGATION_ADDRESS_SPACE_ISOLATION
+	help
+	  This feature provides the ability to run some kernel code
+	  with a reduced kernel address space. This can be used to
+	  mitigate some speculative execution attacks.
+
+	  ASI is not yet ready for use.
 #
 # Selected by architectures that need custom DMA operations for e.g. legacy
 # IOMMUs not handled by dma-iommu.  Drivers must never select this symbol.
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1fd698311bc1dba134a8e14dd551d2390e752cda..cb874c3857cf443c6235e05bc3f070b0ea2686f0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -38,6 +38,7 @@ config X86_64
 	select ZONE_DMA32
 	select EXECMEM if DYNAMIC_FTRACE
 	select ACPI_MRRM if ACPI
+	select ARCH_HAS_MITIGATION_ADDRESS_SPACE_ISOLATION
 
 config FORCE_DYNAMIC_FTRACE
 	def_bool y
diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
new file mode 100644
index 0000000000000000000000000000000000000000..53acdf22fe33efc6ccedbae52b262a904868459a
--- /dev/null
+++ b/arch/x86/include/asm/asi.h
@@ -0,0 +1,5 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_X86_ASI_H
+#define _ASM_X86_ASI_H
+
+#endif /* _ASM_X86_ASI_H */
diff --git a/include/linux/asi.h b/include/linux/asi.h
new file mode 100644
index 0000000000000000000000000000000000000000..ef640c8e79369a9ada2881067f0c1d78093293f7
--- /dev/null
+++ b/include/linux/asi.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _INCLUDE_ASI_H
+#define _INCLUDE_ASI_H
+
+#ifdef CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
+#include <asm/asi.h>
+#else
+
+#endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
+#endif /* _INCLUDE_ASI_H */

-- 
2.50.1


