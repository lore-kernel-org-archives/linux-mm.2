Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45611C88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 18:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB67D6B0088; Sun, 13 Sep 2026 14:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67616B008C; Sun, 13 Sep 2026 14:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7F5E6B0092; Sun, 13 Sep 2026 14:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 46E9E6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 14:43:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43AEC1209AE
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:43:52 +0000 (UTC)
X-FDA: 85209613104.17.F868974
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91AB0100003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:43:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eNx/h/qR";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789325030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jcy4Xks1KmzO/76JdqZYak5DRErDriwNl/lBhMKXFU=;
	b=PdobjtLJl01F9fvcD+TTJdb9vAcg3N+0vtEF36Wuezl29jVu5YP4AsP0Fg8ssJoPSDRt1O
	vHXdxGlGh54mkF8p7EGUJOyBft2EjVa3BL//qpofgJEzDUO0/Vw3pKQqJ/i33uMXhqLn1/
	2W1x+0+XwnbyWAzwdFJzDw8vrlDY/mc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789325030;
	b=eJ972OFAXawboOVndNKoZQCv/pmYJoO0WPwm+PJXnTystKbvUVVrVNnTkwz7sUCqDs7dz6
	TnOA50WhmrgXZeoFa7F5SVA8FLz8rGj0G/IDUbsNKgUNTJ4uBr25g0b2+TuwSNAOCgsN0Y
	EdFMdjk4vJfxTgkyxsF4CI3v23sTDgk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="eNx/h/qR";
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFAC74034E;
	Sun, 13 Sep 2026 18:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8B51F000FF;
	Sun, 13 Sep 2026 18:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789325028;
	bh=0jcy4Xks1KmzO/76JdqZYak5DRErDriwNl/lBhMKXFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eNx/h/qRjBH8CFc2lfKqkmZ1HZbCTa5aBsMZqDhZysDc4vBfloO4DwENDgXqUo026
	 uO1mcwsr3a1AnUAKeDEeKJIW0W0hJS6GKk5YGJ+u7SuaS1dSbE7oEZHOG03+gGSzk0
	 4KCe0+0p4Yslz9fOENom+FbB4eZAKkMn3SdkWxp/IIQe/lKFprJCwza8ZiZJ+yu3xH
	 Yoc+NT0DZFd1w0Hbn2ElMFjeDv66Ra+19KAvyNFAmh7SuFFCr633zkM2RIrL2s/0fi
	 i1dDI5pTK2kKsc+pIVt+tnz+COmSEDLRmrdNWFTjFCrIur76NETlwNwwhf/rK8MtcJ
	 i0U6xEh5wEx2g==
Date: Sun, 13 Sep 2026 19:43:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Pedro Falcato <pfalcato@suse.de>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] khugepaged: hold invalidate_lock across collapse_file()
 readahead
Message-ID: <aqbtfms0_2ULBIT7@gremlin>
References: <20260913101142.28802-1-ngocthang2710.1999@gmail.com>
 <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: prt6twqap1h1jej1bk8fo666q33q55mf
X-Rspamd-Queue-Id: 91AB0100003
X-HE-Tag: 1789325030-165069
X-HE-Meta: U2FsdGVkX18L6JU1DLynb/WPppf8NLYhqBWyea52l/0Xi/FaJTSvtXqdLLWrqYUAuq2+Gd7sl8Et4IUSAUgAT7cJABYLP+6mCfzcse3cAQ2txwxpVPjRfvRSVXlwymSJa6WRrJPLZoL/8P/yIIlEELnoef+R47kOay4jTJQFQTw7DqaI1gXDRTPdWfuR8RJmiH3t9oKn1rKlQtuRlSPjBTcKphbXc3rl3TVIr28gmX93XXqSf79o0Ijwe+7Z3Bblgx5CMH0++Pf/2m8UJLkf8RH1EqfQVfqvWPRB8guXzs2tnz7Hn3FDMHwpZ9qaTkmuO2ySkDRlbMvZ/Wff2hNSYg0OXhwHLBqrPn3aoAyYOqQxYVRAyKgkWDZTaG1uPoaC8KcPnapiSOtuCqYyoGxvasIADVtcWiUWEPS1rVSZb+ZjijZ3+IDnbf2K40txyt5uD+x6r7sMXCnqDdGUGhyofp7GKYN3NmMaFpMZdBxjeTAaawXdj8DHikR7S/dLCy6JydKxogr57CUkAy02jU4gaflsRA7y8XKl9aiXwcwk/VCeIOLp6HknMbj3JL6DOaSnmlNE6E4ZL69hxaCKMwC1EZ81MQeDPLio/CSNA8oBscS2tPGEh4xrQ7ztFy6g5o+PJ9k4qXVqo5ge0DYp0CoZZitOhJQ6UNOEUf/F2AW0Ot2rQC8yF+lY2pZgoRApYpks3N18u94VN4stoFRP3O7y3uqYFzHv9n/3xrYpNVuxD0/mSz4qaj6zGz5WaDT3+aM8b6BPN1oSrvdEErvAcRTQxGh1mEeAqRE1Ce+qeg7TrfVZ21Ji+8sxs0PxcVf6ryS1lQKnqW7ZfeZU958T5gKlJ1x8TNmBMCe+s1dVk/FbqLIpZR/PL66w1J8R6/1QIzGyVXxrFvvLzsGFQdWUFsSm09Xsmgj6DGV3VogGVAHDEwE4BMXuvAJWoBDU/omZmLa8vtvWAFQ/j3PKTVrm4xV
 S0aX1Zl1
 0SmsJP/X6v+ot4e1jFee1lE1ONnye9O7XCfJTgDpuXwJM095QG5KOQQDOXcX4lYnZI0qWNaxz4w1w9Fy9vLdumcuANGsGEbAKv/hQ3RJ7SSXZgJ18wjTWnw8A5+M/zspEGuCLn43FrKsrXEvD0+axofQajvfSg/Sqk3OkpYsMH1dDv8OVnFyNorbDiX6yDOOosgfjeO0Z9flYFMzgHdMA3n7KEuZqbANfQz1l5V+hTFdS+ifSKv+2E6c/qzym+PXOiZtAku9P3QTzLZ9VoecouHViUbM4TeZWHZfVUpD+HCVnlgDH6B4bGij4GJezKgQWOlKJBH8k6ofx1GrtA5iD5rh6iencWaDGEiVJyaHTA4XG74tZb26D6riuTBSZIxHm9GI2Nj236oyazjl2mKuNlIH07UVU0DrpH/yInkk4dJByNAgDzTXFIg3W5FX0zqL3P0MXVkDRerhVnNafRStwWVoPVbJpItToGmpVfwRnaRvIgZjEo2ZeLcLc9CUZaI8M6/ThSokouovhr/VTmB0IQk+Wz3rvDlETvD7m12kHxiDFvqe/oi+2G/Y/oMUiaJNsHoFWzsTo4/CuYg08QCj4EPl6WciiNelad+4O/YVb0mrXdhXPtp8J+WpoLKuwKdqAGGGT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 13, 2026 at 12:31:32PM -0400, Zi Yan wrote:
> +willy and heat
>
> On Sun Sep 13, 2026 at 6:11 AM EDT, Nguyen Ngoc Thang wrote:
> > collapse_file() calls page_cache_sync_readahead() to fault in missing
> > pages before collapsing them into a THP. That helper takes
> > mapping->invalidate_lock itself for the duration of the call, then
> > drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())

Em-dash.

> > takes invalidate_lock and then waits on each page's folio lock while
> > holding it. If collapse_file() has already locked one of those folios
> > by the time truncate reaches it, and then tries to acquire
> > invalidate_lock again (e.g. on the next iteration, or via a nested
> > readahead call), the two paths can deadlock/hang on each other's lock:
> > truncate blocked on the folio lock collapse holds, and collapse
> > blocked waiting for invalidate_lock that truncate holds.

Please don't send walls of text.

> >
> > Reproducing this over ~150,000 collapse iterations with truncate
> > racing concurrently reliably hits hung_task: blocked tasks within
> > about 20 seconds on an unpatched kernel.
> >
> > Fix it by taking invalidate_lock_shared once for the whole scan, before
> > locking any folio, and using page_cache_ra_unbounded() directly in the
> > readahead call site instead of page_cache_sync_readahead(), since the
> > latter would try to retake the lock we already hold.
> > page_cache_ra_unbounded() does not clamp to EOF like the helper it
> > replaces, so clamp the requested range explicitly.
> >
> > Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> > Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

No Fixes tag?...

Given, AFAICT, that you have no contribution history until last wednesday, and
have emerged from nowhere to sending patches across I think 8 maybe 9 subsystems
all at once, it seems a near-certainty you're using an LLM to generate patches.

Please follow kernel procedure and add an Assisted-by tag disclosing this both
on this patch and all the others, please.

https://docs.kernel.org/process/coding-assistants.html

Also note that you are also required to have an understanding of what the
patches are doing:

https://docs.kernel.org/process/generated-content.html

	"As with the output of any tooling, the result may be incorrect or
	inappropriate. You are expected to understand and to be able to defend
	everything you submit. If you are unable to do so, then do not submit
	the resulting changes."

On that basis I wonder whether it would be best if somebody else could take over
this patch?

> > ---
> >  mm/khugepaged.c | 25 ++++++++++++++++++++++---
> >  1 file changed, 22 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 11ff98d55c76..690ccbcdf593 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2267,6 +2267,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	VM_WARN_ON_ONCE(!is_shmem && !mapping_pmd_folio_support(mapping));
> >  	VM_WARN_ON_ONCE(start & (HPAGE_PMD_NR - 1));
> >
> > +	/*
> > +	 * Take invalidate_lock before any folio lock: the readahead below
> > +	 * needs it, and truncate holds it while waiting on folio locks.
> > +	 */
> > +	if (!is_shmem)
> > +		filemap_invalidate_lock_shared(mapping);
> > +
> >  	result = alloc_charge_folio(&new_folio, mm, cc, HPAGE_PMD_ORDER);
> >  	if (result != SCAN_SUCCEED)
> >  		goto out;
> > @@ -2337,10 +2344,20 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  			}
> >  		} else {	/* !is_shmem */
> >  			if (!folio || xa_is_value(folio)) {
> > +				DEFINE_READAHEAD(ractl, file, &file->f_ra,
> > +						  mapping, index);
> > +				pgoff_t eof = DIV_ROUND_UP(i_size_read(mapping->host),
> > +							    PAGE_SIZE);
> > +
> >  				xas_unlock_irq(&xas);
> > -				page_cache_sync_readahead(mapping, &file->f_ra,
> > -							  file, index,
> > -							  end - index);
> > +				/*
> > +				 * invalidate_lock held above; don't retake it.
> > +				 * page_cache_ra_unbounded(), unlike the readahead
> > +				 * helper this replaces, does not clamp to EOF.
> > +				 */
> > +				if (index < eof)
> > +					page_cache_ra_unbounded(&ractl,
> > +						min(end, eof) - index, 0);
> >  				/* drain lru cache to help folio_isolate_lru() */
> >  				lru_add_drain();
> >  				folio = filemap_lock_folio(mapping, index);
> > @@ -2672,6 +2689,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	folio_unlock(new_folio);
> >  	folio_put(new_folio);
> >  out:
> > +	if (!is_shmem)
> > +		filemap_invalidate_unlock_shared(mapping);
> >  	VM_BUG_ON(!list_empty(&pagelist));
> >  	trace_mm_khugepaged_collapse_file(mm, new_folio, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
> >  	return result;
>
>
>
>
> --
> Best Regards,
> Yan, Zi
>

--
Cheers, Lorenzo

