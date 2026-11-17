Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10576606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T+3F7yW0
Received: by kanga.kvack.org (Postfix)
	id DFB006B00EF; Tue, 17 Nov 2026 08:48:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DABAD6B05B0; Tue, 17 Nov 2026 08:48:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC13B6B05B1; Tue, 17 Nov 2026 08:48:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7AA6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 08:48:30 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DACF3160409
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:48:29 +0000 (UTC)
X-FDA: 85444740738.05.6405C1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3993018000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 13:48:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+3F7yW0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794923308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M6VZ7CYm+YVVdzMSRV4Ww9IA3aFQKKqL1aLxREeXniA=;
	b=p+GX5C5kly1Cu7tF3D8jpRQ+zjyBUJYZqUpufdH3cQx9x9M5s7uIftrxFg2CJcMyoq8Bc4
	AkjelYJjKpHtxKFEazMseBe8U8evTFC2sEmFctAc/bLq+L2BLthNu+HxyAuhpzpH4G01wG
	PwB/BzEHXylrIJZZOj5r/5H9ndH9ki4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T+3F7yW0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794923308;
	b=nq69DWzY5aqLyog0QMhvt32b1hgBvdIXuVj01yi6Y7meCwk3J2ifBNEoODlpEAjIDnpzS/
	xzWxtMwq58qKFj+o32J+6fMxpHTX5Ih2v8qkCio9RdZWCijPT3qKOnmWtMSKcVFyUht0Oe
	7bCnd5jhqHj2a6jKC/Zv8IAygl07E8k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69B8C45BB7;
	Tue, 17 Nov 2026 13:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3DF01F000C5;
	Tue, 17 Nov 2026 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794923307;
	bh=M6VZ7CYm+YVVdzMSRV4Ww9IA3aFQKKqL1aLxREeXniA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=T+3F7yW0BNt6KMfaHj/yGXMeR4K2bVB+aAbodU4rPyQ4VzPuuj2Hh5mrLnivJPxk1
	 wQ6OWg3eROScfL6IJQ5k9m1+p2bKFthWj0CGhENWdYUE5g0aRK6tZsm8dsj5Zkt23e
	 6PqvdCv7HcR3UdB3hkJOAeKIV5poO0ldCcKvIULv30JcD+eHURWlM/BeYipWUH5AzB
	 WIqq3HNKw5ReZoKiTay09O8/AIAJxeTouYXVCxY0aejIev/QA9S5aNR0dhL7WW28Hg
	 eMLh63MYL9PpSyb50HZZ5HEyfiiiXkAnR1OGlXOlFD2mFODzo8UieNeUxoL/W5zf/L
	 tAS/3pp73j/2g==
Date: Tue, 17 Nov 2026 13:48:19 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Christoph Hellwig <hch@infradead.org>, 
	Yuan-Hao Hsu <aa9736195201@gmail.com>, John Hubbard <jhubbard@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v5 5/8] mm/gup: break out gup_lookup_pte() helper
Message-ID: <avxXgTBaJkPN6XOh@gremlin>
References: <20261116210127.3837898-1-riel@surriel.com>
 <20261116210127.3837898-6-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116210127.3837898-6-riel@surriel.com>
X-Rspamd-Queue-Id: 3993018000A
X-Rspam-User: 
X-Stat-Signature: 63si47uxcpa1y3auh5tz8xhwf7gu6n86
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794923308-335250
X-HE-Meta: U2FsdGVkX1/wop1Xuh8mVMZp48d7StqwmIGlFp4YbF1kEoqs8VHO2VP2RwxBQBTBzVnxizm9KAMbbdPS5nAhw0ALd65Tqgmpd+jFJn6FpPVRkiI2X7OBlNmOEnoR/s0cWleq2y7eZqHv7IRZJko3cp42ihC3fu0mQfM3B+AWVMkg+v5vJWHobGBpVX5wXryELTidJhg2R2YFtg5g9lgSJiyL/lhhtYF1Usl/AQxyXn7HH5ud8w3aMAw4o11DlBR0FTp42HIsqa9KEF7iMLMJsChrNb3Fa1YvqgJt8mcAubBiItQVP7ukza4Aesl+rlQdHhPhUC+vZVghrALKcb779nbO31v3WjQ8vXvpgsROyZNwAEcjd+/87T6F8kfrILLQMLpxsWBNn2M7jNDI0yDF2K5Da2cc0aTolB2Q5uiPf+q0rsLuNPVNnyOg6ygx6n9+9S/ejvD93jrmoYSdd2t4FRTSIMixT7nQOFcCW042S/poQEFgziJLNF6lmAm5Vnl7kE2DVvs/3xdN6/KJ78AQzdbnxvVdFHRMeB3tMVN06aLus7GDLJLpJe1cS0dhIrzrGwo4jkKNNWktA//7OhoxufSh+S4B4EfghaiWu2Yg7fn0iJKCXfFl4i+Q9Fb51GUhLC2iYUrkP8YfWZWbaSTBRq7MvAj8mY2JRebzJqQX5F6k1HUia5jftvgv+QJbzKxmc9JJTi1KPIfMAj95dZvilsFzy+1WC8QGOoDn6vvardw8EDd37rWq9RB4XEU36jn76hFtjwS8f+zKYKW7ZeT1HlEkAVvUI6XHv9HSky11wEU5i3lfmF/hZ60iIwYz4x2SYotYzgL7WyDw1cr190SoWx50qRsS3odIrkztrkCkk9kuHatTIZ99tzjOzgz9n915p6WQogPEuWuhUgynR6RHGtnhduTFvlkmQgiEnyrReMaaYiakLGrklGgPp12T+cmbCU358uOhqSjmrQVd8cx
 ioVOwLIz
 YQ2c5X32VmWeE5CZeY9FIgWbfF6qp1wkQpSi+m1kIYZM49buvPCL28GNxJ9wNRyt8slNI83s9WEHTyOXvzQuuB/kr6VWyFMG3L+vNUwYrq0aiAnbayGVlOqx+d36j/MtGOOpycOTUQxtgqt5M2Lk21YAh82MjylymdJ6Px4juQMvVjJ4NTgBTDQSRn7j4XxMH35aOKce6/v1Es826v/o7XwNXmZnK4ZU6ZiwyIYicclLlqzAgNxpiL4ysB5DmQdHou1AOpjbgwWE8YP7OtKI8VhWmWZalSGpzBe9GlEtOOPfIECB+teVx0oLHOLKIL94tICFugWNtgBuBI1hPNbT3OTEtYcen+tiU962xaBOoxcBPEN0vY0sAz3D+JqIM68omC4MF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 04:01:24PM -0500, Rik van Riel wrote:
> follow_page_pte() is 92 lines and does two separate things: work out
> which page a PTE maps, if any, and commit to the page it found. The
> first half reaches the second through five exit paths, two of which
> unwind the PTE lock in different ways.
>
> Split the resolve half into gup_lookup_pte(), which returns the page it
> resolved, NULL when the PTE cannot be followed, or the errno the caller
> must report. follow_page_pte() is left with one unlock and one exit.
>
> no_page_table() can look up the page cache, so the case that needs it is
> recorded and the call made after dropping the PTE lock, as before.
>
> A none PTE still returns before any write check runs, so a FOLL_WRITE
> failure can never reach the recorded call: the caller consults
> no_page_table() for exactly the same PTEs the old code did.
>
> No functional changes intended.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  mm/gup.c | 100 +++++++++++++++++++++++++++++++------------------------
>  1 file changed, 56 insertions(+), 44 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index efb2ad64be80..3aed0bc1c2b4 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -965,74 +965,86 @@ static long gup_grab_fill_folio_pages(struct folio *folio,
>  	return 0;
>  }
>
> -static long follow_page_pte(struct vm_area_struct *vma,
> -		unsigned long address, pmd_t *pmd, unsigned int flags,
> -		struct page **pages)
> +/*
> + * Resolve one present PTE to the page it maps. Returns no page and no error
> + * when the PTE cannot be followed but the caller may fault it in, and a
> + * negative errno when the caller must report the failure.
> + */
> +static long gup_lookup_pte(struct vm_area_struct *vma, unsigned long address,
> +		pte_t *ptep, pte_t pte, unsigned int flags, struct page **pagep)
>  {
> -	struct mm_struct *mm = vma->vm_mm;
> -	struct folio *folio;
>  	struct page *page;
> -	spinlock_t *ptl;
> -	pte_t *ptep, pte;
> -	long ret;
>
> -	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
> -	if (!ptep)
> -		return no_page_table(vma, flags, address);
> -	pte = ptep_get(ptep);
> +	*pagep = NULL;
> +
>  	if (!pte_present(pte))
> -		goto no_page;
> +		return 0;
>  	if (pte_protnone(pte) && !gup_can_follow_protnone(vma, flags))
> -		goto no_page;
> +		return 0;
>
>  	page = vm_normal_page(vma, address, pte);
>
>  	/*
>  	 * We only care about anon pages in can_follow_write_pte().
>  	 */
> -	if ((flags & FOLL_WRITE) &&
> -	    !can_follow_write_pte(pte, page, vma, flags)) {
> -		ret = 0;
> -		goto out;
> -	}
> +	if ((flags & FOLL_WRITE) && !can_follow_write_pte(pte, page, vma, flags))
> +		return 0;
>
>  	if (unlikely(!page)) {
>  		if (flags & FOLL_DUMP) {
>  			/* Avoid special (like zero) pages in core dumps */
> -			ret = -EFAULT;
> -			goto out;
> -		}
> -
> -		if (is_zero_pfn(pte_pfn(pte))) {
> -			page = pte_page(pte);
> -		} else {
> -			ret = follow_pfn_pte(vma, address, ptep, flags);
> -			goto out;
> +			return -EFAULT;
>  		}
> +		if (!is_zero_pfn(pte_pfn(pte)))
> +			return follow_pfn_pte(vma, address, ptep, flags);
> +		page = pte_page(pte);
>  	}
> -	folio = page_folio(page);
>
> -	if (!pte_write(pte) && gup_must_unshare(vma, flags, folio, page)) {
> -		ret = -EMLINK;
> -		goto out;
> -	}
> +	if (!pte_write(pte) &&
> +	    gup_must_unshare(vma, flags, page_folio(page), page))
> +		return -EMLINK;
>
>  	VM_WARN_ON_ONCE_PAGE((flags & FOLL_PIN) && PageAnon(page) &&
>  			     !PageAnonExclusive(page), page);
>
> -	ret = gup_grab_fill_folio_pages(folio, page, 1,
> -			pte_dirty(pte), flags, pages);
> -	if (ret)
> -		goto out;
> -	ret = 1;
> -out:
> +	*pagep = page;
> +	return 0;
> +}
> +
> +static long follow_page_pte(struct vm_area_struct *vma,
> +		unsigned long address, pmd_t *pmd, unsigned int flags,
> +		struct page **pages)
> +{
> +	struct mm_struct *mm = vma->vm_mm;
> +	bool need_no_page_table = false;
> +	struct page *page;
> +	spinlock_t *ptl;
> +	pte_t *ptep, pte;
> +	long ret;
> +
> +	ptep = pte_offset_map_lock(mm, pmd, address, &ptl);
> +	if (!ptep)

OK so this is what happens if there's no PMD entry. Maybe worth a comment?
Especially if you have special handling for the PTE PTL being held below.

> +		return no_page_table(vma, flags, address);
> +	pte = ptep_get(ptep);
> +
> +	ret = gup_lookup_pte(vma, address, ptep, pte, flags, &page);
> +	if (!ret && page) {
> +		ret = gup_grab_fill_folio_pages(page_folio(page), page,
> +						     1, pte_dirty(pte), flags, pages);
> +		if (!ret)
> +			ret = 1;
> +	} else if (!ret && pte_none(pte)) {
> +		/*
> +		 * no_page_table() may look up the page cache, so it cannot run
> +		 * under the PTE lock. A none PTE returns from gup_lookup_pte()
> +		 * before any write check runs, so this is the same call the old
> +		 * code made -- not a new failure mode for FOLL_WRITE.
> +		 */

This feels -- a little -- schloppy ;)

Why are you referencing 'the old code' in a permanent comment for which what
'the old code' means is super unclear?

That's really just not helpful.

'A none PTE returns from gup_lookup_pte() before any write check runs' also
reads weirdly.

I'm also not sure why you're sending a pte_none() PTE to gup_lookup_pte()
anyway + checking for the error again?

	if (pte_none(ptep)) {
		... whatever ...
		goto blah;
	}

It seems silly otherwise.


Also isn't the page cache thing _only_ for hugetlbfs, unless you changed
that? And aren't a number of other callers of no_page_table() also broken?

But in general the comment could be made much clearer:

	/*
	 * If a hugetlb VMA it might access the page cache in no_page_table(),
	 * which cannot be done under the PTL, so defer until it's dropped.
	 */

Or whatever, something human-written like that :)


> +		need_no_page_table = true;

This is set true but not used anywhere? This is dead code no? Am I missing
something?

Patches should be incremental but adding completely useless locals incrementally
seems silly?

> +	}
> +
>  	pte_unmap_unlock(ptep, ptl);
>  	return ret;

I'm guessing you forgot to include the code that works with
need_no_page_table here?

Should it have been:

	if (!ret && need_no_page_table)
		return no_page_table(vma, flags, address);

Perhaps?

I'm not sure any of this is really a cleanup, I'm finding this quite
confusing, actually...

'need_no_page_table' isn't a great name either. Maybe is_none or something?

> -no_page:
> -	pte_unmap_unlock(ptep, ptl);
> -	if (!pte_none(pte))
> -		return 0;
> -	return no_page_table(vma, flags, address);
>  }
>
>  static long follow_pmd_mask(struct vm_area_struct *vma,
> --
> 2.56.0
>

--
Cheers, Lorenzo

