Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0B2E9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 15:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A026B0005; Thu, 19 Feb 2026 10:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07466B0089; Thu, 19 Feb 2026 10:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A13C26B008A; Thu, 19 Feb 2026 10:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89F396B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 10:20:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A1AC8C0A4
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:20:56 +0000 (UTC)
X-FDA: 84461568912.18.4F283C8
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf13.hostedemail.com (Postfix) with ESMTP id 73E3820015
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 15:20:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=f+zedE0z;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771514454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJWQHabnh6u189YCJEq42YLB+uPwZUwkYJ7q/vk+sIY=;
	b=zVtjCiPywFmg44m44yWtBkKvfbmvcQ+X1eTAUdNu3cbCPi7Tc36DNQeLSb9BFmk2SuItiW
	qNrqu7O0daMHTuVQU06HkvIwVUxbVM0ftPucuRwzDjzFJ6VKOHg5A76lPVixN3pTtU+cIT
	srsSYmyxQYLDkFCyJBY2GtzsphSNR1Q=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=f+zedE0z;
	spf=none (imf13.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771514454; a=rsa-sha256;
	cv=none;
	b=xxqUkA1Yqa6+eYxDRca9Krw+QyS3C/fAWwWPuFkN9zgSfEMG6ePeXkRasZiWdojR2qr0lO
	jPJBMIwx8APvotZvnAfCTjeuWjbXb3Xq1mtnkviYIiO1YlE6mZAOFAVPuwmZEaEPSEY04t
	bGruL/n/pZnhmbVH3GwwKnbJ3slR8sI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GJWQHabnh6u189YCJEq42YLB+uPwZUwkYJ7q/vk+sIY=; b=f+zedE0zzjUGv9Mglc5T/eVrMT
	7JM6mK0oAgYogGk3XbEpjFlHTEtueSGdnuIv79gW/a+c0XyfzDZjQjWb8JvcvtGRuAzW59Di6RGNG
	2evcxWw0L196DIh+jk3COnP7ev4Xaw14jXdjdIcR8CnDiSgY876fTHVEVHg1Buz13/hxSNLOGAoXr
	NzDl59gsBj6D4fiKzz8A7jbHL5wYPMX0K2iW5fAzDYmr3YooahPaD/oFPfjXZw1AVgVLanv3ZkFYp
	mRH0GdRHsdzIF0GHOWGVlk6g4+FO31HMwxBzvxGPPyO738RcAH2bajKX7qq4lv5p3zt+G3kp90IPP
	CvXz6LUg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vt5pd-00000001RvQ-3eH1;
	Thu, 19 Feb 2026 15:20:47 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 10EB930075B; Thu, 19 Feb 2026 16:20:45 +0100 (CET)
Date: Thu, 19 Feb 2026 16:20:45 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [LSF/MM/BPF TOPIC] 64k (or 16k) base page size on x86
Message-ID: <20260219152045.GR1395416@noisy.programming.kicks-ass.net>
References: <aZcmlIF4bmG0twkp@thinkstation>
 <20260219151729.GK1282955@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219151729.GK1282955@noisy.programming.kicks-ass.net>
X-Stat-Signature: xoattf4en3ed4jsqo6b4ohb4i5spyjjs
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 73E3820015
X-HE-Tag: 1771514454-590882
X-HE-Meta: U2FsdGVkX1+1GNNWbrghV3Y7ClWX8R23QrolNmVEfBmU8IsS1gcVHOv6Z69HqygKGcTchTzfWl/9wJ9tY/ZAYh4texrN8fVFq+BPC/t10z9x5aFArtVHDKllO2w1Bwi9li2JlrYX0qxXr3jubP7K/eOJePxkzEKmbgBo9zql2sPxCZhnZUS6r48xBdHrInmdKELi6mbQJJi5d2cHruZ0QJgfZCHfC1xI2SZOoU8/nlynI2w4vbqgilCTqRZdXO0pJ52lNRwTntv/LOrJ4U1Z+5l2Vutz0KfK5pp+ugcYjq/O1FWhxO9fcf6+QqivbSi3ZsAHgnsJVIlS97X3Lc4c6h+l9oLBci4KBTVNLyTorxpJHIEwi34qCH0JCmuD/ji5tJ/7LCqRrD4I1AFq/sElG0IB3ggQaOxKcU3j8qLVjInzGLttvA9TosM0LukirWLX5kYmHmvzEIVolEOaNdX7LB8gc2H9L9pzS0Ghx1L2g8JgUZyE+PvBMV9Jd/Nn8nVJBdheYo4Oqoniz0RPbFalpFzdLzQi6icWDRehJNClDIqQdhoguumdxg+qqEyw8MG+95wRak/Tqi7axEMCyBg0BWA47oWzWskNGnLCs70C2dq7z9oi+zEdzhFhWrlFkvNBFRhscW9iiye8v2ZT6KVpGQuH1ViPIJl4+ZGwLmw7owS5jb7blzMJ/2vvuyuuTr/8grnIyLMes2HRS/YUf/nWmN6+uv5G99N13RH+OmfFZPmimXZ+U0QIe/4Ab0V9WbIG/3xSoOq/UU0kGB0BZUcZz7n1xgXFN+6CUhPWqwoIbGXpBSukWq0F3unc3Bw72dx8aJjesApQYApMRF4H0osIYwVF0ferSnWWJ2ioCasf0QIUS973ZoWGXihG0US4CzGqA9Jn5mBk7SJ0pY9OdTdCLLTHpJGQStGu0jVk0qw2hXOyYknEwStZD3a+LEfCP+5f/rukYM/axXak0xc0rkL
 Iy3kfhuS
 eBpdY2P1MrgnNDIVfYQXnkLRg/dscF1rQwBRL7vFlzQsj0kR6J5lVgadpKRwyetAMhr+OLRN8Q/oUINt33biu7SLpZvBIgpX+dsX9xTt2UTCFPURafolFvdBBzUjJclQj5ShhxrragiRS2so1UNclR+JdEwP1w+ehNCGKQvRk5Qa6xak392GtIriW6q5USQkr/HNBOTiILg9aAU96zu5hx09Y6/ePLxl8gcDVyP8bqpHmYiHaZhQy53egh8hjOFi9dSRE4rIjlL1HfoY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 04:17:29PM +0100, Peter Zijlstra wrote:
> On Thu, Feb 19, 2026 at 03:08:51PM +0000, Kiryl Shutsemau wrote:
> > No, there's no new hardware (that I know of). I want to explore what page size
> > means.
> > 
> > The kernel uses the same value - PAGE_SIZE - for two things:
> > 
> >   - the order-0 buddy allocation size;
> > 
> >   - the granularity of virtual address space mapping;
> > 
> > I think we can benefit from separating these two meanings and allowing
> > order-0 allocations to be larger than the virtual address space covered by a
> > PTE entry.
> 
> Didn't AA do this a decade ago or somesuch?

  https://lwn.net/Articles/240914/

