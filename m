Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA420C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28956B0159; Thu, 23 Jul 2026 05:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD92A6B015B; Thu, 23 Jul 2026 05:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8B06B015C; Thu, 23 Jul 2026 05:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1B036B0159
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:29:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32D6EA0BB0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:27 +0000 (UTC)
X-FDA: 85019518374.15.BEF5B98
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 66B17180007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LRdFtUe2;
	spf=pass (imf24.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784798965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dPfVR8qOQpuRYvB5SnMtHyLaliAGnyBwBDTXNiCFaX4=;
	b=zXl0oSV784yEXsojOpSNPAr2xayPdwcwYXdpgdYHlxqKHtWhYQ1Rj1NpJGgTkUVf1aIHb/
	ktB+hfgfCtwn03LAju5IbNHW3jkIGd4bgh4gVqGuCvOqjZRIQ8mXJ1CuWOsENZAwrjZsYv
	NIbjCjlH81uRV272JH20tujckWUSrR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784798965;
	b=tpzR3dADxvGhtzldKjpHtB3iNQ1/JIky7gy2jHwVuRH4tXJdd+pNsyxZtrsjdvh8YX7Fpi
	8yS2uu6znnoxmYFRb5f3eaRxXnq/p0lAIhJ5z6bJ6brhtNwOE5Txp4F0JGsgqKXlAaDeCJ
	n8E41f1zzYskBkm6WHYCb+TI5556U9Q=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LRdFtUe2;
	spf=pass (imf24.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cc97653887so5061015ad.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798964; x=1785403764; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dPfVR8qOQpuRYvB5SnMtHyLaliAGnyBwBDTXNiCFaX4=;
        b=LRdFtUe27xitvX/n6BsRn0s9BK+vO9oCO1JLgcAHoHE7CqxonFtKhm+KWAQ5G1JQiU
         EDv6Po4qVmApYftzT04CyB+/czNtQ6M98jqhvaEkofFTNidcy+4INfMiuNsT07sTRu2Y
         A0/Caxohg7TY7f6cAQkTNsV1FMWWt429YKnLIV+Fao1eVOl+nAGsFiAxZbFIF8ZrCBqA
         IAkCDZxxW2/JgAsHk2GgGmAyyNmRreDdNfh2fnacd+W6dHyhUNf+vfHYmTwGHDsQ/YEZ
         mtckVHrDTv9md8KcO0g7Q+JFkb+LcrrLKpKZ52x2BkF+dZzdJNVXi1s6R8FAlNgWo2sJ
         Cqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798964; x=1785403764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dPfVR8qOQpuRYvB5SnMtHyLaliAGnyBwBDTXNiCFaX4=;
        b=K/Yxoh407sBZ6d0JJt087LWYuwT+xkBV9whkMpWeMg6yyWfsCJcyaq8u0WNxpMk0ds
         m0qHgxGsZf2I3036mY/wc561NJzZwpaXDz3vetlxm+fD0gato74p7I5tfic0xU9r++m+
         i5VPje3k1UR9fe80bbbgVNS73qeP1yXSus/UscLYLk86cz/s868wgNzkh8kaRzAQnoPF
         pJvd4g3yoNy6BzU2AIbmDsT/GtiYnl6tVtenZDyzZtTmKz/kr4wN9aOBsD99HLsj+BkF
         z/p1IaRL3DBK2V0vtPNUcPL3LRlBp3w+tiCBterVUeRrIceNvKSq0Yh/Y3XpFYZZ51qk
         V6Cg==
X-Forwarded-Encrypted: i=1; AHgh+RrjPGIbyq2Iz0qlW3hLnE1OS7MvOYMs21gSMCuhLDSWT51mPnChgHdu87VAsQQeg7/1QgrN1kAMnw==@kvack.org
X-Gm-Message-State: AOJu0YwbWxbyXrGbNvTZgCCIdXdokYKL1jUeOgbkF4UhRDe4gr1d0Oz2
	aICS5jz/B+S9ZHwEJaXQF8gi5/HsWG/LqW910+fLDMR1tkqPOPYOtlKm
X-Gm-Gg: AR+sD10rxZluEp+y/Tv8KtKKJYU3m3v7mK7/eYNRAIwb3k6PclpzSrMvNYJher3KQnv
	KTyYVw+19ya1vNOcLaLnl3KkqkLuacsF8xXRAT1CTiyOFERGBADTLJWNQ7TzsAx5C3NQR8M4Vg8
	OZIGPtjaKeOaeW1tzD72UvoMzzOYJZq8hF2dfMDpJqIT3cUIx4wNLs2bbfFyDFIHs3hZnLiYPkz
	48NCn+bXo43WIBHBnQMIc30Q/WqSDLV37N/nbSgurL78EBk0klST3QvYhZbEUH4CqFQX0RGARiL
	b7xwR0Mys+gWiIH0w8UfVbH1HyAb14UffPnVAEkOVqwoar4Fjk2uTpBTeYoFtoc4Qk13BEze5/7
	FrcKb54s02Kp0du3K0Gzutv4FAsBxEFogINkLbor8KVxPqadxstBR+iDroYhPKNztX8xDJASRLk
	DuyIW/OMqpfXlT3cyWAg==
X-Received: by 2002:a17:903:3d10:b0:2c7:f338:5691 with SMTP id d9443c01a7336-2cfa74b2ffdmr28199215ad.36.1784798964222;
        Thu, 23 Jul 2026 02:29:24 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa388fsm30298125ad.12.2026.07.23.02.29.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:29:23 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH RESEND 2/3] mm: trace: decode MTE and shadow stack VMA flags
Date: Thu, 23 Jul 2026 17:29:04 +0800
Message-Id: <20260723092905.761037-3-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723092905.761037-1-zhaomeijing100@gmail.com>
References: <20260723092905.761037-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 66B17180007
X-Stat-Signature: aypesb4uhtr6jirsx9hfbemskur5jdig
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784798965-660284
X-HE-Meta: U2FsdGVkX18KsSX2gRy7/jc8c99HOJhNuZFG7zNlX04cqzMByU358fBXDc9gORaKc95rVmtehThGBAL1VQXhckVIpyL/JxfxogJRHkHNeKcsuZ+XzI2/nRhsHikVT7NCUl8uJSTHLzSJdTCNhFHpyqd+anNX0y0QNjUnxG9tCDMM6fQi98b1QaWbwUPM9HlpRqNx5XZpqr3Ihiptq/D/HblyS7tjdt3y3Q8wV+X4rhJfwyFMPzwVR304pUXHMrvI44hYFXsPjqaLg7mHUu1SG2m7erMaPqXqRQRbssHgjl+IJIBKhWqJtKsVLTnpphnljKn/46jwJtaYS7Scygoxwf9EyuRz//jFHQDWOq0Kyj7q9ql2sUl+EYlwlq2X1IJ3XSMvUNI2V9tIVgMLlGSfxlqLpFdFdB8NC2HjCGdN4gJ7NRbh9eo19J+5CXjTv6Taejs/IwHRdLdlz/khioY77JsF+XSCtysIl+oVd768MPkZLsNOhZqmiY73EKD+J4UrqqPl3bO4UTwk7Agu2xry+q/zyuDLByQ3nTCDqenpsIB2wCRzgjO390j8RwicfliwayEQa5Rs8CrnRh6/+iNxAfAwbgrDvNhsYCHvhZ5VIycp9FwFcNX/JwoBmWKQL5GuqKV8w/hvkKeOfP3iujt/MKmFCxEvjOfEzjy2DWhGSSW6d7WhTtg1K4jVUr2EIs9yNnmYIz1NHTd0Ce9j85GUg/z13KzvVem7finqZ5m29MOsojg3MdMtuWR0zBJZqetHR9WjV61zPFnfgMG+8EH3vmMJ6Kpbvo4mu5EXkY4f7BUEsvf6XZ50qJAEyg1ed4MC10EXMF+EOrMwrClgDUe3YnqT4VFDcbuSOyR5G7E3jvPqOc1ddklPxjDnMSRp6k8HxdjyMynjZs5KwXZlMWjKf62RRBBxEx5STZLsEtPv5r2E6+8iC/5ZN0e/HRTb++XtOxWGAFPqCO8SdYAR0ES
 WZ4Dtnhg
 /yjky3kdNC2/iXV0M2OW8VJRy1EUOTKKyYX50CC1q4fUi0LEA41aPIaubtb2Rbsh8HlyNhcXt/ACXoWPLCTCsEuyd1GwIVAhSRcYhE956kXHXmr4abBFvqnzpl2h/8dHTeRQBGclGlU6Yfbs+fJXyDINViq8a5kyvIZYC4MZCFetDMFbv3KUVBKIx20Y2vOc0K7UICE5G8+D9n6GIb6etZsj18gTLtKeanMOodImVpbsslnMuoPW4wKWV2p8s2uOtIfLFgT/zivSoJFlP8FYmc2Wxa4EkHbiZpZw52QovTeClLn/YzOaIPPNbPvx9wv5L2IAMyM6/mbeQG8ylPa+FYW2IdpXPxZzADDQy8ruzSlcc1oKrlpnLRJ8KCE/KdAZDXsuJ5pda2raZZnwn566IQMbMzrdv3HBwDVtZN5zQhNLyhLqjdmbW3yrhk/vklZzKZCsJ9kp71yC4eTHItE4WR/wRaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

show_vma_flags(), which is used by VMA tracepoints and %pGv, leaves
architecture-specific HIGH_ARCH_* bits unnamed.  Arm64 MTE flags and
user shadow stack flags are therefore printed as raw hexadecimal values.

These bit positions are shared between architectures.  For example, bit
37 represents VM_MTE_ALLOWED on arm64 but VM_SHADOW_STACK on x86, so a
shared HIGH_ARCH_* bit cannot be given an unconditional name.

Add conditionally compiled names for VM_MTE, VM_MTE_ALLOWED and
VM_SHADOW_STACK.  Keep the configuration guards aligned with the
definitions of these aliases so each shared bit position is decoded
according to the target architecture.

For example, an arm64 VMA containing VM_MTE_ALLOWED is now printed as:

  ...|account|mte_allowed|...

instead of:

  ...|account|0x2000000000

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index add5ad6843e8..2d76daacb70c 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -204,6 +204,19 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
 
+#ifdef CONFIG_ARM64_MTE
+# define IF_HAVE_VM_MTE(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_MTE(flag, name)
+#endif
+
+#if defined(CONFIG_X86_USER_SHADOW_STACK) || defined(CONFIG_RISCV_USER_CFI) || \
+	defined(CONFIG_ARM64_GCS)
+# define IF_HAVE_VM_SHADOW_STACK(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_SHADOW_STACK(flag, name)
+#endif
+
 #define __def_vmaflag_names						\
 	{VM_READ,			"read"		},		\
 	{VM_WRITE,			"write"		},		\
@@ -238,6 +251,9 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
+IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
+IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
 	{VM_MERGEABLE,			"mergeable"	}		\
 
 #define show_vma_flags(flags)						\
-- 
2.25.1

