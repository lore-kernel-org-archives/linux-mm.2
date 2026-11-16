Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28F2606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z0M2J+UM
Received: by kanga.kvack.org (Postfix)
	id A2DC96B00EF; Mon, 16 Nov 2026 12:22:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DF486B05B1; Mon, 16 Nov 2026 12:22:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5246B05B2; Mon, 16 Nov 2026 12:22:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 71F6B6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:22:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04A9AA01C8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:22:00 +0000 (UTC)
X-FDA: 85441650042.17.49150C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 60C1E4000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:21:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0M2J+UM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794849719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fVsGbQYRHAeRgv/EQToJrUh3lGrfBZ4ksTLjRrhgvYU=;
	b=2ZzDS6Hzh5Qlr5670tsTNc2Pe4jqdWrLdjqBJ2dte+zJ/G66IXYBeIVWyBUoOT0FLBHPFT
	ey7Ss0tMUV4o8jQkMSDHvlRMgCga+w6oRADKYGwKNEK72KeVypOhVx/x7Tc+6Z0hzO13lF
	QqZ95amIbu8yNDWqBRezNLi9Ffq1FlI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0M2J+UM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794849719;
	b=1micO/jB4Dd9Chg73EuST3qK+GAv2++R24UMrs9sgY4+xvZ1hEpe1uEVn2AmTbEkWIfJ6U
	9zucoCSAfEQoCrKhc1mm6FZhA0PqshwtNh9L+sZN8csWPnGSKg+KzyjvJG77fMIcecQ9LU
	GRQfuEGxgz88X5f/yK9Xj5pdxslFfEU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E8F6C62529;
	Mon, 16 Nov 2026 17:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC131F000C9;
	Mon, 16 Nov 2026 17:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794849718;
	bh=fVsGbQYRHAeRgv/EQToJrUh3lGrfBZ4ksTLjRrhgvYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z0M2J+UM+J2X+m27UF/uGbLb5uGD5sVmGzVUXG8X7hI3x9Ukwm0nej1IfIbe+q+q9
	 4reI26TAGmspDfN1J/V4c7ZyHcnC6GigZMvmkQK1n5UiMB53RWR4vw8YCPo2RwRLt4
	 Jg3gUQAj4ldsw67y/c6ttu5ojccsDuWESHtxyftNAlad9Vu+fhiINNCwb01QivffAQ
	 JePUkTfZFHNdDVnAF3Yl14pC7gq3lYTqHNrr/VXu3l+7OKKRsJPGvhyDKiDcpf7mxo
	 bdEitk8xYizikjKUBgfGfwp2FWl2Y7EUh/LuegQWHpNecE4wmLbQLywq3Kr8eXGo3+
	 GS+kXaLTtMJjQ==
Date: Mon, 16 Nov 2026 17:21:49 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: Re: [PATCH 2/3] mm/memory: do not report OOM if insert_pfn() races a
 huge fault
Message-ID: <avs6WWOurjIN-trm@gremlin>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-2-537605643f6f@kernel.org>
 <998b00e3-bde9-450c-b50b-069e65d00c49@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998b00e3-bde9-450c-b50b-069e65d00c49@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60C1E4000E
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7jy39otd1qmmdbtxhezpk1wzee4ojicm
X-Rspam-User: 
X-HE-Tag: 1794849719-149286
X-HE-Meta: U2FsdGVkX191/UBcTFALbJB5Hy3xgfuvH5iIi7tChSQpVmg0VZPsPX5LKXw+qsth61Co9RqnxGzU/aBc2GNfgV9bEkjJ8mp9uo/Yklt28bVhOlaVe4Mh/aZKNGTxTPklRdWLxBzhNAMqviY4u7uLF3fBXAjJKr5CHAVwd9oxy1u49RI0azSX02MjOQrRNa02WhoD+O1xoL2APx9k1e6LdbXBEtTHzkGWYxXEqCy+mVBj88MfZBrYQ7I4FOX2YPs14DZwIo97/hE9CmkNfeVxOBvGpciW7KF67SlJnu4+9rzaDFDeWVF8MU59m3vG/n64u+tXAF6pA7fAK+F3EE8YF/6plMEv9A3/0CP9n4+1p0hDCVTubaNiDC/x1uewGf8MGxx4jW8NKnVmSZC9ANmjh/3Pm+epFlgmiEUEo0DL+qIZ9Ig6no1SnJWbjwI7PNQPQsEhot0GfKdFhNrLIIf62HetC4I/PK3Uip2V1vQoDQr+yZfCyGs/mhk5cgj2FrtSzDmJ8Vn0sJ9rd/5OgpX/ANE2EHOoxa1xtPvScHJxtvYoYsCPu5hK1a+tmxNY4ctjJ/AYDbjAjx3pNZKINqa+ON29ewhUCK/7AoPDZ1id15Pacpa4QOafQ3HuA4+96AkKk+rgonVdkwc9khgKlYt4bVGJ28H1VgS1cbNz380M6+QgZ3I+tmAaWlXLSpRM4NCEVkipVwX0QXtCImciEzNZkA1gIZJuCZVlLblwck31qhoe3aQjYBnCRB89PakvlyAlYFGuylII9gLC8dgtX8sp8JW5dmYWKk04iW51lJ5tfWDVTeo0WPlcrXZnulAxd8idKXnm0p5slHv8QMHWjl3gdUHXHrVk5QeSztWMrq0BEIM+ymvPy9ZBL187HEtIFe9mSOOlBbQPOy9V49n1sar1EjRuZ3v/wwU+x4Wvb+BSCE8BCymiYr36afW1NDpXegwM5zZcSUH0sQnKJaKc3v5
 tOZS6t7T
 pBuTjVWEUjyimOsVm2rPW0UVXO4UPtmwoKk+7jQZA9WvHD9TV7FKT8GCfRKYU8KMsOVzYC0jjjD+VafzBjhao023lgA6nv+W+YaWCOoYjit36eM0eS1XlLBON8eygNkhXIUd2ixy9YkI9xzX/B+D3Y0/RbNwzi7DLXYUtKmkf+9KO8RKkK0ZZP2leCGwbX5WFPcBqedW7lUT8XXl5d0DUIvTRYzLUHZWAQIrMdRKVBYCdn/ZmUlxygjiEOXSwmuweN43BSP+m5wv57AlaEQ1VBCndyU/fz1OqC/0p94CTZIcvmabQFAmXawzAgmQmH4sWrQ/7Yg5c6Gc7M2Lq/L2a+HX161Bds5fC3Q+hR8CuCFU2EUFRmqfdOmM95g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:59:35PM +0100, David Hildenbrand (Arm) wrote:
> On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
> > From: Eliav Farber <farbere@amazon.com>
> >
> > A driver that implements both ->fault and ->huge_fault must anticipate
> > concurrent use of both.
> >
> > This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> > concurrent with faulting, as that only holds the mmap write lock and thus
> > does not exclude faulting threads stabilised by VMA lock.
> >
> > This is not currently safely handled by insert_pfn(), however, which
> > obtains its PTE entry via get_locked_pte(), and treats a NULL return value
> > as an allocation failure, returning VM_FAULT_OOM.
> >
> > The issue is that get_locked_pte() also returns NULL if the PMD entry is
> > not a page table which can happen if a concurrent huge fault installs a
> > huge PMD entry between __handle_mm_fault() observing the PMD entry to be
> > empty and insert_pfn() being invoked.
> >
> > This can result in VM_FAULT_OOM being reported incorrectly.
> >
> > Address this by proactively checking whether a page table allocation
> > actually failed, and returning VM_FAULT_NOPAGE if the NULL indicates that
> > we were raced instead.
> >
> > The same assumption is made in insert_page(), however only DAX implements
> > ->huge_fault and can reach it, and it serialises faults of different orders
> > with its own mapping entry lock, so it does not require a change.
> >
> > Target the commit introducing the first driver able to do this.
> >
> > Link: https://lore.kernel.org/all/20261112051440.16140-3-farbere@amazon.com/
> > Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> > Signed-off-by: Eliav Farber <farbere@amazon.com>
> > [ ljs: rewrote commit message, trimmed comment ]
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/memory.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index e03110906aa8..cff39eccfd42 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -2866,10 +2866,17 @@ static vm_fault_t insert_pfn(struct vm_area_struct *vma, unsigned long addr,
> >  	struct mm_struct *mm = vma->vm_mm;
> >  	pte_t *pte, entry;
> >  	spinlock_t *ptl;
> > +	pmd_t *pmd;
> >
> > -	pte = get_locked_pte(mm, addr, &ptl);
> > -	if (!pte)
> > +	pmd = walk_to_pmd(mm, addr);
> > +	if (!pmd)
> >  		return VM_FAULT_OOM;
> > +	if (pte_alloc(mm, pmd))
> > +		return VM_FAULT_OOM;
> > +	/* We may have raced a huge fault, if so let the fault be retried. */
> > +	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> > +	if (!pte)
> > +		return VM_FAULT_NOPAGE;
>
> Same question, what if we would stumble over a PUD entry, how would we handle
> that today? I'd assume we'd also want to return VM_FAULT_NOPAGE instead of
> VM_FAULT_OOM.

It can't for similar reasons.

Actually changing this would require changing walk_to_pmd() a fair bit so it can
distinguish a failure to allocate from that, and I'm not sure it's worth doing
that at this point, better as follow-up?

>
>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

