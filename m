Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805F4D10F24
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:28:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE586B002C; Wed, 26 Nov 2025 13:28:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F276B00A6; Wed, 26 Nov 2025 13:28:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD046B00A7; Wed, 26 Nov 2025 13:28:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABB046B002C
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:28:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6184D8A342
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:28:18 +0000 (UTC)
X-FDA: 84153593076.24.8DD30FF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id A1F5E14000B
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:28:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EDXwQLG7;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764181696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMtuZdjEjIyWs7AMMNhWKMWFtEfsA3Nf1pH3H7cBisk=;
	b=O2MDA/FETNJVyKcNLNr9QwgXS1ab3QEszTyYE3ZWTvhgL7gZ7yt2d0kOiQhkhYXur6umTX
	kT16HUHWXqYG4raSTBE6vUagDblNSt4bmLAlXE4nbLmnGe17SalXfzzzBiYXQDZcecyjkQ
	Y0ZFRdQk8ozvkHNXL0spMlTsoVqIwEU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=EDXwQLG7;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764181696; a=rsa-sha256;
	cv=none;
	b=17r05O7IzCzXUb0TBLudDzNe3LwfopvsNL+E4VmVXhMEaJJxO08w6IPn9ZMh3q4jWJ9m6k
	oWFXOWLBU+YEpEOMoBjYmNAqr2Exn+Vr5HJc2CWJZEhT1oiJ7NK+sYl8ZLwOlZbwyNIzL6
	wiag166NnV19VtDhlpbfuWYCauk0gXw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=IMtuZdjEjIyWs7AMMNhWKMWFtEfsA3Nf1pH3H7cBisk=; b=EDXwQLG7m2/DlEb5zVFsUebFto
	UnQWxYHYPvMC3prtF4A/VoM+H8WD8K2dMUAAoQeGEMeFI4AdpxeAuV0RqZAJG9+HTT4FMSNPqiy4W
	/Ss2LcN4coLR/z43sLaE8kb762L7kHRzcn039qAnD5tAcPR5Pya2osfZYEPH7K0vtCRk+QOXkIEuD
	bdEtMVGWH4WpWm4h2lh3VGK9LetesPEwK/eizmzL8BaRLHLAu0x8zbAMDWR1pXgVn9oDOrd/QcmHv
	KNMZPOKIv0aUDffoksykP884/RJLrRkRQCMcl6wwM0Cwl+ERBW2LI1EFDmmYDbNNmWdtOqKaAsW/4
	Eqi+43/g==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vOKFR-0000000AXL2-42jd;
	Wed, 26 Nov 2025 18:28:13 +0000
Date: Wed, 26 Nov 2025 18:28:13 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <aSdGvY2UzrXdR2e3@casper.infradead.org>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
X-Stat-Signature: 948pbo1pafmpau1r9zp6pah8kx97rest
X-Rspam-User: 
X-Rspamd-Queue-Id: A1F5E14000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1764181696-572191
X-HE-Meta: U2FsdGVkX18cWTeBGNDIPwqBILRjLcosUA+fLLTXjduKbsNJw0LlzTmJk8kXuxnLsuN1hZDQAYr2EbL7K2zcu4s0ZmCBrPAaIe+Tl5FX5V5GLzQt6dlCRhT7WoR7b6QALeY4mYKfrO/Z4y8V0JEYs3UDdIXlglm39A+td/lQnI7iy6W9+if4WsUOSAPf0PuGzYzoSK5/Qadm+YRwwDSMmkiOCkZ1ZbErdcmHS4Qaur/3CKvNjx6s5Sc5RZtkVQg6hkVssulElzOJkkFEpyXoCjYROXPBJy4lFZVRiRQfdxLWsrbSxgOIm5mDmPt2Y7tAYjMXv5/yVEfjlQMWV0jAkQYY6kSSzk+KSM414uTjT74byAx0AK4CsDySBz3w1/bSOxRbAlDI83KLcC74Y3XS1QHM8oGBVi/n6mAjFZ2XL6Wqndindx6XkFTEuzF7PTkAYL4O+pSh21+yS2JQyPUGCmyhsLuiU2UcZuxCrYi3CPusw9S4lh0JprGWKXwaxESodDmrMCO+Bu6vyezbHT8alnTc4T8AS0e+WN1idSpB9MVL+xs3YUFNYB2SGyNUKbhx/RiwSXbUCvDPTgQ7fXlo+Q5L+unHnfi3R6mg22G2yRTrLeWN766IuNrUloosUgR9gl/ITdrvSM2ujeTlW+Rl5+2YM+6pwsQWmCf3pXTIswzYPoNbmIS/FBd6uzLMNxujZJKViiXitvmfbiFm0X2NA1p9DCFyRtQp4xD4VrGGf5yhsko2WX4yP8xTHlCEO4kzPlUJZ5bdst2fVEz1ruu+liZZJbaekByEdM7tc+FinWzqV5iM/cTINvwDX6HrUEOZpEKjZkcBmnRaODFhBEP2UiELcxT+D/3HIdNCuGsvQ57hMIwFzM/vGuc+bQo3u2xj7WedrJCvgN8Q+pNpD0tQG9u7EgEl7NBw/dMzjU6wIWvyzoHG7g63PIL0L4ta1JTd+vi3SsS2L/6RmIT914d
 972ZAmUY
 9ilhu4c4ZIuAQsCc/lF2bjcM6UJfyqt0m47vRx3/l8N2xFy+SAXoDGCY7AkOr471sALy/7OhPhMnI7/NukwRSfjZcbKf+B1JgSW7c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 06:06:53PM +0000, Lorenzo Stoakes wrote:
> On Wed, Nov 26, 2025 at 05:44:58PM +0000, Matthew Wilcox (Oracle) wrote:
> > If we get a signal, we need to restore the vm_refcnt.  We don't think
> > that the refcount can actually be decremented to zero here as it
> > requires the VMA to be detached, and the vma_mark_detached() uses
> > TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
> > as if the refcount was zero at the start of this function.
> >
> > Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> > Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> > Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/mmap_lock.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index e6e5570d1ec7..3c9bf2f96280 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
> >  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
> >  		   state);
> >  	if (err) {
> > +		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> 
> Really think we should WARN_ON_ONCE() as Vlasta suggested.
> 
> It's an 'impossible' situation so we should make that clear. And we should
> find out about it if the impossible happens... :)

It's only "impossible" currently due to some fairly esoteric reasoning.
As far as _this_ function is concerned, it's entirely possible.
I don't want to leave this trap for the next person who calls
__vma_enter_locked(TASK_KILLABLE).

> > +			/*
> > +			 * We got a fatal signal, but the last reader went
> > +			 * away as well.  Resolve the race in favour of
> 
> This is very subtle, I don't think this really explains this clearly
> enough.
> 
> Maybe put something like:
> 
> 	/* Couldn't wait on readers probably due to a fatal signal, so unlock. */
> 
> Before the refcount_sub_and_test()

I think this falls into the "saying what you're doing, not why
you're doing it" trap.  Whereas my comment is at a higher level --
there's a race where both exit conditions are true at the same time.
The rcuwait_wait_event() picked one option, but we would rather resolve
the race in the opposite direction.

> And:
> 
> 	/* Shouldn't be possible - VMA entirely detached, so treat it as such. */
> 
> Before err = 0?

Again though, saying it's "not possible" relies on knowing all the
callers of this function behave a particular way, and there's no
guarantee they'll continue to do so.


