Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71023606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCqxzAJj
Received: by kanga.kvack.org (Postfix)
	id 920266B06DD; Tue, 24 Nov 2026 08:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7926B06DF; Tue, 24 Nov 2026 08:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7216B06E0; Tue, 24 Nov 2026 08:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5643D6B06DD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:30:27 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5EEB140BB3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:30:26 +0000 (UTC)
X-FDA: 85470096852.29.738A164
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 36BA240008
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:30:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCqxzAJj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795527025;
	b=ryFpN+uQfP4j1LM2DHiZu4bj6VV20rkDErhUmoKNjMyShj9TJZgX3un7oAIeigLkyE9k5l
	QDInzGFByyB7YaCgd7DfLVuwYAZTZxT3Rzdp4Wz1IekHsf1J6bx4q6XvtHmUcO+9gElzXo
	n0O2ALj1Ed2NTJypfGmZUiXYfEdXCCI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795527025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dHp9HTARdoHtxKAu6nPHPSzmPEU1mRqVl5Dy4Gq+ko=;
	b=Dz5A8a22N9scuGHZpk7qLPkAHMk3PZG5XoffBdThfFifonlM/mf76AaH+l0o7QUC6g1og+
	sasRwoWK+McE3XDXcNGaSYYEC1peKoKj3GIb5jyBifAr78k/Aqw4rfVEy3dDll7trxal2O
	4S+te3QjLV1jk5rwKO7Rn0Dl/t9PrcI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jCqxzAJj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of aneesh.kumar@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=aneesh.kumar@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F60623A5;
	Tue, 24 Nov 2026 13:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1429B1F000C6;
	Tue, 24 Nov 2026 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795527024;
	bh=5dHp9HTARdoHtxKAu6nPHPSzmPEU1mRqVl5Dy4Gq+ko=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jCqxzAJjVpIJjwovRyqxRWcIP/1B3dGdfwKBWeMKdR8HKyUrkxtLFRbPDJMQLyrXb
	 owAqj3PB6cKHqac2gb0IwSUnm6Jz149LTaGXvIacdGk2W381ux3zvZoZXbN+neKPF3
	 1PHEsfLA8kEDrjmujBkqVkHmbA0E8gDIOIkjgM6J5C2vcD1lMEU6JiYCBpy8r5CFJo
	 cdhDHzPASzOI9GYVDMxu8Q3IH3tHuhugE5hCwGZ29K+jacyTfw/E4MwfT2i06O/AFL
	 R4B/E6tiODpZWkUSH2LaCdCMjaXBhI2MO9cxeHkKmawVLpMcJRxhf31tfzXIRXcjR3
	 N/DAqTlKmk0CQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian K?nig <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
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
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
In-Reply-To: <awQd81MwZqi55gf8@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
Date: Tue, 24 Nov 2026 19:00:00 +0530
Message-ID: <yq5aa4mybbmv.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 36BA240008
X-Stat-Signature: 16p4yzj1hhi56g3rug7ng7c98mad5pnz
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795527025-409982
X-HE-Meta: U2FsdGVkX1829PnE/J9V5St9mrrYRX6BIYfqX+fvQLKXvmWWqh2rvUG4gfX+WhRIH4PJIGkbOOLpWzV6GMGL5TgrGriCp7cqFUH6b0htIK6GcMClcUEHGqIHNrv6Migzb9dC4TKVZnu5fBfyzolqb52aofjzbECuWGzcEl01P5J7fH7/QACXFw8WIbRrBv6D9bensUQUauJ1zBMLxWLMLY9W+HKBnC4eRxGvBorSg4ux3wZaPe4CcuXXzgVT3qneAK2d3mQ9ywq3/p7wuuNcUKa2Y/aGiCF6E8ALAs8XwMZQhkA87SYmAqUmJ3+IafDpYg14TBplgMzpKm6vvlLOUP1KKvD8ZLQKDBPPA8bakf7iConawp3vXSK7LbSUvkfWHTXamAXN9yE/ROabJ5Pulj4bnyN6xao1IhYmIOFcLqhZTVKeyPMOU6VAFW7yD3Ou/0Pd+9EPuQsvgLIkEL1KyRl4k/Zc+WFkmNag4Yx/N5DEEuGx+8o2CGxmYEkF5CgUr9Ldi3R+Jc1PYzps+vsmw5g7Vj2hdpkENCQe4FBXSPg5Fzkta48fN3PuDgK77b03TrCx/QyAENXFz2Td7Z+SrDn1PrW1vDimrX5lXriloMH80JMMrpZvTE6NFTw7gqdfJdgwqEZUcWJ7Izuh5t6sYNrGDM5nhmCZnItJEuMo6pB6vq/uKMcnSJcd9jSSQvmG1LGxwNioRI6paMsmswNx70Y/iKZGe7Vu8ocyYsVfbBdnh1ZZ5mYdLZJ/OmO8hv2SRhPrrEF5cvbzIRMWkajfP0Eyvs5N0ioic919aMaku3uxinMdO8uooq85546BFvtZy2l+tla7bymfUwMVQJ3ejyHFyZKPEBg/bfBGIKw6vXVmXZv7uJMnSGKsSY8b8Mkl1yztj6YNa3l/TCTlRfQqlF9I74s9QerYdgE/gjrBL24+dzYZXguNN37oUBEuVoyCBSyUGM2gsxyk3mudvIy
 rAdIK0G1
 W6b2SVYBIcX4vvL/rijju5Q2Xwl5548/dWZveiFop630r1kltAmoK6dQRFyUIapO2N4jWASOXwcus1G2Xmp2zpLZHNiR6VzmPjgOMEwczcsod8UqUWfufejJzN/2N4mSbag7WjFrHX9SHc8LzfysmabluSRCNJwS5zaYr/kRWXd7w9F+/AyrY8a/1eXtKyWvyrdeP92fEBV2017oUq1AEb/zUikpvw5IMnrPIBfFwVomhZmCRtZPn4WissL3LoWfKIKSf30dMzmJ8fJw0ZvIMPPs9UxBB0PbNve2TpnC0jrgc0BxPaM5QsO806iA/AIdndno/Sy+w5xpEwo22d0JLkQShw2kxJ/JSU8D3NhPipQ3DUJ3Xkm/LOeXf2OVsYYPldpll3c39XLDnUSddVPFdKJ3rgglgiTLv3N8BYPgrLZFdvn6QYBpT6zaIaAMzApLINdsVCX3sYdXm4qRwpEPNko/+0orENG2ZHm5F+gpdBs5Jd6ZqYNE7clrcWC6MGYpc+1lkU9ZwrIg07D+T5oRXlvAAQ0tKtrYtI/G5KMR/atsHPTV96MS2M8/tPP71jWSJOKyh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Catalin Marinas <catalin.marinas@arm.com> writes:

> Hi Aneesh,
>
> I'm replying on this patch rather than on the one introducing the API. I
> think it's more obvious here why I think we can make things simpler.
>
> On Mon, Nov 16, 2026 at 02:41:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>  static struct page *its_alloc_pages_node(int node, gfp_t gfp,
>>  					 unsigned int order)
>>  {
>> -	struct page *page;
>> -	int ret = 0;
>> +	struct cc_shared_pages mem;
>>  
>>  	if (node == NUMA_NO_NODE)
>>  		node = numa_mem_id();
>>  
>> -	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
>> -
>> -	if (!page)
>> -		return NULL;
>> -
>> -	ret = set_memory_decrypted((unsigned long)page_address(page),
>> -				   1 << order);
>> -	/*
>> -	 * If set_memory_decrypted() fails then we don't know what state the
>> -	 * page is in, so we can't free it. Instead we leak it.
>> -	 * set_memory_decrypted() will already have WARNed.
>> -	 */
>> -	if (ret)
>> +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
>> +				       PAGE_SIZE << order, &mem))
>>  		return NULL;
>>  
>> -	return page;
>> +	return mem.page;
>
> This part is mostly fine but I do wonder why not make this alloc
> function the same as buddy alloc_pages_node() - return a struct page
> pointer.
>
>>  static void its_free_pages(void *addr, unsigned int order)
>>  {
>> -	/*
>> -	 * If the memory cannot be encrypted again then we must leak the pages.
>> -	 * set_memory_encrypted() will already have WARNed.
>> -	 */
>> -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
>> +	struct cc_shared_layout layout;
>> +	struct cc_shared_pages mem;
>> +
>> +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
>>  		return;
>> -	free_pages((unsigned long)addr, order);
>> +
>> +	mem.page = virt_to_page(addr);
>> +	mem.shared_size = layout.shared_size;
>> +	free_cc_shared_pages(&mem);
>>  }
>
> Here it gets weird and I don't see why we can't have just a buddy-like
> interface. The kernel-doc for alloc says that shared_size must be
> retained for the corresponding free but without reading the source code,
> you can't tell that cc_shared_calc_layout() gives you the same
> shared_size populated by alloc. We have a similar pattern in dma-buf but
> using the compound page order.
>
> What's wrong with a simpler API:
>
> struct page *alloc_cc_shared_pages_node(int nid, gfp_t gfp, unsigned int order);
> struct page *alloc_cc_shared_pages(gfp_t gfp, unsigned int order);
> void free_cc_shared_pages(struct page *page, unsigned int order);
>
> Both alloc and free take the original request order and perform the
> round up internally without exposing the details to the caller. Alloc
> shares the whole resulting buddy block and free makes the same block
> private before releasing it. We can document that free takes the
> original requested order and releases the whole allocation. Partial
> frees aren't supported.
>
> We can get rid of layout and mem structures (or at least not as
> part of the API). Of course, this assumes that the shared granule size
> remains constant for a guest's lifetime but I don't think that's a
> problem.
>
>> @@ -278,7 +267,8 @@ static void *itt_alloc_pool(int node, int size)
>>  		if (!page)
>>  			break;
>>  
>> -		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
>> +		gen_pool_add(itt_pool, (unsigned long)page_address(page),
>> +			     cc_shared_granule_size(), node);
>
> Here we can introduce:
>
> unsigned int cc_shared_page_order(unsigned int order);
>
> and just use (PAGE_SIZE << cc_shared_page_order(0)) for gen_pool_add().
>
> Was there a caller you had in mind that needs the common allocator to
> share less than the whole buddy block?
>

No, I don't have a caller that needs to share less than the whole buddy
block.

Taking Jason's feedback into account, we could have the allocator
request compound pages and recover the actual allocation order with
compound_order(). That would avoid passing an order to free:

void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
void *alloc_cc_shared(gfp_t gfp, unsigned int order);
void free_cc_shared(void *addr);

Alloc would round up internally and share the entire buddy block; free
would recover its order, make the whole block private, and release it.

As you noted, dma-buf would need virt_to_page() to obtain the pages for
its scatterlist.

-aneesh

