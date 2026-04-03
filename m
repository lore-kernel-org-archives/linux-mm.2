Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 233D2D730A2
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 06:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 070256B0005; Fri,  3 Apr 2026 02:27:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048856B0089; Fri,  3 Apr 2026 02:27:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78B76B008A; Fri,  3 Apr 2026 02:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D796B6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 02:27:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 285CBC1E84
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:27:53 +0000 (UTC)
X-FDA: 84616264026.07.5B96C98
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 84EB7180009
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:27:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBkk7KaS;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775197671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z5yCsms2lDqppeg+Z5upeOKt5mavT/Ni40mmVnEI9g4=;
	b=LGajEO3amk/b3cQEtT9CfWfFSaXYxBVDB6/HYNmDd2ukA231kXl+ecCoWKOBqkuMj9uu3A
	n7kZ1+tjrbQPLZ5PCSq13ahpQYb4H01nijAXkvPXZRcBnUHIf92Z47BWGVmwXiBCErnRSl
	49zGPWuxi6JI25BXunhYEWFX2yAGVmo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775197671; a=rsa-sha256;
	cv=none;
	b=RGecI+VK4HBRsUh71DvbxaVRwUvbs+ok0s5kRBCwXsl0yadJr2lKw1sp4iDaGFA/3FEp3Y
	kqku2rcbudBjDcIglgzc9iO0V90Z1RiiTxkxD074GO5jB3PMXuLJRpy/msz/bTg9UbaFgc
	k75jB/8Iex3U6MJuqw0alLGT91cj6XE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BBkk7KaS;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CD6160121;
	Fri,  3 Apr 2026 06:27:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6701C4CEF7;
	Fri,  3 Apr 2026 06:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775197670;
	bh=zio9ToFhevhY9R8ryXtIpy2BTp2ha4BmkEW0x4mvpJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BBkk7KaSvOJSmmg7PgyD9L0luP63Yaw3F9EFZ4dFnGR3buZXF7qVzTsf7CarLoq5f
	 ewDa3Pr+6tcBWjL86S9H9xOmF/ThhO/qYCtzF/W2x4YMHqKSia5IKi6ioeP3lJ7J7+
	 ZxHH/5nAyk1aio6h/F+D3phhVTbWOci54V/jwXg0vwuMca6rkvSY/vSVmeAMB6esXa
	 2cvSLjfkD0bFtdd3WV5PK8wQ9ZBwgwk/fBCHgtawJ4ZCVzFkOoPg/O5d11rwb4CR+r
	 3CFWBCcfeiSagFr2CciBotdWwzSTYNCV+rletxIsGbokU+ukCNwSwTA+Vzh4kAvMRA
	 vrDK+n1LWuGrQ==
Date: Fri, 3 Apr 2026 15:27:48 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
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
Message-ID: <ac9d5O5XehnXRc5A@hyeyoo>
References: <20260331111240.153913-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331111240.153913-1-elver@google.com>
X-Rspamd-Queue-Id: 84EB7180009
X-Stat-Signature: pfpedw9wyqconuxftezx144ug35arbc3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775197671-736986
X-HE-Meta: U2FsdGVkX19nP3uzebfasiAQ1PZAYDAqKq//c67Jd6G4+SJwjNU9mbYkLz6MGwcU5AglWF/qeTu+hWvO+Ydog17avSPG9wY7OoWSq7xUmLeExvp+jaRgtwPtaZhEzMMs//9WAb7pxM9MvbuDWJJ/5PKtsG4teYwbdLWzGVQgy3BCkBSW+VjpLrXWKyI+C2CZUvC+ER/dKUzprw1XZtQHP7nToMFCCwUqVFj+uzcQYup81/hhFC1x+dX7nHQqAmKKzznQaSdmscMdHgx4lF4n5V063J8lQOGxnLjVEQaoThsE0a8LgKGMnuKlwVHJ/c2iqs1DqsdWRSMw7dDBRKLIv4ag6REW+iJsqHeHaYbNaZQIUzSr4pZCcLGkZfnoxhEHUUlNeukrGSyYA/7BbBmvWrf5YoGpBUp4dwVqBRQgr/4b7qfCOPA1Ls9fnYVq7+YN3koFceon7H/iKsWhjAMV0u5IuUzmzZXcJE5NVMmEie/CPqhFflzofrHtsZqlg+qL+uthI3M62DMCECybx+1DzNaWnEw6hIU936nc60XKzftk3Vxzjqey2tIu5UJYF183oXBSJXCH/Nyysbd+hR3Fq0mdFFPV0Jn0n2mZadbrFqOFfmX/M9PBuLXwDpLpV0QHsWO8ry4o/8JFReaUs9otJ1pgIL/qVZLN8KPjiTk87+F9gPxSIdNpuZ8Wgq6HyrLusrHg6Je4jix+5JTMs9vNSTK52mAEBWhTEmaadvMwkH5J3jULiDc3VkEmBuX7H9jTcYQwXkqh88y+ACXf2Jybbg3m0bxVVWPcsNdIPZweb57IwcjPplibduJr2ojaHo2qY1dJeV2RH+TmYeyye01Jh+dGTJafCznRrOrjuUQhObv8y2JjjVJYxG3lG6WyUAxNw9u2NFqKfyKQCOyBE2LgThcu/BxzZ9gC/wxkGaYe4KYCukF7X/I6vY1AjPInEd3j756CW8iFQUMauosuFeY
 rH0vcy+a
 injZZ321UJn0J3/XU9PlnO0rAJaVSgHvejNAL0bi35Lw0GiuO3/ZoYCXWjeQ8kBqkVqJ9+8uRc2vTZLOq7gNikJKPUnyc2+QeBN6+ZotATb58OngTASI+3dJ18o9Uw/0TP6lsvCG4QI3Q/3SDSItdfkOgkQz2RYcwcRgN3S9qPMQRjTfwdh2ytpMR/k6fvpcfoWvV2mtlJeYlKiTImQI0R8/AtE+/U2F2tChTsjV1oowa1TPSyGk9/JyqqE96oq1CQtfx0Fv064uD7h5O90SYfr6kOH/0ELV35u95mHCWqTHhVfxLveLb8aTbFL7lfHvT6a78pFsa44JxsMg2Zb8QvYnAZhe8LhNxE6JlS7S9bfBJGDuyH8/iS3iRmHlrtf8TEbtXFB7lTumq+Bk8ITBE9SvWSsxGfuXCsc5ncjdrYgckAIDiHWm4a68bvqk87jFZn7uvxu4C83gjHsBV9pCO5uVmCUAYJkIQgSlTQTHaEM699lycZDn0PjM2Vai0ahsqEytE8N7YoFbUpVCYqY7rGqNVvk32Oofd2VwCSQl44Zxpd+a+XHcbj4fCY6aONNuyruXxJ4h2Z8T6gvRGGu5J1rxGygUAD4LyU2+R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 01:12:27PM +0200, Marco Elver wrote:
> Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
> flexible PARTITION_KMALLOC_CACHES, with the former being a partitioning
> mode of the latter.
> 
> Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages a feature
> available in Clang 22 and later, called "allocation tokens" via
> __builtin_infer_alloc_token [1]. Unlike RANDOM_KMALLOC_CACHES, this mode
> deterministically assigns a slab cache to an allocation of type T,
> regardless of allocation site.
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
> also does not prevent cross-cache attacks, and SLAB_VIRTUAL [3] should
> be used as a complementary mitigation (once available).
> 
> With all that, my kernel (x86 defconfig) shows me a histogram of slab
> cache object distribution per /proc/slabinfo (after boot):
> 
>   <slab cache>      <objs> <hist>
>   kmalloc-part-15    1537  +++++++++++++++
>   kmalloc-part-14    2996  +++++++++++++++++++++++++++++
>   kmalloc-part-13    1555  +++++++++++++++
>   kmalloc-part-12    1045  ++++++++++
>   kmalloc-part-11    1717  +++++++++++++++++
>   kmalloc-part-10    1489  ++++++++++++++
>   kmalloc-part-09     851  ++++++++
>   kmalloc-part-08     710  +++++++
>   kmalloc-part-07     100  +
>   kmalloc-part-06     217  ++
>   kmalloc-part-05     105  +
>   kmalloc-part-04    4047  ++++++++++++++++++++++++++++++++++++++++
>   kmalloc-part-03     276  ++
>   kmalloc-part-02     283  ++
>   kmalloc-part-01     316  +++
>   kmalloc            1599  +++++++++++++++
> 
> The above /proc/slabinfo snapshot shows me there are 6943 allocated
> objects (slabs 00 - 07) that the compiler claims contain no pointers or
> it was unable to infer the type of, and 11900 objects that contain
> pointers (slabs 08 - 15). On a whole, this looks relatively sane.
> 
> Additionally, when I compile my kernel with -Rpass=alloc-token, which
> provides diagnostics where (after dead-code elimination) type inference
> failed, I see 179 allocation sites where the compiler failed to identify
> a type (down from 966 when I sent the RFC [4]). Some initial review
> confirms these are mostly variable sized buffers, but also include
> structs with trailing flexible length arrays.
> 
> Link: https://clang.llvm.org/docs/AllocToken.html [1]
> Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18/ [2]
> Link: https://lwn.net/Articles/944647/ [3]
> Link: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/ [4]
> Link: https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434
> Signed-off-by: Marco Elver <elver@google.com>
> ---
> Changelog:
> v1:
> * Rebase and switch to builtin name that was released in Clang 22.

> * Keep RANDOM_KMALLOC_CACHES the default.

Presumably because only the latest Clang supports it?

> RFC: https://lore.kernel.org/all/20250825154505.1558444-1-elver@google.com/
> ---
>  Makefile                        |  5 ++
>  include/linux/percpu.h          |  2 +-
>  include/linux/slab.h            | 94 ++++++++++++++++++++-------------
>  kernel/configs/hardening.config |  2 +-
>  mm/Kconfig                      | 45 ++++++++++++----
>  mm/kfence/kfence_test.c         |  4 +-
>  mm/slab.h                       |  4 +-
>  mm/slab_common.c                | 48 ++++++++---------
>  mm/slub.c                       | 31 +++++------
>  9 files changed, 144 insertions(+), 91 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 15a60b501b95..c0bf00ee6025 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -864,10 +877,10 @@ unsigned int kmem_cache_sheaf_size(struct slab_sheaf *sheaf);
>   * with the exception of kunit tests
>   */
>  
> -void *__kmalloc_noprof(size_t size, gfp_t flags)
> +void *__kmalloc_noprof(size_t size, gfp_t flags, kmalloc_token_t token)
>  				__assume_kmalloc_alignment __alloc_size(1);
>  
> -void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node)
> +void *__kmalloc_node_noprof(DECL_BUCKET_PARAMS(size, b), gfp_t flags, int node, kmalloc_token_t token)
>  				__assume_kmalloc_alignment __alloc_size(1);

So the @token parameter is unused when CONFIG_PARTITION_KMALLOC_CACHES is
disabled but still increases the kernel size by a few kilobytes...
but yeah I'm not sure if we can get avoid it without hurting readability.

Just saying. (does anybody care?)

>  void *__kmalloc_cache_noprof(struct kmem_cache *s, gfp_t flags, size_t size)

> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..fa4ffc1fcb80 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -247,22 +247,47 @@ config SLUB_STATS
>  	  out which slabs are relevant to a particular load.
>  	  Try running: slabinfo -DA
>  
> -config RANDOM_KMALLOC_CACHES
> -	default n
> +config PARTITION_KMALLOC_CACHES
>  	depends on !SLUB_TINY
> -	bool "Randomize slab caches for normal kmalloc"
> +	bool "Partitioned slab caches for normal kmalloc"
>  	help
> -	  A hardening feature that creates multiple copies of slab caches for
> -	  normal kmalloc allocation and makes kmalloc randomly pick one based
> -	  on code address, which makes the attackers more difficult to spray
> -	  vulnerable memory objects on the heap for the purpose of exploiting
> -	  memory vulnerabilities.
> +	  A hardening feature that creates multiple isolated copies of slab
> +	  caches for normal kmalloc allocations. This makes it more difficult
> +	  to exploit memory-safety vulnerabilities by attacking vulnerable
> +	  co-located memory objects. Several modes are provided.
>  
>  	  Currently the number of copies is set to 16, a reasonably large value
>  	  that effectively diverges the memory objects allocated for different
>  	  subsystems or modules into different caches, at the expense of a
> -	  limited degree of memory and CPU overhead that relates to hardware and
> -	  system workload.
> +	  limited degree of memory and CPU overhead that relates to hardware
> +	  and system workload.
> +
> +choice
> +	prompt "Partitioned slab cache mode"
> +	depends on PARTITION_KMALLOC_CACHES
> +	default RANDOM_KMALLOC_CACHES
> +	help
> +	  Selects the slab cache partitioning mode.
> +
> +config RANDOM_KMALLOC_CACHES
> +	bool "Randomize slab caches for normal kmalloc"
> +	help
> +	  Randomly pick a slab cache based on code address.
> +
> +config TYPED_KMALLOC_CACHES
> +	bool "Type based slab cache selection for normal kmalloc"
> +	depends on $(cc-option,-falloc-token-max=123)
> +	help
> +	  Rely on Clang's allocation tokens to choose a slab cache, where token
> +	  IDs are derived from the allocated type.
> +
> +	  The current effectiveness of Clang's type inference can be judged by
> +	  -Rpass=alloc-token, which provides diagnostics where (after dead-code
> +	  elimination) type inference failed.
> +
> +	  Requires Clang 22 or later.

Assuming not all people building the kernel are security experts...
(including myself) could you please add some insights/guidance on how to
decide between RANDOM_KMALLOC_CACHES and TYPED_KMALLOC_CACHES?

Something like what Florent wrote [1]:                                          
| One more perspective on this: in a data center environment, attackers
| typically get a first foothold by compromising a userspace network
| service. If they can do that once, they can do that a bunch of times,
| and gain code execution on different machines every time.
| 
| Before trying to exploit a kernel memory corruption to elevate
| privileges on a machine, they can test the SLAB properties of the
| running kernel to make sure it's as they wish (eg: with timing side
| channels like in the SLUBStick paper). So with RANDOM_KMALLOC_CACHES,
| attackers can just keep retrying their attacks until they land on a
| machine where the types T and S are collocated and only then proceed
| with their exploit.
| 
| With TYPED_KMALLOC_CACHES (and with SLAB_VIRTUAL hopefully someday),
| they are simply never able to cross the "objects without pointers" to
| "objects with pointers" boundary which really gets in the way of many
| exploitation techniques and feels at least to me like a much stronger
| security boundary.
| 
| This limit of RANDOM_KMALLOC_CACHES may not be as relevant in other
| deployments (eg: on a smartphone) but it makes me strongly prefer
| TYPED_KMALLOC_CACHES for server use cases at least.

[1] https://lore.kernel.org/all/CALGbS4U6fox7SwmdHfDuawmOWfQeQsxtA1X_VqRxTHpSs-sBYw@mail.gmail.com

Otherwise the patch is really straightforward and looks good to me.

Thanks!

-- 
Cheers,
Harry / Hyeonggon

