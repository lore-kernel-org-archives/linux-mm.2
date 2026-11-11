Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B1B606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ic+37J/+
Received: by kanga.kvack.org (Postfix)
	id D937B6B00EF; Wed, 11 Nov 2026 13:39:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1D4E6B05B0; Wed, 11 Nov 2026 13:39:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5326B05B1; Wed, 11 Nov 2026 13:39:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4BD6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:39:25 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1680380399
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:39:25 +0000 (UTC)
X-FDA: 85423701090.23.4E605C6
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	by imf20.hostedemail.com (Postfix) with ESMTP id 01AD21C000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:39:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ic+37J/+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794422363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRAIfcX6+TdrX9n5/F+l2/1/bdd3k5f7+8neSB5hSIA=;
	b=VUYvbk5X0fC6dcPSQq/tH79OrUdaWya04DooWDqkGbGMCm92Zi5JCU/QVNhBfjk7T7ZUFj
	F/xBu3FmC3pWZuuUR/Z4h4gTPCAm14ui94FWtGyN4nWPrblCU0WP7a+uwZhAd9nWlVP5Cg
	J8zkYnl2HSIQJECZS5LS3Q8RO43qZA0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ic+37J/+";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794422363;
	b=cNOhrsgcZhhXOQRpUwPjNaE889zxweKdIbF895jaAMw/Fa0rHrN5SWmK7MtY2T2ZFN8bKp
	9Ezk11ChObqXPKEyYts/6kwW74sXyNwXwVCaqiMS26lMrLPdDG/C3CU2bpDEi0c3EDic+R
	W3zLMkgQBbUKx9CEGPcVfsGGbk0phS0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2gpjyCxlXHV0kojP2zZzDz+9fWvH7WUFDk0I4A7ZOo4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794422360; v=1; x=1795027160;
 b=ic+37J/+PMNglcZ4O6GYMCFRlVhoVoVzwDw1G1hNEFe33rP4lI7o2VPyrhiNLm7OMduH99Zc
 JujJ2y9jwJHfRxjzfA45Asz24HLAPqfsgPq6vzdGsKB3a2x/GZ926pdBgKMVm1VWvktKWv30q99
 kPA8m5W8zklVFd9Dd/y9VZOY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 9920d73fa52f55d7;
	Wed, 11 Nov 2026 18:39:20 +0000
X-Mizu-Trace-ID: 9920d73fa52f55d7
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: don't PTE-batch a swap-in over a hardware-poisoned subpage
Date: Wed, 11 Nov 2026 10:39:17 -0800
Message-ID: <20261111183917.1093166-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <avRqaatdOUunxrcZ@gremlin>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 01AD21C000D
X-Stat-Signature: zaqanwd9xox4i5cmspsdyhugn3a4nrbi
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794422362-513187
X-HE-Meta: U2FsdGVkX1+DdbFzzl/eNfi5I9GytUqSmdS69BZXflEphM7512b3fs1xSxo/WmiURzc/O3VU3o1ZnhB3pqnLgW3BdCzlBHoKctB8ikK6vfho2wQoG/0dZpA3drJN53vBldTBdvhN1nQQ7csnTMKxPyRWEJWmeL+uUj8SBDB8NyY3tja6lb1QI0h+9NFcZGXlwcsganTc06vYKlX5sXCcGIK99d4aqnztkthyTG+VHlpTs5t2893YeEZTSIui3fWDHYwMQVPBW0ahrNwxMIXcL50rIBzq0VbngjU5GtNHW4Rk9kI/xWf9yxM0yEUEJZF5FAh3yadC0BajdMTMFkBzANvCFJk0x7kHRNy5owoWBIypNTW93O/9rIThy2ihVQsNhp1aaOsSnlEoK7y5S2iuweTp0R7wCUH7s9hvik0Jk11LE9b2gHklBQUG3Sa6ehlRi74tKVnLDKIcwXFUPzXc009Q0bDSua2jCn5x5cKFjqajiMtIEFE43AHeHWt6g+tSI0Q/CQ+lDyXSoXfXLQflVQ8xIYe35Gc8IgHCmrDKoEOIMzSgicA8DHKxupuPqaKGsqdAbxcyjanUqPKtNj3EX7o4KEdBGn0gzyBpYuzzWxBDD3OhWvNdgr8G5YZ/cyLTGCgEWNhDQz0ADsemXvW8Io5b1abdXobQ0PXZQ/m8k3gUCVi5zWfFBTF0wDiApZvydY9LTDE7v6iTFY4Mu0TkspJk4JDmth5o0uuJWxACOmD+abN5gMMfImfHnSfYtznk0Kcmgb/nVx9ErZm19Xz1BP6BzP2B6G/7Ibd3kb8cyN5R78YDdEK6TpBNDqo4H788onMcYIxquofjRIsJE771sU6PIQimzOJ+P/d2NUfje0YzWa55dLcI1zQLJQJXUJ690tJHcTxguVVBLSwHyX69GTGVgawQag2OO6hiMW97nmzDOS5lKMGjvHK1EVlGsLYQclgqSnaFcDmzlDU/FQ7
 GCJol1y4
 vxqQiFmcWBsKg/haBqcf6AGMhflrw55WRr4icnbe6EnZOcIjcWMbXHl68m8WM5TvTvEv/0kpFiSzl3gGist9w4PrJwEaPas6PfX+efkVj96IwWxeeeueO0A7/iEJ5VD7pgkuP6bzW/t3aawOZfcmxWcxSX0F9JuXs1cj9lSEIx+/as1PKTnKqKNijEpN8c+fx0IOPBxRdl5OQyjAgvXL/u6P2zjt0m6WVb/6fG4mGrO+8K8cvHU1GINsaVH9YaGio3M5z0g8BrZTZYfFvF/FQpkKvkY6wrwteViwWLMMuxxLGDLLR6cuzNWXqNbPyTdRpWOmtayLqWDRY+tw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 13:18:36 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> On Wed, Nov 11, 2026 at 03:38:29AM -0800, Usama Arif wrote:
> > do_swap_page() checks PageHWPoison() on the faulting page, but the
> > large-folio batching path then maps the rest of the folio without looking
> > at the other subpages. A poisoned subpage that is not the one being
> > faulted gets mapped anyway, and the fault that would have reported it
> > never happens.
> >
> > Skip batching for such a folio and let each page take its own fault,
> > where the existing check catches it.
> >
> > Scan the subpages rather than testing the folio-level PG_has_hwpoisoned:
> > memory_failure() sets PageHWPoison() on the subpage first and only sets
> > the folio flag much later, and the bail-outs in between - for example
> > get_hwpoison_page() losing a page lifecycle race - return with the
> > subpage marked and the folio flag never set.
> >
> > Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > ---
> >  mm/internal.h | 15 +++++++++++++++
> >  mm/memory.c   |  4 ++++
> >  2 files changed, 19 insertions(+)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index cd3675c044e0a..e61c02f4019b0 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -28,6 +28,21 @@ struct folio_batch;
> >  int __copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> >  		void *buf, int len, unsigned int gup_flags);
> >
> > +/*
> > + * Check every page of the folio for HWPoison, rather than relying on the
> > + * folio-level PG_has_hwpoisoned, which memory_failure() can leave clear.
> > + */
> > +static inline bool folio_has_any_hwpoisoned_page(const struct folio *folio)
> > +{
> > +	long nr = folio_nr_pages(folio);
> > +	long i;
> > +
> > +	for (i = 0; i < nr; i++)
> > +		if (PageHWPoison(folio_page(folio, i)))
> > +			return true;
> > +	return false;
> > +}
> > +
> >  /* mm/workingset.c */
> >  bool workingset_test_recent(void *shadow, bool file, bool *workingset,
> >  			    bool flush);
> > diff --git a/mm/memory.c b/mm/memory.c
> > index d477a4f986bc8..4b7d456332200 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5158,6 +5158,10 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  		    swap_pte_batch(folio_ptep, nr, folio_pte) != nr)
> >  			goto check_folio;
> >
> > +		/* Let a poisoned subpage take its own fault. */
> > +		if (folio_has_any_hwpoisoned_page(folio))
> > +			goto check_folio;
> > +

Hello Lorenzo,

Thanks for the reviews!

> 
> Hm, isn't scanning every single page in the folio potentially quite costly
> here?  I thought the point of batching was to improve performance overall?

Swapping in requires checking every subpage, so there would be a cost.
I guess trading it off for correctness :(

> 
> It seems broken to have stuff potentially interact with hwpoison but then
> to only set the folio-level flag much later?
> 

PG_has_hwpoisoned lives in the second page, so memory_failure() only
sets it once it holds a folio reference, otherwise it could race with a
THP split. If get_hwpoison_page() can't get a reference,
memory_failure() gives up with only the subpage marked. The comment
above folio_set_has_hwpoisoned() in memory_failure() says that is fine:

  Don't need care about the above error handling paths for
  get_hwpoison_page() since they handle either free page
  or unhandlable page.

But a large folio that is briefly off the LRU, e.g. isolated by
reclaim, takes those paths too and can still be mapped afterwards.

> Also why are we swapping out folios containing hwpoison pages? Shouldn't we
> migrate away from the hwpoison? :) (I'm not really familiar with the hw
> poison stuff)
> 
> 

The error hits a folio that is already in the swap
cache, e.g. while reclaim has it off the LRU to write it out, and
get_hwpoison_page() fails for any folio that is off the LRU. Normally
memory_failure() would split the folio and isolate the bad page (for
an uncorrected error there is nothing to migrate; that is soft
offline). Here it does neither, and the folio stays in the swap cache
with only the subpage marked.

While looking at this I also noticed that the fallback drops a freshly
read (not yet anon) folio from the swap cache and frees it with the
poisoned page in it. We should actually actually also check folio_test_anon()
before checking folio_has_any_hwpoisoned_page().

> >  		page_idx = idx;
> >  		address = folio_start;
> >  		ptep = folio_ptep;
> > --
> > 2.53.0-Meta
> >
> 
> --
> Cheers, Lorenzo
> 

