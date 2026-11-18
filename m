Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB84606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PnizEqc3
Received: by kanga.kvack.org (Postfix)
	id B0FBE6B05B2; Wed, 18 Nov 2026 09:22:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE77E6B05B3; Wed, 18 Nov 2026 09:22:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FDA76B05BC; Wed, 18 Nov 2026 09:22:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 84F316B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:22:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E36C4C0755
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:22:20 +0000 (UTC)
X-FDA: 85448454840.26.794967C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 53D57A0008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:22:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnizEqc3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795011739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wQ/P0S/BIwLbAm3SwXm7MlYVraP/+sqEwKu2qG1M6g4=;
	b=piEIFoLQQbjNjtnbX0Ww0IupVhG/jVt1uzxXT1wDPA9vkbGkSZHgjz4F/9i2MD9L/CaXLU
	goi7Yj8Y3eqC8kUKeeZvfWywjjERSkivcT7zp32o/HjWkxLRHCGcapnwhCTlTDfGRqk8to
	ywjXEo7OKCKzWb65g2FJwco9sEkL8dU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PnizEqc3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795011739;
	b=mZ8geMGvpgLeDiCiznrquVjy/FBhSoShFYxbOM9tbMYNwWdN7c62ra+Q7Jy3DcMGhyO6ho
	RArPZZGH1LdgdiJbfBOkwOvGt/mUJ6j4PsmYBIbLi3EoSgmgdgL/kz8cBEtYqx23aRM2PL
	OBaNA+/TfOIedUmg9N6bEwrDQJ+7Jcw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDAFE6224B;
	Wed, 18 Nov 2026 14:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8FF1F000CC;
	Wed, 18 Nov 2026 14:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795011738;
	bh=wQ/P0S/BIwLbAm3SwXm7MlYVraP/+sqEwKu2qG1M6g4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PnizEqc3duk8cYNxG5qGYHzwEoF+La9oGAi8pJGK9qXZcAv3wu/S8lvPf3PlCLFNX
	 //mLiYaJ5aV1BWHge/nKYmGK+aCkhIbb5oU9XMvP4IFkSOORivHfYnAt9bGZyXpeKh
	 Y858N4ekCEGW6tAiolhdqT4gMpWa1yltL+Kz8VN1ujdXnukHxAmxtgs/7xzW7e4bvx
	 VXFOM1e7HjLm7XniR+DbNVU6dhqAaXV8djy+yP7OvAcNIo+8kp41tilnabUC2fNmlk
	 l6G37fDwn1RJTgTT2PL4qy061Tr0IgTS6fz0aV832Uv9+RPpoEi/L4bVZIWv3EcEDQ
	 Y6KdCOczQMvbg==
Date: Wed, 18 Nov 2026 16:22:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 5/7] mm/page_ext: allocate page extensions early for
 SPARSEMEM
Message-ID: <av20jiGZH5uYV6LT@kernel.org>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
 <20261117120627.50601-6-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117120627.50601-6-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: 53D57A0008
X-Rspam-User: 
X-Stat-Signature: ju5a7fpxbceua6e7noa1385r7cfddzrh
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795011739-685440
X-HE-Meta: U2FsdGVkX1//6nacvghDhzsDppg3i3AULAv1ox+1QUhpokmhrS2f7ZxD2Ap4tXjtXQD3LNEXd0hxUQZfB58BQ7Glkw0zWp47uOSmNR76tVimUnGuiF9xbG9+OWw1y0Tf0cSgks1npMcmGxNjDwuam5pdic/06X7G8LtZ9pLmgM7MVdxa60iKcyMTCuVtvECiNlBA5Z7kgB1gXoH2iEjZ9qw3PjkU/tcllzots9oD/KHnZWHA0U00fY8zZqpPv9FMsuCvamN5NCBb6JuAJ7vTyYtkYklLmmjzr0L+v6/jC6j7LM4GwDfcpmftlZhqPJYcP6EwaNJ0MyU55bmaokjrXdLxcSOG1EtRK+gabyGa7GRbS44fhJigN8EmH65L5SUzMmHyCX402Z4OKmbgU/Yld93c94eUOr46m+TP+OUJpLgC9QSqjPfBs6EQRZg/6e4a8SqWWBpG/AHk5gpBrmsUhuuwxaEUPminffHkc1g8dpvmMNLI5Y/VP9eeT4Wl1jj0BhtV/9JPR0tHWt4wZG4Hi3iXZOBaPdddimvfYRBmeq5D5x211C5y7ARiGr+pEAvl9UTNzy8HxjH3uULwkI+YRKdMWSc8kmNMI0igUmnHPgnAxCnUdTR2SEhRyvidSLFFuhTWHbn5L3T0OyZpJoalaLyUTdUAB/D3xsNVpkiQioS4Im2U3HnUQqnwFT9FM06W+XJ5gI3JuSOIwgBGeQrGXLkWg2WXOybZ2H53KazvRz+7iuPWxhuli2BNRvqIpv6mc5FC4O5U3joxJHduUePXenoMVnrb5VY5+wUJqmhW0ZnJG0tZieGI1Yf0Wu4I2SsUGZJnVeAoX6B3X3Xjqo8R10RwkxxS4QrLWHPXMHy/2ewD7B2e4t/SOJ3JylJatmb5B8JyueF8OkDYqqy/K6Jlt1C9vd2wD5kIa/sf1U5oBP8A/100t0+Cd/DUe/HQQfoTATiZ87wwxA3fMcdMS2v
 xAhZvu/Q
 yr8ttBRKgN3YFzV2MYfXTY+HvI8vSVFRna7b4v7zNkuxBT2ykAZ7+jhmjQEC7GQftHfDS/vAjbdZEwSRlOJY4yqkiGrK+CtBNvZz+mfmdlnjhRnkL/b5DPkDJFE5tFnrtv0x9aGuqo4zbjRIfklnpaEq3e2e6EU3pDSB8cJXiRWDJWeDrRU5FmDPezBICDyilJJ9rk1XtPQW6zY8gleyQjZ1UDyVqPqS9WV1590/hc6ikLTuSkU1tB3q4B567hza6axHIAH18zDQnKcFAbhgusoF3v5cJtO/5FHXLe0kTeEvDnPX9lg3C/0i45uxwSNTedbk/nDu+22Gq7v35Exp4tl1zvRDi4Dpmc6Kp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 08:06:25PM +0800, Muchun Song wrote:
> KMSAN needs page extensions when kmsan_init_shadow() installs per-page
> metadata, before memblock_free_all() releases memory to the buddy
> allocator.  FLATMEM makes page extensions available by this point,
> whereas SPARSEMEM initializes them later in boot.
> 
> Allocate boot-time SPARSEMEM page extensions from memblock to match
> FLATMEM's initialization timing.  This gives early clients the same
> page_ext availability guarantee across both memory models, while runtime
> memory hotplug continues to use vmalloc.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

with a nit below

> ---
> v2:
> - Allocate all boot-time SPARSEMEM page extensions from memblock
>   (suggested by Mike Rapoport)
> - Keep memblock allocations above DMA and suppress per-section free
>   messages (suggested by Chris Down)
> ---
>  include/linux/page_ext.h |   9 +--
>  mm/mm_init.c             |   4 --
>  mm/page_ext.c            | 119 +++++++++++++++++++--------------------
>  3 files changed, 60 insertions(+), 72 deletions(-)
>
> +static __ref void *alloc_page_ext(size_t size, int nid)
>  {
>  	void *addr;
>  
> +	if (!slab_is_available()) {
> +		addr = memblock_alloc_try_nid(size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS),
> +					      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
> +		if (addr)
> +			memmap_boot_pages_add(size / PAGE_SIZE);

I think it should be DIV_ROUND_UP().

> +		return addr;
> +	}
> +
>  	addr = vzalloc_node(size, nid);
>  	if (addr)
> -		memmap_pages_add(DIV_ROUND_UP(size, PAGE_SIZE));
> +		memmap_pages_add(size / PAGE_SIZE);

And here too.

>  
>  	return addr;
>  }
> @@ -304,7 +300,7 @@ static int __meminit init_section_page_ext(unsigned long pfn, int nid)
>  	if (section->page_ext)
>  		return 0;
>  
> -	table_size = page_ext_size * PAGES_PER_SECTION;
> +	table_size = PAGE_ALIGN(page_ext_size * PAGES_PER_SECTION);
>  	base = alloc_page_ext(table_size, nid);
>  
>  	/*

-- 
Sincerely yours,
Mike.

