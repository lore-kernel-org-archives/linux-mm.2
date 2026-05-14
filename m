Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A727CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:01:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799376B0088; Thu, 14 May 2026 05:01:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7715C6B008A; Thu, 14 May 2026 05:01:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6874B6B008C; Thu, 14 May 2026 05:01:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 590966B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:01:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F3B06120503
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:01:38 +0000 (UTC)
X-FDA: 84765432276.23.C963D73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 16B77A000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:01:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2BkCcFN;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778749297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LnrHHHGVvbNMJ97uL6t/hsKoQJ00bMmYxh3AG8Ng1W0=;
	b=D5iyDAPPSYOZNU/ZTkQPN2JCmFK/5o399hwMS/6jT1x+Ov9XZU7HTqwqtHX+IU6MWsFfk0
	UQA+iPOCKVK+nwKzHbdS5m4wG3anpHx1xhQ1ruizSb2u8wsklh43xyHcr/danawoTWkDMn
	yyuVZLnvinnE3DO+n/j9GQY0W3uYLfo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2BkCcFN;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778749297; a=rsa-sha256;
	cv=none;
	b=rZelQsi918w7nbT9fWAf2AzhYrCpE4jQuNL0c961amFtN4/EHBFHM8Z5RqIbrfup2LxrL9
	rG6DxIu/HW/bxWPK21lsFZeKYPLgrrl6E+fgXng/XoMinCXp3OQrWlah/P8HPqjv/hB/7Q
	j/bt9QRK701ncyRAu9RGNIcRqV92rbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BB41341A38;
	Thu, 14 May 2026 09:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B715C2BCC6;
	Thu, 14 May 2026 09:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778749295;
	bh=9qrd7DZRswnShjHayhkqvrhofgKn4ZIB2zVBnchimsI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G2BkCcFNIRRps5PTJarrPld2ITBu3MEnYEXg11mhnE12D+VJRwwayBQfS5aUku6Jb
	 GXY+k0+bMYEQte2Ba2sZBCfpZ2pE29oY3Sw4HJsnFUxwH7lke/wvijUh3uCpXurIuK
	 DlnckljG5ZQxBM+omlZP1Vjg7PIs641+rCM4lh8uuv0PKiiJ3ktkbxJZPoKcTdoKFy
	 2XJfB1OFdJl9GaXOCKD6hBOWKZlrz490Wtmw9lnKJmbQ2Nn+4aDO2Uh8XBNd/n6D40
	 l+2nIpCyOVcnw6ERQlbyTVQxJWZ7gtGqzcNekaxoeepcMWR2F6R0Wc++MSOvjaq3xU
	 MiY/qECmkhCFA==
Message-ID: <560a84ed-7daf-4a78-a314-b867c73bce22@kernel.org>
Date: Thu, 14 May 2026 11:01:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] slab: support for compiler-assisted type-based
 slab cache partitioning
Content-Language: en-US
To: Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>,
 David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>,
 Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>,
 Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org,
 Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev,
 GONG Ruiqi <gongruiqi1@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
References: <20260511200136.3201646-1-elver@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260511200136.3201646-1-elver@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 16B77A000D
X-Rspam-User: 
X-Stat-Signature: 768px78ht9q75obkgpf3o6ftpgrepfnx
X-HE-Tag: 1778749296-647409
X-HE-Meta: U2FsdGVkX184viT5dlirg7ONxjAnvliwbStyiqxI1exbaTNsOzFiFsGZQdM9U1K9yeVTwkjhn2sT2EwhmVC7muV4Z1HofB1Bd6TCLp8bK+Bjmd/+P8ws2ze9jA7ARDjnVpo63M1Tcsx+EwtGoO6sd6R/ZzhOPCawqgbuEFeKYHbnjmr9SyKUdGS3fPgwSe4IgBbL0y9O/4vz7Dk3MCyr8tStCKEB7CjYCzfR6uUrLls8PO8eAPq6NTQ82PObIGAE24budyARkbz4b0ddWr9hIevmMuV0AWBwZuJJvevwF6MPHNv9QyqFc2eAjvq39/RnA2oA1FmTZ5VDPwMkFZBfi+zsdJEzE69Q5+S3ZSMtQ17RLUzpSALKWRUXUqydY7b3TP/SwVbcpyPF7rwpNJqb4Ou4vZX0CXdVtHijDo/fhwlzA7Qmud4UZtoAe/t0QoBOYdhXyIIiaOsCdZutgsB6kkgb7m2kkU4ucLl1SjuGgazmUZXeBcRqOKmtTuZwJdZQTCnWLW9w7h216HY7npEdfTk5SVihtm0WD0V4YRBZWSbypXo1n55D6jzyOlrB1Y/DwFXUCFAQNAl4OJuvp48xqSn04VM9PW+t9nO5omkbJqmKHT+XiXU55NU6CugZpYNxtxnaTZYqcTAvHinU/LROSUaBo5fagvCDj/L23vqClES1zSmDVWRnGJ00XRmOF5Zai/V5YpmqK40z7ZnRp3wHPVswdN+M7dGdtHM13EhnLZOycIUZCIJRm5XiFg46k6+s/XrxlchmLCrIovdYEVehwNv6u+0fWQ/qzCtI8qD8eiKlsBxUffIpYMuNgeaFoja1rpdDLc796bwl/Eu24+/kIo2JzrV3IpJ2bB7VCzJtucoTzSuhlIXSlL3k5A+N4yGDBmPsDMFhRj8RjjyK2xPJLoBl4j6JpdQI8iKejP25Oq/E7OLIeDALEDR9JwyaVFDLuu4D+CoV8FZb+gJjM+z
 mlZapft3
 gTMjzXdUyEOxO8OEOhURw4X1UWyE8tVrCPdOn9GNl0Rlkm8QQoUeVUDQdKlE4DUTXSnngsLh8hJ36swxkP24Pz8J2KsTcjXpmUltGOYzmcdZ7cW+5noVwY0qh2Q5niYRkDtUGoY3Etp5rFjhIzOTiOjTsVlT6BINJskFqXeZCYTjUJV7g6MbD2y8PFb/LqzIhouJtgj0v0VfZ0iZd4O3zBlu1GCX51iEgNZvKH4SR5/wRtUEbwcwaZ78lTiz/zjbW9xZeTg/BwVaIjg/ryhBRMXMP79Mt9NtRSOSSFD3mq+FpBAn/rtfG7MQ5/pF10sOMaVjEpeWeQfs7kxqKm70y1ERYQkA4no0Wyuo224hVr1gp61tDexutLPJ/jRGRwyxUSIvlmLVXkgz06gFoOUuP11lTl/A0t/EwZAlGuecifxSVsknnj72gRTfhgDhPNG3aIG4BeMoSu4x80J0w+s+/sw1SmvUY7T0xKW/3eaWXWihDEWvp/KzFfKB76Kp0RDUnWqFxEApv5D+Jb5+7Is9FuDyqdNEBozVVdxAafL/3B7FmUnLJeE7ro85bQWKpfZsrNL52TQeqkMgSebSU2h025GlTXKJ5EKhATjlj1k35vYiQQX8xHPxZjpXRjXymcTrdxQF8NF3u2VaWNp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 22:00, Marco Elver wrote:
> Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
> flexible KMALLOC_PARTITION_CACHES, with the former being a partitioning
> mode of the latter.
> 
> Introduce a new mode, KMALLOC_PARTITION_TYPED, which leverages a feature
> available in Clang 22 and later, called "allocation tokens" via
> __builtin_infer_alloc_token() [1]. Unlike KMALLOC_PARTITION_RANDOM
> (formerly RANDOM_KMALLOC_CACHES), this mode deterministically assigns a
> slab cache to an allocation of type T, regardless of allocation site.
> 
> The builtin __builtin_infer_alloc_token(<malloc-args>, ...) instructs
> the compiler to infer an allocation type from arguments commonly passed
> to memory-allocating functions and returns a type-derived token ID. The
> implementation passes kmalloc-args to the builtin: the compiler performs
> best-effort type inference, and then recognizes common patterns such as
> `kmalloc(sizeof(T), ...)`, `kmalloc(sizeof(T) * n, ...)`, but also
> `(T *)kmalloc(...)`. Where the compiler fails to infer a type the
> fallback token (default: 0) is chosen.
> 
> Note: kmalloc_obj(..) APIs fix the pattern how size and result type are
> expressed, and therefore ensures there's not much drift in which
> patterns the compiler needs to recognize. Specifically, kmalloc_obj()
> and friends expand to `(TYPE *)KMALLOC(__obj_size, GFP)`, which the
> compiler recognizes via the cast to TYPE*.
> 
> Clang's default token ID calculation is described as [1]:
> 
>    typehashpointersplit: This mode assigns a token ID based on the hash
>    of the allocated type's name, where the top half ID-space is reserved
>    for types that contain pointers and the bottom half for types that do
>    not contain pointers.
> 
> Separating pointer-containing objects from pointerless objects and data
> allocations can help mitigate certain classes of memory corruption
> exploits [2]: attackers who gains a buffer overflow on a primitive
> buffer cannot use it to directly corrupt pointers or other critical
> metadata in an object residing in a different, isolated heap region.
> 
> It is important to note that heap isolation strategies offer a
> best-effort approach, and do not provide a 100% security guarantee,
> albeit achievable at relatively low performance cost. Note that this
> also does not prevent cross-cache attacks: while waiting for future
> features like SLAB_VIRTUAL [3] to provide physical page isolation, this
> feature should be deployed alongside SHUFFLE_PAGE_ALLOCATOR and
> init_on_free=1 to mitigate cross-cache attacks and page-reuse attacks as
> much as possible today.
> 
> With all that, my kernel (x86 defconfig) shows me a histogram of slab
> cache object distribution per /proc/slabinfo (after boot):
> 
>   <slab cache>      <objs> <hist>
>   kmalloc-part-15    1465  ++++++++++++++
>   kmalloc-part-14    2988  +++++++++++++++++++++++++++++
>   kmalloc-part-13    1656  ++++++++++++++++
>   kmalloc-part-12    1045  ++++++++++
>   kmalloc-part-11    1697  ++++++++++++++++
>   kmalloc-part-10    1489  ++++++++++++++
>   kmalloc-part-09     965  +++++++++
>   kmalloc-part-08     710  +++++++
>   kmalloc-part-07     100  +
>   kmalloc-part-06     217  ++
>   kmalloc-part-05     105  +
>   kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
>   kmalloc-part-03     183  +
>   kmalloc-part-02     283  ++
>   kmalloc-part-01     316  +++
>   kmalloc            1422  ++++++++++++++
> 
> The above /proc/slabinfo snapshot shows me there are 6673 allocated
> objects (slabs 00 - 07) that the compiler claims contain no pointers or
> it was unable to infer the type of, and 12015 objects that contain
> pointers (slabs 08 - 15). On a whole, this looks relatively sane.
> 
> Additionally, when I compile my kernel with -Rpass=alloc-token, which
> provides diagnostics where (after dead-code elimination) type inference
> failed, I see 186 allocation sites where the compiler failed to identify
> a type (down from 966 when I sent the RFC [4]). Some initial review
> confirms these are mostly variable sized buffers, but also include
> structs with trailing flexible length arrays.
> 
> Link: https://clang.llvm.org/docs/AllocToken.html [1]
> Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18/ [2]
> Link: https://lwn.net/Articles/944647/ [3]
> Link: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/ [4]
> Link: https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434
> Acked-by: GONG Ruiqi <gongruiqi1@huawei.com>
> Co-developed-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Marco Elver <elver@google.com>

Applied [1] to slab/for-next, thanks. That means including the kernel-doc
workarounds in patch 3. I know Jon said someone might hate it, but maybe it
will motivate them for creating a proper fix :) It seems better than leaving
doc generation broken or not applying this series at all.

https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.2/alloc_token

I did the following fixup to remove passing an unnecessary NULL argument for
__kmalloc_nolock() with buckets enabled. Made bloat-o-meter happier a bit.

diff --git a/include/linux/slab.h b/include/linux/slab.h
index c232f8a10af6..795455256329 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -894,7 +894,7 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
  * with the exception of kunit tests
  */
 
-void *__kmalloc_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags)
+void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 				__assume_kmalloc_alignment __alloc_size(1);
 
 void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, int node)
@@ -981,7 +981,7 @@ static __always_inline __alloc_size(1) void *_kmalloc_noprof(size_t size, gfp_t
 				kmalloc_caches[kmalloc_type(flags, token)][index],
 				flags, size);
 	}
-	return __kmalloc_noprof(PASS_KMALLOC_PARAMS(size, NULL, token), flags);
+	return __kmalloc_noprof(PASS_TOKEN_PARAMS(size, token), flags);
 }
 #define kmalloc_noprof(...)			_kmalloc_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
 #define kmalloc(...)				alloc_hooks(kmalloc_noprof(__VA_ARGS__))
diff --git a/mm/slub.c b/mm/slub.c
index a6e9015601d6..74652bbdd591 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5303,10 +5303,10 @@ void *__kmalloc_node_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags, in
 }
 EXPORT_SYMBOL(__kmalloc_node_noprof);
 
-void *__kmalloc_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags)
+void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 {
-	return __do_kmalloc_node(size, PASS_BUCKET_PARAM(b), flags,
-				 NUMA_NO_NODE, _RET_IP_, PASS_TOKEN_PARAM(token));
+	return __do_kmalloc_node(size, NULL, flags,  NUMA_NO_NODE, _RET_IP_,
+				 PASS_TOKEN_PARAM(token));
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 


