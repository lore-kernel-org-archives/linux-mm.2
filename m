Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54365CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED14D8E0011; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9008E0002; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBF068E0011; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDE248E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9659CC0957
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:12 +0000 (UTC)
X-FDA: 83841251424.17.6EF03E1
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf20.hostedemail.com (Postfix) with ESMTP id D64311C0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LkJiMDX6;
	spf=pass (imf20.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756744990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtywjNgEiCtG5qk+Og9zZlkfm9Zwe/MrSwR0wbY7quk=;
	b=I/UdKr/blymLQXThD2c23jcR7krXTamE/pgBsXuG0M+hXGzlZeRPiSU0NXNPFsEPevhF8Q
	C9I+66rAFDg4odzW1+zCL12zsrMJ2AHGTULRBCiqURrVw/ifjn4o1clF1EGywc6+b9PMnB
	jM/K9DghBy7FfCTaOY64h6jRWfV5qUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756744990; a=rsa-sha256;
	cv=none;
	b=JyHnzN0K4dh2i/PsRd194eLHeYOEiAjkF7/GIPmuGpIZs/pusGM6UQwgCA1kdgO9kpkELA
	cGRrv2j0RhcKQiMPLzqVPCEsc1nv0NIpMV46GFdcYweXJF3814yTa4EAPNeWjiTSN4bIkr
	vrRhZ2Rw25UNAHB+KKe6eMKVHsfv25c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LkJiMDX6;
	spf=pass (imf20.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3d0dd9c9381so3105247f8f.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744989; x=1757349789; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YtywjNgEiCtG5qk+Og9zZlkfm9Zwe/MrSwR0wbY7quk=;
        b=LkJiMDX61prNQncNXbyIyPtmfZ97y2BVehIrMBTgUUh5+bwA35sobqJxLzzCJqUZmU
         fLA7zQE6AFAC4WJER9D6XGJd37apGsqzvD6SoMFqMN5QepPe0nJr845U2TyxRigWmidS
         v14t8lrv+DhWq+aSPvX9Y8QGD+SzeRADbtxv43hSTp+MxUki3C1nzbnveZDl52/QOUGD
         Jv3Snla9nd+G0cg8/IVUyE7oJtuDrVCcO429XYbEqVz59Ijis9gMr7rZX/Hp8aE9nnN9
         K4ikJBLMionX6R0nTBxPy+neuWv77+VHL5Vg8DHOUilabNpSkDE2U/G+wUX6c6HJ9plZ
         n/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744989; x=1757349789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtywjNgEiCtG5qk+Og9zZlkfm9Zwe/MrSwR0wbY7quk=;
        b=Uc+hyHbVHX/31DOtm8nrKJCPP5TKnpTmaI6iGGCGJBahrlJJ9S/R2ZzwZw73CUEcRj
         Non+UAek3uU64HnE5cpY231AteA4bjpXCg5+QYZwLOunsy64VOJuZ0Cy6Ooa/McOD5gi
         gxzuEwF+Pz7Q6wH88EBq3wtNUa3P1LVHNubaaKYPVi1z9qbO1+k/hffwhymswGT68j/R
         yCUorNyzRd+DBrV5M/FGYd/q7of5bdy5/GTrEfqDc8A9uqy7NSCbkzSh7qP7jDiSZatV
         x0ewQPY7Os7v68hzKOVGH+lNwBVnd0b7rPxL5aVEIyw7w3yOLMf994z1NArzb5wGq4hG
         FPYA==
X-Forwarded-Encrypted: i=1; AJvYcCVYqa70M0NBdktchp/5Eh6jhByw9RLnEpNgte9yXMoagxlI994WQQN1fZCcGq0jBz5jUM/EEsJsdA==@kvack.org
X-Gm-Message-State: AOJu0Yyt7QoYPPvrN70ukfw97Yl0NmNdQIISzBxtxmlOX6VkypRkG7nV
	7OqWYgFlruvq/qw8iGu4Mvu9GUD1/sbaw/vUf0qzUbi4v7q0ngD95lJI
X-Gm-Gg: ASbGncsyNeLvaBhOvZsQLQWKYlk+oohnAd3vhYp32MiLNubBshi0Vbcs5om3UiAREYJ
	mLj9QrOyo6xRiGVSlzEKZpGxLwgvF1l5rzvoogb/dYwn6PQ1kLulSTJ/3iKyW4qUXevdTWb40MW
	YqTfrNdKnVNcyYRXYJFOCtt/9l8Qd2OisHPDQBItjP5XbxQK1+zi3sgEFsQqSuu1GnmxCIcKbkB
	ua2fIyLZh7q1EWLyohZHs84e7iuRKK1e5zciuaYBJfAYIiGWTjVlwtDgYT6NleGFQ5r/jqyYi9+
	2DBaPGKKKfemHlDkM0yAbL7bL4r/gwjPd30utpqFDZqIe226bAZsNjxufYkduGyEGmvqiiHPqnj
	Yh/Ow5zFCh4vj6AcrgOV8H+MixIhxK+IAcdnkl2pWvpMiMJsqcvgI2Ax/xiOopa+z0K3NC/MK/A
	UQp6KecDiviki1Z2H2yGq6MRN5F34P
X-Google-Smtp-Source: AGHT+IEnOODGXodj9uSDYZuNbZRTIWZR+Tmr4mQZlPwEBrGOm1FTa8AUzy4RHJ1nyi0T/epc72WPkQ==
X-Received: by 2002:a5d:5f50:0:b0:3ce:8632:9fed with SMTP id ffacd0b85a97d-3d1def6a9ecmr7320649f8f.45.1756744989103;
        Mon, 01 Sep 2025 09:43:09 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:08 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 1/7] mm/kasan: implement kasan_poison_range
Date: Mon,  1 Sep 2025 16:42:06 +0000
Message-ID: <20250901164212.460229-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
In-Reply-To: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D64311C0009
X-Stat-Signature: t1uzgh3ta7zzh15xa7memjouibpges8i
X-Rspam-User: 
X-HE-Tag: 1756744990-645214
X-HE-Meta: U2FsdGVkX1+JhTi7VuLTB8t08UCSWf08qZsZHtKrHh4fAS/sZyErwvCYmTrZV/yVNLyD6VCZAWL6BYhyLUfTwdH9OIebAeiGWo3hXUpx35X0dcjv6Mxps+NrScrdjiaPivxD0nOq5VFOTSlIipqpTJWxLKojH/7k0lOUdxnNvwuEW2posGezS91ELQV/Rrh66a5wyCQITt0NGryzPWr0DEfwyElgEwHqky3kC7KMXzJajmSqkCr5qOeGLsJH2lYpFA7afGpaaS/enhhGEO33VjgK5uwG7AAcC8z8S88aUoltWep5KYivfbvRH27vaLaKaNHjcurZIF4jxB/Kf/QY/7+wZJlRB6gLtaF2CrfUbWT8zZf6EHQswbwgDMKjEw3n+sFtsnCfxAykd+/w7REs8LNo2m9pFnsWX0zaeKYYPbUCcJvXe91/gla1mee1DjgWRtQggI9y95IPkNSc0TlmLgebbjTtvygws0U5CsrRMIm4cY64dosz29WMima3hq9rmxhd1v5gN+6fH44bfpys6FdhOM5IKSUx4dWYIdL+VlsBMpAU98pFsrTlV5BXCjuDqRbJ0AWO5ljZNB/XWN65lf5E8Qj2J6kUy4P9aKQhvNqal6+n9tm33Y7MoaIhthmHR+Kwlgod6957cdkqbtfVn3Jd5Cd2+KwUFIHmin3ftxF9xd7S4I51ZdIlosPBCI0/yumUYrUTHW6Ka42dkzCRPlFYmWUBh+bvLmRC699YMgaq4Ln7qf8z7tEg1Vb9PDKkG7cggrXyYnTfy2RktUFXqwssCluGgsWsSnBu8xh0OPaPy3v0zeX+mMvAO4vdcDjFrKE0qX2u2sv2AvYEw6WFpkdP1CVQ5voLnCrkM8VPIGeYYw5aH9rGaVxNv1sgnv96StEmaWj+c3qPvLPao4man4ifxwzOIMwUsf2wyxSAooO/gO6pakweZcYnRDrTV9F+S78iB+Nk90p3gf/cSSy
 9x36nlg4
 cml3Iy2+ERY25/Z3Mejz8HMVrQY5R0MNuPZeUGpuTheEE0n7kUKL9SJ9hIXFgPgc1pIgyUrXO27KNZc6EDhxqT9YB3GdIhllCtzvr6WgH+a9pKch46nFKsFUPfJOOX5BCmNNqmg4C37H0qJ1VO9XAXJq0BWvaztSK5V2A8ggAezie5jc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Introduce a new helper function, kasan_poison_range(), to encapsulate
the logic for poisoning an arbitrary memory range of a given size, and
expose it publically in <include/linux/kasan.h>.

This is a preparatory change for the upcoming KFuzzTest patches, which
requires the ability to poison the inter-region padding in its input
buffers.

No functional change to any other subsystem is intended by this commit.

Signed-off-by: Ethan Graham <ethangraham@google.com>
---
 include/linux/kasan.h | 16 ++++++++++++++++
 mm/kasan/shadow.c     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..09baeb6c9f4d 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -102,6 +102,21 @@ static inline bool kasan_has_integrated_init(void)
 }
 
 #ifdef CONFIG_KASAN
+
+/**
+ * kasan_poison_range - poison the memory range [start, start + size)
+ *
+ * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, defined
+ * in <mm/kasan/kasan.h>.
+ *
+ * - If @start is unaligned, the initial partial granule at the beginning
+ *	of the range is only poisoned if CONFIG_KASAN_GENERIC is enabled.
+ * - The poisoning of the range only extends up to the last full granule before
+ *	the end of the range. Any remaining bytes in a final partial granule are
+ *	ignored.
+ */
+void kasan_poison_range(const void *start, size_t size);
+
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -402,6 +417,7 @@ static __always_inline bool kasan_check_byte(const void *addr)
 
 #else /* CONFIG_KASAN */
 
+static inline void kasan_poison_range(const void *start, size_t size) {}
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index d2c70cd2afb1..a1b6bfb35f07 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -147,6 +147,37 @@ void kasan_poison(const void *addr, size_t size, u8 value, bool init)
 }
 EXPORT_SYMBOL_GPL(kasan_poison);
 
+void kasan_poison_range(const void *start, size_t size)
+{
+	void *end = (char *)start + size;
+	uintptr_t start_addr = (uintptr_t)start;
+	uintptr_t head_granule_start;
+	uintptr_t poison_body_start;
+	uintptr_t poison_body_end;
+	size_t head_prefix_size;
+	uintptr_t end_addr;
+
+	end_addr = ALIGN_DOWN((uintptr_t)end, KASAN_GRANULE_SIZE);
+	if (start_addr >= end_addr)
+		return;
+
+	head_granule_start = ALIGN_DOWN(start_addr, KASAN_GRANULE_SIZE);
+	head_prefix_size = start_addr - head_granule_start;
+
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) && head_prefix_size > 0)
+		kasan_poison_last_granule((void *)head_granule_start,
+					  head_prefix_size);
+
+	poison_body_start = ALIGN(start_addr, KASAN_GRANULE_SIZE);
+	poison_body_end = ALIGN_DOWN(end_addr, KASAN_GRANULE_SIZE);
+
+	if (poison_body_start < poison_body_end)
+		kasan_poison((void *)poison_body_start,
+			     poison_body_end - poison_body_start,
+			     KASAN_SLAB_REDZONE, false);
+}
+EXPORT_SYMBOL(kasan_poison_range);
+
 #ifdef CONFIG_KASAN_GENERIC
 void kasan_poison_last_granule(const void *addr, size_t size)
 {
-- 
2.51.0.318.gd7df087d1a-goog


