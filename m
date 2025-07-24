Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EC4C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 23:37:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F416B035F; Thu, 24 Jul 2025 19:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB8316B0361; Thu, 24 Jul 2025 19:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80216B0362; Thu, 24 Jul 2025 19:37:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B12A36B035F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 19:37:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F792C0588
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:10 +0000 (UTC)
X-FDA: 83700771420.25.BA44865
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8519420008
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 23:37:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=TNUhSrfo;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753400228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=krQk4P3pfTRPUT5p9FwZ7J0ulZx2x20Cletpatu8lvU=;
	b=zuxAsdoXFO+EXKdDd1P070KKEDeMtzwkiCevd7eqh4W8lYprnT8Y7Tu/CbK3dNHwOgDjyx
	fTQ8AbgOqveuqG93NiQjWe6TbEHMdzAzGpG/XOyreyRp1mpyjta9hd5I/ClPIJocfuP+zy
	tKu97XW0gGtAsksFH+FCyD72e6LF0pk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=TNUhSrfo;
	spf=pass (imf03.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753400228; a=rsa-sha256;
	cv=none;
	b=iRM2FoYCYw1lvq750mPgelNnT5wFN509Ys7T6khBgbcQkFuVm+nIiVIeAc3MduG+ycOh/s
	lQ3BevI4pYn+Z/XTy7BcP+5vdnTfdX33CECB5QgFw7iIA82p4gsU+WeTpKYEdUcxnJlea4
	zA/Q7MNHNbWKaDiEK20jxIbZshrwBIQ=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2350fc2591dso19146125ad.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 16:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753400227; x=1754005027; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=krQk4P3pfTRPUT5p9FwZ7J0ulZx2x20Cletpatu8lvU=;
        b=TNUhSrfoVOukzJyhkqA6s6SfXEsC0dvyEHlpgVhnsmShexbA3p9d/35rtuIPeMTrbH
         Y5475Q8in5+oA/vg+TLz3fUkcGUOjR1RXh/ZwmJw3SnB/EIa9WDSithdBusJ/gB1Z/oA
         9pSLyB7hx2K3O/2xQ8IdK4JKkEchd5l+IkLgYjjDvx/b5Q/mfzB+tyNunfkR8B96dcyE
         9u69aH1DBeuidO0tzCpwqjTpBnuBNK5nx6W5ZIAsDRKT1w9akXlL+F3VymotatVbuCqJ
         WB3f4zIkxek8aiIbRfml+3HtF1t7i7bwY116C+2lc3Fv5yjgydixmDE/aCDOJr1qAOGF
         UQTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753400227; x=1754005027;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krQk4P3pfTRPUT5p9FwZ7J0ulZx2x20Cletpatu8lvU=;
        b=YBzXS6tXI+eBIfdUlJ9a9IVsrj/D318T0AZ8l0mxFtnhLYwL0zLXEQxuPBMoyKUqGd
         EgRPATLRo1ZlpuQ7pA4DbK8AZB/+botNi0xi/1J99u65O9l8FWTqdHr8rjUWNq+g5EMJ
         1jD9413HZMjOHXrzMgG1Qv/6R5Jx2x8QNGd8KXWA1mYbPxyQLdNjCdMksYS6iS+Lao3+
         csBY4G8rQ0vqgrw9jO4nJRbFIJB51y9WZyYppLfI3jPD4mWZ5LiXwc2msugXahSlBi8m
         l4WKzNEOOsGEZ8cTzq4vjg7u9JuqOraZ3Lczjrj2a1/QkZ4TeXP1pNNSOFzy8bPLIxEJ
         eFgA==
X-Forwarded-Encrypted: i=1; AJvYcCW+fNjFkvZfXLDYBmfQniZFeqKWvUDpLudEG0VxZ3H/HX0DGUb58Blde3WvYCZDwu3TiwqVjwTWdw==@kvack.org
X-Gm-Message-State: AOJu0YwxjI7F/FvfyeUWzGuH7bxFPbdcnz4BxB/mGlFbqOUi3qRoeWpl
	cicc+MpvdHQpcOaeksrvhxJMpDZofakUNLXZI117/FsicSPn53aI5tH1Bv+AyLnDR0VSrYWCs9G
	olTt8
X-Gm-Gg: ASbGncsSJtlbPRgCKqlRJoWZI9LQNlCwg9d3xCylLUzzpMEq0mLOlwZAaN1QvyNlPJO
	0uQASMoA1kaJndsWiNspfx7rg727HUdF8PZc75gcK3urfDIXWsaTvSFXp9Fc/X8wfxabTw5BCPI
	kM3pedhT2QJ1nKTHAny56aG3CdIutl/g/WKJ2QJzK28aDnpdU1BV5ijT/WDRu8MXZC8Fm2ccL9v
	7Kv1F8F7ZR50Jsqc+hH2z96ZyVdqzgUgBmy3vygPEUHPMuXlt3E2cDpTS16+JIfebIDoa68Xaxz
	KEPbFGuyi7Owt9nJB3o4509nq1V9Iu5+dzf351qQeLs3ZYmtt8wfPCA2fBv6TfpPlCf5RlgqABh
	dsKWhO+2LW8D4X92GREMnvaKUWsFWXpJL
X-Google-Smtp-Source: AGHT+IHqqHjkrV1Y0AgUE/7okEjKgN0Xu4SqOAlTzo93EMsg5xWeC1nRyl3GBDs9U3ql1blBgoSqFg==
X-Received: by 2002:a17:902:ebc5:b0:23f:a1b5:e537 with SMTP id d9443c01a7336-23fa5ce4bf8mr55592815ad.3.1753400227208;
        Thu, 24 Jul 2025 16:37:07 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fa48bc706sm23598685ad.106.2025.07.24.16.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 16:37:06 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 24 Jul 2025 16:36:54 -0700
Subject: [PATCH 01/11] riscv: add landing pad for asm routines.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250724-riscv_kcfi-v1-1-04b8fa44c98c@rivosinc.com>
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
X-Stat-Signature: u7mu5dpgggug8wnztzdfazmtw7do98tt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8519420008
X-Rspam-User: 
X-HE-Tag: 1753400228-112054
X-HE-Meta: U2FsdGVkX19/jvIzvzwwoWqlB86BVYremBnE4NjbAgWHtqvwP/XKk79ICmtm7E/Okf8DAlmd6D2PP+QR2Dv9mvrXE/Ea+y9cJ8tqH0dtmMRBnjcu3XFvfTZtSZLrew0XrscX4WZTVCfJh7XOapA+JFDqZ7nuYV0cjBffzBx5r6FFFvgC4BcrlodSQhBYb4RiMV4Xk84CpZFvDhB9+MJ/jSS0+cC1uhbgqBBexZDOVs695Hq6Xg/XdXyDv9reyr8EnLGEGGdOYOnSbseup/YKOFRDni1O5f19M4DAwUAxCw7eBV4KFsbEox4ZMuP+zap0mAWDPdkbC1Z3iyAh2qHLm7d3uT00Vkw2YcxvQw6Vq2oRZv+y5UfNbFpZ0wB0vEutjMN30Du8x7uONp+7qheYLoZb/16daIu75D7a41ymqqYFh5tw/5u+Cmz/qz5mb8/xbv/O+Akf+N/5wwoZkdRx8ZW5c/mz9M5q3o3Tthuu/Ff174i9Aj8Z7xjS7Qb/RCDoMwQkR8JRkDvLFfA35xxlqCqwADgN2T02fG5sveXk0948EJ+ayqexmBucMD3mFFN/g9rF0VRdwrAVrH5QkBRrkRzDA8hGarmctkhPJreiskUczEhHidvEJr+rJM2jYS2rYZ8Pj4VkGuSOQd64W3n8XeF5SaQTgtg28YZSCNXWk9PrhYwDrsCSZBcnmBGCrVbRGovmX3al/RaJ9SvFj0ihJ8bO87Mp49mUSBIf80PxnBP5mGO9kErMTcz2HTgsQNQYdDsrbJaqy5BzjQ3BdOAXFeV6Dyv1zkOS3QzmqQev3Fpb2KQHjQaRakAJ9oxcni3C4/Deuj5Km3WV5JQ9emG91BHKSCe9fyC31POqkb2Ox36K5fVZb+8K+Uf+otJ3ln57Yay5s2+6mahbaTB1KPbf6UDPNnL2u/7TkyQrTe5YskqStyNv+aApZvR2I8gOOP9lTQXkHbjNE94flmP4u2Q
 fFcwKqut
 0pbCO1uF/UsJHoWyR/0RU0odObRYF9yriwJHnZGpsEa19kqNleOFthhI1u4aajC05E5TifOE5WU7UXvFDhIpmPstG80lwINcQ/TvSOWhvV7opJuednmkWp6mrK0jXTkLedqHi2w/KOsr6fwvT23zHGS5lJfpJ7oCU1oqHKSROLwqDjd9Cx6OP4ikVFix454Sp7oqUp5uyQNeAtBBRdwCUC1iiHsI9+gVRjknBwBt9O2tLNNkDmNCUaCCN6DVfEIkAeFI6q3Hu6hHtyOtiqc6XpORmEpgGnZcz/SHON89JHLA8jA0ZJriPKhHXdtLPiVyd+ZQT0cxvkr6ZdO2bTAp5Ne9gT1Mbplabc/BYUveIUp8IKPVig4tWnuaoMpeohz/YcdxWD5tcZfy7vBHiGFhxe4r1C4KPeSLuinnKmi5SOhzM/LCdzH53Gf1XOms8sUIbmlmVbQjHnUQ+WAAQZ7mjhgdv0MjodBvu9mmTPRUebR75fiT1mE7YA9G2DQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SYM_* macros are used to define assembly routines. In this patch series,
re-define those macros in risc-v arch specific include file to include
a landing pad instruction at the beginning. This is done only when the
compiler flag for landing pad is enabled (i.e. __riscv_zicfilp).

TODO: Update `lpad 0` with `lpad %lpad_hash(name)` after toolchain
support.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/linkage.h | 42 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/arch/riscv/include/asm/linkage.h b/arch/riscv/include/asm/linkage.h
index 9e88ba23cd2b..162774b81158 100644
--- a/arch/riscv/include/asm/linkage.h
+++ b/arch/riscv/include/asm/linkage.h
@@ -6,7 +6,49 @@
 #ifndef _ASM_RISCV_LINKAGE_H
 #define _ASM_RISCV_LINKAGE_H
 
+#ifdef __ASSEMBLY__
+#include <asm/assembler.h>
+#endif
+
 #define __ALIGN		.balign 4
 #define __ALIGN_STR	".balign 4"
 
+#ifdef __riscv_zicfilp
+/*
+ * A landing pad instruction is needed at start of asm routines
+ * re-define macros for asm routines to have a landing pad at
+ * the beginning of function. Currently use label value of 0x1.
+ * Eventually, label should be calculated as a hash over function
+ * signature.
+ */
+#define SYM_FUNC_START(name)				\
+	SYM_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
+	lpad 0;
+
+#define SYM_FUNC_START_NOALIGN(name)			\
+	SYM_START(name, SYM_L_GLOBAL, SYM_A_NONE)	\
+	lpad 0;
+
+#define SYM_FUNC_START_LOCAL(name)			\
+	SYM_START(name, SYM_L_LOCAL, SYM_A_ALIGN)	\
+	lpad 0;
+
+#define SYM_FUNC_START_LOCAL_NOALIGN(name)		\
+	SYM_START(name, SYM_L_LOCAL, SYM_A_NONE)	\
+	lpad 0;
+
+#define SYM_FUNC_START_WEAK(name)			\
+	SYM_START(name, SYM_L_WEAK, SYM_A_ALIGN)	\
+	lpad 0;
+
+#define SYM_FUNC_START_WEAK_NOALIGN(name)		\
+	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
+	lpad 0;
+
+#define SYM_TYPED_FUNC_START(name)				\
+	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_A_ALIGN)	\
+	lpad 0;
+
+#endif
+
 #endif /* _ASM_RISCV_LINKAGE_H */

-- 
2.43.0


