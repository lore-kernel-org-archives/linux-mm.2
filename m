Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD51C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECFB86B008C; Tue, 28 Jul 2026 11:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E801F6B0093; Tue, 28 Jul 2026 11:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96B76B0095; Tue, 28 Jul 2026 11:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B55336B008C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:01:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 368B080400
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:01:38 +0000 (UTC)
X-FDA: 85038499476.21.ED4044B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id B49001C0006
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:01:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="sMNki/i/";
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785250895;
	b=6rrNY1CdEGOrEV3MOKgn11vebMES5TQjGnACifXDgbS3TIQPiTqAW/nUNVwl+ly/XgabJW
	1TQfGLRlfX4RCeco69Wcelgc2QoBFQ2ha/ZUPxquVNOXJyyToikk9OZNI/zHCwEY15bBeZ
	7ieQWYGhSjLH2aPHVoqCgSF+X6E5zfg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="sMNki/i/";
	spf=pass (imf18.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785250895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1K0D4ZSgD2q3ahJtEpB5vFDqIt7gcOZKTtXOge/lvM=;
	b=j7J8rY5Qty84VD4xBizO5Il9wIvIkZNhJ0X1Th9VvTb52aKGE2Zi/kzpnh0vWaVkStQIIt
	5mXH7E6TlxWS3aXbUYUVg76P40vkIUsKi8XX5yS8VPu+zqlpwWfERIni7KZvOQIIgEVaHA
	G2uOt0iIPerqln5NLvJkWITa4fC5Jo4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=r1K0D4ZSgD2q3ahJtEpB5vFDqIt7gcOZKTtXOge/lvM=; b=sMNki/i/hYMtTFJnfP3WoUISe1
	J+1P1dHzs7xzYXowAl6xxBcQrK72Cwty9oM2zO4NwwTx3UBZhxuQ4WNMhmMrqhxTnVyC8rVU0QMxk
	y4l/2xEIdgaitprmBest0tDC8bLHOuFBSeNT7KLjgh8jvTQo/ck6XpMBg2nHBD0I0QASfVIMIQz/Z
	R8fzqOZ+NpKRa8jvkVqS4OeNWk/rwHU2jzssTHn7QDrExZhI4eJGXbRiw4MzGaiyDWrkJzefhb9vu
	gcdTUO8MaC9QIiP4HDbFy7fAHqZoh8+/vDHMXlzaoYpWIgCCdXMimSOiwDTzueDzoIsAsclYyoPBO
	e6jd75zA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wojJ8-0000000DW4s-3IaE;
	Tue, 28 Jul 2026 15:01:26 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 5459C3004AB; Tue, 28 Jul 2026 17:01:26 +0200 (CEST)
Date: Tue, 28 Jul 2026 17:01:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <20260728150126.GC921102@noisy.programming.kicks-ass.net>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
 <20260728145528.GI651302@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728145528.GI651302@noisy.programming.kicks-ass.net>
X-Stat-Signature: q7edxor4stk9me5kfr7wxe99fczufrdj
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B49001C0006
X-Rspam-User: 
X-HE-Tag: 1785250895-924253
X-HE-Meta: U2FsdGVkX1+C494vg6h32GM8egHsD/A0fBiuAU1/SepXsZtbrwFGU2Ug+rOmyAzUon1tgLrxGJ2LOGzalAG3DvQbGnkpCo7gGxkCsdxiY9bAIcL1p/CEyCPLRq2GRErioAKahw+ZKW/D5HRPRjRqxIJ2hA3Bd2lyA/uKlE+mhsE806Vmt3WXfVIUxcevXNA1+j9fd2IT7r1S924GSkwGmSQn1Xk17neXqFkiEOTPP3a0DctSqcmUN3YTfeUlm8d3sCln0G9E6eM767bfz6E0bubOY3KyqxPbhEv8jRmlR2VgQWciu92xLN0lqpq5xyyq7h1wJgU8OUN/nn/PoaZoW2J3DMj0+eO8tQeu6xOMLjn/DYzUfKPIkCgpCz33XJNeYB+y/h7KU+kBE8Z4v4dMPxfIdTcnqoySJKBLYWN769EVfIuaQR7Jeq4ADYbtnAl5uiS7uZR6/rW5LRQ4+CzwI1VoPKEWGxbyE7I/gNPjck0ZFRvQrkHTidEF9teIO9viDU26e+fRSpTM51mJzyqmmZY1XyXQTDWfTMfRaxce0QbjW6JvQ/xUOK1clfuh2lWvJ0TH3gmHGz1uQNh7yKS6cAPUUvq+W4XIJQFW8xODm2iDP2rXmZsdAvZkIuOHFBbaxTMeXlLD1MurarT+AUQKhT8+76f25MxEoodA0LzKyh3T2KFzmFnOng1+6qeZjeE6lVvluJT5Lanw4QU2KzNB+HnPcgJrT8nsc7NF9PykFQD4rONh2cZm68sgd4oPgYdC9fK0d9zuJGMFcJ8VqXG1oFPqV70GrvQzFdX4jKPX0v3HBM3GqyNhEkURPkZsH2CxHFftL2U6VrbHMaKrcQL5nUx2UREjDecBgzBVBVJysfiDKNsrPKWDtSzR8oZmLvtA6j4TDxUpeJMAc+4Dbx+V1BYPFzDDfCQKcAFU6+em76GVzJ7lpX/nIIU2owU6WtVzxVE6dVJf2rGgcZdG6jG
 KANbqYrm
 3dkvqUG90uy8xqMsb47Xy2+GtxjW46tEKCp2JnEv5vaIMzc1JWu5E9cAqQZZD6rOsNGTttUgbnh9jOiOlTtytHEfPtrmxYD/3Odg2Sq/zQMaJ2vpHUgs+Yl4fGQox/C59y3Xr3etiR4zvpDRwibn7t97xmdO5DbhNojFd3BZoMT27Ihai9JWt4czUOzTTlFixE0FM4fSPjEePLqnD4EJjB+gG6ejwS/T8Kh6510bf8REG+HX3cw2IzUDt34aac7Ruc99b/S8lAwOb27CNe7m7PcoX/RlYoqDceVZvzHcseou3eTWV0Hd/7g0TKl9J7YFseNBk/5E137sNwNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:55:28PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> > On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > > exception. Is that not better?
> > > > 
> > > > As I'm scanning through email this morning, there's another issue that
> > > > popped up with that patch. It's causing hangs on boot.
> > > > 
> > > > It's looking like debug pagealloc not taking the lock is actually
> > > > functional, not an optimization. Although, I hesitate to say
> > > > "functional" and would prefer to use much less nice words to describe it.
> > > 
> > > Yeah, lets figure out why that is before we retain this wart ;-)
> > 
> > As Lorenzo said:
> > 
> >   __kernel_map_pages() can be called from irq context:
> > 
> >   < GFP_ATOMIC context >
> >   kfree() or whatever
> >   -> ...
> >   -> __free_pages_prepare()
> >   -> debug_pagealloc_unmap_pages()
> >   -> __kernel_map_pages()
> >   -> __change_page_attr_set_clr()
> >   -> cpa_lock
> > 
> 
> The TLBI hack in __kernel_map_pages() makes me wonder how any of this is
> correct to begin with. That comment isn't helping.
> 

Also, the 'atomic context' usage hereabout seems confused. In particular
the issue is with IRQ-disabled context, they are not the same thing.

This confusion is seen in the existing comments in __set_pages_{p,np}()
and in this patch series. It needs fixing.

