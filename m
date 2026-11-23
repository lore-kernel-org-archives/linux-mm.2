Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DE8B606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=mFRdk6B4
Received: by kanga.kvack.org (Postfix)
	id 2F5C96B05B8; Mon, 23 Nov 2026 10:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6F46B05B9; Mon, 23 Nov 2026 10:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195CF6B05BA; Mon, 23 Nov 2026 10:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE92A6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:00:47 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A6A6808A6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:00:47 +0000 (UTC)
X-FDA: 85466695734.28.518E1B8
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2E7DA4001B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:00:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=mFRdk6B4;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446045;
	b=O2MFJmza171az2MvCl8cUvukVUtQiiA5h/HXyCDncCkGJJbruYzZQF4/qznjkbXef/P65p
	GZbOu+N51nErJyCDx0wNDloRH5JKNfzoHlsZLuUi4sbVsgiRRjZRjkC+7wPhvVUFAIZYr9
	9kljKxcK6QeS/SGAyv6Jkfzg6hn+ImU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
	b=vIWRvxz7VkH2fGn2VwfAciuj6flTLTLGYInxpINoU/nn23EmtYN6fKPfV16NqOXaot7P2r
	cBWrdSDxUgc1Q8fjoGTKKrSnU/RMAlt7RUKQnze2fhghlMH8ZjaBsGgQvmoNWYW/0cT1OG
	L5Mc9v5fhFD6SRmo7t2/uFOVmAKd1xA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=mFRdk6B4;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.43 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9213f004a14so41548756d6.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795446044; x=1796050844; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
        b=mFRdk6B4KEluah3BQEd+Wd9A3JV2uB/yq8PUyqzTEe+XcougL0pCxA5pPZiDhWXULm
         tkTZRRbc30JGNavaryp+ez1U8uoe4vQe8aqDrsivs/slsYnca85pi8NXxyUx3ZlU3g26
         s7IOSwINbYeu98yhh72DXl7YbWIB6kSZj7sg4xrTsp5DMZ40Mu+cw+MyZ1KvqmJiJLq/
         9oGfOZ1F2KRG4cb7MGJumFVFFk52PLIn3cy3NXmBdNyiUwtqG8vR0IcMe3XNqS0Re9EN
         ceCWONhOeeDeU++uvbdWh4so7bgFf07jcntv1sVXMN57lVyjsV8qhwvu5lrW7qaSTeKD
         7EXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795446044; x=1796050844;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
        b=phHo2H+5jh81hozGuCV9tvepgwzBBxNj2IRtGBcbjqHjpyZzCHT4Pf6EtbYeK8HoMl
         vtYGWUjnBfTSeYWmodaYVc+fwRnWn/gm/KhlN2MeUNU+oVwAkJM7p8eUNdTGnHW4LxSQ
         xTThakwRAyvY9TXCCbLobQwcS4C4lqphZ9bd6YvWbVjx0guVWh9ot5MhHroS7CkOM8KE
         nvBqF7oKv+ykyekbmNz1VyFBxmYRwSuCP45OOkLwtzC3xDS+kpHXwsah4BMNLRuhIM9A
         7IasmW6iQpYMyDVM/DWJhADmh8KCgwAFywmoX54PaIdf3DM6peuviG25TZF96SqCNmFg
         WVHA==
X-Forwarded-Encrypted: i=1; AL+hErEMxoBMlIfep3PSxRYJh78f9YOHLwUWBBZhSLIc6mmbceD/tdmu/djXocE5LAuQRy3CSqDExVU3Dw==@kvack.org
X-Gm-Message-State: APuU4Z9cjvEheL4JPqBS81tB0aXPeCQR4f98GyIa9hXPdhfICKXNpmDV
	p8JTdWb6tUosL+nvG3EjY8IlXSLH2JHvkBUqCw7N8XwZcPewWU1zWzrJkE57QWqSs6I=
X-Gm-Gg: AZFdTZfbA4eomoeiZVmkesJ4yTvmnMlxKXJGq+YKipwpsTfr+u4smRAWnAS07msyEN3
	YEBI2blWHbm1iQc31nyM/clwy+8d6t0auG+YQ+0uLO0oP+ylwthmvwY7/L4TqF2hubcEkPVE127
	BbVF4CsIulh/zjB0SGPlM/XqNoJq0SFwY5Yt+cuyeUtdBVgoDZ6XMjGRETk6aUuD0FS1MJjTvMd
	TAyQL8th8+tuYRV6P04dw3KWco6+RcB0cdg6WkbU/nG409p5VICTTM+fPQMv6Lu792V5Kuf8+VN
	TMzSoyPPuJQN5lGHOal0EPewCuld1Qml+wyKGvOgXa4w7nx4hu3HPc8Ant3W7ZP1tk7pxjq/r3k
	yAazZeQIwwZILgmE/e0CxDKjK6wCC8jFL8moNzt2XaKzj3uygn5PtEsFjNgEtfV+UE1yiOC+Oef
	8KUm28XqN9GBCm3ZlM2qmlGYIjL4VBdPcHeK6xwLEmfqYxpepFFWLPBeEG0a0EvldlS/GLfsJ6n
	WAPm9grzA8eTyoUc0+gCSbIfC46FmazHp18pcy9sSNdIWBvhatqR/tfCTXwx281MAXjmsEpyAXz
	DJfkaBivoWSA71muIfBLwbnTn4lGXjGTibyV4qVeBFDqmoEEOmR0IvgCegLhh6HcNyiCNSpFEW1
	WcM8=
X-Received: by 2002:a05:6214:4891:b0:921:27c2:3f89 with SMTP id 6a1803df08f44-92134a3715dmr207386236d6.17.1795446043629;
        Mon, 23 Nov 2026 07:00:43 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a16754sm107600476d6.39.2026.11.23.07.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:00:42 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVVX7-00000000rK9-14j4;
	Mon, 23 Nov 2026 11:00:41 -0400
Date: Mon, 23 Nov 2026 11:00:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
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
Message-ID: <20261123150041.GB179082@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awQd81MwZqi55gf8@arm.com>
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 2E7DA4001B
X-Stat-Signature: xt48g9fojhgce7metd4qu6k1odautsb9
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795446044-498027
X-HE-Meta: U2FsdGVkX1/BQMUqLTpfVZq/eTHQnq3qUWK0hrSrCB3Yap+j7tQVCaPlpyHxL3/IH3tCMYBUqlOK8fpB3Srmx2iP0rtT16n2cItcPgda6UyAPToMfT0cVDg1IWDZeKOBDJa/qO9W23iZls46i0CULEY19AvdNy1QgihXDllWJuh/AuQceJNDXkahnnxuIIVsGXsosyrOTg+QUM/S4LkWqT2HvPb0yQ20jO9UujFfyYKbi0X1IVSxmc0BUoc1g3tck8kIrRsiezxli6aqpgnwEZ0gjRJamdbkd3M37gbXtOc+oMjXBX0H5i6cWsFcpbilqxuxYhSAEZAFOkCKtHfncxd/J+t2v5i5mBv2xogeQmtlA7vURmdfnVG8dToFst1knKxC9eBGs/HANyZLZoOUYRK8a+TsrGzxSpJ9Ex9UVENzCwTRXGD42OkZ1sZfRx3P2eVxHdz62dDFLs9+ceoLJxgZ4ClxnjBq98gDAsv50SZc9wQy6X6G94oUw0oFqbHKM9GX2+Gr72icND1K4s6q4v6p5FbU7b0d02AKE+6dJmHMY9DCICi5HpaBHqHL8lvYLOqlxcgk2bWLsZIptomhdVq7hJHFmQ6Sm+Hs1rxDExYFj+u6FBG3ip/SekVp2HTSsleVI7oSB97AYcsu/LJ5JXKT+DNN3d6x1DwAKnzjrbRv/EwPphzmIvhFs/u1+vd/Zy0qVKgAf9+P+xml4hAWZIRHP+GIoacb21d74WOv0QcPrSqaVrLRIJXOoJTcibsYAdkuS2NoMCNsXToO0WqqCuvMKctdRzTZkOMRbG2gQVIt0nMYKVoCNTqodusEepu1sfJjKYOxrzxsMPs9VCUZSSyi/s0zjDhagH2B6PbiVF2OB2fktY4YQ63RDovUdPEJ9uNIFSCDFiOy8w/1RqXE48sHv94ZAgt5RH0k5nCs74FKdXRZK5p/m/BiZZCIwHPG3V/EdUoimIhVE/wsXtX
 Vc4agWBb
 JB0UluJ2Qr9GDXonqt+qbUUphVUuSK8MLW/sfRAHOLWlXbILvspNE4o0Vsy6yS3pqzAqPEoDsn8PXXweFfrJqfs16H8soQpSVbi3amIooUCGAn5JaZot2tNxeUq04IiVj+cHd3muYFwTGISkTvyD2II5RTMBka1coPCgVWYrvV7FEbcFbdjbZpaddNHdKVPdmCi7cQu4OAYD7eDE5bVqw/F7dWirtlT96HMX2iod/2wL9KsiiTOO9jO8IfmYIkDtgtOM+8PsdkEOVFPF/PGe74VmNUHoI2ngwwULEDrTW60SShrByoAVdlsqHWs/S7vFYohDlNVniNERGD0+WI5qE48uw+rKAoJH9y1uTEymEKRMpe0NA3ri2ivkN6ZOl4I8ZBwzmMvIIEyTlFDnARtoHWPjHMuAcdyFlpIMgEeGooKaRvJOnfsTql5c70mcIGhoP+o1YW+bCrAa9NTRKWrJkfemtfdHsnXz4+uAL+liijUxJghhM9hiSlY4rbF1ujwsjF7Ru+wvSXP1WIiJHlQhNcNWzUdZfynVBINif
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 11:05:23AM +0000, Catalin Marinas wrote:
> > -	/*
> > -	 * If set_memory_decrypted() fails then we don't know what state the
> > -	 * page is in, so we can't free it. Instead we leak it.
> > -	 * set_memory_decrypted() will already have WARNed.
> > -	 */
> > -	if (ret)
> > +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
> > +				       PAGE_SIZE << order, &mem))
> >  		return NULL;
> >  
> > -	return page;
> > +	return mem.page;
> 
> This part is mostly fine but I do wonder why not make this alloc
> function the same as buddy alloc_pages_node() - return a struct page
> pointer.

I'd argue we shouldn't even be returning struct page here, do many
places even use the struct page? What for?

Exposing struct page to places that just want a kernel addr means they
have to call page_address and we are back to the highmem weirdness.

> >  static void its_free_pages(void *addr, unsigned int order)
> >  {
> > -	/*
> > -	 * If the memory cannot be encrypted again then we must leak the pages.
> > -	 * set_memory_encrypted() will already have WARNed.
> > -	 */
> > -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
> > +	struct cc_shared_layout layout;
> > +	struct cc_shared_pages mem;
> > +
> > +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
> >  		return;
> > -	free_pages((unsigned long)addr, order);
> > +
> > +	mem.page = virt_to_page(addr);
> > +	mem.shared_size = layout.shared_size;
> > +	free_cc_shared_pages(&mem);
> >  }
> 
> Here it gets weird and I don't see why we can't have just a buddy-like
> interface. The kernel-doc for alloc says that shared_size must be
> retained for the corresponding free but without reading the source code,
> you can't tell that cc_shared_calc_layout() gives you the same
> shared_size populated by alloc. We have a similar pattern in dma-buf but
> using the compound page order.

This makes sense, we should not be passing size to a free function,
make a compount page/high order folio instead if the API is going to
be struct page based.

> We can get rid of layout and mem structures (or at least not as
> part of the API). Of course, this assumes that the shared granule size
> remains constant for a guest's lifetime but I don't think that's a
> problem.

It should be encoded in the struct page meta data, as the order.

> Was there a caller you had in mind that needs the common allocator to
> share less than the whole buddy block?

If we want this it definitely needs to be a void * based API not
struct page one though..

Jason

