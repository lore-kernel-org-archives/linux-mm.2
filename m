Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 927C5606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ijpVlN8I
Received: by kanga.kvack.org (Postfix)
	id B08C16B05B0; Mon, 23 Nov 2026 13:29:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1136B05B1; Mon, 23 Nov 2026 13:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F63B6B05B7; Mon, 23 Nov 2026 13:29:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2506B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:29:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 180E9C09E7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:29:39 +0000 (UTC)
X-FDA: 85467222078.09.579B5DC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 049D9100007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:29:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ijpVlN8I;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795458577;
	b=zlx6SGbqu96q9A4DfjWC+RZa9zOtGAYYoonpKZ1Z6dNcSLemK5Y8n6XftvBw5DyYwVInsj
	PvZgaLSl6WGiZgYeZNzi+Qm4jQ15J+Rc8s1VMl0tUT+U+Pp6hwvDOouqTtHQbhyB88ZJvt
	fa27E1Ks5cXLh9r0o4gJ91FXAfOve9c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795458577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4/j1tVsYjuDomGfTOiRNEufIvsMjxkzCoGFkLJLsf4Q=;
	b=xld5vEbSxkigMToCCoNe2ntp48p4iODkxR+9o/rYvvrKtWV5kJgpTYjAmy9M0v9L/ihXs0
	WfuhvgueexLfIGiyoBa3uqdjGNBxMvfVtWlsXTWKBJ7VCK080Shbq9lwIrU924Jz2KfYU+
	uE5fxcYk7EMZXYyhUNEZm4wFeE5ep4Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ijpVlN8I;
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B72C9143D;
	Mon, 23 Nov 2026 10:29:32 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E3763F763;
	Mon, 23 Nov 2026 10:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795458575; bh=91rRqWnUFnt98sbMIZIWLen5dQtczci7+M9TkR+C2eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ijpVlN8I1I3lz+oP0f/Ra6j/FKXUuG6yrg9sGG6aArSc3WgM6d06k0TeBcvheHnlB
	 +bg049yO3+3oRRTrxvdP291vcWCMxo9GAp2+PsBjvQ08/CJLOgCUEhOoOYk7V5y0sg
	 lWIn7leu+umSmLK0yR2G0mX6r/H/ZewmLWycrNRc=
Date: Mon, 23 Nov 2026 18:29:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
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
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <awSGBdS1AiFhJzZV@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <20261123150041.GB179082@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261123150041.GB179082@ziepe.ca>
X-Stat-Signature: s8tq5jgpod31ix1ha4wujherbsxrk43x
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 049D9100007
X-HE-Tag: 1795458576-944822
X-HE-Meta: U2FsdGVkX18PcCSxVzp9Erl7SIGUOGUBDYW3RTR7i85Z4syIj86qpmoA6yOobGGal064tWZakhEoK8ZwcWi6We4RKcIqG35V67Z7hZdVEUtLLwlZEzMxi/ej2bvVA0Y8Dg8BZhHDvFxIqJ/drGV+jE90gThgkzP49Pe2dh8iwTKwXiZQMiYmKnwQSjCaR4jfFHpr6X0/nBYVNtyv7Nlnq6BRA+TaA4WvK7T9tG5BfXYYufPekI9hhGFwl/PhOx3i5kcmzyQ2JVsYxsxhwgtS4mDIk6IYHxJfX10F+txXk/LlwvPCM8XWElGx02DphrviJodaGI7M1nZr2YHNVa2c1a07TVJ6GcLoMnzkE1vY+iiKUjZexf54kl2MavE1mrCu/c8ucuuC44FeKVlv7k1gkz0BGt2V3hdxeLGwbFcjv+ILwRmAv/S0x7g50eD+Z83RgZPdTzdpJDse+xZevJ4+XGKEaF/KSCPW938S19EPKUdtwBm+ybEkuwapjvPTxTsCInvlJ+reit+f2ufv5/GVLmMh4MfZgmwORMTvVX69OdnpvPuQ1GXXUCbWAySYtsoxh6CXsAvnESG6X9gg8oaIuwofCgnRZOGrs0DhZknx9mcugpa3dZNKSLd21Js84F+2NFyzhHa2qVGRRL2k9Y3AQZmP7frhC14Q51+VVPddQHO6Y3meKRv/+XQ5pmbAuB1NvIED2mNvPtWRsomLxVGh/1kZvK+kvWOytWb/gNJRac+gmQPRZ/kxECabWyVzQu00eMYbfyeNUbVzosV4sA3yOewhSl68e+OoghFA3jci3mcjE7zO2aVFJljgG/bK+1nyqa1CGiUz46G2wIELyPMsSi/V/+VTfOxWAxTkutyDm7IVS2qe4rQd+0C8MdmSe6yMJMeYvwKbhMQ6T/14G8jplLdGHxUqhGpt3223QxBw8Wnv1EnHn3pHcWlIPEkIm1c1aqVU1/YRLcC/o11EbwE
 XIMDbZf4
 uFBKrgx0GhPPNzgcMz0Yr3W5m30wuQYydQ+Slw0jNLMiWxI1RGgOpJ6WCJPyoPBlDLRD57S3NnjH8/OU2oexkkMcv6+E5sEOrQQDgTKM9/i7woPcOsvfUkx2LP4NxehNdb2aHS4516IExxjZRuLrMvrUawbQg260fXHKi+AplQZseNL8PVm15X718+fqUYGpTcJsxhJkFtCqcTBXy96i7g+kCdgzGkHdiRKRfTvLAuO68EiL/PfhWSgDCNLYv6QMr3S8i8s0SVNHIVs7EsbcLo7gR7R7VCcFlIMu1UHvpu1oZhmBb4WM18dnDhSLpIiNU0k0G5Uk5cFO5ZPT52Rq9rJp0N+tWy1mJJTVKUbzEAw58gvwx9/uvWbu4HqXjAGs/s3h/KYzyr+pUDE9HCbTTZsqgyA9SxaHAAWjeMBPUr2ZRnmWcWpEb7qX1RHh3USlCb3diAvGeOVIb9EueKES5pokvLFXm+8LZ2FRUqhu1E8kAw9zBpS3S7Okck5OEFfIG2Pf3t87gvscm+y5nbYVO273A7Zmh9eRAiEIuTrSEB30GqrL705nmvIhZOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 11:00:41AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 11:05:23AM +0000, Catalin Marinas wrote:
> > > -	/*
> > > -	 * If set_memory_decrypted() fails then we don't know what state the
> > > -	 * page is in, so we can't free it. Instead we leak it.
> > > -	 * set_memory_decrypted() will already have WARNed.
> > > -	 */
> > > -	if (ret)
> > > +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
> > > +				       PAGE_SIZE << order, &mem))
> > >  		return NULL;
> > >  
> > > -	return page;
> > > +	return mem.page;
> > 
> > This part is mostly fine but I do wonder why not make this alloc
> > function the same as buddy alloc_pages_node() - return a struct page
> > pointer.
> 
> I'd argue we shouldn't even be returning struct page here, do many
> places even use the struct page? What for?

I just suggested it for similarity with alloc_pages_node(). It can be
made better indeed.

> Exposing struct page to places that just want a kernel addr means they
> have to call page_address and we are back to the highmem weirdness.

dma-buf system heap needs struct page for scatterlist, so we need the
virt_to_page() conversion if we return a VA.

> > >  static void its_free_pages(void *addr, unsigned int order)
> > >  {
> > > -	/*
> > > -	 * If the memory cannot be encrypted again then we must leak the pages.
> > > -	 * set_memory_encrypted() will already have WARNed.
> > > -	 */
> > > -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
> > > +	struct cc_shared_layout layout;
> > > +	struct cc_shared_pages mem;
> > > +
> > > +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
> > >  		return;
> > > -	free_pages((unsigned long)addr, order);
> > > +
> > > +	mem.page = virt_to_page(addr);
> > > +	mem.shared_size = layout.shared_size;
> > > +	free_cc_shared_pages(&mem);
> > >  }
> > 
> > Here it gets weird and I don't see why we can't have just a buddy-like
> > interface. The kernel-doc for alloc says that shared_size must be
> > retained for the corresponding free but without reading the source code,
> > you can't tell that cc_shared_calc_layout() gives you the same
> > shared_size populated by alloc. We have a similar pattern in dma-buf but
> > using the compound page order.
> 
> This makes sense, we should not be passing size to a free function,
> make a compount page/high order folio instead if the API is going to
> be struct page based.
> 
> > We can get rid of layout and mem structures (or at least not as
> > part of the API). Of course, this assumes that the shared granule size
> > remains constant for a guest's lifetime but I don't think that's a
> > problem.
> 
> It should be encoded in the struct page meta data, as the order.

I agree.

> > Was there a caller you had in mind that needs the common allocator to
> > share less than the whole buddy block?
> 
> If we want this it definitely needs to be a void * based API not
> struct page one though..

For whole-block sharing, either a VA or a folio works for me. If the
allocator takes an order, the requested size and the sharing granule are
both powers of two. Rounding up to the granule already gives a valid
buddy block size, so there’s no need for a separate shared_size.

-- 
Catalin

