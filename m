Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B4EC531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 09:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B706B015B; Thu, 23 Jul 2026 05:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D4F36B015D; Thu, 23 Jul 2026 05:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3A46B015E; Thu, 23 Jul 2026 05:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FAED6B015B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:29:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9FACC1203F0
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:31 +0000 (UTC)
X-FDA: 85019518542.22.3C71778
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id D023C180003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 09:29:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B7ppayUn;
	spf=pass (imf06.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784798969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dyZbGE6s/GhiUQY1p3Ic3dHaqeDboCKAETdtIwyjiwg=;
	b=Iuz2REUELlqLDGX+CEOfpprIQTBCfQnpADTbsZTkMdz6PyXtYUQyBPawQ/x5FuGDiefzL/
	1ru8w1gAO4nFAO+qNg3vNp5AbL1/c5Wq/GZ+3L7/22Lf6GP7AHRJ+0Tyfrq7Vx839IbE2b
	yUJ0tDLq79cCmZMIi/qDgvF05dT4m54=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B7ppayUn;
	spf=pass (imf06.hostedemail.com: domain of zhaomeijing100@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=zhaomeijing100@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784798969;
	b=GszddUs8mAVYQV+2EPPxsg9PvvfG9gECMxV23uH/MnrfpA4+nJvZQkUQ8BTr3sIImEokaz
	J4twPDA5rE3ZWGjHOKssaWrX2Zn48rOdaEOfD+PtGy5DjrQbFhgJmeEUCRuqsgoIFxieBr
	yXxDne2lCBBe/k9aLAo8BVKTptWZeys=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso4872545ad.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 02:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784798969; x=1785403769; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dyZbGE6s/GhiUQY1p3Ic3dHaqeDboCKAETdtIwyjiwg=;
        b=B7ppayUnmnB2jgfEVB5vmdaZqAKCYT5gMfS1n1fkN9gk+U95c21xlvmEI31hULd5yN
         emi9HHYAzzaRdguv8BQvFrleuGnBzSLkv46Yho4Q/yuizSqPjFH+C2aVbzBeJh5nZ000
         2B/deMAjsLIkrbjnbYTYnpRRmioX+3TBhwfj7+ZgI0XkH6xZw9nuRp3dr57QvFNcGFjB
         f/R21c94Ij23/pLW3z6QKznlKdmTxOkRjWKEXsCUvbKhW2yHqZ3P2okFDrkxKZa5smG+
         PM0D4Sp2BGZq0yEk0qJpqjuM0dhJHD16WQKlu32h+P3cnSZVr8OeXBDuZ20Lh8J9I1fP
         mPig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798969; x=1785403769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dyZbGE6s/GhiUQY1p3Ic3dHaqeDboCKAETdtIwyjiwg=;
        b=J7YOte5gq6x2TO5sAIfoltDaS+RTGo0wPdv7WS/Zi4TXory+9fRxNzyeGtuAbH89Z5
         wTtDalhwxdLWZcc1+9GLaYc0GWbq+SOp2jsoBecL6rcq1Yd/195yt74UceolW0jsCynn
         yNjDUqaxgAjdRvwPSILrhA6YI1yEY29SpiyeDiifQNMtcpIDWf5kbyxo7kHb1IgwoSqB
         vEaARLef2XfSZl18FW7q6/1EfEA0881Y8Sgu2pIig+xGRIxP8hUvJVZjCq+Ctarxeqa3
         KbrbcEiRlZ4YuTy6VdmctJG+/SZ6e/NXRzWWvvvBq+MZc/MUE7cmlfw+O9lYzEvzxv0C
         g34A==
X-Forwarded-Encrypted: i=1; AHgh+Rrm0Ul+Un7S/gxKjnDii79lSMtG5Tw4p//H21fbK09qpPbAKP9lSxb6+keSuHqi7PnOUTWMG4uuWQ==@kvack.org
X-Gm-Message-State: AOJu0YyHjlWX9TT/rkyRF4284Lem2MmwUNjYFgq/mXPkcX3d1h5n0to6
	WU84sNkilPepygWTwbVEGz9yOLfrHqj0xIjOn5Q1CYn+QAzuMo3531FS
X-Gm-Gg: AR+sD11Yfn0bqPb7PJ6N7uc8cSYDkz8XcKoiAxQ5Pbt4/vnQaO0jFVBdTZPo2KMgP0W
	KPBScwxNf7/lAtkMVtMRxg7IHIm+WcejtDgWlz1rlqB4apevjPcB0LQMgKAARRFtAXveTQ1Dh3w
	57SbceKchLJb5t7mqdFmL2DPlkarKiolq5kZVde1yAlZhaEbQMnO9RT1IJNu6rtlEz6tYBwgUCx
	z1e/VAo85H7pZ5mDQ3iEFpycb5o3kTJQEzs+4dj+k+tOMDgJmkFh5/RxXI+ujVT1aWe++0tqsze
	sRw+2LZzxJbm6OTtlVT0P/yZWFrQqA6TENAtuojlOvCXVYRWJ4BsIxvxiGwZlIgwdWX5bypKGfJ
	LMVO0bV5PYQGpYpKF3pEEz0xj7ePuwT47sP6P7Otjh8F22JgnSbaUx28HQ0rkaSIYL0lKA2tnRd
	JdZBfoHPt33epLffG4Ag==
X-Received: by 2002:a17:903:181:b0:2c9:97a7:f544 with SMTP id d9443c01a7336-2cfa6f81c55mr27454325ad.42.1784798968576;
        Thu, 23 Jul 2026 02:29:28 -0700 (PDT)
Received: from PC-2B0BA31200898.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efa388fsm30298125ad.12.2026.07.23.02.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 02:29:27 -0700 (PDT)
From: Meijing Zhao <zhaomeijing100@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Meijing Zhao <zhaomeijing@lixiang.com>
Subject: [PATCH RESEND 3/3] mm: trace: name protection key encoding bits
Date: Thu, 23 Jul 2026 17:29:05 +0800
Message-Id: <20260723092905.761037-4-zhaomeijing100@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260723092905.761037-1-zhaomeijing100@gmail.com>
References: <20260723092905.761037-1-zhaomeijing100@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D023C180003
X-Stat-Signature: 1184rwjtuge839s1f5hk9uw3uifq7h84
X-HE-Tag: 1784798969-41221
X-HE-Meta: U2FsdGVkX18KZyN9J7YZZeoM2lM47s3IwHRgt1roSFAX4gxq396NTOtPfXvy8Jjvl3/iGp3kFjRibAhA/Gm377hzJfo9bF2ljnz03l5Yb1t93D95QSuc6I9PgMo8R33kIT+oTAXCta9GGipboJw8Vmt0vg0Rofx6SaVEq5ae2Fsvx8mfGYm+XG+MTYz7L3G1Vd6Ir9iFDBL8fKM8pY4+FoguMPHV/zip+PpWh23on7o1t4rghg2ljQtWzhLLbCgRuS38O2juTzFABDwEIe0b1+3wLyhKIdmC3hYQAN2ddbX1nPDEDvObyNvU9lUyxGgcXl3FbLPYDQf53NMF2I+uNXDJ68NYLPl/aItsev9gLr+h0OYFnEwUfYIiy3dzYMcRNR6C2fTXAKysevNlvoleYasiDt/+dpr1g/Pfz/02KHWHNYnGIDjxKEfTlVsyRGSYmEn/5PjMs3F12D29ef2zR49VRlc0znT6TsSXWKkYAUwYDL9OjAYi/M7rzDypGDtDn6XkRFnkCyy3Q2Xxc0L6QCGgPqgUG/zV84IWV8uxiwsMsCUvcihdaCm73XZ2radBsnNfx1hgr5PWdm8zfCkQ5yPzMpNWrJtRu0p6GZnHCe7K+0xJq/875IVuPa5M7RqwzmBwAZueFnAhuCayRwLAe4IfGZ9sgIcegQ5TdUCV7AsrRhHLxx00OTcfJq+hLdw6z733qZ4ib4qcZBCZJMubx0m693VccqPMmUZguTqvDv5LZPfnW5eZ6ypTInyW/tx3z8ZLj9ywvG25Bnid+vNF2DqcuJ/8dYmjhXx9smnh62nhSD0i1B/8kSPsQmQx0EEHGfv74AASTbHJ+VSrtnCYsRUVE3lrr+CL9HuEps8BB5PsnxQZP1C0Y6p+MAV2ojF7GgIrBNO8rLczWxfUiDSRIHpqY5cZ1senwXabqMvC61jhAoFK19LDBT4TTfvUiiCBmvlbGUxiwRh3Mn7uQzv
 TImmsBYb
 nW2SnYDPtIUA20pPPA+eZdZA2ajAsNcfeOEm2TIoGh05OVYO3Xgx9nUhkBSU8n0olxfdngYKvk7HfeOIL7lph+8BfB4EivCRXDNcJF0Q207mWGo6CXPb54U6czv4oFQFgaJsjlWgE9hj+dYLGlZMjd5YymmlPVUnUbevMb4Z5N8pgODEIPWL60oGT3NlH07HoJI0wfugfNQG5WNFgWu7Mb7oN9JI2c58SAUNE5z4GKVLMyLxlL/6kRDg0Oxy9iefZhjQnosTA8mM6l6Kow6EPWI6WNRg3aIaKCZqvdGBkj/SBpXkXg7KRjilPk94//AzssHiTpnRKtll/zug3XnE/lXQE8xPiimkvDNZYwcU5j2rrRR0R3U28uIo7VOcymvDqyDJhXjgl8D5tMUlXRv/GTTASj8w5wxjBFao7H//MViZF0JeUKiqF1ZSTfV1PfLNu8prRJ3zjC9WO1ly7b/JQOvGNKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Meijing Zhao <zhaomeijing@lixiang.com>

Protection keys are encoded in architecture-specific HIGH_ARCH_* VMA
flag bits.  show_vma_flags(), which is used by VMA tracepoints and %pGv,
does not name those bits, leaving them as raw hexadecimal values.

Name the protection-key encoding bits pkey_bit0 through pkey_bit4 under
CONFIG_ARCH_HAS_PKEYS.  The names make clear that these are bits of one
protection-key value rather than independent protection keys.  For
example, protection key 3 is represented as:

  pkey_bit0|pkey_bit1

Honor CONFIG_ARCH_PKEY_BITS when exposing bit 3 and bit 4 so only bits
provided by the architecture are included.

Signed-off-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 include/trace/events/mmflags.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index 2d76daacb70c..c8b8a980f8c7 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -204,6 +204,24 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_VM_DROPPABLE(flag, name)
 #endif
 
+#ifdef CONFIG_ARCH_HAS_PKEYS
+# define IF_HAVE_VM_PKEY(flag, name) {flag, name},
+#if CONFIG_ARCH_PKEY_BITS > 3
+# define IF_HAVE_VM_PKEY3(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY3(flag, name)
+#endif
+#if CONFIG_ARCH_PKEY_BITS > 4
+# define IF_HAVE_VM_PKEY4(flag, name) {flag, name},
+#else
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+#else
+# define IF_HAVE_VM_PKEY(flag, name)
+# define IF_HAVE_VM_PKEY3(flag, name)
+# define IF_HAVE_VM_PKEY4(flag, name)
+#endif
+
 #ifdef CONFIG_ARM64_MTE
 # define IF_HAVE_VM_MTE(flag, name) {flag, name},
 #else
@@ -251,6 +269,11 @@ IF_HAVE_VM_SOFTDIRTY(VM_SOFTDIRTY,	"softdirty"	)		\
 	{VM_HUGEPAGE,			"hugepage"	},		\
 	{VM_NOHUGEPAGE,			"nohugepage"	},		\
 IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,	"droppable"	)		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT0,		"pkey_bit0")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT1,		"pkey_bit1")		\
+IF_HAVE_VM_PKEY(VM_PKEY_BIT2,		"pkey_bit2")		\
+IF_HAVE_VM_PKEY3(VM_PKEY_BIT3,		"pkey_bit3")		\
+IF_HAVE_VM_PKEY4(VM_PKEY_BIT4,		"pkey_bit4")		\
 IF_HAVE_VM_MTE(VM_MTE,			"mte")			\
 IF_HAVE_VM_MTE(VM_MTE_ALLOWED,		"mte_allowed")		\
 IF_HAVE_VM_SHADOW_STACK(VM_SHADOW_STACK, "shadow_stack")	\
-- 
2.25.1

