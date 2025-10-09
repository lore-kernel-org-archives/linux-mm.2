Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F6B4CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948FA8E0055; Wed,  8 Oct 2025 21:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F9698E0002; Wed,  8 Oct 2025 21:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A0E8E0055; Wed,  8 Oct 2025 21:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64AC28E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:59:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2147BC08D7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:00 +0000 (UTC)
X-FDA: 83976917640.30.D42352B
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 39A194000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=fK42nNr0;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf12.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IhRrU7vktZrNl/RvMhvzrzBaAz+rEcTgEU1eyRQaB6M=;
	b=5mOalcMBp1qUX6kuGxXRBu+q4KzLKW7xPxdvnf0kXnb7Kqgk1f5N6Y05TJk8kC+TsYgx+f
	tzC5KX1hiFreT6yrGya4Jrsg7rmnEocWc1NdxPNDnU7ahrOrGoeEAAGn1fmbplli0GK8s0
	hTShVIhgkyx0+gPdFsl/VPW0D5WmrmE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975138; a=rsa-sha256;
	cv=none;
	b=qXr9dmy/0bOyYeUT3S+Vcqv5YkrvSKRpssDYguhW40g/ZofdGc0pwCYqUR+jbSscZu44p0
	cjH4G59C8FPSLFH3uArPB3gQhBZ394XtZDOvIDwRqmen4S9mvD/OVLcaYh4QQ0hImhoP/4
	xo5DSZHld7ie9bkCk2kuCnAAJHJ2sRg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=fK42nNr0;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf12.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b4ee87cc81eso344354a12.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975137; x=1760579937; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IhRrU7vktZrNl/RvMhvzrzBaAz+rEcTgEU1eyRQaB6M=;
        b=fK42nNr0I+n3VVGEeR+6yRBvB28NImy/CN61rXO+7snlCKPXp94hgC082zZfPDikTt
         +Ef8cFW4ArHfjcUJJi9YMnroj9cvJS42gaI2swLOOR2cYn0YSfBAM2yz6W2iyZHepaCk
         l/ZphgfOYVcDtXHuRlLM8U1rrQy90Tr3Gu+K96hVsKUHkpnWTgiJvrtcITZUtPW7WMcJ
         WNQslt8EXTVBRGCu53yT1P0scpJBs6v8kHiDE5zJFV4bCwaihB/P1DuqFT2LSp8SEB1O
         EYncOuklfdgz6n0HWOk8gfamlmRJuQ/TiKomKCh0oohlDbcuMlnaxATC3jMAoQjWmI2K
         q8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975137; x=1760579937;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IhRrU7vktZrNl/RvMhvzrzBaAz+rEcTgEU1eyRQaB6M=;
        b=KK7QAEHD62SyBB4O1cHTPf0cpnN6OO0SvMVznjNVxL0sKUHi/uygm2h2DvR5cUIC3Z
         5Wpqu33WZkjZh0Z4u7LGr+9Mqbs2MYJoGcEll/FKbyviVMVa8DAS6OtWDo9eqnewTg9x
         gza9Krcxuyn9PR9Nmurzlgya7sPJ40v3sbbW/pb8ETM4vVom8udggySwwlrEKMxB1Ty8
         Vxpi9RLHAOLeECoAzTfA4ztuGuTNB8QHw0ucf4tCeLD/qWm6u0b3NuTWPcnPItOe4GD0
         FDuuZpDDyJ9AqQTZf869pDcGRTkhzuSkbKTn8jIDIlAz4IVvtXIYGitOYU/V/qhDNp+J
         1aAw==
X-Forwarded-Encrypted: i=1; AJvYcCUOwLJuRXp3cgTTZY4MVpr/70XifnmsBBeryEM4n1z7/XO+9vZDNjgY6F1tim9W6eQAOfHi+foqKw==@kvack.org
X-Gm-Message-State: AOJu0Yws0/erK8a2IB8IGGN9RovkQt6goKDFjn96snrt1zSa/TjIqlFx
	Nflsql/me0X/2p9kosX4LG1QAj5wFAMh7pQFKt0pROY2SoM3edGnpgObNG5kBeLcWsw=
X-Gm-Gg: ASbGnctX0w7LOVu39ZHRLOdzRqGxLwE0466UgXCcyCmnTLbJXqUV/kIW77DX04ldk/p
	/4yZ2ewXyO4oNwPNJIph9kokcHSAK+4rdx91ntX0sUXFwBxkW5p+88NP6p7mgyyuehiRYdJ7/Zb
	O8ChkeI/04T5ZJeenBL9KwmU2HUAxKAFsG2lNHXSTdC88scemWZve+4amIKv5BvDCqpGNnRjOFC
	a8RaOtUp2PclzOzhdChQt41ireLk2+wi4dGPFuMvOUxU0r7VSD0ppDZkSJyLleIHxEP5UiVnoqS
	m935xMtI8YUDxXdGBAtW5/V+ry/JGrlAvop9RT0xIirpKZKUtegxJYuXF4BvkslVg10l0B0owqr
	21RP7llXwgmod6n7OGWv1cbmrM7rtxOXqMH71Ix5IfINwxmp/FN6xG0WHIhxYa8zHFE+5knxEgg
	ppnwc=
X-Google-Smtp-Source: AGHT+IF4/p9h31NSUo1ZrLpsC4/HMuMrEtQruEgKyI7OaJlvUq2z/r/6N19/PUGAwAUvJ1fjHTYvrw==
X-Received: by 2002:a17:903:a8b:b0:265:89c:251b with SMTP id d9443c01a7336-290273ef081mr70781625ad.29.1759975137149;
        Wed, 08 Oct 2025 18:58:57 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:56 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v2 13/18] riscv: alternative: Add an ALTERNATIVE_3 macro
Date: Wed,  8 Oct 2025 18:57:49 -0700
Message-ID: <20251009015839.3460231-14-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: ua5j5ypmhkkhq7q1c7uwgm8f6p3bums3
X-Rspam-User: 
X-Rspamd-Queue-Id: 39A194000A
X-HE-Tag: 1759975138-442232
X-HE-Meta: U2FsdGVkX18V4f8sXbLzTHE5SYVdYiqaO3qk3UOk7tnu7gnVf+nqTHnsI7B9OhNQDMqI3m6FaIk+eEj4+wWWLA/tlcDpOJrDLwXZhQRwdUCZH7Yo82lehzEq51NL1QXg0/sn72+xnGAWr/5NgsCiIyjn6KWBO65Uf5Gi523CEL12gPYIac2cQV+P9BgswLdfbxwSOwci5MAk5xVNuu/eATWrzZL75S7OQXTjIJgP0qgCet7ig4aypZSyXyWiekO4YKcMuBPVCfaSYKcQ+T1Fp2YOKTp1XcI+LcNfbed9PU5E9Y+wnMfKLiuLH5PlVUOYee3MPSLdRoV5iSTEhKZozs3htYpXqVLeJU49fp75V5JrPiM7QRR5v1U4O/s1+SXJf9K5ikYNHaygWeewGSncW8pCeCba+sl7EwfYXZ3RWxZEV5dsLM4Z/JeFOxqK4DL3g+OsVxDIcS1CNMzrlefNhA+MF7p8KN9uo3GKGDrs8n+ORbJN/sBhVkHCOLGBNg8qPhz0L//KySmiawITxj99tS4yRzSExPzBaxXFuYNPqv0qBzkssBHE/0CQ3u8QvK050x+6SwAffl+1qDW9JfwKHRRP0OckQCLoGqsfq129zR93VwyFPt+jxhkmskmTB9ZS/R742/l+QT84nRXLqY3UVOwQ9bihlhROfnFxsUR4MOkMrnVS3y2XKRvRXhtggxvwFrkWTIfYfH0fJXax0TkMB3IIp1UPb8UJQ2F7hjv1iSwNqhcD2PSN51pyNrffp0rfT9nt+iuFNKWwkb8lAidQGDLGuR7r2szhqeKQYhvYE+tcDQmBlD/FiEXXI/ly8OVGGKEudNLczSiNf7J+2mvG3EaF6/tjL1FXsW1tqyX47KiGOVvqug+gcEOqoDeG1VlvMgbLl9ePPtJoInhJN132y0MszTbVS6frlnWB+tU2uWAW946nbbd07zzSVfZdN1+V76qeU2G2Ndi2ObANI9F
 6bCwllUT
 YSlxhBDg0nUHme3YxzCG+ZMmnUcAs0V/baP51YbxlLTEDukU8Z2g3FTu90L5jwt54KQcBTd36B7d36M7IDwxUi6xQCo8aRAsMnS2J/sJIirj8PB7F/PhnlWS1/oLomVWvat2I7z5gZJPjdPTMkgZ6/rE1qtnWAQj82ax78BlbyyqtEqOZvkFVnM5Y+oAQHKt9hcYRDhJ42X1/vdMw2R5PtZJ8ByfoLxOKjdtwjIGZZYpYxse/Yzm/2yLkVVs46Au2L3lJMATH2WeLosYf+YCjLBwtse2ZaLiVY7XDW+x6BrJRMyLy3bD+RMjcV76L4+ykEpvauS1nb+UgK+I5JBwMvvdyrxhwPpjJywphwJSQk+oRVhDZ50YmMCOJfUv4unCVQ3E7fpaqSLP27CBICMkBc4LIRkZ/pagm7QiFRJ6ZrupKxUEQevH+7u/wvnOthXOJGccs3783al0pkqReJzNIg3bffvTHuu3ISHK6e55LyXBr71m53cvnBmrnxj80O54CtNP0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ALT_FIXUP_MT() is already using ALTERNATIVE_2(), but it needs to be
extended to handle a fourth case. Add ALTERNATIVE_3(), which extends
ALTERNATIVE_2() with another block of new content.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - Fix erroneously-escaped newline in assembly ALTERNATIVE_CFG_3 macro

 arch/riscv/include/asm/alternative-macros.h | 45 ++++++++++++++++++---
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
index 231d777d936c2..2d79abecf9a87 100644
--- a/arch/riscv/include/asm/alternative-macros.h
+++ b/arch/riscv/include/asm/alternative-macros.h
@@ -50,8 +50,17 @@
 	ALT_NEW_CONTENT \vendor_id_2, \patch_id_2, \enable_2, "\new_c_2"
 .endm
 
+.macro ALTERNATIVE_CFG_3 old_c, new_c_1, vendor_id_1, patch_id_1, enable_1,	\
+				new_c_2, vendor_id_2, patch_id_2, enable_2,	\
+				new_c_3, vendor_id_3, patch_id_3, enable_3
+	ALTERNATIVE_CFG_2 "\old_c", "\new_c_1", \vendor_id_1, \patch_id_1, \enable_1 \
+				    "\new_c_2", \vendor_id_2, \patch_id_2, \enable_2
+	ALT_NEW_CONTENT \vendor_id_3, \patch_id_3, \enable_3, "\new_c_3"
+.endm
+
 #define __ALTERNATIVE_CFG(...)		ALTERNATIVE_CFG __VA_ARGS__
 #define __ALTERNATIVE_CFG_2(...)	ALTERNATIVE_CFG_2 __VA_ARGS__
+#define __ALTERNATIVE_CFG_3(...)	ALTERNATIVE_CFG_3 __VA_ARGS__
 
 #else /* !__ASSEMBLY__ */
 
@@ -98,6 +107,13 @@
 	__ALTERNATIVE_CFG(old_c, new_c_1, vendor_id_1, patch_id_1, enable_1)	\
 	ALT_NEW_CONTENT(vendor_id_2, patch_id_2, enable_2, new_c_2)
 
+#define __ALTERNATIVE_CFG_3(old_c, new_c_1, vendor_id_1, patch_id_1, enable_1,	\
+				   new_c_2, vendor_id_2, patch_id_2, enable_2,	\
+				   new_c_3, vendor_id_3, patch_id_3, enable_3)	\
+	__ALTERNATIVE_CFG_2(old_c, new_c_1, vendor_id_1, patch_id_1, enable_1,	\
+				   new_c_2, vendor_id_2, patch_id_2, enable_2)	\
+	ALT_NEW_CONTENT(vendor_id_3, patch_id_3, enable_3, new_c_3)
+
 #endif /* __ASSEMBLY__ */
 
 #define _ALTERNATIVE_CFG(old_c, new_c, vendor_id, patch_id, CONFIG_k)	\
@@ -108,6 +124,13 @@
 	__ALTERNATIVE_CFG_2(old_c, new_c_1, vendor_id_1, patch_id_1, IS_ENABLED(CONFIG_k_1),	\
 				   new_c_2, vendor_id_2, patch_id_2, IS_ENABLED(CONFIG_k_2))
 
+#define _ALTERNATIVE_CFG_3(old_c, new_c_1, vendor_id_1, patch_id_1, CONFIG_k_1,		\
+				  new_c_2, vendor_id_2, patch_id_2, CONFIG_k_2,		\
+				  new_c_3, vendor_id_3, patch_id_3, CONFIG_k_3)		\
+	__ALTERNATIVE_CFG_3(old_c, new_c_1, vendor_id_1, patch_id_1, IS_ENABLED(CONFIG_k_1),	\
+				   new_c_2, vendor_id_2, patch_id_2, IS_ENABLED(CONFIG_k_2),	\
+				   new_c_3, vendor_id_3, patch_id_3, IS_ENABLED(CONFIG_k_3))
+
 #else /* CONFIG_RISCV_ALTERNATIVE */
 #ifdef __ASSEMBLY__
 
@@ -118,11 +141,17 @@
 #define __ALTERNATIVE_CFG(old_c, ...)		ALTERNATIVE_CFG old_c
 #define __ALTERNATIVE_CFG_2(old_c, ...)		ALTERNATIVE_CFG old_c
 
+#define _ALTERNATIVE_CFG_3(old_c, ...)	\
+	ALTERNATIVE_CFG old_c
+
 #else /* !__ASSEMBLY__ */
 
 #define __ALTERNATIVE_CFG(old_c, ...)		old_c "\n"
 #define __ALTERNATIVE_CFG_2(old_c, ...)		old_c "\n"
 
+#define _ALTERNATIVE_CFG_3(old_c, ...)	\
+	__ALTERNATIVE_CFG(old_c)
+
 #endif /* __ASSEMBLY__ */
 
 #define _ALTERNATIVE_CFG(old_c, ...)		__ALTERNATIVE_CFG(old_c)
@@ -147,15 +176,21 @@
 	_ALTERNATIVE_CFG(old_content, new_content, vendor_id, patch_id, CONFIG_k)
 
 /*
- * A vendor wants to replace an old_content, but another vendor has used
- * ALTERNATIVE() to patch its customized content at the same location. In
- * this case, this vendor can create a new macro ALTERNATIVE_2() based
- * on the following sample code and then replace ALTERNATIVE() with
- * ALTERNATIVE_2() to append its customized content.
+ * Variant of ALTERNATIVE() that supports two sets of replacement content.
  */
 #define ALTERNATIVE_2(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,		\
 				   new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2)		\
 	_ALTERNATIVE_CFG_2(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,	\
 					new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2)
 
+/*
+ * Variant of ALTERNATIVE() that supports three sets of replacement content.
+ */
+#define ALTERNATIVE_3(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,		\
+				   new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2,		\
+				   new_content_3, vendor_id_3, patch_id_3, CONFIG_k_3)		\
+	_ALTERNATIVE_CFG_3(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,	\
+					new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2,	\
+					new_content_3, vendor_id_3, patch_id_3, CONFIG_k_3)
+
 #endif
-- 
2.47.2


