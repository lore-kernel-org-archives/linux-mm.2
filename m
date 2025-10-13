Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64981CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A867F8E0090; Mon, 13 Oct 2025 17:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36CE8E0031; Mon, 13 Oct 2025 17:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FEC98E0090; Mon, 13 Oct 2025 17:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9478E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FE5AC0666
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:03 +0000 (UTC)
X-FDA: 83994449406.12.79202DC
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4229EC0008
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fXQhv3Sy;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
	b=blWqe/R9g3jLQvVMi1pgdV0jsB9thSgFpSem8VDByUhvH4owOeG9NvqoAbqxa0oYztuCr0
	uVM2sQ8OCO3ovWgVogxiG4CzKdPn2WNED/DalhWwEalWPmMSwUqRVBgC1xeosKrgSHbdyZ
	k/x7qn6azYCO7kvzMygnOGcAlmOMwxg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fXQhv3Sy;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392561; a=rsa-sha256;
	cv=none;
	b=B6ZsI+CVWuDmmdwuR/0St9ZTniu7+bK78UfMdLJtPoB9UJY7gn5hapYqp0ppz88kTdf5BM
	YH0Pe0LVUuKEdwBDwYf9FeMZnLABSD+Hsmky2TknUlxTVIfFB2PDkbsV1MFeYgETZ4W2L0
	OktTYnHrJJ0ziIrOe1/fQAvv1o90gOo=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3381f041d7fso6102568a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392560; x=1760997360; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=fXQhv3SyiSN1mD0FZ3ZHl4OHItxmo1XFIAQsdTOu+rh13kXnge1o4bSItRsTDn8zP5
         3Rpo0wncdZTww5Eynyn2YCQZDce69K1K7yTRt/wuufj55FAFLzk9vVj1iupu398Y3kKj
         WPVKajpRBHMQjQ5z+g72U3CjF4uc0bp7gScd9ROlsRn88lrtiSulw4et9LwTxwnK6Q4c
         ubshvV8s1cvtd8T2obteQAzCw24x6dwWVeBNJMTugPM0H55vcMMj9hRRwefjqx6Vmky6
         QCAW50zXd4gD4rg9G1fhsHoP4NrEzLLawbe0OkLVIrv5z7NsyLhNsSsh3ZAUGfYvUr1G
         jGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392560; x=1760997360;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=F5L/NBYR+mGzgUb281wPcdMbVOYlJsX/nS7oZcGWDzKOvhkobvdiJ7qwPcoRgeQMqf
         EgXPTT++/gy0b5y6xd7P+PwrL/mAt+8WRkcplr6I4u7tK8o8kqsHPLDK8iB/8Z+2YWoM
         2s0gyzKQIKEq2uxqtjv4B9D4wKB9dZXSs1slJFx7XcrhK2sBP9QWTNl+X4Kxum8fpCBc
         uL7kt4ru08PcTLXqoJdfHFScETeRjf/MXsf/jmiFFW4d3KTbOb7XTEkbWM+gF9IDB2xI
         inLSqPadiJ+UpBpOXRxPh30Zv5kbjCPdEkM8YlGbKkziFBpEJsXL+hgegLfO5a2yxGxF
         NvFg==
X-Forwarded-Encrypted: i=1; AJvYcCU+t+Bzr8ET4xaLssXznOKC7RxQsMi1VnNvHcXNJK1l3pM4TehxuF4yjrthN9ePq+7n4EIyGkN72A==@kvack.org
X-Gm-Message-State: AOJu0Ywx/U/1tbKf/jFTqwuq5M73scm9hf4gGN0Cg4vzTs8sQJwORiSo
	/x4kIXa1Td+BCzNLBmjKTh3hzz5gT56/vSSQYnhwESlf0/m5o8lmDgSCLLSQfxeG9j4=
X-Gm-Gg: ASbGncuWxN//Pv7f8FeS/E06re6DU4GiJO3OIMBDqnswy6iI4R4oQSnSS4ckz9rusdS
	IMJZovEvt9BJp6BRdM/8fUkKiIgzebMJGIn8n4plK1pgM8Wxecw0Bgy5mWnoLxXJf2SYBBT1a4O
	Fn4ZcMNhh0mfp+RKvKja30Q8cu1o3DwjNFZddpjezryHlV2NILsW0lM1uE6MpmBnEnP2RL2kane
	cWXP2VJL5dXrjjB8Qw1Jyjmxg1n5FS0DJ5bu0vtjdr5D/Y8FUdUBIh34Zi4m/6Gijn8wwbq0EDV
	pcYfnJazh8jOW9LlDLke5A0d+WyPDRcnUhhM5ezv1a7yaJJv+ANU9Csi7YuolhiPgPOMfDlXM4V
	5NnWveLfVNO89YiZY9/HMs1G8rK75qzsCddt0RswJNI1jVLRRrKJUBdzDbj94Wg==
X-Google-Smtp-Source: AGHT+IFqzpISbqmNZOG0bEFOm6WKZWXC8Tmhcil3Siykq0hDNGwZJ8D8UA33BLPp/sr08wWkDb8lvg==
X-Received: by 2002:a17:90b:2691:b0:330:55de:8c20 with SMTP id 98e67ed59e1d1-339eda4935emr36148338a91.2.1760392560121;
        Mon, 13 Oct 2025 14:56:00 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:55:59 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:55:53 -0700
Subject: [PATCH v20 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-1-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4229EC0008
X-Stat-Signature: gda3beqmcpx7bdmtes886thxk7xer1fa
X-Rspam-User: 
X-HE-Tag: 1760392561-249113
X-HE-Meta: U2FsdGVkX1/C9PTH77CI6+dzzCzjjWWHesAtTab2zM4sR+ms2MZRY1skkS9eFhmMnmPnJSkDA7rDrOIKikmVVDWnzcIEF9MwpGBAwubMmaT5MYzvMweXpVSEaMUrpRY3Jl5/tk/q4AXVFzzCF40lTxQkcppoKB4qv2hy3Ia6/ZkV4uUsRMRPeA7xKTE0dcYCEzBiWlerg1t1Z0R6apPlQICbhtzgIEu4WOyw0iegeaNfUfoIGZzNs5pVPgnXsJ6BvvyVuSFkWBTjEenBDD9TCc5Dd+Qh8R397nzyRwQfXZ9tHX6/jQca51m6yikf08gMj3tTNRKwMQixvyQ/14ApVcNLIa2kv46uzixyCzUqyKtz6C6KpE3cUIxcjUJ/cAlmJs2h2wHWHPNTzlmf+bl3HCgcmvtgzdicYraxIWgR8x9+a9JYTFvg/koOz+f2lvqICMvNlc+a8nri+AJAHG4YmJWPTL2j7lYTPg3R3gUdQabXG/VQRVDzLQHpmixx0lIMnh9wEXcXSImt9ag25KPLkUP2oxJIEKIv5Wf9zFJLF0j1oFhzY5NrYW8yS72MHGbA8FU7whpSdcBJJX3iPxCvK6SrzvuAdIZEjHplaTc0ZdKfaFCqvmCBJ8Rk9rjIqlCTMA/7O+r+xZvmLIH3Y+XwNTZdZI4mJVC/twjAbmpZL1y45NQ6rI3QuD2TgOdrRvFZNQSOolx3/4yFtHv1MEyUPTF+fzJ9FAkz7X3oLlNLlFnu/L9QPc1bfaSRFkIHdFuYA8o/7go1O0dP9/5DOzuS3FBXc3ZTdskWIu3/UNG3MrgweeTj2ZBA7mER6tbyRBq5xLOpe/TouSmgYk8iRNfw1zir26AJoJ3117lxPjHBLLfMRA11WtBkfMtb1Ny4B6haGdc2UnSQrnTf+djRF7bdwzFMech14MHi57UQ1w0hlImumS69rXJHYcFaGzyfnw4Kp4YHKQPYhsP+9ioWCAu
 553RPftS
 jVpqGoH5qYDAFRHJlNFi6zMFD84PtNwJ41C0dw211Q26nOrCXtVPIzQS5jAeg+4xvlpa5Fhys/naMOUYShY/0+otzxzJyKDU01vHjqk+p+QTqydnPJRa9ehfhtbvroIoYc21Gg5hDwlwn+geFqiW4OsVk95iN9czrvHG1b6Ze9/bwjdUglfc2UAsbIOxbFi2JdSRVMCGuumBwyn92tDaE8JCI0XKWSRNLg1QdoK/ZM2vVuffud6pDOCQ3diYsw1qqF2BxcNmqujy5f8cm9grZAIqCY2EGbTBE8UhIQs+di6voI8vm2zWEWOWsj5bESrVy0Di0YlblBKcIPvmymTTdFkUx5cLd7sw0ok8LavWPGQBwaUo28R0HdvZVwvc4gxNMKlBGpe21ak0yZ1FlJSW7fbCsFk4VO8OehsAVcD2bbBmosy+LKPoqvKXrqCuBo82r41sB2oGaR/7D3HhMho2FqGNPRaO8LYhYjHR8/6/Hdc3vaWijjcP5c2PLThajwCUC+UZ72vrPYiEdfzp3Xhp4XybSCiMXxlC3wKyPX1snH+ygAxcOBDv+7nAPlwzxvUgsmWORIYK1wiYUTw0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VM_HIGH_ARCH_5 is used for riscv

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/mm.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..2032d3f195f1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -380,6 +380,13 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_SHADOW_STACK	VM_HIGH_ARCH_6
 #endif
 
+#if defined(CONFIG_RISCV_USER_CFI)
+/*
+ * Following x86 and picking up the same bitpos.
+ */
+# define VM_SHADOW_STACK	VM_HIGH_ARCH_5
+#endif
+
 #ifndef VM_SHADOW_STACK
 # define VM_SHADOW_STACK	VM_NONE
 #endif

-- 
2.43.0


