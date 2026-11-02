Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DC7C60A2602
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=h1MBcrPN
Received: by kanga.kvack.org (Postfix)
	id 983116B05BD; Mon,  2 Nov 2026 07:58:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934256B05BE; Mon,  2 Nov 2026 07:58:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849486B05BF; Mon,  2 Nov 2026 07:58:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 61F5E6B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:58:35 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9A55120CBE
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:58:34 +0000 (UTC)
X-FDA: 85390182948.01.ED7FF28
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id CCAEE40002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:58:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h1MBcrPN;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793624313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A55LxL5rZiBQoPqsIgU4SUYaOdIDejVyKaA5JG5v21k=;
	b=gqyTNdcH+AFpKDxkeACuP0BwJJ8Szwm7lL73yvHvYqx1qLtXACa629kLNche+9VBfDc/j3
	sM049X9b2YCrRmsqLq9AzcxtRpv7d+k1ZQ3kRqnPcvpaadbGOZrjcFX4hGCc2fPkmgEOBm
	KvuqlN6QPUir0VF+czrEdsQB/TazdJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793624313;
	b=1Zz2a64Q4QxUM5bsSX0Y+b8OvMXycqflBwOQ6stEBh3yiqgwGjp1mH5WtADb3J4fr6PF6L
	sC1K91JDCYpv/Ll20q3Ay2oxzw6uI3tDqsg6auS7NiZgLa2EOL+fmTTMnA9aWXGzUyaOIw
	Jbm78lMD2wsCNiZ+mkuCRxzAR7XwyB8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=h1MBcrPN;
	spf=pass (imf07.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4C131FC4;
	Mon,  2 Nov 2026 04:58:28 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 772563F59E;
	Mon,  2 Nov 2026 04:58:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793624311; bh=OpqLpqu6JUVcMgPsx1gdtS+Nt5xvn0q+76+HatrXhPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h1MBcrPNpf/gqbCTydTx1HH/aqR39F9ICnrFOTaBzrxi/PNUb/qQjkpmpDBfiEH18
	 dSUU5plg+8iefp0dPwVzh6lbFiXlCTU98ZBgN3qqAkNWbnmuzkezZy/Cx/hThxkk9m
	 VzLeB39Jt5QIsksKnu3RMx5NnZes0G0Y5R22PzxY=
Date: Mon, 2 Nov 2026 12:58:26 +0000
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>
Subject: Re: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
Message-ID: <auiI8jzumVHmmSV9@e129823.arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
 <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85c4a87b-2c8b-4ef5-bb30-6518080f8be0@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CCAEE40002
X-Stat-Signature: ddyob4mcqhoam78ahio4ssc4czqoog4m
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793624312-885524
X-HE-Meta: U2FsdGVkX18v3f7o1hlFAaqF7sDermkBam+JwRbIXlM+L6MoQd2Woqhh0XkDsn0bbtbpTr0xs5DLkOm+Dbr7aFpgI/o2B6hE541rQpB6rrMOyWZMGZ/TyyY5AJPuxalYMe1NB9RpkIJ0u/PGV7rC9Mmy38PUGVW+fvK1WglGowfEbjbtyjJOKuHeL9ggGaETu1NYaCmYRIOB1gJNdgL8RQrZO/MVHbM0hknEi0aOl/X4bC7sgw1xkH1wIL+bK5STm8rTMA0G7KJfWls10hhQOgt7CHxLNkFihFEKXFQMdlUI7s0cNkE5ZjTnaxiyhhcdAMxCji6JXMIkT4aS8cvv9li7zetStqREA1pK7n0bReWmFOYcult2CucC/ZoG3FuS9OGKxglMbRATzK8bvVh37eWWH9pTnrgjUMHXPx+Jrc7qAwtFnWtbQTQ9wnpJjmVgNP662gUqzQHqfoyiw/W/jpgCN+3TSXRHLf3qkI6f0NmS9IPqTrLpTTsAGE4JUEvVHn1UGWf0hq4xeH7oKrvhoqr5Hd7u2qCRSMSi7I2ISGrTTR0K5o7RVqPerXSS8PmHJ4WOad53hQNHIC6wu01j+LVNDivA04TcPH0Ioo+lLmq47UTSrwU1gtANgjsC26h37XPvdHxjP1ed6g+xgI3wyoFWDQz2MOYRN+tdpFJvskX8PsxmU/M4P5TfaHQYzb8CBHngtPM0b6kzs4ttlupBPmmuH7Omy98Gh+KpZ8yByeUaGbWUwwVMRhxJL5VzI0vQzUBYq4MAAZ1CYsucrCRaZBmbftWvEJuUeQzQWEjSYvIG7Ra+60oTz994KLLT4LYIfci+4G3lpDXRUT0TDd/nddo1UXX4blr38KiPDMsftJeswgCIfxl90eRY7e0idzTs6NlmxbK4zyCxVRNBeKU2qkIsvnVcKNNVhGY3Co9MCP5adIL28rS/Y/MvnFxEI6QL8XHX7n+x9X71YH3D+jT
 RUnnmYqg
 26ycpBYzUBeYpB9l9CdZtUcxESlifIc+e654cd2nIl7TR23QYeIqjIQurfIj+sOvHEN5tIpeRhpGQnTBogEiK3tgDDIcGH7Hd8JD518etBZuwSRHOeNv3fL2f2KOeXu7drrJzKEY+xW05v5Fh9JkE6fGbGfd/hdXh+tnhvwtr2en6gsOthPF5BbdcTLO/wtztZOSJNePJwsLeH0rBaRAYp7+gulWJifv9X0kW9d/uFzTGz/t0+g8PYN61yYtpoo7VkA3OmlrkB6ysjWvDr4gHpAE1C7Iw6hJf+CqUj/QMpcJ4WM9s7plJlT7AjAmV8RMuV0qr3+CL2PQf0LhBGYie4qOSAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 01:10:21PM +0100, David Hildenbrand (Arm) wrote:
> On 11/2/26 12:30, Yeoreum Yun wrote:
> > In x86, shadow stack PTE is marked with PAGE_RW=0 and PAGE_DIRTY=1.
> > If the shadow stack pte entry is consequence with the read-only pte
> > like PAGE_RW=0 and PAGE_DIRTY=0, folio_pte_batch_flags()
> > with FPB_RESPECT_WRITE without FPB_RESPECT_DIRTY considers both are
> > the same.
> > 
> > To address this, save the first pte's writable and compare subsequence
> > pte's writablity with pte_write() when FPB_RESPECT_WRITE is set
> > without FPB_RESPECT_DIRTY.
> 
> 
> I think this should be patch #1 and likely carry a Fixes: tag.

I see. I'll move and add Fixes tag.

> 
> I think we can already create an inconsistency by using a mixture of
> 
> * MADV_HUGEPAGE (overwrite for nohugepage for shadow stack)
> * MADV_DONTFORK + fork() + MADV_DOFORK
> * FPB_RESPECT_WRITE users
> 
> Not that it would matter in practice.

True. but it's possible anyway... without alternative suggestion.

> 
> > 
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  mm/internal.h | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 35016b1afc8bf..b4d0df4c35adf 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -418,7 +418,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
> >  		struct vm_area_struct *vma, pte_t *ptep, pte_t *ptentp,
> >  		unsigned int max_nr, fpb_t flags)
> >  {
> > -	bool any_writable = false, any_young = false, any_dirty = false;
> > +	bool any_writable = false, any_young = false, any_dirty = false, writable;
> >  	pte_t expected_pte, pte = *ptentp;
> >  	unsigned int nr, cur_nr;
> >  
> > @@ -438,6 +438,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
> >  
> >  	nr = pte_batch_hint(ptep, pte);
> >  	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
> > +	writable = !!pte_write(pte);
> >  	ptep = ptep + nr;
> >  
> >  	while (nr < max_nr) {
> > @@ -446,6 +447,16 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
> >  		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
> >  			break;
> >  
> > +		/*
> > +		 * x86 shadow-stack PTEs encode writability as RW=0, DIRTY=1.
> > +		 * Without FPB_RESPECT_DIRTY, __pte_batch_clear_ignored()
> > +		 * considers shadow-stack PTE as the same with subsequent
> > +		 * ordinary read-only PTEs. Therefore, check whether pte writable.
> > +		 */
> 
> That information doesn't really belong in here in that detail level.
> "/* pte_mkclean() can remove the writable bit in some cases. */"
> 

I see. I'll change with simple as you suggest.

> > +		if (unlikely((flags & (FPB_RESPECT_WRITE | FPB_RESPECT_DIRTY)) == FPB_RESPECT_WRITE &&
> > +			     writable != !!pte_write(pte)))
> 
> It might be nicer and more efficient to track if any was readonly/not-writable and
> 
> 	any_unwritable = !pte_write(pte);
> 
> And checking once after the loop.

Sorry. But I couldn't follow. If we accumalate with any_unwritable
and check it out of loop once only, we couldn't properly nr value or
Am I missing something?

> 
> 
> I checked and we cannot really fix x86 without an additional sw bit to remember
> "shadow stack PTE".

Agree.

> 
> As discussed, the simpler alternative would be to just disallow large folios in
> shadow stacks entirely for now, given that vm_mmap_shadow_stack() already
> disables large folios explicitly.
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4b71d010b2aff..9a2dc90ef9690 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -367,6 +367,9 @@ int hugepage_madvise(struct vm_area_struct *vma,
>  {
>         switch (advice) {
>         case MADV_HUGEPAGE:
> +               /* PTE batching doesn't work reliably. */
> +               if (vma_test_single_mask(vma, VMA_SHADOW_STACK))
> +                       break;
>                 *vm_flags &= ~VM_NOHUGEPAGE;
>                 *vm_flags |= VM_HUGEPAGE;
>                 break;
> 

Yeap. once we do this, we don't need to this fix patch anyway.
But I don't know whether there is practical case changing the
VMA_SHADOW_STACK with huge though it is initailised with NOHUGE.

> -- 
> Cheers,
> 
> David

-- 
Sincerely,
Yeoreum Yun

