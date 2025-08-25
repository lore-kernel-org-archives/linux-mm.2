Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04426CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 15:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363D48E0047; Mon, 25 Aug 2025 11:45:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33ADB8E0038; Mon, 25 Aug 2025 11:45:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250608E0047; Mon, 25 Aug 2025 11:45:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A2F98E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 11:45:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CCDF590AE
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:45:25 +0000 (UTC)
X-FDA: 83815704210.09.F4C86D7
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 863A8180012
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:45:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sNCYWhha;
	spf=pass (imf16.hostedemail.com: domain of 3EYWsaAUKCBo4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3EYWsaAUKCBo4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756136723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xe3ZI6MnUgwFYgdlik+eGR2/g7UExZaNNrV7DLC0Hwk=;
	b=qofMoLigukrZWa9kvpJgwPlSN0Tmml0KbYjBqHdub+znPGmYO6JvC76A7KUpttft3iIBol
	8OqbbeVc4Rv1sU+195b9E6zXRGWxPXTIvZ8DpDEawuhyP78wshHgxmCYXYIfiA2OmzQJ49
	m18oaTriwIZxDfk4DBTqUhOwhLYoOes=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sNCYWhha;
	spf=pass (imf16.hostedemail.com: domain of 3EYWsaAUKCBo4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3EYWsaAUKCBo4BL4H6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756136723; a=rsa-sha256;
	cv=none;
	b=OSojC4+Rr2fNyzXvMELJRZb7Doce8BzYZUMb8EDl5YNKBuTrhRrt+ABWHmr1ft4VfoyvJr
	qqM7MKPrFMcQ9rYPqs5IRcSlHoxP1+VQOW5gXeWP8rH/kmw4IuVXENt76EL8mUpKO14scm
	bFN+qiX7sbHiF1zPa2FgYv+Cc1VeZOw=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-61c6d735f2aso859480a12.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 08:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756136722; x=1756741522; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xe3ZI6MnUgwFYgdlik+eGR2/g7UExZaNNrV7DLC0Hwk=;
        b=sNCYWhha8Ag+HJ9Pykx61bZTQVt9rKymHe2V6PJ/jzs35Je7ti0QCXusyi40lv4F6m
         j0iAl+hV4ys8X6HbKN28vMz45s5hFetdBPF0jZ40jPxpROGTXjGB0b/9PX+7+WyZOiij
         jC54PnWAU8XlMIbJ+hf1gD7Emo6lv+6Y/m/hxFrlp6TiA0BPdzBZeMaOBuiqUOkf7K7h
         0JCYGLi6xsAJ+jKs4PX54r2weUmq2UlFTejrrhzIIgCcUPeE9n3lUNiEW6wlU8qX7aMY
         HcLlo/7i1S/i0sTnCVnWprPvBsGj+FTTygwMHsGjOBhBD0fh+w5HE4ZqxD6EFIJHwWOG
         nlMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756136722; x=1756741522;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xe3ZI6MnUgwFYgdlik+eGR2/g7UExZaNNrV7DLC0Hwk=;
        b=H9z+WRCgTuhDAzzR5lUHdQuKlISEbl3EiB28ilJ/L5bUQ2WzkXECpdQfWroqLB1xj0
         HxDYTctU4Zf04CJNOM+Glhb9xkxhGx2LNQIgPmmEmhiGNEsKlgmns9dXV4S3RDTTPJoM
         ydGH3wXXl/shWs2QUNSV+W2o4LfITP26sJjXBdKlEtFr/6YkAgIPEv+Ke/I7Ng41RAOV
         v1FgOnMNEtVnTHIPw/YWorZGsAbABQ6Lw0lK/PISVvMZ/kC0aPkgDO5APzh/05p44Fr7
         TFCcOGTN3HGVf3tq5jaW2GVPcjS7DC8gdh61FnfMZjjevKCspYHe7hwjw+iKNf5sZRr8
         hcKw==
X-Forwarded-Encrypted: i=1; AJvYcCVQarRRf9csPrMUffnM6OLadgJMSMtVVUIDORSdrM3bKSMav47wCTE9D2R3/z6K0zkbiPy7ZFQMbg==@kvack.org
X-Gm-Message-State: AOJu0Yx3voZ7pEz29BFlA39HmsinKTWPAxxlXpikhDvuulA/bBrkKrVO
	ybGqGcKbb8084xKatItj58K23payzkxIgDp+JtKOGNjItaB9RHGbfmcpUVmkfHqIOi8yh8VM12s
	L+A==
X-Google-Smtp-Source: AGHT+IFh0CDuf5rjjEL9k+KqRWzPp1sG7EfeKGkWflLNt+9cpgEFt5OAszOudAI2QqZvW4DoT3MS7eBS1Q==
X-Received: from edaa12.prod.google.com ([2002:a05:6402:24cc:b0:61c:5f40:a3ff])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:21c8:b0:61b:fd1c:a2d6
 with SMTP id 4fb4d7f45d1cf-61c1b49e8f3mr11045108a12.15.1756136721629; Mon, 25
 Aug 2025 08:45:21 -0700 (PDT)
Date: Mon, 25 Aug 2025 17:44:40 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.rc2.233.g662b1ed5c5-goog
Message-ID: <20250825154505.1558444-1-elver@google.com>
Subject: [PATCH RFC] slab: support for compiler-assisted type-based slab cache partitioning
From: Marco Elver <elver@google.com>
To: elver@google.com
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alexander Potapenko <glider@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrey Konovalov <andreyknvl@gmail.com>, David Hildenbrand <david@redhat.com>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Florent Revest <revest@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Matteo Rizzo <matteorizzo@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, linux-hardening@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 863A8180012
X-Stat-Signature: cexmnn9btf5q84r7tjo3t94zxpsf5rwh
X-Rspam-User: 
X-HE-Tag: 1756136723-301607
X-HE-Meta: U2FsdGVkX1+Gd2BxyfmMmM2OE7o0hE1ux9ok9x8Kc3R+TYtkKuznkpOJfJyJyJn5IConPm9osHfEC8x0rn/rCUpIHKzDeNegBkRkbHqSe4KgRm5ADSz6FfVyK9Q2745HGLGL2jpDQzxLj9aAIkWxQjOck8x0NxE6r8rvDnYksuq5TEAQgLbEStoVTkIZ74ZQjd90+ZdO64AnYEEz3YPMigXzJiZN8lnD9PdeHOvoMPv7/Oy59hxf3ejsoRd9lLeIHdryrLzr81mtrE+t+XxvmJ/TFIgQkNjD4ZTFDYXN/G44br9JsxlcoT3ZJOWu2boVCRwtbWk5Wwx/Tqow9zhz4emFIx3Qq9oDCKIqqc0DeCV3kAtRXyc2mcZw/GZBlrtc6gmf0xOL5xb5aS4Iqf/ZmlmW7u6XXOv/l7Y/8w9sIC3QfPUq/KY4viPfuTZlydYRK6c/8QaTVbzOIZXu/Hu43aB1cvXH7WJ5N7302bx0zzPCpslWkq5bJ7ZEXYywiG2VuXwjHZPCM84+S03dngCoRvvB9z0yl/fM4ay13JGpTyq8JTc0NVIBd222NWLWIRRY9St7X+1boQ5BHZry03IfnCdXpw1TIdsOEx/ITIKws6qeDGLM2ub7BC8t3oy8pla8BAXP18b1P5JFV4Ftc6WDmVvhB+v/BkGQXiMgo+Y1+VGOlJQGwLTWg5xy0tGjmXyHvgFOHkWln80Ug5HiQmgiK1DOq22vM7LyyAXwxMSs1LpcKSlf1DOgN4GVXplgMrovRz2VIqWQ3LffjSO5QHANTYU9gLcOciwGmNrX2Js/Amls7W8vTdEqC9xwXl5qIex1YtnvGhOWKBonoqmW5Osdb3qJTw5xIgtrdW3JJndGTupRfQZ29bZCAkQJq2+JKeUKc8JBP5jfFoOawNEjKlaoyUfDXdGeT+7CjWMMl2ylh2QUtGs1nSeBznqskGjKv/5hhs8JUEco3028LfPrO7y
 xvMfbwYM
 zcrj9a7ECcZA1PFtsDeN+gus1JZYReVxHTCc0Tu0Bp7Mz42SKeVjJkVRG+VO13Ew63gkXLn0GLRkE6eghnJ5Girjosbr3QgMyir+fUyw0MH2iaNM+BhbIJyA1QjUCo1MKLzn9cmJZfKW6mzN4RNdF/F4gnlAj4ll/+l7rdOiWRyYl8KD/cAHYipGSg3Yd6oToAyfidqlBzlTJwAwM1NUx2cUv5JIa05lNphouMovUolIujl9EjbmHwvPsmd3hqdAwhfzMhNVgiFOzCuDXLdp/Q8HTdAgHZOEkuf/bc1NVn7ioooJg8Hw7VvtTAOlVOaTCUAzfpQ6PQg6KNPOKuNNUyVBzc6XDUguHEB4rgfiapVSbm9tPEiG8+R/VQ1LMOnqtbSsATah3+1eVqOBBDqwVoWEf4+pcOSa5iL1hpGrnI2QqQZdcHr5gZ/tOLOVaqcRdDCPDV08a3x8cQMLdX5Kz90GD5Vf/LsqMGMCBoJgzW3JyskgkV6f46VdbKPg4tWkMDJFeO2XEvd3tazEJIK2Tg/f4FiyH7QK8bPDK1IbESesTIFXHpTlBbaF0BwrChsAyQWV4EHTHTAI1MoB+yV84qc362xAUjo6K/XRuQVHmnM9DwGQHDiaDMy30K7p/hHLzye33SfNTap1J3dtw9jo7llEtBXMj6otXJ5eYZMuq5L7JygiLR425Gxa9bxplaifxGz+1k8iedCsGdh2tZ3RtZY4v2Eh6wEr3wG6YOS2/1Vqdyrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ Beware, this an early RFC for an in-development Clang feature, and
  requires the following Clang/LLVM development tree:
   https://github.com/melver/llvm-project/tree/alloc-token
  The corresponding LLVM RFC and discussion can be found here:
   https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434 ]

Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
flexible PARTITION_KMALLOC_CACHES, with the former being a partitioning
mode of the latter.

Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages Clang's
"allocation tokens" via __builtin_alloc_token_infer [1].

This mechanism allows the compiler to pass a token ID derived from the
allocation's type to the allocator. The compiler performs best-effort
type inference, and recognizes idioms such as kmalloc(sizeof(T), ...).
Unlike RANDOM_KMALLOC_CACHES, this mode deterministically assigns a slab
cache to an allocation of type T, regardless of allocation site.

Clang's default token ID calculation is described as [1]:

   TypeHashPointerSplit: This mode assigns a token ID based on the hash
   of the allocated type's name, where the top half ID-space is reserved
   for types that contain pointers and the bottom half for types that do
   not contain pointers.

Separating pointer-containing objects from pointerless objects and data
allocations can help mitigate certain classes of memory corruption
exploits [2]: attackers who gains a buffer overflow on a primitive
buffer cannot use it to directly corrupt pointers or other critical
metadata in an object residing in a different, isolated heap region.

It is important to note that heap isolation strategies offer a
best-effort approach, and do not provide a 100% security guarantee,
albeit achievable at relatively low performance cost. Note that this
also does not prevent cross-cache attacks, and SLAB_VIRTUAL [3] should
be used as a complementary mitigation.

With all that, my kernel (x86 defconfig) shows me a histogram of slab
cache object distribution per /proc/slabinfo (after boot):

  <slab cache>      <objs> <hist>
  kmalloc-part-15     619  ++++++
  kmalloc-part-14    1412  ++++++++++++++
  kmalloc-part-13    1063  ++++++++++
  kmalloc-part-12    1745  +++++++++++++++++
  kmalloc-part-11     891  ++++++++
  kmalloc-part-10     610  ++++++
  kmalloc-part-09     792  +++++++
  kmalloc-part-08    3054  ++++++++++++++++++++++++++++++
  kmalloc-part-07     245  ++
  kmalloc-part-06     182  +
  kmalloc-part-05     122  +
  kmalloc-part-04     295  ++
  kmalloc-part-03     241  ++
  kmalloc-part-02     107  +
  kmalloc-part-01     124  +
  kmalloc            6231  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

The above /proc/slabinfo snapshot shows me there are 7547 allocated
objects (slabs 00 - 07) that the compiler claims contain no pointers or
it was unable to infer the type of, and 10186 objects that contain
pointers (slabs 08 - 15). On a whole, this looks relatively sane.

Additionally, when I compile my kernel with -Rpass=alloc-token, which
provides diagnostics where (after dead-code elimination) type inference
failed, I see 966 allocation sites where the compiler failed to identify
a type. Some initial review confirms these are mostly variable sized
buffers, but also include structs with trailing flexible length arrays
(the latter could be recognized by the compiler by teaching it to look
more deeply into complex expressions such as those generated by
struct_size).

Link: https://github.com/melver/llvm-project/blob/alloc-token/clang/docs/AllocToken.rst [1]
Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18/ [2]
Link: https://lwn.net/Articles/944647/ [3]
Signed-off-by: Marco Elver <elver@google.com>
---
 Makefile                        |  5 ++
 include/linux/percpu.h          |  2 +-
 include/linux/slab.h            | 88 ++++++++++++++++++++-------------
 kernel/configs/hardening.config |  2 +-
 mm/Kconfig                      | 43 ++++++++++++----
 mm/kfence/kfence_test.c         |  4 +-
 mm/slab.h                       |  4 +-
 mm/slab_common.c                | 48 +++++++++---------
 mm/slub.c                       | 20 ++++----
 9 files changed, 131 insertions(+), 85 deletions(-)

diff --git a/Makefile b/Makefile
index d1adb78c3596..cc761267fc75 100644
--- a/Makefile
+++ b/Makefile
@@ -936,6 +936,11 @@ KBUILD_CFLAGS	+= $(CC_AUTO_VAR_INIT_ZERO_ENABLER)
 endif
 endif
 
+ifdef CONFIG_TYPED_KMALLOC_CACHES
+# PARTITION_KMALLOC_CACHES_NR + 1
+KBUILD_CFLAGS	+= -falloc-token-max=16
+endif
+
 # Explicitly clear padding bits during variable initialization
 KBUILD_CFLAGS += $(call cc-option,-fzero-init-padding-bits=all)
 
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 85bf8dd9f087..271b41be314d 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -36,7 +36,7 @@
 #define PCPU_BITMAP_BLOCK_BITS		(PCPU_BITMAP_BLOCK_SIZE >>	\
 					 PCPU_MIN_ALLOC_SHIFT)
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
 # if defined(CONFIG_LOCKDEP) && !defined(CONFIG_PAGE_SIZE_4KB)
 # define PERCPU_DYNAMIC_SIZE_SHIFT      13
 # else
diff --git a/include/linux/slab.h b/include/linux/slab.h
index d5a8ab98035c..4ace54744b54 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -583,10 +583,10 @@ static inline unsigned int arch_slab_minalign(void)
 #define SLAB_OBJ_MIN_SIZE      (KMALLOC_MIN_SIZE < 16 ? \
                                (KMALLOC_MIN_SIZE) : 16)
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
-#define RANDOM_KMALLOC_CACHES_NR	15 // # of cache copies
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
+#define PARTITION_KMALLOC_CACHES_NR	15 // # of cache copies
 #else
-#define RANDOM_KMALLOC_CACHES_NR	0
+#define PARTITION_KMALLOC_CACHES_NR	0
 #endif
 
 /*
@@ -605,8 +605,8 @@ enum kmalloc_cache_type {
 #ifndef CONFIG_MEMCG
 	KMALLOC_CGROUP = KMALLOC_NORMAL,
 #endif
-	KMALLOC_RANDOM_START = KMALLOC_NORMAL,
-	KMALLOC_RANDOM_END = KMALLOC_RANDOM_START + RANDOM_KMALLOC_CACHES_NR,
+	KMALLOC_PARTITION_START = KMALLOC_NORMAL,
+	KMALLOC_PARTITION_END = KMALLOC_PARTITION_START + PARTITION_KMALLOC_CACHES_NR,
 #ifdef CONFIG_SLUB_TINY
 	KMALLOC_RECLAIM = KMALLOC_NORMAL,
 #else
@@ -633,9 +633,20 @@ extern kmem_buckets kmalloc_caches[NR_KMALLOC_TYPES];
 	(IS_ENABLED(CONFIG_ZONE_DMA)   ? __GFP_DMA : 0) |	\
 	(IS_ENABLED(CONFIG_MEMCG) ? __GFP_ACCOUNT : 0))
 
+#ifdef CONFIG_RANDOM_KMALLOC_CACHES
 extern unsigned long random_kmalloc_seed;
+typedef struct { unsigned long ip; } kmalloc_token_t;
+#define __kmalloc_token(...) ((kmalloc_token_t) { .ip = _RET_IP_ })
+#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
+typedef struct { unsigned long v; } kmalloc_token_t;
+#define __kmalloc_token(...) ((kmalloc_token_t){ .v = __builtin_alloc_token_infer(__VA_ARGS__) })
+#else
+/* no-op */
+typedef struct {} kmalloc_token_t;
+#define __kmalloc_token(...) ((kmalloc_token_t){})
+#endif
 
-static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigned long caller)
+static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, kmalloc_token_t token)
 {
 	/*
 	 * The most common case is KMALLOC_NORMAL, so test for it
@@ -643,9 +654,11 @@ static __always_inline enum kmalloc_cache_type kmalloc_type(gfp_t flags, unsigne
 	 */
 	if (likely((flags & KMALLOC_NOT_NORMAL_BITS) == 0))
 #ifdef CONFIG_RANDOM_KMALLOC_CACHES
-		/* RANDOM_KMALLOC_CACHES_NR (=15) copies + the KMALLOC_NORMAL */
-		return KMALLOC_RANDOM_START + hash_64(caller ^ random_kmalloc_seed,
-						      ilog2(RANDOM_KMALLOC_CACHES_NR + 1));
+		/* PARTITION_KMALLOC_CACHES_NR (=15) copies + the KMALLOC_NORMAL */
+		return KMALLOC_PARTITION_START + hash_64(token.ip ^ random_kmalloc_seed,
+							 ilog2(PARTITION_KMALLOC_CACHES_NR + 1));
+#elif defined(CONFIG_TYPED_KMALLOC_CACHES)
+		return KMALLOC_PARTITION_START + token.v;
 #else
 		return KMALLOC_NORMAL;
 #endif
@@ -819,10 +832,10 @@ void *kmem_cache_alloc_node_noprof(struct kmem_cache *s, gfp_t flags,
  * with the exception of kunit tests
  */
 
-void *__kmalloc_noprof(size_t size, gfp_t flags)
+void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 				__assume_kmalloc_alignment __alloc_size(1);
 
-void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
+void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
 				__assume_kmalloc_alignment __alloc_size(1);
 
 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t size)
@@ -893,7 +906,7 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
  *	Try really hard to succeed the allocation but fail
  *	eventually.
  */
-static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t flags)
+static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 {
 	if (__builtin_constant_p(size) && size) {
 		unsigned int index;
@@ -903,20 +916,21 @@ static __always_inline __alloc_size(1) void *kmalloc_noprof(size_t size, gfp_t f
 
 		index = kmalloc_index(size);
 		return __kmalloc_cache_noprof(
-				kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
+				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, size);
 	}
-	return __kmalloc_noprof(size, flags);
+	return __kmalloc_noprof(size, flags, token);
 }
+#define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc(...)				alloc_hooks(kmalloc_noprof(__VA_ARGS__))
 
 #define kmem_buckets_alloc(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
+	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, __kmalloc_token(_size)))
 
 #define kmem_buckets_alloc_track_caller(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, _RET_IP_))
+	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, _RET_IP_, __kmalloc_token(_size)))
 
-static __always_inline __alloc_size(1) void *kmalloc_node_noprof(size_t size, gfp_t flags, int node)
+static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, gfp_t flags, int node, kmalloc_token_t token)
 {
 	if (__builtin_constant_p(size) && size) {
 		unsigned int index;
@@ -926,11 +940,12 @@ static __always_inline __alloc_size(1) void *kmalloc_node_noprof(size_t size, gf
 
 		index = kmalloc_index(size);
 		return __kmalloc_cache_node_noprof(
-				kmalloc_caches[kmalloc_type(flags, _RET_IP_)][index],
+				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, node, size);
 	}
-	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node);
+	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, token);
 }
+#define kmalloc_node_noprof(...)		_kmalloc_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_node(...)			alloc_hooks(kmalloc_node_noprof(__VA_ARGS__))
 
 /**
@@ -939,14 +954,15 @@ static __always_inline __alloc_size(1) void *kmalloc_node_noprof(size_t size, gf
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1, 2) void *kmalloc_array_noprof(size_t n, size_t size, gfp_t flags)
+static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t size, gfp_t flags, kmalloc_token_t token)
 {
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
-	return kmalloc_noprof(bytes, flags);
+	return _kmalloc_noprof(bytes, flags, token);
 }
+#define kmalloc_array_noprof(...)		_kmalloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_array(...)			alloc_hooks(kmalloc_array_noprof(__VA_ARGS__))
 
 /**
@@ -989,9 +1005,9 @@ static inline __realloc_size(2, 3) void * __must_check krealloc_array_noprof(voi
 #define kcalloc(n, size, flags)		kmalloc_array(n, size, (flags) | __GFP_ZERO)
 
 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node,
-					 unsigned long caller) __alloc_size(1);
+					 unsigned long caller, kmalloc_token_t token) __alloc_size(1);
 #define kmalloc_node_track_caller_noprof(size, flags, node, caller) \
-	__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, caller)
+	__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, caller, __kmalloc_token(size))
 #define kmalloc_node_track_caller(...)		\
 	alloc_hooks(kmalloc_node_track_caller_noprof(__VA_ARGS__, _RET_IP_))
 
@@ -1008,17 +1024,18 @@ void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flag
 #define kmalloc_track_caller_noprof(...)	\
 		kmalloc_node_track_caller_noprof(__VA_ARGS__, NUMA_NO_NODE, _RET_IP_)
 
-static inline __alloc_size(1, 2) void *kmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags,
-							  int node)
+static inline __alloc_size(1, 2) void *_kmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags,
+								  int node, kmalloc_token_t token)
 {
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
-		return kmalloc_node_noprof(bytes, flags, node);
-	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), flags, node);
+		return _kmalloc_node_noprof(bytes, flags, node, token);
+	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), flags, node, token);
 }
+#define kmalloc_array_node_noprof(...)		_kmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_array_node(...)			alloc_hooks(kmalloc_array_node_noprof(__VA_ARGS__))
 
 #define kcalloc_node(_n, _size, _flags, _node)	\
@@ -1034,16 +1051,17 @@ static inline __alloc_size(1, 2) void *kmalloc_array_node_noprof(size_t n, size_
  * @size: how many bytes of memory are required.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1) void *kzalloc_noprof(size_t size, gfp_t flags)
+static inline __alloc_size(1) void *_kzalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 {
-	return kmalloc_noprof(size, flags | __GFP_ZERO);
+	return _kmalloc_noprof(size, flags | __GFP_ZERO, token);
 }
+#define kzalloc_noprof(...)			_kzalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kzalloc(...)				alloc_hooks(kzalloc_noprof(__VA_ARGS__))
 #define kzalloc_node(_size, _flags, _node)	kmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
-void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node) __alloc_size(1);
+void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token) __alloc_size(1);
 #define kvmalloc_node_noprof(size, flags, node)	\
-	__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node)
+	__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, __kmalloc_token(size))
 #define kvmalloc_node(...)			alloc_hooks(kvmalloc_node_noprof(__VA_ARGS__))
 
 #define kvmalloc(_size, _flags)			kvmalloc_node(_size, _flags, NUMA_NO_NODE)
@@ -1052,19 +1070,19 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
 
 #define kvzalloc_node(_size, _flags, _node)	kvmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 #define kmem_buckets_valloc(_b, _size, _flags)	\
-	alloc_hooks(__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE))
+	alloc_hooks(__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, __kmalloc_token(_size)))
 
 static inline __alloc_size(1, 2) void *
-kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node)
+_kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmalloc_token_t token)
 {
 	size_t bytes;
 
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;
 
-	return kvmalloc_node_noprof(bytes, flags, node);
+	return __kvmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), flags, node, token);
 }
-
+#define kvmalloc_array_node_noprof(...)		_kvmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kvmalloc_array_noprof(...)		kvmalloc_array_node_noprof(__VA_ARGS__, NUMA_NO_NODE)
 #define kvcalloc_node_noprof(_n,_s,_f,_node)	kvmalloc_array_node_noprof(_n,_s,(_f)|__GFP_ZERO,_node)
 #define kvcalloc_noprof(...)			kvcalloc_node_noprof(__VA_ARGS__, NUMA_NO_NODE)
diff --git a/kernel/configs/hardening.config b/kernel/configs/hardening.config
index 64caaf997fc0..df4fba56a3fd 100644
--- a/kernel/configs/hardening.config
+++ b/kernel/configs/hardening.config
@@ -22,7 +22,7 @@ CONFIG_SLAB_FREELIST_RANDOM=y
 CONFIG_SLAB_FREELIST_HARDENED=y
 CONFIG_SLAB_BUCKETS=y
 CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
-CONFIG_RANDOM_KMALLOC_CACHES=y
+CONFIG_PARTITION_KMALLOC_CACHES=y
 
 # Sanity check userspace page table mappings.
 CONFIG_PAGE_TABLE_CHECK=y
diff --git a/mm/Kconfig b/mm/Kconfig
index e443fe8cd6cf..f194ead443d4 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -284,22 +284,45 @@ config SLUB_CPU_PARTIAL
 	  which requires the taking of locks that may cause latency spikes.
 	  Typically one would choose no for a realtime system.
 
-config RANDOM_KMALLOC_CACHES
-	default n
+config PARTITION_KMALLOC_CACHES
 	depends on !SLUB_TINY
-	bool "Randomize slab caches for normal kmalloc"
+	bool "Partitioned slab caches for normal kmalloc"
 	help
-	  A hardening feature that creates multiple copies of slab caches for
-	  normal kmalloc allocation and makes kmalloc randomly pick one based
-	  on code address, which makes the attackers more difficult to spray
-	  vulnerable memory objects on the heap for the purpose of exploiting
-	  memory vulnerabilities.
+	  A hardening feature that creates multiple isolated copies of slab
+	  caches for normal kmalloc allocations. This makes it more difficult
+	  to exploit memory-safety vulnerabilities by attacking vulnerable
+	  co-located memory objects. Several modes are provided.
 
 	  Currently the number of copies is set to 16, a reasonably large value
 	  that effectively diverges the memory objects allocated for different
 	  subsystems or modules into different caches, at the expense of a
-	  limited degree of memory and CPU overhead that relates to hardware and
-	  system workload.
+	  limited degree of memory and CPU overhead that relates to hardware
+	  and system workload.
+
+choice
+	prompt "Partitioned slab cache mode"
+	depends on PARTITION_KMALLOC_CACHES
+	default TYPED_KMALLOC_CACHES
+	help
+	  Selects the slab cache partitioning mode.
+
+config RANDOM_KMALLOC_CACHES
+	bool "Randomize slab caches for normal kmalloc"
+	help
+	  Randomly pick a slab cache based on code address.
+
+config TYPED_KMALLOC_CACHES
+	bool "Type based slab cache selection for normal kmalloc"
+	depends on $(cc-option,-falloc-token-max=123)
+	help
+	  Rely on Clang's allocation tokens to choose a slab cache, where token
+	  IDs are derived from the allocated type.
+
+	  The current effectiveness of Clang's type inference can be judged by
+	  -Rpass=alloc-token, which provides diagnostics where (after dead-code
+	  elimination) type inference failed.
+
+endchoice
 
 endmenu # Slab allocator options
 
diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 00034e37bc9f..76111257bbcc 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -214,7 +214,7 @@ static void test_cache_destroy(void)
 static inline size_t kmalloc_cache_alignment(size_t size)
 {
 	/* just to get ->align so no need to pass in the real caller */
-	enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, 0);
+	enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, __kmalloc_token(0));
 	return kmalloc_caches[type][__kmalloc_index(size, false)]->align;
 }
 
@@ -285,7 +285,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 
 		if (is_kfence_address(alloc)) {
 			struct slab *slab = virt_to_slab(alloc);
-			enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, _RET_IP_);
+			enum kmalloc_cache_type type = kmalloc_type(GFP_KERNEL, __kmalloc_token(size));
 			struct kmem_cache *s = test_cache ?:
 					kmalloc_caches[type][__kmalloc_index(size, false)];
 
diff --git a/mm/slab.h b/mm/slab.h
index 248b34c839b7..e956b59e0bd8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -386,12 +386,12 @@ static inline unsigned int size_index_elem(unsigned int bytes)
  * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
  */
 static inline struct kmem_cache *
-kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, unsigned long caller)
+kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token)
 {
 	unsigned int index;
 
 	if (!b)
-		b = &kmalloc_caches[kmalloc_type(flags, caller)];
+		b = &kmalloc_caches[kmalloc_type(flags, token)];
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
diff --git a/mm/slab_common.c b/mm/slab_common.c
index bfe7c40eeee1..6c826d50c819 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -741,7 +741,7 @@ size_t kmalloc_size_roundup(size_t size)
 		 * The flags don't matter since size_index is common to all.
 		 * Neither does the caller for just getting ->object_size.
 		 */
-		return kmalloc_slab(size, NULL, GFP_KERNEL, 0)->object_size;
+		return kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_token(0))->object_size;
 	}
 
 	/* Above the smaller buckets, size is a multiple of page size. */
@@ -775,26 +775,26 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_RCL_NAME(sz)
 #endif
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
-#define __KMALLOC_RANDOM_CONCAT(a, b) a ## b
-#define KMALLOC_RANDOM_NAME(N, sz) __KMALLOC_RANDOM_CONCAT(KMA_RAND_, N)(sz)
-#define KMA_RAND_1(sz)                  .name[KMALLOC_RANDOM_START +  1] = "kmalloc-rnd-01-" #sz,
-#define KMA_RAND_2(sz)  KMA_RAND_1(sz)  .name[KMALLOC_RANDOM_START +  2] = "kmalloc-rnd-02-" #sz,
-#define KMA_RAND_3(sz)  KMA_RAND_2(sz)  .name[KMALLOC_RANDOM_START +  3] = "kmalloc-rnd-03-" #sz,
-#define KMA_RAND_4(sz)  KMA_RAND_3(sz)  .name[KMALLOC_RANDOM_START +  4] = "kmalloc-rnd-04-" #sz,
-#define KMA_RAND_5(sz)  KMA_RAND_4(sz)  .name[KMALLOC_RANDOM_START +  5] = "kmalloc-rnd-05-" #sz,
-#define KMA_RAND_6(sz)  KMA_RAND_5(sz)  .name[KMALLOC_RANDOM_START +  6] = "kmalloc-rnd-06-" #sz,
-#define KMA_RAND_7(sz)  KMA_RAND_6(sz)  .name[KMALLOC_RANDOM_START +  7] = "kmalloc-rnd-07-" #sz,
-#define KMA_RAND_8(sz)  KMA_RAND_7(sz)  .name[KMALLOC_RANDOM_START +  8] = "kmalloc-rnd-08-" #sz,
-#define KMA_RAND_9(sz)  KMA_RAND_8(sz)  .name[KMALLOC_RANDOM_START +  9] = "kmalloc-rnd-09-" #sz,
-#define KMA_RAND_10(sz) KMA_RAND_9(sz)  .name[KMALLOC_RANDOM_START + 10] = "kmalloc-rnd-10-" #sz,
-#define KMA_RAND_11(sz) KMA_RAND_10(sz) .name[KMALLOC_RANDOM_START + 11] = "kmalloc-rnd-11-" #sz,
-#define KMA_RAND_12(sz) KMA_RAND_11(sz) .name[KMALLOC_RANDOM_START + 12] = "kmalloc-rnd-12-" #sz,
-#define KMA_RAND_13(sz) KMA_RAND_12(sz) .name[KMALLOC_RANDOM_START + 13] = "kmalloc-rnd-13-" #sz,
-#define KMA_RAND_14(sz) KMA_RAND_13(sz) .name[KMALLOC_RANDOM_START + 14] = "kmalloc-rnd-14-" #sz,
-#define KMA_RAND_15(sz) KMA_RAND_14(sz) .name[KMALLOC_RANDOM_START + 15] = "kmalloc-rnd-15-" #sz,
-#else // CONFIG_RANDOM_KMALLOC_CACHES
-#define KMALLOC_RANDOM_NAME(N, sz)
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
+#define __KMALLOC_PARTITION_CONCAT(a, b) a ## b
+#define KMALLOC_PARTITION_NAME(N, sz) __KMALLOC_PARTITION_CONCAT(KMA_PART_, N)(sz)
+#define KMA_PART_1(sz)                  .name[KMALLOC_PARTITION_START +  1] = "kmalloc-part-01-" #sz,
+#define KMA_PART_2(sz)  KMA_PART_1(sz)  .name[KMALLOC_PARTITION_START +  2] = "kmalloc-part-02-" #sz,
+#define KMA_PART_3(sz)  KMA_PART_2(sz)  .name[KMALLOC_PARTITION_START +  3] = "kmalloc-part-03-" #sz,
+#define KMA_PART_4(sz)  KMA_PART_3(sz)  .name[KMALLOC_PARTITION_START +  4] = "kmalloc-part-04-" #sz,
+#define KMA_PART_5(sz)  KMA_PART_4(sz)  .name[KMALLOC_PARTITION_START +  5] = "kmalloc-part-05-" #sz,
+#define KMA_PART_6(sz)  KMA_PART_5(sz)  .name[KMALLOC_PARTITION_START +  6] = "kmalloc-part-06-" #sz,
+#define KMA_PART_7(sz)  KMA_PART_6(sz)  .name[KMALLOC_PARTITION_START +  7] = "kmalloc-part-07-" #sz,
+#define KMA_PART_8(sz)  KMA_PART_7(sz)  .name[KMALLOC_PARTITION_START +  8] = "kmalloc-part-08-" #sz,
+#define KMA_PART_9(sz)  KMA_PART_8(sz)  .name[KMALLOC_PARTITION_START +  9] = "kmalloc-part-09-" #sz,
+#define KMA_PART_10(sz) KMA_PART_9(sz)  .name[KMALLOC_PARTITION_START + 10] = "kmalloc-part-10-" #sz,
+#define KMA_PART_11(sz) KMA_PART_10(sz) .name[KMALLOC_PARTITION_START + 11] = "kmalloc-part-11-" #sz,
+#define KMA_PART_12(sz) KMA_PART_11(sz) .name[KMALLOC_PARTITION_START + 12] = "kmalloc-part-12-" #sz,
+#define KMA_PART_13(sz) KMA_PART_12(sz) .name[KMALLOC_PARTITION_START + 13] = "kmalloc-part-13-" #sz,
+#define KMA_PART_14(sz) KMA_PART_13(sz) .name[KMALLOC_PARTITION_START + 14] = "kmalloc-part-14-" #sz,
+#define KMA_PART_15(sz) KMA_PART_14(sz) .name[KMALLOC_PARTITION_START + 15] = "kmalloc-part-15-" #sz,
+#else // CONFIG_PARTITION_KMALLOC_CACHES
+#define KMALLOC_PARTITION_NAME(N, sz)
 #endif
 
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
@@ -803,7 +803,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 	KMALLOC_RCL_NAME(__short_size)				\
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
-	KMALLOC_RANDOM_NAME(RANDOM_KMALLOC_CACHES_NR, __short_size)	\
+	KMALLOC_PARTITION_NAME(PARTITION_KMALLOC_CACHES_NR, __short_size)	\
 	.size = __size,						\
 }
 
@@ -915,8 +915,8 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 		flags |= SLAB_CACHE_DMA;
 	}
 
-#ifdef CONFIG_RANDOM_KMALLOC_CACHES
-	if (type >= KMALLOC_RANDOM_START && type <= KMALLOC_RANDOM_END)
+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
+	if (type >= KMALLOC_PARTITION_START && type <= KMALLOC_PARTITION_END)
 		flags |= SLAB_NO_MERGE;
 #endif
 
diff --git a/mm/slub.c b/mm/slub.c
index 30003763d224..d3c2beab0ea2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4344,7 +4344,7 @@ EXPORT_SYMBOL(__kmalloc_large_node_noprof);
 
 static __always_inline
 void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
-			unsigned long caller)
+			unsigned long caller, kmalloc_token_t token)
 {
 	struct kmem_cache *s;
 	void *ret;
@@ -4359,29 +4359,29 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
-	s = kmalloc_slab(size, b, flags, caller);
+	s = kmalloc_slab(size, b, flags, token);
 
 	ret = slab_alloc_node(s, NULL, flags, node, caller, size);
 	ret = kasan_kmalloc(s, ret, size, flags);
 	trace_kmalloc(caller, ret, size, s->size, flags, node);
 	return ret;
 }
-void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
+void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, _RET_IP_);
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, _RET_IP_, token);
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);
 
-void *__kmalloc_noprof(size_t size, gfp_t flags)
+void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 {
-	return __do_kmalloc_node(size, NULL, flags, NUMA_NO_NODE, _RET_IP_);
+	return __do_kmalloc_node(size, NULL, flags, NUMA_NO_NODE, _RET_IP_, token);
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
 void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags,
-					 int node, unsigned long caller)
+					 int node, unsigned long caller, kmalloc_token_t token)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, caller);
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, caller, token);
 
 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
@@ -5041,7 +5041,7 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  *
  * Return: pointer to the allocated memory of %NULL in case of failure
  */
-void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
+void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
 {
 	void *ret;
 
@@ -5051,7 +5051,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
 	 */
 	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
 				kmalloc_gfp_adjust(flags, size),
-				node, _RET_IP_);
+				node, _RET_IP_, token);
 	if (ret || size <= PAGE_SIZE)
 		return ret;
 
-- 
2.51.0.rc2.233.g662b1ed5c5-goog


