Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 486EFF3C24E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17646B0095; Mon,  9 Mar 2026 09:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9AE86B0096; Mon,  9 Mar 2026 09:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3ED6B0098; Mon,  9 Mar 2026 09:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8ABDB6B0095
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:42:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4371B1B6E5B
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:45 +0000 (UTC)
X-FDA: 84526639890.28.2865BE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6649814000F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:42:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dQnV0/0I";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdLqgkrqeAfJ6Qj1NcjlAT2Fn0qLa5PiGFwuIm6W/I8=;
	b=dEu7iFJTDFcHZDA62VRsuAw5JoBGjfFF7WvDToEdJRANXBbmaDuwmfguwFgcZf8yZ8OPki
	1KUw2Bh/F3o78RKbi1AqREbPKblEEIJ6wGTe5j9pRAbH/C5jwtXkvUm0Wp7xBtkAO7R88+
	VuXThfCEsn8pu+fKaCiIdF+dkWoC3VI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="dQnV0/0I";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063763; a=rsa-sha256;
	cv=none;
	b=vbekN1hUeN+QbL/P+Z+0YsvI2plGcJjNjXVcH6P8ezik2Ew945IkYIFwxcHjj6mKSNsSw+
	zvzFmhq8+CKg9mFTbVZc+B7rG+B1zAJIuhylSadLVK3jWvtOUJMGIlRvy9TIMOabXjPgQz
	GzZG8SIxXIiWcgibjiJhaXtcEdO49AE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6966443410;
	Mon,  9 Mar 2026 13:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF653C2BCB0;
	Mon,  9 Mar 2026 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063762;
	bh=QdLqgkrqeAfJ6Qj1NcjlAT2Fn0qLa5PiGFwuIm6W/I8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dQnV0/0Ib5o0KbD2/Ib4XNlPdDfuU95v07ZdnPKKg/jFgYKnhJQhqIjmKDE6jqoHa
	 UbnrtJYOdfufndzBfXb1qT70GS2hllMwKgjigWNx4X/AmvD8OC015KFUUmWfM896jr
	 wXD1IkVH+s3e1kL5CIa837syBspn675hbIjHowdCIOfapdJc/If84l+T88BRb5Q1/C
	 fHHYCOP92nycWnMvBnifB/KK9hIBMPUEWC6c1NlMCuWDVPTlHFviQ7LzRunEaSUMkn
	 iJr6MSJLjAjFWmO3A7thdciHjEBjfED6vCHJ9FMv7WUeep4AHm6VcjAK/bvyCVE536
	 8QEJ6P5eRDAHw==
Date: Mon, 9 Mar 2026 13:42:35 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v1 0/4] mm: move vma_(kernel|mmu)_pagesize() out of
 hugetlb.c
Message-ID: <9172a09f-f014-4a76-b813-8f0c79fbe2f4@lucifer.local>
References: <20260306101600.57355-1-david@kernel.org>
 <4rzf46kw6hq3b5ivv7cvgyza4yfrvk2shrncytobabxef644nm@wzu2bw63co37>
 <371cf0f7-4b30-4d8c-99e7-ae0543f8be23@lucifer.local>
 <5eae6c52-c3f9-407e-8fb8-01a950b282bf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5eae6c52-c3f9-407e-8fb8-01a950b282bf@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6649814000F
X-Rspamd-Server: rspam08
X-Stat-Signature: 13mm3db59c37u3p37iibh6x9fia669pt
X-HE-Tag: 1773063763-782827
X-HE-Meta: U2FsdGVkX18tyr4ZqHbXt1WQm1ppjn8rNH5dGj3khFv8gwHwizVBPAqlNMGaFV9Ne5iMilOt1YHsEnqXosb3oN7afhZU73vjNn04zvdPsvG6vb3AONU/p8+KYXnwjlqOYV9O2fZpIHZ3yx5GsaIHF0Wl7b9H4HWeQJMdta+VsPGjqg6UpD4++6J2YtDTcjQCYOPaHerXGcm3YKKp8xkio5zVEfZ2I/jD2hCe5CU7gnhjYcHjZGwCDIQ8c0mvBD9F2Fw5ZcNjprcYKTmCjfPFbX9/0GW4wYUGRn46o94gm1KhaDDnrAxUHdxnMrAGZabrrfb+7uhqAJBw+Irid6K4kinx7GIIXbFPW8qx/+bC/oqdNdPAcv0ojpBQb3jTqREonK3c2KPxqJ0xwtX7GXoCQlSf5udW4dCacWBgHY57iWlGxFKQoHILOwRDiqg9j64rvaNwTGMgBT56hzPxQroc0FKOqeY8bn2eCEEOPmlI9pRYqqrRMfRzckdYY6TkuAPEOWuT91cCLH3WIuH+cuWIk4lDBrRcTIP7l+p28ICwNC2aqwu+uVOzZCBCxcYem70uD1/e+LWOTzfmHDH1d9Cy/5BtoF2GW2REqyI0rjPj4RZdtxXNF0W6g8IS4Huq1JztuhGaZMQ+07IG/x4NKvxmWno7v22tnSQRKVMxnkKAwnm5lOKUbnpC+UYz5vbRwsnOkVtMnXjQT7dAXlcrEd6F30Kljz9cqmEEBMyWcoDnC2jVxOWECOojGnZBN2UVtybfFZOkRABypoRfbws7acHe9xqxS49AQlrKDGkOyc0j8Bd+JjcwZwPTXXllWppbqYP4SRswTfgWLsDhXIzIuLmVO8emqXMqfN/EJkbiD/+kKiFpOVk68/8K/DhOF20azhibVQ4WIJv3W+hN3zKebNR01SmOQESYpTOjkoj19Smsu7lziif7GgVHi1TLYgAkcEr9+xvOMQBNJ7dlm1S8jZs
 sroXPyxf
 2ZPD2Q3vhRAmEkK7lNl1T1KpI5b/usCRvM6W0gtq6WVa+iojeI0dwDEFfxfe9yAyexdck8bus3Op+emgyvu+UQviYCliR06d5Mo4Kmznoa7UGsIYWzSnfZddFrf10bsxft430DYjMCWBy4X65jiwW3xWqXk47tJoZ+IUAY9dk8ISRNe36zp0jQHkXTlNKxCfm6LmsbpMZUWjKZTo9JrkpIN6jsYLUc+yVVkt5Ai8zzwKhSc4WnRxd1XM/qOeG8Xo+fhX7yLcW/EVfo+huUPvPXI2e8bAkuQvWKxrYy9Qe9SFpsKP4sLM6oyR4LKXLgphgKxQ3CBBVpxyCqb+cIJOobwDwpMXoXcY2TpuWnLoAPWEcOtFPXJPNqj9jlNoDu03OIvHoSAInPuHjS7NnO1OZ/mnU3JLZ0gnSdRTnU+cye+FSc9iMVGdI/wWo9VuuFoL9Yla6oSaumaokBvUVgjdyJWQsHuu1rLcnAVuaYyBa69d58VZgpBI3w10lLRSoH9iCA6LnTIXsLpmTWOE4tfJLORO3P1kbvper/R8F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:12:50PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 12:19, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Mar 06, 2026 at 11:13:41AM +0000, Pedro Falcato wrote:
> >> On Fri, Mar 06, 2026 at 11:15:56AM +0100, David Hildenbrand (Arm) wrote:
> >>> Looking into vma_(kernel|mmu)_pagesize(), I realized that there is one
> >>> scenario where DAX would not do the right thing when the kernel is
> >>> not compiled with hugetlb support.
> >>>
> >>> Without hugetlb support, vma_(kernel|mmu)_pagesize() will always return
> >>> PAGE_SIZE instead of using the ->pagesize() result provided by dax-device
> >>> code.
> >>>
> >>> Fix that by moving vma_kernel_pagesize() to core MM code, where it belongs.
> >>> I don't think this is stable material, but am not 100% sure.
> >>>
> >>> Also, move vma_mmu_pagesize() while at it. Remove the unnecessary hugetlb.h
> >>> inclusion from KVM code.
> >>>
> >>> Cross-compiled heavily.
> >>>
> >>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> >>> Cc: Nicholas Piggin <npiggin@gmail.com>
> >>> Cc: Michael Ellerman <mpe@ellerman.id.au>
> >>> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> >>> Cc: Muchun Song <muchun.song@linux.dev>
> >>> Cc: Oscar Salvador <osalvador@suse.de>
> >>> Cc: Lorenzo Stoakes <ljs@kernel.org>
> >>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> >>> Cc: Vlastimil Babka <vbabka@kernel.org>
> >>> Cc: Mike Rapoport <rppt@kernel.org>
> >>> Cc: Suren Baghdasaryan <surenb@google.com>
> >>> Cc: Michal Hocko <mhocko@suse.com>
> >>> Cc: Jann Horn <jannh@google.com>
> >>> Cc: Pedro Falcato <pfalcato@suse.de>
> >>> Cc: Paolo Bonzini <pbonzini@redhat.com>
> >>> Cc: Dan Williams <dan.j.williams@intel.com>
> >>
> >> Although we all love less mail, FYI it seems like this didn't work properly
> >> for the patches (no CC's on there).
> >>
> >> Did you try git-email --cc-cover?
> >
> > Yeah I noticed this also :>) Assumed it was a new way of doing things somehow?
> > :P
>
> "--cc-cover" is apparently not the git default on my new machine.
>
> "See, I CCed you, I totally did not try to sneak something in. Oh, I
> messed up my tooling, stupid me ...". :)

;)

Wasn't aware of that option actually, handy!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

