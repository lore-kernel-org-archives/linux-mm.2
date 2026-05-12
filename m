Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9D7CD37AC
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 04:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D927B6B008A; Tue, 12 May 2026 00:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D42A46B008C; Tue, 12 May 2026 00:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57DB6B0092; Tue, 12 May 2026 00:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3A2D6B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 00:57:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 289651C0109
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:57:07 +0000 (UTC)
X-FDA: 84757558494.22.084481A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 581FC18000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:57:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IdzDA37+;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778561825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xopj4SxAUrfN4NvLwRTjjr936ytazk74v6k4wO+DYig=;
	b=X6EGqrvrElfpGeMys5UGDs8oINXYzOY8EO/yCcHwzVrdBiHE0/tkGO4vFsEwwD0pgClScx
	SXFAlkxmn43kXhp7UfLf73vClJ7DBMbZ3D6ks2zc9TVSbERGv76LTSD0gJVXkvY4VJkJnv
	9alOkTsGoGU2qtWJdvLYxDF0nqENQyM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IdzDA37+;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778561825; a=rsa-sha256;
	cv=none;
	b=zRDN7Jgx80byO9TrS+ML1GqbdlqQ14TPaQHiyOgmvGDpynpWdH+9d0rS5cHO+tT9wYfI3e
	j0MB9TQyuqGKyRyKt8b8dkwHc9bUmrQ9kWbjRD4jWx3ySbw8J4rYYAuuEv16bhad1wQb6t
	/i5J7FXWfWa1Q3afO4v6fFrVseLUqTw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 468044192D;
	Tue, 12 May 2026 04:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0372C2BCB0;
	Tue, 12 May 2026 04:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778561824;
	bh=SuGzOrO8Ty44mf2D4njc9ML+1sXJQc1sV4S69Dg22ww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IdzDA37+6qHy5RsQcN2ylceO9txldaqjFLIXbOjt3qcpLZNB/CuSElDOLf3phdqFa
	 iEgyQxtJYvEFVh2PKNQEp3TjPI/ojxsvZLeGUEwUq+3Z7wCs9FTEvI64yTlqwZIckG
	 BdWcHutsJ3yczyQTuOl0GZLAxnO4qMu87n99WtTBuIae7Ic/hLzEEnV9HKYp+T2slA
	 uddxc0GNuuKFm4lachuclzP+dxeakxHuxvocO0QKxEitVZdMPVFhBirzMfnCBlAhK4
	 LP6qFbG/BTcGzyke3nu1xgOrC2zd0dSKaM5s/oSmOgi9KCz8Brt2j6+JkKRib901X7
	 4o0UmmthTuQ0A==
Date: Tue, 12 May 2026 13:57:01 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Bill Wendling <morbo@google.com>, David Hildenbrand <david@kernel.org>, 
	David Rientjes <rientjes@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Suren Baghdasaryan <surenb@google.com>, 
	linux-hardening@vger.kernel.org, Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Hao Li <hao.li@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alexander Potapenko <glider@google.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev, 
	GONG Ruiqi <gongruiqi1@huawei.com>
Subject: Re: [PATCH v4 1/3] slab: support for compiler-assisted type-based
 slab cache partitioning
Message-ID: <ukzpbgomokgwof4ulxhabbvtfexuihegnmephhe66dp5qeet6q@m37pdnzjakjr>
References: <20260511200136.3201646-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511200136.3201646-1-elver@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 581FC18000B
X-Stat-Signature: w3ray9q7armisgdm9tbab6odsp38zd96
X-HE-Tag: 1778561825-624465
X-HE-Meta: U2FsdGVkX1/oEyBw03xPhRnVkBiUuXvL5y2qMvq4At/xicKammVxd5gYzVSG7lJIaYm/mA/i+98Rv2WjiN6q+LBHhULC0w7042VybbSnICvxSmN5Pkrur+uyCP5sRmAGkDQx8AweHBszWqZDoVXsoSa3b5TOsEOVpZcmwupDi2t1nv09SlixMGnFVqOo9WyzkFzYcNmfzX9H3vCYcI6zgCA858+9QT0d/zfvd+b8Gz3IQjwmPDX5m/hl6xFZqTovNpi0uYqfXfmbe1ymNz10Kl7vteuR7DmCIHjb2EvnUpVoZsciNOdrGM82a1aJlAbJyTQf/xYhZKu4FT2cW58pgziVTQiNW3f7CwQui7h+FpegMQclJa5RpOXFTlaN+XgdvkMzWvzouau/N+NyPPupupzEgIOGcJhSoDtFxSZxOF8QiK+Js3G0MI2uai+c+MJyK9LN5sGSmrayzSu7Gkh/r79kWL239rHSaavBpCVDSB2tV4HLFB7dcw0NFurZjWONpAIORM7JNS/MiNur2n9PDpGlVq0aibtU9cSKYuSAM1kZDlgJL6De6Fc8LXeHrdRC4lmMZYD0Qok2jVJ6iG9zjxw+S9GREfhfYlljP9a87PHWZsMd3J6ZCdPoFBIn2MEZXlU0x9R+9HY6qrTFuZQkjjlt9G9B/+Gq13CMl59s+fjsi9/S6/de6EcEAoW/9fasygFyvkazmMAOwbl4bonDpD9TPWKPpnQFdSEnKbUh5+WllWEIFf75ac7h7VZ1kqkverR5bcYzhqV9MP1lj+GfpUZsTIz5g+xNbF3sEn4lcS3JW9DURbJ82yGZF+etMIf7XmY5/woxql88yuGURyrGeRMfChSCot3+Jm6NMPjAc6wBODGBUF5aHtWPFQNwDh2XZzRRq1ZUxvpgIXZzImX6glsLJgUjgqtsMmdNvMHEOvj6jiOExW6qNZ66UQ8xqoFckVXRI+0dEjXfcmjTCV3
 KbuyKD7x
 lmylqbHz3RNfo/AwTIPb+rvev+XIz9W3JMHx99QMakAi5mGNTN7IMyOs4RijsBtgzjRn7aPTMQsvCqWx/z18fQtNVxXKCkJBWlxe2dI8MLR8noGWEX6jebXV5nUW78kFxvDrIETfVxU16Q76uOcHTS1mdojAlvajjHByl5jT1vxHuUy8DdfF8it4Qo1NwPTo8CNZveK83DLkLnmCRCmadtv8rdkf5x9Taq5oGS/+UaffiFEp6Nt3Ij1W1qDV+Fcfai2kOY08P4gIrdalw4jHAkDtD+MKeVxGwv63aQTT0mMIqJaLkG9/C6Msbx6q3r/mscaQ6eH4UmCP7TqWOd9GjJfjJdLTyRs5S20NgutMsDIeRjt0yBgWrbLK3KuC6IHLXnQLsUcZ5t466jadLNvvMj7qEpDcpFK7xvZ+hGPFOImtxcvlkojOSEFFO/JVW9YKg3WKdwtzzN8fQG1YmLFinne/oUEW1z5NebCm5nk/aSHYfSoRC5chLl3y9quseTqNsD6G9TxbDuQq1ikOALj4kuh8giCQhaljVdRPkVR0wyNHj92qbO/Om36e0lGTvyuqmyJDHdXSAuCKSLXkNda2JCNGPWKO5y2gEnmcZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 10:00:48PM +0200, Marco Elver wrote:
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
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

>  # Sanity check userspace page table mappings.
>  CONFIG_PAGE_TABLE_CHECK=y
> +config RANDOM_KMALLOC_CACHES
> +	bool
> +	transitional
> +	help
> +	  Transitional config for migration to KMALLOC_PARTITION_CACHES.

Heh, didn't realize transitional config was a thing, nice!

-- 
Cheers,
Harry / Hyeonggon

