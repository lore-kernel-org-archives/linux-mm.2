Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DDECAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D68F8E0001; Wed, 24 Sep 2025 11:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE088E000F; Wed, 24 Sep 2025 11:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34CA58E0001; Wed, 24 Sep 2025 11:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19CEC8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:13 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CB6771608CB
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:12 +0000 (UTC)
X-FDA: 83924454264.08.1DA3FBE
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8638180025
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tZsy5NUf;
	spf=pass (imf24.hostedemail.com: domain of 3eQfUaAgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3eQfUaAgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5r90z2IR0Gemmlb3xWRzXWwMPPH2fiEvwZqfzBajcPU=;
	b=d3iM7k1jjhcjbOl6WwB3NXBisTBldf4HSo5rg+d0EmqUrYHBSFY7U+GvlwmdXrwTKwG2Cz
	Zm6D0AfiDuvDFqnQuxkJE8sTVzCyxI2GEy3/r7ksJLvynULyni+ucy/KocXJ1MSgWKubWp
	hPaXsCztzl8vHAwvBtD9vHpNB2h2F7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726011; a=rsa-sha256;
	cv=none;
	b=UHYPaIg0/GuuUjU3UvYASZ68DgmAa/9vclDHcdUWgeEED+1aRNNHJQuadGqSTbyhGDJVlA
	rm2yng2rSqOSchqvLR9ltmKREXm5oqqP2+gAJaslqx8V3jworpX0inonpWiNo/CgHr65WO
	hihYTftDLh8WVxOW1oPiN+6XxiAOVgw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tZsy5NUf;
	spf=pass (imf24.hostedemail.com: domain of 3eQfUaAgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3eQfUaAgKCCYLCEMOCPDIQQING.EQONKPWZ-OOMXCEM.QTI@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b07c2924d53so355567866b.3
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726009; x=1759330809; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5r90z2IR0Gemmlb3xWRzXWwMPPH2fiEvwZqfzBajcPU=;
        b=tZsy5NUfEa1nLsr7YqaaHcvCGYyUlIzTyiYtMjK+4oy7k0j/6MFrkwZmxgH/wOBi6a
         z4nlql9xE9mc1MIEWCvINPJxTbPO3RAtp/iUiJZfdpwwMWuiH4j30nFpTdm9u7D3e8QN
         SdUrJUcx/bZDQTqtOcO2DFAzb1O2dBY63Q6GSrrfKSYW5XgSOmAMNfARva4ynH2LxIdQ
         Xs8surpsRChb+4Ri+Qo3XIQ0oQbwAkmafZRvfQz27Md3xf7B3sseL3KpiIOPQTG1jPOr
         glfmFrskGWu/9FY0qQ0ywUzznZLgZzODwiVFHx+wyhkJ1fWxg/TlO+TwecZaB4b8teJR
         J86w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726009; x=1759330809;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5r90z2IR0Gemmlb3xWRzXWwMPPH2fiEvwZqfzBajcPU=;
        b=De2WrmfEqs1rntbjfxyzOm+aBG5OqC7233VOT4mZBY0S7ZvvotDSH2FVfOGPdFd+WV
         8Dtp1to1XoqzJ0c6Atb9q5rYaAaTfEleamFjeNo0CkJyt7S2L2PicEP3jTFdVhjgqLhF
         ZNfR5rUF7ZL7OQvllm0f9vHRiaXn9cxViaosNRuAwP/b1TChiybxSYODu7plOGYPHZ8c
         tkVKQIAz4d5/Jzr+sgQA9+ceKRYgBc4soXAAaVwH9u2u4bEWOXHZmD3xpCH3UXkHZmju
         j1wFeW8upCGEeaSO8K5L0S6I4PZ9CeMANYklQ60rO4Ys5CjCV0JJrXPjSd4ZtfQR200G
         z8ug==
X-Forwarded-Encrypted: i=1; AJvYcCWLw0d+EgUr+GfPYVLvzFW90hSERuhWrNItirTKdmETERhc3KWGybVcxZ2bFVQJUY8mmhBwsNUwJw==@kvack.org
X-Gm-Message-State: AOJu0YwMQAiNDKukRvwSH11bPLmrHWtQ2kKVoYmJWfPLYmCtJjuBNXhf
	4ufxyk1bjDeKx7nCG/On1WM2J0UbTWXaSAOC9avdDb8SCceceh/cHNKMEMHd3yIz15B9xYma4dk
	6xaO4lPSoHGUfOw==
X-Google-Smtp-Source: AGHT+IHX44fYosJyVsS9pPKUxPF4QsPRR2phTVeYFYZ8rkhn5hEuqP4aCDJC7cWbgd2p6O99Y3BBHqDWpl1tVg==
X-Received: from ejcti11.prod.google.com ([2002:a17:907:c20b:b0:b2c:9261:eb0f])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:86a6:b0:b28:6440:a85c with SMTP id a640c23a62f3a-b34bc9720a6mr11837866b.50.1758726009211;
 Wed, 24 Sep 2025 08:00:09 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:37 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-2-2d861768041f@google.com>
Subject: [PATCH 02/21] x86/mm/asi: add X86_FEATURE_ASI and asi=
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
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: faqkmh99y4ukucmw8ef5eqtqn64ihqw9
X-Rspamd-Queue-Id: D8638180025
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758726010-265573
X-HE-Meta: U2FsdGVkX1/KdHTFUiBhP52hI3+gdW1jIc6WEonAYG0KcSYSepuEYWre8bcEHQDOT0zK+4+61dPc0KhKCKfjSqBW2i34+6dAH5k48yNuAFiOoAcoNDJlN5GFBugW0qYTuf2p40bjDBlYpy8UzuqXgtB1ATQAy6BREojdfyISMFq9hnW6LkKW2hKIo4DVRkFSx+bElhYSwmlAeVsAlqtsfG0/EG24Jn5c2Tj5dCrQETI+yqv1SXvRE5JWVRScU6ysdz6CUWTcNDd6I4jTC5UyV4AZkvY1pnOlex1ngieg+2VeqwcWoVlzG4QCrrXwfBKt5YHNnhefSB+B+CJLzHs0MD23yL1BQFSNeMY/2Rt0vD3YbfKk5ZoqJUo3Th78082occruP7yoEe8Xl3foUeEta260QEHGMXEj/Tzq5q5CSm8POYakBTdUXrpKzs94tFEZ0SIN67Ri4rmsqOdvDmQIy/OZ6LWBo2OCza2YhCSNhGEGlvmAoBIVZK8V9AYNqgTi0MtzQ3JmW3xZTWnQDgmRN9VZXZUL1TVjsJLYqITZWNz5O/AcU2cfEWcrW0c2MNyK50ybLxg9kmHZuYYNr6c5QKqq3e+1h7dhLyK8XauClXT/ZmGZcOJQFWEoHUbZdiApbLSXQ8qYMY1NIM46spUmwbfxfv50qyzj3h3MKsFMPPiOgmlzdmAXBNuMxdM1jg67VXW1yEotO0uI4urIpDfwTwtmyqLoHEBCCZV9si8LIG6l1UOvlVfuQJaMW2f5Ev6YaaR/IRcuQsm6/omIxDm2TTfwSZ5VESAF3MlEhlvdPxXIooh+I/xcWkUpyhouHXgUwkjix5gmTClMrwqEAwNpdszFJii8IbETH3HtOL8DPQXCUcf4e9qjioFeOYEIeG4ZMuLpfH9KnbHTbZkimh+hg/OxcDUr3IiUQLCim4tEliHb/aTYAVekMIcESQt2Vg9shVgBmBL0XHTiWJc0oXO
 zKnTR+zv
 4A4165TKejTdcaHRgBP5ZrdLVkzCnBaLi5/W/bD2bBEk/laS85fiKZ69RWq/Qj9WfHRDbo1fLGqISmKqvVfcToHIGO5mCnqavxJE0pIZ27NBGD6v0DX0j1Onz96dNSW3esKQ90ee7t2dWrLFjZ5XgVGtTDTFq9nqNZ4tozkzxuEkCo09agItawyii8iU5AmVDQ2yGP1XliGu04HpQubwxUlwad87PKIPUfSNJeWfdYhPkKiBecKDnNrsQjgI7qoH4Ctd1umXJla6aBKu1vTVwLEGP3ASF+0j5C0OaDtmhbTOwY+0KsgmMJrc3z11vjaxxjjPCvxHlPjIAgSUyOXm501Fi3g0cH/4lxvqNoD6+ccvA6u0c1W6tYVjWApuT+oW72nAwgnBvhn33V1EgbTDKnUSZpmY095ft606sV0DPT+65AsSn9ded+rOXQl07ep0nfs0zFdBbjAubtIfpmME02KgoO8tI6ITj6sXnsyHj5YJDQAMKctq2aubNlHbzDFQg6GJk8KVCsBF3U0ndtXN2F8TCM2k2Inh1fJu4ONzFeTl9sslMoeyhRF4oVrP6qyZMJWM59PLGrwu5HioeUZrL05LiW9s8C6C5oHE1hBOc/pCQuEM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a CPU feature to enable ASI, and a command-line flag to enable that
feature. At present, the feature doesn't do anything, but adding it
early helps to avoid unnecessary code churn later.

The cmdline arg will eventually need an "auto" behaviour, but since this
would be equivalent to "off", don't define it yet. Just define what's
necessary to be able to test the code.

Co-developed-by: Junaid Shahid <junaids@google.com>
Signed-off-by: Junaid Shahid <junaids@google.com>
Co-developed-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 Documentation/admin-guide/kernel-parameters.txt |  8 +++++++
 arch/x86/include/asm/asi.h                      | 10 +++++++++
 arch/x86/include/asm/cpufeatures.h              |  1 +
 arch/x86/mm/Makefile                            |  1 +
 arch/x86/mm/asi.c                               | 28 +++++++++++++++++++++++++
 arch/x86/mm/init.c                              |  3 +++
 include/linux/asi.h                             |  5 +++++
 7 files changed, 56 insertions(+)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6c42061ca20e581b5192b66c6f25aba38d4f8ff8..9b8330fc1fe31721af39b08b58b729ced78ba803 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5324,6 +5324,14 @@
 
 			Not specifying this option is equivalent to pti=auto.
 
+	asi=		[X86-64] Control Address Space Isolation (ASI), a
+			technology for mitigating CPU vulnerabilities. ASI is
+			not yet ready to provide security guarantees but can be
+			enabled for evaluation.
+
+			on   - unconditionally enable
+			off  - unconditionally disable
+
 	pty.legacy_count=
 			[KNL] Number of legacy pty's. Overwrites compiled-in
 			default number.
diff --git a/arch/x86/include/asm/asi.h b/arch/x86/include/asm/asi.h
index 53acdf22fe33efc6ccedbae52b262a904868459a..32a4c04c4be0f6f425c7cbcff4c58f1827a4b4c4 100644
--- a/arch/x86/include/asm/asi.h
+++ b/arch/x86/include/asm/asi.h
@@ -2,4 +2,14 @@
 #ifndef _ASM_X86_ASI_H
 #define _ASM_X86_ASI_H
 
+#include <asm/cpufeature.h>
+
+void asi_check_boottime_disable(void);
+
+/* Helper for generic code. Arch code just uses cpu_feature_enabled(). */
+static inline bool asi_enabled_static(void)
+{
+	return cpu_feature_enabled(X86_FEATURE_ASI);
+}
+
 #endif /* _ASM_X86_ASI_H */
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4091a776e37aaed67ca93b0a0cd23cc25dbc33d4..3eee24a4cabf3b2131c34596236d8bc8eec05b3b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -499,6 +499,7 @@
 #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
 #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
 #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
+#define X86_FEATURE_ASI			(21*32+17) /* Kernel Address Space Isolation */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5b9908f13dcfd092897f3778ee56ea4d45bdb868..5ecbff70964f61a903ac96cec3736a7cec1221fd 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -52,6 +52,7 @@ obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS)	+= pkeys.o
 obj-$(CONFIG_RANDOMIZE_MEMORY)			+= kaslr.o
 obj-$(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)	+= pti.o
+obj-$(CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION)	+= asi.o
 
 obj-$(CONFIG_X86_MEM_ENCRYPT)	+= mem_encrypt.o
 obj-$(CONFIG_AMD_MEM_ENCRYPT)	+= mem_encrypt_amd.o
diff --git a/arch/x86/mm/asi.c b/arch/x86/mm/asi.c
new file mode 100644
index 0000000000000000000000000000000000000000..8c907f3c84f43f66e412ecbfa99e67390d31a66f
--- /dev/null
+++ b/arch/x86/mm/asi.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/asi.h>
+#include <linux/init.h>
+#include <linux/string.h>
+
+#include <asm/cmdline.h>
+#include <asm/cpufeature.h>
+
+void __init asi_check_boottime_disable(void)
+{
+	bool enabled = false;
+	char arg[4];
+	int ret;
+
+	ret = cmdline_find_option(boot_command_line, "asi", arg, sizeof(arg));
+	if (ret == 3 && !strncmp(arg, "off", 3)) {
+		enabled = false;
+		pr_info("ASI explicitly disabled by kernel cmdline.\n");
+	} else if (ret == 2 && !strncmp(arg, "on", 2)) {
+		enabled = true;
+		pr_info("ASI enabled.\n");
+	} else if (ret) {
+		pr_err("Unknown asi= flag '%s', try 'off' or 'on'\n", arg);
+	}
+
+	if (enabled)
+		setup_force_cpu_cap(X86_FEATURE_ASI);
+}
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 8bf6ad4b9400e7a04e9dc4e341e20a4a67ddb7ab..b877a41fc291284eb271ebe764a52730d51da3fc 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/asi.h>
 #include <linux/gfp.h>
 #include <linux/initrd.h>
 #include <linux/ioport.h>
@@ -761,6 +763,7 @@ void __init init_mem_mapping(void)
 	unsigned long end;
 
 	pti_check_boottime_disable();
+	asi_check_boottime_disable();
 	probe_page_size_mask();
 	setup_pcid();
 
diff --git a/include/linux/asi.h b/include/linux/asi.h
index ef640c8e79369a9ada2881067f0c1d78093293f7..1832feb1b14d63f05bbfa3f87dd07753338ed70b 100644
--- a/include/linux/asi.h
+++ b/include/linux/asi.h
@@ -6,5 +6,10 @@
 #include <asm/asi.h>
 #else
 
+#include <linux/types.h>
+
+static inline void asi_check_boottime_disable(void) { }
+static inline bool asi_enabled_static(void) { return false; }
+
 #endif /* CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION */
 #endif /* _INCLUDE_ASI_H */

-- 
2.50.1


