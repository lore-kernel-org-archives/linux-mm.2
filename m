Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28EFDC87FC5
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B2698E00C6; Thu, 24 Jul 2025 19:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8143E8E007C; Thu, 24 Jul 2025 19:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E3F8E00C6; Thu, 24 Jul 2025 19:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5217D8E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D0EF31DA803
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:26 +0000 (UTC)
X-FDA: 83700772092.07.6E9C95B
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id E23E8120009
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=bq54yZxK;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pn/2JSdO71rXzNO2stWjtKSzEMWnL5mCAakTnDwVXrM=;
	b=KIaCnETPLqt+3WJbIdJ9BvtEJSvG+5mC5+JAEZQk85Zs+664dkFtIyfCS9dpIfa7DqkqmG
	qPT9TYajt+7lRkWY7S7U9tiraxCXeEn1c3fKxfzGllA1Zepjf0RSd4nT+oPC1A/8wNg+yz
	PMRmKebNBJsfSr3DCJESAVVcbAVdEv0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400245; a=rsa-sha256;
	cv=none;
	b=z1XY2MF5qcDVnSjmaC2L1HrWSXvoF/pWyOOENGnYnxs2WceLcw94IkAVylADfPIMgfg5Dv
	1WYoWndZqhnjn5FJ7+ripC813sbyoS++/lUvWOTnfjqSZ+0sZXitsr/20Auisc4HEycPNS
	2FZM603ZHaOQfrZUmZ7+psxIShNLauY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=bq54yZxK;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-234fcadde3eso20912615ad.0
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400243; x=1754005043; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pn/2JSdO71rXzNO2stWjtKSzEMWnL5mCAakTnDwVXrM=;
        b=bq54yZxKMZZ+yj8Xtfs+LDrfgJWnheWocj0vvbFNeVTKr5A5bnFkEuyRyMoCQFX/hS
         PvU2nNZZvtc37Q20teceq1bvBAdG4x7Yr4lUttvr6MWEL6BTN70wHULk6DAqT272t+LQ
         vk9nBdL9hLOz9oBfmMR34V5MFryDfTRJrpYJrTq5QY1On4eYavXwwsu/g6DkPjQw3lqR
         kokoaSAttD5OeROfsgaSvW9NmuQG9c8oSxaQa2Wa2RvGcdbTLMmA/54q29i+3pFUlOn5
         DsDD77rD6+LXY8dZfi6A/XD5egloOBXP4lAnOfnrYSL2ZMukCMtubzW1hfHWeir7TlAS
         5MJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400243; x=1754005043;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pn/2JSdO71rXzNO2stWjtKSzEMWnL5mCAakTnDwVXrM=;
        b=T0dyLTm5Xz5MjhVlLO1+kuyvl1a5uKRivzr3ZJQdm4lNL3rhMU51+1mPXZk6dGqQ8Q
         Mba2RKyhGucZ0rosB8G6Uq1PBU//3oVEdAQ4UVq4vMqRrrgpajgo4KRSAjRrbsKgL2hI
         pM51jXsy4nj6YC2M7w5KriYT2ivWCo4icN0XlaSRkkE4qgMyDwkhimIw7c5tLLT61lMf
         vapEU14FGVdCc3mvweRHSTySzQqHwhC9RtUaJlct0XK1oxRaXfKdLjKFOYxXXtehG4aG
         v+n1XLNvV270WhxDxasDX+ycWbfk0SimEG60WMQw1v5zcWsDCut58nk1M8hLLds3Hkui
         BSJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqg+rzC6Po7jPNEeAEPtV2ymlN7e4H0W9T033qdZea6/PyIE7/hhZk0E1DBCwTiYs3VkECmjumMg==@kvack.org
X-Gm-Message-State: AOJu0Yzmf03ifgBAcHkcUTBInMo0jPVoLcjT0fRZdnygQDVHgpk8WhPB
	4AB0765khXe3HmurMC0zFQ8s0qc/+0AWSlU6Ju7aBxwVh93Vodz7+UFmKe7/YYIF+X7oOLV+0uy
	a1jk8
X-Gm-Gg: ASbGncshHQXy90JQ5pnOPkgovGRlhhD6fLlsuet1CP84ISFZTE2RbQJ3x3Z33b0jk1a
	JIm5gEY+C66f/Ba45KN9IQ1Kh8Iwa9QMlQO18hfOa73k1y/q7+O9pHY4QVxkkTXSH63NzBiLwcE
	62xNl2wbIB7zPYBu4EqJaQfvlRLONGMPGWOHMa8oo5dkkz0h3wenUcqIdwWUpsnGZLTTK71GGeu
	+PeRr6COaHuF2dZiqUmZu3CLn+GNJ9tFwnMc2eoLn8Gvg0WI9uR3xa4EssuL+47Y61zUaFfNRYx
	rz/+G9iAox3f/y0UOcQZ7r6LKhAviYKAa1hDmqjqQQqPm+4lnx/ZfONNNXfjZ7O87cU/uy4e9Jy
	csYnQSrjRXLo1KYaZy4IQGipvTCAd8eo8
X-Google-Smtp-Source: AGHT+IG/G30hZbdmg+vYLTFJ4nOwJXxTBe4ZWwYMeNmIug6yYy0RZhNu1ZgYT+kQPlkJisfs0XgYFA==
X-Received: by 2002:a17:902:e54e:b0:235:ea29:28e9 with SMTP id d9443c01a7336-23f981b0a15mr141134525ad.38.1753400243473;
        Thu, 24 Jul 2025 16:37:23 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:23 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:37:01 -0700
Subject: [PATCH 08/11] riscv/mm: prepare shadow stack for init task
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-8-04b8fa44c98c@rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
In-Reply-To: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@redhat.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Monk Chiang <monk.chiang@sifive.com>, 
 Kito Cheng <kito.cheng@sifive.com>, Justin Stitt <justinstitt@google.com>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 rick.p.edgecombe@intel.com, broonie@kernel.org, cleger@rivosinc.com, 
 samitolvanen@google.com, apatel@ventanamicro.com, ajones@ventanamicro.com, 
 conor.dooley@microchip.com, charlie@rivosinc.com, samuel.holland@sifive.com, 
 bjorn@rivosinc.com, fweimer@redhat.com, jeffreyalaw@gmail.com, 
 heinrich.schuchardt@canonical.com, andrew@sifive.com, ved@rivosinc.com, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E23E8120009
X-Stat-Signature: bhr8h7fw8kxnf17bdbwjsoz9bjh63zeg
X-Rspam-User: 
X-HE-Tag: 1753400244-316854
X-HE-Meta: U2FsdGVkX1+yy4Rv7kwraeim18tumA+aNAPVbAQJCO99T60ysyR8pREfuC0pqOVSXEJSy2HO+/I9EobllfX/eEWZOu6XPFcR20bWK7wJeUrOTuz8DcU/UQUp5zF3LiyZGeMKcQL0tG3nbVhxLFViNftrr0aVog7ssbqGZlxLHRFiWCHLbLEi9lUkBbGLs/IL3Rr1XFA98lQ4nSBdx1jgrZz7WTHkI06GP6bHC2ndzO1fAL69hiymWnxliLELZpmJCvNPzowElFHULK3La63wzl+Wyl0vvvCUZbYcL3YsUIOP3vnwH8OekgK72EdCQjJqCXbxvJSvjXLqscwfsM3ySMOp3ptfEQ6Lfg4a7YCC4iECqFXI4W+7Y+jAYfQlvh91tobBW84T0WRXKIGSgnfmQNApAQBjVlfPyH+zpqG0DvQlsMO/qZvruBkrDWYL7mA6VXpJqcXcTux7Ja1LA9wlW9CZItAP1gocGk3nMgK22J5fNSfz9tj402YY+r7K/Sd/5ZsT3Pnrw+d7lp9fRhq8kRUKOHuv9r22nrf2UGKfUBN2lxKO+ugsyRzC0qxYdBCoB49vyFJWteilNHQhqV+0fw70inJA/a4Z5y4uf/dkvh/Nk0VD/8hQhnQ59+6tBNIFqINFARYQTKdKB3L0OLQmEs5o6s/Yetqs/r+PDHvXDSmxgcAmZ3sRnvWuSJfsA0oocOLO4KnJIEvzJc5K0DFJK2415s3FO0f1JjZE8TDBZj8BNUOt+Y27mClwFMFspvZGmX4r+ZKe9qtjIqMUPfeX+F9XL3SBszb+dQ3EMGFWd7HwWED55CXxH+bk59e/ilrlbDc8JTx24QGIKUB7XBhytXtnkzNs2uBjsM06TNMdYV3stxyE5GlktXAMMWkBvHZ8d0OJDKOuXejXDFCGUTh2RCftKCJA8EkjY60aVfxr2GReyUA1+DVdO8j5jz9qQ1b3OhzNOb4Xkb984lHbxc8
 vjn02ciq
 rYV32S8BQet2/bWOIB7bx2DRTHzZuibV1QR0AEqOuk18Z40emwgmM5cwdVCELgoGkunJ2vQIeHkjZ4KYWPAQ9Qf/yqkD9DwO5fbiATi4mtmq8IwZu+er8ijSgZmGPMXss0BnAIAHm/rxHnosC41/MU7w5vYM5HYSlrt6AhqSrkPESy0u0USYaIqvQVk0mpSPspUTtKBqs8vEbCYXepmXqW2zf/tJcHy79VCZvQcEg/3Xm6rrsfyD479XDpFOyGs5B+7nbsCewFf/ubu1WAqjxCfWquFPE7aG0pedoY7eKhd459Uyjlu3KuLKNmD3czMDcsFM6Y0GqNBtFeyH8xFzgMzBr1FL3ZNwNF7QVJlPizl0wR2i+K2aEuQnnF7I5olv7owliV4p+oivMfKS9HVT1fi33ExLvFuajSJ7DBgtkFldvOm4muu+a9pe3Cmn7kmBfMXHbRvRH8C1llgXzY3xvXwKbvdM2jcgXmJDS04vZvRH8abM7HVJpbdJxEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With CONFIG_SHADOW_CALL_STACK, shadow call stack goes into data section.
CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK indicates hardware assisted shadow
stack are used. Hardware assisted shadow stack on riscv uses PTE.R=0, PTE.W=1
& PTE.X=0 encodings. Without CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK, shadow stack
for init is placed in data section and thus regular read/write encodings are
applied to it. Although with CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK, they need to
go into different section. This change places it into `.shadowstack` section.
As part of this change early boot code (`setup_vm`), applies appropriate
PTE encodings to shadow call stack for init placed in `.shadowstack`
section.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h     |  4 ++++
 arch/riscv/include/asm/sections.h    | 22 ++++++++++++++++++++++
 arch/riscv/include/asm/thread_info.h | 10 ++++++++--
 arch/riscv/kernel/vmlinux.lds.S      | 12 ++++++++++++
 arch/riscv/mm/init.c                 | 29 ++++++++++++++++++++++-------
 5 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index f04f3da881c9..bb80667d3c13 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -202,6 +202,10 @@ extern struct pt_alloc_ops pt_ops __meminitdata;
 #define PAGE_KERNEL_READ_EXEC	__pgprot((_PAGE_KERNEL & ~_PAGE_WRITE) \
 					 | _PAGE_EXEC)
 
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+#define PAGE_KERNEL_SHADOWSTACK __pgprot(_PAGE_KERNEL & ~(_PAGE_READ | _PAGE_EXEC))
+#endif
+
 #define PAGE_TABLE		__pgprot(_PAGE_TABLE)
 
 #define _PAGE_IOREMAP	((_PAGE_KERNEL & ~_PAGE_MTMASK) | _PAGE_IO)
diff --git a/arch/riscv/include/asm/sections.h b/arch/riscv/include/asm/sections.h
index a393d5035c54..ae7c6fcbaaeb 100644
--- a/arch/riscv/include/asm/sections.h
+++ b/arch/riscv/include/asm/sections.h
@@ -14,6 +14,10 @@ extern char __init_data_begin[], __init_data_end[];
 extern char __init_text_begin[], __init_text_end[];
 extern char __alt_start[], __alt_end[];
 extern char __exittext_begin[], __exittext_end[];
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+extern char __init_shstk_start[], __init_shstk_end[];
+#endif
+extern char __end_srodata[];
 
 static inline bool is_va_kernel_text(uintptr_t va)
 {
@@ -31,4 +35,22 @@ static inline bool is_va_kernel_lm_alias_text(uintptr_t va)
 	return va >= start && va < end;
 }
 
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+static inline bool is_va_init_shadow_stack_early(uintptr_t va)
+{
+	uintptr_t start = (uintptr_t)(kernel_mapping_pa_to_va(__init_shstk_start));
+	uintptr_t end = (uintptr_t)(kernel_mapping_pa_to_va(__init_shstk_end));
+
+	return va >= start && va < end;
+}
+
+static inline bool is_va_init_shadow_stack(uintptr_t va)
+{
+	uintptr_t start = (uintptr_t)(__init_shstk_start);
+	uintptr_t end = (uintptr_t)(__init_shstk_end);
+
+	return va >= start && va < end;
+}
+#endif
+
 #endif /* __ASM_SECTIONS_H */
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index e066f41176ca..5bcc62cf5a0a 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -79,12 +79,18 @@ struct thread_info {
 };
 
 #ifdef CONFIG_SHADOW_CALL_STACK
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
 #define INIT_SCS							\
-	.scs_base	= init_shadow_call_stack,			\
+	.scs_base	= init_shadow_call_stack,	\
+	.scs_sp		= &init_shadow_call_stack[SCS_SIZE / sizeof(long)],
+#else
+#define INIT_SCS							\
+	.scs_base	= init_shadow_call_stack,	\
 	.scs_sp		= init_shadow_call_stack,
+#endif /* CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK */
 #else
 #define INIT_SCS
-#endif
+#endif /* CONFIG_SHADOW_CALL_STACK */
 
 /*
  * macros/functions for gaining access to the thread information structure
diff --git a/arch/riscv/kernel/vmlinux.lds.S b/arch/riscv/kernel/vmlinux.lds.S
index 61bd5ba6680a..e65c0c099ed0 100644
--- a/arch/riscv/kernel/vmlinux.lds.S
+++ b/arch/riscv/kernel/vmlinux.lds.S
@@ -129,6 +129,18 @@ SECTIONS
 		*(.srodata*)
 	}
 
+	. = ALIGN(SECTION_ALIGN);
+	__end_srodata = .;
+
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	.shadowstack : AT(ADDR(.shadowstack) - LOAD_OFFSET){
+		__init_shstk_start = .;
+		KEEP(*(.shadowstack..init))
+		. = __init_shstk_start + PAGE_SIZE;
+		__init_shstk_end = .;
+	}
+#endif
+
 	. = ALIGN(SECTION_ALIGN);
 	_data = .;
 
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 1af3c0bc6abe..dba1cf3f8dfc 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -794,14 +794,22 @@ static __meminit pgprot_t pgprot_from_va(uintptr_t va)
 	if (IS_ENABLED(CONFIG_64BIT) && is_va_kernel_lm_alias_text(va))
 		return PAGE_KERNEL_READ;
 
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+	/* If init task's shadow stack va, return write only page protections */
+	if (IS_ENABLED(CONFIG_64BIT) && is_va_init_shadow_stack(va)) {
+		pr_info("Shadow stack protections are being applied to for init\n");
+		return PAGE_KERNEL_SHADOWSTACK;
+	}
+#endif
+
 	return PAGE_KERNEL;
 }
 
 void mark_rodata_ro(void)
 {
-	set_kernel_memory(__start_rodata, _data, set_memory_ro);
+	set_kernel_memory(__start_rodata, __end_srodata, set_memory_ro);
 	if (IS_ENABLED(CONFIG_64BIT))
-		set_kernel_memory(lm_alias(__start_rodata), lm_alias(_data),
+		set_kernel_memory(lm_alias(__start_rodata), lm_alias(__end_srodata),
 				  set_memory_ro);
 }
 #else
@@ -959,14 +967,21 @@ static void __init create_kernel_page_table(pgd_t *pgdir,
 static void __init create_kernel_page_table(pgd_t *pgdir, bool early)
 {
 	uintptr_t va, end_va;
+	pgprot_t prot;
 
 	end_va = kernel_map.virt_addr + kernel_map.size;
-	for (va = kernel_map.virt_addr; va < end_va; va += PMD_SIZE)
+	for (va = kernel_map.virt_addr; va < end_va; va += PMD_SIZE) {
+		prot = PAGE_KERNEL_EXEC;
+#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
+		if (early && is_va_init_shadow_stack_early(va))
+			prot = PAGE_KERNEL_SHADOWSTACK;
+#endif
 		create_pgd_mapping(pgdir, va,
-				   kernel_map.phys_addr + (va - kernel_map.virt_addr),
-				   PMD_SIZE,
-				   early ?
-					PAGE_KERNEL_EXEC : pgprot_from_va(va));
+					kernel_map.phys_addr + (va - kernel_map.virt_addr),
+					PMD_SIZE,
+					early ?
+					prot : pgprot_from_va(va));
+	}
 }
 #endif
 

-- 
2.43.0


