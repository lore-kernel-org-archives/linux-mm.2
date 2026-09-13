Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A2DC88E5C
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 18:48:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E2386B0092; Sun, 13 Sep 2026 14:48:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693836B0093; Sun, 13 Sep 2026 14:48:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8E56B0095; Sun, 13 Sep 2026 14:48:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A5AB6B0092
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 14:48:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CDBC8099B
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:48:53 +0000 (UTC)
X-FDA: 85209625746.08.24E61A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DCFE980006
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 18:48:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItY4COLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789325331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jb/hhwiK/UcdPAYGlSzJUb1U4vkmWKdi+D5nmTCyiwc=;
	b=tAftsuUUlhsNvZqXnMjaHTcyBbSAnmXp9iSyrmXN7189O7Z3dkEND3L6YiXECktE3ondV2
	my0xsnQEdWgSBtKGd9P05JbVd+qfvfG/ZIQI9qWzKrvIYMSGCGesdFXsVDm1z2LXvirTOi
	pprYQgZOQg1tgIO68zMg6JHJt9xlXKo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789325331;
	b=aKAl1mvUwI2T4HAACKU4njobtytfxkXFHqDsa+3EBqkENiuFw1ZkSWUHajH2u1zyx8kPou
	OnlOLHronqA6iETBLSTUypJC6Qqj+ayOgbCtOJGKP66IvYMzDxgpLW7mae4lgEsNPFsO5M
	GSktbGS9W8ngR/k/NcB6n6+fHC6Zkio=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItY4COLM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B40660F8D;
	Sun, 13 Sep 2026 18:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E79701F000FF;
	Sun, 13 Sep 2026 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789325331;
	bh=jb/hhwiK/UcdPAYGlSzJUb1U4vkmWKdi+D5nmTCyiwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ItY4COLMkAOPfq5upFo8+NRTEgTDJTWe71lMpMoYvx0ForD2G2ynjMLUv2Mnqq/Jo
	 C6CeqeBAIXxivARXiF0/4f1ecs//FHJoa5wN0EJkQq+rGGS9/FtWk79Jh/I5fzCZqr
	 hwZMMnyXadBtXtpmEgWarpdPi/AIA3J8c2CWRh5gPKngo4zKqcGydp/CKNne6/zAAA
	 xhozv6PlZTBw0YRIbYlFzREHen/VOfCFQhbe5rxQ9EHEZqVlV/OGyByRAIrjc6ugl4
	 2+ME+jKjjsts8211xwWo0ZHPTCfQl7vVJN1Ht8x9Tq0kbu4rKkT8V0GtXuT6+HfY08
	 SX9dpAjXFMf0g==
Date: Sun, 13 Sep 2026 19:48:44 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] khugepaged: hold invalidate_lock across
 collapse_file() readahead
Message-ID: <aqbvFtlXd3Jdnfbm@gremlin>
References: <DLEBZ0GIGNQ8.17U563YYJ37AA@nvidia.com>
 <20260913163644.122133-1-ngocthang2710.1999@gmail.com>
 <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913111700.6de78b5834842f7dd3f12d07@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DCFE980006
X-Stat-Signature: 7k47k7w4jnq7ajq8zmg65dzu36y15kxr
X-HE-Tag: 1789325331-425999
X-HE-Meta: U2FsdGVkX1+BccHcxPA9VDni0v96UVIH6bQJY39VzZ2sKucEmZ4D9MIXAq5tBjIHJg4fK2r5ipo1aKsRgfnRT6DYHQyjqNP5wlSXegvJlwtuM44KsY+P3ODOonLD7rC+SYnB5WW6t5uCdOj6W5l+uZrjZsoYHw5XC1MJPEnTXFtzddkdTt1dohyaigHic2uajFgFjtIFCGrwIf04L46KclQ37h0XWoy+pNcsH6u5Ey0Twgpg/SvUxbkqyy9y201HF/inSYqPJuFAy4hsYbxtXjpFCSDpKx3MS4y3TGm5xPubUXTMi5rRz+P9NzYVyuPfN73rvez/ObAZ7doG9rAVuJ/bZmZZ6jmM/Jic9v4ZuWwn+Kz+iyupKXIyCtlZvfco8FFcPBmeg50/2Qb6SDTKKgeSorK0U8bsELQVXp0Clji341/LNdieEEF8idTCtad1qjdFBozgRLEPC5kWQg4sSR/7erTTSazmtnDLEN0XH+2RaP7S3mIVGfuOShaLhczICB3Zvg0Mmslhbgbvu/5H7obHyf19GpSUMe45pcTw8T/xAauN9F7UKgu4Xkav+XAVIrK6Y12Tb/DtaGYnQ/fViMjQXG3FetDURkyNuTx5wyVKlJ6O+tLNqbXcjg7D5zd5oavwjsrtI3mwjnIf8JERX6uvbQGKsmjtTgnf8d2OYpAsMfCOxIy/vw5ibLWQZZJrfewnfqtZ7l8W18BnNjeT+awaH+s7hhZriavB8tWk2JYQjPwUE6nurgm2ukOiq2QCIMV096B/wubWTc2fzPGd7Zyh9dUD0KcaSU9D2/6bP+uwEy2mPN7lMYUxYzui9/WRzWOqA/0Af/xWgmOq1qujYzfeEe1I0cMhn0fLqJ5YXRT2hv3FqZur+/9ZGzzpqc2kXtmzvmQJM9wCjsiyd73fN1CthEOQZ0f16ZdUb2Z0QYCJzY42AOIneH8+pxpJXTQcqFYJtPWMWCfMEAH5rga
 AS9HCL/0
 dwgTwgRkVYXr4LvdA+6yTLj/wez/8KCc3w/sHX8Q95sO2Be/K/d/dbz+Pinut/04eUbZ9Qbp2qZrAPp8exW/1tUPKtf7Y1Acv9NiFo9VCBMniqJ3k53eMcQqskjw5MjRdp62aoR7EkcIA41zSROWK2SyUsFhBx7DQQHjxIJsW/RoGCZE3hPu50Pc+LUW/FZV0jVYKR93WuC1alIXAb2JQy+Oihm38irOpyBFmxey+KDhTbGV9zp2Zc6rz0BVwfMMLRFAcZw5mCMSmMSiY8JSoNpiTF8pbSmwHw897zRBCbuPleUBPWlMRvCiqDcw99RzrMhtJZL+k5vXG4EIgpUq1RavCoT8f5bXr8dErMtlN5MmzoPkogHWzrcODFjUcJ4A71NkEsLCRa/y0Q60zN88wVmNkc1Q+OPRxmL22f/CaCaJqem9iMdgj0AX1thJR91pVGvrrlyK/rC9o5H9Z3jPjp0I0m0Vpq6GEtX5cp961YhBPkFjlAMPqj4j96DyKMGvSfq5s2h2lTUpIcS41dZ2quUP9xQpzvFaHUUl4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Nguyen - do not send v2 in reply to v1, look across mm and see how things are
done here).

somebody who has a

On Sun, Sep 13, 2026 at 11:17:00AM -0700, Andrew Morton wrote:
> On Sun, 13 Sep 2026 23:36:44 +0700 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com> wrote:
>
> > collapse_file() calls page_cache_sync_readahead() to fault in missing
> > pages before collapsing them into a THP. That helper takes
> > mapping->invalidate_lock itself for the duration of the call, then
> > drops it -- but truncate (e.g. ext4_setattr() -> truncate_pagecache())
> > takes invalidate_lock and then waits on each page's folio lock while
> > holding it. If collapse_file() has already locked one of those folios
> > by the time truncate reaches it, and then tries to acquire
> > invalidate_lock again (e.g. on the first readahead call, since
> > invalidate_lock is not yet held at that point), the two paths can
> > deadlock/hang on each other's lock: truncate blocked on the folio lock
> > collapse holds, and collapse blocked waiting for invalidate_lock that
> > truncate holds.
> >
> > Reproducing this over ~150,000 collapse iterations with truncate
> > racing concurrently reliably hits hung_task: blocked tasks within
> > about 20 seconds on an unpatched kernel.
> >
> > Fix it by taking invalidate_lock_shared once for the whole scan, after
> > alloc_charge_folio() succeeds and before locking any folio, and using
> > page_cache_ra_unbounded() directly in the readahead call site instead
> > of page_cache_sync_readahead(), since the latter would try to retake
> > the lock we already hold. page_cache_ra_unbounded() does not clamp to
> > EOF like the helper it replaces, so clamp the requested range
> > explicitly.
> >
> > 730633f0b7f9 added invalidate_lock acquisition around readahead but
> > missed collapse_file(), which already locks pages while calling
> > readahead; later filesystem conversions made the deadlock reachable by
> > taking invalidate_lock before waiting on page locks during truncate.
> >
> > Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> > Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
>
> (You forgot to cc the original author)

Also a change log, and that mm doesn't like sending a respin in-reply-to a
previous version. Which is all consistent with somebody using e.g. openclaw to
pepper generated patches across the kernel...

>
> Five years.
>
> I wonder why this hasn't been discovered by lockdep, AI, syzbot or any
> other of the tools we've been using for so long.
>
> Thanks for doing all this.

See https://lore.kernel.org/linux-mm/aqbtfms0_2ULBIT7@gremlin/

I am not really entirely happy with somebody who has sent a flurry of patches
across disparate subsystems with no previous track record being in charge of a
potentially backported fix.

It's David's decision but I think this fix should be taken over by somebody
else.

See https://lore.kernel.org/all/?q=f%3ANguyen+Ngoc+Thang

>
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2257,6 +2257,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	enum scan_result result = SCAN_SUCCEED;
> >  	int nr_none = 0;
> >  	bool is_shmem = shmem_file(file);
> > +	bool need_unlock = false;
> >
> >  	/*
> >  	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> > @@ -2271,6 +2272,15 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	if (result != SCAN_SUCCEED)
> >  		goto out;
> >
> > +	/*
> > +	 * Take invalidate_lock before any folio lock: the readahead below
> > +	 * needs it, and truncate holds it while waiting on folio locks.
> > +	 */
> > +	if (!is_shmem) {
>
> Is the shmem special-case a red flag?
>
> Probably this fix an acceptable minimal-thing-for-backporting.
>
> Question for maintainers as well as for yourself: but does this
> indicate a need for a more architected redo?
>

--
Cheers, Lorenzo

