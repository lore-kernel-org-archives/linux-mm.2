Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 562F1CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:08:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F058E0005; Mon, 15 Sep 2025 10:08:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05608E0002; Mon, 15 Sep 2025 10:08:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42A78E0005; Mon, 15 Sep 2025 10:08:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93F928E0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:08:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46082BA910
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:08:11 +0000 (UTC)
X-FDA: 83891663982.16.4791E67
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9126118000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:08:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPNNM2K5;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757945289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pxnt3sHwAQpyUbxOwOsUzgo5O1xyk2XabDAUUNgLXds=;
	b=VkuJMqNP3VygxHtgcS/vRsGIeBMeui2vYdkrdXibxLI+1dSWu91eNEuMt45nSVLkrx6dxG
	g5FJNpyiNZdHUQsDHcdTrzAQP/WW0uprML9sKZ7XRf/zA6rPZBQYmbglPW3y9Sf0xB6H4V
	K+ixP2pHZuHSyqzdnCNJtG4ojRckDqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757945289; a=rsa-sha256;
	cv=none;
	b=bNvzhO9dTMVKNpQ2Q5w72JljPAKnD5e6LgEYJzIa189jnstlRk7mJiIQZh2PRtL5KkjS0M
	SypgzpNDS08zfN+g3mBBd7Eam3nb/lZEAPwV1GwLrSPN3SZCIABSuhtp+6BoTn1pxQ9XOd
	U69fEe4LPB31IhLYfc0nOvQPP6JQJ+w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPNNM2K5;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C12C46023F;
	Mon, 15 Sep 2025 14:08:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B3BC4CEF1;
	Mon, 15 Sep 2025 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757945288;
	bh=h50qQh38duU1m6UIFJf7kQKicDE1Q8M4KDLHwbgBOf8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NPNNM2K5+B1b/SGk0biF3/sOCzrwdCGam8qGKQHN+sks0w9l8kVUKoPjqOjSLiFWS
	 2Kr+U43tOamkUeEMzbHOtI4pmdBkDOAjZ1TIi0djoYjB3zPh6LyuRjqwO7ZwrBJFqA
	 /Gj13YwN9YfxvmHRe412aU6eX2AsYpzT5f5WMy/7jNaL9tvMUllEfmqj3TY74AqKpz
	 oi3AEtwgKPN1k2cUpXB+CCBwz9fNLonEJvXs3vZ50hYxlESkNOp9tbnNyUyZ4ksghJ
	 Rchlx7gZR8ShmyvcSHwDa5Fw6FKvXyMxd1GTSQe+POyeTUnhCdELwE/nLGFz2pcduw
	 M8mwbbGO9VV3A==
Date: Mon, 15 Sep 2025 17:08:00 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aMgdwE83dKdT1K7L@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <mafs0ldmon784.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0ldmon784.fsf@kernel.org>
X-Stat-Signature: iyribmn87gf3k97mpaamgusar97ficcn
X-Rspam-User: 
X-Rspamd-Queue-Id: 9126118000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757945289-303767
X-HE-Meta: U2FsdGVkX1/wggMOp+qhrIpFm6u1wE4kC6jKnIVmZKqXqeXn8tgdAAs7BpiQuERQmnf5TGp9fAN0yU6l6s83ytwZFSpINPW1mv6bol0NfSENpkuioyyEgBm5Lf8i+sCgAyCWkWu+XFksNwjokRnlsV1FP/hKopxeUq/im2gH9xyCmohTie9Zm/itxI6pZGEZ7ySQ23NJcRxYSQLqAayNOzf8dyj4BuEumVMLeS64bN2zMMk0bKPrLh61SfPZ5GEecwAJDs0qeqNIMeEBABChdru/dJaf+XPANAUScl3AKeKiDo10JTrIJAewEQbh9lUQh6NCjfUvj21er57TjQRp4sQ24hOzN9rO/EAu/gqQrqHHr9/d6C3xscL30By0EzjtawNY/uLykf2V9riQU+8zJVv7ImbPGO67AmNP9CtLklIsKMBE4J/I/R8dUQ+7n4qnLbXNrsgrXTyO4NeeIC7w4QJKNdWBYHxuonSjMi/QiqleTh8MoKVA5rwDXRGnMSEJ3CXmbRYccl7QnHvC+CV2EV02QIu7vv6iMYYH9NeJ1WfqnjVSlnoZsJy1Ch33jYYLf6RowJvklVNKSUZpqoSWZEUyk1g4nuTP8SMlgFzHrEtmXozAhak+0WoiCdt4Z1axa9629rmVKgfbdp32TM6gLxOwDQpDSYGEHxyz/JagqMTmHg5UjLgS7HM3F2bvj0yks/2UQ5Bkxkvp4KjLYKcsutqoshPI/CiafUDG6dgsHHW9po2rR2iX9f9O9ex2k/ONqVH0C14RqxSVSty6fEYzeCsBhDu5Nd2gQBb57mb3OcztwDPludGElTIhn9N69RVwxUWhbj2eKOLmEteSbROeNcnQZDXOn/Mh0J+ZNZr3ZpHkF8ufmaqRVA7ml8OvTKoI5F6U4sgFyheV3tW0RMmBwogtCg41hHRYDr9AYo3pe8lGTksndJkenxiiNuY8yFi69QL5mqsbETJFbYvvbUp
 Ith+a5Sj
 vXBzhXBR22at1A3N4wp6btQb84lQliyd1bNSj6xZOc+LP24K576pGy/S2v30crxIHa+p5vZs2RcObRwr6IoN92uu7+WNarK8ypjsnawy1UN0FTx0wExksKUekQnrtxOZpnJaF+8to15AVof6cL+1kKUXGt5H8S4LXnkrF4UH/sgPcPGY7Gb2M2+O6wzK/mi5PpZElBN4h9zXQ0iXxJYysWhylFTtyfivTQZd+DEORioH6oFIMTztJtju8PlfOU9sshBZJwaqGMqXKLW4/IBLPa0APWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 08:12:59PM +0200, Pratyush Yadav wrote:
> On Mon, Sep 08 2025, Mike Rapoport wrote:
> 
> > From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> >
> > A vmalloc allocation is preserved using binary structure similar to
> > global KHO memory tracker. It's a linked list of pages where each page
> > is an array of physical address of pages in vmalloc area.
> >
> > kho_preserve_vmalloc() hands out the physical address of the head page
> > to the caller. This address is used as the argument to
> > kho_vmalloc_restore() to restore the mapping in the vmalloc address
> > space and populate it with the preserved pages.
> >
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

...

> > @@ -742,6 +743,205 @@ int kho_preserve_phys(phys_addr_t phys, size_t size)
> >  }
> >  EXPORT_SYMBOL_GPL(kho_preserve_phys);
> >  
> > +struct kho_vmalloc_chunk;
> > +
> > +struct kho_vmalloc_hdr {
> > +	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
> > +	unsigned int total_pages;	/* only valid in the first chunk */
> > +	unsigned int flags;		/* only valid in the first chunk */
> > +	unsigned short order;		/* only valid in the first chunk */
> > +	unsigned short num_elms;
> 
> I think it the serialization format would be cleaner if these were
> defined in a separate structure that holds the metadata instead of being
> defined in each page and then ignored in most of them.
> 
> If the caller can save 8 bytes (phys addr of first page), it might as
> well save 16 instead. Something like the below perhaps?
> 
> struct kho_vmalloc {
> 	DECLARE_KHOSER_PTR(first, struct kho_vmalloc_chunk *);
> 	unsigned int total_pages;
> 	unsigned short flags;
> 	unsigned short order;
> };
> 
> And then kho_vmalloc_hdr becomes simply:
> 
> struct kho_vmalloc_hdr {
> 	DECLARE_KHOSER_PTR(next, struct kho_vmalloc_chunk *);
> };
> 
> You don't even need num_elms since you have the list be zero-terminated.

Agree, thanks. 

> > +#define KHO_VMALLOC_FLAGS_MASK	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
> 
> I don't think it is a good idea to re-use VM flags. This can make adding
> more flags later down the line ugly. I think it would be better to
> define KHO_VMALLOC_FL* instead.

Ok.
 
> > +static void kho_vmalloc_free_chunks(struct kho_vmalloc_chunk *first_chunk)
> > +{
> > +	struct kho_mem_track *track = &kho_out.ser.track;
> > +	struct kho_vmalloc_chunk *chunk = first_chunk;
> > +
> > +	while (chunk) {
> > +		unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
> > +		struct kho_vmalloc_chunk *tmp = chunk;
> > +
> > +		__kho_unpreserve(track, pfn, pfn + 1);
> 
> This doesn't unpreserve the pages contained in the chunk, which
> kho_preserve_vmalloc() preserved.

Will fix. 

> > +	while (chunk) {
> > +		struct page *page;
> > +
> > +		for (int i = 0; i < chunk->hdr.num_elms; i++) {
> > +			phys_addr_t phys = chunk->phys[i];
> > +
> > +			for (int j = 0; j < (1 << order); j++) {
> > +				page = phys_to_page(phys);
> > +				kho_restore_page(page, 0);
> > +				pages[idx++] = page;
> 
> This can buffer-overflow if the previous kernel was buggy and added too
> many pages. Perhaps keep check for this?

You mean it added more than total_pages?
But the preserve part adds exactly vm->nr_pages, so once we get it right
what bugs do you expect here? 
 
> > +				phys += PAGE_SIZE;
> > +			}
> > +		}
> > +
> > +		page = virt_to_page(chunk);
> > +		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
> > +		kho_restore_page(page, 0);
> > +		__free_page(page);
> > +	}
> > +
> > +	area = __get_vm_area_node(nr * PAGE_SIZE, align, shift, flags,
> > +				  VMALLOC_START, VMALLOC_END, NUMA_NO_NODE,
> > +				  GFP_KERNEL, __builtin_return_address(0));
> > +	if (!area)
> > +		goto err_free_pages_array;
> > +
> > +	addr = (unsigned long)area->addr;
> > +	size = get_vm_area_size(area);
> > +	err = vmap_pages_range(addr, addr + size, PAGE_KERNEL, pages, shift);
> > +	if (err)
> > +		goto err_free_vm_area;
> > +
> > +	return area->addr;
> 
> You should free the pages array before returning here.

Why? They get into vm->pages.

-- 
Sincerely yours,
Mike.

