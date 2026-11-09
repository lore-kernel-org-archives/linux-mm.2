Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 970F6606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 17:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U+p2wwv4
Received: by kanga.kvack.org (Postfix)
	id B09126B05BA; Mon,  9 Nov 2026 12:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9166B05BB; Mon,  9 Nov 2026 12:30:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F5F36B05BC; Mon,  9 Nov 2026 12:30:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 757C06B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:30:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E468120764
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:30:11 +0000 (UTC)
X-FDA: 85416269022.23.7475695
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5599A2000F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 17:30:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+p2wwv4;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794245409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ZMtATJ/UU7bDo4o1x8DtF/SV0R6ntQW02njcbLrqVg=;
	b=XmWVmc4IPb71vam2IC5fGiFaHPJgYWgQRB/hynZIL4K9tKYdYCeSdmWmhRD5wJTl/qX3oq
	BaYimTFQcKlw+vwArPk5hv3AJBspej/4KeJyM1eNrTzNcA+mACoo7OGToV10rqO7YA2k2o
	l88MYsnDDdGI/dxLmhKb3sp9Xnp0Xvw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794245409;
	b=R7d1wkY0regy9XqVlF/czf4ne93Gd5ttKhehGiyzO14F51dBDBFoibq32V9WmJmts09Sb1
	xKa2qwfS5prv7PlMbpWGDbpR7dikARJc8oUPU/9EAcvqX8jcqRr1tbFXlL43+rFHH4C08S
	ZOMGLPo7INdkL61KR8BwcVCT9sTONuc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U+p2wwv4;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAD34634B4;
	Mon,  9 Nov 2026 17:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B38E1F0089F;
	Mon,  9 Nov 2026 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794245408;
	bh=8ZMtATJ/UU7bDo4o1x8DtF/SV0R6ntQW02njcbLrqVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U+p2wwv4C+kQrVcwZvssLOeRpnAgXsEULsPEgNyaaaIxvwy/8/VtD7V4xk8S90u/q
	 LOzpzC2I2lypdwvarPxFoXZ7SYIzpf7KZZhW/8vXrIgqI+IgENJqFXQU1wqLD0ZOJt
	 ad9lrl+xLEN7TPiZR3cdsFR1ipJLh+td95pCLRukwR/oOEuLFRXdiRI4ocrMdAlKbR
	 oe6DlyKpJmPXb+qNL3Tk1lYBmV8tdok1UwWiuymyAA+cpLqFduKw2owvoWvPHPaF/3
	 o+VT27eAshKjqwOUMveGvqJzOJSm4cz5J+3aog8pZOgcSCH8Hr8iwXzAwL8qFGDu3a
	 zpuGkCZ3Ayn/A==
Date: Mon, 9 Nov 2026 17:30:02 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avICl6pdLiWvO3X1@gremlin>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
 <avHWhZzXE-ge6nU6@gremlin>
 <avH3L4ZbQC6fIt5s@thinkstation>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avH3L4ZbQC6fIt5s@thinkstation>
X-Stat-Signature: mzrmi8gu76s7jgo8pizyd1nkmi55sdc5
X-Rspamd-Queue-Id: 5599A2000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794245409-899432
X-HE-Meta: U2FsdGVkX189LOc2Xv+YmBlLs+VqqieuFj7+zHoj7hwPGUIsIErRrz/naipqorrx1FY35MqQHOFeYEb1KeyNetQSclQNlgs7NLvv+F73/AlbAnm5QUXRcNfdfqzeAshzRKkKhCdIOpZpWQyTR2iZVeloVLH1X0l1xJoJ6M0L4cOpVF4b6vzEYA6LLufc5lN4u1GqHWc8wuU7oyNmj3EkbANdqhlffQYRc6w7nGILp9aKdeWXWimlvz7CGy1pR/UumB3e+1EFcBuFw24gFw9ckuDxYpoCGRGA+Zk1p/Ldat+pMlNod0EBLGOLaly91Eo/rtZh0Oipt6mwICxLxkZWrl+ohdpDOGhIc1uYLK0laLBjG6C2eijOl7UQ4UxIrnGtAMcUG5WaTYwWwDIgwuhy7pRA6euH/3InB5UCQQ1B3GPIZ/QiBfypKTojJx7yIWvM4QNzOfONC2jHcIWOz4DX5x2QpCqvkt7LXode88moxPIYOkJROjjK4n5YiENGYjsgHGhbPv86fi+7meAAorL5NsmSkENPPGOTks7wqTK8tUDWFkVMWHMqPZNN4qphAssCNf1hJtBHbyKhFYAVjbFRmR2eOAisttq/9a5Edz9RYlcsAjg2vkX3QYcABrVPBWZ5ZeWngXsOGNVxxePbWGXZwkgIdnjv/kI9+IZwSKbvsmLBFgiGxczB9F/rUpAmKlJL04tOrhy0sVVzDe7SFMvse1Sjcrk7XKQduVSl+CeoDpBLi4ZGUMieFKsZRLBO0JiI5H0RU6yDaWX+Oruun3Gi8261vRrLM4hWlJ/aRw+Vj7dQSl+gciKVhferA7RMfRRneUZf6eSm2SdZHxgq5AU9Prtmk5GYZIu1B72ap24Wd4l/9QRVSGmUDIeHPzC7N+rB51tYJ1xoKmc+9zruwMJD44QDemecB8wiL4r9KVkBlGP3/aptScspzcdJAGlEOB6JZnrwLgxa/Q8tWimYDUp
 Y7xBnEwS
 PKUGu+fC+XA+/4Z7qOQmf5on8PjdSqB78nbuI9iHSvUgJGRjQu24FpPFsvZ01mOtAEGjtyA1+xKkVTSdoMvJ8GsENGLAr3s59fRSq+IlslbA1CBzP6O9HJ2Xi8ubnoPloOlB6ZKYh1fBV93kfokd35wsHB3fbtsyccTvW/hWM2R0nHPOq4MCOKP2f3YP7RyJz56XhEkgdsHh+WrX0wrjhfu5Egn1eWDE9OT7cxiC3UR2vvWvYhnK9tv++uQDPbT8LVea2IbTpgVNtTW+zif/eaQrM5KQtkEZppfpqGRjUjPe7JWdSgXAd3UrzOvngwzibqgUTKAV1F09Dd8M+t+aT+aOi7ALwvfNnJmGt4L78WLy1pG8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 05:17:03PM +0000, Kiryl Shutsemau wrote:
> On Mon, Nov 09, 2026 at 04:11:40PM +0000, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Nov 09, 2026 at 12:04:01PM +0000, Kiryl Shutsemau (Meta) wrote:
> > > do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
> > > can lock it in that window, fail, and clear PG_uptodate with the folio
> > > left in the page cache. ecryptfs_writepages() does this when encryption
> > > fails. filemap_page_mkwrite() relocks the folio and checks only
> > > ->mapping, so the fault maps a folio that is not uptodate:
> > >
> > >     CPU0                            CPU1
> > >     do_shared_fault()
> > >       folio_unlock()
> > >                                     ecryptfs_writepages()
> > >                                       folio_clear_uptodate()
> > >       filemap_page_mkwrite()
> > >         folio_lock()
> > >       finish_fault()
> > >
> > > The next read(2) or fault on the folio reads it in again from the file,
> > > over anything stored through the mapping in the meantime. Those stores
> > > are lost.
> > >
> > > Recheck PG_uptodate once ->page_mkwrite() returns with the folio locked,
> > > and retry the fault if it is clear, the same way filemap_fault() retries
> > > on a cached folio that lost PG_uptodate. Skip folios outside the page
> > > cache: driver pages from ->fault() never get PG_uptodate and would
> > > retry forever.
> > >
> > > The check stays out of do_page_mkwrite(): wp_page_shared() calls it on
> > > a folio that is still mapped, and a retry there would fault on the same
> > > PTE forever.
> > >
> > > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > > Closes: https://lore.kernel.org/sashiko-outbox-202966@kernel.org/
> >
> > No Fixes? Sorry I may have missed context from v1 here :)
>
> The window is from 2007, when __do_fault() started to drop the folio
> lock around ->page_mkwrite():
>
> Fixes: 6967614761fd ("ocfs2: release page lock before calling ->page_mkwrite")

Yeah not insisting!

>
> Not sure how useful such Fixes is. It predates any possible stable tree.
>
> > > ---
> > >  mm/memory.c | 22 ++++++++++++++++++++++
> > >  1 file changed, 22 insertions(+)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index fe72e66c9c2e..cc1d0b7d15c7 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -5613,6 +5613,18 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
> > >  	return VM_FAULT_OOM;
> > >  }
> > >
> > > +/*
> > > + * A page cache folio that is not uptodate holds data that was never read in
> > > + * or cleared, and mapping it leaks stale memory to userspace.
> > > + */
> > > +static bool file_folio_not_uptodate(struct folio *folio)
> > > +{
> > > +	if (likely(folio_test_uptodate(folio)))
> > > +		return false;
> > > +	/* Driver pages from ->fault() never get PG_uptodate */
> >
> > I guess you mean drivers that return non-page cache folios from ->fault()?
>
> Yes. How about:
>
>         /*
>          * ->fault() can also return driver memory that is not in the page
>          * cache. It never gets PG_uptodate.
>          */
>
> I would rather avoid "rmappable". These folios do get
> folio_add_file_rmap_ptes() in set_pte_range(), and the word reads like
> PG_large_rmappable. As you said, DAX never reaches the check, so "page
> cache" is accurate.

OK, though my concern is you're making an assumption based on where this is
called from, somebody else could use the function somewhere else and... :)

But this is nitpicking really, that's fine!

>
> > > +	return !folio_test_anon(folio) && folio->mapping;
> >
> > Technically folio_test_anon() can never return true based on where this is
> > called from right? Could this just be a:
> >
> > 	VM_WARN_ON_ONCE(folio_test_anon(folio));
> > 	/* ... comment */
> > 	return folio->mapping;
> >
> > Instead?
>
> Right, all callers pass a file folio.
>
> I will make it an assert, but at the top of the helper, so it checks
> every call and not only the rare !uptodate one.

Thanks!

>
> > > @@ -6163,6 +6175,16 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
> > >  			folio_put(folio);
> > >  			return tmp;
> > >  		}
> > > +
> > > +		/*
> > > +		 * The folio was unlocked for ->page_mkwrite(). If it lost
> > > +		 * PG_uptodate meanwhile, retry the fault to read it in again.
> > > +		 */
> > > +		if (unlikely(file_folio_not_uptodate(folio))) {
> >
> > As Pedro said, I think this unlikely() is probably unnecessary given the true
> > return case is implicitly unlikely.
>
> As I told Pedro, I prefer it at the call site. That is where the reader
> needs to see that the retry is the rare path. But if you insist...

You could also remove the likely() in the function itself ;)

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

