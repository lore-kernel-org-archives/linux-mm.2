Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD196CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 443186B0096; Mon, 25 May 2026 13:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F3E06B009D; Mon, 25 May 2026 13:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337786B0096; Mon, 25 May 2026 13:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E4056B0096
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:12:08 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E3F97140181
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:12:07 +0000 (UTC)
X-FDA: 84806585094.21.F185764
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 31C12A0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:12:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=sbc0u1k4;
	spf=none (imf15.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779729126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DOIDEXr4JcbyQnXt3Wm5hMkj1JeWW7NL1U97wmwyhQ0=;
	b=vlyq8TnSYO+HKMeTyxa4MtEb9y5eBtCbQIT/eghp7tNydH2itTf79RsummXVZt+xj4LHmP
	SxKP1HJIHFrTwYZV9acPWme960yRFhuPINxqKW6XFiX1MAPKyKgzVMy9zoz3dO1O5rdVEg
	y6HTbsbcSsgJpd3MK0nlIt0ZngUBaZA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=sbc0u1k4;
	spf=none (imf15.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779729126; a=rsa-sha256;
	cv=none;
	b=8Lw46tobOSognn5FwIu8QHI1kyZeE0moeZkk9zzFjnEJSBa8jmxagbgwlltXvQ9BYfM0rq
	VejB7ydpJYHapzCV8dkaEgVi2/6CvzIiYZD7tkqTfqVYmjjRD0Oh+MraamZ3+eCRAJcLHU
	xT/a0ovOzU41RWnxWkoeAArpeHv9PDo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DOIDEXr4JcbyQnXt3Wm5hMkj1JeWW7NL1U97wmwyhQ0=; b=sbc0u1k4SAsY4qA3OoiubEAY4e
	Vnf+ICm4qBDKT1Lg/iz67tKdcXKgy90aupU3k+388rnJqlJn4NFLAZOA9msInN854g3Cz3RvPKtkl
	mYCA3PnhMX1jsqqwx6VTyI0cTHB3YUpbK2u6MoJ6iM2NHf0VkermYPnwKJp2J1OmsiYpW3wg3siQJ
	BD3k21r93qQz21HFjE1whp1fpomSAXZ9BBrpi5wbThFAyvxphYqM1qsCz4S9DFLQv5/Vfn3fiAUb3
	nKABUvBDmvtUSEwhhU6j4i7KDZl8PyQ2ABs2HbSzhz5c3h3oq2dQRe/Mw0afBlMMr5N5M9G9lZTNj
	FciSjRjw==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRYqQ-000000006hJ-3A9r;
	Mon, 25 May 2026 17:12:02 +0000
Date: Mon, 25 May 2026 13:12:01 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Carlier <devnexen@gmail.com>, 
	Heechan Kang <gganji11@naver.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <z6t4kefzgrdiu4zurxt63f3qdyjbjsvgyjnpxjkufj546huf2s@hq6xghp5w4ns>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
 <ag3BNLU1b6p9u_6K@kernel.org>
 <d48f558c-1bed-44d5-bbf6-34782ebf18f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d48f558c-1bed-44d5-bbf6-34782ebf18f2@kernel.org>
X-Rspamd-Queue-Id: 31C12A0005
X-Stat-Signature: bjypxtn5ifcdfc57tobus7yc5b5qp3sd
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779729125-532979
X-HE-Meta: U2FsdGVkX1/gfvYQ0BFCEoBqbk55viZMVJ15oMeWSFLXPv3ISZpsdFEddsy2i8h9aFHCI1IHN6yAKfk99+IMnE1HTd3pD7Fzz1v5GeMfCCzjC+1r8dZogG+7b3mWK0vMufvkIhgymvInzffSxco+/V/mwbYWbw9opQYSlpSeFF4pbdZUmkqpDqkKyxltJKbM+PMyMi3ZSTNVsevcyDPEdug/3CAdbiu+BiEyQIkkshoCgPz4OAXv9uKaFzVOz8gFWwZmBs2ToASTg+ajkOmzCAdjTdhoo0CANND8FMHJJuAia9wYS+48R6Dl6OIOA9lJiWq8pXtRSC+OhsLIhN6tlHVCTloW2yc1GvWPx3vmv+7j0Xb6AmIq4Gjcs1/gx/koZz4K2InZfUG2avj9z+ZodpCzar+yMKq8DYrSRUQ6Ep6fDrp11HDRo11VwZtUyAfizaazA+6s0TnEUEc1O6OeEURkIM8fVIMsDYrlGLKTdCYFGye/+C7VJUxoK5pcTHS14UEkabi/9QeYBwsIAU6LL0DvGKDPZySqCdzxTaLv8Gh8NQ2g/dBYD5jt/8r1gBW9lfczDg1qnx1X89YYoMXyJICQPT0mRhYKoKcBAO7DPdj/olum3mRxGWBdZf68Cbiv3DGpPdg+Z+BlvFIwynO6jUIHmgMU5V1eXFdyiBpOjU5SFHRunoPpoN6rPpA0NrXnGJZfNkSyKeSDCZbHqPQ0Wre8m3KPn+PASMnoOKS7gHkg0oIOHDxzFfTJe1eByGCjoHv5LEEMY3GFMzoY1Yua//qUYj5t6vcdduutayw+UHLiD6NhNeTSQ+Nt9cjK015tArmvsIZ/S/jWj/wdunmluQYIWHV9SGdWLK4/o8+iyNxdc+pbMY2MOhGIftD4TplMzVXTw5u9WfrXVff6r21eYfXt2LeVZivWYuGbFoFkTQMcW1T5nVLG0Nq0rE0ACIz+3Tn82LoUfXtBU5uMz2q
 Nxdthqfs
 AikmgYoTfkLGkxIaTEfWbEvofU5yvt179qQdll/s44h0xCKzyUq89NWV1aOhLKXkQoeUiGIx41co0GG1K9sVqTvbgyZ6MIzFu8zEDfcUsmTjra6eeTvPhSGz0Th5ye0LAnYXaAk+bCZImU8ZO82hTcqb0JXLwLX1zUYNITrGMf48C+oFTrzzEsYfpvRZ7M7cCQ1aaSn2wuImGz7HtvN+iNDa3O5Jaaf++WypcXE4IngFvNvW+8h1TaCiF4TxU+BSoF3l8a5OyhsE1Rm3D2dH+hWiRzesxTBqrrTWUTB6lL8lrPafWdrfYb6MFtvieeEBWt5cizIR0mQW7itI03dHd2ZmhY7+qCqrjLfM5VhXj8ILOLYBLiWGUFr/TJQsvjxY9oWRN1Jm7A223pDr1kwdWtgY3tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/20 04:38PM, David Hildenbrand (Arm) wrote:
> On 5/20/26 16:12, Mike Rapoport wrote:
> > On Wed, May 20, 2026 at 03:48:02PM +0200, David Hildenbrand (Arm) wrote:
> >> On 5/20/26 14:53, Mike Rapoport wrote:
> >>>
> >>> Do you mean per-VMA?
> >>> Per-MM counter would capture unrelated changes, e.g. an masvise() for
> >>> unrelated range.
> >>
> >> I was thinking about a per-MM thing for simplicity. If there were any changes,
> >> we'd retry (-EAGAIN).
> >>
> >> IOW, something like &mm->mm_lock_seq, which we have for per-vma locks already.
> >>
> >> Not sure if unrelated changes would really be a problem in practice (another
> >> thread gabbing the mmap_lock in write mode until we serviced the fault).
> > 
> > Let me reiterate:
> > 
> > A thread doing UFFDIO_COPY releases the VMA in mfill_copy_folio_retry(),
> > re-gets the VMA and checks if the per-MM counter stayed the same.
> > 
> > If another thread makes any change to VMA while mfill_copy_folio_retry()
> > waits to re-get the VMA, the counter would be incremented by another
> > thread. mfill_copy_folio_retry() will see the change after mfill_get_vma()
> > and will bail out with -EAGAIN.
> > 
> 
> Yeah.

This isn't bulletproof anyways.  The sequence count can wrap.  So, if
someone can replace the vma then cause the sequence counter wrap, then
you can be fooled into thinking it's okay (we had this problem years ago
with the vmacache using a 32 bit counter, iirc).

> 
> > So if another thread does, e.g. MADV_DONTFORK on completely unrelated VMA,
> > mfill_copy_folio_retry() will return -EAGAIN and I'm not sure we'll not
> > break the existing userspace by this.
> 
> Ah, you mean that -EAGAIN would not be handled by user space already even though
> documented in the man page ... because it relies on -EAGAIN not happening in
> specific situations (i.e., copying a single page).
> 
> That's very likely true and we'd have to retry internally, which makes it more
> complicated indeed.
> 
> -- 
> Cheers,
> 
> David

