Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272F9FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 926836B00A9; Fri, 24 Apr 2026 09:24:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD746B00AA; Fri, 24 Apr 2026 09:24:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5566B00AC; Fri, 24 Apr 2026 09:24:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A29A6B00A9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:24:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8B7716019B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:24:46 +0000 (UTC)
X-FDA: 84693519372.25.F2E4DE8
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id D861D180008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:24:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n7IllKre;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3G2_raQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3G2_raQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2wPIwL5iML28/7AmVBGfGMGsfL6v2mEfuOT0orVLws=;
	b=DKtO75qHF9RrCI8VeDMrlZ54+2K1pmXR6fbDGL2Z/4hqeweMRTm+UQcyLhfP9Ww71I6c4s
	HDEnQF5W5ccjV4P36jNDR/5jNHov3GbVT7HYq5qYiTNhikLM2eHqWW+cvYgV7rux+o9OEG
	siNjF15k2XXNHfiKWyj3jKe3n+qtgAY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=n7IllKre;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3G2_raQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3G2_raQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037085; a=rsa-sha256;
	cv=none;
	b=WjUn532Xi7GOmeA0n2lE+PmMGlWcUvo2mkhLT8S5DjhmsmOCJyuWSJG4xeLwCHgI/IAk/h
	7jbYwLQrJJ0laCGqITvlwFw2VqECT3mlHPXUWo57f1g9Q3Ej+blXavdMbSpy/O/Zmu/vI/
	LlwMPfyZTl7X0BcgrlrXT4Vyvcy/Cpw=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488e097a270so56153045e9.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 06:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777037083; x=1777641883; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=E2wPIwL5iML28/7AmVBGfGMGsfL6v2mEfuOT0orVLws=;
        b=n7IllKrefQp30SvH78+7B6rkRAk+r5PNu+LdZvj4Nzm7SYTVHW/8dfmwEmkyluA3GD
         XvaultSN3GrO2dj/u5I74R9UedwpwicFLooP8RiZ9RN4vF6h9E2cSoG2WJ+QQ+Oyto6c
         +JuqOmcGebMcKIfXnj2BMDTgny7lam7pxOkcXXkYDzbJXgKuOyHAwgopFJ3LXNSR7Mly
         LbYF+C/2k+d64FY6oa/uNXS8F9lNG7nvaIdzyTxWVHXXDPucr5m5epiCouXJsy4ZUXeS
         O62Qr0/5UvbZEfJpVutaIDB9AReG4+HTHMKeJdWoMR38rxzHHckbbrKpMPV/yTr0LAkf
         KvRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777037083; x=1777641883;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E2wPIwL5iML28/7AmVBGfGMGsfL6v2mEfuOT0orVLws=;
        b=OQTz2cPnzBCbk/SP5mwkYQLrmAh3VZMPCf9HKhycDUZCdWiLbiQajTZlBGjoQJFcc9
         AboPEvN/72nQ06ZIxpL8+cHSjqQ+ZqbWPC07hOLV3SxUM1skhK2SnNfoyiuspbqTvVqN
         OftwzmSir40H+xWIZc/Gcp6DV1fvfO0HGcg445M/h0GUszoYsbNaqCmhmvMgpOK6qp/U
         nNEo0HJcZUKxbUxcOhiyHpH3sHvZETm8WoLscT6Ugn+AkQbMlmFo+HlJ6RGGI3K2LMNc
         gixfUGUe+vsUDGrI800QB2MftF+3dU7k3q0KXe1nVVQmR+B9aF4bx3XmB8KPaqFn0ql7
         Q3MA==
X-Forwarded-Encrypted: i=1; AFNElJ8stuo1uoz+j1XEZGOqipe5m1KRpd77OX9FneYkC5c7ur9DdCSD3pr8HBcHdTKXh5NR8dACZmR7ZA==@kvack.org
X-Gm-Message-State: AOJu0YyQCHV2s8fdWAtlWHMTZfE9h6Earf5dmxozp4/KRRvMCKNTxN7P
	xlJnGaTdMRh23jPcc7Siozjji9eqhuUdUxdsMFnsCi0wPRPfpoylfQBVucNrqNAi0VcIHMYBTCS
	rBw==
X-Received: from wmjl23.prod.google.com ([2002:a7b:c357:0:b0:485:f1d7:164d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:5295:b0:486:f634:ef1
 with SMTP id 5b1f17b1804b1-488fb77d0fdmr450013595e9.17.1777037083109; Fri, 24
 Apr 2026 06:24:43 -0700 (PDT)
Date: Fri, 24 Apr 2026 15:24:02 +0200
In-Reply-To: <20260424132427.2703076-1-elver@google.com>
Mime-Version: 1.0
References: <20260424132427.2703076-1-elver@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260424132427.2703076-2-elver@google.com>
Subject: [PATCH v3 2/2] slab: fix kernel-docs for mm-api
From: Marco Elver <elver@google.com>
To: elver@google.com, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, 
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Kees Cook <kees@kernel.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com, 
	llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D861D180008
X-Stat-Signature: c19q1ko7hmx3k1dycaew18bng9r15dq7
X-HE-Tag: 1777037084-371889
X-HE-Meta: U2FsdGVkX1/qJXU4p3WmEuQPWqGXiRO9S1B+8mLX8/wS60WH0gwCXeWJ2kP1iuBN1i9Epse4RFbn5ZAT048FCU5iKx+c+Fyd7AHNhM+7IUaVbxmtePN0vPAgmSWfT95ZqsXjuPNUncq4zSfUbAahmbfMrLC/8J3QfSjanJghK7sPz4vswTXIMJHs+AWPWeBXYyLd6vfFpDZandyrp6yRTw88kkcSS/I+DtascxwFaGTAC9L0gip7K+esY4rFRBrv30eZ3UASph2wLMMSMTxA/Zq39BPym9lCEjYkj7Pq3g75L3T3JME6S7z326reeV5l7xim08x90y80MVlPGcJVooVb8mFaUoEQNManKLQkpm+fAS1kfaquxjA0cNN9jQxlS2AIaSFtW4TjD11nCcYUyE2+HF+5n0CggQEyQQOQxRE9VpHwWzsayQbmXCoefVX5bLcNON9nwTjQ4OXDPVt9jfJR36dgvJc0+OEdXCPWC/BzfWLGph/bhD2tl0OdJWJBgjwxrzzC76WEGp77EEwLpwTDnRHXs81kyfMCFlEaXrlWjZ4rwj8pLGUTEwmlZ/Z5nd5mLFnFBiv92GQchmjKcGSnwFtbbcms5ze5nhZfYRA4sMMsx21i1gbsvPL5Rdoo2cRKmBetYRYVeoqzJb9xS3y4kscxLicoK7flAKG83UhYjHRoRvQ5+f9LqUWcB8pQjx8Q3hFp63O+UDBrAm0vLBoZduaybn7TabbGJOrD2oICNdu/m04JR7phVvnfMsRTxkOz66vs4xp48uEF4wQrvJ/iDW4JhQsefz8vD2xrHptt+Tl5/UccMSX10etgXLvXJkhCGgFfF6w5zZ3sFCgOGb6ymujAu8uvN4jGv3K790yI/pp6NlT76rg0ujTRFi6A/K8pR42L0DxcLmoqFpf2nIsa6MhAFiDAhLGnbD8kbcVQYtFI/OB2JtRp3l9sg6vnGW1ajDjY0zoe0+ekMLZ
 fLg9Z9mO
 n1jRKSdDpyCBWgDYjKjRs32a78WVIimVXE62I1leddl44LMJyA4wwG0EGjdFnYYLMu4lh8t9ElN+oPI/0nxkilAe6Y1KmJfqQP6Zo3mDJMRqUSdCxImptpFbIo2G7GIkno/TxqNEJUpn6YT3HfievBbntK9aR+cbcn8EJ9hM2aTxi6J8V4WKPYH1863nK0haPVNM3guOVO6GDKNMKVqhTBzTGpDGCBF9lb8WNRJrxRYJihmFA0wN6f6hYUnWxdKmAWqXxyjvEopfhdPmSgeOpZR9QQx8kuvPFGbERoWD/CtaWw7qVrrO5n3ucuiMO8y7UprN3MA60Ru99/u1mYyC1EzFMMXvnZTJMfHVCp1QWKZZamp6LsEPX5Tj1vwPtH6TwnDECvjdEJ98IBWFx7t7tDGeOh7bS/rzSXdRP/6PE7OwQb7G617lcEcdfFzVG5yOlrOL6PV2aWYZyfxyqNA/kpgCxPmBlu9RPmkzo96KpGHd595o0m2NVSGb8fCSq3Pnb6VBFcODiaaFuWZVvTiXDx6xAf8UPyO3WNnGrOd9ffRkLe1xoD/03FZPPuZOZLzARnjeNlvVLXx71TAPavxdbT5zc7LEg93YZEqo1G85niqSFKgIP0k/JRhcbn01tgfQOyfG2cK2z6UE2idbvYzvq2Af1vFIk4Ww6QtT+lf9d0CjO0bfCKJLGCDoHny7SMeDY6RNz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mm-api kernel-doc comments have been broken for a while, as many
documented symbols shifted from being direct function definitions to
macros wrapping _noprof implementations during the introduction of
allocation tagging (starting with commit 7bd230a26648 "mm/slab: enable
slab allocation tagging for kmalloc and friends").

When the kernel-doc block remains above the internal implementation
function but uses the public API name, the documentation generator fails
to associate the documented symbol and generates warnings and fails to
emit the documentation.

Fix this by:

1. Moving the kernel-doc comment blocks from slub.c to slab.h, placing
   them directly above the user-facing macros.

2. Converting the variadic macros for the documented APIs to use
   explicit arguments.

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
---
 include/linux/slab.h | 192 ++++++++++++++++++++++++++++++++-----------
 mm/slub.c            |  98 ----------------------
 2 files changed, 144 insertions(+), 146 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index c232f8a10af6..dcff0da1c01c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -530,7 +530,46 @@ void * __must_check krealloc_node_align_noprof(const void *objp,
 					       unsigned long align,
 					       gfp_t flags, int nid) __realloc_size(2);
 #define krealloc_noprof(_o, _s, _f)	krealloc_node_align_noprof(_o, PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), 1, _f, NUMA_NO_NODE)
-#define krealloc_node_align(_o, _s, _a, _f, _n)	alloc_hooks(krealloc_node_align_noprof(_o, PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), _a, _f, _n))
+/**
+ * krealloc_node_align - reallocate memory. The contents will remain unchanged.
+ * @p: object to reallocate memory for.
+ * @new_size: how many bytes of memory are required.
+ * @align: desired alignment.
+ * @flags: the type of memory to allocate.
+ * @nid: NUMA node or NUMA_NO_NODE
+ *
+ * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
+ * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
+ *
+ * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
+ * Documentation/core-api/memory-allocation.rst for more details.
+ *
+ * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
+ * initial memory allocation, every subsequent call to this API for the same
+ * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
+ * __GFP_ZERO is not fully honored by this API.
+ *
+ * When slub_debug_orig_size() is off, krealloc() only knows about the bucket
+ * size of an allocation (but not the exact size it was allocated with) and
+ * hence implements the following semantics for shrinking and growing buffers
+ * with __GFP_ZERO::
+ *
+ *           new             bucket
+ *   0       size             size
+ *   |--------|----------------|
+ *   |  keep  |      zero      |
+ *
+ * Otherwise, the original allocation size 'orig_size' could be used to
+ * precisely clear the requested size, and the new size will also be stored
+ * as the new 'orig_size'.
+ *
+ * In any case, the contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.
+ *
+ * Return: pointer to the allocated memory or %NULL in case of error
+ */
+#define krealloc_node_align(p, new_size, align, flags, nid) \
+	alloc_hooks(krealloc_node_align_noprof(p, PASS_TOKEN_PARAMS(new_size, __kmalloc_token(new_size)), align, flags, nid))
 #define krealloc_node(_o, _s, _f, _n)	krealloc_node_align(_o, _s, 1, _f, _n)
 #define krealloc(...)			krealloc_node(__VA_ARGS__, NUMA_NO_NODE)
 
@@ -913,6 +952,22 @@ void *__kmalloc_large_noprof(size_t size, gfp_t flags)
 void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
 				__assume_page_alignment __alloc_size(1);
 
+static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
+{
+	if (__builtin_constant_p(size) && size) {
+		unsigned int index;
+
+		if (size > KMALLOC_MAX_CACHE_SIZE)
+			return __kmalloc_large_noprof(size, flags);
+
+		index = kmalloc_index(size);
+		return __kmalloc_cache_noprof(
+				kmalloc_caches[kmalloc_type(flags, token)][index],
+				flags, size);
+	}
+	return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
+}
+#define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 /**
  * kmalloc - allocate kernel memory
  * @size: how many bytes of memory are required.
@@ -968,27 +1023,22 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
  *	Try really hard to succeed the allocation but fail
  *	eventually.
  */
-static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
-{
-	if (__builtin_constant_p(size) && size) {
-		unsigned int index;
-
-		if (size > KMALLOC_MAX_CACHE_SIZE)
-			return __kmalloc_large_noprof(size, flags);
-
-		index = kmalloc_index(size);
-		return __kmalloc_cache_noprof(
-				kmalloc_caches[kmalloc_type(flags, token)][index],
-				flags, size);
-	}
-	return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
-}
-#define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
-#define kmalloc(...)				alloc_hooks(kmalloc_noprof(__VA_ARGS__))
+#define kmalloc(size, flags)			alloc_hooks(kmalloc_noprof(size, flags))
 
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node);
 #define kmalloc_nolock_noprof(_s, _f, _n)	_kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), _f, _n)
-#define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
+/**
+ * kmalloc_nolock - Allocate an object of given size from any context.
+ * @size: size to allocate
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
+ * allowed.
+ * @node: node number of the target node.
+ *
+ * Return: pointer to the new object or NULL in case of error.
+ * NULL does not mean EBUSY or EAGAIN. It means ENOMEM.
+ * There is no reason to call it again and expect !NULL.
+ */
+#define kmalloc_nolock(size, gfp_flags, node)	alloc_hooks(kmalloc_nolock_noprof(size, gfp_flags, node))
 
 /**
  * __alloc_objs - Allocate objects of a given type using
@@ -1115,23 +1165,36 @@ static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, g
 #define kmalloc_node_noprof(...)		_kmalloc_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_node(...)			alloc_hooks(kmalloc_node_noprof(__VA_ARGS__))
 
+static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t size, gfp_t flags, kmalloc_token_t token)
+{
+	size_t bytes;
+
+	if (unlikely(check_mul_overflow(n, size, &bytes)))
+		return NULL;
+	return _kmalloc_noprof(bytes, flags, token);
+}
+#define kmalloc_array_noprof(...)		_kmalloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 /**
  * kmalloc_array - allocate memory for an array.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t size, gfp_t flags, kmalloc_token_t token)
+#define kmalloc_array(n, size, flags)		alloc_hooks(kmalloc_array_noprof(n, size, flags))
+
+static inline __realloc_size(2, 3) void * __must_check _krealloc_array_noprof(void *p,
+								       size_t new_n,
+								       size_t new_size,
+								       gfp_t flags, kmalloc_token_t token)
 {
 	size_t bytes;
 
-	if (unlikely(check_mul_overflow(n, size, &bytes)))
+	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
 		return NULL;
-	return _kmalloc_noprof(bytes, flags, token);
-}
-#define kmalloc_array_noprof(...)		_kmalloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
-#define kmalloc_array(...)			alloc_hooks(kmalloc_array_noprof(__VA_ARGS__))
 
+	return krealloc_node_align_noprof(p, PASS_TOKEN_PARAMS(bytes, token), 1, flags, NUMA_NO_NODE);
+}
+#define krealloc_array_noprof(...)		_krealloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 /**
  * krealloc_array - reallocate memory for an array.
  * @p: pointer to the memory chunk to reallocate
@@ -1149,20 +1212,7 @@ static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t si
  * In any case, the contents of the object pointed to are preserved up to the
  * lesser of the new and old sizes.
  */
-static inline __realloc_size(2, 3) void * __must_check _krealloc_array_noprof(void *p,
-								       size_t new_n,
-								       size_t new_size,
-								       gfp_t flags, kmalloc_token_t token)
-{
-	size_t bytes;
-
-	if (unlikely(check_mul_overflow(new_n, new_size, &bytes)))
-		return NULL;
-
-	return krealloc_node_align_noprof(p, PASS_TOKEN_PARAMS(bytes, token), 1, flags, NUMA_NO_NODE);
-}
-#define krealloc_array_noprof(...)		_krealloc_array_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
-#define krealloc_array(...)			alloc_hooks(krealloc_array_noprof(__VA_ARGS__))
+#define krealloc_array(p, new_n, new_size, flags) alloc_hooks(krealloc_array_noprof(p, new_n, new_size, flags))
 
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
@@ -1214,17 +1264,17 @@ static inline __alloc_size(1, 2) void *_kmalloc_array_node_noprof(size_t n, size
  */
 #define kmem_cache_zalloc(_k, _flags)		kmem_cache_alloc(_k, (_flags)|__GFP_ZERO)
 
-/**
- * kzalloc - allocate memory. The memory is set to zero.
- * @size: how many bytes of memory are required.
- * @flags: the type of memory to allocate (see kmalloc).
- */
 static inline __alloc_size(1) void *_kzalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
 {
 	return _kmalloc_noprof(size, flags | __GFP_ZERO, token);
 }
 #define kzalloc_noprof(...)			_kzalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
-#define kzalloc(...)				alloc_hooks(kzalloc_noprof(__VA_ARGS__))
+/**
+ * kzalloc - allocate memory. The memory is set to zero.
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+#define kzalloc(size, flags)			alloc_hooks(kzalloc_noprof(size, flags))
 #define kzalloc_node(_size, _flags, _node)	kmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
 void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
@@ -1233,7 +1283,26 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	__kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, NULL, __kmalloc_token(_size)), _align, _flags, _node)
 #define kvmalloc_node_align(...)		\
 	alloc_hooks(kvmalloc_node_align_noprof(__VA_ARGS__))
-#define kvmalloc_node(_s, _f, _n)		kvmalloc_node_align(_s, 1, _f, _n)
+/**
+ * kvmalloc_node - attempt to allocate physically contiguous memory, but upon
+ * failure, fall back to non-contiguous (vmalloc) allocation.
+ * @size: size of the request.
+ * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
+ * @node: numa node to allocate from
+ *
+ * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
+ * Documentation/core-api/memory-allocation.rst for more details.
+ *
+ * Uses kmalloc to get the memory but if the allocation fails then falls back
+ * to the vmalloc allocator. Use kvfree for freeing the memory.
+ *
+ * GFP_NOWAIT and GFP_ATOMIC are supported, the __GFP_NORETRY modifier is not.
+ * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
+ * preferable to the vmalloc fallback, due to visible performance drawbacks.
+ *
+ * Return: pointer to the allocated memory of %NULL in case of failure
+ */
+#define kvmalloc_node(size, flags, node)	kvmalloc_node_align(size, 1, flags, node)
 #define kvmalloc_node_noprof(size, flags, node)	\
 	kvmalloc_node_align_noprof(size, 1, flags, node)
 #define kvmalloc(...)				kvmalloc_node(__VA_ARGS__, NUMA_NO_NODE)
@@ -1266,8 +1335,35 @@ _kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmallo
 
 void *kvrealloc_node_align_noprof(const void *p, DECL_TOKEN_PARAMS(size, token), unsigned long align,
 				  gfp_t flags, int nid) __realloc_size(2);
-#define kvrealloc_node_align(_p, _s, _a, _f, _n)	\
-	alloc_hooks(kvrealloc_node_align_noprof(_p, PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), _a, _f, _n))
+/**
+ * kvrealloc_node_align - reallocate memory; contents remain unchanged
+ * @p: object to reallocate memory for
+ * @size: the size to reallocate
+ * @align: desired alignment
+ * @flags: the flags for the page level allocator
+ * @nid: NUMA node id
+ *
+ * If @p is %NULL, kvrealloc() behaves exactly like kvmalloc(). If @size is 0
+ * and @p is not a %NULL pointer, the object pointed to is freed.
+ *
+ * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
+ * Documentation/core-api/memory-allocation.rst for more details.
+ *
+ * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
+ * initial memory allocation, every subsequent call to this API for the same
+ * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
+ * __GFP_ZERO is not fully honored by this API.
+ *
+ * In any case, the contents of the object pointed to are preserved up to the
+ * lesser of the new and old sizes.
+ *
+ * This function must not be called concurrently with itself or kvfree() for the
+ * same memory allocation.
+ *
+ * Return: pointer to the allocated memory or %NULL in case of error
+ */
+#define kvrealloc_node_align(p, size, align, flags, nid)	\
+	alloc_hooks(kvrealloc_node_align_noprof(p, PASS_TOKEN_PARAMS(size, __kmalloc_token(size)), align, flags, nid))
 #define kvrealloc_node(_p, _s, _f, _n)		kvrealloc_node_align(_p, _s, 1, _f, _n)
 #define kvrealloc(...)				kvrealloc_node(__VA_ARGS__, NUMA_NO_NODE)
 
diff --git a/mm/slub.c b/mm/slub.c
index ccb208cfbecd..dbc3c947e5be 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5310,17 +5310,6 @@ void *__kmalloc_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
-/**
- * kmalloc_nolock - Allocate an object of given size from any context.
- * @size: size to allocate
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, __GFP_ZERO, __GFP_NO_OBJ_EXT
- * allowed.
- * @node: node number of the target node.
- *
- * Return: pointer to the new object or NULL in case of error.
- * NULL does not mean EBUSY or EAGAIN. It means ENOMEM.
- * There is no reason to call it again and expect !NULL.
- */
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
 {
 	gfp_t alloc_gfp = __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
@@ -6717,44 +6706,6 @@ __do_krealloc(const void *p, size_t new_size, unsigned long align, gfp_t flags,
 	return ret;
 }
 
-/**
- * krealloc_node_align - reallocate memory. The contents will remain unchanged.
- * @p: object to reallocate memory for.
- * @new_size: how many bytes of memory are required.
- * @align: desired alignment.
- * @flags: the type of memory to allocate.
- * @nid: NUMA node or NUMA_NO_NODE
- *
- * If @p is %NULL, krealloc() behaves exactly like kmalloc().  If @new_size
- * is 0 and @p is not a %NULL pointer, the object pointed to is freed.
- *
- * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
- * Documentation/core-api/memory-allocation.rst for more details.
- *
- * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
- * initial memory allocation, every subsequent call to this API for the same
- * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
- * __GFP_ZERO is not fully honored by this API.
- *
- * When slub_debug_orig_size() is off, krealloc() only knows about the bucket
- * size of an allocation (but not the exact size it was allocated with) and
- * hence implements the following semantics for shrinking and growing buffers
- * with __GFP_ZERO::
- *
- *           new             bucket
- *   0       size             size
- *   |--------|----------------|
- *   |  keep  |      zero      |
- *
- * Otherwise, the original allocation size 'orig_size' could be used to
- * precisely clear the requested size, and the new size will also be stored
- * as the new 'orig_size'.
- *
- * In any case, the contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.
- *
- * Return: pointer to the allocated memory or %NULL in case of error
- */
 void *krealloc_node_align_noprof(const void *p, DECL_TOKEN_PARAMS(new_size, token), unsigned long align,
 				 gfp_t flags, int nid)
 {
@@ -6797,28 +6748,6 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
 	return flags;
 }
 
-/**
- * __kvmalloc_node - attempt to allocate physically contiguous memory, but upon
- * failure, fall back to non-contiguous (vmalloc) allocation.
- * @size: size of the request.
- * @b: which set of kmalloc buckets to allocate from.
- * @token: allocation token.
- * @align: desired alignment.
- * @flags: gfp mask for the allocation - must be compatible (superset) with GFP_KERNEL.
- * @node: numa node to allocate from
- *
- * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
- * Documentation/core-api/memory-allocation.rst for more details.
- *
- * Uses kmalloc to get the memory but if the allocation fails then falls back
- * to the vmalloc allocator. Use kvfree for freeing the memory.
- *
- * GFP_NOWAIT and GFP_ATOMIC are supported, the __GFP_NORETRY modifier is not.
- * __GFP_RETRY_MAYFAIL is supported, and it should be used only if kmalloc is
- * preferable to the vmalloc fallback, due to visible performance drawbacks.
- *
- * Return: pointer to the allocated memory of %NULL in case of failure
- */
 void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
 			     gfp_t flags, int node)
 {
@@ -6900,33 +6829,6 @@ void kvfree_sensitive(const void *addr, size_t len)
 }
 EXPORT_SYMBOL(kvfree_sensitive);
 
-/**
- * kvrealloc_node_align - reallocate memory; contents remain unchanged
- * @p: object to reallocate memory for
- * @size: the size to reallocate
- * @align: desired alignment
- * @flags: the flags for the page level allocator
- * @nid: NUMA node id
- *
- * If @p is %NULL, kvrealloc() behaves exactly like kvmalloc(). If @size is 0
- * and @p is not a %NULL pointer, the object pointed to is freed.
- *
- * Only alignments up to those guaranteed by kmalloc() will be honored. Please see
- * Documentation/core-api/memory-allocation.rst for more details.
- *
- * If __GFP_ZERO logic is requested, callers must ensure that, starting with the
- * initial memory allocation, every subsequent call to this API for the same
- * memory allocation is flagged with __GFP_ZERO. Otherwise, it is possible that
- * __GFP_ZERO is not fully honored by this API.
- *
- * In any case, the contents of the object pointed to are preserved up to the
- * lesser of the new and old sizes.
- *
- * This function must not be called concurrently with itself or kvfree() for the
- * same memory allocation.
- *
- * Return: pointer to the allocated memory or %NULL in case of error
- */
 void *kvrealloc_node_align_noprof(const void *p, DECL_TOKEN_PARAMS(size, token), unsigned long align,
 				  gfp_t flags, int nid)
 {
-- 
2.54.0.545.g6539524ca2-goog


