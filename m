Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B05DC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:33:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5E946B0096; Tue, 28 Jul 2026 11:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0F396B0098; Tue, 28 Jul 2026 11:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD72E6B0099; Tue, 28 Jul 2026 11:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 923536B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:33:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2231E1202AD
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:33:51 +0000 (UTC)
X-FDA: 85038580662.26.1A29899
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0218E1A0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:33:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZR7XTAvt;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785252829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MtI8BjVNz9fvIWLLabGAXhTyjAUw+ny5VCHWBMfAP7U=;
	b=foZfFIlEPmB+meBC4QVdwVa6T1LpFzs/AuIpirHJj5AhycAgNi45FBeUJ9i6sKismanOdV
	fA8cTQ3qGZtp1LkT33ErMN9qjaeYGUHGsEUP7TQ8xQgW5hG9HlO5gSW+bf7Q2OI41xBX+D
	0vOBnY1UM5yBJ0C8CBB2w7QdbBrC27I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ZR7XTAvt;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785252829;
	b=Z3MefpK5TBCxPTj8XByfUSMKf5iHS9ARlwRG2US0Tx6YVjK1eE7b+luDYFANL2tDARrqCA
	D2pBgHe4yxix5HzBAuaHdW5/jKn4yKf45dvUKhgR1phbW8VJ94dP/5kJFa/RAQG81ViAwM
	LDO82mffdTAS8PqucXYtWsCttecTBCA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MtI8BjVNz9fvIWLLabGAXhTyjAUw+ny5VCHWBMfAP7U=; b=ZR7XTAvtNIKJro36JxE/8l5Q/W
	ReI+Qiwt7PsTt2gjKRFN+94VxnT4QcNzzua3897tbbBK2zoDqEElZSnqusWc70POKhKhprFcGTNel
	J2sUYUxGJAlwLorD5mn+tYu+56aQUqbZpxu3dhCYYZ8pNYNCHs42fILaFYFNMHG8B71NmI7hFnLUd
	3FMIbQlnGUw6or7BLKSbHdVRtXp2cacvktYZFtfsB6ZLR6NRE/Ww4KeGKcd3/39EpDCsALZVL8P4W
	03P8v3ZO3dhnkJHv1fe24ssYJX/CLUcU6wNX4smqEXCVYrj7WjL9XaT5srV1LsLj+wgcalmaoKbbM
	ZA0j0ndQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wojoM-0000000DaEn-0Vwv;
	Tue, 28 Jul 2026 15:33:42 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id A12183004AB; Tue, 28 Jul 2026 17:33:41 +0200 (CEST)
Date: Tue, 28 Jul 2026 17:33:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
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
Message-ID: <20260728153341.GY751831@noisy.programming.kicks-ass.net>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
 <20260728142108.GW751831@noisy.programming.kicks-ass.net>
 <adfffb36-9943-4af7-a0ee-0e762e47fa11@intel.com>
 <20260728143135.GG651302@noisy.programming.kicks-ass.net>
 <amjAxhL-IeeJITEv@kernel.org>
 <20260728145528.GI651302@noisy.programming.kicks-ass.net>
 <20260728150126.GC921102@noisy.programming.kicks-ass.net>
 <amjHQtTRKKkxdaWC@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amjHQtTRKKkxdaWC@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0218E1A0004
X-Stat-Signature: xxhq7yp8uy5puyfui4uhuxmm5fywkaxk
X-HE-Tag: 1785252828-292946
X-HE-Meta: U2FsdGVkX18p970mj0aZptJ0VhLl9QjlMq85CEGlyzKyjKiuwIFE/39+FOXPA1PUq+p22cLNhcFPpXGEzjJBtZNYUl6sBlvvrQsQIDrUX73SwNEL8yEr9dTTtyuJi4wQ2sfu90VJklK5gyHYVVj26jHOzNvWUnYn5DuF5OXiy9Mm78S5ZTA2IUTZbwe1wjOJjVPH+d6gVmeJ+M8Ht1k1lplb4GympaTitDBZd0zm0ZiBI5iBsP/MDv9MJNyZKcfzpWlfgGoBtcd7eN7usGHC4WLrG0WT1BPg+VwLspyoCE60W+oqfIxv1+x5P9WwHDBIIEVGoR9WIGRkZz9MB76vm0/WMpttqL7Ew5CONjXhxU2PzYQUWsBbSXluogGF8qczzgddknJTa9RXYsCOhw3YaigEXS4qrgM4QW+IURw7yu3tZn4W/J1AyXT6RNDMf+a+SfcVvBzlgAZD+F7XaPnJvgYhZ5BRkHi/zGBRHzkwfwLNTBuTYWdzWm6c6E7xZBYgRkxBbhM8j+0bUOGgnTkFysuS1Njqsl4QCOQwR85cmWP1fHcTKnLW+/S12/GNbDdz8ylKXE9u0NSsC0OxGd5duSwW8aHDluTj4ItQfmXvZwvWOND1YsFy0+DNaj9s8d39h7Iq2VkCg8Xwu4dk4NWg399+MhpXZhVuAizXx+rsHsu6Wo/eFHErlDcaNp/hk48St6C3BM20cWOAoAFcXd8f++iZvXG4qWlwRGE1qT3Wf/zdqWMcvqHhWB3yPjJ9yHOr3WmtC3e/5kL+bowcooycaTIK4DcFFvTbX4mbrhWYCt+lDPX/i/XxmfXJqMAxWa/4cEF4AnV7wAQcQ+M6E847WWj5VrmX5bkjMgIrAe/wQC0lMOCi64vXJMqJZcaopBxXyqEeyFU+y6xx6Jva6bU4FcG/I+BVTbKoa4FtBO8gzDEf9cpywvXIIEKGLMbt7nb9z3CSzK2famg24tZ/2FT
 iZOMrVqz
 CMn8f2v1dVQckTLDekULYk3xT/bUBbLKAz6BEHzWxzkAuosaiOjaut6sCa0BCrDrNKGCmkPfXpLJR521zscPA81XWoYJ63MxsA6FawCMLItmlYcGr9aue5rU1DYR8cwy017mBQ7gb5zxVIESXqLU2zrNpTpsubAKLlFHVUTeo84Ewe3g8eJJlbg8uB3L9VusmRGGC8a3KGHiKRQT1LugN37bDPBqYA55zsweoWvt24rJkPGPEWni41Kc0DWq5Mf5h0Sg0xUt2fBujoZj3ROLTSwDFlCYlpmK5cAfgqSsL5UmXTdt6n/eRHu/SdjNPqamETxgiRylxj6B9YU0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:20:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Tue, Jul 28, 2026 at 05:01:26PM +0200, Peter Zijlstra wrote:
> > On Tue, Jul 28, 2026 at 04:55:28PM +0200, Peter Zijlstra wrote:
> > > On Tue, Jul 28, 2026 at 05:46:30PM +0300, Mike Rapoport wrote:
> > > > On Tue, Jul 28, 2026 at 04:31:35PM +0200, Peter Zijlstra wrote:
> > > > > On Tue, Jul 28, 2026 at 07:30:27AM -0700, Dave Hansen wrote:
> > > > > > On 7/28/26 07:21, Peter Zijlstra wrote:
> > > > > > > There was already a patch merged that removed the shole debug_pagealloc
> > > > > > > exception. Is that not better?
> > > > > >
> > > > > > As I'm scanning through email this morning, there's another issue that
> > > > > > popped up with that patch. It's causing hangs on boot.
> > > > > >
> > > > > > It's looking like debug pagealloc not taking the lock is actually
> > > > > > functional, not an optimization. Although, I hesitate to say
> > > > > > "functional" and would prefer to use much less nice words to describe it.
> > > > >
> > > > > Yeah, lets figure out why that is before we retain this wart ;-)
> > > >
> > > > As Lorenzo said:
> > > >
> > > >   __kernel_map_pages() can be called from irq context:
> > > >
> > > >   < GFP_ATOMIC context >
> > > >   kfree() or whatever
> > > >   -> ...
> > > >   -> __free_pages_prepare()
> > > >   -> debug_pagealloc_unmap_pages()
> > > >   -> __kernel_map_pages()
> > > >   -> __change_page_attr_set_clr()
> > > >   -> cpa_lock
> > > >
> > >
> > > The TLBI hack in __kernel_map_pages() makes me wonder how any of this is
> > > correct to begin with. That comment isn't helping.
> > >
> >
> > Also, the 'atomic context' usage hereabout seems confused. In particular
> > the issue is with IRQ-disabled context, they are not the same thing.
> 
> I mean yeah the IRQs being off is the issue with holding the lock over an IPI, a
> softirq allocating GFP_ATOMIC won't be a problem for that, but I think all the
> conclusions are still the same.

preempt_disable() is an 'atomic context', but does not present the
problem.

Anyway, yes not saying the conclusions are wrong, just that the wording
is confusing at heck.

