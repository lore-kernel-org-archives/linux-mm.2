Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E9AAC54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 13:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BE5E6B008A; Fri, 31 Jul 2026 09:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F656B008C; Fri, 31 Jul 2026 09:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 385EA6B0092; Fri, 31 Jul 2026 09:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A67F6B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:06:51 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 78418A181B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:06:50 +0000 (UTC)
X-FDA: 85049096580.20.4D14464
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D29C81C000F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 13:06:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UXETMweu;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785503208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfKDQGcjC77lWhFDxxIUMTeu7Or4b1KfGKqTpcdoQtg=;
	b=Q2rm7FF0GilIjXyIgkP2ZEBoK8xmsfkjyG5LvTnIb6JQfu8QqrPz2UqakNjW+swWkVz+Gx
	crI3vqGFqHab/sEPzcvodegiKTzi8XiGSJBeAi7UjI2hzPK8BPt16u3pXRCa1yiMZLQL3T
	TZkr3mAsdwtXwgnU/y19tNoby6kL8xc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785503208;
	b=57FQOguXMfKVeCs607SN4Xv6Lc/S06UaLr+JAcJtL94AuTB20CPF6V0qM1LnEwc3GXXykq
	j8A+lupnsfl3r3XSPYz8RWRIrTQHUkdvIEDZo8zM0eIfvwaclMFt52DE8FDypNDGPqmkGZ
	+GHzRNdkFGaZ/U7L7jVx+qq15NqCGF8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UXETMweu;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E05F7411A1;
	Fri, 31 Jul 2026 13:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4219C1F000E9;
	Fri, 31 Jul 2026 13:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785503207;
	bh=DfKDQGcjC77lWhFDxxIUMTeu7Or4b1KfGKqTpcdoQtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UXETMweuKAHYqTuS5uRHtY5TtueyuIE2O+mlkmCM5dAvXTXYxgI1ETPQNCT1M5EL4
	 OC3gK19KAd+yn9fPRiK9bt/Hg3SCuZhDwBcU7SSJIq+PRhSga84nsg6WfoUw2D4E+4
	 tdABxNtLnEXvH8zLfIsu3jTPoAaWYDz6RkHFvKEKYHhS3hikmj1NpFa3tHfyrNOkdR
	 mOfpnbqKVyGVQuTb99j0N1fYwHz/U6/Z3wKq67lc85OD4sQeUM78REpUGH6bjMMM+C
	 aFgEnHL6c9WFS6RaACpUYG2wpumJlf4vouyLNPMKC/bKisz/Nsz2Q8HJMbrVA3b3B6
	 LY/TXXBhqkMGw==
Date: Fri, 31 Jul 2026 14:06:30 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	lihongfu@kylinos.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, vbabka@kernel.org
Subject: Re: [PATCH v2 1/2] mm: Use a folio in the softleaf_is_device_private
 path
Message-ID: <amyZL8pfpMetn30d@lucifer>
References: <amdkR-gX_ABcKyCQ@lucifer>
 <20260731094054.90791-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731094054.90791-1-hongfu.li@linux.dev>
X-Rspamd-Queue-Id: D29C81C000F
X-Stat-Signature: i1ci7gfa4a8xnhkgmiocbiq11o1q9ehz
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785503208-38331
X-HE-Meta: U2FsdGVkX19nif+MmjVbGI72w1ZqxVpJRaQWJU6z46x+3+n6cFQrmc46jxClwThfJTssy++cAgx1VbAxZGI8q5ggGjYIWq3GywW+Oo0r3vYXlshz+9BKwMhztTzBQxPWhSlHpRQiRSp3+l6TD8JvLF8clGQrI5M5hL9SETW/LQyGNqd76EYzE+Hl+zhrLHcPDaM5FujdF7gj4xLukuFZPLjB/hUuHK2t5nD/2Cf1qF0vrwgsyb7r7S/xxoAaIEuigk/qc6XKt1taJH4uddTVYh66+SvspK3sgVMDmCcQja6J4Tz78Fc2+p8iK0uFgdz/eUaWi3orKVaRxB5NVf+BC7dHoFNFhNtl3kVyNs51HV0+twZMzd9gLMuvbALGIqvU6zsqTgQubUsvSOKnCfoowR30P6Ak7sF/dy0TPiU6myVg6+x0lizx03lrHjKJWL1d8mYld7bAV/44h8N1wRiOUpuvMSr76lFgNiz25Z+IRb9+bi1vNIXgkJDg0W82BRtkKWsNFRYyItx2sB6Lnzu5koSnO+6rXrBky9vGnIG0XuZrfEjX2lt4MW86XNTRfnj3NtWQWgb0GIiwKmz2+MK1aY2/6SChGyxmlC4I2eR6Eub0yUp2N0d9jl0HYfyInykRU5SRX+g1P+7lHE10KaS1PB8JdC0PvRV5/QNv/6l/PFnSgoKF8JiRQqlIG4D+nzABEle5XPXmfkYbmpameUrD+cMpYNkHKBc5VcmQ90iJl9+b7cLqNi/eHnlzCdWvOxdFrS3VzjbMjqLTYokHWCWP9Yg6vKPJlP0WYfpJBR6v6snwwVfmDt2bbGorfQhO0VrS3nJJRQZuB5L4ldOmdb8zWpXAdIZyqFdiTOykUk3ThHLYzSMXlJbRAH9qu3hMN5rOaic8YPnH6zLw7VYR4m0cK9HnxTlbWfblVNzL05FEfj5MPonv49B/swbAObOyRHhGw+c94inmcTFsmenSMKa
 vXJNUKpp
 qS6db73TzvAllFy55uGpInYs2ZN7yJmC7HDJYpem8NN/7oxLRZYUPIs0bFZMb3Jl/gQ9l8aNaAuOEefLquZir/8VLWkS/CH9tDWeGPztiS1w9idqqbaKavjnc+3YM40FqaFiuUwf5aFQnNLqScmfu7EqsgCWrP9RFT9+aI/QL9x1Yb41+4Gm118SQu+YmCjxx6Udku5H9ktS9Sd4l4xhGtByVrVUWjJF7wW2sBwe3WibDOqFCVhZao2YiEYJiyC9/yWPuQywcGbSW200vILP3XR0Rzxyo7NrTZNIeXMHgDIFq6Bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 05:40:54PM +0800, Hongfu Li wrote:
> > >  mm/memory.c | 11 ++++++-----
> > >  1 file changed, 6 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index d5e87624f692..ae521baa8c84 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4871,18 +4871,19 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >  				goto unlock;
> > >
> >
> > Up here we have:
> >
> > 			vmf->page = softleaf_to_page(entry);
> > 			vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> > 					vmf->address, &vmf->ptl);
> > 			if (unlikely(!vmf->pte ||
> > 				     !pte_same(ptep_get(vmf->pte),
> > 							vmf->orig_pte)))
> >
> > Since we're canonicalising to folio why not actually set folio using
> > softleaf_to_folio()?
> >
> > So
> >
> > +			folio = softleaf_to_folio(entry);
> > -			vmf->page = softleaf_to_page(entry);
> > +			vmf->page = &folio->page;
> >
> > This would also make more sense in your 2/2. But more on that in a sec.
>
> Thanks, I've thought through your suggestion carefully.
>
> Could entry reference a tail page of a folio here?
> If so, softleaf_to_folio() retrieves the folio containing this page,
> and vmf->page = &folio->page would point to the folio's head page,
> which may not be correct.

Yeah that's true! My bad, disregard that bit then :)

>
> Best regards,
> Hongfu

--
Cheers, Lorenzo

