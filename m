Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C2B60A6F50
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Vibe2WIA
Received: by kanga.kvack.org (Postfix)
	id 47F656B05B9; Fri, 13 Nov 2026 11:19:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4083A6B05BA; Fri, 13 Nov 2026 11:19:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B0406B05BB; Fri, 13 Nov 2026 11:19:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3A1D6B05B9
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:18:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84EF74025A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:18:59 +0000 (UTC)
X-FDA: 85430604798.15.6729F29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D0E271C000E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:18:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vibe2WIA;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794586737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gfKCKZttULbLUSYKjLw2rQpWRQy7369BlI6NWLima74=;
	b=PqBgU8r5yivATE4P/MRCLeyQAcc//OSu5KF0bbUtpm1DrtH4W5khIake1U1esG0kskX9Kr
	kPda2yCGTqKEs2zhTOPI/Q03+hKqoQg8Z8HQeOP2J6Wp2lJrv7NnZ0gUHHf9NcEjG/WVOH
	RDj33lznVDgV8IjRBvHOO9abR9GbtTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794586738;
	b=mbIxHAseM5sVWgOiR41SatC8BPKrak3rH/kAQDMncYjKZocPS5wT7uFZUxDw8HTChtwbo4
	KSGx8pnU/pNMfADOiqV274ZWeswTbEErrApDgijjp+i717KRSkK4d/09tvUZH9n6e+N3iV
	3eIMpctLyasw+DYE4LTx5jljAQT/ukg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vibe2WIA;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4972B628B8;
	Fri, 13 Nov 2026 16:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1591F000C7;
	Fri, 13 Nov 2026 16:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794586737;
	bh=gfKCKZttULbLUSYKjLw2rQpWRQy7369BlI6NWLima74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vibe2WIAY0fix0GPxjAhXr5IAODiFtxZhTL6hkbMoPswB8Z/QjgQa5K6AQAOsa4f1
	 e+uAs5WkrJgP7rMWQHuPujIsc8ylsI4yJQOIXwOCjzn1A75l7fNQkw310CvkvijR36
	 lLtjvMZ7B3j36t2y2nTxZ0stUyuupSMR4h+eazWcTCeIke1ypglK7wlYA+z6MPeLxq
	 jHt0ChQ1YqiOkr/PGa9uZ7DIVGvktcDmQXALJWrzvhBOcCr+yhRFiAjzPLO0kMrnmt
	 VJ3C0n4Mh7ykyJb2v9jT9EWTN8wgzzQsjDVToJVInkJ8qbWNeX0JyBA+ptZw78dAkV
	 9x9Cfbut/O4Gw==
Date: Fri, 13 Nov 2026 16:18:47 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Eliav Farber <farbere@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	William Kucharski <william.kucharski@linux.dev>, Vishal Moola <vishal.moola@gmail.com>, 
	Alex Williamson <alex@shazbot.org>, Matthew Wilcox <willy@infradead.org>, 
	Peter Xu <peterx@redhat.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] mm/huge_memory: don't warn when a page table
 blocks a huge pfn insert
Message-ID: <avcsfhWktvKxQlkW@gremlin>
References: <20261112051440.16140-1-farbere@amazon.com>
 <20261112051440.16140-4-farbere@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112051440.16140-4-farbere@amazon.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: xda7zf55ady7wh1nuk4mh3pqxmqrdjnm
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D0E271C000E
X-Rspam-User: 
X-HE-Tag: 1794586737-798578
X-HE-Meta: U2FsdGVkX1/yKlrBpA6sz+o0596IA2YNP3SNNe/LFZ78IqA0hiIdZUcdiHNcGh8H/XfCdt6GPj+nnnADZEZ5gMMQpwfJwpog9e1A/MBjCBFkNbeEPSyOVmbKcTLKW8mpNt9JW4esbJzoYZgRw7A2WujNKaDqD4G4x0sxC/om3WTYbHQTteV3q/15e4tt/XvuvlGaW9JwDw5jYbyyIzAYQ0MxNVtywEvQwB4Lc0rZwDaHnFqTLm7cW5GaIggN8KG6pMGfaT2d9dTnKfo2Th0kkPtxWXVqqHkxoTnglyOnXe1UayWTXoVv+iLp39MpA61ZXUC7CaA9sJwTKRvf/cxz9tmxU7vKxJZL0eGolifbZLmGmhzvCiFC6F0P3QMUTYQIhn8TEjUZr3CdsJmPVNXSjCwVmfGJStkfqy7V0YqIygV4zG8pR8ykiEmZST7lQYRqRC+LxZnxNEjVIJCm/LhNSnCvXXZks2up5R4g06Q5EX13HNCZAAE8knjd7MUhENSBsmiWXdXP3Tb8wsM+lY39ICi5KVgWL74YtCecQACR+RRiAIH9m/m6xh4ELe3Ba2566NrDyIoV9teg+5xqTS1bUo1jBSMaRBRSkuZuR79y4/Jw7FHej0uZRHniMygLRPyxdcXPXeqau7xP+Yd7W+tclweNd3WEBLqsZl1p568pNvBuz2b0p7kEV74pYzIHFeuzzHISbGjhWr5aUmJVw0+zIWYrmmehYfNSokrFb/PapSFci/0vAx0Hg6nWrnmb0DQQaK3aRdQeNOGROBXeBsoWZJBAvuF3/X9J4s7PC0IX1OIW1c3d4bGvDsOsQzCWtP/3Z9WAADIFQrR4JgLbDw1pmU6cnstpxX2nNOkcxEyYl0Ox3oRBWTfelX52xoGx8JiVNzkxpvZZ8qEVevtjB16K/irtnG9Mg40ZT/XWJ/z6K8+K+iPCGswD2IgV8MRY10grHe2AjuwLRNbtsu+E0Lt
 MVk4NaES
 QsdK8HkiOjbhEeHA57xDFt/xbK8Z4pTeo9e351G6nhfH0YeakfytfbiMzlA5GUvL2SS/OBEgj6OEzZ1Tj3HRgzwL/3nYCmFliNZCyR0mseQXj80HYmelbp4oUOzbyxZ7/7kCR4uNVZLDvNbQcb6dg2ZfntmjdEBPMMJhASJD2xpL8suzQWYcmO+PXmMmEn1k5t/yJaEnxJz/FWIlD3Jn9hmtTMSXF9yjLCzj4w98O2ZWMqlPhI10/QkkRv1PqevaIPyqDW1xGTCvQDInrAh432TM89uiHoNS8zdcH80Wqq2AjSbvyitj8RawQjtEi2cQ7UfoUvMRxxj++pv5zl253EuNBAc8dvGFian95bMptjj7x16I93t7s+RVBdGH2kSatF/EbJM4WfLdtXP0Gma+foPMSOpdLKZdC9zyUCA4Ez0wDD+icINTZiSxmJsI4FbG4sxZUWL38NH2G6xw9qT68FCc/CqvKzGcfU9+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

TL;DR is I feel like maybe I need to take this over as I'm not confident
you understand this...

On Thu, Nov 12, 2026 at 05:14:39AM +0000, Eliav Farber wrote:
> insert_pmd() and insert_pud() treat a non-empty entry at their own level

Non-empty reads quite strangely. I'd say present but non-present !=
!pmd_none().

And the code is just... so terrible.

It seems to assume that softleaves don't exist so don't bother to care
about that, for one.

I'm not sure if this fix is sufficient, actually.

> as a leaf and compare its PFN against the one being inserted. A page
> table installed by a concurrent order-0 fault also makes the entry
> non-empty, and pmd_pfn()/pud_pfn() then report the PFN of that table,
> which never matches. insert_pmd() warns unless the entry is the huge
> zero PMD, and insert_pud() warns on any mismatch.
>
> A VM_PFNMAP mapping with both ->fault and ->huge_fault can produce the

Please refer to non-deprecated VMA flags in new code.

> mixed orders: an order-0 fault installs a page table over an address

'the mixed orders'? What does that mean?

> while a concurrent huge fault on the same address reaches insert_pmd().
> Changing an mm's THP policy while another thread faults the same PMD,
> for example with prctl(PR_SET_THP_DISABLE), is enough to do it.

OK that's useful information. Terrible.

I wonder if actually there are other bugs that will surface because this
takes the mmap write lock but concurrent faults are permitted.

Maybe we need to make PR_SET_THP_DISABLE take every single VMA's write lock
in the mm first...

Even that is dubious as new VMAs can come into existence while you do that
:))

Ah well. I guess correct thing is to handle races like this as best we can.

>
> Compare the PFN only for a leaf entry. A page table is not an error, so
> take the existing out_unlock path, which returns VM_FAULT_NOPAGE and
> lets the access refault onto the smaller entry.

Sorry this paragraph is just word salad LLM-ish code-as-prose, delete it.

This commit message is really poor - it's too long, and what it goes into
detail about is mostly useless.

Pare it down into a form that demonstrates understanding of the page fault
code. Make the actual explainy bit as small as possible.

And you haven't answered key questions:

- What real-world workload were you doing when you encountered this?

- Or was it code inspection? Or was it an LLM? Assisted-by might be gone
  but you are strongly encouraged to explain this even if below the --- in
  the patch...

- What are the actual runtime implications for users?

- Why did you decide to not do anything about the other flaws here?

- What parts of the kernel are actually vulnerable to this? E.g.
  https://elixir.bootlin.com/linux/v7.3.1/A/ident/vmf_insert_pfn_pmd

Anyway, there's lots of broken stuff here though.

insert_pmd() seems to ignore the fact that PMD softleaves exist. Maybe
that's not possible in this code path... but... I don't see how it's not?

So this just seems terribly broken overall.

>
> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")

A commit message that goes into excruciating detail describing the code I
can literally scroll down and look at, but zero comment on why this fixes
target was chosen.

Presumably the first user that made this possible? I guess? Or no?

Do I as a reviewer have to go figure it out?

Please try to make our lives easier :)

> Signed-off-by: Eliav Farber <farbere@amazon.com>
> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> ---
>  mm/huge_memory.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index eb913acb03b7..052c50dadc48 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1643,6 +1643,14 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
>  		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>  					  fop.pfn;
>
> +		/*
> +		 * A concurrent order-0 fault may have installed a PTE table
> +		 * here, which pmd_pfn() would report as the PFN of the table
> +		 * itself. Only a leaf entry can be compared.
> +		 */

I hate this comment so much.

It's what I see so often from LLM output too... you're going on to say what
_would_ have happened if you _didn't_ do what you just did on the
_assumption_ that reader has zero understanding of page tables and fault
handling, and that the code (of course) will _never_ change.

It's adding nothing.

'Only a leaf entry can be compared' especially... it just reads like an
annotation from somebody/something that doesn't understand page table/fault
handling code.

Anyway delete both please.

> +		if (!pmd_leaf(*pmd))
> +			goto out_unlock;

 * @VM_FAULT_NOPAGE:		->fault installed the pte, not return page

Is this still the correct return value?

I imagine it's effectively saying 'this is not what we expected ah well
carry on'.

But what if it's a softleaf... Presumably it's somehow not possible for it
to be a PMD softleaf entry... but ugh.

The assumption here in the code is so bogus though. One can experience a
concurrent huge fault no?

So:

			if (pmd_pfn(*pmd) != pfn) {
				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
				goto out_unlock;
			}

Is still completely broken isn't it? You could well find a leaf, installed
by a concurrent huge fault handler, and trigger a warning couldn't you?

Or is that somehow prevented?

I also don't get why an existing unexpected entry is totally fine if !write
let's not check anything...

It feels like the real fix is something more substantial.

Maybe better for me to take this over...

> +
>  		if (write) {
>  			if (pmd_pfn(*pmd) != pfn) {
>  				WARN_ON_ONCE(!is_huge_zero_pmd(*pmd));
> @@ -1770,6 +1778,14 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
>  		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
>  					  fop.pfn;
>
> +		/*
> +		 * A concurrent order-0 fault may have installed a PMD table
> +		 * here, which pud_pfn() would report as the PFN of the table
> +		 * itself. Only a leaf entry can be compared.
> +		 */
> +		if (!pud_leaf(*pud))
> +			goto out_unlock;
> +
>  		if (write) {
>  			if (WARN_ON_ONCE(pud_pfn(*pud) != pfn))
>  				goto out_unlock;
> --
> 2.47.3
>

--
Cheers, Lorenzo

