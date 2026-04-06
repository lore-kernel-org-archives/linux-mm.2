Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2FE7E9D831
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 04:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC4A26B0088; Mon,  6 Apr 2026 00:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4EBA6B0089; Mon,  6 Apr 2026 00:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A16656B008A; Mon,  6 Apr 2026 00:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D08A6B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 00:28:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D7965B7701
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 04:28:18 +0000 (UTC)
X-FDA: 84626849076.14.9E7D84F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 42E4C140003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 04:28:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LrIhyVRw;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775449697; a=rsa-sha256;
	cv=none;
	b=1DawGjTwyRy/W/TR4mIHpzU3oV28F1s9MYMFWEt22NAtwq8clQEkiQnpzXACeIuzhO1R5q
	/gE8/FMDgCxehdjUUTmEjQkQjT7eMoaXV+MjcFa6qASFL4Wm4OmCCMNUAxFwE58GVKqJIO
	FL54uU93yMnGbaeuSM7gDdIvajiuln4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775449697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2hURVLDrM6B8hIf5RW31VyEqW/sq/fQ8CbDDCGZjN4=;
	b=bol8uctx3Orck1ujpgchJc3b3XLC3PGyG5b+xIb3HrQ9WEvN9nWVTXKOsFQMeOwrhiI8mY
	u+5CpScgZClQnRZeF20hnXUv66lp6pJpMeN4fRks5tvRmDq1NhrQyLH9dSmaL7YYoaXvSo
	H7vNZkn+iPSTGHicVfUNFRMgv7Of4Bo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LrIhyVRw;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 381D1600AC;
	Mon,  6 Apr 2026 04:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD13C4CEF7;
	Mon,  6 Apr 2026 04:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775449695;
	bh=uYGceNTzNuZmnfMgHyxFjYMImRSA6EY2IdzY776syzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LrIhyVRwlhPr2buj/spqkEinh0TSUCphFFxWRJXa2SZtyWFV6c4MxfuD5ms92G8Gl
	 vF2Xwudli8dgQTWDDFEh2TVvmX9GKFpLuavPEKdvydy+HtFjT5cJUef0ABrMCT60Bh
	 7jGHLax2sgOPSsQvn0dFRvioqMBwroi6D1bIVOv3zMa8uJc1tQU4nXJY0ouygzxw4d
	 BSuRScIDayM5+b1FbWHSly4IL1lsYndWt71ihRoSN3F/8njW79cQ5nAfOC8QuJgyYW
	 JRi2kSAo5UKGNlmcsgsdFWu0K7wAXftMgPVNCSFAi5N4Xegxsa1y1AlDGKWok42OFq
	 MW/UF3hsWgP/w==
Date: Mon, 6 Apr 2026 13:28:13 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Hao Li <hao.li@linux.dev>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev, Andrey Konovalov <andreyknvl@gmail.com>,
	Florent Revest <revest@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jann Horn <jannh@google.com>, KP Singh <kpsingh@kernel.org>,
	Matteo Rizzo <matteorizzo@google.com>
Subject: Re: [PATCH v1] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <adM2XVZf1DekahlY@hyeyoo>
References: <20260331111240.153913-1-elver@google.com>
 <ac9d5O5XehnXRc5A@hyeyoo>
 <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0fe363c-2e8f-44a4-9b64-3fa3ba9a5773@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42E4C140003
X-Stat-Signature: 4fo85jhusmwksuqbhy1j88jp49a5opu3
X-HE-Tag: 1775449697-886719
X-HE-Meta: U2FsdGVkX1+KAL27QruHnM1G/HT5wNWR9b9xKqqTpX35YtbqjXy1eWMW+3KYJXRaqgxaFj026QV+mxmDOYbcPEJdkw5bJ1/3qsVS/m/ulbeTCrcl37gbeBbXZEj63um1bTHhuLVresaYCepQGlck5rMZScYIX5VWtoKLJWhGCXi6YaB33d3pLtY5QAl2m6PSzLtUt9JSlowtu9dGT0udL26pcrkmfT14550obfxkxuchrvcZdda1faXe4wgghI7R63bae+Tr7m+ArJ2csT6kS3aw2OXAkmtCjWQzNSytiP7B9dqLlVP1BQi2E4U4/ds0HQgrcMdhm3C5U9Od/vY2dmf3R/cRoGPKrvQhNkfcYB122/eQ9tpvk6QA5nSl4sxE57a5FXJWAoTemT6EsGjLdS/cBhwV0Jch0fA8zN6GmfamzqapdwE1oSGPgWcla12YZrpT5P4e2W6rzh+eoWZGrYOi73ZujG7I/iTbfWPNZwrUjR+UTCR8Z5aJadt+SylUallEg5/PHftSNhG6zimRjjWMH4Vc5XDkv8uhdyAaCI1CXrGrooDOgrd2V1okEwqsELmqnDNzi6tbG3VRNy7yjwPJTtSQCEQUjfrAQ0FYLw550cQpBtBozifvHBfxps6y0TLgIEaMZWWySBwilkQ+FPuCupV/uCSLH68ZehGwtYzmOHfmdbfEbEJq2rl6QZp5EcI1Aayf5NexHhztZ/9zmUPUl1jjGAWCbmyBuJ+yTlzNXFXbabgee2CF5RNQOTAQx2Uc5B/cYrMXLni+JpTx/oZnp3IqiX66mFuz8TooiutnPBaedOatxar9y012aGcovfuD9LuHryG2QGRIxlCSV8upomF5mzWMPEYKTEwb1TAHvmcUofVvJJ2ls5JbvPxGb/f0Vxl94OUY4u3Wk9zgQdIvrHlZCEJ0LCxHJ2alC0cZhPbtuG8QhFlOJ0d3ElyP9zyP8NvRGY9B1hGl31C
 MArmJhAl
 j3WOMS64s0OI3o1ZRzSwdDfI7MxYANenjDFyQ20H6zDspKW71OMVVuIxm+M6r0hLaWIarEV4QuPa0VfuHUMYZBucohTU70v8lBJRwPGACUc91wpMKF1Be0TeN8tvvTfbv4Qim3TI2CpT2VfBWGlktpA9Tt2JZG3XtgnIYa1QNZOe/YEaDCkxNNmazX7+ufXUw2uWzbWVMuZFq1o7Uilxx0PWWXentUruab9aGzNrl/VVm/wbgGjAI7eEeV70NU21GjFsiVgNrZBy+NLrOF8qWi5H+PKOTJ4q3kOAfHh+//yQglDeaPCOfSWuQudsm2SHbJDQ1Go4ZZTn5hBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 03, 2026 at 08:29:22PM +0200, Vlastimil Babka (SUSE) wrote:
> On 4/3/26 08:27, Harry Yoo (Oracle) wrote:
> >> diff --git a/include/linux/slab.h b/include/linux/slab.h
> >> index 15a60b501b95..c0bf00ee6025 100644
> >> --- a/include/linux/slab.h
> >> +++ b/include/linux/slab.h
> >> @@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
> >>   * with the exception of kunit tests
> >>   */
> >>  
> >> -void *__kmalloc_noprof(size_t size, gfp_t flags)
> >> +void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
> >>  				__assume_kmalloc_alignment __alloc_size(1);
> >>  
> >> -void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> >> +void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
> >>  				__assume_kmalloc_alignment __alloc_size(1);
> > 
> > So the @token parameter is unused when CONFIG_PARTITION_KMALLOC_CACHES is
> > disabled but still increases the kernel size by a few kilobytes...
> > but yeah I'm not sure if we can get avoid it without hurting readability.
> > 
> > Just saying. (does anybody care?)
> 
> Well we did care enough with CONFIG_SLAB_BUCKETS to hide the unused param
> using DECL_BUCKET_PARAMS(),

Hmm yeah.

I wasn't sure if we could do this without hurting readability,
but perhaps we could...

> so maybe extend that idea?
> I think it's not just kernel size, but increased register pressure etc.

Something like this should work? (diff on top of this patch)

-- 
Cheers,
Harry / Hyeonggon

diff --git a/include/linux/slab.h b/include/linux/slab.h
index c0bf00ee6025..0496d2e63f5e 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -871,16 +871,32 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
 #define PASS_BUCKET_PARAM(_b)		NULL
 #endif

+#ifdef CONFIG_PARTITION_KMALLOC_CACHES
+#define DECL_TOKEN_PARAM(_token)	, kmalloc_token_t (_token)
+#define _PASS_TOKEN_PARAM(_token)	, (_token)
+#define PASS_TOKEN_PARAM(_token)	(_token)
+#else
+#define DECL_TOKEN_PARAM(_token)
+#define _PASS_TOKEN_PARAM(_token)
+#define PASS_TOKEN_PARAM(_token)	((kmalloc_token_t){})
+#endif
+
+#define DECL_KMALLOC_PARAMS(_size, _b, _token)	DECL_BUCKET_PARAMS(_size, _b) \
+						DECL_TOKEN_PARAM(_token)
+
+#define PASS_KMALLOC_PARAMS(_size, _b, _token)	PASS_BUCKET_PARAMS(_size, _b) \
+						_PASS_TOKEN_PARAM(_token)
+
 /*
  * The following functions are not to be used directly and are intended only
  * for internal use from kmalloc() and kmalloc_node()
  * with the exception of kunit tests
  */

-void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
+void *__kmalloc_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags)
 				__assume_kmalloc_alignment __alloc_size(1);

-void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
+void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
 				__assume_kmalloc_alignment __alloc_size(1);

 void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t size)
@@ -964,7 +980,7 @@ static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t
 				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, size);
 	}
-	return __kmalloc_noprof(size, flags, token);
+	return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
 }
 #define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc(...)				alloc_hooks(kmalloc_noprof(__VA_ARGS__))
@@ -1075,10 +1091,10 @@ void *_kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node, kmalloc_tok
 	__alloc_flex(kvzalloc, default_gfp(__VA_ARGS__), typeof(P), FAM, COUNT)

 #define kmem_buckets_alloc(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, __kmalloc_token(_size)))
+	alloc_hooks(__kmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE))

 #define kmem_buckets_alloc_track_caller(_b, _size, _flags)	\
-	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(_size, _b), _flags, NUMA_NO_NODE, _RET_IP_, __kmalloc_token(_size)))
+	alloc_hooks(__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), _flags, NUMA_NO_NODE, _RET_IP_))

 static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, gfp_t flags, int node, kmalloc_token_t token)
 {
@@ -1093,7 +1109,7 @@ static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, g
 				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, node, size);
 	}
-	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, token);
+	return __kmalloc_node_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags, node);
 }
 #define kmalloc_node_noprof(...)		_kmalloc_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_node(...)			alloc_hooks(kmalloc_node_noprof(__VA_ARGS__))
@@ -1154,10 +1170,10 @@ static inline __realloc_size(2, 3) void * __must_check krealloc_array_noprof(voi
  */
 #define kcalloc(n, size, flags)		kmalloc_array(n, size, (flags) | __GFP_ZERO)

-void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node,
-					 unsigned long caller, kmalloc_token_t token) __alloc_size(1);
+void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node,
+					 unsigned long caller) __alloc_size(1);
 #define kmalloc_node_track_caller_noprof(size, flags, node, caller) \
-	__kmalloc_node_track_caller_noprof(PASS_BUCKET_PARAMS(size, NULL), flags, node, caller, __kmalloc_token(size))
+	__kmalloc_node_track_caller_noprof(PASS_KMALLOC_PARAMS(size, NULL, __kmalloc_token(size)), flags, node, caller)
 #define kmalloc_node_track_caller(...)		\
 	alloc_hooks(kmalloc_node_track_caller_noprof(__VA_ARGS__, _RET_IP_))

@@ -1183,7 +1199,7 @@ static inline __alloc_size(1, 2) void *_kmalloc_array_node_noprof(size_t n, size
 		return NULL;
 	if (__builtin_constant_p(n) && __builtin_constant_p(size))
 		return _kmalloc_node_noprof(bytes, flags, node, token);
-	return __kmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), flags, node, token);
+	return __kmalloc_node_noprof(PASS_KMALLOC_PARAMS(bytes, NULL, token), flags, node);
 }
 #define kmalloc_array_node_noprof(...)		_kmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc_array_node(...)			alloc_hooks(kmalloc_array_node_noprof(__VA_ARGS__))
@@ -1209,10 +1225,10 @@ static inline __alloc_size(1) void *_kzalloc_noprof(size_t size, gfp_t flags, km
 #define kzalloc(...)				alloc_hooks(kzalloc_noprof(__VA_ARGS__))
 #define kzalloc_node(_size, _flags, _node)	kmalloc_node(_size, (_flags)|__GFP_ZERO, _node)

-void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
-			     gfp_t flags, int node, kmalloc_token_t token) __alloc_size(1);
+void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
+			     gfp_t flags, int node) __alloc_size(1);
 #define kvmalloc_node_align_noprof(_size, _align, _flags, _node)	\
-	__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, NULL), _align, _flags, _node, __kmalloc_token(_size))
+	__kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, NULL, __kmalloc_token(_size)), _align, _flags, _node)
 #define kvmalloc_node_align(...)		\
 	alloc_hooks(kvmalloc_node_align_noprof(__VA_ARGS__))
 #define kvmalloc_node(_s, _f, _n)		kvmalloc_node_align(_s, 1, _f, _n)
@@ -1225,7 +1241,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 #define kvzalloc_node(_size, _flags, _node)	kvmalloc_node(_size, (_flags)|__GFP_ZERO, _node)

 #define kmem_buckets_valloc(_b, _size, _flags)	\
-	alloc_hooks(__kvmalloc_node_noprof(PASS_BUCKET_PARAMS(_size, _b), 1, _flags, NUMA_NO_NODE, __kmalloc_token(_size)))
+	alloc_hooks(__kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, _b, __kmalloc_token(_size)), 1, _flags, NUMA_NO_NODE))

 static inline __alloc_size(1, 2) void *
 _kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmalloc_token_t token)
@@ -1235,7 +1251,7 @@ _kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmallo
 	if (unlikely(check_mul_overflow(n, size, &bytes)))
 		return NULL;

-	return __kvmalloc_node_noprof(PASS_BUCKET_PARAMS(bytes, NULL), 1, flags, node, token);
+	return __kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(bytes, NULL, token), 1, flags, node);
 }
 #define kvmalloc_array_node_noprof(...)		_kvmalloc_array_node_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kvmalloc_array_noprof(...)		kvmalloc_array_node_noprof(__VA_ARGS__, NUMA_NO_NODE)
diff --git a/mm/slub.c b/mm/slub.c
index 5630dde94df0..84f129d79c99 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5293,15 +5293,17 @@ void *__do_kmalloc_node(size_t size, kmem_buckets *b, gfp_t flags, int node,
 	trace_kmalloc(caller, ret, size, s->size, flags, node);
 	return ret;
 }
-void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
+void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, _RET_IP_, token);
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
+				 _RET_IP_, PASS_TOKEN_PARAM(token));
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);

-void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
+void *__kmalloc_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags)
 {
-	return __do_kmalloc_node(size, NULL, flags, NUMA_NO_NODE, _RET_IP_, token);
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags,
+				 NUMA_NO_NODE, _RET_IP_, PASS_TOKEN_PARAM(token));
 }
 EXPORT_SYMBOL(__kmalloc_noprof);

@@ -5394,10 +5396,11 @@ void *_kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node, kmalloc_tok
 }
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);

-void *__kmalloc_node_track_caller_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags,
-					 int node, unsigned long caller, kmalloc_token_t token)
+void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
+					 int node, unsigned long caller)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node, caller, token);
+	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags, node,
+				 caller, PASS_TOKEN_PARAM(token));

 }
 EXPORT_SYMBOL(__kmalloc_node_track_caller_noprof);
@@ -6812,8 +6815,8 @@ static gfp_t kmalloc_gfp_adjust(gfp_t flags, size_t size)
  *
  * Return: pointer to the allocated memory of %NULL in case of failure
  */
-void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
-			     gfp_t flags, int node, kmalloc_token_t token)
+void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token),
+			     unsigned long align, gfp_t flags, int node)
 {
 	bool allow_block;
 	void *ret;
@@ -6824,7 +6827,7 @@ void *__kvmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), unsigned long align,
 	 */
 	ret = __do_kmalloc_node(size, PASS_BUCKET_PARAM(b),
 				kmalloc_gfp_adjust(flags, size),
-				node, _RET_IP_, token);
+				node, _RET_IP_, PASS_TOKEN_PARAM(token));
 	if (ret || size <= PAGE_SIZE)
 		return ret;

--
2.43.0

