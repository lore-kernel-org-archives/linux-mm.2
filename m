Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5714BFF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 15:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792F86B0005; Mon,  4 May 2026 11:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B436B008A; Mon,  4 May 2026 11:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 659586B008C; Mon,  4 May 2026 11:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A8B36B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 11:01:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9753B401F1
	for <linux-mm@kvack.org>; Mon,  4 May 2026 15:01:08 +0000 (UTC)
X-FDA: 84730050216.13.7AE192E
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf14.hostedemail.com (Postfix) with ESMTP id F2F2B10002A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 15:00:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZKCPgSDc;
	spf=temperror (imf14.hostedemail.com: error in processing during lookup of elver@google.com: DNS error) smtp.mailfrom=elver@google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891c0620bcso29860815e9.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 08:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777906856; x=1778511656; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vihrjy6JWRaFYaKwFFp+zwam3K505oAzvsgkAqow4uE=;
        b=ZKCPgSDcXouVk2QNzRfO6O8wBX62yQhAaOV+PJqrN3gDQGYGXv0thH0BpjO0uMwB9B
         zQLDgy6iuzhDtOvnUUVgFCDS9IcsAYq5VNPf52dPzH4CNOUrmeDkasO7RKh/CJJPuqVA
         G6IsVto6qswYrhPc/7MqCzaAb2ANgm1vULdSYeWnmRMY9qfdrZyciEdlxJsOH0KeUW2A
         ju0wIJEzNAxZO3sIuAdho2AYrppyQo2fVKFgX/Ka+uxrvysUq5RXmEw0QjKGtf/z3+j7
         4W7F4htceyCaAcTrpubfyjtoA5LbO3k8E2LtUlxliWFjAlAC0J3SAAH2y7tPycKPGaIq
         fGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777906856; x=1778511656;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vihrjy6JWRaFYaKwFFp+zwam3K505oAzvsgkAqow4uE=;
        b=BMv2Rj2qVsvWO1AtTwyNi8rrzGTaaEZip4OM1rdRc2wyRnxbS8kUEI8/3ALamlMmoZ
         JniRFPnv5enllm/eE6WSrM6Z3su3Qyk8BHiUDUSXaNbEgP8EsuuuG/mJJuW7RmFqAXJQ
         tCK+5ot4++I/sdNDRSYXF/rs2XQtBHYbqgf69XsmOuz0+ES2JQEPgKFS7Ym34ARLC0jc
         +8HA31mK1YXnU7PeDT0rAE3+C43uIFi/d2XezSgz6iH4ROXibNibZ6vpDIxs44NhTNeG
         nkwLslX6+dNyrSQmcQHDTY+oFCyOWXtqiXOicfHytr/eH2cFfcgIUxzHrWVleUKlX0cA
         /fKg==
X-Forwarded-Encrypted: i=1; AFNElJ82HAbZ03o4tVOmmyCmCIA4HPGOAFqgkGftJ3VVzKNU5QRiLrnrUAdNoidLFQRSqXE30tli1d7/Tw==@kvack.org
X-Gm-Message-State: AOJu0YxpqudWXbvrlJC2CyDFXX/Tetn9tPJrhKI/m/hLdlDyVgNs5/fx
	p/wTQvUy3bj+h8ZInQe0nXB68r1DUmnd01jpiePdrHx6kC5+OOYz+ZPHAIEIlqnpMQ==
X-Gm-Gg: AeBDieswYyelOOMKqJdsUvvYaED3aAULQNn7WPBfkCgV6CnP1dLhB9QbB8hT5UwM2Lv
	0WkLg0Yps2JIEArKX714qZypxpZ3GRwWAf98jmHxYUmF1C+g3eNy79UuMFd0WDtnhGk7sezeeom
	HdxtOm+IToR7CNHlgDfOJDAq5QOOxscyHTzVX8MDlwNft3NK9rLoY2k7kTsM5IlZR9Zet8psUxU
	B5KQHBqoxCwt2xOc1REVGhZMUAx+8RtN73+tYWscvPunE8bL5SIorAGXCHunN7lmVwK4HrvnFy3
	7do/ivOjmyJ4k6bRJ1PiXzJJIHeZnJGL9n4P56JB1V380/pgKStqL5ONNTJsCRC8i1pII6nQ5uM
	WMz51N79ipT9DQseXgT6FawIFaGwwRt9Wvp/bZ/wG11nPKUqxsBm1SjTUFj2X2FfdJ2SnLpZ9Dx
	6GzjcieCkrrnIFMN+52RCOsFqaYGWEwEA/7AGX6SAfRhX1Q+32NWJMvQr+XwGR3mPEduFjPt8Ad
	kSG8dXJCw==
X-Received: by 2002:a05:600c:46d1:b0:489:1d74:56d with SMTP id 5b1f17b1804b1-48a988ca441mr162572375e9.29.1777906853078;
        Mon, 04 May 2026 08:00:53 -0700 (PDT)
Received: from elver.google.com ([2a00:79e0:2834:9:fba5:1281:871d:3fd6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fe3cae3sm116897425e9.0.2026.05.04.08.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 08:00:52 -0700 (PDT)
Date: Mon, 4 May 2026 17:00:45 +0200
From: Marco Elver <elver@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	David Rientjes <rientjes@google.com>,
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
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, kasan-dev@googlegroups.com,
	llvm@lists.linux.dev,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] slab: fix kernel-docs for mm-api
Message-ID: <afi0nQ84k1oz5RyH@elver.google.com>
References: <20260424132427.2703076-1-elver@google.com>
 <20260424132427.2703076-2-elver@google.com>
 <9c321184-9080-4d5c-bd1a-a16cd0bbaed3@kernel.org>
 <CANpmjNN_=g31Eoa+w1NrFALfp1dDBi5oHEZdr_bA_48-tS2M=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNN_=g31Eoa+w1NrFALfp1dDBi5oHEZdr_bA_48-tS2M=Q@mail.gmail.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F2F2B10002A
X-Stat-Signature: kij99zy6jeby44w37c85pd665kjrqjcc
X-HE-Tag: 1777906857-12235
X-HE-Meta: U2FsdGVkX1/53qMs9qh1gS5lPPC1ONa7T40UqO4oRh1L1c2FO16yX3OzTV23iGQEJFI9QVvKk/9Q+qOZA/Lfat6TkotwqRY+bfqpo9ivhjSvH7vKhHFQJjTGXUyO2rVsnQXWq1UQhNYrqfos5rviXt+n/iRZuDvv2y8dorGI+zWz1/405ldwSVKWevnYa119isyytLlvha5YysKKJiIEYHAuBFDPF3eB8eio72uj8kyS5MjF84hWRkd9ZiKl4Fb7HqotTWnUCAxldmLZozRkz0Z0nL5oDIHGBj0+nfcIaGdUJNso5RqzEl9S32DzpxwLeWoJ2/mNxnPq+yX53jBZpLjmNYTZR2SBygCPGPcDOD3JHf2dfTb2QqQPkrUirRYFfOIFBy/CRdnSQkMQ9hAE7Bht4FzKN9xabNPYq3BKkFU5z8I6f/vIl6v1guk6SmhCJ5e3P5xoA9TMAv5LImPCI/YAdfGRLMwH270YgT0kEfqUlDcgJvsZDGe+1LVfjGP+ZyIzcpuhv/IkdR1a7gSHJLo/CpBreF/NAesgdX6O2uv9PIDdxf2LmQKvHMOt/QN7B1r0y6A1cp5VoHm7Id/oV6XXMWKcEz1H0RM00rFN7IiGe1YZo/1J66bSjz2l8b1nkIa6TLr6PMUPD0OZJDlH6zPzSr4WC1LWuh2oUzz1lu1+Kbtrf2rLtrt1/Y1Nwt2YKJ5vcQxt3hYSKYTsGmvCKe+rjdq7C2TNkbdJApXljAkfMvAZ3SGfX1hH8J7OBN8tFRmIKdtYIOQJDmLnss9EdTvVDJVe1U4Y/FMbkAKFYU2K3JiRf0e+LeXm9nVyTiUrFkUsL3BbLeCeF09Jq4yV7wBx6b/V6QyNXe6KSiE/8VWn4r/QtHEHdh32e9spG1xQiNLAKQkPGf+xNVjIOjGfHS1tfT/2Ftusw+bdv70HZRbYyrorAMdtFDLFzl6P+oSU3XC7+AdLjExY1l6ufC3
 e4hPwO1O
 5bg16z4ob0jB7XzO/5LcR8xHPTu7yzgc0Ww2OTIVETXTcg9i6blpGj8+aDZhLlyA6x+zDaoBCp95Fq1IPMZcNmR3bPahPBeuXdwTnsEnz2CZuTASyS1uR7rYV8vq0y5TcCT4SFdyosJ81NyUquNbxp7lF+bSTzkQJB0NGsMiaBuLy4jf/JuQ/wUNoyrUOohEdNbTVqzvj6TCYuTO5wCYy5Y4X/Ulj1o/SNHy3fpE0kee2B3LR3xFmXdbPG+TI2aK+mm/NQylOhSvIcIhRfk/moavFgr87NKNu/zYKGQMmqnUevNDwtresj8GldF0xOHcZeLWCqqamPZNW3Tm9tfMbCuVmcVqVq/l/CIlW5fH//ljPe8s2MzqrcGxyltxTTxM7m1Gm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 03:59PM +0200, Marco Elver wrote:
> On Thu, 30 Apr 2026 at 15:40, Vlastimil Babka (SUSE) <vbabka@kernel.org> wrote:
> >
> > On 4/24/26 15:24, Marco Elver wrote:
> > > The mm-api kernel-doc comments have been broken for a while, as many
> > > documented symbols shifted from being direct function definitions to
> > > macros wrapping _noprof implementations during the introduction of
> > > allocation tagging (starting with commit 7bd230a26648 "mm/slab: enable
> > > slab allocation tagging for kmalloc and friends").
> > >
> > > When the kernel-doc block remains above the internal implementation
> > > function but uses the public API name, the documentation generator fails
> > > to associate the documented symbol and generates warnings and fails to
> > > emit the documentation.
> > >
> > > Fix this by:
> > >
> > > 1. Moving the kernel-doc comment blocks from slub.c to slab.h, placing
> > >    them directly above the user-facing macros.
> > >
> > > 2. Converting the variadic macros for the documented APIs to use
> > >    explicit arguments.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Marco Elver <elver@google.com>
> >
> > +Cc Jon
> >
> > I thought it was supposed to work because the kernel-doc scripts were at the
> > time taught by commit 51a7bf0238c2 ("scripts/kernel-doc: drop "_noprof" on
> > function prototypes") to handle _noprof. In the current form git grep finds:
> >
> > tools/lib/python/kdoc/kdoc_parser.py:        suffixes = [ '_noprof' ]
> > tools/lib/python/kdoc/xforms_lists.py:        (KernRe("_noprof"), ""),
> >
> > Doesn't it work for you then?
> 
> Ah, I see. So it doesn't work anymore because we add the '_' prefix, too.
> 
> I guess the question is if we want to proliferate more kdoc parser
> special cases, or just move the docs to the macros. The downside of
> macros is that they lose the types in the displayed function
> signature.
> 
> Preferences?

How about the below, i.e. adding type decls that only the kernel-doc
parser sees? One complication is also DECL_KMALLOC_PARAMS, and adding
kernel-doc parser hacks for that looks pretty awful, so this is a lot
cleaner.

------ >8 ------

From: Marco Elver <elver@google.com>
Date: Tue, 21 Apr 2026 13:48:21 +0200
Subject: [PATCH] slab: fix kernel-docs for mm-api

The mm-api kernel-docs have been disconnected from their symbols. While
the scripts were previously taught to handle the _noprof suffix added by
allocation tagging (in 51a7bf0238c2 "scripts/kernel-doc: drop "_noprof"
on function prototypes"), this does not handle cases where the internal
implementation function has an additional leading underscore. The added
optional parameters (via DECL_KMALLOC_PARAMS) further complicate parsing
the internal signatures.

When the kernel-doc block remains above the internal implementation
function but uses the public API name, the documentation generator fails
to associate the documented symbol.

Simply moving the docs to the macros in slab.h fixes the association but
causes loss of types in the generated documentation (rendering as e.g.
untyped 'kmalloc(size, flags)' macro).

Fix this by:

1. Moving the kernel-doc comment blocks from slub.c to slab.h, placing
   them directly above the user-facing macros.

2. Providing explicit, typed C prototypes for the documented APIs inside
   '#if 0 /* kernel-doc */' blocks.

3. Converting the variadic macros for the documented APIs to use
   explicit arguments to match the documentation.

No functional change intended.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Provide typed C prototypes in '#if 0' blocks to properly render API.
---
 include/linux/slab.h | 216 +++++++++++++++++++++++++++++++++----------
 mm/slub.c            |  98 --------------------
 2 files changed, 168 insertions(+), 146 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index c232f8a10af6..5e1249e36b0d 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -530,7 +530,49 @@ void * __must_check krealloc_node_align_noprof(const void *objp,
 					       unsigned long align,
 					       gfp_t flags, int nid) __realloc_size(2);
 #define krealloc_noprof(_o, _s, _f)	krealloc_node_align_noprof(_o, PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), 1, _f, NUMA_NO_NODE)
-#define krealloc_node_align(_o, _s, _a, _f, _n)	alloc_hooks(krealloc_node_align_noprof(_o, PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), _a, _f, _n))
+#if 0 /* kernel-doc */
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
+void *krealloc_node_align(const void *p, size_t new_size, unsigned long align, gfp_t flags, int nid);
+#endif
+#define krealloc_node_align(p, new_size, align, flags, nid) \
+	alloc_hooks(krealloc_node_align_noprof(p, PASS_TOKEN_PARAMS(new_size, __kmalloc_token(new_size)), align, flags, nid))
 #define krealloc_node(_o, _s, _f, _n)	krealloc_node_align(_o, _s, 1, _f, _n)
 #define krealloc(...)			krealloc_node(__VA_ARGS__, NUMA_NO_NODE)
 
@@ -913,6 +955,23 @@ void *__kmalloc_large_noprof(size_t size, gfp_t flags)
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
+#if 0 /* kernel-doc */
 /**
  * kmalloc - allocate kernel memory
  * @size: how many bytes of memory are required.
@@ -968,27 +1027,27 @@ void *__kmalloc_large_node_noprof(size_t size, gfp_t flags, int node)
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
+void *kmalloc(size_t size, gfp_t flags);
+#endif
+#define kmalloc(size, flags)			alloc_hooks(kmalloc_noprof(size, flags))
 
 void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node);
 #define kmalloc_nolock_noprof(_s, _f, _n)	_kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), _f, _n)
-#define kmalloc_nolock(...)			alloc_hooks(kmalloc_nolock_noprof(__VA_ARGS__))
+#if 0 /* kernel-doc */
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
+void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
+#endif
+#define kmalloc_nolock(size, gfp_flags, node)	alloc_hooks(kmalloc_nolock_noprof(size, gfp_flags, node))
 
 /**
  * __alloc_objs - Allocate objects of a given type using
@@ -1115,23 +1174,40 @@ static __always_inline __alloc_size(1) void *_kmalloc_node_noprof(size_t size, g
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
+#if 0 /* kernel-doc */
 /**
  * kmalloc_array - allocate memory for an array.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t size, gfp_t flags, kmalloc_token_t token)
+void *kmalloc_array(size_t n, size_t size, gfp_t flags);
+#endif
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
+#if 0 /* kernel-doc */
 /**
  * krealloc_array - reallocate memory for an array.
  * @p: pointer to the memory chunk to reallocate
@@ -1149,20 +1225,9 @@ static inline __alloc_size(1, 2) void *_kmalloc_array_noprof(size_t n, size_t si
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
+void *krealloc_array(void *p, size_t new_n, size_t new_size, gfp_t flags);
+#endif
+#define krealloc_array(p, new_n, new_size, flags) alloc_hooks(krealloc_array_noprof(p, new_n, new_size, flags))
 
 /**
  * kcalloc - allocate memory for an array. The memory is set to zero.
@@ -1214,17 +1279,20 @@ static inline __alloc_size(1, 2) void *_kmalloc_array_node_noprof(size_t n, size
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
+#if 0 /* kernel-doc */
+/**
+ * kzalloc - allocate memory. The memory is set to zero.
+ * @size: how many bytes of memory are required.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+void *kzalloc(size_t size, gfp_t flags);
+#endif
+#define kzalloc(size, flags)			alloc_hooks(kzalloc_noprof(size, flags))
 #define kzalloc_node(_size, _flags, _node)	kmalloc_node(_size, (_flags)|__GFP_ZERO, _node)
 
 void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long align,
@@ -1233,7 +1301,29 @@ void *__kvmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), unsigned long
 	__kvmalloc_node_noprof(PASS_KMALLOC_PARAMS(_size, NULL, __kmalloc_token(_size)), _align, _flags, _node)
 #define kvmalloc_node_align(...)		\
 	alloc_hooks(kvmalloc_node_align_noprof(__VA_ARGS__))
-#define kvmalloc_node(_s, _f, _n)		kvmalloc_node_align(_s, 1, _f, _n)
+#if 0 /* kernel-doc */
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
+void *kvmalloc_node(size_t size, gfp_t flags, int node);
+#endif
+#define kvmalloc_node(size, flags, node)	kvmalloc_node_align(size, 1, flags, node)
 #define kvmalloc_node_noprof(size, flags, node)	\
 	kvmalloc_node_align_noprof(size, 1, flags, node)
 #define kvmalloc(...)				kvmalloc_node(__VA_ARGS__, NUMA_NO_NODE)
@@ -1266,8 +1356,38 @@ _kvmalloc_array_node_noprof(size_t n, size_t size, gfp_t flags, int node, kmallo
 
 void *kvrealloc_node_align_noprof(const void *p, DECL_TOKEN_PARAMS(size, token), unsigned long align,
 				  gfp_t flags, int nid) __realloc_size(2);
-#define kvrealloc_node_align(_p, _s, _a, _f, _n)	\
-	alloc_hooks(kvrealloc_node_align_noprof(_p, PASS_TOKEN_PARAMS(_s, __kmalloc_token(_s)), _a, _f, _n))
+#if 0 /* kernel-doc */
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
+void *kvrealloc_node_align(const void *p, size_t size, unsigned long align, gfp_t flags, int nid);
+#endif
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


