Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09813606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 11:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KvhrT8NK
Received: by kanga.kvack.org (Postfix)
	id 191516B05B1; Mon, 23 Nov 2026 06:05:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 142CB6B05B2; Mon, 23 Nov 2026 06:05:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030E96B05B3; Mon, 23 Nov 2026 06:05:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D797A6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:05:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 303661407C1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:05:38 +0000 (UTC)
X-FDA: 85466103156.14.1B34F93
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19D3B1C0004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:05:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KvhrT8NK;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795431936;
	b=8jhgUB9NZOiu/nDpotzn/D2ngxj+bhsETolpovEHBKqO/WHrZu6XlBTKDvwsJWuCCg5NKA
	B9v5/Z+78R1E2seVHY51bWQ/Ss8J+KjHVMN5mHo57UzBdQsyUa3ZWXmo+azPZw2SzWnVPz
	cUikeACO8hyPSkbIby9+0el1eKtoV/c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795431936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y+pXRncvtOc4nB9TtW4KG6FLyRulzoczl3trVZwKBJI=;
	b=UUDyjJXj2qXZspgoXfJWFEa1En/+wNKR+I98Ni9gsTnXNmdjb01ul+eCM4qtcCwpYRELsO
	XlpuoQ2674nqF/R0K0IvZbbegboc790ILV7JbyJTym+nHQMa977VK+YXZqeWPWC1Z24zk5
	hGxuD6GFvmfYHWnXTY3FlDE/rQM2qgk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KvhrT8NK;
	spf=pass (imf18.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 218E3143D;
	Mon, 23 Nov 2026 03:05:32 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A83273F882;
	Mon, 23 Nov 2026 03:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795431935; bh=kCUeWgNlDSox1V+xXIV0FoQklIwe01iQtQShkTSpFns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KvhrT8NKkwfUQlN/JVYJ5xdBVy5POFXKjhsTfodMnif/DZoxUXBTRSE+v99DKNllE
	 5d1fBxUVR51g74P9by/+O7T3jZUmuCzToT2ynvCd+snaLJQPIjfE7jA9gHVgHouzT3
	 DFYSeENRGheUkSn0CCeE9f0MsFw+W0BZ+uXNA9WQ=
Date: Mon, 23 Nov 2026 11:05:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <awQd81MwZqi55gf8@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116091137.94252-5-aneesh.kumar@kernel.org>
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 19D3B1C0004
X-Stat-Signature: tts1c1z8zuww5c5qumzoz1x43h7on6cq
X-Rspam-User:
X-HE-Tag: 1795431935-498127
X-HE-Meta: U2FsdGVkX1/TGQp7HSQVTuyJC8aS9+EcPWxDe3vbP3CISHOds107rWdLXwS5GEEl5JMpFgxvWBz6dAgRkNf98cLdVmyGmfXrRxRYIMtLzuZHwckOoG6FTIjOOhYdQt+bdA7nKbJMYFFIl8DXHSlpjVb2YQbEonmh9qCsxIYdywTctPz77gB9eL0dBvUPszhO+YbjS2nqfENnxuAhBIQ1IbmhlQ1nuMYELYl6fcWj52SvjZ5FAnXPklE1aZEMNpCCEPM02E+sA96iPZAc5KJWdO5qX6uHvIple2fBDt/L373cQMsZTck4wn3kezV4rKtJvdOKK/+GjxtKxZCVGLQbzf0Xt5o7x/FauR4c3JHmTL9kjLFYu6f7PcY7g43MbhYTSSCBDRP1RX7aZTjGbHmS9aIZdDeYfPztlFdK6jRmbYLmBCJA4rWdJKEf8T8FA7b5BEeKH0KjenDlI/o+teWkwK763CC0BlmXymnsb6/fOjyJmfEzuWUX5bxke2Mt8wZpVs5K3G8ThKsKYt0YALb4f8P1w7ClqxlHzZHWurJINa9OJbSiHyvDKoVGNQ/w1KOZpaBiNNz80acjehHneu+NJfdqWas5dTJvXURnaOfzV2o5ytrp29rZYtkv4ufgX0YfKwjFb/KYdjCbPRFluOPSKxq06Zpyaxc38Y9ucarvD7bhFEFTQSCC4fwMMVfKAdikAVF632hbAu6X2UQtMSn8fnr4XIbHMuORN53lJC0EMwD0ht8wvxYXlPm6c/AzbSMZDhky9/nmpcFDSeJS10U+1TimBvQRLixpnRFUUvzGKgVv89gv1UZHulnth0qJVV4LIcbg2c2O2vw5eJA0ixPLZIw8stzxJuQ/8ABqHwtSkFf06mTtb4J0GAwjFXOcFHIdCSajg0DnuJZINVQmqnFn9mfVVHOkJxbRT1QxrqRp+SLK5713xrdqEbq0w+RCJ+/Oxy4lnRa/DiAH4eqyrZr
 Q3ZiSlxU
 fK4Rh27WSpdPuo4ycIRjRhZM639gO44KUpk8zXevDHhfQESGI/VSmRQ0TZAJi6BWgeM9Zuf6JQdyjJHt1zJ2fzQLI6T4LQu+nM9F8lsGh5Rj2zNNSUu+TiiwU/bCAam1N6q8tnU+hgNAtu2caOxr2czr1dbPxM029uJif9moHkkhC/qCEvXEwArj+cAXx1s+3hJS13JBhVm89t9X1wY6CAHP35Td328GbwOoG8J/cAmtXOR2mzLBYSJbh3IxtrU8oPzJEJ7MSFqBYJtzg8SUleyBEM/CgSrEb7cRfkgd6Dtoo6hhY96J/PIP/YleLoq7L+3o3Kwi0yKwgrua3VDKUkGMzM4RKf0Qdq8GUn1fZfGyF9I9NJtpaZkFav8JCd0gmhfTL08BfNGi+N6Rp9k+GKw1hlnmA52LZY9RTgI0YDqI4QGcoj4efj24G/PMzoMJFOXuDOcWaVSMfVTs6Xp0Bv/pp+lXJ+V34E9dEd6p0t3OmkLd6YMUVyppimr+0uDXDYf1sZYbtOpU9TeeqoR+jpiyYhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Aneesh,

I'm replying on this patch rather than on the one introducing the API. I
think it's more obvious here why I think we can make things simpler.

On Mon, Nov 16, 2026 at 02:41:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
>  static struct page *its_alloc_pages_node(int node, gfp_t gfp,
>  					 unsigned int order)
>  {
> -	struct page *page;
> -	int ret = 0;
> +	struct cc_shared_pages mem;
>  
>  	if (node == NUMA_NO_NODE)
>  		node = numa_mem_id();
>  
> -	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
> -
> -	if (!page)
> -		return NULL;
> -
> -	ret = set_memory_decrypted((unsigned long)page_address(page),
> -				   1 << order);
> -	/*
> -	 * If set_memory_decrypted() fails then we don't know what state the
> -	 * page is in, so we can't free it. Instead we leak it.
> -	 * set_memory_decrypted() will already have WARNed.
> -	 */
> -	if (ret)
> +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
> +				       PAGE_SIZE << order, &mem))
>  		return NULL;
>  
> -	return page;
> +	return mem.page;

This part is mostly fine but I do wonder why not make this alloc
function the same as buddy alloc_pages_node() - return a struct page
pointer.

>  static void its_free_pages(void *addr, unsigned int order)
>  {
> -	/*
> -	 * If the memory cannot be encrypted again then we must leak the pages.
> -	 * set_memory_encrypted() will already have WARNed.
> -	 */
> -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
> +	struct cc_shared_layout layout;
> +	struct cc_shared_pages mem;
> +
> +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
>  		return;
> -	free_pages((unsigned long)addr, order);
> +
> +	mem.page = virt_to_page(addr);
> +	mem.shared_size = layout.shared_size;
> +	free_cc_shared_pages(&mem);
>  }

Here it gets weird and I don't see why we can't have just a buddy-like
interface. The kernel-doc for alloc says that shared_size must be
retained for the corresponding free but without reading the source code,
you can't tell that cc_shared_calc_layout() gives you the same
shared_size populated by alloc. We have a similar pattern in dma-buf but
using the compound page order.

What's wrong with a simpler API:

struct page *alloc_cc_shared_pages_node(int nid, gfp_t gfp, unsigned int order);
struct page *alloc_cc_shared_pages(gfp_t gfp, unsigned int order);
void free_cc_shared_pages(struct page *page, unsigned int order);

Both alloc and free take the original request order and perform the
round up internally without exposing the details to the caller. Alloc
shares the whole resulting buddy block and free makes the same block
private before releasing it. We can document that free takes the
original requested order and releases the whole allocation. Partial
frees aren't supported.

We can get rid of layout and mem structures (or at least not as
part of the API). Of course, this assumes that the shared granule size
remains constant for a guest's lifetime but I don't think that's a
problem.

> @@ -278,7 +267,8 @@ static void *itt_alloc_pool(int node, int size)
>  		if (!page)
>  			break;
>  
> -		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
> +		gen_pool_add(itt_pool, (unsigned long)page_address(page),
> +			     cc_shared_granule_size(), node);

Here we can introduce:

unsigned int cc_shared_page_order(unsigned int order);

and just use (PAGE_SIZE << cc_shared_page_order(0)) for gen_pool_add().

Was there a caller you had in mind that needs the common allocator to
share less than the whole buddy block?

-- 
Catalin

